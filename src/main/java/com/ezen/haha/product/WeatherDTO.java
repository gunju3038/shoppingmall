package com.ezen.haha.product;

import java.util.ArrayList;

public class WeatherDTO {
	String lowbaseDate, lowfcstTime, lowfcstValue;
    String highbaseDate, highfcstTime, highfcstValue;
	String id;
	
    public WeatherDTO() {}

	public String getLowbaseDate() {
		return lowbaseDate;
	}
	public void setLowbaseDate(String lowbaseDate) {
		this.lowbaseDate = lowbaseDate;
	}
	public String getLowfcstTime() {
		return lowfcstTime;
	}
	public void setLowfcstTime(String lowfcstTime) {
		this.lowfcstTime = lowfcstTime;
	}
	public String getLowfcstValue() {
		return lowfcstValue;
	}
	public void setLowfcstValue(String lowfcstValue) {
		this.lowfcstValue = lowfcstValue;
	}
	public String getHighbaseDate() {
		return highbaseDate;
	}
	public void setHighbaseDate(String highbaseDate) {
		this.highbaseDate = highbaseDate;
	}
	public String getHighfcstTime() {
		return highfcstTime;
	}
	public void setHighfcstTime(String highfcstTime) {
		this.highfcstTime = highfcstTime;
	}
	public String getHighfcstValue() {
		return highfcstValue;
	}
	public void setHighfcstValue(String highfcstValue) {
		this.highfcstValue = highfcstValue;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

}
