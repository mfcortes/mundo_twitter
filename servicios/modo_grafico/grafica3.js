var chart;
var titulo = new Array();
var labelEjeX = new Array();
var labelEjeY = new Array();
var tipoGraf = new Array();
var lbMensaje = new Array();
var stk = new Array();
var vMin = new Array();
var Rot = new Array();
var Ali = new Array();

var ipServidor = "http://localhost/modulo_grafico/servidor/generaDatos.php";
           
//var ipServidor = "http://192.168.161.50/indicadores/servidor/generaDatos.php";
//var ipServidor = "http://172.28.209.53/indicadores/servidor/generaDatos.php";

$(document).ready(function() {
	var qq=0;
	// Se cargan Datos
	pueblaLabel();
	paso="graftwit";
	carga_grafico_opcional(paso);
	paso="graftwitfecha";
	carga_grafico_opcional(paso);
	
	
	
});



function pueblaLabel()
{

	titulo['graftwit']="TWITER";
	labelEjeX['graftwit']="Fecha";
	labelEjeY['graftwit']="Q Twitter"; 
	tipoGraf['graftwit']='column';
	//tipoGraf['sla1']='line';
	lbMensaje['graftwit']=' Twiter';
	stk['graftwit']='';
	vMin['graftwit']=0;
	Rot['graftwit']=0;
	Ali['graftwit']='center';
	
	titulo['graftwitfecha']="TWITER";
	labelEjeX['graftwitfecha']="Fecha";
	labelEjeY['graftwitfecha']="Q Twitter"; 
	tipoGraf['graftwitfecha']='line';
	lbMensaje['graftwit']=' Twiter';
	stk['graftwitfecha']='';
	vMin['graftwitfecha']=0;
	Rot['graftwitfecha']=0;
	Ali['graftwitfecha']='center';
	
}


function carga_grafico_opcional(pasoIdSeleccion)
{
	var options3 = {
		chart: {
        	renderTo: pasoIdSeleccion,
        	zoomType: 'xy',
        	defaultSeriesType: tipoGraf[pasoIdSeleccion],
     		borderWidth: 2,
      		plotShadow: true,
      		plotBorderWidth: 1
     	},
     	colors: [
	 		'#4572A7', 
			'#AA4643', 
			'#89A54E', 
			'#80699B', 
			'#3D96AE', 
			'#DB843D', 
			'#92A8CD', 
			'#A47D7C', 
			'#B5CA92'
		],
		title: {
        	text: titulo[pasoIdSeleccion]
  		},
    	subtitle: {
			text: 'Fuente Datos Twitter'
		},
		xAxis: {
			categories: [],
			title: {
				text: labelEjeX[pasoIdSeleccion]
			},
			labels: {
				align:Ali[pasoIdSeleccion],
                rotation: Rot[pasoIdSeleccion]
            }
		},
		yAxis: {
			min: vMin[pasoIdSeleccion],
			title: {
				text: labelEjeY[pasoIdSeleccion]
			}
		},
		plotOptions: {
			column: {
				stacking: stk[pasoIdSeleccion],
				dataLabels: {
					enabled: true
					, color: 'white'
				}
			},
			bar: {
				stacking: stk[pasoIdSeleccion],
				dataLabels: {
					enabled: true
					, color: 'white'
				}
			}
		},
			tooltip: {
			formatter: function() {
				return ''+
				this.x +'</b><br/>'+ this.series.name + '</b><br/>' +this.y +lbMensaje[pasoIdSeleccion];
			}
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
			  		for (i=0;i<retorno[0].data.length;i++)
					{
						options3.xAxis.categories.push(retorno[0]['data'][i]);
					}
					for (i=1;i<retorno.length;i++)
					{	
						options3.series.push(retorno[i]);
					}
			 	}		
			}
    });
    var chart = new Highcharts.Chart(options3);
    
}