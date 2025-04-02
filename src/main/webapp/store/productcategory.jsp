<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="java.util.*"%>
<%@page import="com.mlb.store.dto.*"%>
<%
	String category = request.getParameter("ca_id");
	String[] teams = request.getParameterValues("team");
	String sort = request.getParameter("sort");
	String items = request.getParameter("search");
	
	com.mlb.store.dao.ProductsStocksDao dao = new com.mlb.store.dao.ProductsStocksDao();
	ArrayList<ProductsStocksDto> dto = null;
	int count = 0;
	
	if(teams!=null){
		dto = dao.selectByCaTeams(category, teams);
	}else if(items!=null && !items.isEmpty()){
		if("latest".equals(sort)){
			dto = dao.searchProductsByDate(items);
		}else{
			dto = dao.searchProducts(items);
		}
		count = dao.countProducts(items);
	}else if("latest".equals(sort)){
		dto = dao.selectByCaDate(category);
	}else{
		dto = dao.selectAllByCategory(category);
	}

	request.setAttribute("items", items);
	request.setAttribute("count", count);
 	request.setAttribute("productsList", dto);
 	request.setAttribute("category", category);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Products</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
<style>

*{
	margin: 0px;
	padding: 0px;
	list-style:none;
	font-family: 'Noto sans KR', sans-serif;
}

a{
	text-decoration: none;
	color: #000000;
}

.products {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    gap: 10px;
    padding: 20px;
    margin: 0 50px;
}

.products ul {
    width: calc(20% - 10px);
    box-sizing: border-box;
    text-align: center;
    margin-bottom: 50px;
}


@media screen and (max-width: 992px) {
    .products ul {
        width: calc(33.33% - 10px);
    }
}


@media screen and (max-width: 600px) {
    .products ul {
        width: calc(100% - 10px);
    }
}

.filter {
    display: flex; 
    justify-content: flex-start;
    align-items: center; /* 수직 정렬 */
    gap: 15px; /* 요소 간 간격 */
    padding: 15px;
    border-radius: 10px;
    background-color: white; /* 배경색 */
    margin:10px 70px 30px 70px;
}


.filter1, .filter2, .filter3 {
    display: flex;
    align-items: center;
    gap: 10px; /* 내부 요소 간격 */
}


.filter3{
	margin-left:auto;
}


.filter button {
    background-color: #000000;
    color: white;
    border: none;
    padding: 8px 12px;
    border-radius: 5px;
    cursor: pointer;
}


.filter input[type="text"] {
    padding: 5px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

@media screen and (max-width: 992px) {
    .filter {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .filter1, .filter2, .filter3 {
        width: 100%;
        justify-content: flex-start;
    }
    
    .filter3 {
        margin-left: 0;
    }
}

.noProduct{
	text-align:center;
}

.productName{
	margin-bottom: 5px;
	white-space: nowrap; 
    overflow: hidden;    
    text-overflow: ellipsis;
}
.productPrice{
	font-weight: bold;
}

.category{
	font-size: 30px;
	margin-left: 70px;
	font-weight: bold;
}

.productImg{
	background-color:#F8F8F8;
	margin-bottom: 15px;
}

</style>
</head>
<body>
<jsp:include page="/topnavigator.jsp"></jsp:include>



<!-- 카테고리 별 팀 선택 -->
<div class="filter">
	<form action="productcategory.jsp" method="get" class="filter1">
		<label for="team"></label>
		<input type="hidden" name="ca_id" value="${category }">
	    <input type="checkbox" name="team" value="LaDodgers"> LA 다저스
	    <input type="checkbox" name="team" value="Boston"> 보스턴 레드삭스
	    <input type="checkbox" name="team" value="Cleveland"> 클리블랜드 가디언스
	    <input type="checkbox" name="team" value="NYKees"> 뉴욕 양키스
	    <input type="checkbox" name="team" value="SanGiants"> 샌프란시스코 자이언츠
	    <button type="submit">조회</button>
	</form>
	
	
	<!-- 카테고리 별 최신상품순 조회 -->
	<form action="productcategory.jsp" method="get" class="filter2">
		<c:if test="${not empty category }">
			<input type="hidden" name="ca_id" value="${category }">
		</c:if>
		<c:if test="${not empty items }">
			<input type="hidden" name="search" value="${items }">
		</c:if>
		<input type="hidden" name="sort" value="latest">
		<button type="submit">최신상품순</button>
	</form>
	
	
	<!-- 전체 상품 내 검색 -->
	<form action="productcategory.jsp" method="get" class="filter3">
		상품검색: <input type="text" name="search">
		<input type="hidden" name="sort" value="default">
		<button type="submit">검색</button>
	</form>
</div>


<!-- 카테고리/검색 시 상품개수 조회 -->
<c:choose>
	<c:when test="${not empty category }">
		<p class="category">${category }</p>
	</c:when>
	<c:when test="${not empty count }">
		<p class="category">전체상품(${count })</p>
	</c:when>
</c:choose>


<c:choose>
	<c:when test="${empty productsList }">
		<p class="noProduct">상품을 찾을 수 없습니다.</p>
	</c:when>
	<c:otherwise>
	<div class="products">
		<c:forEach var="product" items="${productsList }">
				<ul>
					<li>
						<div class="productImg">
							<a href="productDetail.jsp?pr_id=${product.prID }">
								<img src="../primg/thum/${product.prThumImg }" width="200px">
							</a>
						</div>
					</li>
					<li>
						<div class="productName">
							<a href="productDetail.jsp?pr_id=${product.prID}">${product.prName }</a>
						</div>
					</li>
					<li>
						<div class="productPrice">${product.price }</div>
					</li>
				</ul>
			</c:forEach>
		</div>
	</c:otherwise>
</c:choose>
</body>
</html>