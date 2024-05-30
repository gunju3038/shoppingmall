package com.ezen.haha.pay;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ezen.haha.product.BasketDTO;


@Controller
public class PayOrderController {
	@Autowired
	SqlSession sqlSession;
	
	// 환불 결정 화면으로 가기
    @RequestMapping(value = "/paycancel")
	public String paycancel(HttpServletRequest request, Model mo) {
    	String orderid = request.getParameter("orderid");
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<PayDTO> list = ss.paysearch(orderid);
		
		mo.addAttribute("list", list);
    	
		return "paycancel";
	}

    //무통장입금
    @RequestMapping(value = "/bankAction")
	public String bankDepositAction(HttpServletRequest request,Model mo) {
    	HttpSession hs = request.getSession();
    	com.ezen.haha.pay.Service ss = sqlSession.getMapper(com.ezen.haha.pay.Service.class);
    	String id = (String) hs.getAttribute("id");
		String name = request.getParameter("name");
		String tel = request.getParameter("tel");
    	String address = request.getParameter("postcode") + "," + request.getParameter("address1") + "," +
    					 request.getParameter("address2");
    	String sname = request.getParameter("sname");
    	int paynum = Integer.parseInt(request.getParameter("guestbuysu"));
    	String payment = request.getParameter("payment");
    	String snum = request.getParameter("snum");
    	String email = ss.email(id);

    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Date now = new Date();         
    	String payEndTime = sdf.format(now);
    	String paystate = "1";

    	String price = request.getParameter("price");
    	price = price.replace(",", "");
    	int totprice = Integer.parseInt(price);
    	
    	String stringSavePoint = request.getParameter("savepoint");
    	stringSavePoint = stringSavePoint.replace(",", "");
    	int savePoint = Integer.parseInt(stringSavePoint);
    	
    	int usePoint;
    	if(request.getParameter("point") == null) {
    		usePoint = 0;
    	}
    	else {
    		String point = request.getParameter("point");
    		
    		point = point.replace(",", "");
    		usePoint = Integer.parseInt(point);     		
    	}
    	String useCoupon = request.getParameter("useCoupon");
    	String insertCoupon = "";
    	if(useCoupon.equals("10000원 할인쿠폰")) {
    		insertCoupon = "mannum";
    	}
    	else if(useCoupon.equals("10% 할인쿠폰")) {
    		insertCoupon = "tennum";
    	}
    	else if(useCoupon.equals("20% 할인쿠폰")) {
    		insertCoupon = "twentinum";
    	}
    	ss.bankinsert(id,name,address,tel,email,payment,snum,sname,paynum,totprice,payEndTime,paystate,insertCoupon,savePoint,usePoint);
    	int orderid = ss.selectorderid(id);
    	String basketnum = request.getParameter("basketnum");

    	// 결재 완료 후 해당 상품 재고 감소 업데이트
    	String[] basketnums = basketnum.split(",");
        for (String basket : basketnums) {
        	ArrayList<BasketDTO> basketlist = ss.basketInfo(basket);
        	for(BasketDTO aa : basketlist) {
        		ss.productsuupdate(aa);
        	}
        	ss.basketDelete(basket);
        }
    	if(useCoupon.equals("10000원 할인쿠폰")) {
    		ss.couponUpdate(id,"mannum");    		
    	}
    	else if(useCoupon.equals("10% 할인쿠폰")) {
    		ss.couponUpdate(id,"tennum");    		
    	}
    	else if(useCoupon.equals("20% 할인쿠폰")) {
    		ss.couponUpdate(id,"twentinum");    		
    	}
    	com.ezen.haha.membership.Service mss = sqlSession.getMapper(com.ezen.haha.membership.Service.class);
    	mss.couponTotal(id);
  		ss.pointUpdate(id,usePoint,savePoint);
  		int nowpoint = ss.selectnowpoint(id);
  		ss.banknowpointUpdate(nowpoint,id,orderid);
  		int totalPrice = ss.totalPrice(id);
  		ss.rankUpdate(id,totalPrice);
  		if(payment.equals("카카오페이")) {
        	return "zeroKakao";
        }
    	
    	Random random = new Random();
        StringBuilder accountNumber = new StringBuilder();
        accountNumber.append(random.nextInt(9) + 1);
        for (int i = 0; i < 10; i++) {
            int digit = random.nextInt(10); //
            accountNumber.append(digit);
        }
        String account = accountNumber.toString();
        account =  account.substring(0, 3) + "-" + account.substring(3, 7) + "-" + account.substring(7);
        
        String bankChoice = request.getParameter("bankChoice");
        mo.addAttribute("account", account);
        mo.addAttribute("bankChoice", bankChoice);
    	
        return "bankaction";
	}
    
 //   payCancel
    @ResponseBody
    @RequestMapping(value = "/bankCancel", method = RequestMethod.POST) 
    public String bankCancel(HttpServletRequest request) {
    	int orderid = Integer.parseInt(request.getParameter("orderid"));
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
    
		String message = "환불이 완료되었습니다.";
        
        Service ss = sqlSession.getMapper(Service.class);
        String useCoupon = ss.selectUseCoupon(orderid);
        int savePoint = ss.selectSavePoint(orderid);
        ss.updatepaylist(orderid);
   
        if(useCoupon != null) {
        	ss.couponRefund(id,useCoupon);
        }
        ss.savePointRefund(id,savePoint);
        int totalPrice = ss.totalPrice(id);
  		ss.rankUpdate(id,totalPrice);
  		
    	com.ezen.haha.membership.Service mss = sqlSession.getMapper(com.ezen.haha.membership.Service.class);
    	mss.couponTotal(id); // 보유쿠폰 수 갱신
        
    	return message;
    }
    
    
}
