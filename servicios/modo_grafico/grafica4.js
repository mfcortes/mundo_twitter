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
	
	
	for (qq=1;qq<=3;qq++)
	{
		paso="Hsla"+qq;
		carga_grafico_opcional(paso);
	}
	
	
});



function pueblaLabel()
{

	titulo['Hsla1']="Distribucion Incidentes Pendientes, Asignados y En Curso";
	labelEjeX['Hsla1']="Fecha";
	labelEjeY['Hsla1']="Q Tiket"; 
	tipoGraf['Hsla1']='line';
	stk['Hsla1']='';
	
	titulo['Hsla2']="Distribucion Incidentes Abiertos";
	labelEjeX['Hsla2']="Fecha";
	labelEjeY['Hsla2']="Q Tiket"; 
	tipoGraf['Hsla2']='line';
	stk['Hsla2']='';
	
	titulo['Hsla3']="Distribucion Incidentes Total generados";
	labelEjeX['Hsla3']="Fecha";
	labelEjeY['Hsla3']="Q Tiket"; 
	tipoGraf['Hsla3']='line';
	stk['Hsla3']='';
	
	titulo['Hsla4']="Distribucion Incidentes Abiertos vs Cerrados";
	labelEjeX['Hsla4']="Fecha";
	labelEjeY['Hsla4']="Q Tiket"; 
	tipoGraf['Hsla4']='line';
	stk['Hsla4']='';
		
}


function carga_grafico_opcional(pasoIdSeleccion)
{
	var option_master = {chart: {
		        renderTo: pasoIdSeleccion,
		        zoomType: 'x',
        		defaultSeriesType: tipoGraf[pasoIdSeleccion]
		    },
			title: {
        		text: titulo[pasoIdSeleccion]
  			},
		    rangeSelector: {
		        selected: 4
		    },
			xAxis: {
				title: {
					text: labelEjeX[pasoIdSeleccion]
				}
			},
		    yAxis: {
		    	title: {
					text: labelEjeY[pasoIdSeleccion]
				},
		    	plotLines: [{
		    		value: 0,
		    		width: 2,
		    		color: 'silver'
		    	}]
		    },
			plotOptions: {
				column: {
					stacking: stk[pasoIdSeleccion],
					dataLabels: {
						enabled: true,
						color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
					}
				}
			},
	    	legend: {
				layout: 'vertical',
				align: 'right',
				verticalAlign: 'top',
				borderWidth: 0
			},
		    tooltip: {
		    	pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> <br/>',
		    	valueDecimals: 0
		    },
		series: [
			]
		};
	
	
	
	//str_data="tipoAccion="+pasoIdSeleccion;
	str_data="tipoAccion="+pasoIdSeleccion+"&grafOdespliege=graf";
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
					//for (i=0;i<retorno[0].data.length;i++)
					//{
						//option_master.xAxis.categories.push(retorno[0]['data'][i]);
					//}
					for (i=1;i<retorno.length;i++)
					{	
						option_master.series.push(retorno[i]);
					}
			 	}		
			}
    });
    //var chart = new Highcharts.Chart(options3);
    			 
    //var chart2 = new Highcharts.StockChart(option_master);
    chart2 = new Highcharts.StockChart(option_master);
}