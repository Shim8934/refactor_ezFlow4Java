<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html style="height: 100%">
	<head>
		<title><spring:message code='ezJournal.t133' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezJournal/journal_script.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezJournal/excel.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript">
		
			var formId = "<c:out value='${journal.formId}'/>";
			var journalId = "<c:out value='${journal.journalId}'/>";
			var journalTitle = "<c:out value='${journal.journalTitle}'/>";
			var typeId = "<c:out value='${journal.typeId}'/>";
			var isSum = "<c:out value='${journal.isSum}'/>";
			
			// 수정
			function journalModify() {
				window.location.href = "/ezJournal/journalWrite.do?typeId=" + typeId + "&journalId=" + journalId + "&mode=modify" + "&isSum=" + isSum;
			}
			
			// 재사용
			function journalReuse() {
				window.location.href = "/ezJournal/journalWrite.do?typeId=" + typeId + "&journalId=" + journalId + "&mode=reuse" + "&isSum=" + isSum;
			}
			
			// 삭제
			function journalDelete() {
				if (confirm("<spring:message code='ezJournal.t139'/>")) {
					$.ajax ({
						type : "POST",
						dataType : "text",
						async : "false",
						url : "/ezJournal/journalDelete.do",
						data : {
							journalId : JSON.stringify(journalId)
						},
						success : function() {
							alert("<spring:message code='ezJournal.t138'/>");
							try {
								opener.setJournalList();
							} catch(e) { }
							window.close();
						},
						error : function() {
							alert("<spring:message code='ezJournal.t149'/>");
						}
					});
				}
			}
			
			// 첨부파일 모두 선택
			function attach_SelectAll() {
			    var checks = document.getElementById('lstAttachLink').getElementsByTagName("input");
			    for (var i = 0; i < checks.length; i++)
			        checks.item(i).checked = true;
			}
        
			// 첨부파일 다운로드
			function attach_Download() {
			    checks = document.getElementById('lstAttachLink').getElementsByTagName("input");
			    downloadAll(checks)
			}
			
			var suffix = 0;
			function downloadAll(checks) {
		        if (checks.item(suffix)) {
		            if (checks.item(suffix).checked) {
		            	if (GetAttribute(checks.item(suffix), "attachid") != "" && GetAttribute(checks.item(suffix), "attachid") != null) {
			                location.href = encodeURIComponent(GetAttribute(checks.item(suffix++), "filepath"));
			            } else {
			            //	console.log("filePath : " + GetAttribute(checks.item(suffix), "filePath"));
		                	location.href = "/ezJournal/journalAttachDown.do?filePath=" + GetAttribute(checks.item(suffix), "filePath") + "&fileName=" + GetAttribute(checks.item(suffix++), "fileName") + "&journalId=" + journalId;
			            }
	                	setTimeout(function () { downloadAll(checks) }, 1000);
		            }
		            else {
		                suffix++;
		                downloadAll(checks);
		            }
		        }
		        else
		            suffix = 0;
		    }
		</script>
	</head>
	<body class="popup" style="overflow: hidden; height: 100%;">
		<table class="layout" style="height: 100%">
			<tr>
				<td style="vertical-align: top; height: 10px;">
					<div id="menu">
						<ul>
						<!-- 		        	댓글 -->
							<li><span onclick='openJournalReply();'> <spring:message code='ezJournal.t102' />(<a id="replyCount">${journal.replyCount }</a>)
							</span></li>
							<c:if test="${journal.mine eq 'yes' }">
								<!-- 		        	수정 -->
								<li><span onclick='journalModify()'> <spring:message code='ezJournal.t107' /></span></li>
							</c:if>
							<!-- 		        	조회자정보 -->
							<li><span onclick='journalViewerList();'> <spring:message code='ezJournal.t182' /></span></li>
							<c:if test="${journal.mine eq 'yes' }">	
								<!-- 		        	재사용 -->
								<li><span onclick='journalReuse()'> <spring:message code='ezJournal.t181' /></span></li>
								<!-- 	        		삭제 -->
								<li><span class="icon16 popup_icon16_delete" onclick='journalDelete()'></span></li>
							</c:if>
							<!-- 	        		수신확인 -->
							<c:if test="${journal.totalRecv gt 0 }">
								<li><span onclick='journalReceiverList();'> <spring:message code='ezJournal.t113' />(${journal.checkRecv }/${journal.totalRecv })</span></li>
							</c:if>
							<li><span class="icon16 popup_icon16_print" onclick='printJournal();'></span></li>
							<!-- 		        	메일로발송 -->
							<li><span class="icon16 popup_icon16_mail_gray" onclick='fromJournalToMail()'></span></li>
							<!-- 캐비넷  -->
							<c:if test="${useCabinet == 'YES'}">
								<li><span onclick='addRelatedCabinet()'><spring:message code='ezCabinet.t125' /></span></li>
							</c:if>
							<c:set var="userAgentInfo" value="${fn:toLowerCase(header['User-Agent'])}" />
						</ul>
					</div>
					<div id="close">
						<ul>
							<li><span onClick="window.close()"></span></li>
						</ul>
					</div> 
					<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
					</script>
				</td>
			</tr>
			<tr>
				<td style="vertical-align: top; height: 10px;">
					<table class="content2" style="width: 100%;">
						<!-- 작성일  -->
						<tr>
							<th style="width: 10%;"><spring:message code='ezJournal.t25' /></th>
							<td style="width: 40%; white-space: nowrap">
								<div style="overflow-y: auto; vertical-align: middle">
									<c:out value="${journal.journalDate}" />
								</div>
							</td>
							<!-- 작성자 -->
							<th style="width: 10%;"><spring:message code='ezJournal.t34' /></th>
							<td style="width: 40%; white-space: nowrap">
								<div style="vertical-align: middle; height: 16px; cursor: pointer" onclick='OpenUserInfo("${journal.writerId}")'>
									<c:out value="${journal.writerName}" />
								</div>
							</td>
						</tr>
						<!-- 일지함명  -->
						<tr>
							<th style="width: 10%;"><spring:message code='ezJournal.t12' /></th>
							<td style="width: 40%; white-space: nowrap">
								<div style="overflow-y: auto; vertical-align: middle">
									<spring:message code='${journal.typeId}' />
								</div>
							</td>
							<!-- 양식명 -->
							<th style="width: 10%;"><spring:message code='ezJournal.t22' /></th>
							<td style="width: 40%; white-space: nowrap">
								<div style="overflow-y: auto; vertical-align: middle">
									<c:out value="${journal.formName}" />
								</div>
							</td>
						</tr>
						<!-- 제목 -->
						<tr>
							<th><spring:message code='ezJournal.t184' /></th>
							<td width="100%" id="cTitle" style="WORD-WRAP: break-word; word-break: break-all; line-height: 16px;" colspan=3>
								<div id="journalTitle" style="vertical-align: middle">
									<c:out value=" ${journal.journalTitle}" />
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		<tr>
			<td class="pad1" id="pad1" style="vertical-align: top; height: 100%;">
<!-- 		        <div class="viewbox" style="text-align:center; padding:0; width:100%; height:100%; overflow:auto; border:1px solid #b6b6b6"> -->
<!-- 				<iframe id="message" name="message" frameborder="0" style="width: 100%; height: 472px; border: 1px solid rgb(221, 221, 221); background: rgb(255, 255, 255);"></iframe> -->
				<iframe src="/ezJournal/journalDetailContent.do?journalId=${journal.journalId }" id="message" name="message" class="viewbox" style="padding:0; width:100%; height:100%; overflow:auto; border:1px solid #b6b6b6">
<!-- 				    <div style="text-align: left;"> -->
<!-- 						<img onclick="Smaller();" style="cursor:pointer; margin:5px;" src="/images/minus.png"> -->
<!-- 				        <img onclick="Bigger();" style="cursor:pointer; margin:5px; margin-left:-10px;" src="/images/plus.png"> -->
<!-- 					</div> -->
<!-- 					<div id="journalContent" style="height:10px;display:inline-block;"> -->
<%-- 			        	${journal.journalContent } --%>
<!-- 					</div> -->
				</iframe>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: top; paddin-top: 5px;">
				<table class="file">
					<tr class="pos1">
						<th><spring:message code='ezJournal.t105' /></th>
						<td>
							<div id="lstAttachLink" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white; text-align: left">
								<c:forEach items="${journal.fileList }" var="file" varStatus="status">
									<div style="margin-top: 3px; height: auto !important;">
										<div class="custom_checkbox">
										    <c:set var="imagePath" value="/images/etc.svg" />
                                            <%-- <input type="checkbox" name="fileSelect" value="${file.fileName }"> --%>
                                            <!-- 		            			<img src="/images/image.png">  -->
                                                <input id="fileSelect${status.index}" type="checkbox" filename="${file.fileEncodeName}" filepath="${file.filePath}">
                                            <c:if test="${file.fileType == 'jpg' || file.fileType == 'jpeg' || file.fileType == 'bmp' || file.fileType == 'gif' || file.fileType == 'png' || file.fileType == 'tif' || file.fileType == 'tiff'}">
                                                <c:set var="imagePath" value="/images/image.svg" />
                                            </c:if>
                                            <c:if test="${file.fileType == 'doc' || file.fileType == 'docx'}">
                                                <c:set var="imagePath" value="/images/doc.svg" />
                                            </c:if>
                                            <c:if test="${file.fileType == 'xls' || file.fileType == 'xlsx'}">
                                                <c:set var="imagePath" value="/images/xls.svg" />
                                            </c:if>
                                            <c:if test="${file.fileType == 'ppt' || file.fileType == 'pptx' || file.fileType == 'pps' || file.fileType == 'ppsx'}">
                                                <c:set var="imagePath" value="/images/ppt.svg" />
                                            </c:if>
                                            <c:if test="${file.fileType == 'txt'}">
                                                <c:set var="imagePath" value="/images/txt.svg" />
                                            </c:if>
                                            <c:if test="${file.fileType == 'zip'}">
                                                <c:set var="imagePath" value="/images/zip.svg" />
                                            </c:if>
                                            <c:if test="${file.fileType == 'pdf'}">
                                                <c:set var="imagePath" value="/images/pdf.svg" />
                                            </c:if>
                                            <c:if test="${file.fileType == 'hwp' || file.fileType == 'hwpx'}">
                                                <c:set var="imagePath" value="/images/hwp.svg" />
                                            </c:if>
                                            <c:if test="${file.fileType == 'ecm'}">
                                                <c:set var="imagePath" value="/images/ecm.svg" />
                                            </c:if>
										<label for="fileSelect${status.index}"><img src="${imagePath}" style="width:20px;height:20px;vertical-align:sub"/>&nbsp; <a href="/ezJournal/journalAttachDown.do?filePath=${file.filePath }&fileName=${file.fileEncodeName}&journalId=${journal.journalId}"><c:out value='${file.fileName }'/>&nbsp;(${file.fileTransSize })</a></label></div><br>
									</div>
								</c:forEach>
							</div>
						</td>
						<td class="pos2" style="white-space: normal; overflow: hidden;">
							<a class="imgbtn imgbck"><span style="width: 57px;" onClick="attach_SelectAll()"><spring:message code='ezJournal.t106' /></span></a>
							<br /> 
							<a class="imgbtn imgbck"><span style="width: 57px;" onClick="attach_Download()"><spring:message code='ezJournal.t26' /></span></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.5); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="" style="border: none;" id="iFrameLayer"></iframe>
	</div>

	<script type="text/javascript">
		    window.offscreenBuffering = true;
		    var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		    var curFontSize = 1;
		    var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	        var journalId = <c:out value="${journal.journalId}" />;
	        
	        window.onresize = function () {
	        	sizeOn();
		    };
		    window.onload = function (){
		    	
// 		    	if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
//                     self.resizeTo(760, 800);
//                 } else {
//                     self.resizeTo(785, 830);
//                 }
		    	
		    	sizeOn();
		    	
		    	try {
			    	opener.parent.left.setRecvCount();
					opener.setRecvCount();
				} catch(e) { }
		    }
		    
		    function sizeOn(){
		    	var contentHeight = document.documentElement.clientHeight - 230;
	            document.getElementById("pad1").style.height = contentHeight + "PX";
	            var contentWidth = document.documentElement.clientWidth - 20;
	            document.getElementById("pad1").style.width = contentWidth + "PX";
		    }
	        
	        
	        function Bigger(doc) {     
                if (nowZoom < maxZoom) {
                    nowZoom += 10;
                } else {
                    return;
                }
                
                $('#message').contents().find('#journalContent').css("zoom",nowZoom + "%");
                sizeOn();
	        }
	        
	        function Smaller(doc) {
                if (nowZoom > minZoom) {
                    nowZoom -= 10;
                } else {
                    return;
                }

                $('#message').contents().find('#journalContent').css("zoom",nowZoom + "%");
                sizeOn();
	        }
		    
		    // 작성자 정보창
		    function OpenUserInfo(pUserID) {
		        GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID, "UserInfo", 420, 450, "NO");
		    }
			
		    // 메일 발송 버튼
		    function fromJournalToMail() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 1200) / 2;
		        var szUrl = "/ezEmail/mailWrite.do?journalId=" + journalId+ "&cmd=journal";
		        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		        window.close();
		    }
		    
		    // 조회자정보
		    function journalViewerList(currentPage) {
		    	if (!currentPage) {
					currentPage = "";
				}
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 620) / 2;
		        var top = (heigth - 425) / 2;
		        var szHref = "/ezJournal/JournalViewerList.do?journalId=" + journalId+"&currentPage="+currentPage;
	            DivPopUpShow(620, 425, szHref);
		    }
		    
		    //엑셀로 저장 (미구현)
		    function convertToExcel(elem){
		    	var title = $("#journalTitle").text().trim();
	    		var browser = navigator.userAgent.toLowerCase();
// 		    	if (-1 != browser.indexOf('trident')) {
// 		        	var output = document.getElementById("journalContent").outerHTML;
		   		 
// 			        var SaveFileName = title;
			 
// 			        var oWin = window.open("about:blank", "_blank");
			 
// 			        oWin.document.write(output);
// 			        oWin.document.close();
// 			        // success = true, false
// 			        var success = oWin.document.execCommand('SaveAs', false, SaveFileName);
// 			        oWin.close();
					
					
// 					if (document.all.excelExportFrame == null) // 프레임이 없으면 만들자~!
// 			        {
// 			            var excelFrame = document.createElement("iframe");
// 			            excelFrame.id = "excelExportFrame";
// 			            excelFrame.name = "excelExportFrame";
// 			            excelFrame.position = "absolute";
// 			            excelFrame.style.zIndex = -1;
// 			            excelFrame.style.visibility = "hidden";
// 			            excelFrame.style.top = "-10px";
// 			            excelFrame.style.left = "-10px";
// 			            excelFrame.style.height = "0px";
// 			            excelFrame.style.width = "0px";
// 			            document.body.appendChild(excelFrame); // 아이프레임을 현재 문서에 쑤셔넣고..
// 			        }
// 			        var frmTarget = document.all.excelExportFrame.contentWindow.document; // 해당 아이프레임의 문서에 접근
			 
// 			        var SaveFileName = title;
			 
// 			        frmTarget.open("text/html", "replace");
// 			        frmTarget.write('<html>');
// 			        frmTarget
// 			                .write('<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr"/>\r\n'); // 별로..
// 			        frmTarget.write('<body onload="saveFile();">');
// 			        frmTarget.write(document.getElementById("journalContent").outerHTML); // tag를 포함한 데이터를 쑤셔넣고
// 			        frmTarget.write('<script language="javascript">');
// 			        frmTarget
// 			                .write('function saveFile(){document.execCommand("SaveAs", true, "'
// 			                        + SaveFileName + '");}');
// 			        frmTarget.write('<\/script>');
// 			        frmTarget.write('</body>');
// 			        frmTarget.write('</html>');
// 			        frmTarget.close();
// 			        frmTarget.charset="UTF-8"; // 자 코드셋을 원하는걸로 맞추시고..
// // 			        frmTarget.charset = "euc-kr";
// 			        frmTarget.focus();

// 		        } else {
			    	var uri = $("#journalContent").battatech_excelexport({
	                    // 테이블 아이디
	                    containerid: "journalContent", 
	                    // 데이터 타입 설정
	                    datatype: 'table', 
	                    // URI return 여부
	                    returnUri: true
	                });
	                // 파일이름, URI 설정
	                $(elem).attr('download', title).attr('href', uri);
// 		        }
		    }
		    
		    //수신자정보
		    function journalReceiverList(currentPage) {
		    	if (!currentPage) {
					currentPage = "";
				}
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 620) / 2;
		        var top = (heigth - 425) / 2;
		        var szHref = "/ezJournal/JournalReceiverList.do?journalId=" + journalId + "&currentPage=" + currentPage;
	            DivPopUpShow(620, 425, szHref);
		    }
		    
		    //인쇄
		    function printJournal(){
		    	var data = $('#message').contents().find('#journalContent').html();
		    	var mywindow = window.open('', 'journalContent', 'height=1000,width=1000');
		    	mywindow.document.write('<html><head><title><spring:message code="ezJournal.t1" /></title>');
		    	mywindow.document.write('<style type="text/css">p {margin-top: 0px;margin-bottom: 0px;}</style>');
		    	mywindow.document.write('</head><body >');
		    	mywindow.document.write(data);
		    	mywindow.document.write('</body></html>');
		    	mywindow.document.close();
		    	mywindow.focus();
		    	mywindow.print();
		    	
		    	/* 2020-06-18 홍승비 - 크롬 브라우저에서 close가 바로 동작하여 print하지 못하는 현상 발생, close부분 임시 주석처리(타 모듈에서도 인쇄창을 바로 close하지 않음) */
		    	//mywindow.close();
		    	return true;
		    }
		    
			function addRelatedCabinet() {
				//* moon 2018.07.26
				window.open("/ezCabinet/cabinetAddRelated.do?module=jounl", "addRelated", getOpenWindowfeature(480, 505));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
			
		  //업무일지 댓글
		    function openJournalReply() {
		    	DivPopUpShow($('body').prop('scrollWidth') * 0.95, $('body').prop('scrollHeight') * 0.92, "/ezJournal/journalReply.do?journalId="+journalId);
		    }
		  
		  function addReplyCount(){
			  $("#replyCount").text(Number($("#replyCount").text()) + 1);
		  }
		  function minusReplyCount(){
			  $("#replyCount").text(Number($("#replyCount").text()) - 1);
		  }
		</script>

	</body>
</html>