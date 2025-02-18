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
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
	    		text-overflow : ellipsis;
	    		text-align:center;
				word-break:keep-all;
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
		    	
		    	if ($("#contentlist tr").length > 13) { //스크롤이 생길 경우 처리
		    		var addTh = "<th class='borderRight' style='width: 0.5%;'></th>";
		    		$(".mainlist tr th:eq(4)").after(addTh);
		    		$(".mainlist tr th:eq(4)").removeClass("borderRight");
		    	}
		    	
	    		//리스트가 10개이고 ie일경우 하단의 테이블 border가 보이지 않는 현상때문에 추가.
	    		if ($("#contentlist tr").length == 10 && navigator.userAgent.toUpperCase().indexOf("CHROME") == -1) {
	    			$("#contentlist").css("border-bottom","1px solid #e2e3e6");
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
	         		<th class="borderLeft" style="width:17%;text-align:center;"><spring:message code='ezAttitude.t63' /></th>
	            	<th class="borderLeft" style="width:18%;text-align:center;"><spring:message code='ezAttitude.t250' /></th>
	            	<th class="borderLeft" style="width:20%;text-align:center;"><spring:message code='ezAttitude.t251' /></th>
	            	<th class="borderLeft" style="width:33%;text-align:center;padding-left: 10px;"><spring:message code='ezAttitude.t248' /></th>
	            	<th class="borderLeft borderRight" style="width:10%;text-align:center;"><spring:message code='ezAttitude.t62' /></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="width: 100%;height: 404px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
	                <c:choose>
			    		<c:when test="${not empty resultList }">
					    	<c:forEach items="${resultList }" var="list">
					        	<tr>
					            	<td class="borderLeft" style="width:17%;">
					            		${list.changeDate}
				        	    	</td>
					            	<td class="borderLeft" style="width:18%;">
					        	    	<c:set var="originAnnualLastCnt" value="${fn:split(list.originAnnualCnt,'.')[1]}" />
					        	    	<c:if test="${originAnnualLastCnt == 0 }">
					        	    		${fn:split(list.originAnnualCnt,'.')[0]}<spring:message code='ezAttitude.t68' />
					        	    	</c:if>
					        	    	<c:if test="${originAnnualLastCnt == 5 }">
						            		${list.originAnnualCnt}<spring:message code='ezAttitude.t68' />
					        	    	</c:if>
					        	    	<c:if test="${originAnnualLastCnt == null }">
						            		${list.originAnnualCnt}<spring:message code='ezAttitude.t68' />
					        	    	</c:if>
				        	    	</td>
					            	<td class="borderLeft" style="width:20%;">
					        	    	<c:set var="changeAnnualLastCnt" value="${fn:split(list.changeAnnualCnt,'.')[1]}" />
					        	    	<c:if test="${changeAnnualLastCnt == 0 }">
					        	    		${fn:split(list.changeAnnualCnt,'.')[0]}<spring:message code='ezAttitude.t68' />
					        	    	</c:if>
					        	    	<c:if test="${changeAnnualLastCnt == 5 }">
						            		${list.changeAnnualCnt}<spring:message code='ezAttitude.t68' />
					        	    	</c:if>
					        	    	<c:if test="${changeAnnualLastCnt == null }">
						            		${list.changeAnnualCnt}<spring:message code='ezAttitude.t68' />
					        	    	</c:if>
				        	    	</td>
					            	<td class="borderLeft" style="width:33%;text-align: left;padding-left: 10px;" title="${list.changeReason}">
					            		${list.changeReason}
				        	    	</td>
					            	<td class="borderLeft borderRight" style="width:10%;">
					            		${list.changeUserName}
					            		<c:if test= "${list.changeUserName == null || list.changeUserName == ''}">
					            			${list.changeUserId }
					            		</c:if>
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