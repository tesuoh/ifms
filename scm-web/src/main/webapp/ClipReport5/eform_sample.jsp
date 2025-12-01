<%@page import="com.clipsoft.clipreport.oof.connection.OOFConnectionMemo"%>
<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="java.io.File"%>
<%@page import="com.clipsoft.clipreport.server.service.ReportUtil"%>
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
OOFDocument oof = OOFDocument.newOOF();
//불러올 리포트 지정
OOFFile file = oof.addFile("crf.root", "%root%/crf/eform_sample.crfe");



%><%@include file="Property.jsp"%><%
//세션을 활용하여 리포트키들을 관리하지 않는 옵션
//request.getSession().setAttribute("ClipReport-SessionList-Allow", false);
String resultKey =  ReportUtil.createEForm5(request, oof,  propertyPath);

//리포트의 특정 사용자 ID를 부여합니다.
//clipreport4.properties 의 useuserid 옵션이 true 일 때만 적용됩니다. 
//clipreport4.properties 의 useuserid 옵션이 true 이고 기본 예제[String resultKey =  ReportUtil.createEForm5(request, oof, propertyPath);] 사용 했을 때 세션ID가 userID로 사용 됩니다.
//String resultKey =  ReportUtil.createEForm5(request, oof, propertyPath, "userID");

//리포트를 저장 스토리지를 지정하여 생성합니다.
//String resultKey =  ReportUtil.createEForm5ByStorage(request, oof, propertyPath, "rpt2");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>EForm</title>
<meta name="viewport" content="width=800, user-scalable=no">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="./css/clipreport.css">
<link rel="stylesheet" type="text/css" href="./css/eform.css">
<link rel="stylesheet" type="text/css" href="./css/UserConfig.css">
<link rel="stylesheet" type="text/css" href="./css/font.css">
<script type='text/javascript' src='./js/jquery-3.7.1.js'></script>
<script type='text/javascript' src='./js/clipreport.js'></script>
<script type='text/javascript' src='./js/UserConfig.js'></script>
<script type='text/javascript'>
var urlPath = document.location.protocol + "//" + document.location.host;
var eform =  "";
function html2xml(divPath){	
    var eformkey = "<%=resultKey%>";
	eform = createImportJSPEForm("./Clip.jsp", eformkey, document.getElementById(divPath));

    eform.setStyle("close_button","display:none;");
    eform.setStyle("save_button","right:10px;");

    eform.setNecessaryEnabled(true);
    /*
	eform.setEndSaveButtonEvent(function (){
		alert(JSON.stringify(eform.getEFormData()));
	});
	*/
	eform.view();
}

</script>
</head>
<body onload="html2xml('targetDiv1')">
<div id='targetDiv1' style='position:absolute;top:5px;left:5px;right:5px;bottom:5px;'></div>
</body>
</html>
