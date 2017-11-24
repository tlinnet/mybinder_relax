# See latest tag at: https://hub.docker.com/r/jupyter/scipy-notebook/
# Reference with: https://github.com/jupyter/docker-stacks/commits/master
FROM jupyter/scipy-notebook:033056e6d164

# Set variables    
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

# Set root
USER root

# Get packages
ENV BUILD_PACKAGES="curl wget unzip subversion git"
ENV BUILD_PACKAGES="$BUILD_PACKAGES grace scons"

# Install. # Install all packages in 1 RUN
RUN echo "Installing these packages" $BUILD_PACKAGES
RUN apt-get update && \
    apt-get install --no-install-recommends -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

# Set user back
USER ${NB_USER}

# Install additional python packages
#ENV ANACONDA_PACKAGES=""
#conda install -c anaconda $ANACONDA_PACKAGES && \

#ENV CONDA_PACKAGES=""
#conda install -c conda-forge $CONDA_PACKAGES && \

ENV PIP_PACKAGES="scons nmrglue"
ENV PIP_PACKAGES="$PIP_PACKAGES https://iweb.dl.sourceforge.net/project/minfx/1.0.12/minfx-1.0.12.tar.gz"
ENV PIP_PACKAGES="$PIP_PACKAGES https://iweb.dl.sourceforge.net/project/bmrblib/1.0.4/bmrblib-1.0.4.tar.gz"
#pip install $PIP_PACKAGES

# RISE: Quickly turn your Jupyter Notebooks into a live presentation.
# datashader: creating meaningful representations of large amounts of data.

# Install packages
RUN echo "" && \
    pip install $PIP_PACKAGES && \
    conda install -c damianavila82 rise && \
    conda install -c bokeh datashader

# jupyter notebook password remove
RUN echo "" && \
    mkdir -p $HOME/.jupyter && \
    cd $HOME/.jupyter && \
    echo "c.NotebookApp.token = u''" > jupyter_notebook_config.py

# Get relax
# http://www.nmr-relax.com
ENV PYTHON_INCLUDE_DIR="/opt/conda/include/python3.6m"
RUN cd $HOME && \
    mkdir -p $HOME/software && \
    cd $HOME/software && \
    git clone --depth 1 https://github.com/nmr-relax/relax.git relax && \
    cd $HOME/software/relax && \
    scons && \
    ./relax -i && \
    ln -s $HOME/software/relax/relax /opt/conda/bin/relax

# Make sure the contents of our repo are in ${HOME}
COPY Dockerfile ${HOME}
COPY *.ipynb ${HOME}/
COPY images ${HOME}/images

# Sign Notebooks
#WORKDIR /home/jovyan/work
RUN for f in *.ipynb; do jupyter trust $f; done

## Set root, and make folder writable
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}