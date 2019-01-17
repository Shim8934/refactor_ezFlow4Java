<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<input type="hidden" id="useCircularValue" value="${useCircular}">
<input type="hidden" id="useMailValue" value="${useMail}">
<input type="hidden" id="useApprovalValue" value="${useApproval}">
<input type="hidden" id="useScheduleValue" value="${useSchedule}">
<input type="hidden" id="useQuestionValue" value="${useQuestion}">
	<article class="writebanner box_shadow">
		<div class="layDIV">
	     	<div class="writebanner_leftContents">
	         	<dl id="NewMail3" class="mail">
	                 <c:choose>
	                 	<c:when test="${useMail eq 'NO'}">
                   			<dt class="iconCircle icon"><span class="iconCommon"></span></dt>
			                 <dt class="txt">&nbsp;</dt>
                   		</c:when>
	                 	<c:otherwise>
			             	 <dt class="icon"><span class="icon_mail"></span></dt>
			                 <dt class="txt"><spring:message code='ezNewPortal.gu1' /></dt>
			                 <c:choose>
			                 	<c:when test="${unreadMailCount eq 0}">
			                 		<dd class="count countZero">0</dd>
			                 	</c:when>
			                 	<c:when test="${unreadMailCount > 999}">
			                 		<dd class="count">999+</dd>
			                 	</c:when>
			                 	<c:otherwise>
					            	<dd class="count">${unreadMailCount }</dd>
			                 	</c:otherwise>
			                 </c:choose>
	                 	</c:otherwise>
	                 </c:choose>
	             </dl>
	             <dl id="AprSign3" class="work">
	                 <c:choose>
	                 	<c:when test="${useApproval eq 'NO'}">
                   			 <dt class="iconCircle icon"><span class="iconCommon"></span></dt>
			                 <dt class="txt">&nbsp;</dt>
                   		</c:when>
	                 	<c:otherwise>
			             	 <dt class="icon"><span class="icon_approval"></span></dt>
			                 <dt class="txt"><spring:message code='ezNewPortal.gu2' /></dt>
			                 <c:choose>
			                 	<c:when test="${approvalCount eq 0}">
			                 		<dd class="count countZero">0</dd>
			                 	</c:when>
			                 	<c:when test="${approvalCount > 999}">
			                 		<dd class="count">999+</dd>
			                 	</c:when>
			                 	<c:otherwise>
					            	<dd class="count">${approvalCount }</dd>
			                 	</c:otherwise>
			                 </c:choose>
	                 	</c:otherwise>
	                 </c:choose>
	             </dl>
	         </div>
	         <div class="writebanner_rightContents">
	         	<ul class="writebannerTop sortablePortlet">
	                 <li>
	                 	<dl id="Schedule3" class="writebannerIcon">
	                         <c:choose>
	                         	<c:when test="${useSchedule eq 'NO'}">
	                     			<dt class="iconCircle"><span class="iconCommon"></span></dt>
	                        		<dt class="iconText"></dt>
	                     		</c:when>
	                         	<c:otherwise>
			                     	 <dt class="iconCircle iconcSchedule"><span class="iconCommon iconSchedule"></span></dt>
			                         <dt class="iconText"><spring:message code='ezNewPortal.gu3' /></dt>
			                         <c:choose>
					                 	<c:when test="${scheduleCount eq 0}">
					                 		<dd class="count countZero">0</dd>
					                 	</c:when>
					                 	<c:when test="${scheduleCount > 999}">
					                 		<dd class="count">999+</dd>
					                 	</c:when>
					                 	<c:otherwise>
							            	<dd class="count">${scheduleCount }</dd>
					                 	</c:otherwise>
					                 </c:choose>
	                         	</c:otherwise>
	                         </c:choose>
	                     </dl>
	                 </li>	                 
	                 <li>
	                 	<dl id="Poll3" class="writebannerIcon">
	                         <c:choose>
	                         	<c:when test="${useQuestion eq 'NO'}">
	                     			<dt class="iconCircle"><span class="iconCommon"></span></dt>
	                        		<dt class="iconText"></dt>
	                     		</c:when>
	                         	<c:otherwise>
			                     	 <dt class="iconCircle iconcVote"><span class="iconCommon iconVote"></span></dt>
			                         <dt class="iconText"><spring:message code='ezNewPortal.gu4' /></dt>
			                         <c:choose>
					                 	<c:when test="${pollCount eq 0}">
					                 		<dd class="count countZero">0</dd>
					                 	</c:when>
					                 	<c:when test="${pollCount > 999}">
					                 		<dd class="count">999+</dd>
					                 	</c:when>
					                 	<c:otherwise>
							            	<dd class="count">${pollCount }</dd>
					                 	</c:otherwise>
					                 </c:choose>
	                         	</c:otherwise>
	                         </c:choose>
	                     </dl>
	                 </li>
	             	<li>
	                 	<dl id="Circular3" class="writebannerIcon">
	                     	<c:choose>
	                     		<c:when test="${useCircular eq 'NO'}">
	                     			<dt class="iconCircle"><span class="iconCommon"></span></dt>
	                        		<dt class="iconText"></dt>
	                     		</c:when>
	                     		<c:otherwise>
			                     	 <dt class="iconCircle iconcBoard"><span class="iconCommon iconBoard"></span></dt>
			                         <dt class="iconText"><spring:message code='ezNewPortal.gu5' /></dt>
			                         <c:choose>
					                 	<c:when test="${circularCount eq 0}">
					                 		<dd class="count countZero">0</dd>
					                 	</c:when>
					                 	<c:when test="${circularCount > 999}">
					                 		<dd class="count">999+</dd>
					                 	</c:when>
					                 	<c:otherwise>
							            	<dd class="count">${circularCount }</dd>
					                 	</c:otherwise>
					                 </c:choose>
	                     		</c:otherwise>
	                     	</c:choose>
	                     </dl>
	                 </li>
	             </ul>
	             <ul class="writebannerBottom">
	                 <li>
	                 	<dl id="AprProcessing" class="writebannerIcon">
	                         <c:choose>
	                         	<c:when test="${useApproval eq 'NO'}">
		                   			<dt class="iconCircle"><span class="iconCommon"></span></dt>
		                      		<dt class="iconText"></dt>
		                   		</c:when>
	                         	<c:otherwise>
			                         <dt class="iconCircle iconcToward"><span class="iconCommon iconToward"></span></dt>
			                         <dt class="iconText"><spring:message code='ezNewPortal.gu6' /></dt>
			                         <c:choose>
					                 	<c:when test="${approvalProgressingCount eq 0}">
					                 		<dd class="count countZero">0</dd>
					                 	</c:when>
					                 	<c:when test="${approvalProgressingCount > 999}">
					                 		<dd class="count">999+</dd>
					                 	</c:when>
					                 	<c:otherwise>
							            	<dd class="count">${approvalProgressingCount }</dd>
					                 	</c:otherwise>
					                 </c:choose>
	                         	</c:otherwise>
	                         </c:choose>
	                     </dl>
	                 </li>
	                 <li>
	                 	<dl id="AprDraft" class="writebannerIcon">
	                         <c:choose>
	                         	<c:when test="${useApproval eq 'NO'}">
		                   			<dt class="iconCircle"><span class="iconCommon"></span></dt>
		                      		<dt class="iconText"></dt>
		                   		</c:when>
	                         	<c:otherwise>
			                     	 <dt class="iconCircle iconcReturn"><span class="iconCommon iconReturn"></span></dt>
			                         <dt class="iconText"><spring:message code='ezNewPortal.gu7' /></dt>
			                         <c:choose>
					                 	<c:when test="${approvalDraftCount eq 0}">
					                 		<dd class="count countZero">0</dd>
					                 	</c:when>
					                 	<c:when test="${approvalDraftCount > 999}">
					                 		<dd class="count">999+</dd>
					                 	</c:when>
					                 	<c:otherwise>
							            	<dd class="count">${approvalDraftCount }</dd>
					                 	</c:otherwise>
					                 </c:choose>
	                         	</c:otherwise>
	                         </c:choose>
	                     </dl>
	                 </li>
	                 <li>
	                 	<dl id="AprDeptSusin" class="writebannerIcon">
	                         <c:choose>
	                         	<c:when test="${useApproval eq 'NO'}">
		                   			<dt class="iconCircle"><span class="iconCommon"></span></dt>
		                      		<dt class="iconText"></dt>
		                   		</c:when>
	                         	<c:otherwise>
			                     	 <dt class="iconCircle iconcReceive"><span class="iconCommon iconReceive"></span></dt>
			                         <dt class="iconText"><spring:message code='ezNewPortal.gu8' /></dt>
			                         <c:choose>
					                 	<c:when test="${approvalDeptSusinCount eq 0}">
					                 		<dd class="count countZero">0</dd>
					                 	</c:when>
					                 	<c:when test="${approvalDeptSusinCount >= 999}">
					                 		<dd class="count">999+</dd>
					                 	</c:when>
					                 	<c:otherwise>
							            	<dd class="count">${approvalDeptSusinCount }</dd>
					                 	</c:otherwise>
					                 </c:choose>
	                         	</c:otherwise>
	                         </c:choose>
	                     </dl>
	                 </li>
	             </ul>
	         </div>
		</div>
	</article>
</body>
</html>