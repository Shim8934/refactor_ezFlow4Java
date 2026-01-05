<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t981' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ErrorHandler.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style title = ezform_style_1>
			P {
				MARGIN-TOP	:	0mm;
				MARGIN-BOTTOM	: 0MM;
			}
			/* 첨부파일 아이콘 변경 */
			#lstAttachLink img{width: 18px;height: 18px;vertical-align: middle;margin: 0 2px 4px 0;}
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
			var myVar;
			var pUseEditor = "${use_Editor}";
			var html = "";
			
			window.onload = function ()
			{
// 				var fullPath = "/ezCommon/downloadAttach.do?filepath=" + encodeURIComponent(strContentLocation);
				if (pUseEditor != "HWP") {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommon/mhtToHTMLContent.do",
						data : { type	:	"COMMUNITYCONTENT", 
								 href	:	strContentLocation,
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
					readyPrint();
				}
			}
			
			function readyPrint() {
				$("#message").contents().find("body").css("word-wrap", "break-word");
				
			    SetAttachmentInfo();
			    if (OneLineReplyFlag == "1") {
			    	getOneLineReply();
			    }
			
			    if (g_progresswin) {
			    	g_progresswin.close();
			    }
			    
			    myVar = setInterval(function () { beforePrint(); }, 2000);
			}
			
			function btnClose_onclick() {
				window.close();
			}
			
			function SetAttachmentInfo() {
			    var xmlhttp = createXMLHttpRequest();
			    var xmldom = createXmlDom();
				
			    xmlhttp.open("GET", "/ezCommunity/getItemAttachments.do?itemID=" + encodeURIComponent(pItemID), false);
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
					
		            if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1) {
		                fileImage = "/images/image.svg";
		            } else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1) {
		                fileImage = "/images/doc.svg";
		            } else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1) {
		                fileImage = "/images/xls.svg";
		            } else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1) {
		                fileImage = "/images/ppt.svg";
		            } else if (strFileExt.indexOf(".txt") != -1) {
		                fileImage = "/images/txt.svg";
		            } else if (strFileExt.indexOf(".zip") != -1) {
		                fileImage = "/images/zip.svg";
		            } else if (strFileExt.indexOf(".pdf") != -1) {
		                fileImage = "/images/pdf.svg";
		            } else if (strFileExt.indexOf(".hwp") != -1 || strFileExt.indexOf(".hwpx") != -1) {
						fileImage = "/images/hwp.svg";
					} else if (strFileExt.indexOf(".ecm") != -1) {
		                fileImage = "/images/ecm.svg";
		            } else {
		                fileImage = "/images/etc.svg";
		            }
		            
			        /* strAttach = strAttach + "<input type='checkbox' name='fileSelect' value='" + filename + "' filehref=\"/ezCommunity/getCommunityAttachInfo.do?fileName=" + encodeURIComponent(filename) + "&filePath=" + encodeURIComponent(filepath)  + "\">"; */
	                strAttach = strAttach + "<img src='" + fileImage + "'> <a href=/ezCommunity/getCommunityAttachInfo.do?fileName=" + encodeURIComponent(filename) + "&filePath=" + encodeURIComponent(filepath) + ">";
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
					type : "GET",
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
		 	            		strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + item.userID + "\")'><font color=blue>" + item.userName + "</font></span>(" + item.writeDate.substring(0, 16) + ")" + " : </font>" + item.content + "<br>";
		 	            	} else if (gubun == "2") {
		 	            		strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick=''><font color=blue>" + item.userName + "</font></span>(" + item.writeDate.substring(0, 16) + ")" + " : </font>" + item.content + "<br>";
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
		 	        	   console.log(e);
		 	           }
					}
				});
			}
			
			function beforePrint() {
				if (CrossYN()) {
		            window.print();
		        } else {
		            preview_print();
		        }
		
		        clearInterval(myVar);
			}
			
			// window onload 시 message 프레임에 본문을 로딩한 다음, 화면에 표출하기 위한 contenttable 영역에 본문 html을 복사하는 함수
			// 관리자도구의 콘솔창에서 스크립트 에러가 발생하나, 정상 동작함.
			function displaytable() {
				document.getElementById("contenttable").innerHTML = message.document.body.innerHTML;
			}
			
			function Editor_Complete() {
	        	var URL;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(strContentLocation);
                message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
	        }
			
			function FieldsAvailable(isTrue) {
	        	if (isTrue) {
	        		message.GetTextFile("HTML", "", function (data) {
	        			html = data;
	        			document.getElementById("contenttable").innerHTML = html;
	        			readyPrint();
	        		});
	        	}
	        }
		</script>
	</head>
	
	<body class="popup">
		<table class="layout">
			<tr>
		    	<!-- <td style="height:20px"> -->
		    	<td style="width:100%;">
			      	<div id="menu">
						<ul id="menuTable">
							<li class="sel">
								<h1 style="margin-top:-4px;"><spring:message code = 'ezCommunity.t982' /></h1>
							</li>
						</ul>
						<ul style="float: right; margin-right: 40px">
							<li id="menuTable" style="background: none; border: none;">
								<span class="icon16 popup_icon16_print" onclick="beforePrint()"></span>
							</li>
						</ul>
					</div>
				    <div id="close">
				        <ul>
				            <li><span onClick="window.close();"></span></li>
				        </ul>
				    </div>
				</td>
		  	<tr>
		    	<!-- <td style="height:20px"> -->
		    	<td>
		    		<!-- 2018-02-05  김보미 - 테이블컬럼 조정 -->
		    		<table class="content" style="width:100%">
		    		<!-- 작성자&부서 -->
		    		<tr>
		    			<th style="width:10%;"><spring:message code = 'ezCommunity.t138' /></th> 
				        <td id="WriteUserNM" style="CURSOR: pointer;white-space:nowrap;width:40%;" <c:if test="${boardInfo.gubun == '2' }">colspan="3"</c:if>><div id = title style="vertical-align:middle;width:100%; white-space:pre-line;" onClick=''><c:out value = '${item.writerName}' /></div></td>
				        <%-- 부서명은 익명게시판이 아닌 경우에만 표출 --%>
				        <c:if test="${boardInfo.gubun != '2' }">
		    				<th style="width:10%;"><spring:message code = 'ezCommunity.t932' /></th> 
				        	<td id="User_DeptNM" style="padding-right:10px;white-space:nowrap;width:40%;"><span><c:out value = '${item.writerDeptName }' /></span></td>
				        </c:if>
		    		</tr>
		    		<!-- 직위&전화번호 -->
		    		<c:choose>
		    			<c:when test="${boardInfo.gubun != 2 }">
		    				<tr>
		    					<th style="width:10%;"><spring:message code = 'ezCommunity.t960' /></th> 
				       			<td id="User_JobTitle" style="padding-right:10px;white-space:nowrap;width:40%;"><span><c:out value = '${item.extensionAttribute3}' /></span></td>
								<th style="width:10%;"><spring:message code = 'ezCommunity.t269' /></th>
								<td id="Telephone" style="width:40%;"><c:out value = '${item.extensionAttribute4 }' /></td>
		    				</tr>
		    			</c:when>
		    		</c:choose>
		    		<!-- 게시일&게시종료일 -->
		    		<tr>
		    			<th style="width:10%;"><spring:message code = 'ezCommunity.t209' /></th>
					    <td id="PostDate" style="padding-right:15px;width:40%;white-space:nowrap"><div id = title style="vertical-align:middle;width:auto;height:17px;overflow-y:auto;"><c:out value = '${item.writeDate.substring(0, 16)}' /></div></td>
					    <th style="width:10%;"><spring:message code = 'ezCommunity.t931' /></th>
					    
					    <c:set var="t930"><spring:message code='ezCommunity.t930'/></c:set>
					    
					    <c:choose>
		                 	<c:when test="${item.endDate == t930}">
		                 		<td id="EndDate" style="padding-right:15px;width:40%;white-space:nowrap"><div id = title style="vertical-align:middle;width:auto;height:17px;overflow-y:auto;"><spring:message code = 'ezCommunity.t930' /></div></td>
		                 	</c:when>
		                 	
		                 	<c:otherwise>
		                 		<td id="EndDate" style="padding-right:15px;width:40%;white-space:nowrap"><div id = title style="vertical-align:middle;width:auto;height:17px;overflow-y:auto;"><c:out value = '${item.endDate.split(" ")[0]}' /></div></td>
		                 	</c:otherwise>
		                 </c:choose>
		    		</tr>
<!-- 				        <tr> -->
<%-- 				        	<th><spring:message code = 'ezCommunity.t138' /></th> --%>
<%-- 				        	<td id="WriteUserNM" style="CURSOR: pointer;white-space:nowrap;width:120px;"><div id = title style="vertical-align:middle;width:115px;height:17px;overflow-y:auto;" onClick=''><c:out value = '${item.writerName}' /></div></td> --%>
<%-- 				          	<th><spring:message code = 'ezCommunity.t209' /></th> --%>
<%-- 				          	<td id="PostDate" style="padding-right:15px;width:auto;white-space:nowrap"><div id = title style="vertical-align:middle;width:auto;height:17px;overflow-y:auto;"><c:out value = '${item.writeDate }' /></div></td> --%>
<%-- 				          	<th><spring:message code = 'ezCommunity.t931' /></th> --%>
				          	
<%-- 				          	<c:set var="t930"><spring:message code='ezCommunity.t930'/></c:set> --%>
				          	
<%-- 				          	<c:choose> --%>
<%-- 	                        	<c:when test="${item.endDate == t930}"> --%>
<%-- 	                        		<td id="EndDate" style="padding-right:15px;width:80px;white-space:nowrap"><div id = title style="vertical-align:middle;width:auto;height:17px;overflow-y:auto;"><spring:message code = 'ezCommunity.t930' /></div></td> --%>
<%-- 	                        	</c:when> --%>
	                        	
<%-- 	                        	<c:otherwise> --%>
<%-- 	                        		<td id="EndDate" style="padding-right:15px;width:80px;white-space:nowrap"><div id = title style="vertical-align:middle;width:auto;height:17px;overflow-y:auto;"><c:out value = '${item.endDate }' /></div></td> --%>
<%-- 	                        	</c:otherwise> --%>
<%-- 	                        </c:choose> --%>
	                        
<!-- 				        </tr> -->
<!-- 			        	<tr> -->
<%-- 			        		<th><spring:message code = 'ezCommunity.t932' /></th> --%>
<%-- 				          	<td id="User_DeptNM" style="padding-right:10px;white-space:nowrap"><span><c:out value = '${item.writerDeptName }' /></span></td> --%>
<%-- 				          	<th><spring:message code = 'ezCommunity.t960' /></th> --%>
<%-- 				          	<td id="User_JobTitle" style="padding-right:10px;white-space:nowrap;"><span><c:out value = '${item.extensionAttribute3}' /></span></td> --%>
<%-- 							<th style="width:70px"><spring:message code = 'ezCommunity.t269' /></th> --%>
<%-- 							<td id="Telephone" style="width:100%"><c:out value = '${item.extensionAttribute4 }' /></td> --%>
<!-- 			        	</tr> -->
			        	<tr>
			          		<th><spring:message code = 'ezCommunity.t210' /></th>
			          		<td id="cTitle" style="WORD-WRAP: break-word" colspan="5"><div id="title"><c:out value = '${item.title}' /></div></td>
			        	</tr>
					</table>
				</td>
		  	</tr>
		  	<table class="layout">
		  	<tr>
		    	<td class="pad1" id="ItemOverflow" style="display:none;"  >
		    		<c:if test="${use_Editor ne 'HWP'}">
			    		<iframe id="message" class="viewbox" name="message" style="display:none; border:1px solid #ddd;"  onload ="displaytable()"></iframe>
		    		</c:if>
		    		<c:if test="${use_Editor eq 'HWP'}">
		        		<iframe id="message" name="message" src="/ezCommunity/WHWPEditor.do" style="display:none;"></iframe>
			        </c:if>
		    	</td> 
		  	</tr>
		    <tr>
		    	<td class="pad1" style="height: 100%;">
		        	<div id ="contenttable" class ="viewbox" style="line-height:20px; letter-spacing: 0.5px; border:1px solid #ddd;"></div>
		    	</td> 
		  	</tr>
		  	</table>
    		<table class="content" id ="onelinereply" style="border-bottom:none;">
			    <tr>
			        <th class="boardItemViewPrint_cssThEn" style="border-bottom: none; font-weight: bold;"><spring:message code = 'ezBoard.jjh06' /></th>
			        <td class="boardItemViewPrint_cssTdEn" style="height:50px;border-bottom: none;"><div id="onelinereplylist" style="height:auto; background-color:white;text-align:left"></div></td>
			    </tr>
		    </table>
    		<table class="file">
		        <tr>
		        	<th class="boardItemViewPrint_cssThEn"><spring:message code = 'ezCommunity.t141' /></th>
			        <td class="boardItemViewPrint_cssTdEn" style="width:100%;height:100%;"><div id="lstAttachLink" style="margin-top:0px;padding-top:0px;background-color:white;height:auto;text-align:left "></div></td>
		          	<td id="ItemLevel" style="display:none"></td>
		        </tr>
			</table>
		</table>
	</body>
</html>