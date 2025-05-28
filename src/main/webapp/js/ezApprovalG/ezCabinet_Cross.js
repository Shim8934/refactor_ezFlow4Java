var ListTypeFlag;
var g_SelCabXml = "";
var g_TransFlag = "0";
var g_szParamXml = "";
var g_CabSearchParamXml = "";
var g_RecSearchParamXml = "";
var g_DeliverySearchParamXml = "";

var g_HeaderInfoXml = "";

var g_SortField = "", g_SortType = "", g_OrderBy = "";

var g_bConfirm = false;
var g_bRecAdmin = false;	
var g_bDeptCharger = false;	
var g_bCabCharger = false;

var g_ItemDeptID;
var g_OtherDeptDocViewRight = false;

var g_CabListXmlhttp = null;
var totalPage = "";
var pTotalCnt = "";

var g_isSearching = false;
var g_searchDate = {
	startDate: null,
	endDate: null
}

var OrderOption = "";

var cabProduceY = ""; // 기록물철등록부에서 기록물보기로 진입한 경우, 선택된 기록물철분류의 생산년도를 담는 변수

/* 2022-12-27 홍승비 - 기록물철 검색 시 생산연도 조건 없는 경우, 반드시 회계연도 '이하' 조건을 사용하기 위한 회계연도 전역변수 추가 */
var accountYearForCabList = getAccountingYear();

function ChkCabRoleInfo(selRow) {
    var ConfirmFlag;
    var CabClassNo;
    var MenuType;

    if (selRow != null) {
        if (ListTypeFlag == "2" || ListTypeFlag == "3") {
            MenuCtl_Trans();
        }
        else {
            if (DocList_Flag == "CABINET") {
                ConfirmFlag = selRow.getAttribute("DATA4");
                CabClassNo = selRow.getAttribute("DATA2");
                g_ItemDeptID = selRow.getAttribute("DATA5");
                g_ItemDeptID = g_ItemDeptID.trim();

                MenuType = "0";
            }
            else if (DocList_Flag == "RECORD") {
                ConfirmFlag = selRow.getAttribute("DATA9");
                CabClassNo = selRow.getAttribute("DATA10");
                g_ItemDeptID = selRow.getAttribute("DATA11");

                g_ItemDeptID = g_ItemDeptID.trim();

                MenuType = "1";
            }

            if (ConfirmFlag == "1")
                g_bConfirm = true;
            else
                g_bConfirm = false;

            // voc.kaoni.com(#125383) - 전자결재G > 업무담당자 > 대장등록과 열람권한 설정 가능
            /*if (MenuType == "1" && g_bDeptCharger) {
            	g_bCabCharger = true;
            } else {*/
            g_bCabCharger = ISCabCharger(CabClassNo, UserID);
            // }
            
            ezCabMunuCtl(MenuType, selRow);
        }
    }
}

function SwapIcon(objImg, szVal) {
    if (objImg) {
        objImg.Enable = szVal;
    }
}

function ezCabMunuCtl(MenuType, selRow) {
    var ModRight = GetChangeRight();

    var pModRight_Flag = true;

    if (ModRight == "true")
        pMenuFlag = "";
    else
        pMenuFlag = "none";
        
    if (g_sFlag === "m02" && underDeptFlag === "TRUE" && GetSelectVal("rec_underDept2") != "default") {
        MenuType = "cabinetUnderDept";
    }

    switch (MenuType) {
        case "0":
            if (typeof (spanElement) != "undefined") {
                return;
            }
        
            if (typeof (tdNewVol) != "undefined" && typeof (tdNewVol) != "unknown") {
                document.getElementById("tdNewVol").style.display = "none"; // 권호수 안보이게
            }

            if (typeof (tdModifyCab) != "undefined" && typeof (tdModifyCab) != "unknown" && ListTypeFlag !== "15") {

                document.getElementById("tdModifyCab").style.display = pMenuFlag;
            }

            // 20200824 김보혜 기록물철 관련 버튼들 전체적으로 수정 (한사대) 
            if ((g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE") && ListTypeFlag !== "15") {
                document.getElementById("tdBtnCabDel").style.display = "";    
            }

            // 20201215 강승구 '종료연기승인', '편철확정' 오류수정
            var endProBtn = document.getElementById("tdbtnEndProduce");
            var endCancelProBtn = document.getElementById("tdbtnCancelEndProd");

            if(endProBtn && endCancelProBtn) {
                if (ListTypeFlag == "8" && GetCabChargerRight() === "true" && g_sFlag != "m09") {
                    if (selRow.getAttribute("DATA6") == "0") {
                        document.getElementById("tdbtnEndProduce").style.display = "";
                        document.getElementById("tdbtnCancelEndProd").style.display = "none";
                    } else {
                        document.getElementById("tdbtnEndProduce").style.display = "none";
                        document.getElementById("tdbtnCancelEndProd").style.display = "";
                    }
                    document.getElementById("tdNewVol").style.display = "";
                } else if(ListTypeFlag == "10" && GetCabChargerRight() === "true" && g_sFlag == "m07"){			// 2020-09-14 김민성 - 종료연기신청, 정리대상목록 권호수추가 버튼 추가
                    document.getElementById("tdbtnEndProduce").style.display = "";
                    document.getElementById("tdbtnCancelEndProd").style.display = "none";
                    document.getElementById("tdNewVol").style.display = "";
                } else {
                    document.getElementById("tdbtnEndProduce").style.display = "none";
                    document.getElementById("tdbtnCancelEndProd").style.display = "none";
                }
            }

            /**
             * 연기신청에 따른 버튼 활성화비활성화
             */
            if (ListTypeFlag == "10" && GetCabChargerRight() === "true") {
                if (selRow.getAttribute("DATA8") == "Y") {
                    document.getElementById("tdReqDelayEndY").style.display = "none";
                    document.getElementById("tdCancelDelayEndY").style.display = "";
                } else {
                    document.getElementById("tdReqDelayEndY").style.display = "";
                    document.getElementById("tdCancelDelayEndY").style.display = "none";
                }
            }

            if (typeof (tdViewCabHist) != "undefined" && typeof (tdViewCabHist) != "unknown") {
                if (IsUserDeptRec() == "true")
                    document.getElementById("tdViewCabHist").style.display = "";
                else
                    document.getElementById("tdViewCabHist").style.display = "none";
            }


            if (typeof (tdSetCharger) != "undefined" && typeof (tdSetCharger) != "unknown") {
                if (GetCabChargerRight() == "true" && ListTypeFlag !== "15")
                    document.getElementById("tdSetCharger").style.display = "";
                else
                    document.getElementById("tdSetCharger").style.display = "none";
            }

            break;

        case "1":
        	
        	if (typeof (ListTypeFlag) != "undefined" && ListTypeFlag == "25") {
        		return;
        	}
        	if (typeof (spanElement) != "undefined") {
        	    return;
        	}
        	/* 2023-06-28 한태훈 - 통합 PC 저장 시 지워졌던 네 개의 버튼 - 등록정보, 공람정보, 철검색, 목록출력 버튼 보이기 (나머지 버튼들은 아래 if문으로 조절됨) */
        	document.getElementById("tDocInfo").style.display = "";
			document.getElementById("tdViewRecInfo").style.display = "";
			document.getElementById("tdCabSelect").style.display = "";
			document.querySelector("#trRecSubMenu #tdDocListPrint").style.display = "";
        	
            if (typeof (tdRegRecord) != "undefined" && typeof (tdRegRecord) != "unknown") {
                if (GetCabChargerRight() == "true")
                    document.getElementById("tdRegRecord").style.display = "";
                else
                    document.getElementById("tdRegRecord").style.display = "none";
            }

            if (typeof (tdRegSepAtt) != "undefined" && typeof (tdRegSepAtt) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                	if (GetCabChargerRight() == "true" || g_bDeptCharger) {
                        document.getElementById("tdRegSepAtt").style.display = "";
                    } else {
                        document.getElementById("tdRegSepAtt").style.display = "none";
                    }
                }
                else {
                    document.getElementById("tdRegSepAtt").style.display = "none";
                }
            }

            if (typeof (tdMoveRec) != "undefined" && typeof (tdMoveRec) != "unknown")
                document.getElementById("tdMoveRec").style.display = pMenuFlag;

            if (typeof (tdModifyRec) != "undefined" && typeof (tdModifyRec) != "unknown")
                document.getElementById("tdModifyRec").style.display = pMenuFlag;
            
            if (g_bRecAdmin || AdminYN == "TRUE") {
                if (typeof (tdVeiwRecHist) != "undefined" && typeof (tdVeiwRecHist) != "unknown") {
                document.getElementById("tdVeiwRecHist").style.display = "";
                }
                document.getElementById("tdbtnViewRecReadHist").style.display = "";
                CheckBtnSetRecRole();
            } else {
                if (typeof (tdVeiwRecHist) != "undefined" && typeof (tdVeiwRecHist) != "unknown") {
                	document.getElementById("tdVeiwRecHist").style.display = "none";
                }
                if (typeof (tdbtnViewRecReadHist) != "undefined" && typeof (tdbtnViewRecReadHist) != "unknown") {
                document.getElementById("tdbtnViewRecReadHist").style.display = "none";
                }
            }
            
            if (typeof (tdbtnSetRecRole) != "undefined" && typeof (tdbtnSetRecRole) != "unknown") {
                // #125383 전자결재G > 업무담당자 > 대장등록과 열람권한 설정 가능
                // 기록물 관리 책임자 외에 관리자, 작성자, 업무담당자등 버튼 감추라고 하여 변경함.
            	if (g_bRecAdmin) {
	                document.getElementById("tdbtnSetRecRole").style.display = "";
            	} else {
            		document.getElementById("tdbtnSetRecRole").style.display = "none";
            	}
            }
            
            if (typeof (tdNotify_Rec) != "undefined" && typeof (tdNotify_Rec) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    if (IsUserDeptRec() == "true")
                        document.getElementById("tdNotify_Rec").style.display = "";
                    else
                        document.getElementById("tdNotify_Rec").style.display = "none";
                }
                else {
                    document.getElementById("tdNotify_Rec").style.display = "none";
                }
            }

            if (typeof (tddisplaySend_Rec) != "undefined" && typeof (tddisplaySend_Rec) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    if (IsUserDeptRec() == "true")
                        document.getElementById("tddisplaySend_Rec").style.display = "";
                    else
                        document.getElementById("tddisplaySend_Rec").style.display = "none";
                }
                else {
                    document.getElementById("tddisplaySend_Rec").style.display = "none";

                }
            }

            if (typeof (tdVeiwRecHist) != "undefined" && typeof (tdVeiwRecHist) != "unknown") {
                if (IsUserDeptRec() == "true" && document.getElementById("tdVeiwRecHist").style.display == "")
                    document.getElementById("tdVeiwRecHist").style.display = "";
                else
                    document.getElementById("tdVeiwRecHist").style.display = "none";
            }

            if (typeof (tdbtnViewRecReadHist) != "undefined" && typeof (tdbtnViewRecReadHist) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    // #125383 전자결재G > 업무담당자 > 대장등록과 열람권한 설정 가능
                    // 기록물 관리 책임자 외에 관리자, 작성자, 업무담당자등 버튼 감추라고 하여 변경함.
                    if (g_bRecAdmin) {
                    	document.getElementById("tdbtnViewRecReadHist").style.display = "";
                    }
                    else{
                    	document.getElementById("tdbtnViewRecReadHist").style.display = "none";
                    }
                }
                else {
                    document.getElementById("tdbtnViewRecReadHist").style.display = "none";
                }
            }

            if (typeof (tdbtnCardSend) != "undefined" && typeof (tdbtnCardSend) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    if (selRow.getAttribute("DATA12") == "7") {
                        if (IsUserDeptRec() == "true")
                            document.getElementById("tdbtnCardSend").style.display = "";
                        else
                            document.getElementById("tdbtnCardSend").style.display = "none";
                    }
                    else {
                        document.getElementById("tdbtnCardSend").style.display = "none";
                    }
                }
                else {
                    document.getElementById("tdbtnCardSend").style.display = "none";
                }
            }

            if (document.getElementById("tdGongRam")) {
//                if ((GetAttribute(selRow, "DATA15") == "011" || GetAttribute(selRow, "DATA15") == "001") && arr_userinfo[1] == GetAttribute(selRow, "DATA3") && GetAttribute(selRow, "DATA8") === "00")
				// 2020-01-08 정주환 공람발송 기안자는 항상 on
                if ((((GetAttribute(selRow, "DATA15") == "001" || GetAttribute(selRow, "DATA15") == "019" || GetAttribute(selRow, "DATA15") == "014") && arr_userinfo[1] == GetAttribute(selRow, "DATA3")) || (GetAttribute(selRow, "DATA15") == "011" && arr_userinfo[1] == GetAttribute(selRow, "DATA19"))) && GetAttribute(selRow, "DATA8") === "00")
                    document.getElementById("tdGongRam").style.display = "";
                else
                    document.getElementById("tdGongRam").style.display = "none";
            }

            if (document.querySelector("#tdichange_Rec") && document.querySelector("#tdichangeS_Rec")) {
                var seperateAttachNo = GetAttribute(selRow, "DATA8");
                var rejectFlag = GetAttribute(selRow, "DATA13");
                var docType = GetAttribute(selRow, "DATA17");
                var docState = GetAttribute(selRow, "DATA15");
                if (isDrafter(WriterID, WriterDeptID) && seperateAttachNo === "00" && rejectFlag === "0") {
                    if (docType === "003" && docState === "001") {
                        SetMenuBtn("tdichange_Rec", "none");
                        SetMenuBtn("tdichangeS_Rec", "none");
                        SetMenuBtn("tdReSend", "");
                    } else {
                        SendOfferCheckBtn(GetAttribute(selRow, "DATA1"), arr_userinfo[1]);
                    }
                }
                /* 2022-03-18 홍승비 - 미처리문서함 > 내부시행문 시행문변환 팝업창 내부에서 반송 시 삭제 가능 + 다시 시행문변환하여 발송도 가능 (rejectFlag == 1이라도 시행문변환 가능) */
                else if (ListTypeFlag == "23" && isDrafter(WriterID, WriterDeptID) && seperateAttachNo === "00" && rejectFlag === "1") {
                    if (docType === "003" && docState === "001") {
                        SetMenuBtn("tdichange_Rec", "none");
                        SetMenuBtn("tdichangeS_Rec", "none");
                        SetMenuBtn("tdReSend", "");
                    } else {
                        SendOfferCheckBtn(GetAttribute(selRow, "DATA1"), arr_userinfo[1]); // 내부시행문, 외부시행문 판별
                    }
                } else {
                    SetMenuBtn("tdichange_Rec", "none");
                    SetMenuBtn("tdichangeS_Rec", "none");
                    SetMenuBtn("tdReSend", "none");
                }
            }
            
            break;
            
            case "cabinetUnderDept" : 
            break;
    }

    if (ListTypeFlag == "9") {
        SetMenuBtn("tdModifyCab", "none");
        SetMenuBtn("tdViewCabHist", "none");
        SetMenuBtn("tdSetCharger", "none");
        SetMenuBtn("tdbtnViewRecList", "none");
        SetMenuBtn("tbar1", "none");
        SetMenuBtn("tdNewVol", "none");
    }
}
function SetMenuBtn(sbtnname, sbtnstyle) {
    if (document.getElementById(sbtnname) != null)
        document.getElementById(sbtnname).style.display = sbtnstyle;
}
function isDrafter(writerID, writerDeptID) { // 발송의뢰 표출 조건 상위부서 확인하도록 함. 
    return writerID === arr_userinfo[1] && (writerDeptID === arr_userinfo[4] || writerDeptID === upperDeptCode);
}

function IsUserDeptRec() {
    if (AdminYN == "TRUE") {
        return "true";
    }
    else {
        if (g_ItemDeptID == DeptID)	
        {
            return "true";
        }
        else
        {
            return "false";
        }
    }
}
function GetCabChargerRight() {
    if (g_ItemDeptID == DeptID)
    {
        if (g_bRecAdmin)
        {
            return "true";
        }
        else
        {
            return g_bCabCharger.toString();
        }
    }
    else
    {
        return "false";
    }
}

function GetChangeRight() {
    if (AdminYN == "TRUE") {
        return "true";
    }
    else {
        if (g_ItemDeptID == DeptID)	
        {
            if (g_bRecAdmin)
            {
                return "true";
            }
            else {
                if (g_bConfirm)	
                {
                    return "false";
                }
                else
                {
                    return g_bCabCharger.toString();
                }
            }
        }
        else	
        {
            return "false";
        }
    }
}

function InitGlobals(ListFlag, ListType, MenuType) {
    curpage = 1;
    nowblock = 0;
    totalPage = 0;

    DocList_Flag = ListFlag;
    ListTypeFlag = ListType;

    if (ListFlag == "CABINET") {
        //g_CabSearchParamXml = "";
        try {
            if (trSubInfoTab) {
                document.getElementById("trSubInfoTab").style.display = "none";
                document.getElementById("divList").style.height = "730px";

                //PageSize = 10;
                Block_Size = 10;
            }
        } catch (e) { }
    }
    else if (ListFlag == "RECORD") {
        g_SelCabXml = "";
        //g_RecSearchParamXml = "";
        try {
            if (trSubInfoTab) {
                document.getElementById("trSubInfoTab").style.display = "";
                document.getElementById("divList").style.height = "474px";
                //PageSize = 10;
                Block_Size = 10;
            }
        } catch (e) { }
    }

    g_SortField = "";
    g_SortType = "";
    g_OrderBy = "";

    GetHearderXml();
    InitSubMenu(MenuType);
}


function GetCabHistList() {
    DocList_Flag = "CABHIST";

    switch (ListTypeFlag) {
        case "2":
            GetTransListXml("P03");
            break;

        case "3":
            GetTransListXml("T03");
            break;

        case "4":
            g_CabSearchParamXml = "";
            GetTransListXml("T03");
            break;
    }
    InitSubMenu();
}

function GetRecHistList() {
    DocList_Flag = "RECHIST";
    switch (ListTypeFlag) {
        case "2":
            GetTransListXml("P04");
            break;

        case "3":
            GetTransListXml("T04");
            break;

        case "4":
            g_CabSearchParamXml = ""; 
            GetTransListXml("T04");
            break;
    }
    InitSubMenu();
}

function GetSCList() {
    DocList_Flag = "SCLIST";
    switch (ListTypeFlag) {
        case "2":
            GetTransListXml("P05");
            break;

        case "3": 
            GetTransListXml("T05");
            break;

        case "4": 
            g_CabSearchParamXml = ""; 
            GetTransListXml("T05");
            break;
    }
    InitSubMenu();
}

function GetAttachList() {
    DocList_Flag = "ATTACH";

    switch (ListTypeFlag) {
        case "2":
            GetTransListXml("P06");
            break;

        case "3":
            GetTransListXml("T06");
            break;

        case "4": 
            g_CabSearchParamXml = "";
            GetTransListXml("T06");
            break;
    }
    InitSubMenu();
}

function GetDistList() {
    DocList_Flag = "DISTLIST";

    GetTransListXml("P07");	

    InitSubMenu();
}

function GetCaninetList() {
	listLoading(true); //20201211 조진호 - 리스트 출력 시 시간이 오래 걸릴 수 있어 로딩바 추가
    if (isPeriodYear && g_CabSearchParamXml == "") {
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        if (nowmonth < 10)
            nowmonth = "0" + nowmonth;

        if (nowday < 10)
            nowday = "0" + nowday;

        g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00.001</SPRODUCEY><EPRODUCEY>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59.999</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
    }

    switch (ListTypeFlag) {
        case "2": 
            GetTransListXml("P01");
            break;

        case "3": 
            GetTransListXml("T01");
            break;

        case "4": 
            g_CabSearchParamXml = "<SEARCHPARAM><TRANSFLAG>16=0</TRANSFLAG></SEARCHPARAM>";
            GetTransListXml("T01");
            break;

        default:
            GetCaninetListXml();
    }
    listLoading(false);	// 20201211 조진호 로딩바 display:none
    settingResize();
}

function GetRecordList() {
    if (g_RecSearchParamXml == "") {
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        if (nowmonth < 10)
            nowmonth = "0" + nowmonth;

        if (nowday < 10)
            nowday = "0" + nowday;

        var tempDeptID = DeptID;

        if (typeof underDeptFlag !== "undefined" && underDeptFlag === "TRUE" && GetSelectVal("rec_underDept") != "default") {
            tempDeptID = GetSelectVal("rec_underDept");
        }
        
        var selSendStatus = "";
        var selSendStatusElement = document.getElementById("selSendStatus");
        if (selSendStatusElement && selSendStatusElement.style.display == "") {
            selSendStatus = selSendStatusElement.value;

            var deptSelectBox = g_sFlag === "m02" ? "rec_underDept2" : "rec_underDept";
            var deptSelectBoxCheck = document.getElementById(deptSelectBox);
            if ((deptSelectBoxCheck && GetSelectVal(deptSelectBox) != "default") || (!deptSelectBoxCheck && underDeptFlag === "TRUE")) {
                selSendStatus = "";
            }
        } else if (typeof(selSendStatusFlag) != "undefined" && selSendStatusFlag == "N") {
            selSendStatus = "N"
        }
        // if (checkRecordAll()) {
        //  checkRecordAll : 기존 소스를 찾을 수 없어 임시 주석처리
        //     tempDeptID = "ALL";
        // }

        /* 2022-07-20 홍승비 - 기록물철등록부 > 기록물철 선택 후 기록물보기로 진입한 경우, 선택한 기록물철의 생산 년도를 기준으로 표출 (검색조건 없을 시의 기본 표출) */
        if (typeof(isCabinetToRecordFirst) != "undefined" && isCabinetToRecordFirst == true && typeof(g_sFlag) != "undefined" && g_sFlag == "m02") { // 기록물철등록부의 g_sFlag는 'm02'
        	// 생산년도의 01월 01일부터 12월 31일까지를 검색 범위로 설정
        	g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + cabProduceY + "-01-01 00:00:00.001</SREGDATE><EREGDATE>" + cabProduceY + "-12-31 23:59:59.999</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE><SELSENDSTATUS>" + selSendStatus + "</SELSENDSTATUS></SEARCHPARAM>";
        }
        else {
        	g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00.001</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59.999</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE><SELSENDSTATUS>" + selSendStatus + "</SELSENDSTATUS></SEARCHPARAM>";        	
        }
    } else if (g_isSearching) {
    	var searchParamXml = loadXMLString(g_RecSearchParamXml);
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

    switch (ListTypeFlag) {
        case "2": 
            GetTransListXml("P02");
            break;

        case "3": 
            GetTransListXml("T02");
            break;

        case "4": 
            GetTransListXml("T02");
            break;

        default:
            GetRecordListXml();
    }
}

function GetTransListXml(ListType) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "LISTTYPE", ListType);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "ORDERBY", g_OrderBy);

    if (g_CabSearchParamXml != "")	
    {
        var oSParam = loadXMLString(g_CabSearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);
    }

    g_szParamXml = getXmlString(xmlpara);

    g_CabListXmlhttp = createXMLHttpRequest();
    g_CabListXmlhttp.open("POST", "/ezApprovalG/getTransList.do", true);
    g_CabListXmlhttp.onreadystatechange = onreadystatechange_CabList;
    g_CabListXmlhttp.send(xmlpara);

}

function GetCaninetListXml() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "LISTFLAG", ListTypeFlag);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "ORDERBY", g_OrderBy);

    if (g_CabSearchParamXml != "")	
    {
        var oSParam = loadXMLString(g_CabSearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);
    }
    
    /* 2022-12-27 홍승비 - 기록물철등록부에서 진입 + 특정 생산연도 '이하' 검색조건이 없다면 반드시 현재 회계연도를 생산연도 검색조건으로 체크하도록 수정 */
    // 현재 회계연도와 같거나 이하인 생산연도의 기록물철만 기본으로 표출함
    var eProduceYear = xmlpara.getElementsByTagName("EPRODUCEY")[0];
    if (ListTypeFlag == "0") {
    	// 생산연도 검색조건 태그 자체가 없음 -> 검색조건 태그를 신규 삽입
    	if (typeof(eProduceYear) == "undefined" || eProduceYear == null) {
    		createNodeAndInsertText(xmlpara, objNode, "EPRODUCEY", accountYearForCabList);
    	}
    	// 생산연도 검색조건 태그는 존재하나 내부에 값이 없음 -> 검색조건 태그 내부의 값을 치환
    	else if (eProduceYear.innerHTML.trim() == "") {
    		eProduceYear.innerHTML = accountYearForCabList;
    	}
    }

    g_szParamXml = getXmlString(xmlpara);

    g_CabListXmlhttp = createXMLHttpRequest();
    g_CabListXmlhttp.open("POST", "/ezApprovalG/getCabinetList.do", true);
    g_CabListXmlhttp.onreadystatechange = onreadystatechange_CabList;
    g_CabListXmlhttp.send(xmlpara);
}


function onreadystatechange_CabList() {
    var Resultxml;
    var iStatus;

    if (g_CabListXmlhttp != null) {
        if (g_CabListXmlhttp.readyState == 4 && g_CabListXmlhttp.status == 200) {
            Resultxml = g_CabListXmlhttp.responseXML;
            iStatus = g_CabListXmlhttp.status;

            switch (iStatus) {
                case 200:
                case 201:
                case 204:
                case 207:
                    if (getXmlString(Resultxml) == "" || getNodeText(GetChildNodes(Resultxml)) == "FALSE") {
                        OpenAlertUI(strLang548);
                        return null;
                    }

                    if (iStatus == 207) {
                        var nodeStatus = SelectSingleNode(Resultxml, "a:multistatus/a:response[a:status $ge$ 'HTTP/1.1 4']");
                        if (nodeStatus != null) {
                            OpenAlertUI(strLang548);
                            return null;
                        }
                    }

                    InsertToCabListView(Resultxml);
                    break;

                default:
                    OpenAlertUI(strLang548);
                    return null;
            }
            g_CabListXmlhttp = null;
        }
    }
}

function InsertToCabListView(Resultxml) {
    try {
        ListViewData = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
        NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALDOCCOUNT");

        if (ListViewData == null)
            return;

        NodeListLen = 0;

        
        if (NodeList2 != null) {
            var cnt = getNodeText(NodeList2);
            if (cnt != "")
                NodeListLen = cnt;
            else
                NodeListLen = 0;
        }

        var xmlDoc;
        if (CrossYN()) {
            var xmlLIST = createXmlDom();
            var nodeToImport = xmlLIST.importNode(ListViewData, true);
            xmlLIST.appendChild(nodeToImport);

            xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
        }
        else {
            xmlDoc = createXmlDom();
            xmlDoc.appendChild(ListViewData);
        }
        
        if (g_HeaderInfoXml != "") {
        	xmlDoc = insertSortInfoToHeader(g_HeaderInfoXml, xmlDoc);
        }
        
        if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DocList");                               
        DocList.SetMulSelectable(true);                        
                                  
        DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");      
        DocList.SetRowOnClick("lvtDoclist_SelChange");           
        DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
        DocList.SetOrderbyCol("COLNAME");
        DocList.SetTitleIdx(0);
        DocList.SetTitle("Title");
        DocList.DataSource(xmlDoc);                             
        DocList.DataBind("lvtDoclist");                          
        DocList = null;

        makePageSelPage(NodeListLen);
        DisplayLineCnt_ezCab(NodeListLen);

        selFirstRow(Resultxml);
        listLoading(false);	// 20201211 조진호 로딩바 display:none
    } catch (e) { }
}

function GetRecordListXml() {
    var xmlpara = createXmlDom();
    var objNode, objChildNode;
    objNode = createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "USERID", UserID);
    createNodeAndInsertText(xmlpara, objNode, "TRANSFLAG", g_TransFlag);
    createNodeAndInsertText(xmlpara, objNode, "LISTFLAG", ListTypeFlag);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "ORDERBY", g_OrderBy);
    if(typeof(selSendStatusFlag) != "undefined" && selSendStatusFlag == "N"){
        createNodeAndInsertText(xmlpara, objNode, "SELSENDSTATUS", selSendStatusFlag);
    }
    
    /**
     *  g_RecSearchParamXml 사용자가 입력한 검색조건
     *  입력한 검색 조건을 XML에 추가
     */
    if (g_RecSearchParamXml != "")
    {
        var oSParam = loadXMLString(g_RecSearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);
    }
    objChildNode = createNodeAndAppandNode(xmlpara, objNode, objChildNode, "CABINETINFO");

    var i, len;
    if (g_SelCabXml != "")	
    {
        var CabListXml = loadXMLString(g_SelCabXml);

        var objCabs = SelectNodes(CabListXml, "CABINETID");
        len = objCabs.length; // 이거 주석 처리하면 안됨. for문에 len이 아닌 objCabs.length로 비교할 경우 자꾸 줄어들어서 에러 남 2019-02-27 임민석
        
        for (i = 0; i < len; i++) {
            try{
                objChildNode.appendChild(objCabs[i]);
            }
            catch (e) {
                objChildNode.appendChild(objCabs[0]);
            }
        }
    }

    g_szParamXml = getXmlString(xmlpara);

    g_CabListXmlhttp = createXMLHttpRequest();
    g_CabListXmlhttp.open("POST", "/ezApprovalG/getRecordList.do", true);
    g_CabListXmlhttp.onreadystatechange = onreadystatechange_RecList;
    g_CabListXmlhttp.send(xmlpara);
}

function InsertToRecListView(Resultxml) {
    try {
        ListViewData = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
        NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALDOCCOUNT");

        if (ListViewData == null) {
            return;
        }
        
        NodeListLen = 0;
        
        if (NodeList2 != null) {
            var cnt = getNodeText(NodeList2);
            if (cnt != "")
                NodeListLen = cnt;
            else
                NodeListLen = 0;
        }
        
        /* 2022-07-20 홍승비 - 기록물철등록부에서 기록물보기로 진입한 경우, 년도 확장 및 생산년도를 셀렉트 */
        if (typeof(isCabinetToRecordFirst) != "undefined" && isCabinetToRecordFirst == true && typeof(g_sFlag) != "undefined" && g_sFlag == "m02") {
        	var recYearSelect = $("#rec_year");
        	var todayYear = parseInt(new Date().getFullYear());
            cabProduceY = parseInt(cabProduceY);
            
            // 선택 가능 년도를 확장 (생산년도 ~ 현재년도)
            for (var i = todayYear; i >= cabProduceY; i--) {
            	// 년도 옵션이 셀렉트박스에 존재하지 않는 경우에만 아래쪽으로 어펜드 (최상단이 ALL, 위에서 아래쪽으로 년도가 감소하므로)
            	if (recYearSelect.find("option[value='" + i + "']").length <= 0) {
            		AddOption(rec_year, i, i);
            	}
            }
            
            recYearSelect.val(cabProduceY); // 기본 표출 년도를 생산년도로 셋팅 (onchange 이벤트는 동작하지 않음)
            isCabinetToRecordFirst = false; // 기록물보기 버튼 클릭으로 최초 진입했는지 판단하는 플래그 false로 변경 (이후의 GetRecordList ~ InsertToRecListView 부터는 생산년도 관련 코드가 동작하지 않도록)
        }

        var xmlDoc;
        if (CrossYN()) {
            var xmlLIST = createXmlDom();
            var nodeToImport = xmlLIST.importNode(ListViewData, true);
            xmlLIST.appendChild(nodeToImport);
            xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
        }
        else {
            xmlDoc = createXmlDom();
            xmlDoc.appendChild(ListViewData);
        }

        var preDocList = new ListView();
        preDocList.LoadFromID('DocList');
        var preSelectedRow = preDocList.GetSelectedRows();

        xmlDoc = insertSortInfoToHeader(g_HeaderInfoXml, xmlDoc);
        if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DocList");                               
        DocList.SetMulSelectable(true);                        
                                  
        DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");      
        DocList.SetRowOnClick("lvtDoclist_SelChange");           
        DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
        DocList.SetOrderbyCol("COLNAME");
        DocList.SetTitleIdx(0);                                 
        DocList.SetTitle("RecTitle");
        // 2023-03-20 한태훈 - 기록물 등록대장, 부서공유함 복수선택 체크박스 추가
        if (typeof(g_sFlag) != "undefined" && (g_sFlag == "m01" || g_sFlag == "docShare")) { DocList.SetCheckBoxFlag(true); }
        DocList.SetSecurityFlag(true);
        DocList.SetSecurityIdx(13);
        DocList.DataSource(xmlDoc);                             
        DocList.DataBind("lvtDoclist");

        if (typeof (cabinetAttachPage) != "undefined" && cabinetAttachPage) {
        	// 분리첨부 검색 페이지에서 의견 아이콘 삭제
        	$(".OpIcon").remove();
            $("#DocList_TH_OP").remove();
        }

        if (selRowChangeFlag && preSelectedRow.length > 0) {
            // 탭 이동 시 전 탭에서 선택된 row 선택되지 않도록 flag값 변경
            selRowChangeFlag = false;
            DocList.SetSelectedID(preSelectedRow[0].getAttribute('id'));
        }
        DocList = null;

        if (typeof diffPaging != 'undefined' && diffPaging == "attachDoc") {
            //orgmakePageSelPage(NodeListLen);
            totalPage = parseInt(NodeListLen / PageSize);
            
            // 2023-06-26 전인하 - 페이지네이션 오류 수정
            if ((NodeListLen % PageSize) != 0) {
                totalPage += 1;
            }
            makePageSelPageCA(NodeListLen);
        } else {
        	makePageSelPage(NodeListLen);
        }
        
        DisplayLineCnt_ezCab(NodeListLen);
        selFirstRow(Resultxml);
    } catch (e) {
    	console.log(e);
    }
}

function onreadystatechange_RecList() {
    var Resultxml;
    var iStatus;

    if (g_CabListXmlhttp != null) {
        if (g_CabListXmlhttp.readyState == 4 && g_CabListXmlhttp.status == 200) {
            if (typeof (CheckBtnSetRecRole) == "function")
                CheckBtnSetRecRole();
            Resultxml = g_CabListXmlhttp.responseXML;
            iStatus = g_CabListXmlhttp.status;

            switch (iStatus) {
                case 200:
                case 201:
                case 204:
                case 207:
                    if (getXmlString(Resultxml) == "" || getNodeText(GetChildNodes(Resultxml)) == "FALSE") {
                        OpenAlertUI(strLang555);
                        return null;
                    }

                    if (iStatus == 207) {
                        var nodeStatus = SelectSingleNode(Resultxml, "a:multistatus/a:response[a:status $ge$ 'HTTP/1.1 4']");
                        if (nodeStatus != null) {
                            OpenAlertUI(strLang555);
                            return null;
                        }
                    }
                    InsertToRecListView(Resultxml);
                    // 2023-06-15 전인하 - 전자결재G > 기록물대장 미리보기 - 초기 로딩이 끝난 뒤 미리보기가 열린 상태일 경우 미리보기 여는 분기 삽입
                    // 리스트 로딩보다 미리보기 여는 분기가 먼저 실행되는 것을 방지함
                    if (typeof previewInfo != 'undefined' && previewInfo != "OFF" && typeof cabinetPreviewItemFlagArr != 'undefined' && cabinetPreviewItemFlagArr.includes(g_sFlag)) {
                        PreviewRayerChange(pPreviewShow_HOW, 'Cabinet');
                    }
                    break;

                default:
                    OpenAlertUI(strLang555);
                    return null;
            }
            g_CabListXmlhttp = null;
        }
    }
}


function MoveRecord(pRecID, pSepAttNo, pNewCabID, pFlag) {
    var XmlHttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();	

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "RECORDID", pRecID);
    createNodeAndInsertText(xmlpara, objNode, "SEPATTACHNO", pSepAttNo);
    createNodeAndInsertText(xmlpara, objNode, "NEWCABID", pNewCabID);
    createNodeAndInsertText(xmlpara, objNode, "FLAG", pFlag);

    XmlHttp.open("POST", "/ezApprovalG/moveRecord.do", false);
    XmlHttp.send(xmlpara);

    if (XmlHttp != null && XmlHttp.readyState == 4) {
     	 if (XmlHttp.status == 200) {
     		return true;
     	 } else {
     		 return false;
     	 }
   }
}

function DisplayLineCnt_ezCab(NodeListLen) {
    var ListName = "";
    if (DocList_Flag == "RECORD") {
        if (ListTypeFlag == "10")
            ListName = strLang559;
        else if (ListTypeFlag == "11")
            ListName = strLang560;
        else
            ListName = strLang561;
    }
    else if (DocList_Flag == "CABINET") {
        if (ListTypeFlag == "9")
            ListName = strLang562;
        else if (ListTypeFlag == "10")
            ListName = strLang563;
        else
            ListName = strLang227;
    }

    
}

function GetHearderXml() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getLVHeaderInfo.do",
		data : {
			companyID : CompanyID,
			listFlag  : DocList_Flag,
			listType  : ListTypeFlag
		},
		success: function(xml){
			result = xml;
		},
		error : function() {
			OpenAlertUI(strLang573);
	        g_HeaderInfoXml = "";
		}
	});
	
    var rtnXml = loadXMLString(result);
    var dataNodes = GetChildNodes(rtnXml);

    if (getNodeText(dataNodes[0]) == "FALSE") {
        OpenAlertUI(strLang573);
        g_HeaderInfoXml = "";
    }
    else {
        g_HeaderInfoXml = rtnXml;
    }
}

function lvtDoclist_HeaderClick(pHeader) {
    if (DocList_Flag === "RECORD" && pHeader === "") {
        return;
    }

    if (OrderCell == pHeader) {
        if (OrderOption == "")
            OrderOption = "DESC";
        else
            OrderOption = "";
    }
    else {
        OrderCell = pHeader;
        OrderOption = "";
    }
        SortList(pHeader);
}

function SortList(szField) {
    if (g_SortField == szField)
    {
        g_SortType = GetToggledSotrType();
    }
    else {
        g_SortType = "ASC";
    }

    g_SortField = szField;
    g_OrderBy = "Order By " + g_SortField + " " + g_SortType;

    if (DocList_Flag == "CABINET") {
        GetCaninetList();
    } else if (DocList_Flag == "RECORD") {
        GetRecordList();
    } else if (DocList_Flag == "Delivery") {
    	idistbox_onclick();
    }
}

function GetToggledSotrType() {
    if (g_SortType == "ASC")
        return "DESC";
    else
        return "ASC";
}
var viewrechistory_cross_dialogArguments = new Array();
function btnViewRecHistory_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var para = new Array();
        para[0] = selRow[0].getAttribute("DATA6");
        para[1] = selRow[0].getAttribute("DATA8");
        var url = "/ezApprovalG/viewRecHistory.do";

        viewrechistory_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewRecHistory_Cross", GetOpenWindowfeature(1017, 480));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        OpenAlertUI(strLang577);
    }
}

var viewrecinfo_cross_dialogArguments = new Array();
function btnViewRecInfo_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var para = new Array();
        para[0] = selRow[0].getAttribute("DATA6");
        para[1] = selRow[0].getAttribute("DATA8");	

        var url = "/ezApprovalG/viewRecInfo.do";

        viewrecinfo_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewRecInfo_Cross", GetOpenWindowfeature(640, 562));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        OpenAlertUI(strLang577);
    }
}
var viewcabinfo_cross_dialogArguments = new Array();
function btnViewCabInfo_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var para = new Array();
        para[0] = selRow[0].getAttribute("DATA1");		
        para[1] = selRow[0].getAttribute("DATA2");	

        var url = "/ezApprovalG/viewCabInfo.do";
        viewcabinfo_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewCabInfo_Cross", GetOpenWindowfeature(640, 550));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        OpenAlertUI(strLang578);
    }
}

var viewcabhistory_cross_dialogArguments = new Array();
function btnViewCabHistory_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var para = new Array();
        para[0] = selRow[0].getAttribute("DATA2");	

        var url = "/ezApprovalG/viewCabHistory.do";

        viewcabhistory_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewCabHistory_Cross", GetOpenWindowfeature(970, 473));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        OpenAlertUI(strLang578);
    }
}

function btnViewContent_onclick() {
    ViewDoc_onclick();
}
var doclistview_cross_dialogArguments = new Array();
function DocListPrinter_onclick() {
    var para = new Array();
    para[0] = DocList_Flag;
    para[1] = DeptID;
    para[2] = ContainerID;
    para[3] = DelListYN;
    para[4] = condition;
    para[5] = UserID;
    para[6] = Init_Flag;
    para[7] = AdminYN;

    para[8] = ListTypeFlag;
    para[9] = g_szParamXml;
    para[10] = deptName;

    para[11] = NodeListLen;

    if (!NodeListLen) {
        OpenAlertUI("목록이 불러와진 후 시도해주세요.");
        return;
    }

    var url = "/ezApprovalG/docListView.do";

    doclistview_cross_dialogArguments[0] = para;

    var OpenWin = window.open(url, "DocListView_Cross", GetOpenWindowfeature(1395, 582));
    try { OpenWin.focus(); } catch (e) { }
}

function ISReceivedCab(pCabID) {
    var objCabInfoXml = GetCabinetClassInfo(pCabID);

    CabTransFlag = getNodeText(SelectSingleNode(objCabInfoXml, "CABTRANSFLAG"));
    TDetpCode = getNodeText(SelectSingleNode(objCabInfoXml, "TDEPTCODE"));

    if (CabTransFlag != "2") {
        return false;
    }
    else {
        if (TDetpCode == DeptID) {
            return true;
        }
        else {
            return false;
        }
    }
}

//START
function ViewDoc_onclick() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length > 0) {
        var selRow = tr[0];
        
        // 2023-09-05 기록물 등록대장 미리보기 - 배부대장 문서보기 분기처리 추가, 비공개문서에 대한 누락된 분기처리(전체관리자는 비공개문서 열람할 수 있음) 추가
        if (DocList_Flag == "RECORD" || DocList_Flag == "Delivery") {
        	
        	/* 2024-12-27 홍승비 - 기록물 배부대장 > 배부한 문서가 삭제된 경우 알러트를 표출하도록 수정 (회송 후 삭제 시 레코드까지 삭제되므로 대응 / 관리자단에서 삭제 시 레코드는 유지됨) */
        	if (DocList_Flag == "Delivery" && g_uFlag == "m03") {
        		if (!isDocExists(selRow.getAttribute("DATA1"), "APR") && !isDocExists(selRow.getAttribute("DATA1"), "END")) {
        			OpenAlertUI(strLangHSBDR01);
        			return;
        		}
        	}
        	
            var securityApprovalFlag = DocList_Flag == "RECORD" ? trim_Cross(selRow.getAttribute("DATA14")) : trim_Cross(selRow.getAttribute("DATA8"));
            if (securityApprovalFlag != "null" && securityApprovalFlag != "" && securityApprovalFlag >= GetTodayDate()) {
                if (CheckAprLine(selRow.getAttribute("DATA1")) == "TRUE" || GetUserRole() != "User" ) {
                    chk_Passwd(UserID, ViewDoc_onclick_Complete);
                } else {
                    OpenAlertUI(strLang580);
                    return "";
                }
            } else {
                ViewDoc_onclick_Complete("True");
            }  	 
        } else {
            ViewDoc_onclick_Complete("True");
        }           
    }
    else {
        OpenAlertUI(strLang584);
    }
}

function ViewDoc_onclick_Complete(Rtn) {
    if (Rtn == "False") {
        var pAlertContent = strLang581;
        OpenAlertUI(pAlertContent);
        return "";
    }
    else if (Rtn == "cancel") {
        var pAlertContent = strLang582;
        OpenAlertUI(pAlertContent);
        return "";
    }
    else if (Rtn == "True" || Rtn == "TRUE") {
        var DocList = new ListView();          
        DocList.LoadFromID("DocList");
        var tr = DocList.GetSelectedRows();
        if (tr.length > 0) {
            var selRow = tr[0];
            if (DocList_Flag == "RECORD") {
               // 2024-09-19 전인하 - 결재선에 존재하였던 유저의 경우 기록물대장에서 비공개문서라도 열람이 가능
               var checkAprLineFlag = CheckAprLine(trim_Cross(selRow.getAttribute("DATA1")));
               if (AdminYN != "TRUE" && (!g_bRecAdmin) && checkAprLineFlag !== "TRUE") {
                    if (!HasRecReadRight(trim_Cross(selRow.getAttribute("DATA6")), trim_Cross(selRow.getAttribute("DATA8")), UserID)) {
                        OpenAlertUI(strLang580);
                        return "";
                    }
                }
                if (selRow.getAttribute("DATA8") != "00") {
                    OpenAlertUI(strLang260);
                    return "";
                }
            }
        }

        if (trim_Cross(pURL) == "") {
            if (trim_Cross(DocID) == "") {
                OpenAlertUI(strLang260);
            } else if (g_uFlag == "m03" || g_uFlag == "m14") {  // 2023-09-25 전인하 - 배부대장 메뉴 flag값 전달
            	var pAlertContent = "배부문서는 최초접수시 생성되므로 배부받은 부서에서 접수를 하여야 열람할 수 있습니다.";
                OpenAlertUI(pAlertContent);
                return "";
            } else {
                var para2 = new Array();
                para2[0] = selRow.getAttribute("DATA6");
                para2[1] = selRow.getAttribute("DATA8");

                var url = "/ezApprovalG/contDocView_NoDoc.do?docID=" + encodeURI(DocID) + "&g_RecID=" + encodeURI(para2[0]) + "&g_SepAttNo=" + encodeURI(para2[1]);
                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;
                var left = 0;
                var top = 0;
                var wWidth = 600;
                var wHeigth = 300;
                var pleftpos, ptoppos;
                pleftpos = parseInt(width) - wWidth;
                ptoppos = parseInt(heigth) - wHeigth;

                left = pleftpos / 2;
                top = ptoppos / 2;

                window.open(url, strLang1135, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeigth + ",width=" + wWidth + ",top=" + top + ",left = " + left);
            }
        }
        else {
            var para = new Array();
            DocID = selRow.getAttribute("DATA1");
            pURL = selRow.getAttribute("DATA2");
            
            var tempUrl = pURL;

            var openLocation = "";
            
            if (tempUrl.substr(tempUrl.length - 4, tempUrl.length).toLowerCase() == ".ezd") {
            	tempUrl = tempUrl.substr(0, tempUrl.length - 4);
            }
            
            if (tempUrl.substr(tempUrl.length - 3, tempUrl.length).toLowerCase() == "hwp") {
            	if(useWebHWP == "NO") {
	            	if (isIE()) {
	                	if (g_uFlag == "m03" || g_uFlag == "m14") {  // 2023-09-25 전인하 - 배부대장 메뉴 flag값 전달
	                		openLocation = "/ezApprovalG/ezViewEnd_HWP.do?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=&orgDocID=";
	                	} else {
	                		openLocation = "/ezApprovalG/ezViewEnd_HWP.do?docID=" + escape(DocID) + "&docHref=" + escape(pURL) + "&formID=" + escape(selRow.getAttribute("DATA5")) + "&orgDocID=";
	                	}
	                } else {
	                	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	                	alert(pAlertContent);
	                    
	                    return;
	                }
            	} else {
            		if (g_uFlag == "m03" || g_uFlag == "m14") { /* 2023-07-13 민지수 - 배부대장 메뉴 flag값 전달 */
                		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=&orgDocID=&uFlag=" + g_uFlag;
                	} else {
                		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do?docID=" + escape(DocID) + "&docHref=" + escape(pURL) + "&formID=" + escape(selRow.getAttribute("DATA5")) + "&orgDocID=";
                	}
            	}
            } else {
	            if (g_uFlag == "m03" || g_uFlag == "m14") { // 2023-09-25 전인하 - 배부대장 메뉴 flag값 전달
	                openLocation = "/ezApprovalG/contDocView.do";
	                openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=&orgDocID=&uFlag=" + g_uFlag;
	            } else {
	                openLocation = "/ezApprovalG/contDocView.do";
	                openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(selRow.getAttribute("DATA5")) + "&orgDocID=";
	            }
             }
	            openwindow(openLocation, "cabinet", 880, 570);
         }
     }
}
//END
function GetTodayDate() {
    var objDate = new Date();
    var y = String(objDate.getFullYear());
    var m = String(objDate.getMonth() + 1);
    var d = String(objDate.getDate());
    m = "00".substring(0, 2 - m.length) + m;
    d = "00".substring(0, 2 - d.length) + d;
    return y + "-" + m + "-" + d;
}

//START
var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd(pUserID, CompleteFunction) {
    var parameter = pUserID;
    ezchkpasswd_cross_dialogArguments[0] = parameter;
    
    if (CompleteFunction != undefined) {
    	ezchkpasswd_cross_dialogArguments[1] = CompleteFunction;
    } else {
    	ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;
    }

    ezchkpasswd_cross_dialogArguments[2] = true;
    
    var url = "/ezApprovalG/ezchkPasswd.do?mode=SEC";
    var OpenWin = window.open(url, "ezchkPasswd_Cross", GetOpenWindowfeature(460, 225)); // 기록물대장 리스트에서 보안결재문서 접근
    try { OpenWin.focus(); } catch (e) { }
}
//END

function CheckAprLine(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/checkAprLineUser.do",
		data : {
			companyID : CompanyID,
			docID     : pDocID,
			mode  	  : "END",
			userID    : UserID
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    var dataNodes = GetChildNodes(loadXMLString(result));
    return getNodeText(dataNodes[0]);

}

function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;

            pleftpos = parseInt(width) - 967;
            heigth = parseInt(heigth) - 30;
            if (CrossYN())
                heigth = parseInt(heigth) - 25;

            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
                heigth = parseInt(heigth) - 40;
            width = parseInt(width) - pleftpos;
            left = pleftpos / 2;
        }
        else {
            heigth = parseInt(heigth) - 30;
            if (CrossYN())
                heigth = parseInt(heigth) - 25;

            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
                heigth = parseInt(heigth) - 40;
            width = parseInt(width) - 10;
        }

        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

    }
    catch (e) {
        alert("openwindow :: " + e.description);
    }
}

function OpenWin(wfileLocation, wName, wWidth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        var pleftpos, ptoppos;
        pleftpos = parseInt(width) - wWidth;
        ptoppos = parseInt(heigth) - wHeigth;

        left = pleftpos / 2;
        top = ptoppos / 2;

        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeigth + ",width=" + wWidth + ",top=" + top + ",left = " + left);

    } catch (e) {
        OpenAlertUI("openwindow :: " + e.description);
    }
}

function HasRecReadRight(pRecID, pSepAttNo, pUserID) {
    if (GetUserRecRight(pRecID, pSepAttNo, pUserID) != "0")
        return true;
    else
        return false;
}

function GetUserRecRight(pRecID, pSepAttNo, pUserID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getUserRecRight.do",
		data : {
			companyID : CompanyID,
			recID     : pRecID,
			sepAttNo  : pSepAttNo,
			userID    : pUserID
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    var dataNodes = GetChildNodes(loadXMLString(result));
    var rtn = getNodeText(dataNodes[0]);

    if (rtn == "FALSE") {
        OpenAlertUI(strLang586);
        return "0";
    }
    else {
        return rtn;
    }
}

var searchrec_cross_dialogArguments = new Array();
function btnSearchRec_onclick(opnOption,opentype) {
    var para = new Array();
    para[0] = AdminYN;	
    para[1] = DeptID;		
    para[2] = deptName;

    if (typeof (opnOption) == "undefined") opnOption = "0";
    para[3] = opnOption;	
    if(opnOption == "0") {
    	para[4] = g_sFlag;
    	para[5] = szRoleInfo;
    }

    var url = "/ezApprovalG/searchRec.do";

    if (CrossYN()) {
        searchrec_cross_dialogArguments[0] = para;
        searchrec_cross_dialogArguments[1] = btnSearchRec_onclick_Complete;

        if (opentype == "OPEN") {
        	searchrec_cross_dialogArguments[2] = true;
            var OpenWin = window.open(url, "SearchRec_Cross", GetOpenWindowfeature(800, 460));
            try { OpenWin.focus(); } catch (e) { }
        }
        else
            //DivPopUpShow(470, 350, url);
        	DivPopUpShow(800, 460, url);
    }
    else {
        var feature;
        if (opnOption == "1") {
            feature = "dialogWidth:470px;dialogHeight:420px;scroll:no;resizable:no;status:no;help:no;edge:sunken";
            feature = feature + GetShowModalPosition(623, 420);
        }
        else {
            feature = "dialogWidth:470px;dialogHeight:410px;scroll:no;resizable:no;status:no;help:no;edge:sunken";
            feature = feature + GetShowModalPosition(623, 410);
        }
        var rtnVal = window.showModalDialog(url, para, feature);

        if (rtnVal[0] == "TRUE") {
            curpage = 1;

            g_RecSearchParamXml = rtnVal[1];
            GetRecordList();
        }
    }
}
/**
 * [문서첨부]->[검색]
 * rtnVal[0] : TRUE OR FALSE
 * rtnVal[1] : 검색 조건(XML)
 * */
function btnSearchRec_onclick_Complete(rtnVal) {
    DivPopUpHidden();
    if (rtnVal[0] == "TRUE") {
        curpage = 1;

        g_isSearching = true;
        g_RecSearchParamXml = rtnVal[1];
        GetRecordList();
    }
    if (document.getElementById("rec_year") != null) {
        $('#rec_year').val("ALL");
        /*$('#rec_year').selectmenu('refresh');*/
    }
    if (document.getElementById("rec_underDept") != null) {
        $('#rec_underDept').val("default");
    }

    if (document.getElementById("selSendStatus") != null) {
        $('#selSendStatus').val("");
    }
}

// 열람권한 멀티지정 START 
// 2020/11/13 박기범
var SetRecUserRolePara = new Array();
function btnSetRecUserRole_onclick() {
    var DocList = new ListView();  
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    var selDocIDs 	= [];
    var pRecIDs		= [];
    var pSepAttNos	= [];

    if (selRow.length > 0) {
    	var strSepAttDocs = "";
    	var strSelDocs = "";
        var arrSelDocs = [];
    	
    	for (var i = 0; i < selRow.length; i++) {
    		// 분리첨부등록, DocID여부 체크
    		const sepAttTF = (DocList_Flag == "RECORD" && selRow[i].getAttribute("DATA8") != "00");
    		const docIdTF = (selRow[i].getAttribute("DATA1") == "");
    		
    		if (sepAttTF || docIdTF) {
    			strSepAttDocs += selRow[i].childNodes.item(4).getAttribute("title") + ", ";
    		} else {
    			selDocIDs	.push(selRow[i].getAttribute("DATA1"));
    			pRecIDs		.push(selRow[i].getAttribute("DATA6"));
    			pSepAttNos	.push(selRow[i].getAttribute("DATA8"));
    			// 멀티지정일 경우 일괄 설정할건지 출력하는 허가창 출력 로직
    			var rtnXml = GetRecViewerInfo(selRow[i].getAttribute("DATA6"), selRow[i].getAttribute("DATA8"));
    			
    			if (SelectSingleNode(SelectSingleNode(rtnXml.documentElement, "LISTVIEWDATA"), "ROWS") != null) {
                    var tempDocNo = selRow[i].querySelector('[headername="DISPREGISTERNO"]');
                    if(!!tempDocNo) {
                        arrSelDocs.push(tempDocNo.innerText);
                    }
    			}
    		}
    		
    	}
    	
    	if (strSepAttDocs != "") {
    		strSepAttDocs = strSepAttDocs.substring(0,strSepAttDocs.length - 2);
    		OpenAlertUI(strSepAttDocs + " : " + strLang590);
    		return;
    	}
    	
    	SetRecUserRolePara[0] = pRecIDs;	
    	SetRecUserRolePara[1] = pSepAttNos;	
    	SetRecUserRolePara[2] = DeptID;
        var length = arrSelDocs.length;
    	if (selRow.length > 1 && length > 0){
            for (var j = 0; j < length; j++) {
                strSelDocs += arrSelDocs[j] + ", ";
                if(j === 1 && length > 2) strSelDocs += "<br>";
                if(j === 3) break;
            }
            if(length > 4) strSelDocs += " ...";
    		strSelDocs += "<br>" + strLangPgb01;
    		OpenInformationUI(strSelDocs, btnSetRecUserRole_onclick_Complete);
    	} else {
    		SetRecUserRole(SetRecUserRolePara);
    	}
    } else {
        OpenAlertUI(strLang584);
        return;
    }
    
}

var setrecuserrole_cross_dialogArguments = new Array();
function SetRecUserRole(SetRecUserRolePara) {
    var url = "/ezApprovalG/setRecUserRole.do";

    setrecuserrole_cross_dialogArguments[0] = SetRecUserRolePara;

    var OpenWin = window.open(url, "SetRecUserRole_Cross", GetOpenWindowfeature(909, 450));
    try { OpenWin.focus(); } catch (e) { }
}

// 일괄 설정 허가창 출력용 - 열람권한 설정된 유저 호출용 함수
function GetRecViewerInfo(pRecID, pSepAttNo) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS");
    createNodeAndInsertText(xmlpara, objNode, "RECID", pRecID);
    createNodeAndInsertText(xmlpara, objNode, "SEPATTNO", pSepAttNo);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", UserLang);

    xmlhttp.open("POST", "/ezApprovalG/getRecViewerInfo.do", false);
    xmlhttp.send(xmlpara);
    return  xmlhttp.responseXML;
}

function btnSetRecUserRole_onclick_Complete(Ans) {
    DivPopUpHidden();
    if (Ans) {
    	SetRecUserRole(SetRecUserRolePara);
    }
}
// 열람권한 멀티지정 (박기범) END

function SaveToRecReadHist() {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", DocID);
    createNodeAndInsertText(xmlpara, objNode, "USERID", arr_userinfo[1]);
    createNodeAndInsertText(xmlpara, objNode, "USERNAME", arr_userinfo[11]);
    createNodeAndInsertText(xmlpara, objNode, "USERTITLE", arr_userinfo[13]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[15]);
    createNodeAndInsertText(xmlpara, objNode, "USERNAME2", arr_userinfo[12]);
    createNodeAndInsertText(xmlpara, objNode, "USERTITLE2", arr_userinfo[14]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME2", arr_userinfo[16]);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_SaveRecReadHist.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);

    if (getNodeText(dataNodes[0]) != "TRUE") {

    }
}


var g_progresswin = null;	
function showProgress() {
}

function hideProgress() {
}

function Search_Onclick(pInitFlag) {
    if (DocList_Flag == "RECORD") {

    }
    else if (DocList_Flag == "CABINET") {
        SearchCabinet(pInitFlag);
    }
}
var searchcab_cross_dialogArguments = new Array();
function SearchCabinet(pInitFlag) {
    var para = new Array();
    para[0] = AdminYN;
    para[1] = DeptID;
    para[2] = deptName;
    para[3] = pInitFlag;

    var url = "/ezApprovalG/searchCab.do";

    searchcab_cross_dialogArguments[0] = para;
    searchcab_cross_dialogArguments[1] = SearchCabinet_Complete;

    if (pInitFlag == "0") {
        var OpenWin = window.open(url, "SearchCab_Cross", GetOpenWindowfeature(880, 500));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        var OpenWin = window.open(url, "SearchCab_Cross", GetOpenWindowfeature(470, 395));
        try { OpenWin.focus(); } catch (e) { }
    }
}


function SearchCabinet_Complete(rtnVal) {
    if (rtnVal[0] == "TRUE") {
    	//검색 시 리스트가 1페이지로 돌아가지 않는 오류 개선
    	curpage = 1;
        g_CabSearchParamXml = rtnVal[1];
        GetCaninetList();
    }

    if (document.getElementById("cab_year") != null) {
        $('#cab_year').val("ALL");
        /*$('#cab_year').selectmenu('refresh');*/
    }
}


function openergetDocInfo() {
	listLoading(true); //20201211 조진호 - 리스트 출력 시 시간이 오래 걸릴 수 있어 로딩바 추가
    if (DocList_Flag == "CABINET") {
        GetCaninetList();
    }
    else if (DocList_Flag == "RECORD") {
        // 선택한 row 유지를 위한 Flag 설정
        selRowChangeFlag = true;
        GetRecordList();
        listLoading(false);
    }
    else {
        GetDocDeliveryList(g_DeliverySearchParamXml);
    }
}


var BlockSize = 10;
var totalPage = "";
function td_Create1(strtext) {
    document.getElementById("tblPageRayer").innerHTML = strtext;
}
function makePageSelPage(pTotalCnt) {
    var strtext;
    var PagingHTML = "";
    document.getElementById("tblPageRayer").innerHTML = "";
    if (pTotalCnt != undefined) {
    	if (g_isSearching) {
    		var startDate = g_searchDate.startDate;
    		var endDate = g_searchDate.endDate;
    		
    		period = getDatePeriod(UserLang, startDate.getFullYear(), (startDate.getMonth() + 1), startDate.getDate(), endDate.getFullYear(), (endDate.getMonth() + 1), endDate.getDate());
    	} else if (GetSelectVal("rec_year") == "ALL" && GetSelectVal("cab_year") == "ALL" && GetSelectVal("del_year") == "ALL") {
            var nowyear = new Date().getFullYear();
            var nowmonth = new Date().getMonth() + 1;
            var nowday = new Date().getDate();
            period = getDatePeriod(UserLang, (nowyear - 1), nowmonth, nowday, nowyear, nowmonth, nowday);
        }
        else {
            if (GetSelectVal("rec_year") != "ALL"){
            	period = getDatePeriod(UserLang, document.getElementById("rec_year").value, 1, 1, document.getElementById("rec_year").value, 12, 31);
            	//period = document.getElementById("rec_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("rec_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
            } else if (GetSelectVal("cab_year") != "ALL") {
            	period = getDatePeriod(UserLang, document.getElementById("cab_year").value, 1, 1, document.getElementById("cab_year").value, 12, 31);
            	//period = document.getElementById("cab_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("cab_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
            } else {
            	period = getDatePeriod(UserLang, document.getElementById("del_year").value, 1, 1, document.getElementById("del_year").value, 12, 31);
            	//period = document.getElementById("del_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("del_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
            	
            }
        }

        if (!isPeriodYear)
            document.getElementById("TitleInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color' style='font-weight:bold;'>" + pTotalCnt + "</span>";
        else
            document.getElementById("TitleInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color' style='font-weight:bold;'>" + pTotalCnt + "</span>&nbsp;/ " + period;

        if (g_sFlag === "UNTREATED") {
            parent.frames["left"].document.getElementById("COUNTUNTREATED").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
        }
    }

    strtext = "<div class='pagenavi'>";

    PagingHTML += strtext;
    totalPage = Math.ceil(new Number(pTotalCnt / PageSize));
    var pageNum = curpage;
    if (totalPage > 1 && pageNum != 1) {
        strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'>";
        strtext = strtext + "</span>";
        PagingHTML += strtext;
    }
    else {
        strtext = "<span class='btnimg first disabled'><a >";
        strtext = strtext + "</a></span>";
        PagingHTML += strtext;
    }
    if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
            strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'>";
            strtext = strtext + "</span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg prev disabled'>";
            strtext = strtext + "</span>";
            PagingHTML += strtext;
        }
    }
    else {
        strtext = "<span class='btnimg prev disabled'>";
        strtext = strtext + "</span>";
        PagingHTML += strtext;
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
    
    if(totalPage == "0") {
    	MaxNum = 1;
    }
    for (i = startNum; i <= MaxNum; i++) {
        if (i == pageNum) {
            strtext = "<span class='on'>" + i + "</span>"
            PagingHTML += strtext;
        }
        else {
            strtext = "<span onclick = 'goToPageByNum(" + i + ")'>" + i + "</span>"
            PagingHTML += strtext;
        }
    }
    if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
            strtext = "<span class='btnimg next' onclick='return selafterBlock()'>";
            strtext = strtext + "</span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg next disabled'>";
            strtext = strtext + "</span>";

            PagingHTML += strtext;
        }
    }
    else {
        strtext = "<span class='btnimg next disabled'>";
        strtext = strtext + "</span>";
        PagingHTML += strtext;
    }
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'>";
        strtext = strtext + "</span>";
        PagingHTML += strtext;
    }
    else {
        strtext = "<span class='btnimg last disabled'>";
        strtext = strtext + "</span>";
        PagingHTML += strtext;
    }
    PagingHTML += "</div>";
    
    listLoading(false);	// 20201211 조진호 로딩바 display:none
    
    td_Create1(PagingHTML);
}
function goToPageByNum(Value) {
    curpage = Value;
    pageNum = curpage;
    makePageSelPage(NodeListLen);
    openergetDocInfo();
}
function selbeforeBlock() {
    var pageNum = curpage;
    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selbeforeBlock_one() {
    var pageNum = curpage;
    if (parseInt(pageNum - 1) > 0)
        goToPageByNum(parseInt(pageNum - 1));
    else
        return;
}
function selafterBlock() {
    var pageNum = curpage;
    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock_one() {
    var pageNum = curpage;
    if (parseInt(pageNum + 1) <= totalPage)
        goToPageByNum(parseInt(pageNum + 1));
    else
        return;
}

function goToPage(page) {
    if (page == "front") {
        if (parseInt(curpage) - 1 < 1)
            return;
        curpage = curpage - 1;
        openergetDocInfo();
    }
    else if (page == "next") {
        if (parseInt(curpage) + 1 > parseInt(totalPage))
            return;
        curpage = curpage + 1;
        openergetDocInfo();
    }
}


function insertSortInfoToHeader(header, listData) {
    try {
    	if (header != "" && getXmlString(header) != "" && getXmlString(header) != "<LISTINFO/>") {
            var oXml = header;
            var nodesCell = SelectNodes(oXml, "LISTINFO/CELL");
            var header = SelectNodes(listData, "LISTVIEWDATA/HEADERS/HEADER");
            var heaerLength = header.length;

            var objNode;
            for (var i = 0; i < heaerLength; i++) {             

                for (var j = 0; j < nodesCell.length; j++) {
                    var sn = getNodeText(SelectSingleNode(nodesCell[j], "SN"));
                    var colAlias = getNodeText(SelectSingleNode(nodesCell[j], "COLALIAS"));
                    var colname = getNodeText(SelectSingleNode(nodesCell[j], "COLNAME"));
                    if (i == j && colname != "") {                
                    	if (GetElementsByTagName(header[i], "COLNAME").length > 0) {
                            setNodeText(GetElementsByTagName(header[i], "COLNAME")[0], colAlias);
                        }
                        else {
                            createNodeAndAppandNodeText(listData, header[i], objNode, "COLNAME", colAlias);
                        }
                        j = nodesCell.length;
                    }
                }

            }
        }
        return listData;

    } catch (e) { }
}

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, "");
}

var searchdelivery_cross_dialogArguments = new Array();
function btnSearchDelivery_onclick(opnOption) {
    var para = new Array();
    para[0] = AdminYN;
    para[1] = DeptID;
    para[2] = deptName;
    para[3] = opnOption;

    if (typeof (opnOption) == "undefined") opnOption = "0";
    para[3] = opnOption;

    searchdelivery_cross_dialogArguments[0] = para;
    searchdelivery_cross_dialogArguments[1] = btnSearchDelivery_onclick_Complete;

    var url = "/ezApprovalG/searchDelivery.do";

    var OpenWin = window.open(url, "SearchDelivery_Cross", GetOpenWindowfeature(460, 470));
    try { OpenWin.focus(); } catch (e) { }
}

function btnSearchDelivery_onclick_Complete(rtnVal) {
    if (rtnVal[0] == "TRUE") {
        curpage = 1;
        
        g_isSearching = true;
        g_DeliverySearchParamXml = rtnVal[1];
        GetDocDeliveryList(g_DeliverySearchParamXml);
    }
}

function orgmakePageSelPage(pTotalCnt) {
    totalPage = parseInt(pTotalCnt / PageSize);
    var modCnt = pTotalCnt - (totalPage * PageSize);
    if (modCnt > 0) totalPage = totalPage + 1;

    td_pTotalCount.textContent = totalPage;
    txt_PageInputNum.value = curpage;
    
    listLoading(false);	// 20201211 조진호 로딩바 display:none
    return;
}

function getEngMonth(month) {
	var engMonthStr = "";
	
	switch(Number(month)) {
		case 1 :
			engMonthStr = "Jan";
			break;
		case 2 :
			engMonthStr = "Feb";
			break;
		case 3 :
			engMonthStr = "Mar";
			break;
		case 4 :
			engMonthStr = "Apr";
			break;
		case 5 :
			engMonthStr = "May";
			break;
		case 6 :
			engMonthStr = "Jun";
			break;
		case 7 :
			engMonthStr = "Jul";
			break;
		case 8 :
			engMonthStr = "Aug";
			break;
		case 9 :
			engMonthStr = "Sep";
			break;
		case 10 :
			engMonthStr = "Oct";
			break;
		case 11 :
			engMonthStr = "Nov";
			break;
		case 12 :
			engMonthStr = "Dec";
			break;
	}
	
	return engMonthStr;
}

function getDatePeriod(userLang, startYear, startMonth, startDate, endYear, endMonth, endDate) {
	return getDateStrByLang(userLang, startYear, startMonth, startDate) + " ~ " + getDateStrByLang(userLang, endYear, endMonth, endDate);
}

function getDateStrByLang(userLang, year, month, date) {
	if (userLang == "2") {
		return getEngMonth(month) + " " + date + ", " + year;
	} else {
		return year + strLang1028 + " " + month + strLang1029 + " " + date + strLang1030
	}
}

/* 2022-07-20 홍승비 - 선택한 기록물철의 생산년도를 리턴하는 AJAX 함수 추가 */
function getProduceYear(cabinetClassNo) {
	var resY = new Date().getFullYear();
	
	$.ajax({
		type : "GET",
		async : false,
		url : "/ezApprovalG/getCabProduceYear.do",
		data : {
				companyID : CompanyID,
				cabinetClassNo : cabinetClassNo
		},
		success : function(result) {
			resY = result;
		}
	});
	
	return resY;
}

// 2023-09-25 전인하 - 전자결재G > 배부대장 미리보기 > 문서 진행/완료여부 조회
function getLineMode(pDocID) {
    var rtnVal = "";
    $.ajax({
        type : "POST",
        dataType : "text",
        async : false,
        url : "/ezApprovalG/getLineMode.do",
        data : {
                docID : pDocID
                },
        success: function(xml) {
            rtnVal = xml;
        }        			
    });
    return rtnVal;
}

/* 2024-12-27 홍승비 - 현재 선택한 문서의 docID로 문서정보 레코드가 존재하는지 확인하는 AJAX 함수 추가 */
function isDocExists(pDocID, pMode) {
    var rtnVal = false;
    
    try {
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/getDocData.do",
			data : {
				docID : pDocID,
				mode : pMode,
				sel : "ALL"
			},
			success: function(xml) {
				var docXml = loadXMLString(xml);
				
				if (SelectSingleNodeValueNew(docXml, "DATA/DOCID").trim() != "") {
					rtnVal = true;
				}
			}
		});
	} catch (e) {
		console.error(e);
	}
    
    return rtnVal;
}