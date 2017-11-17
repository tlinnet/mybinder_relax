FROM jupyter/scipy-notebook:7fd175ec22c7

# Set variables    
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

# Set root
USER root

# Get packages
ENV BUILD_PACKAGES="lynx curl wget unzip subversion git"
ENV BUILD_PACKAGES="$BUILD_PACKAGES grace scons"

# Install. # Install all packages in 1 RUN
RUN echo "Installing these packages" $BUILD_PACKAGES
RUN apt-get update && \
    apt-get install --no-install-recommends -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

# Set user back
USER ${NB_USER}

# Install additional python packages
ENV ANACONDA_PACKAGES="ipywidgets"
ENV CONDA_PACKAGES="bqplot vaex ipyvolume"
ENV PIP_PACKAGES="scons"
ENV PIP_PACKAGES="$PIP_PACKAGES https://iweb.dl.sourceforge.net/project/minfx/1.0.12/minfx-1.0.12.tar.gz"
ENV PIP_PACKAGES="$PIP_PACKAGES https://iweb.dl.sourceforge.net/project/bmrblib/1.0.4/bmrblib-1.0.4.tar.gz"
ENV PIP_PACKAGES="$PIP_PACKAGES https://github.com/jjhelmus/nmrglue/releases/download/v0.6/nmrglue-0.6.tar.gz"

# Install packages
RUN echo "" && \
    conda install -c anaconda $ANACONDA_PACKAGES && \
    conda install -c conda-forge $CONDA_PACKAGES && \
    pip install $PIP_PACKAGES


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
    sed -i -e 's/+ `temp_extns`//g' sconstruct && \
    sed -i -e 's/+ `sys.version_info\[0\]`//g' sconstruct && \
    sed -i -e 's/+ `sys.version_info\[1\]`//g' sconstruct && \
    sed -i -e 's/+ `str(self.relax_fit_object\[0\])`//g' sconstruct && \
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