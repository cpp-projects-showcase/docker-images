#
# Dockerfile: http://github.com/cpp-projects-showcase/docker-images/tree/master/debian9
# Docker Hub/Cloud page: https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
#
FROM docker.io/debian:9

LABEL authors="Denis Arnaud <denis.arnaud_github at m4x dot org>"
LABEL version="0.1"

# Environment
ENV container docker
ENV HOME /home/build
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL $LANG
# Check https://github.com/SOCI/soci/tags for the latest releases
ENV SOCI_VER 4.0.2
# Check https://github.com/mikefarah/yq/releases/latest for the latest releases
ENV YQ_VERSION 4.13.5

# Update the system
RUN apt-get update && apt-get -y install locales apt-utils && apt-get -y upgrade

# Generate the locales
RUN locale-gen $LANG

# Configure the time-zone
RUN apt-get -y install tzdata && echo "Europe/Paris" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

# Basic, C++ and Python packages
RUN apt-get -y install sudo less htop net-tools wget curl \
	screen git keychain gawk \
	bash-completion vim-nox emacs-nox apt-utils keyutils ftp \
	zlib1g-dev libbz2-dev gzip tar unzip \
	lsb-release libgmp-dev \
	gcc g++ cmake manpages \
	m4 autoconf libtool build-essential cppcheck clang \
	flex bison \
	libboost-all-dev libxapian-dev \
	libreadline-dev libncurses5-dev \
	libczmq-dev libzmq3-dev libssl-dev libffi-dev \
	swig graphviz libopenblas-dev \
	libmpich-dev libopenmpi-dev \
	sqlite3 libsqlite3-dev libmariadb-dev libmysql++-dev \
	postgresql-server-dev-all \
	libicu-dev libprotobuf-dev protobuf-compiler \
	python3 libpython3-dev \
	python3-django libapache2-mod-wsgi-py3 \
	libgeos++-dev \
	doxygen ghostscript texlive-latex-recommended \
	r-base r-base-dev \
	rake \
	jq

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# yq, the YAML CLI utility like jq, but for YAML
RUN curl -L -s \
	  https://github.com/mikefarah/yq/releases/download/v$YQ_VERSION/yq_linux_amd64 \
	  -o /usr/local/bin/yq && \
	chmod 775 /usr/local/bin/yq

# SOCI (as of December 2018, SOCI v4.0 has still not been released)
RUN mkdir -p /opt/soci
ADD resources/soci-debian-cmake.patch /opt/soci/soci-debian-cmake.patch
RUN curl -L -s \
         https://github.com/SOCI/soci/archive/refs/tags/v$SOCI_VER.tar.gz \
         -o /opt/soci/soci-$SOCI_VER.tar.gz && cd /opt/soci && \
    tar zxf soci-$SOCI_VER.tar.gz && rm -f soci-$SOCI_VER.tar.gz && \
    cd soci-$SOCI_VER && patch -p1 < ../soci-debian-cmake.patch && \
    mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
          -DSOCI_CXX11=ON -DSOCI_TESTS=OFF .. && \
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
ENV PATH $HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
# Python 3.8.12
RUN pyenv install 3.8.12 && \
    pyenv global 3.8.12 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.8.12"
# Python 3.9.7
RUN pyenv install 3.9.7 && \
    pyenv global 3.9.7 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.9.7"
# Python 3.10.0
RUN pyenv install 3.10.0 && \
    pyenv global 3.10.0 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.10.0"

# Entry point
CMD ["/bin/bash"]

