package com.kh.semiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.semiprj.dao.EventDao;
import com.kh.semiprj.dto.EventDto;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/event")
public class EventController {
	
	
	@Autowired
    private EventDao eventDao;

    // 1. 단순 달력 화면(JSP)을 열어주는 메서드
    @RequestMapping("/calendar")
    public String calendar() {
        return "event/calendar"; // /WEB-INF/views/calendar.jsp 호출
    }

    // 2. [조회 API] DB에서 일정을 싹 긁어와서 JSON 배열로 보내주는 메서드
    @GetMapping("/api/events")
    @ResponseBody // 🌟 자바 List를 JSON 문자열로 자동 조립해 줍니다.
    public List<EventDto> selectList(HttpSession session) {
    	String loginNo = (String) session.getAttribute("loginNo");
        // 서비스 -> 매퍼 -> 오라클 DB 조회 실행
        List<EventDto> list = eventDao.selectList(loginNo);
        return list; 
    }

   
    @PostMapping("/rest/event")
    @ResponseBody
    public EventDto insert(
            @RequestBody EventDto eventDto){
    	
        eventDao.insertEvent(eventDto);

        return eventDto;
    }

    
    @PutMapping("/rest/event")
    @ResponseBody
    public String edit(@RequestBody EventDto eventDto) {
        boolean result = eventDao.update(eventDto);
        //System.out.println("수정요청들어옴");
        //System.out.println(eventDto);
        
        return result? "success" : "fail";
    }
    
    
    @DeleteMapping("/rest/event")
    @ResponseBody
    public String delete(@RequestParam int eventNo) {

        boolean result = eventDao.delete(eventNo);

        return result ? "success" : "fail";
    }
    
    @RequestMapping("/calendarList")
    public String calendarList(HttpSession session, 
    		@RequestParam(required = false) String sort, 
    		@RequestParam(required = false) String column, 
			@RequestParam(required = false) String keyword, 
    					
    					Model model){
    	String loginNo = (String) session.getAttribute("loginNo");
    	
    	List<EventDto> list; 
    	
    			
		if(keyword != null && !keyword.trim().isEmpty()) {
	
	        list = eventDao.selectListByUser(
	                loginNo,
	                column,
	                keyword);
	
	    }		
    			
    			
    			
		else if("event_no".equals(sort)) {
            list = eventDao.selectNewest(loginNo);
        }
        else if("event_start1".equals(sort)) {
            list = eventDao.selectBySchedule(loginNo);
        }
        else {
            list = eventDao.selectOldest(loginNo);
        }
    	
    	model.addAttribute("list", list);
    	//System.out.println("sort = " + sort);
    	
    	return "event/calendarList";
    	
    	
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
