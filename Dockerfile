FROM   debian:jessie

RUN   echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
      echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
      apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
      echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
      apt-get update && \
      apt-get install -y \
             build-essential  \
             curl  \
             lib32z1 \
             gcc-multilib  \
             git  \
             oracle-java8-installer \
             oracle-java8-set-default \
             vim  \
      && rm -rf /var/lib/apt/lists/* 

# Node JS
RUN  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash  \
    && export NVM_DIR="$HOME/.nvm"  \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  \
    && nvm install 6.9

ENV  NVM_DIR=$HOME/.nvm \
     NODE_PATH=$HOME

# Cordova ionic, etc
RUN npm install -g cordova ionic gulp bower

# Android
RUN curl http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | tar xz -C /usr/local/
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | /usr/local/android-sdk-linux/tools/android update sdk \
    --all --no-ui \
    --filter platform-tool,build-tools-23.0.3,android-23,addon-google_apis-google-23,extra-android-m2repository,extra-google-google_play_services,extra-google-m2repository
RUN find /usr/local/android-sdk-linux -perm 0744 | xargs chmod 755

# extra-android-support



# Workdir
RUN mkdir /src
WORKDIR /src
VOLUME  /src

# Expongo para ionic
EXPOSE  8100
