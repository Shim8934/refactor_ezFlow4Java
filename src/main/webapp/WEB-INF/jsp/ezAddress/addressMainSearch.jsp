<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>address_search</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <style>
	    	.emptyDiv {
	    		height: 140px;
	    		padding-top: 60px;
	    		color : #d0d0d0;
	    		font-size : 12px;
	    		font-weight: bold;
	    	}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezAddress.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/Address_List.js')}"></script>
	    <script type="text/javascript">
	
	        var pCurrentPage = "1";
	        var pOrderOption = "S_NAME:0";
	        var pFilter = "";
	        var pTotalCnt = "";
	        var pPageSize = "";
	        var pMaxPage = "";
	        var BlockSize = 10;
	        var pFolderName = "";
	        var pAddrType = "";
	        var m_strColorSelect = "#f1f8ff";
	        var m_strColorOver = "#f4f5f5";
	        var m_strColorDefault = "#ffffff";
	        var CardHeader1 = "<spring:message code='ezAddress.t263' />";
	        var CardHeader2 = "<spring:message code='ezAddress.t189' />";
	        var CardHeader3 = "<spring:message code='ezAddress.t264' />";
	        var idlist = "";
	        var orderby = "<c:out value='${orderBy}'/>";
	        var filter = "<c:out value='${filter}'/>";
	        var Badmin = "${bAdmin}";
	        var Cadmin = "${cAdmin}";
	        var strLang_1 = "<spring:message code='ezAddress.t315' />";
	        var strLang_2 = "<spring:message code='ezAddress.t316' />";
	        var searchFlag = true;
	        var pUse_Editor = "${useEditor}";
	        var pNoneActiveX = "${noneActiveX}";
	        var AddressType = "<spring:message code='ezAddress.t145' />";
	        var AddressType2 = "<spring:message code='ezAddress.t146' />";
	        var AddressType3 = "<spring:message code='ezAddress.t147' />";
	        document.onselectstart = function () { return false; };
	        window.onresize = Window_onresize;
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	
	            Window_onresize();
	            makePageSelPage();
	        }
	        function search_keypress() {
	            if (window.event.keyCode == "13")
	                search_start();
	        }
	        function Search_Clear() {
	            document.getElementById("search_text").value = "";
	        }
	        function search_start() {
	        	searchFlag = true;
	        	var searchText = document.getElementById("search_text").value.trim();
	        	
	            if (searchText == "") {
	                alert("<spring:message code='ezAddress.t310' />");
	                document.getElementById("search_text").focus();
	                return;
	            }
	            idlist = "";
	
	            if (document.getElementById("CheckUser").checked == true) {
	                idlist = "P";
	            }
	
	            if (document.getElementById("CheckDept").checked == true) {
	                if (idlist == "") {
	                    idlist = "D";
	                }
	                else {
	                    idlist += ",D";
	                }
	            }
	
	            if (document.getElementById("CheckCompany").checked == true) {
	                if (idlist == "") {
	                    idlist = "C";
	                }
	                else {
	                    idlist += ",C";
	                }
	            }
	
	            if (idlist == "") {
	                alert("<spring:message code='ezAddress.t311' />");
	                return;
	            }
	
	            var subtype = document.getElementById("search_case").value;
	            filter = subtype + "," + searchText;
	            pCurrentPage = "1";
	            Get_SearchAddressList();
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }
	
	        function write_letter() {
	            if (listContentArry.length == 0) {
	                alert("<spring:message code='ezAddress.t4' />");
	            }
	            else {
	                var email = "";
	                for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                    var AddressObj = document.getElementById(listContentArry[Cnt]);
	                    if (AddressObj.getAttribute("_stype") == "P") {
	                        var addrname = AddressObj.getAttribute("_Sname");
	                        var addremail = AddressObj.getAttribute("_Semail");
	                        if (isValidEmail(addremail)) {
	                            if (email == "")
	                                email = "\"" + addrname + "\" <" + addremail + ">";
	                            else
	                                email += ",\"" + addrname + "\" <" + addremail + ">";
	                        }
	                    }
	                    else {
	                        var subxmlHTTP = createXMLHttpRequest();
	                        var xmlDom = createXmlDom();
	
	                        var objNode;
	                        createNodeInsert(xmlDom, objNode, "DATA");
	                        createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", decodeURIComponent(AddressObj.getAttribute("_addressid")));
	                        createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", AddressObj.getAttribute("_foldertype"));
	                        subxmlHTTP.open("POST", "/ezAddress/addressGetGroupEmail.do", false);
	                        subxmlHTTP.send(xmlDom);
	                        xmlDom = subxmlHTTP.responseXML;
	                        var emailRows = SelectNodes(xmlDom, "DATA/ROW");
	                        
	                        if (emailRows.length > 0) {
	                        	var addrname = AddressObj.getAttribute("_Sname");
	                        	if (AddressObj.getAttribute("_foldertype") == "P")
	                                var addremail = AddressObj.getAttribute("_AddressID") + "|!|P";
	                            else
	                                var addremail = AddressObj.getAttribute("_AddressID") + "|!|D";
	                        	
	                        	if (email == "")
	                                email = "\"" + addrname + "\" <" + addremail + ">";
	                            else
	                                email += ",\"" + addrname + "\" <" + addremail + ">";
	                        }
	                    }
	                }
	                if (email == "") {
	                    alert("<spring:message code='ezAddress.t229' />");
	                    return;
	                }
	
	                var pheight = window.screen.availHeight;
	                var conHeight = pheight * 0.8;
	                var pwidth = window.screen.availWidth;
	                var pTop = (pheight - conHeight) / 2;
	                var pLeft = (pwidth - 890) / 2;
	
	                window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(email), "",
	                    "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            }
	        }
	        
	        function isValidEmail(email_address) {
	            var format = /^[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+)*@[0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*$/;
	            if (email_address.search(format) != -1) {
	                return true;
	            }
	            else {
	                return false;
	            }
	        }
	        var address_movecopy_dialogArguments = new Array();
	        var address_movecopyOpenWin = "";
	        function move_address() {
	            if (listContentArry.length == 0) {
	                alert("<spring:message code='ezAddress.t216' />");
	            }
	            else {
	                var xmlDom = createXmlDom();
	                var objNode;
	                var objRow;
	                var objRowNode;
	                objNode = createNodeInsert(xmlDom, objNode, "DATA");
	                for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                    var AddressObj = document.getElementById(listContentArry[Cnt]);
	                    objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ROW");
	                    createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "ID", decodeURIComponent(AddressObj.getAttribute("_addressid")));
	                    createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "TYPE", AddressObj.getAttribute("_SType"));
	                    createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "OLDFOLDERTYPE", AddressObj.getAttribute("_foldertype"));
	                    createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "FOLDERID", decodeURIComponent(AddressObj.getAttribute("_folderid")));
	                }
	                if (CrossYN()) {
	                    address_movecopy_dialogArguments[0] = "";
	                    address_movecopy_dialogArguments[1] = move_address_Complete;
	                    address_movecopy_dialogArguments[2] = "CLOSE";
	                    address_movecopy_dialogArguments[3] = xmlDom;
	                    address_movecopyOpenWin = window.open("/ezAddress/addressMoveCopy.do", "address_movecopy", GetOpenWindowfeature(500, 375));
	                    try { address_movecopyOpenWin.focus(); } catch (e) {console.log(e);}
	                }
	                else {
	                    var feature = "dialogHeight:375px; dialogWidth:500px; status:no; help:no; edge:sunken";
	                    feature = feature + GetShowModalPosition(500, 375);
	                    var moveUrl = window.showModalDialog("/ezAddress/addressMoveCopy.do", null, feature);
	                    if (typeof (moveUrl) == "undefined")
	                        return;
	
	                    if (moveUrl["cmd"] == "MOVE") {
	                        for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                            var AddressObj = document.getElementById(listContentArry[Cnt]);
	                            if (typeof (AddressObj.getAttribute("_addressid")) != "undefined") {
	                                if (AddressObj.getAttribute("_foldertype") != "P") {
	                                    if (AddressObj.getAttribute("_foldertype") == "D" && Badmin != "Y" || AddressObj.getAttribute("_foldertype") == "C" && Cadmin != "Y") {
	                                        if (AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
	                                            alert("<spring:message code='ezAddress.t217' />");
	                                            return;
	                                        }
	                                    }
	                                }
	                            }
	                        }
	                    }
	                    createNodeAndInsertText(xmlDom, objNode, "CMD", moveUrl["cmd"]);
	                    createNodeAndInsertText(xmlDom, objNode, "NEWFOLDERID", decodeURIComponent(moveUrl["folderid"]));
	                    createNodeAndInsertText(xmlDom, objNode, "NEWFOLDERTYPE", moveUrl["foldertype"]);
	                    createNodeAndInsertText(xmlDom, objNode, "OWNERID", moveUrl["ownerid"]);
	                    var xmlHTTP = createXMLHttpRequest();
	                    xmlHTTP.open("POST", "/ezAddress/addressSaveMoveCopy.do", false);
	                    xmlHTTP.send(xmlDom);
	
	                    if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                        alert("<spring:message code='ezAddress.t218' />");
	                    else {
	                        alert("<spring:message code='ezAddress.t219' />");
	                        if (moveUrl["cmd"] == "MOVE") {
	                            pTotalCnt = parseInt(pTotalCnt) - listContentArry.length;
	                            if (pCurrentPage != 1 && pTotalCnt == (pCurrentPage - 1) * pPageSize)
	                                pCurrentPage--;
	                            Get_SearchAddressList();
	                        }
	                    }
	                }
	            }
	        }
	        function move_address_Complete(moveUrl) {
	        	
	            try {
	                if (typeof (moveUrl) == "undefined")
	                    return;
	
	                if (moveUrl["cmd"] == "MOVE") {
	                    for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                        var AddressObj = document.getElementById(listContentArry[Cnt]);
	                        if (typeof (AddressObj.getAttribute("_addressid")) != "undefined") {
	                            if (AddressObj.getAttribute("_foldertype") != "P") {
	                                if (AddressObj.getAttribute("_foldertype") == "D" && Badmin != "Y" || AddressObj.getAttribute("_foldertype") == "C" && Cadmin != "Y") {
	                                    if (AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
	                                        alert("<spring:message code='ezAddress.t217' />");
	                                        return;
	                                    }
	                                }
	                            }
	                        }
	                    }
	                }
	                var objNode;
	                createNodeAndInsertText(address_movecopy_dialogArguments[3], objNode, "CMD", moveUrl["cmd"]);
	                createNodeAndInsertText(address_movecopy_dialogArguments[3], objNode, "NEWFOLDERID", decodeURIComponent(moveUrl["folderid"]));
	                createNodeAndInsertText(address_movecopy_dialogArguments[3], objNode, "NEWFOLDERTYPE", moveUrl["foldertype"]);
	                createNodeAndInsertText(address_movecopy_dialogArguments[3], objNode, "OWNERID", moveUrl["ownerid"]);
	                var xmlHTTP = createXMLHttpRequest();
	                xmlHTTP.open("POST", "/ezAddress/addressSaveMoveCopy.do", false);
	                xmlHTTP.send(address_movecopy_dialogArguments[3]);
	                
	            	// 2024.07.05 한슬기 : 팝업창이 완전히 닫혔는지 체크 후에 alert을 띄우도록 변경(safari에서 alert이 가려지는 문제가 있음)
	                var checkChildClosed = setInterval(function() {
						if (address_movecopyOpenWin.closed){
							
							clearInterval(checkChildClosed);
							
			                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
			                    alert("<spring:message code='ezAddress.t218' />");
			                else {
			                    alert("<spring:message code='ezAddress.t219' />");
			                    if (moveUrl["cmd"] == "MOVE") {
			                    	pTotalCnt = parseInt(pTotalCnt) - listContentArry.length;
			                        if (pCurrentPage != 1 && pTotalCnt == (pCurrentPage - 1) * pPageSize){
			                            pCurrentPage--;
			                        }
			                        Get_SearchAddressList();
			                    }
			                }
						}
						
					}, 100);
	                
	                /*if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                    alert("<spring:message code='ezAddress.t218' />");
	                else {
	                    alert("<spring:message code='ezAddress.t219' />");
	                    if (moveUrl["cmd"] == "MOVE") {
	                        pTotalCnt = parseInt(pTotalCnt) - listContentArry.length;
	                        if (pCurrentPage != 1 && pTotalCnt == (pCurrentPage - 1) * pPageSize)
	                            pCurrentPage--;
	                        Get_SearchAddressList();
	                        //Get_SearchAddressList();
	                    }
	                }*/
	            } catch (e) {console.log(e);}
	        }
	        function delete_address() {
	        	
	        	if (pTotalCnt == 0) {
	        		alert("<spring:message code='ezAddress.t212' />");
	        		return;
	        	}
	        	
	            if (listContentArry.length == 0) {
	                alert("<spring:message code='ezAddress.t212' />");
	            }
	            else {
	            	if (confirm(listContentArry.length + "<spring:message code='ezAddress.t213' />")) {
		                for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
		                    var AddressObj = document.getElementById(listContentArry[Cnt]);
		                    if (typeof (AddressObj.getAttribute("_addressid")) != "undefined") {
		                        if (AddressObj.getAttribute("_foldertype") != "P") {
		                            if (AddressObj.getAttribute("_foldertype") == "D" && Badmin != "Y" || AddressObj.getAttribute("_foldertype") == "C" && Cadmin != "Y") {
		                                if (AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
		                                    alert("<spring:message code='ezAddress.t211' />");
		                                    return;
		                                }
		                            }
		                        }
		                    }
		                }
		                var xmlDom = createXmlDom();
		                var objNode;
		                var objRow;
		                var objRowNode;
		                objNode = createNodeInsert(xmlDom, objNode, "DATA");
		                for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
		                    var AddressObj = document.getElementById(listContentArry[Cnt]);
		                    objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ROW");
		                    createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "ID", decodeURIComponent(AddressObj.getAttribute("_addressid")));
		                    createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "OLDFOLDERTYPE", AddressObj.getAttribute("_foldertype"));
		                }
		                var xmlHTTP = createXMLHttpRequest();
		                xmlHTTP.open("POST", "/ezAddress/addressDelete.do", false);
		                xmlHTTP.send(xmlDom);
		                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
		                    alert("<spring:message code='ezAddress.t214' />");
		                else {
		                    alert( "<spring:message code='ezAddress.t215' />");
		                    pTotalCnt = parseInt(pTotalCnt) - listContentArry.length;
		                    if (pCurrentPage != 1 && pTotalCnt == (pCurrentPage - 1) * pPageSize)
		                        pCurrentPage--;
		                    Get_SearchAddressList();
		                }
	            	}
	            }
	        }
	        /*
	        function check_click(obj) {
	            if (document.getElementById(obj).checked != true)
	                document.getElementById(obj).checked = true;
	            else
	                document.getElementById(obj).checked = false;
	        }*/
	    </script>
	</head>
	<body class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);" style="overflow:hidden">
	    <h1><spring:message code='ezAddress.t312' /></h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onclick="move_address()"><spring:message code='ezAddress.t176' /></span></li>
	            <li onclick="delete_address()"><span class="icon16 icon16_delete"></span></li>
	            <li onclick="window.location.reload(false)"><span class="icon16 icon16_refresh"></span></li>
	            <li><span class="icon16 icon16_mail_gray" onclick="write_letter()"></span></li>
	            <li style="background:none;float:right">
	                <select id="ListViewType" onchange="View_Change();">
	                    <option value="card" <c:if test="${pListType == 'card'}"> selected</c:if>><spring:message code='ezAddress.t2000' /></option>
	                    <option value="list" <c:if test="${pListType == 'list'}"> selected</c:if>><spring:message code='ezAddress.t2001' /></option>
	                </select>
	            </li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezAddress.t314' /></th>
	            <td>
                    <div class="custom_checkbox">
                        <input type="checkbox" name="chkType" id="CheckUser" checked />
                        <label for="CheckUser">
                            <spring:message code='ezAddress.t145' />&nbsp;&nbsp;
                        </label>
                    </div>
                    <div class="custom_checkbox">
                        <input type="checkbox" name="chkType" id="CheckDept" checked />
                        <label for="CheckDept">
                            <spring:message code='ezAddress.t146' />&nbsp;&nbsp;
                        </label>
                    </div>
                    <div class="custom_checkbox">
                        <input type="checkbox" name="chkType" id="CheckCompany" checked />
                        <label for="CheckCompany">
                            <spring:message code='ezAddress.t147' />&nbsp;&nbsp;
                        </label>
                    </div>
	                <select name="search_case" id="search_case" style="height:22px; vertical-align:middle;">
	                    <option value="S_NAME"><spring:message code='ezAddress.t124' /></option>
	                    <option value="S_COMPANY"><spring:message code='ezAddress.t51' /></option>
	                    <option value="S_DEPT"><spring:message code='ezAddress.t54' /></option>
	                    <option value="S_TITLE"><spring:message code='main.t77' /></option>
	                    <option value="S_COMPANY_ADDR"><spring:message code='ezAddress.t295' /></option>
	                    <option value="S_HOME_ADDR"><spring:message code='ezAddress.t296' /></option>
	                    <option value="S_MEMO"><spring:message code='ezAddress.t91' /></option>
	                    <option value="S_EMAIL"><spring:message code='ezAddress.t264' /></option>
	                    <option value="S_COMPANY_PHONE"><spring:message code='ezAddress.t263' /></option>
	                    <option value="S_MOBILE"><spring:message code='ezAddress.t189' /></option>
	                    <option value="S_FAX"><spring:message code='ezAddress.t292' /></option>
	                    <option value="S_HOMEPAGE"><spring:message code='ezAddress.t293' /></option>
	                </select>
	                <input type="text" name="search_text" id="search_text" class="textarea" onkeypress="return search_keypress()" onmousedown="Search_Clear();" style="height:22px;">
	                <a class="imgbtn imgbck" style="vertical-align: middle;margin-top:2px"><span onclick="search_start()"><spring:message code='ezAddress.t142' /></span></a></td>
	        </tr>
	    </table>
	    <br>	    
	    <table style="width: 100%;">
	        <tr>
	            <td>
	                <h2 id="mailBoxInfo"></h2>
	            </td>
	            <td></td>
	        </tr>
	    </table>
	    <div style="vertical-align: top; border: 0px solid red;" id="list_Layer">
	        <table class="mainlist" id="DetailList_header" style="width:100%; table-layout: fixed; display:none;">
	            <tr>
	                <th style="cursor: pointer;text-align:center; margin:0px; width: 20px;">
	                    <div class='custom_checkbox'>
	                	    <input type="checkbox" id="HeaderAllCheckBox" onclick="event_HeaderCheckBoxClick(this)">
                        </div>
	                </th>
	                <th style="padding-left:0px; padding-right:0px; text-align:center;width:40px;"><img src="/images/i_individual.gif" border="0"></th>
	                <th id="CompanyName"  style="padding:0px; CURSOR: pointer; width: 20%; white-space: nowrap;" onmouseover="this.style.color='#006BB6'" onmouseout="this.style.color='#393939'" _OrderOption="1" _OrderName="S_NAME" onclick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t124' /><span id="S_NAME"><img border="0" src="/images/view-sortup.gif"></span></th>
	                <th id="PhoneNumber" style="CURSOR: pointer; width: 20%; white-space: nowrap; padding:0px;" onmouseover="this.style.color='#006BB6'" onmouseout="this.style.color='#393939'" _OrderOption="0" _OrderName="S_COMPANY" onclick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t51' /><span id="S_COMPANY"></span></th>
	                <th id="width1" style="CURSOR: pointer; width: 20%; white-space: nowrap; padding:0px;" onmouseover="this.style.color='#006BB6'" onmouseout="this.style.color='#393939'" _OrderOption="0" _OrderName="S_COMPANY_PHONE" onclick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t263' /><span id="S_COMPANY_PHONE"></span></th>
	                <th id="width2" style="CURSOR: pointer; width: 20%; white-space: nowrap; padding:0px;" onmouseover="this.style.color='#006BB6'" onmouseout="this.style.color='#393939'" _OrderOption="0" _OrderName="S_MOBILE" onclick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t189' /><span id="S_MOBILE"></span></th>
	                <th style="CURSOR: pointer; width: 20%; white-space: nowrap; padding:0px;" onmouseover="this.style.color='#006BB6'" onmouseout="this.style.color='#393939'" _OrderOption="0" _OrderName="S_EMAIL" onclick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t264' /><span id="S_EMAIL"></span></th>
	                <th id="FolderType" style="CURSOR:pointer;width:10%;white-space:nowrap;padding:0px;" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" _OrderOption="0" _OrderName="S_TYPE" onClick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t231' /><span id="S_TYPE"></span></th>
	            </tr>
	        </table>
	        <div id="contentlist" name="contentlist" style="border: 0px solid blue; height: 650px; width: 100%; overflow-y: auto;">
	            <table class="mainlist" style="width: 100%; table-layout: fixed;" id="MailList">
	            </table>
	            <div style="width: 100%; height: 100%; display: none;" id="MailListCard">
	            </div>
	        </div>
	        <div id="tblPageRayer" style="width: 450px; margin: 6px auto;"></div>
	    </div>
	    <div style="width:100%;height:100%;position:absolute;top:0px;left:0px;display:none;z-index:5000;" id="mailPanel" onclick="ShowQuickAddres();" >&nbsp;</div>
	        <div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
	            <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
	    </div>
	</body>
</html>
