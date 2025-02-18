<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t335'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<style>
	        .viewbox {
				line-height:20px;
			}
			p {
				margin-top: 0px;
				margin-bottom: 0px;
			}
			#txtContent h1, #txtContent h2 , #txtContent h3 , #txtContent h4 , #txtContent h5 , #txtContent h6 {
				margin-left:0px;
				margin-right:0px;
				color:#000000;
			}
			#txtContent h1 {font-size:2em; margin-top:0.67em; margin-bottom:0.67em;}
			#txtContent h2  {font-size:1.5em; margin-top:0.83em; margin-bottom:0.83em;}
			#txtContent h3 {font-size:1.17em; margin-top:1em; margin-bottom:1em;}
			#txtContent h4 {font-size:1em; margin-top:1.33em; margin-bottom:1.33em;}
			#txtContent h5 {font-size:0.83em; margin-top:1.67em; margin-bottom:1.67em;}
			#txtContent h6 {font-size:0.67em; margin-top:2.33em; margin-bottom:2.33em;}
			th.boardItemViewPrint_cssThEn{border-right:none;}
			td.boardItemViewPrint_cssTdEn{border:1px solid #d2d2d2;}
			td.boardItemViewPrint_cssTdEn > table .boardComment{border-bottom:1px solid #d2d2d2;}
			td.boardItemViewPrint_cssTdEn > table .boardComment:last-child{border-bottom:none;}
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
			var pBoardID= "<c:out value='${boardID}'/>";
			var pBoardName = "${boardInfo.boardName}";
		    var eOneline = "<c:out value='${oneLine}'/>";
		    var eAttach = "<c:out value='${attach}'/>";
			var strWriterID = "${boardItem.writerID}";
			var strWriterName = ConvMakeXMLString("<c:out value='${boardItem.writerName}'/>"); // 익명게시판의 게시자명 특문처리 대응
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
		    var reactFlag = "<c:out value='${boardInfo.reactFlag}'/>";
		    var commentSort = "earliest"; // 댓글 정렬 기준 : earliest(등록순) / latest(최신순)
		
		    var myVar;
		    var pUseEditor = "${use_Editor}";
	    	var html = "";
	    	
		    window.onload = function () {
		    	if (pUseEditor != "HWP") {
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
					beforePrint();
		    	}
		    };
		    
		    function beforePrint() {
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
		        
		        document.getElementById("WriteUserNM").innerText = " " + strWriterName;
		        
		        // 2024-07-31 전인하 - 게시판 > 확장컬럼 > peoplePicker 타입 출력값 가공
		        var userLang = "${userInfo.lang}";        
		        for (i = 1 ; i < 6; i++) {
		            var extentionAttrId = "extensionAttribute" + (5 + i);
		            var extentionAttrDiv = document.getElementById(extentionAttrId);
		            if (extentionAttrDiv != null && typeof extentionAttrDiv != "undefined")
		            if (extentionAttrDiv.getAttribute("type") == "people") {
		                extentionAttrDiv.innerText = peoplePickerDisplay(extentionAttrDiv.innerText, userLang);
		            }
		        }
		    }
		
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
		        xmlhttp.open("POST", "/ezBoard/getItemAttachments.do?itemID=" + encodeURIComponent(pItemID), false);
		        xmlhttp.send();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        var filename = "";
		        var strAttach = "";
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        var attachFileDiv = document.getElementById("lstAttachLink");
		        
		        for (var i = 0; i < xmldomNodes.length; i++) {
					var span = document.createElement("SPAN");
					var img = document.createElement("IMG");
		                
		            filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
		            filename = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
		            filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
		            strAttach = " " + filename + " (" + filesize + ")";
		            
		            var strTarget = "target=''";
		            var strFileExt = filename.substr(filename.lastIndexOf('.')).toLowerCase();
		            if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
		               strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
		               strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
		               strFileExt == ".xlsx" || strFileExt == ".rtf") {
		                strTarget = "target=''";
		            }
		            
		            if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1) {
		                fileImage = "/images/image.png";
		            } else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1) {
		                fileImage = "/images/doc.png";
		            } else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1) {
		                fileImage = "/images/xls.png";
		            } else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1) {
		                fileImage = "/images/ppt.png";
		            } else if (strFileExt.indexOf(".txt") != -1) {
		                fileImage = "/images/txt.png";
		            } else if (strFileExt.indexOf(".zip") != -1) {
		                fileImage = "/images/zip.png";
		            } else if (strFileExt.indexOf(".pdf") != -1) {
		                fileImage = "/images/pdf.png";
		            } else if (strFileExt.indexOf(".ecm") != -1) {
		                fileImage = "/images/ecm.png";
		            } else {
		                fileImage = "/images/email/mail_006.gif";
		            }
		            
	                img.src = fileImage;
                    
	                var attachNameSpan = document.createElement("SPAN");
	                attachNameSpan.innerText = strAttach;
	                
	                var br = document.createElement("BR");
	
	                span.appendChild(img);
	                span.appendChild(attachNameSpan);
	                span.appendChild(br);
	
	                attachFileDiv.appendChild(span);
		        }
		    }
		    
		    /* 2018-06-29 홍승비 - 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		    function OpenUserInfo(pUserID, pDeptID) {
		        var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
		    }
		    function getOneLineReply() {
		        var commentPanel = $('#comment_list_display');
                $.ajax({
                    type : "POST",
                    async : false,
                    url : "/ezBoard/getBoardComment.do",
                    dataType : "json",
                    data : {
                        itemID : pItemID,
                        boardID : pBoardID,
                        gubun : gubun,
                        sort : commentSort
                    },
                    success : function(result) {
                        var boardCommentList = makeBoardCommentHtml(result, "print");
                        $("#onelinereplylist").append(boardCommentList); //새 댓글리스트 삽입
                    },
                    error : function(jqXHR, textStatus, errorThrown) {
                        
                    }
                });
		    }
		    function displaytable() {
		        if(message.document.body.innerHTML != "")
		            document.getElementById("txtContent").innerHTML = message.document.body.innerHTML;
		    }
		    
		    /* 2021-08-12 홍승비 - 익명게시물 게시자명 특문처리 추가 */
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&#039;", "'");
		        str = ReplaceText(str, "&#034;", "\"");
		  		str = ReplaceText(str, "&#92;", "\\");
		  	    str = ReplaceText(str, "&amp;", "&");
		        return str;
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
	        			document.getElementById("txtContent").innerHTML = html;
	        			beforePrint();
	        		});
	        	}
	        }
		    
		</script>
	</head>
	<!-- 2018-02-01 김보미 - 게시물 상세 테이블 컬럼 조정. -->
	<body style="padding:10px;">
		<table class="layout" >  
		  <tr>
		    <td>
		        <table class="content" style="width:100%;">
		        	<!-- 게시자&부서 (부서의 경우 익명게시판이 아닐때만 표출) -->
		        	<tr>
		        	<c:choose>
		        		<c:when test="${boardInfo.guBun != '2'}">
			        		<th style="width:10%;"><spring:message code='ezBoard.t223'/></th>
							<td id="WriteUserNM" style="width:40%; white-space:nowrap"></td>
							<th style="width:10%;"><spring:message code='ezBoard.t289'/></th>
							<td id="User_DeptNM" style="width:40%; white-space:nowrap">${boardItem.writerDeptName}</td>
						</c:when>
						<c:otherwise>
							<th style="width:10%;"><spring:message code='ezBoard.t223'/></th>
							<td id="WriteUserNM" style="width:40%; white-space:nowrap" colspan=4></td>
						</c:otherwise>
					</c:choose>
		        	</tr>
		        	<!-- 직위&사내전화 (익명게시판이 아닌 경우에만 표출) -->
		        	<c:if test="${boardInfo.guBun != '2'}">
		        	<tr>
		        		<th><spring:message code='ezBoard.t290'/></th>
						<td id="User_JobTitle" style="width:40%; white-space:nowrap;">${boardItem.extensionAttribute3}<div></div></td>
						<th><spring:message code='ezPersonal.t177'/></th>
						<td id="Telephone" style="width:40%; white-space:nowrap">${boardItem.extensionAttribute4}</td>
		        	</tr>
		        	</c:if>
		        	<!-- 게시일&게시종료일 -->
		        	<tr>
						<th><spring:message code='ezBoard.t224'/></th>
		        		<td id="PostDate" style="width:40%; white-space:nowrap">${boardItem.writeDate.substring(0, 16)}</td>
						<th><spring:message code='ezBoard.t288'/></th>
						<c:set var="t287" value="<spring:message code='ezBoard.t287'/>"/>
						<c:choose>
							<c:when test="${boardItem.endDate == t287}">
								<td id="EndDate" style="padding-right:15px; width:40%;"><spring:message code='ezBoard.t287'/></td>
							</c:when>
							<c:otherwise>
								<td id="EndDate" style="padding-right:15px; width:40%;">${boardItem.endDate.split(' ')[0]}</td>
							</c:otherwise>
						</c:choose>
		        	</tr>
		        	<c:if test="${(boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK') && not empty boardItem.updateDate}">
                     <!-- 수정자, 수정일 -->
                        <tr>
                            <c:if test="${boardInfo.guBun != '2'}">
                                <th><spring:message code='ezBoard.updateJIH01' /></th>
                                <td id="updaterName" style = "white-space:nowrap; padding-right:5px; width: 40%;">
                                    <div style="vertical-align:middle;width:100%;height:16px;">${boardItem.updaterName}</div>
                                </td>
                                <th><spring:message code='ezBoard.updateJIH02' /></th>
                                <td id="updateDate" style = "white-space:nowrap; padding-right:5px; width: 40%;">
                                    <div style="vertical-align:middle;width:100%;height:16px;">${boardItem.updateDate.substring(0, 16)}</div>
                                </td>
                            </c:if>
                            <c:if test="${boardInfo.guBun == '2'}">
                                <th><spring:message code='ezBoard.updateJIH02' /></th>
                                <td width="100%" id="updateDate" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
                                    <div style="WIDTH: 100%; vertical-align: middle"><c:out value="${boardItem.updateDate.substring(0, 16)}"/></div>
                                </td>
                            </c:if>
                        </tr>
                    <!-- 수정자, 수정일 end -->
                    </c:if>	
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
					                <td colspan="5" id="${boardAttr.tableCol}" type="${boardAttr.colType}">
					                	<c:choose>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute6'}">
					                			${boardItem.extensionAttribute6}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute7'}">
					                			${boardItem.extensionAttribute7}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute8'}">
					                			${boardItem.extensionAttribute8}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute9'}">
					                			${boardItem.extensionAttribute9}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute10'}">
					                			${boardItem.extensionAttribute10}
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
	                  <td id="cTitle" style="WORD-WRAP: break-word;" colspan="6"><c:out value="${boardItem.title}"/></td>
		            </tr>
		            <%-- 키워드 --%>
                     <c:if test='${boardInfo.useKeyword eq "Y"}'>
                         <tr>
                             <th><spring:message code="ezApprovalG.t1200" /></th>
                             <td width="100%" id="cKeyword" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
                                <div style="WIDTH: 100%; vertical-align: middle">
                                    <c:if test='${not empty keywordList}'>
                                        <c:forEach var="keyword" items="${keywordList}">
                                            <span class="keywordSpanView" id="${keyword.keywordName}">#${keyword.keywordName}</span>
                                        </c:forEach>
                                    </c:if>
                                </div>
                             </td>
                         </tr>
                     </c:if>
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
		        <c:if test="${use_Editor ne 'HWP'}">
		        	<iframe id="message" name="message" style="height:100%; width:100%" onload ="displaytable()"></iframe>
		        </c:if>
		        <c:if test="${use_Editor eq 'HWP'}">
	        		<iframe id="message" name="message" src="/ezBoard/WHWPEditor.do" style="height:100%; width:100%"></iframe>
		        </c:if>
		    </td>
		  </tr>
		    <tr>
		    <td class="pad1" style="height:100%;">
		        <div id ="txtContent" class ="viewbox" style="border:1px solid #d2d2d2; margin-left:0px; margin-right:0px;"></div>
		    </td> 
		  </tr>
		  </table>
		  <table class="layout" style="margin-top:5px;">
		      <tr id="onelineView" style="display:none;">
		        <td style="height:30px">
		          <table style="height:100%;">
		            <tr>
		              <th class="boardItemViewPrint_cssThEn" style="height:100%; "><spring:message code='ezBoard.jjh06'/></th>
		              <td class="boardItemViewPrint_cssTdEn" style="height:100%; width:100%; ">
		                <table id="onelinereplylist" style="OVERFLOW:visible;  background-color:white; text-align:left; width:100%;"></table>
		              </td>
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
		              <th class="boardItemViewPrint_cssThEn" style="height:100%; "><spring:message code='ezBoard.t10025'/></th>
		              <td class="boardItemViewPrint_cssTdEn" style="width:100%; height:100%; "><div id="lstAttachLink" style="padding-top:3px;padding-bottom:3px;padding-left:3px;OVERFLOW:visible;  background-color:white; text-align:left"></div></td>
		              <td id="ItemLevel" style="display:none"></td>
		            </tr>
		          </table>
		        </td>
		      </tr>
		</table>
	</body>
</html>