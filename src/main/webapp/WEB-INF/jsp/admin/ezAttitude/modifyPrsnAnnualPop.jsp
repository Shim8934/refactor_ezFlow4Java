<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			총 연차 등록/수정
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">	
	    	var flagCheck = 'change';
	    	var companyId = "<c:out value="${vo.companyId}" />";
	    	var changeReason = '';
	    	var totalAnnualCnt = "<c:out value="${vo.totalAnnualCnt}" />";
	    	var useAnnualCnt = "<c:out value="${vo.useAnnualCnt}" />";
	    	var annualCnt = "";
	    	var searchYear = "<c:out value="${vo.year}" />";
	    	var userId = "<c:out value="${vo.userId}" />";
	    
	    	$(document).ready(function(){
		    	$("input:text[name=totalAnnualCnt]").on("keyup", function() {
		    	    $(this).val($(this).val().replace(/[^0-9]/g,""));
		    	});
		    	
		    	if(useAnnualCnt == null || useAnnualCnt == "") {
		    		useAnnualCnt = 0;
		    	}
		    	
		    	if(totalAnnualCnt == null || totalAnnualCnt == "") {
		    		totalAnnualCnt = 0;
		    	} else if(totalAnnualCnt % 1 == 0.5) {
		    		$("input:checkbox[id='bancha']").prop('checked', true);
		    		setBancha();
		    		totalAnnualCnt = totalAnnualCnt - 0.5
		    	}
		    	
		    	useAnnualCnt = Number(useAnnualCnt);
		    	totalAnnualCnt = Number(totalAnnualCnt);
		    	
		    	$("#useAnnualCnt").html(useAnnualCnt);
		    	$("#totalAnnualCnt").val(totalAnnualCnt);
   			});
	    	
	    	function setFlagCheck(){
	    		flagCheck = $("input:radio[name=flagCheck]:checked").val();
		    }
	    	
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
	    		annualCnt = $("#totalAnnualCnt").val();
	    		if (annualCnt == "" || annualCnt == null) {
	    			alert("연차수 입력");
	    			return;
	    		}
	    		if (changeReason == "" || changeReason == null) {
	    			alert("수정사유입력");
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
	   					year : searchYear,
	   					changeReason : changeReason,
	   					companyId : companyId,
	   					annualCnt : annualCnt,
	   					userId : userId,
	   					flagCheck : flagCheck
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
	    	총 연차 등록/수정
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center">사원명</th>
	            <td>
	            	${vo.userName}
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center">직위</th>
	            <td>
	            	${vo.userTitle}
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center">사원명</th>
	            <td>
	            	${vo.userDeptName}
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center">사용 연차 수</th>
	            <td id="useAnnualCnt">
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center">총 연차수</th>
	            <td>
	            	<input id="totalAnnualCnt" name="totalAnnualCnt" type="text" style="width:30px;text-align:right;padding-bottom: 5px;" value="" maxlength="3">
	            	<label id="banchaTxt"></label>일
	            	<span style="width:100px;padding-right: 30px;"></span>
	            	<input type="checkbox" id="bancha" name="bancha" onchange="setBancha();">
	            	<label for="bancha">반차추가</label>
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center">수정사유</th>
	            <td>
	            	<input id="changeReason" name="changeReason" type="text" style="width:100%;padding-bottom: 5px;" value="">
	            </td>
	        </tr>
	    </table>
	    <br/>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="modifyPrsnAnnualCnt();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>