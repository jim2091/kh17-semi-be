package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ExpAppDto {
private int appId;
private Timestamp expDate;
private int expPrice;
private String expHistory;
private String expHow;
private String expPurpose;
}
