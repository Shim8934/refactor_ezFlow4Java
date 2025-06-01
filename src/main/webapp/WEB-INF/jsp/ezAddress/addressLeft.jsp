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
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style type="text/css">
	    	#mCSB_1_container {
				margin-right: 0px;
			}
	    </style>
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

	            Address_Menu_Click();
	            
	            leftResize();
		        $(".addressListBox").mCustomScrollbar({
	        		theme : "dark"
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
	        		
	        		var imgCnt = $(element).parent().children('.sub_iconLNB').length - 2;
	        		var title = $(element)[0].innerHTML;
	        		
	        		if (imgCnt > 0) {
	        			// 최초값 170, 한 블럭의 값 16 이지만 길이가 맞지않아 14로 설정
	        			var customWidth = 170 - (14 * imgCnt);
	        			$(element).css("width", customWidth+"px");
	        			$(element).css("text-align", "justify");
	        		}
					$(element).attr("title", title);
	        	});
	        }	        
	        
	        
	        // 수정 수아 재은
	        function detailView() {
	        	
	        	/* xml_http = createXMLHttpRequest();
                xml_http.open("POST", "/ezEmail/mailGetUse.do", true);
                xml_http.onreadystatechange = test;
                xml_http.send(); */
              
                $.ajax({
                    url: "/ezEmail/mailGetUse.do",
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
	            var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, true, false);
	            PostTreeView.putchildxml(nodeIdx, childxml);
	            
	            /**
	            	ellipsis 적용을 위해 함수 호출
	            */
	            applyEllipsisMailTree();
	        }
	  
	        function Address_Menu_Click() {
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
	            parent.document.querySelector("iframe[name=right]").src = url;
	        }
	        var address_foldermanage_dialogArguments = new Array();
	        function address_foldermanage() {
	            address_foldermanage_dialogArguments[1] = address_foldermanage_Complete;
	            var OpenWin = window.open("/ezAddress/addressFolderManage.do", "address_foldermanage", GetOpenWindowfeature(500, 500));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	        function address_foldermanage_Complete(ret) {
	            if (ret != undefined) {
	            	$.ajax({
	            		type : "GET",
	            		url : "/ezAddress/getRootAddressXML.do",
	            		dataType : "text",
	            		success : function(data) {
	            			document.getElementById("AddressFolderXML").innerHTML = data;
	     	            	LoadAddressTree();
	            		}, error : function(ee) {
	            			alert("error: " + ee.status);
	            		}
	            	});
	            	
	            	/* var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("GET", "/ezAddress/getRootAddressXML.do", false);
		            xmlHTTP.send();
	            	
		            document.getElementById("AddressFolderXML").innerHTML = xmlHTTP.responseText;
	            	LoadAddressTree(); */
	            }
	        }
			// TODO: div.tree 영역 밖의 li들은 꼭 li로 있어야 하는지? 또 하나의 div.tree로 만들 수는 없는지? (관리 용이 목적)
	        function address_Search() {
                parent.document.querySelector("iframe[name=right]").src = "/ezAddress/addressMainSearch.do";
	            // 2023-06-28 황인경 - 디자인 개선 > 주소록 > 좌측메뉴 > 하단 '주소록검색' 메뉴 선택시 상단 메뉴 선택 해제
	            $(".node_selected").attr("class", "node_normal");
				// 1) 메일과의 통일성. 2) address_Search() 두 번 클릭 시, .list_text가 list_text는 사라지고 node_normal로 변경되는 현상 발생.
	            // $(".list_text").addClass("node_selected");
	        }
		    
 			function event_folderMenu(event){
		    	
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
		   
		   
		   	var xmlHTTP2 = null;
		   	var deltype = null;
		 
			// 주소작성창 호출
			function newAddress() {
				var wWeight = "600";
                var wHeight = "500";
				
                
                var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - wHeight) / 2;
		        var pLeft = (pwidth - wWeight) / 2;
		
		       	var dualScreenTop = window.screenY;
		        var dualScreenLeft = window.screenX;
		        	
		       	pTop += dualScreenTop;
		       	pLeft += dualScreenLeft;
		       				
				if (/MSIE|Trident/.test(window.navigator.userAgent)) {
		       		if (window.screenLeft > window.screen.width) {
		       			pTop -= 223;
		       			pLeft -= 375;
		       		}
		       	}
                window.open("/ezAddress/addressWrite.do?ownerid=" + encodeURIComponent("${userInfo.id}") + "&folderid=&foldertype=", "",
                "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + pTop + ",left = " + pLeft);
			}
			
			
			// 환경설정 호출
			function mail_Config() {
				detailView();
		 		parent.document.querySelector("iframe[name=right]").src = "/ezEmail/mailConfig.do?flag=address";
			}
			
			// 주소록 트리 이름
			function send_AddressTitle() {
				var addressNames = document.getElementsByClassName("node_selected");
				var addressTitle = addressNames[0].innerText;
				return addressTitle;
			}
			
			function leftResize(){
	        	$(".addressListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
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
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezAddress.t231' />">
	    		<spring:message code='ezAddress.t231' />
	        	<span class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezEmail.t99000044" />" onclick="mail_Config()"></span>
	        </div>
	        <div class="btn_writeBox" onclick="newAddress()">
	        	<p class="btn_write01"><spring:message code='ezAddress.t236' /></p>
	        </div>
	        <div class="addressListBox" style="overflow:hidden; padding-right: 0;">
		        <ul class="lnbUL" style="background: #F8F9FB">
		        	<div class="tree" id="AddressTreeView" style="padding-top:15px">
	            		<%-- 2023-06-22 황인경 - 디자인 개선 > 주소록 > 좌측메뉴 LNB 이미지 삭제 --%>
<%-- 		            <span> 
			            	<span> 
			                	<span> 
			                    	<div class="node_div"> 
			                        	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_adress_individual"></span><span class="list_text"><spring:message code='ezAddress.t145' /></span><span class="sub_iconLNB tree_manage" onclick="address_foldermanage()"></span> 
			                        </div> 
			                	</span> 
			                    <span> 
			                    	<div class="node_div"> 
			                        	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_adress_department"></span><span class="list_text"><spring:message code='ezAddress.t146' /></span> 
			                        </div> 
			                	</span> 
			                    <span> 
			                    	<div class="node_div"> 
			                        	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_adress_company"></span><span class="list_text"><spring:message code='ezAddress.t147' /></span> 
			                        </div> 
			                	</span> 
			                </span>         
			            </span> --%>
		            </div>
		            <li onclick="address_Search()"><span class="list_text"><spring:message code="ezEmail.t99000042" /></span></li>
		        </ul>
	        </div>
	    </div>
	    <xml id="RootFolderXML" style="display: none;">
	    ${rootFolderXML}
	    </xml>
	    <xml id="AddressFolderXML" style="display: none;">
	    ${rootAddressXML}	        
	</body>
	<%-- <body class="leftbody" style="overflow: auto; height: 100%;">
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
	            <li id="mailexport"><span style="width: 100%; display: inline-block;" onclick="mail_export()"><spring:message code="ezEmail.t378" /></span></li>
	            <li id="mailexportall" style="display: none;"><span style="width: 100%; display: inline-block;" onclick="mail_exportall()"><spring:message code="ezEmail.t99000014" /></span></li>
	            <li id="mailimport"><span onclick="mail_import()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000015" /></span></li>
	            <li><span onclick="Open_ReservationManage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t605" /></span></li>
                <c:if test="${useBizmekaSpambox == 'YES'}"> 
                <li><span onclick="openSpamBox()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.ldh01" /></span></li>
                </c:if>
	        </ul>
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
	        <h3 style="border-top:0px"><span onclick="mail_Config()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000044" /></span></h3>
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
		    <tr>
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
	</body> --%>
</html>
