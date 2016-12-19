<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title>${title}</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var labelcolor = "gray"
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var itemcode, itemname, itemname2, itemlimit, itemsecu, itempub, gState, itemgroup;
	        var gRtnVal = "FALSE";
	        var companyID;
	
	        var ReturnFunction;
	
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        window.onload = function () {
	            try {
	                dialogArguments = opener.minscodemain_cross_dialogArguments[0];
	                ReturnFunction = opener.minscodemain_cross_dialogArguments[1];
	            } catch (e) { }
	            var para = dialogArguments;
	            if (para[0] == "I") {
	                gState = "I";
	                itemcode = para[1];
	                itemname = para[2];
	                itemlimit = para[3];
	                itemsecu = para[4];
	                itempub = para[5];
	                itemgroup = para[6];
	                companyID = para[7];
	            }
	            else {
	                gState = "U";
	                itemcode = para[1];
	                itemname = para[2];
	                itemlimit = para[3];
	                itemsecu = para[4];
	                itempub = para[5];
	                itemgroup = para[6];
	                companyID = para[7];
	                itemname2 = para[8];
	
	                document.getElementById("tbFormID").value = itemcode;
	                document.getElementById("tbFormName").value = itemname;
	                document.getElementById("tbFormName2").value = itemname2;
	                document.getElementById("keepperiod").value = itemlimit;
	                document.getElementById("securitylevel").value = itemsecu;
	                document.getElementById("isPublic").value = itempub;
	                document.getElementById("tbFormID").readOnly = true;
	                document.getElementById("tbFormID").disabled = true;
	            }
	        }
	
	        function btnOk_onclick() {
	            if (gState == "I") {
	                insForm();
	            }
	            else {
	                UpdateForm();
	            }
	
	            if (gRtnVal == "FALSE") {
	                alert("<spring:message code='ezApproval.t731'/>");
	            }
	            else {
	                if(ReturnFunction != null)
	                    ReturnFunction(gRtnVal);
	                window.close();
	            }
	        }
	
	        function btncancel_onclick() {
	            if(ReturnFunction != null)
	                ReturnFunction("FALSE");
	            window.close();
	        }
	
	        function insForm() {
	            if (document.getElementById("tbFormName").value != ""
	                && document.getElementById("tbFormID").value != ""
	                && document.getElementById("tbFormName2").value != "") {
					var result = "";
	                
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezApproval/mInsDocNumItem.do",
			    		data : {
			    			groupID      : itemgroup,
			    			itemCode     : document.getElementById("tbFormID").value,
			    			itemName     : document.getElementById("tbFormName").value,
			    			itemName2    : document.getElementById("tbFormName2").value,
			    			itemLimit    : document.getElementById("keepperiod").value,
			    			itemSecurity : document.getElementById("securitylevel").value,
			    			itemPublic   : document.getElementById("isPublic").value,
			    			companyID    : companyID
			    		},
			    		success: function(text){
			    			result = text;
			    		}
			    	});
	            	
	                gRtnVal = result;
	            }
	            else {
	                gRtnVal = "FALSE";
	            }
	        }
	
	
	        function UpdateForm() {
	            if (document.getElementById("tbFormName").value != ""
	                && document.getElementById("tbFormID").value != "") {
					var result = "";
	                
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezApproval/mUpdateDocNumItem.do",
			    		data : {
			    			groupID      : itemgroup,
			    			itemCode     : document.getElementById("tbFormID").value,
			    			itemName     : document.getElementById("tbFormName").value,
			    			itemName2    : document.getElementById("tbFormName2").value,
			    			itemLimit    : document.getElementById("keepperiod").value,
			    			itemSecurity : document.getElementById("securitylevel").value,
			    			itemPublic   : document.getElementById("isPublic").value,
			    			companyID    : companyID
			    		},
			    		success: function(text){
			    			result = text;
			    		}
			    	});
			    	
	                gRtnVal = result;
	            }
	            else {
	                gRtnVal = "FALSE";
	            }
	        }
	
	    </script>
	</head>
	<body oncontextmenu="return false" class="popup">
	    <h1>
	        ${title}
	    </h1>
	    <table class="content">
	        <tr>
	            <th>
	                <spring:message code='ezApproval.t732'/>
	            </th>
	            <td>
	                <table style="width: 100%">
	                    <tr class="primary">
	                        <th>
	                            ${langPrimary}
	                        </th>
	                        <td>
	                            <input type="text" maxlength="50" id="tbFormName" name="tbFormName" style="width: 170px" /></td>
	                    </tr>
	                    <tr class="secondary">
	                        <th>
	                            ${langSecondary}
	                        </th>
	                        <td>
	                            <input type="text" maxlength="50" id="tbFormName2" name="tbFormName2" style="width: 170px" /></td>
	                    </tr>
	                </table>
	            </td>
	            <th>
	                <spring:message code='ezApproval.t335'/>
	            </th>
	            <td>
	                <input type="text" maxlength="3" id="tbFormID" name="tbFormID" style="width: 90px" readonly="readonly" value="${maxItemCode}" /></td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code='ezApproval.t81'/>
	            </th>
	            <td colspan="3">
	                <select id="securitylevel" name="select" style="width: 85px">
	                    ${securityNode}
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code='ezApproval.t336'/>
	            </th>
	            <td colspan="3">
	                <select id="keepperiod" name="select" style="width: 85px">
	                    ${periodNode}
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code='ezApproval.t82'/>
	            </th>
	            <td colspan="3">
	                <select id="isPublic" name="select" style="width: 85px">
	                    <option value="Y" selected="selected">
	                        <spring:message code='ezApproval.t50'/>
	                    </option>
	                    <option value="N">
	                        <spring:message code='ezApproval.t49'/>
	                    </option>
	                </select>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn" onclick="btnOk_onclick()"><span><spring:message code='ezApproval.t272'/></span></a>
	        <a class="imgbtn" onclick="btncancel_onclick()"><span><spring:message code='ezApproval.t273'/></span></a>
	    </div>
	</body>
</html>