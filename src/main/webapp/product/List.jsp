<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="com.mlb.product.dao.*" %>
<%@ page import="com.mlb.product.dto.*" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Font.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/ProductList.css">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%
    request.setCharacterEncoding("UTF-8");
    String[] categories = request.getParameterValues("category");
    String[] teams = request.getParameterValues("team");
    ProductDao productDao = new ProductDao();
    TeamDao teamDao = new TeamDao();
    ArrayList<ProductDto> productList = new ArrayList<ProductDto>();
    ArrayList<TeamDto> teamList = teamDao.selectAll();
    if((categories == null || categories.length == 0) && (teams == null || teams.length == 0)){
        productList = productDao.selectAll();
    } else {
        productList = productDao.selectByTeamsOrCategories(teams, categories);
    }
    session.setAttribute("teamList",teamList);
    session.setAttribute("productList", productList);
    %>
    <title>MLB - Products</title>
</head>
<body>
<div class="product-list-header">
    <h1>Products</h1>
    <form action="<%= request.getContextPath() %>/product/List.jsp" method="post">
        <div class="search-box-category">
            <details>
                <summary>Category</summary>
                <div class="category-list">
                    <div class="category-item">
                        <label for="Hat">Hat</label>
                        <input type="checkbox" name="category" value="Hat" <%
                            for(String category : categories){
                                if(category.equals("Hat")){
                                    out.print("checked");
                                }
                            }
                        %>>
                    </div>
                    <div class="category-item">
                        <label for="Beanie">Beanie</label>
                        <input type="checkbox" name="category" value="Beanie" <%
                            for(String category : categories){
                                if(category.equals("Beanie")){
                                    out.print("checked");
                                }
                            }
                        %>>
                    </div>
                    <div class="category-item">
                        <label for="Season">Season</label>
                        <input type="checkbox" name="category" value="Season" <%
                            for(String category : categories){
                                if(category.equals("Season")){
                                    out.print("checked");
                                }
                            }
                        %>>
                    </div>
                    <div class="category-item">
                        <label for="BallCap">BallCap</label>
                        <input type="checkbox" name="category" value="BallCap" <%
                            for(String category : categories){
                                if(category.equals("BallCap")){
                                    out.print("checked");
                                }
                            }
                        %>>
                    </div>
            </details>
        </div>
        <div class="search-box-team">
            <details>
                <summary>Team</summary>
                <div class="team-list">
                    <c:forEach var="team" items="${teamList}">
                        <div class="team-item">
                            <label for="${team.getTm_id()}">${team.getTm_name()}</label>
                            <input type="checkbox" name="team" value="${team.getTm_id()}" <% 
                            for(String team : teams){
                                if(team.equals(((TeamDto)pageContext.getAttribute("team")).getTm_id())){
                                    out.print("checked");
                                }
                            }
                            %>>
                        </div>
                    </c:forEach>
                </div>
            </details>
        </div>
        <input type="submit" value="Search">
    </form>
</div>
<div class="product-list">
<c:forEach var="product" items="${productList}">
    <div class="product">
        <img class="product-thum-img" src="<%= request.getContextPath() %>/primg/thum/${product.getPr_thum_img()}" alt="${product.getPr_name()}">
        <p>${product.getPr_name()}</p>
        <p>${product.getCa_id()}</p>
        <p>${product.getTm_id()}</p>
        <p>${product.getTm_name()}</p>
    </div>
</c:forEach>
</div>
</body>
</html>
