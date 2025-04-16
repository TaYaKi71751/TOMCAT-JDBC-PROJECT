<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="org.json.*" %>
<%@ page import="java.net.http.*"%>
<%@ page import="java.net.*" %>
<%@ page import="com.mlb.customer.UserDto"%>
<%@ page import="com.mlb.order.pay.dao.*"%>
<%@ page import="com.mlb.order.pay.dto.*"%>
<%@ page import="java.util.*"%>

<%@ page import="java.io.*"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <%
    request.setCharacterEncoding("UTF-8");
    UserDto userDto = (UserDto) session.getAttribute("user");
    if(userDto == null){
        response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
        return;
    }
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

    OrderDao orderDao = new OrderDao();
    OrderDto orderDto = null;
    String orderIdString = request.getParameter("order_id");
    Long orderId = null;
    if(orderIdString!= null){
        try {
            orderId = Long.parseLong(orderIdString);
            orderDto = orderDao.selectByOrderId(orderId);
            if(orderDto == null){
                out.println("<script>alert('주문번호가 올바르지 않습니다.');</script>");
                out.println("<script>location.href='" + request.getContextPath() + "/order/orderList.jsp?view=order';</script>");
                return;
            }
            if(orderDto.getUserId() != userId){
                out.println("<script>alert('주문번호가 올바르지 않습니다.');</script>");
                out.println("<script>location.href='" + request.getContextPath() + "/order/orderList.jsp?view=order';</script>");
                return;
            }
        } catch(Exception e){
                out.println("<script>alert('주문번호가 올바르지 않습니다.');</script>");
                out.println("<script>location.href='" + request.getContextPath() + "/order/orderList.jsp?view=order';</script>");
                return;
        }
    }
    Long totalPrice = orderDto.getTotalPrice();
    String imp_key = "";
    String imp_secret = "";
    HttpRequest.Builder requestBuilder = HttpRequest.newBuilder();
    requestBuilder.uri(URI.create("https://api.iamport.kr/users/getToken"));
    requestBuilder.header("Content-Type", "application/json");
    HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString("{\"imp_key\": \"" + imp_key + "\", \"imp_secret\": \"" + imp_secret + "\"}");
    requestBuilder.POST(bodyPublisher);
    HttpRequest httpRequest = requestBuilder.build();
    HttpResponse<String> httpResponse = null;
    try {
        httpResponse = HttpClient.newHttpClient().send(httpRequest, HttpResponse.BodyHandlers.ofString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    String responseBody = httpResponse.body();
    System.out.println("responseBody: " + responseBody);
    String accessToken = null;
    try {
        JSONObject jsonObject = new JSONObject(responseBody);
        if(jsonObject.getLong("code") == 0l){
            accessToken = jsonObject.getJSONObject("response").getString("access_token");
        } else {
            out.println("<script>alert('결제 취소를 위한 토큰 발급에 실패했습니다.');</script>");
            out.println("<script>location.href='" + request.getContextPath() + "/order/orderList.jsp?view=order';</script>");
            return;
        }
    } catch (JSONException e) {
        e.printStackTrace();
    }
    requestBuilder = HttpRequest.newBuilder();
    requestBuilder.header("Authorization", accessToken);
    requestBuilder.header("Content-Type", "application/json");
    requestBuilder.uri(URI.create("https://api.iamport.kr/payments/cancel"));
    bodyPublisher = HttpRequest.BodyPublishers.ofString("{\"merchant_uid\": \"merchant_" + orderDto.getOrderId() + "\", \"amount\": " + totalPrice + ", \"reason\": \"주문 취소\"}");
    requestBuilder.POST(bodyPublisher);
    httpRequest = requestBuilder.build();
    try {
        httpResponse = HttpClient.newHttpClient().send(httpRequest, HttpResponse.BodyHandlers.ofString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    responseBody = httpResponse.body();
    System.out.println("responseBody: " + responseBody);
    try {
        JSONObject jsonObject = new JSONObject(responseBody);
        if(jsonObject.getLong("code") == 0l){
            out.println("<script>alert('결제가 취소되었습니다.');</script>");
        } else {
            out.println("<script>alert('결제 취소에 실패했습니다.');</script>");
        }
    } catch (JSONException e) {
        e.printStackTrace();
    }
    OrderDetailDao orderDetailDao = new OrderDetailDao();
    ArrayList<OrderDetailDto> orderDetailList = orderDetailDao.selectByOrderId(orderId);
    for(OrderDetailDto orderDetailDto : orderDetailList){
        orderDetailDto.setOrderId(null);
        orderDetailDao.update(orderDetailDto);
    }
    orderDao.delete(orderId);
    out.println("<script>location.href='" + request.getContextPath() + "/order/orderList.jsp?view=order';</script>");
    

    %>
</head>
<body>

</body>
</html>
