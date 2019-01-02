<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>shared_mailbox_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
		<style>
			.mainlist tr td {
				padding:0px;
			}
			.mainlist_free tr th {
				border-top:0px;
			}
			.mainlist_free tr td:first-child {
				padding-left:10px;
			}
			.mainlist_free tr th:first-child {
				padding-left:10px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript">
			var companyId = "${userCompany}";
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };
		    
		    window.onload = function () {
		        if (document.all("ListCompany") != null && document.all("ListCompany").length == 0) {
		            alert("<spring:message code='ezEmail.t49' />");
		        } else {
		        	companyChange();
		        }
		    }
		    
		    function companyChange() {
		    	companyId = document.all("ListCompany") == null ? companyId : document.all("ListCompany").value;
		        
		    	$.ajax({
	    			url: "/admin/ezEmail/getSharedMailboxList.do",
	    			type: "POST",
	    			async: false,
	    			dataType: 'text',
	    			data: {'compId' : companyId},
	    			success: function(result) {
	    				if (result === "NO_PERMISSION") {
	    					alert("<spring:message code='ezOrgan.t302' />");
	    				} else if (result === "ERROR") {
	    					alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    				} else {
	    					document.getElementById("sharedMailboxUser").innerHTML = "";
	    					var resultXml = loadXMLString(result);
	    					var headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
	    		            var xmlRtn = resultXml.documentElement.getElementsByTagName("ROWS")[0];
	    					
	    		            if (CrossYN()) {
	    		                var Node = headerData.importNode(xmlRtn, true);
	    		                headerData.documentElement.appendChild(Node);
	    		            } else {
	    		                headerData.documentElement.appendChild(xmlRtn);
	    		            }
	    					
	    		            document.getElementById("sharedMailboxList").innerHTML = "";
	    		            var pUserList = new ListView();
	    		            pUserList.SetID("sharedMailbox");
	    		            pUserList.SetRowOnDblClick("modSharedMailbox");
	    		            pUserList.SetRowOnClick("viewSharedMailboxInfo");
	    		            pUserList.SetSelectFlag(false);
	    		            pUserList.SetHeightFree(true);
	    		            pUserList.DataSource(headerData);
	    		            pUserList.DataBind("sharedMailboxList");
	    				}
	    			},
	    			error: function(err) {
	    				alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    			}
	    		})
		    }
		
		    var xmlHTTP = createXMLHttpRequest();
		    
		    function viewSharedMailboxInfo() {
		        var listview = new ListView();
		        listview.LoadFromID("sharedMailbox");
		        var shareId = GetAttribute(listview.GetSelectedRows()[0], "DATA1");
		        
		        $.ajax({
	    			url: "/admin/ezEmail/getSharedMailboxInfo.do",
	    			type: "POST",
	    			async: false,
	    			dataType: 'json',
	    			data: {'shareId' : shareId},
	    			success: function(result) {
	    				if (result.resultCode === "OK") {
	    					document.getElementById("sharedMailboxUser").innerHTML = "";
	    					
	    			        var sharedMailboxInfoDiv = document.createElement("DIV");
	    			        sharedMailboxInfoDiv.setAttribute("style", "height:50px;");
	    			        
	    			        var span = document.createElement("SPAN");
	    			        span.setAttribute("style", "color: #000; font-weight: bold;");
	    			        
	    			        if (CrossYN()) {
	    			        	span.textContent = "▒ <spring:message code='ezEmail.sharedMailbox08' />";
	    			        } else {
	    			        	span.innerText = "▒ <spring:message code='ezEmail.sharedMailbox08' />";
	    			        }
	    			        
	    			        sharedMailboxInfoDiv.appendChild(span);
	    			        
	    			        var br = document.createElement("BR");
	    			        sharedMailboxInfoDiv.appendChild(br);
	    			        
	    			        var mailDiv = document.createElement("DIV");
	    			        mailDiv.setAttribute("style", "margin-top:5px; margin-left:5px;");
	    			        
	    			        if (CrossYN()) {
	    			        	mailDiv.textContent = "<spring:message code='ezOrgan.t91' /> : " + result.sharedMailboxInfo.shareMail;
	    			        } else {
	    			        	mailDiv.innerText = "<spring:message code='ezOrgan.t91' /> : " + result.sharedMailboxInfo.shareMail;
	    			        }
	    			        
	    			        sharedMailboxInfoDiv.appendChild(mailDiv);
	    			        
	    			        var sharedMailboxUserDiv = document.createElement("DIV");
	    			        sharedMailboxUserDiv.setAttribute("style", "margin-top:10px;");
	    			        
	    			        span = document.createElement("SPAN");
	    			        span.setAttribute("style", "color: #000; font-weight: bold;");
	    			        
	    			        if (CrossYN()) {
	    			        	span.textContent = "▒ <spring:message code='ezEmail.sharedMailbox06' />";
	    			        } else {
	    			        	span.innerText = "▒ <spring:message code='ezEmail.sharedMailbox06' />";
	    			        }
	    			        
	    			        sharedMailboxUserDiv.appendChild(span);
	    			        
	    			        result.sharedMailboxInfo.userList.forEach(function(vo, index) {
	    			        	var userDiv = document.createElement("DIV");
	    			            userDiv.setAttribute("style", "margin-top:5px; margin-left:5px; cursor:pointer;");
	    			            userDiv.setAttribute("onClick", "showMember(this)");
	    			            userDiv.setAttribute("id", vo.userId);
	    			            userDiv.innerHTML = vo.userName + " (" + vo.deptName + ")";
	    			            sharedMailboxUserDiv.appendChild(userDiv);
				    		});
	    			        
	    			        document.getElementById("sharedMailboxUser").appendChild(sharedMailboxInfoDiv);
	    			        document.getElementById("sharedMailboxUser").appendChild(sharedMailboxUserDiv);
	    				} else if (result.resultCode === "NO_PERMISSION") {
	    					alert("<spring:message code='ezOrgan.t302' />");
	    				} else {
	    					alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    				}
	    			},
	    			error: function(err) {
	    				alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    			}
	    		})
		    }
		
		    function showMember(obj) {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 450) / 2;
		        var pLeft = (pwidth - 420) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + obj.id + "&dept=", "", "height=450px,width=420px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }

		    function delSharedMailbox() {
		        var listview = new ListView();
		        listview.LoadFromID("sharedMailbox");
		
		        var xmlDom = createXmlDom();
		        var xmlHTTP = createXMLHttpRequest();
		
		        var objNode = "";
		        createNodeInsert(xmlDom, objNode, "DATA");
		
		        var selectedCount = listview.GetSelectedRows().length;
		        
		        if (selectedCount > 0) {
		        	var shareName = listview.GetSelectedRows()[0].innerText;
		        	var shareId = listview.GetSelectedRows()[0].getAttribute("DATA1");
		        	
			        if (confirm("[" + shareName + "] <spring:message code='ezEmail.sharedMailbox22' />")) {
			        	if (confirm("<spring:message code='ezEmail.sharedMailbox23' />")) {
			        		$.ajax({
				    			url: "/admin/ezEmail/delSharedMailbox.do",
				    			type: "POST",
				    			async: false,
				    			dataType: 'json',
				    			data: {'shareId' : shareId},
				    			success: function(result) {
				    				if (result.resultCode === "OK") {
				    					alert("<spring:message code='ezEmail.sharedMailbox24' />");
				    				} else if (result.resultCode === "NO_PERMISSION") {
				    					alert("<spring:message code='ezOrgan.t302' />");
				    				} else {
				    					alert("<spring:message code='ezEmail.sharedMailbox07' />");
				    				}
				    				
				    				companyChange();
				    			},
				    			error: function(err) {
				    				alert("<spring:message code='ezEmail.sharedMailbox07' />");
				    				companyChange();
				    			}
				        	})
			        	}
			        }
		        } else {
		        	alert("<spring:message code='ezEmail.sharedMailbox20' />");
		        }
		    }
		    
		    var sharedMailboxDialogArguments = new Array();
		    
		    function addSharedMailbox() {
		        var feature = "dialogHeight:670px; dialogWidth:990px; scroll:no;status:no; help:no; edge:sunken";
		        feature = feature + GetShowModalPosition(990, 670);
		        
		        if (CrossYN()) {
		            sharedMailboxDialogArguments[0] = addSharedMailboxComplete;
		            var OpenWin = window.open("/admin/ezEmail/showAddSharedMailbox.do?compId=" + companyId, "", GetOpenWindowfeature(990, 670));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            var rtnValue = window.showModalDialog("/admin/ezEmail/showAddSharedMailbox.do?compId=" + companyId, feature);
		            if (typeof (rtnValue) != "undefined") {
		                companyChange();
		            }
		        }
		    }
		    
		    function addSharedMailboxComplete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		            companyChange();
		        }
		    }
		    
		    function modSharedMailbox() {
		        var pUserList = new ListView();
		        pUserList.LoadFromID("sharedMailbox");
		
		        var selnode = pUserList.GetSelectedRows();
		        
		        if (selnode == "") {
		            alert("<spring:message code='ezEmail.sharedMailbox20' />");
		            return;
		        }
		        
		        var shareId = selnode[0].getAttribute("DATA1");
		        var feature = "dialogHeight:670px; dialogWidth:990px; scroll:no;status:no; help:no; edge:sunken";
		        feature = feature + GetShowModalPosition(990, 670);
		        
		        if (CrossYN()) {
		        	sharedMailboxDialogArguments[0] = addSharedMailboxComplete;
		            var OpenWin = window.open("/admin/ezEmail/showAddSharedMailbox.do?shareId=" + shareId + "&compId=" + companyId, "", GetOpenWindowfeature(990, 670));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            var rtnValue = window.showModalDialog("/admin/ezEmail/showAddSharedMailbox.do?shareId=" + shareId + "&compId=" + companyId, feature);
		            
		            if (typeof (rtnValue) != "undefined") {
		                companyChange();
		            }
		        }
		    }
		    
			var inputpassword_dialogArguments = new Array();
		    
			function mod_password() {
				var pUserList = new ListView();
		        pUserList.LoadFromID("sharedMailbox");
		        var selnode = pUserList.GetSelectedRows();
		        
		        if (selnode == "") {
		            alert("<spring:message code='ezEmail.sharedMailbox20' />");
		            return;
		        }
		        
		        inputpassword_dialogArguments[0] = strLangSharedMailbox02;
		        inputpassword_dialogArguments[1] = mod_password_Complete;
		        var OpenWin = window.open("/admin/ezOrgan/inputPassword.do", "InputPassword", GetOpenWindowfeature(467, 185));	
		        try { OpenWin.focus(); } catch (e) { }
			}
			
		    function mod_password_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		        	var pUserList = new ListView();
			        pUserList.LoadFromID("sharedMailbox");
			        var selnode = pUserList.GetSelectedRows();
			        var shareId = selnode[0].getAttribute("DATA1");
			        
		            $.ajax({
		            	type : "POST",
		            	dataType : "xml",
		            	url : "/admin/ezOrgan/changePassword.do",
		            	async : false,
		            	data : {password : rtnValue, cn : shareId},
		            	success : function(result) {
		            		alert(strLangSharedMailbox03);
		            	},
		            	error : function() {
		            		alert("<spring:message code='ezOrgan.t41' />");
		            	}
		            });
	            }
		    }
		</script>
	</head>
	<body class="mainbody">
		<xml id="listviewheader" style="display:none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.sharedMailbox02' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		
		<h1><spring:message code='ezEmail.sharedMailbox01' /></h1>
		
		<div id="mainmenu">
			<span style="display:none;"><b><spring:message code='ezEmail.t59' /></b></span>
			<select name="ListCompany" id="ListCompany" onchange="companyChange()" style="margin-bottom:10px; display:none;">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
	      	</select>
			<ul>
				<li><span onClick="addSharedMailbox()"><spring:message code='ezEmail.sharedMailbox03' /></span></li>
		    	<li><span onClick="modSharedMailbox()"><spring:message code='ezEmail.sharedMailbox04' /></span></li>
		      	<li><span onClick="delSharedMailbox()"><spring:message code='ezEmail.sharedMailbox05' /></span></li>
		      	<li><span onClick="mod_password()"><spring:message code='ezOrgan.t231' /></span></li>
		    </ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table class="mainlist">
			<tr>
				<td style="vertical-align:top; border-bottom:0;">
					<div style="width:300px; height:400px; overflow-y:auto; border-color:#dbdbda; border-width:1px; border-style:solid;">
						<div id="sharedMailboxList"></div>      
					</div>
				</td>
				<td style="vertical-align:top; border-bottom:0;">
					<div style="margin-left:5px; width:500px; height:380px;">
						<div id="sharedMailboxUser" style="width:100%; height:100%; padding:10px; overflow-y:auto; border-color:#dbdbda; border-width:1px; border-style:solid;"></div>
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>



