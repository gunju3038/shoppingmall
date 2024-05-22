package com.ezen.haha.pay;

public class PayDTO {
	// 카카오페이용 변수
	String tid; // 결재고유번호
	String next_redirect_mobile_url; // 모바일 접속 시
	String next_redirect_pc_url; // pc 접속 시
	String partner_order_id; // 주문번호
	String partner_user_id; // 회원아이디
	String payment_method_type; // 결재 수단, CARD 혹은 MONEY
	String item_name; // 상품명
	int quantity; // 상품개수
	int total_amount; // 상품 총금액
	int tax_free_amount; // 비과세금액
	String pgtoken; // 클라이언트 결재 후 결제 최종 승인에 필요한 토큰
	String created_at; // 결제 준비 요청 시각
	String approved_at; // 결제 승인 시각
	String basketnum; // 재고 및 장바구니 삭제
	String usecoupon; // 쿠폰 업데이트
	String usepoint; // 포인트 업데이트
	String savepoint; // 포인트 업데이트
	int orderid;
	// 결재 출력용 변수
	String id,paytype,sname,payendtime,address,name,tel,email,drequest;
	int paynum,totprice;
	String snum;
	String paystate; // 결재 상태, 1 = 결재완료 / 0 = 환불완료
	String payment;
	
	public PayDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getTid() {
		return tid;
	}
	public void setTid(String tid) {
		this.tid = tid;
	}
	public String getNext_redirect_mobile_url() {
		return next_redirect_mobile_url;
	}
	public void setNext_redirect_mobile_url(String next_redirect_mobile_url) {
		this.next_redirect_mobile_url = next_redirect_mobile_url;
	}
	public String getNext_redirect_pc_url() {
		return next_redirect_pc_url;
	}
	public void setNext_redirect_pc_url(String next_redirect_pc_url) {
		this.next_redirect_pc_url = next_redirect_pc_url;
	}
	public String getPartner_order_id() {
		return partner_order_id;
	}
	public void setPartner_order_id(String partner_order_id) {
		this.partner_order_id = partner_order_id;
	}
	public String getPartner_user_id() {
		return partner_user_id;
	}
	public void setPartner_user_id(String partner_user_id) {
		this.partner_user_id = partner_user_id;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public int getTotal_amount() {
		return total_amount;
	}
	public void setTotal_amount(int total_amount) {
		this.total_amount = total_amount;
	}
	public int getTax_free_amount() {
		return tax_free_amount;
	}
	public void setTax_free_amount(int tax_free_amount) {
		this.tax_free_amount = tax_free_amount;
	}
	public String getPgtoken() {
		return pgtoken;
	}
	public void setPgtoken(String pgtoken) {
		this.pgtoken = pgtoken;
	}
	public String getPayment_method_type() {
		return payment_method_type;
	}
	public void setPayment_method_type(String payment_method_type) {
		this.payment_method_type = payment_method_type;
	}
	public String getCreated_at() {
		return created_at;
	}
	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}
	public String getApproved_at() {
		return approved_at;
	}
	public void setApproved_at(String approved_at) {
		this.approved_at = approved_at;
	}

	
 	public String getBasketnum() {
		return basketnum;
	}
	public void setBasketnum(String basketnum) {
		this.basketnum = basketnum;
	}
	public int getOrderid() {
		return orderid;
	}
	public void setOrderid(int orderid) {
		this.orderid = orderid;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPaytype() {
		return paytype;
	}
	public void setPaytype(String paytype) {
		this.paytype = paytype;
	}
	public String getSname() {
		return sname;
	}
	public void setSname(String sname) {
		this.sname = sname;
	}
	public String getPayendtime() {
		return payendtime;
	}
	public void setPayendtime(String payendtime) {
		this.payendtime = payendtime;
	}
	public int getPaynum() {
		return paynum;
	}
	public void setPaynum(int paynum) {
		this.paynum = paynum;
	}
	public int getTotprice() {
		return totprice;
	}
	public void setTotprice(int totprice) {
		this.totprice = totprice;
	}
	public String getSnum() {
		return snum;
	}
	public void setSnum(String snum) {
		this.snum = snum;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getDrequest() {
		return drequest;
	}
	public void setDrequest(String drequest) {
		this.drequest = drequest;
	}
	public String getPaystate() {
		return paystate;
	}
	public void setPaystate(String paystate) {
		this.paystate = paystate;
	}
	public String getUsecoupon() {
		return usecoupon;
	}
	public void setUsecoupon(String usecoupon) {
		this.usecoupon = usecoupon;
	}
	public String getUsepoint() {
		return usepoint;
	}
	public void setUsepoint(String usepoint) {
		this.usepoint = usepoint;
	}
	public String getSavepoint() {
		return savepoint;
	}
	public void setSavepoint(String savepoint) {
		this.savepoint = savepoint;
	}
	public String getPayment() {
		return payment;
	}
	public void setPayment(String payment) {
		this.payment = payment;
	}

	
}

