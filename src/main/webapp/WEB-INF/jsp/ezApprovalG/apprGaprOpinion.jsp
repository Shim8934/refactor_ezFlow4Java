<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t55'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Opinion_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draft_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
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
		    arr_userinfo[1] = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2] = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3] = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4] = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5] = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6] = "<c:out value ='${userInfo.jikChek}'/>";
		    arr_userinfo[7] = "N";
		    arr_userinfo[8] = "<c:out value ='${userInfo.email}'/>";
		    arr_userinfo[9] = "";
		    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11] = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12] = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13] = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14] = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15] = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16] = "<c:out value ='${userInfo.deptName2}'/>";
		    var pUserID = arr_userinfo[1];
		    var companyID = "<c:out value ='${userInfo.companyID}'/>";
		    var pCompanyName = "<c:out value ='${userInfo.companyName}'/>";
		    var pDisplay = "";
		    var pHeSongFlag = "";
		    var pWindow;
		    var ChkFlag = false;
		    var UserLang = "<c:out value ='${userInfo.lang}'/>";
		    var RetValue;
		    var ReturnFunction;
		    var junGyulFlag = "<c:out value ='${junGyulFlag}'/>";
		    var agreeReturnType = "<c:out value ='${agreeReturnType}'/>";
		    var orgCompanyID = parent.orgCompanyID;
		    
		    var move_on, frameLeft, frameTop;
		    var layerStartX, layerStartY;
		    var iFramePanel = window.parent.document.getElementById("iFramePanel");
		    var ext;
		    var pDocState;
		    var pMode = "APR";
		    
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
		            
		            try {
			            if (RetValue == undefined && opener.apropinion_cross_dialogArguments[0] != undefined) {
			                try {
			                    RetValue = opener.apropinion_cross_dialogArguments[0];
			                    ReturnFunction = opener.apropinion_cross_dialogArguments[1];
			                } catch (e) {
			                    RetValue = window.dialogArguments;
			                }
			            } 
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }

		            pDocID = RetValue[0];
		            pDisplay = RetValue[1];
		            pKuyjeType = RetValue[2];
		            pOrgDocID = RetValue[3];
		            pWindow = RetValue[5];
		            pHeSongFlag = RetValue[4];
		            pDocState = RetValue[6];
		            
		            //한글일때 showmodaldialog 로 창이 열리기 때문에 parent로 값을 가져올수 없기때문에 추가
		            if (orgCompanyID == undefined) {
			            orgCompanyID = RetValue[98];
		            }
		            ext = RetValue[99];
		            
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
		            
		            if (typeof(pDocState) != "undefined" && (pDocState == "015" || pDocState == "017")) {
		            	document.getElementById("bbtn_OpinionAdd").style.display = "none";
		            	document.getElementById("bbtn_OpinionDel").style.display = "none";
		            	document.getElementById("bbtn_OpinionCancel").style.display = "none";
		            }
		            
		            if (!CrossYN())
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
		            OpContent = trim(document.getElementById("txt_OpinionContent").value);
		            // Opstate에 현재 btn_OpinionAdd의 텍스트 값을 가져온다 ex) 저장, 수정 ..
		            Opstate = document.getElementById("btn_OpinionAdd").textContent;
		            ChkFlag = true;
		            AddOpinionContent(Opstate, OpContent);
		            g_OpinionModifyFlagAdd = false;
		            if(ChkFlag == true){
			            document.getElementById("bbtn_OpinionCancel").style.display = "";
		            }
		        }
		        catch (e) {
		            alert("btn_OpinionAdd ::" + e.description);
		        }
		    }
		    function btn_OpinionCancel_onclick() {
	            if (ReturnFunction != null) {
	                ReturnFunction("cancel");
	                window.close();
	            } else {
	                window.returnValue = "cancel";
	                window.close();
	            }
		    }
		    function btn_OpinionOK_onclick() {
		        if (ChkFlag) {
		            btn_OpinionSave_onclick();
		        } else {
		            if (ReturnFunction != null) {
		                ReturnFunction("cancel");
		                window.close();
		            } else {
		                window.returnValue = "cancel";
		                window.close();
		            }
		        }
		    }
		    function btn_OpinionDel_onclick() {
		        SetOpinionAction("DEL");
		        deleteOpinionInfo();
		        if (pDisplay == "BanSong" || pDisplay == "BoRyu") {
			        ChkFlag = false;
		        } else {
			        ChkFlag = true;
		        }
		    }
		    function btn_OpinionSave_onclick() {
		        try {
		            if (pDisplay == "Show") {
		                if (CrossYN())
		                    parent.DivPopUpHidden();
		                else
		                    window.close();
		            } else {
		                saveOpinionInfo();
		            }
		        } catch (e) {
		            alert("btn_OpinionSave  :: " + e.description);
		        }
		    }
		    
		    function OPINIONOnSelChange_onclick() {
		        try {
		            var OpinionList = new ListView();
		            OpinionList.LoadFromID("OpinionList");
		            var pSelectedRow = OpinionList.GetSelectedRows();
		            if (pSelectedRow != null) {
		                txt_OpinionContent.value = GetAttribute(pSelectedRow[0], "DATA3") != null ? GetAttribute(pSelectedRow[0], "DATA3") : "";
		                document.getElementById("bbtn_OpinionDel").style.display = "none"
		                if (getNodeText(document.getElementById("btn_OpinionAdd")) != "<spring:message code='ezApprovalG.t269'/>" && OpinionAddFlag == 0) {
		                    setNodeText(document.getElementById("btn_OpinionAdd") , "<spring:message code='ezApprovalG.t421'/>");
		                    document.getElementById("txt_OpinionContent").readOnly = true;
		                }
		                else {
		                    if (pUserID == GetAttribute(pSelectedRow[0], "DATA2") && pDisplay != "Show" && pMode == "APR") {
		                        setNodeText(document.getElementById("btn_OpinionAdd") , "<spring:message code='ezApprovalG.t269'/>");
		                        document.getElementById("btn_OpinionAdd").disabled = false;
		                        document.getElementById("btn_OpinionDel").disabled = false;
		                        document.getElementById("bbtn_OpinionAdd").style.display = ""
		                        document.getElementById("bbtn_OpinionDel").style.display = ""
		                        document.getElementById("txt_OpinionContent").readOnly = false;
		                    }
		                    else {
		                        document.getElementById("bbtn_OpinionAdd").style.display = "none"
		                        document.getElementById("bbtn_OpinionDel").style.display = "none"
		                        document.getElementById("txt_OpinionContent").readOnly = true;
		                    }
		                }
		            }
		            if (pOrgDocID == "REDRAFT") {
		                document.getElementById("bbtn_OpinionDel").style.display = ""
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
		    
		    function layerStart() {
		    	layerStartX = event.clientX;
		    	layerStartY = event.clientY;
		    	move_on = true;
		    }

		    function layerMove() {
		    	if(move_on == true) {
		    		if(iFramePanel.offsetLeft > 0 && ((event.clientX - layerStartX + iFramePanel.offsetLeft) > 5) && ((event.clientX - layerStartX + iFramePanel.offsetLeft + iFramePanel.offsetWidth) < 1145)) {
		    			iFramePanel.style.left = (event.clientX - layerStartX + iFramePanel.offsetLeft) + "px";
		    		}
		    		
		    		if(iFramePanel.offsetTop > 0 && ((event.clientY - layerStartY + iFramePanel.offsetTop) > 5) && ((event.clientY - layerStartY + iFramePanel.offsetTop + iFramePanel.offsetHeight) < 990)) {
		    			iFramePanel.style.top = (event.clientY - layerStartY + iFramePanel.offsetTop) + "px";
		    		}
		    	}
		    }
		    	
		    function layerStop() {
				move_on = false;
		    }
		</script>
		<style>
			.mainlist tr th {border-top:0px}
		</style>
	</head>
	<body class="popup">
	    <h1>
	        <spring:message code='ezApprovalG.t55'/>
	        <span id="TDHeSongMsg" style="font-size: 8pt; display: none">*
	            <spring:message code='ezApprovalG.t422'/>
	        </span>
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="return btn_OpinionCancel_onclick()"></span></li>
            </ul>
        </div>
	    <div class="listview" style="width: 100%; height: 190px; overflow-x:hidden; overflow-y: AUTO;">
	        <div id="OPINION" style="margin:1px 1px 1px 1px;">
	        </div>
	    </div>
	    <h2 style="margin-top: 10px; margin-bottom: 3px">
	        <spring:message code='ezApprovalG.t423'/>
	    </h2>
	    <textarea id="txt_OpinionContent" name="txt_OpinionContent" class="textarea" style="width: 100%;
	        height: 150px; box-sizing:border-box;-moz-box-sizing:border-box; resize:none;"  onfocus="return txt_OpinionContent_onfocus()"
	        onchange="return txt_OpinionContent_onchange()"></textarea>
	    <div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="bbtn_OpinionAdd"><span id="btn_OpinionAdd" onClick="return btn_OpinionAdd_onclick()" ><spring:message code='ezApprovalG.t268'/></span></a>
		    <a class="imgbtn" id="bbtn_OpinionDel"><span id="btn_OpinionDel" onClick="return btn_OpinionDel_onclick()" ><spring:message code='ezApprovalG.t266'/></span></a>
		    <a class="imgbtn" id="bbtn_OpinionCancel" style="display:none"><span id="btn_OpinionCancel" onClick="return btn_OpinionOK_onclick()"><spring:message code='ezApprovalG.t1760'/></span></a>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
