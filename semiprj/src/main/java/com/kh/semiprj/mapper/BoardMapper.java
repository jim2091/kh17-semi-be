package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.BoardDto;

@Component
public class BoardMapper implements RowMapper<BoardDto> {
	@Override
	public BoardDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		BoardDto boardDto = new BoardDto();
		boardDto.setBoardNo(rs.getLong("board_no"));
		boardDto.setBoardWriter(rs.getString("board_writer"));
		boardDto.setBoardTitle(rs.getString("board_title"));
		try {
			boardDto.setBoardContent(rs.getString("board_content"));
		}
		catch(Exception e) {
		}
		boardDto.setBoardHead(rs.getString("board_head"));
		boardDto.setBoardType(rs.getString("board_type"));
		boardDto.setBoardWtime(rs.getTimestamp("board_wtime"));
		boardDto.setBoardLikecount(rs.getLong("board_likecount"));
		boardDto.setBoardReadcount(rs.getLong("board_readcount"));
		boardDto.setBoardReplycount(rs.getLong("board_replycount"));
		boardDto.setBoardGroup(rs.getLong("board_group"));
		boardDto.setBoardParent(rs.getObject("board_parent", Long.class));
		boardDto.setBoardDepth(rs.getLong("board_depth"));
		return boardDto;
	}
}
