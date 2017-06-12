<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/email_tree.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview.htc.js"></script>	    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='main.lhm02' />" type="text/css">
	    <script type="text/javascript">
	        var pUse_Editor = "${useEditor}";
	        var subCode = "${subCode}";
	        var funcCode = "${funCode}";
	        var g_firstOpen = true;
	        var lang = "${userinfo.lang}";
	        var pNoneActiveX = "${noneActiveX}";
	        var reloadRetryCount = 1;
	        
	        document.onselectstart = function () { return false; };
	        window.onresize = function () {
	            if (document.documentElement.clientHeight > 900) {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";	                
	            }
	            else {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";	                
	            }
	        }
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            if (document.documentElement.clientHeight > 900) {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";	                
	            }
	            else {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";	                
	            }	            
	            Function_Flag(funcCode);
	            LoadAddressTree(true);
	            
	            /* 2017-05-18 장진혁 신규회람판에 클릭이벤트 생성 */ 
	            $("#newCircular").click();
	        }
	        function write_Letter() {
	            var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var conWidth = pwidth * 0.8;
	            if (conWidth > 890)
	                conWidth = 890;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 890) / 2;
	            var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            if (CrossYN() || pNoneActiveX == "YES") {
	                window.open("/ezEmail/mailWrite.do?cmd=NEW", "", feature);
	            }
	            else {
	                if (pUse_Editor == "")
	                    window.open("/ezEmail/mailWrite.do?cmd=NEW", "", feature);
	                else {
	
	                    window.open("/ezEmail/mailWrite.do?cmd=NEW", "", feature);
	                }
	            }          
	        }
	        function LoadEmailTree() {
	            var PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
	            PostTreeView.attachEvent('requestdata', requestdata);
	            PostTreeView.attachEvent('nodeselect', selectnode);
	            PostTreeView.attachEvent('nodedblclick', function () { PostTreeView.toggle(PostTreeView.selectedIndex()) });
	            PostTreeView.attachEvent('dragdrop', email_dragdrop);
	            PostTreeView.dragdrop(true);
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	            var treeconfig;
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            }
	            else
	                treeconfig = xmlHTTP.responseXML;
	
	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + document.getElementById("RootFolderXML").innerHTML + "</nodes></tree>");
	            PostTreeView.update();
	            if (subCode != "1" && subCode != "") {
	                PostTreeView.select(subCode);
	                selectnode();
	            }
	            else
	                PostTreeView.select(1);
	        }
	        function requestdata(event) {
	            if (!event) event = window.event;
	            var nodeIdx = event.nodeIdx;
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	            var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, true);
	            PostTreeView.putchildxml(nodeIdx, childxml);
	        }
	        function selectnode() {
	            var nodeIdx = PostTreeView.selectedIndex();
	            var href = PostTreeView.getvalue(nodeIdx, "href");
	            var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(PostTreeView.getvalue(nodeIdx, "foldername")) + "&url=" + encodeURIComponent(PostTreeView.getvalue(nodeIdx, "href"));
	            try {
	                if (typeof (parent.frames["right"]) != "undefined")
	                    parent.frames["right"].Window_onunload();
	            } catch (e) { }
	            if (g_firstOpen)
	                g_firstOpen = false;
	            else
	                window.open(url, "right");
	            get_unreadcount();
	        }
	        function email_dragdrop(event) {
	            if (!event) event = window.event;
	            var nodeIdx = event.nodeIdx;
	
	            var szCommand = (event.bctrl) ? "copy" : "move";
	            var szSubCommand = event.command;
	
	            if (CrossYN()) {
	                if (szCommand == "move" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").move_on_dragdrop(PostTreeView.getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	                else if (szCommand == "copy" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").copy_on_dragdrop(PostTreeView.getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	            }
	            else {
	                if (szCommand == "move" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").document.Script.move_on_dragdrop(PostTreeView.getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	                else if (szCommand == "copy" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").document.Script.copy_on_dragdrop(PostTreeView.getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	            }
	        }
	        var xmlHTTP_Unread = null;
	        function get_unreadcount_2010() {
	            if (xmlHTTP_Unread != null)
	                return;
	            try {
	                xmlHTTP_Unread = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "URL", PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"));
	                xmlHTTP_Unread.open("POST", "/ezEmail/getFolderUnreadCount.do", true);
	                xmlHTTP_Unread.onreadystatechange = get_unreadend_2010;
	                get_unreadend_2010.href = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	                xmlHTTP_Unread.send(xmlpara);
	            }
	            catch (e) {
	                xmlHTTP_Unread = null;
	            }
	        }
	        function get_unreadend_2010() {
	            if (xmlHTTP_Unread == null || xmlHTTP_Unread.readyState != 4)
	                return;
	            if (xmlHTTP_Unread.status >= 200 && xmlHTTP_Unread.status < 300) {
	                var unreadcount = getNodeText(SelectNodes(xmlHTTP_Unread.responseXML, "DATA")[0]);
	                var caption = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	
	                if (get_unreadend_2010.href == PostTreeView.getvalue(PostTreeView.selectedIndex(), "href")) {
	                    if (unreadcount == "0") {
	                        PostTreeView.putcaption(PostTreeView.selectedIndex(), caption);
	                    }
	                    else {
	                        PostTreeView.putcaption(PostTreeView.selectedIndex(), caption + "(" + unreadcount + ")");
	                    }
	                    
	                    var pageTitle = parent.frames["right"].document.title;

	                    if (pageTitle == "mail_list") {
                        	try { parent.frames["right"].mailBoxInfo.childNodes.item(1).innerText = " " + unreadcount + " "; } catch (e) { }
	                    }
	                    
	                    xmlDom = null;
	                }
	            }
	            xmlHTTP_Unread = null;
	        }
	        function get_unreadcount() {
	            return get_unreadcount_2010();
	        }
	        function check_pop3() {
	            var OpenWin = window.open("/ezEmail/mailGetPop3.do", "mail_getpop3_cross", GetOpenWindowfeature(460, 360));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function mail_exportall() {
	            var param = { "href": new Array(), "parent": new Object(), "url": new String() };
	            param["name"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	            param["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            var feature = "dialogWidth:480px; dialogHeight:265px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
	            feature = feature + GetShowModalPosition(480, 265);
	            window.showModalDialog("/myoffice/ezEmail/htm/mail_exportall.aspx", param, feature);
	        }
	        
	        /* var mail_foldermanage_Cross_dialogArguments = new Array();
	        function folder_manage() {
	            mail_foldermanage_Cross_dialogArguments[1] = folder_manager_after;
	            var OpenWin = window.open("/ezEmail/mailFolderManage.do", "mail_foldermanage_Cross", GetOpenWindowfeature(500, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        } */
	        
	        function folder_manager_after(RtnVal) {
	            if (RtnVal) {
	                var href = PostTreeView.getvalue(1, "href");
	                var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(PostTreeView.getvalue(1, "foldername")) + "&url=" + encodeURIComponent(PostTreeView.getvalue(1, "href"));
	                PostTreeView.source("<tree><nodes>" + get_childXML("", true, true) + "</nodes></tree>");
	                PostTreeView.update();
	                if (PostTreeView.selectedIndex() == -1) {
	                    PostTreeView.select(1);
	                }
	                window.open(url, "right");
	            }
	        }
	        function Function_Flag(v_data) {
	            v_data = parseInt(v_data);
	
	            switch (v_data) {
	                case 1:
	                    LoadEmailTree();
	                    break;
	                case 2:
	                    LoadEmailTree();
	                    WebPartToggle(level1El.item(1));
	                    break;
	            }
	        }
	        function WebPartToggle(obj) {
	
	            if (obj.listNum && currentListNum != obj.listNum + 1) {
	                level1El.item(currentListNum - 1).className = null;
	                level2El.item(currentListNum - 1).className = "off";
	            }
	
	            if (level2El.item(obj.listNum).className == "on") {
	                level1El.item(obj.listNum).className = null;
	                level2El.item(obj.listNum).className = "off";
	            }
	            else {
	                level1El.item(obj.listNum).className = "on";
	                level2El.item(obj.listNum).className = "on";
	            }
	
	            currentListNum = obj.listNum + 1;
	
	            setMenu(level2El.item(obj.listNum));
	        }
	        function TreeView_toggle(TreeView, TreeFunc, subfolder) {
	            if (TreeView.style.display == "none") {
	                if (typeof (subfolder) != "undefined")
	                    TreeFunc(subfolder);
	                else
	                    TreeFunc();
	            }
	            else
	                TreeView.style.display = "none";
	        }
	        function Open_Mail(treeid) {
	            PostTreeView.select(treeid);
	        }
	        function Open_Search() {
	            try {
	                var url;
	                url = "/ezEmail/mailSearchView.do";
	                window.open(url, "right");
	            } catch (e) { }
	        }
	        function Open_ReservationManage() {
	            var OpenWin = window.open("/ezEmail/mailReservation.do", "mail_reservation_cross", GetOpenWindowfeature(501, 350));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function Open_Restore() {
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 500) / 2;
	            var pLeft = (pwidth - 700) / 2;
	            var name = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	            var path = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            var OpenWin;
	            if (!CrossYN())
	                OpenWin = window.open("/myoffice/ezEmail/mail_restore_deleted.aspx?name=" + encodeURIComponent(name) + "&path=" + encodeURIComponent(path), "mail_restore_deleted", GetOpenWindowfeature(700, 490));
	            else
	                OpenWin = window.open("/myoffice/ezEmail/mail_restore_deleted_cross.aspx?name=" + encodeURIComponent(name) + "&path=" + encodeURIComponent(path), "mail_restore_deleted", GetOpenWindowfeature(700, 490));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function spam_mail() {
	            frmSpam.target = "right";
	            frmSpam.submit();
	        }
	        function mail_export() {
	            try {
	                parent.frames["right"].mail_export();
	            } catch (e) {
	                alert("<spring:message code="ezEmail.t640" />");
	            }
	        }
	        function mail_exportall() {
	            var param = { "href": new Array(), "parent": new Object(), "url": new String() };
	            param["name"] = PostTreeView.getvalue(PostTreeView.selectedIndex, "foldername");
	            param["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex, "href");
	            param["parent"] = window.parent.frames("right");
	            var feature = "dialogWidth:480px; dialogHeight:265px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
	            feature = feature + GetShowModalPosition(480, 265);
	            window.showModalDialog("/myoffice/ezEmail/htm/mail_exportall.aspx", param, feature);
	        }
	        var mail_import_cross_dialogArguments = new Array();
	        function mail_import() {
	            var param = { "foldername": new Array(), "href": new Object() };
	            param["foldername"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	            param["href"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            mail_import_cross_dialogArguments[0] = param;
	            mail_import_cross_dialogArguments[1] = mail_import_Complete;
	            var OpenWin = window.open("/ezEmail/mailImport.do", "mail_foldermanage_Cross", GetOpenWindowfeature(500, 400));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function mail_import_Complete() {
	        	if (typeof (window.parent.frames["right"].MailListRefresh) == "function")
	                window.parent.frames["right"].MailListRefresh();
	            PostTreeView.source("<tree><nodes>" + get_childXML("", true, true) + "</nodes></tree>");
	            PostTreeView.update();
	            if (PostTreeView.selectedIndex() == -1) {
	                PostTreeView.select(1);
	            }
	        }
	        function mail_Config() {
	            parent.frames["right"].location.href = "/ezEmail/mailConfig.do";
	        }
	        function Address_Menu_Click() {
	            /* LoadAddressTree(true);
	            if (AddressTreeView.selectedIndex() == -1)
	                AddressTreeView.select(1);
	            else
	                selectnode_address(); */
	        }
	        //var AddressTreeView = null;
	        function LoadAddressTree() {
	            /* if (AddressTreeView == null) {
	                AddressTreeView = new TreeView('AddressTreeView', 'AddressTreeView');
	
	                AddressTreeView.attachEvent('requestdata', requestdata_address);
	                AddressTreeView.attachEvent('nodeselect', selectnode_address);
	                AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
	            }
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	            var treeconfig;
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            }
	            else {
	                treeconfig = new ActiveXObject("Microsoft.XMLDOM");
	                treeconfig.async = false;
	                treeconfig.loadXML(xmlHTTP.responseText);
	            }
	            AddressTreeView.config(treeconfig);
	            AddressTreeView.source(document.getElementById("AddressFolderXML").innerHTML);
	            AddressTreeView.update();
	
	            if (funcCode == "2") {
	                if (subCode != "1" && subCode != "") {
	                    AddressTreeView.select(subCode);
	                    selectnode_address();
	                }
	                else
	                    AddressTreeView.select(1);
	            } */
	        }
	        function requestdata_address(event) {
	            if (!event) {
	                event = window.event;
	            }
	
	            var nodeIdx = event.nodeIdx;
	
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	
	            /* var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"))
	            AddressTreeView.putchildxml(nodeIdx, childxml); */
	        }
	        function selectnode_address() {
	            /* var nodeIdx = AddressTreeView.selectedIndex();
	            var url = "/ezAddress/addressMainList.do?folderid=" + encodeURIComponent(AddressTreeView.getvalue(nodeIdx, "folderid")) + "&type=" + encodeURIComponent(AddressTreeView.getvalue(nodeIdx, "type"));
	            window.open(url, "right"); */
	        }
	        var address_foldermanage_dialogArguments = new Array();
	        function address_foldermanage() {
	            address_foldermanage_dialogArguments[1] = address_foldermanage_Complete;
	            var OpenWin = window.open("/ezAddress/addressFolderManage.do", "address_foldermanage", GetOpenWindowfeature(450, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function address_foldermanage_Complete(ret) {
	            if (ret != undefined) {
	            	var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("GET", "/ezAddress/getRootAddressXML.do", false);
		            xmlHTTP.send();
	            	
		            document.getElementById("AddressFolderXML").innerHTML = xmlHTTP.responseText;
	            	LoadAddressTree();
	            }
	        }
	        function address_Search() {
	            window.open("/ezAddress/addressMainSearch.do", "right");
	        }
	        function Email_Menu_Click() {
	            PostTreeView.select(1);
	        }
	        
	        /* 2017-05-17 장진혁 구현 */	        
	        function openFolder() {
	        	if ($("#PostTreeView").height() != "0"){	        	
		        	$("#PostTreeView").height("0px");	        	
		        	$("#PostTreeView").css("padding","0px");
		        	$("#openImg").attr("src", "/images/expnd.gif");
		        	$("#circularDoc").css("border-bottom", "0px");
	        	} else {
	        		$("#PostTreeView").height("200px");	        	
		        	$("#PostTreeView").css("padding","10px 20px");
		        	$("#openImg").attr("src", "/images/cllps.gif");
		        	$("#circularDoc").css("border-bottom", "1px solid #dedede");
	        	}
	        }
	        
	        function folder_Manage() {
	        	var OpenWin = window.open("/ezCircular/circularFolderManage.do", "", GetOpenWindowfeature(500, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        
	        function TopBoard_onclick(obj, ID) {
	            AccessLevel = "1";
	            var rootBoardID = ID;
	            SelectedBoardID = ID;
	            SelectedBoardGroupID = ID;
	            SelectedBoardParentBoardID = 'top';
	            var num = obj.split("TreeCtrl");
	            document.getElementById(obj + "obj").innerHTML = "";
	            SetTreeConfig();
	            var treeView = new TreeView();
	            treeView.SetID("TreeView" + obj);
	            treeView.SetRequestData("TreeCtrl_onNodeExpanded");
	            treeView.SetNodeClick("TreeCtrl_onNodeClick");            
	            treeView.DataSource(GetSubBoard(rootBoardID, "1"));
	            treeView.DataBind(obj + "obj");
	        }
	        
	        /* 2017-05-17 정수현 구현 */
	        function newCircular() {                
	        	window.parent.frames["right"].location.href = "/ezcircular/newCircular.do";
	        }
	        
	        function circularComplete() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularComplete.do";
	        }
	        
	        function circularMyCircular() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularMyCircular.do";
	        }
	        
	        function circularTemp() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularTemp.do";
	        }
	        
	        function circularDelete() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularDelete.do";
	        }
	        
	        function circularConfig() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularConfig.do";
	        }
	    </script>
	</head>
	<body class="leftbody" style="overflow: hidden;">
	    <div id="left">
	        <div class="left_mail" title="회람판"></div>
	        <h2><span style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t1" /></span></h2>				
	        <ul id="iconul">
	        	<li><span style="width:100%;display:inline-block;" id="newCircular" onClick="newCircular()"><img src="/images/ImgIcon/icon_approval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t2" /><span id=count1></span></span></li>
				<li><span style="width:100%;display:inline-block;" id="circularComplete" onClick="circularComplete()"><img src="/images/ImgIcon/icon_ingapproval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t3" /></span></li>
				<li><span style="width:100%;display:inline-block;" id="circularMyCircular" onClick="circularMyCircular()"><img src="/images/ImgIcon/icon_writeapproval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t4" /></span></li>				
				<li><span style="width:100%;display:inline-block;" id="circularTemp" onClick="circularTemp()"><img src="/images/ImgIcon/icon_extraappr.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t5" /></span></li>
				<li><span style="width:100%;display:inline-block;" id="circularDelete" onClick="circularDelete()"><img src="/images/ImgIcon/deleted.gif" width="16" height="16" class="icon" style="margin-left:-1px"><span style="margin-left:1px"><spring:message code="ezCircular.t6" /></span></span></li>
				<li id="circularDoc"><span style="width:100%;display:inline-block;" onClick="openFolder()"><img src="/images/ImgIcon/icon_partapproval.gif" width="16" height="16" class="icon"><span><spring:message code="ezCircular.t7" /></span>&nbsp;&nbsp;<img src="/images/cllps.gif" id="openImg" class="icon"></span></li>	        
	            <div class="tree" style="height: 200px; background-color: #ffffff; border-bottom: 1px solid #dedede; overflow: auto; padding-left: 20px;" id="PostTreeView"></div>
	            	<!--<script>		
				    	var strHTML = "", data = "";
						var cnt = 0;	        		
						
						$.ajax({
							type : "POST",
							dataType : "json",
							async : false,
							url : "/ezCircular/getTopFolder.do",	        			
							data : { boardType : "top"},
							success: function(result){
								$.each(result, function(idx, item){	        					
									$.each(item, function(idx, i){
										strHTML += "<h2><div AccessLevel='1' id='TreeCtr" + idx + "' value='" + i.boardId;
				                        strHTML += "' onclick=\"TopBoard_onclick('TreeCtrl" + idx + "','" + i.boardId + "')\">";
				                        strHTML += i.boardName + "</div></h2>";
				                        strHTML += "<ul><div class='tree' name='BoardTree' id='TreeCtrl" + idx + "obj' style='width: auto; overflow: auto; padding-left: 10px; padding-bottom: 20px; max-height: 200px;'>";
				                        strHTML += "</div></ul>";
									});
									cnt = item.length;
									data = item[0].boardId;
								});
								$("#TopBoard").html(strHTML);
				
				                if (cnt > 0){         	
									TopBoard_onclick("TreeCtrl0", data);
				                }
							},
							error: function() {
								alert("에러발생");	
							}
						});
						
						initToggleList(document.getElementById("left"), "h2", "ul", "li");
					</script> -->
	            <li style="background: url('/images/kr/left/left_dot02.gif') no-repeat 25px 9px #fff;padding: 8px 5px 7px 40px"><span onclick="" style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t8" /></span></li>
	            <li style="background: url('/images/kr/left/left_dot02.gif') no-repeat 25px 9px #fff;padding: 8px 5px 7px 40px"><span onclick="folder_Manage()" style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t9" /></span></li>	            
	        </ul>	        
	        <h3><span onclick="circularConfig()" style="width:100%;display:inline-block;"><spring:message code="ezCircular.t10" /></span></h3>
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    <xml id="RootFolderXML" style="display: none;">
	    	${rootFolderXML}
	    </xml>
	</body>
</html>