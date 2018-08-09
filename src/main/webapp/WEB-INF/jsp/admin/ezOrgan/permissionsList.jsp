<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">	    
	    <link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/Tab.css")%>" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e3'/>" type="text/css">
	    <style>
	    .mainlist_free tr td:first-child {
	    		padding-left:10px;
	    		height:25px;
	    }
	    .mainlist_free tr th:first-child {
	    		padding-left:10px;
	    }
	    </style>
	    <script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/mouseeffect.js")%>"></script>
	    <script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
	    <script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezOrgan/TreeView.js")%>"></script>
	    <script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezOrgan/ListView_list.js")%>"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
		<script type="text/javascript" language="javascript">
			var pUse_Editor = "<c:out value='${use_editor}'/>";
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
			    if (${isAdmin}) {
			    	type = 'c=1';
			        Permissions_List();
			    } else {
		            document.getElementById("Permission_sub1").style.display = "none";
		            document.getElementById("1tab2").click();
		            type = 'k=1';
		            Permissions_List();			        
			    }
			    
			    //2018-08-06 김보미 - 페이지 위치 고정
			    windowResize();
			});
			
			function searchList() {
				CurPage = 1;
				Permissions_List();
			}
			
			function company_change() {
				clearSearchVal();
				Permissions_List();
		    }
		    
			function Permissions_List() {
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/getPermissionsList.do",		        	
		        	data : {companyID : document.getElementById("ListCompany").value, type : type, pageNum : CurPage, pageSize : pageSize, searchType : document.getElementById("searchType").value, searchValue : document.getElementById("searchValue").value},
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
		            Permissions_List();
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
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' /></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' /></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' /></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' /></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' /></span>";
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
		                strtext = "";
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' /></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' /></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' /></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' /></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' /></span>";
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
		        clearSearchVal();
		        Permissions_List();
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
		            clearSearchVal();
		            Permissions_List();
		        }
		    }
		    
		    function Permissions_Add_Complete() {
		    	clearSearchVal();
		        Permissions_List();
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
		        Permissions_List();
		    }
		    
		    function email_onclick() {

		        var listview = new ListView();
		        listview.LoadFromID("lvPermissionList");

		        if (listview.GetSelectedRows().length == 0) {
		            alert(strLang13);
		            return;
		        }

		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;


		        var MsgTo = "\"" + GetAttribute(listview.GetSelectedRows()[0],"DATA3") + "\" <" + GetAttribute(listview.GetSelectedRows()[0],"DATA4") + ">";

		        /* 2017-01-02 이효민사원
		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW&msgTo=" + encodeURIComponent(MsgTo), "",
		                           "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        }
		        else {
		            if (pUse_Editor == "")
		                window.open("/myoffice/ezEmail/mail_write.aspx?cmd=NEW&msgTo=" + encodeURIComponent(MsgTo), "",
		                                "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		            else {
		                window.open("/myoffice/ezEmail/mail_write_IE.aspx?cmd=NEW&msgTo=" + encodeURIComponent(MsgTo), "",
		                            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		            }
		        } */
		        window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(MsgTo), "",
                        "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }
		    
		    function clearSearchVal () {
		    	$("#searchValue").val("");
		    }
		    
            //2018-08-06 김보미 - 페이지 위치 고정
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 170 - document.getElementById("mainmenu").clientHeight;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
	    </script>
	</head>
	<body class="mainbody">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t218' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t67' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t69' /></NAME>
		        		<WIDTH>10%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t68' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t91' /></NAME>
		        		<WIDTH>25%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t95' /></NAME>
		        		<WIDTH>10%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t123' /></NAME>
		        		<WIDTH>10%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	
	    <form id="Form1" method="post">
		    <h1><spring:message code='ezOrgan.t00005' /><span id="mailBoxInfo"></span></h1>
		    <div id="mainmenu">
			    <span><b><spring:message code='ezOrgan.t00006' /> : </b></span>    		           
	            <select id="ListCompany" onchange="company_change()">
	            	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
	            </select>
	            
		        <ul style="margin-top:15px;">
		            <li><span onClick="Permissions_Add()"><spring:message code='ezOrgan.t00007' /></span></li>
		            <!-- <li style="padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
		            <li><span onClick="Permissions_Del('MOD')"><spring:message code='ezOrgan.t00008' /></span></li>
		            <li><span onClick="Permissions_Del('ALL')"><spring:message code='ezOrgan.t00009' /></span></li>
		            <!-- <li style="padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
		            <li><span onClick="email_onclick()"><spring:message code='ezOrgan.t00010' /></span></li>
		            
		            <span style="float: right; font-weight: normal; color: black; clear:inherit;margin-left:1px">
		            	<select id="searchType" style="width:80px;">
							<option selected="" value="displayname"><spring:message code='ezOrgan.t67' /></option>
							<option value="cn"><spring:message code='ezOrgan.t218' /></option>
							<option value="title"><spring:message code='ezOrgan.t69' /></option>
							<option value="description"><spring:message code='ezOrgan.t68' /></option>
							<option value="mail"><spring:message code = 'ezOrgan.t91' /></option>
							<option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
							<option value="company"><spring:message code= 'ezOrgan.t123' /></option>
						</select>
						
						<input id="searchValue" onkeypress="if(event.keyCode==13) {searchList(); return false;}" onfocus="clearSearchVal();" style="height: 29px;border: 1px solid #cbcbcb; border-right:0px;">
						<a href="#" style="float: right"><img src="/images/bsearch_new.gif" border="0" onclick="searchList()" style="height:29px;"></a>
		            </span>
		        </ul>
		    </div>
		    <script type="text/javascript">
		        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
		    </script>
		    <div class="portlet_tabpart01" style="padding-bottom:3px; width:100%;">
		        <div class="portlet_tabpart01_top" id="tab1">
	                <p id="Permission_sub1"><span divname="c" id="1tab1"><spring:message code='ezOrgan.t291' /></span></p>
	                <p id="Permission_sub2"><span divname="k" id="1tab2"><spring:message code='ezOrgan.t293' /></span></p>
	                <p id="Permission_sub3"><span divname="g" id="1tab3"><spring:message code='ezOrgan.t295' /></span></p>
	                <p id="Permission_sub4"><span divname="a" id="1tab4"><spring:message code='ezOrgan.t292' /></span></p>
	                <p id="Permission_sub5" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="i" id="1tab5"><spring:message code='ezOrgan.t294' /></span></p>
	                <p id="Permission_sub6"><span divname="n" id="1tab6"><spring:message code='ezOrgan.t297' /></span></p>
	                <p id="Permission_sub7"><span divname="l" id="1tab7"><spring:message code='ezOrgan.t296' /></span></p>
	                <p id="Permission_sub8" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="w" id="1tab8"><spring:message code='ezOrgan.t301' /></span></p>
	                <p id="Permission_sub9" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="m" id="1tab9"><spring:message code='ezOrgan.t300' /></span></p>
	                <c:if test="${approvalForDoc == 'Y'}">
	                	<p id="Permission_sub10"><span divname="f" id="1tab10"><spring:message code='ezOrgan.lhj1' /></span></p>
	                </c:if>
	                <p id="Permission_sub11"><span divname="wf" id="1tab11"><spring:message code='ezOrgan.t303' /></span></p>
	                <p id="Permission_sub12" <c:if test="${use_attitude != 'YES'}">style="display:none;"</c:if>><span divname="wa" id="1tab12"><spring:message code='ezOrgan.kbm01' /></span></p>
		        </div>
		    </div>
		    <!-- 2018-08-06 김보미 - 페이지 위치 고정 -->
<!-- 		    <div class="listview" style="Width:100%;"> -->
<!-- 		        <div id="AdminListView" style="border: 0px solid #ddd; Width: 100%; Height:540px; /* overflow-x: auto; */ BACKGROUND-COLOR: white; /* overflow-y:auto; */"></div> -->
<!-- 		    </div> -->
			<div id="contentlist" style="width:100%; overflow: auto;">
			    <div class="listview">
			        <div id="AdminListView" style="border: 0px solid #ddd; Width: 100%; Height:540px; /* overflow-x: auto; */ BACKGROUND-COLOR: white; /* overflow-y:auto; */"></div>
			    </div>
			</div>
		    <div id="tblPageRayer" style="Width:100%;text-align:center;margin-top:10px"></div>
		</form>         
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>