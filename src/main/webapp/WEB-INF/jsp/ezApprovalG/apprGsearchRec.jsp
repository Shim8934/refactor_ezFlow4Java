<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1104'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OpenSelWin_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezcomposeappt_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS" >
		    var OrderCell = "";
		    var rtnVal = new Array();
		    var g_AdminYN,g_DeptCode, g_DeptName, g_Listtype, g_Roleinfo;
		    var g_SelChargerID="";
		    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
		    var opnOption = "0";
			var orgDeptID;
		    var RetValue;
		    var ReturnFunction;
		    var winFlag;
		    
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
		            winFlag = parent.searchrec_cross_dialogArguments[2];
		        } catch (e) {
		            try {
		                RetValue = opener.searchrec_cross_dialogArguments[0];
		                ReturnFunction = opener.searchrec_cross_dialogArguments[1];
		                winFlag = opener.searchrec_cross_dialogArguments[2];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        g_AdminYN = RetValue[0];
		        g_DeptCode = RetValue[1];
		        g_DeptName = RetValue[2];
		        opnOption = RetValue[3];
		        g_Listtype = RetValue[4];
				
				if(g_Listtype === "m01"){
					document.getElementById("trFormID").style.display = "";
					document.getElementById("trOrgDocNum").style.display = "";
					document.getElementById("trDrafterDept").style.display = "";
					document.getElementById("trDocNum").style.display = "";
				}
				
		        g_Roleinfo = RetValue[5];
		        rtnVal[0] = "FALSE";

				orgDeptID = g_DeptCode;
		        
		        InitCode();
		        document.getElementById("txtDeptName").value = g_DeptName;
		        if (opnOption == "1") trDept.style.display = "none";
		        
		      	//엔터키 눌렀을때도 검색 실행
		        $(".text").attr("onkeyup", "enterkey(event)");
		    };
		
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true,
		            onClose: function (selectedDate) {
		            	$("#Edatepicker").datepicker("option", "minDate", selectedDate);
		            }
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true,
		            onClose: function (selectedDate) {
		            	$("#Sdatepicker").datepicker("option", "maxDate", selectedDate);
		            }		            
		        });
		
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', "");
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");  
		        $("#Edatepicker").datepicker('setDate', "");
		    });
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		     var monthStr = monthMsg.split(";");     
		     var dayMsg = "<spring:message code='ezSchedule.t108' />";
		     var dayStr = dayMsg.split(";");
		    
		     $(function () {
		         $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		          closeText: "<spring:message code='main.t3' />",
		             prevText: "<spring:message code='main.t0604' />",
		             nextText: "<spring:message code='main.t0605' />",
		             currentText: "<spring:message code='main.t0606' />",
		             monthNames: monthStr,
		             monthNamesShort: monthStr,
		             dayNames: dayStr,
		             dayNamesShort: dayStr,
		             dayNamesMin: dayStr,
		             weekHeader: 'Wk',
		             dateFormat: 'yy-mm-dd',
		             firstDay: 0,
		             isRTL: false,
		             duration: 200,
		             showAnim: 'show',
		             showMonthAfterYear: true
		         };
		         $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		     });
		
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
		    			
		    			var nodesRegType = SelectNodes(result, "CODELIST/REGISTERTYPE/CODE");
				        InitCodeSelBoxWithNullOpt(nodesRegType, selRegisterType);
		    		}        			
		    	});
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
				document.getElementById("chkTransExp").checked = false;
		    }
		    function btnSearch_onclick() {
		        var oParamXml = GetCabSearchParamXml();
		        if (getXmlString(oParamXml) != "") {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = getXmlString(oParamXml);
		
		            if (ReturnFunction != null) {
		                ReturnFunction(rtnVal);
		                
		                if (winFlag) {
		                	window.close();
		                }
		            } else {
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
		    /**
		    * 검색조건을 XML로 만들기
		    */
		    function GetCabSearchParamXml() {
				var tempDeptID = g_DeptCode;
				if ((g_Listtype === "m12" || g_Listtype === "m13") && g_Roleinfo.indexOf("i=1;") > -1 && g_DeptCode === orgDeptID) {
					tempDeptID = "ALL";
				}

		        var oXml = createXmlDom();
		        var oRoot = "";
		        var oData = "";
		        createNodeInsert(oXml, oRoot, "SEARCHPARAM");
		        createNodeAndInsertText(oXml, oData, "DEPTCODE", tempDeptID);
		        createNodeAndInsertText(oXml, oData, "TITLE", document.getElementById("txtTitle").value);
		        createNodeAndInsertText(oXml, oData, "REGTYPE", selRegisterType.value);
		        createNodeAndInsertText(oXml, oData, "SREGDATE", GetRegSDate());
		        createNodeAndInsertText(oXml, oData, "EREGDATE", GetRegEDate());
		        createNodeAndInsertText(oXml, oData, "CHARGER", g_SelChargerID);
		        createNodeAndInsertText(oXml, oData, "SC", txtSC.value);
				createNodeAndInsertText(oXml, oData, "FORMID", document.getElementsByName("formID")[0].id);
				createNodeAndInsertText(oXml, oData, "ORGDOCNUM", document.getElementsByName("txtOrgDocNum")[0].value);
				createNodeAndInsertText(oXml, oData, "DRAFTERDEPT", document.getElementsByName("txtDrafterDept")[0].value);
				createNodeAndInsertText(oXml, oData, "DOCNUM", document.getElementsByName("txtDocNum")[0].value);
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
		        	return $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "00:00:00";
		        else
		            return "";
		    }
		    function GetRegEDate() {
		        if ($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val().length > 0)
		            return $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "23:59:59";
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
		            
		            if (winFlag) {
	                	window.close();
	                }
		        } else {
		            window.returnValue = rtnVal;
		            window.close();
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

			var getformcont_cross_dialogArguments = new Array();
			function btn_FormSelect_onclick() {
				var parameter = new Array();
				parameter[0] = "<c:out value = '${userInfo.deptID}' />";
				parameter[1] = "999";
				getformcont_cross_dialogArguments[0] = parameter;
				getformcont_cross_dialogArguments[1] = btn_FormSelect_onclick_Complete;
				var retVal = window.open("/ezApprovalG/getFormCont.do", "", GetOpenWindowfeature(715, 580));
			}

			function btn_FormSelect_onclick_Complete(retVal) {
				if (typeof (retVal) != "undefined" && retVal[0] != "cancel") {
					document.getElementsByName("formID")[0].id = retVal[2];
					document.getElementsByName("formID")[0].value = retVal[3];
				}
			}
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1104'/></h1>
		<div id="close">
            <ul>
                <li><span id="Submit22223" onclick="return btnCancel_onclick()"></span></li>
            </ul>
        </div>
		<table class="content" style="width:100%" >
		  <tr  id="trDept" style="display:none"> 		<!-- 2020-09-16 김민성 - 등록대장, 접수목록, 발송목록의 상세검색에서 처리과 탭 기본 안나타나게 수정 -->
		    <th style="WIDTH:80px;" > <spring:message code='ezApprovalG.t1105'/></th>
		    <td style=" WIDTH:270px" > 
		      <input class="text" name="txtDeptName" id=txtDeptName disabled>
		      <a class="imgbtn imgbck" style="height: 23px;margin-bottom: 0px;"><span onClick="return SelectDept_OnClick()" id="btnSelDept"  style="width:24px;text-align:center;line-height: 22px;"><spring:message code='ezApprovalG.t105'/></span></a>
		     </td>
		  </tr>
		  <tr id = "trFormID" style="display: none">
			  <th ><spring:message code='ezApprovalG.t442'/></th>
			  <td style=" WIDTH:270px" >
				  <input class="text" name="formID" id=""  style=" WIDTH:270px" disabled>
				  <a  class="imgbtn imgbck" style="height: 23px;margin-bottom: 0px;"><span onClick="return btn_FormSelect_onclick()" id="formNameBox"  style="width:55px;text-align:center;line-height: 22px;"><spring:message code='ezApprovalG.t152'/></span></a>
			  </td>
		  </tr>
		  <tr id = "trDocNum" style="display: none">
				<th style="WIDTH:80px"><spring:message code='ezApprovalG.F0005'/></th>
				<td style=" WIDTH:270px">
					<input class="text" style=" WIDTH: 100%;height: 25px; -moz-box-sizing:border-box;box-sizing:border-box;" name="txtDocNum" id=txtDocNum>    </td>
		  </tr>
		  <tr id = "trOrgDocNum" style="display: none">
				<th style="WIDTH:80px"><spring:message code='ezApprovalG.kmh07'/></th>
				<td style=" WIDTH:270px">
					<input class="text" style=" WIDTH: 100%;height: 25px; -moz-box-sizing:border-box;box-sizing:border-box;" name="txtOrgDocNum" id=txtOrgDocNum>    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:80px"> <spring:message code='ezApprovalG.t1092'/></th>
		    <td style=" WIDTH:270px"> 
		      <input class="text" style=" WIDTH: 100%;height: 25px; -moz-box-sizing:border-box;box-sizing:border-box;" name="txtTitle" id=txtTitle>    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:80px"> <spring:message code='ezApprovalG.t1106'/></th>
		    <td style=" WIDTH:270px"> 
		      <input class="text" style=" WIDTH: 100%;height: 25px; -moz-box-sizing:border-box;box-sizing:border-box;" name="txtCabTitle" id=txtCabTitle>    </td>
		  </tr>
		  <tr > 
		    <th  style="WIDTH:80px"><spring:message code='ezApprovalG.t1107'/></th>
		    <td style=" WIDTH:270px"> 
		      <select name="selRegisterType" id="selRegisterType" style=" WIDTH: 150px;HEIGHT: 25px;" ></select>    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:80px"> <spring:message code='ezApprovalG.t831'/></th>
		    <td style=" WIDTH:270px">
				<input type="text" id="Sdatepicker" style="width:80px;height:25px;text-align:center" readonly>&nbsp;~
		        <input type="text" id="Edatepicker" style="width:80px;height:25px;text-align:center" readonly>
		    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:80px"> <spring:message code='ezApprovalG.t1101'/></th>
		    <td style=" WIDTH:270px" > 
		      <input class="text" name="txtCharger" id=txtCharger disabled>
		      <a  class="imgbtn imgbck" style="height: 23px;margin-bottom: 0px;"><span onClick="return SelectUser_OnClick()" id="btnSelUser"  style="width:24px;text-align:center;line-height: 22px;"><spring:message code='ezApprovalG.t105'/></span></a>
		    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:80px"> <spring:message code='ezApprovalG.t445'/></th>
		    <td style=" WIDTH:270px"> 
		      <input class="text" style=" WIDTH:100%;height:25px; -moz-box-sizing:border-box;box-sizing:border-box;" name="txtDrafter" id=txtDrafter>    </td>
		  </tr>
		  <tr id = "trDrafterDept" style="display: none">
				<th style="WIDTH:80px"> <spring:message code='ezApprovalG.t1331'/></th>
				<td style=" WIDTH:270px">
					<input class="text" style=" WIDTH:100%;height:25px; -moz-box-sizing:border-box;box-sizing:border-box;" name="txtDrafterDept" id=txtDrafterDept>    </td>
		  </tr>
		  <tr > 
		    <th style="WIDTH:80px"><spring:message code='ezApprovalG.t94'/></th>
		    <td style=" WIDTH:270px"> 
		      <input class="text" style=" WIDTH:100%;height:25px; -moz-box-sizing:border-box;box-sizing:border-box;" name="txtSC" id=txtSC>    </td>
		  </tr>
		  <tr>
		  	<th style="WIDTH:80px"><spring:message code='ezApprovalG.t1116'/></th>
			  <td><div class='custom_checkbox'><input type="checkbox" name="chkTransExp" id="chkTransExp" value="1"  style="vertical-align:middle;"></div></td>
		  </tr>
		  </table>
		  
		<%-- <h2><input type="checkbox" name="chkTransExp" id="chkTransExp" value="1"  style="vertical-align:middle;"><spring:message code='ezApprovalG.t1116'/></h2> --%>
		
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"><span id="reset" onclick="return reset_onclick()"><spring:message code='ezApprovalG.t621'/></span></a>
			<a class="imgbtn"><span id="Submit22222" onclick="return btnSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
