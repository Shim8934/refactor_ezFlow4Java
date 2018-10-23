<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <title><spring:message code='ezPortal.pjg11'/></title>
        <script>        
        $(document).ready(function() {
    		$("#btn").click(function(e) {
    		    $.ajax({
    		    	url: "/ezExchange/exchangeRate.do",
    			    dataType: "JSON",
    			    type: "GET",
    		        //jsonpCallback: 'processJSONPResponse',
    		      success: function(result, status, xhr) {
    		    	  console.log(result);
    		    	  result = JSON.stringify(result);
    		    	  for(var i=0; i<result.length; i++){
    		    		  document.write(result[i]);
    		    	  }
    		      },
    		      error: function(xhr, status, error) {
    		        console.log("Result: " + status + " xhr: " + xhr + " xhr.status: " + xhr.status + " xhr.statusText: " + xhr.statusText)
    		      }
    		    });
    		  });
    		
    		
    	})
    	
    	
		</script>
		<input type="button" id="btn" value="확인"/>
	<div id="result"></div>
	</head>
	<body>
	    
	</body>
</html>