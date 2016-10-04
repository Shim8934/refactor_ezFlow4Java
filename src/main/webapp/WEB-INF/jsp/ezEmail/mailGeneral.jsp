<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_general</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
        <script src="/js/jquery/raphael.2.1.0.min.js"></script>
        <script src="/js/jquery/justgage.1.0.1.min.js"></script>
		<script type='text/javascript'>
		    var xmlhttp;
		    document.onselectstart = function () { return false; };
		    var MailQuater;
		    window.onload = function()
		    {
		        MailQuater = new JustGage({
		            id: "mailquatersize",
		            value: 0,
		            min: 0,
		            max: 100,
		            showInnerShadow: true,
		            levelColorsGradient : true
		        });
		       
		        xmlhttp = createXMLHttpRequest();
                xmlhttp.open("POST", "/ezEmail/mailGetUse.do", true);
                xmlhttp.onreadystatechange = detailbox_after;
                xmlhttp.send();
		    }

		    function detailbox_after()
		    {
                if(xmlhttp == null || xmlhttp.readyState != 4) return;
                var result = xmlhttp.responseXML;
                		        
                if (CrossYN()) {
                    var resultvalue2 = "<spring:message code='ezEmail.t313' />" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].textContent + "<spring:message code='ezEmail.t314' />";
                    resultvalue2 += GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].textContent + "(" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent + "%)<spring:message code='ezEmail.t315' /><spring:message code='ezEmail.t316' />";
                    MailQuater.refresh(parseInt(GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent))
                } else {
                    var resultvalue2 = "<spring:message code='ezEmail.t313' />" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].text + "<spring:message code='ezEmail.t314' />";
                    resultvalue2 += GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].text + "(" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text + "%)<spring:message code='ezEmail.t315' /><spring:message code='ezEmail.t316' />";
                    MailQuater.refresh(parseInt(GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text))                    
                }
                
		        MailQuater.refreshtitle(resultvalue2);		        
		    }
			function Change_Click(Gubun)
			{
				if (listcount.value == "" || listcount.value != parseInt(listcount.value))
				{
					alert("<spring:message code='ezEmail.t170' />");
					listcount.focus();
					return;
				}

				if (parseInt(listcount.value) < 5 || parseInt(listcount.value) > 500)
				{
					alert("<spring:message code='ezEmail.t171' />");
					listcount.focus();
					return;
				}

				if (refreshinterval.value == "" || refreshinterval.value != parseInt(refreshinterval.value))
				{
					alert("<spring:message code='ezEmail.t172' />");
					refreshinterval.focus();
					return;
				}

				if (parseInt(refreshinterval.value) < 300 || parseInt(refreshinterval.value) > 50000)
				{
					alert("<spring:message code='ezEmail.t173' />");
					refreshinterval.focus();
					return;
				}
			    if (parseInt(document.getElementById("WListUser").value) + parseInt(document.getElementById("WPreUser").value) > 100) {
			        alert(strLang303);
			        return;
			    }
			    if (parseInt(document.getElementById("HListUser").value) + parseInt(document.getElementById("HPreUser").value) > 100) {
			        alert(strLang304);
			        return;
			    }
			    var ExtName = "";
			    for (var i = 0; i < document.getElementById("ExtSenderNM").childNodes.length; i++) {
			        if (document.getElementById("ExtSenderNM").childNodes.item(i).nodeName == "OPTION") {
			            var pOptionValue = document.getElementById("ExtSenderNM").childNodes.item(i).value;
			            ExtName += ExtName == "" ? pOptionValue : "|!-@-!|" + pOptionValue;
			        }
			    }

				var xmlHTTP = createXMLHttpRequest();
				xmlHTTP.open("POST", "/ezEmail/mailGeneralSave.do?MODE=ALL", false);
				xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlHTTP.send(
				"<DATA><LISTCOUNT>" + listcount.value + "</LISTCOUNT><REFRESHINTERVAL>" + refreshinterval.value + "</REFRESHINTERVAL>"+
                "<KEEPDELETELENGTH>" + document.getElementById("AutoSaveTime").value + "</KEEPDELETELENGTH>"+
                "<PREVIEWMODE>" + document.getElementById("PreviewMode").value + "</PREVIEWMODE>"+
                "<PREVIEWWLIST>" + document.getElementById("WListUser").value + "</PREVIEWWLIST>" +
                "<PREVIEWWCONTENT>" + document.getElementById("WPreUser").value + "</PREVIEWWCONTENT>" +
                "<PREVIEWHLIST>" + document.getElementById("HListUser").value + "</PREVIEWHLIST>" +
                "<PREVIEWHCONTENT>" + document.getElementById("HPreUser").value + "</PREVIEWHCONTENT>" +
                "<MAILSENDERNM>" + MakeXMLString(ExtName) + "</MAILSENDERNM>" +
                "</DATA>"
				);
				if (Gubun == "1") {
				    if (xmlHTTP.status == 200)
				        alert("<spring:message code='ezEmail.t42' />");
				    else
				        alert("<spring:message code='ezEmail.t176' />" + xmlHTTP.statusText);
				}
			}
		    function MakeXMLString(pStr) {
		        pStr = ReplaceText(pStr, "&", "&amp;");
		        pStr = ReplaceText(pStr, "<", "&lt;");
		        pStr = ReplaceText(pStr, ">", "&gt;");
		        return pStr;
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
			function Cancel_Click()
			{
				window.location.reload(true);
			}
			function PrevieOption(obj) {
			    if (obj.value == "OFF") {
			        document.getElementById("PreviewHSizeDiv").style.display = "none";
			        document.getElementById("PreviewWSizeDiv").style.display = "none";
			    }
			    else if (obj.value == "H") {
			        document.getElementById("PreviewHSizeDiv").style.display = "";
			        document.getElementById("PreviewWSizeDiv").style.display = "none";
			    }
			    else {
			        document.getElementById("PreviewHSizeDiv").style.display = "none";
			        document.getElementById("PreviewWSizeDiv").style.display = "";
			    }
			}
			function HChange(obj) {
			    if (obj == document.getElementById("HListUser")) {
			        document.getElementById("HPreUser").value = 100 - parseInt(obj.value);
			    }
			    else {
			        document.getElementById("HListUser").value = 100 - parseInt(obj.value);
			    }
			}
			function WChange(obj) {
			    if (obj == document.getElementById("WListUser")) {
			        document.getElementById("WPreUser").value = 100 - parseInt(obj.value);
			    }
			    else {
			        document.getElementById("WListUser").value = 100 - parseInt(obj.value);
			    }
			}
			function MailOutNameModify() {
			    for (var i = 0; i < document.getElementById("ExtSenderNM").childNodes.length; i++) {
			        if (document.getElementById("ExtSenderNM").childNodes.item(i).nodeName == "OPTION") {
			            var pOptionValue = document.getElementById("ExtSenderNM").childNodes.item(i).value;
			            Conitems.innerHTML += "<div style='font-family:dotum;font-size:small;height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + pOptionValue + "'><nobr>" + pOptionValue + "</nobr><div>";
			        }
			    }  
			    inboxRuleConbtn1.style.display = "";
			    inboxRuleCon1.focus();
			}
			function event_Mover(obj) {
			    if (obj != _popObj)
			        obj.style.backgroundColor = "#EDEDED";
			}
			function event_Mout(obj) {
			    if (obj != _popObj)
			        obj.style.backgroundColor = "#FFFFFF";
			}
			var _popObj = null;;
			function event_Mclick(obj) {

			    if (_popObj != null) {
			        _popObj.style.backgroundColor = "#ffffff";
			    }
			    _popObj = obj;
			    obj.style.backgroundColor = "#DBE1E7";
			}
			var ConCellRow = null;
			function pop_modify(obj) {
			    ConCellRow = obj;
			    inboxRuleCon1.value = obj.getAttribute("value");
			    inboxRuleCon1.focus();
			    document.getElementById("inputBtn").innerText = strLang240;
			}
			function pop_delete() {
			    if (_popObj != null) {
			        inboxRuleCon1.value = "";
			        _popObj.outerHTML = "";
			        inboxRuleCon1.focus();
			        inputBtn.innerText = strLang239;
			        ConCellRow = null;
			        return;
			    }
			}
			function event_keyDown() {
			    if (event.keyCode == "13")
			        pop_addcon();
			}
			function pop_addcon() {
			    if (inboxRuleCon1.value.length > 0) {
			        var ischeck = true;
			        for (var i = 0; i < Conitems.childNodes.length; i++) {
			            if (inboxRuleCon1.value == Conitems.childNodes.item(i).value) {
			                if (confirm(strLang221)) {
			                    inboxRuleCon1.focus();
			                    return;
			                }
			                else {
			                    inboxRuleCon1.value = "";
			                    inboxRuleCon1.focus();
			                    inputBtn.innerText = strLang239;
			                    ConCellRow = null;
			                    return;
			                }
			            }
			        }
			        if (ischeck) {
			            if (ConCellRow != null) {
			                ConCellRow.outerHTML = "<div style='font-family:dotum;font-size:small;height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + inboxRuleCon1.value + "'><nobr>" + inboxRuleCon1.value + "</nobr><div>";
			                inboxRuleCon1.value = "";
			                inboxRuleCon1.focus();
			                inputBtn.innerText = strLang239;
			                ConCellRow = null;
			            }
			            else {
			                Conitems.innerHTML += "<div style='font-family:dotum;font-size:small;height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + inboxRuleCon1.value + "'><nobr>" + inboxRuleCon1.value + "</nobr><div>";
			                inboxRuleCon1.value = "";
			                inboxRuleCon1.focus();
			            }
			        }
			        else {
			            alert(strLang222);
			            inboxRuleCon1.value = "";
			            inboxRuleCon1.focus();
			            inputBtn.innerText = strLang239;
			            ConCellRow = null;
			        }
			    }
			    else
			        alert(strLang223);
			}
			function pop_confrim() {
			    while (document.getElementById("ExtSenderNM").childNodes.length > 0) {
			        document.getElementById("ExtSenderNM").removeChild(document.getElementById("ExtSenderNM").childNodes.item(0));
			    }
			    for (var i = 0; i < Conitems.childNodes.length; i++) {
			        if (Conitems.childNodes.item(i).nodeName == "DIV") {
			            var _NewOption = document.createElement("OPTION");
			            _NewOption.value = Conitems.childNodes.item(i).innerText;
			            _NewOption.innerHTML = Conitems.childNodes.item(i).innerText;
			            document.getElementById("ExtSenderNM").appendChild(_NewOption);
			        }
			    }
			    inboxRuleConbtn1.style.display = "none";
			    inboxRuleCon1.value = "";
			    Conitems.innerHTML = "";
			}
			function pop_cancel() {
			    inboxRuleConbtn1.style.display = "none";
			    inboxRuleCon1.value = "";
			    Conitems.innerHTML = "";
			}
		</script>
	</head>
	<body style="margin-left:10px;margin-right:10px;">
		<br>
		<h2 class="h2_dot"><spring:message code='ezEmail.t311' /></h2>
		    <div align="center" style="width:618px;border:1px solid #d6d6d6;margin-left:18px;">
		        <div id="mailquatersize" style="width:400px; height:200px;display: inline-block;"></div>
		    </div>
		<br />
		<h2 class="h2_dot"><spring:message code='ezEmail.t177' /></h2>
		<span class="txt" style="margin-left:13px;">* <spring:message code='ezEmail.t178' /></span> <br>
		<span class="txt" style="margin-left:13px;">* <spring:message code='ezEmail.t99000033' /></span> <br>
		<table class="content" style="width:623px;margin-left:13px;">
		  <tr>
		    <th><spring:message code='ezEmail.t179' /></th>
		    <td>
		       <select id="listcount" style="WIDTH:100px">
		            <option value=10 <c:if test="${listCount == '10'}">selected</c:if>>10</option>
		            <option value=20 <c:if test="${listCount == '20'}">selected</c:if>>20</option>
		            <option value=30 <c:if test="${listCount == '30'}">selected</c:if>>30</option>
		            <option value=40 <c:if test="${listCount == '40'}">selected</c:if>>40</option>
		            <option value=50 <c:if test="${listCount == '50'}">selected</c:if>>50</option>
		        </select>
		      <spring:message code='ezEmail.t180' /></td>
		  </tr>
		  <tr>
		      <th><spring:message code='ezEmail.t487' /></th>
		      <td>
		          <select id="PreviewMode" style="WIDTH:100px" onchange="PrevieOption(this);">
		            <option value="OFF" <c:if test="${previewMode == 'OFF'}">selected</c:if>><spring:message code='ezEmail.t99000017' /></option>
		            <option value="H" <c:if test="${previewMode == 'H'}">selected</c:if>><spring:message code='ezEmail.t99000018' /></option>
		            <option value="W" <c:if test="${previewMode == 'W'}">selected</c:if>><spring:message code='ezEmail.t99000019' /></option>
		        </select>
		          <span id="PreviewHSizeDiv" <c:if test="${previewMode != 'H'}">style="display:none;"</c:if>>
		          <spring:message code='ezEmail.t99000020' /> 
		              <select  id="HListUser" style="width:50px;" onchange="HChange(this);">
		                  <c:forEach var="i" begin="39" end="64" step="1"> <!-- TODO: for문 잘 돌아가나 확인(String값을 int값으로 convert안해서 잘 안돌아갈 듯) -->
		                      <c:choose> 
		                      	<c:when test="${previewHListSize == i}">
		                      		<option value="<c:out value='${i}'/>" selected><c:out value='${i}'/></option>
		                      	</c:when>
		                      	<c:otherwise>
		                      		<option value="<c:out value='${i}'/>"><c:out value='${i}'/></option>
		                      	</c:otherwise>
		                      </c:choose>
		                  </c:forEach>
		              </select>
		          <spring:message code='ezEmail.t99000021' />
		              <select  id="HPreUser" style="width:50px;" onchange="HChange(this);">
		                  <c:forEach var="i" begin="36" end="61" step="1">
		                      <c:choose>
		                      	<c:when test="${previewHContentSize == i}">
		                      		<option value="<c:out value='${i}'/>" selected><c:out value='${i}'/></option>
		                      	</c:when>
		                      	<c:otherwise>
		                      		<option value="<c:out value='${i}'/>"><c:out value='${i}'/></option>
		                      	</c:otherwise>
		                      </c:choose>
		                  </c:forEach>
		              </select>
		          </span>
		          <span id="PreviewWSizeDiv" <c:if test="${previewMode != 'W'}">style="display:none;"</c:if>>
		          <spring:message code='ezEmail.t99000020' />
		              <select  id="WListUser" style="width:50px;" onchange="WChange(this);">
		                  <c:forEach var="i" begin="24" end="65" step="1">
		                      <c:choose>
		                      	<c:when test="${previewWListSize == i}">
		                      		<option value="<c:out value='${i}'/>" selected><c:out value='${i}'/></option>
		                      	</c:when>
		                      	<c:otherwise>
		                      		<option value="<c:out value='${i}'/>"><c:out value='${i}'/></option>
		                      	</c:otherwise>
		                      </c:choose>
		                  </c:forEach>
		              </select>
		          <spring:message code='ezEmail.t99000021' />
		              <select  id="WPreUser" style="width:50px;" onchange="WChange(this);">
		                  <c:forEach var="i" begin="35" end="76" step="1">
		                      <c:choose>
		                      	<c:when test="${previewWContentSize == i}">
		                      		<option value="<c:out value='${i}'/>" selected><c:out value='${i}'/></option>
		                      	</c:when>
		                      	<c:otherwise>
		                      		<option value="<c:out value='${i}'/>"><c:out value='${i}'/></option>
		                      	</c:otherwise>
		                      </c:choose>
		                  </c:forEach>
		              </select>
		          </span>
		      </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezEmail.t181' /></th>
		    <td><input type="text" id=refreshinterval class="textarea" style="WIDTH:100px" value="${refreshInterval}" name="text">
		      <spring:message code='ezEmail.t182' /></td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezEmail.t99000008' /></th>
		    <td>
		       <select id="AutoSaveTime" style="WIDTH:100px">
		            <option value=0 <c:if test="${keepDeleteLength == '0'}">selected</c:if>><spring:message code='ezEmail.t99000009' /></option>
		            <option value=60 <c:if test="${keepDeleteLength == '60'}">selected</c:if>>60</option>
		            <option value=90 <c:if test="${keepDeleteLength == '90'}">selected</c:if>>90</option>
		            <option value=120 <c:if test="${keepDeleteLength == '120'}">selected</c:if>>120</option>
		        </select>
		    <spring:message code='ezEmail.t182' /></td>
		  </tr>
		  <tr>
		      <th><spring:message code='ezEmail.t99000032' /></th>
		      <td>
		          <select style="width:300px;height:20px;" id="ExtSenderNM">${mailSendObject}</select>
		          <a class="imgbtn" onclick="MailOutNameModify();"><span><spring:message code='ezEmail.t149' /></span></a>
		      </td>
		  </tr>
		</table>  
		<br />
		<div align="center" style="width:623px;">
		    <a class="imgbtn" onClick="Change_Click('1')"><span><spring:message code='ezEmail.t48' /></span></a>
		    <a class="imgbtn" onClick="Cancel_Click()"><span><spring:message code='ezEmail.t39' /></span></a>
		</div> 
		<div  id="inboxRuleConbtn1" style="position:absolute; left:100px; top:65px;border:3px solid gray;width:415px;background-color:#F9F9F9; display:none;">
		<table style="width:100%;border:0;border-collapse:collapse; border-spacing:0;padding:0px;margin-top:10px;" >
		  <tr>
		    <td style="width:60%;padding:10px 0 0 10px" id="ReceiverSelecttd" name="ReceiverSelecttd">
		        <INPUT type="text" id="inboxRuleCon1" name="inboxRuleCon1" style="width:100%" onKeyDown="event_keyDown();"></td>
		    <td style="width:60%;padding:12px 10px 0 8px;">
		    <div ><a class="imgbtn"><span onClick="pop_addcon();" id="inputBtn"><spring:message code='ezEmail.t308' /></span></a>&nbsp;<a class="imgbtn"><span onClick="pop_delete();"><spring:message code='ezEmail.t95' /></span></a></div></td>
		  </tr>
		</table>
		<div style="border:1px solid #dddddd; margin:10px 10px 10px 10px; padding:10px 10px 10px 10px; background-color:#f2f2f2;">
		       <div id="Conitems" name="Conitems" style="border:1px solid #dbdbda;width:370px;height:200px;overflow-y:auto;overflow-x:hidden;text-overflow:ellipsis;background-color:#ffffff;">
		       </div>
		</div>
		<div id="mainmenu" style="margin-left:150px;">
		<ul id="tb_Parent">
		  <li><span onClick="pop_confrim();Change_Click('0');"><img src="/images/ImgIcon/mtg-accept.png" height="16" style="margin-top:-3px;text-align:center"  /><spring:message code='ezEmail.t38' /></span></li>
		  <li><span onClick="pop_cancel();"><img src="/images/ImgIcon/mtg-decline.png" height="16" style="margin-top:-3px;text-align:center;"  /><spring:message code='ezEmail.t39' /></span></li>
		  </ul>        
		</div>
		</div>
	</body>
</html>



