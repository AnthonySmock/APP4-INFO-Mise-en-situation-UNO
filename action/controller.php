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
        return $response->withJson(drawCard($requestData));
    if($requestData['action'] == "play")
    {
        if(!isset($requestData['cid']))
            return $response->withJson(array("info" => "missing field cid for action play"))->withStatus(400);
        if(!is_int($requestData['cid']))
            return $response->withJson(array("info" => "cid must be an integer"))->withStatus(400);
        return playCard($requestData, $response);
    }
});

function drawCard($requestData)
{
    $gid = $requestData['gid'];
    $pid = $requestData['pid'];
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

    return $card;
}

function playCard($requestData, $response) {

    /*
    "cid": "159",
  "color": "red",
  "number": 5*/

    $cid = $requestData['cid'];
    $gid = $requestData['gid'];
    $pid = $requestData['pid'];

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

    incrementTurn($gid);

    return $response;
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
            SELECT * FROM playersingame WHERE Game_gid = 36
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

$app->get("/api/turn", function($request, $response) {
  return $response->withJson(array("istrun" => isPlayerTurn(17,36)));
});

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
