<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet"  href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<title><spring:message code="ezSystem.kbh08" /></title>
</head>
<body class="mainbody" style="overflow:hidden;">
	<h1>
		<spring:message code="ezSystem.kbh08" />
		<span class="title_bar"><img src="/images/name_bar.gif"></span>
		<select class="companySelect" id="companyList">
			<c:forEach var="company" items="${companyList}">
				<option value="${company.cn }" ${company.cn eq companyID ? 'selected' : ''}><c:out value='${company.displayName}'/></option>
			</c:forEach>
		</select>
	</h1>
	<br><span class="txt">▒ <spring:message code="ezSystem.kbh04" /></span><br><br>
	<table class="content" style="width:600px;">
		<colgroup>
			<col style="width: 60px;"/>
			<col />
		</colgroup>
		<tr>
			<th rowspan="2"><spring:message code="ezSystem.kbh05" /></th>
			<td><input type="radio" name="multiLogin" value="YES" id="multiLogin_YES" ${useMultiLogin eq 'YES' ? 'checked' : ''}><label for="multiLogin_YES"><span style="vertical-align:middle;"><spring:message code="ezSystem.kbh06" /></span></label></td>
		</tr>
		<tr>
			<td><input type="radio" name="multiLogin" value="NO" id="multiLogin_NO" ${useMultiLogin eq 'NO' ? 'checked' : ''}><label for="multiLogin_NO"><span style="vertical-align:middle;"><spring:message code="ezSystem.kbh07" /></span></label></td>
		</tr>
	</table>
	<div style="width:600px;">
		<div class="btnpositionJsp">
			<a id="btn_save" class="imgbtn"><span><spring:message code="ezSystem.kbh09" /></span></a>
			<a id="btn_cancle" class="imgbtn"><span><spring:message code="ezSystem.kbh10" /></span></a>
		</div>
	</div>
	<script type="text/javascript">
		var btn_save = document.getElementById("btn_save");
		var btn_calcle = document.getElementById("btn_cancle");
		var select_companyList = document.getElementById("companyList");
		var originCheckValueID = document.querySelector('[name="multiLogin"]:checked').id;
		
		// function
		var setMultiLoginType = function() {
			var multiLoginType = document.querySelector('[name="multiLogin"]:checked');
			
			$.ajax({
				type: "POST",
				url: "/admin/ezSystem/companyMultiLoginType.do",
				data: {
					companyID: select_companyList.value,
					multiLoginType: multiLoginType.value
				},
				success: function() {
					alert("<spring:message code='ezSystem.kbh11' />");
					originCheckValueID = multiLoginType.id;
				},
				error: function() {
					alert("<spring:message code='ezSystem.kbh12' />");
				}
			});
		}
		
		var cancelAction = function() {
			document.getElementById(originCheckValueID).checked = true;
		}
		
		var getMultiLoginType = function() {
			$.ajax({
				type: "GET",
				url: "/admin/ezSystem/companyMultiLoginType.do",
				data: {
					companyID: select_companyList.value
				},
				success: function(result) {
					var multiLoginID = "multiLogin_" + result;
					document.getElementById(multiLoginID).checked = true;
				}
			});
		}
		
		// event
		document.addEventListener('DOMContentLoaded', function() {
			btn_save.onclick = setMultiLoginType;
			btn_calcle.onclick = cancelAction;
			select_companyList.onchange = getMultiLoginType;
		}, false);
		
	</script>
</body>
</html>