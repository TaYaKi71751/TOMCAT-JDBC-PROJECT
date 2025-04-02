package com.mlb.customer;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DeleteServlet
 */
@WebServlet("/customer/DeleteServlet")
public class DeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteServlet() {
        super();
        // TODO Auto-generated constructor stub
    }	
	
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

        // 요청에서 userId 가져오기
        String userIdStr = request.getParameter("userId");
        boolean isDeleted = false;

        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try {
                Long userId = Long.parseLong(userIdStr); // String → Long 변환
                isDeleted = UserDao.deleteUser(userId); // UserDao의 deleteUser(Long) 메서드 호출
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 삭제 결과에 따른 처리
        if (isDeleted) {
            response.sendRedirect("userList.jsp?msg=success"); // 삭제 성공 시 목록으로 이동
        } else {
            response.sendRedirect("userList.jsp?msg=failure"); // 삭제 실패 시 메시지 전달
        }
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);        
}
}