package com.ezen.haha.product;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
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

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


@Controller
public class ProductController {
	@Autowired
	SqlSession sqlSession;
	
	String imagepath = "C:\\이젠디지털12\\spring\\shoppingmall-master\\src\\main\\webapp\\resources\\image\\";
	
	private static final Logger logger = LoggerFactory.getLogger(ProductController.class);
	
	// ���� ���� ��硫댁�쇰�
	@RequestMapping(value = "/productinput")
	public String productinput() {
		
		return "productinput";
	}
	
	// ���� ���� �� DB�� ����
	@RequestMapping(value = "/productsave", method = RequestMethod.POST)
	public String productsave(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		int snum = Integer.parseInt(mul.getParameter("snum"));
		String stype = mul.getParameter("stype");
		String stype_sub = mul.getParameter("stype_sub");
		String color = mul.getParameter("color");
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
             String originFileName = mf.getOriginalFilename(); // 占쏙옙癰�占� 占쏙옙占쏙옙 筌�占�
             
             if(firstfile) {
            	 fname = originFileName;
            	 firstfile = false;
             }
             else {
            	 fname = fname + ", " +originFileName;
             }
             System.out.println("originFileName : " + originFileName);
             String safeFile = imagepath + originFileName;
             mf.transferTo(new File(safeFile));
         }
        System.out.println("fname : " + fname);
		Service ss = sqlSession.getMapper(Service.class);
		ss.productinsert(snum,sname,stype,stype_sub,price,ssize,msize,lsize,xlsize,color,fname,intro,best,recommend);
		
		return "redirect:/main";
	}

	// DB �곗�댄�� 媛��몄�� �� 異��� ��硫댁�쇰� 媛�湲�
	@RequestMapping(value = "/productout")
	public String productout(HttpServletRequest request, PageDTO dto, Model mo) {
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
		
		mo.addAttribute("paging",dto);
		mo.addAttribute("list", ss.productout(dto));
		
		
		return "productout";
	}
	
	// ���� �대┃ �� ���� �댁�� ��硫댁�쇰� 媛�湲�
	@RequestMapping(value = "/detailview")
	public String detailview(HttpServletRequest request, Model mo) {
		int snum = Integer.parseInt(request.getParameter("snum"));
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<ProductDTO> list = ss.detailview(snum);
		mo.addAttribute("list", list);
		
		// ���� 由щ럭 異��� 異�媛�
		ArrayList<ProductreviewDTO> list1 = ss.productreviewout(snum);
		mo.addAttribute("list1", list1);
		return "detailview";
	}
	
	// ���� �댁�� 李쎌���� �λ�援щ�� DB ����
	@RequestMapping(value = "/basket")
	public String basket(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		// 濡�洹몄�� �� id 媛��몄�ㅺ린
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null) // 濡�洹몄�� 泥댄��
		{
			Service ss = sqlSession.getMapper(Service.class);
			String sname = request.getParameter("sname");
			String color = request.getParameter("color");
			Integer snum = ss.colorsnumsearch(sname,color); // ������ 留��� ������ ����肄��� 媛��몄�ㅺ린
			
			if(snum!=null) // ������ 留��� ������ ����吏� 泥댄��(�ъ�⑹���� �대��誘� 異��� ��硫댁�� ������ ���� �댁�� ��硫댁���� ������ ������怨� ���닿�湲� ��臾몄�� �곕� 泥댄�ы�댁�쇳��)
			{
				String stype = request.getParameter("stype");
				int guestbuysu = Integer.parseInt(request.getParameter("guestbuysu"));
				int su = Integer.parseInt(request.getParameter("su"));
				int price = Integer.parseInt(request.getParameter("price"));
				int totprice = Integer.parseInt(request.getParameter("totprice"));
				
				String ssize = request.getParameter("ssize");
				String image = request.getParameter("image");
				
				int jaegocheck = ss.jaegocheck(snum,ssize,color,guestbuysu); // ���� 議댁�� ��臾� 諛� �ш� 泥댄��
				int snumcheck = ss.snumcheck(snum,ssize,color); // �λ�援щ�� 以�蹂� 泥댄��
				
				if(jaegocheck!=0) // ���� �ш� 泥댄��
				{
					if(snumcheck==0) // �λ�援щ�� 以�蹂� 泥댄��
					{
						ss.basketinsert(id,snum,sname,stype,guestbuysu,price,totprice,ssize,image,color);
						return "redirect:/basketout";
					}
					else
					{
						response.setContentType("text/html;charset=utf-8");
						PrintWriter printw = response.getWriter();
						printw.print("<script> alert('以�蹂듬�� ������ �λ�援щ���� ���듬����.'); window.location.href='./basketout'; </script>");
						printw.close();
						return null;
					}
				}
				else
				{
					response.setContentType("text/html;charset=utf-8");
					PrintWriter printw = response.getWriter();
					printw.print("<script> alert('�대�� ������ �ш�媛� ���듬����.'); window.history.back(); </script>");
					printw.close();
					return null;
				}
			}
			else
			{
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script> alert('�대�� ������ ������ 議댁�ы��吏� ���듬����.'); window.history.back(); </script>");
				printw.close();
				return null;
			}
			
		}
		else
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('濡�洹몄�몄�� �����⑸����.'); window.location.href='./login'; </script>");
			printw.close();
			return "redirect:./login";
		}
		
	}
	
	// DB ���ν�� �λ�援щ�� 異���
	@RequestMapping(value = "/basketout")
	public String basketout(HttpServletRequest request, PageDTO dto, Model mo, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null) {
			String nowPage=request.getParameter("nowPage");
	        String cntPerPage=request.getParameter("cntPerPage");
	        
	        Service ss = sqlSession.getMapper(Service.class);

	        int total=ss.totalbasket(id);
	    
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
	       
	        dto = new PageDTO(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));
	        
	        mo.addAttribute("paging",dto);
			mo.addAttribute("list", ss.basketout(id,dto.getStart(),dto.getEnd()));
			
			return "basketout";
		}
		else
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('濡�洹몄�몄�� �����⑸����.'); window.location.href='./login'; </script>");
			printw.close();
			return "redirect:./login";
		}
		
	}
	
	// �λ�援щ������ 泥댄�щ��� ���� �� 援щℓ���� ��硫댁�쇰� �대��
	@RequestMapping(value = "/basketsell", method = RequestMethod.POST)
	public String basketsell(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		Service ss = sqlSession.getMapper(Service.class);
		ss.deleteproductsell(); // 援щℓ 李쎌�� ��瑜� ��留��� DB�� �닿릿 二쇰Ц ��蹂� 珥�湲고��(delete), ����硫� �댁�� 二쇰Ц��蹂대�� ��遺� 遺��ъ��, ��以��� 吏�湲�源�吏� 援щℓ���� 援щℓ紐⑸��� 蹂닿� �띕�ㅻ㈃ 珥�湲고�� ���� �ㅻⅨ DB���대��� �곕� 留��ㅼ�댁�� ���ν��嫄곕�� �ㅻⅨ 諛⑸��� 李얠���� �� 寃� 媛���
		
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null) // 濡�洹몄�� 以��대�쇰㈃
		{
			String [] items = request.getParameterValues("item"); // 泥댄�щ��ㅻ� ������ 紐⑸� 踰��몃�� 媛��몄��
			String [] reguestbuysu = request.getParameterValues("guestbuysu"); // �λ�援щ������ ������ ������ 媛��몄��
			String [] retotprice = request.getParameterValues("totprice"); // �λ�援щ������ ������ 珥� 媛�寃⑹�� 媛��몄��
			int [] basketnum = null;
			int [] guestbuysu = null;
			int [] totprice = null;
			
			if(items != null)
			{
				basketnum = new int[items.length]; // basketnum 諛곗�� 珥�湲고��, ����硫� ���ъ�명�� ���ш� �щ��.
				guestbuysu = new int[reguestbuysu.length];
		        totprice = new int[retotprice.length];
		        
				for(int i=0; i<items.length; i++)
				{
					basketnum[i] = Integer.parseInt(items[i]); // int �����쇰� ����
					guestbuysu[i] = Integer.parseInt(reguestbuysu[i]);
					totprice[i] = Integer.parseInt(retotprice[i]);
				}
			}
			
			ArrayList<BasketDTO> list = new ArrayList<>(); 
			for (int i = 0; i < basketnum.length; i++) {
				ss.updatebasket(guestbuysu[i],totprice[i],basketnum[i]);// �λ�援щ������ ������ ����, 珥� 媛�寃� ���곗�댄��
			    list.add(ss.basketsell(basketnum[i]));
			}
			
			mo.addAttribute("list", list);
			
			return "basketsellout";
		}
		else
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('濡�洹몄�몄�� �����⑸����.'); window.location.href='./login'; </script>");
			printw.close();
			return "redirect:./login";
		}
	
	}
	
	// ���� �댁�� ��硫댁���� 利��� 援щℓ �대┃ �� 援щℓ���� ��硫댁�쇰� �대��
	@RequestMapping(value = "/productsell", method = RequestMethod.POST)
	public String productsell(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		Service ss = sqlSession.getMapper(Service.class);
		ss.deleteproductsell(); // 援щℓ 李쎌�� ��瑜� ��留��� DB�� �닿릿 二쇰Ц ��蹂� 珥�湲고��(delete), ����硫� �댁�� 二쇰Ц��蹂대�� ��遺� 遺��ъ��, ��以��� 吏�湲�源�吏� 援щℓ���� 援щℓ紐⑸��� 蹂닿� �띕�ㅻ㈃ 珥�湲고�� ���� �ㅻⅨ DB���대��� �곕� 留��ㅼ�댁�� ���ν��嫄곕�� �ㅻⅨ 諛⑸��� 李얠���� �� 寃� 媛���
			
		String image = request.getParameter("image");
		int snum = Integer.parseInt(request.getParameter("snum"));
		String sname = request.getParameter("sname");
		String ssize = request.getParameter("ssize");
		String color = request.getParameter("color");
		int guestbuysu = Integer.parseInt(request.getParameter("guestbuysu"));
		int totprice = Integer.parseInt(request.getParameter("totprice"));
		String stype = request.getParameter("stype");
		
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id"); // 濡�洹몄�� 以��� �� id 媛��� 媛��몄��
		
		int jaegocheck = ss.jaegocheck(snum,ssize,color,guestbuysu); // ���� 議댁�� ��臾� 諛� �ш� 泥댄��
		if(jaegocheck!=0) // ���� �ш� 泥댄��
		{
			if(id != null) // 濡�洹몄�� ��臾� 泥댄��
			{
				ArrayList<MembershipDTO> IDlist = ss.IDinformation(id); // 援щℓ �� ��蹂� ���μ�� ���� ���� ��蹂대�� 媛��몄��
				MembershipDTO dto = IDlist.get(0); // IDlist�� 湲곕��� 泥ル�吏� 媛��� 遺��ъ��
				String name = dto.getName();
				String tel = dto.getTel();
				String email = dto.getEmail();
				String address = dto.getAddress();
				
				// 媛��� ��蹂댁�� 援щℓ ��蹂대�� DB ���대�(Productsell)�� ����
				ss.Productsellinsert(id,name,tel,email,address,image,snum,sname,ssize,guestbuysu,totprice,stype,color);
				ArrayList<ProductSellDTO> pslist = ss.productsellout();
				mo.addAttribute("list", pslist);
				
				return "productsellout";
			}
			else
			{
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script> alert('濡�洹몄�몄�� �����⑸����.'); window.location.href='./login'; </script>");
				printw.close();
				return "redirect:./login";
			}
		}
		else
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('�대�� ������ �ш�媛� ���듬����.'); window.history.back(); </script>");
			printw.close();
			return null;
		}
			
	}
	
	// �λ�援щ�� 紐⑸� ���� �� ����
	@RequestMapping(value = "/basketdelete")
	public String basketdelete(HttpServletRequest request) {
		String [] items = request.getParameterValues("item"); // 泥댄�щ��ㅻ� ������ 紐⑸� 踰��몃�� 媛��몄��
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
	
	// ���� �댁�� ��硫댁���� ���� ������湲�
	@RequestMapping(value = "/deleteProduct")
	public String deleteproduct(HttpServletRequest request) {
		int snum = Integer.parseInt(request.getParameter("snum"));
		Service ss = sqlSession.getMapper(Service.class);
		String files = ss.selectFile(snum);
		
		String[] imageFiles = files.split(", "); 
		for(String image : imageFiles) {
			File imageFile = new File(imagepath+image);
			imageFile.delete();
		}
		
		ss.deleteproduct(snum);
		
		return "redirect:/productout";
	}
	
	// ���� �댁�� ��硫댁���� ���� ���� ��硫댁�쇰� 媛�湲�
	@RequestMapping(value = "/updateproductview")
	public String updateproductview(HttpServletRequest request, Model mo) {
		int snum = Integer.parseInt(request.getParameter("snum"));
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<ProductDTO> list = ss.updateproductview(snum);
		mo.addAttribute("list", list);
		
		return "updateproductview";
	}	
		
	// ���� ���� ��硫댁���� 諛��� �곗�댄�곕� ���� ��蹂� ������湲�
	@RequestMapping(value = "/updateproduct", method = RequestMethod.POST)
	public String updateproduct(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {		
		int snum = Integer.parseInt(mul.getParameter("snum"));
		String stype = mul.getParameter("stype");
		String stype_sub = mul.getParameter("stype_sub");
		String color = mul.getParameter("color");
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
             String originFileName = mf.getOriginalFilename(); // 占쏙옙癰�占� 占쏙옙占쏙옙 筌�占�
             
             if(firstfile) {
            	 fname = originFileName;
            	 firstfile = false;
             }
             else {
            	 fname = fname + ", " +originFileName;
             }
             System.out.println("originFileName : " + originFileName);
             String safeFile = imagepath + originFileName;
             mf.transferTo(new File(safeFile));
         }
        System.out.println("fname : " + fname);
		Service ss = sqlSession.getMapper(Service.class);
		ss.productupdate(snum,sname,stype,stype_sub,price,ssize,msize,lsize,xlsize,color,fname,intro,best,recommend);
		
		return "redirect:/productout";
	}

	// 援щℓ李� 二쇱�� ���� ��硫댁�쇰�
	@RequestMapping(value = "/updateaddress")
	public String updateaddress() {
		
		return "updateaddress";
	}
	
	// 援щℓ李� �대� ���� ��硫댁�쇰�
	@RequestMapping(value = "/updatename")
	public String updatename() {
		
		return "updatename";
	}
	
	// 援щℓ李� �곕�쎌� ���� ��硫댁�쇰�
	@RequestMapping(value = "/updatetel")
	public String updatetel() {
		
		return "updatetel";
	}
	// 援щℓ李� �대��� ���� ��硫댁�쇰�
	@RequestMapping(value = "/updateemail")
	public String updateemail() {
		
		return "updateemail";
	}
	
	// ���� 由щ럭 ���� ��硫댁�쇰�
	@RequestMapping(value = "/productreviewinput")
	public String productreviewinput(HttpServletRequest request, Model mo, HttpServletResponse response) throws IOException {
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
		if(id != null) // 濡�洹몄�� ��臾� 泥댄��
		{
			int snum = Integer.parseInt(request.getParameter("snum"));
			
			// 由щ럭 �곌린 �� �대�� ������ 援ъ������吏� 泥댄��			
			Service ss = sqlSession.getMapper(Service.class);
			Integer buysnum = ss.productbuysearch(id,snum);
			
			if(buysnum == null)
			{
				response.setContentType("text/html;charset=utf-8");
				PrintWriter printw = response.getWriter();
				printw.print("<script> alert('���� 援ъ�� 湲곕��� ���듬����.'); window.history.back(); </script>");
				printw.close();
				return null;
				
			}
			else
			{
				mo.addAttribute("snum", snum);
				return "productreviewinput";
			}
			
		}
		else
		{
			response.setContentType("text/html;charset=utf-8");
			PrintWriter printw = response.getWriter();
			printw.print("<script> alert('濡�洹몄�몄�� �����⑸����.'); window.location.href='./login'; </script>");
			printw.close();
			return "redirect:./login";
		}
		
	}
	
	// ���� 由щ럭 ���� �� DB�� ����
	@RequestMapping(value = "/productreviewsave", method = RequestMethod.POST)
	public String productreviewsave(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		HttpSession hs = mul.getSession();
		String id = (String) hs.getAttribute("id"); 
		String btitle = mul.getParameter("btitle");
		int snum = Integer.parseInt(mul.getParameter("snum"));
		String bcontent = mul.getParameter("bcontent");
		int productrank = Integer.parseInt(mul.getParameter("productrank"));
		
		MultipartFile mf = mul.getFile("bpicture");
		String fname = mf.getOriginalFilename();
		mf.transferTo(new File(imagepath+"\\"+fname));
		
		Service ss = sqlSession.getMapper(Service.class);
		ss.productreviewsave(snum,id,btitle,bcontent,fname,productrank);
		
		return "redirect:/productout";
	}
	// detailview.jsp ajax ���� 泥댄��
	@ResponseBody
	@RequestMapping(value = "/stockcheck", method = RequestMethod.POST)
	public String stockcheck(HttpServletRequest request) {
		int snum =  Integer.parseInt(request.getParameter("snum"));
		String size = request.getParameter("size");
		Service ss = sqlSession.getMapper(Service.class);
		String result="";
		if(size.equals("S")) {
			result = ss.stockcheck(snum,"ssize");
		}
		else if(size.equals("M")) {
			result = ss.stockcheck(snum,"msize");
		}
		else if(size.equals("L")) {
			result = ss.stockcheck(snum,"lsize");
		}
		else {
			result = ss.stockcheck(snum,"xlsize");
		}
		
		return result;
	}
	
	// 踰��ㅽ�� ���� ��硫� 異���
	@RequestMapping(value = "/bestproductout")
	public String bestproductout(HttpServletRequest request, Model mo) {
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<ProductDTO> list = ss.bestproductout();
		mo.addAttribute("list", list);
		
		return "bestproductout";
	}
	
	// 異�泥� ���� ��硫댁�쇰� 媛�湲�
	@RequestMapping(value = "/recommendout")
	public String recommendout(HttpServletRequest request, Model mo) {
		
		return "recommendout";
	}
	
	// 異�泥� ���� ��硫�, 湲곗��泥� �④린��蹂� API�� �곗�댄�� 蹂대�닿린(https://www.data.go.kr/data/15084084/openapi.do?recommendDataYn=Y#/tab_layer_detail_function)
	@PostMapping("/bestproductoutweatherview")
    @ResponseBody
    public WeatherDTO getWeather(@RequestBody Map<String, String> coordinates, HttpServletRequest request) {
		WeatherDTO dto = new WeatherDTO();
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		
        // ��諛��ㅽ�щ┰�몃Ц���� 怨��고�� 醫���媛� 媛��몄��
        String latitude = coordinates.getOrDefault("convertedLatitude","");
        String longitude = coordinates.getOrDefault("convertedLongitude","");
        
        // API �ㅽ����
        String serviceKey = "YyEqjh8P0u6xMakFTsRYbV5DoxV57cDRQ8rf%2BUbTxrW9fxmGbEjiNcU%2Fh5U4UpQnGLdrNuFtDo7e1i5w1lK39A%3D%3D";
        
        // �ㅻ�� ��吏� 吏���
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        String baseDate = currentDate.format(formatter);
        
        // �④린��蹂� 湲곗���媛� �ㅼ��(05��)
        String baseTime = "0500";
        
        // 醫���媛� API�� 蹂대�대�� 蹂����� 留�寃� nx,ny濡� �ㅼ��
        String nx = latitude;
        String ny = longitude;

        try {
            // API �몄��� ���� URL ���� 諛� �곗�댄�� 蹂대�닿린
            String apiUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
                            + "?serviceKey=" + serviceKey
                            + "&numOfRows=400&pageNo=1"
                            + "&base_date=" + baseDate
                            + "&base_time=" + baseTime
                            + "&nx=" + nx
                            + "&ny=" + ny;

            // HTTP �곌껐 �ㅼ��
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET"); // API 臾몄���� GET�쇰� 蹂대�대�щ�쇨� �댁�� GET�쇰� �ㅼ��

            // ���� �곗�댄�� �쎄린
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            // ���� �곗�댄�� 異���
            dto.setId(id);
            String xmlResponse = response.toString();
            parseWeatherData(xmlResponse, dto); // 諛��� �곕� �⑥��瑜� 留��ㅼ�댁�� �곗�댄�� 異��κ낵�� 吏���
            conn.disconnect();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
	}
	
	// 異��� ���� ��硫�, 湲곗��泥� �④린��蹂� API���� ���� 諛��� �곗�댄�곕� ��硫� 異���
	private void parseWeatherData(String xmlResponse, WeatherDTO dto) {
		
        try {
        	// 湲곗��泥� �④린��蹂� API���� 諛��� �곗�댄�곕�� xml �����대��濡� �닿��� �쎌�� �� ��寃� 泥�由ы���� 怨쇱��
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(xmlResponse)));
            //
            
            // 諛��� �곗�댄�곗���� ������ ��蹂� 異�異�
            NodeList itemList = doc.getElementsByTagName("item");
            for (int i = 0; i < itemList.getLength(); i++) {
                Node itemNode = itemList.item(i);
                if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element itemElement = (Element) itemNode;
                    
                    // category = �곗�댄�� ��猷�援щ� 肄��� -> category�� 媛��� TMN �대㈃ �� 理���湲곗��, TMX 硫� �� 理�怨�湲곗�� 
                    String category = itemElement.getElementsByTagName("category").item(0).getTextContent();
                    String lowbaseDate = null, lowfcstTime = null, lowfcstValue = null;
                    String highbaseDate = null, highfcstTime = null, highfcstValue = null;
                    
                    
                    if (category.equals("TMN")) { // �� 理��� 湲곗�� 異���
                        
                        lowbaseDate = itemElement.getElementsByTagName("baseDate").item(0).getTextContent(); // ��蹂� ��吏�(�ㅻ�� ��吏�)
                        lowfcstTime = itemElement.getElementsByTagName("fcstTime").item(0).getTextContent(); // ��蹂� ��媛�(理��� 湲곗�� ��媛�, 蹂댄�� 06��)
                        lowfcstValue = itemElement.getElementsByTagName("fcstValue").item(0).getTextContent(); // 理��� �⑤�� 媛�
                        dto.setLowbaseDate(lowbaseDate);
                        dto.setLowfcstTime(lowfcstTime);
                        dto.setLowfcstValue(lowfcstValue);
                        
                    }
                    else if(category.equals("TMX")) // �� 理�怨� 湲곗�� 異���
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
	
	// 異�泥� ���� ��硫�, 怨��곕�� ��洹� �⑤��媛��쇰� 異�泥� ���� 異���
	@PostMapping("/recommendsearch")
    @ResponseBody
    public ArrayList<ProductDTO> recommendsearch(@RequestBody Map<String, String> coordinates, Model mo) {
		String avgTemp = coordinates.getOrDefault("avgTemp","");
		
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<ProductDTO> list = ss.recommendsearch(avgTemp);
		
		return list;
	}
	
	// ���� ������ �곕Ⅸ 異���
	@RequestMapping(value = "/product_list", method = RequestMethod.GET)
	   public String product_list(HttpServletRequest request, PageDTO dto, Model mo) {
	      String stype = request.getParameter("stype");
	      String nowPage=request.getParameter("nowPage");
	        String cntPerPage=request.getParameter("cntPerPage");
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
	      
	      mo.addAttribute("paging",dto);
	      mo.addAttribute("list", ss.searchout(stype,dto.getStart(),dto.getEnd()));
	      mo.addAttribute("stype",stype);
	      return "product_list";
	      
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
	
}
	
