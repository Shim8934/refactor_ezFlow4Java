var PreviewH_Move = false;
var minimumWidth = 890;
function PreviewH_onMouserDown(e) {
    curevent = (typeof event == 'undefined' ? e : event)

    var newPos_H = curevent.clientX;

    if (newPos_H < parseInt(CurrenWidth * 0.40)) {
        newPos_H = parseInt(CurrenWidth * 0.40);
    }
    else if (newPos_H > parseInt(CurrenWidth * 0.75)) {
        newPos_H = parseInt(CurrenWidth * 0.75);
    }

    document.getElementById("ResizeBarH").style.left = newPos_H + "px";
    document.getElementById("ResizeBarH").style.display = "";
    document.getElementById("mailPanel").style.display = "";
    PreviewH_Move = true;

    // IE에서 Preview 프레임의 크기를 변경하기 위해 마우스를 드래그 후 놓을 때 메일 목록의 텍스트가 모두 선택되는 문제가 발생해 추가함.
    document.onselectstart = function () { return false; };
}
var PreviewW_Move = false;
function PreviewW_onMouserDown(e) {
    curevent = (typeof event == 'undefined' ? e : event)

    var newPos_W = curevent.clientY;

    if (newPos_W < (parseInt(CurrentHeight * 0.25) + 90)) {
        newPos_W = parseInt(CurrentHeight * 0.25) + 90;
    }
    else if (newPos_W > (parseInt(CurrentHeight * 0.65) + 90)) {
        newPos_W = (parseInt(CurrentHeight * 0.65) + 90);
    }

    document.getElementById("ResizeBarW").style.top = newPos_W + "px";
    document.getElementById("ResizeBarW").style.display = "";
    document.getElementById("mailPanel").style.display = "";
    PreviewW_Move = true;
	SmallSizeList = false;
    
    // IE에서 Preview 프레임의 크기를 변경하기 위해 마우스를 드래그 후 놓을 때 메일 목록의 텍스트가 모두 선택되는 문제가 발생해 추가함.
    document.onselectstart = function () { return false; };
}
function MailPreviewEnd(e) {
	
    if (PreviewW_Move || PreviewH_Move) {
        document.getElementById("ResizeBarH").style.display = "none";
        document.getElementById("ResizeBarW").style.display = "none";
        document.getElementById("mailPanel").style.display = "none";
        if (PreviewH_Move) {
            var newPos_H = parseInt(document.getElementById("ResizeBarH").style.left) - 10;
            if (pMailListWidthH > newPos_H) {
                pMailPreWidthH = pMailPreWidthH + (pMailListWidthH - newPos_H);
                pMailListWidthH = newPos_H;
            } else {
                pMailPreWidthH = CurrenWidth - newPos_H;
                pMailListWidthH = newPos_H;
            }
            document.getElementById("ifrmPreViewH").style.display = "";
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
            document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 10) + "px";
            document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 5 + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
            document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 155) + "px";
            
            pMailListDiv_H = (pMailListWidthH / CurrenWidth) * 100;
            pMailPreVDiv_H = (pMailPreWidthH / CurrenWidth) * 100;
            if($("#PreH_CCMain").css("display") != "none") {
            	$("#ifrmPreViewH").height($("#ifrmPreViewH").height()-20);
            }

            mailPrevIframeSize();
        }
        else if (PreviewW_Move) {
            var newPos_W = parseInt(document.getElementById("ResizeBarW").style.top) - 90;
            if (pMailListHeightW > newPos_W) {
                pMailPreHeightW = pMailPreHeightW + (pMailListHeightW - newPos_W);
                pMailListHeightW = newPos_W;
            } else {
                pMailPreHeightW = CurrentHeight - newPos_W;
                pMailListHeightW = newPos_W;
            }
            
            document.getElementById("ifrmPreViewW").style.display = "";
            document.getElementById("MailListRayer").style.width = "100%";
            document.getElementById("PreviewRayerW").style.width = "100%";
            document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
            document.getElementById("contentlist").style.height = (pMailListHeightW - 100) + "px";
//            document.getElementById("PreviewRayerW").style.height = pMailPreHeightW + "px";
            document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 110) + "px";
            pMailListDiv = (pMailListHeightW / CurrentHeight) * 100;
            pMailPreVDiv = (pMailPreHeightW / CurrentHeight) * 100;
            if($("#PreW_CCMain").css("display") != "none") {
            	$("#ifrmPreViewW").height($("#ifrmPreViewW").height()-20);
            }
            
            mailPrevIframeSize();
        }
        PreviewH_Move = false;
        PreviewW_Move = false;
        ContextMenuHidden();
        if (g_foldertype != "sent") {
            if (SmallSizeList) {
                if (p_ListorderValue == "" || p_ListorderValue == "UNREAD") {
                    BasicViewHeaderChange(SmallSizeList, g_foldertype);
                    OldSmallSizeList = SmallSizeList;
                }
            }
            else {
                if (p_ListorderValue == "" && OldSmallSizeList) {
                    BasicViewHeaderChange(SmallSizeList, g_foldertype);
                }
                else if (p_ListorderValue == "UNREAD" && OldSmallSizeList) {
                    BasicViewHeaderChange(SmallSizeList, g_foldertype);
                }
            }
        } else {
        	if (pPreviewShow_HOW == "H" && !useReceivingChk) {
                BasicViewHeaderChange(SmallSizeList, g_foldertype);
            }
        }
    }
    
    // IE에서 Preview 프레임의 크기를 변경하기 위해 마우스를 드래그 후 놓을 때 메일 목록의 텍스트가 모두 선택되는 문제가 발생해 추가함.
    // 이 부분은 사용자가 Preview 헤더 부분의 텍스트를 선택 가능하게 하기 위해 필요함.
    document.onselectstart = null;
}
var SmallSizeList = false;
var OldSmallSizeList = false;
function MailPreviewResize(e) {
    if (PreviewH_Move) {
        curevent = (typeof event == 'undefined' ? e : event)
        
        // 좌우 화면 프레임 크기를 변경할 때 좌우 10 픽셀 범위에 마우스
        // 포인터가 오면 자동으로 리사이징 작업을 완료시킨다.
        var minSize = parseInt(10);
        var maxSize = parseInt(document.documentElement.clientWidth - 10);
        
        if (curevent.clientX < minSize || curevent.clientX > maxSize) {
            MailPreviewEnd(e);
        }
        else {
            var newPos_H = curevent.clientX;

            // 왼쪽으로 리사이징 할 수 있는 최대 비율을 제한한다.
            if (newPos_H < parseInt(CurrenWidth * 0.40)) {
                newPos_H = parseInt(CurrenWidth * 0.40);
            // 오른쪽으로 리사이징 할 수 있는 최대 비율을 제한한다.
            } else if (newPos_H > parseInt(CurrenWidth * 0.75)) {
                newPos_H = parseInt(CurrenWidth * 0.75);
            }

            // 화면 폭이 일정 크기보다 작아지면 헤더 구성을 변경한다.
            // 중요도, 책갈피, 첨부파일, 크기 컬럼을 제거한다.
            if (newPos_H <= 470) {
                SmallSizeList = true;
            } else {
                SmallSizeList = false;
            }
            
            document.getElementById("ResizeBarH").style.left = newPos_H + "px";
        }
    }
    else if (PreviewW_Move) {
        curevent = (typeof event == 'undefined' ? e : event)
        var minSize = parseInt(100);
        var maxSize = parseInt(document.documentElement.clientHeight-100);
        if (curevent.clientY < minSize || curevent.clientY > maxSize) {
            MailPreviewEnd(e);
        }
        else {
            var newPos_W = curevent.clientY;
            if (newPos_W < (parseInt(CurrentHeight * 0.25) + 90))
                newPos_W = parseInt(CurrentHeight * 0.25) + 90;
            else if (newPos_W > (parseInt(CurrentHeight * 0.65) + 90)) {
                newPos_W = (parseInt(CurrentHeight * 0.65) + 90);
            }
            document.getElementById("ResizeBarW").style.top = newPos_W + "px";
        }
        setTimeout(function () { isScrollMailList(); }, 500);
    }
}
// 수아 수정 (매개변수 fromE추가)
function new_mail_onclick(fromE) {
	// 수아 수정
	var msgto = "";
	if (useMailWriteSenderClick == "YES" && typeof fromE != "undefined" && $(fromE).attr("data-msgto") != "" && fromE.innerHTML != "") {
		msgto = $(fromE).attr("data-msgto");
	}
	
	var msgStr = msgto !== "" ? "&msgto=" + msgto : "" ;
	pUrl = "/ezEmail/mailWrite.do?cmd=NEW" + msgStr;
	//pUrl = "/ezEmail/mailWrite.do?cmd=NEW"
	
	/*if (CrossYN() || pNoneActiveX == "YES") {
        pUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW";
    }
    else {
        if (pUse_Editor == "")
            pUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW";
        else
            pUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW";
    }*/
	
	if (typeof(shareId) != "undefined" && shareId != "") {
		pUrl += "&shareId=" + encodeURIComponent(shareId);
	}
	
	var pheight = window.outerHeight;
    var conHeight = Math.max(pheight * 0.8, 840);
    var pwidth = window.outerWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > minimumWidth)
        conWidth = minimumWidth;
    // var pTop = (pheight - conHeight) / 2;
    // var pLeft = (pwidth - minimumWidth) / 2;
    var pLeft = window.outerWidth / 2 + window.screenX - (conWidth / 2);
    var pTop = window.outerHeight / 2 + window.screenY - (conHeight / 2);
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px,width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
    
    var newwin = window.open(pUrl, "", feature);
	
    newwin.focus();
	
	/* post 방식        mailWriteSender -> mailList.jsp
	 * var myForm = document.mailWriteSenderClick;
	
    var newwin = GetOpenWindow("", "mailWriteSender", 890, 840, "yes");
    myForm.target = "mailWriteSender"; 
    myForm.msgto.value = msgStr;
    myForm.submit();
    
    newwin.focus();
    newwin.name = "";*/
}
function ReSend(pURL, pEmail) {
    var pheight = window.screen.availHeight;
    var conHeight = Math.max(pheight * 0.8, 840);
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > minimumWidth)
        conWidth = minimumWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - minimumWidth) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px,width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
    
    var requestUrl = "/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURIComponent(pEmail);
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}
    
    window.open(requestUrl, "", feature);
    /*if (CrossYN() || pNoneActiveX == "YES") {
        window.open("/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURIComponent(pEmail), "", feature);
    }
    else {
        if (pUse_Editor == "")
            window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURIComponent(pEmail), "", feature);
        else
            window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURIComponent(pEmail), "", feature);
    }*/
}

// 2024.05.24 한슬기 : 수신인 이름을 사용하기위해 오버로딩
function ReSend(pURL, pEmail, pReader) {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - minimumWidth) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
    
    var requestUrl = "/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURIComponent(pEmail) + "&reciverName=" + encodeURIComponent(pReader);
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}
    
    window.open(requestUrl, "", feature);
    
}

function reply_mail_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0 && currentFixingId == null) {
        alert(strLang42);
    }
    
    if (listContentArry.length > 1 || listSubContentArry.length > 1) {
        alert(strLang44);
        return;
    }
    else {
        var pSelectItem;
        if (listContentArry.length > 0) {
            pSelectItem = document.getElementById(listContentArry[listContentArry.length-1])
        } else if (listSubContentArry.length > 0) {
            pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
        } else {
        	pSelectItem = currentFixingId;
        }
        var pheight = window.outerHeight;
        var conHeight = Math.max(pheight * 0.8, 840);
        var pwidth = window.outerWidth;
        var conWidth = pwidth * 0.8;
        if (conWidth > minimumWidth)
            conWidth = minimumWidth;
        var pLeft = window.outerWidth / 2 + window.screenX - (conWidth / 2);
        var pTop = window.outerHeight / 2 + window.screenY - (conHeight / 2);
        
        if (checkBlockedMail(pSelectItem.getAttribute('_href')) == '1') {
            alert(strLangLDH07);
            return;        
        }
        var pURI = "/ezEmail/mailWrite.do?cmd=REPLY&URL=" + encodeURIComponent(pSelectItem.getAttribute('_href'));
        
    	if (typeof(shareId) != "undefined" && shareId != "") {
    		pURI += "&shareId=" + encodeURIComponent(shareId);
    	}
        
        var newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
        newwin.focus();
    }
}

function GetNewGuid() {
    return Math.floor((1 + Math.random()) * 0x10000)
               .toString(16)
               .substring(1);
}

function all_reply_mail_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0 && currentFixingId == null) {
        alert(strLang42);
    }
    
    if (listContentArry.length > 1 || listSubContentArry.length > 1) {
        alert(strLang44);
        return;
    }
    else {
        var pSelectItem;
        if (listContentArry.length > 0) {
            pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1])
		} else if (listSubContentArry.length > 0) {
            pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
        } else {
        	pSelectItem = currentFixingId;
        }
        var pheight = window.outerHeight;
        var conHeight = Math.max(pheight * 0.8, 840);
        var pwidth = window.outerWidth;
        var conWidth = pwidth * 0.8;
        if (conWidth > minimumWidth)
            conWidth = minimumWidth;
        var pLeft = window.outerWidth / 2 + window.screenX - (conWidth / 2);
        var pTop = window.outerHeight / 2 + window.screenY - (conHeight / 2);
        
        if (checkBlockedMail(pSelectItem.getAttribute('_href')) == '1') {
            alert(strLangLDH07);
            return;        
        }
        
        var pURI = "/ezEmail/mailWrite.do?cmd=REPLYALL&URL=" + encodeURIComponent(pSelectItem.getAttribute('_href'));
        
        if (typeof(shareId) != "undefined" && shareId != "") {
        	pURI += "&shareId=" + encodeURIComponent(shareId);
    	}
        
        var newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
        newwin.focus();
    }
}

function reSend_onClick() {
	if (listContentArry.length == 0 && listSubContentArry.length == 0 && currentFixingId == null) {
        alert(strLang42);
    }
    
    if (listContentArry.length > 1 || listSubContentArry.length > 1) {
        alert(strLang44);
        return;
    } else {
        var pSelectItem;
        
        if (listContentArry.length > 0) {
            pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1])
        } else if (listSubContentArry.length > 0) {
            pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
        } else {
        	pSelectItem = currentFixingId;
        }
        
        var pURI = "/ezEmail/mailWrite.do?cmd=RESEND&URL=" + encodeURIComponent(pSelectItem.getAttribute('_href'));
        
        if (typeof(shareId) != "undefined" && shareId != "") {
        	pURI += "&shareId=" + encodeURIComponent(shareId);
    	}
        
        var newwin = GetOpenWindow(pURI, "", 890, 840, "yes");
        newwin.focus();
    }

}

function rewrite_onClick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0 && currentFixingId == null) {
        alert(strLang42);
    }

    if (listContentArry.length > 1 || listSubContentArry.length > 1) {
        alert(strLang44);
        return;
    } else {
        var pSelectItem;

        if (listContentArry.length > 0) {
            pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1])
        } else if (listSubContentArry.length > 0) {
            pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
        } else {
            pSelectItem = currentFixingId;
        }

        if (checkBlockedMail(pSelectItem.getAttribute('_href')) == '1') {
            alert(strLangLDH07);
            return;        
        }

        var pURI = "/ezEmail/mailWrite.do?cmd=REWRITE&URL=" + encodeURIComponent(pSelectItem.getAttribute('_href'));

        if (typeof(shareId) != "undefined" && shareId != "") {
        	pURI += "&shareId=" + encodeURIComponent(shareId);
    	}
        
        var newwin = GetOpenWindow(pURI, "", 890, 840, "yes");
        newwin.focus();
    }

}

function transmission_mail_onclick() {
    var pSelectItems = [];

    // 2025.02.13 김은실 : [국립암센터] 메일 전달 방식. 전달 시 메일 다수 선택 가능.
    if (listContentArry.length > 0) {
        pSelectItems = listContentArry.map(id => document.getElementById(id).getAttribute("_href")); // ["INBOX/4", "INBOX/5", "INBOX/6"]
    } else if (listSubContentArry.length > 0) {
        pSelectItems = listSubContentArry.map(id => document.getElementById(id).getAttribute("_href"));
    } else if (currentFixingId) {
        pSelectItems = [currentFixingId.getAttribute('_href')]; // ["INBOX/4"]
    }

    forward_mail_call(pSelectItems, shareId); // 마지막 라인이라 return 필요없어서 생략.
}

function Read_StatusChange(pGubun) {
    if (listContentArry.length == 0 && listSubContentArry.length == 0 && currentFixingId == null) {
        alert(strLang42);
        return;
    }

    var isRead;
    if (pGubun == "R")
        isRead = "TRUE";
    else
        isRead = "FALSE";
    var xmlpara = createXmlDom();
    var xmlHTTP = createXMLHttpRequest();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "ISREAD", isRead);
    if (listContentArry.length > 0) {
        for (var i = 0; i < listContentArry.length; i++) {
            createNodeAndInsertText(xmlpara, objNode, "MESSAGEID", document.getElementById(listContentArry[i]).getAttribute("_href"));
        }
    } else if (listSubContentArry.length > 0) {
        for (var i = 0; i < listSubContentArry.length; i++) {
            createNodeAndInsertText(xmlpara, objNode, "MESSAGEID", document.getElementById(listSubContentArry[i]).getAttribute("_href"));
        }
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "MESSAGEID", currentFixingId.getAttribute("_href"));
    }
    
    var url = "/ezEmail/mailSetReadChange.do";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		url += "?shareId=" + encodeURIComponent(shareId);
	}
    
    xmlHTTP.open("POST", url, false);
    xmlHTTP.send(xmlpara);
    
    // 20200428 조진호 - 메일 리스트에서 체크박스를 이용한 행위 뒤 체크박스가 풀리도록 추가
    if (listContentArry.length > 0) {
        for (var i = 1; i <= listContentArry.length; i++) {
            document.getElementById(listContentArry[listContentArry.length - i]).children[0].children[0].checked = false;
        }
    }
    try {
        if (document.getElementById("HeaderAllCheckBox") != null)
            document.getElementById("HeaderAllCheckBox").checked = false;
    } catch (e) {console.log(e);}
    
    MailListRefresh();
}
var mail_movecopy_cross_dialogArguments = new Array();
function move_mail_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0 && currentFixingId == null) {
        alert(strLang42);
        return;
    }
    
    mail_movecopy_cross_dialogArguments[1] = move_mail_onclick_Complete_timer;
    mail_movecopy_cross_dialogArguments[2] = "CLOSE";
    
    var requestUrl = "/ezEmail/mailMoveCopy.do";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	}
    
	if (listContentArry.length + listSubContentArry.length == 0) {
		currentFixingIdTemp = currentFixingId;
	}
	
    var OpenWin = window.open(requestUrl, "mail_movecopy_cross", GetOpenWindowfeature(500, 700));
    try { OpenWin.focus(); } catch (e) {console.log(e);}
}

//2024-12-11 김대현 크롬과 엣지에서 다른창에서 호출시  confirm 함수가 안먹는 현상 발생하여 타이머를 두고 자기 자신이 다시 호출하게 변경
function move_mail_onclick_Complete_timer(moveUrl) {
    setTimeout(function() {
        move_mail_onclick_Complete(moveUrl);
    }, 100);
}

function move_mail_onclick_Complete(moveUrl) {
    if (typeof (moveUrl) == "undefined")
        return;

	var isOnlyFixingId = listContentArry.length + listSubContentArry.length == 0;

    if (moveUrl["cmd"] == "MOVE") {
    	var includeSecureMail = false;
        var isSentmail = false;
    	for (var i = 0; i < listContentArry.length; i++) {
    		if (document.getElementById(listContentArry[i]).getAttribute("securemail") == "1") {
    			includeSecureMail = true;
                
                // 2024-12-11 김대현 보낸편지함에 있는 보안메일 일때만 아래 confirm함수를 타야하기 때문에 해당 메일이 현재 보낸편지함에 있는지 확인하는 부분
                var mailBox = document.getElementById(listContentArry[i]).getAttribute("_href");
                mailBox = mailBox != null ? mailBox.toLowerCase() : "";
                isSentmail = /^sent/.test(mailBox);
                
    	    	break;
    	    }
    	}
        
    	if (isSentmail && includeSecureMail || isOnlyFixingId && currentFixingIdTemp.getAttribute("securemail") == "1") {
    		if (!confirm(strLangLHM20)) {
	    		return;
	    	}
    	}
    	
        var szItemID = "";
        for (var i = 0; i < listContentArry.length; i++) {
            szItemID += document.getElementById(listContentArry[i]).getAttribute("_href") + ",";
        }
        for (var i = 0; i < listSubContentArry.length; i++) {
            szItemID += document.getElementById(listSubContentArry[i]).getAttribute("_href") + ",";
        }
        
        if (isOnlyFixingId) {
        	szItemID = currentFixingIdTemp.getAttribute("_href") + ",";
        }
        
        Mail_CopyPostSend(moveUrl["cmd"], moveUrl["url"], szItemID);
    }
    else if (moveUrl["cmd"] == "COPY") {
        var szItemID = "";
        for (var i = 0; i < listContentArry.length; i++) {
            szItemID += document.getElementById(listContentArry[i]).getAttribute("_href") + ",";
        }
        for (var i = 0; i < listSubContentArry.length; i++) {
            szItemID += document.getElementById(listSubContentArry[i]).getAttribute("_href") + ",";
        }

		if (isOnlyFixingId) {
			szItemID = currentFixingIdTemp.getAttribute("_href") + ",";
		}

        Mail_CopyPostSend(moveUrl["cmd"], moveUrl["url"], szItemID);
        
        // 20200428 조진호 - 메일 리스트에서 체크박스를 이용한 행위 뒤 체크박스가 풀리도록 추가
        if (listContentArry.length > 0) {
            for (var i = 1; i <= listContentArry.length; i++) {
                document.getElementById(listContentArry[listContentArry.length - i]).children[0].children[0].checked = false;
            }
        }
        try {
            if (document.getElementById("HeaderAllCheckBox") != null)
                document.getElementById("HeaderAllCheckBox").checked = false;
        } catch (e) {console.log(e);}
        
        MailListRefresh();
    } else if (moveUrl['cmd'] === 'KEEP_MOVE') {
        let itemId = "";
        for (let i = 0; i < listContentArry.length; i++) {
            itemId += document.getElementById(listContentArry[i]).getAttribute("_href") + ",";
        }
        for (let i = 0; i < listSubContentArry.length; i++) {
            itemId += document.getElementById(listSubContentArry[i]).getAttribute("_href") + ",";
        }

        if (isOnlyFixingId) {
            itemId = currentFixingIdTemp.getAttribute("_href") + ",";
        }

        keepMove(itemId, moveUrl["url"]);
    }
}
var xmlhttp_mailCopy;
function Mail_CopyPostSend(Mode, Url, szItemID) {
    var xmlpara = createXmlDom();
    var objNode;
    xmlhttp_mailCopy = createXMLHttpRequest();
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CMD", Mode);
    createNodeAndInsertText(xmlpara, objNode, "UNIQUEID", szItemID);
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", Url);
    
    var requestUrl = "/ezEmail/mailMoveCopyMessage.do";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	}
    
    xmlhttp_mailCopy.open("POST", requestUrl, true);
    xmlhttp_mailCopy.onreadystatechange = event_Mail_CopyPostSend;
    event_Mail_CopyPostSend.mode = Mode;
    xmlhttp_mailCopy.send(xmlpara);
}
function event_Mail_CopyPostSend() {
    if (xmlhttp_mailCopy != null && xmlhttp_mailCopy.readyState == 4) {
        if (xmlhttp_mailCopy.status >= 200 && xmlhttp_mailCopy.status < 300) {
        	pRtnMessage = xmlhttp_mailCopy.responseText;
        	
        	if (pRtnMessage.indexOf("NO COPY processing failed.") > -1) {
        		alert(strLang241);
        	} else {
	        	MailListRefresh();
	        	
	            if(event_Mail_CopyPostSend.mode=="MOVE") {
	            	prevShow_Clear();
	            	alert(MoveMsg);
	            } else if (event_Mail_CopyPostSend.mode=="COPY") {
	            	alert(CopyMsg);
	            }
        	}
        }
        else {
            alert(strLang5);
        }
    }
}
var xmlhttp_mailMoveDelete;
function Mail_MoveDeletePostSend(Mode, Url, szItemID) {
    var xmlpara = createXmlDom();
    var objNode;
    xmlhttp_mailMoveDelete = createXMLHttpRequest();
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "UNIQUEID", szItemID);
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", Url);
    
    var url = "/ezEmail/mailDelete.do?cmd=" + Mode;
    
    if (typeof(shareId) != "undefined" && shareId != "") {
		url += "&shareId=" + encodeURIComponent(shareId);
	}
    
    xmlhttp_mailMoveDelete.open("POST", url, true);
    xmlhttp_mailMoveDelete.onreadystatechange = event_xmlhttp_mailMoveDelete_Complete;
    event_xmlhttp_mailMoveDelete_Complete.mode = Mode;
    xmlhttp_mailMoveDelete.send(xmlpara);
}
function event_xmlhttp_mailMoveDelete_Complete() {
    hideDelAllProgress();
    if (xmlhttp_mailMoveDelete != null && xmlhttp_mailMoveDelete.readyState == 4) {
    	if (xmlhttp_mailMoveDelete.responseText.indexOf("NO COPY processing failed.") > -1) {
    		alert(strLang241);
    	}
    	else if (xmlhttp_mailMoveDelete.status >= 200 && xmlhttp_mailMoveDelete.status < 300) {
            MailListRefresh();
            
            if(event_xmlhttp_mailMoveDelete_Complete.mode=="MOVE")
                alert(MoveMsg);
            else if (event_xmlhttp_mailMoveDelete_Complete.mode == "ALL") {
                alert(strLang215)
            }
            else {
                if (event_xmlhttp_mailMoveDelete_Complete.mode != "BMOVE")
                    alert(strLang215)
            }
        }
        else {
            if (event_xmlhttp_mailMoveDelete_Complete.mode == "MOVE")
                alert(strLang52);
            else
                alert(strLang131);
        }
        prevShow_Clear();
    }
}

var mailKeepMoveDialogArguments = {};

function keepMove(itemIDs, copyFolderID) {
    if (copyFolderID === "Sent") {
        alert(strLangKeepMoveCantUseSentBox);
        return;
    }

    mailKeepMoveDialogArguments.okHandler = keepMoveOkHandler;
    mailKeepMoveDialogArguments.mailUids = itemIDs;
    mailKeepMoveDialogArguments.targetFolderId = copyFolderID;
    let url = '/ezEmail/mailKeepMove.do?folderId=' + encodeURIComponent(copyFolderID);

    if (shareId) {
        url += '&shareId=' + encodeURIComponent(shareId);
    }

    const openWindow = window.open(url, 'mail_keepmove', GetOpenWindowfeature(500, 220));
    try { openWindow.focus(); } catch (e) {console.log(e);}
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
                startKeepMoveTimer(result.data);
            } else {
                alert(strLang321 + '\n' + Date.now());
            }
        },
        error: function() {
            alert(strLang321 + '\n' + Date.now());
        }
    });
}

let keepMoveTimerId;

function clearKeepMoveTimer() {
    if (keepMoveTimerId) {
        psSetTimeFlag = false;
        HiddenMailProgressNew();
        clearTimeout(keepMoveTimerId);
        keepMoveTimerId = null;
    }
}

function startKeepMoveTimer(userKey) {
    psSetTimeFlag = true;
    ShowMailProgressNew();
    keepMoveTimerId = setTimeout(function callAjax()  {
        $.ajax({
            type : "POST",
            url : "/ezEmail/getMailboxProgress.do",
            data : { userKey },
            dataType : "json",
            success : function(data) {
                // -1 전처리
                // 0 진행 중
                // 100 성공
                // -100 실패: From 헤더 없음
                // -200 실패: 자동분류 추가 실패(jgw)
                // -300 실패: 알 수 없는 오류
                switch (data.progress) {
                    case 100:
                        ShowPercent(100);
                        setTimeout(() => {
                            clearKeepMoveTimer();
                            prevShow_Clear();
                            MailListRefresh();
                            alert(strLang359);
                        }, 20);
                        break;
                    case -100:
                        alert(strLangKeepMoveNoFromHeader);
                        clearKeepMoveTimer();
                        break;
                    case -200:
                    case -300:
                        alert(`${strLang321}\n${Date.now()}\n${data.progress}`);
                        clearKeepMoveTimer();
                        break;
                    default:
                        if (data.progress > -1) {
                            ShowPercent(data.progress);
                        }
                        keepMoveTimerId = setTimeout(callAjax, 1000);
                }
            }, error : function(e) {
                alert("error. " + e.status);
            }
        });
    }, 500);
}

function refreshUnreadCount() {
    try {
        if (typeof (window.parent.frames.left) != "undefined")
            parent.frames["left"].get_unreadcount();
    } catch (e) {console.log(e);}
}
function deleteWork(bDel) {
    
    if (['pre_h_tag_add', 'pre_w_tag_add'].some(id => {
        var el = document.getElementById(id);
        return el && document.activeElement === el;
    })) return;


    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang42);
        return;
    }
    
    var includeSecureMail = false;
	for (var i = 0; i < listContentArry.length; i++) {
		if (document.getElementById(listContentArry[i]).getAttribute("securemail") == "1") {
			includeSecureMail = true;
	    	break;
	    }
	}
	
    var cmd = "";
    if (bDel == true || g_szRootFolderName.replace(' ', '') == strLang4) {
        cmd = "BDELETE";
        if (includeSecureMail) {
        	if (!confirm(strLangLHM19)) {
        		return;
        	}
        } else {
        	if (!confirm(strLang58)) {
            	return;
            }
        }
        
    }
    else {
        if (g_foldertype == "delete")
            cmd = "SOFTDEL";
        else
            cmd = "BMOVE";
        if (includeSecureMail) {
        	if (!confirm(strLangLHM19)) {
        		return;
        	}
        } else {
        	if (!confirm(strLang59)) {
            	return;
            }
        }
    }
    var szItemID = "";
    for (var i = 0; i < listContentArry.length; i++) {
        szItemID += document.getElementById(listContentArry[i]).getAttribute("_href") + ",";
    }
    for (var i = 0; i < listSubContentArry.length; i++) {
        szItemID += document.getElementById(listSubContentArry[i]).getAttribute("_href") + ",";
    }
    Mail_MoveDeletePostSend(cmd, "", szItemID);
    
    try {
        if (document.getElementById("HeaderAllCheckBox") != null)
            document.getElementById("HeaderAllCheckBox").checked = false;
    } catch (e) {console.log(e);}
}

function deleteUnreadWork() {

    if (searchMode) {
        deleteSearchedAndUnreadMail();
    } else {
        deleteUnreadMail();
    }
}

function deleteUnreadMail() {
    
    try {
        var url = g_moveUrl;
        var trashBoxURL = pDeleteBoxID;
        var cmd = "";
       
        // 지운편지함의 메일 영구삭제
        if (url == trashBoxURL) {
            if (confirm(strUreadDelPermenant)) {
                cmd = "MAILREALDEL";
            } else {
                return;
            }
        }
        // 편지함의 메일 지운편지함으로 이동 
        else {
            if (confirm(strUreadDelChk)) {
                cmd = "MAILDEL";
            } else {
                return;
            }
        }
        
        ShowMailProgress();
                        
        $.ajax({
            cache: false,
            async: false,
            method: 'post',
            url: "/ezEmail/unreadMailDel.do",
            data: { url: url, cmd: cmd, shareId: encodeURIComponent(shareId) },
            success: function(result) {
                if (result === "ok") {
                    alert(strLang215);
                } else {
                    alert(strLang216);
                }
            },
            error: function() {
                alert(strLang216);
            },
            complete : function() {
                HiddenMailProgress();
                MailListRefresh();
            }
        });
   } catch (e) {
       console.log("unread mail delete error");
   }
}

function deleteSearchedAndUnreadMail() {
    var url = g_moveUrl;
    var trashBoxURL = pDeleteBoxID;
    var cmd = "";
   
    // 지운편지함의 메일 영구삭제
    if (url == trashBoxURL) {
        if (!confirm(strUreadDelSearchPermenant)) {
            return;
        }
    }
    // 편지함의 메일 지운편지함으로 이동 
    else {
        if (!confirm(strUreadDelSearch)) {
            return;
        }
    }

	var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    var pOrderyOption = p_ListorderType + " ORDER BY \"" + p_ListOrderby + "\" " + p_ListOrderOption;
    var attachStatus = "all";
	var andorStatus = "and";
	var end = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));
	var secureMailFilter = document.getElementById("select").value == "SECUREMAIL" ? 1 : 0;
	var maxCount = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));
	socketUserkey = mailbox_getUserKey();

	if(mailsearchDetail == "Y"){
		if(document.querySelector("input[name=attachment]:checked").value != null ){
			attachStatus = document.querySelector("input[name=attachment]:checked").value;
		} 

		if(document.querySelector("input[name=andor]:checked").value != null ){
			andorStatus = document.querySelector("input[name=andor]:checked").value;
		}
	}

	var jsonData = {"FOLDERID" : window.tagName ? '' : g_moveUrl,
					"SORTTYPE" : pOrderyOption,
					"SEARCH" : SearchKeyword,
					"KEYWORD" : searchRequiredKeyword,
					"CATEGORY" : searchRequiredCategory,
					"START" : "0",
					"STARTDATE" : startDate,
					"ENDDATE" : endDate,
					"ATTACHSTATUS" : attachStatus,
					"ANDORSTATUS" : andorStatus,
					"VIEWSELECTINDEX" : document.getElementById("select").selectedIndex.toString(),
					"END" : end.toString(),
					"SECUREMAILFILTER" : secureMailFilter.toString(),
					"TAGNAME" : window.tagName ? tagName : "",
					"SHAREDID" : shareId,
					};

 	ShowMailProgress();
      
	$.ajax({
		cache: false,
		method: "post",
		url: "/ezEmail/searchedAndUnreadMailDel.do",
		data: JSON.stringify(jsonData),
		contentType : "application/json",
		complete: function(){
			HiddenMailProgress();
		},
		success: function(result){
			if (result == "ok") {
				alert(strLang215);
			} else {
				alert(strLang216);
			}
		},
		error: function() {
			alert(strLang216);
		},
		complete : function() {
        	HiddenMailProgress();
            MailListRefresh();
		}
	});

    GetListInfo_HeaderObject = HeaderObject;
    GetListInfo_ContentObject = ContentObject;
}

function delAllFile() {
    if (!confirm(strLang333))
        return;	
    showDelAllProgress();
    Mail_MoveDeletePostSend("ALL", "", g_moveUrl);
}
function receiveCheck_onClick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang42);
        return;
    }
    if (listContentArry.length > 1 || listSubContentArry.length > 1) {
        alert(strLang44);
        return;
    }
    var url = "";
    if (listContentArry.length == 1) {
        url = document.getElementById(listContentArry[0]).getAttribute("_href");
    }
    else {
        url = document.getElementById(listSubContentArry[0]).getAttribute("_href");
    }
    
    var requestUrl = "/ezEmail/mailReaderList.do?url=" + encodeURIComponent(url);
    
    if (typeof(shareId) != "undefined" && shareId != "") {
		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	}
    
    var OpenWin = window.open(requestUrl, "mail_readerlist", GetOpenWindowfeature(620, 500));
    try { OpenWin.focus(); } catch (e) {console.log(e);}
}
function ListCount(pCount) {
    document.getElementById("MailList").setAttribute("listpageCount", pCount);
    MailOptionHidden();
    MailListRefresh();
}
var denial_cross_dialogArguments = new Array();
function reject_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang42);
        return;
    }
    var RejectArray = new Array();

    RejectArray = listContentArry.length == 0 ? listSubContentArry : listContentArry;
    var params = new Array();
    params["email"] = new Array();
    params["link"] = new Array();
    for (var n = 0; n < RejectArray.length; n++) {
        const msgto = document.getElementById(RejectArray[n]).querySelectorAll('[data-msgto]')[0].getAttribute('data-msgto');
        const splitAddr = getEmailAddressList(msgto);
        params["email"][n] = quoteEmailName(splitAddr.name[0], splitAddr.email[0]);
        params["link"][n] = "";
    }
    denial_cross_dialogArguments[0] = params;
    denial_cross_dialogArguments[1] = reject_onclick_Complete;
    var OpenWin = window.open("/ezEmail/mailDenial.do", "denial_cross", GetOpenWindowfeature(450, 314));
    try { OpenWin.focus(); } catch (e) {console.log(e);}
}
function reject_onclick_Complete(retVal)
{
    if (typeof (retVal) == "string") {
        if (retVal == "cancel")
            return;
    }
    var xmlpara = createXmlDom();
    var objNode;
    var objRow;
    var objRow2;
    objNode = createNodeInsert(xmlpara, objNode, "DATA");
    objRow = createNodeAndAppandNode(xmlpara, objNode, objRow, "ROW");
    
    if (typeof(shareId) != "undefined" && shareId != "") {
    	 createNodeAndAppandNodeText(xmlpara, objRow, objRow2, "SHAREID", shareId);
    }
    for (var i = 0; i < retVal.length; i++) {
        objRow = createNodeAndAppandNode(xmlpara, objNode, objRow, "ROW");
        createNodeAndAppandNodeText(xmlpara, objRow, objRow2, "DENIAL", retVal[i]);
    }
    var xmlHTTP = new XMLHttpRequest();
    xmlHTTP.open("POST", "/ezEmail/mailRequestDenial.do", false);
    xmlHTTP.setRequestHeader("Content-Type", "text/xml");
    xmlHTTP.send(xmlpara);

    var result = xmlHTTP.responseText;

    result = replaceAll(result, "<DATA><![CDATA[", "");
    result = replaceAll(result, "]]></DATA>", "");

    return result;
}
function replaceAll(pStrContent, pStrOrg, pStrRep) {
    return pStrContent.split(pStrOrg).join(pStrRep);
}
var xmlhttp_mailPreview;
var xmlhttp_mailPreviewObject;
var Old_Preview_Href;
function prevShow() {
    if (!g_bPrevShow)
        return;

    try {
        if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        	var sentDateStr = document.querySelector("#PreContent_Rayer" + pPreviewShow_HOW).getElementsByClassName("sentDateStr")[0];
        	
        	var innerFrame  = document.getElementById("ifrmPreViewW_div");
            document.getElementById("Preview_Header" + pPreviewShow_HOW).style.display = "none";
            
            if (sentDateStr != null) {
            	sentDateStr.style.display = "none";
            }
            
            innerFrame.onload = function () {
            	var innerDoc = innerFrame.contentDocument || innerFrame.contentWindow.document;
            	if (innerDoc.getElementById("ifrmviewEmptyText").innerText == "") {
            		innerDoc.getElementById("ifrmviewEmptyText").innerText = strLangJYH01;
            	}
            }
        }
        else {
            var Preview_Href;
            if (listContentArry.length > 0) {
                Preview_Href = document.getElementById(listContentArry[listContentArry.length - 1]).getAttribute("_href");
                xmlhttp_mailPreviewObject = document.getElementById(listContentArry[listContentArry.length - 1]);
            }
            else {
                Preview_Href = document.getElementById(listSubContentArry[listSubContentArry.length - 1]).getAttribute("_href");
                xmlhttp_mailPreviewObject = document.getElementById(listSubContentArry[listSubContentArry.length - 1]);
            }
            //if (Old_Preview_Href == Preview_Href)
            //    return;
            Old_Preview_Href = Preview_Href;
            var strQuery = "<URL>" + Preview_Href + "</URL>";
            xmlhttp_mailPreview = createXMLHttpRequest();
            
            var previewUrl = "/ezEmail/mailPrevShow.do?MSGFLAG=N";
            
            if (typeof(shareId) != "undefined" && shareId != "") {
            	previewUrl += "&shareId=" + encodeURIComponent(shareId);
            }
            
            xmlhttp_mailPreview.open("POST", previewUrl, true);
            xmlhttp_mailPreview.onreadystatechange = event_xmlhttp_mailPreview_Complete;
            xmlhttp_mailPreview.send(strQuery);
            
            if (pPreviewShow_HOW == "H") {
                window.frames['ifrmPreViewH'].document.write("");
            }
            else {
                window.frames['ifrmPreViewW'].document.write("");
            }            
        }

    } catch (e) {console.log(e);}
}
function event_xmlhttp_mailPreview_Complete() {
    if (xmlhttp_mailPreview != null && xmlhttp_mailPreview.readyState == 4) {
        if (xmlhttp_mailPreview.status >= 200 && xmlhttp_mailPreview.status < 300) {
            var xmlDoc = xmlhttp_mailPreview.responseXML;
            var pUnread = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/UNREAD")[0]);
            var pDate = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/DATE")[0]);
            var pFrom = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/FROM")[0]);
            var pFromemail = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/FROMEMAIL")[0]);
            var pFromname = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/FROMNAME")[0]);
            var pTo = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/TO")[0]);
            var pCc = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/CC")[0]);
            var pBcc = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/BCC")[0]);
            var pSubject = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/SUBJECT")[0]);
            var pHtml = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/HTMLDESCRIPTION")[0]);
            var pImportance = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/IMPORTANCE")[0]);
            var pBlockedMail = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/BLOCKEDMAIL")[0]);
            var pSensitivity = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/SENSITIVITY")[0]);
            var pHasembed = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/HASEMBEDED")[0]);
            var pItemid = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/ITEMID")[0]);
            var pContentClass = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/CONTENTCLASS")[0]);
            var senderProfileImageName = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/SENDERPROFILEIMAGENAME")[0]);
            var pCountryCode = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/COUNTRYCODE")[0]);
            var pMailIP =  getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/COUNTRYIP")[0]);
            var pCountryName =  getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/COUNTRYNAME")[0]);
            var pTags =  getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/TAGS")[0]);
            
            if (pBlockedMail == '1') {
                alert(strLangLDH07);
                return;
            }
            
            if (pPreviewShow_HOW == "H") {
                PrevViewFormH.iptURL.value = pItemid;
                PrevViewFormH.submit();
            }
            else {
                PrevViewFormW.iptURL.value = pItemid;
                PrevViewFormW.submit();
            }

            var pMailReceiver = pTo;
            var pReceiverArray = pMailReceiver.split(";");
            var pReceiverHtml = "";
            var pReceiverSubHtml = "";
            var pReceiverDetailDisplay = false;
            var pReceiverDetailHtml = "";
            var pMailSenderHtml = "";
            var pReceiverCnt = 0;
            for (var Cnt = 0; Cnt < pReceiverArray.length; Cnt++) {
                var pReceiver_ = pReceiverArray[Cnt].replace(/"/g, "");
                if (pReceiver_.length > 10) {
                    var Pos1 = pReceiver_.indexOf("<");
                    var Pos2 = pReceiver_.indexOf(">");
                    var pReceiver_Name = TrimText(pReceiver_.substring(0, Pos1));
                    var pReceiver_Address = TrimText(pReceiver_.substring(Pos1 + 1, Pos2));
                    
                    if (pReceiver_Address.indexOf("@") == -1) {
                        // @가 없으면 정상적인 이메일 주소가 아니므로 이름하고 동일한 값을 표시한다.
                        pReceiver_Address = pReceiver_Name;
                    }
                    
                    if (Cnt == 0) {
                        pReceiverHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pReceiver_Address) + "' onclick='show_personinfo(\"" + pReceiver_Address + "\")'>\"" + pReceiver_Name  + " &lt;" + pReceiver_Address + "&gt;" + "\"</span>";
                        
                    }

                    if (pReceiverDetailHtml != "")
                        pReceiverDetailHtml += "&nbsp;,&nbsp;";
                    pReceiverDetailHtml += "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pReceiver_Address) + "' onclick='show_personinfo(\"" + pReceiver_Address + "\")'>\"" + pReceiver_Name + " &lt;" + pReceiver_Address + "&gt;" + "\"</span>";
                    if (g_useremail == pReceiver_Address) {
                        pReceiverHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pReceiver_Address) + "' onclick='show_personinfo(\"" + pReceiver_Address + "\")'>\"" + pReceiver_Name + " &lt;" + pReceiver_Address + "&gt;" + "\"</span>";
                    }

                    pReceiverCnt++;
                }
            }
            if (pReceiverCnt >= 2) {
                document.getElementById("PreH_ReceiverDetail").style.display = ""; 
                document.getElementById("PreH_ReceiverDetail").className = "icon_graydown";
                document.getElementById("PreW_ReceiverDetail").style.display = "";
                document.getElementById("PreW_ReceiverDetail").className = "icon_graydown";
                pReceiverSubHtml = "(" + strLang156 + pReceiverCnt + strLang300 + ")";
                pReceiverDetailDisplay = true;
            } else {
                document.getElementById("PreH_ReceiverDetail").style.display = "none";
                document.getElementById("PreW_ReceiverDetail").style.display = "none";
                
                pReceiverSubHtml = "";
                pReceiverDetailDisplay = false;
                if (pReceiverHtml == "") {
                    pReceiverHtml = pReceiverDetailHtml;
                }

            }

            document.getElementById("PreH_CCMain").style.display = "none";
            document.getElementById("PreW_CCMain").style.display = "none";
            document.getElementById("PreH_CCDetail").style.display = "none";
            document.getElementById("PreW_CCDetail").style.display = "none";
            var pCcHtml = "";
            var pCcSubHtml = "";
            var pCcDetailHtml = "";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
            document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 110) + "px";
            if (pCc != "") {
                var pMailCc = pCc;
                var pCcArray = pMailCc.split(";");
                var pCcDetailDisplay = false;
                var pMailSenderHtml = "";
                var pCcCnt = 0;
                for (var Cnt = 0; Cnt < pCcArray.length; Cnt++) {
                    var pCc_ = pCcArray[Cnt].replace(/"/g, "");
                    if (pCc_.length > 10) {
                        var Pos1 = pCc_.indexOf("<");
                        var Pos2 = pCc_.indexOf(">");
                        var pCc_Name = TrimText(pCc_.substring(0, Pos1));
                        var pCc_Address = TrimText(pCc_.substring(Pos1 + 1, Pos2));
                        
                        if (Cnt == 0) {
                            pCcHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pCc_Address) + "' onclick='show_personinfo(\"" + pCc_Address + "\")'>\"" + pCc_Name + "\"</span>";

                        }

                        if (pCcDetailHtml != "")
                            pCcDetailHtml += "&nbsp;,&nbsp;";
                        pCcDetailHtml += "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pCc_Address) + "' onclick='show_personinfo(\"" + pCc_Address + "\")'>\"" + pCc_Name + "\"</span>";
                        if (g_useremail == pCc_Address) {
                            pCcHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pCc_Address) + "' onclick='show_personinfo(\"" + pCc_Address + "\")'>\"" + pCc_Name + "\"</span>";
                        }

                        pCcCnt++;
                    }
                }
                if (pCcCnt >= 2) {
                    document.getElementById("PreH_CCDetail").style.display = "";
                    document.getElementById("PreH_CCDetail").className = "icon_graydown";
                    document.getElementById("PreW_CCDetail").style.display = "";
                    document.getElementById("PreW_CCDetail").className = "icon_graydown";
                    pCcSubHtml = "(" + strLang156 + pCcCnt + strLang300 + ")";
                    pCcDetailDisplay = true;
                } else {
                    document.getElementById("PreH_CCDetail").style.display = "none";
                    document.getElementById("PreW_CCDetail").style.display = "none";

                    pCcSubHtml = "";
                    pCcDetailDisplay = false;
                    if (pCcHtml == "") {
                        pCcHtml = pCcDetailHtml;
                    }

                }
                if (pPreviewShow_HOW == "H") {                    
                    document.getElementById("PreH_CCMain").style.display = "";
                } else {
                    document.getElementById("PreW_CCMain").style.display = "";
                }
                $("#ifrmPreViewH").height($("#ifrmPreViewH").height()-20);
                $("#ifrmPreViewW").height($("#ifrmPreViewW").height()-20);
            }
            
            var pOCS = "";
            if (USE_OCS == "YES") {
                pOCS = "<img src='/images/presence/unknown.gif' id='" + GetGUID() + "' onload=\"PresenceControl('" + pFromemail + "',this);\" style='vertical-align:middle;padding-right:5px;'/>";
            }
            
            if(pFromname == ""){
            	pMailSenderHtml = pOCS + "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pFromemail) + "' onclick='show_personinfo(\"" + pFromemail + "\")'>&nbsp;</span>";
            } else {
            	pMailSenderHtml = pOCS + "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pFromemail) + "' onclick='show_personinfo(\"" + pFromemail + "\")'>\"" + pFromname + " &lt;" + pFromemail + "&gt;" + "\"</span>";
            	
            	if (useCountryIP == "YES" ) {
            		pMailSenderHtml += "<span title=" + pCountryName + ">"
            		if (useShowSystemCountry == "YES") {
            			if (pCountryCode != "") {
            				if (pCountryCode == "unknown") {
            					pCountryCode = "qm";
            				}
            				pMailSenderHtml += "<img src='/images/countryIcon/" + pCountryCode.toLowerCase() + ".png' style='vertical-align: middle; padding: 0px 0px 3px;'> " ;  
            			}
                		         		
            		} else {
            			if (pCountryCode != "") {
            				if (systemCountryCode != pCountryCode) {
            					if (pCountryCode == "unknown") {
            						pCountryCode = "qm";
            					}
            					pMailSenderHtml += "<img src='/images/countryIcon/" + pCountryCode.toLowerCase() + ".png' style='vertical-align: middle; padding: 0px 0px 3px;'> " ;  
            				}
            			}
            		}
            		if (pMailIP != null && pMailIP != "") {
            			pMailSenderHtml += "<span> ( " + pMailIP + " ) </span>";
            		}
            		pMailSenderHtml += "</span>";
            		
            	} 
            }

            //pMailSenderHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pFromname) + "' onclick='show_personinfo(\"" + pFromemail + "\")'>\"" + ConvertStringForHTML(pFromname) + "\"</span>";

            if (pPreviewShow_HOW == "H") {
                document.getElementById("PreH_subject").setAttribute("itemid", pItemid);
                document.getElementById("PreH_subject").setAttribute("_contentclass", pContentClass);
                document.getElementById("PreH_MailReceiverDetail_Rayer").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
                document.getElementById("PreH_sub_subject").innerHTML = pSubject;
                var preTitle = document.getElementById('PreH_sub_subject').innerText;
                document.getElementById("PreH_subject").setAttribute("title", preTitle);
                //kms
                pSubject = pSubject.trim();
                if(pSubject == ""){
                	document.getElementById("PreH_sub_subject").innerHTML = strLang97;
                }
                document.getElementById("PreH_subject").style.display = "";
                document.getElementById("PreH_date").innerHTML = pDate;
                document.getElementById("PreH_MailReceiver").innerHTML = pReceiverHtml;
                document.getElementById("PreH_MailReceiver_sub").innerHTML = pReceiverSubHtml;
                document.getElementById("PreH_MailReceiverDetail").innerHTML = pReceiverDetailHtml;
                document.getElementById("PreH_MailCC").innerHTML = pCcHtml;
                document.getElementById("PreH_MailCC_sub").innerHTML = pCcSubHtml;
                document.getElementById("PreH_MailCCDetail").innerHTML = pCcDetailHtml;
                document.getElementById("PreH_sub_MailSender").innerHTML = pMailSenderHtml;
                
                var picNone = "/images/kr/main/bestEmployee_pic_none.png";
                document.getElementById("preHSenderImage").src = (senderProfileImageName !== "")? "/admin/ezOrgan/getPersonalInfo.do?fileName=" + senderProfileImageName : picNone;
                document.getElementById("preHSenderImage").setAttribute('onerror', "this.src='" + picNone + "'");

				if (useMailTag) {
					document.getElementById("pre_h_tag_add").value = "";
					document.getElementById("pre_h_tag_view").innerHTML = "";
					if (pTags) {
						pTags.split("|").forEach(function(tagName) { appendTag(tagName,"pre_h_tag_view"); });
					}
				}
            } else {
                document.getElementById("PreW_subject").setAttribute("itemid", pItemid);
                document.getElementById("PreW_subject").setAttribute("_contentclass", pContentClass);
                document.getElementById("PreW_MailReceiverDetail_Rayer").style.display = "none";
                document.getElementById("Preview_HeaderW").style.display = "";
                document.getElementById("PreW_sub_subject").innerHTML = pSubject;
                pSubject = pSubject.trim();
                if(pSubject == ""){
                	document.getElementById("PreW_sub_subject").innerHTML = strLang97;
                }
                document.getElementById("PreW_subject").style.display = "";
                document.getElementById("PreW_date").innerHTML = pDate;
                document.getElementById("PreW_MailReceiver").innerHTML = pReceiverHtml;
                document.getElementById("PreW_MailReceiver_sub").innerHTML = pReceiverSubHtml;
                document.getElementById("PreW_MailReceiverDetail").innerHTML = pReceiverDetailHtml;
                document.getElementById("PreW_MailCC").innerHTML = pCcHtml;
                document.getElementById("PreW_MailCC_sub").innerHTML = pCcSubHtml;
                document.getElementById("PreW_MailCCDetail").innerHTML = pCcDetailHtml;
                document.getElementById("PreW_sub_MailSender").innerHTML = pMailSenderHtml;
                
                var picNone = "/images/kr/main/bestEmployee_pic_none.png";
                document.getElementById("preWSenderImage").src = (senderProfileImageName !== "")? "/admin/ezOrgan/getPersonalInfo.do?fileName=" + senderProfileImageName : picNone;
                document.getElementById("preWSenderImage").setAttribute('onerror', "this.src='" + picNone + "'");

				if (useMailTag) {
					document.getElementById("pre_w_tag_add").value = "";
					document.getElementById("pre_w_tag_view").innerHTML = "";
					if (pTags) {
						pTags.split("|").forEach(function(tagName) { appendTag(tagName,"pre_w_tag_view"); });
					}
				}
            }
            MailList_ChangeStatus(xmlhttp_mailPreviewObject);
            xmlhttp_mailPreviewObject = null;
            xmlhttp_mailPreview = null;
        }
    }
}
function MailList_ChangeStatus(obj) {
    if (obj.getAttribute("read") == "0") {
        if (obj.getAttribute("_contentclass") == "IPM.Note") {
            if(p_HeaderViewXML.indexOf("viewXMLFile1_1.xml") > 0)
                obj.childNodes.item(1).childNodes.item(0).src = "/images/ImgIcon/icon-msg-read.gif";
            else
                obj.childNodes.item(2).childNodes.item(0).src = "/images/ImgIcon/icon-msg-read.gif";
        }
        for (var i = 0; i < obj.childNodes.length; i++) {
            obj.childNodes.item(i).style.fontWeight = "";
        }
        obj.setAttribute("read", "1");
        try{
            parent.frames["left"].get_unreadcount();}catch(e){console.log(e);}
    }
}
function prevShow_Clear() {
    if (pPreviewShow_HOW == "W") {
    	var sentDateStr = document.body.querySelector("#PreContent_RayerW #sentDateStr");
        document.getElementById("Preview_HeaderW").style.display = "none";
        document.getElementById("ifrmPreViewW").src = strLangLHM18;
        
        if (sentDateStr != null) {
        	sentDateStr.style.display = "none";
        }
        
        var innerFrame  = document.getElementById("ifrmPreViewW");
        innerFrame.onload = function () {
        	var innerDoc = innerFrame.contentDocument || innerFrame.contentWindow.document;
        	if (innerDoc.getElementById("ifrmviewEmptyText").innerText == "") {
        		innerDoc.getElementById("ifrmviewEmptyText").innerText = strLangJYH01;
        	}
        }
    }
    else {
    	var sentDateStr = document.body.querySelector("#PreContent_RayerH #sentDateStr");
        document.getElementById("Preview_HeaderH").style.display = "none";
        document.getElementById("ifrmPreViewH").src = strLangLHM18;
        
        if (sentDateStr != null) {
        	sentDateStr.style.display = "none";
        }
        
        var innerFrame  = document.getElementById("ifrmPreViewH");
        innerFrame.onload = function () {
        	var innerDoc = innerFrame.contentDocument || innerFrame.contentWindow.document;
        	if (innerDoc.getElementById("ifrmviewEmptyText").innerText == "") {
        		innerDoc.getElementById("ifrmviewEmptyText").innerText = strLangJYH01;
        	}
        }
    }
}
function ReceiverDetail_view(obj) {
    if (obj.className == "icon_graydown") {
        obj.className = "icon_grayup"
        if (pPreviewShow_HOW == "W")
            document.getElementById("PreW_MailReceiverDetail_Rayer").style.display = "";
        else
            document.getElementById("PreH_MailReceiverDetail_Rayer").style.display = "";
    }
    else {
        obj.className = "icon_graydown"
        if (pPreviewShow_HOW == "W")
            document.getElementById("PreW_MailReceiverDetail_Rayer").style.display = "none";
        else
            document.getElementById("PreH_MailReceiverDetail_Rayer").style.display = "none";
    }
    
    mailPrevIframeSize();
}
function CCDetail_view(obj) {
    if (obj.className == "icon_graydown") {
        obj.className = "icon_grayup"
        if (pPreviewShow_HOW == "W")
            document.getElementById("PreW_MailCCDetail_Rayer").style.display = "";
        else
            document.getElementById("PreH_MailCC_Rayer").style.display = "";
    }
    else {
        obj.className = "icon_graydown"
        if (pPreviewShow_HOW == "W")
            document.getElementById("PreW_MailCCDetail_Rayer").style.display = "none";
        else
            document.getElementById("PreH_MailCC_Rayer").style.display = "none";
    }
    
    mailPrevIframeSize();
}
function show_personinfo(email) {
    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 450);
    window.open("/ezCommon/showPersonInfo.do?email=" + encodeURIComponent(email), "", feature);
}
function MailReadOpen() {
    var pItemID;
    var pContentclass;
    if (pPreviewShow_HOW == "W") {
        pItemID = document.getElementById("PreW_subject").getAttribute("itemid");
        pContentclass = document.getElementById("PreW_subject").getAttribute("_contentclass");
    }
    else {
        pItemID = document.getElementById("PreH_subject").getAttribute("itemid");
        pContentclass = document.getElementById("PreH_subject").getAttribute("_contentclass");
    }
    callMsgDlg(pContentclass, pItemID);
}
var isPreviewChange = false;
function PreviewRayerChange(pGubun) {
    try {
        if (pPreviewShow_HOW == pGubun)
            return;
        
        isPreviewChange = true;
        if (pGubun == "NONE") {
            pPreviewShow_HOW = "OFF";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "none";
            CurrentHeight = document.documentElement.clientHeight - 92 - (document.getElementById("mainmenu").clientHeight - 28);
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = "100%";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
            else
                document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
            g_bPrevShow = false;
            
            CurrenWidth = document.documentElement.clientWidth - 20;
            if (!useReceivingChk) {
	            if (CurrenWidth < 470) {
	                BasicViewHeaderChange(true, g_foldertype);
	            } else {
	                BasicViewHeaderChange(false, g_foldertype);
	            }
            }
        }
        else if (pGubun == "W") {
            if (pMailListDiv == 0 || pMailPreVDiv == 0) {
                pMailListDiv = 50; pMailPreVDiv = 50;
            }
            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerW").style.display = "block";
            document.getElementById("PreviewRayerH").style.display = "none";

            CurrenWidth = document.documentElement.clientWidth - 10;
            CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10) + "px";
            pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
            pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
            document.getElementById("MailListRayer").style.width = "100%";
            document.getElementById("PreviewRayerW").style.width = "100%";
            document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("contentlist").style.height = (pMailListHeightW - 100) + "px";
            else
                document.getElementById("contentlist").style.height = (pMailListHeightW - 100) + "px";
//            document.getElementById("PreviewRayerW").style.height = pMailPreHeightW + "px";
            document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 80) + "px";
            document.getElementById("PreW_subject").style.width = (CurrenWidth - 155) + "px";
            
            pPreviewShow_HOW = "W";
            pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
            pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);
            g_bPrevShow = true;
            if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT" && p_ListorderValue != "RECEIV") {
                //if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                    if (!useReceivingChk) {
                    //if (g_foldertype != "sent") {
                        CurrenWidth = document.documentElement.clientWidth - 20;
                        
                        if (CurrenWidth < 470) {
                            BasicViewHeaderChange(true, g_foldertype);
                        } else {
                            BasicViewHeaderChange(false, g_foldertype);
                        }
                        /*if (p_HeaderViewXML.indexOf("viewXMLFile1_1.xml") > 0) {
                            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
                            var HeaderObject = document.getElementById("MailHeader");
                            var ContentObject = document.getElementById("MailList");
                            HeaderIni(HeaderObject);
                            s(HeaderObject, ContentObject);
                        }*/
                    }
                //}
            }
        }
        else if (pGubun == "H") {
            if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                pMailListDiv_H = 50; pMailPreVDiv_H = 50;
            }
            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "inline-block";

            CurrenWidth = document.documentElement.clientWidth - 20;
            CurrentHeight = document.documentElement.clientHeight - 92 - (document.getElementById("mainmenu").clientHeight - 28);
            pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
            pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

            if(CurrenWidth < (pMailListWidthH + pMailPreWidthH))
            {
                if (pMailListWidthH > parseInt(CurrenWidth * 0.40)) {
                    pMailListWidthH = pMailListWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
                else {
                    pMailPreWidthH = pMailPreWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
            }

            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
            else
                document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
            document.getElementById("PreviewRayerH").style.width = pMailPreWidthH + "px";
            document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 2 + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
            document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 152) + "px";
            
            pPreviewShow_HOW = "H";
            g_bPrevShow = true;
            if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT" && p_ListorderValue != "RECEIV") {
                //if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                	// if (g_foldertype != "sent") {
                        
            		if (!useReceivingChk) {
                        pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));

                        if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                            pMailListWidthH = parseInt(CurrenWidth * 0.40);
                        }
            			
                        if (pMailListWidthH < 470) {
                            BasicViewHeaderChange(true, g_foldertype);
                        } else {
                            BasicViewHeaderChange(false, g_foldertype);
                        }
                		
                		/*if (p_HeaderViewXML.indexOf("viewXMLFile1.xml") > 0) {
                            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1_1.xml";
                            var HeaderObject = document.getElementById("MailHeader");
                            var ContentObject = document.getElementById("MailList");
                            HeaderIni(HeaderObject);
                            GetListInfo(HeaderObject, ContentObject);
                        }*/
                    }
                //}
            }
        }
    	isScrollMailList();
        MailOptionHidden();
        PreviewMode_ChangeBtn();
        isPreviewChange = false;
        
        mailGeneralSave();
        
        if (g_bPrevShow)
            prevShow();
    } catch (e) {console.log(e);}
}


function Window_resize() {
    try {
    	document.getElementById("layer_popup").style.left = document.documentElement.clientWidth - 260 + "px";
        document.getElementById("layer_popup").style.top = "100px";

        if (!isPreviewChange) {
        	
        	/* 단암 일정사이즈 이하로 width가 줄어도 좌우 미리보기 유지 
            if (parseInt(document.documentElement.clientWidth) < 1000) {
            	document.getElementById("PreViewleft").style.display = "none";
            	pPreviewShow_HOW = "W";
            }
            else {
                document.getElementById("PreViewleft").style.display = "";
            } */
        	
            if (pPreviewShow_HOW == "W") {
                
            	if (pMailListDiv == 0 || pMailPreVDiv == 0) {
                    pMailListDiv = 50; pMailPreVDiv = 50;
                }
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerW").style.display = "block";
                document.getElementById("PreviewRayerH").style.display = "none";

                CurrenWidth = document.documentElement.clientWidth - 10;
                CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = (CurrenWidth + 10) + "px";
                pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
                pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
                document.getElementById("MailListRayer").style.width = "100%";
                document.getElementById("PreviewRayerW").style.width = "100%";
                document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
                
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("contentlist").style.height = (pMailListHeightW - 100) + "px";
                else
                    document.getElementById("contentlist").style.height = (pMailListHeightW - 100) + "px";
//                document.getElementById("PreviewRayerW").style.height = pMailPreHeightW + "px";
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 110) + "px";
                document.getElementById("PreW_subject").style.width = (CurrenWidth - 155) + "px";
                
                pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
                pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);
                
                if($("#PreW_CCMain").css("display") != "none") {
                	$("#ifrmPreViewW").height($("#ifrmPreViewW").height()-20);
                }
                
                mailPrevIframeSize();
                

                CurrenWidth = document.documentElement.clientWidth - 20;
                if (!useReceivingChk) {
	                if (CurrenWidth < 470) {
	                    BasicViewHeaderChange(true, g_foldertype);
	                } else {
	                    BasicViewHeaderChange(false, g_foldertype);
	                }
                }
            }
            else if (pPreviewShow_HOW == "H") {
            	if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                    pMailListDiv_H = 50; pMailPreVDiv_H = 50;
                }
            	
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerW").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "inline-block";

                CurrenWidth = document.documentElement.clientWidth - 20;
                CurrentHeight = document.documentElement.clientHeight - 92 - (document.getElementById("mainmenu").clientHeight - 28);
                pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
                pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

                if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                    var ChangeListWidthDiv = parseInt(CurrenWidth * 0.40) - pMailListWidthH;
                    pMailListWidthH = parseInt(CurrenWidth * 0.40);
                    pMailPreWidthH = pMailPreWidthH - ChangeListWidthDiv;
                }
                
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
                document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
                
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
                else
                    document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
                
                document.getElementById("PreviewRayerH").style.width = pMailPreWidthH - 10 + "px";
                document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 2 + "px";
                document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
                document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 152) + "px";
                
                /* 좌우 리사이징 시 round로 인해 비율의 합이 100%가 되지 않아
                   오른쪽 끝에 여백이 발생하여 제거함
                pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
                pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
                */
                
                // 화면 폭이 일정 크기보다 작아지면 헤더 구성을 변경한다.
                // 중요도, 책갈피, 첨부파일, 크기 컬럼을 제거한다.
                if (!useReceivingChk) {
	                if (pMailListWidthH < 470) {
	                    BasicViewHeaderChange(true, g_foldertype);
	                } else {
	                    BasicViewHeaderChange(false, g_foldertype);
	                }
                }
	                
                if($("#PreH_CCMain").css("display") != "none") {
                	$("#ifrmPreViewH").height($("#ifrmPreViewH").height()-20);
                }
                
                mailPrevIframeSize();
            }
            else if (pPreviewShow_HOW == "OFF") {
                document.getElementById("PreviewRayerW").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "none";
                CurrentHeight = document.documentElement.clientHeight - 92 - (document.getElementById("mainmenu").clientHeight - 28);
                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = "100%";
                
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
                else
                    document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
                
                CurrenWidth = document.documentElement.clientWidth - 20;

                if (!useReceivingChk) {
	                if (CurrenWidth < 470) {
	                    BasicViewHeaderChange(true, g_foldertype);
	                } else {
	                    BasicViewHeaderChange(false, g_foldertype);
	                }
                }
            }
        }            
    } catch (e) {console.log(e);}
}
function CustomRandom() {
    var now = new Date();
    var seed = now.getMilliseconds();
    return Math.random(seed) + 1;
}
function s4() {
    return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
};

var ReadMailOpenNewWin;	
function callMsgDlg(szContentClass, Href) {
    if (szContentClass == "IPM.Appointment") {
        var xmlHTTP = createXMLHttpRequest();
        var xmlDoc = createXmlDom();
        var rootNode;
        createNodeInsert(xmlDoc, rootNode, "DATA");
        createNodeAndInsertText(xmlDoc, rootNode, "ITEMID", Href);
        xmlHTTP.open("POST", "/myoffice/ezEmail/remote/mail_convertid.aspx", false);
        xmlHTTP.send(xmlDoc);
        var scheduleid = "";
        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
            scheduleid = xmlHTTP.responseText;
        }
        var feature = "height = 660px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
        feature = feature + GetOpenPosition(770, 660);
        window.open("/myoffice/ezSchedule/schedule_read_Cross.aspx?id=" + encodeURIComponent(scheduleid), "",
                feature);
        return;
    }
    // var pheight = window.outerHeight;
    var conHeight = 720;
    var pwidth = window.outerWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > minimumWidth)
        conWidth = minimumWidth;
    // var pTop = (pheight - conHeight) / 2;
    // var pLeft = (pwidth - minimumWidth) / 2;
    var pLeft = window.outerWidth / 2 + window.screenX - (conWidth / 2);
    var pTop = window.outerHeight / 2 + window.screenY - (conHeight / 2);
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1";
    if (!g_bdraft) {
        var pURI = "/ezEmail/mailRead.do?iptURL=" + encodeURIComponent(Href) + "&PNFlag=Y&CONTENTCLASS=" + encodeURIComponent(szContentClass);
        
        if (typeof(shareId) != "undefined" && shareId != "") {
        	pURI += "&shareId=" + encodeURIComponent(shareId);
        }
        
        ReadMailOpenNewWin = window.open(pURI, "", feature);
        
        if (ReadMailOpenNewWin != null) {
        	ReadMailOpenNewWin.focus();
        }
    }
    else {
    	if (typeof(shareId) != "undefined" && shareId != "") {
    		if (sendPermission == "Y") {
    			var pURI = "/ezEmail/mailWrite.do?cmd=EDIT&URL=" + encodeURIComponent(Href) + "&shareId=" + encodeURIComponent(shareId);
            	
            	ReadMailOpenNewWin = window.open(pURI, "", feature);
            	
            	if (ReadMailOpenNewWin != null) {
                	ReadMailOpenNewWin.focus();
                }
    		} else {
    			alert(strLangKSA02);
    		}
    	} else {
    		var pURI = "/ezEmail/mailWrite.do?cmd=EDIT&URL=" + encodeURIComponent(Href);
        	
        	ReadMailOpenNewWin = window.open(pURI, "", feature);
        	
        	if (ReadMailOpenNewWin != null) {
            	ReadMailOpenNewWin.focus();
            }
    	}
    }
}

function callMsgDlgAppr(href, type) {
    var pheight = window.screen.availHeight;
    var conHeight = 720;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 1200)
        conWidth = 1200;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 1200) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1";

    var pURI = "/ezEmail/mailApprRead.do?URL=" + encodeURIComponent(href);
    if (type) {
        pURI += "&type=" + encodeURIComponent(type);
    }

    ReadMailOpenNewWin = window.open(pURI, "", feature);

    if (ReadMailOpenNewWin != null) {
        ReadMailOpenNewWin.focus();
    }
}

var PcSaveArrayList = new Array();
function mail_export() { // 전체메일 구분하기 위해 함수 분리
    mail_export_exec(false);
}

function mail_export_exec(isAllMail) {
	var type = "MAIL";
	
	if (listContentArry.length == 0 && listSubContentArry.length == 0 && searchMode) {
		if (!confirm(strLangLS02)) {
        	return;
        } else {
			if (!confirm(strLangLS03)) {
				return;
			} else {
				try {
	            	setTimeout(function() {
		            searchedMailExportZip();
			        }, 1000);
		        } catch (e) {
		           	console.log("searchedMailExportZip error!");
		        }
			}
		}
	} else if (listContentArry.length == 0 && listSubContentArry.length == 0 && !isAllMail) {
        if (!confirm(strLangLS01)) {
        	return;
        } else {
			try {
            	setTimeout(function() {
	            mailbox_export();
		        }, 1000);
	        } catch (e) {
	           	console.log("mailbox_export error!");
	        }
		}
    } else {
        PcSaveArrayList = new Array();
       
        for (var i = 0; i < listContentArry.length; i++) {
            PcSaveArrayList[PcSaveArrayList.length] = document.getElementById(listContentArry[i]);
        }
        
        for (var i = 0; i < listSubContentArry.length; i++) {
            PcSaveArrayList[PcSaveArrayList.length] = document.getElementById(listSubContentArry[i]);
        }
        
        if (PcSaveArrayList.length === 0 && isAllMail) {
            alert(strLangAllmailSaveAlert);
            return;
        }

		if (useEncryptZipForEmail == "YES") {
			mailExportOption_onClick(type);
		} else {
			mailExport_start();
		}
	}
	
	// 20200428 조진호 - 메일 리스트에서 체크박스를 이용한 행위 뒤 체크박스가 풀리도록 추가
    if (listContentArry.length > 0) {
        for (var i = 1; i <= listContentArry.length; i++) {
            document.getElementById(listContentArry[listContentArry.length - i]).children[0].children[0].checked = false;
        }
    }
    try {
        if (document.getElementById("HeaderAllCheckBox") != null)
            document.getElementById("HeaderAllCheckBox").checked = false;
    } catch (e) {console.log(e);}
    
    MailListRefresh();
    
}

function mailExport_start(pwd){
	var encryptPw = "";
	var folderIdAndMessageIdList = new Object();
	
	if (typeof pwd != "undefined") {
		encryptPw = pwd;
	}
	
	if (PcSaveArrayList.length == 1 && encryptPw == "") {
		var parameters = "url=" + encodeURIComponent(PcSaveArrayList[0].getAttribute("_href"));
		var fullpath = "/ezEmail/mailExport.do?" + parameters;
		
		if (typeof(shareId) != "undefined" && shareId != "") {
			fullpath += "&shareId=" + encodeURIComponent(shareId);
    	}
		
		AttachDownFrame.location.href = fullpath;
		AttachDownFrame.target = "_blank";
		
	} else {
		
		for (var i = 0; i < PcSaveArrayList.length; i++) {
			var folderIdAndMessageId = PcSaveArrayList[i].getAttribute("_href").split("/");
			
			if (folderIdAndMessageIdList[folderIdAndMessageId[0]] == undefined) {
				folderIdAndMessageIdList[folderIdAndMessageId[0]] = folderIdAndMessageId[1];
			} else {
				folderIdAndMessageIdList[folderIdAndMessageId[0]] += "," + folderIdAndMessageId[1];
			}
		}
		
		ShowMailProgress();
		
		var requestUrl = "/ezEmail/mailExportZip.do";
		
		if (typeof(shareId) != "undefined" && shareId != "") {
			requestUrl += "?shareId=" + encodeURIComponent(shareId);
    	}
		
		$.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : requestUrl,
			data : folderIdAndMessageIdList,
			complete: function(){
				HiddenMailProgress();
			},
			success: function(result){
				
				if (result != "") {
					var fullpath = "/ezEmail/downloadMailZip.do?temp=" + result + "&encryptPw=" + encryptPw;
					
					if (typeof(shareId) != "undefined" && shareId != "") {
						fullpath += "&shareId=" + encodeURIComponent(shareId);
			    	}
					
					AttachDownFrame.location.href = fullpath;
					AttachDownFrame.target = "_blank";
				} else {
					alert(strLang104);
				}
				
			}
		});
	}
	
}

function searchedMailExportZip() {
	var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    var pOrderyOption = p_ListorderType + " ORDER BY \"" + p_ListOrderby + "\" " + p_ListOrderOption;
    var attachStatus = "all";
	var andorStatus = "and";
	var end = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));
	var secureMailFilter = document.getElementById("select").value == "SECUREMAIL" ? 1 : 0;
	var maxCount = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));
	socketUserkey = mailbox_getUserKey();

	if(mailsearchDetail == "Y"){
		if(document.querySelector("input[name=attachment]:checked").value != null ){
			attachStatus = document.querySelector("input[name=attachment]:checked").value;
		} 

		if(document.querySelector("input[name=andor]:checked").value != null ){
			andorStatus = document.querySelector("input[name=andor]:checked").value;
		}
	}

	var jsonData = {"FOLDERID" : window.tagName ? '' : g_moveUrl,
					"SORTTYPE" : pOrderyOption,
					"SEARCH" : SearchKeyword,
					"KEYWORD" : searchRequiredKeyword,
					"CATEGORY" : searchRequiredCategory,
					"START" : "0",
					"STARTDATE" : startDate,
					"ENDDATE" : endDate,
					"ATTACHSTATUS" : attachStatus,
					"ANDORSTATUS" : andorStatus,
					"VIEWSELECTINDEX" : document.getElementById("select").selectedIndex.toString(),
					"END" : end.toString(),
					"SECUREMAILFILTER" : secureMailFilter.toString(),
					"TAGNAME" : window.tagName ? tagName : "",
					"SHAREDID" : shareId,
					"MAXCOUNT" : maxCount,
					"USERKEY" : socketUserkey
					};

    var _url = "/ezEmail/searchedMailExportZip.do";
 
 	ShowMailProgressNew();
	ShowPercent(0);
	mailboxProgressFun(true, socketUserkey, (progress, state, stateDescription) => {
        if (!state) {
            return;
        }

        if (state === "CANCEL") {
            HiddenMailProgress();
            mailboxProgressFun(false);
            return;
        }

        if (state === "SUCCESS") {
            var fullpath = "/ezEmail/downloadMailZip.do?temp=" + stateDescription + "&encryptPw=" + "";

            if (typeof(shareId) != "undefined" && shareId != "") {
                fullpath += "&shareId=" + encodeURIComponent(shareId);
            }

            AttachDownFrame.location.href = fullpath;
            AttachDownFrame.target = "_blank";
        } else {
            alert(strLang104);
        }

        HiddenMailProgressNew();
        mailboxProgressFun(false);
    });
      
	$.ajax({
		cache: false,
		method: "post",
		url: _url,
		data: JSON.stringify(jsonData),
		contentType : "application/json",
		error: function() {
			alert(strLang321);
		}
	});

    GetListInfo_HeaderObject = HeaderObject;
    GetListInfo_ContentObject = ContentObject;
}

function HiddenContextMenu() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("ContextMenuDiv").style.display = "none";
	if (window.currentFixingId) {
		currentFixingId = null;
	}
}
function ContextMenuHidden() {
    if (document.getElementById("ContextMenuDiv").style.display == "")
        HiddenContextMenu();
    
    if (document.getElementById("mailPanel").style.display == "")
    	HiddenContextMenu();
    
    if (parent.frames["left"].document.getElementById("folderMenuDiv").style.display == "") {
    	parent.frames["left"].document.getElementById("folderPanel").style.display = "none";
    	parent.frames["left"].document.getElementById("folderMenuDiv").style.display = "none";
    }
    if(document.getElementById("moreSearch").style.display != "none"){
	    $("#moreSearch").css("display", "none");   
	    $("#searchButton").css("display", "none");   
	    document.getElementsByName("keyword")[0].disabled = false;
	    document.getElementById("searchCheck").disabled = false;
	    document.getElementById("searchCheck").style.backgroundColor="rgb(255,255,255)";
    }
}
function PopUpPreMail() {
    
    var CurrentObject;
    var isMainlist = false;
    if (_RowObject != null) {
        CurrentObject = _RowObject;
        isMainlist = true;
    }
    else {
        CurrentObject = _SubRowObject;
        isMainlist = false;
    }
    if (isMainlist) {
        var isCurrentCnt = parseInt(CurrentObject.getAttribute("id").replace("Maillist_", ""));
        var ContentObject = document.getElementById("MailList");
        var CurrentPageSize = ContentObject.getAttribute("listpagecount")
        var CurrentPage = ContentObject.getAttribute("curpage")
        var CurrentMaxPage = ContentObject.getAttribute("maxpage")
        if (CurrentPage == 1 && isCurrentCnt == 0) {
            return "PREEND";
        }
        else if (CurrentPage != 1 && isCurrentCnt == 0) {
            var pageNum = parseInt(CurrentPage) - 1;
            goToPageByNum(pageNum);
            setTimeout(function () { PagingMove(CurrentPageSize, true); }, 1000);
            return "PREMOVE";
        }
        else {
            var preCurrentCnt = isCurrentCnt -1;
            var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
            _RowObject = preCurrentObject;
            callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
        }
    }
    else {
        var isCurrentCnt = parseInt(CurrentObject.getAttribute("id").replace("Maillist_", ""));
        var ContentObject = document.getElementById("GroupSubList");
        if (isCurrentCnt == 0) {
            return "PREEND";
        }
        else {
            var preCurrentCnt = isCurrentCnt - 1;
            var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
            _SubRowObject = preCurrentObject;
            callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
        }
    }
}
function PagingMove(CurrentPageSize) {
    var preCurrentCnt;
    if (CurrentPageSize != 0)
        preCurrentCnt = CurrentPageSize - 1;
    else
        preCurrentCnt = 0;
    ;
    var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
    _RowObject = preCurrentObject;
    callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
}
function PopUpNextMail() {
    var CurrentObject;
    var isMainlist = false;
    if (_RowObject != null) {
        CurrentObject = _RowObject;
        isMainlist = true;
    }
    else {
        CurrentObject = _SubRowObject;
        isMainlist = false;
    }
    if (isMainlist) {
        var isCurrentCnt = parseInt(CurrentObject.getAttribute("id").replace("Maillist_", ""));
        var ContentObject = document.getElementById("MailList");
        var CurrentPageSize = ContentObject.getAttribute("listpagecount")
        var CurrentPage = ContentObject.getAttribute("curpage")
        var CurrentMaxPage = ContentObject.getAttribute("maxpage")
        var CurrentMaxCount = ContentObject.getAttribute("MaxCount");
        if (CurrentPage == CurrentMaxPage && isCurrentCnt == (CurrentMaxCount  - ((CurrentMaxPage - 1) * CurrentPageSize))-1) {
            return "NEXTEND";
        }
        else if (CurrentPage != CurrentMaxPage && isCurrentCnt == (CurrentPageSize - 1)) {
            var pageNum = parseInt(CurrentPage) +1;
            goToPageByNum(pageNum);
            setTimeout(function () { PagingMove(0); }, 1000);
            return "NEXTMOVE";
        }
        else {
            var preCurrentCnt = isCurrentCnt + 1;
            var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
            _RowObject = preCurrentObject;
            callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
        }
    }
    else {
        var isCurrentCnt = parseInt(CurrentObject.getAttribute("id").replace("Maillist_", ""));
        var ContentObject = document.getElementById("GroupSubList");
        var CurrentMaxCount = ContentObject.getAttribute("MaxCount");
        if (isCurrentCnt == (CurrentMaxCount-1)) {
            return "NEXTEND";
        }
        else {
            var preCurrentCnt = isCurrentCnt + 1;
            var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
            _SubRowObject = preCurrentObject;
            callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
        }
    }
}

function event_flag(obj) {
    var temp_listContentArry = listContentArry;
    listContentArry = [GetAttribute(obj.parentElement, "id")];
    toggle_flag(obj);
    listContentArry = temp_listContentArry;
}

var flagXmlHttp;
function toggle_flag(obj) {
    if (listContentArry.length == 0 && listSubContentArry.length == 0 && currentFixingId == null) {
        alert(strLang42);
        return;
    }
    var pSelectItem;
    if (listContentArry.length > 0) {
        if (listContentArry.length > 1) {
            pSelectItem = "";
            for (var i = 1; i <= listContentArry.length; i++) {
                pSelectItem += document.getElementById(listContentArry[listContentArry.length - i]).getAttribute("_href") + ";";
            }
        }
        else
            pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1]).getAttribute("_href") + ";";
	} else if (listSubContentArry.length > 0) {
		pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1]).getAttribute("_href") + ";";
	} else {
		pSelectItem = currentFixingId.getAttribute("_href") + ";";;
	}

    var now = new Date();
    now.setDate(now.getDate() + 1);

    var month = parseInt(now.getMonth()) + 1;
    var pSDate = now.getFullYear() + "-" + month + "-" + now.getDate();
    var pEDate = pSDate;


    flagXmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();


    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "ITEMID", pSelectItem);
    createNodeAndInsertText(xmlDom, objNode, "STARTDATE", pSDate);
    createNodeAndInsertText(xmlDom, objNode, "ENDDATE", pEDate);

    var url = "/ezEmail/mailSetFlag.do";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		url += "?shareId=" + encodeURIComponent(shareId);
	}
    
    try {
        flagXmlHttp.open("POST", url, true);
        flagXmlHttp.onreadystatechange = event_toggle_flag_end;
        flagXmlHttp.send(xmlDom);
        if(typeof obj === "undefined") {
            // 20200428 조진호 - 메일 리스트에서 체크박스를 이용한 행위 뒤 체크박스가 풀리도록 추가
            if (listContentArry.length > 0) {
                for (var i = 1; i <= listContentArry.length; i++) {
                    document.getElementById(listContentArry[listContentArry.length - i]).children[0].children[0].checked = false;
                }
            }
            try {
                if (document.getElementById("HeaderAllCheckBox") != null)
                    document.getElementById("HeaderAllCheckBox").checked = false;
            } catch (e) {console.log(e);}
        }
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
        	if (flagXmlHttp.responseText != "NEW" && flagXmlHttp.responseText != "DEL") {
        		alert("ERROR");
        	}

            MailListRefresh();
        }
    }
}
function cancel_send() {

    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        return;
    }
    var pSelectItem;
    if (listContentArry.length > 0) {
        pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1])
    }
    else {
        pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
    }

    if (!confirm(strLang143))
        return;

    var xmlDom = createXmlDom();
    g_xmlHttp = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", pSelectItem.getAttribute("_href"));
    g_xmlHttp.open("POST", "/myoffice/ezEmail/remote/mail_cancelsend.aspx", false);
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
    window.open("/myoffice/ezemail/htm/cancelMessageReport_cross.aspx?num=" + pnum, '', 'height=320,width=730,resizable=yes,scrollbars=no');
}
function ShowMailProgress() {
    document.getElementById("mailPanel").style.display = "";
    document.getElementById("MailProgress").style.top = "400px";
    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
    document.getElementById("MailProgress").style.display = "";
}
function HiddenMailProgress() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("MailProgress").style.display = "none";
}

function showDelAllProgress() {
    document.getElementById("mailPanel").style.display = "block";
    document.getElementById("mailPanel").style.opacity = 0.5;
    document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
    document.getElementById("MailProgress").style.top = "400px";
    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
    document.getElementById("MailProgress").style.display = "";
    parent.document.getElementById("left").contentWindow.showProgress();
}

function hideDelAllProgress() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("mailPanel").style.backgroundColor = "";
    document.getElementById("MailProgress").style.display = "none";
    parent.document.getElementById("left").contentWindow.hideProgress();
}

function PreviewMode_ChangeBtn() {
    /*document.getElementById("PreViewNone").setAttribute("src", "/images/kr/cm/btn_noframe.gif");
    document.getElementById("PreViewBottom").setAttribute("src", "/images/kr/cm/btn_bottomframe.gif");
    document.getElementById("PreViewleft").setAttribute("src", "/images/kr/cm/btn_leftframe.gif");
    if (pPreviewShow_HOW == "H")
        document.getElementById("PreViewleft").setAttribute("src", "/images/kr/cm/btn_onleftframe.gif");
    else if (pPreviewShow_HOW == "W")
        document.getElementById("PreViewBottom").setAttribute("src", "/images/kr/cm/btn_onbottomframe.gif");
    else
        document.getElementById("PreViewNone").setAttribute("src", "/images/kr/cm/btn_onnoframe.gif");*/
	
	document.getElementById("PreViewNone").className = "icon16 btn_noframe";
	
	if (document.getElementById("PreViewBottom")) {
		document.getElementById("PreViewBottom").className = "icon16 btn_bottomframe";
	}
	
	if (document.getElementById("PreViewleft")) {
		document.getElementById("PreViewleft").className = "icon16 btn_leftframe";
	}
	
	if (pPreviewShow_HOW == "H") {
		if (document.getElementById("PreViewleft")) {
			document.getElementById("PreViewleft").className = "icon16 btn_onleftframe";
		}
	} else if (pPreviewShow_HOW == "W") {
		if (document.getElementById("PreViewBottom")) {
			document.getElementById("PreViewBottom").className = "icon16 btn_onbottomframe";
		}
	} else {
        document.getElementById("PreViewNone").className = "icon16 btn_onnoframe";
	}

}
function MailOptionView(obj) {
    if (obj.getAttribute("mode") == "off") {
        document.getElementById("layer_popup").style.left = document.documentElement.clientWidth - 260 + "px";
        document.getElementById("layer_popup").style.top = "100px";
        document.getElementById("layer_popup").style.display = "";
        
        if (g_szRootFolderName === strLangKDH01) {
            //20240827 김대현 수신확인 메뉴를 클릭시 필터링은 숨김
            document.getElementById("selectViewList").style.display="none"; 
        }
        
        //obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
        obj.setAttribute("class", "icon16 btn_onarrow_down");
        obj.setAttribute("mode", "on");
    }
    else {
        MailOptionHidden();
    }
}
function MailOptionHidden() {
    document.getElementById("layer_popup").style.display = "none";
    document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
    //document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
    document.getElementById("maillistoptiondiv").setAttribute("class", "icon16 btn_arrow_down");
    ContextMenuHidden();
}
//레이어팝업 바깥쪽 클릭시 레이어팝업 꺼지게 2018-02-22 강민수92
function MailOptionHiddenOutside(e) {
	var container = $('#layer_popup');
	var btncontainer = $('#maillistoptiondiv');
	var maillistoptionmode = $('#maillistoptiondiv').attr('mode');
	if (maillistoptionmode == "on") {
		if (container.has(e.target).length === 0 && $(e.target).attr('id') != 'maillistoptiondiv') {
			MailOptionHidden();
		}
	}
    var clickedElementClass = e.target.className;
    if (!clickedElementClass.includes('input_select_arrow')) {
        hiddenMoreMenu();
    }

    let usingMailPreview = document.getElementById("iFramePanel_mail_preview").className.includes('on');
    if (usingMailPreview) {
        hiddenPreviewMail();
    }
}
function mailOpenPopup(btn, event) {
	event.stopPropagation();
	var obj = btn.parentElement;
	event_listclick(obj, event);
	event_listDBClick(obj.parentElement);
}

function mailPrevIframeSize() {
	var previewmail_info = $("#PreContent_Rayer" + pPreviewShow_HOW).find(".previewmail_info").outerHeight();
	var sentDateStr = $("#PreContent_Rayer" + pPreviewShow_HOW).find(".sentDateStr").outerHeight();
	var pPreview = pPreviewShow_HOW == "H" ? CurrentHeight : pMailPreHeightW;
	
	previewmail_info = (Math.ceil((previewmail_info + sentDateStr)/10) * 10) + 10;
	
	$("#ifrmPreView" + pPreviewShow_HOW).height(pPreview - previewmail_info + 15);
}

function mailConfirm_flag_btn() {
	var listContentArrLen = listContentArry.length;
	var listSubContentArrLen = listSubContentArry.length;
	var pSelectItem  = "";
	var url = "/ezEmail/mailSetFlagForMailConfirm.do";
	
	if (listContentArrLen == 0 && listSubContentArrLen == 0 && currentFixingId == null) {
        alert(strLang42);
        return;
    }

	if (listContentArrLen > 0) {
        for (var i = 0; i < listContentArry.length; i++) {
            pSelectItem += document.getElementById(listContentArry[i]).getAttribute("_href") + ";";
        }
    } else if (listSubContentArry.length > 0) {
        pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
    } else {
    	pSelectItem = currentFixingId.getAttribute("_href") + ";";
    }

    flagXmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "ITEMID", pSelectItem);
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		url += "?shareId=" + encodeURIComponent(shareId);
	}
    
    try {
        flagXmlHttp.open("POST", url, true);
        flagXmlHttp.onreadystatechange = function() {
        	if(flagXmlHttp.readyState == 4) {
        		if (flagXmlHttp.responseText == "OK") {
        			MailListRefresh();
        		} else {
        			alert(strLang321);
        		}
        	}
        };
        flagXmlHttp.send(xmlDom);
    }
    catch (e) {console.log(e);}
}

function mailConfirm_line() {
	listContentArry.forEach(function(val, key) {
		$("#"+val).toggleClass("mail_confirm");
	});
}

function hiddenMoreMenu() {
    var pageType = pPreviewShow_HOW == "H" ? "_h" : "_w";
    var tagLayerElement = document.getElementById("layer_select"+pageType);
    if (tagLayerElement) {
        tagLayerElement.scroll({top:0});
        var tagLayerStyle = getComputedStyle(tagLayerElement);
        if (tagLayerStyle.display !== 'none') {
            document.getElementById("input_wrap"+pageType).classList.remove("on");
        }
    }
}

function hiddenPreviewMail() {
    document.getElementById("iFramePanel_mail_preview").style.display = "none";
    document.getElementById("iFramePanel_mail_preview").classList.remove("on");
    document.getElementById("mail_preview_Layer").src = "/blank.htm";
}