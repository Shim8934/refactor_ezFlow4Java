<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t282'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/previewBoard.css')}" type="text/css">
		<style type="text/css">
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
			.popup h1, .popup h2 {height:auto;}
			div#txtContent{margin-left:0px; margin-right:0px;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<script type="text/javascript">
		
		var curFontSize = 1;
		var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		var gubun = "<c:out value='${guBun}'/>";
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    window.onload = function () {
		        var WriterName = "${userInfo.displayName}";
		        var WriteDate = window.opener.GetStartDate();
		        var pEndDate = window.opener.GetEndDate();
		        var WriterDeptName = "${userInfo.deptName}";
		        var WriterTitle = "${userInfo.title}";
		        var WriterPhone = "${userInfo.phone}";
		        var pUse_Editor = "${useEditor}";
		        var Title = window.opener.document.getElementById('txtTitle').value;
		        var Content = window.opener.document.getElementById('message').contentWindow.GetEditorContent();
				var writerNameType = "<c:out value = '${writerNameType}'/>"; // 2025-01-21 임정은 - 게시자명선택 타입 (0 : 이름, 1 : 부서명)
				
		        if (gubun != 3) {
		        	if (CrossYN()) {
			            var _tempList = document.createElement("table");
			            var _tempList2 = document.createElement("div");
			            _tempList.innerHTML = window.opener.dadiframe.document.getElementById("lstAttachLink").innerHTML;
			            _tempList2.style.height = "58px";
			            
			            var tmeptr = _tempList.getElementsByTagName("TR");
	
			            /* 2018-07-10 홍승비 - 게시물 미리보기 시 첨부파일 체크박스 제거, 스크롤 높이 조절, 특문처리 */
			            for (var i = 1; i < tmeptr.length; i++) {
			                var span = document.createElement("SPAN");
			                var img = document.createElement("IMG");
			                var a = document.createElement("A");
		                    var filename = GetChildNodes(tmeptr[i])[1].textContent;
		                    var filesize = GetChildNodes(tmeptr[i])[2].textContent;
		                    a.innerHTML = MakeXMLString(filename) + " (" + filesize + ")";
		                    
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
		                    
			                var br = document.createElement("BR");
			
			                span.appendChild(img);
			                span.appendChild(a);
			                span.appendChild(br);
			
			                _tempList2.appendChild(span);
			            }
			            var AttachHTML = _tempList2.outerHTML;
			
// 			            AttachHTML = ReplaceText(AttachHTML, "%3b", ";");
// 			            AttachHTML = ReplaceText(AttachHTML, "%2b", "+");
			            document.getElementById('lstAttachLink').innerHTML = ReplaceText(AttachHTML, "<A href=", "<A temp=");
		        	} else {
		        		var AttachHTML = window.opener.lstAttachLink.innerHTML;
// 		                AttachHTML = ReplaceText(AttachHTML, "%3b", ";");
// 		                AttachHTML = ReplaceText(AttachHTML, "%2b", "+");
		                lstAttachLink.innerHTML = ReplaceText(AttachHTML, "<A href=", "<A temp=");
		        	}
		        }
		        if (gubun != "2") {
					if (writerNameType == "1") {
						document.getElementById('WriteUserNM').innerHTML = WriterDeptName;
					} else {
						document.getElementById('WriteUserNM').innerHTML = WriterName;
					}
		        } else { // 익명게시판의 게시자명 특문처리 대응
		        	document.getElementById('WriteUserNM').innerText = window.opener.document.getElementById('txtNickName').value;
		        }
		        if (document.getElementById('WriteUserNM').innerText == "") {
		        	document.getElementById('WriteUserNM').innerHTML = "<spring:message code='ezBoard.t286'/>";
		        }
		        if (WriteDate == "") {
		        	WriteDate = "${strNow}";
		        }
		        
		        document.getElementById('PostDate').innerHTML = WriteDate.substring(0, 16);
		        
		        if (pEndDate.substr(0, 4) == "9999") {
		        	pEndDate = "<spring:message code='ezBoard.t287'/>";
		        } else {
		        	pEndDate = pEndDate.split(" ")[0];
		        }
		        document.getElementById('EndDate').innerHTML = pEndDate;
		        if (gubun != 2) {
		            document.getElementById('User_DeptNM').innerHTML = MakeXMLString(WriterDeptName);
					if (writerNameType == "1") {
						document.getElementById('User_JobTitle').innerHTML = WriterDeptName;
					} else {
		            	document.getElementById('User_JobTitle').innerHTML = WriterTitle;
					}
		            document.getElementById('Telephone').innerHTML = WriterPhone;
		        }
		        document.getElementById('txtTitle').innerHTML = MakeXMLString(Title);
		        document.getElementById('txtContent').innerHTML = ExtractBetweenPattern(Content, "kaoni>", "</body>");
		        document.getElementById('txtContent').innerHTML = ReplaceText(document.getElementById('txtContent').innerHTML, "onmouseover", "");
		        document.getElementById('txtContent').innerHTML = ReplaceText(document.getElementById('txtContent').innerHTML, "onfocus", "");
		        var TDs = document.getElementById('txtContent').getElementsByTagName("TD");
		        for (var i = 0; i < TDs.length; i++) {
		            if (TDs.item(i).innerHTML == "") TDs.item(i).innerHTML = "&nbsp;";
		        }
		
		        /* 2019-10-24 홍승비 - 확장칼럼 사용 시 라디오버튼, 체크박스 선택지가 하나인 경우, 미리보기에서 반드시 표출되는 오류 수정 */
		        for (var i = 0; i < 5; i++) {
					if (document.getElementById("extensionAttribute" + (i + 6)) != null) {
						var paremtElement = opener.document.getElementsByName("extensionAttribute" + (i + 6));
		                var WriterValue = "";
		                if (paremtElement.length > 0) {
		                    for (var j = 0; j < paremtElement.length; j++) {
		                        if ((paremtElement[j].type == "radio" || paremtElement[j].type == "checkbox") && paremtElement[j].checked) { // 라디오버튼 또는 체크박스
		                            WriterValue += paremtElement[j].value + ",";
		                        } else if (paremtElement[j].type == "text" || paremtElement[j].getAttribute('type') == "textArea") { // 텍스트
		                        	WriterValue = paremtElement[j].value;
		                        } else if (paremtElement[j].getAttribute('type') == "people") {
		                            WriterValue = paremtElement[j].innerText;
		                        } else if (paremtElement[j].tagName == "SELECT") {
		                            WriterValue = paremtElement[j].value;
		                        }
		                    }
			                
		                	if (paremtElement[0].type == "radio" || paremtElement[0].type == "checkbox") {
		                    	WriterValue = WriterValue.substring(0, WriterValue.length - 1);
		                	}
		                    document.getElementById("extensionAttribute" + (i + 6)).innerText = WriterValue;
		                }
		            }
		        }
		        
		        // 2024-08-23 전인하 - 게시판 > 미리보기 시 키워드 값 삽입
		        var keywords = window.opener.keywordArr;
		        if (keywords.length > 0) {
		            document.querySelector('#cKeywordTr').style.display = '';
		            for (let i = 0; i < keywords.length; i++) {
		                var keywordObj = makeKeywordSpanObj(keywords[i], "print");
                        document.querySelector('#cKeyword').append(keywordObj);
		            }
		        }
		    };
		    
		    /* 2019-05-16 홍승비 - 처음 리사이즈 동작을 ready  시점으로 변경 */
		    $(document).ready(function() {
		    	ResizeDiv();
		    });
		    
		    function MakeXMLString(str) {
		        str = ReplaceText(str, "&", "&amp;");
		        str = ReplaceText(str, "<", "&lt;");
		        str = ReplaceText(str, ">", "&gt;");
		        return str;
		    }
		    function ExtractBetweenPattern(orgStr, firstPattern, lastPattern) {
		        var sIndex, eIndex;
		        var copyStr = new String(orgStr);
		        var retStr = "", subStr;
		        var regFExp = new RegExp(firstPattern, "i");
		        var regEExp = new RegExp(lastPattern, "i");
		        var loop = 0;
		        sIndex = copyStr.search(regFExp);
		        if (sIndex == -1) {
		            return orgStr;
		        }
		        copyStr = copyStr.substr(sIndex + firstPattern.length);
		        eIndex = copyStr.search(regEExp);
		        if (eIndex == -1) {
		            return copyStr;
		        }
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function Bigger() {
		        if (curFontSize < 4) {
		            curFontSize += 1;
		        }
		        document.getElementById('txtContent').style.fontSize = fontSize[curFontSize];
		    }
		    function Smaller() {
		        if (curFontSize > 0) {
		            curFontSize -= 1;
		        }
		        document.getElementById('txtContent').style.fontSize = fontSize[curFontSize];
		    }
		    
		    /* 2019-05-16 홍승비 - 미리보기 시 가로 리사이즈 추가 */
		    function ResizeDiv() {
 		        document.getElementById("ItemOverflow").style.height = (window.innerHeight - document.getElementById("topTable").clientHeight - 124) + "px";
				document.getElementById("ItemOverflow").style.width = (document.documentElement.clientWidth - 40) + "px";
		    }
		</script>
	</head>
	<body class="popup" style="background-image:none" onresize="ResizeDiv()">
		<table class="layout" style="width:100%;">
			<tr>
		    	<td style="vertical-align: top; height:20px">
		    		<!-- 2018-02-01 김보미 - 테이블 컬럼 순서 조정 -->
		    		<table id="topTable" class="content" style="width:100%; height:100%;">
						<!-- 게시자&부서 -->
						<tr>
							<th style="width:10%;"><spring:message code='ezBoard.t223'/></th> 
							<%-- 2019-09-17 홍승비 - 익명게시판 게시물 작성 시 미리보기 TD 수정 --%>
							<c:choose>
								<c:when test="${guBun == '2'}">
									<td id="WriteUserNM" style="white-space:nowrap; width:40%" colspan="3">
								</c:when>
								<c:otherwise>
									<td id="WriteUserNM" style="white-space:nowrap; width:40%">
								</c:otherwise>
							</c:choose>
								<div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;cursor:pointer"></div>
							</td>
							<c:if test="${guBun != '2'}">
								<th style="width:10%;"><spring:message code='ezBoard.t289'/></th>
								<td id="User_DeptNM" style="white-space:nowrap; width:40%"></td>
							</c:if>
						</tr>
						<!-- 직위&사내전화 -->
						<c:if test="${guBun != '2'}">
						<tr>
							<th style="width:10%;"><spring:message code='ezBoard.t290'/></th>
							<td id="User_JobTitle" style="white-space:nowrap; width:40%"></td>
							<th style="width:10%;"><spring:message code='ezPersonal.t177'/></th>
						    <td id="Telephone" style="width:40%"></td>
						</tr>
						</c:if>
						<!-- 게시일&게시종료일 -->
						<tr>
							<th style="width:10%;"><spring:message code='ezBoard.t224'/></th>
							<td id="PostDate" style="padding-right:10px; white-space:nowrap; width:40%"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;"></div></td>
							<th style="width:10%;"><spring:message code='ezBoard.t288'/></th>
							<td id="EndDate" style="padding-right:10px; white-space:nowrap; width:40%"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;"></div></td>
						</tr>

<!-- 		  <tr> -->
<!-- 		    <td style="height:20px"><table class="content"> -->
<!-- 		        <tr> -->
<%-- 		          <th><spring:message code='ezBoard.t207'/></th> --%>
<!-- 		          <td id="WriteUserNM" style="white-space:nowrap; width:200px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;cursor:pointer"></div></td> -->
<%-- 		          <th><spring:message code='ezBoard.t224'/></th> --%>
<!-- 		          <td id="PostDate" style="padding-right:10px; white-space:nowrap; width:300px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;"></div></td> -->
<%-- 		          <th><spring:message code='ezBoard.t288'/></th> --%>
<!-- 		          <td id="EndDate" style="padding-right:10px; white-space:nowrap; width:200px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;"></div></td> -->
<!-- 		        </tr> -->
<%-- 		        <c:if test="${guBun != '2'}"> --%>
<!-- 			        <tr> -->
<%-- 			          <th><spring:message code='ezBoard.t289'/></th> --%>
<!-- 			          <td id="User_DeptNM" style="white-space:nowrap; width:200px"></td> -->
<%-- 			          <th><spring:message code='ezBoard.t290'/></th> --%>
<!-- 			          <td id="User_JobTitle" style="white-space:nowrap; width:200px"></td> -->
<%-- 			          <th><spring:message code='ezBoard.t38'/></th> --%>
<!-- 			          <td id="Telephone" style="width:200px"></td> -->
<!-- 			        </tr> -->
<%-- 		        </c:if> --%>

	<!-- 		        추가 항목이 있을 경우 -->
	       			<c:forEach var="boardAttributeVO" items="${boardAttributeListVO}" step="1" varStatus="status">
	       				<tr>
	       					<c:choose>
	       						<c:when test="${extenLang == 1}">
	         						<th>${boardAttributeVO.colName1}</th>
	       						</c:when>
	       						<c:otherwise>
	       							<th>${boardAttributeVO.colName2}</th>
	       						</c:otherwise>
	       					</c:choose>
	       					<c:choose>
	       						<c:when test="${boardAttributeVO.colType == 'radio'}">
					                <td colspan="5" id="${boardAttributeVO.tableCol}">
					                </td>
	      						</c:when>
	      						<c:when test="${boardAttributeVO.colType == 'text'}">
					                <td colspan="5" id="${boardAttributeVO.tableCol}">
					                </td>
	       						</c:when>
	       						<c:when test="${boardAttributeVO.colType == 'check'}">
					                <td colspan="5" id="${boardAttributeVO.tableCol}">
					                </td>
	       						</c:when>
	       						<c:when test="${boardAttributeVO.colType == 'people'}">
                                    <td colspan="5" id="${boardAttributeVO.tableCol}">
                                    </td>
                                </c:when>
                                <c:when test="${boardAttributeVO.colType == 'textArea'}">
                                    <td colspan="5" id="${boardAttributeVO.tableCol}">
                                    </td>
                                </c:when>
								<c:when test="${boardAttributeVO.colType == 'cal'}">
									<td colspan="5" id="${boardAttributeVO.tableCol}">
									</td>
								</c:when>
								<c:when test="${boardAttributeVO.colType == 'select'}">
								    <td colspan="5" id="${boardAttributeVO.tableCol}">
									</td>
								</c:when>
	       					</c:choose>
	       				</tr>
	       			</c:forEach>
	<!-- 	          추가 항목이 있을 경우 끝 -->
		        <tr>
		          <th><spring:message code='ezBoard.t291'/></th>
		          <td id="cTitle" style="WORD-WRAP: break-word" colSpan="5"><div id="txtTitle" style="OVERFLOW-Y: auto; WIDTH: 100%; vertical-align: middle"></div></td>
		        </tr>
		         <!-- 키워드 -->
                 <tr id="cKeywordTr" style="display:none">
                     <th><spring:message code="ezApprovalG.t1200" /></th>
                     <td width="100%" id="cKeyword" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
                     </td>
                 </tr>
			      </table>
		      </td>
		  </tr>
		  <tr>
			<td class="pad1">
			<%-- 2018-02-02 김보미 - height:auto로 변경 / 2018-11-27 홍승비 - min-height값 추가 --%>
		        <div id="ItemOverflow" class="viewbox" style="overflow: auto; padding:10px 10px 10px 10px; height:auto; min-height:120px; width:auto; word-break: break-all;">
		            <div id="txtContent" class="white" style="overflow-y:auto; height:100%; width: 100%"></div>
		        </div>
		    </td>
			</tr>
		    <c:if test="${guBun != '3'}">
			  <tr>
			    <td style="height:20px">
				    <table class="file">
				        <tr>
				          <th><spring:message code='ezBoard.t10025'/></th>
				          <td style="padding-right:0px"><div id="lstAttachLink" style="margin-top:0px;padding-top:0px;OVERFLOW: auto; HEIGHT: 58px; background-color:white; text-align:left"></div></td>
				          <td id="ItemLevel" style="display:none"></td>
				        </tr>
			      	</table>
			    </td>
			  </tr>
		    </c:if>
		</table>
	</body>
</html>