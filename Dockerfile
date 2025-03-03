# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.19 as buildstage

ARG MOD_VERSION

RUN \
  echo "**** grab rffmpeg ****" && \
  mkdir -p /root-layer/usr/local/bin/ && \
  MOD_VERSION=${MOD_VERSION:-master} && \
  curl -fo \
    /root-layer/usr/local/bin/rffmpeg -L \
    "https://raw.githubusercontent.com/joshuaboniface/rffmpeg/${MOD_VERSION}/rffmpeg" && \
  chmod +x /root-layer/usr/local/bin/rffmpeg

# copy local files
COPY root/ /root-layer/

## Single layer deployed image ##
FROM scratch

LABEL maintainer="junkman690"

# Add files from buildstage
COPY --from=buildstage /root-layer/ /
