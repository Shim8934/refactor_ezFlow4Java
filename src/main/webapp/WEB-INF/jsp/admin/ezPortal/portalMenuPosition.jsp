<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t100'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
		<script type="text/javascript">
			var g_align = "${align}";
			var g_valign = "${vAlign}";
			var g_leftmargin = "${leftMargin}";
			var g_rightmargin = "${rightMargin}";
			var g_topmargin = "${topMargin}";
			var g_bottommargin = "${bottomMargin}";
			var pageid = "<c:out value = '${pageID}' />";
			var parentuid = "<c:out value = '${parentUID}' />";
			
			function window_onload() {
				tdpreview.align = g_align;
				//tdpreview.parentElement.vAlign = g_valign;
				tdpreview.style.verticalAlign = g_valign;
				tdpreview.style.paddingLeft = g_leftmargin + "px";
				tdpreview.style.paddingRight = g_rightmargin + "px";
				tdpreview.style.paddingTop = g_topmargin + "px";
				tdpreview.style.paddingBottom = g_bottommargin + "px";			
				
				topmargin.value = g_topmargin;
				bottommargin.value = g_bottommargin;
				leftmargin.value = g_leftmargin;
				rightmargin.value = g_rightmargin;
				
				if (g_align == "left") alignselect.selectedIndex = 0;
				if (g_align == "center") alignselect.selectedIndex = 1;
				if (g_align == "right") alignselect.selectedIndex = 2;
				if (g_valign == "top") valignselect.selectedIndex = 0;
				if (g_valign == "middle") valignselect.selectedIndex = 1;
				if (g_valign == "bottom") valignselect.selectedIndex = 2;			
			}
			
			function alignchange() {
				var obj = event.srcElement;
				switch(parseInt(obj.item(obj.selectedIndex).value))
				{
					case 1 : 
						tdpreview.align = "left";
						break;
					case 2 : 
						tdpreview.align = "center";
						break;
					case 3 : 
						tdpreview.align = "right";
						break;
					case 4 : 
						// 20071031 속성 변경
						//tdpreview.parentElement.vAlign = "top";
						tdpreview.style.verticalAlign = "top";
						break;
					case 5 : 
						//tdpreview.parentElement.vAlign = "middle";
						tdpreview.style.verticalAlign = "middle";
						break;
					case 6 : 
						//tdpreview.parentElement.vAlign = "bottom";
						tdpreview.style.verticalAlign = "bottom";
						break;					
				}
			}
			
			function SaveSetting()
			{
				var errorFlag = 0;
				if (!is_num(topmargin.value))    errorFlag = 1;
				if (!is_num(bottommargin.value)) errorFlag = 1;
				if (!is_num(leftmargin.value))   errorFlag = 1;
				if (!is_num(rightmargin.value))  errorFlag = 1;
				
				if (errorFlag == "1")
				{
					alert("<spring:message code='ezPortal.t58'/>");
					return;
				}
				
				var strXML = "<DATA>";
				strXML += "<UID_>" + parentuid + "</UID_>";
				strXML += "<ALIGN>" + alignselect.selectedIndex + "</ALIGN>";
				strXML += "<VALIGN>" + valignselect.selectedIndex + "</VALIGN>";
				strXML += "<PADDINGLEFT>" + leftmargin.value + "</PADDINGLEFT>";
				strXML += "<PADDINGRIGHT>" + rightmargin.value + "</PADDINGRIGHT>";
				strXML += "<PADDINGTOP>" + topmargin.value + "</PADDINGTOP>";
				strXML += "<PADDINGBOTTOM>" +  bottommargin.value + "</PADDINGBOTTOM>";
				strXML += "</DATA>";
				
				var xmlhttp = createXMLHttpRequest();
	
				xmlhttp.open("POST", "/admin/ezPortal/savePositionSettings.do?pageID=" + pageid, false);
				xmlhttp.send(strXML);
				
				xmlhttp = null;
				alert("<spring:message code='ezPortal.t119'/>");
				document.location.reload();
			}
		</script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
		<h1><spring:message code='ezPortal.t100'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table width="500" class="content">
			<tr>
				<th><spring:message code='ezPortal.t70'/></th>
				<td width="100%">
					<spring:message code='ezPortal.t71'/>
					<select id="alignselect" onChange="alignchange()">
						<option value="1"><spring:message code='ezPortal.t72'/></option>
						<option value="2" selected><spring:message code='ezPortal.t73'/></option>
						<option value="3"><spring:message code='ezPortal.t74'/></option>
					</select>
					&nbsp;
					<spring:message code='ezPortal.t75'/>
					<select id="valignselect" onChange="alignchange()">
						<option value="4"><spring:message code='ezPortal.t76'/></option>
						<option value="5" selected><spring:message code='ezPortal.t73'/></option>
						<option value="6"><spring:message code='ezPortal.t77'/></option>
					</select>		
			</tr>
			<tr> 
				<th><spring:message code='ezPortal.t78'/></th> 
				<td><spring:message code='ezPortal.t79'/>
					<input type="text" id="topmargin" style="width:30px"> px &nbsp;&nbsp;<spring:message code='ezPortal.t80'/>
					<input type="text" id="bottommargin" style="width:30px"> px&nbsp;&nbsp; <spring:message code='ezPortal.t81'/>
					<input type="text" id="leftmargin" style="width:30px"> px &nbsp;&nbsp;<spring:message code='ezPortal.t82'/>
					<input type="text" id="rightmargin" style="width:30px"> px</td> 
			</tr>
			<tr> 
				<th><spring:message code='ezPortal.t63'/></th> 
				<td align="center">
					<table width="100%" height="70" border="0" cellpadding="0" cellspacing="5"> 
						<tr> 
							<td id="tdpreview" style="border:1px solid #ddd"><spring:message code='ezPortal.t120'/></td> 
						</tr> 
					</table>			
				</td> 
			</tr>
		</table>
		<div class="btnposition">
        	<a class="imgbtn"><span onClick="SaveSetting();"><spring:message code='ezPortal.t62'/></span></a>
		</div>
	</body>
</html>