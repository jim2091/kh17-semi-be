package com.kh.semiprj.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice(basePackages = {"com.kh.semiprj.restController"})
public class ErrorRestController {
	@ExceptionHandler(Exception.class)
	public ResponseEntity<String> error(Exception e) {
		e.printStackTrace();
		return ResponseEntity.status(500).build();
	}
	
	@ExceptionHandler(TargetNotfoundException.class)
	public ResponseEntity<String> notFound(Exception e) {
		return ResponseEntity.status(404).build();
	}
	
	@ExceptionHandler(WhoAreYouException.class)
	public ResponseEntity<String> unauthorize(Exception e) {
		return ResponseEntity.status(401).build();
	}
	
	@ExceptionHandler(GetOutException.class)
	public ResponseEntity<String> forbidden(Exception e) {
		return ResponseEntity.status(403).build();
	}
	//비동기 부서 카테고리 등록 중복 오류
		@ExceptionHandler(SameNameException.class)
		public ResponseEntity<String> handleSameName(SameNameException e) {
			e.printStackTrace();
			
			return ResponseEntity.status(400).body(e.getMessage());
		}
}

