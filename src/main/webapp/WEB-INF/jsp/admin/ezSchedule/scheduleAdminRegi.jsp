<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t6001' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">		    
		    var userlang = "<c:out value='${primary}'/>";
		    var companylist = "${companyList}";
		    
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
			
			window.onload = function () {
			    schedule_get_regiUse();
			}
	
			function schedule_get_regiUse() {
			    $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezSchedule/scheduleGetRegi.do",
		    		data : {
		    			COMPANYID  : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value		    			
		    		},
		    		success: function(text) {
		    			if (text == "0") {
					        document.getElementById("USE").checked = true;
		    			} else if(text == "1") {
					        document.getElementById("USE").checked = true;
		    			} else {
					        document.getElementById("NUSE").checked = true;
		    			}
		    		}
		        });
			}			
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
		    function Change_Click() {		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezSchedule/scheduleSaveRegi.do",
		    		data : {
		    			COMPANYID  : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value,
		    			PREVIOSLYREGIUSE : (document.getElementsByName("USE")[0].checked ? "1" : "2")
		    		},
		    		success: function(text) {
		    			alert("<spring:message code='ezSchedule.t4012' />");
		    		}
		        });
		    }
		</script>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezSchedule.t6001' /></h1>
		<form id="Form1" method="post">
			<div id="mainmenu">
			    <ul>
			        <li style="background:none;padding-top:4px;height:24px">
			            <select id="ListCompany" onchange="schedule_get_regiUse()">${companySel}</select>
			        </li>
			    </ul>
			</div>
			<br />
			<table class="content" style="width: 450px; margin-left: 15px;">
			    <tr>
			        <th><spring:message code='ezSchedule.t402' /></th>
			        <td>
			            <input style="margin-top: 0px;" type="radio" id="USE" name="USE" value="1" /><label for="USE" style="cursor: pointer; vertical-align: middle"><spring:message code='ezSchedule.t403' /></label>
			            <input style="margin-top: 0px;" type="radio" id="NUSE" name="USE" value="2"/><label for="NUSE" style="cursor: pointer; vertical-align: middle"><spring:message code='ezSchedule.t404' /></label>
			        </td>
			    </tr>
			</table>
			<div class="btnposition" style="width: 450px">
			    <a class="imgbtn" onclick="Change_Click()"><span><spring:message code='ezSchedule.t4' /></span></a>
			    <a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code='ezSchedule.t5' /></span></a>
			</div>
		    <script type="text/javascript">
		    	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
		</form>
	</body>
</html>

