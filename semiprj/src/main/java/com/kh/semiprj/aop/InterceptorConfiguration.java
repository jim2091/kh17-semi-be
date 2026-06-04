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
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(homeInterceptors).addPathPatterns("/**");

	}
}
