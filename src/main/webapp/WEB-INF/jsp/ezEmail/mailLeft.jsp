<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>left_myoffice</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email_tree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/address_tree_Cross.js')}"></script>
	    <!-- 재은 수정 -->
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/NewMailList.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <script type="text/javascript">
	        var pUse_Editor = "${useEditor}";
	        var subCode = "${subCode}";
	        var funcCode = "${funCode}";
	        var g_firstOpen = true;
	        var lang = "${userinfo.lang}";
	        var pNoneActiveX = "${noneActiveX}";
	        var reloadRetryCount = 1;
	      	var previewSubTree = "${previewSubTree}";
	      	var usePreviewSubTree = "${usePreviewSubTree}";
	      	var useBottomFrameOnly = "${useBottomFrameOnly}";
	      	var useMailBoxBackUp = "${useMailBoxBackUp}";
	      	var useMailReceiveScreen = "${useMailReceiveScreen}";
	      	var operatorMailAddress = "${operatorMailAddress}";
	      	var shareId = "";
	      	var deletePermission = "";
	      	var sendPermission = "";
	      	var treeviewStr = "PostTreeView";
	      	
	        document.onselectstart = function () { return false; };
	        window.onresize = function () {
	        	/* 2018-05-23 이소담 - 편지함 목록 스크롤 제거 
	            if (document.documentElement.clientHeight > 900) {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";
	                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.58 + "px";
	            }
	            else {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";
	                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.38 + "px";
	            }*/
	        	
	        }
	        
	        window.onload = function () {
			    
	        	detailView();
		    	
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            /* 2018-05-23 이소담 - 편지함 목록 스크롤 제거 
	            if (document.documentElement.clientHeight > 900) {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";
	                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.58 + "px";
	            }
	            else {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";
	                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.58 + "px";
	            } */
	            Function_Flag(funcCode);
	            LoadAddressTree(true);
	            previewSubTreeCall();
	        }
	        
	        /**
	        	메일함 ellipsis 추가.
	        	박종균
	        */
	        function applyEllipsisMailTree() {
	        	/**
	        		1. 왼쪽 메뉴에 존재하는 트리 node를 전부 가져온다.
	        		2. 그 안에서 들여쓰기가 된 img 갯수를 가져온다.
	        		3. 이미지 갯수를 통해 list가 표현될 width를 재설정한다.
	        	*/
	        	$("[id^='PostTreeView_node']").each(function(index, element){
	        		
	        		var imgCnt = $(element).parent().find('img').length - 2;
	        		var title = $(element)[0].innerHTML;
	        		
	        		if (imgCnt > 0) {
	        			// 최초값 164, 한 블럭의 값 18
	        			var customWidth = 140 - (18 * imgCnt);
	        			$(element).css("width", customWidth+"px");
	        			$(element).attr("title", title);	
	        		}
							
	        	});
	        }
	        
	        /**
	        	주소록 ellipsis 추가.
	        	박종균
	        */
	        function applyEllipsisAddressTree() {
	        	/**
	        		1. 왼쪽 메뉴에 존재하는 트리 node를 전부 가져온다.
	        		2. 그 안에서 들여쓰기가 된 img 갯수를 가져온다.
	        		3. 이미지 갯수를 통해 list가 표현될 width를 재설정한다.
	        	*/
	        	$($("[id^='AddressTreeView_node']")).each(function(index, element){
	        		
	        		var imgCnt = $(element).parent().find('img').length - 2;
	        		var title = $(element)[0].innerHTML;
	        		
	        		if (imgCnt > 0) {
	        			// 최초값 164, 한 블럭의 값 18
	        			var customWidth = 140 - (18 * imgCnt);
	        			$(element).css("width", customWidth+"px");
	        			$(element).attr("title", title);	
	        		}
							
	        	});
	        }	        
	        
	        
	        // 수정 수아 재은
	        function detailView(_shareId) {
	        	
	        	var requestUrl = "/ezEmail/mailGetUse.do";
	        	
	        	if (typeof(_shareId) != "undefined" && _shareId != "") {
	            	requestUrl += "?shareId=" + encodeURIComponent(_shareId);
	            }
	        	
                $.ajax({
                    url: requestUrl,
                    type: "POST",
                    dataType: "xml",
                    error : function(error) {
                        console.log(error);
                    },
                    success : function(xml_http) {
                       var result = xml_http;
                 	   var totalVolume = ""; 
                 	   var useVolume = "";
                 	   var percent = "";
                 	   var colorClass = "myBar_green";
                 	            
                 	   if (CrossYN()) { 
                 	        totalVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].textContent;
                 	        useVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].textContent; 
                 	        percent = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent;                    
                 	   } else { 
                 	        totalVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].text;
                 	        useVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].text; 
                 	        percent = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text;
                 	   }

                 	   //뿌려주기
                 	   $("#myBar").css({
                 	       "width" : percent + "%"
                 	   });                 	                   
                 	   $("#useVol").html(useVolume + "<span>/ " + totalVolume + "</span>");
                 	   $("#usePer").text(percent+"%");
                 	   
                 	   //용량 체크(색깔로)
                 	   if (percent >= 80) {
                 	   		colorClass = "myBar_red";
                 	       	$(".volumeDL dd").css("color", "#ff4040");
                 	   } else if (percent >= 70) {
					   		colorClass = "myBar_yellow";
					   		$(".volumeDL dd").css("color", "#ff9c00");
                 	   } else {
                 		  	colorClass = "myBar_green";
                 		  	$(".volumeDL dd").css("color", "#0470e4");
                 	   }                  		   
                 	            
                 	   $("#myBar").addClass(colorClass);
                    }
                });        	    
	        }	        
	        
        	// 2017.12.27 단암 시스템 트리 열기 
            // plus 이미지의 갯수를 확인 한 후 하위 트리를 재귀적으로 호출하여 오픈시킨다. 오픈된 하위트리는 minus 이미지로 바꿔준다.
            // 환경설정에서 기존설정값과 신규설정값이 다르면 트리를 재호출하여 적용시킨다. 
            // 편지함 관리에서도 닫기버튼을 누르면 트리를 재호출하여 적용시킨다.
	        function previewSubTreeCall(type){
        		
        		if (typeof type != "undefined") {
        			previewSubTree = type;

            		if (usePreviewSubTree == "YES" && previewSubTree == "N") {
    	            	var treeArrNum = $('.plusTreeImg').length;

    		          	for (var i = 0; i < treeArrNum; i++) {
    		        	    var getSubtree = $('.plusTreeImg').eq(i).attr('name');
    		        	    var idx = getSubtree.split('PostTreeView_img_');
    		        	    
    		        	    if (typeof idx[1] != "undefined") {
    		        	    	var attr = $('#PostTreeView_img_' + idx[1]).attr("src").split('/');
    		        	    	
    		        	    	if (attr[3] != "plus.gif") {
    			        	    	PostTreeView.toggle(idx[1]);
    		        	    	}
    		        	    }
    		        	    
    	        	    	treeArrNum = $('.plusTreeImg').length;
    		          	}
    	            }
        		}
	           
        		if (usePreviewSubTree == "YES" && previewSubTree == "Y") {
		            var treeArrNum = $('.plusTreeImg').length;

		          	for (var i = 0; i < treeArrNum; i++) {
		        	    var getSubtree = $('.plusTreeImg').eq(i).attr('name');
		        	    var idx = getSubtree.split('PostTreeView_img_');
		        	    
		        	    if (typeof idx[1] != "undefined") {
		        	    	var childxml = get_childXML(PostTreeView.getvalue(idx[1], "href"), false, true, false);
		        	    	PostTreeView.putchildxml(idx[1], childxml);
		        	    	$('#PostTreeView_img_' + idx[1]).attr("src", "/images/OrganTree_cross/minus.gif");
		        	    }
		        	    
	        	    	treeArrNum = $('.plusTreeImg').length;
		          	}
	            } 

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
                    window.open("/ezEmail/mailWrite.do?cmd=NEW", "", feature);
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
	            } else {
	                PostTreeView.select(1);
	            }
	            
                selectnode();	            
	        }
	        function requestdata(event) {
	            if (!event) event = window.event;
	            var nodeIdx = event.nodeIdx;
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	            var childxml = get_childXML(eval(treeviewStr).getvalue(nodeIdx, "href"), false, true, false);
	            eval(treeviewStr).putchildxml(nodeIdx, childxml);
	            
	            /**
	            	ellipsis 적용을 위해 함수 호출
	            */
	            applyEllipsisMailTree();
	        }
	        
	        function selectnode(event) {
	        	if (!event) event = window.event;
				/* 2018-08-06 장진혁 스크립트 오류로 undefined 걸름 */
	        	if (event != undefined && event.which == 3) {
	        		return;
	        	}
				
			    var nodeIdx = eval(treeviewStr).selectedIndex();
			    var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(eval(treeviewStr).getvalue(nodeIdx, "foldername")) + "&url=" + encodeURIComponent(eval(treeviewStr).getvalue(nodeIdx, "href"));
        		
        		if (shareId != "") {
        			url += "&shareId=" + encodeURIComponent(shareId);
        		}
        		
        		try {
	                if (typeof (parent.frames["right"]) != "undefined")
	                    parent.frames["right"].Window_onunload();
	            } catch (e) { }
	            
	            if (g_firstOpen) {
	                g_firstOpen = false;
	            } else {
	                window.open(url, "right");
	            }
	            
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
	                        window.parent.frames("right").move_on_dragdrop(eval(treeviewStr).getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	                else if (szCommand == "copy" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").copy_on_dragdrop(eval(treeviewStr).getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	            }
	            else {
	                if (szCommand == "move" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").document.Script.move_on_dragdrop(eval(treeviewStr).getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	                else if (szCommand == "copy" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").document.Script.copy_on_dragdrop(eval(treeviewStr).getvalue(event.nodeIdx, "href"));
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
                	var href = eval(treeviewStr).getvalue(eval(treeviewStr).selectedIndex(), "href");
                	
                	createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "URL", href);
	                
	                if (shareId != "") {
		                createNodeAndInsertText(xmlpara, objNode, "SHAREID", shareId);
	                }
	                
	                xmlHTTP_Unread.open("POST", "/ezEmail/getFolderUnreadCount.do", true);
	                xmlHTTP_Unread.onreadystatechange = get_unreadend_2010;
	                get_unreadend_2010.href = href;
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
	                var caption = eval(treeviewStr).getvalue(eval(treeviewStr).selectedIndex(), "foldername");
	
	                if (get_unreadend_2010.href == eval(treeviewStr).getvalue(eval(treeviewStr).selectedIndex(), "href")) {
	                    if (unreadcount == "0") {
	                    	eval(treeviewStr).putcaption(eval(treeviewStr).selectedIndex(), caption);
	                    	eval(treeviewStr).putstyle(eval(treeviewStr).selectedIndex(), "font-weight : ''");
	                    }
	                    else {
	                    	eval(treeviewStr).putcaption(eval(treeviewStr).selectedIndex(), caption + "(" + unreadcount + ")");
	                    	eval(treeviewStr).putstyle(eval(treeviewStr).selectedIndex(), "font-weight : bold");
	                    }
	                    
	                    var pageTitle = parent.frames["right"].document.title;

	                    if (pageTitle == "mail_list") {
                        	try { parent.frames["right"].folderUnreadCount.innerText = " " + unreadcount + " "; } catch (e) { }
	                    }
	                    
	                    xmlDom = null;
	                }
	            }
	            
	            xmlHTTP_Unread = null;
	            applyEllipsisMailTree();
	        }
	        function get_unreadcount() {
	            return get_unreadcount_2010();
	        }
	        function check_pop3() {
	            var OpenWin = window.open("/ezEmail/mailGetPop3.do", "mail_getpop3_cross", GetOpenWindowfeature(460, 360));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        var mail_foldermanage_Cross_dialogArguments = new Array();
	        function folder_manage() {
	            mail_foldermanage_Cross_dialogArguments[1] = folder_manager_after;
	            var OpenWin = window.open("/ezEmail/mailFolderManage.do", "mail_foldermanage_Cross", GetOpenWindowfeature(555, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function folder_manager_after(RtnVal) {
	            if (RtnVal && shareId == "") {
	                var href = PostTreeView.getvalue(1, "href");
	                PostTreeView.source("<tree><nodes>" + get_childXML("", true, true, false) + "</nodes></tree>");
	                PostTreeView.update();
	                
	                if (PostTreeView.selectedIndex() == -1) {
	                    PostTreeView.select(1);
	                }
	                
	                var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(PostTreeView.getvalue(1, "foldername")) + "&url=" + encodeURIComponent(PostTreeView.getvalue(1, "href"));
	                window.open(url, "right");
	                
	                previewSubTreeCall();
	            	detailView();
	            }
	        }
	        
	        /**
	        	메일함 트리뷰 reload 함수
	        */
	        function mailbox_treeview_reload() {
	        	setTimeout(function() {
	        		PostTreeView.source("<tree><nodes>" + get_childXML("", true, true, false) + "</nodes></tree>");
	                PostTreeView.update();
	                
	                previewSubTreeCall();
	        	}, 100);
	        }
	        
	        function Function_Flag(v_data) {
	            v_data = parseInt(v_data);
	
	            switch (v_data) {
	                case 1:
	                    LoadEmailTree();
	                    break;
	                case 2:
	                    LoadEmailTree();
	                    WebPartToggle(level1El.item(level1El.length - 1));
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
	        
	        function openSpamBox() {
	            try {
	                var url;
	                
	                url = "http://gwspam.bizmeka.com/personal/index.php?email=${credentialForBizmekaSpambox}&init=mail";
	                window.open(url, "right");
	            } catch (e) {	                
	            }	            
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
	        function mail_Config() {
	        	if (shareId == "") {
	        		detailView();
	        	}
	        	
	            parent.frames["right"].location.href = "/ezEmail/mailConfig.do";
	        }
	        function Address_Menu_Click() {
	        	HiddenFolderMenu();
	            LoadAddressTree(true);
	            
	            if (AddressTreeView.selectedIndex() == -1)
	                AddressTreeView.select(1);
	            else
	                selectnode_address();
	            
	            applyEllipsisAddressTree();
	        }
	        var AddressTreeView = null;
	        function LoadAddressTree() {
	            if (AddressTreeView == null) {
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
	            }
	        }
	        function requestdata_address(event) {
	            if (!event) {
	                event = window.event;
	            }
	
	            var nodeIdx = event.nodeIdx;
	
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	
	            var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"))
	            AddressTreeView.putchildxml(nodeIdx, childxml);
	            
	            /**
	            	주소록 ellipsis 추가
	            */
	            applyEllipsisAddressTree();
	        }
	        function selectnode_address() {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            var url = "/ezAddress/addressMainList.do?folderid=" + encodeURIComponent(AddressTreeView.getvalue(nodeIdx, "folderid")) + "&type=" + encodeURIComponent(AddressTreeView.getvalue(nodeIdx, "type"));
	            window.open(url, "right");
	        }
	        var address_foldermanage_dialogArguments = new Array();
	        function address_foldermanage() {
	            address_foldermanage_dialogArguments[1] = address_foldermanage_Complete;
	            var OpenWin = window.open("/ezAddress/addressFolderManage.do", "address_foldermanage", GetOpenWindowfeature(500, 500));
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
	        	shareId = "";
	        	deletePermission = "";
	        	sendPermission = "";
	        	treeviewStr = "PostTreeView";
	        	
	        	HiddenFolderMenu();
	        	
		    	if (useMailBoxBackUp == "YES") {
			    	document.getElementById("mailbox_import").style.display = "";
		    	}
		    	
			    document.getElementById("mailbox_delete").style.display = "";
	        	
	        	detailView();
	            eval(treeviewStr).select(1);
	        }
	        
	        function showProgress() {
			    document.getElementById("progressPanel").style.display = "block";
			    document.getElementById("progressPanel").style.opacity = 0.5;
			    document.getElementById("progressPanel").style.background = "rgba(0,0,0,0.7)";
			}
	        
	        function hideProgress() {
	        	document.getElementById("progressPanel").style.display = "none";
	        }
	        
		    function goPage(idx) {
				var url = "";
				
				switch (idx) {
				    case 1:
				        url = "/admin/ezOrgan/organRight.do";
						break;
				    case 2:
				        url = "/admin/ezEmail/mailDistributionList.do";
						break;
					case 3:
						url = "/admin/ezEmail/mailDefaultQuota.do" ;
						break;
					case 4:
						url = "/admin/ezEmail/mailConfigColor.do";
						break;
					case 5:
						url = "/admin/ezOrgan/retireUserManage.do";
						break;
					case 6:
						url = "/ezStatistics/statisticsMailMain.do";
						break;
				    case 7:
				        url = "/ezStatistics/statisticsMailDept.do";
					    break;
			        case 8:
			            url = "/ezStatistics/statisticsMailUser.do";
			            break;
			        case 9:
			            url = "/ezStatistics/statisticsQuantityDept.do";
			            break;
			        case 10:
			            url = "/ezStatistics/statisticsQuantityUser.do";
			            break;
			        case 11:
			        	url = "/ezStatistics/statisticsMailRecieveLogList.do";
			        	break;
			        case 12:
			        	url = "/ezStatistics/statisticsMailSendLogList.do";
			        	break;			            
			        case 13:
			        	url = "/admin/ezSystem/systemMainMenu.do";
			        	break;			            
			        case 14:
			        	url = "/admin/ezEmail/mailQuotaList.do";
			        	break;			            
				}
				
				window.open(url, "right");
			}	
		    
 			function event_folderMenu(event){
 				event.preventDefault();
 				
		    	if (!event) event = window.event;
		        var EventMouseX = event.clientX;
		        var EventMouseY = event.clientY;

		        var listsizeheight = document.documentElement.clientHeight;
		        var listsizewidth = document.documentElement.clientWidth;
		        var EventDivSize = EventMouseY + 240;
		        if (listsizeheight < EventDivSize) {
		            var Div_ = EventDivSize - listsizeheight;
		            EventMouseY = EventMouseY - Div_;
		        }

		        EventDivSize = EventMouseX + 140;
		        if (listsizewidth < EventDivSize) {
		            var Div_ = EventDivSize - listsizewidth;
		            EventMouseX = EventMouseX - Div_;
		        }
		        
		        //document.getElementById("folderPanel").style.display = "";
		        document.getElementById("folderMenuDiv").style.left = EventMouseX + "px";
		        document.getElementById("folderMenuDiv").style.top = EventMouseY + "px";
		        document.getElementById("folderMenuDiv").style.display = "";
		       
		        if ( parent.frames["right"].document.getElementById("mailPanel").style.display == "none") {
			        parent.frames["right"].document.getElementById("mailPanel").style.display = "";
		        }
		    }
		    
		    function HiddenFolderMenu(){
		    	document.getElementById("folderPanel").style.display = "none";
		        document.getElementById("folderMenuDiv").style.display = "none";
		    	
		        if (parent.frames["right"].document.getElementById("mailPanel").style.display == "") {
		        	parent.frames["right"].document.getElementById("mailPanel").style.display = "none";
		        }
		    }
		    
		    //편지함 모두 읽기
		    function folder_ReadChange(pGubun){
		    	var xmlHTTP = createXMLHttpRequest();
		    	var nodeIdx = eval(treeviewStr).selectedIndex();
	            var href = eval(treeviewStr).getvalue(nodeIdx, "href");
	            var foldername = eval(treeviewStr).getvalue(nodeIdx, "foldername");
	            var isRead = "FALSE";
	            
	            if (pGubun == "R") {
	            	isRead = "TRUE";
	            }
	            
	            var requestUrl = "/ezEmail/folderSetReadChange.do?url=" + encodeURIComponent(href) + "&isRead=" + isRead;
	            
	            if (shareId != "") {
	            	requestUrl += "&shareId=" + encodeURIComponent(shareId);
	            }
	            
	            xmlHTTP.open("POST",requestUrl, false);
	            xmlHTTP.send();
	            
	            try {
	                if (typeof (parent.frames["right"]) != "undefined")
	                    parent.frames["right"].Window_onunload();
	            } catch (e) { }
	            
	            if (g_firstOpen) {
	                g_firstOpen = false;
	            } else {
	            	requestUrl = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(foldername) + "&url=" + encodeURIComponent(href);
	                
	            	if (shareId != "") {
		            	requestUrl += "&shareId=" + encodeURIComponent(shareId);
		            }
	            	
	            	window.open(requestUrl, "right");
	            }
	            
	            get_unreadcount();
		    }
		    
		    function mailbox_export(){
		    	try {
		    		var nodeIdx = eval(treeviewStr).selectedIndex();
		    		var folderPath = eval(treeviewStr).getvalue(nodeIdx, "href");
		    		
		    		if (typeof (parent.frames["right"].g_moveUrl) == "undefined" || parent.frames["right"].g_moveUrl != folderPath) {
		            	var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(eval(treeviewStr).getvalue(nodeIdx, "foldername")) + "&url=" + encodeURIComponent(folderPath);
		            	
		            	if (shareId != "") {
		            		url += "&shareId=" + encodeURIComponent(shareId);
			            }
		            	
		            	parent.frames["right"].location.href = url;
		    		}
	            	
            		setTimeout(function() {
	            		parent.frames["right"].mailbox_export();
		        	}, 1000);
	            	
	            } catch (e) {
	            	console.log("mailbox_export error!");
	            }
		    }
		    
		    function mailbox_import(){
		    	try {
		    		var nodeIdx = eval(treeviewStr).selectedIndex();
		    		var folderPath = eval(treeviewStr).getvalue(nodeIdx, "href");
		    		
		    		if (typeof (parent.frames["right"].g_moveUrl) == "undefined" || parent.frames["right"].g_moveUrl != folderPath) {
		            	var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(eval(treeviewStr).getvalue(nodeIdx, "foldername")) + "&url=" + encodeURIComponent(folderPath);
		            	
		            	if (shareId != "") {
		            		url += "&shareId=" + encodeURIComponent(shareId);
			            }
		            	
		            	parent.frames["right"].location.href = url;
		    		}
		    		
	            	setTimeout(function() {
	            		parent.frames["right"].mailbox_import();
		        	}, 1000);
	            } catch (e) {
	            	console.log("mailbox_import error!");
	            }
		    }
		    
		   function mailbox_delete() {
			   try {
				   var nodeIdx = eval(treeviewStr).selectedIndex();
		    	   var folderPath = eval(treeviewStr).getvalue(nodeIdx, "href");
		    	   
		    	   var trashBoxURL = "${pDeleteBoxID}";
			        
			      	//지운편지함의 메일 영구삭제
			        if (folderPath == trashBoxURL) {
			            if (confirm("<spring:message code='ezEmail.t470' />")) {
				            if (confirm("<spring:message code='ezEmail.ksa03' />")) {
				                delete_mail(folderPath, true, "");
				            }
			            }
			        }
			      	//편지함의 메일 지운편지함으로 이동  
			        else {
			            if (confirm("<spring:message code='ezEmail.t475' />")) {
			            	if (confirm("<spring:message code='ezEmail.ksa04' />")) {
				                delete_mail(folderPath, false, trashBoxURL);	
			            	}
			            }
			        }
			      	
			   } catch (e) {
				   console.log("mailbox_delete error!");
			   }
		   }
		   
		   var xmlHTTP2 = null;
		   var deltype = null;
		   function delete_mail(szURL, bDelete, destURL) {
		    	xmlHTTP2 = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		        
		        if (bDelete) {
		            deltype = "MAILREALDEL";
		        } else {
		            deltype = "MAILDEL";
		        }
		        
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", destURL);
		        createNodeAndInsertText(xmlDOM, objNode, "CMD", deltype);
		        
		        var requestUrl = "/ezEmail/mailMakeFolder.do";
		        
		        if (shareId != "") {
		        	requestUrl += "?shareId=" + encodeURIComponent(shareId);
	            }
		        
		        xmlHTTP2.open("POST", requestUrl, true);
		        xmlHTTP2.onreadystatechange = delete_mail_complete;
		        xmlHTTP2.send(xmlDOM);
		        
		        ShowMailProgressNew();
		    }
		   
			function delete_mail_complete() {
				if (xmlHTTP2 != null && deltype != null && xmlHTTP2.readyState == 4) {
					var nodeIdx = eval(treeviewStr).selectedIndex();
					var foldername = eval(treeviewStr).getvalue(nodeIdx, "foldername");
					var href = eval(treeviewStr).getvalue(nodeIdx, "href");
					
					HiddenMailProgressNew();
					HiddenFolderMenu();
		        	 
		            //지운편지함의 메일 영구삭제
		            if (deltype == "MAILREALDEL") {
		            	if (xmlHTTP2.status >= 200 && xmlHTTP2.status < 300) {
							if (xmlHTTP2.responseText == "OK") {
								alert("<spring:message code='ezEmail.t473' />");

								if (typeof (parent.frames["right"]) != "undefined") {
									parent.frames["right"].Window_onunload();
								}
			 			        
								if (g_firstOpen) {
									g_firstOpen = false;
								} else {
									var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(foldername) + "&url=" + encodeURIComponent(href);

									if (shareId != "") {
										url += "&shareId=" + encodeURIComponent(shareId);
									}

									window.open(url, "right");
									get_unreadcount();
								}
					    	} else {
					    		alert("<spring:message code='ezEmail.t472' />");
					    	}
					    } else {
					    	alert("<spring:message code='ezEmail.t472' />");
					    }
		            }
		            //편지함의 메일 지운편지함으로 이동
					else {
						if (xmlHTTP2.status >= 200 && xmlHTTP2.status < 300) {
							if (xmlHTTP2.responseText == "OK") {
								alert("<spring:message code='ezEmail.t478' />");

								if (typeof (parent.frames["right"]) != "undefined") {
									parent.frames["right"].Window_onunload();
								}
			 			        
								if (g_firstOpen) {
									g_firstOpen = false;
								} else {
									var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(foldername) + "&url=" + encodeURIComponent(href);
									
									if (shareId != "") {
										url += "&shareId=" + encodeURIComponent(shareId);
									}
									
									window.open(url, "right");
									get_unreadcount();
								}
		            		} else if (xmlHTTP2.responseText.indexOf("NO COPY processing failed.") > -1) {
		            			alert(strLang241);
		            		} else {
		            			alert("<spring:message code='ezEmail.t477' />");
		            		}
						} else {
		            		alert("<spring:message code='ezEmail.t477' />");
		            	}
		            }
		            
		        }
		    }
		   
			function HiddenMailProgressNew() {
				var CurrentHeight = parent.frames["right"].document.CurrentHeight;
				var CurrenWidth = parent.frames["right"].document.CurrenWidth;
				
			   parent.frames["right"].document.getElementById("mailPanel").style.display = "none";
			   parent.frames["right"].document.getElementById("mailPanel").style.backgroundColor = "";
			   parent.frames["right"].document.getElementById("MailProgress").style.display = "none";
			   hideProgress();
			   
			   if (useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.hideProgress();
				} 
			}
		   
			function ShowMailProgressNew() {
				var CurrentHeight = parent.frames["right"].document.CurrentHeight;
				var CurrenWidth = parent.frames["right"].document.CurrenWidth;
				
				parent.frames["right"].document.getElementById("mailPanel").style.display = "block";
				parent.frames["right"].document.getElementById("mailPanel").style.opacity = 0.5;
				parent.frames["right"].document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
				parent.frames["right"].document.getElementById("MailProgress").style.top = (CurrentHeight / 2) + "px";
				parent.frames["right"].document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
				parent.frames["right"].document.getElementById("MailProgress").style.display = "";
			    showProgress();
			    
			    if (useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.showProgress();
				}
			}
			
			// 수신확인 메뉴 클릭
			function reception_check() {
				var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent("<spring:message code='ezEmail.t516' />") + "&url=receiveChk";
				
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
			
			function operatorSendMail() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var conWidth = pwidth * 0.8;
		        
		        if (conWidth > 890) {
		            conWidth = 890;
		        }
		        
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";

		        window.open("/ezEmail/mailWrite.do?cmd=NEW&operatorMailAddress=" + operatorMailAddress, "", feature);
		    }
			
			// 2018-10-16 공유사서함 관련 함수 추가
			function Share_Menu_Click(_shareId, _deletePermission, _sendPermission) {
				shareId = _shareId;
				deletePermission = _deletePermission;
				sendPermission = _sendPermission;
				treeviewStr = 'shareTreeView_' + shareId;
			    
			    if (document.getElementById(treeviewStr).innerHTML === "") {
			        var xmlHTTP = createXMLHttpRequest();
			        var xmlDOM = createXmlDom();
			        var objNode;
			        createNodeInsert(xmlDOM, objNode, "DATA");
			        createNodeAndInsertText(xmlDOM, objNode, "URL", "");
			        createNodeAndInsertText(xmlDOM, objNode, "BCOUNT", "-1");
			        
			        xmlHTTP.open("POST", "/ezEmail/getFolderList.do?shareId=" + encodeURIComponent(shareId), false);
			        xmlHTTP.send(xmlDOM);

			        var nodeTreeXml = xmlHTTP.responseText.replace("<DATA>", "").replace("</DATA>", "");
			        LoadEmailTree2(nodeTreeXml);
			        
			    } else {
			    	eval(treeviewStr).select(1);
			    }
			    
			    HiddenFolderMenu();
			    
			    if (deletePermission == "Y") {
			    	if (useMailBoxBackUp == "YES") {
				    	document.getElementById("mailbox_import").style.display = "";
			    	}
			    	
				    document.getElementById("mailbox_delete").style.display = "";
			    } else {
				    document.getElementById("mailbox_import").style.display = "none";
				    document.getElementById("mailbox_delete").style.display = "none";
			    }
			    
			    detailView(shareId);
			}
			
			function LoadEmailTree2(RootShareFolderXML) {
			    if (RootShareFolderXML.trim() == "") {
			        return;
			    }
			    
			    var shareTreeView = new TreeView('shareTreeView_' + shareId, 'shareTreeView_' + shareId);
			    shareTreeView.attachEvent('requestdata', requestdata);
			    shareTreeView.attachEvent('nodeselect', selectnode);
			    shareTreeView.attachEvent('nodedblclick', function () { shareTreeView.toggle(shareTreeView.selectedIndex()) });
			    
			    if (deletePermission == "Y") {
			    	shareTreeView.attachEvent('dragdrop', email_dragdrop);
			    	shareTreeView.dragdrop(true);
			    }
			    
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
			    xmlHTTP.send();
				
			    var treeconfig;
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            } else {
	                treeconfig = xmlHTTP.responseXML;
	            }
			    
			    shareTreeView.config(treeconfig);
			    shareTreeView.source("<tree><nodes>" + RootShareFolderXML + "</nodes></tree>");
			    shareTreeView.update();
			    shareTreeView.select(1);
			    
			    selectnode();
			}

			function SharefindID() {
			    var str = "";
			    
			    for (var i = 0; i < document.getElementsByTagName("ul").length; i++) {
			        if (document.getElementsByTagName("ul")[i].className == "on") {
			            str = document.getElementsByTagName("ul")[i];
			        }
			    }
			    
			    str = str.getElementsByTagName("div")[0].id;
			    var rtn = GetAttribute(document.getElementById(str), "value");
			    
			    return rtn;
			}

			function SharefindIndex() {
			    var str = "";
			    
			    for (var i = 0; i < document.getElementsByTagName("ul").length; i++) {
			        if (document.getElementsByTagName("ul")[i].className == "on") {
			            str = document.getElementsByTagName("ul")[i];
			        }
			    }
			    
			    str = str.getElementsByTagName("div")[0].id;
			    var rtn = GetAttribute(document.getElementById(str), "index");
			    
			    return rtn;
			}

	    </script>
		<style type="text/css">
			.myBar_red {
			  height: 7px;				  
			  background-color: #ff4040;
			}
			.myBar_yellow {
			  height: 7px;				  
			  background-color: #ff9c00;
			}
			.myBar_green {
			  height: 7px;				  
			  background-color: #4faaff;
			}
			.node_normal{
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		white-space: nowrap;
	    	}
			.node_selected{
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		white-space: nowrap;
	    	}	    	
		</style>
	</head>
	<body class="leftbody" style="overflow: auto; height: 100%;">
	    <div id="left">
	        <div class="left_mail" title="<spring:message code="ezEmail.t99000012" />"><span><spring:message code="ezEmail.t99000012" /></span></div>
	        <h2><span onclick="Email_Menu_Click();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000012" /></span></h2>
	        <ul>
	            <div class="tree" style="height: 100%; background-color: #ffffff; border-bottom: 1px solid #eaeaea; overflow: auto; padding-left: 20px;" id="PostTreeView" oncontextmenu="event_folderMenu(event); return false;" onclick="HiddenFolderMenu();"></div>
	            <li><span onclick="write_Letter()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000013" /></span></li>
	            
	            <c:if test="${useMailReceiveScreen == 'YES'}">
	            	<li><span onclick="reception_check()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t516" /></span></li>
	            </c:if>
	            <li><span onclick="folder_manage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t481" /></span></li>
	            <li><span onclick="Open_Search();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t641" /></span></li>
		        <c:if test="${useOnlyInnerMail != 'YES'}">
	            <li><span onclick="check_pop3()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t490" /></span></li>
	            </c:if>
	            <li><span onclick="Open_ReservationManage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t605" /></span></li>
                <c:if test="${useBizmekaSpambox == 'YES'}"> 
                <li><span onclick="openSpamBox()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.ldh01" /></span></li>
                </c:if>
	        </ul>
	        
	        <c:if test="${useSharedMailbox == 'YES'}">
		        <c:forEach items="${shareInfoList}" var="shareInfo">
		        	<h2><span onclick="Share_Menu_Click('${shareInfo.shareId}', '${shareInfo.deletePermission}', '${shareInfo.sendPermission}');" 
		        			style="width:85%; display:inline-block; overflow:hidden; text-overflow:ellipsis; display:inline-block; white-space:nowrap;" title="${shareInfo.shareName}"><c:out value="${shareInfo.shareName}" /></span></h2>
		        	<ul>
		            	<div id="shareTreeView_${shareInfo.shareId}" class="tree" value="${shareInfo.shareId}" style="height: 100%; background-color: #ffffff; border-bottom: 1px solid #eaeaea; overflow: auto; padding-left: 20px;" oncontextmenu="event_folderMenu(event); return false;" onclick="HiddenFolderMenu();"></div>
		        	</ul>
		        </c:forEach>
	        </c:if>
	        <h2><span onclick="Address_Menu_Click();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000041" /></span></h2>
	        <ul>
	            <div class="tree" style="height: 100%; background-color: #ffffff; border-bottom: 1px solid #eaeaea; overflow-x:hidden; overflow-y: auto; padding-left: 20px;" id="AddressTreeView"></div>
	            <li><span id='Address_Search' onclick="address_Search();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000042" /></span></li>
	            <li style="border-bottom-color:#e8e8e8" evt="0"><span onclick="address_foldermanage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000043" /></span></li>
	        </ul>	        
	    	<!-- 수정 수아 재은 -->
	    	<!-- <div style="border:1px solid #e8e8e8;margin:10px 10px 2px;background-color:#f8f8fa">
			    <div id='myProgress' style='margin-left:20px;margin-top:10px'></div>
			    <div style="width:80%">
			    	<div id='myBar'></div>
			    </div>	
			    <div style='text-align:center; margin-top:10px;margin-bottom:5px;font-weight: bold;font-family: dotum;' class="volumes"></div>
		    </div> -->
		    <div class="mail_volume">
		    	<p class="volume_num"><img src="/images/volume_num.png" /></p>
		        <p class="volume_graph" id='myProgress'><span id='myBar'></span></p>
		        <dl class="volumeDL" >
		        	<dt id="useVol"></dt>
		            <dd id="usePer"></dd>
		        </dl>
		    </div>
		    <c:if test="${operatorMailAddress ne null && operatorMailAddress != ''}">
		    <h4 onclick="operatorSendMail()"><span><spring:message code="ezEmail.0hun01" /></span></h4>
		    </c:if>
	        <h3 onclick="mail_Config()" style="border-top:0px"><span style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000044" /></span></h3>
	        <%--
	        <c:if test="${isDotNetAdmin == true}">
  			<h2>
  				<span onClick="goPage(1)" style="display:inline-block;width:100%;"><spring:message code='main.t56' /></span>
    			<ul></ul>  				
  			</h2>  
  			<h2>
  				<span onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='main.t57' /></span>
    			<ul></ul>    			
  			</h2>  
  			<h2>
  				<span onClick="goPage(3)" style="display:inline-block;width:100%;"><spring:message code='main.t58' /></span>
    			<ul></ul>
  			</h2>  			
  			<h2>
  				<span onClick="goPage(14)" style="display:inline-block;width:100%;"><spring:message code='ezEmail.lsd01' /></span>
    			<ul></ul>
  			</h2>  			
			<h2>
				<span onClick="goPage(4)" style="display:inline-block;width:100%;"><spring:message code='main.t00027' /></span>
			    <ul></ul>
			</h2>
			<h2>
				<span onClick="goPage(5)" style="display:inline-block;width:100%;"><spring:message code='main.t377' /></span>
			    <ul></ul>
			</h2>		
            <h2><span id="PARAMETER" style="display:inline-block;width:100%;" onClick="goPage(13)" ><spring:message code='main.kms1' /></span>
            <ul class="on"></ul>
            </h2>			
      	    <h2><span id="MAIL" style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='ezStatistics.t2' /></span></h2>
		    <ul>
			    <li><span style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='ezStatistics.t1001' /></span></li>
			    <li><span style="display:inline-block;width:100%;" onClick="goPage(7)"><spring:message code='ezStatistics.t1012' /></span></li>
                <li><span style="display:inline-block;width:100%;" onclick="goPage(8)"><spring:message code='ezStatistics.t1018' /></span></li>
                <li><span style="display:inline-block;width:100%;" onclick="goPage(9)"><spring:message code='ezStatistics.t1023' /></span></li>
                <li><span style="display:inline-block;width:100%;" onclick="goPage(10)"><spring:message code='ezStatistics.t1025' /></span></li>
                <li><span style="display:inline-block;width:100%;" onclick="goPage(11)"><spring:message code='ezStatistics.kyj1' /></span></li>
                <li><span style="display:inline-block;width:100%;" onclick="goPage(12)"><spring:message code='ezStatistics.kyj2' /></span></li>
		    </ul>			
			</c:if>		 
			--%>       
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    <xml id="RootFolderXML" style="display: none;">
	    ${rootFolderXML}
	    </xml>
	    <xml id="AddressFolderXML" style="display: none;">
	    ${rootAddressXML}
	    </xml>
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;display:none;" id="progressPanel">&nbsp;</div>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="folderPanel" onclick="HiddenFolderMenu();" >&nbsp;</div>   		    		               
		<div id="folderMenuDiv" style="position:absolute;top:180px;z-index:6000;display:none;">
		    <table cellpadding=2 cellspacing=1 border=0 style="width:130px;" class="popuplist">
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="folder_ReadChange('R');HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/icon-msg-read.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.jyh01" /></span></td>
		    </tr>
		    <tr id="mailbox_export" <c:if test="${useMailBoxBackUp ne 'YES'}">style="display:none"</c:if>>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="mailbox_export();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_mailreply.gif" alt="" align="absmiddle" border="0" hspace="5"><spring:message code="ezEmail.lhm31" /></span></td>
		    </tr>
		    <tr id="mailbox_import" <c:if test="${useMailBoxBackUp ne 'YES'}">style="display:none"</c:if>>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="mailbox_import();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_fw.gif" alt="" align="absmiddle"  border="0" hspace="5"><spring:message code="ezEmail.lhm32" /></span></td>
		    </tr>
		    <tr id="mailbox_delete">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="mailbox_delete();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/deleted.gif" alt="" align="absmiddle"  border="0" hspace="5"><spring:message code="ezEmail.t483" /></span></td>
		    </tr>
		    </table>
		</div>
		<script>
			// 웹소켓 지원을 안할 경우 '편지함 내려받기/가져오기' 버튼 숨김
	        if ('WebSocket' in window) {
	       	} else if ('MozWebSocket' in window) {
	       	} else {
	       		document.getElementById("mailbox_export").style.display = "none";
				document.getElementById("mailbox_import").style.display = "none";
	       	}
		</script>
	</body>
</html>
