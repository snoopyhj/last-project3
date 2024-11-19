package com.example.security.vo;

import java.sql.Date;
import java.util.Objects; // for equals and hashCode

public class HotelReview {
    
    private int reviewId;          // 리뷰 ID
    private String defaultNum;     // 숙소 고유 번호
    private String userId;         // 사용자 ID
    private int rating;            // 평점
    private String reviewText;     // 리뷰 내용
    private Date reviewDate;       // 리뷰 작성일
    private String imagePath;      // 이미지 경로
    private String hotelName;

    

    // 기본 생성자
    public HotelReview() {
    }

    // 모든 필드를 사용하는 생성자
    public HotelReview(int reviewId, String defaultNum, String userId, int rating, String reviewText, Date reviewDate, String imagePath,String hotelName) {
        this.reviewId = reviewId;
        this.defaultNum = defaultNum;
        this.userId = userId;
        this.rating = rating;
        this.reviewText = reviewText;
        this.reviewDate = reviewDate;
        this.imagePath = imagePath;
        this.hotelName=hotelName;
    }
    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }
    // Getter와 Setter
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
        if (rating < 0 || rating > 5) { // 평점 유효성 검사
            throw new IllegalArgumentException("Rating must be between 0 and 5.");
        }
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

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    // toString 메서드 - 디버깅과 로그를 위한 정보 출력
    @Override
    public String toString() {
        return "HotelReview{" +
                "reviewId=" + reviewId +
                ", defaultNum='" + defaultNum + '\'' +
                ", userId='" + userId + '\'' +
                ", rating=" + rating +
                ", reviewText='" + reviewText + '\'' +
                ", reviewDate=" + reviewDate +
                ", imagePath='" + imagePath + '\'' +
                '}';
    }

    // equals와 hashCode - 객체 비교와 컬렉션 사용 시 유용
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        HotelReview that = (HotelReview) o;
        return reviewId == that.reviewId && 
               Objects.equals(defaultNum, that.defaultNum) &&
               Objects.equals(userId, that.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(reviewId, defaultNum, userId);
    }
}
