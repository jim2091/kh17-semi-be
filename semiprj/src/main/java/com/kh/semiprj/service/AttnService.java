package com.kh.semiprj.service;

import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.semiprj.dao.AttnDao;

@Service
public class AttnService {
	@Autowired
	private AttnDao attnDao;
	
	public String getAttendanceStatus(LocalTime attnInTime) {
		LocalTime standardTime = LocalTime.of(9, 0);
		
		if(attnInTime == null) {
			return "결근";
		}
		if(attnInTime.isAfter(standardTime)) {
			return "지각";
		}
		return "정상출근";
	}
	
	
	
}
