<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title>${title}</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var labelcolor = "gray";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var companyID, gRtnVal;
	        var gState, GroupName, GroupName2, GroupID, UpperGroupID, Level;
	
	        var reParam = new Array();
	        reParam[0] = "FALSE";
	        reParam[1] = "";
	
	        var ReturnFunction;
	
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        window.onload = function () {
	            try{
	                ReturnFunction = opener.minsgroupmain_cross_dialogArguments[1];
	                dialogArguments = opener.minsgroupmain_cross_dialogArguments[0];
	            } catch (e) { }
	
	            var para = dialogArguments;
	
	            if (para[0] == "I") {
	                gState = "I";
	                GroupName = para[1];
	                GroupID = para[2];
	                UpperGroupID = para[3];
	                Level = para[4];
	                companyID = para[5];
	            }
	            else
	            {
	                gState = "U";
	                GroupName = para[1];
	                GroupName2 = para[6];
	                GroupID = para[2];
	                UpperGroupID = para[3];
	                Level = para[4];
	                companyID = para[5];
	                document.getElementById("tbFormName").value = GroupName;
	                document.getElementById("tbFormName2").value = GroupName2;
	                document.getElementById("tbFormID").value = GroupID;
	            }
	        }
	
	        function btnOk_onclick() {
	            if (gState == "I") {
	                var ret = insForm();
	                if (!ret)
	                    return;
	            }
	            else {
	                var ret = UpdateForm();
	                if (!ret)
	                    return;
	            }
	
	            reParam[0] = gRtnVal;
	            reParam[1] = tbFormName.value;
	            reParam[2] = tbFormName2.value;
	            if(ReturnFunction != null)
	                ReturnFunction(reParam);
	            window.close();
	        }
	
	
	        function btncancel_onclick() {
	            reParam[0] = "FALSE";
	            reParam[1] = "";
	
	            if (ReturnFunction != null)
	                ReturnFunction(reParam);
	            window.close();
	        }
	
	        function insForm() {
	            if (tbFormName.value != "" && tbFormName2.value != "") {
	                var result = "";
	                
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezApproval/mInsDocNumGroup.do",
			    		data : {
			    			g_level : Level,
			    			g_upperID : UpperGroupID,
			    			groupName : tbFormName.value,
			    			groupName2 : tbFormName2.value,
			    			companyID  : companyID
			    		},
			    		success: function(text){
			    			result = text;
			    		}
			    	});
			    	
	                gRtnVal = result;
	                if (gRtnVal == "0") {
	                    alert("<spring:message code='ezApproval.t762'/>");
	                    return false;
	                }
	                else {
	                    return true;
	                }
	            }
	            else {
	                alert("<spring:message code='ezApproval.t763'/>");
	                return false;
	            }
	        }
	
	        function UpdateForm() {
	            if (tbFormName.value != "" && tbFormName2.value != "") {
	                var result = "";
	                
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezApproval/mUpdateDocNumGroup.do",
			    		data : {
			    			groupID    : GroupID,
			    			groupName  : tbFormName.value,
			    			groupName2 : tbFormName2.value,
			    			companyID  : companyID
			    		},
			    		success: function(text){
			    			result = text;
			    		}
			    	});
			    	
	                gRtnVal = result;
	
	                if (gRtnVal == "<RESULT>TRUE</RESULT>") {
	                    return true;
	                }
	                else {
	                    return false;
	                }
	            }
	            else {
	                alert("<spring:message code='ezApproval.t763'/>");
	                return false;
	            }
	        }
	
	        window.oncontextmenu = function () {
	            return false;
	        }
	    </script>
	</head>
	<body class="popup">
	    <h1>${title}</h1>
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezApproval.t764'/></th>
	            <td>
	                <table style="width: 100%">
	                    <tr class="primary">
	                        <th>${langPrimary}</th>
	                        <td>
	                            <input type="text" id="tbFormName" name="tbFormName" style="width: 195px" maxlength="50">
	                        </td>
	                    </tr>
	                    <tr class="secondary">
	                        <th>${langSecondary}</th>
	                        <td>
	                            <input type="text" id="tbFormName2" name="tbFormName2" style="width: 195px" maxlength="50">
	                            <input type="text" id="tbFormID" name="tbFormID" style="width: 100px; display: none" readonly>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnposition">
	        <a class="imgbtn" onclick="btnOk_onclick()"><span><spring:message code='ezApproval.t84'/></span></a>
	        <a class="imgbtn" onclick="btncancel_onclick()"><span><spring:message code='ezApproval.t85'/></span></a>
	    </div>
	</body>
</html>