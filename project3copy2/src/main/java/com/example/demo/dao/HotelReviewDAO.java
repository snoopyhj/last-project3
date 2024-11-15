package com.example.demo.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.demo.vo.HotelReviewVO;

@Mapper
public interface HotelReviewDAO {
    void insertReview(HotelReviewVO review);
    List<HotelReviewVO> getReviewsByHotel(String defaultNum);  // 호텔의 default_num을 기준으로 조회
}