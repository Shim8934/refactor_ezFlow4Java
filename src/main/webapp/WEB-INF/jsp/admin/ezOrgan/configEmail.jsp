<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezOrgan.t144' /></title>
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			function Delete_Address() {
			    var index = document.getElementById("ListEmail").selectedIndex;
			    
				if (index == -1) {
					alert("<spring:message code='ezOrgan.t145' />");
					return;
				}
				
			    var selectedEmail = document.getElementById("ListEmail").options[index];
			    
			  	//2017-06-02 이효민 : original 주소, 도메인 Alias 주소 삭제 못하도록 하기 위해 추가
		    	if (selectedEmail.getAttribute("type") === "1") {
		    		alert("<spring:message code='ezOrgan.lhm1' />");
		            return;
		    	}
		    	
		    	if (selectedEmail.getAttribute("type") === "2") {
		    		alert("<spring:message code='ezOrgan.lhm3' />");
		            return;
		    	}
		    	
			    if (CrossYN()) {
			        if (selectedEmail.textContent.indexOf("SMTP") == 0) {
			            alert("Primary" + "<spring:message code='ezOrgan.t146' />");
			            return;
			        }
			        
			        if (selectedEmail.textContent.indexOf("smtp") != 0) {
			            alert("SMTP" + "<spring:message code='ezOrgan.t147' />");
			            return;
			        }
			    } else {
			        if (selectedEmail.innerText.indexOf("SMTP") == 0) {
			            alert("Primary" + "<spring:message code='ezOrgan.t146' />");
		                return;
		            }
			        
		            if (selectedEmail.innerText.indexOf("smtp") != 0) {
		                alert("SMTP" + "<spring:message code='ezOrgan.t147' />");
			            return;
			        }
			    }
			    
				document.getElementById("ListEmail").options[index] = null;
			}
		
			function Set_Primary() {
			    var index = document.getElementById("ListEmail").selectedIndex;
			    
				if (index == -1) {
					alert("Primary" + "<spring:message code='ezOrgan.t148' />");
					return;
				}
				
				var selectedEmail = document.getElementById("ListEmail").options[index];
				
			    if (CrossYN()) {
			        if (selectedEmail.textContent.indexOf("SMTP") == 0) {
			            return;
			        }
		
			        if (selectedEmail.textContent.indexOf("smtp") != 0) {
			            alert("SMTP" + "<spring:message code='ezOrgan.t149' />");
			            return;
			        }
			        
			        selectedEmail.textContent = selectedEmail.textContent.replace("smtp", "SMTP");
			        
			        for (var i = 0; i < document.getElementById("ListEmail").length; i++) {
			            if (i != index && document.getElementById("ListEmail").options[i].textContent.indexOf("SMTP") == 0) {
			                document.getElementById("ListEmail").options[i].textContent = document.getElementById("ListEmail").options[i].textContent.replace("SMTP", "smtp");
			            }
			        }
			    }
			    else {
			        if (selectedEmail.innerText.indexOf("SMTP") == 0) {
			            return;
			        }
			        
			        if (selectedEmail.innerText.indexOf("smtp") != 0) {
			            alert("SMTP" + "<spring:message code='ezOrgan.t149' />");
			            return;
			        }
			        
			        selectedEmail.innerText = selectedEmail.innerText.replace("smtp", "SMTP");
			        
		            for (var i = 0; i < document.getElementById("ListEmail").length; i++) {
		                if (i != index && document.getElementById("ListEmail").options[i].innerText.indexOf("SMTP") == 0) {
		                    document.getElementById("ListEmail").options[i].innerText = document.getElementById("ListEmail").options[i].innerText.replace("SMTP", "smtp");
		                }
		            }
			    }
			}
		
			function Add_Address() {
				var email = prompt("<spring:message code='ezOrgan.t151' />", "");
				
				if (email == null) {
					return;
				}
				
				if (!Check_ID(email.trim())) {
					alert("Email" + "<spring:message code='ezOrgan.t153' />");
					return;
				}
				
				if (duplicateCheck(email)) {
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
				
				document.getElementById("ListEmail").options.add(newOption);
				
				/* 2016-12-15 이효민 : 사용하지 않음.
				if (document.getElementById("CheckPolicy").checked == true)
					if (confirm("Email" + "<spring:message code='ezOrgan.t156' />"))
						document.getElementById("CheckPolicy").checked = false; */
			}
			
			function Check_ID(pValue) {
				var regex = /^[a-z0-9\_\-\.]{1,20}@[a-zA-Z0-9\_\-\.]+$/;
				return regex.test(pValue);
			}
			
			function duplicateCheck(pEmail) {
				var objList = document.getElementById("ListEmail");
		
				for (var i = 0; i < objList.length; i++) {
				    if (CrossYN()) {
				        if (objList.options[i].textContent.toUpperCase() == "SMTP:" + pEmail.toUpperCase()) {
				            return true;
				        }
				    } else {
				        if (objList.options[i].innerText.toUpperCase() == "SMTP:" + pEmail.toUpperCase()) {
				            return true;
				        }
				    }
				}
		
				return false;
			}
		
			function OK_Click() {
			    var xmlHTTP = createXMLHttpRequest();
			    var xmlDom = createXmlDom();
		        var xmlPara = createXmlDom();
		        var objRoot, objNode, subNode;
		
			    var objNode;
			    createNodeInsert(xmlDom, objNode, "DATA");
			    createNodeAndInsertText(xmlDom, objNode, "CN", '${userId}');
		        objRoot = createNodeAndInsertText(xmlDom, objNode, "MAILLIST", "");
		
				var primarymail = "";
				for (var i = 0; i < document.getElementById("ListEmail").length; i++) {
				    if (CrossYN()) {
				        if (document.getElementById("ListEmail").options[i].textContent.indexOf("SMTP") == 0) {
				            primarymail = document.getElementById("ListEmail").options[i].textContent.substr(5);
				        }
						
				        if (document.getElementById("ListEmail").options[i].getAttribute("type") === "0") {
				        	createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "MAIL", document.getElementById("ListEmail").options[i].textContent);
				        }
				    }
				    else {
				        if (document.getElementById("ListEmail").options[i].innerText.indexOf("SMTP") == 0) {
				            primarymail = document.getElementById("ListEmail").options[i].innerText.substr(5);
				        }
						
				        if (document.getElementById("ListEmail").options[i].getAttribute("type") === "0") {
				        	createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "MAIL", document.getElementById("ListEmail").options[i].innerText);
				        }
					}
				}
		
				objRoot = createNodeAndInsertText(xmlDom, objNode, "PRIMARYMAIL", primarymail);
				
		        /* 2016-12-19 이효민 : 사용하지 않음.
		        if (document.getElementById("CheckPolicy").checked == true)
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
