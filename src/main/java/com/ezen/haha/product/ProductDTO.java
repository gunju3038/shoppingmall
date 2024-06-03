package com.ezen.haha.product;

public class ProductDTO {
   int snum, price, totprice, best, ssize, msize, lsize, xlsize,viewnum,count;
   String sname, stype, stype_sub, color, image, intro,recommend,info;
   double productrank;
   

public ProductDTO() {}

   public int getSnum() {
      return snum;
   }

   public void setSnum(int snum) {
      this.snum = snum;
   }
   public String getRecommend() {
	   return recommend;
   }
   
   public void setRecommend(String recommend) {
	   this.recommend = recommend;
   }

   public int getPrice() {
      return price;
   }

   public void setPrice(int price) {
      this.price = price;
   }

   public String getSname() {
      return sname;
   }

   public void setSname(String sname) {
      this.sname = sname;
   }



public String getStype() {
	return stype;
}

public void setStype(String stype) {
	this.stype = stype;
}

public String getStype_sub() {
	return stype_sub;
}

public void setStype_sub(String stype_sub) {
	this.stype_sub = stype_sub;
}

public int getSsize() {
	return ssize;
}

public void setSsize(int ssize) {
	this.ssize = ssize;
}

public int getMsize() {
	return msize;
}

public void setMsize(int msize) {
	this.msize = msize;
}

public int getLsize() {
	return lsize;
}

public void setLsize(int lsize) {
	this.lsize = lsize;
}

public int getXlsize() {
	return xlsize;
}

public void setXlsize(int xlsize) {
	this.xlsize = xlsize;
}

public String getImage() {
      return image;
   }

   public void setImage(String image) {
      this.image = image;
   }

   public String getIntro() {
      return intro;
   }

   public void setIntro(String intro) {
      this.intro = intro;
   }

   public int getTotprice() {
      return totprice;
   }

   public void setTotprice(int totprice) {
      this.totprice = totprice;
   }

   public int getBest() {
      return best;
   }

   public void setBest(int best) {
      this.best = best;
   }


   public String getColor() {
      return color;
   }

   public void setColor(String color) {
      this.color = color;
   }

public int getViewnum() {
	return viewnum;
}

public void setViewnum(int viewnum) {
	this.viewnum = viewnum;
}

public String getInfo() {
	return info;
}

public void setInfo(String info) {
	this.info = info;
}

public int getCount() {
	return count;
}

public void setCount(int count) {
	this.count = count;
}

public double getProductrank() {
	return productrank;
}

public void setProductrank(double productrank) {
	this.productrank = productrank;
}


}
