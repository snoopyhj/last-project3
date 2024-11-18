package com.example.demo.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.example.demo.vo.RecommendVO;



@Mapper
@Repository
public interface RecommendDAO {
	 ArrayList<RecommendVO> recommends();

}


