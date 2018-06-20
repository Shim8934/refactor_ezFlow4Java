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
	<body class="cabGeneral">
		<br>
		
		<table class="cabTable">
			<tr>
				<th><spring:message code="ezCabinet.t32"/></th>
				<th><spring:message code="ezCabinet.t33"/></th>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t36"/></td>
				<td>
					<input type="radio" id="tk_actInput"   name="tk" ${tkFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="tk_deactInput" name="tk" ${tkFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t37"/></td>
				<td>
					<input type="radio" id="ml_actInput"   name="ml" ${mkFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="ml_deactInput" name="ml" ${mkFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t38"/></td>
				<td>
					<input type="radio" id="pn_actInput"   name="pn" ${pnFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="pn_deactInput" name="pn" ${pnFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t39"/></td>
				<td>
					<input type="radio" id="hrp_actInput"   name="hrp" ${hrpFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="hrp_deactInput" name="hrp" ${hrpFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t40"/></td>
				<td>
					<input type="radio" id="actInput"   name="sch" ${schFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="deactInput" name="sch" ${schFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t41"/></td>
				<td>
					<input type="radio" id="omg_actInput"   name="omg" ${omgFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="omg_deactInput" name="omg" ${omgFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t42"/></td>
				<td>
					<input type="radio" id="res_actInput"   name="res" ${resFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="res_deactInput" name="res" ${resFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t43"/></td>
				<td>
					<input type="radio" id="com_actInput"   name="com" ${comFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="com_deactInput" name="com" ${comFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
			<tr>
				<td class="cabName"><spring:message code="ezCabinet.t44"/></td>
				<td>
					<input type="radio" id="pro_actInput"   name="pro" ${proFlag == 'Y' ? 'checked' : ''}><label><spring:message code="ezCabinet.t34"/></label>
					<input type="radio" id="pro_deactInput" name="pro" ${proFlag == 'Y' ? '' : 'checked'}><label><spring:message code="ezCabinet.t35"/></label>
				</td>
			</tr>
		</table>
		
		<br>
		
		<div class="cabBttnDiv">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript">
			(function() {
				init();
				
				function init() {
					var buttons = document.querySelectorAll("a[class='imgbtn']");
					buttons[0].firstElementChild.onclick = function(e) {save();};
					buttons[1].firstElementChild.onclick = function(e) {cancel();};
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