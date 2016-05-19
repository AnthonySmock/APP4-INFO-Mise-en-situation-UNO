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
        return $response->withJson(playCard($requestData));
    }
});
    
function drawCard($requestData)
{
    $gid = $requestData['gid'];
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
    if ($exe == false)
    {
        //plus de cartes : regénérer la pioche avec les cartes jouées, sauf la première
    }
    else
    {
        $data = $exe->fetch();
        //$pickedCard = array_rand($data, 1);
        $card['cid'] = $data['cid'];
        $card['color'] = $data['color_name'];
        $card['number'] = convertNumberName($data['number_name']);
    }
    return $card;
}


function convertNumberName($numberName) {
    switch($data['number_name']) {
            case "un":
            return 1;
            break;
            case "deux":
            return 2;
            break;
            case "trois":
            return 3;
            break;
            case "quatre":
            return 4;
            break;
            case "cinq":
            return 5;
            break;
            case "six":
            return 6;
            break;
            case "sept":
            return 7;
            break;
            case "huit":
            return 8;
            break;
            case "neuf":
            return 9;
            break;
        }
    
    return 1;
}
?>