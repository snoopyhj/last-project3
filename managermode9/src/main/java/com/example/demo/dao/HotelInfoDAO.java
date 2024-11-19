package com.example.demo.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.example.demo.vo.HotelVO;

@Mapper
public interface HotelInfoDAO {
	int insertHotelReservation(HotelVO hotelVO);
    int insert_hotelinfo(HotelVO hotelVO);
    
    int hotel_update(HotelVO hotelVO);
    
    HotelVO select_hotel_by_default_num(@Param("default_num") String default_num);
    
    boolean existsByDefaultNum(@Param("default_num") String default_num);
}
