<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">	
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<style>
		.countryWrap { width: 720px; height: 550px; }
		.countryWrap .countryDiv { float:left; width: 47%; }
		.countryDiv {height: 80%;}
		.listview, .countryDivSec  { height: 100%; }
		.countryWrap .countryDiv .countryDivSec { overflow: auto; }
		.countryDivSec tbody > tr { cursor: pointer; vertical-align: middle; }   
		.countryDivSec tbody > tr:hover { background-color: rgba(244, 245, 245, 1); } 
		.countryDivSec tbody > tr img {  display: block; }
		.arrDiv {
			float:left; 
			width: 6%;
			height: 80%;
			box-sizing: border-box;
		    padding: 0 9px;
		    position: relative;
		}
		.arrDiv div { top: 50%; transform: translateY(-50%); position: absolute; left: 32%; }
		.arrDiv  img {  display: block; margin: 10px 0; }
		.countryBtn { width: 100%; float:left; box-sizing: border-box; }
	</style>
<body style="overflow:hidden; ">
	<br>
	<div class="countryWrap">
		<div class="countryDiv">
		    <div class="listview">
		        <div  class="countryDivSec">
			        <table class="mainlist_free" width="100%">
			        	<colspan>
			        		<col width="50"/>
			        		<col width=""/>
			        	</colspan>
			        	<thead>
					        <tr>
					        	<th colspan="2"><spring:message code='ezSystem.ksa04' /></th>
					        </tr>
				        </thead>
				        <tbody>
				        	<c:forEach items="${countryList }" var="item">
								<tr>
							        <td align="left">
							        	<img src="${item.imagePath}" alt="" title="" width="32">
							        </td>
							        <td align="left"><c:out value="${item.countryName }"/></td>
						        </tr>
					        </c:forEach>
			        	</tbody>
			        </table>
		        </div>
		    </div>
		</div>
		
		<div class="arrDiv">
			<div>
            	<img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="btn_Add_onclick()"/>
            	<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()"/>
            </div>
        </div>
        
		<div class="countryDiv">
		    <div class="listview">
		        <div class="countryDivSec">
			        <table class="mainlist_free" width="100%">
			        	<colspan>
			        		<col width="50"/>
			        		<col width=""/>
			        	</colspan>
			        	<thead>
					        <tr>
					        	<th colspan="2"><spring:message code='ezSystem.ksa05' /></th>
					        </tr>
				        </thead>
				        <tbody>
			        	</tbody>
			        </table>
			        
		        </div>
		    </div>
		</div>
		
		<div class="countryBtn btnpositionJsp">
	    	<a id="btn1" class="imgbtn" onclick="saveBtn()"><span><spring:message code='ezSystem.kbh09' /></span></a>
	    	<a id="btn2" class="imgbtn" onclick="cancleBtn()"><span><spring:message code='ezSystem.kbh10' /></span></a>
	    </div>
	    
	</div>
</body>
	
<script>

	window.onload = function () {
		iframeHeight();
	}
	window.parent.onresize = function () {
		iframeHeight();
	}
	
	function iframeHeight() {
		var iframeH = parent.document.getElementById("ipManager_ifrm").offsetHeight;
		var bodyH = document.body.offsetHeight;
		var iframeMH = parent.document.getElementById("ipManager_ifrm").style.maxHeight.split("px")[0];
		
		console.log("iframeH = " + iframeH + ", bodyH = " + bodyH + ", iframeMH = " + iframeMH);
		if (iframeH <= bodyH) {
			if (iframeMH < bodyH) {
				parent.document.getElementById("ipManager_ifrm").style.height = iframeMH + "px";
			} else {
				parent.document.getElementById("ipManager_ifrm").style.height = bodyH + "px";
			}
		}
	}
	
	function btn_Add_onclick() {
		
	}
	
	function DeleteReceiver() {
		
	}
	
	function saveBtn() {
		
	}
	
	function cancleBtn() {
		
	}
	

	$(".countryDivSec tr").on("click", function() {
		if ($(this).css("background").indexOf("rgb(241, 248, 255)") > -1) {
			$(this).css("background", "");
		} else {
			$(this).css("background", "rgb(241, 248, 255)");	
		}
		
	});
	
</script>

</html>