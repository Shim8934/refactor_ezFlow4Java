<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t6000' /></title>
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
				journal_get_formuse();
			}
	
			function journal_get_formuse() {			    
			    $.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : true,
		    		url : "/admin/ezJournal/journalGetFormUse.do",
		    		data : {
		    			COMPANYID  : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value		    			
		    		},
		    		success: function(result) {
		    			
		    			var leng = Object.keys(result.typeList).length;
		    			
		    			for(var i = 0; i < leng; i++) {
		    				if (result.typeList[i].journalUse == "use") {
		    					document.getElementById("USE" + i).checked = true;
		    				} else {
		    					document.getElementById("NUSE" + i).checked = true;
		    				}
		    			}
		    		}
		        });
			}			
		    function Cancel_Click() {
		        window.location.reload(true);
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
		</script>
		<style>
			.content td {
				text-align: center;
			}
		</style>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezJournal.b002' /></h1>
		<form id="Form1" method="post">
			<div id="mainmenu">
				<span><b><spring:message code = 'ezApprovalG.t1512' /></b></span>
	            <select id="ListCompany" onchange="journal_get_formruse()">${companySel}</select>
			</div>
			<br/>
			<table class="content" style="width: 260px; margin-left: 15px;">
			    <tr>
			        <th style="text-align: center;" width="100px"><spring:message code='ezJournal.b011' /></th>
			        <th style="text-align: center;" width="80px"><spring:message code='ezJournal.b012' /></th>
			        <th style="text-align: center;" width="80px"><spring:message code='ezJournal.b013' /></th>
			    </tr>
			    <tr>
			    	<td><spring:message code='ezJournal.b005' /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="USE0" name="USE0" value="1" /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="NUSE0" name="USE0" value="2"/></td>
			    </tr>
			    <tr>
			    	<td><spring:message code='ezJournal.b006' /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="USE1" name="USE1" value="1" /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="NUSE1" name="USE1" value="2"/></td>
			    </tr>
			    <tr>
			    	<td><spring:message code='ezJournal.b007' /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="USE2" name="USE2" value="1" /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="NUSE2" name="USE2" value="2"/></td>
			    </tr>
			    <tr>
			    	<td><spring:message code='ezJournal.b008' /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="USE3" name="USE3" value="1" /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="NUSE3" name="USE3" value="2"/></td>
			    </tr>
			    <tr>
			    	<td><spring:message code='ezJournal.b009' /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="USE4" name="USE4" value="1" /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="NUSE4" name="USE4" value="2"/></td>
			    </tr>
			    <tr>
			    	<td><spring:message code='ezJournal.b010' /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="USE5" name="USE5" value="1" /></td>
			        <td><input style="margin-top: 0px;" type="radio" id="NUSE5" name="USE5" value="2"/></td>
			    </tr>
			</table>
			<div class="btnposition" style="width: 260px">
			    <a class="imgbtn" onclick="Change_Click()"><span><spring:message code='ezSchedule.t4' /></span></a>
			    <a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code='ezSchedule.t5' /></span></a>
			</div>
		    <script type="text/javascript">
		    	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
		</form>
	</body>
</html>

