<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t208" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var OldDeptName = "";
			var OldDeptName2 = "";
			var ReturnFunction;
			var RetValue;
			var approvalFlag = "${approvalFlag}";
			
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
						dataType : "text",
						url : "/admin/ezOrgan/getEntryInfo.do",
						async : false,
						data : {cn : DeptID.value, prop : "displayName;extensionAttribute9;extensionAttribute1;extensionAttribute2;extensionAttribute3;extensionAttribute4;extensionAttribute5;extensionAttribute6;extensionAttribute8;extensionAttribute10;extensionAttribute15;extensionAttribute11", pMode : "dept" },
						success : function(result){
							xmlDom = loadXMLString(result);
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
								if(approvalFlag == 'G') {
									InsDept.checked = true;	
								}
							}
				            /* 2015-06-30 표준모듈:추가(결재문서수신여부) - KSK */
							if (SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE11") == "Y"){
								if(approvalFlag == 'G') {
							    	document.getElementById("ouDoumentReceiveYN").checked = true;
								}
							}
						}
					});
				}
			    
			    /* dhlee: Safari에서 영문 입력이 되지 않아 제거함.
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
			    */
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
	                	OpenAlertUI("<spring:message code='ezOrgan.x0003'/>");
	                    return;
	                }
	            }
				if (DeptID.value == ""){
                	OpenAlertUI("<spring:message code='ezOrgan.t210'/>");
					return;
				}				
				if (DeptID.value.length < 3){
                	OpenAlertUI("<spring:message code='ezOrgan.t211'/>");
					return;
				}				
				if (!Check_ID(DeptID.value)){
                	OpenAlertUI("<spring:message code='ezOrgan.t212'/>");
					return;
				}				
				if (DeptName.value.trim() == ""){
                	OpenAlertUI("<spring:message code='ezOrgan.t213'/>");
					return;
				}
												
				var parentCn;
				var extensionattribute8 = "0";
				/* 2017-12-29 장진혁 - 조직도에서 기본적으로 해당 부서를 수신처로 등록할 수 있게 수정 */
				var extensionattribute11 = "";
				
				if (OldDeptName == ""){
					parentCn = ParentID.value;
			    }				
				
				if(approvalFlag == 'G') {
					if (InsDept.checked){
						extensionattribute8 = "1";
					}	
				
					if (document.getElementById("ouDoumentReceiveYN").checked){
						extensionattribute11 = "Y";
					} else {
						extensionattribute11 = "N";
					}
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveDeptInfo.do",
					async : false,
					data : {parentCn: parentCn, cn: DeptID.value, displayName: DeptName.value.trim(), displayName2: DeptName2.value.trim(), extensionAttribute10: SusinSymbol.value, 
						    extensionAttribute15: SortNum.value, extensionAttribute9: Manager.value, extensionAttribute5: BalsinPerson.value, extensionAttribute6: SimpleName.value, 
						    extensionAttribute4: DocManage.value, extensionAttribute8: extensionattribute8, extensionAttribute11: extensionattribute11},
					success : function(result){						
						if (result == "PRE"){
							OpenAlertUI("<spring:message code='ezOrgan.t119'/>");
						}else if (result == "EMAIL_ERROR"){
							OpenAlertUI("<spring:message code='ezOrgan.t217'/>");//TODO: 적절한 메시지 넣기
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
						OpenAlertUI("<spring:message code='ezOrgan.t217'/>");
					}
				});
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
	    </script>
	</head>
	<body class="popup">
		<h1 id=subtitle ><spring:message code='ezOrgan.t208' /></h1>
		<div id="close">
            <ul>
                <li><span id=bt_Cancel onClick="window.close()"></span></li>
            </ul>
        </div>		
		<span style="color:red"><spring:message code='ezOrgan.t00018' /></span>
		<table class="content"> 
			<tr> 
		    	<th><spring:message code='ezOrgan.t218' /><span style="color:red"> *</span></th> 
		    	<td><input type="text" id=DeptID maxlength="20"></td> 
		  	</tr> 
		  	<tr> 
			    <th ><spring:message code='ezOrgan.t219' /></th> 
		    	<td><input type="text" id=ParentID readonly="readonly"> </td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t220' /><span style="color:red"> *</span></th> 
		    	<td style="padding:0">
		    		<table style="width:100%">
		        		<tr class="primary">
		          			<th><c:out value='${primary}'/></th>
		          			<td><input name="text" type="text" id=DeptName style="width:97%" maxlength="50"></td>
		        		</tr>
		        		<tr class="secondary">
		          			<th><c:out value='${secondary}'/></th>
		          			<td><input name="text" type="text" id=DeptName2 style="width:97%" maxlength="50"></td>
		        		</tr>
		      		</table>
		      	</td> 
		  	</tr>
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t221' /></th> 
		    	<td><input type="text" id=SimpleName style="width:97%" maxlength="50"></td> 
		  	</tr>
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t222' /></th> 
		    	<td><input type="text" id=SusinSymbol style="width:97%" maxlength="50"></td> 
		  	</tr> 
		  	<tr>
		    	<th><spring:message code='ezOrgan.t223' /></th> 
		    	<td><input type="text" id=BalsinPerson style="width:97%" maxlength="50"></td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t224' /></th> 
		    	<td><input type="text" id=DocManage style="width:97%" maxlength="50"></td>		    	 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t225' /></th> 
		    	<td><input type="text" id=Manager style="width:97%" maxlength="50"></td> 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t226' /></th> 
		    	<td><input type="text" id=SortNum style="width:97%" maxlength="10"></td> 
		  	</tr> 
		  	<c:if test="${approvalFlag == 'G'}">
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t227' /></th> 
		    	<td><input type="checkbox" id=InsDept value="checkbox"></td> 
		  	</tr> 
		  	</c:if>
		  	<c:if test="${approvalFlag == 'G'}">
		    <tr> 
		    	<th><spring:message code='ezOrgan.t990' /></th> 
		    	<td><input type="checkbox" id="ouDoumentReceiveYN" value="checkbox"></td> 
		  	</tr> 
		  	</c:if>
		</table> 
		<div class="btnpositionNew">
		    <a class="imgbtn" id=bt_OK  onClick="OK_Click()"><span><spring:message code='ezOrgan.t124' /></span></a>
		</div>
			<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>