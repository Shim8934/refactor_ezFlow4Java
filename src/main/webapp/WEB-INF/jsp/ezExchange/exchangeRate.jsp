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
    		var authkey = "bEpJzTo23DwqD1TOODGOlf3QuXhDrsxe";
    		var searchdate = new Date().toISOString().slice(0,10).replace(/-/g,"");
    		var data = "AP01";
    		var urlData = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey="+authkey+"&searchdate="+searchdate+"&data="+data;
    		
    		
    		$("#btn").click(function(e) {
    		    $.ajax({
    		    	url: urlData,
    			    dataType: "JSON",
    			    type: "GET",
    			    jsonp: false,
    		      jsonpCallback: 'processJSONPResponse',
    		      success: function(result, status, xhr) {
    		    	  console.log(result);
    		    	  result = JSON.stringify(result);
    		    	  for(var i=0; i<result.length; i++){
    		    		  document.write(result[i]);
    		    	  }
    		      },
    		      error: function(xhr, status, error) {
    		        console.log("Result: " + status + " " + error + " " + xhr.status + " " + xhr.statusText)
    		      }
    		    });
    		    
    		    function processJSONPResponse(data) {
        			console.log("Run here!");
        			console.log(data);
        		}
    		  });
    		
    		
    	})
    	
    	
		</script>
		<input type="button" id="btn" value="확인"/>
	<div id="result"></div>
	</head>
	<body>
	    
	</body>
</html>