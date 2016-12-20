<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t927' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<c:if test="${fn:indexOf(User-Agent, 'rv:11') > 0}">
			<style>
		        p {
		            LINE-HEIGHT: 20px; MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; FONT-SIZE: 10pt;
		        }
		        div {
		            LINE-HEIGHT: 20px; MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; FONT-SIZE: 10pt;
		        }
		    </style>
			
		</c:if>
		<style title="ezform_style_1">
			P {
				MARGIN-TOP : 0mm;
				MARGIN-BOTTOM: 0mm;
			}
		</style>
		
		<script type="text/javascript">
			var curFontSize = 1;
		    var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		    var gubun = "<c:out value='${gubun}' />";
		    var pUse_Editor = "<c:out value='${Use_Editor}' />";
		    var pUse_IE11Browser = "<c:out value='${Use_IE11Browser}' />";
	
		    window.onload = function () {
		        var WriterName ="<c:out value='${userInfo.displayName1}' />";
		        var WriteDate = window.opener.GetStartDate();
		        var pEndDate = window.opener.GetEndDate();
		        var WriterDeptName = "<c:out value='${userInfo.deptName1}' />";
		        var WriterTitle = "<c:out value='${userInfo.title1}' />";
		        var WriterPhone = "<c:out value='${userInfo.phone}' />";
		        var Title = window.opener.document.getElementById('txtTitle').value;
	
		        if (CrossYN()) {
		            if (pUse_Editor == "TAGFREE") {
		                Content = window.opener.document.getElementById('message').contentWindow.GetEditorContent();
		            } else {
		                Content = window.opener.document.getElementById('message').contentWindow.GetEditorContent();
		            }
		        } else {
		            try {
		                if (pUse_IE11Browser == "CK") {
		                    Content = window.opener.document.getElementById('message').contentWindow.GetEditorContent();
		                } else {
		                    Content = window.opener.pzFormProc.Editor.Dom.body.innerHTML;
		                }
		            } catch (e) {
		                Content = window.opener.document.getElementById('message').contentWindow.GetEditorContent();
		            }
		        }
	
		        if (gubun != 3) {
		            var AttachHTML = window.opener.document.getElementById('lstAttachLink').innerHTML;
		            AttachHTML = ReplaceText(AttachHTML, "%3b", ";");
		            AttachHTML = ReplaceText(AttachHTML, "%2b", "+");
		            document.getElementById('lstAttachLink').innerHTML = ReplaceText(AttachHTML, "<A href=", "<A temp=");
		        }
	
		        if (gubun != "2") {
		        	document.getElementById('WriteUserNM').innerHTML = WriterName;
		        } else {
		        	document.getElementById('WriteUserNM').innerHTML = window.opener.document.getElementById('txtNickName').value;
		        }
	
		        if (document.getElementById('WriteUserNM').innerText == "") {
		        	document.getElementById('WriteUserNM').innerHTML = "<spring:message code='ezCommunity.t929'/>";
		        }
	
		        if (WriteDate == "") {
		        	WriteDate = "<c:out value='${strNow}' />";
		        }
		        
		        document.getElementById('PostDate').innerHTML = WriteDate;
		        
		        if (pEndDate.substr(0, 4) == "9999") {
		        	pEndDate = "<spring:message code='ezCommunity.t930'/>";
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
		        document.getElementById('txtContent').innerHTML = "<div id='ezFormProc_div' class='margin' style='font-family:dotum, arial, verdana'>" + txtContent.innerHTML + "</div>";
		        document.getElementById('txtContent').innerHTML = ReplaceText(document.getElementById('txtContent').innerHTML, "onmouseover", "");
		        document.getElementById('txtContent').innerHTML = ReplaceText(document.getElementById('txtContent').innerHTML, "onfocus", "");
	
		        var Anchors = document.getElementById('txtContent').getElementsByTagName("A");
		        
		        for (var j = 0; j < Anchors.length; j++) {
		            Anchors.item(j).target = "_blank";
		        }
	
		        var TDs = document.getElementById('txtContent').getElementsByTagName("TD");
		        
		        for (var i = 0; i < TDs.length; i++) {
		            if (TDs.item(i).innerHTML == "") {
		            	TDs.item(i).innerHTML = "&nbsp;";
		            }
		        }
		    }
	
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
		        document.getElementById("ItemOverflow").style.width = document.body.clientWidth - 30 + "px";
		    }
		</script>
	</head>
	<body class="popup" style="background-image: none" onresize="ResizeDiv()">
		<table class="layout">
	        <tr>
	        	<td style="height:20px">
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezCommunity.t138' /></th>
	                        <td id="WriteUserNM" style="white-space:nowrap">
	                            <div id="title" style="vertical-align: middle; width: 100%; height: 16px; overflow-y: auto; cursor: pointer"></div>
	                        </td>
	                        <th><spring:message code='ezCommunity.t209' /></th>
	                        <td id="PostDate" style="padding-right: 10px;white-space:nowrap;">
	                            <div id="title" style="vertical-align: middle; width: 100%; height: 16px; overflow-y: auto;"></div>
	                        </td>
	                        <th><spring:message code='ezCommunity.t931' /></th>
	                        <td id="EndDate" style="padding-right: 10px;width:100%;white-space:nowrap">
	                            <div id="title" style="vertical-align: middle; width: 100%; height: 16px; overflow-y: auto;"></div>
	                        </td>
	                    </tr>
	                    
	                    <c:if test="${gubun != '2' }">
	                    	<tr>
		                        <th><spring:message code='ezCommunity.t932' /></th>
		                        <td id="User_DeptNM" style="width:100px;white-space:nowrap"></td>
		                        <th><spring:message code='ezCommunity.t268' /></th>
		                        <td style="white-space:nowrap" id="User_JobTitle"></td>
		                        <th><spring:message code='ezCommunity.t269' /></th>
		                        <td style="width:100%;white-space:nowrap" id="Telephone"></td>
	                    	</tr>
	                    </c:if>
	                    
	                    <tr>
	                        <th><spring:message code='ezCommunity.t210' /></th>  
	                        <td id="cTitle" style="WORD-WRAP: break-word" colspan="5">
	                            <div id="txtTitle" style="OVERFLOW-Y: auto; WIDTH: 100%; HEIGHT: 20px; valign: middle"></div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	        <tr>
	            <td class="pad1">
	                <div id="ItemOverflow" class="viewbox" style="overflow: auto; height: 520px; width:737px;">
	                    <div id="txtContent" class="white" style="width: 100%;height:100%; overflow-y: auto"></div>
	                </div>
	            </td>
	        </tr>
	        
	        <c:if test="${gubun !='3' }">
	        	<tr>
		            <td style="height:20px">
		                <table class="file">
		                    <tr>
		                        <th><spring:message code='ezCommunity.t933' /></th>
		                        <td>
		                            <div align="left" id="lstAttachLink" style="margin-top: 0px; padding-top: 0px; OVERFLOW: auto; HEIGHT: 58px; background-color: white"></div>
		                        </td>
		                        <td id="ItemLevel" style="display: none"></td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
	        </c:if>
	        
	    </table>
	</body>
</html>