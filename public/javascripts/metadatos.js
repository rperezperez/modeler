
function guardar_y_cerrar(){
	$('formulario_ventana').submit();
}

 function grand(h, nombre) {
          iframe=document.getElementById(nombre);
          iframe.style.height=h+5+"px";
 }

 function redimensiona(nombre)
     {
		 iframe = this.document.getElementById(nombre);
		 height = iframe.contentDocument.body.scrollHeight;
		 iframe.style.height = height+90+"px";
     }

	 function redimensionar(iframe)
	     {
			
			 height = iframe.contentDocument.body.scrollHeight;
			 iframe.style.height = height+90+"px";
	     }

	function cerrar(){
		this.frameElement.blindUp();
	}

  function refrescar(id, campo)
  {
	  parent.document.getElementById(id).innerHTML = $(campo).value;

  }

function crearVentana(prefijo,id, donde)
{

		var elemento;
		$(prefijo+'_div_id_'+id).show();
		column = document.getElementById(prefijo+"_div_id_"+id);
		column.innerHTML = "";
		elemento = document.createElement('iframe');
		if (id != "-1"){
			elemento.setAttribute("src", donde+id);
		}else{
			elemento.setAttribute("src", donde);
		}
		elemento.setAttribute("onLoad", "setTimeout(\"redimensiona('"+prefijo+"_"+donde+"_id_"+id+"')\", 1000)")
 		//elemento.setAttribute("onLoad", "setTimeout(\"redimensionar(this)\", 1000)")
		elemento.setAttribute("onFocus", "redimensiona('"+prefijo+"_"+donde+"_id_"+id+"');")
		elemento.setAttribute("class", "marco");
		elemento.setAttribute("style", "display:none;");
		elemento.setAttribute("id",prefijo+"_"+donde+"_id_"+id);
		elemento.setAttribute("name",prefijo+"_"+donde+"_id_"+id);
		elemento.setAttribute("width", "100%");
		elemento.setAttribute("height", "100px;");		
		elemento.setAttribute("frameborder","0");

		column.appendChild(elemento);
}

function mostrarDireccion(prefijo,id,donde)
{
	//escondemos la fila
//	esconder(id,"tr");

	//creamos la ventana
	crearVentana(prefijo,id, donde);

	//mostramos la ventana
	mostrar(id,prefijo+"_"+donde);

//	redimensiona(prefijo+"_"+donde+"_id_"+id);

}

function mostrar(id, tipo)
{
	$(tipo+'_id_'+id).blindDown();
}

function esconder(id, tipo)
{
	$(tipo+'_id_'+id).fade();
}
