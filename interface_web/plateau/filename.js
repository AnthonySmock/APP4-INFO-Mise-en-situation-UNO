var names = [];
var count=10;
var counter=setInterval(timer, 1000); //1000 will  run it every 1 second
var action = 0;

function timer()
{
  count=count-1;
  
	$.ajax({
		url: 'http://dev.asmock.com/api/state',
		dataType: "json",
		type: "POST", 
		data: JSON.stringify({ "pid": 3, "gid":2 }),
		success: function(data)
		{
			document.getElementById("n1").innerHTML = data.othersNumberOfCards[0]["username"];
			document.getElementById("n2").innerHTML = data.othersNumberOfCards[1]["username"];
			document.getElementById("n3").innerHTML = data.othersNumberOfCards[2]["username"];
			
			document.getElementById("nb1").innerHTML = data.othersNumberOfCards[0]["numberOfCards"];
			document.getElementById("nb2").innerHTML = data.othersNumberOfCards[1]["numberOfCards"];
			document.getElementById("nb3").innerHTML = data.othersNumberOfCards[2]["numberOfCards"];
			
			/*names = [];
			for(var i=0; i<data.yourCards.length; i++)
			{
				names.push(data.yourCards[i]["number"]+"_"+data.yourCards[i]["color"]+"_"+data.yourCards[i]["cid"]);
			}
			affichage();*/
		},
		error:function(request)
		 {          
			alert(request.responseText);
		 }
	});
  
  if(count>=5)
  {
	  $("#u4").css("pointer-events", "auto");
	  $('.card').css("pointer-events", "auto");
	  $("#sab").css("visibility", "visible");$("#sab").css("width", "100px"); $("#sab").css("height", "100px");
	  $("#stop").css("visibility", "hidden"); $("#stop").css("width", "0px"); $("#stop").css("height", "0px");
	  document.getElementById("timer").innerHTML=count-45 + " secs"; // watch for spelling
  }
  else
  {
	  if(action==0)
	  {
		  pioche(6,"red");
	  }
	  $("#sab").css("visibility", "hidden");$("#sab").css("width", "0px"); $("#sab").css("height", "0px");
	  $("#stop").css("visibility", "visible");$("#stop").css("width", "100px"); $("#stop").css("height", "100px");
	   $("#u4").css("pointer-events", "none");
	   $('.card').css("pointer-events", "none");
	   document.getElementById("timer").innerHTML="Patienter"; // watch for spelling
  }
  
  if(count <=0)
  {
	  count = 10;
	  action = 0;
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

function remove(texte,cid)
{
	var names2 =[];
	var classe = texte.split(' ');
	var numb = classe[1].split('-');
	var num = numb[1];
	var coul = classe[2];
	var bl=0;
	for(var i =0;i < names.length;i++)
	{
		if(names[i] != num+"_"+coul+"_"+cid)
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
		$(new_div1).prop('title',name[2]); //set
		routine(new_div1);
		
		$(new_span1).addClass('inner');
		$(new_span2).addClass('mark').html(num);
		$(new_span1).append($(new_span2));
		$(new_div1).append($(new_span1));
		$(existing_div1).append($(new_div1));
	}
	
	$('.card').click(function(e){
			var div1 = $(this).parent().parent();
			var id = $(div1).attr('id');
			if(id=="uno-main") //play
			{
				$this = $(e.target);
				var texte = $(this).attr('class');
				var cid = $(this).attr('title');
				$.ajax({
					url: 'http://dev.asmock.com/api/action',
					dataType: "json",
					type: "POST", 
					data: JSON.stringify({ "action": "play", "cid":cid }),
					success: function(data)
					{
						remove(texte,cid); //on enleve la carte de la main
						action = 1;
				        count = 5;
					},
					error:function(request)
					 {          
						alert(request.responseText);
					 }
				});
			}
		});
}

function pioche(num,coul) //draw
{
	action=1;
	count=5;
	timer();
	
	$.ajax({
	url: 'http://dev.asmock.com/api/action',
	dataType: "json",
	type: "POST",
	data: JSON.stringify({ "action": "draw" }),
	success: function(data)
	{
		names.push(data["number"]+"_"+data["color"]+"_"+data["cid"]);
		affichage();
	},
	error:function(request)
	 {          
		alert(request.responseText);
	 }
	});
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
			names.push(data.carte[i]["number"] +"_"+data.carte[i]["color"]+"_"+i);
			//alert(JSON.stringify(data)); 
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
