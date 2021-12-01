FROM debian:bullseye-slim as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget \
        libcurl4-gnutls-dev \
        libproj-dev \
        libexpat1-dev \
        libzstd-dev \
        liblzma-dev \
        zlib1g-dev \
        libspatialite-dev \
        build-essential \
        cmake \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ARG CPUS=4

# GEOS ###################################################

ARG GEOS_VERSION=3.10.1

RUN cd /tmp && \
    wget https://github.com/libgeos/geos/archive/refs/tags/${GEOS_VERSION}.tar.gz && \
    tar xf ${GEOS_VERSION}.tar.gz

RUN cd /tmp/geos-${GEOS_VERSION} && \
    mkdir build && \
    cd build && \
    cmake \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_PREFIX=/usr/local/ \
         -DBUILD_TESTING=OFF \
         -DBUILD_BENCHMARKS=OFF \
         -DBUILD_DOCUMENTATION=OFF \
         .. && \
	make --quiet -j${CPUS} && \ 
	make --quiet install && \
	find /usr/local -name '*.a' -delete && \
    strip /usr/local/lib/*.so


# GDAL ###################################################

ARG GDAL_VERSION=3.3.1

RUN cd /tmp && \
    wget https://github.com/OSGeo/gdal/releases/download/v${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    tar xf gdal-${GDAL_VERSION}.tar.gz


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
