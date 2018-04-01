# noVNC + TurboVNC + VirtualGL
# Useful links for the software we are using:
# http://novnc.com
# https://turbovnc.org
# https://virtualgl.org

FROM nvidia/opengl:1.0-glvnd-runtime

ARG SOURCEFORGE=https://sourceforge.net/projects
ARG TURBOVNC_VERSION=2.1.2
ARG VIRTUALGL_VERSION=2.5.2
ARG LIBJPEG_VERSION=1.5.2
ARG WEBSOCKIFY_VERSION=0.8.0
ARG NOVNC_VERSION=1.0.0

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl wget emacs vim less sudo lsof net-tools git htop gedit gedit-plugins \
	unzip zip psmisc xz-utils \
	libglib2.0-0 libxext6 libsm6 libxrender1 \
	libpython-dev libsuitesparse-dev libeigen3-dev libsdl1.2-dev doxygen graphviz libignition-math2-dev \
        gcc \
        libc6-dev \
        libglu1 \
        libglu1:i386 \
        libxv1 \
        libxv1:i386 \
	lubuntu-desktop xvfb xterm terminator zenity mesa-utils \
        make cmake \
        python \
        python-numpy \
        x11-xkb-utils \
        xauth \
        xfonts-base \
        xkb-data && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    curl -fsSL -O ${SOURCEFORGE}/turbovnc/files/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
        -O ${SOURCEFORGE}/libjpeg-turbo/files/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
        -O ${SOURCEFORGE}/virtualgl/files/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
        -O ${SOURCEFORGE}/virtualgl/files/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i *.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver

# Install miniconda
RUN cd /tmp && \
    curl -fsSL -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod u+x Miniconda3-latest-Linux-x86_64.sh && \
    ./Miniconda3-latest-Linux-x86_64.sh -b

ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin

RUN curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt && \
    mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && \
    chmod -R a+w /opt/noVNC && \
    mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify && \
    cd /opt/websockify && make && \
    cd /opt/noVNC/utils && \
    ln -s /opt/websockify

COPY xorg.conf /etc/X11/xorg.conf
COPY index.html /opt/noVNC/index.html

# Defeat screen locking and power management
RUN mv /etc/xdg/autostart/light-locker.desktop /etc/xdg/autostart/light-locker.desktop_bak
RUN mv /etc/xdg/autostart/xfce4-power-manager.desktop /etc/xdg/autostart/xfce4-power-manager.desktop_bak

# Expose whatever port NoVNC will serve from. In our case it will be 40001, see ./start_desktop.sh
EXPOSE 40001
ENV DISPLAY :1

# Install desktop file for this user
RUN mkdir -p /root/Desktop
COPY ./firefox.desktop_applications /usr/share/applications/firefox.desktop
COPY ./terminator.desktop /root/Desktop
RUN mkdir -p /root/.config/terminator
COPY ./terminator_config /root/.config/terminator/config
COPY ./firefox.desktop /root/Desktop
COPY ./galculator.desktop /root/Desktop
COPY ./htop.desktop /root/Desktop
COPY ./self.pem /root/self.pem
# Precede bash on all new terminator shells with vglrun so that 3d graphics apps will use the GPU
RUN perl -pi -e 's/^Exec=terminator$/Exec=terminator -e "vglrun bash"/g' /usr/share/applications/terminator.desktop

# Install udacity desktop background (YMMV)
COPY ./background.png /usr/share/lubuntu/wallpapers/1604-lubuntu-default-wallpaper.png

RUN mkdir -p /root/.vnc
COPY ./xstartup.turbovnc /root/.vnc/xstartup.turbovnc
RUN chmod a+x /root/.vnc/xstartup.turbovnc

# Install ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > \
    /etc/apt/sources.list.d/ros-latest.list && \
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
    apt-get update -y && \
    apt-get install -y ros-kinetic-desktop-full && \
    apt-get install -y ros-kinetic-navigation && \
    apt-get install -y ros-kinetic-roscpp && \
    apt-get install -y ros-kinetic-joy && \
    apt-get install -y ros-kinetic-kobuki-safety-controller && \
    apt-get install -y ros-kinetic-yocs-velocity-smoother && \
    apt-get install -y ros-kinetic-turtlebot-bringup && \
    apt-get install -y ros-kinetic-geometry-msgs && \
    apt-get install -y ros-kinetic-yocs-cmd-vel-mux && \
    apt-get install -y ros-kinetic-diagnostic-aggregator && \
    apt-get install -y ros-kinetic-depthimage-to-laserscan && \
    apt-get install -y ros-kinetic-gazebo-ros && \
    apt-get install -y ros-kinetic-kobuki-gazebo-plugins && \
    apt-get install -y ros-kinetic-robot-pose-ekf && \
    apt-get install -y ros-kinetic-robot-state-publisher && \
    apt-get install -y ros-kinetic-turtlebot-description && \
    apt-get install -y ros-kinetic-turtlebot-navigation && \
    apt-get install -y ros-kinetic-xacro && \
    rosdep init && \
    rosdep update && \
    echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc

# Upgrade gazebo to gazebo v7
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update -y && apt-get install -y gazebo7

# Add miniconda to root's PATH
RUN echo "export PATH=/root/miniconda3:$PATH" >> /root/.bashrc

# Create some useful default aliases
RUN printf "%s\n" \
           "alias cp=\"cp -i\"" \
           "alias mv=\"mv -i\"" \
           "alias rm=\"rm -i\"" >> /root/.bash_aliases

COPY start_desktop.sh /usr/local/bin/start_desktop.sh

CMD /usr/local/bin/start_desktop.sh

