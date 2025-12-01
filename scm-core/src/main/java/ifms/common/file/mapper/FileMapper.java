package ifms.common.file.mapper;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import ifms.common.file.vo.FileGroupVO;
import ifms.common.file.vo.FileVO;

import java.util.List;

@Mapper
public interface FileMapper {

    /**
     * upload single/upload multi 파일그룹정보 생성
     * @param fileGroupVO
     * @throws Exception
     */
    void insertFileGroup(FileGroupVO fileGroupVO) throws Exception;

    /**
     * upload single/upload multi 파일상세정보 생성
     * @param fileVO
     * @throws Exception
     */
    void insertFileDetail(FileVO fileVO) throws Exception;

    /**
     * upload single/upload multi 파일정보 삭제하기 - UPDATE처리
     * @param fileVO
     * @return
     * @throws Exception
     */
    int deleteFile(FileVO fileVO) throws Exception;
    
    /**
     * upload single 파일정보 삭제하기 - DELETE처리
     * @param fileVO
     * @return
     * @throws Exception
     */
    int deleteFileInfo(FileVO fileVO) throws Exception;
    
    /**
     * upload single 파일그룹정보 삭제하기 - DELETE처리
     * @param fileVO
     * @return
     * @throws Exception
     */
    int deleteFileInfoGroup(FileVO fileVO) throws Exception;

    /**
     * upload single 파일정보저장 - 최종저장처리
     * 		- 필수파라미터 : fileGroupSn, filePath, fileDtlSn, mdfrId
     * @param fileVO
     * @return
     * @throws Exception
     */
    int saveSingleFile(FileVO fileVO) throws Exception;

    /**
     * upload single 파일정보 불러오기 - upload single업로드에서만 사용
     * @param fileVO
     * @return
     * @throws Exception
     */
    FileVO selectFileDtl(FileVO fileVO) throws Exception;

    /**
     * 다운로드수 UPDATE 처리
     * @param vo
     * @return
     * @throws Exception
     */
    int updateDwldCount(FileVO vo) throws Exception;

    /**
     * upload multi 파일목록 불러오기
     * @param fileVO
     * @return
     * @throws Exception
     */
    List<FileVO> selectFileList(FileVO fileVO) throws Exception;

    /**
     * upload multi 파일정보저장 - 최종저장처리
     * 		- 필수파라미터 : fileGroupSn, filePath, fileDtlSnArray, mdfrId
     * @param fileVO
     * @return
     * @throws Exception
     */
    int saveMultiFile(FileVO fileVO) throws Exception;
    
    /**
     * single 파일 교체 시 기존에 등록된 파일 DEL_YN = 'Y' 처리
     * @param fileVO
     * @return
     * @throws Exception
     */
    int updateOrgnlFile(FileVO fileVO) throws Exception;
    int updateNewFile(FileVO fileVO) throws Exception;
}
