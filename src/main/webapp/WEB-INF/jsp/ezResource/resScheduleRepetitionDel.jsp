<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t319" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
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
		    	var ans = confirm("" + strLang90 + "");
		    	
		    	if (ans) {
			        document.getElementById("chk_Instance").checked == true ? m_dialogArguments["InstanceType"] = "Instance" : m_dialogArguments["InstanceType"] = "Master";
			        
			        m_dialogArguments["CancelOpen"] = false;
			        if (ReturnFunction != null) {
			            ReturnFunction(m_dialogArguments);
			        } else {
			            window.close();
			        }
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
		<div id="close">
            <ul>
                <li><span onclick="btnCancel_Click()"></span></li>
            </ul>
        </div>
		<%-- <div class="box" style="padding:40px 10px 30px;height:70px">
  			<label>
  				<input id="chk_Instance" type="radio" name="chk_Open" value="Instance" checked>
  				<spring:message code="ezResource.t323" />
  			</label><br>
  			<label style="margin-top:15px">
  				<input type="radio" name="chk_Open" value="Master">
  				<spring:message code="ezResource.t324" />
  			</label>
  		</div> --%>
  		<table class="content" style="width:100%">
			<tr>
		    	<td colspan="3">
		    		<input id="chk_Instance" type="radio" name="chk_Open" value="Instance" checked>
		      		<label for="chk_Instance"><spring:message code='ezResource.t323'/></label>
		      	</td>
		  	</tr>
		  	<tr>
		    	<td colspan="3">
		    		<input type="radio" name="chk_Open" value="Master" >
		      		<label for="chk_series"><spring:message code='ezResource.t324'/></label>
		      	</td>
		  	</tr>  
		</table>
		<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="btnOk_Click()" ><spring:message code="ezResource.t15" /></span></a>
		</div>
	</body>
</html>
