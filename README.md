# Jupyter-Code-Container: Dockerized Dev Environment

[![Docker Pulls](https://img.shields.io/docker/pulls/chaichy/jupyter-code-container)](https://hub.docker.com/r/chaichy/jupyter-code-container)


> ⚠️ **This image is intended for CPU-based development environments. GPU/CUDA is not (yet) supported in this build.**

A single Docker image for remote Python development:  
VS Code (`code-server`) + JupyterLab + secure Cloudflare Tunnel, all set up and ready to go.

---

## 🚀 Quick Start

**Get up and running in just a few steps:**

```bash
# 1. Pull the image from Docker Hub
docker pull chaichy/jupyter-code-container:latest

# 2. Run the container (replace paths and secrets)
docker run -d \
  --name dev-env \
  -v /absolute/path/to/workspace:/workspace \
  -e CF_TUNNEL_TOKEN="<your-cloudflared-token>" \
  -e JUPYTER_TOKEN="<your-jupyter-token>" \
  -e PASSWORD="<your-vscode-password>" \
  chaichy/jupyter-code-container:latest
```

---

## 🌐 One-Click Deployment: RunPod

Want a full dev environment in the cloud in minutes?  
**[Deploy this stack directly on RunPod!](https://runpod.io/console/deploy?template=kj8bldufic&ref=7v5mhnoa)**

[Deploy to RunPod](https://runpod.io/console/deploy?template=kj8bldufic&ref=7v5mhnoa)

### RunPod Best Practices

- **This container is designed for CPU instances.**  
  If you select a GPU instance on RunPod, GPU acceleration will not be available out of the box.

- **Set your environment variables as secrets!**
    - `CF_TUNNEL_TOKEN`
    - `JUPYTER_TOKEN`
    - `PASSWORD`

- **Use Cloudflare Zero Trust**  
  Consider enabling [Cloudflare Zero Trust](https://developers.cloudflare.com/cloudflare-one/zero-trust/) for additional access control and logging. This lets you restrict access to your services based on identity, device posture, or other rules.

- **Mount your data**  
  You can attach a persistent volume to `/workspace` so your code and notebooks persist between sessions.

---

## ✨ Features

- **Unified environment**: One container, both code-server and JupyterLab.
- **Cloudflare Tunnel**: Secure access, no open ports needed ([Cloudflare Tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)).
- **Auto-installed VS Code Extensions**: Python, Jupyter.
- **Mount your code**: Mount a local folder to `/workspace` for editing and notebooks.
- **Pre-configured VS Code ↔ Jupyter integration**.

---

## 📦 Repository Structure

```text
├── Dockerfile
├── scripts/
│   └── entrypoint.sh
├── config/
│   ├── code-server-config.yaml
│   └── jupyter_notebook_config.py
└── README.md
```

---

## ⚙️ Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your host
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide/) setup, ideally combined with [Cloudflare Zero Trust](https://developers.cloudflare.com/cloudflare-one/zero-trust/) for access control
- A domain & DNS in Cloudflare with [ingress rules](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/routing-to-tunnel/) for your tunnel

---

## 🛠 Build the Image (optional)

```bash
git clone https://github.com/chaichy/jupyter-code-container.git
cd jupyter-code-container
docker build -t chaichy/jupyter-code-container:latest .
```

---

## 🖥 Run the Container

```bash
docker run -d \
  --name dev-env \
  -v /absolute/path/to/workspace:/workspace \
  -e CF_TUNNEL_TOKEN="<your-cloudflared-token>" \
  -e JUPYTER_TOKEN="<your-jupyter-token>" \
  -e PASSWORD="<your-vscode-password>" \
  chaichy/jupyter-code-container:latest
```

- `-v /.../workspace:/workspace`: mounts your local workspace
- `CF_TUNNEL_TOKEN`: [Get it here](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- `JUPYTER_TOKEN`: Password token for JupyterLab
- `PASSWORD`: Password for VS Code

Access your services:

- **VS Code**: `https://code.YOUR_DOMAIN.com`
- **JupyterLab**: `https://jupyter.YOUR_DOMAIN.com`

---

## ⚡️ Environment Variables

| Variable          | Description                                                           |
| ----------------- | --------------------------------------------------------------------- |
| `CF_TUNNEL_TOKEN` | Cloudflare Tunnel token ([setup guide](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)) |
| `JUPYTER_TOKEN`   | Token to secure JupyterLab                                            |
| `PASSWORD`        | Password to secure code-server                                        |
| `TARGETARCH`      | (Optional) Docker build arg for architecture (`amd64`, `arm64`)       |

---

## 🧩 VS Code Extensions Installed

- [MS Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [MS Jupyter](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter)


## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
