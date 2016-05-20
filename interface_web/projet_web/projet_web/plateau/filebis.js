var pID;

// connection

// \{ \"username\" \:  ' + username + ' \,
//                                 \"password\" \: '+ password + '
//                                  \}'


$(document).ready(function(){
	
	
	


    $("#submit_connection").click(function(){

     var username = "\"" +$('#username').val()+"\"";
     var password = "\"" +$('#password').val()+"\"";

            $.ajax({
                        url: 'http://dev.asmock.com/api/connection',
                        dataType: "json",
                      type: "POST",
                       data: JSON.stringify({"username" : username,
                                             "password" : password}) ,
                        success: function(data)
                        {
                     //   alert("jb");
                          //alert(JSON.stringify(data));

                       document.getElementById('span_pid').value =data[0]["pid"];
                       //console.log(document.getElementById('span_pid').value)
                        },
                        error:function()
                        {          
                            // errorToConnect();
                        }
                   });
    });


//Inscription

/*    $("#submit_inscription").click(function(){

            if($('#password_inscription').val() !=  $('#password_inscription_verif').val() )
            {
                alert("Erreur : mot de pass pas identiques !")
            }
        else
        {
            var username = "\"" +$('#username_inscription').val()+"\"";
            var password = "\"" +$('#password_inscription').val()+"\"";

            $.ajax({
                url: 'http://dev.asmock.com/api/subscribe',
                dataType: "json",
                type: "POST",
                data: JSON.stringify({"username" : username,
                                      "password" : password}) ,
                        success: function(data)
                        {
                        alert('Registration Successful');    
                        },
                        error:function()
                         {          
                            //errorToConnect();
                          }
               });
        }
    });*/


//Liste parties


        $("#list_partie").click(function(){
            console.log("coucou")
          

            $.ajax({
            url: 'http://dev.asmock.com/api/game',
            dataType: "json",
            type: "GET",
          //  data: "a",
            success: function(data)
                {
                //  alert(data[0]["gid"] +"-"+ data.length);

                   //alert(JSON.stringify(data));
                   //document.getElementById('span_gid').value =data[0]["gid"];
                   document.getElementById('span_gid').value ="u";
                   //console.log(document.getElementById('span_gid').value)

                     //   {  
             //     "gid" : gidOfTheGame,   
             //     "gameName" : "nameOfTheGame",  
             //     "playerWaiting" : n,  
             //     PLANNED "maxPlayer" : 4,  
             //     "isPasswordSet" : true/false,
             //  }
                   //  console.log("Liste partie"),
           //        [{"gid":"2","gameName":"test","playerWaiting":"2","maxPlayer":"4","isPasswordSet":true}]
           //                data[i]["gid"] +


/*           for(int i=0, i<= data.length,i++){
                //   document.getElementById('infos_partie').value = "Nom partie" + data[i]["gameName"] +   data[i]["playerWaiting"] + data[i]["isPasswordSet"];
            // span_SOLI

                }*/

                },
                error:function()
                {          
                    // errorToConnect();
                }

            });


        });

     //    });



//choix partie

    // $("#submit_choix_partie").click(function(){

    //  var password = "\"" +$('#password_partie').val()+"\"";
    //  var gid = "\"" +$('#nom_partie').val()+"\"";
    //  var pid = pID;

    //         $.ajax({
    //             url: 'http://dev.asmock.com/api/play',
    //             dataType: "json",
    //             type: "POST",
    //             data : { "pid" : pid,
    //                      "gid" : gid,
    //                      "password" : password},

    //             success: function(data)
    //                 {

    //                 },
    //             error:function()
    //                 {          
    //                     // errorToConnect();
    //                 }
    //         });
    // });


//creation partie

   // $("#create_partie").click(function(){

   //  $.ajax({
   //  url: 'http://dev.asmock.com/api/game',
   //  dataType: "json",
   //  success: function(data)
   //  {

   //      $.post(
   //              console.log("Create partie"),
   //          {

   //          },
   //          // function(data){
   //          //     if(data == 'SUCCES'){
   //          //          $("#resultat").html("<p>Vous avez été connecté avec succès !</p>");
   //          //     }
   //          //     else{
   //          //          $("#resultat").html("<p>Erreur lors de l'inscription'...</p>");
   //          //     }
   //          // },
   //          'text'
   //       );
   //  },
   //  error:function()
   //  {          
   //      // errorToConnect();
   //  }
   //  });
   //  });





    // $("#more_com").click(function(){

         

    //     $.ajax({

    //        url: 'http://dev.asmock.com/api/carte',
    //        type : 'GET' // Le type de la requête HTTP.

    //        data : nom_user;

    //     });

       

    // });



    // });
});
