<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
	    <title>address_list</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/Address_List.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezAddress.e1' />"></script>
	    <script type="text/javascript">
	        var pFolderID = "${pFolderId}";
	        var pFolderType = "${pFolderType}";
	        var pOwerID = "${pOwerId}";
	        var deptAdmin = "${deptAdmin}";
	        var compAdmin = "${compAdmin}";
	        var pCurrentPage = "1";
	        var pOrderOption = "S_NAME:0";
	        var pFilter = "";
	        var pFilterDB = "";
	        var pTotalCnt = "";
	        var pPageSize = "";
	        var pMaxPage = "";
	        var BlockSize = 10;
	        var pFolderName = "";
	        var m_strColorSelect = "#DBE1E7";
	        var m_strColorOver = "#f4f5f5";
	        var m_strColorDefault = "#ffffff";
	        var searchFlag = false;
	        var CardHeader1 = "<spring:message code='ezAddress.t263' />";
	        var CardHeader2 = "<spring:message code='ezAddress.t189' />";
	        var CardHeader3 = "<spring:message code='ezAddress.t264' />";
	        var uLang = "${userInfo.lang}";
	        var pUse_Editor = "${useEditor}";
	        var pUse_IE11Browser = "${useIE11Browser}";
	        var pNoneActiveX = "${noneActiveX}";
	        var strLang_1 = "";
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
	            if (uLang != "1") {
	            	document.getElementById("address_wordmenu_korea").style.display = "none";
	            }
	            if (uLang != "3") {
	            	document.getElementById("address_wordmenu_japan").style.display = "none";
	            }
	            
	            if (CrossYN() || (pNoneActiveX == "YES")) {
	                document.getElementById("importaddress").style.display = "none";
	                document.getElementById("exportaddress").style.display = "none";
	                document.getElementById("importaddress_Cross").style.display = "";
	                document.getElementById("exportaddress_Cross").style.display = "";
	            }
	            else {
	                document.getElementById("importaddress").style.display = "";
	                document.getElementById("exportaddress").style.display = "";
	                document.getElementById("importaddress_Cross").style.display = "none";
	                document.getElementById("exportaddress_Cross").style.display = "none";
	            }
	            Window_onresize();
	            Get_AddressList();
	
	        }
	        function new_address() {
	            if (deptAdmin != "Y" && pFolderType == "D") {
	                alert("<spring:message code='ezAddress.t999900003' />");
	                return;
	            }
	            else if (compAdmin != "Y" && pFolderType == "C") {
	                alert("<spring:message code='ezAddress.t999900004' />");
	                return;
	            }
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var conHeight = 500;
	            var conWidth = 600;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - conWidth) / 2;
	            window.open("/ezAddress/addressWrite.do?ownerid=" + encodeURIComponent(pOwerID) + "&folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType, "",
	            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 500px, width = 600px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
	        }
	        function new_group() {
	        	if (deptAdmin != "Y" && pFolderType == "D") {
	                alert("<spring:message code='ezAddress.t999900003' />");
	                return;
	            }
	            else if (compAdmin != "Y" && pFolderType == "C") {
	                alert("<spring:message code='ezAddress.t999900004' />");
	                return;
	            }
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var conHeight = 655;
	            var conWidth = 970;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - conWidth) / 2;
	            window.open("/ezAddress/addressWriteGroup.do?ownerid=" + encodeURI(pOwerID) + "&folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType, "",
	            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 655px, width = 970px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
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
	                        createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", pFolderType);
	                        /* if(pFolderType == "P")
	                            subxmlHTTP.open("POST", "RemoteEWS/address_get_groupemail.aspx", false);
	                        else
	                            subxmlHTTP.open("POST", "Remote/address_get_groupemail.aspx", false); */
	                        subxmlHTTP.open("POST", "/ezAddress/addressGetGroupEmail.do", false);
	                        
	                        subxmlHTTP.send(xmlDom);
	                        xmlDom = subxmlHTTP.responseXML;
	                        var emailRows = SelectNodes(xmlDom, "DATA/ROW");
	                        for (var Cnt2 = 0; Cnt2 < emailRows.length; Cnt2++) {
	                            var name = SelectSingleNodeValue(emailRows[Cnt2], "NAME");
	                            var useremail = SelectSingleNodeValue(emailRows[Cnt2], "EMAIL");
	                            if (email == "")
	                                email = "\"" + name + "\" <" + useremail + ">";
	                            else
	                                email += ",\"" + name + "\" <" + useremail + ">";
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
	
	
	                if (CrossYN() || pNoneActiveX == "YES")
	                    window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURI(email), "",
	                        "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                else {
	                    if (pUse_Editor == "")
	                        window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURI(email), "",
	                                "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                    else
	                        window.open("/myoffice/ezEmail/mail_write_IE.aspx?cmd=NEW&msgTo=" + escape(email), "",
	                            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                }
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
	                    if (searchFlag) {
	                        createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "OLDFOLDERTYPE", AddressObj.getAttribute("_foldertype"));
	                        createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "FOLDERID", decodeURIComponent(AddressObj.getAttribute("_folderid")));
	                    }
	                    else {
	                        createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "OLDFOLDERTYPE", pFolderType);
	                        createNodeAndAppandNodeText(xmlDom, objRow, objRowNode, "FOLDERID", decodeURIComponent(pFolderID));
	                    }
	                }
	                if (CrossYN()) {
	                    address_movecopy_dialogArguments[0] = "";
	                    address_movecopy_dialogArguments[1] = move_address_Complete;
	                    address_movecopy_dialogArguments[2] = "CLOSE";
	                    address_movecopy_dialogArguments[3] = xmlDom;
	                    address_movecopyOpenWin = window.open("/ezAddress/addressMoveCopy.do", "address_movecopy", GetOpenWindowfeature(320, 375));
	                    try { address_movecopyOpenWin.focus(); } catch (e) { }
	                }
	                else {
	                    var feature = "dialogHeight:375px; dialogWidth:320px; status:no; help:no; edge:sunken";
	                    feature = feature + GetShowModalPosition(320, 375);
	                    var moveUrl = window.showModalDialog("/ezAddress/addressMoveCopy.do", null, feature);
	                    if (typeof (moveUrl) == "undefined")
	                        return;
	
	                    if (searchFlag) {
	                        for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                            var AddressObj = document.getElementById(listContentArry[Cnt]);
	                            if (moveUrl["folderid"] == AddressObj.getAttribute("_folderid")) {
	                                alert("<spring:message code='ezAddress.t170' />");
	                            return;
	                        	}
	                    	}
		                }
		                else {
		                    if (moveUrl["folderid"] == pFolderID && moveUrl["ownerid"] == pOwerID) {
		                        alert("<spring:message code='ezAddress.t170' />");
		                        return;
		                    }
		                }
	                    if (moveUrl["cmd"] == "MOVE") {
	                        for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                            var AddressObj = document.getElementById(listContentArry[Cnt]);
	                            if (typeof (AddressObj.getAttribute("_addressid")) != "undefined") {
	                            	if (pFolderType == "C" && compAdmin != "Y" && AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
	                            		alert("<spring:message code='ezAddress.t217' />");
	                                    return;
	                            	}
	                            	else if (pFolderType == "D" && deptAdmin != "Y" && AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
	                            		alert("<spring:message code='ezAddress.t217' />");
	                                    return;
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
	                        alert((listContentArry.length) + "<spring:message code='ezAddress.t219' />");
	                        if (moveUrl["cmd"] == "MOVE") {
	                            if (searchFlag)
	                                Get_SearchAddressList();
	                            else
	                                Get_AddressList();
	                        }
	                    }
	                }
	
	            }
	        }
	        function move_address_Complete(moveUrl) {
	            try {
	                if (typeof (moveUrl) == "undefined")
	                    return;
	                address_movecopyOpenWin.close();
	                if (searchFlag) {
	                    for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                        var AddressObj = document.getElementById(listContentArry[Cnt]);
	                        if (moveUrl["folderid"] == AddressObj.getAttribute("_folderid")) {
	                            alert("<spring:message code='ezAddress.t170' />");
	                            return;
	                        }
	                    }
	                }
	                else {
	                    if (moveUrl["folderid"] == pFolderID && moveUrl["ownerid"] == pOwerID) {
	                        alert("<spring:message code='ezAddress.t170' />");
	                        return;
	                    }
	                }
	                if (moveUrl["cmd"] == "MOVE") {
	                    for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                        var AddressObj = document.getElementById(listContentArry[Cnt]);
	                        if (typeof (AddressObj.getAttribute("_addressid")) != "undefined") {
	                        	if (typeof (AddressObj.getAttribute("_addressid")) != "undefined") {
	                            	if (pFolderType == "C" && compAdmin != "Y" && AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
	                            		alert("<spring:message code='ezAddress.t217' />");
	                                    return;
	                            	}
	                            	else if (pFolderType == "D" && deptAdmin != "Y" && AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
	                            		alert("<spring:message code='ezAddress.t217' />");
	                                    return;
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
	
	                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                    alert("<spring:message code='ezAddress.t218' />");
	                else {
	                    alert((listContentArry.length) + "<spring:message code='ezAddress.t219' />");
	                    if (moveUrl["cmd"] == "MOVE") {
	                        if (searchFlag)
	                            Get_SearchAddressList();
	                        else
	                            Get_AddressList();
	                    }
	                }
	            } catch (e) {}
	        }
	        function delete_address() {
	            if (listContentArry.length == 0) {
	                alert("<spring:message code='ezAddress.t212' />");
	            }
	            else {
	                for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                    var AddressObj = document.getElementById(listContentArry[Cnt]);
	                    if (typeof (AddressObj.getAttribute("_addressid")) != "undefined") {
	                    	if (typeof (AddressObj.getAttribute("_addressid")) != "undefined") {
                            	if (pFolderType == "C" && compAdmin != "Y" && AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
                            		alert("<spring:message code='ezAddress.t211' />");
                                    return;
                            	}
                            	else if (pFolderType == "D" && deptAdmin != "Y" && AddressObj.getAttribute("_ModifierID") != "${userInfo.id}" && AddressObj.getAttribute("_CreatorID") != "${userInfo.id}") {
                            		alert("<spring:message code='ezAddress.t211' />");
                                    return;
                            	}
                            }
	                    }
	                }
	                var DeleteItemID = "";
	                var xmlHTTP = createXMLHttpRequest();
	                for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                    var AddressObj = document.getElementById(listContentArry[Cnt]);
	                    /* if (AddressObj.getAttribute("_foldertype") == "P" || (AddressObj.getAttribute("_foldertype") == null && pFolderType == "P")) {
	                        if (DeleteItemID == "")
	                            DeleteItemID = decodeURIComponent(AddressObj.getAttribute("_addressid"));
	                        else
	                            DeleteItemID = DeleteItemID + "," + decodeURIComponent(AddressObj.getAttribute("_addressid"));
	                    } */
	                }
	                /* var xmlDom = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlDom, objNode, "DATA");
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERID", pFolderID);
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", "P");
	                createNodeAndInsertText(xmlDom, objNode, "DELETELIST", DeleteItemID);
	                xmlHTTP.open("POST", "RemoteEWS/address_deleteItems.aspx", false);
	                xmlHTTP.send(xmlDom); */
	
	                var xmlDom = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlDom, objNode, "DATA");
	                for (var Cnt = 0; Cnt < listContentArry.length ; Cnt++) {
	                    var AddressObj = document.getElementById(listContentArry[Cnt]);
	                    /* if (AddressObj.getAttribute("_foldertype") != "P" || (AddressObj.getAttribute("_foldertype") == null && pFolderType != "P")) {
	                        createNodeAndInsertText(xmlDom, objNode, "ID", decodeURIComponent(AddressObj.getAttribute("_addressid")));
	                    } */
	                    createNodeAndInsertText(xmlDom, objNode, "ID", decodeURIComponent(AddressObj.getAttribute("_addressid")));
	                }
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERID", pFolderID);
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", pFolderType);
	                xmlHTTP.open("POST", "/ezAddress/addressDelete.do", false);
	                xmlHTTP.send(xmlDom);
	
	                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                    alert("<spring:message code='ezAddress.t214' />");
	                 else {
	                     alert((listContentArry.length) + "<spring:message code='ezAddress.t215' />");
	                     pTotalCnt = parseInt(pTotalCnt) - listContentArry.length;
	                     if (pCurrentPage != 1 && pTotalCnt == (pCurrentPage - 1) * pPageSize)
	                         pCurrentPage--;
	                     if (searchFlag)
	                         Get_SearchAddressList();
	                     else
	                         Get_AddressList();
	                 }
	            }
	        }
	        function quick_add() {
	            if (document.getElementById("qname").value == "") {
	                alert("<spring:message code='ezAddress.t220' />");
	                document.getElementById("qname").focus();
	                return;
	            }
	
	            var regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
	            if (regex.test(document.getElementById("qemail").value) === false) {
	                alert("<spring:message code='ezAddress.t350' />");
	                document.getElementById("qemail").focus();
	                return;
	            }
	
	            if (!check_length(document.getElementById("qname").value, 50, "<spring:message code='ezAddress.t124' />")) return;
	            if (!check_length(document.getElementById("qcompany").value, 50, "<spring:message code='ezAddress.t221' />")) return;
	            if (!check_length(document.getElementById("qcomphone").value, 20, "<spring:message code='ezAddress.t222' />")) return;
	            if (!check_length(document.getElementById("qmobile").value, 20, "<spring:message code='ezAddress.t223' />")) return;
	            if (!check_length(document.getElementById("qemail").value, 250, "<spring:message code='ezAddress.t224' />")) return;
	
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlDom = createXmlDom();
	
	            var objNode, objRow;
	            objNode = createNodeInsert(xmlDom, objNode, "DATA");
	            createNodeAndInsertText(xmlDom, objNode, "FOLDERID", pFolderID);
	            createNodeAndInsertText(xmlDom, objNode, "TYPE", pFolderType);
	            createNodeAndInsertText(xmlDom, objNode, "OWNERID", pOwerID);
	            createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", "");
	            createNodeAndInsertText(xmlDom, objNode, "CHANGEKEY", "");
	            createNodeAndInsertText(xmlDom, objNode, "PHOTOPATH", "");
	            createNodeAndInsertText(xmlDom, objNode, "SNAME", document.getElementById("qname").value);
	            createNodeAndInsertText(xmlDom, objNode, "SCOMPANY", document.getElementById("qcompany").value);
	            createNodeAndInsertText(xmlDom, objNode, "SDEPT", "");
	            createNodeAndInsertText(xmlDom, objNode, "STITLE", "");
	            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYPHONE", document.getElementById("qcomphone").value);
	            createNodeAndInsertText(xmlDom, objNode, "SMOBILE", document.getElementById("qmobile").value);
	            createNodeAndInsertText(xmlDom, objNode, "SFAX", "");
	            createNodeAndInsertText(xmlDom, objNode, "SEMAIL", document.getElementById("qemail").value);
	            createNodeAndInsertText(xmlDom, objNode, "SHOMEPAGE", "");
	            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYZIP", "");
	            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYADDR", "");
	            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYADDR", "");
	            createNodeAndInsertText(xmlDom, objNode, "SHOMEZIP", "");
	            createNodeAndInsertText(xmlDom, objNode, "SHOMEADDR", "");
	            createNodeAndInsertText(xmlDom, objNode, "SMEMO", "");
	            createNodeAndInsertText(xmlDom, objNode, "STYPE", "P");
	            createNodeAndInsertText(xmlDom, objNode, "USERNM", "");
	            createNodeAndInsertText(xmlDom, objNode, "USERNM2", "");
	            objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ATTACHLIST");
	            
	            /* if(pFolderType == "P")
	                xmlHTTP.open("POST", "RemoteEWS/address_save.aspx", false);
	            else
	                xmlHTTP.open("POST", "Remote/address_save.aspx", false); */
	            xmlHTTP.open("POST", "/ezAddress/addressSave.do", false);
	            
	            xmlHTTP.send(xmlDom);
				
	            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
	            	if (xmlHTTP.status != 200) {
	            		alert("<spring:message code='ezAddress.t226' />");
	            		return;
	            	}
	            	else if (xmlHTTP.responseText == "PRE") {
	            		alert("<spring:message code='ezAddress.t225' />");
	            		return;
	            	}
	            	else if (xmlHTTP.responseText == "NO_AUTHORITY") {
	            		alert("<spring:message code='ezAddress.t1' />");
	            		window.location.href = window.location.href;
	            	}
	            	else {
	            		alert("<spring:message code='ezAddress.t226' />");
	            		return;
	            	}
	            }
	            else {
	            	window.location.href = window.location.href;
	            }
	            
	        }
	        function check_length(chkstr, maxlength, fieldname) {
	            var length = 0;
	            var i;
	
	            for (i = 0; i < chkstr.length; i++)
	                if (chkstr.charCodeAt(i) > 256)
	                    length = length + 2;
	                else
	                    length++;
	
	            if (length > maxlength) {
	                alert(fieldname + "<spring:message code='ezAddress.t227' />" + maxlength + "<spring:message code='ezAddress.t228' />");
			    return false
			}
	
	        return true;
	        }
	
	        function address_inout(which) {
	            var feature = "dialogWidth:390px; dialogHeight:290px; scroll:no; status:no; help:no;edge:sunken";
	            feature = feature + GetShowModalPosition(390, 290);
	            if (which == 0)
	                window.showModalDialog("address_export.aspx?folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType + "&ownerid=" + escape(pOwerID), null, feature);
	            else {
	                window.showModalDialog("address_import.aspx?folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType + "&ownerid=" + escape(pOwerID), null, feature);
	                window.location.reload();
	            }
	        }
	
	        function doLayerPopup(obj) {
	            if (obj.getAttribute("mode") == "off") {
	                document.getElementById("layer_popup").style.left = "55px";
	                document.getElementById("layer_popup").style.top = "100px";
	                document.getElementById("layer_popup").style.display = "";
	                document.getElementById("srarchpopup").style.display = "";
	                document.getElementById("addpopup").style.display = "none";
	                obj.setAttribute("mode", "on");
	                HiddenLayer_Click();
	            }
	            else {
	                SearchOptionHidden();
	            }
	        }
	        function SearchOptionHidden() {
	            document.getElementById("srarchpopup").style.display = "none";
	            document.getElementById("addpopup").style.display = "";
	            document.getElementById("layer_popup").style.display = "none";
	            document.getElementById("SearchOption").setAttribute("mode", "off");
	            HiddenLayer_Click();
	        }
	
	        function search_start() {
	            if (document.getElementById("search_text").value == "") {
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
	            var searchText = document.getElementById("search_text").value;
	            filter = subtype + "," + searchText;
	            pCurrentPage = "1";
	            searchFlag = true;
	            Get_SearchAddressList();
	            SearchOptionHidden();
	        }
	
	        function search_keypress() {
	            if (window.event.keyCode == "13")
	                search_start();
	        }
	        function check_click(obj) {
	            if (document.getElementById(obj).checked != true)
	                document.getElementById(obj).checked = true;
	            else
	                document.getElementById(obj).checked = false;
	        }
	        var xmlHTTP = createXMLHttpRequest();
	        function crossexport() {
	            var pURL = "/ezAddress/excelExport.do?folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType + "&ownerid=" + encodeURIComponent(pOwerID);
	            saveExcel.location.href = pURL;

	            setNodeText(document.getElementById("loadtxt"), "<spring:message code='ezAddress.t5001' />");
	            document.getElementById("Div1").style.display = "";
	            document.getElementById("loadingLayer").style.display = "";
	            document.getElementById("loadingLayer").style.top = (document.documentElement.clientHeight / 2) + "px";
	            document.getElementById("loadingLayer").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";

	            setTimeout("CheckReadState()", 500);
	        }
	        function CheckReadState() {
	            var pURL = "/ezAddress/excelExport.do";
	            xmlHTTP.open("POST", pURL, false);
	            xmlHTTP.onreadystatechange = event_CrossExport;
	            xmlHTTP.send();
	        }
	        function event_CrossExport() {
	            if (xmlHTTP.readyState == 4 && xmlHTTP != null) {
	                if (xmlHTTP.status == 200) {
	                    document.getElementById("Div1").style.display = "none";
	                    document.getElementById("loadingLayer").style.display = "none";
					}
	            }
	        }
	        function crossImport() {
	        	if (deptAdmin != "Y" && pFolderType == "D") {
	        		alert("<spring:message code='ezAddress.t1' />");
	                return;
	            }
	            else if (compAdmin != "Y" && pFolderType == "C") {
	            	alert("<spring:message code='ezAddress.t1' />");
	                return;
	            }
	        	
	            document.getElementById("file1").click();
	        }
	        function btn_AttachAdd_onclick() {
	            var tempname = document.form.file1.value;
	        	if (tempname == "") {
		            return;
	            }
	        	
	            var last = tempname.split(".").length;
	            var extension = tempname.split(".")[last - 1];

	            if (extension.toUpperCase() != "CSV") {
	                alert("<spring:message code='ezAddress.t179' />");
	                return;
	            }
				
	            document.getElementById("Div1").style.display = "";
	            document.getElementById("loadingLayer").style.display = "";
	            document.getElementById("loadingLayer").style.top = (document.documentElement.clientHeight / 2) + "px";
	            document.getElementById("loadingLayer").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";
	            
		        var frm = document.getElementById('form');
		        frm.action = "/ezAddress/excelImport.do?folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType + "&ownerid=" + encodeURIComponent(pOwerID);
		        frm.submit();
	        }
	        function UploadComplete(result) {
	        	document.form.file1.value = "";
	        	document.getElementById("Div1").style.display = "none";
		        document.getElementById("loadingLayer").style.display = "none";
		        
		        if (result == "OK") {
		        	alert("<spring:message code='ezAddress.t178' />");
		        } else {
		        	alert("<spring:message code='ezAddress.t181' />");
		        }
		        
		        window.location.reload();
		    }
	    </script>
    </head>
	<body class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);" style="overflow:hidden">
		<h1><spring:message code='ezAddress.t231' /><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
			    <li><span  onClick="new_address()"><spring:message code='ezAddress.t236' /></span></li>
				<li><span  onClick="new_group()"><spring:message code='ezAddress.t237' /></span></li>
				<li id="importaddress"><span  onClick="address_inout(1)"><spring:message code='ezAddress.t210' /></span></li>
				<li id="exportaddress"><span  onClick="address_inout(0)"><spring:message code='ezAddress.t143' /></span></li>
				
				<li id="importaddress_Cross"><span onclick="crossImport()"><spring:message code='ezAddress.t210' /></span></li>
        		<li id="exportaddress_Cross"><span onclick="crossexport()"><spring:message code='ezAddress.t143' /></span></li>
				
				<li><span onClick="write_letter()"><spring:message code='ezAddress.t238' /></span></li>
				<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
				<li><span id="SearchOption" mode="off" onClick="doLayerPopup(this)"><spring:message code='ezAddress.t142' /></span></li>
				<li><span onClick="move_address()"><spring:message code='ezAddress.t239' /></span></li>
				<li><span onClick="delete_address()"><spring:message code='ezAddress.t175' /></span></li>
				<li><span onClick="window.location.reload(false)"><spring:message code='ezAddress.t240' /></span></li>
				<li><span onclick="ShowQuickAddres();"><spring:message code='ezAddress.t2002' /></span></li>
				<li style="background:none">
					<select style="margin-top:-3px;width:100px" id="ListViewType" onchange="View_Change();">
						<option value="card" <c:if test="${pListType == 'card'}"> selected</c:if>><spring:message code='ezAddress.t2000' /></option>
						<option value="list" <c:if test="${pListType == 'list'}"> selected</c:if>><spring:message code='ezAddress.t2001' /></option>
				    </select>
				</li>
			</ul>
		</div>
		<ul class="address_wordmenu" id="address_wordmenu" style="margin-bottom:0px;">
			<li><span onClick="pFilterDB='';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()"><spring:message code='ezAddress.t243' /></span></li>
			<span id="address_wordmenu_korea">
				<li><span onClick="pFilterDB='INDEX_KO,ㄱ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㄱ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㄴ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㄴ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㄷ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㄷ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㄹ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㄹ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅁ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅁ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅂ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅂ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅅ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅅ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅇ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅇ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅈ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅈ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅊ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅊ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅋ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅋ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅌ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅌ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅍ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅍ</span></li>
				<li><span onClick="pFilterDB='INDEX_KO,ㅎ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ㅎ</span></li>
			</span>
			<span id="address_wordmenu_japan">
				<li><span onClick="pFilterDB='INDEX_JA,あ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">あ</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,か';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">か</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,さ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">さ</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,た';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">た</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,な';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">な</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,は';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">は</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,ま';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ま</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,や';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">や</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,ら';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">ら</span></li>
				<li><span onClick="pFilterDB='INDEX_JA,わ';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">わ</span></li>
			</span>
			<li><span onClick="pFilterDB='INDEX_EN,A';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">A</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,B';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">B</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,C';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">C</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,D';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">D</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,E';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">E</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,F';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">F</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,G';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">G</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,H';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">H</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,I';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">I</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,J';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">J</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,K';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">K</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,L';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">L</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,M';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">M</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,N';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">N</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,O';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">O</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,P';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">P</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,Q';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">Q</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,R';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">R</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,S';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">S</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,T';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">T</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,U';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">U</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,V';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">V</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,W';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">W</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,X';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">X</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,Y';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">Y</span></li>
			<li><span onClick="pFilterDB='INDEX_EN,Z';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">Z</span></li>
			<c:choose>
				<c:when test="${userInfo.lang eq '1'}">
					<li><span onClick="pFilterDB='INDEX_KO,ETC';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">
						<spring:message code='ezAddress.t259' /></span>
					</li>
				</c:when>
				<c:when test="${userInfo.lang eq '3'}">
					<li><span onClick="pFilterDB='INDEX_JA,ETC';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">
						<spring:message code='ezAddress.t259' /></span>
					</li>
				</c:when>
				<c:otherwise>
					<li><span onClick="pFilterDB='INDEX_EN,ETC';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">
						<spring:message code='ezAddress.t259' /></span>
					</li>
				</c:otherwise>
			</c:choose>
			
			<%--개인주소록, 부서주소록 소팅 기능임 삭제 하지 마시오--%>
			<%--
			<li><span onClick="pFilter=&quot;KIND,IPM.Contact&quot;;pOrderOption='SNAME:0';pCurrentPage='1';Get_AddressList()">Person</span></li>
			<li><span onClick="pFilter=&quot;KIND,IPM.DistList&quot;;pOrderOption='SNAME:0';pCurrentPage='1';Get_AddressList()">Group</span></li>
			--%>
		</ul>
		<br />
		<div style="vertical-align:top;border:0px solid red;" id="list_Layer">
			<table class="mainlist" id="DetailList_header">
			    <tr>
					<th style="cursor:pointer;padding:0;width:20px">
				    	<input type="checkbox" id="HeaderAllCheckBox" onClick="event_HeaderCheckBoxClick(this)">
					</th>
					<th style="padding:0;text-align:center;width:20px"><img src="/images/i_individual.gif" border="0"></th>
					<th id="CompanyName" style="CURSOR:pointer;width:20%;white-space:nowrap;"onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" _OrderOption="1" _OrderName="SNAME" onClick="OderbyOptionExpression(this)" ><spring:message code='ezAddress.t124' /><span id="SNAME"></span></th>
					<th id="PhoneNumber" style="CURSOR:pointer;width:20%;white-space:nowrap;" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" _OrderOption="0" _OrderName="SCOMPANY" onClick="OderbyOptionExpression(this)" ><spring:message code='ezAddress.t51' /><span id="SCOMPANY"></span></th>
					<th style="CURSOR:pointer;width:20%;white-space:nowrap;" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" _OrderOption="0" _OrderName="SCOMPANYPHONE" onClick="OderbyOptionExpression(this)" ><spring:message code='ezAddress.t263' /><span id="SCOMPANYPHONE"></span></th>
					<th style="CURSOR:pointer;width:20%;white-space:nowrap;" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" _OrderOption="0" _OrderName="SMOBILE" onClick="OderbyOptionExpression(this)" ><spring:message code='ezAddress.t189' /><span id="SMOBILE"></span></th>
					<th style="CURSOR:pointer;width:20%;white-space:nowrap;" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" _OrderOption="0" _OrderName="SEMAIL" onClick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t264' /><span id="SEMAIL"></span></th>
					<th id="FolderType" style="CURSOR:pointer;width:10%;white-space:nowrap;display:none" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'" _OrderOption="0" _OrderName="STYPE" onClick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t231' /><span id="STYPE"></span></th>
				</tr>
			</table>
			<div id="contentlist" name="contentlist" style="border:0px solid blue;height:350px;width:100%;overflow-y:auto;">
				<table class="mainlist" style="" id="MailList"></table>
				<div style="height:100%;display:none;" id="MailListCard" ></div>
			</div>
			<div id="tblPageRayer"  style="width:450px; margin:6px auto;"></div>
		</div>
		<div style="width:100%;height:100%;position:absolute;top:0px;left:0px;display:none;z-index:5000;" id="mailPanel" onclick="ShowQuickAddres();" >&nbsp;</div>
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
			<img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<div id="layer_popup" style="width:524px;z-index:6000;display:none;position:absolute;top:100px;left:100px;text-align:center;vertical-align:middle;background-color:#ffffff;">
			<div id="addpopup" class="popupwrap1">
				<div class="popupwrap3">
					<h1><spring:message code='ezAddress.t2003' /></h1>
					<div id="x_close" onclick="ShowQuickAddres();"><em><spring:message code='ezAddress.t5' /></em></div>
					<!-- 내용 -->
				    <table class="popuplist" style="width:480px;margin:10px 0px 0px 1px;">
						<tr>
				  			<th style="width:120px"><spring:message code='ezAddress.t124' /></th>
							<td><input type="text" id="qname" name="qname" class="textarea" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" maxlength="50">      </td>
						</tr>
						<tr>
				  			<th style="width:150px"><spring:message code='ezAddress.t221' /></th>
							<td><input type="text" id="qcompany" name="qcompany" class="textarea" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" maxlength="50">      </td>
						</tr>
						<tr>
				  			<th style="width:90px" ><spring:message code='ezAddress.t222' /></th>
							<td><input type="text" id="qcomphone" name="qcomphone" class="textarea" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" maxlength="20">      </td>
						</tr>
						<tr>
							<th style="width:90px"><spring:message code='ezAddress.t223' /></th>
							<td><input type="text" id="qmobile" name="qmobile" class="textarea" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" maxlength="20">      </td>
						</tr>
						<tr>
							<th><spring:message code='ezAddress.t264' /></th>
							<td><input type="text" id="qemail" name="qemail" class="textarea" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" maxlength="250">      </td>
						</tr>
					</table>
					<!-- /내용 -->
					<br />
					<div style="text-align:center;">
						<a class="imgbtn"><span onclick="quick_add()" ><spring:message code='ezAddress.t173' /></span></a>
						<a class="imgbtn"><span onclick="quick_cancel()" ><spring:message code='ezAddress.t11' /></span></a>
				    </div>
				</div>
			</div>
			<div id="srarchpopup" class="popupwrap1" style="display:none">
				<div class="popupwrap3">
					<h1><spring:message code='ezAddress.t312' /></h1>
					<table class="content">  
						<tr>
							<th style="text-align:center"><spring:message code='ezAddress.t314' /></th>
							<td style="text-align:left">
								<input type="checkbox" name="chkType" id="CheckUser" /><span onclick="check_click('CheckUser')" style="cursor: pointer;"><spring:message code='ezAddress.t145' /></span>
								<input type="checkbox" name="chkType" id="CheckDept" /><span onclick="check_click('CheckDept')" style="cursor: pointer;"><spring:message code='ezAddress.t146' /></span>
								<input type="checkbox" name="chkType" id="CheckCompany" /><span onclick="check_click('CheckCompany')" style="cursor: pointer;"><spring:message code='ezAddress.t147' /></span>
							</td>
						</tr>
						<tr>
							<th style="text-align:center">
								<select name="search_case" id="search_case">
									<option value="S_NAME"><spring:message code='ezAddress.t124' /></option>
									<option value="S_COMPANY"><spring:message code='ezAddress.t51' /></option>
									<option value="S_DEPT"><spring:message code='ezAddress.t54' /></option>
									<option value="S_TITLE"><spring:message code='ezAddress.t52' /></option>
									<option value="S_COMPANY_ADDR"><spring:message code='ezAddress.t295' /></option>
									<option value="S_HOME_ADDR"><spring:message code='ezAddress.t296' /></option>
									<option value="S_MEMO"><spring:message code='ezAddress.t259' /></option>
									<option value="S_EMAIL"><spring:message code='ezAddress.t264' /></option>
									<option value="S_COMPANY_PHONE"><spring:message code='ezAddress.t263' /></option>
									<option value="S_MOBILE"><spring:message code='ezAddress.t189' /></option>
									<option value="S_FAX"><spring:message code='ezAddress.t292' /></option>
									<option value="S_HOMEPAGE"><spring:message code='ezAddress.t293' /></option>
								</select>
							</th>
							<td style="text-align:left">
								<input type="text" name="search_text" id="search_text" class="textarea" style="width:100%" onkeypress="return search_keypress()" >
							</td>
						</tr>
					</table>
					<br />
					<table style="width:100%">
						<tr>
							<td style="text-align:center;">
								<a class="imgbtn"><span onClick="search_start()"><spring:message code='ezAddress.t142' /></span></a>
								<a class="imgbtn"><span onClick="SearchOptionHidden()"><spring:message code='ezAddress.t11' /></span></a>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="shadow"></div>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;display:none;" id="Div1">&nbsp;</div>
	    <span class="loading_layer" style="z-index:6000;position:absolute;top:400px;left:300px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><span id="loadtxt"><spring:message code='ezAddress.t5000' /></span></span></span>
	    <iframe id=saveExcel name=saveExcel style="display:none"></iframe>
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezAddress/excelImport.do" target="ifrm">
	        <input type="file" name="file1" id="file1" accept=".csv" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;"/>
	    </form>
	</body>
</html>