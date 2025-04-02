<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
</head>
<body>
    <h2>회원정보 수정</h2>
    <form action="UpdateProfileServlet" method="post">
        <label>이름: <input type="text" name="name" value="${user.name}" required></label><br>
        <label>이메일: <input type="email" name="email" value="${user.email}" required></label><br>
        <label>전화번호: <input type="text" name="hp" value="${user.hp}"></label><br>
        <label>주소: <input type="text" name="address" value="${user.address}"></label><br>
        
        <h3>비밀번호 변경 (선택 사항)</h3>
        <label>현재 비밀번호: <input type="password" name="currentPw"></label><br>
        <label>새 비밀번호: <input type="password" name="newPw"></label><br>
        <label>새 비밀번호 확인: <input type="password" name="confirmPw"></label><br>
        
        <input type="submit" value="수정하기">
    </form>
</body>
</html>
