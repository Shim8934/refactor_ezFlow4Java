<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t55'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Opinion_New_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script id="clientEventHandlersJS" type="text/javascript">
		var RetValue, ReturnFunction;
		var pOpinionMod, pOpinionContent;
		var primary = "<c:out value='${primary}'/>"; // 의견 작성 시 다국어 대응을 위한 변수 (1:기본언어, 2:다국어)
		var designationUsed; // 지정반송 사용여부
		var pUserName;
		
		window.onload = function () {
			if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
			    KeEventControl(document.getElementById("txt_OpinionContent"));
			}
			
			try {
			    RetValue = parent.opinionPopup_cross_dialogArguments[0];
			    ReturnFunction = parent.opinionPopup_cross_dialogArguments[1];
			    
			    if (typeof(RetValue) == "undefined") {
			    	RetValue = opener.opinionPopup_cross_dialogArguments[0];
                    ReturnFunction = opener.opinionPopup_cross_dialogArguments[1];
			    }
			} catch (e) {
			    try {
			        RetValue = opener.opinionPopup_cross_dialogArguments[0];
			        ReturnFunction = opener.opinionPopup_cross_dialogArguments[1];
			    } catch (e) {
			        RetValue = window.dialogArguments;
			    }
			}
			
			pOpinionMod = RetValue[0];
			pOpinionContent = RetValue[1];
			designationUsed = RetValue[2]; // 2024-06-24 양지혜 - 전자결재 > 지정반송
			pUserName = RetValue[4];
			
			document.getElementById("txt_OpinionContent").focus();
			
			if (pOpinionMod == "MOD") {
				document.getElementById("txt_OpinionContent").value = pOpinionContent;
			}

			if (designationUsed == "YES" && RetValue[3] == "Y") {
				document.getElementById("returnUserArea").style.display = "";
				document.getElementById("txt_OpinionContent").style.height = "200px";
			}
		};
		
		function btn_OpinionCancel_onclick() {
			if (ReturnFunction != null) {
				ReturnFunction("cancel");
			} else {
				window.returnValue = "cancel";
			}
		}
		
		function btn_OpinionSave_onclick() {
			var opinionContent = document.getElementById("txt_OpinionContent").value;

			// 2024-06-24 양지혜 - 전자결재 > 지정반송 > 의견내용에 관련 정보 추가
			var returnUserSN = getReturnUserSN();
			if (returnUserSN != "") {
				opinionContent += returnInfo;
			}
			
			if (opinionContent.trim() != "") {
				var returnValue = new Array();
				returnValue[0] = pOpinionMod;
				returnValue[1] = opinionContent;
					
				/* 2020-04-02 홍승비 - 신규의견 저장 시 부모 의견창에 신규의견작성 플래그 전달 (수정 시 무시) */
				var pNewOpinionFlag = false;
				if (pOpinionMod == "ADD") {
					pNewOpinionFlag = true;
				}
				returnValue[2] = pNewOpinionFlag;
				returnValue[3] = returnUserSN;
				
				if (ReturnFunction != null) {
					ReturnFunction(returnValue);
				} else {
					window.returnValue = returnValue;
				}
			} else {
				var pAlertContent = strLang402;
	            OpenAlertUI(pAlertContent, btn_OpinionSave_onclick_complete);
	            return;
			}
		}
		
		function btn_OpinionSave_onclick_complete() {
			DivPopUpHidden();
			document.getElementById("txt_OpinionContent").focus();
		}

		/* 2024-06-24 양지혜 - 전자결재 > 지정반송 > 의견내용에 관련 정보 추가 */
		var returnInfo = "";
		function getReturnUserSN() {
			var checkedId = "";
			var userList = document.getElementsByName('returnUser');
			for (var i=0; i < userList.length; i++) {
				if (userList[i].checked) {
					checkedId = userList[i].value;
					returnInfo = "\n└ [지정반송] " + getNowDate() + " " + pUserName + " → " + userList[i].getAttribute('data1');
 				}
			}
			return checkedId
		}

		function getNowDate() {
			var now = new Date();
			var month = now.getMonth().toString().length == 1 ? "0" + (now.getMonth() + 1) : now.getMonth() + 1;
			var date = now.getDate().toString().length == 1 ? "0" + now.getDate() : now.getDate();
			return now.getFullYear() + "-" + month + "-" + date;
		}
		</script>
		<style type="text/css">
		</style>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t423'/></h1>
	    
	    <div id="close">
            <ul><li><span onclick="return btn_OpinionCancel_onclick()"></span></li></ul>
        </div>
        
	    <textarea id="txt_OpinionContent" style="width:477px; height:255px; resize: none;"></textarea>

		<%-- 2024-06-24 양지혜 - 전자결재 > 지정반송 > 반송위치 영역 --%>
		<div id="returnUserArea" style="display: none ">
			<h2 style="margin-top: 10px; margin-bottom: 3px;"><spring:message code='ezApprovalG.yjh03'/></h2>
			<div class="listview">
				<div id="lvUserList" style="height: 130px; overflow-x:hidden; overflow-y: AUTO; padding: 5px;">
					${aprUserList}
				</div>
			</div>
		</div>
	    
	    <div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="bbtn_OpinionSave"><span id="btn_OpinionSave" onClick="return btn_OpinionSave_onclick()"><spring:message code='ezApprovalG.t1767'/></span></a>
	    </div>
	    
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
