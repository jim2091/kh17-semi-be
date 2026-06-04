package com.kh.semiprj.exception;

import lombok.NoArgsConstructor;

@NoArgsConstructor
public class TargetNotfoundException extends RuntimeException{
	public TargetNotfoundException(String message) {
		super(message);
	}
}
