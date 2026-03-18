//#############################################################################################################################################결재선 초기화
function Lineinfo_ini() {
    if (!Lineinfoini) {
    	if (approvalFlag == "S") {
            Tree_setconfig();
            Lineinfoini = true;
            InitListView();
            if (typeof(OrgAprUserDeptID) != "undefined" && OrgAprUserDeptID != "") {
            	TreeViewinitialize(OrgAprUserDeptID, companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "", "", orgCompanyID);
            } else {
            	TreeViewinitialize(arr_userinfo[4], companyID + "/other", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "", "", orgCompanyID);
            }
            displayUserList(DeptID);
            ChangeLineTab("Organ");
            initJunGyul();
            CheckCurAprLine();
    	} else {
    		Tree_setconfig();
    		Lineinfoini = true;
    		TreeViewinitialize(arr_userinfo[4], companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "");
    		InitListView();
            ChangeLineTab("Organ");
        }
        treeViewScrollTo("FromTreeView");   //2020-04-24 : 선택된 노드로 트리뷰 커서 이동
    }
}

function circulation_ini() {
	getGongRamDocInfo();
	Tree_setconfig();
	if (typeof(OrgAprUserDeptID) != "undefined" && OrgAprUserDeptID != "") {
		TreeViewinitialize(OrgAprUserDeptID, companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "", "circulation", orgCompanyID);
	} else {
		TreeViewinitialize(arr_userinfo[4], companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "", "circulation", orgCompanyID);
	}
    displayUserListCC(DeptID);
    InitListViewCC();
    ChangeLineTabCC("Organ");

    treeViewScrollTo("FromTreeViewCC");   //2020-04-24 : 선택된 노드로 트리뷰 커서 이동
}
//#############################################################################################################################################결재선 내부 탭 이벤트
var internalTab = false;
function ChangeLineTab(divname) {
    if (divname == "Organ") {
        document.getElementById("OrganLineTab").style.display = "";
        document.getElementById("TempLineTab").style.display = "none";
		document.getElementById("AddRemoveBTN2").style.display = "";
        internalTab = true;
    } else {
        if(!Lineinfoini2)
        {            
            Lineinfoini2 = true;
            InitAprlineTemplet();
        }
        document.getElementById("OrganLineTab").style.display = "none";
        document.getElementById("TempLineTab").style.display = "";
		document.getElementById("AddRemoveBTN2").style.display = "none";
    }
}

function ChangeLineTabCC(divname) {
    try {
        if (divname == "Organ") {
            document.getElementById("Organ").style.display = "";
            document.getElementById("ReceptTempCC").style.display = "none";
        } else if (divname == "Save") {
            document.getElementById("Organ").style.display = "none";
            document.getElementById("ReceptTempCC").style.display = "";
            GetReceptTempletListCC();
        }
    } catch (e) {
        alert("ChangeReceptTab::" + e.description);
    }
}

function GetReceptTempletListCC() {
    try {
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : true,
    		url : "/ezApprovalG/getLineTemplist.do",
    		data : {
    				userID 	 : pUserID,
    				formID   : "ZZZZZZZZ"
    				},
    		success: function(text){
    			event_GetReceptTempletListCC(text);
    		}        			
    	});
    	
    } catch (e) {
        alert("GetReceptTempletListCC::" + e.description);
    }
}
function event_GetReceptTempletListCC(result) {
    try {
        if (document.getElementById("RecSaveListCC").innerHTML != "") {
        	document.getElementById("RecSaveListCC").innerHTML = "";
        }
        
        var liveView = new ListView();
        liveView.SetID("lvRecSaveListCC");
        liveView.SetRowOnClick("lvRecSaveListCC_onSel_Click");
        liveView.SetSelectFlag(true);
        liveView.SetHeightFree(true);
        liveView.DataSource(loadXMLString(result));
        liveView.DataBind("RecSaveListCC");

        var pCurSelRow = liveView.GetSelectedRows();
        if (pCurSelRow.length != 0) {
            GetReceptTempletInfoCC(pCurSelRow[0].getAttribute("DATA1"));
        }
        else {
            document.getElementById("RecSaveDetailCC").innerHTML = "";
        }
        xmlhttp = null;
    }
    catch (e) {
        alert("event_GetReceptTempletListCC::" + e.description);
    }
}

function lvRecSaveListCC_onSel_Click() {
    try {
        var liveView = new ListView();
        liveView.SetID("lvRecSaveListCC");
        var pCurSelRow = liveView.GetSelectedRows();
        if (pCurSelRow.length != 0) {
            GetReceptTempletInfoCC(pCurSelRow[0].getAttribute("DATA1"));
        }
    } catch (e) {
        alert("lvRecSaveListCC_onSel_Click::" + e.description);
    }
}

function GetReceptTempletInfoCC(p_AprLineTempletID) {
    try {
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : true,
    		url : "/ezApprovalG/aprLineTempletListInfo.do",
    		data : {
    				userID 	 : pUserID,
    				formID   : "ZZZZZZZZ",
    				aprLineSN: p_AprLineTempletID
    				},
    		success: function(text){
    			event_GetReceptTempletInfoCC(text);
    		}        			
    	});
    } catch (e) {
        alert("GetReceptTempletInfoCC::" + e.description);
    }
}
function event_GetReceptTempletInfoCC(result) {
    try {
        if (document.getElementById("RecSaveDetailCC").innerHTML != "")
            document.getElementById("RecSaveDetailCC").innerHTML = "";
        var pAPRTEMP = new ListView();
        pAPRTEMP.SetID("lvRecSaveDetailCC");
        pAPRTEMP.SetMulSelectable(false);
        pAPRTEMP.SetHeightFree(true);
        pAPRTEMP.SetSelectFlag(false);
        pAPRTEMP.DataSource(loadXMLString(result));
        pAPRTEMP.DataBind("RecSaveDetailCC");
        xmlHTTP = null;
    }
    catch (e) {
        alert("event_GetReceptTempletInfoCC::" + e.description);
    }
}

function CheckCurAprLine()
{
    var pAPRLINE = new ListView();    
    pAPRLINE.LoadFromID("lvAPRLINE");
    
    var pTotalRows = pAPRLINE.GetDataRows();
    var pTotalRowsLen = pTotalRows.length;
    var i;
	
    for(i = 0 ; i < pTotalRowsLen ; i++)
    {
        var tr = pTotalRows[i]; 
		
		var p_CurAprStat = GetAttribute(tr,"DATA12");
		if(p_CurAprStat == "002")
		{
		    CurAprLine = parseInt(tr.cells[0].innerText);
			return;
		}
    }
    CurAprLine = 0;
}
//#############################################################################################################################################트리뷰 Tree_setconfig()
function Tree_setconfig() {
    var xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
    xmlHTTP.send();
    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
        var treeView = new TreeView();
        treeView.SetConfig(xmlHTTP.responseXML);
    }
}
//############################################################################################################################################# 결재선 리스트 결재유형 드랍다운박스 처리 
//S버젼 안쓰는거같아서 주석
function LineAprTyepSet() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pSelectedRow = pAPRLINE.GetSelectedRows();
    var p_isDept = GetAttribute(pSelectedRow[0], "DATA5")
    var AprTyepID = "";
    var CurrentSn = getNodeText(pSelectedRow[0].childNodes.item(0));
    var p_StatusDis = GetAttribute(pSelectedRow[0], "DATA12") == "003" ? "disabled" : "";
    if (p_isDept == "Y") {
        var AprTypeObj = SChangeAprlineType("group", GetAttribute(pSelectedRow[0], "DATA11"));
        AprTyepID = GetAttribute(pSelectedRow[0], "id") + "select";
        AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style=\"width:100%;\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
        pSelectedRow[0].childNodes[4].innerHTML = AprTypeObj;
    } else {
        var AprTypeObj = SChangeAprlineType("user", GetAttribute(pSelectedRow[0], "DATA11"));
        AprTyepID = GetAttribute(pSelectedRow[0], "id") + "select";
        AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style=\"width:100%;\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
        pSelectedRow[0].childNodes[4].innerHTML = AprTypeObj;
    }
    
    LineAprTyepSetAll();
}

var p_RejectFlag = false;
var ProSn = 0;
function LineAprTyepSetAll() {
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
	            else { /* 2023-08-02 민지수 - 전자결재 > 부서합의 > 회송문서 재기안시 부서 결재유형 선택 활성화 */
	                /*if (GetAttribute(pTotalRows[i], "DATA12") == "015")
	                    p_StatusDis = "disabled";*/
	                
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
		
		if($(this).attr("DATA8") == "Y" && $(this).attr("DATA11") == "008") {
			text = "★";
		} else if($(this).attr("DATA9") == "Y" && $(this).attr("DATA11") == "005") {
			auditCount2++;
			if(auditCount1 > 1 && auditCount1 == auditCount2) {
				text = "⊙";
			}
		}
		
		$(this).attr('id', id);
		$(this).children('td:first').text(text+(index+1));
		$(this).children().find('select').attr("id", id + 'select');
	});
}

//############################################################################################################################################# 결재방법 지정 함수
var onclickLine = true;
function AprlineType_onchangeLine(obj) {
    if (onclickLine && CrossYN()) {
        onclickLine = false;
        setTimeout(AprlineType_onchangeLine, 1, obj);
    } else {
        var pCheckTypevalue = obj.value;
        var TypeName = obj.childNodes[obj.selectedIndex].innerText;

        var Rtnval = true;

        if (pCheckTypevalue == "008" || pCheckTypevalue == "009" || pCheckTypevalue == "011" || pCheckTypevalue == "012") {
            if (pHapyuiArea == 0 && pHapYuiCount != "0")
                Rtnval = CheckHapYuiCellValue();
        }
        
        if (Rtnval && (pCheckTypevalue == "013" || pCheckTypevalue == "021" )) {
            Rtnval = CheckGamsaYesan(pCheckTypevalue, obj);
        }

        if (Rtnval)
            APRLINETYPECHANGEFunction(pCheckTypevalue, TypeName);
        
        if (approvalFlag == "S") {
        	if (TypeName != strLangAprType4) {
                checkdisabled();
            }
        	
            onclickLine = true;
        }
    }
}
//############################################################################################################################################# 결재선 리스트 초기화
var xmlhttp;
function InitListView() {
    try {
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/aprLineRequest.do",
    		data : {
    				docID    : pDocID, 
    				userID 	 : pUserID,
    				formID   : pFormID,
    				deptID 	 : arr_userinfo[4],
    				reDraft  : pReDraftFlag,
    				isUsed   : "",
    				mode     : "",
    				orgCompanyID : companyID
    				},
    		success: function(xml){
    			result = xml;
    		}        			
    	});
    	
    	result = loadXMLString(result);
    	
        var NodeList = createXmlDom();
        NodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");
        
        var nodeCnt;
        nodeCnt = NodeList.length;
        
        var pAPRLINE = new ListView();  
        pAPRLINE.SetID("lvAPRLINE");
        pAPRLINE.SetMulSelectable(false);
        pAPRLINE.SetHeightFree(true);
        pAPRLINE.SetDrop("aprlineDrop");
        pAPRLINE.SetRowOnClick("OnSelChange_onclick");
        pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
        pAPRLINE.SetSelectFlag(false);
        
        if (approvalFlag == "S") {
        	if (pAdmin == "Y") {
        		var DraftNode = createXmlDom();
        	    DraftNode = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW")[nodeCnt - 1];
        	    var IniListData4 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA4").trim();
        	    var IniListData6 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA6").trim();
        	    var IniListData10 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA10").trim();
        	    var IniListData13 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA13").trim();
        	    var IniListData14 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA14").trim();
        	    var IniListData15 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA15").trim();
        	    var IniListData16 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA16").trim();
        	    var IniListData17 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA17").trim();
        	    var IniListData18 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA18").trim();
        	    var curaprline = "";
        	    for (var i = 0; i < NodeList.length; i++) {
        	        if (SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "DATA12") == strAprState2) {
        	            curaprline = SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "VALUE");
        	            break;
        			}
        		}
        		pAPRLINE.DataSource(result);
            	pAPRLINE.DataBind("APRLINE");
        	} else {
//fomace        		
        	    if (nodeCnt <= 1) {        	    	
        	        var DraftXml;
        	        DraftXml = AddDraftUserFirst(); 
        	        Resultxml = loadXMLString(DraftXml);
        	        pAPRLINE.DataSource(Resultxml);
        	        pAPRLINE.DataBind("APRLINE");
        	    } else {
        	        var DraftNode = createXmlDom();
        	        DraftNode = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW")[nodeCnt - 1];
        	        var IniListData4 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA4").trim(); // 결재자ID
        	        var IniListData6 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA6").trim(); // 결재자부서ID
        	        var IniListData10 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA10").trim(); // 결재자LDAP경로
        	        var IniListData13 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA13").trim(); // 결재자 이름
        	        var IniListData14 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA14").trim(); // 결재자 이름(다국어)
        	        var IniListData15 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA15").trim(); // 결재자 부서명
        	        var IniListData16 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA16").trim(); // 결재자 부서명 (다국어)
        	        var IniListData17 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA17").trim(); // 결재자 직위
        	        var IniListData18 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA18").trim(); // 결재자 직위 (다국어)
        	        
        	        if(IniListData6!=null && IniListData6 != "" && IniListData6 != arr_userinfo[4] && orgCompanyID != "" && orgCompanyID != arr_userinfo[17] && pReDraftFlag != "REDRAFT") { //2018-10-25 배현상, 사간겸직 조건 추가
            	    	arr_userinfo[4] = IniListData6;
            	    }
        	        
        	        var curaprline = "";
        	        for (var i = 0; i < NodeList.length; i++) {
        	            if (SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "DATA12") == strAprState2) { // APRSTATE (002, 진행)
        	                curaprline = SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "VALUE");
        	                break;
        	            }
        	        }
        	        if ((IniListData4 == arr_userinfo[1] && IniListData6 == arr_userinfo[4] && IniListData10 == companyID && IniListData13 == arr_userinfo[11] &&
        	            IniListData14 == arr_userinfo[12] && IniListData15 == arr_userinfo[15] && IniListData16 == arr_userinfo[16] && IniListData17 == arr_userinfo[13] && IniListData18 == arr_userinfo[14]) || curaprline != 1) {

        	            var susinreset = false;
        	            for (var i = 0; i < NodeList.length; i++) {
        	                if (SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "DATA11") == strAprType14) { // APRTYPE (014, 수신)
        	                    susinreset = true; // 결재선 상에 수신 타입의 결재자가 존재한다는 것은, 수신부서에서 회송된 문서를 의미한다.
        	                    isSusinReset = true;
        	                    break;
        	                }
        	            }
        	            if (susinreset) {
        	                var DraftXml;
        	                //DraftXml = AddDraftUserFirst();
        	                DraftXml = addOrgAprLine(); // 수신부서에서 회송된 문서의 경우, 원문서의 결재선을 불러온다.
        	                Resultxml = loadXMLString(DraftXml);
        	                pAPRLINE.DataSource(Resultxml);
        	                pAPRLINE.DataBind("APRLINE");
        	            }
        	            else {
        	                pAPRLINE.DataSource(result);
        	                pAPRLINE.DataBind("APRLINE");
        	            }
        	        } else {        	        	
        	            var DraftXml;
        	            DraftXml = AddDraftUserFirst();
        	            Resultxml = loadXMLString(DraftXml);
        	            pAPRLINE.DataSource(Resultxml);
        	            pAPRLINE.DataBind("APRLINE");
        	        }
        	    }
        	}
        	
            LineAprTyepSetAll();
        } else {
        	var tempdeptname = "";
        	
        	var curaprline = 1;
        	for (var i = 0; i < NodeList.length; i++) {
        		if (SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "DATA12") == strAprState2 
        				|| SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "DATA12") == strAprState5) { //2018-08-25 강민수92 보류일때 결재선나오게하기위해 추가
        			curaprline = SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "VALUE");
        			break;
        		}
        	}
        	
        	if (nodeCnt > 0) {
        		if (CrossYN())
        			tempdeptname = result.documentElement.getElementsByTagName("DATA6")[nodeCnt - 1].textContent;
        		else
        			tempdeptname = result.documentElement.getElementsByTagName("DATA6")[nodeCnt - 1].text;
        	}
        	if (curaprline == 1 && tempdeptname != arr_userinfo[4]) {
        		var DraftXml;
        		DraftXml = AddDraftUserFirst();
        		Resultxml = loadXMLString(DraftXml);
        		pAPRLINE.DataSource(Resultxml);
        		pAPRLINE.DataBind("APRLINE");
        	}
        	else {
        		var DraftNode = createXmlDom();
        		DraftNode = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW")[nodeCnt - 1];
        		var IniListData4 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA4").trim();
        		var IniListData6 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA6").trim();
        		var IniListData10 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA10").trim();
        		var IniListData13 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA13").trim();
        		var IniListData14 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA14").trim();
        		var IniListData15 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA15").trim();
        		var IniListData16 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA16").trim();
        		var IniListData17 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA17").trim();
        		var IniListData18 = SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA18").trim();
        		if ((IniListData4 == arr_userinfo[1] && IniListData6 == arr_userinfo[4] && IniListData10 == companyID && IniListData13 == arr_userinfo[11] &&
        				IniListData14 == arr_userinfo[12] && IniListData15 == arr_userinfo[15] && IniListData16 == arr_userinfo[16] && IniListData17 == arr_userinfo[13] && IniListData18 == arr_userinfo[14]) || curaprline != 1) {
        			var susinreset = false;
        			for (var i = 0; i < NodeList.length; i++) {
        				if (SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "DATA11") == strAprType14) {
        					susinreset = true;
        					break;
        				}
        			}
        			if (susinreset) {
        				var DraftXml;
        				DraftXml = AddDraftUserFirst();
        				Resultxml = loadXMLString(DraftXml);
        				pAPRLINE.DataSource(Resultxml);
        				pAPRLINE.DataBind("APRLINE");
        			}
        			else {
        				pAPRLINE.DataSource(result);
        				pAPRLINE.DataBind("APRLINE");
        			}
        		}
        		else {
        			var DraftXml;
        			DraftXml = AddDraftUserFirst();
        			Resultxml = loadXMLString(DraftXml);
        			pAPRLINE.DataSource(Resultxml);
        			pAPRLINE.DataBind("APRLINE");
        		}
        	}
        	// 비전자문서 기안 시, 마지막 결재선이 그대로 나오는 에러 수정
        	if (nonElecRec == "Y" && pIniGubun == "1") {
        		var DraftXml;
        		document.getElementById("APRLINE").innerHTML = "";
        		DraftXml = AddDraftUserFirst();
        		Resultxml = loadXMLString(DraftXml);
        		pAPRLINE.DataSource(Resultxml);
        		pAPRLINE.DataBind("APRLINE");
        	}
        	
        	LineAprTyepSetAll();
        	
        	if (pReDraftFlag != "HAPYUI" && pReDraftFlag != "HABYUI") {
        		for (var i = 0; i < pAPRLINE.GetRowCount() ; i++) {
        			if (pAPRLINE.GetDataRows()[i].getAttribute("DATA8") == "Y") {
        				pAPRLINE.GetDataRows()[i].childNodes[0].innerHTML = "★" + pAPRLINE.GetDataRows()[i].childNodes[0].innerHTML;
        			}
        			if (pAPRLINE.GetDataRows()[i].getAttribute("DATA9") == "Y") {
        				pAPRLINE.GetDataRows()[i].childNodes[0].innerHTML = "⊙" + pAPRLINE.GetDataRows()[i].childNodes[0].innerHTML;
        			}
        		}
        	}
        }
    } catch (e) {
        alert("InitListView :: " + e.description);
    }
}

function InitListViewCC() {
    try {
    	var result = "";
    	var pMode = "APR";
    	
    	/* 2021-04-19 홍승비 - 수신부서에서 회송된 문서의 경우, 원문서(완료문서)의 회람(공람) 정보를 가져오도록 수정 */
    	if (typeof(isSusinReset) != "undefined" && isSusinReset == true) {
    		pMode = "END2";
    	}
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getLineList.do",
    		data : {
    			docID : pGongRamDocID,
    			mode  : pMode,
    			docState : "015",
    			orgCompanyID : companyID
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

        var pAPRLINE = new ListView();
        pAPRLINE.SetID("pAPRLINE");
        pAPRLINE.SetMulSelectable(false);
        pAPRLINE.SetRowOnDblClick("AprlineDel_onclickCC");
        pAPRLINE.SetSelectFlag(false);
        pAPRLINE.SetHeightFree(true);
        pAPRLINE.DataSource(loadXMLString(result));
        pAPRLINE.DataBind("APRLINECC");
    }
    catch (e) {
        alert("InitListViewCC :: " + e.description);
    }
}

//회람
function CheckAprlineCC() {
    var listview = new ListView();
    listview.LoadFromID("pAPRLINE");

    var objRows = listview.GetDataRows();

    //회람탭 안눌렀을떄
	if (objRows == undefined) {
		getGongRamDocInfo();
	    InitListViewCC();
	    
	    return CheckAprlineCC();
	}
    var totCnt = objRows.length;
    var newCnt = 0;
    
    if (objRows.length > 0 && objRows[0].id == "pAPRLINE_TR_noItems") {
    	totCnt = 0;
    }

    for (var i = 0 ; i < totCnt ; i++) {
        if (GetAttribute(objRows[i], "DATA12") == "001") {
            newCnt++;
        }
    }
    var beforeCnt = totCnt - newCnt;

    if (totCnt == 0)
        return -1;
    else if (beforeCnt == totCnt)
        return 0;
    else if (beforeCnt != 0 && beforeCnt < totCnt)
        return 1;
    else
        return 2;
}

/*
 * 전자결재S인 경우 '전결'이 중간 단계에 들어갈 수 있기 때문에 
 * 이 함수를 통해 나머지 뒤의 결재를 초기화 시킨다. 
 * 전자결재G는 '전결'이 항상 마지막에 위치.
 */
function initJunGyul() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pTotalRows = pAPRLINE.GetDataRows();

    if (pTotalRows == undefined)
        return;

    var pTotalRowsLen = pTotalRows.length;

    for (var i = pTotalRowsLen - 1; i > 0; i--) {
        if (GetAttribute(pTotalRows[i], "DATA5") == "N") {
            for (var z = 0; z < pTotalRows[i].cells[4].childNodes[0].length; z++) {
                var temprowvalue = getNodeText(pTotalRows[i].cells[4].childNodes[0].options[z]);
                
                if (pTotalRows[i].cells[4].childNodes[0].options[z].selected && temprowvalue == strLangAprType4) {
                    SetAttribute(pTotalRows[i], "DATA11", strAprType4);
                    for (var y = 0; y < i; y++) {
                        var SelectObjectId = GetAttribute(pTotalRows[y], "id") + "select";

                        var p_Option = document.createElement("OPTION");
                            setNodeText(p_Option,strLangAprType3);

                        p_Option.setAttribute("value", "003");
                        p_Option.setAttribute("value2", strLangAprType3);

                        var AprTypeObj = "<select id='" + SelectObjectId + "' disabled style='width:100%;'>" + p_Option.outerHTML + "</select>";
                        pTotalRows[y].cells[4].innerHTML = AprTypeObj;
                        SetAttribute(pTotalRows[y], "DATA11", strAprType3);
                    }

                }
            }

        }
    }
}
//#############################################################################################################################################트리뷰 더블클릭 이벤트 TreeViewNodeClick()
function TreeViewNodeClick() {
    var nodeIdx = 1;
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    var selnode = treeView.GetSelectNode();
    DeptID = selnode.GetNodeData("CN");
    displayUserList(DeptID);
}
function TreeViewNodeDbClick() {
    return;
}

function TreeViewNodeClickCC() {
	var nodeIdx = 1;
	var treeView = new TreeView();
	treeView.LoadFromID("FromTreeViewCC");
	var selnode = treeView.GetSelectNode();
	DeptID = selnode.GetNodeData("CN");
	displayUserListCC(DeptID);
}
function TreeViewNodeDbClickCC() {
	return;
}

function displayUserListCC(DeptID) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezOrgan/getDeptMemberList.do",
		data : {
				deptID   : DeptID,
				cell 	 : "displayName;description;title;telephoneNumber;extensionattribute5",
				prop     : "department;extensionAttribute4;displayName;description;title",
				type 	 : "user"
		},
		success: function(xml){
			xml = loadXMLString(xml);		
			if (document.getElementById("UserListCC").innerHTML != "")
		        document.getElementById("UserListCC").innerHTML = "";
			
			var headerData = createXmlDom();
		    headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
		    
		    if (xml != "") {
		        if (CrossYN()) {
		            var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
		            var Node = headerData.importNode(xmlRtn, true);
		            headerData.documentElement.appendChild(Node);
		        } else {
		            var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
		            headerData.documentElement.appendChild(xmlRtn);
		        }
		    }
		    
			var listview = new ListView();
		    listview.SetID("DivUserList");
		    listview.SetMulSelectable(false);
		    listview.SetRowOnClick("list3_onSel_Click");
		    listview.SetRowOnDblClick("list3_onSel_DBclick");
		    listview.SetSelectFlag(false);
		    listview.SetHeightFree(true);
		    listview.DataSource(headerData);
		    listview.DataBind("UserListCC");
		},
		error: function(request) {
			alert(strLang821 + request.responseText);
		}
	});
}
//#############################################################################################################################################조직도 트리 및 사용자 리스트 함수 사용 부분 displayUserList()
var xmlhttpUserlist;
function displayUserList(DeptID) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezOrgan/getDeptMemberList.do",
		data : {
				deptID   : DeptID, 
				cell 	 : "displayName;description;title;telephoneNumber;extensionattribute5",
				prop     : "department;displayName;description;title",
				type 	 : "user"
		},
		success: function(xml){
			event_displayUserList(loadXMLString(xml));
		}        			
	});
}
function event_displayUserList(xml) {
    var retXml = createXmlDom();

    if (document.getElementById("UserList").innerHTML != "")
        document.getElementById("UserList").innerHTML = "";

    var headerData = createXmlDom();
    headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
    if (xml != "") {
        if (CrossYN()) {
            var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
            var Node = headerData.importNode(xmlRtn, true);
            headerData.documentElement.appendChild(Node);
        }
        else {
            var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
            headerData.documentElement.appendChild(xmlRtn);
        }
    }
    var pUserList = new ListView();
    pUserList.SetID("pUserList");
    pUserList.SetRowOnClick("list2_onSel_Click"); 
    pUserList.SetRowOnDblClick("list2_onSel_DBclick");
    pUserList.SetDrag("list2_onDragStart");  //2020-04-27 : 드래그앤드랍 추가
    pUserList.SetSelectFlag(false);
    pUserList.SetHeightFree(true);
    pUserList.SetTitleIdx(1);
    pUserList.DataSource(headerData);                 
    pUserList.DataBind("UserList");

    var userRows = pUserList.GetDataRows();

    if (userRows.length <= 0) {
        OpenAlertUI(linealt11);
    }
    else if (USE_OCS.toUpperCase() == "YES") {
        check_presence();
    }
    
    var headersList = userlist_h.getElementsByTagName("header");
    
    for (var i = 0; i < headersList.length; i++) {
        var headerName = headersList[i].getElementsByTagName("name")[0].textContent;
        document.getElementById("pUserList_TH_" + i).innerText = headerName;
    }
}

function event_displayUserListCC(xml) {
	var retXml = createXmlDom();
	
	if (document.getElementById("UserListCC").innerHTML != "")
		document.getElementById("UserListCC").innerHTML = "";
	
	var headerData = createXmlDom();
	headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
	if (xml != "") {
		if (CrossYN()) {
			var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
			var Node = headerData.importNode(xmlRtn, true);
			headerData.documentElement.appendChild(Node);
		}
		else {
			var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
			headerData.documentElement.appendChild(xmlRtn);
		}
	}
	var pUserList = new ListView();
	pUserList.SetID("DivUserList");
	pUserList.SetRowOnClick("list3_onSel_Click");
	/* 2024-12-06 홍승비 - 공람자, 회람자 검색 > 검색결과 더블클릭으로 추가 시 list3_onSel_DBclick 함수로 통일 */
    pUserList.SetRowOnDblClick("list3_onSel_DBclick");
	pUserList.SetSelectFlag(false);
	pUserList.SetHeightFree(true);
	pUserList.SetTitleIdx(1);
	pUserList.DataSource(headerData);                 
	pUserList.DataBind("UserListCC");                   
	
	var userRows = pUserList.GetDataRows();
	
	if (userRows.length <= 0) {
		OpenAlertUI(linealt11);
	}
	else if (USE_OCS.toUpperCase() == "YES") {
		check_presence();
	}
}
//############################################################################################################################################# 조직도 사용자 검색
function textUser_onkeypress(e) {
    if (e.keyCode == "13") {
        document.getElementById("btn_searchUser").onclick();
    }
}
//############################################################################################################################################# 조직도 사용자 검색
function textUserCC_onkeypress(e) {
	if (e.keyCode == "13") {
		document.getElementById("btn_searchUserCC").onclick();
	}
}
//############################################################################################################################################# 조직도 사용자 검색 
function btn_searchUser_onclick() {
    searchUserList();
}
//############################################################################################################################################# 조직도 사용자 검색
function searchUserList(search)
{
  try{
    var searchdoc = document.getElementById("textUser");
	var strSearch = searchdoc.value + "";
	if (strSearch =="")
	{
	  	var pAlertContent = linealt3;
		OpenAlertUI(pAlertContent);
	    document.getElementById("textUser").focus();
	}
	else if (strSearch.length < 2 )
	{
	    var pAlertContent = linealt4;
        OpenAlertUI(pAlertContent);
        document.getElementById("textUser").focus();
	}
	else
	{
		$.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : "/ezOrgan/getSearchList.do",
			data : {
				search : "displayName::" + strSearch + ";;PhysicalDeliveryOfficeName::" + companyID,
				cell   : "displayName;description;title;telephoneNumber;extensionattribute5",
				prop   : "department;displayName;description;title",
				type   : "user"
			},
			success: function(xml){
				event_displayUserList(loadXMLString(xml));
			}    			
		});
	}
  }catch(ErrMsg){
    alert(ErrMsg.description);
  }
}

//############################################################################################################################################# 회람 조직도 사용자 검색
function btn_searchUserCC_onclick() {
	searchUserListCC();
}

function searchUserListCC(search)
{
	try{
		var searchdoc = document.getElementById("textUserCC");
		var strSearch = searchdoc.value + "";
		if (strSearch == "")
		{
			var pAlertContent = linealt3;
			OpenAlertUI(pAlertContent);
			document.getElementById("textUserCC").focus();
		}
		else if (strSearch.length < 2 )
		{
			var pAlertContent = linealt4;
			OpenAlertUI(pAlertContent);
			document.getElementById("textUserCC").focus();
		}
		else
		{
			$.ajax({
				type : "POST",
				dataType : "text",
				async : true,
				url : "/ezOrgan/getSearchList.do",
				data : {
					search : "displayName::" + strSearch + ";;PhysicalDeliveryOfficeName::" + companyID,
					cell   : "displayName;description;title;telephoneNumber;extensionattribute5",
					prop   : "department;extensionAttribute4;displayName;description;title",
					type   : "user"
				},
				success: function(xml){
					event_displayUserListCC(loadXMLString(xml));
				}    			
			});
		}
	}catch(ErrMsg){
		alert(ErrMsg.description);
	}
}
function GetProcessAprType(AprLineAddIndex, AprLineRow, pClass) {
    var retVal = "";

    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");
    var tr = pAPRLINE.GetSelectedRows();
    if (InsertMode == "Edit" && tr.length > 0) {
        retVal = GetAttribute(tr[0], "DATA11");
    }
    if (retVal == "011" || retVal == "012") {
        if (pClass != "DEPT") {
            retVal = "";
        }
    }
    else {
        if (pClass == "DEPT") {
            retVal = "";
        }
    }

    return retVal;
}
//############################################################################################################################################# 결재유형 명칭 다국어
function AprTypeToName(tempCode) {
    var retVal = "";

    switch (tempCode) {
        case "001":
            retVal = strLangAprType1;
            break;

        case "002":
            retVal = strLangAprType2;
            break;

        case "003":
            retVal = strLangAprType3;
            break;

        case "004":
            retVal = strLangAprType4;
            break;

        case "005":
            retVal = strLangAprType5;
            break;

        case "006":
            retVal = strLangAprType6;
            break;

        case "007":
            retVal = strLangAprType7;
            break;

        case "008":
            retVal = strLangAprType8;
            break;

        case "009":
            retVal = strLangAprType9;
            break;

        case "011":
            retVal = strLangAprType11;
            break;

        case "012":
            retVal = strLangAprType12;
            break;

        case "013":
            retVal = strLangAprType13;
            break;

        case "014":
            retVal = strLangAprType14;
            break;

        case "015":
            retVal = strLangAprType15;
            break;

        case "016":
            retVal = strLangAprType16;
            break;

        case "017":
            retVal = strLangAprType17;
            break;
        case "018":
            retVal = strLangAprType18;
            break;
        
        case "019":
            retVal = strLangAprType19;
            break;

        case "031":
            retVal = strLangAprType31;
            break;

        case "040":
            retVal = strLangAprType40;
            break;

        default:
            retVal = "";
            break;
    }
    return retVal;
}
//############################################################################################################################################# 기안자 정보 xml
function AddDraftUserFirst() {
    var pparsingXML;
    pparsingXML = "<LISTVIEWDATA><HEADERS>";
	pparsingXML += "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
	pparsingXML += "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
	pparsingXML += "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	pparsingXML += "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
	pparsingXML += "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>120</WIDTH></HEADER>";
	pparsingXML += "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>70</WIDTH></HEADER>";
	pparsingXML += "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>120</WIDTH></HEADER>";
    pparsingXML += "</HEADERS><ROWS>";
    pparsingXML += "<ROW><CELL>";
    pparsingXML += "<VALUE>" + "1" + "</VALUE>";
    pparsingXML += "<DATA1>" + "" + "</DATA1>";
    pparsingXML += "<DATA2>" + "" + "</DATA2>";
    pparsingXML += "<DATA3>" + pDocID + "</DATA3>";
    pparsingXML += "<DATA4>" + MakeXMLString(arr_userinfo[1]) + "</DATA4>";
    pparsingXML += "<DATA5>" + "N" + "</DATA5>";
    pparsingXML += "<DATA6>" + MakeXMLString(arr_userinfo[4]) + "</DATA6>";
    pparsingXML += "<DATA7>" + "" + "</DATA7>";
    pparsingXML += "<DATA8>" + "N" + "</DATA8>";
    pparsingXML += "<DATA9>" + "N" + "</DATA9>";
    pparsingXML += "<DATA10>" + MakeXMLString(companyID) + "</DATA10>";
    
    if (approvalFlag == "S") {
    	pparsingXML += "<DATA11>" + strAprType1 + "</DATA11>";
    } else {
    	if (approvalFlag == "G" && nonElecRec == "Y") {
    		pparsingXML += "<DATA11>" + strAprType1 + "</DATA11>";
    	} else {
    		pparsingXML += "<DATA11>" + strAprType18 + "</DATA11>";
    	}
    }
    pparsingXML += "<DATA12>" + strAprState1 + "</DATA12>";
    pparsingXML += "<DATA13>" + MakeXMLString(arr_userinfo[11]) + "</DATA13>";
    pparsingXML += "<DATA14>" + MakeXMLString(arr_userinfo[12]) + "</DATA14>";
    pparsingXML += "<DATA15>" + MakeXMLString(arr_userinfo[15]) + "</DATA15>";
    pparsingXML += "<DATA16>" + MakeXMLString(arr_userinfo[16]) + "</DATA16>";
    pparsingXML += "<DATA17>" + MakeXMLString(arr_userinfo[13]) + "</DATA17>";
    pparsingXML += "<DATA18>" + MakeXMLString(arr_userinfo[14]) + "</DATA18>";
    pparsingXML += "</CELL><CELL>";
    pparsingXML += "<VALUE>" + MakeXMLString(arr_userinfo[2]) + "</VALUE>";
    pparsingXML += "</CELL><CELL>";
    pparsingXML += "<VALUE>" + MakeXMLString(arr_userinfo[3]) + "</VALUE>";
    pparsingXML += "</CELL><CELL>";
    pparsingXML += "<VALUE>" + MakeXMLString(arr_userinfo[5]) + "</VALUE>";
    pparsingXML += "</CELL><CELL>";
    
    if (approvalFlag == "S") {
    	pparsingXML += "<VALUE>" + strLangAprType1 + "</VALUE>";
    } else {
    	if (approvalFlag == "G" && nonElecRec == "Y") {
    		pparsingXML += "<VALUE>" + strLangAprType1 + "</VALUE>";
    	} else {
    		pparsingXML += "<VALUE>" + strLangAprType18 + "</VALUE>";
    	}
    }
    pparsingXML += "</CELL><CELL>";
    pparsingXML += "<VALUE>" + strLangAprState2 + "</VALUE>";
    pparsingXML += "</CELL><CELL></CELL></ROW></ROWS></LISTVIEWDATA>";
    return pparsingXML;
}
var aprlinecount = 0;
/**
 * 결재선 리스트 유저의 결재유형을 찾아주는 함수
 * ex) 첫 번째 유저는 '기안'만 가능
 */
function ChangeAprlineType(CheckGPerson, CurrentAprType) {
    var ReturnValue = "";
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");
        if (CheckGPerson == "group") {
            var selDeptID = GetAttribute(pAPRLINE.GetSelectedRows()[0], "DATA4");
            var p_AprlineValue = new Array();
            var p_AprlineCode = new Array();

            var i = 0;
            var j = 0;

            for (i = 0; i < SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE").length; i++) {
                if (SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE") == strAprType13) {
                    if (pDeptgamsaCount > 0) {
                        p_AprlineValue[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "NAME");
                        p_AprlineCode[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE");
                        j = j + 1;
                    }
                }
                else {
                    if (pHapYuiCount > 0) {
                        p_AprlineValue[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "NAME");
                        p_AprlineCode[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE");
                        j = j + 1;
                    }
                }
            }
            aprlinecount++;
            var p_Aprlinelen = p_AprlineValue.length;
            for (i = 0; i < p_Aprlinelen; i++) {
                var p_Option = document.createElement("OPTION");

                p_Option.innerHTML = p_AprlineValue[i];
                p_Option.setAttribute("value", p_AprlineCode[i]);
                p_Option.setAttribute("value2", p_AprlineValue[i]);

                if (CurrentAprType == p_AprlineCode[i])
                    p_Option.setAttribute("selected", true);

                ReturnValue = ReturnValue + p_Option.outerHTML;
            }
        }
        else if (CheckGPerson == "user") {
            var selUserID = "";
            var selUserSN = "";
            var lastUserSN = "";

            if (CrossYN()) {
                selUserID = GetAttribute(pAPRLINE.GetDataRows()[aprlinecount], "DATA4");
                selUserSN = pAPRLINE.GetDataRows()[aprlinecount].childNodes[0].textContent.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "");
                lastUserSN = pAPRLINE.GetDataRows()[0].childNodes[0].textContent.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "");
            }
            else {
                selUserID = GetAttribute(pAPRLINE.GetDataRows()[aprlinecount], "DATA4");
                selUserSN = pAPRLINE.GetDataRows()[aprlinecount].childNodes[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "");
                lastUserSN = pAPRLINE.GetDataRows()[0].childNodes[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "");
            }
            aprlinecount++;
            
            //if (GetAttribute(pAPRLINE.GetDataRows()[aprlinecount], "DATA11") != strAprType15) {
                var p_AprlineValue = new Array();
                var p_AprlineCode = new Array();
                var i = 0;
                var j = 0;
                var tempName = "";
                var tempCode = "";
                var selLength = SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE").length;

                for (i = 0; i < selLength; i++) {
                    tempName = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE")[i], "NAME");
                    tempCode = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE")[i], "CODE");
                    switch (tempCode) {
                        case "001":
                            if (selUserSN == lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;

                        case "002":
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                            break;

                        case "003":
                            if (selUserID != pUserID) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;

                        case "004":
                            if (selUserSN == lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;                       

                        case "007":
                            if (pChamJoFlag == "Y" && pReDraftFlag != "GAMSABU") {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        case "008":
                            if (pHapYuiCount != "0" && selUserSN != "1" && selUserSN != lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        case "009":
                            if (pHapYuiCount != "0" && selUserSN != "1" && selUserSN != lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        case "016":
                            if (selUserSN == lastUserSN || selUserSN == (lastUserSN - 1)) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        case "018":
                            if (selUserSN == "1") {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        case "019":
                            if (selUserSN != "1" && selUserSN != lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        default:
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                            break;
                    }
                }

                var p_Aprlinelen = p_AprlineValue.length;
                var pAPRLINE = new ListView();
                pAPRLINE.LoadFromID("lvAPRLINE");
                var pTotalRows = pAPRLINE.GetDataRows();
                
                for (i = 0; i < p_Aprlinelen; i++) 
                {
                    var p_Option = document.createElement("OPTION");
                    p_Option.innerHTML = p_AprlineValue[i];
                    p_Option.setAttribute("value", p_AprlineCode[i]);
                    p_Option.setAttribute("value2", p_AprlineValue[i]);
                    
                    if (CurrentAprType == p_AprlineCode[i])
                    {             
                            p_Option.setAttribute("selected", true);
                    }
                    else if (selUserSN != lastUserSN && CurrentAprType == "001" && p_AprlineCode[i] == "019") {
                            p_Option.setAttribute("selected", true);

                    }
                    if(pTotalRows.length > 1)
                    {
                        if (selUserSN == 1 && p_AprlineCode[i] == "018") {
                            p_Option.setAttribute("selected", true);
                        }
                    }
                    ReturnValue = ReturnValue + p_Option.outerHTML;
                }
            //}
        }

    } catch (e) {
        alert("ChangeAprlineType :: " + e.description);
    }
    return ReturnValue;
}

//S전용
function SChangeAprlineType(CheckGPerson, CurrentAprType) {
    var ReturnValue = "";
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");
        if (CheckGPerson == "group") {
            var selDeptID = GetAttribute(pAPRLINE.GetSelectedRows()[0], "DATA4");
            var p_AprlineValue = new Array();
            var p_AprlineCode = new Array();

            var i = 0;
            var j = 0;

            for (i = 0; i < SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE").length; i++) {
                if (SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE") == strAprType13) {
                    if (pGamSaCount > 0) {
                        p_AprlineValue[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "NAME");
                        p_AprlineCode[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE");
                        j = j + 1;
                    }
                }
                else {
                    if (pHapYuiCount > 0) {
                        p_AprlineValue[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "NAME");
                        p_AprlineCode[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE");
                        j = j + 1;
                    }
                }
            }

            var p_Aprlinelen = p_AprlineValue.length;
            for (i = 0; i < p_Aprlinelen; i++) {
                var p_Option = document.createElement("OPTION");
                setNodeText(p_Option,p_AprlineValue[i]);

                p_Option.setAttribute("value", p_AprlineCode[i]);
                p_Option.setAttribute("value2", p_AprlineValue[i]);

                if (CurrentAprType == p_AprlineCode[i])
                    p_Option.setAttribute("selected", "true");

                ReturnValue = ReturnValue + p_Option.outerHTML;
            }
        }
        else if (CheckGPerson == "user") {
            var selUserID = GetAttribute(pAPRLINE.GetSelectedRows()[0], "DATA4");
            {
                var p_AprlineValue = new Array();
                var p_AprlineCode = new Array();
                var i = 0;
                var j = 0;
                var tempName = "";
                var tempCode = "";
                var selLength = SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE").length;

                for (i = 0; i < selLength; i++) {
                    tempName = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE")[i], "NAME");
                    tempCode = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE")[i], "CODE");

                    switch (tempCode) {
                        case "001":
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                            break;

                        case "002":
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                            break;

                        case "003":
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                            break;

                        case "004":
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                            break;

                        case "007":
                            if (pChamJoFlag == "Y" && pReDraftFlag != "GAMSABU") {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        case "008":
                            if (pHapYuiCount > 0) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        case "009":
                            if (pHapYuiCount > 0) {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;

                        case "031":
                            if (pReDraftFlag == "DRAFT" || pReDraftFlag == "REDRAFT") {
                                p_AprlineValue[j] = tempName;
                                p_AprlineCode[j] = tempCode;
                                j = j + 1;
                            }
                            break;
                        default:
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                            break;
                    }
                }

                var p_Aprlinelen = p_AprlineValue.length;
                for (i = 0; i < p_Aprlinelen; i++) {
                    var p_Option = document.createElement("OPTION");
                    setNodeText(p_Option,p_AprlineValue[i]);
                    p_Option.setAttribute("value", p_AprlineCode[i]);
                    p_Option.setAttribute("value2", p_AprlineValue[i]);
                    if (CurrentAprType == p_AprlineCode[i]) {
                        p_Option.setAttribute("selected", "true");
                    }
                    ReturnValue = ReturnValue + p_Option.outerHTML;

                }
            }
        }

    } catch (e) {
        alert("ChangeAprlineType :: " + e.description);
    }
    
    return ReturnValue;
}

function check_presence() {
    var pUserList = new ListView();
    pUserList.LoadFromID("pUserList");
    var totalRow = pUserList.GetDataRows();

    var pCNList = new Array();
    for (var i = 0; i <= totalRow.length - 1; i++) {
        pCNList[i] = GetAttribute(totalRow[i], "DATA2");
    }
    var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');

    pCNList = null;
    for (var i = 0; i < totalRow.length; i++) {
        if (pSIPUriList[i].trim() != "") {
            var TD = totalRow[i].childNodes[0];
            TD.innerHTML = "<div><img style='vertical-align:middle;' src='/images/Presence/unknown.gif' id ='" + GetGUID() + "' onload='PresenceControl(\"" + pSIPUriList[i] + "\",this);' /><span style='vertical-align:middle;padding-left:5px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width:61px;display:inline-block'>" + TD.innerHTML + "</span></div>";
        }
    }
    pSIPUriList = null;
}

//2020-04-27 : 드래그앤드랍 추가
function list2_onDragStart(ev) {
    dragTabMenu = "APRLINE";
    ev.dataTransfer.setData("text", ev.target.id);

    if (ev.target.getAttribute("selected") != "true") {
        $(ev.target).click();
    }
}

function aprlineDrop(ev) {
    if (dragTabMenu == "APRLINE") {  //결재선 추가
        list2_onSel_DBclick();  
    }
}

function listViewStart(xml, id, dbClick) {
    var retXml = createXmlDom();

    if (document.getElementById(id).innerHTML != "")
        document.getElementById(id).innerHTML = "";

    var headerData = createXmlDom();
    headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
    if (xml != "") {
    	var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
    	
    	if(xmlRtn.textContent == '') {
    		OpenAlertUI(linealt19);
    		return false;
    	}
    	
    	if (CrossYN()) {
            var Node = headerData.importNode(xmlRtn, true);
            headerData.documentElement.appendChild(Node);
        } else {
            headerData.documentElement.appendChild(xmlRtn);
        }
    }
    var auditUserList = new ListView();
    auditUserList.SetID('tb_'+id);
    auditUserList.SetSelectFlag(true);
    auditUserList.SetHeightFree(true);
    if(dbClick != undefined && dbClick != "") {
    	auditUserList.SetRowOnDblClick(dbClick);
    }
    auditUserList.DataSource(headerData);
    auditUserList.DataBind(id);

    var userRows = auditUserList.GetDataRows();

    if (userRows.length <= 0) {
        OpenAlertUI(linealt11);
    }
    else if (USE_OCS.toUpperCase() == "YES") {
        check_presence();
    }
    return true;
}
function CheckGamsaYesan(pAprType, pObj) {
    try {
        var pDeptID, pDeptName;
        for (i = 0; i < SelectNodes(GamsaYesanInfoXML, "DATA/ROW").length; i++) {
            if (SelectSingleNodeValue(SelectNodes(GamsaYesanInfoXML, "DATA/ROW")[i], "APRTYPE") == pAprType) {
                pDeptID = SelectSingleNodeValue(SelectNodes(GamsaYesanInfoXML, "DATA/ROW")[i], "CN");
                pDeptName = SelectSingleNodeValue(SelectNodes(GamsaYesanInfoXML, "DATA/ROW")[i], "DISPLAYNAME");
            }
        }

        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");

        var pSelRow = pAPRLINE.GetSelectedRows();
        if (pSelRow.length > 0) {
            if (pDeptID != GetAttribute(pSelRow[0], "DATA4")) {
                var pAlertContent = "";
                if (pAprType == "013")
                    pAlertContent = strLang1068 + pDeptName + strLang1070;
                else
                    pAlertContent = strLang1069 + pDeptName + strLang1070;

                OpenAlertUI(pAlertContent);
                
                pObj.value = GetAttribute(pSelRow[0], "DATA11");
                return false;
            }
        }
       
       return true;
    } catch (e) {
    	alert("CheckGamsaYesan :: " + e.description);
    }
}

function setDeptGamsaType(targetRow) {
	[].forEach.call(targetRow.childNodes[4].getElementsByTagName("option"), function(elem) {
		if(targetRow.getAttribute("DATA4") == optGamsabu && elem.value != strAprType13
		  || targetRow.getAttribute("DATA4") != optGamsabu && elem.value == strAprType13) {
			elem.parentNode.removeChild(elem);
		}
	})
}

/* 2021-04-16 홍승비 - 회송된 수신문서에 대하여, 완료된 원문서의 결재선을 가져와 결재정보에 맵핑하기 위한 함수 */
function addOrgAprLine() {
    try {
    	var result = "";
    	var pparsingXML = "";
    	var orgDocID = getOrgDocID();
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/aprLineRequest.do",
    		data : {
    				docID    : orgDocID, 
    				userID 	 : pUserID,
    				formID   : pFormID,
    				deptID 	 : arr_userinfo[4],
    				reDraft  : pReDraftFlag,
    				isUsed   : "",
    				mode     : "END",
    				orgCompanyID : companyID
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});
    	
    	result = loadXMLString(result);
    	
        var NodeList = createXmlDom();
        NodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");
        var nodeCnt;
        nodeCnt = NodeList.length;
        
        // 원문서의 결재선 카운트가 1개 이하인 경우, 기존의 결재선 초기화 함수를 실행한다.
        if (nodeCnt <= 1) {
        	pparsingXML = AddDraftUserFirst();
        } else {
        	var DraftNode = createXmlDom();
        	
            pparsingXML = "<LISTVIEWDATA><HEADERS>";
        	pparsingXML += "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
        	pparsingXML += "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
        	pparsingXML += "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        	pparsingXML += "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
        	pparsingXML += "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>120</WIDTH></HEADER>";
        	pparsingXML += "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>70</WIDTH></HEADER>";
        	pparsingXML += "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>120</WIDTH></HEADER>";
            pparsingXML += "</HEADERS>";
        	
        	for (var i = 0; i < nodeCnt; i++) {
	        	DraftNode = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW")[i]; // 기안자부터 최종결재자까지 결재선 생성 루프를 진행
	        	
	            pparsingXML += "<ROWS><ROW><CELL>";
	            pparsingXML += "<VALUE>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "VALUE").trim() + "</VALUE>"; // 결재순번
	            pparsingXML += "<DATA1>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA1").trim() + "</DATA1>"; // 결재일자
	            pparsingXML += "<DATA2>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA2").trim() + "</DATA2>"; // 도착일자
	            pparsingXML += "<DATA3>" + pDocID + "</DATA3>"; // 문서ID
	            pparsingXML += "<DATA4>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA4").trim() + "</DATA4>"; // 결재자ID
	            pparsingXML += "<DATA5>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA5").trim() + "</DATA5>"; // 결재자 또는 결재부서 플래그 (APRMEMBERISDEPTYN)
	            pparsingXML += "<DATA6>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA6").trim() + "</DATA6>"; // 결재자부서ID
	            pparsingXML += "<DATA7>" + "" + "</DATA7>"; // 결재안함사유 (REASONDONOTAPPROV)
	            pparsingXML += "<DATA8>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA8").trim() + "</DATA8>"; // 발의자 (ISPROPOSERYN)
	            pparsingXML += "<DATA9>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA9").trim() + "</DATA9>"; // 보고자 (ISBRIEFUSERYN) 
	            pparsingXML += "<DATA10>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA10").trim() + "</DATA10>"; // 결재자LDAP경로
	            pparsingXML += "<DATA11>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA11").trim() + "</DATA11>"; // 결재유형 (APRTYPE)
	            pparsingXML += "<DATA12>" + strAprState1 + "</DATA12>"; // APRSTATE는 대기로 고정
	            pparsingXML += "<DATA13>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA13").trim() + "</DATA13>"; // 결재자 이름
	            pparsingXML += "<DATA14>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA14").trim() + "</DATA14>"; // 결재자 이름 (다국어)
	            pparsingXML += "<DATA15>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA15").trim() + "</DATA15>"; // 결재자 부서명
	            pparsingXML += "<DATA16>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA16").trim() + "</DATA16>"; // 결재자 부서명 (다국어)
	            pparsingXML += "<DATA17>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA17").trim() + "</DATA17>"; // 결재자 직위
	            pparsingXML += "<DATA18>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA18").trim() + "</DATA18>"; // 결재자 직위 (다국어)
	            
	            pparsingXML += "</CELL><CELL>";
	            if (primary == "1") {
	            	pparsingXML += "<VALUE>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA13").trim() + "</VALUE>"; // 결재자 이름
	            } else {
	            	pparsingXML += "<VALUE>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA14").trim() + "</VALUE>"; // 결재자 이름 (다국어)
	            }
	            pparsingXML += "</CELL><CELL>";
	            if (primary == "1") {
	            	pparsingXML += "<VALUE>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA17").trim() + "</VALUE>"; // 결재자 직위
	            } else {
	            	pparsingXML += "<VALUE>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA18").trim() + "</VALUE>"; // 결재자 직위 (다국어)
	            }
	            pparsingXML += "</CELL><CELL>";
	            if (primary == "1") {
	            	pparsingXML += "<VALUE>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA15").trim() + "</VALUE>"; // 결재자 부서명
	            } else {
	            	pparsingXML += "<VALUE>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA16").trim() + "</VALUE>"; // 결재자 부서명 (다국어)
	            }
	            pparsingXML += "</CELL><CELL>";
	            pparsingXML += "<VALUE>" + SelectSingleNodeValue(GetChildNodes(DraftNode)[0], "DATA11").trim() + "</VALUE>"; // 결재유형 (APRTYPE)
	            pparsingXML += "</CELL><CELL>";
	            pparsingXML += "<VALUE>" + strLangAprState1 + "</VALUE>";  // APRSTATE는 대기로 고정
	            pparsingXML += "</CELL><CELL></CELL></ROW></ROWS>";
        	}
        	
        	pparsingXML += "</LISTVIEWDATA>";
        }
        
        return pparsingXML;
    } catch (e) {
        alert("addOrgAprLine :: " + e.description);
        pparsingXML = AddDraftUserFirst();
        return pparsingXML;
    }
}

/* 2021-04-19 홍승비 - 원문서의 DOCID를 가져오는 ajax 함수 추가 */
function getOrgDocID() {
	var orgDocID = "";
	
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getOrgDocIDByMode.do",
		data : {
				docID    : pDocID,
				mode : "APR",
				orgCompanyID : companyID
		},
		success: function(result){
			orgDocID = result;
		}
	});
	
	return orgDocID;
}
