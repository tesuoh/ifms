package ifms.adm.bbs.rcs.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.bbs.rcs.mapper.AdmRcsMapper;
import ifms.cmn.util.IfmsGlobalsUtil;
import ifms.common.file.service.FileService;
import ifms.common.util.FilePath;

/**
 * 자료실 관리
 * @author seryeong
 *
 */

@Service
public class AdmRcsService {
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	AdmRcsMapper admRcsMapper;
	
	@Autowired
    private FileService fileService;

	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;
	
	/**
	 * 자료실 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectRcsTotalCount(Map<String, Object> requestMap) throws Exception{
		return admRcsMapper.selectRcsTotalCount(requestMap);
	}

	/**
	 * 자료실 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectAdmRcsList(Map<String, Object> requestMap) throws Exception{
		return admRcsMapper.selectAdmRcsList(requestMap);
	}
	
	/**
	 * 자료실 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int insertRcs(Map<String, Object> requestMap) throws Exception{
		try {
			String frstRgtrId = "";
			if (requestMap.get("frstRgtrId") != null) {
				frstRgtrId = requestMap.get("frstRgtrId").toString();
			} else {
				// frstRgtrId가 없을 경우 예외 처리 또는 기본값 설정
				throw new IllegalArgumentException("등록자 ID가 누락되었습니다.");
			}

			String fileGroupSn = null;
			
			
			Map<String, Object> uploadMap = (Map<String, Object>) requestMap.get("admRcsGroupSn");
			if (uploadMap != null) {
				fileService.saveMultiFile(frstRgtrId, uploadMap, ifmsGlobalsUtil.getProperties("REAL_PATH"));
				fileGroupSn = uploadMap.get("fileGroupSn") != null ? uploadMap.get("fileGroupSn").toString() : null; 
			}

			requestMap.put("fileGroupSn", fileGroupSn);
			return admRcsMapper.insertRcs(requestMap);

		} catch (IllegalArgumentException e) {
			log.error("입력 값 오류: {}", e.getMessage());
			throw e;
		}
		
	}
	
	/**
	 * 자료실 상세 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectRcsDetail(Map<String, Object> requestMap) throws Exception{
		admRcsMapper.updateInqCnt(requestMap); //조회수 증가
		
		return admRcsMapper.selectRcsDetail(requestMap);
	}
	
	/**
	 * 자료실 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deleteRcs(Map<String, Object> requestMap) throws Exception{
		String userId = String.valueOf(requestMap.get("userId"));
		log.debug("========= userId : {}", userId);
		
		return admRcsMapper.deleteRcs(requestMap);
	};
	
	/**
	 * 자료실 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int updateRcs(Map<String, Object> requestMap) throws Exception{
		
		try {
			String lastMdfrId = "";
			if (requestMap.get("lastMdfrId") != null) {
				lastMdfrId = requestMap.get("lastMdfrId").toString();
			} else {
				// frstRgtrId가 없을 경우 예외 처리 또는 기본값 설정
				throw new IllegalArgumentException("등록자 ID가 누락되었습니다.");
			}
			String fileGroupSn = null;
			
			Map<String, Object> uploadMap = (Map<String, Object>) requestMap.get("admRcsGroupSn");
			if (uploadMap != null) {
				fileService.saveMultiFile(lastMdfrId, uploadMap, ifmsGlobalsUtil.getProperties("REAL_PATH"));
				fileGroupSn = uploadMap.get("fileGroupSn") != null ? uploadMap.get("fileGroupSn").toString() : null; 
				
				List<String> fileDtlSnArray = (List<String>)uploadMap.get("fileDtlSnArray");
				if(fileDtlSnArray.size() == 0) {
					fileGroupSn = null;
				}
			}

			
			requestMap.put("fileGroupSn", fileGroupSn);

			return admRcsMapper.updateRcs(requestMap);

		} catch (IllegalArgumentException e) {
			log.error("입력 값 오류: {}", e.getMessage());
			throw e;
		}
	}
	
	/**
	 * 동영상
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectVideoFile(Map<String, Object> requestMap) throws Exception{
		return admRcsMapper.selectVideoFile(requestMap);
	}
}
