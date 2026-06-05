package com.kh.semiprj.vo;

import lombok.Data;

@Data
public class HistoryPageVO {
	private String beginDate;
	private String endDate;
	private int page = 1;
	private int size = 10;
	private int count;
	
	public boolean isList() {
		return beginDate == null || endDate == null;
	}
	public boolean isSearch() {
		return !isList();
	}
	public int getBeginRownum() {
		return page*size-(size-1);
	}
	public int getEndRownum() {
		return page*size;
	}
	public String getSearchParams() {
		if(isList()) 
			return "size=" + size;
		else
			return "size=" +size + "&beginDate=" + beginDate+ "&endDate=" + endDate;
	}
	//현재 페이지에 맞는 첫 블록 번호를 반환하는 메소드
	public int getBeginBlock() {
		return (page-1)/10*10+1;
	}
	//이전 블록이 존재하는지 판정하는 메소드
	public boolean hasPrevious() {
		return getBeginBlock() > 1;
	}
	//이전을 누르면 이동할 블록 번호를 반환하는 메소드
	public int getPreviousBlock() {
		return getBeginBlock() -1;
	}
	//총 페이지수를 계산하여 반환하는 메소드 (pageCount)
	public int getPageCount() {
		return (count-1)/size +1;
	}
	//현재 페이지 기준 마지막 블록을 계산하여 반환하는 메소드(endBlock)
	public int getEndBlock() {
		int endBlock = getBeginBlock() + 9;
		return Math.min(getPageCount(), endBlock);
	}
	//다음이 존재하는지 판정하여 반환하는 메소드
	public boolean hasNext() {
		return getEndBlock() < getPageCount();
	}
	//다음을 누르면 나올 블록번호를 계산하는 메소드(endBlock+1)
	public int getNextBlock() {
		return getEndBlock() +1;
	}

	
	
	
	
}
