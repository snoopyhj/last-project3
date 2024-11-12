CREATE TABLE hotel_list (
    주소 VARCHAR2(255),                  
    지역코드 VARCHAR2(10), 
    숙박시설종류 VARCHAR2(50),
    이미지1 VARCHAR2(255),              
    이미지2 VARCHAR2(255),              
    이미지사용권한 VARCHAR2(50),        
    mapx VARCHAR2(50),                         
    mapy VARCHAR2(50),                         
    전화번호 VARCHAR2(50),              
    호텔이름 VARCHAR2(120),             
    시군구코드 VARCHAR2(15),
    고유번호 VARCHAR2(5),
    호텔설명 VARCHAR2(1000),
    숙박가능인원 VARCHAR2(10),
    standard VARCHAR2(50),
    deluxe VARCHAR2(50),
    suite VARCHAR2(50)
);


Alter Table hotel_list
rename column 주소 to address;

alter table hotel_list
rename column 지역코드 to region;

alter table hotel_list
rename column 숙박시설종류 to type;

alter table hotel_list
rename column 이미지1 TO img1;

alter table hotel_list
rename column 이미지2 TO Img2;

alter table hotel_list
rename column 이미지사용권한 to img_auth;

alter table hotel_list
rename column 전화번호 to Tel;

alter table hotel_list
rename column 호텔이름 to name;

alter table hotel_list
rename column 시군구코드 to subregion;

alter table hotel_list
rename column 고유번호 to default_num;

alter table hotel_list
rename column 호텔설명 to coment;

alter table hotel_list
rename column 숙박가능인원 to person;

alter table hotel_list
rename column 호텔가격 to cost;


select * from hotel_list;


commit;
