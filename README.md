Container images to support development with C++ and Python
===========================================================

[![Docker Cloud build status](https://img.shields.io/docker/cloud/build/infrahelpers/cpppython)](https://hub.docker.com/repository/docker/infrahelpers/cpppython/general)
[![Container repository on Quay](https://quay.io/repository/cpppythondevelopment/base/status "Container repository on Quay")](https://quay.io/repository/cpppythondevelopment/base)

# Introduction
[That project](https://github.com/cpp-projects-showcase/docker-images)
produces container (_e.g._, Docker) images, hosted on a
[dedicated public Docker Cloud site](https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython).
Those container images are intended to bring Linux-based ready-to-use
environment for C++ and Python developers. Both programming languages
are indeed related, as Python is built on top of C++ (_e.g._, a few Python
modules need to be compiled with C++).
Some basic support for [R](http://r-project.org) is also provided.

The supported Linux distributions are
[Rocky Linux 9](https://docs.rockylinux.org/release_notes/9_4/),
[CentOS 10 Stream](https://community.centminmod.com/threads/centos-stream-10-is-released.25454/) (not officially released, as of end 2024; see also
[CentOS Stream 10 compose artifacts](https://composes.stream.centos.org/stream-10/development/latest-CentOS-Stream/compose/BaseOS/x86_64/iso/)),
[CentOS 9 Stream](https://blog.centos.org/2021/12/introducing-centos-stream-9/),
[CentOS 8 Stream](https://wiki.centos.org/Manuals/ReleaseNotes/CentOS8.2004),
[Fedora 40](https://docs.fedoraproject.org/en-US/fedora/f40/release-notes/index.html),
[Fedora 39](https://docs.fedoraproject.org/en-US/fedora/f39/release-notes/index.html),
[Ubuntu 24.04 LTS (Noble Numbat)](https://releases.ubuntu.com/24.04/),
[Ubuntu 22.04 LTS (Jammy Jellyfish)](https://releases.ubuntu.com/22.04/),
[Ubuntu 20.04 LTS (Focal Fossa)](https://releases.ubuntu.com/20.04/),
[Debian 12 (Bookworm)](https://www.debian.org/releases/bookworm/),
and [Debian 11 (Bullseye)](https://www.debian.org/releases/bullseye/).

Every time some changes are committed on the
[project's GitHub repository](https://github.com/cpp-projects-showcase/docker-images),
the
[container images are automatically rebuilt](https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython/timeline)
and pushed onto Docker Cloud.

When some more components are needed, which may be of interest to other
C++ and Python developers, the Docker image may be amended so as to add
those extra components.
The preferred way to propose amendment of the Docker image is through
[pull requests on the GitHub project](https://github.com/cpp-projects-showcase/docker-images/pulls).
Once the pull request has been merged, _i.e._, once the `Dockerfile` amendment
has been
[committed in GitHub](https://github.com/cpp-projects-showcase/docker-images/commits/main),
Docker Cloud then rebuilds the corresponding container images, which become
available for every one to use.

## See also
* [Management of Python-related Docker images](https://github.com/python-helpers/docker-image-management)

# Images on Docker Cloud
* [Docker Cloud dashboard](https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython)

# Using the pre-built development images
* Start the Docker container featuring the target Linux distribution
  (`<linux-distrib>` may be one of `rocky9`, `centos9`, `centos8`,
  `fedora40`, `fedora39`, `debian12`, `debian11`,
  `ubuntu2404`, `ubuntu2204`, or `ubuntu2004`):
```bash
$ docker pull infrahelpers/cpppython:<linux-distrib>
$ docker run --rm -v ~/.ssh/id_rsa:/home/build/.ssh/id_rsa -v ~/.ssh/id_rsa.pub:/home/build/.ssh/id_rsa.pub -it infrahelpers/cpppython:<linux-distrib>
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
[build@5..0 opentrep (trunk)]$ export INSTALL_BASEDIR="${HOME}/dev/deliveries" && if [ -d /usr/lib64 ]; then LIBSUFFIX=64; fi && export LIBSUFFIX_4_CMAKE="-DLIB_SUFFIX=${LIBSUFFIX}"
[build@5..0 opentrep (trunk)]$ rm -rf build && mkdir build && cd build
[build@5..0 build (trunk)]$ cmake3 -DCMAKE_INSTALL_PREFIX=${INSTALL_BASEDIR}/opentrep-latest  -DCMAKE_BUILD_TYPE:STRING=Debug -DINSTALL_DOC:BOOL=OFF -DRUN_GCOV:BOOL=OFF ${LIBSUFFIX_4_CMAKE} ..
[build@5..0 build (trunk)]$ make install
[build@5..0 build (trunk)]$ ./opentrep/opentrep-indexer -t sqlite
[build@5..0 build (trunk)]$ ./opentrep/opentrep-searcher -t sqlite -q "nce sfo"
[build@5..0 build (trunk)]$ exit
```

# Customize a Docker Image
The images may be customized, and pushed to Docker Cloud;
`<linux-distrib>` may be one of `rocky9`, `centos9`, `centos8`,
`fedora40`, `fedora39`, `debian12`, `debian11`,
`ubuntu2404`, `ubuntu2204`, or `ubuntu2004`:
```bash
$ mkdir -p ~/dev
$ cd ~/dev
$ git clone https://github.com/cpp-projects-showcase/docker-images.git cpp-docker-images
$ cd cpp-docker-images
$ vi <linux-distrib>/Dockerfile
$ docker build -t infrahelpers/cpppython:<linux-distrib> <linux-distrib>/
$ docker run --rm -v ~/.ssh/id_rsa:/home/build/.ssh/id_rsa -v ~/.ssh/id_rsa.pub:/home/build/.ssh/id_rsa.pub -it infrahelpers/cpppython:<linux-distrib>
[build@9..d cpp-projects-showcase]$ exit
$ docker push infrahelpers/cpppython:<linux-distrib>
```

# TODO
Do not hestitate to create an issue
[on GitHub](https://github.com/cpp-projects-showcase/docker-images/issues):



