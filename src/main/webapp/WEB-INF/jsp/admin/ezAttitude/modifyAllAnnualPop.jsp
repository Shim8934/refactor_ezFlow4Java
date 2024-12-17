<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t236' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">	
	    	var companyId = "<c:out value="${companyId}" />";
	    	var changeReason = '';
	    	var annualCnt = '';
	    
	    	$(document).ready(function(){
		    	$("input:text[name=annualCnt]").on("keyup", function() {
		    	    $(this).val($(this).val().replace(/[^0-9]/g,""));
		    	});
   			});
	    	
	    	function setBancha() {
	    		if($("input:checkbox[id='bancha']").is(":checked")) {
	    			$("#banchaTxt").html(".5");
	    		} else {
	    			$("#banchaTxt").html("");
	    		}
	    	}
	    	
	    	//전체 연차 등록/수정
	    	function modifyAllAnnualCnt() {
	    		changeReason = $("#changeReason").val();
	    		annualCnt = $("#annualCnt").val();
	    		if (annualCnt == "" || annualCnt == null) {
	    			alert("<spring:message code='ezAttitude.t242' />");
	    			return;
	    		}
	    		if (annualCnt.length > 2) {
					if (annualCnt.length != 3 || annualCnt.substr(0,1) != "0") {
		    			alert("<spring:message code='ezAttitude.t263' />");
		    			return;
	    			}
	    		}
	    		if (changeReason == "" || changeReason == null) {
	    			alert("<spring:message code='ezAttitude.t243' />");
	    			return;
	    		}
	    		if($("input:checkbox[id='bancha']").is(":checked")) {
	    			annualCnt = Number(annualCnt) + 0.5;
	    		}

				$.ajax({
	   				type:"post",
	   				url:"/admin/ezAttitude/changeAllAnnual.do",
	   				dataType : "text",
	   				data:{
	   					userName : opener.searchUserName,
	   					deptName : opener.searchDeptName,
	   					title : opener.searchTitle,
	   					changeReason : changeReason,
	   					companyId : companyId,
	   					annualCnt : annualCnt
	   				},
					success : function(resultStatus) {
	            		if (resultStatus == "success") {
	   						opener.getAnnualList();
	   						window.close();
	            		} else if (resultStatus == "dive") {
	            			alert("<spring:message code='ezAttitude.t263' />");
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
	            	},
	   				error : function() {
	   					alert("<spring:message code='ezAttitude.t175' />");
	   				}
	   			});
	   		}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	<spring:message code='ezAttitude.t236' />
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	        	<th style="width:200px; text-align:center"><spring:message code='ezAttitude.t246' /></th>
	            <td>
	            	<input id="annualCnt" name="annualCnt" type="text" style="width:30px;padding-bottom: 5px;text-align: right;" value="" maxlength="2">
	            	<label id="banchaTxt"></label><spring:message code='ezAttitude.t68' />
	            	<span style="width:100px;padding-right: 30px;"></span>
	            	<input type="checkbox" id="bancha" name="bancha" onchange="setBancha();">
	            	<label for="bancha"><spring:message code='ezAttitude.t247' /></label>
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center"><spring:message code='ezAttitude.t248' /></th>
	            <td>
	            	<input id="changeReason" name="changeReason" type="text" style="width:100%;padding-bottom: 5px;" value="">
	            </td>
	        </tr>
	    </table>
	    <br/>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="modifyAllAnnualCnt();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>