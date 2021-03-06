gdal_version_major := "3"
gdal_version_minor := "4"
gdal_version_patch := "1"

geos_version_major := "3"
geos_version_minor := "10"
geos_version_patch := "1"

distribution_name := "bullseye"
image_name := "nmandery/gdal-minimal"

build:
    sudo docker build \
        --pull \
        --build-arg GDAL_VERSION={{gdal_version_major}}.{{gdal_version_minor}}.{{gdal_version_patch}} \
        --build-arg GEOS_VERSION={{geos_version_major}}.{{geos_version_minor}}.{{geos_version_patch}} \
        --build-arg CPUS=`cat /proc/cpuinfo | grep processor | wc -l` \
        -t "{{image_name}}:{{gdal_version_major}}-{{distribution_name}}" \
        -t "{{image_name}}:{{gdal_version_major}}.{{gdal_version_minor}}-{{distribution_name}}" \
        -t "{{image_name}}:{{gdal_version_major}}.{{gdal_version_minor}}.{{gdal_version_patch}}-{{distribution_name}}" \
        .

push-dockerhub: build
    sudo docker push "{{image_name}}:{{gdal_version_major}}-{{distribution_name}}"
    sudo docker push "{{image_name}}:{{gdal_version_major}}.{{gdal_version_minor}}-{{distribution_name}}"
    sudo docker push "{{image_name}}:{{gdal_version_major}}.{{gdal_version_minor}}.{{gdal_version_patch}}-{{distribution_name}}"


