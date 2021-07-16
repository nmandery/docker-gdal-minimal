# Docker `gdal-minimal` image

Somewhat small docker image containing [GDAL](https://gdal.org/) with only minimal dependencies compiled 
in to reduce the image size. Based on Debian `bullseye-slim` from the [official debian docker images](https://hub.docker.com/_/debian/).

The GDAL headers are included in the image to use it for compilation of other software, any other 
headers and dependencies can be installed via `apt`.

[Available on dockerhub](https://hub.docker.com/r/nmandery/gdal-minimal)

## Supported raster and vector formats

```
Supported Formats:
  VRT -raster,multidimensional raster- (rw+v): Virtual Raster
  DERIVED -raster- (ro): Derived datasets using VRT pixel functions
  GTiff -raster- (rw+vs): GeoTIFF
  COG -raster- (wv): Cloud optimized GeoTIFF generator
  HFA -raster- (rw+v): Erdas Imagine Images (.img)
  PNG -raster- (rwv): Portable Network Graphics
  JPEG -raster- (rwv): JPEG JFIF
  MEM -raster,multidimensional raster- (rw+): In Memory Raster
  GIF -raster- (rwv): Graphics Interchange Format (.gif)
  BIGGIF -raster- (rov): Graphics Interchange Format (.gif)
  PCIDSK -raster,vector- (rw+v): PCIDSK Database File
  GPKG -raster,vector- (rw+vs): GeoPackage
Supported Formats:
  PCIDSK -raster,vector- (rw+v): PCIDSK Database File
  ESRI Shapefile -vector- (rw+v): ESRI Shapefile
  MapInfo File -vector- (rw+v): MapInfo File
  OGR_VRT -vector- (rov): VRT - Virtual Datasource
  Memory -vector- (rw+): Memory
  KML -vector- (rw+v): Keyhole Markup Language (KML)
  GeoJSON -vector- (rw+v): GeoJSON
  GeoJSONSeq -vector- (rw+v): GeoJSON Sequence
  ESRIJSON -vector- (rov): ESRIJSON
  TopoJSON -vector- (rov): TopoJSON
  GPKG -raster,vector- (rw+vs): GeoPackage
  SQLite -vector- (rw+v): SQLite / Spatialite
  FlatGeobuf -vector- (rw+v): FlatGeobuf
```

## Building

... can be done using the [`just`](https://github.com/casey/just) command runner:


```
just build
```
