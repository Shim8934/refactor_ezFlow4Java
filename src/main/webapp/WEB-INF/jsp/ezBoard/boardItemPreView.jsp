<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t282'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/previewBoard.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
		
		var curFontSize = 1;
		var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		var gubun = "${guBun}";
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
			                img.src = "/images/email/mail_006.gif";
			
			                var a = document.createElement("A");
		                    var filename = GetChildNodes(tmeptr[i])[1].textContent;
		                    var filesize = GetChildNodes(tmeptr[i])[2].textContent;
		                    a.innerHTML = MakeXMLString(filename) + " (" + filesize + ")";
		                    
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
		        	document.getElementById('WriteUserNM').innerHTML = WriterName;
		        } else {
		        	document.getElementById('WriteUserNM').innerHTML = window.opener.document.getElementById('txtNickName').value;
		        }
		        if (document.getElementById('WriteUserNM').innerText == "") {
		        	document.getElementById('WriteUserNM').innerHTML = "<spring:message code='ezBoard.t286'/>";
		        }
		        if (WriteDate == "") {
		        	WriteDate = "${strNow}";
		        }
		        
		        document.getElementById('PostDate').innerHTML = WriteDate;
		        
		        if (pEndDate.substr(0, 4) == "9999") {
		        	pEndDate = "<spring:message code='ezBoard.t287'/>";
		        } else {
		        	pEndDate = pEndDate.split(" ")[0];
		        }
		        document.getElementById('EndDate').innerHTML = pEndDate;
		        if (gubun != 2) {
		            document.getElementById('User_DeptNM').innerHTML = MakeXMLString(WriterDeptName);
		            document.getElementById('User_JobTitle').innerHTML = WriterTitle;
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
		
		        for (var i = 0; i < 5; i++) {
		            if (document.getElementById("extensionAttribute" + (i + 6)) != null) {
		                var paremtElement = opener.document.getElementsByName("extensionAttribute" + (i + 6));
		                var WriterValue = "";
		                if (paremtElement.length > 1) {
		                    for (var j = 0; j < paremtElement.length; j++) {
		                        if (paremtElement[j].checked) {
		                            WriterValue += paremtElement[j].value + ",";
		                        }
		                    }
		                    WriterValue = WriterValue.substring(0, WriterValue.length - 1);
		                } else {
		                    WriterValue = paremtElement[0].value;
		                }
		
		                document.getElementById("extensionAttribute" + (i + 6)).innerHTML = WriterValue;
		            }
		        }
		    };
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
		    function ResizeDiv() {
// 		        document.getElementById("ItemOverflow").style.width = document.body.clientWidth - 45 + "px";
		    }
		</script>
	</head>
	<body class="popup" style="background-image:none" onresize="ResizeDiv()">
		<table class="layout" style="width:100%;">
			<tr>
		    	<td style="vertical-align: top; height:20px">
		    		<!-- 2018-02-01 김보미 - 테이블 컬럼 순서 조정 -->
		    		<table class="content" style="width:100%;">
						<!-- 게시자&부서 -->
						<tr>
							<th style="width:10%;"><spring:message code='ezBoard.t207'/></th> 
							<td id="WriteUserNM" style="white-space:nowrap; width:40%">
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
		        <tr>
		          <th><spring:message code='ezBoard.t291'/></th>
		          <td id="cTitle" style="WORD-WRAP: break-word" colSpan="5"><div id="txtTitle" style="OVERFLOW-Y: auto; WIDTH: 100%; HEIGHT: 15px; vertical-align: middle"></div></td>
		        </tr>
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
	       					</c:choose>
	       				</tr>
	       			</c:forEach>
	<!-- 	          추가 항목이 있을 경우 끝 -->
			      </table>
		      </td>
		  </tr>
		  <tr>
			<td class="pad1">
			<!-- 2018-02-02 김보미 - height:auto로 변경 -->
		        <div id="ItemOverflow" class="viewbox" style="overflow: auto; padding:10px 10px 10px 10px; height:auto; width:auto; word-break: break-all;">
		            <div id="txtContent" class="white" style="overflow-y:auto; height:100%; width: 100%"></div>
		        </div>
		    </td>
			</tr>
		    <c:if test="${guBun != '3'}">
			  <tr>
			    <td style="height:20px">
				    <table class="file">
				        <tr>
				          <th><spring:message code='ezBoard.t292'/></th>
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