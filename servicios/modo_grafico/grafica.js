var chart;
$(document).ready(function() {
 
    var options = {
		 chart: {
         renderTo: 'container',
         defaultSeriesType: 'column'
      	},

		title: {
        	text: 'Estadisticas Ticket'
  		},
        subtitle: {
        	text: 'Fuente Datos AR'
		},
        xAxis: {
            categories: [],
            title: {
                    text: null
                }
                
        },
		yAxis: {
			min: 0,
         	title: {
            	text: 'Q Ticket'
			}
        },
        plotOptions: {
                column: {
                    dataLabels: {
                        enabled: true
                    }
                }
            },
		legend: {
			layout: 'vertical',
			align: 'right',
			verticalAlign: 'top',
			x: -10,
			y: 100,
			borderWidth: 0
		},tooltip: {
                formatter: function() {
                    return ''+
                        this.x +': '+ this.y +' Ticket';
                }
            },
		series: [
		]
	}
		
	 var chart = new Highcharts.Chart(options);   
	
	$.ajax({
       		type: "GET"
        ,   async:false
        ,   cache:false
        ,   dataType:"json"
        ,   url: "http://localhost/indicadores/servidor/generaDatos.php" 
		,   success: function(retorno){
				for (i=0;i<retorno[0].data.length;i++)
				{
					options.xAxis.categories.push(retorno[0]['data'][i]);
				}
				for (i=1;i<retorno.length;i++)
				{	
					options.series.push(retorno[i]);
					alert(retorno[i].);
				}	  
			}
    });
    
   

});

            