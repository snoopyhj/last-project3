package com.example.demo.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.example.demo.vo.HotelVO;

@Mapper
public interface HotelDAO {
    @Select("SELECT * FROM hotel_list WHERE default_num = #{defaultNum}")
    HotelVO getHotelByDefaultNum(String defaultNum);
}
