<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" >	        
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		    };
		    
		    function goPage(idx) {
		    	switch(idx) {
		    		case 1:
		    			window.open("/admin/ezWebFolder/webfolderAdminRight.do", "right");
		    			break;
		    		case 2:
		    			window.open("/admin/ezWebFolder/webfolderAdminPersonal.do", "right");
		    			break;	
		    	}
		    }
		    
		    function companyFolder() {		    	
		    	window.open("/admin/ezWebFolder/webfolderAdminCompanyFolder.do", "right");
		    }
		    
		    function companyFile() {
		    	window.open("/admin/ezWebFolder/webfolderAdminCompanyFile.do", "right");
		    }
		    
		    function fileTransactionHistory() {
		    	window.open("/admin/ezWebFolder/webfolderAdminFileHistory.do", "right");
		    }
	    </script>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
	    <div id="left" style="overflow: auto">
	        <div class="left_admin" title="<spring:message code='ezWebFolder.t10' />">
	        	<img src="/images/admin/first.png" width="16px" height="16px">&nbsp;<spring:message code="main.t29" />
	        </div>        

		    <h2>
  				<span style="display:inline-block;width:100%;"><spring:message code='ezWebFolder.t101' /></span>
  			</h2>  
    		<ul>
    			<li><span id="company"  style="width: 100%; display: inline-block;" onClick="goPage(1)" ><spring:message code='ezWebFolder.t102' /></span></li>
		        <li><span id="personal" style="width: 100%; display: inline-block;" onClick="goPage(2)" ><spring:message code='ezWebFolder.t103' /></span></li>		        	        
		    </ul>
		    
		    <h2>
  				<span style="display:inline-block;width:100%;" onClick="companyFolder();"><spring:message code='ezWebFolder.t126' /></span>
  			</h2>
  			<ul>
  			</ul>
  			    
		   	<h2>
  				<span style="display:inline-block;width:100%;" onClick="companyFile();"><spring:message code='ezWebFolder.t127' /></span>
  			</h2> 
  			<ul>
  			</ul>
			
			<h2>
  				<span style="display:inline-block;width:100%;" onClick="fileTransactionHistory();"><spring:message code='ezWebFolder.t128' /></span>
  			</h2>
  			<ul>
  			</ul> 
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	</body>
</html>