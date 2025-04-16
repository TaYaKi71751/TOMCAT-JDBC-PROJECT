<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="com.mlb.product.dao.*" %>
<%@ page import="com.mlb.product.dto.*" %>
<%@ page import="com.mlb.order.pay.dao.*" %>
<%@ page import="com.mlb.order.pay.dto.*" %>
<%@ page import="com.mlb.customer.UserDto" %>
<html>
<head>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript"	src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script>
var IMP = window.IMP;
IMP.init("imp45535874");
</script>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>MLB - OrderInsertDB</title>
    <%
    request.setCharacterEncoding("UTF-8");
    String userIdString = (String) session.getAttribute("user_id");
    Long userId = null;
    String grade = (String) session.getAttribute("grade");
    if(userIdString == null || grade == null || !grade.equals("customer")){
        response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
        return;
    }
    try {
        userId = Long.parseLong(userIdString);
    } catch(Exception e){
        response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
        return;
    }
    String pay_id = request.getParameter("pay_id");
    String shippingAddress = request.getParameter("shipping_address");
    String[] order_detail_ids_string = request.getParameterValues("order_detail_id");
				String success = request.getParameter("success");
    String orderIdString = request.getParameter("order_id");
    Long orderId = null;
    String params = "";
				params += "&shipping_address=" + shippingAddress;
				params += "&pay_id=" + pay_id;
				if(success!= null && success.equals("true")){
				 		params += "&success=true";
				}
    Long totalPrice = 0l;
    ProductStockDao productStockDao = new ProductStockDao();
    OrderDetailDao orderDetailDao = new OrderDetailDao();
    ArrayList<OrderDetailDto> orderDetailList = new ArrayList<OrderDetailDto>();
    for(String order_detail_id_string : order_detail_ids_string){
        params += "&order_detail_id=" + order_detail_id_string;
        Long order_detail_id = null;
        try {
            order_detail_id = Long.parseLong(order_detail_id_string);
        } catch(Exception e){
            response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_order_detail_id" + params);
            return;
        }
        OrderDetailDto orderDetailDto = orderDetailDao.selectByOrderDetailId(order_detail_id);
        if(orderDetailDto == null){
            response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_order_detail_id" + params);
            return;
        }
        if(userId!= orderDetailDto.getUserId()){
            response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_order_detail_id" + params);
            return;
        }
        if(orderDetailDto.getOrderId() != 0){
            response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_order_detail_id" + params);
            return;
        }
        if(orderDetailDto.getOrderQuantity() <= 0){
            response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_order_detail_id" + params);
            return;
        }
        if(orderDetailDto.getOrderQuantity() > productStockDao.selectByProductStockId(orderDetailDto.getPrStId()).getQuantity()){
            response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_order_detail_id" + params);
            return;
        }
        orderDetailList.add(orderDetailDto);
        totalPrice += orderDetailDto.getCurrentTotalPrice();
    }
    if(!("naverpay".equals(pay_id) || "kakao".equals(pay_id) || "card".equals(pay_id))) {
        response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_pay_id" + params);
        return;
    }
    if(orderIdString!= null){
        try {
            orderId = Long.parseLong(orderIdString);
            System.out.println("orderId : " + orderId);
            OrderDao orderDao = new OrderDao();
            OrderDto orderDto = orderDao.selectByOrderId(orderId);
            if(orderDto == null){
                response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_order_id" + params);
                return;
            }
            if(orderDto.getUserId() != userId){
                response.sendRedirect(request.getContextPath() + "/order/payments.jsp?error=invalid_order_id" + params);
                return;
            }
        } catch(Exception e){
            System.out.println("error : " + e);
            orderId = null;
        }
    }
    for(OrderDetailDto orderDetailDto : orderDetailList){
        orderDetailDto.setOrderPrice(orderDetailDto.getCurrentPrice());
				}

    OrderDao orderDao = new OrderDao();
    OrderDto orderDto = new OrderDto();
    orderDto.setUserId(userId);
    orderDto.setOrderDate(LocalDateTime.now());
    orderDto.setTotalPrice(totalPrice);
    orderDto.setPayId(pay_id);
    orderDto.setShippingAddress(shippingAddress);
    if (orderId != null){
        orderDto.setOrderId(orderId);
        params += "&order_id=" + orderId;
        orderDao.update(orderDto);
    } else {
        orderId = orderDao.insert(orderDto);
        params += "&order_id=" + orderId;
    }
				if("kakao".equals(pay_id)){
						out.println("<script>"
							+ "IMP.request_pay({"
+ "		pg: 'kakaopay',"
+ "  pay_method: 'kakaopay',"
+ "		merchant_uid: 'merchant_" + orderId + "',"
+ "		name: 'MLB',"
+ "		amount: " + totalPrice + ","
+"		buyer_email: '',"
+"		buyer_name: '" + ((UserDto)session.getAttribute("user")).getName() + "',"
+"	}, function(rsp) {"
+"		console.log(rsp);"
		
		 //결제 성공 시
+"		if (rsp.success) {"
+"			var msg = '결제가 완료되었습니다.';"
+"			console.log('결제성공 ');"
+					"document.location.href = '" + request.getContextPath() + "/order/OrderInsertDB.jsp?success=true&" + params + "';"
+"		} else {"
+"			var msg = '결제에 실패하였습니다.';"
+"			msg += '에러내용 : ' + rsp.error_msg;"
+"		}"
+"		alert(msg);"
+"      if (!rsp.success) {"
+"          document.location.href = '" + request.getContextPath() + "/order/OrderInsertDB.jsp?success=false" + params + "';"
+"      }"
+"	});"
+"</script>");
				}
				if("card".equals(pay_id)){
						out.println("<script>"
							+ "IMP.request_pay({"
+ "		pg: 'html5_inicis',"
+ "  pay_method: 'card',"
+ "		merchant_uid: 'merchant_" + orderId + "',"
+ "		name: 'MLB',"
+ "		amount: " + totalPrice + ","
+"		buyer_email: '',"
+"		buyer_name: '" + ((UserDto)session.getAttribute("user")).getName() + "',"
+"	}, function(rsp) {"
+"		console.log(rsp);"
		
		 //결제 성공 시
+"		if (rsp.success) {"
+"			var msg = '결제가 완료되었습니다.';"
+"			console.log('결제성공 ');"
+					"document.location.href = '" + request.getContextPath() + "/order/OrderInsertDB.jsp?success=true&" + params + "';"
+"		} else {"
+"			var msg = '결제에 실패하였습니다.';"
+"			msg += '에러내용 : ' + rsp.error_msg;"
+"		}"
+"		alert(msg);"
+"      if (!rsp.success) {"
+"          document.location.href = '" + request.getContextPath() + "/order/OrderInsertDB.jsp?success=false" + params + "';"
+"      }"
+"	});"
+"</script>");

				}
				if(success != null && success.equals("true")){
    for(OrderDetailDto orderDetailDto : orderDetailList){
        orderDetailDto.setOrderId(orderId);
        orderDetailDto.setOrderPrice(orderDetailDto.getCurrentPrice());
        ProductStockDto productStockDto = productStockDao.selectByProductStockId(orderDetailDto.getPrStId());
        System.out.println(productStockDto);
        if(productStockDto.getQuantity() - orderDetailDto.getOrderQuantity() < 0){
            continue;
        }
        productStockDto.setQuantity(productStockDto.getQuantity() - orderDetailDto.getOrderQuantity());
        productStockDao.update(productStockDto);
        orderDetailDao.update(orderDetailDto);
    }
    response.sendRedirect(request.getContextPath() + "/order/OrderPaySuccess.jsp?order_id=" + orderId);
				}
    %>
</head>
<body>

</body>
</html>
