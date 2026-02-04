package ifms.emma.mapper;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * EMMA SMS 발송 Mapper
 * SMS 메시지 발송을 위한 데이터베이스 연동 인터페이스
 */
@Mapper
public interface EmmaMapper {
	
	/**
	 * SMS 발송 정보 등록
	 * EM_SMT_TRAN 테이블에 SMS 발송 요청 데이터를 등록한다.
	 * 
	 * @param map SMS 발송 정보
	 *        - callback: 발신 전화번호 (일반 전화번호 또는 휴대폰 번호)
	 *        - recepientNum: 수신 휴대폰 번호
	 *        - content: SMS 메시지 내용 (최대 80바이트)
	 * @return 등록된 레코드 수
	 */
	public int insertEmSmtTran(Map<Object, String> map);

}
