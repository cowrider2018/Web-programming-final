DROP DATABASE IF EXISTS final;
CREATE DATABASE final CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE final;
DROP TABLE IF EXISTS `Member`;
CREATE TABLE `Member` (
    `memberId` INT(8) AUTO_INCREMENT,
    `email` VARCHAR(30),
    `password` VARCHAR(16),
    `memberName` VARCHAR(16),
    `sex` CHAR(1),
    `phoneNumber` VARCHAR(10),
    `address` TEXT,
    `creditCard` VARCHAR(16),
    `lastLoginTime` DATETIME,
    PRIMARY KEY (memberId)
)AUTO_INCREMENT=10000000;
DROP TABLE IF EXISTS `Item`;
CREATE TABLE `Item` (  
	itemId INT(8) AUTO_INCREMENT,
	itemName VARCHAR(16),
	itemDescription TEXT,
	picture TEXT,
	price DECIMAL(10, 2),
	inventoryQuantity INT,
    PRIMARY KEY (itemId)
)AUTO_INCREMENT=10000000;
DROP TABLE IF EXISTS `Type`;
CREATE TABLE `Type` (
    typeId INT(8),
	typeName VARCHAR(16),
	itemId INT(8),
    PRIMARY KEY (itemId)
);
DROP TABLE IF EXISTS `Order`;
CREATE TABLE `Order` (
    orderId INT(8) AUTO_INCREMENT,
	memberId INT(8),
	orderDate DATE,
	paymentMethod VARCHAR(20),
	paymentStatus CHAR(1),
	address TEXT,
	totalPrice DECIMAL(10, 2),
	orderStatus CHAR(1),
	notes TEXT,
    PRIMARY KEY (orderId)
)AUTO_INCREMENT=10000000;
DROP TABLE IF EXISTS `OrderDetails`;
CREATE TABLE `OrderDetails` (
    orderId INT(8),
	itemId INT(8),
	quantity INT,
    PRIMARY KEY (orderId,itemId)
);
DROP TABLE IF EXISTS `Cart`;
CREATE TABLE `Cart` (  
    memberId INT(8),
	itemId INT(8),
	quantity INT,
    PRIMARY KEY (memberId,itemId)
);
DROP TABLE IF EXISTS `Comment`;
CREATE TABLE `Comment` (  
    commentId INT(8),
	itemId INT(8),
	memberId INT(8),
	score INT(1),
	contents TEXT,
	commentDate DATE,
    PRIMARY KEY (commentId)
);