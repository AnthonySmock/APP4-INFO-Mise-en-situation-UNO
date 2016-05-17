$(document).ready(function()
{
	var names = [];
	names.push("4_red");
	names.push("4_blue");
	names.push("4_green");
	names.push("4_yellow");
	
	var existing_div1 = document.getElementById("my-cards");
	new_div1 = document.createElement("div"),
	new_span1 = document.createElement("span"),
	new_span2 = document.createElement("span");
	
	for( var i = 0; i < names.length; i++ ) {
		var nj = names[i].split('_');
		var texte = "card num-"+nj[0]+" "+nj[1];
		var num = nj[0];
		var new_div1 = document.createElement("div"),
		new_span1 = document.createElement("span"),
		new_span2 = document.createElement("span");
		
		
		$(new_div1).addClass(texte);
		$(new_span1).addClass('inner');
		$(new_span2).addClass('mark').html(num);
		$(new_span1).append($(new_span2));
		$(new_div1).append($(new_span1));
		$(existing_div1).append($(new_div1));
	}
});

$(document).ready(function()
{
	$('.card').click(function(e){
		$this = $(e.target);
		//alert($this.text()+"-"+$(this).attr('class'));
		var texte = $(this).attr('class');
		var num = $this.text();
		
		var div1 = $(this).parent().parent();
		var id = $(div1).attr('id'); 
		
		
		if(id=="uno-main")
		{
			//alert(id);
			var existing_div1 = document.getElementById("uno-game"),
			new_div1 = document.createElement("div"),
			new_span1 = document.createElement("span"),
			new_span2 = document.createElement("span");
			
			$(existing_div1).empty();
			$(new_div1).addClass(texte);
			$(new_span1).addClass('inner');
			$(new_span2).addClass('mark').html(num);
			$(new_span1).append($(new_span2));
			$(new_div1).append($(new_span1));
			$(existing_div1).append($(new_div1));
			
			//var existing_div2 = document.getElementById("my-cards");
			//var div_suppr = existing_div2.getElementById("my-cards")
		}
	});
	
	$('#u4').click(function(e) {  
		var existing_div1 = document.getElementById("my-cards"),
		new_div1 = document.createElement("div"),
		new_span1 = document.createElement("span"),
		new_span2 = document.createElement("span");
		
		$(new_div1).addClass("card num-8 blue");
		$(new_span1).addClass("inner");
		$(new_span2).addClass("mark");
		$(new_span2).text("8");
		
		$(new_span1).append($(new_span2));
		$(new_div1).append($(new_span1));
		$(existing_div1).append($(new_div1));
		//alert(1);
	});
});
