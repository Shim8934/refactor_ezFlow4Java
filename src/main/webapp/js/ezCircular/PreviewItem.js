function MailOptionView(obj) {
    if (obj.getAttribute("mode") == "off") {
        document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 160 + "px";
        if(pAdminType == "y")
            document.getElementById("layer_Viewpopup").style.top = "50px";
        else
            document.getElementById("layer_Viewpopup").style.top = "100px";
        document.getElementById("layer_Viewpopup").style.display = "";
        //obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
        obj.setAttribute("class", "icon16 btn_onarrow_down");
        obj.setAttribute("mode", "on");
    }
    else {
        MailOptionHidden();
    }
}
//레이어팝업 바깥쪽 클릭시 레이어팝업 꺼지게 2018-02-22 강민수92
function MailOptionHiddenOutside(e) {
	var container = $('#layer_Viewpopup');
	var maillistoptionmode = $('#maillistoptiondiv').attr('mode');
	if (maillistoptionmode == "on") {
		if (container.has(e.target).length === 0 && $(e.target).attr('id') != 'maillistoptiondiv') {
			MailOptionHidden();
		}
	}
}
function MailOptionHidden() {
    document.getElementById("layer_Viewpopup").style.display = "none";
    document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
    //document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
    document.getElementById("maillistoptiondiv").setAttribute("class", "icon16 btn_arrow_down");
}

function PreviewRayerChange(pGubun) {
    pGubun = pGubun.trim();
    if (selobj != null && pGubun != "NONE" && selobj.childNodes.length != 0)
        ItemPreviewRead(selobj);

    if (pGubun == "OFF")
        pGubun = "NONE";
    if (clickPreviweType == "PHOTO") {
        if (document.documentElement.clientWidth < 1300) {
            PreviewRayerChange_photo("NONE");
        }
        else {
            PreviewRayerChange_photo(pGubun);
        }

        return;
    }
    try {
        if (document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "w-resize";

        if ((pGubun == "H" || pGubun == "W") && selobj != null) {
            if (selobj.childNodes.length != 0)
                selobj.childNodes[2].style.fontWeight = "normal";
        }

        isPreviewChange = true;
        if (pGubun == "NONE") {
            pPreviewShow_HOW = "OFF";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "none";
            CurrentHeight = document.documentElement.clientHeight - 110;
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = "100%";
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
            } else {
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
            }
            g_bPrevShow = false;
        }
        else if (pGubun == "W") {
            if (pMailListDiv == 0 || pMailPreVDiv == 0) {
                pMailListDiv = 50; pMailPreVDiv = 50;
            }

            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerW").style.display = "block";
            document.getElementById("PreviewRayerH").style.display = "none";

            CurrenWidth = document.documentElement.clientWidth - 10;
            CurrentHeight = document.documentElement.clientHeight - 110;
            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10) + "px";
            pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
            pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));

            document.getElementById("MailListRayer").style.width = "100%";
            document.getElementById("PreviewRayerW").style.width = "100%";
            document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
                document.getElementById("BoardList_BODY").style.height = (pMailListHeightW - 100) + "px";
            }
            else {
                document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
                document.getElementById("BoardList_BODY").style.height = (pMailListHeightW - 100) + "px";
            }
            document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

            document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
            document.getElementById("PreW_subject").style.width = (CurrenWidth - 200) + "px";
            
            pPreviewShow_HOW = "W";
            pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
            pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);

            if (onclickFlag) {
                document.getElementById("Preview_HeaderW").style.display = "";
                document.getElementById("Preview_HeaderH").style.display = "none";
            }
            g_bPrevShow = true;
        }
        else if (pGubun == "H") {
            if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                pMailListDiv_H = 50; pMailPreVDiv_H = 50;
            }
            if (onclickFlag) {
            }

			if (parent.document.getElementById("tab1")) {
				CurrenWidth = document.documentElement.clientWidth + 7;
			} else {
				CurrenWidth = document.documentElement.clientWidth - 20;
			}
            CurrentHeight = document.documentElement.clientHeight - 110;
            pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
            pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "inline-block";

            if (CurrenWidth < (pMailListWidthH + pMailPreWidthH)) {
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
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
            }
            else {
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
            }
            
            //document.getElementById("divList").style.overflow = "auto";
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 5) + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 68) + "px";
            document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 155) + "px";
            
            pPreviewShow_HOW = "H";
            pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
            pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);

            if (onclickFlag) {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
            }

            g_bPrevShow = true;
        }
        MailOptionHidden();
        PreviewMode_ChangeBtn();
        if (pAdminType != "y" && firstFlag)
            Set_BoardConfig();
        isPreviewChange = false;
        scroll();
    } catch (e) { }
}

var SetConfig = true;

function PreviewMode_ChangeBtn() {
    try {
    /*document.getElementById("PreViewNone").setAttribute("src", "/images/kr/cm/btn_noframe.gif");
    if (document.getElementById("PreViewBottom") != null)
        document.getElementById("PreViewBottom").setAttribute("src", "/images/kr/cm/btn_bottomframe.gif");
    document.getElementById("PreViewleft").setAttribute("src", "/images/kr/cm/btn_leftframe.gif");
    if (pPreviewShow_HOW.trim() == "H")
        document.getElementById("PreViewleft").setAttribute("src", "/images/kr/cm/btn_onleftframe.gif");
    else if (pPreviewShow_HOW.trim() == "W") {
        if (document.getElementById("PreViewBottom") != null)
            document.getElementById("PreViewBottom").setAttribute("src", "/images/kr/cm/btn_onbottomframe.gif");
    }
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
    	
    } catch (e) { }
}

/* 2021-01-21 홍승비 - 미리보기 영역 열려있지 않은 경우, 원클릭으로 회람판 읽기팝업창 표출 */
function ItemPreviewRead_click(obj) {
    selobj = document.getElementById(obj);
    onclickFlag = true;
    
    if (g_bPrevShow) {
        ItemPreviewRead(document.getElementById(obj));
    }
}

var xmlhttp = createXMLHttpRequest();
var xmlhttp2 = createXMLHttpRequest();
function ItemPreviewRead(obj) {
    obj.childNodes[2].style.fontWeight = "normal";

    var pcircularId = obj.getAttribute("CIRCULARID");
    var pmemberId = obj.getAttribute("MEMBERID");
    
    clickPreviweType = "TEXT";
    
    if (document.getElementById("previewmail_bar_h") != null)
        document.getElementById("previewmail_bar_h").style.cursor = "w-resize";
    
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("GET", "/ezCircular/getPreviewItem.do?pcircularId=" + pcircularId + "&pmemberId=" + pmemberId, true);
    xmlhttp.onreadystatechange = event_ItemPreviewRead;
    xmlhttp.send();
    xmlhttp2 = createXMLHttpRequest();
    xmlhttp2.open("GET", "/ezCircular/getItemAttachments.do?pcircularId=" + pcircularId, true);
    xmlhttp2.onreadystatechange = event_ItemPreviewRead;
    xmlhttp2.send();
    
    /* 2017-07-07 이효진 */
//    $(obj).find("img[src='/images/ImgIcon/circular_unread.gif']").attr('src', '/images/ImgIcon/circular_read.gif')
}
var ItemID;
var WriterID;
var WriterName;
var WriterDeptName;
var WriterCompanyName;
var ContentLocation;

var CircularId;
var Title;
var pOCS;
var RegDate;
var Content;
var status;
var option;
var memberFile;
var picNone = "/images/kr/main/bestEmployee_pic_none.png";

function event_ItemPreviewRead() {
    if ((xmlhttp != null && xmlhttp.readyState == 4) && (xmlhttp2 != null && xmlhttp2.readyState == 4)) {
        if ((xmlhttp.status >= 200 && xmlhttp.status < 300) && (xmlhttp2.status >= 200 && xmlhttp2.status < 300)) {
            if (document.getElementById("PreViewBottom") != null){
            	document.getElementById("PreViewBottom").style.display = "";
            }
            
            xmlDoc = loadXMLString(xmlhttp.responseText);
            
            CircularId = SelectSingleNodeValueNew(xmlDoc, "NODES/NODE/CircularId");
            MemberId = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/MemberId");
            MemberName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/MemberName");
            RegDate = SelectSingleNodeValueNew(xmlDoc, "NODES/NODE/RegDate");
            Title = SelectSingleNodeValueNew(xmlDoc, "NODES/NODE/Title");
            Content = SelectSingleNodeValueNew(xmlDoc, "NODES/NODE/Content");
            status = SelectSingleNodeValueNew(xmlDoc, "NODES/NODE/Status");
            option = SelectSingleNodeValueNew(xmlDoc, "NODES/NODE/Option");
            memberFile = SelectSingleNodeValueNew(xmlDoc, "NODES/NODE/MemberFile");
            
            var userPic = (memberFile == null || memberFile == "null")? "/admin/ezOrgan/getPersonalInfo.do?fileName=" + memberFile : picNone;
            document.getElementById("Pre" + pPreviewShow_HOW + "_userPic").innerHTML = "<img src='" + userPic + "' onerror=\"this.src='" + picNone + "'\" width='55px' height='55px'>";

            if (pPreviewShow_HOW.trim() == "W") {
                document.getElementById("Preview_HeaderW").style.display = "";
                document.getElementById("Preview_HeaderH").style.display = "none";
                document.getElementById("ifrmPreViewW").src = "/ezCircular/circularItemPreviewContent.do";
                //document.getElementById("PreW_subject").style.width = (CurrenWidth - 200 - 10) + "px";
            }
            else if (pPreviewShow_HOW.trim() == "H") {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
                document.getElementById("ifrmPreViewH").src = "/ezCircular/circularItemPreviewContent.do";
            }
            else {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "none";
            }
        }
    }
    
    if (typeof (window.parent.frames.left) != "undefined") {
        parent.frames["left"].getNewCircularCount();
	}
}

function previewItemSet() {
    document.getElementById("Pre" + pPreviewShow_HOW + "_sub_subject").innerText = Title;
    document.getElementById("Pre" + pPreviewShow_HOW + "_sub_subject").setAttribute("title", Title);
    document.getElementById("Pre" + pPreviewShow_HOW + "_MailReceiver").innerHTML = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + MemberName
	+ "' onclick='MemberInfo_onclick(\"" + MemberId + "\")'>" + MemberName + "</span>";
    document.getElementById("Pre" + pPreviewShow_HOW + "_date").innerText = RegDate.substring(0, 16);
    
    var readHTML = Content;
    var tempText = xmlhttp2.responseText;
    
    if (xmlhttp2.readyState == 4) {
        setTimeout(function () {
            if (pPreviewShow_HOW.trim() == "W") {
                if (document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent != undefined) {
                    document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent(readHTML, tempText, option);
                }
            }
            else if (pPreviewShow_HOW.trim() == "H") {
                if (document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent != undefined) {
                    document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent(readHTML, tempText, option);
                }
            }
        }, 100);
    }
}

function loadsetInterval(readHTML, responseText) {
    try {
        if (pPreviewShow_HOW.trim() == "W") {
            if (document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent != undefined) {
                if (document.getElementById("ifrmPreViewW").contentWindow.document.getElementById("txtContent") != null) {
                    document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent(readHTML, responseText);
                    clearInterval(interValue);
                }
            }
        }
        else if (pPreviewShow_HOW.trim() == "H") {
            if (document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent != undefined) {
                if (document.getElementById("ifrmPreViewH").contentWindow.document.getElementById("txtContent") != null) {
                    document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent(readHTML, responseText);
                    clearInterval(interValue);
                }
            }
        }

    } catch (e) {

    }
}
function event_downContent(result, result2) {
        document.getElementById("Pre" + pPreviewShow_HOW.trim() + "_sub_subject").textContent = Title;
        document.getElementById("Pre" + pPreviewShow_HOW.trim() + "_MailReceiver").innerHTML = pOCS;
        document.getElementById("Pre" + pPreviewShow_HOW.trim() + "_date").textContent = WriteDate;
        document.getElementById("ifrmPreView" + pPreviewShow_HOW.trim()).contentWindow.makeWriteContent(result, result2);
}

function PreviewH_onMouserDown(e) {
    curevent = (typeof event == 'undefined' ? e : event);

    var newPos_H = curevent.clientX;

    if (newPos_H < parseInt(CurrenWidth * 0.40)) {
        newPos_H = parseInt(CurrenWidth * 0.40);
    }
    else if (newPos_H > parseInt(CurrenWidth * 0.65)) {
        newPos_H = parseInt(CurrenWidth * 0.65);
    }

    document.getElementById("ResizeBarH").style.left = newPos_H + "px";
    document.getElementById("ResizeBarH").style.display = "";
    document.getElementById("mailPanel").style.display = "";
    PreviewH_Move = true;
}
function PreviewW_onMouserDown(e) {
    curevent = (typeof event == 'undefined' ? e : event);

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
            document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 5) + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
            document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 155) + "px";
            pMailListDiv_H = (pMailListWidthH / CurrenWidth) * 100;
            pMailPreVDiv_H = (pMailPreWidthH / CurrenWidth) * 100;

        } else if (PreviewW_Move) {
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
            document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
            document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

            document.getElementById("BoardList_BODY").style.height = (pMailListHeightW - 100) + "px";
            
            if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1)
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 35) + "px";
            else
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
            pMailListDiv = (pMailListHeightW / CurrentHeight) * 100;
            pMailPreVDiv = (pMailPreHeightW / CurrentHeight) * 100;
        }
        PreviewH_Move = false;
        PreviewW_Move = false;
    }
}

function MailPreviewResize(e) {
    if (PreviewH_Move) {
        curevent = (typeof event == 'undefined' ? e : event);
        var minSize = parseInt(200);
        var maxSize = parseInt(document.documentElement.clientWidth - 200);
        if (curevent.clientX < minSize || curevent.clientX > maxSize) {
            MailPreviewEnd(e);
        } else {
            var newPos_H = curevent.clientX;

            if (newPos_H < parseInt(CurrenWidth * 0.40)) {
                newPos_H = parseInt(CurrenWidth * 0.40);
                SmallSizeList = true;
            }
            else if (newPos_H > parseInt(CurrenWidth * 0.65)) {
                newPos_H = parseInt(CurrenWidth * 0.65);
            }

            if (newPos_H > parseInt(CurrenWidth * 0.40))
                SmallSizeList = false;

            document.getElementById("ResizeBarH").style.left = newPos_H + "px";
        }
    } else if (PreviewW_Move) {
        curevent = (typeof event == 'undefined' ? e : event);
        var minSize = parseInt(100);
        var maxSize = parseInt(document.documentElement.clientHeight - 100);

        if (curevent.clientY < minSize || curevent.clientY > maxSize) {
            MailPreviewEnd(e);
        } else {
            var newPos_W = curevent.clientY;
            
            if (newPos_W < (parseInt(CurrentHeight * 0.25) + 90)) {
                newPos_W = parseInt(CurrentHeight * 0.25) + 90;
            } else if (newPos_W > (parseInt(CurrentHeight * 0.65) + 90)) {
                newPos_W = (parseInt(CurrentHeight * 0.65) + 90);
            }
            
            document.getElementById("ResizeBarW").style.top = newPos_W + "px";
        }
    }
}

function CircularReadOpen() {
	var circularID = selobj.getAttribute("CIRCULARID");
	
	if (CrossYN()) {
        var feature = GetOpenPosition(820, 900);
    	window.open("/ezCircular/circularRead.do?circularID=" + circularID, "", "width=820, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	} else {
    	var feature = GetOpenPosition(790, 900);
    	window.open("/ezCircular/circularRead.do?circularID=" + circularID, "", "width=790, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	}
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}
function Window_resize() {
    try {
        if (!isPreviewChange) {
            if (parseInt(document.documentElement.clientWidth) < 1000) {
                document.getElementById("PreViewleft").style.display = "none";
                if (pPreviewShow_HOW.trim() == "H")
                    pPreviewShow_HOW = "W";
                PreviewMode_ChangeBtn();
            }
            else {
                document.getElementById("PreViewleft").style.display = "";
            }

            if (pPreviewShow_HOW.trim() == "W") {
                if (pMailListDiv == 0 || pMailPreVDiv == 0) {
                    pMailListDiv = 50; pMailPreVDiv = 50;
                }
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerW").style.display = "block";
                document.getElementById("PreviewRayerH").style.display = "none";

                CurrenWidth = document.documentElement.clientWidth - 10;
                CurrentHeight = document.documentElement.clientHeight - 110;
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10) + "px";
                pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
                pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
                document.getElementById("MailListRayer").style.width = "100%";
                document.getElementById("PreviewRayerW").style.width = "100%";
                document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
                if (navigator.userAgent.indexOf('Firefox') != -1) {
                    document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
                    document.getElementById("BoardList_BODY").style.height = (pMailListHeightW - 100) + "px";
                }
                else 
                    document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
                    document.getElementById("BoardList_BODY").style.height = (pMailListHeightW - 100) + "px";
                document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

                if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1)
                    document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 98) + "px";
                else
                    document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
                document.getElementById("PreW_subject").style.width = (CurrenWidth - 200) + "px";
                pPreviewShow_HOW = "W";
                pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
                pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);
            }
            else if (pPreviewShow_HOW.trim() == "H") {
                if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                    pMailListDiv_H = 50; pMailPreVDiv_H = 50;
                }
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerW").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "inline-block";
                
                if (parent.document.getElementById("tab1")) {
    				CurrenWidth = document.documentElement.clientWidth + 7;
    			} else {
    				CurrenWidth = document.documentElement.clientWidth - 20;
    			}
                CurrentHeight = document.documentElement.clientHeight - 110;
                pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
                pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

                if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                    var ChangeListWidthDiv = parseInt(CurrenWidth * 0.40) - pMailListWidthH;
                    pMailListWidthH = parseInt(CurrenWidth * 0.40);
                    pMailPreWidthH = pMailPreWidthH - ChangeListWidthDiv;
                }
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
                document.getElementById("MailListRayer").style.height = CurrentHeight + 200 + "px";
                document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
                if (navigator.userAgent.indexOf('Firefox') != -1) {
                    document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                    document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
                }
                else {
                    document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                    document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
                }

                //document.getElementById("divList").style.overflow = "auto";
                document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
                document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 5) + "px";
                document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
                document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 155) + "px";
                pPreviewShow_HOW = "H";
                pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
                pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
            }
            else if (pPreviewShow_HOW.trim() == "OFF") {
                document.getElementById("PreviewRayerW").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "none";
                CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = "100%";
                if (navigator.userAgent.indexOf('Firefox') != -1) {
                    document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                    document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
                }
                else {
                    document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                    document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
                }
                //document.getElementById("divList").style.overflow = "auto";
            }
        }
        scroll();
    } catch (e) { 
    }
}

function Window_resize2(){
	 // 2018-12-19 김민성 - 회람판 검색 스크롤 구현
        CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementsByClassName("content")[0].clientHeight - 28);
        document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
        document.getElementById("MailListRayer").style.width = "100%";
        if (navigator.userAgent.indexOf('Firefox') != -1) {
            document.getElementById("divList").style.height = (CurrentHeight - 87) + "px";
            document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
        }
        else {
            document.getElementById("divList").style.height = (CurrentHeight - 87) + "px";
            document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
        }
    scroll();
}

var lCount;
function ListCount(pCount) {
	lCount = pCount;
    selobj = null;
    MailOptionHidden();
    Set_BoardConfig();
    CurPage = 1;
}

function Set_BoardConfig()
{
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezCircular/setCircularConfig.do",
		data : { pUserID   : SSUserID, 
				 pListCount: lCount, 
				 pPreView  : pPreviewShow_HOW 
				},
		success: function(result){
			getBoardList();
		}     			
	});
}

//레프트 메뉴카운트 업뎃용
function leftCountRf() {
	var pDiv, pId, pValue;
	
	if (window.parent.frames["left"] != undefined) {
	    var h2 = window.parent.frames["left"].document.getElementsByTagName("h2");
	
	    for (var i = 0; i < h2.length; i++) {
	        if (h2[i].className == "on") {
	            pId = h2[i].getElementsByTagName("div")[0].id;
	            pId = pId.replace("TreeCtr", "TreeCtrl");
	            pValue = h2[i].getElementsByTagName("div")[0].getAttribute("value");
	            window.parent.frames["left"].TopBoard_onclick(pId, pValue);
	            break;
	        }
	    }
	}
}

//무적의 자바 인코더
function javaURLEncode(str) {
	  return encodeURIComponent(str)
	    .replace(/\+/g, "%2b")
	    .replace(/\;/g, "%3b")
	    .replace(/!/g, "%21")
	    .replace(/'/g, "%27")
	    .replace(/\(/g, "%28")
	    .replace(/\)/g, "%29")
	    .replace(/~/g, "%7E");
}

function MemberInfo_onclick(pUserID, pDeptID) {
	var feature = "width=420px, height=450px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 450);
    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
}

function scroll() {
	var BoardList_BODYHeight = document.getElementById("BoardList_BODY").clientHeight;
	var BoardListDivHeight = document.getElementById("BoardListDiv").clientHeight;
	
	 if (BoardList_BODYHeight > BoardListDivHeight) {
		if ($("#BoardList_THEAD tr th#forScroll").length > 0) {
			$("#BoardList_THEAD tr th#forScroll").remove();
		}
	} else {
		if ($("#BoardList_THEAD tr th#forScroll").length < 1) {
			
			$("#BoardList_THEAD tr").append("<th></th>");
			
				var lastTh = $("#BoardList_THEAD tr th").last();
				lastTh.attr("id", "forScroll");
				lastTh.css("width", "10px");
		}
	}
}

// 2019-03-07 김민성 - 회람 이동/삭제 후 미리보기 이벤트 수정
function prevShow_Clear() {
    if (pPreviewShow_HOW == "W") {
    	var sentDateStr = document.body.querySelector("#PreContent_RayerW #sentDateStr");
        document.getElementById("Preview_HeaderW").style.display = "none";
        document.getElementById("ifrmPreViewW").src = strLang29;
        
        if (sentDateStr != null) {
        	sentDateStr.style.display = "none";
        }
        
        var innerFrame  = document.getElementById("ifrmPreView" + pPreviewShow_HOW);
        innerFrame.onload = function () {
        	var innerDoc = innerFrame.contentDocument || innerFrame.contentWindow.document;
        	if (innerDoc.getElementById("ifrmviewEmptyText").innerText == "") {
        		innerDoc.getElementById("ifrmviewEmptyText").innerText = strLang28;
        	}
        }
    }
    else if(pPreviewShow_HOW == "H"){
    	var sentDateStr = document.body.querySelector("#PreContent_RayerH #sentDateStr");
        document.getElementById("Preview_HeaderH").style.display = "none";
        document.getElementById("ifrmPreViewH").src = strLang29;
        
        if (sentDateStr != null) {
        	sentDateStr.style.display = "none";
        }
        
        var innerFrame  = document.getElementById("ifrmPreView" + pPreviewShow_HOW);
        innerFrame.onload = function () {
        	var innerDoc = innerFrame.contentDocument || innerFrame.contentWindow.document;
        	if (innerDoc.getElementById("ifrmviewEmptyText").innerText == "") {
        		innerDoc.getElementById("ifrmviewEmptyText").innerText = strLang28;
        	}
        }
    }
}
