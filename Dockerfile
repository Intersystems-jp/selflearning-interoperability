#イメージのタグはこちら（https://container.intersystems.com/contents）でご確認ください
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:latest-cd
FROM $IMAGE

USER ${ISC_PACKAGE_MGRUSER}

ENV SRCDIR=/irisdev/src
COPY ./src $SRCDIR/
COPY iris.script .

RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly