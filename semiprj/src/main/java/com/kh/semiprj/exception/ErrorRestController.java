package com.kh.semiprj.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RestControllerAdvice;

//예외만 전담하여 처리하는 도구
//@RestControllerAdvice(annotations = {RestController.class})
@RestControllerAdvice(basePackages = {"com.kh.spring09.restcontroller"})
public class ErrorRestController {
	
	//컨트롤러에서 예외가 생기면 그 예외에 대한 처리를 수행하는 매핑
	//- 코드는 컨트롤러와 동일하게 작성 가능
	//- 예외 객체를 제공받을 수 있음
	@ExceptionHandler(Exception.class)
	public ResponseEntity<String> error(Exception e, Model model) {
		return ResponseEntity.status(500).build(); //오류 페이지 연결
	}
	
	@ExceptionHandler(TargetNotfoundException.class)
	public ResponseEntity<String> notFound(Exception e, Model model) {
		return ResponseEntity.status(404).build();//오류 페이지 연결
	}
	@ExceptionHandler(WhoAreYouException.class)
	public ResponseEntity<String> unauthorize(Exception e, Model model) {
		return ResponseEntity.status(401).build();//오류 페이지 연결
	}
	@ExceptionHandler(GetOutException.class)
	public ResponseEntity<String> forbidden(Exception e, Model model) {
		return ResponseEntity.status(403).build();//오류 페이지 연결
	}
	
	//비동기 부서 카테고리 등록 중복 오류
	@ExceptionHandler(SameNameException.class)
	public ResponseEntity<String> handleSameName(SameNameException e) {
		e.printStackTrace();
		
		return ResponseEntity.status(400).body(e.getMessage());
	}
	
}






