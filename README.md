# Dataset Container

This repository allows building containers containing a file based dataset.

## Usage

Use makefile `image` or `push` targets and provider necessary arguments:

- `SOURCE_DATA_DIR` - path to a directory with a dataset, assumed to be a name of a dataset
- `DATA_ARCHIVE` - path to an archived dataset used to calculated md5sum
- `DESCRIPTION` - short description of a dataset

Example:

~~~bash
make \
  SOURCE_DATA_DIR=clinical-trials-data-800k \
  DATA_ARCHIVE=clinical-trials-data-800k.tar.xz \
  DESCRIPTION="Clinical trials studies and data objects" \
  all
~~~

The images are pushed to [data-container](https://hub.docker.com/repository/docker/onedata/data-container) repository on [hub.docker.com](hub.docker.com).

## Attached Metadata

Each data container has matadatach attached to it in form of images labels and container environment variables. The list of metadata attached:

- `DATA_DIR` - location of a dataset in a container
- `NUMBER_OF_DIRECTORIES` - numer of directories inside of `DATA_DIR` (excluding `DATA_DIR`)
- `NUMBER_OF_FILES` - number of files inside of `DATA_DIR`
- `DESCRIPTION` - short description of a dataset

## Docker Image Naming Convention

Each dataset is published with 2 image tags latest and identified with it's md5sum, according to templates:

- `onedata/data-container:` `<dataset name>` `-` `latest`
- `onedata/data-container:` `<dataset name>` `-` `<md5hash of dataset archive>`

## Archive Preparation

The command used to prepare archives:

~~~bash
tar -cf - clinical-trials-data-800k  | xz -T 9 -9 -c - > clinical-trials-data-800k.tar.xz
~~~

## Published Datasets

| Description                                   | Dataset Link                                                                                           | Docker Image                                              |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------- |
| Full set of hf5 files with telescope metadata | [cta-hdf5-data-125k.tar.xz](https://drive.google.com/open?id=11yeHd78JVbJlL9CEhjE6bfSL7evW18xy)        | `onedata/data-container:cta-hdf5-data-125k-latest`        |
| A subset of hf5 files with telescope metadata | [cta-hdf5-data-30k.tar.xz](https://drive.google.com/open?id=164v3aU2dr9mmOGQTPga2lNoAQkQJ-65l)         | `onedata/data-container:cta-hdf5-data-30k-latest`         |
| Clinical trials studies and data objects      | [clinical-trials-data-800k.tar.xz](https://drive.google.com/open?id=1M0REkK4W0TgN3xMKuqCVvoqCq_p3UJbo) | `onedata/data-container:clinical-trials-data-800k-latest` |
| Covid related studies and data objects        | [covid-data-10k.tar.xz](https://drive.google.com/open?id=1VNH5Dj72-gdXDMCgqE-DOEwlSZVKcC3s)            | `onedata/data-container:clinical-trials-data-800k-latest` |
