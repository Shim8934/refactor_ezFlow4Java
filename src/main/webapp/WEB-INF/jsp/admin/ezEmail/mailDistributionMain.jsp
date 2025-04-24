<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html style="height: 99%;">
<head>
	<title><spring:message code='email.appr.menu.allhands' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">	
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
</head>
<body class="mainbody" style="height: 95%;">
	<h1>
    	<spring:message code='ezEmail.t58'/>
    	<span class="title_bar"><img src="/images/name_bar.gif"></span>
    	<select id="ListCompany" class="companySelect" onchange="selectCompanyId()" style="height:29px">
        	<c:forEach var="item" items="${list}">
        		<%--<c:set var="optionSelect" value="${item.cn == userInfo.companyID ? 'selected' : ''}"/>--%>
                <c:set var="optionSelect" value="${fn:contains(companyId, item.cn) ? 'selected' : ''}" />
        		<option value="<c:out value='${item.cn}'/>" ${optionSelect}><c:out value='${item.displayName}'/></option>
           	</c:forEach>
	    </select>
    </h1>
    <div class="portlet_tabpart01">
        <div class="portlet_tabpart01_top" id="tab1">
            <p><span data-id="list"><spring:message code='email.dist.main.list' /></span></p> <% // 목록관리 %>
            <p><span data-id="config"><spring:message code='ezEmail.t373' /></span></p> <% // 발송설정 %>
        </div>
    </div>
    
    <div style="padding-top: 20px; height: 85%;">
		<iframe id="Content_ifrm" style="width:100%; height:100%; border:none;" src=""></iframe>
	</div>
</body>
<script type="text/javascript">
var companyId = "<c:out value='${companyId}'/>";
   	
window.onload = function () {
	$("#tab1>p:first-child").click();
};
       
function selectCompanyId() {
	var company = $("#ListCompany").val();
	if (companyId != company) {
		companyId = company;
	}
	
	ChangeTab();  		
}

function ChangeTab() {
	var pSelectTab = $("#tab1>p>span[class='tabon']")[0].dataset.id;
	var ifmURL = "";
	 
	switch (pSelectTab) {
     	case "config": 		ifmURL = "/admin/ezEmail/mailDistributionSender.do?companyId=" + companyId; break;
		default: 			ifmURL = "/admin/ezEmail/mailDistributionList.do?companyId=" + companyId; break;
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
