<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<title><spring:message code='ezBoard.t242'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var gUserID = "";
		    var rtnVal = "cancel";
		    var ReturnFunction;
		    var rsa = new RSAKey();
		    function ReplaceText( orgStr, findStr, replaceStr )
		    {
		        var re = new RegExp( findStr, "gi" );
		        return ( orgStr.replace( re, replaceStr ) );
		    }
		
		    function btn_OpinionOK_onclick()
		    {
		        if (inpPassword.value == "") 
		        {
		            alert("<spring:message code='ezBoard.t243'/>");
		            return;
		        }
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/confirmPassword.do",
					data : { newPassword   : rsa.encrypt(document.getElementById("inpPassword").value),
							 itemID : "${itemID}"	
							},
					success: function(result){
						rtnVal = result;
					}        			
				});
		        
		        window.close();
		    }
		    window.onunload = function ()
		    {
		        if (ReturnFunction != null)
		            ReturnFunction(rtnVal);
		        else
		            window.returnValue = rtnVal;
		    };
		    function btn_OpinionCANCEL_onclick()
		    {
		        if (ReturnFunction != null)
		            rtnVal = "cancel";
		        else
		            window.returnValue = "cancel";
		        window.close();
		    }
		    window.onload = function ()
		    {
		        try {
		            ReturnFunction = opener.checkpassword_dialogArguments[1];
		        } catch (e) {}
		        
		        rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1)
		                KeEventControl(document.getElementById("inpPassword"));
		        }
		        catch (e) {
		        }
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<h1><spring:message code='ezBoard.t244'/></h1>
	    <div class="txt">
	        <spring:message code='ezBoard.t245'/>
	    </div>
	    <br />
	    <div>
	        <input type="password" class="textarea" id="inpPassword" name="inpPassword" style="WIDTH:100%">
	    </div>
	    <div class="btnposition">
	        <a name="btn_OpinionOK" id="btn_OpinionOK" class="imgbtn" onClick="return btn_OpinionOK_onclick()"  ><span><spring:message code='ezBoard.t14'/></span></a>
	        <a name="btn_OpinionCANCEL" id="btn_OpinionCANCEL" class="imgbtn" onClick="return btn_OpinionCANCEL_onclick()" ><span><spring:message code='ezBoard.t15'/></span></a>
	    </div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
	</body>
</html>