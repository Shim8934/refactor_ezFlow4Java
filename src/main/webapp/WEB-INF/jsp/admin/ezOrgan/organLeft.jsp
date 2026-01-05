<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="main.t23" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	   	   	
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">	
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">	
		<style>
			#mCSB_1_container { margin-right: 0px;} 
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript">
			document.onselectstart = function (){
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA"){
					return false;
				}else{
					return true;
				}
			};

			function showProgress() {
				document.getElementById("progressPanel").style.display = "";
			}

			function hideProgress() {
				document.getElementById("progressPanel").style.display = "none";
			}

			function mailStatisticsFolder() {
				if($("#MAIL").parent().attr('class') == "on"){
					$("#MAIL").parent().attr('class', '');
					document.getElementById("leftList").style.display = "";
				} else {
					$("#MAIL").parent().attr('class', 'on');
					document.getElementById("leftList").style.display = "block";
				}
				
			}
			
		    function goPage(idx){
		    	if(idx==23 | idx==24 | idx==25 | idx==26 | idx==27 | idx==28 | idx==29){
		    		$("#MAIL").parent().attr('class', 'on');
		    	} else {
		    		$("#MAIL").parent().attr('class', '');
		    	}
		    	
				var url = "";

				switch(idx){
					case 1:
						url = "/admin/ezOrgan/organRight.do";
						break;
					case 2:
						url = "/admin/ezOrgan/totalUserList.do"
						break;
					case 10:
						url = "/admin/ezOrgan/retireUserManage.do";
						break;
					case 12:
						url = "/admin/ezOrgan/permissionsList.do";
						break;
					case 13:
						url = "/admin/ezOrgan/addJobList.do";
						break;
					case 31:
						url = "/admin/ezOrgan/jobInfoList.do";
						break;
					case 32:
						url = "/admin/ezOrgan/loginStop.do";
						break;
					case 33:
						url = "/admin/ezOrgan/groupList.do";
						break;
				}
				parent.document.querySelector("iframe[name=right]").src = url;
			}

			$(document).ready(function() {
				leftResize();
				$(".adminListBox").mCustomScrollbar({
					theme : "dark"
				});

				$("#left .adminListBox h2 span").click(function(){
					$("#left .adminListBox h2").removeClass("on");
					$(this).parent().addClass("on");
				})
				
			});

			function leftResize(){
				$(".adminListBox").height(window.innerHeight-58);
			}

			$( window ).resize(function() {
				leftResize();
			});
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="<c:if test="${dotNetIntegration eq 'YES'}"><spring:message code="main.t78" /></c:if>
												 <spring:message code='main.t8' />">
				<c:if test="${dotNetIntegration eq 'YES'}"><spring:message code="main.t78" /></c:if>
				<spring:message code='main.t8' />
  			</div>
  			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2 class="on">
					<span class="list_text" id="Organ" onClick="goPage(1)" style="display:inline-block;width:100%;" title="<c:if test='${lang eq 6}'><spring:message code='main.t56' /></c:if>"><spring:message code='main.t56' /></span>
				</h2>
				<h2>
					<span class="list_text" id="totalUser" onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='ezOrgan.ksy01' /></span>
				</h2>
				<c:if test="${dotNetIntegration ne 'YES'}">
				<h2>
					<span class="list_text" id="CheckAdmin" onClick="goPage(12)" style="display:inline-block;width:100%;"><spring:message code='main.t00062' /></span>
				</h2> 
				<h2>
					<span class="list_text" id="Addjob" onClick="goPage(13)" style="display:inline-block;width:100%;" title="<c:if test='${lang eq 6}'><spring:message code='main.t00063' /></c:if>"><spring:message code='main.t00063' /></span>
				</h2> 
			</c:if>
				<h2>
					<span class="list_text" id="JobInfo" onClick="goPage(31)" style="display:inline-block;width:100%;"><spring:message code='ezOrgan.csj01' /></span>
				</h2> 
				<h2>
					<span class="list_text" onClick="goPage(10)" style="display:inline-block;width:100%;"><spring:message code='main.t377' /></span>
				</h2>
			<c:if test="${dotNetIntegration ne 'YES'}">
				<c:if test="${useLoginStop == 'YES'}">
					<h2>
						<span class="list_text" onClick="goPage(32)" style="display:inline-block;width:100%;" title="<c:if test='${lang eq 6}'><spring:message code='ezOrgan.hdp17' /></c:if>"><spring:message code='ezOrgan.hdp17' /></span>
					</h2>
				</c:if>
				<c:if test="${packageType != 'mail'}">
					<h2>
						<span class="list_text" onClick="goPage(33)" style="display:inline-block;width:100%;"><spring:message code='ezOrgan.zNo004' /></span>
					</h2>
				</c:if>
			</c:if>
	  		</div>			
		</div>
		<!-- <script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script> -->
		<div style="width:100%; height:100%; position:absolute; top:0; left:0; z-index:1000;
		    background:none rgba(0,0,0,0.4); display:none;" class="progressPanel" id="progressPanel">&nbsp;
		</div>
	</body>
</html>
