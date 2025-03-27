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

	public Long selectCount(String where){
		Long count = 0L;
		String sql = "SELECT COUNT(*) FROM products";
		if(where != null && where.length() > 0){
			sql += " WHERE " + where;
		}
		ResultSet rs = DBConn.statementQuery(sql);
		try {
			if(rs.next()) {
				count = rs.getLong(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}

	public ArrayList<ProductDto> selectAllByPage(Long page){
		ArrayList<ProductDto> list = new ArrayList<ProductDto>();
		Long count = selectCount(null);
		if(page < 1 || page > count / 10 + 1){
			return list;
		}
		String sql = "WITH " + //
						"PR_RESULT AS ( " + //
						"select " + //
						"ROWNUM as NO, " + //
						"P.pr_id, " + //
						"P.tm_id, " + //
						"P.ca_id," + //
						"P.pr_name, " + //
						"P.pr_regdate, " + //
						"P.pr_thum_img, " + //
						"P.pr_detail_img " + //
						"from products P ORDER BY P.pr_id desc ) " + //
						"SELECT * FROM PR_RESULT " + //
						"WHERE (NO BETWEEN " + (((page - 1) * 10) + 1) + " AND " + (page * 10) + ")";
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
	public ArrayList<ProductDto> selectByCategoriesPage(String[] ca_ids, Long page){
		ArrayList<ProductDto> list = new ArrayList<ProductDto>();
		Long count = null;
		String where = "";
		if(ca_ids != null && ca_ids.length > 0){
			where = " ca_id = \'" + ca_ids[0] + "\'";
			for(int i = 1; i < ca_ids.length; i++){
				where += " OR ca_id = \'" + ca_ids[i] + "\'";
			}
			selectCount(where);
		}
		if(page < 1 || page > count / 10 + 1){
			return list;
		}
		String sql = "WITH " + //
						"PR_RESULT AS ( " + //
						"select " + //
						"ROWNUM as NO, " + //
						"P.pr_id, " + //
						"P.tm_id, " + //
						"P.ca_id," + //
						"P.pr_name, " + //
						"P.pr_regdate, " + //
						"P.pr_thum_img, " + //
						"P.pr_detail_img " + //
						"from products P " + " WHERE " + where + " ORDER BY P.pr_id desc ) " + //
						"SELECT * FROM PR_RESULT " + //
						"WHERE (NO BETWEEN " + (((page - 1) * 10) + 1) + " AND " + (page * 10) + ")";
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
	public ArrayList<ProductDto> selectByTeamsPage(String[] tm_ids, Long page){
		ArrayList<ProductDto> list = new ArrayList<ProductDto>();
		Long count = null;
		String where = "";
		if(tm_ids != null && tm_ids.length > 0){
			where = " tm_id = \'" + tm_ids[0] + "\'";
			for(int i = 1; i < tm_ids.length; i++){
				where += " OR tm_id = \'" + tm_ids[i] + "\'";
			}
		}
		count = selectCount(where);
		if(page < 1 || page > count / 10 + 1){
			return list;
		}
		String sql = "WITH " + //
						"PR_RESULT AS ( " + //
						"select " + //
						"ROWNUM as NO, " + //
						"P.pr_id, " + //
						"P.tm_id, " + //
						"P.ca_id," + //
						"P.pr_name, " + //
						"P.pr_regdate, " + //
						"P.pr_thum_img, " + //
						"P.pr_detail_img " + //
						"from products P " + " WHERE " + where + " ORDER BY P.pr_id desc ) " + //
						"SELECT * FROM PR_RESULT " + //
						"WHERE (NO BETWEEN " + (((page - 1) * 10) + 1) + " AND " + (page * 10) + ")";
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
	public ArrayList<ProductDto> selectByTeamsOrCategoriesPage(String[] tm_ids, String[] ca_ids, Long page){
		ArrayList<ProductDto> list = new ArrayList<ProductDto>();
		Long count = null;
		String where = "";
		if(tm_ids != null && tm_ids.length > 0){
			where = " tm_id = \'" + tm_ids[0] + "\'";
			for(int i = 1; i < tm_ids.length; i++){
				where += " OR tm_id = \'" + tm_ids[i] + "\'";
			}
		}
		if(ca_ids != null && ca_ids.length > 0){
			if (tm_ids != null && tm_ids.length > 0) {
				where += " AND (ca_id = \'" + ca_ids[0] + "\'";
				for(int i = 1; i < ca_ids.length; i++){
					where += " OR ca_id = \'" + ca_ids[i] + "\'";
				}
				where += ")";
			} else {
				where = " ( ca_id = \'" + ca_ids[0] + "\'";
				for(int i = 1; i < ca_ids.length; i++){
					where += " OR ca_id = \'" + ca_ids[i] + "\'";
				}
				where += ") ";
			}
		}
		count = selectCount(where);
		String sql = "WITH " + //
						"PR_RESULT AS ( " + //
						"select " + //
						"ROWNUM as NO, " + //
						"P.pr_id, " + //
						"P.tm_id, " + //
						"P.ca_id, " + //
						"P.pr_name, " + //
						"P.pr_regdate, " + //
						"P.pr_thum_img, " + //
						"P.pr_detail_img " + //
						"from products P " + " WHERE " + where + " ORDER BY P.pr_id desc ) " + //
						"SELECT * FROM PR_RESULT  " + //
						"WHERE (NO BETWEEN " + (((page - 1) * 10) + 1) + " AND " + (page * 10) + ")";
		if(tm_ids != null && tm_ids.length > 0){
			sql += " AND ( tm_id = \'" + tm_ids[0] + "\'";
			for(int i = 1; i < tm_ids.length; i++){
				sql += " OR tm_id = \'" + tm_ids[i] + "\'";
			}
			sql += ")";
		}
		if(ca_ids != null && ca_ids.length > 0){
			if(tm_ids != null && tm_ids.length > 0){
				sql += " AND (ca_id = \'" + ca_ids[0] + "\'";
				for(int i = 1; i < ca_ids.length; i++){
					sql += " OR ca_id = \'" + ca_ids[i] + "\'";
				}
				sql += ")";
			}else{
				sql += " AND ( ca_id = \'" + ca_ids[0] + "\'";
				for(int i = 1; i < ca_ids.length; i++){
					sql += " OR ca_id = \'" + ca_ids[i] + "\'";
				}
				sql += ")";
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

	public ProductDto selectByProductId(long pr_id){
		ProductDto dto = new ProductDto();
		String sql = "SELECT * FROM products WHERE pr_id = " + pr_id;
		ResultSet rs = DBConn.statementQuery(sql);
		try {
			if(rs.next()) {
				dto.setPr_id(rs.getLong("pr_id"));
				dto.setTm_id(rs.getString("tm_id"));
				dto.setCa_id(rs.getString("ca_id"));
				dto.setPr_name(rs.getString("pr_name"));
				dto.setPr_regdate(rs.getTimestamp("pr_regdate").toLocalDateTime());
				dto.setPr_thum_img(rs.getString("pr_thum_img"));
				dto.setPr_detail_img(rs.getString("pr_detail_img"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
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
	public void update(ProductDto dto){
		String sql = "UPDATE products SET " + //
						"tm_id = \'" + dto.getTm_id() + "\', " + //
						"ca_id = \'" + dto.getCa_id() + "\', " + //
						"pr_name = \'" + dto.getPr_name() + "\', " + //
						// "pr_regdate = \'" + dto.getPr_regdate() + "\', " + //
						"pr_thum_img = \'" + dto.getPr_thum_img() + "\', " + //
						"pr_detail_img = \'" + dto.getPr_detail_img() + "\' " + //
						"WHERE pr_id = " + dto.getPr_id();
		DBConn.statementUpdate(sql);
	}
}
