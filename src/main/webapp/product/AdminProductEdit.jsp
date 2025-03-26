<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ page import="com.mlb.product.dao.*" %>
<%@ page import="com.mlb.product.dto.*" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Font.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/AdminProductEdit.css">
<%
    request.setCharacterEncoding("UTF-8");
    session.setAttribute("grade", "admin");
%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%
        String grade = (String) session.getAttribute("grade");
        if(grade == null || !grade.equals("admin")){
            response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
        } else {
            System.out.println("grade: " + grade);
        }
        String productIdString = request.getParameter("productId");
        Long productId = null;
        try {
            productId = Long.parseLong(productIdString);
        } catch(Exception e){
            response.sendRedirect(request.getContextPath() + "/product/List.jsp");
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
        TeamDao teamDao = new TeamDao();
        ArrayList<TeamDto> teamList = teamDao.selectAll();
        pageContext.setAttribute("teamList", teamList);
        pageContext.setAttribute("product", product);
        pageContext.setAttribute("productStockList", productStockList);
    %>
    <title>MLB - AdminProductEdit</title>
</head>
<body>
    <form action="" method="post">
        <h1>상품 수정</h1>
        <table>
            <tr>
                <th>상품명</th>
                <th>팀</th>
                <th>카테고리</th>
            </tr>
            <tr>
                <td>${product.getPr_name()}</td>
                <td>${product.getTm_name()}</td>
                <td>${product.getCa_id()}</td>
            </tr>
            <tr>
                <td><input class="product-name" type="text" name="productName" value="${product.getPr_name()}"></td>
                <td>
                    <select class="product-team" name="teamId">
                    <c:forEach var="team" items="${teamList}">
                        <option value="${team.getTm_id()}">${team.getTm_name()}</option>
                    </c:forEach>
                    </select>
                </td>
                <td>
                    <select class="product-category" name="categoryId">
                        <option value="Season">Season</option>
                        <option value="BallCap">BallCap</option>
                        <option value="Hat">Hat</option>
                        <option value="Beanie">Beanie</option>
                    </select>
                </td>
                </table>
        <table>
            <tr>
                <th>선택</th>
                <th>색상</th>
                <th>사이즈</th>
                <th>가격</th>
                <th>재고</th>
                <th>제품 이미지</th>
                <th>설명 이미지</th>
            </tr>
            <c:forEach var="productStock" items="${productStockList}">
            <tr>
                <td>
                    <input class="product-id" type="hidden" name="productId" value="<%= product.getPr_id() %>">
                    <input type="radio" name="productStockId" value="${productStock.getPr_st_id()}">
                </td>
                <td><label class="product-color" for="colorId">${productStock.getCl_name()}</label></td>
                <td><label class="product-size" for="sizeId">${productStock.getSz_id()}</label></td>
                <td><label class="product-price" for="price">${productStock.getPrice()}</label></td>
                <td><label class="product-quantity" for="quantity">${productStock.getQuantity()}</label></td>
                <td><label class="product-thumbnail-image" for="productThumbnailImage">${product.getPr_thum_img()}</label></td>
                <td><label class="product-detail-image">${product.getPr_detail_img()}</label></td>
            </tr>
            </c:forEach>
            <tr>
                <td></td>
                <td>
                    <select class="product-color" name="colorId">
                        <option value="WT">White</option>
                        <option value="BLK">Black</option>
                        <option value="BLE">Blue</option>
                        <option value="RED">Red</option>
                        <option value="GN">Green</option>
                        <option value="PK">Pink</option>
                        <option value="BG">Beige</option>
                        <option value="BR">Brown</option>
                        <option value="GR">Gray</option>
                    </select>
                </td>
                <td>
                    <select class="product-size" name="sizeId">
                        <option value="XS">XS</option>
                        <option value="S">S</option>
                        <option value="M">M</option>
                        <option value="L">L</option>
                        <option value="XL">XL</option>
                        <option value="XXL">XXL</option>
                    </select>
                </td>
                <td><input class="product-price" type="number" name="price" value="0"></td>
                <td><input class="product-quantity" type="number" name="quantity" value="0"></td>
                <td><input class="product-thumbnail-image" type="text" name="productThumbnailImage" value=""></td>
                <td><input class="product-detail-image" type="text" name="productDetailImage" value=""></td>
            </tr>
            <tr>
                <td colspan="8">
                    <input type="submit" value="재고 정보 수정" formaction="<%= request.getContextPath() %>/product/AdminProductStockUpdate.jsp">
                    <input type="submit" value="재고 정보 삭제" formaction="<%= request.getContextPath() %>/product/AdminProductStockDelete.jsp">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
