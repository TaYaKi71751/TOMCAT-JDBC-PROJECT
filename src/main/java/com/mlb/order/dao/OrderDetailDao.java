package com.mlb.order.dao;

import java.sql.ResultSet;
import java.util.ArrayList;

import com.mlb.order.dto.*;
import com.mlb.utils.*;

public class OrderDetailDao {
    public ArrayList<OrderDetailDto> selectCartByUserId(Long user_id) {
        ArrayList<OrderDetailDto> dtos = new ArrayList<OrderDetailDto>();
        String sql = "SELECT * FROM order_details WHERE order_id is NULL AND user_id = " + user_id;
        ResultSet rs = DBConn.statementQuery(sql);
        try {
            while (rs.next()) {
                OrderDetailDto dto = new OrderDetailDto();
                dto.setOrderDetailId(rs.getLong("order_detail_id"));
                dto.setOrderId(rs.getLong("order_id"));
                dto.setUserId(rs.getLong("user_id"));
                dto.setPrStId(rs.getLong("pr_st_id"));
                dto.setOrderQuantity(rs.getLong("order_quantity"));
                dto.setOrderPrice(rs.getLong("order_price"));
                dtos.add(dto);
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return dtos;
    }

    public ArrayList<OrderDetailDto> selectOrderByOrderId(Long order_id){
        ArrayList<OrderDetailDto> dtos = new ArrayList<OrderDetailDto>();
        String sql = "SELECT * FROM order_details WHERE order_id = " + order_id;
        ResultSet rs = DBConn.statementQuery(sql);
        try {
            while (rs.next()) {
                OrderDetailDto dto = new OrderDetailDto();
                dto.setOrderDetailId(rs.getLong("order_detail_id"));
                dto.setOrderId(rs.getLong("order_id"));
                dto.setUserId(rs.getLong("user_id"));
                dto.setPrStId(rs.getLong("pr_st_id"));
                dto.setOrderQuantity(rs.getLong("order_quantity"));
                dto.setOrderPrice(rs.getLong("order_price"));
                dtos.add(dto);
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return dtos;
    }

    public void insert(OrderDetailDto dto) {
        String sql = "INSERT INTO order_details (order_id, user_id, pr_st_id, order_quantity, order_price) VALUES (" +
            dto.getOrderId() + ", " +
            dto.getUserId() + ", " +
            dto.getPrStId() + ", " +
            dto.getOrderQuantity() + ", " +
            dto.getOrderPrice() +  
        ")";
        DBConn.statementUpdate(sql);
    }
}
