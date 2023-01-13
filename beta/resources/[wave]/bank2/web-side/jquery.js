$(document).ready(function(){
	let actionContainer = $("#container");
	let actionButton = $("#container");

	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showMenu":
				requestesquerda();
				requestInicio();
				actionButton.fadeIn(100);
				actionContainer.fadeIn(100);
			break;

			case "hideMenu":
				actionButton.fadeOut(100);
				actionContainer.fadeOut(100);
			break;

			case "requestBank":
				requestesquerda();
			break;

			case "requestFines":
				requestFines();
			break;

			case "requestCredito":
				requestCredito();
			break;

			case "requestsacar":
				requestsacar();
			break;

			case "requestdepositar":
				requestdepositar();
			break;
			
			case "requestInvoices":
				requestInvoices();
			break;

			case "requestMyInvoices":
				requestMyInvoices();
			break;

			case "requestInicio":
				requestInicio();
				requestesquerda();
			break;
		}
	});

	$("#bancodreita").load("./inicio.html");

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://bank2/bankClose");
		}
	};
});

$('#actionbutton').click(function(e){
	$.post("http://bank2/bankClose");
});

$(document).on("click","#fecharporra",function(){
	$.post("http://bank2/bankClose");
});

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

const carregarMenu = (name) => {
	return new Promise((resolve) => {
		$("#bancodreita").load(name+".html",function(){
			resolve();
		});
	});
}

const requestesquerda = () => {
	$.post("http://bank2/requestBank",JSON.stringify({}),function(data){
		$("#boxesquerda").html(`            
		<div class="cartao">
		<h1>BEM VINDO DE VOLTA SR(A)</h1>
	</div>
	<div class="texto1">
		<img src="https://cdn.discordapp.com/attachments/865844588434423838/930724338229968976/Opcoes.png">
	</div>
	
	<div class="bank-left">
		<a href="#" onclick="carregarMenu('depositar');"><i class="fas fa-hand-holding-usd"></i><texto>DEPOSITAR</texto></a>
		<a href="#" onclick="carregarMenu('sacar');"><i class="fas fa-funnel-dollar"></i><texto>SACAR</texto></a>
		<a href="#" onclick="carregarMenu('multas');"><i class="fas fa-copy"></i><texto>MULTAS</texto></a>
		<a href="#" onclick="carregarMenu('credito');"><i class="fas fa-credit-card"></i><texto>CREDITO</texto></a>
	</div>`);
	});
}

const requestFines = () => {
	requestesquerda();
	$.post("http://bank2/requestFines",JSON.stringify({}),(data) => {
		let i = 0;
		const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
		zeromultas = false
		$('#bancodreita').html(`
		<div class="cartao3">
			<div class="multas2">
		${nameList.map((item) => (`
				<div class="format" data-id-key="${item.id}" data-price-key="${item.price}" data-idd-key="${i = i + 1}">
					<div class="multas-box" style="width:100%;">

					<div class="d-flex bd-highlight titulomultas style="width:100%; text-alig:center;">
					<div class="p-2 flex-fill bd-highlight">Valor</div>
					<div class="p-2 flex-fill bd-highlight">Quem Multou</div>
					<div class="p-2 flex-fill bd-highlight">Descrição</div>
				</div>

				<div class="d-flex bd-highlight" style="width:100%;"">
					<div class="p-2 flex-fill bd-highlight textomultas">$${formatarNumero(item.price)}</div>
					<div class="p-2 flex-fill bd-highlight textomultas">${item.nuser_id}</div>
					<div class="p-2 flex-fill bd-highlight textomultas">${item.text}</div>
				</div>	

					</div>
				</div>
		`)).join('')}
			</div>
			<center><div class="btn-multas">PAGAR SELECIONADA</div>	</center>
		</div>		
		`);
		if (i == 0) {
			$('#bancodreita').html(`
			<div class="cartao3">
				<div class="texto2">
					<h1>SEM MULTAS A PAGAR</h2>
				</div>
				<div>
				<a href="#" onclick="carregarMenu('inicio');"><div class="button" ><h1>CANCELAR</h1></i></div></a>
			</div>	
			</div>	
		`);
		 }
	});
}

$(document).on("click",".btn-multas",debounce(function(){
	let $el = $('.format.active');
	$.post("http://bank2/finesPayment",JSON.stringify({
		id: $el.attr('data-id-key'),
		price: $el.attr('data-price-key')
	}));
}));

const requestInvoices = () => {
	$.post("http://bank2/requestInvoices",JSON.stringify({}),(data) => {
		let i = 0;
		const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
		$('#bank-right').html(`
			<div class="title">FATURAS</div>
			<div class="faturas">PAGAR SELECIONADA</div>
			${nameList.map((item) => (`
				<div class="format" data-id-key="${item.id}" data-price-key="${item.price}" data-nuser_id-key="${item.nuser_id}">
					<div class="format-left">${i = i + 1}</div>
					<div class="format-right"><texto>${item.text}</texto><br><b>Valor:</b> $${formatarNumero(item.price)}   -   <b>Aplicado:</b> ${item.name}   -   <b>Data:</b> ${item.date}</div>
				</div>
			`)).join('')}
		`);
	});
}

$(document).on("click",".faturas",debounce(function(){
	let $el = $('.format.active');
	$.post("http://bank2/invoicesPayment",JSON.stringify({
		id: $el.attr('data-id-key'),
		price: $el.attr('data-price-key'),
		nuser_id: $el.attr('data-nuser_id-key')
	}));
}));

$(document).on("click",".format",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.format').removeClass('active');
	if(!isActive) $el.addClass('active');
});

const requestMyInvoices = () => {
	$.post("http://bank2/requestMyInvoices",JSON.stringify({}),(data) => {
		let i = 0;
		const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
		$('#bank-right').html(`
			<div class="title">MINHAS FATURAS</div>
			${nameList.map((item) => (`
				<div class="format" data-id-key="${item.id}">
					<div class="format-left">${i = i + 1}</div>
					<div class="format-right"><texto>${item.text}</texto><br><b>Valor:</b> $${formatarNumero(item.price)}   -   <b>Aplicado:</b> ${item.name}   -   <b>Data:</b> ${item.date}</div>
				</div>
			`)).join('')}
		`);
	});
}

const requestInicio = () => {
	requestesquerda();
	$.post("http://bank2/requestBank",JSON.stringify({}),function(data){
	if (data.horas > 7 & data.analise == 0 ) {	
		$('#bancodreita').html(`
				<div class="cartao2">
				<div class="texto2">
					<h1><b>`+ formatarNumero(data.resultado) +`</b></h1>
				</div>
				<form>
				<div>
					<input type="number" class ="input-ps" placeholder="PASSAPORTE" id="recebedor" required oninvalid="this.setCustomValidity('Digite um id para envio')"
					oninput="this.setCustomValidity('')">
				</div>
				<div>
					<input type="number" class ="input-ps2" placeholder="QUANTIA" id="valor" required oninvalid="this.setCustomValidity('Digite a quantidade para envio')"
					oninput="this.setCustomValidity('')">
				</div>
				<div class="alert alert-success" role="alert" style=" margin-top: 8%; background: transparent; font-size: 15px; border-radius: 0px; border: 2px solid #406882; color: #fff;">
				<center class="creditosla">
					Temos uma analise de crédito para você. <a href="#" onclick="carregarMenu('credito');" class="alert-link"><span>CLICK AQUI</span></a> e saiba mais.
				</center>
				</div>
				<div class="icon1">
					<img src="https://cdn.discordapp.com/attachments/509496822629269517/954888454192377916/Icon1.png" alt="" srcset="">
				</div>
				<div class="icon2">
					<img src="https://cdn.discordapp.com/attachments/509496822629269517/954888629245837342/Icon2.png" alt="" srcset="">
				</div>
				<div>
					<div class="transferir button" ><h1>CONFIRMAR</h1></i></div>
					<button type="cancel" id="fecharporra" class="button2" ><h1>CANCELAR</h1></i></button>
				</div>
				</div>
				</form>
			</div> `);
		} else {	
				$('#bancodreita').html(`
				<div class="cartao2">
				<div class="texto2">
					<h1><b>`+ formatarNumero(data.resultado) +`</b></h1>
				</div>
				<form>
				<div>
					<input type="number" class ="input-ps" placeholder="PASSAPORTE" id="recebedor" required oninvalid="this.setCustomValidity('Digite um id para envio')"
					oninput="this.setCustomValidity('')">
				</div>
				<div>
					<input type="text" class ="input-ps2" placeholder="QUANTIA" id="valor" required oninvalid="this.setCustomValidity('Digite a quantidade para envio')"
					oninput="this.setCustomValidity('')">
				</div>
				
				<div class="icon1">
					<img src="https://cdn.discordapp.com/attachments/509496822629269517/954888454192377916/Icon1.png" alt="" srcset="">
				</div>
				<div class="icon2">
					<img src="https://cdn.discordapp.com/attachments/509496822629269517/954888629245837342/Icon2.png" alt="" srcset="">
				</div>
				<div>
					<div class="transferir button" ><h1>CONFIRMAR</h1></i></div>
					<button type="cancel" id="fecharporra" class="button2" ><h1>CANCELAR</h1></i></button>
				</div>
				</div>
				</form>
			</div> `);	
		};	
	});
}


$(document).on("click",".transferir",debounce(function(){
	let destino = parseInt($('#recebedor').val());
	let deposito = parseInt($('#valor').val());
	if(deposito > 0) {
		$.post("http://bank2/banktransfer",JSON.stringify({ deposito,destino }));
	}
}));



const requestCredito= () => {
	
	$.post("http://bank2/requestBank",JSON.stringify({}),function(data){
		if (data.analise == 1) {
					
			$('#bancodreita').html(`
			<div class="cartao8">
			<div class="texto2">
			<div class="alert " role="alert" style="margin-top: 17%; background-color: #406882; font-size: 17px; color: #fff;  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; text-align: justify;">
				<h4 class="alert-heading">CRÉDITO EM ANÁLISE</h4>
				<hr>
				<p>Agora você precisa esperar que o nosso sistema faça sua analise de credito. Isso pode levar alguns dias ♥</p>
			
				<hr>
				Numero de propostas recusadas: <b>0`+ formatarNumero(data.recusas) +`</b> | Max de recusa: <b>05</b>
				</div>

				
			</div>
			<div>
			<a href="#" onclick="carregarMenu('inicio');"><div class="button" ><h1>CANCELAR</h1></i></div></a>
		</div>
		</div> `);

		} else {	

		if (data.horas > 14 & data.recusas < 6) {
			$('#bancodreita').html(`
					<div class="cartao7">
					<div class="solicite">
						<h1><center><input id="numerodemqs_input" class="form-control-range range_credito"  type="range" min="10000" max="500000" value=""></center></h1>
							<div id="resultado1">`+formatarNumero(250000)+`</div>
							<input type="hidden" class ="input-ps" placeholder="PASSAPORTE" id="creditodesejado" required oninvalid="this.setCustomValidity('Digite um id para envio')"
					oninput="this.setCustomValidity('')" value="250000">
							<div>
							<div class="credito2 button3" ><h1>SOLICITAR</h1></i></div>
							<a href="#" onclick="carregarMenu('inicio');"><button type="cancel" class="button4" ><h1>RECUSAR</h1></i></button></a>
						</div>
						</div>
					<script type="text/javascript">
					var inputvar = document.getElementById("numerodemqs_input"),
			 	number_mqs = document.getElementById("resultado1");
				inputvar.addEventListener("input", function() {
			  number_mqs.innerHTML = formatarNumero(inputvar.value);
			  document.getElementById("creditodesejado").value =  inputvar.value;
			}, false);
			
			/* Para deixar algo invisível */
			function displayNone(NoneId) {
				document.getElementById(NoneId).style.display = "none";
			  }
			  /* Para deixar algo visível */
			
			function displayBlock(BlockId) {
			  document.getElementById(BlockId).style.display = "block";
			}
				</script>

				</div> `);
				
			} else {	

			
				$('#bancodreita').html(`
				<div class="cartao8">
				<div class="texto2">
				<div class="alert alert-dark" role="alert" style="margin-top: 17%; background-color: #406882; font-size: 17px; color: #fff;  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; text-align: justify;">
					<h4 class="alert-heading">SEM MARGEM DE CRÉDITO</h4>
					<hr>
					<p>Você precisa melhorar sua margem para poder pegar um emprestimo em nosso banco. Neste momento não temos nenhuma proposta de emprestimo pré-liberada em seu nome.Para melhorar isso você precisa ter mais tempo em nossa cidade e talvez aduerir mais alguns bens  como casa, carro ou um emprego de carteira assinada.</p>
					<hr>
					</div>
				</div>
				<div>
				<a href="#" onclick="carregarMenu('inicio');"><div class="button" ><h1>CANCELAR</h1></i></div></a>
			</div>
			</div> `);

			};
		} }

			
	);

		$("#boxesquerda").html(` 

		<div class="cartao_credito">
				
		<h2 class="titulo_excredito">COMO FUNCIONA</h2>

		<p class="textocredito">A análise de crédito reúne todas as informações relevantes de uma determinada pessoa ou empresa, para que a 
		instituição financeira possa conceder ou não o limite de crédito que ela está precisando. Se a propsota for aprovada, você vai pagar parcelado com uma pequena taxa de juros de 12% a.m. Aqui, são avaliados os valores pedidos e a 
		capacidade financeira de pagamento. Após a solicitação, você passará por uma analise de um <b>banqueiro</b> e logo depois terá sua resposta.</p>

		<br>	
		<h2 class="titulo_excredito"> A ANALISE</h2>
		<p  class="textocredito">Sua analise pode demorar alguns dias. Então sempre verique o seu banco para saber o andar da sua solicitação. Você pode receber algumas ligações de nossos representantes para confirmação de dados e até mesmo uma reunião em nosso banco.</p>
		
		</div>

		<div class="bank-left">
			<a href="#" onclick="carregarMenu('depositar');"><i class="fas fa-hand-holding-usd"></i><texto>DEPOSITAR</texto></a>
			<a href="#" onclick="carregarMenu('sacar');"><i class="fas fa-funnel-dollar"></i><texto>SACAR</texto></a>
			<a href="#" onclick="carregarMenu('multas');"><i class="fas fa-copy"></i><texto>MULTAS</texto></a>
			<a href="#" onclick="carregarMenu('credito');"><i class="fas fa-credit-card"></i><texto>CREDITO</texto></a>
		</div>`);

}


$(document).on("click",".credito2",debounce(function(){
	let valor_desejado = parseInt($('#creditodesejado').val());
	if(valor_desejado > 0){
		$.post("http://bank2/bankcredito",JSON.stringify({ valor_desejado }));
	}
}));




const requestsacar = () => {
	requestesquerda();
	$.post("http://bank2/requestBank",JSON.stringify({}),function(data){
	$('#bancodreita').html(`
			<div class="cartao5">
			
			<form>
			<div>
				<input type="number" class ="input-ps3" placeholder="QUANTIA" id="saque" required oninvalid="this.setCustomValidity('Digite a quantidade para envio')"
				oninput="this.setCustomValidity('')">
			</div>
		
			<div class="icon3">
				<img src="https://cdn.discordapp.com/attachments/509496822629269517/954888629245837342/Icon2.png" alt="" srcset="">
			</div>
			<div>
				<div class="sacar button" ><h1>CONFIRMAR</h1></i></div>
				<a href="#" onclick="carregarMenu('inicio');"><button type="cancel" class="button2" ><h1>CANCELAR</h1></i></button></a>
			</div>
			</div>
			</form>
		</div> `);
	});
}


$(document).on("click",".sacar",debounce(function(){
	let saque = parseInt($('#saque').val());
	if(saque > 0){
		$.post("http://bank2/bankWithdraw",JSON.stringify({ saque }));
	}
}));


const requestdepositar = () => {
	requestesquerda();
	$.post("http://bank2/requestBank",JSON.stringify({}),function(data){
		$('#bancodreita').html(`
			<div class="cartao6">
			
			<form>
			<div>
				<input type="number" class ="input-ps3" placeholder="QUANTIA" id="deposito" required oninvalid="this.setCustomValidity('Digite a quantidade para envio')"
				oninput="this.setCustomValidity('')">
			</div>
		
			<div class="icon3">
				<img src="https://cdn.discordapp.com/attachments/509496822629269517/954888629245837342/Icon2.png" alt="" srcset="">
			</div>
			<div>
				<div class="depositar button" ><h1>CONFIRMAR</h1></i></div>
				<a href="#" onclick="carregarMenu('inicio');"><button type="cancel" class="button2" ><h1>CANCELAR</h1></i></button></a>
			</div>
			</div>
			</form>
		</div> `);
	});
}



$(document).on("click",".depositar",debounce(function(){
	let deposito = parseInt($('#deposito').val());
	if(deposito > 0){
		$.post("http://bank2/bankDeposit",JSON.stringify({ deposito }));
	}
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
		timeout = setTimeout(later,250)
		if (callNow) func.apply(context,args)
	}
}