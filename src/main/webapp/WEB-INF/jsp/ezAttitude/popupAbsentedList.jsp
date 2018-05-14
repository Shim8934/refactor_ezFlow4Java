<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>미입력자 팝업</title>
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
		
		<style>
			#searchTable {
				border-top: 1px solid #e8e8e8;
				border-left: 1px solid #e8e8e8;
				border-right: 1px solid #e8e8e8;
				background-color: #fcfcfc;
			}
			#searchTable td {padding: 8px 5px;}
		</style>
		
		<script type="text/javascript">
			var companyId = "${companyId}";
			var searchUserName = "";
			var searchDeptName = "";
			var searchTitle = "";
			var searchDeptId = "${searchDeptId}";
			var searchStartDate = "${searchStartDate}";
			var searchEndDate = "${searchEndDate}";
			var pageNum = 1;
	    	var totalCount = "";
	    	var totalPage = "";
	    	var orderCell = "";
	    	var orderOption = "";
			
			$(function() {
				getAbsentedList();
				
				$(document).on('click', '#contentlist table.mainlist th', function(){
	   				if (!$(this).find("img").length) {
	   					src = "";
	   					orderOption = "";
	   					orderCell = $(this).attr("colname");
	   				}
	   			
	    			if (orderOption == "" || orderOption == "DESC") {
	    				src = '/images/etc/view-sortup.gif';
	    				orderOption = "ASC";
	    			} else {
	    				src = '/images/etc/view-sortdown.gif';
	    				orderOption = "DESC";
	    			}
	    			
	    			$("#contentlist table.mainlist th").find("img").remove();
	    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
	    			
	    			getAbsentedList();
	    		});
			});
			
	    	function getAbsentedList() {
	    		$.ajax({
					type : "post",
					dastaType : "json",
					async : false,
					url : "/admin/ezAttitude/getAttitudeAbsentedList.do",
					data : {
						companyId : companyId,
	   					userName : "",
	   					deptName : "",
	   					title : "",
	   					deptId : searchDeptId,
	   					startDate : searchStartDate,
	   					endDate : searchEndDate,
	   					pageNum : "",
	   					listSize : "",
	   					orderCell : orderCell,
	   					orderOption : orderOption,
	   					duplicated : "duplicated"
					},
					success : function(result) {
						getAbsentedList_after(result.list);
					}
					
				});
	    	}
	    	
			function getAbsentedList_after(result){
	    		var resultHtml = "";
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr userid='" + vo.writerId + "'>";
	    			resultHtml += "<td>" + vo.startDate + "</td>";
	    			resultHtml += "<td>" + vo.userName + "</td>"
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.deptName + "</td></tr>";
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='3' style='text-align:center'><spring:message code='ezAttitude.lhj23' /></td></tr>";	
	    		}
	    		
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    	}
			
			function btnSendMail_onclick() {
				$.ajax({
					type : "POST",
					async : true,
					url : "/ezAttitude/absentedListSendMail.do",
					data : {
						companyId : companyId,
	   					userName : "",
	   					deptName : "",
	   					title : "",
	   					startDate : "",
	   					endDate : "",
	   					deptId : searchDeptId
					},
					success : function(result) {
						if (result == "ok") {
							alert("메일이 발송되었습니다.");
						} else {
							alert("메일 발송에 실패하였습니다.");
						}
					}
				});
			}
			
			function btnClose_onclick() {
				window.close();
			}
			
			function searchPress(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	getAbsentedList();
		            }
		        } else {
		            if (evt.which == 13)
		            	getAbsentedList();
		        }
		    }
		</script>
	</head>
	
	<body class="popup">
		<h1>미입력자 목록</h1>
		<table class="mainlist" style="width:100%;">
			<thead>
				<tr>
					<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname">이름</th>
					<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title">직위</th>
					<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description">부서</th>
					<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="startdate">일자</th>
				</tr>
			</thead>
		</table>
		<div id="contentlist" style="height:550px; overflow-y: auto;">
			<table class="mainlist" style="width:100%;">
				<tbody></tbody>
			</table>
		</div>
		
		<div class="btnposition">
			<c:if test="${searchEndDate != ''}"><a class="imgbtn"><span onclick="return btnSendMail_onclick()">메일발송</span></a></c:if>
			<a class="imgbtn"><span onclick="return btnClose_onclick()">닫기</span></a>
		</div>
	</body>
</html>