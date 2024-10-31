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