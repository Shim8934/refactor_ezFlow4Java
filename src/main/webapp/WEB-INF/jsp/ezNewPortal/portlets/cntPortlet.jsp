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
<%-- <input type="hidden" id="useQuestionValue" value="${useQuestion}"> --%>
<input type="hidden" id="useSurveyValue" value="${useSurvey}">

<%-- 2023-06-08 홍승비 - 디자인 개선을 위해 테마3 카운트 포틀릿 분리 및 구조 변경 --%>
<c:choose>
	<c:when test="${usedTheme eq 3}">
	<article class="box_shadow">
		<div class="layDIV">
	     	 <ul class="quick_ul">
	     	 	<%-- 받은메일 --%>
				<li id="NewMail3" class="theme3CntLi">
					<c:choose>
						<c:when test="${useMail eq 'NO'}">
						<dl class="writebannerIcon">
                   			<dt class="iconCircle icon"><span class="iconCommon"></span></dt>
							<dt class="txt">&nbsp;</dt>
						</dl>
                   		</c:when>
	                 	<c:otherwise>
							<div>
								<div class="quick_img">
									<span class="quick_icon1"></span>
									<span class="quick_num">
										<c:choose>
						                 	<c:when test="${unreadMailCount eq 0}">0</c:when>
						                 	<c:when test="${unreadMailCount > 999}">999+</c:when>
						                 	<c:otherwise>${unreadMailCount}</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="quick_txt"><spring:message code='ezNewPortal.gu1' /></div>
							</div>
						</c:otherwise>
					</c:choose>
				</li>
				
				<%-- 오늘일정 --%>
				<li id="Schedule3" class="theme3CntLi">
					<c:choose>
						<c:when test="${useSchedule eq 'NO'}">
						<dl class="writebannerIcon">
							<dt class="iconCircle"><span class="iconCommon"></span></dt>
							<dt class="iconText"></dt>
						</dl>
						</c:when>
						<c:otherwise>
							<div>
								<div class="quick_img">
									<span class="quick_icon2"></span>
									<span class="quick_num">
										<c:choose>
											<c:when test="${scheduleCount eq 0}">0</c:when>
											<c:when test="${scheduleCount > 999}">999+</c:when>
											<c:otherwise>${scheduleCount}</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="quick_txt"><spring:message code='ezNewPortal.gu3'/></div>
							</div>
						</c:otherwise>
					</c:choose>
				</li>
				
				<%-- 전자설문 --%>
				<li id="Survey3" class="theme3CntLi">
					<c:choose>
						<c:when test="${useSurvey eq 'NO'}">
						<dl class="writebannerIcon">
							<dt class="iconCircle"><span class="iconCommon"></span></dt>
							<dt class="iconText"></dt>
						</dl>
						</c:when>
						<c:otherwise>
							<div>
								<div class="quick_img">
									<span class="quick_icon3"></span>
									<span class="quick_num">
										<c:choose>
											<c:when test="${unResponseIngSurveyCnt eq 0}">0</c:when>
											<c:when test="${unResponseIngSurveyCnt > 999}">999+</c:when>
											<c:otherwise>${unResponseIngSurveyCnt}</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="quick_txt"><spring:message code='ezNewPortal.gu4'/></div>
							</div>
						</c:otherwise>
					</c:choose>
				</li>
				
				<%-- 회람판 --%>
				<li id="Circular3" class="theme3CntLi">
					<c:choose>
						<c:when test="${useCircular eq 'NO'}">
						<dl class="writebannerIcon">
							<dt class="iconCircle"><span class="iconCommon"></span></dt>
							<dt class="iconText"></dt>
						</dl>
						</c:when>
						<c:otherwise>
							<div>
								<div class="quick_img">
									<span class="quick_icon4"></span>
									<span class="quick_num">
										<c:choose>
											<c:when test="${circularCount eq 0}">0</c:when>
											<c:when test="${circularCount > 999}">999+</c:when>
											<c:otherwise>${circularCount}</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="quick_txt"><spring:message code='ezNewPortal.gu5'/></div>
							</div>
						</c:otherwise>
					</c:choose>
				</li>
				
				<%-- 결재할문서 --%>
				<li id="AprSign3" class="theme3CntLi">
					<c:choose>
	                 	<c:when test="${useApproval eq 'NO'}">
	                 	<dl class="writebannerIcon">
                   			 <dt class="iconCircle icon"><span class="iconCommon"></span></dt>
			                 <dt class="txt">&nbsp;</dt>
						</dl>
                   		</c:when>
	                 	<c:otherwise>
							<div>
		                        <div class="quick_img">
		                            <span class="quick_icon5"></span>
		                            <span class="quick_num">
			                            <c:choose>
						                 	<c:when test="${approvalCount eq 0}">0</c:when>
						                 	<c:when test="${approvalCount > 999}">999+</c:when>
						                 	<c:otherwise>${approvalCount}</c:otherwise>
					                 	</c:choose>
		                            </span>
		                        </div>
		                        <div class="quick_txt"><spring:message code='ezNewPortal.gu2'/></div>
		                    </div>
						</c:otherwise>
					</c:choose>
				</li>
				
	            <%-- 진행문서 --%>
	            <li id="AprProcessing" class="theme3CntLi">
					<c:choose>
						<c:when test="${useApproval eq 'NO'}">
						<dl class="writebannerIcon">
							<dt class="iconCircle"><span class="iconCommon"></span></dt>
							<dt class="iconText"></dt>
						</dl>
						</c:when>
						<c:otherwise>
							<div>
								<div class="quick_img">
									<span class="quick_icon6"></span>
									<span class="quick_num">
										<c:choose>
											<c:when test="${approvalProgressingCount eq 0}">0</c:when>
											<c:when test="${approvalProgressingCount > 999}">999+</c:when>
											<c:otherwise>${approvalProgressingCount}</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="quick_txt"><spring:message code='ezNewPortal.gu6'/></div>
							</div>
						</c:otherwise>
					</c:choose>
				</li>
				
				<%-- 기안문서 --%>
				<li id="AprDraft" class="theme3CntLi">
					<c:choose>
						<c:when test="${useApproval eq 'NO'}">
						<dl class="writebannerIcon">
							<dt class="iconCircle"><span class="iconCommon"></span></dt>
							<dt class="iconText"></dt>
						</dl>
						</c:when>
						<c:otherwise>
							<div>
								<div class="quick_img">
									<span class="quick_icon7"></span>
									<span class="quick_num">
										<c:choose>
											<c:when test="${approvalDraftCount eq 0}">0</c:when>
											<c:when test="${approvalDraftCount > 999}">999+</c:when>
											<c:otherwise>${approvalDraftCount}</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="quick_txt"><spring:message code='ezNewPortal.gu7'/></div>
							</div>
						</c:otherwise>
					</c:choose>
				</li>
				
				<%-- 부서수신함 --%>
				<li id="AprDeptSusin" class="theme3CntLi">
					<c:choose>
						<c:when test="${useApproval eq 'NO'}">
						<dl class="writebannerIcon">
							<dt class="iconCircle"><span class="iconCommon"></span></dt>
							<dt class="iconText"></dt>
						</dl>
						</c:when>
						<c:otherwise>
							<div>
								<div class="quick_img">
									<span class="quick_icon8"></span>
									<span class="quick_num">
										<c:choose>
											<c:when test="${approvalDeptSusinCount eq 0}">0</c:when>
											<c:when test="${approvalDeptSusinCount > 999}">999+</c:when>
											<c:otherwise>${approvalDeptSusinCount}</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="quick_txt"><spring:message code='ezNewPortal.gu8'/></div>
							</div>
						</c:otherwise>
					</c:choose>
				</li>
			</ul>
		</div>
	</article>
	</c:when>
	<c:otherwise>
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
	                 	<%-- 
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
	                      --%>
	                 	<dl id="Survey3" class="writebannerIcon">
	                         <c:choose>
	                         	<c:when test="${useSurvey eq 'NO'}">
	                     			<dt class="iconCircle"><span class="iconCommon"></span></dt>
	                        		<dt class="iconText"></dt>
	                     		</c:when>
	                         	<c:otherwise>
			                     	 <dt class="iconCircle iconcVote"><span class="iconCommon iconVote"></span></dt>
			                         <dt class="iconText"><spring:message code='ezNewPortal.gu4' /></dt>
			                         <c:choose>
					                 	<c:when test="${unResponseIngSurveyCnt eq 0}">
					                 		<dd class="count countZero">0</dd>
					                 	</c:when>
					                 	<c:when test="${unResponseIngSurveyCnt > 999}">
					                 		<dd class="count">999+</dd>
					                 	</c:when>
					                 	<c:otherwise>
							            	<dd class="count">${unResponseIngSurveyCnt }</dd>
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
	</c:otherwise>
</c:choose>
</body>
</html>