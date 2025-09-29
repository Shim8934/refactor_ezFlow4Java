<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
	    <title><spring:message code='ezBoard.t1005'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<script type="text/javascript">
		    var pBoardID = "";
		    var pItemID = "";
		    var pTitle = "";
		    var pContent = "";
		    var pMode = "";
		    var isAllGroupBoard = "";
		    var useKeyword = ""; // 키워드 사용여부(Y/N)
		    var keywordArr = []; // 키워드 배열
		    var ReturnFunction;
		    
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.photoalbumedit_dialogArguments[1];
		            pBoardID = parent.photoalbumedit_dialogArguments[0][0];
		            pItemID = parent.photoalbumedit_dialogArguments[0][1];
		            pTitle = parent.photoalbumedit_dialogArguments[0][2];
		            pContent = parent.photoalbumedit_dialogArguments[0][3];
		            pMode = parent.photoalbumedit_dialogArguments[0][4];
		            isAllGroupBoard = parent.photoalbumedit_dialogArguments[0][5];
                    useKeyword = parent.photoalbumedit_dialogArguments[0][6];
                    keywordArr = parent.photoalbumedit_dialogArguments[0][7];
		        } catch (e) {
		            pBoardID = dialogArguments[0];
		            pItemID = dialogArguments[1];
		            pTitle = dialogArguments[2];
		            pContent = dialogArguments[3];
		            pMode = dialogArguments[4];
		            isAllGroupBoard = dialogArguments[5];
                    useKeyword = dialogArguments[6];
                    keywordArr = dialogArguments[7];
		        }
		
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                var input = document.getElementsByTagName("input");
		                for (var i = 0; i < input.length; i++) {
		                    if (input[i].getAttribute("type") == "text")
		                        KeEventControl(input[i]);
		                }
		            }
		        }
		        catch (e)
		        { }
		
		        if (pMode != "temp") {
		        	pMode = "add";
		        }
		        document.getElementById("title").value = pTitle;
		        document.getElementById("content").value = pContent;
		        if (useKeyword != null && useKeyword == "Y") {
		            document.querySelector('#keywordView').style.display = '';
                    for (let key of keywordArr) {
                        var keywordObj = makeKeywordSpanObj(key, "edit");
                        document.querySelector('#txtKeyword').before(keywordObj)
                    }
                }
		    };
		    
		    function updatealbum() {
		        var pTitle = document.getElementById("title").value;
		        var pContent = document.getElementById("content").value;
		        
		        if (!pTitle) {
		        	   alert("<spring:message code='ezBoard.t390'/>");
		        	   document.getElementById("title").focus();
		        	   return;
		        }
		
		        var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		
		        var strXML = "";
		        strXML = "<DATA>";
		        strXML += "<NODE>";
		        strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
		        strXML += "<ITEMID>" + pItemID + "</ITEMID>";
		        strXML += "<TITLE><![CDATA[" + pTitle + "]]></TITLE>";
		        strXML += "<CONTENT><![CDATA[" + pContent + "]]></CONTENT>";
                /* 2024-08-13 전인하 - 키워드 추가 */
                if (useKeyword != null && useKeyword == 'Y') {
                    strXML += "<KEYWORDS>";
                    for (var keyword of keywordArr) {
                        // createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "KEYWORD", keyword);
                        strXML += "<KEYWORD>" + keyword + "</KEYWORD>";
                    }
                    strXML += "</KEYWORDS>";
                }
		        strXML += "</NODE>";
		        strXML += "</DATA>";
		
		        xmldom.async = false;
		        xmldom.preserveWhiteSpace = true;
		        xmldom = loadXMLString(strXML);
		        
		        xmlhttp.open("POST", "/ezBoard/deleteImageItem.do?mod=" + pMode, false);
		        xmlhttp.send(xmldom);
		        
		        if (xmlhttp.responseText == "OK") {
		        	sendBoardAlert("modify", pBoardID, pItemID, isAllGroupBoard);
		        	
		            alert("<spring:message code='ezBoard.t1015'/>");
		            if (CrossYN())
		                ReturnFunction(xmlhttp.responseText);
		            else {
		                window.returnValue = xmlhttp.responseText;
		                window.close();
		            }
		        }
		        else {
		            alert("<spring:message code='ezBoard.t1016'/>");
		        }
		    }
		    function wclose() {
		        if(CrossYN())
		            parent.DivPopUpHidden();
		        else
		            window.close();
		    }
		    
		    /* 2021-06-22 홍승비 - 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendBoardAlert(pMode, pBoardID, pItemID, pIsAllGroupBoard) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/sendBoardAlert.do",
					data : {
						mode : pMode,
						boardID : pBoardID,
						itemID : pItemID,
						isAllGroupBoard : pIsAllGroupBoard
					}
				});
	        }
	        
		</script>
	</head>
	<body class="popup">
	    <table class="layout">
	        <tr style="height:50px">
	            <td style="vertical-align:top" >
	                <div id="menu">
	                    <ul>
	                        <li ID='btn_Modify' ><span onclick="updatealbum()"><spring:message code='ezBoard.t316'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li ><span onclick="wclose()"></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="vertical-align:top">
	                <table class="content">
	                    <tr>
	                        <th style="width:80px"><spring:message code='ezBoard.t291'/></th>
	                        <td style="width:100%"><input type="text" id="title" value="" style="width:100%;" maxlength="100" /></td>
	                    </tr>
	                    <!-- 키워드 시작 -->
                        <tr id='keywordView' style='display:none'>
                            <th><spring:message code="ezApprovalG.t1200" /></th>
                            <td colspan="3" id="keyWordResult">
                                <input type="text" id="txtKeyword" style="WIDTH: 20%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onblur="keyword_blur(event)" onkeyup="keyword_onkeyUp(event)" >
                            </td>
                        </tr>
                        <!-- 키워드 끝 -->
	                    <tr>
	                        <th style="width:80px"><spring:message code='ezQuestion.t180'/><spring:message code='ezCommunity.t18'/></th>
	                        <td style="width:100%;"><textarea id="content" style="height:100px;margin:2px;width:99%; resize:none;"></textarea></td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	</body>
</html>