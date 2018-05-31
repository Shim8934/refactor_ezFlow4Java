<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>업무 관련 게시물 페이지</title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>

<script type="text/javascript">
// 	var boardList;
	
// 	$(function(){
// 		boardList = ${boardList};
// 	});
	
 	var projectId = Number(parent.parent.projectId);
 	var projectName = null;
	var groupId = Number("${groupId}");
	var taskId = Number("${taskId}");
	var taskName = null;
	var currentPage = 1;
	var taskDetails = {};
		
	$(document).ready(function() {
		setInitData();
		currentHeight = $(window).height()-100;
		$("#projectContent").css("height", currentHeight + "px");
		$("#contentList").css("height", (currentHeight - 50) + "px");
		
		getBoardList();
	});
	
	function goAddBoard() {
		var feature = GetOpenPosition(790, 800);
		window.open("/ezPMS/goAddBoard.do?projectName=" + projectName + "&projectId=" + projectId + "&groupId=" + groupId 
										 + "&taskName=" + taskName  + "&taskId=" + taskId + "&mode=new", 
					"", "width=790, height=800, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function getBoardList() {
		var data = {
			projectId : projectId,
			groupId : groupId,
			taskId : taskId,
			currentPage : currentPage
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			dataType : "html",
			data : JSON.stringify(data),
			url : "/ezPMS/getBoardList.do",
			success : function(contentList) {
				$("#contentList").html(contentList);
			}	
		});
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page) {
		currentPage = page;
		getBoardList();
	}
	
	// 메인에서 체크박스로 선택 후 삭제할 때
	function deleteBoardsAction(itemIds) {
		data = {
			itemIds : itemIds,
			projectId : projectId
		}
		
		$.ajax({
			type : "DELETE",
			url : "/ezPMS/deleteBoard.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				if(result.data == 'success') {
					alert("삭제되었습니다.");
					getBoardList();
				} else {
					alert('삭제는 프로젝트 담당자나 게시자만 할 수 있습니다.');
				}	
			},
			error : function() {
				alert("삭제에 실패했습니다.");
			}
		})
	}
	
	// 조회 화면에서 삭제할 때
	function deleteBoardAction(itemIds) {
		data = {
			itemIds : itemIds,
			projectId : projectId
		}
		
		$.ajax({
			type : "DELETE",
			url : "/ezPMS/deleteBoard.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				if(result.data == 'success') {
					boardDetail.alert("삭제되었습니다.");
					boardDetail.close();
					getBoardList();
				} else {
					boardDetail.alert('삭제는 프로젝트 담당자나 게시자만 할 수 있습니다.');
				}
			},
			error : function() {
				alert("삭제에 실패했습니다.");
			}
		})
	}
	
	// 체크박스 전체선택 혹은 해제
	function selectAllTR(elem) {
		if($(elem).is(":checked")) {
			 $('input:checkbox[name="boardCheckbox"]').each(function() {
				 $(this).prop("checked","true");
				 $(this).parent().parent().addClass("selectedTR");
			 });
		} else {
			 $('input:checkbox[name="boardCheckbox"]').each(function() {
				 $(this).removeProp("checked","true");
				 $(this).parent().parent().removeClass("selectedTR");
			 });
		}
	}
	
	function setInitData(){
		taskDetails = JSON.parse(parent.document.querySelector("[name='frameParamTaskDetails']").value);
		projectName = taskDetails.projectName;
		taskName = taskDetails.taskName;
	}
</script>
<style type="text/css">
</style>
</head>
<body>
	<div id="projectContent">
		<div id="contentList"></div>
	</div>
</body>
</html>