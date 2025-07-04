#
# Dockerfile: http://github.com/cpp-projects-showcase/docker-images/tree/main/ubuntu2004
# Usual Docker tag: infrahelpers/cpppython:ubuntu2004
# Docker Hub/Cloud page: https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
#
FROM docker.io/ubuntu:20.04

LABEL authors="Denis Arnaud <denis.arnaud_github at m4x dot org>"
LABEL version="0.1"

# Environment
ENV container="docker"
ENV HOME="/home/build"
ENV LANGUAGE="en_US:en"
ENV LANG="en_US.UTF-8"
ENV LC_ALL="$LANG"

# Update the system
RUN echo "Europe/Paris" > /etc/timezone
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90-yes
RUN apt-get -qq update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
	apt-utils apt-transport-https \
	ca-certificates locales tzdata sudo \
	zip unzip gzip bzip2 xz-utils tar unrar p7zip-full \
	curl wget netcat net-tools bind9-host aptitude

# Generate the locales
RUN locale-gen $LANG && \
	update-locale LANG=$LANG LANGUAGE=$LANGUAGE LC_ALL=$LC_ALL

# Configure the time-zone
RUN dpkg-reconfigure -f noninteractive tzdata

# Basic, C++ and Python packages
RUN apt-get -qq update && apt-get -y upgrade
RUN apt-get -y install procps less htop screen
RUN apt-get -y install git keychain gettext-base gawk
RUN apt-get -y install bash-completion vim-nox emacs-nox apt-utils keyutils ftp
RUN apt-get -y install zlib1g-dev libbz2-dev lsb-release libgmp-dev
RUN apt-get -y install gcc g++ cppcheck clang manpages patch pkg-config
RUN apt-get -y install m4 autoconf automake libtool libltdl-dev build-essential
RUN apt-get -y install flex bison
RUN apt-get -y install libboost-all-dev libxapian-dev
RUN apt-get -y install libreadline-dev libncurses5-dev
RUN apt-get -y install libzmqpp-dev libzmq3-dev libczmq-dev
RUN apt-get -y install libssl-dev libffi-dev
RUN apt-get -y install swig graphviz libopenblas-dev
RUN apt-get -y install libmpich-dev libopenmpi-dev
RUN apt-get -y install sqlite3 libsqlite3-dev
RUN apt-get -y install mariadb-client libmariadbclient-dev
RUN apt-get -y install postgresql-client libpqxx-dev
RUN apt-get -y install libicu-dev libprotobuf-dev protobuf-compiler
RUN apt-get -y install python3 libpython3-dev
RUN apt-get -y install libgeos++-dev
RUN apt-get -y install doxygen ghostscript texlive-latex-recommended
RUN apt-get -y install r-base r-base-dev rake
RUN apt-get -y install jq
#RUN apt-get -y install python3-django libapache2-mod-wsgi-py3

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# CMake (for Ubuntu LTS: https://apt.kitware.com/)
RUN curl -kL https://apt.kitware.com/keys/kitware-archive-latest.asc | \
	gpg --dearmor - | \
	tee /usr/share/keyrings/kitware-archive-keyring.gpg > /dev/null && \
	echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | \
	tee /etc/apt/sources.list.d/kitware.list > /dev/null && \
	apt-get update && apt-get -y install cmake

# yq, the YAML CLI utility like jq, for YAML (https://github.com/mikefarah/yq)
RUN YQ_VER=$(curl -Ls https://api.github.com/repos/mikefarah/yq/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
	architecture=$(uname -m|sed 's/x86_/amd/') && \
	echo "YQ_VER=${YQ_VER} - architecture=${architecture}" && \
	curl -Ls \
	    https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_${architecture} -o /usr/local/bin/yq && \
	chmod +x /usr/local/bin/yq

# SOCI (https://github.com/SOCI/soci)
RUN mkdir -p /opt/soci
RUN SOCI_VER=$(curl -Ls https://api.github.com/repos/SOCI/soci/tags|jq -r '.[].name'|grep "^v"|sort -r|head -1|cut -d'v' -f2,2) && \
	curl -Ls \
         https://github.com/SOCI/soci/archive/refs/tags/v${SOCI_VER}.tar.gz \
         -o /opt/soci/soci-${SOCI_VER}.tar.gz && cd /opt/soci && \
    tar zxf soci-${SOCI_VER}.tar.gz && rm -f soci-${SOCI_VER}.tar.gz && \
    cd soci-${SOCI_VER} && mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
          -DSOCI_TESTS=OFF .. && \
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

# Python, Pyenv and pipenv (https://www.python.org/downloads/)
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

# Hack to git update $HOME/.pyenv
WORKDIR $HOME/.pyenv
RUN git pull
WORKDIR $HOME

ENV PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
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

