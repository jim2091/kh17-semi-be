package com.kh.semiprj.exception;

public class SameNameException extends RuntimeException{

	public SameNameException() {
		super();
	}
	public SameNameException(String message) {
		super(message);
	}
}
