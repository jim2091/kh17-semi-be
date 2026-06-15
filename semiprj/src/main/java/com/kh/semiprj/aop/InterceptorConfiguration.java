package com.kh.semiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class InterceptorConfiguration implements WebMvcConfigurer{

	@Autowired
	private HomeInterceptors homeInterceptors;
	@Autowired
	private BoardOwnerInterceptor boardOwnerInterceptor;
	@Autowired
	private EmpOnlyInterceptor empOnlyInterceptor;
	@Autowired
	private MasterDenyInterceptor masterDenyInterceptor;
	@Autowired
	private MasterOnlyInterceptor masterOnlyInterceptor;
	@Autowired
	private BoardReadInterceptor boardReadInterceptor;
	@Autowired
	private ReplyOwnerInterceptor replyOwnerInterceptor;
	@Autowired
	private PdsReadInterceptor pdsReadInterceptor;
	@Autowired
	private MessageOwnerInterceptor messageOwnerInterceptor;
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		//- 홈 화면에 로그인된 사용자 Dto를 넘겨주는 인터셉터 
		//(다른 화면에도 필요할 수 있을 거 같은데 필요하면 쓰세요)
		registry.addInterceptor(homeInterceptors).addPathPatterns("/**");

		//- 로그인된 사용자 기능에 대한 인터셉터
		registry.addInterceptor(empOnlyInterceptor).addPathPatterns(
				"/admin/**"//관리자
				,"/app/**"//전자결재
				,"/attn/**"//근태
				,"/emp/**"//직원
				,"/board/**"//게시판
				,"/dept/**"//부서
				,"/event/**"//일정
				,"/message/**"//쪽지
				,"/notification/**"//알림
				,"/pds/**"//자료실
				)
				.excludePathPatterns(
						"/emp/login"
						,"/emp/cert_id"
						,"/emp/cert_pw"
						,"/emp/change_pw"
						,"/emp/change_pw_change"
						,"/emp/find_id"
						,"/emp/find_id_complete"
						,"/emp/find_pw"
						,"/dept/insert"
						,"/dept/edit"
						);
		
		//- 관리자 기능에 대한 인터셉터
		registry.addInterceptor(masterOnlyInterceptor).addPathPatterns(
				"/pds/write"
				,"/message/delete"
				,"/message/adminList"
				,"/admin/**"
				)
				.excludePathPatterns(
						);
		registry.addInterceptor(masterDenyInterceptor).addPathPatterns(
				"/admin/detail"
				,"/admin/edit"
				);
		
		//- 자료실 조회수 증가 인터셉터
		registry.addInterceptor(pdsReadInterceptor)
				.addPathPatterns("/pds/detail");
		
		//- 게시판 조회수 증가 처리를 하는 인터셉터
		registry.addInterceptor(boardReadInterceptor)
				.addPathPatterns("/board/detail");
		
		//- 본인 소유의 게시글만 수정, 삭제가 가능하도록 하는 인터셉터
		registry.addInterceptor(boardOwnerInterceptor)
		        .addPathPatterns("/board/edit", "/board/delete");
		
		//- 본인 소유의 댓글만 수정, 삭제가 가능하도록 하는 인터셉터
		registry.addInterceptor(replyOwnerInterceptor)
				.addPathPatterns("/rest/reply/edit", "/rest/reply/delete");
				
		//- 메세지 소유자만 상세 페이지 접근할 수 있도록 하는 인터셉터
		registry.addInterceptor(messageOwnerInterceptor)
				.addPathPatterns(
						"/message/detail"
						);
	}
}
