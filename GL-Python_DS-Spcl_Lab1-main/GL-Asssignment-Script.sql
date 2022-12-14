
CREATE DATABASE e_commerce;

CREATE TABLE `e_commerce`.`supplier` (
  `SUPP_ID` INT NOT NULL,
  `SUPP_NAME` VARCHAR(50) NULL,
  `SUPP_CITY` VARCHAR(50) NULL,
  `SUPP_PHONE` VARCHAR(10) NULL,
  PRIMARY KEY (`SUPP_ID`));

CREATE TABLE `e_commerce`.`customer` (
  `CUS_ID` INT NOT NULL,
  `CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `CUS_PHONE` VARCHAR(10) NULL,
  `CUS_CITY` VARCHAR(30) NULL,
  `CUS_GENDER` CHAR NULL,
  PRIMARY KEY (`CUS_ID`));

CREATE TABLE `e_commerce`.`category` (
  `CAT_ID` INT NOT NULL,
  `CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`CAT_ID`));

CREATE TABLE `e_commerce`.`product` (
  `PRO_ID` INT NOT NULL,
  `PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
  `CAT_ID` INT NOT NULL,
  PRIMARY KEY (`PRO_ID`),
  INDEX `CAT_ID_idx` (`CAT_ID` ASC) VISIBLE,
  CONSTRAINT `CAT_ID`
    FOREIGN KEY (`CAT_ID`)
    REFERENCES `e_commerce`.`category` (`CAT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `e_commerce`.`product_details` (
  `PROD_ID` INT NOT NULL,
  `PRO_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `PROD_PRICE` INT NOT NULL,
  PRIMARY KEY (`PROD_ID`),
  INDEX `PRO_ID_idx` (`PRO_ID` ASC) VISIBLE,
  INDEX `SUPP_ID_idx` (`SUPP_ID` ASC) VISIBLE,
  CONSTRAINT `PRO_ID`
    FOREIGN KEY (`PRO_ID`)
    REFERENCES `e_commerce`.`product` (`PRO_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `SUPP_ID`
    FOREIGN KEY (`SUPP_ID`)
    REFERENCES `e_commerce`.`supplier` (`SUPP_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `e_commerce`.`order` (
  `ORD_ID` INT NOT NULL,
  `ORD_AMOUNT` INT NOT NULL,
  `ORD_DATE` DATE NULL,
  `CUS_ID` INT NOT NULL,
  `PROD_ID` INT NOT NULL,
  PRIMARY KEY (`ORD_ID`),
  INDEX `CUS_ID_idx` (`CUS_ID` ASC) VISIBLE,
  INDEX `PROD_ID_idx` (`PROD_ID` ASC) VISIBLE,
  CONSTRAINT `CUS_ID`
    FOREIGN KEY (`CUS_ID`)
    REFERENCES `e_commerce`.`customer` (`CUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PROD_ID`
    FOREIGN KEY (`PROD_ID`)
    REFERENCES `e_commerce`.`product_details` (`PROD_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `e_commerce`.`rating` (
  `RAT_ID` INT NOT NULL,
  `CUS_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `RAT_RATSTARS` INT NOT NULL,
  PRIMARY KEY (`RAT_ID`),
  INDEX `SUPP_ID_idx` (`SUPP_ID` ASC) VISIBLE,
  INDEX `CUS_ID_idx` (`CUS_ID` ASC) VISIBLE,
  CONSTRAINT `SUPP_ID_1`
    FOREIGN KEY (`SUPP_ID`)
    REFERENCES `e_commerce`.`supplier` (`SUPP_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CUS_ID_1`
    FOREIGN KEY (`CUS_ID`)
    REFERENCES `e_commerce`.`customer` (`CUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO e_commerce.supplier
VALUES (1,'Rajesh Retails','Delhi','1234567890'),
	(2,'Appario Ltd.','Mumbai','2589631470'),
	(3,'Knome products','Bangalore','9785462315'),
	(4,'Bansal Retails','Kochi','8975463285'),
	(5,'Mittal Ltd.','Lucknow','7898456532');

INSERT INTO e_commerce.customer
VALUES (1,'AAKASH','9999999999','DELHI','M'),
	(2,'AMAN','9785463215','NOIDA','M'),
    (3,'NEHA','9999999998','MUMBAI','F'),
    (4,'MEGHA','9994562399','KOLKATA','F'),
    (5,'PULKIT','7895999999','LUCKNOW','M');

INSERT INTO e_commerce.category
VALUES (1,'BOOKS'),
	(2,'GAMES'),
    (3,'GROCERIES'),
    (4,'ELECTRONICS'),
    (5,'CLOTHES');

INSERT INTO e_commerce.product
VALUES (1,'GTA V','DFJDJFDJFDJFDJFJF',2),
	(2,'TSHIRT','DFDFJDFJDKFD',5),
    (3,'ROG LAPTOP','DFNTTNTNTERND',4),
    (4,'OATS','REURENTBTOTH',3),
    (5,'HARRY POTTER','NBEMCTHTJTH',1);

INSERT INTO e_commerce.product_details
VALUES (1,1,2,1500),
	(2,3,5,30000),
    (3,5,1,3000),
    (4,2,3,2500),
    (5,4,1,1000);

INSERT INTO e_commerce.order
VALUES (20,1500,'2021-10-12',3,5),
	(25,30500,'2021-09-16',5,2),
    (26,2000,'2021-10-05',1,1),
    (30,3500,'2021-08-16',4,3),
    (50,2000,'2021-10-06',2,1);

INSERT INTO e_commerce.rating
VALUES (1,2,2,4),
	(2,3,4,3),
    (3,5,1,5),
    (4,1,3,2),
    (5,4,5,4);

SELECT T.CUS_GENDER AS 'GENDER',COUNT(T.CUS_ID) AS 'COUNT'
FROM (
SELECT O.ORD_AMOUNT,O.CUS_ID,C.CUS_GENDER
FROM e_commerce.order O
INNER JOIN e_commerce.customer C
ON O.CUS_ID=C.CUS_ID
WHERE O.ORD_AMOUNT >= 3000) T
GROUP BY T.CUS_GENDER;

SELECT O.*,PD.PRO_ID,P.PRO_NAME,C.CUS_NAME
FROM e_commerce.order O
INNER JOIN e_commerce.product_details PD
ON O.PROD_ID=PD.PROD_ID
INNER JOIN e_commerce.product P
ON PD.PRO_ID=P.PRO_ID
INNER JOIN e_commerce.customer C
ON O.CUS_ID=C.CUS_ID
WHERE O.CUS_ID=2;

SELECT * FROM e_commerce.supplier
WHERE SUPP_ID IN (
SELECT SUPP_ID FROM e_commerce.product_details 
GROUP BY SUPP_ID
HAVING COUNT(SUPP_ID) > 1);

SELECT CAT_NAME FROM e_commerce.category
WHERE CAT_ID IN (
SELECT CAT_ID FROM e_commerce.product
WHERE PRO_ID IN (
SELECT PRO_ID FROM e_commerce.product_details
WHERE PROD_ID IN (
SELECT PROD_ID FROM e_commerce.order
WHERE ORD_AMOUNT IN (SELECT MIN(ORD_AMOUNT) FROM e_commerce.order))));

SELECT PRO_ID,PRO_NAME FROM e_commerce.product
WHERE PRO_ID IN (
SELECT PRO_ID FROM e_commerce.product_details
WHERE PROD_ID IN (
SELECT PROD_ID FROM e_commerce.order
WHERE ORD_DATE > '2021-10-05'));

SELECT T2.SUPP_ID,S.SUPP_NAME,T2.RAT_RATSTARS,C.CUS_NAME
FROM (
SELECT * FROM (
SELECT *,ROW_NUMBER() OVER(ORDER BY RAT_RATSTARS DESC) AS ORD FROM e_commerce.rating) T
WHERE T.ORD <= 3) T2
INNER JOIN e_commerce.supplier S
ON T2.SUPP_ID=S.SUPP_ID
INNER JOIN e_commerce.customer C
ON T2.CUS_ID=C.CUS_ID;

SELECT CUS_NAME,CUS_GENDER
FROM e_commerce.customer
WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';

SELECT SUM(ORD_AMOUNT) AS TOTAL FROM (
SELECT O.ORD_AMOUNT,O.CUS_ID,C.CUS_GENDER
FROM e_commerce.order O
INNER JOIN e_commerce.customer C
ON O.CUS_ID=C.CUS_ID
WHERE C.CUS_GENDER='M') T;

SELECT * 
FROM e_commerce.customer C
LEFT OUTER JOIN e_commerce.order O
ON C.CUS_ID=O.CUS_ID;