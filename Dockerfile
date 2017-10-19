FROM ros:kinetic-ros-base

MAINTAINER Markus Kohout <kohout@embedded.rwth-aachen.de>

ADD /python_packages.txt /python_packages.txt

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install build-essential cmake pkg-config \
	                libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev \
	                libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
	                libgtk2.0-dev wget zip unzip python-pip \
	                libatlas-base-dev gfortran ocl-icd-opencl-dev \
	                python2.7-dev \
                    ros-kinetic-perception

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

# Install Python Packages
RUN pip install -r /python_packages.txt

RUN rosdep update

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"

