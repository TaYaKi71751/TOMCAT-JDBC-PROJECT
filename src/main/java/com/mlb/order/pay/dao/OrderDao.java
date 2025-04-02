package com.mlb.order.pay.dao;

import java.sql.ResultSet;
import java.util.ArrayList;

import com.mlb.order.pay.dto.OrderDto;
import com.mlb.utils.DBConn;
import com.mlb.utils.UserInput;

public class OrderDao {
    public Long insert(OrderDto dto){
        String sql = "INSERT INTO orders (user_id, order_date, total_price, pay_id, shipping_address, shipping_date) VALUES (" + dto.getUserId() + ", TO_DATE(\'" + UserInput.dateToString(dto.getOrderDate()) + "\',\'YYYY-MM-DD HH24:MI:SS\'), " + dto.getTotalPrice() + ", \'" + dto.getPayId() + "\', \'" + dto.getShippingAddress() + "\', " + "NULL" + ")";
        System.out.println(sql);
        DBConn.statementUpdate(sql);
        sql = "SELECT MAX(order_id) FROM orders WHERE user_id = " + dto.getUserId();
        ResultSet rs = DBConn.statementQuery(sql);
        try {
            if(rs.next()){
                return rs.getLong(1);
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return 0l;
    }

    public void update(OrderDto dto){
        String sql = "UPDATE order SET " + //
                        "user_id = " + dto.getUserId() + ", " +
                        "order_date = TO_DATE(\'" + UserInput.dateToString(dto.getOrderDate()) + "\',\'YYYY-MM-DD HH24:MI:SS\'), " + 
                        "total_price = \'" + dto.getTotalPrice() + "\', " + //
                        "pay_id = \'" + dto.getPayId() + "\', " + //
                        "shipping_address = \'" + dto.getShippingAddress() + "\', " + //
                        "shipping_date = TO_DATE(\'" + UserInput.dateToString(dto.getShippingDate()) + "\',\'YYYY-MM-DD HH24:MI:SS\'), " + //
                        "WHERE order_id = " + dto.getOrderId();
        DBConn.statementUpdate(sql);
    }

    public ArrayList<OrderDto> selectAll() {
        String sql = "SELECT * FROM orders";
        ResultSet rs = DBConn.statementQuery(sql);
        ArrayList<OrderDto> list = new ArrayList<OrderDto>();
        try {
            while(rs.next()){
                OrderDto dto = new OrderDto();
                dto.setOrderId(rs.getLong("order_id"));
                dto.setUserId(rs.getLong("user_id"));
                dto.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                dto.setTotalPrice(rs.getLong("total_price"));
                dto.setPayId(rs.getString("pay_id"));
                dto.setShippingAddress(rs.getString("shipping_address"));
                dto.setShippingDate(rs.getTimestamp("shipping_date").toLocalDateTime());
                list.add(dto);
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<OrderDto> selectByUserId(Long userId){
        String sql = "SELECT * FROM orders WHERE user_id = " + userId;
        ResultSet rs = DBConn.statementQuery(sql);
        ArrayList<OrderDto> list = new ArrayList<OrderDto>();
        try {
            while(rs.next()){
                OrderDto dto = new OrderDto();
                dto.setOrderId(rs.getLong("order_id"));
                dto.setUserId(rs.getLong("user_id"));
                dto.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                dto.setTotalPrice(rs.getLong("total_price"));
                dto.setPayId(rs.getString("pay_id"));
                dto.setShippingAddress(rs.getString("shipping_address"));
                dto.setShippingDate(rs.getTimestamp("shipping_date").toLocalDateTime());
                list.add(dto);
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public OrderDto selectByOrderId(Long orderId){
        String sql = "SELECT * FROM orders WHERE order_id = " + orderId;
        ResultSet rs = DBConn.statementQuery(sql);
        OrderDto dto = null;
        try {
            if(rs.next()){
                dto = new OrderDto();
                dto.setOrderId(rs.getLong("order_id"));
                dto.setUserId(rs.getLong("user_id"));
                dto.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                dto.setTotalPrice(rs.getLong("total_price"));
                dto.setPayId(rs.getString("pay_id"));
                dto.setShippingAddress(rs.getString("shipping_address"));
                dto.setShippingDate(rs.getTimestamp("shipping_date").toLocalDateTime());
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return dto;
    }
}
