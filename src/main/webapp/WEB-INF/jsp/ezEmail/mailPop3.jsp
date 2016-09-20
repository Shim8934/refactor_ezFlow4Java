<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>mail_pop3</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
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
		                if (navigator.userAgent.indexOf("MSIE") != -1) {
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
		                else if (navigator.userAgent.indexOf("MSIE") == -1) {
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
		                if (navigator.userAgent.indexOf("MSIE") != -1) {
		                    svElem = document.body.all("popDelete" + (i + 1));
		
		                }
		                else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                    svElem = document.getElementById("popDelete" + (i + 1));
		                }
		
		                if (popDelete == "Y")
		                    svElem.checked = true;
		                else
		                    svElem.checked = false;
		
		                if (navigator.userAgent.indexOf("MSIE") != -1) {
		                    var popSSL = bResult.getElementsByTagName("POP3SSLYN")[i].text;
		                    svElem = document.body.all("popSSL" + (i + 1));
		                }
		                else if (navigator.userAgent.indexOf("MSIE") == -1) {
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
		        mail_selectfolder_cross_dialogArguments[2] = "CLOSE";
		        mail_selectfolder_cross_dialogArguments[3] = idx;
		
		        var OpenWin = GetOpenWindow("/ezEmail/mailSelectFolder.do", "mail_selectfolder_cross", 400, 355);
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function search_mailbox_complete(mailBoxInfo) {
		        if (typeof (mailBoxInfo) == "undefined")
		            return;
		
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            svElem = document.body.all("popBox" + mail_selectfolder_cross_dialogArguments[3]);
		
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            svElem = document.getElementById("popBox" + mail_selectfolder_cross_dialogArguments[3]);
		        }
		        svElem.innerHTML = mailBoxInfo.name;
		        svElem.setAttribute("url", mailBoxInfo.url);
		    }
		    function SavePop3() {
		        var popID, popPW, popSave, popSaveTo, popSaveToFolder, popServer, popXML;
		        popXML = "<DATA>"
		        for (var i = 1; i < 4; i++) {
		            var svElem = "";
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                svElem = document.body.all("popServer" + i);
		
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                svElem = document.getElementById("popServer" + i);
		            }
		            popServer = svElem.value;
		            if (popServer == "")
		                continue;
		
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                svElem = document.body.all("popID" + i);
		
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                svElem = document.getElementById("popID" + i);
		            }
		            popID = svElem.value;
		            if (popID == "") {
		            	alert(i + "<spring:message code='ezEmail.t224' />");
		                return;
		            }
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                svElem = document.body.all("popPW" + i);
		
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                svElem = document.getElementById("popPW" + i);
		            }
		            popPW = svElem.value;
		
		            if (popPW == "") {
		            	alert(i + "<spring:message code='ezEmail.t225' />");
		                return;
		            }
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                svElem = document.body.all("popPort" + i);
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                svElem = document.getElementById("popPort" + i);
		            }
		            popPort = svElem.value;
		            if (popPort == "") {
		            	alert(i + "<spring:message code='ezEmail.t226' />");
		                return;
		            }
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                svElem = document.body.all("popBox" + i);
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
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
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                svElem = document.body.all("popDelete" + i);
		
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                svElem = document.getElementById("popDelete" + i);
		            }
		            if (svElem.checked == true)
		                popDelete = "Y";
		            else
		                popDelete = "N";
		
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                svElem = document.body.all("popSSL" + i);
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                svElem = document.getElementById("popSSL" + i);
		            }
		            var popSSL = svElem.checked;
		            popXML = popXML + "<ROW><SERVER>" + popServer + "</SERVER><PORT>" + popPort + "</PORT><ID>" + rsa.encrypt(popID) + "</ID><DELETE>" + popDelete + "</DELETE><PW>" + rsa.encrypt(popPW) + "</PW><SAVETO>" + popSaveTo + "</SAVETO><SAVETOFOLDER>" + popSaveToFolder + "</SAVETOFOLDER><SSL>" + popSSL + "</SSL></ROW>";
		
		        }
		        popXML = popXML + "</DATA>";
		        try {
		            var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/ezEmail/mailPop3Save.do", false);
		            xmlHTTP.send(popXML);
		
		            if (xmlHTTP.status == 200)
		            	alert("<spring:message code='ezEmail.t42' />");
		            else
		            	alert("<spring:message code='ezEmail.t228' />" + xmlHTTP.statusText);
		
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
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            svElem = document.body.all("popSelect" + idx);
		            textValue = document.body.all("popServer" + idx);
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            svElem = document.getElementById("popSelect" + idx);
		            textValue = document.getElementById("popServer" + idx);
		        }
		        if (svElem.options[svElem.selectedIndex].value == "-1") {
		            alert(svElem.options[svElem.selectedIndex].text + "<spring:message code='ezEmail.t229' />");
		            return;
		        }
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            svElem2 = document.body.all("popSelect" + idx);
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            svElem2 = document.getElementById("popSelect" + idx);
		        }
		        svElem2.value = svElem.options[svElem.selectedIndex].value;
		        textValue.value = svElem2.value;
		        if (svElem.options[svElem.selectedIndex].value == 'pop.gmail.com' || svElem.options[svElem.selectedIndex].value == 'pop.hanmail.net' || svElem.options[svElem.selectedIndex].value == 'pop3.live.com' || svElem.options[svElem.selectedIndex].value == 'pop3.nate.com' || svElem.options[svElem.selectedIndex].value == 'pop.naver.com') {
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                document.body.all("popPort" + idx).value = "995";
		                document.body.all("popSSL" + idx).checked = true;
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                document.getElementById("popPort" + idx).value = "995";
		                document.getElementById("popSSL" + idx).checked = true;
		            }
		        }
		        else {
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                document.body.all("popPort" + idx).value = "110";
		                document.body.all("popSSL" + idx).checked = false;
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                document.getElementById("popPort" + idx).value = "110";
		                document.getElementById("popSSL" + idx).checked = false;
		            }
		        }
		
		        if (svElem.options[svElem.selectedIndex].ispay == "true") {
		
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                document.body.all("popSpan" + idx).innerText = " " + strLang181;
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                document.getElementById("popPort" + idx).innerHTML = " " + strLang181;
		            }
		
		        }
		        else {
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                document.body.all("popSpan" + idx).innerText = "";
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
		                document.getElementById("popSpan" + idx).innerHTML = "";
		            }
		
		        }
		
		    }
		    function connect_test(idx) {
		        var svElem = "";
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            svElem = document.body.all("popServer" + idx);
		            var popServer = svElem.value;
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            var svElem = document.getElementById("popServer" + idx);
		            var popServer = svElem.value;
		        }
		
		        if (popServer == "") {
		        	alert("<spring:message code='ezEmail.t230' />");
		            return;
		        }
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            svElem = document.body.all("popPort" + idx);
		            var popPort = svElem.value;
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            svElem = document.getElementById("popPort" + idx);
		            var popPort = svElem.value;
		        }
		        if (popPort == "") {
		        	alert("<spring:message code='ezEmail.t231' />");
		            return;
		        }
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            svElem = document.body.all("popID" + idx);
		            var popID = svElem.value;
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            svElem = document.getElementById("popID" + idx);
		            var popID = svElem.value;
		        }
		        if (popID == "") {
		        	alert("<spring:message code='ezEmail.t232' />");
		            return;
		        }
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            svElem = document.body.all("popPW" + idx);
		            var popPW = svElem.value;
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            svElem = document.getElementById("popPW" + idx);
		            var popPW = svElem.value;
		        }
		        if (popPW == "") {
		        	alert("<spring:message code='ezEmail.t233' />");
		            return;
		        }
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            svElem = document.body.all("popSSL" + idx);
		            var popSSL = svElem.checked;
		            var popXML = "<DATA><SERVER>" + popServer + "</SERVER><PORT>" + popPort + "</PORT><ID>" + rsa.encrypt(popID) + "</ID>" + "<PW>" + rsa.encrypt(popPW) + "</PW><SSL>" + popSSL + "</SSL></DATA>";
		
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            svElem = document.getElementById("popSSL" + idx);
		            var popSSL = svElem.checked;
		            var popXML = "<DATA><SERVER>" + popServer + "</SERVER><PORT>" + popPort + "</PORT><ID>" + rsa.encrypt(popID) + "</ID>" + "<PW>" + rsa.encrypt(popPW) + "</PW><SSL>" + popSSL + "</SSL></DATA>";
		
		        }
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("POST", "/ezEmail/mailPop3Connect.do", false);
		        xmlHTTP.send(popXML);
		        if (xmlHTTP.status == 200) {
		            if (navigator.userAgent.indexOf("MSIE") != -1) {
		                if (xmlHTTP.responseXML.text == "OK")
		                	alert("<spring:message code='ezEmail.t234' />");
		                else
		                	alert("<spring:message code='ezEmail.t235' />\n\n<spring:message code='ezEmail.t236' />");
		
		            }
		            else if (navigator.userAgent.indexOf("MSIE") == -1) {
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
		        	alert("<spring:message code='ezEmail.t237' />" + xmlHTTP.statusText);
		    }
					
		    function replaceAll(pStrContent, pStrOrg, pStrRep) {
		        return pStrContent.split(pStrOrg).join(pStrRep);
		    }
		</script>
	</head>
	<body onload="javascript:window_onload()" style="margin-left:10px;margin-right:10px;">
		<br>
		<span class="txt" ><spring:message code='ezEmail.t239' /><br> 
		      <spring:message code='ezEmail.t240' /><br> 
		    <spring:message code='ezEmail.t241' /></span><br>
		      <br> 
		<h2 class="h2_dot"><spring:message code='ezEmail.t242' /></h2>	
		<table class="content" style="width:720px;margin-left:13px;"> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t243' /></th> 
		    <td colspan="3"> <input type="text" name="popServer1" id="popServer1" class="textarea" style="width:200px"> 
		      <select name="popSelect1" id="popSelect1" class="select" onChange="popChange(1)" style="vertical-align:middle;width:200px;"> 
			    <OPTION VALUE=""><spring:message code='ezEmail.t731' /></option>
			    <OPTION VALUE="pop.naver.com"><spring:message code='ezEmail.t732' /></option>
			    <OPTION VALUE="pop3.nate.com"><spring:message code='ezEmail.t733' /></option>
			    <OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
			    <OPTION VALUE="kornet.net"><spring:message code='ezEmail.t252' /></option>
			    <OPTION VALUE="soback.kornet.net"><spring:message code='ezEmail.t253' /></option>
			    <OPTION VALUE="pop3.live.com"><spring:message code='ezEmail.t735' /></option>
			    <OPTION VALUE="">----------------</option>
			    <OPTION VALUE="email.kebi.com" ispay="true"><spring:message code='ezEmail.t258' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.netian.com" ispay="true"><spring:message code='ezEmail.t247' />(<spring:message code='ezEmail.t743' />)(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="netian.com" ispay="true"><spring:message code='ezEmail.t247' />(<spring:message code='ezEmail.t744' />)(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.dreamwiz.com" ispay="true"><spring:message code='ezEmail.t251' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pmail.unitel.co.kr" ispay="true"><spring:message code='ezEmail.t736' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.chol.com" ispay="true"><spring:message code='ezEmail.t250' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop3.paran.com" ispay="true"><spring:message code='ezEmail.t737' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop3.freechal.com" ispay="true"><spring:message code='ezEmail.t738' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="mail.hanafos.com" ispay="true"><spring:message code='ezEmail.t739' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.hanmail.net" ispay="true"><spring:message code='ezEmail.t740' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.korea.com" ispay="true">Korea.com(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="">----------------</option>
			    <OPTION VALUE=""><spring:message code='ezEmail.t244' /></option>
			</select>	
		      Port : <input type="text" name="popPort1" id="popPort1" class="textarea" style="width:30px" value="110"> 
		      SSL :<input type="checkbox" name="popSSL1" id="popSSL1"></td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t263' /></th> 
		    <td style="width:100%;"> <input type="text" name="popID1" id="popID1" class="textarea" style="width:200px"><span id="popSpan1"></span></td> 
		    <th style="white-space:nowrap" ><spring:message code='ezEmail.t264' /></th> 
		    <td style="white-space:nowrap;width:250px;"> <input type="password" name="popPW1" id="popPW1" class="textarea" style="width:100px;margin:0px 1px 0px 0px;">
		        <a  class="imgbtn"><span onClick="connect_test(1)"><spring:message code='ezEmail.t265' /></span></a></td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t266' /></th> 
		    <td colspan="3"><a  class="imgbtn"><span onClick="search_mailbox(1)"><spring:message code='ezEmail.t37' /></span></a> <spring:message code='ezEmail.t267' /><span id='popBox1' url=""><spring:message code='ezEmail.t158' /></span> 
		      <input type="checkbox" name="popDelete1" id="popDelete1" value="checkbox"> 
		      <spring:message code='ezEmail.t268' /></td> 
		  </tr> 
		</table> 
		<br>
		<h2 class="h2_dot"><spring:message code='ezEmail.t700' /></h2> 
		<table class="content" style="width:720px;margin-left:13px;">
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t243' /></th> 
		    <td colspan="3"> <input type="text" name="popServer2" id="popServer2" class="textarea" style="width:200px"> 
		      <select name="popSelect2" id="popSelect2" class="select" onChange="popChange(2)" style="vertical-align:middle;width:200px;"> 
		         <OPTION VALUE=""><spring:message code='ezEmail.t731' /></option>
			    <OPTION VALUE="pop.naver.com"><spring:message code='ezEmail.t732' /></option>
			    <OPTION VALUE="pop3.nate.com"><spring:message code='ezEmail.t733' /></option>
			    <OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
			    <OPTION VALUE="kornet.net"><spring:message code='ezEmail.t252' /></option>
			    <OPTION VALUE="soback.kornet.net"><spring:message code='ezEmail.t253' /></option>
			    <OPTION VALUE="pop3.live.com"><spring:message code='ezEmail.t735' /></option>
			    <OPTION VALUE="">----------------</option>
			    <OPTION VALUE="email.kebi.com" ispay="true"><spring:message code='ezEmail.t258' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.netian.com" ispay="true"><spring:message code='ezEmail.t247' />(<spring:message code='ezEmail.t743' />)(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="netian.com" ispay="true"><spring:message code='ezEmail.t247' />(<spring:message code='ezEmail.t744' />)(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.dreamwiz.com" ispay="true"><spring:message code='ezEmail.t251' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pmail.unitel.co.kr" ispay="true"><spring:message code='ezEmail.t736' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.chol.com" ispay="true"><spring:message code='ezEmail.t250' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop3.paran.com" ispay="true"><spring:message code='ezEmail.t737' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop3.freechal.com" ispay="true"><spring:message code='ezEmail.t738' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="mail.hanafos.com" ispay="true"><spring:message code='ezEmail.t739' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.hanmail.net" ispay="true"><spring:message code='ezEmail.t740' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.korea.com" ispay="true">Korea.com(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="">----------------</option>
			    <OPTION VALUE=""><spring:message code='ezEmail.t244' /></option>
		      </select> 
		      Port : <input type="text" name="popPort2" id="popPort2" class="textarea" style="width:30px" value="110"> 
		      SSL :<input type="checkbox" name="popSSL2" id="popSSL2"></td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t263' /></th> 
		    <td style="width:100%;"> <input type="text" name="popID2" id="popID2" class="textarea" style="width:200px"> <span id="popSpan2"></span></td> 
		    <th style="white-space:nowrap" ><spring:message code='ezEmail.t264' /></th> 
		    <td style="white-space:nowrap;width:250px;"> <input type="password" name="popPW2" id="popPW2" class="textarea" style="width:100px;margin:0px 0px 0px 0px;"> 
		      <a  class="imgbtn"><span onClick="connect_test(2)"><spring:message code='ezEmail.t265' /></span></a> </td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t266' /></th> 
		    <td colspan="3"><a  class="imgbtn"><span onClick="search_mailbox(2)"><spring:message code='ezEmail.t37' /></span></a><span><spring:message code='ezEmail.t267' /></span><span id='popBox2' url=""><spring:message code='ezEmail.t158' /></span> 
		      <input type="checkbox" name="popDelete2" id="popDelete2" value="checkbox"> 
		      <spring:message code='ezEmail.t268' /></td> 
		  </tr> 
		</table> 
		<br> 
		<h2 class="h2_dot"><spring:message code='ezEmail.t701' /></h2> 
		<table class="content" style="width:720px;margin-left:13px;"> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t243' /></th> 
		    <td colspan="3"> <input type="text" name="popServer3" id="popServer3" class="textarea" style="width:200px"> 
		      <select name="popSelect3" id="popSelect3" class="select" onChange="popChange(3)" style="vertical-align:middle;width:200px;"> 
		         <OPTION VALUE=""><spring:message code='ezEmail.t731' /></option>
			    <OPTION VALUE="pop.naver.com"><spring:message code='ezEmail.t732' /></option>
			    <OPTION VALUE="pop3.nate.com"><spring:message code='ezEmail.t733' /></option>
			    <OPTION VALUE="pop.gmail.com"><spring:message code='ezEmail.t734' /></option>
			    <OPTION VALUE="kornet.net"><spring:message code='ezEmail.t252' /></option>
			    <OPTION VALUE="soback.kornet.net"><spring:message code='ezEmail.t253' /></option>
			    <OPTION VALUE="pop3.live.com"><spring:message code='ezEmail.t735' /></option>
			    <OPTION VALUE="">----------------</option>
			    <OPTION VALUE="email.kebi.com" ispay="true"><spring:message code='ezEmail.t258' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.netian.com" ispay="true"><spring:message code='ezEmail.t247' />(<spring:message code='ezEmail.t743' />)(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="netian.com" ispay="true"><spring:message code='ezEmail.t247' />(<spring:message code='ezEmail.t744' />)(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.dreamwiz.com" ispay="true"><spring:message code='ezEmail.t251' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pmail.unitel.co.kr" ispay="true"><spring:message code='ezEmail.t736' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.chol.com" ispay="true"><spring:message code='ezEmail.t250' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop3.paran.com" ispay="true"><spring:message code='ezEmail.t737' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop3.freechal.com" ispay="true"><spring:message code='ezEmail.t738' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="mail.hanafos.com" ispay="true"><spring:message code='ezEmail.t739' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.hanmail.net" ispay="true"><spring:message code='ezEmail.t740' />(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="pop.korea.com" ispay="true">Korea.com(<spring:message code='ezEmail.t741' />)</option>
			    <OPTION VALUE="">----------------</option>
			    <OPTION VALUE=""><spring:message code='ezEmail.t244' /></option>
		      </select> 
		      Port : <input type="text" name="popPort3" id="popPort3" class="textarea" style="width:30px" value="110"> 
		      SSL :<input type="checkbox" name="popSSL3" id="popSSL3"></td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t263' /></th>
		    <td style="width:100%;"> <input type="text" name="popID3" id="popID3" class="textarea" style="width:200px"> <span id="popSpan3"></span></td> 
		    <th style="white-space:nowrap" ><spring:message code='ezEmail.t264' /></th> 
		    <td style="white-space:nowrap;width:250px;"> <input type="password" name="popPW3" id="popPW3" class="textarea" style="width:100px;margin:0px 0px 0px 0px;"> 
		      <a  class="imgbtn"><span onClick="connect_test(3)"><spring:message code='ezEmail.t265' /></span></a></td> 
		  </tr> 
		  <tr> 
		    <th style="white-space:nowrap"><spring:message code='ezEmail.t266' /></th> 
		    <td colspan="3"> <a  class="imgbtn"><span onClick="search_mailbox(3)"><spring:message code='ezEmail.t37' /></span></a><span><spring:message code='ezEmail.t267' /></span><span id='popBox3' url=""><spring:message code='ezEmail.t158' /></span> 
		      <input type="checkbox" name="popDelete3" value="checkbox" id="popDelete3"> 
		      <spring:message code='ezEmail.t268' /></td> 
		  </tr> 
		</table> 
		<br />
		<div style="width:720px;text-align:center;">
		    <a class="imgbtn" onClick="SavePop3()"><span><spring:message code='ezEmail.t48' /></span></a>
		    <a class="imgbtn" onClick="Cancel_Click()"><span><spring:message code='ezEmail.t39' /></span></a>
		</div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
	</body>
</html>



