<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><spring:message code='ezPMS.t105' /></title>
	<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
	<script type="text/javascript">
		
		var itemId = '${board.itemId}';
		var rootItemId = '${board.rootItemId}';
		var itemLevel = '${board.itemLevel}';
		var userId = '${userId}';
		var writerId = '${board.writerId}';
		var authority = '${authority}'
		var projectId = '${board.projectId}';	
		var title = '<c:out value = "${board.title}"/>';
		var folderId = '${board.folderId}';
		var folderName = "";
		var projectName = '<c:out value = "${board.projectName}"/>';
		var itemIds = new Array(itemId); // 메인화면에서 여러개의 게시물을 한 번에 이동하는 함수를 재사용하기 위함
		
		$(function() {
			// 게시자이거나 담당자(authority = 1)인 경우만 수정/삭제/이동 버튼이 보임
			if(userId != writerId && authority != '1') {
				$("#modifyBtn").css("display", "none");
				$("#deleteBtn").css("display", "none");
				$("#moveBtn").css("display", "none");
			}
			
			// 조회자(authority = 3)인 경우, 답변버튼 사라짐
			if(authority == '3') {
				$("#ReplyBtn").css("display", "none");
			}
			
			/* var folderName = ${board.folderName};
			console.log(folderName);
			$("#folderName").text(replaceString(folderName)); */
		})
		// 첨부파일 모두 선택
		function attach_SelectAll() {
			var checkboxes = document.getElementById('lstAttachLink').getElementsByTagName("input");
			var checkboxesCount = checkboxes.length;
			
			for(var i = 0; i < checkboxesCount; i++) {
				checkboxes.item(i).checked = true;
			}
		}
		
		function attach_Download() {
			var checkboxes = $("input:checked");
			var i = 0;
			var checkboxesCount = checkboxes.length;
			
			if(!checkboxesCount) {
				alert("<spring:message code='ezPMS.t106' />");
			}
			
			var link = document.createElement('a');
			
			$(link).attr("display", "none");
			$(link).attr("href", "/ezPMS/downloadFile.do?filePath=" + checkboxes.eq(i).attr("data-filepath") 
													 + "&fileName=" + checkboxes.eq(i).attr("data-filename"));
			link.click();
													 
			var process = setInterval(function() {
				i++;
				
				if(i < checkboxesCount) {
					$(link).attr("href", "/ezPMS/downloadFile.do?filePath=" + checkboxes.eq(i).attr("data-filepath") 
							 + "&fileName=" + checkboxes.eq(i).attr("data-filename"));
					link.click();
				} else {
					clearInterval(process);
				}
			}, 1000);
		}
		
		function deleteBoard() {
			
			if(checkIfHasReplies(itemIds) == true) {
				alert("<spring:message code='ezPMS.t296' />");	
				return;
			}
			
			if(confirm("<spring:message code='ezPMS.t107' />") == true) {
				var items = new Array();
				items.push(itemId);
				deleteBoardAction(items);
			}	
		}
		
		function deleteBoardAction(itemIds) {
			var data = {
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
						window.close();
						opener.getBoardList();
						
						if (typeof(opener.getFolderTree() != undefined)) {
							opener.getFolderTree();
						}
						
					} else {
						alert("<spring:message code='ezPMS.t108' />");
					}
				},
				error : function() {
					alert("<spring:message code='ezPMS.t213' />");
				}
			})
		}
		
		function modifyBoard() {
			window.location.href = '/ezPMS/goAddBoard.do?itemId=' + itemId + '&projectId=' + projectId + '&mode=modify'
								+ '&folderId=' + folderId;
		}
		
		function goMoveBoard() {
			
			if(checkIfHasReplies(itemIds) == true) {
				alert("<spring:message code='ezPMS.t292' />");	
				return;
			}
			
			DivPopUpShow(320, 320, "/ezPMS/goMoveBoards.do?projectId=" + projectId + "&onlyGroup=false");
		}
		
		function checkIfHasReplies(itemIds) {
			
			var check;
			
			var data = {
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
		
		function boardViewerList(currentPage) {
			
			if (!currentPage) {
				currentPage = "";
			}
			
			var heigth = window.screen.availHeight;
	        var width = window.screen.availWidth;
	        var left = (width - 500) / 2;
	        var top = (heigth - 300) / 2;
	        
	        DivPopUpShow(600, 437, "/ezPMS/getBoardViewerList.do?itemId=" + itemId + "&currentPage=" + currentPage + "&projectId=" + projectId);
		}
		
		function fromPMSBoardToMail() {
			var pheight = window.screen.availHeight;
	        var conHeight = pheight * 0.8;
	        var pwidth = window.screen.availWidth;
	        var pTop = (pheight - conHeight) / 2;
	        var pLeft = (pwidth - 1200) / 2;
	        var szUrl = "/ezEmail/mailWrite.do?ezPMSProjectId=" + projectId + "&ezPMSBoardId=" + itemId + "&cmd=ezPMSBoard";
	        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
	        window.close();
		}
		
		function goAddBoardReply() {
			window.location.href = '/ezPMS/goAddBoard.do?itemId=' + itemId + '&projectId=' + projectId + '&mode=reply' + '&rootItemId=' + rootItemId 
								 + '&itemLevel=' + itemLevel + '&folderId=' + folderId;
		}
		
	 	var nowZoom = 100;
        var maxZoom = 200;
        var minZoom = 80;

        var MozNowZoom = 1;
        var MozMaxZoom = 2;
        var MozMinZoom = 0.8;
	        
		window.onload = function() {
			var doc = document.getElementById('message');
			
			document.getElementById('smaller').onclick = function () {
				Smaller(doc);
			}
			document.getElementById('bigger').onclick = function () {
				Bigger(doc);
			}
		}
		
		function Bigger(doc) {     
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                if (MozNowZoom < MozMaxZoom) {
                    MozNowZoom += 0.1;
                } else {
                    return;
                }
                
                $(doc).find('.contentDiv').css("MozTransform","scale(" + MozNowZoom + ")");
                $(doc).find('.contentDiv').css("MozTransformOrigin","0 0");
            } else {
                if (nowZoom < maxZoom) {
                    nowZoom += 10;
                } else {
                    return;
                }
                
                $(doc).find(".contentDiv").css("zoom",nowZoom + "%");
                $(doc).find("#curZoomSize").text(nowZoom + "%");
                $(doc).find("#curZoomSize").show();
                setTimeout(function(){$(doc).find("#curZoomSize").css("display","none")}, 1000);
            }
        }
        
        function Smaller(doc) {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                if (MozNowZoom > MozMinZoom) {
                    MozNowZoom -= 0.1;
                } else {
                    return;
                }

                $(doc).find('.contentDiv').css("MozTransform","scale(" + MozNowZoom + ")");
                $(doc).find('.contentDiv').css("MozTransformOrigin","0 0");
            } else {
                if (nowZoom > minZoom) {
                    nowZoom -= 10;
                } else {
                    return;
                }

                $(doc).find(".contentDiv").css("zoom",nowZoom + "%");
                $(doc).find("#curZoomSize").text(nowZoom + "%");
                $(doc).find("#curZoomSize").show();
                setTimeout(function(){$(doc).find("#curZoomSize").css("display","none")}, 1000);
            }
        }
	</script>
	<style type="text/css">
		.content {
			table-layout : fixed;
		}
		
		.content tr th {
			width : 20%;
		}
		
		.content tr td {
			text-overflow : ellipsis;
			overflow : hidden;
			white-space : nowrap;
		}
	</style>
</head>
<body class="popup" style="height: 98%; word-wrap: break-word;">
	<table class="layout" style="width: 100%">
		<tr>
			<td style="height: 20px">
				<div id="menu">
					<ul>
						<li id="ReplyBtn"><span onclick="goAddBoardReply()"><spring:message code='ezPMS.t109' /></span></li>
						<li id="modifyBtn"><span onclick="modifyBoard()"><spring:message code='ezPMS.t110' /></span></li>
						<li id="deleteBtn"><span onclick="deleteBoard()"><spring:message code='ezPMS.t11' /></span></li>
						<li id="moveBtn"><span onclick="goMoveBoard()"><spring:message code='ezPMS.t111' /></span></li>
						<li><span onclick="fromPMSBoardToMail()"><spring:message code='ezPMS.t112' /></span></li>
						<li><span onclick="boardViewerList()"><spring:message code='ezPMS.t113' /></span></li>
					</ul>
				</div>
				<div id="close" style="float:right">
					<ul>
						<li>
							<span id="cancel" onclick="window.close()"></span>
						</li>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<table class="content" style="width:100%;">
					<tr>
						<th><spring:message code='ezPMS.t114' /></th>
						<td><c:out value="${board.writerName}"/></td>
						<th><spring:message code='ezPMS.t214' /></th>
						<td><c:out value="${board.writerDeptName}"/></td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t216' /></th>
						<td><c:out value="${board.writerPosition}"/></td>
						<th><spring:message code='ezPMS.t117' /></th>
						<td><c:out value="${board.mobileNumber}"/></td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t340' /></th>
						<td id="folderName"><c:out value="${board.folderName}"/></td>
						<th><spring:message code='ezPMS.t119' /></th>
						<td><c:out value="${fn:substring(board.writeDate, 0, 19)}"/></td>
						
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t215' /></th>
						<td colspan="3"><c:out value="${board.title}"/></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="pad1" id="pad1" style="vertical-align: top; height: 100%;">
				<div id="message" style="border:1px solid #d1d1d1; padding: 8px; height: 528px; overflow: auto;">
					<div>
						<img src="/images/minus.png" title="글자작게" id="smaller" style="cursor:pointer;">
						<img src="/images/plus.png" title="글자크게" id="bigger" style="cursor: pointer;">
						<span id="curZoomSize" style="display:none; float:right;"></span>
					</div>
					<br />
					<br />
					<div class="contentDiv">
						${board.writeContent}
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: top; paddin-top: 5px;">
				<table class="file">
					<tr class="pos1">
						<th><spring:message code='ezPMS.t120' /></th>
						<td>
							<div id="lstAttachLink" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white; text-align: left">
								<c:forEach items="${board.fileList }" var="file">
									<div style="margin-top: 3px; height: 20px">
										<input type="checkbox" data-filename="${file.fileName}" data-filepath="${file.filePath}">
										<img src="/images/${file.fileType}.png"/>&nbsp; 
										<a href="/ezPMS/downloadFile.do?filePath=${file.filePath}&fileName=${file.fileName}">
											<c:out value="${file.fileName} (${file.fileTransSize})"/>
										</a>
										<br>
									</div>
								</c:forEach>
							</div>
						</td>
						<td class="pos2" style="white-space: normal; overflow: hidden;">
							<a class="imgbtn"><span style="width: 57px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a>
							<br /> 
							<a class="imgbtn"><span style="width: 57px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>