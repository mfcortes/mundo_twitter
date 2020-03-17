var chart2;
var titulo = new Array();
var labelEjeX = new Array();
var labelEjeY = new Array();
var tipoGraf = new Array();
var stk = new Array();



//var ipServidor = "http://localhost/indicadores/servidor/generaDatos.php";
           
var ipServidor = "http://192.168.161.50/indicadores/servidor/generaDatos.php";
//var ipServidor = "http://172.28.209.53/indicadores/servidor/generaDatos.php";

$(document).ready(function() {
	var qq=0;
	// Se cargan Datos
	pueblaLabel();
	
	
	for (qq=1;qq<=1;qq++)
	{
		paso="Msla"+qq;
		carga_grafico_opcional(paso);
	}
	
	
});



function pueblaLabel()
{

	titulo['Msla1']="Distribucion acumulada incidentes";
	labelEjeX['Msla1']="Fecha";
	labelEjeY['Msla1']="Q Tiket"; 
	tipoGraf['Msla1']='line';
	stk['Msla1']='';
	
		
}


function carga_grafico_opcional(pasoIdSeleccion)
{
	var option_inicio = {chart: {
		        renderTo: pasoIdSeleccion
		    },
			title: {
        		text: titulo[pasoIdSeleccion]
  			},
  			plotOptions: {
				pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
                        }
                    }
                   }
			},
		    tooltip: {
		    	pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> <br/>',
		    	valueDecimals: 0
		    },
		series: [
			]
		};
	
	
	
	str_data="tipoAccion="+pasoIdSeleccion;
	$.ajax({
       		type: "GET"
       	, 	data: str_data
        ,   async:false
        ,   cache:false
        ,   dataType:"json"
        ,   url: ipServidor 
		,   success: function(retorno){
				if (typeof retorno[0].data != 'undefined')
			  	{
					
					for (i=1;i<retorno.length;i++)
					{	
						option_inicio.series.push(retorno[i]);
					}
			 	}		
			}
    });
    //var chart = new Highcharts.Chart(options3);
    			 
    //var chart2 = new Highcharts.StockChart(option_master);
    chart2 = new Highcharts.Chart(option_inicio);
}