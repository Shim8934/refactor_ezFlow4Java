<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t931'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
    	<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
    	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CabinetInfo_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/OpenAlert_Cross.js"></script>
		<SCRIPT ID="clientEventHandlersJS" type="text/javascript">
		    var arrCabInfo = new Array();
		    var g_PYear, g_DispFlag, g_DispEndDate;
		    var rtnVal = new Array();
		    var CompanyID = "${userInfo.companyID}";
		    var UserLang = "${userInfo.lang}";
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            RetValue = parent.endcabproduce_cross_dialogArguments[0];
		            ReturnFunction = parent.endcabproduce_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.endcabproduce_cross_dialogArguments[0];
		                ReturnFunction = opener.endcabproduce_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        arrCabInfo[0] = RetValue[0];
		        arrCabInfo[1] = RetValue[1];
		        InitCabinetInfo();
		        rtnVal[0] = "FALSE";
		    };
		    function InitCabinetInfo() {
		        var oXml = GetCabinetClassInfo(arrCabInfo[0]);
		
		        if (oXml.text != "FALSE") {
		
		            var xmldomNodes = SelectNodes(oXml, "RESULT");
		
		            if (xmldomNodes.length > 0) {
		                g_DispFlag = SelectSingleNodeValue(xmldomNodes[0], "DISPFLAG");
		                g_DispEndDate = SelectSingleNodeValue(xmldomNodes[0], "DISPENDDATE");
		
		                if (g_DispFlag == "1" && g_DispEndDate == "")
		                {
		                    OpenAlertUI("<spring:message code='ezApprovalG.t1014'/>" + "'" + "<spring:message code='ezApprovalG.t269'/>" + "'" + "<spring:message code='ezApprovalG.t1015'/>");
		                    window.close();
		                }
		                
		                if("${userInfo.lang}" == "1")  { 
		                	tdTitle.innerHTML = SelectSingleNodeValue(xmldomNodes[0], "TITLE");
		                } else { 
		                	tdTitle.innerHTML = SelectSingleNodeValue(xmldomNodes[0], "TITLE2");
		                }
		                
		                tdRecType.innerHTML = SelectSingleNodeValue(xmldomNodes[0], "RECTYPEDES");
		                tdSN.innerHTML = SelectSingleNodeValue(xmldomNodes[0], "DISPCABCLASSNO");
		                g_PYear = SelectSingleNodeValue(xmldomNodes[0], "PRODUCEYEAR");
		            }
		        }
		        else {
		            tdTitle.innerHTML = "";
		            tdRecType.innerHTML = "";
		            tdSN.innerHTML = "";
		        }
		    }
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        window.close();
		    }
		    function cmdConfirm_onclick() {
		        if (EndCabProduce(arrCabInfo[1], txtExpYear.innerHTML, "0")) {
		            OpenAlertUI("<spring:message code='ezApprovalG.t1016'/>", OpenAlertUI_Close);
		            rtnVal[0] = "TRUE";
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t1017'/>");
		        }
		    }
		    function OpenAlertUI_Close() {
		        window.close();
		    }
		    window.onunload = function () {
		        if (ReturnFunction != null)
		            ReturnFunction(rtnVal);
		        else
		            window.returnValue = rtnVal;
		    }
		</SCRIPT>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t931'/></h1>
		<h2><spring:message code='ezApprovalG.t1018'/></h2>
		<table class="content">
		  <tr>                 
		    <th  ><spring:message code='ezApprovalG.t998'/></th>
		    <td id="tdTitle" >&nbsp;</td>
		  </tr>
		  <tr>                 
		    <th ><spring:message code='ezApprovalG.t1019'/></th>
		    <td id="tdSN" >&nbsp;</td>
		  </tr>
		  <tr>                 
		    <th ><spring:message code='ezApprovalG.t826'/></th>
		    <td id="tdRecType" >&nbsp;</td>
		  </tr>
		  <tr style="display:none">                 
		    <th ><spring:message code='ezApprovalG.t841'/></th>
		    <td id="txtExpYear">${pYear}</td>
		  </tr>
		</table>
		<br>
		<div style="font-family:'arial', 'verdana', 'dotum'; FONT-SIZE: 9pt"><spring:message code='ezApprovalG.t1020'/><br>
				(<spring:message code='ezApprovalG.t1021'/></div>
		<!---------------------------------------- 확인, 취소버튼 ----------------------------------------------->
		<div class="btnposition" >
		    <a class="imgbtn"><span name="btnOK" onClick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		    <a class="imgbtn"><span name="btnCancel" onClick="return cmdCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>