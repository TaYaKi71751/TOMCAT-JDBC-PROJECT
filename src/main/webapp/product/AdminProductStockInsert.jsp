<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.mlb.product.dao.*" %>
<%@ page import="com.mlb.product.dto.*" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>MLB - AdminProductStockUpdate</title>
</head>
<body>
<%
    String grade = (String) session.getAttribute("grade");
    if(grade == null || !grade.equals("admin")){
        response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
    } else {
        System.out.println("grade: " + grade);
    }
    String productIdString = request.getParameter("productId");
    String productStockIdString = request.getParameter("productStockId");
    String colorId = request.getParameter("colorId");
    String sizeId = request.getParameter("sizeId");
    String priceString = request.getParameter("price");
    String quantityString = request.getParameter("quantity");
    Long productId = null;
    Long productStockId = null;
    Long price = null;
    Long quantity = null;
    try {
        productId = Long.parseLong(productIdString);
        productStockId = Long.parseLong(productStockIdString);
        price = Long.parseLong(priceString);
        quantity = Long.parseLong(quantityString);
    } catch(Exception e){
        response.sendRedirect(request.getContextPath() + "/product/AdminProductList.jsp");
        return;
    }
    ProductStockDao productStockDao = new ProductStockDao();
    ProductStockDto productStock = new ProductStockDto(
        productStockId,
        productId,
        colorId,
        sizeId,
        quantity,
        price
    );

    productStockDao.update(productStock);

    out.println("<h1>상품 재고 수정 완료</h1>");
    Thread.sleep(1000);
    response.sendRedirect(request.getContextPath() + "/product/AdminProductEdit.jsp?productId=" + productId);
%>

</body>
</html>
