package com.ezen.haha.qna;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;


@Controller
public class QnaController {
	@Autowired
	SqlSession sqlSession;

	String imagepath = "C:\\이젠디지탈12\\spring\\shoppingmall-master\\src\\main\\webapp\\resources\\qnaimg";

	//고객센터 main
	@RequestMapping(value = "/qnahome")
	public String qna1(HttpServletRequest request ,Model mo) {
		 HttpSession hs = request.getSession();
		    String id = (String) hs.getAttribute("id");
		    
		    Service ss = sqlSession.getMapper(Service.class);
		    List<Map<String, Object>> myqnastate = ss.myqnastate(id);

		    int qnasuccess = 0;
		    int myqnaing = 0;

		    for (Map<String, Object> status : myqnastate) {
		        int qnastate = ((BigDecimal) status.get("QNASTATE")).intValue();
		        BigDecimal count = (BigDecimal) status.get("COUNT(*)");

		        if (qnastate == 1) {
		            qnasuccess = count.intValue();
		        } else {
		            myqnaing = count.intValue();
		        }
		    }

		    mo.addAttribute("qnasuccess", qnasuccess);
		    mo.addAttribute("myqnaing", myqnaing);

		    return "qnahome";
		}
	
	// 고객센터 공지사항출력화면
	@RequestMapping(value = "/notice")
	public String notice(HttpServletRequest request, com.ezen.haha.qna.PageDTO dto , Model mo) {
		String nowPage=request.getParameter("nowPage");
        String cntPerPage=request.getParameter("cntPerPage");
		Service ss = sqlSession.getMapper(Service.class);
		
		int total=ss.total();
		if(nowPage==null && cntPerPage == null) {
			nowPage="1";
			cntPerPage="7";
		}
		else if(nowPage==null) {
			nowPage="1";
		}
		else if(cntPerPage==null) {
			cntPerPage="7";
		}
		
		dto = new com.ezen.haha.qna.PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", ss.noticeout(dto.getStart(),dto.getEnd()));
		
		return "noticepage";
	}
	//공지사항 글쓰기(관리자만 가능해야함)
	@RequestMapping(value = "/noticeinput")
	public String qna3() {
		
		return "noticeinputform";
	}
	
	//공지사항 글쓰기 DB에 저장 (로그인한 관리자만 작성할 수 있게 해야함)
	@RequestMapping(value = "/noticesave", method = RequestMethod.POST)
	public String qna4(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		String bid = "관리자";
		String btype = mul.getParameter("btype");
		String btitle = mul.getParameter("btitle");
		String bcontent = mul.getParameter("bcontent");
		
		List<String> filename = new ArrayList<>();
		
		List<MultipartFile> fileList = mul.getFiles("bpicture");
		for (MultipartFile mf : fileList) {
	        if (!mf.isEmpty()) {
	            String originalfilename = mf.getOriginalFilename();
	            String extension = FilenameUtils.getExtension(originalfilename);
	            String uuid = UUID.randomUUID().toString();
	            String newfilename = uuid + "_" + System.currentTimeMillis() + "." + extension;
	            String fname = filesave(newfilename, mf.getBytes(), originalfilename);
	            filename.add(fname); // 파일 이름을 리스트에 추가
	        } else {
	            filename.add(null);
	        }
	    }
		// 파일 이름 리스트를 쉼표로 구분하여 문자열로 변환해줌
	    String fname = String.join(",", filename);
	    Service ss = sqlSession.getMapper(Service.class);
	    ss.noticeinsert(bid, btype, btitle, bcontent, fname);
	    
	    return "redirect:/notice";
	}
	
	private String filesave(String newfilename, byte[] bytes, String originalfilename) throws IOException {
		if (bytes == null) {
	        return null;
	    }
		String filePath = imagepath + "\\" + newfilename; // 이미지 경로 생성
		File file = new File(filePath);
		FileOutputStream fos = new FileOutputStream(file);
		fos.write(bytes);
		fos.close();
		return newfilename;
	}
	
	//제목 클릭 시 내용
	@RequestMapping(value = "/bcontentpage")
	public String qna5(HttpServletRequest request,Model mo) throws UnsupportedEncodingException {
		request.setCharacterEncoding("utf-8");
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<QnaDTO> list = ss.contentpage(bnum);
		mo.addAttribute("list", list);
		return "bcontentpage";
	}
	
	//공지사항 삭제
	@ResponseBody
	@RequestMapping(value = "/noticedelete")
	public String qna6(HttpServletRequest request) {
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		String originalbimg = request.getParameter("originalbimg");
		deleteFile(originalbimg); // 이미지 파일 삭제
		
		Service ss = sqlSession.getMapper(Service.class);
		int deletecount = ss.notice_delete(bnum);
		return (deletecount > 0) ? "success" : "failure";
	}
	
	private void deleteFile(String originalbimg) {
		if (originalbimg != null && !originalbimg.isEmpty()) {
			String imageName = originalbimg.substring(originalbimg.lastIndexOf("/") + 1);
			String img_allpath = imagepath + "\\" + imageName;
			File img = new File(img_allpath);
			if (img.exists() && img.delete()) {
				System.out.println("성공 ! img경로 : " + img);
			} else {
				System.out.println("실패!!! img경로 : " + img);
			}
		} else {
			System.out.println("이미지 경로가 없어요!? ");
		}
	}
	
	//공지사항 수정
	@RequestMapping(value = "/nmodify")
	public String qna7(HttpServletRequest request,Model mo) throws UnsupportedEncodingException {
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<QnaDTO> list = ss.contentpage(bnum);
		mo.addAttribute("list", list);
		return "nmodifypage";
	}
	
	//수정하는 부분에서 전에 있던 사진삭제
	@ResponseBody
	@RequestMapping(value = "/imgdelete")
	public String qna8(HttpServletRequest request) {
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		String originalbimg = request.getParameter("originalbimg");
		boolean hasimg = (originalbimg != null && !originalbimg.isEmpty());
		Service ss = sqlSession.getMapper(Service.class);
		int deletecount = 0;
		System.out.println("사진 이름 : "+ originalbimg);
		if (hasimg) {
			deleteFile(originalbimg); // 이미지 삭제
			// 파일 저장 경로에서 이미지 파일 삭제
			String filePath = imagepath + "\\" + originalbimg;
			File file = new File(filePath);
			if (file.exists()) {
				if (file.delete()) {
					System.out.println("이미지 파일 삭제 성공");
				} else {
					System.out.println("이미지 파일 삭제 실패");
				}
			} else {
				System.out.println("이미지 파일이 존재하지 않습니다.");
			}
			
			// 데이터베이스에서 이미지 정보 삭제
			deletecount = ss.notice_deleteimg(bnum);
		} else {
			deletecount = ss.notice_deleteimg(bnum);
		}
		
		return (deletecount > 0) ? "success" : "failure";
	}
	
	//공지사항 수정 DB에 업데이트 (로그인한 관리자만 작성할 수 있게 해야함)
	@RequestMapping(value = "/noticemodify", method = RequestMethod.POST)
	public String qna9(MultipartHttpServletRequest mul, HttpServletResponse response) throws IllegalStateException, IOException {
	    int bnum = Integer.parseInt(mul.getParameter("bnum"));
	    String btype = mul.getParameter("btype");
	    String btitle = mul.getParameter("btitle");
	    String bcontent = mul.getParameter("bcontent");
	    List<String> filename = new ArrayList<>();

	 // 새로운 이미지 업로드
	 List<MultipartFile> fileList = mul.getFiles("bpicture");
	 if (fileList != null && !fileList.isEmpty()) {
		 for (MultipartFile mf : fileList) {
			 String originalfilename = mf.getOriginalFilename();
			 String extension = FilenameUtils.getExtension(originalfilename);
			 String uuid = UUID.randomUUID().toString();
			 String newfilename = uuid + "_" + System.currentTimeMillis() + "." + extension;
			 String fname = filesave(newfilename, mf.getBytes(), originalfilename);
			 filename.add(fname);
		 }
	 } else {
		 filename.add(null);
	 }
	 
	 String fname = String.join(",", filename);
	 
	 // 기존 이미지를 삭제
	 String originalbimg = mul.getParameter("originalbimg"); 
	 deleteFile(originalbimg);
	 
	 Service ss = sqlSession.getMapper(Service.class);
	 
	 ss.noticeupdate(btype, btitle, bcontent, fname, bnum);
	 response.setContentType("text/html;charset=utf-8");
	 PrintWriter printw = response.getWriter();
	 printw.print("<script> alert('수정이 완료되었습니다.');</script>");
	 return "redirect:/notice";
	}
	
	//공지사항 검색
	@RequestMapping(value = "/searchgogo")
	public String qna10(HttpServletRequest request, com.ezen.haha.qna.PageDTO dto , Model mo) {
		String keyword = request.getParameter("keyword");
		String nowPage=request.getParameter("nowPage");
		String cntPerPage=request.getParameter("cntPerPage");
		Service ss = sqlSession.getMapper(Service.class);
		
		int total=ss.totalserch(keyword);
		if(nowPage==null && cntPerPage == null) {
			nowPage="1";
			cntPerPage="7";
		}
		else if(nowPage==null) {
			nowPage="1";
		}
		else if(cntPerPage==null) {
			cntPerPage="7";
		}
		
		dto = new com.ezen.haha.qna.PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", ss.noticeserch(keyword,dto.getStart(),dto.getEnd()));
		
		return "noticepage";
	}
	
	//FAQ(자주묻는질문)page
	@RequestMapping(value = "/faq")
	public String qna11(HttpServletRequest request, com.ezen.haha.qna.PageDTO dto , Model mo) {
		String nowPage=request.getParameter("nowPage");
		String cntPerPage=request.getParameter("cntPerPage");
		Service ss = sqlSession.getMapper(Service.class);
		
		int total=ss.total_faq();
		if(nowPage==null && cntPerPage == null) {
			nowPage="1";
			cntPerPage="7";
		}
		else if(nowPage==null) {
			nowPage="1";
		}
		else if(cntPerPage==null) {
			cntPerPage="7";
		}
		
		dto = new com.ezen.haha.qna.PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", ss.faqout(dto.getStart(),dto.getEnd()));
		
		return "faqpage";
	}
	
	//FAQ(자주묻는질문) 글쓰기(관리자만 가능해야함)
	@RequestMapping(value = "/faqinput")
	public String qna12() {
		
		return "faqinputform";
	}
	
	//FAQ 글쓰기 DB에 저장 (로그인한 관리자만 작성할 수 있게 해야함)
	@RequestMapping(value = "/faqsave", method = RequestMethod.POST)
	public String qna13(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		String bid = mul.getParameter("bid");
		String btype = mul.getParameter("btype");
		String btitle = mul.getParameter("btitle");
		String bcontent = mul.getParameter("bcontent");
		
		List<String> filename = new ArrayList<>();
		
		List<MultipartFile> fileList = mul.getFiles("bpicture");
		if (fileList != null && !fileList.isEmpty()) {
			for (MultipartFile mf : fileList) {
				if (!mf.isEmpty()) {
					String originalfilename = mf.getOriginalFilename();
					String extension = FilenameUtils.getExtension(originalfilename);
					String uuid = UUID.randomUUID().toString();
					String newfilename = uuid + "_" + System.currentTimeMillis() + "." + extension;
					String fname = filesave(newfilename, mf.getBytes(), originalfilename);
					filename.add(fname); // 파일 이름을 리스트에 추가
				} 
			}
		} else {
			filename.add(null);
		}
		// 파일 이름 리스트를 쉼표로 구분하여 문자열로 변환해줌
		String fname = String.join(",", filename);
		Service ss = sqlSession.getMapper(Service.class);
		ss.faqinsert(bid, btype, btitle, bcontent, fname);
		
		return "redirect:/faq";
	}
	
	//FAQ 글 수정
	@RequestMapping(value = "/fmodifypage")
	public String qna14(HttpServletRequest request,Model mo) throws UnsupportedEncodingException {
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<QnaDTO> list = ss.contentpage(bnum);
		mo.addAttribute("list", list);
		return "fmodifypage";
	}
	
	//faq 검색
	@RequestMapping(value = "/faqsearchgogo")
	public String qna15(HttpServletRequest request, com.ezen.haha.qna.PageDTO dto , Model mo) {
		String stype = request.getParameter("stype");
		String keyword = request.getParameter("keyword");
		String nowPage=request.getParameter("nowPage");
		String cntPerPage=request.getParameter("cntPerPage");
		Service ss = sqlSession.getMapper(Service.class);
		
		int total=ss.faqserchpageing(stype,keyword);
		if(nowPage==null && cntPerPage == null) {
			nowPage="1";
			cntPerPage="7";
		}
		else if(nowPage==null) {
			nowPage="1";
		}
		else if(cntPerPage==null) {
			cntPerPage="7";
		}
		
		dto = new com.ezen.haha.qna.PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", ss.faqserch(stype,keyword,dto.getStart(),dto.getEnd()));
		
		return "faqpage";
	}
	
	// qna 게시판 화면 보기
	@RequestMapping(value = "/qna")
	public String qnapage(HttpServletRequest request, com.ezen.haha.qna.PageDTO dto , Model mo) {
		String nowPage=request.getParameter("nowPage");
        String cntPerPage=request.getParameter("cntPerPage");
		Service ss = sqlSession.getMapper(Service.class);
		
		int total=ss.qnatotal();
		if(nowPage==null && cntPerPage == null) {
			nowPage="1";
			cntPerPage="7";
		}
		else if(nowPage==null) {
			nowPage="1";
		}
		else if(cntPerPage==null) {
			cntPerPage="7";
		}
		
		dto = new com.ezen.haha.qna.PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", ss.qnaout(dto.getStart(),dto.getEnd()));
		
		return "qnapage";
	}
	
	// qna 게시판 글쓰기 화면 보기
	@RequestMapping(value = "/qnainputform")
	public String qnainputform(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null)
		{
			return "qnainputform";
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

	//qna 글쓰기 DB에 저장 (로그인한 대상만 작성할 수 있게 해야함)
	@RequestMapping(value = "/qnasave", method = RequestMethod.POST)
	public String qnasave(MultipartHttpServletRequest mul, HttpServletResponse response) throws IllegalStateException, IOException {
		HttpSession hs = mul.getSession();
		String id = (String) hs.getAttribute("id");
		String bid = mul.getParameter("bid");
		
		if(id != null || bid != null)
		{
			String btype = mul.getParameter("btype");
			String btitle = mul.getParameter("btitle");
			String bcontent = mul.getParameter("bcontent");
			int secret = Integer.parseInt(mul.getParameter("secret"));
			
			
			List<String> filename = new ArrayList<>();
			
			List<MultipartFile> fileList = mul.getFiles("bpicture");
		    for (MultipartFile mf : fileList) {
		        String originalfilename = mf.getOriginalFilename();
		        String extension = FilenameUtils.getExtension(originalfilename);
		        String uuid = UUID.randomUUID().toString();
		        String newfilename = uuid + "_" + System.currentTimeMillis() + "." + extension;
		        String fname = filesave(newfilename, mf.getBytes(), originalfilename);
		        filename.add(fname); // 파일 이름을 리스트에 추가 ㄱㄱ
		    }
		    // 파일 이름 리스트를 쉼표로 구분하여 문자열로 변환해줌
		    String fname = String.join(",", filename);

		    Service ss = sqlSession.getMapper(Service.class);
		    ss.qnainsert(bid, btype, btitle, bcontent, fname, secret);
		    return "redirect:/qna";
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
	
	// qna 게시판 제목 클릭 시 내용
	@RequestMapping(value = "/qnacontentpage")
	public String qnacontentpage(HttpServletRequest request,Model mo,HttpServletResponse response) throws IOException {
		request.setCharacterEncoding("utf-8");
		int secret = Integer.parseInt(request.getParameter("secret"));
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		String bid = request.getParameter("bid");
		// 글쓴이와 관리자만 비밀글 들어갈 수 있게 조정
		if(id.equals(bid) || id.equals("admin"))
		{
			secret = 0;
		}
		
		if(secret == 1)
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('해당 글은 비밀글입니다.'); window.history.back(); </script>");
			printw.close();
			return null;
		}
		else
		{
			int bnum = Integer.parseInt(request.getParameter("bnum"));
			int step = Integer.parseInt(request.getParameter("step"));
			
			Service ss = sqlSession.getMapper(Service.class);
			ArrayList<QnaDTO> list = ss.qnacontentpage(bnum,step);
			mo.addAttribute("list", list);
			return "qnacontentpage";
		}
	}
	
	// qna 게시판 답글 쓰기 화면으로
	@RequestMapping(value = "/qnacomment")
	public String qnacomment(HttpServletRequest request ,Model mo, HttpServletResponse response) throws IOException {
		request.setCharacterEncoding("utf-8");
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		int step = Integer.parseInt(request.getParameter("step"));
		
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id.equals("admin"))
		{
			Service ss = sqlSession.getMapper(Service.class);
			ArrayList<QnaDTO> list = ss.commentinputview(bnum,step);
			mo.addAttribute("list", list);
			
			return "qnacommentinput";
		}
		else 
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('잘못된 접근입니다.'); window.history.back(); </script>");
			printw.close();
			return null;
		}
	}
	
	// qna 게시판 답글 DB에 저장
	@RequestMapping(value = "/qnacommentsave")
	public String qnacommentsave(HttpServletRequest request) throws UnsupportedEncodingException {
		request.setCharacterEncoding("utf-8");
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		int groups = Integer.parseInt(request.getParameter("groups"));
		int step = Integer.parseInt(request.getParameter("step"));
		int indent = Integer.parseInt(request.getParameter("indent"));
		String bid = request.getParameter("bid");
		String btype = request.getParameter("btype");
		String btitle = request.getParameter("btitle");
		String bcontent = request.getParameter("bcontent");
		String user = request.getParameter("user");
		int qnastate = Integer.parseInt(request.getParameter("qnastate"));
		
		Service ss = sqlSession.getMapper(Service.class);
		step++; // re 답글을 달때마다 증가하게 만듬
		indent++; // re 답글을 달때마다 증가하게 만듬
		ss.qnastateupdate(qnastate,user,bnum);
		ss.qnacommentsave(bnum,bid,btype,btitle,bcontent,groups,step,indent);
		return "redirect:/qna";
	}
	
	// 새로운 답글을 달때 step만 증가하게 만듬
	private void stepup(int groups, int step) {
		Service ss = sqlSession.getMapper(Service.class);
		ss.stepup(groups,step);
	}
	
	//qna 게시판 글 삭제
	@ResponseBody
	@RequestMapping(value = "/qnadelete")
	public String qnadelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		String bid = request.getParameter("bid");
		
		if(id.equals(bid) || id.equals("admin"))
		{
			int bnum = Integer.parseInt(request.getParameter("bnum"));
		    String originalbimg = request.getParameter("originalbimg");
		    deleteFile(originalbimg); // 이미지 파일 삭제

		    Service ss = sqlSession.getMapper(Service.class);
		    int deletecount = ss.qna_delete(bnum);
		    return (deletecount > 0) ? "success" : "failure";
		}
		else
		{
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 서버 오류 상태 코드 반환
		    return "failure";
		}
	    
	}
	
	// qna 게시판 글 수정
	@RequestMapping(value = "/qnamodify")
	public String qnamodify(HttpServletRequest request,Model mo, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		String bid = request.getParameter("bid");
		int step = Integer.parseInt(request.getParameter("step"));
		if(id.equals(bid) || id.equals("admin"))
		{
			Service ss = sqlSession.getMapper(Service.class);
			ArrayList<QnaDTO> list = ss.qnacontentview(bnum,step);
			mo.addAttribute("list", list);
			return "qnamodifypage";
		}
		else
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('해당 글 수정은 작성자 혹은 관리자만 가능합니다.'); window.history.back(); </script>");
			printw.close();
			return null;
		}
	}
	
	// qna 글 수정하는 부분에서 전에 있던 사진삭제
	@ResponseBody
	@RequestMapping(value = "/qnaimgdelete")
	public String qnaimgdelete(HttpServletRequest request) {
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		String originalbimg = request.getParameter("originalbimg");

		boolean hasimg = (originalbimg != null && !originalbimg.isEmpty());
		Service ss = sqlSession.getMapper(Service.class);
		int deletecount = 0;
		
		if (hasimg) {
			deleteFile(originalbimg); // 이미지 삭제
	        deletecount = ss.qna_deleteimg(bnum);
	    } else {
	        deletecount = ss.qna_deleteimg(bnum);
	    }

	    return (deletecount > 0) ? "success" : "failure";
	}
	
	// qna 게시판 글 수정 DB에 업데이트
		@RequestMapping(value = "/qnamodify", method = RequestMethod.POST)
		public String qnamodify(MultipartHttpServletRequest mul, HttpServletResponse response) throws IllegalStateException, IOException {
		    int bnum = Integer.parseInt(mul.getParameter("bnum"));
		    String step = mul.getParameter("step");
		    String btype = mul.getParameter("btype");
		    String btitle = mul.getParameter("btitle");
		    String bcontent = mul.getParameter("bcontent");
		    List<String> filename = new ArrayList<>();

		    // 새로운 이미지 업로드
		    List<MultipartFile> fileList = mul.getFiles("bpicture");
		    for (MultipartFile mf : fileList) {
		        String originalfilename = mf.getOriginalFilename();
		        String extension = FilenameUtils.getExtension(originalfilename);
		        String uuid = UUID.randomUUID().toString();
		        String newfilename = uuid + "_" + System.currentTimeMillis() + "." + extension;
		        String fname = filesave(newfilename, mf.getBytes(), originalfilename);
		        filename.add(fname);
		    }
		    String fname = String.join(",", filename);

		    // 기존 이미지를 삭제
		    String originalbimg = mul.getParameter("originalbimg"); 
		    
		    deleteFile(originalbimg);
		    
		    Service ss = sqlSession.getMapper(Service.class);

		    ss.qnaupdate(btype, btitle, bcontent, fname, bnum, step);
		    response.setContentType("text/html;charset=utf-8");
		    PrintWriter printw = response.getWriter();
		    printw.print("<script> alert('수정이 완료되었습니다.'); window.location.href='./qna'; </script>");
		    printw.close();
		    return "redirect:/qna";
		}

	// qna 게시판 검색
	@RequestMapping(value = "/qnasearchgogo")
	public String qnasearchgogo(HttpServletRequest request, com.ezen.haha.qna.PageDTO dto , Model mo) {
		String keyword = request.getParameter("keyword");
		 if (keyword == null || keyword.trim().isEmpty()) {
		        // 에러가 아니라 그냥 페이지를 반환
		        return "redirect:./qna";
		    }
		 
		Service ss = sqlSession.getMapper(Service.class);
		int bnum = ss.bnumsearch(keyword);
		
		String nowPage=request.getParameter("nowPage");
		String cntPerPage=request.getParameter("cntPerPage");
		
		
		int total=ss.qnatotalsearch(keyword);
		if(nowPage==null && cntPerPage == null) {
			nowPage="1";
			cntPerPage="7";
		}
		else if(nowPage==null) {
			nowPage="1";
		}
		else if(cntPerPage==null) {
			cntPerPage="7";
		}
		
		dto = new com.ezen.haha.qna.PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", ss.qnasearch(keyword,dto.getStart(),dto.getEnd(),bnum));
		
		return "qnapage";
	}	
	
	// qnamain에서 나의게시판 화면 보기
	@ResponseBody
	@RequestMapping(value = "/qnagetme", method = RequestMethod.POST)
	public List<QnaDTO> fetchData(@RequestParam("status") String status,
			HttpSession session) {
		
		String id = (String) session.getAttribute("id");
		Service ss = sqlSession.getMapper(Service.class);
		List<QnaDTO> list = new ArrayList<>();
		
		if (status.equals("qnasuccess")) {
			List<Integer> bnum = ss.numberget(id);
			
			list = ss.qnamainsuccess(id, bnum);
		} else if (status.equals("myqnaing")) {
			list = ss.qnamainsearch(id);
		}
		return list;
	}
	
	// 마이페이지 문의내역 보기
	@RequestMapping(value = "/qnalist")
	public String qnalist(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String bid = (String) hs.getAttribute("id");
		
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<QnaDTO> list = ss.qnalist(bid);
		mo.addAttribute("list", list);
		
		return "qnalist";
	}
	
	// 마이페이지 문의내역 제목 클릭 시 qna 검색 화면으로 
	@RequestMapping(value = "/qnasearchview")
	public String qnasearchview(HttpServletRequest request, com.ezen.haha.qna.PageDTO dto , Model mo) {
		String btitle = request.getParameter("btitle");
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		
		Service ss = sqlSession.getMapper(Service.class);
		
		String nowPage=request.getParameter("nowPage");
		String cntPerPage=request.getParameter("cntPerPage");
		
		
		int total=ss.qnatotalsearch(btitle);
		if(nowPage==null && cntPerPage == null) {
			nowPage="1";
			cntPerPage="7";
		}
		else if(nowPage==null) {
			nowPage="1";
		}
		else if(cntPerPage==null) {
			cntPerPage="7";
		}
		
		dto = new com.ezen.haha.qna.PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", ss.qnasearch(btitle,dto.getStart(),dto.getEnd(),bnum));
		
		return "qnapage";
	}
	
	//faq 수정 DB에 업데이트
   @RequestMapping(value = "/faqmodify", method = RequestMethod.POST)
   public String qna22(MultipartHttpServletRequest mul, HttpServletResponse response) throws IllegalStateException, IOException {
      int bnum = Integer.parseInt(mul.getParameter("bnum"));
      String btype = mul.getParameter("btype");
      String btitle = mul.getParameter("btitle");
      String bcontent = mul.getParameter("bcontent");
      List<String> filename = new ArrayList<>();
      
      // 새로운 이미지 업로드
      List<MultipartFile> fileList = mul.getFiles("bpicture");
      if (fileList != null && !fileList.isEmpty()) {
         for (MultipartFile mf : fileList) {
            String originalfilename = mf.getOriginalFilename();
            String extension = FilenameUtils.getExtension(originalfilename);
            String uuid = UUID.randomUUID().toString();
            String newfilename = uuid + "_" + System.currentTimeMillis() + "." + extension;
            String fname = filesave(newfilename, mf.getBytes(), originalfilename);
            filename.add(fname);
         }
      } else {
         filename.add(null);
      }
      
      String fname = String.join(",", filename);
      
      // 기존 이미지를 삭제
      String originalbimg = mul.getParameter("originalbimg"); 
      deleteFile(originalbimg);
      
      Service ss = sqlSession.getMapper(Service.class);
      
      ss.noticeupdate(btype, btitle, bcontent, fname, bnum);
      response.setContentType("text/html;charset=utf-8");
      PrintWriter printw = response.getWriter();
      printw.print("<script> alert('수정이 완료되었습니다.');</script>");
      return "redirect:/faq";
   }
}
