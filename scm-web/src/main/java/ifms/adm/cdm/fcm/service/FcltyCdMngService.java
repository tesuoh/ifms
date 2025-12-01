package ifms.adm.cdm.fcm.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.cdm.fcm.mapper.FcltyCdMngMapper;
import ifms.cmn.util.IfmsGlobalsUtil;
import ifms.common.file.mapper.FileMapper;
import ifms.common.file.service.FileService;
import ifms.common.file.vo.FileVO;

/**
 * 시설물 코드 관리 Service
 * @author seongwook
 *
 */
@Service
public class FcltyCdMngService {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private FcltyCdMngMapper fcltyCdMngMapper;
	
	@Autowired
	private FileService fileService;

	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;
	
    @Autowired
    private FileMapper fileMapper;
    
	/**
	 * 시설물코드 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectFcltyCdMngTotalCount(Map<String, Object> requestMap) throws Exception{
		return fcltyCdMngMapper.selectFcltyCdMngTotalCount(requestMap);
	}
	
	/**
	 * 시설물코드 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectFcltyCdMngList(Map<String, Object> requestMap) throws Exception{
		return fcltyCdMngMapper.selectFcltyCdMngList(requestMap);
	}
	
	/**
	 * 시설물코드 분류 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectFcltyCdClsfList(Map<String, Object> requestMap) throws Exception{
		return fcltyCdMngMapper.selectFcltyCdClsfList(requestMap);
	}
	
	/**
	 * 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public int insertFcltyCdMng(Map<String, Object> requestMap) throws Exception{
		if(fcltyCdMngMapper.selectFcltyCdCnt(requestMap) > 0) {
			return -1;
		}
		
		Map<String, Object> fileUpload = (Map<String, Object>) requestMap.get("admFcmGroupSn");
		requestMap.put("fileGroupSn", Integer.parseInt(fileUpload.get("fileGroupSn").toString()));
		String userId = (String) requestMap.get("userId");
		
		if(fileUpload != null) {
			fileService.saveSingleFileFclty(userId, fileUpload, ifmsGlobalsUtil.getProperties("FCLTY_IMG_PATH"), (String)requestMap.get("ptznFcltySeCd"));
			
			FileVO fileVO = new FileVO();
			int fileGroupSn = NumberUtils.toInt(String.valueOf(fileUpload.get("fileGroupSn")));
			int fileDtlSn = NumberUtils.toInt(String.valueOf(fileUpload.get("fileDtlSn")));
			fileVO.setFileGroupSn(fileGroupSn);									//화면에서 넘어온 파일그룹 KEY
			fileVO.setFileDtlSn(fileDtlSn);										//화면에서 넘어온 파일상세 KEY
			fileVO = fileService.selectFileDtl(fileVO);
			
//			requestMap.put("iconFileNm", (String)requestMap.get("ptznFcltySeCd") + FileUtil.getFilenameExtension((String)requestMap.get("fileNm"), true));
			requestMap.put("iconFileNm", (String)requestMap.get("ptznFcltySeCd") + "." + fileVO.getFileExtnNm());
		}
		
		
		String fcltyClsfNm = (String) requestMap.get("fcltyClsfNm");
		switch(fcltyClsfNm) {
			case "101":
				requestMap.put("fcltyClsfNm", "CCTV");
				requestMap.put("lyrNm", "101_CCTV 현황");
				requestMap.put("blckNm", requestMap.get("blckNm") + "_현황");
				requestMap.put("tmprTblNm", "cad_cctv_lyr_stus_t");
				requestMap.put("stusTblNm", "cad_cctv_lyr_stus_m");
				requestMap.put("upPtznFcltySn", "8");
				break;
			case "301":
				requestMap.put("fcltyClsfNm", "안전표지");
				requestMap.put("lyrNm", "301_안전표지 현황");
				requestMap.put("blckNm", requestMap.get("blckNm") + "_현황");
				requestMap.put("tmprTblNm", "cad_stlb_lyr_stus_t");
				requestMap.put("stusTblNm", "cad_stlb_lyr_stus_m");
				
				String stlbClsf = String.valueOf(((String) requestMap.get("blckNm")).charAt(0));
				if(stlbClsf.equals("1")) requestMap.put("upPtznFcltySn", "24");
				else if(stlbClsf.equals("2")) requestMap.put("upPtznFcltySn", "67");
				else if(stlbClsf.equals("3")) requestMap.put("upPtznFcltySn", "113");
				else if(stlbClsf.equals("4")) requestMap.put("upPtznFcltySn", "157");
				else requestMap.put("upPtznFcltySn", "157");
				break;
			case "405":
				requestMap.put("fcltyClsfNm", "노면표시");
				requestMap.put("lyrNm", "405_노면표시 현황_기타");
				requestMap.put("blckNm", requestMap.get("blckNm") + "_현황");
				requestMap.put("tmprTblNm", "cad_pvmk_etc_pnt_lyr_stus_t");
				requestMap.put("stusTblNm", "cad_pvmk_etc_pnt_lyr_stus_m");
				requestMap.put("upPtznFcltySn", "221");
				break;
			case "505":
				requestMap.put("fcltyClsfNm", "도로부속물");
				requestMap.put("lyrNm", "505_도로부속물 현황_기타");
				requestMap.put("blckNm", requestMap.get("blckNm") + "_현황");
				requestMap.put("tmprTblNm", "cad_rdacr_etc_pnt_lyr_stus_t");
				requestMap.put("stusTblNm", "cad_rdacr_etc_pnt_lyr_stus_m");
				requestMap.put("upPtznFcltySn", "295");
				break;
			case "601":
				requestMap.put("fcltyClsfNm", "기타시설물");
				requestMap.put("lyrNm", "601_기타시설물 현황");
				requestMap.put("blckNm", requestMap.get("blckNm") + "_현황");
				requestMap.put("tmprTblNm", "cad_etc_fclty_pnt_lyr_stus_t");
				requestMap.put("stusTblNm", "cad_etc_fclty_pnt_lyr_stus_m");
				requestMap.put("upPtznFcltySn", "320");
				break;
			default:
				return -2;
		}
		return fcltyCdMngMapper.insertFcltyCdMng(requestMap);
	}
	
	/**
	 * 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deleteFcltyCdMng(Map<String, Object> requestMap) throws Exception{
		try {
			//첨부파일도 함께 삭제
			List<Map<String, Object>> fileInfo = fcltyCdMngMapper.getFileInfoList(requestMap);
			
			FileVO vo = new FileVO();
			vo.setMdfrId((String)requestMap.get("userId"));
			for(int i = 0; i < fileInfo.size(); i++) {
				vo.setFileGroupSn(Integer.parseInt(fileInfo.get(i).get("fileGroupSn").toString()));																	//화면에서 넘어온 파일그룹 KEY
				vo.setFileDtlSn(Integer.parseInt(fileInfo.get(i).get("fileDtlSn").toString()));																	//화면에서 넘어온 파일그룹 KEY
				
				fileService.deleteRealFile(Integer.parseInt(fileInfo.get(i).get("fileGroupSn").toString()), "N", fileInfo.get(i).get("delYn").toString());
				fileService.deleteFileInfo(vo);
			}
			// 그룹을 삭제하면 파일이 여러개일때 최초 파일만 삭제되고 나머지 파일이 삭제 안돼서 개별삭제 후 그룹 삭제하는걸로 변경
			fileService.deleteFileInfoGroup(vo);
		}
		catch(SQLException e) {
			log.error("SQLException: {}", e);
		}
		int result = 0;
		String delYn = fcltyCdMngMapper.selectFcltyCdDelYn(requestMap);
		if("Y".equals(delYn)) {
			result = fcltyCdMngMapper.deleteFcltyCdMng(requestMap);
		} else if("N".equals(delYn)){
			result = -1;
		} else {
			result = 0;
		}
		return result;
	}
}
