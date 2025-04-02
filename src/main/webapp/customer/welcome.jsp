<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mlb.customer.UserDto" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession(false);
    UserDto user = (sessionObj != null) ? (UserDto) sessionObj.getAttribute("user") : null;

    if (user == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
</head>
<body>
    <h2>Welcome, <%= user.getUserId() %>!</h2>
    <p>Your email: <%= user.getEmail() %></p>
    <a href="profile.jsp">Edit Profile</a> |
    <a href="login.jsp">Logout</a> |
    <a href="delete.jsp">delete</a>
</body>
</html>
