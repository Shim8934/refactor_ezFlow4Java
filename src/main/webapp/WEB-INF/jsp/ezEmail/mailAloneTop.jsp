<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <title>TopMenu</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            
        <link href="/css/main.css" rel="stylesheet" type="text/css">
        
        
        <style type="text/css">
            
            
        </style>
    
        <script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
        <script type="text/javascript" src="/js/ezPortal/functionLib.js"></script>          
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript">
        var skinnum = "";
        
        var selectedCell = "";
        var selectedSubCell = "";
        var previousSubCell = null;
        var previousCell = null;
        var count = 1000;
        var pageid = "F3633607-8E8B-42A1-B777-6E2969072E58";
        var parentpageid = "top";
        var mode = "view";
        var editmode = "";
        var viewmode = "";
        var bInherit = false;
        var pressCount = 0;
        var selObjClass = "";
        var SkinExist = "NO";
        var pNoneActiveX = "YES";
        
        // 2009.11.25 - 소스보기시 개인정보 유출방지
        var pwd = "";
        document.onselectstart = function () { return false; };
        window.onload = function() {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.body.style.MozUserSelect = 'none';
                document.body.style.WebkitUserSelect = 'none';
                document.body.style.khtmlUserSelect = 'none';
                document.body.style.oUserSelect = 'none';
                document.body.style.UserSelect = 'none';
            }
            if (editmode == "new_inherit") bInherit = true;
            if (mode == "edit") AttachEvents(main_table);
            
            // 2009.11.25 - 소스보기시 개인정보 유출방지
            pwd = CheckPwd();
            
            // 검색UI 설정
            try {
                if (typeof(searchTD) == "object") {
                    searchTD.parentNode.parentNode.parentNode.style.width = "100%";
                    searchTD.innerHTML = "<table border=\"0\" height=\"41\" cellspacing=\"0\" cellpadding=\"0\"><tr>" +
                                        "<td width=\"44\"   height=\"40\" valign=\"middle\"><img src=\"/images/main/totalsearch.gif\" align=\"absmiddle\"></td>" +
                                        "<td width=\"140\"   height=\"40\" valign=\"middle\">   <input name=\"txtSearch\" type=\"text\"  class=\"search\" onkeydown=entercheck()></td>" +                                   
                                        "<td width=\"31\"  height=\"40\" valign=\"middle\"><img src=\"/images/top/bt_search.gif\" width=\"31\" height=\"21\" style='cursor:pointer' onclick=Search()></td>" +
                                        "</tr></table>";
                }
            }
            catch (e) {}
            
            // 수정(2007.03.14) : 사용자 정보 영역 UI 설정
            try {
                if (typeof(userInfoTD) == "object") {
                    userInfoTD.parentNode.parentNode.parentNode.style.marginTop = "10px";
                    userInfoTD.innerHTML = "<iframe width=300 height=31 border=0 src='/myoffice/ezPortal/filter/UserInfoPortlet.aspx' frameborder=0 scrolling=no></iframe>";
                }
            }
            catch (e) {}
    
            // 보기모드에서 미리보기가 아닌 경우 실행
            if (mode == "view" && viewmode != "preview") {
                var agentObj;
                 if (!CrossYN()) {
                     //브라우저 정보 가져오기
                    var userAgent = window.navigator.userAgent;
                    
                    //IE9 일때만 ActiveX 설치하게 설정
                    if (userAgent.indexOf("Trident/5.0") > 0) {
                         GetObject();
                         ezNotieSetting();
                    }
                    
                } 
//              window.setInterval("update_connectinfo()", 30000);  
            }
        }
        function ezNotieSetting() {
            
        }
        function GetObject() {
            var agentObj;
            try {
            } catch (e) { }

            var agentObj;
            i_icd2.SetDocumentDisp(window.document);
            i_icd2.xmlURL = "http://" + document.location.hostname + "/ezPortal/componentListTransfer.do";
            i_icd2.CheckVersion();
            var nCount = i_icd2.nNeedDownload;
            if (nCount) {
                if_Progress.StartOn();
            } else {
                finish_download();
            }
        }

        function finish_download() {
            OfficeBugPatch();   
            popupNotice();
        }

        function OfficeBugPatch()
        {
        }
        
        // 2009.11.25 - 소스보기시 개인정보 유출방지
        function CheckPwd() {
                var strPwd = "";
                var xmlhttp = createXMLHttpRequest();
                xmlhttp.open("POST", "interASP/CheckPwd.aspx", false);
                xmlhttp.send();        
                strPwd = xmlhttp.responseText;
                if(strPwd == "FALSE") {
                       xmlhttp = null;        
                       return "FALSE";
                }
                xmlhttp = null;
                return strPwd;
        }

        
        function popupNotice() {
            //document.all.ifmpopup.src ="popup_menu.aspx";
        }

        var xmlHTTP = null;
        var blogout = false;
    
    // 2016-07-27 임시로 주석    
    /*  function update_connectinfo()
        {
            if (blogout)
                return;
                
            xmlHTTP = createXMLHttpRequest();
            xmlHTTP.open("POST", "/myoffice/main/update_connectinfo.aspx", true);
            xmlHTTP.onreadystatechange = event_update_connectinfo;
            xmlHTTP.send();
        } */
        
        var bLogOutNOTICE = false;
        function event_update_connectinfo() {
            if (xmlHTTP.readyState != 4)
                return;
            
            if (xmlHTTP.status == 200 && xmlHTTP.responseText == "LOGOUT") {
                blogout = true;
                alert("사용자가 다른곳에서 로그인해서 강제로 로그아웃합니다.");
                window.top.location.href = "/user/login/actionLogout.do";
            }
        }
        
        function change_menu(idx, navigation_info) {
            
        }

        function OpenInformationUI(pInformationContent)
        {
            var parameter = pInformationContent;
            var url = "/myoffice/ezApproval/ezAPROPINION.htm";
            var feature = "status:no;dialogWidth:330px;dialogHeight:180px;help:no;scroll:no;edge:sunken";
            var RtnVal = window.showModalDialog(url,parameter,feature);
            return RtnVal;
        }

        function load()
        {
            var ret = window.showModalDialog("TopMenu_search.aspx?mode=load");
            if (typeof(ret) == "undefined") return;
            
            document.location.href = "/ezPortal/topMenu.do?pageID=" + ret[0];
        }

        function inherit()
        {
            var ret = window.showModalDialog("TopMenu_search.aspx?mode=inherit");
            if (typeof(ret) == "undefined") return;
            
            document.location.href = "/ezPortal/topMenu.do?parentPageID=" + ret[0];
        }

        function savesub(pObject, pPageID, pParentPageID, pDisplayName, pDisplayName2)
        {
            var strXML = "<DATA>";
            strXML += "<DISPLAYNAME>" + pDisplayName + "</DISPLAYNAME>";
            strXML += "<DISPLAYNAME2>" + pDisplayName2 + "</DISPLAYNAME2>";
            strXML += "<THEMEINFO>" + ReplaceValidString(document.getElementById("Themeinfo").value) + "</THEMEINFO>";
            strXML += "<WIDTH>" + pObject.getAttribute("width").toString().replace("px", "").replace("100%", "-1") + "</WIDTH>";
            strXML += "<HEIGHT>" + pObject.getAttribute("height").toString().replace("px", "").replace("100%", "-1") + "</HEIGHT>";
            strXML += "<PARENTPAGEID>" + pParentPageID + "</PARENTPAGEID>";
            
            // 대상테이블의 최상위td count
            for (var i=0; i<pObject.children.item(0).children.item(0).children.length; i++)
            {
                // 최상위td
                if (pObject.children.item(0).children.item(0).children.item(i).id == "") continue;
                if (pObject.children.item(0).children.item(0).children.item(i).id.substr(0, 2) == "td")
                {
                    strXML += "<CELL>";
                    var td_item = pObject.children.item(0).children.item(0).children.item(i);
                    strXML += "<WIDTH>" + td_item.style.width.toString().replace("px", "") + "</WIDTH>";
                    
                    // 해당td내의 tr의 카운트 (TABLE/TBODY/TR)
                    for (var j=0; j<td_item.children.item(0).children.item(0).children.length; j++)
                    {
                        // 해당 tr내의 td
                        var tdsub_item = td_item.children.item(0).children.item(0).children.item(j).children.item(0);
                            
            
                        if (tdsub_item.id == "") continue;
                        
                        
                        // td안에 컨텐츠가 존재하는 경우
                        if (tdsub_item.children.length > 0 && tdsub_item.children.item(0).id.toLowerCase().substr(0, 4) != "main")
                        {
                            strXML += "<ROW>";
                            strXML += "<TYPE>0</TYPE>";
                            strXML += "<UID>" + tdsub_item.getAttribute("uid") + "</UID>";
                            strXML += "<PAGEUID>" + tdsub_item.getAttribute("pageuid") + "</PAGEUID>";
                            strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
                            strXML += "<DISPLAYNAME>" + tdsub_item.firstChild.innerHTML+ "</DISPLAYNAME>";
                            strXML += "<CANREMOVE>" + tdsub_item.getAttribute("canremove") + "</CANREMOVE>";
                            strXML += "<CANRESIZE>" + tdsub_item.getAttribute("canresize") + "</CANRESIZE>";
                            strXML += "<CANREPLACE>" + tdsub_item.getAttribute("canreplace") + "</CANREPLACE>";
                            strXML += "<ROOTPAGEID>" + pageid + "</ROOTPAGEID>";
                            strXML += "</ROW>";
                        }
                        // td안에 테이블이 존재하는 경우
                        else {
                            strXML += "<ROW>";
                            strXML += "<TYPE>1</TYPE>";
                            strXML += "<UID>" + tdsub_item.getAttribute("uid") + "</UID>";
                            strXML += "<PAGEUID>" + tdsub_item.getAttribute("pageuid") + "</PAGEUID>";
                            strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
                            strXML += "<DISPLAYNAME>" + tdsub_item.getAttribute("pageuid") + "</DISPLAYNAME>";
                            strXML += "<CANREMOVE>" + tdsub_item.getAttribute("canremove") + "</CANREMOVE>";
                            strXML += "<CANRESIZE>" + tdsub_item.getAttribute("canresize") + "</CANRESIZE>";
                            strXML += "<CANREPLACE>" + tdsub_item.getAttribute("canreplace") + "</CANREPLACE>";
                            strXML += "<ROOTPAGEID>" + pageid + "</ROOTPAGEID>";
                            strXML += "</ROW>";
                            
                            // 하위테이블의 정보를 저장
                            savesub(tdsub_item.children.item(0), tdsub_item.getAttribute("uid"), "top", tdsub_item.getAttribute("uid"), tdsub_item.getAttribute("uid"));
                        }
                    }
                    strXML += "</CELL>";
                }
            }
            strXML += "</DATA>";

            var xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/admin/ezPortal/portalSaveTopMenu.do?pageID=" + pPageID + "&parentPageID=" + pParentPageID, false);
            xmlhttp.send(strXML);
            xmlhttp = null;
        }

        function save()
        {
            if (txtDisplayName.value == "")
            {               
                alert("포탈 페이지 이름을 입력하세요.");
                txtDisplayName.focus();
                return;     
            }
            if (txtDisplayName2.value == "")
            {               
                txtDisplayName2.value = txtDisplayName.value;
            }
            
            savesub(main_table, pageid, parentpageid, txtDisplayName.value, txtDisplayName2.value);
            
            // 스킨정보 생성
            if (SkinExist == "NO")
                SaveSkin(pageid);
            
            alert("저장했습니다.");
            document.location.href = "/ezPortal/topMenu.do?pageID=" + pageid;
        }
        
        function SaveSkin(pPageID)
        {
            var xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/admin/ezPortal/portalSaveSkin.do?pageID=" + pPageID, false);
            xmlhttp.send();
            xmlhttp = null;
        }
        
        function CheckDuplicate(pUID)
        {
            for (var i=0; i<main_table.getElementsByTagName("td").length; i++)
            {
                if (main_table.getElementsByTagName("td").item(i).getAttribute("uid") == pUID) return true;
            }
            return false;
        }
        
        function OpenEditWindow(pUID)
        {
            if (pUID == "201") window.open("admin/edit/LogoArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
            if (pUID == "202") window.open("admin/edit/UtilMenuArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
            if (pUID == "203") window.open("admin/edit/MainMenuArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
            if (pUID == "205") window.open("admin/edit/SearchArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
        }
        
        function dblclicksubcell()
        {
            var obj = null;
            if (event.srcElement.id == "") obj = event.srcElement.parentElement;
            else obj = event.srcElement;
            
            if (typeof(obj.uid) != "undefined" && obj.uid != "") 
            {
                event.cancelBubble = true;  
                OpenEditWindow(obj.uid);
            }
        }

        function AttachEvents(pObject, pPageID)
        {
            var prevpageid = "";
            var count = 0;
            
            for (var i = 0; i < pObject.getElementsByTagName("td").length; i++)
            {

                if (pObject.getElementsByTagName("td").item(i).id == "") continue;

                if (pObject.getElementsByTagName("td").item(i).id.indexOf("sub") > -1)
                {
                    if (prevpageid != pObject.getElementsByTagName("td").item(i).getAttribute("pageuid")) count++;
                    prevpageid = pObject.getElementsByTagName("td").item(i).getAttribute("pageuid");


                    pObject.getElementsByTagName("td").item(i).setAttribute("onclick", "selectsubcell(event)");
                    pObject.getElementsByTagName("td").item(i).setAttribute("onkeydown", "cellkeydown(event)");
                    pObject.getElementsByTagName("td").item(i).setAttribute("onkeyup", "cellkeyup()");
                    //pObject.getElementsByTagName("td").item(i).onclick = selectsubcell;
                    //pObject.getElementsByTagName("td").item(i).onkeydown = cellkeydown;
                    //pObject.getElementsByTagName("td").item(i).onkeyup = cellkeyup;
                    pObject.getElementsByTagName("td").item(i).style.cursor = "pointer";
                    
                }
                else
                {
                    pObject.getElementsByTagName("td").item(i).setAttribute("onclick", "selectcell(event)");
                    pObject.getElementsByTagName("td").item(i).setAttribute("onkeydown", "cellkeydown(event)");
                    pObject.getElementsByTagName("td").item(i).setAttribute("onkeyup", "cellkeyup()");
                    //pObject.getElementsByTagName("td").item(i).onclick = selectcell;
                    //pObject.getElementsByTagName("td").item(i).onkeydown = cellkeydown;
                    //pObject.getElementsByTagName("td").item(i).onkeyup = cellkeyup;
                }
            }
            
            if (count > 1) bInherit = false;
        }

        // 영역 선택시 처리
        function selectcell(e)
        {

            var Event = e ? e : window.event;
            var Element = Event.target ? Event.target : Event.srcElement;
            if (Element.id == "") return;
            if (Element.id.indexOf("sub") > -1) return;
            selectedCell = Element.id;
            if (previousCell != null) previousCell.style.backgroundColor = "white";
            previousCell = Element.children.item(0).children.item(0).children.item(0).children.item(0);
            previousCell.style.backgroundColor = "lightblue";
            
            
            // 현재 선택된 cell
            var cell = eval(selectedCell);
            
            // 선택된 cell의 table
            var tblObject = eval(GetMainTable(eval(selectedCell)));
            
            if (typeof(tblObject) == "undefined")
                return;
            
            var maxHeight = 0;
            var compareHeight = 0;
            
            if (tblObject.getAttribute("height") != "")
                maxHeight = parseInt(tblObject.getAttribute("height").replace("px", ""), 10);
            
            // 해당 table의 height를 구한다.
            for (var i = 0; i < tblObject.getElementsByTagName("tr").length; i++)
            {
                try{
                    compareHeight = tblObject.getElementsByTagName("tr").item(i).style.height.replace("px", "");
                    
                    if (compareHeight != "")
                    {
                        if (parseInt(compareHeight, 10) > maxHeight)
                            maxHeight = parseInt(compareHeight, 10);
                    }
                
                } catch (e) {}
            }
            
            document.getElementById("txtWidth").value = cell.style.width.replace("px", "");
            document.getElementById("txtHeight").value = maxHeight;

            
            document.getElementById("txtWidth").disabled = false;
            if (document.getElementById("txtWidth").value == "")
            {
                document.getElementById("txtWidth").value = "*";
                document.getElementById("txtWidth").disabled = true;
            }
            
            // 선택한 개체의 종류
            selObjClass = "TABLE";
        }

        function selectcellTitle(e)
        {

            var Event = e ? e : window.event;
            var Element = Event.target ? Event.target : Event.srcElement;
            selectcell2(Element.parentElement.parentElement.parentElement.parentElement);
            //event.srcElement.parentElement.parentElement.parentElement.parentElement.click();
            //event.cancalBubble = true;
            //event.returnValue = false;
        }
        function selectcell2(obj) {


            if (obj.getAttribute("id") == "") return;
            if (obj.getAttribute("id").indexOf("sub") > -1) return;
            selectedCell = obj.getAttribute("id");
            if (previousCell != null) previousCell.style.backgroundColor = "white";
            previousCell = obj.children.item(0).children.item(0).children.item(0).children.item(0);
            previousCell.style.backgroundColor = "lightblue";


            // 현재 선택된 cell
            var cell = eval(selectedCell);

            // 선택된 cell의 table
            var tblObject = eval(GetMainTable(eval(selectedCell)));

            if (typeof (tblObject) == "undefined")
                return;

            var maxHeight = 0;
            var compareHeight = 0;

            if (tblObject.getAttribute("height") != "")
                maxHeight = parseInt(tblObject.getAttribute("height").replace("px", ""), 10);

            // 해당 table의 height를 구한다.
            for (var i = 0; i < tblObject.getElementsByTagName("tr").length; i++) {
                try {
                    compareHeight = tblObject.getElementsByTagName("tr").item(i).style.height.replace("px", "");

                    if (compareHeight != "") {
                        if (parseInt(compareHeight, 10) > maxHeight)
                            maxHeight = parseInt(compareHeight, 10);
                    }

                } catch (e) { }
            }

            document.getElementById("txtWidth").value = cell.style.width.replace("px", "");
            document.getElementById("txtHeight").value = maxHeight;


            document.getElementById("txtWidth").disabled = false;
            if (document.getElementById("txtWidth").value == "") {
                document.getElementById("txtWidth").value = "*";
                document.getElementById("txtWidth").disabled = true;
            }

            // 선택한 개체의 종류
            selObjClass = "TABLE";
        }

        // 컨텐츠 선택시 처리
        function selectsubcell(e)
        {
            var Event = e ? e : window.event;
            var eventItem = Event.target ? Event.target : Event.srcElement;
            if (eventItem.getAttribute("id") == null)
            {
                eventItem = eventItem.parentElement;
            }
            selectedSubCell = eventItem.getAttribute("id");
            
            try
            {
                if (previousSubCell != null) previousSubCell.parentElement.style.backgroundColor = "white";
            } catch(e) {}
            
            eventItem.parentElement.style.backgroundColor = "#FFDEB5";
            previousSubCell = eventItem;
            
            var cell;
            var curHeight = 0;
            if (selectedSubCell != null) {
                cell = eval(selectedSubCell);
                curHeight = parseInt(cell.parentElement.style.height.replace("px", ""));
            }
            else {
                cell = eval(previousSubCell);
                curHeight = parseInt(cell.parentElement.children[1].style.height.replace("px", ""));
            }
            document.getElementById("txtHeight").value = curHeight;
            // 컨텐츠 선택시는 너비 입력필드를 disabled
            document.getElementById("txtWidth").value = "*";
            document.getElementById("txtWidth").disabled = true;
            // 선택한 개체의 종류
            selObjClass = "CONTENTS";
        }

        function cellkeyup()
        {
            pressCount = 0;
        }

        function cellkeydown(e)
        {
            if (!e.ctrlKey)
            {
                switch(e.keyCode)
                {
                    case 37:
                        swaprow("left");
                        break;
                    case 38:
                        swaprow("up");
                        break;
                    case 39:
                        swaprow("right");
                        break;
                    case 40:
                        swaprow("down");
                        break;
                    default:
                        break;
                }
            }
            else
            {
                switch(e.keyCode)
                {
                    case 37:
                        resizecell("left");
                        break;
                    case 38:
                        resizerow("up");
                        break;
                    case 39:
                        resizecell("right");
                        break;
                    case 40:
                        resizerow("down");
                        break;
                    default:
                        break;
                }
            }
        }

        function GetPageID(pCell) {
            if (typeof (pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getAttribute("uid")) != "undefined") return pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getAttribute("uid");
            else return pageid;
        }
        var menuitem_search_dialogArguments = new Array();
        function insertrow()
        {
            if (selectedCell == "")
            {
                alert("컨텐츠를 추가할 열을 선택하세요.");
                return;
            }
            
            if (eval(selectedCell).children.item(0).children.item(0).children.length > 9)
            {
                alert("하나의 열에 10개 이상의 컨텐츠를 추가할 수 없습니다.");
                return;
            }
            
            if (CrossYN()) {
                menuitem_search_dialogArguments[1] = insertrow_Complete;
                var OpenWin = window.open("/ezPortal/menuItemSearch.do", "MenuItem_search", GetOpenWindowfeature(290, 340));
                try { OpenWin.focus(); } catch (e) { }
            }
            else {

                var ret = window.showModalDialog("/ezPortal/menuItemSearch.do", "", "dialogHeight:340px; dialogWidth:290px; status:no;scroll:auto; help:no; edge:sunken" + GetShowModalPosition(290, 340));

                if (typeof (ret) == "undefined") return;

                if (CheckDuplicate(ret[0]) && ret[0] != "206") {
                    alert("이미 추가된 컨텐츠입니다.");
                    return;
                }

                if (ret[0] == "206") {
                    ret[0] = GetGUID();
                    ret[1] = "";
                }

                /*var newrow = eval(selectedCell).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
                newrow.style.width = "100%";
                newrow.style.height = "100px";

                var subtdGetid = "subtd" + GetGUID().substr(0, 4);
                var strInnerHTML = "<td id=\"" + subtdGetid + "\"uid=\"" + ret[0] + "\" style=\"width:100%\"  ownerpageuid='" + pageid + "' align=\"center\" onclick=\"selectsubcell(event)\" ondblclick=\"dblclicknotice()\" onkeydown=\"cellkeydown(event)\" canremove=\"1\"  canresize=\"1\"  canreplace=\"1\"><b> " + ret[1] + "</b></td>";             
                newrow.innerHTML = strInnerHTML;
                var pageuid = "";
                if (GetPageID(document.getElementById(subtdGetid)) == null)
                    pageuid = pageid;
                else
                    pageuid = GetPageID(document.getElementById(subtdGetid));

                document.getElementById(subtdGetid).setAttribute("pageuid", pageuid);
                document.getElementById(subtdGetid).focus(); */

                var newrow = eval(selectedCell).children.item(0).insertRow();
                var subtdGetid = "subtd" + GetGUID().substr(0, 4);
                newrow.style.width = "100%";
                newrow.style.height = "100px";
                var newcell = newrow.insertCell();
                newcell.id = subtdGetid;
                newcell.uid = ret[0];

                if (GetPageID(document.getElementById(subtdGetid)) == null) {
                    pageuid = pageid;
                } else
                    pageuid = GetPageID(document.getElementById(subtdGetid));

                newcell.pageuid = pageuid;
                newcell.ownerpageuid = pageid;
                newcell.canremove = 1;
                newcell.canresize = 1;
                newcell.canreplace = 1;

                newcell.setAttribute("id", subtdGetid);
                newcell.setAttribute("uid", ret[0]);
                newcell.setAttribute("pageuid", pageuid);
                newcell.setAttribute("ownerpageuid", pageid);
                newcell.setAttribute("canremove", 1);
                newcell.setAttribute("canresize", 1);
                newcell.setAttribute("canreplace", 1);

                newcell.style.width = "100%";
                newcell.align = "center";
                newcell.innerHTML = "<b>" + ret[1] + "</b>";
                newcell.onclick = selectsubcell;
                //newcell.ondblclick = dblclicknotice;
                //newcell.onkeydown = cellkeydown;
                selectedSubCell = "";
                newcell.focus();
            }
        }
            function insertrow_Complete(ret) {
                if (typeof (ret) == "undefined") return;

                if (CheckDuplicate(ret[0]) && ret[0] != "206") {
                    alert("이미 추가된 컨텐츠입니다.");
                    return;
                }

                if (ret[0] == "206") {
                    ret[0] = GetGUID();
                    ret[1] = "";
                }

                var newrow = eval(selectedCell).children.item(0).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
                newrow.style.width = "100%";
                newrow.style.height = "100px";

                var subtdGetid = "subtd" + GetGUID().substr(0, 4);
                var strInnerHTML = "<td id=\"" + subtdGetid + "\"uid=\"" + ret[0] + "\" style=\"width:100%\"  ownerpageuid='" + pageid + "' align=\"center\" onclick=\"selectsubcell(event)\" ondblclick=\"dblclicknotice()\" onkeydown=\"cellkeydown(event)\" canremove=\"1\"  canresize=\"1\"  canreplace=\"1\"><b> " + ret[1] + "</b></td>";
                newrow.innerHTML = strInnerHTML;

                var pageuid = "";
                if (GetPageID(document.getElementById(subtdGetid)) == null)
                    pageuid = pageid;
                else
                    pageuid = GetPageID(document.getElementById(subtdGetid));

                document.getElementById(subtdGetid).setAttribute("pageuid", pageuid);
                document.getElementById(subtdGetid).focus();

            }

        function insertcell()
        {
            if (bInherit)
            {
                alert("상속받은 포탈 페이지에는 열을 추가할 수 없습니다.");
                return;
            }
            
            if (selectedCell == "")
            {
                alert("열을 삽입할 위치를 선택해주세요");
                return;
            }
            
            var newcell = document.createElement("td");
            var row = eval(selectedCell).parentElement;
            row.insertBefore(newcell, eval(selectedCell));
            
            newcell.style.width = "100px";
            newcell.vAlign = "top";
            newcell.innerHTML = "<table border=1 cellpadding=0 cellspacing=0 width=100% valign=top><tbody><TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>100px</td></TR></tbody></table>";
            newcell.id = "td" + GetID();
            newcell.setAttribute("onclick", "selectcell(event)");
            newcell.setAttribute("onkeydown", "cellkeydown(event)");
            //newcell.onclick = selectcell;
            //newcell.onkeydown = cellkeydown;
            selectedSubCell = "";
        }

        function removecell()
        {
            if (bInherit)
            {
                alert("상속받은 포탈 페이지에는 열을 삭제할 수 없습니다.");
                return;
            }

            if (selectedCell == "")
            {   
                alert("삭제할 열을 선택하세요.");
                return;
            }
            
            if (selectedCell == "td0") return;
            
            if (selectedCell.substr(0,3) == "td0")
            {
                if (confirm("삽입된 페이지를 삭제하시겠습니까?"))
                {
                    eval(selectedCell).parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.removeChild(eval(selectedCell).parentElement.parentElement.parentElement.parentElement.parentElement);
                    selectedCell = "";
                    selectedSubCell = "";
                }
                return;
            }
            
            var row = eval(selectedCell).parentElement;
            
            for (var i=0; i<row.children.length; i++)
            {
                if (row.children.item(i).id == selectedCell)
                {
                    row.removeChild(row.children.item(i));
                    break;
                }
            }
            selectedCell = "";
            selectedSubCell = "";
        }

        function removerow()
        {
            if (selectedSubCell == "")
            {   
                alert("삭제할 컨텐츠를 선택하세요.");
                return;
            }
            
            var cell = eval(selectedSubCell);
            
            if (cell.getAttribute("canremove") != 1)
            {
                alert("삭제할 수 없는 컨텐츠입니다.");
                return;
            }
            
            var parentPageid = GetPageID(cell);
            if (parentPageid == null)
                parentPageid = pageid;
            if (cell.getAttribute("pageuid") != parentPageid)
            {
                alert("상속받은 컨텐츠는 삭제할 수 없습니다.");
                return;
            }
            
            cell.parentElement.parentElement.removeChild(cell.parentElement);
            selectedSubCell = "";
            selectedCell = "";
        }
        //크로스용 함수 추가
        function swapNodes(item1, item2) {
            var itemtmp = item1.cloneNode(1);
            var parent = item1.parentNode;
            item2 = parent.replaceChild(itemtmp, item2);
            parent.replaceChild(item2, item1);
            parent.replaceChild(item1, itemtmp);
            itemtmp = null;
        }
        function getNextSibling(node) {

            while (node.nodeType != 1) {
                node = node.nextSibling;
            }

            return node;
        }
        function getPreviousSibling(node) {

            while (node.nodeType != 1) {
                node = node.previousSibling;
            }

            return node;
        }
        //크로스용 함수 추가
        function swaprow(pDirection)
        {
            if (selectedSubCell == "")
            {   
                alert("컨텐츠를 선택하세요.");
                return;
            }

            var cell = eval(selectedSubCell);

            if (cell.getAttribute("canreplace") != 1)
            {
                alert("위치를 변경할 수 없는 컨텐츠입니다.");
                return;
            }
            var parentPageid = GetPageID(cell);
            if (parentPageid == null)
                parentPageid = pageid;
            if (cell.getAttribute("pageuid") != parentPageid)
            {
                alert("상속받은 컨텐츠는 위치를 변경할 수 없습니다.");
                return;
            }

            var obj = null;
            
            if (pDirection == "up")
            {
                if (getPreviousSibling(cell.parentElement.previousSibling) == null || getPreviousSibling(cell.parentElement.previousSibling).children.item(0).id == "")
                {
                    if (cell.pageuid == pageid) return;
                    try {
                            obj = cell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.insertAdjacentElement("beforeBegin", cell.parentElement);
//                          obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
                    } catch(e) { return; }
                }
                else 
                {
                    if (getPreviousSibling(cell.parentElement.previousSibling).outerHTML.toLowerCase().indexOf("table") > -1)
                    {
                        try {
                            obj = getPreviousSibling(cell.parentElement.previousSibling).children.item(0).children.item(0).children.item(0).children.item(0).lastChild.children.item(0).children.item(0).insertAdjacentElement("beforeEnd", cell.parentElement);
//                          obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
                        } catch(e) { return; }
                    }
                    else
                    {
                        //cell.parentElement.swapNode(cell.parentElement.previousSibling);
                        swapNodes(cell.parentElement, getPreviousSibling(cell.parentElement.previousSibling));
                    }
                }
            }   
            else if (pDirection == "down")
            {
                if (getNextSibling(cell.parentElement.nextSibling) == null || getNextSibling(cell.parentElement.nextSibling).children.item(0).id == "")
                {
                    if (cell.pageuid == pageid) return;
                    try {
                            obj = cell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.insertAdjacentElement("afterEnd", cell.parentElement);
                            obj.children.item(0).pageuid = GetPageID(obj.children.item(0));
                    } catch(e) { return; }
                }
                else
                {
                    if (getNextSibling(cell.parentElement.nextSibling).outerHTML.toLowerCase().indexOf("table") > -1)
                    {
                        try {
                            obj = getNextSibling(cell.parentElement.nextSibling).children.item(0).children.item(0).children.item(0).children.item(0).firstChild.children.item(0).children.item(0).firstChild.insertAdjacentElement("afterEnd", cell.parentElement);
//                          obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
                        } catch(e) { return; }
                    }
                    else
                    {
                        //cell.parentElement.swapNode(cell.parentElement.nextSibling);
                        //cell.parentElement.swapNode(cell.parentElement.nextSibling);
                        swapNodes(cell.parentElement, getNextSibling(cell.parentElement.nextSibling));
                    }

                }
            }
            else if (pDirection == "left")
            {
                if (getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling) == null) return;
                
                if (getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling).children.item(0).children.item(0).children.length > 9)
                {
                    alert("하나의 열에 10개 이상의 컨텐츠를 추가할 수 없습니다.");
                    return;
                }
                getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling).children.item(0).children.item(0).appendChild(cell.parentElement);
            }
            else if (pDirection == "right")
            {
                if (getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling) == null) return;
            
                if (getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling).children.item(0).children.item(0).children.length > 9)
                {
                    alert("하나의 열에 10개 이상의 컨텐츠를 추가할 수 없습니다.");
                    return;
                }
                getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling).children.item(0).children.item(0).appendChild(cell.parentElement);
            }
            cell.focus();
        }

        function resizecell(pDirection)
        {
            if (selectedCell == "")
            {   
                alert("컨텐츠를 선택하세요.");
                return;
            }
            
            if (bInherit)
            {
                alert("상속받은 포탈 페이지는 크기를 조정할 수 없습니다.");
                return;
            }

            var cell = eval(selectedCell);
            
            var curWidth = parseInt(cell.style.width.replace("px", ""));

            var increase = 1;

            if (pDirection == "right")
            {
                curWidth += increase;
                try {
                    cell.style.width = curWidth.toString();
                    cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = curWidth.toString() + "px"; 
                } catch(e) {}
            }   
            else if (pDirection == "left")
            {
                curWidth -= increase;
                try {
                    cell.style.width = curWidth.toString();
                    cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = curWidth.toString() + "px"; 
                } catch(e) {}
            }

            event.cancelBubble = true;
        }

        function resizerow(pDirection)
        {
            if (selectedSubCell == "")
            {   
                alert("행을 선택하세요.");
                return;
            }

            var cell = eval(selectedSubCell);
            
            if (cell.getAttribute("canresize") != 1)
            {
                alert("크기를 변경할 수 없는 컨텐츠입니다.");
                return;
            }
            
            if (cell.getAttribute("pageuid") != GetPageID(cell))
            {
                alert("상속받은 컨텐츠는 크기를 변경할 수 없습니다.");
                return;
            }
            
            var curHeight = parseInt(cell.parentElement.style.height.replace("px", ""));

            var increase = 1;

            if (pDirection == "up")
            {
                curHeight += increase;
                try {
                    cell.parentElement.style.height = curHeight.toString();
                } catch(e) {}
            }   
            else if (pDirection == "down")
            {
                curHeight -= increase;
                try {
                    cell.parentElement.style.height = curHeight.toString();
                } catch(e) {}
            }
            //event.cancelBubble = true;
        }

        function GetMainTable(pCell)
        {
            try {
                return pCell.parentElement.parentElement.parentElement.id;
            } catch (e) {}
        }
        
        function resizepage(pDirection)
        {
            if (selectedCell == "")
            {
                alert("크기를 변경할 페이지를 선택해 주세요.");
                return;
            }
            
            var tblObject = eval(GetMainTable(eval(selectedCell)));
            
            if (bInherit)
            {
                alert("상속받은 포탈 페이지는 크기를 조정할 수 없습니다.");
                return;
            }

            if (tblObject.width == "100%" && (pDirection == "left" || pDirection == "right"))
            {
                alert("최대화 된 너비는 크기를 조절할 수 없습니다.");
                return;
            }
            if (tblObject.height == "100%" && (pDirection == "up" || pDirection == "down"))
            {
                alert("최대화 된 높이는 크기를 조절할 수 없습니다.");
                return;
            }

            try
            {
                if (pDirection == "left")
                {
                    tblObject.width = parseInt(tblObject.width.toString().replace("px", "")) - 10;
                }
                if (pDirection == "right")
                {
                    tblObject.width = parseInt(tblObject.width.toString().replace("px", "")) + 10;
                }
                if (pDirection == "down")
                {
                    tblObject.height = parseInt(tblObject.height.toString().replace("px", "")) + 10;
                    tblObject.parentElement.parentElement.style.height = tblObject.height;
                }
                if (pDirection == "up")
                {
                    tblObject.height = parseInt(tblObject.height.toString().replace("px", "")) - 10;
                    tblObject.parentElement.parentElement.style.height = tblObject.height;
                }
            } catch(e) {}
            
        }
        
        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        function GetGUID() {
            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
        }

        function GetID()
        {
            return count++;
        }

        function preview()
        {
            window.open("/ezPortal/topMenu.do?mode=view&viewMode=preview&pageID=" + pageid);
        }

        function OpenMaxURL(pURL)
        {
            if (pURL == "") return; 
            location.href = pURL;
        }

        function insertpage()
        {
            if (selectedCell == "")
            {
                alert("행을 추가할 열을 선택하세요.");
                return;
            }
            
            if (eval(selectedCell).children.item(0).children.item(0).children.length > 9)
            {
                alert("하나의 열에 10개 이상의 컨텐츠를 추가할 수 없습니다.");
                return;
            }
            
            var strHTML = "<table id='main_table_" + GetGUID().substr(0,4) + "' border=1 cellpadding=0 cellspacing=0 width=100% height=110px style='table-layout:fixed;'>";
            strHTML += "<tr id='main_row'>";
            strHTML += "<TD id='td0" + GetGUID().substr(0,3) + "' vAlign=top><table border=1 cellpadding=0 cellspacing=0 width=100% valign=top>";
            strHTML += "<TBODY><TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR></tbody>";
            strHTML += "</table></td></tr></table>";

            var newrow = eval(selectedCell).children.item(0).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
            //var newrow = eval(selectedCell).children.item(0).insertRow();
            newrow.style.width = "100%";
            newrow.style.height = "100px";

            var subGetId = "subtd" + GetID();
            //var strInnerHTML = "<td id=\"" + subGetId + "\"uid=\"" + GetGUID() + "\" style=\"width:100%\" pageuid='" + GetGUID() + "' ownerpageuid='" + pageid + "' align=\"center\" onclick=\"selectsubcell(event)\" ondblclick=\"dblclicknotice()\" onkeydown=\"cellkeydown(event)\" canremove=\"1\"  canresize=\"1\"  canreplace=\"1\">" + strHTML + "</td>";
            var TD = document.createElement("TD");
            TD.setAttribute("id", subGetId);
            TD.setAttribute("uid", GetGUID());
            TD.setAttribute("style", "width:100%");
            TD.setAttribute("pageuid", GetGUID());
            TD.setAttribute("ownerpageuid", pageid);
            TD.setAttribute("align", "center");
            TD.setAttribute("canremove", "1");
            TD.setAttribute("canresize", "1");
            TD.setAttribute("canreplace", "1");
            TD.setAttribute("onclick", "selectsubcell(event)");
            TD.setAttribute("ondblclick", "dblclicknotice()");
            TD.setAttribute("onkeydown", "cellkeydown(event)");         
            TD.innerHTML = strHTML;

            newrow.appendChild(TD);
            //newrow.innerHTML = strInnerHTML;

            //var newcell = newrow.insertCell();
            //newcell.id = "subtd" + GetID();
            //newcell.uid = GetGUID();
            //newcell.pageuid = GetGUID();
            //newcell.canremove = 1;
            //newcell.canresize = 1;
            //newcell.canreplace = 1;
            //newcell.style.width = "100%";
            //newcell.align = "center"; 
            //newcell.innerHTML = strHTML;
            //selectedSubCell = "";
            //newcell.focus();
            //AttachEvents(newcell);
            document.getElementById(subGetId).focus();
            AttachEvents(document.getElementById(subGetId))
        }

        function newpage() {
            location.href = "/ezPortal/topMenu.do?mode=new";
        }

        /* 현재 이미지 관리 및 롤오버시 이미지 변환 함수 */
        var curImg = new Image;
        var oldPath = "";
        var subPath = "";
        var menuName = "";
        var tempclickmenuPath = "";
        var temppNewPath;
        var tempobj;
        
        function img_onMouseOver(pNewPath, obj) {
            temppNewPath = pNewPath;
            tempobj = obj;
            if (curImg == obj) {
                return;
            }
            else {
                oldPath = obj.src;
                obj.src = pNewPath;
                if (clickmenusub != "")
                    document.getElementById(clickmenusub).style.display = "none";
                if (clickmenuName != "" && document.getElementsByName(clickmenuName)[0].src.indexOf(pNewPath) == -1) {
                    tempclickmenuPath = document.getElementsByName(clickmenuName)[0].src;
                    document.getElementsByName(clickmenuName)[0].src = clickmenuPath;
                }
            }
            if (document.getElementById("menu_" + obj.name) != null) {
                subPath = "menu_" + obj.name;
                menuName = obj.name;
                document.getElementById("menu_" + obj.name).style.left = 0;
                document.getElementById("menu_" + obj.name).style.display = "";
                var LeftMargin = parseInt(document.getElementsByName(menuName)[0].offsetLeft);
                if (window.document.documentElement.clientWidth < document.getElementsByName(menuName)[0].offsetLeft + document.getElementById("menu_" + obj.name).clientWidth) {
                    LeftMargin = LeftMargin - (document.getElementsByName(menuName)[0].offsetLeft + document.getElementById("menu_" + obj.name).clientWidth - window.document.documentElement.clientWidth);
                    LeftMargin = LeftMargin - 30;
                }
                document.getElementById("menu_" + obj.name).style.left = LeftMargin + "px";
            }
            else {
                menuName = obj.name;
                subPath = "";
            }
        }

        function img_onMouseOut(obj){
            tempobj = obj;
            if (curImg == obj) {
                return;
            }
            else if (clickmenuPath == oldPath) {
            }
            else {
                obj.src = oldPath;
                if (tempclickmenuPath != "" && obj != document.getElementsByName(clickmenuName)[0])
                    document.getElementsByName(clickmenuName)[0].src = tempclickmenuPath;
            }
            if (subPath != "" && document.getElementById(subPath).style.display == "" && subPath != clickmenusub) {
                document.getElementById(subPath).style.display = "none";
            }
            if (clickmenusub != "")
                document.getElementById(clickmenusub).style.display = "";
        }
        

        function submenuover() {
            img_onMouseOver(temppNewPath, tempobj);
        }

        function submenuout() {
            img_onMouseOut(tempobj);
        }
        window.onresize = function () {
            if (clickmenusub != "") {
                document.getElementById(clickmenusub).style.left = 0;
                var LeftMargin = parseInt(document.getElementsByName(clickmenuName)[0].offsetLeft);
                if (window.document.documentElement.clientWidth <= document.getElementsByName(clickmenuName)[0].offsetLeft + document.getElementById(clickmenusub).clientWidth) {
                    LeftMargin = LeftMargin - (document.getElementsByName(clickmenuName)[0].offsetLeft + document.getElementById(clickmenusub).clientWidth - window.document.documentElement.clientWidth);
                    LeftMargin = LeftMargin - 30;
                }
                document.getElementById(clickmenusub).style.left = LeftMargin + "px";
            }
        }

        function sub_toggle(subfolder)
        {
            try
            {
                for (var i=0; i<subfolder.parentElement.children.length; i++)
                {
                    subfolder.parentElement.children.item(i).style.display = "none";
                }
            
                subfolder.style.display = "block";      
                //subfolder.firstChild.firstChild.firstChild.click();
            }catch(e) {}
            
        }
        
        function submenuclick(pSubMenuID)
        {
            
        }
        
        function layoutmode()
        {
            for (var i=0; i<document.getElementsByTagName("tr").length; i++)
            {
                var evtHandler = document.getElementsByTagName("tr").item(i).onclick;
                if (evtHandler != null && evtHandler.toString().indexOf("selectcellTitle") > -1)
                {
                    document.getElementsByTagName("tr").item(i).style.display = "none";
                }
            }
        }

        function editingmode()
        {
            for (var i = 0; i < document.getElementsByTagName("tr").length; i++)
            {
                var evtHandler = document.getElementsByTagName("tr").item(i).onclick;
                if (evtHandler != null && evtHandler.toString().indexOf("selectcellTitle") > -1)
                {
                    document.getElementsByTagName("tr").item(i).style.display = "";
                }
            }
        }
        
        function resizeTable()
        {
            if (selObjClass == "TABLE")
            {
                if (selectedCell == "")
                {
                    alert("변경할 셀을 선택해 주십시요.");
                    return;
                }
                
                // 현재 선택된 cell
                var cell = eval(selectedCell);
                
                if (txtWidth.value != "*" && txtWidth.value != "")
                {
                    if (!is_num(txtWidth.value))
                    {
                        alert("너비에 숫자를 입력해 주십시요.");
                        return;
                    }
                    cell.style.width = document.getElementById("txtWidth").value;
                    cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = document.getElementById("txtWidth").value + "px";
                }
                
                var tblObject = eval(GetMainTable(eval(selectedCell)));
                
                if (typeof(tblObject) == "undefined")
                    return;
                
                if (!is_num(txtHeight.value))
                {
                    alert("높이에 숫자를 입력해 주십시요.");
                    return;
                }
                tblObject.height = document.getElementById("txtHeight").value;
                tblObject.parentElement.parentElement.style.height = document.getElementById("txtHeight").value + "px";
            }
            else if (selObjClass == "CONTENTS")
            {
                if (selectedSubCell == "")
                {   
                    alert("행을 선택하세요.");
                    return;
                }

                var cell = eval(selectedSubCell);
                
                if (cell.getAttribute("canresize") != 1)
                {
                    alert("선택하신 행은 크기를 변경할 수 없습니다.");
                    return;
                }
                
                try {
                    cell.parentElement.style.height = document.getElementById("txtHeight").value + "px";
                } catch(e) { alert }
            }
            else
            {
                alert("선택된 셀이 없습니다.");
            }
            
            //event.cancelBubble = true;
        }
        
        // 통합검색
        function Search()
        {
            txtSearch.value = TrimText(ReplaceText(txtSearch.value, "'", ""));
            var pSearchString = txtSearch.value;
            
            
            parent.frames["main"].location.href = "/myoffice/ezsearch/index_search.aspx?Keyword=" + escape(pSearchString);
        }
        function keyword_Clear(obj) {
            obj.value = "";
        }
        function Key_event(e,obj)
        {
            var curevent = (typeof event == 'undefined' ? e : event)
                if (curevent.keyCode == "13") {
                    Emp_Search();
                }
        }

        function input_Onblur(obj)
        {
            if (obj.value.length == 0) { obj.className = 'input_text' } else { obj.className = 'input_text focusnot' }
        }
        // 직원조회
        function Emp_Search() {
            if (document.getElementById('input_search').value != "") {
                var wHeight = 550;
                var wWidth = 750;
                var wVertical = Math.floor(screen.height / 2) - (wHeight / 2);
                var wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);

                window.open("/ezPersonal/personSearch.do?searchString=" + document.getElementById('input_search').value, "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status=no, toolbar=no, menubar=no,location=no, resizable=0");

                document.getElementById('input_search').value = '';
            }
        }
        
        // 2009.11.27 - 팝업창의 위치를 선택할 수 있는 기능 추가
        function openPopup(popup_number, wWidth, wHeight, wPosition)
        {
            var wVertical, wHorizontal;
            if(wPosition == 0)
            {
                wVertical = Math.floor(screen.height/2) - (wHeight/2); 
                wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
            }
            else if(wPosition == 1)
            {
                wVertical = 100; 
                wHorizontal = 100;
            }
            else if(wPosition == 2)
            {
                wVertical = screen.height - wHeight - 100; 
                wHorizontal = 100;
            }
            else if(wPosition == 3)
            {
                wVertical = 100; 
                wHorizontal = screen.width - wWidth - 100;
            }
            else if(wPosition == 4)
            {
                wVertical = screen.height - wHeight - 100; 
                wHorizontal = screen.width - wWidth - 100;
            }
            else if(wPosition == 5)
            {
                wVertical = 100; 
                wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
            }
            else if(wPosition == 6)
            {
                wVertical = screen.height - wHeight - 100; 
                wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
            }
            else
            {
                wVertical = 0; 
                wHorizontal = 0;
            }

            if(wVertical < 0)
                wVertical = 0;

            if(wHorizontal < 0)
                wHorizontal = 0;

            if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1)
                wHeight = eval(wHeight) - 60;

            window.open("/admin/ezPersonal/showPopup.do?itemSeq=" + popup_number + 
                    "&answer=", "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
        }
    
        var clickmenusub = "";
        var clickmenuPath = "";
        var clickmenuName = "";
        function OpenWindow(evt, url, location, option) {
            if (option != "") {
                var width = 0, height = 0;
                var leftPosition = "", topPosition = "";
                var opt = option.split(',');
                for (var i = 0 ; i < opt.length ; i++) {
                    if (opt[i].indexOf('height') > -1) {
                        height = opt[i].substring(opt[i].indexOf('=') + 1, opt[i].indexOf('px'))
                        var top = (window.screen.height / 2) - ((height / 2) + 50);
                        topPosition = ", top=" + top + ", screenY=" + top;
                    }
                    if (opt[i].indexOf('width') > -1) {
                        width = opt[i].substring(opt[i].indexOf('=') + 1, opt[i].indexOf('px'))
                        left = (window.screen.width / 2) - ((width / 2) + 10);
                        leftPosition = ", left=" + left + ", screenX=" + left;
                    }
                }
                option = option + topPosition + leftPosition;
            }
            if (evt != undefined) {
                var targetid = evt.target ? evt.target.id : event.srcElement.id;
                if (targetid != "") {
                    clickmenusub = subPath;
                    if (menuName != clickmenuName) {
                        clickmenuPath = oldPath;
                        clickmenuName = menuName;
                    }
                }
            }
            window.open(url, location, option);
        }
        </script>
    </head>
            
        <body > 
        
        <div id="objectDiv"></div>
        <div id= 'top'>
            <header>
                <div class='logo'>
                    <img src='/files/upload_portal/S907000/Logo/logo.gif' style='cursor:pointer' onclick='OpenWindow(event, " ", " ", " ")' width='106' height='45'>
                </div>
                <article class='utmenu'>
                    <ul>
                        
                            <li ><span style='cursor:pointer' onclick='OpenWindow(event, "/admin/main.do", "", "")'>관리자</span></li>
                        
                        <li ><span style='cursor:pointer' onclick='OpenWindow(event, "/ezPersonal/personSearch.do", "null", "height=550px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0")'>직원조회</span></li>
                        <li ><span style='cursor:pointer' onclick='OpenWindow(event, "/ezPortal/environmentMain.do", "main", "")'>환경설정</span></li>
                        <li class='btn_logout'><span style='cursor:pointer' onclick='top.location.href = "/user/login/actionLogout.do"'>로그아웃</span></li>
                    </ul>
                </article>
                <div class='top_search'>
                    <input id='input_search' class='input_text' type='text' onfocus="this.className='input_text focus'; " onblur='input_Onblur(this)' onkeyup='Key_event(event);' onmousedown='keyword_Clear(this);' /><input type='image' src='/images/kr/cm/top_search_btn.gif' alt='' class='topsearch_btn' onclick="Emp_Search()">
                </div>
            </header>
            <nav>
                <ul class='topmenu'>
            <!--        <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu01.gif' id="top_menu01" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu01o.gif', this);" onmouseout="img_onMouseOut(this);" name='cf34747c-d809-461d-93d9-e50486ae3b68' style='cursor:pointer' onclick='OpenWindow(event, "/ezPortal/myPortal.do", "main", " ")' width='86' height='33'>
                    </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu02.gif' id="top_menu02" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', this);" onmouseout="img_onMouseOut(this);" name='09e1d12c-5ffd-4240-8791-020431a5c47b' style='cursor:pointer' onclick='OpenWindow(event, "/ezEmail/mailMain.do", "main", " ")' width='94' height='33'>
                        </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu03(4).gif' id="top_menu03(4)" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu03o(8).gif', this);" onmouseout="img_onMouseOut(this);" name='6cdb78b7-ae72-48ce-990f-5c0f6838fbbc' style='cursor:pointer' onclick='OpenWindow(event, "/ezSchedule/scheduleIndex.do?funCode=2", "main", " ")' width='121' height='33'>
                        </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu04.gif' id="top_menu04" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu04o.gif', this);" onmouseout="img_onMouseOut(this);" name='c1d31831-98a4-4c0a-9815-6c71ea9ff4d0' style='cursor:pointer' onclick='OpenWindow(event, "/myoffice/ezApproval/index_approval.aspx", "main", " ")' width='123' height='33'>
                    </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu05.gif' id="top_menu05" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu05o.gif', this);" onmouseout="img_onMouseOut(this);" name='1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d' style='cursor:pointer' onclick='OpenWindow(event, "/EgovPageLink.do?menuNo=11&link=ezBoard%2FboardMain", "main", " ")' width='110' height='33'>
                    </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu09(16).gif' id="top_menu09(16)" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu09o(21).gif', this);" onmouseout="img_onMouseOut(this);" name='f5c278f0-b62d-4437-8b08-1a81c2410497' style='cursor:pointer' onclick='OpenWindow(event, "/ezCommunity/communityMain.do", "main", " ")' width='116' height='33'>
                    </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu07.gif' id="top_menu07" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu07o.gif', this);" onmouseout="img_onMouseOut(this);" name='23ced55b-ace8-48cb-9834-19b8d9fb8d8b' style='cursor:pointer' onclick='OpenWindow(event, "/myoffice/ezKMS/index_ezkms.aspx", "main", " ")' width='122' height='33'>
                    </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu08(1).gif' id="top_menu08(1)" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu08o(1).gif', this);" onmouseout="img_onMouseOut(this);" name='e4807d84-7872-4e58-b2c6-d92d55c3d66f' style='cursor:pointer' onclick='OpenWindow(event, "/myoffice/ezDMS/index_ezDMS.aspx", "main", " ")' width='123' height='33'>
                    </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu06.gif' id="top_menu06" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu06o.gif', this);" onmouseout="img_onMouseOut(this);" name='6db81dc5-e8ba-49c8-b625-df4fd375a43a' style='cursor:pointer' onclick='OpenWindow(event, "/ezResource/resMain.do", "main", " ")' width='121' height='33'>
                    </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu04(1).gif' id="top_menu04(1)" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu04o(1).gif', this);" onmouseout="img_onMouseOut(this);" name='b39f97e9-4272-45d2-bcda-2ceb6d6e46d0' style='cursor:pointer' onclick='OpenWindow(event, "/ezApprovalG/apprGMain.do", "main", " ")' width='123' height='33'>
                    </li>
                    <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu11(4)(2).gif' id="top_menu11(4)(2)" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu11o(4)(2).gif', this);" onmouseout="img_onMouseOut(this);" name='4203ff61-93f2-4c8c-b439-3a8a8b79c767' style='cursor:pointer' onclick='OpenWindow(event, "/myoffice/ezSNS/SNSMain.aspx", "main", "null")' width='101' height='33'>
                    </li> -->
                    
                        <li>
                        <img src='/files/upload_portal/S907000/Menu/top_menu02.gif' id="top_menu02" onmouseover="img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', this);" onmouseout="img_onMouseOut(this);" name='09e1d12c-5ffd-4240-8791-020431a5c47b' style='cursor:pointer' onclick='OpenWindow(event, "/ezEmail/mailMain.do", "main", " ")' width='94' height='33'>
                    </li>   
                    
                </ul>
            </nav> 
            <div class="topSubMenu">
                <ul id="menuc509b9ce-a545-4bde-bc38-77786cd87c41" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul>
                <ul id="menu7d3b9b37-5975-4cf5-9096-1adb43f7e755" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul>
                <ul id="menu4d0e8144-011d-4483-ac42-43c179b9dc87" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul>
                <ul id="menu8a485e8a-9162-479d-a21a-fda9585e0e3e" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul>
                <ul id="menu49e1b202-c2ae-4a4d-980a-29239b3e6e14" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul>
                <ul id="menu7431401e-6b06-4363-ba5b-fc7026757d63" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul>
                <ul id="menuf31e5262-c633-4f0d-ac95-817843fc5f38" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul>
                <ul id="menu62ef609e-ab67-4b30-bde9-0412c3378290" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul>
                <ul id="menu_1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx" onmouseover="submenuover()" onmouseout="submenuout()">
                    <li class="left">
                        <li class="right"></ul><ul id="menu_09e1d12c-5ffd-4240-8791-020431a5c47b" id="menu01_sub" style="DISPLAY:none;top:0px;left:100px" onmouseover="submenuover()" onmouseout="submenuout()"><li class="left"><li onclick="javascript:submenuclick('c93e6f29-ac0a-46a4-84c2-ae809e9c7c9e');OpenWindow(event, '/ezEmail/mailMain.do?funCode=1', 'main', ' ')">메일</li>
                        <li onclick="javascript:submenuclick('8d13543c-7747-4828-a141-1e28045ff722');OpenWindow(event, '/ezEmail/mailMain.do?funCode=2', 'main', ' ')">주소록</li>
                        <li class="right"></ul><ul id="menu23ced55b-ace8-48cb-9834-19b8d9fb8d8b" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menu0fbe027c-9241-4922-bf97-cc6d10e402c9" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menue254ef6f-d602-4d40-8e39-b44177a8737c" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menu2016a429-cb39-4653-b92c-c9595c12acec" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menu8593cc87-7630-420b-a6d5-f7a8577c5a31" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menu8e9ebb41-5631-4c6f-9887-ec824464bce3" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menuf6f7ecd7-1969-4025-9bcc-bbc181e41073" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menuce2fd9b5-3934-4cba-b13f-a32d36a5d63a" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menuba0d5a0d-7ea9-469a-a981-a00e2b8825ec" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menu698d7b32-1fe1-4fcc-af02-643b08fddfce" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx"></ul><ul id="menuf5c278f0-b62d-4437-8b08-1a81c2410497" id="menu01_sub" style="DISPLAY:none;top:0px;left:nullpx">
                    </ul>
                </div>
            </div>

                       
        <!-- 표준모듈 (2007.03.15) 수정: .NET Framework 2.0에서는 RegisterStartupScript 메서드 지원하지 않음. -->
        
    
    <div id="objectProgressDiv"></div>
        
        <iframe id=ifmpopup style="display:none" src=""></iframe>
    </body>
</html>
