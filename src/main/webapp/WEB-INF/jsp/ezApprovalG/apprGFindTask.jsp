<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t111'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script ID="clientEventHandlersJS" LANGUAGE="javascript">
		    var rtnVal = new Array();
		    window.onload = function ()
		    {
		        rtnVal[0]="FALSE";
		    }
		    function btnReset_onclick()
		    {
		        txtTitle.value = "";
		        txtCode.value = "";
		    }
		    function btnOK_onclick()
		    {
		        if(txtTitle.value=="" && txtCode.value=="")
		        {
		            alert("<spring:message code='ezApprovalG.t1023'/>");
		        }
		        else
		        {
		            rtnVal[0]="TRUE";
		            rtnVal[1]=txtTitle.value;
		            rtnVal[2]=txtCode.value;
		            window.close();
		        }
		    }
		    function btnClose_onclick(){
		        rtnVal[0]="FALSE";
		        window.close();
		    }
		    window.onunload = function ()
		    {
		        window.returnValue = rtnVal;
		    }
		</script>
	</head>
	<body leftmargin="0" topmargin="0"class="popup">
		<h1><spring:message code='ezApprovalG.t111'/></h1>
		<table class="content">
		  <tr>
		    <th><spring:message code='ezApprovalG.t649'/></th>
		    <td><input type="text" class="text" style="Width:100%; " name="txtTitle" id="txtTitle">
		    </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t1024'/></th>
		    <td><input type="text" class="text" style="Width:100%; " name="txtCode" id="txtCode">
		    </td>
		  </tr>
		</table>
		<div class="btnposition">
		<a class="imgbtn" name="btnReset" onclick = "return btnReset_onclick()"><span><spring:message code='ezApprovalG.t621'/></span></a>
		<a class="imgbtn" name="btnOK" onclick = "return btnOK_onclick()"><span><spring:message code='ezApprovalG.t111'/></span></a>
		<a class="imgbtn" id="btnClose" name="btnOK" onclick="return btnClose_onclick()"><span><spring:message code='ezApprovalG.t64'/></span></a>
		</div>
	</body>
</html>