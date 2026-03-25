<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t335'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
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
			/* 첨부파일 아이콘 변경 */
			#lstAttachLink img{width: 18px;height: 18px;vertical-align: middle;margin: 0 2px 4px 0;}
			.preview_attach_list > ul > li:hover span{font-weight:unset; }
			.preview_toggleBtn{cursor: default;}
			.textBtn:hover {color:#131416;cursor: default}
			.btn_attach_download {cursor: default}
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
			var Atttribute = "${boardAttr}";
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
		            document.querySelector(".comment_listBox").style.display = "";
		        }
		        
		        if (eAttach == "Y") {
		            document.getElementById('attachView').style.display = "";
		        }
		
		        SetAttachmentInfo();
		        if (OneLineReplyFlag == "1") {
		        	getOneLineReply();
		        }
		        
		        myVar = setInterval(function () { DocumentComplate(); }, 2000);
		        
		        // document.getElementById("WriteUserNM").innerText = " " + strWriterName;
				
				
				// 2024-07-31 전인하 - 게시판 > 확장컬럼 > peoplePicker 타입, textArea 타입 출력값 가공
				var userLang = "${userInfo.lang}"
				var boardAttrListTemp = '<c:out value="${boardAttrJson}"/>';
				var boardAttrListJson = JSON.parse(replaceEntityCodeToStr(boardAttrListTemp));
				var boardItemTemp = '<c:out value="${boardItemJson}"/>';
				var boardItemJson = JSON.parse(replaceEntityCodeToStr(boardItemTemp));
				
				for (let i = 0 ; i < boardAttrListJson.length ; i++ ) {
					var boardAttr = boardAttrListJson[i];
					if (boardAttr.colType == 'people') {
						var peoplePickerString = peoplePickerDisplay(boardItemJson[boardAttr.tableCol], userLang);
						document.getElementById(boardAttr.tableCol).innerText = peoplePickerString;
					} else if (boardAttr.colType == 'textArea') {
						document.getElementById(boardAttr.tableCol).style.display = "block";
						var peoplePickerString = boardItemJson[boardAttr.tableCol];
						var peoplePickerStringList = peoplePickerString.split("<br/>");
						for (let j = 0 ; j < peoplePickerStringList.length ; j++) {
							if (j != 0) {
								var brDom = document.createElement("br");
								document.getElementById(boardAttr.tableCol).appendChild(brDom);
							}
							var bDom = document.createElement("b");
							bDom.style.fontWeight = 'normal';
							bDom.innerText = unescapeForJson(peoplePickerStringList[j])
							document.getElementById(boardAttr.tableCol).appendChild(bDom);
						}
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
		        
				var oUl = document.createElement("ul");
				for (var i = 0; i < xmldomNodes.length; i++) {
					var oLi = document.createElement("li");
					var oSpan = document.createElement("span");
					var oA = document.createElement("a");
					var oImage = document.createElement("img");
					
					filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
					/* 2018-04-27 홍승비 - 화면에 표시되는 파일명 특문처리 수정 */
					filenameOrg = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
					filenameView = MakeXMLString(filenameOrg);
					filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));

					var strTarget = "target=''";
					var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
					if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
							strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
							strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
							strFileExt == ".xlsx" || strFileExt == ".rtf") {
						strTarget = "target=''";
					}

					if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1)
						fileImage = "/images/image.svg";
					else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1)
						fileImage = "/images/doc.svg";
					else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1)
						fileImage = "/images/xls.svg";
					else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1)
						fileImage = "/images/ppt.svg";
					else if (strFileExt.indexOf(".txt") != -1)
						fileImage = "/images/txt.svg";
					else if (strFileExt.indexOf(".zip") != -1)
						fileImage = "/images/zip.svg";
					else if (strFileExt.indexOf(".pdf") != -1)
						fileImage = "/images/pdf.svg";
					else if (strFileExt.indexOf(".hwp") != -1 || strFileExt.indexOf(".hwpx") != -1)
						fileImage = "/images/hwp.svg";
					else if (strFileExt.indexOf(".ecm") != -1)
						fileImage = "/images/ecm.svg";
					else
						fileImage = "/images/etc.svg";

					var protocol = window.location.protocol;
					var serverName = window.location.hostname;
					
					oImage.src = fileImage;
					oA.innerText = filenameOrg + " (" + filesize + ")";
					oA.style.cursor = "default";
					oSpan.appendChild(oImage);
					oSpan.appendChild(oA)
					oLi.appendChild(oSpan);
					if (typeof useBoardFilePrvw !== 'undefined' && useBoardFilePrvw == "1" && guestReadFG !== "Y") {
						oButton = document.createElement("button");
						oButton.className = "textBtn i_attach_preview";
						oButton.style.cursor ="default";
						oLi.appendChild(oButton);
					}
					oUl.appendChild(oLi);
				}
				document.getElementById('lstAttachLink').append(oUl);
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
	<body class="popup newBoardPopup" style="padding:10px;">
		<div class="layout" >  
			<div class="preview_infoBox">
				<div class="preview_tit"><c:out value="${boardItem.title}"/></div>
				<div class="preview_info">
					<div>
						<c:choose>
							<c:when test="${guBun != '2'}">
								<span id="WriteUserNM">
									<c:out value="${boardItem.writerDeptName}"/> <c:out value="${boardItem.writerName}"/><c:if test="${not empty fn:trim(boardItem.extensionAttribute3)}">(<c:out value="${boardItem.extensionAttribute3}"/>)</c:if>
								</span>
							</c:when>
							<c:otherwise>
								<span id="WriteUserNM">
									<c:out value="${boardItem.writerName}"/>
								</span>
							</c:otherwise>
						</c:choose>
						<span id="PostDate"><c:out value="${boardItem.writeDate.substring(0, 16)}"/></span>
					</div>
					<div>
						<c:choose>
							<c:when test="${boardItem.endDate.substring(0,4) == '9999'}">
								<span id="EndDate" style="padding-right:5px;">
									<spring:message code='ezBoard.t287' />
								</span>
							</c:when>
							<c:otherwise>
								<span id="EndDate" style="padding-right:15px;">
									<c:out value="${boardItem.endDate.split(' ')[0]}"/>
								</span>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				<c:if test="${((boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK') && not empty boardItem.updateDate) || boardInfo.useKeyword eq 'Y' || boardAttrCount > 0}">
					<div class="preview_detail">
						<!-- 상세정보는 위 기본정보를 제외한 추가정보 (확장컬럼) -->
						<span class="preview_toggleBtn active"><spring:message code='ezBoard.newDesign10' /></span>
						<div class="detail_category active">
							<ul>
								<c:if test="${(boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK') && not empty boardItem.updateDate}">
									<!-- 수정자, 수정일 -->
									<li>
										<c:if test="${guBun != '2'}">
											<span><spring:message code='ezBoard.updateJIH01' /></span>
											<span id="updaterName">
												<c:out value="${boardItem.updaterDept}"/> <c:out value="${boardItem.updaterName}"/><c:if test="${not empty fn:trim(boardItem.updaterTitle)}">(<c:out value="${boardItem.updaterTitle}"/>)</c:if>
												<span><c:out value="${boardItem.updateDate.substring(0, 16)}"/></span>
											</span>
										</c:if>
										<c:if test="${guBun == '2'}">
											<span><spring:message code='ezBoard.updateJIH02' /></span>
											<span id="updateDate">
												<c:out value="${boardItem.updateDate.substring(0, 16)}"/>
											</span>
										</c:if>
									</li>
									<!-- 수정자, 수정일 end -->
								</c:if>	
								<c:if test='${boardInfo.useKeyword eq "Y"}'>
									<li>
										<span><spring:message code="ezApprovalG.t1200" /></span>
										<c:if test='${not empty keywordList}'>
											<c:forEach var="keyword" items="${keywordList}">
												<span class="keywordSpan" id="${keyword.keywordName}" onclick="onclickKeyword(event)">#${keyword.keywordName}</span>
											</c:forEach>
										</c:if>
									</li>
								</c:if>
								<c:if test="${boardAttrCount > 0}">
									<c:forEach var="boardAttr" items="${boardAttr}">
										<li>
											<c:choose>
												<c:when test="${extenLang == '1'}">
													<span>${boardAttr.colName1}</span>
												</c:when>
												<c:otherwise>
													<span>${boardAttr.colName2}</span>
												</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${boardAttr.colType == 'people' || boardAttr.colType == 'textArea'}">                                         
													<span id="${boardAttr.tableCol}"></span>
												</c:when>
												<c:when test="${boardAttr.colType == 'people'}">
													<span id="${boardAttr.tableCol}"></span>
												</c:when>
												<c:when test="${boardAttr.tableCol == 'extensionAttribute6'}">
													<c:out value="${boardItem.extensionAttribute6}"/>
												</c:when>
												<c:when test="${boardAttr.tableCol == 'extensionAttribute7'}">
													<c:out value="${boardItem.extensionAttribute7}"/>
												</c:when>
												<c:when test="${boardAttr.tableCol == 'extensionAttribute8'}">
													<c:out value="${boardItem.extensionAttribute8}"/>
												</c:when>
												<c:when test="${boardAttr.tableCol == 'extensionAttribute9'}">
													<c:out value="${boardItem.extensionAttribute9}"/>
												</c:when>
												<c:when test="${boardAttr.tableCol == 'extensionAttribute10'}">
													<c:out value="${boardItem.extensionAttribute10}"/>
												</c:when>
												<c:otherwise></c:otherwise>
											</c:choose>
										</li>
									</c:forEach>
								</c:if>
							</ul>
						</div>
					</div>
				</c:if>
			</div>
			<div id="attachView" class="preview_attachBox" style="display:none;">
				<div class="preview_attach_header">
					<span class="preview_toggleBtn active"><spring:message code='ezBoard.t10025' /></span>
				</div>
				<div class="preview_attach_list boardPrint active" id="lstAttachLink" style="border: none;"></div>
			</div>
		  </div>
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
		        <div id ="txtContent" class ="viewbox"></div>
		    </td> 
		  </tr>
		  </table>
		  <div class="comment_listBox" style="display: none;">
			  <div id="onelinereplylist"></div>
		  </div>
	</body>
</html>