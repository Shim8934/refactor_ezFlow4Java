<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="overflow:hidden">
	<head>
		<title><spring:message code='ezEmail.t659' /></title>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script>
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    var Arguments;
		    var ReturnFunction;
		    var CancelFunction;
		    window.onload = function () {
		        try {
		            Arguments = parent.mail_select_dlmember_cross_dialogArguments[0];
		            ReturnFunction = parent.mail_select_dlmember_cross_dialogArguments[1];
		            CancelFunction = parent.mail_select_dlmember_cross_dialogArguments[2];
		        } catch (e) {
		            try {
		                Arguments = opener.mail_select_dlmember_cross_dialogArguments[0];
		                ReturnFunction = opener.mail_select_dlmember_cross_dialogArguments[1];
		                CancelFunction = opener.mail_select_dlmember_cross_dialogArguments[2];
		            } catch (e) { }
		        }
		        if ("${isUser}" == "group") {
		            document.getElementById("h1").innerHTML += " - <spring:message code='ezEmail.t26' />";
		        }
		        document.all("cmd_ok").focus();
		    }
		    function Window_Close() {
		        if (ReturnFunction != null) {
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
		                if (ReturnFunction != null) {
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
	<body style="overflow:hidden;" class="popup">
		<form method="post">
			<h1 id="h1"><spring:message code='ezEmail.t659' /></h1>
			<div class="box" id="maillist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; HEIGHT:320px">
			  <table style="width:100%;" class="popuplist" style="TABLE-LAYOUT:fixed" id="checkboxtable">
			    <tr>
			      <th style="width:50px;text-align:center;"><spring:message code='ezEmail.t488' /></th>
			      <th><spring:message code='ezEmail.t712' /></th>
			      <th style="width:100px;text-align:center;"><spring:message code='ezEmail.t26' /></th>
			      <th style="width:80px;text-align:center;"><spring:message code='ezEmail.t28' /></th>
			      <th style="width:80px;text-align:center;"><spring:message code='ezEmail.t31' /></th>
			    </tr>
			    
			    <c:forEach var="item" items="${list}">
			    
			    <tr>
			      <td style="text-align:center;"><input type='checkbox' name="goruplistinput" _email="${item.mail}" _name="${item.displayName}" checked ></td>
			      <td>&nbsp;${item.company} </td>
			      <td style="text-align:center;">${item.dept}</td>
			      <td style="text-align:center;">${item.title}</td>
			      <td style="text-align:center;">${item.displayName}</td>
			    </tr>
			    
			    </c:forEach>
			    
			  </table>
			</div>
		  <div class="btnposition">
		    <a class="imgbtn" onClick="add_personal()" id="cmd_ok"><span><spring:message code='ezEmail.t38' /></span></a>
		    <a class="imgbtn" onClick="Window_Close()"><span><spring:message code='ezEmail.t39' /></span></a>
		  </div>
		</form>
	</body>
</html>



