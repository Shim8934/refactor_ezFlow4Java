<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<spring:message code='ezAttitude.t241' />
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
	    	table.mainlist tr:not(.tr_noItems) td {
	    		table-layout : fixed;
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		text-align:center;
	    	}
	    	.mainlist tr th.borderLeft {
	    		border-left: 1px solid #e2e3e6;
	    	}
	    	.mainlist tr td.borderLeft {
	    		border-left: 1px solid #e2e3e6;
	    	}
	    	.mainlist tr th.borderRight {
	    		border-right: 1px solid #e2e3e6;
	    	}
	    	.mainlist tr td.borderRight {
	    		border-right: 1px solid #e2e3e6;
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
		    	
		    	if ($("#contentlist tr").length > 6) { //스크롤이 생길 경우 처리
		    		var addTh = "<th class='borderRight' style='width: 9px;'></th>";
		    		$(".mainlist tr th:eq(4)").after(addTh);
		    		$(".mainlist tr th:eq(4)").removeClass("borderRight");
		    		
		    		//ie일경우 #contentlist border-bottom : 1px solid #e2e3e6;
		    		if (navigator.userAgent.toUpperCase().indexOf("CHROME") == -1) {
		    			$("#contentlist").css("border-bottom","1px solid #e2e3e6");
		    		}
		    	}
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
	    			alert("<spring:message code='ezAttitude.t242' />");
	    			return;
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
	    	<spring:message code='ezAttitude.t241' />
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
        <div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
	         		<th class="borderLeft" style="width:19%;text-align:center;"><spring:message code='ezAttitude.t63' /></th>
	            	<th class="borderLeft" style="width:14%;text-align:center;"><spring:message code='ezAttitude.t250' /></th>
	            	<th class="borderLeft" style="width:14%;text-align:center;"><spring:message code='ezAttitude.t251' /></th>
	            	<th class="borderLeft" style="width:43%;text-align:center;"><spring:message code='ezAttitude.t248' /></th>
	            	<th class="borderLeft borderRight" style="width:10%;text-align:center;"><spring:message code='ezAttitude.t62' /></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 202px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
	                <c:choose>
			    		<c:when test="${not empty resultList }">
					    	<c:forEach items="${resultList }" var="list">
					        	<tr>
					            	<td class="borderLeft" style="width:19%;">
					            		${list.changeDate}
				        	    	</td>
					            	<td class="borderLeft" style="width:14%;">
					            		${list.originAnnualCnt}<spring:message code='ezAttitude.t68' />
				        	    	</td>
					            	<td class="borderLeft" style="width:14%;">
					            		${list.changeAnnualCnt}<spring:message code='ezAttitude.t68' />
				        	    	</td>
					            	<td class="borderLeft" style="width:43%;text-align: left;padding-left: 10px;" title="${list.changeReason}">
					            		${list.changeReason}
				        	    	</td>
					            	<td class="borderLeft borderRight" style="width:10%;">
					            		${list.changeUserName}
				        	    	</td>
				       	 		</tr>
					    	</c:forEach>
			    		</c:when>
			    		<c:otherwise>
	   						<tr id='List_TR_noItems' class='tr_noItems'><td colspan='5' style='text-align:center'><spring:message code='ezAttitude.t130' /></td></tr>
			    		</c:otherwise>
					</c:choose>
                </table>
            </div>
        </div>
	</body>
</html>