<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script>
 	var projectId = ${projectId};
 	var projectName = null;
	var groupId = null;
	var taskId = null;
	var taskName = null;
	var currentPage = 1;
	var treeData = JSON.parse('${data}');
		
	$(document).ready(function() {
		
		currentHeight = $(window).height()-100;
		$("#taskTree").css("height", currentHeight + "px");
		$("#projectContent").css("height", currentHeight + "px");
		$("#contentList").css("height", (currentHeight - 50) + "px");
		
		getProjectTaskTree("taskTree", treeData, false);
		getBoardList();
		
		$("#taskTree").on("click", ".jstree-anchor", function() {
			taskName = $(this).text();
			if($(this).parent().attr("id").charAt(0) == 't') { 
				groupId = $(this).parents("li").eq(1).attr("id");
				taskId = $(this).parent().attr("id").substr(1);
			} else {
				groupId = $(this).parent().attr("id");
				taskId = null;
			}
			currentPage = 1;
			getBoardList();
		});
		
		// 여기 다른 방법으로 할 순 없을지 고민해봐야함. 근데 아무리 해도 모르겠음
		setTimeout(function() {
			var project = $("li[role='treeitem'][aria-level='1']");
			groupId = project.attr("id");
			projectName = project.children("a").text();
			taskName = projectName;
		}, 100);
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
</script>

<script>
	var boardDetail;
	
	$(function() {
		$("#divList").css("height", (currentHeight - 100) + "px");
		
		$("tbody tr td:not(.checkbox)").on("click", function(evt) {
			var checkbox = $(this).parent().children("td:eq(0)").children();
			$('input:checkbox[name="boardCheckbox"]').each(function() {
				$(this).removeProp("checked","true");
				$(this).parent().parent().removeClass("selectedTR");
			});
			
			checkbox.prop("checked", "true");
			selectTR(checkbox);
		});
		
		$("tbody tr").on("dblclick", function() {
			goBoardDetail(this);
		});
		
		$(".mainlist th:not(.checkboxHeader)").on("click", function() {
			
		});
	})
	
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
	
	function selectTR(elem) {
		if($(elem).is(":checked")) {
			$(elem).parent().parent().addClass("selectedTR");
		} else {
			$(elem).parent().parent().removeClass("selectedTR");
		}
	}
	
	// 게시판 상세 화면
	function goBoardDetail(elem) {
		var itemId = $(elem).attr("data-itemId");
		$(elem).removeClass("noView");
		var feature = GetOpenPosition(790, 800);
		boardDetail = window.open("/ezPMS/getBoardDetail.do?projectId=" + projectId + "&itemId=" + itemId, "", 
								  "width=790, height=800, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function deleteBoards() {
		var checkBoxes = $('input:checked[name="boardCheckbox"]');
		if(!checkBoxes.length) {
			alert("삭제할 글을 선택하세요.");
			return;
		}
		
		if(confirm("정말 삭제하시겠습니까?") == true) {
			var itemIds = new Array();
			checkBoxes.each(function() {
				var itemId = $(this).parents("tr").eq(0).attr("data-itemid");
				itemIds.push(itemId);		
			});
			deleteBoardsAction(itemIds);
		}	
	}
	
	function moveBoards() {
		var checkBoxes = $('input:checked[name="boardCheckbox"]');
		if(!checkBoxes.length) {
			alert("이동할 글을 선택하세요.");
			return;
		}
		var itemIdsURI = "";
		
		checkBoxes.each(function() {
			var itemId = $(this).parents("tr").eq(0).attr("data-itemid");
			itemIdsURI += ("&itemIds=" + itemId);	
		});
		
		DivPopUpShow(320, 320, "/ezPMS/goMoveBoard.do?projectId=" + projectId + "&onlyGroup=false" + itemIdsURI);
	}
</script>

<style>
	#taskTree {
		margin-right : 5px;
		width : 16%;
		overflow : auto;
		border : 1px solid #d1d1d1;
		float : left;
		display : inline-block
	}
	
	#projectContent {
		width : 83%;
		overflow : auto;
		border : 1px solid #d1d1d1;
	}
	
	#contentList {
		width : 98%;
		margin-left : 1%;
		margin-top : 15px;
	}
</style>

</head>
<body>
	<div id="taskTree"></div>
	<div id="projectContent">
		<div id="contentList"></div>
	</div>
</body>
</html>