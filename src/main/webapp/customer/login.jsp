<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <style>
	body { font-family: Arial, sans-serif; text-align: center; }
    form { width: 300px; margin: 0 auto; }
    input { display: block; width: 100%; margin-bottom: 10px; padding: 8px; }
    button { width: 100%; padding: 10px; background-color: blue; color: white; border: none; }
</style>
</head>
<body>
    <h2>로그인</h2>
    <% String error = request.getParameter("error"); %>
    <% if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>
    <form action="LoginServlet" method="post">       
        <input type="text" id="userId" name="userId" placeholder="User Id" required>
        <br>        
        <input type="password" id="password" name="password"  placeholder="Password" required>
        <br>
        <button type="submit">Login</button>
    </form><br>
    <a href="find.jsp">아이디/비밀번호 찾기</a>
    <p>회원이 아니신가요? <a href="register.jsp">회원가입</a></p>
</body>
</html>