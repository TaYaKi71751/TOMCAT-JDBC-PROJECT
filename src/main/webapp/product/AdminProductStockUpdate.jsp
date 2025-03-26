<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    request.setCharacterEncoding("UTF-8");
    session.setAttribute("grade", "admin");
%>
<%@ page import="java.util.*" %>
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
    String teamIdString = request.getParameter("teamId");
    String category = request.getParameter("category");
    Long productId = null;
    try {
        productId = Long.parseLong(productIdString);
    } catch(Exception e){
        response.sendRedirect(request.getContextPath() + "/product/AdminProductList.jsp");
        return;
    }
    ProductDao productDao = new ProductDao();
    ProductDto product = productDao.selectByProductId(productId);
    if(product == null){
        response.sendRedirect(request.getContextPath() + "/product/AdminProductList.jsp");
        return;
    }
    ProductStockDao productStockDao = new ProductStockDao();
    ArrayList<ProductStockDto> productStockList = productStockDao.selectByProductId(productId);
    for(ProductStockDto productStock : productStockList){
        System.out.println(productStock);
    }
    pageContext.setAttribute("product", product);
    pageContext.setAttribute("productStockList", productStockList);
%>

</body>
</html>
