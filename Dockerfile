FROM debian:bullseye-slim as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget \
        libcurl4-gnutls-dev \
        libgeos++-dev \
        libproj-dev \
        libexpat1-dev \
        libzstd-dev \
        liblzma-dev \
        zlib1g-dev \
        libspatialite-dev \
        build-essential \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ARG GDAL_VERSION=3.3.1

RUN cd /tmp && \
    wget https://github.com/OSGeo/gdal/releases/download/v${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    tar xf gdal-${GDAL_VERSION}.tar.gz

ARG CPUS=4

RUN cd /tmp/gdal-${GDAL_VERSION} && \
    ./configure \
        --disable-debug \
        --disable-static \
        --prefix=/usr/local \
        --with-sse \
        --with-avx \
        --with-liblzma \
        --with-freexl=no \
        --with-pcraster=no \
        --with-pcidsk=no \ 
        --without-jpeg12 \
        --enable-lto=yes \
        --disable-all-optional-drivers \
        --enable-driver-stacit \
        --enable-driver-stacta \
        --enable-driver-flatgeobuf \
        --enable-driver-shape \
        --enable-driver-gpkg && \
    make --quiet -j${CPUS} && \ 
    make --quiet install && \
    strip /usr/local/lib/*.so


FROM debian:bullseye-slim
COPY --from=builder /usr/local /usr/local
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        libcurl3-gnutls \
        libexpat1 \
        libgeos-3.9.0 \
        libgeos-c1v5 \
        libgeos-dev \ 
        libjbig0 \ 
        libjpeg62-turbo \ 
        libproj19 \ 
        libsqlite3-0 \
        libtiff5 \ 
        libspatialite7 \
        libtiffxx5 \
        zlib1g \
        proj-data && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ldconfig && \
    gdalinfo --formats && \
    ogrinfo --formats 
