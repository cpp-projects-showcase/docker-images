Docker images to support development on C++ and Python stacks
=============================================================

# Introduction
[That project](https://github.com/cpp-projects-showcase/docker-images)
produces Docker images, hosted on [dedicated
public Docker Cloud site](https://cloud.docker.com/u/cpppythondevelopment/repository/docker/cpppythondevelopment/base).
Those Docker images are intended to bring Linux-based ready-to-use environment
for C++ and Python developers. Both programming languages are related
as Python is built on top of C++ (_e.g._, a few Python modules needs
to be compiled with C++).
Some basic support for [R](http://r-project.org) is also provided.

The supported Linux distributions are
[CentOS 7](https://wiki.centos.org/Manuals/ReleaseNotes/CentOS7),
[Ubuntu 18.10 (Cosmic Cuttlefish)](http://releases.ubuntu.com/18.10/),
[Ubuntu 18.04 LTS (Bionic Beaver)](http://releases.ubuntu.com/18.04/),
[Ubuntu 16.04 LTS (Xenial Xerus)](http://releases.ubuntu.com/16.04/)
and [Debian 9 (Stretch)](https://www.debian.org/releases/stretch/).
[Debian 10 (buster; release expected around May 2019)](https://www.debian.org/releases/buster/)
and [CentOS 8 (release expected end of 2019)](https://wiki.centos.org/Manuals/ReleaseNotes/CentOS8)
may be supported next.

Every time some changes are committed on the [project's GitHub
repository](https://github.com/cpp-projects-showcase/docker-images),
the [Docker images are automatically
rebuilt](https://cloud.docker.com/u/cpppythondevelopment/repository/docker/cpppythondevelopment/base/timeline)
and pushed onto Docker Cloud.

When some more components are needed, which may be of interest to other
C++ and Python developers, the Docker image may be amended so as to add
those extra components.
The preferred way to propose amendment of the Docker image is through
[pull requests on the GitHub
project](https://github.com/cpp-projects-showcase/docker-images/pulls).
Once the pull request has been merged, _i.e._, once the `Dockerfile` amendment
has been [committed in
GitHub](https://github.com/cpp-projects-showcase/docker-images/commits/master),
Docker Cloud then rebuilds the corresponding Docker images, which become
available for every one to use.

# Images on Docker Cloud
* [Docker Cloud dashboard](https://cloud.docker.com/u/cpppythondevelopment/repository/docker/cpppythondevelopment/base)

# Using the pre-built development images
* Start the Docker container featuring the target Linux distribution
  (`<linux-distrib>` may be one of `centos7`, `ubuntu1810`, `ubuntu1804`,
   `ubuntu1604` or `debian9`):
```bash
$ docker pull cpppythondevelopment/base:<linux-distrib>
$ docker run --rm -v ~/.ssh/id_rsa:/home/build/.ssh/id_rsa -v ~/.ssh/id_rsa.pub:/home/build/.ssh/id_rsa.pub -it cpppythondevelopment/base:<linux-distrib>
[build@5..0 dev]$ 
```

* Setup the user names and email addresses as environment variables for
  subsequent settings. If you intend to contribute to Fedora/CentOS/RedHat
  packaging, they should match as much as possible with
  [Pagure, the Fedora Git repository](https://src.fedoraproject.org/settings#nav-email-tab)(otherwise, just ignore the RPM packaging part):
```bash
[build@5..0 dev]$ export FULLNAME="Firstname Lastname"
[build@5..0 dev]$ export EMAIL="email@example.com"
```

* Setup the user name and email address for Git:
```bash
[build@5..0 dev]$ git config --global user.name "$FULLNAME"
[build@5..0 dev]$ git config --global user.email "$EMAIL"
```

* Setup the user names and email address for the RPM packaging:
```bash
[build@5..0 dev]$ sed -i -e "s/Firstname Lastname/$FULLNAME/g" ~/.rpmmacros
[build@5..0 dev]$ sed -i -e "s/email@example.com/$EMAIL/g" ~/.rpmmacros
```

* Clone some C++-based project (_e.g._,
  [OpenTREP](http://github.com/trep/opentrep) is used as an example here):
```bash
[build@5..0 dev]$ git clone https://github.com/trep/opentrep.git
Cloning into 'opentrep'...
remote: Enumerating objects: 44, done.
remote: Counting objects: 100% (44/44), done.
remote: Compressing objects: 100% (35/35), done.
Receiving objects: 100% (5813/5813), 61.53 MiB | 211.00 KiB/s, done.
remote: Total 5813 (delta 12), reused 19 (delta 8), pack-reused 5769
Resolving deltas: 100% (3665/3665), done.
[build@5..0 dev]$ cd opentrep
[build@5..0 opentrep (trunk)]$ 
```

* Do some development:
```bash
[build@5..0 opentrep (trunk)]$ export INSTALL_BASEDIR=$HOME/dev/deliveries && export TREP_VER=99.99.99 && if [ -d /usr/lib64 ]; then LIBSUFFIX=64; fi && export LIBSUFFIX_4_CMAKE="-DLIB_SUFFIX=$LIBSUFFIX"
[build@5..0 opentrep (trunk)]$ rm -rf build && mkdir build && cd build
[build@5..0 build (trunk)]$ cmake3 -DCMAKE_INSTALL_PREFIX=${INSTALL_BASEDIR}/opentrep-$TREP_VER  -DCMAKE_BUILD_TYPE:STRING=Debug -DINSTALL_DOC:BOOL=OFF -DRUN_GCOV:BOOL=OFF ${LIBSUFFIX_4_CMAKE} ..
[build@5..0 build (trunk)]$ make install
[build@5..0 build (trunk)]$ ./opentrep/opentrep-indexer
[build@5..0 build (trunk)]$ ./opentrep/opentrep-searcher -q "nce sfo"
[build@5..0 build (trunk)]$ exit
```

# Customize a Docker Image
The images may be customized, and pushed to Docker Cloud;
`<linux-distrib>` may be one of `centos7`, `ubuntu1810`, `ubuntu1804`,
`ubuntu1604` or `debian9`:
```bash
$ mkdir -p ~/dev
$ cd ~/dev
$ git clone https://github.com/cpp-projects-showcase/docker-images.git cpp-docker-images
$ cd cpp-docker-images
$ vi <linux-distrib>/Dockerfile
$ docker build -t cpppythondevelopment/<linux-distrib>:beta --squash <linux-distrib>/
$ docker run --rm -v ~/.ssh/id_rsa:/home/build/.ssh/id_rsa -v ~/.ssh/id_rsa.pub:/home/build/.ssh/id_rsa.pub -it cpppythondevelopment/<linux-distrib>:beta
[build@9..d cpp-projects-showcase]$ exit
$ docker push cpppythondevelopment/<linux-distrib>:beta
```

# TODO
For any of the following features, an issue may be open
[on GitHub](https://github.com/cpp-projects-showcase/docker-images/issues):
1. Support other Linux distributions, for instance Ubuntu 14.04 LTS
   or Fedora (_e.g._, `fedora`)
2. Automate regular rebuilds (_e.g._, once a month for CentOS or Ubuntu)


