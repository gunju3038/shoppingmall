package com.ezen.haha.membership;

import java.util.ArrayList;

public interface Service {

	String id_check(String id);

	void membersave(String id, String pw, String name, String tel, String email, String pid,String address);

	MembershipDTO logingo(String id, String pw);

	MembershipDTO kakaologin(String email);

	ArrayList<MembershipDTO> memberidserch(String name, String email);
	
	MembershipDTO pwgetme(String id, String name, String email);

	String email_check(String email);

	void updatepw(String pw, String id);
	
	ArrayList<MembershipDTO> memberpwserch(String id);

	//MembershipDTO naverlogin(String name, String email);

	MembershipDTO naverlogin(String email);

	ArrayList<MembershipDTO> membershipsearch(String id);

	void membershipupdate(String newid, String pw, String name, String tel, String email, String pid, String address,
			String id);

	void membershipdelete(String id);

	void couponUpdate(String string, String id);

	void couponTotal(String id);
	
	void couponinsert(String id);
}
