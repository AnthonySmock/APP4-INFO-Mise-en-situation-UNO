var names = [];
var count=40;
var counter=setInterval(timer, 1000); //1000 will  run it every 1 second
var notre_tour=0;
var action = 0;
var pid=0,gid=0;
var change = 0;

function timer()
{
	gid = parseInt(sessionStorage.getItem("gid_partie"));
  pid = parseInt(sessionStorage.getItem("pid_joueur"));
  count=count-1;
  //alert(document.getElementById('span_gid').value);
	$.ajax({
		url: 'http://dev.asmock.com/api/state',
		dataType: "json",
		type: "POST", 
		data: JSON.stringify({ "pid": pid, "gid":gid }),
		success: function(data)
		{
			//alert(JSON.stringify(data));
			//alert(data.isYourTurn);


			if(data.isYourTurn == false)
			{
				change = 0;
				
				//alert("pas notre tour");
				notre_tour=0;
				//count = 0;
			}
			else
			{
				//alert("notre tour");
				notre_tour=1;
				if(change==0)
				{
					count = 30;
					change=1;
				}
				//count = 30;
			}

						if (typeof(data.othersNumberOfCards["1"]) != "undefined")
			{
			//code for what to do with json here
						document.getElementById("n1").innerHTML = data.othersNumberOfCards["1"]["username"];
			document.getElementById("nb1").innerHTML = data.othersNumberOfCards["1"]["numberOfCards"];
			}

						if (typeof(data.othersNumberOfCards["2"]) != "undefined")
			{
			//code for what to do with json here
						document.getElementById("n2").innerHTML = data.othersNumberOfCards["2"]["username"];
			document.getElementById("nb2").innerHTML = data.othersNumberOfCards["2"]["numberOfCards"];
			}

			if (typeof(data.othersNumberOfCards["3"]) != "undefined")
			{
			//code for what to do with json here
						document.getElementById("n3").innerHTML = data.othersNumberOfCards["3"]["username"];
			document.getElementById("nb3").innerHTML = data.othersNumberOfCards["3"]["numberOfCards"];
			}
			
			
			names = [];
			for(var i=0; i<data.yourCards.length; i++)
			{
				names.push(data.yourCards[i]["number"]+"_"+data.yourCards[i]["color"]+"_"+data.yourCards[i]["cid"]);
			}
			affichage();
			
			var existing_div1 = document.getElementById("uno-game"),
			new_div1 = document.createElement("div"),
			new_span1 = document.createElement("span"),
			new_span2 = document.createElement("span");
			
			var texte = "card num-"+data.upperCard["number"]+" "+data.upperCard["color"]; //"card num-6 red"
			
			if (typeof(data.upperCard["number"] != "undefined"))
			{
			$(existing_div1).empty();

			$(new_div1).addClass(texte);$(new_span1).addClass('inner');$(new_span2).addClass('mark').html(data.upperCard["number"]);
			$(new_span1).append($(new_span2));$(new_div1).append($(new_span1));$(existing_div1).append($(new_div1));
			}
		},
		error:function(request)
		 {          
			alert(request.responseText);
		 }
	});
  
  if(notre_tour == 1)
  {
	  $("#u4").css("pointer-events", "auto");
	  $('.card').css("pointer-events", "auto");
	  $("#sab").css("visibility", "visible");$("#sab").css("width", "100px"); $("#sab").css("height", "100px");
	  $("#stop").css("visibility", "hidden"); $("#stop").css("width", "0px"); $("#stop").css("height", "0px");
	  document.getElementById("timer").innerHTML=count + " secs"; // watch for spelling
  }
  if(count<=0)
  {
	  count = 0;
	  if(action==0) 
	  {
		  pioche();
	  }
	  $("#sab").css("visibility", "hidden");$("#sab").css("width", "0px"); $("#sab").css("height", "0px");
	  $("#stop").css("visibility", "visible");$("#stop").css("width", "100px"); $("#stop").css("height", "100px");
	  $("#u4").css("pointer-events", "none");
	  $('.card').css("pointer-events", "none");
	  document.getElementById("timer").innerHTML="Patienter"; // watch for spelling
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
				var cid = parseInt($(this).attr('title'));
				$.ajax({
					url: 'http://dev.asmock.com/api/action',
					dataType: "json",
					type: "POST", 
					data: JSON.stringify({ "pid": pid, "gid": gid,"action": "play", "cid":cid }),
					success: function(data)
					{
						//remove(texte,cid); //on enleve la carte de la main
						//alert("reussi jouer");
						action = 1;
						timer();
						count=0;
						//count=30;
						//notre_tour = 0;
					},
					error:function(request)
					 {   
						//alert("pas reussi jouer");
						       
						alert(request.responseText+"-cid: "+cid);
					 }
				});
			}
		});
}

function pioche() //draw
{

	
	$.ajax({
	url: 'http://dev.asmock.com/api/action',
	dataType: "json",
	type: "POST",
	data: JSON.stringify({ "pid": pid, "gid":gid, "action": "draw" }),
	success: function(data)
	{
		//alert(JSON.stringify(data) +"-draw"); 
		names.push(data["number"]+"_"+data["color"]+"_"+data["cid"]);
		affichage();
	},
	error:function(request)
	 {          
		alert(request.responseText);
	 }
	});
	
	action=1;
	//notre_tour = 0;
	count=0;
	timer();
}


$(document).ready(function()
{
	gid = parseInt(sessionStorage.getItem("gid_partie"));
  pid = parseInt(sessionStorage.getItem("pid_joueur"));
  console.log(gid);console.log(pid);
	//console.log("coucou");

	var json_obj;
	//console.log(document.getElementById("span_gid").value);
	/*$.ajax({
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
	error:function(request)
	{          
		//alert(request.responseText);
	}
	});*/
	
	$('#u4').click(function(e) {
		pioche();
	});
});
