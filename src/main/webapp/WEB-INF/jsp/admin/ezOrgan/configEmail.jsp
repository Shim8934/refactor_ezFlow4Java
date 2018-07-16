<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='ezOrgan.t144' /></title>
	<link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript">
		
		function Delete_Address()
		{
			if (document.all("ListEmail").selectedIndex == -1)
			{
				alert("<spring:message code='ezOrgan.t145' />");
				return;
			}
	
		    var index = document.all("ListEmail").selectedIndex;
		    
		  	//2017-06-02 이효민 : original 주소, 도메인 Alias 주소 삭제 못하도록 하기 위해 추가
	    	if (document.all("ListEmail").options[index].getAttribute("type") === "1") {
	    		alert("<spring:message code='ezOrgan.lhm1' />");
	            return;
	    	}
	    	
	    	if (document.all("ListEmail").options[index].getAttribute("type") === "2") {
	    		alert("<spring:message code='ezOrgan.lhm3' />");
	            return;
	    	}
	    	
		    if (CrossYN()) {
		        if (document.all("ListEmail").options[index].textContent.indexOf("SMTP") == 0) {
		            alert("Primary" + "<spring:message code='ezOrgan.t146' />");
		            return;
		        }
	
		        if (document.all("ListEmail").options[index].textContent.indexOf("smtp") != 0) {
		            alert("SMTP" + "<spring:message code='ezOrgan.t147' />");
		            return;
		        }
		    } else {
		        if (document.all("ListEmail").options[index].innerText.indexOf("SMTP") == 0) {
		            alert("Primary" + "<spring:message code='ezOrgan.t146' />");
	                return;
	            }
	
	            if (document.all("ListEmail").options[index].innerText.indexOf("smtp") != 0) {
	                alert("SMTP" + "<spring:message code='ezOrgan.t147' />");
		            return;
		        }
		    }
	
			document.all("ListEmail").options[index] = null;
		}
	
		function Set_Primary()
		{
			if (document.all("ListEmail").selectedIndex == -1)
			{
				alert("Primary" + "<spring:message code='ezOrgan.t148' />");
				return;
			}
	
		    var index = document.all("ListEmail").selectedIndex;
		    if (CrossYN()) {
		        if (document.all("ListEmail").options[index].textContent.indexOf("SMTP") == 0)
		            return;
	
		        if (document.all("ListEmail").options[index].textContent.indexOf("smtp") != 0) {
		            alert("SMTP" + "<spring:message code='ezOrgan.t149' />");
		            return;
		        }
	
		        document.all("ListEmail").options[index].textContent = document.all("ListEmail").options[index].textContent.replace("smtp", "SMTP");
	
		        for (var i = 0; i < document.all("ListEmail").length; i++) {
		            if (i != index && document.all("ListEmail").options[i].textContent.indexOf("SMTP") == 0)
		                document.all("ListEmail").options[i].textContent = document.all("ListEmail").options[i].textContent.replace("SMTP", "smtp");
		        }
		    }
		    else {
		        if (document.all("ListEmail").options[index].innerText.indexOf("SMTP") == 0)
		            return;
	
		        if (document.all("ListEmail").options[index].innerText.indexOf("smtp") != 0) {
		            alert("SMTP" + "<spring:message code='ezOrgan.t149' />");
		            return;
		        }
	
	            document.all("ListEmail").options[index].innerText = document.all("ListEmail").options[index].innerText.replace("smtp", "SMTP");
	
	            for (var i = 0; i < document.all("ListEmail").length; i++) {
	                if (i != index && document.all("ListEmail").options[i].innerText.indexOf("SMTP") == 0)
	                    document.all("ListEmail").options[i].innerText = document.all("ListEmail").options[i].innerText.replace("SMTP", "smtp");
	            }
		    }
		}
	
		function Add_Address() {
			var email = trim(prompt("<spring:message code='ezOrgan.t151' />", ""));
			
			if (email == "" || email == null) {
				return;
			}
	
			if (email.indexOf("@") < 1 || email.indexOf("@") != email.lastIndexOf("@")) {
				alert("Email" + "<spring:message code='ezOrgan.t153' />");
				return;
			}
			
			if ( Check_Address(email) ) {
				alert("<spring:message code='ezOrgan.t155' />");
				return;
			}
			
			//2016-12-15 이효민 : 유효한 도메인인지, 이미 사용중인 메일주소인지 체크
			var xmlHTTP = createXMLHttpRequest();
		    var xmlDom = createXmlDom();
	        var xmlPara = createXmlDom();
	        var objRoot, objNode, subNode;
	
		    var objNode;
		    createNodeInsert(xmlDom, objNode, "DATA");
		    createNodeAndInsertText(xmlDom, objNode, "MAIL", email);
			
		    xmlHTTP.open("POST","/admin/ezOrgan/checkEmail.do",false);
			xmlHTTP.send(xmlDom);
	
			if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
				if (xmlHTTP.responseText.indexOf("OTHERDOMAIN") > -1) {
					alert("<spring:message code='ezOrgan.lhm2' />");
					return;
				} else if (xmlHTTP.responseText.indexOf("OTHERUSER") > -1) {
					alert("<spring:message code='ezOrgan.t158' />");
					return;
				} else {
					alert("<spring:message code='ezOrgan.t159' />");
					return;
				}
			}
			//2016-12-15 이효민 END
			
			var newOption = document.createElement("option");        
			newOption.text = "smtp:" + email;
			newOption.setAttribute("type", "0");
			
			document.all("ListEmail").options.add(newOption);
			
			/* 2016-12-15 이효민 : 사용하지 않음.
			if (document.all("CheckPolicy").checked == true)
				if (confirm("Email" + "<spring:message code='ezOrgan.t156' />"))
					document.all("CheckPolicy").checked = false; */
		}
		
		function Check_Address( pEmail )
		{
			var objList = document.all("ListEmail");
	
			for( var i = 0 ; i < objList.length ; i++ )
			{
			    if (CrossYN()) {
			        if (objList.options[i].textContent.toUpperCase() == "SMTP:" + pEmail.toUpperCase())
			            return true;
			    } else {
			        if (objList.options[i].innerText.toUpperCase() == "SMTP:" + pEmail.toUpperCase())
			            return true;
			    }
			}
	
			return false;
		}
	
		function OK_Click()
		{
		    var xmlHTTP = createXMLHttpRequest();
		    var xmlDom = createXmlDom();
	        var xmlPara = createXmlDom();
	        var objRoot, objNode, subNode;
	
		    var objNode;
		    createNodeInsert(xmlDom, objNode, "DATA");
		    createNodeAndInsertText(xmlDom, objNode, "CN", '${userId}');
	        objRoot = createNodeAndInsertText(xmlDom, objNode, "MAILLIST", "");
	
			var primarymail = "";
			for (var i=0; i<document.all("ListEmail").length; i++) {
			    if (CrossYN()) {
			        if (document.all("ListEmail").options[i].textContent.indexOf("SMTP") == 0) {
			            primarymail = document.all("ListEmail").options[i].textContent.substr(5);
			        }
					
			        if (document.all("ListEmail").options[i].getAttribute("type") === "0") {
			        	createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "MAIL", document.all("ListEmail").options[i].textContent);
			        }
			    }
			    else {
			        if (document.all("ListEmail").options[i].innerText.indexOf("SMTP") == 0) {
			            primarymail = document.all("ListEmail").options[i].innerText.substr(5);
			        }
					
			        if (document.all("ListEmail").options[i].getAttribute("type") === "0") {
			        	createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "MAIL", document.all("ListEmail").options[i].innerText);
			        }
				}
			}
	
			objRoot = createNodeAndInsertText(xmlDom, objNode, "PRIMARYMAIL", primarymail);
			
	        /* 2016-12-19 이효민 : 사용하지 않음.
	        if (document.all("CheckPolicy").checked == true)
	            createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "MSEXCHPOLICIESEXCLUDED", "");
	        else
	            createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "MSEXCHPOLICIESEXCLUDED", "{26491CFC-9E50-4857-861B-0CB8DF22B5D7}"); */
	
			xmlHTTP.open("POST","/admin/ezOrgan/saveEmail.do",false);
			xmlHTTP.send(xmlDom);
	
			if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
				alert("<spring:message code='ezOrgan.t159' />");
			} else {
				alert("<spring:message code='ezOrgan.t160' />");
				window.close();
			}
		}
	
	     function trim(str)
	     {
	        while(str && str.indexOf(" ") == 0)
	        str = str.substring(1);
	 
	        while(str && str.lastIndexOf(" ") == str.length-1)
	        str = str.substring(0, str.length-1);
	 
	        return str;
	     }
	
	</script>
</head>
<body class="popup"> 
	<form method="post"> 
		<h1><spring:message code='ezOrgan.t144' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table class="content">
			<%-- //2016-12-15 이효민 : 사용하지 않는 기능.
			<tr>
				<th>RUS<spring:message code='ezOrgan.t161' /></th> 
				<td>
					<input id="CheckPolicy" type="checkbox" name="CheckPolicy">
					Recipient Policy<spring:message code='ezOrgan.t162' />
				</td> 
			</tr>  --%>
			<tr> 
				<th><spring:message code='ezOrgan.t163' /></th> 
				<td style="padding:3px">
					${listEmailHtml}	
				</td> 
			</tr> 
		</table> 
		<div class="btnpositionNew">
			<a class="imgbtn" onClick="Add_Address()"><span><spring:message code='ezOrgan.t164' /></span></a>
			<a class="imgbtn" onClick="Delete_Address()"><span><spring:message code='ezOrgan.t165' /></span></a>
			<a class="imgbtn" style="WIDTH:auto" onClick="Set_Primary()"><span>Primary<spring:message code='ezOrgan.t166' /></span></a>
			<a class="imgbtn" onClick="OK_Click()"><span><spring:message code='ezOrgan.t167' /></span></a>
		</div>
	</form> 
</body>
</html>
