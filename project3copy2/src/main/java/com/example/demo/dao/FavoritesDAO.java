package com.example.demo.dao;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.FavoritesVO;

@Mapper
public interface FavoritesDAO {
    void insertFavorite(FavoritesVO review);
    void deleteFavorite(FavoritesVO review);
    boolean isFavorite(FavoritesVO favorite);
    }