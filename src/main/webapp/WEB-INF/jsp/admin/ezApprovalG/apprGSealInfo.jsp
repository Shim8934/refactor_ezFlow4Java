<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<c:choose>
			<c:when test="${pDeptYN == 'Y' }">
				<title><spring:message code = 'ezApprovalG.t1264' /></title>
			</c:when>
			<c:otherwise>
				<title><spring:message code = 'ezApprovalG.t1266' /></title>
			</c:otherwise>
		</c:choose>
		
		<style>
	        DIV.IMAGEVIEW {
	            behavior: url("SealView.htc");
	        }
	    </style>
		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight;
	        var pRegDate, pDelDate, pRegUserID, pRegUserName;
	        var RetValue;
	        var ReturnFunction;
	        
	        $(document).ready(function(){
	            try {
	                try {
	                    RetValue = parent.ezsealinfo_dialogArguments[0];
	                    ReturnFunction = parent.ezsealinfo_dialogArguments[1];
	                } catch (e) {
	                    try {
	                        RetValue = opener.ezsealinfo_dialogArguments[0];
	                        ReturnFunction = opener.ezsealinfo_dialogArguments[1];
	                    } catch (e) {
	                        RetValue = window.dialogArguments;
	                    }
	                }
	                
	                pSealNum = RetValue[0];
	                pSealName = RetValue[1];
	                pSealPath = RetValue[2];
	                pSealWidth = RetValue[3];
	                pSealHeight = RetValue[4];
	                pRegDate = RetValue[5];
	                pDelDate = RetValue[6];
	                pRegUserID = RetValue[7];
	                pRegUserName = RetValue[8];
	
                    $("#SealName").html(pSealName);
                    $("#SealSize").html(pSealWidth + "mm * " + pSealHeight + "mm");
                    $("#RegDate").html(pRegDate);

                    if (pDelDate == "") {
                        $("#DelDate").html("--");
                    } else {
                        $("#DelDate").html(pDelDate);
                    }
	                	                
	                $("#RegUser").html("<span style=\"cursor:pointer\" onclick='return openUserInfo(\"" + pRegUserID + "\")'>" + pRegUserName + "</span>");
	                document.getElementById("signimage").style.width = pSealWidth + "mm";
	                document.getElementById("signimage").style.height = pSealHeight + "mm";
	                document.getElementById("signimage").src = "/ezCommon/downloadAttach.do?filePath=" + pSealPath;
	            } catch (e) {
	                alert("window_onload : " + e.description);
	            }
	        });
	        
	        function openUserInfo(tempUserID) {
	            if (CrossYN()) {
	                window.open("/ezCommon/showPersonInfo.do?id=" + tempUserID, "ShowPersonInfo", GetOpenWindowfeature(438, 420));
	            } else {
	                dialogArguments.window.open("/ezCommon/showPersonInfo.do?id=" + tempUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 438));
	            }
	        }
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<c:choose>
			<c:when test="${pDeptYN == 'Y' }">
				<h1><spring:message code = 'ezApprovalG.t1264' /></h1>
			</c:when>
			<c:otherwise>
				<h1><spring:message code = 'ezApprovalG.t1266' /></h1>
			</c:otherwise>
		</c:choose>
	    
	    <div id="close">
	        <ul>
	            <li><span onclick="window.close()"><spring:message code = 'ezApprovalG.t64' /></span></li>
	        </ul>
	    </div>
	    
	    <script type="text/javascript">
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	
	    <table class="content">
	        <tr>
	        	<c:choose>
					<c:when test="${pDeptYN == 'Y' }">
						<th><spring:message code = 'ezApprovalG.t1250' /></th>
					</c:when>
					<c:otherwise>
						<th><spring:message code = 'ezApprovalG.t1262' /></th>
					</c:otherwise>
				</c:choose>
	            
	            <td id="SealName"></td>
	        </tr>
	        <tr>
	        	<c:choose>
					<c:when test="${pDeptYN == 'Y' }">
						<th><spring:message code = 'ezApprovalG.t1253' /></th>
					</c:when>
					<c:otherwise>
						<th><spring:message code = 'ezApprovalG.t1263' /></th>
					</c:otherwise>
				</c:choose>
	            
	            <td id="SealSize"></td>
	        </tr>
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t831' /></th>
	            <td id="RegDate"></td>
	        </tr>
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1265' /></th>
	            <td id="DelDate"></td>
	        </tr>
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1254' /></th>
	            <td id="RegUser"></td>
	        </tr>
	        <tr>
	            <td colspan="2" style="text-align:center; padding-top:5px; padding-bottom:5px;">
	                  <img id="signimage" alt="" src="" />
	            </td>
	        </tr>
	    </table>
	</body>
</html>