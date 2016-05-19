<?php
/**
 * Step 1: Require the Slim Framework using Composer's autoloader
 *
 * If you are not using Composer, you need to load Slim Framework with your own
 * PSR-4 autoloader.
 */

/**
 * Step 2: Instantiate a Slim application
 *
 * This example instantiates a Slim application using
 * its default settings. However, you will usually configure
 * your Slim application now by passing an associative array
 * of setting names and values into the application constructor.
 */

/**
 * Step 3: Define the Slim application routes
 *
 * Here we define several Slim application routes that respond
 * to appropriate HTTP request methods. In this example, the second
 * argument for `Slim::get`, `Slim::post`, `Slim::put`, `Slim::patch`, and `Slim::delete`
 * is an anonymous function.
 */
/*$app->get('/', function ($request, $response, $args) {
    $response->write("Welcome to Slim!");
    return $response;
});*/

$app->post('/api/subscribe', function ($request, $response, $args) use ($app)
 {
    $data = json_decode($request->getBody(), true);
	$player_username = $data['username'];
	$player_password = $data['password'];
	
	try
	{
		// On se connecte à MySQL
		$bdd = new PDO('mysql:host=localhost;dbname=Uno_game;charset=utf8', 'root', '');
	}
	catch(Exception $e)
	{
		// En cas d'erreur, on affiche un message et on arrête tout
			die('Erreur : '.$e->getMessage());
	}

	// Si tout va bien, on peut continuer
	// On récupère tout le contenu de la table jeux_video
	$req = $bdd->prepare('SELECT * FROM player WHERE username = ?');
	$req->execute(array($player_username));
	$donnees = $req->fetchAll();
	if (preg_match ('/[^a-zA-Z0-9 ]/i', $player_password)){
		echo 'password ne contient pas que des caractères alphanumériques non accentués';
	}else{
		echo 'password ne contient que des caractères alphanumériques non accentués';
		if($donnees){
			echo "\n ERROR : il y a deja un compte avec ce nom ! ";
		}
		else{
			echo "\n insert...";
			if ($bdd->query("INSERT INTO Player (pid, username, password) VALUES (11,'$player_username','$player_password')")) {
				echo "New record created successfully";
			} else {
				echo "Error: ";
			}
		}
	}
	
	$req = $bdd->prepare('SELECT * FROM player WHERE username = ?');
	$req->execute(array($player_username));
	$donnees = $req->fetchAll();
	
	return $response->withJson($donnees);
});





$app->post('/api/connexion', function ($request, $response, $args) use ($app)
 {
    $data = json_decode($request->getBody(), true);
	$player_username = $data['username'];
	$player_password = $data['password'];
	
	try
	{
		// On se connecte à MySQL
		$bdd = new PDO('mysql:host=localhost;dbname=Uno_game;charset=utf8', 'root', '');
	}
	catch(Exception $e)
	{
		// En cas d'erreur, on affiche un message et on arrête tout
			die('Erreur : '.$e->getMessage());
	}

	// Si tout va bien, on peut continuer

	// On récupère tout le contenu de la table jeux_video
	$req = $bdd->prepare('SELECT * FROM player WHERE username = ? AND password= ?');
	$req->execute(array($player_username,$player_password));
	$donnees = $req->fetchAll();
	
	if($donnees){
			echo "\n Vous etes connecté, votre pid : " .$donnees[0]["pid"];
			return $response->withJson($donnees);
		}
	else{
		$info['info']="Error : username and password invalid..";
		echo "\n Error : username and password invalid..";
		return $response->withJson($info)->withStatus(400);
		}
});


/*$app->put('/api[/{cocotte}]', function ($request, $response, $args) { 
	$data = json_decode($request->getBody(), true);
	$data['name'] = $args['cocotte'];
	return $response->withJson($data);
})->setArgument('cocotte', 'test');*/

/**
 * Step 4: Run the Slim application
 *
 * This method should be called last. This executes the Slim application
 * and returns the HTTP response to the HTTP client.
 */
?>