﻿var XmlHeader;
var XmlHeader_SUB;
var BlockSize = 10;
var p_ListOrderObject = null;
var p_SubListOrderObject = null;
var _RowObject = null;
var _SubRowObject = null;
var _SublistDBClickEvent = false;
var GetList_HTTP;
var GetList_HTTP_SUB;
var GetListInfo_HeaderObject;
var GetListInfo_ContentObject;
var m_strColorSelect = "#f1f8ff";
var m_strColorOver = "#f4f5f5";
var m_strColorDefault = "#ffffff";
var m_strColorOpened = "#fafafa";
var GroupplusImg ="/images/ImgIcon/groupplus.gif";
var GroupminImg ="/images/ImgIcon/groupmin.gif";
var GroupSenderImg ="/images/ImgIcon/groupsender.gif";
var GroupSubjectImg ="/images/ImgIcon/groupsubject.gif";
var GroupColor = "#666666";
var pSearchListCount = 0;

function HeaderIni(HeaderObject) {
    MakeHeaderHTML(HeaderObject);
}
function HeaderIni_SUB(HeaderObject) {
    MakeHeaderHTML_SUB(HeaderObject);
}
function MakeHeaderHTML(HeaderObject) {
    var Rvalue = "";
    try {
        HeaderObject.innerHTML = "";
        var XmlHttp = createXMLHttpRequest();
        XmlHttp.open("GET", p_HeaderViewXML, false);
        XmlHttp.send();
        XmlHeader = XmlHttp.responseXML;
        XmlRows = SelectNodes(XmlHeader, "view/column");
        var _HeaderTR = document.createElement("TR");
        var _HeaderTH = document.createElement("TH");
        _HeaderTH.style.width = "22px";        
        if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT") {
        	_HeaderTH.style.textAlign = "center";
             var _HeaderCheckBox = document.createElement("INPUT");
            _HeaderCheckBox.type = "checkbox";
            _HeaderCheckBox.style.margin = "0px";
            _HeaderCheckBox.style.padding = "0px";
            _HeaderCheckBox.style.width = "13px";
            _HeaderCheckBox.style.height = "13px";
            _HeaderCheckBox.setAttribute("id", "HeaderAllCheckBox");
            if (p_ListorderValue == "GROUPSUBLIST") { _HeaderCheckBox.onclick = function () { event_SubHeaderCheckBoxClick(this); }; }
            else { _HeaderCheckBox.onclick = function () { event_HeaderCheckBoxClick(this); }; }
            _HeaderTH.appendChild(_HeaderCheckBox);
        }
        _HeaderTR.appendChild(_HeaderTH);
        for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
            var _HeaderRow = document.createElement("TH");
            if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT" && SelectSingleNodeValue(XmlRows[Cnt], "propname") != "readdt") {
            	if (p_ListorderValue == "GROUPSUBLIST") {
                    _HeaderRow.onclick = function () { event_SubHeaderClick(this); };
                }
                else {
                    _HeaderRow.onclick = function () { event_HeaderClick(this); };
                }
            }
            _HeaderRow.style.width = SelectSingleNodeValue(XmlRows[Cnt], "width")
            _HeaderRow.style.textAlign = SelectSingleNodeValue(XmlRows[Cnt], "align");
            _HeaderRow.style.cursor = "pointer";
            _HeaderRow.setAttribute("prop", SelectSingleNodeValue(XmlRows[Cnt], "prop"));

            if (SelectSingleNodeValue(XmlRows[Cnt], "propname") == "subject" || SelectSingleNodeValue(XmlRows[Cnt], "receivedt") == "sender") {
            	_HeaderRow.style.overflow = "hidden";
                _HeaderRow.style.textOverflow = "ellipsis";
                _HeaderRow.style.whiteSpace = "nowrap";	
            }
            
            var HeaderType = SelectSingleNodeValue(XmlRows[Cnt], "heading");
            if (HeaderType == "IMG") {
            	if (SelectSingleNodeValue(XmlRows[Cnt], "imgpath") == "") {
            		_HeaderRow.innerHTML = "&nbsp;";
            	} else {
            		_HeaderRow.innerHTML = "<IMG style=\"cursor:pointer\" src=\"" + SelectSingleNodeValue(XmlRows[Cnt], "imgpath") + "\"/>";
            	}
            } else {
                _HeaderRow.innerHTML = SelectSingleNodeValue(XmlRows[Cnt], "heading");
            }
            if (SelectSingleNodeValue(XmlRows[Cnt], "propname") == "readdt") {
            	_HeaderTR.appendChild(_HeaderRow);
            	continue;
            }
            
            var _HeaderSpanimg = null;
            if (SelectSingleNodeValue(XmlRows[Cnt], "prop") == p_ListOrderby) {
                _HeaderRow.setAttribute("orderoption", p_ListOrderOption);
                var _HeaderSpanimg = document.createElement("IMG");
                if (p_ListOrderOption == "DESC")
                    _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
                else
                    _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

                _HeaderSpanimg.setAttribute("align", "absmiddle");
                if (p_ListorderValue == "GROUPSUBLIST") {
                    p_SubListOrderObject = _HeaderRow;
                }
                else {
                    p_ListOrderObject = _HeaderRow;
                }
            }
            else
                _HeaderRow.setAttribute("orderoption", "");
            if (_HeaderSpanimg != null)
                _HeaderRow.appendChild(_HeaderSpanimg);

            _HeaderTR.appendChild(_HeaderRow);
        }
        HeaderObject.appendChild(_HeaderTR);
    }
    catch (e) {
        alert(e.description);
    }
}
function MakeHeaderHTML_SUB(HeaderObject) {
    var Rvalue = "";
    try {
        HeaderObject.innerHTML = "";
        var XmlHttp = createXMLHttpRequest();
        XmlHttp.open("GET", p_HeaderViewXML, false);
        XmlHttp.send();
        XmlHeader_SUB = XmlHttp.responseXML;
        XmlRows = SelectNodes(XmlHeader_SUB, "view/column");
        var _HeaderTR = document.createElement("TR");
        var _HeaderTH = document.createElement("TH");
        _HeaderTH.style.width = "22px";
        var _HeaderCheckBox = document.createElement("INPUT");
        _HeaderCheckBox.type = "checkbox";
        _HeaderCheckBox.style.margin = "0px";
        _HeaderCheckBox.style.padding = "0px";
        _HeaderCheckBox.style.width = "13px";
        _HeaderCheckBox.style.height = "13px";
        _HeaderCheckBox.setAttribute("id", "HeaderAllCheckBox");
        if (p_ListorderValue == "GROUPSUBLIST") { _HeaderCheckBox.onclick = function () { event_SubHeaderCheckBoxClick(this); }; }
        else { _HeaderCheckBox.onclick = function () { event_HeaderCheckBoxClick(this); }; }
        _HeaderTH.appendChild(_HeaderCheckBox);
        _HeaderTR.appendChild(_HeaderTH);
        for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
            var _HeaderRow = document.createElement("TH");
            _HeaderRow.onclick = function () { event_SubHeaderClick(this); };
            _HeaderRow.style.width = SelectSingleNodeValue(XmlRows[Cnt], "width")
            _HeaderRow.style.textAlign = SelectSingleNodeValue(XmlRows[Cnt], "align");
            _HeaderRow.style.cursor = "pointer";
            _HeaderRow.setAttribute("prop", SelectSingleNodeValue(XmlRows[Cnt], "prop"));

            var HeaderType = SelectSingleNodeValue(XmlRows[Cnt], "heading");
            if (HeaderType == "IMG")
                _HeaderRow.innerHTML = "<IMG style=\"cursor:pointer\" src=\"" + SelectSingleNodeValue(XmlRows[Cnt], "imgpath") + "\"/>";
            else
                _HeaderRow.innerHTML = SelectSingleNodeValue(XmlRows[Cnt], "heading");

            var _HeaderSpanimg = null;
            if (SelectSingleNodeValue(XmlRows[Cnt], "prop") == p_ListOrderby) {
                _HeaderRow.setAttribute("orderoption", p_ListOrderOption);
                var _HeaderSpanimg = document.createElement("IMG");
                if (p_ListOrderOption == "DESC")
                    _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
                else
                    _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

                _HeaderSpanimg.setAttribute("align", "absmiddle");
                p_SubListOrderObject = _HeaderRow;
            }
            else
                _HeaderRow.setAttribute("orderoption", "");
            if (_HeaderSpanimg != null)
                _HeaderRow.appendChild(_HeaderSpanimg);

            _HeaderTR.appendChild(_HeaderRow);
        }
        HeaderObject.appendChild(_HeaderTR);
    }
    catch (e) {
        alert(e.description);
    }
}

function drag(ev) {
	var eventTarget = ev.srcElement || ev.target;
	var listContentLength = listContentArry.length;
	
	if (listContentLength > 1 && listContentArry.indexOf(eventTarget.id) > -1) {
		var szItemID = "";
		
		for (var i = 0; i < listContentArry.length; i++) {
			szItemID += GetAttribute(document.getElementById(listContentArry[i]), "_href") + ",";
		}
		
		ev.dataTransfer.setData("text", szItemID);
	} else {
		ev.dataTransfer.setData("text", GetAttribute(eventTarget, "_href") + ",");
	}
}

var xmlhttp_MailReceiverList = null;
function MakeListInfoHTML(ConentObject) {
    if (p_ListorderValue == "" || p_ListorderValue == "RECEIV" || p_ListorderValue == "UNREAD" || p_ListorderValue == "GROUPSUBLIST"
    	 || p_ListorderValue == "INTERNAL" || p_ListorderValue == "EXTERNAL" || p_ListorderValue == "SECUREMAIL" || p_ListorderValue == "IMPORTANT" || p_ListorderValue == "ATTACH") {
    	try {
            var XmlList = GetList_HTTP.responseXML;
            
            if (XmlList == null) {
                return;
            }
            var XmlRows = SelectNodes(XmlList, "maillist/response");
            var p_TotalCnt = getNodeText(SelectNodes(XmlList, "maillist/CONTENTRANGE")[0]);
            var szRangeHeader = getNodeText(SelectNodes(XmlList, "maillist/CONTENTRANGE")[0]);
            GetListInfo_ContentObject.innerHTML = "";
            
            // 삭제 혹은 이동 시 스크롤바가 맨 위로 이동하지 않도록 하기 위해 주석 처리함
//            if (p_ListorderValue != "GROUPSUBLIST") {
//                document.getElementById("contentlist").scrollTop = "0";
//            }
            
            for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
                var p_Href = SelectSingleNodeValue(XmlRows[Cnt], "href");
                var p_Importance = SelectSingleNodeValue(XmlRows[Cnt], "importance");
                var p_Flag = SelectSingleNodeValue(XmlRows[Cnt], "flag");
                var p_Attach = SelectSingleNodeValue(XmlRows[Cnt], "attach");
                var p_Sender = SelectSingleNodeValue(XmlRows[Cnt], "sender");
                var p_Msgto = SelectSingleNodeValue(XmlRows[Cnt], "msgto");
                var p_Subject = SelectSingleNodeValue(XmlRows[Cnt], "subject");
                var p_ReceiveDT = SelectSingleNodeValue(XmlRows[Cnt], "receivedt");
                var p_Size = SelectSingleNodeValue(XmlRows[Cnt], "size");
                var p_Read = SelectSingleNodeValue(XmlRows[Cnt], "read");
                var p_ContentClass = SelectSingleNodeValue(XmlRows[Cnt], "contentclass");
                var p_IsDraft = SelectSingleNodeValue(XmlRows[Cnt], "isdraft");
                var p_SecureMail = SelectSingleNodeValue(XmlRows[Cnt], "securemail");
                var p_Readdt = SelectSingleNodeValue(XmlRows[Cnt], "readdt");
                var p_Group = SelectSingleNodeValue(XmlRows[Cnt], "group");
                var p_RecipientCount = SelectSingleNodeValue(XmlRows[Cnt], "recipientCount");
                var p_countryCode = SelectSingleNodeValue(XmlRows[Cnt], "countryCode");
                var p_mailIP = SelectSingleNodeValue(XmlRows[Cnt], "mailIP");
                var p_countryName = SelectSingleNodeValue(XmlRows[Cnt], "countryName");
                var p_mailConfirm = SelectSingleNodeValue(XmlRows[Cnt], "mailConfirm");
                var recipients = [];
            	var recipientsLen = 1;
                
                var _TR = document.createElement("TR");
                _TR.setAttribute("id", "Maillist_" + Cnt);
                _TR.style.cursor = "pointer";
                _TR.style.fontWeight = p_Read == "0" ? "bold" : "";
                _TR.style.color = p_Importance == "2" ? "red" : "";
                _TR.style.cursor = "pointer";
                _TR.setAttribute("_href", p_Href);
                _TR.setAttribute("_subject", p_Subject);
                _TR.setAttribute("read", p_Read);
                _TR.setAttribute("_contentclass", p_ContentClass);
                _TR.setAttribute("_isdraft", p_IsDraft);
                _TR.setAttribute("securemail", p_SecureMail);
                
                if (shareId != "" && deletePermission != "Y") {
                	_TR.setAttribute("draggable", false);
                } else {
                	_TR.setAttribute("draggable", true);
                	_TR.ondragstart = function () { drag(event) };
                }

                // 2020-08-19 김은실 -우클릭 시 currentFixingId가 다르게 찍히는 현상: _TD에서=>_TR로 선택&마우스효과 변경
                _TR.onmouseover = function () { event_listMover(this); };
                _TR.onmouseout = function () { event_listMout(this); };
            
                var _TDCheckBox = document.createElement("TD");
                _TDCheckBox.style.width = "22px";
                _TDCheckBox.style.textAlign = "center";
                _TDCheckBox.style.cursor = "default";
                var _TDCheckBox_Sub = document.createElement("INPUT");
                _TDCheckBox_Sub.type = "checkbox";
                if (p_ListorderValue == "GROUPSUBLIST") { _TDCheckBox_Sub.onclick = function () { event_SublistCheckboxclick(this); }; }
                else { _TDCheckBox_Sub.onclick = function () { event_listCheckboxclick(this); }; }
                _TDCheckBox_Sub.style.margin = "0px";
                _TDCheckBox_Sub.style.padding = "0px";
                _TDCheckBox_Sub.style.width = "13px";
                _TDCheckBox_Sub.style.height = "13px";
                _TDCheckBox_Sub.style.cursor = "pointer";
                _TDCheckBox.appendChild(_TDCheckBox_Sub);
                _TR.appendChild(_TDCheckBox);
                XmlHeaderRows = SelectNodes(XmlHeader, "view/column");
                
                // 수신확인 중 수신자가 여러명일 경우
            	//if (useReceivingChk) {
            		recipients = p_Msgto.split(',');
            		recipientsLen = recipients.length;
            	//}
            	
                for (var HRows = 0; HRows < XmlHeaderRows.length; HRows++) {

                    var _TDColum = document.createElement("TD");
                    var ssNodeValue = SelectSingleNodeValue(XmlHeaderRows[HRows], "propname");
                    switch (ssNodeValue) {
                        case "importance":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.cursor = "default";
                            _TDColum.innerHTML = p_Importance == "0" ? "<IMG style='cursor:default' draggable='false' src='/images/ImgIcon/icon-lowimportance.gif'/>" : p_Importance == "2" ? "<IMG style='cursor:default' src='/images/ImgIcon/icon-highimportance.gif'/>" : "";
                            break;
                        case "receiveInfo":
                        	_TDColum.style.width = "18px";
                        	if (p_RecipientCount >= 2 || p_Group == "yes") {
                        		_TDColum.innerHTML = "<span style='cursor: pointer'><IMG src='/images/receivedCheck_closed.png'></span>";
                        		_TDColum.setAttribute("viewSelect", "false");
                        		_TDColum.onclick = function () { viewReceivers(this); };
                        	}
                        	break;
                        case "status":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.cursor = "default";
                            _TDColum.innerHTML = GetContentClassImg(p_ContentClass, p_Read);
                            break;
                        case "flag":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.cursor = "pointer";
                            _TDColum.innerHTML = p_Flag == "0" ? "<IMG style='cursor:pointer' draggable='false' src='/images/ImgIcon/view-flag.gif'/>" : "<IMG style='cursor:pointer' src='/images/ImgIcon/icon-flag.gif'/>";
                            _TDColum.onclick = function () { event_flag(this); };
                            break;
                        case "attach":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.cursor = "default";
                            _TDColum.innerHTML = p_Attach == "1" ? "<IMG id='imgCol' draggable='false' style='cursor:default' src='/images/newAttach.gif'/>" : "";
                            break;
                        case "sender":
                        	var innerHTML = p_Sender;
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_Subject;
                            _TDColum.innerHTML = innerHTML;
                            _TDColum.title = p_Msgto;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            // 수아 수정 (보낸사람 클릭 -> 보낸 사람에게 메일 전송창)
                            _TDColum.setAttribute("data-msgtoLen", recipientsLen);
                            _TDColum.setAttribute("data-msgto", p_Msgto);
                            // 재원 수정
                            _TDColum.setAttribute("data-name", p_Sender);
                            //_TDColum.onclick = function (event) { useMailWriteSenderClick == "NO" ? event_listclick(this, event) : new_mail_onclick(this); };
                            _TDColum.onclick = function (event) {
                                clearTimeout(singleClickTimer);
                                singleClickTimer = setTimeout(function () {
                                    event_listclick(this, event);
                                }.bind(this), 200);
                            };

                            _TDColum.ondblclick = function () {
                                clearTimeout(singleClickTimer);
                                event_listDBClick(this.parentElement);
                            };
                            
                            _TDColum.onselectstart = function () { return false; };
                            break;
                        case "subject":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            if (p_Subject.trim() == "") {
                            	p_Subject = strLang97;
                            }
                            if (p_SecureMail == 1) {
                            	p_Subject = "<span class='security_icon'></span>" + p_Subject;
                            }
                            
                            var p_Title  = SelectSingleNodeValue(XmlRows[Cnt], "subject");
                            // 2024-10-29 김대현 두줄보기할때 title에 태그 들어가는 현상 수정
                            p_Title = p_Title.replace(/<[^>]*>/g, '');
                            _TDColum.title = p_Title.replaceAll('&amp;', '&').replaceAll('&#40;', '(').replaceAll('&#41;', ')').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('&#39;', "'");

                            if (useMailNewWindow == "YES") {
                            	if (g_bdraft == true) {
	                            	p_Subject = p_Subject
	                            } else {
	                            	p_Subject = "<div id = \"subject\"style=\" cursor:pointer; max-width:85%; display:inline-block;overflow:hidden; text-overflow: ellipsis;\">" + p_Subject + "</div>&nbsp;&nbsp;<img class='mailpopupicon' src=\"/images/email/popup_icon.gif\" width=\"12px\"  onclick = \"mailOpenPopup(this, event)\" />";
	                            }
                            }
                            
                            _TDColum.innerHTML = p_Subject;
                            _TDColum.title = p_Title.replaceAll('&amp;', '&').replaceAll('&#40;', '(').replaceAll('&#41;', ')').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('&#39;', "'");
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";

                            var singleClickTimer;
                            _TDColum.onclick = function (event) {
                                clearTimeout(singleClickTimer);
                                singleClickTimer = setTimeout(function () {
                                    event_listclick(this, event);

                                    if (pPreviewShow_HOW == "OFF") {
                                        event_listDBClick(this.parentElement);
                                    }
                                }.bind(this), 200);
                            };

                            _TDColum.ondblclick = function () {
                                clearTimeout(singleClickTimer);
                                event_listDBClick(this.parentElement);
                            };
                            _TDColum.onselectstart = function () { return false; };
                            break;
                        case "receivedt":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.minWidth = "70px";
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_ReceiveDT;
                            _TDColum.title = p_ReceiveDT;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            _TDColum.onclick = function (event) {
                                clearTimeout(singleClickTimer);
                                singleClickTimer = setTimeout(function () {
                                    event_listclick(this, event);
                                }.bind(this), 200);
                            };

                            _TDColum.ondblclick = function () {
                                clearTimeout(singleClickTimer);
                                event_listDBClick(this.parentElement);
                            };
                            _TDColum.onselectstart = function () { return false; };
                            break;
                        case "size":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = FormatSize(p_Size);
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";

                            _TDColum.onclick = function (event) {
                                clearTimeout(singleClickTimer);
                                singleClickTimer = setTimeout(function () {
                                    event_listclick(this, event);
                                }.bind(this), 200);
                            };

                            _TDColum.ondblclick = function () {
                                clearTimeout(singleClickTimer);
                                event_listDBClick(this.parentElement);
                            };
                            _TDColum.onselectstart = function () { return false; };
                            break;
                        case "readdt":
                            _TDColum.style.textAlign = "center";
                            _TDColum.style.width = "150px";
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.minWidth = "70px";
                        	
                        	if (p_Readdt == "UNREAD") {                                
                                var TD_ATag = document.createElement("A");
                                TD_ATag.className = "imgbtn";
                                
                                var TD_Span = document.createElement("SPAN");
                                TD_Span.innerHTML = reSendMsg;
                                TD_Span.onclick = function () {
                                    var msgHref = this.parentElement.parentElement.parentElement.getAttribute("_href");
                                    
                                    ReSendWithURLOnly(msgHref);
                                };
                                TD_ATag.appendChild(TD_Span);
                                
                                _TDColum.appendChild(TD_ATag);                        		
                        	} else {
                        	    _TDColum.innerHTML = p_Readdt;
                        	}
                        	
                        	break;
                        case "parentname": // 편지함 위치 컬럼
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            var parentName = SelectSingleNodeValue(XmlRows[Cnt], "parentName");
                            _TDColum.innerHTML = parentName;
                            _TDColum.title = parentName;
                            break;
                    }
                    _TR.appendChild(_TDColum);
                    
                 // 180514 보낸사람 클릭 시 메일 작성
                    if (ssNodeValue == "sender") { 
                    	var _TDColumSpan = document.createElement("span");
                    	_TDColumSpan.style.padding = "7px 3px";
                    	_TDColumSpan.innerHTML = innerHTML;
                        var countryTitle = "";
                    	
                    	if (useCountryIP == "YES") {
                    		countryTitle = p_Msgto + p_countryName;
                    		if (p_mailIP != "") {
                    			countryTitle += "( " + p_mailIP + " )";
                    		}
                    		_TDColumSpan.title = countryTitle;
                    	}
                    	
                    	if (useMailWriteSenderClick == "YES") {
                    		if (shareId == "" || (shareId != "" && sendPermission == "Y")) {
                    			_TDColumSpan.onclick = function (event) { event_senderNameClick(this.parentElement, event); };
                    			_TDColumSpan.ondblclick = function (event) { event_senderNameDBClick(event); };
                    		}
                    	}
                    	
                    	_TR.lastChild.innerHTML = "";
                    	
                    	// 2018-10-05 메일리스트에 보낸사람 국기표시 박예연
                    	// 현재 국가도 표시할지 여부 : useShowSystemCountry - YES : 현재 상태 한국도 나오는 상태 , NO 현재국가는 안나오는 상태
                    	if (useCountryIP == "YES" && g_foldertype == "" && p_countryCode != "") {
	                    			
            				// 본인국가 표시 
            				if (useShowSystemCountry == "YES") {
            					
            					var _img = document.createElement("img");
            					_img.style.verticalAlign = "middle";
            					_img.style.padding = "0px 0px 3px 0px";
            					
            					if (p_countryCode == "unknown") {
            						p_countryCode = "qm";
            					}
            					
            					_img.src = "/images/countryIcon/" + p_countryCode + ".png";
            					_img.title = countryTitle;
            					_TR.lastChild.appendChild(_img);
            				} else {
            					// 본인국가 표시 안함 p_mailIP p_countryName
            					if ( p_countryCode != systemCountryCode.toLowerCase() ) {
            						var _img = document.createElement("img");
            						_img.style.verticalAlign = "middle";
            						_img.style.padding = "0px 0px 3px 0px";
            						
            						if (p_countryCode == "unknown") {
            							p_countryCode = "qm";
            						}
            						
            						_img.src = "/images/countryIcon/" + p_countryCode + ".png";
            						_img.title = countryTitle;
            						_TR.lastChild.appendChild(_img);
            					}
            				}
                    	}
                    	
                    	if (useMailConfirm == "YES" && p_mailConfirm == "true") {
                            _TR.setAttribute("class", "mail_confirm");
                    	}
                    	
                    	_TR.lastChild.appendChild(_TDColumSpan);
                    }
                }
                GetListInfo_ContentObject.appendChild(_TR);
            }
            
            if (searchMode) {
            	pSearchListCount = p_TotalCnt.split(";")[4]
            }
            
            if(XmlRows.length == "0"){
                var _TR = document.createElement("TR");
            	var _TDColum = document.createElement("TD");
            	_TDColum.innerHTML = strLangKMS03;
            	_TDColum.align = "center";
            	_TR.appendChild(_TDColum);
            	GetListInfo_ContentObject.appendChild(_TR);
            }
            if (p_ListorderValue != "GROUPSUBLIST")
                mf_updatePageInfo(szRangeHeader)
            else
                mf_updatePageInfoGroupList(szRangeHeader)
        } catch (e) {
            alert(e.description);
        }
    }
    else if (p_ListorderValue == "SENT" || p_ListorderValue == "SUBJECT") {
        try {
            var XmlList = GetList_HTTP.responseXML;
            var XmlRows = SelectNodes(XmlList, "multistatus/response");
            var p_TotalCnt = getNodeText(SelectNodes(XmlList, "multistatus/CONTENTRANGE")[0]);
            var szRangeHeader = getNodeText(SelectNodes(XmlList, "multistatus/CONTENTRANGE")[0]);
            GetListInfo_ContentObject.innerHTML = "";
            document.getElementById("contentlist").scrollTop = "0";
            for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
                var p_Sender = SelectSingleNodeValue(XmlRows[Cnt], "prop1");
                var p_VisibleCnt = SelectSingleNodeValue(XmlRows[Cnt], "visiblecount");
                var p_UnreadCnt = SelectSingleNodeValue(XmlRows[Cnt], "unreadcount");
                var _TR = document.createElement("TR");
                _TR.setAttribute("id", "MailGroupList_" + Cnt);
                _TR.style.cursor = "pointer";
                _TR.setAttribute("prop", p_Sender);
                _TR.setAttribute("mode", p_ListorderValue);
                _TR.onmouseover = function () { event_listMover(this); };
                _TR.onmouseout = function () { event_listMout(this); };
                _TR.onclick = function () { event_GrouplistDBClick(this); };
                _TR.onselectstart = function () { return false; };
                XmlHeaderRows = SelectNodes(XmlHeader, "view/column");
                
                var _TDExpColum = document.createElement("TD");
                _TDExpColum.style.width = "35px"
                var _TDExpImg = document.createElement("IMG");
                _TDExpImg.src = GroupplusImg;
                _TDExpImg.align = "absmiddle";
                var _TDExpImg2 = document.createElement("IMG");
                p_ListorderValue == "SENT" ? _TDExpImg2.src = GroupSenderImg : _TDExpImg2.src = GroupSubjectImg;
                _TDExpImg2.align = "absmiddle";
                _TDExpColum.appendChild(_TDExpImg);
                _TDExpColum.appendChild(_TDExpImg2);
                _TR.appendChild(_TDExpColum);
                for (var HRows = 0; HRows < XmlHeaderRows.length; HRows++) {
                    var _TDColum = document.createElement("TD");
                    switch (SelectSingleNodeValue(XmlHeaderRows[HRows], "propname")) {
                        case "subject":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = p_Sender + "<span style='color:" + GroupColor + ";'><b>(" + p_VisibleCnt + ")</b></span>";
                            break;
                        case "info":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = "<span >[" + strLang255 + "<span style='color:" + GroupColor + ";'><b>" + p_UnreadCnt + "</b></span> / " + strLang256 + "<span style='color:" + GroupColor + ";'><b>" + p_VisibleCnt + "</b></span>]</span>";
                            break;
                    }
                    _TR.appendChild(_TDColum);
                }
                var _HiddenTR = document.createElement("TR");
                _HiddenTR.setAttribute("id", "MailGroupList_" + Cnt+"sub");
                _HiddenTR.style.display = "none";
                var _HiddenTD = document.createElement("TD");
                _HiddenTD.colSpan = "3";
                _HiddenTR.appendChild(_HiddenTD);
                GetListInfo_ContentObject.appendChild(_TR);
                GetListInfo_ContentObject.appendChild(_HiddenTR);
            }
            mf_updatePageInfo(szRangeHeader)
        } catch (e) {
            alert(e.description);
        }
    }
}

var xmlhttp_MailReceiverList;
var MailReceiverListXML;
function getReaderCount(parentId) {
	 if (xmlhttp_MailReceiverList != null && xmlhttp_MailReceiverList.readyState == 4) {
	        if (xmlhttp_MailReceiverList.status >= 200 && xmlhttp_MailReceiverList.status < 300) {
	        	MailReceiverListXML = xmlhttp_MailReceiverList.responseXML;
                xmlhttp_MailReceiverList = null;
                makeReceiverList(parentId);
	        }      
	 }
}

function makeReceiverList(parentId) {
	var XmlRows = SelectNodes(MailReceiverListXML, "DATA/ROW");
	XmlRows = sortNode(XmlRows, "READDATE", "UNREAD", "DESC"); // READDATE 컬럼 기준 UNREAD가 아닌것 정렬 (내림차순으로)
	
	for (var i = XmlRows.length - 1; i >= 0; i--) {
		var readDate = SelectSingleNodeValue(XmlRows[i], "READDATE");
        var readerEmail = SelectSingleNodeValue(XmlRows[i], "READEREMAIL");
        var cancel = trim_Cross(SelectSingleNodeValue(XmlRows[i], "CANCEL"));
        var readerName = SelectSingleNodeValue(XmlRows[i], "READERNAME");
        
        var TR = document.createElement("TR");
        TR.setAttribute("id", parentId + "_" + i);
        
        if ($("#" + parentId)[0].childNodes[0].childNodes[0].checked == true) {
        	TR.style.backgroundColor = m_strColorSelect;
        } else {
        	TR.style.backgroundColor = m_strColorOpened;
        }
        // 2020-08-19 김은실 -우클릭 시 currentFixingId가 다르게 찍히는 현상: 세부목록에도 currentMoverId 적용
        TR.onmouseover = function () { currentMoverId = parentId; };
        
        var TD1 = document.createElement("TD");
        TD1.style.width = "22px;";
        
        var TD2 = document.createElement("TD");
        TD2.style.width = "18px;";
        
        var TD3 = document.createElement("TD");
        TD3.style.textAlign = "left";
        TD3.style.overflow = "hidden";
        TD3.style.textOverflow = "ellipsis";
        TD3.style.whiteSpace = "nowrap";
        TD3.style.width = "22%";
        TD3.innerHTML = readerName;
        
        var TD4 = document.createElement("TD");
        var subject = $("#" + parentId)[0].getAttribute("_subject");
        TD4.style.textAlign = "left";
        TD4.style.overflow = "hidden";
        TD4.style.textOverflow = "ellipsis";
        TD4.style.whiteSpace = "nowrap";
        TD4.style.width = "49%";
        TD4.innerHTML = subject;
        
        var TD5 = document.createElement("TD");
        var sendDate = $("#" + parentId)[0].childNodes[4].innerText;
        TD5.style.textAlign = "center";
        TD5.style.width = "150px";
        TD5.style.overflow = "hidden";
        TD5.style.textOverflow = "ellipsis";
        TD5.style.whiteSpace = "nowrap";
        TD5.style.minWidth = "70px";
        TD5.innerHTML = sendDate;
        
        var TD6 = document.createElement("TD");
        TD6.style.textAlign = "center";
        TD6.style.width = "150px";
        TD6.style.overflow = "hidden";
        TD6.style.textOverflow = "ellipsis";
        TD6.style.whiteSpace = "nowrap";
        TD6.style.minWidth = "70px";
        
        if (readDate == 'UNREAD') {
            var msgHref = $("#" + parentId)[0].getAttribute("_href");
        	
            var TD6_ATag = document.createElement("A");
            TD6_ATag.className = "imgbtn";
            
            var TD6_Span = document.createElement("SPAN");
            TD6_Span.innerHTML = reSendMsg;
            TD6_Span.setAttribute("EMAIL", readerEmail);
            TD6_Span.setAttribute("READERNAME", readerName);
            TD6_Span.onclick = function () {
                ReSend(msgHref, this.getAttribute("EMAIL"), this.getAttribute("READERNAME"));
            };
            TD6_ATag.appendChild(TD6_Span);
            
            TD6.appendChild(TD6_ATag);
        } else {        
            TD6.innerHTML = readDate;
        }
        
        TR.appendChild(TD1);
        TR.appendChild(TD2);
        TR.appendChild(TD3);
        TR.appendChild(TD4);
        TR.appendChild(TD5);
        TR.appendChild(TD6);
        
        $(".mainlist #" + parentId).after(TR);
	}
}

function viewReceivers(obj) {
	if (obj.getAttribute("viewSelect") == "false") {
		var parentHref = obj.parentElement.getAttribute("_href");
		var parentId = obj.parentElement.id;
		
		MailReceiverListXML = null;
        xmlhttp_MailReceiverList = null;
        
        var strQuery = "<MESSAGEID>" + decodeURIComponent(parentHref) + "</MESSAGEID>";
        var requestUrl = "/ezEmail/mailGetReceiveList.do";
        
    	if (typeof(shareId) != "undefined" && shareId != "") {
    		requestUrl += "?shareId=" + encodeURIComponent(shareId);
    	}
        
        xmlhttp_MailReceiverList = createXMLHttpRequest();
        xmlhttp_MailReceiverList.open("POST", requestUrl, true);
        xmlhttp_MailReceiverList.onreadystatechange = function() { getReaderCount(parentId); }
        xmlhttp_MailReceiverList.send(strQuery);
		
		obj.setAttribute("viewSelect", "true");
		obj.childNodes[0].childNodes[0].src = "/images/receivedCheck_opend.png";
	} else {
		
		var parentId = obj.parentElement.id;
		var removeElement = $("#MailList")[0].childNodes;
		var removeArry = [];
		
		for (var i = 0; i < removeElement.length; i++) {
			if (removeElement[i].id.indexOf(parentId  + "_") != -1) {
				removeArry[removeArry.length] = removeElement[i].id;
			}
		}
		
		for (var i = 0; i <removeArry.length; i++) {
			$("#" + removeArry[i]).remove();
		}
		
		obj.setAttribute("viewSelect", "false");
		obj.childNodes[0].childNodes[0].src = "/images/receivedCheck_closed.png";
	}
}

function MakeListInfoHTML_SUB(ConentObject) {
        try {
            var XmlList = GetList_HTTP_SUB.responseXML;
            var XmlRows = SelectNodes(XmlList, "maillist/response");
            var p_TotalCnt = getNodeText(SelectNodes(XmlList, "maillist/CONTENTRANGE")[0]);
            var szRangeHeader = getNodeText(SelectNodes(XmlList, "maillist/CONTENTRANGE")[0]);
            GetListInfo_ContentObject.innerHTML = "";
            if (XmlRows.length == 0) {
                document.getElementById("contentlist").scrollTop = "0";
                try { p_ListorderValue = pGroupListClickObject.getAttribute("mode"); } catch (e) {console.log(e);}
                MailListRefresh();
                return;
            }
            for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
                var p_Href = SelectSingleNodeValue(XmlRows[Cnt], "href");
                var p_Importance = SelectSingleNodeValue(XmlRows[Cnt], "importance");
                var p_Flag = SelectSingleNodeValue(XmlRows[Cnt], "flag");
                var p_Attach = SelectSingleNodeValue(XmlRows[Cnt], "attach");
                var p_Sender = SelectSingleNodeValue(XmlRows[Cnt], "sender");
                var p_Subject = SelectSingleNodeValue(XmlRows[Cnt], "subject");
                var p_ReceiveDT = SelectSingleNodeValue(XmlRows[Cnt], "receivedt");
                var p_Size = SelectSingleNodeValue(XmlRows[Cnt], "size");
                var p_Read = SelectSingleNodeValue(XmlRows[Cnt], "read");
                var p_ContentClass = SelectSingleNodeValue(XmlRows[Cnt], "contentclass");
                var _TR = document.createElement("TR");
                _TR.setAttribute("id", "Maillist_" + Cnt);
                _TR.style.cursor = "pointer";
                _TR.style.fontWeight = p_Read == "0" ? "bold" : "";
                _TR.style.color = p_Importance == "2" ? "red" : "";
                _TR.style.verticalAlign = "middle";
                _TR.style.cursor = "pointer";
                _TR.setAttribute("_href", p_Href);
                _TR.setAttribute("_subject", p_Subject);
                _TR.setAttribute("read", p_Read);
                _TR.setAttribute("_contentclass", p_ContentClass);
                _TR.onmouseover = function () { event_SublistMover(this); };
                _TR.onmouseout = function () { event_SublistMout(this); };
                _TR.onclick = function () { event_Sublistclick(this); };
                _TR.ondblclick = function () { event_SublistDBClick(this); };
                _TR.onselectstart = function () { return false; };
                var _TDCheckBox = document.createElement("TD");
                _TDCheckBox.style.width = "22px";
                var _TDCheckBox_Sub = document.createElement("INPUT");
                _TDCheckBox_Sub.type = "checkbox";
                _TDCheckBox_Sub.onclick = function () { event_SublistCheckboxclick(this); };
                _TDCheckBox_Sub.style.margin = "0px";
                _TDCheckBox_Sub.style.padding = "0px";
                _TDCheckBox_Sub.style.width = "13px";
                _TDCheckBox_Sub.style.height = "13px";
                _TDCheckBox.appendChild(_TDCheckBox_Sub);
                _TR.appendChild(_TDCheckBox);
                XmlHeaderRows = SelectNodes(XmlHeader_SUB, "view/column");
                for (var HRows = 0; HRows < XmlHeaderRows.length; HRows++) {

                    var _TDColum = document.createElement("TD");
                    switch (SelectSingleNodeValue(XmlHeaderRows[HRows], "propname")) {
                        case "importance":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = p_Importance == "0" ? "<IMG style='cursor:pointer' draggable='false' src='/images/ImgIcon/icon-lowimportance.gif'/>" : p_Importance == "2" ? "<IMG style='cursor:pointer' src='/images/ImgIcon/icon-highimportance.gif'/>" : "";
                            break;
                        case "status":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = GetContentClassImg(p_ContentClass, p_Read);
                            break;
                        case "flag":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = p_Flag == "0" ? "" : "<IMG style='cursor:pointer' draggable='false' src='/images/ImgIcon/icon-flag.gif'/>";
                            break;
                        case "attach":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = p_Attach == "1" ? "<IMG id='imgCol' style='cursor:pointer' draggable='false' src='/images/ImgIcon/view-paperclip.gif '/>" : "";
                            break;
                        case "sender":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_Sender;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            break;
                        case "subject":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_Subject;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            break;
                        case "receivedt":
                        	_TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_ReceiveDT;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            break;
                        case "size":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = FormatSize(p_Size);
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            break;
                    }
                    _TR.appendChild(_TDColum);
                }
                GetListInfo_ContentObject.appendChild(_TR);
            }
            mf_updatePageInfoGroupList(szRangeHeader)
        } catch (e) {
            alert(e.description);
        }
}
function MailSelect_One() {
    if (document.getElementById("Maillist_0") != null)
        document.getElementById("Maillist_0").onclick();
}
var pOldSearchKeyword;

function GetListInfo(HeaderObject, ContentObject) {
    /* 수아 재은 수정 */
    checkedHrefArry = getCheckHrefArry();

    listSubContentArry = new Array();
    listContentArry = new Array();
    var xmlpara = createXmlDom();
    var objNode;
    var pageCount = parseInt(document.getElementById("MailList").getAttribute("listpageCount"));
    var curPage = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var MaxCount = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));
    var MaxPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    var pStart;
    var pEnd;

    pStart = (pageCount * (curPage - 1));
    pEnd = ((curPage) * pageCount) - 1;

    if (pStart >= MaxCount && pEnd >= MaxCount && MaxCount != 0) {
        curPage = Math.ceil(MaxCount / pageCount);
        document.getElementById("MailList").setAttribute("curPage", curPage);
        pStart = (pageCount * (curPage - 1));
        pEnd = ((curPage) * pageCount) - 1;
        if (pEnd > MaxCount || MaxCount != 0)
            pend = MaxCount;
    }

    var pOrderyOption = p_ListorderType + " ORDER BY \"" + p_ListOrderby + "\" " + p_ListOrderOption;

    createNodeInsert(xmlpara, objNode, "DATA");

    // 태그 페이지라면 모든 폴더를 대상으로 함 (빈 문자열로 넘기면 모든 편지함)
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", window.tagName ? "" : g_moveUrl);
    createNodeAndInsertText(xmlpara, objNode, "SORTTYPE", pOrderyOption);
    pOldSearchKeyword = SearchKeyword;
    if (mailsearchDetail == "N" && document.getElementsByName('keyword').item(0) == "") {
        searchKArray = [];
        searchCArray = [];
    }

    searchRequiredKeyword = [];
    searchRequiredCategory = [];

    for (var i = 0; i < searchCArray.length; i++) {
        // 2021-06-22 김은실 - 이미 변경된 단어를 새로고침시 다시 변경하여, 직접 변경하기 보다 -> 그때만 변경하여 넘겨는 것이 좋을 것으로 보임. (&lt; -> &amp;lt; 등이 되는 경우가 있음.)
        var searchKTemp = searchKArray[i];
        searchKTemp = ReplaceText(searchKTemp, "&", "&amp;");
        searchKTemp = ReplaceText(searchKTemp, "<", "&lt;");
        searchKTemp = ReplaceText(searchKTemp, ">", "&gt;");
        searchKTemp = ReplaceText(searchKTemp, "'", "''");
        createNodeAndInsertText(xmlpara, objNode, "KEYWORD", searchKTemp);
        createNodeAndInsertText(xmlpara, objNode, "CATEGORY", searchCArray[i]);
        searchRequiredKeyword.push(searchKTemp);
        searchRequiredCategory.push(searchCArray[i]);
    }
    createNodeAndInsertText(xmlpara, objNode, "SEARCH", SearchKeyword);
    createNodeAndInsertText(xmlpara, objNode, "START", pStart);
    var attachStatus = "all";
    var andorStatus = "and";
    if (mailsearchDetail == "Y") {
        if (document.querySelector("input[name=attachment]:checked").value != null) {
            attachStatus = document.querySelector("input[name=attachment]:checked").value;
        }

        if (document.querySelector("input[name=andor]:checked").value != null) {
            andorStatus = document.querySelector("input[name=andor]:checked").value;
        }
    }

    createNodeAndInsertText(xmlpara, objNode, "STARTDATE", startDate);
    createNodeAndInsertText(xmlpara, objNode, "ENDDATE", endDate);
    createNodeAndInsertText(xmlpara, objNode, "ATTACHSTATUS", attachStatus);
    createNodeAndInsertText(xmlpara, objNode, "ANDORSTATUS", andorStatus);


    if (p_ListorderValue == "GROUPSUBLIST") {
        createNodeAndInsertText(xmlpara, objNode, "END", "ALL");
    } else {
        createNodeAndInsertText(xmlpara, objNode, "END", pEnd);
    }

    createNodeAndInsertText(xmlpara, objNode, "VIEWSELECTINDEX", document.getElementById("select").selectedIndex);

    var secureMailFilter = document.getElementById("select").value == "SECUREMAIL" ? 1 : 0;
    createNodeAndInsertText(xmlpara, objNode, "SECUREMAILFILTER", secureMailFilter);
    createNodeAndInsertText(xmlpara, objNode, "TAGNAME", window.tagName ? tagName : "");
    var attachFileFilter = document.getElementById("select").value === "ATTACH" ? 1 : 0;
    createNodeAndInsertText(xmlpara,objNode, "ATTACHFILEFILTER", attachFileFilter);
    
    var _url = "/ezEmail/mailGetList.do";

    if (typeof (shareId) != "undefined" && shareId != "") {
        _url += "?shareId=" + encodeURIComponent(shareId);
    }

    if (useReceivingChk) {
        _url = "/ezEmail/getReceiverMailList.do";
    }

    GetList_HTTP = createXMLHttpRequest();
    GetList_HTTP.open("POST", _url, true);
    GetList_HTTP.onreadystatechange = GetListIevent_ongetxmlcomplete;
    GetList_HTTP.send(xmlpara);
    GetListInfo_HeaderObject = HeaderObject;
    GetListInfo_ContentObject = ContentObject;
    if (!importExportMode) {
        ShowMailProgress();
    }
}
var p_ListorderType_SUB;
var p_ListOrderby_SUB;
var p_ListOrderOption_SUB;
function GetListInfo_SUB(HeaderObject, ContentObject) {
    listSubContentArry = new Array();
    listContentArry = new Array();
    var xmlpara = createXmlDom();
    var objNode;
    var pageCount = parseInt(document.getElementById("MailList").getAttribute("listpageCount"));
    var curPage = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var MaxCount = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));
    var MaxPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    var pStart;
    var pEnd;
    pStart = (pageCount * (curPage - 1));
    pEnd = ((curPage) * pageCount) - 1;
    if (pEnd > MaxCount && MaxCount != 0)
        pEnd = MaxCount;

    if (pStart >= MaxCount && pEnd >= MaxCount && MaxCount != 0) {
        curPage = Math.ceil(MaxCount / pageCount);
        document.getElementById("MailList").setAttribute("curPage", curPage);
        pStart = (pageCount * (curPage - 1));
        pEnd = ((curPage) * pageCount) - 1;
        if (pEnd > MaxCount || MaxCount != 0)
            pend = MaxCount;
    }

    var pOrderyOption = p_ListorderType_SUB + " ORDER BY \"" + p_ListOrderby_SUB + "\" " + p_ListOrderOption_SUB;

    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", g_moveUrl);
    createNodeAndInsertText(xmlpara, objNode, "SORTTYPE", pOrderyOption);
    
    pOldSearchKeyword = SearchKeyword;
    if (mailsearchDetail == "N" && document.getElementsByName('keyword').item(0) == ""){
    	searchKArray = [];
    	searchCArray = [];
    }
    
    for (var i = 0 ; i < searchCArray.length; i++ ){
    	searchKArray[i] = ReplaceText(searchKArray[i], "&", "&amp;");
    	searchKArray[i] = ReplaceText(searchKArray[i], "<", "&lt;");
    	searchKArray[i] = ReplaceText(searchKArray[i], ">", "&gt;");
    	searchKArray[i] = ReplaceText(searchKArray[i], "'", "''");
    	createNodeAndInsertText(xmlpara, objNode, "KEYWORD", searchKArray[i]);
    	createNodeAndInsertText(xmlpara, objNode, "CATEGORY", searchCArray[i]);
    }
    createNodeAndInsertText(xmlpara, objNode, "SEARCH", SearchKeyword);
    createNodeAndInsertText(xmlpara, objNode, "START", pStart);
    
    var attachStatus = "all";
	var andorStatus = "and";
	if(mailsearchDetail == "Y"){
		if(document.querySelector("input[name=attachment]:checked").value != null ){
			attachStatus = document.querySelector("input[name=attachment]:checked").value;
		} 
		
		if(document.querySelector("input[name=andor]:checked").value != null ){
			andorStatus = document.querySelector("input[name=andor]:checked").value;
		}
	}
	
	createNodeAndInsertText(xmlpara, objNode, "STARTDATE", startDate);
	createNodeAndInsertText(xmlpara, objNode, "ENDDATE", endDate);
	createNodeAndInsertText(xmlpara, objNode, "ATTACHSTATUS", attachStatus);
	createNodeAndInsertText(xmlpara, objNode, "ANDORSTATUS", andorStatus);
    
    
    if (p_ListorderValue == "GROUPSUBLIST") {
    	createNodeAndInsertText(xmlpara, objNode, "END", "ALL");
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "END", pEnd);
    }
    
    createNodeAndInsertText(xmlpara, objNode, "VIEWSELECTINDEX", document.getElementById("select").selectedIndex);
    
    var url = "/ezEmail/mailGetList.do";
    
    if (typeof(shareId) != "undefined" && shareId != "") {
    	url += "?shareId=" + encodeURIComponent(shareId);
    }
    
    GetList_HTTP_SUB = createXMLHttpRequest();
    GetList_HTTP_SUB.open("POST", url, true);
    GetList_HTTP_SUB.onreadystatechange = GetListIevent_ongetxmlcomplete_SUB;
    GetList_HTTP_SUB.send(xmlpara);
    GetListInfo_HeaderObject = HeaderObject;
    GetListInfo_ContentObject = ContentObject;
    
    if (!importExportMode) {
    	ShowMailProgress();
    }
}

function GetListIevent_ongetxmlcomplete() {
    if (GetList_HTTP != null && GetList_HTTP.readyState == 4) {
        if (GetList_HTTP.status >= 200 && GetList_HTTP.status < 300) {
            MakeListInfoHTML(GetListInfo_HeaderObject, GetListInfo_ContentObject);
            
            if (GetList_HTTP.responseXML != null) {
                if (SelectNodes(GetList_HTTP.responseXML, "maillist/response").length == 0) {
                    if (parseInt(GetAttribute(document.getElementById("MailList"), "curPage")) > 1) {
                        goToPageByNum(parseInt(GetAttribute(document.getElementById("MailList"), "curPage")) - 1);
                        return;
                    }
                }
                // try {
                //     if (document.getElementById("HeaderAllCheckBox") != null)
                //         document.getElementById("HeaderAllCheckBox").checked = false;
                // } catch (e) {console.log(e);}
            } else {
            	parent.frames["left"].reloadRetryCount--;
            	
            	if (parent.frames["left"].reloadRetryCount >= 0) {
            		location.reload(true);
            	} else {
            		parent.frames["left"].reloadRetryCount = 1;
            	}
            }
            
            isScrollMailList();
            
            if (!importExportMode) {
            	HiddenMailProgress();
            }
           /* if (typeof (searchMode) != "undefined") {
            	searchMode = false;
            }*/
            GetList_HTTP = null;
            
            /* 수아 재은 수정 (선택된 input href) */
            for (i = 0; i < checkedHrefArry.length; i++) {
            	var getChkId = $(".mainlist tr[_href='" + checkedHrefArry[i] + "']").attr("id");
            	
            	if (!(typeof getChkId === 'undefined')) {
                    listContentArry[listContentArry.length] = getChkId;
	            	document.getElementById(getChkId).childNodes.item(0).childNodes.item(0).checked = true;
	                document.getElementById(getChkId).style.backgroundColor = m_strColorSelect;
            	}
            } // for End
        }   
    }
}

/* 수아 재은 추가 (선택된 input href) */
function getCheckHrefArry() {
	var checkedHrefArry = new Array();
	
	$("#MailList tr input:checked").each(function () {
		checkedHrefArry.push($(this).parents("tr").attr("_href"));
	});
	
	return checkedHrefArry;
}

function isScrollMailList(){
	if ($("#contentlist").height() < $("table.mainlist#MailList").height()) {
		if ($("#MailHeader tr th#forScroll").length < 1) {
			$("#MailHeader tr").append('<th id="forScroll" style="width:10px;"><th>');
		}
	} else {
		if ($("#MailHeader tr th#forScroll").length > 0) {
			$("#MailHeader tr th#forScroll").remove();
		}
	}
}

function GetListIevent_ongetxmlcomplete_SUB() {
    if (GetList_HTTP_SUB != null && GetList_HTTP_SUB.readyState == 4) {
        if (GetList_HTTP_SUB.status >= 200 && GetList_HTTP_SUB.status < 300) {
            MakeListInfoHTML_SUB(GetListInfo_HeaderObject, GetListInfo_ContentObject);
            if (!importExportMode) {
            	HiddenMailProgress();
            }
            try { p_ListorderValue = pGroupListClickObject.getAttribute("mode"); } catch (e) {console.log(e);}
            GetList_HTTP_SUB = null;
        }
    }
}
function on_changeView(listtypeValue) {
    MailOptionHidden();
    p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
    p_ListOrderby = "urn:schemas:httpmail:datereceived";
    p_ListOrderOption = "DESC";
    switch (listtypeValue) {
        case "BASE":
        case "PREVIEW": 
            p_ListorderType = "";
            p_ListorderValue = "";
            break;
        case "UNREAD":
            p_ListorderType = "WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false AND \"urn:schemas:httpmail:read\" = false";
            p_ListorderValue = "UNREAD";
            break;
        case "SENT":
            p_ListorderType = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                              " GROUP BY \"http://schemas.microsoft.com/mapi/sent_representing_name\" ";
            p_ListorderValue = "SENT";
            p_ListOrderby = "http://schemas.microsoft.com/mapi/sent_representing_name";
            p_ListOrderOption = "ASC";
            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile3.xml";
            break;
        case "SUBJECT":
            p_ListorderType = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                              " GROUP BY \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\" ";
            p_ListorderValue = "SUBJECT";
            p_ListOrderby = "http://schemas.microsoft.com/mapi/proptag/x0e1d001f";
            p_ListOrderOption = "ASC";
            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile4.xml";
            break;
        case "RECEIV":
            p_ListorderType = "WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false ";
            p_ListorderValue = "RECEIV";
            p_ListOrderby = "http://schemas.microsoft.com/exchange/date-iso";
            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile2.xml";
            break;
        case "INTERNAL":
            p_ListorderType = "INTERNAL";
            p_ListorderValue = "INTERNAL";
            searchMode = true;
            break;
        case "EXTERNAL":
            p_ListorderType = "EXTERNAL";
            p_ListorderValue = "EXTERNAL";
            searchMode = true;
            break;
        case "SECUREMAIL":
        	p_ListorderType = "SECUREMAIL";
        	p_ListorderValue = "SECUREMAIL";
        	searchMode = true;
        	break;
        case "IMPORTANT":
        	p_ListorderType = "IMPORTANT";
        	p_ListorderValue = "IMPORTANT";
        	searchMode = true;
        	break;
        case "ATTACH":
            p_ListorderType = "ATTACH";
            p_ListorderValue = "ATTACH";
            searchMode = true;
            break;
    }
    if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT" && p_ListorderValue != "RECEIV") {
        if (pPreviewShow_HOW == "H") {
            if (pMailListWidthH <= 470) { 
                if (g_foldertype != "sent") {
                    p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1_1.xml";
                    SmallSizeList = true;
                    OldSmallSizeList = true;
                }
            }
        }
    }
    _RowObject = null;
    _SubRowObject = null;
    pGroupListClickObject = null;
    listContentArry = new Array();
    listSubContentArry = new Array();
    document.getElementsByName('keyword').item(0).value = "";
    document.getElementById("MailList").setAttribute("curPage", "1");
    document.getElementById("MailList").setAttribute("maxcount", "0");
    document.getElementById("MailList").setAttribute("maxpage", "0");
    var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    HeaderIni(HeaderObject);
    GetListInfo(HeaderObject,ContentObject);
}
function mf_updatePageInfo(szRangeHeader) {
    var pageCount = parseInt(document.getElementById("MailList").getAttribute("listpageCount"));
    var curPage = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var MaxCount = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));

    var szRangeHeaderArray = szRangeHeader.split(';');
    m_iStartRange = parseInt(szRangeHeaderArray[1]);
    m_imaxRows = parseInt(szRangeHeaderArray[4]);
    document.getElementById("MailList").setAttribute("MaxCount", m_imaxRows);
    m_iMaxPageNumber = Math.ceil(m_imaxRows / pageCount);
    document.getElementById("MailList").setAttribute("MaxPage", m_iMaxPageNumber);
    var num = Math.ceil((m_iStartRange + pageCount) / pageCount);
    document.getElementById("MailList").setAttribute("curPage", num);
    pFolderTotalCount = szRangeHeaderArray[6];
    pFolderUnReadCount = szRangeHeaderArray[8];
    makePageSelPage();
}
function mf_updatePageInfoGroupList(szRangeHeader) {
    var szRangeHeaderArray = szRangeHeader.split(';');
    m_iStartRange = parseInt(szRangeHeaderArray[1]);
    m_imaxRows = parseInt(szRangeHeaderArray[4]);
    document.getElementById("GroupSubList").setAttribute("MaxCount", m_imaxRows);
    document.getElementById("MailList").setAttribute("MaxPage", "1");
    document.getElementById("MailList").setAttribute("curPage", "1");
}

function MailListRefreshByTimeout() {
	
	if (typeof (searchMode) != "undefined" && typeof (importExportMode) != "undefined") {
		if (searchMode || importExportMode) {
			return;
		}
	}
	
	setTimeout(function() {
		MailListRefresh();
	}, 500);
}

function MailListRefresh() {
	if (window.psSetTimeFlag) {
		return;
	}

	ContextMenuHidden();

	if (typeof(shareId) != "undefined" && shareId != "") {
		parent.frames["left"].detailView(shareId);
	} else {
		parent.frames["left"].detailView();
	}
    
    if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT") {
    	// 20200428 조진호 - 메일 리스트에서 체크박스를 이용한 행위 뒤 체크박스가 풀리도록 추가
        // if (listContentArry.length > 0) {
        //     for (var i = 1; i <= listContentArry.length; i++) {
        //         document.getElementById(listContentArry[listContentArry.length - i]).children[0].children[0].checked = false;
        //     }
        // }
    	
    	goToPageByNum(MailList.getAttribute("curPage"));
    }
    else {
        if (listSubContentArry.length > 0) {
            var pGroupProp = pGroupListClickObject.getAttribute("prop");
            var pGroupMode = pGroupListClickObject.getAttribute("mode");
            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
            if (pGroupMode == "SENT") {
                p_ListorderType = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                                  " AND \"http://schemas.microsoft.com/mapi/sent_representing_name\" = '" + pGroupProp + "' ";
                p_ListorderValue = "GROUPSUBLIST";
                p_ListOrderby = "urn:schemas:httpmail:datereceived";
                p_ListOrderOption = "DESC";
            }
            else if (pGroupMode == "SUBJECT") {
                p_ListorderType = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                                  " AND \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\" = '" + pGroupProp + "' ";
                p_ListorderValue = "GROUPSUBLIST";
                p_ListOrderby = "urn:schemas:httpmail:datereceived";
                p_ListOrderOption = "DESC";
            }
            var NewDIV = document.createElement("DIV");
            NewDIV.innerHTML = document.getElementById("GroupSubObject").innerHTML;
            var SubGroupListTarget = document.getElementById(pGroupListClickObject.getAttribute("id") + "sub")
            SubGroupListTarget.style.display = "";
            SubGroupListTarget.childNodes.item(0).appendChild(NewDIV);
            pGroupListClickObject.style.backgroundColor = m_strColorSelect;
            pGroupListClickObject.childNodes.item(0).childNodes.item(0).src = GroupminImg;
            var HeaderObject = document.getElementById("GroupSubHeader");
            var ContentObject = document.getElementById("GroupSubList");
            
            // 20200428 조진호 - 메일 리스트에서 체크박스를 이용한 행위 뒤 체크박스가 풀리도록 추가
            // if (listContentArry.length > 0) {
            //     for (var i = 1; i <= listContentArry.length; i++) {
            //         document.getElementById(listContentArry[listContentArry.length - i]).children[0].children[0].checked = false;
            //     }
            // }
            
            listSubContentArry = new Array();
            listContentArry = new Array();
            HeaderIni_SUB(HeaderObject);
            GetListInfo_SUB(HeaderObject, ContentObject);
        }
        else {
            on_changeView(document.getElementById("select").value);
        }
    }
    
    refreshUnreadCount();

    // commented out to maintain the current preview content when the mail list is refreshed : dhlee
//    prevShow_Clear();
}
/** @param pGubun 컬럼 개수가 줄어드는지 여부, 너비가 좁을 때 true가 됨 */
function BasicViewHeaderChange(pGubun, pFolderType) {
	var viewXmlFile;
	
	if (pFolderType == "draft" ||  pFolderType == "sent") {
		viewXmlFile = pGubun ? "viewXMLFile2_1.xml" : "viewXMLFile2.xml";
	} else if (pFolderType == "tag") {
		viewXmlFile = pGubun ? "viewXMLFileTagTableShort.xml" : "viewXMLFileTagTable.xml";
	} else {
		viewXmlFile = pGubun ? "viewXMLFile1_1.xml" : "viewXMLFile1.xml";
	}

	var newHeaderXml = "/js/ezEmail/Controls_cross/" + g_userLang + "/" + viewXmlFile;

	if (p_HeaderViewXML == newHeaderXml)
            return;

    p_HeaderViewXML = newHeaderXml;

    listContentArry = new Array();
    listSubContentArry = new Array();
    var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    HeaderIni(HeaderObject);
    GetListInfo(HeaderObject, ContentObject);
}
function goToPageByNum(szNum) {
    var currentScrollTop = document.getElementById("contentlistDiv").scrollTop;
    var currentPage = document.getElementById("MailList").getAttribute("curPage");
    document.getElementById("MailList").setAttribute("curPage", szNum); 
    var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    GetListInfo(HeaderObject,ContentObject);
    if (currentPage != document.getElementById("MailList").getAttribute("curPage")) {
        $("#contentlistDiv").scrollTop(0); 
        try {
            if (document.getElementById("HeaderAllCheckBox") != null)
                document.getElementById("HeaderAllCheckBox").checked = false;
        } catch (e) {console.log(e);}
    } else {
        $("#contentlistDiv").scrollTop(currentScrollTop);
    }
}
function selbeforeBlock() {
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock() {
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock_one() {
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var totalPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    if (parseInt(pageNum + 1) <= totalPage)
        goToPageByNum(parseInt(parseInt(pageNum + 1)));
    else
        return;
}
function selbeforeBlock_one() {
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var totalPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    if (parseInt(pageNum -1) > 0)
        goToPageByNum(parseInt(parseInt(pageNum - 1)));
    else
        return;
}
function td_Create1(strtext) {
    document.getElementById("tblPageRayer").innerHTML = strtext;
    // 페이지 만들때 folderTotalCount를 넣어준다.
	folderTotalCount = Number($('#folderTotalCount').text());
	console.log("fc="+folderTotalCount);
}
function makePageSelPage() {
    var strtext;
    var PagingHTML = "";
    document.getElementById("tblPageRayer").innerHTML = "";
    strtext = "<div class=\"pagenavi\">";
    PagingHTML += strtext;
    var totalPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    
    if (searchMode) {
    	document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span id='pSearchListCount' class='txt_color'> " + pSearchListCount + "</span>";
    } else {
    	document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span id='folderUnreadCount' class='txt_color'> " + pFolderUnReadCount + " </span> / <span id='folderTotalCount'>" + pFolderTotalCount + " </span></b>";
    }
    
    if (totalPage > 1 && pageNum != 1) {
        PagingHTML += "<span class=\"btnimg first\" onclick= 'return goToPageByNum(1)'></span>";
    }
    else {
        PagingHTML += "<span class=\"btnimg first disabled\"></span>";
    }
    if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
            PagingHTML += "<span class=\"btnimg prev\" onclick= 'return selbeforeBlock()'></span>";
        }
        else {
            PagingHTML += "<span class=\"btnimg prev disabled\" ></span>";
        }
    }
    else {
        PagingHTML += "<span class=\"btnimg prev disabled\" ></span>";
    }
    var MaxNum;
    var i;
    var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
    if (totalPage >= (startNum + parseInt(BlockSize))) {
        MaxNum = (startNum + parseInt(BlockSize)) - 1;
    }
    else {
        MaxNum = totalPage;
    }
    for (i = startNum; i <= MaxNum; i++) {
        if (i == pageNum) {
        	PagingHTML += "<span class=\"on\">" + i + "</span>";
        }
        else {
            PagingHTML += "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
        }
    }
    if (MaxNum == 0) {
    	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
    }
    if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
            PagingHTML += "<span class=\"btnimg next\" onclick='return selafterBlock()'></span>";
        }
        else {
            PagingHTML += "<span class=\"btnimg next disabled\"></span>";
        }
    }
    else {
        PagingHTML += "<span class=\"btnimg next disabled\"></span>";
    }
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        PagingHTML += "<span class=\"btnimg last\" onclick='return goToPageByNum(" + totalPage + ")'></span>";
    }
    else {
        PagingHTML += "<span class=\"btnimg last disabled\"></span>";
    }
    PagingHTML += "</div>";
    td_Create1(PagingHTML);
}

function event_secondRightClick() {
	 if (document.getElementById("ContextMenuDiv").style.display == "") {
		 HiddenContextMenu();
	 } else {
		 return;
	 }
	
}

function event_listContextMenu(event) {
	if (document.getElementById("mailPanel").style.display == "none") {
		 if (document.getElementById("ContextMenuDiv").style.display == "") {
			 $("mailPanel").css("display","none");
			 HiddenContextMenu();
		 }
	}
    if (!event) event = window.event;
    var EventMouseX = event.clientX;
    var EventMouseY = event.clientY;

    var listsizeheight = document.documentElement.clientHeight;
    var listsizewidth = document.documentElement.clientWidth;
//  var EventDivSize = EventMouseY + 400;   // 2020-08-19 김은실 -컨텍스트메뉴 밑 안보임 현상: 메뉴의 최종 길이를 기준으로, 맥시멈 사이즈를 정하기 위해 밑으로 이동
    if (g_foldertype == "draft") {
    	$("#ContextMenuDiv tbody #replyMenu").css("display","none");
    }
    
    var target = event.target ? event.target : event.srcElement;
    var targetTag = target.tagName;

    if (targetTag == 'SPAN'){ 
		$("#ContextMenuDiv tbody #searchName, #searchInThisBoxByName, #searchAllBoxByName").css("display","");
	} else {
		$("#ContextMenuDiv tbody #searchName, #searchInThisBoxByName, #searchAllBoxByName").css("display","none");
	}

	// 2020-08-19 김은실 -컨텍스트메뉴 밑 안보임 현상:
	// 1) JQuery: $().height(): Chrome,IE 모두 테스트 완료.
	var EventDivSize = EventMouseY + $("#ContextMenuDiv").height() + 70;
	// 2) JQuery를 사용할 수 없다면, 이 방식으로 할수 있음.
	// document.getElementById("ContextMenuDiv").style.display = "block";   
	// var EventDivSize = EventMouseY + document.getElementById("ContextMenuDiv").offsetHeight + 70;   
	// document.getElementById("ContextMenuDiv").style.display = "none";
    if (listsizeheight < EventDivSize) {
    	var Div_ = EventDivSize - listsizeheight;
    	EventMouseY = EventMouseY - Div_;
    }
    
    EventDivSize = EventMouseX + 140;
    if (listsizewidth < EventDivSize) {
    	var Div_ = EventDivSize - listsizewidth;
    	EventMouseX = EventMouseX - Div_;
    }
//    document.getElementById("mailPanel").style.display = "";
    document.getElementById("ContextMenuDiv").style.left = EventMouseX + "px";
    document.getElementById("ContextMenuDiv").style.top = EventMouseY + "px";
    document.getElementById("ContextMenuDiv").style.display = "";
}
function event_listMover(obj) {
	currentMoverId = obj.id;
    if (pGroupListClickObject != obj && !obj.childNodes.item(0).childNodes.item(0).checked) {
        obj.style.backgroundColor = m_strColorOver;
    }
}
function event_SublistMover(obj) {
    if (obj != _SubRowObject && !obj.childNodes.item(0).childNodes.item(0).checked) {
        obj.style.backgroundColor = m_strColorOver;
    }
}
function event_listMout(obj) {
    if (pGroupListClickObject != obj && !obj.childNodes.item(0).childNodes.item(0).checked) {
        obj.style.backgroundColor = m_strColorDefault;
    }
}
function event_SublistMout(obj) {
    if (obj != _SubRowObject && !obj.childNodes.item(0).childNodes.item(0).checked) {
        obj.style.backgroundColor = m_strColorDefault;
    }
}
function event_HeaderClick(obj) {
    if (p_ListOrderObject != null) {
        if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG")
            p_ListOrderObject.childNodes.item(1).outerHTML = "";
    }
    p_ListOrderObject = obj;
    p_ListOrderOption = p_ListOrderObject.getAttribute("orderoption");
    if (p_ListOrderOption == "DESC")
        p_ListOrderOption = "ASC";
    else if (p_ListOrderOption == "ASC")
        p_ListOrderOption = "DESC";
    else
        p_ListOrderOption = "DESC";

    p_ListOrderObject.setAttribute("orderoption", p_ListOrderOption);
    p_ListOrderby = p_ListOrderObject.getAttribute("prop");

    if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG") {
        if (p_ListOrderOption == "DESC")
            p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortdown.gif");
        else
            p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortup.gif");
    }
    else {
        var _HeaderSpanimg = document.createElement("IMG");
        if (p_ListOrderOption == "DESC")
            _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
        else
            _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

        _HeaderSpanimg.setAttribute("align", "absmiddle");
        obj.appendChild(_HeaderSpanimg);
    }
    var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    GetListInfo(HeaderObject, ContentObject);
}

function event_SubHeaderClick(obj) {
    if (p_SubListOrderObject != null) {
        if (p_SubListOrderObject.childNodes.length > 1 && p_SubListOrderObject.childNodes[1].nodeName == "IMG")
            p_SubListOrderObject.childNodes.item(1).outerHTML = "";
    }
    p_SubListOrderObject = obj;
    p_ListOrderOption_SUB = p_SubListOrderObject.getAttribute("orderoption");
    if (p_ListOrderOption_SUB == "DESC")
        p_ListOrderOption_SUB = "ASC";
    else if (p_ListOrderOption_SUB == "ASC")
        p_ListOrderOption_SUB = "DESC";
    else
        p_ListOrderOption_SUB = "DESC";

    p_SubListOrderObject.setAttribute("orderoption", p_ListOrderOption_SUB);
    p_ListOrderby_SUB = p_SubListOrderObject.getAttribute("prop");

    if (p_SubListOrderObject.childNodes.length > 1 && p_SubListOrderObject.childNodes[1].nodeName == "IMG") {
        if (p_ListOrderOption_SUB == "DESC")
            p_SubListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortdown.gif");
        else
            p_SubListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortup.gif");
    }
    else {
        var _HeaderSpanimg = document.createElement("IMG");
        if (p_ListOrderOption_SUB == "DESC")
            _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
        else
            _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

        _HeaderSpanimg.setAttribute("align", "absmiddle");
        p_SubListOrderObject.appendChild(_HeaderSpanimg);
    }
    var HeaderObject = document.getElementById("GroupSubHeader");
    var ContentObject = document.getElementById("GroupSubList");
    GetListInfo_SUB(HeaderObject, ContentObject);
}

function event_SubHeaderCheckBoxClick(obj) {
    if (obj.checked) {
        for (var i = 0; i < document.getElementById("GroupSubList").childNodes.length; i++) {
            document.getElementById("GroupSubList").childNodes.item(i).childNodes.item(0).childNodes.item(0).checked = true;
            document.getElementById("GroupSubList").childNodes.item(i).style.backgroundColor = m_strColorSelect;
            listSubContentArry[listSubContentArry.length] = document.getElementById("GroupSubList").childNodes.item(i).getAttribute("id");
        }
    }
    else {
        for (var i = 0; i < document.getElementById("GroupSubList").childNodes.length; i++) {
            document.getElementById("GroupSubList").childNodes.item(i).childNodes.item(0).childNodes.item(0).checked = false;
            document.getElementById("GroupSubList").childNodes.item(i).style.backgroundColor = m_strColorDefault;
        }
        listSubContentArry = new Array();
    }
}
function event_HeaderCheckBoxClick(obj) {
	
	// mail list DomElement
	var mailListElement = document.getElementById("MailList");
	
	// 메일 리스트가 비어있다면 함수 종료 (검색결과 없음 또는 메일 없음)
	if (isEmptyMailList(mailListElement)) {
		return;
	}
	
	// tr 노드들 (메일 리스트의 전체 행)
	var mailNodes = mailListElement.childNodes;
	// tr 노드 (하나의 행)
	var mailNode;
	// tr 노드 개수
	var nodeCount = mailNodes.length;
	
    if (obj.checked) {
    	
        for (var i = 0; i < nodeCount; i++) {
        	mailNode = mailNodes.item(i);
        	
        	if (mailNode.childNodes.item(0).childNodes.length != 0) {
        		mailNode.childNodes.item(0).childNodes.item(0).checked = true;
        	}
        	
        	
        	mailNode.style.backgroundColor = m_strColorSelect;
            //TODO: 테스트해보기 2016-06-02
            // dhlee: modified so that existing elements aren't merged with new ones.
            //listContentArry[listContentArry.length] = document.getElementById("MailList").childNodes.item(i).getAttribute("id");
            listContentArry[i] = mailNode.getAttribute("id");
        }
    } else {
    	
        for (var i = 0; i < nodeCount; i++) {
        	mailNode = mailNodes.item(i);
        	
        	if (mailNode.childNodes.item(0).childNodes.length != 0) {
        		mailNode.childNodes.item(0).childNodes.item(0).checked = false;
        	}
        	mailNode.style.backgroundColor = m_strColorDefault;
        }
        
        listContentArry = new Array();
    }
}

// MailList id값을 가진 DomElement를 파라미터로 함
// 메일 Row가 존재하지 않으면 true, 있다면 false
function isEmptyMailList(mailListElement) {
	
	if (mailListElement === undefined || mailListElement === null) {
		return true;
	}
	
	if (mailListElement.childElementCount > 1) {
		return false;
	}
	
	var firstMailNode = mailListElement.childNodes.item(0);
	
	return firstMailNode.childElementCount === 1;
}

var PressShiftKey = false;
var PressCtrlKey = false;
function event_listOnkeyUp(event) {
	
	if (event.target.className == "Mail_Input" || event.target.name == "keyword" || event.target.name == "prekeyword") {
		return;
	}
	
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;
    }
    switch (event.keyCode) {
        case 16: PressShiftKey = false; break;
        case 17: PressCtrlKey = false; break;
        case 46:
            if (event.shiftKey) {
                deleteWork(true);
                PressShiftKey = false;
            }
            else {
                deleteWork(false);
            }
            break;
    }

}
function event_listOnkeyDown(event) {
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;
    }
    switch (event.keyCode) {
        case 16: PressShiftKey = true; break;
        case 17: PressCtrlKey = true; break;
    }
}
function ArrayDelete(TargetArray, DeleteNodeStr) {
    var TempArray = new Array();
    for (var i = 0; i < TargetArray.length; i++) {
        if (TargetArray[i] != DeleteNodeStr)
            TempArray[TempArray.length] = TargetArray[i];
    }
    TargetArray = TempArray;
    return TargetArray;
}
var listContentArry = new Array();
var listSubContentArry = new Array();
var listEventCheckbox = false;
var listSubEventCheckbox = false;
function event_listclick(obj, event) {	
	if (obj.tagName == "TD") {
        obj = obj.parentElement;
    }
	
    if (!listEventCheckbox) {
        if (document.getElementById("HeaderAllCheckBox").checked) {
            var TemplistArray = new Array();
            if (obj.childNodes.item(0).childNodes.item(0).checked) {
                for (var i = 0; i < listContentArry.length; i++) {
                    if (obj.getAttribute("id") == listContentArry[i]) {
                        obj.childNodes.item(0).childNodes.item(0).checked = false;
                        obj.style.backgroundColor = m_strColorDefault;
                    }
                    else {
                        TemplistArray[TemplistArray.length] = listContentArry[i];
                    }
                }
                listContentArry = TemplistArray;
            }
            else {
                obj.childNodes.item(0).childNodes.item(0).checked = true;
                obj.style.backgroundColor = m_strColorSelect;
                listContentArry[listContentArry.length] = obj.getAttribute("id");
            }
        }
        else {
            if (!event.shiftKey && !event.ctrlKey && listContentArry.length > 0) {
                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                    _RowObject = document.getElementById(listContentArry[Cnt]);
                    _RowObject.style.backgroundColor = m_strColorDefault;
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                    
                    if (useReceivingChk) {
                    	var receiveChilds = $("#MailList [id^=" + listContentArry[Cnt] + "_]");
                    	
                    	for (var i = 0; i < receiveChilds.length; i++) {
                    		receiveChilds[i].style.backgroundColor = m_strColorDefault;
                    	}
                    }// end if
                    
                }
                listContentArry = new Array();
            }
            if (event.shiftKey) {
                var SelectedPreObj = null;
                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                    _RowObject = document.getElementById(listContentArry[Cnt]);
                    if (Cnt == 0)
                        SelectedPreObj = _RowObject;

                    _RowObject.style.backgroundColor = m_strColorDefault;
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listContentArry = new Array();
                _RowObject = obj;
                var PrelistContent;
                if (SelectedPreObj == null)
                    PrelistContent = _RowObject.getAttribute("id");
                else
                    PrelistContent = SelectedPreObj.getAttribute("id");

                var CurlistContent = obj.getAttribute("id");
                var PrePoint = parseInt(PrelistContent.replace("Maillist_", ""));
                var CurPoint = parseInt(CurlistContent.replace("Maillist_", ""));
                if (PrePoint < CurPoint) {

                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
                        _RowObject = document.getElementById("Maillist_" + Cnt);
                        _RowObject.style.backgroundColor = m_strColorSelect;
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                    }

                }
                else if (PrePoint > CurPoint) {
                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
                        _RowObject = document.getElementById("Maillist_" + Cnt);
                        _RowObject.style.backgroundColor = m_strColorSelect;
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                    }
                }
                else if (PrePoint == CurPoint) {
                    if (_RowObject.childNodes.item(0).childNodes.item(0).checked) {
                        _RowObject.style.backgroundColor = m_strColorDefault;
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                        listContentArry = ArrayDelete(listContentArry, _RowObject.id);
                    }
                    else {
                        _RowObject.style.backgroundColor = m_strColorSelect;
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listContentArry[listContentArry.length] = GetAttribute(_RowObject, "id");
                        prevShow();
                    }
                }
                else
                    return;
            }
            else {
                _RowObject = obj;
                if (_RowObject.childNodes.item(0).childNodes.item(0).checked) {
                    _RowObject.style.backgroundColor = m_strColorDefault;
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                    listContentArry = ArrayDelete(listContentArry, _RowObject.id);
                }
                else {
                    _RowObject.style.backgroundColor = m_strColorSelect;
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                    listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                    
                    if (useReceivingChk) {
                    	var receiveChilds = $("#MailList [id^=" + _RowObject.getAttribute("id") + "_]");
                    	
                    	for (var i = 0; i < receiveChilds.length; i++) {
                    		receiveChilds[i].style.backgroundColor = m_strColorSelect;
                    	}
                    }// end if
                    
                    prevShow();
                }
            }
            document.getElementById("ContextMenuDiv").style.display = "none";
        }
    }
    else
        listEventCheckbox = false;
}
function event_listCheckboxclick(obj) {
    if (obj.checked) {
        obj.parentElement.parentElement.style.backgroundColor = m_strColorSelect;
        
        var allChild = $("#MailList")[0].childNodes;
        
        for (var i = 0;i < allChild.length; i++) {
        	if (allChild[i].id.indexOf(obj.parentNode.parentNode.id + "_") != -1) {
        		allChild[i].style.backgroundColor = m_strColorSelect;
        	}
        }
        
        listContentArry[listContentArry.length] = obj.parentElement.parentElement.getAttribute("id");
    }
    else {
        var TemplistArray = new Array();
        
        var allChild = $("#MailList")[0].childNodes;
        
        for (var i = 0;i < allChild.length; i++) {
        	if (allChild[i].id.indexOf(obj.parentNode.parentNode.id + "_") != -1) {
        		/*allChild[i].style.backgroundColor = m_strColorDefault;*/
        		allChild[i].style.backgroundColor = m_strColorOpened;
        	}
        }
        
        for (var i = 0; i < listContentArry.length; i++) {
            if (obj.parentElement.parentElement.getAttribute("id") == listContentArry[i]) {
                obj.parentElement.parentElement.style.backgroundColor = m_strColorDefault;
            }
            else {
                TemplistArray[TemplistArray.length] = listContentArry[i];
            }
        }
        listContentArry = TemplistArray;
    }
    listEventCheckbox = true;
}
function event_Sublistclick(obj) {
    if (!listSubEventCheckbox) {
        if (document.getElementById("HeaderAllCheckBox").checked) {
            var TemplistArray = new Array();
            if (obj.childNodes.item(0).childNodes.item(0).checked) {
                for (var i = 0; i < listSubContentArry.length; i++) {
                    if (obj.getAttribute("id") == listSubContentArry[i]) {
                        obj.childNodes.item(0).childNodes.item(0).checked = false;
                        obj.style.backgroundColor = m_strColorDefault;
                    }
                    else {
                        TemplistArray[TemplistArray.length] = listSubContentArry[i];
                    }
                }
                listSubContentArry = TemplistArray;
            }
            else {
                obj.childNodes.item(0).childNodes.item(0).checked = true;
                obj.style.backgroundColor = m_strColorSelect;
                listSubContentArry[listSubContentArry.length] = obj.getAttribute("id");
            }
        }
        else {
            if (!PressShiftKey && !PressCtrlKey && listSubContentArry.length > 0) {
                for (var Cnt = 0 ; Cnt < listSubContentArry.length; Cnt++) {
                    _SubRowObject = document.getElementById(listSubContentArry[Cnt]);
                    _SubRowObject.style.backgroundColor = m_strColorDefault;
                    _SubRowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listSubContentArry = new Array();
            }
            if (PressShiftKey) {
                for (var Cnt = 0 ; Cnt < listSubContentArry.length; Cnt++) {
                    _SubRowObject = document.getElementById(listSubContentArry[Cnt]);
                    _SubRowObject.style.backgroundColor = m_strColorDefault;
                    _SubRowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listSubContentArry = new Array();
                var PrelistContent = _SubRowObject.getAttribute("id");
                _SubRowObject = obj;
                var CurlistContent = obj.getAttribute("id");
                var PrePoint = parseInt(PrelistContent.replace("Maillist_", ""));
                var CurPoint = parseInt(CurlistContent.replace("Maillist_", ""));
                if (PrePoint < CurPoint) {

                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
                        _SubRowObject = document.getElementById("Maillist_" + Cnt);
                        _SubRowObject.style.backgroundColor = m_strColorSelect;
                        _SubRowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listSubContentArry[listSubContentArry.length] = _SubRowObject.getAttribute("id");
                    }

                }
                else if (PrePoint > CurPoint) {
                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
                        _SubRowObject = document.getElementById("Maillist_" + Cnt);
                        _SubRowObject.style.backgroundColor = m_strColorSelect;
                        _SubRowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listSubContentArry[listSubContentArry.length] = _SubRowObject.getAttribute("id");
                    }
                }
                else
                    return;
            }
            else {
                _SubRowObject = obj;
                if (_SubRowObject.childNodes.item(0).childNodes.item(0).checked) {
                    _SubRowObject.style.backgroundColor = m_strColorDefault;
                    _SubRowObject.childNodes.item(0).childNodes.item(0).checked = false;
                    listSubContentArry = ArrayDelete(listSubContentArry, _SubRowObject.id);
                }
                else {
                    _SubRowObject.style.backgroundColor = m_strColorSelect;
                    _SubRowObject.childNodes.item(0).childNodes.item(0).checked = true;
                    listSubContentArry[listSubContentArry.length] = _SubRowObject.getAttribute("id");
                    prevShow();
                }
            }
            document.getElementById("ContextMenuDiv").style.display = "none";
        }
    }
    else
        listSubEventCheckbox = false;
}
function event_SublistCheckboxclick(obj) {
    if (obj.checked) {
        obj.parentElement.parentElement.style.backgroundColor = m_strColorSelect;
        listSubContentArry[listSubContentArry.length] = obj.parentElement.parentElement.getAttribute("id");
    }
    else {
        var TemplistArray = new Array();
        for (var i = 0; i < listSubContentArry.length; i++) {
            if (obj.parentElement.parentElement.getAttribute("id") == listSubContentArry[i]) {
                obj.parentElement.parentElement.style.backgroundColor = m_strColorDefault;
            }
            else {
                TemplistArray[TemplistArray.length] = listSubContentArry[i];
            }
        }
        listSubContentArry = TemplistArray;
    }
    listSubEventCheckbox = true;
}

function checkBlockedMail(url) {
    var strQuery = "<URL>" + url + "</URL>";
    xmlhttp_mailCheckBlock = createXMLHttpRequest();
    
    var previewUrl = "/ezEmail/mailPrevShow.do?MSGFLAG=N";
    
    if (typeof(shareId) != "undefined" && shareId != "") {
        previewUrl += "&shareId=" + encodeURIComponent(shareId);
    }
    
    xmlhttp_mailCheckBlock.open("POST", previewUrl, false);
    xmlhttp_mailCheckBlock.send(strQuery);

    var pBlockedMail = 1;
    
    if (xmlhttp_mailCheckBlock.status == 200) {
        pBlockedMail = getNodeText(SelectNodes(xmlhttp_mailCheckBlock.responseXML, "DATA/BLOCKEDMAIL")[0]);        
    }
    
    return pBlockedMail;
}

function event_listDBClick(obj) {
    if (checkBlockedMail(obj.getAttribute("_href")) == '1') {
        alert(strLangLDH07);
        return;        
    }
    
    callMsgDlg(obj.getAttribute("_contentclass"), obj.getAttribute("_href"), obj.getAttribute("_isdraft"));
    MailList_ChangeStatus(obj);
}
function event_SublistDBClick(obj) {
    _SublistDBClickEvent = true;
    callMsgDlg(obj.getAttribute("_contentclass"), obj.getAttribute("_href"));
    MailList_ChangeStatus(obj);
}
// 보낸사람 클릭
var mailWriteSenderChk = true;
function event_senderNameClick(thisParent, event){
	if (!mailWriteSenderChk) { 
		return; 
	} else {
        var p_Msgto = $(thisParent).attr("data-msgto");

        if (p_Msgto.includes("&")) {
            $(thisParent).attr("data-msgto", encodeURIComponent(p_Msgto));
        }

		setTimeout(function(){
			var msgToLen = $(thisParent).attr("data-msgtoLen");
			
			if (msgToLen > 20) { // 보낸편지함 > 받는 사람 클릭시 받는사람이 20명 이상일 경우 빈 메일창 띄우기 (메일쓰기 get방식으로 변경하면서 수정)
				new_mail_onclick();
			} else {
				new_mail_onclick(thisParent); // 메일쓰기		
			}

			mailWriteSenderChk = true;
		}, 200);
		
		mailWriteSenderChk = false;
	}
}
function event_senderNameDBClick(event) {
	event.stopPropagation();
}  
var pGroupListClickObject;
function event_GrouplistDBClick(obj) {
    if (_SublistDBClickEvent) {
        _SublistDBClickEvent = false;
        return;
    }
    if (pGroupListClickObject == obj) {
        pGroupListClickObject.childNodes.item(0).childNodes.item(0).src = GroupplusImg;
        pGroupListClickObject.style.backgroundColor = m_strColorDefault;
        var SubGroupListTarget = document.getElementById(pGroupListClickObject.getAttribute("id") + "sub")
        SubGroupListTarget.style.display = "none";
        SubGroupListTarget.childNodes.item(0).innerHTML = ""
        pGroupListClickObject = null;
        return;
    }
    var pGroupProp = obj.getAttribute("prop");
    var pGroupMode = obj.getAttribute("mode");
    p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
    if (pGroupMode == "SENT") {
        p_ListorderType_SUB = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                          " AND \"http://schemas.microsoft.com/mapi/sent_representing_name\" = '" + pGroupProp + "' ";
        p_ListOrderby_SUB = "urn:schemas:httpmail:datereceived";
        p_ListOrderOption_SUB = "DESC";
    }
    else if (pGroupMode == "SUBJECT") {
        p_ListorderType_SUB = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                          " AND \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\" = '" + pGroupProp + "' ";
        p_ListOrderby_SUB = "urn:schemas:httpmail:datereceived";
        p_ListOrderOption_SUB = "DESC";
    }
    if (pGroupListClickObject != null) {
        pGroupListClickObject.style.backgroundColor = m_strColorDefault;
        try{
        	var SubGroupListTarget = document.getElementById(pGroupListClickObject.getAttribute("id") + "sub")
            SubGroupListTarget.style.display = "none";
            SubGroupListTarget.childNodes.item(0).innerHTML = ""
        } catch (e) {console.log(e);}
    }
    pGroupListClickObject = obj;
    var NewDIV = document.createElement("DIV");
    NewDIV.innerHTML = document.getElementById("GroupSubObject").innerHTML;
    var SubGroupListTarget = document.getElementById(pGroupListClickObject.getAttribute("id") + "sub")
    SubGroupListTarget.style.display = "";
    SubGroupListTarget.childNodes.item(0).appendChild(NewDIV);
    pGroupListClickObject.style.backgroundColor = m_strColorSelect;
    pGroupListClickObject.childNodes.item(0).childNodes.item(0).src = GroupminImg;
    var HeaderObject = document.getElementById("GroupSubHeader");
    var ContentObject = document.getElementById("GroupSubList");
    listSubContentArry = new Array();
    HeaderIni_SUB(HeaderObject);
    GetListInfo_SUB(HeaderObject, ContentObject);
}
function FormatSize(p_Prop8) {
    var iSize = parseInt(p_Prop8);
    if (iSize < 1000) {
        p_Prop8 = iSize + " B";
    }
    else {
        iSize = Math.round(iSize / 1024);

        if (iSize > 1000) {
            iSize = Math.round(iSize / 1024);
            iSize = String(iSize);
            p_Prop8 = iSize + " MB";
        }
        else
            p_Prop8 = iSize + " KB";
    }
    return p_Prop8;

}
function GetContentClassImg(ContentClass, isRead) {
    var Rvalue = "";
    switch (ContentClass) {
        case "IPM.Note":
            {
                Rvalue = isRead == "1" ? "/images/ImgIcon/icon-msg-read.gif" : "/images/ImgIcon/icon-msg-unread.gif";
                break;
            }
        case "IPM.Note.StorageQuotaWarning":
            {
                Rvalue = isRead == "1" ? "/images/ImgIcon/icon-msg-read.gif" : "/images/ImgIcon/icon-msg-unread.gif";
                break;
            }
        case "IPM.Note.StorageQuotaWarning.Warning":
            {
                Rvalue = isRead == "1" ? "/images/ImgIcon/icon-msg-read.gif" : "/images/ImgIcon/icon-msg-unread.gif";
                break;
            }
        case "REPORT.IPM.Note.IPNRN":
            {
                Rvalue = "/images/ImgIcon/icon-report-ipnrn.gif";
                break;
            }
        case "REPORT.IPM.Note.IPNNRN":
            {
                Rvalue = "/images/ImgIcon/icon-report-ipnnrn.gif";
                break;
            }
        case "IPM.Note.Rules.OofTemplate.Microsoft":
            {
                Rvalue = "/images/ImgIcon/icon-oof.gif";
                break;
            }
        case "REPORT.IPM.Note.NDR":
            {
                Rvalue = "/images/ImgIcon/icon-report-ndr.gif";
                break;
            }
        case "REPORT.IPM.Note.Relayed.DR":
            {
                Rvalue = "/images/ImgIcon/icon-report-dr.gif";
                break;
            }
        case "REPORT.IPM.Note.DR":
            {
                Rvalue = "/images/ImgIcon/icon-report-dr.gif";
                break;
            }
        case "IPM.Note.Microsoft.Voicemail":
            {
                Rvalue = "/images/ImgIcon/icon-msg-voicemail.gif";
                break;
            }
        case "IPM.Note.Microsoft.Voicemail.UM.CA":
            {
                Rvalue = "/images/ImgIcon/icon-msg-voicemail.gif";
                break;
            }
        case "IPM.Note.Microsoft.Missed.Voice":
            {
                Rvalue = "/images/ImgIcon/icon-msg-missedvoice.gif";
                break;
            }
        case "IPM.Schedule.Meeting.Request":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq.png";
                break;
            }
        case "IPM.Schedule.Meeting.Canceled":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-cancel.png";
                break;
            }
        case "IPM.Schedule.Meeting.Resp.Pos":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-accept.png";
                break;
            }
        case "IPM.Schedule.Meeting.Resp.Neg":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-decline.png";
                break;
            }
        case "IPM.Schedule.Meeting.Resp.Tent":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-tentative.png";
                break;
            }
        case "REPORT.IPM.Schedule.Meeting.Request.NDR":
            {
                Rvalue = "/images/ImgIcon/icon-report-ndr.png";
                break;
            }
        case "IPM.Contact":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-tentative.gif";
                break;
            }
        case "IPM.Appointment":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-decline.gif";
                break;
            }
        case "IPM.Sharing":
            {
                Rvalue = "/images/ExchWeb/img/icon-appt.gif";
                break;
            }
        case "REPORT.IPM.Note.Delayed.DR":
            {
                Rvalue = "/images/ImgIcon/icon-report-ndr.gif";
                break;
            }
        case "REPLY":
            {
                Rvalue = "/images/ImgIcon/icon-msg-read4.gif";
                break;
            }
        case "FORWARD":
            {
                Rvalue = "/images/ImgIcon/icon-msg-read2.gif";
                break;
            }
        case "IPM.Note.StorageQuotaWarning.SendReceive":
            {
                Rvalue = "/images/ImgIcon/icon-report-ndr.gif";
                break;
            }
        default:
            {
                Rvalue = isRead == "1" ? "/images/ImgIcon/icon-msg-read.gif" : "/images/ImgIcon/icon-msg-unread.gif";
                break;
            }
    }
    return "<IMG style='cursor:pointer' draggable='false' src='" + Rvalue + "'/>";
}
