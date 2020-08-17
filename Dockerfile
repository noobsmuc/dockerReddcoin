 FROM debian:jessie-20200607-slim as base

LABEL name="noobsmuc/reddcoin" \
      description="reddcoin on jessie image ready for staking"

ARG GIT_COMMIT_ID=39088ca
ENV SLEEPNUMBERANDSUFFIX="20m"
ENV PASSWORDPHRASE=''

WORKDIR /

#https://superuser.com/questions/987788/openssl-not-found-during-configure
RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive"  apt-get install -y \
    nano libboost-all-dev

FROM base as source

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive"  apt-get install -y \
    build-essential libtool autotools-dev wget git autoconf pkg-config libdb++-dev libssl-dev libssl1.0.0 bsdmainutils 

RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz \
    && tar -xzvf db-4.8.30.NC.tar.gz \
    && cd db-4.8.30.NC/build_unix \
    && ../dist/configure --enable-cxx \
    && make \
    && make install \
    && cd / \
    && rm db-4.8.30.NC.tar.gz \
    && cd /

RUN git clone https://github.com/reddcoin-project/reddcoin \
    && cd reddcoin \
    && git checkout $GIT_COMMIT_ID \
    && export CPATH="/usr/local/BerkeleyDB.4.8/include" \
    && export LIBRARY_PATH="/usr/local/BerkeleyDB.4.8/lib" \
    && export LD_LIBRARY_PATH="/usr/local/BerkeleyDB.4.8/lib" \
    && ./autogen.sh \
    && ./configure LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/" --with-gui=no \
    && make \
    && make install \
    && cd /

FROM base as final
RUN mkdir /root/.reddcoin \
    && rm -rf /reddcoin /var/lib/apt/lists/* \ 
    && cd /
 
WORKDIR /
 COPY --from=source /usr/local/BerkeleyDB.4.8 /usr/local/BerkeleyDB.4.8
 COPY --from=source /usr/local/bin/reddcoin* /usr/local/bin/

COPY ["/files/reddcoinCheck.sh", "./"]
RUN chmod 755 /reddcoinCheck.sh

VOLUME /root/.reddcoin

CMD ["bin/bash","/reddcoinCheck.sh"]
