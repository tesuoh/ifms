package ifms.adm.bbs.qna.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.bbs.qna.mapper.AdmQnaMapper;
import ifms.cmn.util.IfmsGlobalsUtil;
import ifms.common.file.service.FileService;
import ifms.common.util.FilePath;

/**
 * Qna 관리 Service
 * @author seryeong
 *
 */
@Service
public class AdmQnaService {
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private AdmQnaMapper admQnaMapper;
	
	@Autowired
	private FileService fileService;

	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;
	
	/**
	 * 질의 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectAdmQnaList(Map<String, Object> requestMap) throws Exception{
		return admQnaMapper.selectAdmQnaList(requestMap);
	}
	
	/**
	 * 질의 목록 총건수 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectQnaListTotalCount(Map<String, Object> requestMap) throws Exception{
		return admQnaMapper.selectQnaListTotalCount(requestMap);
	}
	
	/**
	 * Qna 상세 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectQnaDetail(Map<String, Object> requestMap) throws Exception{
		admQnaMapper.updateInqCnt(requestMap); //조회수 증가
		
		return admQnaMapper.selectQnaDetail(requestMap);
	}
	
	/**
	 * 답변 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> qnaAnsCnInsert(Map<String, Object> requestMap) throws Exception{
		try {
			String lastMdfrId = "";
			if (requestMap.get("lastMdfrId") != null) {
				lastMdfrId = requestMap.get("lastMdfrId").toString();
			} else {
				// frstRgtrId가 없을 경우 예외 처리 또는 기본값 설정
				throw new IllegalArgumentException("등록자 ID가 누락되었습니다.");
			}

			Map<String, Object> uploadMap = (Map<String, Object>) requestMap.get("ansFileGroupSn");

			String ansFileGroupSn = null;
			
			if (uploadMap != null && uploadMap.get("fileGroupSn") != null) {
				
				fileService.saveSingleFile(lastMdfrId, uploadMap, ifmsGlobalsUtil.getProperties("REAL_PATH"));
				
				ansFileGroupSn = uploadMap.get("fileGroupSn").toString().equals("") ? null : uploadMap.get("fileGroupSn").toString();
			}
			
			requestMap.put("ansFileGroupSn", ansFileGroupSn);
			
			return admQnaMapper.qnaAnsCnInsert(requestMap);

		} catch (IllegalArgumentException e) {
			log.error("입력 값 오류: {}", e.getMessage());
			throw e;
		}
	}
	
	/**
	 * 질의 게시글 삭제 처리
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deleteQstn(Map<String, Object> requestMap) throws Exception{
		return admQnaMapper.deleteQstn(requestMap);
	}
}
