package com.kh.semiprj.vo;

import lombok.Data;

@Data
public class PageVO {
	private String column;
	private String keyword;
	private int page = 1;
	private int size = 10;
	private int count;
	
	//목록인지 검색인지 판정하는 메소드
	public boolean isList() {
		return column == null || keyword == null;
	}
	public boolean isSearch() {
		return !isList();
	}
	
	//시작Rownum과 종료Rownum을 계산
	public int getBeginRownum() {
		return page * size - (size - 1);
	}
	public int getEndRownum() {
		return page * size;
	}
	
	//검색 유지용 파라미터
	public String getSearchParams() {
		if(isList())
			return "size="+size;
		else 
			return "size="+size+"&column="+column+"&keyword="+keyword;
	}
	
	//현재 페이지에 맞는 첫 블록 번호를 반환하는 메소드
	public int getBeginBlock() {
		return (page - 1) / 10 * 10 + 1;
	}
	
	//이전 블록이 존재하는지 판정하는 메소드
	public boolean hasPrevious() {
		return getBeginBlock() > 1;//블록 시작이 1보다 크면 → 이전 있음
	}
	
	//이전을 누르면 이동할 블록 번호를 반환하는 메소드
	public int getPreviousBlock() {
		return getBeginBlock() - 1; 
	}
	
	//전체 페이지 수를 계산하여 반환하는 메소드
	public int getPageCount() {
		return (count - 1) / size + 1;
	}
	
	//현재 페이지 기준 마지막 블록을 계산하여 반환하는 메소드
	public int getEndBlock() {
		int endBlock = getBeginBlock() + 9;
		return Math.min(getPageCount(), endBlock);
	}
	
	//다음이 존재하는지 판정하여 반환하는 메소드
	public boolean hasNext() {
		return getEndBlock() < getPageCount();//현재 블록 끝 < 전체 페이지 수 → 다음 있음
	}
	
	//다음을 누르면 나올 블록번호를 계산하는 메소드
	public int getNextBlock() {
		return getEndBlock() + 1;
	}
}

