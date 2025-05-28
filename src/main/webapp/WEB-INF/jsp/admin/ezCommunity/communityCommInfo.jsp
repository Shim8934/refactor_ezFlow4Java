<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${title}' /> <spring:message code = 'ezCommunity.t46' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		
		<script type="text/javascript">
			window.onload = function () {	        	
	        	//window.resizeTo(550, 360 + window.outerHeight - window.innerHeight);
	        	
				var agent = navigator.userAgent.toLowerCase(); 
				if (!CrossYN() || agent.search( "trident" ) > -1 ) {
					document.getElementById("c_clubdesc").style.marginBottom = "0px";
				}
				
			}
			
			var code = "<c:out value = '${code}' />";
			
			function comClose_onclick( code, pType ) {
				if ( pType == "Del") {
					var result = confirm("<spring:message code = 'ezCommunity.t59' />");
					
					if (result) {
						window.location.href = "/admin/ezCommunity/commCloseAll.do?type=popUp&code=" + code;
						
					} else {
						//alert("<spring:message code = 'ezCommunity.t60' />");
						self.close();
					}
					
				} else {	//if (pType == "New")
					var result = confirm("<spring:message code = 'ezCommunity.t61' />");
					
					if (result) {
						window.location.href = "/admin/ezCommunity/commAdmitOk.do?type=popUp&code=" + code + "&pDivi=AdmitOK&name=" + encodeURIComponent('<c:out value = '${clubVO.c_ClubName}' />');
						
					} else {
						//alert("<spring:message code = 'ezCommunity.t62' />");
						self.close();
					}
				}
			}
			
			function closeCancel_onclick( code, pType ) {
				if ( pType == "Del") {
					self.close();
				} else { //if (pType == "New")
					var result = confirm("<spring:message code = 'ezCommunity.t63' />");
				
					if (result) {
						window.location.href = "/admin/ezCommunity/commAdmitOk.do?type=popUp&code=" + code + "&pDivi=AdmitCancel";
					} else {
						//alert("<spring:message code = 'ezCommunity.t62' />");
						self.close();
					}
				}
			}
		</script>
	</head>
	<body class="popup" >
		<form method="post" name="mod" action="admin_basic_ok.asp">
			<input type="hidden" name="code" value="<c:out value = '${code }' />">
			
			<c:choose>
				<c:when test="${type == 'Del' }">
					<h1 id="popUpTitle" style="height:45px;"><spring:message code = 'ezCommunity.t39' /></h1>
				</c:when>
				<c:otherwise>
					<h1 id="popUpTitle" style="height:45px;"><spring:message code = 'ezCommunity.t25' /> / <spring:message code = 'ezCommunity.t44' /></h1>
				</c:otherwise>
			</c:choose>
	   		<div id="close">
	            <ul>
	                <li><span onclick="window.close()"></span></li>
	            </ul>
	        </div>
	   		
			<table class="content" style="margin-top:10px;">
				<tr> 
					<th><spring:message code = 'ezCommunity.t9' /></th>
					<td><c:out value = '${memberVO.userName }' /> (<c:out value = '${clubVO.c_SysopID }' />)</td>
				</tr>
				<tr> 
					<th><spring:message code = 'ezCommunity.t9991' /></th>
					<td>
		                <table style="table-layout:fixed;width:410px;">
		                    <tr>
		                        <td style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;max-width:410px; padding-left: 0px;">
		                        	<c:choose>   
			                            <c:when test="${userInfo.primary != '2' }">
											<c:out value = '${clubVO.c_ClubName}' />
										</c:when>
										<c:otherwise>
											<c:out value = '${clubVO.c_ClubName2}' />
										</c:otherwise>
									</c:choose>
		                        </td>
		                    </tr>
		                </table>
					</td>
				</tr>
				<tr> 
					<th><spring:message code = 'ezCommunity.t11' /></th>
					<td> <c:out value = '${strCategory}' /></td>
				</tr>
				<tr> 
					<th><spring:message code = 'ezCommunity.t12' /></th>
					<td>
						<c:choose>
							<c:when test="${clubVO.c_ClubConfirmType == '2' }">
								<spring:message code = 'ezCommunity.t13' />
							</c:when>
							
							<c:otherwise>
								<c:if test="${clubVO.c_ClubConfirmType == '3' }">
									<spring:message code = 'ezCommunity.t14' />
								</c:if>
							</c:otherwise>
						</c:choose>
						
					</td>
				</tr>
				<tr> 
					<th><spring:message code = 'ezCommunity.t15' /></th>
					<td>
						<c:choose>
							<c:when test="${clubVO.c_ClubGubun == '2' }">
								<spring:message code = 'ezCommunity.t66' />
							</c:when>
							
							<c:otherwise>
								<c:if test="${clubVO.c_ClubGubun == '3' }">
									<spring:message code = 'ezCommunity.t67' />
								</c:if>
							</c:otherwise>
						</c:choose>
						
					</td>
				</tr>
				<tr style="display:none"> 
					<th><spring:message code = 'ezCommunity.t68' /></th>
					<td>
					
						<c:choose>
							<c:when test="${clubVO.isIn == '1' }">
								<spring:message code = 'ezCommunity.t69' />
							</c:when>
							<c:otherwise>
								<c:if test="${clubVO.isIn == '2' }">
									<spring:message code = 'ezCommunity.t70' />
								</c:if>
							</c:otherwise>
						</c:choose>	
					</td>
				</tr>
				<tr height="100%"> 
					<c:choose>
						<c:when test="${type == 'Del' }">
							<th><spring:message code = 'ezCommunity.t71' /></th>
							<td style="padding:0px 2px 0px 0px;"> <textarea id="c_clubdesc" name="c_clubdesc" style="background-color:#ffffff; Width:98%; Height:120px; cursor:default;
								 border:none; resize:none;" readonly><c:out value = '${delReason}' /></textarea></td>
						</c:when>
						
						<c:otherwise>
							<th><spring:message code = 'ezCommunity.design03' /><spring:message code = 'ezCommunity.t18' /></th>
							<td style="padding:0px 2px 0px 0px;"> <textarea id="c_clubdesc" name="c_clubdesc" style="background-color:#ffffff;Width:98%; Height:120px; cursor:default;
								 border:none; resize:none;" readonly><c:out value = '${newInfo}' /></textarea></td>
						</c:otherwise>
					</c:choose>
				</tr>
			</table>
		</form>
		<div class="btnpositionNew">
		    <a class="imgbtn"><span onclick="return comClose_onclick('${code}','${type}')" ><spring:message code = 'ezCommunity.t46' /></span></a>
		         
            <c:if test="${type == 'New' }">
         		<a class="imgbtn"><span onclick="return closeCancel_onclick('${code}','${type}')" ><spring:message code = 'ezCommunity.t44' /></span></a>	
         	</c:if>
		</div>
	</body>
</html>