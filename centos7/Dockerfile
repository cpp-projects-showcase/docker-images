#
# http://github.com/cpp-projects-showcase/docker-images/tree/master/centos7
#
FROM docker.io/centos:7

LABEL authors="Denis Arnaud <denis.arnaud_github at m4x dot org>"
LABEL version="0.1"

# Docker build time environment variables
ENV container docker
ENV HOME /home/build
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL $LANG
# Check https://github.com/mikefarah/yq/releases/latest for the latest releases
ENV YQ_VERSION 4.11.2

# Import the Centos-7 GPG key to prevent warnings
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7

# Update of CentOS
RUN yum -y clean all && \
    yum -y upgrade && \
    yum -y install epel-release

# Environment for the `root` user
ADD resources/bashrc /root/.bashrc

# Basic, C++ and Python packages
RUN yum -y install dnf && \
  dnf -y install less htop net-tools which sudo man vim \
	git-all wget curl file bash-completion keyutils Lmod \
	zlib-devel bzip2-devel gzip tar rpmconf yum-utils \
        autoconf automake libtool \
	gcc gcc-c++ cmake cmake3 m4 \
	lcov cppunit-devel \
	zeromq-devel czmq-devel cppzmq-devel openblas-devel \
	boost-devel boost169-devel boost169-python3-devel \
	xapian-core-devel openssl-devel libffi-devel \
	mpich-devel openmpi-devel \
	readline-devel sqlite-devel mariadb-devel \
	soci-mysql-devel soci-sqlite3-devel && \
  yum -y install libicu-devel \
	protobuf-devel protobuf-compiler \
	python36 python36-devel \
	geos-devel \
	graphviz ghostscript doxygen \
	R-devel \
	rake rubygem-rake \
	jq && \
  yum -y install "tex(latex)" texlive-epstopdf-bin

# yq, the YAML CLI utility like jq, but for YAML
RUN curl -L -s \
	  https://github.com/mikefarah/yq/releases/download/v$YQ_VERSION/yq_linux_amd64 \
	  -o /usr/local/bin/yq && \
	chmod 775 /usr/local/bin/yq

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

# Switch to the `build` user
WORKDIR $HOME
USER build

# Git prompt
RUN git clone https://github.com/magicmonty/bash-git-prompt.git $HOME/.bash-git-prompt --depth=1

# Python Pyenv and pipenv
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
# To be removed as soon as the image builds again correctly
#RUN cd $HOME/.pyenv && git pull && cd -
#
ENV PATH $HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
# Python 3.8.11
RUN pyenv install 3.8.11 && \
    pyenv global 3.8.11 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.8.11"
# Python 3.9.5
RUN pyenv install 3.9.5 && \
    pyenv global 3.9.5 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.9.5"
# Python 3.9.6
RUN pyenv install 3.9.6 && \
    pyenv global 3.9.6 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.9.6"

# Entry point
CMD ["/bin/bash"]

