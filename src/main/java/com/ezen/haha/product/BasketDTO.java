package com.ezen.haha.product;

import com.ezen.haha.membership.MembershipDTO;

public class BasketDTO {
	String id,sname,stype,ssize,image,color;
	int basketnum,snum,guestbuysu,price,totprice;
	MembershipDTO membershipdto;
	
	public BasketDTO() {}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getSname() {
		return sname;
	}

	public void setSname(String sname) {
		this.sname = sname;
	}

	public String getStype() {
		return stype;
	}

	public void setStype(String stype) {
		this.stype = stype;
	}

	public String getSsize() {
		return ssize;
	}

	public void setSsize(String ssize) {
		this.ssize = ssize;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public int getSnum() {
		return snum;
	}

	public void setSnum(int snum) {
		this.snum = snum;
	}

	public int getTotprice() {
		return totprice;
	}

	public void setTotprice(int totprice) {
		this.totprice = totprice;
	}

	public int getGuestbuysu() {
		return guestbuysu;
	}

	public void setGuestbuysu(int guestbuysu) {
		this.guestbuysu = guestbuysu;
	}

	public int getBasketnum() {
		return basketnum;
	}

	public void setBasketnum(int basketnum) {
		this.basketnum = basketnum;
	}

	public MembershipDTO getMembershipdto() {
		return membershipdto;
	}

	public void setMembershipdto(MembershipDTO membershipdto) {
		this.membershipdto = membershipdto;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}
	
}
