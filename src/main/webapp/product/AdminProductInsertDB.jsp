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
    <title>MLB - AdminProductInsertDB</title>
</head>
<body>
<jsp:include page="/topnavigator.jsp"></jsp:include>
<%
    request.setCharacterEncoding("UTF-8");
    String grade = (String) session.getAttribute("grade");
    if(grade == null || !grade.equals("admin")){
        response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
        return;
    } else {
        System.out.println("grade: " + grade);
    }
    String productName = request.getParameter("productName");
    String teamId = request.getParameter("teamId");
    String category = request.getParameter("categoryId");
    String productThumbnailImage = request.getParameter("productThumbnailImage");
    String productDetailImage = request.getParameter("productDetailImage");
    Long productId = null;
    ProductDao productDao = new ProductDao();
    ProductDto product = new ProductDto(
        null,
        teamId,
        category,
        productName,
        null,
        productThumbnailImage,
        productDetailImage
    );
    ArrayList<ProductDto> productList = productDao.searchWithoutProductId(product);
    if(productList.size() > 0){
        response.sendRedirect(request.getContextPath() + "/product/AdminProductAdd.jsp?error=exist");
        return;
    }
    productDao.insert(product);
    productId = productDao.getMaxProductId();

    response.sendRedirect(request.getContextPath() + "/product/AdminProductEdit.jsp?productId=" + productId);
%>

</body>
</html>
