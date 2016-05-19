<?php
/**
	Fichier contenant les fonctions qui vont être utilisées par différents fichiers.
*/


// Fonction permettant la connexion à la base de donnée
function getDB()
{
	// adresse de la base de données
	$dbhost = "127.0.0.1";
    // user de la base de donnée
	$dbuser = "root";
	// mdp de la base de donnée
    $dbpass = "WkbkBNJRWa";
	// nom de la base de donnée
    $dbname = "uno";
 
    $mysql_conn_string = "mysql:host=$dbhost;dbname=$dbname";
    $dbConnection = new PDO($mysql_conn_string, $dbuser, $dbpass); 
    $dbConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    return $dbConnection;
}