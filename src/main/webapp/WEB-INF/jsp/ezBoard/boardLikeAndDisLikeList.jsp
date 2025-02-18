<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezBoard.kmh09' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list_admin.js')}"></script>
	
<style>  
	table { border-collapse:collapse; margin-top: 10px; margin-bottom: 10px; table-layout:fixed; text-align:center;}
	th, td { border:1px solid black; height: 20px; padding-left: 2px; word-break:break-all}
</style>
	
<script type="text/javascript">
	var xmlDoc = loadXMLString('${strXML}');
	var html = "";
	window.onload = function() {
		var nameCount = "";
		for (var i = 0; i < SelectNodes(xmlDoc, "DATA/ROW").length; i++) {
			
			likeNameCheck =xmlDoc.getElementsByTagName("LIKELIST").item(i).getElementsByTagName("DISPLAYNAME").length;
			disLikeNameCheck =xmlDoc.getElementsByTagName("DISLIKELIST").item(i).getElementsByTagName("D_DISPLAYNAME").length;
			
			html += "<table style='border-collapse:collapse;text-align:center;'>"
			html +=	"<colgroup>"
			html +=	"<col style='width :150px;'>"
			html +=	"<col style='width :150px;'>"
			html +=	"<col style='width :150px;'>"
			html +=	"<col style='width :150px;'>"
			html +=	"<col style='width :150px;'>"
			html +=	"<col style='width :150px;'>"
			html +=	"<colgroup>"
			html +=	"<tr style='border: 1px solid black;'>"
			html +=	"<td colspan='1' style='background-color: #dfdfdf;'><spring:message code='ezBoard.kmh04' /></td>"
			html += "<td colspan='5'>"
			html += xmlDoc.getElementsByTagName("ITEMINFO").item(i).getElementsByTagName("TITLE").item(0).childNodes[0].nodeValue;
			html += "</td>"
			html +=	"</tr>"
			html +=	"<tr style='border: 1px solid black;'>"
			html += "<td colspan='3' style='background-color: #dfdfdf;' ><spring:message code='ezBoard.kmh05' />("
				
				if(likeNameCheck === 0){
					html += "0" + ")</td>"
				}else{
					html +=	xmlDoc.getElementsByTagName("LIKELIST").item(i).getElementsByTagName("LIKELISTCOUNT").item(0).childNodes[0].nodeValue + ")</td>"
				}		
			
			html += "</td>"
			html +=	"<td colspan='3' style='background-color: #dfdfdf;'><spring:message code='ezBoard.kmh06' />("
				
				if(disLikeNameCheck === 0){
					html += "0" + ")</td>"
				}else{
					html +=	xmlDoc.getElementsByTagName("DISLIKELIST").item(i).getElementsByTagName("DISLIKELISTCOUNT").item(0).childNodes[0].nodeValue + ")</td>"
				}	
			
			html += "</td>"
			html +=	"</tr>"
			
			if(likeNameCheck >= disLikeNameCheck){
				nameCount = likeNameCheck;
			}else{
				nameCount = disLikeNameCheck;
			}
			
			if(likeNameCheck =="0"&&disLikeNameCheck =="0"){		
				html+="<tr style='border: 1px solid black;'>"
				html+="<td colspan ='3' style='height: 40px;'><spring:message code='ezBoard.kmh02' /></td>"
				html+="<td colspan ='3' style='height: 40px;'><spring:message code='ezBoard.kmh03' /></td>"
				html+="</tr>"
			}else{
			for(var j = 0; j < nameCount; j++){
					if(likeNameCheck == "0"){
						html += "<tr style='height: 40px; border: 1px solid black;'>"
						html += "<td></td>"
 	 				 	html += "<td></td>"
 	 				 	html += "<td></td>"
 				 	}else{
 				 		if(likeNameCheck > j){
			 			html += "<tr style='height: 40px; border: 1px solid black;'>"
						html += "<td>"
						html +=  xmlDoc.getElementsByTagName("LIKELIST").item(i).getElementsByTagName("DISPLAYNAME").item(j).childNodes[0].nodeValue;
			 			html += "</td>"
			 			html += "<td>"
			 			html +=  xmlDoc.getElementsByTagName("LIKELIST").item(i).getElementsByTagName("USERID").item(j).childNodes[0].nodeValue;
			 			html += "</td>"
			 			html += "<td>"
				 		html +=  xmlDoc.getElementsByTagName("LIKELIST").item(i).getElementsByTagName("LIKEDATE").item(j).childNodes[0].nodeValue;
			 			html += "</td>"
 				 		}else{
 				 			html += "<tr style='height: 40px; border: 1px solid black;'>"
 				 			html += "<td></td>"
 	 				 		html += "<td></td>"
 	 				 		html += "<td></td>"
 	 				 		}
					}	 
				
 				 	if(disLikeNameCheck == "0"){
						html += "<td></td>"
	 				 	html += "<td></td>"
	 				 	html += "<td></td>"
						html += "</tr>"
 				 	}else{
 				 		if(disLikeNameCheck > j){
						html += "<td>"
						html +=  xmlDoc.getElementsByTagName("DISLIKELIST").item(i).getElementsByTagName("D_DISPLAYNAME").item(j).childNodes[0].nodeValue;
			 			html += "</td>"
			 			html += "<td>"
			 			html +=  xmlDoc.getElementsByTagName("DISLIKELIST").item(i).getElementsByTagName("D_USERID").item(j).childNodes[0].nodeValue;
			 			html += "</td>"
			 			html += "<td>"
				 		html +=  xmlDoc.getElementsByTagName("DISLIKELIST").item(i).getElementsByTagName("D_DISLIKEDATE").item(j).childNodes[0].nodeValue;
			 			html += "</td>"
			 			html += "</tr>"
 				 		}else{
 				 			html += "<td></td>"
 	 				 		html += "<td></td>"
 	 				 		html += "<td></td>"
 	 				 		html += "</tr>"
 	 				 		}
					}	 
				}
			}
			html += "</table>"
			html += "<table>"
			html += "<tr style ='border: none'></tr>"
			html += "</table>"
		}	
			document.getElementById("listTable").innerHTML = document.getElementById("listTable").innerHTML + html;
	}
	
	function excelDown() {
		xmlDocListHttp = createXMLHttpRequest();
		var xmlPara = '${strXML}';
		var excelFileName = "<spring:message code='ezBoard.kmh11' />";
		xmlDocListHttp.open("post", "/ezBoard/excelLikeAndDisLikeList.do", true);
		xmlDocListHttp.responseType='blob';
		xmlDocListHttp.send(xmlPara);
		xmlDocListHttp.onload = function(e) {
			if (this.status == 200) {
				var blob = new Blob([this.response] ,{ type: "application/vnd.ms-excel" });
				var a = document.createElement("a");
				a.setAttribute("type", "hidden");
				var ua = window.navigator.userAgent;
				if(ua.indexOf('MSIE') > 0 || ua.indexOf('Trident') > 0) {
					navigator.msSaveOrOpenBlob(blob,excelFileName+'.xls');
				} else {
					var url = window.URL.createObjectURL(blob);
					a.href = url;
					a.download = excelFileName+'.xls';
					document.body.appendChild(a);
					a.click();
					window.URL.revokeObjectURL(url);
				}
			} else {
				alert("<spring:message code='ezBoard.t181' />");
			}
		};
	}
	
</script>
	
</head>
<body class="popup">
	<h1>
		<spring:message code='ezBoard.kmh09' />
	</h1>
	<div id="close">
		<ul>
			<li><span onclick="window.close()"></span></li>
		</ul>
	</div>
	<div id="listTable" style="margin-bottom: 80px">
	</div>
	<div class="btnposition btnpositionNew">
		<a class ="imgbtn" onClick="excelDown()"><span><spring:message code='ezBoard.kmh10' /></span></a>
		<a class ="imgbtn" onClick="window.close()" name="Cloase"><span><spring:message code='ezBoard.t14' /></span></a>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.5); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' /> " style="border: none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>