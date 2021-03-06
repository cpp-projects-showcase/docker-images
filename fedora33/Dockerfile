#
# https://github.com/cpp-projects-showcase/docker-images/tree/master/fedora33
#
FROM docker.io/library/fedora:33

LABEL authors="Christophe Gattardi <christophe.gattardi+docker@gmail.com>"
LABEL version="0.1"

# Docker build time environment variables
ENV container docker
ENV HOME /home/build
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL $LANG

# Update of Fedora and configure the locale
RUN dnf -y clean all && \
    dnf -y upgrade && \
	dnf -y install glibc-locale-source glibc-langpack-en && \
	dnf -y clean all && \
	localedef -f UTF-8 -i en_US $LANG 

# Environment for the `root` user
ADD resources/bashrc /root/.bashrc

# Basic, C++ and Python packages
RUN dnf -y install less htop net-tools which sudo man vim \
	git-all wget curl file bash-completion keyutils \
	zlib-devel bzip2-devel gzip tar rpmconf yum-utils \
	langtable gcc gcc-c++ cmake cmake3 m4 cppunit-devel \
	zeromq-devel czmq-devel cppzmq-devel openblas-devel \
	boost-devel xapian-core-devel openssl-devel libffi-devel \
	mpich-devel openmpi-devel \
	readline-devel sqlite-devel mysql-devel \
	soci-mysql-devel soci-sqlite3-devel && \
  dnf -y install libicu-devel protobuf-devel protobuf-compiler \
	python36 \
	python3-django python3-mod_wsgi \
	python38 \
	python3-devel \
	geos-devel \
	graphviz ghostscript doxygen \
	R-devel \
	rubygem-rake \
	jq && \
  dnf -y install "tex(latex)" texlive-epstopdf-bin && \
  dnf -y clean all

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
ENV PATH $HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH

# Hack to git update $HOME/.pyenv
#RUN cd $HOME/.pyenv && git pull && cd -

# Python 3.8.10
RUN pyenv install 3.8.10 && \
    pyenv global 3.8.10 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.8.10"
# Python 3.9.4
RUN pyenv install 3.9.4 && \
    pyenv global 3.9.4 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.9.4"
# Python 3.9.5
RUN pyenv install 3.9.5 && \
    pyenv global 3.9.5 && \
    pip install -U pip pipenv
RUN pyenv global system || echo "No default system version of Python. Sticking to 3.9.5"

# Entry point
CMD ["/bin/bash"]
