gdal_version_major := "3"
gdal_version_minor := "3"
gdal_version_patch := "1"
distribution_name := "bullseye"
image_name := "nmandery/gdal-minimal"

build:
    sudo docker build \
        --pull \
        --build-arg GDAL_VERSION={{gdal_version_major}}.{{gdal_version_minor}}.{{gdal_version_patch}} \
        --build-arg CPUS=`cat /proc/cpuinfo | grep processor | wc -l` \
        -t "{{image_name}}:{{gdal_version_major}}-{{distribution_name}}" \
        -t "{{image_name}}:{{gdal_version_major}}.{{gdal_version_minor}}-{{distribution_name}}" \
        -t "{{image_name}}:{{gdal_version_major}}.{{gdal_version_minor}}.{{gdal_version_patch}}-{{distribution_name}}" \
        .

push-dockerhub: build
    sudo docker push "{{image_name}}:{{gdal_version_major}}-{{distribution_name}}"
    sudo docker push "{{image_name}}:{{gdal_version_major}}.{{gdal_version_minor}}-{{distribution_name}}"
    sudo docker push "{{image_name}}:{{gdal_version_major}}.{{gdal_version_minor}}.{{gdal_version_patch}}-{{distribution_name}}"


