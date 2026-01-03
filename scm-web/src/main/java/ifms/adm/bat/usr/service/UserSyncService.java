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
 * fmsif.if_tb_scm_user_all (인터페이스 테이블)에서 데이터를 읽어서
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
			
			// 2. if_tb_scm_user_all 인터페이스 테이블에서 동기화할 사용자 데이터 조회
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
					String userId = (String) userAll.get("user_id");
					
					if (userId == null || userId.trim().isEmpty()) {
						log.warn("user_id가 없어 건너뜁니다: {}", userAll);
						continue;
					}
					
					// tb_scm_user (마스터) 처리
					boolean scmUserExists = esbLinkMapper.existsScmUser(userId);
					Map<String, Object> scmUserMap = mapUserDataForScmUser(userAll);
					
					if (scmUserExists) {
						esbLinkMapper.updateScmUser(scmUserMap);
						scmUserUpdateCount++;
						log.debug("tb_scm_user 업데이트: {}", userId);
					} else {
						esbLinkMapper.insertScmUser(scmUserMap);
						scmUserInsertCount++;
						log.debug("tb_scm_user 삽입: {}", userId);
					}
					
					// tb_scm_user_parco (디테일) 처리
					boolean scmUserParcoExists = esbLinkMapper.existsScmUserParco(userId);
					Map<String, Object> scmUserParcoMap = mapUserDataForScmUserParco(userAll);
					
					if (scmUserParcoExists) {
						esbLinkMapper.updateScmUserParco(scmUserParcoMap);
						scmUserParcoUpdateCount++;
						log.debug("tb_scm_user_parco 업데이트: {}", userId);
					} else {
						esbLinkMapper.insertScmUserParco(scmUserParcoMap);
						scmUserParcoInsertCount++;
						log.debug("tb_scm_user_parco 삽입: {}", userId);
					}
					
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
	 * if_tb_scm_user_all 데이터를 tb_scm_user (마스터) 형식으로 매핑
	 * @param userAll
	 * @return
	 */
	private Map<String, Object> mapUserDataForScmUser(Map<String, Object> userAll) {
		Map<String, Object> userMap = new HashMap<>();
		
		// 기본 필수 필드
		userMap.put("userId", userAll.get("user_id"));
		userMap.put("userClsfCd", userAll.get("user_clsf_cd"));
		userMap.put("lgnId", userAll.get("lgn_id"));
		userMap.put("userNm", userAll.get("user_nm"));
		userMap.put("empNo", userAll.get("emp_no"));
		userMap.put("smsRcptnYn", userAll.get("sms_rcptn_yn"));
		userMap.put("lastCntnIpAddr", userAll.get("last_cntn_ip_addr"));
		userMap.put("lastCntnDt", userAll.get("last_cntn_dt"));
		
		return userMap;
	}
	
	/**
	 * if_tb_scm_user_all 데이터를 tb_scm_user_parco (디테일) 형식으로 매핑
	 * @param userAll
	 * @return
	 */
	private Map<String, Object> mapUserDataForScmUserParco(Map<String, Object> userAll) {
		Map<String, Object> userParcoMap = new HashMap<>();
		
		// 기본 필수 필드
		userParcoMap.put("userId", userAll.get("user_id"));
		userParcoMap.put("parcoUserId", userAll.get("parco_user_id"));
		userParcoMap.put("userPswd", userAll.get("user_pswd"));
		userParcoMap.put("userOrgnlId", userAll.get("user_orgnl_id"));
		userParcoMap.put("userPhotoFile", userAll.get("user_photo_file"));
		userParcoMap.put("parcoUserNm", userAll.get("parco_user_nm"));
		userParcoMap.put("userEngNm", userAll.get("user_eng_nm"));
		userParcoMap.put("parcoEmpNo", userAll.get("parco_emp_no"));
		
		// 부서 정보
		userParcoMap.put("deptCd", userAll.get("dept_cd"));
		userParcoMap.put("deptNm", userAll.get("dept_nm"));
		
		// 직위/직급 정보
		userParcoMap.put("indctJbpsCd", userAll.get("indct_jbps_cd"));
		userParcoMap.put("indctJbpsCdNm", userAll.get("indct_jbps_cd_nm"));
		userParcoMap.put("jbgdCd", userAll.get("jbgd_cd"));
		userParcoMap.put("jbgdNm", userAll.get("jbgd_nm"));
		userParcoMap.put("jbpsCd", userAll.get("jbps_cd"));
		userParcoMap.put("jbpsNm", userAll.get("jbps_nm"));
		userParcoMap.put("jbttlCd", userAll.get("jbttl_cd"));
		userParcoMap.put("jbttlNm", userAll.get("jbttl_nm"));
		userParcoMap.put("dutyCd", userAll.get("duty_cd"));
		userParcoMap.put("dutyNm", userAll.get("duty_nm"));
		userParcoMap.put("tkcgTaskNm", userAll.get("tkcg_task_nm"));
		userParcoMap.put("jbgdLvlNo", userAll.get("jbgd_lvl_no"));
		
		// 날짜 정보
		userParcoMap.put("regYnd", userAll.get("reg_ynd"));
		userParcoMap.put("jncmpYnd", userAll.get("jncmp_ynd"));
		userParcoMap.put("rsgntnYmd", userAll.get("rsgntn_ymd"));
		
		// 연락처 정보
		userParcoMap.put("emlAdor", userAll.get("eml_ador"));
		userParcoMap.put("workSutsCd", userAll.get("work_suts_cd"));
		userParcoMap.put("mblTelno", userAll.get("mbl_telno"));
		userParcoMap.put("ofcTelno", userAll.get("ofc_telno"));
		userParcoMap.put("coFxno", userAll.get("co_fxno"));
		userParcoMap.put("coZip", userAll.get("co_zip"));
		userParcoMap.put("coAdor", userAll.get("co_ador"));
		userParcoMap.put("coDaddr", userAll.get("co_daddr"));
		
		// 기타 정보
		userParcoMap.put("gndrCd", userAll.get("gndr_cd"));
		userParcoMap.put("extTelno", userAll.get("ext_telno"));
		userParcoMap.put("empSeCd", userAll.get("emp_se_cd"));
		userParcoMap.put("coCd", userAll.get("co_cd"));
		userParcoMap.put("coNm", userAll.get("co_nm"));
		userParcoMap.put("hghrkDeptCd", userAll.get("hghrk_dept_cd"));
		userParcoMap.put("hghrkDeptNm", userAll.get("hghrk_dept_nm"));
		userParcoMap.put("powkCd", userAll.get("powk_cd"));
		userParcoMap.put("powkNm", userAll.get("powk_nm"));
		userParcoMap.put("ocptNm", userAll.get("ocpt_nm"));
		userParcoMap.put("ocptCd", userAll.get("ocpt_cd"));
		userParcoMap.put("cstctNm", userAll.get("cstct_nm"));
		userParcoMap.put("cstctCd", userAll.get("cstct_cd"));
		userParcoMap.put("workRulNm", userAll.get("work_rul_nm"));
		userParcoMap.put("workRulCd", userAll.get("work_rul_cd"));
		userParcoMap.put("lastPrmtYmd", userAll.get("last_prmt_ymd"));
		userParcoMap.put("prpGrdNo", userAll.get("prp_grd_no"));
		userParcoMap.put("ntnltyNm", userAll.get("ntnlty_nm"));
		
		// 인터페이스 관리 컬럼
		userParcoMap.put("ifDt", userAll.get("if_dt"));
		
		return userParcoMap;
	}
}

