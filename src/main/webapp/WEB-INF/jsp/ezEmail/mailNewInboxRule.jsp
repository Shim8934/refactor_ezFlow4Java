<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.t804' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/ListView_list.js"></script>
		<script type="text/javascript" >
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            ReturnFunction = opener.mail_newinboxrule_cross_dialogArguments[1];
		        } catch (e) { }
		        ConArea.innerHTML += "<span style='margin-left:25px;'>" + inboxRuleCon.innerHTML + "</span>";
		        ActArea.innerHTML += "<span style='margin-left:20px;'>" + inboxRuleAct.innerHTML + "</span>";
		        ExptArea.innerHTML += "<span style='margin-left:20px;'>" + inboxRuleExpt.innerHTML + "</span>";
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("RuleDisplayName"));
		                KeEventControl(document.getElementById("inboxRuleCon1"));
		            }
		        }
		        catch (e)
		        { }
		    }
		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
		        {
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
		    
		    function deleteCell(obj) {
		        obj.parentNode.parentNode.outerHTML = "";
		    }
		    function AddRule(obj) {
		        
		        if (obj.childNodes.length >= 4)
		        {
		            alert(strLang218);
		            return;
		        }
		        
		
		        var span = document.createElement("SPAN");
		        span.innerHTML = "<br/><span class='txt' style='text-align:left;margin-left:25px;'></span><br /><span>"
		                            + "<span onclick='deleteCell(this)' style='cursor:pointer;'><img src='/images/ImgIcon/delete.gif' align='absmiddle'  height='16' style='margin-top:-3px;' hspace='2' /></span>";
		
		        switch (obj.id) {
		            case "ConArea":
		                span.innerHTML += inboxRuleCon.innerHTML + "</span>";
		                break;
		            case "ActArea":
		                span.innerHTML += inboxRuleAct.innerHTML + "</span>";
		                break;
		            case "ExptArea":
		                span.innerHTML += inboxRuleExpt.innerHTML + "</span>";
		                break;
		        }
		
		        obj.appendChild(span);
		
		        if (obj.id == "ConArea") {
		            // 첫 CONDITION 외에는 '모든 메시지' 조건을 삭제함
		            curCon = document.all("Condition").item(ConArea.childNodes.length - 1);
		            curCon.remove(curCon.length - 1);
		        }
		    }
		
		    var _curCellObj = null;
		    var _RuleKind = null;
		
		    function Actselect(obj) {
		        _curCellObj = obj.nextSibling;
		        _RuleKind = obj.value;
		
		        for (var i = 0; i < document.getElementsByName("ActS").length - 1; i++) {
		            if (document.getElementsByName("ActS").item(i).getAttribute("RuleKind") == obj.value) {
		                alert(strLang224);
		                obj.item(0).selected = true;
		                return;
		            }
		        }
		
		        switch (obj.value) {
		            case "MOVE":
		            case "COPY":
		                getFolder();
		                break;
		            case "DELETE":
		                _curCellObj.innerHTML = "<span style='vertical-align:middle;margin-top-10px;'><u>" + strLang234 + "</u></span>";
		                _curCellObj.setAttribute("RuleKind", "DELETE");
		                break;
		            case "FORWARD":
		            case "REDIRECTION":
		                document.getElementById("ReceiverSelecttd").style.width = "54%";
		                document.getElementById("ReceiverSelect").style.display = "";
		                inboxRuleConbtn1.style.display = "";
		                inboxRuleCon1.focus();
		                break;
		            case "READ":
		                _curCellObj.innerHTML = "<span style='vertical-align:middle;margin-top-10px;'><u>" + strLang341 + "</u></span>";
		                _curCellObj.setAttribute("RuleKind", "READ");
		                break;
		            case "IMPORTANCE":
		                _curCellObj.setAttribute("RuleKind", "IMPORTANCE");
		                _curCellObj.nextSibling.nextSibling.style.display = "";
		                _curCellObj.innerHTML = "<span style='vertical-align:middle;margin-top-10px;'><u>" + strLang343 + "</u></span>";
		                _curCellObj.style.width = "auto";
		                break;
		        }
		
		        if (obj.value != "IMPORTANCE")
		            _curCellObj.nextSibling.nextSibling.style.display = "none";
		
		        Commentdsc(obj.value);
		    }
		    var mail_selectfolder_cross_dialogArguments = new Array();
		    function ImSelect(obj) {
		        if (obj.value != "NONE") {
		            obj.previousSibling.previousSibling.setAttribute("value", obj.value);
		        }
		    }
		    function getFolder() {
		        mail_selectfolder_cross_dialogArguments[1] = getFolder_Complete;
		        mail_selectfolder_cross_dialogArguments[2] = getFolder_Complete;
		        DivPopUpShow(400, 355, "/ezEmail/mailSelectFolder.do");
		    }
		    function getFolder_Complete(mailBoxInfo) {
		        try {
		            DivPopUpHidden();
		            if (typeof (mailBoxInfo) == "undefined") {
		                ActRObject.parentNode.children.item(1).innerHTML = "<span onclick='getFoldercell(this);' style='vertical-align:middle;margin-top-10px;'><u>" + strLang219 + "</u></span>";
		                return;
		            }
		
		            var url = mailBoxInfo["url"];
		            var name = folderdisnameChange(mailBoxInfo["name"]);
		            _curCellObj.setAttribute("RuleKind", _RuleKind);
		            _curCellObj.setAttribute("url", url);
		            _curCellObj.setAttribute("fordername", name);
		            _curCellObj.innerHTML = "<span onclick='getFoldercell(this);' style='font-family:dotum' value='" + url + "'><nobr>\"<u>" + name + "" + ((_RuleKind == "MOVE") ? strLang220 : strLang342) + "</u></nobr></span>";
		        } catch (e) {
		
		        }
		    }
		    function getFoldercell(obj) {
		        _curCellObj = obj.parentNode;
		        _RuleKind = _curCellObj.getAttribute("RuleKind");
		        mail_selectfolder_cross_dialogArguments[1] = getFolder_Complete;
		        mail_selectfolder_cross_dialogArguments[2] = getFolder_Complete;
		        mail_selectfolder_cross_dialogArguments[3] = obj.parentNode;
		        DivPopUpShow(400, 355, "/ezEmail/mailSelectFolder.do");
		    }
		    function getFoldercell_Complete(mailBoxInfo) {
		        try {
		            DivPopUpHidden
		            if (typeof (mailBoxInfo) == "undefined") {
		                mail_selectfolder_cross_dialogArguments[3].innerHTML = "<span onclick='getFoldercell(this);' style='vertical-align:middle;margin-top-10px;'><u>" + strLang219 + "</u></span>";
		                return;
		            }
		
		            var url = mailBoxInfo["url"];
		            var name = folderdisnameChange(mailBoxInfo["name"]);
		            //mail_selectfolder_cross_dialogArguments[3].parentNode.setAttribute("RuleKind", "MOVE");
		            _curCellObj.setAttribute("url", url);
		            _curCellObj.setAttribute("fordername", name);
		            _curCellObj.innerHTML = "<span onclick='getFoldercell(this);' style='font-family:dotum' value='" + url + "'><nobr>\"<u>" + name + "" + ((_RuleKind == "MOVE") ? strLang220 : strLang342) + "</u></nobr></span>";
		        } catch (e) {
		
		        }
		    }
		    function IsEmail(strEmail) {
		        var regx = new RegExp(/^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/g);
		        return regx.test(strEmail);
		    }
		    function IsDomain(strDomain) {
		        var regx = new RegExp(/@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/g);
		        return regx.test(strDomain);
		    }
		    function IsKorean(strEmailAddr) {
		        var regx = new RegExp(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/);
		        return regx.test(strEmailAddr);
		    }
		    function pop_addcon() {
		        if (inboxRuleCon1.value.length > 0) {
		            var ischeck = true;
		            if (_RuleKind == "SENDER" || _RuleKind == "RECEIVER" || _RuleKind == "FORWARD" || _RuleKind == "REDIRECTION")
		                ischeck = IsEmail(inboxRuleCon1.value);
		
		            var isSenderAddress = true;
		            if (_RuleKind == "DOMAIN") {
		                if (IsKorean(inboxRuleCon1.value)) {
		                    inboxRuleCon1.value = "";
		                    inboxRuleCon1.focus();
		                    alert(strLang309);
		                    return;
		                }
		                else {
		                    if (!IsDomain(inboxRuleCon1.value)) {
		                        alert(strLang310);
		                        return;
		                    }
		                }
		            }
		            for (var i = 0; i < Conitems.childNodes.length; i++) {
		                if (inboxRuleCon1.value == Conitems.childNodes.item(i).value) {
		                    if (confirm(strLang221)) {
		                        inboxRuleCon1.focus();
		                        return;
		                    }
		                    else {
		                        inboxRuleCon1.value = "";
		                        inboxRuleCon1.focus();
		                        inputBtn.textContent = strLang239;
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
		                    inputBtn.textContent = strLang239;
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
		                inputBtn.textContent = strLang239;
		                ConCellRow = null;
		            }
		        }
		        else
		            alert(strLang223);
		    }
		    function pop_addcon2(rulekind, value) {
		        if (value.length > 0) {
		            if (rulekind == "SENDER" || rulekind == "RECEIVER" || rulekind == "FORWARD" || rulekind == "REDIRECTION") {
		                if (value.split("<").length > 1) {
		                    var mailaddress = value.split("<")[1].replace(">", "");
		                    Conitems.innerHTML += "<div style='font-family:dotum;font-size:small;height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' ondblclick onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + mailaddress + "'><nobr>" + MakeXMLString(value) + "</nobr><div>";
		                }
		                else {
		                    Conitems.innerHTML += "<div style='font-family:dotum;font-size:small;height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' ondblclick onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + value + "'><nobr>" + value + "</nobr><div>";
		                }
		            }
		            else {
		                Conitems.innerHTML += "<div style='font-family:dotum;font-size:small;height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' ondblclick onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + value + "'><nobr>" + value + "</nobr><div>";
		            }
		        }
		    }
		    function event_Mover(obj) {
		        if (obj != _popObj)
		            obj.style.backgroundColor = "#EDEDED";
		    }
		    function event_Mout(obj) {
		        if (obj != _popObj)
		            obj.style.backgroundColor = "#FFFFFF";
		    }
		    var _popObj = null; ;
		    function event_Mclick(obj) {
		
		        if (_popObj != null) {
		            _popObj.style.backgroundColor = "#ffffff";
		        }
		        _popObj = obj;
		        obj.style.backgroundColor = "#DBE1E7";
		    }
		    function random() {
		        return Math.floor(Math.random() * 100);
		    }
		    var ConCellRow=null;
		    function pop_modify(obj) {
		        ConCellRow = obj;
		        inboxRuleCon1.value = obj.getAttribute("value");
		        inboxRuleCon1.focus();
		        document.getElementById("inputBtn").textContent = strLang240;
		    }
		    function pop_delete() {
		        if (_popObj != null) {
		            inboxRuleCon1.value = "";
		            _popObj.outerHTML = "";
		            inboxRuleCon1.focus();
		            inputBtn.textContent = strLang239;
		            ConCellRow = null;
		            return;
		        }
		    }
		    function event_keyDown(e) {
		        var curevent = (typeof event == 'undefined' ? e : event)
		        if (curevent.keyCode == "13")
		            pop_addcon();
		    }
		    function pop_cancel() {
		        var rtnValue = false;
		        if (Conitems.children.length > 0) {
		            rtnValue = confirm(strLang313);
		            if (!rtnValue)
		                return;
		        }
		        if (rtnValue &&
		            (_curCellObj.getAttribute("value") == "" ||
		            _curCellObj.getAttribute("value") == null)) {
		            _curCellObj.innerHTML = "<span onclick='Ruleselectcell(this);' value=''><nobr><u>" + strLang219 + "</u></nobr></span>";
		            _curCellObj.setAttribute("RuleKind", _RuleKind);
		            _curCellObj.setAttribute("value", "");
		            inboxRuleConbtn1.style.display = "none";
		            _curCellObj = null;
		            _RuleKind = null;
		            inboxRuleCon1.value = "";
		            Conitems.innerHTML = "";
		            inputBtn.textContent = strLang239;
		            ConCellRow = null;
		            return;
		        }
		        inboxRuleConbtn1.style.display = "none";
		        inputBtn.textContent = strLang239;
		        ConCellRow = null;
		        _curCellObj = null;
		        _RuleKind = null;
		        inboxRuleCon1.value = "";
		        Conitems.innerHTML = "";
		    }
		    function pop_confrim() {
		        var _exp = "";
		        var _value = "";
		        var _displaynames = "";
		        if (Conitems.children.length == 0) {
		
		            _curCellObj.innerHTML = "<span onclick='Ruleselectcell(this);' value=''><nobr><u>" + strLang219 + "</u></nobr></span>";
		            _curCellObj.setAttribute("RuleKind", _RuleKind);
		            _curCellObj.setAttribute("value", "");
		            inboxRuleConbtn1.style.display = "none";
		            _curCellObj = null;
		            _RuleKind = null;
		            inboxRuleCon1.value = "";
		            Conitems.innerHTML = "";
		            return;
		        }
		        for (var i = 0; i < Conitems.children.length; i++) {
		            if (_exp == "") {		
                        _exp = "\"" + MakeXMLString(TrimText(Conitems.children.item(i).textContent)) + "\"";
                        _value = MakeXMLString(TrimText(Conitems.children.item(i).textContent));                            
		            }
		            else {
                        _exp += "" + strLang235 + "" + MakeXMLString(TrimText(MakeXMLString(Conitems.children.item(i).textContent))) + "\"";
                        _value += ";" + MakeXMLString(TrimText(Conitems.children.item(i).textContent));
		            }
		        }
		        if (_curCellObj != null) {
		            _curCellObj.innerHTML = "<span onclick='Ruleselectcell(this);' style='font-family:dotum' value='" + _value + "'><nobr><u>" + _exp + "</u></nobr></span>";;
		            _curCellObj.setAttribute("value", _value);
		            _curCellObj.setAttribute("RuleKind", _RuleKind);
		        }
		        inboxRuleConbtn1.style.display = "none";
		        inputBtn.textContent = strLang239;
		        ConCellRow = null;
		        _curCellObj = null;
		        _RuleKind = null;
		        Conitems.innerHTML = "";
		        inboxRuleCon1.value = "";
		    }
		    var _RuleKind = null;
		    function Ruleselect(obj) {
		        _curCellObj = obj.nextSibling;
		        _RuleKind = obj.value;
		
		        // 예외 사용안함 선택
		        if (_curCellObj.id == "ExptS" && obj.value == "NONE") {
		            _curCellObj.setAttribute("RuleKind", "");
		            _curCellObj.setAttribute("value", "");
		            _curCellObj.innerHTML = "";
		        }
		
		        if (obj.value != "NONE") {
		            for (var i = 0; i < document.all(_curCellObj.id).length - 1; i++) {
		                if (document.all(_curCellObj.id).item(i).getAttribute("RuleKind") == obj.value) {
		                    alert(strLang224);
		                    obj.item(0).selected = true;
		                    return;
		                }
		            }
		            if ((_curCellObj.getAttribute("value") != ""
		                && _curCellObj.getAttribute("value") != null)
		                && _curCellObj.getAttribute("RuleKind") != obj.value) {
		                if (!confirm(strLang225)) {
		                    switch (_curCellObj.getAttribute("RuleKind")) {
		                        case "SENDER":
		                            obj.selectedIndex = 1;
		                            obj.item(1).checked = true;
		                            break;
		                        case "DOMAIN":
		                            obj.selectedIndex = 2;
		                            obj.item(2).checked = true;
		                            break;
		                        case "RECEIVER":
		                            obj.selectedIndex = 3;
		                            obj.item(3).checked = true;
		                            break;
		                        case "SUBJECT":
		                            obj.selectedIndex = 4;
		                            obj.checked = true;
		                            break;
		                        case "BODY":
		                            obj.selectedIndex = 5;
		                            obj.item(5).checked = true;
		                            break;
		                        case "SUBJECTORBODY":
		                            obj.selectedIndex = 6;
		                            obj.item(6).checked = true;
		                            break;
		                        case "ALLMESSAGES":
		                            obj.selectedIndex = 7;
		                            obj.item(7).checked = true;
		                            break;
		                    }
		                    return;
		                }
		                else {
		                    _curCellObj.removeAttribute("RuleKind", true)
		                    _curCellObj.removeAttribute("value", true)
		                }
		            }
		            if (obj.value == "SENDER" || obj.value == "RECEIVER") {
		                document.getElementById("ReceiverSelecttd").style.width = "54%";
		                document.getElementById("ReceiverSelect").style.display = "";
		            }
		            else {
		                document.getElementById("ReceiverSelecttd").style.width = "60%";
		                document.getElementById("ReceiverSelect").style.display = "none";
		            }
		
		            // '모든 메시지 포함'일시 조건 추가 버튼을 숨기고 Rules에 값 반영
		            if (obj.value != "ALLMESSAGES") {
		                inboxRuleConbtn1.style.display = "";
		                inboxRuleCon1.focus();
		                if (obj.name == "Condition")
		                    document.getElementById("tb_AddRuleCon").style.display = "";
		            }
		            else {
		                if (obj.name == "Condition")
		                    document.getElementById("tb_AddRuleCon").style.display = "none";
		
		                document.getElementById("ConS").innerHTML = strLang340;
		                document.getElementById("ConS").setAttribute("RuleKind", "ALLMESSAGES");
		                document.getElementById("ConS").setAttribute("value", "ALLMESSAGES");
		                // '모든 메시지 포함'일시 추가 적용된 조건 해제
		                var curCon = ConArea.childNodes.length;
		                if (curCon > 1) {
		                    for (i = curCon; i > 1 ; i--) {
		                        ConArea.childNodes.item(i - 1).outerHTML = "";
		                    }
		                }
		            }
		
		            Commentdsc(_RuleKind);
		        }
		    }
		    function Ruleselectcell(obj) {
		        _curCellObj = obj.parentNode;
		        _RuleKind = _curCellObj.getAttribute("RuleKind");
		        if (obj.value != "") {
		            for (var i = 0; i < obj.getAttribute("value").split(';').length; i++) {
		                var _value = obj.getAttribute("value").split(';')[i];
		                pop_addcon2(_RuleKind, _value);
		            }
		        }
		        if (_RuleKind == "SENDER" || _RuleKind == "RECEIVER" || _RuleKind == "FORWARD" || _RuleKind == "REDIRECTION") {
		            document.getElementById("ReceiverSelecttd").style.width = "54%";
		            document.getElementById("ReceiverSelect").style.display = "";
		        }
		        else {
		            document.getElementById("ReceiverSelecttd").style.width = "60%";
		            document.getElementById("ReceiverSelect").style.display = "none";
		        }
		        inboxRuleConbtn1.style.display = "";
		        inboxRuleCon1.focus();
		        Commentdsc(_RuleKind)
		    }
		    var mail_newreceiverchoose_dialogArguments = new Array();
		    function SelectReceiver_onClick() {
		        var type = "rule";
		        var receiverData = new Array();
		        receiverData["addReceiver"] = addReceiver;
		        receiverData["window"] = this;
		        mail_newreceiverchoose_dialogArguments[0] = receiverData;
		        mail_newreceiverchoose_dialogArguments[1] = addReceiver;
		        var OpenWin = window.open("/ezEmail/mailNewReceiverChoose.do?defaultwin=&type=" + type + "&rulekind=" + _RuleKind, "mail_foldermanage_Cross", GetOpenWindowfeature(970, 655));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function addReceiver(pListView) {
		        var ListData = loadXMLString(pListView);
		        var count = ListData.getElementsByTagName("ROW").length;
		        for (var nCnt1 = 0; nCnt1 < count; nCnt1++) {
		            var ischeck = true;
		            if (!CrossYN()) {
		                if (!IsEmail(ListData.getElementsByTagName("EMAIL")[nCnt1].text)) {
		                    continue;
		                }
		            }
		            else if (CrossYN()) {
		                if (!IsEmail(ListData.getElementsByTagName("EMAIL")[nCnt1].textContent)) {
		                    continue;
		                }
		            }
		            var Name = "";
		            var Email = "";
		            if (!CrossYN()) {
		
		                Name = ListData.getElementsByTagName("NAME")[nCnt1].text;
		                Email = ListData.getElementsByTagName("EMAIL")[nCnt1].text;
		            }
		            else if (CrossYN()) {
		
		                Name = ListData.getElementsByTagName("NAME")[nCnt1].textContent;
		                Email = ListData.getElementsByTagName("EMAIL")[nCnt1].textContent;
		            }
		            for (var i = 0; i < Conitems.childNodes.length; i++) {
		                if (Email == Conitems.childNodes.item(i).value) {
		                    ischeck = false; break;
		                }
		            }
		            if (ischeck) {
		                Conitems.innerHTML += "<div style='font-family:dotum;font-size:small;height:18px;vertical-align:middle;border-bottom:1px solid #dbdbda;' ondblclick='pop_modify(this);' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_Mclick(this);' value='" + Email + "'><nobr>" + Email + "</nobr><div>";
		            }
		        }
		    }
		    function Commentdsc(kind) {
		        switch (kind) {
		            case "SENDER":
		                inboxRuleConbtn1comment.innerHTML = "<img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'> " + strLang226 + "";
		                break;
		            case "DOMAIN":
		                inboxRuleConbtn1comment.innerHTML = "<img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'> " + strLang308 + " ex) @kaoni.com" + "";
		                break;
		            case "REDIRECTION":
		            case "FORWARD":
		            case "RECEIVER":
		                inboxRuleConbtn1comment.innerHTML = "<img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'> " + strLang227 + "";
		                break;
		            case "SUBJECT":
		                inboxRuleConbtn1comment.innerHTML = "<img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'> " + strLang228 + "";
		                break;
		            case "BODY":
		                inboxRuleConbtn1comment.innerHTML = "<img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'> " + strLang229 + "";
		                break;
		            case "SUBJECTORBODY":
		                inboxRuleConbtn1comment.innerHTML = "<img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'> " + strLang338 + "";
		                break;
		        }
		    }
		    function New_InboxRule() {
		
		        if (document.getElementById("RuleDisplayName").value == "") {
		            alert(strLang230); return;
		        }
		        if (document.getElementsByName("ConS").length == 1) {
		            alert(strLang231); return;
		        }
		        else {
		            var isRule = false;
		            for (var i = 0; i < document.getElementsByName("ConS").length - 1; i++) {
		                if (document.getElementsByName("ConS").item(0).getAttribute("RuleKind") != null
		                   && (document.getElementsByName("ConS").item(0).getAttribute("value") != null && document.getElementsByName("ConS").item(0).getAttribute("value") != ""))
		                    isRule = true;
		            }
		            if (!isRule) {
		                alert(strLang231); return;
		            }
		        }
		        if (document.getElementsByName("ActS").length == 1) {
		            alert(strLang232); return;
		        }
		        else {
		            if (document.getElementsByName("ActS").item(0).getAttribute("RuleKind") == null) {
		                alert(strLang232); return;
		            }
		        }
		        var XmlDom = createXmlDom();
		        var Xmlhttp = createXMLHttpRequest();
		        var objRoot, objRow, objRow2, objRow3, objNode, objRowRow, objRow2Row, objRow3Row, objRows;
		        objNode = createNodeInsert(XmlDom, objNode, "DATA");
		        createNodeAndInsertText(XmlDom, objNode, "NAME", document.getElementById("RuleDisplayName").value);
		
		        // CONDITION NODE
		        objRow = createNodeAndAppandNode(XmlDom, objNode, objRow, "CONDITION");
		
		        for (var i = 0; i < document.getElementsByName("ConS").length - 1; i++) {
		
		            curKind = document.getElementsByName("ConS").item(i).getAttribute("RuleKind");
		            objRows = createNodeAndAppandNode(XmlDom, objRow, objRows, "ROW");
		            createNodeAndAppandNodeText(XmlDom, objRows, objRowRow, "CONKIND", curKind);
		            createNodeAndAppandNodeText(XmlDom, objRows, objRowRow, "CONVALUE", document.getElementsByName("ConS").item(i).getAttribute("value"));
		        }
		
		        // ACTION NODE
		        objRow2 = createNodeAndAppandNode(XmlDom, objNode, objRow2, "ACTION");
		
		        for (var i = 0; i < document.getElementsByName("ActS").length - 1; i++) {
		            curKind = document.getElementsByName("ActS").item(i).getAttribute("RuleKind");
		            objRows = createNodeAndAppandNode(XmlDom, objRow2, objRows, "ROW");
		            createNodeAndAppandNodeText(XmlDom, objRows, objRow2Row, "ACTKIND", curKind);
		
		            if (curKind == "MOVE" || curKind == "COPY") {
		                createNodeAndAppandNodeText(XmlDom, objRows, objRow2Row, "URL", document.getElementsByName("ActS").item(i).getAttribute("url"));
		                createNodeAndAppandNodeText(XmlDom, objRows, objRow2Row, "NAME", document.getElementsByName("ActS").item(i).getAttribute("fordername"));
		            }
		            else {
		                createNodeAndAppandNodeText(XmlDom, objRows, objRow2Row, "ACTVALUE", document.getElementsByName("ActS").item(i).getAttribute("value"));
		            }
		
		            // 중요도 선택을 하지 않았을 경우
		            if (curKind == "IMPORTANCE" &&
		                (document.getElementsByName("ActS").item(i).getAttribute("value") == null
		                || document.getElementsByName("ActS").item(i).getAttribute("value") == "")) {
		                alert(strLang232);
		                return;
		            }
		        }
		
		        // EXCEPTION NODE
		        objRow3 = createNodeAndAppandNode(XmlDom, objNode, objRow3, "EXCEPTION");
		
		        for (var i = 0; i < document.getElementsByName("ExptS").length - 1; i++) {
		            curKind = document.getElementsByName("ExptS").item(i).getAttribute("RuleKind");
		            objRows = createNodeAndAppandNode(XmlDom, objRow3, objRows, "ROW");
		            createNodeAndAppandNodeText(XmlDom, objRows, objRow3Row, "EXPTKIND", curKind);
		            createNodeAndAppandNodeText(XmlDom, objRows, objRow3Row, "EXPTVALUE", document.getElementsByName("ExptS").item(i).getAttribute("value"));
		        }
		
		        Xmlhttp.open("POST", "/ezEmail/mailSetInboxRule.do?mode=NEW", false);
		        Xmlhttp.send(XmlDom);
		        if (!CrossYN()) {
		            if (Xmlhttp.responseXML.text == "OK") {
		                alert("<spring:message code='ezEmail.t134' />");
		                window.returnValue = "OK";
		                window.close();
		            }
		            else
		                alert(strLang233);
		        }
		        else if (CrossYN()) {
		            var result = Xmlhttp.responseText;
		            result = replaceAll(result, "<DATA><![CDATA[", "");
		            result = replaceAll(result, "]]></DATA>", "");
		            if (result == "OK") {
		                alert("<spring:message code='ezEmail.t134' />");
		                ReturnFunction("OK");
		                window.close();
		            }
		            else
		                alert(strLang233);
		        }
		    }
		    function closed() {
		        window.returnValue = "CANCEL";
		        window.close();
		    }
		    function replaceAll(pStrContent, pStrOrg, pStrRep) {
		        return pStrContent.split(pStrOrg).join(pStrRep);
		    }
		    function MakeXmlNode(xmldoc, root, key, value) {
		        var childNode = xmldoc.createElement(key);
		        try {
		            var cDataNode = xmldoc.createCDATASection(String(value));
		            childNode.appendChild(cDataNode);
		        }
		        catch (e) {
		            childNode.text = String(value);
		        }
		        root.appendChild(childNode);
		    }
		    function CheckName(name, emailaddress) {
		        var pRtnVal = emailaddress;
		        if (name != "") {
		            pRtnVal = name + " &lt;" + emailaddress + "&gt;";
		        }
		
		        return pRtnVal;
		    }
		    function MakeXMLString(pStr) {
		        pStr = ReplaceText(pStr, "&", "&amp;");
		        pStr = ReplaceText(pStr, "<", "&lt;");
		        pStr = ReplaceText(pStr, ">", "&gt;");
		        return pStr;
		    }
		    function open_userinfo(cn) {
		        var feature = "height=500px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 500);
		        window.open("/ezCommon/showPersonInfo.do?id=" + cn, "", feature);
		    }
		</script>
	</head>
	<body class="popup" style="background-color:#ffffff;">
        <div id="menu">
          <ul>
            <li><span onClick="New_InboxRule()"><spring:message code='ezEmail.t804' /></span></li>
          </ul>
        </div>
        <div id="close">
          <ul>
            <li><span onClick="closed();"><spring:message code='ezEmail.t63' /></span></li>
          </ul>
        </div>
	    <div style="border:1px solid #dbdbda;width:585px;height:475px;overflow-y:auto;margin:5px 5px 5px 5px;">
		    <div style="margin-top:20px;margin-left:20px;">
			    <img src="/images/ImgIcon/rul-sml.gif" align="absmiddle"  height="16" style="margin-top:-3px;" hspace="2" /><span class="txt"><spring:message code='ezEmail.t812' /></span><p />
			    <span class="txt"><spring:message code='ezEmail.t813' /></span> <input type="text" style='width:80%;' id="RuleDisplayName" name="RuleDisplayName" /><p />
			    <span class="txt"><spring:message code='ezEmail.t814' /></span><br />
			    <div id="ConArea" name="ConArea" style="margin-top:8px;"></div>
			    <br />
			    <div id="mainmenu"><ul  id="tb_AddRuleCon"><li><span onclick='AddRule(ConArea);'><spring:message code='ezEmail.t815' /></span></li></ul></div>
			    <span class="txt" ><spring:message code='ezEmail.t816' /></span><br />
			    <div id="ActArea" name="ActArea" style="margin-top:8px;"></div>
			    <br />
			    <div id="mainmenu"><ul  id="tb_AddRuleAct"><li><span onclick='AddRule(ActArea);'><spring:message code='ezEmail.t815' /></span></li></ul></div>
			    <span class="txt" ><spring:message code='ezEmail.t842' /></span><br />
			    <div id="ExptArea" name="ExptArea" style="margin-top:8px;"></div>
			    <br />
			    <div id="mainmenu"><ul  id="tb_AddRuleExpt"><li><span onclick='AddRule(ExptArea);'><spring:message code='ezEmail.t815' /></span></li></ul></div>
			</div>
		</div>
	</body>
	<script type="text/javascript">
	    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	    selToggleList(document.getElementById("close"), "ul", "li", "0");
	</script>

	<div id="inboxRuleCon" name="inboxRuleCon" style="display:none;">
		<select name="Condition" class="select" onChange="Ruleselect(this)" style="margin-bottom:0px;" > 
		    <option value="NONE" selected><spring:message code='ezEmail.t817' /></option>
		    <option value="SENDER"><spring:message code='ezEmail.t818' /></option>
		    <option value="DOMAIN"><spring:message code='ezEmail.t829' /></option>
		    <option value="RECEIVER"><spring:message code='ezEmail.t819' /></option>
		    <option value="SUBJECT"><spring:message code='ezEmail.t820' /></option>
		    <option value="BODY"><spring:message code='ezEmail.t821' /></option>
		    <option value="SUBJECTORBODY"><spring:message code='ezEmail.t835' /></option>
		    <option value="ALLMESSAGES"><spring:message code='ezEmail.t836' /></option>
		</select><span id="ConS" name="ConS" style="display:inline-block;width:230px;border:0px solid #dbdbda;height:20px;margin-left:8px;margin-top:0px;text-overflow:ellipsis; overflow:hidden;cursor:pointer;vertical-align:middle;color:#6495ED;font-weight:bold;"></span>
	</div>
	<div id="Ruledsc1" name="Ruledsc2"></div>
	<div id="inboxRuleAct" name="inboxRuleCon"  style="display:none;">
		<select name="Action" class="select" onchange="Actselect(this);"> 
			<option value="NONE" selected><spring:message code='ezEmail.t817' /></option>
			<option value="MOVE"><spring:message code='ezEmail.t822' /></option>
			<option value="DELETE"><spring:message code='ezEmail.t168' /></option>
			<option value="REDIRECTION"><spring:message code='ezEmail.t837' /></option>
			<option value="COPY"><spring:message code='ezEmail.t838' /></option>
			<!-- <option value="READ"><spring:message code='ezEmail.t839' /></option> -->
			<option value="IMPORTANCE"><spring:message code='ezEmail.t840' /></option>
			<!-- <option value="FORWARD"><spring:message code='ezEmail.t841' /></option> -->
		</select><span id="ActS" name="ActS" style="display:inline-block;width:230px;height:20px;border:0px solid #dbdbda;margin-left:8px;margin-top:0px;text-overflow:ellipsis; overflow:hidden;cursor:pointer;vertical-align:middle;color:#6495ED;font-weight:bold;"></span>
		<select id="ImportanceSel" name="ImportanceSel" class="select" onchange="ImSelect(this)" style="width:auto; display:none;">
			<option value="NONE" selected><spring:message code='ezEmail.t359' /><spring:message code='ezEmail.t488' /></option>
			<option value="LOW"><spring:message code='ezEmail.t360' /></option>
			<option value="NORMAL"><spring:message code='ezEmail.t361' /></option>
			<option value="HIGH"><spring:message code='ezEmail.t362' /></option>
		</select>
	</div>
	<div id="inboxRuleExpt" name="inboxRuleExpt" style="display:none;">
		<select name="Exception" class="select" onchange="Ruleselect(this);">
			<option value="NONE" selected><spring:message code='ezEmail.t99000009' /></option>
			<!--<option value="SENDER"><spring:message code='ezEmail.t818' /></option>-->
			<option value="DOMAIN"><spring:message code='ezEmail.t829' /></option>
			<option value="RECEIVER"><spring:message code='ezEmail.t819' /></option>
			<option value="SUBJECT"><spring:message code='ezEmail.t820' /></option>
			<option value="BODY"><spring:message code='ezEmail.t821' /></option>
			<option value="SUBJECTORBODY"><spring:message code='ezEmail.t835' /></option>
		</select><span id="ExptS" name="ExptS" style="width:230px;height:20px;border:0px solid #dbdbda;margin-left:8px;margin-top:0px;text-overflow:ellipsis; overflow:hidden;cursor:pointer;vertical-align:middle;color:#6495ED;font-weight:bold;"></span>
	</div>
	<div  id="inboxRuleConbtn1" name="inboxRuleConbtn1" style="position:absolute; left:100px; top:65px;border:3px solid #5093d8;width:70%;background-color:#F9F9F9; display:none;">
		<br>
		<span style="background-color:#f2f2f2;width:100%; height:30px; padding:8px 0 0 5px; margin:0 10px 0 10px;" class="txt"id="inboxRuleConbtn1comment" name="inboxRuleConbtn1comment"></span>
		<table style="width:100%;border:0;border-collapse:collapse; border-spacing:0;padding:0px;" >
			<tr>
				<td style="width:60%;padding:10px 0 0 10px" id="ReceiverSelecttd" name="ReceiverSelecttd">
					<INPUT type="text" id="inboxRuleCon1" name="inboxRuleCon1" style="width:100%" onKeyDown="event_keyDown(event);">
				</td>
				<td style="width:60%;padding:12px 10px 0 8px;">
					<div >
						<img src="/images/email/cntct.gif" align="absmiddle" style="margin-left:5px;cursor:pointer;display:none;" id="ReceiverSelect" name="ReceiverSelect" onclick="SelectReceiver_onClick();" />
						<a class="imgbtn"><span onClick="pop_addcon();" id="inputBtn"><spring:message code='ezEmail.t308' /></span></a>
						<a class="imgbtn"><span onClick="pop_delete();"><spring:message code='ezEmail.t95' /></span></a>
					</div>
				</td>
			</tr>
		</table>
		<div style="border:1px solid #dddddd; margin:10px 10px 10px 10px; padding:10px 10px 10px 10px; background-color:#f2f2f2;">
			<div id="Conitems" name="Conitems" style="border:1px solid #dbdbda;width:370px;height:200px;overflow-y:auto;overflow-x:hidden;text-overflow:ellipsis;background-color:#ffffff;">
			</div>
		</div>
		<div id="mainmenu" style="margin-left:150px;">
			<ul id="tb_Parent">
				<li><span onClick="pop_confrim();"><img src="/images/ImgIcon/mtg-accept.png" height="16" style="margin-top:-3px;text-align:center"  /><spring:message code='ezEmail.t38' /></span></li>
				<li><span onClick="pop_cancel();"><img src="/images/ImgIcon/mtg-decline.png" height="16" style="margin-top:-3px;text-align:center;"  /><spring:message code='ezEmail.t39' /></span></li>
			</ul>
		</div>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</html>
