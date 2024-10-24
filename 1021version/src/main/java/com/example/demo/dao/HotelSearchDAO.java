package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.example.demo.vo.HotelVO;

@Mapper
@Repository
public interface HotelSearchDAO {
	public HotelVO select_hotel(HotelVO vo);
	
	public List<HotelVO> selectHotelsByType(@Param("type") String type);

	public HotelVO gotoreservation(@Param("name") String name);
}