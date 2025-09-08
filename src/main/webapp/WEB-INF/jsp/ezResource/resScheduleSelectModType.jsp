<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.ModType.jih01'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var modType;
			var ReturnFunction;

		    window.onload = function () {
		        try {
		            ReturnFunction = parent.resScheduleSelectModType_cross_dialogArguments[0];
		        } catch (e) {
					try {
						ReturnFunction = opener.resScheduleSelectModType_cross_dialogArguments[0];
					} catch { }
		        }
		    }

		    function btnOk_Click() {
				modType = document.querySelector("input[name='modType']:checked").value;
				if (ReturnFunction != null) {
					ReturnFunction(modType);
					window.close();
				} else {
					window.returnValue = modType;
					window.close();
				}
		    }

		    function btnCancel_Click() {
		    	if (ReturnFunction != null) {
		            parent.DivPopUpHidden();
		        } else {
		            window.close();
				}
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<h1><spring:message code='ezSchedule.ModType.jih01'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="btnCancel_Click()"></span></li>
            </ul>
        </div>
  		<table class="content" style="width:100%">
			<tr>
		    	<td colspan="3">
		    		<input type="radio" name="modType" value="1" checked>
		      		<label for="modType"><spring:message code='ezSchedule.ModType.jih03'/></label>
		      	</td>
		  	</tr>
		  	<tr>
		    	<td colspan="3">
		    		<input type="radio" name="modType" value="2" >
		      		<label for="modType"><spring:message code='ezSchedule.ModType.jih04'/></label>
		      	</td>
		  	</tr>
            <tr>
		    	<td colspan="3">
		    		<input type="radio" name="modType" value="3" >
		      		<label for="modType"><spring:message code='ezSchedule.ModType.jih05'/></label>
		      	</td>
		  	</tr>  
		</table>
		<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="btnOk_Click()" ><spring:message code="ezResource.t15" /></span></a>
		</div>
	</body>
</html>
