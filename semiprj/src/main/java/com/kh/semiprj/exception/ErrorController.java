package com.kh.semiprj.exception;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice(basePackages = {"com.kh.semiprj.controller"})
public class ErrorController {
	@ExceptionHandler(Exception.class)
	public String error(Exception e, Model model) {
		e.printStackTrace();
		model.addAttribute("message", e.getMessage());
		return "error/500";
	}
	
	@ExceptionHandler(TargetNotfoundException.class)
	public String notFound(Exception e, Model model) {
		model.addAttribute("message", e.getMessage());
		return "error/404";
	}
	
	@ExceptionHandler(WhoAreYouException.class)
	public String unauthorize(Exception e, Model model) {
		model.addAttribute("message", e.getMessage());
		return "error/401";//미인증
	}
	
	@ExceptionHandler(GetOutException.class)
	public String forbidden(Exception e, Model model) {
		model.addAttribute("message", e.getMessage());
		return "error/403";//권한 부족
	}
}