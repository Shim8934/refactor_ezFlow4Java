<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezNewPortal.t048' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet"  href="${util.addVer('/js/dist/themes/default/style.min.css')}" type="text/css">

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/dist/jstree.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<style type="text/css">
#boardTreeArea {border:1px solid #ddd;padding:1px 0px 1px 1px; background-color:#fff;height:485px;overflow-x:hidden;overflow-y:auto;word-break:break-all}
#TopBoards tr:first-child h2 {border-top:0px;}
#TopBoards {width:100%;}
.jstree-container-ul {margin:10px 0px;}
</style>
</head>
<body class="popup">
	<h1><spring:message code='ezNewPortal.t048' /></h1>
	<div id="close"><ul><li><span></span></ul></div>
	<div id="boardTreeArea">
		<table id="TopBoards">
		<c:forEach items="${boardList }" var="board" varStatus="status">
			<tr>
				<td>
					<h2 class="boardTop off" id="board${status.index }" data1="${board.id}"><span><c:out value="${board.text }"/></span></h2>
				</td>
			</tr>
			<tr>
				<td>
					<div id="boardSub${status.index }" class="boardSub"></div>
				<td>
			</tr>
		</c:forEach>
		</table>
	</div>
	<div id="selBoard" class="btnposition btnpositionNew"><a class="imgbtn"><span><spring:message code='ezNewPortal.t049' /></span></a></div>
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
    </div>
<script type="text/javascript">
var board_alertArguments = new Array();
var portletCode = "<c:out value="${portletCode}"/>"
var portletBoardId = "<c:out value="${portletBoardId}"/>"
var portletBoardGroupID = "<c:out value="${portletBoardGroupID}"/>"
var findBoard = false;

$(function(){
	$("#close").on("click", function(){
		window.close();
	});
	
	eventSetting();

	/* 2025-01-23 김유진 - 게시판그룹명 > div -> li 기존 게시판 id 찾기 */
	if (portletBoardId !== "" && portletBoardGroupID !== "" ) {
		var h2s = document.getElementById("TopBoards").getElementsByClassName("boardTop");
		for (var i = 0 ; i < h2s.length ; i++) {
			if (h2s[i].getAttribute("data1") == portletBoardGroupID) {
				LoadTreeViewByPath(h2s[i], portletBoardId, portletBoardGroupID);
			}
		}
		return;
	}
});

function LoadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID) {
	pObjSpan.click();
	setTimeout(function() {
		divId = pObjSpan.getAttribute("id").replace("board", "boardSub");
		var lis = document.getElementById(divId).getElementsByClassName("jstree-node");
	
		var cnt = lis.length;
		for (var i = 0; i < cnt; i++) {
			if (findBoard) {
				break;
			}
			
			if (portletBoardId === lis[i].getAttribute("id")) {
				document.getElementById(portletBoardId + "_anchor").click();
				findBoard = true;
				break;
			}
			else {
				// 하위 게시판들에서 기존 게시판 id 찾기
				clickUntilLeaf(lis[i]);
			}
		}
	}, 900);
}

function clickUntilLeaf(node) {
	if (!node.classList.contains("jstree-leaf")) {
		var jstreeOcl = node.querySelector("i.jstree-ocl");
		if (jstreeOcl) {
			jstreeOcl.click();
			var childNodes = node.querySelectorAll("ul > li");
			for (var i = 0; i < childNodes.length; i++) {
				if (findBoard) {
					break;
				}
				if (portletBoardId === childNodes[i].getAttribute("id")) {
					if (document.getElementById(portletBoardId + "_anchor")) {
						document.getElementById(portletBoardId + "_anchor").click();
					}
					findBoard = true;
					break;
				} else {
					// 하위 게시판들에서 기존 게시판 id 찾기
					clickUntilLeaf(childNodes[i]);
					// 열려있어야 하위 폴더트리 사용 가능, 다 사용 후 닫아주기
					if (!findBoard && i === childNodes.length-1) {
						jstreeOcl.click();
					}
				}
			}
		}
	}
}

var eventSetting = function() {
	$("#selBoard").on("click", selectBoard);
	
	var boardIdList = $(".boardTop");
	var boardIdListCount = boardIdList.length;
	
	for (var i = 0; i < boardIdListCount; i++) {
		var boardId = boardIdList[i].id;
		boardId = $("#" + boardId).attr("data1");
		$("#board" + i).on("click", {"boardId" : boardId, "boardIndex" : i}, getSubBoards)
	}
}

var selectBoard = function(event) {
	board_alertArguments[1] = DivPopUpHidden;
	
	if ($(".jstree").length == 0) {
    	var url = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezNewPortal.t050' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezNewPortal.t050' />") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
		DivPopUpShow(330, 205, url);
		return;
	} else {
		var selBoard = $("li[aria-selected='true']");
		
		if (selBoard.length == 0) {
	    	var url = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezNewPortal.t050' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezNewPortal.t050' />") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
			DivPopUpShow(330, 205, url);
			return;
		} else {
			var portletId = "<c:out value='${portletId}'/>";
			var gubun = selBoard.attr("gubun");
		
			if ((portletId == 9 || portletCode == "mPhotoboard") && (gubun != 3 && gubun != 4)) {
		    	var url = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezNewPortal.t051' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezNewPortal.t051' />") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
				DivPopUpShow(330, 205, url);
				return;
			}
			/* 2018-11-09 홍승비 - 동영상게시판 게시판선택 분기 임시 추가 */
			else if (portletId == 47 && (gubun != 7)) {
		    	var url = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezNewPortal.t052' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezNewPortal.t052' />") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
				DivPopUpShow(330, 205, url);
				return;
			}
			
			var boardName = selBoard.find(".jstree-clicked").text();
			selBoard = selBoard.attr("id");
			
			if (portletId == "null") {
				window.opener.document.getElementById("newPortletBoard").value = boardName;
				window.opener.document.getElementById("newPortletBoard").setAttribute("value", boardName);
				window.opener.document.getElementById("newPortletBoard").setAttribute("data1", selBoard);
			} else {
				window.opener.document.getElementById("portletBoard" + portletId).value =  boardName;
				window.opener.document.getElementById("portletBoard" + portletId).setAttribute("value", boardName);
				window.opener.document.getElementById("portletBoard" + portletId).setAttribute("data1", selBoard);
			}

			// 게시판 포틀릿 형태 관련 on off
			if (!!window.opener.switchBoardViewTypeRow) {
				var id = portletId !== "null" ? portletId : "";
				window.opener.switchBoardViewTypeRow(id, false);
				window.opener.resetBoardUrl(id);
				if (gubun == 0) {
					window.opener.switchBoardViewTypeRow(id, true);
				}
			}
			
			window.close();
		}
	}
}

var getSubBoards = function(event) {
	var nowBoardTree = $(".jstree").attr("id");

	var parentBoardId = event.data.boardId;
	var boardIndex = event.data.boardIndex;
	
	$(".jstree").jstree('destroy');
	
	
	if (nowBoardTree == "boardSub" + boardIndex) {
		$("#board" + boardIndex).attr("class", "boardTop off");
	} else {
		$(".boardTop").attr("class", "boardTop off");
		$("#board" + boardIndex).attr("class", "boardTop on");
		
		var companyId = "<c:out value='${companyId}'/>";
		
		var request = new XMLHttpRequest();
		request.open('POST', '/admin/ezNewPortal/getSubBoards.do', true);
		request.setRequestHeader('content-type', 'application/json');
		
		request.onload = function() {
			if (request.status >= 200 && request.status < 400) {
				var result = JSON.parse(request.responseText);
				
				$("#boardSub" + boardIndex).jstree({
					'core' : {
						'data' : result,
						'multiple' : false,
						'animation' : 0
					},
					'plugins' : ['sort', 'wholerow', 'types'],
					'sort' : function (a, b) {
						var compare1 = this.get_node(a);
						var compare2 = this.get_node(b);
						
						return (compare1.sort > compare2.sort)? -1 : 1;
					},
					'types' : {
						'default' : {
							'icon' : "/images/OrganTree_cross/fldr.gif"
						}
					}
				}).on("ready.jstree", function(){
					var resultCount = result.length;
					
					for (var i = 0; i < resultCount; i++) {
						var board = result[i];
						var boardId = board.id.replace("}", "\\}");
						if (board.boardColor != null && board.boardColor != "#000000") {
							//board.id.querySelectorAll("jstree-anchor").style.color = board.boardColor;
							$("#\\" + boardId + "").find(".jstree-anchor").css("color", board.boardColor);
						}
						
						$("#\\" + boardId + "").attr("gubun", board.gubun);
					}
				}).on("open_node.jstree", function(){
					var resultCount = result.length;
					
					for (var i = 0; i < resultCount; i++) {
						var board = result[i];
						var boardId = board.id.replace("}", "\\}");
						if (board.boardColor != null && board.boardColor != "#000000") {
							//board.id.querySelectorAll("jstree-anchor").style.color = board.boardColor;
							$("#\\" + boardId + "").find(".jstree-anchor").css("color", board.boardColor);
						}
						
						$("#\\" + boardId + "").attr("gubun", board.gubun);
					}
				});
			}
		}
		
		request.onerror = function() {}
		
		var data = JSON.stringify({
			parentBoardId : parentBoardId,
			companyId : companyId
		});
		 
		request.send(data);
	}
}
</script>
</body>
</html>