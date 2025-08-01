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
			#mCSB_1_container {margin-right: 0px;} 
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

			function goPage(idx){
				var url = "";

				if (${dotNetIntegration == 'YES'}) {
					if (idx < 23  || idx > 29) {
						$(".lnb H2").attr("class", "off");
			    		$(".lnb UL").attr("class", "lnbUL off");
					}
				}

				switch(idx){

					case 2:
						//url = "/admin/ezEmail/mailDistributionList.do";
						url = "/admin/ezEmail/mailDistributionMain.do";
						break;
					case 3:
						url = "/admin/ezEmail/mailDefaultQuota.do" ;
						break;
					case 4:
						url = "/myoffice/ezEmail/Admin/mail_spamfilter_category.aspx"  ;
						break;
					case 5:
					if (!CrossYN())
						url = "/myoffice/ezEmail/Admin/FormMaker.aspx";
					else
						url = "/myoffice/ezEmail/Admin/FormMaker_Cross.aspx";
						break;
					case 6:
						url = "/myoffice/ezEmail/Admin/mail_approve_category.aspx";
						break;
					case 7:
						url = "/myoffice/ezEmail/Admin/Right_DLSendManage.aspx" ;
						break;
					case 8:
						url = "/myoffice/ezEmail/Admin/Right_DLSentItems.aspx";
						break;
					case 9:
						url = "/admin/ezEmail/mailConfigColor.do";
						break;
					case 11:
						url = "/myoffice/ezEmail/Admin/Right_LargeSizeMailManage.aspx";
						break;
					case 14:
						url = "/admin/ezSystem/systemMainMenu.do";
						break;
					case 20:
						url = "/myoffice/ezEmail/Admin/mail_DLMailConfig.aspx";
						break;
					case 21:
						url = "/myoffice/ezEmail/DLmail_list.aspx";
						break;
					case 22:
						url = "/admin/ezEmail/mailQuotaList.do";
						break;
					case 23:
						url = "/ezStatistics/statisticsMailMain.do";
						break;
					case 24:
						url = "/ezStatistics/statisticsMailDept.do";
						break;
					case 25:
						url = "/ezStatistics/statisticsMailUser.do";
						break;
					case 26:
						url = "/ezStatistics/statisticsQuantityDept.do";
						break;
					case 27:
						url = "/ezStatistics/statisticsQuantityUser.do";
						break;
					case 28:
						url = "/ezStatistics/statisticsMailRecieveLogList.do";
						break;
					case 29:
						url = "/ezStatistics/statisticsMailSendLogList.do";
						break;
					case 30:
					 	url = "/admin/ezEmail/letterMain.do";
					 	break;
					case 32:
						url = "/admin/ezEmail/signatureMain.do";
						break;
					case 33:
						url = "/admin/ezEmail/showSharedMailboxList.do";
						break;
					case 34:
					 	url = "/admin/ezEmail/mailCopyright.do";
				    	break;
					case 35:
						url = "/admin/ezEmail/multiDomain.do";
						break;
					case 36:
						url = "/admin/ezEmail/companyMultiDomain.do";
						break;
					case 37:
						url = "/admin/ezEmail/appr/allHands/main.do";
						break;
					case 38:
						url = "/admin/ezEmail/appr/main.do";
						break;
					case 39:
						url = "/admin/ezEmail/adminConfigPOP3IMAP.do";
						break;
				}
				window.open(url,"right");
				
				$("#left .adminListBox h2 span").click(function(){
					$("#left .adminListBox h2").removeClass("on");
					$(this).parent().addClass("on");
				})
				
			}

			$(document).ready(function() {
				leftResize();
				$(".adminListBox").mCustomScrollbar({
					theme : "dark"
				});
			});

			function leftResize(){
				$(".adminListBox").height(window.innerHeight-58);
			}

			$( window ).resize(function() {
				leftResize();
			});
			
			function openFolder(val01) {
		    	if ($("#" + val01 + "H2").attr("class") == "on") {	        	
		    		$("#" + val01 + "H2").attr("class", "off");
		    		$("#" + val01 + "UL").attr("class", "lnbUL off");
		    	} else {
		    		$(".lnb H2").attr("class", "off");
		    		$(".lnb UL").attr("class", "lnbUL off");
		    		
		    		$("#" + val01 + "H2").attr("class", "on")
		    		$("#" + val01 + "UL").attr("class", "lnbUL");
		    	}
		    }
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="<spring:message code='main.t78' />">
				<spring:message code='main.t78' />
  			</div>
  			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2 class="on">
					<span class="h2Title" onClick="goPage(22)" style="display:inline-block;width:100%;"><spring:message code="ezEmail.lsd01" /></span>
				</h2>
				
				<c:if test="${useApprMail}">
				<h2>
					<% // 전체메일승인 %>
					<span class="h2Title" onClick="goPage(37)" style="display:inline-block;width:100%;"><spring:message code="email.appr.menu.allhands" /></span>
				</h2>
				<h2>
					<% // 메일승인관리 %>
					<span class="h2Title" onClick="goPage(38)" style="display:inline-block;width:100%;"><spring:message code="email.appr.menu.normal" /></span>
				</h2>
				</c:if>
				
				<c:if test="${cChk == '1'}">
				<h2>
					<span class="h2Title" onClick="goPage(9)" style="display:inline-block;width:100%;"><spring:message code='main.t00027' /></span>
				</h2>
				<h2>
					<span class="h2Title" onClick="goPage(3)" style="display:inline-block;width:100%;"><spring:message code='main.t58' /></span>
				</h2>
				</c:if>
				<c:if test="${UseDisablePopImap == 'YES'}">
					<h2>
						<span onClick="goPage(39)" style="display:inline-block;width:100%;"><spring:message code='ezEmail.configPOP3IMAP' /></span>
					</h2>
				</c:if>
				<h2>
					<span class="h2Title" onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='main.t57' /></span>
				</h2>  
				<c:if test="${useSharedMailbox == 'YES'}">
					<h2>
						<span class="h2Title" onClick="goPage(33)" style="display:inline-block;width:100%;"><spring:message code='ezEmail.sharedMailbox01' /></span>
						<ul></ul>
					</h2>
				</c:if>
				<c:if test="${cChk == '1'}">
				<h2>
					<span class="h2Title" onClick="goPage(35)" style="display:inline-block;width:100%;"><spring:message code='ezEmail.multiDomain.ksa01' /></span>
				</h2> 
				<h2>
					<span class="h2Title" onClick="goPage(36)" style="display:inline-block;width:100%;"><spring:message code='ezEmail.multiDomain.ksa02' /></span>
				</h2>
	  			</c:if>
				<!-- 2018-02-20 재은 수정 (편지지 등록) -->
				<c:if test="${useLetter == 'YES'}">
					<h2>
						<span class="h2Title" onClick="goPage(30)" style="display:inline-block;width:100%;"><spring:message code='main.t374' /></span>
						<ul></ul>
					</h2>
				</c:if>
				<c:if test="${useSignatureTemplate == 'YES'}">
					<h2>
						<span class="h2Title" onClick="goPage(32)" style="display:inline-block;width:100%;"><spring:message code='ezEmail.jje05'/></span>
						<ul></ul>
					</h2>
				</c:if>
				<c:if test="${dotNetIntegration == 'YES' && cChk == '1'}">
					<h2><span class="h2Title" id="PARAMETER" style="display:inline-block;width:100%;" onClick="goPage(14)" ><spring:message code='main.kms1' /></span>
					<ul class="on"></ul>
					</h2>		
				</c:if>
				<c:if test="${dotNetIntegration == 'YES'}">
					<h2 class="off" id="menu2H2">
						<span class="h2Title" class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" id="MAIL" onClick="openFolder('menu2')"><spring:message code='ezStatistics.t2' /></span>
					</h2>
					<ul class="lnbUL off" id="menu2UL">
						<li><span class="sub_iconLNB tree_admin_stats"></span><span class="h2_text" onClick="goPage(23)"><spring:message code='ezStatistics.t1001' /></span></li>
						<li><span class="sub_iconLNB tree_admin_stats"></span><span class="h2_text" onClick="goPage(24)"><spring:message code='ezStatistics.t1012' /></span></li>
						<li><span class="sub_iconLNB tree_admin_stats"></span><span class="h2_text" onclick="goPage(25)"><spring:message code='ezStatistics.t1018' /></span></li>
						<li><span class="sub_iconLNB tree_admin_stats"></span><span class="h2_text" onclick="goPage(26)"><spring:message code='ezStatistics.t1023' /></span></li>
						<li><span class="sub_iconLNB tree_admin_stats"></span><span class="h2_text" onclick="goPage(27)"><spring:message code='ezStatistics.t1025' /></span></li>
						<li><span class="sub_iconLNB tree_admin_stats"></span><span class="h2_text" onclick="goPage(28)"><spring:message code='ezStatistics.kyj1' /></span></li>
						<li><span class="sub_iconLNB tree_admin_stats"></span><span class="h2_text" onclick="goPage(29)"><spring:message code='ezStatistics.kyj2' /></span></li>
					</ul>
					
					
				</c:if>
				<c:if test="${useCopyrightMenu == 'YES'}">
	  			<h2>
					<span  class="h2Title" onClick="goPage(34)" style="display:inline-block;width:100%;"><spring:message code='ezEmail.ksa06'/></span>
				    <ul></ul>
				</h2>
				</c:if>
			</div>
		</div>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" class="progressPanel" id="progressPanel">&nbsp;</div>
	</body>
</html>