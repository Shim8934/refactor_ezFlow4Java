<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t894'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
		<script id="clientEventHandlersJS" type="text/javascript">
		    var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
		    var UserLang = "<c:out value ='${userInfo.lang}'/>";
		    var arrCabInfo = new Array();
		    var g_NewVolNo;
		    var rtnVal = new Array();
		    var RetValue;
		    var ReturnFunction;
		    var winFlag;
		    window.onload = function () {
		        try {
		            RetValue = opener.addvolume_cross_dialogArguments[0];
		            ReturnFunction = opener.addvolume_cross_dialogArguments[1];
		            winFlag = opener.addvolume_cross_dialogArguments[2];
		        } catch (e) {
		            try {
		                RetValue = parent.addvolume_cross_dialogArguments[0];
		                ReturnFunction = parent.addvolume_cross_dialogArguments[1];
		                winFlag = parent.addvolume_cross_dialogArguments[2];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        if (!CrossYN())
		            RetValue = window.dialogArguments;
		        if (RetValue != null) {
		            arrCabInfo[0] = RetValue[0];
		            arrCabInfo[1] = RetValue[1];
		        }
		        InitCabClassInfo(GetCabinetClassInfo(arrCabInfo[0]));
		        g_NewVolNo = GetNewVolNo(arrCabInfo[1]);
		        if (CrossYN()) {
		            document.getElementById("tdTitle").textContent = arrCabInfo[2];
		            document.getElementById("tdRecType").textContent = arrCabInfo[3];
		            document.getElementById("tdSN").textContent = arrCabInfo[4];
		            document.getElementById("tdNewVolNo").textContent = g_NewVolNo;
		        }
		        else {
		            document.getElementById("tdTitle").innerText = arrCabInfo[2];
		            document.getElementById("tdRecType").innerText = arrCabInfo[3];
		            document.getElementById("tdSN").innerText = arrCabInfo[4];
		            document.getElementById("tdNewVolNo").innerText = g_NewVolNo;
		        }
		        rtnVal[0] = "FALSE";
		    };
		    function InitCabClassInfo(objCabInfoXml) {
		        if ("<c:out value ='${userInfo.lang}'/>" == "1") { 
		        	arrCabInfo[2] = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/TITLE");
		        } else { 
		        	arrCabInfo[2] = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/TITLE2");
		        }
		        arrCabInfo[3] = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/RECTYPEDES");
		        arrCabInfo[4] = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/REGSN");
		    }
		    function GetNewVolNo(pCabClassNo) {
		        var result = "";
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getNewVolNo.do",
		    		data : {
		    			cabClassNO : pCabClassNo,
		    			companyID  : CompanyID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}, error : function() {
		    			  alert("<spring:message code='ezApprovalG.t895'/>");
		    		} 			
		    	});

		        var xmlRtn = result;
		        
		        if (SelectSingleNodeValue(xmlRtn, "RESULT") != "FALSE") {
		            return SelectSingleNodeValue(xmlRtn, "RESULT");
		        }
		    }
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		            
		            if (winFlag) {
		            	window.close();
		            }
		        }
		        else {
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    function cmdConfirm_onclick() {
		        rtnVal[0] = "TRUE";
		        rtnVal[1] = g_NewVolNo;
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		            
		            if (winFlag) {
		            	window.close();
		            }
		        }
		        else {
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    window.onbeforeunload = function() {
		        if (!CrossYN()) {
		            window.returnValue = rtnVal;
		        }
		    }
		</script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t894'/></h1>
	    <div id="close">
            <ul>
                <li><span id="btnCancel" onclick="return cmdCancel_onclick()"></span></li>
            </ul>
        </div>
        <div class="point"><spring:message code='ezApprovalG.t896'/></div>
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezApprovalG.t897'/></th>
	            <td id="tdNewVolNo">&nbsp;</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApprovalG.t898'/></th>
	            <td id="tdTitle">
	        </tr>
	        <tr>
	            <th><spring:message code='ezApprovalG.t826'/></th>
	            <td id="tdRecType">&nbsp;</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApprovalG.t899'/></th>
	            <td id="tdSN">&nbsp;</td>
	        </tr>
	    </table>	
	    <br />
	    <h2><spring:message code='ezApprovalG.t900'/></h2>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span id="btnOK" onclick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
	    </div>
	</body>
</html>
