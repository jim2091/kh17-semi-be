package com.kh.semiprj.restController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.BoardDao;

//@CrossOrigin
@RestController
@RequestMapping("/rest/board")
public class BoardRestController {
	@Autowired
	private BoardDao boardDao;
}
