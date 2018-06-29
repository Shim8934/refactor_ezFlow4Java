<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t325" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript">
			var g_bFlag = true;

	    	function btnOk_Click() {
		        chk_Instance.checked == true ? dialogArguments["InstanceType"] = "Instance" : dialogArguments["InstanceType"] = "Master";
	        	g_bFlag = false;
	        	window.close();
	    	}

	    	function btnCancel_Click() {
		        window.close();
	    	}

	    	window.onbeforeunload = function () {
		        if (g_bFlag != true) {
	            	dialogArguments["CancelOpen"] = false;
		        } else {
		            dialogArguments["CancelOpen"] = true;
	        	}
	    	}
		</script>
	</head>
	<body class="popup"  LANGUAGE=javascript style="overflow:hidden">
		<h1><spring:message code="ezResource.t326" /></h1>
		<div class="txt"><spring:message code="ezResource.t320" /><br>
  			<spring:message code="ezResource.t327" /><br>
  			<spring:message code="ezResource.t322" />
  		</div>
		<br>
		<div class="box" style="padding:10px">
  			<input id=chk_Instance type="radio" name="chk_Open" value="Instance" checked>
  				<spring:message code="ezResource.t328" />
  		<br>
  			<input type="radio" name="chk_Open" value="Master">
  				<spring:message code="ezResource.t329" />
  		</div>
		<div class="btnposition">
  			<input type="submit" value="<spring:message code="ezResource.t15" />" onClick="btnOk_Click();">
  			<input type="submit" value="<spring:message code="ezResource.t16" />" onClick="btnCancel_Click();">
		</div>
	</body>
</html>
