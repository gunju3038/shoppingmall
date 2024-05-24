package com.ezen.haha.pay;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.ezen.haha.product.BasketDTO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class PayController {
	
	@Autowired
	SqlSession sqlSession;
	
	PayDTO dto = new PayDTO();
	// 카카오페이 단건결재 API를 통한 결재 진행(https://developers.kakaopay.com/docs/payment/online/single-payment)
	// 카카오페이 단건결재를 하기 위해선 크게 두가지 과정이 있다.(결재 요청 -> 결재 승인 요청)    
	// 결재 요청
    @PostMapping("/payready") // 데이터값 POST 지정, 카카오 서버는 POST 자료만 받는다고 명시되어 있음
    public ResponseEntity<String> createPayment(HttpServletRequest request, @RequestBody Map<String, String> formData) throws UnsupportedEncodingException {
    	
    	HttpSession hs = request.getSession();
    	Service ss = sqlSession.getMapper(Service.class);
		String id = (String) hs.getAttribute("id");
		String address = formData.getOrDefault("address", "");
		String name = formData.getOrDefault("name", "");
		String tel = formData.getOrDefault("tel", "");
		String drequest = formData.getOrDefault("request", "");
		String sname = formData.getOrDefault("sname", "");
		String basketnum = formData.getOrDefault("basketnum", "");
		String usepoint = formData.getOrDefault("usepoint", "");
		String savepoint = formData.getOrDefault("savepoint", "");
		String usecoupon = formData.getOrDefault("usecoupon", "");
		int guestbuysu = Integer.parseInt(formData.getOrDefault("guestbuysu", ""));
		String email = ss.email(id);
		
		
		String snum =formData.getOrDefault("snum", "");
		
		String stringTotprice =formData.getOrDefault("totprice", "");
		stringTotprice = stringTotprice.replace(",", "");
		int totprice = Integer.parseInt(stringTotprice); 
		PayDTO paydto = new PayDTO();
		
		paydto.setId(id);
		ss.insertorderid(paydto);
		
		String orderid = String.valueOf(paydto.orderid);
		
        String SECRET_KEY = "DEVEFDEE8BC156E700548072473187B892DAC623"; // 시크릿(secret_key(dev)) 키(테스트용 키)
        String auth = "SECRET_KEY " + SECRET_KEY; // 앞에 "SECRET_KEY " 를 써줘야 카카오 서버가 시크릿 키를 인식함
        
        ObjectMapper objectMapper = new ObjectMapper();
        
        String apiUrl = "https://open-api.kakaopay.com/online/v1/payment/ready"; // 카카오 단건결재 결재 '요청' 링크

        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type","application/json"); // 본문 형식을 JSON 으로 변경, 안하면 카카오 서버가 인식을 못한다.(API 문서에도 명시되어 있음)
        headers.set("Authorization", auth); // 카카오 서버 시크릿 키 인증 틀
        
        Map<String, Object> requestBodyMap = new LinkedHashMap<>();
        // 아래는 카카오 결재 API 가 결재 요청에 요구하는 필수 데이터들, 아래 이외의 데이터도 추가해서 넣을 수 있다.(API 문서 참조)
        requestBodyMap.put("cid", "TC0ONETIME"); // 가맹점 id(String), 테스트 아이디 "TC0ONETIME" 입력
        requestBodyMap.put("partner_order_id", orderid); // 가맹점 주문번호(String)
        requestBodyMap.put("partner_user_id", id); // 가맹점 회원 id(String)
        requestBodyMap.put("item_name", sname); // 상품명(String)
        requestBodyMap.put("quantity", guestbuysu); // 상품 개수(int)
        requestBodyMap.put("total_amount", totprice); // 상품 총 금액(int)
        requestBodyMap.put("tax_free_amount", 0); // 상품 비과세 금액(int)
        requestBodyMap.put("approval_url", "http://localhost:8686/haha/success"); // 결재 성공 시 리다이렉트 링크(String)
        requestBodyMap.put("fail_url", "http://localhost:8686/haha/fail"); // 결재 실패 시 리다이렉트 링크(String)
        requestBodyMap.put("cancel_url", "http://localhost:8686/haha/cancel"); // 결재 취소 시 리다이렉트 링크(String)
        
        
        String requestBody;
        try {
            requestBody = objectMapper.writeValueAsString(requestBodyMap); // 카카오 서버에 json 형식으로 보내줘야 하기에 타입을 변경
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("JSON 변환에 실패했습니다.");
        }
        
        HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers); // 위에 쓴 정보들을 가지고 카카오 서버에 요청
        
        RestTemplate restTemplate = new RestTemplate(); // 카카오 서버에 요청하고 그 결과물을 받기 위한 코드
        // 한글 인코딩, 안하면 카카오 결재창에서 상품명이 ?로 뜬다.
        List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();
        StringHttpMessageConverter stringHttpMessageConverter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
        stringHttpMessageConverter.setWriteAcceptCharset(false);
        messageConverters.add(stringHttpMessageConverter);
        restTemplate.setMessageConverters(messageConverters);
        // 한글 인코딩 end
        
     // 이 중간에 QR 코드가 뜨고 클라이언트가 결재 과정을 진행한다.(카카오 서버에서 직접 처리하는 과정이라 관여할 부분은 없음)
        
        ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, requestEntity, String.class); // 받은 자료들을 response에 저장

        if (response.getStatusCode().is2xxSuccessful()) { // response가 true 라면 아래 실행
            // 받은 JSON 응답을 객체로 매핑하여 출력
            try {
                JsonNode root = objectMapper.readTree(response.getBody()); // 카카오 서버에서 받은 자료들을 JSON 문자열(JsonNode)로 변경
                String tid = root.get("tid").asText(); // 결재 고유 번호, 카카오 서버에서 자체 생성된 번호이며 결재 승인 요청에서 사용
                String nextRedirectAppUrl = root.get("next_redirect_app_url").asText(); // 요청한 클라이언트(Client)가 모바일 앱일 경우 -> 카카오톡 결제 페이지 Redirect URL
                String nextRedirectMobileUrl = root.get("next_redirect_mobile_url").asText(); // 요청한 클라이언트가 모바일 웹일 경우
                String nextRedirectPcUrl = root.get("next_redirect_pc_url").asText(); // 요청한 클라이언트가 PC 웹일 경우
                String androidAppScheme = root.get("android_app_scheme").asText(); // 카카오페이 결제 화면으로 이동하는 Android 앱 스킴(Scheme) - 내부 서비스용
                String iosAppScheme = root.get("ios_app_scheme").asText(); // 카카오페이 결제 화면으로 이동하는 iOS 앱 스킴 - 내부 서비스용
                String createdAt = root.get("created_at").asText(); // 결제 준비 요청 시간
                
             // 결재 승인 요청에서 사용할 정보를 DTO에 저장
                dto.setTid(tid); 
                dto.setOrderid(paydto.orderid);
                dto.setSnum(snum);
                dto.setPartner_user_id(id);
                dto.setTotal_amount(totprice);
                dto.setAddress(address);
                dto.setName(name);
                dto.setTel(tel);
                dto.setEmail(email);
                dto.setDrequest(drequest);
                dto.setBasketnum(basketnum);
                dto.setUsecoupon(usecoupon);
                dto.setUsepoint(usepoint);
                dto.setSavepoint(savepoint);
                
                
                return ResponseEntity.ok(nextRedirectPcUrl); // PC에서 결재를 진행할 것이기에 nextRedirectPcUrl 링크 사용
            } catch (JsonProcessingException e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("JSON 파싱에 실패했습니다.");
            }
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("결제 생성에 실패했습니다.");
        }
    }
    
    
    
    // 결재 승인 요청
    @GetMapping("/success")
    public ModelAndView payapprove(@RequestParam("pg_token") String pgToken) throws IOException {
    	// 결재 요청 이후 클라이언트가 결재를 진행하고 성공하면 카카오 서버에서 /success?pg_token= 형식의 pg_token 을 리다이렉트로 보내준다.
    	// 그 /success?pg_token= 리다이렉트를 맵핑(/success)으로 받고 @RequestParam("pg_token") 을 사용하여 토큰 정보를 따로 받아준다.
    	// 이후 pg_token과 tid 및 요구 필수 데이터	들을 카카오 서버에 보내어 최종적으로 결재 승인 요청을 진행하고 결재 완료 결과물을 받는다. 
    	ModelAndView mv = new ModelAndView();
    	
    	String tid = dto.getTid(); 
    	String id = dto.getPartner_user_id();
    	String orderid = String.valueOf(dto.getOrderid());
    	String snum = dto.getSnum();
    	int totprice = dto.getTotal_amount();
    	String address = dto.getAddress();
    	String name = dto.getName();
    	String tel = dto.getTel();
    	String email = dto.getEmail();
    	String drequest = dto.getDrequest();
    	String basketnum = dto.getBasketnum();
    	String useCoupon = dto.getUsecoupon();
    	String stringSavePoint = dto.getSavepoint();
    	stringSavePoint = stringSavePoint.replace(",", "");
    	int savePoint = Integer.parseInt(stringSavePoint);
    	
    	int usePoint;
    	if(dto.getUsepoint() == null) {
    		usePoint = 0;
    	}
    	else {
    		String point = dto.getUsepoint();
    		point = point.replace(",", "");
    		usePoint = Integer.parseInt(point);     		
    	}

        String SECRET_KEY = "DEVEFDEE8BC156E700548072473187B892DAC623"; 
        String auth = "SECRET_KEY " + SECRET_KEY; 

        ObjectMapper objectMapper = new ObjectMapper();

        String apiUrl = "https://open-api.kakaopay.com/online/v1/payment/approve"; // 카카오 단건결제 결재 '승인' 링크

        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type","application/json"); 
        headers.set("Authorization", auth); 

        Map<String, Object> requestBodyMap = new LinkedHashMap<>();
        // 아래는 카카오 결재 API 가 결재 승인 요청에 요구하는 필수 데이터들
        requestBodyMap.put("cid", "TC0ONETIME"); // 가맹점 id(String), 테스트 아이디 "TC0ONETIME" 입력
        requestBodyMap.put("tid", tid); // 결재 고유 번호
        requestBodyMap.put("partner_order_id", orderid); // 가맹점 주문번호(String)
        requestBodyMap.put("partner_user_id", id); // 가맹점 회원 id(String)
        requestBodyMap.put("pg_token", pgToken); // 결제승인 요청을 인증하는 토큰(String), 위에서 진행한 결재 요청 이후 클라이언트가 결재를 진행하면 토큰이 리다이렉트로 돌아온다.

        String requestBody1 = null;
        try {
            requestBody1 = objectMapper.writeValueAsString(requestBodyMap); 
        } catch (JsonProcessingException e) {
            e.printStackTrace();
//            return "JSON 변환에 실패했습니다.";
        }
        
        HttpEntity<String> requestEntity = new HttpEntity<>(requestBody1, headers); 

        RestTemplate restTemplate = new RestTemplate(); 
     // 한글 인코딩, 안하면 카카오 결재창에서 상품명이 ?로 뜬다.
        List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();
        StringHttpMessageConverter stringHttpMessageConverter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
        stringHttpMessageConverter.setWriteAcceptCharset(false);
        messageConverters.add(stringHttpMessageConverter);
        restTemplate.setMessageConverters(messageConverters);
     // 한글 인코딩 end
        
        ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, requestEntity, String.class); 
       
        if (response.getStatusCode().is2xxSuccessful()) {
        	JsonNode root = objectMapper.readTree(response.getBody());
        	// 결재 완료 결과물을 카카오 서버에서 받아옴
        	String aid = root.get("aid").asText(); // 요청 고유 번호, 승인/취소가 구분된 결제번호
        	String tid1 = root.get("tid").asText(); // 결제 고유 번호, 승인/취소가 동일한 결제번호
        	String cid = root.get("cid").asText();
        	String partner_order_id = root.get("partner_order_id").asText(); // 가맹점 주문번호(String)
        	int partner_order_id1 = Integer.parseInt(partner_order_id); // 주문 번호 String을 int로 변환
        	String partner_user_id = root.get("partner_user_id").asText();
        	String payment_method_type = root.get("payment_method_type").asText(); // 결재 수단, CARD 혹은 MONEY(테스트 단계에선 MONEY 만 가능해 보인다. CARD로 하려면 다른 카드사 결재를 따로 등록해야하는 것 같음)  
        	String item_name = root.get("item_name").asText();
        	String quantity = root.get("quantity").asText();
        	int quantity1 = Integer.parseInt(quantity);
        	String created_at = root.get("created_at").asText(); // 결제 준비 요청 시각
        	String approved_at = root.get("approved_at").asText(); // 결제 승인 시각
        	
        	int paystate = 1; // 결재 상태 1 = 결재 완료
        	String payment = "카카오페이"; //결제 방식 구분
    
        	
        	// 결재 완료 후 클라이언트에게 보여줄 부분만 가져와서 DB에(payinfo) 저장
        	Service ss = sqlSession.getMapper(Service.class);
        	System.out.println("usecoupon: "+useCoupon);
        	System.out.println("savepoint: "+savePoint);
        	String insertCoupon = "";
        	if(useCoupon.equals("10000원 할인쿠폰")) {
        		insertCoupon = "mannum";
        	}
        	else if(useCoupon.equals("10% 할인쿠폰")) {
        		insertCoupon = "tennum";
        	}
        	else if(useCoupon.equals("20% 할인쿠폰")) {
        		insertCoupon = "twentinum";
        	}
        	
        	ss.payinsert(tid1,partner_order_id1,id,payment_method_type,item_name,quantity1,totprice,approved_at,snum,address,name,tel,email,drequest,paystate,payment,insertCoupon,savePoint,usePoint);
        	// 결재 완료 후 출력
        	ArrayList<PayDTO> list = ss.payout(partner_order_id1, partner_user_id);
        	// 결재 완료 후 해당 상품 재고 감소 업데이트
        	String[] basketnums = basketnum.split(",");
            for (String basket : basketnums) {
            	ArrayList<BasketDTO> basketlist = ss.basketInfo(basket);
            	for(BasketDTO aa : basketlist) {
            		ss.productsuupdate(aa);   // 구매한 만큼 상품 재고 갱신
            	}
            	ss.basketDelete(basket);   // 장바구니 삭제
            }
        	if(useCoupon.equals("10000원 할인쿠폰")) {
        		ss.couponUpdate(id,"mannum");    // 쿠폰 업데이트
        	}
        	else if(useCoupon.equals("10% 할인쿠폰")) {
        		ss.couponUpdate(id,"tennum");    		
        	}
        	else if(useCoupon.equals("20% 할인쿠폰")) {
        		ss.couponUpdate(id,"twentinum");    		
        	}
        	com.ezen.haha.membership.Service mss = sqlSession.getMapper(com.ezen.haha.membership.Service.class);
        	mss.couponTotal(id); // 보유쿠폰 수 갱신
      		ss.pointUpdate(id,usePoint,savePoint); // 포인트 갱신
      		int nowpoint = ss.selectnowpoint(id);
      		ss.nowpointUpdate(nowpoint,id,orderid);
        	int totalPrice = ss.totalPrice(id); // 회원 총 주문금액 
      		ss.rankUpdate(id,totalPrice); // 회원등급 갱신
      		
        	// return "redirect:/이동경로" 을 하면 알 수 없는 이유로 화면이 이동하지 않는 문제가 발생(이동이 안되고 그냥 출력문으로 출력됨)
        	// 부득이하게 ModelAndView 를 사용하여 화면 이동
        	mv.addObject("list", list);
        	mv.setViewName("payout"); // 상품 구입 후 출력
        	return mv;
        	
        }
        else
        {
//        	return "결제를 실패했습니다.";
        }
		return mv;
   
    }    
    
    
    // 환불 과정(카카오 단건결재 API)
    @PostMapping("/paycancelrequest") // 데이터값 POST 지정, 카카오 서버는 POST 자료만 받는다고 명시되어 있음
    public ResponseEntity<String> paycancelrequest(HttpServletRequest request, @RequestBody Map<String, String> formData) throws UnsupportedEncodingException {
		String tid = formData.getOrDefault("tid", "");
		int totprice = Integer.parseInt(formData.getOrDefault("totprice", ""));
		HttpSession hs = request.getSession();
		String id = (String) hs.getAttribute("id");
		int orderid = Integer.parseInt(formData.getOrDefault("orderid", ""));
		
		String SECRET_KEY = "DEVEFDEE8BC156E700548072473187B892DAC623"; // 시크릿(secret_key(dev)) 키(테스트용 키)
        String auth = "SECRET_KEY " + SECRET_KEY; // 앞에 "SECRET_KEY " 를 써줘야 카카오 서버가 시크릿 키를 인식함

        ObjectMapper objectMapper = new ObjectMapper();

        String apiUrl = "https://open-api.kakaopay.com/online/v1/payment/cancel"; // 카카오 단건결제 결재 '요청' 링크

        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type","application/json"); // 본문 형식을 JSON 으로 변경, 안하면 카카오 서버가 인식을 못한다.(API 문서에도 명시되어 있음)
        headers.set("Authorization", auth); // 카카오 서버 시크릿 키 인증 틀

        Map<String, Object> requestBodyMap = new LinkedHashMap<>();
        // 아래는 카카오 결재 API 가 결재 요청에 요구하는 필수 데이터들, 아래 이외의 데이터도 추가해서 넣을 수 있다.(API 문서 참조)
        requestBodyMap.put("cid", "TC0ONETIME"); // 가맹점 id(String), 테스트 아이디 "TC0ONETIME" 입력
        requestBodyMap.put("tid", tid); // 결재 고유번호
        requestBodyMap.put("cancel_amount", totprice); // 취소 금액(int)
        requestBodyMap.put("cancel_tax_free_amount", 0); // 취소 비과세 금액(int)
        
        String requestBody = "";
        try {
            requestBody = objectMapper.writeValueAsString(requestBodyMap); // 카카오 서버에 json 형식으로 보내줘야 하기에 타입을 변경
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            
        }
        
        HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers); // 위에 쓴 정보들을 가지고 카카오 서버에 요청
        
        RestTemplate restTemplate = new RestTemplate(); // 카카오 서버에 요청하고 그 결과물을 받기 위한 코드
        
        // 한글 인코딩, 안하면 카카오 결재창에서 상품명이 ?로 뜬다.
        List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();
        StringHttpMessageConverter stringHttpMessageConverter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
        stringHttpMessageConverter.setWriteAcceptCharset(false);
        messageConverters.add(stringHttpMessageConverter);
        restTemplate.setMessageConverters(messageConverters);
        // 한글 인코딩 end
        
        ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, requestEntity, String.class); // 받은 자료들을 response에 저장
        System.out.println(response);
        if (response.getStatusCode().is2xxSuccessful()) { // response가 true 라면 아래 실행
            // 받은 JSON 응답을 객체로 매핑하여 출력
            try {
                JsonNode root = objectMapper.readTree(response.getBody()); // 카카오 서버에서 받은 자료들을 JSON 문자열(JsonNode)로 변경
                String tid1 = root.get("tid").asText(); // 결재 고유 번호
                String partner_order_id = root.get("partner_order_id").asText(); // 가맹점 주문번호
                String partner_user_id = root.get("partner_user_id").asText(); // 가맹점 회원 아이디
                
                JsonNode amountNode = root.get("amount"); // 결재 금액, amount에 복합적으로 내용이 들어가 있기에 따로 풀어야 한다.
                int totalAmount = amountNode.get("total").asInt(); // 총 결재 금액 가져오기
                                
                JsonNode canceled_amount = root.get("canceled_amount"); // 취소 금액
                int totalCanceled_amount = canceled_amount.get("total").asInt();
                  
                String item_name = root.get("item_name").asText(); // 상품 이름
                String quantity = root.get("quantity").asText(); // 상품 수량
                String approved_at = root.get("approved_at").asText(); // 결재 승인 시각
                String canceled_at = root.get("canceled_at").asText(); // 결재 취소 시각
                
                System.out.println(tid1);
                System.out.println(partner_order_id);
                
                String message = "환불이 완료되었습니다.";
                
                Service ss = sqlSession.getMapper(Service.class);
                String useCoupon = ss.selectUseCoupon(orderid);
                int savePoint = ss.selectSavePoint(orderid);
                
                ss.updatepaylist(orderid);
           
                if(useCoupon != null) {
                	ss.couponRefund(id,useCoupon);
                }
                ss.savePointRefund(id,savePoint);
                int totalPrice = ss.totalPrice(id);
          		ss.rankUpdate(id,totalPrice);
          		
            	com.ezen.haha.membership.Service mss = sqlSession.getMapper(com.ezen.haha.membership.Service.class);
            	mss.couponTotal(id); // 보유쿠폰 수 갱신
          		
                return ResponseEntity.ok(message); 
                
            } catch (JsonProcessingException e) {
                e.printStackTrace();
               
            }
        } else {
        	return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("환불 처리가 이미 완료되었습니다.");
        }
		
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("환불 처리가 이미 완료되었습니다.");
    }
    
}
