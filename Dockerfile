FROM jupyter/scipy-notebook:7fd175ec22c7

# Set variables    
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY Dockerfile ${HOME}
COPY *.ipynb ${HOME}/
COPY images ${HOME}/

# Set root
USER root
RUN chown -R ${NB_UID} ${HOME}

# Get packages
ENV BUILD_PACKAGES="lynx curl wget unzip subversion git"
ENV BUILD_PACKAGES="$BUILD_PACKAGES grace scons"

# Install. # Install all packages in 1 RUN
RUN echo "Installing these packages" $BUILD_PACKAGES
RUN apt-get update && \
    apt-get install --no-install-recommends -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

# Install additional python packages
ENV PIP_PACKAGES="bqplot ipyvolume"
ENV PIP_PACKAGES="$PIP_PACKAGES https://iweb.dl.sourceforge.net/project/minfx/1.0.12/minfx-1.0.12.tar.gz"
ENV PIP_PACKAGES="$PIP_PACKAGES https://iweb.dl.sourceforge.net/project/bmrblib/1.0.4/bmrblib-1.0.4.tar.gz"
ENV PIP_PACKAGES="$PIP_PACKAGES https://github.com/jjhelmus/nmrglue/releases/download/v0.6/nmrglue-0.6.tar.gz"

# Install packages
RUN echo "" && \
    pip install $PIP_PACKAGES

# Enable
RUN echo "" && \
    jupyter nbextension enable --py bqplot --sys-prefix && \
    jupyter nbextension enable --py ipyvolume --sys-prefix

# Set user back
USER ${NB_USER}