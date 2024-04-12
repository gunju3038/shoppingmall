package com.ezen.haha.servicecenter;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
public class ServicecenterController {
	
	@Autowired
	SqlSession sqlSession;
	
	private static final Logger logger = LoggerFactory.getLogger(ServicecenterController.class);
	
	// 문의 게시판 글쓰기 화면으로 가기
	@RequestMapping(value = "/noticeboardwriting")
	public String noticeboardwriting() {
		
		return "noticeboardwriting";
	}
	
	
}
