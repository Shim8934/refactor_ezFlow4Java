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
var projectId = "${project.projectId}";

$(function() {
	$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectOverview.do?projectId="+projectId);
	$("#1tab0").addClass("tabon");
	
	$("#1tab0").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		//개요
		$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectOverview.do?projectId="+projectId);
		
	});
	
	$("#1tab1").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//간트차트로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectForGantt.do?projectId=" + projectId);
	});
	
	$("#1tab2").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//업무리스트로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/taskListMain.do?projectId=" + projectId);
	});
	
	$("#1tab3").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//게시판으로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/getProjectBoard.do?projectId=" + projectId);
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
		$("#FBoard_ifrm").attr("src", "/ezPMS/getComment.do");
	});
	$(".tab").hover(function(){
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

function addFavorite(projectId) {
	var response = confirm("프로젝트를 즐겨찾기 하시겠습니까?");
	if (response == true) {
		data = {
				status : "F",
				projectList : projectId
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/addFavoriteProject.do",
			data :JSON.stringify(data),
			success : function(result) {
				if (result == "0") {
					alert("프로젝트가 즐겨찾기 되었습니다.");
					$("#projectName").find("img").attr("src", "/images/ImgIcon/icon-flag.gif");
					$("#projectName").find("img").attr("onclick", "deleteFavorite(" + projectId + ")");
				
				} else {
					alert("이미 추가된 프로젝트 입니다.");
					return;
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}
}

function deleteFavorite(projectId) {
	var response = confirm("프로젝트를 즐겨찾기 해제하시겠습니까?");
	if (response == true) {
		data = {
				status : "F",
				projectList : projectId
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/deleteFavoriteProject.do",
			data :JSON.stringify(data),
			success : function(result) {
				alert("즐겨찾기가 해제되었습니다.");
				$("#projectName").find("img").attr("src", "/images/ImgIcon/view-flag.gif");
				$("#projectName").find("img").attr("onclick", "addFavorite(" + projectId + ")");
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}	
}
</script>
</head>
<body class="mainbody" style="height: 95%; overflow: hidden" marginwidth="0" marginheight="0">
	<h1 id="projectName">
		<c:out value="${project.projectName }" />
		<c:choose>
			<c:when test="${project.isFavorite eq 0}">
				<img class="star" style="cursor: pointer; width:17px; vertical-align:text-top;" draggable="false" src="/images/ImgIcon/view-flag.gif"
					onclick="addFavorite(${project.projectId })">
			</c:when>
			<c:otherwise>
				<img class="star" style="cursor: pointer; width:17px; vertical-align:text-top;" draggable="false" src="/images/ImgIcon/icon-flag.gif"
					onclick="deleteFavorite(${project.projectId })">
			</c:otherwise>
		</c:choose>
	</h1>
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