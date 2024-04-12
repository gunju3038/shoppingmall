package com.ezen.haha.membership;

import java.util.ArrayList;

public interface Service {

	String id_check(String id);

	void membersave(String id, String pw, String name, String tel, String email, String pid,String address);

	MembershipDTO logingo(String id, String pw);

	MembershipDTO kakaologin(String email);

	ArrayList<MembershipDTO> memberidserch(String name, String email);

	String email_check(String email);

	void updatepw(String pw, String id);
	
	ArrayList<MembershipDTO> memberpwserch(String id);

	//MembershipDTO naverlogin(String name, String email);

	MembershipDTO naverlogin(String name);
}
