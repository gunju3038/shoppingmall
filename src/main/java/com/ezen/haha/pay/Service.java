package com.ezen.haha.pay;

import java.util.ArrayList;

import com.ezen.haha.product.BasketDTO;
import com.ezen.haha.product.ProductDTO;
import com.ezen.haha.product.ProductreviewDTO;

public interface Service {

	ArrayList<PayDTO> payout(int partner_order_id1, String partner_user_id);

	void payinsert(String tid1, int partner_order_id1, String partner_user_id, String payment_method_type, String item_name, int quantity1, int totprice, String approved_at, String snum, String address, String name, String tel, String email, String drequest, int paystate, String payment, String useCoupon, int savePoint, int usePoint);

	void productsuupdate(int snum, int quantity1);

	ArrayList<PayDTO> paysearch(String orderid);

	String email(String id);

	ArrayList<BasketDTO> basketInfo(String basket);

	void productsuupdate(BasketDTO aa);

	void basketDelete(String basket);

	void couponUpdate(String id, String string);

	void pointUpdate(String id, int usePoint, int savePoint);

	void insertorderid(PayDTO paydto);

	void payinfoupdate(String guestbuysu, int partner_order_id1);

	void rankUpdate(String id, int totalPrice);

	int totalPrice(String id);

	void couponRefund(String id, String useCoupon);

	void savePointRefund(String id, int savePoint);

	String selectUseCoupon(int orderid);

	int selectSavePoint(int orderid);

	void updatepaylist(int orderid);

	void bankinsert(String id, String name, String address, String tel, String email, String payment, String snum,
			String sname, int paynum, int totprice, String payEndTime, String paystate, String insertCoupon,
			int savePoint, int usePoint);

	int pointsearch(String id);

	void nowpointUpdate(int nowpoint, String id, String orderid);

	int selectnowpoint(String id);

	int selectorderid(String id);

	void banknowpointUpdate(int nowpoint, String id, int orderid);

	

}
