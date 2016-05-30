package egovframework.ezEKP.ezEmail.task;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import egovframework.com.cmm.EgovMessageSource;

@Component
public class EzEmailAsync {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailAsync.class);

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 
	
	@Async
	public void test(String str) throws Exception{
		Thread.sleep(5000);
		System.out.println(str);
	}

}
