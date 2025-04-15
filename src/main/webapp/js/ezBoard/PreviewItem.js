﻿function MailOptionView(obj, flag) {
    if (obj.getAttribute("mode") == "off") {
        if (flag=='N') {
        	document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 160 + "px";
        } else {
        	document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
        }
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
function MailOptionHidden() {
    document.getElementById("layer_Viewpopup").style.display = "none";
    document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
    //document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
    document.getElementById("maillistoptiondiv").setAttribute("class", "icon16 btn_arrow_down");
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
function PreviewRayerChange(pGubun) {
    pGubun = pGubun.trim();
    if (selobj != null && pGubun != "NONE" && selobj.childNodes.length != 0)
        ItemPreviewRead(selobj);

    if (pGubun == "OFF") {
    	pGubun = "NONE";
    }
    
    if (clickPreviweType == "PHOTO" || clickPreviweType == "MOVIE") {
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
                document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
            } else {
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px"; 
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
            } else {
                document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
                document.getElementById("BoardList_BODY").style.height = (pMailListHeightW - 100) + "px";
            }
            document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

            /* 2018-09-17 홍승비 - 즐겨찾기 탭에서 하단 미리보기 사용 시 스크롤 잘리지 않도록 수정 */
            if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1) {
            	document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 114) + "px";
            } else {
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
            }
            
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
            
            if ($("body").attr("class") == "tabbody") {            
            	document.getElementById("MailListRayer").style.width = pMailListWidthH-20 + "px";
            } else {
            	document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
            }            
            
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
            	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
            } else
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
            	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
            /*document.getElementById("divList").style.overflow = "auto";*/
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 68) + "px";
            document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 200) + "px";
            
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

        if (firstFlag) {
            Set_BoardConfig();
        }
        
        isPreviewChange = false;
        scroll();
    } catch (e) {
    	console.log(e);
    }
}
var SetConfig = true;
function PreviewRayerChange_photo(pGubun) {

	try {
        pGubun = pGubun.trim();
        SetConfig = true;
        if (pGubun == "W") {
            SetConfig = false;
            pGubun = "H";
        }
        //이유를 몰라서 빼놓음
//        if (pGubun == "NONE")
//            SetConfig = false;

        if (document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "default";

        isPreviewChange = true;
        if (pGubun == "NONE") {
            pPreviewShow_HOW = "OFF";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "none";
            CurrentHeight = document.documentElement.clientHeight - 110;
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = "100%";
            /* 2018-04-25 홍승비 - 크로스 브라우징 중복 코드 삭제 */
            document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
            /* 2019-04-11 홍승비 - 앨범형식 보기 시 사용하지 않는 div 분기처리 */
            // if (document.getElementById("BoardList_BODY") != null) {
            // 	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
            // }
            g_bPrevShow = false;
        }
        else if (pGubun == "H") {
            if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                pMailListDiv_H = 50; pMailPreVDiv_H = 50;
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
                } else {
                    pMailPreWidthH = pMailPreWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
            }
            document.getElementById("PreviewRayerH").style.width = "752px";
            if ($("body").attr("class") == "tabbody") {
            	document.getElementById("MailListRayer").style.width = (CurrenWidth - 780) + "px";
            } else{
            	document.getElementById("MailListRayer").style.width = (CurrenWidth - 760) + "px";
            }
            document.getElementById("PreContent_RayerH").style.width = "749px";

            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            /* 2018-04-25 홍승비 - 크로스 브라우징 중복 코드 삭제 */
			document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
			
//			if (document.getElementById("BoardList_BODY") != null) {
//			    document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 100) + "px";
//			}
			
			if (document.getElementById("ifrmPreViewH")) {
				document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 68) + "px";
			}
			/* 2019-04-11 홍승비 - 앨범형식 보기 시 사용하지 않는 div 분기처리 */
			// if (document.getElementById("BoardList_BODY") != null) {
			// 	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
			// }

            /*document.getElementById("divList").style.overflow = "auto";*/
            document.getElementById("ifrmPreViewH_photo").style.height = (CurrentHeight - 77) + "px";
            pPreviewShow_HOW = "H";
            pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
            pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);

            if (onclickFlag) {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
            }

            g_bPrevShow = true;
        }
        isPreviewChange = false;
        MailOptionHidden();
        PreviewMode_ChangeBtn();
        
        /* 2019-01-03 홍승비 - 포토/썸네일게시판에서 미리보기 유형 설정 시 저장되도록 주석 제거 */
        if (SetConfig) {
        	Set_BoardConfig();
        }
        scroll();
    } catch (e) {
    	console.log(e);
    }
}

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

/* 2021-01-19 홍승비 - 미리보기 영역이 열려있지 않다면, 원클릭으로 게시물 읽기팝업창을 호출 */
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
	var noticeObj = ["0", "5", "M"].includes(pBoardType) && obj.getAttribute("DATA9") == "1";
    
	if (!noticeObj) {
        for (var i = 0; i < obj.childNodes.length; i++) {
            if (obj.childNodes[i].style.fontWeight == "bold") {
                obj.childNodes[i].style.fontWeight = "normal";
            } else {
                obj.childNodes[i].style.fontWeight = "normal";
            }
        }
    }

    var pboardid = obj.getAttribute("DATA1");
    var pitemid = obj.getAttribute("DATA2");

    if (document.getElementById('spn_title' + obj.id.split('_')[2]) != null) { // 다른 게시판에선 이 조건문을 타지않는걸로 보임
        document.getElementById('spn_title' + obj.id.split('_')[2]).style.fontWeight = "normal";
        //document.getElementById('spn_content' + obj.id.split('_')[2]).style.fontWeight = "normal"; // 게시판 > 썸네일게시판  > PreViewH사용시 스크립트오류 발생시킨부분 주석
    }
    if (document.getElementById('spn_content' + obj.id.split('_')[2]) != null) {
    	document.getElementById('spn_content' + obj.id.split('_')[2]).style.fontWeight = "normal";
    }
    if (previewType == "PHOTO" || previewType == "MOVIE" || (obj.getAttribute("DATA10") == "3" || obj.getAttribute("DATA10") == "4" || obj.getAttribute("DATA10") == "7")) {
        clickPreviweType = "PHOTO";
        if (document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "default";

        xmlhttp = createXMLHttpRequest();
        if (location.href.toLowerCase().indexOf('temp') > -1)
            xmlhttp.open("POST", "/ezBoard/getPreviewItem.do?boardID=" + encodeURIComponent(pboardid) + "&itemID=" + encodeURIComponent(pitemid) + "&mode=" + pMode + "&location=TEMP", true);
        else
            xmlhttp.open("POST", "/ezBoard/getPreviewItem.do?boardID=" + encodeURIComponent(pboardid) + "&itemID=" + encodeURIComponent(pitemid) + "&mode=" + pMode + "&location=GENERAL", true);
        xmlhttp.onreadystatechange = event_ItemPreviewRead_photo;
        xmlhttp.send();
    }
    else {
        clickPreviweType = "TEXT";
        if (document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "w-resize";
        xmlhttp = createXMLHttpRequest();
        if (location.href.toLowerCase().indexOf('temp') > -1)
            xmlhttp.open("POST", "/ezBoard/getPreviewItem.do?boardID=" + encodeURIComponent(pboardid) + "&itemID=" + encodeURIComponent(pitemid) + "&mode=" + pMode + "&location=TEMP", true);
        else
            xmlhttp.open("POST", "/ezBoard/getPreviewItem.do?boardID=" + encodeURIComponent(pboardid) + "&itemID=" + encodeURIComponent(pitemid) + "&mode=" + pMode + "&location=GENERAL", true);
        xmlhttp.onreadystatechange = event_ItemPreviewRead;
        xmlhttp.send();
        xmlhttp2 = createXMLHttpRequest();
        xmlhttp2.open("POST", "/ezBoard/getItemAttachments.do?itemID=" + encodeURIComponent(pitemid), true);
        xmlhttp2.onreadystatechange = event_ItemPreviewRead;
        xmlhttp2.send();
    }

    if (obj.getAttribute("gubun") == "2" && BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && obj.getAttribute("publicflag") == "N") {
        document.getElementById('openPassword').setAttribute('data-id', obj.getAttribute("DATA2"));
        document.getElementById('openPassword').setAttribute('data-board', obj.getAttribute("DATA1"));
        $('#openPassword').val('');
        $('#chkPass').modal();
    }
}
var ItemID;
var WriterID;
var WriterName;
var WriterDeptName;
var WriterCompanyName;
var ContentLocation;
var UserIMG;
var OneLineReplyFlag;
var Gubun;
var BoardID;

function event_ItemPreviewRead_photo() {
    if (xmlhttp != null && xmlhttp.readyState == 4) {
        if (xmlhttp.status >= 200 && xmlhttp.status < 300) {
            var xmldom = loadXMLString(xmlhttp.responseText)
            if (document.getElementById("PreViewBottom") != null)
                document.getElementById("PreViewBottom").style.display = "none";
            
            if (SelectSingleNodeValueNew(xmldom, "DATA") == "NO") {
            	alert(strLang173);
                document.getElementById("userImgH").src = "/images/kr/main/bestEmployee_pic_none.png";
                document.getElementById("userImgW").src = "/images/kr/main/bestEmployee_pic_none.png";
            } 
            
            var WriterID = SelectSingleNodeValueNew(xmldom, "NODES/NODE/WriterID");
            var WriterName = SelectSingleNodeValueNew(xmldom, "NODES/NODE/WriterName");
            var WriterDeptID = SelectSingleNodeValueNew(xmldom, "NODES/NODE/WriterDeptID");
            var WriterDeptName = SelectSingleNodeValueNew(xmldom, "NODES/NODE/WriterDeptName");
            var WriterCompanyName = SelectSingleNodeValueNew(xmldom, "NODES/NODE/WriterCompanyName");
            var WriteDate = SelectSingleNodeValueNew(xmldom, "NODES/NODE/WriteDate");
            var Title = SelectSingleNodeValueNew(xmldom, "NODES/NODE/Title");
            var ContentLocation = SelectSingleNodeValueNew(xmldom, "NODES/NODE/ContentLocation");
            var GuBun = SelectSingleNodeValueNew(xmldom, "NODES/NODE/GUBUN");
            var UserIMG =  SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/UserIMG");
            var LikeCount = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/LikeCount");
            var DisLikeCount = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/DisLikeCount");

            if (pPreviewShow_HOW.trim() == "W") {
                PreviewRayerChange_photo("W");
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
            }
            else if (pPreviewShow_HOW.trim() == "H") {
                PreviewRayerChange_photo("H");
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
            }
            else {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "none";
            }
            
            if (document.getElementById("userImgH") != null && UserIMG != "") {
            	document.getElementById("userImgH").src = UserIMG;
            }
            if (document.getElementById("userImgW") != null && UserIMG != "") {
            	document.getElementById("userImgW").src = UserIMG;
            }
            
            var pOCS = "";
            if (USE_OCS == "YES") {
                if ((BroswerAndNonActiveXCheck() == "IE")) {
                    var pSIPUri = getSIPUri(GetAttribute(selobj, "DATA3"));
                    pOCS = "<img src='/images/presence/unknown.gif' id='" + GetGUID() + "' onload=\"PresenceControl('" + pSIPUri + "',this);\" style='vertical-align:middle;padding-right:5px;'/>";
                }
            }
            /* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
            pOCS += "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + WriterName
            			+ "' onclick='MemberInfo_onclick(\"" + GetAttribute(selobj, "DATA3").trim() + "\", \"" + WriterDeptID + "\")'>" + WriterName + "</span>";

            if (document.getElementById('ifrmPreViewH') != null) {
                document.getElementById('ifrmPreViewH_photo').style.display = "";
                document.getElementById('ifrmPreViewW_photo').style.display = "";
                document.getElementById('ifrmPreViewH').style.display = "none";
                document.getElementById('ifrmPreViewW').style.display = "none";
            }

            if (SelectSingleNodeValueNew(xmldom, "DATA") == "NOVIEW") {
                alert(strLang55);
                return;
            }

            setNodeText(document.getElementById("PreH_sub_subject"), Title);
            document.getElementById("PreH_MailReceiver").innerHTML = pOCS;
            setNodeText(document.getElementById("PreH_date"), WriteDate.substring(0, 16));
            var fullPath = "/ezBoard/boardAttachDown.do?filepath=" + javaURLEncode(ContentLocation);
            
            /* 20118-11-07 홍승비 - 동영상게시물 미리보기 분기 추가 */
            if (GuBun == "7") {
            	 if (location.href.toLowerCase().indexOf('temp') > -1)
 	                document.getElementById('ifrmPreViewH_photo').src = "/ezBoard/boardItemPreViewMovieContent.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")) + "&mode=" + pMode + "&location=TEMP";
 	            else
 	                document.getElementById('ifrmPreViewH_photo').src = "/ezBoard/boardItemPreViewMovieContent.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")) + "&mode=" + pMode + "&likeCount=" + LikeCount + "&disLikeCount=" + DisLikeCount + "&location=GENERAL";
            } else {
	            if (location.href.toLowerCase().indexOf('temp') > -1)
	                document.getElementById('ifrmPreViewH_photo').src = "/ezBoard/boardItemPreViewPhotoContent.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")) + "&mode=" + pMode + "&location=TEMP";
	            else
	                document.getElementById('ifrmPreViewH_photo').src = "/ezBoard/boardItemPreViewPhotoContent.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")) + "&mode=" + pMode + "&likeCount=" + LikeCount + "&disLikeCount=" + DisLikeCount + "&location=GENERAL";
            }
        }
    }
}
var Title;
var pOCS;
var WriteDate;
var interValue;
function event_ItemPreviewRead() {
    if ((xmlhttp != null && xmlhttp.readyState == 4) && (xmlhttp2 != null && xmlhttp2.readyState == 4)) {
        if ((xmlhttp.status >= 200 && xmlhttp.status < 300) && (xmlhttp2.status >= 200 && xmlhttp2.status < 300)) {
            if (document.getElementById("PreViewBottom") != null){
            	document.getElementById("PreViewBottom").style.display = "";
            }
     
            if (SelectSingleNodeValue(xmlhttp.responseXML, "DATA") == "NO") {
                if (!g_bPrevShow) { //미리보기 아닐 때만 alert
            	    alert(strLang173);
                }    
            	document.querySelector('#PreH_sub_subject').textContent = "";
            	document.querySelector('#PreH_MailReceiver').textContent = "";
            	document.querySelector('#PreH_date').textContent = "";
            	document.getElementById("userImgH").src = "/images/kr/main/bestEmployee_pic_none.png";
            	document.querySelector('#PreW_sub_subject').textContent = "";
            	document.querySelector('#PreW_MailReceiver').textContent = "";
            	document.querySelector('#PreW_date').textContent = "";
            	document.getElementById("userImgW").src = "/images/kr/main/bestEmployee_pic_none.png";
            }
            
            ItemID = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/ItemID");
            WriterID = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterID");
            WriterName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterName");
            WriterDeptID = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterDeptID");
            WriterDeptName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterDeptName");
            WriterCompanyName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterCompanyName");
            WriteDate = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriteDate");
            Title = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/Title");
            ContentLocation = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/ContentLocation");
            UserIMG =  SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/UserIMG");
            BoardID = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/BoardID");
            LikeCount = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/LikeCount");
            DisLikeCount = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/DisLikeCount");
            /* 2019-11-06 홍승비 - 게시물 미리보기 시 댓글옵션 표출용 변수 추가 */
            OneLineReplyFlag = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/ONELINEREPLY");
            if (!!document.getElementById('ifrmPreViewH_photo') && document.getElementById('ifrmPreViewH_photo').style.display != "none") {
            	document.getElementById('ifrmPreViewH_photo').style.display = "none";
            }
            
            if (!!document.getElementById('ifrmPreViewW_photo') && document.getElementById('ifrmPreViewW_photo').style.display != "none") {
            	document.getElementById('ifrmPreViewW_photo').style.display = "none";
            }
            
            if (document.getElementById('ifrmPreViewH').style.display != "none") {
            	document.getElementById('ifrmPreViewH').style.display = "none";
            }
            
            if (document.getElementById('ifrmPreViewW').style.display != "none") {
            	document.getElementById('ifrmPreViewW').style.display = "none";
            }
            
            if (pPreviewShow_HOW.trim() == "W") {
                document.getElementById("Preview_HeaderW").style.display = "";
                document.getElementById("Preview_HeaderH").style.display = "none";
                if(typeof tempLocation !== "undefined" && tempLocation == "Y"){
                    document.getElementById("ifrmPreViewW").src = "/ezBoard/boardItemPreviewContent.do?itemID=" + encodeURIComponent(ItemID) + "&boardID=" + encodeURIComponent(BoardID) + "&likeCount=" + LikeCount + "&disLikeCount=" + DisLikeCount + "&OneLineReplyFlag=" + OneLineReplyFlag + "&tempLocation=" + tempLocation;
                }else{
                    document.getElementById("ifrmPreViewW").src = "/ezBoard/boardItemPreviewContent.do?itemID=" + encodeURIComponent(ItemID) + "&boardID=" + encodeURIComponent(BoardID) + "&likeCount=" + LikeCount + "&disLikeCount=" + DisLikeCount + "&OneLineReplyFlag=" + OneLineReplyFlag;
                }
                document.getElementById('ifrmPreViewW').style.display = "";
            }
            else if (pPreviewShow_HOW.trim() == "H") {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
                if(typeof tempLocation !== "undefined" && tempLocation == "Y"){
                    document.getElementById("ifrmPreViewH").src = "/ezBoard/boardItemPreviewContent.do?itemID=" + encodeURIComponent(ItemID) + "&boardID=" + encodeURIComponent(BoardID) + "&likeCount=" + LikeCount + "&disLikeCount=" + DisLikeCount + "&OneLineReplyFlag=" + OneLineReplyFlag + "&tempLocation=" + tempLocation;
                }else {
                    document.getElementById("ifrmPreViewH").src = "/ezBoard/boardItemPreviewContent.do?itemID=" + encodeURIComponent(ItemID) + "&boardID=" + encodeURIComponent(BoardID) + "&likeCount=" + LikeCount + "&disLikeCount=" + DisLikeCount + "&OneLineReplyFlag=" + OneLineReplyFlag;
                }
                document.getElementById('ifrmPreViewH').style.display = "";
            }
            else {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "none";
            }
            
            if (document.getElementById("userImgH") != null && UserIMG != "") {
                document.getElementById("userImgH").src = UserIMG;
            }
            if (document.getElementById("userImgW") != null && UserIMG != "") {
                document.getElementById("userImgW").src = UserIMG;
            }
        }
    }
}

function previewItemSet() {
	pOCS = "";
    pOCS += "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + WriterName
    			+ "' onclick='MemberInfo_onclick(\"" + selobj.getAttribute("DATA3")  + "\", \"" + WriterDeptID + "\")'>" + WriterName + "</span>";

    if (document.getElementById('ifrmPreViewH_photo') != null) {
        document.getElementById('ifrmPreViewH_photo').style.display = "none";
        document.getElementById('ifrmPreViewW_photo').style.display = "none";
        document.getElementById('ifrmPreViewH').style.display = "";
        document.getElementById('ifrmPreViewW').style.display = "";
    }
    if (CrossYN()) {
    	var boardType = "";
    	
    	if(pMode == "temp"){
    		boardType = "BOARDCONTENTTEMP";
    	}else{
    		boardType = "BOARDCONTENT";
    	}
    	
    	$.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : "/ezCommon/mhtToHTMLContent.do",
			data : { type   	 : boardType, 
					 itemID 	 : ItemID,
					 href        : ContentLocation
				   },
			success: function(result){
				event_downContent(result, xmlhttp2.responseText);
			}        			
		});	
    } else {
        document.getElementById("Pre" + pPreviewShow_HOW + "_sub_subject").innerText = Title;
        document.getElementById("Pre" + pPreviewShow_HOW + "_MailReceiver").innerHTML = pOCS;
        document.getElementById("Pre" + pPreviewShow_HOW + "_date").innerText = WriteDate.substring(0, 16);
        var readHTML = WriteContent(ContentLocation, ItemID);
        var tempText = xmlhttp2.responseText;

        if (xmlhttp2.readyState == 4) {
            setTimeout(function () {
                if (pPreviewShow_HOW.trim() == "W") {
                    if (document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent != undefined)
                        document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent(readHTML, tempText);
                }
                else if (pPreviewShow_HOW.trim() == "H") {
                    if (document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent != undefined)
                        document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent(readHTML, tempText);
                }
            }, 100);
        }
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
        document.getElementById("Pre" + pPreviewShow_HOW.trim() + "_date").textContent = WriteDate.substring(0, 16);
        document.getElementById("ifrmPreView" + pPreviewShow_HOW.trim()).contentWindow.makeWriteContent(result, result2);
}

function PreviewH_onMouserDown(e) {
    if (clickPreviweType == "PHOTO" || clickPreviweType == "MOVIE") {
        return;
    }

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
    if (clickPreviweType == "PHOTO" ||  clickPreviweType == "MOVIE") {
        return;
    }

    curevent = (typeof event == 'undefined' ? e : event);

    var newPos_W = curevent.clientY;
    var offsetW = 0;
    
    /* 2018-11-29 홍승비 - 즐겨찾기 탭 > 하단 미리보기 리사이즈바 어긋나는 부분 수정  */
    if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1 || window.parent.location.href.indexOf("/admin/ezBoard/boardConfig.do") > -1) {
    	offsetW = 72;
    } else {
    	offsetW = 90;
    }

    if (newPos_W < (parseInt(CurrentHeight * 0.25) + offsetW)) {
        newPos_W = parseInt(CurrentHeight * 0.25) + offsetW;
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
    if (clickPreviweType == "PHOTO" ||  clickPreviweType == "MOVIE")
        return;

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
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
            document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 200) + "px";
            pMailListDiv_H = (pMailListWidthH / CurrenWidth) * 100;
            pMailPreVDiv_H = (pMailPreWidthH / CurrenWidth) * 100;

        }
        else if (PreviewW_Move) {
        	var offset = 0;
        	
        	/* 2018-11-29 홍승비 - 즐겨찾기 탭 > 하단 미리보기 리사이즈바 어긋나는 부분 수정  */
        	if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1 || window.parent.location.href.indexOf("/admin/ezBoard/boardConfig.do") > -1) {
        		offsetW = 72;
        	} else {
        		offsetW = 90;
        	}
        	var newPos_W = parseInt(document.getElementById("ResizeBarW").style.top) - offsetW;
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

            /* 2018-09-18 홍승비 - 하단 미리보기 리사이즈 시 상단 게시물리스트 영역 height 수정 */
            document.getElementById("BoardList_BODY").style.height = (pMailListHeightW - 100) + "px";
            
            /* 2018-09-17 홍승비 - 즐겨찾기 탭에서 하단 미리보기 사용 시 스크롤 잘리지 않도록 수정 */
            if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1) {
				document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 114) + "px";
            } else {
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
            }
            pMailListDiv = (pMailListHeightW / CurrentHeight) * 100;
            pMailPreVDiv = (pMailPreHeightW / CurrentHeight) * 100;
        }
        PreviewH_Move = false;
        PreviewW_Move = false;
    }
}
function MailPreviewResize(e) {
    if (clickPreviweType == "PHOTO" ||  clickPreviweType == "MOVIE")
        return;

    if (PreviewH_Move) {
        curevent = (typeof event == 'undefined' ? e : event);
        var minSize = parseInt(200);
        var maxSize = parseInt(document.documentElement.clientWidth - 200);
        if (curevent.clientX < minSize || curevent.clientX > maxSize) {
            MailPreviewEnd(e);
        }
        else {
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
    }
    else if (PreviewW_Move) {
        curevent = (typeof event == 'undefined' ? e : event);
        var minSize = parseInt(100);
        var maxSize = parseInt(document.documentElement.clientHeight - 100);

        if (curevent.clientY < minSize || curevent.clientY > maxSize) {
            MailPreviewEnd(e);
        }
        else {
            var newPos_W = curevent.clientY;
        	var offset = 0;
        	
        	/* 2018-11-29 홍승비 - 즐겨찾기 탭 > 하단 미리보기 리사이즈바 어긋나는 부분 수정  */
        	if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1 || window.parent.location.href.indexOf("/admin/ezBoard/boardConfig.do") > -1) {
        		offsetW = 72;
        	} else {
        		offsetW = 90;
        	}
        	
            if (newPos_W < (parseInt(CurrentHeight * 0.25) + offsetW)) {
                newPos_W = parseInt(CurrentHeight * 0.25) + offsetW;
            }
            else if (newPos_W > (parseInt(CurrentHeight * 0.65) + 90)) {
            	newPos_W = (parseInt(CurrentHeight * 0.65) + 90);
            }
            document.getElementById("ResizeBarW").style.top = newPos_W + "px";
        }
    }
}
function MailReadOpen() {
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - 720) / 2;
    var pLeft = (pwidth - 765) / 2;
    

    if (previewType == "PHOTO" || (selobj.getAttribute("DATA10") == "3" || selobj.getAttribute("DATA10") == "4")) {
		if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
				var height = 789;
		} else {
				var height = 785;
		}
		
		pTop = (pheight - 789) / 2;
		pLeft = (pwidth - 790) / 2;
		window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height +",width=790,top=" + pTop + ",left=" + pLeft, "");
    } else if (previewType == "MOVIE" || selobj.getAttribute("DATA10") == "7" ) {
    	 pTop = (pheight - 679) / 2;
         window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=679,width=765,top=" + pTop + ",left=" + pLeft, "");
    } else {
        window.open("/ezBoard/boardItemView.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
    }
}
function WriteContent(strContentLocation, ItemID) {
    objMHT = new ActiveXObject("MhtFormat.Convert");
    var ContentHTML = MhtConvert(strContentLocation, ItemID);
    ContentHTML = ReplaceText(ContentHTML, "onmouseover", "");
    ContentHTML = ReplaceText(ContentHTML, "onfocus", "");
    ContentHTML = ReplaceText(ContentHTML, "contentEditable=true", "");
    ContentHTML = ReplaceText(ContentHTML, "contentEditable=\"true\"", "");
    return ContentHTML;
}
function MhtConvert(strContentLocation, ItemID) {
    var fullPath;
    if (pMode == "temp")
        fullPath = "/ezBoard/getContentInfo.do?type=BOARDCONTENTTEMP&docID=" + encodeURI(ItemID);
    else
        fullPath = "/ezBoard/getContentInfo.do?type=BOARDCONTENT&docID=" + encodeURI(ItemID);
    objMHT.sync = true;
    var strMht = objMHT.DownloadURL(fullPath);
    objMHT.mhtData = strMht;
    objMHT.filterIn();
    var ret = objMHT.htmlData;
    if (window.location.protocol.toLowerCase() == "https:") {
        var idx = 0; var start = 0;
        while (ret.indexOf("src=\"", start) > 0) {
            start = ret.indexOf("src=\"", start);
            var end = ret.indexOf("\"", start + 5);
            var link = ImageUrl(strContentLocation, idx);
            ret = ret.substring(0, start + 5) + link + ret.substring(end);

            idx = idx + 1;
            start = end;
        }
    }
    return ret;
}
function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}
function Window_resize() {
    if (clickPreviweType == "PHOTO" || clickPreviweType == "MOVIE") {
        Window_resize_photo();
        return;
    }

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
                } else
                    document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
                	document.getElementById("BoardList_BODY").style.height = (pMailListHeightW - 100) + "px";
                document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

                /* 2018-09-17 홍승비 - 즐겨찾기 탭에서 하단 미리보기 사용 시 스크롤 잘리지 않도록 수정 */
                if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1) {
                    document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 114) + "px";
                } else {
                    document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
                }
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
                	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
                } else
                    document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";

                /*document.getElementById("divList").style.overflow = "auto";*/
                document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
                document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
                document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
                document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 200) + "px";
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
                	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
                } else
                    document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
                	/*document.getElementById("divList").style.overflow = "auto";*/
            }
        }
        scroll();
    } catch (e) { }
}
function Window_resize_photo() {
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

            if (document.documentElement.clientWidth < 1300) {
                PreviewRayerChange("NONE");
                document.getElementById("right").style.display = "none";
            }
            else {
                document.getElementById("right").style.display = "";
            }
            
            if (pPreviewShow_HOW.trim() == "H") {
            	if (document.documentElement.clientWidth < 1300) {
                    PreviewRayerChange("NONE");
                    document.getElementById("right").style.display = "none";
                }
                else {
                    document.getElementById("right").style.display = "";
                    PreviewRayerChange("H");
                }
                
                if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                    pMailListDiv_H = 50; pMailPreVDiv_H = 50;
                }
                
                /* 2019-01-03 홍승비 - 포토/썸네일게시판 리사이즈 시 미리보기 영역 수정 */
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
                    } else {
                        pMailPreWidthH = pMailPreWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                    }
                }
                
                document.getElementById("PreviewRayerH").style.width = "752px";
            	if ($("body").attr("class") == "tabbody") {
                	document.getElementById("MailListRayer").style.width = (CurrenWidth - 780) + "px";
                } else {
                	document.getElementById("MailListRayer").style.width = (CurrenWidth - 760) + "px";
                }
                document.getElementById("PreContent_RayerH").style.width = "749px";
                
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
                document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
                
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                
                /* 2022-03-17 홍승비 - 리사이즈 시 포토게시판에만 스크롤이 발생하도록 분기처리 (썸네일, 동영상게시판은 다른 방식으로 스크롤이 발생함) */
                if (window.location.href.indexOf("/ezBoard/boardItemListPhoto.do") > -1) {
                	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
                }
                document.getElementById("ifrmPreViewH_photo").style.height = (CurrentHeight - 77) + "px";
                
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
                document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
                
                if (window.location.href.indexOf("/ezBoard/boardItemListPhoto.do") > -1) {
                	document.getElementById("BoardList_BODY").style.height = (CurrentHeight - 103) + "px";
                }
            }
        }
        scroll();
    } catch (e) { }
    /*try {
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
            if (document.documentElement.clientWidth < 1300) {
                PreviewRayerChange("NONE");
                document.getElementById("right").style.display = "none";
            }
            else {
                document.getElementById("right").style.display = "";
            }


            if (pPreviewShow_HOW.trim() == "H") {
                if (document.documentElement.clientWidth < 1300) {
                    PreviewRayerChange("NONE");
                    document.getElementById("right").style.display = "none";
                }
                else {
                    document.getElementById("right").style.display = "";
                    PreviewRayerChange("H");
                }
            }
        }
        
        MailOptionHidden();
    } catch (e) { }*/
}
var lCount;
function ListCount(pCount) {
    lCount = pCount;
    selobj = null;
//    MailOptionHidden();
    Set_BoardConfig();
    CurPage = 1;
    getBoardList();
    
}

function Set_BoardConfig() {
     $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezBoard/setBoardConfig.do",
		data : { pUserID   : SSUserID, 
				 pListCount: lCount, 
				 pPreView  : pPreviewShow_HOW 
				},
		success: function(result){
		}     			
	});
}

/* 2019-07-08 홍승비 - 게시물 등록, 삭제, 복사, 이동시 좌측메뉴의 선택된 하위게시판 확장 닫히지 않도록 수정 */
//레프트 메뉴카운트 업뎃용
function leftCountRf(pDestBoardIDs) {
	// 기존 코드 주석처리
/*	var pDiv, pId, pValue, pNodeID, pTreeID;

	if (window.parent.frames["left"] != undefined) {
	    var h2 = window.parent.frames["left"].document.getElementsByTagName("h2");
	    var span = window.parent.frames["left"].document.getElementsByTagName("span");
	    
	    
	    // 2018-02-23 천성준 
	     게시판  게시물 등록, 삭제, 복사, 이동시 왼쪽 게시판 폴더 볼드 해제되는 버그 수정 
	    for (var j = 0; j < span.length; j++) {
	    	if (span[j].className == "node_selected") {
	    		pNodeID = span[j].id.replace("spn_","");
	    		pTreeID = pNodeID.split("_")[0];
	    	}
	    }
	    
	    // 2018-12-31 홍승비 - 게시판명의 변경된 태그(div -> span)로 id 찾기 + 게시판 클릭 동작 변경
	    for (var i = 0; i < h2.length; i++) {
	        if (h2[i].className == "on") {
	            pId = h2[i].getElementsByClassName("h2Title")[0].id;
	            pId = pId.replace("TreeCtr", "TreeCtrl");
	            pValue = h2[i].getElementsByClassName("h2Title")[0].getAttribute("value");
	            window.parent.frames["left"].treeViewRefresh(pId, pValue);
	            window.parent.frames["left"].node_select(pNodeID, "", pTreeID, "");
	            break;
	        }
	    }
	}*/
	var pNodeID = "";
	var leftFrame;
	
	// 즐겨찾기탭, 관리자단탭에서 좌측메뉴 접근
	if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1) {
		leftFrame = window.parent.parent.frames["left"];
    } else if (window.parent.location.href.indexOf("/admin/ezBoard") > -1) {
    	leftFrame = window.parent.parent.frames["board_menu"];
    } else {
    	leftFrame = window.parent.frames["left"];
    }
	
	if (leftFrame != undefined) {
	    var h2 = leftFrame.document.getElementsByTagName("h2");
	    var span = leftFrame.document.getElementsByTagName("span");
	    
	    // 현재 선택된 하위게시판명 div의 id 저장
	    for (var j = 0; j < span.length; j++) {
	    	if (span[j].className == "node_selected") {
	    		pNodeID = span[j].id.replace("spn_","");
	    	}
	    }
	    
	    if (pNodeID != "") {
	    	leftFrame.refreshItemCnt(pNodeID);
	    }
	    
	    // 게시판을 선택하여 등록, 복사, 이동 시의 목표게시판 게시물 카운트 갱신 (해당 게시판트리가 확장된 경우에만 게시물 개수 갱신 확인 가능)
	    if (pDestBoardIDs != null && pDestBoardIDs != "") {
	    	var destBoardIDs = pDestBoardIDs.split(";"); // 갱신 대상 게시판이 여러개인 경우 ';' 기호로 잘라서 루프
	    	var destBoardLength = destBoardIDs.length;
	    	var tempDestBoardDiv = leftFrame.document.getElementsByClassName("node_div");
	    	var tempLength = tempDestBoardDiv.length;
	    	
	    	for (var d = 0; d < destBoardLength; d++) {
	    		if (destBoardIDs[d] != null && destBoardIDs[d].trim() != "") {
			    	for (var i = 0; i < tempLength; i++) {
			    		if (tempDestBoardDiv[i].id.indexOf("FromTreeView") > -1) { // 마이게시판에 등록된 하위게시판 
			    		    if (tempDestBoardDiv[i].getAttribute("data3") == destBoardIDs[d]) { 
			    		    	leftFrame.refreshItemCnt(tempDestBoardDiv[i].id); 
			    		    	break; 
			    		    	} 
		    		    } else { // 일반 하위게시판 
		    		    	if (tempDestBoardDiv[i].getAttribute("data1") == destBoardIDs[d]) { 
		    		    		leftFrame.refreshItemCnt(tempDestBoardDiv[i].id); 
		    		    		break; 
		    		    	} 
		    		    } 
			    	}
	    		} else {
	    			break;
	    		}
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
				lastTh.css("width", "7px");
		}
	}
	 
	/*var lastTh = $("#BoardList_TH th").last();
	if (lastTh.attr("id") == null) {
		lastTh.css("display", "none");
	}*/
}

/* 2019-04-09 홍승비 - 썸네일게시판 앨범형식 보기 시 미리보기 동작 추가 */
function ItemPreviewRead_AlbumClick(objDiv) {
    selobj = objDiv;
    onclickFlag = true;
    if (g_bPrevShow) {
    	ItemPreviewRead_Album(objDiv);
    }
}
function ItemPreviewRead_Album(objDiv) {
	if (objDiv.getElementsByClassName("albumTitle")[0].style.fontWeight == "bold") {
		objDiv.getElementsByClassName("albumTitle")[0].style.fontWeight = "normal";
	}
	
    var pboardid = objDiv.getAttribute("DATA1");
    var pitemid = objDiv.getAttribute("DATA2");
    
    clickPreviweType = "PHOTO";
    if (document.getElementById("previewmail_bar_h") != null) {
        document.getElementById("previewmail_bar_h").style.cursor = "default";
    }
    xmlhttp = createXMLHttpRequest();
	xmlhttp.open("POST", "/ezBoard/getPreviewItem.do?boardID=" + encodeURIComponent(pboardid) + "&itemID=" + encodeURIComponent(pitemid) + "&mode=" + pMode + "&location=GENERAL", true);
    xmlhttp.onreadystatechange = event_ItemPreviewRead_photo;
    xmlhttp.send();
}
