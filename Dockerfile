FROM jupyter/datascience-notebook

# Required for Geopandas
USER root
RUN apt-get update && apt-get install -y libgeos-dev ssh
USER $NB_USER

RUN conda update --all -y

ADD ipython_config.py /etc/ipython/
ADD jupyter_notebook_config.py /etc/jupyter/

COPY jupyter-theme/* /home/jovyan/.jupyter/custom/
COPY jupyter-theme/fonts/* /home/jovyan/.jupyter/custom/fonts/

RUN pip install jgscm pyarrow fastparquet geopandas

USER root
RUN mkdir /home/jovyan/.ssh
COPY id_rsa* /home/jovyan/.ssh/
RUN chown -R $NB_USER /home/jovyan/.ssh
RUN chmod 600 /home/jovyan/.ssh/id_rsa
USER $NB_USER

RUN ssh-keyscan -t rsa github.com 2>&1 >> /home/jovyan/.ssh/known_hosts
RUN pip install git+ssh://git@github.com/quartictech/taijitu.git

CMD jupyter notebook --debug --NotebookApp.base_url=/analysis --NotebookApp.token=''
