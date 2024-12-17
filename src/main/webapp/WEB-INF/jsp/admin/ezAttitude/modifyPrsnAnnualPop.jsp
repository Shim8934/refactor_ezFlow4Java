<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t249' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">	
	    	var companyId = "<c:out value="${companyId}" />";
	    	var changeReason = '';
	    	var additionalAnnualCnt = "<c:out value="${additionalAnnualCnt}" />";
	    	var annualCnt = "";
	    	var userId = "<c:out value="${userId}" />";
	    
	    	$(document).ready(function(){
		    	$("input:text[name=additionalAnnualCnt]").on("keyup", function() {
		    	    $(this).val($(this).val().replace(/[^0-9]/g,""));
		    	});
		    	
		    	if(additionalAnnualCnt == null || additionalAnnualCnt == "") {
		    		additionalAnnualCnt = 0;
		    	} else if(additionalAnnualCnt % 1 == 0.5) {
		    		$("input:checkbox[id='bancha']").prop('checked', true);
		    		setBancha();
		    		additionalAnnualCnt = additionalAnnualCnt - 0.5
		    	}
		    	
		    	additionalAnnualCnt = Number(additionalAnnualCnt);
		    	
		    	$("#additionalAnnualCnt").val(additionalAnnualCnt);
   			});
	    	
	    	function setBancha() {
	    		if($("input:checkbox[id='bancha']").is(":checked")) {
	    			$("#banchaTxt").html(".5");
	    		} else {
	    			$("#banchaTxt").html("");
	    		}
	    	}
	    	
	    	//전체 연차 등록/수정
	    	function modifyPrsnAnnualCnt() {
	    		changeReason = $("#changeReason").val();
	    		annualCnt = $("#additionalAnnualCnt").val();
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
	   				url:"/admin/ezAttitude/changePrsnAnnual.do",
	   				dataType : "text",
	   				data:{
	   					changeReason : changeReason,
	   					companyId : companyId,
	   					annualCnt : annualCnt,
	   					userId : userId,
	   					flagCheck : "additionalChange"
	   				},
					success : function(resultStatus) {
	            		if (resultStatus == "success") {
	   						opener.getAnnualList();
	   						window.close();
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
	    	<spring:message code='ezAttitude.t249' />
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezAttitude.t10' /></th>
	            <td>
	            	${userName}
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezAttitude.t11' /></th>
	            <td>
	            	${userTitle}
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezAttitude.t9' /></th>
	            <td>
	            	${userDeptName}
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center"><spring:message code='ezAttitude.kje33' /></th>
	            <td>
	            	<input id="additionalAnnualCnt" name="additionalAnnualCnt" type="text" style="width:30px;text-align:right;padding-bottom: 5px;" value="" maxlength="3">
	            	<label id="banchaTxt"></label><spring:message code='ezAttitude.t68' />
	            	<span style="width:100px;padding-right: 30px;"></span>
	            	<input type="checkbox" id="bancha" name="bancha" onchange="setBancha();">
	            	<label for="bancha"><spring:message code='ezAttitude.t247' /></label>
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center"><spring:message code='ezAttitude.t248' /></th>
	            <td>
	            	<input id="changeReason" name="changeReason" type="text" style="width:100%;padding-bottom: 5px;" value="" maxlength="200">
	            </td>
	        </tr>
	    </table>
	    <br/>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="modifyPrsnAnnualCnt();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>