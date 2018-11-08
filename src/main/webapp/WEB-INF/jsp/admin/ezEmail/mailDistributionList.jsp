<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_distributionlist</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
		<style>
			.mainlist tr td {
				padding:0px;
			}
			.mainlist_free tr th {
				border-top:0px;
			}
			.mainlist_free tr td:first-child{
				padding-left:10px;
			}
			.mainlist_free tr th:first-child{
				padding-left:10px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript">
			var companyId = "${userCompany}";
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    window.onload = function () {
		        if (document.all("ListCompany") != null && document.all("ListCompany").length == 0)
		            alert("<spring:message code='ezEmail.t49' />");
		        else {
		            company_change();
		        }
		    }
		    function company_change() {
		    	companyId = document.all("ListCompany") == null ? companyId : document.all("ListCompany").value;
		        document.getElementById("DIV_Member").innerHTML = "";
		
		        var xmlDom = createXmlDom();
		        var xmlHTTP = createXMLHttpRequest();
		
		        var objRoot;
		        createNodeInsert(xmlDom, objRoot, "DATA");
		        createNodeAndInsertText(xmlDom, objRoot, "CN", null);
		        createNodeAndInsertText(xmlDom, objRoot, "COMPID", companyId);
		
		        xmlHTTP.open("POST", "/admin/ezEmail/mailGetDistribution.do", false);
		        xmlHTTP.send(xmlDom);
		        var stateVlaue = "";
		        if (CrossYN())
		            stateVlaue = xmlHTTP.responseXML.documentElement.textContent.substr(0, 5)
		        else
		            stateVlaue = xmlHTTP.responseXML.documentElement.text.substr(0, 5)
		        if (xmlHTTP.status != 200 || stateVlaue == "ERROR")
		            alert("<spring:message code='ezEmail.t50' />");
		        else {
		            var headerData = createXmlDom();
		            headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		
		            if (CrossYN()) {
		                var xmlRtn = xmlHTTP.responseXML.documentElement.getElementsByTagName("ROWS")[0];
		                var Node = headerData.importNode(xmlRtn, true);
		                headerData.documentElement.appendChild(Node);
		            }
		            else {
		                var xmlRtn = xmlHTTP.responseXML.documentElement.getElementsByTagName("ROWS")[0];
		                headerData.documentElement.appendChild(xmlRtn);
		            }
		            document.getElementById("OrganListView").innerHTML = "";
		            var pUserList = new ListView();
		            pUserList.SetID("lvUserList");
		            pUserList.SetRowOnDblClick("mod_dl");
		            pUserList.SetRowOnClick("View_dl");
		            pUserList.SetSelectFlag(false);
		            pUserList.SetHeightFree(true);
		            pUserList.DataSource(headerData);
		            pUserList.DataBind("OrganListView");
		        }
		    }
		
		    var xmlHTTP = createXMLHttpRequest();
		    function View_dl()
		    {
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");
		
		        var xmlDom = createXmlDom();
		        var objNode = "";
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "CN", GetAttribute(listview.GetSelectedRows()[0], "DATA1"));
		        createNodeAndInsertText(xmlDom, objNode, "COMPID", document.all("ListCompany").value);
		        xmlHTTP.open("POST", "/admin/ezEmail/mailViewDistributionList.do", true);
		        xmlHTTP.onreadystatechange = getDistributionMember_after;
		        xmlHTTP.send(xmlDom);
		    }
		
		    function getDistributionMember_after()
		    {
		        document.getElementById("DIV_Member").innerHTML = "";
		
		        if (xmlHTTP == null || xmlHTTP.readyState != 4) return;
		
		        var DIV_GroupMember = document.createElement("DIV");
		        var Span = document.createElement("SPAN");
		        var BR = document.createElement("BR");
		        /* var IMG = document.createElement("IMG");
		        IMG.src = '/images/ImgIcon/dot.gif';
		        IMG.align = "absmiddle";
		        IMG.hspace = 5; */
		        Span.setAttribute("style", "color: #000; font-weight: bold;");
		        if(CrossYN())
		            Span.textContent = "▒ <spring:message code='ezEmail.t659' />";
		        else
		            Span.innerText = "▒ <spring:message code='ezEmail.t659' />";
		        /* DIV_GroupMember.appendChild(IMG); */
		        DIV_GroupMember.appendChild(Span);
		        var P = document.createElement("P");
		        DIV_GroupMember.appendChild(P);
		        for (var i = 0; i < SelectNodes(xmlHTTP.responseXML, "DATA/ROW").length; i++) {
		
		            var DIV = document.createElement("DIV");
		            DIV.style.marginLeft = "5px";
		            DIV.style.marginTop = "5px";
		            DIV.style.cursor = "hand";
		            DIV.style.color = "black";
		            DIV.style.display = "inline-block";
		
		            if (CrossYN()) {
		                if ("${useOcs}" == "YES")
		                    DIV.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + SelectNodes(xmlHTTP.responseXML, "MAIL").item(i).textContent + "\",this);'/></span><span style='margin-top:50px; cursor:pointer' id=" + SelectNodes(xmlHTTP.responseXML, "CN").item(i).textContent + " onclick='show_member(this)'>" + SelectNodes(xmlHTTP.responseXML, "DISPLAYNAME").item(i).textContent + " (" + SelectNodes(xmlHTTP.responseXML, "DEPT").item(i).textContent + ")</span>";
		                else
		                    DIV.innerHTML = SelectNodes(xmlHTTP.responseXML, "DISPLAYNAME").item(i).textContent + " (" + SelectNodes(xmlHTTP.responseXML, "DEPT").item(i).textContent + ")";
		            }
		            else {
		                if ("${useOcs}" == "YES")
		                    DIV.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + SelectNodes(xmlHTTP.responseXML, "MAIL").item(i).text + "\",this);'/></span><span style='margin-top:50px; ; cursor:pointer' id=" + SelectNodes(xmlHTTP.responseXML, "CN").item(i).text + " onclick='show_member(this)'>" + SelectNodes(xmlHTTP.responseXML, "DISPLAYNAME").item(i).text + " (" + SelectNodes(xmlHTTP.responseXML, "DEPT").item(i).text + ")</span>";
		                else
		                    DIV.innerHTML = SelectNodes(xmlHTTP.responseXML, "DISPLAYNAME").item(i).text + " (" + SelectNodes(xmlHTTP.responseXML, "DEPT").item(i).text + ")";
		            }
		            DIV_GroupMember.appendChild(DIV);
		            var BR = document.createElement("BR");
		            DIV_GroupMember.appendChild(BR);
		        }
		        document.getElementById("DIV_Member").appendChild(DIV_GroupMember);
		    }
		
		    function show_member(obj) {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 450) / 2;
		        var pLeft = (pwidth - 420) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + obj.id + "&dept=", "", "height=450px,width=420px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }
		
		    function del_dl() {
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");
		
		        var xmlDom = createXmlDom();
		        var xmlHTTP = createXMLHttpRequest();
		
		        var objNode = "";
		        createNodeInsert(xmlDom, objNode, "DATA");
		
		        var selectedCount = listview.GetSelectedRows().length;
		        var ret = confirm("<spring:message code='ezEmail.0hun04' />");
		        
		        if (ret) {
			        if (selectedCount > 0) {
				        createNodeAndInsertText(xmlDom, objNode, "CN", listview.GetSelectedRows()[0].getAttribute("DATA1"));
				        createNodeAndInsertText(xmlDom, objNode, "COMPID", companyId);
				        
				        xmlHTTP.open("POST", "/admin/ezEmail/mailDelDistributionList.do", false);
				        xmlHTTP.send(xmlDom);
				        
				        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
				            alert("<spring:message code='ezEmail.t53' />");
				            company_change();
				            return;
				        }
				        
				        alert(selectedCount + "<spring:message code='ezEmail.t54' />");
				        company_change();
			        } else {
			            alert("<spring:message code='ezEmail.t51' />");		            
			        }
		        }
		    }
		    
		    var mail_add_distributionlist_cross_dialogArguments = new Array();
		    function add_dl() {
		        var feature = "dialogHeight:670px; dialogWidth:970px; scroll:no;status:no; help:no; edge:sunken";
		        feature = feature + GetShowModalPosition(970, 670);
		        if (CrossYN()) {
		            mail_add_distributionlist_cross_dialogArguments[0] = companyId;
		            mail_add_distributionlist_cross_dialogArguments[1] = add_dl_Complete;
		            var OpenWin = window.open("/admin/ezEmail/mailAddDistributionList.do?companyId=" + companyId, "", GetOpenWindowfeature(970, 670));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var rtnValue = window.showModalDialog("/admin/ezEmail/mailAddDistributionList.do", companyId,
		                    feature);
		            if (typeof (rtnValue) != "undefined")
		                company_change();
		        }
		    }
		    function add_dl_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined")
		            company_change();
		    }
		    function mod_dl() {
		
		        var pUserList = new ListView();
		        pUserList.LoadFromID("lvUserList");
		
		        var selnode = pUserList.GetSelectedRows();
		        if (selnode == "") {
		            alert("<spring:message code='ezEmail.t55' />");
		            return;
		        }
		        var DeptID = selnode[0].getAttribute("DATA1");
		
		        var feature = "dialogHeight:670px; dialogWidth:970px; scroll:no;status:no; help:no; edge:sunken";
		        feature = feature + GetShowModalPosition(970, 670);
		        if (CrossYN()) {
		            mail_add_distributionlist_cross_dialogArguments = new Array();
		            mail_add_distributionlist_cross_dialogArguments[0] = companyId;
		            mail_add_distributionlist_cross_dialogArguments[1] = add_dl_Complete;
		            var OpenWin = window.open("/admin/ezEmail/mailAddDistributionList.do?cn=" + DeptID + "&name=" + encodeURIComponent(selnode[0].innerText) + "&companyId=" + companyId, "", GetOpenWindowfeature(970, 670));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var rtnValue = window.showModalDialog("/admin/ezEmail/mailAddDistributionList.do?cn=" + DeptID +
		                    "&name=" + encodeURIComponent(selnode[0].innerText), companyId,
		                    feature);
		            if (typeof (rtnValue) != "undefined")
		                company_change();
		        }
		    }
		</script>
	</head>
	<body class="mainbody">
	<xml id="listviewheader" style="display:none">
	  <LISTVIEWDATA>
	    <HEADERS>
	      <HEADER>
	        <NAME><spring:message code='ezEmail.t57' /></NAME>
	        <WIDTH>70</WIDTH>
	      </HEADER>
	    </HEADERS>
	  </LISTVIEWDATA>
	</xml>
	<form id="Form1" method="post">
		<h1><spring:message code='ezEmail.t58' /></h1>
		<div id="mainmenu">
			<span style="display:none;"><b> <spring:message code='ezEmail.t59' /></b></span>
			<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px; display:none;">
				<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>	      		
	      	</select>
			<ul>
				<li class="important"><span onClick="add_dl()"><spring:message code='ezEmail.t60' /></span></li>
		    	<li><span onClick="mod_dl()"><spring:message code='ezEmail.t61' /></span></li>
		      	<li><span class="icon16 icon16_delete" onClick="del_dl()"></span></li>
		    </ul>
	  </div>
	  <script type="text/javascript">
	      selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
	    <table class="mainlist">
	        <tr>
	            <td style="vertical-align:top; border-bottom:none">
	                <div style="width:300px">
	                    <div id="OrganListView" style ="BORDER:0;WIDTH:100%; height:400px; overflow-y: auto; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;"></div>      
	                </div>
	            </td>
	            <td style="vertical-align:top; border-bottom:none">
	                <div id="DIV_Member" style="padding-top:10px; padding-left:5px; width: 300px; height: 395px; margin-right: 5px; margin-bottom: 5px; margin-left: 5px; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; overflow-y: auto;"></div>      
	            </td>
	        </tr>
	    </table>
	</form>
	</body>
</html>



