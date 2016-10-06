<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
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
		
		
		<c:if test="${cID != ''}">
			<c:choose>
				<c:when test="${clubVO.c_ClubConfirmType =='1' || clubVO.c_ClubConfirmType == '2'}">
					<html>
						<head>
							<title><spring:message code = 'ezCommunity.t1085' /></title>
							<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
							<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
							<script type="text/javascript" src="/js/mouseeffect.js"></script>
							<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
							
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
						            	window.resizeTo(346, 240);
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
							<script type="text/javascript">
								function goclub(a)
								{
									try{
									    if(window.opener.window.parent.frames.left.location == undefined)
									        window.opener.location.reload();
									    else
									        window.opener.window.parent.frames.left.location.reload();
										window.close();
									}catch(e){
										window.close();
									}
								}
								window.onunload = function ()
								{	
									try{
									    if(window.opener.window.parent.frames.left.location == undefined)
									        window.opener.location.reload();
									    else
									        window.opener.window.parent.frames.left.location.reload();
									}catch(e){}
								}
								window.onload = function(){
								    if("${userInfo.lang != '3'}"){
								        document.getElementById("pMessageContent").innerHTML = "<c:out value = '${userInfo.displayName1}' />" + "<spring:message code = 'ezCommunity.t1087' />" + "<br /> (" + "<c:out value = '${clubVO.c_ClubName}' />" + ")Community" + "<spring:message code = 'ezCommunity.t1088' />" + "<br />" + "<spring:message code = 'ezCommunity.t1089' />";
								    }
								    else{
								        document.getElementById("pMessageContent").innerHTML = "<spring:message code = 'ezCommunity.t1089' />";
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
							            	window.resizeTo(346, 240);
							            }
							        }
							        
							        if (MACSAFARIYN()) {
							            window.resizeTo(330, 251);
							        }
								}
							</script>
						</c:otherwise>
					</c:choose>
					</head>
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
											<td  class="cimg"></td>
											<td  class="ctxt"><span id="pMessageContent"></span></td>
				            			</tr>
				     				</table>
				 	    		</div>
				        	</div>
				        	
				    		<div class="popup_noti_btnarea"> 
				   	    		<div class="btnposition"> 
				            		<input type="submit" value="<spring:message code = 'ezCommunity.t245' />" onClick="javascript:goclub('${code}')">
					    		</div>
					    		
				    			<span class="bl"></span>
				    			<span class="br"></span>
				    		</div>
				    	</div>
					</body>
				</html>
				</c:when>
				
				<c:otherwise>
					<html>
						<head>
							<title><spring:message code = 'ezCommunity.t1091' /></title>
							<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
							<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
							<script type="text/javascript" src="/js/mouseeffect.js"></script>
							<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
							
							<script type="text/javascript">
								function gorefresh(a) {
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
								
								window.onunload = function() {
								    //if(window.opener.window.parent.frames.left.location == undefined)
								    //    window.opener.location.reload();
								    //else
								    //{
								    //    if(window.opener.window.parent.frames.left != undefined || window.opener.window.parent.frames.left != null)
								    //        window.opener.window.parent.frames.left.location.reload();
								    //}
								}
	
								window.onload = function() {
								    document.getElementById("pMessageContent").innerHTML = "<spring:message code = 'ezCommunity.t1092' />" + "<br />" + "<c:out value = '${clubVO.c_ClubName}' />" + " Community" + "<spring:message code = 'ezCommunity.t1093' />"  + "<spring:message code = 'ezCommunity.t1094' />" + "<br />" + "<spring:message code = 'ezCommunity.t1095' />";
								    
								    var UserAgentState = navigator.userAgent.toLowerCase();
							        
							        if (CrossYN()) {
							        	if (UserAgentState.indexOf("chrome") > 0) {
							        		window.resizeTo(340, 260);
							        	} else {
							        		window.resizeTo(346, 240);
							        	}
							        } else {
							        	if (UserAgentState.indexOf("firefox") != -1) {
							                window.resizeTo(349, 279);
							            } else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
							                window.resizeTo(346, 243);
							            } else {
							            	window.resizeTo(346, 240);
							            }
							        }
							        if (MACSAFARIYN()) {
							            window.resizeTo(330, 251);
							        }
								}
							</script>
						</head>
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
							   	    <div class="btnposition"> 
							            <input type="submit" value="<spring:message code = 'ezCommunity.t245' />" onClick="javascript:gorefresh('${code}')">
								    </div>
								    
						    		<span class="bl"></span>
						    		<span class="br"></span>
						    	</div>
						    </div>
						</body>
					</html>
				</c:otherwise>
			</c:choose>
		</c:if>