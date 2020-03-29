FROM busybox

LABEL maintainer="Michal Orzechowski <orzechowski.michal@gmail.com>"

# Location of the dataset on host machine
ARG SOURCE_DATA_DIR
# Number of files in a dataset
ARG NUMBER_OF_FILES
# Number of directories in a dataset
ARG NUMBER_OF_DIRECTORIES
# Description of a dataset
ARG DESCRIPTION

# Location of dataset in a created image
LABEL data-dir=/data
LABEL number-of-directories=${NUMBER_OF_DIRECTORIES}
LABEL number-of-files=${NUMBER_OF_FILES}
LABEL description="${DESCRIPTION}"

ENV DATA_DIR=/data
ENV NUMBER_OF_DIRECTORIES=${NUMBER_OF_DIRECTORIES}
ENV NUMBER_OF_FILES=${NUMBER_OF_FILES}
ENV DESCRIPTION="${DESCRIPTION}"

RUN mkdir /data
COPY "${SOURCE_DATA_DIR}/" /data/
