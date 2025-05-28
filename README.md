# Jupyter-Code-Container: Dockerized Dev Environment

This repository contains a single Docker image that bundles together:

* **code-server** (VS Code in the browser) with pre-installed extensions
* **JupyterLab** (via Miniforge/Conda) for Python notebooks
* **Cloudflare Tunnel** (ephemeral, token-based) to expose both services securely through your domain
* A shared `/workspace` volume for all your code and data

---

## Features

* **Unified environment**: one container runs both code-server and JupyterLab
* **Cloudflare Tunnel**: no need to open ports on your host or worry about firewalls
* **Auto-installed extensions**: Python, Jupyter, GitLens, GitHub Copilot
* **Conda-managed JupyterLab**: isolated environment without pip system conflicts
* **Mount your code**: mount a local folder to `/workspace` for seamless editing and notebooks
* **Automatic VS Code ↔ Jupyter integration**: VS Code’s Jupyter extension is preconfigured to the local kernel

---

## Repository Structure

```text
├── Dockerfile
├── scripts/
│   └── entrypoint.sh
├── config/
│   ├── code-server-config.yaml
│   └── jupyter_notebook_config.py
└── README.md
```

* `Dockerfile`: builds the image with all components
* `scripts/entrypoint.sh`: runtime script that launches cloudflared, JupyterLab, and code-server
* `config/code-server-config.yaml`: code-server settings (bind address, auth)
* `config/jupyter_notebook_config.py`: JupyterLab settings (token, notebook dir)

---

## Prerequisites

* Docker installed on your host
* A Cloudflare Zero Trust Tunnel setup, with a valid **Tunnel Token**
* A domain and DNS configured in Cloudflare with ingress rules for your tunnel

---

## Build the Image

From the repository root, run:

```bash
docker build -t chaichy/jupyter-code-container:latest .
```

---

## Run the Container

Use the following command (adjust paths and secrets):

```bash
docker run -d \
  --name dev-env \
  -v /absolute/path/to/workspace:/workspace \
  -e CF_TUNNEL_TOKEN="<your-cloudflared-token>" \
  -e JUPYTER_TOKEN="<your-jupyter-token>" \
  -e PASSWORD="<your-vscode-password>" \
  youruser/dev-tunnel:latest
```

* `-v /.../workspace:/workspace` mounts your local work directory
* `CF_TUNNEL_TOKEN`: your Cloudflare tunnel token (ephemeral auth)
* `JUPYTER_TOKEN`: password token for JupyterLab
* `PASSWORD`: password for code-server

### Access

* **VS Code** (browser): `https://code.YOUR_DOMAIN.com`
* **JupyterLab** (browser): `https://jupyter.YOUR_DOMAIN.com`

(The hostname routing is handled by your Cloudflare Tunnel ingress configuration.)

---

## Environment Variables

| Variable          | Description                                                           |
| ----------------- | --------------------------------------------------------------------- |
| `CF_TUNNEL_TOKEN` | Cloudflare Tunnel token for ephemeral tunnels                         |
| `JUPYTER_TOKEN`   | Token to secure JupyterLab                                            |
| `PASSWORD`        | Password to secure code-server                                        |
| `TARGETARCH`      | (Optional) Docker build arg for architecture (e.g., `amd64`, `arm64`) |

---

## VS Code Extensions Installed

* **ms-python.python**
* **ms-toolsai.jupyter**

