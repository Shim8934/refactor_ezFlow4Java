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
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var companyId = "${userCompany}";
			var searchFlag = false;
			
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
		    	document.getElementsByClassName("shared_boxesTable")[0].style.display = "none";
		
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
		            
		            // 리스트 총 개수
		            var listCount = headerData.getElementsByTagName("ROWS")[0].childElementCount;
		            document.getElementById("listCount").innerHTML = listCount;
		            
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
		        if (xmlHTTP == null || xmlHTTP.readyState != 4) return;
				
		        var mailNode = SelectNodes(xmlHTTP.responseXML, "DATA/MAIL")[0];
		        var mail = getNodeText(mailNode);
		        
		        document.getElementById("distributionTitleTH").getElementsByTagName("th")[0].innerHTML = "▒ " + strLangLHM21;
		        document.getElementById("distributionTitleTB").getElementsByTagName("span")[0].innerHTML= "<spring:message code='ezOrgan.t91' /> : " + mail;
		        document.getElementById("distributionListTB").innerHTML = "";

		        for (var i = 0; i < SelectNodes(xmlHTTP.responseXML, "DATA/ROW").length; i++) {
		            var TR = document.createElement("TR");
		            var TD = document.createElement("TD");
		            var SPAN = document.createElement("SPAN");
		            SPAN.setAttribute("class","shared_boxesText");
		            
		            if (CrossYN()) {
		                if ("${useOcs}" == "YES")
		                	SPAN.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + SelectNodes(xmlHTTP.responseXML, "MAIL").item(i).textContent + "\",this);'/></span><span style='margin-top:50px; cursor:pointer' id=" + SelectNodes(xmlHTTP.responseXML, "CN").item(i).textContent + " onclick='show_member(this)'>" + SelectNodes(xmlHTTP.responseXML, "DISPLAYNAME").item(i).textContent + " (" + SelectNodes(xmlHTTP.responseXML, "DEPT").item(i).textContent + ")</span>";
		                else
		                	SPAN.innerHTML = SelectNodes(xmlHTTP.responseXML, "DISPLAYNAME").item(i).textContent 
		                    + " (" + SelectNodes(xmlHTTP.responseXML, "DEPT").item(i).textContent + ")";
		            }
		            else {
		                if ("${useOcs}" == "YES")
		                	SPAN.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + SelectNodes(xmlHTTP.responseXML, "MAIL").item(i).text + "\",this);'/></span><span style='margin-top:50px; ; cursor:pointer' id=" + SelectNodes(xmlHTTP.responseXML, "CN").item(i).text + " onclick='show_member(this)'>" + SelectNodes(xmlHTTP.responseXML, "DISPLAYNAME").item(i).text + " (" + SelectNodes(xmlHTTP.responseXML, "DEPT").item(i).text + ")</span>";
		                else
		                	SPAN.innerHTML = SelectNodes(xmlHTTP.responseXML, "DISPLAYNAME").item(i).text 
		                    + " (" + SelectNodes(xmlHTTP.responseXML, "DEPT").item(i).text + ")";
		            }
		            TD.appendChild(SPAN);
		            TR.appendChild(TD);
		            document.getElementById("distributionListTB").appendChild(TR);
		        }
		        
		        document.getElementsByClassName("shared_boxesTable")[0].style.display = "table";
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
				        //company_change();
				        selectList_Change();
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
		            mail_add_distributionlist_cross_dialogArguments[1] = mod_dl_Complete;
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
		    function mod_dl_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined")
		        	selectList_Change();
		    }
		    function search_click() {
				var searchType = document.getElementById("searchType").value;
		    	var searchValue = document.getElementById("searchValue").value;
		    	searchValue = searchValue.replaceAll(" ","") == "" ? "" : searchValue;
		    	searchFlag = true;

		    	if (searchValue == "") {
		    		alert("<spring:message code='ezEmail.t10' />");
		    		return;
		    	}
		    	
		        var xmlDom = createXmlDom();
		        var xmlHTTP = createXMLHttpRequest();
		        var objRoot;
		        createNodeInsert(xmlDom, objRoot, "DATA");
		        createNodeAndInsertText(xmlDom, objRoot, "CN", null);
		        createNodeAndInsertText(xmlDom, objRoot, "COMPID", companyId);
		        createNodeAndInsertText(xmlDom, objRoot, "SEARCHTYPE", searchType);
		        createNodeAndInsertText(xmlDom, objRoot, "SEARCHVALUE", searchValue);
			
		        xmlHTTP.open("POST", "/admin/ezEmail/mailGetDistributionSearchByItem.do", false);
		        xmlHTTP.send(xmlDom);
		        var stateVlaue = "";
		        
		        if (CrossYN())
		            stateVlaue = xmlHTTP.responseXML.documentElement.textContent.substr(0, 5)
		        else
		            stateVlaue = xmlHTTP.responseXML.documentElement.text.substr(0, 5)
		            
		        if (xmlHTTP.status != 200 || stateVlaue == "ERROR")
		            alert("<spring:message code='ezEmail.t50' />");
		        else {
		        	document.getElementsByClassName("shared_boxesTable")[0].style.display = "none";
		        	
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
		            
		            // 리스트 총 개수
		            var listCount = headerData.getElementsByTagName("ROWS")[0].childElementCount;
		            document.getElementById("listCount").innerHTML = listCount;
		            
		            var pUserList = new ListView();
		            pUserList.SetID("lvUserList");
		            pUserList.SetRowOnDblClick("mod_dl");
		            pUserList.SetRowOnClick("View_dl");
		            pUserList.SetSelectFlag(false);
		            pUserList.SetHeightFree(true);
		            pUserList.DataSource(headerData);
		            pUserList.DataBind("OrganListView");
		        }
		    } // search_onclick END
		    
		    function selectList_Change() {
		    	var selectTR_Data1 = $("#lvUserList tr[selected=true]")[0].getAttribute("data1");
		    	
		    	if (searchFlag == true && document.getElementById("searchValue").value != "") {
		    		search_click();
		    	} else {
		    		company_change();
		    	}

				var reListTR_ = $("#lvUserList tr[data1='" + selectTR_Data1 + "']")[0];
				reListTR_ = typeof reListTR_ != "undefined"  ? reListTR_.getAttribute("id") : "";
				
		    	if (selectTR_Data1 != "" && reListTR_ != "") {
		    		tr_select(reListTR_, "lvUserList", View_dl);
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
		<div style="width:825px;">
		<!-- 검색 -->
		<div style="border: 1px solid #e8e8e8; WIDTH:100%; border-bottom: 0px; height: 30px; box-sizing: border-box; line-height: 30px;">
			<div id="jobTotalInfoRayer" style="line-height: 30px; display: inline-block;">
				<span>&nbsp;[<spring:message code='main.t252'/> <span style="color:#017BEC; font-weight:bold;" id="listCount"></span> <spring:message code='ezSystem.kyj2'/>]</span>
			</div>
			<div id="userSearchRayer" style="float:right; display: inline-block;">
				<div style="display: inline-block; float:left;">
				<select id="searchType" style="height: 26px; width: 120px;">
					<option value="displayName"><spring:message code='ezEmail.t710' /></option> <!-- 그룹이름 -->
					<option value="groupID"><spring:message code='ezEmail.lhm09' /></option> <!-- 그룹아이디 -->
					<option value="memberName"><spring:message code='ezEmail.ksaDistribution01' /></option> <!-- 구성원이름 -->
					<option value="memberID"><spring:message code='ezEmail.ksaDistribution02' /></option> <!-- 구성원아이디 -->
				</select>
				</div>
				<div style="display: inline-block;box-sizing: border-box; padding-right: 2px;width: 519px;padding-left: 5px;">
					<input id="searchValue" onkeypress="if(event.keyCode==13) {search_click(); return false;}" autocomplete="off" style="height: 26px; border: 1px solid #cbcbcb; margin-top:2px; width:89%">
					<a class="imgbtn" style="vertical-align:middle"><span onclick="search_click()"><spring:message code="ezStatistics.t36" /></span></a>
				</div>
			</div>
		</div>
	    <table class="mainlist" style="width:100%;">
	    	<colgroup>
	    		<col width="37%"/>
	    		<col width=""/>
	    	</colgroup>
	        <tr>
	            <td style="vertical-align:top; border-bottom:none">
	                <div style="width:100%">
	                    <div id="OrganListView" style ="BORDER:0;WIDTH:100%; height:400px; overflow-y: auto; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;"></div>      
	                </div>
	            </td>
	            <td style="vertical-align:top; border-bottom:none">
	                <div id="DIV_Member" style="width: 515px; height: 400px; margin-right: 5px; margin-bottom: 5px; margin-left: 5px; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; overflow-y: auto;">
	                	<table class="shared_boxesTable public_distribution" style="display:none">
	                		<thead id="distributionTitleTH">
	                			<tr>
	                				<th></th>
	                			</tr>
	                		</thead>
				            <tbody id="distributionTitleTB">
				            	<tr>
				            		<td><span class="shared_boxesText" id="distriTitSpan"></span></td>
				            	</tr>
				            </tbody>
				            <thead id="distributionListTH">
				            	<tr>
					                <th>▒ <spring:message code='ezEmail.t659' /></th>
					            </tr>
				            </thead>
				            <tbody id="distributionListTB">
				            </tbody>
				        </table>
	                </div>      
	            </td>
	        </tr>
	    </table>
	    </div>
	</form>
	</body>
</html>



