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
    && nvm install 6.9 \
    && curl https://www.npmjs.org/install.sh -L | /bin/bash -

ENV  NVM_DIR=$HOME/.nvm \
     NODE_PATH=$HOME  \


# Cordova ionic, etc
RUN  /bin/bash -l -c "npm install -g cordova ionic gulp bower"

# Android
# extra-android-support
ENV ANDROID_HOME=/usr/local/android-sdk-linux  \
    PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools"

RUN curl http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | tar xz -C /usr/local/  \
   && ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | /usr/local/android-sdk-linux/tools/android update sdk \
    --all --no-ui \
    --filter platform-tools,build-tools-25.0.2,android-25,android-24,addon-google_apis-google-24,extra-android-m2repository,extra-google-google_play_services,extra-google-m2repository  \
   && find /usr/local/android-sdk-linux -perm 0744 | xargs chmod 755



ADD  android-sdk.sh  /etc/profile.d/

# seteos finales.
RUN   mkdir /src 
WORKDIR /src
ENTRYPOINT  ["/bin/bash", "-l", "-c", "$0 $@" ]

# Expongo para ionic
EXPOSE  8100
