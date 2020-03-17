fecha=`date "+%Y%m%d"`
for i in `perl maxidproceso.pl H`
do 
	archivo_pan=pan/pan_idProceso_${i}_${fecha}_hashtag.pan
	echo "nohup sh ejecucion_porUsuario.sh ${i} H & : `date`" >> ${archivo_pan}
    nohup sh ejecucion_porUsuario.sh ${i} H & >> ${archivo_pan}
done