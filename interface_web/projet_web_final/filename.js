function routine(new_div1)
{
	new_div1.onclick = (function(e){
	$this = $(e.target);
	var texte = $(this).attr('class');
	var num = $this.text();
	
	var div1 = $(this).parent().parent();
	var id = $(div1).attr('id'); 
	
	
	if(id=="uno-main")
	{
		var existing_div1 = document.getElementById("uno-game"),
		new_div1 = document.createElement("div"),
		new_span1 = document.createElement("span"),
		new_span2 = document.createElement("span");
		
		$(existing_div1).empty();
		$(new_div1).addClass(texte);$(new_span1).addClass('inner');$(new_span2).addClass('mark').html(num);
		$(new_span1).append($(new_span2));$(new_div1).append($(new_span1));$(existing_div1).append($(new_div1));
		
		var existing_div2 = document.getElementById("my-cards");
		$(existing_div2).remove("."+texte);
	}
	});
}

function remove(new_div1, names)
{
	var classe = $(new_div1).attr('class').split(' ');
	var c1 = classe[1].split('-');
	//$(new_div1).addClass("card num-"+num+ " "+coul);
}

function affichage(names)
{
	var existing_div1 = document.getElementById("my-cards");
	new_div1 = document.createElement("div"),
	new_span1 = document.createElement("span"),
	new_span2 = document.createElement("span");
	
		for( var i = 0; i < names.length; i++ ) {
	var name = names[i].split('_');
	var texte = "card num-"+name[0]+" "+name[1];
	var num = name[0];
	var new_div1 = document.createElement("div"),
	new_span1 = document.createElement("span"),
	new_span2 = document.createElement("span");
	
	$(new_div1).addClass(texte);
	routine(new_div1);
	
	$(new_span1).addClass('inner');
	$(new_span2).addClass('mark').html(num);
	$(new_span1).append($(new_span2));
	$(new_div1).append($(new_span1));
	$(existing_div1).append($(new_div1));
	}
}

function pioche(num,coul)
{
	var existing_div1 = document.getElementById("my-cards"),
	new_div1 = document.createElement("div"),
	new_span1 = document.createElement("span"),
	new_span2 = document.createElement("span");
	
	$(new_div1).addClass("card num-"+num+ " "+coul);
	routine(new_div1);
	
	$(new_span1).addClass("inner");
	$(new_span2).addClass("mark");
	$(new_span2).text(num);
	
	$(new_span1).append($(new_span2));
	$(new_div1).append($(new_span1));
	$(existing_div1).append($(new_div1));
}


$(document).ready(function()
{
	var names = [];
	var json_obj;
	$.ajax({
	url: 'http://dev.asmock.com/api/carte',
	dataType: "json",
	success: function(data)
	{
		for(var i =0;i < data.carte.length;i++)
		{
			names.push(data.carte[i]["number"] +"_"+data.carte[i]["color"]);
		}
		affichage(names);
	},
	error:function()
	{          
		errorToConnect();
	}
	});
	
	$('.card').click(function(e){
	$this = $(e.target);
	var texte = $(this).attr('class');
	var num = $this.text();
	
	var div1 = $(this).parent().parent();
	var id = $(div1).attr('id'); 
	
	var existing_div1 = document.getElementById("uno-game"),
	new_div1 = document.createElement("div"),
	new_span1 = document.createElement("span"),
	new_span2 = document.createElement("span");
	
	routine(new_div1);
	remove(new_div1, names);
	});
	
	
	
	/*names.push("4_red");
	names.push("4_blue");
	names.push("4_green");
	names.push("4_yellow");*/
});

$(document).ready(function()
{

	
	$('#u4').click(function(e) {  
		pioche(6,"red");
	});
});
