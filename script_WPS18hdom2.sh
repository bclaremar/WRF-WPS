#!/bin/bash
#source var.sh

cd /clusterfs2/WRF/WPS

DIR=/clusterfs/software/lib
export PATH=$DIR/netcdf_4.1.3/install/bin:$PATH
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
export PATH=$DIR/grib2/lib:$PATH
opt=1
##opt=2 ungrib of SST
#opt=3 ungrib of ERA-Interim
#opt=4 metgrid of ERA-Interim

m=$(date --date="6 hours ago" "+%m")

d=$(date --date="6 hours ago" "+%d")
echo $d
hh=$(date --date="6 hours ago" "+%k")
#aa=$(expr $hh - 2)
a=$(expr $hh / 6)
b=$(expr $a \* 6)
h=$b;
if (( $b < 10 ));then h="0$b"; fi;
echo $h

yys=2021
mms=$m
dds=$d
hhs=$h
yye=2021
mme=$mms
dde=$(expr $d ) 
if (( $b > 0 ));then dde=$(expr $dde + 1); fi;
if (( ${dde#0} < 10 )); then dde="0${dde#0}";fi;
if (( ${dde#0} > 31 )); then 
	dde=01
	mme=$(expr $mms + 1)
        mme="0${mme#0}"
fi
hhe=$(expr $b + 18 )
if (( $hhe > 18 ));then hhe=$(expr $hhe - 24); fi;
if (( $hhe < 10 )); then hhe="0$hhe";fi;        


echo $dde
echo $hhe
#exit
#cd /clusterfs/software/WRF/build/WPS-4.2
if [ "$opt" -eq 1 -o "$opt" -eq 3 ];then

#ungrib gfs data
echo "----------------------------------------------------"
echo "ungrib gfs data"
echo ""
files="../DATA/GFSd${dds}_t${hhs}*"
l=0
while [ $l -lt 7 ]
do
	l=0
	for i in $(ls $files)
	do
#		echo $i
		l=$[$l+1]
	done
	echo $l
	if [ $l -lt 7 ];then
		sleep 300
	fi
done

sd=($(ls -l $files | awk '{print $5}'))
echo $sd
t=0
j=0
for i in ${sd[0]}
do
    
    echo $i
#    echo $t
    if [ $i -lt 490000000 ];then
        echo "$t is too small file"
	if [ $t -lt 10 ];then
		fh="0${t}"
	else
		fh=$t
	fi
	cd ../DATA
        cmd="curl -s --disable-epsv --connect-timeout 60 -u anonymous:bjorn.claremar@uppmax.uu.se -o GFSd${dds}_t${hhs}z_${fh} https://www.ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.2021${mms}${dds}/${hhs}/atmos/gfs.t${hhs}z.pgrb2.0p25.f0${fh}"
        echo $cmd
        eval $cmd >& error.log
	cd ../WPS

    fi
    t=$[$t+3]
done
echo "GFS download fix is done!"
#exit

./link_grib.csh ../DATA/GFSd${dds}_t${hhs}*
./run_ungrib.sh $yys $mms $dds $hhs $yye $mme $dde $hhe
echo "----------------------------------------------------"
fi
if [ "$opt" -eq 1 -o "$opt" -eq 4 ];then

#metgrid gfs data 
echo "----------------------------------------------------"
echo "metgrid GFS data"
echo ""

./run_metgrid_dom2.sh $yys $mms $dds $hhs $yye $mme $dde $hhe
#ln -sf met_em.d0*.$yys-$mms* ../WRF/run

../WRF_dmpar/run/script_WRF_dom2.sh

fi

