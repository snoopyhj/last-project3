package com.example.demo.vo;

import lombok.Data;
import java.util.Date;

@Data
public class HotelReviewVO {
    
    private Date createdAt; 
    private int reviewId;
    private String defaultNum;  
    private String userId;
    private int rating;
    private String reviewText;
    private Date reviewDate;
    
	
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public int getReviewId() {
		return reviewId;
	}
	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}
	public String getDefaultNum() {
		return defaultNum;
	}
	public void setDefaultNum(String defaultNum) {
		this.defaultNum = defaultNum;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getRating() {
		return rating;
	}
	public void setRating(int rating) {
		this.rating = rating;
	}
	public String getReviewText() {
		return reviewText;
	}
	public void setReviewText(String reviewText) {
		this.reviewText = reviewText;
	}
	public Date getReviewDate() {
		return reviewDate;
	}
	public void setReviewDate(Date reviewDate) {
		this.reviewDate = reviewDate;
	}
    


}
