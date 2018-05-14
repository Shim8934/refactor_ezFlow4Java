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
	   					pageNum : pageNum,
	   					listSize : listSize,
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
	    			resultHtml += "<tr userid='" + vo.userId + "'>";
	    			resultHtml += "<td>" + vo.userName + "</td>";
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.deptName + "</td>";
	    			resultHtml += "<td>" + vo.startDate + "</td></tr>"
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='3' style='text-align:center'>ë¯¸ìë ¥ìê° ììµëë¤.</td></tr>";	
	    		}
	    		
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    	}
			
			function btnSendMail_onclick() {
// 				sendMail.do 만들어논거 태우게 
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
			
			function exportExcel() {
				if ($('#contentlist table.mainlist tbody tr').eq(0).attr('id') == 'List_TR_noItems') {
					alert('엑셀다운');
					return;
				}
				
		    	exportExcelframe.location.href="/admin/ezAttitude/excelAbsentedListExport.do?companyId=" + companyId + "&userName=" + searchUserName + "&deptName=" + searchDeptName + "&title=" + searchTitle + "&deptId=" + searchDeptId + "&startDate=" + searchStartDate + "&endDate=" + searchEndDate + "&orderCell=" + orderCell + "&orderOption=" + orderOption + "&duplicated=duplicated";
		    	exportExcelframe.target="_blank";
			}
		</script>
	</head>
	
	<body class="popup">
		<h1>미입력자 목록</h1>
		<div id="contentlist">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname">이름</th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title">직위</th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description">부서</th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="startdate">일자</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
		
		<div class="btnposition">
			<a class="imgbtn"><span onclick="return btnSendMail_onclick()">메일발송</span></a>
			<a class="imgbtn"><span onclick="exportExcel();">엑셀다운</span></a>
			<a class="imgbtn"><span onclick="return btnClose_onclick()">닫기</span></a>
		</div>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>