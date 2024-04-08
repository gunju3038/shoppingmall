package com.ezen.haha.product;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ezen.haha.membership.MembershipDTO;


@Controller
public class ProductController {
	@Autowired
	SqlSession sqlSession;
	
	String imagepath = "C:\\이젠디지털12\\git\\shoppingmall\\src\\main\\webapp\\resources\\image\\";
	
	private static final Logger logger = LoggerFactory.getLogger(ProductController.class);
	
	// ���� ���� ��硫댁�쇰�
	@RequestMapping(value = "/productinput")
	public String productinput() {
		
		return "productinput";
	}
	
	// ���� ���� �� DB�� ����
	// 4.8수정
	@RequestMapping(value = "/productsave", method = RequestMethod.POST)
	public String productsave(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
		int snum = Integer.parseInt(mul.getParameter("snum"));
		String stype = mul.getParameter("stype");
		String color = mul.getParameter("color");
		String sname = mul.getParameter("sname");
		int su = Integer.parseInt(mul.getParameter("su"));
		int price = Integer.parseInt(mul.getParameter("price"));
		String ssize = mul.getParameter("ssize");
		String intro = mul.getParameter("intro");
		int best = Integer.parseInt(mul.getParameter("best"));
		String fname = "";

		List<MultipartFile> fileList = mul.getFiles("image");
		boolean firstfile = true;
        for (MultipartFile mf : fileList) {
             String originFileName = mf.getOriginalFilename(); // ��蹂� ���� 紐�
             
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
		ss.productinsert(snum,sname,stype,su,price,ssize,color,fname,intro,best);
		
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
		System.out.println(ss.productout(dto).get(0).ssize);
		
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
	@RequestMapping(value = "/deleteproduct")
	public String deleteproduct(HttpServletRequest request) {
		int snum = Integer.parseInt(request.getParameter("snum"));
		Service ss = sqlSession.getMapper(Service.class);
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
		int newsnum = Integer.parseInt(mul.getParameter("newsnum"));
		String sname = mul.getParameter("sname");
		String stype = mul.getParameter("stype");
		String color = mul.getParameter("color");
		int su = Integer.parseInt(mul.getParameter("su"));
		int price = Integer.parseInt(mul.getParameter("price"));
		String ssize = mul.getParameter("ssize");
		String intro = mul.getParameter("intro");
		int best = Integer.parseInt(mul.getParameter("best"));
		
		String image = mul.getParameter("image");
		String sideimage1 = mul.getParameter("sideimage1");
		String sideimage2 = mul.getParameter("sideimage2");
		String sideimage3 = mul.getParameter("sideimage3");
		
		Service ss = sqlSession.getMapper(Service.class);
		
		// �대�몄� ���곗�댄��, �대�� �대�몄��� ���� ���ν��怨� �대�� �대�몄��� ���� ������ 寃쎌�곌� ��湲곗�� if臾몄�쇰� �������� �����쇳����
		MultipartFile mf = mul.getFile("newimage");
		String fname = mf.getOriginalFilename();
		if(mf.getOriginalFilename().equals("")) // 硫��몄�대�몄� ���� ���μ�� ��吏� �����ㅻ㈃
		{
			ss.updateproductmainimage(newsnum,sname,stype,su,price,ssize,color,image,intro,best,snum); // 湲곗〈 �대�몄� ���곗�댄��
		}
		else
		{
			mf.transferTo(new File(imagepath+"\\"+fname));
			fname = mf.getOriginalFilename();
			ss.updateproductmainimage(newsnum,sname,stype,su,price,ssize,color,fname,intro,best,snum); // �� �대�몄� ���곗�댄��
		}
		
		MultipartFile mf1 = mul.getFile("newsideimage1");
		String fname1 = mf1.getOriginalFilename();
		if(mf1.getOriginalFilename().equals(""))
		{
			ss.updateproductsideimage1(sideimage1,snum);
		}
		else
		{
			mf1.transferTo(new File(imagepath+"\\"+fname1));
			fname1 = mf1.getOriginalFilename();
			ss.updateproductsideimage1(fname1,snum);
		}
				
		MultipartFile mf2 = mul.getFile("newsideimage2");
		String fname2 = mf2.getOriginalFilename();
		if(mf2.getOriginalFilename().equals(""))
		{
			ss.updateproductsideimage2(sideimage2,snum);
		}
		else
		{
			mf2.transferTo(new File(imagepath+"\\"+fname2));
			fname2 = mf2.getOriginalFilename();
			ss.updateproductsideimage1(fname2,snum);
		}
		
		MultipartFile mf3 = mul.getFile("newsideimage3");
		String fname3 = mf3.getOriginalFilename();
		if(mf3.getOriginalFilename().equals(""))
		{
			ss.updateproductsideimage3(sideimage3,snum);
		}
		else
		{
			mf3.transferTo(new File(imagepath+"\\"+fname3));
			fname3 = mf3.getOriginalFilename();
			ss.updateproductsideimage3(fname3,snum);
		}

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
			// ���� 援ъ�� �� ���� 援ъ�� 紐⑸��� ���ν���� DB瑜� ���� �곕� 留��ㅼ�� 泥댄�ы�댁�쇳��
			// 吏�湲��� ���� 由щ럭 DB(productreview)���� ��泥� 泥댄�� 
			Service ss = sqlSession.getMapper(Service.class);
			Integer productbuy = ss.productbuysearch(id,snum);
			if(productbuy == null || productbuy != 1)
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
	// ���� 泥댄��
	@ResponseBody
	@RequestMapping(value = "/check", method = RequestMethod.POST)
	public String stockcheck(HttpServletRequest request) {
		int snum =  Integer.parseInt(request.getParameter("snum"));
		String ssize = request.getParameter("ssize");
		
		Service ss = sqlSession.getMapper(Service.class);

		return ss.stockcheck(snum,ssize);
	}
	
	
	
	
}
