# Interactive Jupyter notebooks with graphs and sliders
**Launch these notebooks online.**

* [Example of damped sine wave](https://mybinder.org/v2/gh/tlinnet/mybinder_relax/master?filepath=plot_sin.ipynb)
* [NMR CPMG relaxation graphs](https://mybinder.org/v2/gh/tlinnet/mybinder_relax/master?filepath=CPMG_NMR_relax_interactive.ipynb)

## mybinder.org
[mybinder image](https://mybinder.org) makes an python executable environment available through a browser session. 

* This makes python Jupyter notebooks **truly interactive and exploratory**. 
* Make your code immediately reproducible by anyone, anywhere.
* [Click here to setup installation for mybinder](https://repo2docker.readthedocs.io/en/latest/samples.html)
* [Examples on github for mybinder](https://github.com/binder-examples)

## Files used for bind

* [apt.txt](https://github.com/tlinnet/mybinder_relax/blob/master/apt.txt) : For system packages which should be installed with apt-get.
* [requirements.txt](https://github.com/tlinnet/mybinder_relax/blob/master/requirements.txt) : For the python packages which should be installed with pip.
* [postBuild](https://github.com/tlinnet/mybinder_relax/blob/master/postBuild) : Is the executable file which should be executed after the image is build. Note, there is no sudo privilege available here.