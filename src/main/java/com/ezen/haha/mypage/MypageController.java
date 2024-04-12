package com.ezen.haha.mypage;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

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

import com.ezen.haha.membership.MembershipDTO;
import com.ezen.haha.pay.PayDTO;
import com.ezen.haha.pay.Service;


@Controller
public class MypageController {
	
	@Autowired
	SqlSession sqlSession;
	
	private static final Logger logger = LoggerFactory.getLogger(MypageController.class);
	
	// 마이페이지 화면으로 가기
	@RequestMapping(value = "/mypage")
	public String mypagemain(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		boolean loginstate = (boolean) hs.getAttribute("loginstate");
		
		if(loginstate)
		{
			com.ezen.haha.mypage.Service ss = sqlSession.getMapper(com.ezen.haha.mypage.Service.class);
			ArrayList<MembershipDTO> list = ss.mypageview(id);
			mo.addAttribute("list", list);
			return "mypagemain";
		}
		else
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('로그인이 필요합니다.'); window.location.href='./login'; </script>");
			printw.close();
			return "redirect:./login";
		}
	}
	
	// 쿠폰 보기 화면으로 가기
	@RequestMapping(value = "/couponview")
	public String couponnum(HttpServletRequest request, Model mo) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		com.ezen.haha.mypage.Service ss = sqlSession.getMapper(com.ezen.haha.mypage.Service.class);
		ArrayList<CouponDTO> list = ss.couponview(id);
		mo.addAttribute("list", list);
		
		return "couponview";
	}
	
	// 마이페이지에서 결재 목록 보기 화면으로
    @RequestMapping(value = "/payoutview")
	public String payoutview(HttpServletRequest request, Model mo) {
    	HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		com.ezen.haha.mypage.Service ss = sqlSession.getMapper(com.ezen.haha.mypage.Service.class);
		ArrayList<PayDTO> list = ss.payoutview(id);
    	mo.addAttribute("list", list);
		
		return "payout";
	}
    
    // 관리자 페이지로 가기
    @RequestMapping(value = "/adminpage")
	public String adminpage(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id.equals("admin"))
		{
			return "adminpage";
		}
		else
		{	
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('잘못된 접근입니다.'); window.location.href='./login'; </script>");
			printw.close();
			hs.removeAttribute("id");
			hs.setAttribute("loginstate", false);
			return "redirect:/login";
		}
	}
 // 관리자 페이지에서 결제 목록 보기 화면으로
    @RequestMapping(value = "/payoutviewall")
    public String payoutviewall(HttpServletRequest request, Model mo) {
		com.ezen.haha.mypage.Service ss = sqlSession.getMapper(com.ezen.haha.mypage.Service.class);
		ArrayList<PayDTO> list = ss.payoutviewall();
    	mo.addAttribute("list", list);
		
		return "payout";
	}
 // 관리자 페이지에서 회원 목록 보기 화면으로
    @RequestMapping(value = "/memberviewall")
    public String memberviewall(HttpServletRequest request, Model mo) {
		com.ezen.haha.mypage.Service ss = sqlSession.getMapper(com.ezen.haha.mypage.Service.class);
		ArrayList<MembershipDTO> list = ss.memberviewall();
    	mo.addAttribute("list", list);
		
		return "memberviewall";
	}

}
