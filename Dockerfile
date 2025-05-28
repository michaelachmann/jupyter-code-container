FROM codercom/code-server:latest
ARG TARGETARCH
ENV TARGETARCH=amd64

USER root

# ────────────────────────────────────────────────────
# Install Python prerequisites, Miniforge, JupyterLab, and cloudflared
# ────────────────────────────────────────────────────
RUN apt-get update && \
    apt-get install -y python3 python3-venv curl git ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Miniforge (conda-forge) and JupyterLab for correct architecture
RUN ARCH="${TARGETARCH:-amd64}" && \
    if [ "$ARCH" = "amd64" ]; then INST="Miniforge3-Linux-x86_64.sh"; else INST="Miniforge3-Linux-aarch64.sh"; fi && \
    curl -L "https://github.com/conda-forge/miniforge/releases/latest/download/${INST}" \
        -o /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh && \
    /opt/conda/bin/conda install -y jupyterlab && \
    /opt/conda/bin/conda install -y \
        pandas \
        numpy \
        matplotlib \
        scikit-learn \
        tabulate \
        python-dotenv && \
    /opt/conda/bin/pip install \
        backoff \
        openai \
        wandb \
        krippendorff \
        label-studio-sdk \
        evaluate \
        seqeval && \
    /opt/conda/bin/conda clean -afy

# Add conda to PATH
ENV PATH="/opt/conda/bin:${PATH}"

# Fetch cloudflared static binary
RUN curl -L "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" \
       -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# ────────────────────────────────────────────────────
# Copy static configs & our entrypoint
# ────────────────────────────────────────────────────
COPY config/jupyter_notebook_config.py    /home/coder/.jupyter/jupyter_notebook_config.py
COPY config/code-server-config.yaml       /home/coder/.config/code-server/config.yaml
COPY scripts/entrypoint.sh                /usr/local/bin/entrypoint.sh


RUN chmod +x /usr/local/bin/entrypoint.sh \
 && chown -R coder:coder /home/coder

USER coder
RUN code-server --install-extension ms-python.python \
 && code-server --install-extension ms-toolsai.jupyter 

EXPOSE 8080 8888

USER coder
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]