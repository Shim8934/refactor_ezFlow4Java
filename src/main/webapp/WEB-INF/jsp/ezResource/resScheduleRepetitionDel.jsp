<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t319" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var ReturnFunction;
			var m_dialogArguments;

		    window.onload = function () {
		        try {
		            ReturnFunction = parent.schedule_repetition_del_cross_dialogArguments[1];
		            m_dialogArguments = parent.schedule_repetition_del_cross_dialogArguments[0];
		        }
		        catch (e) {
		            m_dialogArguments = dialogArguments;
		        }
		    }

		    function btnOk_Click() {
		        document.getElementById("chk_Instance").checked == true ? m_dialogArguments["InstanceType"] = "Instance" : m_dialogArguments["InstanceType"] = "Master";
		        
		        m_dialogArguments["CancelOpen"] = false;
		        if (ReturnFunction != null) {
		            ReturnFunction(m_dialogArguments);
		        } else {
		            window.close();
		        }
		    }

		    function btnCancel_Click() {
		        m_dialogArguments["CancelOpen"] = true;
		        if (ReturnFunction != null) {
		            ReturnFunction(m_dialogArguments);
		        } else {
		            window.close();
		        }
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<h1><spring:message code="ezResource.t319" /></h1>
		<div class="txt"><spring:message code="ezResource.t320" /><br>
  			<spring:message code="ezResource.t321" /><br>
  			<spring:message code="ezResource.t322" />
  		</div>
		<div class="box" style="padding:10px">
  			<input id=chk_Instance type="radio" name="chk_Open" value="Instance" checked>
  				<spring:message code="ezResource.t323" /><br>
  			<input type="radio" name="chk_Open" value="Master">
  				<spring:message code="ezResource.t324" />
  		</div>
		<div class="btnposition">
  			<input type="submit" value="<spring:message code="ezResource.t15" />" onClick="btnOk_Click();">
  			<input type="submit" value="<spring:message code="ezResource.t16" />" onClick="btnCancel_Click();">
		</div>
	</body>
</html>
