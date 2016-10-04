<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAddress.t320' /></title>
		<meta name="CODE_LANGUAGE" Content="C#">
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
        <link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script>
		    var Arguments;
		    var ReturnFunction;
		    var CancelFunction;
		    function window_onload() {
		        try {
		            Arguments = parent.address_select_groupemaillist_dialogArguments[0];
		            ReturnFunction = parent.address_select_groupemaillist_dialogArguments[1];
		            CancelFunction = parent.address_select_groupemaillist_dialogArguments[2];
		        } catch (e) {
		            try {
		                Arguments = opener.address_select_groupemaillist_dialogArguments[0];
		                ReturnFunction = opener.address_select_groupemaillist_dialogArguments[1];
		                CancelFunction = opener.address_select_groupemaillist_dialogArguments[2];
		            } catch (e) { }
		        }
		        document.getElementById("cmd_ok").focus();
		    }
		    function Window_Close() {
		        if (ReturnFunction!=null) {
		            CancelFunction();
		        }
		        else {
		            window.returnValue = 0;
		            window.close();
		        }
		    }
			function add_personal() {
			    var count = 0;
			    var pchecks = document.getElementsByName("goruplistinput");
			    for (var i = 0; i < pchecks.length; i++) {
			        if (document.getElementsByName("goruplistinput").item(i).checked) {
			            if (ReturnFunction!=null) {
			                Arguments["name"][count] = document.getElementsByName("goruplistinput").item(i).getAttribute("_name");
			                Arguments["email"][count] = document.getElementsByName("goruplistinput").item(i).getAttribute("_email");
			            }
			            else {
			                window.dialogArguments["name"][count] = document.getElementsByName("goruplistinput").item(i).getAttribute("_name");
			                window.dialogArguments["email"][count] = document.getElementsByName("goruplistinput").item(i).getAttribute("_email");
			            }
			            count++;
			        }
			    }
			    if (ReturnFunction != null) {
			        ReturnFunction(count);
			    }
			    else {
			        window.returnValue = count;
			        window.close();
			    }
			}
		</script>
	</head>
	<body style="overflow:hidden;" class="popup" onload="javascript:window_onload()">
		<form id="Form1" method="post" runat="server">
			<h1><spring:message code='ezAddress.t320' /></h1>
			
			<div id="maillist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; HEIGHT:323px;" class="box">
				<table style="width:100%;" class="popuplist" > 
					<tr> 
						<th style="width:28px;vertical-align:middle;"><spring:message code='ezAddress.t321' /></th>
						<th style="width:200px;white-space:nowrap;"><spring:message code='ezAddress.t124' /></th>
						<th style="white-space:nowrap;" ><spring:message code='ezAddress.t322' /></th>
					</tr>
					<c:forEach var="item" items="${list}">
						<tr>
							<td style="text-align:center">
								<input type='checkbox' value="1" checked name="goruplistinput" _name="${item.personal}" _email="${item.address}">
							</td>
							<td style="white-space:nowrap" >${item.personal}</td>
							<td style="white-space:nowrap" >${item.address}</td>
						</tr>
					</c:forEach>
				</table>
			</div>
			<div class="btnposition">
				<a class="imgbtn" onClick="add_personal()" id="cmd_ok"><span><spring:message code='ezAddress.t25' /></span></a>
				<a class="imgbtn" onClick="Window_Close()"><span><spring:message code='ezAddress.t11' /></span></a>
			</div>
		</form>
	</body>
</html>


