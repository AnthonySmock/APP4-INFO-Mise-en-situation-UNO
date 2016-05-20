<?php
$app->post('/api/action', function ($request, $response) {
    $requestData = json_decode($request->getBody(), true);
    if(!isset($requestData['action']))
        return $response->withJson(array("info" => "missing field action"))->withStatus(400);
    if(!isset($requestData['gid']))
        return $response->withJson(array("info" => "missing field gid"))->withStatus(400);
    if(!isset($requestData['pid']))
        return $response->withJson(array("info" => "missing field pid"))->withStatus(400);
    if(!($requestData['action'] == "play" || $requestData['action'] == "draw"))
        return $response->withJson(array("info" => "action does not exists"))->withStatus(400);
    if(!is_int($requestData['gid']))
            return $response->withJson(array("info" => "gid must be an integer"))->withStatus(400);
    if(!is_int($requestData['pid']))
            return $response->withJson(array("info" => "pid must be an integer"))->withStatus(400);
    if($requestData['action'] == "draw")
        return drawCard($requestData, $response);
    if($requestData['action'] == "play")
    {
        if(!isset($requestData['cid']))
            return $response->withJson(array("info" => "missing field cid for action play"))->withStatus(400);
        if(!is_int($requestData['cid']))
            return $response->withJson(array("info" => "cid must be an integer"))->withStatus(400);
        return playCard($requestData, $response);
    }
});

$app->post('/api/state', function ($request, $response) {

  $requestData = json_decode($request->getBody(), true);

  if(!isset($requestData['gid']))
      return $response->withJson(array("info" => "missing field gid"))->withStatus(400);
  if(!isset($requestData['pid']))
      return $response->withJson(array("info" => "missing field pid"))->withStatus(400);
  if(!is_int($requestData['gid']))
          return $response->withJson(array("info" => "gid must be an integer"))->withStatus(400);
  if(!is_int($requestData['pid']))
          return $response->withJson(array("info" => "pid must be an integer"))->withStatus(400);

  return getState($requestData, $response);
});


function getState($requestData, $response)
{
  $gid = $requestData['gid'];
  $pid = $requestData['pid'];

  if(!isPlayerInGame($pid, $gid))
    return $response->withJson(array("info" => "you aren't in this game"))->withStatus(400);


		$data['isYourTurn'] = isPlayerTurn($pid, $gid);

	$data['isFinished'] = isGameFinished($gid);
	$data['isWinner'] = isPlayerWinner($pid, $gid);
	$data['isBegun'] = isGameBegun($gid);
	$data['upperCard'] = getLastPlayedCard($gid);
	$data['yourCards'] = getPlayerCards($pid, $gid);

	$data['othersNumberOfCards'] = getOthersNumberOfCardsInOrder($pid, $gid);

	return $response->withJson($data);
}

function isGameFinished($gid)
{
  $bdd = getDB();
  $sql = "SELECT isTerminated
          FROM game
          WHERE gid = '$gid'";

  $exe = $bdd->query($sql);

  $data = $exe->fetch();

  if($data['isTerminated'] == 0)
    return false;
    else {
      return true;
    }
}

function getOthersNumberOfCardsInOrder($pid, $gid)
{
  $bdd = getDB();

  $sql = "SELECT @rownum:=@rownum + 1 as row_number,
          t.*
          FROM (
            SELECT p.pid, p.username, n FROM playersingame pg, player p, (SELECT COUNT(*) AS n, p.pid AS Plid FROM main m, player p, game g WHERE m.isPlayed = 0 AND g.gid = m.game_id AND g.gid = '$gid' AND m.player_id = p.pid GROUP BY p.pid) AS n WHERE pg.Game_gid = '$gid' AND pg.Player_pid = p.pid AND p.pid = Plid
          ) t,
          (SELECT @rownum := 0) r";

    $exe = $bdd->query($sql);
    
    $turns = getPlayersTurn($gid);
    $turn = $turns[$pid];

    $playersTurnAndNumber;

  while($data = $exe->fetch())
  {
      
    $playersTurnAndNumber[(($data['row_number'] + (4 - $turn))) % 4 + 1] = array("username" => $data['username'], "numberOfCards" => $data['n']);
  }

  return $playersTurnAndNumber;
}

function isGameBegun($gid)
{
  $bdd = getDB();
  $sql = "SELECT COUNT(*) AS n
          FROM player p, game g, playersingame pg
          WHERE g.gid = '$gid'
          AND g.gid = pg.Game_gid
          AND p.pid = pg.Player_pid";


  $exe = $bdd->query($sql);

  $data = $exe->fetch();

  if($data['n'] == 4)
    return true;
  else {
    return false;
  }
}

function isGameRunning($gid)
{
  if(isGameBegun($gid) && !isGameFinished($gid))
    return true;
  else {
    return false;
  }
}

function getPlayerCards($pid, $gid)
{
  $bdd = getDB();
  $sql = "select m.carte_id
  from main m, game g
  where g.gid = '$gid'
  and m.game_id = g.gid
  and m.player_id = '$pid'
  and m.isPLayed = 0";

  $exe = $bdd->query($sql);
    
    $data = $exe->fetchAll();
    
    foreach($data as &$carte)
    {
        $carte = getInfoOnCard($carte['carte_id']);
        $carte['color'] = $carte['color_name'];
        $carte['number'] = convertNumberName($carte['number_name']);
    }

  return $data;
}

function isPlayerWinner($pid, $gid)
{
  if(!getPlayerCards($pid, $gid))
    return true;
  else
    return false;
}

function isPlayerInGame($pid, $gid)
{
  $bdd = getDB();
  $sql = "select pg.Player_pid
  from playersingame pg, game g
  where pg.Player_pid = '$pid'
  and pg.Game_gid = '$gid'
  and pg.Game_gid = g.gid";

  $exe = $bdd->query($sql);

  if (!($data = $exe->fetch()))
    return false;
  else
    return true;
}

function drawCard($requestData, $response)
{
    $gid = $requestData['gid'];
    $pid = $requestData['pid'];


    if(!isPlayerInGame($pid, $gid))
      return $response->withJson(array("info" => "you aren't in this game"))->withStatus(400);

    if(!isGameRunning($gid))
      return $response->withJson(array("info" => "game is not running"))->withStatus(400);

    if(!isPlayerTurn($pid, $gid))
      return $response->withJson(array("info" => "it's not your turn"))->withStatus(400);

    $bdd = getDB();
    $sql = "select c.cid, co.color_name, n.number_name
    from carte c, main m, color co, number n
    where c.cid = m.carte_id
    and m.game_id = '$gid'
    and m.player_id is null
    and c.color_id = co.color_id
    and c.number_id = n.number_id
    order by rand()
    limit 1";


    $exe = $bdd->query($sql);
    if (!($data = $exe->fetch()))
    {
        //plus de cartes : regénérer la pioche avec les cartes jouées, sauf la première
        return array("info" => "plus de carte");
    }
    else
    {
        //$pickedCard = array_rand($data, 1);
        $card['cid'] = $data['cid'];
        $card['color'] = $data['color_name'];
        $card['number'] = convertNumberName($data['number_name']);
    }

    $cid = $data['cid'];

    $sql = "update main
    set player_id = :pid
    where carte_id = :cid
    and game_id = :gid";

    $req = $bdd->prepare($sql);
    $req->bindParam("pid", $pid);
    $req->bindParam("cid", $cid);
    $req->bindParam("gid", $gid);
    $req->execute();

    incrementTurn($gid);

    return $response->withJson($card);
}

function playCard($requestData, $response) {

    $cid = $requestData['cid'];
    $gid = $requestData['gid'];
    $pid = $requestData['pid'];


    if(!isPlayerInGame($pid, $gid))
      return $response->withJson(array("info" => "you aren't in this game"))->withStatus(400);

    if(!isGameRunning($gid))
      return $response->withJson(array("info" => "game is not running"))->withStatus(400);

    if(!isPlayerTurn($pid, $gid))
      return $response->withJson(array("info" => "it's not your turn"))->withStatus(400);

    $bdd = getDB();

    $sql = "select *
    from carte c, main m
    where c.cid = m.carte_id
    and m.game_id = '$gid'
    and m.player_id = '$pid'
    and m.carte_id = '$cid'
    and m.isPlayed = 0";

    $exe = $bdd->query($sql);

    if(!($data = $exe->fetch()))
       return $response->withJson(array("info" => "you don't have this card"))->withStatus(400);

    $lastPlayedCard = getLastPlayedCard($gid);
    $playerCard = getInfoOnCard($cid);

    if(!($lastPlayedCard['color_name'] == $playerCard['color_name'] || $lastPlayedCard['number_name'] == $playerCard['number_name']))
      return $response->withJson(array("info" => "you can't play this card"))->withStatus(400);

    $sql = "update main
    set isPlayed = 1
    where carte_id = :cid
    and game_id = :gid";

    $req = $bdd->prepare($sql);
    $req->bindParam("cid", $cid);
    $req->bindParam("gid", $gid);
    $req->execute();

    $sql = "update game
    set lastPlayedCard = :cid
    where gid = :gid";

    $req = $bdd->prepare($sql);
    $req->bindParam("cid", $cid);
    $req->bindParam("gid", $gid);
    $req->execute();

    if(isPlayerWinner($pid, $gid))
    {
      makeWinner($pid, $gid);
    }

    incrementTurn($gid);

    return $response;
}

function makeWinner($pid, $gid)
{
  $bdd = getDB();
  $sql = "update playersingame
  set isWinner = 1
  where Game_gid = :gid
  and Player_pid = :pid";

  $req = $bdd->prepare($sql);
  $req->bindParam("gid", $gid);
  $req->bindParam("pid", $pid);
  $req->execute();
  terminateGame($gid);
}

function terminateGame($gid)
{
  $bdd = getDB();
  $sql = "update game
  set isTerminated = 1
  where gid = :gid";

  $req = $bdd->prepare($sql);
  $req->bindParam("gid", $gid);
  $req->execute();
}

function getInfoOnCard($cid)
{
  $bdd = getDB();

  $sql = "SELECT c.cid, co.color_name, n.number_name
  FROM carte c, color co, number n
  WHERE c.cid = '$cid'
  AND c.color_id = co.color_id
  AND c.number_id = n.number_id";

  $exe = $bdd->query($sql);

  return $data = $exe->fetch();
}

function getLastPlayedCard($gid)
{
  $bdd = getDB();

  $sql = "SELECT c.cid, co.color_name, n.number_name
  FROM game g, carte c, color co, number n
  WHERE g.gid = '$gid'
  AND c.cid = g.lastPlayedCard
  AND c.color_id = co.color_id
  AND c.number_id = n.number_id";

  $exe = $bdd->query($sql);

  if($carte = $exe->fetch())
  {
    $carte['color'] = $carte['color_name'];
    $carte['number'] = convertNumberName($carte['number_name']);
  }
    
    return $carte;
}

function incrementTurn($gid)
{
  $bdd = getDB();

  $sql = "update game
  set turn = turn + 1
  where gid = :gid";

  $req = $bdd->prepare($sql);
  $req->bindParam("gid", $gid);
  $req->execute();
}

function getPlayersTurn($gid)
{

  $bdd = getDB();

  $sql = "SELECT @rownum:=@rownum + 1 as row_number,
          t.*
          FROM (
            SELECT * FROM playersingame WHERE Game_gid = '$gid'
          ) t,
          (SELECT @rownum := 0) r";

          $exe = $bdd->query($sql);

          $playersTurn;

          while($data = $exe->fetch())
          {
            $playersTurn[$data['Player_pid']] = $data['row_number'];
          }

          return $playersTurn;

}


function isPlayerTurn($pid, $gid)
{
  $playersTurn = getPlayersTurn($gid);
  if(getCurrentTurn($gid) == $playersTurn[$pid])
    return true;
  else
    return false;

}

function getCurrentTurn($gid)
{

  $bdd = getDB();

  $sql = "SELECT turn
  FROM game g
  WHERE g.gid = '$gid'";

  $exe = $bdd->query($sql);

  $data = $exe->fetch();

  return $data['turn'] % 4 + 1;
}
?>
