<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<title><spring:message code='main.t00037'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf=8">
		<style type="text/css">
			<!--
			td,a {font-family: Arial, gulim;font-size: 9pt;word-break:keep-all; white-space:nowrap; color:#555555; text-decoration:none}
			.over{
				padding-left:15px; padding-right:15px; 
				background-repeat:no-repeat;
				background-position:5;
				background-color:#2a2d32;
				color:#fff;
				border-color:#000;
				border-width:3px 1px 0 0; 
				border-style:solid;
				font-weight:bold;}
			.normal{padding-left:15px; padding-right:15px;color:#ffffff; border-right:1px solid #000;font-weight:bold;word-break:keep-all}
			a:link {}
			a:visited {}
			a:active {}
			a:hover {color: #006c9c;}
			-->
		</style>
		<script type="text/javascript">
			var beforethis;
			var lang = "${userInfo.lang}";
			
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
				        window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPortal.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/portal_" + pUrl + "01", "bottom");
				        break;
				    /* case "menu01":
				        window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftTask.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/task_" + pUrl + "01", "bottom");
				        break; */
					case "menu02":
					    window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftMail.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/mail_" + pUrl + "01", "bottom");
						break;
					case "menu03":
					    window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftBoard.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/board_" + pUrl + "01", "bottom");
						break;
					case "menu04":
					    window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftAppr.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/appr_" + pUrl + "01", "bottom");
						break;
					case "menu05":
					    window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftCommunity.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/community_" + pUrl + "01", "bottom");
						break;	
					case "menu07":
					    window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftResource.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/resource_" + pUrl + "01", "bottom");
						break;
					case "menu08":
					    window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftSchedule.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/schedule_" + pUrl + "01", "bottom");
						break;
				    case "menu09":
				        window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftAddr.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/addr_" + pUrl + "01", "bottom");
				        break;
				    case "menu06":
				        window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftEnv.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/env_" + pUrl + "01", "bottom");
				        break;
				    case "menu10":
				        window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftApprG.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/apprG_" + pUrl + "01", "bottom");
				        break;
				    case "menu11":
				        window.open("/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPoll.do?lang=" + lang + "&rUrl=/ezPortal/help/main.do?id=/images/help/poll_" + pUrl + "01", "bottom");
				        break;
					default:
						break;
				}
			
			}
			
			function TreeView_toggle(TreeView,width){	
				TreeView.style.display = "block";
				TreeView.style.marginLeft = width + "px";
			}
			//-->
		</script>
		</head>
		<body style="background-color:#606671">
			<c:choose>
				<c:when test="${userInfo.lang != '3'}">
					<div>
			    		<img src="/images/help/help.gif" width="135">
					</div>
				<table onstalled="width:100%;" border="0" style="background:url(/images/help/topmenu_bg.gif) repeat-x; height:26px;">
			  <tr>
			      <td class="normal" id="menu00" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">포탈</td>
			      <td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">메일</td>
			      <td class="normal" id="menu09" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">주소록</td>
			      <td class="normal" id="menu08" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">일정관리</td>
			      <!-- <td class="normal" id="menu01" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">업무관리</td> -->
			      <td class="normal" id="menu03" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">게시판</td>
			      <td class="normal" id="menu11" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">전자설문</td>  
			      <!-- <td class="normal" id="menu04" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">전자결재 </td> -->
			      <!-- <td class="normal" id="menu10" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">전자결재 G</td> -->
			      <td class="normal" id="menu05" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">커뮤니티</td>
			      <td class="normal" id="menu07" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">자원관리</td>
			      <td class="normal" id="menu06" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">환경설정</td>
			    <td style="width:100%">&nbsp;</td>
			  </tr>
			</table>
		</c:when>
		<c:otherwise>
			<div>
	    		<img src="/images/help/help_jp.gif" width="135">
			</div>
			<table onstalled="width:100%;" border="0" style="background:url(images/topmenu_bg.gif) repeat-x; height:26px;">
	  			<tr>
	      			<td class="normal" id="menu00" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">ポータル</td>
				    <td class="normal" id="menu02" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">電子メール</td>
				    <td class="normal" id="menu09" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">アドレス帳</td>
				    <td class="normal" id="menu08" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">日程管理</td>
				    <!-- <td class="normal" id="menu01" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">業務管理</td> -->
				    <td class="normal" id="menu03" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">掲示板</td>
				    <td class="normal" id="menu11" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">アンケート</td>  
				    <!-- <td class="normal" id="menu04" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">電子決裁 </td> -->
				    <!-- <td class="normal" id="menu10" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">電子決裁G</td> -->
				    <td class="normal" id="menu05" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">コミュニティー</td>
				    <td class="normal" id="menu07" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">設備管理</td>
				    <td class="normal" id="menu06" style="cursor:pointer" onClick="mclick(this);" onMouseOver="mover(this);" onMouseOut="mout(this);">マイポータルの設定</td>
	    			<td style="width:100%">&nbsp;</td>
	  			</tr>	
			</table>
		</c:otherwise>
	</c:choose>
	</body>
</html>
