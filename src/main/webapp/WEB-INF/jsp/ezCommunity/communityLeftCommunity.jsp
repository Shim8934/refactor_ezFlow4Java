<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_community</title>
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<script type="text/javascript">
			var ResultString;
	        var code = "<c:out value='${code}'/>";
	        var UserLevel = "<c:out value='${userLevel}'/>";
	        var ch_CommunityAdmin = "<c:out value='${fn:indexOf(userInfo.rollInfo, \'t=1\') }'/>";
	        var newmember_confirmtype = "<c:out value='${newmemberConfirmType}'/>";
	        var ch_CheckSysop = "<c:out value='${checkSysop}'/>";
	        var lang = "<c:out value='${lang}'/>";
	        var xmlDom_treeview = createXmlDom();
	        var xmlhttp = createXMLHttpRequest();
	        var ch_selected = false;
			var totalCnt = 0;
			var xmlhttp;
			var xmlhttp2;

			document.onselectstart = function () { return false; };
			window.onload = function () {
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
			    if (screen.height < 1080) {
			        if(screen.height <= 800){
			            document.getElementById("MyCopList").style.height = "135px";
			        }else{
			            document.getElementById("MyCopList").style.height = "225px";
			        }
			    }
			    try {
	                if (code != "") {
	                    window.open("/ezCommunity/commHome/popupCommHome.do?code=" + code + "&userLevel=" + UserLevel);

	                    var dropdown = document.goMyCommForm.MyCommunityList;
	                    var inx = document.goMyCommForm.MyCommunityList.length;

	                    if (!ch_selected){
	                        dropdown.value = "0";
	                    }else{
	                        dropdown.value = code;
	                    }

	                    xmlDom_treeview.async = false;
	                    xmlDom_treeview.load("/xml/common/organtree_config2.xml");
	                    DisplayTopBoard(code);
	                }else {
	                    var funCode = "${funCode}";

                    	if (funCode == "1") {
	                        GoTopNavigate("<spring:message code='ezCommunity.t863' />");
		                    window.parent.frames.right.document.location.href = "/ezCommunity/board/bbsList.do?bName=c_Notice&type=notice&userLevel=" + UserLevel;
		                    document.getElementById('Map510').click();
		                }else if (funCode == "2") {
		                    GoTopNavigate("<spring:message code='ezCommunity.t74' />");
				            window.parent.frames.right.document.location.href = "/ezCommunity/board/bbsList.do?bName=c_Board&type=board&userLevel=" + UserLevel;
				            document.getElementById('Map520').click();
				        }else if (funCode == "3") {
				            GoTopNavigate("<spring:message code='ezCommunity.t1117' />");
					        window.parent.frames.right.document.location.href = "/ezcommunity/searchKey.do?sRadio=c_ClubName&keyword=&key";
					        document.getElementById('Map530').click();
					    }else if (funCode == "4") {
					        GoTopNavigate("<spring:message code='ezCommunity.t1011' />");
				            window.parent.frames.right.document.location.href = "/ezCommunity/commMake.do";
					        document.getElementById('Map540').click();
					    }else if (funCode == "5") {
					        window.parent.frames.right.document.location.href = "/ezCommunity/searchKey.do?type=best";
					    }else {
					        GoTopNavigate("main");
					        window.parent.frames.right.document.location.href = "/ezCommunity/mainPage.do";
					    }
	        		}
				}catch (e) {
	            }
	            getCommunityList();
	            getBoardList();
	        }
			
			function getCommunityList() {
			    xmlhttp = createXMLHttpRequest();
			    xmlhttp.open("POST", "/ezCommunity/getLeftCommunity.do", true);
			    xmlhttp.onreadystatechange = getCommunityList_after;
			    xmlhttp.send();
			}
			
			function getCommunityList_after() {
			    if (xmlhttp == null || xmlhttp.readyState != 4) 
			    	return;
			    var objXML = loadXMLString(xmlhttp.responseText);
			    
			    var totalCnt = GetChildNodes(SelectSingleNodeNew(objXML, "DATA")).length;

			    if (totalCnt > 0) {
			        for (var i = 0; i < totalCnt; i++) {
			            var confirmtype1 = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "C_CLUBCONFIRMTYPE");
			            var sysopID1 = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "C_SYSOPID").trim();
			            var memberCnt1 = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "C_MEMBERCNT");
			            var code2 = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "C_CLUBNO").trim();
			            var copName = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "C_CLUBNAME");
			            if (lang != "1")
			                copName = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "C_CLUBNAME2");
			            var copLogo = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");

			            if (sysopID1 == "${userInfo.id}" || memberCnt1 >= 0) {
	                        if (confirmtype1 == 3 && confirmtype1 == 0) {
	                        }else {
	                            var _li = document.createElement("li");
	                            _li.setAttribute("code", code2);
	                            _li.onclick = function () { GoFunc(this); }
	                            var _span = document.createElement("span");
	                            _span.setAttribute("class", "thumbnail");

	                            var _img = document.createElement("img");
	                            _img.style.width = "33px";
	                            _img.style.height = "33px";
	                            if (copLogo.indexOf("default_logo_type") > -1)
	                                _img.setAttribute("src", "/images/ezCommunity/logo/" + copLogo);
	                            else
	                                _img.setAttribute("src", "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYLOGO&fileName=" + encodeURIComponent(copLogo));

	                            _span.appendChild(_img);
	                            _li.innerHTML = _span.outerHTML + copName;
	                            document.getElementById("list_thumbnail").appendChild(_li);
	                        }
	                    }
	                }
	            }
	        }
			
			function getBoardList() {
	            xmlhttp2 = createXMLHttpRequest();
	            xmlhttp2.open("POST", "/ezCommunity/getLeftBoardList.do", true);
	            xmlhttp2.onreadystatechange = getBoardList_after;
	            xmlhttp2.send();
	        }
			
			function getBoardList_after() {
	            if (xmlhttp2 == null || xmlhttp2.readyState != 4) {
	            	return;
	            }
	            
	            var objXML = xmlhttp2.responseXML;

	            document.getElementById("list_communitynoti").innerHTML = "";
	            var totalCnt = GetChildNodes(SelectSingleNodeNew(objXML, "DATA")).length;
	            
	            if (totalCnt > 0) {
	                for (var i = 0; i < totalCnt; i++) {
	                    if ((screen.height <= 800 && i >= 4) || (screen.height < 1080 && i >= 7)) {
	                        break;
	                    }
	                    
	                    var title = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "TITLE");
	                    var boardNum = SelectSingleNodeValue(SelectNodes(objXML, "DATA/ROW")[i], "NO");
	                    var _li = document.createElement("li");
	                    _li.setAttribute("onClick", "btn_bbsView(" + boardNum + ",'c_board')");
	                    
	                    if (CrossYN()){
	                        _li.textContent = title;
	                    }else{
	                        _li.innerText = title;
	                    }

	                    document.getElementById("list_communitynoti").appendChild(_li);
	                }
	            }
	        }

	        function btn_bbsView(sURL, ttt) {
	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 350;
	            pwidth = pwidth - 350;

	            window.open("/ezCommunity/board/bbsViewNew.do?mode=content&no=" + sURL + "&bName=" + ttt, "<spring:message code='ezCommunity.t166' />", "width=760,height=720,top=" + pheigth + ",left=" + pwidth);
	        }

	        function DisplayTopBoard(code) {
	            return; 
	            xmlhttp.open("POST", "/ezCommunity/getSubBoards.do?rootBoardID=top&subFlag=0&classID=" + code, false);
	            xmlhttp.send();

	            if (xmlhttp.responseXML.text != "ERROR") {
	                MakeTopBoardView(xmlhttp.responseXML.xml);
	            }
	        }

	        function MakeTopBoardView(strXML) {
	            var xmldom = createXmlDom();
	            var strHTML = "";
	            xmldom.async = false;
	            xmldom.preserveWhiteSpace = true;
	            xmldom.loadXML(strXML);

	            strHTML = "";
	            var xmldomNodes = xmldom.selectNodes("TREEVIEWDATA/NODE");
	            for (i = 0; i < xmldomNodes.length; i++) {
	                strHTML += "<table cellpadding=0 cellspacing=0 style='table-layout:fixed;width:100%;border:0px;'>";
	                strHTML += "	<TR>";
	                strHTML += "<td align='right' width='15'><IMG hspace='5' src='/images/dot_03.gif' width='9' height='7'></td>";
	                strHTML += "		<TD class='leftmenu'>";
	                strHTML += "			<span id='" + xmldomNodes.item(i).selectSingleNode("DATA1").text + "' onclick='TopBoard_onclick()' style='cursor:pointer'>&nbsp;" + xmldomNodes.item(i).selectSingleNode("DATA2").text + "</span>";
	                strHTML += "		</TD>";
	                strHTML += "	</TR>";
	                strHTML += "	<tr id='TreeArea' style='display:none;background:#ffffff'>";
	                strHTML += "		<td colspan=2 style=padding-left:5px; padding-bottom:5px>";
	                strHTML += "			<DIV id='TreeCtrl" + i.toString() + "' ;overflow-x:auto;margin-left:5px'></DIV>";
	                strHTML += "		</td>";
	                strHTML += "	</tr>";
	                if (xmldomNodes.length != 1 && (i + 1) != xmldomNodes.length){
	                    strHTML += "	<tr><td height='1' colspan='2' class='dotted'></td></tr>";
	                }
	                strHTML += "</table>";
	            }

	            xmldomNodes = null;
	            xmldom = null;

	            TopBoardsList.innerHTML = strHTML;

	        }

	        function TopBoard_onclick(obj, ID) {
	            document.getElementById(obj + "obj").innerHTML = "";
	            SetTreeConfig();
	            var treeView = new TreeView();
	            treeView.SetID("TreeView" + obj);
	            treeView.SetRequestData("TreeCtrl_onNodeExpanded");
	            treeView.SetNodeClick("TreeCtrl_onNodeClick");
	            treeView.DataSource(GetSubBoard(ID, "1"));
	            treeView.DataBind(obj + "obj");
	        }

	        function SetTreeConfig() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
	            xmlHTTP.send();

	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200){
	                var treeView = new TreeView();
	                treeView.SetConfig(xmlHTTP.responseXML);
	            }
	        }

	        function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
	            var xmlRtn = createXmlDom();
	            var TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1");

	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }

	        function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
	            try {
	                var treeNode = new TreeNode();
	                treeNode.LoadFromID(pNodeID);

	                var SelectedBoardID = treeNode.GetNodeData("DATA1");
	                var SelectedBoardParentBoardID = treeNode.GetNodeData("DATA3");
	                var chkPhotoBrd = treeNode.GetNodeData("DATA6");

	                if (chkPhotoBrd != "3"){
	                    window.parent.frames.right.location.href = "/ezCommunity/boardItemList.do?boardID=" + treeNode.GetNodeData("DATA1") + "&boardName=" + encodeURI(treeNode.GetNodeData("DATA2")) + "&code=" + code;
	                }else{
	                    window.parent.frames.right.location.href = "/ezCommunity/boardItemListPhoto.do?boardID=" + treeNode.GetNodeData("DATA1") + "&boardName=" + encodeURI(treeNode.GetNodeData("DATA2")) + "&code=" + code;
	                }
	                if (CrossYN()) {
	                }
	                else {
	                    window.event.cancelBubble = true;
	                    window.event.returnValue = false;
	                }
	            }
	            catch (e) {
	                alert(e.description);
	            }
	        }
	        
	        function GetSubBoard(pRootBoardID, pSubFlag) {
	            xmlhttp.open("POST", "/ezCommunity/getSubBoards.do?rootBoardID=" + pRootBoardID + "&subFlag=" + pSubFlag + "&selectFlag=0&classID=" + code, false);
	            xmlhttp.send();

	            return xmlhttp.responseXML;
	        }
	        
	        function go_menu(btn) {
	            if (UserLevel == "") {
	                if (document.goMyCommForm.MyCommunityList.length != 0){
	                    code = document.goMyCommForm.MyCommunityList[document.goMyCommForm.MyCommunityList.selectedIndex].value.trim();
	                }
	                var dropdown = document.goMyCommForm.MyCommunityList;
	                var index = document.goMyCommForm.MyCommunityList.selectedIndex;
	            }
	            if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
	                switch (btn.id) {
	                    case "btn_QsPoll": 
	                    	window.open("/ezCommunity/commHome/poll/pollMain.do?code=" + code + "&userLevel=" + UserLevel, "right");
	                        break;
	                    case "btn_MemberInfo": 
	                    	alert("<spring:message code='ezCommunity.t1102' />");
	                		break;
			            case "btn_MemberOut": 
			            	alert("<spring:message code='ezCommunity.t1102' />");
			                break;
			            case "btn_home": 
			            	window.open("/ezCommunity/commHome/popupCommHome.do?code=" + code + "&userLevel=" + UserLevel, "right");
			                break;
			            case "btn_Pims": 
			            	window.open("schedule_main.do?code=" + code + "&userLevel=" + UserLevel, "right");
			                break;
			            case "btn_guest": 
			            	window.open("commhome/guest/guestOne.do?code=" + code, "right");
			                break;
			            case "btn_MemberIn":
			                var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=390,height=210";
			                feature = feature + GetOpenPosition(390, 210);
		
			                if (newmember_confirmtype == "2"){
			                    window.open("join1.do?no=" + code, "", feature);
			                }else if (newmember_confirmtype == "3"){
			                    window.open("join2.do?no=" + code, "", feature);
			                }
			                break;
			            case "btn_MemberJoinIng":
			                alert("<spring:message code='ezCommunity.t1102' />");
			                break;
			            default: 
			            	window.open("/ezcommunity/commHome/popupCommHome.do?code=" + code + "&userLevel=" + UserLevel, "right");
			                break;
			        }
			    }else {
			        switch (btn.id) {
			            case "btn_QsPoll": 
			            	window.open("/ezcommunity/commHome/poll/pollMain.do?code=" + code + "&userLevel=" + UserLevel, "right");
			                break;
			            case "btn_MemberInfo": 
			            	window.open("/ezcommunity/commHome/commViewMember.do?code=" + code, "right");
			                break;
			            case "btn_MemberOut":
			                if (ch_CheckSysop.toUpperCase() == "TRUE"){
			                    alert("<spring:message code='ezCommunity.t1103' />");
			                }else{
								go_MemberOut(code);
			                }
			                    break;
		                case "btn_Manager": 
		                	open_admin(code);
		                    break;
		                case "btn_home": 
		                	window.open("/ezcommunity/commHome/popupCommHome.do?code=" + code + "&userLevel=" + UserLevel, "right");
		                    break;
		                case "btn_Pims": 
		                	window.open("scheduleMain.do?code=" + code + "&userLevel=" + UserLevel, "right");
		                    break;
		                case "btn_guest": 
		                	window.open("commhome/guest/guestOne.do?code=" + code, "right");
		                    break;
			            case "btn_MemberIn":
			                    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=390,height=170";
			                    feature = feature + GetOpenPosition(390, 170);
		
			                    if (newmember_confirmtype == "2"){
			                        window.open("join1.do?no=" + code, "", feature);
			                    }else if (newmember_confirmtype == "3"){
			                        window.open("join2.do?no=" + code, "", feature);
			                    }
			                    break;
		                case "btn_MemberJoinIng":
		                    alert("<spring:message code='ezCommunity.t1102' />");
		                    break;
		                default: 
		                	window.open("/ezcommunity/commHome/popupCommHome.do?code=" + code + "&userLevel=" + UserLevel, "right");
		                    break;
		            }
		        }
		    }
	        
	        function GoTopNavigate(path_code) {
	            try {
	                var pathcode = path_code;
	                var idx = "6";
	                var navigation_info = "";
	                switch (pathcode) {
	                    case "main":
	                        navigation_info = "CoP";
	                        window.top.frames("top").document.Script.change_menu(idx, navigation_info);
	                        break;
	                    case "<spring:message code = 'ezCommunity.t73' />":
                            window.open("/ezCommunity/board/bbsList.do?bName=c_Notice&type=notice", "right");
                            break;
                        case "<spring:message code = 'ezCommunity.t74' />":
                            window.open("/ezCommunity/board/bbsList.do?bName=c_Board&type=board", "right");
                            break;
                        case "<spring:message code = 'ezCommunity.t1117' />":
                            window.open("/ezCommunity/searchKey.do?sRadio=c_ClubName&keyword=&key", "right");
                            break;
                        case "<spring:message code = 'ezCommunity.t1011' />":
                            window.open("/ezCommunity/commMake.do", "right");
                            break;
                        default:
                            break;
                    }
                } catch (e) {
                }
            }
	        
            function GoFunc(obj) {
                code = obj.getAttribute("code").trim();
                codeName = obj.innerText;
                if (code == "0") {
                    window.frames.location.href = window.frames.location.href;
                }
                else {
                    var url = "/ezCommunity/checkCommHome.do?communityCD=" + code + "&userLevel=1";
                    var wWeight = "1300";
                    var wHeight = "900";

                    var heigth = window.screen.availHeight;
                    var width = window.screen.availWidth;

                    var left = (width - wWeight) / 2;
                    var top = (heigth - wHeight) / 2 - 30;

                    var ret = window.open(url, code, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
                    try {
                    	ret.focus();
                    } catch (e) {
                    }
                }
            }
            
            function go_MemberOut(code) {
                var xmlHttp = createXMLHttpRequest();
                var xmlDoc = createXmlDom();

                var objRoot;
                createNodeInsert(xmlDoc, objRoot, "PARAMETER");

                createNodeAndInsertText(xmlDoc, objRoot, "CODE", code);
                xmlHttp.open("POST", "/ezCommunity/goAdminOk.do", false);
                xmlHttp.send(xmlDoc);

                resultXML = xmlHttp.responseXML;
                
                master = SelectNodes(resultXML, "/COMMUNITY/MASTER/VALUE").item(0).textContent;
                
                master = master.toLowerCase();
                UserID = "<c:out value = '${userInfo.id}' />'";
			    UserID = UserID.toLowerCase();
			
			    try {
			        if (UserID == master) {
			            alert("Community <spring:message code='ezCommunity.t1103' />");
			        }
			        else {
			
			            var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=425,height=385";
			            feature = feature + GetOpenPosition(425, 385);
			            var Para = window.open("/ezCommunity/commHome/commOut.do?code=" + code, "", feature);
			        }
			    } catch (e) {
			    }
			}
            
            function RReplace(value) {
                var r, re;

                re = /</g;
                r = value.replace(re, "&lt;");
                re = />/g;
                r = r.replace(re, "&gt;");

                return (r);
            }

            function isAdmin(code) {
                var xmlHttp = createXMLHttpRequest();
                var xmlDoc = createXmlDom();

                var objRoot;
                createNodeInsert(xmlDoc, objRoot, "PARAMETER");

                createNodeAndInsertText(xmlDoc, objRoot, "CODE", code);

                xmlHttp.open("POST", "/ezCommunity/goAdminOk.do", false);
                xmlHttp.send(xmlDoc);

                resultXML = xmlHttp.responseXML;

                master = SelectNodes(resultXML, "/COMMUNITY/MASTER/VALUE").item(0).textContent;
                isin = SelectNodes(resultXML, "/COMMUNITY/ISIN/VALUE").item(0).textContent;

                master = master.toLowerCase();

                UserID = "${userInfo.id}";
                UserID = UserID.toLowerCase();

                if (UserID == master)
                    return true;
                else
                    return false;
            }

                function open_admin(code) {
                    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=auto,resizable=1,width=800,height=500";
                    feature = feature + GetOpenPosition(800, 500);
                    var comm = window.open("/ezCommunity/commHome/admin/index.do?code=" + code, "", feature);
                }

            function goPage(idx) {
                var url = "";
                switch (idx) {
                    case 1:
                        url = "/ezCommunity/Board/bbsList.do?bName=c_Notice&type=notice";
                        break;

                    case 2:
                        url = "mainPage1.do";
                        break;
                }
                window.open(url, "right");
            }
            
            function List_more() {
                window.parent.frames.right.document.location.href = "/ezCommunity/board/bbsList.do?bName=c_Board&type=board&userLevel=" + UserLevel;
            }
            
            function make_Cop() {
                window.open("/ezCommunity/commMake.do", "right");
            }
		</script>
	</head>
	<body class="leftbody" id="body">
	    <div id="left">
	        <div class="left_cop" title="Community"></div>
	        <!-- mylist -->
	        <h2 class="community_lt">
	        	<span><img src="/images/kr/left/icon_dialog.gif"></span>
	        	<spring:message code='ezCommunity.t2000' />
	        </h2>
	        <div style="overflow: auto; overflow-x: hidden; height: 270px;" id="MyCopList">
	            <!-- list -->
	            <ul class="list_thumbnail" id="list_thumbnail">
	            </ul>
	            <!-- list -->
	        </div>
	
	        <!--/ mylist -->
	        <!-- notice -->
	        <h2 class="community_lt">
	        	<span><img src="/images/kr/left/icon_speaker.gif"></span>
	            <spring:message code='ezCommunity.t2001' />
	            <span class="btn_right" onclick="List_more()"><img src="/images/kr/community/btn_cmmore.gif"></span>
	        </h2>
	        <div class="divwrap">
	            <ul class="list_communitynoti" id="list_communitynoti">
	                <!-- 최대10개 -->
	            </ul>
	            <p class="bland_border"></p>
	        </div>
	        <!-- /notice -->
	
	        <div class="community_banner" onclick="make_Cop()">
	            <img src="<spring:message code='ezCommunity.i4' />" width="181" height="90">
	        </div>
    	</div>
	</body>
</html>