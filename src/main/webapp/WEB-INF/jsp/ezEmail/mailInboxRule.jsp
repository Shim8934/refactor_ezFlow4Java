<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>mail_filter</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript">
		    var Xmlhttp = null;
		    document.onselectstart = function () { return false; };
		    function window_onload() {
		        //alert(navigator.userAgent);
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        Xmlhttp = createXMLHttpRequest();
		        Xmlhttp.open("POST", "/ezEmail/mailGetInboxRule.do", true);
		        Xmlhttp.onreadystatechange = event_Get_listComplite;
		        Xmlhttp.send("");
		    }
		    function Rule_Reload() {
		        document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td style='text-align:center;'><img src='/images/email/progress_img.gif' /></td></tr></table>";
		        _RowObject = null;
		        document.getElementById("ContentDescription").innerHTML = "";
		        Xmlhttp = createXMLHttpRequest();
		        Xmlhttp.open("POST", "/ezEmail/mailGetInboxRule.do", true);
		        Xmlhttp.onreadystatechange = event_Get_listComplite;
		        Xmlhttp.send("");  
		    }
		    function event_Get_listComplite() {
		        if (Xmlhttp == null || Xmlhttp.readyState != 4)
		            return;
		        if (Xmlhttp.status >= 200 && Xmlhttp.status < 300) {
		            MakeRuleList();
		        }
		    }
		    function MakeRuleList() {
		        var _html = "";
		        try {
		            var XmlNode = "";
		            var XmlNodeText = "";
		            if (navigator.userAgent.indexOf("MSIE") == -1) {
		                XmlNodeText = Xmlhttp.responseText;
		                XmlNode = loadXMLString(XmlNodeText);
		                var countValue = 0;
		
		                _html = "<table class='mainlist' style='width:100%;'>";
		                if (XmlNode.getElementsByTagName("ROWS").length > 0) {
		                    for (var i = 0; i < XmlNode.getElementsByTagName("ROWS").length; i++) {
		
		                        var _itemid = XmlNode.getElementsByTagName("ROWS").item(i).getElementsByTagName("ID").item(0).textContent;
		                        var _name = XmlNode.getElementsByTagName("ROWS").item(i).getElementsByTagName("NAME").item(0).textContent;
		                        var _Use = XmlNode.getElementsByTagName("ROWS").item(i).getElementsByTagName("USE").item(0).textContent;
		                        var _priority = XmlNode.getElementsByTagName("ROWS").item(i).getElementsByTagName("PRIORITY").item(0).textContent;
		                        var _con = "";
		                        var _conval = "";
		
		                        var conPath = XmlNode.getElementsByTagName("ROWS").item(i).getElementsByTagName("CONDITION").item(0);
		
		                        for (var j = 0; j < conPath.getElementsByTagName("KIND").length; j++) {
		                            _con += "#" + conPath.getElementsByTagName("KIND").item(j).textContent;
		                            _conval += "#" + conPath.getElementsByTagName("VALUES").item(j).textContent;
		                        }
		
		                        _con = _con.substring(1, _con.length);
		                        _conval = _conval.substring(1, _conval.length);
		
		                        var _act = "";
		                        var _actfid = "";
		                        var _actfnm = "";
		                        var _actval = "";
		                        
		
		                        var actPath = XmlNode.getElementsByTagName("ROWS").item(i).getElementsByTagName("ACTION").item(0);
		                        var actfcnt = 0;
		
		                        for (var j = 0 ; j < actPath.getElementsByTagName("KIND").length; j++) {
		                            curkind = actPath.getElementsByTagName("KIND").item(j).textContent;
		                            
		                            if (curkind == "MOVE" || curkind == "COPY") {
		                                _act += "#" + curkind;
		                                _actfid += "#" + actPath.getElementsByTagName("FOLDERID").item(actfcnt).textContent;
		                                _actfnm += "#" + actPath.getElementsByTagName("FOLDERNAME").item(actfcnt).textContent;
		                                _actval += "#0";
		                                actfcnt++;
		                            }
		                            else if (curkind == "REDIRECTION" || curkind == "FORWARD" || curkind == "IMPORTANCE") {
		                                _act += "#" + curkind;
		                                _actval += "#" + actPath.getElementsByTagName("VALUES").item(j).textContent;
		                            }
		                            else if (curkind == "READ" || curkind == "DELETE") {
		                                _act += "#" + curkind;
		                                _actval += "#0";
		                            }
		                            else {
		                                _act += "#NONE";
		                                _actval += "#0";
		                            }
		                        }
		
		                        if (actPath.getElementsByTagName("KIND").length == 0) {
		                            _act += "#NONE";
		                            _actval += "#0";
		                        }
		
		                        _act = _act.substring(1, _act.length);
		                        _actfid = _actfid.substring(1, _actfid.length);
		                        _actfnm = _actfnm.substring(1, _actfnm.length);
		                        _actval = _actval.substring(1, _actval.length);
		
		                        var _expt = "";
		                        var _exptval = "";
		
		                        var exptPath = XmlNode.getElementsByTagName("ROWS").item(i).getElementsByTagName("EXCEPTION").item(0);
		
		                        for (var j = 0; j < exptPath.getElementsByTagName("KIND").length; j++) {
		                            _expt += "#" + exptPath.getElementsByTagName("KIND").item(j).textContent;
		                            _exptval += "#" + exptPath.getElementsByTagName("VALUES").item(j).textContent;
		                        }
		
		                        _expt = _expt.substring(1, _expt.length);
		                        _exptval = _exptval.substring(1, _exptval.length);
		
		                        _html += "<tr _itemid='" + _itemid + "' _name='" + MakeXMLString(_name).replace(/\'/g, "&#039;") + "' _priority='" + _priority + "' _con='" + _con + "' _conval='" + _conval + "' _act='" + _act + "' _actfid='" + _actfid + "'  _actfnm='" + _actfnm + "' _actval='" + _actval + "' _expt='" + _expt + "' _exptval='" + _exptval + "'  onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
		                        //alert("itemid='" + _itemid + "' _name='" + MakeXMLString(_name).replace(/\'/g, "&#039;") + "' _priority='" + _priority + "' _con='" + _con + "' _conval='" + _conval + "' _act='" + _act + "' _actfid='" + _actfid + "'  _actfnm='" + _actfnm + "' _actval='" + _actval + "' _expt='" + _expt + "' _exptval='" + _exptval + "'");
		                        
		                        if (_act.indexOf("NONE") != -1) {
		                            if (_Use == "Y")
		                                _html += "<td style='width:8%;padding-left:5px;'><input type='checkbox' disabled=disabled _itemid='" + _itemid + "' onclick='event_statuschange(this);' checked></td>";
		                            else
		                                _html += "<td style='width:8%;padding-left:5px;'><input type='checkbox' disabled=disabled _itemid='" + _itemid + "' onclick='event_statuschange(this);'></td>";
		
		                            _html += "<td style='width:60%;color:gray;'>" + MakeXMLString(_name) + "</td>";
		                        }
		                        else {
		                            if (_Use == "Y")
		                                _html += "<td style='width:8%;padding-left:5px;'><input type='checkbox' _itemid='" + _itemid + "' onclick='event_statuschange(this);' checked></td>";
		                            else
		                                _html += "<td style='width:8%;padding-left:5px;'><input type='checkbox' _itemid='" + _itemid + "' onclick='event_statuschange(this);'></td>";
		
		                            _html += "<td style='width:60%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" + MakeXMLString(_name) + "</td>";
		                        }
		                        /*
		                        if (_Act == "DELETE")
		                            _html += "<td style='width:32%;text-align:center;color:Red;'> " + strLang201 + "</td>";
		                        else
		                        */
		                            _html += "<td style='width:32%;text-align:center; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" + _actfnm.replace("#", ", ") + "</td>";
		                        
		                    
		                        _html += "</tr></html>";
		                        
		
		                        if (SelectNodes(XmlNode, "ROWS").length == 0)
		                            document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'> " + strLang202 + "</td></tr></table>";
		                        else
		                            document.getElementById("contentlist").innerHTML = _html;
		                    }
		                }
		                else {
		                    document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang202 + "</td></tr></table>";
		                }
		
		            }
		        }
		        catch (e) {
		            document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang202 + "</td></tr></table>";
		
		        }
		        Xmlhttp = null;
		    }
		    function event_Mover(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(1).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
		        }
		    }
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
		        }
		    }
		    var _RowObject = null;
		    function event_click(obj) {
		        if (_RowObject != null) {
		            _RowObject.childNodes.item(0).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(1).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(2).style.backgroundColor = "#ffffff";
		        }
		            
		        _RowObject = obj;
		        obj.childNodes.item(0).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(1).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(2).style.backgroundColor = "#DBE1E7";
		        MakeDescription();
		    }
		    function MakeDescription() {
		        var _html = "";
		        var _con = "";
		        var _act = "";
		        var _expt = "";
		
		        var con = _RowObject.getAttribute("_con").split('#');
		        var conval = _RowObject.getAttribute("_conval").split('#');
		        var act = _RowObject.getAttribute("_act").split('#');
		        var actfid = _RowObject.getAttribute("_actfid").split('#');
		        var actfnm = _RowObject.getAttribute("_actfnm").split('#');
		        var actval = _RowObject.getAttribute("_actval").split('#');
		        var expt = _RowObject.getAttribute("_expt").split('#');
		        var exptval = _RowObject.getAttribute("_exptval").split('#');
		
		        // CONDITION
		        _html += "<span style='font-weight:bold;color:#3B7CBE;'>" + strLang203 + "</span><p/>";
		
		        for (var i = 0; i < con.length; i++) {
		            switch (con[i]) {
		                case "SENDER":
		                    _con += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang204 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(conval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                    break;
		                case "RECEIVER":
		                    _con += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang205 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(conval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                    break;
		                case "SUBJECT":
		                    _con += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang207 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(conval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                    break;
		                case "BODY":
		                    _con += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang208 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(conval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                    break;
		                case "SUBJECTORBODY":
		                    _con += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang339 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(conval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                    break;
		                case "DOMAIN":
		                    _con += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang307 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(conval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                    break;
		            }
		        }
		        // ALL MESSAGES
		        if (con[0] == "" || con[0] == null) {
		            _con += "<p/><div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'><span style='color:red;'>" + strLang340 + "</span></div>";
		        }
		
		        _html += "<span>" + _con + "</span>";
		
		        // ACTION
		        _html += "<p/><span style='font-weight:bold;color:#3B7CBE;'>" + strLang211 + "</span><p/>";
		
		        var fcnt = 0;
		        var isNONE = false;
		        for (var i = 0; i < act.length; i++) {
		            switch (act[i]) {
		                case "MOVE":
		                    _act += "<div><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>\"<span style='color:red;'>" + actfnm[fcnt] + "</span>\" " + strLang213 + "</div>";
		                    fcnt++;
		                    break;
		                case "COPY":
		                    _act += "<div><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>\"<span style='color:red;'>" + actfnm[fcnt] + "</span>" + strLang342 + "</div>";
		                    fcnt++;
		                    break;
		                case "READ":
		                    _act += "<div><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'><span style='color:red;'>" + strLang341 + "</span></div>";
		                    break;
		                case "DELETE":
		                    _act += "<div><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'><span style='color:red;'>" + strLang212 + "</span></div>";
		                    break;
		                case "FORWARD":
		                    if (actval[i].indexOf(" </o=") == -1) {
		                        _act += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang344 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(actval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"<br/>\"<span style='color:red;'>") + "</span>\"</div>";
		                    }
		                    else {
		                        _act += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang344 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(actval[i].substring(0, actval[i].indexOf(" </o="))) + "</span>\"</div>";
		                    }
		                    break;
		                case "REDIRECTION":
		                    if (actval[i].indexOf(" </o=") == -1) {
		                        _act += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang345 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(actval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"<br/>\"<span style='color:red;'>") + "</span>\"</div>";
		                    }
		                    else {
		                        _act += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang345 + " </span><br/>\"<span style='color:red;'>" +
		                     MakeXMLString(actval[i].substring(0, actval[i].indexOf(" </o="))) + "</span>\"</div>";
		                    }
		                    break;
		                case "IMPORTANCE":
		                    _act += "<div><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang343;
		                    switch (actval[i]) {
		                        case "LOW":
		                            _act += "<span style='color:red;'>" + strLang346 + "</span></div>";
		                            break;
		                        case "NORMAL":
		                            _act += "<span style='color:red;'>" + strLang347 + "</span></div>";
		                            break;
		                        case "HIGH":
		                            _act += "<span style='color:red;'>" + strLang348 + "</span></div>";
		                            break;
		                    }
		                    break;
		                case "NONE":
		                    //_html = "<span style='color:red;'>" + strLang242 + "</span>";
		                    isNONE = true;
		                    break;
		            }
		        }
		
		        _html += "<span>" + _act + "</span>";
		
		        // EXCEPTION
		        if (_RowObject.getAttribute("_expt") != "") {
		            _html += "<p/><span style='font-weight:bold;color:#3B7CBE;'>" + strLang349 + "</span><p/>";
		
		            for (var i = 0; i < expt.length; i++) {
		                switch (expt[i]) {
		                    case "SENDER":
		                        _expt += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang204 + " </span><br/>\"<span style='color:red;'>" +
		                         MakeXMLString(exptval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                        break;
		                    case "RECEIVER":
		                        _expt += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang205 + " </span><br/>\"<span style='color:red;'>" +
		                         MakeXMLString(exptval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                        break;
		                    case "SUBJECT":
		                        _expt += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang207 + " </span><br/>\"<span style='color:red;'>" +
		                         MakeXMLString(exptval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                        break;
		                    case "BODY":
		                        _expt += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang208 + " </span><br/>\"<span style='color:red;'>" +
		                         MakeXMLString(exptval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                        break;
		                    case "SUBJECTORBODY":
		                        _expt += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang339 + " </span><br/>\"<span style='color:red;'>" +
		                         MakeXMLString(exptval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                        break;
		                    case "DOMAIN":
		                        _expt += "<div><span><img src='/images/ImgIcon/dot.gif' align='absmiddle' hspace='5'>" + strLang307 + " </span><br/>\"<span style='color:red;'>" +
		                         MakeXMLString(exptval[i].replace(/;/g, "_replacesemiconlon_")).replace(/_replacesemiconlon_/g, "</span>\"  " + strLang210 + "<br/>" + " \"<span style='color:red;'>") + "</span>" + strLang206 + "</div>";
		                        break;
		                }
		            }
		
		            _html += "<span>" + _expt + "</span>";
		        }
		        
		        if (isNONE)
		            _html = "<span style='color:red;'>" + strLang242 + "</span>";
		
		        document.getElementById("ContentDescription").innerHTML = _html;
		    }
		    var mail_newinboxrule_cross_dialogArguments = new Array();
		    function New_InboxRule() {
		        mail_newinboxrule_cross_dialogArguments[1] = New_InboxRule_Complete;
		        var OpenWin = window.open("/ezEmail/mailNewInboxRule.do", "mail_NewInboxRule_cross", GetOpenWindowfeature(620, 550));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function New_InboxRule_Complete(newWin) {
		        try {
		            if (newWin == "OK") {
		                document.getElementById("contentlist").innerHTML = "";
		                document.getElementById("ContentDescription").innerHTML = "";
		                Rule_Reload();
		            }
		        } catch (e) {
		
		        }
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
		    function event_dbclick(obj) {
		        _RowObject = obj;
		        Detail_InboxRule();
		    }
		    var mail_detailinboxrule_cross_dialogArguments = new Array();
		    function Detail_InboxRule() {
		    
		        if (_RowObject == null) {
		            alert(strLang214);
		            return;
		        }
		        else if (_RowObject.getAttribute("_act").indexOf("NONE") != -1 ) {
		            alert(strLang242);
		            return;
		        }
		        mail_detailinboxrule_cross_dialogArguments[0] = _RowObject;
		        mail_detailinboxrule_cross_dialogArguments[1] = New_InboxRule_Complete;
		        var OpenWin = window.open("/ezEmail/mailDetailInboxRule.do", "mail_NewInboxRule_cross", GetOpenWindowfeature(620, 550));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function Detail_InboxRule_Complete(newWin) {
		        try {
		            if (newWin == "OK") {
		                document.getElementById("contentlist").innerHTML = "";
		                document.getElementById("ContentDescription").innerHTML = "";
		                Rule_Reload();
		            }
		        } catch (e) {}
		    }
		    var XmlhttpDelete;
		    function event_DeleteRule() {
		        if (_RowObject == null) {
		            alert(strLang214);
		            return;
		        }
		        XmlhttpDelete = createXMLHttpRequest();
		        XmlhttpDelete.open("POST", "/ezEmail/mailDeleteInboxRule.do", true);
		        XmlhttpDelete.onreadystatechange = event_DeleteRuleComplete;
		        XmlhttpDelete.send("<DATA><RULEID>" + _RowObject.getAttribute("_itemid") + "</RULEID></DATA>");
		        
		    }
		    function event_DeleteRuleComplete() {
		        if (XmlhttpDelete == null || XmlhttpDelete.readyState != 4)
		            return;
		        if (XmlhttpDelete.status >= 200 && XmlhttpDelete.status < 300) {
		            if (XmlhttpDelete.responseXML.getElementsByTagName("DATA")[0].textContent == "OK") {
		                alert(strLang215);
		                document.getElementById("ContentDescription").innerHTML = "";
		                _RowObject = null;
		                Rule_Reload();
		            }
		            else
		                alert(strLang216);
		
		            XmlhttpDelete = null;
		        }
		    }
		    var XmlhttpStatus;
		    function event_statuschange(obj) {
		
		        var Xmldom = createXmlDom();
		        var objNode;
		        createNodeInsert(Xmldom, objNode, "DATA");
		
		        //var root = Xmldom.createNode("1", "DATA", "");
		        //Xmldom.appendChild(root);
		        createNodeAndInsertText(Xmldom, objNode, "RULEID", obj.getAttribute("_itemid"));
		        //MakeXmlNode(Xmldom, root, "RULEID", obj._itemid);
		
		
		        if(obj.checked)
		            //MakeXmlNode(Xmldom, root, "STATUS", "Y");
		            createNodeAndInsertText(Xmldom, objNode, "STATUS", "Y");
		        else
		            //MakeXmlNode(Xmldom, root, "STATUS", "N");
		            createNodeAndInsertText(Xmldom, objNode, "STATUS", "N");
		
		        XmlhttpStatus = createXMLHttpRequest(); 
		        XmlhttpStatus.open("POST", "/ezEmail/mailSetRuleStatus.do", true);
		        XmlhttpStatus.onreadystatechange = event_statusComplite;
		        XmlhttpStatus.send(Xmldom);
		    }
		    function event_statusComplite() {
		        if (XmlhttpStatus == null || XmlhttpStatus.readyState != 4)
		            return;
		        if (XmlhttpStatus.status >= 200 && XmlhttpStatus.status < 300) {
		            if (XmlhttpStatus.responseXML.getElementsByTagName("DATA")[0].textContent == "OK")
		            { }
		            else
		                alert(strLang217);
		            
		            XmlhttpStatus = null;
		        }
		    }
		    function event_ChangePriority(A_itemid, A_priority, B_itemid, B_priority) {
		        var Xmldom = createXmlDom();
		        var objNode;
		        createNodeInsert(Xmldom, objNode, "DATA");
		        createNodeAndInsertText(Xmldom, objNode, "ARULEID", A_itemid);
		        createNodeAndInsertText(Xmldom, objNode, "APRIORITY", B_priority);
		        createNodeAndInsertText(Xmldom, objNode, "BRULEID", B_itemid);
		        createNodeAndInsertText(Xmldom, objNode, "BPRIORITY", A_priority);
		        var XmlhttpPriority = createXMLHttpRequest();
		        XmlhttpPriority.open("POST", "/ezEmail/mailSetRulePriority.do", false);
		        XmlhttpPriority.send(Xmldom);
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            if (XmlhttpPriority.responseXML.text == "OK") {
		                XmlhttpPriority = null;
		                return true;
		            }
		            else {
		                alert(strLang217);
		                XmlhttpPriority = null;
		                return false;
		            }
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            var result = XmlhttpPriority.responseText;
		
		            result = replaceAll(result, "<DATA><![CDATA[", "");
		            result = replaceAll(result, "]]></DATA>", "");
		
		            if (result == "OK") {
		                XmlhttpPriority = null;
		                return true;
		            }
		            else {
		                alert(strLang217);
		                XmlhttpPriority = null;
		                return false;
		            };
		        }
		        if (XmlhttpPriority.responseXML.text == "OK") {
		            XmlhttpPriority = null;
		            return true;
		        }
		        else {
		            alert(strLang217);
		            XmlhttpPriority = null;
		            return false;
		        }
		    }
		    function replaceAll(pStrContent, pStrOrg, pStrRep) {
		        return pStrContent.split(pStrOrg).join(pStrRep);
		    }
		    function Priority_UP() {
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            if (_RowObject == null) {
		                alert(strLang214);
		                return;
		            }
		            var ChangeRow = null;
		            for (var i = 0; i < _RowObject.parentNode.childNodes.length; i++) {
		                if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
		                    if (i == 0) {
		                        return;
		                    }
		                    ChangeRow = i - 1;
		                    if (event_ChangePriority(_RowObject.getAttribute("_itemid"), _RowObject.getAttribute("_priority"), _RowObject.parentNode.children.item(ChangeRow).getAttribute("_itemid"), _RowObject.parentNode.children.item(ChangeRow).getAttribute("_priority")))
		                        swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
		                    break;
		                }
		            }
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            if (_RowObject == null) {
		                alert(strLang214);
		                return;
		            }
		            var ChangeRow = null;
		            for (var i = 0; i < _RowObject.parentNode.children.length; i++) {
		                if (_RowObject.parentNode.children.item(i) == _RowObject) {
		                    if (i == 0) {
		                        return;
		                    }
		                    ChangeRow = i - 1;
		                    if (event_ChangePriority(_RowObject.getAttribute("_itemid"), _RowObject.getAttribute("_priority"), _RowObject.parentNode.children.item(ChangeRow).getAttribute("_itemid"), _RowObject.parentNode.children.item(ChangeRow).getAttribute("_priority"))) {
		                        swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
		                    }
		                    break;
		                }
		            }
		        }
		    }
		     function swapNodes(item1, item2) {
		         var itemtmp = item1.cloneNode(1);
		         var parent = item1.parentNode;
		         item2 = parent.replaceChild(itemtmp, item2);
		         item1.setAttribute("_priority", item2.getAttribute("_priority"));
		         item2.setAttribute("_priority", itemtmp.getAttribute("_priority"));
		         parent.replaceChild(item2, item1);
		         parent.replaceChild(item1, itemtmp);
		         itemtmp = null;
		     } 
		     function Priority_DOWN() {
		         if (_RowObject == null) {
		             alert(strLang214);
		             return;
		         }
		         var ChangeRow = null;
		         for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
		             if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
		                 if (i == _RowObject.parentNode.childNodes.length - 1) {
		                     return;
		                 }
		                 ChangeRow = i + 1;
		                 if (event_ChangePriority(_RowObject.getAttribute("_itemid"), _RowObject.getAttribute("_priority"), _RowObject.parentNode.children.item(ChangeRow).getAttribute("_itemid"), _RowObject.parentNode.children.item(ChangeRow).getAttribute("_priority")))
		                     swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
		                 break;
		             }
		         }
		     }
		     function MakeXMLString(pStr) {
		         pStr = ReplaceText(pStr, "&", "&amp;");
		         pStr = ReplaceText(pStr, "<", "&lt;");
		         pStr = ReplaceText(pStr, ">", "&gt;");
		         return pStr;
		     }
		</script>
		<script>
		    window.onload = window_onload;
		</script>
	</head>
	<body style="margin-left:10px;margin-right:10px;"> 
		<form method="post" runat="server"> 
			<br>
			<span class="txt">&nbsp;<spring:message code='ezEmail.t800' /></span><br />
			<span class="txt">&nbsp;<spring:message code='ezEmail.t801' /></span><br />
			<span class="txt">&nbsp;<spring:message code='ezEmail.t802' /></span><br />
			<span class="txt">&nbsp;<spring:message code='ezEmail.t803' /></span><br />
			
			<span class="txt">&nbsp;*&nbsp;<img src="/images/ImgIcon/prev.gif"   height="16" style="margin-top:-3px;vertical-align:middle;text-align:center;" alt="<spring:message code='ezEmail.t833' />"/><img src="/images/ImgIcon/next.gif" align="absmiddle"  height="16" style="margin-top:-3px;" alt="<spring:message code='ezEmail.t834' />" /><spring:message code='ezEmail.t807' /></span><br /><br /><br />
		    <div id="mainmenu">
		        <ul id="tb_Parent">
		          <li><span onclick="New_InboxRule();"><img src="/images/ImgIcon/rul-sml.gif"  style="margin-top:-2px;" /><spring:message code='ezEmail.t804' /></span></li>
		          <li><span onclick="Detail_InboxRule();"><img src="/images/ImgIcon/options.gif"   style="margin-top:-2px;"  /><spring:message code='ezEmail.t805' /></span></li>
		          <li><span onclick="event_DeleteRule();"><img src="/images/ImgIcon/delete.gif"   style="margin-top:-2px;"  /><spring:message code='ezEmail.t95' /></span></li>
		          <li><span onclick="Rule_Reload();"><img src="/images/ImgIcon/recur.gif"    style="margin-top:-2px;"  /><spring:message code='ezEmail.t515' /></span></li>
		          <li><span onclick="Priority_UP();"><img src="/images/ImgIcon/prev.gif"  style="margin-top:-2px;" alt="<spring:message code='ezEmail.t833' />"/></span></li>
		          <li><span onclick="Priority_DOWN();"><img src="/images/ImgIcon/next.gif"  style="margin-top:-2px;" alt="<spring:message code='ezEmail.t834' />" /></span></li>
		          </ul>        
			</div>
			<table style="width:750px;height:385px;" border="0">
				<tr>
					<td>
						<div style="border:1px solid #dbdbda;width:435px;height:385px;">
							<table class="mainlist" style="width:100%;">
			                    <tr>
			                        <td style="width:8%;background-color:#F3F3F3;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;"><span><spring:message code='ezEmail.t808' /></span></td>
			                        <td style="width:60%;background-color:#F3F3F3;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;"><span style="padding-left:10px;"><spring:message code='ezEmail.t809' /></span></td>
			                        <td style="width:32%;background-color:#F3F3F3;text-align:center;border-bottom:2px solid #dbdbda;"><span><spring:message code='ezEmail.t810' /></span></td>
			                    </tr>
							</table>
							<div id="contentlist" name="contentlist" style="height:365px;overflow-y:auto;">
				                <table class="mainlist" style="width:100%;">
				                    <tr>
				                        <td style="text-align:center;">
				                           <img src="/images/email/progress_img.gif" />
				                        </td>
				                    </tr>
				                </table>
							</div>
						</div>
					</td>
					<td>
						<div style="border:1px solid #dbdbda;width:315px;height:385px;overflow-y:auto;margin:5px 5px 5px 5px;">
							<div id="ContentDescription" style="margin-top:1px;margin:5px 5px 5px 5px;">
			                </div>
						</div>
					</td>
				</tr>
			</table>
		</form> 
	</body>
</html>

