<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html style="height: 99%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><c:out value="${project.projectName }" /></title>

<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript">
var projectId = "${project.projectId}";
var groupId = "${project.groupId}";

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
		$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskListMain.do?projectId=" + projectId + "&onlyGroup=true");
	});
	
	$("#1tab3").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//게시판으로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/getBoardMain.do?projectId=" + projectId + "&onlyGroup=false");
	});
	
	$("#1tab4").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskLogMain.do?projectId=" + projectId + "&onlyGroup=false");
	});
	
	$("#1tab5").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//의견으로 가는 부분 url 수정하기
		$("#FBoard_ifrm").attr("src", "/ezPMS/getCommentMain.do?projectId=" + projectId + "&onlyGroup=false");
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
	var response = confirm("<spring:message code='ezPMS.t24' />");
	
	if (response == true) {
		var data = {
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
					alert("<spring:message code='ezPMS.t25' />");
					$("#projectName").find("img").attr("src", "/images/ImgIcon/icon-flag.gif");
					$("#projectName").find("img").attr("onclick", "deleteFavorite(" + projectId + ")");
				
				} else {
					alert("<spring:message code='ezPMS.t26' />");
					return;
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}
}

function deleteFavorite(projectId) {
	var response = confirm("<spring:message code='ezPMS.t27' />");
	
	if (response == true) {
		var data = {
				status : "F",
				projectList : projectId
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/deleteFavoriteProject.do",
			data :JSON.stringify(data),
			success : function(result) {
				alert("<spring:message code='ezPMS.t28' />");
				$("#projectName").find("img").attr("src", "/images/ImgIcon/view-flag.gif");
				$("#projectName").find("img").attr("onclick", "addFavorite(" + projectId + ")");
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}	
}
</script>
<style>
	#pjName {
		font-size: 15px;
		font-weight: bold;
		padding-left: 5px;
		left: 7px;
		color: #333;
		height: 25px;
		line-height: 25px;
		max-width: 700px;
		overflow: hidden;
		white-space:nowrap;
		text-overflow:ellipsis;
		display: block;
		float: left;
	}
	
	#projectInfo, #projectInfo span{
		font-size: 15px;
	}
</style>
</head>
<body class="mainbody" style="height: 95%; overflow: hidden; margin-left:0px; margin-right: 0px;" marginwidth="0" marginheight="0" >
	<div id="test" style="padding-left:10px">
	<h1 id="projectName">
		<span id="pjName"><c:out value="${project.projectName}"/></span> 
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
		<span id="projectInfo">
			(
			<span id="projectProgress"><fmt:formatNumber value="${project.progress}" pattern="0.0"/>%</span>, 
			<span>
				D<c:out value="${project.restDueday - 1 < 0 ? '+'.concat(-(project.restDueday - 1)) : '-'.concat(project.restDueday - 1) }"/>, 
				<c:out value="${project.planStartDate}"/> ~ <c:out value="${project.planEndDate}"/>
			</span>
			)
		</span>
	</h1>
	<div class="portlet_tabpart01">
	   <div class="portlet_tabpart01_top" id="tab1">
	   		<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t66' /></span></p>
	  	 	<p id="FBoard_sub1"><span id="1tab1" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t151' /></span></p>
	  	 	<p id="FBoard_sub2"><span id="1tab2" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t152' /></span></p>
	 	  	<p id="FBoard_sub3"><span id="1tab3" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t141' /></span></p>
	 	  	<p id="FBoard_sub4"><span id="1tab4" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t153' /></span></p>
	   		<p id="FBoard_sub5"><span id="1tab5" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t154' /></span></p>
	   </div>
	</div>
	</div>
	<iframe id="FBoard_ifrm" name="project" style="width: 100%; height: 100%;" frameborder="0"></iframe>
</body>
</html>