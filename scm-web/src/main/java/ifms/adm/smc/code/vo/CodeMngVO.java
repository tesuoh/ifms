package ifms.adm.smc.code.vo;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import ifms.common.util.DefaultVO;
import ifms.cmn.support.Create;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CodeMngVO {
	
	/** 공통코드 ID */
	@NotBlank(message = "공통코드 ID는 필수입니다", groups = { Create.class })
	@Size(max = 20)
	private String comCdId;

	/** 공통코드 길이 */
	private Integer comCdLen;

	/** 서브시스템 코드 */
	@Size(max = 10)
	private String subsysCd;

	/** 시스템 공통코드 여부 */
	@Size(max = 1)
	private String sysComCdYn;

	/** 삭제 여부 */
	@Size(max = 1)
	private String delYn;

	/** 공통코드 명 */
	@Size(max = 100)
	private String comCdNm;

	/** 공통코드 설명 */
	private String comCdExpln;

	/** 등록자 ID */
	private String crtUserId;

	/** 수정자 ID */
	private String updtUserId;

	public CodeMngVO() {
		super();
	}

}
