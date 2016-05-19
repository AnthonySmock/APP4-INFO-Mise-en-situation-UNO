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

function convertNumberName($numberName) {
    switch($numberName) {
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