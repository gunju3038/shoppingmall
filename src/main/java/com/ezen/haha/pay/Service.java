package com.ezen.haha.pay;

import java.util.ArrayList;

public interface Service {

	ArrayList<PayDTO> payout(int partner_order_id1, String partner_user_id);

	void payinsert(String tid1, int partner_order_id1, String partner_user_id, String payment_method_type, String item_name, int quantity1, int totprice, String approved_at, int snum, String address, String name, String tel, String email, String drequest);

	void productsuupdate(int snum, int quantity1);

}
