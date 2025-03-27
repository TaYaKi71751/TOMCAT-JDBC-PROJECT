<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
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
    String productName = request.getParameter("productName");
    String teamId = request.getParameter("teamId");
    String category = request.getParameter("categoryId");
    String productThumbnailImage = request.getParameter("productThumbnailImage");
    String productDetailImage = request.getParameter("productDetailImage");
    Long productId = null;
    try {
        productId = Long.parseLong(productIdString);
    } catch(Exception e){
        response.sendRedirect(request.getContextPath() + "/product/AdminProductList.jsp");
        return;
    }
    ProductDao productDao = new ProductDao();
    ProductDto product = new ProductDto(
        productId,
        teamId,
        category,
        productName,
        null,
        productThumbnailImage,
        productDetailImage
    );
    productDao.update(product);

    out.println("<h1>상품 수정 완료</h1>");
    Thread.sleep(1000);
    response.sendRedirect(request.getContextPath() + "/product/AdminProductEdit.jsp?productId=" + productId);
%>

</body>
</html>
