<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript">
		function ipListAddPopUp() {
			var url = "/ezSystem/systemAddAccessList.do";
			var ipPopUp = window.open(url, "ipPopUp", GetOpenWindowfeature(970, 600));
		}
	</script>
</head>
<body class="mainbody">
	<br><span><b><spring:message code = 'ezApprovalG.t1566' /> : </b>
	    <select id="ListCompany" onchange="selectCompanyID()" style="height:29px">
        	<c:forEach var="item" items="${list}">
        		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
           	</c:forEach>
	    </select>
    </span><br>
	<br><span class="txt">▒ 거부된 IP(IP대역)에서도 접속 가능한 사용자 및 부서 리스트</span><br><br>
	<div id="mainmenu">
	    <ul class="on">
	        <li><span onclick="ipListAddPopUp()">추가</span></li>
	        <li><span onclick="alert('삭제')">삭제</span></li>
	    </ul>
	</div>
	
	<table class="mainlist" style="width:50%;">	
		<tr>
 			<th width="22px;"><input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
 			<th width="45%;">이름(ID)</th>
 			<th>부서</th>
		</tr>
	</table>
	
</body>
</html>