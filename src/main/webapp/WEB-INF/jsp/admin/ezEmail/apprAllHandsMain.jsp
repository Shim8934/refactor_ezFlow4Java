<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="height: 99%;">
<head>
	<title><spring:message code='email.appr.menu.allhands' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">	
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
</head>
<body class="mainbody" style="height: 95%;">
	<h1>
    	<spring:message code='email.appr.menu.allhands'/> <% // 전체메일승인 %>
    	<span class="title_bar"><img src="/images/name_bar.gif"></span>
    	<select id="ListCompany" class="companySelect" onchange="selectCompanyID()" style="height:29px">
        	<c:forEach var="item" items="${list}">
        		<c:set var="optionSelect" value="${item.cn == userInfo.companyID ? 'selected' : ''}"/>
        		<option value="<c:out value='${item.cn}'/>" ${optionSelect}><c:out value='${item.displayName}'/></option>
           	</c:forEach>
	    </select>
    </h1>
    <div class="portlet_tabpart01">
        <div class="portlet_tabpart01_top" id="tab1">
            <p><span data-id="policy"><spring:message code='email.appr.menu.allhands.policy'/></span></p> <% // 승인정책 %>
            <p><span data-id="pending"><spring:message code='email.appr.menu.allhands.pending'/></span></p> <% // 승인대기목록 %>
            <p><span data-id="sending"><spring:message code='email.appr.menu.allhands.sending'/></span></p> <% // 승인로그 %>
        </div>
    </div>
    
    <div style="padding-top: 20px; height: 85%;">
		<iframe id="Content_ifrm" style="width:100%; height:100%; border:none;" src=""></iframe>
	</div>
</body>
<script type="text/javascript">
var companyID = "<c:out value='${userInfo.companyID}'/>";
   	
window.onload = function () {
	$("#tab1>p:first-child").click();
};
       
function selectCompanyID() {
	var company = $("#ListCompany").val();
	if (companyID != company) {
		companyID = company;
	}
	
	ChangeTab();  		
}

function ChangeTab() {
	var pSelectTab = $("#tab1>p>span[class='tabon']")[0].dataset.id;
	var ifmURL = "";
	 
	switch (pSelectTab) {
     	case "pending": 		ifmURL = "/admin/ezEmail/appr/allHands/pending.do?companyId=" + companyID + "&startNum=1"; break;
     	case "sending": 		ifmURL = "/admin/ezEmail/appr/allHands/completeLog.do?companyId=" + companyID + "&startNum=1"; break;
		default: 				ifmURL = "/admin/ezEmail/appr/allHands/policy.do?companyId=" 	+ companyID; break;
	}
	
  	document.getElementById("Content_ifrm").src = ifmURL;
}

$("#tab1>p").on({
	"click" : function() {     
		$(this).parent("div").find("p>span").removeClass();
		$(this).find("span")[0].className = "tabon";
		
		ChangeTab();
	},
	"mouseover" : function() {
		if ($(this).find("span").hasClass("tabon")) {return; }
		$(this).parent("div").find("p>span:not(.tabon)").removeClass();
		$(this).find("span:not(.tabon)")[0].className = "tabover";
	},
	"mouseout" : function() {
		$(this).parent("div").find("p>span:not(.tabon)").removeClass();
	}
});

</script>
</html>
