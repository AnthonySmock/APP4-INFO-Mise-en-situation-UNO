<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require 'vendor/autoload.php';
require 'fonctions.php';
require 'Slim/App.php';

$app = new Slim\App();

// requete permettant de récupérer tous les résultats d'une table: fonctionnel
// url à taper pour tester: http://localhost/"votre répertoire si sous répertoire dans www"/getPlayers
$app->get('/getPlayers', 'getPlayers');

// requete permettant de récupérer un résultat particulier: fonctionnel
// url à taper pour tester: http://localhost/"votre répertoire si sous répertoire dans www"/getPlayers/"valeur de pid présente dans votre base de données"
$app->get('/getPlayer/{id}', function (Request $request, Response $response, $args) {
	getPlayer($args['id']);
});

// requete permettant d'ajouter une ligne dans une table
// code non testé
$app->get('/addPlayer', function (Request $request, Response $response, $args) {
	addPlayer($request->getParsedBody());
});

// requete permettant de mettre à jour les données
// code non testé
$app->put('/updatePlayer', function (Request $request, Response $response, $args) {
	updatePlayer($request->getParsedBody());
});

// requete permettant de supprimer une donnée
// code non testé
$app->put('/deletePlayer', function (Request $request, Response $response, $args) {
	deletePlayer($request->getParsedBody());
});


$app->run();

function getPlayers()
{
	$db = getDB();
	$sql = "select * from player";
	$exe = $db->query($sql);
	$data = $exe->fetchAll();
	$db = null;
	echo json_encode($data);
}

function getPlayer($id)
{
	$db = getDB();
	$sql = "select username from player where `pid` = '$id'";
	$exe = $db->query($sql);
	$data = $exe->fetch();
	$db = null;
	echo json_encode($data);
}


function addPlayer($player)
{
	$db = getDB();
	$sql = "insert into player (username, password, nbPlayedGames, nbWonGames)"
		. "values ('$player[username]', '$player[password]', '$player[nbPlayedGames]', '$player[nbWonGames]')";
	$exe = $db->query($sql);
	$insert = $db->insert_id;
	$db = null;
	if (!empty($insert))
		echo $insert;
	else
		echo false;
}
	
function updatePlayer($player)
{
	$db = getDB();
	$sql = "update player"
		.  "set username = '$player[username]',"
		.  "set password = '$player[password]',"
		. "where pid = '$player[pid]'";
	$exe =  $db->query($sql);
	$update = $db->affected_rows;
	$db = null;
	if (!empty($update))
		echo $update;
	else
		echo false;
}

function deletePlayer($player)
{
	$db = getDB();
	$sql = "delete"
		.  "from player"
		. "where pid = '$player[pid]'";
	$db = null;
	if (!empty($update))
		echo $update;
	else
		echo false;
}

?>


















