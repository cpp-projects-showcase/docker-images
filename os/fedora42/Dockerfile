#
# Dockerfile: http://github.com/cpp-projects-showcase/docker-images/tree/main/fedora42
# Usual Docker tag: infrahelpers/cpppython:fedora42
# Docker Hub/Cloud page: https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
#
FROM fedora:42

LABEL authors="Christophe Gattardi <christophe.gattardi+docker@gmail.com>"
LABEL version="0.1"

# Docker build time environment variables
ENV container="docker"
ENV HOME="/home/build"

# Update of Fedora and configure the locale
RUN dnf -y upgrade && \
	dnf -y install glibc-locale-source glibc-langpack-en && \
	dnf -y clean all && \
	localedef -f UTF-8 -i en_US en_US.UTF-8

#
ENV LANGUAGE="en_US:en"
ENV LANG="en_US.UTF-8"
ENV LC_ALL="$LANG"

# Environment for the `root` user
ADD resources/bashrc /root/.bashrc

# Basic, C++ and Python packages
RUN dnf -y upgrade && \
	dnf -y install less htop net-tools bind-utils which sudo man vim \
	git-all wget curl file bash-completion keyutils awk \
	zlib-devel bzip2-devel gzip tar patch rpmconf yum-utils \
	langtable gcc gcc-c++ cmake cmake3 m4 cppunit-devel \
	zeromq-devel czmq-devel cppzmq-devel openblas-devel \
	boost-devel xapian-core-devel openssl-devel libffi-devel \
	mpich-devel openmpi-devel \
	readline-devel sqlite-devel mysql-devel \
	soci-mysql-devel soci-sqlite3-devel
RUN dnf -y install libicu-devel protobuf-devel protobuf-compiler \
	python3-mod_wsgi \
	python3 python3-devel \
	python3.9 \
	python3.10 python3.10-devel \
	python3.11 python3.11-devel \
	python3.12 python3.12-devel \
	python3.13 python3.13-devel \
	geos-devel \
	graphviz ghostscript doxygen \
	R-devel \
	rubygem-rake \
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
RUN git pull
WORKDIR $HOME

ENV PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
# Python 3.13.9
RUN pyenv install 3.13.9 && \
    pyenv global 3.13.9 && \
    pip install -U pip
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.13.9"

# Entry point
CMD ["/bin/bash"]
