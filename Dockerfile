FROM tlinnet/relax

# Make sure the contents of our repo are in ${HOME}
COPY Dockerfile ${HOME}/work
COPY *.ipynb ${HOME}/work/
COPY images ${HOME}/work/images

# Sign Notebooks
RUN for f in *.ipynb; do jupyter trust $f; done

# WORKDIR /home/jovyan

#ENV NB_USER jovyan
#ENV NB_UID 1000
## Set user
#USER ${NB_USER}
#ENV HOME=/home/${NB_USER}
#WORKDIR /home/jovyan/work
#ENV PATH="$HOME/bin:${PATH}"

## Set root
#USER root
#RUN chown -R ${NB_UID} ${HOME}

## Set user back
#USER ${NB_USER}
    