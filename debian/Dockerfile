#
# http://github.com/cpp-projects-showcase/docker-images/tree/master/ubuntu
#
FROM docker.io/debian:9
MAINTAINER Denis Arnaud <denis.arnaud_github at m4x dot org>
LABEL version="0.1"

# Environment
ENV container docker
ENV HOME /home/build
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL $LANG

# Update the system
RUN apt-get update && apt-get -y install locales apt-utils && apt-get -y upgrade

# Generate the locales
RUN locale-gen $LANG

# Configure the time-zone
RUN apt-get -y install tzdata && echo "Europe/Paris" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

# Basic, C++ and Python packages
RUN apt-get -y install sudo less htop net-tools wget curl screen git-all keychain gawk \
	bash-completion vim-nox emacs-nox apt-utils keyutils ftp \
	zlib1g-dev libbz2-dev gzip tar unzip \
	lsb-release libgmp-dev \
	gcc g++ cmake manpages \
	m4 autoconf libtool build-essential cppcheck clang \
	flex bison \
	libboost-all-dev libxapian-dev \
	libreadline-dev libncurses5-dev \
	libczmq-dev libzmq3-dev libssl-dev libffi-dev \
	swig graphviz \
	libmpich-dev libopenmpi-dev \
	sqlite3 libsqlite3-dev libmariadb-dev libmysql++-dev \
	postgresql-server-dev-all \
	libicu-dev libprotobuf-dev protobuf-compiler \
	python libpython-dev python3 libpython3-dev \
	python3-django libapache2-mod-wsgi-py3 \
	libgeos++-dev \
	doxygen ghostscript texlive-latex-recommended \
	rake

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# SOCI (as of December 2018, SOCI v4.0 has still not been released)
RUN mkdir -p /opt/soci
ADD resources/soci-debian-cmake.patch /opt/soci/soci-debian-cmake.patch
RUN git clone https://github.com/SOCI/soci.git /opt/soci/socigit && \
	cd /opt/soci/socigit && patch -p1 < ../soci-debian-cmake.patch && \
	mkdir -p build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DSOCI_CXX_C11=ON -DSOCI_TESTS=OFF .. && \
	make install

# Create the `build` user (for the development activities)
RUN adduser --disabled-password --gecos "" build
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

# Git prompt
RUN git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

# Python Pyenv and pipenv
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
RUN PATH=$HOME/.pyenv/bin:$PATH pyenv install 3.7.1
RUN PATH=$HOME/.pyenv/bin:$PATH pyenv global 3.7.1
RUN PATH=$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH pip install -U pipenv

# Entry point
CMD ["/bin/bash"]

