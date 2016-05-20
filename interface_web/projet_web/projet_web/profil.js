
$(document).ready(function(){


    $("#submit_connection").click(function(){
       if( $('#username').val() == "" || $('#password').val() == ""  )
            {
                alert("Erreur, ressayez !")
            }
            else
            {
               var $username = String($('#username').val());
               var $password = String($('#password').val());
        	$.ajax({
                    	url: 'http://dev.asmock.com/api/connection',
                    	dataType: "json",
                      type: "POST",
                      data:JSON.stringify({ "username" : $username, "password" : $password }),
                    	success: function(data)
                    	{
                        console.log(data[0]["pid"])
                        sessionStorage.setItem("pid_joueur",data[0]["pid"]);
                        alert("Connexion reussie !")          
                        document.location.href="home.html"

                    	},
                    	error:function()
                    	{          
                    		alert("Erreur connexion ")
                    	}
        	       });
        }
    });

//Inscription ok

    $("#submit_inscription").click(function(){

            if($('#password_inscription').val() !=  $('#password_inscription_verif').val() 
              || $('#password_inscription').val() == "" || $('#username_inscription').val() == ""  )
            {
                alert("Erreur, ressayez !")
            }
        else
          {
              var $username = String($('#username_inscription').val());
              var $password = String($('#password_inscription').val());

          	$.ajax({
              	url: 'http://dev.asmock.com/api/subscribe',
                  dataType: "json",
                  type: "post",
                  data:JSON.stringify({ "username" : $username, "password" : $password }),

                      	success: function(data)
                      	{
                          alert("Inscription reussie !")
                          console.log(data.username)
                          document.location.href="home.html"
                      	},
                      	error:function()
                      	 {        
                            alert("Erreur, ressayez !")  
                      	 }
          	   });
          }
    });


//Liste parties  ok

            $.ajax({
            url: 'http://dev.asmock.com/api/game',
            dataType: "json",
            type: "GET",
          //  data: "a", 
            success: function(data)
            {

        $.each(data, function(index, value) {
        $('#list_partie').append('<option value="'+ index +'">'+ 'Partie:   '+ value.gameName +'    |Joueurs En attente:   '+  value.playerWaiting +'    |Joueurs Max:   '+  value.maxPlayer +'      |Password:   '+  value.isPasswordSet +'</option>');
        $('#list_partie').value =value.gameName;
    });

            },
            error:function()
            {          
            }
            });




//choix partie  


    $("#submit_choix_partie").click(function(){
      
      $.ajax({
      url: 'http://dev.asmock.com/api/game',
      dataType: "json",
      type: "GET",
      success: function(data)
      {
        $gid = data[document.getElementById("list_partie").selectedIndex].gid;
         sessionStorage.setItem("gid_partie",$gid);
      },
      error:function()
      {          
      }
      });


       var $gid      = String(sessionStorage.getItem("gid_partie"));
       var $pid      = String(sessionStorage.getItem("pid_joueur"));

          $.ajax({
              url: 'http://dev.asmock.com/api/play',
              dataType: "json",
              type: "post",
              data : JSON.stringify({ "pid" : $pid, "gid" : $gid,  "password" : "" }),
              success: function(data)
                  {
                    alert("La partie a bien été choisie !!")  
                    location.replace("plateau/index.html");  
                   
                  },
              error:function()
                  {   
                    alert("Erreur, choisissez une autre partie !")  
                  }
          });

          console.log(sessionStorage.getItem("gid_partie"))
            });



//creation partie

   $("#create_partie").click(function(){

   console.log("hey");


     var $password =        String($('#password_partie').val());
     var $gamename =        String($('#nom_partie').val());
     var $nombre_joueurs =  String($('#nombre_joueurs').val());
     var $pid =             String(sessionStorage.getItem("pid_joueur"));

      $.ajax({
      url: 'http://dev.asmock.com/api/game',
      dataType: "json",
      type: "post",
      data : JSON.stringify({ "pid" : $pid, "gameName" : $gamename,  "gamePassword" : $password,  "maxPlayer" : $nombre_joueurs  }),
        success: function(data)
        {
          alert(' Votre partie a bien été crée ! :-) ')
          console.log("data"+ data.gid)
           sessionStorage.setItem("gid_partie",data.gid);
          document.location.href="plateau/index.html"
        },
          error:function()
          {        
           alert(' Erreur, ressayez ! ')  
          }
      });
    });




   $("#create_partie").click(function(){

          var $pid      = String(sessionStorage.getItem("pid_joueur"));
       
          $.ajax({
          url: 'http://dev.asmock.com/api/profil',
          dataType: "json",
          type: "post",
          data : JSON.stringify({ "pid" : $pid }),
            success: function(data)
            {
              document.getElementById('game_won').innerHTML = data.gameWon
              document.getElementById('game_played').innerHTML = data.gameWon
            },
              error:function()
              {          
                  
              }
          });
   });



});


