<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t6000' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
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
			    schedule_get_lunaruse();
			}

			function changeCompany() {
				schedule_get_lunaruse();
			}
	
			function schedule_get_lunaruse() {			    
			    $.ajax({
		    		type : "GET",
		    		dataType : "text",
		    		async : true,
		    		cache : false,
		    		url : "/ezSchedule/scheduleGetLunarUse.do",
		    		data : {
		    			 COMPANYID  : encodeURIComponent(companySelectID)
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
		    		url : "/admin/ezSchedule/scheduleSaveLunarUse.do",
		    		data : {
		    			/* COMPANYID  : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value, */
		    			LUNARUSE : (document.getElementsByName("USE")[0].checked ? "1" : "2")
		    		},
		    		success: function(text) {
		    			
		    			if(text=='0'){
		    				alert("<spring:message code='ezAddress.t1' />");
		    			}else if(text=='1'){
		    				
		    			alert("<spring:message code='ezSchedule.t4012' />");
		    			}
		    			
		    		}
		        });
		    }
		</script>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezSchedule.t6000' />
			<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
		</h1>
		<form id="Form1" method="post">
			<br />
			<table class="content" style="width: 450px;">
			    <tr>
			        <th><spring:message code='ezSchedule.t402' /></th>
			        <td>
						<div class='custom_radio'><input style="margin-top: 0px;" type="radio" id="USE" name="USE" value="1" /><label for="USE" style="cursor: pointer; vertical-align: middle"><spring:message code='ezSchedule.t403' /></label></div>
						<div class='custom_radio'><input style="margin-top: 0px;" type="radio" id="NUSE" name="USE" value="2"/><label for="NUSE" style="cursor: pointer; vertical-align: middle"><spring:message code='ezSchedule.t404' /></label></div>
			        </td>
			    </tr>
			</table>
			<div class="btnpositionJsp" style="width: 436px">
			    <a class="imgbtn" onclick="Change_Click()"><span><spring:message code='ezSchedule.t157' /></span></a>
			    <a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code='ezSchedule.t5' /></span></a>
			</div>
		</form>
	</body>
</html>

