<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezNotification.e1', 'msg')}"></script>
        <link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
		<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css">
	</head>

<body class="notiBody">

<div class="urgent_noti notification" style="overflow: auto; height: 100vh">
    <div class="noti_header">
        <h3><spring:message code="ezNotification.hth57"/></h3>
    </div>
    
    <div class="noti_company_content">
        <span><c:out value = '${notiCompanyContent}'/>
        </span>
    </div>
	
    <div class="urgent_cont">
        <h3><spring:message code="ezNotification.hth58"/></h3>
        <input type="text" id="notiTitle" placeholder="<spring:message code="ezNotification.hth58"/>">
    </div>

    <div class="urgent_cont">
        <h3><spring:message code="ezNotification.hth59"/></h3>
        <textarea id="notiContent"></textarea>
    </div>

    <div class="urgent_cont">
        <h3 id="notiTargetBtn" onclick="openAddRecipient()"><spring:message code="ezNotification.hth61"/><span class="add_btn"><spring:message code="ezNotification.hth60"/></span></h3>
        <ul id="emergencyNotiUserList">
        </ul>
    </div>

    <div class="noti_bot_btn">
        <span id="cancelNotiBtn" onclick="moveToNotiMain()"><spring:message code="ezNotification.hth23"/></span>
        <span id="sendNotiBtn" onclick="sendEmergencyNoti()" class="close"><spring:message code="ezNotification.hth62"/></span>
    </div>
</div>

</body>

<script>
function moveToNotiMain() {
	var notiFrame = window.parent.frames["iframeNoti"];
	notiFrame.setAttribute("src", "/ezNotification/notificationMain.do");
}

var emergency_noti_dialogArguments = [];
function openAddRecipient() {
	var notiRecipientList = document.getElementsByClassName("notiRecipientList");
	var notiParamObj = {};
	var notiParamArray = [];
	for (var i = 0; i < notiRecipientList.length; i++) {
		var notiElem = notiRecipientList[i];
		var cn = notiElem.getAttribute("cn");
		var userType = notiElem.getAttribute("userType");
		var subDeptYn = notiElem.getAttribute("subDeptYn");
		var companyId = notiElem.getAttribute("companyId");
		var notiParam = {};
		notiParam.userType = userType;
		notiParam.cn = cn;
		notiParam.companyId = companyId;
		notiParam.subDeptYn = subDeptYn;
		notiParam.name = notiElem.querySelector('p').textContent;
		notiParamArray.push(notiParam);
	}
	
	emergency_noti_dialogArguments[0] = notiParamArray;
	emergency_noti_dialogArguments[1] = notiListSelect_complete;
	var Params = new Array();
	if (CrossYN()) {
        var OpenWin = window.open("/ezNotification/notiSelectReceiver.do", "ADD_RECEIVER", GetOpenWindowfeature(1040, 590));
        try { OpenWin.focus(); } catch (e) { }
    } else {
        window.showModalDialog("/ezNotification/notiSelectReceiver.do", Params, "dialogHeight:590px; dialogWidth:1040px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(1040, 590));
    }
}

function notiListSelect_complete(notiRecipientArray) {
	//notiRecipientArray = emergency_noti_dialogArguments[0]
	var notiListElem = document.getElementById("emergencyNotiUserList");
	while (notiListElem.firstChild) {
		notiListElem.removeChild(notiListElem.firstChild);
	}
	
	for (var i = 0; i < notiRecipientArray.length; i++) {
		var notiRecipient = notiRecipientArray[i];
		var cn = notiRecipient.recipientId;
		var receiptName = notiRecipient.receiptName;
		var userType = notiRecipient.userType;
		var subDeptYn = notiRecipient.subDeptYn;
		var companyId = notiRecipient.companyId;
		
		var notiLiElem = document.createElement("li");
		notiLiElem.setAttribute("id", "notiRecipientList_" + i);
		notiLiElem.classList.add("notiRecipientList");
		notiLiElem.setAttribute("cn", cn);
		notiLiElem.setAttribute("userType", userType);
		notiLiElem.setAttribute("subDeptYn", subDeptYn);
		notiLiElem.setAttribute("companyId", companyId);
		var notiPElem = document.createElement("p");
		notiPElem.textContent = receiptName;
		var notiDelBtn = document.createElement("span");
		notiDelBtn.addEventListener("click", delRecipieint.bind(notiDelBtn, "notiRecipientList_" + i));
		notiDelBtn.classList.add("del_btn");
		notiLiElem.appendChild(notiPElem);
		notiLiElem.appendChild(notiDelBtn);
		document.getElementById("emergencyNotiUserList").appendChild(notiLiElem);
	}
}

function delRecipieint(listId) {
	if (document.getElementById(listId)) {
		document.getElementById(listId).remove();
	}
}

function sendEmergencyNoti() {
	var notiTitle = document.getElementById("notiTitle").value.trim();
	var notiContent = document.getElementById("notiContent").value.trim();
	
	if (notiTitle == "") {
		alert('<spring:message code="ezNotification.hth63"/>');
		return;
	}
	if (notiContent == "") {
		alert('<spring:message code="ezNotification.hth64"/>');
		return;
	}
	
	if (notiTitle.length > 30) {
		alert('<spring:message code="ezNotification.hth87"/>');
		return;
	}
	
	if (notiContent.length > 2500) {
		alert('<spring:message code="ezNotification.hth88"/>');
		return;
	}
	
	var notiList = document.getElementsByClassName("notiRecipientList");
	
	if(notiList.length == 0) {
		alert('<spring:message code="ezNotification.hth65"/>');
		return;
	}
	var notiParamObj = {};
	var notiParamArray = [];
	for (var i = 0; i < notiList.length; i++) {
		var notiElem = notiList[i];
		var cn = notiElem.getAttribute("cn");
		var userType = notiElem.getAttribute("userType");
		var subDeptYn = notiElem.getAttribute("subDeptYn");
		var companyId = notiElem.getAttribute("companyId");
		var notiParam = {};
		notiParam.userType = userType;
		notiParam.cn = cn;
		if (userType == "PERSON") {
			notiParam.companyId = companyId;
		} else if (userType == "DEPT") {
			notiParam.subDeptYn = subDeptYn;
		}
		notiParamArray.push(notiParam);
	}
	
	notiParamObj.recipient = notiParamArray;
	notiParamObj.notiContent = notiTitle;
	notiParamObj.notiBody = notiContent;
	$.ajax({
		type : "POST",
		dataType : "text",
		contentType : "application/json",
		data : JSON.stringify(notiParamObj),
		async : false,
		url : "/ezNotification/sendEmergencyNoti.do",
		success : function(result) {
			if (result == "false") {
				alert('<spring:message code="ezNotification.hth83"/>');
				return;
			}
			alert('<spring:message code="ezNotification.hth66"/>');
			moveToNotiMain();
		},
		error : function(e) {
			alert('<spring:message code="ezNotification.hth83"/>');
			console.log(e)
		}
	});
}

</script>

</html>