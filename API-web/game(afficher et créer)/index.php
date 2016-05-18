<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require 'vendor/autoload.php';
require 'fonctions.php';
require 'Slim/App.php';

$app = new Slim\App();

// requete permettant de récupérer les cartes d'un joueur
$app->get('/play', function (Request $request, Response $response) {
	getCards();
});

// requete permettant d'afficher les parties en cours 
$app->get('/game', function (Request $request, Response $response) {
	getGame($request, $response);
});

// requete permettant d'afficher les parties en cours 
$app->post('/game', function (Request $request, Response $response) {
	postGame($request, $response);
});

$app->run();

function getPlayers()
{
	$data = json_decode($request->getBody(), true);
	
	$db = getDB();
	$sql = "select * from player";
	$exe = $db->query($sql);
	$data = $exe->fetchAll();
	$db = null;
	echo json_encode($data);
}


function getGame(Request $request, Response $response)
{
	
	$db = getDB();
	// requete permettant d'afficher toutes les parties non terminées et qui 
	// n'ont pas atteint le nb de joueur max
	$sql =  "select g.gid, g.gameName, count(p.Player_pid) as nbJoueurs, g.gamePassword
			from game g, playersingame p
			where g.gid = p.Game_gid
			and isTerminated = false
			group by (g.gid)
			having nbJoueurs < 4";
	$exe = $db->query($sql);
	
	if ($exe == false)
	{
		$erreur['info'] = "erreur requete base de données";
		return $response->withJson($erreur)->withStatus(500);
	}
	else
	{
	
		while ($data = $exe->fetch() )
		{
			// test si pour la partie il existe un mdp
			if ( $data['gamePassword'] == "null")
			{
				$dataToEncode = [ "gid" => $data['gid'],
								  "gameName" => $data['gameName'],
								  "playerWaiting" => $data['nbJoueurs'],
								  "maxPlayer" => "4",
								  "isPasswordSet" => false,
				];		  
			}
			else
			{
				$dataToEncode = [ "gid" => $data['gid'],
								  "gameName" => $data['gameName'],
								  "playerWaiting" => $data['nbJoueurs'],
								  "maxPlayer" => "4",
								  "isPasswordSet" => true,
				];		  
			}
			$db = null;
			return $response->withJson($dataToEncode);
		
		}
	}

}

function postGame(Request $request, Response $response)
{
	$db = getDB();
	$dataReceived = json_decode($request->getBody(), true);
	// valeur n'a pas pu être décodée
	if ($dataReceived == null)
	{
		
		$erreur['info'] = "aucune donnée reçue";
		
		return $response->withJson($erreur)->withStatus(500);
	}
	else
	{
		
		$pid = $dataReceived['pid'];
		$gameName = $dataReceived['gameName'];
		$gamePassword = $dataReceived['gamePassword'];
		$maxPlayer = $dataReceived['maxPlayer'];
		$finish = 0;
		$isAdmin = 1;
		
		// le pid et le gameName sont obligatoires
		if ( isExist($pid) && isExist($gameName) )
		{
			// insertion dans la table game
			// test s'il y a un mot de passe ou non
			if (isExist($gamePassword))
			{
				// si oui: insertion d'un mdp également
				$sql = "insert into game (gameName, gamePassword, isTerminated)
						values (:name, :pwd, :bool)";
				try {

						$req = $db->prepare($sql);
						$req->bindParam("name", $gameName);
						$req->bindParam("pwd", $gamePassword);
						$req->bindParam("bool", $finish);
						$req->execute();
						
					
	
				} catch (PDOException $e)
				{
					echo '{"error":{"text":'. $e->getMessage() .'}}';
					$erreur['info'] = "erreur d'insertion";
					return $response->withJson($erreur)->withStatus(500);
				}
			}
			else
			{
				// si oui: insertion d'un mdp également
				$sql = "insert into game (gameName, isTerminated)
						values (:name, :bool)";
				try {

						$req = $db->prepare($sql);
						$req->bindParam("name", $gameName);
						$req->bindParam("bool", $finish);
						$req->execute();
						
					
				} catch (PDOException $e)
				{
					echo '{"error":{"text":'. $e->getMessage() .'}}';
					$erreur['info'] = "erreur d'insertion";
					return $response->withJson($erreur)->withStatus(500);
				}
			}
			$lastInserted = $db->lastInsertId();
			// insertion dans la table playersingame
			$sql = "insert into playersingame (Game_gid, isAdmin, Player_pid)
				    values (:gid, :isAdmin, :pid)";
			try {

					$req = $db->prepare($sql);
					$req->bindParam("gid", $lastInserted);
					$req->bindParam("isAdmin", $isAdmin);
					$req->bindParam("pid", $pid);
					$req->execute();	
				
			} catch (PDOException $e)
			{
				echo '{"error":{"text":'. $e->getMessage() .'}}';
				$erreur['info'] = "erreur d'insertion";
				return $response->withJson($erreur)->withStatus(500);
			}
		} 
	}
	
}

// fonction qui permet de l'existence d'une variable
function isExist ($var)
{
	if ( !isset($var) || empty($var) || $var == "null")
	{
		return false;
	}
	else
	{
		return true;
	}
}



/*
Requetes d'insertion dans la table game:


insert into game (gameName, gamePassword, isTerminated)
values ('partie1', 'toto', false);

insert into game (gameName, gamePassword, isTerminated)
values ('partie2', 'test', false);

insert into game (gameName, gamePassword, isTerminated)
values ('partie3', 'tata', false);

insert into game (gameName, gamePassword, isTerminated)
values ('partie4', 'titi', true);

insert into game (gameName, gamePassword, isTerminated)
values ('battle', 'toto', false);

insert into game (gameName, gamePassword, isTerminated)
values ('uno', 'test', true);

insert into game (gameName, gamePassword, isTerminated)
values ('partie34', 'tata', true);

insert into game (gameName, gamePassword, isTerminated)
values ('partie45', 'titi', true);

insert into player (username, password)
values ('zorro', 'azer');

insert into player (username, password)
values ('zarra', 'azer');

insert into player (username, password)
values ('titi', 'azer');

insert into player (username, password)
values ('grosminet', 'azer');

insert into player (username, password)
values ('bugs bunny', 'azer');

insert into player (username, password)
values ('daffy', 'azer');

// partie 1: pleine
insert into playersingame 
values (1, 1);

insert into playersingame 
values (1, 2);

insert into playersingame 
values (1, 3);

insert into playersingame 
values (1, 4);

// partie 2 non pleine
insert into playersingame 
values (2, 5);

insert into playersingame 
values (2, 6);


*/
?>


















