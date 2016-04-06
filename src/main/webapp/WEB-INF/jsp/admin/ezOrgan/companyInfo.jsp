<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezOrgan.t112" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var ReturnFunction;
			
			$(document).ready(function(){
				try {
		            ReturnFunction = opener.companyinfo_dialogArguments[1];
		            ParentID.value = opener.companyinfo_dialogArguments[0];
		        } catch (e) {
		            ParentID.value = window.dialogArguments;
		        }
		        
		        try {
			        var ua = navigator.userAgent;
			        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
			            KeEventControl(document.getElementById("CompanyID"));
			            KeEventControl(document.getElementById("CompanyName"));
			            KeEventControl(document.getElementById("CompanyName2"));
			        }
			    }catch (e) { }
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
				
				$.ajax({
					type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/saveCompanyInfo.do",
		        	async : false,
		        	data : {parentCn : ParentID.value, cn : CompanyID.value, displayName : CompanyName.value, displayName2 : CompanyName2.value},
		        	success : function(result){
		        		 var retVal = result;
		        		 
		        		 if (retVal == "PRE"){
		        			 alert("<spring:message code='ezOrgan.t119' />");
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
		<h1><spring:message code='ezOrgan.t120' /></h1>		
		<table class="content"> 
			<tr> 
		    	<th><spring:message code='ezOrgan.t121' /></th> 
		    	<td><input id=CompanyID style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;"></td> 
		  	</tr> 
		  	<tr> 
		  		<th><spring:message code='ezOrgan.t122' /></th> 
		    	<td> <input id=ParentID style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" readonly></td> 
		  	</tr> 
		  	<tr>
			    <th><spring:message code='ezOrgan.t123' /></th>
			    <td style="padding:0;">
			    	<table style="width:100%;-moz-box-sizing:border-box;box-sizing:border-box;">
			    		<tr class="primary">
		        			<th>${primary }</th>
		        			<td><input name="Input" id=CompanyName style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" ></td>
		      			</tr>
		      			<tr class="secondary">
		        			<th>${secondary}</th>
		        			<td><input id=CompanyName2 type="text" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;"></td> 
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