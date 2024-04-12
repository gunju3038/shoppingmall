package com.ezen.haha.mypage;

import com.ezen.haha.membership.MembershipDTO;

public class CouponDTO {
	String id;
	int couponnum; // 쿠폰 총 개수 
	int twentinum; // 20% 할인쿠폰 개수
	int mannum; // 만원 쿠폰 개수
	int tennum; // 10% 할인쿠폰 개수

	MembershipDTO membershipdto;
	
	public CouponDTO() {}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getCouponnum() {
		return couponnum;
	}

	public void setCouponnum(int couponnum) {
		this.couponnum = couponnum;
	}

	public int getTwentinum() {
		return twentinum;
	}

	public void setTwentinum(int twentinum) {
		this.twentinum = twentinum;
	}

	public int getMannum() {
		return mannum;
	}

	public void setMannum(int mannum) {
		this.mannum = mannum;
	}

	public int getTennum() {
		return tennum;
	}

	public void setTennum(int tennum) {
		this.tennum = tennum;
	}

	public MembershipDTO getMembershipdto() {
		return membershipdto;
	}

	public void setMembershipdto(MembershipDTO membershipdto) {
		this.membershipdto = membershipdto;
	}

}
