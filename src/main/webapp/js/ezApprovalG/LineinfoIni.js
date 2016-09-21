//#############################################################################################################################################결재선 초기화
function Lineinfo_ini() {
    if (!Lineinfoini) {
        Tree_setconfig();
        Lineinfoini = true;
        TreeViewinitialize(arr_userinfo[4], companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "");
        InitListView();
        ChangeLineTab("Organ");
    }
}
//#############################################################################################################################################결재선 내부 탭 이벤트
var internalTab = false;
function ChangeLineTab(divname) {

    if (divname == "Organ") {
        document.getElementById("OrganLineTab").style.display = "";
        document.getElementById("TempLineTab").style.display = "none";
        internalTab = true;
    }
    else {
        if(!Lineinfoini2)
        {            
            Lineinfoini2 = true;
            InitAprlineTemplet();
        }
        document.getElementById("OrganLineTab").style.display = "none";
        document.getElementById("TempLineTab").style.display = "";
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
function LineAprTyepSet() {
    var pAPRLINE = new ListView(); 
    pAPRLINE.LoadFromID("lvAPRLINE");
    
    var pSelectedRow = pAPRLINE.GetSelectedRows();
    var p_isDept = pSelectedRow[0].getAttribute("DATA5")
    var p_StatusDis = pSelectedRow[0].getAttribute("DATA12") == "001" ? "" : pAPRLINE.GetDataRows().length == 1 ? "" : "disabled";
    var AprTyepID = "";
    if (p_isDept == "Y") {
        var AprTypeObj = ChangeAprlineType("group", pSelectedRow[0].getAttribute("DATA11"));
        AprTyepID = pSelectedRow[0].getAttribute("id") + "select";
        AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style =\"width:100%\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
        pSelectedRow[0].childNodes[4].innerHTML = AprTypeObj;
    } else {
        var AprTypeObj = ChangeAprlineType("user", pSelectedRow[0].getAttribute("DATA11"));
        AprTyepID = pSelectedRow[0].getAttribute("id") + "select";
        AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style =\"width:100%\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
        pSelectedRow[0].childNodes[4].innerHTML = AprTypeObj;
    }
}
var p_RejectFlag = false;
var ProSn = 0;
function LineAprTyepSetAll() {
    aprlinecount = 0;
    var pAPRLINE = new ListView();   
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pTotalRows = pAPRLINE.GetDataRows();
    for (var i = 0; i < pTotalRows.length; i++) {
        var p_isDept = pTotalRows[i].getAttribute("DATA5");
        var CurrentSn = CrossYN() ? pTotalRows[i].childNodes.item(0).textContent : pTotalRows[i].childNodes.item(0).innerText;
        
        if (pTotalRows[i].getAttribute("DATA12") == "002")
            ProSn = CurrentSn;

        if (pTotalRows[i].getAttribute("DATA12") == "004")
            p_RejectFlag = true;
        

        var p_StatusDis = (CurrentSn != 1 && (pTotalRows[i].getAttribute("DATA12") == "001" || p_RejectFlag)) ? "" : pTotalRows.length == 1 ? "" : "disabled";
        if ((pTotalRows[i].getAttribute("DATA11") == "009" || pTotalRows[i].getAttribute("DATA11") == "012") && parseInt(CurrentSn) < parseInt(ProSn))
            p_StatusDis = "disabled";

        if (p_isDept == "Y") {
            var AprTypeObj = ChangeAprlineType("group", pTotalRows[i].getAttribute("DATA11"));
            AprTyepID = pTotalRows[i].getAttribute("id") + "select";
            AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style =\"width:100%\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
            pTotalRows[i].childNodes[4].innerHTML = AprTypeObj;
        } else {
            var AprTypeObj = ChangeAprlineType("user", pTotalRows[i].getAttribute("DATA11"));
            AprTyepID = pTotalRows[i].getAttribute("id") + "select";
            AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchangeLine(this)\" style =\"width:100%\" " + p_StatusDis + " >" + AprTypeObj + "</select>";
            pTotalRows[i].childNodes[4].innerHTML = AprTypeObj;

            if (pTotalRows[i].childNodes[0].innerHTML != pTotalRows.length && pTotalRows[i].getAttribute("DATA11") == "001") {
                pTotalRows[i].setAttribute("DATA11", "019");
            }
            else if (pTotalRows[i].childNodes[0].innerHTML == "1" && pTotalRows[i].getAttribute("DATA11") == "001") {
                pTotalRows[i].setAttribute("DATA11", "018");
            }
            var selectedindex = pTotalRows[i].childNodes[4].childNodes[0].selectedIndex;
            pTotalRows[i].setAttribute("DATA11", pTotalRows[i].childNodes[4].childNodes[0].childNodes[selectedindex].value);
        }
    }
}
//############################################################################################################################################# 결재방법 지정 함수
var onclickLine = true;
function AprlineType_onchangeLine(obj) {
    if (onclickLine && CrossYN()) {
        onclickLine = false;
        setTimeout(AprlineType_onchangeLine, 1, obj);
    }
    else {
        var pCheckTypevalue = obj.value;
        var TypeName = obj.childNodes[obj.selectedIndex].innerText;

        var Rtnval = true;

        if (pCheckTypevalue == "008" || pCheckTypevalue == "009" || pCheckTypevalue == "011" || pCheckTypevalue == "012") {
            if (pHapyuiArea == 0 && pHapYuiCount != "0")
                Rtnval = CheckHapYuiCellValue();
        }

        if (Rtnval)
            APRLINETYPECHANGEFunction(pCheckTypevalue, TypeName);
    }
}
//############################################################################################################################################# 결재선 리스트 초기화
var xmlhttp;
function InitListView() {
    try {
    	var result = "";
    	$.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/aprLineRequest.do",
    		data : {
    				docID    : pDocID, 
    				userID 	 : pUserID,
    				formID   : pFormID,
    				deptID 	 : arr_userinfo[4]
    				},
    		success: function(xml){
    			result = xml;
    		}        			
    	});
                
        var NodeList = createXmlDom();
        
        NodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");
        
        var nodeCnt;
        nodeCnt = NodeList.length;
        
        var pAPRLINE = new ListView();  
        pAPRLINE.SetID("lvAPRLINE");
        pAPRLINE.SetMulSelectable(false);
        pAPRLINE.SetHeightFree(true);
        pAPRLINE.SetRowOnClick("OnSelChange_onclick");
        pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
        pAPRLINE.SetSelectFlag(false);
        
        var tempdeptname = "";

        var curaprline = 1;
        for (var i = 0; i < NodeList.length; i++) {
            if (SelectSingleNodeValue(GetChildNodes(NodeList[i])[0], "DATA12") == strAprState2) {
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
    } catch (e) {
        alert("InitListView :: " + e.description);
    }
}

function initJunGyul()
{
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRLINE");

    var pTotalRows = pAPRLINE.GetDataRows();
    var pTotalRowsLen = pTotalRows.length;
    
    for(var i = pTotalRowsLen-1; i > 0; i--)
    {
        if(pTotalRows[i].getAttribute("DATA5") == "N")
        {
            if( findOptionNum("A03004") != undefined && pTotalRows[i].cells[4].childNodes[0].options[findOptionNum("A03004")].selected)
            {
                for(var y=0; y < i; y++)
                {
                    pTotalRows[y].cells[4].childNodes[0].disabled = true;   
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
//#############################################################################################################################################조직도 트리 및 사용자 리스트 함수 사용 부분 displayUserList()
var xmlhttpUserlist;
function displayUserList(DeptID) {
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : true,
		url : "/ezOrgan/getDeptMemberList.do",
		data : {
				deptID   : DeptID, 
				cell 	 : "displayName;description;title;telephoneNumber",
				prop     : "department;displayName;description;title",
				type 	 : "user"
				},
		success: function(xml){
			event_displayUserList(xml);
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
    pUserList.SetSelectFlag(false);
    pUserList.SetHeightFree(true);
    pUserList.DataSource(headerData);                 
    pUserList.DataBind("UserList");                   

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
function btn_searchUser_onclick() {
    searchUserList();
}
//############################################################################################################################################# 조직도 사용자 검색
function searchUserList(search)
{
  try{
    var searchdoc = document.getElementById("textUser");
	var strSearch = searchdoc.value + "";
	if (textUser.value =="")
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
			dataType : "xml",
			async : true,
			url : "/ezOrgan/getSearchList.do",
			data : {
				search : "displayname::" + strSearch + ";;PhysicalDeliveryOfficeName::" + companyID,
				cell   : "displayname;description;title;telephonenumber",
				prop   : "department;displayName;description;title",
				type   : "user"
			},
			success: function(xml){
				event_displayUserList(xml);
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
	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>35</WIDTH></HEADER>";
	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>120</WIDTH></HEADER>";
	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>130</WIDTH></HEADER>";
	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>120</WIDTH></HEADER>";
	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>70</WIDTH></HEADER>";
	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>120</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "</HEADERS><ROWS>";
    pparsingXML = pparsingXML + "<ROW><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + "1" + "</VALUE>";
    pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
    pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
    pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
    pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(arr_userinfo[1]) + "</DATA4>";
    pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
    pparsingXML = pparsingXML + "<DATA6>" + MakeXMLString(arr_userinfo[4]) + "</DATA6>";
    pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
    pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
    pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
    pparsingXML = pparsingXML + "<DATA10>" + MakeXMLString(companyID) + "</DATA10>";
    pparsingXML = pparsingXML + "<DATA11>" + strAprType18 + "</DATA11>";
    pparsingXML = pparsingXML + "<DATA12>" + strAprState1 + "</DATA12>";
    pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(arr_userinfo[11]) + "</DATA13>";
    pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(arr_userinfo[12]) + "</DATA14>";
    pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(arr_userinfo[15]) + "</DATA15>";
    pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(arr_userinfo[16]) + "</DATA16>";
    pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(arr_userinfo[13]) + "</DATA17>";
    pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(arr_userinfo[14]) + "</DATA18>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[2]) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[3]) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[5]) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + strLangAprType18 + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + strLangAprState1 + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL></CELL></ROW></ROWS></LISTVIEWDATA>";
    return pparsingXML;
}
var aprlinecount = 0;
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