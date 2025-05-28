<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t931'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OpenAlert_Cross.js')}"></script>
		<SCRIPT ID="clientEventHandlersJS" type="text/javascript">
		    var arrCabInfo = new Array();
		    var g_PYear, g_DispFlag, g_DispEndDate;
		    var rtnVal = new Array();
		    var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
		    var UserLang = "<c:out value ='${userInfo.lang}'/>";
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

						// 2018-05-04 강민수92 QC #12584 번 알러트창 안뜨게 수정 
// 		                if (g_DispFlag == "1" && g_DispEndDate == "")
// 		                {
// 		                    OpenAlertUI("<spring:message code='ezApprovalG.t1014'/>" + "'" + "<spring:message code='ezApprovalG.t269'/>" + "'" + "<spring:message code='ezApprovalG.t1015'/>");
// 		                    window.close();
// 		                }
		                
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
		<div id="close">
            <ul>
                <li><span name="btnCancel" onClick="return cmdCancel_onclick()"></span></li>
            </ul>
        </div>
		<h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1018'/></h2>
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
		<h2 style="font-weight: normal;">▒ <spring:message code='ezApprovalG.t1020'/><br>
				&nbsp;&nbsp;(<spring:message code='ezApprovalG.t1021'/></h2>
		<!---------------------------------------- 확인, 취소버튼 ----------------------------------------------->
		<div class="btnposition btnpositionNew" >
		    <a class="imgbtn"><span name="btnOK" onClick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>