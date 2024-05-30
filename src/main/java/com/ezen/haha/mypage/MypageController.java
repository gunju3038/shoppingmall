package com.ezen.haha.mypage;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ezen.haha.membership.MembershipDTO;
import com.ezen.haha.pay.PayDTO;
import com.ezen.haha.product.ProductDTO;
import com.ezen.haha.product.ProductreviewDTO;
import com.ezen.haha.qna.QnaDTO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class MypageController {

	@Autowired
	SqlSession sqlSession;
	
	// 파이썬 스크립트에 JSON 데이터 전달
    String pythonScriptPath = "C:\\이젠디지탈12\\spring\\shoppingmall-master\\src\\main\\webapp\\resources\\python\\product_visual.py";


	// 마이페이지 화면으로 가기
	@RequestMapping(value = "/mypage")
	public String mypagemain(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");

		if (id == null) {
			hs.setAttribute("loginstate", false);
		}

		boolean loginstate = (boolean) hs.getAttribute("loginstate");
		
		if (loginstate) {
			Service ss = sqlSession.getMapper( Service.class);
			ArrayList<MembershipDTO> list = ss.mypageview(id);
			ArrayList<PayDTO> list2 = ss.payoutviewmonth(id); 
			ArrayList<ProductDTO> list3 = ss.bestproductout();
			mo.addAttribute("list", list);
			mo.addAttribute("list2", list2);
			mo.addAttribute("list3", list3);
			return "mypagemain";
			
		} else {
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

		Service ss = sqlSession.getMapper( Service.class);
		ArrayList<CouponDTO> list = ss.couponview(id);
		mo.addAttribute("list", list);

		return "couponview";
	}

	// 관리자페이지에서 결재 목록 보기 화면으로
	@RequestMapping(value = "/payoutview")
	public String payoutview(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id.equals("admin"))
		{
			 Service ss = sqlSession.getMapper( Service.class);
			ArrayList<PayDTO> list = ss.payoutviewall();
			mo.addAttribute("list", list);

			return "adminpayoutview";
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

	// 마이페이지에서 결재 목록 보기 화면으로
	@RequestMapping(value = "/guestpayoutview")
	public String guestpayoutview(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");

		Service ss = sqlSession.getMapper( Service.class);
		ArrayList<PayDTO> list = ss.guestpayoutview(id);
		mo.addAttribute("list", list);
		
		return "payout";
	}
	
	// 관리자 페이지로 가기
	@RequestMapping(value = "/adminpagemain")
	public String adminpage(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");

		if (id.equals("admin")) {
			return "adminpagemain";
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

	// 관리자 페이지에서 회원 목록 보기 화면으로
	@RequestMapping(value = "/memberviewall")
	public String memberviewall(HttpServletRequest request, Model mo) {
		 Service ss = sqlSession.getMapper( Service.class);
		ArrayList<MembershipDTO> list = ss.memberviewall();
		mo.addAttribute("list", list);

		return "memberviewall";
	}

	// 마이페이지 환불 내역 보기
	@RequestMapping(value = "/refundview")
	public String refundview(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		 Service ss = sqlSession.getMapper( Service.class);
		ArrayList<MembershipDTO> list = ss.refundview(id);
		mo.addAttribute("list", list);

		return "refundout";
	}
	// 관리자페이지 환불 내역 보기
	@RequestMapping(value = "/adminrefundview")
	public String adminrefundview(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		 Service ss = sqlSession.getMapper( Service.class);
		ArrayList<MembershipDTO> list = ss.adminrefundview(id);
		mo.addAttribute("list", list);

		return "adminrefundview";
	}
	
	// 마이페이지 나의 상품 리뷰 보기
	@RequestMapping(value = "/myproductreview")
	public String myproductreview(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		 Service ss = sqlSession.getMapper( Service.class);
		ArrayList<ProductreviewDTO> list = ss.myproductreview(id);
		mo.addAttribute("list", list);
		

		return "myproductreview";
	}
	
	// 나의 상품 리뷰에서 리뷰한 상품 보기
	@RequestMapping(value = "/reviewproductview")
	public String reviewproductview(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		String stringSnum = request.getParameter("snum");
		int snum = Integer.parseInt(request.getParameter("snum"));
		String sname = request.getParameter("sname");
		
		Service ss = sqlSession.getMapper( Service.class);
		ArrayList<ProductDTO> list = ss.detailview(snum,sname);
		mo.addAttribute("list", list);
		
		
		// 상품 리뷰 출력 추가
		ArrayList<ProductreviewDTO> list1 = ss.productreviewout(snum,sname);
		mo.addAttribute("list1", list1);
		
		// 시각화 과정
		// 시각화 전에 필요한 데이터(상품을 결재한 유저 id의 주민번호) DB에서 가져오기
		ArrayList<MembershipDTO> list2 = ss.payinfodata(stringSnum);
		
		List<String> ageList = new ArrayList<>();

		for (MembershipDTO dto : list2) { 
		    String pid = dto.getPid();

		    // 나이 구분
		    char genderData = pid.charAt(7);
		    int birthdayData = Integer.parseInt(pid.substring(0,2));
		    
		    if(genderData == '1' || genderData == '2') {
		        birthdayData += 1900;
		    } else {
		        birthdayData += 2000;
		    }
		    LocalDate ld = LocalDate.now();
		    int nowyear = ld.getYear(); 
		    int age = nowyear - birthdayData;
		    
		    // 나이를 리스트에 추가
		    ageList.add(String.valueOf(age));
		}

		Map<String, Object> requestData = new HashMap<>();
		requestData.put("ages", ageList);
		requestData.put("snum", snum);
		
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonData;
		
		// 상품 설명 시각화 그래프 추가
		
		try {
			    jsonData = objectMapper.writeValueAsString(requestData);
	
			    
			    ProcessBuilder processBuilder = new ProcessBuilder("python", pythonScriptPath);
			    processBuilder.redirectErrorStream(true);
			    
			    Process process = processBuilder.start();
	
			    PrintWriter writer = new PrintWriter(process.getOutputStream(), true);
			    writer.println(jsonData);
			    writer.flush();
			    writer.close();
	         
	        try {
				int result = process.waitFor();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        
	        // 파이썬에서 만들어진 이미지 불러오기
	        String image = "/resources/python_image/product_visual_" + snum + ".png";
	        
	        // 모델에 그래프 이미지 경로 추가
	        mo.addAttribute("visual_image", image);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        // 시각화 과정 종료
		
		if(list==null || list.isEmpty() || list1==null || list1.isEmpty())
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('해당 상품은 존재하지 않습니다.'); window.history.back(); </script>");
			printw.close();
			return null;
		}
		else 
		{
			return "detailview";
		}
		
	}
	
	// 마이페이지 주소지 목록 가져오기
	@RequestMapping(value = "/mypageaddresslist",method = RequestMethod.GET)
	public String mypageaddresslist(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		com.ezen.haha.product.Service ss = sqlSession.getMapper(com.ezen.haha.product.Service.class);
		ArrayList<AddressListDTO> list = ss.addresslistout(id);
		
		mo.addAttribute("list", list);
		
		return "mypageaddresslist";
	}	
	
	// 주소 목록 추가 페이지
	@RequestMapping(value = "/addressinput")
	public String addressInput(HttpServletRequest request) {

		return "addressInput";
	}
	// 주소 목록 추가 
	@RequestMapping(value = "/addressSave")
	public String addressSave(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		String addressname = request.getParameter("addressname");
		String name = request.getParameter("name");
		String tel = "010-"+ request.getParameter("tel1") + "-" + request.getParameter("tel2");
		String address = request.getParameter("postcode")+","+request.getParameter("address1")+","+ 
						request.getParameter("address2");
		Service ss = sqlSession.getMapper(Service.class);
		
		System.out.println(id);
		System.out.println(addressname);
		System.out.println(name);
		System.out.println(tel);
		System.out.println(address);
		
		ss.addressInsert(id,addressname,name,tel,address);
			

		String script = "<script>";
	    script += "window.opener.location.reload();"; // 부모 창 리로드
	    script += "window.close();"; // 팝업 창 닫기
	    script += "window.opener.location.href='./mypageaddresslist';"; // 부모 창 리다이렉트
	    script += "</script>";

	    response.setContentType("text/html;charset=utf-8");
	    PrintWriter printw = response.getWriter();
	    printw.print(script);
	    printw.close();
	    return null;
	}	
	// 주소 목록 삭제 페이지
	@ResponseBody
	@RequestMapping(value = "/adderessDelete")
	public String adderessDelete(HttpServletRequest request) {
		Service ss = sqlSession.getMapper(Service.class);
		int addressnum = Integer.parseInt(request.getParameter("addressnum"));
		ss.addressDelete(addressnum);
		
		
		return "mypageaddresslist";
	}
		
	// 마이페이지 마일리지 화면 보기
	@RequestMapping(value = "/mileageview")
	public String mileageview(HttpServletRequest request, Model mo) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");

		Service ss = sqlSession.getMapper( Service.class);
		ArrayList<CouponDTO> list = ss.mileageview(id);
		
		mo.addAttribute("list", list);

		return "mileageview";
	}
	
	// 마이페이지 등급별 혜택 화면 보기
	@RequestMapping(value = "/rankgift")
	public String rankgift(HttpServletRequest request, Model mo) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		Service ss = sqlSession.getMapper( Service.class);
		ArrayList<MembershipDTO> list = ss.mypageview(id);
		mo.addAttribute("list", list);
		
		return "rankgift";
	}
	
		
		
}
