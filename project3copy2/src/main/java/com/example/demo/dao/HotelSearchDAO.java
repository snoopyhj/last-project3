package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.example.demo.vo.HotelVO;
import com.example.demo.vo.RoomTypePrice; // RoomTypePrice 추가

@Mapper
@Repository
public interface HotelSearchDAO {
    public HotelVO select_hotel(HotelVO vo);
    
    public List<HotelVO> selectHotelsByType(@Param("type") String type);

    public HotelVO gotoreservation(@Param("name") String name);
    
    public HotelVO gotohoteldetailbytype(@Param("name") String name);
    
    public HotelVO gotoreservationbytype(@Param("name") String name);

    // 방 타입별 가격 조회 메서드 추가
    public List<RoomTypePrice> getRoomTypesAndPrices(@Param("defaultNum") String defaultNum);
}
