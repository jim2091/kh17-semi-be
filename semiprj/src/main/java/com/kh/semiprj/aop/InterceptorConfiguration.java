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
	@Autowired
	private AccountStatusInterceptor accountStatusInterceptor;
	@Autowired
	private DeptDashboardInterceptor deptDashboardInterceptor;
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(homeInterceptors).addPathPatterns("/**");
		
		// 2. 자료실 조회수 증가 인터셉터
		registry.addInterceptor(pdsReadInterceptor)
				.addPathPatterns("/pds/detail");
		
		// 3. [핵심 수정] 로그인한 사원(Emp)만 접근 가능한 경로 지정 
		// 근태(/attn/**) 및 전자결재(/app/**) 주소를 추가하여 비회원 접근을 차단합니다.

		//- 로그인된 사용자 기능에 대한 인터셉터

		registry.addInterceptor(empOnlyInterceptor).addPathPatterns(
				"/emp/**"
				,"/board/**"
				,"/dept/**"
				,"/message/**"
				,"/attn/**"  // 근태 메뉴 추가
				,"/app/**"   // 결재 및 휴가원 신청 메뉴 추가
				,"/admin/**"//관리자
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


		// 4. 관리자(Master) 전용 기능 제한 인터셉터 (하나로 병합 정렬)

		
		//- 관리자 기능에 대한 인터셉터

		registry.addInterceptor(masterOnlyInterceptor).addPathPatterns(
				"/pds/write"
				,"/pds/edit"
				,"/message/delete"
				,"/message/adminList"
				,"/admin/**" // 하단에 중복 분리되어 있던 코드를 이쪽으로 통합했습니다.
				);

		
		// 8. 최고관리자 거부 정책 인터셉터
		// 뭔가 이상한데요? /admin은 관리자가 보는 페이지일텐데 관리자 접근을 막는다..? 일단 주석처리 할게요
		
//		registry.addInterceptor(masterDenyInterceptor).addPathPatterns(
//				"/admin/detail"
//				,"/admin/edit"
//				);
		

		// 9. 본인 메시지 확인 인터셉터
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
				.addPathPatterns("/message/detail");
		
		registry.addInterceptor(accountStatusInterceptor)
				.addPathPatterns("/**")
				.excludePathPatterns(
						"/emp/edit"
						,"/emp/wait"
						,"/emp/login"
						,"/css/**"
                        ,"/js/**"
                        ,"/images/**"
                        ,"/error"
                        ,"/emp/find**"
                        ,"/emp/cert**"
                        ,"/emp/change**"
						);
		registry.addInterceptor(deptDashboardInterceptor)
				.addPathPatterns("/dept/manager");
	}
}