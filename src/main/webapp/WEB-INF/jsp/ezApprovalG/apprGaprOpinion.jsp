<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t55'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Opinion_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/draft_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script id="clientEventHandlersJS" type="text/javascript">
		    var OrderCell = "";
		    var pDocID;
		    var pUserID;
		    var OpinionAddFlag = 0;
		    var AproveFlag = 0;
		    var pOpinionType = strOpinionType1;
		    var OpinionModifyFlag = false;
		    var pKuyjeType;
		    var pOrgDocID;
		    var g_OpinionModifyFlagAdd = true;
		    var arr_userinfo = new Array();
		    arr_userinfo[0] = "user";
		    arr_userinfo[1] = "${userInfo.id}";
		    arr_userinfo[2] = "${userInfo.displayName}";
		    arr_userinfo[3] = "${userInfo.title}";
		    arr_userinfo[4] = "${userInfo.deptID}";
		    arr_userinfo[5] = "${userInfo.deptName}";
		    arr_userinfo[6] = "${userInfo.jikChek}";
		    arr_userinfo[7] = "N";
		    arr_userinfo[8] = "${userInfo.email}";
		    arr_userinfo[9] = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    arr_userinfo[11] = "${userInfo.displayName1}";
		    arr_userinfo[12] = "${userInfo.displayName2}";
		    arr_userinfo[13] = "${userInfo.title1}";
		    arr_userinfo[14] = "${userInfo.title2}";
		    arr_userinfo[15] = "${userInfo.deptName1}";
		    arr_userinfo[16] = "${userInfo.deptName2}";
		    var pUserID = arr_userinfo[1];
		    var companyID = "${userInfo.companyID}";
		    var pCompanyName = "${userInfo.companyName}";
		    var pDisplay = "";
		    var pHeSongFlag = "";
		    var pWindow;
		    var ChkFlag = false;
		    var UserLang = "${userInfo.lang}";
		    var RetValue;
		    var ReturnFunction;
		    var NonActiveX = "YES";
		    window.onload = function () {
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("txt_OpinionContent"));
		            }
		            try {
		                RetValue = parent.apropinion_cross_dialogArguments[0];
		                ReturnFunction = parent.apropinion_cross_dialogArguments[1];
		            } catch (e) {
		                try {
		                    RetValue = opener.apropinion_cross_dialogArguments[0];
		                    ReturnFunction = opener.apropinion_cross_dialogArguments[1];
		                } catch (e) {
		                    RetValue = window.dialogArguments;
		                }
		            }
		            if (RetValue == undefined && opener.apropinion_cross_dialogArguments[0] != undefined) {
		                try {
		                    RetValue = opener.apropinion_cross_dialogArguments[0];
		                    ReturnFunction = opener.apropinion_cross_dialogArguments[1];
		                } catch (e) {
		                    RetValue = window.dialogArguments;
		                }
		            }
		            pDocID = RetValue[0];
		            pDisplay = RetValue[1];
		            pKuyjeType = RetValue[2];
		            pOrgDocID = RetValue[3];
		            pWindow = RetValue[5];
		            pHeSongFlag = RetValue[4];
		            if (pHeSongFlag == "Y")
		                TDHeSongMsg.style.display = "";
		            CheckOpinionType();
		            if (!pDocID) pDocID = pOrgDocID;
		            InitOpinionInfo();
		            if (pOrgDocID == "REDRAFT" || pOrgDocID == "HeSong") {
		                document.getElementById("bbtn_OpinionDel").style.display = "";
		            }
		            else {
		                document.getElementById("bbtn_OpinionDel").style.display = "none";
		            }
		            if (!CrossYN() || NonActiveX == "NO")
		                window.returnValue = "cancel";
		        }
		        catch (e) {
		            alert("window_onload ::" + e.description);
		        }
		    };
		    function btn_OpinionAdd_onclick() {
		        try {
		            SetOpinionAction("ADD");
		            var OpContent;
		            var Opstate;
		            OpContent = document.getElementById("txt_OpinionContent").value;
		            Opstate = document.getElementById("btn_OpinionAdd").textContent;
		            AddOpinionContent(Opstate, OpContent);
		            g_OpinionModifyFlagAdd = false;
		            ChkFlag = true;
		        }
		        catch (e) {
		            alert("btn_OpinionAdd ::" + e.description);
		        }
		    }
		    function btn_OpinionCancel_onclick() {
		        if (ChkFlag) {
		            btn_OpinionSave_onclick();
		        }
		        else {
		            if (ReturnFunction != null) {
		                ReturnFunction("cancel");
		                window.close();
		            }
		            else {
		                window.returnValue = "cancel";
		                window.close();
		            }
		        }
		    }
		    function btn_OpinionDel_onclick() {
		        SetOpinionAction("DEL");
		        deleteOpinionInfo();
		        ChkFlag = true;
		    }
		    function btn_OpinionSave_onclick() {
		        try {
		            if (pDisplay == "Show") {
		                if (CrossYN() || NonActiveX == "YES")
		                    parent.DivPopUpHidden();
		                else
		                    window.close();
		            }
		            else {
		                saveOpinionInfo();
		            }
		        }
		        catch (e) {
		            alert("btn_OpinionSave  :: " + e.description);
		        }
		    }
		    function OPINIONOnSelChange_onclick() {
		        try {
		            var OpinionList = new ListView();
		            OpinionList.LoadFromID("OpinionList");
		            var pSelectedRow = OpinionList.GetSelectedRows();
		            if (pSelectedRow != null) {
		                txt_OpinionContent.value = GetAttribute(pSelectedRow[0], "DATA3");
		                document.getElementById("bbtn_OpinionDel").style.display = "none";
		                if (document.getElementById("btn_OpinionAdd").textContent != "<spring:message code='ezApprovalG.t269'/>" && OpinionAddFlag == 0) {
		                    document.getElementById("btn_OpinionAdd").textContent = "<spring:message code='ezApprovalG.t421'/>";
		                    document.getElementById("txt_OpinionContent").readOnly = true;
		                }
		                else {
		                    if (pUserID == GetAttribute(pSelectedRow[0], "DATA2") && pDisplay != "Show") {
		                        document.getElementById("btn_OpinionAdd").textContent = "<spring:message code='ezApprovalG.t269'/>";
		                        document.getElementById("btn_OpinionAdd").disabled = false;
		                        document.getElementById("btn_OpinionDel").disabled = false;
		                        document.getElementById("bbtn_OpinionAdd").style.display = "";
		                        document.getElementById("bbtn_OpinionDel").style.display = "";
		                        document.getElementById("txt_OpinionContent").readOnly = false;
		                    }
		                    else {
		                        document.getElementById("bbtn_OpinionAdd").style.display = "none";
		                        document.getElementById("bbtn_OpinionDel").style.display = "none";
		                        document.getElementById("txt_OpinionContent").readOnly = true;
		                    }
		                }
		            }
		            if (pOrgDocID == "REDRAFT") {
		                document.getElementById("btn_OpinionDel").disabled = false;
		            }
		        }
		        catch (e) {
		            alert("OPINIONOnSelChange :: " + e.description);
		        }
		    }
		    function txt_OpinionContent_onfocus() {
		        if (pDisplay == "Show") {
		            document.getElementById("btn_OpinionCancel").focus();
		            document.getElementById("txt_OpinionContent").blur();
		        }
		    }
		    function txt_OpinionContent_onchange() {
		        if (OpinionAddFlag == "1" && !OpinionModifyFlag)
		            OpinionModifyFlag = true;
		    }
		    function SetOpinionAction(pFlag) {
		        try {
		            pWindow.document.Script.OpinionAction = pFlag;
		        } catch (e) { }
		    }
		</script>
	</head>
	<body class="popup">
	    <h1>
	        <spring:message code='ezApprovalG.t55'/>
	        <span id="TDHeSongMsg" style="font-size: 8pt; display: none">*
	            <spring:message code='ezApprovalG.t422'/>
	        </span>
	    </h1>
	    <div class="listview" style="width: 100%; height: 190px; overflow: AUTO;">
	        <div id="OPINION" style="margin:1px 1px 1px 1px;">
	        </div>
	    </div>
	    <h2 style="margin-top: 10px; margin-bottom: 3px">
	        <spring:message code='ezApprovalG.t423'/>
	    </h2>
	    <textarea id="txt_OpinionContent" name="txt_OpinionContent" class="textarea" style="width: 100%;
	        height: 150px; box-sizing:border-box;-moz-box-sizing:border-box;"  onfocus="return txt_OpinionContent_onfocus()"
	        onchange="return txt_OpinionContent_onchange()"></textarea>
	    <div class="btnposition">
	    <a class="imgbtn" id="bbtn_OpinionAdd" ><span id="btn_OpinionAdd" onClick="return btn_OpinionAdd_onclick()" ><spring:message code='ezApprovalG.t268'/></span></a>
	    <a class="imgbtn" id="bbtn_OpinionDel"><span id="btn_OpinionDel" onClick="return btn_OpinionDel_onclick()" ><spring:message code='ezApprovalG.t266'/></span></a>
	    <a class="imgbtn" id="bbtn_OpinionCancel"><span id="btn_OpinionCancel" onClick="return btn_OpinionCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>