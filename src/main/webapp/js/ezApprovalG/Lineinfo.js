﻿//#############################################################################################################################################사용자리스트 원클릭 이벤트 list2_onSel_Click()
function list2_onSel_Click() {
}
//#############################################################################################################################################사용자리스트 더블클릭 이벤트 list2_onSel_DBclick()
function list2_onSel_DBclick() {
    var pUserList = new ListView();      
    pUserList.LoadFromID("pUserList");

	var selnode = pUserList.GetSelectedRows();
	var RtnVal = CheckSignCellValue();  
    
    InsertMode = "Add";	
    
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("lvAPRLINE"); 

    var pSelRow = pAPRLINE.GetSelectedRows();
    if (RtnVal) {
    	if (approvalFlag == "S") {
    		var lineArea = CheckLineArea_BeforeAdd();
    		if (!lineArea) {return;}
			
			for(var i = selnode.length-1 ; i >= 0 ; i--){
				SAPRLINEATTENDADDFunction(selnode[i], "PERSON");
			}
    	} else {
    		if (selnode.length != 0) {
				aprlinecount = 0;

    			for(var i = selnode.length-1 ; i >= 0 ; i--)
    				APRLINEATTENDADDFunction(selnode[i], "PERSON");
    		}
    	}
    }
}

function list3_onSel_DBclick() {
    try {
        var listview = new ListView();
        listview.LoadFromID("DivUserList");

        var selnode = listview.GetSelectedRows();
        if (selnode.length != 0) APRLINEATTENDADDFunctionCC(selnode[0], "PERSON");
    }
    catch (e) {
        alert("list3_onSel_DBclick :: " + e.description);
    }
}
function list4_onSel_DBclick() {
	try {
		var listview = new ListView();
		listview.LoadFromID("DivUserList");
		
		var selnode = listview.GetSelectedRows();
		APRLINEATTENDADDFunctionCC(selnode[0], "SEARCH");
	}
	catch (e) {
		alert("list4_onSel_DBclick :: " + e.description);
	}
}
function list3_onSel_Click() {
}

//회람
function AprlineDel_onclickCC() {
    APRLINEATTENDERDELFunctionCC();
}

//공람 전체삭제
function list3_deleteAll() {
	try {
		var listview = new ListView();
		listview.LoadFromID("pAPRLINE");

		var pSelectedRow = listview.GetDataRows();
		if (pSelectedRow.length != 0 && pSelectedRow != null && pSelectedRow[0].getAttribute("id").indexOf("noItems") < 0 && listview.GetSelectedIndexes().split(',')[0] != -1) {
			for (var i = 0; i < pSelectedRow.length; i++) {
				if (pSelectedRow[i].cells[5].innerText == strLang72) {
					DoDeleteCC(pSelectedRow);
				}
			}
		}
	} catch (e) {
		alert("list3_deleteAll :: " + e.description);
	}
}

//############################################################################################################################################# 결재선 삭제 함수
function AprlineDel_onclick() {
	
	var pAPRLINE = new ListView();      //// ListView 선언
	pAPRLINE.LoadFromID("lvAPRLINE");
	var pRows = pAPRLINE.GetDataRows();
	var pSelectedRow = pAPRLINE.GetSelectedRows();
	var isAuditApproval = false;
	var lastAuditRow = null;
	
	if($(pSelectedRow).attr("DATA11") == "005" && $(pSelectedRow).attr("DATA12") == "001") {
		for(var i=0; i<pRows.length; i++) {
			if($(pRows[i]).attr("DATA11") == "005" && $(pRows[i]).attr("DATA12") == "003") {
				isAuditApproval = true;
			}
			if($(pRows[i]).attr("DATA11") == "005" && $(pRows[i]).attr("DATA12") == "001" && lastAuditRow == null) {
				lastAuditRow = pRows[i];
			}
		}
		
		if(isAuditApproval) {
			if(pSelectedRow[0] == lastAuditRow) {
				OpenAlertUI(strLang954);
				return;
			} else {
				AprLineDel_onclick_action();
			}
		} else {
			for(var i=0; i<pRows.length; i++) {
				if($(pRows[i]).attr("DATA11") == "005" && $(pRows[i]).attr("DATA12") == "001") {
					$(pRows[i]).trigger("click");
					AprLineDel_onclick_action();
				}
			}
			$("input[name=auditApprLine]").prop("checked", false);
		}
		
	} else if($(pSelectedRow).attr("DATA11") == "020" || $(pSelectedRow).attr("DATA11") == "021") {
		for(var i=0; i<pRows.length; i++) {
			if(($(pRows[i]).attr("DATA11") == "020" || $(pRows[i]).attr("DATA11") == "021") && $(pRows[i]).attr("DATA12") == "001") {
				$(pRows[i]).trigger("click");
				AprLineDel_onclick_action();
			}
		}
		$("input[name=apprBilingual]").attr("isChecked", "N");
		$("input[name=apprBilingual][value=01]").attr("isChecked", "Y");
		$("input[name=apprBilingual][value=01]").prop("checked", true);
	} else {
		AprLineDel_onclick_action();
	}
}

function AprLineDel_onclick_action() {
	if (approvalFlag == "S") {
	    if (!CrossYN()) {
	        var Event_ID = window.event.srcElement.id;
	    } else if (navigator.userAgent.indexOf('Firefox') > -1) {
	        var Event_ID = "";
	    } else {
	        var Event_ID = window.event.srcElement.id;
	    }

	    var pAPRLINE = new ListView();
	    pAPRLINE.LoadFromID("lvAPRLINE");
	    var pCurSelRow = pAPRLINE.GetSelectedRows();
	    var tempcurtype = GetAttribute(pCurSelRow[0], "DATA11");
	    if (Event_ID.indexOf("lvAPRLINE_TR_") == -1) {
	        if (nodelUser()) {
	            APRLINEATTENDERDELFunction();

	            if (tempcurtype == "004") {
	                for (var i = 0; i < pAPRLINE.GetDataRows().length; i++)
	                    if (GetAttribute(pAPRLINE.GetDataRows()[i], "DATA11") == "003")
	                        pAPRLINE.GetDataRows()[i].setAttribute("DATA11", "");
	            }
	            LineAprTyepSetAll();
	        }
	    }
	} else {
		if (!rowclickevent) {
			setTimeout(AprlineDel_onclick, 1);
		}
		if (!CrossYN()) {
			var Event_ID = window.event.srcElement.id;
		}
		else if (navigator.userAgent.indexOf('Firefox') > -1) {
			var Event_ID = "";
		}
		else {
			var Event_ID = "";
			if (typeof(window.event) != "undefined") {
				Event_ID = window.event.srcElement.id;
			} else {
				return;
			}
		}
		if (Event_ID.indexOf("lvAPRLINE_TR_") == -1) {
			if (nodelUser())
				APRLINEATTENDERDELFunction();
		}
	}
}
function nodelUser()
{
    var pAPRLINE = new ListView();    
    pAPRLINE.LoadFromID("lvAPRLINE");
    var SelRow = pAPRLINE.GetSelectedRows();
    
	if(SelRow[0].getAttribute("DATA4").toLowerCase() == pUserID.toLowerCase() && SelRow[0].childNodes[0].innerHTML.replace("★","").replace("⊙","") == "1")
	{
	    OpenAlertUI(strLang945);
	    return false;
	}
	return true;
}
//############################################################################################################################################# 결재선 클릭 이벤트 
var rowclickevent = false;
function OnSelChange_onclick() {
    try {
    	if (approvalFlag == "S") {
    		var pAPRLINE = new ListView();
    	    pAPRLINE.LoadFromID("lvAPRLINE");
    	    var pSelectedRow = pAPRLINE.GetSelectedRows();
    	    pSelAprLineState = GetAttribute(pSelectedRow[0], "DATA12");
    	} else {
    		rowclickevent = false;
    		var pAPRLINE = new ListView();
    		pAPRLINE.LoadFromID("lvAPRLINE");
    		var pSelectedRow = pAPRLINE.GetSelectedRows();
    		
    		if (pSelectedRow.length > 0) {
    			var p_IsDept = GetAttribute(pSelectedRow[0], "DATA5");
    			
    			if (p_IsDept == "Y") {
    				var child = GetChildNodes(Reporter.parentElement);
    				for (var i = 0; i < child.length; i++) {
    					if (child[i].nodeType == 1)
    						child[i].style.display = "none";
    				}
    			}
    			else if (p_IsDept == "N") {
    				var child = GetChildNodes(Reporter.parentElement);
    				for (var i = 0; i < child.length; i++) {
    					if (child[i].nodeType == 1 && child[i].name != undefined) {
							child[i].style.display = "";
						}

    				}
    				if (pReDraftFlag != "HAPYUI" || pReDraftFlag != "HABYUI") {
    					if (GetAttribute(pAPRLINE.GetSelectedRows(0)[0], "DATA9") == "Y") {
    						if (chkReporter)
    							Reporter.readOnly = true;
    						else
    							Reporter.readOnly = false;
    						Reporter.checked = true;
    					}
    					else {
    						if (chkReporter)
    							Reporter.readOnly = true;
    						else
    							Reporter.readOnly = false;
    						Reporter.checked = false;
    					}
    					
    					if (GetAttribute(pAPRLINE.GetSelectedRows(0)[0], "DATA8") == "Y") {
    						if (chkSuggester)
    							Suggester.readOnly = true;
    						else
    							Suggester.readOnly = false;
    						
    						Suggester.checked = true;
    					}
    					else {
    						if (chkSuggester)
    							Suggester.readOnly = true;
    						else
    							Suggester.readOnly = false;
    						
    						Suggester.checked = false;
    					}
    				}
    				else {
    					Reporter.checked = false;
    					Suggester.checked = false;
    				}
    			}
    			OnSelChangeDoEvent(pSelectedRow);
    			rowclickevent = true;
    		}
    	}
    }
    catch (e) {
        alert("OnSelChange_onclick :: " + e.description);
    }
}
//#############################################################################################################################################결재선 추가 함수 APRLINEATTENDADDFunction()
function APRLINEATTENDADDFunction(pCurSelectedRow, Mode) {
    var pAPRLINE = new ListView();     
    pAPRLINE.LoadFromID("lvAPRLINE");
    
	var pCurSelRow = pAPRLINE.GetSelectedRows(); 
	
	var treeView = new TreeView(); //treeview 선언 
    treeView.LoadFromID("FromTreeView"); //treeview 로드
  
	var selnode = treeView.GetSelectNode();//TreeView.selectedIndex;
	
	if(pCurSelectedRow == null)
	{
		if(Mode == "PERSON")
		{
			var pCurSelectedRow = pCurSelRow[0];
			if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2"))//TreeView.getvalue(selnode, "EXTENSIONATTRIBUTE2"))
			{
				var pAlertContent = strLang250 + "<br> " + strLang251;
				OpenAlertUI(pAlertContent);	  
			}
		}
		else if(Mode == "DEPT")
		{
			var pCurSelectedRow = selnode;//TreeView.selectedIndex;
			var pAlertContent = strLang250 + "<br> " + strLang251;
			OpenAlertUI(pAlertContent);	  
		}
	} else if (Mode == "DEPT") {
		if (GetEntryInfo(pCurSelectedRow.GetNodeData("CN")) == "N") {
			var pAlertContent = strLang1105;
			OpenAlertUI(pAlertContent);
			return;
		}
	}
    
    var p_PrevAprStat = "";
	if(pCurSelRow.length != 0)
	{
		var p_PrevRow = null;
		if( p_PrevRow != null)
		{
			var p_PrevAprStat = p_PrevRow[5].innerText;
			p_PrevAprStat = ConvertAprLineState(p_PrevAprStat , "code");			
		}
	}
	if(p_PrevAprStat == "003" && pReDraftFlag == "DRAFT")   
	{
		var pAlertContent = "" + strLang293 + "";
		OpenAlertUI(pAlertContent);
	}
	else if(pReDraftFlag == "REDRAFT")                     
	{                     
		if(p_PrevAprStat == "003" || p_PrevAprStat == "004" || p_PrevAprStat == "002" )
		{
			AprLineChangeType();
			AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
			pReDraftAprLineChangeFlag = true;
		}else{
			AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
		}	
	}else{
		if(pReDraftAprLineFlag)
		{
			if(p_PrevRow != null)
			{ 
				if(p_PrevAprStat == "002" && GetAttribute(p_PrevRow[0], "DATA4") == pUserID)
				{
					var pAlertContent = "" + strLang319 + "";
					OpenAlertUI(pAlertContent);
				}else{
					AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
				}
			}else{
				AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
			}
		}else{
			AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
		}
	}
}

//S버젼
function SAPRLINEATTENDADDFunction(pCurSelectedRow, Mode) {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pCurSelRow = pAPRLINE.GetSelectedRows();

    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    var selnode = treeView.GetSelectNode();
    if (pCurSelectedRow == null) {
        if (Mode == "PERSON") {
            var pCurSelectedRow = pCurSelRow[0];
            if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2")) {
                var pAlertContent = strLangS250 + "<br> " + strLangS251;
                OpenAlertUI(pAlertContent);
            }
        }
        else if (Mode == "DEPT") {
            var pCurSelectedRow = selnode;
            var pAlertContent = strLangS250 + "<br> " + strLangS251;
            OpenAlertUI(pAlertContent);
        }
    }
    var p_PrevAprStat = "";
    var pCurSelRowRows;
    if (pAPRLINE.GetDataRows().length != 0) {
        pCurSelRowRows = pAPRLINE.GetDataRows();
        if (pCurSelRowRows != null) {
            p_PrevAprStat = GetAttribute(pCurSelRowRows[0], "DATA12");
        }
    }
    
    if (p_PrevAprStat == "003" && pReDraftFlag == "DRAFT") {
        var pAlertContent = strLangS250 + "<br> " + strLangS251;
        OpenAlertUI(pAlertContent);
    }
    else if (pReDraftFlag == "REDRAFT") {
        if (p_PrevAprStat == "003" || p_PrevAprStat == "004" || p_PrevAprStat == "002") {
            AprLineChangeType();
            AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
            pReDraftAprLineChangeFlag = true;
        } else {
            AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
            pReDraftAprLineChangeFlag = true;
        }
    } else {
        if (pReDraftAprLineFlag) {
            if (pCurSelRowRows[0] != null) {
			    if (p_PrevAprStat == "002" && GetAttribute(pCurSelRowRows[0], "DATA4") == pOrgApruserid) {
			    	//2018-11-12 배현상, pUserID로 할 경우 대리결재자가 최종결재선을 바꿀 수 있는 오류 수정
                    var pAlertContent = strLangS254;
                    OpenAlertUI(pAlertContent);
                } else {
                    AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
                }
            } else {
                AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
            }
        } else {
            AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
        }
    }
}
//회람
function APRLINEATTENDADDFunctionCC(pCurSelectedRow, Mode) {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");

        var pCurSelRow = pAPRLINE.GetDataRows();

        if (pCurSelRow[0] != undefined && pCurSelRow[0].id == "pAPRLINE_TR_noItems") 
            pAPRLINE.DeleteRow("pAPRLINE_TR_noItems")

        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeViewCC");

        var selnode = treeView.GetSelectNode();

        if (pCurSelectedRow == null) {
            if (Mode == "PERSON") {
                var pCurSelectedRow = pCurSelRow[0];
            } else if (Mode == "DEPT") {
                var pCurSelectedRow = selnode;
            } else if (Mode == "SEARCH") {
            	var pCurSelectedRow = pCurSelRow[0];
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
            AprLineAddUserCC(Mode, pCurSelRow, pCurSelectedRow);
        }

    } catch (e) {
        alert("APRLINEATTENDADDCC Function :: " + e.description);
    }
}

function aprLineAddDeptUser(mode, xmlData) {
	
	try {
		//console.log("xmlData : " + xmlData);
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
				var pAlertContent = "";

				if (approvalFlag == "G") {
					pAlertContent = strLang824;
				} else {
					pAlertContent = strLangS824;
				}

	            OpenAlertUI(pAlertContent);
	            continue;
	        }
		
            pparsingXML = "<LISTVIEWDATA><HEADERS>";
            if (approvalFlag == 'S') {
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>120</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>70</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>140</WIDTH></HEADER>";
            } else {
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>100</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>100</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>130</WIDTH></HEADER>";
            }
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
            pparsingXML = pparsingXML + "<VALUE><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA5")[i]) + "]]></VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA7")[i]) + "]]></VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE><![CDATA[" + getNodeText(GetElementsByTagName(xmlData, "DATA6")[i]) + "]]></VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            if (approvalFlag == 'S') {
            	pparsingXML = pparsingXML + "<VALUE>" + strLangAprType17 + "</VALUE>";
            } else {
            	pparsingXML = pparsingXML + "<VALUE>" + strLangDocState15 + "</VALUE>";
            }
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


function AprLineAddUserCC(Mode, tr, pSelectedRow) {
    try {
        if (pSelectedRow != null) {
            var treeView = new TreeView();
            treeView.LoadFromID("FromTreeViewCC");

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
                if (approvalFlag == 'S') {
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>50</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>120</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>70</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>140</WIDTH></HEADER>";
                } else {
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>100</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>100</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
                	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>130</WIDTH></HEADER>";
                }
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
                //회람 docstate
                pparsingXML = pparsingXML + "<DATA11>015</DATA11>";
                pparsingXML = pparsingXML + "<DATA12>001</DATA12>";
                pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(preWriterName1) + "</DATA13>";		
                pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(preWriterName2) + "</DATA14>";		
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
                if (approvalFlag == 'S') {
                	pparsingXML = pparsingXML + "<VALUE>" + strLangAprType17 + "</VALUE>";
                } else {
                	pparsingXML = pparsingXML + "<VALUE>" + strLangDocState15 + "</VALUE>";
                }
                pparsingXML = pparsingXML + "</CELL><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + strLang72 + "</VALUE>";
                pparsingXML = pparsingXML + "</CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>";
            } else if (Mode == "DEPT") {
            } else if (Mode == "SEARCH") {
            	var preDeptID = GetAttribute(pSelectedRow, "DATA3");
        		var preDeptName = pSelectedRow.cells[1].innerText;
        		var preDeptJobTitle = pSelectedRow.cells[2].innerText;
        		var preDeptName1 = GetAttribute(pSelectedRow, "DATA9");
        		var preDeptName2 = GetAttribute(pSelectedRow, "DATA10");
        		var preWriterName1 = GetAttribute(pSelectedRow, "DATA7");
        		var preWriterName2 = GetAttribute(pSelectedRow, "DATA8");
        		var preDeptJobTitle1 = GetAttribute(pSelectedRow, "DATA11");
        		var preDeptJobTitle2 = GetAttribute(pSelectedRow, "DATA12");
            	
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
            	//회람 docstate
            	pparsingXML = pparsingXML + "<DATA11>015</DATA11>";
            	pparsingXML = pparsingXML + "<DATA12>001</DATA12>";
            	pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(preWriterName1) + "</DATA13>";		
            	pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(preWriterName2) + "</DATA14>";		
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
            	if (approvalFlag == 'S') {
            		pparsingXML = pparsingXML + "<VALUE>" + strLangAprType17 + "</VALUE>";
            	} else {
            		pparsingXML = pparsingXML + "<VALUE>" + strLangDocState15 + "</VALUE>";
            	}
            	pparsingXML = pparsingXML + "</CELL><CELL>";
            	pparsingXML = pparsingXML + "<VALUE>" + strLang72 + "</VALUE>";
            	pparsingXML = pparsingXML + "</CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>";
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
        alert("AprLineAddUserCC :: " + e.description);
    }
}

//#############################################################################################################################################결재선 삭제 더블클릭 이벤트 APRLINEDEPTADD()
function APRDEPTADD() {
    if (getNodeText(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES")) == "") {
        OpenAlertUI(strLang295);
        return;
    }
    var checkhapyu = CheckHapYuiCellValue();
    if(!checkhapyu){
        return;
    }
    var RtnVal = true;
    if (pHapyuiArea != 0)   
        RtnVal = true;
    if (RtnVal) {
        aprlinecount = 0;
        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");

        var pTreeSelNode = treeView.GetSelectNode();
        
        if (approvalFlag == "S") {
        	SAPRLINEATTENDADDFunction(pTreeSelNode, "DEPT");
        } else {
        	APRLINEATTENDADDFunction(pTreeSelNode, "DEPT");
        }
    }
}
//############################################################################################################################################# 결재순번(Down) 1)
function AprlineDown_onclick() {
	if (approvalFlag == "S") {
		APRLINESNDownFunction();
	} else {
		APRLINESNDownFunction();
		aprlinecount = 0;
		//LineAprTyepSetAll();
		LineAprTyepSetAll_DELETE_ADD();
	}
}
//############################################################################################################################################# 결재순번(Down) 2)
function APRLINESNDownFunction() {
    try {
    	if (approvalFlag == "S") {
    		var pAPRLINE = new ListView();
            pAPRLINE.LoadFromID("lvAPRLINE");
            var pSelectedRow = pAPRLINE.GetSelectedRows();
            
            if ($("input:checkbox[id='passAprLine']").is(":checked") && (GetAttribute(pSelectedRow[0], "DATA12") == "004" || GetAttribute(pSelectedRow[0], "DATA12") == "003" || GetAttribute(pSelectedRow[0], "DATA12") == "002")) {
            	OpenAlertUI("기결재통과시 기결재자의 결재선은 변경할 수 없습니다.");
            	return;
            }

            if (pSelectedRow[0] == undefined) {
                OpenAlertUI(strLangS574);
                return;
            }

            if ($("input:checkbox[id='passAprLine']").is(":checked") && (GetAttribute(pSelectedRow[0], "DATA4") != null ? GetAttribute(pSelectedRow[0], "DATA4").toLowerCase() : "") == pUserID.toLowerCase() && pSelectedRow[0].childNodes[0].innerHTML == "1") {
                OpenAlertUI(strLangS575);
                return;
            }

            var pSelAprLineState = GetAttribute(pSelectedRow[0], "DATA12");
            if (pSelectedRow.length != 0) {
                var p_NextSelRow = pAPRLINE.GetDataRows()[Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) + 1];

                // 기안자를 선택 후 아래로 이동시킬 때, 오류 발생하여 수정. 2020-10-16 홍대표.
                if (!p_NextSelRow) {
                	OpenAlertUI(strLangS575);
					return;
                }

                if (p_NextSelRow.getAttribute("data12") != null && (p_NextSelRow.getAttribute("data12") == "003" || p_NextSelRow.getAttribute("data12") == "004")) {
                	OpenAlertUI(strLangS576);
                	return;
                }

                
                if ((GetAttribute(p_NextSelRow, "DATA4") != null ? GetAttribute(p_NextSelRow, "DATA4").toLowerCase() : "") == pUserID.toLowerCase() && p_NextSelRow.childNodes[0].innerHTML == "1") {
                    OpenAlertUI(strLangS576);
                    return;
                }
                if (GetAttribute(pSelectedRow[0], "DATA5") == "N") {
                    if (pSelectedRow[0].cells[4].childNodes[0].value == strAprType3 || pSelectedRow[0].cells[4].childNodes[0].value == strAprType4) {
                        OpenAlertUI(strLangS577);
                        return;
                    }

                    if (GetAttribute(p_NextSelRow, "DATA5") == "N") {
                        if (p_NextSelRow.cells[4].childNodes[0].value == strAprType3 || p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                            OpenAlertUI(strLangS576);
                            return;
                        }
                    }

                }
                else {
                    if (GetAttribute(p_NextSelRow, "DATA5") == "N") {
                        if (p_NextSelRow.cells[4].childNodes[0].value == strAprType3 || p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                            OpenAlertUI(strLangS576);
                            return;
                        }
                    }
                }
                if (p_NextSelRow != null) {
                    var p_NextAprStat = GetAttribute(p_NextSelRow, "DATA12");
                    if ((pSelAprLineState == "003" || p_NextAprStat == "003") && pReDraftFlag == "DRAFT") {
                        var pAlertContent = strLangS237;
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                    else if (pReDraftFlag == "REDRAFT") {
                        if (pSelAprLineState == "002" || pSelAprLineState == "003" || pSelAprLineState == "004") {
                            Ans = true;
                            if (Ans) {
                                AprLineChangeType();
                                DoAprLineDown(pSelectedRow);
                                pReDraftAprLineChangeFlag = true;                         
                            }
                        }
                        else {
                            DoAprLineDown(pSelectedRow);                      
                        }
                    }
                    else {
                        var temproevalue = getNodeText(pSelectedRow[0].cells[0]);

                        if (pReDraftAprLineFlag) {
                            if (((p_NextAprStat == "002" || p_NextAprStat == "005") && GetAttribute(p_NextSelRow, "DATA4") == pUserID || p_NextAprStat == "003")) {
                                var pAlertContent = strLangS239;
                                OpenAlertUI(pAlertContent);
                                return;
                            }
                            else if ((pSelAprLineState == "002" && GetAttribute(pSelectedRow[0], "DATA12") == pUserID)) {
                                var pAlertContent = strLangS239;
                                OpenAlertUI(pAlertContent);
                                return;
                            }
                            else if (CurAprLine > temproevalue) {
                                var pAlertContent = strLangS241;
                                OpenAlertUI(pAlertContent);
                                return;
                            }
                            else {
                                DoAprLineDown(pSelectedRow);                         
                            }
                        }
                        else {
                            DoAprLineDown(pSelectedRow);                                                  
                        }
                    }
                }
            }
    	} else {
    		var pAPRLINE = new ListView();
    		pAPRLINE.LoadFromID("lvAPRLINE");
    		var pSelectedRow = pAPRLINE.GetSelectedRows();
    		
    		if ($("input:checkbox[id='passAprLine']").is(":checked") && (GetAttribute(pSelectedRow[0], "DATA12") == "004" || GetAttribute(pSelectedRow[0], "DATA12") == "003" || GetAttribute(pSelectedRow[0], "DATA12") == "002")) {
				OpenAlertUI("기결재통과시 기결재자의 결재선은 변경할 수 없습니다.");
				return;
    		}
    		
    		if(pSelectedRow[0] == undefined){
    			OpenAlertUI(strLangS574);
    			return;            
    		}
    		
    		if(pSelectedRow[0].getAttribute("DATA4").toLowerCase() == pUserID.toLowerCase() && pSelectedRow[0].childNodes[0].innerHTML == "1")
    		{
    			OpenAlertUI(strLang306);    
    			return;
    		}
    		
    		
    		var pSelAprLineState = pSelectedRow[0].getAttribute("DATA12");
    		if (pSelectedRow.length != 0) {
    			var p_NextSelRow = pAPRLINE.GetDataRows()[Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) + 1];
    			
    			if ($("input:checkbox[id='passAprLine']").is(":checked") && p_NextSelRow.getAttribute("data12") != null && (p_NextSelRow.getAttribute("data12") == "003" || p_NextSelRow.getAttribute("data12") == "004")) {
    				OpenAlertUI(strLangS576);
    				return;
    			}
    			
    			if(p_NextSelRow == undefined || p_NextSelRow.getAttribute("DATA4").toLowerCase() == pUserID.toLowerCase() && p_NextSelRow.childNodes[0].innerHTML == "1") {
    				OpenAlertUI(strLangS576);
    				return;
    			} 
    			
    			if(pSelectedRow[0].getAttribute("DATA5") == "N") { 
//    				if(pSelectedRow[0].cells[4].childNodes[0].options[2].selected == true || pSelectedRow[0].cells[4].childNodes[0].options[3].selected == true) {
//    					OpenAlertUI(strLang552);    
//    					return;
//    				}
//    				
//    				if(p_NextSelRow.getAttribute("DATA5") == "N") {
//    					if(p_NextSelRow.cells[4].childNodes[0].options[2].selected == true || p_NextSelRow.cells[4].childNodes[0].options[3].selected == true) {
//    						OpenAlertUI(strLang551);    
//    						return;
//    					}
//    				}
    			} else {
    				if(p_NextSelRow.getAttribute("DATA5") == "N") {
//    					if(p_NextSelRow.cells[4].childNodes[0].options[2].selected == true || p_NextSelRow.cells[4].childNodes[0].options[3].selected == true) {
//    						OpenAlertUI(strLangS576); 
//    						return;
//    					}
    				}
    			}
    			
    			if (p_NextSelRow != null) {
    				var p_NextAprStat = GetAttribute(p_NextSelRow, "DATA12");
    				if ((pSelAprLineState == "003" || p_NextAprStat == "003") && pReDraftFlag == "DRAFT") {
    					var pAlertContent = strLang306;
    					OpenAlertUI(pAlertContent);
    					return;
    				}
    				else if (pReDraftFlag == "REDRAFT") {
    					if (pSelAprLineState == "002" || pSelAprLineState == "003" || pSelAprLineState == "004") {
    						Ans = true;
    						if (Ans) {
    							AprLineChangeType();
    							DoAprLineDown(pSelectedRow);
    							pReDraftAprLineChangeFlag = true;                          
    						}
    					}
    					else {
    						DoAprLineDown(pSelectedRow);                      
    					}
    				}
    				else {
    					if (pReDraftAprLineFlag) {
    						if (((p_NextAprStat == "002" || p_NextAprStat == "005") && GetAttribute(p_NextSelRow, "DATA4") == pUserID || p_NextAprStat == "003")) {
    							var pAlertContent = strLang310;
    							OpenAlertUI(pAlertContent);
    							return;
    						}
    						else if ((pSelAprLineState == "002" && GetAttribute(pSelectedRow[0], "DATA12") == pUserID)) {
    							var pAlertContent = strLang239;
    							OpenAlertUI(pAlertContent);
    							return;
    						}
    						else if (CurAprLine > pSelectedRow[0].cells[0].innerText) {
    							var pAlertContent = strLang241;
    							OpenAlertUI(pAlertContent);
    							return;
    						}
    						else {
    							DoAprLineDown(pSelectedRow);                         
    						}
    					}
    					else {
    						DoAprLineDown(pSelectedRow);                      
    					}
    				}
    			}
    		}
    	}
    } catch (e) {
        alert("APRLINESNDownFunction :: " + e.description);
    }
}
//############################################################################################################################################# 결재순번(Down) 3)
function ChangeAprLineDown(CurSelRow, p_NextSelRow) {
    var p_NextAprStat = p_NextSelRow.cells(0).DATA12;
    if ((pSelAprLineState == "003" || p_NextAprStat == "003") && pReDraftFlag == "DRAFT") {
        var pAlertContent = strLang237;
        OpenAlertUI(pAlertContent);
        return;
    }
    else if (pReDraftFlag == "REDRAFT") {
        if (pSelAprLineState == "002" || pSelAprLineState == "003" || pSelAprLineState == "004") {
            Ans = true;
            if (Ans) {
                DoAprLineDown(CurSelRow);
                pReDraftAprLineChangeFlag = true;
            }
        }
        else {
            DoAprLineDown(CurSelRow);
        }
    }
    else {
        if (pReDraftAprLineFlag) {
            if ((p_NextAprStat == "002" && p_NextSelRow.cells(0).DATA4 == pUserID)) {
                var pAlertContent = strLang239;
                OpenAlertUI(pAlertContent);
                return;
            } else {
                DoAprLineDown(CurSelRow);
            }
        } else {
            DoAprLineDown(CurSelRow);
        }
    }
}
//############################################################################################################################################# 결재순번(Down) 4)
function DoAprLineDown(pSelectedRow) {
    try {
    	if (approvalFlag == "S") {
    		var RowDownCheck;
            var pAPRLINE = new ListView();
            pAPRLINE.LoadFromID("lvAPRLINE");

            var pTotalRows = pAPRLINE.GetDataRows();
            var pTotalRowsLen = pTotalRows.length;

            var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

            var CIndex = pSelectedIndex;
            var NIndex;
            var Rtnval = "N";

            NIndex = pSelectedIndex + 1;
            if (NIndex < pTotalRowsLen) {
                RowDownCheck = getNodeText(pTotalRows[NIndex].cells[0]);

                setNodeText(pTotalRows[NIndex].cells[0],getNodeText(pTotalRows[CIndex].cells[0]));
                setNodeText(pTotalRows[CIndex].cells[0],RowDownCheck);
                
                Rtnval = "Y";
            }
            if (Rtnval == "Y")
                pAPRLINE.RowMoveDown();
    	} else {
    		var RowDownCheck;
    		var pAPRLINE = new ListView();
    		pAPRLINE.LoadFromID("lvAPRLINE");
    		
    		var pTotalRows = pAPRLINE.GetDataRows();
    		var pTotalRowsLen = pTotalRows.length;
    		
    		var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);
    		
    		var CIndex = pSelectedIndex;
    		var NIndex;
    		var Rtnval = "N";
    		
    		NIndex = pSelectedIndex + 1;
    		if (NIndex + 1 != pTotalRowsLen) {
    			RowDownCheck = pTotalRows[NIndex].cells[0].innerText;
    			var localCheck = getNodeText(pTotalRows[CIndex].cells[0]);
    			var OrgRowDownCheck = RowDownCheck;
    			var OrglocalCheck = localCheck;
    			
    			RowDownCheck = RowDownCheck.replace("⊙", "").replace("★", "");
    			localCheck = localCheck.replace("⊙", "").replace("★", "");
    			
    			if (OrglocalCheck.indexOf("⊙") > -1) {
    				RowDownCheck = "⊙" + RowDownCheck;
    			}
    			if (OrglocalCheck.indexOf("★") > -1) {
    				RowDownCheck = "★" + RowDownCheck;
    			}
    			if (OrgRowDownCheck.indexOf("⊙") > -1) {
    				localCheck = "⊙" + localCheck;
    			}
    			if (OrgRowDownCheck.indexOf("★") > -1) {
    				localCheck = "★" + localCheck;
    			}
    			
    			if (CrossYN()) {
    				setNodeText(pTotalRows[NIndex].childNodes[0] , localCheck);
    				setNodeText(pTotalRows[CIndex].childNodes[0] , RowDownCheck);
    			}
    			else {
    				setNodeText(pTotalRows[NIndex].cells[0] , localCheck);
    				setNodeText(pTotalRows[CIndex].cells[0] , RowDownCheck);
    			}
    			Rtnval = "Y";
    		}
    		else {
    			var pAlertContent = "" + strLang306 + "";
    			OpenAlertUI(pAlertContent);
    			return;
    		}
    		if (Rtnval == "Y")
    			pAPRLINE.RowMoveDown();
    	}
    } catch (e) {
        alert("DoAprLineDown :: " + e.description);
    }
}
//############################################################################################################################################# 결재순번(UP) 1)
function AprlineUpper_onclick() {
	if (approvalFlag == "S") {
		APRLINESNUPPERFunction();
	} else {
		APRLINESNUPPERFunction();
		aprlinecount = 0;
		//LineAprTyepSetAll();
		LineAprTyepSetAll_DELETE_ADD();
	}
}
//############################################################################################################################################# 결재순번(UP) 2)

function APRLINESNUPPERFunction() {
    try {
    	if (approvalFlag == "S") {
    		var pAPRLINE = new ListView();
            pAPRLINE.LoadFromID("lvAPRLINE");
            var pSelectedRows = pAPRLINE.GetSelectedRows();
            
            if ($("input:checkbox[id='passAprLine']").is(":checked") && (GetAttribute(pSelectedRows[0], "DATA12") == "003" || GetAttribute(pSelectedRows[0], "DATA12") == "002")) {
            	OpenAlertUI("기결재통과시 기결재자의 결재선은 변경할 수 없습니다.");
            	return;
            }

            if (pSelectedRows[0] == undefined) {
                OpenAlertUI(strLangS574);
                return;
            }

            if ((GetAttribute(pSelectedRows[0], "DATA4") != null ? GetAttribute(pSelectedRows[0], "DATA4").toLowerCase() : "") == pUserID.toLowerCase() && pSelectedRows[0].childNodes[0].innerHTML == "1") {
                OpenAlertUI(strLangS575);
                return;
            }

            if (pSelectedRows.length != 0) {
                var p_NextSelRow = pAPRLINE.GetDataRows()[Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) - 1];
                if (p_NextSelRow == undefined)
                    return;

                if (GetAttribute(pSelectedRows[0], "DATA5") == "N") {
                    if (pSelectedRows[0].cells[4].childNodes[0].value == strAprType3 || pSelectedRows[0].cells[4].childNodes[0].value == strAprType4) {
                        OpenAlertUI(strLangS577);
                        return;
                    }
                    if (p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                        OpenAlertUI(strLangS287);
                        return;
                    }
                    if (pAPRLINE.GetDataRows().length != parseInt(pSelectedRows[0].childNodes[0].innerHTML)) {
                        if (GetAttribute(p_NextSelRow, "DATA5") == "N") {
                            if (p_NextSelRow.cells[4].childNodes[0].value == strAprType3 || p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                                OpenAlertUI(strLangS576);
                                return;
                            }
                        }
                    }
                }
                else {
                    if (GetAttribute(p_NextSelRow, "DATA5") == "N") {
                        if (p_NextSelRow.cells[4].childNodes[0].value == strAprType3 || p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                            OpenAlertUI(strLangS576);
                            return;
                        }
                    }
                }
                if (pSelAprLineState == "003" && pReDraftFlag != "REDRAFT") {
                    var pAlertContent = strLangS237;
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else if (pReDraftFlag == "REDRAFT") {
                    if (pSelAprLineState == "002" || pSelAprLineState == "003" || pSelAprLineState == "004" || GetAttribute(pSelectedRows[0], "DATA4") == pUserID) {
                        Ans = true;
                        if (Ans) {
                            UpperAprLineSN(pSelectedRows);
                            AprLineChangeType();
                            pReDraftAprLineChangeFlag = true;
                        }
                    } else {
                        UpperAprLineSN(pSelectedRows);               
                    }
                }
                else {
                    if (pReDraftAprLineFlag) {
                        var TmpAprLineState = GetAttribute(pSelectedRows[0], "DATA12");
                        var tempcellvalue = getNodeText(pSelectedRows[0].cells[0]);
                        if (((TmpAprLineState == "002" || TmpAprLineState == "005") && GetAttribute(pSelectedRows[0], "DATA4") == pUserID || tempcellvalue == "1")) {
                            var pAlertContent = strLangS245;
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                        else if (CurAprLine > tempcellvalue) {
                            var pAlertContent = strLangS241;
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                        else {
                            UpperAprLineSN(pSelectedRows);                    
                        }
                    } else {
                        UpperAprLineSN(pSelectedRows);                
                    }
                }
            }
    	} else {
    		var pAPRLINE = new ListView();
    		pAPRLINE.LoadFromID("lvAPRLINE");
    		var pSelectedRows = pAPRLINE.GetSelectedRows();
    		
    		if ($("input:checkbox[id='passAprLine']").is(":checked") && (GetAttribute(pSelectedRows[0], "DATA12") == "004" || GetAttribute(pSelectedRows[0], "DATA12") == "003" || GetAttribute(pSelectedRows[0], "DATA12") == "002")) {
    			OpenAlertUI("기결재통과시 기결재자의 결재선은 변경할 수 없습니다.");
    			return;
    		}
    		
    		if(pSelectedRows[0] == undefined){
    			OpenAlertUI(strLangS574);
    			return;            
    		}
    		
    		if (pSelectedRows.length != 0) {
    			if (pSelectedRows[0].childNodes[0].innerHTML.replace("★","").replace("⊙","") == 1) {
    				var pAlertContent = "" + strLang306 + "";
    				OpenAlertUI(pAlertContent);
    				return;
    			}
    			
    			if (pSelAprLineType == "003" && pReDraftFlag == "DRAFT") {
    				var pAlertContent = "" + strLang307 + "";
    				OpenAlertUI(pAlertContent);
    				return;
    			}
    			else if (pReDraftFlag == "REDRAFT") {
    				if (pSelAprLineType == "002" || pSelAprLineType == "003" || pSelAprLineType == "004" || GetAttribute(pSelectedRows[0], "DATA4") == pUserID) {
    					Ans = true;
    					if (Ans) {
    						UpperAprLineSN(pSelectedRows);
    						AprLineChangeType();
    						pReDraftAprLineChangeFlag = true;
    					}
    				} else {
    					UpperAprLineSN(pSelectedRows);
    				}
    			} else {
    				if (pReDraftAprLineFlag) {
    					var TmpAprLineState = pSelectedRows[0].cells[5].innerText;
    					TmpAprLineState = ConvertAprLineState(TmpAprLineState, "Code");
    					
    					if (((TmpAprLineState == "002" || TmpAprLineState == "005") && GetAttribute(pSelectedRows[0], "DATA4") == pUserID || pSelectedRows[0].cells[0].innerText.replace("★").replace("⊙") == "1"))  //다음결재자가 결재선변경자인경우
    					{
    						var pAlertContent = "" + strLang310 + "";
    						OpenAlertUI(pAlertContent);
    						return;
    					} else {
    						UpperAprLineSN(pSelectedRows);
    					}
    				} else {
    					UpperAprLineSN(pSelectedRows);
    				}
    			}
    		}
    	}
    } catch (e) {
        alert("APRLINESNUPPERFunction :: " + e.description);
    }
}

//############################################################################################################################################# 결재순번(UP) 3)
function UpperAprLineSN(pSelectedRow) {
    try {
    	if (approvalFlag == "S") {
    		var pAPRLINE = new ListView();
            pAPRLINE.LoadFromID("lvAPRLINE");

            var pTotalRows = pAPRLINE.GetDataRows();
            var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);
            var RowUpCheck;
            var NIndex = pSelectedIndex - 1;
            var CIndex = pSelectedIndex;
            var Rtnval = "N";

            if (NIndex >= 0) {
                RowUpCheck = getNodeText(pTotalRows[NIndex].cells[0]);

                setNodeText(pTotalRows[NIndex].cells[0],getNodeText(pTotalRows[CIndex].cells[0]));
                setNodeText(pTotalRows[CIndex].cells[0],RowUpCheck);
                
                Rtnval = "Y";
            }

            if (Rtnval == "Y")
                pAPRLINE.RowMoveUp();
    	} else {
    		var pAPRLINE = new ListView(); 
    		pAPRLINE.LoadFromID("lvAPRLINE");
    		
    		var pTotalRows = pAPRLINE.GetDataRows();
    		var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);
    		var RowUpCheck;
    		var NIndex = pSelectedIndex - 1;
    		var CIndex = pSelectedIndex;
    		var Rtnval = "N";
    		
    		if (NIndex >= 0) {
    			RowUpCheck = pTotalRows[NIndex].cells[0].innerText; 
    			var localCheck = getNodeText(pTotalRows[CIndex].cells[0]);
    			var OrgRowUpCheck = RowUpCheck
    			var OrglocalCheck = localCheck
    			
    			RowUpCheck = RowUpCheck.replace("⊙", "").replace("★", "");
    			localCheck = localCheck.replace("⊙", "").replace("★", "");
    			
    			if (OrglocalCheck.indexOf("⊙") > -1) {
    				RowUpCheck = "⊙" + RowUpCheck;
    			}
    			if (OrglocalCheck.indexOf("★") > -1) {
    				RowUpCheck = "★" + RowUpCheck;
    			}
    			if (OrgRowUpCheck.indexOf("⊙") > -1) {
    				localCheck = "⊙" + localCheck;
    			}
    			if (OrgRowUpCheck.indexOf("★") > -1) {
    				localCheck = "★" + localCheck;
    			}
    			
    			if (CrossYN()) {
    				setNodeText(pTotalRows[NIndex].childNodes[0] , localCheck);
    				setNodeText(pTotalRows[CIndex].childNodes[0] , RowUpCheck);
    			}
    			else {
    				setNodeText(pTotalRows[NIndex].cells[0] , localCheck);
    				setNodeText(pTotalRows[CIndex].cells[0] , RowUpCheck);
    			}
    			Rtnval = "Y";
    		}
    		
    		if (Rtnval == "Y")
    			pAPRLINE.RowMoveUp();
    	}
    } catch (e) {
        alert("UpperAprLineSN :: " + e.description);
    }
}
//############################################################################################################################################# 결재유형 변경 
function AprLineChangeType() {
    try {
        var i;
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;

        var pTmpAprLineState = strAprState1;
        var pTmpAprLineStateName = strLangAprState1;

        for (i = 0; i < pTotalRowsLen - 1; i++) {
        	if ($("input:checkbox[id='passAprLine']").is(":checked") && ($(pTotalRows[i]).attr("DATA12") == "004" || $(pTotalRows[i]).attr("DATA12") == "003" || $(pTotalRows[i]).attr("DATA12") == "002")) {
        		continue;
        	}
            SetAttribute(pTotalRows[i], "DATA12", pTmpAprLineState);
            pTotalRows[i].cells[5].innerHTML = pTmpAprLineStateName;
            if(GetAttribute(pTotalRows[i], "DATA11", pTmpAprLineState) == strAprType14){
                SetAttribute(pTotalRows[i], "DATA11", pTmpAprLineState);
                pTotalRows[i].cells[5].innerHTML = pTmpAprLineStateName;
            }
        }

        pTmpAprLineState = strAprState2;
        pTmpAprLineStateName = strLangAprState2;
        SetAttribute(pTotalRows[i], "DATA12", pTmpAprLineState);
        pTotalRows[i].cells[5].innerHTML = pTmpAprLineStateName;
    } catch (e) {
        alert("AprLineChangeType :: " + e.description);
    }
}
//############################################################################################################################################# 부서에 사용자가 존재 여부 확인
function isgetUser(DeptID) {	
	var result = "";
	var rtnVal = true;
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getDeptMemberList.do",
		data : {
				deptID   : DeptID, 
				cell 	 : "displayName;description;title;telephoneNumber;extensionAttribute1",
				prop     : "department",
				type 	 : "user"
				},
		success: function(xml){
			result = xml;
		}        			
	});

    var nodes = SelectNodes(loadXMLString(result), "LISTVIEWDATA/ROWS/ROW");
    if(nodes.length < 0) rtnVal = false;
    if (rtnVal) {
        nodeCnt = nodes.length;

        if (nodeCnt > 0)
            rtnVal = true;
        else
            rtnVal = false;
    }

    return rtnVal;
}

//############################################################################################################################################# 부서에 수발신담당자 존재 여부 확인
function isReceiverChk(DeptID)
{
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/receiverChk.do",
		data : {
				deptID   : DeptID 
				},
		success: function(text){
			result = text;
		},
		error : function () {
			result = "false";
		}
	});
	
			
	if(result == "false") 
	    return false;
	else
	    return true;
}
//############################################################################################################################################# 결재선 중복 여부 확인 
function AprLineDupulicationChecking(Mode, selnode, pSelectedRow) {
    var chkDuplflag = false;
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");

    var totalRow = pAPRLINE.GetDataRows();
    for (i = 0; i < totalRow.length; i++) {
        if (Mode == "DEPT") {
            if (GetAttribute(totalRow[i], "DATA4") == selnode.GetNodeData("CN")) {
                chkDuplflag = true;
                break;
            }
        }
        else {
            if (GetAttribute(totalRow[i], "DATA4") == GetAttribute(pSelectedRow, "DATA2")) {
                if (GetAttribute(totalRow[i], "DATA4") == optGamsabu) {
                    if (totalRow[i].cells[4].innerText == strLangS51) {
                        chkDuplflag = true;
                        break;
                    }
                }
                else {
                    chkDuplflag = true;
                    break;
                }
            }
        }
    }
    pAPRLINE = null;
    return chkDuplflag;
}
var temppSelectedRow;
var tempMode;
var AprLineAddUser_pSelectedRow;
var AprLineAddUser_Mode;
var chkDuplflag;
function AprLineAddUser(Mode, tr, pSelectedRow) {
	if (approvalFlag == "S") {
		AprLineAddUser_pSelectedRow = pSelectedRow;
	    AprLineAddUser_Mode = Mode;
	    
	    if (pSelectedRow != null) {
	        var pparsingXML;
	        var i

	        var treeView = new TreeView();
	        treeView.LoadFromID("FromTreeView");

	        var selnode = treeView.GetSelectNode();
	        if (Mode == "DEPT") {
	            if (!isgetUser(selnode.GetNodeData("CN"))) {
	                var pAlertContent = strLangS222 + "<br>" + strLangS223;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	        }

	        if (Mode == "PERSON") {
	            if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2")) {
	                var pAlertContent = strLangS224;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	        }
	        else if (Mode == "DEPT") {
	            if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2")) {
	                var pAlertContent = strLangS225 + "<br>" + strLangS226;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	        }

	        if (AprLineDupulicationChecking(Mode, selnode, pSelectedRow)) {
	            if (Mode == "DEPT") {
	                var pAlertContent = strLangS227 + "<br>" + strLangS226;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            else {
	                var pInformationContent = strLangS228 + "<br>" + strLangS229;
	                if (CrossYN()) {
	                    var RtnVal = OpenInformationUI(pInformationContent, SAprLineAddUser_Complete);
	                    if (RtnVal)
	                        SAprLineAddUser_Complete(RtnVal);
	                }
	                else {
	                    var RtnVal = OpenInformationUI(pInformationContent, SAprLineAddUser_Complete);
	                    if(RtnVal)
	                        SAprLineAddUser_Complete(RtnVal);
	                }
	            }
	        }
	        else {
	            SAprLineAddUser_Complete(true);
	        }
	    }
	} else {
		if( pSelectedRow != null)
		{
			var pparsingXML;
			var i
			chkDuplflag = false;
			
			var treeView = new TreeView(); //treeview 선언 
			treeView.LoadFromID("FromTreeView"); //treeview 로드
			
			var selnode = treeView.GetSelectNode();
			if(Mode == "DEPT")
			{		    
				if(!isgetUser(selnode.GetNodeData("CN")))
				{
					var pAlertContent = "" + strLang291 + "<br>" + strLang292 + "";
					OpenAlertUI(pAlertContent);
					return;
				}
			}
			
			if(Mode == "PERSON")
			{
				if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2"))
				{
					var pAlertContent = "" + strLang293 + "";
					OpenAlertUI(pAlertContent);	
					return;  
				}
			}
			else if(Mode == "DEPT")
			{
				if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2"))
				{
					var pAlertContent = "" + strLang294 + "<br>" + strLang295 + "";
					OpenAlertUI(pAlertContent);	 
					return; 
				}
			}

			var pAPRLINE = new ListView();      //// ListView 선언
			pAPRLINE.LoadFromID("lvAPRLINE"); 
			
			var totalRow = pAPRLINE.GetDataRows();
			for(i=0;i< totalRow.length;i++)
			{		   
				if(Mode == "DEPT")
				{
					if(GetAttribute(totalRow[i],"DATA4") == selnode.GetNodeData("CN"))
					{
						chkDuplflag = true;
						break;
					}
				}
				else
				{
					if(GetAttribute(totalRow[i],"DATA4") == GetAttribute(pSelectedRow,"DATA2"))
					{
						if(GetAttribute(totalRow[i],"DATA4") == optGamsabu) 
						{					    
							if(totalRow[i].cells[4].innerText == totalRow[i].cells[4].innerText.replace("" + strLang2 + "", "") && totalRow[i].cells[4].innerText == totalRow[i].cells[4].innerText.replace("" + strLang3 + "", ""))
							{	
								chkDuplflag = true;
								break;
							}
						}
						else
						{	
							chkDuplflag = true;
							break;
						}
					}
				}
			}
			
			temppSelectedRow = pSelectedRow;
			tempMode = Mode;
			if($(pSelectedRow).attr("ABSENCE") != "" && $(pSelectedRow).attr("ABSENCE") != undefined) {
				var pInformationContent = "" + strLang1039 + "";
				OpenInformationUI(pInformationContent, OpenInformationUI_Result);
			} else {
				if($(pSelectedRow).attr("APPRLINETYPE") == "audit_add" || $(pSelectedRow).attr("JUNBUBYN") == "Y"
					|| $(pSelectedRow).attr("APPRLINETYPE") == "020" || $(pSelectedRow).attr("APPRLINETYPE") == "021") {
					chkDuplflag = false;
				}
				if (chkDuplflag) {
					var pInformationContent = "" + strLang296 + "<br>" + strLang297 + "";
					var ans = OpenInformationUI(pInformationContent, AprLineAddUser_Complete);
					
					if(ans) {
						AprLineAddUser_Complete(true);
					}
				}
				else {
					AprLineAddUser_Complete(true);
				}
			}
		}
	}
}

function OpenInformationUI_Result(Ans) {
	DivPopUpHidden();
	if (Ans) {
    }
    else {
        return;
    }
	
	if (chkDuplflag) {
		var pInformationContent = "" + strLang296 + "<br>" + strLang297 + "";
		var ans = OpenInformationUI(pInformationContent, AprLineAddUser_Complete);
		
		if(ans) {
			AprLineAddUser_Complete(true);
		}
	}
	else {
		AprLineAddUser_Complete(true);
	}
}

function AprLineAddUser_Complete(Ans) {
    DivPopUpHidden();
    if (Ans) {
    }
    else {
        return;
    }
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    var selnode = treeView.GetSelectNode();

    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");
    var AprLineRow = pAPRLINE.GetDataRows();
    AprLineAddIndex = AprLineRow.length;
    AprLineAddIndex = AprLineAddIndex + 1;

    if (AprLineAddIndex > 1) {
        if (AprLineRow[0].cells[4].innerText == "" + strLang6 + "" || AprLineRow[0].cells[4].innerText == "" + strLang74 + "") {
            var pAlertContent = "" + strLang298 + "<br>" + strLang299 + "";
            OpenAlertUI(pAlertContent);
            return;
        }
    }

    var pCompanyNAME;

    if (selnode.GetNodeData("EXTENSIONATTRIBUTE3") == "TopGroup")
        pCompanyNAME = selnode.GetNodeData("VALUE");
    else
        pCompanyNAME = selnode.GetNodeData("EXTENSIONATTRIBUTE3");

    var pDeptNm = temppSelectedRow.value;	//pSelectedRow.value 없지만 오류를 일으키진 않으므로 냅둔다.

    if (selnode.GetNodeData("EXTENSIONATTRIBUTE2") != companyID) {
        pDeptNm = temppSelectedRow.value + "(" + pCompanyNAME + ")";
    }

    var tr = pAPRLINE.GetSelectedRows();
    if (tr.length > 0 && InsertMode != "Add") {
        AprLineAddIndex = parseInt(tr[0].cells[0].innerText);
    }

    if (tempMode == "PERSON") {
        pparsingXML = AprLineUserAdd(AprLineAddIndex, AprLineRow, temppSelectedRow, selnode)
    }
    else if (tempMode == "DEPT") {
        pparsingXML = AprLineDeptAdd(AprLineAddIndex, AprLineRow, temppSelectedRow, selnode);
    }
    Resultxml = loadXMLString(pparsingXML);

    var tr = pAPRLINE.GetSelectedRows();
    var InitTr = pAPRLINE.GetDataRows();
    var MaxID = 0;

    for (var j = 0  ; j < InitTr.length  ; j++) {
        var curnum = Number(pAPRLINE.GetSelectedRowID(j).substring(pAPRLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAPRLINE.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }

    if (tr.length == 0 || InsertMode == "Add") {
        if (InitTr.length == 0) {
            if (document.getElementById("lvAPRLINE").innerHTML != "")
                document.getElementById("lvAPRLINE").innerHTML = "";

            var pAPRLINE = new ListView();
            pAPRLINE.SetID("lvAPRLINE");
            pAPRLINE.SetMulSelectable(false);
            pAPRLINE.SetRowOnClick("OnSelChange_onclick");
            pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
            pAPRLINE.SetSelectFlag(false);
            pAPRLINE.DataSource(Resultxml);
            pAPRLINE.DataBind("lvAPRLINE");
            if (CrossYN()) {
                pAPRLINE.GetDataRows()[0].cells[4].textContent = "" + strLang20 + "";
            }
            else {
                pAPRLINE.GetDataRows()[0].cells[4].innerText = "" + strLang20 + "";
            }
        }
        else {
        	var rowIndex = 0;
        	var objTr = null;
        	
        	if (tempMode == "PERSON") {
        		if(Resultxml.getElementsByTagName("APPRLINETYPE")[0].textContent == "audit_add"
            		|| Resultxml.getElementsByTagName("JUNBUBYN")[0].textContent == "Y") {
            		if(InitTr.length > 1) {
            			rowIndex = 1;
            		}
            	}
        	}
        	
            objTr = pAPRLINE.NewAddRow(rowIndex, "lvAPRLINE" + "_TR_" + eval(MaxID + 1));
            pAPRLINE.AddDataRow(objTr, Resultxml);
        }

        AprLineAddIndex = AprLineAddIndex + 1;
    }
    else {
        var idx = parseInt(pAPRLINE.GetSelectedIndexes().split(",")[0]);
        var selIdx = pAPRLINE.GetSelectedRows()[0].getAttribute("id");
        pAPRLINE.DeleteRow(selIdx);

        var objTr = pAPRLINE.NewAddRow(idx, selIdx);
        pAPRLINE.AddDataRow(objTr, Resultxml);
        pAPRLINE.SetSelectedID(selIdx);
    }
    setRep_Suggester();
    aprlinecount = 0;
    //LineAprTyepSetAll();
    LineAprTyepSetAll_DELETE_ADD();
}

function SAprLineAddUser_Complete(RtnVal)
{
    DivPopUpHidden();
    if (!RtnVal) {
    	return;
    }
    
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");

    var selnode = treeView.GetSelectNode();

    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    AprLineAddIndex = AprLineRow.length;
    AprLineAddIndex = AprLineAddIndex + 1;

    var pCompanyNAME;

    if (selnode.GetNodeData("EXTENSIONATTRIBUTE3") == "TopGroup")
        pCompanyNAME = selnode.GetNodeData("VALUE");
    else
        pCompanyNAME = selnode.GetNodeData("EXTENSIONATTRIBUTE3");

    var pDeptNm = AprLineAddUser_pSelectedRow.value;

    if (selnode.GetNodeData("EXTENSIONATTRIBUTE2") != companyID) {
        pDeptNm = AprLineAddUser_pSelectedRow.value + "(" + pCompanyNAME + ")";
    }

    var tr = pAPRLINE.GetSelectedRows();
    if (tr.length > 0 && InsertMode != "Add") {
        AprLineAddIndex = parseInt(getNodeText(tr[0].cells[0]));
    }

    if (AprLineAddUser_Mode == "PERSON") {
        pparsingXML = AprLineUserAdd(AprLineAddIndex, AprLineRow, AprLineAddUser_pSelectedRow, selnode)
    }
    else if (AprLineAddUser_Mode == "DEPT") {
        pparsingXML = AprLineDeptAdd(AprLineAddIndex, AprLineRow, AprLineAddUser_pSelectedRow, selnode);
    }

    Resultxml = loadXMLString(pparsingXML);

    var tr = pAPRLINE.GetSelectedRows();
    var InitTr = pAPRLINE.GetDataRows();
    var MaxID = 0;

    for (var j = 0; j < InitTr.length; j++) {
        var curnum = Number(pAPRLINE.GetSelectedRowID(j).substring(pAPRLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAPRLINE.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }

    if (InitTr.length == 0) {
        if (document.getElementById("APRLINE").innerHTML != "")
            document.getElementById("APRLINE").innerHTML = "";

        var pAPRLINE = new ListView();
        pAPRLINE.SetID("lvAPRLINE");
        pAPRLINE.SetMulSelectable(false);
        pAPRLINE.SetRowOnClick("OnSelChange_onclick");
        pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
        pAPRLINE.SetSelectFlag(false);
        pAPRLINE.SetHeightFree(true);
        pAPRLINE.DataSource(Resultxml);
        pAPRLINE.DataBind("APRLINE");
        pAPRLINE.SetSelectedIndex(0);
    }
    else {
        var objTr = pAPRLINE.NewAddRow(0, "lvAPRLINE" + "_TR_" + eval(MaxID + 1));
        pAPRLINE.AddDataRow(objTr, Resultxml);
        pAPRLINE.SetSelectedIndex(MaxID + 1);
    }
    AprLineAddIndex = AprLineAddIndex + 1; 
    
    LineAprTyepSet();
	if (AprLineAddUser_Mode == "PERSON") initJunGyul();
}




function AprLineUserAdd(AprLineAddIndex, AprLineRow, pSelectedRow, selnode)
{
    var pparsingXML = "<LISTVIEWDATA><HEADERS>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>30</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>60</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
    pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
    pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
    pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
    pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA2")) + "</DATA4>";
    pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
    pparsingXML = pparsingXML + "<DATA6>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA3")) + "</DATA6>";
    pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
    pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
    pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
    pparsingXML = pparsingXML + "<DATA10>" + selnode.GetNodeData("EXTENSIONATTRIBUTE2") + "</DATA10>";

    var nAprType = "";
    if (AprLineAddIndex > 1) {
        nAprType = GetProcessAprType(AprLineAddIndex, AprLineRow, "PERSON");

        if (nAprType == "")
        {
            for (i=0; i<GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES")).length; i++)
			{			
				if (getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[i].getElementsByTagName("CODE")[0]) == "001")
				{
				    nAprType = "001";
			    }
			}
        }

        if (GetAttribute(AprLineRow[AprLineAddIndex], "DATA11") == strAprType4 || GetAttribute(AprLineRow[AprLineAddIndex], "DATA11") == strAprType3) {
            pparsingXML = pparsingXML + "<DATA11>";
            if (InsertMode != "Add")
                pparsingXML = pparsingXML + tr[0].cells[0].DATA11 + "</DATA11>";
            else
                pparsingXML = pparsingXML + GetAttribute(AprLineRow[AprLineAddIndex], "DATA11") + "</DATA11>";
        }
        else {
            pparsingXML = pparsingXML + "<DATA11>" + nAprType + "</DATA11>";
        }
    }
    else {
        pparsingXML = pparsingXML + "<DATA11>" + MakeXMLString(SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE")[0], "CODE")) + "</DATA11>";
    }
    pparsingXML = pparsingXML + "<DATA12>" + strAprState1 + "</DATA12>";

    pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA7")) + "</DATA13>";
    pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA8")) + "</DATA14>";
    pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA9")) + "</DATA15>";
    pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA10")) + "</DATA16>";
    pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA11")) + "</DATA17>";
    pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA12")) + "</DATA18>";
    pparsingXML = pparsingXML + "<ABSENCE>" + MakeXMLString(GetAttribute(pSelectedRow, "ABSENCE")) + "</ABSENCE>";
	pparsingXML = pparsingXML + "<JUNBUBYN>" + MakeXMLString(GetAttribute(pSelectedRow, "JUNBUBYN")) + "</JUNBUBYN>";
	pparsingXML = pparsingXML + "<APPRLINETYPE>" + MakeXMLString(GetAttribute(pSelectedRow, "APPRLINETYPE")) + "</APPRLINETYPE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
	//pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pSelectedRow[0].cells[0].innerText) + "</VALUE>";
	pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA4")) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
	//pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pSelectedRow[0].cells[2].innerText) + "</VALUE>";
	pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA6")) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
	//pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pSelectedRow[0].cells[1].innerText) + "</VALUE>";
	pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(pSelectedRow, "DATA5")) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";

    if (AprLineAddIndex > 1) {
        if (GetAttribute(AprLineRow[AprLineAddIndex], "DATA11") == strAprType4 || GetAttribute(AprLineRow[AprLineAddIndex], "DATA11") == strAprType3) {
            pparsingXML = pparsingXML + "<VALUE>";

            if (InsertMode != "Add")
                pparsingXML = pparsingXML + tr[0].cells[4].innerText + "</VALUE>";
            else
                pparsingXML = pparsingXML + AprTypeToName(GetAttribute(AprLineRow[AprLineAddIndex], "DATA11")) + "</VALUE>";
        }
        else {
            pparsingXML = pparsingXML + "<VALUE>" + AprTypeToName(nAprType) + "</VALUE>";
        }
    }
    else {
        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE")[0], "NAME")) + "</VALUE>";
    }
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + strLangAprState1 + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL></CELL></ROW></ROWS></LISTVIEWDATA>";

    return pparsingXML;
}
function AprLineDeptAdd(AprLineAddIndex,AprLineRow,pSelectedRow ,selnode)
{
    var pparsingXML = "<LISTVIEWDATA><HEADERS>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>30</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>60</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
    pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
    pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
    pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
    pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(selnode.GetNodeData("CN")) + "</DATA4>";
    pparsingXML = pparsingXML + "<DATA5>" + "Y" + "</DATA5>";
    pparsingXML = pparsingXML + "<DATA6>" + MakeXMLString(selnode.GetNodeData("CN")) + "</DATA6>";
    pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
    pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
    pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
    pparsingXML = pparsingXML + "<DATA10>" + MakeXMLString(selnode.GetNodeData("EXTENSIONATTRIBUTE2")) + "</DATA10>";
    var nAprType = GetProcessAprType(AprLineAddIndex, AprLineRow, "DEPT");

    if (nAprType == "")
        nAprType = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[0], "CODE");


    if (pGamSaCount > 0 && pHapYuiCount <= 0)
	{
		pparsingXML = pparsingXML + "<DATA11>" + getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES"))[GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES")).length-1].getElementsByTagName("CODE")[0]) + "</DATA11>";				
	}
	else
	{
		pparsingXML = pparsingXML + "<DATA11>" + getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES"))[0].getElementsByTagName("CODE")[0]) + "</DATA11>";
	}
	pparsingXML = pparsingXML + "<DATA12>" + strAprState1 + "</DATA12>";
	
    var checkDept = false;
    //로직이 이상해서 주석처리. totalRow는 조직도 부서원리스트의 row 인데 두번째 사람하고 만 비교함. 이미 추가된 결재선에서 최종결재자 직전의 사람이 부서장인지 비교하기 위한 로직이면 더 말이 되는듯.
    //아래 로직대로 돌아가면 부서추가를 할 때, 조직도의 두번째 사람이 부서장이면 개인으로 추가되고 버그가 발생함.
    //2019-06-18 홍대표
//    if (SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[0], "CODE") == "011") {
//
//        var pUserList = new ListView();
//        pUserList.LoadFromID("pUserList");
//        var totalRow = pUserList.GetDataRows();
//
//        for (var j = 1; j <= totalRow.length; j++) 
//        {
//            if (GetAttribute(totalRow[1], "DATA1") == "user" && GetAttribute(totalRow[1], "DATA2") == selnode.GetNodeData("EXTENSIONATTRIBUTE9") && checkDept == false) {
//                pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(GetAttribute(totalRow[1], "DATA7")) + "</DATA13>";
//                pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(GetAttribute(totalRow[1], "DATA8")) + "</DATA14>";
//                pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(GetAttribute(totalRow[1], "DATA9")) + "</DATA15>";
//                pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(GetAttribute(totalRow[1], "DATA10")) + "</DATA16>";
//                pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(GetAttribute(totalRow[1], "DATA11")) + "</DATA17>";
//                pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(GetAttribute(totalRow[1], "DATA12")) + "</DATA18>";
//                pparsingXML = pparsingXML + "</CELL><CELL>";
//                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(totalRow[1], "DATA4")) + "</VALUE>";
//                pparsingXML = pparsingXML + "</CELL><CELL>";
//                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(totalRow[1], "DATA5")) + "</VALUE>";
//                pparsingXML = pparsingXML + "</CELL><CELL>";
//                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(totalRow[1], "DATA6")) + "</VALUE>";
//                pparsingXML = pparsingXML + "</CELL><CELL>";
//                checkDept = true;
//                break;
//            }
//        }
//    }

    if (checkDept == false) {
        pparsingXML = pparsingXML + "<DATA13>-</DATA13>";
        pparsingXML = pparsingXML + "<DATA14>-</DATA14>";
        pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(selnode.GetNodeData("DISPLAYNAME1")) + "</DATA15>"; 
        pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(selnode.GetNodeData("DISPLAYNAME2")) + "</DATA16>"; 
        pparsingXML = pparsingXML + "<DATA17>-</DATA17>";
        pparsingXML = pparsingXML + "<DATA18>-</DATA18>";

        pparsingXML = pparsingXML + "</CELL><CELL>";
        pparsingXML = pparsingXML + "<VALUE>-</VALUE>";
        pparsingXML = pparsingXML + "</CELL><CELL>";
        pparsingXML = pparsingXML + "<VALUE>-</VALUE>";
        pparsingXML = pparsingXML + "</CELL><CELL>";
        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(selnode.GetNodeData("VALUE")) + "</VALUE>";
        pparsingXML = pparsingXML + "</CELL><CELL>";
    }

    if (pGamSaCount > 0 && pHapYuiCount <= 0) {
        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE").length - 1], "NAME")) + "</VALUE>";
    }
    else {
        pparsingXML = pparsingXML + "<VALUE>" + AprTypeToName(nAprType) + "</VALUE>";
    }
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + strLangAprState1 + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>";
    return pparsingXML;
}
//############################################################################################################################################# 결재선리스트 이벤트 처리 
function CheckSignCellValue() {
    return true;
}

//회람
function APRLINEATTENDERDELFunctionCC() {
    try {
        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");

        var pSelectedRow = listview.GetSelectedRows();
        if (pSelectedRow.length != 0 && pSelectedRow != null && listview.GetSelectedIndexes().split(',')[0] != -1) {
			for (var i = 0; i < pSelectedRow.length; i++) {
				if (pSelectedRow[i].cells[5].innerText == strLang72) {
					DoDeleteCC(pSelectedRow);
				}
			}
        }
    } catch (e) {
        alert("APRLINEATTENDERDELFunction :: " + e.description);
    }
}

function DoDeleteCC(pSelectedRow) {
    try {
        var RowDelCheck;

        var listview = new ListView();
        listview.LoadFromID("pAPRLINE");

        var pTotalRows = listview.GetDataRows();
        var pSelectedIndex = listview.GetSelectedIndexes() == '' ? 0 : Number(listview.GetSelectedIndexes().split(',')[0]);
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
            var selIdx = listview.GetSelectedRows().length == 0 ? listview.GetDataRows()[0].getAttribute("id") : listview.GetSelectedRows()[0].getAttribute("id");
            listview.DeleteRow(selIdx);
        }
        
        // 2019-04-04 천성준 - 회람자 리스트 row제거 시, row가 0개일때 "데이터가 없습니다" 표출
        if (listview.GetDataRows().length <= 0) {
        	var objTr = document.createElement("TR");
        	objTr.setAttribute("id", "pAPRLINE_TR_noItems");
        		
        	var oText = document.createTextNode(strLang944);
        	var objTd = document.createElement("TD");
        	objTd.align = "center";
        	
        	var colCount = document.getElementById("pAPRLINE").getElementsByTagName("th").length;
        	objTd.setAttribute("colSpan", colCount);
        	objTd.appendChild(oText);
        	objTr.appendChild(objTd);
        	
        	document.getElementById("pAPRLINE").appendChild(objTr);
        }
    } catch (e) {
        alert("DoDelete :: " + e.description);
    }
}

//############################################################################################################################################# 결재선리스트 삭제 이벤트 
function APRLINEATTENDERDELFunction()
{
  try {
	  if (approvalFlag == "S") {
		  var pAPRLINE = new ListView();
	        pAPRLINE.LoadFromID("lvAPRLINE");
	        
	        var aprState = $(pAPRLINE.GetSelectedRows()).attr("DATA12");
	        
	        if ($("input:checkbox[id='passAprLine']").is(":checked") && (aprState == "004" || aprState == "003" || aprState == "004")) {
	        	OpenAlertUI("기결재통과시 기결재자의 결재선은 변경할 수 없습니다.")
	        	return;
	        }

	        var pSelectedRow = pAPRLINE.GetSelectedRows();

	        pSelAprLineState = GetAttribute(pSelectedRow[0], "DATA12");

	        if (pSelectedRow.length != 0 && pSelectedRow != null && pAPRLINE.GetSelectedIndexes().split(',')[0] != -1) {
	            if (pSelAprLineState == "003" && pReDraftFlag != "REDRAFT") {
	                var pAlertContent = strLangS247;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            else if (GetAttribute(pSelectedRow[0], "DATA8") == "Y")
	            {
	                var pAlertContent = strLangS626;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            else if (pReDraftFlag == "REDRAFT") {
	                var pDraftSN = getNodeText(pSelectedRow[0].cells[0]);
	                if (pSelAprLineState == "002" || pSelAprLineState == "003" || pSelAprLineState == "004" || pDraftSN == "1") {
	                    Ans = true;
	                    if (Ans) {
	                        AprLineChangeType();
	                        DoDelete(pSelectedRow);
	                        pReDraftAprLineChangeFlag = true;
	                    }
	                } else {
	                    DoDelete(pSelectedRow);
	                }
	            } else {
	                if (pReDraftAprLineFlag) {
	                    var TmpAprLineState = GetAttribute(pSelectedRow[0], "DATA12");
	                    var tempcellvalue = getNodeText(pSelectedRow[0].cells[0]);
	                    if ((TmpAprLineState == "002" || TmpAprLineState == "005") || tempcellvalue == "1") {
	                        var pAlertContent = strLangS249;
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    }
	                    else {
	                        DoDelete(pSelectedRow)
	                    }
	                } else {
	                    DoDelete(pSelectedRow)
	                }
	            }
	        }
	  } else {
		  var pAPRLINE = new ListView();      //// ListView 선언
		  pAPRLINE.LoadFromID("lvAPRLINE");
		  var pSelectedRow = pAPRLINE.GetSelectedRows();
		  
		  var aprState = $(pAPRLINE.GetSelectedRows()).attr("DATA12");
	        
		if ($("input:checkbox[id='passAprLine']").is(":checked") && (aprState == "004" || aprState == "003" || aprState == "004")) {
			OpenAlertUI("기결재통과시 기결재자의 결재선은 변경할 수 없습니다.")
			return;
		}
		  
		  //var pSelectedRow = APRLINE.multiselects;
		  //if(pSelectedRow.length != 0 && pSelectedRow != null && pSelectedRow.item(0).index != -1)
		  if(pSelectedRow.length != 0 && pSelectedRow != null && pAPRLINE.GetSelectedIndexes().split(',')[0] != -1)
		  {
			  if(pSelAprLineType == "003" && pReDraftFlag == "DRAFT")   //기안시 , 결재선 변경시 적용
			  {		    
				  var pAlertContent = "" + strLang315 + "";
				  OpenAlertUI(pAlertContent);
				  return;
			  }
			  else if(pReDraftFlag == "REDRAFT")                      //재기안시 적용
			  {
				  //var pDraftSN = pSelectedRow.item(0).cells(0).innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", ""); 
				  var pDraftSN = pSelectedRow[0].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", ""); 
				  if(pSelAprLineType == "002" || pSelAprLineType == "003" || pSelAprLineType == "004" || pDraftSN == "1")
				  {
					  Ans = true;
					  if(Ans)                                             //재기안시 결재선 변경시
					  {  
						  AprLineChangeType();
						  DoDelete(pSelectedRow);
						  pReDraftAprLineChangeFlag = true;
					  }
				  }else{
					  DoDelete(pSelectedRow);
				  }
			  }else{		
				  if(pReDraftAprLineFlag)
				  {
					  var TmpAprLineState = pSelectedRow[0].cells[5].innerText;
					  TmpAprLineState = ConvertAprLineState(TmpAprLineState , "Code");
					  if(( TmpAprLineState == "002" || TmpAprLineState == "005" ) || pSelectedRow[0].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "") == "1")
					  {
						  var pAlertContent = "" + strLang317 + "";
						  OpenAlertUI(pAlertContent);
						  return;
					  }else{
						  DoDelete(pSelectedRow)
					  }
				  }else{
					  DoDelete(pSelectedRow)
				  }
			  }
		  }
	  }
  } catch(e) {
    alert("APRLINEATTENDERDELFunction :: " + e.description);
  }
}

// 결재선 지정 -> 보고자  or 발의자 선택 -> 결재선 삭제,추가  -> 보고자 발의자 표기가 되지 않아   LineAprTypeSetAll()을 수정하여 함수 추가 , 
// 원복하려면  LineAprTypeSetALL_DELETE_ADD()함수를 지우고 LineAprTypeSetAll_DELETE_ADD() -> LineAprTypeSetAll()로 바꾸면됨.
function LineAprTyepSetAll_DELETE_ADD() {
	var auditCount1 = 0;
	var auditCount2 = 0;
	if (approvalFlag == "S") {
		var pAPRLINE = new ListView();
	    pAPRLINE.LoadFromID("lvAPRLINE");
	    var pTotalRows = pAPRLINE.GetDataRows();
	    for (var i = 0; i < pTotalRows.length; i++) {
	        var CurrentSn = getNodeText(pTotalRows[i].childNodes.item(0));

	        if (GetAttribute(pTotalRows[i], "DATA12") == "002")
	            ProSn = CurrentSn;

	        var p_isDept = GetAttribute(pTotalRows[i], "DATA5");
	        
	        if (GetAttribute(pTotalRows[i], "DATA12") == "004")
	            p_RejectFlag = true;

	        var p_StatusDis = (GetAttribute(pTotalRows[i], "DATA12") == "003" && !p_RejectFlag) ? "disabled" : "";
	        if (p_isDept == "Y") {
	            var AprTypeObj = SChangeAprlineType("group", GetAttribute(pTotalRows[i], "DATA11"));
	            if (AprTypeObj == "") {
	                pAPRLINE.DeleteRow(pTotalRows[i].id);
	            }
	            else {
	                if (GetAttribute(pTotalRows[i], "DATA12") == "015")
	                    p_StatusDis = "disabled";
	                
	                if ($("input:checkbox[id='passAprLine']").is(":checked") && (pTotalRows[i].getAttribute("DATA12") == "004" || pTotalRows[i].getAttribute("DATA12") == "003" || pTotalRows[i].getAttribute("DATA12") == "002")) {
	                	p_StatusDis = "disabled";
	                }
	                
	                AprTyepID = GetAttribute(pTotalRows[i], "id") + "select";
	                AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style=\"width:100%;\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
	                pTotalRows[i].childNodes[4].innerHTML = AprTypeObj;
	            }
	        } else {
	            if (pTotalRows.length == 1)
	                p_StatusDis = "disabled";
	            else {
	                if (CurrentSn == "1")
	                    p_StatusDis = "disabled";

	                if (GetAttribute(pTotalRows[i], "DATA12") == "002" && CurrentSn == ProSn)
	                    p_StatusDis = "disabled";

	                if ((GetAttribute(pTotalRows[i], "DATA11") == "009" || GetAttribute(pTotalRows[i], "DATA11") == "007" || GetAttribute(pTotalRows[i], "DATA11") == "012") && parseInt(CurrentSn) < parseInt(ProSn))
	                    p_StatusDis = "disabled";
	                
	                if (GetAttribute(pTotalRows[i],"DATA8") == "Y")    
	                     p_StatusDis = "disabled";
	                
	                if ($("input:checkbox[id='passAprLine']").is(":checked") && (pTotalRows[i].getAttribute("DATA12") == "004" || pTotalRows[i].getAttribute("DATA12") == "003" || pTotalRows[i].getAttribute("DATA12") == "002")) {
	                	p_StatusDis = "disabled";
	                }
	            }
	            if (GetAttribute(pTotalRows[i], "DATA11") != "003") {
	                var AprTypeObj = SChangeAprlineType("user", GetAttribute(pTotalRows[i], "DATA11"));
	                if (AprTypeObj == "") {
	                    pAPRLINE.DeleteRow(pTotalRows[i].id);
	                }
	                else {
	                    AprTyepID = GetAttribute(pTotalRows[i], "id") + "select";
	                    AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style=\"width:100%;\"" + p_StatusDis + " >" + AprTypeObj + "</select>";
	                    pTotalRows[i].childNodes[4].innerHTML = AprTypeObj;
	                    var selectedindex = pTotalRows[i].childNodes[4].childNodes[0].selectedIndex;
	                    SetAttribute(pTotalRows[i], "DATA11", pTotalRows[i].childNodes[4].childNodes[0].childNodes[selectedindex].value);
	                }
	            }
	        }
	    }
	} else {
		aprlinecount = 0;
		var pAPRLINE = new ListView();   
		pAPRLINE.LoadFromID("lvAPRLINE");
		var pTotalRows = pAPRLINE.GetDataRows();
		for (var i = 0; i < pTotalRows.length; i++) {
			var p_isDept = pTotalRows[i].getAttribute("DATA5");
			var CurrentSn = CrossYN() ? pTotalRows[i].childNodes.item(0).textContent : pTotalRows[i].childNodes.item(0).innerText;
			
			if (pTotalRows[i].getAttribute("DATA12") == "002") {
				ProSn = CurrentSn;
			}
			
			if (pTotalRows[i].getAttribute("DATA12") == "004" || GetAttribute(pTotalRows[i], "DATA12") == "015")
				p_RejectFlag = true;
			
			
			var p_StatusDis = (CurrentSn != 1 && (pTotalRows[i].getAttribute("DATA12") == "001" || p_RejectFlag)) ? "" : pTotalRows.length == 1 ? "" : "disabled";
			if ((pTotalRows[i].getAttribute("DATA11") == "009" || pTotalRows[i].getAttribute("DATA11") == "012") && parseInt(CurrentSn) < parseInt(ProSn))
				p_StatusDis = "disabled";
			
			if ($("input:checkbox[id='passAprLine']").is(":checked") && (pTotalRows[i].getAttribute("DATA12") == "004" || pTotalRows[i].getAttribute("DATA12") == "003" || pTotalRows[i].getAttribute("DATA12") == "002")) {
            	p_StatusDis = "disabled";
            }
			// 감사부서는 감사결재 유형만 사용할 수 있도록 설정. 2020-02-28 홍대표.
			if(pDeptgamsaCount > 0 && pTotalRows[i].getAttribute("DATA4") == optGamsabu) {
				p_StatusDis = "disabled";
			}
			
			if (p_isDept == "Y") {
				var AprTypeObj = ChangeAprlineType("group", pTotalRows[i].getAttribute("DATA11"));
				AprTyepID = pTotalRows[i].getAttribute("id") + "select";
				AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style =\"width:100%\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
				pTotalRows[i].childNodes[4].innerHTML = AprTypeObj;
				
				// 감사부서는 감사결재 유형만 사용할 수 있도록 설정. 2020-02-28 홍대표.
				setDeptGamsaType(pTotalRows[i]);
			} else {
				var AprTypeObj = ChangeAprlineType("user", pTotalRows[i].getAttribute("DATA11"));
				var tempHtml = "";
				// 감사
				var index = pTotalRows.length-1;
				var revIndex = 0;
				// (index-revIndex)최초감사자 index값
				$.each($(pTotalRows).get().reverse(), function(j, item) {
					if($(this).attr("DATA11") == "005") {
						revIndex = j;
						return false;
					}
				});
				
				if(pTotalRows[i].getAttribute("JUNBUBYN") == "Y" || pTotalRows[i].getAttribute("APPRLINETYPE") == "audit_add"
					|| pTotalRows[i].getAttribute("DATA11") == "005") {
					$.each($(AprTypeObj), function(j, item) {
						if(this.value == "005") {
							tempHtml += this.outerHTML;
						}
					});
					AprTypeObj = tempHtml;
					
					// 현재 결재자가 준법지원인일때(최초감사일때)
					if(arr_userinfo[1] == pTotalRows[i].getAttribute("DATA4") && i == (index-revIndex)) {
						//$('#td_check_rep_sugg').hide();
						$("#auditAddBtn").hide();
						$("#td_check_rep_sugg").hide();
						$("#tr_radio_audit").show();
						$("#APRLINE").css("height", "488px");
					}
					
					pTotalRows[i].setAttribute("APPRLINETYPE", "audit_add");
					pTotalRows[i].setAttribute("DATA9", "N");
					auditCount1++;
					
				} else {
					$.each($(AprTypeObj), function(j, item) {
						if(this.value != "005") {
							tempHtml += this.outerHTML;
						}
					});
					AprTypeObj = tempHtml;
				}
				AprTyepID = pTotalRows[i].getAttribute("id") + "select";
				AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style =\"width:100%\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
				pTotalRows[i].childNodes[4].innerHTML = AprTypeObj;
				
				if (pTotalRows[i].childNodes[0].innerHTML != pTotalRows.length && pTotalRows[i].getAttribute("DATA11") == "001") {
					pTotalRows[i].setAttribute("DATA11", "019");
				}
				else if (pTotalRows[i].childNodes[0].innerHTML.replace("★","").replace("⊙","") == "1" && pTotalRows[i].getAttribute("DATA11") == "001") {
					pTotalRows[i].setAttribute("DATA11", "018");
				}
				
				var selectedindex = pTotalRows[i].childNodes[4].childNodes[0].selectedIndex;
				pTotalRows[i].setAttribute("DATA11", pTotalRows[i].childNodes[4].childNodes[0].childNodes[selectedindex].value);
				
			}
		}
	}
	$.each($(pTotalRows).get().reverse(), function(index) {
		var text = "";
		var id = this.id;
        id = id.replace(/\d+$/, '') + index;
		
		/*if($(this).attr("DATA8") == "Y" && $(this).attr("DATA11") == "008") {
			text = "★";
		} else if($(this).attr("DATA9") == "Y" && $(this).attr("DATA11") == "005") {
			auditCount2++;
			if(auditCount1 > 1 && auditCount1 == auditCount2) {
			text = "⊙";
			}
		}*/
		
		if($(this).attr("DATA8") == "Y") {
			text += "★";
		}
		if($(this).attr("DATA9") == "Y") {
			text += "⊙";
		}
		
		
		$(this).attr('id', id);
		$(this).children('td:first').text(text+(index+1));
		$(this).children().find('select').attr("id", id + 'select');
	});
}

//############################################################################################################################################# 결재선리스트 삭제 이벤트 
function DoDelete(pSelectedRow) {
    try {
    	if (approvalFlag == "S") {
            var pAPRLINE = new ListView();
            pAPRLINE.LoadFromID("lvAPRLINE");

            var pTotalRows = pAPRLINE.GetDataRows();
            var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

            var RowDelCheck;
            var Rtnval = "N";
            TIndex = pTotalRows.length;
            NIndex = pSelectedIndex;

            for (i = 0; i <= NIndex; i++) {
                RowDelCheck = getNodeText(pTotalRows[i].cells[0]);
                setNodeText(pTotalRows[i].childNodes[0],RowDelCheck - 1);
                
                Rtnval = "Y";
            }

            if (Rtnval == "Y") {
                var selIdx = GetAttribute(pAPRLINE.GetSelectedRows()[0], "id");
                pAPRLINE.DeleteRow(selIdx);
            }
    	} else {
    		var pAPRLINE = new ListView();      
    		pAPRLINE.LoadFromID("lvAPRLINE");
    		
    		var pTotalRows = pAPRLINE.GetDataRows();
    		var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);
    		
    		var RowDelCheck;
    		var Rtnval = "N";
    		TIndex = pTotalRows.length;
    		NIndex = pSelectedIndex;
    		
    		for (i = 0; i <= NIndex; i++) {
    			var temptext = "";
    			if (CrossYN()) {
    				RowDelCheck = pTotalRows[i].cells[0].innerText;
    				if (RowDelCheck.indexOf("★") > -1) {
    					temptext += "★";
    					RowDelCheck = RowDelCheck.replace("★", "");
    				}
    				if (RowDelCheck.indexOf("⊙") > -1) {
    					temptext += "⊙";
    					RowDelCheck = RowDelCheck.replace("⊙", "");
    				}
    				
    				pTotalRows[i].childNodes[0].textContent = temptext + (RowDelCheck - 1);
    			}
    			else {
    				RowDelCheck = pTotalRows[i].cells[0].innerText;
    				if (RowDelCheck.indexOf("★") > -1) {
    					temptext += "★";
    					RowDelCheck = RowDelCheck.replace("★", "");
    				}
    				if (RowDelCheck.indexOf("⊙") > -1) {
    					temptext += "⊙";
    					RowDelCheck = RowDelCheck.replace("⊙", "");
    				}
    				pTotalRows[i].cells[0].innerText = temptext + (RowDelCheck - 1);
    			}
    			
    			Rtnval = "Y";
    		}
    		
    		if (Rtnval == "Y") {
    			var selIdx = pAPRLINE.GetSelectedRows()[0].getAttribute("id");
    			pAPRLINE.DeleteRow(selIdx);
    		}
    		aprlinecount = 0;

    		//LineAprTyepSetAll();
    		LineAprTyepSetAll_DELETE_ADD();
    		
    		document.getElementById('Reporter').checked =false;
    		document.getElementById('Suggester').checked =false;

    	}
    } catch (e) {
        alert("DoDelete :: " + e.description);
    }
}
//############################################################################################################################################# 결재선정보 XML Parsing
function APRLINETEMPLETXMLParsing() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;
    var CurCellLen = AprLineRow[0].cells.length;

    var i;
    var j;
    var k = 0;
    var GetXml;
    var AprLineTotalLen;
    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang331 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang29 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang32 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang61 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang124 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang332 + "</NAME><WIDTH>120</WIDTH></HEADER><HEADER><NAME>" + strLang333 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>";
    GetXml = GetXml + "<ROWS>";
    var rep1 = /⊙/g
    var rep2 = /★/g
    for (i = 0; i < CurListLen; i++) {
        var tr = AprLineRow[i];
        GetXml = GetXml + "<ROW>";
        for (j = 0; j < CurCellLen - 1; j++)
            if (tr.cells[j].childNodes[0].nodeName == "SELECT") {
                var pAprTypeObjId = AprLineRow[i].getAttribute("id")+"select";
                var pAprTypeCode_, pAprTypeName_;
                var pAprSelectindex = document.getElementById(pAprTypeObjId).selectedIndex;
                pAprTypeCode_ = document.getElementById(pAprTypeObjId)[pAprSelectindex].getAttribute("value");
                pAprTypeName_ = document.getElementById(pAprTypeObjId)[pAprSelectindex].getAttribute("value2");
                GetXml = GetXml + "<COLUMN>" + MakeXMLString(pAprTypeName_) + "</COLUMN>";
            }
            else
                GetXml = GetXml + "<COLUMN>" + MakeXMLString(tr.cells[j].innerText.replace(rep1, "").replace(rep2, "")) + "</COLUMN>";

        if (pReDraftFlag == "REDRAFT") {
            GetXml = GetXml + "<DATA name='ProcessDate'></DATA>";
            GetXml = GetXml + "<DATA name='ReceivedDate'></DATA>";
        }
        else {
            GetXml = GetXml + "<DATA name='ProcessDate'>" + GetAttribute(tr, "DATA1") + "</DATA>";
            GetXml = GetXml + "<DATA name='ReceivedDate'>" + GetAttribute(tr, "DATA2") + "</DATA>";
        }

        
        if (trim_Cross(GetAttribute(tr, "DATA3")) != "") 
            GetXml = GetXml + "<DATA name='DocID'>" + GetAttribute(tr, "DATA3") + "</DATA>";
        else
            GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";

        GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(GetAttribute(tr, "DATA4")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + GetAttribute(tr, "DATA5") + "</DATA>";
        GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(GetAttribute(tr, "DATA6")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + MakeXMLString(GetAttribute(tr, "DATA7")) + "</DATA>";
        GetXml = GetXml + "<DATA name='isProposerYN'>" + GetAttribute(tr, "DATA8") + "</DATA>";
        GetXml = GetXml + "<DATA name='isBriefUserYN'>" + GetAttribute(tr, "DATA9") + "</DATA>";
        GetXml = GetXml + "<DATA name='isCompanyID'>" + GetAttribute(tr, "DATA10") + "</DATA>";
        GetXml = GetXml + "<DATA name='AprType'>" + GetAttribute(tr, "DATA11") + "</DATA>";
        GetXml = GetXml + "<DATA name='AprState'>" + GetAttribute(tr, "DATA12") + "</DATA>";
        GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(GetAttribute(tr, "DATA13")) + "</DATA>";
        GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(GetAttribute(tr, "DATA14")) + "</DATA>";
        GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(GetAttribute(tr, "DATA15")) + "</DATA>";
        GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(GetAttribute(tr, "DATA16")) + "</DATA>";
        GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(GetAttribute(tr, "DATA17")) + "</DATA>";
        GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(GetAttribute(tr, "DATA18")) + "</DATA>";
        GetXml = GetXml + "</ROW>";
    }

	GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
	pAprLineXml[0] = GetXml;
	
	//기안자 정보를 진행으로 Setting
	if(!pReDraftAprLineFlag)
	{
		// 표준모듈 (2007.05.09) : 다국어
		var TmpAprLineState = strAprState2;
		var TmpAprLineStateName = strLangAprState2;
		if(pReDraftAprLineChangeFlag)
		{
			var ChangeXml = createXmlDom();
			ChangeXml= loadXMLString(GetXml);
			var NodeList = SelectNodes(ChangeXml,"LISTVIEWDATA/ROWS/ROW");
			
			if(NodeList.length != 0)
			{
				var pDraftDay = getGyulJeDateDB();
				
				setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[17],TmpAprLineState);
				setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[5],TmpAprLineStateName);
				setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[7],pDraftDay);
				pAprLineXml[0] = getXmlString(ChangeXml);
				
			}
		}
		else if(pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "WHOKYUL")
		{
			var ChangeXml = createXmlDom();
			ChangeXml= loadXMLString(GetXml);
			var NodeList = SelectNodes(ChangeXml,"LISTVIEWDATA/ROWS/ROW");
			
			if(NodeList.length != 0)
			{
				var pDraftDay = getGyulJeDateDB();
				
				setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[17],TmpAprLineState);
				setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[5],TmpAprLineStateName);
				setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[7],pDraftDay);
				
				pAprLineXml[0] = getXmlString(ChangeXml);
			}
		}
	}

    return pAprLineXml[0];    
}

function SAPRLINETEMPLETXMLParsing() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;
    var CurCellLen = AprLineRow[0].cells.length;

    var i;
    var j;
    var k = 0;
    var GetXml;
    var AprLineTotalLen;
    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLangS106 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLangS107 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLangS108 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLangS38 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLangS109 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLangS110 + "</NAME><WIDTH>120</WIDTH></HEADER><HEADER><NAME>" + strLangS111 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>";
    GetXml = GetXml + "<ROWS>";

    for (i = 0; i < CurListLen; i++) {
        var tr = AprLineRow[i];
        GetXml = GetXml + "<ROW>";
        for (j = 0; j < CurCellLen - 1; j++)
            if (tr.cells[j].childNodes[0].nodeName == "SELECT") {
                var pAprTypeObjId = GetAttribute(AprLineRow[i], "id") + "select";
                var pAprTypeCode_, pAprTypeName_;
                var pAprSelectindex = document.getElementById(pAprTypeObjId).selectedIndex;
                pAprTypeCode_ = GetAttribute(document.getElementById(pAprTypeObjId)[pAprSelectindex], "value");
                pAprTypeName_ = GetAttribute(document.getElementById(pAprTypeObjId)[pAprSelectindex], "value2");
                GetXml = GetXml + "<COLUMN>" + MakeXMLString(pAprTypeName_) + "</COLUMN>";
            }
            else {
                GetXml = GetXml + "<COLUMN>" + MakeXMLString(getNodeText(tr.cells[j])) + "</COLUMN>";
            }

        if (pReDraftFlag == "REDRAFT") {
        	if ($(tr).attr("DATA12") == "002" || ($(tr).attr("DATA12") == "003") && $("input:checkbox[id='passAprLine']").is(":checked")) {
				GetXml = GetXml + "<DATA name='ProcessDate'>" + MakeXMLString(GetAttribute(tr, "DATA1")) + "</DATA>";
				GetXml = GetXml + "<DATA name='ReceivedDate'>" + MakeXMLString(GetAttribute(tr, "DATA2")) + "</DATA>";
			} else {
				GetXml = GetXml + "<DATA name='ProcessDate'></DATA>";
				GetXml = GetXml + "<DATA name='ReceivedDate'></DATA>";
			}
        }
        else {
            GetXml = GetXml + "<DATA name='ProcessDate'>" + GetAttribute(tr, "DATA1") + "</DATA>";
            GetXml = GetXml + "<DATA name='ReceivedDate'>" + GetAttribute(tr, "DATA2") + "</DATA>";
        }
        if (trim_Cross(GetAttribute(tr, "DATA3")) != "")
            GetXml = GetXml + "<DATA name='DocID'>" + GetAttribute(tr, "DATA3") + "</DATA>";
        else
            GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";

        GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(GetAttribute(tr, "DATA4")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + GetAttribute(tr, "DATA5") + "</DATA>";
        GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(GetAttribute(tr, "DATA6")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + MakeXMLString(GetAttribute(tr, "DATA7")) + "</DATA>";
        GetXml = GetXml + "<DATA name='isProposerYN'>" + GetAttribute(tr, "DATA8") + "</DATA>";
        GetXml = GetXml + "<DATA name='isBriefUserYN'>" + GetAttribute(tr, "DATA9") + "</DATA>";
        GetXml = GetXml + "<DATA name='isCompanyID'>" + GetAttribute(tr, "DATA10") + "</DATA>";
        GetXml = GetXml + "<DATA name='AprType'>" + GetAttribute(tr, "DATA11") + "</DATA>";
        GetXml = GetXml + "<DATA name='AprState'>" + GetAttribute(tr, "DATA12") + "</DATA>";
        GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(GetAttribute(tr, "DATA13")) + "</DATA>";
        GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(GetAttribute(tr, "DATA14")) + "</DATA>";
        GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(GetAttribute(tr, "DATA15")) + "</DATA>";
        GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(GetAttribute(tr, "DATA16")) + "</DATA>";
        GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(GetAttribute(tr, "DATA17")) + "</DATA>";
        GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(GetAttribute(tr, "DATA18")) + "</DATA>";
        GetXml = GetXml + "</ROW>";
    }

    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
    pAprLineXml[0] = GetXml;

    if (!pReDraftAprLineFlag) {
        var TmpAprLineState = strAprState2;
        var TmpAprLineStateName = strLangAprState2;
        if (pReDraftAprLineChangeFlag) {
            var ChangeXml = createXmlDom();
            ChangeXml = loadXMLString(GetXml);
            var NodeList = SelectNodes(ChangeXml, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0) {
                var pDraftDay = getGyulJeDateDB();

                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[17], TmpAprLineState);
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[5], TmpAprLineStateName);
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[7], pDraftDay);
                pAprLineXml[0] = getXmlString(ChangeXml);

            }
        }
        else if (pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "WHOKYUL") {
            var ChangeXml = createXmlDom();
            ChangeXml = loadXMLString(GetXml);
            var NodeList = SelectNodes(ChangeXml, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0) {
                var pDraftDay = getGyulJeDateDB();

                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[17], TmpAprLineState);
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[5], TmpAprLineStateName);
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[7], pDraftDay);

                pAprLineXml[0] = getXmlString(ChangeXml);
            }
        }
    }

    return pAprLineXml[0];
}

function CheckHapYuiCellValue() {
  try {
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("lvAPRLINE");
    
    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;
    var CurAprLen = 0;
    var pCurAprDeptLen = 0;
    var pAprTypeFlag = "008"; //개인순차합의
    pAprTypeFlag = ConvertAprLineType(pAprTypeFlag,"Value");
    CurAprLen = getAprLineGyulJeLen(AprLineRow , CurListLen , pAprTypeFlag);
  
    pAprTypeFlag = "012"; //부서 병렬 합의
    pAprTypeFlag = ConvertAprLineType(pAprTypeFlag,"Value");
    pCurAprDeptLen = getAprLineGyulJeLen(AprLineRow , CurListLen , pAprTypeFlag);
    if (pHapYuiCount == "0") {
		var pAlertContent = "" + strLang369 + "<br>  " + strLang371 + "";
		OpenAlertUI(pAlertContent);
		return false;
    }
    return true;
  }catch(e){
    alert("CheckHapYuiCellValue :: " + e.description);
  }
}

//############################################################################################################################################# 결재참가자의 수를 가져오는 함수 
function getAprLineGyulJeLen(AprLineRow , CurListLen , pAprTypeFlag)
{
   	pTotalIndex = 0;
	var i;
	for(i = 0 ; i < CurListLen ; i++)
	{
		if(GetAttribute(AprLineRow[i],"DATA11") == pAprTypeFlag)
			pTotalIndex = pTotalIndex + 1;
	}
	return pTotalIndex;
}
//############################################################################################################################################# 결재방법 이벤트 처리
function APRLINETYPECHANGEFunction(valuecode, valueName) {
	var p_AprLineValueCode, p_AprLineValueName;
	var p_CurAprlineStat;
	var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pCurSelRow = pAPRLINE.GetSelectedRows();

    if (pCurSelRow.length == 0)
        return false;

        
	p_CurAprlineStat = GetAttribute(pCurSelRow[0],"DATA12");
	
	p_AprLineValueName = valueName;
	p_AprLineValueCode = valuecode;
	  
	if(pSelAprLineState != "003" && ( pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "HABYUI" ))
	{
		AprLineTypeCheck(p_AprLineValueName,p_AprLineValueCode,pCurSelRow);
	}
	else if(pReDraftFlag == "REDRAFT")
	{
		if(pSelAprLineState == "003" || pSelAprLineState == "004" || pCurSelRow[0].cells[0].innerText == "1")
		{
			Ans = true;
			if(Ans)
			{
				AprLineTypeCheck(p_AprLineValueName,p_AprLineValueCode,pCurSelRow);
				pReDraftAprLineChangeFlag = true; 
			}
		}else{
			AprLineTypeCheck(p_AprLineValueName,p_AprLineValueCode,pCurSelRow);
		}
	}
	
	if (approvalFlag == "S") {
		if(!SCheckLineUser()) {
			resetList();
			return;
		}
	} else {
		if(!CheckLineUser()) {
			return;
		}
	}
}
//############################################################################################################################################# 결재방법 체크
function AprLineTypeCheck(p_AprLineValueName,p_AprLineValueCode,CurSelRow)
{
	if ( CurSelRow != null )
	{
		var ReasonNoCheck;
		var p_AprlineTypeVal;
		var p_AprlineTypeValCode;
		var RtnVal = true;
		p_AprlineTypeValCode = GetAttribute(CurSelRow[0],"DATA11");
		if(RtnVal)
		{
			if(p_AprLineValueCode == "004")
			{
				var pCurSelIndex = getNodeText(CurSelRow[0].cells[0]);
				var pTmpAprLineTypeCode, pTmpAprLineTypeName;
				pTmpAprLineTypeCode = strAprType3;
				pTmpAprLineTypeName = strLangAprType3;
				
				if (approvalFlag == "S") {
					rtnvalue = ApplyJunGyulFunction(pCurSelIndex ,pTmpAprLineTypeCode, pTmpAprLineTypeName);
					if (rtnvalue == "check") {
						return;
					}
				}
			}
            else if (p_AprlineTypeValCode == "004") {
                var pAPRLINE = new ListView();      //// ListView 선언
                pAPRLINE.LoadFromID("lvAPRLINE");
                var pAprLineRow = pAPRLINE.GetDataRows();
                var pAprLineRowLen = pAprLineRow.length;
                
                if (approvalFlag == "S") {
                	for (i = 0; i < pAprLineRowLen; i++) {
                        var templinevalue = parseInt(getNodeText(pAprLineRow[i].cells[0]));
                        var temprowvalue = parseInt(getNodeText(CurSelRow[0].cells[0]));
                       
                        if (templinevalue > temprowvalue) {
                            if (GetAttribute(pAprLineRow[i], "DATA11") == strAprType3) {

                                var cnt = pAprLineRow[i].cells[4].childNodes[0].length;
                                if (pAprLineRow[i].cells[4].childNodes[0].value == strAprType3) {
                                    if (pAprLineRow[i].cells[4].childNodes[0].disabled) {
                                        var AprTypeObj = SChangeAprlineType("user", strAprType1);
                                        AprTyepID = GetAttribute(pAprLineRow[i], "id") + "select";
                                        AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style=\"width:100%;\">" + AprTypeObj + "</select>";
                                        pAprLineRow[i].cells[4].innerHTML = AprTypeObj;
                                        SetAttribute(pAprLineRow[i], "DATA11", strAprType1);
                                    }
                                }
                            }
                        }
                        else {
                            break;
                        }
                    }
                } else {
                	for (i = 0; i < pAprLineRowLen; i++) {
                		if (parseInt(pAprLineRow[i].cells[0].innerText) > parseInt(CurSelRow[0].cells[0].innerText)) {
                			if (GetAttribute(pAprLineRow[i], "DATA11") == strAprType3) {
                				
                				var cnt = pAprLineRow[i].cells[4].childNodes[0].length;
                				if (pAprLineRow[i].cells[4].childNodes[0].value == strAprType3) {
                					if (pAprLineRow[i].cells[4].childNodes[0].disabled){//전결지정으로 강제로 변경된 케이스{
                						for (var y = 0; y < cnt; y++) {
                							if (pAprLineRow[i].cells[4].childNodes[0].childNodes[y].getAttribute("value") == strAprType1) {
                								pAprLineRow[i].cells[4].childNodes[0].selectedIndex = y;
                								pAprLineRow[i].cells[4].childNodes[0].disabled = false;
                								
                							}
                						}
                						SetAttribute(pAprLineRow[i], "DATA11", strAprType1);
                					}
                				}
                			}
                		}
                		else {
                			break;
                		}
                	}
                }

	            pAPRLINE = null;
	        }
			SetAttribute(CurSelRow[0], "DATA11", p_AprLineValueCode);			
		}
	}
}
//############################################################################################################################################# "결재안함" 사유여부 확인
function ReasonNocheck(CurSelRow,p_AprlineTypeVal,p_AprLineValue)
{
    var checkvalue = "NREASON";
    if(p_AprlineTypeVal == "003" && p_AprLineValue != "003" && NoReasonVal != "")
    {   
		var pInformationContent = strLang220 + "<br> " + strLang221;
		var Ans = OpenInformationUI(pInformationContent);
		if(Ans)
		{
			checkvalue = "YES";
			SetAttribue(CurSelRow[0],"DATA7","") ;
		}else{
			checkvalue = "NO";
		}
    }
	return checkvalue;
}


//############################################################################################################################################# 결재방법이 "전결" 이벤트 처리
function ApplyJunGyulFunction(pCurSelIndex, pTmpAprLineTypeCode, pTmpAprLineTypeName)
{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
	var pAprLineRow = pAPRLINE.GetDataRows();
	var pAprLineRowLen = pAprLineRow.length;
	var i;
	var flag;
	for(i = 0 ; i < pAprLineRowLen ; i++)
	{
	    flag = "uncheck";
		if(parseInt(pAprLineRow[i].cells[0].innerText) > parseInt(pCurSelIndex) && (GetAttribute(pAprLineRow[i],"DATA11") == strAprType12  || GetAttribute(pAprLineRow[i],"DATA11") == strAprType11 || GetAttribute(pAprLineRow[i],"DATA11") == strAprType5))
		{
			flag = "check";
			var pAlertContent = strLang286 + "<br>"+ strLang287;
			OpenAlertUI(pAlertContent);
			
			var pSelectedRow = pAPRLINE.GetSelectedRows();
            var p_IsDept = GetAttribute(pSelectedRow[0],"DATA5"); 
            var pOrderSN = pAPRLINE.GetSelectedIndexes().split(',')[0]; 

            if (approvalFlag == "S") {
            	if (p_IsDept == "Y") { 
            		SChangeAprlineType("group"); 
            	} else if(p_IsDept == "N") { 
            		SChangeAprlineType("user"); 
            	}
            	
            	resetList();
            } else {
            	if (p_IsDept == "Y") { 
            		ChangeAprlineType("group"); 
            	} else if(p_IsDept == "N") { 
            		ChangeAprlineType("user"); 
            	}
            }
            
			return flag;
		}

		else if(parseInt(pAprLineRow[i].cells[0].innerText) > parseInt(pCurSelIndex) && (GetAttribute(pAprLineRow[i],"DATA11") == strAprType8 || GetAttribute(pAprLineRow[i],"DATA11") == strAprType9))
		{
			flag = "check";
			var pAlertContent = strLangS506 + "<br>"+ strLang287;
			OpenAlertUI(pAlertContent);
			
			var pSelectedRow = pAPRLINE.GetSelectedRows();  
            var p_IsDept = GetAttribute(pSelectedRow[0],"DATA5");  
            var pOrderSN =pAPRLINE.GetSelectedIndexes().split(',')[0];
            
            if (approvalFlag == "S") {
            	if (p_IsDept == "Y") { 
            		SChangeAprlineType("group"); 
            	} else if(p_IsDept == "N") { 
            		SChangeAprlineType("user"); 
            	}
            	
            	resetList();
            } else {
            	if (p_IsDept == "Y") { 
            		ChangeAprlineType("group"); 
            	} else if(p_IsDept == "N") { 
            		ChangeAprlineType("user"); 
            	}
            }
            
			return flag;
		}
	}
	//앞에 User가 전결일 경우 뒤에 결재자는 결재안함 처리, DropDown비활성
	for(i = 0 ; i < pAprLineRowLen ; i++)
	{
		if(parseInt(pAprLineRow[i].cells[0].innerText) > parseInt(pCurSelIndex))
		{
			if(GetAttribute(pAprLineRow[i],"DATA11") != strAprType8 && GetAttribute(pAprLineRow[i],"DATA11") != strAprType9) {
				if (approvalFlag == "S") {
					var SelectObjectId = GetAttribute(pAprLineRow[i], "id") + "select";

	                var p_Option = document.createElement("OPTION");
	                if (CrossYN())
	                    setNodeText(p_Option , strLangAprType3);
	                else
	                    setNodeText(p_Option,strLangAprType3);
	                p_Option.setAttribute("value", "003");
	                p_Option.setAttribute("value2", strLangAprType3);
	                var AprTypeObj = "<select style='width:100%;' id='" + SelectObjectId + "' disabled='true' >" + p_Option.outerHTML + "</select>";
	                pAprLineRow[i].cells[4].innerHTML = AprTypeObj;

	                SetAttribute(pAprLineRow[i], "DATA11", pTmpAprLineTypeCode);
				} else {
					var cnt = pAprLineRow[i].cells[4].childNodes[0].length;
					
					for(var y = 0; y < cnt; y ++)
					{
						
						if(pAprLineRow[i].cells[4].childNodes[0].childNodes[y].getAttribute("value2") == pTmpAprLineTypeName)
						{
							pAprLineRow[i].cells[4].childNodes[0].options[y].selected = true;
							pAprLineRow[i].cells[4].childNodes[0].disabled = true;
							
						}
					}
					
					SetAttribute(pAprLineRow[i],"DATA11",pTmpAprLineTypeCode);
				}
			}
		}
		else
		{
			break;
		}
	}
}
//############################################################################################################################################# 전결이 없을경우 DropDown 활성화
function checkdisabled()
{
	if (approvalFlag == "S") {
	    var pAPRLINE = new ListView();
	    pAPRLINE.LoadFromID("lvAPRLINE");
	    var pAprLineRow = pAPRLINE.GetDataRows();
	    var SelRow = pAPRLINE.GetSelectedRows();
	    var pAprLineRowLen = pAprLineRow.length - 1;

	    for (var i = pAprLineRowLen; i > 0; i--) {

	        if (GetAttribute(pAprLineRow[i - 1], "DATA5") == "N") {
	            var num = findOptionNum(strAprType4);
	            var num2 = findOptionNum(strAprType3);
	            if (pAprLineRow[i - 1].cells[4].childNodes[0].options[num].selected == true) {
	                for (var y = 0; y < i - 1; y++) {
	                    if (GetAttribute(pAprLineRow[y], "DATA5") == "N") {
	                        pAprLineRow[y].cells[4].childNodes[0].disabled = true;
	                        pAprLineRow[y].cells[4].childNodes[0].options[num2].selected = true;
	                    }

	                }
	                break;
	            }
	            else {
	                var curaprsn = false;;
	                for (var y = 0; y < i; y++) {
	                    if (GetAttribute(pAprLineRow[y], "DATA12") == "002") // aprType이 진행인 경우
	                        curaprsn = true;

	                    if ((GetAttribute(pAprLineRow[y], "DATA12") == "003" || curaprsn) && pReDraftFlag != 'REDRAFT') // aprType이 승인인 경우
	                        pAprLineRow[y].cells[4].childNodes[0].disabled = true;
	                    else
	                        pAprLineRow[y].cells[4].childNodes[0].disabled = false;

	                }
	            }
	        }
	    }
	} else {
		var pAPRLINE = new ListView();      //// ListView 선언
		pAPRLINE.LoadFromID("lvAPRLINE");
		var pAprLineRow = pAPRLINE.GetDataRows();
		var SelRow = pAPRLINE.GetSelectedRows();
		var pAprLineRowLen = pAprLineRow.length;
		
		for(var i = pAprLineRowLen; i > 0; i--)
		{
			
			if(pAprLineRow[i-1].getAttribute("DATA5") == "N")
			{
				var num = findOptionNum(strAprType4);
				var num2 = findOptionNum(strAprType3);
				if(pAprLineRow[i-1].cells[4].childNodes[0].options[num].selected == true)
				{
					for(var y=0; y < i-1; y++)
					{
						pAprLineRow[y].cells[4].childNodes[0].disabled	= true;
						pAprLineRow[y].cells[4].childNodes[0].options[num2].selected = true;
					}
					break;
				}
				else
				{
					for(var y=0; y < i; y++)
					{
						pAprLineRow[y].cells[4].childNodes[0].disabled	= false;
					}
				}
			}
		}
	}
}
function findOptionNum(type)
{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pAprLineRow = pAPRLINE.GetDataRows();
    var pAprLineRowLen = pAprLineRow.length;

    for (var i = 0; i < pAprLineRowLen; i++) 
    {     
        var cnt = pAprLineRow[i].cells[4].childNodes[0].length;
        for (var y = 0; y < cnt; y++) 
        {
            if (pAprLineRow[i].cells[4].childNodes[0].childNodes[y].getAttribute("value") == type) 
            {
                return y;
            }
        }
    }
            
        
}
//############################################################################################################################################# 기안자 정보 체크
function CheckDraftUser(valuecode, valueName)
{
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");
    
	var NodeList = pAPRLINE.GetDataRows();
    var SelRow = pAPRLINE.GetSelectedRows();
	var NodeListLen = NodeList.length;
	
	var i;
	if(NodeListLen != 0)
	{   
	    if (GetAttribute(NodeList[NodeListLen - 1], "DATA4").toLowerCase() == pUserID.toLowerCase() && GetAttribute(NodeList[NodeListLen - 1], "DATA6").toLowerCase() == arr_userinfo[4].toLowerCase())
		{
			return true;
		}else{
			return false;
		}
	}
}
//############################################################################################################################################# 결재방법의 option 값을 초기값으로 돌리는 함수
function resetList() 
{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pTotalRows = pAPRLINE.GetDataRows();
    var SelRow = pAPRLINE.GetSelectedRows();
    
    if (approvalFlag == "S") {
        if (GetAttribute(SelRow[0], "DATA5") == "N") {
            SelRow[0].cells[4].childNodes[0].options[0].selected = true;
            SetAttribute(SelRow[0], "DATA11", "001");
        }
    } else {
    	if (SelRow[0].getAttribute("DATA5") == "N" && SelRow[0].getAttribute("DATA11") != strAprType16)
    	{
    		//var selindex = SelRow[0].cells[4].childNodes[0].selectedIndex;
    		SelRow[0].cells[4].childNodes[0].options[0].selected = true;
    		SetAttribute(SelRow[0], "DATA11", SelRow[0].cells[4].childNodes[0].options[0].value);
    	}
    }
    
}

function CheckLineArea()
{
    var pAlertContent = "";
    var pAPRLINE = new ListView();    
    pAPRLINE.LoadFromID("lvAPRLINE");
    
	var AprLineRow = pAPRLINE.GetDataRows();
    var SelRow = pAPRLINE.GetSelectedRows();
	var NodeListLen = AprLineRow.length;
	
    var pCurAprilban = 0;
	var pCurAprPersonLen = 0;
	var pCurAprDeptLen = 0;
	var pCurAprChamLen = 0;
	var pCurAprHainLen = 0;
	var pCurAprGongramLen = 0;
	var pAlertContent = "";
	
	if(pAprLineArea == 0)
	{
      var pChkFlag = chkJunkyul(AprLineRow)
	    if(pChkFlag == "false"){
 		    pAlertContent = pAlertContent + strLangS286 + "<br>"
	    }else if(pChkFlag == "another"){
		    pAlertContent = pAlertContent + strLangS287 + "<br>"
	    }else if(pChkFlag == "junkyul"){
		    pAlertContent = pAlertContent + strLangS288 + "<br>"
	    }
	    
	    var pAprTypeFlag = "001";
	    pCurAprilban = getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);

	    var pAprTypeFlag = "004";
	    pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);

	    var pAprTypeFlag = "003";
	    pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);

	    var pAprTypeFlag = "040";
	    pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);
	    
	    if (pCurAprilban > pSignCount) { 
	    	pAlertContent = pAlertContent + strLangS276 + pSignCount + strLangS277 + "<br>";
	    }
    }
    
    if (pAlertContent != "")
	{
  		var pAlertContent =  pAlertContent + "" + strLangS304;
		OpenAlertUI(pAlertContent);
		return false;
	}
    return true;
}

function CheckLineArea_BeforeAdd()
{
	var pAlertContent = "";
	var pAPRLINE = new ListView();    
	pAPRLINE.LoadFromID("lvAPRLINE");
	
	var AprLineRow = pAPRLINE.GetDataRows();
	var SelRow = pAPRLINE.GetSelectedRows();
	var NodeListLen = AprLineRow.length;
	
	var pCurAprilban = 0;
	var pCurAprPersonLen = 0;
	var pCurAprDeptLen = 0;
	var pCurAprChamLen = 0;
	var pCurAprHainLen = 0;
	var pCurAprGongramLen = 0;
	var pAlertContent = "";
	
	if(pAprLineArea == 0)
	{
		var pChkFlag = chkJunkyul(AprLineRow)
		if(pChkFlag == "false"){
			pAlertContent = pAlertContent + strLangS286 + "<br>"
		}else if(pChkFlag == "another"){
			pAlertContent = pAlertContent + strLangS287 + "<br>"
		}else if(pChkFlag == "junkyul"){
			pAlertContent = pAlertContent + strLangS288 + "<br>"
		}
		
		var pAprTypeFlag = "001";
		pCurAprilban = getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);
		
		var pAprTypeFlag = "004";
		pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);
		
		var pAprTypeFlag = "003";
		pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);
		
		var pAprTypeFlag = "040";
		pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);
		
		var pAprTypeFlag = "020";
		pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);
		
		if(pCurAprilban >= pSignCount)  
		{ 
			pAlertContent = pAlertContent + strLangS276 + pSignCount + strLangS277 + "<br>";
		}
	}
	
	if (pAlertContent != "")
	{
		var pAlertContent =  pAlertContent + "" + strLangS304;
		OpenAlertUI(pAlertContent);
		return false;
	}
	return true;
}
//############################################################################################################################################# 결재 라인 체크 이벤트
function CheckLineUser() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;

    if (CurListLen <= 0) {
        OpenAlertUI("" + strLang335 + "<br>" + strLang336 + "");
        return false;
    }

    var pCurDraft = 0;
    var pCurSign = 0;
    var pCurAprove = 0;
    var pCurJunkyul = 0;
    var pCurDekyul = 0;
    var pCurHapyui = 0;
    var pCurGamsa = 0;
    var pCurWhoakin = 0;
    var i;
    var pCurSignFlag = false;
    var pCurHSignFlag = false;
    var pCurGamsaFlag = false;
    var pCurWhoakinFlag = false;

    var pFirstAprType = GetAttribute(AprLineRow[CurListLen - 1], "DATA11");
    for (i = 0 ; i < CurListLen ; i++) {
        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType18)
            pCurDraft = pCurDraft + 1;
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType19)
            pCurSign = pCurSign + 1;
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType13)
            pCurGamsa = pCurGamsa + 1;
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType1) {
            pCurAprove = pCurAprove + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            if (pCurGamsa > 0)
                pCurGamsaFlag = true;
        }
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType16) {
            pCurDekyul = pCurDekyul + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            if (pCurGamsa > 0)
                pCurGamsaFlag = true;
            if (pCurWhoakin > 0) {
            	//2018-10-12 배현상, 최종결재자 직전에 결재자가 대결인 경우 최종결재자의 결재유형이 확인이 올 수 있는 경우 제거
            	pCurWhoakinFlag = true;
            }
        }
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType4) {
            pCurJunkyul = pCurJunkyul + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            if (pCurGamsa > 0)
                pCurGamsaFlag = true;
        }
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType2) {
        	//2018-10-12 배현상, 최종결재자 직전에 결재자가 대결인 경우 최종결재자의 결재유형이 확인이 올 수 있는 경우 제거
        	pCurWhoakin = pCurWhoakin + 1;
        }
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType9 || GetAttribute(AprLineRow[i], "DATA11") == strAprType8 || GetAttribute(AprLineRow[i], "DATA11") == strAprType11 || GetAttribute(AprLineRow[i], "DATA11") == strAprType12)
            pCurHapyui = pCurHapyui + 1;
    }

    var pAlertContent = "";
    if ((pCurDraft + pCurSign + pCurAprove + pCurDekyul + pCurJunkyul + pCurGamsa) > pSignCount) {
    	if (draftAllFlag != undefined && draftAllFlag == "Y") { // 일괄기안의 경우, "N안의 사인칸 수" 정보를 표출
        	pAlertContent = pAlertContent + opener.lowerSignTab + strLangHSBRDa09 + "" + strLang349 + "" + pSignCount + "" + strLang350 + "<br>";
        } else {
        	pAlertContent = pAlertContent + "" + strLang349 + "" + pSignCount + "" + strLang350 + "<br>";
        }
    }
    
	if (pCurHapyui > pHapYuiCount) {
    	if (draftAllFlag != undefined && draftAllFlag == "Y") {
    		pAlertContent = pAlertContent + opener.lowerHapyuiTab + strLangHSBRDa09 + strLang351 + "" + pHapYuiCount + "" + strLang350 + "<br> ";
    	} else {
    		pAlertContent = pAlertContent + "" + strLang351 + "" + pHapYuiCount + "" + strLang350 + "<br> ";
    	}
    }

    if (pCurAprove >= 1 && (pCurDekyul >= 1 || pCurJunkyul >= 1)) {
        pAlertContent = pAlertContent + "" + strLang352 + "<br> ";
    }

    if (pCurAprove > 1) {
        pAlertContent = pAlertContent + "" + strLang353 + "<br> ";
    }

    if (pCurDekyul > 1) {
        pAlertContent = pAlertContent + "" + strLang354 + "<br> ";
    }

    if (pCurGamsa > 1) {
        pAlertContent = pAlertContent + "" + strLang355 + "<br> ";
    }

    if (pCurAprove == 0 && pCurDekyul == 0 && pCurJunkyul == 0) {
        pAlertContent = pAlertContent + "" + strLang356 + "<br> ";
    }

    if (pCurDekyul > 0 && pCurJunkyul > 0) {
        if (AprLineRow[0].cells[4].innerText == "" + strLang7 + "") {
            pAlertContent = pAlertContent + "" + strLang358 + "<br> ";
        }
    }

    if (pCurSignFlag) {
        pAlertContent = pAlertContent + "" + strLang359 + "<br> ";
    }

    if (pCurHSignFlag) {
        pAlertContent = pAlertContent + "" + strLang360 + "<br> ";
    }

    if (pCurGamsaFlag) {
        pAlertContent = pAlertContent + "" + strLang361 + "<br> ";
    }
    
    if (pCurWhoakinFlag) {
    	pAlertContent = pAlertContent + "" + strLangBae2 + "<br> ";
    }
    if (pFirstAprType != strAprType18 && pFirstAprType != strAprType1 && pFirstAprType != strAprType4 && pFirstAprType != strAprType16)
        pAlertContent = pAlertContent + "" + strLang362 + "" + ConvertAprLineType(pFirstAprType, "Value") + "" + strLang363 + "<br> ";

    var pChkFlag = CheckDraftDeptID(AprLineRow);
    if (!pChkFlag)
        pAlertContent = pAlertContent + " " + strLang364 + "<br>";

    if (pAlertContent != "") {
        pAlertContent = pAlertContent + "" + strLang336 + "";
        OpenAlertUI(pAlertContent);
        return false;
    }

    if (pCurSign >= 3) {
        var pInformationContent = "" + strLang365;
        var Ans = OpenAlertUI(pInformationContent);
        return false;
    }

    return true;
}

function SCheckLineUser() {
    var pAlertContent = "";
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    var SelRow = pAPRLINE.GetSelectedRows();
    var NodeListLen = AprLineRow.length;


    if (NodeListLen <= 0) {
        OpenAlertUI(strLangS266 + "<br>" + strLangS267);
        return false;
    }

    for (i = 0; i < NodeListLen; i++) {
        if (GetAttribute(AprLineRow[i], "DATA4") == "") {
            OpenAlertUI(strLangS266 + "<br>" + strLangS267);
            return false;
        }
    }
    var pCurAprilban = 0;
    var pCurAprPersonLen = 0;
    var pCurAprDeptLen = 0;
    var pCurAprChamLen = 0;
    var pCurAprHainLen = 0;
    var pCurAprGongramLen = 0;
    var pAlertContent = "";


    if (pHapyuiArea == 0) {
        var pAprTypeFlag = "008";
        pCurAprPersonLen = getAprLineGyulJeLen(AprLineRow, NodeListLen, pAprTypeFlag);

        pAprTypeFlag = "009";
        pCurAprPersonLen = pCurAprPersonLen + getAprLineGyulJeLen(AprLineRow, NodeListLen, pAprTypeFlag);

        pAprTypeFlag = "012";
        pCurAprDeptLen = getAprLineGyulJeLen(AprLineRow, NodeListLen, pAprTypeFlag);

        pAprTypeFlag = "011";
        pCurAprDeptLen = pCurAprDeptLen + getAprLineGyulJeLen(AprLineRow, NodeListLen, pAprTypeFlag);

        if ((pCurAprPersonLen + pCurAprDeptLen) > pHapYuiCount) {
            pAlertContent = pAlertContent + strLangS281 + pHapYuiCount + strLangS277 + "<br> ";
        }
    }

    if (pCurAprDeptLen > 0) {
        var DuplicateFlagDept = false;
        for (i = 0; i < NodeListLen; i++) {
            if (GetAttribute(AprLineRow[i], "DATA5") == "Y") {
                for (j = i + 1; j < NodeListLen; j++) {

                    if (GetAttribute(AprLineRow[j], "DATA5") == "Y" && GetAttribute(AprLineRow[i], "DATA4") == GetAttribute(AprLineRow[j], "DATA4")) {
                        DuplicateFlagDept = true;
                        break;
                    }
                }
            }
        }
        if (DuplicateFlagDept) {
            pAlertContent = pAlertContent + strLangS283 + "<br> ";
        }
    }


    pAprTypeFlag = "007";
    pCurAprChamLen = getAprLineGyulJeLen(AprLineRow, NodeListLen, pAprTypeFlag);

    pAprTypeFlag = "002";
    pCurAprHainLen = getAprLineGyulJeLen(AprLineRow, NodeListLen, pAprTypeFlag);

    pAprTypeFlag = "017";
    pCurAprHainLen = getAprLineGyulJeLen(AprLineRow, NodeListLen, pAprTypeFlag);

    if (pCurAprGongramLen > pGongramCount) {
        pAlertContent = pAlertContent + strLangS285 + pGongramCount + strLangS277 + "<br>";
    }

    if (pAprLineArea == 0) {
        var pChkFlag = chkJunkyul(AprLineRow)
        if (pChkFlag == "false") {
            pAlertContent = pAlertContent + strLangS286 + "<br>"
        } else if (pChkFlag == "another") {
            pAlertContent = pAlertContent + strLangS287 + "<br>"
        } else if (pChkFlag == "junkyul") {
            pAlertContent = pAlertContent + strLangS288 + "<br>"
        }
    }

    var pChkFlag = chkLastKyuljea(AprLineRow)
    
	if (!pChkFlag) {
        pAlertContent = pAlertContent + " " + strLangS289 + "<br>"
    }
  

    var pChkFlag = chkHabyuiGamsa(AprLineRow)
    if (!pChkFlag) {
        pAlertContent = pAlertContent + " " + strLangS290 + "<br>"
    }

    var pChkFlag = chkLastKyuljeaCF(AprLineRow)
    if (!pChkFlag) {
        pAlertContent = pAlertContent + " " + strLangS291 + "<br>"
    }
//    var pChkFlag = chkbeforeGamSa(AprLineRow)
//    if (!pChkFlag)
//        pAlertContent = pAlertContent + " " + strLangS292 + "<br>"
//
//    var pChkFlag = chkafterGamSa(AprLineRow)
//    if (!pChkFlag)
//        pAlertContent = pAlertContent + " " + strLangS293 + "<br>"

    var pChkFlag = chkafterdeptHabyui(AprLineRow)
    if (!pChkFlag)
        pAlertContent = pAlertContent + " " + strLangS294 + "<br>"

//    var pChkFlag = chkDrafterTongje(AprLineRow)
//    if (!pChkFlag)
//        pAlertContent = pAlertContent + " " + strLangS295 + "<br>"

    var pChkFlag = chkSusinUser(AprLineRow)
    if (!pChkFlag)
        pAlertContent = pAlertContent + " " + strLangS296 + "'" + strLangS131 + "'" + strLangS297 + "<br>"

//    var pChkFlag = chkTongjeCheck(AprLineRow)
//    if (!pChkFlag)
//        pAlertContent = pAlertContent + " '" + strLangS236 + "'" + strLangS298 + "<br>"
//
    var pChkFlag = ChkWhoKyulDuplicate(AprLineRow)
    if (!pChkFlag)
    	pAlertContent = pAlertContent + strLangSpjj29 + "<br>"
        //pAlertContent = pAlertContent + " " + strLangS299 + "'" + strLangS275 + "'" + strLangS300 + "<br>"

    var pChkFlag = ChkWhoKyulLast(AprLineRow)
    if (!pChkFlag)
    	pAlertContent = pAlertContent + strLangSpjj28 + "<br>"
        //pAlertContent = pAlertContent + " " + strLangS301 + "'" + strLangS275 + "'" + strLangS302 + "<br>"

//    var pChkString = CheckWorkFlowXML(AprLineRow)
//    if (pChkString != "")
//        pAlertContent = pAlertContent + pChkString;

    var pChkFlag = CheckDraftDeptID(AprLineRow);
    if (!pChkFlag)
        pAlertContent = pAlertContent + " " + strLangS303 + "<br>";

    if (chamjoAfterYN == 'NO') {
    	var pChkFlag = CheckChamjo(AprLineRow);
    	
        if (!pChkFlag)
            pAlertContent = pAlertContent + " " + strLangSHJ1 + "<br>";
    }
    
    if (pAlertContent != "") {
        var pAlertContent = pAlertContent + "" + strLangS304;
        OpenAlertUI(pAlertContent);
        return false;
    }
    
    return true;
}

function chkJunkyul(AprLineRow)
{
 	var afterApr;
 	var afterAprflag;
 	var i;
 	var rtnVal;
 	afterApr = 0;
 	afterAprflag = false;
 	rtnVal = "true";
 	var anotherApr = 0;
 	var afterApr2  = 0
 	
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 		if( GetAttribute(AprLineRow[i],"DATA11") == strAprType4)
 		{
 			afterAprflag = true;		
 		}
 		if(afterAprflag)
 		{
 			if(GetAttribute(AprLineRow[i],"DATA11") == strAprType3)
 			{
 				afterApr = afterApr + 1;
 			}
 			else
 			{
 				anotherApr = anotherApr + 1;
 			}
 		}	
 		else
 		{
 			if(GetAttribute(AprLineRow[i],"DATA11") == strAprType3)
 			{
 				afterApr2 = afterApr2 + 1;
 			}
 		}
 	}
 	
 	if(afterAprflag)
 	{
 		if(afterApr > 0 && anotherApr -1 == 0 ){
 			rtnVal = "true";	
 		}
 		else if(anotherApr-1 > 0 ){
 			rtnVal = "another";
 		}
 		else
 		{
 			rtnVal = "false";
 		}
 	}
 	else
 	{
 		 if(afterApr2 > 0 ){
 			rtnVal = "junkyul";
 		}
 	
 	}
 	return rtnVal; 
}

function chkLastKyuljea(AprLineRow) {
	var i, rtnVal;
	var aprtype;
	rtnVal = true;
	
	for(i=0;i < AprLineRow.length - 1; i++) {
		aprtype = GetAttribute(AprLineRow[i],"DATA11");

		if (addLastKyulJeYN == "1") {
			if (aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType8 || aprtype == strAprType15 || aprtype == strLangS264) break;
			if (aprtype == strAprType9 || aprtype == strAprType12 || aprtype == strAprType11) {
				rtnVal = false;
				break;
			}

		} else if (addLastKyulJeYN == "2") {
			if (aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType8 || aprtype == strAprType15 || aprtype == strLangS264) break;
			if (aprtype == strAprType9 || (GetAttribute(AprLineRow[0],"DATA11") != strAprType11 && GetAttribute(AprLineRow[0],"DATA11") != strAprType8 && aprtype == strAprType12)) {
				rtnVal = false;
				break;
			}
		} else if (addLastKyulJeYN == "0") {

			if (aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strLangS264) break;
			if (aprtype == strAprType8 || aprtype == strAprType9 || aprtype == strAprType12 || aprtype == strAprType11) {
				rtnVal = false;
				break;
			}
		}
	}
	return rtnVal;
}

function chkHabyuiGamsa(AprLineRow)  
{
	var i, rtnVal;
	var aprtype, H, G;
	H = 0;
	G = 0;
	rtnVal = true;
	
	for(i=0;i < AprLineRow.length - 1; i++)
	{
		aprtype = GetAttribute(AprLineRow[i],"DATA11")
		if(aprtype == strLangS53 || aprtype == strAprType12 || aprtype == strAprType11)
			H = H + 1;
		if(aprtype == strLangS264 || aprtype == strAprType5)
			G = G + 1;
	}
	if (H > 0 && G > 0)
		rtnVal = false;
	return rtnVal; 
}

function chkLastKyuljeaCF(AprLineRow) {
	var i, rtnVal;
	var aprtype;
	rtnVal = true;
	for(i=0;i < AprLineRow.length - 1; i++)	{
		aprtype = GetAttribute(AprLineRow[i],"DATA11");
		
		if (addLastKyulJeYN == "1") {
			if (aprtype == strAprType8 || aprtype == strLangS214 || aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strLangS264) break;
			if (aprtype == strAprType2) {
				rtnVal = false;
				break;
			}

		} else if (addLastKyulJeYN == "2") {
			if (aprtype == strAprType8 || aprtype == strAprType11 || aprtype == strLangS214 || aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strLangS264) break;
			if (aprtype == strAprType2) {
				rtnVal = false;
				break;
			}
		}  else {
			if (aprtype == strLangS214 || aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strLangS264) break;
			if (aprtype == strAprType2) {
				rtnVal = false;
				break;
			}
		}
	
	}
	return rtnVal;
}

function chkbeforeGamSa(AprLineRow)
{
	var afterApr;
 	var afterAprflag;
 	var i;
 	var rtnVal;
 	afterApr = 0;
 	afterAprflag = false;
 	rtnVal = true;
 	
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 		
 		if(AprLineRow[i].cells[4].innerText == strLangS264)
 		{
 			afterAprflag = true;		
 		}
 		
 		if(afterAprflag)
 		{
 			if(GetAttribute(AprLineRow[i],"DATA11") == strAprType15 || AprLineRow[i].cells[4].innerText == strLangS264)	
 			    afterApr = 0;
 			else
 				afterApr = afterApr + 1;
 		}	
 	}
 	
 	if(afterAprflag)
	{ 	
 		if(afterApr > 0) rtnVal = true;
 		else
 			rtnVal = false;
	}
	return rtnVal
}
function chkafterGamSa(AprLineRow)
{
	var afterApr;
 	var afterAprflag;
 	var i;
 	var rtnVal;
 	afterApr = 0;
 	afterAprflag = false;
 	rtnVal = true;
 	
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType15)
 		{
 			afterAprflag = true;		
 		}
 		
 		if(afterAprflag)
 		{
	        afterApr = afterApr + 1;
 		}	
 	}
 	
 	if(afterAprflag)
	{ 	
 		if(afterApr > 1) rtnVal = false;
 		else
 			rtnVal = true;
	}
	return rtnVal
}
function chkafterdeptHabyui(AprLineRow)
{
	var afterApr = 0;
 	var afterAprflag = 0;
 	var i, j, k;
 	var rtnVal;
 	afterApr = 0;
 	afterAprflag = false;
 	rtnVal = true;
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType12)
 		{
 			afterAprflag = i;
 			break;		
 		}
 	}

 	for(j = AprLineRow.length - 1; j >= 0;j--)
 	{
 		if(GetAttribute(AprLineRow[j],"DATA11") == strAprType12)
 		{
 			afterApr = j;
 		}
 	}

 	if (afterApr != afterAprflag)
 	{
 		for(afterAprflag ; afterAprflag >= afterApr ; afterAprflag--)
 		{
 			if(GetAttribute(AprLineRow[i],"DATA11") != strAprType12)
 			{
 				rtnVal = false;
 				break;		
 			}
 		}
 	}
	return rtnVal;
}
function chkDrafterTongje(AprLineRow)
{
 	if (GetAttribute(AprLineRow[AprLineRow.length-1],"DATA11") == strAprType31)
 		return false;
 	else
 		return true;
}
function chkSusinUser(AprLineRow)
{
 	var i, j, k;
 	var rtnVal = true;
 	
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType14) 
 		{ 
 			if (approvalFlag == "S") {
 				SetAttribute(AprLineRow[i], "DATA11", document.getElementById("lvAPRLINE_TR_" + i + "select").value);
 			} else {
 				rtnVal = false;
 			}
 		}
 	}
	return rtnVal;
}
function chkTongjeCheck(AprLineRow)
{
 	var i, j, k;
 	var rtnVal = true;
 	
	if (pReDraftFlag == "DRAFT" || pReDraftFlag == "REDRAFT")
	{
		rtnVal = true;
	}
	else
	{
 		for(i = AprLineRow.length - 1; i >= 0;i--)
 		{
 			if(GetAttribute(AprLineRow[i],"DATA11")  == strAprType31) 
 			{
 				rtnVal = false;
 			}
 		}
 	}
	return rtnVal;
}
function ChkWhoKyulDuplicate(AprLineRow)
{
 	var i, j, k;
 	var rtnVal = true;
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 		
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType40)
 		{
 			var tempUserID = GetAttribute(AprLineRow[i], "DATA4") != null ?  GetAttribute(AprLineRow[i], "DATA4").toLowerCase() : "";
 			for (j = i - 1; j>=0; j--)
 			{
 				if (GetAttribute(AprLineRow[j],"DATA11") == strAprType40 && (GetAttribute(AprLineRow[j], "DATA4") != null ? GetAttribute(AprLineRow[j], "DATA4").toLowerCase() : "") == tempUserID)
 					rtnVal = false;
 			}
 		}
 	}
	return rtnVal;
}
function ChkWhoKyulLast(AprLineRow)
{
	if (GetAttribute(AprLineRow[AprLineRow.length - 1],"DATA11") == strAprType40)
	
		return false;

    for(var i = 0 ; i < AprLineRow.length ; i++)
    {
        if(GetAttribute(AprLineRow[i],"DATA11") == strAprType7)
        {
        }
    	else if (GetAttribute(AprLineRow[i],"DATA11") == strAprType40)
    	{
	    	return false;
	    }
	    else
	    {
	        break;
	    }
	}
		
	return true;
}
function CheckWorkFlowXML(AprLineRow)
{
	var CheckNodes = SelectNodes(WorkFlowXML,"LINESCHECK/MUST/APRLINE");
	var i=0;
	var rtnVal = "";
	for (i=0; i<CheckNodes.length; i++)
	{
	    var pAprType = SelectSingleNodeValue(CheckNodes[i],"APRTYPE") ;
		var pClass = SelectSingleNodeValue(CheckNodes[i],"CLASS") ;
		var pValue = SelectSingleNodeValue(CheckNodes[i],"VALUE") ;
		var pDesc = SelectSingleNodeValue(CheckNodes[i],"DESC") ;
		
		rtnVal += checkAprLine(pAprType, pClass, pValue, pDesc, AprLineRow, "MUST");
	}
	
	CheckNodes = SelectNodes(WorkFlowXML,"LINESCHECK/MUSTNOT/APRLINE");
	for (i=0; i<CheckNodes.length; i++)
	{
		var pAprType = SelectSingleNodeValue(CheckNodes[i],"APRTYPE") ;
		var pClass = SelectSingleNodeValue(CheckNodes[i],"CLASS") ;
		var pValue = SelectSingleNodeValue(CheckNodes[i],"VALUE") ;
		var pDesc = SelectSingleNodeValue(CheckNodes[i],"DESC") ;
		
		rtnVal += checkAprLine(pAprType, pClass, pValue, pDesc, AprLineRow, "MUSTNOT");
	}
	return rtnVal;
}
function CheckDraftDeptID( AprLineRow )
{
	if(GetAttribute(AprLineRow[AprLineRow.length - 1],"DATA6") != arr_userinfo[4]
		&& (GetAttribute(AprLineRow[AprLineRow.length - 1],"DATA12") == strAprState2 || GetAttribute(AprLineRow[AprLineRow.length - 1],"DATA12") == strAprState1) )
		return false;
	
	return true;
}
/**
 *  최종결재가 이후로 참조 추가 체크.(프리텔레콤)
 * */
function CheckChamjo(AprLineRow) {
	var i, rtnVal;
	var aprtype;
	rtnVal = true;
	for(i=0;i < AprLineRow.length - 1; i++)	{
		aprtype = GetAttribute(AprLineRow[i],"DATA11");
		if (aprtype == strLangS214 || aprtype == strAprType1 || aprtype == strAprType4) break;
		if (aprtype == strAprType7) {
			rtnVal = false;
			break;
		}
	}
	return rtnVal;
}

function ReDraftSaveAprLine() {
    if (pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "WHOKYUL") {
        if (!pReDraftAprLineFlag) {
            AlterAprLineType();
        }
    }
    else if (pReDraftFlag == "REDRAFT") {
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/deleteSignInfo.do",
    		data : {
    				docID : pDocID, 
    				},
    		success: function(result){
    		}
    	});
    	
        if (!pReDraftAprLineChangeFlag) {
            Ans = true;
            if (Ans) {
                AprLineChangeType();

                pReDraftAprLineChangeFlag = true;
            }
            else {
                AprLineBanSongChangeType();
            }
        }
        else {
            AprLineChangeType();
        }

    }
}
function AlterAprLineType() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");

    var pAprRow = pAPRLINE.GetDataRows();
    var pAprRowLen = pAprRow.length;
    var i;

    var TmpAprLineStateReadyCode, TmpAprLineStateReadyName;
    var TmpAprLineStateJinhangCode, TmpAprLineStateJinhangName;

    TmpAprLineStateReadyCode = strAprState1;
    TmpAprLineStateReadyName = strLangAprState1;

    TmpAprLineStateJinhangCode = strAprState2;
    TmpAprLineStateJinhangName = strLangAprState2;

    for (i = 0 ; i < pAprRowLen ; i++) {
        var TmpAprLineState = GetAttribute(pAprRow[i], "DATA12");
        if (TmpAprLineState != strAprState3) {
            SetAttribute(pAprRow[i], "DATA12", TmpAprLineStateReadyCode);
            pAprRow[i].cells[5].innerHTML = TmpAprLineStateReadyName;
        }
        else {
            SetAttribute(pAprRow[i - 1], "DATA12", TmpAprLineStateJinhangCode);
            pAprRow[i - 1].cells[5].innerHTML = TmpAprLineStateJinhangName;
            break;
        }
    }
}
//결재선, 수신처에 데이터가 있는지 검사하는 함수
function Checkline() {
    if (!bool) {
        Lineinfo_ini();
    }
    if (!bool2) {
        Receptinfo_ini();
    }
    if (approvalFlag == "G") {
    	if (!bool3) {
    		Cabinetinfo_ini();
    	}
    	if (!bool4) { //2013.09.10. 에너지관리공단 lyn : 반송문서 재기안 시 쪽수를 입력하라는 문구 떠서 추가 (Docinfo_ini 만 빠져있었음)
    		Docinfo_ini();
    	}
    } else {
    	if (!bool3) {
            Draftinfo_ini();
    	}
    }

    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pAprRow = pAPRLINE.GetDataRows();

    if (pAprRow.length == 1 && pAprRow[0].id == "lvRECEPTLIST_TR_noItems") {
        OpenAlertUI(strLang266);
        var tabshow = document.getElementById("1tab2");
        Tab1_MouseClick(tabshow);
        return false;
    }

    if (pSuSinFlag != "N") {
        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");
        var receptRow = listview.GetDataRows();

        var CurListLen = receptRow.length;
        if (CurListLen == 0 || (CurListLen == 1 && receptRow[0].id == "lvRECEPTLIST_TR_noItems") && pDocType != "002") {
            OpenAlertUI(linealt14);
            var tabshow = document.getElementById("1tab2");
            Tab1_MouseClick(tabshow);
            return false;
        }
    }
    
    if (approvalFlag == "S") {
    	var FormList = new ListView();
        FormList.LoadFromID("lvinfolist");
        var cnt = FormList.GetSelectedRows().length;
        if (cnt == 0 && pkeeperiod == "") {
            var FrequencyFormList = new ListView();
            FrequencyFormList.LoadFromID("lvinfofrequencylist");
            var cnt2 = FrequencyFormList.GetSelectedRows().length;
            if (cnt2 == 0 && pkeeperiod == "") {
                OpenAlertUI(strLangS599);
                document.getElementById("1tab3").onclick();
                return false;
            }
        }
    }
}


//기안자 정보를 삽입하는 함수
function AddDraftUser(pSN,pAprType,pDraftDayFlag,pAprState)
{
	var GetXml;
	var pDraftDay = "";
	if(pDraftDayFlag)
		pDraftDay = getGyulJeDateDB();
	GetXml = "<ROW>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(pSN) + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(arr_userinfo[2]) + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(arr_userinfo[3]) + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(arr_userinfo[5]) + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(pAprType) + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(pAprState) + "</COLUMN>";
	GetXml = GetXml + "<DATA name='ProcessDate'>" + "" + "</DATA>";
	GetXml = GetXml + "<DATA name='ReceivedDate'>" + pDraftDay + "</DATA>";
	GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
	GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(pUserID) + "</DATA>";
	GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + "N" + "</DATA>";
	GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(arr_userinfo[4]) + "</DATA>";
	GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + "" + "</DATA>";
	GetXml = GetXml + "<DATA name='isProposerYN'>" + "N" + "</DATA>";
	GetXml = GetXml + "<DATA name='isBriefUserYN'>" + "N" + "</DATA>";
	GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(arr_userinfo[11]) + "</DATA>";		//primary usernm
	GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(arr_userinfo[12]) + "</DATA>";		//secondary usernm
	GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(arr_userinfo[15]) + "</DATA>";	//primary deptname
	GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(arr_userinfo[16]) + "</DATA>";	//secondary deptname
	GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(arr_userinfo[13]) + "</DATA>";	//primary title
	GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(arr_userinfo[14]) + "</DATA>";	//secondary title

	GetXml = GetXml + "</ROW>";
	return GetXml;
}

function setRep_Suggester()
{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    
    var Row = pAPRLINE.GetDataRows();//APRLINE.rows;
	var CurListLen = Row.length;
	
	var i;	
	for(i=0;i<CurListLen;i++)
	{	
		//Row = APRLINE.rows(i)		
		if(Row[i])
		{	
		    if(CrossYN())
            {
                Row[i].cells[0].textContent = Row[i].cells[0].innerText.replace("" + strLang75 + "","")
			    Row[i].cells[0].textContent = Row[i].cells[0].innerText.replace("" + strLang76 + "","")
    				
			    //if(Row.cells[0].DATA8 == "Y")
			    if(GetAttribute(Row[i], "DATA8") == "Y")
			    {
				    //Row.cells(0).innerText = "" + strLang75 + "" + Row.cells(0).innerText  
				    Row[i].cells[0].textContent = "" + strLang75 + "" + Row[i].cells[0].innerText  
				    chkSuggester = true;
			    }
    			
			    //if(Row.cells(0).DATA8 == "")
			    if(GetAttribute(Row[i], "DATA8") == "")
			    {
				    //Row.cells(0).DATA8 = "N"
				    SetAttribute(Row[i], "DATA8", "N");
				    Suggester.checked = false;
			    }
    			
			    //if(Row.cells(0).DATA9 == "Y")
			    if(GetAttribute(Row[i], "DATA9") == "Y")
			    {
				    //Row.cells(0).innerText = "" + strLang76 + "" + Row.cells(0).innerText  
				    Row[i].cells[0].textContent = "" + strLang76 + "" + Row[i].cells[0].innerText  
				    chkReporter = true;
			    }
    			
			    //if(Row.cells(0).DATA9 == "")
			    if(GetAttribute(Row[i], "DATA9") == "")
			    {			
				     //Row.cells(0).DATA9 = "N"
				     SetAttribute(Row[i], "DATA9", "N");
				     Reporter.checked = false; 					 
			    }
            }
            else
            {
                Row[i].cells[0].innerText = Row[i].cells[0].innerText.replace("" + strLang75 + "","")
			    Row[i].cells[0].innerText = Row[i].cells[0].innerText.replace("" + strLang76 + "","")
    				
			    //if(Row.cells[0].DATA8 == "Y")
			    if(GetAttribute(Row[i], "DATA8") == "Y")
			    {
				    //Row.cells(0).innerText = "" + strLang75 + "" + Row.cells(0).innerText  
				    Row[i].cells[0].innerText = "" + strLang75 + "" + Row[i].cells[0].innerText  
				    chkSuggester = true;
			    }
    			
			    //if(Row.cells(0).DATA8 == "")
			    if(GetAttribute(Row[i], "DATA8") == "")
			    {
				    //Row.cells(0).DATA8 = "N"
				    SetAttribute(Row[i], "DATA8", "N");
				    Suggester.checked = false;
			    }
    			
			    //if(Row.cells(0).DATA9 == "Y")
			    if(GetAttribute(Row[i], "DATA9") == "Y")
			    {
				    //Row.cells(0).innerText = "" + strLang76 + "" + Row.cells(0).innerText  
				    Row[i].cells[0].innerText = "" + strLang76 + "" + Row[i].cells[0].innerText  
				    chkReporter = true;
			    }
    			
			    //if(Row.cells(0).DATA9 == "")
			    if(GetAttribute(Row[i], "DATA9") == "")
			    {			
				     //Row.cells(0).DATA9 = "N"
				     SetAttribute(Row[i], "DATA9", "N");
				     Reporter.checked = false; 					 
			    }
            }			
		}
    }
}

function OnSelChangeDoEvent(pSelectedRow)
{
  try
  {
	if(pSelectedRow.length != "0")
	{
		//var p_CurAprStat  = pSelectedRow.cells(5).innerText;
		var p_CurAprStat  = pSelectedRow[0].cells[5].textContent;		
		var Proposer;
		var BriefUser;
	    //var ClickValue = pSelectedRow.cells(4).innerText;
		//var Selectedvalue = pSelectedRow[0].childNodes[4].childNodes[0].selectedIndex;
		//var ClickValue = pSelectedRow[0].childNodes[4].childNodes[0].childNodes[Selectedvalue].textContent
		//var ClickValue = pSelectedRow[0].cells[4].innerText;
		//var ReasonNo = pSelectedRow.cells(0).DATA7;              
		var ReasonNo = GetAttribute(pSelectedRow[0], "DATA7");              
		var pClickValue;
        
		//pSelAprLineType = ConvertAprLineState(p_CurAprStat, "Code")  		
		//pClickValue = ConvertAprLineType(ClickValue, "Code")  
		        
		pSelAprLineType = GetAttribute(pSelectedRow[0], "DATA12");
		pClickValue = GetAttribute(pSelectedRow[0], "DATA11");
		if(pSelAprLineType == "003" && pReDraftFlag != "REDRAFT")       //기안시 , 결재선 변경시 승인자 처리
		{
			//AprlineType.disabled = true;
			Reporter.disabled = true;
			Suggester.disabled = true;				
		}			
		else if(pSelAprLineType != "003" && pReDraftFlag != "REDRAFT")  // 기안시 , 일반 결재참가자 처리 
		{
			if(pReDraftAprLineFlag)                                       //결재선 변경시 
			{
				if(pSelAprLineType == "002") // 자신이던 아니던 바꿀수 없다. && pSelectedRow.cells(0).DATA4 == pUserID)  //다음결재자가 결재선변경자인경우
				{
					//AprlineType.disabled = true;
					Reporter.disabled = true;
					Suggester.disabled = true;										
				}
				else if(pSelAprLineType == "005")
				{
					//AprlineType.disabled = true;
					Reporter.disabled = true;
					Suggester.disabled = true;										
				}
				else
				{
				    if (pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI") {
				        Reporter.disabled = true;
				        Suggester.disabled = true;
				    }
				    else {
				        Reporter.disabled = false;
				        Suggester.disabled = false;
				    }
				}
			}
			else
			{                                              
				//전결 --> 결재안함 Setting 된것 disable 체크 함수 호출
				if(pClickValue == "003")
				{
					var RtnVal = CheckJunGyulState();  //결재안함 체크 -> 전결에 의한 여부 조사
					if(RtnVal)
					{
						//AprlineType.disabled = true;  
						Reporter.disabled = true;
						Suggester.disabled = true;
					}
					else
					{
						//AprlineType.disabled = false;      
						Reporter.disabled = false;
						Suggester.disabled = false;
					}
				}
				else
				{
				    if (pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI") {
				        Reporter.disabled = true;
				        Suggester.disabled = true;
				    }
				    else{
				        Reporter.disabled = false;
				        Suggester.disabled = false;    
				    }
				}
			}
		}
		else
		{
		    if (pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI") {
		        Reporter.disabled = true;
		    }
		    else {
		        Reporter.disabled = false;
		        Suggester.disabled = false;
		    }
		}

		// 결재안함 사유란 초기화
		ReasonNoAprTxt.value = "";				
		//AprlineType.value = ClickValue;		
		// 2012-09-04 IE,Chrome 의 경우 SelectBox에서 선택값이 없을 경우 자동으로 빈값으로 보이게 되지만
		// 파폭,사파리의 경우 첫벗째값으로 자동 선택되기 때문에 체크로직을 추가함.
//		var opCheck=false;
//		for(cnt=0;cnt < AprlineType.options.length; cnt++)
//		{		    
//		    if(AprlineType.options[cnt].value==ClickValue)
//		    {
//		        opCheck=true;
//		        break;
//		    }
//		}
//		if(opCheck)
//		    AprlineType.value = ClickValue;
//		else AprlineType.selectedIndex=-1;
		
			
		// Row의 결재선 정보가 결재안함 상태인경우
		if(pClickValue == "003" && pSelAprLineType != "003")
		{                     
			ReasonNoAprTxt.value = ReasonNo;
			ReasonNoAprTxt.disabled = false;                
			ReasonNoApr.disabled = false;
		}
	}
  }
  catch(e)
  {
	alert("OnSelChangeDoEvent :: " + e.description);
  }
}

function btnAddEtcDept_onclick(pType) {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");
        var AprLineRow = pAPRLINE.GetDataRows();
        AprLineAddIndex = AprLineRow.length;
        AprLineAddIndex = AprLineAddIndex + 1;

        //불필요한 결재선 체크 로직 수정. 결재선에 결재 유형만 있을 때, 에러 발생. 2020-03-09 홍대표
//        if (AprLineRow.length == 1) {
//            if (GetAttribute(AprLineRow[0], "DATA11") == strAprType1 || GetAttribute(AprLineRow[0], "DATA11") == strAprType4 || GetAttribute(AprLineRow[0], "DATA11") == strAprType16) {
//                var pAlertContent = "" + strLang298 + "<br>" + strLang299 + "";
//                OpenAlertUI(pAlertContent);
//                return;
//            }
//        }
        

        var tr = pAPRLINE.GetSelectedRows();
        if (tr.length > 0 && InsertMode != "Add") {
            AprLineAddIndex = parseInt(getNodeText(tr[0].cells[0]));
        }

        var Resultxml;
        var pDeptID = "", pDeptName = "", pDeptName2 = "", pEx2 = "";
       
        if (SelectNodes(GamsaYesanInfoXML, "DATA/ROW").length > 0) {
            for (i = 0; i < SelectNodes(GamsaYesanInfoXML, "DATA/ROW").length; i++) {

                if (SelectSingleNodeValue(SelectNodes(GamsaYesanInfoXML, "DATA/ROW")[i], "APRTYPE") == pType) {
                    pDeptID = SelectSingleNodeValue(SelectNodes(GamsaYesanInfoXML, "DATA/ROW")[i], "CN");
                    pDeptName = SelectSingleNodeValue(SelectNodes(GamsaYesanInfoXML, "DATA/ROW")[i], "DISPLAYNAME");
                    pDeptName2 = SelectSingleNodeValue(SelectNodes(GamsaYesanInfoXML, "DATA/ROW")[i], "DISPLAYNAME2");
                    pEx2 = SelectSingleNodeValue(SelectNodes(GamsaYesanInfoXML, "DATA/ROW")[i], "EXTENSIONATTRIBUTE2");
                    Resultxml = AprLineEtcDeptAdd(AprLineAddIndex, pType, pDeptID, pDeptName, pDeptName2, pEx2);

                    break;
                }
            }
        }
        else {
            OpenAlertUI("해당부서 정보가 존재하지 않습니다.");
            return false;
        }


        var InitTr = pAPRLINE.GetDataRows();
        var MaxID = 0;

        for (var j = 0; j < InitTr.length; j++) {
            var curnum = Number(pAPRLINE.GetSelectedRowID(j).substring(pAPRLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAPRLINE.GetSelectedRowID(j).length);
            if (MaxID < curnum)
                MaxID = curnum;
        }


        if (InitTr.length == 0) {
            //첫번째 row는 기안자가 꼭 있어야함.           
            OpenAlertUI("기안자가 등록되지 않았습니다.");
            return false;
        }
        else {
            var objTr = pAPRLINE.NewAddRow(0, "lvAPRLINE" + "_TR_" + eval(MaxID + 1));
            pAPRLINE.AddDataRow(objTr, Resultxml);
        }

        AprLineAddIndex = AprLineAddIndex + 1;


        setRep_Suggester();
        aprlinecount = 0;
        LineAprTyepSetAll();
    }
    catch (e) {
    	OpenAlertUI(e.description);
    }
}

function AprLineEtcDeptAdd(AprLineAddIndex, nAprType, pDeptID, pDeptName, pDeptName2, pEx2) {
    var pparsingXML = "<LISTVIEWDATA><HEADERS>";
    pparsingXML = pparsingXML + "<HEADER><NAME></NAME><WIDTH>30</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME></NAME><WIDTH>50</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME></NAME><WIDTH>60</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME></NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME></NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME></NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME></NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL><STYLE><![CDATA[overflow: hidden; text-overflow: ellipsis; white-space: nowrap;]]></STYLE>";
    pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
    pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
    pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
    pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
    pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(pDeptID) + "</DATA4>";
    pparsingXML = pparsingXML + "<DATA5>" + "Y" + "</DATA5>";
    pparsingXML = pparsingXML + "<DATA6>" + MakeXMLString(pDeptID) + "</DATA6>";
    pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
    pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
    pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
    pparsingXML = pparsingXML + "<DATA10>" + MakeXMLString(pEx2) + "</DATA10>";
    pparsingXML = pparsingXML + "<DATA11>" + nAprType + "</DATA11>";
    pparsingXML = pparsingXML + "<DATA12>" + strAprState1 + "</DATA12>";
    pparsingXML = pparsingXML + "<DATA13>-</DATA13>";
    pparsingXML = pparsingXML + "<DATA14>-</DATA14>";
    pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(pDeptName) + "</DATA15>";
    pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(pDeptName2) + "</DATA16>";
    pparsingXML = pparsingXML + "<DATA17>-</DATA17>";
    pparsingXML = pparsingXML + "<DATA18>-</DATA18>";
    pparsingXML = pparsingXML + "</CELL><CELL><STYLE><![CDATA[overflow: hidden; text-overflow: ellipsis; white-space: nowrap;]]></STYLE>";
    pparsingXML = pparsingXML + "<VALUE>-</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL><STYLE><![CDATA[overflow: hidden; text-overflow: ellipsis; white-space: nowrap;]]></STYLE>";
    pparsingXML = pparsingXML + "<VALUE>-</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL><STYLE><![CDATA[overflow: hidden; text-overflow: ellipsis; white-space: nowrap;]]></STYLE>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pDeptName) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL><STYLE><![CDATA[overflow: hidden; text-overflow: ellipsis; white-space: nowrap;]]></STYLE>";
    pparsingXML = pparsingXML + "<VALUE>" + AprTypeToName(nAprType) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL><STYLE><![CDATA[overflow: hidden; text-overflow: ellipsis; white-space: nowrap;]]></STYLE>";
    pparsingXML = pparsingXML + "<VALUE>" + strLangAprState1 + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL><STYLE><![CDATA[overflow: hidden; text-overflow: ellipsis; white-space: nowrap;]]></STYLE><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>";

    return loadXMLString(pparsingXML);
}

//회람
function APRLINEXMLParsingCC() {
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
        		strXML = strXML + "<DATA name='SMemberDeptName'>" + MakeXMLString(GetAttribute(pTotalRows[i], "DATA16")) + "</DATA>";
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

//2020-04-28 : 결재선 부서검색
function btnAprLineSearchDept_onClick() {
	try{
        var tmpDeptName = document.getElementById("textUser").value;
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
				search : "EXACT_EXTENSIONATTRIBUTE2::" + CompanyID + ";;displayname::" + tmpDeptName,
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
					"</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
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
                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
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
        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
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

function list2_onSel_DBclick_audit(table_id) {
	var pUserList = new ListView();      
    pUserList.LoadFromID(table_id);

	//var selnode = pUserList.GetSelectedRows();
    var rows = pUserList.GetDataRows();
	var RtnVal = CheckSignCellValue();  
    
    InsertMode = "Add";	
    
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("lvAPRLINE");
    
    for(var i=0; i<rows.length; i++) {
    	var selnode = new Array();
    	selnode.push(rows[i]);
    	
    	if (RtnVal) {
        	if (approvalFlag == "S") {
        		var lineArea = CheckLineArea_BeforeAdd();
        		if (!lineArea) {return;}
    			
    			for(var j = selnode.length-1 ; j >= 0 ; j--){
    				SAPRLINEATTENDADDFunction(selnode[j], "PERSON");
    			}
        	} else {
        		if (selnode.length != 0) {
    				aprlinecount = 0;

        			for(var j = selnode.length-1 ; j >= 0 ; j--)
        				APRLINEATTENDADDFunction(selnode[j], "PERSON");
        		}
        	}
        }
    }
}

function btnReceiptSearchDept_onClick() {
    try{
        var tmpDeptName = document.getElementById("textUser2").value;
        if (tmpDeptName.length == 0) {
            var pAlertContent = strLang240;
            document.getElementById("textUser2").focus();
            OpenAlertUI(pAlertContent);
            return;
        }

        var xmlDOM, adCount;
        $.ajax({
            type : "POST",
            dataType : "text",
            async : false,
            url : "/ezOrgan/getSearchList.do",
            data : {
                search : "EXACT_EXTENSIONATTRIBUTE2::" + CompanyID + ";;displayname::" + tmpDeptName,
                cell   : "extensionAttribute3;displayname;extensionAttribute9;",
                prop   : "",
                type   : "group"
            },
            success: function(xml){
                document.getElementById("textUser2").focus();
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
                "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
            g_xmlHTTP.onreadystatechange = event_getReceiptDeptFullTree;
            g_xmlHTTP.send(strQuery);
        }
        else {
            var rgParams = new Array();
            rgParams["addrBook"] = xmlDOM;
            rgParams["deptid"] = "";
            
            checkname2_cross_dialogArguments[0] = rgParams;
            checkname2_cross_dialogArguments[1] = btnReceiptSearchDept_onClick_Complete2;

            DivPopUpShow(609, 372, "/ezPersonal/checkName2.do");
        }

    }catch(e){}
}

function btnReceiptSearchDept_onClick_Complete2(rgParams) {
    DivPopUpHidden();
    if (rgParams["deptid"] != "") {
        g_xmlHTTP = createXMLHttpRequest();
        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
        g_xmlHTTP.onreadystatechange = event_getReceiptDeptFullTree;
        g_xmlHTTP.send(strQuery);
    }
}

function event_getReceiptDeptFullTree() {
    if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
        if (g_xmlHTTP.status == 200) {
            document.getElementById('TreeView2').innerHTML = "";
            var treeView = new TreeView();
            treeView.SetID("tvTreeView2");
            treeView.SetUseAgency(true);
            treeView.SetUseSusinColor4AprG(true);
            treeView.SetRequestData("RequestData2");
            treeView.SetNodeClick("TreeViewNodeClick2");
            treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
            treeView.DataBind("TreeView2");

            treeViewScrollTo("tvTreeView2");   //2020-04-24 : 선택된 노드로 트리뷰 커서 이동
        }
        else {
            alert(strLang249 + g_xmlHTTP.status);
            g_xmlHTTP = null;
        }
    }
}
