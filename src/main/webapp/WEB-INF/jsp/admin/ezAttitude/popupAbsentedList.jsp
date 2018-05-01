<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>미입력자 목록조회</title>
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
	</head>
	
	<script type="text/javascript">
		var companyId = "${companyId}";
		var searchUserName = "${searchUserName}";
		var searchDeptName = "${searchDeptName}";
		var searchTitle = "${searchTitle}";
		var searchStartDate = "${searchStartDate}";
		var searchEndDate = "${searchEndDate}";
		var pageNum = 1; // 페이지 ==> 초기값 설정
    	var totalCount = "" // 게시물 총 갯수
    	var totalPage = ""; // 게시판의 총 페이지갯수
    	var orderCell = ""; // 정렬 명
    	var orderOption = ""; // 정렬 형식(ASC, DESC)
		
		$(function() {
			getAbsentedList();
		});
    	
    	function getAbsentedList() {
    		$.ajax({
				type : "post",
				dastaType : "json",
				async : false,
				url : "/admin/ezAttitude/getAbsentedList.do",
				data : {
					companyId : companyId,
   					userName : searchUserName,
   					deptName : searchDeptName,
   					title : searchTitle,
   					startDate : searchStartDate,
   					endDate : searchEndDate,
   					orderCell : orderCell,
   					orderOption : orderOption
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
    			resultHtml += "<td>" + vo.deptName + "</td></tr>";
    		});
    		
    		if (resultHtml == "") {
    			resultHtml = "<tr><td colspan='3' style='text-align:center'>미입력자가 없습니다.</td></tr>";	
    		}
    		
    		$("#contentlist table.mainlist tbody").append(resultHtml);
    	}
		
		//메일
		function btnSendMail_onclick() {
			$.ajax({
   				type:"post",
   				dataType:"text",
   				async : false,
   				url:"/admin/ezAttitude/sendMail.do",
   				data:{
   					companyId : pCompanyId,
   					userName : searchUserName,
   					deptName : searchDeptName,
   					title : searchTitle,
   					searchStartDate : searchStartDate,
   					searchEndDate : searchEndDate,
   					pageNum : pageNum,
   					listSize : listSize,
   					orderCell : orderCell,
   					orderOption : orderOption
   				},
   				success: function(result){
					if (result == "ok") {
						alert("성");
	   					window.close();
					} else {
						alert("실");
	   					window.close();
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
	
	<body class="popup">
		<h1>미입력자 목록</h1>
		
		<table id="searchTable" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 3%;">부서</td>
					<td style="width: 12%;"><input type="text" id="searchDeptName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;">이름</td>
					<td style="width: 12%;"><input type="text" id="searchUserName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;">직위</td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50" onkeypress="searchPress()"></td>
				</tr>
				<tr>
					<td style="width: 3%;">검색기간</td>
					<td>
						<input type="text" id="Sdatepicker" style="width:80px;text-align:center"/> ~
						<input type="text" id="Edatepicker" style="width:80px;text-align:center"/>
					</td>
					<td style=" width:*;" colspan=4>
						<a class="imgbtn"><span onclick="searchUserConfList('search');">검색</span></a>&nbsp;
						<a class="imgbtn"><span onclick="searchUserConfList('refresh');">새로고침</span></a>&nbsp;
					</td>
				</tr>
			</tbody>
		</table>
		
		<div id="contentlist">
			<table class="mainlist">
				<thead>
					<tr>
						<th>이름</th>
						<th>직위</th>
						<th>부서</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
		
		<div class="btnposition">
			<a class="imgbtn"><span onclick="return btnSendMail_onclick()">메일발송</span></a>
			<a class="imgbtn"><span onclick="return btnClose_onclick()">닫기</span></a>
		</div>
	</body>
</html>