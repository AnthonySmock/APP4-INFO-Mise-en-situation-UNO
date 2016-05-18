var names = [];
var count=75;

var counter=setInterval(timer, 1000); //1000 will  run it every 1 second

function timer()
{
  count=count-1;
  if(count>=45)
  {
	  $("#u4").css("pointer-events", "auto");
	  $('.card').css("pointer-events", "auto");
	  $("#sab").css("visibility", "visible");$("#sab").css("width", "100px"); $("#sab").css("height", "100px");
	  $("#stop").css("visibility", "hidden"); $("#stop").css("width", "0px"); $("#stop").css("height", "0px");
	   document.getElementById("timer").innerHTML=count-45 + " secs"; // watch for spelling
  }
  else
  {
	  $("#sab").css("visibility", "hidden");$("#sab").css("width", "0px"); $("#sab").css("height", "0px");
	  $("#stop").css("visibility", "visible");$("#stop").css("width", "100px"); $("#stop").css("height", "100px");
	   $("#u4").css("pointer-events", "none");
	   $('.card').css("pointer-events", "none");
	   document.getElementById("timer").innerHTML="Tour des autres"; // watch for spelling
  }
  
  if(count <=0)
  {
	  count = 75;
  }
}

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
		//alert(id);
		var existing_div1 = document.getElementById("uno-game"),
		new_div1 = document.createElement("div"),
		new_span1 = document.createElement("span"),
		new_span2 = document.createElement("span");
		
		$(existing_div1).empty();
		$(new_div1).addClass(texte);$(new_span1).addClass('inner');$(new_span2).addClass('mark').html(num);
		$(new_span1).append($(new_span2));$(new_div1).append($(new_span1));$(existing_div1).append($(new_div1));
	}
	});
}

function remove(texte)
{
	var names2 =[];
	var classe = texte.split(' ');
	var numb = classe[1].split('-');
	var num = numb[1];
	var coul = classe[2];
	var bl=0;
	for(var i =0;i < names.length;i++)
	{
		if(names[i] != num+"_"+coul)
		{
			names2.push(names[i]);
		}
		else
		{
			if(bl == 1)
			{
				names2.push(names[i]);
			}
			bl = 1;
		}
	}
	names=names2
	affichage();
}

function affichage()
{
	var existing_div1 = document.getElementById("my-cards");
	new_div1 = document.createElement("div"),
	new_span1 = document.createElement("span"),
	new_span2 = document.createElement("span");
	
	$(existing_div1).empty();
	for( var i = 0; i < names.length; i++ ) {
		var name = names[i].split('_');
		var texte = "card num-"+name[0]+" "+name[1];
		var num = name[0];
		var new_div1 = document.createElement("div"),new_span1 = document.createElement("span"),new_span2 = document.createElement("span");
		$(new_div1).addClass(texte);
		routine(new_div1);
		
		
		
		$(new_span1).addClass('inner');
		$(new_span2).addClass('mark').html(num);
		$(new_span1).append($(new_span2));
		$(new_div1).append($(new_span1));
		$(existing_div1).append($(new_div1));
	}
	
	$('.card').click(function(e){
		$this = $(e.target);
		var texte = $(this).attr('class');
		remove(texte);
		count = 45;
		});
}

function pioche(num,coul)
{
	count=45;
	timer();
	names.push(num+"_"+coul);
	affichage();
}


$(document).ready(function()
{
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
		affichage();
	},
	error:function()
	{          
		errorToConnect();
	}
	});
	
	$('#u4').click(function(e) {
		pioche(5,"green");
	});
});
