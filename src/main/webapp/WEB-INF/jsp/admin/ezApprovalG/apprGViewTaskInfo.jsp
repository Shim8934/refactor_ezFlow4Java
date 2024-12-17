<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t822' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Req_TaskClass_Cross.js')}"></script>
		
	
		<script type="text/javascript">
			var rtnVal = new Array();
		    var DeptID, TaskCode;
		    var CompanyID = "<c:out value = '${userInfo.companyID}' />";
		    window.onbeforeunload = window_onunload;
		    window.onunload = window_onunload;
		    var RetValue;
		    var ReturnFunction;
		    
		    $(document).ready(function(){
		        var UserAgentState = navigator.userAgent.toLowerCase();
		        //if (UserAgentState.indexOf("firefox") > -1)
		        //    setinnerHTMLProperty();
		        rtnVal[0] = "FALSE";
	
		        try {
		            RetValue = parent.viewtaskinfo_cross_dialogArguments[0];
		            ReturnFunction = parent.viewtaskinfo_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.viewtaskinfo_cross_dialogArguments[0];
		                ReturnFunction = opener.viewtaskinfo_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        
		        DeptID = RetValue[0];
		        TaskCode = RetValue[1];
		        InitCode();
		        InitTaskInfo();
		    });
		    
		    //function setinnerHTMLProperty() {
		    //    if (typeof HTMLElement != "undefined" && typeof HTMLElement.prototype.__defineGetter__ != "undefined") {
		    //        HTMLElement.prototype.__defineGetter__("innerHTML", function () {
		    //            if (this.textContent) {
		    //                return (this.textContent)
		    //            }
		    //            else {
		    //                var r = this.ownerDocument.createRange();
		    //                r.selectNodeContents(this);
		    //                return r.toString();
		    //            }
		    //        });
		    //        HTMLElement.prototype.__defineSetter__("innerHTML", function (sText) {
		    //            this.innerHTML = sText
		    //        });
		    //    }
		    //}
		    
		    function InitCode() {
		    	$.ajax({
	        		type : "POST",
		        	url : "/ezApprovalG/getCodeList.do",
		        	async : false,
		        	data : {companyID : CompanyID},
		        	dataType : "text",
		        	success : function(result){
		        		result = loadXMLString(result);
		        		
		        		var nodesKeepPeriod = SelectNodes(result, "CODELIST/KEEPINGPERIOD/CODE");
			            InitCodeSelectBox(nodesKeepPeriod, selKeepPeriod);

			            var nodesKeepMethod = SelectNodes(result, "CODELIST/KEEPINGMETHOD/CODE");
			            InitCodeSelectBox(nodesKeepMethod, selKeepMethod);

			            var nodesKeepPlace = SelectNodes(result, "CODELIST/KEEPINGPLACE/CODE");
			            InitCodeSelectBox(nodesKeepPlace, selKeepPlace);
		        	}
	        	});
		    }
		    
		    function InitTaskInfo() {
		        var TaskXml = loadXMLString(GetTaskInfo());
		        
		        if (getNodeText(GetChildNodes(TaskXml)[0]) == "FALSE") {
		            alert("<spring:message code = 'ezApprovalG.t653' />");
		            window.close();
		        }
		        else if (getNodeText(GetChildNodes(TaskXml)[0]) == "NOITEM") {
		            alert("<spring:message code = 'ezApprovalG.t654' />");
		            window.close();
		        } else {
					var applyDateValue = SelectSingleNodeValueNew(TaskXml, "ROW/APPLYDATE");
		            document.getElementById("tdCreateDate").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/CREATEDATE").substring(0, 10);
		            document.getElementById("tdApplyDate").innerHTML = applyDateValue.substring(0, 4) + '-' + applyDateValue.substring(4, 6) + '-' + applyDateValue.substring(6, 8);
		            document.getElementById("tdTitle").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/TASKNAME");
		            document.getElementById("tdTitle2").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/TASKNAME2");
		            document.getElementById("tdDesc").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/DESCRIPTION");
		            document.getElementById("selKeepPeriod").value = SelectSingleNodeValueNew(TaskXml, "ROW/KEEPINGPERIOD");
		            document.getElementById("tdKPReason").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/KPREASON");
		            document.getElementById("selKeepMethod").value = SelectSingleNodeValueNew(TaskXml, "ROW/KEEPINGMETHOD");
		            document.getElementById("selKeepPlace").value = SelectSingleNodeValueNew(TaskXml, "ROW/KEEPINGPLACE");
	
		            var DispFlag = SelectSingleNodeValueNew(TaskXml, "ROW/DISPLAYRECFLAG");
		            
		            if (DispFlag == "1") {
		                document.getElementById("tdDispFlag").innerHTML = "<spring:message code = 'ezApprovalG.t601' />";
		            } else {
		                document.getElementById("tdDispFlag").innerHTML = "<spring:message code = 'ezApprovalG.t602' />";
		            }
	
		            document.getElementById("tdDispTransTime").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/DISPLAYRECTRASTIME");
		            SelectOption(selExFrequency, SelectSingleNodeValueNew(TaskXml, "ROW/EXDISPLAYFREQUENCY"));
		            SelectOption(selDisplayUsage, SelectSingleNodeValueNew(TaskXml, "ROW/DISPLAYUSAGE"));
	
		            var SCFlag = SelectSingleNodeValueNew(TaskXml, "ROW/SPECIALCATALOGFLAG");
		            
		            if (SCFlag == "1") {
		                tdSCFlag.innerHTML = "<spring:message code = 'ezApprovalG.t51' />";
		            } else if (SCFlag == "2") {
		                tdSCFlag.innerHTML = "<spring:message code = 'ezApprovalG.t607' />";
		            } else {
		                tdSCFlag.innerHTML = "<spring:message code = 'ezApprovalG.t606' />";
		            }
	
		            document.getElementById("tdSC1").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/SC1");
		            document.getElementById("tdSC2").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/SC2");
		            document.getElementById("tdSC3").innerHTML = SelectSingleNodeValueNew(TaskXml, "ROW/SC3");
		        }
		    }
	
		    function btnOK_onclick() {
		        rtnVal[0] = "TRUE";
		        window.close();
		    }
	
		    function btnClose_onclick() {
		        rtnVal[0] = "FALSE";
		        window.close();
		    }
	
		    function window_onunload() {
		        window.returnValue = rtnVal;
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<h1><spring:message code = 'ezApprovalG.t822' /></h1>
		<div id="close">
            <ul>
                <li><span name="btnCancel" onClick="return btnClose_onclick()"></span></li>
            </ul>
        </div>
		<table class="content">
		  	<tr>
			    <th><spring:message code = 'ezApprovalG.t597' />(<spring:message code = 'ezApprovalG.t1764' />)</th>
			    <td id="tdTitle"></td>
			</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t597' />(<spring:message code = 'ezApprovalG.t1765' />)</th>
			    <td id="tdTitle2"></td>
		  	</tr>
		  	<tr>
		    	<th> <spring:message code = 'ezApprovalG.t823' /></th>
		    	<td  id="tdCreateDate"></td>
		  	</tr>
		  	<tr>
		    	<th> <spring:message code = 'ezApprovalG.t824' /></th>
		    	<td  id="tdApplyDate"></td>
		  	</tr>
		  	<tr>
				<th><spring:message code = 'ezApprovalG.t672' /></th>
		    	<td>
		    		<textarea name="tdDesc" class="textarea" style="font-size:9pt;width:97%;height:60px; border:0px; resize:none;" id=tdDesc readonly="readonly"></textarea>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t117' /></th>
		    	<td>
		    		<Select id="selKeepPeriod" style="width:120px;" disabled></Select>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t678' /></th>
		    	<td>
		    		<textarea name="tdKPReason" class="textarea" style="font-size:9pt;width:97%;height:60px; border:0px; resize:none;" id=tdKPReason readonly="readonly"></textarea>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t599' /></th>
		    	<td>
		    		<Select id="selKeepMethod" style="width:200px" disabled></Select>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t600' /></th>
		    	<td>
		    		<Select id="selKeepPlace" style="width:120px" disabled></Select>
		    	</td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezApprovalG.t601' /></th>
			    <td  id="tdDispFlag"></td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezApprovalG.t604' /></th>
			    <td  id="tdDispTransTime"></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t611' /></th>
		    	<td>
		    		<Select id="selExFrequency" style="width:100px" disabled>
				        <Option value="" id="" selected></Option>
				        <Option value="1" id="1"><spring:message code = 'ezApprovalG.t612' /></Option>
				        <Option value="2" id="2"><spring:message code = 'ezApprovalG.t613' /></Option>
				        <Option value="3" id="3"><spring:message code = 'ezApprovalG.t614' /></Option>
		      		</Select>
			    </td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t615' /></th>
		    	<td>
		    		<Select id="selDisplayUsage" style="width:100px" disabled>
				        <Option value="" id="" selected></Option>
				        <Option value="1" id="1"><spring:message code = 'ezApprovalG.t616' /></Option>
				        <Option value="2" id="2"><spring:message code = 'ezApprovalG.t617' /></Option>
				        <Option value="3" id="3"><spring:message code = 'ezApprovalG.t618' /></Option>
				        <Option value="4" id="4"><spring:message code = 'ezApprovalG.t619' /></Option>
				        <Option value="5" id="5"><spring:message code = 'ezApprovalG.t620' /></Option>
			      	</Select>
		    	</td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezApprovalG.t605' /></th>
			    <td  id="tdSCFlag"></td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezApprovalG.t608' /></th>
			    <td  id="tdSC1"></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t609' /></th>
		    	<td  id="tdSC2"></td>
		  	</tr>
			<tr>
			    <th><spring:message code = 'ezApprovalG.t610' /></th>
			    <td  id="tdSC3"></td>
			</tr>
		</table>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" name="btnOK" onClick="return btnOK_onclick()"><span><spring:message code = 'ezApprovalG.t20' /></span></a>
		</div>
	</body>
</html>