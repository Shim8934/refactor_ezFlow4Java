<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezPMS/common.js")%>"></script>
<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezPMS/jstree.js")%>"></script>
<script type="text/javascript">
	var currentPage = 1;
	var listNumber = 20;
	var projectSort = 0;
	var orderWhat = "init";
	var orderHow = "";
	
	// 검색을 위한 파라미터
	var searchByProjectName = "";
	var searchByOverview = "";
	var listProjectStatus = "A";
	
	// REST 재사용을 위한 dummy 파라미터. 여기선 사용되지 않음
	var searchByUser = "";

	$(function() {
		getProjectList();
		
	})
	
	function getProjectList() {
		
		var data = {
			currentPage : currentPage,
			listNumber : listNumber,
			searchByProjectName : searchByProjectName,
			searchByOverview : searchByOverview,
			listProjectStatus : listProjectStatus,
			projectSort : projectSort,
			orderWhat : orderWhat,
			orderHow : orderHow,
			
			searchByUser : searchByUser
		}
		
			$.ajax({
				type : "POST",
				contentType: "application/json; charset=UTF-8",
				dataType : "html",
				data : JSON.stringify(data),
				url : "/admin/ezPMS/getProjectList.do",
				success : function(contentList) {
					$("#contentList").html(contentList);
					
					setInitOrder();
				}	
			});
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page) {
		currentPage = page;
		getProjectList();
	}
	
	function setInitOrder() {
		$("table.mainlist th").each(function() {
			if (orderWhat == $(this).attr("data-order")) {
				if (orderHow == 'asc') {
					$(this).attr("data-sort", "asc");
					$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
				} else if (orderHow == 'desc') {
					$(this).attr("data-sort", "desc");
					$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
				}
			}
		});

		boardListScroll();
	}
	
	function boardListScroll() {
		var thWidth = document.getElementById("tableHeader").clientWidth
				- document.getElementById("tableBody").clientWidth;
		if (thWidth > 0) {
			$("#BoardList_TH").append('<th style=width:2px;></th>');
		}
	}
	
	//헤더 리스트 셋팅
	function setListOrder(elem){
		orderWhat = $(elem).attr("data-order");
		orderHow = $(elem).attr("data-sort");
		
		if(orderHow == null){
			orderHow='asc';
		} else if(orderHow == 'asc'){
			orderHow='desc';
		} else if(orderHow == 'desc'){
			orderHow='asc';
		}
		
		getProjectList();
	}
	
	function viewListByStatus(elem) {
		listProjectStatus = elem;
		searchByProjectName = "";
		searchByOverview = "";
		currentPage = 1;
		
		getProjectList();
	}
	
	function searchProject() {
		listProjectStatus = "A";	
		var searchCondition = $("#searchCondition option:selected").val();
		var searchKeyword = $("#searchKeyword").val();
		
		if(searchCondition == "searchByProjectName") {
			searchByProjectName = searchKeyword;
			searchByOverview = "";
		} else if(searchCondition == "searchByOverview") {
			searchByProjectName = "";
			searchByOverview = searchKeyword;
		}
		
		currentPage = 1;
		getProjectList();
	}
	
	function setSearchInput(elem) {
		if(elem == "listProjectStatus") {
			$("#searchKeyword").css("display", "none");
			$("#searchBtn").css("display", "none");
			$("#listByStatus").css("display", "");
		} else {
			$("#searchKeyword").css("display", "");
			$("#searchBtn").css("display", "");
			$("#listByStatus").css("display", "none");
		}
	}
	
	function getProjectGeneralInfo(projectId) {
		var feature = GetOpenPosition(650, 470);
		window.open("/admin/ezPMS/getProjectGeneralInfo.do?projectId=" + projectId, "", 
					"width=650, height=470, resizable=no, scrollbars=no, status=no" + feature);
	}
</script>
</head>
<body class="mainbody">
	<h1><spring:message code="ezPMS.t235"/></h1>
	<select id="searchCondition" onchange="setSearchInput(this.value)">
		<option value="searchByProjectName"><spring:message code="ezPMS.t31"/></option>
		<option value="searchByOverview"><spring:message code="ezPMS.t236"/></option>
		<option value="listProjectStatus"><spring:message code="ezPMS.t38"/></option>
	</select>
	<input id="searchKeyword" type="text" onkeypress="if(event.keyCode==13) {searchProject(); return false;}"/>
	<a class="imgbtn" id="searchBtn" onclick="searchProject()" style="margin-left:3px;"><span><spring:message code="ezPMS.t1"/></span></a>
	<select id="listByStatus" onchange="viewListByStatus(this.value)" style="display: none;">
		<option value="A"><spring:message code="ezPMS.t271"/></option>
		<option value="P"><spring:message code="ezPMS.t258"/></option>
		<option value="W"><spring:message code="ezPMS.t260"/></option>
		<option value="C"><spring:message code="ezPMS.t261"/></option>
		<option value="L"><spring:message code="ezPMS.t262"/></option>
		<option value="S"><spring:message code="ezPMS.t259"/></option>
		<option value="D"><spring:message code="ezPMS.t263"/></option>
	</select>
	
	<div id="contentList" style="overflow: auto; margin-top: 10px;">
		<span id="MailListRayer"
			style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
		</span>
	</div>
</body>
</html>