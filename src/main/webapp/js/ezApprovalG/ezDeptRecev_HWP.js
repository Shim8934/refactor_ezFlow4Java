
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
		if (HwpCtrl.CheckFieldExist(name))
		{
	  		name = "habyui" + i;
	  		if (HwpCtrl.CheckFieldExist(name))
	  			HwpCtrl.SetFieldText(name, "");
	  		
	  		name = "habyuisign" + i;
	  		if (HwpCtrl.CheckFieldExist(name))
	  			HwpCtrl.SetFieldText(name, "");
	  		
	  		name = "habyuipositon" + i;
	  		if (HwpCtrl.CheckFieldExist(name))
	  			HwpCtrl.SetFieldText(name, "");
	  		
	  		
	  		name = "habyuidate" + i;
	  		if (HwpCtrl.CheckFieldExist(name))
	  			HwpCtrl.SetFieldText(name, "");
	  	}
	  	else
	  	{
	  	   break;
	  	}
	}
	
	for(i=1;i < 20;i++) {
		if (HwpCtrl.CheckFieldExist("gongram" + i)) {
			HwpCtrl.SetFieldText("gongram" + i, "");
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
     
    
    LastSignSN = OrderType.length
    for(i=1;i<OrderType.length;i++)
    {
    	if(OrderType[i] == strLangAprType1 || OrderType[i] == strLangAprType4 || OrderType[i] ==strLangAprType3 )
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
	if (HwpCtrl.CheckFieldExist("lastKyuljikwee"))
		HwpCtrl.SetFieldText("lastKyuljikwee", lastKyuljiwee);

	if (HwpCtrl.CheckFieldExist("lastKyulName"))
		HwpCtrl.SetFieldText("lastKyulName", lastKyulName);
    
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
		  		    if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname, OrderDept[i]);
				
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname, OrderName[i]);
				
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);
				}
	  			else if(xmlReDraft == "C")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname) && OrderStat[i] != strLang173)
				        HwpCtrl.SetFieldText(fieldname, OrderDept[i]);
	  				
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname) && OrderStat[i] != strLang173 )
				        HwpCtrl.SetFieldText(fieldname, OrderName[i]);
	  			
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname) && OrderStat[i] != strLang173 )
				        HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);
	  				
	  				IsSkipDrafter = "TRUE"; 
	  			}
	  			else
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname, OrderDept[i]);
	  					  		    
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname,  OrderName[i]);
	  				  		    
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  			    if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname,  OrderJobtitle[i]);
	  			}
	  			hapyuiCnt = hapyuiCnt + 1;
	  			break;
	  		
	  		case strLangAprType8:
	  			
	  			if(xmlReDraft == "R")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname,  OrderDept[i]);
				        
	  				IsSkipDrafter = "FALSE";
	  			}
	  			else if(xmlReDraft == "C")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname) && OrderStat[i] != "승인")
                        
				        
	  				IsSkipDrafter = "TRUE"; 
	  			}
	  			else
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname,  OrderDept[i]);
	  				
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
	  			if (HwpCtrl.CheckFieldExist(fieldname))
	  			{
				        HwpCtrl.SetFieldText(fieldname,  OrderName[i] + " " + OrderJobtitle[i] + " " + OrderDept[i]);
				        gongramCnt = gongramCnt + 1;
				}       
	  			break;
	  	}
	}
	  
	if(refer != "")
	{
	  	fieldname = "refer";
	    if (HwpCtrl.CheckFieldExist(fieldname))
				        HwpCtrl.SetFieldText(fieldname,  refer);
	}

	
	var susinSN = "";
	if(pDraftFlag == "SUSIN" || pDocState == "011" )
	  	susinSN = pSusinSN 
	
	
	for(i=1;i < 10;i++)
	{
	  	fieldname = susinSN + "jikwe" + i
	  	if (HwpCtrl.CheckFieldExist(fieldname))
	  	    HwpCtrl.SetFieldText(fieldname,  "");
        else
	  		break;
	}
	
	for(i=1;i < 10;i ++)
	{
	  	fieldname =  "hjkwe" + i
	  	if (HwpCtrl.CheckFieldExist(fieldname))
	  	    HwpCtrl.SetFieldText(fieldname,  "");
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
	  				if (HwpCtrl.CheckFieldExist(fieldname))
	  	                HwpCtrl.SetFieldText(fieldname,  OrderJobtitle[i]);
	  	                	
	  				fieldname = susinSN + "sign" + idx;
	  				if (HwpCtrl.CheckFieldExist(fieldname))
	  	                HwpCtrl.SetFieldText(fieldname,  OrderName[i] + "<br>" + OrderReason[i]);
	  	                
	  				idx = idx + 1;
	  				continue;
	  			}
	  		}
	  		            
  		    fieldname = susinSN + "jikwe" + idx;
  		    if (HwpCtrl.CheckFieldExist(fieldname))
  	            HwpCtrl.SetFieldText(fieldname,  OrderJobtitle[i]);
  	            
	  	    
	  		fieldname = susinSN + "sign" + idx;
	  		if (HwpCtrl.CheckFieldExist(fieldname))
	  		{
	  	        
	  	        HwpCtrl.SetFieldText(fieldname,  "");
	  	        idx = idx + 1;
	  	    }
	  	}

	  	if(OrderType[i] == strLangAprType8 || OrderType[i] == strLangDocType5 )
	  	{
	  		fieldname =  "hjikwe" + hidx;
	  		if (HwpCtrl.CheckFieldExist(fieldname))
	  		{
	  	        HwpCtrl.SetFieldText(fieldname,  OrderJobtitle[i]);
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
		if (HwpCtrl.CheckFieldExist(tempFieldName))
		{
			if (trim(HwpCtrl.GetFieldText(tempFieldName)) == "")
			{
				fieldName = pSusin + pSignKinds + i;
				if(HwpCtrl.CheckFieldExist(fieldName))
				{
					if (trim(HwpCtrl.GetFieldText(fieldName)) == "")
					{
						HwpCtrl.SetFieldSlash(fieldName, true);
					}
					else
					{
						HwpCtrl.SetFieldSlash(fieldName, false);
					}
				}				
			}
			else
			{
				fieldName = pSusin + pSignKinds + i;
				if(HwpCtrl.CheckFieldExist(fieldName))
				{
					HwpCtrl.SetFieldSlash(fieldName, false);
				}
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
		if (HwpCtrl.CheckFieldExist(fieldname))
		{
			var fieldvalue = trim(HwpCtrl.GetFieldText(fieldname));
			if (fieldvalue == "")
			{
				fieldname = "habyui" + j;			
				if (HwpCtrl.CheckFieldExist(fieldname))
					HwpCtrl.SetFieldText(fieldname, "");
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
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");

		fieldname = susunSN + "seumyung" + i;
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");

		fieldname = susunSN + "seumyungdate" + i;
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");
					  	
		fieldname = susunSN + "jikwe" + i;
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");
	}
  
    for(j = 1 ; j <= hapyuiCount ; j++)
    {
		fieldname = susunSN + "habyui" + j;
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");

		fieldname = susunSN + "habyuipositon" + j;
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");
		    
		fieldname = susunSN + "habyuidate" + j;
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");
		
		fieldname = susunSN + "habyuisign" + j;
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");
    }
    
    for(i=1;i<20;i++)
    {
		fieldname = susunSN + "habyuiopinion" + i;
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, "");
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
	if (HwpCtrl.CheckFieldExist(fieldname))
		HwpCtrl.SetFieldText(fieldname, "");
	
	fieldname = "recipients";
	if (HwpCtrl.CheckFieldExist(fieldname))
		HwpCtrl.SetFieldText(fieldname, "");
  }
  catch(e){alert("setClearSusinCellInfo()" + e.description);}
}


function putJunkyulSign(signID)
{
	if (HwpCtrl.CheckFieldExist(signID))
		
		HwpCtrl.SetFieldText(signID, strLangEtcAprType4);
}



function SendDraftMappingSign(ret)
{
  try{
	
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt;
	var sn = 1;

	signCnt = 0;
	
	var PositionText = "";
	PositionText = getOpinionCount();
	
	if(LastSignSN == 1) 
	{
		
		if(pDraftFlag == "SUSIN" ||  pDocState == "011")
		{	
			fieldname = pSusinSN + "sign" + sn;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");		
			
			fieldname = pSusinSN + "jikwe" + sn;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");		
		}
		else
		{			
			fieldname = "sign" + sn;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");		
		
			fieldname = "jikwe" + sn;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");		
		}
		
		sn = 1;
	}
	else if (DraftLastFlag)		
	{
		putJunkyulSign("sign" + sn);
		for(i=1;i<20;i++)
	  	{
	  		if(pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
	  		else signID = "sign" + i

			if (HwpCtrl.CheckFieldExist(signID))
				LastSignNo = i;
	  	}
		sn = LastSignNo;
	}

	if(pDraftFlag == "SUSIN" ||  pDocState == "011")
	{ 
		psigncell = pSusinSN + "sign" + sn;
		pseumyungcell = pSusinSN + "jikwe" + sn;
		pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
	}else{
		psigncell = "sign" + sn;
		pseumyungcell = "jikwe" + sn;
		pseumyungdatecell = "seumyungdate" + sn;
	}
	
	 
	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 
	
	var strimg;
	var SingFlag = true;
	


	if(ret != "NAME")
	{
		if (HwpCtrl.CheckFieldExist(psigncell))
		{
			
			HwpCtrl.SetFieldText(psigncell, "");	
			HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);
			
		}
	
	  	
	  	signInfo[signCnt] = psigncell;
	  	SignName[signCnt] = psigncell;
	  	SignType[signCnt] = "IMAGE";
		SignContent[signCnt] = ret;
	  	signCnt = signCnt + 1
	  	SingFlag = true;
	}
	else
	{
	  if (HwpCtrl.CheckFieldExist(psigncell))
	  {
	
            HwpCtrl.SetFieldText(psigncell, arr_userinfo[2]);	  	
	  		
	  		signInfo[signCnt] = psigncell;
	  		SignName[signCnt] = psigncell;
	  	    SignType[signCnt] = "TEXT";
		    SignContent[signCnt] = arr_userinfo[2];
	  		signCnt = signCnt + 1
	  		SingFlag = false; 
	  }
	}
	
    
	if (HwpCtrl.CheckFieldExist(pseumyungcell))
	{
		HwpCtrl.SetFieldText(pseumyungcell, arr_userinfo[3] + PositionText);		
		signInfo[signCnt] = pseumyungcell;
		SignName[signCnt] = pseumyungcell;
	  	SignType[signCnt] = "TEXT";
		SignContent[signCnt] = arr_userinfo[3] + PositionText;
		signCnt = signCnt + 1
	}

	
	if (HwpCtrl.CheckFieldExist(pseumyungdatecell))
	{
		HwpCtrl.SetFieldText(pseumyungdatecell, s);		
		signInfo[signCnt] = pseumyungdatecell;
		SignName[signCnt] = pseumyungdatecell;
	  	SignType[signCnt] = "TEXT";
		SignContent[signCnt] = s;
		signCnt = signCnt + 1
	}
	
    return signInfo;
  }catch(e){
    alert("SendDraftMappingSign(ret)" + e.description);
  }
}


function UndoSignInfo(signInfo)
{
  try{
	var cnt 
	if(signInfo)
	{
		for(cnt=0;cnt < signInfo.length;cnt++)
		{
			if (HwpCtrl.CheckFieldExist(signInfo[cnt]))
				HwpCtrl.SetFieldText(signInfo[cnt], "");
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

	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/createnewdoc.aspx", false);
	xmlhttp.send(xmlpara);
	
	if(xmlhttp.responseText == "False")
	{
		var pAlertContent = strLang344 + "<br> " + strLang345;
		OpenAlertUI(pAlertContent);
	}else{
		return xmlhttp.responseText;
	}
  }catch(e){
    alert(e.description);
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


function getDeptSymbol(DeptID, DeptName) {
var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getADInfos.do",
		data : {
			cn : DeptID,
			prop : "extensionAttribute6",
			cate  : "group"
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
	if (result == "") {
		return DeptName;
	} else {
		return getNodeText(GetChildNodes(loadXMLString(result).documentElement)[0]);
	}
}


function SetAutoPropertyValue()
{
  try{
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
  
	var FieldLists = HwpCtrl.GetFieldList();
	var Fields = FieldLists.split(";");
  
	
	for (i = 0 ; i < Fields.length ; i ++)
	{
		if(pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL")
		{
	  		switch (Fields[i])
	  		{
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
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(7)));
	  		  		break;
	  			case "address" :			   
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(6)));
	  		  		break;												
	  			case "telephone" :		  	
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(5)));
	  		  		break;												
	  			case "fax" :			      	
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(4)));
	  		  		break;												
	  			case "department" :		  	
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(2)));
	  		  		break;												
	  			case "parantdept" :      
	  				HwpCtrl.SetFieldText(Fields[i], arrDeptInfo[3]);
	  		  		break;
	  			case "seniorposition" :		
	  		  		break;												
	  			case "seniorname" :			 
	  		  		break;												
	  			case "charge" :				   
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(0)));
	  		  		break;
	  			case "position" :			   
	  				HwpCtrl.SetFieldText(Fields[i], arr_userinfo[3]);
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
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(3)));
		  		  	break;							
	  			case "deptname" :         
	  				HwpCtrl.SetFieldText(Fields[i], arr_userinfo[5]);
	  		  		break;
	  			case "seal" :           
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(3)) + strLang148);
		  		  	break;
	  			case "username" :        
	  				HwpCtrl.SetFieldText(Fields[i], arr_userinfo[2]);
		  		  	break;
	  			case "draftername" :      
	  				HwpCtrl.SetFieldText(Fields[i], arr_userinfo[2]);
		  		  	break;
	  			case "draftdate" :       
	  				HwpCtrl.SetFieldText(Fields[i], CurrentDate);
		  		  	break;
	  			case "receiptdate" :
	  				HwpCtrl.SetFieldText(Fields[i], CurrentDate);
		  		  	break;
	  			case "deptshortedname" :
	  				HwpCtrl.SetFieldText(Fields[i], DeptSymbol);
		  			break;
	  			case "receivername" :
	  				HwpCtrl.SetFieldText(Fields[i], arr_userinfo[2]);
		  			break;	
 			}	  	
	  	}
	  	else
	  	{
	  	    switch (field.FieldID)
	  	    {
	  	     	case pSusinSN + "receiptdate" :	
	  				HwpCtrl.SetFieldText(Fields[i], CurrentDate);
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
					SignInfo = HwpCtrl.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}
				else
				{
					SignInfo = HwpCtrl.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    }
	    else
	    {
			if(Fields[i].substr(0,5) == "jikwe")
			{
				if(SignInfoFlag)
				{
					SignInfo = HwpCtrl.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}
				else
				{
					SignInfo = HwpCtrl.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    }
	}
	pSuSinFlag = "N";

	
	
	if(pDraftFlag != "SUSIN" && pDocState != "011")
	{
		var RtnVal = HwpCtrl.CheckFieldExist("recipient");
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
	if(HwpCtrl.CheckFieldExist(fieldname))	
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

function makeOpinionList(OpinionXML)
{
	if (!HwpCtrl.CheckFieldExist("opinions"))
		return;

	var firstFlag = true;
	var NodeList = OpinionXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	if (NodeList.length > 0)
	{
		var strOpinion = " ";
		for (i=NodeList.length - 1; i>=0; i--)
		{
			
		    if (getNodeText(NodeList.item(i).childNodes(0)) == "일반의견")
			{
				if (firstFlag)
				{
					strOpinion = "[" +strLang27 +"\n";
					firstFlag = false;
				}
				strOpinion = strOpinion + "" + getNodeText(NodeList.item(i).childNodes(2)) + "      "; 
				strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(1)) + "      "; 
				strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(6)) + "\n"; 
			}
				
		}		
		HwpCtrl.SetFieldText("opinions", strOpinion);
	}
	else
	{
		HwpCtrl.SetFieldText("opinions", "");
	}
}

function getOpinionCount()
{
	
	return "";
	
}


function SaveDraftDocInfo()
{
	var rtnVal;
	
	
	rtnVal = SaveFile();
    if (rtnVal != "TRUE")
	{
		return rtnVal;
	}
	
	SignSave();
	
	switch (pDraftFlag)
	{
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

	if (rtnVal.toUpperCase() != "TRUE")
	{
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
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);

	if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
	    createNodeAndInsertText(xmlpara, objNode, "OrgDocID", pOrgDocID);
	    createNodeAndInsertText(xmlpara, objNode, "DocType", pDocType);
	    createNodeAndInsertText(xmlpara, objNode, "DocState", pDocState);
	}
	else {
	    createNodeAndInsertText(xmlpara, objNode, "OrgDocID", "");
	    createNodeAndInsertText(xmlpara, objNode, "DocType", "");
	    createNodeAndInsertText(xmlpara, objNode, "DocState", "");
	}

	createNodeAndInsertText(xmlpara, objNode, "FunctionType", "002");
	createNodeAndInsertText(xmlpara, objNode, "Href", "/document/doc/" + pDocID + ".hwp");




	if (HwpCtrl.CheckFieldExist("doctitle"))
	    createNodeAndInsertText(xmlpara, objNode, "DocTitle", HwpCtrl.GetFieldText("doctitle"));
	else
	    createNodeAndInsertText(xmlpara, objNode, "DocTitle", "");



	var field = "";
	if (HwpCtrl.CheckFieldExist("docnumber"))
	    field = HwpCtrl.GetFieldText("docnumber");
	else if (HwpCtrl.CheckFieldExist("be_docnumber"))
	    field = HwpCtrl.GetFieldText("be_docnumber");
	else if (HwpCtrl.CheckFieldExist("deptshortedname"))
	    field = HwpCtrl.GetFieldText("deptshortedname");
	else
	    field = "";

	createNodeAndInsertText(xmlpara, objNode, "DocNo", field);


	createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);
	createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", pHasOpinionYN);

	var startdate;
	if (pState == "000")
	    startdate = "DRAFTSAVE";
	else
	    startdate = "DRAFT";
	createNodeAndInsertText(xmlpara, objNode, "StartDate", startdate);
	createNodeAndInsertText(xmlpara, objNode, "EndDate", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "WriterID", "");
	createNodeAndInsertText(xmlpara, objNode, "WriterName", "");
	createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", "");
	createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", "");
	createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", "");
	createNodeAndInsertText(xmlpara, objNode, "Html", "");
	createNodeAndInsertText(xmlpara, objNode, "OrgHtml", "");
	createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[2]);
	createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

	createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);

	createNodeAndInsertText(xmlpara, objNode, "public", "");
	createNodeAndInsertText(xmlpara, objNode, "ItemCode", tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ItemName", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "UrgentApproval", tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KeyWord", tempKeyword);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", "");
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);




	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezViewHWP/aspx/dodraft_HWP.aspx", false);
	xmlhttp.send(xmlpara);

	SetBtnStateFalse();
	return getNodeText(loadXMLString(xmlhttp.responseText));
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

	if (HwpCtrl.CheckFieldExist("doctitle"))
	    createNodeAndInsertText(xmlpara, objNode, "DocTitle", HwpCtrl.GetFieldText("doctitle"));
	else
	    createNodeAndInsertText(xmlpara, objNode, "DocTitle", "");

	if (HwpCtrl.CheckFieldExist("docnumber"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", HwpCtrl.GetFieldText("docnumber"));
	else if (HwpCtrl.CheckFieldExist("be_docnumber"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", HwpCtrl.GetFieldText("be_docnumber"));
	else if (HwpCtrl.CheckFieldExist("deptshortedname"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", HwpCtrl.GetFieldText("deptshortedname"));
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

	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezViewHWP/aspx/dodraft_HWP.aspx", false);
	xmlhttp.send(xmlpara);
	  		
	SetBtnStateFalse();
	return getNodeText(loadXMLString(xmlhttp.responseText));
  }catch(e){
    alert(e.description);
  }
}


function openSignUI()
{
  try{
    var objRoot;
    var objNode;
    var SignNodeList;
    
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
  
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
  
    xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/GetSignRequest.aspx", false);
    xmlhttp.send(xmlpara);
  
    SignNodeList = loadXMLString(xmlhttp.responseText).selectNodes("LISTVIEWDATA/ROWS/ROW"); 
    if(SignNodeList.length != 0)
    { 
		var parameter	= pUserID;
		var url = "/myoffice/ezApprovalG/ezAPRSIGN/AprSign1_Cross.aspx";
		var feature	= "status:no;dialogWidth:350px;dialogHeight:320px;help:no;scroll:no;edge:sunken";
	    var ret = window.showModalDialog(url,parameter,feature);
    }else{
		var ret = "NAME";
    }
	return ret;
  }catch(e){
    alert("openSignUI : " + e.description);
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
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pOrgDocID", pOrgDocID);
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

	xmlhttp.open("POST","/myOffice/ezApprovalG/DraftUI/aspx/setSusinUpdateDocID.aspx",false);
	xmlhttp.send(xmlpara);

	return xmlhttp.responseText;

  }catch(e){
    alert(e.description);
  }
}

function OpenInformationUI(pInformationContent) {
	var parameter = pInformationContent;
	var url = "/myoffice/ezApprovalG/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
	return RtnVal;
}

function OpenAlertUI(pAlertContent) {
	var parameter	= pAlertContent;
	var url = "/ezApprovalG/ezAprAlert.do";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal		= window.showModalDialog(url,parameter,feature);
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
	btnAssign.Enable = "false";
	btnDistribute.Enable = "false";
	btnReturn.Enable = "false";
	btnAproveSusin.Enable = "false";
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
   	 		if (xmlhttp.statusText == "OK") {
   	 			var pAlertContent = strLang878;
   	 			OpenAlertUI(pAlertContent, "", "OPEN");
   	 		} else {
   	 			var pAlertContent = strLang740;
   	 			OpenAlertUI(pAlertContent, "", "OPEN");
   	 			return;
   	 		}
        } 
    } catch(e){
    	alert("setHeSongDocInfo :: " + e.description);
    }
}

function chk_Passwd()
{
	var parameter = pUserID;
	var url		= "/myoffice/ezApprovalG/ezchkPasswd.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret = window.showModalDialog(url,parameter,feature);
		
	
		
	return ret;
}

function getLastOpinon()
{
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	
	xmlhttp.open("Post", "/myoffice/ezApprovalG/ReceivUI/aspx/getLastOpinonCotent.aspx", false);
	xmlhttp.send(xmlpara);	
	
	if (loadXMLString(xmlhttp.responseText).documentElement.childNodes.length > 0 )
	{
	    var content = getNodeText(loadXMLString(xmlhttp.responseText).documentElement.childNodes(0));		
	}	

	if (HwpCtrl.CheckFieldExist("memo"))
		HwpCtrl.SetFieldText("memo", content);
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
		
	if(!HwpCtrl.CheckFieldExist(pPrefix + "docnumber"))		
		return 




	
	var fieldValue = HwpCtrl.GetFieldText(pPrefix + "docnumber");
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
				numHeader = numHeader + d.getYear() + Tail 
				break;

			case "yy":
				var yyear = d.getYear()
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
			
	HwpCtrl.SetFieldText(pPrefix + "docnumber", numHeader);
	if(numHeader.indexOf(strLang107) > 0) 
		HwpCtrl.SetDocumentInfo("NULL", "NULL", numHeader);
}



function SaveFile()
{

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();


    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));

		
	xmlhttp.open("POST","aspx/SaveFileHWP.aspx",false);
	xmlhttp.send(xmlpara);
		
	return xmlhttp.responseText;
}

function SaveOrgFile()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "Html", pOrgHtml);

		
	xmlhttp.open("POST","aspx/SaveFileHWP.aspx",false);
	xmlhttp.send(xmlpara);
		
	return xmlhttp.responseText;
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
		}
		xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/setSignInfo.aspx", false);
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

	
	if (HwpCtrl.CheckFieldExist("hrecipients"))
		HwpCtrl.SetFieldText("hrecipients", "");
	
	if (HwpCtrl.CheckFieldExist("recipient"))
	{
		HwpCtrl.SetFieldText("recipient", "");
	}

	if (HwpCtrl.CheckFieldExist("recipients"))
		HwpCtrl.SetFieldText("recipients", "");

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
	
	
	
		
	
	if (HwpCtrl.CheckFieldExist("recipient"))
	{
		if(precipent == strLang68)
		{
			HwpCtrl.SetFieldText("recipient", precipent);		
			
			if (HwpCtrl.CheckFieldExist("recipients"))
				HwpCtrl.SetFieldText("recipients", precipents);		

			if (HwpCtrl.CheckFieldExist("hrecipients"))
				HwpCtrl.SetFieldText("hrecipients", strLang70);		
		}
		else
		{
			HwpCtrl.SetFieldText("recipient", precipent);		
		
			if(precipents == "")
			{			
				if (HwpCtrl.CheckFieldExist("recipients"))
					HwpCtrl.SetFieldText("recipients", "");		

				if (HwpCtrl.CheckFieldExist("hrecipients"))
					HwpCtrl.SetFieldText("hrecipients", "");		
			}
		}	
	}
	else if (HwpCtrl.CheckFieldExist("recipients"))
		HwpCtrl.SetFieldText("recipients", precipents);
}


function UpdateLineHistory()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
	createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
	createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
	createNodeAndInsertText(xmlpara, objNode, "chkFlag", "MUST");
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[14]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", arr_userinfo[16]);
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPRHISTORY/aspx/UpdateLineHistory.aspx", false);
	xmlhttp.send(xmlpara);
	
	if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE")
	{
	}
	else
	{
		var pAlertContent = strLang720;
    	OpenAlertUI(pAlertContent);
	}	
}