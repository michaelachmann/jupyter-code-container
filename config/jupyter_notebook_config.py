import os
c = get_config()
c.NotebookApp.ip           = "0.0.0.0"
c.NotebookApp.port         = 8888
c.NotebookApp.token        = os.environ.get("JUPYTER_TOKEN","")
c.NotebookApp.allow_origin = "*"
c.NotebookApp.open_browser = False
c.NotebookApp.notebook_dir = "/workspace"