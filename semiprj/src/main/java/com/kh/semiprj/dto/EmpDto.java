package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class EmpDto {
	private String empNo;
	private String empId;
	private String empPw;
	private String empName;
	private String empBirth;
	private String empEmail;
	private String empContact;
	private String empPost;
	private String empAddress1;
	private String empAddress2;
	private String empLevel;
	private String empPosition;
	private int empDept;
	private String empApprovalStatus;
	private String empUseYn;
	private Timestamp empHireDate;
	private Timestamp empRetiredDate;
	private Timestamp empCreateAt;
	private String empMentor;
	private Timestamp empPwChange;
	private String empEmailVerified;
}
















