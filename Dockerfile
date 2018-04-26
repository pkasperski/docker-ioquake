# build quake
FROM buildpack-deps:stretch as builder

ENV COPYDIR /server

WORKDIR /server
COPY ./server_compile.sh .

RUN apt-get update && apt-get install unzip && ./server_compile.sh && \
    curl https://raw.githubusercontent.com/nrempel/q3-server/master/baseq3/pak0.pk3 -o ./baseq3/pak0.pk3

RUN curl -o quake3-latest-pk3s.zip 'https://www.ioquake3.org/data/quake3-latest-pk3s.zip' -H 'Referer: https://ioquake3.org' && \
    unzip quake3-latest-pk3s.zip && \
    mv /server/quake3-latest-pk3s/baseq3/* /server/baseq3/ && \
    mv /server/quake3-latest-pk3s/missionpack/* /server/missionpack/ && \
    rm -rf quake3-latest-pk3s* && \
    curl -o cpma-1.50-nomaps.zip https://cdn.playmorepromode.com/files/latest/cpma-1.50-nomaps.zip && \
    unzip cpma-1.50-nomaps.zip && rm cpma-1.50-nomaps.zip && \
    curl -o cpma-mappack-full.zip https://cdn.playmorepromode.com/files/cpma-mappack-full.zip && \
    unzip -d /server/baseq3/ cpma-mappack-full.zip && rm cpma-mappack-full.zip && \
    wget https://raw.githubusercontent.com/ioquake/ioq3/master/misc/linux/start_server.sh && chmod +x start_server.sh

# server
FROM debian:stretch

EXPOSE 27960

COPY --from=builder /server /server
COPY ./configs/* /server/baseq3/

WORKDIR /server

ENTRYPOINT [ "./ioq3ded.x86_64", "+exec", "server.cfg", "+exec", "levels.cfg", "+exec", "bots.cfg" ]

