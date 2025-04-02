package com.mlb.customer;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ProfileServlet
 */
@WebServlet("customer/ProfileServlet")
public class ProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProfileServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession();
		UserDto user = (UserDto) session.getAttribute("user"); // 현재 로그인한 사용자 정보

		if (user == null) {
			response.sendRedirect("login.jsp"); // 로그인되지 않은 경우 로그인 페이지로 이동
			return;
		}

		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String hp = request.getParameter("hp");
		String address = request.getParameter("address");

		// 비밀번호 변경 처리
		String currentPw = request.getParameter("currentPw");
		String newPw = request.getParameter("newPw");
		String confirmPw = request.getParameter("confirmPw");

		boolean passwordChanged = false;
		if (currentPw != null && !currentPw.isEmpty()) {
			if (!user.getPw().equals(currentPw)) {
				request.setAttribute("error", "현재 비밀번호가 올바르지 않습니다.");
				request.getRequestDispatcher("editProfile.jsp").forward(request, response);
				return;
			}
			if (!newPw.equals(confirmPw)) {
				request.setAttribute("error", "새 비밀번호가 일치하지 않습니다.");
				request.getRequestDispatcher("editProfile.jsp").forward(request, response);
				return;
			}
			user.setPw(newPw);
			passwordChanged = true;
		}

		user.setName(name);
		user.setEmail(email);
		user.setHp(hp);
		user.setAddress(address);

		boolean success = UserDao.updateUser(user, passwordChanged);

		if (success) {
			session.setAttribute("user", user);
			response.sendRedirect("profile.jsp?success=프로필이 성공적으로 수정되었습니다.");
		} else {
			request.setAttribute("error", "프로필 수정에 실패했습니다.");
			request.getRequestDispatcher("editProfile.jsp").forward(request, response);
		}
	}
}
