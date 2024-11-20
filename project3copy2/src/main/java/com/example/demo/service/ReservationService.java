package com.example.demo.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.dao.ReservationDAO;

@Service
public class ReservationService {

    private final ReservationDAO reservationDAO;

    public ReservationService(ReservationDAO reservationDAO) {
        this.reservationDAO = reservationDAO;
    }

    @Transactional
    public void createReservation(String imp_uid, String product_name, int cost, 
                                  String email, String name, String tel, 
                                  String address, String dateRange, String dateStr, 
                                  String person, String DEFAULT_NUM) {
        // 트랜잭션 시작
        reservationDAO.insert_info(imp_uid, product_name, cost, email, name, tel, address, dateRange, dateStr, person,
        						   DEFAULT_NUM);

        // 다른 DAO 호출이나 추가 로직도 동일 트랜잭션 내에서 처리 가능
    }
}
