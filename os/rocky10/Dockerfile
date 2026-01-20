#
# Dockerfile: https://github.com/cpp-projects-showcase/docker-images/tree/main/rocky10
# Usual Docker tag: infrahelpers/cpppython:rocky10
# Docker Hub/Cloud page: https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
#
# Base Image:
# * Hub/cloud:
#   + Home page on Docker Hub: https://hub.docker.com/_/rockylinux
#   + '10' on Docker Hub: https://hub.docker.com/r/rockylinux/rockylinux
# * Dockerfile:
#   + Specific branches on https://github.com/rocky-linux/sig-cloud-instance-images
#   + e.g., https://github.com/rocky-linux/sig-cloud-instance-images/tree/Rocky-9.6.20250531-UBI-x86_64
#
# FROM docker.io/rockylinux:10
FROM docker.io/rockylinux/rockylinux:10.1.20251123

LABEL authors="Denis Arnaud <denis.arnaud_github at m4x dot org>"
LABEL version="0.1"

# Docker build time environment variables
ENV container="docker"
ENV HOME="/home/build"
ENV LANGUAGE="en_US:en"
ENV LANG="en_US.UTF-8"
ENV LC_ALL="$LANG"

# Add the repository for CodeReady Linux Builder (CRB)
RUN dnf -y install 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled crb

# Add EPEL support
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm

# Update of CentOS
RUN dnf -y clean all && \
    dnf -y upgrade || echo "Issue with upgrade; fine for now"

# Configure the locale
RUN dnf -y install glibc-locale-source glibc-langpack-en && \
	localedef -f UTF-8 -i en_US $LANG

# Environment for the `root` user
ADD resources/bashrc /root/.bashrc

# Basic, C++ and Python packages
RUN dnf -y install curl-minimal
RUN dnf -y install less htop net-tools bind-utils which sudo man \
	git-all wget file bash-completion keyutils \
	zlib-devel bzip2-devel xz-devel gzip tar patch rpmconf dnf-utils \
	autoconf automake libtool \
	langtable gcc gcc-c++ cmake m4 cppunit-devel \
	zeromq-devel czmq-devel cppzmq-devel openblas \
	boost-devel boost-python3-devel boost-mpich-python3 boost-openmpi-python3 \
	xapian-core-libs \
	openssl-devel libffi-devel \
	mpich-devel openmpi-devel \
	readline-devel sqlite-devel \
	mariadb-connector-c-devel
# Soon to be released:
# xapian-bindings soci-mysql-devel soci-sqlite3-devel soci-postgresql-devel
RUN dnf -y install libicu-devel \
	protobuf-devel protobuf-compiler python3-protobuf \
	python python-devel \
	python3-mod_wsgi \
	geos-devel \
	graphviz doxygen \
	rake rubygem-rake \
	jq
# ghostscript
RUN dnf -y remove ruby-default-gems || \
	echo "ruby-default-gems was not installed. Good enough"
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

# Work around to force a reset of the cache in building Docker
RUN mkdir -p /tmp/TO_BE_REMOVED

ENV PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
# Python 3.12.12
RUN pyenv install 3.12.12 && \
    pyenv global 3.12.12 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.12.12"
# Python 3.13.11
RUN pyenv install 3.13.11 && \
    pyenv global 3.13.11 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.13.11"

# Entry point
CMD ["/bin/bash"]


