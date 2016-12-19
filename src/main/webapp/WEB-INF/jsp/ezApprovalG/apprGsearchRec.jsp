<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1104'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/OpenSelWin_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezcomposeappt_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<!-- data picker-->
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	    <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS" >
		    var OrderCell = "";
		    var rtnVal = new Array();
		    var g_AdminYN,g_DeptCode, g_DeptName;
		    var g_SelChargerID="";
		    var CompanyID = "${userInfo.companyID}";
		    var opnOption = "0";
		    var RetValue;
		    var ReturnFunction;
		    var NonActiveX = "YES";
		    
		    window.onload = function () {
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("txtTitle"));
		            KeEventControl(document.getElementById("txtCabTitle"));
		            KeEventControl(document.getElementById("txtDrafter"));
		            KeEventControl(document.getElementById("txtSC"));
		        }
		        try {
		            RetValue = parent.searchrec_cross_dialogArguments[0];
		            ReturnFunction = parent.searchrec_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.searchrec_cross_dialogArguments[0];
		                ReturnFunction = opener.searchrec_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        g_AdminYN = RetValue[0];
		        g_DeptCode = RetValue[1];
		        g_DeptName = RetValue[2];
		        opnOption = RetValue[3];
		        rtnVal[0] = "FALSE";
		        
		        InitCode();
		        document.getElementById("txtDeptName").value = g_DeptName;
		        if (opnOption == "1") trDept.style.display = "none";
		    };
		
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', "");
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', "");
		    });
		    if ("${userInfo.lang}" == "1") {
			    $(function () {
			        $.datepicker.regional['ko'] = {
			        		closeText: "<spring:message code='main.t3' />",
				            prevText: "<spring:message code='main.t0604' />",
				            nextText: "<spring:message code='main.t0605' />",
				            currentText: "<spring:message code='main.t0606' />",
				            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                       "<spring:message code='main.t0627' />"],
				            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
						                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
						                       "<spring:message code='main.t0627' />"],
				            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                       "<spring:message code='main.t0627' />"],
			            weekHeader: 'Wk',
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional['ko']);
			    });
		    } else {
			    $(function () {
			        $.datepicker.regional['en'] = {
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional['en']);
			    });
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
		    		}        			
		    	});
		    	
		        var nodesRegType = SelectNodes(result, "CODELIST/REGISTERTYPE/CODE");
		        InitCodeSelBoxWithNullOpt(nodesRegType, selRegisterType);
		    }
		    function reset_onclick() {
		        document.getElementById("txtDeptName").value = "";
		        document.getElementById("txtTitle").value = "";
		        selRegisterType.selectedIndex = 0;
		        document.getElementById("txtCharger").value = "";
		        g_SelChargerID = "";
		        document.getElementById("txtSC").value = "";
		        document.getElementById("txtDrafter").value = "";
		        document.getElementById("txtCabTitle").value = "";
		        $("#Sdatepicker").datepicker('setDate', "");
		        $("#Edatepicker").datepicker('setDate', "");
		    }
		    function btnSearch_onclick() {
		        var oParamXml = GetCabSearchParamXml();
		        if (getXmlString(oParamXml) != "") {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = getXmlString(oParamXml);
		
		            if (ReturnFunction != null) {
		                ReturnFunction(rtnVal);
		                window.close();
		            }
		            else {
		                window.returnValue = rtnVal;
		                window.close();
		            }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1091'/>");
		        }
		    }
		    function SelectUser_OnClick() {
		        var rtn = SelectUser("", g_DeptCode);
		    }
		    function GetSelUserInfo(szXml) {
		        oXml = loadXMLString(szXml);
		        var nodesUser = SelectNodes(oXml, "USER");
		        var iLen = nodesUser.length;
		        var i;
		        var SelUserName = "";
		        g_SelChargerID = "";
		        for (i = 0; i < iLen; i++) {
		            if (g_SelChargerID != "") {
		                g_SelChargerID += ",";
		            }
		            if (SelUserName != "") {
		                SelUserName += ";";
		            }
		            g_SelChargerID += "'" + SelectSingleNodeValue(nodesUser[i], "ID") + "'";
		            SelUserName += SelectSingleNodeValue(nodesUser[i], "NAME");
		        }
		        txtCharger.value = SelUserName;
		    }
		    function GetCabSearchParamXml() {
		        var oXml = createXmlDom();
		        var oRoot = "";
		        var oData = "";
		        createNodeInsert(oXml, oRoot, "SEARCHPARAM");
		        createNodeAndInsertText(oXml, oData, "DEPTCODE", g_DeptCode);
		        createNodeAndInsertText(oXml, oData, "TITLE", document.getElementById("txtTitle").value);
		        createNodeAndInsertText(oXml, oData, "REGTYPE", selRegisterType.value);
		        createNodeAndInsertText(oXml, oData, "SREGDATE", GetRegSDate());
		        createNodeAndInsertText(oXml, oData, "EREGDATE", GetRegEDate());
		        createNodeAndInsertText(oXml, oData, "CHARGER", g_SelChargerID);
		        createNodeAndInsertText(oXml, oData, "SC", txtSC.value);
		        if (chkTransExp.checked) {
		            createNodeAndInsertText(oXml, oData, "TRANSEXPIRE", "TRUE");
		        }
		        else {
		            createNodeAndInsertText(oXml, oData, "TRANSEXPIRE", "");
		        }
		        createNodeAndInsertText(oXml, oData, "DRAFTER", txtDrafter.value);
		        createNodeAndInsertText(oXml, oData, "CABTITLE", txtCabTitle.value);
		        return oXml;
		    }
		    function GetRegSDate() {
		        if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val().length > 0)
		            return $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "00:00:00.001";
		        else
		            return "";
		    }
		    function GetRegEDate() {
		        if ($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val().length > 0)
		            return $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "23:59:59.999";
		        else
		            return "";
		    }
		    function SelectDept_OnClick() {
		        var rtn = SelectDept();
		    }
		
		    function btnCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		            window.close();
		        }
		        else {
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		</script>
	</head>
	<body class="popup" style="margin-left:0px;margin-top:0px">
		<h1><spring:message code='ezApprovalG.t1104'/></h1>
		<table class="content" style="width:445px" >
		  <tr  id="trDept"> 
		    <th style="WIDTH:175px" > <spring:message code='ezApprovalG.t1105'/></th>
		    <td style=" WIDTH:270px" > 
		      <input class="text" name="txtDeptName" id=txtDeptName disabled>
		      <a class="imgbtn" style="vertical-align:middle"><span onClick="return SelectDept_OnClick()" id="btnSelDept"  style="width:40px;text-align:center"><spring:message code='ezApprovalG.t105'/></span></a>
		     </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:175px"> <spring:message code='ezApprovalG.t1092'/></th>
		    <td style=" WIDTH:270px"> 
		      <input class="text" style=" WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" name="txtTitle" id=txtTitle>    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:175px"> <spring:message code='ezApprovalG.t1106'/></th>
		    <td style=" WIDTH:270px"> 
		      <input class="text" style=" WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" name="txtCabTitle" id=txtCabTitle>    </td>
		  </tr>
		  <tr > 
		    <th  style="WIDTH:175px"><spring:message code='ezApprovalG.t1107'/></th>
		    <td style=" WIDTH:270px"> 
		      <select name="selRegisterType" id="selRegisterType" style=" WIDTH: 100%" ></select>    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:175px"> <spring:message code='ezApprovalG.t831'/></th>
		    <td style=" WIDTH:270px">
				<input type="text" id="Sdatepicker" style="width:80px;text-align:center"> 
		        <input type="text" id="Edatepicker" style="width:80px;text-align:center">
		    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:175px"> <spring:message code='ezApprovalG.t1101'/></th>
		    <td style=" WIDTH:270px" > 
		      <input class="text" name="txtCharger" id=txtCharger disabled>
		      <a  class="imgbtn" style="vertical-align:middle"><span onClick="return SelectUser_OnClick()" id="btnSelUser"  style="width:40px;text-align:center;"  ><spring:message code='ezApprovalG.t105'/></span></a>
		    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:175px"> <spring:message code='ezApprovalG.t445'/></th>
		    <td style=" WIDTH:270px"> 
		      <input class="text" style=" WIDTH:100%;-moz-box-sizing:border-box;box-sizing:border-box;" name="txtDrafter" id=txtDrafter>    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:175px"><spring:message code='ezApprovalG.t94'/></th>
		    <td style=" WIDTH:270px"> 
		      <input class="text" style=" WIDTH:100%;-moz-box-sizing:border-box;box-sizing:border-box;" name="txtSC" id=txtSC>    </td>
		  </tr>
		  </table>
		  
		<h2><input type="checkbox" name="chkTransExp" id="chkTransExp" value="1"><spring:message code='ezApprovalG.t1116'/></h2>
		
		<div class="btnposition">
			<a class="imgbtn"><span id="reset" onclick="return reset_onclick()"><spring:message code='ezApprovalG.t621'/></span></a>
			<a class="imgbtn"><span id="Submit22222" onclick="return btnSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
			<a class="imgbtn"><span id="Submit22223" onclick="return btnCancel_onclick()"><spring:message code='ezApprovalG.t64'/></span></a>  
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>