<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t996'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/RegCabinet_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/InitSCPopup_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}" ></script>
		<script type="text/javascript">
		    var rtnVal = new Array();
		    var xmlhttp = createXMLHttpRequest();
		    var pUserID = "<c:out value ='${userInfo.id}'/>";
		    var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
		    arr_userinfo[9]  = CompanyID;
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("txtTitle"));
		            KeEventControl(document.getElementById("txtTitle2"));
		        }
		        
		        
		        try {
		            RetValue = parent.createcabinet_cross_dialogArguments[0];
		            ReturnFunction = parent.createcabinet_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.createcabinet_cross_dialogArguments[0];
		                ReturnFunction = opener.createcabinet_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        if (!CrossYN())
		            document.getElementById("cabinetdiv").style.height = "";
		
		
		        if (RetValue != null) {
		            arrTask[0] = RetValue[0];
		            arrTask[1] = RetValue[1];
		            arrTask[2] = RetValue[2];
		            arrTask[3] = RetValue[3];
		            arrTask[4] = RetValue[4];
		            arrTask[5] = RetValue[5];
		            bDisplayFlag = RetValue[6];
		            bSpecialFlag = RetValue[7];
		            g_arrSCName[0] = RetValue[8];
		            g_arrSCName[1] = RetValue[9];
		            g_arrSCName[2] = RetValue[10];
		            arrTask[6] = RetValue[11];
		            arrTask[7] = RetValue[12];
		        }
		
		        rtnVal[0] = "FALSE";
		        pOwnerID = arr_userinfo[1];
		        pOwnerName = arr_userinfo[2];
		        txtOwner.value = pOwnerName;
		        InitCode();
		        InitTaskInfo();
		    };
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		        }
		        else {
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    
		    var AddSpecialCatalog_Cross_dialogArguments = new Array();
		     function btnAddSpecialCatalog_onclick() {
		         var para = new Array();
		         para[0] = g_szSCListXml;
		         para[1] = g_arrSCName[0];
		         para[2] = g_arrSCName[1];
		         para[3] = g_arrSCName[2];
		         var url = "/ezApprovalG/insSpecialList.do";
		         var rtn;
		         AddSpecialCatalog_Cross_dialogArguments[0] = para;
		         AddSpecialCatalog_Cross_dialogArguments[1] = btnAddSpecialCatalog_onclick_Complete;
		         var OpenWin;
		         
		             OpenWin = window.open(url, "AddSpecialCatalog_Cross", GetOpenWindowfeature(500, 435));

		         try { OpenWin.focus(); } catch (e) { }
		     }
		     function btnAddSpecialCatalog_onclick_Complete(rtn) {
		     	   DivPopUpHidden();
		     	   if (rtn[0] == "TRUE") {
		     	        g_szSCListXml = rtn[1];
		     	    }
		     }
		     
		    function cmdConfirm_onclick() {
		        if (typeof (arrTask[0]) == "undefined" || arrTask[0] == "") {
		            alert("<spring:message code='ezApprovalG.t997'/>");
		        }
		        else if (txtTitle.value == "") {
		            alert("<spring:message code='ezApprovalG.t955'/>");
		        }
		        else if (txtTitle2.value == "") {
		            alert("<spring:message code='ezApprovalG.t1766'/>");
		        }
		        else {
		            if (RegisterCabinet()) {
		                rtnVal[0] = "TRUE";
		                rtnVal[1] = g_CabID;
		                
		                if (ReturnFunction != null) {
		                    ReturnFunction(rtnVal);
		                }
		                else {
		                    window.returnValue = rtnVal;
		                    window.close();
		                }
		            }
		        }
		    }
		    window.onbeforeunload = onunload;
		    function onunload() {
		        if (!CrossYN()) {
		            window.returnValue = rtnVal;
		        }
		    }
		</SCRIPT>
	</head>
	<body style="background-color:#FFFFFF;margin-left:10px;margin-top:3px;" class="popup">
<!-- 		<OBJECT classid=clsid:35609FBF-EE92-472F-B72A-599B70D21F9E  -->
<!-- 				id=behave1 -->
<!-- 				style="HEIGHT: 0px; WIDTH: 0px;display:none;"></OBJECT> -->
<!-- 		<OBJECT classid=clsid:F8E93A35-2D04-4E2C-A04D-87947594C674  -->
<!-- 				id=behavelist1 style="HEIGHT: 0px; WIDTH: 0px;display:none;"> -->
<!-- 		</OBJECT>  -->
		<h1 style="margin-bottom: 4px;"><spring:message code='ezApprovalG.t996'/></h1>
		<div id="close">
            <ul>
                <li><span id="btnCancel" onclick="return cmdCancel_onclick()"></span></li>
            </ul>
        </div>
		<div id="cabinetdiv" style="height:100%;">
		<table class="content">
		  <tr>
		    <th > <spring:message code='ezApprovalG.t577'/>(<spring:message code='ezApprovalG.t1764'/>)</th>
		  <td id="tdTaskName">  </tr>
		   <tr>
		    <th > <spring:message code='ezApprovalG.t577'/>(<spring:message code='ezApprovalG.t1765'/>)</th>
		  <td id="tdTaskName2">  </tr>
		  <tr> 
		    <th ><spring:message code='ezApprovalG.t998'/>(<spring:message code='ezApprovalG.t1764'/>)</th>
		    <td><input type="text" name="txtTitle" id="txtTitle" class="text" style="Width:100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
		  </tr>
		   <tr> 
		    <th ><spring:message code='ezApprovalG.t998'/>(<spring:message code='ezApprovalG.t1765'/>)</th>
		    <td><input type="text" name="txtTitle2" id="txtTitle2" class="text" style="Width:100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
		  </tr>
		  <tr> 
		    <th ><spring:message code='ezApprovalG.t826'/></th>
		    <td><Select id="selRecTypeCode" style="width:100%; height: 25px;"></Select></td>
		  </tr>
		  <tr> 
		    <th ><spring:message code='ezApprovalG.t117'/></th>
		    <td><select id="selKeepPeriod" style="width:100px; height: 25px;"></Select></td>
		  </tr>
		  <tr> 
		    <th ><spring:message code='ezApprovalG.t599'/></th>
		    <td id="tdKeepMethod">&nbsp;</td>
		  </tr>
		  <tr> 
		    <th ><spring:message code='ezApprovalG.t600'/></th>
		    <td id="tdKeepPlace">&nbsp;</td>
		  </tr>
		  <tr> 
		    <th ><spring:message code='ezApprovalG.t999'/></th>
		    <td> 
		      <input type="text" name="txtOwner" id="txtOwner" class="text" disabled style="width:auto; font-size:9pt"></td>
		  </tr>
		  <tr class="ptb2"> 
		    <th ><spring:message code='ezApprovalG.t1000'/></th>
		    <td> 
		      <table style="border:0;border-collapse:collapse; border-spacing:0;padding:0px;width:100%;">
		        <tr> 
		          <td id="tdSpecialFlag">&nbsp;</td> 
		          <td style="width:70px;"><a  class="imgbtn" name="btnAddSC" id="btnAddSC"><span onClick="return btnAddSpecialCatalog_onclick()"><spring:message code='ezApprovalG.t268'/></span></a></td>
		        </tr>
		      </table>    </td>
		  </tr>
		  <tr> 
		    <th ><spring:message code='ezApprovalG.t601'/></th>
		    <td> 
		      <table style="border:0;border-collapse:collapse; border-spacing:0;padding:0px;width:100%;">
		        <tr> 
		          <td id="tdDisplayFlag" >&nbsp;</td> 
		          <td style="width:70px;"><a  class="imgbtn imgbck"  name="btnDisplayInfo" id="btnDisplayInfo" style="vertical-align:middle;margin:auto;"><span onClick="return btnDisplayInfo_onclick()"><spring:message code='ezApprovalG.t1042'/></span></a></td>
		        </tr>
		      </table>    </td>
		  </tr>
		</table>
		</div>
		<table style="border:0;border-collapse:collapse; border-spacing:0;padding:0px;width:100%;margin-top:5px;">
		  <tr> 
		    <td class="btnposition btnpositionNew">
		      <a class="imgbtn"><span id="btnOK" onclick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		    </td>
		  </tr>
		</table>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>