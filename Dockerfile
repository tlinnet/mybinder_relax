FROM tlinnet/relax

# Make sure the contents of our repo are in ${HOME}/work
COPY Dockerfile ${HOME}/work
COPY *.ipynb ${HOME}/work/
COPY images ${HOME}/work/images

# Sign Notebooks
WORKDIR /home/jovyan/work
RUN for f in *.ipynb; do jupyter trust $f; done

# Set variables
ENV NB_USER jovyan
ENV NB_UID 1000
# Set user
#ENV HOME=/home/${NB_USER}

## Set root, and make folder writable
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

    