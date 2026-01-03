package ifms.adm.bat.usr.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 사용자 데이터 동기화 스케줄러
 * ESB Link 테이블을 모니터링하여 새로운 사용자 데이터를 동기화
 * @author system
 */
@Component
public class UserSyncScheduler {
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private UserSyncService userSyncService;
	
	/**
	 * 1분마다 실행되는 사용자 데이터 동기화 작업
	 * cron 표현식: 초 분 시 일 월 요일
	 * "0 * * * * ?" - 매 분 0초에 실행
	 */
	@Scheduled(cron = "0 * * * * ?")
	public void syncUserDataJob() {
		log.info("사용자 데이터 동기화 스케줄 작업 시작");
		
		try {
			userSyncService.syncUserData();
			log.info("사용자 데이터 동기화 스케줄 작업 완료");
		} catch (Exception e) {
			log.error("사용자 데이터 동기화 스케줄 작업 중 오류 발생", e);
		}
	}
}

