FROM jupyter/scipy-notebook

USER root
RUN apt-get update && apt-get install -y libgeos-dev ssh curl
RUN echo "deb http://packages.cloud.google.com/apt gcsfuse-jessie main" | tee /etc/apt/sources.list.d/gcsfuse.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y gcsfuse
USER $NB_USER

RUN conda update --all -y

ADD ipython_config.py /etc/ipython/
ADD jupyter_notebook_config.py /etc/jupyter/

COPY jupyter-theme/* /home/jovyan/.jupyter/custom/
COPY jupyter-theme/fonts/* /home/jovyan/.jupyter/custom/fonts/

RUN pip install jgscm pyarrow fastparquet geopandas nltk tornado==4.4.1
RUN python  -m nltk.downloader stopwords

USER root
COPY bin/* /usr/bin
RUN mkdir /home/jovyan/.ssh
COPY id_rsa* /home/jovyan/.ssh/
RUN chown -R $NB_USER /home/jovyan/.ssh
RUN chmod 600 /home/jovyan/.ssh/id_rsa
USER $NB_USER

RUN ssh-keyscan -t rsa github.com 2>&1 >> /home/jovyan/.ssh/known_hosts
RUN shrubbery_update taijitu

CMD jupyter notebook --debug --NotebookApp.base_url=/analysis --NotebookApp.token=''
