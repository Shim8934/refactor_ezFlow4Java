
var lastKyulName, lastKyuljiwee, LastSignSN;
var DraftLastFlag = false;

var g_progresswin = null;	
function showProgress(inforstring) {
	g_progresswin = window.showModelessDialog("/ezApprovalG/showProgress.do?fileInfo=" + encodeURI(inforstring) , "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
	while (g_progresswin.document.readyState != "complete") {}
}

function hideProgress() {
  try {
	if (g_progresswin)
		g_progresswin.close();
  } catch(e) {}
}
function GetDraftAprLineInfo(ret) {
  try {
    DraftLastFlag = false;
    
	var xmlKuljea;
	var chamjo;
	var hapyuiCnt;
	var SignCnt;
	var referCnt;
	var xmlReDraft;
	
	var objNodes;
	var FormProc;
	var fields;
	var findstring;
	var count;
	var i;
	var name;
	
	var OrderType = new Array();        
	var OrderDept = new Array();        
	var OrderName = new Array();        
	var OrderStat = new Array();         
	var OrderJobtitle = new Array();    
	var OrderReason = new Array();      
	
	var xmldom = createXmlDom();

	if (ret[5] == undefined) {
	    xmlKuljea = ret[0];
	    xmlReDraft = ret[2];
	}
	else {
	    xmlKuljea = ret[1];
	    xmlReDraft = ret[5];
	}

	setAprLinesXML(xmlKuljea);
	
	xmlReDraft = "R";
	if(xmlReDraft == "C")
	{
		ApplyDocCellInfo();
	}else if(xmlReDraft == "R"){
		ClearDocCellInfo();
	}

	xmldom = loadXMLString(xmlKuljea);
	
	objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
	count = objNodes.length;

	 
	for(i=1;i<200;i++)
	{
		name = "habyuisign" + i;
		if (message.FieldExist(name))
		{
	  		name = "habyui" + i;
	  		if (message.FieldExist(name))
	  			message.PutFieldText(name, "");
	  		
	  		name = "habyuisign" + i;
	  		if (message.FieldExist(name))
	  			message.PutFieldText(name, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
	  		
	  		name = "habyuipositon" + i;
	  		if (message.FieldExist(name))
	  			message.PutFieldText(name, "");
	  		
	  		
	  		name = "habyuidate" + i;
	  		if (message.FieldExist(name))
	  			message.PutFieldText(name, "");
	  	}
	  	else
	  	{
	  	   break;
	  	}
	}
	
	for(i=1;i < 20;i++) {
		if (message.FieldExist("gongram" + i)) {
			message.PutFieldText("gongram" + i, "");
		}
	}
	
    	
	for(i=0;i < count;i++) {
		var Cell = GetChildNodes(objNodes[i]);
	    var KyljeaOrder = getNodeText(Cell[0]);
	    var KyljeaName = getNodeText(Cell[1]);
	    var KyljeaDeptName =  getNodeText(Cell[3]);
	    var KyljeaType  =  getNodeText(Cell[4]);
	    var KyljeaStat =  getNodeText(Cell[5]);
        var KyljeaJobtitle = getNodeText(Cell[2]);
        var ReasonDoNotApprov = getNodeText(Cell[12]);
	    
	    OrderType[KyljeaOrder] = KyljeaType;
	    OrderName[KyljeaOrder] = KyljeaName;
	    OrderDept[KyljeaOrder] = KyljeaDeptName;
	    OrderStat[KyljeaOrder] = KyljeaStat;      
	    OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
	    OrderReason[KyljeaOrder] = ReasonDoNotApprov;
	}
	
	/* 2023-11-03 홍승비 - G버전에서는 부서합의문서 접수 시에도 기안자의 대결/전결이 가능하므로, 기안자의 결재유형 체크 변수 추가 */
	CurAprType = OrderType[1]; // 한글양식에서는 CurAprType 변수에 결재유형의 코드가 아닌 이름을 저장하므로 주의
    
    LastSignSN = OrderType.length
    for (i=1;i<OrderType.length;i++)
    {
    	if (OrderType[i] == strLangAprType1 || OrderType[i] == strLangAprType4 || OrderType[i] == strLangAprType3)
    	{
    		LastSignSN = i;
        }	
    }

    if (OrderType[1] == strLangAprType4)
    {
		DraftLastFlag = true;
    }
     
	
    lastKyulName = OrderName[LastSignSN]
    lastKyuljiwee = OrderJobtitle[LastSignSN]
	if (message.FieldExist("lastKyuljikwee"))
		message.PutFieldText("lastKyuljikwee", lastKyuljiwee);

	if (message.FieldExist("lastKyulName"))
		message.PutFieldText("lastKyulName", lastKyulName);
    
	hapyuiCnt = 1;
	SignCnt = 1;
	referCnt = 1;
	gongramCnt = 1;

	var fieldname;
	var field;
	var refer;
	
	refer = "";

	for(i=0;i < OrderType.length;i ++)
	{
		switch (OrderType[i])
		{
	  		case strLang126:
	  	   		break;

	  		case strLangAprType1:
	  			break;
	  		
	  		case strLangAprType2:
	  			
	  			if ((OrderName[i] == arr_userinfo[2]) && (i == 1)) IsSkipDrafter = "TRUE";
	  		  	break;				
	  	
	  		case strLang2:
	  			
	  			
	  			
	  			if(xmlReDraft == "R")
	  			{
		  		    fieldname = "habyui" + hapyuiCnt;
		  		    if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname, OrderDept[i]);
				
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname, OrderName[i]);
				
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  				if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname, OrderJobtitle[i]);
				}
	  			else if(xmlReDraft == "C")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (message.FieldExist(fieldname) && OrderStat[i] != strLang173)
				        message.PutFieldText(fieldname, OrderDept[i]);
	  				
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				if (message.FieldExist(fieldname) && OrderStat[i] != strLang173 )
				        message.PutFieldText(fieldname, OrderName[i]);
	  			
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  				if (message.FieldExist(fieldname) && OrderStat[i] != strLang173 )
				        message.PutFieldText(fieldname, OrderJobtitle[i]);
	  				
	  				IsSkipDrafter = "TRUE"; 
	  			}
	  			else
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname, OrderDept[i]);
	  					  		    
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname,  OrderName[i]);
	  				  		    
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  			    if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname,  OrderJobtitle[i]);
	  			}
	  			hapyuiCnt = hapyuiCnt + 1;
	  			break;
	  		
	  		case strLangAprType8:
	  			
	  			if(xmlReDraft == "R")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname,  OrderDept[i]);
				        
	  				IsSkipDrafter = "FALSE";
	  			}
	  			else if(xmlReDraft == "C")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (message.FieldExist(fieldname) && OrderStat[i] != "승인")
                        
				        
	  				IsSkipDrafter = "TRUE"; 
	  			}
	  			else
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname,  OrderDept[i]);
	  				
	  			}
	  			hapyuiCnt = hapyuiCnt + 1;
	  			break;
	  			
	  		case strLangAprType7:
	  			if (referCnt == 1)
	  			{
	  				refer = "";			
	  				refer = refer + OrderName[i];
	  				referCnt = referCnt + 1
	  			}else{
	  				refer = refer + ", "  + OrderName[i];
	  			}
	  			break;
	  			
	  		case strLang12:
	  			fieldname = "gongram" + gongramCnt
	  			if (message.FieldExist(fieldname))
	  			{
				        message.PutFieldText(fieldname,  OrderName[i] + " " + OrderJobtitle[i] + " " + OrderDept[i]);
				        gongramCnt = gongramCnt + 1;
				}       
	  			break;
	  	}
	}
	  
	if(refer != "")
	{
	  	fieldname = "refer";
	    if (message.FieldExist(fieldname))
				        message.PutFieldText(fieldname,  refer);
	}

	
	var susinSN = "";
	if(pDraftFlag == "SUSIN" || pDocState == "011" )
	  	susinSN = pSusinSN 
	
	
	for(i=1;i < 10;i++)
	{
	  	fieldname = susinSN + "jikwe" + i
	  	if (message.FieldExist(fieldname))
	  	    message.PutFieldText(fieldname,  "");
        else
	  		break;
	}
	
	for(i=1;i < 10;i ++)
	{
	  	fieldname =  "hjkwe" + i
	  	if (message.FieldExist(fieldname))
	  	    message.PutFieldText(fieldname,  "");
	  	else
	  		break;
	}

	var idx = 1;
	var hidx = 1;
	for(i=1;i < OrderJobtitle.length;i ++)
	{
	  	if(OrderType[i] == strLangAprType18 || OrderType[i] == strLangAprType19 || OrderType[i] == strLang126 || OrderType[i] == strLangAprType1 || OrderType[i] == strLangAprType4  || OrderType[i] == strLangAprType16)
	  	{
	  	   
	  		var j, chkflag;
	  		if(OrderType[i] == strLangAprType3)
	  		{
	  			chkflag = false;
	  			for(j=1;j < i;j++)
	  			{
	  				if(OrderType[j] == strLangAprType4)
	  				{
	  					chkflag = true;
	  					break;   
	  				}
	  			}
	  			if(!chkflag)
	  			{
	  				fieldname = susinSN + "jikwe" + idx;
	  				if (message.FieldExist(fieldname))
	  	                message.PutFieldText(fieldname,  OrderJobtitle[i]);
	  	                	
	  				fieldname = susinSN + "sign" + idx;
	  				if (message.FieldExist(fieldname))
	  	                message.PutFieldText(fieldname,  OrderName[i] + "<br>" + OrderReason[i]);
	  	                
	  				idx = idx + 1;
	  				continue;
	  			}
	  		}
	  		            
  		    fieldname = susinSN + "jikwe" + idx;
  		    if (message.FieldExist(fieldname))
  	            message.PutFieldText(fieldname,  OrderJobtitle[i]);
  	            
	  	    
	  		fieldname = susinSN + "sign" + idx;
	  		if (message.FieldExist(fieldname))
	  		{
	  	        
	  	        message.PutFieldText(fieldname,  " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
	  	        idx = idx + 1;
	  	    }
	  	}

	  	if(OrderType[i] == strLangAprType8 || OrderType[i] == strLangDocType5 )
	  	{
	  		fieldname =  "hjikwe" + hidx;
	  		if (message.FieldExist(fieldname))
	  		{
	  	        message.PutFieldText(fieldname,  OrderJobtitle[i]);
  	        hidx = hidx + 1;
	  		}		
	  	}	
	}

  }catch(e){
    alert(e.description);
  }	
  
}


function setSignSlash(pSignKinds, pSusin)
{
	var i,j;
	var fieldName;
	var field, fieldvalue;
	var tempFieldName;
	
	for (i=1; i<20; i++)
	{
		tempFieldName = pSusin + "jikwe" + i;
		if (message.FieldExist(tempFieldName))
		{
            fieldName = pSusin + pSignKinds + i;
            if(message.FieldExist(fieldName)){
                message.MoveToField(fieldName);
                var act = message.HwpCtrl.CreateAction("CellBorder");
                var set = act.CreateSet();
                act.GetDefault(set);
                set.SetItem("DiagonalType", 1);
			    if (trim(message.GetFieldText(tempFieldName)) == "" && trim(message.GetFieldText(fieldName)) == "")
                    set.SetItem("SlashFlag", 0x02);
                else
                    set.SetItem("SlashFlag", 0x00);
                act.Execute(set);
            }
		}
	}
}



function ApplyDocCellInfo()
{
  try{
	var i;
	var j;
	var k;
	var fieldname;
	var fieldvalue;
		
	for(j = 1 ; j <= hapyuiCount ; j++)
	{
		fieldname = "habyuidate" + j;
		if (message.FieldExist(fieldname))
		{
			var fieldvalue = trim(message.GetFieldText(fieldname));
			if (fieldvalue == "")
			{
				fieldname = "habyui" + j;			
				if (message.FieldExist(fieldname))
					message.PutFieldText(fieldname, "");
			}
		}
	}
  }catch(e){
	alert("ApplyDocCellInfo()" + e.description);
  }	
}


function ClearDocCellInfo()
{
  try{
	var i;
	var j;
	var fieldname;
	var susunSN = "";
		    
	
	if(pDraftFlag == "SUSIN" || pDocState == "011" ) susunSN = pSusinSN;
	
	for(i = 1; i <= SignCount ; i++)
	{
		fieldname = susunSN + "sign" + i;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */

		fieldname = susunSN + "seumyung" + i;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, "");

		fieldname = susunSN + "seumyungdate" + i;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, "");
					  	
		fieldname = susunSN + "jikwe" + i;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, "");
	}
  
    for(j = 1 ; j <= hapyuiCount ; j++)
    {
		fieldname = susunSN + "habyui" + j;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, "");

		fieldname = susunSN + "habyuipositon" + j;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, "");
		    
		fieldname = susunSN + "habyuidate" + j;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, "");
		
		fieldname = susunSN + "habyuisign" + j;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, " ");
    }
    
    for(i=1;i<20;i++)
    {
		fieldname = susunSN + "habyuiopinion" + i;
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, "");
    }
  }catch(e){
    alert("ClearDocCellInfo()" + e.description);
  }
}


function setClearSusinCellInfo()
{
  try{
	var fieldname;
	fieldname = "recipient";
	if (message.FieldExist(fieldname))
		message.PutFieldText(fieldname, "");
	
	fieldname = "recipients";
	if (message.FieldExist(fieldname))
		message.PutFieldText(fieldname, "");
  }
  catch(e){alert("setClearSusinCellInfo()" + e.description);}
}


function putJunkyulSign(signID) {
	if (message.FieldExist(signID))
		message.PutFieldText(signID, strLangEtcAprType4);
}



function SendDraftMappingSign(ret) {
  try {
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt;
	var sn = 1;

	signCnt = 0;
	
	var PositionText = "";
	PositionText = getOpinionCount();

	if(LastSignSN == 1 && approvalFlag == "G") {
		if(pDraftFlag == "SUSIN" || pDocState == "011") {	
			fieldname = pSusinSN + "sign" + sn;
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
			
			fieldname = pSusinSN + "jikwe" + sn;
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, "");		
		} else {			
			fieldname = "sign" + sn;
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, " ");
		
			fieldname = "jikwe" + sn;
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, "");		
		}
		
		sn = 1;
	}
	else if (DraftLastFlag || approvalFlag == "S")	{
	    if(DraftLastFlag)
		    putJunkyulSign("sign" + sn);
        if(DraftLastFlag || LastSignSN == 1){
            for(i=1;i<20;i++) {
                if(pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
                else signID = "sign" + i

                if (message.FieldExist(signID))
                    LastSignNo = i;
            }
            sn = LastSignNo;
        }
	}

	if (pDraftFlag == "SUSIN" ||  pDocState == "011") { 
		psigncell = pSusinSN + "sign" + sn;
		pseumyungcell = pSusinSN + "jikwe" + sn;
		pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
	} else {
		psigncell = "sign" + sn;
		pseumyungcell = "jikwe" + sn;
		pseumyungdatecell = "seumyungdate" + sn;
	}
	
	 
	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 
	
	var strimg;
	var SingFlag = true;
	var OpinionText = ""; // 합의문서 접수 시에도 대결/전결 문자를 표출하기 위한 변수
	
	// 합의일자와 합의직위가 이미지 서명보다 나중에 삽입되는 경우, 양식상에 제대로 삽입되지 않는 경우가 있어 상단으로 이동 (웹한글 비동기 관련)
	if (message.FieldExist(pseumyungcell)) {
		message.PutFieldText(pseumyungcell, arr_userinfo[3] + PositionText);
		signInfo[signCnt] = pseumyungcell;
		SignName[signCnt] = pseumyungcell;
	  	SignType[signCnt] = "TEXT";
		SignContent[signCnt] = arr_userinfo[3] + PositionText;
		signCnt = signCnt + 1
	}
	
	if (message.FieldExist(pseumyungdatecell)) {
		message.PutFieldText(pseumyungdatecell, s);
		signInfo[signCnt] = pseumyungdatecell;
		SignName[signCnt] = pseumyungdatecell;
	  	SignType[signCnt] = "TEXT";
		SignContent[signCnt] = s;
		signCnt = signCnt + 1
	}
	
	if (CurAprType == strLangAprType4) {
		OpinionText = strLang6 + "\15";
	} else if (CurAprType == strLangAprType16) {
		OpinionText = strLang7 + "\15";
	}
	
	if (ret != "NAME") {
		if (message.FieldExist(psigncell)) {
			message.PutFieldText(psigncell, OpinionText);	
			message.InsertPicture(psigncell, document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(ret), SendDraftMappingSign_after);
		}
		
	  	signInfo[signCnt] = psigncell;
	  	SignName[signCnt] = psigncell;
	  	SignType[signCnt] = "IMAGE";
		SignContent[signCnt] = ret + "::" + OpinionText;
	  	signCnt = signCnt + 1
	  	SingFlag = true;
	}
	else {
		if (message.FieldExist(psigncell)) {
            message.PutFieldText(psigncell, OpinionText + arr_userinfo[2]);	  	
	  		signInfo[signCnt] = psigncell;
	  		SignName[signCnt] = psigncell;
	  	    SignType[signCnt] = "TEXT";
		    SignContent[signCnt] = OpinionText + arr_userinfo[2];
	  		signCnt = signCnt + 1
	  		SingFlag = false; 
		}
	}
	
	if (ret == "NAME") {
		rtnSignInfo = signInfo;
		GetHTML(before_saveRecevInfo);
	}
  } catch(e) {
    alert("SendDraftMappingSign(ret)" + e);
  }
}

function SendDraftMappingSign_after() {
	GetHTML(before_saveRecevInfo);
}

function UndoSignInfo(signInfo)
{
  try{
	var cnt 
	if(signInfo)
	{
		for(cnt=0;cnt < signInfo.length;cnt++)
		{
			if (message.FieldExist(signInfo[cnt]))
				message.PutFieldText(signInfo[cnt], "");
		}
	}
  }catch(e){
	alert("UndoSignInfo(signInfo)" + e.description);
  }
}


function getDraftInfo()
{
  try{
	pFormHref	= FormHref;
	
	
	
	pDraftFlag = DraftFlag; 
	pDocType = DocType;

	
	pSusinSN = SusinSN;    
	pDocState= DocState;
	pDocState = ConvertDocState(pDocState);
	
	if(pDraftFlag == "SUSIN")
	{
		pSusinSN = SusinSN;
		pDocType = DocType;
		pDocState= DocState;
	
		pDocType = ConvertDocType(pDocType);
		pDocState = ConvertDocState(pDocState);
	}
	else if(pDraftFlag == "HAPYUI")
	{
		pDocType = DocType;
		pDocState= DocState;
	
		pDocType = ConvertDocType(pDocType);
		pDocState = ConvertDocState(pDocState);
	}
	pCurSelRow = CurSelRow;
  }catch(e){
    alert(e.description);
  }
}


function ConvertDocType(pDocType)
{
	
	return pDocType;
}


function ConvertDocState(pDocState)
{
	
	return pDocState;
}


function SetBtnStateFalse()
{
  try{
    btnSetAprLine.Enable	= "false";
	btnSendDraft.Enable		= "false";
	btnOpinion.Enable		= "false";  
  }catch(e){
    alert(e.description);
  }
}


function SetBtnStateTrue()
{
  try{
  	btnSetAprLine.Enable	= "true";
  	btnSendDraft.Enable		= "true";
	btnOpinion.Enable		= "true";
	btnClose.Enable			= "true";		
	btnPrint.Enable			= "true";
  }catch(e){
    alert(e.description);
  }
}

function createNewDoc()
{
  try{
	var NewDocID;
	var objRoot;
	var objNode;
	
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);

	xmlhttp.open("POST", "/ezApprovalG/createNewDoc.do", false);
	xmlhttp.send(xmlpara);
	
	if(xmlhttp.responseText == "False")
	{
		var pAlertContent = strLang344 + "<br> " + strLang345;
		OpenAlertUI(pAlertContent);
	}else{
		return xmlhttp.responseText;
	}
  }catch(e){
	  alert("createNewDoc " + e.description);
  }
}

function getDraftUserInfo() {
    try {
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezOrgan/getADInfos.do",
    		data : {
    			cn : pUserID,
    			prop : "displayName;mail;description;company;facsimileTelephoneNumber;telephoneNumber;streetaddress;postalcode",
    			cate  : "user"
    		},
    		success: function(xml){
    			xmluserInfo = loadXMLString(xml);
    		}        			
    	});
    } catch (e) {
        alert("getDraftUserInfo()" + e.description);
    }
}

  // 함수가 겹쳐서 주석 처리. xml 처리도 잘못돼서 버그 일으킴. 2019-09-25 홍대표
//function getDeptSymbol(DeptID, DeptName) {
//var result = "";
//	
//	$.ajax({
//		type : "POST",
//		dataType : "text",
//		async : false,
//		url : "/ezOrgan/getADInfos.do",
//		data : {
//			cn : DeptID,
//			prop : "extensionAttribute6",
//			cate  : "group"
//		},
//		success: function(xml){
//			result = xml;
//		}        			
//	});
//	
//	if (result == "") {
//		return DeptName;
//	} else {
//		return getNodeText(GetChildNodes(loadXMLString(result).documentElement)[0]);
//	}
//}


function SetAutoPropertyValue() {
  try {
	var fieldname;
	var field;
	var pSusinNextSN;
	var objNodes;
	var CurrentDate;
	objNodes = xmluserInfo.documentElement.childNodes;
	
	
    CurrentDate = getGyulJeDate();
    SignInfo = "";
    hapyuiCount = 0;
    SignCount = 0;
  
	var Fields = message.GetFieldList(0, 1);
  
	
	for (i = 0 ; i < Fields.length ; i ++) {
		if(pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
	  		switch (Fields[i]) {
	  			case "bedocnumber" :				    
	  				setDocNumFormat("be");
	  				break;
	  			case "docnumber" :				   
	  				setDocNumFormat("");
	  				break;
	  			case "enforcedate" :		 
	  				break;
	  			case "recipient" :			 
	  				break;
	  			case "refer" :				   
	  		  		break;
	  			case "zipcode" :			   
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(7)));
	  		  		break;
	  			case "address" :			   
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(6)));
	  		  		break;												
	  			case "telephone" :		  	
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(5)));
	  		  		break;												
	  			case "fax" :			      	
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(4)));
	  		  		break;												
	  			case "department" :		  	
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(2)));
	  		  		break;												
	  			case "parantdept" :      
	  				message.PutFieldText(Fields[i], arrDeptInfo[3]);
	  		  		break;
	  			case "seniorposition" :		
	  		  		break;												
	  			case "seniorname" :			 
	  		  		break;												
	  			case "charge" :				   
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(0)));
	  		  		break;
	  			case "position" :			   
	  				message.PutFieldText(Fields[i], arr_userinfo[3]);
		  		  	break;
	  			case "keepperiod" :			 
	  			  	
	  		  		break;												
	  			case "publication" :		 
	  		  		
	  		  		break;												
	  			case "examname" :			  
		  		  	break;												
		  		case "examdate" :			  
	  		  		break;												
	  			case "headcampaign" :		 
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(3)));
		  		  	break;							
	  			case "deptname" :         
	  				message.PutFieldText(Fields[i], arr_userinfo[5]);
	  		  		break;
	  			case "seal" :           
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(3)) + strLang148);
		  		  	break;
	  			case "username" :        
	  				message.PutFieldText(Fields[i], arr_userinfo[2]);
		  		  	break;
	  			case "draftername" :      
	  				message.PutFieldText(Fields[i], arr_userinfo[2]);
		  		  	break;
	  			case "draftdate" :       
	  				message.PutFieldText(Fields[i], CurrentDate);
		  		  	break;
	  			case "receiptdate" :
	  				message.PutFieldText(Fields[i], CurrentDate);
		  		  	break;
	  			case "deptshortedname" :
	  				message.PutFieldText(Fields[i], DeptSymbol);
		  			break;
	  			case "receivername" :
	  				message.PutFieldText(Fields[i], arr_userinfo[2]);
		  			break;	
 			}	  	
	  	}
	  	else {
	  	    switch (field.FieldID) {
	  	     	case pSusinSN + "receiptdate" :	
	  	     		message.PutFieldText(Fields[i], CurrentDate);
	  				break;
	  	    }	
	  	}
	  	
	  	
	  	
	  	if(pDraftFlag == "SUSIN" ||  pDocState == "011")
	  	{
	  		var pSignSusin = pSusinSN + "sign";
	  		if (Fields[i].substr(0, 5) == pSignSusin)
	  	  		SignCount = SignCount + 1;
	  	}
	  	else
	  	{
	  		if (Fields[i].substr(0, 4) == "sign")
	  	  		SignCount = SignCount + 1;
	  	} 
      
		
	    if (Fields[i].substr(0, 10) == "habyuidate")
	    {
	    	hapyuiCount = hapyuiCount + 1;
	    }
	    
	    
	    if (Fields[i].substr(0, 7) == "gongram")
	    {
	    	gongramCount = gongramCount + 1;
	    }
	  	
	    
	    if(pDraftFlag == "SUSIN" || pSusinSN != "0")
	    {
			var pSignInfoSusin = pSusinSN + "jikwe";
			if(Fields[i].substr(0,6) == pSignInfoSusin)
			{
				if(SignInfoFlag)
				{
					SignInfo = message.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}
				else
				{
					SignInfo = message.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    }
	    else
	    {
			if(Fields[i].substr(0,5) == "jikwe")
			{
				if(SignInfoFlag)
				{
					SignInfo = message.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}
				else
				{
					SignInfo = message.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    }
	}
	pSuSinFlag = "N";

	
	
	if(pDraftFlag != "SUSIN" && pDocState != "011")
	{
		var RtnVal = message.FieldExist("recipient");
		if(RtnVal)
	    	pSuSinFlag = "Y";
		else
	    	pSuSinFlag = "N";
	}

	
	if(pSusinSN)
		pSusinNextSN = parseInt(pSusinSN) + 1;
	else
		pSusinNextSN = 1;
	
	fieldname = pSusinNextSN + "sign1";
	if(message.FieldExist(fieldname))	
		pSuSinFlag = "Y";

	pChamJoFlag = "Y";
  }catch(e){	
	alert(e.description);
  }
}

function openOpinionUI(pOpinionFlag) {
  try {
    var parameter = new Array();
    parameter[0]	= pDocID;
    parameter[1]	= pOpinionFlag;
    parameter[2]	= "002";
    parameter[3]	= pDraftFlag;
    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
    parameter[99] = "hwp";
    
    var url = "/ezApprovalG/aprOpinion.do";
	var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
	var ret = window.showModalDialog(url,parameter,feature);
	 if (ret != "cancel" && ret!= "Clear" && ret != undefined) {
	    var NodeList;
	    var objXML = createXmlDom();
	    objXML = loadXMLString(ret);
	    NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
	
	    if(NodeList.length != 0) {
	    	pHasOpinionYN = "Y";
	    } else {
			pHasOpinionYN = "N";
			ret = "cancel";
	    }
	    makeOpinionList(objXML);	    
    }
    return ret;
  } catch(e){
    alert(e.description);
  }
}

function makeOpinionList(OpinionXML) {
	if (!message.FieldExist("opinions"))
		return;

	var firstFlag = true;
	var NodeList = OpinionXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	if (NodeList.length > 0) {
		var strOpinion = " ";
		for (i=NodeList.length - 1; i>=0; i--) {
			
		    if (getNodeText(NodeList.item(i).childNodes(0)) == "일반의견") {
				if (firstFlag) {
					strOpinion = "[" +strLang27 +"\n";
					firstFlag = false;
				}
				strOpinion = strOpinion + "" + getNodeText(NodeList.item(i).childNodes(2)) + "      "; 
				strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(1)) + "      "; 
				strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(6)) + "\n"; 
			}
				
		}		
		message.PutFieldText("opinions", strOpinion);
	}
	else {
		message.PutFieldText("opinions", "");
	}
}

function getOpinionCount()
{
	
	return "";
	
}


function SaveDraftDocInfo() {
	var rtnVal;

	rtnVal = SaveFile();
    if (rtnVal.toUpperCase() != "TRUE") {
		return rtnVal;
	}
	
	SignSave();
	
	switch (pDraftFlag) {
		case "SUSIN" :
			rtnVal = SaveDraftDocInfo_susin();
			break;
		
		case "REDRAFT" :
			if(pDocState == "011")
				rtnVal = SaveDraftDocInfo_susin();
			else
				rtnVal = SaveDraftDocInfo_ilban();
			break;	
       
       default :
			rtnVal = SaveDraftDocInfo_ilban();
			break;
	}

	if (rtnVal.toUpperCase() != "TRUE") {
		SaveOrgFile();
	}

	return rtnVal;
}


function SaveDraftDocInfo_ilban()
{
  try{
	var field;
	var objRoot;
	var objNode;
	var field;
	
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "FORMID", pFormID);

	if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
	    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pOrgDocID);
	    createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", pDocType);
	    createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", pDocState);
	}
	else {
	    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", "");
	    createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", "");
	    createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", "");
	}

	createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", "002");
	createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + pDocID + ".hwp");




	if (message.FieldExist("doctitle"))
	    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", message.GetFieldText("doctitle"));
	else
	    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", "");



	var field = "";
	if (message.FieldExist("docnumber"))
	    field = message.GetFieldText("docnumber");
	else if (message.FieldExist("be_docnumber"))
	    field = message.GetFieldText("be_docnumber");
	else if (message.FieldExist("deptshortedname"))
	    field = message.GetFieldText("deptshortedname");
	else
	    field = "";
	

	createNodeAndInsertText(xmlpara, objNode, "DOCNO", field);

	//부서순차합의 일경우 접수번호를 통해 가져온 DOCNO 를 가져오도록 수정. 2019-02-21 홍대표
	if(pDraftFlag == "HAPYUI" && approvalFlag == "G") {
		xmlpara.getElementsByTagName("DOCNO")[0].textContent = pDocNo;
	}

	createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
	createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);

//	var startdate;
//	if (pState == "000")
//	    startdate = "DRAFTSAVE";
//	else
//	    startdate = "DRAFT";
	createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "WRITERID", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", "");
	createNodeAndInsertText(xmlpara, objNode, "HTML", "");
	createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");
	createNodeAndInsertText(xmlpara, objNode, "PUSERID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[2]);
	createNodeAndInsertText(xmlpara, objNode, "PDEPTID", arr_userinfo[4]);

	createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);

	createNodeAndInsertText(xmlpara, objNode, "PUBLIC", "");
	createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", "");
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", pDocNumCode);

	createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);

	xmlhttp.open("POST", "/ezApprovalG/doDraftHWP.do", false);
	xmlhttp.send(xmlpara);

	if (xmlhttp != null && xmlhttp.readyState == 4) {
    	 if (xmlhttp.status == 200) {
    		SetBtnStateFalse();
    		 return getNodeText(GetChildNodes(xmlhttp.responseXML)[0]);
    	 } else {
    		return "FALSE";
    	 }
    }
	
  }catch(e){
    alert(e.description);
  }
}

function SaveDraftDocInfo_susin()
{
  try{
	var field;
	var objRoot;
	var objNode;
	var field;
	    
	var objNodes = xmldoc.documentElement.childNodes;
		
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	var xmlRtn = createXmlDom();
		

	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", getNodeText(objNodes(0)));
	createNodeAndInsertText(xmlpara, objNode, "FormID", getNodeText(objNodes(1)));
	createNodeAndInsertText(xmlpara, objNode, "OrgDocID", getNodeText(objNodes(2)));
	createNodeAndInsertText(xmlpara, objNode, "DocType", getNodeText(objNodes(3)));

	createNodeAndInsertText(xmlpara, objNode, "DocState", getNodeText(objNodes(4)));
	createNodeAndInsertText(xmlpara, objNode, "FunctionType", "002");
	createNodeAndInsertText(xmlpara, objNode, "Href", getNodeText(objNodes(6)));

	if (message.FieldExist("doctitle"))
	    createNodeAndInsertText(xmlpara, objNode, "DocTitle", message.GetFieldText("doctitle"));
	else
	    createNodeAndInsertText(xmlpara, objNode, "DocTitle", "");

	if (message.FieldExist("docnumber"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", message.GetFieldText("docnumber"));
	else if (message.FieldExist("be_docnumber"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", message.GetFieldText("be_docnumber"));
	else if (message.FieldExist("deptshortedname"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", message.GetFieldText("deptshortedname"));
	else
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", "");

	createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);
	createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", "");
	createNodeAndInsertText(xmlpara, objNode, "StartDate", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "EndDate", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "WriterID", getNodeText(objNodes(13)));
	createNodeAndInsertText(xmlpara, objNode, "WriterName", getNodeText(objNodes(14)));

	createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", getNodeText(objNodes(15)));
	createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", getNodeText(objNodes(16)));
	createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", getNodeText(objNodes(17)));
	createNodeAndInsertText(xmlpara, objNode, "Html", "");
	createNodeAndInsertText(xmlpara, objNode, "OrgHtml", "");

	createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[2]);
	createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

	createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);

	createNodeAndInsertText(xmlpara, objNode, "Public", tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "ItemCode", tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ItemName", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "ItemName2", tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "UrgentApproval", tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KeyWord", tempKeyword);

	createNodeAndInsertText(xmlpara, objNode, "PMemberName", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "SMemberName", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "PMemberDeptName", arr_userinfo[15]);
	createNodeAndInsertText(xmlpara, objNode, "SMemberDeptName", arr_userinfo[16]);
	createNodeAndInsertText(xmlpara, objNode, "PMemberJobTitle", arr_userinfo[13]);
	createNodeAndInsertText(xmlpara, objNode, "SMemberJobTitle", arr_userinfo[14]);
	
	createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);

	xmlhttp.open("POST", "/ezApprovalG/doDraftHWP.do", false);
	xmlhttp.send(xmlpara);
	
	if (xmlhttp != null && xmlhttp.readyState == 4) {
    	 if (xmlhttp.status == 200) {
    		SetBtnStateFalse();
    		return xmlhttp.responseText;
    	 } else {
    		return "FALSE";
    	 }
    }
	
  }catch(e){
	  alert("SaveDraftDocInfo_susin : " + e.description);
  }
}

var aprsign1_cross_dialogArguments = new Array();
function openSignUI(parameter) {
	try {
	    var SignNodeList;
	    var result = "";
	    
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/getSignRequest.do",
			data : {
				userID : pUserID
			},
			success: function(xml){
				result = xml;
			}
		});
		
		SignNodeList = SelectNodes(loadXMLString(result), "LISTVIEWDATA/ROWS/ROW");
		
		/* 2023-08-29 홍승비 - 표준모듈에서 직접서명(useDirectSign) 기능 사용하지 않으므로 관련 변수 및 분기 제거 */
		// if (SignNodeList.length != 0) {
			var parameter	= pUserID;
			aprsign1_cross_dialogArguments[0] = parameter;
	        aprsign1_cross_dialogArguments[1] = openSignUI_Complete;
	        
	        DivPopUpShow(350, 310, "/ezApprovalG/aprSign.do");
	    /* 
		} else {
	    	 openSignUI_Complete("NAME");
	     }
	     */
	} catch(e) {
		alert("openSignUI : " + e);
	}
}


function openAprLineUI() {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;

        parameter[1] = "9999999999";
        parameter[2] = SignCount;
        parameter[3] = SignInfo;
        parameter[4] = hapyuiCount;
        parameter[5] = pDraftFlag;
        parameter[6] = pSuSinFlag;
        parameter[7] = pChamJoFlag;
        parameter[8] = gongramCount;
        parameter[9] = false;
        parameter[10] = pDocType;
        parameter[11] = "";
        parameter[12] = "";
        parameter[13] = DraftFlag;
        parameter[14] = "";
        parameter[15] = "";
        var url = "/myoffice/ezApprovalG/ezAPRLINE/Aprline2.aspx";
        var feature = "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";
        var ret = window.showModalDialog(url, parameter, feature);
        return ret;

    } catch (e) {
        alert(e.description);
    }
} 

function GetAprDocFormID() {
	 try {
    	var result = "";
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getAprDocFormID.do",
    		data : {
    			docID : pDocID
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});

        pFormID = SelectSingleNodeValueNew(loadXMLString(result), "DATA/FORMID");
	        
	 } catch (e) {
       alert("GetAprDocFormID()" + e.description);
	 }
}



function trim(parm_str)
{
  return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
  str_temp = parm_str ;
  while (str_temp.length != 0) {
    if (str_temp.substring(0, 1) == " ") {
      str_temp = str_temp.substring(1, str_temp.length) ;
    } else {
      return str_temp ;
    }
  }
  return str_temp ;
}

function rtrim(parm_str) {
  str_temp = parm_str ;
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


function getGyulJeDate() {
   try {
        var xmlhttp = createXMLHttpRequest();

        xmlhttp.open("POST", "/ezApprovalG/getDate.do", false);
        xmlhttp.send();

        return xmlhttp.responseText;

    } catch (e) {
        alert("getGyulJeDate()" + e.description);
    }
}


function setSusinUpdataDocID()
{
	try{
    	var result = "";
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/setSusinUpdateDocID.do",
    		data : {
    			orgDocID : pOrgDocID,
    			docID    : pDocID,
    			deptID   : RECEIPTDEPTID.innerText
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});

        return getNodeText(GetChildNodes(loadXMLString(result))[0]);

    }
    catch(e){

        alert("setSusinUpdataDocID : " + e.description);

    }
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
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}

/*function OpenAlertUI(pAlertContent) {
	var parameter	= pAlertContent;
	var url = "/ezApprovalG/ezAprAlert.do";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal		= window.showModalDialog(url,parameter,feature);
}*/

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

function getDocInfo() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getDocInfo.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});
	
    xmldoc = result;
    var objNodes = xmldoc.documentElement.childNodes;
	if(objNodes) {
		pOrgDocID = SelectSingleNodeValueNew(result, "DATA/ORGDOCID");			
		if (SelectSingleNodeValueNew(result, "DATA/HASOPINIONYN") == "Y" || SelectSingleNodeValueNew(result, "DATA/HASOPINIONYN") == "O") {
			pHasOpinionYN = "Y";
		}
			
		tempSecurity = SelectSingleNodeValueNew(result, "DATA/SECURITYCODE");
	    tempKeep = SelectSingleNodeValueNew(result, "DATA/STORAGEPERIOD");
	    tempUrgent = SelectSingleNodeValueNew(result, "DATA/URGENTAPPROVAL");
	    tempPublic = SelectSingleNodeValueNew(result, "DATA/ISPUBLIC");
	    tempKeyword = SelectSingleNodeValueNew(result, "DATA/KEYWORD");
	    tempItemCode = SelectSingleNodeValueNew(result, "DATA/ITEMCODE");
	    tempItemName = SelectSingleNodeValueNew(result, "DATA/ITEMNAME");		
		
        pSummery = SelectSingleNodeValueNew(result, "DATA/SUMMARY");
        pSpecialRecordCode = SelectSingleNodeValueNew(result, "DATA/SPECIALRECORDCODE");
        pPublicityCode = SelectSingleNodeValueNew(result, "DATA/PUBLICITYCODE");
        pLimitRange = SelectSingleNodeValueNew(result, "DATA/LIMITRANGE");
        pPageNum = SelectSingleNodeValueNew(result, "DATA/PAGENUM");
        cabinetID = SelectSingleNodeValueNew(result, "DATA/CABINETID");
        TaskCode = SelectSingleNodeValueNew(result, "DATA/TASKCODE");

        tempSecurityDate = SelectSingleNodeValueNew(result, "DATA/SECURITYAPPROVAL");
		drafterDeptid = SelectSingleNodeValueNew(result, "DATA/WRITERDEPTID");
    }
}

function getReceiveDocInfo() {
  try{
	  var pdocXML;
	  var result = "";
  	
      $.ajax({
  		type : "POST",
  		dataType : "text",
  		async : false,
  		url : "/ezApprovalG/getReceiveDocInfo.do",
  		data : {
  			docID : pDocID
  		},
  		success: function(xml){
  			result = loadXMLString(xml);
  		}        			
  	});
    
    xmlpara = createXmlDom();

    pdocXML = SelectSingleNodeNew(result, "RECEIVEDATA/DOCINFO");
    xmlString = getXmlString(pdocXML);
    xmlpara = loadXMLString(xmlString);
    document.getElementById("DOCINFO").dataSource = xmlpara;
	
    
    xmlpara = createXmlDom();
    pdocXML = SelectSingleNodeNew(result, "RECEIVEDATA/ATTACHINFO");
    xmlString = getXmlString(pdocXML);
    xmlpara = loadXMLString(xmlString);
    document.getElementById("ATTACHINFO").dataSource = xmlpara;
	
    xmlpara = createXmlDom();
    pdocXML = SelectSingleNodeNew(result, "RECEIVEDATA/DOCFLAGINFO");
    xmlString = getXmlString(pdocXML);
    xmlpara = loadXMLString(xmlString);

    var node = GetElementsByTagName(xmlpara, "DocFlag");
    pDraftFlag = getNodeText(node[0]);
    
    var node = GetElementsByTagName(xmlpara, "Href");
    pFormHref = getNodeText(node[0]);
	
    pOrgDocID = getNodeText(GetElementsByTagName(result, "ORGDOCID")[0]);
    var doctitle = getNodeText(GetElementsByTagName(result, "DOCTITLE")[0]);
	
	if (CrossYN()) {
		RECEIPTDEPTID.textContent = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
	} else {
		RECEIPTDEPTID.innerText = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
	}
	   
	switch (pDraftFlag) {
		case "SUSIN" :
			pSusinSN     = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
            pDocType     = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
            pDocState    = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
            pAprState    = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
            pSusinDocURL = pFormHref;
			pSusinDocURL = pSusinDocURL.replace("mht", "hwp");
			break;

		case "HAPYUI" :
			pSusinSN = ""
			pDocType     = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
            pDocState    = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
            pAprState    = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
            pSusinDocURL = getNodeText(GetElementsByTagName(result, "HAPYUI")[0]);
			pSusinDocURL = pSusinDocURL.replace("mht", "hwp");
			break;
				
		case "GAMSABU" :
			pSusinSN     = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
            pDocType     = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
            pDocState    = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
            pAprState    = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
            pSusinDocURL = getNodeText(GetElementsByTagName(result, "GAMSA")[0]);
			pSusinDocURL = pSusinDocURL.replace("mht", "hwp");
			break;
				
		case "WHOKYUL" :
			pSusinSN      = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
            pDocType      = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
            pDocState     = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
            pAprState     = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
            pSusinDocURL  = getNodeText(GetElementsByTagName(result, "GAMSA")[0]);
			pSusinDocURL  = pSusinDocURL.replace("mht", "hwp");
			break;
			
		case "GONGRAM" :
            pSusinSN     = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
            pDocType     = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
            pDocState    = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
            pAprState    = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
            pSusinDocURL = pFormHref;
			pSusinDocURL = pSusinDocURL.replace("mht", "hwp");
			break;
			
		default :
			pSusinSN = "1"; 
			break;
	}
  }catch(e){
	alert("getReceiveDocInfo :: " + e.description);
  }
}


function setButtonReceiveTrue()
{
	SetBtnStateFalse();
	/*btnAssign.Enable = "false";
	btnDistribute.Enable = "false";
	btnReturn.Enable = "false";
	btnAproveSusin.Enable = "false";*/
}

function setHeSongDocInfo() {
    try {
    	var objRoot;
        var objNode;

        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        createNodeInsert(xmlpara, objNode, "ASSIGN");

        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pAprMemberDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pAprMemberID", pUserID);
        createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", "1");

        xmlhttp.open("POST", "/ezApprovalG/setHeSongHapyuiDocInfo.do", false);
        xmlhttp.send(xmlpara);
    
        if (xmlhttp != null && xmlhttp.readyState == 4) {
   	 		if (xmlhttp.status == 200) {
   	 			var pAlertContent = strLang878;
   	 			OpenAlertUI(pAlertContent, OpenAlertUI_Close);
   	 			return true;
   	 		} else {
   	 			var pAlertContent = strLang740;
   	 			OpenAlertUI(pAlertContent, OpenAlertUI_Close);
   	 			return false;
   	 		}
        } 
    } catch(e){
    	alert("setHeSongDocInfo :: " + e.description);
    }
}

var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd() {
	var parameter = pUserID;
	var url		= "/ezApprovalG/ezchkPasswd.do";
	
	ezchkpasswd_cross_dialogArguments[0] = parameter;
	ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

	DivPopUpShow(330, 200, url);
	//var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	//var ret = window.showModalDialog(url,parameter,feature);
		
	//return ret;
}

function getLastOpinon()
{
	
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getLastOpinonCotent.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = loadXMLString(xml);
		}
	});
	
	var content = "";
    if (GetChildNodes(result.documentElement).length > 0 )
        content = getNodeText(GetChildNodes(result.documentElement)[0]);

	if (message.FieldExist("memo"))
		message.PutFieldText("memo", content);
}


function setFirstDrafter()
{
	var pxml 
	var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

	pxml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>결재순번</NAME><WIDTH>100</WIDTH></HEADER>"
	pxml = pxml + "<HEADER><NAME>이름</NAME><WIDTH>100</WIDTH></HEADER>"
	pxml = pxml + "<HEADER><NAME>부서</NAME><WIDTH>150</WIDTH></HEADER>"
	pxml = pxml + "<HEADER><NAME>결재방법</NAME><WIDTH>150</WIDTH></HEADER>"
	pxml = pxml + "<HEADER><NAME>결재상태</NAME><WIDTH>100</WIDTH></HEADER>"
	pxml = pxml + "<HEADER><NAME>결재일</NAME><WIDTH>120</WIDTH></HEADER>"
	pxml = pxml + "<HEADER><NAME>수신일</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>"
	pxml = pxml + "<ROWS><ROW><COLUMN>1</COLUMN>"
	pxml = pxml + "<COLUMN>" + arr_userinfo[2] + "</COLUMN>"
	pxml = pxml + "<COLUMN>" + arr_userinfo[3] + "</COLUMN>"
	pxml = pxml + "<COLUMN>" + arr_userinfo[5] + "</COLUMN>"
	pxml = pxml + "<COLUMN>" + "확인" + "</COLUMN>"
	pxml = pxml + "<COLUMN>" + "진행" + "</COLUMN>"
	pxml = pxml + "<DATA name='ProcessDate'></DATA>"
	pxml = pxml + "<DATA name='ReceivedDate'></DATA>"
	pxml = pxml + "<DATA name='DocID'>" + pDocID + "</DATA>"
	pxml = pxml + "<DATA name='AprMemberID'>" + arr_userinfo[1] + "</DATA>"
	pxml = pxml + "<DATA name='AprmemberIsDeptYN'>N</DATA>"
	pxml = pxml + "<DATA name='AprMemberDeptID'>" + arr_userinfo[4] + "</DATA>"
	pxml = pxml + "<DATA name='ReasonDoNotApprov'>" + "" + "</DATA>"
	pxml = pxml + "<DATA name='isProposerYN'>N</DATA>"
	pxml = pxml + "<DATA name='isBriefUserYN'>N</DATA>"
	pxml = pxml + "</ROW></ROWS></LISTVIEWDATA>"
	
	xmlpara.loadXML(pxml);
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave.aspx", false);
	xmlhttp.send(xmlpara);
	
	
	
	if(xmlhttp.responseText == "true")
	{
		
		
		
		
		
		
		
		
		
		
		
		LastSignSN = 1;
	
	}
	else
	{
		var pAlertContent = strLang760;
		OpenAlertUI(pAlertContent);
	
	}
}


function setDocNumFormat(pPrefix)
{
	var Arr_Header = new Array()
	var Header, Tail
	var i
	var d = new Date();
		
	var numHeader = ""
	if(pDraftFlag == "REDRAFT") return;
		
	if(!message.FieldExist(pPrefix + "docnumber"))		
		return 




	
	var fieldValue = message.GetFieldText(pPrefix + "docnumber");
	Arr_Header = fieldValue.split("@")
	    
	for(i=1;i<Arr_Header.length;i++)
	{
		Header = Arr_Header[i].substr(0,2);
		Tail   = Arr_Header[i].substr(2);
				
		switch(Header)
		{
			case "DP":
				numHeader = numHeader + DeptSymbol + Tail;
				break;			

			case "dp":
				numHeader = numHeader + DeptSymbol + Tail 
				break;

			case "YY":
				numHeader = numHeader + getAccountingYear() + Tail
				break;

			case "yy":
				var yyear = getAccountingYear()
				numHeader = numHeader + yyear.toString().substr(2) + Tail
				break;

			case "MM":
				var mmonth = d.getMonth() + 1
				if(parseInt(mmonth) < 10) mmonth = "0" + mmonth;
					numHeader = numHeader + mmonth + Tail
				break;

			case "mm":
				numHeader = numHeader + (d.getMonth() + 1) + Tail
				break;

			case "NN":
				break;

			case "nn":
				break;

			case "cs":
				numHeader = numHeader + strLang107 + Tail;
				break;

			default:
				numHeader = numHeader + fieldValue;
				break;
		}
	}
			
	message.PutFieldText(pPrefix + "docnumber", numHeader);
	if(numHeader.indexOf(strLang107) > 0) 
		HwpCtrl.SetDocumentInfo("NULL", "NULL", numHeader);
}



function SaveFile()
{

    var result = "";

	var data = {
		docID : pDocID,
		html  : pOrgHtml,
		orgCompanyID : orgCompanyID
	}

    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveFileHWP.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});
    
	return result;
}

function SaveOrgFile()
{
	var result = "";

	// 2021.01.07 강승구 : 오류발생 후 파일이 사라지는 오류 수정
	if (!pOrgHtml)
        return;
	
	var data = {
		docID : pDocID,
		html  : pOrgHtml,
		orgCompanyID : orgCompanyID
	}
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveFileHWP.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});
		
	return result;
}


function SignSave()
{
	if (SignContent.length > 0)
	{
		var xmlhttp = createXMLHttpRequest();
		var xmlpara = createXmlDom();
  
		var objRoot, objNode, subNode;
		objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

		for (i = 0; i < SignContent.length; i++) {
		    objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "SIGNINFO");
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", pDocID);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNTYPE", SignType[i]);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNNAME", SignName[i]);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "CONTENT", SignContent[i]);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "ORGCOMPANYID", orgCompanyID);
		}
		xmlhttp.open("Post", "/ezApprovalG/setSignInfo.do", false);
		xmlhttp.send(xmlpara);
	}
}


function setRecevInfo(ret)
{
	
	var i
	var strMailAdd = ""
	var precipent = ""
	var precipents = ""
	var	mailflag = true;
	var recipflag = true;
	var mailList = "";
	var mailcnt = 0;
	
	var xmldom = createXmlDom();
	xmldom.async = false;
	xmldom.loadXML(ret)

	
	if (message.FieldExist("hrecipients"))
		message.PutFieldText("hrecipients", "");
	
	if (message.FieldExist("recipient"))
	{
		message.PutFieldText("recipient", "");
	}

	if (message.FieldExist("recipients"))
		message.PutFieldText("recipients", "");

	if(xmldom.documentElement.length == 0) return;
	var rows = xmldom.documentElement.childNodes
	
	for(i=rows.length - 1;i>=0;i--)
	{
		var row = rows(i)
		if(getNodeText(rows(i).childNodes(3)) == "Y")
		{
			if(mailflag)
			{
				strMailAdd = "\"" + getNodeText(rows(i).childNodes(0)) + "\"" + " " + "<" + getNodeText(rows(i).childNodes(6)) + ">";
				mailflag = false;
				mailList = getNodeText(rows(i).childNodes(0));
			}
			else
			{
				strMailAdd = strMailAdd + ", " + "\"" + getNodeText(rows(i).childNodes(0)) + "\"" + " " + "<" + getNodeText(rows(i).childNodes(6)) + ">";
				mailList = mailList + "," + getNodeText(rows(i).childNodes(0));
			}
			mailcnt = mailcnt + 1;
		}	
		
		if(recipflag)
		{
				if(getNodeText(rows(i).childNodes(3)) == "Y")
				{
					precipent = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0)) 
					precipents = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
					recipflag = false;	
				}
				else
				{	
					if(isExtDoc == "Y")
					{
						precipent = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
						precipents = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))				
						recipflag = false;	
					}
					else
					{
						precipent = getNodeText(rows(i).childNodes(0))
						precipents = getNodeText(rows(i).childNodes(0))				
						recipflag = false;	
					}
				}
			
		}
		else
		{
			precipent = strLang68;
			
			if(getNodeText(rows(i).childNodes(3)) == "Y")
				precipents = precipents + "," + getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
			else
			{
				if(isExtDoc == "Y")
					precipents = precipents + "," + getNodeText(rows(i).childNodes(7)) + " " +  getNodeText(rows(i).childNodes(0)); 
				else
					precipents = precipents + "," + getNodeText(rows(i).childNodes(0));
			}
		}		
	}
	
	
	
		
	
	if (message.FieldExist("recipient"))
	{
		if(precipent == strLang68)
		{
			message.PutFieldText("recipient", precipent);		
			
			if (message.FieldExist("recipients"))
				message.PutFieldText("recipients", precipents);		

			if (message.FieldExist("hrecipients"))
				message.PutFieldText("hrecipients", strLang70);		
		}
		else
		{
			message.PutFieldText("recipient", precipent);		
		
			if(precipents == "")
			{			
				if (message.FieldExist("recipients"))
					message.PutFieldText("recipients", "");		

				if (message.FieldExist("hrecipients"))
					message.PutFieldText("hrecipients", "");		
			}
		}	
	}
	else if (message.FieldExist("recipients"))
		message.PutFieldText("recipients", precipents);
}


function UpdateLineHistory()
{
var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateLineHistory.do",
		data : {
			docID : pDocID,
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
			
			var DataNodes = GetChildNodes(loadXMLString(result));
		    var rtnVal = getNodeText(DataNodes[0]);
		    if (rtnVal == "TRUE") {
		    }
		    else {
		        var pAlertContent = strLang91;
		        OpenAlertUI(pAlertContent);
		    }
		},
		error : function() {
			var pAlertContent = strLang720;
			OpenAlertUI(pAlertContent);
		}
	});
}

var apropinion_cross_dialogArguments = new Array();
function openOpinionUI_New(pOpinionType, CompleteFunction) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = "";			//DRAFTFLAG 결재는 공백 고정 
		parameter[3] = pDocState;	//DOCSTATE
		parameter[4] = orgCompanyID;//ORGCOMPANYID
		parameter[99] = ext;		//EXT
		
		apropinion_cross_dialogArguments[0] = parameter;
		if (typeof(CompleteFunction) != "undefined") {
			apropinion_cross_dialogArguments[1] = CompleteFunction;
		} else {
			apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete;
		}
		
		/*
		var url = "/ezApprovalG/aprOpinionNew.do";
		var OpenWin = window.open(url, "AprOpinion_Cross", GetOpenWindowfeature(530, 520));
        try { OpenWin.focus(); } catch (e) { }
        */
		DivPopUpShow(530, 520, "/ezApprovalG/aprOpinionNew.do");
	} catch (e) {
		alert("openOpinionUI_New ::: " + e.description);
	}
}

function openOpinionUI_New_Complete(ret) {
	try {
		DivPopUpHidden();
		if (ret == "Clear") {
			pHasOpinionYN = "N";
		} else if (ret == "cancel") {
			//do_nothing
		} else {
	        var objXML = createXmlDom();
	        objXML = loadXMLString(ret);
	        
	        var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
	        if (NodeList.length != 0) {
	            pHasOpinionYN = "Y";
	        } else {
	            pHasOpinionYN = "N";
	            ret = "cancel";
	        }
		}
	} catch (e) {
		alert("openOpinionUI_New_Complete ::: " + e.description);
	}
}

function SGetDraftAprLineInfo(ret) {
    try {
        DraftLastFlag = false;
        var xmlKuljea;
        var chamjo;
        var hapyuiCnt;
        var SignCnt;
        var referCnt;
        var xmlReDraft;
        var objNodes;
        var fields;
        var findstring;
        var count;
        var i;
        var name;
        var OrderType = new Array();
        var OrderTypeName = new Array();
        var OrderDept = new Array();
        var OrderName = new Array();
        var OrderStat = new Array();
        var OrderStatName = new Array();
        var OrderJobtitle = new Array();
        var OrderReason = new Array();
        var OrderAddress = new Array();
        var OrderID = "";

        if (ret[5] == undefined) {
            xmlKuljea = ret[0];
            xmlReDraft = ret[2];
        } else {
            xmlKuljea = ret[1];
            xmlReDraft = ret[5];
        }

	    setAprLinesXML(xmlKuljea);

        xmlReDraft = "R";
        if (xmlReDraft == "C") {
            ApplyDocCellInfo();
        } else if (xmlReDraft == "R") {
            ClearDocCellInfo(ret);
        }

        xmldom = loadXMLString(xmlKuljea);

        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        count = objNodes.length;

        for(i=1;i<200;i++)
        {
            name = "habyuidate" + i;
            if (message.FieldExist(name))
            {
                if(!trim(message.GetFieldText(name))){
                    name = "habyui" + i;
                    if (message.FieldExist(name))
                        message.PutFieldText(name, "");

                    name = "habyuisign" + i;
                    if (message.FieldExist(name))
                        message.PutFieldText(name, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */

                    name = "habyuipositon" + i;
                    if (message.FieldExist(name))
                        message.PutFieldText(name, "");
                }
            }
            else {
               break;
            }
        }

        var tmpI = 1;
        while(message.FieldExist("gongram" + tmpI)){
            message.PutFieldText("gongram" + tmpI++ , "");
        }

        for (i = 0; i < count; i++) {
            var Cell = GetChildNodes(objNodes[i]);
            var KyljeaOrder = getNodeText(Cell[0]);
            var KyljeaName = getNodeText(Cell[1]);
            var KyljeaDeptName = getNodeText(Cell[3]);
            var KyljeaType = getNodeText(Cell[16]);
            var KyljeaTypeName = getNodeText(Cell[4]);
            var KyljeaStat = getNodeText(Cell[17]);
            var KyljeaStatName = getNodeText(Cell[5]);
            var KyljeaJobtitle = getNodeText(Cell[2]);
            var ReasonDoNotApprov = getNodeText(Cell[12]);
            var KyljeaID = getNodeText(Cell[9]);

            OrderType[KyljeaOrder] = KyljeaType;
            OrderTypeName[KyljeaOrder] = KyljeaTypeName;
            OrderName[KyljeaOrder] = KyljeaName;
            OrderDept[KyljeaOrder] = KyljeaDeptName;
            OrderStat[KyljeaOrder] = KyljeaStat;
            OrderStatName[KyljeaOrder] = KyljeaStatName;
            OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
            OrderReason[KyljeaOrder] = ReasonDoNotApprov;
            OrderID += KyljeaID + ",";
        }

        LastSignSN = OrderType.length;

        for (i = 1; i < OrderType.length; i++) {
            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40)
                LastSignSN = i;
        }

        if (OrderType[1] == strAprType4) {
            DraftLastFlag = true;
        }

        if (message.FieldExist("lastKyulName")) {
            message.PutFieldText("lastKyulName", OrderName[LastSignSN]);
        }

        hapyuiCnt = 1;
        SignCnt = 1;
        referCnt = 1;
        gongramCnt = 1;

        var fieldname;
        var field;
        var refer = "";

        for (i = 0; i < OrderType.length; i++) {
            switch (OrderType[i]) {
                case strAprType1:
                    break;

                case strAprType2:
                    if (OrderName[i] == arr_userinfo[2] && i == 1) {
                    	IsSkipDrafter = "TRUE";
                    }
                    break;

                case strAprType11: // 부서순차합의
                    fieldname = "habyuisign" + hapyuiCnt;
                    if (message.FieldExist(fieldname)) {
                        if(message.FieldExist("habyuisign" + hapyuiCnt) && !message.FieldExist("habyuija" + hapyuiCnt))
                            message.PutFieldText(fieldname, OrderName[i]);
                    }

                    fieldname = "habyuipositon" + hapyuiCnt;
                    if (message.FieldExist(fieldname)) {
                        message.PutFieldText(fieldname, OrderJobtitle[i]);
                    }

                case strAprType8: // 개인순차합의
                    if(OrderType[i] == strAprType8)
                        IsSkipDrafter = "FALSE";
                    var orderStat = OrderType[i] == strAprType12 ? strLangS57 : strLangS26;
                    var habyuisign = OrderType[i] == strAprType11 || OrderType[i] == strAprType12 ? OrderDept[i] : OrderName[i];

                    fieldname = "habyui" + hapyuiCnt;
                    if (message.FieldExist(fieldname)) {
                        message.PutFieldText(fieldname, OrderDept[i]);
                    }

                    hapyuiCnt = hapyuiCnt + 1;
                    break;

                case strAprType7:
                    if (referCnt == 1) {
                        refer = OrderName[i];
                        referCnt = referCnt + 1;
                    } else {
                        refer = refer + "," + OrderName[i];
                    }
                    break;

                case strAprType17:
                    fieldname = "gongram" + gongramCnt
                    if (message.FieldExist(fieldname)) {
                        message.PutFieldText(fieldname, OrderName[i] + " " + OrderJobtitle[i] + " " + OrderDept[i]);
                        gongramCnt = gongramCnt + 1;
                    }
                    break;
            }
        }

        if (refer != "") {
            fieldname = "refer";
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, refer);
            }
        }

        var susinSN = "";
        if (pDraftFlag == "SUSIN" || pDocState == strDocState11 || pDraftFlag == "GAMSABU")
            susinSN = pSusinSN;

        var cnt = 20;

        var fieldList = ["jikwe", "sign", "approdept", "seumyung"];
        var isPass = false;
        for (i = 1; i <= cnt; i++) {
            fieldname = susinSN + "jikwe" + i;
            if (message.FieldExist(fieldname))
                message.PutFieldText(fieldname, "");
            else
                break;
        }

        for (i = 1; i < cnt; i++) {
            fieldname = "hjkwe" + i;
            if (message.FieldExist(fieldname))
                message.PutFieldText(fieldname, "");
            else
                break;
        }

        for (i = 1; i < cnt; i++) {
            fieldname = "sign" + i;
            if (message.FieldExist(fieldname))
                message.PutFieldText(fieldname, "");
            else
                break;
        }

        var idx = 1;
        var hidx = 1;
        var Flag = "";
        if (pDraftFlag == "SUSIN" || pDocState == strDocState11)
            Flag = susinSN + "Recv";

        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40) {
                if (LastSignSN == i) {
                    for (k = 1; k <= cnt; k++) {
                        if (pDraftFlag == "SUSIN" || pDraftFlag == "GAMSABU") signID = pSusinSN + "sign" + k;
                        else signID = "sign" + k;

                        if (message.FieldExist(signID)) {
                            LastSignNo = k;
                        }
                    }
                    idx = LastSignNo;
                }
                var j, chkflag;

 				if (junGyulFlag == "4") {
        			if (OrderType[i] == "003") {
        				continue;
        			}
        		}

        		if (OrderType[i] == strAprType3) {
                    chkflag = false;
                    for (j = 1; j < i; j++) {
                        if (OrderType[j] == strAprType4) {
                            chkflag = true;
                            break;
                        }
                    }
                    if (!chkflag) {
                        fieldname = susinSN + "jikwe" + idx;
                        if (message.FieldExist(fieldname)) {
                            message.PutFieldText(fieldname, OrderJobtitle[i]);
                        }

                        fieldname = susinSN + "sign" + idx;
                        if (message.FieldExist(fieldname)) {
                            message.PutFieldText(fieldname, OrderName[i] + "\15" + OrderReason[i]);
                        }

                        fieldname = susinSN + "approdept" + idx;
                        if (message.FieldExist(fieldname)) {
                            message.PutFieldText(fieldname, OrderDept[i]);
                        }

                        idx = idx + 1;
                        continue;
                    }
                }

                fieldname = susinSN + "jikwe" + idx;
                if (message.FieldExist(fieldname)) {
                    message.PutFieldText(fieldname, OrderJobtitle[i]);
                }

                fieldname = susinSN + "sign" + idx;
                if (message.FieldExist(fieldname)) {
                    /* 2020-07-24 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
                	if (!message.FieldExist(susinSN + "seumyung" + idx)) {
                		message.PutFieldText(fieldname, OrderName[i]);
                	}
                	// 서명필드 + 결재자명 필드가 함께 존재
                	else {
                	    message.PutFieldText(fieldname, "[NOSLASH]");
                	    // 그 외의 경우, 아무런 값이 부여되지 않으므로 슬래시 이미지를 표출
                	    // 그 외의 경우가 없음.
//                		field.innerHTML = "[NOSLASH]";
                	}
                }


                fieldname = susinSN + "approdept" + idx;
                if (message.FieldExist(fieldname)) {
                    message.PutFieldText(fieldname, OrderDept[i]);
                }
                	idx = idx + 1; // 서명칸이 존재하는 경우, idx를 1 증가시켜서 다음 칸을 찾는다.
            }

            if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
                fieldname = "hjikwe" + hidx;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    setNodeText(field , OrderJobtitle[i]);
                    hidx = hidx + 1;
                }
            }
        }
        if (isSplit == "Y")
            setSignSlash("sign", susinSN);
    } catch (e) {
        alert("SGetDraftAprLineInfo(ret)" + e.description);
    }
}