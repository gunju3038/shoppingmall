package com.ezen.haha.product;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.ibatis.session.SqlSession;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.ezen.haha.membership.MembershipDTO;
import com.ezen.haha.mypage.AddressListDTO;
import com.ezen.haha.mypage.CouponDTO;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


@Controller
public class ProductController {
	@Autowired
	SqlSession sqlSession;
	
	// 이미지 파일 저장 경로
	String imagepath = "C:\\이젠디지탈12\\spring\\shoppingmall-master\\src\\main\\webapp\\image\\";
	
	// 파이썬 파일 실행 경로
    String pythonScriptPath = "C:\\이젠디지탈12\\spring\\shoppingmall-master\\src\\main\\webapp\\resources\\python\\product_visual.py";
	
	// 상품 입력 화면으로
	@RequestMapping(value = "/productinput")
	public String productinput(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		return "productinput";
	}
	
	// 상품 입력 후 DB에 저장
	@RequestMapping(value = "/productsave", method = RequestMethod.POST)
	public String productsave(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		int snum = Integer.parseInt(mul.getParameter("snum"));
		String stype = mul.getParameter("stype");
		String stype_sub = mul.getParameter("stype_sub");
		String sname = mul.getParameter("sname");
		int price = Integer.parseInt(mul.getParameter("price"));
		int ssize = Integer.parseInt(mul.getParameter("ssize"));
		int msize = Integer.parseInt(mul.getParameter("msize"));
		int lsize = Integer.parseInt(mul.getParameter("lsize"));
		int xlsize = Integer.parseInt(mul.getParameter("xlsize"));
		String intro = mul.getParameter("intro");
		int best = Integer.parseInt(mul.getParameter("best"));
		int recommend = Integer.parseInt(mul.getParameter("recommend"));
		
		String fname = "";
		List<MultipartFile> fileList = mul.getFiles("image");
		boolean firstfile = true;
        for (MultipartFile mf : fileList) {
             String originFileName = mf.getOriginalFilename();
             if(firstfile) {
            	 fname = originFileName;
            	 firstfile = false;
             }
             else {
            	 fname = fname + ", " +originFileName;
             }
             String safeFile = imagepath + originFileName;
             mf.transferTo(new File(safeFile));
         }
        
		Service ss = sqlSession.getMapper(Service.class);
		ss.productinsert(snum,sname,stype,stype_sub,price,ssize,msize,lsize,xlsize,fname,intro,best,recommend,0);
		
		return "redirect:/productinput";
	}
	// 관리자 상품출력 페이지
	@RequestMapping(value = "/productout")
	public String productout(HttpServletRequest request, PageDTO dto, Model mo, HttpServletResponse response) throws IOException {
		String nowPage=request.getParameter("nowPage");
        String cntPerPage=request.getParameter("cntPerPage");
        Service ss = sqlSession.getMapper(Service.class);
        
        int total=ss.total();
    
        if(nowPage==null && cntPerPage == null) {
           nowPage="1";
           cntPerPage="5";
        }
        else if(nowPage==null) {
           nowPage="1";
        }
        else if(cntPerPage==null) {
           cntPerPage="5";
        }      
       
	    dto = new PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		ArrayList<ProductDTO> list = ss.productout(dto);
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", list);
	
		return "productout";
	}
	
	// 상품 클릭 시 상품 내용 화면으로 가기
	@RequestMapping(value = "/detailview")
	public String detailview(HttpServletRequest request, Model mo) {
		String stringSnum = request.getParameter("snum");
		int snum = Integer.parseInt(request.getParameter("snum"));
		Service ss = sqlSession.getMapper(Service.class);
		
		ss.updateViewNum(snum);
		ArrayList<ProductDTO> list = ss.detailview(snum);
		mo.addAttribute("list", list);
		
		// 상품 리뷰 출력 추가
		ArrayList<ProductreviewDTO> list1 = ss.productreviewout(snum);
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
				e.printStackTrace();
			}
	        
	        String image = "/resources/python_image/product_visual_"+ snum +".png";
	        
	        // 모델에 그래프 이미지 경로 추가
	        mo.addAttribute("visual_image", image);
		} catch (IOException e) {
			e.printStackTrace();
		}
        // 시각화 과정 종료
		return "detailview";
	}
	// 상품 내용 창에서 장바구니 DB 저장
	@RequestMapping(value = "/basket")
	public String basket(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 로그인 시 id 가져오기
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null) // 로그인 체크
		{
			Service ss = sqlSession.getMapper(Service.class);
			int snum = Integer.parseInt(request.getParameter("snum"));
			int guestbuysu = Integer.parseInt(request.getParameter("guestbuysu"));
			String size = request.getParameter("size");
			String color = request.getParameter("color");
			
			int duplicateCheck = ss.duplicateCheck(id,snum,size); // 장바구니 중복 체크
			
			if(duplicateCheck != 0) {
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script> alert('중복된 제품이 장바구니에 있습니다.'); history.back(); </script>");
				printw.close();
				return null;
			}
			else {
				ss.basketinsert(id,snum,guestbuysu,size,color); // 장바구니 입력
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script>" +
					    	 "if (confirm('장바구니로 이동하시겠습니까?')) {" +
					    	 "    window.location.href='./basketout';" +
					    	 "} else {" +
					    	 "    history.back();" + // 현재 페이지 유지
					    	 "}" +
					    	 "</script>"
					);
				printw.close();
				return null;
			}
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
	
	// DB 저장한 장바구니 출력
	@RequestMapping(value = "/basketout")
	public String basketout(HttpServletRequest request, PageDTO dto, Model mo, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		Service ss = sqlSession.getMapper(Service.class);
		if(id != null) {
			ArrayList<BasketDTO> list = ss.basketout(id);
			for(BasketDTO basket : list) {
				String stock = ss.stockcheck(basket.snum, basket.psize);	
				basket.setStock(Integer.parseInt(stock));
			}
			mo.addAttribute("list", list);
			
			return "basketout";
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
	
	// 장바구니에서 체크박스 선택 후 구매확인 화면으로 이동
	@RequestMapping(value = "/basketsell", method = RequestMethod.POST)
	public String basketsell(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		Service ss = sqlSession.getMapper(Service.class);
		ss.deleteproductsell(); // 구매 창을 누를 때마다 DB에 담긴 주문 정보 초기화(delete), 안하면 이전 주문정보를 전부 불러옴, 구매 정보는 구매할 시 payinfo DB 테이블(결재 정보)에 따로 저장 
		
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null) // 로그인 중이라면
		{
			String [] items = request.getParameterValues("item"); // 체크박스로 선택한 목록 번호를 가져옴
			String [] reguestbuysu = request.getParameterValues("guestbuysu"); // 장바구니에서 수정한 수량을 가져옴
			String [] retotprice = request.getParameterValues("totprice"); // 장바구니에서 수정한 총 가격을 가져옴
			int [] basketnum = null;
			int [] guestbuysu = null;
			int [] totprice = null;
			
			if(items != null)
			{
				basketnum = new int[items.length]; // basketnum 배열 초기화, 안하면 널포인트 에러가 뜬다.
				guestbuysu = new int[reguestbuysu.length];
		        totprice = new int[retotprice.length];
		        
				for(int i=0; i<items.length; i++)
				{
					basketnum[i] = Integer.parseInt(items[i]); // int 타입으로 전환
					guestbuysu[i] = Integer.parseInt(reguestbuysu[i]);
					totprice[i] = Integer.parseInt(retotprice[i]);
				}
			}
			
			ArrayList<BasketDTO> list = new ArrayList<>(); 
			for (int i = 0; i < basketnum.length; i++) {
				ss.updatebasket(guestbuysu[i],totprice[i],basketnum[i]);// 장바구니에서 수정한 수량, 총 가격 업데이트
			    list.add(ss.basketsell(basketnum[i]));
			}
			
			mo.addAttribute("list", list);
			
			return "basketsellout";
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
	
	// 상품 내용 화면에서 즉시 구매 클릭 시 구매확인 화면으로 이동
	@RequestMapping(value = "/productsell", method = RequestMethod.POST)
	public String productsell(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		Service ss = sqlSession.getMapper(Service.class);
		
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null) // 로그인확인
		{	
			String [] items = request.getParameterValues("item"); // 체크된 상품들 가져오기
			String [] reguestbuysu = request.getParameterValues("guestbuysu"); 
			String totprice = request.getParameter("topPrice"); 
			ArrayList<BasketDTO> list = new ArrayList<>(); 

			for(int i=0; i<items.length; i++  ) {
				ss.updatebasket(items[i], reguestbuysu[i]);
				list.add(ss.productsell(items[i]));
			}
			mo.addAttribute("list", list);
			mo.addAttribute("totprice", totprice);
			mo.addAttribute("point", ss.pointOut(id));
			mo.addAttribute("rank", ss.rankOut(id)); 
			return "basketsellout";
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
	
	// 즉시구매 시 basketDB에 저장 후 출력
	@RequestMapping(value = "/directBuy")
	public String directBuy(HttpServletRequest request, HttpServletResponse response, Model mo) throws IOException {
		// 로그인 시 id 가져오기
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null) // 로그인 체크
		{
			Service ss = sqlSession.getMapper(Service.class);
			BasketDTO basketdto = new BasketDTO();
			int snum = Integer.parseInt(request.getParameter("snum"));
			int guestbuysu = Integer.parseInt(request.getParameter("guestbuysu"));
			String psize = request.getParameter("size");
			String color = request.getParameter("color");
			int stock = Integer.parseInt(ss.stockcheck(snum,psize));
			basketdto.setColor(color);
			basketdto.setGuestbuysu(guestbuysu);
			basketdto.setId(id);
			basketdto.setPsize(psize);
			basketdto.setSnum(snum);
			basketdto.setStock(stock);
			ss.basketdirectinsert(basketdto); // 장바구니 입력
			String basketnum = String.valueOf(basketdto.getBasketnum()); 
			ArrayList<BasketDTO> list = new ArrayList<>(); 

			list.add(ss.productsell(basketnum));
			int totprice = list.get(0).productdto.price * guestbuysu;
			
			mo.addAttribute("list", list);
			mo.addAttribute("totprice", totprice);
			mo.addAttribute("point", ss.pointOut(id));
			mo.addAttribute("rank", ss.rankOut(id));
			return "basketsellout";
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
	
	// 장바구니 목록 선택 후 삭제
	@RequestMapping(value = "/basketdelete")
	public String basketdelete(HttpServletRequest request) {
		String [] items = request.getParameterValues("item"); // 체크박스로 선택한 목록 번호를 가져옴
		int [] basketnum = null;
		
		if(items != null && items.length > 0)
		{
			basketnum = new int[items.length];
			for(int i=0; i<items.length; i++)
			{
				basketnum[i] = Integer.parseInt(items[i]);
			}
		}
		
		Service ss = sqlSession.getMapper(Service.class);
		for (int i = 0; i < basketnum.length; i++) {
			ss.deletebasket(basketnum[i]);
		}
		return "redirect:/basketout";
	}
	
	// 상품 내용 화면에서 상품 삭제하기
	@RequestMapping(value = "/deleteProduct")
	public String deleteproduct(HttpServletRequest request) {
		int snum = Integer.parseInt(request.getParameter("snum"));
		Service ss = sqlSession.getMapper(Service.class);
		String files = ss.getImage(snum);
		
		String[] imageFiles = files.split(", "); 
		for(String image : imageFiles) {
			File imageFile = new File(imagepath+image);
			imageFile.delete();
		}
		
		ss.deleteproduct(snum);
		
		return "redirect:/productout";
	}
	
	// 상품 내용 화면에서 상품 수정 화면으로 가기
	@RequestMapping(value = "/updateproductview")
	public String updateproductview(HttpServletRequest request, Model mo) {
		int snum = Integer.parseInt(request.getParameter("snum"));
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<ProductDTO> list = ss.updateproductview(snum);
		mo.addAttribute("list", list);
		
		return "updateproductview";
	}	
		
	// 상품 수정 화면에서 받은 데이터로 상품 정보 수정하기
	@RequestMapping(value = "/updateproduct", method = RequestMethod.POST)
	public String updateproduct(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		int snum = Integer.parseInt(mul.getParameter("snum"));
		String stype = mul.getParameter("stype");
		String stype_sub = mul.getParameter("stype_sub");
		String sname = mul.getParameter("sname");
		int price = Integer.parseInt(mul.getParameter("price"));
		int ssize = Integer.parseInt(mul.getParameter("ssize"));
		int msize = Integer.parseInt(mul.getParameter("msize"));
		int lsize = Integer.parseInt(mul.getParameter("lsize"));
		int xlsize = Integer.parseInt(mul.getParameter("xlsize"));
		String intro = mul.getParameter("intro");
		int best = Integer.parseInt(mul.getParameter("best"));
		int recommend = Integer.parseInt(mul.getParameter("recommend"));
		
		Service ss = sqlSession.getMapper(Service.class);
		String fnames = ss.getImage(snum);
		String [] images = fnames.split(", ");
		for(String image : images) {
			File imageFile = new File(imagepath+image);
			imageFile.delete();
		}
		
		String fname = "";
		List<MultipartFile> fileList = mul.getFiles("image");
		boolean firstfile = true;
        for (MultipartFile mf : fileList) {
             String originFileName = mf.getOriginalFilename(); 
             if(firstfile) {
            	 fname = originFileName;
            	 firstfile = false;
             }
             else {
            	 fname = fname + ", " +originFileName;
             }
             String safeFile = imagepath + originFileName;
             mf.transferTo(new File(safeFile));
         }
		
		ss.productupdate(sname,stype,stype_sub,price,ssize,msize,lsize,xlsize,fname,intro,best,recommend,snum);
		 
		return "redirect:/productout";
	}


	// 회원정보수정(주소)
	@RequestMapping(value = "/updateaddress")
	public String updateaddress() {
		
		return "updateaddress";
	}
	
	// 회원정보수정(이름)
	@RequestMapping(value = "/updatename")
	public String updatename() {
		
		return "updatename";
	}
	
	// 회원정보수정(전화번호)
	@RequestMapping(value = "/updatetel")
	public String updatetel() {
		
		return "updatetel";
	}
	// 회원정보수정(이메일)
	@RequestMapping(value = "/updateemail")
	public String updateemail() {
		
		return "updateemail";
	}
	
	// 상품 리뷰 입력 화면으로
	@RequestMapping(value = "/productreviewinput")
	public String productreviewinput(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		Service ss = sqlSession.getMapper(Service.class);
		
		String snumber = request.getParameter("snum");
		String [] snumbers  = snumber.split(",");
		int snum = Integer.parseInt(snumbers[0]);
		
		ArrayList<ProductDTO> list = new ArrayList<ProductDTO>();
		if(snumbers.length >= 2) {
			for(int i = 0; i<snumbers.length; i++) {
				 list.add(ss.selectReview(Integer.parseInt(snumbers[i])));	
				 String [] images = list.get(i).image.split(",");
				 String image = images[0];
				 list.get(i).setImage(image);
			}
			mo.addAttribute("list",list);
		
			return "productSelectReview";
		}
		else {
			ArrayList<ProductreviewDTO> reviewList = ss.checkReview(id,snum);
			if(!reviewList.isEmpty()) {
				
				mo.addAttribute("list", reviewList);
				return "productReviewModify";
			}
			
				list.add(ss.selectReview(snum));	
				String [] images = list.get(0).image.split(",");
				String image = images[0];
				list.get(0).setImage(image);
			
				mo.addAttribute("list",list);
			
			return "productreviewinput";
		}
	}
	
	
	// 상품 리뷰 입력 후 DB에 저장
	@RequestMapping(value = "/productreviewsave", method = RequestMethod.POST)
	public String productreviewsave(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		Service ss = sqlSession.getMapper(Service.class);
		HttpSession hs = mul.getSession();
		String id = (String) hs.getAttribute("id"); 
		String btitle = mul.getParameter("btitle");
		int snum = Integer.parseInt(mul.getParameter("snum"));
		String sname = mul.getParameter("sname");
		String image = mul.getParameter("image");
		String bcontent = mul.getParameter("bcontent");
		int productrank = Integer.parseInt(mul.getParameter("productrank"));
		
		if (mul.getFile("bpicture") != null && !mul.getFile("bpicture").isEmpty()) {
		MultipartFile mf = mul.getFile("bpicture");
		String fname = mf.getOriginalFilename();
		mf.transferTo(new File(imagepath+"\\"+fname));
		ss.productreviewsave(snum,sname,id,btitle,bcontent,fname,productrank,image);
		}
		else {
			ss.productreviewsave(snum,sname,id,btitle,bcontent,"0",productrank,image);
		}
			
		return "redirect:/myproductreview";
	}
	
	// 상품 리뷰 업데이트
	@RequestMapping(value = "/productreviewupdate", method = RequestMethod.POST)
	public String productreviewupdate(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		Service ss = sqlSession.getMapper(Service.class);
		HttpSession hs = mul.getSession();
		String id = (String) hs.getAttribute("id"); 
		String btitle = mul.getParameter("btitle");
		int snum = Integer.parseInt(mul.getParameter("snum"));
		String sname = mul.getParameter("sname");
		String bcontent = mul.getParameter("bcontent");
		int productrank = Integer.parseInt(mul.getParameter("productrank"));
		int bnum = ss.selectBnum(id,snum);
		String deleteFile = ss.deleteFile(id,snum);
		File imageFile = new File(imagepath+deleteFile);
		imageFile.delete();
		
		if (mul.getFile("bpicture") != null && !mul.getFile("bpicture").isEmpty()) {
		MultipartFile mf = mul.getFile("bpicture");
		String fname = mf.getOriginalFilename();
		mf.transferTo(new File(imagepath+"\\"+fname));
		ss.productreviewupdate(bnum,btitle,bcontent,fname,productrank);			
		}
		else {
			ss.productreviewupdate(bnum,btitle,bcontent,"0",productrank);
		}
		return "redirect:/myproductreview";
	}
		
		// 상품 리뷰 삭제
	@ResponseBody
	@RequestMapping(value = "/productReviewDelete", method = RequestMethod.GET)
	public String productReviewDelete(HttpServletRequest request,HttpServletResponse response) throws IOException {
		Service ss = sqlSession.getMapper(Service.class);
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id"); 
		int snum = Integer.parseInt(request.getParameter("snum"));
		int bnum = ss.selectBnum(id,snum);

		String deleteFile = ss.deleteFile(id,snum);
		File imageFile = new File(imagepath+deleteFile);
		imageFile.delete();
		
		ss.productReviewDelete(bnum);
		
		return "삭제완료";
	}
	// detailview.jsp ajax 수량 체크
	@ResponseBody
	@RequestMapping(value = "/stockcheck", method = RequestMethod.POST)
	public String stockcheck(HttpServletRequest request) {
		int snum =  Integer.parseInt(request.getParameter("snum"));
		String size = request.getParameter("size");
		Service ss = sqlSession.getMapper(Service.class);
		String result=ss.stockcheck(snum,size);;

		return result;
	}
	
	// 베스트 상품 화면 출력
	@RequestMapping(value = "/bestproductout")
	public String bestproductout(HttpServletRequest request, Model mo, PageDTO dto) {
		String nowPage=request.getParameter("nowPage");
	    String cntPerPage=request.getParameter("cntPerPage");
	    String sort =  request.getParameter("sort");
	    Service ss = sqlSession.getMapper(Service.class);
	    int besttotalSearch=ss.besttotalSearch();  
    
 
		 if(nowPage==null && cntPerPage == null) {
		    nowPage="1";
		    cntPerPage="10";
		 }
		 else if(nowPage==null) {
		    nowPage="1";
		 }
		 else if(cntPerPage==null) {
		    cntPerPage="10";
		 }      
		dto = new PageDTO(besttotalSearch,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
		
		if(sort == null || sort.equals("latest")) {
			 mo.addAttribute("list", ss.bestsearchout(dto.getStart(),dto.getEnd()));
			 mo.addAttribute("sort", "latest");
		}
		else if(sort.equals("highest")){
			 mo.addAttribute("list", ss.bestsearchoutlowest(dto.getStart(),dto.getEnd()));
			 mo.addAttribute("sort", "highest");
		}
		else if(sort.equals("lowest")){
			 mo.addAttribute("list", ss.bestsearchouthighest(dto.getStart(),dto.getEnd()));
			 mo.addAttribute("sort", "lowest");
		}
	
	    mo.addAttribute("paging",dto);
	    
	    return "bestproductout";
	}
	
	// 추천 상품 화면으로 가기
	@RequestMapping(value = "/recommendout")
	public String recommendout(HttpServletRequest request, Model mo) {
		
		return "recommendout";
	}
	
	// 추천 상품 화면, 기상청 단기예보 API에 데이터 보내기(https://www.data.go.kr/data/15084084/openapi.do?recommendDataYn=Y#/tab_layer_detail_function)
	@PostMapping("/bestproductoutweatherview")
    @ResponseBody
    public WeatherDTO getWeather(@RequestBody Map<String, String> coordinates, HttpServletRequest request) {
		WeatherDTO dto = new WeatherDTO();
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
        // 자바스크립트문에서 계산한 좌표값 가져옴
        String latitude = coordinates.getOrDefault("convertedLatitude","");
        String longitude = coordinates.getOrDefault("convertedLongitude","");
        
        // API 실행키
        String serviceKey = "YyEqjh8P0u6xMakFTsRYbV5DoxV57cDRQ8rf%2BUbTxrW9fxmGbEjiNcU%2Fh5U4UpQnGLdrNuFtDo7e1i5w1lK39A%3D%3D";
        
        // 오늘 날짜 지정
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        String baseDate = currentDate.format(formatter);
        
        // 단기예보 기준시간 설정(05시)
        String baseTime = "0500";
        
        // 좌표값 API에 보내는 변수에 맞게 nx,ny로 설정
        String nx = latitude;
        String ny = longitude;

        try {
            // API 호출을 위한 URL 생성 및 데이터 보내기
            String apiUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
                            + "?serviceKey=" + serviceKey
                            + "&numOfRows=400&pageNo=1"
                            + "&base_date=" + baseDate
                            + "&base_time=" + baseTime
                            + "&nx=" + nx
                            + "&ny=" + ny;

            // HTTP 연결 설정
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET"); // API 문서에 GET으로 보내달라고 해서 GET으로 설정

            // 응답 데이터 읽기
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            // 응답 데이터 출력
            dto.setId(id);
            String xmlResponse = response.toString();
            parseWeatherData(xmlResponse, dto); // 밑에 따로 함수를 만들어서 데이터 출력과정 진행
            conn.disconnect();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
	}
	
	// 추전 상품 화면, 기상청 단기예보 API에서 응답 받은 데이터로 화면 출력
	private void parseWeatherData(String xmlResponse, WeatherDTO dto) {
        try {
        	// 기상청 단기예보 API에서 받은 데이터는 xml 형태이므로 이것을 읽을 수 있게 처리하는 과정
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(xmlResponse)));
            //
            
            // 받은 데이터에서 필요한 정보 추출
            NodeList itemList = doc.getElementsByTagName("item");
            for (int i = 0; i < itemList.getLength(); i++) {
                Node itemNode = itemList.item(i);
                if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element itemElement = (Element) itemNode;
                    
                    // category = 데이터 자료구분 코드 -> category의 값이 TMN 이면 일 최저기온, TMX 면 일 최고기온 
                    String category = itemElement.getElementsByTagName("category").item(0).getTextContent();
                    String lowbaseDate = null, lowfcstTime = null, lowfcstValue = null;
                    String highbaseDate = null, highfcstTime = null, highfcstValue = null;
                    
                    
                    if (category.equals("TMN")) { // 일 최저 기온 출력
                        
                        lowbaseDate = itemElement.getElementsByTagName("baseDate").item(0).getTextContent(); // 예보 날짜(오늘 날짜)
                        lowfcstTime = itemElement.getElementsByTagName("fcstTime").item(0).getTextContent(); // 예보 시간(최저 기온 시간, 보통 06시)
                        lowfcstValue = itemElement.getElementsByTagName("fcstValue").item(0).getTextContent(); // 최저 온도 값
                        dto.setLowbaseDate(lowbaseDate);
                        dto.setLowfcstTime(lowfcstTime);
                        dto.setLowfcstValue(lowfcstValue);
                        
                    }
                    else if(category.equals("TMX")) // 일 최고 기온 출력
                    {
                    	
                    	highbaseDate = itemElement.getElementsByTagName("baseDate").item(0).getTextContent();
                    	highfcstTime = itemElement.getElementsByTagName("fcstTime").item(0).getTextContent();
                    	highfcstValue = itemElement.getElementsByTagName("fcstValue").item(0).getTextContent();
                        dto.setHighbaseDate(highbaseDate);
                        dto.setHighfcstTime(highfcstTime);
                        dto.setHighfcstValue(highfcstValue);
                        
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	
	// 추천 상품 화면, 계산된 평균 온도값으로 추천 상품 출력
	@PostMapping("/recommendsearch") 
    @ResponseBody
    public ArrayList<ProductDTO> recommendsearch(@RequestBody Map<String, String> coordinates, Model mo) {
		double avgTempDouble = Double.parseDouble(coordinates.getOrDefault("avgTemp", "0")); // 일 평균 온도
		int avgTemp = (int) avgTempDouble; // 정수로 전환
		
		// recommend DB 테이블에 저장된 값에 맞추기
		if(avgTemp<5)
		{
			avgTemp=0;
		}
		else if(avgTemp>=5 && avgTemp<15)
		{
			avgTemp=5;
		}
		else if(avgTemp>=15 && avgTemp<20)
		{
			avgTemp=15;
		}
		else if(avgTemp>=20 && avgTemp<100)
		{
			avgTemp=20;
		}
		
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<ProductDTO> list = ss.recommendsearch(avgTemp);
		
		return list;
	}
	
	// 상품 타입에 따른 출력
	@RequestMapping(value = "/product_list", method = RequestMethod.GET)
	   public String product_list(HttpServletRequest request, PageDTO dto, Model mo) {
	      String stype = request.getParameter("stype");
	      String nowPage=request.getParameter("nowPage");
	      String cntPerPage=request.getParameter("cntPerPage");
	      String sort =  request.getParameter("sort");
	      Service ss = sqlSession.getMapper(Service.class);
	      int totalSearch=ss.totalSearch(stype);  
       
       if(nowPage==null && cntPerPage == null) {
          nowPage="1";
          cntPerPage="10";
       }
       else if(nowPage==null) {
          nowPage="1";
       }
       else if(cntPerPage==null) {
          cntPerPage="10";
       }      
      dto = new PageDTO(totalSearch,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));

      if(sort == null || sort.equals("latest")) {
     	 mo.addAttribute("list", ss.searchout(stype,dto.getStart(),dto.getEnd()));
     	 mo.addAttribute("sort", "latest");
      }
      else if(sort.equals("highest")){
     	 mo.addAttribute("list", ss.searchoutlowest(stype,dto.getStart(),dto.getEnd()));
     	 mo.addAttribute("sort", "highest");
      }
      else if(sort.equals("lowest")){
     	 mo.addAttribute("list", ss.searchouthighest(stype,dto.getStart(),dto.getEnd()));
     	 mo.addAttribute("sort", "lowest");
      }
      
      mo.addAttribute("paging",dto);
      mo.addAttribute("stype",stype);
      
      return "product_list";
   }
	// 상품 타입에 따른 출력(자세히)
	@RequestMapping(value = "/product_subList", method = RequestMethod.GET)
	public String product_subList(HttpServletRequest request, PageDTO dto, Model mo) {
		String stype_sub = request.getParameter("stype_sub");
	    String nowPage=request.getParameter("nowPage");
	    String cntPerPage=request.getParameter("cntPerPage");
	    String sort =  request.getParameter("sort");
	    Service ss = sqlSession.getMapper(Service.class);
	    int totalSearch=ss.totalSubSearch(stype_sub);  

	    if(nowPage==null && cntPerPage == null) {
	       nowPage="1";
	       cntPerPage="10";
	    }
	    else if(nowPage==null) {
	       nowPage="1";
	    }
	    else if(cntPerPage==null) {
	       cntPerPage="10";
	    }      
	   dto = new PageDTO(totalSearch,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
	
	   if(sort == null || sort.equals("latest")) {
	  	 mo.addAttribute("list", ss.subsearchout(stype_sub,dto.getStart(),dto.getEnd()));
	  	 mo.addAttribute("sort", "latest");
	   }
	   else if(sort.equals("highest")){
	  	 mo.addAttribute("list", ss.subsearchoutlowest(stype_sub,dto.getStart(),dto.getEnd()));
	  	 mo.addAttribute("sort", "highest");
	   }
	   else if(sort.equals("lowest")){
	  	 mo.addAttribute("list", ss.subsearchouthighest(stype_sub,dto.getStart(),dto.getEnd()));
	  	 mo.addAttribute("sort", "lowest");
	   }
	   
       mo.addAttribute("paging",dto);
       mo.addAttribute("stype_sub",stype_sub);
       return "product_subList";
    }
	
	@RequestMapping(value = "/product_search", method = RequestMethod.GET)
	public String productSearch(HttpServletRequest request, PageDTO dto, Model mo) {
		String searchKey = request.getParameter("search_key");
		String searchValue = request.getParameter("search_value");
		
		if(searchKey.equals("전체") && searchValue.isEmpty()) {

			return "redirect:/productout";
		}
		else if(searchKey.equals("전체") && !searchValue.isEmpty()) {
			String nowPage=request.getParameter("nowPage");
			String cntPerPage=request.getParameter("cntPerPage");
			Service ss = sqlSession.getMapper(Service.class);
			
			int totalSearch=ss.totalValue(searchValue);
			
			if(nowPage==null && cntPerPage == null) {
				nowPage="1";
				cntPerPage="5";
			}
			else if(nowPage==null) {
				nowPage="1";
			}
			else if(cntPerPage==null) {
				cntPerPage="5";
			}      
			dto = new PageDTO(totalSearch,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
			mo.addAttribute("paging",dto);
			mo.addAttribute("list", ss.searchOutValue(searchValue,dto.getStart(),dto.getEnd()));
			mo.addAttribute("search_key", searchKey);
			mo.addAttribute("search_value", searchValue);
			return "product_searchout";			
		}
		else if(!searchKey.equals("전체") && searchValue.isEmpty()) {
			String nowPage=request.getParameter("nowPage");
			String cntPerPage=request.getParameter("cntPerPage");
			Service ss = sqlSession.getMapper(Service.class);
			
			int totalSearch=ss.totalKey(searchKey);
			if(nowPage==null && cntPerPage == null) {
				nowPage="1";
				cntPerPage="5";
			}
			else if(nowPage==null) {
				nowPage="1";
			}
			else if(cntPerPage==null) {
				cntPerPage="5";
			}      
			dto = new PageDTO(totalSearch,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
			mo.addAttribute("paging",dto);
			mo.addAttribute("list", ss.searchOutKey(searchKey,dto.getStart(),dto.getEnd()));
			mo.addAttribute("search_key", searchKey);
			mo.addAttribute("search_value", searchValue);
			return "product_searchout";			
		}
		else {
			String nowPage=request.getParameter("nowPage");
			String cntPerPage=request.getParameter("cntPerPage");
			Service ss = sqlSession.getMapper(Service.class);
			
			int totalSearch=ss.totalKeyValue(searchKey,searchValue);
			
			if(nowPage==null && cntPerPage == null) {
				nowPage="1";
				cntPerPage="5";
			}
			else if(nowPage==null) {
				nowPage="1";
			}
			else if(cntPerPage==null) {
				cntPerPage="5";
			}      
			dto = new PageDTO(totalSearch,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
			mo.addAttribute("paging",dto);
			mo.addAttribute("list", ss.searchOutKeyValue(searchKey,searchValue,dto.getStart(),dto.getEnd()));
			mo.addAttribute("search_key", searchKey);
			mo.addAttribute("search_value", searchValue);
			return "product_searchout";			
		}

	}
	
	// 주소지 목록 가져오기
	@RequestMapping(value = "/addressPopup",method = RequestMethod.GET)
	public String addressPopup(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<AddressListDTO> list = ss.addresslistout(id);
		
		mo.addAttribute("list", list);
		
		return "addressPopup";
	}	
	// 보유 쿠폰 가져오기
	@RequestMapping(value = "/couponPopup",method = RequestMethod.GET)
	public String couponPopup(HttpServletRequest request, Model mo) {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<CouponDTO> list = ss.couponlistout(id);
		
		mo.addAttribute("list", list);
		
		return "couponPopup";
	}		
	// 검색(상품명) 기능
	@RequestMapping(value = "/gnb_search", method = RequestMethod.GET)
	public String search_list(HttpServletRequest request, PageDTO dto, Model mo) {
	      String sname = request.getParameter("sname");
	      String nowPage=request.getParameter("nowPage");
	      String cntPerPage=request.getParameter("cntPerPage");
	      Service ss = sqlSession.getMapper(Service.class);
	        
	      int totalSearch=ss.totalValue(sname);
	     
	      if(nowPage==null && cntPerPage == null) {
	         nowPage="1";
	         cntPerPage="10";
	      }
	      else if(nowPage==null) {
	         nowPage="1";
	      }
	      else if(cntPerPage==null) {
	         cntPerPage="10";
	      }      
	       
	      dto = new PageDTO(totalSearch,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
	      
	      mo.addAttribute("paging",dto);
	      mo.addAttribute("list", ss.searchOutValue(sname,dto.getStart(),dto.getEnd()));
	      mo.addAttribute("sname",sname);
	      return "gnb_search";
	   }
	@RequestMapping(value = "/productReviewList")
	public String productReviewList(HttpServletRequest request, PageDTO dto, Model mo) {
	      String nowPage=request.getParameter("nowPage");
	      String cntPerPage=request.getParameter("cntPerPage");
	      Service ss = sqlSession.getMapper(Service.class);
	        
	      int total=ss.totalReview();
	     
	      if(nowPage==null && cntPerPage == null) {
	         nowPage="1";
	         cntPerPage="10";
	      }
	      else if(nowPage==null) {
	         nowPage="1";
	      }
	      else if(cntPerPage==null) {
	         cntPerPage="10";
	      }      
	       
	      dto = new PageDTO(total,Integer.parseInt(nowPage),Integer.parseInt(cntPerPage));
	      
	      mo.addAttribute("paging",dto);
	      mo.addAttribute("list", ss.productReviewOut(dto));
 
		      return "reviewList";
	   }
		
		
	@RequestMapping(value = "/detailReview")
	public String detailReview(HttpServletRequest request,Model model){
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		Service ss = sqlSession.getMapper(Service.class);
		
		ArrayList<ProductreviewDTO> list =  ss.detailReview(bnum);
		model.addAttribute("list", list);
		return "detailReview";
	}

		
	@ResponseBody
	@RequestMapping(value = "/bestreview", method = RequestMethod.POST)
	public String bestreview(HttpServletRequest request) {
		int bnum =  Integer.parseInt(request.getParameter("bnum"));
		
		Service ss = sqlSession.getMapper(Service.class);
		ss.bestreview(bnum);

		return "1";
	}
		
	@ResponseBody
	@RequestMapping(value = "/bestreviewout", method = RequestMethod.POST)
	public String bestreviewout(HttpServletRequest request) {
		int bnum =  Integer.parseInt(request.getParameter("bnum"));
		
		Service ss = sqlSession.getMapper(Service.class);
		ss.bestreviewout(bnum);

		return "1";
	}
		
	@ResponseBody
	@RequestMapping(value = "/takeReview")
	public void takeReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int bnum = Integer.parseInt(request.getParameter("bnum"));
		Service ss = sqlSession.getMapper(Service.class);
		ProductreviewDTO dto = ss.takeReview(bnum);
		JSONObject data = new JSONObject();
		    
		data.put("bpicture", dto.bpicture);
		data.put("sname", dto.sname);
		data.put("id", dto.id);    
		data.put("productrank", dto.productrank);    
		data.put("bdate", dto.bdate);    
		data.put("btitle", dto.btitle);    
		data.put("bcontent", dto.bcontent);    
		    
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(data.toString());
	} 
		
}
	
