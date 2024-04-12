package com.ezen.haha.qna;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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




@Controller
public class QnaController {
	@Autowired
	SqlSession sqlSession;
	
	private static final Logger logger = LoggerFactory.getLogger(QnaController.class);
	
	
	
	//고객센터 main
	@RequestMapping(value = "/qnahome")
	public String qna1() {
		
		return "qnahome";
	}
	
	//공지사항
	@RequestMapping(value = "/notice")
	public String qna2() {
		
		return "noticepage";
	}
	//공지사항 글쓰기 (관리자만 가능해야함)
	@RequestMapping(value = "/noticeinput")
	public String qna3() {
		
		return "noticeinputform";
	}
	
		
}
