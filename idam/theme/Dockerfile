ARG BASE_REGISTRY=registry1.dso.mil/ironbank
ARG BASE_IMAGE=redhat/ubi/ubi8-micro
ARG BASE_TAG=8.7

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

WORKDIR /app

# Create user / home directory for compliance
RUN echo "bigbang:x:1000:1000::/home/bigbang:/sbin/nologin" >> /etc/passwd \
    && mkdir -p /home/bigbang \
    && chmod 0750 /home/bigbang \
    && chown 1000:1000 /home/bigbang

COPY "###ZARF_VAR_THEME_FILE###" /app/

RUN chmod +rx "###ZARF_VAR_THEME_FILE###"

USER 1000:1000

HEALTHCHECK NONE
