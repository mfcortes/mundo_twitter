var chart;
var menu = $("ul.dropdown");

 $(document).ready(function() {
 
	menu.mouseover(function(){
		displayOptions($(this).find("li"));
	});
	menu.mouseout(function(){
		hideOptions($(this));
	});

	//funcion que MUESTRA todos los elementos del menu
	function displayOptions(e){
		e.show();
	}
	//funcion que OCULTA los elementos del menu
	function hideOptions(e){
		e.find("li").hide();
		e.find("li.active").show();
	} 


});
