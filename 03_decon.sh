#!/bin/bash

## script: decon.sh
### purpose: apply the predictive deconvolution to supprese the seimsic bubble/ghost
##4=hydrophone, 1=geophone

suplot="wbox=9 hbox=6"
inst=16

# reduction velocity (km/s)
vred=6.5





cd p01_2-30hz_filter




# for com in 1 4; do
for com in 4; do
	acfile=obx${inst}_${com}_autocorrelation.ps
	acfile2=obx${inst}_${com}_autocorrelation_after.ps
	deconfile=2-30_obx${inst}_${com}decon.su
	png=${acfile%.*}.png


	echo 'Currenst processing bp2-30_filt_sem4a.01.obx'${inst}'.'${com}'.su'

suacor ntout=1151 < bp2-30_filt_sem4a.01.obx${inst}.${com}.su | supsimage d2=1 f2=1 n1tic=5 n2tic=10 $suplot title="Autocorrelation before deconvolution" label1="Time (s)" label2="Trace" > $acfile
gmt psimage $acfile -Dx0.01i/0.01i+w5i > ${acfile%.*}.tmp
gmt psconvert ${acfile%.*}.tmp -A -Tj
rm ${acfile%.*}.tmp $acfile



	supef minlag=0.05 maxlag=0.13 < bp2-30_filt_sem4a.01.obx${inst}.${com}.su > $deconfile

	segyhdrs < $deconfile
	segywrite  tape="${deconfile%.*}".sgy endian=0 verbose=1 < $deconfile
	rm  binary header
	mv $deconfile "${deconfile%.*}".sgy ../p02_decon


suacor ntout=1151 < ../p02_decon/$deconfile | supsimage d2=1 f2=1 n1tic=5 n2tic=10 $suplot title="Autocorrelation after deconvolution" label1="Time (s)" label2="Trace" > $acfile2
gmt psimage $acfile2 -Dx0.01i/0.01i+w5i > ${acfile2%.*}.tmp
gmt psconvert ${acfile2%.*}.tmp -A -Tj
rm ${acfile2%.*}.tmp $acfile2






# supef minlag=0.05 maxlag=0.13 < bp3-25_filt_sem4a.01.obx${inst}.${com}.su | sureduce rv=6.5 | suwind tmin=1 tmax=4.8 | suximage perc=90 key=ep
sureduce rv=6.5 < bp2-30_filt_sem4a.01.obx${inst}.${com}.su | suwind tmin=1 tmax=4 | suximage perc=90 key=ep
sureduce rv=6.5 < ../p02_decon/$deconfile | suwind tmin=1 tmax=4 | suximage perc=90 key=ep

done