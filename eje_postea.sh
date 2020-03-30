id_proceso=2

Fecha=`date "+%Y%m%d"`
arch_log="log/Log_Postea_${Fecha}.log"
arch_adm="${0}_${Fecha}.adm"
echo "Inicio Proceso `date`" > $arch_log
echo "Arch ADM" > $arch_adm

# Se recuperan credenciales de twitter
string=`perl traecredenciales.pl ${id_proceso}`

while [ true ]
do
    echo "perl posteaTwits.pl : `date`" >>  $arch_log
    perl analitic1.pl >> $arch_log
    perl posteaTwits2.pl $string >> $arch_log
    
    if [ ! -s ${arch_adm} ]
    then
        echo "DOWN Proceso ``date``" >> "${arch_log}.down"
        exit 1
    fi
    sleep 300;
done
