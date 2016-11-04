<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t335'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script>
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
			window.offscreenBuffering = true;
			var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
			var curFontSize = 1;
			var pItemID = "${itemID}";
			var pBoardID= "${boardID}";
			var pBoardName = "${boardInfo.boardName}";
		    var eOneline = "${oneLine}";
		    var eAttach = "${attach}";
			var strWriterID = "${boardItem.writerID}";
			var strWriterName = "${boardItem.writerName}";
			var strWriterDeptName = "${boardItem.writerDeptName}";
			var strWriterCompanyName = "${boardItem.writerCompanyName}";
			var strWriteDate = "${boardItem.writeDate}";
			var strImportance = "${boardItem.importance}";
			var strEndDate = "${boardItem.endDate}";
			var strContentLocation = "${boardItem.contentLocation}";
			var strAttachList = "${boardItem.attachments}";
			var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.displayName}";
			var	Access_FG = "${boardInfo.access_FG}";
			var	BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
			var	ListView_FG = "${boardInfo.listView_FG}";
			var	Read_FG = "${boardInfo.read_FG}";
			var	Write_FG = "${boardInfo.write_FG}";
			var	Reply_FG = "${boardInfo.reply_FG}";
			var	Delete_FG = "${boardInfo.delete_FG}";
			var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
			var pReservedItem = "${reservedItem}";
			var OneLineReplyFlag = "${oneLineReplyFlag}";
		    var gubun = "${boardInfo.guBun}";
		
		    var myVar;
		    window.onload = function () {
		    	var html = "";
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { type   : "BOARDCONTENT", 
							 itemID 	 : pItemID
						   },
					success: function(result){
						html = result;
					}        			
				});	
		        var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();
				
		        if (eOneline == "Y")
		            document.getElementById('onelineView').style.display = "";
		        if (eAttach == "Y")
		            document.getElementById('attachView').style.display = "";
		
		        SetAttachmentInfo();
		        if (OneLineReplyFlag == "1") getOneLineReply();
		
		        myVar = setInterval(function () { DocumentComplate(); }, 2000);
		       
		    };
		
		    function DocumentComplate() {
// 		        if (!CrossYN()) {
// 		            preview_print();
// 		        }
// 		        else{
		            window.print();
// 		        }
		
		        clearInterval(myVar);
		    }
		
		    function preview_print() { //미리보기 기능 선언
		        var OLECMDID = 7; //7이 미리보기,6이 인쇄,8이 페이지설정
		        var PROMPT = 1;
		        var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
		        document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
		        WebBrowser1.ExecWB(OLECMDID, PROMPT);
		        WebBrowser1.outerHTML = "";
		        return false;
		    }
		
		    function btnClose_onclick() {
		        window.close();
		    }
		
		    function SetAttachmentInfo() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		        xmlhttp.open("POST", "/ezBoard/getItemAttachments.do?itemID=" + pItemID, false);
		        xmlhttp.send();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        var filename = "";
		        var strAttach = "";
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
		            filename = filepath.substr(109, filepath.length - 108);
		            filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
		            strAttach = strAttach + filename + "&nbsp;(" + filesize + ")<br>";
		        }
		        document.getElementById('lstAttachLink').innerHTML = strAttach;
		    }
		    function OpenUserInfo(pUserID) {
		        var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
		    }
		    function getOneLineReply() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/readOneLineReply.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
		        xmlhttp.send();
		        var xmldom = createXmlDom();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        var strHTML = "";
		        var temp;
		        for (var i = 0; i < xmldom.getElementsByTagName("REPLYID").length; i++) {
		            temp = i + 1;
		                strHTML += "<font color=blue>" + temp.toString() + ". " + "<span><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + "<br>";
		        }
		        if (i == 0)
		            strHTML = "<spring:message code='ezBoard.t312'/>";
		        document.getElementById('onelinereplylist').innerHTML = strHTML;
		    }
		    function displaytable() {
		        if(message.document.body.innerHTML != "")
		            document.getElementById("contenttable").innerHTML = message.document.body.innerHTML;
		    }
		</script>
	</head>
	<body style="padding-top:10px; padding-left:10px; padding-right:10px;">
		<table class="layout" >  
		  <tr>
		    <td>
		        <table class="content" style="width:100%;">
		            <tr>
	                  <th style="width:10%; text-align:center"><spring:message code='ezBoard.t223'/></th>
	                  <td id="WriteUserNM" style="width:20%; white-space:nowrap">&nbsp;<c:out value="${boardItem.writerName}"/></td>
	                  <th style="width:10%; text-align:center"><spring:message code='ezBoard.t224'/></th>
	                  <td id="PostDate" style="width:25%; white-space:nowrap">&nbsp;${boardItem.writeDate}</td>
	                  <th style="width:10%; text-align:center"><spring:message code='ezBoard.t288'/></th>
	                  <c:set var="t287" value="<spring:message code='ezBoard.t287'/>"/>
	                  <c:choose>
		                  <c:when test="${boardItem.endDate == t287}">
			                  <td id="EndDate" style="padding-right:15px; width:25%;">&nbsp;<spring:message code='ezBoard.t287'/></td>
		                  </c:when>
		                  <c:otherwise>
			                  <td id="EndDate" style="padding-right:15px; width:25%;">&nbsp;${boardItem.endDate.split(' ')[0]}</td>
		                  </c:otherwise>
	                  </c:choose>
		            </tr>
		            <tr>
	                  <th style="width:10%; text-align:center"><spring:message code='ezBoard.t289'/></th>
	                  <td id="User_DeptNM" style="width:20%; white-space:nowrap">&nbsp;${boardItem.writerDeptName}</td>
	                  <th style="width:10%; text-align:center"><spring:message code='ezBoard.t290'/></th>
	                  <td id="User_JobTitle" style="width:25%; white-space:nowrap;">${boardItem.extensionAttribute3}<div></div></td>
	                  <th style="width:10%; text-align:center;"><spring:message code='ezBoard.t38'/></th>
	                  <td id="Telephone" style="width:25%; white-space:nowrap">&nbsp;${boardItem.extensionAttribute4}</td>
		            </tr>
		            <tr>
	                  <th style="text-align:center"><spring:message code='ezBoard.t291'/></th>
	                  <td id="cTitle" style="WORD-WRAP: break-word;" colspan="6">&nbsp;${boardItem.title} </td>
		            </tr>
		      </table>
		    </td>
		  </tr>
		  </table>
		  <table class="layout" style="margin-top:5px;">
		  <tr>
		    <td class="pad1" style="display:none;">
		        <iframe id="message" name="message" style="height:100%; width:100%" onload ="displaytable()"></iframe>
		    </td>
		  </tr>
		    <tr>
		    <td class="pad1" style="height:100%;">
		        <div id ="contenttable" class ="viewbox"></div>
		    </td> 
		  </tr>
		  </table>
		  <table class="layout" style="margin-top:5px;">
		      <tr id="onelineView" style="display:none;">
		        <td style="height:30px">
		          <table class="file2" style="height:100%;">
		            <tr>
		              <th style="height:100%; "><spring:message code='ezBoard.t324'/></th>
		              <td style="height:100%; width:100%; "><div id="onelinereplylist" style="OVERFLOW:visible;  background-color:white; text-align:left"></div></td>
		            </tr>
		          </table>
		        </td>
		      </tr>
		  </table>
		  <table class="layout" style="margin-top:5px;">
		      <tr id="attachView" style="display:none;">
		        <td style="height:20px" class="pad1">
		          <table class="file2" style="height:100%">
		            <tr>
		              <th style="height:100%; "><spring:message code='ezBoard.t292'/></th>
		              <td style="width:100%; height:100%; "><div id="lstAttachLink" style="padding-top:3px;padding-bottom:3px;padding-left:3px;OVERFLOW:visible;  background-color:white; text-align:left"></div></td>
		              <td id="ItemLevel" style="display:none"></td>
		            </tr>
		          </table>
		        </td>
		      </tr>
		</table>
	</body>
</html>