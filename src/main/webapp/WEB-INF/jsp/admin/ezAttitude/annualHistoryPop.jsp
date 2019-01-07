<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			수정내역확인
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<style>
			table.content {
				width:100%;
				table-layout:fixed;
				white-space:nowrap;
				overflow:hidden;
			}
	    	table.content tr:not(.tr_noItems) td {
	    		table-layout : fixed;
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		text-align:center;
	    	}
	    </style>
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
	    	수정내역확인
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	    	<thead>
		    	<tr style="background-color: rgb(255, 255, 255);">
	         	   	<th style="width:17%;text-align:center;">변경일시</th>
	            	<th style="width:15%;text-align:center;">기존 총 연차수</th>
	            	<th style="width:15%;text-align:center;">변경 총 연차수</th>
	            	<th style="text-align:center;">변경사유</th>
	            	<th style="width:10%;text-align:center;">변경자</th>
		    	</tr>
	    	</thead>
	    	<tbody>
	    		<c:choose>
		    		<c:when test="${not empty resultList }">
				    	<c:forEach items="${resultList }" var="list">
				        	<tr>
				            	<td>
				            		${list.changeDate}
			        	    	</td>
				            	<td>
				            		${list.originAnnualCnt}일
			        	    	</td>
				            	<td>
				            		${list.changeAnnualCnt}일
			        	    	</td>
				            	<td>
				            		${list.changeReason}
			        	    	</td>
				            	<td>
				            		${list.changeUserName}
			        	    	</td>
			       	 		</tr>
				    	</c:forEach>
		    		</c:when>
		    		<c:otherwise>
   						<tr id='List_TR_noItems' class='tr_noItems'><td colspan='5' style='text-align:center'><spring:message code='ezAttitude.t130' /></td></tr>
		    		</c:otherwise>
				</c:choose>
	    	</tbody>
	    </table>
	</body>
</html>