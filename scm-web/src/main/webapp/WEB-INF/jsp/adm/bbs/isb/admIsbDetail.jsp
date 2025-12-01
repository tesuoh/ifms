<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 정보공유게시판 관리 상세 (+ 댓글)
---------------------------------------------------------------------------------------------------------------- -->

<%
	//줄바꿈
	pageContext.setAttribute("cn", "\n");
	pageContext.setAttribute("br", "</br>");
%>

<script>
	let cmntList;
	let savedParams = ${savedParams};
	
	document.addEventListener('DOMContentLoaded', () => {
		cmntList = document.getElementById('cmntList');		
		init();

		function setupVideoEvents(video) {
			if (!video) {
				console.warn("비디오 요소를 찾을 수 없습니다.");
				return;
			}

			// 비디오가 끝났을 때 처리
			video.addEventListener('ended', function () {
				if (!video.paused) {
					video.pause();
				}
				video.removeAttribute('src'); // 소스 제거
				video.load(); // 연결 해제
			});

			// 페이지를 떠날 때 비디오 정리
			window.addEventListener('beforeunload', function () {
				if (!video.paused) {
					video.pause();
				}
				video.removeAttribute('src');
				video.load();
			});
		}
		const videoContainer = document.getElementById('myVideo'); // div 선택
		const video = videoContainer ? videoContainer.querySelector('video') : null; // div 내부의 video 찾기

		setupVideoEvents(video);
		// MutationObserver 설정 (동적으로 비디오가 추가될 경우)
		const observer = new MutationObserver((mutations) => {
			mutations.forEach((mutation) => {
				mutation.addedNodes.forEach((node) => {
					if (node.tagName === 'VIDEO') {
						setupVideoEvents(node);
					}
				});
			});
		});

		observer.observe(document.body, { childList: true, subtree: true });

	});
	
	const init = async() => {
		await searchCmntList();
		eventHandler.init();
		setPstFile();
	}
	
	const eventHandler = {
		init: function(){
			this.bind();
		}
		, bind: function(){
			
			//목록
			const listButton = document.getElementById('listButton');
			if(listButton){
				listButton.addEventListener('click', () => {
					sendForm('/adm/bbs/isb/admIsbList.do', savedParams);
				});
			}
			
			//게시글 삭제
			const pstDeleteButton = document.getElementById('pstDeleteButton');
			if(pstDeleteButton){
				pstDeleteButton.addEventListener('click', deletePst);
			}

			//댓글 event delegation
			cmntList.addEventListener('click', (event) => {
				
				//댓글 삭제
				if(event.target.classList.contains('cmntDeleteButton')){
					deleteCmnt(event);					
				}
				
				//첨부파일 다운로드
				if(event.target.classList.contains('link-attach')){
					fileDownload(event);
				}
				
			})
			
		}
	}
	
	/* 게시글 첨부파일 세팅 */
	const setPstFile = () => {
		const pstFileGroupSn = ${detail.fileGroupSn};
		
		if(pstFileGroupSn > 0){
			
			$('#pstFileGroupSn').addMultiUpload(
					null
					, {useDefaultExtension : false,  readonly : true }
			);

			$('#pstFileGroupSn').loadMultiUpload(pstFileGroupSn);
		}
	} 

	/* 첨부파일 다운로드 (댓글) */
	const fileDownload = () => {
		event.preventDefault();
		
		const dataset = event.target.dataset;
		const fileGroupSn = dataset.filegroupsn;
		const fileDtlSn = dataset.filedtlsn;
		const srvrFileNm = dataset.srvrfilenm;
		
		
		fn_download(fileGroupSn, fileDtlSn, srvrFileNm, "single");
	}

	/* 페이징 */
	const updatePagination = (pagingVO) => {
		
        if (!pagingVO) return;
        
        const searchCount = document.getElementById('searchCount');
        if (searchCount && pagingVO) {
            searchCount.innerHTML = pagingVO.totalCount;
        }
        $('#pageNavigation').paging(pagingVO, searchCmntList);
    };
	
	/* 댓글 조회 */
	const searchCmntList = (pageNo = 1) => {
		const pageSize = 10;
		
		const params = {
			pstSn: ${detail.pstSn}
			, pageNo: pageNo
			, listCount: pageSize > 0 ? pageSize : null
		};
					
		const cmntListUrl = '/adm/bbs/isb/selectIsbCmntList.json';
		
		if(params.pstSn){
			
			sendJson(cmntListUrl, params, (data) => {
				const { pagingVO, list } = data;
				
				updatePagination(pagingVO);
				renderCmnt(list);
			})
		}
	}
	
	/* 댓글 렌더링 */
	const renderCmnt = (list) => {
		cmntList.innerHTML = '';
		
		if(!list){
			const noCmnt = fnCreateElement('li', { class: 'comment-info-date' }, '댓글이 없습니다.');
			cmntList.append(noCmnt);
			return;
		}
		
		list.forEach((item, idx) => {
			const li = fnCreateElement('li', { class: 'comment-info-group' });
			
			// 작성자
	        const infoDiv = fnCreateElement('div', { class: 'comment-info', style: 'display: flex;' });
	        const wrtrSpan = fnCreateElement('span', { class: 'comment-info-date', style: 'margin: 0;' }, `\${item.wrtrNm} | \${item.instNm}`);
	        const regDtSpan = fnCreateElement('span', { class: 'comment-info-date', style: 'margin-left: auto;' }, item.wrtrDt);
	        
	        infoDiv.appendChild(wrtrSpan);
	        infoDiv.appendChild(regDtSpan);
	     	
	        li.appendChild(infoDiv);
			
	     	// 댓글 내용
	        const textDiv = fnCreateElement('div', { class: 'comment-text' }, item.cmntCn);
	     	
	     	li.appendChild(textDiv);
	     	
	     	//첨부파일 있을 때
	     	if(item.fileGroupSn > 0){
	     		
		     	const fileNm = `\${item.fileNm} (\${util.formatter.FILESIZE.format(item.atchFileSz)})`;
	     		const attr = {
	   				class: 'link-attach'
	 				, href: '#'
	 				, 'title': fileNm
	 				, 'data-filegroupsn': item.fileGroupSn
	 				, 'data-filedtlsn': item.fileDtlSn
	     		}
	     		const div = fnCreateElement('div', {style: 'margin-top: 10px;'}, '첨부파일: ');
	     		const file = fnCreateElement('a', attr, fileNm);
	     		
	     		div.append(file);
	     		
	     		li.appendChild(div);
	     		
	     	}
	     
	     	//삭제버튼
	     	const deleteButtonDiv = fnCreateElement('div', {class: 'table-bottom-control'});
			
			const attrs = {
					class: 'btn btn-small btn-default btn-red cmntDeleteButton'
					, 'data-sn': item.cmntSn
					, id: `cmntDeleteBtns_\${idx}`
					, type: 'button'
			}
			const btn = fnCreateElement('button', attrs, '삭제');
			
			deleteButtonDiv.appendChild(btn);
	     	li.appendChild(deleteButtonDiv);

	        cmntList.appendChild(li);
		});

	}
	
	/* 요소 생성 함수 */
	const fnCreateElement = (tag, attr = {}, text = '') => {
		const element = document.createElement(tag);
		Object.entries(attr).forEach(([key, value])=>{
			element.setAttribute(key, value);
		});
		
		element.innerHTML = text.replace(/(?:\r\n|\r|\n)/g, '</br>');
	    
		return element;
	}
	
	//댓글 삭제
	const deleteCmnt = (event) => {
		const target = event.target;
		const cmntSn = target.dataset.sn;
		const cmntDeleteUrl = '/adm/bbs/isb/deleteCmnt.json';
		const params = {
				'cmntSn': cmntSn
		}
		
		
		//첨부파일이 있다면 첨부파일 정보 같이 보내기
		const cmntGroup = target.closest('.comment-info-group');
		const ahflFileInfo = cmntGroup.querySelector('.link-attach');
		if(ahflFileInfo){
			params.fileGroupSn = ahflFileInfo.dataset.filegroupsn;
			params.fileDtlSn = ahflFileInfo.dataset.filedtlsn;
		}
		
		if(confirm('삭제 하시겠습니까?')){
			sendJson(cmntDeleteUrl, params, (data) => {
				const { result, pagingVO } = data;
				
				if(result == 1){
					searchCmntList();
				}
				else if(result == 'noAuth'){
					alert('삭제 권한이 없습니다.');
					return;
				}
				else{
					alert('삭제 실패하였습니다.');
					return;
				}
			});
		}
	}
	

	//게시글 삭제
	const deletePst = () => {
		const params = {'pstSn': ${detail.pstSn}}
		const pstDeleteUrl = '/adm/bbs/isb/deletePst.json';
		
		if(confirm('삭제하시겠습니까? 게시글에 등록된 댓글도 삭제됩니다.')){
			sendJson(pstDeleteUrl, params, (data) => {
				const result = data.result;
				
				if(result == 1){
					alert('삭제되었습니다.');
					return sendForm('/adm/bbs/isb/admIsbList.do');				
				}
				else if(result == 'noAuth'){
					alert('삭제 권한이 없습니다.');
					return;
				}
			})
			
		}
	}
</script>

<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>정보공유게시판 상세 조회</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 그리드 시작 -->
			<div class="table-scrollable" id="pstDetail">
				<table class="table table-bordered">
					<caption>테이블 요약</caption>
					<colgroup class="hidden-sm hidden-xs">
						<col style="width:140px;">
						<col style="width:35%;">
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">제목</th>
							<td colspan="3">
								<c:out value="${detail.pstTtl }"/>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">소속</th>
							<td>
								<c:out value="${detail.instNm}"/>
							</td>
							<th class="td-head" scope="row">조회수</th>
							<td>
								<c:out value="${detail.inqCnt }"/>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">등록자</th>
							<td>
								<c:out value="${detail.wrtrNm }"/>
							</td>
							<th class="td-head" scope="row">등록일</th>
							<td>
								<c:out value="${detail.wrtrDt }"/>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">내용</th>
							<td colspan="3">
								${fn:replace(detail.pstCn, cn, br)}
								<div id="myVideo" style="width: 80%;">
									<c:if test="${fn:length(videoInfo) > 0}">
										<br>
										<video controls width="100">
											<source type="video/mp4"
													src="/common/file/video.file?fileGroupSn=${videoInfo.fileGroupSn }&fileDtlSn=${videoInfo.fileDtlSn}&fileTypeSeCd=Y&fileNm=${videoInfo.srvrFileNm}"
											/>
										</video>

									</c:if>
								</div>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">첨부파일</th>
							<td colspan="3" id="pstFileList">
								<div id="pstFileGroupSn"></div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 그리드 끝 -->
			
			<!-- 댓글 시작 -->
			<div class="comment-wrapper">
				<div class="comment-head">
					<div class="comment-count"><span class="comment-count-num" id="searchCount"></span>개의 댓글</div>
				</div>
					
				<div class="comment-contents">
					<ul class="comment-list" id="cmntList">
					</ul>
					<!-- 페이징 시작 -->
				    <div class="pagination-wrapper">
				        <div id="pageNavigation"></div>
				    </div>
				    <!-- 페이징 끝 -->
				</div>
			</div>
			<!-- 댓글 끝 -->
			
			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="listButton">목록</button>
				<button type="button" class="btn btn-default btn-red" id="pstDeleteButton">게시글 삭제</button>
			</div>


		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->