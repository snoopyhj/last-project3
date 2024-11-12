CREATE TABLE reservation(
	imp_uid VARCHAR2(100) PRIMARY KEY,
	product_name VARCHAR2(100) NOT NULL,
	cost NUMBER(30) NOT NULL,
	email VARCHAR2(100) NOT NULL,
	name VARCHAR2(100) NOT NULL,
	tel VARCHAR2(100) NOT NULL,
	address VARCHAR2(100) NOT NULL,
	daterange VARCHAR2(1000),
	pay_date DATE,
	person VARCHAR2(100)
);