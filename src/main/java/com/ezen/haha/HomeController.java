package com.ezen.haha;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.ezen.haha.product.ProductDTO;
import com.ezen.haha.product.ProductreviewDTO;
import com.ezen.haha.product.Service;


@Controller
public class HomeController {
	
	@Autowired
	SqlSession sqlSession; 
	
	@RequestMapping(value = "/")
	public String home(Model mo) {
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<ProductDTO> list = ss.bestViewNum();
		ArrayList<ProductreviewDTO> list2 = ss.bestReview();
		
		mo.addAttribute("list", list);
		mo.addAttribute("list2", list2);
		return "main";
	}
	@RequestMapping(value = "/main")
	public String home2(Model mo) {
		Service ss = sqlSession.getMapper(Service.class);
		ArrayList<ProductDTO> list = ss.bestViewNum();
		ArrayList<ProductreviewDTO> list2 = ss.bestReview();
		
		mo.addAttribute("list", list);
		mo.addAttribute("list2", list2);

		return "main";
	}

	
}
