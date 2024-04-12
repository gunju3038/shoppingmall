package com.ezen.haha.mypage;

import java.util.ArrayList;

import com.ezen.haha.membership.MembershipDTO;
import com.ezen.haha.pay.PayDTO;

public interface Service {

	ArrayList<MembershipDTO> mypageview(String id);

	ArrayList<CouponDTO> couponview(String id);
	
	ArrayList<PayDTO> payoutview(String id);

	ArrayList<PayDTO> payoutviewall();

	ArrayList<MembershipDTO> memberviewall();

}
