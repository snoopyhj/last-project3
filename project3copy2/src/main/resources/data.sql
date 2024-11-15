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



