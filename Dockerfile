#イメージのタグはこちら（https://hub.docker.com/_/intersystems-iris-data-platform）でご確認ください
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2021.1.0.215.3
ARG IMAGE=store/intersystems/iris-community:2021.1.0.215.3
FROM $IMAGE

USER root
RUN apt-get update
RUN apt-get -y install locales && \
   localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# jdbc related 
RUN DEBIAN_FRONTEND=noninteractive apt -y install openjdk-8-jre \
 && apt clean

###########################################
#### Set up the irisowner account and load application
USER ${ISC_PACKAGE_MGRUSER}


ENV SRCDIR=/irisdev/src
COPY ./src $SRCDIR/

RUN  iris start $ISC_PACKAGE_INSTANCENAME \ 
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") Do ##class(Security.Users).UnExpireUserPasswords("*") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'Set tSC=$system.OBJ.Load("'$SRCDIR'/Installer.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'set tSC=##class(ZSelflearning.Installer).RunInstall("'$SRCDIR'") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly
