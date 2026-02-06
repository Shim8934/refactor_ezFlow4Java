var m_bPrevNext = false;
var real_href = "";
var minimumWidth = 1200;

function get_mail(flag) {
    var Flag;

    if (null != opener) {
        m_bPrevNext = true;
    }
    if (m_bPrevNext) {

        try {
            if (flag == "prev") {
                var Rtn = opener.PopUpPreMail();
                if (Rtn == "PREEND") {
                    alert(strLang184);
                }
                else if (Rtn == "PREMOVE") {
                    alert(strLang305);
                    window.close();
                }
                else {
                    window.close();
//                    opener.ReadMailOpenNewWin.focus();
                }
            }
            else {
                var Rtn = opener.PopUpNextMail();
                if (Rtn == "NEXTEND") {
                    alert(strLang185);
                }
                else if (Rtn == "NEXTMOVE") {
                    alert(strLang306);
                    window.close();
                }
                else {
                    window.close();
//                    opener.ReadMailOpenNewWin.focus();
                }
            }
        }
        catch (e) {
            if (flag == "prev") {
                alert(strLang184);
            } else if(flag == "next"){
                alert(strLang185);
            } else{
                alert(e.description);
            }
            self.close();
        }
        m_bPrevNext = false;
    }

}
function ReSend(pURL, pEmail) {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - minimumWidth) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
    
    var requestUrl = "/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURIComponent(pEmail);
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}
    
    window.open(requestUrl, "", feature);
    /*if (CrossYN() || pNoneActiveX == "YES") {
        window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + pEmail, "", feature);
    }
    else {
        if (pUse_Editor == "")
            window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + pEmail, "", feature);
        else
            window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + pEmail, "", feature);
    }*/
}
document.querySelectorAll(".ical_btn_container").forEach(container => {
    container.addEventListener("click", function (e) {
        const btn = e.target.closest("button");
        if (!btn) return;
        const status = e.target.dataset.status;
        const uid = document.getElementById("ical_uid").value;
        const subject = document.querySelector(".gw_ical_summary").textContent.trim();
        const period = document.querySelector('.ical-period');
        const isAllDay = period.dataset.isAllDay == "true";
        const start = period.dataset.start;
        const end = period.dataset.end;
        const location = document.getElementById("ical_location").textContent;

        fetch("/ezEmail/sendIcalResponseMail.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                uid: uid,
                organizerCn: fromAddr,
                summaryStr: subject,
                dtAllDay: isAllDay,
                startDtStr: start,
                endDtStr: end,
                status: status,
                locationStr: location,
                uidStr: g_paramURL
            })
        }).then(res => {
            if (res.ok) {
                alert(strLangIcal01);
            } else {
                alert(strLangIcal02);
            }
            window.top.close();
        }).catch(error => {
            alert(strLangIcal02);
            window.top.close();
        });
    });
});

// 2024.05.24 한슬기 : 수신인 이름을 사용하기위해 오버로딩
function ReSend(pURL, pEmail, pReader) {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - minimumWidth) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
    
    var requestUrl = "/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURIComponent(pEmail) + "&reciverName=" + encodeURIComponent(pReader);
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}

    window.open(requestUrl, "", feature);
    
}

function encoding_mail() {
    try {
        var infolder = "/exchange/" + CutBeforeText(g_paramURL, "/exchange/");
        var strQuery = "<DATA><URL>" + infolder + "</URL><AUTHOR>" + g_author + "</AUTHOR></DATA>"

        var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
        xmlHTTP.open("POST", "remote/mail_interencode.aspx", false);
        xmlHTTP.setRequestHeader("content-type:", "text/xml");
        xmlHTTP.send(strQuery);

        var strRetUrl = xmlHTTP.responseXML.text;
        xmlHTTP = null;

        if (strRetUrl != "") {
            try {
                window.opener.MailListRefresh();
            }
            catch (e) {console.log(e);}

            if (strRetUrl.substr(0, 5) != "ERROR") {
                document.location.href = "/myoffice/ezEmail/mail_read.aspx?URL=" + encodeURIComponent(strRetUrl);
            }
        }
    }
    catch (e) {console.log(e);}
}

function reply_onClick() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - minimumWidth) / 2;
    
    var requestUrl = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(g_paramURL) + "&cmd=REPLY";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}
	if (typeof(sharer) != "undefined" && sharer != "") {
		requestUrl += "&sharer=" + encodeURIComponent(sharer);
	}
    
    window.location.href = requestUrl;
}

function allreply_onClick() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - minimumWidth) / 2;
    
    var requestUrl = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(g_paramURL) + "&cmd=REPLYALL";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}
	
	if (typeof(sharer) != "undefined" && sharer != "") {
		requestUrl += "&sharer=" + encodeURIComponent(sharer);
	}
	
    window.location.href = requestUrl;
}

function pass_onClick() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - minimumWidth) / 2;
    
    var requestUrl = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(g_paramURL) + "&cmd=FORWARD";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}
	
	if (typeof(sharer) != "undefined" && sharer != "") {
		requestUrl += "&sharer=" + encodeURIComponent(sharer);
	}
    
    window.location.href = requestUrl;
}
var mail_movecopy_cross_dialogArguments = new Array();
function move_onClick() {
    mail_movecopy_cross_dialogArguments[1] = move_onclick_Complete;
    mail_movecopy_cross_dialogArguments[2] = DivPopUpHiddenReadMail;
    
    var requestUrl = "/ezEmail/mailMoveCopy.do";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	}
    
    DivPopUpShow(320, 375, requestUrl);
}
function move_onclick_Complete(moveUrl) {
    DivPopUpHiddenReadMail();
    if (typeof (moveUrl) == "undefined")
        return;

    var szOrgURL = g_paramURL;

    if (moveUrl["cmd"] == "MOVE") {
    	if (isSecureMail == "true") {
    		if (!confirm(strLangLHM20)) {
    			return;
    		}
    	}
    	
    	CopyOrMoveMail(moveUrl["cmd"], g_paramURL, moveUrl["url"]);
    }
    else if (moveUrl["cmd"] == "COPY") {
    	CopyOrMoveMail(moveUrl["cmd"], g_paramURL, moveUrl["url"]);
    } else if (moveUrl["cmd"] === "KEEP_MOVE") {
        keepMove(g_paramURL, moveUrl["url"]);
    }
    
    usedMoveDel = "1";
}

function DivPopUpHiddenReadMail() {
	document.getElementById("iFramePanel").style.display = "none";
	document.getElementById("mailPanel").style.display = "none";
	document.getElementById("loadingLayer").style.display = "none";
}

var g_deleteHttp = null;
function delete_mail_2010(cmd, copyFolderID) {
    try {
        g_deleteHttp = createXMLHttpRequest();
        var xmlDOM = createXmlDom();

        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "CMD", cmd);
        createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", g_paramURL);
        createNodeAndInsertText(xmlDOM, objNode, "FOLDERID", copyFolderID);

        objRoot.appendChild(objNode3);

        g_deleteHttp.open("POST", "/myoffice/ezEmail/remote/mail_movecopy.aspx", true);
        g_deleteHttp.onreadystatechange = event_deletemail_end;
        g_deleteHttp.send(xmlDOM);

    }
    catch (e) {
        g_deleteHttp = null;
        if (cmd == "COPY")
            alert(strLang52);
        else if (cmd == "MOVE")
            alert(strLang5);
        else if (cmd == "BDELETE" || cmd == "BMOVE")
            alert(strLang6);
    }

}
function delete_mail() {
	if (isSecureMail == "true") {
		if (!confirm(strLangLHM19)) {
			return;
		}
	} else {
		if (!confirm(strLang59)) {
			return;
		}
	}

    if (g_deleteHttp != null)
        return;
    try {

        g_deleteHttp = createXMLHttpRequest();
        var xmlDOM = createXmlDom();

        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "CMD", pisDelete);
        createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", g_paramURL);
        createNodeAndInsertText(xmlDOM, objNode, "FOLDERID", "");
        
        var url = "/ezEmail/mailDelete.do?cmd=" + pisDelete;
        
        if (typeof(shareId) != "undefined" && shareId != "") {
    		url += "&shareId=" + encodeURIComponent(shareId);
    	}
        
        g_deleteHttp.open("POST", url, true);
        g_deleteHttp.onreadystatechange = event_deletemail_end;
        g_deleteHttp.send(xmlDOM);

    }
    catch (e) {
        console.log(e);
    }


}

function event_deletemail() {
    if (g_deleteHttp != null && g_deleteHttp.readyState == 4) {
        if (g_deleteHttp.status < 200 || g_deleteHttp.status > 300) {
            g_deleteHttp = null;
            alert(strLang131);
        }
        else {
            try {
                var DestURL = g_deleteHttp.responseXML.getElementsByTagName("d:deleteditems").item(0).text
                var paramURL = CutBeforeText(g_paramURL, g_userID);
                paramURL = CutAfterText(paramURL, "/");

                g_deleteHttp = null;
                g_deleteHttp = new ActiveXObject("Microsoft.XMLHttp");

                if (paramURL == CutBeforeText(DestURL, g_userID)) {
                    g_deleteHttp.open("DELETE", g_paramURL, true);
                    g_deleteHttp.setRequestHeader("Content-Length:", "0");
                    g_deleteHttp.onreadystatechange = event_deletemail_end;
                    g_deleteHttp.send("");
                }
                else {
                    g_deleteHttp.open("MOVE", g_paramURL, true);
                    g_deleteHttp.setRequestHeader("Destination", DestURL + "/delete.eml");
                    g_deleteHttp.setRequestHeader("Content-Length:", "0");
                    g_deleteHttp.setRequestHeader("Translate:", "f");
                    g_deleteHttp.setRequestHeader("allow-rename:", "t");
                    g_deleteHttp.setRequestHeader("Overwrite:", "f");
                    g_deleteHttp.onreadystatechange = event_deletemail_end;
                    g_deleteHttp.send("");
                }
            }
            catch (e) {
                g_deleteHttp = null;
                alert(strLang131);
            }
        }
    }
}

function event_deletemail_end() {
    if (g_deleteHttp != null && g_deleteHttp.readyState == 4) {
        if (g_deleteHttp.status < 200 || g_deleteHttp.status > 300) {
            g_deleteHttp = null;
            alert(strLang131);
        }
        else {
            g_deleteHttp = null;
            window.close();
            try {
                window.opener.MailListRefresh();
            } catch (e) {console.log(e);}
        }

    }
}

var g_copyItemHttp = null;
function CopyOrMoveMail(cmd, itemIDs, copyFolderID) {
    if (g_copyItemHttp != null)
        return;

    try {

        g_copyItemHttp = createXMLHttpRequest();

        var xmlDOM = createXmlDom();

        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "CMD", cmd);
        createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", itemIDs);
        createNodeAndInsertText(xmlDOM, objNode, "FOLDERID", copyFolderID);

        var requestUrl = "/ezEmail/mailMoveCopyMessage.do";
        
    	if (typeof(shareId) != "undefined" && shareId != "") {
    		requestUrl += "?shareId=" + encodeURIComponent(shareId);
    	}
        
        g_copyItemHttp.open("POST", requestUrl, true);
        event_CopyOrMoveMail.cmd = cmd;
        g_copyItemHttp.onreadystatechange = event_CopyOrMoveMail;
        g_copyItemHttp.send(xmlDOM);

    }
    catch (e) {
        g_copyItemHttp = null;
        if (cmd == "COPY")
            alert(strLang52);
        else if (cmd == "MOVE")
            alert(strLang5);
        else if (cmd == "BDELETE")
            alert(strLang6);
    }
}


function event_CopyOrMoveMail() {
    if (g_copyItemHttp != null && g_copyItemHttp.readyState == 4) {
        if (g_copyItemHttp.status < 200 && g_copyItemHttp.status > 300) {
            if (event_CopyOrMoveMail.cmd == "MOVE")
                alert(strLang132);
            else {
                if (g_copyItemHttp.responseText == "FULL") {
                    alert(strLang241);
                }
                else {
                    alert(strLang52);
                }
            }
            g_copyItemHttp = null;
        }
        else {
            if (event_CopyOrMoveMail.cmd == "MOVE") {
                alert(strLangLHM06);
                window.close();
                try {
                    window.opener.MailListRefresh();
                } catch (e) {console.log(e);}
            }
            else {
                if (g_copyItemHttp.responseText == "FULL") {
                    alert(strLang241);
                }
                else {
                    alert(strLang53);
                }
            }
            g_copyItemHttp = null;
        }
    }
}

var mailKeepMoveDialogArguments = {};
function keepMove(itemIDs, copyFolderID) {
    if (copyFolderID === "Sent") {
        alert(strLangKeepMoveCantUseSentBox);
        return;
    }

    mailKeepMoveDialogArguments.okHandler = keepMoveOkHandler;
    mailKeepMoveDialogArguments.cancelHandler = function () {
        DivPopUpHiddenReadMail();
        document.getElementById("iFrameLayer").src = "about:blank";
    };
    mailKeepMoveDialogArguments.mailUids = itemIDs;
    mailKeepMoveDialogArguments.targetFolderId = copyFolderID;
    let url = '/ezEmail/mailKeepMove.do?folderId=' + encodeURIComponent(copyFolderID);

    if (shareId) {
        url += '&shareId=' + encodeURIComponent(shareId);
    }

    DivPopUpHiddenReadMail();
    document.getElementById("iFrameLayer").src = "about:blank";
    setTimeout(function() {
        DivPopUpShow(450, 220, url);
    }, 0);
}

function keepMoveOkHandler(/** @type boolean*/cleanup) {
    $.ajax({
        method: 'post',
        url: '/ezEmail/mailKeepMove.do',
        data: {
            mailUids: mailKeepMoveDialogArguments.mailUids.split(','),
            targetFolderPath: mailKeepMoveDialogArguments.targetFolderId,
            cleanup,
            shareId
        },
        success: function (result) {
            if (result.status === 'ok') {
                opener.startKeepMoveTimer(result.data);
                window.close();
            } else {
                alert(strLang321 + '\n' + Date.now());
            }
        },
        error: function() {
            alert(strLang321 + '\n' + Date.now());
        }
    });
}

function download_mail() {
    fileName = mailSubject.innerText;
    fileName = ReplaceText(fileName, "\\\\", "");
    fileName = ReplaceText(fileName, "/", "");
    fileName = ReplaceText(fileName, ":", "_");
    fileName = ReplaceText(fileName, "\\*", "");
    fileName = ReplaceText(fileName, "\\?", "");
    fileName = ReplaceText(fileName, "\"", "");
    fileName = ReplaceText(fileName, "<", "");
    fileName = ReplaceText(fileName, ">", "");
    fileName = ReplaceText(fileName, "\\|", "");
    fileName = ReplaceText(fileName, "\\.", "");

    if (fileName.length > 30)
        fileName = fileName.substr(0, 30);

    fileName = fileName + ".eml";

    if (ReplaceText(fileName, " ", "") == ".eml") fileName = "untitled.eml"
    if (!CrossYN() && pNoneActiveX != "YES") {
        var ezUtil_regData = new ActiveXObject("ezUtil.RegScript");
        var regData = ezUtil_regData.ReadValueEx(2, "SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage", "OEMCP");
        ezUtil_regData = null;

        form1.iptURL.value = g_paramURL;
        var newwin = window.open("", "download", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
        form1.action = "remote/mail_readattach.aspx?filename=" + encodeURIComponent(fileName) + "&regData=" + regData;
        form1.target = "download";
        form1.submit();
    }
    else {
        var regData = navigator.systemLanguage
        form1.iptURL.value = g_paramURL;
        form1.action = "remote/mail_readattach.aspx?filename=" + encodeURIComponent(fileName) + "&regData=" + regData;
        form1.target = "_self";
        form1.submit();
    }
}

var address_selectAddress_dialogArguments = new Array();
function func_addaddr() {
	address_selectAddress_dialogArguments[1] = func_addaddr2;
	address_selectAddress_dialogArguments[2] = [];
	
	var url = "/ezEmail/mailSelectAddress.do?url=" + encodeURIComponent(g_paramURL);
	
	if (typeof(shareId) != "undefined" && shareId != "") {
		url += "&shareId=" + encodeURIComponent(shareId);
	}
	
	if (typeof(sharer) != "undefined" && sharer != "") {
		url += "&sharer=" + encodeURIComponent(sharer);
	}
	
	DivPopUpShow(600, 500, url);
}

var address_foldermanage_dialogArguments = new Array();
function func_addaddr2(result) {
	DivPopUpHiddenReadMail();
	
	if (result) {
		address_foldermanage_dialogArguments[1] = func_addaddr_Complete;
		DivPopUpShow(450, 500, "/ezAddress/addressFolderManage.do?mode=Show");
	}
}

function func_addaddr_Complete(ret) {
	DivPopUpHiddenReadMail();

	if (ret == 0 || ret == 1) {
        return;
    }
	
    var xmlHTTP = createXMLHttpRequest();

    try {
    	var addressList = address_selectAddress_dialogArguments[2];
    	var type = ret.split(':')[0];
        var folderId = ret.split(':')[1];
        
    	var objNode, objRow;
    	var xmlDom;
    	var name, email;
    	var duplicateList = [];
    	
    	for (i = 0; i < addressList.length; i++) {
    		name = addressList[i]["name"];
    		email = addressList[i]["email"];
            
    		// 주소록에 추가시 중복체크
        	var AddressCnt = Get_DupliCateAddressCnt(email, folderId, type);
        	
        	if (parseInt(AddressCnt) > 0) {
        		duplicateList.push(addressList[i]);
        		continue;
        	}
    		
            xmlDom = createXmlDom();
            
            objNode = createNodeInsert(xmlDom, objNode, "DATA");
            createNodeAndInsertText(xmlDom, objNode, "FOLDERID", folderId);
            createNodeAndInsertText(xmlDom, objNode, "TYPE", type);
            createNodeAndInsertText(xmlDom, objNode, "OWNERID", "");
            createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", "");
            createNodeAndInsertText(xmlDom, objNode, "CHANGEKEY", "");
            createNodeAndInsertText(xmlDom, objNode, "PHOTOPATH", "");
            createNodeAndInsertText(xmlDom, objNode, "SNAME", name);
            createNodeAndInsertText(xmlDom, objNode, "SCOMPANY", "");
            createNodeAndInsertText(xmlDom, objNode, "SDEPT", "");
            createNodeAndInsertText(xmlDom, objNode, "STITLE", "");
            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYPHONE", "");
            createNodeAndInsertText(xmlDom, objNode, "SMOBILE", "");
            createNodeAndInsertText(xmlDom, objNode, "SFAX", "");
            createNodeAndInsertText(xmlDom, objNode, "SEMAIL", email);
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
                	alert(strLang133 + xmlHTTP.status);
                	return;
                }
                
                if (xmlHTTP.responseText == "NO_AUTHORITY_D") {
                	alert(strLangLHJ01);
                	return;
                } else if (xmlHTTP.responseText == "NO_AUTHORITY_C") {
                	alert(strLangLHJ02);
                	return;
                } else {
                	alert(strLang135);
                	return;
                }
            }
    	}
    	
    	// duplicateList 동일한 메일주소
    	
    	if (duplicateList.length > 0) {
    		var alertMsg = strLangKSA01;
    		var dupliNameTxt = [];
    		
    		$.each(duplicateList, function(i, e) {
    			dupliNameTxt.push(e.name);
			});
    		
    		alertMsg = alertMsg.replace("%s", dupliNameTxt.join(","));
    		
    		alert(alertMsg);
    	} else {
    		alert(strLang136);
    	}
    } catch (e) {
        xmlHTTP = null;
        alert(strLang133 + e.message);
        return;
    }
    
    xmlHTTP = null;
}

function Get_DupliCateAddressCnt(senderEmail, folderId, type) {
	var xmlHTTP = createXMLHttpRequest();

	try {
		var returnValue = "";
		var xmlDom = createXmlDom();
		var objNode;
		
		createNodeInsert(xmlDom, objNode, "DATA");
		createNodeAndInsertText(xmlDom, objNode, "IDLIST", "");
		createNodeAndInsertText(xmlDom, objNode, "FILTER", senderEmail);
		createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", type);
		createNodeAndInsertText(xmlDom, objNode, "FOLDERID", folderId);
		
		xmlHTTP.open("POST", "/ezAddress/addressGetSearchCnt.do", false);
		xmlHTTP.send(xmlDom);
		
		if (xmlHTTP.status != 200){
			alert(strLang133 + xmlHTTP.status);
		} else {
			returnValue = xmlHTTP.responseText;
		}
		
	} catch (e){
		xmlHTTP = null;
        alert(strLang133 + e.description);
        return;
	}
 
	xmlHTTP = null;
	
    return returnValue;
}

var denial_cross_dialogArguments = new Array();
function func_reject() {
    if (g_fromEmail == "" && g_rejectWord == "") {
        alert(strLang137);
        return;
    }
    var params = new Array();
    params["email"] = new Array();
    params["link"] = new Array();
    var labelFromName = document.getElementById('LabelFromName').textContent;
    params["email"][0] = quoteEmailName(labelFromName, g_fromEmail);
    params["link"][0] = g_rejectWord;

    denial_cross_dialogArguments[0] = params;
    denial_cross_dialogArguments[1] = func_reject_Complete;
    DivPopUpShow(450, 314, "/ezEmail/mailDenial.do");
}
function func_reject_Complete(retVal) {
	var result = "";
	
    try {
        DivPopUpHidden();
        if (typeof (retVal) == "string") {
            if (retVal == "cancel")
                completeListener();
                return;
        }
        var objXml = new DOMParser().parseFromString('<DATA></DATA>', "text/xml");
        var objRoot = objXml.documentElement;

        if (typeof(shareId) != "undefined" && shareId != "") {
        	var objRow = objXml.createElement("ROW");
            objRoot.appendChild(objRow);
            
            var objNode = objXml.createElement("SHAREID");
            objNode.appendChild(objXml.createCDATASection(shareId));
            objRow.appendChild(objNode);
       }

        for (var i = 0 ; i < retVal.length ; i++) {
            var objRow = objXml.createElement("ROW");
            objRoot.appendChild(objRow);

            var objNode = objXml.createElement("DENIAL");
            objNode.appendChild(objXml.createCDATASection(retVal[i]));
            objRow.appendChild(objNode);
        }

        var xmlHTTP = new XMLHttpRequest();

        xmlHTTP.open("POST", "/ezEmail/mailRequestDenial.do", false);
        xmlHTTP.setRequestHeader("Content-Type", "text/xml");
        xmlHTTP.send(objXml);
        var result = xmlHTTP.responseText;

        result = replaceAll(result, "<DATA><![CDATA[", "");
        result = replaceAll(result, "]]></DATA>", "");
        
        xmlHTTP = null;

        completeListener();
    } catch (e) {console.log(e);}
    
    return result;
}

function completeListener() {
	document.getElementById("mailPanel").style.display = "none";
	document.getElementById("loadingLayer").style.display = "none";
}

function replaceAll(pStrContent, pStrOrg, pStrRep) {
    return pStrContent.split(pStrOrg).join(pStrRep);
}
function write_mail(userinfo) {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 1200) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1";

    if (pUse_Editor == "")
        window.open('mail_write_Cross.aspx' + "?MsgTo=" + userinfo + '&cmd=NEW', "", feature);
    else
        window.open('mail_write_Cross.aspx' + "?MsgTo=" + userinfo + '&cmd=NEW', "", feature);

    window.close();
}
function receiveCheck_onClick() {
	var requestUrl = "/ezEmail/mailReaderList.do?url=" + encodeURIComponent(g_paramURL);
    
    if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}
	
    var OpenWin = window.open(requestUrl, "mail_readerlist", GetOpenWindowfeature(650, 500));
    try { OpenWin.focus(); } catch (e) {console.log(e);}
}
function view_original() {
	var url = "/ezEmail/mailReadOriginal.do?url=" + encodeURIComponent(g_paramURL);
	
	if (typeof(shareId) != "undefined" && shareId != "") {
		url += "&shareId=" + encodeURIComponent(shareId);
	}
	if (typeof(sharer) != "undefined" && sharer != "") {
		url += "&sharer=" + encodeURIComponent(sharer);
	}
	
	MM_openBrWindow(url, 850, 650);
}
function MM_openBrWindow(url, w, h) {
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - h) / 2;
    var pLeft = (pwidth - w) / 2;

    var opwin = window.open(url, "oWin"
      , "width=" + w + ",height=" + h + ",status=no,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,top=" + pTop + ",left = " + pLeft);
}


var flagXmlHttp;
function toggle_flag() {
    var now = new Date();
    now.setDate(now.getDate() + 1);

    var month = parseInt(now.getMonth()) + 1;
    var pSDate = now.getFullYear() + "-" + month + "-" + now.getDate();
    var pEDate = pSDate;


    flagXmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();


    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "ITEMID", g_paramURL);
    createNodeAndInsertText(xmlDom, objNode, "STARTDATE", pSDate);
    createNodeAndInsertText(xmlDom, objNode, "ENDDATE", pEDate);

    var url = "/ezEmail/mailSetFlag.do";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		url += "?shareId=" + encodeURIComponent(shareId);
	}
	
	if (typeof(sharer) != "undefined" && sharer != "") {
		url += "?sharer=" + encodeURIComponent(sharer);
	}
    
    try {
        flagXmlHttp.open("POST", url, true);
        flagXmlHttp.onreadystatechange = event_toggle_flag_end;
        flagXmlHttp.send(xmlDom);
    }
    catch (e) {console.log(e);}
}
function event_toggle_flag_end() {
    if (flagXmlHttp != null && flagXmlHttp.readyState == 4) {
        if (flagXmlHttp.status < 200 || flagXmlHttp.status > 300) {
            flagXmlHttp = null;
            alert("ERROR");
        }
        else {
            if (flagXmlHttp.responseText == "NEW")
                alert(strLang139);
            else if (flagXmlHttp.responseText == "DEL")
                alert(strLang140);
            else
                alert("ERROR");

            window.opener.MailListRefresh();
        }
    }
}
function show_senderprofile() {
    if (g_notiSSO == "1")
        return;

    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 450);
    window.open("/ezCommon/showPersonInfo.do?email=" + g_fromEmail, "", feature);
}
function show_personinfo(email) {
    if (g_notiSSO == "1")
        return;

    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 450);
    window.open("/ezCommon/showPersonInfo.do?email=" + encodeURIComponent(email), "", feature);
}
function attach_SelectAll() {
    if (CrossYN()) {
        var checks = attachedfileDIV.getElementsByTagName("input");
        for (var i = 0; i < checks.length; i++)
            checks.item(i).checked = true;
    }
    else {
        var checks = attachedfileDIV.all.tags("input");
        for (var i = 0; i < checks.length; i++)
            checks.item(i).checked = true;
    }
}
function attach_Download() {
    var param = { "href": new Array(), "filesize": new Array(), "name": new Array(), "folderpath": new String() };
    var count = 0;
    var checks;

    if (CrossYN()) {
        checks = attachedfileDIV.getElementsByTagName("input");

        for (var i = 0; i < checks.length; i++) {
            if (checks.item(i).checked == true) {
                param["href"][count] = GetAttribute(checks.item(i), "filehref");
                param["filesize"][count] = GetAttribute(checks.item(i), "filesize");
                param["name"][count] = GetAttribute(checks.item(i), "filename");
                count++;
            }
        }
    }
    else {
        checks = attachedfileDIV.all.tags("input");

        for (var i = 0; i < checks.length; i++) {
            if (checks.item(i).checked == true) {
                param["href"][count] = checks.item(i).filehref;
                param["filesize"][count] = checks.item(i).filesize;
                param["name"][count] = checks.item(i).filename;
                count++;
            }
        }
    }


    if (count == 0) {
        alert(strLang141);
        return;
    }

    downloadAll(checks);


}
var suffix = 0;
function downloadAll(checks) {
    if (checks.item(suffix)) {
        if (checks.item(suffix).checked) {

            location.href = GetAttribute(checks.item(suffix++), "filehref");
            setTimeout(function () { downloadAll(checks) }, 1000);
        }
        else {
            suffix++;
            downloadAll(checks);
        }
    }
    else
        suffix = 0;
}
function attach_Delete() {
    var count = 0;
    var param = new Array();

    var xml = "<FILE>";

    if (CrossYN()) {
        var checks = attachedfileDIV.getElementsByTagName("input");

        for (var i = 0; i < checks.length; i++) {
            if (checks.item(i).checked == true) {
                xml += "<ROW>";
                xml += "<NAME><![CDATA[" + GetAttribute(checks.item(i), "fileid") + "]]></NAME>";
                xml += "</ROW>";
                param[count] = i;
                count++;

            }
        }
    }
    else {
        var checks = attachedfileDIV.all.tags("input");

        for (var i = 0; i < checks.length; i++) {
            if (checks.item(i).checked == true) {
                xml += "<ROW>";
                xml += "<NAME><![CDATA[" + checks.item(i).fileid + "]]></NAME>";
                xml += "</ROW>";
                param[count] = i;
                count++;

            }
        }
    }

    if (count == 0) {
        alert(strLang90);
        return;
    }

    xml += "<ITEMID><![CDATA[" + g_paramURL + "]]></ITEMID></FILE>";

    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezEmail/remote/mail_del_interattach.aspx", false);
    xmlhttp.send(xml);

    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        var oRoot = xmlhttp.responseXML.documentElement;
        var ret = oRoot.childNodes[0].nodeValue;

        if (ret != "FAIL") {
            g_paramURL = ret;
            for (i = 0; i < count; i++) {
                var delindex = param[i] - i;
                checks.item(delindex).parentElement.outerHTML = "";
                if (checks.item(delindex) != null && typeof (checks.item(delindex).parentElement) != "undefined") {
                    if (typeof (checks.item(delindex).parentElement.parentElement) != "undefined") {
                        if (checks.item(delindex).parentElement.parentElement.childNodes[delindex].nodeName == "BR") {
                            checks.item(delindex).parentElement.parentElement.childNodes[delindex].outerHTML = "";
                        }
                    }
                }
            }
        }
        else {
            alert(strLang183);
        }
    }
}

var g_xmlHttp;

// 메일 회수 선택
function cancel_send() {
   
    if (!confirm(strLang143))
        return;

    var xmlDom = createXmlDom();
    g_xmlHttp = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", g_paramURL);

    g_xmlHttp.open("POST", "remote/mail_cancelsend.aspx", false);
    g_xmlHttp.onreadystatechange = mail_cancelsend_after;
    g_xmlHttp.send(xmlDom);

}
function mail_cancelsend_after() {
    if (g_xmlHttp != null && g_xmlHttp.readyState == 4) {
        var szStatus = g_xmlHttp.status;
        switch (szStatus) {
            case 200:
                if (g_xmlHttp.responseText == "OK")
                    alert(strLang146);
                else if (g_xmlHttp.responseText.indexOf("RE:") > -1) {
                    if (confirm(strLang261)) {
                        var splitNum = g_xmlHttp.responseText.split(':')[1];

                        view_recallMessageReport(splitNum)
                    }
                }
                else {
                    alert(g_xmlHttp.responseText)
                }
                break;
        }
    }
}
function view_recallMessageReport(pnum) {
    var feature = "height=320,width=730,resizable=yes,scrollbars=no";
    feature = feature + GetOpenPosition(730, 320);
    window.open("/myoffice/ezemail/htm/cancelMessageReport_cross.aspx?num=" + pnum, '', feature);

}
function post_mail() {
    openwindow("/myoffice/ezBoard/gwBoard_Post_ITem.aspx?Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=list&url=" + encodeURIComponent(g_paramURL), "", 880, 550);
    window.close();
}
function post_mail_New() {
    var feature = "height=720,width=765,resizable=yes,scrollbars=no";
    feature = feature + GetOpenPosition(765, 720);
    if (CrossYN() || pNoneActiveX == "YES")
        window.open("/myoffice/ezBoardSTD/NewBoardItem_Cross.aspx?url=" + encodeURIComponent(g_paramURL), '', feature);
    else {
        if (pUse_Editor == "")
            window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?url=" + encodeURIComponent(g_paramURL), '', feature);
        else
            window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?url=" + encodeURIComponent(g_paramURL), '', feature);
    }

    window.close();
}
function Item_View(vItem, pCItemID, vWriter, pBrdid, vGbnBoard, pBrdnm, brd_Gubun) {
    var pcurpage = "1", pBrdMod = "WorkBoard", pDeptBoardYN = "N", pAdminFg = "0"

    var rep = new RegExp("&", "gi");
    Brdnm = pBrdnm.replace(rep, "chr(38)");

    pURL = "/Myoffice/ezboard/gwBoard_Get_View.aspx?BoardID=" + pBrdid + "&ItemID=" + vItem + "&GoTopage=" + pcurpage + "&Brd_mod=" + pBrdMod + "&Brdnm=" + Brdnm + "&CItemID=" + pCItemID;
    pURL = pURL + "&WUserID=" + vWriter + "&DeptBoardYN=" + pDeptBoardYN + "&AdminFg=" + pAdminFg + "&pGbnBoard=" + vGbnBoard + "&pbrdGubun=" + brd_Gubun;

    var openLocation = pURL;
    openwindow(openLocation, "", 880, 550);
}

/* 2019-12-19 홍승비 - 메일링크에 직접 encodeURIComponent 추가 */
/* 2018-07-19 홍승비 - 답변메일, 새 게시 메일로 알리는 기능 -> 사간겸직 시 현재 회사가 아닌 곳에서 보내진 승인메일은 alert 처리 */
function Item_View_New(pBoardID, pItemID, pBoardType) {
    if (pBoardType == "3" || pBoardType == "4" || pBoardType == "7") {
        var pheight = window.screen.availHeight;
        var pwidth = window.screen.availWidth;
        var pTop = (pheight - 720) / 2;
        var pLeft = (pwidth - 765) / 2;

        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID), false);
        xmlhttp.send();
        
        var xmlDoc = xmlhttp.responseXML;
        
        /* 2018-07-19 홍승비 - 삭제된 게시물 링크에 접근 시 alert 작동 */
        if (xmlDoc == null) {
       	 alert(strLang166);
       	 return;
       }
        /* 2018-07-19 홍승비 - 게시물 관련 companyID 다를 시 alert 작동 */
        if (getNodeText(xmlDoc.getElementsByTagName("DATA1")[0]) == "FAIL") {
        	 alert(strLangHSB01 + xmlDoc.getElementsByTagName("DATA2")[0].childNodes[0].nodeValue + strLangHSB02);
        }
        /* 2018-11-06 홍승비 - 포토, 썸네일게시물 메일 내부에서 접근 시 .aspx->.do로 수정, 동영상게시판 구분 추가 */
        else if (getNodeText(xmlDoc.documentElement) != "0" && pBoardType != "7") {
          //  window.open("/myoffice/ezBoardSTD/BoardItemView_Photo.aspx?&ItemID=" + pItemID + "&BoardID=" + pBoardID + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
            window.open("/ezBoard/boardItemViewPhoto.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&location=GENERAL", "", "height=793,width=790, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");   
        } else if (getNodeText(xmlDoc.documentElement) != "0" && pBoardType == "7") {
          //  window.open("/myoffice/ezBoardSTD/BoardItemView_Photo.aspx?&ItemID=" + pItemID + "&BoardID=" + pBoardID + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
            window.open("/ezBoard/boardItemViewMovie.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&location=GENERAL", "", "height=679,width=764, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");   
        }
        else {
            alert(strLang166);
        }
    }
    else {
        var pheigth = window.screen.availHeight;
        var pwidth = window.screen.availWidth;
        pheigth = parseInt(pheigth) / 2;
        pwidth = parseInt(pwidth) / 2;
        pheigth = pheigth - 284;
        pwidth = pwidth - 359;

        var isDotNet = false;
        var dotNetUrl;
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID), false);
        xmlhttp.send();
        
        var xmlDoc = xmlhttp.responseXML;

        /* 2018-07-19 홍승비 - 삭제된 게시물 링크에 접근 시 alert 작동 */
        if (xmlDoc == null) {
       	 alert(strLang166);
       	 return;
       }
        // 반환값이 http로 시작하면 닷넷 게시판으로 연동하는 경우이다.
        if (xmlhttp.responseText.substring(0, 4) == "http") {
            isDotNet = true;
            dotNetUrl = xmlhttp.responseText;
        }
        if (isDotNet) {
            xmlhttp.open("POST", dotNetUrl + "/myoffice/ezBoardSTD/interASP/GetItemViewNew.aspx?pBoardID=" + pBoardID + "&pItemID=" + pItemID, false);
            xmlhttp.withCredentials = true;
            xmlhttp.send();            
        }
          
        /* 2018-07-19 홍승비 - 게시물 관련 companyID 다를 시 alert 작동 */
        if (getNodeText(xmlDoc.getElementsByTagName("DATA1")[0]) == "FAIL") {
        	 alert(strLangHSB01 + xmlDoc.getElementsByTagName("DATA2")[0].childNodes[0].nodeValue + strLangHSB02);
        }
        else if (getNodeText(xmlhttp.responseXML.documentElement) != "0") {
            if (isDotNet) {
                window.open(dotNetUrl + "/myoffice/ezBoardSTD/BoardItemView_Cross.aspx?ItemID=" + pItemID + "&BoardID=" + pBoardID, "", "height=720,width=765, status = no, toolbar=no, menubar=no, location=no,scrollbars=1, resizable=1, top=0, left=0", "");                
            } else {
                window.open("/ezBoard/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID), "", "height=720,width=765, status = no, toolbar=no, menubar=no, location=no,scrollbars=1, resizable=1, top=0, left=0", "");
            }
        } else {
            alert(strLang166);
        }
    }
}

/* 2018-07-03 홍승비 - 승인게시물에 쓰이는 기능 -> 사간겸직 시 현재 회사가 아닌 곳에서 보내진 승인메일은 alert 처리 */
function Item_View_APPR(pBoardID, pItemID, pgubun) {
    var pheigth = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    pheigth = parseInt(pheigth) / 2;
    pwidth = parseInt(pwidth) / 2;
    pheigth = pheigth - 284;
    pwidth = pwidth - 359;

    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID), false);
    xmlhttp.send();
    
    var xmlDoc = xmlhttp.responseXML;
    
    /* 2018-07-05 홍승비 - 삭제된 게시물 링크에 접근 시 alert 작동 */
    if (xmlDoc == null) {
   	 alert(strLang166);
   	 return;
   }
    /* 2018-07-03 홍승비 - 승인게시물 관련 companyID 다를 시 alert 작동 */
    if (getNodeText(xmlDoc.getElementsByTagName("DATA1")[0]) == "FAIL") {
    	 alert(strLangHSB01 + xmlDoc.getElementsByTagName("DATA2")[0].childNodes[0].nodeValue + strLangHSB02);
    }
    /* 2018-11-06 홍승비 - 포토, 썸네일게시물 승인을 위해 .aspx->.do로 수정, 동영상게시판 구분 추가 */
    else if (getNodeText(xmlDoc.documentElement) != "0") {
        if (pgubun == "3" || pgubun == "4") {
            window.open("/ezBoard/boardItemViewPhoto.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&location=GENERAL", "", "height=793,width=790, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
        } else if (pgubun == "7") {
        	 window.open("/ezBoard/boardItemViewMovie.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&location=GENERAL", "", "height=679,width=764, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
        }
        else {
            window.open("/ezBoard/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&location=GENERAL", "", "height=720,width=765, status = no, scrollbars=1, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
        }
    }
    else {
        alert(strLang166);
    }
}


// 20060724 준호추가
// 커뮤니티 게시판에서 넘어온 경우 처리
// 게시 보기(새거)
/* 2018-07-03 홍승비 - 답변 알림 메일 확인 시 companyID 체크 */
function item_View_New_Community(pBoardID, pItemID, pCommunityID) {
    var pheigth = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    pheigth = parseInt(pheigth) / 2;
    pwidth = parseInt(pwidth) / 2;
    pheigth = pheigth - 284;
    pwidth = pwidth - 359;

    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("GET", "/ezCommunity/getItemViewNew.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID), false);
    xmlhttp.send();
    
    var xmlDoc = xmlhttp.responseXML;
    
    /* 2018-07-19 홍승비 - 삭제된 게시물 링크에 접근 시 alert 작동 */
    if (xmlDoc == null) {
   	 alert(strLang166);
   	 return;
   }
    /* 2018-10-04 홍승비 - 커뮤니티 답변게시물 관련 companyID 다를 시 alert 작동 */
    if (getNodeText(xmlDoc.getElementsByTagName("DATA1")[0]) == "FAIL") {
    	 alert(strLangHSB01 + xmlDoc.getElementsByTagName("DATA2")[0].childNodes[0].nodeValue + strLangHSB02);
    } else {
    if (CrossYN())
        window.open("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&code=" + encodeURIComponent(pCommunityID), "", "height=720,width=765, status = no, toolbar=no, scrollbars=1, menubar=no, location=no, resizable=1, top=0, left=0", "");
    else
        window.open("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&code=" + encodeURIComponent(pCommunityID), "", "height=720,width=765, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
    }
}

/* 2021-11-16 홍승비 - 커뮤니티 게시알림, 수정알림, 댓글알림 메일 기능 추가 + 포토게시물 링크 추가 */
function item_ViewPhoto_New_Community(pBoardID, pItemID, pCommunityID) {
	var pheigth = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	pheigth = parseInt(pheigth) / 2;
	pwidth = parseInt(pwidth) / 2;
	pheigth = pheigth - 284;
	pwidth = pwidth - 359;
	
	var xmlhttp = createXMLHttpRequest();
	xmlhttp.open("GET", "/ezCommunity/getItemViewNew.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID), false);
	xmlhttp.send();
	
	var xmlDoc = xmlhttp.responseXML;
	
	/* 2018-07-19 홍승비 - 삭제된 게시물 링크에 접근 시 alert 작동 */
	if (xmlDoc == null) {
		alert(strLang166);
		return;
	}
	/* 2018-10-04 홍승비 - 커뮤니티 답변게시물 관련 companyID 다를 시 alert 작동 */
	if (getNodeText(xmlDoc.getElementsByTagName("DATA1")[0]) == "FAIL") {
		alert(strLangHSB01 + xmlDoc.getElementsByTagName("DATA2")[0].childNodes[0].nodeValue + strLangHSB02);
	} else {
		if (CrossYN())
			window.open("/ezCommunity/boardItemViewPhoto.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&code=" + encodeURIComponent(pCommunityID), "", "height=721,width=750, status = no, toolbar=no, scrollbars=1, menubar=no, location=no, resizable=1, top=0, left=0", "");
		else
			window.open("/ezCommunity/boardItemViewPhoto.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&code=" + encodeURIComponent(pCommunityID), "", "height=721,width=750, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
	}
}

/* 커뮤니티 초대알림 메일 */
function invite_Community(pCommunityID) {
    var pheigth = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    pheigth = parseInt(pheigth) / 2;
    pwidth = parseInt(pwidth) / 2;
    pheigth = pheigth - 284;
    pwidth = pwidth - 359;

    if (CrossYN())
        window.open("/ezCommunity/commHome/popupCommHome.do?code=" + encodeURIComponent(pCommunityID) + "&userLevel=0&inviteFlag=true", "", "height=900,width=1300, status = no, toolbar=no, scrollbars=1, menubar=no, location=no, resizable=1, top=0, left=0", "");
    else
        window.open("/ezCommunity/commHome/popupCommHome.do?code=" + encodeURIComponent(pCommunityID) + "&userLevel=0&inviteFlag=true", "", "height=900,width=1300, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");

}

// 결재 보기
function ViewDoc(pDocID, pURL, pWhat, pOpinionFlag, pdocState, pListSusin, podoc) {
    if (typeof (pWhat) == "undefined" || podoc == "") {
        openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURIComponent(pDocID) + "&DocHref=" + encodeURIComponent(pURL);
        openwindow(openLocation, "", 880, 550);
    }
    else if (pWhat == "1") {
        openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURIComponent(pDocID) + "&DocHref=" + encodeURIComponent(pURL) + "&OpinionFlag=" + encodeURIComponent(pOpinionFlag) + "&docState=" + encodeURIComponent(pdocState) + "&ListSusin=" + encodeURIComponent(pListSusin) + "&odoc=" + encodeURIComponent(podoc);
        openwindow(openLocation, "", 880, 550);
    }
    else {
        openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURIComponent(pDocID) + "&DocHref=" + encodeURIComponent(pURL);
        openwindow(openLocation, "", 880, 550);
    }
}

// 2019-06-24 김민성 - 일정 초대 메일 읽기
function open_schedule(scheduleid) {
	var wWeight = "760";
    var wHeight = "670";
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = (width - wWeight) / 2;
    var top = (heigth - wHeight) / 2;
    
    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/ezSchedule/getScheduleRead.do?scheduleid=" + encodeURIComponent(scheduleid), false);
    xmlhttp.send();
    
  	var xmlDoc = xmlhttp.responseText;
    
  	if(xmlDoc == "D") {
  		alert(strLang166);
  		return;
  	}
  	else if (xmlDoc == "N") {
      	 alert(strLangKMSS01);
      	 return;
    }

    if (CrossYN())
        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&isMailNoti=Y", "",
            "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
    else
        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&isMailNoti=Y", "",
            "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
}

function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;
            pleftpos = parseInt(width) - 700;
            heigth = parseInt(heigth) - 176;
            width = parseInt(width) - pleftpos;
            left = pleftpos / 2;
        }
        else {
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - 10;
        }

        if (wName == "")
            window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
        else
            window.open("", wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

    } catch (e) {console.log(e);}
}

function mail_link(){
	
	var chk = $("#approv_a").attr("href");
	$("#approv_a").removeAttr("href");
	if(chk != "" && chk != undefined) {
		var link = chk.split("/");
		
		for (var i = 1; i < link.length; i++) {
			real_href += "/" + link[i];
		}
	}
	
	/* 2020-07-08 홍승비 - 메일 링크의 결재문서 열기 시 팝업창 크기 조정 (전자결재 > 결재할문서, 결재진행문서 팝업창과 동일하게) */
	// window.open(real_href, 'apprmailLink', GetOpenWindowfeature(880, 900, true));
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;
        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;

            pleftpos = parseInt(width) - 1150;
            heigth = parseInt(heigth) - 30;

            if (CrossYN()) {
                heigth = parseInt(heigth) - 25;
            }
            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
                heigth = parseInt(heigth) - 40;
            }
            
            width = parseInt(width) - pleftpos;
            left = pleftpos / 2;
        }
        else {
            heigth = parseInt(heigth) - 30;

            if (CrossYN()) {
                heigth = parseInt(heigth) - 25;
            }
            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
                heigth = parseInt(heigth) - 40;
            }
            
            width = parseInt(width) - 10;
        }

        window.open(real_href, 'apprmailLink', "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
    }
    catch (e) {
        alert("openwindow :: " + e.description);
    }
    
}

function addIcalSchedule(pURL, shareId) {
	if (confirm(strLangKSA03)) {
		$.ajax({
		  type : "post",
		  url : "/ezSchedule/icsImportFromEmail.do",
		  data : {
			  "pURL" : encodeURIComponent(pURL),
			  "shareId" : encodeURIComponent(shareId)
		  },
		  success : function(result){ 
			  if (result != "OK") {
				  alert(strLangKSA05 + " : " + result);
			  } else {
				  alert(strLangKSA04);
			  }
		  },
		  error: function(error){
			  alert(strLangKSA05);
		  }
	   });
	}
}

function download_Single_mail() {

    var parameters = "url=" + encodeURIComponent(g_paramURL);
    var fullpath = "/ezEmail/mailExport.do?" + parameters;

    if (typeof(sharer) != "undefined" && sharer != "") {
        fullpath += "&sharer=" + encodeURIComponent(sharer);
    }
    AttachDownFrame.location.href = fullpath;
    AttachDownFrame.target = "_blank";

}

var mail_originalEML_cross_dialogArguments = new Array();

function view_OriginalEML() {
    mail_originalEML_cross_dialogArguments[1] = DivPopUpHiddenReadMail;

    var parameters = "url=" + encodeURIComponent(g_paramURL);
    var requestUrl = "/ezEmail/getOriginalEML.do?" + parameters;

    if (typeof(shareId) != "undefined" && shareId != "") {
        requestUrl += "&shareId=" + encodeURIComponent(shareId);
    }

    if (typeof(sharer) != "undefined" && sharer != "") {
        requestUrl += "&sharer=" + encodeURIComponent(sharer);
    }

    DivPopUpShow(620, 600, requestUrl);
}

function makeWindowPosition(width, height) {
	var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;

    var screenWidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var screenHeight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var left = (screenWidth - width) / 2 + dualScreenLeft;
    var top = (screenHeight - height) / 2 + dualScreenTop;
    
    var feature = ", left=" + left + ",top=" + top;
    return feature;
}

function openAttendChk() {
	var height = 470;
	var width = 800;
	var feature = makeWindowPosition(width, height);
    
    var requestUrl = "/ezSchedule/scheduleReceiveAttendant.do?from=mail";
    
    window.open(requestUrl, "", "height=" + height + "px, width= " + width + "px" + feature);
    
}

function openScheduleInfo() {
	var scheduleId = event.target.getAttribute("scheduleId");
	var repeatCount = event.target.getAttribute("repeatCount");
	var height = 700;
	var width = 800;
	var feature = makeWindowPosition(width, height);
    var requestUrl = "";
    if (repeatCount != null) {
    	requestUrl = "/ezSchedule/scheduleRead.do?id=" + encodeURIComponent(scheduleId) + "&repeatcount=" + repeatCount;
    } else {
    	requestUrl = "/ezSchedule/scheduleRead.do?id=" + encodeURIComponent(scheduleId) + "&isReceive=Y";
    }
    
    window.open(requestUrl, "", "height=" + height + "px, width= " + width + "px" + feature);
}

//2023-09-06 한태훈 - 일정관리 > 미리알림 메일 링크
function reminderMailLink() {
	var reminder_link = document.getElementById("reminder_link");
	var id = reminder_link.getAttribute("scheId");
	var otherid = reminder_link.getAttribute("otherid");
	var repeatcount = reminder_link.getAttribute("repeatcount");
	var date = reminder_link.getAttribute("date");
	var type = reminder_link.getAttribute("type");
	var datetype = reminder_link.getAttribute("datetype");
	var pattern = reminder_link.getAttribute("pattern");
    var height = 750;
    var width = 800;
    
    var feature = makeWindowPosition(width, height);
	
	var url = "/ezSchedule/scheduleRead.do?";
	url += "id=" + encodeURIComponent(id) + "&otherid=" + encodeURIComponent(otherid) +"&repeatcount=" + encodeURIComponent(repeatcount) + "&date=" + encodeURIComponent(date) + "&type=" + encodeURIComponent(type) + "&datetype=" + encodeURIComponent(datetype) + "&pattern=" + encodeURIComponent(pattern);
	window.open(url, "", "toolbar=0, location=0, directories=0, status=0, menubar=0, scrollbars=0, resizable=1, height=" + height +"px, width=" + width +"px" + feature);
}
