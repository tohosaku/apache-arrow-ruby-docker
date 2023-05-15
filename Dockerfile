FROM ruby:3.2-slim-bullseye

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      gnupg \
      file \
      git \
      dialog \
      build-essential \
  && apt-get clean \
  && apt update \
  && apt install -y -V ca-certificates lsb-release wget \
  && wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
  && apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
  && apt update \
  && apt install -y -V libarrow-dev \
                       libarrow-glib-dev \
                       libarrow-dataset-dev \
                       libarrow-dataset-glib-dev \
                       libarrow-flight-dev \
                       libarrow-flight-glib-dev \
  && gem install red-arrow \
  && gem install red-parquet \
  && gem install red-arrow-dataset \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

WORKDIR /workspace
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
