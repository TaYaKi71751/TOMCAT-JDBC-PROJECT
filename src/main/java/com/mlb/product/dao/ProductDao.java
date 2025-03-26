package com.mlb.product.dao;

import java.sql.ResultSet;
import java.time.*;
import java.util.*;

import com.mlb.product.dto.ProductDto;
import com.mlb.utils.*;

public class ProductDao {
	public ArrayList<ProductDto> selectAll(){
		ArrayList<ProductDto> list = new ArrayList<ProductDto>();
		String sql = "SELECT * FROM products";
		ResultSet rs = DBConn.statementQuery(sql);
		try {
			while(rs.next()) {
				ProductDto dto = new ProductDto();
				dto.setPr_id(rs.getLong("pr_id"));
				dto.setTm_id(rs.getString("tm_id"));
				dto.setCa_id(rs.getString("ca_id"));
				dto.setPr_name(rs.getString("pr_name"));
				dto.setPr_regdate(rs.getTimestamp("pr_regdate").toLocalDateTime());
				dto.setPr_thum_img(rs.getString("pr_thum_img"));
				dto.setPr_detail_img(rs.getString("pr_detail_img"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public ArrayList<ProductDto> selectByCategories(String[] ca_ids){
		ArrayList<ProductDto> list = new ArrayList<ProductDto>();
		String sql = "SELECT * FROM products";
		if(ca_ids != null && ca_ids.length > 0){
			sql += " WHERE ca_id = \'" + ca_ids[0] + "\'";
			for(int i = 1; i < ca_ids.length; i++){
				sql += " OR ca_id = \'" + ca_ids[i] + "\'";
			}
		}
		ResultSet rs = DBConn.statementQuery(sql);
		try {
			while(rs.next()) {
				ProductDto dto = new ProductDto();
				dto.setPr_id(rs.getLong("pr_id"));
				dto.setTm_id(rs.getString("tm_id"));
				dto.setCa_id(rs.getString("ca_id"));
				dto.setPr_name(rs.getString("pr_name"));
				dto.setPr_regdate(rs.getTimestamp("pr_regdate").toLocalDateTime());
				dto.setPr_thum_img(rs.getString("pr_thum_img"));
				dto.setPr_detail_img(rs.getString("pr_detail_img"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public ArrayList<ProductDto> selectByTeams(String[] tm_ids){
		ArrayList<ProductDto> list = new ArrayList<ProductDto>();
		String sql = "SELECT * FROM products";
		if(tm_ids != null && tm_ids.length > 0){
			sql += " WHERE tm_id = \'" + tm_ids[0] + "\'";
			for(int i = 1; i < tm_ids.length; i++){
				sql += " OR tm_id = \'" + tm_ids[i] + "\'";
			}
		}
		ResultSet rs = DBConn.statementQuery(sql);
		try {
			while(rs.next()) {
				ProductDto dto = new ProductDto();
				dto.setPr_id(rs.getLong("pr_id"));
				dto.setTm_id(rs.getString("tm_id"));
				dto.setCa_id(rs.getString("ca_id"));
				dto.setPr_name(rs.getString("pr_name"));
				dto.setPr_regdate(rs.getTimestamp("pr_regdate").toLocalDateTime());
				dto.setPr_thum_img(rs.getString("pr_thum_img"));
				dto.setPr_detail_img(rs.getString("pr_detail_img"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public ArrayList<ProductDto> selectByTeamsOrCategories(String[] tm_ids, String[] ca_ids){
		ArrayList<ProductDto> list = new ArrayList<ProductDto>();
		String sql = "SELECT * FROM products";
		if(tm_ids != null && tm_ids.length > 0){
			sql += " WHERE tm_id = \'" + tm_ids[0] + "\'";
			for(int i = 1; i < tm_ids.length; i++){
				sql += " OR tm_id = \'" + tm_ids[i] + "\'";
			}
		}
		if(ca_ids != null && ca_ids.length > 0){
			if(tm_ids != null && tm_ids.length > 0){
				sql += " AND (ca_id = \'" + ca_ids[0] + "\'";
				for(int i = 1; i < ca_ids.length; i++){
					sql += " OR ca_id = \'" + ca_ids[i] + "\'";
				}
				sql += ")";
			}else{
				sql += " WHERE ca_id = \'" + ca_ids[0] + "\'";
				for(int i = 1; i < ca_ids.length; i++){
					sql += " OR ca_id = \'" + ca_ids[i] + "\'";
				}
			}
		}
		ResultSet rs = DBConn.statementQuery(sql);
		try {
			while(rs.next()) {
				ProductDto dto = new ProductDto();
				dto.setPr_id(rs.getLong("pr_id"));
				dto.setTm_id(rs.getString("tm_id"));
				dto.setCa_id(rs.getString("ca_id"));
				dto.setPr_name(rs.getString("pr_name"));
				dto.setPr_regdate(rs.getTimestamp("pr_regdate").toLocalDateTime());
				dto.setPr_thum_img(rs.getString("pr_thum_img"));
				dto.setPr_detail_img(rs.getString("pr_detail_img"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}
