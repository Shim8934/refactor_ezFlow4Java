<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezEmail.pyy01" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/ListView_list.js')}"></script>
		<script type="text/javascript" >
		
		var senderNMData = "";
		var event_mailSenderNM = "";
		window.onload = function() {
			
			inboxRuleCon1.focus();
			senderNMData = opener.mailSenderNM[1] ;
			event_mailSenderNM = opener.mailSenderNM[2] ;
			Conitems.innerHTML = senderNMData;
			
		}
		function pop_confirm() {
			senderNMData = Conitems.innerHTML ;
			event_mailSenderNM(senderNMData);
		    inboxRuleCon1.value = "";
		    Conitems.innerHTML = "";
		    window.close();
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
		function event_Mover(obj) {
		    if (obj != _popObj)
		        obj.style.backgroundColor = "#EDEDED";
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
		                ConCellRow.outerHTML = "<div style='font-family:" + "<spring:message code='main.t246' />" + ";font-size:small;height:18px;line-height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;padding:1px;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + inboxRuleCon1.value + "'><nobr>" + inboxRuleCon1.value + "</nobr><div>";
		                inboxRuleCon1.value = "";
		                inboxRuleCon1.focus();
		                inputBtn.innerText = strLang239;
		                ConCellRow = null;
		            }
		            else {
		                Conitems.innerHTML += "<div style='font-family:" + "<spring:message code='main.t246' />" + ";font-size:small;height:18px;line-height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;padding:1px;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + inboxRuleCon1.value + "'><nobr>" + inboxRuleCon1.value + "</nobr><div>";
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
		function pop_cancel() {
	        inboxRuleCon1.value = "";
	        Conitems.innerHTML = "";
	        window.close();
		}

		function setDefault(){
            if (_popObj != null) {
                removeDefault();

                _popObj.setAttribute('value','___'+_popObj.getAttribute('value'));
                _popObj.textContent = _popObj.textContent + ' (default)'
                //_popObj.outerHTML = ;
                return;
            }
		}

		function removeDefault(){
    		$("div[value]").each(function() {
                var value = $(this).attr("value");

                if (value.startsWith("___")) {
                    var newValue = value.substring(3); // "___" 제거
                    $(this).attr("value", newValue);
                    var newText = $(this).text().replace(" (default)", ""); // " (default)" 제거
                    $(this).text(newText);
                }
            });

		}
		</script>
	</head>
	<body style="background-color:#ffffff;">
	    
	<div  id="inboxRuleConbtn1" name="inboxRuleConbtn1" >
		<div class="popupJQLayer" style="padding-top:6px;padding-bottom:9px;border-radius:0px;">
			<h1 class="title" style="overflow:hidden; text-overflow:ellipsis; width:450px;"><spring:message code="ezEmail.pyy01" /></h1>
			<div id="close">			
	            <ul>
	            	<li><span onclick="pop_cancel()"></span></li>
	            </ul>
	        </div>
			<table style="width:100%;border:0;border-collapse:collapse; border-spacing:0;padding:0px;" >
				<tr>
					<td style="width:60%;padding:10px 0 0 10px" id="ReceiverSelecttd" name="ReceiverSelecttd">
						<input type="text" id="inboxRuleCon1" name="inboxRuleCon1" style="width:100%" onKeyDown="event_keyDown(event);">
					</td>
					<td style="width:60%;padding:12px 10px 0 8px;">
						<div >
							<img src="/images/email/cntct.gif" align="absmiddle" style="cursor:pointer;display:none;" id="ReceiverSelect" name="ReceiverSelect" onclick="SelectReceiver_onClick();" />
							<a class="imgbtn imgbck"><span onClick="pop_addcon();" id="inputBtn"><spring:message code='ezEmail.t308' /></span></a>
							<a class="imgbtn imgbck"><span onClick="pop_delete();"><spring:message code='ezEmail.t95' /></span></a>
						</div>
					</td>
				</tr>
			</table>
			<div style="border:1px solid #dddddd; margin:10px 10px 10px 10px; padding:10px 10px 10px 10px; background-color:#f2f2f2;">
				<div id="Conitems" name="Conitems" style="font-family:<spring:message code='main.t246' />;border:1px solid #dbdbda;height:200px;overflow:auto;background-color:#ffffff;">
				</div>
			</div>
			<div class="btnpositionLayer">
				<a class="imgbtn"><span onClick="setDefault();"><spring:message code='ezEmail.yja002' /> </span></a>
				<a class="imgbtn"><span onClick="removeDefault();"><spring:message code='ezEmail.yja003' /></span></a>
				<a class="imgbtn"><span onClick="pop_confirm();"><spring:message code='main.sp09' /></span></a>
			</div>
		</div>	
	</div>
</html>

