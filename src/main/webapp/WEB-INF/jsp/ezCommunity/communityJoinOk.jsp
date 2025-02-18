<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

	<%-- 2018-06-08 홍승비 - 도달 불가능 코드 주석처리 --%>
	<%-- 가입하기 팝업에서 bCanJoin은 무조건 true값을 가진다. (초기 가입신청 시 userlevel/permit은 null이기 때문) --%>
	<%--
	<c:if test="${bCanJoin != 'true' }">
		<c:choose>
			<c:when test="${userLevel == '1' || userLevel == '4' }">
				<script type="text/javascript">
					alert("<c:out value = '${userInfo.displayName}' /><spring:message code = 'ezCommunity.t1082' />");
					history.go(-1);
					self.close();
				</script>
			</c:when>
			
			<c:when test="${userLevel == '0'}">
				<script type="text/javascript">
					alert("<c:out value = '${userInfo.displayName}' /><spring:message code = 'ezCommunity.t1083' />");
					history.go(-1);
					self.close();
				</script>
			</c:when>
			
			<c:otherwise>
				<c:choose>
					<c:when test="${userLevel == '3' }">
						<script type="text/javascript">
							alert("<c:out value = '${userInfo.displayName}' /><spring:message code = 'ezCommunity.t1084' />");
							self.close();
						</script>
					</c:when>
					
					<c:otherwise>
						<script type="text/javascript">
							alert("<spring:message code = 'ezCommunity.t889' />");
							self.close();
						</script>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:if>
	--%>
	
	<%--
	<c:if test="${cID != ''}">
	--%>
		<c:choose>
			<%-- 자동 가입 유형의 신청 결과 팝업 --%>
			<c:when test="${clubVO.c_ClubConfirmType =='1' || clubVO.c_ClubConfirmType == '2'}">
				<html>
					<head>
						<title><spring:message code = 'ezCommunity.t1085' /></title>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
						<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
						<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
						<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
						<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
						<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>					
						<%--
						<c:choose>
							<c:when test="${clubVO.c_MemberCnt < 0 }">
								<script type="text/javascript">
									if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		
									    window.onblur = function () {
									        window.focus();
									    }
									}
									
									 var UserAgentState = navigator.userAgent.toLowerCase();
	
									 if (CrossYN()) {
							        	if (UserAgentState.indexOf("chrome") > 0) {
							        		window.resizeTo(340, 260);
							        	} else {
							        		window.resizeTo(346, 270);
							        	}
							        } else {
							        	if (UserAgentState.indexOf("firefox") != -1) {
							                window.resizeTo(349, 279);
							            } else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
							                window.resizeTo(346, 243);
							            } else {
							            	window.resizeTo(346, 270);
							            }
							        }
							        
							        if (MACSAFARIYN()) {
							            window.resizeTo(330, 251);
							        }
									
									function goclub(a)
									{
										alert("<spring:message code = 'ezCommunity.t1086' />");
									    if(window.opener.window.parent.frames.left.location == undefined)
									        window.opener.location.reload();
									    else
									        window.opener.window.parent.frames.left.location.reload();
										window.close();
										self.close();
									}
													
									function window_onunload()
									{
										try{
										    window.opener.location.reload();
										}catch(e){}	
									}
								</script>
							</c:when>
					
							<c:otherwise> 
							 --%>
								<script type="text/javascript">
									function refresh()
									{
										/* try{
										    if(window.opener.window.parent.frames.left.location == undefined) */
										        window.opener.location.reload();
										/*     else
										        window.opener.window.parent.frames.left.location.reload();
											window.close();
										}catch(e){
											window.close();
										} */
										        self.close();
									}
									/* window.onunload = function ()
									{	
										try{
										    if(window.opener.window.parent.frames.left.location == undefined)
										        window.opener.location.reload();
										    else
										        window.opener.window.parent.frames.left.location.reload();
										}catch(e){}
									} */
									
									window.onload = function(){
									    if ("${userInfo.lang}" != '3') {
									    	//2018-07-04 김보미 - 커뮤니티명 길 경우 처리
// 									        document.getElementById("pMessageContent").innerHTML = "<c:out value = '${userInfo.displayName1}' />" + "<spring:message code = 'ezCommunity.t1087' />" + "<br />(" + "<c:out value = '${clubVO.c_ClubName}' />" + ")</span>Community" + "<spring:message code = 'ezCommunity.t1088' />" + "<br />" + "<spring:message code = 'ezCommunity.t1089' />";
									        document.getElementById("pMessageContent").innerHTML = "<c:out value = '${userInfo.lang eq 1? userInfo.displayName1 : userInfo.displayName2}' />" + "<spring:message code = 'ezCommunity.t1087' />" + "<br /> <span id='clubName'>(" + "<c:out value = '${clubVO.c_ClubName}' />" + ")</span> &nbsp;Community" + "<spring:message code = 'ezCommunity.t1088' />" + "<br />" + "<spring:message code = 'ezCommunity.t1089' />";
									    	var clubName = "<c:out value = '${clubVO.c_ClubName}' />";
									    	if (getByteLength(clubName) > 50) {
									    		$("#clubName").css({"width":"305px","display":"inline-block", "overflow":"hidden", "text-overflow":"ellipsis", "white-space":"nowrap", "margin-bottom":"-5px" });
									    		$("#clubName").attr("title", clubName);
									    	}
									    }
									    else {
									        document.getElementById("pMessageContent").innerHTML = "<spring:message code = 'ezCommunity.t1089' />";
									    }
		
								/* 2018-06-08 홍승비 - 커뮤니티 가입(결과) 팝업 리사이즈 미사용 주석처리 */
								 /* var UserAgentState = navigator.userAgent.toLowerCase();
										
										if (CrossYN()) {
								        	if (UserAgentState.indexOf("chrome") > 0) {
								        		window.resizeTo(346, 270);
								        	} else {
								        		window.resizeTo(346, 270);
								        	}
								        } else {
								        	if (UserAgentState.indexOf("firefox") != -1) {
								                window.resizeTo(349, 279);
								            } else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
								                window.resizeTo(346, 243);
								            } else {
								            	window.resizeTo(346, 270);
								            }
								        }
								        
								        if (MACSAFARIYN()) {
								            window.resizeTo(330, 251);
								        } */
									}
									//2018-07-04 김보미 - 커뮤니티명 길 경우 처리
									//문자열  byte수 구하는 함수
									function getByteLength(s,b,i,c){
										for(b=i=0; c=s.charCodeAt(i++); b+=c>>11?3:c>>7?2:1);
										return b;
									}
								</script>
						<%--	
							</c:otherwise>
						</c:choose>
						--%>
					</head>
				</c:when>

			<%-- 승인 후 가입 유형의 신청 결과 팝업 --%>
			<c:otherwise>
				<html>
					<head>
						<title><spring:message code = 'ezCommunity.t1091' /></title>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
						<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
						<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
						<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
						<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
						<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>							
						<script type="text/javascript">
							function refresh() {
							    //if(window.opener.window.parent.frames.left.location == undefined)
							    //{
				                window.opener.location.reload();
							    //}
							    //else
							    //{
							    //    if(window.opener.window.parent.frames.left != undefined || window.opener.window.parent.frames.left != null)
							    //        window.opener.window.parent.frames.left.location.reload();
							    //}

								self.close();
							}
							
							//window.onunload = function() {
							    //if(window.opener.window.parent.frames.left.location == undefined)
							    //    window.opener.location.reload();
							    //else
							    //{
							    //    if(window.opener.window.parent.frames.left != undefined || window.opener.window.parent.frames.left != null)
							    //        window.opener.window.parent.frames.left.location.reload();
							    //}
							//}

							window.onload = function() {
								//2018-07-04 김보미 - 커뮤니티명 길 경우 처리
// 							    document.getElementById("pMessageContent").innerHTML = "<c:out value = '${clubVO.c_ClubName}' />" + " Community" + "<spring:message code = 'ezCommunity.t1093' />"  + "<spring:message code = 'ezCommunity.t1094' />" + "<br />" + "<spring:message code = 'ezCommunity.t1095' />";
							    document.getElementById("pMessageContent").innerHTML = "<span id='clubName'><c:out value = '${clubVO.c_ClubName}' /></span>" + " <spring:message code='ezCommunity.t1529'/>" + "<spring:message code = 'ezCommunity.t1093' />"  + "<spring:message code = 'ezCommunity.t1094' />" + "<br />" + "<spring:message code = 'ezCommunity.t1095' />";
							    
							    var clubName = "<c:out value = '${clubVO.c_ClubName}' />";
							    if (getByteLength(clubName) > 50) {
						    		$("#clubName").css({"width":"305px","display":"inline-block", "overflow":"hidden", "text-overflow":"ellipsis", "white-space":"nowrap", "margin-bottom":"-5px" });
						    		$("#clubName").attr("title", clubName);
						    	}
							    
							/* 2018-06-08 홍승비 - 커뮤니티 가입(결과) 팝업 리사이즈 미사용 주석처리 */
							/* var UserAgentState = navigator.userAgent.toLowerCase();
						        
						         if (CrossYN()) {
						        	if (UserAgentState.indexOf("chrome") > 0) {
						        		window.resizeTo(340, 260);
						        	} else {
						        		window.resizeTo(346, 270);
						        	}
						        } else {
						        	if (UserAgentState.indexOf("firefox") != -1) {
						                window.resizeTo(349, 279);
						            } else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
						                window.resizeTo(346, 243);
						            } else {
						            	window.resizeTo(346, 270);
						            }
						        }
						        if (MACSAFARIYN()) {
						            window.resizeTo(330, 251);
						        } */
							}
							//2018-07-04 김보미 - 커뮤니티명 길 경우 처리
							//문자열  byte수 구하는 함수
							function getByteLength(s,b,i,c){
								for(b=i=0; c=s.charCodeAt(i++); b+=c>>11?3:c>>7?2:1);
								return b;
							}
						</script>
					</head>
				</c:otherwise>
			</c:choose>
					
					<body style="overflow:hidden;">
						<div class="popup_noti">
						    <div class="popup_noti_title" style="height:10px;">
						    	<span class="tl"></span>
						    	<span class="tr"></span>
						    </div>
						    
					 	    <div class="popup_noti_content">
				            	<div  style="padding:10px;">
					          		<table>
					            		<tr>
					              			<td class="cimg"></td>
					              			<td class="ctxt"><span id="pMessageContent"></span></td>
					            		</tr>
					     			</table>
					 	    	</div>
					        </div>
					        
					    	<div class="popup_noti_btnarea"> 
						   	    <div class="btnposition" style="padding-top:0px;"> 
						            <input type="submit" value="<spring:message code = 'ezCommunity.t245' />" onClick="refresh()">
							    </div>
							    
					    		<span class="bl"></span>
					    		<span class="br"></span>
					    	</div>
					    </div>
					</body>
				</html>
	<%--
	</c:if>
	 --%>