<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_general</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script src="${util.addVer('/js/jquery/raphael.2.1.0.min.js')}"></script>
        <script src="${util.addVer('/js/jquery/justgage.1.0.1.min.js')}"></script>
		<script type='text/javascript'>
		    var xmlhttp;
		    document.onselectstart = function () { return false; };
		    var MailQuater;
		    var previewSubTree = "${previewSubTree}";
		    var usePreviewSubTree = "${usePreviewSubTree}";
		    var dotnetFlag = "<c:out value='${dotnetFlag}'/>";
			var useEachMailDefault = "${useEachMailDefault}"
		    
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
                
                if (usePreviewSubTree == "YES") {
	                if (previewSubTree == "Y") {
	                	$('#previewSubTreeSlb').val("Y").attr("selected", "selected");
	                } else {
	                	$('#previewSubTreeSlb').val("N").attr("selected", "selected");
	                }
                }
		    }

		    function detailbox_after()
		    {
                if(xmlhttp == null || xmlhttp.readyState != 4) return;
                var result = xmlhttp.responseXML;
                		        
                if (CrossYN()) {
                    var resultvalue2 = "<spring:message code='ezEmail.t313' /> " + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].textContent + " <spring:message code='ezEmail.t314' /> ";
                    resultvalue2 += GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].textContent + "(" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent + "%) " + "<spring:message code='ezEmail.t315' /><spring:message code='ezEmail.t316' />";
                    MailQuater.refresh(parseInt(GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent));
                } else {
                    var resultvalue2 = "<spring:message code='ezEmail.t313' /> " + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].text + "<spring:message code='ezEmail.t314' /> ";
                    resultvalue2 += GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].text + "(" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text + "%) "  + "<spring:message code='ezEmail.t315' /><spring:message code='ezEmail.t316' />";
                    MailQuater.refresh(parseInt(GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text));
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
				
			    // 2024.09.09 한슬기 : 개별발신 기본 여부. 관리자 > 시스템 > 패라메터 > 개별발신 디폴트 사용이 '아니요'일 경우 사용자 설정에 선택된 값을 저장
			    var defaultSeparateSendVal = "";
			    if (useEachMailDefault === "NO"){
			    	defaultSeparateSendVal = document.getElementById("defaultSeparateSend").value;
			    }
			    
				var xmlHTTP = createXMLHttpRequest();
				var url = "/ezEmail/mailGeneralSave.do?MODE=ALL" ;
			    var previewSubTreeSlb = $("#previewSubTreeSlb option:selected").val();
			    var textOptionVal = $("#textOptionSlb option:selected").val();
				var sendStr = "<DATA><INMAILBOX>NO</INMAILBOX><LISTCOUNT>" + listcount.value + "</LISTCOUNT><REFRESHINTERVAL>" + refreshinterval.value + "</REFRESHINTERVAL>"+
				                "<KEEPDELETELENGTH>" + document.getElementById("AutoSaveTime").value + "</KEEPDELETELENGTH>"+
				                "<PREVIEWMODE>" + document.getElementById("PreviewMode").value + "</PREVIEWMODE>"+
				                "<PREVIEWWLIST>" + document.getElementById("WListUser").value + "</PREVIEWWLIST>" +
				                "<PREVIEWWCONTENT>" + document.getElementById("WPreUser").value + "</PREVIEWWCONTENT>" +
				                "<PREVIEWHLIST>" + document.getElementById("HListUser").value + "</PREVIEWHLIST>" +
				                "<PREVIEWHCONTENT>" + document.getElementById("HPreUser").value + "</PREVIEWHCONTENT>" +
				                "<MAILSENDERNM>" + MakeXMLString(ExtName) + "</MAILSENDERNM>" +
				                "<PREVIEWMAILIMAGE>" + document.getElementById("previewMailImage").value + "</PREVIEWMAILIMAGE>" +
				                "<PREVIEWMAIL>" + document.getElementById("previewMail").value + "</PREVIEWMAIL>" +
				                "<MAILSEARCHPERIOD>" + document.getElementById("searchPeriod").value + "</MAILSEARCHPERIOD>" +
				                "<TEXTOPTION>" + textOptionVal + "</TEXTOPTION>" + 
				                "<DEFAULTCURSORPOSITION>"+ document.getElementById("defaultCursorPosition").value + "</DEFAULTCURSORPOSITION>" +
								"<DEFAULTSEPARATESEND>"+ defaultSeparateSendVal + "</DEFAULTSEPARATESEND>" +
				                "<MAILSENDRESULT>" + document.getElementById("sendResult").value + "</MAILSENDRESULT>" + 
								"<EDITORFONTFAMILY>" + document.getElementById("editorFontFamily").value + "</EDITORFONTFAMILY>" +
								"<EDITORFONTSIZE>" + document.getElementById("editorFontSize").value + "</EDITORFONTSIZE>"+
								"<SELFCCOPTION>" + document.getElementById("selfCcOption").value + "</SELFCCOPTION>" +
								"<FORWARDAS>" + document.getElementById("forwardAs").value + "</FORWARDAS>";
				
                if (usePreviewSubTree == "YES") {
                	sendStr +=  "<PREVIEWSUBTREE>" + previewSubTreeSlb + "</PREVIEWSUBTREE>";
                }
				
				xmlHTTP.open("POST", url, false);
				xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
                xmlHTTP.send(sendStr + "</DATA>");
				
                if(dotnetFlag != "yes"){
                	var previewSubTreeStatus = window.parent.parent.frames["left"].previewSubTree;
                    if ((typeof previewSubTreeStatus != "undefined") && previewSubTreeStatus != previewSubTreeSlb) {
                    	var type = previewSubTreeSlb;
                    	window.parent.parent.frames["left"].previewSubTreeCall(type);
                    }
                }
                
                try {
                	var pSaveInterval = window.parent.parent.frames["left"].pSaveInterval;
                	var newInterval = parseInt(refreshinterval.value) * 1000;
                	
                    if (pSaveInterval != newInterval) {
                    	window.parent.parent.frames["left"].pSaveInterval = newInterval;
                    	window.parent.parent.frames["left"].setMailListRefreshTimer();
                    }
                } catch (e) {
                	console.error(e.message);
                }
                
				if (Gubun == "1") {
				    if (xmlHTTP.status == 200)
				        alert("<spring:message code='ezEmail.t42' />");
				    else
				        alert("<spring:message code='ezEmail.t176' />" + xmlHTTP.status);
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
			
			var senderNMData = "";
			var mailSenderNM = new Array();
			
			function MailOutNameModify() {
				Conitems.innerHTML = "";
				for (var i = 0; i < document.getElementById("ExtSenderNM").childNodes.length; i++) {
			        if (document.getElementById("ExtSenderNM").childNodes.item(i).nodeName == "OPTION") {
			            var pOptionValue = document.getElementById("ExtSenderNM").childNodes.item(i).value;
			            var pOptionText = document.getElementById("ExtSenderNM").childNodes.item(i).textContent;
			            // if(pOptionValue.startsWith("___")) pOptionText += " (default)";
			            Conitems.innerHTML += "<div style='font-family:" + "<spring:message code='main.t246' />" + ";font-size:small;height:18px;line-height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;padding:1px;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + pOptionValue + "'><nobr>" + pOptionText + "</nobr><div>";
			        }
			    }  
	            senderNMData = Conitems.innerHTML;
				mailSenderNM[1] = senderNMData;
				mailSenderNM[2] = event_mailSenderNM;
				var OpenWin = window.open("/ezEmail/mailExtSenderNM.do", "mail_NewInboxRule_cross", GetOpenWindowfeature(500, 392));
		        try { OpenWin.focus(); } catch (e) {console.log(e);}
		        
		        
			}
			
			function event_mailSenderNM(obj) {
				Conitems.innerHTML = obj;
				pop_confirm();
				Change_Click('0');
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
			    obj.style.backgroundColor = "#f1f8ff";
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
			                ConCellRow.outerHTML = "<div style='font-family:" + "<spring:message code='main.t246' />" + ";font-size:small;height:22px;line-height:22px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + inboxRuleCon1.value + "'><nobr>" + inboxRuleCon1.value + "</nobr><div>";
			                inboxRuleCon1.value = "";
			                inboxRuleCon1.focus();
			                inputBtn.innerText = strLang239;
			                ConCellRow = null;
			            }
			            else {
			                Conitems.innerHTML += "<div style='font-family:" + "<spring:message code='main.t246' />" + ";font-size:small;height:22px;line-height:22px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + inboxRuleCon1.value + "'><nobr>" + inboxRuleCon1.value + "</nobr><div>";
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
			function pop_confirm() {
			    while (document.getElementById("ExtSenderNM").childNodes.length > 0) {
			        document.getElementById("ExtSenderNM").removeChild(document.getElementById("ExtSenderNM").childNodes.item(0));
			    }
			    for (var i = 0; i < Conitems.childNodes.length; i++) {
			        if (Conitems.childNodes.item(i).nodeName == "DIV") {
			            var _NewOption = document.createElement("OPTION");
			            _NewOption.value = Conitems.childNodes.item(i).getAttribute("value");
			            if(_NewOption.value.startsWith("___")) _NewOption.selected = true;
			            _NewOption.innerHTML = Conitems.childNodes.item(i).innerText;
			            document.getElementById("ExtSenderNM").appendChild(_NewOption);
			        }
			    }
			}
		</script>
	</head>
	<body style="margin-left:10px;margin-right:10px;">
		<br>
		<h2><spring:message code='ezEmail.t311' /></h2>
		    <div align="center" style="width:677px;border:1px solid #d6d6d6;margin-top:5px">
		        <div id="mailquatersize" style="width:400px; height:200px;display: inline-block;"></div>
		    </div>
		<br />
		<h2><spring:message code='ezPersonal.yej01' /></h2>
		<span class="txt">▒ <spring:message code='ezEmail.t178' /></span> <br>
		<span class="txt">▒ <spring:message code='ezEmail.t99000033' /></span> <br><br>
		<table class="content" style="width:680px;">
		  <tr>
		    <th style="width:40%;"><spring:message code='ezEmail.t179' /></th>
		    <td style="width:60%;">
		       <select id="listcount" style="WIDTH:100px">
		            <option value=10 <c:if test="${listCount == '10'}">selected</c:if>>10</option>
		            <option value=20 <c:if test="${listCount == '20'}">selected</c:if>>20</option>
		            <option value=30 <c:if test="${listCount == '30'}">selected</c:if>>30</option>
		            <option value=40 <c:if test="${listCount == '40'}">selected</c:if>>40</option>
		            <option value=50 <c:if test="${listCount == '50'}">selected</c:if>>50</option>
		            <option value=60 <c:if test="${listCount == '60'}">selected</c:if>>60</option>
		            <option value=70 <c:if test="${listCount == '70'}">selected</c:if>>70</option>
		            <option value=80 <c:if test="${listCount == '80'}">selected</c:if>>80</option>
		            <option value=90 <c:if test="${listCount == '90'}">selected</c:if>>90</option>
		            <option value=100 <c:if test="${listCount == '100'}">selected</c:if>>100</option>
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
		                  <c:forEach var="i" begin="39" end="74" step="1"> <!-- TODO: for문 잘 돌아가나 확인(String값을 int값으로 convert안해서 잘 안돌아갈 듯) -->
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
		                  <c:forEach var="i" begin="26" end="61" step="1">
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
		  <tr <c:if test="${useOnlyInnerMail == 'YES'}">style="display:none"</c:if>>
		      <th><spring:message code='ezEmail.t99000032' /></th>
		      <td>
		          <select style="width:300px;" id="ExtSenderNM">${mailSendObject}</select>
		          <a class="imgbtn imgbck" onclick="MailOutNameModify();"><span><spring:message code='ezEmail.t149' /></span></a>
		      </td>
		  </tr>
		  <c:if test="${usePreviewSubTree eq 'YES' }">
			  <tr>
			  	<th><spring:message code="ezEmail.kyj18"/> </th>
			  	<td>
			  		<select id="previewSubTreeSlb" style="width:100px;">
			  			<option value="Y"><spring:message code="ezEmail.t808"/> </option>
			  			<option value="N"><spring:message code='ezEmail.t99000009' /></option>
			  		</select>
			  	</td>
			  </tr>
		  </c:if>
		  <tr>
		  	<th><spring:message code="ezEmail.ksa05"/> </th>
		  	<td>
		  		<select id="previewMailImage" style="width:100px;">
		  			<option value="Y" <c:if test="${previewMailImage == 'Y'}">selected</c:if>><spring:message code="ezEmail.t808"/> </option>
		  			<option value="N" <c:if test="${previewMailImage == 'N'}">selected</c:if>><spring:message code='ezEmail.t99000009' /></option>
		  		</select>
		  	</td>
		  </tr>
		  <tr>
            <th><spring:message code="ezEmail.preview.before.send"/></th>
            <td>
                <select id="previewMail" style="width:100px;">
                    <option value="N" <c:if test="${previewMail == 'N'}">selected</c:if>><spring:message code='ezEmail.t99000009' /></option>
                    <option value="P" <c:if test="${previewMail == 'P'}">selected</c:if>><spring:message code='ezEmail.general.priority' /> </option>
                    <option value="Y" <c:if test="${previewMail == 'Y'}">selected</c:if>><spring:message code='ezEmail.general.all' /></option>
                </select>
            </td>
          </tr>
		  <tr>
		      <th><spring:message code="ezEmail.lhm80"/></th>
		      <td>
		          <select id="textOptionSlb" style="width:100px;">
		              <option value="HTML">HTML</option>
		              <option value="PLAIN" <c:if test="${textOption eq 'PLAIN'}">selected</c:if>>Plain Text</option>
		          </select>
		      </td>
		  </tr>
		  <tr>
		      <th><spring:message code="ezEmail.ls004"/></th>
		      <td>
		          <select id="searchPeriod" style="width:100px;">
		            <option value=oneWeek <c:if test="${mailSearchPeriod == 'oneWeek'}">selected</c:if>><spring:message code="ezEmail.pyy17" /></option>
		            <option value=oneMonth <c:if test="${mailSearchPeriod == 'oneMonth'}">selected</c:if>><spring:message code="ezEmail.pyy18" /></option>
		            <option value=threeMonth <c:if test="${mailSearchPeriod == 'threeMonth'}">selected</c:if>><spring:message code="ezEmail.pyy19" /></option>
		            <option value=sixMonth <c:if test="${mailSearchPeriod == 'sixMonth'}">selected</c:if>><spring:message code="ezEmail.ls001" /></option>
		            <option value=oneYear <c:if test="${mailSearchPeriod == 'oneYear'}">selected</c:if>><spring:message code="ezEmail.ls002" /></option>
		          </select>
		      </td>
		  </tr>
		  <!-- 2024.08.06 한슬기 : 메일쓰기화면 커서 위치 설정-->
		  <tr>
		      <th><spring:message code="ezEmail.general.defaultCursorPosition"/></th>
		      <td>
		          <select id="defaultCursorPosition" style="width:100px;">
		            <option value=recipient <c:if test="${defaultCursorPosition == 'recipient'}">selected</c:if>><spring:message code='ezEmail.t66' /></option>
		            <option value=content <c:if test="${defaultCursorPosition == 'content'}">selected</c:if>><spring:message code='ezPersonal.t155' /></option>
		            <option value=subject <c:if test="${defaultCursorPosition == 'subject'}">selected</c:if>><spring:message code='ezEmail.t98' /></option>
		          </select>
		      </td>
		  </tr>
		  
		  <!-- 2024.08.06 한슬기 : 개별발신 기본 여부. 관리자 > 시스템 > 패라메터 > 개별발신 디폴트 사용이 '아니요'일 경우만 보임-->
		  <c:if test="${useEachMailDefault eq 'NO'}">
			  <tr>
			      <th><spring:message code="ezEmail.general.defaultSeparateSend"/></th>
			      <td>
			          <select id="defaultSeparateSend" style="width:100px;">
			            <option value="N" <c:if test="${defaultSeparateSend eq 'N' || defaultSeparateSend == null}">selected</c:if>><spring:message code='ezEmail.t99000009' /></option>
			            <option value="Y" <c:if test="${defaultSeparateSend eq 'Y'}">selected</c:if>><spring:message code="ezEmail.t808"/></option>
			          </select>
			      </td>
			  </tr>
		  </c:if>

          <!-- 2025.02.11 한슬기 : 국립암센터 나를 항상 참조에 포함 설정 추가(사용안함, 참조, 숨은참조. default : 사용안함) -->
          <tr>
			  <th><spring:message code="ezEmail.general.selfCcOption"/></th>
			  <td>
				  <select id="selfCcOption" style="width:100px;">
					  <option value="none" <c:if test="${selfCcOption ne 'cc' and selfCcOption ne 'bcc'}">selected</c:if>><spring:message code='ezEmail.t99000009' /></option>
					  <option value="cc" <c:if test="${selfCcOption eq 'cc'}">selected</c:if>><spring:message code="ezEmail.t706"/></option>
					  <option value="bcc" <c:if test="${selfCcOption eq 'bcc'}">selected</c:if>><spring:message code="ezEmail.t562"/></option>
				  </select>
			  </td>
          </tr>



			<tr>
              <th><spring:message code="ezEmail.send.result"/></th>
              <td>
                  <select id="sendResult" style="width:100px;">
                    <option value=failure <c:if test="${mailSendResult == 'failure'}">selected</c:if>><spring:message code="ezEmail.general.fail" /></option>
                    <option value=always <c:if test="${mailSendResult == 'always'}">selected</c:if>><spring:message code="ezEmail.general.always" /></option>
                  </select>
              </td>
          </tr>
		  <c:if test="${primaryLang == '1'}">
			  <tr>
				  <th><spring:message code="ezEmail.general.editorFontStyle"/></th>
				  <td>
					  <select id="editorFontFamily" style="width:150px;">
						  <c:forEach var="font" items="${defaultFontFamilyList}">
							  <option value="${font.trim()}" <c:if test="${editorFontFamily == font}">selected</c:if>>${font.trim()}</option>
						  </c:forEach>
					  </select>
					  <select id="editorFontSize" style="width:100px;">
						  <c:forEach var="size" items="${defaultFontSizeList}">
							  <option value="${size}" <c:if test="${editorFontSize == size}">selected</c:if>>${size}</option>
						  </c:forEach>
					  </select>
				  </td>
			  </tr>
		  </c:if>

		  <!-- 2025.02.13 김은실 : [국립암센터] 메일 전달 방식. inline: 본문으로 전달(default), attach: 첨부로 전달 -->
          <tr>
              <th><spring:message code="ezEmail.general.forward"/></th>
              <td>
                  <select id="forwardAs" style="width:100px;">
                    <option value=inline <c:if test="${forwardAs == 'inline'}">selected</c:if>><spring:message code="ezEmail.general.forward.asInline" /></option>
                    <option value=attach <c:if test="${forwardAs == 'attach'}">selected</c:if>><spring:message code="ezEmail.general.forward.asAttach" /></option>
                  </select>
                  <br /><!-- description style: 공통적인 class가 없는 것으로 보여서 inline으로 줌. ※ #999999 = rgb(153, 153, 153) -->
                  <text style="color: #999999;"><spring:message code="ezEmail.general.forward.description" /></text>
              </td>
          </tr>
		</table>
		<div align="center" style="width:680px;">
			<div class="btnpositionJsp">
		    	<a class="imgbtn" onClick="Change_Click('1')"><span><spring:message code='main.sp09' /></span></a>
		    	<a class="imgbtn" onClick="Cancel_Click()"><span><spring:message code='ezEmail.t39' /></span></a>
		    </div>
		</div> 
		
		<div  id="inboxRuleConbtn1" style="position:absolute; left:100px; top:65px;border:1px solid gray;width:415px;background-color:white; display:none;">
			        <INPUT type="text" id="inboxRuleCon1" name="inboxRuleCon1" style="width:100%" onKeyDown="event_keyDown();"></td>
			<div style="border:1px solid #dddddd; margin:10px 10px 10px 10px; padding:10px 10px 10px 10px; background-color:#f1f3f5;">
			       <div id="Conitems" name="Conitems" style="border:1px solid #dbdbda;width:370px;height:200px;overflow-y:auto;overflow-x:hidden;text-overflow:ellipsis;background-color:#ffffff;">
			       </div>
			</div>
		</div>
	</body>
</html>



