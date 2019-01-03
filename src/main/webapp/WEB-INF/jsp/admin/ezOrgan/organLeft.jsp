<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="main.t23" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	   	   	
	    <link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css">	
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">	
	    <style>
			#mCSB_1_container {
				margin-right: 0px;
			} 
		</style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" language="javascript">
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
				
				switch(idx){
				    case 1:
				        url = "/admin/ezOrgan/organRight.do";
						break;
				    case 2:
				        url = "/admin/ezEmail/mailDistributionList.do";
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
					case 10:
						url = "/admin/ezOrgan/retireUserManage.do";
						break;
					case 11:
						url = "/myoffice/ezEmail/Admin/Right_LargeSizeMailManage.aspx";
						break;
				    case 12:
				        url = "/admin/ezOrgan/permissionsList.do";
				        break;
				    case 13:
				        url = "/admin/ezOrgan/addJobList.do";
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
				    case 31:
				    	url = "/admin/ezOrgan/jobInfoList.do";
				    	break;
				    case 32:
				    	url = "/admin/ezEmail/signatureMain.do";
					 	break;
				    case 33:
					 	url = "/admin/ezEmail/showSharedMailboxList.do";
				    	break;
				}
				window.open(url,"right");
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
	    </script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="<spring:message code='main.t8' />">
				<spring:message code='main.t8' />
  			</div>
  			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<c:if test="${cChk == '1'}">
					<h2>
						<span class="list_text" id="Organ" onClick="goPage(1)" ><spring:message code='main.t56' /></span>
						<ul></ul>
					</h2> 
					<h2>
						<span class="list_text" id="CheckAdmin" onClick="goPage(12)" ><spring:message code='main.t00062' /></span>
						<ul></ul>
					</h2> 
					<h2>
						<span class="list_text" id="Addjob" onClick="goPage(13)" ><spring:message code='main.t00063' /></span>
						<ul></ul>
					</h2> 
					<h2>
						<span class="list_text" id="JobInfo" onClick="goPage(31)"><spring:message code='ezOrgan.csj01' /></span>
						<ul></ul>
					</h2> 
					<h2>
						<span class="list_text" onClick="goPage(10)"><spring:message code='main.t377' /></span>
						<ul></ul>
					</h2>
	  			</c:if>			

	  			
				<c:if test="${dotNetIntegration == 'YES'}">
	            <h2><span id="PARAMETER" style="display:inline-block;width:100%;" onClick="goPage(14)" ><spring:message code='main.kms1' /></span>
	            <ul class="on"></ul>
	            </h2>		
	      	    <h2><span id="MAIL" style="display:inline-block;width:100%;" onClick="goPage(23)"><spring:message code='ezStatistics.t2' /></span></h2>
			    <ul>
				    <li><span style="display:inline-block;width:100%;" onClick="goPage(23)"><spring:message code='ezStatistics.t1001' /></span></li>
				    <li><span style="display:inline-block;width:100%;" onClick="goPage(24)"><spring:message code='ezStatistics.t1012' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(25)"><spring:message code='ezStatistics.t1018' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(26)"><spring:message code='ezStatistics.t1023' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(27)"><spring:message code='ezStatistics.t1025' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(28)"><spring:message code='ezStatistics.kyj1' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(29)"><spring:message code='ezStatistics.kyj2' /></span></li>
			    </ul>			            				
	            </c:if>		
            </div>
		</div>
        <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
	</body>
</html>
