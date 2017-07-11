FROM ros:lunar

MAINTAINER Markus Kohout <kohout@embedded.rwth-aachen.de>

RUN apt-get update -qq
RUN apt-get -y upgrade
RUN apt-get -y install build-essential software-properties-common cmake pkg-config
RUN apt-get -y install libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev
RUN apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN apt-get -y install libgtk2.0-dev wget zip unzip
RUN apt-get -y install libatlas-base-dev gfortran
RUN apt-get -y install python2.7-dev python3.5-dev python3-numpy

# Install OpenCV
RUN cd \
    && wget https://github.com/opencv/opencv/archive/3.2.0.zip \
    && unzip 3.2.0.zip \
    && cd opencv-3.2.0 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j3 \
    && make install \
    && cd \
    && rm 3.2.0.zip

# Install Pylon
RUN cd \
    && wget https://git.rwth-aachen.de/team_galaxis/archives/raw/master/basler/pylon-5.0.5.9000--RC8-x86_64.tar.gz \
    && gunzip pylon-*.tar.gz \
    && tar -xvf pylon-*.tar \
    && cd pylon-5.0.5.9000-x86_64 \
    && tar -C /opt -xzf pylonSDK*.tar.gz # \
    #&& ./setup-usb.sh -y

# Install Duo3D library
RUN cd \
    && wget https://git.rwth-aachen.de/team_galaxis/archives/raw/master/duo3d/CL-DUO3D-LIN-1.0.80.20.zip \
    && unzip "CL-DUO3D-LIN-1.0.80.20" \
    && cd CL-DUO3D-LIN-1.0.80.20/DUODriver \
    && cp duo-1024-4.4.0-64-generic.ko /lib/modules/$(uname -r)/kernel/drivers/duo.ko \
    && sh -c 'echo 'duo' >> /etc/modules' \
&& depmod

RUN rosdep init &&
    rosdep update
RUN echo "source /opt/ros/lunar/setup.bash" >> ~/.bashrc
RUN source ~/.bashrc