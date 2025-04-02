package com.mlb.order.dao;

import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import com.mlb.order.dto.*;
import com.mlb.order.dto.option.OrderDetail;
import com.mlb.order.dto.option.OrderNo;
import com.mlb.order.dto.option.Product;
import com.mlb.utils.DBConn;

public class OrderListDao {
	
	
	// 전체 주문 리스트 
	public ArrayList<OrderDto> selectOrderListAll(){
		
		return null;
	}
	
	// 회원 주문 리스트 
	public ArrayList<OrderDto> selectOrderList(Long userId){
			
		// 'BallCap' , 'Hat'  , 'Season' ,'Beanie'
		ArrayList<OrderDto> orderList = new ArrayList<>();
		String sql = "select O.order_id,O.order_date,O.total_price,O.pay_id,O.shipping_address,O.shipping_date ";
		sql += "from ORDERS O ";
		sql += String.format("where O.user_id = %d " , userId );
		sql += "order by order_date desc";
				
		System.out.println(sql);
		ResultSet rs = DBConn.statementQuery(sql);
		
		try {
			
			ArrayList<OrderNo> orderNolist = new ArrayList<>();
			// 주문 리스트 가져오기
			while (rs.next()) {
				
				OrderNo orderNo = new OrderNo( rs.getLong("order_id") , 
						rs.getTimestamp("order_date").toLocalDateTime(), 
						rs.getInt("total_price"), 
						rs.getString("pay_id") ,
						rs.getString("shipping_address") ,
						rs.getTimestamp("shipping_date").toLocalDateTime() );
				
				orderNolist.add(orderNo);
			}

			// 주문 상세 정보 가져오기.
			for (OrderNo orderNo : orderNolist) {
				
				ArrayList<OrderDetail> orderDetails = new ArrayList<>();
				
				StringBuilder sb = new StringBuilder();
				
				sb.append("select ");
				sb.append("O.order_id, ");
				sb.append("OD.user_id, ");
				sb.append("OD.order_detail_id, ");
				sb.append("OD.order_quantity, ");
				sb.append("OD.order_price, ");
				sb.append("P.pr_id, ");
				sb.append("P.tm_id, ");
				sb.append("P.pr_name, ");
				sb.append("p.pr_thum_img, ");
				sb.append("P.tm_id, ");
				sb.append("PS.pr_st_id, ");
				sb.append("PS.cl_id, ");
				sb.append("PS.sz_id ");
				sb.append("from ORDERS O , ORDER_DETAILS OD , product_stocks PS , products P ");
				sb.append("where O.order_id = OD.order_id and ");
				sb.append(String.format("O.user_id = %d and ", userId));
				sb.append("OD.pr_st_id = PS.pr_st_id and ");
				sb.append("PS.pr_id = P.pr_id and ");
				sb.append(String.format("O.order_id = %d", orderNo.getOrderId()));
				
				sql = sb.toString();
				rs = DBConn.statementQuery(sql);
				System.out.println(sql);
				
				while (rs.next()) {
					OrderDetail od = new OrderDetail( rs.getLong("user_id"), 
							rs.getLong("order_detail_id") , 
							rs.getInt("order_quantity" ), 
							rs.getInt("order_price"), 
							rs.getString("pr_name"),
							rs.getString("pr_thum_img"),
							rs.getLong("pr_id"), 			
							rs.getLong("pr_st_id"),
							rs.getString("cl_id"),
							rs.getString("sz_id")
							);
					
					orderDetails.add(od);
				}
				
				OrderDto orderDto = new OrderDto(orderNo,orderDetails);
				orderList.add(orderDto);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConn.dbClose();
		}

		return orderList;
	}
	
	// 회원 장바구니 리스트 
	public ArrayList<OrderDto> selectUserCartList(Long userId){
			
		return null;
	}
	

}
