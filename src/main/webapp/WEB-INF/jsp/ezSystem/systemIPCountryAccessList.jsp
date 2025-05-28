<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">	
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<style>
		.countryWrap { width: 720px; height: 550px; }
		.countryWrap .countryDiv { float:left; width: 47%; }
		.countryDiv {height: 90%;}
		.listview, .countryDivSec  { height: 100%; }
		.countryWrap .countryDiv .countryDivSec { overflow: auto; }
		.countryDivSec tbody > tr { cursor: pointer; vertical-align: middle; }   
		.countryDivSec tbody > tr img {  display: block; }
		.arrDiv {
			float:left; 
			width: 6%;
			height: 90%;
			box-sizing: border-box;
		    padding: 0 9px;
		    position: relative;
		}
		.arrDiv div { top: 50%; transform: translateY(-50%); position: absolute; left: 32%; }
		.arrDiv  img {  display: block; margin: 10px 0; }
		.countryBtn { width: 100%; float:left; box-sizing: border-box; }
		
		.counntryTRSelect { background: rgb(241, 248, 255); }
		.counntryTRHover { background-color: rgb(244, 245, 245); }
	</style>
<body style="overflow:hidden; " onselectstart="return false" ondragstart="return false">
	<br>
	<div class="countryWrap">
		<div class="countryDiv">
		    <div class="listview">
		        <div class="countryDivSec countryList">
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
								<tr data-name="${item.countryName }" data-code="${item.countryCode }">
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
            	<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="btn_Del_onclick()"/>
            </div>
        </div>
        
		<div class="countryDiv">
		    <div class="listview">
		        <div class="countryDivSec countryAccessList">
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
	var countryAccessList = [];
	
	window.onload = function () {
		iframeHeight();
		getAccessCountryList();
	}
	window.parent.onresize = function () {
		iframeHeight();
	}
	
	function getAccessCountryList() {
		var printTR = "<tr data-name=\"{countryName}\" data-code=\"{countryCode}\" >";
			printTR += "<td align=\"left\"><img src=\"{imagePath}\" alt=\"\" title=\"\" width=\"32\"></td>"; 
			printTR += "<td align=\"left\">{countryName}</td></tr>"; 
		
		$.ajax({
			type : "post",
			url : "/ezSystem/getAccessCountryList.do",
			dataType : "json",
			success : function(data) {
				if (typeof data.data != "undefined") {
					var appendHTML = "";
					countryAccessList = [];
					
					data.data.forEach(function (ele, index) {
						var tempTR = printTR;
						
						countryAccessList.push(ele.countryCode);
						
						tempTR = tempTR.replace(/{countryName}/gi, ele.countryName);
						tempTR = tempTR.replace(/{countryCode}/gi, ele.countryCode);
						tempTR = tempTR.replace(/{imagePath}/gi, ele.imagePath);
						appendHTML += tempTR;
					});
					
					$(".countryAccessList tbody").empty();
					$(".countryAccessList tbody").append(appendHTML);
				} //if end
			}
		});
	}
	
	function iframeHeight() {
		var iframeH = parent.document.getElementById("ipManager_ifrm").offsetHeight;
		var bodyH = document.body.offsetHeight;
		var iframeMH = parent.document.getElementById("ipManager_ifrm").style.maxHeight.split("px")[0];
		
		if (iframeH <= bodyH) {
			if (iframeMH < bodyH) {
				parent.document.getElementById("ipManager_ifrm").style.height = iframeMH + "px";
			} else {
				parent.document.getElementById("ipManager_ifrm").style.height = bodyH + "px";
			}
		}
	}
	
	function btn_Add_onclick() {
		$(".countryList").find(".counntryTRSelect").each(function(index, ele) {
			addFunction(ele);
		});
	}
	
	function btn_Del_onclick() {
		$(".countryAccessList").find(".counntryTRSelect").each(function(index, ele) {
			delFuntion(ele);
		});
	}
	
	function addFunction(thisEle) {
		var selectCountryTR = $(thisEle).clone(true);
		var thisCountryCode = $(selectCountryTR).attr("data-code");
		
		if (countryAccessList.indexOf(thisCountryCode) == -1) {
			countryAccessList.push(thisCountryCode);
			
			var printCountryTR = $(selectCountryTR).removeClass("counntryTRSelect");
			$(".countryAccessList tbody").append(printCountryTR);
		}
	}
	
	function delFuntion(thisEle) {
		var thisCountryCode = $(thisEle).attr("data-code");
		var countryAccessListIndex = countryAccessList.indexOf(thisCountryCode);

		if (countryAccessListIndex > -1) {
			countryAccessList.splice(countryAccessListIndex, 1);
		}
		
		$(thisEle).remove();
	}
	
	function saveBtn() {
		$.ajax({
			type : "post",
			url : "/ezSystem/saveAccessCountryList.do",
			data : { "saveList" : countryAccessList.join(";")},
			success : function(data) {
			    if (data == "setAccess") {
                    alert("<spring:message code='ezSystem.yja05'/>");
                    getAccessCountryList();
                    return;
                }
				if (data == "PERMISSION_ERROR") {
					alert("<spring:message code='ezTask.t1' />");
				} else {
					alert("<spring:message code='ezSystem.ksa06' />");				
				}
			}, error : function () {
				alert("<spring:message code='ezSystem.ksa07' />");	
			}
		});
	}
	
	function cancleBtn() {
		getAccessCountryList();
	}
	
 	$(document).on("click", ".countryDivSec tbody > tr", function() {
		if ($(this).hasClass("counntryTRHover")){
			$(this).removeClass("counntryTRHover");
		}
		$(this).toggleClass("counntryTRSelect");
	}); 
	
	$(document).on("mouseover", ".countryDivSec tbody > tr", function() {
		if (!$(this).hasClass("counntryTRSelect")){
			$(this).addClass("counntryTRHover");
		}
	});
	
	$(document).on("mouseleave", ".countryDivSec tbody > tr", function() {
		$(this).removeClass("counntryTRHover");
	});
	
	$(document).on("dblclick", ".countryDivSec tbody > tr", function() {
		if ($(this).parents(".countryList").length == 1) {
			addFunction(this);
		} else if ($(this).parents(".countryAccessList").length == 1) {
			delFuntion(this);
		}
	});
	
</script>

</html>