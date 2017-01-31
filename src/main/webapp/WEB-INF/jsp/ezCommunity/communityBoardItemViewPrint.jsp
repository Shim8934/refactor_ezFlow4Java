<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t981' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<style title = ezform_style_1>
			P {
				MARGIN-TOP	:	0mm;
				MARGIN-BOTTOM	: 0MM;
			}
		</style>
		

		<script type="text/javascript">
			window.offscreenBuffering = true;
			
			var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
			var curFontSize = 1;
			
			var pItemID = "<c:out value = '${pItemID}' />";
			var pBoardID= "<c:out value = '${pBoardID}' />";
			var pBoardName = "<c:out value = '${boardInfo.boardName}' />";
			
			var strWriterID = "<c:out value = '${item.writerID}' />";
			var strWriterName = "<c:out value = '${item.writerName}' />";
			var strWriterDeptName = "<c:out value = '${item.writerDeptName}' />";
			var strWriterCompanyName = "<c:out value = '${item.writerCompanyName}' />";
			var strWriteDate = "<c:out value = '${item.writeDate}' />";
			var strImportance = "<c:out value = '${item.importance}' />";
			var strEndDate = "<c:out value = '${item.endDate}' />";
			var strContentLocation = "<c:out value = '${item.contentLocation}' />";
			var strAttachList = "<c:out value = '${item.attachments}' />";
			
			var SSUserID = "<c:out value = '${userInfo.id}' />";
			var SSUserName = "<c:out value = '${userInfo.displayName1}' />";
			
			var	Access_FG = "<c:out value = '${boardInfo.access_FG}' />";
			var	BoardAdmin_FG = "<c:out value = '${boardInfo.boardAdmin_FG}' />";
			var	ListView_FG = "<c:out value = '${boardInfo.listView_FG}' />";
			var	Read_FG = "<c:out value = '${boardInfo.read_FG}' />";
			var	Write_FG = "<c:out value = '${boardInfo.write_FG}' />";
			var	Reply_FG = "<c:out value = '${boardInfo.reply_FG}' />";
			var Delete_FG = "<c:out value = '${boardInfo.delete_FG}' />";
			var OneLineReplyFlag = "<c:out value = '${oneLineReplyFlag}' />";
			
			var BoardGroupAdmin_FG = "<c:out value = '${boardInfo.boardGroupAdmin_FG}' />";
			var gubun = "<c:out value = '${ boardInfo.gubun }' />";
			
			var pReservedItem = "<c:out value = '${pReservedItem}' />";
			
			var g_progresswin;
			
			window.onload = function ()
			{
// 				var fullPath = "/ezCommon/downloadAttach.do?filepath=" + encodeURIComponent(strContentLocation);
				
				var html = "";
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { type	:	"COMMUNITYCONTENT", 
							 itemID	:	pItemID
						   },
					success: function(result){
						html = result;
					}        			
				});
				var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();
			
			    SetAttachmentInfo();
			    if (OneLineReplyFlag == "1") {
			    	getOneLineReply();
			    }
			
			    if (g_progresswin) {
			    	g_progresswin.close();
			    }
			}
			
			function btnClose_onclick() {
				window.close();
			}
			
			function SetAttachmentInfo() {
			    var xmlhttp = createXMLHttpRequest();
			    var xmldom = createXmlDom();
				
			    xmlhttp.open("POST", "/ezCommunity/getItemAttachments.do?itemID=" + pItemID, false);
			    xmlhttp.send();
				
			    xmldom = loadXMLString(xmlhttp.responseText);
			    xmlhttp = null;
				
			    var i=0;
			    var pos = 0;
			    var filename = "";
			    var filepath = "";
			    var strAttach = "";
			
			    var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
				
			    var regData = GetbrowserLanguage();
			    
			    for (i = 0; i < xmldomNodes.length; i++) {
			        filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
			        filename = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
			        filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
			        var strTarget ="target='_blank'"; 
			        var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
					
			        if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
			            strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
			            strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
			            strFileExt == ".xlsx" || strFileExt == ".rtf") {
			            strTarget = "target=''";
			        }
					
			        strAttach = strAttach + "<input type='checkbox' name='fileSelect' value='" + filename + "' filehref=\"/ezCommunity/getCommunityAttachInfo.do?fileName=" + encodeURIComponent(filename) + "&filePath=" + encodeURIComponent(filepath)  + "\">";
	                strAttach = strAttach + "<img src='/images/email/mail_006.gif'> <a href=/ezCommunity/getCommunityAttachInfo.do?fileName=" + encodeURIComponent(filename) + "&filePath=" + encodeURIComponent(filepath) + ">";
	                strAttach = strAttach + filename + "&nbsp;(" + filesize + ")</a><br>";
			    }
				
			    document.getElementById('lstAttachLink').innerHTML = strAttach;
			}
			
			function MemberInfo_onclick(pUserID) {
			    var feature = "height=290px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
			    feature = feature + GetOpenPosition(420, 290);
			    window.open("/myoffice/main/common/get_userinfo.aspx?id=" + pUserID, "", feature);
			}
			
			function OpenUserInfo(pUserID) {
			    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
			    feature = feature + GetOpenPosition(420, 450);
			    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
			}
			
			function getOneLineReply() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezCommunity/readOneLineReply.do",
					data : { boardID	:	pBoardID, 
							 itemID		:	pItemID
						   },
					success: function(result){
						strHTML = "";
		 	            var temp = 0;
		 	            
						$.each(result["oneLineReplyList"], function(idx, item){
		 	            	temp = temp+1;
		 	            	if (gubun != "2") {
		 	            		strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + item.userID + "\")'><font color=blue>" + item.userName + "</font></span>(" + item.writeDate + ")" + " : </font>" + item.content + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + item.replyID + "\")'><br>";
		 	            	} else if (gubun == "2") {
		 	            		strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick=''><font color=blue>" + item.userName + "</font></span>(" + item.writeDate + ")" + " : </font>" + item.content + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + item.replyID + "\")'><br>";
		 	            	}
		 	           });
		 	           
		 	           if (temp == 0){
		 	        	   document.getElementById("onelinereply").style.display = "none";
		 	        	   return;
		 	           }
		 	                
		 	           try {
		 	               document.getElementById('onelinereplylist').innerHTML = strHTML;
		 	           }
		 	           catch (e) {
		 	           }
					}
				});
			}
			
			function beforePrint() {
			    window.print();
			}
			
			function displaytable() {
			    document.getElementById("contenttable").innerHTML = message.document.body.innerHTML;
			}
		</script>
	</head>
	
	<body class="popup">
		<table class="layout" style="height:700px">
			<tr>
		    	<td style="height:20px">
					<h1><spring:message code = 'ezCommunity.t982' /></h1>
					
			      	<div id="close">
				        <ul>
				        	<li><span onclick="beforePrint()"><spring:message code = 'ezCommunity.t981' /></span></li>
				          	<li><span onClick="window.close();"><spring:message code = 'ezCommunity.t21' /></span></li>
				        </ul>
			      	</div>
			      	
			      	<script type="text/javascript">
						selToggleList(document.getElementById("close"), "ul", "li", "0");
					</script>
				</td>
		  	<tr>
		    	<td style="height:20px">
		    		<table class="content" style="width:100%">
				        <tr>
				        	<th><spring:message code = 'ezCommunity.t138' /></th>
				        	<td id="WriteUserNM" style="CURSOR: pointer;white-space:nowrap;width:120px;"><div id = title style="vertical-align:middle;width:115px;height:17px;overflow-y:auto;" onClick=''>&nbsp;<c:out value = '${item.writerName}' /></div></td>
				          	<th><spring:message code = 'ezCommunity.t209' /></th>
				          	<td id="PostDate" style="padding-right:15px;width:auto;white-space:nowrap"><div id = title style="vertical-align:middle;width:auto;height:17px;overflow-y:auto;"><c:out value = '${item.writeDate }' /></div></td>
				          	<th><spring:message code = 'ezCommunity.t931' /></th>
				          	
				          	<c:set var="t930"><spring:message code='ezCommunity.t930'/></c:set>
				          	
				          	<c:choose>
	                        	<c:when test="${item.endDate == t930}">
	                        		<td id="EndDate" style="padding-right:15px;width:80px;white-space:nowrap"><div id = title style="vertical-align:middle;width:80px;height:17px;overflow-y:auto;"><spring:message code = 'ezCommunity.t930' /></div></td>
	                        	</c:when>
	                        	
	                        	<c:otherwise>
	                        		<td id="EndDate" style="padding-right:15px;width:80px;white-space:nowrap"><div id = title style="vertical-align:middle;width:80px;height:17px;overflow-y:auto;"><c:out value = '${item.endDate }' /></div></td>
	                        	</c:otherwise>
	                        </c:choose>
	                        
				        </tr>
			        	<tr>
			        		<th><spring:message code = 'ezCommunity.t932' /></th>
				          	<td id="User_DeptNM" style="padding-right:10px;white-space:nowrap"><span><c:out value = '${item.writerDeptName }' /></span></td>
				          	<th><spring:message code = 'ezCommunity.t960' /></th>
				          	<td id="User_JobTitle" style="padding-right:10px;white-space:nowrap;"><span><c:out value = '${item.extensionAttribute3}' /></span></td>
							<th style="width:70px"><spring:message code = 'ezCommunity.t269' /></th>
							<td id="Telephone" style="width:100%"><c:out value = '${item.extensionAttribute4 }' /></td>
			        	</tr>
			        	<tr>
			          		<th><spring:message code = 'ezCommunity.t210' /></th>
			          		<td id="cTitle" style="WORD-WRAP: break-word" colspan="5"><div id="title"><c:out value = '${item.title}' /></div></td>
			        	</tr>
					</table>
				</td>
		  	</tr>
		  	<tr>
		    	<td class="pad1" id="ItemOverflow" style="display:none"  >
		    		<iframe id="message" class="viewbox" name="message" frameborder="0" style="display:none" onload ="displaytable()">
		    	</iframe></td> 
		  	</tr>
		    <tr>
		    	<td class="pad1" style="height: 100%;">
		        	<div id ="contenttable" class ="viewbox" style="height:100%"></div>
		    	</td> 
		  	</tr>
		    <tr  id ="onelinereply">
		    	<td style="height:20px">
		    		<table class="content">
					    <tr>
					        <th><spring:message code = 'ezCommunity.t961' /></th>
					        <td style="height:50px"><div id="onelinereplylist" style="HEIGHT:auto; background-color:white;text-align:left"></div></td>
					    </tr>
				    </table>
				</td>
	        </tr>
		  	<tr>
		    	<td style="height:20px">
		    		<table class="file">
				        <tr>
				        	<th><spring:message code = 'ezCommunity.t933' /></th>
					        <td style="width:100%;height:100%"><div id="lstAttachLink" style="margin-top:0px;padding-top:0px;background-color:white;height:auto;text-align:left "></div></td>
				          	<td id="ItemLevel" style="display:none"></td>
				        </tr>
					</table>
				</td>
		  	</tr>
		</table>
	</body>
</html>