<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezAttitude.t111'/></title>
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
			#mailBoxInfo {
				font-weight: normal;
    			color: #666;
			}
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
				
				$(document).on('click', 'table.mainlist th', function(){
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
	    			
	    			$("table.mainlist th").find("img").remove();
	    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
	    			
	    			getAbsentedList();
	    		});
			});
			
	    	function getAbsentedList() {
				if (searchEndDate == '') {
					var resultHtml = "<tr id='List_TR_noItems'><td colspan='3' style='text-align:center'><spring:message code='ezAttitude.t138' /></td></tr>";
					$("#contentlist table.mainlist tbody").append(resultHtml);
					
					return;
				}
	    		
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
						$("#mailBoxInfo").html(" - [<spring:message code='ezAttitude.t76'/><span style='color:#017BEC;'> " + result.totalCount + " </span><spring:message code='ezAttitude.t78'/>]");
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
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='3' style='text-align:center'><spring:message code='ezAttitude.t138' /></td></tr>";	
	    		}
	    		
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    	}
			
			function btnSendMail_onclick() { 
				/* $.ajax({
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
				}); */
				var pheight = window.screen.availHeight;
				var conHeight = pheight * 0.8;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - conHeight) / 2;
				var pLeft = (pwidth - 890) / 2;
				var szUrl = "/ezEmail/mailWrite.do?cmd=attitudeAbsented&companyId=" + companyId + "&userName=&deptName=&title=&deptId=" + searchDeptId + "&startDate=" + searchStartDate + "&endDate=" + searchEndDate + "&pageNum=&listSize=&orderCell=" + orderCell + "&orderOption=" + orderOption;
					
				window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height=" + conHeight + "px, width=890px, status=no, toolbar=no, menubar=no, location=no, resizable=1");
				window.close();
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
		<h1><spring:message code='ezAttitude.t111'/><span id="mailBoxInfo"></span><c:if test="${searchEndDate != ''}"><img style="float: right; margin-right: 5px; margin-top:1px; cursor: pointer;" src="/images/poll/sendMail01.png" onclick="btnSendMail_onclick()"></c:if></h1>
		<table class="mainlist" style="width:100%;">
			<thead>
				<tr>
					<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="startdate"><spring:message code='ezAttitude.t133'/></th>
					<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname"><spring:message code='ezAttitude.t10'/></th>
					<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title"><spring:message code='ezAttitude.t11'/></th>
					<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description"><spring:message code='ezAttitude.t9'/></th>
				</tr>
			</thead>
		</table>
		<div id="contentlist" style="height:550px; overflow-y: auto;">
			<table class="mainlist" style="width:100%;">
				<tbody></tbody>
			</table>
		</div>
		
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"><span onclick="return btnClose_onclick()"><spring:message code='ezAttitude.t157'/></span></a>
		</div>
	</body>
</html>