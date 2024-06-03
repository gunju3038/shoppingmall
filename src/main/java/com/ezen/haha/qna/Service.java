package com.ezen.haha.qna;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ezen.haha.mypage.AddressListDTO;
import com.ezen.haha.mypage.CouponDTO;

public interface Service {

	void noticeinsert(String bid, String btype, String btitle, String bcontent, String fname);

	ArrayList<QnaDTO> noticeout(int start, int end);

	ArrayList<QnaDTO> contentpage(int bnum);

	public int total();
	
	public ArrayList<QnaDTO> page(PageDTO dto);

	int notice_delete(int bnum);

	int notice_deleteimg(int bnum);

	void noticeupdate(String btype, String btitle, String bcontent, String fname, int bnum);

	ArrayList<QnaDTO> noticeserch(String keyword, int start, int end);

	int totalserch(String keyword);
	
	void faqinsert(String bid, String btype, String btitle, String bcontent, String fname);

	ArrayList<QnaDTO> faqout(int start, int end);

	int total_faq();

	int faqserchpageing(String stype, String keyword);

	ArrayList<QnaDTO> faqserch(String stype, String keyword, int start, int end);

	void qnainsert(String bid, String btype, String btitle, String bcontent, String fname, int secret);
	
	ArrayList<QnaDTO> qnaout(int start, int end);

	ArrayList<QnaDTO> commentinputview(int bnum, int step);

	ArrayList<QnaDTO> qnacontentpage(int bnum, int step);

	void stepup(int groups, int step);

	void qnacommentsave(int bnum, String bid, String btype, String btitle, String bcontent, int groups, int step, int indent);

	int qnatotal();

	int qna_delete(int bnum);

	ArrayList<QnaDTO> qnacontentview(int bnum, int step);

	int qna_deleteimg(int bnum);

	void qnaupdate(String btype, String btitle, String bcontent, String fname, int bnum, String step);

	int qnatotalsearch(String keyword);

	ArrayList<QnaDTO> qnasearch(String keyword, int start, int end, int bnum);

	int bnumsearch(String keyword);

	void qnastateupdate(int qnastate, String user, int bnum);

	int qnabnumsearch(String id);
	
	List<Map<String, Object>> myqnastate(String id);

	List<QnaDTO> qnamainsearch(String id);

	List<QnaDTO> qnamainsuccess(String id, List<Integer> bnum);

	List<Integer> numberget(String id);
	
	ArrayList<QnaDTO> qnalist(String bid);

}
