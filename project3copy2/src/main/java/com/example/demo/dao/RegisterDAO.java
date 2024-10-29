package com.example.demo.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface RegisterDAO {
	public int insert_member(String id,
    						 String pwd,
    						 String name,
    						 String birthday,
    						 String tel,
    						 String address,
    						 String signupRoutesString,
    						 String gender);
}