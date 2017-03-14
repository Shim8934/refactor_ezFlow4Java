<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${title}' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var labelcolor = "gray";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var gRtnVal = "FALSE";
	        var gState, TaskCode, PCode, companyID, pLevel;
	        var RetValue;
	        var ReturnFunction;
	        var approvalFlag = "<c:out value = '${approvalFlag}' />";
	        
	        $(document).ready(function(){
	            var ua = navigator.userAgent;
	            
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                KeEventControl(document.getElementById("tbSubCode"));
	                KeEventControl(document.getElementById("tbTaskCode"));
	                KeEventControl(document.getElementById("tbTaskName"));
	                KeEventControl(document.getElementById("tbTaskName2"));
	                KeEventControl(document.getElementById("tbDispTransTime"));
	                KeEventControl(document.getElementById("tbList1"));
	                KeEventControl(document.getElementById("tbList2"));
	                KeEventControl(document.getElementById("tbList3"));
	                KeEventControl(document.getElementById("tbTaskDesc"));
	                KeEventControl(document.getElementById("tbKPReason"));
	            }

	            try {
	                RetValue = parent.taskcodeinsert_cross_dialogArguments[0];
	                ReturnFunction = parent.taskcodeinsert_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.taskcodeinsert_cross_dialogArguments[0];
	                    ReturnFunction = opener.taskcodeinsert_cross_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }

	            if (approvalFlag == 'S') {
	            	document.getElementsByName("isAllDept")[1].checked = true;
	            	$('.approvalFlagG').hide();
	            } else {
	            	$('.approvalFlagS').hide();
	            }
	            
	            if (RetValue[0] == "I") {
	                gState = "I";
	                TaskCode = RetValue[1];
	                PCode = RetValue[2];
	                companyID = RetValue[3];
	                pLevel = RetValue[4];

	                InitCode();
	            } else {
	                gState = "U";
	                TaskCode = RetValue[1];
	                PCode = RetValue[2];
	                companyID = RetValue[3];
	                pLevel = RetValue[4];
	                document.getElementById("tbTaskCode").disabled = true;
	                
	                if (approvalFlag == 'G') {
		                document.getElementById("btnDuplicate").disabled = true;
		                document.getElementsByName("isAllDept")[0].disabled = true;
		                document.getElementsByName("isAllDept")[1].disabled = true;
		                if (TaskCode.length == 8) {
		                    if (TaskCode.substring(0, 2) == "ZZ" || TaskCode == "99999999") {
		                        document.getElementsByName("isAllDept")[1].checked = true;
		                    }
		                }
	                }

	                InitCode();
	                InitTaskInfo();
	            }

	            rdoDisplayFlag_onclick("");
	            rdoSpecialFlag_onclick("");

	            document.getElementById("tbSubCode").value = PCode;
	            document.getElementById("tbTaskCode").value = TaskCode;
	            document.getElementById("tbSubCode").disabled = true;
	        });
	        
	        function InitCode() {
	        	$.ajax({
	        		type : "POST",
		        	url : "/ezApprovalG/getCodeList.do",
		        	async : false,
		        	data : {companyID : companyID},
		        	dataType : "text",
		        	success : function(result){
		        		result = loadXMLString(result);
		        		
		        		var nodesKeepPeriod = SelectNodes(result, "CODELIST/KEEPINGPERIOD/CODE");
			            InitCodeSelectBox(nodesKeepPeriod, selKeepPeriod);

			            var nodesKeepMethod = SelectNodes(result, "CODELIST/KEEPINGMETHOD/CODE");
			            InitCodeSelectBox(nodesKeepMethod, selKeepMethod);

			            var nodesKeepPlace = SelectNodes(result, "CODELIST/KEEPINGPLACE/CODE");
			            InitCodeSelectBox(nodesKeepPlace, selKeepPlace);
			            
			            var nodeSecurityLevel = SelectNodes(result, "CODELIST/SECURITYLEVEL/CODE");
			            InitCodeSelectBox(nodeSecurityLevel, securityLevel);
		        	}
	        	});
	        }
	        
	        function InitTaskInfo() {
	            var TaskXml = GetTaskInfo();
	            
	            if (SelectSingleNodeValue(TaskXml, "RESULT") == "FALSE") {
	                OpenAlertUI("<spring:message code = 'ezApprovalG.t653' />");
	        	} else if (SelectSingleNodeValue(TaskXml, "RESULT") == "NOITEM") {
	            	OpenAlertUI("<spring:message code = 'ezApprovalG.t654' />");
	        	} else {
	            	document.getElementById("tbTaskName").value = SelectSingleNodeValue(TaskXml.documentElement, "TASKNAME");
	            	document.getElementById("tbTaskName2").value = SelectSingleNodeValue(TaskXml.documentElement, "TASKNAME2");
	            	document.getElementById("tbTaskDesc").value = SelectSingleNodeValue(TaskXml.documentElement, "DESCRIPTION");

	            	SelectOption(selKeepPeriod, SelectSingleNodeValue(TaskXml.documentElement, "KEEPINGPERIOD"));

	            	document.getElementById("tbKPReason").value = SelectSingleNodeValue(TaskXml.documentElement, "KPREASON");

	            	SelectOption(selKeepMethod, SelectSingleNodeValue(TaskXml.documentElement, "KEEPINGMETHOD"));
	            	SelectOption(selKeepPlace, SelectSingleNodeValue(TaskXml.documentElement, "KEEPINGPLACE"));
	            	SelectOption(securityLevel, SelectSingleNodeValue(TaskXml.documentElement, "ITEMSECURITY"));
	            	SelectOption(isPublic, SelectSingleNodeValue(TaskXml.documentElement, "ISPUBLIC"));

	            	var DispFlag = SelectSingleNodeValue(TaskXml.documentElement, "EXDISPLAYFREQUENCY");
	            	
	            	if (DispFlag == "2") {
		                document.getElementsByName("rdoDisplayFlag")[0].checked = true;
	            	} else {
	                	document.getElementsByName("rdoDisplayFlag")[1].checked = true;
	            	}

		            document.getElementById("tbDispTransTime").value = SelectSingleNodeValue(TaskXml.documentElement, "DISPLAYRECTRASTIME");
	
		            SelectOption(selExFrequency, SelectSingleNodeValue(TaskXml.documentElement, "DISPFREQ"));
		            SelectOption(selDisplayUsage, SelectSingleNodeValue(TaskXml.documentElement, "DISPLAYUSAGE"));
	
		            var SCFlag = SelectSingleNodeValue(TaskXml.documentElement, "SPECIALCATALOGFLAG");
		            if (SCFlag == "1") {
		                document.getElementsByName("rdoSpecialFlag")[1].checked = true;
		            } else if (SCFlag == "2") {
		                document.getElementsByName("rdoSpecialFlag")[2].checked = true;
		            } else {
		                document.getElementsByName("rdoSpecialFlag")[0].checked = true;
		            } 
		            
		            document.getElementById("tbList1").value = SelectSingleNodeValue(TaskXml.documentElement, "SC1");
		            document.getElementById("tbList2").value = SelectSingleNodeValue(TaskXml.documentElement, "SC2");
		            document.getElementById("tbList3").value = SelectSingleNodeValue(TaskXml.documentElement, "SC3");
		        }
			}
	
			function GetTaskInfo() {
				var tempRet = "";
				
				$.ajax({
					type : "POST",
					url : "/admin/ezApprovalG/getTaskInfo.do",
					async : false,
					data : {taskCode : TaskCode,
							deptCode : "",
							companyID : companyID,
							level : pLevel
							},
					success : function (result) {
						tempRet = loadXMLString(result);
					}
				});
				
				return tempRet;
			}
			
			function rdoDisplayFlag_onclick(szValue) {
			    if (document.getElementsByName("rdoDisplayFlag")[0].checked) {
			        document.getElementById("tbDispTransTime").value = "";
			        document.getElementById("tbDispTransTime").disabled = true;
			    } else {
			        document.getElementById("tbDispTransTime").disabled = false;
			    }
			}
			
			function rdoSpecialFlag_onclick(szValue) {
			    if (document.getElementsByName("rdoSpecialFlag")[0].checked) {
			        document.getElementById("tbList1").value = "";
			        document.getElementById("tbList2").value = "";
			        document.getElementById("tbList3").value = "";
		
			        document.getElementById("tbList1").disabled = true;
			        document.getElementById("tbList2").disabled = true;
			        document.getElementById("tbList3").disabled = true;
			    } else {
			        document.getElementById("tbList1").disabled = false;
			        document.getElementById("tbList2").disabled = false;
			        document.getElementById("tbList3").disabled = false;
			    }
			}
			
			function trim(parm_str) {
			    if (parm_str == "") {
			        return "";
			    } else {
			        return rtrim(ltrim(parm_str));
			    }
			}
			
			function ltrim(parm_str) {
			    var str_temp = parm_str;
			    while (str_temp.length != 0) {
			        if (str_temp.substring(0, 1) == " ") {
			            str_temp = str_temp.substring(1, str_temp.length);
			        } else {
			            return str_temp;
			        }
			    }
			    return str_temp;
			}
			
			function rtrim(parm_str) {
			    var str_temp = parm_str;
			    while (str_temp.length != 0) {
			        int_last_blnk_pos = str_temp.lastIndexOf(" ");
			        
			        if ((str_temp.length - 1) == int_last_blnk_pos) {
			            str_temp = str_temp.substring(0, str_temp.length - 1);
			        } else {
			            return str_temp;
			        }
			    }
			    return str_temp;
			}
			
			var ezapralert_cross_dialogArguments = new Array();
			function OpenAlertUI(pAlertContent) {
			    ezapralert_cross_dialogArguments[0] = pAlertContent;
			    ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
			    var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
			    try { ezAPRALERT_Cross.focus(); } catch (e) { }
			}
			
			function OpenAlertUI_Complete() {
			}
			
			function GetTaskCodeDuplicate() {
			    var tempCode = trim(document.getElementById("tbTaskCode").value);
			    
			    if (tempCode == "") {
			        return "NULL";
			    } else if (tempCode.length != 8) {
			        return "LENGTH";
			    } else if (document.getElementsByName("isAllDept")[0].checked && tempCode.substring(0, 2).toUpperCase() == "ZZ") {
			        return "UNZZ";
			    } else if (document.getElementsByName("isAllDept")[1].checked && tempCode.substring(0, 2).toUpperCase() != "ZZ" && tempCode != "99999999") {
			        return "ZZ";
			    }
			    
			    var tempRet = "";
			    
			    $.ajax({
			    	type : "POST",
			    	url : "/admin/ezApprovalG/getTaskCodeDuplicate.do",
			    	async : false,
			    	data :{sCateCode : tempCode, companyID : companyID},
			    	success : function(result) {
			    		tempRet = result;
			    	}
			    });
		
			    return tempRet;
			}
			
			function btnDuplicate_onclick() {
			    var tempValue = GetTaskCodeDuplicate();
			    
			    if (tempValue == "NULL") {
			        OpenAlertUI("<spring:message code = 'ezApprovalG.t736' />");
			    } else if (tempValue == "TRUE") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t737' />");
			    } else if (tempValue == "FALSE") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t738' />");
			    } else if (tempValue == "LENGTH") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t739' />");
			    } else if (tempValue == "UNZZ") {
		            OpenAlertUI("ZZ<spring:message code = 'ezApprovalG.t740' />");
			    } else if (tempValue == "ZZ") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t741' />");
			    } else {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t723' />");
			    }
			}
			
		    function btnDuplicateHidden_onclick() {
		        var tempValue = GetTaskCodeDuplicate();
		        
		        if (tempValue == "NULL") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t736' />");
		            return false;
		        } else if (tempValue == "TRUE") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t737' />");
		            return false;
		        } else if (tempValue == "FALSE") {
		            return true;
		        } else if (tempValue == "LENGTH") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t742' />");
		            return false;
		        } else if (tempValue == "UNZZ") {
		            OpenAlertUI("ZZ<spring:message code = 'ezApprovalG.t740' />");
		            return false;
		        } else if (tempValue == "ZZ") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t741' />");
		            return false;
		        } else {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t723' />");
		            return false;
		        }
		    }
		    
		    function btnOk_onclick() {
		        var tempCode = trim(document.getElementById("tbTaskCode").value);
		        if (tempCode == "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t743' />");
		            return;
		        } else if (tempCode.length != 8) {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t744' />");
		            return;
		        }
		        
		        if (trim(document.getElementById("tbTaskName").value) == "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t745' />");
		            return;
		        }

		        if (approvalFlag == 'G' && trim(document.getElementById("tbTaskDesc").value) == "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t746' />");
		            return;
		        }
	
		        if (approvalFlag == 'G' && trim(document.getElementById("tbKPReason").value) == "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t747' />");
		            return;
		        }
	
		        if (approvalFlag == 'G' && trim(document.getElementById("tbList1").value) == "" && (trim(document.getElementById("tbList2").value) != "" || trim(document.getElementById("tbList3").value) != "")) {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t748' />");
		            return;
		        }
	
		        if (approvalFlag == 'G' && trim(document.getElementById("tbList2").value) == "" && trim(document.getElementById("tbList3").value) != "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t749' />");
		            return;
		        }
	
		        if (gState == "I") {
		            if (!btnDuplicateHidden_onclick()) {
		                return;
		            }
		        }
		        
		        var gRtnVal = UpdateCode();
		        if (gRtnVal == "TRUE") {
		            if (ReturnFunction != null) {
		                ReturnFunction(gRtnVal);
		            } else {
		                window.returnValue = gRtnVal;
		            }
		            window.close();
		        } else {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t750' />");
		        }
		    }
		    
		    function btncancel_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction("FALSE");
		        }
		        window.close();
		    }
		    
		    function UpdateCode() {
				var pDisplayFlag;
		        if (document.getElementsByName("rdoDisplayFlag")[0].checked) {
		            pDisplayFlag = "2";
		        } else {
		            pDisplayFlag = "1";
		        }
		        
		        var pSpecialFlag;
		        if (document.getElementsByName("rdoSpecialFlag")[0].checked) {
		        	pSpecialFlag = "0";
		        } else if (document.getElementsByName("rdoSpecialFlag")[1].checked) {
		            pSpecialFlag = "1";
		        } else if (document.getElementsByName("rdoSpecialFlag")[2].checked) {
		        	pSpecialFlag = "2";
		        }
		        
		    	var tempRet = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/setTaskCode.do",
		    		async : false,
		    		data : {taskCode : document.getElementById("tbTaskCode").value,
		    				taskName : document.getElementById("tbTaskName").value,
		    				taskName2 : document.getElementById("tbTaskName2").value,
		    				keepingPeriod : document.getElementById("selKeepPeriod").value,
		    				kpReason : document.getElementById("tbKPReason").value,
		    				keepingMethod : document.getElementById("selKeepMethod").value,
		    				keepingPlace : document.getElementById("selKeepPlace").value,
		    				displayRecFlag : pDisplayFlag,
		    				displayRecTransTime : document.getElementById("tbDispTransTime").value,
		    				exDisplayFrequency : document.getElementById("selExFrequency").value,
		    				specialCatalogFlag : pSpecialFlag,
		    				sc1 : document.getElementById("tbList1").value,
		    				sc2 : document.getElementById("tbList2").value,
		    				sc3 : document.getElementById("tbList3").value,
		    				displayUsage : document.getElementById("selDisplayUsage").value,
		    				description : document.getElementById("tbTaskDesc").value,
		    				subCategoryCode : document.getElementById("tbSubCode").value,
		    				itemSecurity : document.getElementById("securityLevel").value,
		    				isPublic : document.getElementById("isPublic").value,
		    				companyID : companyID,
		    				level : pLevel
		    				},
		    		success : function (result) {
		    			tempRet = result;
		    		}
		    	});
		    	
		    	return tempRet;
		    }
	
		    var selecttaskcategory_cross_dialogArguments = new Array();
		    function btnSelPCode_onclick() {
		        var para = new Array();
		        para[0] = "3";
		        para[1] = document.getElementById("tbSubCode").value;
		        para[2] = companyID;
	
		        if (CrossYN()) {
		            selecttaskcategory_cross_dialogArguments[0] = para;
		            selecttaskcategory_cross_dialogArguments[1] = btnSelPCode_onclick_Complete;
	
		            var SelectTaskCategory_Cross = window.open("/admin/ezApprovalG/selectTaskCategory.do", "SelectTaskCategory", GetOpenWindowfeature(340, 480));
		            try { SelectTaskCategory_Cross.focus(); } catch (e) { }
		        } else {
		            var url = "/admin/ezApprovalG/selectTaskCategory.do";
		            var retVal = window.showModalDialog(url, para, "dialogWidth:340px;dialogHeight:480px;status:no;help:no;scroll:no;edge:sunken");
	
		            if (retVal != undefined && retVal != "cancel" && retVal.length == 8) {
		                document.getElementById("tbSubCode").value = retVal;
		            }
		        }
		    }

		    //2016-07-18 이효진 추가.
		    function btnSelPCode_onclick_Complete(retValue){
		    	document.getElementById("tbSubCode").value = retValue;
		    }
	
		    window.oncontextmenu = function () {
		        return false;
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
	    <h1><c:out value = '${title}' /></h1>
	    <span style="color:red"><spring:message code = 'ezApprovalG.t00011' /></span>
	    <table class="content">
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t751' /></th>
	            <td>
	                <input type="radio" name="isAllDept" value="0" checked>
	                <spring:message code = 'ezApprovalG.t752' /><br />
	                <input type="radio" name="isAllDept" value="1">
	                <spring:message code = 'ezApprovalG.t753' />
				</td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t733' /></th>
	            <td>
	                <input type="text" id="tbSubCode" name="tbSubCode" style="WIDTH: 200px" readonly="readonly">
	                <a class="imgbtn"><span id="btnSelPCode" onclick="return btnSelPCode_onclick()"><spring:message code = 'ezApprovalG.t690' /></span></a>
	            </td>
	        </tr>
	        <tr>
	        	<c:choose>
	        		<c:when test="${approvalFlag == 'S'}">
	        			<th><spring:message code = 'ezApprovalG.t729' /> <span style="color:red">*</span></th>
	        			<td><input type="text" id="tbTaskCode" name="tbTaskCode" style="WIDTH: 100%" maxlength="8"></td>
	        		</c:when>
	        		<c:otherwise>
	        			<th><spring:message code = 'ezApprovalG.t576' /><br>(8<spring:message code = 'ezApprovalG.t754' /> <span style="color:red">*</span></th>
	        			<td>
			                <input type="text" id="tbTaskCode" name="tbTaskCode" style="WIDTH: 200px" maxlength="8">
			                <a class="imgbtn"><span id="btnDuplicate" onclick="return btnDuplicate_onclick()"><spring:message code = 'ezApprovalG.t730' /></span></a>
			            </td>
	        		</c:otherwise>
	        	</c:choose>
	        </tr>
	        <tr>
	        	<c:choose>
	        		<c:when test="${approvalFlag == 'S' }">
	        			<th><spring:message code = 'ezApprovalG.t1641' />(<spring:message code = 'ezApprovalG.t1764' />) <span style="color:red">*</span></th>
						<td><input type="text" id="tbTaskName" name="tbTaskName" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="20"></td>
	        		</c:when>
	        		<c:otherwise>
	        			<th><spring:message code = 'ezApprovalG.t597' />(<spring:message code = 'ezApprovalG.t1764' />) <span style="color:red">*</span></th>
	            		<td><input type="text" id="tbTaskName" name="tbTaskName" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="20"></td>
	        		</c:otherwise>
	        	</c:choose>
	        </tr>
	        <tr>
	        	<c:choose>
	        		<c:when test="${approvalFlag == 'S' }">
	        			<th><spring:message code = 'ezApprovalG.t1641' />(<spring:message code = 'ezApprovalG.t1765' />) <span style="color:red">*</span></th>
            			<td><input type="text" id="tbTaskName2" name="tbTaskName2" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="200"></td>
	        		</c:when>
	        		<c:otherwise>
	        			<th><spring:message code = 'ezApprovalG.t597' />(<spring:message code = 'ezApprovalG.t1765' />) <span style="color:red">*</span></th>
	            		<td><input type="text" id="tbTaskName2" name="tbTaskName2" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="200"></td> 
	        		</c:otherwise>
	        	</c:choose>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t755' /> <span style="color:red">*</span></th>
	            <td><textarea style="WIDTH: 100%; HEIGHT: 60px; box-sizing: border-box; -moz-box-sizing: border-box;" id="tbTaskDesc" name="tbTaskDesc" maxlength="300"></textarea></td>
	        </tr>
	        <tr class = 'approvalFlagS'>
	        	<th><spring:message code = 'ezApprovalG.t118' /></th>
	        	<td><select id="securityLevel" style="WIDTH: 100%"></select></td> 
	        </tr>
	        <tr>
	        	<c:choose>
	        		<c:when test="${approvalFlag == 'S' }">
			            <th><spring:message code = 'ezApprovalG.t1198' /> <span style="color:red">*</span></th>
			            <td><select id="selKeepPeriod" style="WIDTH: 100%"></select></td>
	        		</c:when>
	        		<c:otherwise>
			            <th><spring:message code = 'ezApprovalG.t117' /> <span style="color:red">*</span></th>
			            <td><select id="selKeepPeriod" style="WIDTH: 100%"></select></td>
	        		</c:otherwise>
	        	</c:choose>
	        </tr>
	        <tr class = 'approvalFlagS'>
	        	<th><spring:message code = 'ezApprovalG.t109' /> *</th>
	        	<td>
		        	<select id="isPublic" style="width: 100%">
	                    <option value="Y" id="Y"><spring:message code='ezApprovalG.t47'/></option>
	                    <option value="N" id="N"><spring:message code='ezApprovalG.t46'/></option>
	                </select>
				</td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t117' /> <spring:message code = 'ezApprovalG.t756' /> <span style="color:red">*</span></th>
	            <td><textarea style="WIDTH: 100%; HEIGHT: 60px; box-sizing: border-box; -moz-box-sizing: border-box;" id="tbKPReason" name="tbKPReason" maxlength="200"></textarea></td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t599' /></th>
	            <td><select id="selKeepMethod" style="WIDTH: 100%"></select></td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t600' /></th>
	            <td><select id="selKeepPlace" style="WIDTH: 100%"></select></td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t601' /></th>
	            <td>
	                <input type="radio" id="rdoDisplayFlag" name="rdoDisplayFlag" value="0" checked onclick="return rdoDisplayFlag_onclick(this.value)"><spring:message code = 'ezApprovalG.t757' />
	                <input type="radio" id="rdoDisplayFlag" name="rdoDisplayFlag" value="1" onclick="return rdoDisplayFlag_onclick(this.value)">
	                <spring:message code = 'ezApprovalG.t601' />
	            </td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t601' /><br>
	                <spring:message code = 'ezApprovalG.t758' /></th>
	            <td><input type="text" id="tbDispTransTime" name="tbDispTransTime" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50"></td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t611' /><br>
	            <td>
	                <select id="selExFrequency" style="width: 100%">
	                    <option value="1" id="1"><spring:message code = 'ezApprovalG.t612' /></option>
	                    <option value="2" id="2"><spring:message code = 'ezApprovalG.t613' /></option>
	                    <option value="3" id="3"><spring:message code = 'ezApprovalG.t614' /></option>
	                </select>
	            </td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t615' /></th>
	            <td>
	                <select id="selDisplayUsage" style="width: 100%">
	                    <option value="1" id="1"><spring:message code = 'ezApprovalG.t616' /></option>
	                    <option value="2" id="2"><spring:message code = 'ezApprovalG.t617' /></option>
	                    <option value="3" id="3"><spring:message code = 'ezApprovalG.t618' /></option>
	                    <option value="4" id="4"><spring:message code = 'ezApprovalG.t619' /></option>
	                    <option value="5" id="5"><spring:message code = 'ezApprovalG.t620' /></option>
	                </select>
	            </td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t605' /></th>
	            <td>
	                <input type="radio" id="rdoSpecialFlag" name="rdoSpecialFlag" value="0" checked onclick="return rdoSpecialFlag_onclick(this.value)">
	                <spring:message code = 'ezApprovalG.t761' />
	                <input type="radio" id="rdoSpecialFlag" name="rdoSpecialFlag" value="1" onclick="return rdoSpecialFlag_onclick(this.value)">
	                <spring:message code = 'ezApprovalG.t762' />
	                <input type="radio" id="rdoSpecialFlag" name="rdoSpecialFlag" value="2" onclick="return rdoSpecialFlag_onclick(this.value)">
	                <spring:message code = 'ezApprovalG.t683' />
	            </td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t608' /></th>
	            <td><input type="text" id="tbList1" name="tbList1" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50"></td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t609' /></th>
	            <td><input type="text" id="tbList2" name="tbList2" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50"></td>
	        </tr>
	        <tr class = 'approvalFlagG'>
	            <th><spring:message code = 'ezApprovalG.t610' /></th>
	            <td><input type="text" id="tbList3" name="tbList3" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50"></td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="return btnOk_onclick()"><spring:message code = 'ezApprovalG.t413' /></span></a>
	        <a class="imgbtn"><span onclick="return btncancel_onclick()"><spring:message code = 'ezApprovalG.t414' /></span></a>
	    </div>
	</body>
</html>