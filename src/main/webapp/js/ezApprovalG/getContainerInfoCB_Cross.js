var g_CurrentFormCd = "_DEF_1";
var publicityYN = "";
// 2023-05-29  전인하 - 전자결재G > 기록물대장 미리보기 - 미리보기가 삽입되는 페이지 구분값(g_sFlag) 변수배열 추가
var cabinetPreviewItemFlagArr = ['m01', 'm03', 'm05', 'm06', 'm12', 'm13', 'm14', 'UNTREATED', 'docShare']; 


function DisplayLineCnt(Resultxml, viewtype) {
    //document.getElementById("listcount").innerHTML = strLang596 + "<span class='point'>" + NodeListLen + "</span> " + strLang445;
}

function getReceiptInfo() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows()[0];

    var docID = GetAttribute(selRow, "DATA1");
    var publicityYN = GetAttribute(selRow, "DATA16");

    var reqData = new FormData();
    reqData.append("docID", docID);
    reqData.append("mode", "END");
    reqData.append("publicityYN", publicityYN);

    var req = new XMLHttpRequest();
    req.open("POST", "/ezApprovalG/getReceiptinfo.do", false);
    req.send(reqData);

    var res = req.responseText;

    return loadXMLString(res);
}

function getDataInfo() {
	var pUrl = "";

    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows()[0];
    
    //DocList_Flag 지워도 되면 삭제
    if (DocList_Flag == "RECORD" && selRow != undefined) {
        if (trim_Cross(selRow.getAttribute("DATA14")) != "null" && trim_Cross(selRow.getAttribute("DATA14")) != "" && trim_Cross(selRow.getAttribute("DATA14")) >= GetTodayDate()) {
            if (CheckAprLine(selRow.getAttribute("DATA1")) != "TRUE") {
                getdoclistSub_after("NOTPERMISSION");
                return;
            }
        }
    }

    var nowMode = "END";
    if (DocList_Flag != "TMP" && DocList_Flag != "END_RECORD" && DocList_Flag != "APR_RECORD") {
        $.ajax({
            type : "POST",
            dataType : "text",
            async : false,
            url : "/ezApprovalG/getLineMode.do",
            data : {
                docID : DocID,
                orgCompanyID : CompanyID
            },
            success: function(xml){
                nowMode = xml;
            }
        });
    }

    switch (jobState) {
        case "ATTACH":
        	pUrl = "/ezApprovalG/getTotalAttachInfo.do";
            break;

        case "OPINION":
        	pUrl = "/ezApprovalG/getOpinionInfo.do";
            break;

        case "APPROVAL":
        	pUrl = "/ezApprovalG/getLineList.do";
            break;

        case "RECIPENT":
        	pUrl = "/ezApprovalG/getReceiptinfo.do";
            break;
    }

    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : pUrl,
		data : {
				docID : DocID,
				mode  : nowMode,
				publicityYN : publicityYN
				},
		success: function(xml){
			getdoclistSub_after(xml);
		}        			
	});
}

function getdoclistSub_after(xml) {
    try {
        if (document.getElementById("lvtDetail").innerHTML != "")
            document.getElementById("lvtDetail").innerHTML = "";

        if (xml == "NOTPERMISSION") {
            document.getElementById("lvtDetail").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
            document.getElementById("lvtDetail").style.textAlign = "center";
            return;
        }
        
        Resultxml = loadXMLString(xml);

        var DocList = new ListView();      
        DocList.SetID("SubDocList");                               
        DocList.SetMulSelectable(false);                        
        DocList.SetRowOnDblClick("lvtDetail_onSel_DBclick");      
        DocList.DataSource(Resultxml);
        DocList.DataBind("lvtDetail");

        if (USE_OCS == "YES" && jobState == "APPROVAL") {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                setTimeout(check_presence, 100);
            }
            else {
                check_presence();
            }
        }
    }
    catch (e) { 
        console.log(e);
    }
}

function selFirstRow(Resultxml) {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();

    if (selRow.length > 0) {
        processRowClick(selRow[0]);
    }
    else {
        DocID = "";
        pURL = "";
        WriterID = "";
        WriterDeptID = "";
        getDataInfo();
    }
    /* 2022-07-04 홍승비 - 결재완료문서가 존재하는 경우 */
    if ($("#PreviewRayerH").length && $("#PreviewRayerH").css("display") != "none") {
    // 2023-06-30 전인하 - 전자결재G > 기록물대장 미리보기 - 미리보기 레이어 팝업 호출 메소드를 타입에 따라 나눔
        if (typeof cabinetPreviewItemFlagArr != 'undefined' && typeof g_sFlag != 'undefined' && cabinetPreviewItemFlagArr.includes(g_sFlag)) {
            PreviewRayerChange("H", 'Cabinet'); // 기록물
        } else {
            PreviewRayerChange("H", 'Container'); // 완료문서
        }
        if (CrossYN()) {
            if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
                ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = strLang930;	        			
            }
        } else {
            if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
                ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLang930;		            		
            }
        }
    } else if ($("#PreviewRayerH").length) {
        // 2023-07-13 전인하 - 전자결재 > 문서 미리보기 > 미리보기영역 사용하지 않는 메뉴일 경우 미리보기창을 닫는 것이 아니라 프리뷰 레이어 영역을 display: none 처리함
        $("#PreviewRayerH").css("display", "none");
    }
}

function check_presence() {
    try{
        var DocList = new ListView();
        DocList.LoadFromID("SubDocList");
        var selRow = DocList.GetDataRows();
        var pCNList = new Array();
        for (var i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            pCNList[i] = tr.getAttribute("DATA4");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (var i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            tr.cells[1].innerHTML = "<span><img src='/images/Presence/unknown.gif' id ='" + GetGUID() + ",type=smtp' onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/></span>" + tr.cells[1].innerHTML;
        }
        pSIPUriList = null;
    } catch (e) { }
}

function OpenConfirmUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/myoffice/ezApprovalG/ezAPRQuestion_Cross.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken;resizable:yes;";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);

    return RtnVal;
}

//START
function OpenReceiptHistory() {
    var DocList = new ListView();
    DocList.LoadFromID("SubDocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length > 0) {
        var pDocID = tr[0].getAttribute("DATA2");
        var pDeptID = tr[0].getAttribute("DATA1");
        var isExtYN = tr[0].getAttribute("DATA3");

        /* 2019-08-20 홍승비 - 기록물대장 하단 수신자 > 수신자(부서)명 더블클릭 시 팝업창 사이즈 조절 */
        var Url, OpenWin;
        var windowFeature;
        if (isExtYN.toUpperCase() == "Y") {
        	windowFeature = GetOpenWindowfeature(610, 270);
            Url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + pDocID + "&deptID=" + pDeptID;
        }
        else {
        	windowFeature = GetOpenWindowfeature(1155, 460);
            Url = "/ezApprovalG/ezLineInfo.do?docID=" + pDocID + "&deptID=" + pDeptID + "&docState=011";
        }

        var OpenWin = window.open(Url, "OpenReceiptHistory", windowFeature);
        try { OpenWin.focus(); } catch (e) { }
    }
}
//END

function openUserInfo() {
    var DocList = new ListView();
    DocList.LoadFromID("SubDocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length != 0) {
        var pCheckval = tr[0].getAttribute("DATA5");
        if (pCheckval == "Y") {
            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;
            var left = (width - 650) / 2;
            var top = (heigth - 300) / 2;
            //G버전 부서순차합의에서 합의부서 결재선 보일 수 있도록 수정. 2019-02-14 홍대표
//            window.open("/myoffice/ezApprovalG/ezDocInfo/ezLineInfo_Cross.aspx?pDocID=" + tr.getAttribute("DATA3") + "&pDeptID=" + tr.getAttribute("DATA4") + "&pDocState=012", "", "height=270px,width=600px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
            window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr[0].getAttribute("DATA3") + "&deptID=" + tr[0].getAttribute("DATA4") + "&docState=012", "", "height=460px,width=1155px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + GetOpenPosition(1155, 460));
        } else {
            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;
            var left = (width - 450) / 2;
            var top = (heigth - 450) / 2;
            window.open("/ezCommon/showPersonInfo.do?id=" + tr[0].getAttribute("DATA4"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
        }
    }
    else {
        var pAlertContent = strLang598;
        OpenAlertUI(pAlertContent);
    }
}

function GetDocDeliveryList(g_DeliverySearchParamXml) {
	if (g_isSearching) {
    	var searchParamXml = loadXMLString(g_DeliverySearchParamXml);
        var startDate = SelectSingleNodeValue(searchParamXml.firstChild, "SREGDATE");
        var endDate = SelectSingleNodeValue(searchParamXml.firstChild, "EREGDATE");
        
    	if (startDate == "") {
    		var date = new Date();
    		date.setFullYear(date.getFullYear() - 1);
    		
    		g_searchDate.startDate = date;
    	} else {
    		g_searchDate.startDate = new Date(startDate.replace(/-/g,'/'));
    	}
    	
        if (endDate == "") {
        	g_searchDate.endDate = new Date();
        } else {
        	g_searchDate.endDate = new Date(endDate.replace(/-/g,'/'));
        }
    }
	
    DocListType = "DeliveryList";
    if (pChackYN == "FALSE") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
    }

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER"); 
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "pOrderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "pOrderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "pQuery", "");	
    createNodeAndInsertText(xmlpara, objNode, "ISDOCPRINT", "FALSE");
    createNodeAndInsertText(xmlpara, objNode, "UPPERDEPTCODE", upperDeptCode);
    if (g_DeliverySearchParamXml != "" && g_DeliverySearchParamXml != undefined) {
        createNodeAndInsertText(xmlpara, objNode, "search", "1");
        var oSParam = loadXMLString(g_DeliverySearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);
    }
    else {
        createNodeAndInsertText(xmlpara, objNode, "search", "0");
    }

    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "EXTRECEPTYN", g_sFlag === "m03" ? "N" : "Y");
    g_szParamXml = getXmlString(xmlpara);
   
    g_DeliveryXmlhttp = createXMLHttpRequest();
    g_DeliveryXmlhttp.open("POST", "/ezApprovalG/getDeliveryList.do", true);
    g_DeliveryXmlhttp.onreadystatechange = onreadystatechange_GetDocDeliveryList;
    g_DeliveryXmlhttp.send(xmlpara);
}

function onreadystatechange_GetDocDeliveryList() {
    var iStatus;
    var Resultxml;
    if (g_DeliveryXmlhttp != null) {
        if (g_DeliveryXmlhttp.readyState == 4) {

            excelXML = getXmlString(g_DeliveryXmlhttp.responseXML);
            Resultxml = g_DeliveryXmlhttp.responseXML;

            iStatus = g_DeliveryXmlhttp.status;

            switch (iStatus) {
                case 200:
                case 201:
                case 204:
                case 207:
                    if (getNodeText(Resultxml) != "") {
                        listNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
                        NodeList = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
                        NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALDOCCOUNT");
                        Haders = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/HEADERS/HEADER");
                        NodeListLen = 0;

                        if (NodeList2 != null) {
                            var cnt = getNodeText(NodeList2);
                            if (cnt != "")
                                NodeListLen = cnt;
                            else
                                NodeListLen = 0;
                        }

                        if (listNode != null) {

                            var xmlDoc
                            if (CrossYN()) {
                                var xmlLIST = createXmlDom();
                                var nodeToImport = xmlLIST.importNode(listNode, true);
                                xmlLIST.appendChild(nodeToImport);

                                xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
                            }
                            else {
                                xmlDoc = createXmlDom();
                                xmlDoc.appendChild(listNode);
                            }

                            if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
                            var DocList = new ListView();                           
                            DocList.SetID("DocList");                               
                            DocList.SetMulSelectable(true);
                            DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");
                            DocList.SetRowOnClick("lvtDoclist_SelChange");           
                            DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
                            DocList.SetTitleIdx(0);                                  
                            DocList.SetUrgentFlag(false);                            
                            // 2023-09-27 전인하 - 배부대장의 보안결재날짜 데이터는 DATA8에 존재하여 SecurityIdx를 교체함, 보안결재플래그 활성화
                            DocList.SetSecurityFlag(true);                           
                            DocList.SetSecurityIdx(7);
                            DocList.DataSource(xmlDoc);                             
                            DocList.DataBind("lvtDoclist");                          
                            DocList = null;

                            makePageSelPage(NodeListLen);
                            selFirstRow(Resultxml);
                        }
                        // 2023-06-15 전인하 - 전자결재G > 기록물대장 미리보기 -  초기 로딩이 끝난 뒤 미리보기가 열린 상태일 경우 미리보기 여는 분기 삽입
                        // 리스트 로딩보다 미리보기 열람 분기가 먼저 이루어지는 것을 개선
                        if (typeof previewInfo != 'undefined' && previewInfo != "OFF" && typeof cabinetPreviewItemFlagArr != 'undefined' && cabinetPreviewItemFlagArr.includes(g_sFlag)) {
                            PreviewRayerChange(pPreviewShow_HOW, 'Cabinet');
                        }
                    }
                    else {
                        OpenAlertUI(strLang548);
                        return null;
                    }
                    break;
                default:
                    OpenAlertUI(strLang548);
                    return null;
                    break;

            }
            DisplayLineCnt(Resultxml, "3");

            pChackYN = "TRUE";
        }
    }
}

function CheckFormConnFlag(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getFormConnFlag.do",
		data : {
			docID : pDocID,
			companyID : CompanyID
		},
		success: function(xml){
			result = xml;
		}
	});
    if (getNodeText(loadXMLString(result).documentElement) == "Y")
        return true;
    else
        return false;
}

function lvtDoclist_SelChange() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length > 0) {
        processRowClick(tr[0]);
        // 2023-07-10 전인하 - 전자결재G > 기록물대장 미리보기 - tr 클릭 시 관리자페이지가 아닐 때, 미리보기 표출 동작 삽입
        if (useAprPreview == "YES" && typeof cabinetPreviewItemFlagArr != 'undefined' && cabinetPreviewItemFlagArr.includes(g_sFlag)) {
            if ($("#PreviewRayerH").length && $("#PreviewRayerH").css("display") != "none") {
                PreviewRayerChange("H", 'Cabinet');
            } else {
                /* 2021-03-24 홍승비 - 제목 클릭 시 원클릭 이벤트로 전자결재 읽기, 결재 팝업창을 표출 */
                var headerNameTD = $(event.target).attr("headerName");
                if (headerNameTD != null && typeof(headerNameTD) != "undefined" && (headerNameTD == "DOCTITLE" || headerNameTD == "RECTITLE" || headerNameTD == "TITLE")) {
                    lvtDoclist_onSel_DBclick();
                }
            }
        } else {
            /* 2021-03-24 홍승비 - 제목 클릭 시 원클릭 이벤트로 전자결재 읽기, 결재 팝업창을 표출 */
            var headerNameTD = $(event.target).attr("headerName");
            if (headerNameTD != null && typeof(headerNameTD) != "undefined" && (headerNameTD == "DOCTITLE" || headerNameTD == "RECTITLE" || headerNameTD == "TITLE")) {
                lvtDoclist_onSel_DBclick();
            }
        }
    }
}

function processRowClick(tr) {
    if (DocList_Flag == "RECORD") {
        DocID = GetAttribute(tr, "DATA1");
        pURL = GetAttribute(tr, "DATA2");
        WriterDeptID = GetAttribute(tr, "DATA11");
        WriterID = GetAttribute(tr, "DATA3");
        publicityYN = GetAttribute(tr, "DATA16");
        if (!HasRecReadRight(GetAttribute(tr,"DATA6"), GetAttribute(tr,"DATA8"), UserID)) {
            publicityYN = "N";
        }
        
        ChkCabRoleInfo(tr);
        
        //기록물등록대장에서 재발송버튼 보이기위해 추가 2018-07-27 강민수92
        // if (WriterID == "") {
        // 	WriterID = GetAttribute(tr, "DATA3");
        // }

        // if (typeof (SendOfferCheckBtn) != "undefined")
        //     SendOfferCheckBtn(DocID, UserID);

        // if (DocList_Flag == "RECORD") {
        //     if (document.getElementById("tdGongRam")) {
        //         if ((GetAttribute(tr, "DATA15") == "011" || GetAttribute(tr, "DATA15") == "001") && (arr_userinfo[1] == WriterID) && GetAttribute(tr, "DATA8") === "00")
        //             document.getElementById("tdGongRam").style.display = "";
        //         else
        //             document.getElementById("tdGongRam").style.display = "none";
        //     }
        // }

        /* 2020-08-06 홍승비 - 기록물등록대장 > 재발송 버튼 표출 시 리스트헤더의 칼럼 데이터를 colname 활용하여 가져오도록 수정 */
        // if (WriterID == arr_userinfo[1]) {
        //     try {
        //     	var rejectFlagIdx = 0; // 반려칼럼 인덱스
        //     	var resendFlagIdx = 0; // 수신칼럼 인덱스
        //     	var docListHeader = $("#DocList").find("tr[id='DocList_TH']");
            	
        //     	if (docListHeader.length > 0) {
        //     		rejectFlagIdx = docListHeader.find("th[colname='REJECTFLAG']").index();
        //     		resendFlagIdx = docListHeader.find("th[colname='RESENDFLAG']").index();
        //     	}
            	
        //         if (typeof (tr.cells[resendFlagIdx].innerHTML) == "string") {
        //             if (tr.cells[resendFlagIdx].innerHTML == strLang597 && tr.cells[rejectFlagIdx].innerHTML == "") { // 수신칼럼 = "발송", 반려칼럼 = ""인 경우 재발송 버튼 표출
                    
        //                 if (typeof (tdReSend) != "undefined" && typeof (tdReSend) != "unknown") {
        //                     document.getElementById("tdReSend").style.display = "";
        //                 }
        //             }
        //             else {
        //                 if (typeof (tdReSend) != "undefined" && typeof (tdReSend) != "unknown") {
        //                     document.getElementById("tdReSend").style.display = "none";
        //                 }
        //             }
        //         }
        //         else {
        //             if (typeof (tdReSend) != "undefined" && typeof (tdReSend) != "unknown") {
        //                 document.getElementById("tdReSend").style.display = "none";
        //             }
        //         }
        //     }
        //     catch (e) { }
        // }
        // else {
        //     if (typeof (tdReSend) != "undefined" && typeof (tdReSend) != "unknown") {
        //         document.getElementById("tdReSend").style.display = "none";
        //     }
        // }
        
        /* 2022-03-18 홍승비 - 미처리문서함 > 반송처리된 내부시행문 TR 클릭 시 삭제버튼 활성화 */
        if (ListTypeFlag == "23") { // 미처리문서함
        	var rejectFG = GetAttribute(tr,"DATA13"); // TBL_RECORD의 REJECTFLAG(반송플래그)
        	var pDocType = GetAttribute(tr,"DATA17"); // DOCTYPE (001 = 시행문)
        	if (rejectFG == "1" && pDocType == "001") {
        		document.getElementById("tbtnRemoveDoc").style.display = "";
        	} else {
        		document.getElementById("tbtnRemoveDoc").style.display = "none";
        	}
        }

        switch (jobState) {
            case "ATTACH":
                Attach_onclick();
                break;

            case "OPINION":
                Opinion_onclick();
                break;

            case "APPROVAL":
                Approval_onclick();
                break;

            case "RECIPENT":
                Recipent_onclick()
                break;
        }
    } else if (DocList_Flag == "CABINET") {
        ChkCabRoleInfo(tr);
    } else if (DocList_Flag == "Delivery") {
        DocID = GetAttribute(tr,"DATA1");
        pURL = GetAttribute(tr,"DATA2");
        
		switch (jobState) {
            case "ATTACH":
                Attach_onclick();
                break;

            case "OPINION":
                Opinion_onclick();
                break;

            case "APPROVAL":
                Approval_onclick();
                break;

            case "RECIPENT":
                Recipent_onclick()
                break;
        }
	}
}
