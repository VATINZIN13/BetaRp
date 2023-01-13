$(document).ready(function(){
	window.addEventListener('message',function(event){
		switch(event.data.action){
			case "openNUI":
				updateGarages();
				$("#actionmenu").fadeIn(100);
			break;

			case "closeNUI":
				$("#actionmenu").fadeOut(100);
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://garages/close");
		}
	};
});


/* --------------------------------------------------- */
const updateGarages = () => {
	$.post('http://garages/myVehicles',JSON.stringify({}),(data) => {
		const nameList = data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
		$('#garagem').html(`

		<div class="container2">

		<div class="princiap-box">
			<div class="box_logo">
				<div class="logo"><img src="logo.png" alt=""></div>
			</div>
			<div class="clearfix"></div>
		  <div class="box">
				<div id="lista_carros">
				  <div class="titulos">
						<img src="SuaGaragem.png" style="img-fluid" alt=""/> 
					</div>
					<div class="clearfix"></div>
					<div id="box_barra">
					${nameList.map((item) => (`
						<div class="item-garagem" data-name="${item.name}">
							<span class="nome-carro">${item.name2}</span>
							<div class="clearfix"></div>
							 <img src="http://177.54.144.212/vehicles/${item.name}.png" onError="this.onerror=null;this.src='https://cdn.discordapp.com/attachments/948782923002310676/957259644470976512/carrosem.png';" class="foto-carro" alt=""/>
							<div class="clearfix"></div>	
							<div class="box-infos">
								<h3>INFORMAÇÕES</h3>
								<span>Motor</span>
								<div class="progress" style="width: 80%; margin: 0 auto;">
								  <div class="progress-bar" role="progressbar" style="width: ${item.engine}%; background-color: #406882" aria-valuenow="${item.engine}" aria-valuemin="0" aria-valuemax="100">${item.engine}%</div>
								</div>
								<span>Chassi</span>
								<div class="progress" style="width: 80%; margin: 0 auto;">
								  <div class="progress-bar" role="progressbar" style="width: ${item.body}%;background-color: #406882" aria-valuenow="${item.body}%" aria-valuemin="0" aria-valuemax="100">${item.body}%</div>
								</div>
								<span>Gasolina</span>
								<div class="progress" style="width: 80%; margin: 0 auto;">
								  <div class="progress-bar" role="progressbar" style="width: ${item.fuel}%;background-color: #406882" aria-valuenow="${item.fuel}" aria-valuemin="0" aria-valuemax="100">${item.fuel}%</div>
								</div>
								<span class="badge badge-pill badge-success" style="margin-top: 15px;">Revisão em dia</span>

							</div>
						</div>
						`)).join('')}

				</div>				
				</div>

				<div id="publicidade">
					<div class="titulos">
						<img src="UltimasNovidades.png"  alt=""/> 
					</div>	
					<div class="clearfix"></div>
						<div class="box_slide">
							<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
								  <ol class="carousel-indicators">
									<li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
									<li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
									<li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
								  </ol>
								  <div class="carousel-inner" style="filter: drop-shadow(0 0 1.5rem rgba(0, 0, 0, 0.322));">
									<div class="carousel-item active">
									  <img class="d-block w-100" src="PorscheCayman.png" alt="Primeiro Slide">
									</div>
									<div class="carousel-item">
									  <img class="d-block w-100" src="BmwM8.png" alt="Segundo Slide">

									</div>
									<div class="carousel-item">
									  <img class="d-block w-100" src="slide.png" alt="Terceiro Slide">
									</div>
								  </div>
								  <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
									<span class="carousel-control-prev-icon" aria-hidden="true"></span>
									<span class="sr-only">Anterior</span>
								  </a>
								  <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
									<span class="carousel-control-next-icon" aria-hidden="true"></span>
									<span class="sr-only">Próximo</span>
								  </a>
							</div>
						</div>	

						<div class="box_btnc">
							<button type="button" class="btn  btn-aurora spawn" ><i class="fas fa-warehouse"></i> &nbsp; |&nbsp;&nbsp;   RETIRAR</button>
							<button type="button" class="btn  btn-aurora store" ><i class="fas fa-warehouse"></i> &nbsp; |&nbsp;&nbsp;   GUARDAR</button>
						</div>	

				  </div>

				</div>
			</div>
		</div>	
		`);
	});
}
/* --------------------------------------------------- */
$(document).on("click",".item-garagem",function(){
	let $el = $(this);
	let isActive = $el.hasClass("active");
	$(".item-garagem").removeClass("active");
	if(!isActive) $el.addClass("active");
});
/* --------------------------------------------------- */
$(document).on('click','.spawn',debounce(function(){
	let $el = $('.item-garagem.active').attr('data-name');
	if($el){
		$.post('http://garages/spawnVehicles',JSON.stringify({
			name: $el
		}));
	}
}));
/* --------------------------------------------------- */
$(document).on('click','.store',debounce(function(){
	$.post('http://garages/deleteVehicles');
}));
/* ----------DEBOUNCE---------- */
function debounce(func,immediate){
	var timeout
	return function(){
		var context = this,args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,500)
		if (callNow) func.apply(context,args)
	}
}