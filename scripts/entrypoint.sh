#!/usr/bin/env bash
set -e

# Validate required environment variables
if [ -z "${CF_TUNNEL_TOKEN:-}" ]; then
  echo "ERROR: CF_TUNNEL_TOKEN must be set."
  exit 1
fi

# Configure VS Code Jupyter extension to connect to local Jupyter
CONFIG_DIR=/home/coder/.config/code-server/User
mkdir -p "${CONFIG_DIR}"
cat > "${CONFIG_DIR}/settings.json" <<EOF
{
  "jupyter.jupyterServerURI": "http://localhost:8888/?token=${JUPYTER_TOKEN}",
  "jupyter.jupyterServerType": "local"
}
EOF
chown coder:coder "${CONFIG_DIR}/settings.json"

# Start ephemeral Cloudflare tunnel using token
cloudflared tunnel run --token "${CF_TUNNEL_TOKEN}" &

# Start JupyterLab
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token="${JUPYTER_TOKEN}" --NotebookApp.notebook_dir="/workspace" &

# Start code-server as the main process
exec code-server --config /home/coder/.config/code-server/config.yaml /workspace