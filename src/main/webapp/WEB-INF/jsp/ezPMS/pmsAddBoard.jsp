<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>
		<c:choose>
			<c:when test="${mode eq 'modify'}"><spring:message code='ezPMS.t71' /></c:when>
			<c:when test="${mode eq 'reply'}"><spring:message code='ezPMS.t72' /></c:when>
			<c:otherwise><spring:message code='ezPMS.t73' /></c:otherwise>
		</c:choose>
	</title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
	<script>
	var projectId = "${projectId}";
	var writerId = "${writerId}";
	var writerName = "${writerName}";
	var writerDeptName = "${writerDeptName}";
	
	var title = '<c:out value = "${board.title}"/>';
	
	var writeOverview = '<c:out value = "${board.writeOverview}"/>';
	var writeType = "${board.writeType}";
	var folderId = "${folderId}";
	var writeContent = '${writeContent.trim()}';
	var mode = "${mode}";
	var taskName;
	
	// 답변 달 때만 넘어오는 파라미터
	var rootItemId = "${rootItemId}";
	var itemLevel = "${itemLevel}";
	
	// 수정 및 답변 달 때 넘어오는 파라미터
	var itemId = "${param.itemId}";
	
	// 첨부파일 최대용량
	var AttachLimit = "${attachLimit}";
	
	// 버튼 중복클릭 방지
    var doubleSubmitFlag = false;
    
	$(function() {
		taskName = $("#taskName").text();
	});
	
	window.onload = function() {
		
		$(window).unload(function() {
			cancelAddBoard();
		});
		
		// 수정 시 기존의 게시물 내용을 화면에 적용
		if(mode == 'modify') {
			var notice = $("#notice");
			var emergency = $("#emergency");
			
			switch (writeType) {
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
			
			$('#title').val(replaceString(title));
			$('#writeOverview').val(replaceTextAreaString(writeOverview));
			
		} else if (mode == 'reply') {
			
			$('#title').val(replaceString(title));
		}
				
		var fileList = '${fileList}';
		
		if (fileList != null && fileList != "") {
			fileList = decodeURIComponent(fileList);
			dadiframe.setAttachFileInfo(fileList);
		}
		
		document.getElementById("title").focus();
	};
	
	function getTaskSelectionTree() {
		
		if (mode == 'modify') {
			var itemIds = new Array(itemId);
			
			if(checkIfHasReplies(itemIds) == true) {
				alert("<spring:message code='ezPMS.t292' />");	
				return;
			}
		}
		
		DivPopUpShow(320, 320, "/ezPMS/getTaskSelectionTree.do?projectId=" + projectId + "&onlyGroup=false");
	}
	
	function checkIfHasReplies(itemIds) {
		
		var check;
		
		data = {
			itemIds : itemIds
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/checkIfBoardHasReplies.do",
			dataType : "json",
			async : false,
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				check = result.data;
			}
		})
		
		return check;
	}
	
	function Editor_Complete() {
		
		if(mode == 'modify') {
			message.SetEditorContent(writeContent);
		} else if(mode == 'reply') {
			writeContent = ReplaceText(writeContent, "class=&quot;FIELD&quot;", "");
			writeContent = ReplaceText(writeContent, "class=FIELD", "");
			/* writeContent = ReplaceText(writeContent, "&amp;", "&");
			writeContent = ReplaceText(writeContent, "&lt;", "<");
			writeContent = ReplaceText(writeContent, "&gt;", ">"); */
			writeContent = revertString(writeContent);
			writeContent = replaceString(writeContent);
			writeContent = "<body free>" + writeContent + "</body>";
			
			/* 2025-12-04 노병훈 - 직위 없는 사용자가 작성자일때 ", " 제거 */
			var strWriterTitle = "${board.writerPosition}";
            var emptyTitleCheck = strWriterTitle.trim() == "" || strWriterTitle == null ? "" :  strWriterTitle + ", ";

			writeContent = "<br><br>-----<B>[&nbsp;"+"<spring:message code='ezBoard.t423' />"+"</B>-----"
						 + "<br><B><spring:message code='ezBoard.t424' />"+"</B>" 
						 + "&nbsp;${fn:substring(board.writeDate, 0, 16)}" 
						 + "<br><B>"+"<spring:message code='ezBoard.t425' />"+"</B>" 
						 + "&nbsp;${board.writerName}" + "(" + emptyTitleCheck + "${board.writerDeptName}" + ")"
						 + "<br><B><spring:message code='ezBoard.t413' />"+"</B>" 
						 + '&nbsp;<c:out value = "${board.title}"/>' + "<br><br>" + writeContent;
			
			message.SetEditorContent(writeContent);
		}
	}
	
	function addBoard() {
	
		if (doubleSubmitFlag) {
    		return;
    	}
		
		doubleSubmitFlag = true;
		
		var title = $("#title").val().trim();
		var writeContent = message.GetEditorContent();
		var writeOverview = $("#writeOverview").val().trim();
		
		// 긴급 게시 / 공지 사항 여부
		if ($("#notice").is(":checked") == true) {
			
			if ($("#emergency").is(":checked") == true) {
				writeType = 1; // 공지사항 O, 긴급게시 O
			} else {
				writeType = 2; // 공지사항 O, 긴급게시 X
			}
		} else {
			
			if ($("#emergency").is(":checked") == true) {
				writeType = 3; // 공지사항 X, 긴급게시 O
			} else {
				writeType = 4; // 공지사항 X, 긴급게시 X
			}
		}
		
		if (title == "") {
			alert("<spring:message code='ezPMS.t74' />");
			doubleSubmitFlag = false;
			return;
		}
		
		//파일 첨부된 목록 가져오기
		var listtable = dadiframe.document.getElementById("filelist");
		var filelist = GetChildNodes(listtable);
		var fileList = "";
		var filelistCount = filelist.length;
		
		for (var i = 0; i < filelistCount - 1; i++) {	
			
			if (i == 0) {
				fileList = GetAttribute(filelist[i + 1], "fileinfo");
			} else {
				fileList += "/" + GetAttribute(filelist[i + 1], "fileinfo");
    		}
		}
		
		var data = {
			projectId : projectId,
			writerId : writerId,
			writerName : writerName,
			writerDeptName : writerDeptName,
			title : title,
			writeContent : writeContent,
			writeType : writeType,
			folderId : folderId,
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
				
				if (result.data == 'new' || result.data == 'modify' || result.data == 'reply') {
					alert("<spring:message code='ezPMS.t75' />");
					doubleSubmitFlag = false;
					
					if (result.data == 'new' || result.data == 'reply') {
						opener.currentPage = 1;
						
						// 검색 후 새 글을 등록했을 때 검색 조건을 초기화한다.
						opener.searchByTaskName = "";
						opener.searchByUser = "";
						opener.searchByStartDate = ""; 
						opener.searchByEndDate = "";
						opener.searchByTitle = "";
						opener.searchByOverview = "";
						opener.searchByContent = "";	
					} 
					
					if (typeof opener.getBoardList == 'function') {
						opener.getFolderTree();
						opener.getBoardList();
					}
					
					window.close();
				} else {
					alert("<spring:message code='ezPMS.t208' />");
					doubleSubmitFlag = false;
				}	
			},
			error : function() {
				alert("<spring:message code='ezPMS.t208' />");
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
            	alert("<spring:message code='ezPMS.t213' />");	
            }
		});
	}
	</script>
	<style type="text/css">
		.content {
			table-layout : fixed;
		}
		
		.content tr th {
			width : 27%;
		}
		
		.content tr td {
			text-overflow : ellipsis;
			overflow : hidden;
			white-space : nowrap;
		}
	</style>
</head>
<body class="popup" style="height: 99%;">
	<table class="layout" style="width: 100%">
		<tr>
			<td style="height: 20px">
				<div id="menu">
					<ul>
						<li><span onclick="addBoard()"><spring:message code='ezPMS.t40' /></span></li>
					</ul>
				</div>
				<div id="close" style="float:right">
					<ul>
						<li>
							<span id="cancel" onclick="cancelAddBoard()"></span>
						</li>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<table class="content" style="width:100%;">
					<tr>
						<th><spring:message code='ezPMS.t31' /></th>
						<td>
							<c:out value="${projectName }"/>	
						</td>
						<th><spring:message code='ezPMS.t77' /></th>
						<td><input type="checkbox" id="emergency"/> <spring:message code='ezPMS.t78' /> <input type="checkbox" id="notice"/> <spring:message code='ezPMS.t79' /></td>
					</tr>
					<tr>
						<th>
							<c:choose>
								<%-- 답변/수정 작성 시에는 작업을 변경할 수 없다. --%>
								<c:when test="${mode eq 'reply' || mode eq 'modify'}">
									<spring:message code='ezPMS.t340' />
								</c:when>
								<c:otherwise>
									<a class="imgbtn" id="taskSelection" onclick="getTaskSelectionTree()" style="margin-top: 2px;">
										<span><spring:message code='ezPMS.t340' /></span>
									</a>
								</c:otherwise>
							</c:choose>	
						</th>
						<td id="folderName">
							<c:out value="${folderName }"/>
						</td>
						<th><spring:message code='ezPMS.t114' /></th>
						<td><c:out value="${writerName}(${writerDeptName})"/></td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t215' /></th>
						<td colspan="3"><input type="text" id="title" style="width: 100%;"/></td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t81' /></th>
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