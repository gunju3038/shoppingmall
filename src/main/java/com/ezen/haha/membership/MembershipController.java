package com.ezen.haha.membership;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;




@Controller
public class MembershipController {
	@Autowired
	SqlSession sqlSession;
	
	private static final Logger logger = LoggerFactory.getLogger(MembershipController.class);
	
	
	
	//회원가입
	@RequestMapping(value = "/membershipjoin2")
	public String membership3() {
		
		return "membershipjoin2";
	}
	
	//아이디 중복확인
	@ResponseBody
	@RequestMapping(value = "/idcheckgogo")
	public String membership4(HttpServletRequest request) {
		
		String id = request.getParameter("id");
		Service ss = sqlSession.getMapper(Service.class);
	     System.out.println(id);
	      return ss.id_check(id);
	   }
	
	//회원가입 저장
	@RequestMapping(value = "/membershipsave")
	public String membership5(HttpServletRequest request) throws UnsupportedEncodingException {
		request.setCharacterEncoding("utf-8");
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String name = request.getParameter("name");
		String tel = request.getParameter("tel");
		String email = request.getParameter("email");
		String pid = request.getParameter("pid");
		String address = request.getParameter("address1") + " " + request.getParameter("address2");
		
		Service ss = sqlSession.getMapper(Service.class);
		ss.membersave(id,pw,name,tel,email,pid,address);
		return "redirect:/main";
	}
	
	//로그인출력창 ㄱㄱ
	@RequestMapping(value = "/login")
	public String membership6() {
		
		return "logininput";
	}
	
	//로그인
		@RequestMapping(value = "/logingoing")
		public String membership7(HttpServletRequest request, HttpServletResponse response) throws IOException {
			String id = request.getParameter("id");
			String pw = request.getParameter("pw");
			Service ss = sqlSession.getMapper(Service.class);
			MembershipDTO dto = ss.logingo(id,pw);
			if(dto!=null)
			{
				HttpSession hs = request.getSession();
				hs.setAttribute("membership", dto);
				hs.setAttribute("id", id);
				hs.setAttribute("loginstate", true);
				hs.setMaxInactiveInterval(3000);
				return "redirect:/main";
			}
			else {
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script> alert('아이디랑 비밀번호가 틀리셨습니다. 다시 확인해주세요!'); window.history.back(); </script>");
				printw.close();
			}
			return null;
		}
		
		//로그아웃
		@RequestMapping(value = "/logout")
		public String membership8(HttpServletRequest request, HttpServletResponse response) throws IOException {
			HttpSession hs = request.getSession();
			hs.removeAttribute("membership");
			hs.removeAttribute("id");
			hs.setAttribute("loginstate", false);

			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('로그아웃 되었습니다.'); window.location.href='./main'; </script>");
			printw.close();
			return null;
		}
		//ReqeustParam으로 code값 받기
		@RequestMapping(value = "/kakaologin", method = RequestMethod.GET)
		public String kakaoLogin(@RequestParam(value = "code", required = false) String code,HttpServletRequest request, HttpServletResponse response) throws Throwable {
			KakaoService service = new KakaoService();
			
			//code를 보내서 토큰 얻기  
			String access_Token = service.getAccessToken(code);
			//토큰보내서 회원정보 가져오기                          
			HashMap<String, Object> userInfo = service.getUserInfo(access_Token);
			String email = (String)userInfo.get("email");
			System.out.println("이메일 : " + email);
			//회원의 이름과 이메일이 일치하면 로그인    
			Service ss = sqlSession.getMapper(Service.class);
			MembershipDTO dto = ss.kakaologin(email);
			if(dto!=null)
			{
				HttpSession hs = request.getSession();
				hs.setAttribute("membership", dto);
				hs.setAttribute("loginstate", true);
				hs.setMaxInactiveInterval(3000);
				return "redirect:/main";
			}
			else {
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script> alert('회원가입 먼저 진행 부탁드립니다.'); window.location.href='memershipjoin2'; </script>");
				printw.close();
			}
			return null;
		}
		
		//idsersh Page
		@RequestMapping(value = "/idforget")
		public String membership9() {
			
			return "idserch";
		}
		
		//idsersh doing
		@RequestMapping(value = "/idserchgogo")
		public String membership10(HttpServletRequest request, HttpServletResponse response, Model mo) throws IOException {
			request.setCharacterEncoding("utf-8");
			String name = request.getParameter("name");
			String email = request.getParameter("email");
			Service ss = sqlSession.getMapper(Service.class);
			ArrayList<MembershipDTO> list = ss.memberidserch(name,email);
			if(list!=null)
			{
				mo.addAttribute("list", list);
				return "idfind";
				
			}
			else {
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script> alert('입력하신 정보로 가입 된 회원 아이디는 존재하지 않습니다.'); window.location.href='idforget'; </script>");
				printw.close();
			}
			return null;
		}
		
		//pwsersh Page
		@RequestMapping(value = "/pwforget")
		public String membership11() {
			
			return "pwserch";
		}
		
		//pwsersh doing
		@RequestMapping(value = "/pwserchgogo")
		public String membership11(HttpServletRequest request, HttpServletResponse response, Model mo) throws IOException {
		    request.setCharacterEncoding("utf-8");
		    String id = request.getParameter("id");
		    String name = request.getParameter("name");
		    String email = request.getParameter("email");
		    Service ss = sqlSession.getMapper(Service.class);
		    MembershipDTO dto = ss.kakaologin(email);
		    if(dto!=null) //id,pw가 있으면
		    {
		        // 임시 비밀번호 생성 
		        String pw = Randompw.randompw(12);
		        dto.setPw(pw);
		        
		        // 임시 비밀번호로 변경 
		        ss.updatepw(pw,id);
		        ArrayList<MembershipDTO> list = ss.memberpwserch(id);
		        mo.addAttribute("list", list);
		        return "pwfind";
		        
		    }
		    //id가 없을경우
		    else if(ss.id_check(id) == null) {
		        response.setContentType("text/html;charset=utf-8");
		        PrintWriter printw = response.getWriter();
		        printw.print("<script> alert('입력하신 정보로 가입 된 회원 아이디는 존재하지 않습니다.'); window.location.href='idforget'; </script>");
		        printw.close();
		    }
		    //email이 없을경우
		    else if(ss.email_check(email) == null) {
		        response.setContentType("text/html;charset=utf-8");
		        PrintWriter printw = response.getWriter();
		        printw.print("<script> alert('입력하신 정보로 가입 된 회원 이메일은 존재하지 않습니다.'); window.location.href='idforget'; </script>");
		        printw.close();
		    }
		    return null;
		}
		
		//naverlogin
		@RequestMapping(value = "/naverlogin")
		public String naverlogin(@RequestParam(value = "code", required = false) String code,HttpServletRequest request, HttpServletResponse response) throws Throwable {
			NaverService service = new NaverService();
			System.out.println("code##:"+code);
			String access_Token = service.getAccessToken(code);
			HashMap<String, Object> userInfo = service.getUserInfo(access_Token);
			String name = (String)userInfo.get("name");
			String email = (String)userInfo.get("email");
			System.out.println("네이버 이름" + name);
			System.out.println("네이버 이메일" + email);
			Service ss = sqlSession.getMapper(Service.class);
			MembershipDTO dto = ss.naverlogin(name);
			//MembershipDTO dto = ss.naverlogin(name,email);
			if(dto!=null)
			{
				HttpSession hs = request.getSession();
				hs.setAttribute("membership", dto);
				hs.setAttribute("loginstate", true);
				hs.setMaxInactiveInterval(3000);
				return "redirect:/main";
			}
			else {
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script> alert('회원가입 먼저 진행 부탁드립니다.'); window.location.href='.memershipjoin2'; </script>");
				printw.close();
			}
			return null;
		}
				
	// 마이페이지 메뉴의 회원정보 수정 화면 보기
	@RequestMapping(value = "/membershipupdateview")
	public String membershipupdateview(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<MembershipDTO> list = ss.membershipsearch(id);
		mo.addAttribute("list", list);
		
		return "membershipupdateview";
	}			
	
	// 관리자 페이지 회원목록 화면 수정 기능
	@RequestMapping(value = "/adminmembershipupdateview")
	public String adminmembershipupdateview(HttpServletRequest request, Model mo) {
		String id = request.getParameter("id");
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<MembershipDTO> list = ss.membershipsearch(id);
		mo.addAttribute("list", list);
		
		return "adminmembershipupdateview";
	}
	// 관리자 페이지 회원 목록 수정
	@RequestMapping(value = "/adminmembershipupdate")
	public String adminmembershipupdate(HttpServletRequest request, HttpServletResponse response) throws IOException {	
		String beforeid = request.getParameter("beforeid");		
		String newid = request.getParameter("id");
		String pw = request.getParameter("pw");
		String name = request.getParameter("name");
		String tel = request.getParameter("tel");
		String email = request.getParameter("email");
		String pid = request.getParameter("pid");
		String address = request.getParameter("address");
		
		Service ss = sqlSession.getMapper(Service.class);
		ss.membershipupdate(newid,pw,name,tel,email,pid,address,beforeid);
		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter printw = response.getWriter();
		printw.print("<script> alert('회원정보 수정이 완료되었습니다.'); window.location.href='./adminpagemain'; </script>");
		printw.close();
		
		return "./adminpagemain";
	}
	
	
	
	// 마이페이지 메뉴의 회원정보 수정, id 수정 화면
	@RequestMapping(value = "/updateid")
	public String updateid() {
		
		return "updateid";
	}
	
	// 마이페이지 메뉴의 회원정보 수정, 비밀번호 수정 화면
	@RequestMapping(value = "/updatepw")
	public String updatepw() {
		
		return "updatepw";
	}
	
	// 마이페이지 메뉴의 회원정보 수정, 주민번호 수정 화면
	@RequestMapping(value = "/updatepid")
	public String updatepid() {
		
		return "updatepid";
	}

	// 마이페이지 메뉴의 회원정보 수정 기능
	@RequestMapping(value = "/membershipupdate")
	public String membershipupdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		String newid = request.getParameter("id");
		String pw = request.getParameter("pw");
		String name = request.getParameter("name");
		String tel = request.getParameter("tel");
		String email = request.getParameter("email");
		String pid = request.getParameter("pid");
		String address = request.getParameter("address");
		
		Service ss = sqlSession.getMapper(Service.class);
		ss.membershipupdate(newid,pw,name,tel,email,pid,address,id);
		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter printw = response.getWriter();
		printw.print("<script> alert('회원정보 수정이 완료되었습니다.'); window.location.href='./mypage'; </script>");
		printw.close();
		
		return "./mypage";
	}
	
	// 마이페이지 메뉴의 회원 탈퇴 화면 보기
	@RequestMapping(value = "/membershipdeleteview")
   public String membershipdeleteview(HttpServletRequest request, Model mo) {
      HttpSession hs = request.getSession();
      String id = (String) hs.getAttribute("id");
      
      if(id.equals("admin"))
      {
         String userid = request.getParameter("id");
         if(userid==null)
         {
            userid = "admin";
         }
         Service ss = sqlSession.getMapper(Service.class);
         ArrayList<MembershipDTO> list = ss.membershipsearch(userid); // 쿼리문 재활용
         mo.addAttribute("list", list);
         
         return "membershipdeleteview";
      }
		else 
		{
			Service ss = sqlSession.getMapper(Service.class);
			ArrayList<MembershipDTO> list = ss.membershipsearch(id); // 쿼리문 재활용
			mo.addAttribute("list", list);
			
			return "membershipdeleteview";
		}
		
		
	}
	
	// 마이페이지 메뉴의 회원 탈퇴 기능
	@RequestMapping(value = "/membershipdelete")
	public String membershipdelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String id = request.getParameter("id");
		
		Service ss = sqlSession.getMapper(Service.class);
		ss.membershipdelete(id);
		
		HttpSession hs = request.getSession();
		String adminid = (String) hs.getAttribute("id");
		
		if(adminid.equals("admin"))
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('회원탈퇴가 완료되었습니다.'); window.location.href='./adminpagemain'; </script>");
			printw.close();
			
			return "./adminpagemain";
		}
		else 
		{
			hs.removeAttribute("membership");
			hs.removeAttribute("id");
			hs.setAttribute("loginstate", false);
			
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('회원탈퇴가 완료되었습니다.'); window.location.href='./main'; </script>");
			printw.close();
			
			return "./main";
		}
		
	}
	
	@RequestMapping(value = "/roulette")
	public String roulette() {
		
		return "roulette";
	}
	
	@ResponseBody
	@RequestMapping(value = "/couponUpdate")
	public String couponupdate(HttpServletRequest request) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		String win = request.getParameter("win");
		Service ss = sqlSession.getMapper(Service.class);
		if(win.equals("1")) {
			ss.couponUpdate("mannum",id);
		}
		else if(win.equals("3")) {
			ss.couponUpdate("tennum",id);
		}
		else {
			ss.couponUpdate("twentinum",id);
		}
		ss.couponTotal(id);
		return "O";	
	}
	
}
