package com.ezen.haha.product;

public class ProductreviewDTO {
	String id,btitle,bcontent,bpicture,bdate;
	int productrank;
	
	public ProductreviewDTO() {}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getBtitle() {
		return btitle;
	}

	public void setBtitle(String btitle) {
		this.btitle = btitle;
	}

	public String getBcontent() {
		return bcontent;
	}

	public void setBcontent(String bcontent) {
		this.bcontent = bcontent;
	}

	public String getBpicture() {
		return bpicture;
	}

	public void setBpicture(String bpicture) {
		this.bpicture = bpicture;
	}

	public String getBdate() {
		return bdate;
	}

	public void setBdate(String bdate) {
		this.bdate = bdate;
	}

	public int getProductrank() {
		return productrank;
	}

	public void setProductrank(int productrank) {
		this.productrank = productrank;
	}
}
