<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	<title><c:out value='${caption}'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>  
		<script type="text/javascript">
	        var ReturnFunction;
	        window.onload = function () {
	            try {
	                ReturnFunction = parent.board_alertArguments[1];
	            } catch (e) {
	                try {
	                    ReturnFunction = opener.board_alertArguments[1];
	                } catch (e) { }
	            }
	        }
	        
            window.onbeforeunload = function () {
                if (!CrossYN()) {
                    parent.EzHTTPTrans.style.display = "";
                }                                   
            }
	        
	        function Button_Onclick(obj) {
// 	        	window.close();
	        	ReturnFunction();
// 	        	console.log("Button_Onclick");
// 	        	console.log(ReturnFunction);
// 	            var ReturnValue = obj.getAttribute("id");
// 	            if (ReturnFunction != null && ReturnFunction != undefined) {
// 	            	console.log("ReturnFunction != null && ReturnFunction != 'undefined'");
// 	                ReturnFunction(ReturnValue);
// 	            }
// 	            else {
// 	            	console.log("ReturnFunction == null || ReturnFunction == undefined");
// 	                window.returnValue = ReturnValue;
// 	                window.close()
// 	            }
	        }
		</script>
		
	</head>
	<body style="overflow:hidden;"> 
	<div class="popup_noti">
		<div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
	 	<div class="popup_noti_content">
	       <div  style="padding:10px;">
	      <table>
	        <tr>
	          <td  class="cimg"></td>
	          <td  class="ctxt" ><span id="LabelMessage"><c:out value='${message}'/></span></td>
	        </tr>
	      </table>
	 	</div>
	    </div>
	<div class="popup_noti_btnarea"> 
	    <div class="btnposition">
	    <c:forEach var="item" items="${buttonNamesArray}" varStatus="status">
	    	<input type='button' id='${status.index}' style='' value='<c:out value="${item}"/>' onclick='Button_Onclick(this)'>
	    </c:forEach> 	                 
<%-- 	        <input type='button' id='0' style='' value='${buttonName0}' onclick='Button_Onclick(this)'> 	                    --%>
<%-- 	        <input type='button' id='1' style='' value='${buttonName1}' onclick='Button_Onclick(this)'> 	                    --%>
<%-- 	        <input type='button' id='2' style='' value='${buttonName2}' onclick='Button_Onclick(this)'> 	                    --%>
		
	    </div>
	<span class="bl"> </span> <span class="br"></span></div>
	</div>
	</body>	
</html>