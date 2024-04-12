package com.ezen.haha.membership;

import java.security.SecureRandom;

public class Randompw {
	private static final String mini = "abcdefghijklmnopqrstuvwxyz";
    private static final String big = mini.toUpperCase();
    private static final String number = "0123456789";
    private static final String special_chars = "!@#$%^&*+-=,./?><";

    private static final String pwbase = mini + big + number + special_chars;
    private static final SecureRandom secureRandom = new SecureRandom();

    public static String randompw(int length) {
        if (length < 8) {
            throw new IllegalArgumentException("비밀번호의 길이가 8자 이상이어야 합니다.");
        }

        //가변적인 문자열을 생성하고 변경
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int randomchar = secureRandom.nextInt(pwbase.length());
            sb.append(pwbase.charAt(randomchar));
        }
        return sb.toString();
    }
}
