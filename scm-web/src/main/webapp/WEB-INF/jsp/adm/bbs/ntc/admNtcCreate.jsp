<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"		uri="http://www.springframework.org/security/tags" %>

<!-- 공지사항 관리 등록
------------------------------------------------------------------------------------------------- -->

<script>
	let savedParams = ${savedParams};
	
	const ctx = {
		init: function () {
			ctx.eventHandler.init();
		},
		eventHandler: {
			init: function () {
				ctx.eventHandler.bind()
			},
			bind: function () {
				document.getElementById('ntcCreateBtn').addEventListener('click', ctx.method.submit);
				document.getElementById('cancel').addEventListener('click', ctx.method.cancel);

			}
		},
		method: {
			submit: function () {
				form.doSubmit();
			},
			cancel: function () {
				const userConfirmed = confirm('취소하시겠습니까? 작성사항이 저장되지 않습니다.');
				if (userConfirmed) {
					sendForm('/adm/bbs/ntc/admNtcList.do', savedParams);
				}
			}
		}
	}

	const form = {
		init: function () {

		},
		payload: function () {
			const ttl = document.getElementById('ntcMttrTtl').value;
			const cn = document.getElementById('ntcMttrCn').value;
			const ntcMttrPstgYnElement  = document.getElementById('ntcMttrPstgYn');
			const hghrkNtcYnElement  = document.getElementById('hghrkNtcYn');

			const ntcMttrPstgYn = ntcMttrPstgYnElement.checked ? 'Y' : 'N';
			const hghrkNtcYn = hghrkNtcYnElement.checked ? 'Y' : 'N';
			const fileData = $("input[data-key='admNtcGroupSn']").getUploadMultiJson();

			const params = {
				ntcMttrTtl : ttl,
				ntcMttrCn : cn,
				ntcMttrPstgYn : ntcMttrPstgYn,
				hghrkNtcYn : hghrkNtcYn,
				admNtcGroupSn : fileData,
				sysClsfCd: `${sysClsfCd}`
			};

			return params;
		},
		doSubmit: async function () {
			try {
				const params = this.payload();
				const errors = await validator.submit.validate(params);
				if (errors.length > 0) {
					alert(errors.join('\n'));
					return;
				}
				
				// 데이터 전송
				sendJson('/adm/bbs/ntc/insertNtc.json', params, function(data){
					if(data.result === 'success'){
						return sendForm('/adm/bbs/ntc/admNtcList.do', savedParams);
					} else {
						alert('등록에 실패했습니다. 다시 시도해주세요');
						return;
					}
				}, function(error){
					alert('서버 오류로 등록에 실패했습니다.');
				});

			} catch (error){
				await errorHandler.apply(error)
			}
		}
	}

	const validator = {
		submit: {
			validate: async function (payload) {
				return new Promise((resolve) => {
					let errors = [];
					// 제목 필수 입력 검증
					if (!payload.ntcMttrTtl || payload.ntcMttrTtl.trim() === '') {
						errors.push('제목은 필수 입력입니다.');
					}

					// 제목에 HTML 태그 사용 금지
					const tagPattern = /<[^>]*>/g;
					if (tagPattern.test(payload.ntcMttrTtl)) {
						errors.push('제목에 HTML 태그를 사용할 수 없습니다.');
					}

					// 내용에 HTML 태그 사용 금지 (필요 시)
					if (tagPattern.test(payload.ntcMttrCn)) {
						errors.push('내용에 HTML 태그를 사용할 수 없습니다.');
					}

					resolve(errors);
				});
			}
		}
	}

	$(function() {
		ctx.init();

		$('#admNtcGroupSn').addMultiUpload(
				null
				, { useDefaultExtension: true, extension: 'multi', realDelete : true }
		);
		
	})

</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth">
	<span>
		공지사항 관리 등록 - 
		<c:choose>
			<c:when test="${sysClsfCd eq 'ptl'}">대민</c:when>
			<c:when test="${sysClsfCd eq 'biz'}">행정</c:when>
			<c:otherwise></c:otherwise>
		</c:choose>
	</span>
</h1>
<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="table-scrollable">
		<table class="table table-bordered">
			<colgroup>
				<col style="width:12%;">
				<col style="width:auto;">
			</colgroup>
			<tbody>
				<tr>
					<td class="td-head">제목 <span class="textR">*</span></td>
					<td>
						<label class="input-label-none" for="ntcMttrTtl">제목</label>
						<input id="ntcMttrTtl" type="text" class="form-control required" placeholder="입력" name="ntcMttrTtl" style="width:100%"/>
					</td>
				</tr>
				<tr>
					<td class="td-head">내용</td>
					<td>
						<label class="input-label-none" for="ntcMttrCn">내용</label>
						<textarea id="ntcMttrCn" class="form-control" name="ntcMttrCn" style="height:150px;"></textarea>
					</td>
				</tr>
				<tr>
					<td class="td-head">첨부파일</td>
					<td>
                        <div id="admNtcGroupSn"></div>
					</td>
				</tr>
				<tr>
					<td class="td-head">기타</td>
					<td>
						<div class="mt-checkbox-inline">
							<label class="checkbox-label-group">
								<label class="mt-checkbox mt-checkbox-outline" for="ntcMttrPstgYn">
									<input type="checkbox" class="required" id="ntcMttrPstgYn" name="ntcMttrPstgYn" checked/> 게시 여부
									<span></span>
								</label>
								<label class="mt-checkbox mt-checkbox-outline" for="hghrkNtcYn">
									<input type="checkbox" id="hghrkNtcYn" name="hghrkNtcYn"/> 최상위 공지 여부
									<span></span>
								</label>
							</label>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="contents-explanation marT10">
		<div class="contents-explanation-inner">
			<div class="contents-explanation-text">
				<span class="textR">*</span> 표시는 필수입력 사항입니다.
			</div>
		</div>
	</div>
	<div class="table-bottom-control">
		<button type="button" class="btn btn-default" id="cancel">취소</button>
		<button type="button" class="btn btn-primary" id="ntcCreateBtn">등록</button>
	</div>
<!-- 내용 끝 -->
