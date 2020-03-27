id_proceso=$1
tipo_criterio=$2

arch_adm="${0}_idProceso_${id_proceso}_${tipo_criterio}.adm"
arch_log="log/logLog_twitsPorUsuarios_idProceso_${id_proceso}_${tipo_criterio}.log" 
echo "Inicio Proceso idProceso=$id_proceso criterio= $tipo_criterio `date`" > ${arch_adm}

string=`perl traecredenciales.pl ${id_proceso}`
	
	
while [ true ]
do
    echo "**INICIO******perl parser2.pl ${string} ${tipo_criterio}: `date`" >> ${arch_log}
    
    #perl curl_opinion.pl 
    perl parser2.pl ${string} ${tipo_criterio}>> ${arch_log} 
    
    if [ ! -s ${arch_adm} ]
    then
    	echo "Down Proceso idProceso=$id_proceso `date`" >> "${arch_adm}.down"
    	exit 1
    fi 
    echo "**FIN******perl parser2.pl ${id_proceso} ${tipo_criterio} : `date`" >> ${arch_log}
    
    sleep 100; 
done



