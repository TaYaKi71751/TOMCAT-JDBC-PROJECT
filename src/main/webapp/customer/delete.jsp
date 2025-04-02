<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원탈퇴</title>
</head>
<body>
<h2>회원 삭제</h2>
    <form action="DeleteServlet" method="post">
        <label for="userId">삭제할 사용자 ID:</label>
        <input type="text" id="userId" name="userId" required>
        <button type="submit">삭제</button>
    </form>
    <a href="userList.jsp">회원 목록</a>
    
</body>
</html>