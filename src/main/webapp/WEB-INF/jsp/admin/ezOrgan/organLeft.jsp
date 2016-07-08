<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="main.t23" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	   	   	
	    <link rel="stylesheet" href="<spring:message code='main.e15' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			document.onselectstart = function (){
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA"){
		            return false;
		        }else{
		            return true;
		        }
		    };
		    
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
						url = "/myoffice/ezEmail/Admin/mail_mailboxstore_environ.aspx" ;
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
						url = "/myoffice/ezEmail/Admin/mail_Config_Color.aspx";
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
		            case 20:
		                url = "/myoffice/ezEmail/Admin/mail_DLMailConfig.aspx";
		                break;
		            case 21:
		                url = "/myoffice/ezEmail/DLmail_list.aspx";
		                break;
				}
				window.open(url,"right");
			}
	    </script>
	</head>
	<body class="leftbody" style="margin:0px 0px 0px 0px">
		<div id="left">
  			<div class="left_admin" title="<spring:message code='main.t23' />"><spring:message code='main.t23' /></div>   
  			<h2>
  				<span onClick="goPage(1)" style="display:inline-block;width:100%;"><spring:message code='main.t56' /></span>
  			</h2>  
    		<ul>
		        <li><span id="Organ" style="width: 100%; display: inline-block;" onClick="goPage(1)" ><spring:message code='main.t56' /></span></li>
		        <li><span id="CheckAdmin" style="width: 100%; display: inline-block;" onClick="goPage(12)" ><spring:message code='main.t00062' /></span></li>
		        <li><span id="Addjob" style="width: 100%; display: inline-block;" onClick="goPage(13)" ><spring:message code='main.t00063' /></span></li>
		    </ul>   
  			<h2>
  				<span onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='main.t57' /></span>
    			<ul></ul>    			
  			</h2>  
  			<h2>
  				<span onClick="goPage(20)" style="display:inline-block;width:100%;"><spring:message code='main.t1000' /></span>
    			<ul></ul>
  			</h2>
  			<h2>
  				<span onClick="goPage(21)" style="display:inline-block;width:100%;"><spring:message code='main.t1001' /></span>
    			<ul></ul>
  			</h2>
  			<h2>
  				<span onClick="goPage(3)" style="display:inline-block;width:100%;"><spring:message code='main.t58' /></span>
    			<ul></ul>
  			</h2>
  			<!-- 2016-04-05 장진혁 편지지등록 / REQUEST에 MSIE 또는 TRIDENT가 포함될 시에만 메뉴 보여줌으로 되어있었음  -->							
			<h2>
				<span onClick="goPage(5)" style="display:inline-block;width:100%;"><spring:message code='main.t374' /></span>
			    <ul></ul>
			</h2>
			<!-- 편지지등록 끝 -->
			<h2>
				<span onClick="goPage(9)" style="display:inline-block;width:100%;"><spring:message code='main.t00027' /></span>
			    <ul></ul>
			</h2>
			<h2>
				<span onClick="goPage(10)" style="display:inline-block;width:100%;"><spring:message code='main.t377' /></span>
			    <ul></ul>
			</h2>
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>	    
	</body>
</html>