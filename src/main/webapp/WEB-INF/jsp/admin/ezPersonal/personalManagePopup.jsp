<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>ManagePopUp</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var pUse_Editor = "<c:out value = '${useEditor}' />";
		    var pNoneActiveX = "<c:out value = '${noneActiveX}' />";
		    
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };
			
		    $(document).ready(function(){
		    	if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezPersonal.t106' />");
		        } else {
		            document.getElementById("ListCompany").selectedIndex = 0;
		            company_change();
		        }
		    });
		    
		    function makelist() {		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezPersonal/managePopupList.do",
		        	async : false,
		        	data : {companyID : encodeURIComponent(document.getElementById("ListCompany").value)},
		        	success : function (result) {
		        		event_PopupList(loadXMLString(result));
		        	}
		        });
		    }
		    
		    function event_PopupList(result) {
		        try {
		            document.getElementById("AccessList").innerHTML = "";
		            var xmldom = result;
		            var headerData = createXmlDom();
		            headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
	
		            if (CrossYN()) {
		                var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                var Node = headerData.importNode(xmlRtn, true);
		                headerData.documentElement.appendChild(Node);
		            } else {
		                var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                headerData.documentElement.appendChild(xmlRtn);
		            }
		            
		            var listview = new ListView();
		            listview.SetID("AccessListView");
		            listview.SetSelectFlag(false);
		            listview.SetMulSelectable(true);
		            listview.SetRowOnDblClick("PopupList_onDblclick");
		            listview.DataSource(headerData);
		            listview.DataBind("AccessList");
		            //listview.DataSource(xmldom);
		            listview.RowDataBind();
		            xmldomNode = null;
		        } catch (e) {
	
		        }
		    }
	
		    function company_change() {
				makelist();
		    }
	
		    function add_popup() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 620) / 2;
		        var pLeft = (pwidth - 820) / 2;
		        var compid = document.getElementById("ListCompany").value;
	
		        if (browserIE) {
		            if(pNoneActiveX == "YES") {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            } else if (pUse_Editor == "TAGFREE") {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            } else {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            }
		        } else {
		            if (pUse_Editor == "TAGFREE") {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            } else {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            }
		        }
		    }
		    
		    function mod_popup(popup_number) {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 620) / 2;
		        var pLeft = (pwidth - 820) / 2;
		        var compid = document.getElementById("ListCompany").value;
	
		        if (CrossYN()) {
		            if (pUse_Editor == "TAGFREE") {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&itemSeq=" + popup_number, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            } else {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&itemSeq=" + popup_number, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            }
		        } else {
		            if (pUse_Editor == "TAGFREE") {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&itemSeq=" + popup_number, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            } else {
		                window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&itemSeq=" + popup_number, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=620,width=820,top=" + pTop + ",left=" + pLeft, "");
		            }
		        }
		        //if (typeof (rtnValue) != "undefined")
		        //    makelist();
		    }
	
		    var pUse_Editor = "<c:out value = '${useEditor}' />";
		    function PopupList_onDblclick(obj) {
		        var popup_number = document.getElementById(obj).getAttribute("DATA1");
		        var wWidth = document.getElementById(obj).getAttribute("DATA2");
		        var wHeight = document.getElementById(obj).getAttribute("DATA3");
		        var wPosition = document.getElementById(obj).getAttribute("DATA4");
		        var wVertical, wHorizontal;
	
		        if (wPosition == 0) {
		            wVertical = Math.floor(screen.height / 2) - (wHeight / 2);
		            wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
		        } else if (wPosition == 1) {
		            wVertical = 100;
		            wHorizontal = 100;
		        } else if (wPosition == 2) {
		            wVertical = screen.height - wHeight - 100;
		            wHorizontal = 100;
		        } else if (wPosition == 3) {
		            wVertical = 100;
		            wHorizontal = screen.width - wWidth - 100;
		        } else if (wPosition == 4) {
		            wVertical = screen.height - wHeight - 100;
		            wHorizontal = screen.width - wWidth - 100;
		        } else if (wPosition == 5) {
		            wVertical = 100;
		            wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
		        } else if (wPosition == 6) {
		            wVertical = screen.height - wHeight - 100;
		            wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
		        } else {
		            wVertical = 0;
		            wHorizontal = 0;
		        }
	
		        if (wVertical < 0) {
		            wVertical = 0;
		        }
		        
		        if (wHorizontal < 0) {
		            wHorizontal = 0;
		        }
		        
		        window.open("/admin/ezPersonal/showPopup.do?itemSeq=" + popup_number +
		            "&answer=", "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
		    }
	
		    function del_popup(popup_number) {
		        if (!confirm(popup_number + "<spring:message code = 'ezPersonal.t159' />")) {
		            return;
		        }
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/delPopup.do",
		        	async : false,
		        	data : {itemSeq : popup_number},
		        	dataType : "text",
		        	success : function (result) {
		        		if (result != "OK") {
		        			alert("<spring:message code = 'ezPersonal.t160' />");
		        		} else {
		        			alert("<spring:message code = 'ezPersonal.t161' />");
				            makelist();
		        		}
		        	}
		        });
		    }
		</script>
	</head>
	<body class = "mainbody">
		<xml id="listviewheader" style ="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t166' /></NAME>
						<WIDTH>40</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t154' /></NAME>
						<WIDTH></WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t241' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
					  	<NAME><spring:message code = 'ezPersonal.t242' /></NAME>
					  	<WIDTH>80</WIDTH>
					</HEADER>
				  	<HEADER>
						<NAME><spring:message code = 'ezPersonal.t169' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t99' /></NAME>
					    <WIDTH>80</WIDTH>
					</HEADER>
			    </HEADERS>
			</LISTVIEWDATA>
		</xml>
		
	    <form method="post">
			<h1><spring:message code = 'ezPersonal.t266' /></h1>
			<div id="mainmenu">
				<ul>
					<li style="background:none">
						<SELECT id="ListCompany" name="ListCompany" onChange="company_change()">
				        	<c:forEach var="item" items="${list}">
			            		<option value="<c:out value='${item.cn}'/>" ><c:out value='${item.displayName}'/></option>
			            	</c:forEach>
			        	</SELECT>
			        </li>
					<li><span onClick="add_popup()"><spring:message code = 'ezPersonal.t158' /></span></li>
				</ul>
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			<table class="mainlist" style="width:100%;">
				<div id=AccessList style ="border:0;width:100%"></div>
			</table>
		</form>
	</body>
</html>