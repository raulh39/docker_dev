# HowTo:
#  See compose.yaml, otherwise:
#    docker build --build-arg USER_UID=$(id -u) --build-arg USER_NAME=$(id -un) -t devenv .
#    docker run -dit -p 3000:22 --name devenv --hostname devenv devenv:latest
#    ssh -p 3000 root@localhost
FROM ubuntu:24.04
LABEL Description="C++ Development environment"

ARG USER_UID=1111
ARG USER_NAME=ubuntu

SHELL ["/bin/bash", "-c"]

# ------------ Packages --------------
RUN apt-get update -y && apt-get -y --no-install-recommends install \
wget \
sudo \
clang \
clangd \
clang-format \
clang-tools \
cmake \
make \
ninja-build \
pipx \
neovim \
bat \
curl \
gdb \
less \
locales \
git \
openssh-server \
bat \
unminimize \
vivid \
file \
unzip \
build-essential \
python-dev-is-python3 \
neofetch \
software-properties-common \
man \
tree

RUN yes | unminimize

COPY config/locale /etc/default/locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# ------------ Unusual packages --------------
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    sudo install lazygit /usr/local/bin && \
    rm -rf lazygit.tar.gz lazygit

# RUN --mount=type=bind,source=./wezterm-nightly.Ubuntu24.04.deb,target=/root/wezterm-nightly.Ubuntu24.04.deb \
# apt-get -y --no-install-recommends install /root/wezterm-nightly.Ubuntu24.04.deb && \
# apt --fix-broken install

# ------------ sshd --------------
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# ------------ sudo access witout password --------------
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# -------------- Main user configuration --------------
COPY --chown=ubuntu:ubuntu config/bashrc /home/ubuntu/.bashrc
COPY --chown=ubuntu:ubuntu config/bash_aliases /home/ubuntu/.bash_aliases

RUN usermod -u ${USER_UID} -G sudo,root -l ${USER_NAME} -d /home/${USER_NAME} -m ubuntu
RUN echo "${USER_NAME}:${USER_NAME}" | chpasswd

# -------------- Main user programs --------------
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
    
RUN pipx install conan tldr virtualenv

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

RUN git config --global user.email "${USER_NAME}@fake.email.com"
RUN git config --global user.name "${USER_NAME}"
RUN .local/bin/conan profile detect
RUN echo -e '[conf]\ntools.cmake.cmaketoolchain:generator=Ninja' >> $(.local/bin/conan profile path default)

# -------------- sshd start by default --------------
USER root
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]
