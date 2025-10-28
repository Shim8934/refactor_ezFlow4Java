<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_pop3</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript">
			var rsa = new RSAKey();
		    document.onselectstart = function () { return false; };
		    function window_onload() {
		    	rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        var popText = "${infoXML}";
		        var popXML = createXmlDom();
		        var bResult = loadXMLString(popText);
		        if (bResult) {
		            var nCount = bResult.getElementsByTagName("POP3SERVER").length;
		            var i;
		            var popID, popPW, popSave, popSaveTo, popServer;
		            for (i = 0; i < nCount; i++) {
		                if (!CrossYN()) {
		                    popServer = bResult.getElementsByTagName("POP3SERVER")[i].text;
		                    popPort = bResult.getElementsByTagName("POP3PORTNO")[i].text;
		                    popID = bResult.getElementsByTagName("POP3USERID")[i].text;
		                    popPW = bResult.getElementsByTagName("POP3PW")[i].text;
		                    popDelete = bResult.getElementsByTagName("DELETEYN")[i].text;
		                    popSaveTo = bResult.getElementsByTagName("SAVETO")[i].text;
		                    popSaveToFolder = bResult.getElementsByTagName("SAVETOFOLDER")[i].text;
		                    var svElem = document.body.all("popServer" + (i + 1));
		                    svElem.value = popServer;
		                    svElem = document.body.all("popID" + (i + 1));
		                    svElem.value = popID;
		                    svElem = document.body.all("popPW" + (i + 1));
		                    svElem.value = popPW;
		                    svElem = document.body.all("popPort" + (i + 1));
		                    svElem.value = popPort;
		                    svElem = document.body.all("popBox" + (i + 1));
		
		                }
		                else if (CrossYN()) {
		                    popServer = bResult.getElementsByTagName("POP3SERVER")[i].textContent;
		                    popPort = bResult.getElementsByTagName("POP3PORTNO")[i].textContent;
		                    popID = bResult.getElementsByTagName("POP3USERID")[i].textContent;
		                    popPW = bResult.getElementsByTagName("POP3PW")[i].textContent;
		                    popDelete = bResult.getElementsByTagName("DELETEYN")[i].textContent;
		                    popSaveTo = bResult.getElementsByTagName("SAVETO")[i].textContent;
		                    popSaveToFolder = bResult.getElementsByTagName("SAVETOFOLDER")[i].textContent;
		                    var svElem = document.getElementsByName("popServer" + (i + 1)).item(0);
		                    svElem.value = popServer;
		                    svElem = document.getElementById("popID" + (i + 1));
		                    svElem.value = popID;
		                    svElem = document.getElementById("popPW" + (i + 1));
		                    svElem.value = popPW;
		                    svElem = document.getElementById("popPort" + (i + 1));
		                    svElem.value = popPort;
		                    svElem = document.getElementById("popBox" + (i + 1));
		                }
		                if (navigator.userAgent.indexOf("Firefox") == 60) {
		                    svElem.innerHTML = popSaveToFolder;
		                    svElem.setAttribute("url", popSaveTo);
		                }
		                else {
		                    svElem.innerHTML = folderdisnameChange(decodeUTF8Encode(popSaveToFolder));
		                    svElem.setAttribute("url", popSaveTo);
		                }
		                if (!CrossYN()) {
		                    svElem = document.body.all("popDelete" + (i + 1));
		
		                }
		                else if (CrossYN()) {
		                    svElem = document.getElementById("popDelete" + (i + 1));
		                }
		
		                if (popDelete == "Y")
		                    svElem.checked = true;
		                else
		                    svElem.checked = false;
		
		                if (!CrossYN()) {
		                    var popSSL = bResult.getElementsByTagName("POP3SSLYN")[i].text;
		                    svElem = document.body.all("popSSL" + (i + 1));
		                }
		                else if (CrossYN()) {
		                    var popSSL = bResult.getElementsByTagName("POP3SSLYN")[i].textContent;
		                    svElem = document.getElementById("popSSL" + (i + 1));
		                }
		                if (popSSL.toLowerCase() == "true")
		                    svElem.checked = true;
		                else
		                    svElem.checked = false;
		            }
		        }
		        else
		        	alert("POP3 <spring:message code='ezEmail.t223' />");
		        
		    }
		    var mail_selectfolder_cross_dialogArguments = new Array();
		    function search_mailbox(idx) {
		        mail_selectfolder_cross_dialogArguments[1] = search_mailbox_complete;
		        mail_selectfolder_cross_dialogArguments[2] = idx;
		
		        var OpenWin = GetOpenWindow("/ezEmail/mailSelectFolder.do", "mail_selectfolder_cross", 470, 355);
		        try { OpenWin.focus(); } catch (e) {console.log(e);}
		    }
		    function search_mailbox_complete(mailBoxInfo) {
		        if (typeof (mailBoxInfo) == "undefined")
		            return;
				
		        if (mailBoxInfo["isFolderChanged"]) {
	        		try {
	        			parent.parent.frames["left"].mailbox_treeview_reload();
	        		} catch (e) {
	        		    console.log(e);
	        		}
	        	}
	        	
		        if (typeof (mailBoxInfo["url"]) == "undefined" || typeof (mailBoxInfo["url"]) == "undefined") {
		        	return;
		        }
		        
		        if (!CrossYN()) {
		            svElem = document.body.all("popBox" + mail_selectfolder_cross_dialogArguments[2]);
		
		        }
		        else if (CrossYN()) {
		            svElem = document.getElementById("popBox" + mail_selectfolder_cross_dialogArguments[2]);
		        }
		        svElem.innerHTML = mailBoxInfo.name;
		        svElem.setAttribute("url", mailBoxInfo.url);
		    }
		    function SavePop3() {
		        var popID, popPW, popSave, popSaveTo, popSaveToFolder, popServer, popXML;
		        popXML = "<DATA>"
		        for (var i = 1; i < 4; i++) {
		            var svElem = "";
		            if (!CrossYN()) {
		                svElem = document.body.all("popServer" + i);
		
		            }
		            else if (CrossYN()) {
		                svElem = document.getElementById("popServer" + i);
		            }
		            popServer = svElem.value;
		            if (popServer == "")
		                continue;
		
		            if (!CrossYN()) {
		                svElem = document.body.all("popID" + i);
		
		            }
		            else if (CrossYN()) {
		                svElem = document.getElementById("popID" + i);
		            }
		            popID = svElem.value;
		            if (popID == "") {
		            	alert(i + "<spring:message code='ezEmail.t224' />");
		                return;
		            }
		            if (!CrossYN()) {
		                svElem = document.body.all("popPW" + i);
		
		            }
		            else if (CrossYN()) {
		                svElem = document.getElementById("popPW" + i);
		            }
		            popPW = svElem.value;
		
		            if (popPW == "") {
		            	alert(i + "<spring:message code='ezEmail.t225' />");
		                return;
		            }
		            if (!CrossYN()) {
		                svElem = document.body.all("popPort" + i);
		            }
		            else if (CrossYN()) {
		                svElem = document.getElementById("popPort" + i);
		            }
		            popPort = svElem.value;
		            if (popPort == "") {
		            	alert(i + "<spring:message code='ezEmail.t226' />");
		                return;
		            }
		            if (!CrossYN()) {
		                svElem = document.body.all("popBox" + i);
		            }
		            else if (CrossYN()) {
		                svElem = document.getElementById("popBox" + i);
		            }
		            if (svElem.getAttribute("url") == "") {
		            	alert(i + "<spring:message code='ezEmail.t227' />");
		                return;
		            }
		            popSaveTo = svElem.getAttribute("url");
		            if (navigator.userAgent.indexOf("Firefox") == 60) {
		                popSaveToFolder = svElem.innerHTML;
		            }
		            else {
		                popSaveToFolder = svElem.innerText;
		            }
		            if (!CrossYN()) {
		                svElem = document.body.all("popDelete" + i);
		
		            }
		            else if (CrossYN()) {
		                svElem = document.getElementById("popDelete" + i);
		            }
		            if (svElem.checked == true)
		                popDelete = "Y";
		            else
		                popDelete = "N";
		
		            if (!CrossYN()) {
		                svElem = document.body.all("popSSL" + i);
		            }
		            else if (CrossYN()) {
		                svElem = document.getElementById("popSSL" + i);
		            }
		            var popSSL = svElem.checked;
		            popXML = popXML + "<ROW><SERVER>" + popServer + "</SERVER><PORT>" + popPort + "</PORT><ID>" + rsa.encrypt(popID) + "</ID><DELETE>" + popDelete + "</DELETE><PW>" + rsa.encrypt(popPW) + "</PW><SAVETO>" + popSaveTo + "</SAVETO><SAVETOFOLDER>" + popSaveToFolder + "</SAVETOFOLDER><SSL>" + popSSL + "</SSL></ROW>";
		        }
		        popXML = popXML + "</DATA>";
		        try {
		            var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/ezEmail/mailPop3Save.do", false);
		            xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
		            xmlHTTP.send(popXML);
		
		            if (xmlHTTP.status == 200)
		            	alert("<spring:message code='ezEmail.t42' />");
		            else
		            	alert("<spring:message code='ezEmail.t228' />" + xmlHTTP.status);
		
		            xmlHTTP = null;
		        }
		        catch (e) {
		        	alert("<spring:message code='ezEmail.t228' />" + e.description);
		        }
		    }
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
		    function popChange(idx) {
		        var svElem = "";
		        var textValue = "";
		        if (!CrossYN()) {
		            svElem = document.body.all("popSelect" + idx);
		            textValue = document.body.all("popServer" + idx);
		        }
		        else if (CrossYN()) {
		            svElem = document.getElementById("popSelect" + idx);
		            textValue = document.getElementById("popServer" + idx);
		        }
		        if (svElem.options[svElem.selectedIndex].value == "-1") {
		            alert(svElem.options[svElem.selectedIndex].text + "<spring:message code='ezEmail.t229' />");
		            return;
		        }
		        
		        textValue.value = svElem.options[svElem.selectedIndex].value;
		        
		        if (svElem.selectedIndex == (svElem.options.length - 1)) {
		        	textValue.disabled = false;
		        	textValue.focus();
		        } else {
		        	textValue.disabled = true;
		        }
		        
		        if (svElem.options[svElem.selectedIndex].value == 'pop.naver.com' 
		        		|| svElem.options[svElem.selectedIndex].value == 'pop.daum.net' 
		        		|| svElem.options[svElem.selectedIndex].value == 'pop3.nate.com' 
		        		|| svElem.options[svElem.selectedIndex].value == 'pop.gmail.com' 
		        		|| svElem.options[svElem.selectedIndex].value == 'pop3.live.com' 
		        		|| svElem.options[svElem.selectedIndex].value == 'pop.mail.yahoo.com'
		        		|| svElem.options[svElem.selectedIndex].value == 'pop.mail.yahoo.co.jp') {
		            if (!CrossYN()) {
		                document.body.all("popPort" + idx).value = "995";
		                document.body.all("popSSL" + idx).checked = true;
		            }
		            else if (CrossYN()) {
		                document.getElementById("popPort" + idx).value = "995";
		                document.getElementById("popSSL" + idx).checked = true;
		            }
		        }
		        else {
		            if (!CrossYN()) {
		                document.body.all("popPort" + idx).value = "110";
		                document.body.all("popSSL" + idx).checked = false;
		            }
		            else if (CrossYN()) {
		                document.getElementById("popPort" + idx).value = "110";
		                document.getElementById("popSSL" + idx).checked = false;
		            }
		        }
				
		        if (svElem.options[svElem.selectedIndex].ispay == "true") {
		
		            if (!CrossYN()) {
		                document.body.all("popSpan" + idx).innerText = " " + strLang181;
		            }
		            else if (CrossYN()) {
		                document.getElementById("popSpan" + idx).innerHTML = " " + strLang181;
		            }
		
		        }
		        else {
		            if (!CrossYN()) {
		                document.body.all("popSpan" + idx).innerText = "";
		            }
		            else if (CrossYN()) {
		                document.getElementById("popSpan" + idx).innerHTML = "";
		            }
		
		        }
		
		    }
		    function connect_test(idx) {
		        var svElem = "";
		        if (!CrossYN()) {
		            svElem = document.body.all("popServer" + idx);
		            var popServer = svElem.value;
		        }
		        else if (CrossYN()) {
		            var svElem = document.getElementById("popServer" + idx);
		            var popServer = svElem.value;
		        }
		
		        if (popServer == "") {
		        	alert("<spring:message code='ezEmail.t230' />");
		            return;
		        }
		        if (!CrossYN()) {
		            svElem = document.body.all("popPort" + idx);
		            var popPort = svElem.value;
		        }
		        else if (CrossYN()) {
		            svElem = document.getElementById("popPort" + idx);
		            var popPort = svElem.value;
		        }
		        if (popPort == "") {
		        	alert("<spring:message code='ezEmail.t231' />");
		            return;
		        }
		        if (!CrossYN()) {
		            svElem = document.body.all("popID" + idx);
		            var popID = svElem.value;
		        }
		        else if (CrossYN()) {
		            svElem = document.getElementById("popID" + idx);
		            var popID = svElem.value;
		        }
		        if (popID == "") {
		        	alert("<spring:message code='ezEmail.t232' />");
		            return;
		        }
		        if (!CrossYN()) {
		            svElem = document.body.all("popPW" + idx);
		            var popPW = svElem.value;
		        }
		        else if (CrossYN()) {
		            svElem = document.getElementById("popPW" + idx);
		            var popPW = svElem.value;
		        }
		        if (popPW == "") {
		        	alert("<spring:message code='ezEmail.t233' />");
		            return;
		        }
		        if (!CrossYN()) {
		            svElem = document.body.all("popSSL" + idx);
		            var popSSL = svElem.checked;
		            var popXML = "<DATA><SERVER>" + popServer + "</SERVER><PORT>" + popPort + "</PORT><ID>" + rsa.encrypt(popID) + "</ID>" + "<PW>" + rsa.encrypt(popPW) + "</PW><SSL>" + popSSL + "</SSL></DATA>";
		
		        }
		        else if (CrossYN()) {
		            svElem = document.getElementById("popSSL" + idx);
		            var popSSL = svElem.checked;
		            var popXML = "<DATA><SERVER>" + popServer + "</SERVER><PORT>" + popPort + "</PORT><ID>" + rsa.encrypt(popID) + "</ID>" + "<PW>" + rsa.encrypt(popPW) + "</PW><SSL>" + popSSL + "</SSL></DATA>";
		
		        }
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("POST", "/ezEmail/mailPop3Connect.do", true);
		        xmlHTTP.onreadystatechange = function() {
		        	if ( xmlHTTP.readyState == 4 ) {
				        if ( xmlHTTP.status == 200 ) {
				            if (!CrossYN()) {
				                if (xmlHTTP.responseXML.text == "OK")
				                	alert("<spring:message code='ezEmail.t234' />");
				                else
				                	alert("<spring:message code='ezEmail.t235' />\n\n<spring:message code='ezEmail.t236' />");
				
				            }
				            else if (CrossYN()) {
				                var result = xmlHTTP.responseText;
				
				                result = replaceAll(result, "<DATA>", "");
				                result = replaceAll(result, "</DATA>", "");
				
				                if (result == "OK")
				                	alert("<spring:message code='ezEmail.t234' />");
				                else
				                	alert("<spring:message code='ezEmail.t235' />\n\n<spring:message code='ezEmail.t236' />");
				            }
				        }
				        else
				        	alert("<spring:message code='ezEmail.t237' />" + xmlHTTP.status);
		        	}
		        }
		        xmlHTTP.send(popXML);
		    }
					
		    function reset_setting(idx) {
		        var elem = document.getElementById("popServer" + idx);
		        elem.value = "";

		        var elem = document.getElementById("popSelect" + idx);
		        elem.selectedIndex = 0;
		        
		        elem = document.getElementById("popPort" + idx);
		        elem.value = "";
		        
		        elem = document.getElementById("popSSL" + idx);
		        elem.checked = false;		        	
		        
		        elem = document.getElementById("popID" + idx);
		        elem.value = "";		        

		        elem = document.getElementById("popPW" + idx);
		        elem.value = "";		  
		        
		        elem = document.getElementById("popBox" + idx);
		        elem.setAttribute("url", "");
		        elem.innerText = "<spring:message code='ezEmail.t158' />";
		        
		        elem = document.getElementById("popDelete" + idx);
		        elem.checked = false;		        			        
		    }
		    
		    function replaceAll(pStrContent, pStrOrg, pStrRep) {
		        return pStrContent.split(pStrOrg).join(pStrRep);
		    }
		</script>
	</head>
	<c:choose>
		<c:when test="${userLang == '3'}">
		<c:set var="tableWidth" value="750" />
		</c:when>
		<c:when test="${userLang == '2'}">
		<c:set var="tableWidth" value="770" />
		</c:when>
		<c:otherwise>
		<c:set var="tableWidth" value="720" />
		</c:otherwise>
		</c:choose>
	<body onload="javascript:window_onload()" style="margin-left:10px;margin-right:10px;" class="mailPop3">
		<br>
		<div class="txt" style="margin-bottom:25px">
			<div>▒ <spring:message code='ezEmail.t239' /></div> 
		    <div style="margin-top:3px">▒ <spring:message code='ezEmail.t240' /></div> 
		    <div style="margin-top:3px">▒ <spring:message code='ezEmail.t241' /></div>
		    <div style="margin-top:3px">▒ ${pop3MaxFetchSizeMessage}</div>
		</div>
		<h2 class="h2_dot"><spring:message code='ezEmail.t242' /></h2>	
		<table class="content" style="width:${tableWidth}px;"> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t243' /></th> 
		    <td colspan="3"> <input type="text" name="popServer1" id="popServer1" class="textarea" style="width:200px" disabled /> 
		      <select name="popSelect1" id="popSelect1" class="select" onChange="popChange(1)" style="vertical-align:middle;width:200px;"> 
			    <OPTION VALUE=""><spring:message code='ezEmail.t731' /></option>
			    <c:choose>
			    	<c:when test="${primaryLang == '1'}">
			    		<OPTION VALUE="pop.naver.com"><spring:message code='ezEmail.t732' /></option>
					    <OPTION VALUE="pop.daum.net"><spring:message code='ezEmail.t740' /></option>
					    <OPTION VALUE="pop3.nate.com"><spring:message code='ezEmail.t733' /></option>
					    <OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop3.live.com"><spring:message code='ezEmail.t735' /></option>
					    <OPTION VALUE="pop.mail.yahoo.com"><spring:message code='ezEmail.t736' /></option>
			    	</c:when>
			    	<c:when test="${primaryLang == '2'}">
			    		<OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop.mail.yahoo.co.jp"><spring:message code='ezEmail.t737' /></option>
			    	</c:when>
			    	<c:otherwise>
			    		<OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop.mail.yahoo.com"><spring:message code='ezEmail.t736' /></option>
			    	</c:otherwise>
			    </c:choose>
			    <OPTION VALUE=""><spring:message code='ezEmail.t244' /></option>
			  </select>
              <div style="display: inline-block;">
                  <span style="vertical-align: middle; margin-left: 6px">Port : </span>
                  <input type="text" name="popPort1" id="popPort1" class="textarea" style="width:30px" value="110"> 
                  <span style="vertical-align: middle;margin-left: 6px">SSL : </span>
                  <div class="custom_checkbox"><input type="checkbox" name="popSSL1" id="popSSL1"></div>
              </div>
              <a  class="imgbtn imgbck" style="float: right;"><span onClick="reset_setting(1)"><spring:message code='ezEmail.ldh04' /></span></a>	
		    </td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t263' /></th> 
		    <td style="width:100%;"> <input type="text" name="popID1" id="popID1" class="textarea" style="width:200px"><span id="popSpan1"></span></td> 
		    <th style="white-space:nowrap" ><spring:message code='ezEmail.t264' /></th> 
		    <td style="white-space:nowrap;width:250px;"> <input type="password" name="popPW1" id="popPW1" class="textarea" style="width:100px;margin:0px 1px 0px 0px;">
		        <a  class="imgbtn imgbck"><span onClick="connect_test(1)"><spring:message code='ezEmail.t265' /></span></a></td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t266' /></th> 
		    <td colspan="3"><a  class="imgbtn imgbck" style="margin-right:3px !important; /*margin-top: 3px !important; */height: 22px !important;"><span onClick="search_mailbox(1)"><spring:message code='ezEmail.t37' /></span></a> <span style="vertical-align: middle;"><spring:message code='ezEmail.t267' /></span><span id='popBox1' style="vertical-align: middle;" url=""><spring:message code='ezEmail.t158' />&nbsp;</span> 
		        <div class="custom_checkbox">
		            <input type="checkbox" name="popDelete1" id="popDelete1" value="checkbox" style="margin-top: 1px;"><label for="popDelete1" style="vertical-align: middle;"><spring:message code='ezEmail.t268' /></label>
		        </div>
		    </td>
		  </tr> 
		</table> 
		<br>
		<h2 class="h2_dot"><spring:message code='ezEmail.t700' /></h2> 
		<table class="content" style="width:${tableWidth}px;">
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t243' /></th> 
		    <td colspan="3"> <input type="text" name="popServer2" id="popServer2" class="textarea" style="width:200px" disabled /> 
		      <select name="popSelect2" id="popSelect2" onChange="popChange(2)" style="vertical-align:middle;width:200px;"> 
		        <OPTION VALUE=""><spring:message code='ezEmail.t731' /></option>
			    <c:choose>
			    	<c:when test="${primaryLang == '1'}">
			    		<OPTION VALUE="pop.naver.com"><spring:message code='ezEmail.t732' /></option>
					    <OPTION VALUE="pop.daum.net"><spring:message code='ezEmail.t740' /></option>
					    <OPTION VALUE="pop3.nate.com"><spring:message code='ezEmail.t733' /></option>
					    <OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop3.live.com"><spring:message code='ezEmail.t735' /></option>
					    <OPTION VALUE="pop.mail.yahoo.com"><spring:message code='ezEmail.t736' /></option>
			    	</c:when>
			    	<c:when test="${primaryLang == '2'}">
			    		<OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop.mail.yahoo.co.jp"><spring:message code='ezEmail.t737' /></option>
			    	</c:when>
			    	<c:otherwise>
			    		<OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop.mail.yahoo.com"><spring:message code='ezEmail.t736' /></option>
			    	</c:otherwise>
			    </c:choose>
			    <OPTION VALUE=""><spring:message code='ezEmail.t244' /></option>
		      </select> 
		      <div style="display: inline-block;">
                  <span style="vertical-align: middle; margin-left: 6px">Port : </span>
                  <input type="text" name="popPort2" id="popPort2" class="textarea" style="width:30px" value="110"> 
                  <span style="vertical-align: middle;margin-left: 6px">SSL : </span>
                  <div class="custom_checkbox"><input type="checkbox" name="popSSL2" id="popSSL2"></div>
              </div>
		      <a  class="imgbtn imgbck" style="float: right;"><span onClick="reset_setting(2)"><spring:message code='ezEmail.ldh04' /></span></a>
		    </td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t263' /></th> 
		    <td style="width:100%;"> <input type="text" name="popID2" id="popID2" class="textarea" style="width:200px"> <span id="popSpan2"></span></td> 
		    <th style="white-space:nowrap" ><spring:message code='ezEmail.t264' /></th> 
		    <td style="white-space:nowrap;width:250px;"> <input type="password" name="popPW2" id="popPW2" class="textarea" style="width:100px;margin:0px 0px 0px 0px;"> 
		      <a  class="imgbtn imgbck"><span onClick="connect_test(2)"><spring:message code='ezEmail.t265' /></span></a> </td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t266' /></th> 
            <td colspan="3"><a  class="imgbtn imgbck" style="margin-right:3px !important; /*margin-top: 3px !important; */height: 22px !important;"><span onClick="search_mailbox(2)"><spring:message code='ezEmail.t37' /></span></a> <span style="vertical-align: middle;"><spring:message code='ezEmail.t267' /></span><span id='popBox2' style="vertical-align: middle;" url=""><spring:message code='ezEmail.t158' />&nbsp;</span>  
                <div class="custom_checkbox">
                    <input type="checkbox" name="popDelete2" id="popDelete2" value="checkbox" style="margin-top: 1px;"><label for="popDelete2" style="vertical-align: middle;"><spring:message code='ezEmail.t268' /></label>
                </div>
            </td>
		  </tr> 
		</table> 
		<br> 
		<h2 class="h2_dot"><spring:message code='ezEmail.t701' /></h2> 
		<table class="content" style="width:${tableWidth}px;"> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t243' /></th> 
		    <td colspan="3"> <input type="text" name="popServer3" id="popServer3" class="textarea" style="width:200px" disabled /> 
		      <select name="popSelect3" id="popSelect3" class="select" onChange="popChange(3)" style="vertical-align:middle;width:200px;"> 
		        <OPTION VALUE=""><spring:message code='ezEmail.t731' /></option>
			    <c:choose>
			    	<c:when test="${primaryLang == '1'}">
			    		<OPTION VALUE="pop.naver.com"><spring:message code='ezEmail.t732' /></option>
					    <OPTION VALUE="pop.daum.net"><spring:message code='ezEmail.t740' /></option>
					    <OPTION VALUE="pop3.nate.com"><spring:message code='ezEmail.t733' /></option>
					    <OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop3.live.com"><spring:message code='ezEmail.t735' /></option>
					    <OPTION VALUE="pop.mail.yahoo.com"><spring:message code='ezEmail.t736' /></option>
			    	</c:when>
			    	<c:when test="${primaryLang == '2'}">
			    		<OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop.mail.yahoo.co.jp"><spring:message code='ezEmail.t737' /></option>
			    	</c:when>
			    	<c:otherwise>
			    		<OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
					    <OPTION VALUE="pop.mail.yahoo.com"><spring:message code='ezEmail.t736' /></option>
			    	</c:otherwise>
			    </c:choose>
			    <OPTION VALUE=""><spring:message code='ezEmail.t244' /></option>
		      </select> 
              <div style="display: inline-block;">
                    <span style="vertical-align: middle; margin-left: 6px">Port : </span>
                    <input type="text" name="popPort3" id="popPort3" class="textarea" style="width:30px" value="110"> 
                    <span style="vertical-align: middle;margin-left: 6px">SSL : </span>
                    <div class="custom_checkbox"><input type="checkbox" name="popSSL3" id="popSSL3"></div>
                </div>
		      <a  class="imgbtn imgbck" style="float: right"><span onClick="reset_setting(3)"><spring:message code='ezEmail.ldh04' /></span></a>
		    </td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t263' /></th>
		    <td style="width:100%;"> <input type="text" name="popID3" id="popID3" class="textarea" style="width:200px"> <span id="popSpan3"></span></td> 
		    <th style="white-space:nowrap" ><spring:message code='ezEmail.t264' /></th> 
		    <td style="white-space:nowrap;width:250px;"> <input type="password" name="popPW3" id="popPW3" class="textarea" style="width:100px;margin:0px 0px 0px 0px;"> 
		      <a  class="imgbtn imgbck"><span onClick="connect_test(3)"><spring:message code='ezEmail.t265' /></span></a></td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t266' /></th> 
            <td colspan="3"><a  class="imgbtn imgbck" style="margin-right:3px !important; /*margin-top: 3px !important; */height: 22px !important;"><span onClick="search_mailbox(3)"><spring:message code='ezEmail.t37' /></span></a> <span style="vertical-align: middle;"><spring:message code='ezEmail.t267' /></span><span id='popBox3' style="vertical-align: middle;" url=""><spring:message code='ezEmail.t158' />&nbsp;</span>
		        <div class="custom_checkbox">
                    <input type="checkbox" name="popDelete3" id="popDelete3" value="checkbox" style="margin-top: 1px;"><label for="popDelete3" style="vertical-align: middle;"><spring:message code='ezEmail.t268' /></label>
		        </div>
            </td> 
		  </tr> 
		</table>
		<div style="width:${tableWidth}px;text-align:center;">
			<div class="btnpositionJsp">
		    	<a class="imgbtn" onClick="SavePop3()"><span><spring:message code='main.sp09' /></span></a>
		    	<a class="imgbtn" onClick="Cancel_Click()"><span><spring:message code='ezEmail.t39' /></span></a>
		    </div>	
		</div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
	</body>
</html>



