#!/bin/bash
lag=5
m=$(date --date="${lag}hours ago" "+%m")
echo $m
d=$(date --date="${lag} hours ago" "+%d")
echo $d
#d=30
hh=$(date --date="${lag} hours ago" "+%k")
aa=$(expr $hh)
a=$(expr $aa / 6)
b=$(expr $a \* 6)
h=$b;
if (( $b < 10 ));then h="0$b"; fi;
echo $h
cd /clusterfs2/WRF/DATA
cmd="rm -f GFSs_d*t${h}z*"
echo $cmd
eval $cmd

#fh="00"
for fh in {00..48..3}; do
	#.anl
	URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${h}z.pgrb2.0p25.f0${fh}&all_lev=on&all_var=on&subregion=&leftlon=-2&rightlon=31&toplat=67&bottomlat=52&dir=%2Fgfs.2023${m}${d}%2F${h}%2Fatmos"
echo $URL
#	if (( $fh ==00 ));then 
#		URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${h}z.pgrb2.0p25.anl&all_lev=on&all_var=on&subregion=&leftlon=0&rightlon=30&toplat=70&bottomlat=50&dir=%2Fgfs.2021${m}${d}%2F${h}%2Fatmos"
#	fi
	curl "$URL" -o GFSs_d${d}_t${h}z_${fh} 
done

