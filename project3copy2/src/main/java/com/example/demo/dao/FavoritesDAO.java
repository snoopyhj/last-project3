package com.example.demo.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface FavoritesDAO {
    void insertFavorite(String default_num, String username);
    void deleteFavorite(String default_num, String username);
    boolean isFavorite(String default_num, String username);
}