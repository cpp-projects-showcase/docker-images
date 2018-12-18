#
# http://github.com/cpp-projects-showcase/docker-images/tree/master/ubuntu
#
FROM docker.io/ubuntu:18.10
MAINTAINER Denis Arnaud <denis.arnaud_github at m4x dot org>
LABEL version="0.1"

# Environment
ENV container "docker"
ENV HOME "/home/build"
ENV LANG "en_US.UTF-8"
ENV LC_ALL "${LANG}"

# Update the system
RUN apt-get update && apt-get -y install apt-utils && apt-get -y upgrade

# Generate the locales
RUN locale-gen

# Basic, C++ and Python packages
RUN apt-get -y install sudo less htop net-tools wget curl screen git-all \
	bash-completion vim-nox emacs-nox apt-utils keyutils \
	zlib1g-dev libbz2-dev gzip tar unzip \
	lsb-release libgmp-dev \
	gcc g++ cmake m4 autoconf libtool build-essential cppcheck clang \
	flex bison \
	libzmqpp-dev libboost-dev libxapian-dev libssl-dev libffi-dev \
	swig graphviz \
	libmpich-dev libopenmpi-dev \
	libreadline-dev libsqlite3-dev libmariadb-dev libsoci-dev \
	libicu-dev libprotobuf-dev protobuf-compiler \
	python python-pip libpython-dev \
	python3 python3-pip libpython3-dev \
	python3-django libapache2-mod-wsgi-py3 \
	libgeos++-dev \
	doxygen ghostscript texlive-latex-recommended

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create the `build` user (for the development activities)
RUN adduser build
RUN echo "build ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/build && \
    chmod 0440 /etc/sudoers.d/build

# Configure SSH
RUN mkdir -p $HOME/.ssh && chmod 700 $HOME/.ssh

# Set up the packaging environment for the `build` user
ADD resources/bashrc $HOME/.bashrc
ADD resources/gitconfig $HOME/.gitconfig
ADD resources/vimrc $HOME/.vimrc
RUN chmod 640 $HOME/.bashrc $HOME/.gitconfig $HOME/.vimrc
RUN chown -R build.build $HOME

# Switch to the 'build' user
WORKDIR $HOME
USER build

# Python Pyenv and pipenv
RUN git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv
RUN source ${HOME}/.bashrc && pyenv install 3.7.1
RUN pip3 install --user -U pipenv

# Entry point
CMD ["/bin/bash"]

