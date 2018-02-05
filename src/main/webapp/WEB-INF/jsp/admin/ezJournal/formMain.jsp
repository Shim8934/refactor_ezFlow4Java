<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t3' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">		    
		    //var companylist = "${companyList}";
		    var companyId = "<c:out value='${userInfo.companyID}' />";
		    
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
			
			$(document).ready(function() {
				//alert(companyId)
				$("#SCompID").val(companyId);
				journal_get_formuse();
			});
	
			function journal_get_formuse() {			    
			    $.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/admin/ezJournal/useType.do",
		    		data : { companyId  : companyId },
		    		success: function(result) {
		    			
		    			
		    		}
		        });
			}			
		    function Change_Click() {	
		    	var strtype = "";
		    	for (var i = 0; i < 6; i++) {
			    	if (document.getElementById("USE" + i).checked == true) {
			    		strtype += "use";
			    	} else {
			    		strtype += "no";
			    	}
		    	}
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezSchedule/journalSaveFormUse.do",
		    		data : {
		    			COMPANYID  : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value,
		    			FORMUSE : strtype
		    		},
		    		success: function(text) {
		    			alert("<spring:message code='ezSchedule.t4012' />");
		    		}
		        });
		    }
		    
		    function selectCompanyID() {
		        if (companyID != document.getElementById("SCompID").value) {
		            companyID = document.getElementById("SCompID").value;
	
		            //getGroupTree(1, 1, 0, true);
		        }
		    }
		</script>
		<style>
			.content td {
				text-align: center;
			}
		</style>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezJournal.t3' /></h1>
		<div id="mainmenu">
			<span><b><spring:message code = 'ezJournal.t11' /></b>
	            <select id="SCompID" name="SCompID" onchange="selectCompanyID()">
	            	<c:forEach var="company" items="${companyList}">
	            		<option value="<c:out value='${company.companyId}'/>"><c:out value='${company.companyName}'/></option>
	            	</c:forEach>
	            </select><br/><br/>
            </span>
            <ul>
            	<li id="btnInsertForm"><span onclick=""><spring:message code='ezJournal.t17' /></span></li>
            	<li id="btnModeForm"><span onclick=""><spring:message code='ezJournal.t18' /></span></li>
            	<li id="btnDeleteForm"><span onclick=""><spring:message code='ezJournal.t19' /></span></li>
            </ul>
		</div>
		
		<table style="margin-top:5px;width:1005px;height:500px">
			<tr>
		    	<td rowspan="2" style="width:200px; vertical-align:top">
					<div id="divFromTreeView" style="vertical-align:top; padding-top:5px; height:500px; width:100%; overflow-x:auto;overflow-y:auto;BORDER:#b6b6b6 1px solid; BACKGROUND-COLOR:#ffffff" ></div>
				</td>
		    	<td style="width:800px; padding-left:5px; padding-right:5px;vertical-align:top">
			    	<div class="listview">
			        	<div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 470px;overflow-x:auto;overflow-y:auto; padding:0px"  ></div>
			    	</div>
				</td>    
		  	</tr>
		    <tr>
		    	<td style="padding-left:5px; padding-right:5px; padding-top:5px; vertical-align:top">
		        	<table class="content">
			            <tr>
		            		<th><spring:message code = 'ezApprovalG.t1543' /></th>
		              		<td id="descrip">&nbsp;</td>
		            	</tr>
		        	</table>
		    	</td>
		  	</tr>   
		</table>
	    <script type="text/javascript">
	    	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

