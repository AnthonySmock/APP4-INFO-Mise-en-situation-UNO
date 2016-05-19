<?php
ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(-1);

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, PUT, POST, DELETE, OPTIONS');

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require 'vendor/autoload.php';
require 'fonctions.php';

$app = new Slim\App();

$app->get('/api/carte', function ($request, $response, $args) {
	$carte['color'] = 'blue';
	$carte['number'] = 2;
	$cartes[0] = $carte;
	$cartes[1] = $carte;
	$cartes[2] = $carte;
	$theCartes['carte'] =  $cartes;
	return $response->withJson($theCartes);
});

$app->post('/api/state', function ($request, $response) {
	if(rand(1, 4) == 1)
		$data['isYourTurn'] = true;
	else
		$data['isYourTurn'] = false;
	$data['isFinished'] = false;
	$data['isWinner'] = false;
	$data['isBegun'] = true;
	$data['upperCard'] = array(
					'color' => 'red',
					'number' => 9);
	$data['yourCards'] = array(
					array(
						'cid' => 67,
						'color' => 'blue',
						'number' => 1),

					array(
						'cid' => 43,
						'color' => 'red',
						'number' => 4));

	$data['othersNumberOfCards'] = array(
					array(
						'username' => 'Mohamed',
						'numberOfCards' => 4),

					array(
						'username' => 'Nicolas',
						'numberOfCards' => 5),
					array(
						'username' => 'Anthony',
						'numberOfCards' => 7));
	return $response->withJson($data);
});

/*$app->post('/api/action', function ($request, $response) {
	$requestData = json_decode($request->getBody(), true);
	if(!(isset($requestData['action'])))
		return $response->withStatus(400)->write($request->getBody());
	if(!($requestData['action'] === 'draw' || $requestData['action'] === 'play'))
		return $response->withStatus(400)->write($request->getBody());
	if($requestData['action']  === 'draw')
	{
		$carte['color'] = "yellow";
		$carte['number'] = 6;
		$carte['cid'] = 765;
		return $response->withJson($carte);
	}
	return $response;
});*/

require('action/controller.php');
require('game/controller.php');
require('subscribe/controller.php');
    
$app->run();
?>