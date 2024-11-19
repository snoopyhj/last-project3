package com.example.demo.vo;



public class HotelVO {
    private String address;     // 주소
    private String region;      // 지역코드
    private String type;        // 숙박 시설 종류
    private String img1;        // 이미지1
    private String img2;        // 이미지2
    private String img_auth;    // 이미지 사용 권한
    private String mapy;        // 지도 y좌표
    private String mapx;        // 지도 x좌표
    private String tel;         // 전화번호
    private String name;        // 숙박 시설 이름
    private String subregion;   // 시군구코드
    private String default_num; // 고유 번호
    
    
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

	public String getMapy() {
		return mapy;
	}

	public void setMapy(String mapy) {
		this.mapy = mapy;
	}

	public String getMapx() {
		return mapx;
	}

	public void setMapx(String mapx) {
		this.mapx = mapx;
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

	private String coment;      // 숙박 시설 설명
    private String person;      // 숙박 가능 인원
    private String standard;    // STANDARD룸 가격
    private String deluxe;      // DELUXE룸 가격
    private String suite;       // SUITE룸 가격
    public HotelVO() {}
    
    public HotelVO (String address, String region, String type, String img1, String img2, String img_auth, String mapy, String mapx,
    		String tel, String name, String subregion, String default_num, String coment, String person, String standard, String suite,String deluxe) {
    	this.address = address;
    	this.region = region;
    	this.type = type;
    	this.img1 = img1;
    	this.img2 = img2;
    	this.img_auth = img_auth;
    	this.mapy = mapy;
    	this.mapx = mapx;
    	this.tel = tel;
    	this.name = name;
    	this.subregion = subregion;
    	this.default_num = default_num;
    	this.coment = coment;
    	this.person = person;
    	this.standard = standard;
    	this.suite = suite;
    	this.deluxe=deluxe;
    	
    }
    
    public HotelVO (String default_num) {
    	this.default_num = default_num;
    	System.out.println(default_num);
    }
}
