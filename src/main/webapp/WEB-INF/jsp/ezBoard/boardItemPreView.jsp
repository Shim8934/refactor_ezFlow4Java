<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t282'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="/css/previewBoard.css" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
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
			            
			            var tmeptr = _tempList.getElementsByTagName("TR");
	
			            for (var i = 1; i < tmeptr.length; i++) {
			                var span = document.createElement("SPAN");
			                var input = document.createElement("INPUT");
			                input.type = "checkbox";
			
			                var img = document.createElement("IMG");
			                img.src = "/images/email/mail_006.gif";
			
			                var a = document.createElement("A");
		                    var filename = GetChildNodes(tmeptr[i])[1].textContent;
		                    var filesize = GetChildNodes(tmeptr[i])[2].textContent;
		                    
			                a.innerHTML = filename + " (" + filesize + ")";
			
			                var br = document.createElement("BR");
			
			                span.appendChild(input);
			                span.appendChild(img);
			                span.appendChild(a);
			                span.appendChild(br);
			
			                _tempList2.appendChild(span);
			            }
			            var AttachHTML = _tempList2.outerHTML;
			
			            AttachHTML = ReplaceText(AttachHTML, "%3b", ";");
			            AttachHTML = ReplaceText(AttachHTML, "%2b", "+");
			            document.getElementById('lstAttachLink').innerHTML = ReplaceText(AttachHTML, "<A href=", "<A temp=");
		        	} else {
		        		var AttachHTML = window.opener.lstAttachLink.innerHTML;
		                AttachHTML = ReplaceText(AttachHTML, "%3b", ";");
		                AttachHTML = ReplaceText(AttachHTML, "%2b", "+");
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
		            if (document.getElementById("extensionAttribute" + i) != null) {
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
		
		                document.getElementById("extensionAttribute" + i).innerHTML = WriterValue;
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
		        document.getElementById("ItemOverflow").style.width = document.body.clientWidth - 45 + "px";
		    }
		</script>
	</head>
	<body class="popup" style="background-image:none" onresize="ResizeDiv()">
		<table class="layout">
		  <tr>
		    <td style="height:20px"><table class="content">
		        <tr>
		          <th><spring:message code='ezBoard.t207'/></th>
		          <td id="WriteUserNM" style="white-space:nowrap; width:200px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;cursor:pointer"></div></td>
		          <th><spring:message code='ezBoard.t224'/></th>
		          <td id="PostDate" style="padding-right:10px; white-space:nowrap; width:300px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;"></div></td>
		          <th><spring:message code='ezBoard.t288'/></th>
		          <td id="EndDate" style="padding-right:10px; white-space:nowrap; width:200px"><div id = title style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;"></div></td>
		        </tr>
		        <c:if test="${guBun != '2'}">
			        <tr>
			          <th><spring:message code='ezBoard.t289'/></th>
			          <td id="User_DeptNM" style="white-space:nowrap; width:200px"></td>
			          <th><spring:message code='ezBoard.t290'/></th>
			          <td id="User_JobTitle" style="white-space:nowrap; width:200px"></td>
			          <th><spring:message code='ezBoard.t38'/></th>
			          <td id="Telephone" style="width:200px"></td>
			        </tr>
		        </c:if>
		        <tr>
		          <th><spring:message code='ezBoard.t291'/></th>
		          <td id="cTitle" style="WORD-WRAP: break-word" colSpan="5"><div id="txtTitle" style="OVERFLOW-Y: auto; WIDTH: 100%; HEIGHT: 16px; vertical-align: middle"></div></td>
		        </tr>
		      </table>
		      </td>
		  </tr>
		  <tr>
		    <td class="pad1">
		        <div id="ItemOverflow" class="viewbox" style="overflow-y: auto; height:510px; width:730px;">
		            <div id="txtContent" class="white" style="height:100%; "></div>
		        </div>
		    </td>
		    <c:if test="${guBun != '3'}">
			  <tr>
			    <td style="height:20px">
				    <table class="file">
				        <tr>
				          <th><spring:message code='ezBoard.t292'/></th>
				          <td><div id="lstAttachLink" style="margin-top:0px;padding-top:0px;OVERFLOW: auto; HEIGHT: 58px; background-color:white; text-align:left"></div></td>
				          <td id="ItemLevel" style="display:none"></td>
				        </tr>
			      	</table>
			    </td>
			  </tr>
		    </c:if>
		</table>
	</body>
</html>