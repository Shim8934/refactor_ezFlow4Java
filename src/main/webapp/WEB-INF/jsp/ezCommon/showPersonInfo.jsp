<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.t70' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='main.e15' />" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<script type="text/javascript">
			window.onload = function () {
				if (MACSAFARIYN()) {
					window.resizeTo(420, 480);
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
		            var pLeft = (pwidth - 890) / 2;
		            
		            var username = firefoxinnerText(document.getElementById("username"));
		            var email = firefoxinnerText(document.getElementById("email"));

//					var MsgTo = "\"" + username.innerText + "\" <" + email.innerText + ">";
//		          	var MsgTo = "\"" + document.getElementById("username").innerText  + "\" <" + document.getElementById("email").innerText + ">";
		            var MsgTo = "\"" + username  + "\" <" + email + ">";
				    
				    window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURI(MsgTo), "",
		                               "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
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
		</script>
	</head>
	
	<body class = "popup" id = "mainbody">
		<form method = "POST">
			<div id="normalScreen">
			    <div id="menu">
					<ul>
			        	<li><span onClick="window.print()"><spring:message code='main.t73' /></span></li>
					</ul>
			    </div>
			    <div id="close">
			    	<ul>
			        	<li><span onClick="window.close()"><spring:message code='main.t3' /></span></li>
			        </ul>
			    </div>
			    <script type="text/javascript">
					selToggleList(document.getElementById("menu"), "ul", "li", "0");
					selToggleList(document.getElementById("close"), "ul", "li", "0");
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
								<tr>
									<th nowrap style="height:26px"><spring:message code='main.t76' /></th>
									<td id="username">${LiteralDisplayName }</td>
								</tr>
								<tr>
									<th nowrap style="height:26px"><spring:message code='main.t77' /></th>
							  		<td>${LiteralTitle }</td>
								</tr>
								<tr>
									<th nowrap style="height:27px" ><spring:message code='main.t78' /></th>
									<td ><span id="email" style="cursor:pointer" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" onClick="email_onclick()">${LiteralEmail }</span></td>
						        </tr>
						    </table>
						    
					    </td>
					</tr>
				</table>
				
				<table class="content" style="margin-top:10px" >
					<tr>
						<th><spring:message code='main.t79' /></th>
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
					  	<th><spring:message code='main.t85' /></th>
						<td colspan="2">
							<div style="WIDTH:100%;HEIGHT:80px;overflow:auto; line-height:18px">
					        	${LiteralInfo }
					        </div>
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