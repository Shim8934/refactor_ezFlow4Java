<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.t70' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style type="text/css">
			@MEDIA print {
				#litrealInfo {
					overflow: visible !important;
					height: 100% !important;
				}
				
				#menu, #close{
					display: none;
				}
				
				#mainbody {
					background-image: none;
				}
			}
		</style>
		
		<script type="text/javascript">
			var primaryLang = "${primaryLang}";
			var ReturnFunction;
			window.onload = function () {
				if (MACSAFARIYN()) {
					window.resizeTo(420, 480);
				}
				
				if (primaryLang == '3') {
					window.resizeTo(500, 645);
				}
				
				if (isParentCommonArgsUsed()) {
					ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
				}
			}
			
			function email_onclick(){
				//if (email.innerText != "")
				if (document.getElementById("email").innerText != ""){
				    //메일쓰기창 사이즈 조정 2011.06.09
		            var pheight = window.screen.availHeight;
		            var conHeight = pheight * 0.8;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - conHeight) / 2;
		            var pLeft = (pwidth - 1200) / 2;
		            
		            var username = firefoxinnerText(document.getElementById("username"));
		            var email = firefoxinnerText(document.getElementById("email"));

//					var MsgTo = "\"" + username.innerText + "\" <" + email.innerText + ">";
//		          	var MsgTo = "\"" + document.getElementById("username").innerText  + "\" <" + document.getElementById("email").innerText + ">";
		            var MsgTo = "\"" + username  + "\" <" + email + ">";
				    
				    window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURI(MsgTo), "",
		                               "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
				}
			}
			
			function firefoxinnerText(obj)
			{
			    if (navigator.userAgent.indexOf("Firefox")>-1) {
		             var val = obj.innerHTML;
		             val = val.replace(/&nbsp;/ig," ");
		             val = val.replace(/<br>/ig,"\n");
		             val = val.replace(/<br[^>]+>/ig,"\n");
		             val = val.replace(/<[^>]+>/g,"");
		         }
		         else
		         {
		            val = obj.innerText;
		         }
		         return val;
			}
			
			function btnSMS_onClick()
			{
			    var pMobile = document.getElementById("LiteralMobile").innerText;
//				var pMobile = document.all("LiteralMobile").innerText;
				
				//if( pMobile == "" )
				//{
				//	return;
				//}
				
				window.open("/ezPersonal/sms/sms_main.do?num="+pMobile, "", "height=560px,width=570px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
			}
			
			// 2024-03-21 조수빈 - 현재 창 프린트 시 팝업 창의 크기가 작아 미리보기가 잘 보이지 않는 문제 
			
			// 프린트 이후 원래 창의 크기로 돌리기 위해 변수로 저장
			var originalWidth = window.outerWidth;
			var originalHeight = window.outerHeight;
			
			window.onbeforeprint = function() {
				// 미리보기에서 잘 보일 수 있도록 현재 창을 최대화
				window.resizeTo(screen.availWidth, screen.availHeight);
			}
			
			window.onafterprint = function() {
				// 원래의 팝업 사이즈로 변경
				window.resizeTo(originalWidth, originalHeight);
				
				var screenWidth = screen.availWidth;
				var screenHeight = screen.availHeight;
				
				var leftPosition = (screenWidth - originalWidth) / 2;
				var topPosition = (screenHeight - originalHeight) / 2;
				
				// 화면의 중앙으로 위치 변경
				window.moveTo(leftPosition, topPosition);
			}

// 			function btnClose_onclick() {
// 				if (ReturnFunction != null) {
// 					ReturnFunction("cancel");
// 				}
// 				window.close();
// 			}
		</script>
	</head>
	
	<body class = "popup" id = "mainbody">
		<form method = "POST">
			<div id="normalScreen">
			    <div id="menu" style="margin-top:7px;margin-bottom:19px;">
					<ul>
			        	<li><span class="icon16 popup_icon16_print" onClick="window.print()"></span></li>
					</ul>
			    </div>
			    <div id="close">
			    	<ul>
			        	<li><span onClick="return btnClose_onclick()"></span></li>
			        </ul>
			    </div>
			    <script type="text/javascript">
					selToggleList(document.getElementById("menu"), "ul", "li", "0");
				</script>
				
				<table width="100%">
					<tr>
						<th width="119" id="photo">${LiteralPhoto }</th>
						<td valign="top" style="padding-left:5px" >
						
							<table class="content" width="100%" >
								<tr>
									<th nowrap style="height:26px"><spring:message code='main.t74' /></th>
									<td>${LiteralCompany }</td>
								</tr>
								<tr>
									<th nowrap style="height:26px"><spring:message code='main.t75' /></th>
							  		<td>${LiteralDept }</td>
								</tr>
								<c:if test="${primaryLang eq '3'}">
								<tr>
									<th nowrap style="height:26px"><spring:message code='main.ksa01' /></th>
							  		<td>${LiteralFurigana }</td>
								</tr>
								</c:if>
								<tr>
									<th nowrap style="height:26px"><spring:message code='main.t76' /></th>
									<td id="username"><c:out value='${LiteralDisplayName}'/></td>
								</tr>
								<tr>
									<th nowrap style="height:26px"><spring:message code='main.t77' /></th>
							  		<td>${LiteralTitle }</td>
								</tr>
								<tr>
									<th nowrap style="height:27px" ><spring:message code='ezOrgan.t1500' /></th>
									<td >${LiteralRole }</td>
						        </tr>
						    </table>
						    
					    </td>
					</tr>
				</table>
				
				<table class="content" style="margin-top:10px" >
					<tr>
						<th><spring:message code='main.t78' /></th>
						<td colspan="2" width="100%"><span id="email" style="cursor:pointer" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" onClick="email_onclick()"><c:out value='${LiteralEmail}'/></span></td>
					</tr>
					<tr>
						<%-- <th><spring:message code='main.t79' /></th> --%>
						<th><spring:message code='ezPersonal.t177' /></th>
						<td colspan="2" width="100%">${LiteralPhone }</td>
					</tr>
					<tr>
						<th><spring:message code='main.t80' /></th>
						<td style="border-right:medium none">${LiteralMobile }</td>
						<td width="80" style="border-left:medium none">
							<!--a  class="imgbtn"><span onClick="btnSMS_onClick()">SMS<spring:message code='main.t81' /></span></a-->
						</td>
					</tr>
					<tr>
						<th><spring:message code='main.t82' /></th>
						<td colspan="2">${LiteralHomePhone }</td>
					</tr>
					<tr>
					  	<th><spring:message code='main.t83' /></th>
					  	<td colspan="2">${LiteralFax }</td>
					</tr>
					<c:if test="${primaryLang  eq '3'}">
					<tr>
					  	<th><spring:message code='main.ksa02' /></td>
					  	<td colspan="2">${LiteralExtensionPhone }</td>
					</tr>
					<tr>
					  	<th><spring:message code='main.ksa03' /></td>
					  	<td colspan="2">${LiteralOfficeMobile }</td>
					</tr>
					</c:if>
					<tr style="display:none">
						<th rowspan="2" ><spring:message code='main.t84' /></th>
					  	<td colspan="2" height="25">${LiteralPostal }</td>
					</tr>
						<tr style="display:none">
						<td colspan="2" height="25" >
							<div style="word-break:break-all; width:100%; HEIGHT:20px; overflow:auto; line-height:18px" >${"LiteralAddress" }</div>
						</td>
					</tr>
					<tr>
					  	<th><spring:message code='ezPersonal.t1820' /><br><spring:message code='main.t85' /></th>
						<td colspan="2">
							<div id="litrealInfo" style="WIDTH:100%;HEIGHT:65px;overflow:auto; line-height:18px; white-space:pre-wrap;">${LiteralInfo }</div>
					    </td>
					</tr>
				</table>
			</div>
			<div id="printScreen" style="DISPLAY: none">
				<table>
					<tr>
				    	<td><spring:message code='main.t86' /></td>
				  		<td id="printPhoto"></td>
					</tr>
					<tr>
						<td><spring:message code='main.t87' /></td>
						<td id="printCompany"></td>
					</tr>
					<tr>
					  	<td><spring:message code='main.t88' /></td>
					  	<td id="printDept"></td>
					</tr>
					<tr>
					  	<td><spring:message code='main.t89' /></td>
					  	<td id="printName"></td>
					</tr>
					<tr>
					  	<td><spring:message code='main.t90' /></td>
					  	<td id="printTitle"></td>
					</tr>
					<tr>
						<td><spring:message code='main.t91' /></td>
						<td id="printEmail"></td>
					</tr>
					<tr>
					 	<td><spring:message code='main.t92' /></td>
					  	<td id="printPhone"></td>
					</tr>
					<tr>
					  	<td><spring:message code='main.t93' /></td>
					  	<td id="printMobile"></td>
					</tr>
					<tr>
					  	<td><spring:message code='main.t94' /></td>
					  	<td id="printHomePhone"></td>
					</tr>
					<tr>
					  	<td><spring:message code='main.t95' /></td>
					  	<td id="printFax"></td>
					</tr>
					<tr>
					  	<td><spring:message code='main.t96' /></td>
					  	<td id="printAddr"></td>
					</tr>
					<tr>
					  	<td><spring:message code='main.t97' /></td>
					    <td id="printMemo"></td>
					</tr>
				</table>
			</div>
		</form>
	</body>
</html>