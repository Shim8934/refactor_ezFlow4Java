<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email_tree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style>
			/* ellipisis 추가 */
			.node_normal{
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		width:146px;
	    	}
	    	.node_selected{
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    	}	  
	    	#mCSB_1_container {
				margin-right: 0px;
			}  	
			#newCircularCount, #circularCompleteCount, #myCircularCount, #circularTempCount, #circularDeleteCount{  
				pointer-events: none;
			}
		</style>
	    <script type="text/javascript">
	        document.onselectstart = function () { return false; };
	        
	        window.onresize = function () {
// 	            if (document.documentElement.clientHeight > 900) {
// 	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";	                
// 	            }
// 	            else {
// 	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";	                
// 	            }
	        }
	        
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
// 	            if (document.documentElement.clientHeight > 900) {
// 	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";	                
// 	            }
// 	            else {
// 	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";	                
// 	            }
	            
	            LoadEmailTree();
	            
	            /* 2017-05-18 장진혁 신규회람판에 클릭이벤트 생성 */ 
	            $("#newCircular").click();
	            
	            getNewCircularCount();
	            
	           	applyEllipsis();
	           	
	           	leftResize();
		        $(".circularListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
		        liSelected();
	        }
	        
	        /** ellipsis 추가 */
	        function applyEllipsis() {
	        	$("[id^=PostTreeView_node]").each(function (index, element) {
	        		var title = $(element)[0].innerHTML;
	        		$(element).attr("title", title);
	        	} );
	        	
	        }
	        
	        function LoadEmailTree() {	
	        	$.ajax({
            		type : "POST",
            		url : "/ezCircular/getCircularFolderList.do",
            		async : false,
            		dataType : "text",
            		data : {},
            		success : function(result) {
            			$("#RootFolderXML").html("");
	            		$("#RootFolderXML").append(result);
            		}
	        	});
	        	
	            var PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
	            PostTreeView.attachEvent('requestdata', requestdata);
	            PostTreeView.attachEvent('nodeselect', selectnode);
	            PostTreeView.attachEvent('nodedblclick', function () { PostTreeView.toggle(PostTreeView.selectedIndex()) });
	            PostTreeView.dragdrop(true);
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	            var treeconfig;
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            } else {
	                treeconfig = xmlHTTP.responseXML;
	            }

	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + document.getElementById("RootFolderXML").innerHTML + "</nodes></tree>");
	            PostTreeView.update();
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
	            var folderId = PostTreeView.getvalue(nodeIdx, "href");
	            
	            var url = "/ezCircular/circularFolderDoc.do?folderId=" + folderId;
 	            
				window.open(url, "right");
	        }

	        /* 2023-06-14 황인경 - 디자인 개선 > 회람판 > 좌측메뉴 > 트리구조 LNB 이미지 수정 */
	        /* 2017-05-17 장진혁 구현 */
	        function openFolder() {
	        	var h2Title = $(event.target).parent();
	        	var arrowSpan = $(event.target).prev();
	        	
	        	if (h2Title.hasClass("off")) {
					$("h2.on").attr("class", "off");
	        		$(".sub_iconLNB.tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		        	$(".lnbUL").attr("class", "lnbUL off");
	        		h2Title.attr("class", "on");
	        		h2Title.children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
	        		h2Title.next().attr("class", "lnbUL on");
	        		
	        		if (h2Title.next().children().eq(0).attr("id") == "PostTreeView") {
						$("#PostTreeView").css("display", "");
	        		}

	        	} else {
	        		$("h2.on").attr("class", "off");
	        		h2Title.children().eq(0).attr("class", "sub_iconLNB tree_plus");
	        		h2Title.next().attr("class", "lnbUL off");
	        		
	        		if (h2Title.next().children().eq(0).attr("id") == "PostTreeView") {
	        			$("#PostTreeView").css("display", "none");
					}

	        	}
				/*if ($("#PostTreeView").css("display") == "none") {	        	
 	        		$("#PostTreeView").css("display", "");
 	        	} else {
 	        		$("#PostTreeView").css("display", "none");
 	        	} */
	        }
	        
	        function folder_Manage() {
	        	var OpenWin = window.open("/ezCircular/circularFolderManage.do", "", GetOpenWindowfeature(500, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        
	        /* 2017-05-17 정수현 구현 */
	        function newCircular() {
	        	window.parent.frames["right"].location.href = "/ezCircular/newCircular.do";
	        	getNewCircularCount();
	        }
	        
	        function circularComplete() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularComplete.do";
	        	getNewCircularCount();
	        }
	        
	        function circularMyCircular() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularMyCircular.do";
	        	getNewCircularCount();
	        }
	        
	        function circularTemp() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularTemp.do";
	        	getNewCircularCount();
	        }
	        
	        function circularDelete() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularDelete.do";
	        	getNewCircularCount();
	        }
	        
	        function circularConfig() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularConfig.do";
	        	getNewCircularCount();
	        }

	        function circular_Search() {
	        	window.parent.frames["right"].location.href = "/ezCircular/circularSearchView.do";
	        	getNewCircularCount();
	        }
	        
	        function getNewCircularCount() {
	        	$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezCircular/getListCount.do",
					data : {
						listType : 'newCircular'
					},
					success: function(result){
						var rcnt;
						
						if (result.count == "0") {
							rcnt = "";	
						} else {
							rcnt = "(" + result.count + ")";
						}
						$("#newCircularCount").html(rcnt);
					}
				});
	        }

	        /* function getCircularCompleteCount() {
	        	$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezCircular/getListCount.do",
					data : {
						listType : 'circularComplete'
					},
					success: function(result){
						$("#circularCompleteCount").html("(" + result.count + ")");
					}
				});
	        }
	        
	        function getMyCircularCount() {
	        	$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezCircular/getListCount.do",
					data : {
						listType : 'myCircular'
					},
					success: function(result){
						$("#myCircularCount").html("(" + result.count + ")");
					}
				});
	        }
	        
	        function getCircularTempCount() {
	        	$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezCircular/getListCount.do",
					data : {
						listType : 'circularTemp'
					},
					success: function(result){
						$("#circularTempCount").html("(" + result.count + ")");
					}
				});
	        }
	        
	        function getCircularDeleteCount() {
	        	$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezCircular/getListCount.do",
					data : {
						listType : 'deleteCircular'
					},
					success: function(result){
						$("#circularDeleteCount").html("(" + result.count + ")");
					}
				});
	        } */
	        
	        //2018-07-17 김보미 - 프로그레스바
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
			
			var writeboardselect_modal_dialogArguments = new Array();
			function CircularWrite_onclick() {
				var feature = GetOpenPosition(820, 900);
				url = "/ezCircular/circularWrite.do?mode=write";
				var OpenWin = window.open(url, "", "width=820, height=900, status=no, toolbar=no, menubar=no,location=no,resizable=1" + feature);
			    OpenWin.focus();     
			}
			
			function getLeftCount() {		    	
		    	getNewCircularCount();		    	
		    }
			
			function refresh_onclick() {
				parent.frames["right"].refresh_onclick();
		    }
			
			function leftResize(){
	        	$(".circularListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
	        
		     // 2023-06-14 황인경 - 디자인 개선 > 회람판 > 좌측메뉴 > 트리구조 LNB 이미지 추가 
		     function liSelected() {
		    	 var defaultUl = document.getElementById("defaultCircular");
			     var defaultLi = defaultUl.getElementsByTagName("li");
			     
				 for (var i = 0; i < defaultLi.length; i++) {
					 defaultLi[i].addEventListener("click", function() {
						$("#compUL span.node_selected").attr("class", "node_normal");
						var selectedList = defaultUl.querySelector(".node_selected");
		 				
						if (selectedList != null) {
							$(selectedList).removeClass("node_selected");
						    $(event.target).addClass("node_selected");
						} else {
						    $(event.target).addClass("node_selected");
						}
			       	});
			     }
		     }
	    </script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb circular_left" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code="ezCircular.t1" />">
	    		<spring:message code="ezCircular.t1" />
	        	<span class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezCircular.t10" />" onclick="circularConfig()"></span>
	        </div>
	        <div class="btn_writeBox">
	        	<p class="btn_write01" onClick="CircularWrite_onclick()"><spring:message code='ezCircular.t55'/></p>
	        </div>
	        <div class="circularListBox" style="overflow:hidden; padding-right: 0;">
		        <%-- 2023-06-30 황인경 - 디자인 개선 > 회람판 > 좌측메뉴 > 최상위 '회람판' 메뉴 표시 추가 --%>
		        <h2 class="on">
					<span class="sub_iconLNB tree_arrow_down"></span>
			        <span class="h2Title" onclick="openFolder()"><spring:message code="ezCircular.t1" /></span>
		        </h2>
		        <ul class="lnbUL clicked" id="defaultCircular">
                   	<li><span class="list_text node_selected" id="newCircular" onclick="newCircular()"><spring:message code="ezCircular.t2" /><span id="newCircularCount"></span></span></li>
                   	<li><span class="list_text" id="circularComplete" onclick="circularComplete()"><spring:message code="ezCircular.t3" /><span id="circularCompleteCount"></span></span></li>
                   	<li><span class="list_text" id="circularMyCircular" onclick="circularMyCircular()"><spring:message code="ezCircular.t4" /><span id="myCircularCount"></span></span></li>
                   	<li><span class="list_text" id="circularTemp" onclick="circularTemp()"><spring:message code="ezCircular.t5" /><span id="circularTempCount"></span></span></li>
                   	<li><span class="list_text" id="circularDelete" onclick="circularDelete()"><spring:message code="ezCircular.t6" /><span id="circularDeleteCount"></span></span></li>
                   	<li><span class="list_text" onclick="circular_Search()"><spring:message code="ezCircular.t8" /></span></li>
		        </ul>
		        <h2 class="off" id="compH2">
                   	<span class="sub_iconLNB tree_plus"></span><span class="sub_iconLNB tree_manage" onclick="folder_Manage()"></span><span class="h2Title" onclick="openFolder()"><spring:message code="ezCircular.t7" /></span>
		        </h2>
		        <ul class="lnbUL off" id="compUL">
                    <div class="tree onlytree circularDoc" id="PostTreeView" style="display:none;"></div>
		        </ul>
	        </div>
	    </div>
	    <%-- <div id="left">
	        <div class="left_circular" title="<spring:message code="ezCircular.t1" />"><span><spring:message code="ezCircular.t1" /></span></div>
	        <h2><span style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t1" /></span></h2>				
	        <ul id="iconul">
	        	<li onclick="newCircular()"><span style="width:100%;display:inline-block;" id="newCircular"><img src="/images/ImgIcon/icon_approval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t2" /><span id="newCircularCount"></span></span></li>
				<li onclick="circularComplete()"><span style="width:100%;display:inline-block;" id="circularComplete"><img src="/images/ImgIcon/icon_ingapproval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t3" /><span id="circularCompleteCount"></span></span></li>
				<li onclick="circularMyCircular()"><span style="width:100%;display:inline-block;" id="circularMyCircular"><img src="/images/ImgIcon/icon_writeapproval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t4" /><span id="myCircularCount"></span></span></li>				
				<li onclick="circularTemp()"><span style="width:100%;display:inline-block;" id="circularTemp"><img src="/images/ImgIcon/icon_extraappr.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t5" /><span id="circularTempCount"></span></span></li>
				<li onclick="circularDelete()"><span style="width:100%;display:inline-block;" id="circularDelete"><img src="/images/ImgIcon/deleted.gif" width="16" height="16" class="icon" style="margin-left:-1px"><spring:message code="ezCircular.t6" /><span id="circularDeleteCount"></span></span></li>
				<li id="circularDoc" onclick="openFolder()"><span style="width:100%;display:inline-block;"><img src="/images/ImgIcon/icon_partapproval.gif" width="16" height="16" class="icon"><span><spring:message code="ezCircular.t7" /></span>&nbsp;&nbsp;<img src="/images/cllps.gif" id="openImg" class="icon"></span></li>	            
	        </ul>
	        <div class="tree" style="height: 0px;background-color: #ffffff; overflow: auto; padding:0px; border-bottom:1px solid #eaeaea;" id="PostTreeView"></div>
	        <ul id="extra">    
	            <li><span onclick="circular_Search()" style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t8" /></span></li>
	            <li><span onclick="folder_Manage()" style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t9" /></span></li>	            
	        </ul>	       
	        <div class="extra">
	        	<span onclick="circular_Search()" style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t8" /></span>
	        	<span onclick="folder_Manage()" style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t9" /></span>
	        </div> 
	        <h3 style="border-top:1px solid #eaeaea"><span onclick="circularConfig()" style="width:100%;display:inline-block;"><spring:message code="ezCircular.t10" /></span></h3>
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script> --%>
	    <xml id="RootFolderXML" style="display: none;"></xml>
	    <!-- 2018-07-17 김보미 - 프로그레스바 -->
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;display:none;" id="progressPanel">&nbsp;</div>
	</body>
</html>