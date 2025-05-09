<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<title><spring:message code='main.t00037'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf=8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style type="text/css">
			td,a {font-family: Arial, malgun gothic;font-size: 9pt;word-break:keep-all; white-space:nowrap; color:#555555; text-decoration:none}
			.over{
				padding-left:15px; padding-right:15px; 
				background-repeat:no-repeat;
				background-position:5;
				background-color:#2a2d32;
				color:#fff;
				border-color:#000;
				border-width:0px 1px 0 0; 
				border-style:solid;
				font-weight:bold;}
			.normal{padding-left:15px; padding-right:15px;color:#ffffff; border-right:1px solid #000;font-weight:bold;word-break:keep-all}
			a:link {}
			a:visited {}
			a:active {}
			a:hover {color: #006c9c;}
				td {
        			font-family:'Meiryo UI';
    			}
		</style>
		<script type="text/javascript">
			var beforethis;
			var lang = "${userInfo.lang}";
			var topMenuID = "<c:out value='${topMenuID}'/>";
			
			window.onload = function () {
				if ("${firstScreen_Mail}" == "YES") {
		            document.getElementById("menu02").onclick();
		        }
			}
			
			function mover(objThis){
				if(beforethis == objThis) {
					return;
				} else {
						objThis.className='over';
				}
			}
			
			function mout(objThis){	
				
				if(beforethis == objThis){
						return;
				} else {
					objThis.className='normal';
				}
			}
			
			function mclick(objThis) {
			
				if(beforethis == objThis){
					return;
				} 
				else {
					if(typeof(beforethis) == "object")
					{
						//기존에 클릭되 있던 객체를 원래 스타일로 변경.
					beforethis.className='normal';
					}
					objThis.className='over';
					beforethis = objThis;
				}
			
				var pUrl = "";
				if (lang == "3")
				    pUrl = "jp_";
				switch (objThis.id)
				{
				    // 기본 메뉴		
			
				    case "menu00":
				        parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPortal.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/portal_" + pUrl + "01";
				        break;
				    case "menu01":
				        parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftTask.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/task_" + pUrl + "01";
				        break;
					case "menu02":
					    parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftMail.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/mail_" + pUrl + "01";
						break;
					case "menu03":
					    parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftBoard.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/board_" + pUrl + "01";
						break;
					case "menu04":
					    parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftAppr.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/appr_" + pUrl + "01";
						break;
					case "menu05":
					    parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftCommunity.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/community_" + pUrl + "01";
						break;	
					case "menu07":
					    parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftResource.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/resource_" + pUrl + "01";
						break;
					case "menu08":
					    parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftSchedule.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/schedule_" + pUrl + "01";
						break;
				    case "menu09":
				        parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftAddr.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/addr_" + pUrl + "01";
				        break;
				    case "menu06":
				    	var packageType = "${packageType}";
				    	if (packageType != 'standard') {
				    		parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftEnv.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/env_" + pUrl + "02&topMenuID=" + topMenuID;	
				    	} else {
				    		parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftEnv.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/env_" + pUrl + "01&topMenuID=" + topMenuID;	
				    	}
				        
				        break;
				    case "menu10":
				        parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftApprG.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/apprG_" + pUrl + "01";
				        break;
				    case "menu11":
				        parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPoll.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/poll_" + pUrl + "01";
				        break;
				    case "menu12":
				        parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftCircular.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/circular_" + pUrl + "01";
				        break;
				    case "menu13":
				        parent.document.querySelector("iframe[name=bottom]").src = "/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftWebfolder.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/webfolder_" + pUrl + "01";
				        break;
					default:
						break;
				}
			}
			
			function TreeView_toggle(TreeView,width){	
				TreeView.style.display = "block";
				TreeView.style.marginLeft = width + "px";
			}
		</script>
		</head>
		<body style="background-color:#606671">
			<c:choose>
				<c:when test="${userInfo.lang != '3'}">
					<div style="float:left">
			    		<img src="/images/help/help.gif" width="135">
					</div>
					<div style="float:right;font-size:17px;font-family: Malgun Gothic; font-weight: bold; padding:10px;color:white" >ezFlow v6.4.0.STD_20181217</div>
					<div style="clear:both"></div>
				<table onstalled="width:100%;" border="0" style="background:url(/images/help/topmenu_bg.gif) repeat-x; height:26px;">
			  <tr>
			  	  <c:choose>
			  	  	<c:when test="${packageType == 'mail'}">
			  	  		<c:if test="${isMailUsed == 'Y'}">
			  	  			<td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">메일</td>
			  	  			<td class="normal" id="menu09" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">주소록</td>
			  	  		</c:if>
		      			<td class="normal" id="menu06" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">환경설정</td>
			  			<td style="width:100%">&nbsp;</td>
			  	  	</c:when>			  	  
			  	  	<c:when test="${packageType == 'basic'}">
						<c:choose>
							<c:when test="${firstScreen_Mail == 'YES'}">
								<c:if test="${isMailUsed == 'Y'}">
									<td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">메일</td>
								</c:if>
								<td style="width:100%">&nbsp;</td>
							</c:when>
							<c:otherwise>
								<c:if test="${isMailUsed == 'Y'}">
									<td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">메일</td>
									<td class="normal" id="menu09" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">주소록</td>
								</c:if>
				      			<c:if test="${isScheduleUsed == 'Y'}">
				      				<td class="normal" id="menu08" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">일정관리</td>
				      				<td class="normal" id="menu01" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">업무관리</td>
			  	  				</c:if>
			  	  				<c:if test="${isBoardUsed == 'Y'}">
				      				<td class="normal" id="menu03" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">게시판</td>
				      			</c:if>
				      			<c:if test="${isWebfolderUsed == 'Y'}">
				      				<td class="normal" id="menu13" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);"><spring:message code="ezWebFolder.t10"/></td>
				      			</c:if>
				      			<td class="normal" id="menu06" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">환경설정</td>
					  			<td style="width:100%">&nbsp;</td>
							</c:otherwise>
						</c:choose>
			  	  	</c:when>
			  	  	<c:otherwise>
			  	  		<c:choose>
			  	  			<c:when test="${firstScreen_Mail == 'YES'}">
			  	  				<c:if test="${isMailUsed == 'Y'}">
			  	  					<td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">메일</td>
			  	  				</c:if>
			  	  				<td style="width:100%">&nbsp;</td>
			  	  			</c:when>
			  	  			<c:otherwise>
			  	  				<td class="normal" id="menu00" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">포탈</td>
			  	  				<c:if test="${isMailUsed == 'Y'}">
						      		<td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">메일</td>
						      		<td class="normal" id="menu09" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">주소록</td>
						      	</c:if>
						      	<c:if test="${isScheduleUsed == 'Y'}">
						      		<td class="normal" id="menu08" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">일정관리</td>
						      		<td class="normal" id="menu01" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">업무관리</td>
						      	</c:if>
						      	<c:if test="${isBoardUsed == 'Y'}">
			  	  					<td class="normal" id="menu03" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">게시판</td>
			  	  					<td class="normal" id="menu11" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">전자설문</td>
			  	  				</c:if>
			  	  				<c:if test="${isApprUsed == 'Y'}">
			  	  					<c:if test="${approvalFlag == 'G'}">
			  	  						<td class="normal" id="menu10" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">전자결재 G</td>
						      		</c:if>
						      		<c:if test="${approvalFlag != 'G'}">
						      			<td class="normal" id="menu04" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">전자결재 </td>
						      		</c:if>
						      	</c:if>
						      	<c:if test="${isCommunityUsed == 'Y'}">
						      		<td class="normal" id="menu05" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">커뮤니티</td>
						      	</c:if>
						      	<c:if test="${isResUsed == 'Y'}">
						      		<td class="normal" id="menu07" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">자원관리</td>
								</c:if>
								<c:if test="${isCircularUsed == 'Y'}">
									<td class="normal" id="menu12" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">회람판</td>
								</c:if>
								<c:if test="${isWebfolderUsed == 'Y'}">
				      				<td class="normal" id="menu13" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);"><spring:message code="ezWebFolder.t10"/></td>
				      			</c:if>
						      	<td class="normal" id="menu06" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">환경설정</td>
							  	<td style="width:100%">&nbsp;</td>
			  	  			</c:otherwise>
			  	  		</c:choose>
			  	  	</c:otherwise>
			  	  </c:choose>
			  </tr>
			</table>
		</c:when>
		<c:otherwise>
			<div>
	    		<img src="/images/help/help_jp.gif" width="135">
			</div>
			<table onstalled="width:100%;" border="0" style="background:url(/images/help/topmenu_bg.gif) repeat-x; height:26px;">
	  			<tr>
	  				<c:choose>
				  	  	<c:when test="${packageType == 'mail'}">
				  	  		<c:if test="${isMailUsed == 'Y'}">
						    	<td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">メール</td>
						    	<td class="normal" id="menu09" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">アドレス帳</td>
						    </c:if>
				  			<td style="width:100%">&nbsp;</td>
				  	  	</c:when>			  	  	  				
		  				<c:when test="${packageType == 'basic'}">
		  						<c:if test="${isMailUsed == 'Y'}">
									<td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">メール</td>
									<td class="normal" id="menu09" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">アドレス帳</td>
								</c:if>
				      			<c:if test="${isScheduleUsed == 'Y'}">
				      				<td class="normal" id="menu08" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">日程管理</td>
				      				<td class="normal" id="menu01" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">業務管理</td>
			  	  				</c:if>
			  	  				<c:if test="${isBoardUsed == 'Y'}">
				      				<td class="normal" id="menu03" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">掲示板</td>
				      			</c:if>
				      			<c:if test="${isWebfolderUsed == 'Y'}">
				      				<td class="normal" id="menu13" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);"><spring:message code="ezWebFolder.t10"/></td>
				      			</c:if>
				      			<td class="normal" id="menu06" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">マイポータルの設定</td>
				    			<td style="width:100%">&nbsp;</td>
		  				</c:when>
		  				<c:otherwise>
		  						<td class="normal" id="menu00" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">ポータル</td>
			  	  				<c:if test="${isMailUsed == 'Y'}">
			  	  					<td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">メール</td>
			  	  					<td class="normal" id="menu09" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">アドレス帳</td>
						      	</c:if>
						      	<c:if test="${isScheduleUsed == 'Y'}">
						      		<td class="normal" id="menu08" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">スケジュール</td>
						      		<td class="normal" id="menu01" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">業務管理</td>
						      	</c:if>
						      	<c:if test="${isBoardUsed == 'Y'}">
			  	  					<td class="normal" id="menu03" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">掲示板</td>
			  	  					<td class="normal" id="menu11" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">アンケート</td>
			  	  				</c:if>
			  	  				<c:if test="${isApprUsed == 'Y'}">
			  	  					<c:if test="${approvalFlag == 'G'}">
			  	  						<td class="normal" id="menu10" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">電子決裁G</td>
						      		</c:if>
						      		<c:if test="${approvalFlag != 'G'}">
						      			<td class="normal" id="menu04" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">電子決裁</td>
						      		</c:if>
						      	</c:if>
						      	<c:if test="${isCommunityUsed == 'Y'}">
						      		<td class="normal" id="menu05" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">コミュニティ</td>
						      	</c:if>
						      	<c:if test="${isResUsed == 'Y'}">
						      		<td class="normal" id="menu07" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">設備管理</td>
								</c:if>
								<c:if test="${isCircularUsed == 'Y'}">
									<td class="normal" id="menu12" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">回覧板</td>
								</c:if>
								<c:if test="${isWebfolderUsed == 'Y'}">
				      				<td class="normal" id="menu13" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);"><spring:message code="ezWebFolder.t10"/></td>
				      			</c:if>
								<td class="normal" id="menu06" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">環境設定</td>
							  	<td style="width:100%">&nbsp;</td>
		  				</c:otherwise>
	  				</c:choose>
	  			</tr>	
			</table>
		</c:otherwise>
	</c:choose>
	</body>
</html>
