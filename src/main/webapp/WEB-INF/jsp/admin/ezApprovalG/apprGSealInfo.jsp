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

		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight;
	        var pRegDate, pDelDate, pRegUserID, pRegUserName;
	        var RetValue;
	        var ReturnFunction;
	        var pDeptID;
	        var pCompanyID;
	        var pDeptYN = "<c:out value='${pDeptYN}'/>";
	        var ReturnFunctionDel;
	        
	        $(document).ready(function(){
	            try {
	                try {
	                    RetValue = parent.ezsealinfo_dialogArguments[0];
	                    ReturnFunction = parent.ezsealinfo_dialogArguments[1];
	                    ReturnFunctionDel = parent.ezsealinfo_dialogArguments[2];
	                } catch (e) {
	                    try {
	                        RetValue = opener.ezsealinfo_dialogArguments[0];
	                        ReturnFunction = opener.ezsealinfo_dialogArguments[1];
	                        ReturnFunctionDel = opener.ezsealinfo_dialogArguments[2];
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
	                pDeptID = RetValue[9]; // 선택한 관인의 부서ID (부서별관인/직인에서만 사용)
	                pCompanyID = RetValue[10]; // 선택한 관인의 회사ID
	
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
	                window.open("/ezCommon/showPersonInfo.do?id=" + tempUserID, "ShowPersonInfo", GetOpenWindowfeature(450, 420));
	            } else {
	                dialogArguments.window.open("/ezCommon/showPersonInfo.do?id=" + tempUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 450));
	            }
	        }
	        
	        /* 2020-02-17 홍승비 - 관인정보 팝업창에 관인삭제 기능 추가 */
	        function btnDel_onclick() {
	        	if (pDelDate != "") { // 이미 삭제된 경우
	        		alert("<spring:message code = 'ezApprovalG.hsbSl02' />");
	        		return;
	        	}
			    if (!confirm("<spring:message code = 'ezApprovalG.hsbSl01' />")) {
			        return;
			    }
			    
				DeleteSealInfo();
	        }
	        
	        // 회사관인 또는 부서별관인을 삭제하는 기능 (다른 URL 호출)
		    function DeleteSealInfo() {
	        	var pUrl = "/admin/ezApprovalG/deleteSealInfo.do";
	        	if (pDeptYN == "Y") { // 부서별관인
	        		pUrl = "/admin/ezApprovalG/deleteDeptSealInfo.do";
	        	}
	        	
		    	$.ajax({
		    		type : "POST",
		    		url : pUrl,
		    		async : false,
		    		data : {
		    			pSealNum : pSealNum,
		    			deptID : pDeptID,
		    			companyID : pCompanyID
		    		},
		    		success : function (result) {
		    			if (result == "FALSE") {
							alert("<spring:message code='ezBoard.t1020'/>");
						} else {
							alert("<spring:message code='ezBoard.t268'/>");
						}
		    			
		    			window.close();
		    			ReturnFunctionDel(); // 관인삭제 후 리스트 갱신
		    		}
		    	});
		    }
	        
		</script>
	</head>
	<body class="popup" style="overflow:auto">
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
	            <li><span onclick="window.close()"></span></li>
	        </ul>
	    </div>
	
	    <table class="content" style="width:485px">
	        <tr>
	        	<c:choose>
					<c:when test="${pDeptYN == 'Y' }">
						<th style="width:35%;"><spring:message code = 'ezApprovalG.t1250' /></th>
					</c:when>
					<c:otherwise>
						<th style="width:35%;"><spring:message code = 'ezApprovalG.t1262' /></th>
					</c:otherwise>
				</c:choose>
	            
	            <td id="SealName" style="width:355px;"></td>
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
	            	<div style="width:475px; height:195px; overflow:auto;">
	                  <img id="signimage" alt="" src="" />
	                </div> 
	            </td>
	        </tr>
	    </table>
	    <%-- 2020-02-17 홍승비 - 관인삭제버튼 추가 --%>
	    <div class="btnposition btnpositionNew">
	    	<a class="imgbtn" onclick="btnDel_onclick()"><span><spring:message code = 'ezApprovalG.t266' /></span></a>
	    </div>
	</body>
</html>