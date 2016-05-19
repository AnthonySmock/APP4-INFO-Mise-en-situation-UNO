<?php
// requete permettant de récupérer les cartes d'un joueur
$app->get('/api/play', function ($request, $response) {
	getCards();
});

// requete permettant d'afficher les parties en cours 
$app->get('/api/game', function ($request, $response) {
	getGame($request, $response);
});

// requete permettant d'afficher les parties en cours 
$app->post('/api/game', function ($request, $response) {
	postGame($request, $response);
});

// requete permettant d'entrer dans une partie
$app->post('/api/play', function ($request, $response) {
	enterGame($request, $response);
});


function getGame($request, $response)
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
		return $response->withJson($erreur)->withStatus(400);
	}
	else
	{
	
		$array = array();
		$cpt = 0;
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
			$array[$cpt] = $dataToEncode;
			$cpt = $cpt +1;
			
		}
		$db = null;
		return $response->withJson($array);
	}

   
}

function postGame($request, $response)
{
	$db = getDB();
	$dataReceived = json_decode($request->getBody(), true);
	// valeur n'a pas pu être décodée
	if ($dataReceived == null)
	{
		
		$erreur['info'] = "aucune donnée reçue";
		return $response->withJson($erreur)->withStatus(400);
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
			
			// test que le pid existe 
			// vérification de l'existence du pid
			// cas où il n'y a pas de mdp
			// vérification de l'existence du gid
			$sql =  "select pid
				from player
				where pid = '$pid'  ";
			$exe = $db->query($sql);
			if ( $exe->rowCount() == 1)
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
						return $response->withJson($erreur)->withStatus(400);
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
						return $response->withJson($erreur)->withStatus(400);
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
					return $response->withJson($erreur)->withStatus(400);
				}
				echo "super";
			}
			else
			{
				$erreur['info'] = "erreur avec le pid: il n'existe pas";
				return $response->withJson($erreur)->withStatus(400);
			
			}
		} 
		else
		{
			$erreur['info'] = "erreur avec les paramètres json";
			return $response->withJson($erreur)->withStatus(400);
		
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

function enterGame($request, $response)
{
	$db = getDB();
	$dataReceived = json_decode($request->getBody(), true);
	// valeur n'a pas pu être décodée
	if ($dataReceived == null)
	{
		$erreur['info'] = "aucune donnée reçue";
		return $response->withJson($erreur)->withStatus(400);
	}
	else
	{
		$pid = $dataReceived['pid'];
		$gid = $dataReceived['gid'];
		$pwd = $dataReceived['password'];
		
		if ( isExist($pid) && isExist($gid) )
		{
			// vérification de l'existence du pid
			// cas où il n'y a pas de mdp
			// vérification de l'existence du gid
			$sql =  "select pid
				from player
				where pid = '$pid'  ";
			$exe = $db->query($sql);
			
			// cas où il n'y a pas de mdp
			// vérification de l'existence du gid
			$sql2 =  "select gid
				from game
				where gid = '$gid'  ";
			$exe2 = $db->query($sql2); 
			
 			if ( $exe->rowCount() == 1 && $exe2->rowCount() == 1)
			{
			
				//test s'il y a un mdp
				if ( isExist($pwd) )
				{
					// vérification que ce mdp correspond au gid passé en paramètres
					$sql =  "select gid
						from game
						where gamePassword = '$pwd'
						and gid = '$gid'  ";
					$exe = $db->query($sql);
					
					// teste s'il y a un résultat ou non
					if ($exe->rowCount() == 1)
					{
						// tester s'il y a moins de 4 joueurs
						$sql =  "select g.gid, count(p.Player_pid) as nbJoueurs
								from game g, playersingame p
								where g.gid = p.Game_gid
								and isTerminated = false
								and gid = '$gid'
								group by (g.gid)";
						$exe = $db->query($sql);
						$data = $exe->fetch();
						// si oui
						if ( $data['nbJoueurs'] < 4)
						{
							// on fait l'insertion
							echo "on doit faire l'insertion";
							$sql = "insert playersingame (Game_gid, Player_pid)
									values (:gid, :pid)
								";
							try {

									$req = $db->prepare($sql);
									$req->bindParam("gid", $gid);
									$req->bindParam("pid", $pid);
									$req->execute();
							} catch (PDOException $e)
							{
								echo '{"error":{"text":'. $e->getMessage() .'}}';
								$erreur['info'] = "erreur d'insertion";
								return $response->withJson($erreur)->withStatus(400);
							}
						}
						else
						{
							$erreur['info'] = "erreur, il y a déjà 4 joueurs";
							return $response->withJson($erreur)->withStatus(400);
						
						}
					}
					else
					{
						$erreur['info'] = "erreur, le mot de passe est erroné";
						return $response->withJson($erreur)->withStatus(400);
					
					}
				}
				else 
				{	
					// tester s'il y a moins de 4 joueurs
					$sql =  "select g.gid, count(p.Player_pid) as nbJoueurs
							from game g, playersingame p
							where g.gid = p.Game_gid
							and isTerminated = false
							and gid = '$gid'
							group by (g.gid)";
					$exe = $db->query($sql);
					$data = $exe->fetch();
					// si oui
					if ( $data['nbJoueurs'] < 4)
					{
						// on fait l'insertion
						echo "on doit faire l'insertion";
						$sql = "insert playersingame (Game_gid, Player_pid)
								values (:gid, :pid)
							";
						try {

								$req = $db->prepare($sql);
								$req->bindParam("gid", $gid);
								$req->bindParam("pid", $pid);
								$req->execute();
						} catch (PDOException $e)
						{
							echo '{"error":{"text":'. $e->getMessage() .'}}';
							$erreur['info'] = "erreur d'insertion";
							return $response->withJson($erreur)->withStatus(400);
						}
					}
					else
					{
						$erreur['info'] = "erreur, il y a déjà 4 joueurs";
						return $response->withJson($erreur)->withStatus(400);
					
					}
				}
			}
			else
			{
				$erreur['info'] = "erreur  avec le pid ou le gid";
				return $response->withJson($erreur)->withStatus(400);
			}
		}
		else
		{
			$erreur['info'] = "erreur avec les paramètres json";
			return $response->withJson($erreur)->withStatus(400);
		}
	
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