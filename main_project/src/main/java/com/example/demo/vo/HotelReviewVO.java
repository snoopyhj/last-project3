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
    


}
