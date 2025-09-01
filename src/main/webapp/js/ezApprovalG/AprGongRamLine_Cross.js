﻿var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}

var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";
    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
        DivPopUpShow(330, 205, url);
    } else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
        if (RtnVal)
            CompleteFunction(RtnVal);
    }
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}

function trim(parm_str) {
    return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
    str_temp = parm_str;
    while (str_temp.length != 0) {
        if (str_temp.substring(0, 1) == " ") {
            str_temp = str_temp.substring(1, str_temp.length);
        } else {
            return str_temp;
        }
    }
    return str_temp;
}

function rtrim(parm_str) {
    str_temp = parm_str;
    while (str_temp.length != 0) {
        int_last_blnk_pos = str_temp.lastIndexOf(" ");
        if ((str_temp.length - 1) == int_last_blnk_pos) {
            str_temp = str_temp.substring(0, str_temp.length - 1);
        } else {
            return str_temp;
        }
    }
    return str_temp;
}

var g_progresswin = null;
function showProgress() {
    g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape(strLang384), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
}
function hideProgress() {
    try {
        if (g_progresswin)
            g_progresswin.close();
    } catch (e) { }
}

function getGongRamDocInfo() {
    try {
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/gongRamDocInfo.do",
    		data : {
    			docID : pDocID
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});
    	
        pGongRamDocID = getNodeText(GetChildNodes(loadXMLString(result))[0]);

        if (pGongRamDocID == "NONE")
            pGongRamDocID = "";

    } catch (e) {
        pGongRamDocID = "";
        alert("getGongRamDocInfo :: " + e.description);
    }
}

function TreeViewNodeClick() {
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");

    var nodeIdx = treeView.GetSelectNode();

    displayUserList(nodeIdx.GetNodeData("CN"));
}

function displayUserList(DeptID) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezOrgan/getDeptMemberList.do",
		data : {
				deptID   : DeptID,
				cell 	 : "displayName;description;title;telephoneNumber",
				//cell 	 : "displayname;Description;Title;telephonenumber",
				prop     : "department;extensionAttribute4;displayName;description;title",
				type 	 : "user"
				},
		success: function(xml){
			var listview = new ListView();
            listview.LoadFromID("DivUserList");
            listview.DataSource(loadXMLString(xml));
            listview.RowDataBind();
		},
		error: function(request) {
			alert(strLang821 + request.responseText);
		}
	});
}
//안씀
function event_displayUserList(result) {
        var listview = new ListView();
        listview.LoadFromID("DivUserList");
        listview.DataSource(result);
        listview.RowDataBind();
}

function InitListView() {
    try {
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getLineList.do",
    		data : {
    			docID : pGongRamDocID,
    			mode  : "APR",
    			docState : "015"
    		},
    		success: function(text){
    			result = text;
    		}
    	});

        var LVData = null;
        if (result == "NOTPERMISSION") {
            alert(strLang1132);
            window.close();
        } else {
            LVData = createXmlDom();
            LVData = loadXMLString(result);
        }
        
        var resultXML = loadXMLString(result);
        
        setNodeText(GetElementsByTagName(resultXML, "WIDTH")[0], "35");
        setNodeText(GetElementsByTagName(resultXML, "WIDTH")[1], "120");
        setNodeText(GetElementsByTagName(resultXML, "WIDTH")[2], "50");
        setNodeText(GetElementsByTagName(resultXML, "WIDTH")[3], "130");
        setNodeText(GetElementsByTagName(resultXML, "WIDTH")[4], "120");
        setNodeText(GetElementsByTagName(resultXML, "WIDTH")[5], "70");
        setNodeText(GetElementsByTagName(resultXML, "WIDTH")[6], "140");
        
        resultXML.getElementsByTagName("HEADER")[0].removeChild(resultXML.getElementsByTagName("HEADER")[0].childNodes[2]);
        resultXML.getElementsByTagName("HEADER")[1].removeChild(resultXML.getElementsByTagName("HEADER")[1].childNodes[2]);
        resultXML.getElementsByTagName("HEADER")[2].removeChild(resultXML.getElementsByTagName("HEADER")[2].childNodes[2]);
        resultXML.getElementsByTagName("HEADER")[3].removeChild(resultXML.getElementsByTagName("HEADER")[3].childNodes[2]);
        resultXML.getElementsByTagName("HEADER")[4].removeChild(resultXML.getElementsByTagName("HEADER")[4].childNodes[2]);
        resultXML.getElementsByTagName("HEADER")[5].removeChild(resultXML.getElementsByTagName("HEADER")[5].childNodes[2]);
        resultXML.getElementsByTagName("HEADER")[6].removeChild(resultXML.getElementsByTagName("HEADER")[6].childNodes[2]);

        var pAPRLINE = new ListView();
        pAPRLINE.SetID("pAPRLINE");
        pAPRLINE.SetMulSelectable(false);
        pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
        pAPRLINE.SetSelectFlag(false);
        pAPRLINE.SetHeightFree(true);
        pAPRLINE.DataSource(resultXML);
        pAPRLINE.DataBind("APRLINE");
        
    }
    catch (e) {
        alert("InitListView :: " + e.description);
    }
}

function APRLINESNDownFunction() {
    try {
        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");

        var pTotalRow = listview.GetDataRows();
        var pSelectedRow = listview.GetSelectedRows();
        if (pSelectedRow.length != 0) {
            var p_NextSelRow = listview.GetDataRows()[Number(listview.GetSelectedIndexes().split(',')[0]) + 1];

            if (p_NextSelRow != null) {
                if (p_NextSelRow.cells[5].innerText == strLang72)
                    DoAprLineDown(pSelectedRow);
            }
        }
    } catch (e) {
        alert("APRLINESNDownFunction :: " + e.description);
    }
}

function DoAprLineDown(pSelectedRow) {
    try {
        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");

        listview.RowMoveDown();

        var ColRow = listview.GetDataRows();
        for (i = 0 ; i < (ColRow.length) ; i++) {

            if (CrossYN()) {
                ColRow[i].cells[0].textContent = (ColRow.length - i);
            }
            else {
                ColRow[i].cells[0].innerText = (ColRow.length - i);
            }
        }

    } catch (e) {
        alert("DoAprLineDown :: " + e.description);
    }
}

function APRLINESNUPPERFunction() {
    try {

        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");

        var pSelectedRow = listview.GetSelectedRows();
        if (pSelectedRow.length != 0) {
            var p_NextSelRow = listview.GetDataRows()[Number(listview.GetSelectedIndexes().split(',')[0]) - 1];
            if (p_NextSelRow != null) {
                if (p_NextSelRow.cells[5].innerText == strLang72 && pSelectedRow[0].cells[5].innerText == strLang72)
                    UpperAprLineSN(pSelectedRow);
            }
        }
    } catch (e) {
        alert("APRLINESNUPPERFunction :: " + e.description);
    }
}

function UpperAprLineSN(pSelectedRow) {
    try {
        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");

        listview.RowMoveUp();
        var ColRow = listview.GetDataRows();

        for (i = 0 ; i < (ColRow.length) ; i++) {
            if (CrossYN()) {
                ColRow[i].cells[0].textContent = (ColRow.length - i);
            }
            else {
                ColRow[i].cells[0].innerText = (ColRow.length - i);
            }
        }
    } catch (e) {
        alert("UpperAprLineSN  :: " + e.description);
    }
}

function APRLINEATTENDERDELFunction() {
    try {
        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");

        var pSelectedRow = listview.GetSelectedRows();
        if (pSelectedRow.length != 0 && pSelectedRow != null && listview.GetSelectedIndexes().split(',')[0] != -1) {
            if (pSelectedRow[0].cells[5].innerText != strLang72) {
            	var pAlertContent = "";
            	
            	if (approvalFlag == "G") {
            		pAlertContent = strLang822 + "<br> " + strLang823;
            	} else {
            		pAlertContent = strLangS822 + "<br> " + strLang823;
            	}
            	
                OpenAlertUI(pAlertContent);
                return;
            }
            DoDelete(pSelectedRow);
        }
    } catch (e) {
        alert("APRLINEATTENDERDELFunction :: " + e.description);
    }
}

function DoDelete(pSelectedRow) {
    try {
        var RowDelCheck;

        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");

        var pTotalRows = listview.GetDataRows();
        var pSelectedIndex = Number(listview.GetSelectedIndexes().split(',')[0]);
        var Rtnval = "N";

        TIndex = pTotalRows.length;
        NIndex = pSelectedIndex;

        for (i = 0 ; i <= NIndex ; i++) {
            if (CrossYN()) {
                RowDelCheck = pTotalRows[i].cells[0].innerText;
                pTotalRows[i].cells[0].textContent = RowDelCheck - 1;
            }
            else {
                RowDelCheck = pTotalRows[i].cells[0].innerText;
                pTotalRows[i].cells[0].innerText = RowDelCheck - 1;
            }
            Rtnval = "Y";
        }
        if (Rtnval == "Y") {
            var selIdx = listview.GetSelectedRows()[0].getAttribute("id");
            listview.DeleteRow(selIdx);
        }
    } catch (e) {
        alert("DoDelete :: " + e.description);
    }
}

function APRLINEATTENDADDFunction(pCurSelectedRow, Mode) {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");

        var pCurSelRow = pAPRLINE.GetDataRows();

        if (pCurSelRow[0] != undefined && pCurSelRow[0].id == "pAPRLINE_TR_noItems") 
            pAPRLINE.DeleteRow("pAPRLINE_TR_noItems")

        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");

        var selnode = treeView.GetSelectNode();

        if (pCurSelectedRow == null) {
            if (Mode == "PERSON") {
                var pCurSelectedRow = pCurSelRow[0];
            }
            else if (Mode == "DEPT") {
                var pCurSelectedRow = selnode;
            }
        }

        var DuplicateFlag = false;
        for (i = 0; i < pCurSelRow.length; i++) {
            if (GetAttribute(pCurSelRow[i], "DATA4").toLowerCase() == GetAttribute(pCurSelectedRow, "DATA2").toLowerCase())
                DuplicateFlag = true;
        }
        if (DuplicateFlag) {
        	var pAlertContent = "";
        	
        	if (approvalFlag == "G") {
        		pAlertContent = strLang824;
        	} else {
        		pAlertContent = strLangS824;
        	}
        	
            OpenAlertUI(pAlertContent);
            return;
        }
        else {
            AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
        }

    } catch (e) {
        alert("APRLINEATTENDADDFunction :: " + e.description);
    }
}

function AprLineAddUser(Mode, tr, pSelectedRow) {
    try {
        if (pSelectedRow != null) {
            var treeView = new TreeView();
            treeView.LoadFromID("FromTreeView");

            var pparsingXML;
            var objXML = createXmlDom();

            var pAPRLINE = new ListView();      
            pAPRLINE.LoadFromID("pAPRLINE");

            AprLineAddIndex = pAPRLINE.GetDataRows().length;
            AprLineAddIndex = AprLineAddIndex + 1;
            var selnode = treeView.GetSelectNode();

            if (Mode == "PERSON") {
                var preDeptID = GetAttribute(pSelectedRow, "DATA3");
                var preDeptName = pSelectedRow.cells[1].innerText;
                var preDeptJobTitle = pSelectedRow.cells[2].innerText;
                var preDeptName1 = GetAttribute(pSelectedRow, "DATA10");
                var preDeptName2 = GetAttribute(pSelectedRow, "DATA11");
                var preWriterName1 = GetAttribute(pSelectedRow, "DATA8");
                var preWriterName2 = GetAttribute(pSelectedRow, "DATA9");
                var preDeptJobTitle1 = GetAttribute(pSelectedRow, "DATA12");
                var preDeptJobTitle2 = GetAttribute(pSelectedRow, "DATA13");

                if (trim(GetAttribute(pSelectedRow[0], "DATA4")) != "") {
                    var RtnVal = selectSubTitles(GetAttribute(pSelectedRow, "DATA2"));
                    if (RtnVal[0] == "OK") {
                        preDeptID = RtnVal[1];
                        preDeptName = RtnVal[2];
                        preDeptJobTitle = RtnVal[3];
                        preDeptName1 = RtnVal[4];
                        preDeptName2 = RtnVal[5];
                        preDeptJobTitle1 = RtnVal[6];
                        preDeptJobTitle2 = RtnVal[7];
                    }
                    else {
                        return;
                    }
                }

                pparsingXML = "<LISTVIEWDATA><HEADERS>";
                pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
                pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
                pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>50</WIDTH></HEADER>";
                pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
                pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>120</WIDTH></HEADER>";
                pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>70</WIDTH></HEADER>";
                pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>140</WIDTH></HEADER>";
                pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
                pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
                pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
                pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
                pparsingXML = pparsingXML + "<DATA4>" + GetAttribute(pSelectedRow, "DATA2") + "</DATA4>";
                pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
                pparsingXML = pparsingXML + "<DATA6>" + preDeptID + "</DATA6>";
                pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
                pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
                pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
                pparsingXML = pparsingXML + "<DATA10>" + selnode.GetNodeData("EXTENSIONATTRIBUTE2") + "</DATA10>";
                pparsingXML = pparsingXML + "<DATA11>015</DATA11>";
                pparsingXML = pparsingXML + "<DATA12>001</DATA12>";
                pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA8")) + "</DATA13>";		
                pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA9")) + "</DATA14>";		
                pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(preDeptName1) + "</DATA15>";		
                pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(preDeptName2) + "</DATA16>";	
                pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(preDeptJobTitle1) + "</DATA17>";	
                pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(preDeptJobTitle2) + "</DATA18>";	


                pparsingXML = pparsingXML + "</CELL><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + pSelectedRow.cells[0].innerText + "</VALUE>";
                pparsingXML = pparsingXML + "</CELL><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(preDeptJobTitle) + "</VALUE>";
                pparsingXML = pparsingXML + "</CELL><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(preDeptName) + "</VALUE>";
                pparsingXML = pparsingXML + "</CELL><CELL>";
                
                if (approvalFlag == "G") {
                	pparsingXML = pparsingXML + "<VALUE>" + strLang752 + "</VALUE>";
                } else {
                	pparsingXML = pparsingXML + "<VALUE>" + strLangAprType17 + "</VALUE>";
                }
                pparsingXML = pparsingXML + "</CELL><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + strLang72 + "</VALUE>";
                pparsingXML = pparsingXML + "</CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>";
            } else if (Mode == "DEPT") {
            }
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
                    if (document.getElementById("APRLINE").innerHTML != "")
                        document.getElementById("APRLINE").innerHTML = "";

                    var pAPRLINE = new ListView();      
                    pAPRLINE.SetID("pAPRLINE");
                    pAPRLINE.SetMulSelectable(false);    
                    pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");            
                    pAPRLINE.SetSelectFlag(false);
                    pAPRLINE.SetHeightFree(true);
                    pAPRLINE.DataSource(objXML);      
                    pAPRLINE.DataBind("APRLINE");
                } else {
                    var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));
                    pAPRLINE.AddDataRow(objTr, objXML);
                }
            }
            else {
                var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));
                pAPRLINE.AddDataRow(objTr, objXML);
            }

            AprLineAddIndex = AprLineAddIndex + 1;
        }
    } catch (e) {
        alert("AprLineAddUser :: " + e.description);
    }
}

function APRLINEATTENDSAVEFunction() {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;

        if (pTotalRowsLen == "0") {
        	var pAlertContent = "";
        	
        	if (approvalFlag == "G") {
        		pAlertContent = strLang825;
        	} else {
        		pAlertContent = strLangS825;
        	}
            
            OpenAlertUI(pAlertContent);
            return;
        } else {
            SaveAprLineInfo();
        }
    } catch (e) {
        alert("APRLINEATTENDSAVEFunction :: " + e.description);
    }
}

function SaveAprLineInfo() {
    try {
        var pstrXML = APRLINEXMLParsing();
        if (pstrXML == "false") return;
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("Post", "/ezApprovalG/gongRamSave.do?type=" + type, false);
        xmlhttp.send(pstrXML);

        if (xmlhttp != null && xmlhttp.readyState == 4) {
          	 if (xmlhttp.status == 200) {
          		  var dataNodes = GetChildNodes(xmlhttp.responseXML);
                  var ret = getNodeText(dataNodes[0]);
                  if (ret != "FALSE") {
                      UpdateLineHistory(ret);
                      window.returnValue = "OK";
//                      window.close();//
                      btnClose_onclick();
                  }
          	 } else {
          		var pAlertContent = "";
          		
          		if (approvalFlag == "G") {
            		pAlertContent = strLang826;
            	} else {
            		pAlertContent = strLangS826;
            	}
          		
                OpenAlertUI(pAlertContent);
                return;
          	 }
          } 
    } catch (e) {
        alert("SaveAprLineInfo :: " + e.description);
    }
}

function APRLINEXMLParsing() {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;
        var pTotalColsLen = pTotalRows[0].cells.length;

        var i;
        var j;
        var k = 0;
        var strXML;
        var AprLineTotalLen;
        AprLineTotalLen = pTotalRowsLen;

        strXML = "<LISTVIEWDATA><HEADERS></HEADERS><ROWS>";

        for (i = 0 ; i < pTotalRowsLen ; i++) {
            strXML = strXML + "<ROW>";
            strXML = strXML + "<COLUMN>" + (AprLineTotalLen - k) + "</COLUMN>";
            for (j = 1 ; j < pTotalColsLen - 1 ; j++)
                strXML = strXML + "<COLUMN>" + MakeXMLString(pTotalRows[i].cells[j].innerText) + "</COLUMN>";

            strXML = strXML + "<DATA name='ProcessDate'>" + GetAttribute(pTotalRows[i], "DATA1") + "</DATA>";
            strXML = strXML + "<DATA name='ReceivedDate'>" + GetAttribute(pTotalRows[i], "DATA2") + "</DATA>";
            strXML = strXML + "<DATA name='DocID'>" + pDocID + "</DATA>";
            strXML = strXML + "<DATA name='AprMemberID'>" + GetAttribute(pTotalRows[i], "DATA4") + "</DATA>";
            strXML = strXML + "<DATA name='AprmemberIsDeptYN'>" + GetAttribute(pTotalRows[i], "DATA5") + "</DATA>";
            strXML = strXML + "<DATA name='AprMemberDeptID'>" + GetAttribute(pTotalRows[i], "DATA6") + "</DATA>";
            strXML = strXML + "<DATA name='ReasonDoNotApprov'>" + GetAttribute(pTotalRows[i], "DATA7") + "</DATA>";
            strXML = strXML + "<DATA name='isProposerYN'>" + GetAttribute(pTotalRows[i], "DATA8") + "</DATA>";
            strXML = strXML + "<DATA name='isBriefUserYN'>" + GetAttribute(pTotalRows[i], "DATA9") + "</DATA>";
            strXML = strXML + "<DATA name='companyID'>" + GetAttribute(pTotalRows[i], "DATA10") + "</DATA>";
            strXML = strXML + "<DATA name='PMemberName'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA13")) + "</DATA>";		
            strXML = strXML + "<DATA name='SMemberName'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA14")) + "</DATA>";		
            strXML = strXML + "<DATA name='PMemberDeptName'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA15")) + "</DATA>";		
            strXML = strXML + "<DATA name='SMemberDeptName'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA6")) + "</DATA>";	
            strXML = strXML + "<DATA name='PMemberJobTitle'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA17")) + "</DATA>";	
            strXML = strXML + "<DATA name='SMemberJobTitle'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA18")) + "</DATA>";	
            strXML = strXML + "<DATA name='AprType'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA11")) + "</DATA>";
            strXML = strXML + "<DATA name='AprState'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA12")) + "</DATA>";
            strXML = strXML + "</ROW>";
            k = k + 1;
        }

        strXML = strXML + "</ROWS></LISTVIEWDATA>";
        return strXML;
    } catch (e) {
        alert("APRLINEXMLParsing :: " + e.description);
    }
}
function UpdateLineHistory(_DOCID) {
    if (_DOCID == "") {
        return;
    }

	var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateLineHistory.do",
		data : {
			docID : _DOCID,
			userID : arr_userinfo[1],
			userName : arr_userinfo[11],
			userJobTitle : arr_userinfo[13],
			userDeptID : arr_userinfo[4],
			userDeptName : arr_userinfo[15],
			chkFlag : "MUST",
			userName2 : arr_userinfo[12],
			userJobTitle2 : arr_userinfo[14],
			userDeptName2 : arr_userinfo[16]
		},
		success: function(xml){
			result = xml;
		}        			
	});
}
/**
 * 결재->회람(공람)-> 부서추가
 * */
function btn_addDepartment() {
	// 포함할 경우 하위부서 정보를 전부 가져와서 처리
	 	/*if (confirm(strLangPJG02)) {
		var treeView = new TreeView();
		treeView.LoadFromID("FromTreeView");
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
	} else {
		var listView = new ListView();
		listView.LoadFromID("DivUserList");
		var listObj = listView.GetDataRows();
		
		if (listObj) {
			if (listObj[0].id.indexOf("noItems") == -1) {
				for (var i = listObj.length-1; i >= 0; i --) {
					APRLINEATTENDADDFunction(listObj[i], "PERSON");
				}
			}
		}
	}*/ // 부서추가 버튼이 조직도 트리뷰의 선택한 부서의 부서원 입력이 아닌, 이름 검색 시 트리뷰 하단에 검색 결과가 나오는데 그것을 전부 입력하는 동작을 하여서 주석처리
	
	//2018-08-08 천성준 - 부서추가 버튼 클릭 시, 조직도 트리뷰에서 선택한 부서의 CN을 가져와서 부서원 입력  
	var treeView = new TreeView();
	treeView.LoadFromID("FromTreeView");
	var selnode = treeView.GetSelectNode();
	var deptID = selnode.GetNodeData("CN");
	getUserInDept(deptID);
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
			var objXml = createXmlDom();
			xml = loadXMLString(xml);
			// 중복공람자를 제외한다
			var listViewDataNode = objXml.createElement("LISTVIEWDATA");
			var rowsNode = objXml.createElement("ROWS");
			var rows = xml.getElementsByTagName("ROW");
			for(var i=0; i<rows.length; i++) {
				var isDup = false;
				var userId01 = rows[i].getElementsByTagName("CELL")[0].getElementsByTagName("DATA2")[0].textContent;
				for(var j=0; j<rowsNode.getElementsByTagName("ROW").length; j++) {
					var userId02 = rowsNode.getElementsByTagName("ROW")[j].getElementsByTagName("CELL")[0].getElementsByTagName("DATA2")[0].textContent;
					if(userId01 == userId02) {
						isDup = true;
					}
				}
				if(!isDup) {
					rowsNode.appendChild(rows[i]);
					i--;
				}
			}
			listViewDataNode.appendChild(rowsNode);
			objXml.appendChild(listViewDataNode);
			//aprLineAddDeptUser("PERSON", xml);
			//중복제거된 xml로 대체
			aprLineAddDeptUser("PERSON", objXml);
		}		
	});
}

function aprLineAddDeptUser(mode, xmlData) {
	
	try {
		var pparsingXML;
        var objXML = createXmlDom();

        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");
        
        var pCurSelRow = pAPRLINE.GetDataRows();

        if (pCurSelRow[0] != undefined && pCurSelRow[0].id == "pAPRLINE_TR_noItems") {
            pAPRLINE.DeleteRow("pAPRLINE_TR_noItems")
        }
        
        
        AprLineAddIndex = pAPRLINE.GetDataRows().length;
        AprLineAddIndex = AprLineAddIndex + 1;      
        
		var getRow = GetElementsByTagName(xmlData, "ROW");
	
		for(var i = getRow.length-1; i >= 0; i --) {
			
	        var DuplicateFlag = false;
	        for (var j = 0; j < pCurSelRow.length; j++) {
	            if (GetAttribute(pCurSelRow[j], "DATA4").toLowerCase() == getNodeText(GetElementsByTagName(xmlData, "DATA2")[i]).toLowerCase()) {
	                DuplicateFlag = true;
	                console.log("1st : " + GetAttribute(pCurSelRow[j], "DATA4").toLowerCase());
	                console.log("2nd : " + getNodeText(GetElementsByTagName(xmlData, "DATA2")[i]).toLowerCase());
	            }
	        }
	        if (DuplicateFlag) {
	            var pAlertContent;
                if (approvalFlag == "G") {
                    pAlertContent = strLang824;
                } else {
                    pAlertContent = strLangS824;
                }
	            OpenAlertUI(pAlertContent);
	            continue;
	        }
		
            pparsingXML = "<LISTVIEWDATA><HEADERS>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>120</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>70</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>140</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
            pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
            pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
            pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
            pparsingXML = pparsingXML + "<DATA4>" + getNodeText(GetElementsByTagName(xmlData, "DATA2")[i]) + "</DATA4>";
            pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
            pparsingXML = pparsingXML + "<DATA6>" + getNodeText(GetElementsByTagName(xmlData, "DATA3")[i]) + "</DATA6>";
            pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
            pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
            pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
            pparsingXML = pparsingXML + "<DATA10>" + companyID + "</DATA10>";
            //회람 docstate
            pparsingXML = pparsingXML + "<DATA11>015</DATA11>";
            pparsingXML = pparsingXML + "<DATA12>001</DATA12>";
            pparsingXML = pparsingXML + "<DATA13><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA8")[i]) + "]]></DATA13>";
            pparsingXML = pparsingXML + "<DATA14><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA9")[i]) + "]]></DATA14>";
            pparsingXML = pparsingXML + "<DATA15><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA10")[i]) + "]]></DATA15>";
            pparsingXML = pparsingXML + "<DATA16><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA11")[i]) + "]]></DATA16>";
            pparsingXML = pparsingXML + "<DATA17><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA12")[i]) + "]]></DATA17>";
            pparsingXML = pparsingXML + "<DATA18><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA13")[i]) + "]]></DATA18>";
            
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(getNodeText(GetElementsByTagName(xmlData, "DATA5")[i])) + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(getNodeText(GetElementsByTagName(xmlData, "DATA7")[i])) + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(getNodeText(GetElementsByTagName(xmlData, "DATA6")[i])) + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            //G일때는 공람, S일떄는 회람으로 표시되게 수정
            if (approvalFlag == "G") {
            	pparsingXML = pparsingXML + "<VALUE>" + strLangDocState15 + "</VALUE>";
        	} else {
        		pparsingXML = pparsingXML + "<VALUE>" + strLangAprType17 + "</VALUE>";
        	}
            //pparsingXML = pparsingXML + "<VALUE>" + strLangAprType17 + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + strLang72 + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>";	

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
                    if (document.getElementById("APRLINE").innerHTML != "")
                        document.getElementById("APRLINE").innerHTML = "";

                    var pAPRLINE = new ListView();      
                    pAPRLINE.SetID("pAPRLINE");
                    pAPRLINE.SetMulSelectable(false);    
                    pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");            
                    pAPRLINE.SetSelectFlag(false);
                    pAPRLINE.SetHeightFree(true);
                    pAPRLINE.DataSource(objXML);
                    pAPRLINE.DataBind("APRLINE");
                } else {
                    var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));
                    pAPRLINE.AddDataRow(objTr, objXML);
                }
            }
            else {
                var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));
                pAPRLINE.AddDataRow(objTr, objXML);
            }

            AprLineAddIndex = AprLineAddIndex + 1;      
		}//end FOR
	
	} catch (e){
		alert("aprLineAddDeptUser :: " + e.description);
	}

}

//2020-04-28 : 공람부서 검색
var g_xmlHTTP;
var searchorganglist_dialogArguments = new Array();
var checkname2_cross_dialogArguments = new Array();
function btnAprLineSearchDept_onClick() {
	try{
        var tmpDeptName = textUser.value;
        if (tmpDeptName.length == 0) {
            var pAlertContent = strLang240;
            document.getElementById("textUser").focus();
            OpenAlertUI(pAlertContent);
            return;
        }

		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezOrgan/getSearchList.do",
			data : {
				search : "EXACT_EXTENSIONATTRIBUTE2::" + companyID + ";;displayname::" + tmpDeptName,
				cell   : "extensionAttribute3;displayname;extensionAttribute9;",
				prop   : "",
				type   : "group"
			},
			success: function(xml){
				document.getElementById("textUser").focus();
                xmlDOM = loadXMLString(xml);
                adCount = xmlDOM.getElementsByTagName("ROW").length;
			},
	    	error : function(error){
	    		document.getElementById("textUser").focus();
                alert(strLang241 + error.responseText);
	    	}
		});
		
        if (adCount == 0) {
            var pAlertContent = strLang242;
            OpenAlertUI(pAlertContent);
            return;
        }
        else if (adCount == 1) {
            g_xmlHTTP = createXMLHttpRequest();

            var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]) +
					"</DEPTID><TOPID>" + companyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
            g_xmlHTTP.onreadystatechange = event_getAprLineDeptFullTree;
            g_xmlHTTP.send(strQuery);
        }
        else {
            var rgParams = new Array();
            rgParams["addrBook"] = xmlDOM;
            rgParams["deptid"] = "";
            if (CrossYN()) {
                checkname2_cross_dialogArguments[0] = rgParams;
                checkname2_cross_dialogArguments[1] = btnAprLineSearchDept_onClick_Complete2;

                DivPopUpShow(609, 372, "/ezPersonal/checkName2.do");
            }
            else {
                window.showModalDialog("/ezPersonal/checkName2.do", rgParams, "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken");

                if (rgParams["deptid"] != "") {
                    g_xmlHTTP = createXMLHttpRequest();
                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + companyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
                    g_xmlHTTP.onreadystatechange = event_getAprLineDeptFullTree;
                    g_xmlHTTP.send(strQuery);
                }
            }
        }

	}catch(e){}
}

function btnAprLineSearchDept_onClick_Complete2(rgParams) {
    DivPopUpHidden();
    if (rgParams["deptid"] != "") {
        g_xmlHTTP = createXMLHttpRequest();
        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + companyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
        g_xmlHTTP.onreadystatechange = event_getAprLineDeptFullTree;
        g_xmlHTTP.send(strQuery);
    }
}

function event_getAprLineDeptFullTree() {
    if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
        if (g_xmlHTTP.status == 200) {
        	document.getElementById('TreeView').innerHTML = "";
        	var treeView = new TreeView();
        	treeView.SetID("FromTreeView");
        	treeView.SetUseAgency(true);
        	treeView.SetRequestData("RequestData");
        	treeView.SetNodeClick("TreeViewNodeClick");
        	treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
			treeView.DataBind("TreeView");

            treeViewScrollTo("FromTreeView");   //2020-04-24 : 선택된 노드로 트리뷰 커서 이동
        }
        else {
            alert(strLang249 + g_xmlHTTP.status);
            g_xmlHTTP = null;
        }
    }
}
