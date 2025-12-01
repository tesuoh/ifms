<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>


<script type="text/javascript">
    //document.location.href="${pageContext.request.contextPath}/cmn/app/login.do"
    // 서버 사이드 리디렉션: 즉시 지정된 URL로 이동
    response.sendRedirect(request.getContextPath() + "/cmn/app/login.do");
</script>
