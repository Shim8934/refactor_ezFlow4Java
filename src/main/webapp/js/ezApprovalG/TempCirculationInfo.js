/**
 * 결재정보 회람 즐겨찾기 관련
 */
var pFormIDCC = "ZZZZZZZZ";
var temp_CheckAprDeptTempletSN;
function btn_AprDeptTempletDelCC_onclick() {
    try {
        var p_CheckAprDeptTempletSN;
        var pAPRTemplist = new ListView();
        pAPRTemplist.LoadFromID("lvRecSaveListCC");
        var ListViewLen = pAPRTemplist.GetSelectedRows();

        if (ListViewLen.length < 1) {
            var pAlertContent = linealt18;
            OpenAlertUI(pAlertContent);
            return;
        }

        p_CheckAprDeptTempletSN = ListViewLen[0].getAttribute("DATA1");

        if (p_CheckAprDeptTempletSN == "") {
            var pAlertContent = linealt15;
            OpenAlertUI(pAlertContent);
            return;
        }
        temp_CheckAprDeptTempletSN;
        temp_CheckAprDeptTempletSN = p_CheckAprDeptTempletSN;
//        var pInformationContent = linealt16;
        var pInformationContent = strLangPJG01;
        var Ans = OpenInformationUI(pInformationContent, btn_AprDeptTempletDelCC_onclick_Complete);
        if (Ans) {
            DelAprDeptTempletListCC(pUserID, pFormIDCC, p_CheckAprDeptTempletSN);
        }
    } catch (e) {
        alert("AprGongRamLine_Cross_btn_AprDeptTempletDelCC_onclick::" + e.description);
    }
}

function btn_AprDeptTempletDelCC_onclick_Complete(rtn) {
	DivPopUpHidden();
    if (rtn == "" || rtn == undefined)
        return;
    DelAprDeptTempletListCC(pUserID, pFormIDCC, temp_CheckAprDeptTempletSN);
}
function DelAprDeptTempletListCC(pUserID, pFormIDCC, p_SelAprDeptTempletSN) {
    try {
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/delAprLineTempletList.do",
    		data : {
    				userID 	 : pUserID,
    				formID   : pFormIDCC,
    				aprLineSN: p_SelAprDeptTempletSN
    				},
    		success: function(result){
    			GetReceptTempletListCC();
    		},
    		error : function() {
    			var parameter = strLang163 + "<br> " + strLang164;
                OpenAlertUI(parameter);
    		}
    	});
    } catch (e) {
        alert("AprGongRamLine_Cross_DelAprDeptTempletList::" + e.description);
    }
}
function btn_AprDeptTempletAddCC_onclick() {
    try {
        var p_CheckAprDeptTempletSN;
        var pAPRTemplist = new ListView();
        pAPRTemplist.LoadFromID("lvRecSaveListCC");
        var ListViewLen = pAPRTemplist.GetSelectedRows();

        if (ListViewLen.length < 1) {
            return;
        }

        p_CheckAprDeptTempletSN = GetAttribute(ListViewLen[0], "DATA1");

        if (p_CheckAprDeptTempletSN == "") {
            var pAlertContent = linealt14;
            OpenAlertUI(pAlertContent);
        }
        else {
            AddToAprDeptFromAprDeptTempletCC(p_CheckAprDeptTempletSN);
            pAprDeptTempletUseFlag = false;
        }
    } catch (e) {
        alert("AprGongRamLine_Cross_btn_AprDeptTempletAdd_onclick::" + e.description);
    }
}
function AddToAprDeptFromAprDeptTempletCC(p_CheckAprDeptTempletSN) {
    try {
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/aprLineTempletListInfo.do",
    		data : {
    				userID 	 : pUserID,
    				formID   : pFormIDCC,
    				aprLineSN: p_CheckAprDeptTempletSN
    				},
    		success: function(xml){
    			result = loadXMLString(xml);
    		}        			
    	});
    	
        SetGongRamList(result);
    } catch (e) {
        alert("AprGongRamLine_Cross_AddToAprDeptFromAprDeptTemplet::" + e.description);
    }
}
/**
 * 사용하는 곳 전부 적어두기.
 * 1. 전자결재 일반 / 회람 즐겨찾기 -> 적용 -> '회람자 리스트' 출력
 * */
function SetGongRamList(pstrXML) {
    try {
        var listnodes = SelectNodes(pstrXML, "LISTVIEWDATA/ROWS/ROW");

        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("pAPRLINE");
        var objRows = pAPRLINE.GetDataRows();

        if (GetAttribute(objRows[0], "id") == "pAPRLINE_TR_noItems") {
            pAPRLINE.DeleteRow("pAPRLINE_TR_noItems");
        }
        
        //2018-07-05 이효진
        var listnodes = SelectNodes(pstrXML, "LISTVIEWDATA/ROWS/ROW");
        var strHeader = "<HEADERS>";
        strHeader += "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
        strHeader += "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
        strHeader += "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        strHeader += "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
        strHeader += "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>120</WIDTH></HEADER>";
        strHeader += "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>70</WIDTH></HEADER>";
        strHeader += "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>140</WIDTH></HEADER>";
        strHeader += "</HEADERS>";
        
        var strRows = "<ROWS>"; 
        
        var i = 1;
        /* 2024-05-10 양지혜 - 전자결재 > 결재정보 > 퇴직자 포함된 즐겨찾기 적용 시 제외 */
        var RetireList = [];
        document.querySelectorAll('[id^="lvRecSaveDetailCC_TR_"]').forEach(function(element) {
            if (element.getAttribute('RETIRECHK') == "Y") {
                RetireList.push(element.querySelector("td:nth-child(3)").textContent)
            }
        });
        var sn = listnodes.length-RetireList.length;
        for (var cnt = listnodes.length-1; cnt >= 0; cnt-- ) {
        	var preDeptName = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
            var preDeptJobTitle = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
            var preDeptName1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
            var preDeptName2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
            var preWriterName1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[2])[0], "VALUE");
            var preWriterName2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[2])[0], "VALUE");
            var preDeptJobTitle1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
            var preDeptJobTitle2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
            var preDeptID = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[8], "DATA8");
            var preUserID = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[5], "DATA5");
            var RetireChk = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[10], "RETIRECHK");

            if (RetireChk == "N") {
                strRows += "<ROW>";
                strRows += "<CELL>";
                strRows += "<VALUE>" + sn + "</VALUE>";
                strRows += "<DATA1>" + "" + "</DATA1>";
                strRows += "<DATA2>" + "" + "</DATA2>";
                strRows += "<DATA3>" + pDocID + "</DATA3>";
                strRows += "<DATA4>" + preUserID + "</DATA4>";
                strRows += "<DATA5>" + "N" + "</DATA5>";
                strRows += "<DATA6>" + preDeptID + "</DATA6>";
                strRows += "<DATA7>" + "" + "</DATA7>";
                strRows += "<DATA8>" + "N" + "</DATA8>";
                strRows += "<DATA9>" + "N" + "</DATA9>";
                strRows += "<DATA10>7001388</DATA10>";
                strRows += "<DATA11>015</DATA11>";
                strRows += "<DATA12>001</DATA12>";
                strRows += "<DATA13>" + MakeXMLString(preWriterName1) + "</DATA13>";
                strRows += "<DATA14>" + MakeXMLString(preWriterName2) + "</DATA14>";
                strRows += "<DATA15>" + MakeXMLString(preDeptName1) + "</DATA15>";
                strRows += "<DATA16>" + MakeXMLString(preDeptName2) + "</DATA16>";
                strRows += "<DATA17>" + MakeXMLString(preDeptJobTitle1) + "</DATA17>";
                strRows += "<DATA18>" + MakeXMLString(preDeptJobTitle2) + "</DATA18>";
                strRows += "</CELL><CELL>";
                strRows += "<VALUE>" + MakeXMLString(preWriterName1) + "</VALUE>";
                strRows += "</CELL><CELL>";
                strRows += "<VALUE>" + MakeXMLString(preDeptJobTitle) + "</VALUE>";
                strRows += "</CELL><CELL>";
                strRows += "<VALUE>" + MakeXMLString(preDeptName) + "</VALUE>";
                strRows += "</CELL><CELL>";
                
                /* 2024-12-04 홍승비 - 전자결재G > 공람자 즐겨찾기 적용 > 회람 및 공람 메세지 분기처리 추가 */
                if (approvalFlag == "G") {
                	strRows += "<VALUE>" + strLangDocState15 + "</VALUE>";
				} else {
					strRows += "<VALUE>" + strLangAprType17 + "</VALUE>";
				}
                
                strRows += "</CELL><CELL>";
                strRows += "<VALUE>" + strLang72 + "</VALUE>";
                strRows += "</CELL><CELL><VALUE></VALUE></CELL></ROW>";
                sn--;
            }
            i++;
        }
        
        strRows += "</ROWS>";
        
        pparsingXML = "<LISTVIEWDATA>" + strHeader + strRows + "</LISTVIEWDATA>";
        objXML = loadXMLString(pparsingXML);
        
        document.getElementById("APRLINECC").innerHTML = "";
        
        var pAPRLINE = new ListView();
        pAPRLINE.SetID("pAPRLINE");
        pAPRLINE.SetMulSelectable(false);
        pAPRLINE.SetRowOnDblClick("AprlineDel_onclickCC");
        pAPRLINE.SetSelectFlag(false);
        pAPRLINE.SetHeightFree(true);
        pAPRLINE.DataSource(objXML);
        pAPRLINE.DataBind("APRLINECC");

        if (RetireList.length > 0) {
            alert("[" + RetireList.join(",") + "] " + strLangRetiree01);
        }

        /*for (var cnt = listnodes.length-1; cnt >= 0; cnt-- ) {

            var DuplicateFlag = false;
            for (i = 0; i < objRows.length; i++) {
                if (GetAttribute(objRows[i], "DATA4").toLowerCase() == getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[5], "DATA5").toLowerCase() && GetAttribute(objRows[i], "DATA6").toLowerCase() == getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[8], "DATA8").toLowerCase())
                    DuplicateFlag = true;
            }

            if (DuplicateFlag) {
                continue;
            } else {
                var preDeptName = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
                var preDeptJobTitle = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
                var preDeptName1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
                var preDeptName2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
                var preWriterName1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[2])[0], "VALUE");
                var preWriterName2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[2])[0], "VALUE");
                var preDeptJobTitle1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
                var preDeptJobTitle2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
                var preDeptID = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[8], "DATA8");
                var preUserID = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[5], "DATA5");

                var pparsingXML = "";
                pparsingXML += "<LISTVIEWDATA><HEADERS>";
                pparsingXML += "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>30</WIDTH></HEADER>";
                pparsingXML += "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>50</WIDTH></HEADER>";
                pparsingXML += "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>60</WIDTH></HEADER>";
                pparsingXML += "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>80</WIDTH></HEADER>";
                pparsingXML += "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>80</WIDTH></HEADER>";
                pparsingXML += "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
                pparsingXML += "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>80</WIDTH></HEADER>";
                pparsingXML += "</HEADERS><ROWS>";
                pparsingXML += "<ROW>";
                pparsingXML += "<CELL>";
                pparsingXML += "<VALUE>" + AprLineAddIndex + "</VALUE>";
                pparsingXML += "<DATA1>" + "" + "</DATA1>";
                pparsingXML += "<DATA2>" + "" + "</DATA2>";
                pparsingXML += "<DATA3>" + pDocID + "</DATA3>";
                pparsingXML += "<DATA4>" + preUserID + "</DATA4>";
                pparsingXML += "<DATA5>" + "N" + "</DATA5>";
                pparsingXML += "<DATA6>" + preDeptID + "</DATA6>";
                pparsingXML += "<DATA7>" + "" + "</DATA7>";
                pparsingXML += "<DATA8>" + "N" + "</DATA8>";
                pparsingXML += "<DATA9>" + "N" + "</DATA9>";
                pparsingXML += "<DATA10>7001388</DATA10>";
                pparsingXML += "<DATA11>015</DATA11>";
                pparsingXML += "<DATA12>001</DATA12>";
                pparsingXML += "<DATA13>" + MakeXMLString(preWriterName1) + "</DATA13>";
                pparsingXML += "<DATA14>" + MakeXMLString(preWriterName2) + "</DATA14>";
                pparsingXML += "<DATA15>" + MakeXMLString(preDeptName1) + "</DATA15>";
                pparsingXML += "<DATA16>" + MakeXMLString(preDeptName2) + "</DATA16>";
                pparsingXML += "<DATA17>" + MakeXMLString(preDeptJobTitle1) + "</DATA17>";
                pparsingXML += "<DATA18>" + MakeXMLString(preDeptJobTitle2) + "</DATA18>";
                pparsingXML += "</CELL><CELL>";
                pparsingXML += "<VALUE>" + MakeXMLString(preWriterName1) + "</VALUE>";
                pparsingXML += "</CELL><CELL>";
                pparsingXML += "<VALUE>" + MakeXMLString(preDeptJobTitle) + "</VALUE>";
                pparsingXML += "</CELL><CELL>";
                pparsingXML += "<VALUE>" + MakeXMLString(preDeptName) + "</VALUE>";
                pparsingXML += "</CELL><CELL>";
                pparsingXML += "<VALUE>" + strLangAprType17 + "</VALUE>";
                pparsingXML += "</CELL><CELL>";
                pparsingXML += "<VALUE>" + strLang72 + "</VALUE>";
                pparsingXML += "</CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>";

                objXML = loadXMLString(pparsingXML);

                var tr = pAPRLINE.GetSelectedRows();
                var InitTr = pAPRLINE.GetDataRows();
                var MaxID = 0;

                for (var j = 0  ; j < InitTr.length  ; j++) {
                    var curnum = Number(pAPRLINE.GetSelectedRowID(j).substring(pAPRLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAPRLINE.GetSelectedRowID(j).length);
                    if (MaxID < curnum)
                        MaxID = curnum;
                }

                if (tr.length == 0) {
                    if (InitTr.length == 0) {
                        if (document.getElementById("APRLINECC").innerHTML != "")
                            document.getElementById("APRLINECC").innerHTML = "";

                        var pAPRLINE = new ListView();
                        pAPRLINE.SetID("pAPRLINE");
                        pAPRLINE.SetMulSelectable(false);
                        pAPRLINE.SetRowOnDblClick("AprlineDel_onclickCC");
                        pAPRLINE.SetSelectFlag(false);
                        pAPRLINE.SetHeightFree(true);
                        pAPRLINE.DataSource(objXML);
                        pAPRLINE.DataBind("APRLINECC");
                        AprLineAddIndex++;
                    } else {
                        var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));
                        pAPRLINE.AddDataRow(objTr, objXML);
                        AprLineAddIndex++;
                    }
                } else {
                    var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));
                    pAPRLINE.AddDataRow(objTr, objXML);
                    AprLineAddIndex++;
                }
            }
        }*/
    } catch (e) {
        alert("AprGongRamLine_Cross_SetGongRamList::" + e.description);
    }
}
var aprlinetempletname_cross_dialogArguments = new Array();
var tempmode;
function btn_AprDeptTempletSaveCC_onclick(mode) {
    try {
        tempmode = mode;
        if (isExistCCDept(true)) {
            return;
        }

        var templistviewsn = "";
        var templisttviewname = "";
        var ListViewLen = "";

        var lvTest = new ListView();
        lvTest.LoadFromID("pAPRLINE");
        ListViewLen = lvTest.GetDataRows();

        if (ListViewLen.length == 0 || GetAttribute(ListViewLen[0], "id") == "pAPRLINE_TR_noItems") {
        	if (approvalFlag == "G") {
        		OpenAlertUI(strLangpjj27);
        	} else {
        		OpenAlertUI(strLangHYJ28);
        	}
        	
            return;
        }

        var listview = new ListView();

        if (mode == "NEW") {
            listview.LoadFromID("pAPRLINE");
            ListViewLen = listview.GetDataRows();
        } else {
            listview.LoadFromID("lvRecSaveListCC");
            ListViewLen = listview.GetSelectedRows();
        }

        if (mode == "MODIFY" && ListViewLen.length < 1) {
            return;
        } else if (mode == "MODIFY" && ListViewLen.length >= 1) {
            templistviewsn = ListViewLen[0].getAttribute("DATA1");
            templisttviewname = ListViewLen[0].getAttribute("DATA2");
        }

        if (ListViewLen.length != "0" && ListViewLen[0].id != "lvRecSaveListCC_TR_noItems") {
            var windowName = "/ezApprovalG/aprLineTempletName.do?type=gonram";
            var parameter = "status:no;dialogWidth:340px;dialogHeight:205px;scroll:no;edge:sunken";
            var dialogValue = new Array();
            dialogValue[0] = pUserID;
            dialogValue[1] = pFormIDCC;
            dialogValue[2] = "";
            dialogValue[3] = "";
            if (mode == "MODIFY") {
                dialogValue[2] = templistviewsn;
                dialogValue[3] = templisttviewname;
            }
            if (CrossYN()) {
                aprlinetempletname_cross_dialogArguments[0] = dialogValue;
                aprlinetempletname_cross_dialogArguments[1] = btn_AprDeptTempletSaveCC_onclick_Complete;

                DivPopUpShow(340, 200, windowName);
            } else {
                parameter = parameter + GetShowModalPosition(340, 200);

                var ret = window.showModalDialog(windowName, dialogValue, parameter);
                if (ret != "cancel") {
                    if (mode == "NEW")
                        pAprDeptTempletUseFlag = true;
                    else
                        pAprDeptTempletUseFlag = false;

                    CreateNewAprDeptTempletCC(ret);
                }
            }
        } else {
            var pAlertContent = linealt14;
            OpenAlertUI(pAlertContent);
        }
    } catch (e) {
        alert("AprGongRamLine_Cross_SetGongRamList::" + e.description);
    }
}
var pAprDeptTempletUseFlag;
function btn_AprDeptTempletSaveCC_onclick_Complete(ret) {
    try {
        DivPopUpHidden();
        if (ret != "cancel") {
            if (tempmode == "NEW")
                pAprDeptTempletUseFlag = true;
            else
                pAprDeptTempletUseFlag = false;

            CreateNewAprDeptTempletCC(ret);
        }
    } catch (e) {
        alert("AprGongRamLine_Cross_btn_AprDeptTempletSaveCC_onclick_Complete::" + e.description);
    }
}
function isExistCCDept(ExtFlag) {
    try {
        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");
        var CurSelRow = listview.GetDataRows();
        var rtnVal = false;
        for (i = 0; i < CurSelRow.length; i++) {
            if (ExtFlag) {
                if (GetAttribute(CurSelRow[0], "DATA3") == "Y")
                    rtnVal = true;
            }
            else {
                if (GetAttribute(CurSelRow[0], "DATA3") == "N")
                    rtnVal = true;
            }

            if (GetAttribute(CurSelRow[0], "DATA1") == "Address") {
                rtnVal = true;
            }
        }
        return rtnVal;
    } catch (e) {
        alert("AprGongRamLine_Cross_isExistDept::" + e.description);
    }
}
function CreateNewAprDeptTempletCC(p_AprDeptTempletName) {
    try {
        var AprDeptTemplet = createXmlDom();
        var Result;
        var p_AprDeptTempletID;
        AprDeptTemplet = AprDeptTempletXmlParsingCC(p_AprDeptTempletName);
        var AprDeptXml = APRDeptXMLParsingCC(APRLINE, pDocID);
        var AprDeptInfo = createXmlDom();
        AprDeptInfo = loadXMLString(AprDeptXml);

        if (CrossYN()) {
            var xmlRtn = AprDeptTemplet.documentElement;
            var Node = AprDeptInfo.importNode(xmlRtn, true);
            AprDeptInfo.documentElement.appendChild(Node);
        }
        else {
            var xmlRtn = AprDeptTemplet.documentElement;
            AprDeptInfo.documentElement.appendChild(xmlRtn);
        }

        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/ezApprovalG/createAprLineTemplet.do", false);
        xmlhttp.send(AprDeptInfo);
        
        var RtnVal = xmlhttp.responseText;
        
        if (xmlhttp != null && xmlhttp.readyState == 4) {
    		if (xmlhttp.status == 200 && RtnVal == "TRUE") {
    			OpenAlertUI(strLang814, CreateNewAprDeptTempletCC_Complete);
                if (!CrossYN())
                    GetReceptTempletListCC();
    		} else {
    			OpenAlertUI(strLang131);
    		}
    	}

        GetReceptTempletListCC();
    } catch (e) {
        alert("AprGongRamLine_Cross_CreateNewAprDeptTempletCC::" + e.description);
    }
}
function CreateNewAprDeptTempletCC_Complete() {
    DivPopUpHidden();
    GetReceptTempletListCC();
}

function AprDeptTempletXmlParsingCC(p_AprDeptTempletName) {
    try {
        var p_AprDeptSN;
        var xmlpara = createXmlDom();
        if (pAprDeptTempletUseFlag) {
            p_AprDeptSN = "";
        } else {

            var pAPRTemplist = new ListView();
            pAPRTemplist.LoadFromID("lvRecSaveListCC");
            var ListViewLen = pAPRTemplist.GetSelectedRows();
            p_AprDeptSN = ListViewLen[0].getAttribute("DATA1");
        }

        var objNode;
        createNodeInsert(xmlpara, objNode, "APRTEMP");
        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
        createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormIDCC);
        createNodeAndInsertText(xmlpara, objNode, "pAprDeptSN", p_AprDeptSN);
        createNodeAndInsertText(xmlpara, objNode, "p_AprDeptTempletName", p_AprDeptTempletName);

        return xmlpara;
    } catch (e) {
        alert("AprGongRamLine_Cross_AprDeptTempletXmlParsingCC::" + e.description);
    }
}

function APRDeptXMLParsingCC(APRDEPT, pDocID) {
    try {
        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");
        var AprDeptRow = listview.GetDataRows();
        var CurListLen = AprDeptRow.length;
        var CurCellLen = 0;
        if (CurListLen > 0)
            CurCellLen = AprDeptRow[0].cells.length - 1;
        var i;
        var j;
        var GetXml;

        GetXml = "<LISTVIEWDATA><HEADERS></HEADERS>";
        GetXml = GetXml + "<ROWS>";

        for (i = 0; i < CurListLen; i++) {
            GetXml = GetXml + "<ROW>";
            for (j = 0; j < CurCellLen; j++)
                GetXml = GetXml + "<COLUMN>" + MakeXMLString(AprDeptRow[i].cells[j].innerText) + "</COLUMN>";

            GetXml = GetXml + "<DATA name='ProcessDate'>" + AprDeptRow[i].getAttribute("DATA1") + "</DATA>";
            GetXml = GetXml + "<DATA name='ReceivedDate'>" + AprDeptRow[i].getAttribute("DATA2") + "</DATA>";
            GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
            GetXml = GetXml + "<DATA name='AprMemberID'>" + AprDeptRow[i].getAttribute("DATA4") + "</DATA>";
            GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + AprDeptRow[i].getAttribute("DATA5") + "</DATA>";
            GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + AprDeptRow[i].getAttribute("DATA6") + "</DATA>";
            GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + AprDeptRow[i].getAttribute("DATA7") + "</DATA>";
            GetXml = GetXml + "<DATA name='isProposerYN'>" + AprDeptRow[i].getAttribute("DATA8") + "</DATA>";
            GetXml = GetXml + "<DATA name='isBriefUserYN'>" + AprDeptRow[i].getAttribute("DATA9") + "</DATA>";
            GetXml = GetXml + "<DATA name='isCompanyID'>" + AprDeptRow[i].getAttribute("DATA10") + "</DATA>";
            GetXml = GetXml + "<DATA name='AprType'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA11")) + "</DATA>";
            GetXml = GetXml + "<DATA name='AprState'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA12")) + "</DATA>";
            GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA13")) + "</DATA>";
            GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA14")) + "</DATA>";
            GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA15")) + "</DATA>";
            GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA16")) + "</DATA>";
            GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA17")) + "</DATA>";
            GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA18")) + "</DATA>";
            GetXml = GetXml + "</ROW>";
        }

        GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
        return GetXml;
    } catch (e) {
        alert("AprGongRamLine_Cross_APRDeptXMLParsingCC::" + e.description);
    }
}


/**
 * 회람 정보 -> 부서추가 기능
 */
function btn_addDepartment() {
	// 포함할 경우 하위부서 정보를 전부 가져와서 처리
	/*if (confirm(strLangPJG02)) {
		
		var treeView = new TreeView();
		treeView.LoadFromID("FromTreeViewCC");
		var selnode = treeView.GetSelectNode();
		var deptID = selnode.GetNodeData("CN");
		var jsonInfo;
		
		$.ajax({
			type : "POST",
			dataType : "text",
			url : "/ezOrgan/getAllDeptID",
			async : false,
			data : {
				deptID : deptID
			},
			success : function(result) {
				jsonInfo = JSON.parse(result);
				
				for (var i=jsonInfo.length-1; i>=0; i--) {
					getUserInDept(jsonInfo[i].cn);
				}
			}
		});
	} else {*/
		var listView = new ListView();
		listView.LoadFromID("DivUserList");
		var listObj = listView.GetDataRows();
		
		if (listObj) {
			if (listObj[0].id.indexOf("noItems") == -1) {
				for (var i = listObj.length-1; i >= 0; i --) {
					APRLINEATTENDADDFunctionCC(listObj[i], "PERSON");
				}
			}
		}
	//}
}

// 부서원 정보를 가져온다.
function getUserInDept(dept) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getDeptMemberList.do",
		data : {
			deptID : dept,
			cell 	 : "displayName;description;title;telephoneNumber",
			prop     : "department;extensionAttribute4;displayName;description;title",
			type 	 : "user"
		},
		success: function(xml) {
			//console.log("row xml : " + xml);
			xml = loadXMLString(xml);
			aprLineAddDeptUser("PERSON", xml);
		}		
	});
}
