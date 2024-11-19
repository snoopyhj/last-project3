package com.example.demo.vo;

import lombok.Data;

@Data
public class HotelVO {
	public String address; // 주소
	public String region; // 지역코드
	public String type; // 숙박 시설 종류
	public String img1; // 이미지1
	public String img2; // 이미지2
	public String img_auth; // 이미지 사용 권한
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getImg1() {
		return img1;
	}
	public void setImg1(String img1) {
		this.img1 = img1;
	}
	public String getImg2() {
		return img2;
	}
	public void setImg2(String img2) {
		this.img2 = img2;
	}
	public String getImg_auth() {
		return img_auth;
	}
	public void setImg_auth(String img_auth) {
		this.img_auth = img_auth;
	}
	public String getMapx() {
		return mapx;
	}
	public void setMapx(String mapx) {
		this.mapx = mapx;
	}
	public String getMapy() {
		return mapy;
	}
	public void setMapy(String mapy) {
		this.mapy = mapy;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSubregion() {
		return subregion;
	}
	public void setSubregion(String subregion) {
		this.subregion = subregion;
	}
	public String getDefault_num() {
		return default_num;
	}
	public void setDefault_num(String default_num) {
		this.default_num = default_num;
	}
	public String getComent() {
		return coment;
	}
	public void setComent(String coment) {
		this.coment = coment;
	}
	public String getPerson() {
		return person;
	}
	public void setPerson(String person) {
		this.person = person;
	}
	public String getStandard() {
		return standard;
	}
	public void setStandard(String standard) {
		this.standard = standard;
	}
	public String getDeluxe() {
		return deluxe;
	}
	public void setDeluxe(String deluxe) {
		this.deluxe = deluxe;
	}
	public String getSuite() {
		return suite;
	}
	public void setSuite(String suite) {
		this.suite = suite;
	}
	public String getReservation_count() {
		return reservation_count;
	}
	public void setReservation_count(String reservation_count) {
		this.reservation_count = reservation_count;
	}
	public String mapx; // 지도 x좌표
	public String mapy; // 지도 y좌표
	public String tel; // 전화번호
	public String name; // 숙박 시설 이름
	public String subregion; // 시군구코드
	public String default_num; // 고유 번호
	public String coment; // 숙박 시설 설명
	public String person; // 숙박 가능 인원
	public String standard;
	public String deluxe;
	public String suite;
	public String reservation_count;
}