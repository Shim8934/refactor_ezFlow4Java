<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>    
<!DOCTYPE html>
<html>
<head>
</head>
<body class="body_bg1">
	<article class="box_shadow">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet" style="<c:if test='${usedTheme == 3}'>border-bottom: 1px solid #D7E3E5;</c:if>">
			    <dt class="portletText"><spring:message code='ezNewPortal.pjg01'/></dt>
			    <dd class="portletPlus plus" id="ezWorkspacePlus"></dd>
			</dl>          
			<ul class="collaborate_tab" id="divSpaceListResults" style="overflow-y: auto; height: 204px;">
			</ul>
			<div class="collaborate_list">
			    <dl class="collaborate_listTab">
			        <dt onClick="workspaceChangeTab('newsTab')" id="newsTab" class="on"><spring:message code='ezWorkSpace.mjs01'/></dt>
			        <dt onClick="workspaceChangeTab('taskTab')" id="taskTab"><spring:message code='ezWorkSpace.mjs02'/></dt>
			        <dt onClick="workspaceChangeTab('documentTab')" id="documentTab"><spring:message code='ezWorkSpace.mjs03'/></dt>
			        <dt onClick="workspaceChangeTab('issueTab')" id="issueTab"><spring:message code='ezWorkSpace.mjs04'/></dt>
			    </dl>            
				<ul class="listtype_txt" id="divNewsfeedResults">
			    </ul>            	
			</div>
		</div> 
	</article>
	<script type="text/javascript" src="${workspaceContextRootUrl}/Scripts/moment.min.js"></script>	
   	<script type="text/javascript" src="${workspaceContextRootUrl}/Scripts/Groupwareapi.js"></script>
	<script type="text/javascript">
		var g_UserID = "${userId}"; // GW 사용자 Id, 가온누리 Java버전엔 이미 선언되어 있음
		var WorkspaceUrl = "${workspaceHostUrl}"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
		/* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace), 테넌트 컨피그 workspaceAppPath로 협업 웹응용프로그램 경로를 분리하여 사용 ("/" 또는 "/ezWork" 등) */
	    var workspaceAppPath = "${workspaceAppPath}";
		var g_bGroupwareUIType = false;  // 그룹웨어 UI 타입 => true: UIUX, false: Normal(예전 GW 화면)
		var feedListCount = 4;
		var g_bRayful = false;
		var g_bVisible = true; // 문서탭 선택 시 원문에 포함된 첨부파일 포함 여부 (false: 포함)		
		var g_ParentHref = false; // location.href를 parent 윈도우의 경로를 이동시킬지 여부 (true: parent 윈도우를 통해 이동)
		var g_bEzWorkspaceJava = true; // 협업 자바버전 변경을 위한 변수
		
		document.getElementById('ezWorkspacePlus').addEventListener('click', function() {
			window.open("${workspaceContextRootUrl}/Account/SSO", "main", "");
		});
	</script>	
</body>
</html>