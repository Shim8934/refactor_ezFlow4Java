<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
	    <title>address_list</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
	    <style>
	    	.emptyDiv {
	    		height: 140px;
	    		padding-top: 60px;
	    		color : #d0d0d0;
	    		font-size : 12px;
	    		font-weight: bold;
	    	}
	    	
        	.dupliPopUpTableHeader th {text-align:center; height:30px;}
        	.dupliPopUpTableHeader th#dupliPopUpTableHeaderScroll {border: 0; padding: 0;}
        	
        	.dupliPopUpTableBodyDIV {overflow-y: auto;height: 170px;}
        	.dupliPopUpTableBodyDIV::-webkit-scrollbar {width: 5px;}
        	.dupliPopUpTableBodyDIV::-webkit-scrollbar-thumb {background-color: #d2d2d2; border-radius: 5px}
        	.dupliPopUpTableBodyDIV::-webkit-scrollbar-track {background-color: #ececec;}
        
	        .dupliPopUpTableBody {margin-top:10px;width: 100%;margin: 0;border: 0;}
	        .dupliPopUpTableBody tr td:first-child {background-color: #e5efff3d;}
        	.dupliPopUpTableBody td {box-sizing: border-box; padding: 5px; line-height: 18px; word-break: break-word; text-align:left; height:30px; }
        	.dupliPopUpTableBody td div {font-size: 13px; font-weight: 700; box-sizing: border-box; padding: 3px 5px;}
        	.dupliPopUpTableBody td span {color: #6b6b6b; box-sizing: border-box; padding: 3px 5px;}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/Address_List.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezAddress.e1', 'msg')}"></script>
	    <script type="text/javascript">
	        var pFolderID = "<c:out value='${pFolderId}'/>";
	        var pFolderType = "<c:out value='${pFolderType}'/>";
	        var pOwerID = "<c:out value='${pOwerId}'/>";
	        var deptAdmin = "<c:out value='${deptAdmin}'/>";
	        var compAdmin = "<c:out value='${compAdmin}'/>";
	        var useAnyoneEdit = "<c:out value='${useAnyoneEdit}'/>";
	        var pCurrentPage = "1";
	        var pOrderOption = "S_NAME:0";
	        var pFilter = "";
	        var pFilterDB = "";
	        var pTotalCnt = "";
	        var pPageSize = "";
	        var pMaxPage = "";
	        var pAddrType = "";
	        var BlockSize = 10;
	        var pFolderName = "";
	        var m_strColorSelect = "#f1f8ff";
	        var m_strColorOver = "#f4f5f5";
	        var m_strColorDefault = "#ffffff";
	        var searchFlag = false;
	        var CardHeader1 = "<spring:message code='ezAddress.t263' />";
	        var CardHeader2 = "<spring:message code='ezAddress.t189' />";
	        var CardHeader3 = "<spring:message code='ezAddress.t264' />";
	        var uLang = "${userInfo.lang}";
	        var pUse_Editor = "${useEditor}";
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
	            
	            //일본어일 경우 초성 검색 숨김 (한자까지 지원할 수 없어서)
	            if (uLang == "3") {
	            	document.getElementById("address_wordmenu").style.borderBottom = "0px";
	            	document.getElementById("address_wordmenu").style.minHeight = "0px";
	            	document.getElementById("address_wordmenu").style.margin = "0px";
	            	document.getElementById("address_wordmenu").style.padding = "7px";	            	
	            	document.getElementById("contentlist").style.marginBottom = "48px";
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
	            addressTitleMapping();
	            Get_AddressList();
	        }
	        
	        /* 2018-08-11 장진혁 - 레이어팝업 생성된 상태에서 backspace 누를시 왼쪽프레임 부분 딤 처리 없애기 */
	        window.onunload = function () {
	        	if (parent.frames["left"]) {
	        		if (parent.frames["left"].document.getElementById("blockLeft")) {
	        			$(parent.frames["left"].document.body).css("overflow", "");
	        	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
	        		}
	        	} else if (parent.frames["attitude_menu"]) {
	        		if (parent.frames["attitude_menu"].document.getElementById("blockLeft")) {
	        	    	$(parent.frames["attitude_menu"].document.getElementById("blockLeft")).remove();
	        		}
	        	}
	        	      
	        	if (parent.parent.frames["left"]) {
	        		if (parent.parent.frames["board_menu"]) {  		  
	        			$(parent.parent.frames["board_menu"].document.body).css("overflow", "");
	        			$(parent.parent.frames["board_menu"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["board_main"].document.getElementById("blockTop")).remove();
	        		} else if (parent.parent.frames["left"].document.getElementById("blockLeft")) {  		  
	        			$(parent.parent.frames["left"].document.body).css("overflow", "");
	        			$(parent.parent.frames["left"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["right"].document.getElementById("blockTop")).remove();
	        		}
	        	}
	        }
	        
	        /* 2020-02-07 홍승비 - 주소록 가져오기, 내보내기 레이어 팝업도 동적으로 left 계산 */
	        $(window).on("resize", function(){
				var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;	        	
	        	$("#addpopup").css("left", popupX);
	        	$("#srarchpopup").css("left", popupX);
	        	$("#importPopup").css("left", popupX);
	        	$("#exportPopup").css("left", popupX);
	        	$("#dupliPopUp").css("left", popupX);
	        });
	        
	        function new_address() {
	        	if (useAnyoneEdit != "YES") {
	        		if (deptAdmin != "Y" && pFolderType == "D") {
		                alert("<spring:message code='ezAddress.t999900003' />");
		                return;
		            }
		            else if (compAdmin != "Y" && pFolderType == "C") {
		                alert("<spring:message code='ezAddress.t999900004' />");
		                return;
		            }
	        	}
	            
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var conHeight = 500;
	            var conWidth = 600;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - conWidth) / 2;
	            window.open("/ezAddress/addressWrite.do?ownerid=" + encodeURIComponent(pOwerID) + "&folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType, "", GetOpenWindowfeature(600, 510, 0));
	        }
	        function new_group() {
	        	if (useAnyoneEdit != "YES") {
		        	if (deptAdmin != "Y" && pFolderType == "D") {
		                alert("<spring:message code='ezAddress.t999900003' />");
		                return;
		            }
		            else if (compAdmin != "Y" && pFolderType == "C") {
		                alert("<spring:message code='ezAddress.t999900004' />");
		                return;
		            }
	        	}
	        	
	            window.open("/ezAddress/addressWriteGroup.do?ownerid=" + encodeURIComponent(pOwerID) + "&folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType, "", GetOpenWindowfeature(968,646, 0));
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
	                        
	                        if (emailRows.length > 0) {
	                            var addrname = AddressObj.getAttribute("_Sname");
	                            if (pFolderType == "P")
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
	                var pLeft = (pwidth - 1200) / 2;

	                window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(email), "",
                        "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
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
	                    address_movecopyOpenWin = window.open("/ezAddress/addressMoveCopy.do", "address_movecopy", GetOpenWindowfeature(500, 375));
	                    try { address_movecopyOpenWin.focus(); } catch (e) {console.log(e);}
	                }
	                else {
	                    var feature = "dialogHeight:375px; dialogWidth:500px; status:no; help:no; edge:sunken";
	                    feature = feature + GetShowModalPosition(500, 375);
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
	                        alert("<spring:message code='ezAddress.t219' />");
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
	                        if (moveUrl["folderid"] == AddressObj.getAttribute("_folderid")
	                                && moveUrl["foldertype"] == AddressObj.getAttribute("_FolderType")) {
	                            
		                    	// 2024.07.05 한슬기 : 팝업창이 완전히 닫혔는지 체크 후에 alert을 띄우도록 변경(safari에서 alert이 가려지는 문제가 있음)
		    	                var checkChildClosed = setInterval(function() {
		    						if (address_movecopyOpenWin.closed){
		    							clearInterval(checkChildClosed);
		    							alert("<spring:message code='ezAddress.t170' />");
		    						}
		    					}, 100);
		                    	
	   							return;
	                        	
	                        	//alert("<spring:message code='ezAddress.t170' />");
	                            //return;
	                        }
	                    }
	                }
	                else {
	                    if (moveUrl["folderid"] == pFolderID && moveUrl["ownerid"] == pOwerID) {
	                    	// 2024.07.05 한슬기 : 팝업창이 완전히 닫혔는지 체크 후에 alert을 띄우도록 변경(safari에서 alert이 가려지는 문제가 있음)
	    	                var checkChildClosed = setInterval(function() {
	    						if (address_movecopyOpenWin.closed){
	    							clearInterval(checkChildClosed);
	    							alert("<spring:message code='ezAddress.t170' />");
	    						}
	    					}, 100);
	                    	
   							return;
	                    	
	                    	//alert("<spring:message code='ezAddress.t170' />");
	                        //return;
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
	
	                // 2024.07.05 한슬기 : 팝업창이 완전히 닫혔는지 체크 후에 alert을 띄우도록 변경(safari에서 alert이 가려지는 문제가 있음)
	                var checkChildClosed = setInterval(function() {
						if (address_movecopyOpenWin.closed){
							
							clearInterval(checkChildClosed);
							
			                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
			                    alert("<spring:message code='ezAddress.t218' />");
			                else {
			                    alert("<spring:message code='ezAddress.t219' />");
			                    if (moveUrl["cmd"] == "MOVE") {
			                        if (searchFlag)
			                            Get_SearchAddressList();
			                        else
			                            Get_AddressList();
			                    }
			                }
						}
						
					}, 100);
	                
	                /*if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                    alert("<spring:message code='ezAddress.t218' />");
	                else {
	                    alert("<spring:message code='ezAddress.t219' />");
	                    if (moveUrl["cmd"] == "MOVE") {
	                        if (searchFlag)
	                            Get_SearchAddressList();
	                        else
	                            Get_AddressList();
	                    }
	                }*/
	            } catch (e) {console.log(e);}
	        }
	        function delete_address() {
	        		
	        		if ( pTotalCnt == 0) {
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
		
		                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
			                alert("<spring:message code='ezAddress.t214' />");
		                }
						else {
		                    alert("<spring:message code='ezAddress.t215' />");
		                    
		                    document.getElementById("HeaderAllCheckBox").checked = false;
		                    
		                    pTotalCnt = parseInt(pTotalCnt) - listContentArry.length;
		                    if (pCurrentPage != 1 && pTotalCnt == (pCurrentPage - 1) * pPageSize) {
		                    	pCurrentPage--;
		                    }
		                    if (searchFlag) {
		                    	Get_SearchAddressList();
		                    }
		                    else {
		                    	Get_AddressList();
		                	}
		            	}
	            	}
	            }
	        }
	        function quick_add() {
	        	var pQname = document.getElementById("qname").value.trim();
	            var pQemail = document.getElementById("qemail").value.trim();
	            var regex = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
	            
                if (pQname == "") {
                	document.getElementById("qname").focus();
	                alert("<spring:message code='ezAddress.t220' />");
	                return;
                } 
	        	
                if (pQname.indexOf("&") > -1 || pQname.indexOf("<") > -1 || pQname.indexOf(">") > -1 
   	        		 || pQname.indexOf("\"") > -1 || pQname.indexOf("'") > -1 || pQname.indexOf(";") > -1) {
              		alert("<spring:message code='ezEmail.psb17' /> [ & < > \" ' ; ]");
              		document.getElementById("pQname").focus();
   	            	return;
   	        	}
                
	            if (document.getElementById("qemail").value != "" && regex.test(document.getElementById("qemail").value) === false) {
	                alert("<spring:message code='ezAddress.t1100' />");
	                document.getElementById("qemail").focus();
	                return;
	            }
	
	            if (document.getElementById("qemail").value != "") {
	                var AddressCnt = Get_SameAddressCnt();
	
	                if (parseInt(AddressCnt) > 0) {
	                    alert("<spring:message code='ezAddress.t225' />");
	                    return;
	                }
	            }
	            
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
	            createNodeAndInsertText(xmlDom, objNode, "SNAME", pQname);
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
	            createNodeAndInsertText(xmlDom, objNode, "FURIGANA", "");
	            objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ATTACHLIST");
	            
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
	            	else if (xmlHTTP.responseText == "NO_AUTHORITY_D") {
	            		alert("<spring:message code='ezAddress.t999900003' />");
	            		window.location.href = window.location.href;
	            	}
	            	else if (xmlHTTP.responseText == "NO_AUTHORITY_C") {
	            		alert("<spring:message code='ezAddress.t999900004' />");
	            		window.location.href = window.location.href;
	            	}
	            	else {
	            		alert("<spring:message code='ezAddress.t226' />");
	            		return;
	            	}
	            }
	            /* 2018-09-03 홍승비 - 간단추가 완료 이후 추가한 정보 td에서 제거 */
	            else {
	            	quick_add_close();
	            	$.modal.close();
	            	Get_AddressList();
	            }	            
	        }
	        function address_inout(which) {
	            var feature = "dialogWidth:390px; dialogHeight:290px; scroll:no; status:no; help:no;edge:sunken";
	            feature = feature + GetShowModalPosition(390, 290);
	            if (which == 0)
	                window.showModalDialog("address_export.aspx?folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType + "&ownerid=" + encodeURIComponent(pOwerID), null, feature);
	            else {
	                window.showModalDialog("address_import.aspx?folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType + "&ownerid=" + encodeURIComponent(pOwerID), null, feature);
	                window.location.reload();
	            }
	        }	
	        function doLayerPopup() {
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#srarchpopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	// 검색 레이어 팝업 열기 전에 input 내용 지워주도록 처리. 2019-08-02 홍대표.
	        	var inputElem = document.getElementById("srarchpopup").getElementsByTagName("input");
	        	[].forEach.call(inputElem, function(elem){
	        		if(elem.type == "checkbox") {
	        			elem.checked = false;
	        		}
	        		
	        		elem.value = "";
	        	});
	        	
	        	$("#srarchpopup").modal();
	        }	        
	        function SearchOptionHidden() {
	        	quick_add_close();
	        	$.modal.close();
	        }	        
	        function ShowQuickAddres() {
	        	if (useAnyoneEdit != "YES") {
		        	if (deptAdmin != "Y" && pFolderType == "D") {
		                alert("<spring:message code='ezAddress.t999900003' />");
		                return;
		            }
		            else if (compAdmin != "Y" && pFolderType == "C") {
		                alert("<spring:message code='ezAddress.t999900004' />");
		                return;
		            }
	        	}	        	
	        	
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#addpopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	// 레이어 팝업에서 x 버튼과 배경을 눌러서 껏을 때, 동작 차이 버그 수정. 모든 검색 내용을 삭제 후 팝업 오픈 2019-08-02 홍대표
	        	quick_add_close();
	        	
	        	$("#addpopup").modal();
	        }	        
	        
	        function search_start() {
	        	
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
	        
	        function clickImport() {
	        	if (useAnyoneEdit != "YES") {
	        		if (deptAdmin != "Y" && pFolderType == "D") {
		        		alert("<spring:message code='ezAddress.t1' />");
		                return;
		            }
		            else if (compAdmin != "Y" && pFolderType == "C") {
		            	alert("<spring:message code='ezAddress.t1' />");
		                return;
		            }
	        	}
	        	
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#importPopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	$("#importPopup").modal();
	        }
	        
			function clickExport() {
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#exportPopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	$("#exportPopup").modal();
	        }
	        
	        function crossexport() {
	        	var format = "";
	        	var formatRadio = document.getElementsByName('exportFormat');
				
	        	for (var i = 0; i < formatRadio.length; i++) {
	        		if (formatRadio[i].checked) {
	        			format = formatRadio[i].value;
						break;
					}
	        	}
	        	
	            var pURL = "/ezAddress/excelExport.do?folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType + "&ownerid=" + encodeURIComponent(pOwerID) + "&format=" + encodeURIComponent(format);
	            saveExcel.location.href = pURL;

	            setNodeText(document.getElementById("loadtxt"), "<spring:message code='ezAddress.t5001' />");
	            document.getElementById("loadingLayer").style.display = "";
	            document.getElementById("loadingLayer").style.top = (document.documentElement.clientHeight / 2) + "px";
	            document.getElementById("loadingLayer").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";

	            setTimeout("event_CrossExport()", 500);
	            SearchOptionHidden();
	        }	        
	        function event_CrossExport() {
            	document.getElementById("loadingLayer").style.display = "none";
	        }	        
	        function crossImport() {
	            document.getElementById("file1").click();
	        }	        
	        function btn_AttachAdd_onclick(actURL) {
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
				
	            setNodeText(document.getElementById("loadtxt"), "<spring:message code='ezAddress.t5000' />");
	            document.getElementById("loadingLayer").style.display = "";
	            document.getElementById("loadingLayer").style.top = (document.documentElement.clientHeight / 2) + "px";
	            document.getElementById("loadingLayer").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";
	            
	            var format = "";
	        	var formatRadio = document.getElementsByName('importFormat');
				
	        	for (var i = 0; i < formatRadio.length; i++) {
	        		if (formatRadio[i].checked) {
	        			format = formatRadio[i].value;
						break;
					}
	        	}
	        	 
		        SearchOptionHidden();
	        	var frm = document.getElementById('form');
		        var actionURL = (actURL !== undefined && actURL != "") ? actURL : "${useAddrDupliCheck.equals('YES') ? '/ezAddress/excelImportDuplicationCheck.do' : '/ezAddress/excelImport.do'}";
		        frm.action = actionURL + "?folderid=" + encodeURIComponent(pFolderID) + "&foldertype=" + pFolderType + "&ownerid=" + encodeURIComponent(pOwerID) + "&format=" + encodeURIComponent(format);
		        frm.submit();
	        }	 
	        
	        function UploadComplete(result) {
	        	document.form.file1.value = "";
		        document.getElementById("loadingLayer").style.display = "none";
		        
		        if (result == "OK") {
		        	alert("<spring:message code='ezAddress.t178' />");
		        } else if (result == "FORMAT_ERROR") {
		        	alert("<spring:message code='ezAddress.lhm1' />");
		        } else {
		        	alert("<spring:message code='ezAddress.t181' />");
		        }		        
		        window.location.reload();
		    }
	        
	        function quick_add_close(){
	        	var child = document.getElementById("addpopup_list").getElementsByTagName('td');
	        	var i;
	        	for (i = 0; i < child.length; i++) {
	        		child[i].childNodes[0].value = "";
	        	}
	        }
	        
	        // 주소록 title mapping 
	        function addressTitleMapping() {
	        	var addressTitle = parent.frames["left"].send_AddressTitle();
				document.getElementById("presentcell").innerHTML = addressTitle;
	        }
	        
	        $(document).on("change", "#addrTypeSelect", function() {
	        	pCurrentPage 	= 1;
	        	pAddrType 		= $(this).val();
	        	
	        	if (searchFlag) {
		        	Get_SearchAddressList();
	        	} else {
	        		Get_AddressList();
	        	}
	        });

			function duplicationCheckComplete(result, state, duplicateAddr) {
	        	if (result == "OK") {
		        	if (state == "OK") { // 주소록 중복이 없는 경우
		        		btn_AttachAdd_onclick("/ezAddress/excelImport.do");
					} else { // 주소록 중복이 있는 경우
						showDupliPopUp(duplicateAddr);
					}
		        } else {
		        	if (result == "FORMAT_ERROR") {
			        	alert("<spring:message code='ezAddress.lhm1' />");
			        } else {
			        	alert("<spring:message code='ezAddress.t181' />");
			        }		        
			        window.location.reload();
		        } 
	        }
			function showDupliPopUp(list) {
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	

	        	var jsonList = JSON.parse(list);
	        	
	        	var dupliPopUpTableBody = document.getElementsByClassName("dupliPopUpTableBody")[0].getElementsByTagName("tbody");
	        	for (var i=0; i<jsonList.length; i++){
	        		var oriList = jsonList[i].oriAddr;
	        		var newList = jsonList[i].newAddr;

		        	var ele_TR 		= document.createElement("TR");
		        	var ele_TD 		= document.createElement("TD");
		        	var ele_DIV 	= document.createElement("DIV");
		        	var ele_SPAN 	= document.createElement("SPAN");
	        		
		        	var oriDiv = ele_DIV.cloneNode();
			        	oriDiv.textContent 	= oriList.name;
		        	var oriSpan = ele_SPAN.cloneNode();
		        		oriSpan.textContent = oriList.email;
        			var oriTD = ele_TD.cloneNode();
	        			oriTD.appendChild(oriDiv);
	        			oriTD.appendChild(oriSpan);
	        			
		        	var newDiv 	= ele_DIV.cloneNode();
			        	newDiv.textContent 	= newList.name;
		        	var newSpan = ele_SPAN.cloneNode();
		        		newSpan.textContent = newList.email;
        			var newTD 	= ele_TD.cloneNode();
	        			newTD.appendChild(newDiv);
	        			newTD.appendChild(newSpan);

        			ele_TR.appendChild(oriTD);
        			ele_TR.appendChild(newTD);
        			
        			$(dupliPopUpTableBody).append(ele_TR);
	        	}

		        document.getElementById("loadingLayer").style.display = "none";
		        
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	$("#dupliPopUp").css("left", popupX);
	        	$("#dupliPopUp").modal();
	        	
	        	// scroll
	        	$("#dupliPopUp").css("opacity", 0);
	        	isDupliPopUpTableHeaderScroll(); 
	        	$("#dupliPopUp").css("opacity", 1);
	        	
	        }
        	function importAddressConfirm(confirm) {
        		if (confirm) {
        			btn_AttachAdd_onclick("/ezAddress/excelImport.do");    	            
        		} else {
        			document.form.file1.value = "";
        			var duplicateTable = document.querySelector('.dupliPopUpTableBody tbody');
        			
					while (duplicateTable.firstChild) {
						duplicateTable.removeChild(duplicateTable.firstChild);
					}        			
        			SearchOptionHidden();
        		}
        	}
        	function isDupliPopUpTableHeaderScroll() {
        		var forScroll = $("#dupliPopUpTableHeaderScroll"); 
        		
    			if ($(".dupliPopUpTableBodyDIV").height() < $(".dupliPopUpTableBodyDIV table").height()) {
    				forScroll.css("display", "");
    			} else {
    				forScroll.css("display", "none");
    			}
        	}

        </script>
    </head>
	<body class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);" style="overflow:hidden">
		<h1><span id="presentcell"></span><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
			    <li class="important"><span onClick="new_address()"><spring:message code='ezAddress.t236' /></span></li>
				<li class="important"><span onClick="new_group()"><spring:message code='ezAddress.t237' /></span></li>
				<li class="important"><span onclick="ShowQuickAddres();"><spring:message code='ezAddress.t2002' /></span></li>
				<li id="importaddress" style="display:none;"><span  onClick="address_inout(1)"><spring:message code='ezAddress.t210' /></span></li>
				<li id="exportaddress" style="display:none;"><span  onClick="address_inout(0)"><spring:message code='ezAddress.t143' /></span></li>
				<li id="importaddress_Cross"><span onclick="clickImport()"><spring:message code='ezAddress.t210' /></span></li>
        		<li id="exportaddress_Cross"><span onclick="clickExport()"><spring:message code='ezAddress.t143' /></span></li>
				<li><span onClick="move_address()"><spring:message code='ezAddress.t239' /></span></li>
				<li><span class="icon16 icon16_search" id="SearchOption" mode="off" onClick="doLayerPopup()"></span></li>
				<li onClick="delete_address()"><span class="icon16 icon16_delete"></span></li>
				<li onClick="window.location.reload(false)"><span class="icon16 icon16_refresh"></span></li>
				<li><span class="icon16 icon16_mail_gray" onClick="write_letter()"></span></li>
				<li style="background:none;">
					<select id="addrTypeSelect">
						<option value="ALL" selected><spring:message code='ezAddress.ksa07' /></option>
						<option value="GROUP"><spring:message code='ezAddress.ksa08' /></option>
						<option value="PERSONAL"><spring:message code='ezAddress.ksa09' /></option>
				    </select>
				</li>
				<li style="background:none;float:right">
					<select id="ListViewType" onchange="View_Change();">
						<option value="card" <c:if test="${pListType == 'card'}"> selected</c:if>><spring:message code='ezAddress.t2000' /></option>
						<option value="list" <c:if test="${pListType == 'list'}"> selected</c:if>><spring:message code='ezAddress.t2001' /></option>
				    </select>
				</li>
			</ul>
		</div>
			<ul class="address_wordmenu" id="address_wordmenu" style="margin-bottom:15px;">
				<c:if test="${userInfo.lang ne '3'}">
					<div id="address_wordmenu_div">
						<c:choose>
							<c:when test="${userInfo.lang eq '1'}">
								<li style="width:40px;"><span onClick="pFilterDB='';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()"><spring:message code='ezAddress.t243' /></span></li>
							</c:when>
							<c:when test="${userInfo.lang eq '3'}">
								<li style="width:68px;"><span onClick="pFilterDB='';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()"><spring:message code='ezAddress.t243' /></span></li>
							</c:when>
							<c:otherwise>
								<li style="width:40px;"><span onClick="pFilterDB='';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()"><spring:message code='ezAddress.t243' /></span></li>
							</c:otherwise>
						</c:choose>
						<c:if test="${userInfo.lang eq '1'}">
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
						</c:if>
						<c:if test="${userInfo.lang eq '3'}">
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
						</c:if>
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
								<li style="width:40px"><span onClick="pFilterDB='INDEX_KO,ETC';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">
									<spring:message code='ezAddress.t259' /></span>
								</li>
							</c:when>
							<c:when test="${userInfo.lang eq '3'}">
								<li style="width:40px"><span onClick="pFilterDB='INDEX_JA,ETC';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">
									<spring:message code='ezAddress.t259' /></span>
								</li>
							</c:when>
							<c:otherwise>
								<li style="width:40px"><span onClick="pFilterDB='INDEX_EN,ETC';pOrderOption='S_NAME:0';pCurrentPage='1';Get_AddressList()">
									<spring:message code='ezAddress.t259' /></span>
								</li>
							</c:otherwise>
						</c:choose>
					
					<%--개인주소록, 부서주소록 소팅 기능임 삭제 하지 마시오--%>
					<%--
					<li><span onClick="pFilter=&quot;KIND,IPM.Contact&quot;;pOrderOption='SNAME:0';pCurrentPage='1';Get_AddressList()">Person</span></li>
					<li><span onClick="pFilter=&quot;KIND,IPM.DistList&quot;;pOrderOption='SNAME:0';pCurrentPage='1';Get_AddressList()">Group</span></li>
					--%>
					</div>
				</c:if>
			</ul>
		<div style="vertical-align:top;border:0px solid red; white-space:nowrap; overflow-x:auto; overflow-y:hidden;" id="list_Layer">
			<div style="min-width:700px;">
				<table class="mainlist" id="DetailList_header" style="table-layout: fixed;width:100%; display: none;">
				    <tr>
						<th style="cursor:pointer;text-align:center;width:20px;">
					    	<input type="checkbox" id="HeaderAllCheckBox" onClick="event_HeaderCheckBoxClick(this)">
						</th>
						<th style="text-align:center;width:40px;vertical-align: middle;padding:0px"><img src="/images/i_individual.gif" border="0"></th>
						<th id="CompanyName" style="padding-left:5px; CURSOR:pointer;width:20%;white-space:nowrap;" _OrderOption="1" _OrderName="S_NAME" onClick="OderbyOptionExpression(this)" ><spring:message code='ezAddress.t124' /><span id="S_NAME"></span></th>
						<th id="PhoneNumber" style="CURSOR:pointer;width:20%;white-space:nowrap;padding:0px" _OrderOption="0" _OrderName="S_COMPANY" onClick="OderbyOptionExpression(this)" ><spring:message code='ezAddress.t51' /><span id="S_COMPANY"></span></th>
						<th id="width1" style="CURSOR:pointer;width:20%;white-space:nowrap;padding:0px" _OrderOption="0" _OrderName="S_COMPANY_PHONE" onClick="OderbyOptionExpression(this)" ><spring:message code='ezAddress.t263' /><span id="S_COMPANY_PHONE"></span></th>
						<th id="width2" style="CURSOR:pointer;width:20%;white-space:nowrap;padding:0px" _OrderOption="0" _OrderName="S_MOBILE" onClick="OderbyOptionExpression(this)" ><spring:message code='ezAddress.t189' /><span id="S_MOBILE"></span></th>
						<th style="CURSOR:pointer;width:20%;white-space:nowrap;padding:0px" _OrderOption="0" _OrderName="S_EMAIL" onClick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t264' /><span id="S_EMAIL"></span></th>
						<th id="FolderType" style="CURSOR:pointer;width:10%;white-space:nowrap;display:none;padding:0px" _OrderOption="0" _OrderName="S_TYPE" onClick="OderbyOptionExpression(this)"><spring:message code='ezAddress.t231' /><span id="S_TYPE"></span></th>
					</tr>
				</table>
			</div>
			<div id="contentlist" name="contentlist" style="min-width:700px;border:0px solid blue;height:350px;width:100%;overflow-y:auto;">
				<table class="mainlist" style="width: 100%; table-layout: fixed; display:none;" id="MailList" ></table>
				<div style="height:100%;display:none;" id="MailListCard" ></div>
			</div>
			
		</div>
		<div id="tblPageRayer"  style="width:600px; margin:6px auto;"></div>
		<div style="width:100%;height:100%;position:absolute;top:0px;left:0px;display:none;z-index:5000;" id="mailPanel" onclick="ShowQuickAddres();" >&nbsp;</div>
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
			<img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>		
		<div id="addpopup" class="popupwrap1" style="display:none;margin-bottom:60px;">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezAddress.t2002' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="quick_add_close()"></span></a></li>
		            </ul>
		        </div>
				<!-- 내용 -->
			    <table class="popuplist" id="addpopup_list" style="width:510px;margin:10px 0px 0px 1px;">
					<tr>
			  			<th style="width:90px;height:30px"><spring:message code='ezAddress.t124' /></th>
						<td><input type="text" id="qname" name="qname" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="24"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px"><spring:message code='ezAddress.t51' /></th>
						<td><input type="text" id="qcompany" name="qcompany" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="24"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px"><spring:message code='ezAddress.t222' /></th>
						<td><input type="text" id="qcomphone" name="qcomphone" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="20"></td>
					</tr>
					<tr>
						<th style="width:90px;height:30px"><spring:message code='ezAddress.t223' /></th>
						<td><input type="text" id="qmobile" name="qmobile" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="20"></td>
					</tr>
					<tr>
						<th style="height:30px"><spring:message code='ezAddress.t264' /></th>
						<td><input type="text" id="qemail" name="qemail" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="100"></td>
					</tr>
				</table>
				<!-- /내용 -->				
				<div class="btnpositionLayer">
					<a class="imgbtn"><span onclick="quick_add()" ><spring:message code='ezAddress.t173' /></span></a>
			    </div>
			</div>
		</div>
		<div id="srarchpopup" class="popupwrap1" style="display:none;margin-bottom:70px">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezAddress.t312' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="SearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content" style="margin-top:10px;">
					<tr>
						<th style="text-align:center;height:30px"><spring:message code='ezAddress.t314' /></th>
						<td style="text-align:left;height:30px">
							<input type="checkbox" name="chkType" id="CheckUser" /><span onclick="check_click('CheckUser')" style="cursor: pointer;"><spring:message code='ezAddress.t145' /></span><br/>
							<input type="checkbox" name="chkType" id="CheckDept" /><span onclick="check_click('CheckDept')" style="cursor: pointer;"><spring:message code='ezAddress.t146' /></span><br/>
							<input type="checkbox" name="chkType" id="CheckCompany" /><span onclick="check_click('CheckCompany')" style="cursor: pointer;"><spring:message code='ezAddress.t147' /></span>
						</td>
					</tr>
					<tr>
						<th style="text-align:center;height:30px">
							<select name="search_case" id="search_case">
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
						</th>
						<td style="text-align:left;height:30px">
							<input type="text" name="search_text" id="search_text" class="textarea" style="width:98%;margin-left:3px" onkeypress="return search_keypress()" >
						</td>
					</tr>
				</table>
				<br />
				<table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="search_start()"><spring:message code='ezAddress.t142' /></span></a>
							</div>								
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="importPopup" class="popupwrap1" style="display:none;margin-bottom:70px;vertical-align:middle">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezAddress.t309' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="SearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content" style="width:100%;margin-top:10px;">
					<tr>
						<td style="width:70%;border-right-width:0px;">
							<input type="radio" name="importFormat" id="importOutlookCSV" checked="checked" value="outlookCSV" />
							<label for="importOutlookCSV" style="vertical-align:middle;cursor:pointer;">MS Outlook 2013/2016 CSV</label>
						</td>
						<td style="width:30%;text-align:right;border-left-width:0px;">
							<a class="imgbtn imgbck" href="/ezAddress/addressFormatDownload.do?format=outlookCSV"><span><spring:message code='ezAddress.lhm2' /></span></a>
						</td>
					</tr>
					<!-- 
					<tr>
						<td style="width:70%;border-right-width:0px;">
							<input type="radio" name="importFormat" id="importThunderbirdCSV" checked="checked" value="thunderbirdCSV" />
							<label for="importThunderbirdCSV" style="vertical-align:middle;cursor:pointer;">Mozilla Thunderbird CSV</label>
						</td>
						<td style="width:30%;text-align:center;border-left-width:0px;">
							<a class="imgbtn" href="/ezAddress/addressFormatDownload.do?format=thunderbirdCSV"><span><spring:message code='ezAddress.lhm2' /></span></a>
						</td>
					</tr>
					<tr>
						<td style="width:70%;border-right-width:0px;">
							<input type="radio" name="importFormat" id="importGoogleCSV" checked="checked" value="googleCSV" />
							<label for="importGoogleCSV" style="vertical-align:middle;cursor:pointer;">Google CSV</label>
						</td>
						<td style="width:30%;text-align:center;border-left-width:0px;">
							<a class="imgbtn" href="/ezAddress/addressFormatDownload.do?format=googleCSV"><span><spring:message code='ezAddress.lhm2' /></span></a>
						</td>
					</tr>
					-->
				</table>
				<br />
				<table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="crossImport()"><spring:message code='ezEmail.t37' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="exportPopup" class="popupwrap1" style="display:none;margin-bottom:70px;vertical-align:middle">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezAddress.t31' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="SearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content" style="width:100%;margin-top:10px;">
					<tr>
						<td>
							<input type="radio" name="exportFormat" id="exportOutlookCSV" checked="checked" value="outlookCSV" />
							<label for="exportOutlookCSV" style="vertical-align:middle;cursor:pointer;">MS Outlook 2013/2016 CSV</label>
						</td>
					</tr>
					<!-- 
					<tr>
						<td>
							<input type="radio" name="exportFormat" id="exportThunderbirdCSV" checked="checked" value="thunderbirdCSV" />
							<label for="exportThunderbirdCSV" style="vertical-align:middle;cursor:pointer;">Mozilla Thunderbird CSV</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="exportFormat" id="exportGoogleCSV" checked="checked" value="googleCSV" />
							<label for="exportGoogleCSV" style="vertical-align:middle;cursor:pointer;">Google CSV</label>
						</td>
					</tr>
					 -->
				</table>
				<br />
				<table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="crossexport()"><spring:message code='ezAddress.t25' /></span></a>								
							</div>	
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="dupliPopUp" class="popupwrap1" style="display:none;margin-bottom:70px">
			<div class="popupJQLayer" style="width: 600px;">
				
				<div style="position: relative;">
					<div class="title"><spring:message code='ezAddress.ksa01' /></div>
					<div id="close" style="top: 3px; right: 0; ">
			            <ul>
			                <li><a rel="modal:close"><span onclick="importAddressConfirm()"></span></a></li>
			            </ul>
			        </div>
		        </div>
		        
		        <div><spring:message code='ezAddress.ksa02' /></div>
				<table class="content2 dupliPopUpTable dupliPopUpTableHeader" style="margin-top:10px;width: 100%;">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
						<col width="1" />
					</colgroup>
					<tr>
						<th><spring:message code='ezAddress.ksa03' /></th>
						<th style="border-right: 0;"><spring:message code='ezAddress.ksa04' /></th>
						<th width="1" id="dupliPopUpTableHeaderScroll" style="display:none">&nbsp;</th>
					</tr>
				</table>
				<div class="dupliPopUpTableBodyDIV">
					<table class="content2 dupliPopUpTable dupliPopUpTableBody">
						<colgroup>
							<col width="50%" />
							<col width="50%" />
						</colgroup>
						<tbody></tbody>
					</table>
				</div>
				
				<br />
				<table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="importAddressConfirm(true)"><spring:message code='ezAddress.ksa05' /></span></a>
								<a class="imgbtn"><span onClick="importAddressConfirm(false)"><spring:message code='ezAddress.ksa06' /></span></a>
							</div>								
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="shadow"></div>		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
	    <span class="loading_layer" style="z-index:6000;position:absolute;top:400px;left:300px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><span id="loadtxt"><spring:message code='ezAddress.t5000' /></span></span></span>
	    <iframe id=saveExcel name=saveExcel style="display:none"></iframe>
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="" target="ifrm">
	        <input type="file" name="file1" id="file1" accept=".csv" onchange="btn_AttachAdd_onclick()" style="display: none"/>
	    </form>
	</body>
</html>
