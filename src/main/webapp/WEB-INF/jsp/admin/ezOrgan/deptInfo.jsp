<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t208" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var OldDeptName = "";
			var OldDeptName2 = "";
			var ReturnFunction;
			var RetValue;
			var approvalFlag = "${approvalFlag}";
			var isAdd = true;
			var pageType = "${pageType}";
	        var selectDomain = "${companyMailDomain}";
			var isDocReceived = "";
			
			$(document).ready(function(){
			    if (CrossYN()){
			    	try {
			        	ReturnFunction = opener.deptinfo_dialogArguments[1];
			            RetValue = opener.deptinfo_dialogArguments[0];
			        }catch(e){console.log(e);}
			    }else{
			    	RetValue = window.dialogArguments;
			    }
			    
			    if(approvalFlag === "G") {
			    	var content = document.getElementsByClassName("content")[0];
			    	var btnSpace = document.getElementsByClassName("btnpositionNew")[0];
			    	
			    	var windowHeight = window.outerHeight - window.innerHeight;
			    	windowHeight += content.offsetTop;
			    	windowHeight += content.offsetHeight + 40;
			    	windowHeight += btnSpace.offsetHeight;
			    	
			    	window.resizeTo(window.outerWidth, windowHeight);
			    }

				document.getElementById("deptTreeFlag").checked = true;
				
			    if(RetValue[1] == ""){
					subtitle.innerText = "<spring:message code='ezOrgan.t80' />";
			        ParentID.value = RetValue[0];
					if(approvalFlag == 'G') {
				    	document.getElementById("ouDoumentReceiveYN").checked = true;
						if (RetValue[2] == "1") {
							document.getElementById("tr_upperDeptBoxYN").style.display = "";
						}
					}
				}else{
			    	isAdd = false;
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
						data : {cn : DeptID.value, prop : "displayName;extensionAttribute9;extensionAttribute1;extensionAttribute2;extensionAttribute3;extensionAttribute4;extensionAttribute5;extensionAttribute6;extensionAttribute8;extensionAttribute10;extensionAttribute15;extensionAttribute11;deptTreeFlag;useupperdeptbox;deptLevel", pMode : "dept" },
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
							
							var deptTreeFlag = SelectSingleNodeValueNew(xmlDom,"DATA/DEPTTREEFLAG").trim();
							var deptTreeFlagTag = document.getElementById("deptTreeFlag");
							deptTreeFlagTag.checked = deptTreeFlag === 'Y' ? true : false;
							
							if (SelectSingleNodeValueNew(xmlDom,"DATA/EXTENSIONATTRIBUTE8") == "1"){
								if(approvalFlag == 'G') {
									InsDept.checked = true;	
								}
							}
				            /* 2015-06-30 표준모듈:추가(결재문서수신여부) - KSK */
							isDocReceived = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE11");
							if (isDocReceived == "Y"){
								if(approvalFlag == 'G') {
							    	document.getElementById("ouDoumentReceiveYN").checked = true;
								}
							}
							if (approvalFlag == 'G' && SelectSingleNodeValueNew(xmlDom, "DATA/DEPTLEVEL") > 2) {
									document.getElementById("tr_upperDeptBoxYN").style.display = "";
								if (SelectSingleNodeValueNew(xmlDom, "DATA/USEUPPERDEPTBOX") == "Y") {
									document.getElementById("upperDeptBoxYN").checked = true;
									document.getElementById("ouDoumentReceiveYN").disabled = true;
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
			   
			   if(approvalFlag === "S") {
			   	$(".onlyUseG").css("display", "none");
			   }

				var useOrganHideFlag = "${useOrganHideFlag}";
				var treeFlagClass = document.querySelectorAll(".treeFlag");
				if ("NO" === useOrganHideFlag) {
					treeFlagClass.forEach(function (treeFlag) {
						treeFlag.style.display = "none";
					});
				}
			});
			
			function Check_ID(pValue, isAdd) {
				// 인사연동 시 부서 ID에 대문자가 포함되어 있는 경우가 있어, 부서 추가 시에만 대문자를 넣지 못하도록 함.
				var regex = /^[a-zA-Z0-9\_\-\.]+$/;

				/* 2024.09.02 부서와 회사의 경우 대문자 허용
                   if (isAdd) {
                       regex = /^[a-z0-9\_\-\.]+$/;
                   }
                */
				
				return regex.test(pValue);
			}
			
			function OK_Click() {
				if (DeptID.value.trim() == "") {
                	OpenAlertUI("<spring:message code='ezOrgan.t210'/>");
					return;
				}
				
				/* if (DeptID.value.length < 3) {
                	OpenAlertUI("<spring:message code='ezOrgan.t211'/>");
					return;
				} */
				
				if (!Check_ID(DeptID.value, isAdd)) {
                	OpenAlertUI("<spring:message code='ezOrgan.t212'/>");
					return;
				}
				
				if (pageType == "add" && $("#selectDomain").val() == "") {
					OpenAlertUI("<spring:message code='ezEmail.multiDomain.ksa17' />");
	            	return;
	            }
				
				if (DeptName.value.trim() == "") {
                	OpenAlertUI("<spring:message code='ezOrgan.t213'/>");
					return;
				}
				
				 if (DeptName.value.indexOf("\"") > -1 || DeptName.value.indexOf("\\") > -1) {
					OpenAlertUI("<spring:message code='ezOrgan.t214'/> [\"], [\\] <spring:message code='ezOrgan.t260' />");
					return;
				}
				
				if (!SortNum.value.match(/^\d*$/)) {
					OpenAlertUI("<spring:message code='ezOrgan.t226' />: <spring:message code='ezEmail.t99000066'/>");
					return;
				}
				
				var parentCn;
				var histParentCn;
				var extensionattribute8 = "0";
				/* 2017-12-29 장진혁 - 조직도에서 기본적으로 해당 부서를 수신처로 등록할 수 있게 수정 */
				var extensionattribute11 = "";
				/* 2024-07-01 양지혜 - 조직도 > 부서정보 수정 > 상위부서문서함 사용여부 */
				var useUpperDeptBox = "";
				
				if (OldDeptName == ""){
					parentCn = ParentID.value;
			    } else {
			    	histParentCn = ParentID.value;
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

					if (document.getElementById("upperDeptBoxYN").checked){
						useUpperDeptBox = "Y";
					} else {
						useUpperDeptBox = "N";
					}
				}

				// var deptHide = document.getElementById("deptHide");
				// var checkDeptHide = deptHide.checked;
				// var deptHideValue = "N";
				// if (checkDeptHide) {
				// 	deptHideValue = "Y";
				// }
				var deptTreeFlag = document.getElementById("deptTreeFlag");
				var deptTreeFlagValue = deptTreeFlag.checked ? 'Y' : 'N';
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveDeptInfo.do",
					async : false,
					data : {parentCn: parentCn, cn: DeptID.value, displayName: DeptName.value.trim(), displayName2: DeptName2.value.trim(), extensionAttribute10: SusinSymbol.value, 
						    extensionAttribute15: SortNum.value, extensionAttribute9: Manager.value, extensionAttribute5: BalsinPerson.value, extensionAttribute6: SimpleName.value, 
						    extensionAttribute4: DocManage.value, extensionAttribute8: extensionattribute8, extensionAttribute11: extensionattribute11, manualFlag: "Y",
						    selectDomain: selectDomain, histParentCn: histParentCn, deptTreeFlag: deptTreeFlagValue, useUpperDeptBox: useUpperDeptBox},
					success : function(result){						
						if (result == "PRE"){
							OpenAlertUI("<spring:message code='ezOrgan.t119'/>");
						}else if (result == "EMAIL_ERROR"){
							OpenAlertUI("<spring:message code='ezOrgan.t217'/>");
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
		    
		    var selectperson_cross_dialogArguments = new Array();
	        
	        function selectDeptMaster() {
	            var type = "selDeptMaster";
	            selectperson_cross_dialogArguments[1] = selectDeptMasterComplete;
	            
	            var OpenWin = window.open("/ezPersonal/selectPerson.do?type=" + type, "selDeptMaster", GetOpenWindowfeature(860, 535));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	
	        function selectDeptMasterComplete(rtnValue) {
	        	if (typeof (rtnValue) != "undefined") {
	            	document.getElementById("Manager").value = rtnValue;
	        	}
	        }
		    
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		    
		    $(document).on("change", "#selectDomain", function() {
	        	selectDomain = $(this).val();
	        });
			
			function disableDocReceive() {
				if (document.getElementById("upperDeptBoxYN").checked) {
					document.getElementById("ouDoumentReceiveYN").checked = false;
					document.getElementById("ouDoumentReceiveYN").disabled = true;
				} else {
					document.getElementById("ouDoumentReceiveYN").checked = (isDocReceived === "Y");
					document.getElementById("ouDoumentReceiveYN").disabled = false;
				}
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
		    	<th><spring:message code='ezOrgan.pyy1' /><span style="color:red"> *</span></th> 
		    	<td>
		    		<input type="text" id=DeptID maxlength="20"  style="width: 130px; ">
			    	<c:if test="${pageType eq 'add' }">
				    	<span style="font-weight: bold; ">@</span>
						<select id="selectDomain" style="width: 150px; ">
							<c:forEach var="item" items="${domainList}">
								<option value="<c:out value='${item}'/>" ${item eq companyMailDomain ? 'selected' : ''}><c:out value='${item}'/></option>
							</c:forEach>
						</select>
					</c:if>
		    	</td> 
		  	</tr> 
		  	<tr> 
			    <th ><spring:message code='ezOrgan.t219' /></th> 
		    	<td><input type="text" id=ParentID readonly="readonly"> </td> 
		  	</tr> 
		  	<c:if test="${pageType eq 'modify' }">
			  	<tr>
			  		<th><spring:message code='main.t78' /></th>
			  		<td>${deptMail}</td>
			  	</tr>
		  	</c:if>
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
		  	<tr class="onlyUseG"> 
		    	<th><spring:message code='ezOrgan.t221' /></th> 
		    	<td><input type="text" id=SimpleName style="width:97%" maxlength="50"></td> 
		  	</tr>
		  	<tr class="onlyUseG"> 
		    	<th><spring:message code='ezOrgan.t222' /></th> 
		    	<td><input type="text" id=SusinSymbol style="width:97%" maxlength="50"></td> 
		  	</tr> 
		  	<tr class="onlyUseG">
		    	<th><spring:message code='ezOrgan.t223' /></th> 
		    	<td><input type="text" id=BalsinPerson style="width:97%" maxlength="50"></td> 
		  	</tr> 
		  	<tr class="onlyUseG"> 
		    	<th><spring:message code='ezOrgan.t224' /></th> 
		    	<td><input type="text" id=DocManage style="width:97%" maxlength="50"></td>		    	 
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code='ezOrgan.t225' /></th> 
		    	<td>
		    		<input type="text" id=Manager style="width:75%" maxlength="50">
		    		<a id="ReceiverSelect" class="imgbtn imgbck" style="width:16%; padding-left: 10px;" onClick="selectDeptMaster()"><span style="width:80%;text-align:center;"><spring:message code='ezEmail.t488' /></span></a>
		    	</td> 
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
			<tr id="tr_upperDeptBoxYN" style="display: none">
				<th><spring:message code='ezOrgan.jhy001' /></th>
				<td><input type="checkbox" id="upperDeptBoxYN" value="checkbox" onclick="disableDocReceive()"></td>
			</tr>
		  	</c:if>
			<tr class="treeFlag">
				<th ><spring:message code='ezOrgan.kdh07' /></th>
				<td><input type="checkbox" id=deptTreeFlag></td>
			</tr>
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