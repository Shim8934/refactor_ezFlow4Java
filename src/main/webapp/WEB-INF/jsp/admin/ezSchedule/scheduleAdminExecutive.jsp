<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code='ezSchedule.t4003' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript">
        var xmlhttp = createXMLHttpRequest();
        var isToggle = false;
        var selectedCompanyID = "";
        var selectedCompanyName = "";
        
        document.onselectstart = function () {
            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
                return false;
            else
                return true;
        };

        window.onload = function () {
            COMPANY_CHANGE();
        }

        function COMPANY_CHANGE() {
            isToggle = false;
            document.getElementById("p_toggle").style.display = "";
            document.getElementById("p_up").style.display = "none";
            document.getElementById("p_down").style.display = "none";
            document.getElementById("p_save").style.display = "none";
            document.getElementById("p_cancel").style.display = "none";
            
            schedule_get_executiveList();
        }

        function schedule_get_executiveList() {
            selectedCompanyID = $("#ListCompany").val();
            selectedCompanyName = $('#ListCompany option:selected').text();
            
            $.ajax({
                url : "/admin/ezSchedule/scheduleGetExecutiveList.do",
                type : "GET",
                dataType : "xml",
                async : true,
                cache : false,
                data : {companyID : selectedCompanyID,
                    companyName : selectedCompanyName
                },
                success : function(text){
                    MakeSliderList(text);
                }
            });
        }

        function MakeSliderList(text) {
            var _html = "";
            try {
                var XmlNode = text;
                var rows = Array.from(SelectNodes(XmlNode, "DATA/ROW"));
                var countValue = 0;
                
                rows.sort((a, b) => {
                    var priorityA = parseInt(getNodeText(GetElementsByTagName(a, "PRIORITY")[0]), 10);
                    var priorityB = parseInt(getNodeText(GetElementsByTagName(b, "PRIORITY")[0]), 10);
                    return priorityA - priorityB; 
                });
                
                _html = "<table class='mainlist' style='width:100%;'>";
                
                if (rows.length > 0) {
                    for (var i = 0; i < rows.length; i++) {
                        var _Value;
                        _html += "<tr id = '" + getNodeText(GetElementsByTagName(rows[i], "CN")[0])
                            + "'companyid = '" + selectedCompanyID
                            + "'priority = '" + getNodeText(GetElementsByTagName(rows[i], "PRIORITY")[0])
                            + "'usage = '" + getNodeText(GetElementsByTagName(rows[i], "USAGE")[0]).substring(0, 10)
                            + "'createuser = '" + getNodeText(GetElementsByTagName(rows[i], "CREATEUSER")[0])
                            + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);' style='cursor: pointer;'>";
                        
                        _html += "<td style='width:10%;'><span class='spanText'>" + getNodeText(GetElementsByTagName(rows[i], "PRIORITY")[0]) + "</span></td>";
                        _html += "<td style='width:20%;'><span class='spanText'>" + getNodeText(GetElementsByTagName(rows[i], "DISPLAYNAME")[0]) + "</span></td>";
                        _html += "<td style='width:20%;'><span class='spanText'>" + getNodeText(GetElementsByTagName(rows[i], "DEPTNAME")[0]) + "</span></td>";
                        _html += "<td style='width:10%;'><span class='spanText'>" + getNodeText(GetElementsByTagName(rows[i], "USAGE")[0]) + "</span></td>";
                        _html += "<td style='width:20%;'><span class='spanText'>" + getNodeText(GetElementsByTagName(rows[i], "CREATEUSERNAME")[0]) + "</span></td>";
                        _html += "<td style='width:20%;'><span class='spanText'>" + getNodeText(GetElementsByTagName(rows[i], "LASTUPDATE")[0]) + "</span></td>";

                        _html += "</tr>";
                        _html += "</html>";
                        document.getElementById("contentlist").innerHTML = _html;
                    }
                }
                else {
                    document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td style='text-align:center; cursor:default;'><span class='spanText'>" + strLang263 + "</span></td></tr></table>";
                }
            }
            catch (e) {
                document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td style='text-align:center; cursor:default;'><span class='spanText'>" + strLang263 + "</td></tr></table>";
            }
            xmlhttp = null;
        }

        function event_Mover(obj) {
            if (obj != _RowObject) {
                for (var i = 0; i < obj.childNodes.length; i++) {
                    obj.childNodes.item(i).style.backgroundColor = "#EDEDED";
                }
            }
        }
        function event_Mout(obj) {
            if (obj != _RowObject) {
                for (var i = 0; i < obj.childNodes.length; i++) {
                    obj.childNodes.item(i).style.backgroundColor = "#FFFFFF";
                }
            }
        }
        var _RowObject = null;
        function event_click(obj) {
            if (_RowObject != null) {
                for (var i = 0; i < _RowObject.childNodes.length; i++) {
                    _RowObject.childNodes.item(i).style.backgroundColor = "#FFFFFF";
                }
            }

            _RowObject = obj;
            for (var i = 0; i < obj.childNodes.length; i++) {
                obj.childNodes.item(i).style.backgroundColor = "#f1f8ff";
            }
        }

        var schedule_admin_popup_executive_dialogArguments = new Array();
        function event_dbclick() {
            if (isToggle)
                return;
            if (_RowObject == null) {
                alert("<spring:message code='ezSchedule.lyj08'/>");
                return;
            }
            var td = _RowObject.getElementsByTagName("td")[1];
            var username = td.getElementsByTagName("span")[0].textContent;
            var priority = _RowObject.getAttribute("priority");

            schedule_admin_popup_executive_dialogArguments[0] = username;
            schedule_admin_popup_executive_dialogArguments[1] = popup_executive_complete;

            var id = _RowObject.id;
            var usage = _RowObject.getAttribute("usage");
            var companyID = _RowObject.getAttribute("companyid");
            var OpenWin = window.open("/admin/ezSchedule/SchedulePopupExecutive.do?cn=" + id + "&companyId=" + companyID + "&usage=" + usage + "&priority=" + priority, "SchedulePopupExecutive", GetOpenWindowfeature(460, 220));
            try { OpenWin.focus(); } catch (e) { }
        }

        function add_executive() {
            selectedCompanyID = $("#ListCompany").val();
            var table = document.querySelector('#contentlist .mainlist');
            var lastRow = table.querySelector('tr:last-child').textContent != strLang263 ? table.querySelector('tr:last-child') : null;
            var priority = lastRow != null ? parseInt(lastRow.getAttribute("priority"), 10) + 1 : 1;
            
            schedule_admin_popup_executive_dialogArguments[1] = popup_executive_complete;
            var OpenWin = window.open("/admin/ezSchedule/SchedulePopupExecutive.do?priority=" + priority + "&companyId=" + selectedCompanyID, "SchedulePopupExecutive", GetOpenWindowfeature(460, 220));
            try { OpenWin.focus(); } catch (e) { }
        }

        function popup_executive_complete() {
            schedule_get_executiveList();
            _RowObject = null;
        }

        function del_executive() {
            if (_RowObject == null) {
                alert(strLang84);
                return;
            }
            
            if(confirm("<spring:message code='ezSchedule.lyj07' />")){
                $.ajax({
                    url : "/admin/ezSchedule/scheduleDelExecutive.do",
                    type : "POST",
                    dataType : "html",
                    async : false,
                    data : {
                        cn : _RowObject.id,
                        companyId : _RowObject.getAttribute("companyid")
                    },
                    success : function(text){
                        alert(strLang85);
                        popup_executive_complete();
                    },
                    error : function(err){
                        alert(strLang86);
                    }
                });
            }
        }

        function priority_toggle() {
            if (!isToggle) {
                document.getElementById("p_toggle").style.display = "none";
                document.getElementById("p_up").style.display = "";
                document.getElementById("p_down").style.display = "";
                document.getElementById("p_save").style.display = "";
                document.getElementById("p_cancel").style.display = "";
            }
            else {
                document.getElementById("p_toggle").style.display = "";
                document.getElementById("p_up").style.display = "none";
                document.getElementById("p_down").style.display = "none";
                document.getElementById("p_save").style.display = "none";
                document.getElementById("p_cancel").style.display = "none";
            }
            isToggle = !isToggle;
        }

        function priority_save() {
            var content = document.getElementById("contentlist").textContent;
            if (content == strLang263) {
                alert("<spring:message code='ezSchedule.lyj21' />");
                return;
            }
            
            if(confirm("<spring:message code='ezSchedule.lyj13' />")) {
                var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();
                var objNode, objNode2, subNode;
                selectedCompanyID = $("#ListCompany").val();

                var list = document.getElementById("contentlist").getElementsByTagName("TR");
                createNodeInsert(xmlpara, objNode, "DATA");

                for (var i = 0; i < list.length; i++) {
                    if (list[i].getAttribute("needUpdate") != null && list[i].getAttribute("needUpdate") == "true") {
                        subNode = createNodeAndInsertText(xmlpara, objNode, "ROW", "");
                        createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "CN", list[i].getAttribute("id"));
                        createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "PRIORITY", list[i].getAttribute("priority"));
                    }
                }
                
                xmlhttp.open("POST", "/admin/ezSchedule/scheduleNumUpdateExecutive.do?companyID=" + selectedCompanyID, false);
                xmlhttp.send(xmlpara);

                if (xmlhttp.status == 200) {
                    alert("<spring:message code='ezSchedule.t4012' />");
                    COMPANY_CHANGE();
                    _RowObject = null;
                } else {
                    alert("<spring:message code='ezSchedule.lyj18' />");
                    return;
                }
            }
        }

        function priority_cancel() {
            COMPANY_CHANGE();
            _RowObject = null;
        }

        function priority_up() {
            if (_RowObject == null) {
                alert("<spring:message code='ezSchedule.lyj12' />");
                return;
            }
            var ChangeRow = null;
            for (var i = 0; i < _RowObject.parentNode.children.length; i++) {
                if (_RowObject.parentNode.children.item(i) == _RowObject) {
                    if (i == 0) {
                        return;
                    }
                    ChangeRow = i - 1;
                    swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));

                    break;
                }
            }
        }
        function swapNodes(item1, item2) {
            var itemtmp = item1.cloneNode(1);
            var parent = item1.parentNode;
            item2 = parent.replaceChild(itemtmp, item2);
            item1.setAttribute("priority", GetAttribute(item2, "priority"));
            item2.setAttribute("priority", GetAttribute(itemtmp, "priority"));
            item1.setAttribute("needUpdate", "true");
            item2.setAttribute("needUpdate", "true");
            item1.childNodes[0].childNodes[0].innerText = GetAttribute(item1, "priority");
            item2.childNodes[0].childNodes[0].innerText = GetAttribute(item2, "priority");
            parent.replaceChild(item2, item1);
            parent.replaceChild(item1, itemtmp);
            itemtmp = null;
        }
        function priority_down() {
            if (_RowObject == null) {
                alert("<spring:message code='ezSchedule.lyj12' />");
                return;
            }
            var ChangeRow = null;
            for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
                if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
                    if (i == _RowObject.parentNode.childNodes.length - 1) {
                        return;
                    }
                    ChangeRow = i + 1;
                    swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
                    break;
                }
            }
        }
        
        function reset() {
            $(function() {
                $('#keyword').val('');
            });
        }

        function onkeydown_start_search(e) {
            if (e.keyCode == "13") {
                e.preventDefault();
                start_search();
            }
        }

        function start_search() {
            var keyword = document.getElementById("keyword");
            if (keyword.value.trim() == null || keyword.value.trim() == "") {
                alert("<spring:message code='ezSchedule.t8' />");
                return;
            }
            
            selectedCompanyID = $("#ListCompany").val();
            selectedCompanyName = $('#ListCompany option:selected').text();
            $.ajax({
                url : "/admin/ezSchedule/scheduleGetExecutiveList.do",
                type : "GET",
                dataType : "xml",
                async : true,
                cache : false,
                data : {
                    keyword : keyword.value,
                    companyID : selectedCompanyID,
                    companyName : selectedCompanyName
                },
                success : function(text){
                    MakeSliderList(text);
                }
            });
        }
    </script>
</head>
<body class="mainbody">
    <h1>
        <spring:message code='ezSchedule.lyj01' />
        <span class="title_bar"><img src="/images/name_bar.gif"></span>
        <select class="companySelect" id="ListCompany" onChange="schedule_get_executiveList()">
            <c:forEach var="item" items="${companyList}">
                <option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            </c:forEach>
        </select>
    </h1>
<form id="Form1" method="post">
    <div id="mainmenu">
        <div style="width:800px">
            <ul style="margin-top: 20px;">
                <li class="important"><span onClick="add_executive()"><spring:message code='ezSchedule.lyj02' /></span></li>
                <li><span onClick="event_dbclick()"><spring:message code='ezSchedule.t302' /></span></li>
                <li><span class="icon16 icon16_delete" onClick="del_executive()"></span></li>
                <li id="p_toggle" style="display:none;"><span onClick="priority_toggle()"><spring:message code='ezSchedule.lyj03' /></span></li>
                <li id="p_up" onclick="priority_up()" title="위로"><span><img src="/images/ImgIcon/prev.gif" style="margin-top: -2px;"></span></li>
                <li id="p_down" onclick="priority_down()" title="아래로"><span><img src="/images/ImgIcon/next.gif" style="margin-top: -2px;"></span></li>
                <li id="p_save" onclick="priority_save()"><span><spring:message code='ezSchedule.lyj06' /></span></li>
                <li id="p_cancel" onclick="priority_cancel()"><span><spring:message code='ezSchedule.t5' /></span></li>
            </ul>
        </div>
        <table class="content" style="margin-top:9px;">
            <table style="width: 100%; background-color: #f8f8f8; border-top: 1px solid #e8e8e8; border-bottom: 1px solid #e8e8e8;">
                <tbody>
                    <tr>
                        <th style="background-color: #f1f3f5; height: 26px; width:72px; border: 1px solid #e2e3e6;"><spring:message code='ezSchedule.lyj19' /></th>
                        <td style=" border: 1px solid #e2e3e6;">
                            <input name="text" type="text" style="WIDTH:190px; height: 25px; margin-left:5px;" id="keyword" onkeypress="onkeydown_start_search(event)">
                            <a class="imgbtn imgbck" style=" margin-bottom:0px;"><span onclick="start_search()"><spring:message code='ezSchedule.t24' /></span></a>
                            <a class="imgbtn"><span onclick="javascript:reset();"><spring:message code='ezSchedule.lyj20' /></span></a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </table>
    </div>
    <table id="Managetable" style="width: 100%; height: 545px;" border="0">
        <tr>
            <td>
                <div style="border-top:0px; width: 100%; height: 545px;">
                    <table class="mainlist" style="width: 100%;">
                        <tbody id="manage_HEAD">
                        <tr>
                            <th style="width: 10%;"><span><spring:message code='ezSchedule.lyj04' /></span></th>
                            <th style="width: 20%;"><span><spring:message code='ezSchedule.t999' /></span></th>
                            <th style="width: 20%;"><span><spring:message code='ezSchedule.t12' /></span></th>
                            <th style="width: 10%;"><span><spring:message code='ezSchedule.t402' /></span></th>
                            <th style="width: 20%;"><span><spring:message code='ezSchedule.lyj05' /></span></th>
                            <th style="width: 20%;"><span><spring:message code='ezSchedule.csj04' /></span></th>
                        </tr>
                        </tbody>
                    </table>
                    <div id="contentlist" name="contentlist" style="height: 511px; overflow-y: auto;">
                        <table id="managelist_body" class="mainlist" style="width: 100%;">
                            <tr>
                                <td style="text-align: center;">
                                    <img src="/images/email/progress_img.gif" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </td>
        </tr>
    </table>
    <script type="text/javascript">
        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
    </script>
</form>
</body>
</html>

