
//#############################################################################################################################################사용자리스트 원클릭 이벤트 list2_onSel_Click()
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
        if (selnode.length != 0) {
            aprlinecount = 0;
            APRLINEATTENDADDFunction(selnode, "PERSON");
        }
    }
}
//############################################################################################################################################# 결재선 삭제 함수
function AprlineDel_onclick() {
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
        var Event_ID = event.target.id || event.srcElement.id;
    }
    if (Event_ID.indexOf("lvAPRLINE_TR_") == -1) {
        if (nodelUser())
            APRLINEATTENDERDELFunction();
    }
}
function nodelUser()
{
    var pAPRLINE = new ListView();    
    pAPRLINE.LoadFromID("lvAPRLINE");
    var SelRow = pAPRLINE.GetSelectedRows();
    
	if(SelRow[0].getAttribute("DATA4").toLowerCase() == pUserID.toLowerCase() && SelRow[0].childNodes[0].innerHTML == "1")
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
                    if (child[i].nodeType == 1)
                        child[i].style.display = "";
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
        APRLINEATTENDADDFunction(pTreeSelNode, "DEPT");
    }
}
//############################################################################################################################################# 결재순번(Down) 1)
function AprlineDown_onclick() {
    APRLINESNDownFunction();
    aprlinecount = 0;
    LineAprTyepSetAll();
}
//############################################################################################################################################# 결재순번(Down) 2)
function APRLINESNDownFunction() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");
        var pSelectedRow = pAPRLINE.GetSelectedRows();
        
        if(pSelectedRow[0] == undefined){
            OpenAlertUI(strLang549);
            return;            
        }
        
        if(pSelectedRow[0].getAttribute("DATA4").toLowerCase() == pUserID.toLowerCase() && pSelectedRow[0].childNodes[0].innerHTML == "1")
	    {
	        OpenAlertUI(strLang550);    
	        return;
	    }
	    
        
        var pSelAprLineState = pSelectedRow[0].getAttribute("DATA12");
        if (pSelectedRow.length != 0) {
            var p_NextSelRow = pAPRLINE.GetDataRows()[Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) + 1];
            
            if(p_NextSelRow.getAttribute("DATA4").toLowerCase() == pUserID.toLowerCase() && p_NextSelRow.childNodes[0].innerHTML == "1")
            {
                OpenAlertUI(strLang551);    
	            return;
            }
            if(pSelectedRow[0].getAttribute("DATA5") == "N")
            {
	            if(pSelectedRow[0].cells[4].childNodes[0].options[2].selected == true || pSelectedRow[0].cells[4].childNodes[0].options[3].selected == true)
	            {
	                OpenAlertUI(strLang552);    
	                return;
	            }
	            
	            if(p_NextSelRow.getAttribute("DATA5") == "N")
	            {
	                if(p_NextSelRow.cells[4].childNodes[0].options[2].selected == true || p_NextSelRow.cells[4].childNodes[0].options[3].selected == true)
	                {
	                    OpenAlertUI(strLang551);    
	                    return;
	                }
	            }
                
	        }
	        else
	        {
	            if(p_NextSelRow.getAttribute("DATA5") == "N")
	            {
	                if(p_NextSelRow.cells[4].childNodes[0].options[2].selected == true || p_NextSelRow.cells[4].childNodes[0].options[3].selected == true)
	                {
	                    OpenAlertUI(strLang551);    
	                    return;
	                }
	            }
	        }
            if (p_NextSelRow != null) {
                var p_NextAprStat = GetAttribute(p_NextSelRow, "DATA12");
                if ((pSelAprLineState == "003" || p_NextAprStat == "003") && pReDraftFlag == "DRAFT") {
                    var pAlertContent = strLang237;
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else if (pReDraftFlag == "REDRAFT") {
                    if (pSelAprLineState == "002" || pSelAprLineState == "003" || pSelAprLineState == "004") {
                        Ans = ture;
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
                            var pAlertContent = strLang239;
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

            if (CrossYN()) {
                pTotalRows[NIndex].childNodes[0].textContent = pTotalRows[CIndex].cells[0].innerText;
                pTotalRows[CIndex].childNodes[0].textContent = RowDownCheck;
            }
            else {
                pTotalRows[NIndex].cells[0].innerText = pTotalRows[CIndex].cells[0].innerText;
                pTotalRows[CIndex].cells[0].innerText = RowDownCheck;
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
    } catch (e) {
        alert("DoAprLineDown :: " + e.description);
    }
}
//############################################################################################################################################# 결재순번(UP) 1)
function AprlineUpper_onclick() {
    APRLINESNUPPERFunction();
    aprlinecount = 0;
    LineAprTyepSetAll();
}
//############################################################################################################################################# 결재순번(UP) 2)

function APRLINESNUPPERFunction() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");
        var pSelectedRows = pAPRLINE.GetSelectedRows();

        if (pSelectedRows.length != 0) {
            if (pSelectedRows[0].childNodes[0].innerHTML == 1) {
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

                    if (((TmpAprLineState == "002" || TmpAprLineState == "005") && GetAttribute(pSelectedRows[0], "DATA4") == pUserID || pSelectedRows[0].cells[0].innerText == "1"))  //다음결재자가 결재선변경자인경우
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
    } catch (e) {
        alert("APRLINESNUPPERFunction :: " + e.description);
    }
}
function APRLINESNDownFunction() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");

        var pSelectedRow = pAPRLINE.GetSelectedRows();

        if (pSelectedRow.length != 0) {
            var p_NextSelRow = pAPRLINE.GetDataRows()[Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) + 1];
            if (p_NextSelRow != null) {
                var p_NextAprStat = p_NextSelRow.cells[5].innerText;
                p_NextAprStat = ConvertAprLineState(p_NextAprStat, "Code");

                if (p_NextSelRow.cells[4].innerText == "" + strLang20 + "") {
                    var pAlertContent = "" + strLang306 + "";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if ((pSelAprLineType == "003" || p_NextAprStat == "003") && pReDraftFlag == "DRAFT") {
                    var pAlertContent = "" + strLang307 + "";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else if (pReDraftFlag == "REDRAFT") {
                    if (pSelAprLineType == "002" || pSelAprLineType == "003" || pSelAprLineType == "004") {
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
                            var pAlertContent = "" + strLang310 + "";
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
    catch (e) {
        alert("APRLINESNDownFunction :: " + e.description);
    }
}

//############################################################################################################################################# 결재순번(UP) 3)
function UpperAprLineSN(pSelectedRow) {
    try {
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
            if (CrossYN()) {
                pTotalRows[NIndex].childNodes[0].textContent = pTotalRows[CIndex].cells[0].innerText;
                pTotalRows[CIndex].childNodes[0].textContent = RowUpCheck;
            }
            else {
                pTotalRows[NIndex].cells[0].innerText = pTotalRows[CIndex].cells[0].innerText;
                pTotalRows[CIndex].cells[0].innerText = RowUpCheck;
            }
            Rtnval = "Y";
        }

        if (Rtnval == "Y")
            pAPRLINE.RowMoveUp();

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
		dataType : "xml",
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

    var nodes = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");
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
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");		
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
    
	xmlhttp.open("POST","/myoffice/ezApprovalG/ezLine/aspx/Receiver_Chk.aspx", false);
	xmlhttp.send(xmlpara);
			
	if(xmlhttp.responseText == "False") 
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
            if (GetAttribute(totalRow[i], "DATA4") == GetAttribute(pSelectedRow[0], "DATA2")) {
                if (GetAttribute(totalRow[i], "DATA4") == optGamsabu) {
                    if (totalRow[i].cells[4].innerText == strLang51) {
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
function AprLineAddUser(Mode, tr, pSelectedRow) {

    if( pSelectedRow != null)
	{
		var pparsingXML;
		var i
		var chkDuplflag = false;
		
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
				if(GetAttribute(totalRow[i],"DATA4") == GetAttribute(pSelectedRow[0],"DATA2"))
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
		if (chkDuplflag) {
		    var pInformationContent = "" + strLang296 + "<br>" + strLang297 + "";
		    var ans = OpenInformationUI(pInformationContent, AprLineAddUser_Complete);

		    if(!CrossYN() && ans)
		        AprLineAddUser_Complete(true);
		}
		else {
		    AprLineAddUser_Complete(true);
		}
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
            var objTr = pAPRLINE.NewAddRow(0, "lvAPRLINE" + "_TR_" + eval(MaxID + 1));
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
    LineAprTyepSetAll();
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
    pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA2")) + "</DATA4>";
    pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
    pparsingXML = pparsingXML + "<DATA6>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA3")) + "</DATA6>";
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
				    nAprType = "001"
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

    pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA7")) + "</DATA13>";
    pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA8")) + "</DATA14>";
    pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA9")) + "</DATA15>";
    pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA10")) + "</DATA16>";
    pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA11")) + "</DATA17>";
    pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA12")) + "</DATA18>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pSelectedRow[0].cells[0].innerText) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pSelectedRow[0].cells[2].innerText) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pSelectedRow[0].cells[1].innerText) + "</VALUE>";
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
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang230 + "</NAME><WIDTH>30</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang107 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang49 + "</NAME><WIDTH>60</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang108 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang38 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang109 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang231 + "</NAME><WIDTH>80</WIDTH></HEADER>";
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
    if (SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[0], "CODE") == "011") {

        var pUserList = new ListView();
        pUserList.LoadFromID("pUserList");
        var totalRow = pUserList.GetDataRows();

        for (var j = 1; j <= totalRow.length; j++) 
        {
            if (GetAttribute(totalRow[1], "DATA1") == "user" && GetAttribute(totalRow[1], "DATA2") == selnode.GetNodeData("EXTENSIONATTRIBUTE9") && checkDept == false) {
                pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(GetAttribute(totalRow[1], "DATA7")) + "</DATA13>";
                pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(GetAttribute(totalRow[1], "DATA8")) + "</DATA14>";
                pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(GetAttribute(totalRow[1], "DATA9")) + "</DATA15>";
                pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(GetAttribute(totalRow[1], "DATA10")) + "</DATA16>";
                pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(GetAttribute(totalRow[1], "DATA11")) + "</DATA17>";
                pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(GetAttribute(totalRow[1], "DATA12")) + "</DATA18>";
                pparsingXML = pparsingXML + "</CELL><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(totalRow[1], "DATA4")) + "</VALUE>";
                pparsingXML = pparsingXML + "</CELL><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(totalRow[1], "DATA5")) + "</VALUE>";
                pparsingXML = pparsingXML + "</CELL><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(totalRow[1], "DATA6")) + "</VALUE>";
                pparsingXML = pparsingXML + "</CELL><CELL>";
                checkDept = true;
                break;
            }
        }
    }

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
//############################################################################################################################################# 결재선리스트 삭제 이벤트 
function APRLINEATTENDERDELFunction()
{
  try{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    var pSelectedRow = pAPRLINE.GetSelectedRows();
    
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
				if(( TmpAprLineState == "002" || TmpAprLineState == "005" ) && GetAttribute(pSelectedRow[0], "DATA4").toLowerCase() == pUserID.toLowerCase() || pSelectedRow[0].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "") == "1")
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
  }catch(e){
    alert("APRLINEATTENDERDELFunction :: " + e.description);
  }
}
//############################################################################################################################################# 결재선리스트 삭제 이벤트 
function DoDelete(pSelectedRow) {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("lvAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

        var RowDelCheck;
        var Rtnval = "N";
        TIndex = pTotalRows.length;
        NIndex = pSelectedIndex;

        for (i = 0; i <= NIndex; i++) {
            if (CrossYN()) {
                RowDelCheck = pTotalRows[i].cells[0].innerText;
                pTotalRows[i].childNodes[0].textContent = RowDelCheck - 1;
            }
            else {
                RowDelCheck = pTotalRows[i].cells[0].innerText;
                pTotalRows[i].cells[0].innerText = RowDelCheck - 1;
            }

            Rtnval = "Y";
        }

        if (Rtnval == "Y") {
            var selIdx = pAPRLINE.GetSelectedRows()[0].getAttribute("id");
            pAPRLINE.DeleteRow(selIdx);
        }
        aprlinecount = 0;
        LineAprTyepSetAll();
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



function CheckHapYuiCellValue()
{
  try{
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
    if (pHapYuiCount == "0")
    {
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
function APRLINETYPECHANGEFunction(valuecode, valueName)
{   
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
	  
	if(pSelAprLineState != "A04003" && ( pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "HABYUI" ))
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
	
	
    if(!CheckLineUser())
    {
        return;
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
				var pCurSelIndex = CurSelRow[0].cells[0].innerText;
				var pTmpAprLineTypeCode, pTmpAprLineTypeName;
				pTmpAprLineTypeCode = strAprType3;
				pTmpAprLineTypeName = strLangAprType3;
				//rtnvalue = ApplyJunGyulFunction(pCurSelIndex ,pTmpAprLineTypeCode, pTmpAprLineTypeName);
				//if(rtnvalue == "check")
				//{
				//	return;
				//}
			}
            else if(p_AprlineTypeValCode == "004"){
                var pAPRLINE = new ListView();      //// ListView 선언
                pAPRLINE.LoadFromID("lvAPRLINE");
                var pAprLineRow = pAPRLINE.GetDataRows();
                var pAprLineRowLen = pAprLineRow.length;

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

            if(p_IsDept == "Y") 
            { 
                ChangeAprlineType("group"); 
            }else if(p_IsDept == "N"){ 
                ChangeAprlineType("user"); 
            } 
            
            //resetList();
			return flag;
		}

		else if(parseInt(pAprLineRow[i].cells[0].innerText) > parseInt(pCurSelIndex) && GetAttribute(pAprLineRow[i],"DATA11") == strAprType8 || GetAttribute(pAprLineRow[i],"DATA11") == strAprType9)
		{
			flag = "check";
			var pAlertContent = strLang942  + "<br>"+ strLang287;
			OpenAlertUI(pAlertContent);
			
			var pSelectedRow = pAPRLINE.GetSelectedRows();  
            var p_IsDept = GetAttribute(pSelectedRow[0],"DATA5");  
            var pOrderSN =pAPRLINE.GetSelectedIndexes().split(',')[0];
            
            if(p_IsDept == "Y") 
            { 
                ChangeAprlineType("group"); 
            }else if(p_IsDept == "N"){ 
                ChangeAprlineType("user"); 
            } 

            //resetList();
			return flag;
		}
	}
	//앞에 User가 전결일 경우 뒤에 결재자는 결재안함 처리, DropDown비활성
	for(i = 0 ; i < pAprLineRowLen ; i++)
	{
		if(parseInt(pAprLineRow[i].cells[0].innerText) > parseInt(pCurSelIndex))
		{
			if(GetAttribute(pAprLineRow[i],"DATA11") != strAprType8 && GetAttribute(pAprLineRow[i],"DATA11") != strAprType9)
			{
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
		else
		{
			break;
		}
	}
}
//############################################################################################################################################# 전결이 없을경우 DropDown 활성화
function checkdisabled()
{
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
    
    
    if (SelRow[0].getAttribute("DATA5") == "N" && SelRow[0].getAttribute("DATA11") != strAprType16)
    {
        //var selindex = SelRow[0].cells[4].childNodes[0].selectedIndex;
        SelRow[0].cells[4].childNodes[0].options[0].selected = true;
        SetAttribute(SelRow[0], "DATA11", SelRow[0].cells[4].childNodes[0].options[0].value);
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
 		    pAlertContent = pAlertContent + strLang286 + "<br>"
	    }else if(pChkFlag == "another"){
		    pAlertContent = pAlertContent + strLang287 + "<br>"
	    }else if(pChkFlag == "junkyul"){
		    pAlertContent = pAlertContent + strLang288 + "<br>"
	    }
	    
	    var pAprTypeFlag = "001";
	    pCurAprilban = getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);

	    var pAprTypeFlag = "004";
	    pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);

	    var pAprTypeFlag = "003";
	    pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);

	    var pAprTypeFlag = "040";
	    pCurAprilban = pCurAprilban + getAprLineGyulJeLen(AprLineRow , NodeListLen , pAprTypeFlag);

	    if(pCurAprilban > pSignCount)  
	    { 
		    pAlertContent = pAlertContent + strLang276 + pSignCount + strLang277 + "<br>";
	    }
    }
    
    if (pAlertContent != "")
	{
  		var pAlertContent =  pAlertContent + "" + strLang304;
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
    var i;
    var pCurSignFlag = false;
    var pCurHSignFlag = false;
    var pCurGamsaFlag = false;

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
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType9 || GetAttribute(AprLineRow[i], "DATA11") == strAprType8 || GetAttribute(AprLineRow[i], "DATA11") == strAprType11 || GetAttribute(AprLineRow[i], "DATA11") == strAprType12)
            pCurHapyui = pCurHapyui + 1;
    }

    var pAlertContent = "";
    if ((pCurDraft + pCurSign + pCurAprove + pCurDekyul + pCurJunkyul + pCurGamsa) > pSignCount) {
        pAlertContent = pAlertContent + "" + strLang349 + "" + pSignCount + "" + strLang350 + "<br>";
    }

    if (pCurHapyui > pHapYuiCount) {
        pAlertContent = pAlertContent + "" + strLang351 + "" + pHapYuiCount + "" + strLang350 + "<br> ";
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

function chkLastKyuljea(AprLineRow)  
{
	var i, rtnVal;
	var aprtype;
	rtnVal = true;
	
	for(i=0;i < AprLineRow.length - 1; i++)
	{
		aprtype = GetAttribute(AprLineRow[i],"DATA11")
		if(aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strLang264) break;
		if(aprtype == strAprType8 || aprtype == strAprType9 || aprtype == strAprType12 || aprtype == strAprType11)
		{
			rtnVal = false;
			break;
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
		if(aprtype == strLang53 || aprtype == strAprType12 || aprtype == strAprType11)
			H = H + 1;
		if(aprtype == strLang264 || aprtype == strAprType5)
			G = G + 1;
	}
	if (H > 0 && G > 0)
		rtnVal = false;
	return rtnVal; 
}

function chkLastKyuljeaCF(AprLineRow)  
{
	var i, rtnVal;
	var aprtype;
	rtnVal = true;
	for(i=0;i < AprLineRow.length - 1; i++)
	{
		aprtype = GetAttribute(AprLineRow[i],"DATA11");
		if (aprtype == strLang214 || aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strLang264) break;
		if (aprtype = GetAttribute(AprLineRow[1], "DATA11") == strAprType16) break;
		if(aprtype == strAprType2)
		{
			rtnVal = false;
			break;
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
 		
 		if(AprLineRow[i].cells[4].innerText == strLang264)
 		{
 			afterAprflag = true;		
 		}
 		
 		if(afterAprflag)
 		{
 			if(GetAttribute(AprLineRow[i],"DATA11") == strAprType15 || AprLineRow[i].cells[4].innerText == strLang264)	
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
 	    afterAprflag = false;
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType15)
 		{
 			afterAprflag = true;		
 		}
 		
 		if(afterAprflag)
 		{
 		    if (GetAttribute(AprLineRow[i], "DATA11") == strAprType15 || GetAttribute(AprLineRow[i], "DATA11") == strAprType13) afterApr = 0;
 		    else
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
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType12) //AprLineRow.item(i).cells(0).DATA11
 		{
 			afterAprflag = i;
 			break;		
 		}
 	}

 	for(j = AprLineRow.length - 1; j >= 0;j--)
 	{
 		if(GetAttribute(AprLineRow[j],"DATA11") == strAprType12) //AprLineRow.item(j).cells(0).DATA11
 		{
 			afterApr = j;
 		}
 	}

 	if (afterApr != afterAprflag)
 	{
 		for(afterAprflag ; afterAprflag >= afterApr ; afterAprflag--)
 		{
 			if(GetAttribute(AprLineRow[i],"DATA11") != strAprType12) //AprLineRow.item(afterAprflag).cells(0).DATA11
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
 			rtnVal = false;
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
 			var tempUserID = GetAttribute(AprLineRow[i],"DATA4").toLowerCase();
 			for (j = i - 1; j>=0; j--)
 			{
 				
 				if (GetAttribute(AprLineRow[j],"DATA11") == strAprType40 && GetAttribute(AprLineRow[j],"DATA4").toLowerCase() == tempUserID)
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
		
		rtnVal = rtnVal + checkAprLine(pAprType, pClass, pValue, pDesc, AprLineRow, "MUST");
	}
	
	CheckNodes = SelectNodes(WorkFlowXML,"LINESCHECK/MUSTNOT/APRLINE");
	for (i=0; i<CheckNodes.length; i++)
	{
		var pAprType = SelectSingleNodeValue(CheckNodes[i],"APRTYPE") ;
		var pClass = SelectSingleNodeValue(CheckNodes[i],"CLASS") ;
		var pValue = SelectSingleNodeValue(CheckNodes[i],"VALUE") ;
		var pDesc = SelectSingleNodeValue(CheckNodes[i],"DESC") ;
		
		rtnVal = rtnVal + checkAprLine(pAprType, pClass, pValue, pDesc, AprLineRow, "MUSTNOT");
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
//결재선, 수신처에 데이터가 있는지 검사하는 함수
function Checkline() {
    if (!bool) {
        Lineinfo_ini();
    }
    if (!bool2) {
        Receptinfo_ini();
    }
    if (!bool3) {
        Cabinetinfo_ini();
    }
    if (!bool4) { //2013.09.10. 에너지관리공단 lyn : 반송문서 재기안 시 쪽수를 입력하라는 문구 떠서 추가 (Docinfo_ini 만 빠져있었음)
        Docinfo_ini();
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
        if (CurListLen == 0 || (CurListLen == 1 && receptRow[0].id == "lvRECEPTLIST_TR_noItems")) {
            OpenAlertUI(linealt14);
            var tabshow = document.getElementById("1tab2");
            Tab1_MouseClick(tabshow);
            return false;
        }
    }
    
    //else {
    //    document.getElementById("1tab3").onclick();
    //    List.LoadFromID("DivTaskSCateList");
    //    var List = new ListView();
    //}
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