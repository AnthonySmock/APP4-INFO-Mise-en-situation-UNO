-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Mer 18 Mai 2016 à 16:01
-- Version du serveur :  10.1.13-MariaDB
-- Version de PHP :  7.0.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `uno_game1`
--

-- --------------------------------------------------------

--
-- Structure de la table `action`
--

CREATE TABLE `action` (
  `aid` int(11) NOT NULL,
  `carte_id` int(11) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `isPlayed` tinyint(1) DEFAULT NULL,
  `isPioche` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `carte`
--

CREATE TABLE `carte` (
  `cid` int(11) NOT NULL,
  `color_id` int(11) DEFAULT NULL,
  `number_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `color`
--

CREATE TABLE `color` (
  `color_id` int(11) NOT NULL,
  `color_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `game`
--

CREATE TABLE `game` (
  `gid` int(11) NOT NULL,
  `gameName` varchar(100) DEFAULT NULL,
  `gamePassword` varchar(100) DEFAULT NULL,
  `isTerminated` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `main`
--

CREATE TABLE `main` (
  `carte_id` int(11) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `isPlayed` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `number`
--

CREATE TABLE `number` (
  `number_id` int(11) NOT NULL,
  `number_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `player`
--

CREATE TABLE `player` (
  `pid` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `playersingame`
--

CREATE TABLE `playersingame` (
  `Game_gid` int(11) DEFAULT NULL,
  `Player_pid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `token`
--

CREATE TABLE `token` (
  `player_id` int(11) DEFAULT NULL,
  `token` int(11) DEFAULT NULL,
  `dateValidite` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `action`
--
ALTER TABLE `action`
  ADD PRIMARY KEY (`aid`),
  ADD KEY `carte_id` (`carte_id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `game_id` (`game_id`);

--
-- Index pour la table `carte`
--
ALTER TABLE `carte`
  ADD PRIMARY KEY (`cid`),
  ADD KEY `color_id` (`color_id`),
  ADD KEY `number_id` (`number_id`);

--
-- Index pour la table `color`
--
ALTER TABLE `color`
  ADD PRIMARY KEY (`color_id`);

--
-- Index pour la table `game`
--
ALTER TABLE `game`
  ADD PRIMARY KEY (`gid`);

--
-- Index pour la table `main`
--
ALTER TABLE `main`
  ADD KEY `carte_id` (`carte_id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `game_id` (`game_id`);

--
-- Index pour la table `number`
--
ALTER TABLE `number`
  ADD PRIMARY KEY (`number_id`);

--
-- Index pour la table `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`pid`);

--
-- Index pour la table `playersingame`
--
ALTER TABLE `playersingame`
  ADD KEY `Game_gid` (`Game_gid`),
  ADD KEY `Player_pid` (`Player_pid`);

--
-- Index pour la table `token`
--
ALTER TABLE `token`
  ADD KEY `player_id` (`player_id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `action`
--
ALTER TABLE `action`
  MODIFY `aid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `carte`
--
ALTER TABLE `carte`
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `color`
--
ALTER TABLE `color`
  MODIFY `color_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `game`
--
ALTER TABLE `game`
  MODIFY `gid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `number`
--
ALTER TABLE `number`
  MODIFY `number_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `player`
--
ALTER TABLE `player`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT;
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

ALTER TABLE `carte`
  ADD CONSTRAINT `carte_ibfk_1` FOREIGN KEY (`number_id`) REFERENCES `number` (`number_id`),
  ADD CONSTRAINT `carte_ibfk_2` FOREIGN KEY (`color_id`) REFERENCES `color` (`color_id`);
  
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
