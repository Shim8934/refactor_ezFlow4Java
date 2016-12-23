<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t365'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/ezHistory_Cross.js"></script>
	    <script type="text/javascript">
	        var pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight;
	        var pRegDate, pDelDate, pRegUserID, pRegUserName;
	        var companyID;
	        window.onload = function () {
	            try {
	                try {
	                    pSealNum = opener.ezSealInfo_dialogArguments[0][0];
	                    pSealName = opener.ezSealInfo_dialogArguments[0][1];
	                    pSealPath = opener.ezSealInfo_dialogArguments[0][2];
	                    pSealWidth = opener.ezSealInfo_dialogArguments[0][3];
	                    pSealHeight = opener.ezSealInfo_dialogArguments[0][4];
	                    pRegDate = opener.ezSealInfo_dialogArguments[0][5];
	                    pDelDate = opener.ezSealInfo_dialogArguments[0][6];
	                    pRegUserID = opener.ezSealInfo_dialogArguments[0][7];
	                    pRegUserName = opener.ezSealInfo_dialogArguments[0][8];
	                } catch (e) {
	                    pSealNum = dialogArguments.window.document.Script.parameter[0];
	                    pSealName = dialogArguments.window.document.Script.parameter[1];
	                    pSealPath = dialogArguments.window.document.Script.parameter[2];
	                    pSealWidth = dialogArguments.window.document.Script.parameter[3];
	                    pSealHeight = dialogArguments.window.document.Script.parameter[4];
	                    pRegDate = dialogArguments.window.document.Script.parameter[5];
	                    pDelDate = dialogArguments.window.document.Script.parameter[6];
	                    pRegUserID = dialogArguments.window.document.Script.parameter[7];
	                    pRegUserName = dialogArguments.window.document.Script.parameter[8];
	                }
	
	                if (window.ActiveXObject || "ActiveXObject" in window) {
	                    setNodeText(document.getElementById("SealName"),pSealName);
	                    setNodeText(document.getElementById("SealSize"),pSealWidth + "mm * " + pSealHeight + "mm");
	                    setNodeText(document.getElementById("RegDate"),pRegDate);
		            if (pDelDate == "") {
		                setNodeText(document.getElementById("DelDate"),"--");
		            }
		            else {
		                setNodeText(document.getElementById("DelDate"),pDelDate);
		            }
		        }
		        else {
	                setNodeText(document.getElementById("SealName") , pSealName);
	                setNodeText(document.getElementById("SealSize") , pSealWidth + "mm * " + pSealHeight + "mm");
	                setNodeText(document.getElementById("RegDate") , pRegDate);
	                
		            if (pDelDate == "") {
		                setNodeText(document.getElementById("DelDate") , "--");
		            }
		            else {
		                setNodeText(document.getElementById("DelDate") , pDelDate);
		            }
		        }
		        document.getElementById("RegUser").innerHTML = "<span style=\"cursor:pointer\" onclick='return openUserInfo(\"" + pRegUserID + "\")'>" + pRegUserName + "</span>";
		        document.getElementById("signimage").style.width = pSealWidth + "mm";
		        document.getElementById("signimage").style.height = pSealHeight + "mm";
		        document.getElementById("signimage").src = "/ezCommon/downloadAttach.do?filePath=" + pSealPath;
		    } catch (e) {
		        alert("window_onload : " + e.description);
		    }
		}
	
		function openUserInfo(tempUserID) {
		    var wfileLocation = "/ezCommon/showPersonInfo.do?id=" + tempUserID
		    var result = GetOpenWindow(wfileLocation, "", 420, 450, "NO");
		}
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApproval.t366'/></h1>
	
	    <div id="close">
	        <ul>
	            <li><span onclick="window.close()"><spring:message code='ezApproval.t70'/></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	    <table style="width: 470px" class="content">
	        <tr>
	            <th><spring:message code='ezApproval.t361'/></th>
	            <td id="SealName">&nbsp;</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t363'/></th>
	            <td id="SealSize">&nbsp;</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t367'/></th>
	            <td id="RegDate">&nbsp;</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t368'/></th>
	            <td id="DelDate">&nbsp;</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t364'/></th>
	            <td id="RegUser">&nbsp;</td>
	        </tr>
	        <tr>
	            <td colspan="2" style="text-align:center; padding-top:5px; padding-bottom:5px;">
	                  <img id="signimage" alt="" src="" />
	            </td>
	        </tr>
	    </table>
	</body>
</html>