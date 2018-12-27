<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			전체 연차 등록/수정
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">	
	    	var flagCheck = 'change';
	    	var companyId = "<c:out value="${companyId}" />";
	    	var changeReason = '';
	    	var annualCnt = '';
	    	var searchYear = opener.$("#searchYear").val();
	    
	    	$(document).ready(function(){
		    	$("input:text[name=annualCnt]").on("keyup", function() {
		    	    $(this).val($(this).val().replace(/[^0-9]/g,""));
		    	});
   			});
	    	
	    	function setFlagCheck(){
	    		flagCheck = $("input:radio[name=flagCheck]:checked").val();
		    }
	    	 
	    	
	    	//전체 연차 등록/수정
	    	function modifyAllAnnualCnt() {
	    		changeReason = $("#changeReason").val();
	    		annualCnt = $("#annualCnt").val();
	    		if (annualCnt == "" || annualCnt == null) {
	    			alert("연차수 입력");
	    			return;
	    		}
	    		if (changeReason == "" || changeReason == null) {
	    			alert("수정사유입력");
	    			return;
	    		}

				$.ajax({
	   				type:"post",
	   				url:"/admin/ezAttitude/changeAllAnnual.do",
	   				dataType : "text",
	   				data:{
	   					year : searchYear,
	   					changeReason : changeReason,
	   					companyId : companyId,
	   					flagCheck : flagCheck,
	   					annualCnt : annualCnt
	   				},
					success : function(resultStatus) {
	            		if (resultStatus == "success") {
	   						opener.location.reload();
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
	    	전체 연차 등록/수정
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center" rowspan="2">총 연차수</th>
	            <td>
	            	<input name="flagCheck" id="Radio1" type="radio" value="change" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="setFlagCheck();"/><label for="Radio1">&nbsp;총 연차수를 변경하기</label>
	            </td>
	        </tr>
	        <tr>
	            <td>
					<input name="flagCheck" id="Radio2" type="radio" value="plus" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="setFlagCheck();"/><label for="Radio2">&nbsp;현재 총 연차수에서 더하기</label>
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center">연차수</th>
	            <td>
	            	<input id="annualCnt" name="annualCnt" type="text" style="width:100%" value="" maxlength="3">
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center">수정사유</th>
	            <td>
	            	<textarea rows="5" id="changeReason" style="height: 100px; width:338px; resize:none; overflow: auto;" ></textarea>
	            </td>
	        </tr>
	    </table>
	    <br/>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="modifyAllAnnualCnt();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>