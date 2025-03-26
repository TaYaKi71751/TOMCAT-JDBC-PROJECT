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
<%@ page import="java.time.*" %>
<%@ page import="com.mlb.product.dao.*" %>
<%@ page import="com.mlb.product.dto.*" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Font.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/AdminProductList.css">
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
    request.setCharacterEncoding("UTF-8");
    String[] categories = request.getParameterValues("category");
    String[] teams = request.getParameterValues("team");
    String pageString = request.getParameter("page");
    Long pageNum = null;
    String params = "";
    if(categories != null){
        for(String category : categories){
            params += "&category=" + category;
        }
    }
    if(teams != null){
        for(String team : teams){
            params += "&team=" + team;
        }
    }
    if(pageString == null){
        response.sendRedirect(request.getContextPath() + "/product/AdminProductList.jsp?page=1" + params);
        return;
    }
    try {
        pageNum = Long.parseLong(pageString);
        if(pageNum < 1){
            response.sendRedirect(request.getContextPath() + "/product/AdminProductList.jsp?page=1" + params);
            return;
        }
    } catch(Exception e){
        response.sendRedirect(request.getContextPath() + "/product/AdminProductList.jsp?page=1" + params);
        return;
    }
    ProductDao productDao = new ProductDao();
    TeamDao teamDao = new TeamDao();
    ArrayList<ProductDto> productList = new ArrayList<ProductDto>();
    ArrayList<TeamDto> teamList = teamDao.selectAll();
    if((categories == null || categories.length == 0) && (teams == null || teams.length == 0)){
        productList = productDao.selectAllByPage(pageNum);
    } else {
        productList = productDao.selectByTeamsOrCategoriesPage(teams, categories, pageNum);
    }
    session.setAttribute("teamList",teamList);
    session.setAttribute("productList", productList);
    %>
    <title>MLB - Products</title>
</head>
<body>
<div class="product-list-header">
    <h1>Products</h1>
    <a class="button" href="<%= request.getContextPath() %>/product/AdminProductAdd.jsp">
        Add Product
    </a>
    <form action="<%= request.getContextPath() %>/product/AdminProductList.jsp" method="get">
        <input type="hidden" name="page" value="<%= pageNum %>">
        <div class="search-box-category">
            <details>
                <summary>Category</summary>
                <div class="category-list">
                    <div class="category-item">
                        <label for="Hat">Hat</label>
                        <input type="checkbox" name="category" value="Hat" <%
                            if(categories != null){
                                for(String category : categories){
                                    if(category.equals("Hat")){
                                        out.print("checked");
                                    }
                                }
                            }
                        %>>
                    </div>
                    <div class="category-item">
                        <label for="Beanie">Beanie</label>
                        <input type="checkbox" name="category" value="Beanie" <%
                            if (categories != null){
                                for(String category : categories){
                                    if(category.equals("Beanie")){
                                        out.print("checked");
                                    }
                                }
                            }
                        %>>
                    </div>
                    <div class="category-item">
                        <label for="Season">Season</label>
                        <input type="checkbox" name="category" value="Season" <%
                        if(categories != null){
                            for(String category : categories){
                                if(category.equals("Season")){
                                    out.print("checked");
                                }
                            }
                        }
                        %>>
                    </div>
                    <div class="category-item">
                        <label for="BallCap">BallCap</label>
                        <input type="checkbox" name="category" value="BallCap" <%
                        if(categories != null){
                            for(String category : categories){
                                if(category.equals("BallCap")){
                                    out.print("checked");
                                }
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
                            if(teams != null){
                                for(String team : teams){
                                    if(team.equals(((TeamDto)pageContext.getAttribute("team")).getTm_id())){
                                        out.print("checked");
                                    }
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
    <a href="<%= request.getContextPath() %>/product/AdminProductEdit.jsp?productId=${product.getPr_id()}">
        <div class="product">
            <img class="product-thum-img" src="<%= request.getContextPath() %>/primg/thum/${product.getPr_thum_img()}" alt="${product.getPr_name()}">
            <p class="truncate product-name">${product.getPr_name()}</p>
            <p class="truncate product-category">${product.getCa_id()}</p>
            <p class="truncate product-team">${product.getTm_name()}</p>
        </div>
    </a>
</c:forEach>
</div>
<div class="page-nav">
    <%
    if(pageNum > 1){
    %>
    <a class="page-button" href="<%= request.getContextPath() %>/product/List.jsp?page=<%= pageNum - 1 %><%= params %>">Previous</a>
    <%
    }
    %>
    <label class="page-number" for="PageNumber"><%= pageNum %></label>

    <%
    String where = "";
    if(categories != null && categories.length > 0){
        where = " ( ca_id = \'" + categories[0] + "\'";
        for(int i = 1; i < categories.length; i++){
            where += " OR ca_id = \'" + categories[i] + "\'";
        }
        where += " ) ";
    }
    if(teams != null && teams.length > 0){
        if(where.equals("")){
            where = " ( tm_id = \'" + teams[0] + "\'";
        } else {
            where += " AND ( tm_id = \'" + teams[0] + "\'";
        }
        for(int i = 1; i < teams.length; i++){
            where += " OR tm_id = \'" + teams[i] + "\'";
        }
        where += " ) ";
    }
    System.out.println(productDao.selectCount(where));
    if(productDao.selectCount(where) > pageNum * 10){
    %>
    <a class="page-button" href="<%= request.getContextPath() %>/product/List.jsp?page=<%= pageNum + 1 %><%= params %>">Next</a>
    <%
    }
    %>
</body>
</html>
