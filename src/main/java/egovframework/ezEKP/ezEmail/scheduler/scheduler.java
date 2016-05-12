package egovframework.ezEKP.ezEmail.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class scheduler {
	
	@Scheduled(cron = "0 50 17 * * *")
	public void cronTest1(){
		System.out.println("오후 05:50:00에 호출이 됩니다 ");
	}

}
