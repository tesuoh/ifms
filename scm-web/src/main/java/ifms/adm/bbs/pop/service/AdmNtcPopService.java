package ifms.adm.bbs.pop.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.bbs.pop.mapper.AdmNtcPopMapper;
import ifms.cmn.util.IfmsGlobalsUtil;
import ifms.common.file.service.FileService;
import ifms.common.file.vo.FileVO;
import ifms.common.util.FilePath;

/**
 * 공지 팝업 관리 Service
 * @author seryeong
 *
 */
@Service
public class AdmNtcPopService {

	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private AdmNtcPopMapper admNtcPopMapper;
	
	@Autowired
	private FileService fileService;

	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;
	
	/**
	 * 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectPopListTotalCount(Map<String, Object> requestMap) throws Exception{
		return admNtcPopMapper.selectPopListTotalCount(requestMap);
	}
	
	/**
	 * 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPopList(Map<String, Object> requestMap) throws Exception{
		return admNtcPopMapper.selectPopList(requestMap);
	}
	
	/**
	 * 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int insertPop(Map<String, Object> requestMap) throws Exception{
		
		Map<String, Object> fileUpload = (Map<String, Object>) requestMap.get("admPopGroupSn");
		requestMap.put("fileGroupSn", Integer.parseInt(fileUpload.get("fileGroupSn").toString()));
		String frstRgtrId = (String) requestMap.get("frstRgtrId");
		
		log.debug("========== fileUpload: {}", fileUpload);
		log.debug("========== frstRgtrId: {}", frstRgtrId);
		
		if(fileUpload != null) {
			fileService.saveSingleFile(frstRgtrId, fileUpload, ifmsGlobalsUtil.getProperties("REAL_PATH"));
		}
		
		return admNtcPopMapper.insertPop(requestMap);
	}
	
	/**
	 * 상세
	 * @param popupSn
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectPopDetail(String popupSn) throws Exception{
		return admNtcPopMapper.selectPopDetail(popupSn);
	}
	
	/**
	 * 삭제
	 * @param popupSn
	 * @return
	 * @throws Exception
	 */
	public int deletePop(Map<String, Object> requestMap, String userId) throws Exception{
		
		requestMap.put("userId", userId);
		return admNtcPopMapper.deletePop(requestMap);
	};
	
	/**
	 * 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int updatePop(Map<String, Object> requestMap, String userId) throws Exception{
		
		Map<String, Object> orgnlFileInfo = admNtcPopMapper.getFileInfo(requestMap);
		int orgnlFileGroupSn = Integer.parseInt(orgnlFileInfo.get("fileGroupSn").toString());
		log.debug(" ======== ornalFile: {}", orgnlFileGroupSn);

		Map<String, Object> newFileUpload = (Map<String, Object>) requestMap.get("admPopGroupSn");
		
		if(newFileUpload.get("fileGroupSn").toString().trim().isEmpty()) {
			log.debug("======= 첨부파일은 수정사항 없음 fileGroupSn: {}", orgnlFileGroupSn);
			requestMap.put("fileGroupSn", orgnlFileGroupSn);
		}
		else {
			log.debug("======= 첨부파일 ID 수정 필요");
			
			//기존 첨부파일 삭제
			FileVO vo = new FileVO();
			vo.setFileGroupSn(Integer.parseInt(orgnlFileInfo.get("fileGroupSn").toString()));																	//화면에서 넘어온 파일그룹 KEY
			vo.setFileDtlSn(Integer.parseInt(orgnlFileInfo.get("fileDtlSn").toString()));																	//화면에서 넘어온 파일그룹 KEY
			vo.setMdfrId(userId);
			
			fileService.deleteFile(vo);
			
			//신규 첨부파일 저장
			int newFileGroupSn = Integer.parseInt(newFileUpload.get("fileGroupSn").toString());
			fileService.saveSingleFile(userId, newFileUpload, ifmsGlobalsUtil.getProperties("REAL_PATH"));
			requestMap.put("fileGroupSn", newFileGroupSn);
		}
		
		requestMap.put("userId", userId);
		
		return admNtcPopMapper.updatePop(requestMap);
	}
}
