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
	private MasterOnlyInterceptor masterOnlyInterceptor;
	@Autowired
	private BoardReadInterceptor boardReadInterceptor;
	@Autowired
	private ReplyOwnerInterceptor replyOwnerInterceptor;
	private PdsReadInterceptor pdsReadInterceptor;
	@Autowired

    InterceptorConfiguration(PdsReadInterceptor pdsReadInterceptor) {
        this.pdsReadInterceptor = pdsReadInterceptor;
    }
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		//홈 화면에 로그인된 사용자 Dto를 넘겨주는 인터셉터(다른 화면에도 필요할 수 있을 거 같은데 필요하면 쓰세요
		registry.addInterceptor(homeInterceptors).addPathPatterns("/**");

		
		//자료실 조회수 증가 인터셉터
		registry.addInterceptor(pdsReadInterceptor)
				.addPathPatterns("/pds/detail");
		
		registry.addInterceptor(empOnlyInterceptor).addPathPatterns(
				"/emp/**"
				,"/admin/**"
				);
	}
}
