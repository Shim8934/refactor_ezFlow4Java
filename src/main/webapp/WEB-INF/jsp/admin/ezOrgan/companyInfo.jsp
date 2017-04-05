<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t112" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var ReturnFunction;
			var isAdd = true;
			
			$(document).ready(function(){
				var RetValue;
				
			    if (CrossYN()) {
			    	try {
			        	ReturnFunction = opener.companyinfo_dialogArguments[1];
			            RetValue = opener.companyinfo_dialogArguments[0];
			        } catch(e) {}
			    } else {
			    	RetValue = window.dialogArguments;
			    }
		        
			    if (RetValue[1] == "") {
			        ParentID.value = RetValue[0];
			    } else {
			        isAdd = false;
			        subtitle.innerText = "<spring:message code='ezOrgan.x0006' />";		
			        CompanyID.value = RetValue[0];
			        CompanyID.readOnly = true;
			        CompanyName.value = RetValue[1];		
			        
			    	if (RetValue[0] == "Top") {
			    	    ParentID.readOnly = false;
			    	}

     				var xmlDom = createXmlDom();				
     				
     				$.ajax({
     					type : "POST",
     					dataType : "text",
     					url : "/admin/ezOrgan/getEntryInfo.do",
     					async : false,
     					data : {cn : CompanyID.value, prop : "displayName;mail;extensionAttribute1", pMode : "dept" },
     					success : function(result){
     						xmlDom = loadXMLString(result);
     						CompanyName.value = SelectSingleNodeValueNew(xmlDom,"DATA/DISPLAYNAME1").trim();
     						CompanyName2.value = SelectSingleNodeValueNew(xmlDom, "DATA/DISPLAYNAME2").trim();
     						
     						if (!isAdd && RetValue[0] == "Top") {
     						    var mailId = SelectSingleNodeValueNew(xmlDom, "DATA/MAIL").trim();
     						    mailId = mailId.substring(0, mailId.indexOf("@"));
     						    
     						    parentHeader.innerText = "<spring:message code='ezOrgan.t288' />";	
     						    ParentID.value = mailId;
     						} else {
     							ParentID.value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE1").trim();
     						}
     					}
     				});
			    }
			});
			
			function Check_ID(pValue){
				for(var iCnt = 0 ; iCnt < pValue.length ; iCnt++){
					if(pValue.charCodeAt(iCnt) >= 65 && pValue.charCodeAt(iCnt) <= 90){
						// A-Z
					}else if(pValue.charCodeAt(iCnt) >= 97 && pValue.charCodeAt(iCnt) <= 122){
						// a-z
					}else if(pValue.charCodeAt(iCnt) >= 48 && pValue.charCodeAt(iCnt) <= 57){
						// 0-9
					}else{
						return false;
					}
				}				
				return true;
			}

			function OK_Click(){
				if (CompanyID.value == ""){
					alert("<spring:message code='ezOrgan.t113' />");
					return;
				}
				
				if (CompanyID.value.length < 3){
					alert("<spring:message code='ezOrgan.t114' />");
					return;
				}
				
				if (!Check_ID(CompanyID.value)){
					alert("<spring:message code='ezOrgan.t115' />");
					return;
				}
							
				if (CompanyName.value == ""){
					alert("<spring:message code='ezOrgan.t116' />");
					return;
				}
				
				var parentCn;
				var mailId;
				
				if (isAdd) {
					parentCn = ParentID.value;
			    } else {
			        if (CompanyID.value == "Top") {
   						if (ParentID.value == ""){
   							alert("<spring:message code='ezOrgan.x0007' />");
   							return;
   						}
   					
   						if (ParentID.value.length < 3){
   							alert("<spring:message code='ezOrgan.x0008' />");
   							return;
   						}
   					
   						if (!Check_ID(ParentID.value)){
   							alert("<spring:message code='ezOrgan.x0009' />");
   							return;
   						}				
   						
   						mailId = ParentID.value;
			        }
			    }				
				
				$.ajax({
					type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/saveCompanyInfo.do",
		        	async : false,
		        	data : {parentCn : parentCn, cn : CompanyID.value, displayName : CompanyName.value, displayName2 : CompanyName2.value, mailId : mailId},
		        	success : function(result){
		        		 var retVal = result;
		        		 
		        		 if (retVal == "PRE"){
		        			 alert("<spring:message code='ezOrgan.t119' />");
		        		 }else if (retVal == "EMAIL_ERROR"){
		        			 alert("<spring:message code='ezOrgan.t118' />");
		        		 }else{
		        			 if(ReturnFunction != null){
		 			            ReturnFunction(CompanyID.value);
		 				    }else{
		 			            window.returnValue = CompanyID.value;
		 				    }
		 					window.close();
		        		 }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t118' />");
		        	}
				});
			}
			
			function KeEventControl(obj){
		        useragt = navigator.userAgent.toUpperCase();
		        //사파리 브라우저일 경우
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0){
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function (){
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126){
		                return false;
		            }
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32 || parseInt(window.event.keyCode) == 192){
		                return false;
		            }
		        };
		        obj.onkeypress = function () {
		            if (parseInt(window.event.keyCode) == 9) {
		                return false;
		            }
		        };
		    }		
	    </script>
	</head>
	<body class="popup">
		<h1 id="subtitle"><spring:message code='ezOrgan.t120' /></h1>		
		<table class="content"> 
			<tr> 
		    	<th><spring:message code='ezOrgan.t121' /></th> 
		    	<td><input id=CompanyID style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" maxlength="50"></td> 
		  	</tr> 
		  	<tr> 
		  		<th id="parentHeader"><spring:message code='ezOrgan.t122' /></th> 
		    	<td> <input id=ParentID style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" readonly="readonly"></td> 
		  	</tr> 
		  	<tr>
			    <th><spring:message code='ezOrgan.t123' /></th>
			    <td style="padding:0;">
			    	<table style="width:100%;-moz-box-sizing:border-box;box-sizing:border-box;">
			    		<tr class="primary">
		        			<th><c:out value='${primary}'/></th>
		        			<td><input name="Input" id=CompanyName style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" maxlength="50"></td>
		      			</tr>
		      			<tr class="secondary">
		        			<th><c:out value='${secondary}'/></th>
		        			<td><input id=CompanyName2 type="text" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" maxlength="50"></td> 
		      			</tr>
		    		</table>
		    	</td>
		    </tr> 
		</table> 
		<div class="btnposition">
		    <a class="imgbtn" onClick="OK_Click()"><span><spring:message code='ezOrgan.t124' /></span></a>
		    <a class="imgbtn" onClick="window.close()"><span><spring:message code='ezOrgan.t125' /></span></a>
		</div>
	</body>
</html>