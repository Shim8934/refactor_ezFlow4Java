<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezCabinet.t31'/></h1>
		<div class="cabiMain">
			<div class="compSelect" id="companySelect">
				<span><b><spring:message code='ezCabinet.t13'/></b></span>
				<select id="companyList">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<table class="cabTable">
				<tr>
					<th><spring:message code="ezCabinet.t32"/></th>
					<th><spring:message code="ezCabinet.t33"/></th>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t36"/></td>
					<td>
						<input type="radio" role="on"  name="tk" ${tkFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="tk" ${tkFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t37"/></td>
					<td>
						<input type="radio" role="on"  name="ml" ${mkFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="ml" ${mkFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t38"/></td>
					<td>
						<input type="radio" role="on"  name="pn" ${pnFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="pn" ${pnFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t39"/></td>
					<td>
						<input type="radio" role="on"  name="hrp" ${hrpFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="hrp" ${hrpFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t40"/></td>
					<td>
						<input type="radio" role="on"  name="sch" ${schFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="sch" ${schFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t41"/></td>
					<td>
						<input type="radio" role="on"  name="omg" ${omgFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="omg" ${omgFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t42"/></td>
					<td>
						<input type="radio" role="on"  name="res" ${resFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="res" ${resFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t43"/></td>
					<td>
						<input type="radio" role="on"  name="com" ${comFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="com" ${comFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
				<tr>
					<td class="cabName"><spring:message code="ezCabinet.t44"/></td>
					<td>
						<input type="radio" role="on"  name="pro" ${proFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
						<input type="radio" role="off" name="pro" ${proFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
					</td>
				</tr>
			</table>
			<br>
			<div class="cabBttnDiv">
				<a class="imgbtn"><span><spring:message code='ezCabinet.t73'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t74'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
		</div>
		
		<script type="text/javascript">
			(function() {
				init();
				
				function init() {
					document.onselectstart = function() {return false;};
					var buttons = document.querySelectorAll("a[class='imgbtn']");
					buttons[0].firstElementChild.onclick = function(e) {setAllCheckBox(true);};
					buttons[1].firstElementChild.onclick = function(e) {setAllCheckBox(false);};
					buttons[2].firstElementChild.onclick = function(e) {save();};
					buttons[3].firstElementChild.onclick = function(e) {cancel();};
				}
				
				function setAllCheckBox(flag) {
					var radioOnList  = document.querySelectorAll("input[type='radio'][role='on']");
					var radioOffList = document.querySelectorAll("input[type='radio'][role='off']");
					
					for (var i = 0, len = radioOnList.length; i < len; i++) {
						radioOnList[i].checked  = flag;
						radioOffList[i].checked = flag == true ? false : true;
					}
				}
				
				function cancel() {window.location.reload(true);}
				
				function save() {
					
					$.ajax({
						url: '',
						method: 'POST',
						dataType: 'JSON',
						data: {
							
						},
						success: function(data) {
							
						},
						error: function(error) {
							alert('Error: ' + error);
						}
					});
				}
			})();
		</script>
	</body>
</html>