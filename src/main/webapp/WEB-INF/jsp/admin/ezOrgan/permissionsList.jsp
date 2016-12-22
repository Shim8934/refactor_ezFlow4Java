<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">	    
	    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var pUse_Editor = "<c:out value='${use_editor}'/>";
	    	var pUse_IE11Browser = "<c:out value='${use_ie11Browser}'/>";	    	
	    	var totalCnt = 0;
	        var CurPage = 1;
	        var totalPage = 0;
	        var pageSize = 15;
	        var BlockSize = 10;
	    	
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        
	        var topid = "";
	        var Tab1_flag = true;
	        var DelType = "c";
	        var type = "c=1";
	    	
			$(document).ready(function() {
				Permissions_List('c=1');
			});			
			
			function company_change() {
				Permissions_List(type);
		    }
		    
			function Permissions_List(type) {		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/getPermissionsList.do",		        	
		        	data : {companyID : document.getElementById("ListCompany").value, type : type, pageNum : CurPage, pageSize : pageSize},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		if (result.xml != "") {
		                    if (result.documentElement.getElementsByTagName("TOTALCNT")[0] != null) {
		                        totalCnt = getNodeText(result.documentElement.getElementsByTagName("TOTALCNT")[0]);
		                        totalPage = Math.ceil(new Number(totalCnt / pageSize));
		                    }
		                } else {
		                    totalCnt = 0;
		                    totalPage = 0;
		                }
		                var xmldom = result;
		                var headerData = createXmlDom();
		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		                
		                if (CrossYN()) {
		                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }

		                document.getElementById("AdminListView").innerHTML = "";

		                var listview = new ListView();
		                listview.SetID("lvPermissionList");
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("Permissions_View");
		                listview.SetHeightFree(true);
		                listview.DataSource(headerData);
		                listview.DataBind("AdminListView");
		                makePageSelPage();
		        	},
		        	error : function(error){
		        	    alert("<spring:message code='ezOrgan.t2' />" + error);
		        	}
		        });		        
		    }
			
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    
		    function goToPageByNum(Value) {
		        CurPage = Value;
		        makePageSelPage();
		        movePage(CurPage);
		    }
		    
		    function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum - 1) > 0) {
		            goToPageByNum(parseInt(pageNum - 1));
		        } else {
		            return;
		        }
		    }
		    
		    function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage) {
		            goToPageByNum(parseInt(pageNum + 1));
		        } else {
		            return;
		        }
		    }

		    function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            Permissions_List(type)
		        }
		    }
			
			function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang23 + "<span style='color:#017BEC;'> " + totalCnt + " </span>" + strLang24 + "]";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16' /></span>"
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16' /></span>"
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16' /></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang28 + "</span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16' /></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang28 + "</span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16' /></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang28 + "</span>";
		            PagingHTML += strtext;
		        }
		        
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        
		        if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        } else {
		            MaxNum = totalPage;
		        }
		        
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang29 + "</span>";
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16' /></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang29 + "</span>";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16' /></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang29 + "</span>";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16' /></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16' /></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16' /></span>";
		            PagingHTML += strtext;
		        }
		        
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		    }
			
			function Permissions_View() {
		        var listview = new ListView();
		        listview.LoadFromID("lvPermissionList");

		        if (listview.GetSelectedRows().length == 0) {
		            alert(strLang13);
		            return;
		        }
		        
		        var id = listview.GetSelectedRows()[0].getAttribute("DATA1");

		        if (CrossYN()) {
		            var OpenWin = window.open("/admin/ezOrgan/permissionsCheck.do?userID=" + encodeURI(id) + "&companyID=" + document.getElementById("ListCompany").value, "Permissions_Check", GetOpenWindowfeature(970, 580));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            window.showModalDialog("/admin/ezOrgan/permissionsCheck.do?userID=" + encodeURI(id) + "&companyID=" + document.getElementById("ListCompany").value, "", "dialogHeight:580px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(970, 580));
		        }
		    }
			
			var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id) {
		            obj.className = "";
		        }
		    }
		    
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null) {
		                document.getElementById(Tab1_SelectID).className = "";
		            }
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    
		    var clickTabID = "1tab1";
		    function ChangeTab(obj) {
		        var pSelectTab = obj.getAttribute("divname");
		        clickTabID = obj.id;
		        DelType = pSelectTab;
		        type = pSelectTab + "=1";

		        CurPage = 1;
		        Permissions_List(type);
		    }
			
			function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;

		                    if (Tab1_flag) {
		                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
		                        Tab1_flag = false;
		                    }
		                }
		            }
		        }
		    }
			
			var permissions_check_dialogArguments = new Array();
		    function Permissions_Add() {
		        var listview = new ListView();
		        listview.LoadFromID("lvPermissionList");
		        var Params = new Array();
		        var result = "";
		        
		        if (CrossYN()) {
		            permissions_check_dialogArguments[0] = Params;
		            permissions_check_dialogArguments[1] = Permissions_Add_Complete;
		            var OpenWin = window.open("/admin/ezOrgan/permissionsCheck.do?companyID=" + document.getElementById("ListCompany").value, "Permissions_Check", GetOpenWindowfeature(970, 580));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            window.showModalDialog("/admin/ezOrgan/permissionsCheck.do?companyID=" + document.getElementById("ListCompany").value, Params, "dialogHeight:580px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(970, 580));
		            Permissions_List(type);
		        }
		    }
		    
		    function Permissions_Add_Complete() {
		        Permissions_List(type);
		    }

		    function Permissions_Del(mode) {
		        var listview = new ListView();
		        listview.LoadFromID("lvPermissionList");
		        var cData = "";

		        if (listview.GetSelectedRows().length == 0) {
		            alert(strLang13);
		            return;
		        }

		        if (mode == "ALL") {
		        	cData = listview.GetSelectedRows()[0].getAttribute("DATA3") + strLang19 + " " + "<spring:message code='ezAddress.t362' />" + strLang20;		                
	            } else {
	            	cData = listview.GetSelectedRows()[0].getAttribute("DATA3") + strLang19 + document.getElementById(clickTabID).innerText + " " + strLang20;
	            }
		        
		        if (confirm(cData)) {
		        	var data2;
		        	
		            if (mode == "ALL") {
		            	data2 = "";		                
		            } else {
		                var tempDelType = DelType;
		                var DelValue = tempDelType + "=1";
		                
		                if (tempDelType == "") {
		                    tempDelType = "c=0";
		                } else {
		                    tempDelType = tempDelType + "=0";
		                }
		                data2 = listview.GetSelectedRows()[0].getAttribute("DATA2").replace(DelValue, tempDelType);		                
		            }

		            $.ajax({
		            	type : "POST",
		            	dataType : "html",
		            	url : "/admin/ezOrgan/saveUserInfo.do",
		            	async : false,
		            	data : {parentCn : "", cn : listview.GetSelectedRows()[0].getAttribute("DATA1"), extensionAttribute1 : data2},
		            	success : function(result){
		            		if (mode == "ALL") {
			                    alert(strLang21);
		            		} else {
			                    alert(strLang22);
		            		}
		            	},
		            	error : function(){
		            		alert(strLang15);
		            	}
		            });
		        }
		        CurPage = 1;
		        Permissions_List(type);
		    }
	    </script>
	</head>
	<body class="mainbody">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t218' /></NAME>
		        		<WIDTH>10%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t67' /></NAME>
		        		<WIDTH>20%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t69' /></NAME>
		        		<WIDTH>10%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t68' /></NAME>
		        		<WIDTH>20%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t91' /></NAME>
		        		<WIDTH>20%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t95' /></NAME>
		        		<WIDTH>10%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t123' /></NAME>
		        		<WIDTH>10%</WIDTH>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	
	    <form id="Form1" method="post">
		    <h1><spring:message code='ezOrgan.t00005' /><span id="mailBoxInfo"></span></h1>
		    <div id="mainmenu">
	        <ul>
	            <span><b><spring:message code='ezOrgan.t00006' /></b></span> 
	            <div style="margin-top:5px;margin-bottom:10px">		           
		            <select id="ListCompany" onchange="company_change()">
		            	<c:forEach var="item" items="${list}">
		            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		            	</c:forEach>
		            </select>
	            </div>
	            <li><span onClick="Permissions_Add()"><spring:message code='ezOrgan.t00007' /></span></li>
	            <li><span onClick="Permissions_Del('MOD')"><spring:message code='ezOrgan.t00008' /></span></li>
	            <li><span onClick="Permissions_Del('ALL')"><spring:message code='ezOrgan.t00009' /></span></li>
	            <li><span onClick="email_onclick()"><spring:message code='ezOrgan.t00010' /></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
	    </script>
	    <div class="portlet_tabpart01" style="padding-bottom:3px">
	        <div class="portlet_tabpart01_top" id="tab1">
                <p id="Permission_sub1"><span divname="c" id="1tab1"><spring:message code='ezOrgan.t291' /></span></p>
                <p id="Permission_sub2"><span divname="k" id="1tab2"><spring:message code='ezOrgan.t293' /></span></p>
                <p id="Permission_sub3"><span divname="g" id="1tab3"><spring:message code='ezOrgan.t295' /></span></p>
                <p id="Permission_sub4" <c:if test="${IsJMochaStandAlone == 'YES'}">style="display:none;"</c:if>><span divname="a" id="1tab4"><spring:message code='ezOrgan.t292' /></span></p>
                <p id="Permission_sub5" <c:if test="${IsJMochaStandAlone == 'YES'}">style="display:none;"</c:if>><span divname="i" id="1tab5"><spring:message code='ezOrgan.t294' /></span></p>
                <p id="Permission_sub6" <c:if test="${IsJMochaStandAlone == 'YES'}">style="display:none;"</c:if>><span divname="n" id="1tab6"><spring:message code='ezOrgan.t297' /></span></p>
                <p id="Permission_sub7" <c:if test="${IsJMochaStandAlone == 'YES'}">style="display:none;"</c:if>><span divname="l" id="1tab7"><spring:message code='ezOrgan.t296' /></span></p>
                <p id="Permission_sub8" <c:if test="${IsJMochaStandAlone == 'YES'}">style="display:none;"</c:if>><span divname="w" id="1tab8"><spring:message code='ezOrgan.t301' /></span></p>
                <p id="Permission_sub9" <c:if test="${IsJMochaStandAlone == 'YES'}">style="display:none;"</c:if>><span divname="m" id="1tab9"><spring:message code='ezOrgan.t300' /></span></p>
	        </div>
	    </div>
	
	    <div class="listview" style="Width:100%; border-top:0px">
	        <div id="AdminListView" style="border: 0px solid #B6B6B6; Width: 100%; Height:445PX; overflow-x: auto; BACKGROUND-COLOR: white; overflow-y:auto; "></div>
	    </div>
	    <div id="tblPageRayer" style="text-align:center"></div>
	</form>         
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>