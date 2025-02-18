<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t484'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ErrorHandler_Cross.js')}"></script>
		<script  type="text/javascript" >
		    var eOneline = "false";
		    var eAttach = "false";
		    var pItemID = "<c:out value='${itemID}'/>";
		    var pBoardID = "${boardID}";
		    var gubun = "${gubun}";
		    var rvalue = new Array();
		    var ReturnFunction;
		    var oneLineReplyFlag = "${oneLineReplyFlag}";
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.boarditemview_cross_print_option_dialogArguments[1];
		        } catch (e) { }
		        GetAttachmentCount();
		        if (oneLineReplyFlag == "1" || oneLineReplyFlag == "2") {
		            getOneLineReplyCount();
		
		            if (eOneline != "true") {
		                document.getElementById('onl').disabled = true;
		            }
		        }
		        if (eAttach != "true") {
		            document.getElementById('att').disabled = true;
		        }
		        rvalue[0] = "0";
		        rvalue[1] = "0";
		
		        if (ReturnFunction == null)
		            window.returnValue = rvalue;
		    };
		    function GetAttachmentCount() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		        xmlhttp.open("POST", "/ezBoard/getItemAttachments.do?itemID=" + encodeURIComponent(pItemID), false);
		        xmlhttp.send();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        var i = 0;
		        var pos = 0;
		        var filename = "";
		        var filepath = "";
		        var strAttach = "";
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        if (xmldomNodes.length > 0)
		            eAttach = "true";
		    }
		    
		    // 2024-10-18 전인하 - 게시판 > 게시글 조회 > 게시글 인쇄 > 댓글 수 카운트 함수 사용 시 사용하는 컨트롤러 변경 (게시물 댓글 조회 컨트롤러 하나로 통일)
		    function getOneLineReplyCount() {
                $.ajax({
                    type : "POST",
                    async : false,
                    url : "/ezBoard/getBoardComment.do",
                    dataType : "json",
                    data : {
                        itemID : pItemID,
                        boardID : pBoardID,
                        gubun : gubun
                    },
                    success : function(result) { 
                        var commentCount = parseInt(result.totalCommentCount);
                        if (commentCount > 0) {
                            eOneline = "true";
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("<spring:message code='ezCommunity.t1052' />");
                        console.log(e);
                    },
                });
		    }
		    function all_click() {
		        if (eOneline == "true")
		            rvalue[0] = "Y";
		        else
		            rvalue[0] = "N";
		        if (eAttach == "true")
		            rvalue[1] = "Y";
		        else
		            rvalue[1] = "N";
		        
		        if(ReturnFunction != null) {
		        	ReturnFunction(rvalue);
					parent.printOption_close();
		        } else {
		        	window.returnValue = rvalue;
		        	window.close();	
		        }
		    }
		    function select_click() {
		        if (eOneline == "true") {
		            if (document.getElementById('onl').checked == true)
		                rvalue[0] = "Y";
		            else
		                rvalue[0] = "N";
		        }
		        else
		            rvalue[0] = "N";
		
		        if (eAttach == "true") {
		            if (document.getElementById('att').checked == true)
		                rvalue[1] = "Y";
		            else
		                rvalue[1] = "N";
		        }
		        else
		            rvalue[1] = "N";
		        
		        //2018-10-01 김민성 - 게시물 선택인쇄 확인 옵션 추가
		        if (rvalue[0] == "N" && rvalue[1] == "N") {
		    		alert("<spring:message code='ezCircular.t193'/>");
		    		return;
		    	} 
		        
		        if(ReturnFunction != null) {
		        	ReturnFunction(rvalue);
					parent.printOption_close();
		        } else {
		        	window.returnValue = rvalue;
		        	window.close();	
		        }
		    }
		    function only_click() {
		        rvalue[0] = "N";
		        rvalue[1] = "N";
		        if(ReturnFunction != null) {
		        	ReturnFunction(rvalue);
					parent.printOption_close();
		        } else {
		        	window.returnValue = rvalue;
		        	window.close();	
		        }
		    }
		    
		    /* 2019-02-23 홍승비 - 크롬 브라우저 버전업데이트 대응을 위해 unload시 동작 주석처리 */
/* 		    window.onunload = function () {
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		        else {
		            window.returnValue = rvalue;
		        }
		    } */
		    
		    function btn_close() {
		    	ReturnFunction = null;
				parent.printOption_close();
		    }
		
		</script>
		<style type="text/css" title="ezform_style_1">
		P {
				MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm
			}
		</style>
	</head>
	<body class="popup">
		<h1><spring:message code='ezBoard.t484'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="btn_close();"></span></li>
            </ul>
        </div>
		<h2 style="font-weight: normal">▒&nbsp;<spring:message code='ezBoard.t485'/></h2>
		<span id="pMessageContent"></span>
		<table class="content">
		<c:if test="${oneLineReplyFlag == '1' || oneLineReplyFlag == '2'}">
			<tr>
			    <th><input id='onl' name ='onl'  type='checkbox' /></th>
			    <td><span id="ext1">&nbsp;<spring:message code='ezBoard.jjh06'/></span></td>
			</tr>
		</c:if>
		<tr>
		    <th ><input id='att' name='att'  type='checkbox' /></th>
		    <td><span id="ext2">&nbsp;<spring:message code='ezBoard.t487'/></span></td>
		</tr>
		</table>
		          
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="Submit1" onClick="all_click()" ><span><spring:message code='ezBoard.t488'/></span></a>
		    <a class="imgbtn" id="Submit2" onClick="select_click()" ><span><spring:message code='ezBoard.t489'/></span></a>
		    <a class="imgbtn" id="Submit3" onClick="only_click()" ><span><spring:message code='ezBoard.t490'/></span></a>
		</div>
	</body>
</html>