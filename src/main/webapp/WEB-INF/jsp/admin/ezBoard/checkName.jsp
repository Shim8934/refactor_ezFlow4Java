<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t331" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	     
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>	    
		<script type="text/javascript" language="javascript">
			
	    </script>
	</head>
	<body class="popup">		
		<xml id="listviewheader" style ="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<TYPE>sNONE</TYPE>
		        		<NAME><spring:message code="ezBoard.t8"/></NAME>
		        		<WIDTH>100</WIDTH>
		        		<SORTABLE>TRUE</SORTABLE>
		        		<RESIZIBLE>FALSE</RESIZIBLE>
		        		<MINSIZE>10</MINSIZE>
		        		<MAXSIZE>200</MAXSIZE>
		        		<NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code="ezBoard.t9"/></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code="ezBoard.t10"/></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
			      	<HEADER>
			        	<NAME><spring:message code="ezBoard.t11"/></NAME>
				        <WIDTH>70</WIDTH>
		      		</HEADER>
			      	<HEADER>
				        <NAME>E-MAIL</NAME>
				        <WIDTH>200</WIDTH>
				    </HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	</body>
</html>