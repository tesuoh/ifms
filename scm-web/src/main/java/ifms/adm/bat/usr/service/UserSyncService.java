package ifms.adm.bat.usr.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ifms.adm.bat.usr.mapper.EsbLinkMapper;

/**
 * 사용자 데이터 동기화 Service
 * EAI_USERTGT_RCV (인터페이스 테이블)에서 데이터를 읽어서
 * fmsown.tb_scm_user (마스터)와 fmsown.tb_scm_user_parco (디테일) 테이블로 동기화
 * @author system
 */
@Service
public class UserSyncService {
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private EsbLinkMapper esbLinkMapper;
	
	/**
	 * ESB Link 모니터링 및 사용자 데이터 동기화
	 * @throws Exception
	 */
	@Transactional
	public void syncUserData() throws Exception {
		log.info("사용자 데이터 동기화 시작");
		
		try {
			// 1. ESB Link 테이블에서 새로운 레코드 확인
			List<Map<String, Object>> esbLinkRecords = esbLinkMapper.selectNewEsbLinkRecords();
			
			if (esbLinkRecords == null || esbLinkRecords.isEmpty()) {
				log.debug("동기화할 ESB Link 레코드가 없습니다.");
				return;
			}
			
			log.info("ESB Link 레코드 발견: {} 건", esbLinkRecords.size());
			
			// 2. EAI_USERTGT_RCV 인터페이스 테이블에서 동기화할 사용자 데이터 조회
			List<Map<String, Object>> userAllList = esbLinkMapper.selectUserAllForSync();
			
			if (userAllList == null || userAllList.isEmpty()) {
				log.debug("동기화할 사용자 데이터가 없습니다.");
				return;
			}
			
			log.info("동기화할 사용자 데이터: {} 건", userAllList.size());
			
			// 3. 각 사용자 데이터를 tb_scm_user (마스터)와 tb_scm_user_parco (디테일)에 삽입 또는 업데이트
			int scmUserInsertCount = 0;
			int scmUserUpdateCount = 0;
			int scmUserParcoInsertCount = 0;
			int scmUserParcoUpdateCount = 0;
			
			for (Map<String, Object> userAll : userAllList) {
				try {
					// EAI_USERTGT_RCV의 userid를 parco_user_id로 사용 (로그인 ID로 사용)
					String parcoUserId = (String) userAll.get("userid");
					if (parcoUserId == null || parcoUserId.trim().isEmpty()) {
						log.warn("EAI_USERTGT_RCV의 userid가 없어 건너뜁니다: {}", userAll);
						continue;
					}
					
					// tb_scm_user (마스터) 처리 - lgn_id로 존재 여부 확인
					boolean scmUserExists = esbLinkMapper.existsScmUser(parcoUserId);
					String userId;
					
					if (scmUserExists) {
						// 기존 사용자: 기존 user_id 조회
						userId = esbLinkMapper.selectUserIdByLgnId(parcoUserId);
						if (userId == null || userId.trim().isEmpty()) {
							log.warn("기존 user_id 조회 실패, 건너뜁니다: parcoUserId={}", parcoUserId);
							continue;
						}
						log.debug("기존 user_id 사용: userId={}, lgnId={}", userId, parcoUserId);
					} else {
						// 신규 사용자: selectUserId에서 새로운 user_id 생성
						userId = esbLinkMapper.selectUserId();
						if (userId == null || userId.trim().isEmpty()) {
							log.warn("user_id 생성 실패, 건너뜁니다: parcoUserId={}", parcoUserId);
							continue;
						}
						log.debug("신규 user_id 생성: userId={}, lgnId={}", userId, parcoUserId);
					}
					
					Map<String, Object> scmUserMap = mapUserDataForScmUser(userAll, userId, parcoUserId);
					
					if (scmUserExists) {
						esbLinkMapper.updateScmUser(scmUserMap);
						scmUserUpdateCount++;
						log.debug("tb_scm_user 업데이트: userId={}, lgnId={}", userId, parcoUserId);
					} else {
						esbLinkMapper.insertScmUser(scmUserMap);
						scmUserInsertCount++;
						log.debug("tb_scm_user 삽입: userId={}, lgnId={}", userId, parcoUserId);
					}
					
					// tb_scm_user_parco (디테일) 처리 - parco_user_id로 존재 여부 확인
					boolean scmUserParcoExists = esbLinkMapper.existsScmUserParco(parcoUserId);
					Map<String, Object> scmUserParcoMap = mapUserDataForScmUserParco(userAll, userId, parcoUserId);
					
					if (scmUserParcoExists) {
						esbLinkMapper.updateScmUserParco(scmUserParcoMap);
						scmUserParcoUpdateCount++;
						log.debug("tb_scm_user_parco 업데이트: userId={}, parcoUserId={}", userId, parcoUserId);
					} else {
						esbLinkMapper.insertScmUserParco(scmUserParcoMap);
						scmUserParcoInsertCount++;
						log.debug("tb_scm_user_parco 삽입: userId={}, parcoUserId={}", userId, parcoUserId);
					}
					
					// INSERT/UPDATE 성공 시 EAI_USERTGT_RCV의 deal_stat를 'S'로 업데이트 (복합키 사용)
					Map<String, Object> eaiUpdateMap = new HashMap<>();
					eaiUpdateMap.put("unitsystemid", userAll.get("unitsystemid"));
					eaiUpdateMap.put("messageid", userAll.get("messageid"));
					eaiUpdateMap.put("dateandtime", userAll.get("dateandtime"));
					
					esbLinkMapper.updateEaiUsertgtRcvDealStat(eaiUpdateMap);
					log.debug("EAI_USERTGT_RCV deal_stat 업데이트 완료: unitsystemid={}, messageid={}, dateandtime={}", 
							userAll.get("unitsystemid"), userAll.get("messageid"), userAll.get("dateandtime"));
					
				} catch (Exception e) {
					log.error("사용자 데이터 동기화 중 오류 발생: {}", userAll, e);
					// 개별 레코드 오류는 로그만 남기고 계속 진행
				}
			}
			
			log.info("사용자 데이터 동기화 완료 - tb_scm_user(삽입: {} 건, 업데이트: {} 건), tb_scm_user_parco(삽입: {} 건, 업데이트: {} 건)", 
					scmUserInsertCount, scmUserUpdateCount, scmUserParcoInsertCount, scmUserParcoUpdateCount);
			
		} catch (Exception e) {
			log.error("사용자 데이터 동기화 중 오류 발생", e);
			throw e;
		}
	}
	
	/**
	 * EAI_USERTGT_RCV 데이터를 tb_scm_user (마스터) 형식으로 매핑
	 * @param userAll EAI_USERTGT_RCV 데이터
	 * @param userId selectUserIdStr에서 생성한 user_id
	 * @param parcoUserId EAI_USERTGT_RCV의 userid (로그인 ID로 사용)
	 * @return
	 */
	private Map<String, Object> mapUserDataForScmUser(Map<String, Object> userAll, String userId, String parcoUserId) {
		Map<String, Object> userMap = new HashMap<>();
		
		// 기본 필수 필드
		userMap.put("userId", userId);
		userMap.put("userClsfCd", "PAR"); // 기본값
		userMap.put("lgnId", parcoUserId); // EAI_USERTGT_RCV의 userid를 로그인 ID로 사용
		userMap.put("parcoUserId", parcoUserId);
		userMap.put("parcoUserNm", userAll.get("username"));
		userMap.put("parcoEmpNo", userAll.get("employeenumber"));
		
		return userMap;
	}
	
	/**
	 * EAI_USERTGT_RCV 데이터를 tb_scm_user_parco (디테일) 형식으로 매핑
	 * @param userAll EAI_USERTGT_RCV 데이터
	 * @param userId selectUserIdStr에서 생성한 user_id
	 * @param parcoUserId EAI_USERTGT_RCV의 userid
	 * @return
	 */
	private Map<String, Object> mapUserDataForScmUserParco(Map<String, Object> userAll, String userId, String parcoUserId) {
		Map<String, Object> userParcoMap = new HashMap<>();
		
		// 기본 필수 필드
		userParcoMap.put("userId", userId);
		userParcoMap.put("parcoUserId", parcoUserId);
		userParcoMap.put("userPswd", userAll.get("passwd"));
		userParcoMap.put("userOrgnlId", userAll.get("originaluid"));
		userParcoMap.put("userPhotoFile", userAll.get("photo"));
		userParcoMap.put("parcoUserNm", userAll.get("username"));
		userParcoMap.put("userEngNm", userAll.get("engusername"));
		userParcoMap.put("parcoEmpNo", userAll.get("employeenumber"));
		
		// 부서 정보
		userParcoMap.put("deptCd", userAll.get("oucode"));
		userParcoMap.put("deptNm", userAll.get("ou"));
		
		// 직위/직급 정보
		userParcoMap.put("indctJbpsCd", userAll.get("dippos"));
		userParcoMap.put("indctJbpsCdNm", userAll.get("dipposname"));
		userParcoMap.put("jbgdCd", userAll.get("grade"));
		userParcoMap.put("jbgdNm", userAll.get("gradename"));
		userParcoMap.put("jbpsCd", userAll.get("POSITION"));
		userParcoMap.put("jbpsNm", userAll.get("positionname"));
		userParcoMap.put("jbttlCd", userAll.get("titlecode"));
		userParcoMap.put("jbttlNm", userAll.get("titlename"));
		userParcoMap.put("dutyCd", userAll.get("dutycode"));
		userParcoMap.put("dutyNm", userAll.get("dutyname"));
		
		// 날짜 정보 (YYYYMMDD 형식으로 변환 필요)
		userParcoMap.put("regYnd", userAll.get("createdate"));
		userParcoMap.put("jncmpYnd", userAll.get("joindate"));
		userParcoMap.put("rsgntnYmd", userAll.get("deletedate"));
		
		// 연락처 정보
		userParcoMap.put("emlAddr", userAll.get("email"));
		userParcoMap.put("workSutsCd", userAll.get("status"));
		userParcoMap.put("mblTelno", userAll.get("mobile"));
		userParcoMap.put("ofcTelno", userAll.get("officedeptphone"));
		userParcoMap.put("coFxno", userAll.get("officefax"));
		userParcoMap.put("coZip", userAll.get("officezip")); 
		userParcoMap.put("coAddr", userAll.get("officeaddress"));
		userParcoMap.put("coDaddr", userAll.get("officeaddressdetail"));
		
		// 기타 정보
		userParcoMap.put("gndrCd", userAll.get("gender"));
		userParcoMap.put("extTelno", userAll.get("officepersonalphone"));
		userParcoMap.put("empSeCd", userAll.get("usertype"));
		userParcoMap.put("coCd", userAll.get("companyid"));
		userParcoMap.put("coNm", userAll.get("companyname"));
		userParcoMap.put("hghrkDeptCd", userAll.get("topoucode"));
		userParcoMap.put("hghrkDeptNm", userAll.get("topou"));
		userParcoMap.put("powkCd", userAll.get("workplacecode"));
		userParcoMap.put("powkNm", userAll.get("workplace"));
		userParcoMap.put("ocptNm", userAll.get("worktype"));
		userParcoMap.put("ocptCd", userAll.get("worktypecode"));
		userParcoMap.put("cstctNm", userAll.get("costcenter"));
		userParcoMap.put("cstctCd", userAll.get("costcentercode"));
		userParcoMap.put("workRulNm", userAll.get("workrule"));
		userParcoMap.put("workRulCd", userAll.get("workrulecode"));
		userParcoMap.put("lastPrmtYmd", userAll.get("lastpromotiondate"));
		userParcoMap.put("prpGrdNo", userAll.get("proposalgrade"));
		userParcoMap.put("nationality", userAll.get("nationality"));
		
		// 인터페이스 관리 컬럼 (send_time을 if_dt로 사용)
		userParcoMap.put("ifDt", userAll.get("send_time"));
		
		return userParcoMap;
	}
}

