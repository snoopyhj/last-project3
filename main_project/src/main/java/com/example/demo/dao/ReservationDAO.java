package com.example.demo.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface ReservationDAO {
	public int insert_info(String imp_uid,
			   			   String product_name,
			   			   int cost,
			   			   String email,
			   			   String name,
			   			   String tel,
			   			   String address);
}