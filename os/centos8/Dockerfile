#
# Dockerfile: https://github.com/cpp-projects-showcase/docker-images/tree/main/centos8
# Usual Docker tag: infrahelpers/cpppython:centos8
# Docker Hub/Cloud page: https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
#
# Base image:
# * Hub/cloud: 'stream8' on
#   + Docker.io: https://hub.docker.com/r/tgagor/centos-stream 
#   + Quay.io: https://quay.io/repository/centos/centos?tab=tags
# * Dockerfile: https://github.com/tgagor/docker-centos/blob/master/stream8/Dockerfile
#
FROM quay.io/centos/centos:stream8

LABEL authors="Denis Arnaud <denis.arnaud_github at m4x dot org>"
LABEL version="0.1"

# Docker build time environment variables
ENV container="docker"
ENV HOME="/home/build"
ENV LANGUAGE="en_US:en"
ENV LANG="en_US.UTF-8"
ENV LC_ALL="$LANG"

# Import the Centos-8 GPG key to prevent warnings
RUN rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official && \
  rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Testing

# As CentOS Stream 8 has been deprecated, the RPM repositories are now archived.
# The following is a temporary work around. The long term solution is to upgrade
# to CentOS Stream 9 (or soon to CentOS Stream 10)
ADD resources/CentOS-Stream-AppStream.repo /etc/yum.repos.d/CentOS-Stream-AppStream.repo
ADD resources/CentOS-Stream-BaseOS.repo /etc/yum.repos.d/CentOS-Stream-BaseOS.repo
ADD resources/CentOS-Stream-Extras-common.repo /etc/yum.repos.d/CentOS-Stream-Extras-common.repo
ADD resources/CentOS-Stream-Extras.repo /etc/yum.repos.d/CentOS-Stream-Extras.repo
ADD resources/CentOS-Stream-PowerTools.repo etc/yum.repos.d/CentOS-Stream-PowerTools.repo 

# Add the config manager
RUN dnf -y install 'dnf-command(config-manager)'

# Add EPEL support
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Update of CentOS
RUN dnf -y clean all && \
    dnf -y upgrade || echo "Issue with upgrade; fine for now"

# Configure the locale
RUN dnf -y install glibc-locale-source glibc-langpack-en && \
	localedef -f UTF-8 -i en_US $LANG

# Environment for the `root` user
ADD resources/bashrc /root/.bashrc

# Basic, C++ and Python packages
RUN dnf -y install less htop net-tools bind-utils which sudo man vim \
	git-all wget curl file bash-completion keyutils \
	zlib-devel bzip2-devel gzip tar patch rpmconf yum-utils \
	autoconf automake libtool \
	langtable gcc gcc-c++ cmake m4 cppunit-devel \
	zeromq-devel czmq-devel cppzmq-devel openblas-devel \
	boost169-devel boost169-python3-devel \
	xapian-core-devel openssl-devel libffi-devel \
	mpich-devel openmpi-devel \
	readline-devel sqlite-devel mysql-devel \
	soci-mysql-devel soci-sqlite3-devel
RUN dnf -y install libicu-devel \
	protobuf-devel protobuf-compiler \
	python36 python36-devel \
	python3-django python3-mod_wsgi \
	python38 python38-devel \
	python39 python39-devel \
	python3.11 python3.11-devel \
	geos-devel \
	graphviz ghostscript doxygen \
	R-devel \
	rake rubygem-rake \
	jq
RUN dnf -y install "tex(latex)" texlive-epstopdf-bin
RUN dnf -y clean all

# yq, the YAML CLI utility like jq, for YAML (https://github.com/mikefarah/yq)
RUN YQ_VER=$(curl -Ls https://api.github.com/repos/mikefarah/yq/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
	architecture=$(uname -m|sed 's/x86_/amd/') && \
	echo "YQ_VER=${YQ_VER} - architecture=${architecture}" && \
	curl -Ls \
	    https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_${architecture} -o /usr/local/bin/yq && \
	chmod +x /usr/local/bin/yq

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

# Python, Pyenv and pipenv (https://www.python.org/downloads/)
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

# Hack to git update $HOME/.pyenv
WORKDIR $HOME/.pyenv
RUN git pull && hash -r
WORKDIR $HOME

ENV PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
# Python 3.8.20
RUN pyenv install 3.8.20 && \
    pyenv global 3.8.20 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.8.20"
# Python 3.9.23
RUN pyenv install 3.9.23 && \
    pyenv global 3.9.23 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.9.23"
# Python 3.10.18
RUN pyenv install 3.10.18 && \
    pyenv global 3.10.18 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.10.18"
# Python 3.11.13
RUN pyenv install 3.11.13 && \
    pyenv global 3.11.13 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.11.13"
# Python 3.12.11
RUN pyenv install 3.12.11 && \
    pyenv global 3.12.11 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.12.11"
# Python 3.13.5
RUN pyenv install 3.13.5 && \
    pyenv global 3.13.5 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.13.5"

# Entry point
CMD ["/bin/bash"]


