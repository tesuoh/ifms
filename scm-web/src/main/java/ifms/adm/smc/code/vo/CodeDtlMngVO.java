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
public class CodeDtlMngVO {

	/** 공통코드 ID */
	@NotBlank(message = "공통코드 ID는 필수입니다", groups = { Create.class })
	@Size(max = 20)
	private String comCdId;

	/** 상세코드 */
	@NotBlank(message = "상세코드는 필수입니다", groups = { Create.class })
	@Size(max = 20)
	private String dtlCd;

	/** 정렬 순서 */
	private Integer sortSeq;

	/** 삭제 여부 */
	@Size(max = 1)
	private String delYn;

	/** 상세코드 명 */
	@Size(max = 100)
	private String dtlCdNm;

	/** 상세코드 설명 */
	private String dtlCdExpln;

	/** 적용 시작 일자 */
	@Size(max = 8)
	private String aplcnBgngYnd;

	/** 적용 종료 일자 */
	@Size(max = 8)
	private String aplcnEndYmd;

	/** 등록자 ID */
	private String crtUserId;

	/** 수정자 ID */
	private String updtUserId;

	public CodeDtlMngVO() {
		super();
	}
}
