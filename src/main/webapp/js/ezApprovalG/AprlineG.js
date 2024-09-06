﻿// 결재참가자 List에서 선택 결재참가자 결재선에서 삭제
/*
function RowDelete(SelectIndex,ColRow)
{
	var RowDelCheck;
	var ReturnVal = "N";
	TIndex = ColRow.length;                               
	NIndex = SelectIndex;                                   
	    
	for(i = 0 ; i <= NIndex ; i++ ){
		RowDelCheck = ColRow.item(i).cells(0).innerText;       
		ColRow.item(i).cells(0).innerText = RowDelCheck - 1; 
		ReturnVal = "Y";
	}
	return ReturnVal;
}

// 결재참가자 List에서 선택 결재참가자 결재순번 높임
function RowMoveUp(SelectIndex,ColRow)
{
	var RowUpCheck;
	var NIndex = SelectIndex - 1;                                
	var CIndex = SelectIndex;
	var ReturnVal = "N";
	                                                           
	if(NIndex >= 0 ){                                                                
		RowUpCheck = ColRow.item(NIndex).cells(0).innerText;
		ColRow.item(NIndex).cells(0).innerText = ColRow.item(CIndex).cells(0).innerText;      
		ColRow.item(CIndex).cells(0).innerText = RowUpCheck;                                      
		var ReturnVal = "Y";
	}
	return ReturnVal;
}

// 결재참가자 List에서 선택 결재참가자 결재선에서 삭제
function RowDelelte(SelectIndex,ColRow)
{
	var RowDelCheck;
	var ReturnVal = "N";
	TIndex = ColRow.length;                               
	NIndex = SelectIndex;                                   
	    
	for(i = 0 ; i <= NIndex ; i++ )
	{
		RowDelCheck = ColRow.item(i).cells(0).innerText;       
		ColRow.item(i).cells(0).innerText = RowDelCheck - 1; 
		var ReturnVal = "Y";
	}
	return ReturnVal;
}
*/
//  결재순번 지정 Function
function ReSetAprLine(pAPRLINE) {
	var Depth = null;
	var TIndex = null;
	var CIndex = null;
	var NIndex = null;
	var i;
	
	var ColRow = pAPRLINE.GetDataRows(); 
	var SelRow = pAPRLINE.GetSelectedRows();
	TIndex = ColRow.length;
	CIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);
	NIndex = TIndex - CIndex;                 
    
	if(CIndex != 0) {
		for(i = 0 ; i < (CIndex + 2)  ; i++ )
		
		if(i != TIndex)
			ColRow[i].cells[0].innerHTML = TIndex - i;
      
		SelRow[0].cells[0].innerHTML = NIndex;   
		return NIndex                             
	}
}

// 결재선정보가 없을때 최초 기안자 삽입
function setDraftUserFirst() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("pAPRLINE");
    var pTotalRows = pAPRLINE.GetDataRows();
    var pTotalRowsLen = pTotalRows.length;
    var tr = pTotalRows[pTotalRowsLen - 1];
    
    tr.cells[2].innerHTML = arr_userinfo[3];
    tr.cells[3].innerHTML = arr_userinfo[5];
    SetAttribute(tr,"DATA6", arr_userinfo[4]);
   /* pTotalRows.item(pTotalRowsLen - 1).cells(2).innerText = arr_userinfo[3];
    pTotalRows.item(pTotalRowsLen - 1).cells(3).innerText = arr_userinfo[5];
    pTotalRows.item(pTotalRowsLen - 1).cells(0).DATA6 = arr_userinfo[4];*/
}

//전결 여부 검사
function CheckJunGyulState(pOrderSN) {
  try {
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    
    var pTotalRows = pAPRLINE.GetDataRows();
    var pTotalRowsLen = pTotalRows.length;
    
    var i;
	
    for(i = pOrderSN ; i < pTotalRowsLen; i++) {
		// 표준모듈 (2007.05.09) : 다국어
		var pTmpAprLineType = GetAttribute(pTotalRows[i],"DATA11");
		if(pTmpAprLineType == "004") {
			return true;
		}
    }
  } catch(e) {
    alert("CheckJunGyulState :: " + e.description);
  }
}

function GetDocInfo() {
   	pDocID = dialogArguments[0];
	pFormID = dialogArguments[1];
	pSignCount = dialogArguments[2];
	pSignInfo = dialogArguments[3];
	pHapYuiCount = dialogArguments[4];
	pReDraftFlag = dialogArguments[5];
	pSuSinFlag = dialogArguments[6];
	pChamJoFlag = dialogArguments[7];
	pGongramCount = dialogArguments[8];
	pReDraftAprLineFlag = dialogArguments[9];
	pGamSaCount = dialogArguments[11];
	chkReDraft = dialogArguments[13];
	WorkFlowString = dialogArguments[15]; 
	
	try {
	if (WorkFlowString == "" || WorkFlowString == undefined)
		WorkFlowString = "<LINESCHECK><MUST></MUST><MUSTNOT></MUSTNOT></LINESCHECK>";
	} catch(e) {
		WorkFlowString = "<LINESCHECK><MUST></MUST><MUSTNOT></MUSTNOT></LINESCHECK>";
	}
	WorkFlowXML = loadXMLString(WorkFlowString);
	
	if (pReDraftAprLineFlag) pOrgApruserid = dialogArguments[13];
	
	if (dialogArguments.length == 19) {
	    pAprLineArea = dialogArguments[17];
	    pHapyuiArea =  dialogArguments[18];
	}
}

//  보고자 여부 선택 Function
function ReporterCheck(RCheckVal,CurSelRow) {
	if (RCheckVal) {
		SetAttribute(CurSelRow[0],"DATA9","Y");
	} else {
		SetAttribute(CurSelRow[0],"DATA9","N");
	}
}

//  발의자 여부 선택 Function
function SuggesterCheck(SCheckVal,CurSelRow) {
	if (SCheckVal) {
		SetAttribute(CurSelRow[0],"DATA8","Y");
	} else {
		SetAttribute(CurSelRow[0],"DATA8","N");
	}
}

// 버튼 disable 함수
function InitBtn_FunctionAbled() {
	document.getElementById("ReasonNoAprTxt").disabled = true;
	document.getElementById("ReasonNoApr").disabled    = true;
	document.getElementById("AprlineType").disabled    = true;
}

function DoDeleteGamsa(GamsaType, GamsaType2) {
  try { 
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("pAPRLINE");
    
	var pTotalRows = pAPRLINE.GetDataRows();
	for( i=pTotalRows.length-1 ; i>=0 ; i-- ) {
		if( pTotalRows[i].cells[4].innerText == GamsaType || pTotalRows[i].cells[4].innerText == GamsaType2 ) {
		    var selIdx  = pTotalRows[i].getAttribute("id") ;
            pAPRLINE.DeleteRow(selIdx);
			
		}
	}
	/*
	var ttrow = pAPRLINE.GetDataRows();

        for(var j =0  ; j< ttrow.length  ;j++)
        {
            SetAttribute(ttrow[j] ,"id","pAPRLINE" + "_TR_" + j);
        }
        
        pAPRLINE.DataBind("APRLINE");
      */  
	
  } catch(e) {
	alert("DoDelete :: " + e.description);
  }
}

// 결재 참가자 클릭시 실행 함수
function APRLINEATTENDCLICKFunction() {
	var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("pAPRLINE");
    
	var pTotalRows = pAPRLINE.GetSelectedRows();
    
	// 표준모듈 (2007.05.09) : 다국어
	pSelAprLineState = Getattribute(pTotalRows[0],"DATA12");
	
	//선택한 결재자의 결재방법을 가져오는 함수 호출
	CheckAprLineType(pTotalRows);
}

// 선택된 결재자의 결재방법을 나타내주는 함수
//S버젼 중복함수 제거중
//function CheckAprLineType(pCurSel)
//{
//	var pAprLineTypeLen = document.getElementById("AprlineType").length;
//	var i;
//	
//	// 표준모듈 (2007.05.09) : 다국어
//	var TmpAprLineType = Gattribute(pCurSel[0],"DATA11"); //pCurSel.cells(0).DATA11;
//	if(TmpAprLineType == strAprType2)
//	{
//		SetAttribute(pCurSel[0],"DATA12",strAprType1);
//		SetAttribute(pCurSel[0],"innerText",strLangAprType1);
//		//pCurSel.cells(3).innerText = strLangAprType1;
//	}
//	
//	for(i = 0 ; i < pAprLineTypeLen ; i++)
//	{
//		if(AprLineType(i).value == GetAttribute(pCurSel,"DATA11"))
//		{
//			if(!AprLineType(i).disabled)
//			{
//				AprLineType(i).checked = true;
//				break;
//			}
//		}
//	}
//  
//	if(pSelAprLineState == "A04003" && pReDraftFlag == "DRAFT")
//	{
//		for(i = 0 ; i < pAprLineTypeLen ; i++)
//			AprLineType(i).disabled = true;
//	}
//	else if(pSelAprLineState != "A04003" && pReDraftFlag == "DRAFT")
//	{
//		if(pReDraftAprLineFlag)
//		{
//			if(pSelAprLineState == "A04002" && GetAttribute(pCurSel,"DATA4") == pUserID)
//			{  
//				for(i = 0 ; i < pAprLineTypeLen ; i++)
//					AprLineType(i).disabled = true;
//			}else{
//				for(i = 0 ; i < pAprLineTypeLen ; i++)
//					AprLineType(i).disabled = false;
//				CheckDocCellInfoAprLineType();  
//			}
//		}else{                                              
//			for(i = 0 ; i < pAprLineTypeLen ; i++)
//				AprLineType(i).disabled = false;
//			CheckDocCellInfoAprLineType();
//		}
//	}else{
//		for(i = 0 ; i < pAprLineTypeLen ; i++)
//		if(!AprLineType(i).disabled) 
//		 	AprLineType(i).disabled = false;
//	}
//}

// 결재참가자를 추가하는 함수
//S버젼 중복함수 제거중
//function APRLINEATTENDADDFunction(pCurSelectedRow , Mode)
//{
//    var pAPRLINE = new ListView();      //// ListView 선언
//    pAPRLINE.LoadFromID("pAPRLINE");
//    
//	var pCurSelRow = pAPRLINE.GetSelectedRows(); //APRLINE.multiselects;
//	
//	var treeView = new TreeView(); //treeview 선언 
//    treeView.LoadFromID("FromTreeView"); //treeview 로드
//  
//	var selnode = treeView.GetSelectNode();//TreeView.selectedIndex;
//	if(pCurSelectedRow == null)
//	{
//		if(Mode == "PERSON")
//		{
//			var pCurSelectedRow = pCurSelRow[0];
//			if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2"))//TreeView.getvalue(selnode, "EXTENSIONATTRIBUTE2"))
//			{
//				var pAlertContent = strLang250 + "<br> " + strLang251;
//				OpenAlertUI(pAlertContent);	  
//			}
//		}
//		else if(Mode == "DEPT")
//		{
//			var pCurSelectedRow = selnode;//TreeView.selectedIndex;
//			var pAlertContent = strLang250 + "<br> " + strLang251;
//			OpenAlertUI(pAlertContent);	  
//		}
//	}
//    
//    // 표준모듈 (2007.05.09) : 다국어
//    var p_PrevAprStat = "";
//	if(pCurSelRow.length != 0)
//	{
//	    // p_PrevRow = pCurSelRow.prevRow; 가 원본이나 해당기능이 동작하지 않음. 크로스 브라우징 작업중 제외함. 아래와 같이 이전로우 가져올려고 해보았으나 cell 의 17번째값이 없음.
//		var p_PrevRow = null;// pAPRLINE.GetSelectedRows(pAPRLINE.GetSelectedIndexes()-1);//pCurSelRow.prevRow;
//		if( p_PrevRow != null)
//		{
//			p_PrevAprStat = p_PrevRow[0].cells[17].innerText;
//		}
//	}
//	
//	// 승인된 결재참가자 리스트에 결재참가자 추가 제한 하는 부분
//	if(p_PrevAprStat == "A04003" && pReDraftFlag == "DRAFT")
//	{
//		var pAlertContent = strLang250 + "<br> " + strLang251;
//		OpenAlertUI(pAlertContent);
//	}
//	else if(pReDraftFlag == "REDRAFT")
//	{                     
//		if(p_PrevAprStat == "A04003" || p_PrevAprStat == "A04004" || p_PrevAprStat == "A04002" )
//		{
//			AprLineChangeType();
//			AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
//			pReDraftAprLineChangeFlag = true; 
//		}else{
//			AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
//		}	
//	}else{
//		if(pReDraftAprLineFlag)
//		{
//			if(p_PrevRow != null)
//			{ 
//				//if(p_PrevAprStat == "A04002" && p_PrevRow.cells(0).DATA4 == pUserID)
//				if(p_PrevAprStat == "A04002" && GetAttribute(p_PrevRow[0],"DATA4") == pUserID)
//				{
//					var pAlertContent = strLang254;
//					OpenAlertUI(pAlertContent);
//				}else{
//					AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
//				}
//			}else{
//				AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
//			}
//		}else{
//			AprLineAddUser(Mode,pCurSelRow , pCurSelectedRow);
//		}
//	}
//}

// 결재참가자를 추가하는 함수
function APRLINEATTENDSAVEFunction()
{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    
	var Listlen = pAPRLINE.GetDataRows();
	if(Listlen.length == 0)
	{
		var pAlertContent = strLang255;
		OpenAlertUI(pAlertContent);
	}else{
		//결재선 저장 함수 호출
		ReDraftSaveAprLine();
	} 
}
////////////////////////////////////////////////////////////////////////////////////////기록물철 저장 XML2
function GetSelCabInfoXml(totalRows) {
    //var SelCabListview = new ListView();
    //SelCabListview.LoadFromID("DivTaskSCateList");
    //var totalRows = SelCabListview.GetSelectedRows();
    var i;
    var rtnXml = createXmlDom();
    var Root, objItem, objData;
    Root = createNodeInsert(rtnXml, Root, "CABINETINFO");
    
    // 비전자문서 기안시 임시 기록물 정보 입력
    if (nonElecRec == "Y" && pIniGubun == "1") {
    	objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "CABINET");
    	createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETID", g_CabID);
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETNAME", "임시기록물");
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "RECTYPE", "ZZ3782312017000002");
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETSN", "임시SN(a8989891)");
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETVOLNO", "임시VOLNO(ZZ378231)");
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "ZZ378231");
    } else {
	    for (i = 0; i < totalRows.length; i++) {
	        objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "CABINET");
	        createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETID", totalRows[i].getAttribute("DATA1"));
	        createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETNAME", totalRows[i].cells[0].innerText);
	        createNodeAndAppandNodeText(rtnXml, objItem, objData, "RECTYPE", totalRows[i].getAttribute("DATA3"));
	        createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETSN", totalRows[i].cells[1].innerText);
	        createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETVOLNO", totalRows[i].cells[2].innerText);
	        createNodeAndAppandNodeText(rtnXml, objItem, objData, "TASKCODE", totalRows[i].getAttribute("DATA2"));
	        createNodeAndAppandNodeText(rtnXml, objItem, objData, "KEEPPERIOD", totalRows[i].getAttribute("DATA8"));
	    }
    }
    return getXmlString(rtnXml);
}

// 결재참가자 flag 별 Save 함수
function ReDraftSaveAprLine()
{
	if(pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "WHOKYUL")
	{ 
		//결재선 변경함수
		// pReDraftAprLineFlag --> 결재선 변경 Flag  true : 결재선 변경  / false 일반 결재선
		if(!pReDraftAprLineFlag)
		{
			AlterAprLineType();
		}
		//SaveAprLineInfo();
	}
	else if(pReDraftFlag == "REDRAFT")
	{  
		if(!pReDraftAprLineChangeFlag)
		{  
			Ans = true;
			if(Ans)
			{
				//결재 상태 변경 함수 호출(-->진행)
				AprLineChangeType();
				//SaveAprLineInfo();
				pReDraftAprLineChangeFlag = true; 
			}
			else
			{
				AprLineBanSongChangeType();
				//SaveAprLineInfo();
      		}
		}
		else
		{
		    AprLineChangeType();
			//SaveAprLineInfo();
		}
	}
}

// 결재선 변경처리
function AlterAprLineType()
{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    
	var pAprRow = pAPRLINE.GetDataRows(); 
	var pAprRowLen = pAprRow.length;
	var i;
	
	// 표준모듈 (2007.05.09) : 다국어
	var TmpAprLineStateReadyCode, TmpAprLineStateReadyName;
	var TmpAprLineStateJinhangCode, TmpAprLineStateJinhangName;
	
	TmpAprLineStateReadyCode = strAprState1;
	TmpAprLineStateReadyName = strLangAprState1;
	
	TmpAprLineStateJinhangCode = strAprState2;
	TmpAprLineStateJinhangName = strLangAprState2;
	  
	for(i = 0 ; i < pAprRowLen ; i++)
	{
		var TmpAprLineState = GetAttribute(pAprRow[i],"DATA12");
		if(TmpAprLineState != strAprState3)
		{
			SetAttribute(pAprRow[i],"DATA12",TmpAprLineStateReadyCode);
			pAprRow[i].cells[5].innerHTML = TmpAprLineStateReadyName;
		}
		else
		{
			SetAttribute(pAprRow[i-1],"DATA12",TmpAprLineStateJinhangCode);
			pAprRow[i - 1].cells[5].innerHTML = TmpAprLineStateJinhangName;
			break;
		}
	}
}

// 결재선 정보를 저장하는 함수
//function SaveAprLineInfo()
//{
//    SaveAprLineList();
//}

// 결재참가자 리스트를 XML HTTP Protocol를 이용하여 ASP Page 호출하는 함수
function SaveAprLineList()
{
    var Resultxml = APRLINEXMLParsing();
	
	if (Resultxml == "FALSE")
	    return;

	return Resultxml;
	//xmlhttp = createXMLHttpRequest();
	//xmlhttp.open ("Post","aspx/aprlinesave.aspx",false);
	//xmlhttp.send(Resultxml);
	
	//var dataNodes = GetChildNodes(xmlhttp.responseXML); 
    //var ret = getNodeText(dataNodes[0]);
    
    //if(ret == "TRUE")
    //{
    //    APRLINE = pAprLineXml;
	//	//window.returnValue = pAprLineXml;
	//	//window.close();
	//}else{
	//	alert(strLang259);
    //}
    //xmlhttp = null;
}

//  결재참가자 리스트를 XML Data Parsing 하는 Function (결재선)
//S버젼 중복함수 제거중
function APRLINEXMLParsing()
{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    
	var AprLineRow = pAPRLINE.GetDataRows();
	var CurListLen = AprLineRow.length;
	var CurCellLen = AprLineRow[0].cells.length;
	var i;
	var j;
	var k = 0;
	var GetXml;
	var AprLineTotalLen;
	
	// 표준모듈 (2007.05.09) : 다국어
	var pAprTypeFlag = "A03001";
	
	// 기안자 추가 여부 체크 함수
	pDraftUser = CheckDraftUser(pAprTypeFlag);
	if(!pDraftUser && !pReDraftAprLineFlag)
	{
		var pAlertContent = strLang260;
		OpenAlertUI(pAlertContent);
		return "FALSE";
	}
	
	// 기안자 정보가 없는 경우
	if(!pDraftUser && !pReDraftAprLineFlag)
	{
		AprLineTotalLen = CurListLen + 1;
	}else{
		AprLineTotalLen = CurListLen;
	}
 
	GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang331 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang29 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang32 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang61 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang125 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang332 + "</NAME><WIDTH>120</WIDTH></HEADER><HEADER><NAME>" + strLang333 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>";
	GetXml = GetXml + "<ROWS>";
  
	var addWhokyul = chkWhokyulAddChk();
	if(addWhokyul)
	{
		AprLineTotalLen = AprLineTotalLen + 1
	}
 
	for( i = 0 ; i < CurListLen ; i++)
	{
		//사후공람 추가 
		// 표준모듈 (2007.05.09) : 다국어
		if(i== 0 && GetAttribute(AprLineRow[i],"DATA11") != strAprType15)
		{
			if(addWhokyul)
			{
				//검사부 부서를 추가 한다.
				DraftXml = addGamsabu(AprLineTotalLen - k,strAprType15,false,strAprState1);
				GetXml = GetXml + DraftXml;
				k = k + 1;
			}
		}
		GetXml = GetXml + "<ROW>";
		//GetXml = GetXml + "<COLUMN>" + (AprLineTotalLen - k) + "</COLUMN>";
		//for( j = 1 ; j < CurCellLen - 1 ; j++)
		//    GetXml = GetXml + "<COLUMN>" + MakeXMLString(AprLineRow[i].cells[j].innerText) + "</COLUMN>";
		for (j = 0; j < CurCellLen - 1; j++)
		    if (AprLineRow[i].cells[j].childNodes[0].nodeName == "SELECT") {
		        var pAprTypeObjId = AprLineRow[i].getAttribute("id") + "select";
		        var pAprTypeCode_, pAprTypeName_;
		        var pAprSelectindex = document.getElementById(pAprTypeObjId).selectedIndex;

		        if (pAprSelectindex < 0)
		            return;

		        pAprTypeCode_ = document.getElementById(pAprTypeObjId)[pAprSelectindex].getAttribute("value");
		        pAprTypeName_ = document.getElementById(pAprTypeObjId)[pAprSelectindex].getAttribute("value2");
		        GetXml = GetXml + "<COLUMN>" + MakeXMLString(pAprTypeName_) + "</COLUMN>";
		    }
		    else {
		        var rep1 = /⊙/g;
		        var rep2 = /★/g;
		        if (CrossYN())
		            GetXml = GetXml + "<COLUMN>" + MakeXMLString(AprLineRow[i].cells[j].textContent.replace(rep1, "").replace(rep2, "")) + "</COLUMN>";
		        else
		            GetXml = GetXml + "<COLUMN>" + MakeXMLString(AprLineRow[i].cells[j].innerText.replace(rep1, "").replace(rep2, "")) + "</COLUMN>";
		    }

           
		switch(pReDraftFlag)
		{
			case "REDRAFT":
				if ($(AprLineRow[i]).attr("DATA12") == "002" || ($(AprLineRow[i]).attr("DATA12") == "003") && $("input:checkbox[id='passAprLine']").is(":checked")) {
					GetXml = GetXml + "<DATA name='ProcessDate'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA1")) + "</DATA>";
					GetXml = GetXml + "<DATA name='ReceivedDate'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA2")) + "</DATA>";
				} else {
					GetXml = GetXml + "<DATA name='ProcessDate'></DATA>";
					GetXml = GetXml + "<DATA name='ReceivedDate'></DATA>";
				}
       			break;
			
			default :
				
				if(chkReDraft == "REDRAFT")
				{
					GetXml = GetXml + "<DATA name='ProcessDate'></DATA>";
					GetXml = GetXml + "<DATA name='ReceivedDate'></DATA>";
				}
				else
				{				
					GetXml = GetXml + "<DATA name='ProcessDate'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA1")) + "</DATA>";
					GetXml = GetXml + "<DATA name='ReceivedDate'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA2")) + "</DATA>";
				}
       			break;
		}

		if(trim_Cross(GetAttribute(AprLineRow[i],"DATA3")) != "")
		{
			GetXml = GetXml + "<DATA name='DocID'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA3")) + "</DATA>";
		}else{
			GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
		}
		GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA4")) + "</DATA>";
		GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA5")) + "</DATA>";
		GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA6")) + "</DATA>";
		GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA7")) + "</DATA>";
		if (pReDraftFlag != "HAPYUI" && pReDraftFlag != "HABYUI") {
		    GetXml = GetXml + "<DATA name='isProposerYN'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA8")) + "</DATA>";
		    GetXml = GetXml + "<DATA name='isBriefUserYN'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA9")) + "</DATA>";
		}
		else {
		    GetXml = GetXml + "<DATA name='isProposerYN'>N</DATA>";
		    GetXml = GetXml + "<DATA name='isBriefUserYN'>N</DATA>";
		}
		GetXml = GetXml + "<DATA name='isCompanyID'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA10")) + "</DATA>";
		
		// 표준모듈 (2007.05.09) : 다국어
		GetXml = GetXml + "<DATA name='AprType'>" + GetAttribute(AprLineRow[i],"DATA11") + "</DATA>";
		GetXml = GetXml + "<DATA name='AprState'>" + GetAttribute(AprLineRow[i],"DATA12") + "</DATA>";
		
		// 수정(2007.06.18) : multidata 기능추가 
		GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA13")) + "</DATA>";		//primary usernm
		GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA14")) + "</DATA>";		//secondary usernm
		GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA15")) + "</DATA>";		//primary deptname
		GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA16")) + "</DATA>";	//secondary deptname
		GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA17")) + "</DATA>";	//primary title
		GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(GetAttribute(AprLineRow[i],"DATA18")) + "</DATA>";	//secondary title
		
		GetXml = GetXml + "</ROW>";
	    
		k = k + 1;
	}
  
	//기안자 정보를 Insert
	if(!pDraftUser && !pReDraftAprLineFlag)
	{
		var DraftXml;
		
		// 표준모듈 (2007.05.09) : 다국어
		DraftXml = AddDraftUser("1",strAprType1,true,strAprState2);
		
		GetXml = GetXml + DraftXml;
	}
	GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
	pAprLineXml[0] = GetXml;
	
	//기안자 정보를 진행으로 Setting
	if(pDraftUser && !pReDraftAprLineFlag)
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
			    // 표준모듈(2007.05.28) : 다국어-TimeZone 처리
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
			    // 표준모듈(2007.05.28) : 다국어-TimeZone 처리
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

// 결재안함 사유 체크
function chknoApproval()
{
	var chkFlag = false;
	
	var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("pAPRLINE");
    
    var Row = APRLINE.GetSelectedRows();
    var totalRow = APRLINE.GetDataRows();
	if(Row)
	{
		// 표준모듈 (2007.05.09) : 다국어
		if(Row[0].cells[4].innerText == strAprType3)
		{
			if(trim(document.getElementById("ReasonNoAprTxt").value) != "")
				SetAttribute(Row[0],"DATA7",document.getElementById("ReasonNoAprTxt").value);
		}
	}

	var i;
	for(i=0;i<totalRow.length;i++)
	{
		// 표준모듈 (2007.05.09) : 다국어
		if(totalRow[i].cells[4].innerText == strAprType3 && trim_Cross(GetAttribute(totalRow[i],"DATA7")) == "")
		{
			var pAlertContent = totalRow[i].cells[1].innerText + strLang263;
			OpenAlertUI(pAlertContent);
			chkFlag = true;
		}
	}
	return chkFlag;
}

// 사후공람 유무 확인
function chkWhokyulAddChk()
{
	if(pGamSaCount == 0) return false;
	
	var pAPRLINE = new ListView();      //// ListView 선언
	pAPRLINE.LoadFromID("lvAPRLINE");
    
	var listRows = pAPRLINE.GetDataRows();
	var listLength = listRows.length;
	var sunkyulFlag = false;
	var isChifFlag = false;
	var whokyulFlag = false;
	
	var i;
	for(i=0;i<listLength;i++)
	{
		// 표준모듈 (2007.05.09) : 다국어
	    if (GetAttribute(listRows[i], "DATA11") == strAprType18 && !whokyulFlag) whokyulFlag = true;
		
	    var tempkyultext = "";
	    if (CrossYN())
	        tempkyultext = listRows[i].cells[4].childNodes[0][listRows[i].cells[4].childNodes[0].selectedIndex].textContent;
	    else
	        tempkyultext = listRows[i].cells[4].childNodes[0][listRows[i].cells[4].childNodes[0].selectedIndex].innerText;

	    if (tempkyultext == strLang288 && !sunkyulFlag) sunkyulFlag = true;
		if(!isChifFlag)
		{
			if(GetAttribute(listRows[i],"DATA5") == "Y") continue;	
		}
	}
	
	//사전감사이 없고, 본부장이 있으면..사후공람추가
	if(!sunkyulFlag && isChifFlag && !whokyulFlag) return true;
	else return false;
}

// 결재선 목록 저장 xml Parsing 함수
// [2006.07.06] 특수문자 처리
//S버젼 중복된 함수 제거중
//function APRLINETEMPLETXMLParsing()
//{
//    var pAPRLINE = new ListView();    
//    pAPRLINE.LoadFromID("pAPRLINE");
//   
//	var AprLineRow = pAPRLINE.GetDataRows();//APRLINE.rows;
//	var CurListLen = AprLineRow.length;
//	var CurCellLen = AprLineRow[0].cells.length;//AprLineRow.item(0).cells.length;
//	
//	var i;
//	var j;
//	var k = 0;
//	var GetXml;
//	var AprLineTotalLen;
//	GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang106 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang107 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang108 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang38 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang109 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang110 + "</NAME><WIDTH>120</WIDTH></HEADER><HEADER><NAME>" + strLang111 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>";
//	GetXml = GetXml + "<ROWS>";
//	   
//	for( i = 0 ; i < CurListLen ; i++)
//	{
//	    var tr = AprLineRow[i];
//	    GetXml = GetXml + "<ROW>";
//		for( j = 0 ; j < CurCellLen - 1 ; j++)
//			GetXml = GetXml + "<COLUMN>" + MakeXMLString(tr.cells[j].innerText) + "</COLUMN>"; //AprLineRow.item(i).cells(j).innerText
//	    
//		GetXml = GetXml + "<DATA name='ProcessDate'>" + GetAttribute(tr,"DATA1") + "</DATA>"; //AprLineRow.item(i).cells(0).DATA1
//		GetXml = GetXml + "<DATA name='ReceivedDate'>" + GetAttribute(tr,"DATA2")  + "</DATA>"; //AprLineRow.item(i).cells(0).DATA2
//		if( trim_Cross(GetAttribute(tr,"DATA3"))  != "")  //AprLineRow.item(i).cells(0).DATA3
//		{
//			GetXml = GetXml + "<DATA name='DocID'>" + GetAttribute(tr,"DATA3") + "</DATA>"; //AprLineRow.item(i).cells(0).DATA3 
//		}else{
//			GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
//		}	
//		GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(GetAttribute(tr,"DATA4")) + "</DATA>"; //AprLineRow.item(i).cells(0).DATA4
//		GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + GetAttribute(tr,"DATA5") + "</DATA>"; // AprLineRow.item(i).cells(0).DATA5
//		GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(GetAttribute(tr,"DATA6")) + "</DATA>"; //AprLineRow.item(i).cells(0).DATA6
//		GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + MakeXMLString(GetAttribute(tr,"DATA7")) + "</DATA>"; //AprLineRow.item(i).cells(0).DATA7
//		GetXml = GetXml + "<DATA name='isProposerYN'>" + GetAttribute(tr,"DATA8") + "</DATA>"; //AprLineRow.item(i).cells(0).DATA8
//		GetXml = GetXml + "<DATA name='isBriefUserYN'>" + GetAttribute(tr,"DATA9") + "</DATA>"; //AprLineRow.item(i).cells(0).DATA9
//		
//		// 표준모듈 (2007.05.09) : 다국어
//		GetXml = GetXml + "<DATA name='isCompanyID'>" + GetAttribute(tr,"DATA10") + "</DATA>"; //AprLineRow.item(i).cells(0).DATA10
//		GetXml = GetXml + "<DATA name='AprType'>" + GetAttribute(tr,"DATA11") + "</DATA>"; //AprLineRow.item(i).cells(0).DATA11
//		
//		// 20091109 : 결재선 저장 부분 수정
//		//GetXml = GetXml + "<DATA name='AprState'>" + AprLineRow.item(i).cells(0).DATA12 + "</DATA>";
//		GetXml = GetXml + "<DATA name='AprState'>A04001</DATA>";
//		
//		// 수정(2007.06.18) : multidata 기능추가 
//		GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(GetAttribute(tr,"DATA13")) + "</DATA>";		//primary usernm AprLineRow.item(i).cells(0).DATA13
//		GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(GetAttribute(tr,"DATA14")) + "</DATA>";		//secondary usernm AprLineRow.item(i).cells(0).DATA14
//		GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(GetAttribute(tr,"DATA15")) + "</DATA>";		//primary deptname AprLineRow.item(i).cells(0).DATA15
//		GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(GetAttribute(tr,"DATA16")) + "</DATA>";	//secondary deptname AprLineRow.item(i).cells(0).DATA16
//		GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(GetAttribute(tr,"DATA17")) + "</DATA>";	//primary title AprLineRow.item(i).cells(0).DATA17
//		GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(GetAttribute(tr,"DATA18")) + "</DATA>";	//secondary title AprLineRow.item(i).cells(0).DATA18
//		
//		GetXml = GetXml + "</ROW>";
//	}
//	GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
//	
//	return GetXml;  
//}

//  기안자 정보를 삽입하는 함수
// [2006.07.06] 특수문자 처리
function AddDraftUser(pSN,pAprType,pDraftDayFlag,pAprState)
{
	var GetXml;
	//기안날짜 가져오는 함수
	var pDraftDay = "";
	if(pDraftDayFlag)
	    // 표준모듈(2007.05.28) : 다국어-TimeZone 처리
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
	// 수정(2007.06.18) : multidata 기능추가 
	GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(arr_userinfo[11]) + "</DATA>";		//primary usernm
	GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(arr_userinfo[12]) + "</DATA>";		//secondary usernm
	GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(arr_userinfo[15]) + "</DATA>";	//primary deptname
	GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(arr_userinfo[16]) + "</DATA>";	//secondary deptname
	GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(arr_userinfo[13]) + "</DATA>";	//primary title
	GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(arr_userinfo[14]) + "</DATA>";	//secondary title

	GetXml = GetXml + "</ROW>";
	return GetXml;
}

// 결재선정보가 없을때 최초 기안자 삽입
// [2006.07.06] 특수문자 처리
//function AddDraftUserFirst()
//{
//	var pparsingXML;
//	pparsingXML = "<LISTVIEWDATA><HEADERS>";
//	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang230 + "</NAME><WIDTH>30</WIDTH></HEADER>";
//	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang107 + "</NAME><WIDTH>50</WIDTH></HEADER>";
//	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang49 + "</NAME><WIDTH>60</WIDTH></HEADER>";
//	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang108 + "</NAME><WIDTH>80</WIDTH></HEADER>";
//	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang38 + "</NAME><WIDTH>80</WIDTH></HEADER>";
//	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang109 + "</NAME><WIDTH>80</WIDTH></HEADER>";
//	pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang231 + "</NAME><WIDTH>80</WIDTH></HEADER>";
//	pparsingXML = pparsingXML + "</HEADERS><ROWS>";
//	pparsingXML = pparsingXML + "<ROW><CELL>";
//	pparsingXML = pparsingXML + "<VALUE>" + "1"+ "</VALUE>";
//	pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
//	pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
//	pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
//	pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(arr_userinfo[1]) + "</DATA4>";
//	pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
//	pparsingXML = pparsingXML + "<DATA6>" + MakeXMLString(arr_userinfo[4]) + "</DATA6>";
//	pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
//	pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
//	pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
//	pparsingXML = pparsingXML + "<DATA10>" + MakeXMLString(companyID) + "</DATA10>";
//	pparsingXML = pparsingXML + "<DATA11>" + strAprType1 + "</DATA11>";
//	pparsingXML = pparsingXML + "<DATA12>" + strAprState1 + "</DATA12>";
//	pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(arr_userinfo[11]) + "</DATA13>";		//primary usernm
//	pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(arr_userinfo[12]) + "</DATA14>";		//secondary usernm
//	pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(arr_userinfo[15]) + "</DATA15>";		//primary deptname
//	pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(arr_userinfo[16]) + "</DATA16>";		//secondary deptname
//	pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(arr_userinfo[13]) + "</DATA17>";		//primary title
//	pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(arr_userinfo[14]) + "</DATA18>";		//secondary title
//	pparsingXML = pparsingXML + "</CELL><CELL>";
//	pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[2]) + "</VALUE>";
//	pparsingXML = pparsingXML + "</CELL><CELL>";
//	pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[3]) + "</VALUE>";
//	pparsingXML = pparsingXML + "</CELL><CELL>";
//	pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[5]) + "</VALUE>";
//	pparsingXML = pparsingXML + "</CELL><CELL>";
//	pparsingXML = pparsingXML + "<VALUE>" + strLangAprType1 + "</VALUE>";
//	pparsingXML = pparsingXML + "</CELL><CELL>";
//	pparsingXML = pparsingXML + "<VALUE>" + strLangAprState1 + "</VALUE>";
//	pparsingXML = pparsingXML + "</CELL><CELL></CELL></ROW></ROWS></LISTVIEWDATA>"; //새로운 ie 에서 CELL 이 부족하여 빈셀 추가.
//	return pparsingXML;
//}

//감사부서를 사후공람로 추가 한다.
function addGamsabu(pSN,pAprType,pDraftDayFlag,pAprState)
{	
	var GetXml;
	//기안날짜 가져오는 함수
	var pDraftDay = "";
	if(pDraftDayFlag)
	    // 표준모듈(2007.05.28) : 다국어-TimeZone 처리
		pDraftDay = getGyulJeDateDB();
		
	var GamsabuName = getDeptInfo_nodName(optGamsabu,"DisplayName");
	GetXml = "<ROW>";
	GetXml = GetXml + "<COLUMN>" + pSN + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(GamsabuName) + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(GamsabuName) + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + MakeXMLString(GamsabuName) + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + pAprType + "</COLUMN>";
	GetXml = GetXml + "<COLUMN>" + pAprState + "</COLUMN>";
	GetXml = GetXml + "<DATA name='ProcessDate'>" + "" + "</DATA>";
	GetXml = GetXml + "<DATA name='ReceivedDate'>" + pDraftDay + "</DATA>";
	GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
	GetXml = GetXml + "<DATA name='AprMemberID'>" + optGamsabu + "</DATA>";
	GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + "Y" + "</DATA>";
	GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + optGamsabu + "</DATA>";
	GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + "" + "</DATA>";
	GetXml = GetXml + "<DATA name='isProposerYN'>" + "N" + "</DATA>";
	GetXml = GetXml + "<DATA name='isBriefUserYN'>" + "N" + "</DATA>";
	GetXml = GetXml + "</ROW>";
	return GetXml;	
}

//사인칸 셀 정보 체크 함수  , pAprTypeFlag : 값으로 주는  , Flag체크 값 전역변수화 , 변수에 값넣지 말기
function CheckSignCellValue()
{
	return true;
}
/** 
 *  결재정보를 최종으로 확인.
 *  모든 경우에 따른 Validation 확인.
 */ 
function CheckSignCellValueLast() {
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;

    if (CurListLen <= 0) {
        OpenAlertUI("" + strLang335 + "<br>" + strLang336 + "");
        return false;
    }

    var pCurDraft = 0;			//기안 결재참가자수
    var pCurSign = 0;			//검토 결재참가자수
    var pCurAprove = 0;         //결재 결재참가자수
    var pCurJunkyul = 0;        //전결 결재참가자수
    var pCurDekyul = 0;         //대결 결재참가자수
    var pCurHapyui = 0;			//협조 결재참가자수
    // 수정(2005.08.25) : 사전감사 기능 추가
    var pCurGamsa = 0;			//사전감사 결재참가자수
    // 2018-10-15 배현상, 대결 다음 결재자가 확인이 오는 오류 수정
    var pCurWhoakin = 0;
    
    var i;
    var pCurSignFlag = false;	//결재, 전결, 대결 뒤에 검토가 오는지 확인.
    var pCurHSignFlag = false;	//결재, 전결, 대결 뒤에 협조가 오는지 확인.
    // 수정(2005.08.25) : 사전감사 기능 추가
    var pCurGamsaFlag = false;	//결재, 전결, 대결 뒤에 사전감사가 오는지 확인.
    // 2018-10-15 배현상, 대결 다음 결재자가 확인이 오는 오류 수정
    var pCurWhoakinFlag = false;

    //var pFirstAprType = AprLineRow.item(CurListLen - 1).cells(4).innerText;
    //var pFirstAprType = AprLineRow.item(CurListLen - 1).cells(0).DATA11;
    var pFirstAprType = GetAttribute(AprLineRow[CurListLen - 1], "DATA11");
    for (i = 0 ; i < CurListLen ; i++) {
        // 2010.08.1 다국어
        //if(AprLineRow.item(i).cells(0).DATA11 == strAprType18)
        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType18)
            pCurDraft = pCurDraft + 1;
            //		else if(AprLineRow.item(i).cells(0).DATA11 == strAprType19)
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType19)
            pCurSign = pCurSign + 1;
            // 수정(2005.08.25) : 사전감사 참가자수 체크
            //		else if(AprLineRow.item(i).cells(0).DATA11 == strAprType13)
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType13)
            pCurGamsa = pCurGamsa + 1;
            //		else if(AprLineRow.item(i).cells(0).DATA11 == strAprType1)
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType1) {
            pCurAprove = pCurAprove + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            // 수정(2005.08.25) : 사전감사가 결재 뒤에 오는지 체크
            if (pCurGamsa > 0)
                pCurGamsaFlag = true;
        }
            //		else if(AprLineRow.item(i).cells(0).DATA11 == strAprType16)
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType16) {
            pCurDekyul = pCurDekyul + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            // 수정(2005.08.25) : 사전감사가 대결 뒤에 오는지 체크
            if (pCurGamsa > 0)
                pCurGamsaFlag = true;
            if (pCurWhoakin > 0) {
            	//2018-10-12 배현상, 최종결재자 직전에 결재자가 대결인 경우 최종결재자의 결재유형이 확인이 올 수 있는 경우 제거
            	pCurWhoakinFlag = true;
            }
        }
            //else if(AprLineRow.item(i).cells(0).DATA11 == strAprType4)
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType4) {
            pCurJunkyul = pCurJunkyul + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            // 수정(2005.08.25) : 사전감사가 전결 뒤에 오는지 체크
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
    // 수정(2005.08.25) : 사전감사 참가자수도 결재칸수 체크에 포함시킴
    if ((pCurDraft + pCurSign + pCurAprove + pCurDekyul + pCurJunkyul + pCurGamsa) > pSignCount) {
    	if (draftAllFlag != undefined && draftAllFlag == "Y") { // 일괄기안의 경우, "N안의 사인칸 수" 정보를 표출
        	pAlertContent = pAlertContent + opener.lowerSignTab + strLangHSBRDa09 + "" + strLang349 + "" + pSignCount + "" + strLang350 + "<br>";
        } else {
        	pAlertContent = pAlertContent + "" + strLang349 + "" + pSignCount + "" + strLang350 + "<br>";
        }
    }
    
    // 2023-04-20 이가은 - 일괄접수 시 양식마다 다른 결재칸 수로 인해 가장 작은 결재칸 수로 제한시킴
    if (opener.pCurSelRowSend != undefined) {
    	if ((opener.pCurSelRowSend).length >= 2) {
    		if ((pCurDraft + pCurSign + pCurAprove + pCurDekyul + pCurJunkyul + pCurGamsa) > opener.minSignCountInfo[0]) {
    			pAlertContent = pAlertContent + "'" + opener.opener.minSignCountInfo[1] + "' " + strLangCSJ01 +  strLang349 + opener.minSignCountInfo[0] + strLang350;
    		}
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

    // 수정(2005.08.25) : 사전감사 참가자수가 1명인지 체크
    if (pCurGamsa > 1) {
        pAlertContent = pAlertContent + "" + strLang355 + "<br> ";
    }

    if (pCurAprove == 0 && pCurDekyul == 0 && pCurJunkyul == 0) {
        pAlertContent = pAlertContent + "" + strLang356 + "<br> ";
    }

    if (pCurDekyul > 0 && pCurJunkyul > 0)		// 전결 + 대결인데 순서 찾기.
    {
        //if(AprLineRow.item(0).cells(4).innerText == "" + strLang7 + "")
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

    // 수정(2005.08.25) : 사전감사가 결재권자 앞에 있는지 체크
    if (pCurGamsaFlag) {
        pAlertContent = pAlertContent + "" + strLang361 + "<br> ";
    }
    
    if (pCurWhoakinFlag) {
    	pAlertContent = pAlertContent + "" + strLangBae2 + "<br> ";
    }
    
    if (pFirstAprType != strAprType18 && pFirstAprType != strAprType1 && pFirstAprType != strAprType4 && pFirstAprType != strAprType16)
        pAlertContent = pAlertContent + "" + strLang362 + "" + ConvertAprLineType(pFirstAprType, "Value") + "" + strLang363 + "<br> ";


    // 수정(2006.06.12) : 기안자가 겸직인 경우 결재선 기안부서 체크하도록 수정
    var pChkFlag = CheckDraftDeptID(AprLineRow);
    if (!pChkFlag)
        pAlertContent = pAlertContent + " " + strLang364 + "<br>";

    if (pAlertContent != "") {
        pAlertContent = pAlertContent + "" + strLang336 + "";
        OpenAlertUI(pAlertContent);
        return false;
    }

    //검토자 수 체크로직 주석처리.(닷넷 동일) 문서유통 접수 시 사인카운트 오류 관련. 2019-12-03 홍대표.
//    if (pCurSign >= 3) {
//        var pInformationContent = "" + strLang365 + " " + strLang366 + "";
//        var rtnval = confirm(pInformationContent);
//        CheckSignCellValueLast_Complete(rtnval);
//        return rtnval;
//    }
//    else {
//        CheckSignCellValueLast_Complete(true);
//        return true;
//    }
    
    CheckSignCellValueLast_Complete(true);
    return true;
}

function CheckSignCellValueLast_Complete(Ans) {
    DivPopUpHidden();
    if (Ans) {
        APRLINEATTENDSAVEFunction();
    }
}

// [zzesti] 2006.06.02 : 기안자가 겸직인 경우 결재선 기안부서 체크하도록 수정
function CheckDraftDeptID( AprLineRow )
{
	// 표준모듈 (2007.05.09) : 다국어
	if(GetAttribute(AprLineRow[AprLineRow.length - 1],"DATA6") != arr_userinfo[4]
		&& (GetAttribute(AprLineRow[AprLineRow.length - 1],"DATA12") == strAprState2 || GetAttribute(AprLineRow[AprLineRow.length - 1],"DATA12") == strAprState1) )
		return false;
	
	return true;
}

// 같은 사람이 동시에 후결일 수 없다.
function ChkWhoKyulDuplicate(AprLineRow)
{
 	var i, j, k;
 	var rtnVal = true;
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 		// 표준모듈 (2007.05.09) : 다국어
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType40) //AprLineRow.item(i).cells(0).DATA11
 		{
 			var tempUserID = GetAttribute(AprLineRow[i],"DATA4").toLowerCase();//AprLineRow.item(i).cells(0).DATA4.toLowerCase();
 			for (j = i - 1; j>=0; j--)
 			{
 				//if (AprLineRow.item(j).cells(0).DATA11 == strAprType40 && AprLineRow.item(j).cells(0).DATA4.toLowerCase() == tempUserID)
 				if (GetAttribute(AprLineRow[j],"DATA11") == strAprType40 && GetAttribute(AprLineRow[j],"DATA4").toLowerCase() == tempUserID)
 					rtnVal = false;
 			}
 		}
 	}
	return rtnVal;
}

// 기안자와 최종결재자는 후결일 수 없다.
function ChkWhoKyulLast(AprLineRow)
{
	// 표준모듈 (2007.05.09) : 다국어
	//if (AprLineRow.item(AprLineRow.length - 1).cells(0).DATA11 == strAprType40)
	if (GetAttribute(AprLineRow[AprLineRow.length - 1],"DATA11") == strAprType40)
	
		return false;
		
//	if (AprLineRow.item(0).cells(0).DATA11 == strAprType40)
//		return false;

    // 20090622 : 결재선 끝에 참조가 올 경우 그앞의 결재 체크
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

//합의정보
function CheckHapYuiCellValue() {
  try {
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("pAPRLINE");
    
    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;
    var CurAprLen = 0;
    var pCurAprDeptLen = 0;
    
    // 표준모듈 (2007.05.09) : 다국어
    var pAprTypeFlag = strAprType8;
    CurAprLen = getAprLineGyulJeLen(AprLineRow , CurListLen , pAprTypeFlag);
	
    pAprTypeFlag = strAprType12;
    pCurAprDeptLen = getAprLineGyulJeLen(AprLineRow , CurListLen , pAprTypeFlag);
    
    if (pGamSaCount > 0)
    {
		return true;
    }
    if(CurAprLen >= pHapYuiCount)
    {
		var pAlertContent = strLangS305 + "<br>  " + strLangS306;
		OpenAlertUI(pAlertContent);
		return false;
    }
    else if (SelectNodes(AprTypeXML,"APRTYPES/DEPTTYPES").length <= 0 || pHapYuiCount == "0")
    {
		var pAlertContent = strLangS307 + "<br>  " + strLangS306;
		OpenAlertUI(pAlertContent);
		return false;
    }
    return true;
  }catch(e){
    alert("CheckHapYuiCellValue :: " + e.description);
  }
}

//  결재참가자의 수를 가져오는 함수 
function getAprLineGyulJeLen(AprLineRow , CurListLen , pAprTypeFlag)
{
   	pTotalIndex = 0;
	var i;
	for(i = 0 ; i < CurListLen ; i++)
	{
		// 표준모듈 (2007.05.09) : 다국어
		//if(AprLineRow.item(i).cells(0).DATA11 == pAprTypeFlag)
		if(GetAttribute(AprLineRow[i],"DATA11") == pAprTypeFlag)
			pTotalIndex = pTotalIndex + 1;
	}
	return pTotalIndex;
}

//합의중간에 확인 또는 합의 없는 확인 제거
function chkWakin(AprLineRow)
{
	var startHapyui;
	var cnt_Wakin ;
	var i;
	var rowLength = AprLineRow.length - 1;
	var rtnVal;
	cnt_Wakin = 0;
	startHapyui = false;
	rtnVal = true;
	
	for(i=rowLength;i>=0;i--)
	{
		// 표준모듈 (2007.05.09) : 다국어
		/*if(AprLineRow.item(i).cells(4).innerText == "합의")
		{
			if(!startHapyui) startHapyui = true;
			else
			{
				if(cnt_Wakin > 0)
				{
					rtnVal = false;
					break;
				}
			}
		}*/
		
		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType2)
		{
			if(!startHapyui)
			{
				rtnVal = false;
				break;
			}
			else
				cnt_Wakin = cnt_Wakin + 1;
		}
	}
	return rtnVal;
}

//전결자 이후 결재상태 check
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
 		// 표준모듈 (2007.05.09) : 다국어
 		if( GetAttribute(AprLineRow[i],"DATA11") == strAprType4) //AprLineRow.item(i).cells(0).DATA11
 		{
 			afterAprflag = true;		
 		}
 		if(afterAprflag)
 		{
 			if(GetAttribute(AprLineRow[i],"DATA11") == strAprType3) //AprLineRow.item(i).cells(0).DATA11
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
 			if(GetAttribute(AprLineRow[i],"DATA11") == strAprType3) //AprLineRow.item(i).cells(0).DATA11
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

//감사(사전감사) 검사
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
 		//if(AprLineRow.item(i).cells(4).innerText == strLang264)
 		if(AprLineRow[i].cells[4].innerText == strLang264)
 		{
 			afterAprflag = true;		
 		}
 		
 		if(afterAprflag)
 		{
 			// 표준모듈 (2007.05.09) : 다국어
 			//if(AprLineRow.item(i).cells(0).DATA11 == strAprType15 || AprLineRow.item(i).cells(4).innerText == strLang264)	afterApr = 0;
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


function chkDrafterTongje(AprLineRow)
{
	// 기안자는 통제자가 될 수 없다.
	// 표준모듈 (2007.05.09) : 다국어
 	if (GetAttribute(AprLineRow[AprLineRow.length-1],"DATA11") == strAprType31) //AprLineRow.item(AprLineRow.length - 1).cells(0).DATA11
 		return false;
 	else
 		return true;
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
 			// 표준모듈 (2007.05.09) : 다국어
 			if(GetAttribute(AprLineRow[i],"DATA11")  == strAprType31) //AprLineRow.item(i).cells(0).DATA11
 			{
 				rtnVal = false;
 			}
 		}
 	}
	return rtnVal;
}

function chkSusinUser(AprLineRow)
{
 	var i, j, k;
 	var rtnVal = true;
 	
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 		// 표준모듈 (2007.05.09) : 다국어
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType14) //AprLineRow.item(i).cells(0).DATA11
 		{ 
 			rtnVal = false;
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
 	
 	// 표준모듈 (2007.05.09) : 다국어
 	for(i = AprLineRow.length - 1; i >= 0;i--)
 	{
 	    // 20091120 : 부서순차합의부서 사이에 결재자 추가
 		//if(AprLineRow.item(i).cells(0).DATA11 == strAprType12 || AprLineRow.item(i).cells(0).DATA11 == strAprType11)
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType12) //AprLineRow.item(i).cells(0).DATA11
 		{
 			afterAprflag = i;
 			break;		
 		}
 	}

 	for(j = AprLineRow.length - 1; j >= 0;j--)
 	{
 	    // 20091120 : 부서순차합의부서 사이에 결재자 추가
 		//if(AprLineRow.item(j).cells(0).DATA11 == strAprType12 || AprLineRow.item(j).cells(0).DATA11 == strAprType11)
 		if(GetAttribute(AprLineRow[j],"DATA11") == strAprType12) //AprLineRow.item(j).cells(0).DATA11
 		{
 			afterApr = j;
 		}
 	}

 	if (afterApr != afterAprflag)
 	{
 		for(afterAprflag ; afterAprflag >= afterApr ; afterAprflag--)
 		{
 		    // 20091120 : 부서순차합의부서 사이에 결재자 추가
 			//if(AprLineRow.item(afterAprflag).cells(0).DATA11 != strAprType11 && AprLineRow.item(afterAprflag).cells(0).DATA11 != strAprType12)
 			if(GetAttribute(AprLineRow[i],"DATA11") != strAprType12) //AprLineRow.item(afterAprflag).cells(0).DATA11
 			{
 				rtnVal = false;
 				break;		
 			}
 		}
 	}
	return rtnVal;
}

//감사(사후감사) 검사
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
 		// 표준모듈 (2007.05.09) : 다국어
 		if(GetAttribute(AprLineRow[i],"DATA11") == strAprType15) //AprLineRow.item(i).cells(0).DATA11
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

//최종결재자  검사
//S버젼 중복된 함수 제거중
//function chkLastKyuljea(AprLineRow)  
//{
//	var i, rtnVal;
//	var aprtype;
//	rtnVal = true;
//	
//	for(i=0;i < AprLineRow.length - 1; i++)
//	{
//		// 표준모듈 (2007.05.09) : 다국어
//		aprtype = GetAttribute(AprLineRow[i],"DATA11") //AprLineRow.item(i).cells(0).DATA11;
//		if(aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strLang264) break;
//		if(aprtype == strAprType8 || aprtype == strAprType9 || aprtype == strAprType12 || aprtype == strAprType11)
//		{
//			rtnVal = false;
//			break;
//		}
//	}
//	return rtnVal;
//}

//function chkHabyuiGamsa(AprLineRow)  
//{
//	var i, rtnVal;
//	var aprtype, H, G;
//	H = 0;
//	G = 0;
//	rtnVal = true;
//	
//	for(i=0;i < AprLineRow.length - 1; i++)
//	{
//		// 표준모듈 (2007.05.09) : 다국어
//		aprtype = GetAttribute(AprLineRow[i],"DATA11") //AprLineRow.item(i).cells(0).DATA11;
//		if(aprtype == strLang53 || aprtype == strAprType12 || aprtype == strAprType11)
//			H = H + 1;
//		if(aprtype == strLang264 || aprtype == strAprType5)
//			G = G + 1;
//	}
//	if (H > 0 && G > 0)
//		rtnVal = false;
//	return rtnVal; 
//}

function chkLastKyuljeaCF(AprLineRow)  
{
	var i, rtnVal;
	var aprtype;
	rtnVal = true;
	
	for(i=0;i < AprLineRow.length - 1; i++)
	{
		// 표준모듈 (2007.05.09) : 다국어
		aprtype = GetAttribute(AprLineRow[i],"DATA11") ;//AprLineRow.item(i).cells(0).DATA11;
		if(aprtype == strLang214 || aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strLang264) break;
		if(aprtype == strAprType2)
		{
			rtnVal = false;
			break;
		}
	}
	return rtnVal;
}

// 기안자 정보 체크
function CheckDraftUser(pFlag)
{
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("lvAPRLINE");
    
	var NodeList = pAPRLINE.GetDataRows();
	var NodeListLen = NodeList.length;
	var i;
	if(NodeListLen != 0)
	{
		//if(NodeList.item(NodeListLen - 1).cells(0).DATA4.toLowerCase() == pUserID.toLowerCase())
		//2009.03.17 : 결재선 지정시 기안자의 결재형태를 결재가 아닌 다른 것(개인순차합의...)등으로 설정후 확인 클릭시 별다른 내용없이 바로 결재선이 셋팅됨.
		//20100401 : 아래조건 주석처리하고 조건변경 (마지막 조건 변경) pFlag(A03001->A03007)
		//if(NodeList.item(NodeListLen - 1).cells(0).DATA4.toLowerCase() == pUserID.toLowerCase() && NodeList.item(NodeListLen - 1).cells(0).DATA11 == pFlag )
		if(GetAttribute(NodeList[NodeListLen - 1],"DATA4").toLowerCase() == pUserID.toLowerCase() && GetAttribute(NodeList[NodeListLen - 1],"DATA11") != "A03007" )
		{
			return true;
		}else{
			return false;
		}
	}
}

// 서버의 결재시간 가지고 오는 부분
function getGyulJeDate()
{
    var GyulJeDate;
	
	xmlhttp.open("POST","/ezApprovalG/getDate.do",false);
	xmlhttp.send();
	GyulJeDate = xmlhttp.responseText;
	
	return GyulJeDate;
}

//결재상태변경
function AprLineChangeType()
{
//  try{
    var i;
    var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("pAPRLINE");
    
	var pTotalRows = pAPRLINE.GetDataRows();
    var pTotalRowsLen = pTotalRows.length;
    
    // 표준모듈 (2007.05.09) : 다국어
    var pTmpAprLineState = strAprState1;
    var pTmpAprLineStateName = strLangAprState1;
    
    for(i = 0 ; i < pTotalRowsLen - 1 ; i++)
    {
		SetAttribute(pTotalRows[i],"DATA12",pTmpAprLineState);
		pTotalRows[i].cells[5].innerHTML =pTmpAprLineStateName;//pTotalRows.item(i).cells(5).innerText = ;
    }
	
	pTmpAprLineState = strAprState2;
    pTmpAprLineStateName = strLangAprState2;
    SetAttribute(pTotalRows[i],"DATA12", pTmpAprLineState);//pTotalRows.item(i).cells(0).DATA12 = pTmpAprLineState;
    pTotalRows[i].cells[5].innerHTML = pTmpAprLineStateName;//pTotalRows.item(i).cells(5).innerText = pTmpAprLineStateName;
//  }catch(e){
//    alert("AprLineChangeType :: " + e.description);
//  }
}

// 결재선 결재상태를 반송 --> 진행  재기안 경우
function AprLineBanSongChangeType()
{
	var i;
	
	var pAPRLINE = new ListView(); 
	pAPRLINE.LoadFromID("pAPRLINE");
        
	var pSelRow = pAPRLINE.GetDataRows();
	var pSelRowLen = pSelRow.length;
	
	// 표준모듈 (2007.05.09) : 다국어
	var pBansongAprLineState = strAprState4;
	var pJinHangAprLineState = strAprState2;
	var pJinHangAprLineStateName = strLangAprState2;
	var pSungInAprLineState = strAprState3;
	var pSungInAprLineStateName = strLangAprState3;
	  
	for(i = 0 ; i < pSelRowLen ; i++)
	{
		if(GetAttribute(pSelRow[i],"DATA12") == pBansongAprLineSate)
		{
			SetAttribute(pSelRow[i],"DATA12",pJinHangAprLineSate); 
			pSelRow[i].cells[5].innerHTML = pJinHangAprLineSateName;
			break;
		}
	}
	SetAttribute(pSelRow[pSelRowLen - 1],"DATA12",pSungInAprLineSate); 
	pSelRow[pSelRowLen - 1].cells[5].innerHTML = pSungInAprLineSateName;
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
    }
	return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}

var confirmInfo;
function OpenConfirmUI(pInformationContent, confirmFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/confirmPopup.do";
    confirmInfo = new Array();
    
    if (CrossYN()) {
    	confirmInfo[0] = parameter;     
    	confirmInfo[1] = OpenConfirmUI_Complete;
    	confirmInfo[2] = confirmFunction;
        DivPopUpShow(330, 205, url);
    } else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
	return RtnVal;
}

function OpenConfirmUI_Complete(confirmFlag) {
    DivPopUpHidden();
    
    if(confirmFlag) {
    	var confirmFunction = confirmInfo[2];
    	confirmFunction();
    }
}

var ezapralert_cross_dialogArguments = new Array();
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

function OpenAlertUI_Close() {
	try {
		DivPopUpHidden();
		window.close();
		opener.frames["left"].getAprCount();
		opener.getDocList();
	} catch(e) {}
}

//function APRLINETYPECHANGEFunction()
//{
//	// 표준모듈 (2007.05.09) : 다국어
//	var p_AprLineValueCode, p_AprLineValueName;
//	var CurSelRow;
//	var p_CurAprlineStat;
//	  
//	document.getElementById("ReasonNoAprTxt").disabled = true;                             
//	document.getElementById("ReasonNoApr").disabled = true;                               
//	
//	var pAPRLINE = new ListView(); 
//	pAPRLINE.LoadFromID("pAPRLINE");
//    
//	CurSelRow        = pAPRLINE.GetSelectedRows();
//	
//	if(CurSelRow.length == 0)
//	    return false;
//	    
//	p_CurAprlineStat = GetAttribute(CurSelRow[0],"DATA12");
//	
//	p_AprLineValueName = document.getElementById("AprlineType")[document.getElementById("AprlineType").selectedIndex].text;
//	p_AprLineValueCode = document.getElementById("AprlineType")[document.getElementById("AprlineType").selectedIndex].value;
//	 
//	if(document.getElementById("ReasonNoAprTxt").value != "")
//		document.getElementById("ReasonNoAprTxt").value = "";
//	  
//	if(pSelAprLineState != "A04003" && ( pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "HABYUI" ))
//	{
//		if(pReDraftAprLineFlag)
//		{
//				AprLineTypeCheck(p_AprLineValueName,p_AprLineValueCode,CurSelRow);
//		}else{
//			AprLineTypeCheck(p_AprLineValueName,p_AprLineValueCode,CurSelRow);
//		}
//	}
//	else if(pReDraftFlag == "REDRAFT")
//	{
//		if(pSelAprLineState == "A04003" || pSelAprLineState == "A04004" || CurSelRow[0].cells[0].innerText == "1")
//		{
//			Ans = true;
//			if(Ans)
//			{
//				AprLineTypeCheck(p_AprLineValueName,p_AprLineValueCode,CurSelRow);
//				pReDraftAprLineChangeFlag = true; 
//			}
//		}else{
//			AprLineTypeCheck(p_AprLineValueName,p_AprLineValueCode,CurSelRow);
//		}
//	}
//}

function trim(parm_str)
{
	if(parm_str == "")
		return ""
	else
		return rtrim(ltrim(parm_str));
}

function ltrim(parm_str)
{
	var str_temp = parm_str ;
	while (str_temp.length != 0) 
	{
		if (str_temp.substring(0, 1) == " ")
			str_temp = str_temp.substring(1, str_temp.length);
		else
			return str_temp ;
	}
	return str_temp;
}

function rtrim(parm_str)
{
	var str_temp = parm_str ;
	while (str_temp.length != 0)
	{
		int_last_blnk_pos = str_temp.lastIndexOf(" ");
		
		if ((str_temp.length - 1) == int_last_blnk_pos)
			str_temp = str_temp.substring(0, str_temp.length - 1);
		else
			return str_temp;
	}
	return str_temp;
}

function RefreshSN()
{
  try{
    
    var pAPRLINE = new ListView(); 
	pAPRLINE.LoadFromID("pAPRLINE");
	
	var pTotalRows = APRLINE.GetDataRows();
	var idx = 1;

	for( i=pTotalRows.length ; i>=0 ; i-- )
	{
		pTotalRows[i].cells[0].innerHTML = idx;
		idx = idx + 1;
	}
  }
  catch(e)
  {
	alert("RefreshSN :: " + e.description);
  }
}

function getDeptInfo_nodName(pDeptID,NodeName)
{
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getADInfos.do",
		data : {
			cn : pDeptID,
			prop : NodeName,
			cate  : "group"
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
	var dataNodes = GetChildNodes(loadXMLString(result));
	var Rtnval = getNodeText(dataNodes[0]);
				
	return Rtnval;
}

var g_progresswin = null;
function showProgress() {
	g_progresswin = modelessWindow("/ezApprovalG/showProgress.do?fileInfo=" + encodeURI(strLang313) , "", 390, 185, g_progresswin);
    //while (g_progresswin.document.readyState != "complete") { }// 2011.02.16 IE9 지원안함.
	


}
function hideProgress() {
  try {
	if (g_progresswin)
		g_progresswin.close();
  } catch(e) {}
}

function RemoveWorkFlowUser(pAprType, pClass, pValue, AprLineRow)
{
	// 우선 조건을 만족하는 모두를 지우고, 
	var m=0;
 	for(m = AprLineRow.length - 1; m >= 0;m--)
 	{
 		var cAprType = AprLineRow[m].cells[4].innerText;
 		var cUserID = GetAttribute(AprLineRow[m],"DATA4");
 		var cJobTitle = AprLineRow[m].cells[2].innerText;
 		
 		if (cAprType == pAprType)
 		{
 		     var pAPRLINE = new ListView(); 
	         pAPRLINE.LoadFromID("pAPRLINE");
	         
			switch (pClass)
			{//위 함수를 호출하는 메인이 pAPRLINE 이므로 선택된 pAPRLINE 을 지우도록 한다.
			     
	                    
				case "JOBTITLE" :
					if (cJobTitle == pValue)
					{   
					    var selIdx  = AprLineRow[m].getAttribute("id") ;
                        pAPRLINE.DeleteRow(selIdx);
            
						//AprLineRow.item(m).Remove();
					}
					break;
				
				case "USERID" :
					if (cUserID == pValue)
					{
					    var selIdx  = AprLineRow[m].getAttribute("id") ;
                        pAPRLINE.DeleteRow(selIdx);
						//AprLineRow.item(m).Remove();
					}
					break;
					
				default :
				    var selIdx  = AprLineRow[m].getAttribute("id") ;
                    pAPRLINE.DeleteRow(selIdx);
                    //AprLineRow.item(m).Remove();
					break;
			} 	
			/*
            var ttrow = pAPRLINE.GetDataRows();

            for(var j =0  ; j< ttrow.length  ;j++)
            {
                SetAttribute(ttrow[j] ,"id","pAPRLINE" + "_TR_" + j);
            }
            
            pAPRLINE.DataBind("APRLINE");
            */		
 		} 		
 	}
	
	// 순번을 다시 부여하여준다.
 	for(m = AprLineRow.length - 1; m >= 0;m--)
 	{
 		AprLineRow[m].cells[0].innerHTML = AprLineRow.length - m;
	}	
}

//S버젼 중복된 함수 제거중
//function CheckWorkFlowXML(AprLineRow)
//{
//	var CheckNodes = SelectNodes(WorkFlowXML,"LINESCHECK/MUST/APRLINE");//WorkFlowXML.selectNodes("LINESCHECK/MUST/APRLINE");
//	var i=0;
//	var rtnVal = "";
//	for (i=0; i<CheckNodes.length; i++)
//	{
//	    var pAprType = SelectSingleNodeValue(CheckNodes[i],"APRTYPE") ;
//		var pClass = SelectSingleNodeValue(CheckNodes[i],"CLASS") ;
//		var pValue = SelectSingleNodeValue(CheckNodes[i],"VALUE") ;
//		var pDesc = SelectSingleNodeValue(CheckNodes[i],"DESC") ;
//		
//		rtnVal = rtnVal + checkAprLine(pAprType, pClass, pValue, pDesc, AprLineRow, "MUST");
//	}
//	
//	CheckNodes = SelectNodes(WorkFlowXML,"LINESCHECK/MUSTNOT/APRLINE");//WorkFlowXML.selectNodes("LINESCHECK/MUSTNOT/APRLINE");
//	for (i=0; i<CheckNodes.length; i++)
//	{
//		var pAprType = SelectSingleNodeValue(CheckNodes[i],"APRTYPE") ;
//		var pClass = SelectSingleNodeValue(CheckNodes[i],"CLASS") ;
//		var pValue = SelectSingleNodeValue(CheckNodes[i],"VALUE") ;
//		var pDesc = SelectSingleNodeValue(CheckNodes[i],"DESC") ;
//		
//		rtnVal = rtnVal + checkAprLine(pAprType, pClass, pValue, pDesc, AprLineRow, "MUSTNOT");
//	}
//	return rtnVal;
//}

// OptionFlag : MUST - 있어야함. else - 없어야함.
// 리턴값은 pDesc
function checkAprLine(pAprType, pClass, pValue, pDesc, AprLineRow, OptionFlag)
{
	var m;
	var checkFlag = false;
	
 	for(m = AprLineRow.length - 1; m >= 0;m--)
 	{ 
 		var cAprType = AprLineRow[m].cells[4].innerText; //AprLineRow.item(m).cells(4).innerText;
 		var cUserID = GetAttribute(AprLineRow[m],"DATA4");//AprLineRow.item(m).cells(0).DATA4;
 		var cJobTitle = AprLineRow[m].cells[2].innerText;//AprLineRow.item(m).cells(2).innerText;
 		
 		if (cAprType == pAprType)
 		{
			switch (pClass)
			{
				case "JOBTITLE" :
					if (cJobTitle.toLowerCase() == pValue.toLowerCase())
						checkFlag = true;
					break;
				
				case "USERID" :
					if (cUserID.toLowerCase() == pValue.toLowerCase())
						checkFlag = true;
					break;
					
				default :
					checkFlag = true;
					break;
			} 			
 		}
 	}
 	
 	if (OptionFlag == "MUST")
 	{
 		if (checkFlag)
 			return "";
 		else
 			return pDesc + "<br>";
 	}
 	else
 	{
 		if (!checkFlag)
 			return "";
 		else
 			return pDesc + "<br>";
 	}
}


// 프로세스 디자이너
function CheckProcessXML(AprLineRow)
{
    var MustCheck = "";
    var rtnVal = "";
    // 기안자가 반드시 디자인된 프로세스데로 결재선을 지정해야 하는지 여부
    
    var node = GetElementsByTagName(ProcessorXML, "ISMUST");
	if(node.length != 0 )
       MustCheck = getNodeText(node[0]);                
    
    // 결재선 지정 기능
    if(MustCheck == "True" || MustCheck == "")
    {
        var CheckNodes = SelectNodes(ProcessorXML, "PROCESSORLINE/MUST/APRLINE");      
	    var i=0;
	    
	    for (i=0; i<CheckNodes.length; i++)
	    {
	        var pOrder = SelectSingleNodeValue(CheckNodes[i], "ORDER");
		    var pAprType = SelectSingleNodeValue(CCheckNodes[i], "APRTYPE");
		    var pClass = SelectSingleNodeValue(CCheckNodes[i], "CLASS");
		    var pValue = SelectSingleNodeValue(CCheckNodes[i], "VALUE");
		    var pDesc = SelectSingleNodeValue(CCheckNodes[i], "DESC");
		    rtnVal = rtnVal + chkAprProcess(pOrder, pAprType, pClass, pValue, pDesc, AprLineRow, "MUST");
	    }
    	 
	    // 프로세스에 디자인된 결재자 수 보다 많은지 검사
	    
	    var pAPRLINE = new ListView();      //// ListView 선언
        pAPRLINE.LoadFromID("pAPRLINE"); 
    
	    var aprCount = 0
	    var rows = pAPRLINE.GetDataRows();
	 
	    for(m = rows.length- 1; m >= 0;m--)
        { 
           
            var cAprType =GetAttribute(rows[m],"DATA11");
    	  		 		
	        if(cAprType == strAprType7 || cAprType == strAprType2)  
	            continue;
    	    
	        aprCount++;
 	    }
     	
 	    if(CheckNodes.length > 0 && CheckNodes.length < aprCount)
 	        rtnVal = rtnVal + " "+strLang1128;
     		
    }
	return rtnVal;
}
// OptionFlag : MUST - 있어야함. else - 없어야함.
// 리턴값은 pDesc
function chkAprLine(pAprType, pClass, pValue, pDesc, AprLineRow, OptionFlag)
{
	var m;
	var checkFlag = false;
	
	var pAPRLINE = new ListView();      //// ListView 선언
    pAPRLINE.LoadFromID("pAPRLINE"); 
    
	var rows = pAPRLINE.GetDataRows();
	
 	for(m = rows.length - 1; m >= 0;m--)
 	{
 		var cAprType = rows[m].cells[4] .innerText;
 		var cUserID = GetAttribute(rows[m], "DATA4");
 		var cJobTitle = rows[m].cells[2] .innerText;
 		
 		if (cAprType == pAprType)
 		{
			switch (pClass)
			{
				case "JOBTITLE" :
					if (cJobTitle.toLowerCase() == pValue.toLowerCase())
						checkFlag = true;
					break;
				
				case "USERID" :
					if (cUserID.toLowerCase() == pValue.toLowerCase())
						checkFlag = true;
					break;
					
				default :
					checkFlag = true;
					break;
			} 			
 		}
 	}
 	
 	if (OptionFlag == "MUST")
 	{
 		if (checkFlag)
 			return "";
 		else
 			return pDesc + "<br>";
 	}
 	else
 	{
 		if (!checkFlag)
 			return "";
 		else
 			return pDesc + "<br>";
 	}
}

// 프로세스 디자이너
// 리턴값은 pDesc
function chkAprProcess(pOrder, pAprType, pClass, pValue, pDesc, AprLineRow, OptionFlag)
{
	var m;
	var checkFlag = false;
	var eCount = 0;
    	
    if(pOrder <= AprLineRow.length)
    {
 	    for(m = AprLineRow.length - 1; m >= 0;m--)
 	    {  		   
 		    var cAprType = GetAttribute( AprLineRow[m], "DATA11");
 		    var cUserID = GetAttribute(AprLineRow[m], "DATA4");
 		    var cJobTitle = AprLineRow[m].cells[2].innerText;
     		 		
 		    // 확인, 참조는 검사하지 않음
 		    if(cAprType == strAprType7 || cAprType == strAprType2)
 		    {
 		        eCount++;
 		        continue;
            }
            
            // 검사하지 않는 결재 유형을 순차에서 뺌
            var cOrder = AprLineRow[m].cells[0].innerText - eCount;
            
            // 프로세스의 순차와 결재선 순차를 대조(ex.두번째==첫번째,두번째==두번째...)
            if(pOrder == cOrder && pAprType == cAprType)
            {
                switch (pClass)
		        {
			        case "JOBTITLE" :
				        if (cJobTitle.toLowerCase() == pValue.toLowerCase())
					        checkFlag = true;
				        break;
    				
			        case "USERID" :
				        if (cUserID.toLowerCase() == pValue.toLowerCase())
					        checkFlag = true;
				        break;
    					
			        default :
				        checkFlag = true;
				        break;
		        } 	
            }
 	    }
    }
    else
    {
        if(pAprType == "")
            checkFlag = true;
    } 	
 	
 	// 대조 결과 일치하면 빈값을, 불일치 시 오류 메세지를 리턴
 	if (OptionFlag == "MUST")
 	{
 		if (checkFlag)
 			return "";
 		else
 			return pDesc + "<br>";
 	}
 	else
 	{
 		if (!checkFlag)
 			return "";
 		else
 			return pDesc + "<br>";
 	}
}

// 프로세스 디자이너<디자인 된 순차의 결재타입을 기본으로 넣어줌>
//S버젼 중복함수 제거중
//function GetProcessAprType(AprLineAddIndex,AprLineRow,pClass)
//{
//    var retVal = "";          
//    
//    var pAPRLINE = new ListView();      //// ListView 선언
//    pAPRLINE.LoadFromID("pAPRLINE"); 
//    
//    var tr = pAPRLINE.GetSelectedRows();
//	
//	
//    if (InsertMode == "Edit" &&   tr.length > 0 ) {
//        retVal = GetAttribute(tr[0], "DATA11");
//    }
//    
//    if(retVal == "A03011" || retVal == "A03012")
//    {
//        if(pClass != "DEPT")
//        {
//            retVal = "";
//        }
//    }
//    else
//    {
//         if(pClass == "DEPT")
//        {
//            retVal = "";
//        }
//    }
//        
//    return retVal;
//}

// 프로세스 디자이너에서 가져온 A03 타입이 개인,부서에 맞는 타입인지 체크
//S버젼 중복함수 제거중
//function chekAprTypeClass(cheVal,pClass)
//{
//    var retVal = false;
//    
//    if(pClass == "PERSON")
//    {
//        if(cheVal == "A03001" || cheVal == "A03002" || cheVal == "A03003" || cheVal == "A03004" || cheVal == "A03005" || cheVal == "A03006" || cheVal == "A03007" || cheVal == "A03008" || cheVal == "A03009")
//            retVal = true;
//    }
//    else
//    {
//        if(cheVal == "A03010" || cheVal == "A03011" || cheVal == "A03012")
//            retVal = true;
//    }
//    return retVal;
//}

// 프로세스 디자이너 : 결재 타입을 이름으로 반환해줌
//S버젼 중복함수 제거중
//function AprTypeToName(tempCode)
//{
//    var retVal = "";
//    			
//	switch(tempCode)
//	{
//		case "A03001":
//			retVal = strLangAprType1;
//			break;
//
//		case "A03002":
//			retVal = strLangAprType2;
//			break;
//
//		case "A03003":
//			retVal = strLangAprType3;
//			break;
//
//		case "A03004":
//			retVal = strLangAprType4;
//			break;
//
//        case "A03005":
//			retVal = strLangAprType5;
//			break;
//			
//        case "A03006":
//			retVal = strLangAprType6;
//			break;
//			
//		case "A03007":
//			retVal = strLangAprType7;
//			break;
//
//		case "A03008":
//			retVal = strLangAprType8;
//			break;
//
//		case "A03009":
//			retVal = strLangAprType9;
//			break;
//			
//        case "A03011":
//			retVal = strLangAprType11;
//			break;
//		
//		case "A03012":
//			retVal = strLangAprType12;
//			break;
//		
//		case "A03013":
//			retVal = strLangAprType13;
//			break;
//			
//		case "A03014":
//			retVal = strLangAprType14;
//			break;
//						
//		case "A03015":
//			retVal = strLangAprType15;
//			break;	
//		
//		case "A03016":
//			retVal = strLangAprType16;
//			break;
//		
//		case "A03017":
//			retVal = strLangAprType17;
//			break;
//					
//		case "A03031":
//			retVal = strLangAprType31;
//			break;
//			
//		case "A03040":
//			retVal = strLangAprType40;
//			break;	
//		
//		default :
//			retVal = "";
//			break;
//	}
//	return retVal;
//}

//############################################################################################################ 수신처 XML
function AprDeptListXML() {
    var AprDeptListxml;
    var i = 0;
    var pAprNDeptNumber;
    var pAprDeptFlag;
    var AprDeptPara = createXmlDom();
    var AprDeptInfo = createXmlDom();

    pAprNDeptNumber = 1;
    pAprDeptFlag = "NDept";
//    AprDeptPara = AprDeptParameter(pAprNDeptNumber, pAprDeptFlag);
    AprDeptListxml = APRDeptXMLParsing(RECEPTLIST, pDocID);

    var AprDeptInfo = AprDeptListxml;

//    if (CrossYN()) {
//        var xmlRtn = AprDeptPara.documentElement;
//        var Node = AprDeptInfo.importNode(xmlRtn, true);
//        AprDeptInfo.documentElement.appendChild(Node);
//    }
//    else {
//        var xmlRtn = AprDeptPara.documentElement;
//        AprDeptInfo.documentElement.appendChild(xmlRtn);
//    }
    
    return AprDeptInfo;
}
function AprDeptParameter(pAprNDeptNumber, pAprDeptFlag) {
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "APRDEPT");
    createNodeAndInsertText(xmlpara, objNode, "pAprNDeptNumber", pAprNDeptNumber);
    createNodeAndInsertText(xmlpara, objNode, "pAprDeptFlag", pAprDeptFlag);

    return xmlpara;
}
function APRDeptXMLParsing(APRDEPT, pDocID) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");

    var AprDeptRow = listview.GetDataRows();
    var CurListLen = AprDeptRow.length;
    var CurCellLen = 0;
    if (CurListLen > 0)
        CurCellLen = AprDeptRow[0].cells.length;

    var i;
    var j;
    var GetXml;

    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang236 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang237 + "</NAME><WIDTH>600</WIDTH></HEADER></HEADERS>";
    GetXml += "<ROWS>";

    for (i = 0 ; i < CurListLen ; i++) {
        GetXml += "<ROW>";
        for (j = 0 ; j < CurCellLen - 1; j++) {
        	GetXml += "<COLUMN>" + MakeXMLString(getNodeText(AprDeptRow[i].cells[j])) + "</COLUMN>";
        }

        if (trim_Cross(GetAttribute(AprDeptRow[i], "DATA2")) == "") {
            GetXml += "<DATA name='DocID'>" + pDocID + "</DATA>";
        }
        else {
            GetXml += "<DATA name='DocID'>" + GetAttribute(AprDeptRow[i], "DATA2") + "</DATA>";
        }
        GetXml += "<DATA name='ReceiptPointID'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA1")) + "</DATA>";
        GetXml += "<DATA name='ExtReceptYN'>" + GetAttribute(AprDeptRow[i], "DATA3") + "</DATA >";
        GetXml += "<DATA name='ProcessYN'>" + GetAttribute(AprDeptRow[i], "DATA4") + "</DATA>";
        GetXml += "<DATA name='CanEditYN'>" + GetAttribute(AprDeptRow[i], "DATA5") + "</DATA>";
        GetXml += "<DATA name='ExtReceptEmail'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA6")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberID'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA7")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberName'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA8")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberJobTitle'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA9")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberName'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA10")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberName2'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA11")) + "</DATA>";
        GetXml += "<DATA name='JobTitle2'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA12")) + "</DATA>";
        GetXml += "<DATA name='JobTitle'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA13")) + "</DATA>";

        GetXml += "</ROW>";
    }
    
    GetXml += "</ROWS>";
    GetXml += "<APRDEPT>";
    GetXml += "<pAprNDeptNumber>1</pAprNDeptNumber>";
    GetXml += "<pAprDeptFlag>NDept</pAprDeptFlag>";
    GetXml += "</APRDEPT>";
    
    GetXml += "</LISTVIEWDATA>";
    
    return GetXml;
}