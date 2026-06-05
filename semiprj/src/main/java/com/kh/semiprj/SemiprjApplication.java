package com.kh.semiprj;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling; // 1. 스케줄링 활성화를 위한 import

@SpringBootApplication
@EnableScheduling // 2. 여기에 어노테이션 추가
public class SemiprjApplication {

	public static void main(String[] args) {
		SpringApplication.run(SemiprjApplication.class, args);
	}

}