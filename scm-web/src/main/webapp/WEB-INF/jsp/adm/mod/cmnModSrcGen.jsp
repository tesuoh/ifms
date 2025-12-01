<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">

  // 생성 버튼 클릭 시 실행될 함수
  const fnGenerate = () => {
    // JSP에서 입력값 읽어오기
    const packagePath = document.getElementById('packagePath').value;
    const entityName = document.getElementById('entityName').value;
    const comment = document.getElementById('comment').value;
    const tableName = document.getElementById('tableName').value;

    // 필수값 체크
    if (packagePath === "") {
      alert("패키지경로는 필수 입력값입니다.");
      return;
    }
    if (entityName === "") {
      alert("업무용어는 필수 입력값입니다.");
      return;
    }
    if (comment === "") {
      alert("업무명칭(주석용)은 필수 입력값입니다.");
      return;
    }
    if (tableName === "") {
      alert("테이블명칭은 필수 입력값입니다.");
      return;
    }

    const packageRegex = /^[a-zA-Z_][a-zA-Z0-9_]*(\.[a-zA-Z_][a-zA-Z0-9_]*)*$/;
    if (!packageRegex.test(packagePath)) {
      alert("패키지명은 'xxx.xxx.xxx' 형태이며 각 세그먼트는 영문, 숫자, 밑줄(_)로 구성되고 첫 문자는 영문 또는 밑줄이어야 합니다.");
      return; // 유효하지 않으면 요청 취소
    }

    // 업무용어 검증: 첫 글자 대문자 시작, 이후 영문, 숫자, 밑줄 허용
    const entityNameRegex = /^[A-Z][A-Za-z0-9_]*$/;
    if (!entityNameRegex.test(entityName)) {
      alert("업무용어는 첫 글자가 대문자이고 영어, 숫자, 밑줄(_)만 허용됩니다.");
      return;
    }

    // 테이블명칭 검증: 영어(대소문자), 숫자, 밑줄만 허용
    const tableNameRegex = /^[A-Za-z0-9_]+$/;
    if (!tableNameRegex.test(tableName)) {
      alert("테이블명칭은 영어, 숫자, 밑줄(_)만 허용됩니다.");
      return;
    }

    // 서버로 보낼 파라미터 구성
    let params = {
      packagePath: packagePath,
      entityName: entityName,
      comment: comment,
      tableName: tableName
    };


    const serviceUrl = "/adm/mod/cmnModSrcGenerate.json";

    // sendJson 함수 사용
    sendJson(serviceUrl, params, function(data) {
      document.getElementById('controllerCode').value = data.controllerCode || '';
      document.getElementById('serviceCode').value = data.serviceCode || '';
      document.getElementById('mapperCode').value = data.mapperCode || '';
      document.getElementById('xmlCode').value = data.xmlCode || '';
      document.getElementById('jspListCode').value = data.jspListCode || '';
    });
  };

</script>



<!-- 카테고리 시작 -->
<div class="category-wrapper">
  <ul class="page-category">
    <li class="category-item"><a href="#">소스코드 생성</a></li>
    <li class="category-item"><a href="#">소스코드 생성</a></li>
  </ul>
</div>
<!-- 카테고리 끝 -->

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>소스코드 생성</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

  <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">
        <!-- 테이블 시작 -->
        <div class="table-scrollable">
            <table class="table table-bordered">
                <caption>테이블 요약</caption>
                <colgroup>
                    <col style="width:160px;">
                    <col style="width:auto;">
                    <col style="width:160px;">
                    <col style="width:auto;">
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row" class="td-head">패키지경로 <span class="textR">*</span></th>
                        <td>
                            <label class="input-label-none" for="packagePath">패키지경로 입력</label>
                            <input type="text" id="packagePath" name="packagePath" class="form-control" placeholder="" style="width: 100%;">
                        </td>
                        <th scope="row" class="td-head">업무용어 <span class="textR">*</span></th>
                        <td>
                            <label class="input-label-none" for="entityName">업무용어 입력</label>
                            <input type="text" id="entityName" name="entityName" class="form-control" placeholder="" style="width: 100%;">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="td-head">업무명칭(주석용) <span class="textR">*</span></th>
                        <td>
                            <label class="input-label-none" for="comment">업무명칭(주석용) 입력</label>
                            <input type="text" id="comment" name="comment" class="form-control" placeholder="" style="width: 100%;">
                        </td>
                        <th scope="row" class="td-head">테이블명칭 <span class="textR">*</span></th>
                        <td>
                            <label class="input-label-none" for="tableName">테이블명칭 입력</label>
                            <input type="text" id="tableName" name="tableName" class="form-control" placeholder="" style="width: 100%;">
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- 테이블 끝 -->

      <div class="table-bottom-control">
        <button type="submit" class="btn btn-primary" onclick="fnGenerate()">생성</button>
      </div>

      <!-- 테이블 시작 -->
      <div class="table-scrollable marT20">
          <table class="table table-bordered">
              <caption>테이블 요약</caption>
              <colgroup>
                <col style="width:160px;">
                <col style="width:auto;">
              </colgroup>
              <thead>
                  <tr>
                      <th scope="col">구분</th>
                      <th scope="col">생성 코드</th>
                  </tr>
              </thead>
              <tbody>
                  <tr>
                      <th scope="row" class="td-head">Controller</th>
                      <td>
                        <label class="input-label-none" for="controllerCode">Controller 생성</label>
                        <textarea id="controllerCode" class="form-control" readonly>${controllerCode}</textarea>
                      </td>
                  </tr>
                  <tr>
                      <th scope="row" class="td-head">Service</th>
                      <td>
                        <label class="input-label-none" for="serviceCode">Service 생성</label>
                        <textarea id="serviceCode" class="form-control" readonly>${serviceCode}</textarea>
                      </td>
                  </tr>
                  <tr>
                      <th scope="row" class="td-head">mapper</th>
                      <td>
                        <label class="input-label-none" for="mapperCode">mapper 생성</label>
                        <textarea id="mapperCode" class="form-control" readonly>${mapperCode}</textarea>
                      </td>
                  </tr>
                  <tr>
                      <th scope="row" class="td-head">xml</th>
                      <td>
                        <label class="input-label-none" for="xmlCode">xml 생성</label>
                        <textarea id="xmlCode" class="form-control" readonly>${xmlCode}</textarea>
                      </td>
                  </tr>
                  <tr>
                      <th scope="row" class="td-head">Jsp List</th>
                      <td>
                        <label class="input-label-none" for="jspListCode">Jsp List 생성</label>
                        <textarea id="jspListCode" class="form-control" readonly>${jspListCode}</textarea>
                      </td>
                  </tr>
              </tbody>
          </table>
      </div>
      <!-- 테이블 끝 -->

  </div>
  <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->