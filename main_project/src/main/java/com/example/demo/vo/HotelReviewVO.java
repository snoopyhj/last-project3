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
    
    // getter 및 setter 추가
    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }


}
