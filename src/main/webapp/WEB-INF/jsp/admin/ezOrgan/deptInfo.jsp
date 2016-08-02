<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezOrgan.t208" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var OldDeptName = "";
			var OldDeptName2 = "";
			var ReturnFunction;
			var RetValue;
			
			$(document).ready(function(){
				var RetValue;
				
			    if (CrossYN()){
			    	try {
			        	ReturnFunction = opener.deptinfo_dialogArguments[1];
			            RetValue = opener.deptinfo_dialogArguments[0];
			        }catch(e){}
			    }else{
			    	RetValue = window.dialogArguments;
			    }

			    if(RetValue[1] == ""){
					subtitle.innerText = "<spring:message code='ezOrgan.t80' />";
			        ParentID.value = RetValue[0];
				}else{
					subtitle.innerText = "<spring:message code='ezOrgan.t209' />";
			        DeptID.value = RetValue[0];
					DeptID.readOnly = true;
					DeptName.value = RetValue[1];
					OldDeptName = DeptName.value;
					SusinSymbol.focus();

					var xmlDom = createXmlDom();				
					
					$.ajax({
						type : "POST",
						dataType : "xml",
						url : "/admin/ezOrgan/getEntryInfo.do",
						async : false,
						data : {cn : DeptID.value, prop : "displayName;extensionAttribute9;extensionAttribute1;extensionAttribute2;extensionAttribute3;extensionAttribute4;extensionAttribute5;extensionAttribute6;extensionAttribute8;extensionAttribute10;extensionAttribute15;extensionAttribute11", pMode : "dept" },
						success : function(result){
							xmlDom = result;
							DeptName.value = SelectSingleNodeValueNew(xmlDom,"DATA/DISPLAYNAME1").trim();
							DeptName2.value = SelectSingleNodeValueNew(xmlDom, "DATA/DISPLAYNAME2").trim();
							OldDeptName2 = DeptName2.value.trim()
							SimpleName.value = SelectSingleNodeValueNew(xmlDom,"DATA/EXTENSIONATTRIBUTE6").trim();
							Manager.value = SelectSingleNodeValueNew(xmlDom,"DATA/EXTENSIONATTRIBUTE9").trim();
							BalsinPerson.value = SelectSingleNodeValueNew(xmlDom,"DATA/EXTENSIONATTRIBUTE5").trim();
							SusinSymbol.value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE10").trim();
							SortNum.value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE15").trim();
							ParentID.value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE1").trim();
							DocManage.value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE4").trim();
					
							if (SelectSingleNodeValueNew(xmlDom,"DATA/EXTENSIONATTRIBUTE8") == "1"){
								InsDept.checked = true;			
							}
				            /* 2015-06-30 표준모듈:추가(결재문서수신여부) - KSK */
							if (SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE11") == "Y"){
							    document.getElementById("ouDoumentReceiveYN").checked = true;
							}
						}
					});
				}
			    try{
			        var ua = navigator.userAgent;
			        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1){
						KeEventControl(document.getElementById("DeptID"));
			            KeEventControl(document.getElementById("DeptName"));
			            KeEventControl(document.getElementById("DeptName2"));
			            KeEventControl(document.getElementById("SimpleName"));
			            KeEventControl(document.getElementById("SusinSymbol"));
			            KeEventControl(document.getElementById("BalsinPerson"));
			            KeEventControl(document.getElementById("DocManage"));
			            KeEventControl(document.getElementById("Manager"));
			            KeEventControl(document.getElementById("SortNum"));
			        }
			    }
			    catch (e){ }
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
	            for (var i = 0; i < document.getElementById("DeptID").value.length; i++) {
	                if (document.getElementById("DeptID").value.charCodeAt(i) >= 65 && document.getElementById("DeptID").value.charCodeAt(i) <= 90) {
	                    alert("<spring:message code='ezOrgan.t3088' />");
	                    return;
	                }
	            }
				if (DeptID.value == ""){
					alert("<spring:message code='ezOrgan.t210' />");
					return;
				}				
				if (DeptID.value.length < 3){
					alert("<spring:message code='ezOrgan.t211' />");
					return;
				}				
				if (!Check_ID(DeptID.value)){
					alert("<spring:message code='ezOrgan.t212' />");
					return;
				}				
				if (DeptName.value == ""){
					alert("<spring:message code='ezOrgan.t213' />");
					return;
				}
				if (DeptName.value.indexOf("(") != -1 || DeptName.value.indexOf(")") != -1){
					alert("<spring:message code='ezOrgan.t214' /><,>,_,-,& <spring:message code='ezOrgan.t215' />");
					return 0;	
				}
												
				var parentCn;
				var extensionattribute8 = "0";
				var extensionattribute11 = "N";
				
				if (OldDeptName == ""){
					parentCn = ParentID.value;
			    }				
				if (InsDept.checked){
					extensionattribute8 = "1";
				}				
				if (document.getElementById("ouDoumentReceiveYN").checked){
					extensionattribute11 = "Y";
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveDeptInfo.do",
					async : false,
					data : {parentCn: parentCn, cn: DeptID.value, displayName: DeptName.value, displayName2: DeptName2.value, extensionAttribute10: SusinSymbol.value, 
						    extensionAttribute15: SortNum.value, extensionAttribute9: Manager.value, extensionAttribute5: BalsinPerson.value, extensionAttribute6: SimpleName.value, 
						    extensionAttribute4: DocManage.value, extensionAttribute8: extensionattribute8, extensionAttribute11: extensionattribute11},
					success : function(result){						
						if (result == "PRE"){
							alert("<spring:message code='ezOrgan.t119' />");
						}else{
							if (ReturnFunction != null){
					            ReturnFunction(DeptID.value);
						    }else{
					            window.returnValue = DeptID.value;
						    }
							window.close();
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t217' />");
					}
				});
			}
	    </script>
	</head>
	<body class="popup">
		<h1 id=subtitle ><spring:message code='ezOrgan.t208' /></h1>		
		<span style="color:red"><spring:message code='ezOrgan.t00018' /></span>
		<table class="content"> 
			<tr> 
		    	<th><spring:message code='ezOrgan.t218' /><span style="color:red"> *</span></th> 
		    	<td><input type="text" id=DeptID></td> 
		  	</tr> 
		  	<tr> 
			    <th ><spring:message code='ezOrgan.t219' /></th> 
		    	<td><input type="text" id=ParentID readonly ="true"> </td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t220' /><span style="color:red"> *</span></th> 
		    	<td style="padding:0">
		    		<table style="width:100%">
		        		<tr class="primary">
		          			<th><c:out value='${primary}'/></th>
		          			<td><input name="text" type="text" id=DeptName style="width:97%"></td>
		        		</tr>
		        		<tr class="secondary">
		          			<th><c:out value='${secondary}'/></th>
		          			<td><input name="text" type="text" id=DeptName2 style="width:97%"></td>
		        		</tr>
		      		</table>
		      	</td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t221' /></th> 
		    	<td><input type="text" id=SimpleName style="width:97%"></td> 
		  	</tr>
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t222' /></th> 
		    	<td><input type="text" id=SusinSymbol style="width:97%"></td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t223' /></th> 
		    	<td><input type="text" id=BalsinPerson style="width:97%"></td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t224' /></th> 
		    	<td><input type="text" id=DocManage style="width:97%"></td>		    	 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t225' /></th> 
		    	<td><input type="text" id=Manager style="width:97%"></td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t226' /></th> 
		    	<td><input type="text" id=SortNum style="width:97%" maxlength="10"></td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t227' /></th> 
		    	<td><input type="checkbox" id=InsDept value="checkbox"></td> 
		  	</tr> 
		    <tr> 
		    	<th><spring:message code='ezOrgan.t990' /></th> 
		    	<td><input type="checkbox" id="ouDoumentReceiveYN" value="checkbox"></td> 
		  	</tr> 
		</table> 
		<div class="btnposition">
		    <a class="imgbtn" id=bt_OK  onClick="OK_Click()"><span><spring:message code='ezOrgan.t124' /></span></a>
		    <a class="imgbtn" id=bt_Cancel onClick="window.close()"><span><spring:message code='ezOrgan.t125' /></span></a>
		</div>
	</body>
</html>