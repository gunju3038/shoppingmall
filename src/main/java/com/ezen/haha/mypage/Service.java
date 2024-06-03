package com.ezen.haha.mypage;

import java.util.ArrayList;

import com.ezen.haha.membership.MembershipDTO;
import com.ezen.haha.pay.PayDTO;
import com.ezen.haha.product.ProductDTO;
import com.ezen.haha.product.ProductreviewDTO;
import com.ezen.haha.qna.QnaDTO;

public interface Service {

	ArrayList<MembershipDTO> mypageview(String id);

	ArrayList<CouponDTO> couponview(String id);

	ArrayList<PayDTO> payoutviewall();

	ArrayList<MembershipDTO> memberviewall();

	ArrayList<PayDTO> payoutviewmonth(String id);

	ArrayList<PayDTO> guestpayoutview(String id);

	ArrayList<MembershipDTO> refundview(String id);

	ArrayList<ProductreviewDTO> myproductreview(String id);
	
	ArrayList<ProductDTO> detailview(int snum, String sname);

	ArrayList<ProductreviewDTO> productreviewout(int snum, String sname);

	void addressInsert(String id, String addressname, String name, String tel, String address);

	void addressDelete(int addressnum);

	ArrayList<MembershipDTO> adminrefundview(String id);

	ArrayList<CouponDTO> mileageview(String id);

	ArrayList<ProductDTO> bestproductout();

	ArrayList<MembershipDTO> payinfodata(String stringSnum);

}
