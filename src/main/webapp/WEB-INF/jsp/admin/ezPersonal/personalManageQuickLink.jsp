<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var Strmessage = "<spring:message code = 'ezPersonal.t1022' />";
	        var xmlhttp = null;
			
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
	        $(document).ready(function() {
	        	$.ajax({
	        		type : "POST",
	        		url : "/admin/ezPersonal/getQuickLinkList.do",
	        		dataType : "text",
	        		success : function(result) {
	        			event_QuickList(loadXMLString(result));
	        		}
	        	});
	        });
	        
	        function event_QuickList(result) {
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
	                listview.SetRowOnDblClick("QuickList_onDblclick");
	                listview.DataSource(headerData);
	                listview.DataBind("AccessList");
	                //listview.DataSource(xmldom);
	                listview.RowDataBind();
	                xmldomNode = null;
	                xmldom = null;
	            } catch (e) {
	
	            }
	        }
	        var addquicklink_dialogArguments = new Array();
	        function btn_Select() {
	            if (CrossYN()) {
	                addquicklink_dialogArguments[0] = "";
	                addquicklink_dialogArguments[1] = btn_Select_Complete;
	                var AddQuickLink = window.open("/admin/ezPersonal/addQuickLink.do?mode=new", "AddQuickLink", GetOpenWindowfeature(405, 625));
	                try { AddQuickLink.focus(); } catch (e) {
	                }
	            } else {
	                var rtnValue = window.showModalDialog("/admin/ezPersonal/addQuickLink.do?mode=new", "", "dialogHeight:620px;dialogwidth:400px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(405, 625));
	                window.location.reload();
	            }
	        }
	
	        function btn_Select_Complete() {
	            window.location.reload();
	        }
	
	        function QuickList_onDblclick() {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var listviewSelected = listview.GetSelectedRows();
	            if (listviewSelected == "") {
	                alert(Strmessage);
	                return;
	            }
	
	            if (CrossYN()) {
	                addquicklink_dialogArguments[0] = listviewSelected[0].getAttribute("data1");
	                addquicklink_dialogArguments[1] = btn_Select_Complete;
	                var AddQuickLink = window.open("/admin/ezPersonal/addQuickLink.do?mode=modify", "AddQuickLink", GetOpenWindowfeature(405, 625));
	                try { AddQuickLink.focus(); } catch (e) {
	                }
	            } else {
	                var rtnValue = window.showModalDialog("/admin/ezPersonal/addQuickLink.do?mode=modify", listviewSelected[0].getAttribute("data1"), "dialogHeight:620px;dialogwidth:400px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(405, 625));
	                window.location.reload();
	            }
	        }
	
	        function btn_Del() {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var listviewSelected = listview.GetSelectedRows();
	            if (listviewSelected == "") {
	                alert(Strmessage);
	                return;
	            }
	
	            if (!confirm("<spring:message code = 'ezPersonal.t00003' />")) {
	            	return;
	            }
	
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "pQuickLinkID", listviewSelected[0].getAttribute("data1"));
	
	            xmlhttp = null;
	            xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/admin/ezPersonal/delQuickLink.do", false);
	            xmlhttp.send(xmlpara);
	
	            if (xmlhttp != null && xmlhttp.readyState == 4) {
	                if (xmlhttp.statusText == "OK") {
	                    alert("<spring:message code = 'ezPersonal.t00004' />");
	                    window.location.reload();
	                }
	            }
	        }
		</script>
	</head>
	<body class="mainbody">
		<c:choose>
			<c:when test="${host == 'jgw.cloud.kaoni.com'}">
				<xml id="listviewheader" style ="display:none">
					<LISTVIEWDATA>
						<HEADERS>
					    	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t304' /></NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					     	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1023' />Type</NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME>URL</NAME>
					        	<WIDTH>70</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1024' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1025' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1026' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					    </HEADERS>
					</LISTVIEWDATA>
				</xml>
			</c:when>
			<c:otherwise>
				<xml id="listviewheader" style ="display:none">
					<LISTVIEWDATA>
						<HEADERS>
					    	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t304' /></NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					    	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t304' />(<spring:message code = 'ezPersonal.s82' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
							<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t304' />(<spring:message code = 'ezPersonal.s84' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					      	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t304' />(<spring:message code = 'ezPersonal.s85' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					     	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1023' />Type</NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME>URL</NAME>
					        	<WIDTH>70</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1024' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1025' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1026' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					    </HEADERS>
					</LISTVIEWDATA>
				</xml>
			</c:otherwise>
		</c:choose>

		
		<h1>Quick Link</h1>
		<div id="mainmenu">
			<ul>
		    	<li><span onclick="btn_Select()"><spring:message code = 'ezPersonal.t105' /></span></li>
		        <li><span onclick="QuickList_onDblclick()"><spring:message code = 'ezPersonal.t169' /></span></li>
		        <li><span onclick="btn_Del()"><spring:message code = 'ezPersonal.t99' /></span></li>
			</ul>
		</div>
	    <table class="mainlist" style="width:100%;">
	        <div id=AccessList style ="BORDER:0;WIDTH:100%"></div>
	    </table>
	</body>
</html>