<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezOrgan.t144' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var userId = "${userId}";
			var companyId = "${companyId}";
			var configEmailType = "${configEmailType}";

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
			            alert("Primary " + "<spring:message code='ezOrgan.t146' />");
			            return;
			        }
			        
			        if (selectedEmail.textContent.indexOf("smtp") != 0) {
			            alert("SMTP " + "<spring:message code='ezOrgan.t147' />");
			            return;
			        }
			    } else {
			        if (selectedEmail.innerText.indexOf("SMTP") == 0) {
			            alert("Primary " + "<spring:message code='ezOrgan.t146' />");
		                return;
		            }
			        
		            if (selectedEmail.innerText.indexOf("smtp") != 0) {
		                alert("SMTP " + "<spring:message code='ezOrgan.t147' />");
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
			        selectedEmail.textContent += "(Primary)";
			        
			        for (var i = 0; i < document.getElementById("ListEmail").length; i++) {
			            if (i != index && document.getElementById("ListEmail").options[i].textContent.indexOf("SMTP") == 0) {
			                document.getElementById("ListEmail").options[i].textContent = document.getElementById("ListEmail").options[i].textContent.replace("SMTP", "smtp").replace("(Primary)", "");
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
		
			function Add_Address_save_Complete() {
		        DivPopUpHidden();
		    }
			
			function Add_Address_save() {
				var heigth = window.screen.availHeight;
				var width = window.screen.availWidth;
				var left = (width - 620) / 2;
				var top = (heigth - 425) / 2;
				var szHref = "/admin/ezOrgan/configEmailAdd.do?id=" + encodeURIComponent(userId) + "&companyId=" + companyId;
				var strFeature = "status:no;dialogHeight: 155px;dialogWidth: 450px;help: no;resizable:yes";
				     
				DivPopUpShow(450, 155, szHref);
			}	
			
			function Add_Address(email) {
				//var email = prompt("<spring:message code='ezOrgan.t151' />", "");
				
				if (email == null) {
					return;
				}
				
				if (!Check_ID(email.trim())) {
					alert("<spring:message code='ezOrgan.t153' />");
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
				return "OK";
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
			    createNodeAndInsertText(xmlDom, objNode, "CN", "<c:out value='${userId}'/>");
		        objRoot = createNodeAndInsertText(xmlDom, objNode, "MAILLIST", "");
		
				var primarymail = "";
				for (var i = 0; i < document.getElementById("ListEmail").length; i++) {
					/* 2023-10-06 장혜연 : 표시한 Primary를 제거 */
				    if (CrossYN()) {
				        if (document.getElementById("ListEmail").options[i].textContent.indexOf("SMTP") == 0) {
				            primarymail = document.getElementById("ListEmail").options[i].textContent.substr(5).slice(0, -9);
							primarymail = primarymail.replace(/\s*$/,'');
				        }
				        if (document.getElementById("ListEmail").options[i].getAttribute("type") === "0") {
							if (document.getElementById("ListEmail").options[i].textContent.includes("(Primary)")) {
								createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "MAIL", document.getElementById("ListEmail").options[i].textContent.slice(0, -9).trim());
							} else {
								//2024-01-09 김대현 : node를 만들기 전에 메일에 맨뒤에 빈값이 들어가면 지워주는 작업을 한다
								var mailValue = document.getElementById("ListEmail").options[i].textContent
								mailValue = mailValue.replace(/\s*$/,'');
								createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "MAIL", mailValue);
							}
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
				objRoot = createNodeAndInsertText(xmlDom, objNode, "TYPE", configEmailType);
				objRoot = createNodeAndInsertText(xmlDom, objNode, "COMPANYID", companyId);
				
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
				<a class="imgbtn" onClick="Add_Address_save()"><span><spring:message code='ezOrgan.t164' /></span></a>
				<a class="imgbtn" onClick="Delete_Address()"><span><spring:message code='ezOrgan.t165' /></span></a>
				<a class="imgbtn" style="WIDTH:auto" onClick="Set_Primary()"><span><spring:message code='ezOrgan.t166' /></span></a>
				<a class="imgbtn" onClick="OK_Click()"><span><spring:message code='ezOrgan.t167' /></span></a>
			</div>
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>
