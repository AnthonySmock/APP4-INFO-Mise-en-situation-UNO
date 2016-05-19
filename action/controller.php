<?php

$app->post('/api/action', function($request, $response) {
    $requestData = json_decode(request->getBody());
    if(!isset($requestData['action']))
        return $response->withJson(array("info" => "missing field action"))->withStatus(400);
    if(!($requestData['action'] == "play" || $requestData['action'] == "draw"))
        return $response->withJson(array("info" => "action does not exists"))->withStatus(400);
    if($requestData['action'] == "draw")
        return $response->withJson(drawCard($requestData));
    if($requestData['action'] == "play")
    {
        if(!isset($requestData['cid']))
            return $response->withJson(array("info" => "missing field cid for action play"))->withStatus(400);
        if(!is_int($requestData['cid']))
            return $response->withJson(array("info" => "cid must be an integer"))->withStatus(400);
        return $response->withJson(playCard($requestData));
});

$app->post('/api/state', function(&request, $response) {
    
});
    
drawCard($requestData)
{
    
}
?>

