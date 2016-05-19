-- phpMyAdmin SQL Dump
-- version 4.0.9
-- http://www.phpmyadmin.net
--
-- Client: 127.0.0.1
-- Généré le: Mar 17 Mai 2016 à 15:08
-- Version du serveur: 5.5.34
-- Version de PHP: 5.4.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `uno_bd`
--

-- --------------------------------------------------------

--
-- Structure de la table `action`
--

CREATE TABLE IF NOT EXISTS `action` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `carte_id` int(11) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `isPlayed` tinyint(1) DEFAULT NULL,
  `isPioche` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`aid`),
  KEY `carte_id` (`carte_id`),
  KEY `player_id` (`player_id`),
  KEY `game_id` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `carte`
--

CREATE TABLE IF NOT EXISTS `carte` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `color` int(11) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `game`
--

CREATE TABLE IF NOT EXISTS `game` (
  `gid` int(11) NOT NULL AUTO_INCREMENT,
  `gameName` varchar(100) DEFAULT NULL,
  `gamePassword` varchar(100) DEFAULT NULL,
  `isTerminated` tinyint(1) NOT NULL,
  PRIMARY KEY (`gid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `main`
--

CREATE TABLE IF NOT EXISTS `main` (
  `carte_id` int(11) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `isPlayed` tinyint(1) DEFAULT NULL,
  KEY `carte_id` (`carte_id`),
  KEY `player_id` (`player_id`),
  KEY `game_id` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `player`
--

CREATE TABLE IF NOT EXISTS `player` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `playersingame`
--

CREATE TABLE IF NOT EXISTS `playersingame` (
  `Game_gid` int(11) DEFAULT NULL,
  `Player_pid` int(11) DEFAULT NULL,
  KEY `Game_gid` (`Game_gid`),
  KEY `Player_pid` (`Player_pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `token`
--

CREATE TABLE IF NOT EXISTS `token` (
  `player_id` int(11) DEFAULT NULL,
  `token` int(11) DEFAULT NULL,
  `dateValidite` date DEFAULT NULL,
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `action`
--
ALTER TABLE `action`
  ADD CONSTRAINT `action_ibfk_1` FOREIGN KEY (`carte_id`) REFERENCES `carte` (`cid`),
  ADD CONSTRAINT `action_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `player` (`pid`),
  ADD CONSTRAINT `action_ibfk_3` FOREIGN KEY (`game_id`) REFERENCES `game` (`gid`);

--
-- Contraintes pour la table `main`
--
ALTER TABLE `main`
  ADD CONSTRAINT `main_ibfk_1` FOREIGN KEY (`carte_id`) REFERENCES `carte` (`cid`),
  ADD CONSTRAINT `main_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `player` (`pid`),
  ADD CONSTRAINT `main_ibfk_3` FOREIGN KEY (`game_id`) REFERENCES `game` (`gid`);

--
-- Contraintes pour la table `playersingame`
--
ALTER TABLE `playersingame`
  ADD CONSTRAINT `playersingame_ibfk_1` FOREIGN KEY (`Game_gid`) REFERENCES `game` (`gid`),
  ADD CONSTRAINT `playersingame_ibfk_2` FOREIGN KEY (`Player_pid`) REFERENCES `player` (`pid`);

--
-- Contraintes pour la table `token`
--
ALTER TABLE `token`
  ADD CONSTRAINT `token_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `player` (`pid`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
