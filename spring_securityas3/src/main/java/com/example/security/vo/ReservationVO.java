package com.example.security.vo;

import java.util.Date;

public class ReservationVO {
    private String impUid;
    private String productName;
    private long cost;
    private String email;
    private String name;
    private String tel;
    private String address;
    private String dateRange;
    private Date payDate;
    private String person;
    private String default_num;
    public String getDefault_num() {
		return default_num;
	}

	public void setDefault_num(String default_num) {
		this.default_num = default_num;
	}

	// Getters and Setters
    public String getImpUid() {
        return impUid;
    }

    public void setImpUid(String impUid) {
        this.impUid = impUid;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public long getCost() {
        return cost;
    }

    public void setCost(long cost) {
        this.cost = cost;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDateRange() {
        return dateRange;
    }

    public void setDateRange(String dateRange) {
        this.dateRange = dateRange;
    }

    public Date getPayDate() {
        return payDate;
    }

    public void setPayDate(Date payDate) {
        this.payDate = payDate;
    }

    public String getPerson() {
        return person;
    }

    public void setPerson(String person) {
        this.person = person;
    }

    @Override
    public String toString() {
        return "ReservationVO{" +
                "impUid='" + impUid + '\'' +
                ", productName='" + productName + '\'' +
                ", cost=" + cost +
                ", email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", tel='" + tel + '\'' +
                ", address='" + address + '\'' +
                ", dateRange='" + dateRange + '\'' +
                ", payDate=" + payDate +
                ", person='" + person + '\'' +
                '}';
    }
}
