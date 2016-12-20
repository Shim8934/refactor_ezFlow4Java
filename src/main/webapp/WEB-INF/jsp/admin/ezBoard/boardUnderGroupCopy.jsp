<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.jjh01" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	     
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    	    
		<script type="text/javascript" language="javascript">
			var pBoardID = "<c:out value='${boardID}'/>";
	    	
	    	$(document).ready(function(){
	    		if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.getElementById("div1").style.margin = "15px";
	            }	    		
	    	});
	    	
	    	function Save_Acl() {
	    		var objRoot, objNode, radio;
	            radio = document.getElementsByName("radioAcl");

	            for (var i = 0 ; i < radio.length; i++) {
	                if (radio[i].checked == true){
	                    type = radio[i].value;
	                }
	            }
	            
	            $.ajax({
	            	type : "POST",
	            	dataType : "text",
	            	url : "/admin/ezBoard/setUnderBoardAcl.do",
	            	data : {boardID : pBoardID, type : type},
	            	success : function(){
	            		alert("<spring:message code='ezBoard.t79' />.")
		                window.close();
	            	},
	            	error : function(error){
	            		alert("Error : " + error);
	            	}
	            });
			}

	        function window_Cancel() {
	            window.close();
	        }
	    </script>
	</head>
	<body class="popup">		
		<h1><spring:message code="ezBoard.t610" /></h1>
	    <h2 class="h2_dot"><spring:message code="ezBoard.t611" /></h2>
	    <div style="text-align:center; margin:10px;" id="div1">
		    <span class="txt">
		        <input type="radio" name="radioAcl" value="1" /> <spring:message code="ezBoard.t612" />
		        <input type="radio" name="radioAcl" value="2" /> <spring:message code="ezBoard.t613" />
		    </span>
	    </div>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="Save_Acl()"><spring:message code="ezBoard.t14" /></span></a>
	        <a class="imgbtn"><span onclick="window_Cancel()"><spring:message code="ezBoard.t15" /></span></a>
	    </div>
	</body>
</html>