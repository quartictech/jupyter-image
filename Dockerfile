FROM jupyter/minimal-notebook:628fbcb24afd

# jupyter stuff
USER root
# libav-tools for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends libav-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER
RUN conda install --quiet --yes \
    'nomkl' \
    'ipywidgets=6.0*' \
    'pandas=0.19*' \
    'numexpr=2.6*' \
    'matplotlib=2.0*' \
    'scipy=0.19*' \
    'seaborn=0.7*' \
    'scikit-learn=0.18*' \
    'scikit-image=0.12*' \
    'sympy=1.0*' \
    'cython=0.25*' \
    'patsy=0.4*' \
    'statsmodels=0.8*' \
    'cloudpickle=0.2*' \
    'dill=0.2*' \
    'numba=0.31*' \
    'bokeh=0.12*' \
    'sqlalchemy=1.1*' \
    'hdf5=1.8.17' \
    'h5py=2.6*' \
    'vincent=0.4.*' \
    'beautifulsoup4=4.5.*' \
    'xlrd'  && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

# Quartic stuff
USER root
RUN apt-get update \
 && apt-get install -y libgeos-dev ssh curl openssh-server libspatialindex-c3 \
 && apt-get clean \
 && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* \
 && mkdir /var/run/sshd

RUN echo "deb http://packages.cloud.google.com/apt gcsfuse-jessie main" | tee /etc/apt/sources.list.d/gcsfuse.list \
 && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && apt-get update\
 && apt-get install -y gcsfuse 

# setup ssh keys
RUN mkdir /home/jovyan/.ssh
COPY id_rsa* /home/jovyan/.ssh/ 
RUN chown -R $NB_USER /home/jovyan/.ssh\
  && chmod 600 /home/jovyan/.ssh/id_rsa\
  && ssh-keygen -A

# python level stuff
USER $NB_USER
RUN conda update --quiet --all -y \
  && conda install libspatialindex -y \
  && conda clean --all -y
RUN pip install jgscm pyarrow fastparquet geopandas rtree nltk tornado==4.4.1
RUN python  -m nltk.downloader stopwords

# add our jupyter customizations
COPY bin/* /usr/bin
ADD ipython_config.py /etc/ipython/
ADD jupyter_notebook_config.py /etc/jupyter/
COPY jupyter-theme/* /home/jovyan/.jupyter/custom/
COPY jupyter-theme/fonts/* /home/jovyan/.jupyter/custom/fonts/

# pre fill known_hosts
RUN ssh-keyscan -t rsa github.com 2>&1 >> /home/jovyan/.ssh/known_hosts

RUN shrubbery_update
USER root

CMD shrubbery_update \
  && start-notebook.sh --debug --ip='*' --NotebookApp.base_url=/analysis --NotebookApp.token=''
