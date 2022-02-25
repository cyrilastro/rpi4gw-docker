FROM arm64v8/debian:bullseye

LABEL version="1.0"

ARG USER_ID
ARG GROUP_ID

#Import variables
ENV VCPKG_FORCE_SYSTEM_BINARIES=1
ENV GCC_PATH="/opt/xpack-arm-none-eabi-gcc-10.3.1-2.3/bin/"
ENV OPENOCD="/opt/openocd-git/bin/openocd"
ENV ADAPTER=rpi
ENV PATH=$PATH:/opt/xpack-arm-none-eabi-gcc-10.3.1-2.3/bin/
ENV PATH=/home/user/.local/bin:$PATH

RUN apt-get update -qy && apt-get upgrade -y && apt-get install -y \
        python python3 python3-venv python3-pip libncurses5 python3-gpiozero \
        git wget vim \
        npm binutils-arm-none-eabi libftdi1 \
        curl zip unzip tar sed \
        ninja-build sudo snapd
#Flush aptitude cache & temp dir
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add host user UID/GID account, home folder and sudo
RUN groupadd -f -g $GROUP_ID user
RUN useradd -u $USER_ID -g $GROUP_ID -s /bin/bash -d /home/user -m user
RUN usermod -aG sudo user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#cmake install
WORKDIR /opt
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2-linux-aarch64.sh
RUN chmod +x cmake-3.22.2-linux-aarch64.sh
RUN bash cmake-3.22.2-linux-aarch64.sh --include-subdir --skip-license
RUN ln -s /opt/cmake-3.22.2-linux-aarch64/bin/* /usr/local/bin
RUN rm cmake-3.22.2-linux-aarch64.sh

#Patched OPENOCD install
RUN git clone https://github.com/kbeckmann/ubuntu-openocd-git-builder.git
WORKDIR /opt/ubuntu-openocd-git-builder
RUN chmod +x build.sh
RUN ./build.sh
RUN dpkg -i openocd-git_*_arm64.deb
RUN apt-get -y -f install

#vcpkg install
WORKDIR /opt
RUN git clone https://github.com/microsoft/vcpkg
RUN ./vcpkg/bootstrap-vcpkg.sh

#Keystone-core engine via vcpkg
RUN ./vcpkg/vcpkg install keystone

#GCC install
RUN wget https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v10.3.1-2.3/xpack-arm-none-eabi-gcc-10.3.1-2.3-linux-arm64.tar.gz
RUN tar -xvf xpack-arm-none-eabi-gcc-10.3.1-2.3-linux-arm64.tar.gz
RUN rm xpack-arm-none-eabi-gcc-10.3.1-2.3-linux-arm64.tar.gz

WORKDIR /home/user

#Install Python packages for retro-go repo
RUN python3 -m pip install lz4 pillow tqdm xxhash zopflipy pyelftools
#Install Python packages for Brian patch repo
RUN python3 -m pip install Pillow colorama keystone-engine numpy pycrypto
#Install Python packages for LCD Game Shrinker repo
RUN python3 -m pip install Pillow lxml lz4 numpy patool pyunpack svgutils

#Copy init script
COPY build_env.sh .
RUN chmod +x build_env.sh

# Initialisation
CMD ["bash"]





