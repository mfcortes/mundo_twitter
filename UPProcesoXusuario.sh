fecha=`date "+%Y%m%d"`
for i in `perl maxidproceso.pl U`
do 
	archivo_pan=pan/pan_idProceso_${i}_${fecha}.pan
	echo "nohup sh ejecucion_porUsuario.sh ${i} U & : `date`" >> ${archivo_pan}
    nohup sh ejecucion_porUsuario.sh ${i} U & >> ${archivo_pan}
done