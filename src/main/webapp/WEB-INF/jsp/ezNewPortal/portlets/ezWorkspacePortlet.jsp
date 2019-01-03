<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>    
<!DOCTYPE html>
<html>
<head>
</head>
<body class="body_bg1">
	<article class="box_shadow">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet">
			    <dt class="portletText"><spring:message code='ezNewPortal.pjg01' /></dt>
			    <dd class="portletPlus" id="ezWorkspacePlus"><img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png"></dd>
			</dl>          
			<ul class="collaborate_tab" id="divSpaceListResults" style="overflow-y: auto; height: 204px;">
			</ul>
			<div class="collaborate_list">
			    <dl class="collaborate_listTab">
			        <dt onClick="workspaceChangeTab('newsTab')" id="newsTab" class="on">뉴스피드</dt>
			        <dt onClick="workspaceChangeTab('taskTab')" id="taskTab">할일</dt>
			        <dt onClick="workspaceChangeTab('documentTab')" id="documentTab">문서</dt>
			        <dt onClick="workspaceChangeTab('issueTab')" id="issueTab">이슈</dt>
			    </dl>            
				<ul class="listtype_txt" id="divNewsfeedResults">
			    </ul>            	
			</div>
		</div> 
	</article>
	<script type="text/javascript" src="http://space.kaoni.com/myoffice/ezWorkspace/Scripts/moment.min.js"></script>	
   	<script type="text/javascript" src="http://space.kaoni.com/myoffice/ezWorkspace/Scripts/Groupwareapi.js"></script>
	<script type="text/javascript">
		var g_UserID = "${userId}"; // GW 사용자 Id, 가온누리 Java버전엔 이미 선언되어 있음
		var WorkspaceUrl = "http://space.kaoni.com"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
		var g_bGroupwareUIType = false;  // 그룹웨어 UI 타입 => true: UIUX, false: Normal(예전 GW 화면)
		var feedListCount = 4;
		var g_bRayful = false;
		var g_bVisible = true; // 문서탭 선택 시 원문에 포함된 첨부파일 포함 여부 (false: 포함)		
		var g_ParentHref = false; // location.href를 parent 윈도우의 경로를 이동시킬지 여부 (true: parent 윈도우를 통해 이동)
		
		document.getElementById('ezWorkspacePlus').addEventListener('click', function() {
			window.open("http://space.kaoni.com/myoffice/ezWorkspace/Account/SSO", "main", "");
		});
	</script>	
</body>
</html>