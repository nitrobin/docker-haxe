FROM debian:jessie
MAINTAINER nitrobin

ENV DEBIAN_FRONTEND noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Dependencies
RUN apt-get update \
    && apt-get install -y \
          wget \
          g++ g++-multilib libgc-dev \
          python3 \
          php5-cli \
    && apt-get clean


# Haxe environment variables
ENV HAXEVERSION 3.2.1
ENV HAXEURL http://haxe.org/website-content/downloads/$HAXEVERSION/downloads/haxe-$HAXEVERSION-linux64.tar.gz
ENV HAXEPATH /opt/haxe
ENV HAXE_STD_PATH $HAXEPATH/std/
ENV PATH $HAXEPATH:$PATH
ENV HAXELIB_PATH /opt/haxelib

# Neko environment variables
ENV NEKOVERSION 2.0.0
ENV NEKOURL http://nekovm.org/_media/neko-$NEKOVERSION-linux64.tar.gz
ENV NEKOPATH /opt/neko
ENV LD_LIBRARY_PATH $NEKOPATH
ENV PATH $NEKOPATH:$PATH

# Node environment variables
ENV NODEVERSION 4.2.3
ENV NODEURL https://nodejs.org/dist/v$NODEVERSION/node-v$NODEVERSION-linux-x64.tar.gz
ENV NODEPATH /opt/node
ENV PATH $NODEPATH/bin:$PATH

RUN mkdir -p $NODEPATH $NEKOPATH $HAXEPATH

# Download Node.js
RUN wget -O - $NODEURL | tar xzf - --strip=1 -C $NODEPATH

# Download Neko
RUN wget -O - $NEKOURL | tar xzf - --strip=1 -C $NEKOPATH

# Download Haxe
RUN wget -O - $HAXEURL | tar xzf - --strip=1 -C $HAXEPATH

# Haxelib setup
RUN mkdir -p $HAXELIB_PATH
RUN echo $HAXELIB_PATH > /root/.haxelib && cp /root/.haxelib /etc/

#Install haxe libraries
RUN yes|haxelib install hxcpp 3.2.193

RUN yes|haxelib install lime 2.7.0 \
 && yes|haxelib install openfl 3.4.0 \
 && yes|haxelib install format 3.2.1 \
 && yes|haxelib install actuate 1.8.6\
 && yes|haxelib install hscript 2.0.5
 
RUN yes|haxelib install msignal 1.2.2 \
 && yes|haxelib install tjson 1.4.0 \
 && yes|haxelib install inthebox-macros 1.2.0 \
 && yes|haxelib install protohx 0.4.6

# workaround for https://github.com/HaxeFoundation/haxe/issues/3912
ENV HAXE_STD_PATH $HAXE_STD_PATH:.:/

# Scripts
ADD scripts /root/scripts

# Test
ADD test /root/test
#WORKDIR /root/test
RUN /root/test/verify.sh

ENV ANDROIDSDKVERSION 24.3.4
ENV ANDROIDSDKURL http://dl.google.com/android/android-sdk_r$ANDROIDSDKVERSION-linux.tgz
#ENV ANDROIDSDKURL http://exchange/install/android-sdk-ndk/android-sdk_r$ANDROIDSDKVERSION-linux.tgz
ENV ANDROIDSDKPATH /opt/android-sdk
RUN mkdir -p $ANDROIDSDKPATH
RUN wget -O - $ANDROIDSDKURL | tar xzf - --strip=1 -C $ANDROIDSDKPATH


ENV ANDROIDNDKVERSION 10e
ENV ANDROIDNDKURL http://dl.google.com/android/ndk/android-ndk-r$ANDROIDNDKVERSION-linux-x86_64.bin
#ENV ANDROIDNDKURL http://exchange/install/android-sdk-ndk/android-ndk-r$ANDROIDNDKVERSION-linux-x86_64.bin
ENV ANDROIDNDKPATH /opt/android-ndk
RUN cd /opt && wget -v -O /opt/android-ndk.bin $ANDROIDNDKURL \
    && chmod a+x /opt/android-ndk.bin && /opt/android-ndk.bin \
    && rm -f /opt/android-ndk.bin && ln -s android-ndk-r$ANDROIDNDKVERSION android-ndk


CMD ["/bin/bash"]
