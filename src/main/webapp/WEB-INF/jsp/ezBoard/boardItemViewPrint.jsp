<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t335'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style>
	        .viewbox {
				line-height:20px;
			}
			p {
				margin-top: 0px;
				margin-bottom: 0px;
			}
    	</style>
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
		    var AtttributeCount = "${boardAttrCount}";
		
		    var myVar;
		    window.onload = function () {
		    	var html = "";
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { type   : "BOARDCONTENT", 
							 itemID 	 : pItemID,
							 href   : strContentLocation 
						   },
					success: function(result){
						html = result;
					}        			
				});	
		        var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();
				
		        if (eOneline == "Y") {
		            document.getElementById('onelineView').style.display = "";
		        }
		        
		        if (eAttach == "Y") {
		            document.getElementById('attachView').style.display = "";
		        }
		
		        SetAttachmentInfo();
		        if (OneLineReplyFlag == "1") {
		        	getOneLineReply();
		        }
		        
		        myVar = setInterval(function () { DocumentComplate(); }, 2000);
		       
		    };
		
		    function DocumentComplate() {
		        if (CrossYN()) {
		            window.print();
		        } else {
		            preview_print();
		        }
		
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
		            filename = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
		            filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
		            strAttach = strAttach + filename + "&nbsp;(" + filesize + ")<br>";
		        }
		        document.getElementById('lstAttachLink').innerHTML = strAttach;
		    }
		    
		    /* 2018-06-29 홍승비 - 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		    function OpenUserInfo(pUserID, pDeptID) {
		        var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
		    }
		    function getOneLineReply() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/readOneLineReply.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&gubun=" + gubun, false);
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
	<!-- 2018-02-01 김보미 - 게시물 상세 테이블 컬럼 조정. -->
	<body style="padding-top:10px; padding-left:10px; padding-right:10px;">
		<table class="layout" >  
		  <tr>
		    <td>
		        <table class="content" style="width:100%;">
		        	<!-- 게시자&부서 -->
		        	<tr>
		        		<th style="width:10%;"><spring:message code='ezBoard.t223'/></th>
						<td id="WriteUserNM" style="width:40%; white-space:nowrap">&nbsp;<c:out value="${boardItem.writerName}"/></td>
						<th style="width:10%;"><spring:message code='ezBoard.t289'/></th>
						<td id="User_DeptNM" style="width:40%; white-space:nowrap">&nbsp;${boardItem.writerDeptName}</td>
		        	</tr>
		        	<!-- 직위&사내전화 -->
		        	<tr>
		        		<th><spring:message code='ezBoard.t290'/></th>
						<td id="User_JobTitle" style="width:40%; white-space:nowrap;">&nbsp;${boardItem.extensionAttribute3}<div></div></td>
						<th><spring:message code='ezPersonal.t177'/></th>
						<td id="Telephone" style="width:40%; white-space:nowrap">&nbsp;${boardItem.extensionAttribute4}</td>
		        	</tr>
		        	<!-- 게시일&게시종료일 -->
		        	<tr>
						<th><spring:message code='ezBoard.t224'/></th>
		        		<td id="PostDate" style="width:40%; white-space:nowrap">&nbsp;${boardItem.writeDate}</td>
						<th><spring:message code='ezBoard.t288'/></th>
						<c:set var="t287" value="<spring:message code='ezBoard.t287'/>"/>
						<c:choose>
							<c:when test="${boardItem.endDate == t287}">
								<td id="EndDate" style="padding-right:15px; width:40%;">&nbsp;<spring:message code='ezBoard.t287'/></td>
							</c:when>
							<c:otherwise>
								<td id="EndDate" style="padding-right:15px; width:40%;">&nbsp;${boardItem.endDate.split(' ')[0]}</td>
							</c:otherwise>
						</c:choose>
		        	</tr>
		        	<!-- 확장컬럼 -->
						<c:if test="${boardAttrCount > 0}">
							<c:forEach var="boardAttr" items="${boardAttr}">
								<tr>
									<c:choose>
										<c:when test="${extenLang == '1'}">
							                <th>${boardAttr.colName1}</th>
										</c:when>
										<c:otherwise>
							                <th>${boardAttr.colName2}</th>
										</c:otherwise>
									</c:choose>
					                <td colspan="5">
					                	<c:choose>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute6'}">
					                			&nbsp;${boardItem.extensionAttribute6}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute7'}">
					                			&nbsp;${boardItem.extensionAttribute7}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute8'}">
					                			&nbsp;${boardItem.extensionAttribute8}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute9'}">
					                			&nbsp;${boardItem.extensionAttribute9}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute10'}">
					                			&nbsp;${boardItem.extensionAttribute10}
					                		</c:when>
					                		<c:otherwise></c:otherwise>
					                	</c:choose>
					                </td>
					            </tr>
							</c:forEach>
						</c:if>
					<!-- 제목 -->
		            <tr>
	                  <th><spring:message code='ezBoard.t291'/></th>
	                  <td id="cTitle" style="WORD-WRAP: break-word;" colspan="6">&nbsp;${boardItem.title} </td>
		            </tr>
		      </table>
<!-- 		<table class="layout">  -->
<!-- 		  <tr>  -->
<!-- 		    <td style="height:20px"><table class="content">  -->
<!-- 		        <tr>  -->
<%-- 		          <th><spring:message code='ezBoard.t207'/></th>  --%>
<!-- 		          <td id="WriteUserNM" style="white-space:nowrap; width:200px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;cursor:pointer"></div></td>  -->
<%-- 		          <th><spring:message code='ezBoard.t224'/></th>  --%>
<!-- 		          <td id="PostDate" style="padding-right:10px; white-space:nowrap; width:300px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;"></div></td>  -->
<%-- 		          <th><spring:message code='ezBoard.t288'/></th>  --%>
<!-- 		          <td id="EndDate" style="padding-right:10px; white-space:nowrap; width:200px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;"></div></td>  -->
<!-- 		        </tr>  -->
<%-- 		        <c:if test="${guBun != '2'}">  --%>
<!-- 			        <tr>  -->
<%-- 			          <th><spring:message code='ezBoard.t289'/></th>  --%>
<!-- 			          <td id="User_DeptNM" style="white-space:nowrap; width:200px"></td>  -->
<%-- 			          <th><spring:message code='ezBoard.t290'/></th>  --%>
<!-- 			          <td id="User_JobTitle" style="white-space:nowrap; width:200px"></td>  -->
<%-- 			          <th><spring:message code='ezBoard.t38'/></th>  --%>
<!-- 			          <td id="Telephone" style="width:200px"></td>  -->
<!-- 			        </tr>  -->
<%-- 		        </c:if>  --%>
<!-- 		        <tr>  -->
<%-- 		          <th><spring:message code='ezBoard.t291'/></th>  --%>
<!-- 		          <td id="cTitle" style="WORD-WRAP: break-word" colSpan="5"><div id="txtTitle" style="OVERFLOW-Y: auto; WIDTH: 100%; HEIGHT: 15px; vertical-align: middle"></div></td>  -->
<!-- 		        </tr>  -->
<!-- 		        추가 항목이 있을 경우  -->
<%--        			<c:forEach var="boardAttributeVO" items="${boardAttributeListVO}" step="1" varStatus="status">  --%>
<!--        				<tr>  -->
<%--        					<c:choose>  --%>
<%--        						<c:when test="${extenLang == 1}">  --%>
<%--          						<th>${boardAttributeVO.colName1}</th>  --%>
<%--        						</c:when>  --%>
<%--        						<c:otherwise>  --%>
<%--        							<th>${boardAttributeVO.colName2}</th>  --%>
<%--        						</c:otherwise>  --%>
<%--        					</c:choose>  --%>
<%--        					<c:choose>  --%>
<%--        						<c:when test="${boardAttributeVO.colType == 'radio'}">  --%>
<%-- 				                <td colspan="5" id="${boardAttributeVO.tableCol}">  --%>
<!-- 				                </td>  -->
<%--       						</c:when>  --%>
<%--       						<c:when test="${boardAttributeVO.colType == 'text'}">  --%>
<%-- 				                <td colspan="5" id="${boardAttributeVO.tableCol}">  --%>
<!-- 				                </td>  -->
<%--        						</c:when>  --%>
<%--        						<c:when test="${boardAttributeVO.colType == 'check'}">  --%>
<%-- 				                <td colspan="5" id="${boardAttributeVO.tableCol}">  --%>
<!-- 				                </td>  -->
<%--        						</c:when>  --%>
<%--        					</c:choose>  --%>
<!--        				</tr>  -->
<%--        			</c:forEach>  --%>
<!-- 	          추가 항목이 있을 경우 끝  -->
<!-- 		      </table> -->
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
		        <div id ="contenttable" class ="viewbox" style="border:1px solid #ddd"></div>
		    </td> 
		  </tr>
		  </table>
		  <table class="layout" style="margin-top:5px;">
		      <tr id="onelineView" style="display:none;">
		        <td style="height:30px">
		          <table class="file2" style="height:100%;">
		            <tr>
		              <th style="height:100%; "><spring:message code='ezBoard.jjh06'/></th>
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
		              <th style="height:100%; "><spring:message code='ezBoard.t10025'/></th>
		              <td style="width:100%; height:100%; "><div id="lstAttachLink" style="padding-top:3px;padding-bottom:3px;padding-left:3px;OVERFLOW:visible;  background-color:white; text-align:left"></div></td>
		              <td id="ItemLevel" style="display:none"></td>
		            </tr>
		          </table>
		        </td>
		      </tr>
		</table>
	</body>
</html>