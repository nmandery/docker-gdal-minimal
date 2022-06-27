FROM debian:bullseye-slim as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget \
        libcurl4-gnutls-dev \
        libexpat1-dev \
        libzstd-dev \
        liblzma-dev \
        libsqlite3-dev \
        sqlite3 \
        zlib1g-dev \
        libtiff-dev \
        build-essential \
        cmake \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ARG CPUS=4

# GEOS ###################################################

ARG GEOS_VERSION=3.10.2

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

# PROJ ###################################################

ARG PROJ_VERSION=9.0.0
RUN wget -q https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz \
    && tar -xzf proj-${PROJ_VERSION}.tar.gz \
    && cd proj-${PROJ_VERSION} \
    && mkdir build \
    && cd build \
    && cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_TESTING=OFF \
        -DENABLE_IPO=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ \
        .. \
    && make --quiet -j${CPUS} \
    && make --quiet install \
	&& find /usr/local -name '*.a' -delete \
    && strip /usr/local/lib/*.so


# GDAL ###################################################

ARG GDAL_VERSION=3.5.0

RUN cd /tmp && \
    wget https://github.com/OSGeo/gdal/releases/download/v${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    tar xf gdal-${GDAL_VERSION}.tar.gz


RUN cd /tmp/gdal-${GDAL_VERSION} \
    && mkdir b \
    && cd b \
    && cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_TESTING=OFF \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ \
        -DENABLE_IPO=ON \
        -DBUILD_APPS=ON \
        -DBUILD_SHARED_LIBS=ON \
        -DGDAL_USE_LERC_INTERNAL=ON \
        .. \
    && make --quiet -j${CPUS} \
    && make --quiet install \
	&& find /usr/local -name '*.a' -delete \
    && strip /usr/local/lib/*.so


FROM debian:bullseye-slim
COPY --from=builder /usr/local /usr/local
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        libcurl3-gnutls \
        libexpat1 \
        liblzma5 \
        libtiff5 \
        libsqlite3-0 \
        zlib1g && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ldconfig && \
    gdalinfo --formats && \
    ogrinfo --formats 
