<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t214' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var compid = "";
			var ReturnFunction;
			var RetValue;
			window.onload = window_onload;
			function window_onload() {
				try {
				    RetValue = parent.addpoll_cross_dialogArguments[0];
				    ReturnFunction = parent.addpoll_cross_dialogArguments[1];
				} catch (e) {
				    try {
				        RetValue = opener.addpoll_cross_dialogArguments[0];
				        ReturnFunction = opener.addpoll_cross_dialogArguments[1];
				    } catch (e) {
				        RetValue = window.dialogArguments;
				    }
				}
				compid = RetValue;
				selectnum_change();
				
				try {
				    var ua = navigator.userAgent;
				    if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
				        var input = document.getElementsByTagName("input");
				        for (var i = 0; i < input.length; i++) {
				            if (input[i].getAttribute("type") == "text")
				                KeEventControl(input[i]);
				        }
				    }
				}
				catch (e)
				{ }
			}
			
			function selectnum_change() {
				var number = parseInt(selectnum.value);
				for (var i = 1; i < number + 1; i++) {
				    document.getElementById("answer" + i).readOnly = false;
				    document.getElementById("answer" + i).disabled = false;
				}
				
				for (var i=number+1; i<11; i++) {
				    document.getElementById("answer" + i).disabled = true;
				    document.getElementById("answer" + i).value = "";
				}
			}
				
			function OK_Click() {
				if (compid == "") {
					return;
				}
				
				if( document.getElementById("Title").value == "" ) {
					alert("<spring:message code = 'ezPersonal.t215' />");
					document.getElementById("Title").focus();
					return;
				}
				
				if (get_length(document.getElementById("Title").value) > 500) {
					alert("<spring:message code = 'ezPersonal.t216' />");
					return;
				}
				
				for (var i=1; i<11; i++) {
					if (get_length(eval("answer" + i).value) > 100) {
						alert("<spring:message code = 'ezPersonal.t217' />");
						eval("answer" + i).focus();
						return;
					}
				}
				
				//2017-02-19
				//보기에 아무것도 넣지 않았을때, 보기를 입력해야 하도록 수정
				for (var i=1; i<parseInt(selectnum.value)+1; i++) {
					if (document.getElementById("answer" + i).value == "") {
						alert("<spring:message code = 'ezPersonal.jjs01'/>"+i+"<spring:message code = 'ezPersonal.jjs02'/>");
						return;
					}
				}
				
				var objRoot, objNode;
				var xmlDom = createXmlDom();
				var xmlHTTP = createXMLHttpRequest();
				createNodeInsert(xmlDom, objRoot, "DATA"); 
				createNodeAndInsertText(xmlDom, objNode, "COMPID", compid);
				createNodeAndInsertText(xmlDom, objNode, "TITLE", document.getElementById("Title").value);
				createNodeAndInsertText(xmlDom, objNode, "TITLE2", document.getElementById("Title2").value);
				createNodeAndInsertText(xmlDom, objNode, "NUM", document.getElementById("selectnum").value);
				
				for (var i=1; i<11; i++) {
				    createNodeAndInsertText(xmlDom, objNode, "ANSWER", eval("answer" + i).value);
				}
				
				xmlHTTP.open("POST", "/admin/ezPersonal/savePoll.do", false);
				xmlHTTP.send(xmlDom);
				
				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
					alert("<spring:message code = 'ezPersonal.t218' />");
				} else {
				    alert("<spring:message code = 'ezPersonal.t219' />");
				    
				    if (ReturnFunction != null) {
				        ReturnFunction("");
				    } else {
				        window.returnValue = "";
				    }
					window.close();
				}
			}
			
			function get_length(chkstr) {
				var length = 0;
				var i;
				
				for (i=0; i<chkstr.length; i++) {
					if (chkstr.charCodeAt(i) > 256) {
						length = length + 2;
					} else {
						length++;
					}
				}
				
				return length;
			}
		</script>
	</head>
	<body class = "popup">
		<h1><spring:message code = 'ezPersonal.t220' /></h1>
		<table class="content">
			<tr>
		    	<th><spring:message code = 'ezPersonal.t221' /></th>
		    	<td style="padding:0">
			    	<table width="100%">
			        	<tr class="primary">
			          		<th><c:out value = '${langPrimary}' /></th>
			          		<td><input type="text" name="Input" id=Title style="WIDTH:97%"></td>
			        	</tr>
			        	<tr class="secondary">
			          		<th><c:out value = '${langSecondary}' /></th>
			          		<td><input type="text" id=Title2 style="WIDTH:97%"></td>
			        	</tr>
			    	</table>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezPersonal.t222' /></th>
		    	<td>
		    		<select id=selectnum onChange="selectnum_change()">
				        <option value=2>2<spring:message code = 'ezPersonal.t223' /></option>
				        <option selected value=3>3<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=4>4<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=5>5<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=6>6<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=7>7<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=8>8<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=9>9<spring:message code = 'ezPersonal.t223' /></option>
				        <option value=10>10<spring:message code = 'ezPersonal.t223' /></option>
		      		</select>
		      	</td>
			</tr> 
			<tr> 
		    	<th><spring:message code = 'ezPersonal.t224' /></th> 
		  		<td><input type="text" id=answer1 style="WIDTH: 97%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t225' /></th> 
		  		<td><input type="text" id=answer2 style="WIDTH: 97%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t226' /></th> 
		  		<td><input type="text" id=answer3 style="WIDTH: 97%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t227' /></th> 
		  		<td><input type="text" id=answer4 style="WIDTH: 97%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t228' /></th> 
		  		<td><input type="text" id=answer5 style="WIDTH: 97%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t229' /></th> 
		  		<td><input type="text" id=answer6 style="WIDTH: 97%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t230' /></th> 
		  		<td><input type="text" id=answer7 style="WIDTH: 97%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t231' /></th> 
		  		<td><input type="text" id=answer8 style="WIDTH: 97%"></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezPersonal.t232' /></th> 
		  		<td><input type="text" id=answer9 style="WIDTH: 97%"></td>
		   	</tr> 
		  	<tr> 
			    <th><spring:message code = 'ezPersonal.t233' /></th> 
		  		<td><input type="text" id=answer10 style="WIDTH: 97%"></td>
		  	</tr> 
		</table> 
		<div class="btnposition"> 
		    <a class="imgbtn"><span onclick="OK_Click()"><spring:message code = 'ezPersonal.t12' /></span></a>
		    <a class="imgbtn"><span onClick="window.close()"><spring:message code = 'ezPersonal.t13' /></span></a>
	    </div>
	</body>
</html>