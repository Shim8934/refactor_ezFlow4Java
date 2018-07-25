<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1025'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
    	<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
    	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript">
		    var rtnVal = new Array();
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            RetValue = parent.InsDisplayInfo_Cross_dialogArguments[0];
		            ReturnFunction = parent.InsDisplayInfo_Cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.InsDisplayInfo_Cross_dialogArguments[0];
		                ReturnFunction = opener.InsDisplayInfo_Cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        var DisplayEndDate = RetValue[0];
		        var DisplayReason = RetValue[1];
		        InitDisplayEndDate(DisplayEndDate);
		        txtDisplayReason.value = DisplayReason;
		        rtnVal[0] = "FALSE";
		    };
		    function InitDisplayEndDate(DisplayEndDate)
		    {
		        if(DisplayEndDate.length==8)
		        {
		            txtDisplayEndY.value = DisplayEndDate.slice(0,4);
		            txtDisplayEndM.value = DisplayEndDate.slice(4,6);
		            txtDisplayEndD.value = DisplayEndDate.slice(6,8);
		        }
		    }
		    function btnReset_onclick()
		    {
		        txtDisplayEndY.value = "";
		        txtDisplayEndM.value = "";
		        txtDisplayEndD.value = "";
		        txtDisplayReason.value = "";
		    }
		    function btnOK_onclick()
		    {
		        if(txtDisplayEndY.value == "" || txtDisplayEndM.value == "" || txtDisplayEndD.value == "")
		        {
		            alert("<spring:message code='ezApprovalG.t956'/>");
		        }
		        else if(! ValidateYearValue(txtDisplayEndY.value))
		        {
		            alert("<spring:message code='ezApprovalG.t957'/>");
		        }
		        else if(! ValidateNumber(txtDisplayEndM.value))
		        {
		            alert("<spring:message code='ezApprovalG.t958'/>");
		        }
		        else if(! ValidateNumber(txtDisplayEndD.value))
		        {
		            alert("<spring:message code='ezApprovalG.t959'/>");
		        }
		        else if(! IsGreaterThanCurYear(txtDisplayEndY.value))
		        {
		            alert("<spring:message code='ezApprovalG.t1026'/>");
		        }
		        else
		        {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = GetDisplayEndDate();
		            rtnVal[2] = txtDisplayReason.value;
		            
		            if (ReturnFunction != null) {
			            ReturnFunction(rtnVal);
			        } else {
			            window.close();
			        }
		        }
		    }
		    function IsGreaterThanCurYear(pYear)
		    {
		        var curDate = new Date();
		        var curY = curDate.getFullYear();
		        if(parseInt(pYear)>=curY)
		            return true;
		        else
		            return false;
		    }
		    function btnClose_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		        } else {
		            window.close();
		        }
		    }
		    window.onunload = function()
		    {
		        window.returnValue = rtnVal;
		    }
		</script>
	</head>
	<body class="popup" style="margin:0;">
		<h1><spring:message code='ezApprovalG.t1025'/></h1>
		<div id="close">
            <ul>
                <li><span id="btnClose" onClick="return btnClose_onclick()"></span></li>
            </ul>
        </div>
		<table class="content">   
		  <tr>   
		    <th><spring:message code='ezApprovalG.t842'/></th>
		    <td style="width:100%">
		      <input type="text"  name="txtDisplayEndY" id="txtDisplayEndY" maxlength = "4" size="4" style="height:20px;"/>
						<spring:message code='ezApprovalG.t641'/>
		      <input type="text"  name="txtDisplayEndM"  id="txtDisplayEndM" maxlength = "2" size="2" style="height:20px;"/>
						<spring:message code='ezApprovalG.t642'/>
		      <input type="text"  name="txtDisplayEndD"  id="txtDisplayEndD" maxlength = "2" size="2" style="height:20px;"/>
						<spring:message code='ezApprovalG.t643'/>
			  </td>
		  </tr>	
		  <tr> 		  
		    <th><spring:message code='ezApprovalG.t843'/></th>
		    <td style="vertical-align:middle;">
		      <TextArea style="width:100%; height:95px; padding:0px; border:0; resize:none;" id="txtDisplayReason" name="txtDisplayReason"></TextArea>
			  </td>
		  </tr>
		</table>	
		<div class="btnpositionNew" >
		      <a class="imgbtn"><span id="btnReset" onClick="return btnReset_onclick()"><spring:message code='ezApprovalG.t621'/></span></a>
		      <a class="imgbtn"><span id="btnOK" onClick="return btnOK_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>		      
		</div>
	</body>
</html>