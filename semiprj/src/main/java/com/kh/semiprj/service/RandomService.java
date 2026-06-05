package com.kh.semiprj.service;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

import org.springframework.stereotype.Service;

@Service
public class RandomService {
	private Random r = new Random();
	private SecureRandom sr = new SecureRandom();
	private String numbers = "1234567890";
	private String lowerCases = "abcdefghijklmnopqrstuvwxyz";
	private String upperCases = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	private String specialCharacter = "!@#$%^&*()_+~`[]{};':\"\\|,.<>/?";
	private List<String> typeList = List.of(numbers, lowerCases, upperCases, specialCharacter);
	
	public String generateNumber(int size) {
		StringBuffer buffer = new StringBuffer();
		for(int i = 0; i < size; i++) {
			int index = r.nextInt(numbers.length());
			char ch = numbers.charAt(index);
			buffer.append(ch);
		}
		return buffer.toString();
	}
	
	public String generatePw(int size) {
		if(size < 8 || size > 16) {
            throw new IllegalArgumentException("비밀번호 길이는 8~16자여야 합니다.");
        }

        List<Character> chars = new ArrayList<>();

        for(String type : typeList) {
            int index = sr.nextInt(type.length());
            chars.add(type.charAt(index));
        }

        for(int i = 0; i < size - 4; i++) {
            String type = typeList.get(sr.nextInt(typeList.size()));
            chars.add(type.charAt(sr.nextInt(type.length())));
        }

        Collections.shuffle(chars);

        StringBuilder sb = new StringBuilder();

        for(char ch : chars) {
            sb.append(ch);
        }

        return sb.toString();
    }
}
