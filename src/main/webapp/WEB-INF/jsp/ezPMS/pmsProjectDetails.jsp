<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height: 99%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/Tab.css" type="text/css">
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript">
$(function() {
	$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectOverview.do/"+"${projectId}");
	$("#1tab0").addClass("tabon");
	
	$("#1tab0").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		//개요
		$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectOverview.do/"+"${projectId}");
		
	});
	
	$("#1tab1").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//간트차트로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectForGantt.do?projectId=1");
	});
	
	$("#1tab2").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//업무리스트로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/taskListMain.do");
	});
	
	$("#1tab3").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//게시판으로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectBoard.do/${projectId}");
	});
	
	$("#1tab4").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskLogList.do");
	});
	
	$("#1tab5").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//의견으로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectOverview.do");
	});
	$(".tab").hover(function(){
		console.log($(this).attr("class"));
		$(this).addClass("tabover");
	},
		function(){
			$(this).removeClass("tabover");
	});
});

function changeTab(clickTabId, nowTabAttr) {
	$("#"+nowTabAttr).attr("class", "tab");
	$("#"+clickTabId).attr("class", "tabon");
}


</script>
</head>
<body class="mainbody" style="height: 95%; overflow: hidden" marginwidth="0" marginheight="0">
	<h1>Project Details : ${projectId }<span id="mailBoxInfo"> - total : 12</span></h1>
	<div class="portlet_tabpart01" style="margin-bottom: 10px">
	   <div class="portlet_tabpart01_top" id="tab1">
	   		<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab">overview</span></p>
	  	 	<p id="FBoard_sub1"><span id="1tab1" divname="FBoard_div0" class="tab">Gantt</span></p>
	  	 	<p id="FBoard_sub2"><span id="1tab2" divname="FBoard_div0" class="tab">Task List</span></p>
	 	  	<p id="FBoard_sub3"><span id="1tab3" divname="FBoard_div0" class="tab">Board</span></p>
	 	  	<p id="FBoard_sub4"><span id="1tab4" divname="FBoard_div0" class="tab">Task Log</span></p>
	   		<p id="FBoard_sub5"><span id="1tab5" divname="FBoard_div0" class="tab">Comment</span></p>
	   </div>
	</div>
	<iframe id="FBoard_ifrm" style="width: 100%; height: 100%;" frameborder="0"></iframe>
</body>
</html>