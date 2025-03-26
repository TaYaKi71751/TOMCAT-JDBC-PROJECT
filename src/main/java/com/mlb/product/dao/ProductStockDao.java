package com.mlb.product.dao;

import java.sql.ResultSet;
import java.util.*;

import com.mlb.product.dto.ProductStockDto;
import com.mlb.utils.*;

public class ProductStockDao {
    private static ProductStockDao instance = new ProductStockDao();
    
    private ProductStockDao() {
    }
    
    public static ProductStockDao getInstance() {
        return instance;
    }
    
    public ArrayList<ProductStockDto> selectAll(){
        ArrayList<ProductStockDto> list = new ArrayList<ProductStockDto>();
        String sql = "SELECT * FROM product_stocks";
        ResultSet rs = DBConn.statementQuery(sql);
        rs = DBConn.statementQuery(sql);
        try {
            while(rs.next()) {
                ProductStockDto dto = new ProductStockDto();
                dto.setPr_st_id(rs.getLong("pr_st_id"));
                dto.setPr_id(rs.getLong("pr_id"));
                dto.setCl_id(rs.getString("cl_id"));
                dto.setSz_id(rs.getString("sz_id"));
                dto.setQuantity(rs.getLong("quantity"));
                dto.setPrice(rs.getLong("price"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public ArrayList<ProductStockDto> selectByProduct(Long pr_id){
        ArrayList<ProductStockDto> list = new ArrayList<ProductStockDto>();
        String sql = "SELECT * FROM product_stocks";
        ResultSet rs = DBConn.statementQuery(sql);
        if(pr_id != null){
            sql += " WHERE pr_id = " + pr_id;
        }
        rs = DBConn.statementQuery(sql);
        try {
            while(rs.next()) {
                ProductStockDto dto = new ProductStockDto();
                dto.setPr_st_id(rs.getLong("pr_st_id"));
                dto.setPr_id(rs.getLong("pr_id"));
                dto.setCl_id(rs.getString("cl_id"));
                dto.setSz_id(rs.getString("sz_id"));
                dto.setQuantity(rs.getLong("quantity"));
                dto.setPrice(rs.getLong("price"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateQuantity(Long pr_st_id, Long quantity){
        String sql = "UPDATE product_stock SET quantity = " + quantity + " WHERE pr_st_id = " + pr_st_id;
        DBConn.statementUpdate(sql);
    }
    public void decreaseQuantity(Long pr_st_id, Long quantity){
        String sql = "UPDATE product_stock SET quantity = quantity - " + quantity + " WHERE pr_st_id = " + pr_st_id;
        DBConn.statementUpdate(sql);
    }
    public void increaseQuantity(Long pr_st_id, Long quantity){
        String sql = "UPDATE product_stock SET quantity = quantity + " + quantity + " WHERE pr_st_id = " + pr_st_id;
        DBConn.statementUpdate(sql);
    }
    public void updatePrice(Long pr_st_id, Long price){
        String sql = "UPDATE product_stock SET price = " + price + " WHERE pr_st_id = " + pr_st_id;
        DBConn.statementUpdate(sql);
    }
    public void updatePriceByProduct(Long pr_id, Long price){
        String sql = "UPDATE product_stock SET price = " + price + " WHERE pr_id = " + pr_id;
        DBConn.statementUpdate(sql);
    }
}
