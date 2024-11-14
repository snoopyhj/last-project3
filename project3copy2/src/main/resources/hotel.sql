CREATE TABLE hotel_list (
    address VARCHAR2(255),                  
    region VARCHAR2(10), 
    type VARCHAR2(50),
    img1 VARCHAR2(255),              
    Img2 VARCHAR2(255),              
    img_auth VARCHAR2(50),        
    mapx VARCHAR2(50),                         
    mapy VARCHAR2(50),                         
    Tel VARCHAR2(50),              
    name VARCHAR2(120),             
    subregion VARCHAR2(15),
    default_num VARCHAR2(5),
    coment VARCHAR2(1000),
    person VARCHAR2(10),
    standard VARCHAR2(50),
    deluxe VARCHAR2(50),
    suite VARCHAR2(50)
);



CREATE TABLE hotel_reviews (
    REVIEW_ID NUMBER PRIMARY KEY,
    DEFAULT_NUM VARCHAR2(50 BYTE) NOT NULL,
    USER_ID VARCHAR2(50 BYTE) NOT NULL,
    RATING NUMBER(1,0) CHECK (RATING BETWEEN 1 AND 5),
    REVIEW_TEXT CLOB,
    REVIEW_DATE DATE DEFAULT SYSDATE,
    IMAGE_PATH VARCHAR2(255 BYTE)
);


commit;

