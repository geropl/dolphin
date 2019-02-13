FROM gitpod/workspace-full-vnc:latest

USER root

RUN apt-get update && apt-get install -yq \
        # Trial and error
        libxi-dev \
        ffmpeg \
        libgl-dev \
        libx11-dev \
        # Found on https://wiki.dolphin-emu.org/index.php?title=Building_Dolphin_on_Linux#Step_3_-_Building_Dolphin
        libwxbase3.0-dev \
        libwxgtk3.0-dev \
        libgtk2.0-dev \
        libxext-dev \
        libreadline-dev \
        libgl1-mesa-dev \
        libevdev-dev \
        libudev-dev \
        libavformat-dev \
        libavcodec-dev \
        libswscale-dev  \
        # Needed for ./qli-installer.py
        p7zip-full \
        # GPU driver and stuff
        libgl1-mesa-dri \
        #x11-xserver-utils \
        #x11vnc \
        #xinit \
        #xserver-xorg-video-dummy \
        #xserver-xorg-input-void \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

# We need QT, but for comsic (which gitpod/workspace-full is currently based) offers only 5.11
# Unfortuantely, since QT v5.10.1, it uses a syscall 'statx' that is not allowed in Docker (and thus Gitpod).
# Issue: https://bugreports.qt.io/browse/QTBUG-66930
# Thus we have to install QT 5.10.0 manually. Because the official Qt script turned out to be way too painful
# we go with https://lnj.gitlab.io/post/qli-installer/
USER gitpod
RUN mkdir /home/gitpod/qt
WORKDIR /home/gitpod/qt
RUN wget https://git.kaidan.im/lnj/qli-installer/raw/master/qli-installer.py
RUN chmod +x qli-installer.py
RUN pip install requests
RUN ./qli-installer.py 5.10.0 linux desktop
RUN echo 'export Qt5_DIR="/home/gitpod/qt/5.10.0/gcc_64/lib/cmake/Qt5"' >> /home/gitpod/.bashrc
RUN echo 'export QT_QPA_PLATFORM_PLUGIN_PATH="/home/gitpod/qt/5.10.0/gcc_64/plugins/platforms/"' >> /home/gitpod/.bashrc

USER root