#!/bin/bash -l

# ====================================================================
# Edit namelist
# ====================================================================
# Get start and end times
syyyy=$1
smm=$2
sdd=$3
sHH=$4

eyyyy=$5
emm=$6
edd=$7
eHH=$8

px='FILE'

cp -f namelist.template2.wps namelist.wps

sed -i "s/syy/$syyyy/g" namelist.wps
sed -i "s/smm/$smm/g" namelist.wps
sed -i "s/sdd/$sdd/g" namelist.wps
sed -i "s/sHH/$sHH/g" namelist.wps

sed -i "s/eyy/$eyyyy/g" namelist.wps
sed -i "s/emm/$emm/g" namelist.wps
sed -i "s/edd/$edd/g" namelist.wps
sed -i "s/eHH/$eHH/g" namelist.wps

sed -i "s/px/$px/g" namelist.wps

./metgrid.exe



