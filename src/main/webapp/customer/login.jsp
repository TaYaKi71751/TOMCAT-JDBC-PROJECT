<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
</head>
<body>
    <h2>로그인</h2>
    <% String error = request.getParameter("error"); %>
    <% if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>
    <form action="LoginServlet" method="post">
        <label for="userId">User ID:</label>
        <input type="text" id="userId" name="userId" required>
        <br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
        <br>
        <button type="submit">Login</button>
    </form>
    <a href="find.jsp">아이디/비밀번호 찾기</a>
    <p>Don't have an account? <a href="register.jsp">회원가입</a></p>
</body>
</html>