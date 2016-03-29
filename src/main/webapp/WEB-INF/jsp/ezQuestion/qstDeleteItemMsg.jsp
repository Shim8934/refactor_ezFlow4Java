<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezQuestion.t270" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<style>
		</style>
		<script language="JavaScript" type="text/javascript" ID="clientEventHandlersJS">
		  	var pBrdID = "${pBrdID}";
		   	var pItemNo = "${itemNo}";
		    var ReturnFunction;
		    var RetValue;
		    window.onload = function () {
 		        try{
 		            RetValue = parent.qst_delete_itemmsg_dialogArguments[0];
 		            ReturnFunction = parent.qst_delete_itemmsg_dialogArguments[1];
 		        } catch (e) {
 		            try {
		                RetValue = opener.qst_delete_itemmsg_dialogArguments[0];
 		                ReturnFunction = opener.qst_delete_itemmsg_dialogArguments[1];

 		            } catch (e) {
 		                RetValue = window.dialogArguments;
 		            }
 		        }

 		        TITLE.innerHTML = RetValue["TITLE"];
 		        WRITER.innerHTML = RetValue["WRITER"];
		    }
		    function btn_Delete() {
		        var xmlHttp = createXMLHttpRequest();
		        var szUrl = "callDeleteItem.do?brd_id=" + pBrdID + "&item_no=" + pItemNo;
		        xmlHttp.open("POST", szUrl, false);
		        xmlHttp.send();
		        var resultXML = xmlHttp.responseXML;
		        if (resultXML.xml == "")
		            alert("<spring:message code='ezQuestion.t263' />" + "\n" + "<spring:message code='ezQuestion.t264' />");
		        else {
		            State = SelectSingleNodeValue(resultXML, "DATA");
		            if (State != "DELETE_OK")
		                alert("<spring:message code='ezQuestion.t263' />" + "\n" + "<spring:message code='ezQuestion.t264' />");
		            else {
		                if(ReturnFunction != null)
		                    ReturnFunction();
		                window.close();
		            }
		        }
		    }
		</script>
	</head>
	<body class="mainbody">
		<form id="Form1" method="post" runat="server"> 
			<h1><spring:message code='ezQuestion.t262' /></h1>
  			<table class="content"> 
    			<tr > 
      				<th><spring:message code='ezQuestion.t255' /></th> 
      				<td id="TITLE"></td> 
    			</tr> 
    			<tr> 
      				<th><spring:message code='ezQuestion.t265' /></th> 
      				<td id="WRITER"></td> 
    			</tr> 
  			</table>
  			<div class="box" style="padding:10px;margin-top:10px">
  				<spring:message code='ezQuestion.t266' /><br> 
        		<spring:message code='ezQuestion.t267' />
        	</div>
			<div class="btnposition"><input type="button" name="Submit" value="<spring:message code='ezQuestion.t268' />" onclick="btn_Delete()"> 
        		<input type="button" name="Submit2" value="<spring:message code='ezQuestion.t269' />" onclick="window.close()">
        	</div>
		</form> 
	</body>
</html>