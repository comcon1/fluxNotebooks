#!/bin/bash

# CONVERSION SCRIPT
# --------------------------------
# PUT all *.raw files into ./raws
# CREATE ./mzmls folder for output

RAWFOLDER="raws"
MZMLFOLDER="mzmls"
IDDOCK=`id -u`:`id -g`

docker create -u ${IDDOCK} -v $PWD:/data_input --name=rawparser -it caetera/thermorawfileparser
docker start rawparser
DOCKRUN="docker exec rawparser mono /home/biodocker/TRFP/ThermoRawFileParser.exe"

for fn in `ls ${RAWFOLDER}/*.raw`
do
	fnb=`basename -s .raw $fn`
	stat ${RAWFOLDER}/$fnb.raw
    $DOCKRUN -i=/data_input/${RAWFOLDER}/$fnb.raw -b=/data_input/${MZMLFOLDER}/$fnb.mzML -f=2 -m=0 -z -L 1,2 -e -l=0
done


docker rm -f rawparser

