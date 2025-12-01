package ifms.adm.bbs.isb.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.bbs.isb.mapper.AdmIsbMapper;
import ifms.common.file.service.FileService;
import ifms.common.file.vo.FileVO;

/**
 * 정보공유게시판 관리
 * @author seryeong
 *
 */

@Service
public class AdmIsbService {

	@Autowired
	private AdmIsbMapper admIsbMapper;
	
	@Autowired
	private FileService fileService;
	
	/**
	 * 정보공유 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectIsbTotalCount(Map<String, Object> requestMap) throws Exception{
		return admIsbMapper.selectIsbTotalCount(requestMap);
	}
	
	/**
	 * 정보공유 게시판 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectAdmIsbList(Map<String, Object> requestMap) throws Exception{
		return admIsbMapper.selectAdmIsbList(requestMap);
	}
	
	/**
	 * 게시글 상세
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectIsbPstDetail(Map<String, Object> requestMap) throws Exception{
		admIsbMapper.updateInqCnt(requestMap);
		
		return admIsbMapper.selectIsbPstDetail(requestMap);
	}
	
	/**
	 * 댓글 목록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectIsbCmntList(Map<String, Object> requestMap) throws Exception {
		return admIsbMapper.selectIsbCmntList(requestMap);
	}
	
	/**
	 * 댓글 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectCmntTotalCount(Map<String, Object> requestMap) throws Exception {
		return admIsbMapper.selectCmntTotalCount(requestMap);
	}
	
	/**
	 * 댓글 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deleteCmnt(Map<String, Object> requestMap) throws Exception {
		
		//댓글에 첨부파일 있는 경우 -> 첨부파일도 삭제
		String fileGroupSn = (String) requestMap.get("fileGroupSn");
		String fileDtlSn = (String) requestMap.get("fileDtlSn");
		
		//log.debug("=============== deleteCmnt - fileGroupSn : {}", fileGroupSn);
		
		if(fileGroupSn != null || fileDtlSn != null) {
			
			FileVO fileVO = new FileVO();
			fileVO.setFileGroupSn(Integer.parseInt(fileGroupSn));
			fileVO.setFileDtlSn(Integer.parseInt(fileDtlSn));
			fileVO.setMdfrId((String) requestMap.get("userId"));
			
			fileService.deleteFile(fileVO);
		}
		
		
		return admIsbMapper.deleteCmnt(requestMap);
	}

	/**
	 * 게시글 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deletePst(Map<String, Object> requestMap) throws Exception {
		admIsbMapper.deleteCmntInPst(requestMap); //게시글 내 댓글 삭제
		
		return admIsbMapper.deletePst(requestMap);
	}

	public Map<String, Object> selectVideoFile(Map<String, Object> requestMap) throws Exception {
		return admIsbMapper.selectVideoFile(requestMap);
	}
}
