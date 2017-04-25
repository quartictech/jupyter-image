import os

if "JUPYTER_GOOGLE_CLOUD_BUCKET" in os.environ:
    c.NotebookApp.contents_manager_class = 'jgscm.GoogleStorageContentManager'
    c.GoogleStorageContentManager.default_path = os.environ["JUPYTER_GOOGLE_CLOUD_BUCKET"]
