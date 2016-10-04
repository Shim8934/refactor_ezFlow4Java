<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1580' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
	        var PresentCompanyID = "<c:out value = '${userInfo.companyID}' />";
	
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
			$(document).ready(function(){
	            document.getElementById("SCompID").value = PresentCompanyID;
	            GetOptionInfo(document.getElementById("SCompID").value);
	        });
			
			var ezapralert_cross_dialogArguments = new Array();
	        function OpenAlertUI(pAlertContent) {
        		if (CrossYN()) {
		        	ezapralert_cross_dialogArguments[0] = pAlertContent;
	                var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
	                try { ezAPRALERT_Cross.focus(); } catch (e) {
	                }
	            } else {
	                var parameter = pAlertContent;
	                var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
	                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	                var RtnVal = window.showModalDialog(url, parameter, feature);
	            }
	        }
	        
	        function SaveOptionInfo(companyID, option1, option2, option3) {
			    $.ajax({
			    	type : "POST",
			    	url : "/admin/ezApprovalG/saveOptionInfo.do",
			    	async : false,
			    	data : {option1 : option1, option2 : option2, option3 : option3, companyID : companyID},
			    	success : function (result) {
			    		if (result == "TRUE") {
			    			alert("<spring:message code = 'ezApprovalG.t1581' />");
			    		}
			    	}
			    });
			}
	        
			function GetOptionInfo(companyID) {
			    var objXml = new createXmlDom();
			    objXml.async = false;
			
			    objXml = loadXMLFile("/files/upload_approvalG/" + companyID + "/encodeinfo.xml");

			    if (getNodeText(objXml) == "") {
			        SaveOptionInfo(companyID, "Y", "Y", "Y");
			        document.getElementById("special1").checked = true;
			        document.getElementById("special2").checked = true;
			        document.getElementById("special3").checked = true;
			    } else {
			        if (SelectSingleNodeValue(objXml.documentElement, "SIGN") == "Y") {
			            special1.checked = true;
			        }
			        if (SelectSingleNodeValue(objXml.documentElement, "ENCODE") == "Y") {
			            special2.checked = true;
			        }
			        if (SelectSingleNodeValue(objXml.documentElement, "NONE") == "Y") {
			            special3.checked = true;
			        }
			    }
			    
			    objXml = null;
			}
			
			function bt_OK_onclick() {
			    var option1, option2, option3;
			    
			    if (document.getElementById("special1").checked) {
			        option1 = "Y";
			    } else {
			        option1 = "N";
			    }
			
			    if (document.getElementById("special2").checked) {
			        option2 = "Y";
			    } else {
			        option2 = "N";
			    }
			
			    if (document.getElementById("special3").checked) {
			        option3 = "Y";
			    } else {
			        option3 = "N";
			    }
			
			    SaveOptionInfo(SCompID.value, option1, option2, option3);
			}
			
			function OnSelChange() {
			    GetOptionInfo(document.getElementById("SCompID").value);
			}
		</script>
		
	</head>
	<body class="mainbody">
	    <h1><spring:message code = 'ezApprovalG.t1582' /></h1>
	    <div>
	        <b><spring:message code='ezApprovalG.t1276'/></b>
	    	<select id="SCompID" name="SCompID" onchange="selectCompanyID()">
	    		<c:forEach var="item" items="${list}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
            </select>
	    </div>
	
	    <table class="content" style="margin-top: 10px">
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1583' /></th>
	            <td style="width: 250px; white-space: nowrap;">
	                <input type="checkbox" id="special1" name="special1" value="checkbox"><spring:message code = 'ezApprovalG.t1584' />
	            </td>

	            <td style="width: 250px; display: none; white-space: nowrap;">
	                <input type="checkbox" id="special2" name="special2" value="checkbox"><spring:message code = 'ezApprovalG.t1585' />
	            </td>
	
	            <td style="width: 250px; white-space: nowrap;">
	                <input type="checkbox" id="special3" name="special3" value="checkbox"><spring:message code = 'ezApprovalG.t1586' />
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnposition" style="width: 580px">
	        <a class="imgbtn"><span onclick="return bt_OK_onclick()"><spring:message code = 'ezApprovalG.t20' /></span></a>
	    </div>
	</body>
</html>