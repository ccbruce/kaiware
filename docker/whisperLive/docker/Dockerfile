#FROM kingasiagroup/ai-base:1.0r6
FROM kingasiagroup/ai-base:1.0-gpu-r10
#gpu version#FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04 

### setup jupyter
RUN pip install jupyter \
        ansible-kernel \
        bash_kernel \
        bioblend galaxy-ie-helpers \
        biopython \
        cloudpickle \
        cython \
        dill \
        # octave_kernel \
        # Scala
        # spylon-kernel \
        # Java
        # scijava-jupyter-kernel \
        jupytext \
        jupyterlab-geojson \
        jupyterlab-katex \
        jupyterlab-fasta \
        mamba \
        patsy \
        pyodbc \
        jupyterlab_hdf \
    && rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /home/$NB_USER/.ipython/profile_default/startup/ && \
    mkdir -p /home/$NB_USER/.jupyter/custom/

ADD ./get_notebook.py /get_notebook.py
COPY ./ipython-profile.py /home/$NB_USER/.ipython/profile_default/startup/00-load.py
COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/
COPY jupyter_lab_config.py /home/$NB_USER/.jupyter/
ADD ./custom.js /home/$NB_USER/.jupyter/custom/custom.js
ADD ./custom.css /home/$NB_USER/.jupyter/custom/custom.css
ADD ./default_notebook.ipynb /home/$NB_USER/notebook.ipynb

# ENV variables to replace conf file
ENV DEBUG=false \
    GALAXY_WEB_PORT=10000 \
    NOTEBOOK_PASSWORD=none \
    CORS_ORIGIN=none \
    DOCKER_PORT=none \
    API_KEY=none \
    HISTORY_ID=none \
    REMOTE_HOST=none \
    GALAXY_URL=none


# @jupyterlab/google-drive  not yet supported

USER root

# /import will be the universal mount-point for Jupyter
# The Galaxy instance can copy in data that needs to be present to the Jupyter webserver
RUN mkdir -p /import/jupyter/outputs/ && \
    mkdir -p /import/jupyter/data && \
    mkdir -p /export && \
    chown -R $NB_USER:users /home/$NB_USER/ /import /export/ && \
    mkdir -p /opt/app &&\
    chmod 777 /opt/app 

### AI

#WORKDIR /opt/app

#COPY setup.sh /opt/app
#COPY requirements/ /opt/app
#COPY whisper_live /opt/app/whisper_live
#COPY run_server.py /opt/app


EXPOSE 22 19999 29999

RUN echo 'export PATH="/usr/bin/dotnet-runtime:/usr/bin/dotnet:/workspace/bin:$PATH"' >> /home/ccbruce/.bashrc \
    && mkdir -p /opt/startup /workspace /var/workspace /var/my-docker /var/repository && chmod 777 /workspace\
    && mkdir -p /var/log/supervisor \
    && chmod +x /opt/startup/docker-entrypoint.sh 
    #&& apt update -y --fix-missing \
    #&& bash setup.sh \
    #&& pip install -r server.txt \
    #&& rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*
