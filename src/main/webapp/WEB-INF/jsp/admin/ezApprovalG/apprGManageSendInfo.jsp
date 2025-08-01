<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1580' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
	        var PresentCompanyID = "<c:out value = '${userInfo.companyID}' />";
	
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
			$(document).ready(function(){
	            document.getElementById("ListCompany").value = PresentCompanyID;
	            GetOptionInfo(document.getElementById("ListCompany").value);
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
				$.ajax({
					type : "POST",
					url : "/admin/ezApprovalG/getOptionInfo.do",
					async : false,
					dataType : "json",
					data : {companyID : companyID},
					success : function (result) {
						objXml = loadXMLString(result["encodeInfo"]);
						
						if (getNodeText(objXml) == "") {
					        SaveOptionInfo(companyID, "Y", "Y", "Y");
					        document.getElementById("special1").checked = true;
					        document.getElementById("special2").checked = true;
					        document.getElementById("special3").checked = true;
					    } else {
					        if (SelectSingleNodeValue(objXml.documentElement, "SIGN") == "Y") {
					            special1.checked = true;
					        } else {
					        	special1.checked = false;
					        }
					        if (SelectSingleNodeValue(objXml.documentElement, "ENCODE") == "Y") {
					            special2.checked = true;
					        } else {
					        	special2.checked = false;
					        }
					        if (SelectSingleNodeValue(objXml.documentElement, "NONE") == "Y") {
					            special3.checked = true;
					        } else {
					        	special3.checked = false;
					        }
					    }
					}
				});
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
			
			    SaveOptionInfo(ListCompany.value, option1, option2, option3);
			}
			
			function selectCompanyID() {
			    GetOptionInfo(document.getElementById("ListCompany").value);
			}
		</script>
		
	</head>
	<body class="mainbody">
	    <h1>
	    	<spring:message code = 'ezApprovalG.t1582' />
	    	<span class="title_bar"><img src="/images/name_bar.gif"></span>
	    	<select id="ListCompany" name="SCompID" class="companySelect" onchange="selectCompanyID()">
	    		<c:forEach var="item" items="${list}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
            </select>
	    </h1>
	    <div id="mainmenu">
		  	<%-- <ul>	    
		        <b><spring:message code='ezApprovalG.t1276'/></b>
		    	<select id="SCompID" name="SCompID" onchange="selectCompanyID()">
		    		<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
	            </select>
	        </ul> --%>    
	    </div>
	
	    <table class="content" style="margin-top: 10px">
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1583' /></th>
	            <td style="width: 250px; white-space: nowrap;">
					<div class='custom_checkbox'>
						<input type="checkbox" id="special1" name="special1" value="checkbox"><label for="special1"><spring:message code = 'ezApprovalG.t1584' /></label>
					</div>
	            </td>

	            <td style="width: 250px; display: none; white-space: nowrap;">
					<div class='custom_checkbox'>
						<input type="checkbox" id="special2" name="special2" value="checkbox"><label for="special2"><spring:message code = 'ezApprovalG.t1585' /></label>
					</div>
	            </td>
	
	            <td style="width: 250px; white-space: nowrap;">
					<div class='custom_checkbox'>
						<input type="checkbox" id="special3" name="special3" value="checkbox"><label for="special3"><spring:message code = 'ezApprovalG.t1586' /></label>
					</div>
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnpositionJsp" style="width: 560px">
	        <a class="imgbtn"><span onclick="return bt_OK_onclick()"><spring:message code = 'ezApprovalG.t20' /></span></a>
	    </div>
	</body>
</html>