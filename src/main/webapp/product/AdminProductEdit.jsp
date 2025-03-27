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
        ColorDao colorDao = new ColorDao();
        ArrayList<ColorDto> colorList = colorDao.selectAll();
        pageContext.setAttribute("teamList", teamList);
        pageContext.setAttribute("colorList", colorList);
        pageContext.setAttribute("product", product);
        pageContext.setAttribute("productStockList", productStockList);
    %>
    <title>MLB - AdminProductEdit</title>
    <script>
        function selectProductStock(productStockId){
            let productStockIdElement = document.querySelector('input[name="productStockId"][value="' + productStockId + '"]');
            let color = productStockIdElement.parentElement.parentElement.querySelector("label.product-color").id;
            let size = productStockIdElement.parentElement.parentElement.querySelector("label.product-size").id;
            let price = productStockIdElement.parentElement.parentElement.querySelector("label.product-price").id;
            let quantity = productStockIdElement.parentElement.parentElement.querySelector("label.product-quantity").id;
            try {
                document.querySelector('.product-color > [selected="selected"]').removeAttribute("selected");
            } catch(e){}
            document.querySelector('.product-color > option[value="' + color + '"]').setAttribute("selected", "selected");
            try {
                document.querySelector('.product-size > [selected="selected"]').removeAttribute("selected");
            } catch(e){}
            document.querySelector('.product-size > option[value="' + size + '"]').setAttribute("selected", "selected");
            document.querySelector("input.product-price").setAttribute("value", price);
            document.querySelector("input.product-quantity").setAttribute("value", quantity);
        }
    </script>
</head>
<body>
<jsp:include page="/topnavigator.jsp"></jsp:include>
    <div class="product">
    <form action="" method="post">
        <h1>상품 수정</h1>
        <table>
            <tr>
                <th>상품명</th>
                <th>팀</th>
                <th>카테고리</th>
                <th>제품 이미지</th>
                <th>설명 이미지</th>
                <th>상품 등록 일자</th>
            </tr>
            <tr>
                <input class="product-id" type="hidden" name="productId" value="<%= product.getPr_id() %>">
                <td><label class="product-name">${product.getPr_name()}</label></td>
                <td><label class="product-team">${product.getTm_name()}</label></td>
                <td><label class="product-category">${product.getCa_id()}</label></td>
                <td><label class="product-thumbnail-image">${product.getPr_thum_img()}</label></td>
                <td><label class="product-detail-image">${product.getPr_detail_img()}</label></td>
                <td><label class="product-regdate">${product.getPr_regdate().toString()}</label></td>
            </tr>
            <tr>
                <td><input class="product-name" type="text" name="productName" value="${product.getPr_name()}"></td>
                <td>
                    <select class="product-team" name="teamId">
                    <c:forEach var="team" items="${teamList}">
                        <option value="${team.getTm_id()}" <%
                            if(product.getTm_id().equals(((TeamDto)pageContext.getAttribute("team")).getTm_id())){
                                out.print("selected");
                            }
                        %>>${team.getTm_name()}</option>
                    </c:forEach>
                    </select>
                </td>
                <td>
                    <select class="product-category" name="categoryId">
                        <option value="Season" <%
                            if(product.getCa_id().equals("Season")){
                                out.print("selected");
                            }
                        %>>Season</option>
                        <option value="BallCap" <%
                            if(product.getCa_id().equals("BallCap")){
                                out.print("selected");
                            }
                        %>>BallCap</option>
                        <option value="Hat" <%
                            if(product.getCa_id().equals("Hat")){
                                out.print("selected");
                            }
                        %>>Hat</option>
                        <option value="Beanie" <%
                            if(product.getCa_id().equals("Beanie")){
                                out.print("selected");
                            }
                        %>>Beanie</option>
                    </select>
                </td>
                <td><input class="product-thumbnail-image" type="text" name="productThumbnailImage" value="${product.getPr_thum_img()}"></td>
                <td><input class="product-detail-image" type="text" name="productDetailImage" value="${product.getPr_detail_img()}"></td>
            </tr>
            <tr>
                <td colspan="8">
                    <input type="submit" value="상품 정보 수정" formaction="<%= request.getContextPath() %>/product/AdminProductUpdate.jsp">
                    <input type="submit" value="상품 정보 삭제" formaction="<%= request.getContextPath() %>/product/AdminProductDelete.jsp">
                </td>
        </table>
    </form>
    </div>
    <div class="product-stock">
        <h1>재고 수정</h1>
        <form action="" method="post">
            <input class="product-id" type="hidden" name="productId" value="<%= product.getPr_id() %>">
            <table>
                <tr>
                    <th>선택</th>
                    <th>색상</th>
                    <th>사이즈</th>
                    <th>가격</th>
                    <th>재고</th>
                </tr>
                <c:forEach var="productStock" items="${productStockList}">
                <tr>
                    <td>
                        <input type="radio" name="productStockId" value="${productStock.getPr_st_id()}" onclick="selectProductStock(${productStock.getPr_st_id()})">
                    </td>
                    <td><label class="product-color" id="${productStock.getCl_id()}">${productStock.getCl_name()}</label></td>
                    <td><label class="product-size" id="${productStock.getSz_id()}">${productStock.getSz_id()}</label></td>
                    <td><label class="product-price" id="${productStock.getPrice()}">${productStock.getPrice()}</label></td>
                    <td><label class="product-quantity" id="${productStock.getQuantity()}">${productStock.getQuantity()}</label></td>
                </tr>
                </c:forEach>
                <tr>
                    <td></td>
                    <td>
                        <select class="product-color" name="colorId">
                            <c:forEach var="color" items="${colorList}">
                                <option value="${color.getCl_id()}">${color.getCl_name()}</option>
                            </c:forEach>
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
                </tr>
                <tr>
                    <td colspan="8">
                        <input type="submit" value="재고 정보 추가" formaction="<%= request.getContextPath() %>/product/AdminProductStockInsert.jsp">
                        <input type="submit" value="재고 정보 수정" formaction="<%= request.getContextPath() %>/product/AdminProductStockUpdate.jsp">
                        <input type="submit" value="재고 정보 삭제" formaction="<%= request.getContextPath() %>/product/AdminProductStockDelete.jsp">
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
