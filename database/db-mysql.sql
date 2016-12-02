-- MySQL Script generated by MySQL Workbench
-- Fri Dec  2 12:25:31 2016
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema zafira
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `zafira` ;

-- -----------------------------------------------------
-- Schema zafira
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `zafira` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `zafira` ;

-- -----------------------------------------------------
-- Table `USERS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `USERS` ;

CREATE TABLE IF NOT EXISTS `USERS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `USERNAME` VARCHAR(100) NOT NULL,
  `PASSWORD` VARCHAR(50) NULL DEFAULT '',
  `EMAIL` VARCHAR(100) NULL,
  `FIRST_NAME` VARCHAR(100) NULL,
  `LAST_NAME` VARCHAR(100) NULL,
  `ENABLED` TINYINT(1) NOT NULL DEFAULT 0,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `USERNAME_UNIQUE` (`USERNAME` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TEST_SUITES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TEST_SUITES` ;

CREATE TABLE IF NOT EXISTS `TEST_SUITES` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(200) NOT NULL,
  `DESCRIPTION` MEDIUMTEXT NULL,
  `FILE_NAME` VARCHAR(255) NOT NULL DEFAULT '',
  `USER_ID` INT UNSIGNED NOT NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `NAME_FILE_USER_UNIQUE` (`NAME` ASC, `FILE_NAME` ASC, `USER_ID` ASC),
  INDEX `FK_TEST_SUITE_USER_ASC` (`USER_ID` ASC),
  CONSTRAINT `fk_TEST_SUITES_USERS1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `USERS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PROJECTS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PROJECTS` ;

CREATE TABLE IF NOT EXISTS `PROJECTS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(255) NOT NULL,
  `DESCRIPTION` TINYTEXT NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `NAME_UNIQUE` (`NAME` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TEST_CASES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TEST_CASES` ;

CREATE TABLE IF NOT EXISTS `TEST_CASES` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TEST_CLASS` VARCHAR(255) NOT NULL,
  `TEST_METHOD` VARCHAR(100) NOT NULL,
  `INFO` TINYTEXT NULL,
  `TEST_SUITE_ID` INT UNSIGNED NOT NULL,
  `USER_ID` INT UNSIGNED NOT NULL,
  `STATUS` VARCHAR(20) NOT NULL DEFAULT 'UNKNOWN',
  `PROJECT_ID` INT UNSIGNED NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  INDEX `FK_TEST_CASE_SUITE_ASC` (`TEST_SUITE_ID` ASC),
  INDEX `FK_TEST_CASE_USER_ASC` (`USER_ID` ASC),
  INDEX `fk_TEST_CASES_PROJECTS1_idx` (`PROJECT_ID` ASC),
  CONSTRAINT `fk_TEST_CASE_TEST_SUITE1`
    FOREIGN KEY (`TEST_SUITE_ID`)
    REFERENCES `TEST_SUITES` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TEST_CASES_USERS1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `USERS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TEST_CASES_PROJECTS1`
    FOREIGN KEY (`PROJECT_ID`)
    REFERENCES `PROJECTS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WORK_ITEMS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `WORK_ITEMS` ;

CREATE TABLE IF NOT EXISTS `WORK_ITEMS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `JIRA_ID` VARCHAR(45) NOT NULL,
  `TYPE` VARCHAR(45) NOT NULL DEFAULT 'TASK',
  `HASH_CODE` INT NULL,
  `DESCRIPTION` TINYTEXT NULL,
  `USER_ID` INT UNSIGNED NULL,
  `TEST_CASE_ID` INT UNSIGNED NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `WORK_ITEM_UNIQUE` (`JIRA_ID` ASC, `TYPE` ASC, `HASH_CODE` ASC),
  INDEX `fk_WORK_ITEMS_USERS1_idx` (`USER_ID` ASC),
  INDEX `fk_WORK_ITEMS_TEST_CASES1_idx` (`TEST_CASE_ID` ASC),
  CONSTRAINT `fk_WORK_ITEMS_USERS1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `USERS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_WORK_ITEMS_TEST_CASES1`
    FOREIGN KEY (`TEST_CASE_ID`)
    REFERENCES `TEST_CASES` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JOBS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `JOBS` ;

CREATE TABLE IF NOT EXISTS `JOBS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `USER_ID` INT UNSIGNED NULL,
  `NAME` VARCHAR(100) NOT NULL,
  `JOB_URL` VARCHAR(255) NOT NULL,
  `JENKINS_HOST` VARCHAR(255) NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  INDEX `fk_JOBS_USERS1_idx` (`USER_ID` ASC),
  UNIQUE INDEX `JOB_URL_UNIQUE` (`JOB_URL` ASC),
  CONSTRAINT `fk_JOBS_USERS1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `USERS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TEST_RUNS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TEST_RUNS` ;

CREATE TABLE IF NOT EXISTS `TEST_RUNS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CI_RUN_ID` VARCHAR(50) NULL,
  `USER_ID` INT UNSIGNED NULL,
  `TEST_SUITE_ID` INT UNSIGNED NOT NULL,
  `STATUS` VARCHAR(20) NOT NULL,
  `SCM_URL` VARCHAR(255) NULL,
  `SCM_BRANCH` VARCHAR(100) NULL,
  `SCM_COMMIT` VARCHAR(100) NULL,
  `CONFIG_XML` TINYTEXT NULL,
  `WORK_ITEM_ID` INT UNSIGNED NULL,
  `JOB_ID` INT UNSIGNED NOT NULL,
  `BUILD_NUMBER` INT NOT NULL,
  `UPSTREAM_JOB_ID` INT UNSIGNED NULL,
  `UPSTREAM_JOB_BUILD_NUMBER` INT NULL,
  `STARTED_BY` VARCHAR(45) NOT NULL,
  `PROJECT_ID` INT UNSIGNED NULL,
  `KNOWN_ISSUE` TINYINT(1) NOT NULL DEFAULT 0,
  `ENV` VARCHAR(50) NULL,
  `PLATFORM` VARCHAR(30) NULL,
  `STARTED_AT` TIMESTAMP NULL,
  `ELAPSED` INT NULL,
  `ETA` INT NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  INDEX `FK_TEST_RUN_USER_ASC` (`USER_ID` ASC),
  INDEX `FK_TEST_RUN_TEST_SUITE_ASC` (`TEST_SUITE_ID` ASC),
  INDEX `fk_TEST_RUNS_WORK_ITEMS1_idx` (`WORK_ITEM_ID` ASC),
  INDEX `fk_TEST_RUNS_JOBS1_idx` (`JOB_ID` ASC),
  INDEX `fk_TEST_RUNS_JOBS2_idx` (`UPSTREAM_JOB_ID` ASC),
  UNIQUE INDEX `CI_RUN_ID_UNIQUE` (`CI_RUN_ID` ASC),
  INDEX `fk_TEST_RUNS_PROJECTS1_idx` (`PROJECT_ID` ASC),
  CONSTRAINT `fk_TEST_RESULTS_USERS1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `USERS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TEST_RESULTS_TEST_SUITES1`
    FOREIGN KEY (`TEST_SUITE_ID`)
    REFERENCES `TEST_SUITES` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TEST_RUNS_WORK_ITEMS1`
    FOREIGN KEY (`WORK_ITEM_ID`)
    REFERENCES `WORK_ITEMS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TEST_RUNS_JOBS1`
    FOREIGN KEY (`JOB_ID`)
    REFERENCES `JOBS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TEST_RUNS_JOBS2`
    FOREIGN KEY (`UPSTREAM_JOB_ID`)
    REFERENCES `JOBS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TEST_RUNS_PROJECTS1`
    FOREIGN KEY (`PROJECT_ID`)
    REFERENCES `PROJECTS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TEST_CONFIGS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TEST_CONFIGS` ;

CREATE TABLE IF NOT EXISTS `TEST_CONFIGS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `URL` VARCHAR(512) NULL,
  `ENV` VARCHAR(50) NULL,
  `PLATFORM` VARCHAR(30) NULL,
  `PLATFORM_VERSION` VARCHAR(30) NULL,
  `BROWSER` VARCHAR(30) NULL,
  `BROWSER_VERSION` VARCHAR(30) NULL,
  `APP_VERSION` VARCHAR(255) NULL,
  `LOCALE` VARCHAR(30) NULL,
  `LANGUAGE` VARCHAR(30) NULL,
  `DEVICE` VARCHAR(50) NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TESTS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TESTS` ;

CREATE TABLE IF NOT EXISTS `TESTS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(255) NOT NULL,
  `STATUS` VARCHAR(20) NOT NULL,
  `TEST_ARGS` TINYTEXT NULL,
  `TEST_RUN_ID` INT UNSIGNED NOT NULL,
  `TEST_CASE_ID` INT UNSIGNED NOT NULL,
  `MESSAGE` TINYTEXT NULL,
  `START_TIME` TIMESTAMP NULL,
  `FINISH_TIME` TIMESTAMP NULL,
  `DEMO_URL` TINYTEXT NULL,
  `LOG_URL` TINYTEXT NULL,
  `RETRY` INT NOT NULL DEFAULT 0,
  `TEST_CONFIG_ID` INT UNSIGNED NULL,
  `KNOWN_ISSUE` TINYINT(1) NOT NULL DEFAULT 0,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  INDEX `fk_TESTS_TEST_RUNS1_idx` (`TEST_RUN_ID` ASC),
  INDEX `fk_TESTS_TEST_CASES1_idx` (`TEST_CASE_ID` ASC),
  INDEX `fk_TESTS_TEST_CONFIGS1_idx` (`TEST_CONFIG_ID` ASC),
  CONSTRAINT `fk_TESTS_TEST_RUNS1`
    FOREIGN KEY (`TEST_RUN_ID`)
    REFERENCES `TEST_RUNS` (`ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TESTS_TEST_CASES1`
    FOREIGN KEY (`TEST_CASE_ID`)
    REFERENCES `TEST_CASES` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TESTS_TEST_CONFIGS1`
    FOREIGN KEY (`TEST_CONFIG_ID`)
    REFERENCES `TEST_CONFIGS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TEST_WORK_ITEMS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TEST_WORK_ITEMS` ;

CREATE TABLE IF NOT EXISTS `TEST_WORK_ITEMS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TEST_ID` INT UNSIGNED NOT NULL,
  `WORK_ITEM_ID` INT UNSIGNED NOT NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  INDEX `fk_TEST_WORK_ITEMS_TESTS1_idx` (`TEST_ID` ASC),
  INDEX `fk_TEST_WORK_ITEMS_WORK_ITEMS1_idx` (`WORK_ITEM_ID` ASC),
  CONSTRAINT `fk_TEST_WORK_ITEMS_TESTS1`
    FOREIGN KEY (`TEST_ID`)
    REFERENCES `TESTS` (`ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TEST_WORK_ITEMS_WORK_ITEMS1`
    FOREIGN KEY (`WORK_ITEM_ID`)
    REFERENCES `WORK_ITEMS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TEST_METRICS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TEST_METRICS` ;

CREATE TABLE IF NOT EXISTS `TEST_METRICS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `OPERATION` VARCHAR(127) NOT NULL,
  `ELAPSED` BIGINT UNSIGNED NOT NULL COMMENT 'Operation elapsed in ms.',
  `TEST_ID` INT UNSIGNED NOT NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  INDEX `fk_TEST_METRICS_TESTS1_idx` (`TEST_ID` ASC),
  INDEX `TEST_OPERATION` (`OPERATION` ASC),
  CONSTRAINT `fk_TEST_METRICS_TESTS1`
    FOREIGN KEY (`TEST_ID`)
    REFERENCES `TESTS` (`ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WIDGETS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `WIDGETS` ;

CREATE TABLE IF NOT EXISTS `WIDGETS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TITLE` VARCHAR(255) NOT NULL,
  `TYPE` VARCHAR(20) NOT NULL DEFAULT 'linechart',
  `SQL` TINYTEXT NOT NULL,
  `MODEL` TINYTEXT NOT NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `TITLE_UNIQUE` (`TITLE` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SETTINGS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SETTINGS` ;

CREATE TABLE IF NOT EXISTS `SETTINGS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(255) NOT NULL,
  `VALUE` VARCHAR(255) NULL,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `NAME_UNIQUE` (`NAME` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DEVICES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DEVICES` ;

CREATE TABLE IF NOT EXISTS `DEVICES` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `MODEL` VARCHAR(255) NOT NULL,
  `SERIAL` VARCHAR(255) NOT NULL,
  `ENABLED` TINYINT(1) NOT NULL DEFAULT 0,
  `LAST_STATUS` TINYINT(1) NOT NULL DEFAULT 0,
  `DISCONNECTS` INT NOT NULL DEFAULT 0,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `SERIAL_UNIQUE` (`SERIAL` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DASHBOARDS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DASHBOARDS` ;

CREATE TABLE IF NOT EXISTS `DASHBOARDS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TITLE` VARCHAR(255) NOT NULL,
  `TYPE` VARCHAR(255) NOT NULL DEFAULT 'GENERAL',
  `POSITION` INT UNSIGNED NOT NULL DEFAULT 0,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `TITLE_UNIQUE` (`TITLE` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DASHBOARDS_WIDGETS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DASHBOARDS_WIDGETS` ;

CREATE TABLE IF NOT EXISTS `DASHBOARDS_WIDGETS` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `DASHBOARD_ID` INT UNSIGNED NOT NULL,
  `WIDGET_ID` INT UNSIGNED NOT NULL,
  `POSITION` INT UNSIGNED NOT NULL DEFAULT 0,
  `SIZE` INT UNSIGNED NOT NULL DEFAULT 1,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `MODIFIED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  INDEX `fk_DASHBOARDS_WIDGETS_DASHBOARDS1_idx` (`DASHBOARD_ID` ASC),
  INDEX `fk_DASHBOARDS_WIDGETS_WIDGETS1_idx` (`WIDGET_ID` ASC),
  UNIQUE INDEX `DASHBOARD_WIDGET_UNIQUE` (`DASHBOARD_ID` ASC, `WIDGET_ID` ASC),
  CONSTRAINT `fk_DASHBOARDS_WIDGETS_DASHBOARDS1`
    FOREIGN KEY (`DASHBOARD_ID`)
    REFERENCES `DASHBOARDS` (`ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DASHBOARDS_WIDGETS_WIDGETS1`
    FOREIGN KEY (`WIDGET_ID`)
    REFERENCES `WIDGETS` (`ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
