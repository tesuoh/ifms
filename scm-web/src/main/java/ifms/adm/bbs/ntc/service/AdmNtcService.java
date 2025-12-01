package ifms.adm.bbs.ntc.service;

import egovframework.context.EgovWebServletContextListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ifms.adm.bbs.ntc.mapper.AdmNtcMapper;
import ifms.cmn.util.IfmsGlobalsUtil;
import ifms.common.file.mapper.FileMapper;
import ifms.common.file.service.FileService;
import ifms.common.util.FilePath;

import java.util.List;
import java.util.Map;

/**
 * 경찰청 보호구역통합관리시스템 구축사업 (2024) 
 * 공지사항 Service
 */

@Service
public class AdmNtcService {

	@Autowired
	private AdmNtcMapper adminNtcMapper;
	
	@Autowired
	private FileMapper fileMapper;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovWebServletContextListener.class);
    @Autowired
    private FileService fileService;

	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;

	/**
	 * 공지사항 총 건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectAdminNtcListCnt(Map<String, Object> requestMap) throws Exception {
		return adminNtcMapper.selectAdminNtcListCnt(requestMap);
	}
	

	/**
	 * 공지사항 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectAdminNtcList(Map<String, Object> requestMap) throws Exception{
		return adminNtcMapper.selectAdmNtcList(requestMap);
	}
	
	
	/**
	 * 공지사항 상세 정보 조회
	 * @return 상세 조회 결과
	 */
	public Map<String, Object> selectAdminNtc(Map<String, Object> requestMap) throws Exception{
		return adminNtcMapper.selectAdminNtcDetail(requestMap);
	}

	/**
	 * 공지사항 조회수
	 * @return 
	 */
	public int addNtcInqCnt(Map<String, Object> requestMap) throws Exception{
		return adminNtcMapper.addNtcInqCnt(requestMap);
	};
	
	
	/**
	 * 공지사항 수정
	 * @param AdminNtcVO
	 * @return 
	 */
	public int updateNtc(Map<String, Object> requestMap) throws Exception{
		try {
			String lastMdfrId = "";
			if (requestMap.get("lastMdfrId") != null) {
				lastMdfrId = requestMap.get("lastMdfrId").toString();
			} else {
				// frstRgtrId가 없을 경우 예외 처리 또는 기본값 설정
				throw new IllegalArgumentException("등록자 ID가 누락되었습니다.");
			}

			Map<String, Object> uploadMap = (Map<String, Object>) requestMap.get("admNtcGroupSn");
			String fileGroupSn = null;
			
			if (uploadMap != null) {
				fileService.saveMultiFile(lastMdfrId, uploadMap, ifmsGlobalsUtil.getProperties("REAL_PATH"));
				

				if(uploadMap.get("fileGroupSn") != null) {
					fileGroupSn = uploadMap.get("fileGroupSn").toString();
				}
				List<String> fileDtlSnArray = (List<String>)uploadMap.get("fileDtlSnArray");
				if(fileDtlSnArray.size() == 0) {
					fileGroupSn = null;
				}
			}

			requestMap.put("fileGroupSn", fileGroupSn);
			return adminNtcMapper.updateNtc(requestMap);

		} catch (IllegalArgumentException e) {
			LOGGER.error("입력 값 오류: {}", e.getMessage());
			throw e;
		}
		
		
	};
	
	
	/**
	 * 공지사항 삭제
	 */
	public int deleteNtc(Map<String, Object> requestMap) throws Exception{
		return adminNtcMapper.deleteNtc(requestMap);
	};

	/**
	 * 공지사항 등록
	 * @param requestMap
	 * @throws Exception
	 */
	public void insertNtc(Map<String, Object> requestMap) throws Exception{
		try {
			String frstRgtrId = "";
			if (requestMap.get("frstRgtrId") != null) {
				frstRgtrId = requestMap.get("frstRgtrId").toString();
			} else {
				// frstRgtrId가 없을 경우 예외 처리 또는 기본값 설정
				throw new IllegalArgumentException("등록자 ID가 누락되었습니다.");
			}

			Map<String, Object> uploadMap = (Map<String, Object>) requestMap.get("admNtcGroupSn");
			if (uploadMap != null) {
				fileService.saveMultiFile(frstRgtrId, uploadMap, ifmsGlobalsUtil.getProperties("REAL_PATH"));
				
			}

			int ntcMttrSn = adminNtcMapper.selectNextNtcMttrSn();

			if (ntcMttrSn > 0) {
				requestMap.put("ntcMttrSn", ntcMttrSn);
			} else {
				// ntcMttrSn 값이 유효하지 않을 경우 예외 처리
				throw new Exception("공지사항 일련번호 생성에 실패했습니다.");
			}
			adminNtcMapper.insertNtc(requestMap);

		} catch (IllegalArgumentException e) {
			LOGGER.error("입력 값 오류: {}", e.getMessage());
			throw e;
		}


	}


}
