<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t330" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('/css/style.css')}" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" />
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style>
			/* .node_selected
			{
			    font-size: 13px;
			    height: 30px;
			    line-height: 30px;
			    color: #0470e4;
			    display: inline-block;
			    padding: 0px 0px 0px 5px;
			    font-family: Malgun Gothic, malgun gothic;
			    cursor: pointer;
			    width: 76%;
			    white-space: nowrap;
			    text-overflow: ellipsis;
			    overflow: hidden;
			    box-sizing: border-box;
			    font-weight: bold;
			} */
			
			.node_div {height:30px;}
			
			#mCSB_1_container {
				margin-right: 0px;
			}
		</style>
		 <script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCar/organtreeview.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCar/CarTreeInfo_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		
		<script type="text/javascript" id="clientEventHandlersJS" >
		    var carId		= "${carID}";			
    		var Car_Nm		= "<c:out value='${carNm}' />";			
    		var brdGubun	= "${brdGubun}";		
    		var g_UserID	= "${userID}";
    		var g_DeptID	= "${deptID}";
    		var g_DeptPath	= "${deptPathCode}";
    		var pCompanyID	 = "${companyID}";
    		var g_AccessCode = "${strAccessCode}";
    		var g_ServerName = "${serverName}";
    		var selectNo = "${selectNo}";


    		
		    function TreeView_onNodeDblClick() {
        		TreeView.toggle(TreeView.selectedIndex());
    		}

		    window.onresize = function () {
//         		document.getElementById("TreeView").style.height = document.documentElement.clientHeight - 125 + "px";
    		}

    		window.onload = function () {
    			
//         		document.getElementById("TreeView").style.height = document.documentElement.clientHeight - 125 + "px";
        		var TreeView = new organtreeview('TreeView', 'TreeView');
        		TreeView.attachEvent('requestdata', TreeView_onNodeExpanded);
        		TreeView.attachEvent('nodeselect', TreeView_onNodeClick);
        		TreeView.attachEvent('nodedblclick', TreeView_onNodeDblClick);

        		var xmlHTTP = createXMLHttpRequest();
        		xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
        		xmlHTTP.send();

		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
        		    TreeView.server("${serverName}");
            		TreeView.config(xmlHTTP.responseXML);
            		TreeView.update();
        		}
        		TreeLoad();
        		
        		
        		
        		leftResize();
		        $(".resourceListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
    		}

    		function locationInfo(pBrdNm) {
        		var idx = "7";
        		navigation_info = "<a href='/ezCar/carMain.do' target='main' class='n'><spring:message code='ezResource.t334' /></a>"
        		if (pBrdNm != "")
            		navigation_info += " > " + encodeURI(pBrdNm) + "</a>";
    		}

    		/* 2018-05-21 홍승비 - 등록된 상위자원 없는 경우 메세지 출력 수정 */
    		function TreeLoad() {
        		initTreeInfo("", g_UserID, g_DeptID);                                                       
        		
        		if(document.getElementById("TreeView").innerText == "") {
        			var msg = "<spring:message code='ezResource.t368' />";
        			var strUrl = "/ezResource/nonResList.do?msg="+encodeURIComponent(msg);
            		locationInfo("");
            		Navigate(strUrl);
        		}
    		}

    		
    		function TreeView_onNodeExpanded(event) {
        		displayBrdTree.call(this, g_UserID, g_DeptID, event);
        		//자동차명에 툴팁뜨도록 수정
        		for(var i=0; i<document.getElementsByClassName("node_normal").length; i++){
        		    document.getElementsByClassName('node_normal')[i].setAttribute('TITLE',document.getElementsByClassName('node_normal')[i].innerText);
        		}
    		}

		    function TreeView_onNodeClick() {
		        var i = "";
		        var arrName = "";
		        var RealPath = "";
		        var brdID = "";
		        var chkVal = false;
		        g_SelTree = TreeView;
		        var selNode = TreeView.selectedIndex();
		        if (selNode == null) {
            		var strUrl = "/ezCar/nonResList.do";
            		locationInfo(RealPath);
            		Navigate(strUrl);
        		} else {
            		nodeIdx = selNode;
            		var OriginNode = selNode;
            		if (g_AccessCode != "0") g_AccessCode = TreeView.getvalue(nodeIdx, "DATA14");
            		var number = parseInt(TreeView.getvalue(nodeIdx, "DATA3"))
            		for (i = 2; i <= number; i++) {
                		var brdID = TreeView.getvalue(nodeIdx, "DATA1");
                		var brdNm = TreeView.getvalue(nodeIdx, "DATA2");
                		var boardGubun = TreeView.getvalue(nodeIdx, "DATA7");
                		document.getElementById(TreeView.gnodeid() + nodeIdx).className = "node_selected";
                		//document.getElementById(TreeView.gnodeid() + nodeIdx).setAttribute('title',TreeView.getvalue(nodeIdx,"DATA2"));

        		        if (boardGubun == "1" ) {
                    		if ((!chkVal && i == 2) || (chkVal && i == 3)) {
                        		RealPath = "&nbsp;<a href=" + "listResource.do?brdID=" + brdID + "&brdNm=" + encodeURIComponent(brdNm) + "&AccessCode=" + g_AccessCode + " target='right' class='n'>" + brdNm + "</a>" + RealPath;
                    		} else {
                        		RealPath = "&nbsp;<a href=" + "listResource.do?brdID=" + brdID + "&brdNm=" + encodeURIComponent(brdNm) + "&AccessCode=" + g_AccessCode + " target='right' class='n'>" + brdNm + "&nbsp;></a>" + RealPath;
                    		}
                		} else {
                    		chkVal = true;
                		}
            		}
            		locationInfo(RealPath);
            		GetTreeBrdsInfo();
        		}
    		}
		    var schedule_add_select_cross_dialogArguments = new Array();
		    
		    function resourceWrite() {
		    	if (CrossYN()) {
                    var url = "/ezResource/scheduleAddSelect.do";

                    schedule_add_select_cross_dialogArguments[0] = "";
                    schedule_add_select_cross_dialogArguments[1] = btnWrite_onclick_Complete;
                    var Schedule_Add_Select_Cross = GetOpenWindow(url, "Schedule_Add_Select_Cross", 552, 435);
                    try { Schedule_Add_Select_Cross.focus(); } catch (e) {
                    }
                } else {
                    var url = "/ezResource/scheduleAddSelect.do";
                    var feature = "status:no;dialogWidth:552px;dialogHeight:430px;help:no;scroll:no;edge:sunken";
                    feature = feature + GetShowModalPosition(552, 422);
                    var ret = window.showModalDialog(url, "", feature);

                    if (ret != undefined && ret[0][0] != undefined) {
                        url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0];
                        feature = "status:no;dialogWidth:770px;dialogHeight:700px;help:no;scroll:no;edge:sunken";
                        feature = feature + GetShowModalPosition(700, 700);
                        window.showModalDialog(url, ret, feature);
                    }
                }
		    }
		    
		    function btnWrite_onclick_Complete(ret) {
		        if (ret != "close" && ret != undefined && ret[0][0] != undefined) {
		            url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0];

		            var Schedule_Add_ck = window.open(url, "Schedule_Add_Cross", GetOpenWindowfeature(820, 700));
		            
		            try { Schedule_Add_ck.focus(); } catch (e) {}
		        }
		    }
		    
		    function leftResize(){
	        	$(".resourceListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
	</script> 
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code="ezCar.shb01" />">
	    		<spring:message code="ezCar.shb01" />
	        </div>
	        <%-- <div class="btn_writeBox">
	        	<p class="btn_write01" onclick='resourceWrite()'><span class="sub_iconLNB tree_write"></span><spring:message code="ezCar.shb02" /></p>
	        </div> --%>
	        <div class="resourceListBox" style="overflow:hidden; padding-right: 0;">
		        <ul class="lnbUL resLnb_tree">
		        	<div class="tree onlytree" id="TreeView" style="overflow-y: hidden; height: 100%;"></div>
		        	<!-- <div class="tree">
		            	<span>
		                	<span>
		                    	<span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_minus"></span><span class="sub_iconLNB tree_folder"></span><span class="h2_text">회의실</span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_resource_standard"></span><span class="h2_text">3층대회의실</span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_resource_standard"></span><span class="h2_text">3층소회의실</span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_resource_standard"></span><span class="h2_text">5층대회의실</span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_resource_standard"></span><span class="h2_text">5층소회의실</span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_minus"></span><span class="sub_iconLNB tree_folder"></span><span class="h2_text">공용차량</span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_resource_ok"></span><span class="h2_text">공용차량(13하1330)</span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_minus"></span><span class="sub_iconLNB tree_folder"></span><span class="h2_text">빔프로젝트</span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_resource_no"></span><span class="h2_text">빔프로젝트01</span>
		                            </div>
		                    	</span>
		                    </span>        
		                </span>
		            </div> -->
		        </ul>
	        </div>
	    </div>
		<%-- <div id="left">
	        <div class="left_resource" title="<spring:message code="main.t28" />"><span><spring:message code="main.t28" /></span></div>
	        <h2 style="background-color:#FFFFFF;"><span id="menu01" ><spring:message code="ezResource.t342" /></span></h2>
	        <ul style="overflow-x:hidden ;overflow-y:auto;">
	            <div class="tree" id="TreeView" style="height:auto;border:#ddd 0px solid; background-color:#ffffff; vertical-align:top;padding-left:20px;background-color:#ffffff;" ></div>
	        </ul>
	    </div> --%>
	</body>
</html>