-- Fichier test permettant de tester le code index.php

-- Création de la table
CREATE TABLE IF NOT EXISTS `player` ( 
	`pid` int(11) AUTO_INCREMENT, 
	`username` varchar(100) DEFAULT NULL, 
	`password` varchar(100) DEFAULT NULL, 
	`nbPlayedGames` int(11) DEFAULT NULL, 
	`nbWonGames` int(11) DEFAULT NULL, 
	PRIMARY KEY (`pid`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Insertions
insert into player (username, password)
values ('amina', 'mdp');

insert into player (username, password)
values ('mohamed', 'mdp1');

insert into player (username, password)
values ('anthony', 'mdp2');

insert into player (username, password, nbPlayedGames, nbWonGames)
values ('zorro', 'zooro', 4, 2);

insert into player (username, password, nbPlayedGames, nbWonGames)
values ('superman', 'man', 10, 10);

