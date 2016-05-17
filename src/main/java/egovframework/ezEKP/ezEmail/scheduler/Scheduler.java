package egovframework.ezEKP.ezEmail.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class Scheduler {
	
	@Scheduled(cron = "00 00 05 * * *")
	public void autoDelete(){
		System.out.println("오전 05:00:00에 호출이 됩니다 ");
		
	}

}
