<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!-- 삭제 확인 -->
<div class="modal fade" id="deleteConfirm" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title">제목</h4>
      </div>
      <div class="modal-body">
        <!-- 내용 시작 -->
        <div class="contents-row">
          내용
        </div>
        <!-- 내용 끝 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary">아니오</button>
        <button type="button" class="btn btn-primary">예</button>
      </div>
    </div>
  </div>
</div>
<!-- 삭제 확인 끝 -->

<!-- 모달팝업 시작 -->
<div class="modal fade" id="popup_01" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title">제목</h4>
      </div>
      <div class="modal-body">
        <!-- 내용 시작 -->
        <div class="contents-row">
          내용
        </div>
        <!-- 내용 끝 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary">저장</button>
      </div>
    </div>
  </div>
</div>
<!-- 모달팝업 끝 -->

<!-- 모달팝업 시작 -->
<div class="modal fade bs-modal-sm" id="popup_03_sm" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title">제목</h4>
      </div>
      <div class="modal-body">
        <!-- 내용 시작 -->
        <div class="contents-row">
          내용
        </div>
        <!-- 내용 끝 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary">저장</button>
      </div>
    </div>
  </div>
</div>
<!-- 모달팝업 끝 -->

<!-- 모달팝업 시작 -->
<div class="modal fade bs-modal-lg" id="popup_03_lg" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title">제목</h4>
      </div>
      <div class="modal-body">
        <!-- 내용 시작 -->
        <div class="contents-row">
          내용
        </div>
        <!-- 내용 끝 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary">저장</button>
      </div>
    </div>
  </div>
</div>
<!-- 모달팝업 끝 -->

<!-- 모달팝업 시작 -->
<div class="modal fade" id="popup_03_full" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-full">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title">제목</h4>
      </div>
      <div class="modal-body">
        <!-- 내용 시작 -->
        <div class="contents-row">
          내용
        </div>
        <!-- 내용 끝 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary">저장</button>
      </div>
    </div>
  </div>
</div>
<!-- 모달팝업 끝 -->

<!-- 모달팝업 시작 -->
<div class="modal fade" id="popup_04" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title">제목</h4>
      </div>
      <div class="modal-body scrollOptionY" style="height: 200px;">
        <!-- 내용 시작 -->
        <div class="contents-row">
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
          내용<br>
        </div>
        <!-- 내용 끝 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary">저장</button>
      </div>
    </div>
  </div>
</div>
<!-- 모달팝업 끝 -->

<!-- Modal Dialog 시작 -->
<div id="myModal1" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal-title-myModal1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title" id="modal-title-myModal1">지정생성</h4>
      </div>
      <div class="modal-body">
        <p> 생성하시겠습니까? </p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-default" data-dismiss="modal">취소</button>
        <button class="btn btn-primary">생성</button>
      </div>
    </div>
  </div>
</div>
<!-- Modal Dialog 끝 -->

<!-- Alert 시작 -->
<div id="myModal2" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal-title-myModal2">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title" id="modal-title-myModal2">알림</h4>
      </div>
      <div class="modal-body">
        <p> 생성하시겠습니까? </p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-default" data-dismiss="modal">취소</button>
        <button class="btn btn-primary">확인</button>
      </div>
    </div>
  </div>
</div>
<!-- Alert 끝 -->

<!-- Confirm 시작 -->
<div id="myModal3" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal-title-myModal3">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"></button>
        <h4 class="modal-title" id="modal-title-myModal3">지정생성</h4>
      </div>
      <div class="modal-body">
        <p> 생성하시겠습니까? </p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-default" data-dismiss="modal">취소</button>
        <button class="btn btn-primary">생성</button>
      </div>
    </div>
  </div>
</div>
<!-- Confirm 끝 -->


