<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>
		<c:choose>
			<c:when test="${mode eq 'modify'}">게시물 수정</c:when>
			<c:when test="${mode eq 'reply'}">게시물 답변</c:when>
			<c:otherwise>새 게시물 작성</c:otherwise>
		</c:choose>
	</title>
	<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
	<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/dist/jstree.js"></script>
	<script type="text/javascript" src="/js/ezPMS/common.js"></script>	
	<script>
	var projectId = "${projectId}";
	var writerId = "${writerId}";
	var writerName = "${writerName}";
	var writerDeptName = "${writerDeptName}";
	
	var title = '${board.title}';
	
	var writeOverview = '${board.writeOverview}';
	var writeType = "${board.writeType}";
	var writeContent = '${writeContent.trim()}';
	var mode = "${mode}";
	var taskName;
	
	// 답변 달 때만 넘어오는 파라미터
	var rootItemId = "${rootItemId}";
	var itemLevel = "${itemLevel}";
	
	var groupId = "${groupId}";
	
	if(groupId == "") {
		groupId = "${board.groupId}";
	}
	
	var taskId = "${taskId}";
	
	if(taskId == "") {
		taskId = ("${board.taskId}" != "") ? "${board.taskId}" : null;
	}
	
	var itemId = "${param.itemId}";
	
	// 첨부파일 최대용량
	var AttachLimit = "${attachLimit}";
	
	// 버튼 중복클릭 방지
    var doubleSubmitFlag = false;
    
	window.onload = function() {
		
		$(window).unload(function() {
			cancelAddBoard();
		});
		
		// 수정 시 기존의 게시물 내용을 화면에 적용
		if(mode == 'modify') {
			var notice = $("#notice");
			var emergency = $("#emergency");
			switch(writeType) {
			case '1':
				notice.prop("checked","true");
				emergency.prop("checked","true");
				break;
			case '2':
				notice.prop("checked","true");
				break;
			case '3':
				emergency.prop("checked","true");
				break;
			}
			
			$('#title').val(title);
			$('#writeOverview').val(writeOverview);
			
			taskName = ('${board.taskName}' != '') ? '${board.taskName}' : '${board.groupName}';	
		} else if(mode == 'new') {
			
			taskName = '${taskName}';
			
		} else if(mode == 'reply') {
			
			taskName = ('${board.taskName}' != '') ? '${board.taskName}' : '${board.groupName}';	
			
			// 답변 작성 시에는 작업을 변경할 수 없다.
			$("#taskSelection").attr("onclick", "");
			$("#taskSelection").css("cursor", "default");
			
			$('#title').val(title);
		}
		
		$('#taskName').text(taskName);		
		
		var fileList = '${fileList}';
		
		if (fileList != null && fileList != "") {
			fileList = decodeURIComponent(fileList);
			dadiframe.setAttachFileInfo(fileList);
		}
	};
	
	function getTaskSelectionTree() {
		DivPopUpShow(320, 320, "/ezPMS/getTaskSelectionTree.do?projectId=" + projectId + "&onlyGroup=false");
	}
	
	function Editor_Complete() {
		
		if(mode == 'modify') {
			message.SetEditorContent(writeContent);
		} else if(mode == 'reply') {
			writeContent = ReplaceText(writeContent, "class=&quot;FIELD&quot;", "");
			writeContent = ReplaceText(writeContent, "class=FIELD", "");
			writeContent = ReplaceText(writeContent, "&amp;", "&");
			writeContent = ReplaceText(writeContent, "&lt;", "<");
			writeContent = ReplaceText(writeContent, "&gt;", ">");
			
			writeContent = "<body free>" + writeContent + "</body>";
			
			writeContent = "<br><br>-----<B>[&nbsp;"+"<spring:message code='ezBoard.t423' />"+"</B>-----<br><B>"+"<spring:message code='ezBoard.t424' />"+"</B>" + "${board.writeDate}" + "<br><B>"+"<spring:message code='ezBoard.t425' />"+"</B>" + "${board.writerName}" + "(" + "${board.writerPosition}" + "," + "${board.writerDeptName}" + ")<br><B>"+"<spring:message code='ezBoard.t413' />"+"</B>" + "<c:out value = '${boardListVO.title}' />" + "<br><br>" + writeContent;
			
			message.SetEditorContent(writeContent);
		}
	}
	
	function addBoard() {
	
		if (doubleSubmitFlag){
    		return;
    	}
		doubleSubmitFlag = true;
		
		var title = $("#title").val().trim();
		var writeContent = message.GetEditorContent();
		var writeOverview = $("#writeOverview").val().trim();
		
		// 긴급 게시 / 공지 사항 여부
		if($("#notice").is(":checked") == true) {
			
			if($("#emergency").is(":checked") == true) {
				writeType = 1; // 공지사항 O, 긴급게시 O
			} else {
				writeType = 2; // 공지사항 O, 긴급게시 X
			}
		} else {
			
			if($("#emergency").is(":checked") == true) {
				writeType = 3; // 공지사항 X, 긴급게시 O
			} else {
				writeType = 4; // 공지사항 X, 긴급게시 X
			}
		}
		
		if(title == "") {
			alert("제목을 입력해주십시오.");
			return;
		}
		
		//파일 첨부된 목록 가져오기
		var listtable = dadiframe.document.getElementById("filelist");
		var filelist = GetChildNodes(listtable);
		var fileList = "";
		
		for (var i = 0; i < filelist.length - 1; i++) {	
			
			if (i == 0) {
				fileList = GetAttribute(filelist[i + 1], "fileinfo");
			} else {
				fileList += "/" + GetAttribute(filelist[i + 1], "fileinfo");
    		}
		}
		
		data = {
			projectId : projectId,
			writerId : writerId,
			writerName : writerName,
			writerDeptName : writerDeptName,
			title : title,
			writeContent : writeContent,
			writeType : writeType,
			groupId : groupId,
			taskId : taskId,
			writeOverview : writeOverview,
			fileList : fileList,
			mode : mode,
			itemId : itemId,
			rootItemId : rootItemId,
			itemLevel : itemLevel
		}
	
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/addBoard.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				
				if(result.data == 'new' || result.data == 'modify' || result.data == 'reply') {
					alert("게시물을 저장하였습니다.");
					doubleSubmitFlag = false;
					
					if(result.data == 'new' || result.data == 'reply') {
						
						if(taskId == "null") {
							taskId = null;
						}
						
						opener.taskId  = taskId;
						opener.groupId = groupId;
						opener.currentPage = 1;
						
						// 검색 후 새 글을 등록했을 때 검색 조건을 초기화한다.
						opener.searchByTaskName = "";
						opener.searchByUser = "";
						opener.searchByStartDate = ""; 
						opener.searchByEndDate = "";
						opener.searchByTitle = "";
						opener.searchByOverview = "";
						opener.searchByContent = "";
						
						addTaskLog(projectId, 1, groupId, taskId, "[" + taskName.trim() + "](으)로 " + "[" + title.trim() + "] 게시물이 등록되었습니다.");
					} else {
						addTaskLog(projectId, 2, groupId, taskId, "[" + taskName.trim() + "](으)로 " + "[" + title.trim() + "] 게시물이 수정되었습니다.");
					}
					
					opener.getBoardList();
					window.close();
				} else {
					alert("저장에 실패하였습니다.");
					doubleSubmitFlag = false;
				}	
			},
			error : function() {
				alert("저장에 실패하였습니다.");
				doubleSubmitFlag = false;
			}
		});
	}
	
	// 파일을 첨부한 후 등록을 누르지 않고 닫기 버튼을 눌렀을 대 tempUploadFile폴더에 업로드된 파일들이 다시 삭제됨
	function cancelAddBoard() {
		var filecnt = dadiframe.document.getElementById("filelist").childNodes.length;
        var fileList = "";
        
        for (var i = 1; i < filecnt; i++) {
        	var pAttachDelFileName = dadiframe.document.getElementById("filelist").childNodes[i].getAttribute("fileInfo");
            
            if (fileList == "") {
				fileList = pAttachDelFileName;
			} else {
				fileList += "/" + pAttachDelFileName;
			}
        }
        
        $.ajax({
			async : false,
			url : "/ezPMS/uploadFileDelete.do",
            type : 'POST',
            dataType : 'text',
            data : {
            	fileList : fileList
            },
            success: function() {
            	window.close();
            },
            error: function(jqXHR, textStatus, errorThrown) {
            	alert("error");	
            }
		});
	}
	</script>
</head>
<body class="popup" style="height: 99%;">
	<table class="layout" style="width: 100%">
		<tr>
			<td style="height: 20px">
				<div id="menu">
					<ul>
						<li><span onclick="addBoard()">등록</span></li>
						<li style="float: right;"><span onclick="cancelAddBoard()">닫기</span></li>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<table class="content" style="width:100%;">
					<tr>
						<th>프로젝트명</th>
						<td style="width: 50%">
							<c:choose>
								<c:when test="${projectName eq null}">${board.projectName}</c:when>
								<c:otherwise>${projectName}</c:otherwise>
							</c:choose>		
						</td>
						<th>게시종류</th>
						<td><input type="checkbox" id="emergency"/> 긴급게시 <input type="checkbox" id="notice"/> 공지사항</td>
					</tr>
					<tr>
						<th><a class="imgbtn" id="taskSelection" onclick="getTaskSelectionTree()" style="margin-top: 2px;"><span>작업이름</span></a></th>
						<td style="width: 50%" id="taskName"></td>
						<th>등록자</th>
						<td>${writerName}(${writerDeptName})</td>
					</tr>
					<tr>
						<th>제&nbsp;&nbsp;목</th>
						<td colspan="3"><input type="text" id="title" style="width: 100%;"/></td>
					</tr>
					<tr>
						<th>게시개요</th>
						<td colspan="3"><input type="text" id="writeOverview" style="width: 100%;"/></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
            <td style="vertical-align: top; height: 455px">
                <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 98%; width: 100%; overflow: auto; margin-top:-1px"></iframe>
            </td>
        </tr>
        <tr>
			<td>
				<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px;" src="/ezPMS/dragAndDrop.do?mode=${mode}&projectId=${projectId}"></iframe>
			</td>
		</tr>
	</table>
	
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>