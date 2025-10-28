<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	   <title><spring:message code='ezApprovalG.t1090'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OpenSelWin_Cross.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var rtnVal = new Array();
		    var g_AdminYN, g_DeptCode, g_DeptName;
		    var g_SelTaskCode="";
		    var g_SelChargerID="";
		    var g_InitFlag="0";
		    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
		    var approvalFlag = "<c:out value='${approvalFlag}'/>";
		    window.onload = window_onload;
		    window.onbeforeunload = window_onunload;
		    var RetValue;
		    var ReturnFunction;
		    function window_onload() {
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("txtTitle"));
		        }
		
		        try {
		            RetValue = parent.searchcab_cross_dialogArguments[0];
		            ReturnFunction = parent.searchcab_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.searchcab_cross_dialogArguments[0];
		                ReturnFunction = opener.searchcab_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        g_AdminYN = RetValue[0];
		        g_DeptCode = RetValue[1];
		        g_DeptName = RetValue[2];
		        g_InitFlag = RetValue[3];
		
		        if (g_InitFlag == "1") {
		            trTransExp.style.display = "none";
		            trRejectCab.style.display = "";
		            trSelDept.style.display = "none";
		        }
		        rtnVal[0] = "FALSE";
		        InitCode();
		        
		        if(document.txtDeptName) { 
		        	txtDeptName.value = g_DeptName;
		        }
		        
		      	//엔터키 눌렀을때도 검색 실행
		        $(".text").attr("onkeyup", "enterkey(event)");
		    }
		    function InitCode() {
		        var result = "";
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getCodeList.do",
		    		data : {
		    			companyID : CompanyID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    			
		    			var nodesRecType = SelectNodes(result, "CODELIST/RECORDTYPE/CODE");
		    	        InitCodeSelBoxWithNullOpt(nodesRecType, selRecTypeCode);
		
		    	        var nodesKeepPeriod = SelectNodes(result, "CODELIST/KEEPINGPERIOD/CODE");
		    	        InitCodeSelBoxWithNullOpt(nodesKeepPeriod, selKeepPeriod);
		
		    	        var nodesKeepMethod = SelectNodes(result, "CODELIST/KEEPINGMETHOD/CODE");
		    	        InitCodeSelBoxWithNullOpt(nodesKeepMethod, selKeepMethod);
		
		    	        var nodesKeepPlace = SelectNodes(result, "CODELIST/KEEPINGPLACE/CODE");
		    	        InitCodeSelBoxWithNullOpt(nodesKeepPlace, selKeepPlace)
		    		}        			
		    	});
		    }
		    function SelectTask_OnClick() {
		        SelectTask(g_DeptCode, g_DeptName, "0", "1");
		    }
		    function SelectTask_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE")
		            GetSelSTaskInfo(rtn[1]);
		    }
		    function GetSelSTaskInfo(szTaskXml) {
		        var oXml = loadXMLString(szTaskXml);
		        var nodesTask = GetElementsByTagName(oXml, "TASK");
		        var iLen = nodesTask.length;
		        var i;
		        var SelTaskName = "";
		        g_SelTaskCode = "";
		
		        for (i = 0; i < iLen; i++) {
		            if (g_SelTaskCode != "") {
		                g_SelTaskCode += ",";
		            }
		
		            if (SelTaskName != "") {
		                SelTaskName += ";";
		            }
		            g_SelTaskCode += "'" + SelectSingleNodeValue(nodesTask[i], "CODE") + "'";
		            SelTaskName += SelectSingleNodeValue(nodesTask[i], "NAME");
		        }
		        txtTaskName.value = SelTaskName;
		    }
		    function SelectUser_OnClick() {
		        SelectUser("", g_DeptCode);
		    }
		
		    function SelectDept_OnClick() {
		        var rtn = SelectDept();
		
		        if (rtn != undefined) {
		            if (rtn[0] == "TRUE") {
		                g_DeptCode = rtn[1];
		                txtDeptName.value = rtn[2];
		            }
		        }
		    }
		    function GetSelUserInfo(szXml) {
		        var oXml = loadXMLString(szXml);
		        var nodesUser = GetElementsByTagName(oXml, "USER");
		        var iLen = nodesUser.length;
		        var i;
		        var SelUserName = "";
		        var SelUserName2 = "";
		        g_SelChargerID = "";
		
		        for (i = 0; i < iLen; i++) {
		            if (g_SelChargerID != "") {
		                g_SelChargerID += ",";
		            }
		
		            if (SelUserName != "") {
		                SelUserName += ";";
		            }
		
		            if (SelUserName2 != "") {
		                SelUserName2 += ";";
		            }
		            g_SelChargerID += "'" + SelectSingleNodeValue(nodesUser[i], "ID") + "'";
		            SelUserName += SelectSingleNodeValue(nodesUser[i], "NAME");
		            SelUserName2 += SelectSingleNodeValue(nodesUser[i], "NAME2");
		        }
		        txtCharger.value = SelUserName;
		    }
		    function reset_onclick() {
		        txtTitle.value = "";
		        g_SelTaskCode = "";
		        txtTaskName.value = "";
		        selSProduceY.selectedIndex = 0;
		        selEProduceY.selectedIndex = 0;
		        selSEndY.selectedIndex = 0;
		        selEEndY.selectedIndex = 0;
		        selRecTypeCode.selectedIndex = 0;
		        selKeepPeriod.selectedIndex = 0;
		        selKeepMethod.selectedIndex = 0;
		        selKeepPlace.selectedIndex = 0;
		        g_SelChargerID = "";
		        txtCharger.value = "";
				chkTransExp.checked = false;
		    }
		    function btnSearch_onclick() {
		        var oParamXml = GetCabSearchParamXml();
		        if (getNodeText(oParamXml) != "") {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = getXmlString(oParamXml);
		            window.close();
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1091'/>");
		        }
		    }
		    function GetCabSearchParamXml() {
		        var xmlpara = createXmlDom();
		        var objRoot = createNodeInsert(xmlpara, objRoot, "SEARCHPARAM");
		        var oData = createNodeAndInsertText(xmlpara, objRoot, "DEPTCODE", g_DeptCode);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "TITLE", txtTitle.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "TASKCODE", g_SelTaskCode);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "SPRODUCEY", selSProduceY.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "EPRODUCEY", selEProduceY.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "SENDY", selSEndY.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "EENDY", selEEndY.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "RECTYPECODE", selRecTypeCode.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "KEEPPERIOD", selKeepPeriod.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "KEEPMETHOD", selKeepMethod.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "KEEPPLACE", selKeepPlace.value);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "CHARGER", g_SelChargerID);
		
		        var inText = "";
		        if (chkTransExp.checked)
		            inText = "TRUE";
		
		        oData = createNodeAndInsertText(xmlpara, objRoot, "TRANSEXPIRE", inText);
		
		        if (chkRejectCab.checked)
		            inText = "128=128";
		
		        oData = createNodeAndInsertText(xmlpara, objRoot, "TRANSFLAG", inText);
		        oData = createNodeAndInsertText(xmlpara, objRoot, "RECEIVEDCAB", "");
		        oData = createNodeAndInsertText(xmlpara, objRoot, "GIVECAB", "");
		        return xmlpara;
		    }
		    function btnCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        window.close();
		    }
		    function window_onunload() {
		        if (ReturnFunction != null)
		            ReturnFunction(rtnVal);
		        else
		            window.returnValue = rtnVal;
		    }
		    function checkProdDate(opt, value) {
	    		var selectE = document.getElementById("selEProduceY");
	    		var selectS = document.getElementById("selSProduceY");
	    		var valueE = selectE.options[selectE.selectedIndex].value;
	    		var valueS = selectS.options[selectS.selectedIndex].value;
	    		
		    	if (opt == "selSProduceY") {
		    		if (valueS > valueE && valueE != "") {
		    			alert("<spring:message code='ezApprovalG.t10030'/>");
		    			selectS.selectedIndex = 0;
		    		}
		    	} else if (opt == "selEProduceY") {
		    		if (valueE < valueS && valueS != "") {
		    			alert("<spring:message code='ezApprovalG.t10030'/>");
		    			selectE.selectedIndex = 0;
		    		}
		    	}
		    }
		    function checkEndDate(opt, value) {
	    		var selectE = document.getElementById("selEEndY");
	    		var selectS = document.getElementById("selSEndY");
	    		var valueE = selectE.options[selectE.selectedIndex].value;
	    		var valueS = selectS.options[selectS.selectedIndex].value;
	    		
		    	if (opt == "selSEndY") {
		    		if (valueS > valueE && valueE != "") {
		    			alert("<spring:message code='ezApprovalG.t10030'/>");
		    			selectS.selectedIndex = 0;
		    		}
		    	} else if (opt == "selEEndY") {
		    		if (valueE < valueS && valueS != "") {
		    			alert("<spring:message code='ezApprovalG.t10030'/>");
		    			selectE.selectedIndex = 0;
		    		}
		    	}
		    }	
		    
		    function enterkey(e) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	btnSearch_onclick();
		            }
		        }
		        else {
		            if (e.which == 13) {
		            	btnSearch_onclick();
		            }
		        }
			}
		</script>
	</head>
	<body class="popup" leftmargin="0" topmargin="0" LANGUAGE ="javascript">
		<h1><spring:message code='ezApprovalG.t1090'/></h1>
		<div id="close">
            <ul>
                <li><span id="btnCancel" onclick="return btnCancel_onclick()"></span></li>
            </ul>
        </div>
		<table class="content" >
		<c:if test="${useDeptSearchCab eq 'YES'}">
		    <tr id="trSelDept"> 
		        <th><spring:message code='ezApprovalG.t827'/></th>
		        <td style="vertical-align:middle">
		            <input class="text" style=" WIDTH: 215px" name="txtDeptName" id=txtDeptName disabled>
		            <a class="imgbtn imgbck" ><span onclick="return SelectDept_OnClick()" id="btnSelDept"><spring:message code='ezApprovalG.t105'/></span></a>
		        </td>
		    </tr>
		</c:if>
		    <tr> 
		        <th><spring:message code='ezApprovalG.t1092'/></th>
		        <td>
		            <input class="text" style=" WIDTH:99%" name="txtTitle" id=txtTitle>    
		        </td>
		    </tr>
		    <tr> 
		        <th><spring:message code='ezApprovalG.t1093'/></th>
		        <td>
		            <input class="text" style=" WIDTH: 215px" name="txtTaskName" id=txtTaskName disabled>
		            <a class="imgbtn imgbck"><span onClick="return SelectTask_OnClick()" id="btnSelTask"><spring:message code='ezApprovalG.t105'/></span></a>
		        </td>
		    </tr>
		    <tr> 
		        <th> <spring:message code='ezApprovalG.t1094'/></th>
		        <td>
		            <select name="selSProduceY" id="selSProduceY" onchange="return checkProdDate('selSProduceY', this.value )">${yearOption}</select>
		            <spring:message code='ezApprovalG.t1095'/>
		            <select name="selEProduceY" id="selEProduceY" onchange="return checkProdDate('selEProduceY', this.value )">${yearOption}</select>
		            <spring:message code='ezApprovalG.t1096'/>
		        </td>
		    </tr>
		    <tr> 
		        <th> <spring:message code='ezApprovalG.t1097'/></th>
		        <td>
		            <select name="selSEndY" id="selSEndY" onchange="return checkEndDate('selSEndY', this.value )">${yearOption}</select>
		            <spring:message code='ezApprovalG.t1095'/>
		            <select name="selEEndY" id="selEEndY" onchange="return checkEndDate('selEEndY', this.value )">${yearOption}</select>
		            <spring:message code='ezApprovalG.t1096'/>
		        </td>
		    </tr>
		    <tr> 
		        <th><spring:message code='ezApprovalG.t1088'/></th>
		        <td><select name="selRecTypeCode" id="selRecTypeCode" style="HEIGHT: 20px;" ></select></td>
		    </tr>
		    <tr> 
		        <th><spring:message code='ezApprovalG.t1098'/></th>
		        <td>
		            <select name="selKeepPeriod" id="selKeepPeriod" style="HEIGHT: 20px;"></select>
		        </td>
		    </tr>
		    <tr> 
		        <th><spring:message code='ezApprovalG.t1099'/></th>
		        <td><select name="selKeepMethod" id="selKeepMethod" style="HEIGHT: 20px;"></select>
		        </td>
		    </tr>
		    <tr> 
		        <th><spring:message code='ezApprovalG.t1100'/></th>
		        <td>
		            <select name="selKeepPlace" id="selKeepPlace" style="HEIGHT: 20px;"></select>
		        </td>
		    </tr>
		    <tr>
		        <th> <spring:message code='ezApprovalG.t1101'/></th>
		        <td>
		            <input class="text" style=" WIDTH: 215px" name="txtCharger" id=txtCharger disabled>
		            <a class="imgbtn imgbck"><span onClick="return SelectUser_OnClick()" id="btnSelUser" ><spring:message code='ezApprovalG.t105'/></span></a>
		        </td>
		    </tr>
		    <tr id="trTransExp">
		    	<th><spring:message code='ezApprovalG.t1102'/></th>
		    	<td>
		    		<div class='custom_checkbox'><input type="checkbox" name="chkTransExp" id="chkTransExp" value="1" style="vertical-align:middle;"></div>
		    	</td>
		    </tr>
		    <tr id="trRejectCab" style="display:none">
		    	<th><spring:message code='ezApprovalG.t1103'/></th>
		    	<td>
		    		<div class='custom_checkbox'><input type="checkbox" name="chkRejectCab" id="chkRejectCab" value="1"></div>
		    	</td>
		    </tr>
		  </table>
		  
		<%-- <h2 id="trTransExp"><input type="checkbox" name="chkTransExp" id="chkTransExp" value="1" style="vertical-align:middle;"><spring:message code='ezApprovalG.t1102'/></h2>
		<h2 id="trRejectCab" style="display:none"><input type="checkbox" name="chkRejectCab" id="chkRejectCab" value="1"><spring:message code='ezApprovalG.t1103'/></h2> --%>
		
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn"><span id="btnReset" onclick="return reset_onclick()"><spring:message code='ezApprovalG.t621'/></span></a>
		    <a class="imgbtn"><span id="btnSearch" onclick="return btnSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
