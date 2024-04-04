package com.ezen.haha;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/")
	public String home() {
		
		return "woman2";
	}
	@RequestMapping(value = "/main")
	public String home2() {
		
		return "woman2";
	}
	@RequestMapping(value = "/woman")
	public String home3() {
		
		return "woman2";
	}
	@RequestMapping(value = "/kids")
	public String home4() {
		
		return "kids2";
	}
	
	
}
