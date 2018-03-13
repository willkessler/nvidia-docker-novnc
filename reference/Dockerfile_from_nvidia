# noVNC + TurboVNC + VirtualGL
# http://novnc.com
# https://turbovnc.org
# https://virtualgl.org

# xhost +si:localuser:root
# openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem
# docker build -t turbovnc .
# docker run --init --runtime=nvidia --name=turbovnc --rm -i -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -p 5901:5901 turbovnc
# docker exec -ti turbovnc vglrun glxspheres64

FROM nvidia/opengl:1.0-glvnd-runtime

# SOURCEFORGE=https://svwh.dl.sourceforge.net
ARG SOURCEFORGE=https://sourceforge.net/projects
ARG TURBOVNC_VERSION=2.1.2
ARG VIRTUALGL_VERSION=2.5.2
ARG LIBJPEG_VERSION=1.5.2
ARG WEBSOCKIFY_VERSION=0.8.0
ARG NOVNC_VERSION=1.0.0-beta

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        libc6-dev \
        libglu1 \
        libglu1:i386 \
        libsm6 \
        libxv1 \
        libxv1:i386 \
	lubuntu-desktop xterm terminator mesa-utils \
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

ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin

RUN curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt && \
    mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && \
    mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify && \
    ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html && \
    cd /opt/websockify && make

COPY self.pem /

RUN echo 'no-remote-connections\n\
no-httpd\n\
no-x11-tcp-connections\n\
no-pam-sessions\n\
permitted-security-types = otp\
' > /etc/turbovncserver-security.conf

EXPOSE 5901
ENV DISPLAY :1

ENTRYPOINT ["/opt/websockify/run", "5901", "--cert=/self.pem", "--ssl-only", "--web=/opt/noVNC", "--wrap-mode=ignore", "--", "vncserver", ":1", "-securitytypes", "otp", "-otp"]
#ENTRYPOINT ["/opt/websockify/run", "5901", "--cert=/self.pem", "--ssl-only", "--web=/opt/noVNC", "--wrap-mode=ignore", "--", "vncserver", ":1", "-securitytypes", "otp", "-otp", "-noxstartup"]
