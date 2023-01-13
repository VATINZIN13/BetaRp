const TattooStore = {
	currentCategory: null,
	selectedTattoos: {},
	categories: {
		"head": { "title": "Cabeça", "available": [] },
		"torso": { "title": "Torso", "available": [] },
		"leftarm": { "title": "Braço Esquerdo", "available": [] },
		"rightarm": { "title": "Braço Direito", "available": [] },
		"leftleg": { "title": "Perna Esquerda", "available": [] },
		"rightleg": { "title": "Perna Direita", "available": [] },
		"hair": { "title": "Micropigmentação", "available": [] }
	},
	changeCategory: function(category){
		$(".option").removeClass("active");
		TattooStore.currentCategory = category;
		$(".option[category-name='"+category+"']").addClass("active");
		$("#category-name").html(TattooStore.categories[category]["title"]);

		$("#items").html("");
		$.each(TattooStore.categories[category]["available"],function(index,tattoo){
			let selected =  "";
			let label = index + 1;

			if(TattooStore.selectedTattoos[tattoo.name])
				selected = " selected";

			$("#items").append(`
				<div class="item${selected}" tattoo-code="${tattoo.name}" tattoo-category="${category}" tattoo-index="${index}">
					<div class="icon"><img src="http://45.162.228.208/baixada/tattoo/${category}/${tattoo.name}.jpg"></div>
					<div class="itemContent">
						<small>Numeração da tatuagem</small>
						<span>${label >= 100 ? label : '<b>0</b>' + label}</span>
						<div class="check"><i class="fa-light fa-circle-check"></i></div>
					</div>
				</div>
			`);
		});

		TattooStore.loadVariableListeners();
	},
	selectTattoo: function(category,index){
		let item = $(".item[tattoo-category='"+category+"'][tattoo-index='"+index+"']");
		if(item.hasClass("selected")){
			item.removeClass("selected");
			delete TattooStore.selectedTattoos[item.attr("tattoo-code")];
		} else {
			TattooStore.selectedTattoos[item.attr("tattoo-code")] = {};
			item.addClass("selected");
		}

		TattooStore.callServer("changeTattoo",{ type: category, id: index });
	},
	resetTattoos: function(){
		$(".item").removeClass("selected");

		TattooStore.selectedTattoos = {};
		TattooStore.callServer("limpaTattoo",{});
	},
	loadStaticListeners: function(){
		$(".option").on("click",function(){
			TattooStore.changeCategory($(this).attr("category-name"));
		});

		$("#save").on("click",function(){
			$("body").fadeOut();
			TattooStore.callServer("close",{});
		});

		$("#reset").on("click",function(){
			TattooStore.resetTattoos();
		});

		document.onkeydown = function(data) {
			switch(data.keyCode) {
				case 27:
					$("body").fadeOut();
					TattooStore.callServer("close",{});
				break;

				case 68:
					TattooStore.callServer("rotate","left");
				break;

				case 65:
					TattooStore.callServer("rotate","right");
				break;

				case 88:
					TattooStore.callServer("handsup",{});
				break;
			}
		};
	},
	loadVariableListeners: function(){
		$(".item").on("click",function(){
			TattooStore.selectTattoo($(this).attr("tattoo-category"),$(this).attr("tattoo-index"));
		});
	},
	callServer: function(endpoint,data){
		$.post("http://tattoos/"+endpoint,JSON.stringify(data));
	},
	load: function(tattoos,selectedTattoos){
		TattooStore.categories = {
			"head": { "title": "Cabeça", "available": [] },
			"torso": { "title": "Torso", "available": [] },
			"leftarm": { "title": "Braço Esquerdo", "available": [] },
			"rightarm": { "title": "Braço Direito", "available": [] },
			"leftleg": { "title": "Perna Esquerda", "available": [] },
			"rightleg": { "title": "Perna Direita", "available": [] },
			"hair": { "title": "Micropigmentação", "available": [] }
		};

		$("body").fadeIn();
		TattooStore.selectedTattoos = selectedTattoos;
		$.each(tattoos,function(category,element){
			$.each(element.tattoo,function(index,tattoo){
				TattooStore.categories[category]["available"].push(tattoo);
			});
		});

		TattooStore.changeCategory("head");
		TattooStore.loadStaticListeners();
	}
};

$('.sectionContent').on("scroll", function() {
	var posicaoScroll = $(this).scrollTop();
	posicaoScroll ? $('#infoRoll').fadeOut() : $('#infoRoll').fadeIn();
});

window.addEventListener("message",function(event){
	TattooStore.load(event.data.shop,event.data.tattoo);
});