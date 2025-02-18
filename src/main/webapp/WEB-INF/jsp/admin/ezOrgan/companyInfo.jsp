<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t112" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var ReturnFunction;
			var isAdd = true;
			var pageType = "${pageType}";
			
			$(document).ready(function(){
				var RetValue;
				
			    if (CrossYN()) {
			    	try {
			        	ReturnFunction = opener.companyinfo_dialogArguments[1];
			            RetValue = opener.companyinfo_dialogArguments[0];
			        } catch(e) {console.log(e);}
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
		     				getCompanyInfo();
     					}
     				});
			    }
			});
			
			function Check_ID(pValue, isAdd) {
				// 인사연동 시 회사 ID에 대문자가 포함되어 있는 경우가 있어, 회사 추가 시에만 대문자를 넣지 못하도록 함.
				var regex = /^[a-zA-Z0-9\_\-\.]+$/;

			/* 2024.09.02 부서와 회사의 경우 대문자 허용
               if (isAdd) {
                   regex = /^[a-z0-9\_\-\.]+$/;
               }
			*/
               
               return regex.test(pValue);
           }

           function OK_Click(){
               if (CompanyID.value == "") {
                   OpenAlertUI("<spring:message code='ezOrgan.t113'/>");
					return;
				}

				/* ID 길이 제한 체크 제거
				if (CompanyID.value.length < 3) {
					OpenAlertUI("<spring:message code='ezOrgan.t114'/>");
					return;
				}
				*/
				
				if (!Check_ID(CompanyID.value, isAdd)) {
					OpenAlertUI("<spring:message code='ezOrgan.t115'/>");
					return;
				}
					
				var selectDomain = $("#selectDomain").val();
				if (pageType == "add" && selectDomain == "") {
					OpenAlertUI("도메인이 지정되어 있지 않습니다. \n도메인을 설정해 주세요.");
	            	return;
	            }
				
				if (CompanyName.value == "") {
					OpenAlertUI("<spring:message code='ezOrgan.t116'/>");
					return;
				}
				
				if (CompanyName.value.indexOf("\"") > -1 || CompanyName.value.indexOf("'") > -1 || CompanyName.value.indexOf("\\") > -1) {
					OpenAlertUI("<spring:message code='ezOrgan.t215'/> [\"], ['] , [\\] <spring:message code='ezOrgan.t260' />");
					return;
				}
				
				if (operatorID.value != "" && operatorID.value.indexOf("@") > -1) {
					OpenAlertUI("<spring:message code='ezOrgan.t267'/>");
					return;
				}
				
				var parentCn;
				var mailId;
				
				if (isAdd) {
					parentCn = ParentID.value;
			    } else {
			        if (CompanyID.value == "Top") {
   						if (ParentID.value == ""){
   							OpenAlertUI("<spring:message code='ezOrgan.x0007'/>");
   							return;
   						}
   					
   						if (ParentID.value.length < 3){
   							OpenAlertUI("<spring:message code='ezOrgan.x0008'/>");
   							return;
   						}
   					
   						if (!Check_ID(ParentID.value)){
   							OpenAlertUI("<spring:message code='ezOrgan.x0009'/>");
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
		        	data : {parentCn : parentCn, cn : CompanyID.value, displayName : CompanyName.value, displayName2 : CompanyName2.value, mailId : mailId, operatorId : operatorID.value, manualFlag : "Y",
		        		selectDomain : selectDomain},
		        	success : function(result){
		        		 var retVal = result;
		        		 
		        		 if (retVal == "PRE"){
		        			 OpenAlertUI("<spring:message code='ezOrgan.t119'/>");
		        		 }else if (retVal == "EMAIL_ERROR"){
		        			 OpenAlertUI("<spring:message code='ezOrgan.t118'/>");
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
	        			 OpenAlertUI("<spring:message code='ezOrgan.t118'/>");
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
			
			var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";

		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(300, 205, url);
		        }
		    }
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		    
		    function getCompanyInfo() {
		    	$.ajax({
						type : "POST",
						dataType : "text",
						url : "/admin/ezOrgan/getComanyConfig.do",
						async : false,
						data : {cn : CompanyID.value},
						success : function(result) {
							if (result != "") {
	    						operatorID.value = result;
							}
						}
					});	
		    }
		    
	    </script>
	</head>
	<body class="popup">
		<h1 id="subtitle"><spring:message code='ezOrgan.t120' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table class="content"> 
			<tr> 
		    	<th><spring:message code='ezOrgan.t121' /><span style="color:red"> *</span></th> 
		    	<td>
		    		<c:set var="companyIdWidth" value="${pageType eq 'add' ? 'width:42%;' : 'width:100%;' }" />
		    		<input id="CompanyID" style="<c:out value="${companyIdWidth }" /> -moz-box-sizing:border-box;box-sizing:border-box;" maxlength="20">
					<c:if test="${pageType eq 'add' }">
				    	<span style="font-weight: bold; ">@</span>
						<select id="selectDomain" style="width: 48%; ">
							<c:forEach var="item" items="${domainList}">
								<option value="<c:out value='${item}'/>" ${item eq tenantDomain ? 'selected' : ''}><c:out value='${item}'/></option>
							</c:forEach>
						</select>
					</c:if>
		    	</td> 
		  	</tr> 
		  	<c:if test="${pageType eq 'modify' }">
			  	<tr>
			  		<th><spring:message code='main.t78' /></th>
			  		<td>${compMail}</td>
			  	</tr>
		  	</c:if>
		  	<tr> 
		  		<th id="parentHeader"><spring:message code='ezOrgan.t122' /></th> 
		    	<td> <input id="ParentID" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" readonly="readonly"></td> 
		  	</tr> 
		  	<tr> 
		  		<th><spring:message code='ezEmail.0hun02' /></th> 
		    	<td> <input id="operatorID" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" maxlength="50"></td> 
		  	</tr> 
		  	<tr>
			    <th><spring:message code='ezOrgan.t123' /><span style="color:red"> *</span></th>
			    <td style="padding:0;">
			    	<table style="width:100%;-moz-box-sizing:border-box;box-sizing:border-box;">
			    		<tr class="primary">
		        			<th><c:out value='${primary}'/></th>
		        			<td><input name="Input" id="CompanyName" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" maxlength="50"></td>
		      			</tr>
		      			<tr class="secondary">
		        			<th><c:out value='${secondary}'/></th>
		        			<td><input id="CompanyName2" type="text" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" maxlength="50"></td> 
		      			</tr>
		    		</table>
		    	</td>
		    </tr> 
		</table> 
		<div class="btnpositionNew">
		    <a class="imgbtn" onClick="OK_Click()"><span><spring:message code='ezOrgan.t124' /></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>