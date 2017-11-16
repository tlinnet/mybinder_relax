# To build this image, source the file

# Build user setup
docker build -t $USER/relax:20_mybinder -f Dockerfile .
alias dr20='docker run -ti --rm -e DISPLAY=$(ifconfig|grep "inet "|grep -v 127.0.0.1|cut -d" " -f2):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$PWD":/home/developer/work --name relax20 $USER/relax:20_mybinder'
# Docker relax Jupyter notebook
alias dr20j='docker run -ti --rm -e DISPLAY=$(ifconfig|grep "inet "|grep -v 127.0.0.1|cut -d" " -f2):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$PWD":/home/developer/work -p 8888:8888 --name relax20 $USER/relax:20_mybinder'
alias dr20n='docker run -ti --rm -e DISPLAY=$(ifconfig|grep "inet "|grep -v 127.0.0.1|cut -d" " -f2):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$PWD":/home/developer/work -p 8888:8888 --name relax20 $USER/relax:20_mybinder jupyter-notebook --debug --no-browser --port 8888 --ip=0.0.0.0'
alias dr20l='docker run -ti --rm -e DISPLAY=$(ifconfig|grep "inet "|grep -v 127.0.0.1|cut -d" " -f2):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$PWD":/home/developer/work -p 8888:8888 --name relax20 $USER/relax:20_mybinder jupyter-lab --debug --no-browser --port 8888 --ip=0.0.0.0'
alias dr20e='docker exec -it relax20'