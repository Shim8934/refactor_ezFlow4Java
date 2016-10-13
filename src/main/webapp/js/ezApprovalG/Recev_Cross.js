//sign 정보를 가지고 온다!
var lastKyulName, lastKyuljiwee, LastSignSN;
var DraftLastFlag = false;

//결재선정보 Mapping하는 함수
function GetDraftAprLineInfo(ret)
{
  try{
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
	
	var xmldom = createXmlDom();

	if (ret[5] == undefined) {
	    xmlKuljea = ret[0];
	    xmlReDraft = ret[2];
	}
	else {
	    xmlKuljea = ret[1];
	    xmlReDraft = ret[5];
	}

	xmlReDraft = "R";
	if(xmlReDraft == "C")
	{
		ApplyDocCellInfo();
	}else if(xmlReDraft == "R"){
		ClearDocCellInfo();
	}

	xmldom = loadXMLString(xmlKuljea);
	
	objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
	fields = message.GetFieldsList();
	count = objNodes.length;

	for(i=1;i<200;i++)
	{
		name = "habyuidate" + i;
		field = message.GetListItem(fields,name);
		if(field)
	  	{
	  		if(!trim(field.textContent))
	  		{
	  			name = "habyui" + i;
	  			field = message.GetListItem(fields,name);
	  			if(field)
	  				field.textContent = "";
	  			
	  			fieldname = "habyuisign" + i;
	  		    field = message.GetListItem(fields,fieldname);
	  		    if(field)
	  				field.textContent = "";
	  		    
	  		    fieldname = "habyuipositon" + i;
	  		    field = message.GetListItem(fields, fieldname);
	  		    
	  		    if(field)
	  				field.textContent = "";
	  		}
		}else{
	  		break;
	  	}
	}
	
	//공람(참석)
	for(i=1;i < fields.Count;i++)
	{
		field = message.GetListItem(fields, "gongram" + i);
		if(field) field.textContent = "";
	}
	
    //순서를 정리한다.	
	for(i=0;i < count;i++)
	{
	    var KyljeaOrder     = getNodeText(GetChildNodes(objNodes[i])[0]);
	    var KyljeaName      = getNodeText(GetChildNodes(objNodes[i])[1]);
	    var KyljeaDeptName  = getNodeText(GetChildNodes(objNodes[i])[3]);
	     
	    //-------------------------------------------------------------
	    var KyljeaType      = getNodeText(GetChildNodes(objNodes[i])[16]);
	    var KyljeaTypeName  = getNodeText(GetChildNodes(objNodes[i])[4]);
	    var KyljeaStat      = getNodeText(GetChildNodes(objNodes[i])[17]);
	    var KyljeaStatName  = getNodeText(GetChildNodes(objNodes[i])[5]);
	    //-------------------------------------------------------------
	    var KyljeaJobtitle      = getNodeText(GetChildNodes(objNodes[i])[2]);
	    var ReasonDoNotApprov   = getNodeText(GetChildNodes(objNodes[i])[12]);

	    OrderType[KyljeaOrder] = KyljeaType;
	     
	    OrderTypeName[KyljeaOrder] = KyljeaTypeName;
	    OrderName[KyljeaOrder] = KyljeaName;
	    OrderDept[KyljeaOrder] = KyljeaDeptName;
	    OrderStat[KyljeaOrder] = KyljeaStat;     
	     
	    OrderStatName[KyljeaOrder] = KyljeaStatName;
	    OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
	    OrderReason[KyljeaOrder] = ReasonDoNotApprov;
	}
     
    //마지막사인Index
    LastSignSN = OrderType.length;
    for(i=1;i<OrderType.length;i++)
    {
		 
    	if(OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40)    	
    	{
    		LastSignSN = i;
        }	
    }

	 
    if (OrderType[1] == strAprType4)
    {
		DraftLastFlag = true;
    }
     
	//마지막 결재권자를 설정한다.
	var field = message.GetListItem(fields, "lastKyulName");	

	if(field)
		field.textContent  = OrderName[LastSignSN];
    
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
			
	  	   	 
	  		case strAprType1:
	  			break;
	  			
	  		 
	  		case strAprType2:
	  			//기안자확인
	  			if ((OrderName[i] == arr_userinfo[2]) && (i == 1)) IsSkipDrafter = "TRUE";
	  		  	break;	
	  		
	  		case strAprType11:   //strLang51:  <== 2011.03.09  합의type이여야함. 
	  			//재기안결재선변경
	  			//R : 다시시작 
	  			//C:계속진행
	  			if(xmlReDraft == "R")
	  			{
		  		    fieldname = "habyui" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field)
	  					field.textContent = OrderDept[i];
	  		    
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field)
	  					field.textContent = OrderName[i];
	  		    
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field)
	  				field.textContent = OrderJobtitle[i];
	  			}
	  			else if(xmlReDraft == "C")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field && OrderStat[i] != strLang26)
	  					field.textContent = OrderDept[i];
	  		    
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field && OrderStat[i] != strLang26)
	  					field.textContent = OrderName[i];
	  		    
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field && OrderStat[i] != strLang26)
	  					field.Value = OrderJobtitle[i];
	  				IsSkipDrafter = "TRUE";
	  			}
	  			else
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field)
	  					field.textContent = OrderDept[i];
	  		    
	  				fieldname = "habyuisign" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field)
	  					field.textContent = OrderName[i];
	  		    
	  				fieldname = "habyuipositon" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field)
	  					field.textContent = OrderJobtitle[i];
	  			}
	  			hapyuiCnt = hapyuiCnt + 1;
	  			break;		
	  		  		
	  		 
	  		case strAprType8:
	  			//재기안결재선변경   	  			//R : 다시시작 	//C:계속진행
	  			if(xmlReDraft == "R")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if(field)
	  					field.textContent = OrderDept[i];
	  				IsSkipDrafter = "FALSE";
	  			}
	  			else if(xmlReDraft == "C")
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if (field && OrderStat[i] != "" + strLang57 + "")
	  				{
	  				}
	  				IsSkipDrafter = "TRUE"; 
	  			}
	  			else
	  			{
	  				fieldname = "habyui" + hapyuiCnt;
	  				field = message.GetListItem(fields, fieldname);
	  				
	  				if (field)
	  					field.textContent = OrderDept[i]; 
	  			}
	  			hapyuiCnt = hapyuiCnt + 1;
	  			break;
	  		
	  		  	
	  		case strAprType7:
	  			if (referCnt == 1)
	  			{
	  				refer = "";			
	  				refer = refer + OrderName[i];
	  				referCnt = referCnt + 1;
	  			}else{
	  				refer = refer + ", "  + OrderName[i];
	  			}
	  			break;
	  			
	  		case strAprType17:   //strLang61:  <== 2011.03.09 공람에 해당하는 APRTYPE(A030177)값 매핑
	  			fieldname = "gongram" + gongramCnt;
	  			field = message.GetListItem(fields, fieldname);
	  			
	  			if(field)
	  			{
	  				field.textContent = OrderName[i] + " " + OrderJobtitle[i] + " " + OrderDept[i];
	  				gongramCnt = gongramCnt + 1;
	  			}
	  			break;
	  	}
	}

	if(refer != "")
	{
	  	fieldname = "refer";
	  	field = message.GetListItem(fields, fieldname);
	  	
	  	if (field)
	  		field.Value = refer;
	}

	//직위정보
	var susinSN = "";
	 
	if(pDraftFlag == "SUSIN" || pDocState == strDocState11 || pDraftFlag == "GAMSABU")
	  	susinSN = pSusinSN;
	
	//기존직위정보삭제.(일반직위, 합의직위)
	for(i=1;i < 20;i++)
	{
	  	fieldname = susinSN + "jikwe" + i;
	  	field = message.GetListItem(fields, fieldname);
	
		if(field)
	  		field.textContent = " ";//CKEDITOR-원본 : field.Value = " ";
	  	else
	  		break;
	}
	
	for(i=1;i < 20;i ++)
	{
	  	fieldname =  "hjkwe" + i;
	  	field = message.GetListItem(fields, fieldname);
	  	if(field)
	  		field.textContent = " ";//CKEDITOR-원본 : field.Value = " ";
	  	else
	  		break;
	}

	var idx = 1;
	var hidx = 1;
	//var Flag = "";
	//표준모듈 (2007.05.09) : 다국어 (A02011 -> strDocState11)
	//if(pDraftFlag == "SUSIN" || pDocState == strDocState11 ) 
	//{
	//  	susinSN = pSusinSN; 
	//  	Flag = susinSN + "Recv"; 
	//}

	for(i=1;i < OrderJobtitle.length;i ++)
	{
	    if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3)
	  	{
//	  		if(LastSignSN == 1 ||  LastSignSN == i ) 
//			{
//			    //// 2012.01.31 프로세스 디자인 추가 관련
//                //field = message.GetListItem(fields, Flag + "AprLine");
//	  		    //var cnt = 20;
//	  		    //if (field)
//	  		    //    cnt = OrderType.length;
//	  		        
//				for(k=1;k<10;k++)
//				{
//				    //if(pDraftFlag == "SUSIN" || pDraftFlag == "GAMSABU") 
//				    if (pDraftFlag == "SUSIN")
//						signID = pSusinSN + "sign" + k;
//					else 
//						signID = "sign" + k;
//	    	
//					field = message.GetListItem(fields, signID);//CKEDITOR-원본 : field = fields.Item(signID)
//					if(field)
//						LastSignNo = k;
//				}
//				idx = LastSignNo;
//			}
	  		var j, chkflag;
	  		 
	  		if(OrderType[i] == strAprType3)
	  		{
	  			chkflag = false;
	  			for(j=1;j < i;j++)
	  			{
	  				if(OrderType[j] == strAprType4)
	  				{
	  					chkflag = true;
	  					break;   
	  				}
	  			}
	  			if(!chkflag)
	  			{
	  				fieldname = susinSN + "jikwe" + idx;
	  				field = message.GetListItem(fields, fieldname);
	  				if(field)
	  					field.textContent  = OrderJobtitle[i];//CKEDITOR-원본 : field.Value = OrderJobtitle[i];
		  				  			
	  				fieldname = susinSN + "sign" + idx;
	  				field = message.GetListItem(fields, fieldname);
	  				if(field)
	  					field.innerHTML  = OrderName[i] + "<br>" + OrderReason[i];//CKEDITOR-원본 : field.TagObject.innerHTML = OrderName[i] + "<br>" + OrderReason[i];
		  				  			
	  				idx = idx + 1;
	  				continue;
	  			}
	  		}
	  		fieldname = susinSN + "jikwe" + idx;
	  		field = message.GetListItem(fields, fieldname);
	  		if(field)
	  			field.textContent = OrderJobtitle[i];
		  	
	  		fieldname = susinSN + "sign" + idx;
	  		field = message.GetListItem(fields, fieldname);
	  		if(field)
	  		{
	  			field.textContent  = OrderName[i];//CKEDITOR-원본 : field.Value = OrderName[i];
	  			idx = idx + 1;
	  		}
	  	}
	  	
	  	 
	  	if(OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12 )
	  	{
	  		fieldname =  "hjikwe" + hidx;
	  		field = message.GetListItem(fields, fieldname);
	  		if(field)
	  		{
	  			field.textContent  = OrderJobtitle[i];//CKEDITOR-원본 : field.Value = OrderJobtitle[i];
	  			hidx = hidx + 1;
	  		}			
	  	}	
	}
	
	//setSignSlash("sign", susinSN);

  }catch(e){
    alert("GetDraftAprLineInfo : " + e.description);
  }	
}

//재기안 셀정보를 Clear
function ClearDocCellInfo()
{
  try{
    var i;
    var j;
    var k;
    var fieldname;
    var susunSN = "";
	
	if(pDraftFlag == "SUSIN" || pDocState == strDocState11 || pDraftFlag == "GAMSABU") 
	{
		susunSN = pSusinSN;
		//2012.02.08 프로세스 디자이너
		fieldname = pSusinSN + "RecvAprLine";
        field = message.GetListItem(fieldname);
        if(field)
	        AprLineArea = 1;
	        
	    fieldname = pSusinSN + "AprHapuiLine";
	    field = message.GetListItem(fieldname);
	    if(field)
		    HapyuiArea = 1;
	}
	else
	{
	
	    fieldname = "AprLine";
        field = message.GetListItem(fieldname);
        if(field)
	        AprLineArea = 1;
	        
	    fieldname = "AprHapuiLine";
	    field = message.GetListItem(fieldname);
	    if(field)
		    HapyuiArea = 1;
	}
		  
    for(i = 1; i <= SignCount ; i++)
    {
		fieldname = susunSN + "sign" + i;
	  	field = message.GetListItem(fields, fieldname);
	  	if(field)
	  	    field.innerHTML = "&nbsp";//CKEDITOR-원본 : field.value = " ";
	  		    
	  	fieldname = susunSN + "jikwe" + i;
	  	field = message.GetListItem(fields, fieldname);
	  	if(field)
	  	    field.innerHTML = "&nbsp";//CKEDITOR-원본 : field.value = " ";
	  		    
		fieldname = susunSN + "seumyungdate" + i;
	  	field = message.GetListItem(fields, fieldname);
	  	if(field)
	  	    field.innerHTML = "&nbsp";//CKEDITOR-원본 : field.value = " ";
      
		fieldname = susunSN + "jikwe" + i;
	  	field = message.GetListItem(fields, fieldname);
	  	if(field)
	  	    field.innerHTML = "&nbsp";//CKEDITOR-원본 : field.value = " ";
    }
  
    for(j = 1 ; j <= hapyuiCount ; j++)
    {
		fieldname = susunSN + "habyui" + j;
	  	field = message.GetListItem(fields, fieldname);
	  	if(field)
	  	    field.innerHTML = "&nbsp";//CKEDITOR-원본 : field.value = " ";
      
	  	fieldname =  susunSN + "habyuidate" + j;
	  	field = message.GetListItem(fields, fieldname);
	  	if(field)
	  	    field.innerHTML = "&nbsp";//CKEDITOR-원본 : field.value = " ";
       
		fieldname = susunSN + "habyuisign" + j;
	  	field = message.GetListItem(fields, fieldname);
	  	if(field)
	  	    field.innerHTML = "&nbsp";//CKEDITOR-원본 : field.value = " ";
    }
  }catch(e){
  }
}

//수신처,수신처 참조 Cell정보 Clear 함수
function setClearSusinCellInfo()
{
  try{
	var fieldname;
	var fields = message.GetFieldsList();
	fieldname = "recipient";
	field = message.GetListItem(fields, fieldname);
	
	if(field)
	    field.textContent = " ";//CKEDITOR-원본 : field.Value = " ";
	
	fieldname = "recipients";
	field = message.GetListItem(fields, fieldname);
	
	if(field)
	    field.textContent = " ";//CKEDITOR-원본 : field.Value = " ";  
  }catch(e){
    alert("setClearSusinCellInfo : " + e.description);
  }
}

//재기안 결재자 결재선 진행 적용
function ApplyDocCellInfo()
{
  try{
    var i;
    var j;
    var k;
    var fieldname;
	var fieldvalue;
	var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
	  
    for(j = 1 ; j <= hapyuiCount ; j++)
    {
		fieldname = "habyuidate" + j;
	  	field = message.GetListItem(fields, fieldname);
	  	
	    if(field)
	    {
			fieldvalue = field.textContent;//CKEDITOR-원본 : fieldvalue = field.value;
			fieldvalue = trim(fieldvalue);
	  		if(fieldvalue == "")
	  		{
	  			fieldname = "habyui" + j;
	  			field = message.GetListItem(fields, fieldname);
	  			
	  			if(field)
	  				field.textContent = " ";//CKEDITOR-원본 : field.value = "";
			}
		} 
    }
  }catch(e){
    alert("ApplyDocCellInfo : " + e.description);
  }
}

// 전결처리 한다.
function putJunkyulSign(signID)
{
	var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
	var field = message.GetListItem(fields, signID);//CKEDITOR-원본 : var field = fields.Item(signID);
	if(field)
	{
		 
	  	var strimg = "<span style='fontSize:12pt;fontWeight:bolder;color:blue'>" + strLangEtcAprType4 + "</span>";
	  	field.innerHTML = strimg;//CKEDITOR-원본 : field.TagObject.innerHTML = strimg;
	}
}

//사인 Mapping 처리 Spec 적용 
function SendDraftMappingSign(ret)
{
  try{
	var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
	var field;
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt;
	var signposition = "1";
	signCnt = 0;
	//var positiontext = "";
	//positiontext = getopinioncount();

	if ( LastSignSN == "1") 
		signposition = 1;
	else if (DraftLastFlag)		
	{
		putJunkyulSign("sign" + signposition);
		for(i=1;i<20;i++)
	  	{
	  		if(pDraftFlag == "SUSIN") signID = "sign" + i;
	  		else signID = "sign" + i;

	  		field = message.GetListItem(fields, signID);//CKEDITOR-원본 : field = fields.Item(signID)
	  		if(field){
	  			LastSignNo = i;
	  		}
	  	}
		signposition = LastSignNo;
	}
	
	 
	if(pDraftFlag == "SUSIN" ||  pDocState == strDocState11 || pDraftFlag == "GAMSABU")  
	{ 
		psigncell = pSusinSN + "sign" + signposition;
		pseumyungcell = pSusinSN + "jikwe" + signposition;
		pseumyungdatecell = pSusinSN + "seumyungdate" + signposition;
	}
	else
	{
	    psigncell = "sign" + signposition;
	    pseumyungcell = "jikwe" + signposition;
	    pseumyungdatecell = "seumyungdate" + signposition;
	}
	
	//서명일자 
	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 	  

	var field = message.GetListItem(fields, psigncell);//CKEDITOR-원본 : field = fields.Item(psigncell);
	var signWidth	= parseInt(field.offsetWidth) - 4 - 15;//CKEDITOR-원본 :var signWidth	= parseInt(field.TagObject.offsetWidth) - 4 - 15; 
	var signHeight	= parseInt(field.offsetHeight) - 4;//CKEDITOR-원본 :var signHeight	= parseInt(field.TagObject.offsetHeight) - 4;
	var strimg;
	var SingFlag = true;
	 
	if(ret != "NAME")
	{
	    strimg = "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
	    strimg = strimg + " width=" + signWidth;
	    strimg = strimg + " height=" + signHeight + " spath='" + escape(ret) + "'>";
	  	field.innerHTML = strimg;//CKEDITOR-원본 : field.TagObject.innerHTML = strimg;
	
	  	//사인정보를 저장한다.(Undo용)
	  	signInfo[signCnt] = psigncell;
		SignType[signCnt] = "HTML";
		SignName[signCnt] = psigncell;
		SignContent[signCnt] = strimg;
	  	signCnt = signCnt + 1;
	  	SingFlag = true;
	}
	else
	{
	  	if(field)
	  	{
	  	    strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
	  		field.innerHTML = strimg;//CKEDITOR-원본 : field.TagObject.innerHTML = strimg
		  
	  		//사인정보를 저장한다.(Undo용)
	  		signInfo[signCnt] = psigncell;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = psigncell;
			SignContent[signCnt] = strimg;
	  		signCnt = signCnt + 1;
	  		SingFlag = false; 
	  	}
	}
    //서명정보를 display해주는 function
	field = message.GetListItem(fields, pseumyungcell);//CKEDITOR-원본 : field = fields.item(pseumyungcell);
	if(SingFlag)
	{
	  	if(field)
	  	{
	  		setNodeText(field , arr_userinfo[3]);
	  		//사인정보를 저장한다.(Undo용)
	  		signInfo[signCnt] = pseumyungcell;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = pseumyungcell;
			SignContent[signCnt] = arr_userinfo[3];
	  		signCnt = signCnt + 1;
	  	}
	}
	else
	{
	  	if(field)
	  	{
	  		setNodeText(field , arr_userinfo[3]);
	  		//사인정보를 저장한다.(Undo용)
	  		signInfo[signCnt] = pseumyungcell;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = pseumyungcell;
			SignContent[signCnt] = arr_userinfo[3];
	  		signCnt = signCnt + 1;
	  	}
	}
  
	//서명일자
	field = message.GetListItem(fields, pseumyungdatecell);//CKEDITOR-원본 : field = fields.item(pseumyungdatecell)
	if(field)
	{
		setNodeText(field , s);
		//사인정보를 저장한다.(Undo용)
		signInfo[signCnt] = pseumyungdatecell;
		SignType[signCnt] = "TEXT";
		SignName[signCnt] = pseumyungdatecell;
		SignContent[signCnt] = s;
		signCnt = signCnt + 1;
	}
    return signInfo;
  }catch(e){
    alert("SendDraftMappingSign : " + e.description);
  }
}

//사인정보 UNDO
function UndoSignInfo(signInfo)
{
  try{
	var cnt;
	var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
	var field;

	if(signInfo)
	{
	  	for(cnt=0;cnt < signInfo.length;cnt++)
	  	{
	  		field = message.GetListItem(fields, signInfo[cnt]);//CKEDITOR-원본 : field = fields.item(signInfo[cnt])
	  		if(field)
	  			setNodeText(field, "");
	  	}
	}
  }catch(e){
    alert("UndoSignInfo : " + e.description);
  }
}

//버튼 상태 변경함수
function SetBtnStateFalse()
{
  try{
    document.getElementById('btnSetAprLine').Enable	= "false";
	document.getElementById('btnSendDraft').Enable		= "false";
	document.getElementById('btnOpinion').Enable		= "false";  
  }catch(e){
    alert("SetBtnStateFalse : " + e.description);
  }
}

//버튼 상태 변경함수
function SetBtnStateTrue()
{
  try{
  	document.getElementById('btnSetAprLine').Enable	= "true";
  	document.getElementById('btnSendDraft').Enable		= "true";
	document.getElementById('btnOpinion').Enable		= "true";
	document.getElementById('btnClose').Enable			= "true";		
	document.getElementById('btnPrint').Enable			= "true";
  }catch(e){
    alert("SetBtnStateTrue : " + e.description);
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
	
	xmlhttp.open("POST","/ezApprovalG/createNewDoc.do",false);
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
//기안자정보를 가져오는 함수 
function getDraftUserInfo()
{
  try{
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
  	
	// 0 : UserName, 1 : MailID, 2 : DeptName, 3 : CompanyName, 4 : FAX, 5 : tel, 6 : addr, 7 : post
  }catch(e){
	alert("getDraftUserInfo()" + e.description);
  }
}

function getDeptSymbol(DeptID, DeptName)
{
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
	
	if (result == "")
	{
		return DeptName;
	}
	else
	{
		return getNodeText(GetChildNodes(loadXMLString(result).documentElement)[0]);
	}
}

//자동입력Field에 값을 입력하는 함수
function SetAutoPropertyValue()
{
  try{
    //var fields = FormProc.Fields;
    var fields = message.GetFieldsList();
    if(!fields) return;
  
	var fieldname;
	var field;
	var pSusinNextSN;
	var objNodes;
	var CurrentDate;
	objNodes = GetChildNodes(xmluserInfo.documentElement);
	
	//서명일자
    CurrentDate = getGyulJeDate();
    SignInfo = "";
    hapyuiCount = 0;
    SignCount = 0;
  
	for (i = 0 ; i < fields.length ; i ++)
	{
		var field = fields[i];
		if(!fields) return;
	
		if(pDraftFlag == "HAPYUI" || (pDraftFlag == "GAMSABU" && ConvertYN == "Y") || pDraftFlag == "WHOKYUL")
		{
	  		switch (field.id)
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
	  		  		field.textContent = getNodeText(objNodes[7]);
	  		  		break;
	  			case "address" :			   
	  		  		field.textContent = getNodeText(objNodes[6]);
	  		  		break;												
	  			case "telephone" :		  	
	  		  		field.textContent = getNodeText(objNodes[5]);
	  		  		break;												
	  			case "fax" :			      	
	  		  		field.textContent = getNodeText(objNodes[4]);
	  		  		break;												
	  			case "department" :		  
	  		  		field.textContent = getNodeText(objNodes[2]);
	  		  		break;												
	  			case "parantdept" :     
	  		  		field.textContent = arrDeptInfo[3];//CKEDITOR-원본 : field.Value = arrDeptInfo[3];
	  		  		break;
	  			case "seniorposition" :		
	  		  		break;												
	  			case "seniorname" :			 
	  		  		break;												
	  			case "charge" :				    
	  		  		field.textContent = getNodeText(objNodes[0]);
	  		  		break;
	  			case "position" :			    
		  		  	field.textContent = arr_userinfo[3];//CKEDITOR-원본 : field.Value = arr_userinfo[3];
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
		  		  	field.textContent = getNodeText(objNodes[3]);
		  		  	break;							
	  			case "deptname" :         
	  		  		field.textContent = arr_userinfo[5];//CKEDITOR-원본 : field.Value = arr_userinfo[5];
	  		  		break;
	  			case "seal" :           
		  		  	field.textContent = getNodeText(objNodes[3]); + strLang148;
		  		  	break;
	  			case "username" :        
		  		  	field.textContent = arr_userinfo[2];//CKEDITOR-원본 : field.Value = arr_userinfo[2];
		  		  	break;
	  			case "draftername" :      
		  		  	field.textContent = arr_userinfo[2];//CKEDITOR-원본 : field.Value = arr_userinfo[2];
		  		  	break;
	  			case "draftdate" :        
		  		  	field.textContent = CurrentDate;//CKEDITOR-원본 : field.Value = CurrentDate;
		  		  	break;
	  			case "receiptdate" :
		  		  	field.textContent = CurrentDate;//CKEDITOR-원본 : field.Value = CurrentDate;
		  		  	break;
	  			case "deptshortedname" :
		  			field.textContent = DeptSymbol;//CKEDITOR-원본 : field.Value = DeptSymbol;
		  			break;
	  			case "receivername" :
		  			field.textContent = arr_userinfo[2];//CKEDITOR-원본 : field.Value = arr_userinfo[2];
		  			break;	
 			}	  	
	  	}
	  	else
	  	{
	  	    switch (field.id)
	  	    {
	  	     	case pSusinSN + "receiptdate" :	 
	  				field.textContent = CurrentDate;//CKEDITOR-원본 : field.Value = CurrentDate;
	  				break;
	  	    }	
	  	}
	  	
	  	//일반결재
	  	if(pDraftFlag == "SUSIN" ||  pDocState == strDocState11 || pDraftFlag == "GAMSABU")
	  	{
	  		var pSignSusin = pSusinSN + "sign";
	  		if (field.id.substr(0, pSignSusin.length) == pSignSusin)
	  	  		SignCount = SignCount + 1;
	  	}
	  	else
	  	{
	  		if (field.id.substr(0, 4) == "sign")
	  	  		SignCount = SignCount + 1;
	  	} 
      
		//합의
	    if (field.id.substr(0, 10) == "habyuidate")
	    {
	    	hapyuiCount = hapyuiCount + 1;
	    }
	    
	    //공람칸
	    if (field.id.substr(0, 7) == "gongram")
	    {
	    	gongramCount = gongramCount + 1;
	    }
	  	
	    //직위정보
	    if(pDraftFlag == "SUSIN" || pSusinSN != "0" || pDraftFlag == "GAMSABU")
	    {
			var pSignInfoSusin = pSusinSN + "jikwe";
			if(field.id.substr(0,pSignInfoSusin.length) == pSignInfoSusin)
			{
				if(SignInfoFlag)
				{
					SignInfo = field.textContent;//CKEDITOR-원본 : SignInfo = field.value;
					SignInfoFlag = false;
				}
				else
				{
					SignInfo = field.textContent + ";" + SignInfo ;//CKEDITOR-원본 : SignInfo = field.value + ";" + SignInfo ;
				}
			}
	    }
	    else
	    {
			if(field.id.substr(0,5) == "jikwe")
			{
				if(SignInfoFlag)
				{
					SignInfo = field.textContent;
					SignInfoFlag = false;
				}
				else
				{
					SignInfo = field.textContent + ";" + SignInfo ;
				}
			}
	    }
	}
	pSuSinFlag = "N";

	//수신셀
	 
	if(pDraftFlag != "SUSIN" && pDocState != strDocState11 )
	{
	    var RtnVal = message.GetListItem(fields, 'recipient');
		if(RtnVal != null)
	    	pSuSinFlag = "Y";
		else
	    	pSuSinFlag = "N";
	}

	//수발신수신셀정보
	if (pSusinSN == "gamsa")
		pSusinNextSN = 1;
	else if(pSusinSN)
		pSusinNextSN = parseInt(pSusinSN) + 1;
	else
		pSusinNextSN = 1;
	
	fieldname = pSusinNextSN + "sign1";
	field = message.GetListItem(fields, fieldname);
	
	if(field)
		pSuSinFlag = "Y";

	//참조셀
	RtnVal = message.GetListItem(fields, 'refer');
	
	if(RtnVal != null)
		pChamJoFlag = "Y";
	else
		pChamJoFlag = "N";
	  
	//동서 : 참조 Default
	pChamJoFlag = "Y";
  }catch(e){	
	alert("SetAutoPropertyValue : " + e.description);
  }
}

var apropinion_cross_dialogArguments = new Array();
function openOpinionUI(pOpinionFlag) {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;
        parameter[1] = pOpinionFlag;
        parameter[2] = KuyjeType;
        parameter[3] = pDraftFlag;

        var url = "/ezApprovalG/aprOpinion.do";

        apropinion_cross_dialogArguments[0] = parameter;
        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;

        DivPopUpShow(530, 520, url);
    } catch (e) {
        alert("openOpinionUI : " + e.description);
    }
}
function openOpinionUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel") {
        var NodeList;
        var objXML = createXmlDom();
        objXML = loadXMLString(ret);
        NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

        if (NodeList.length != 0)
            pHasOpinionYN = "Y";
        else {
            pHasOpinionYN = "N";
            ret = "cancel";
        }
    }
}

// 기안문서정보를 저장하는 함수 
function SaveDraftDocInfo()
{
    var rtnVal;
	
    // 수정(2008.06.12) : 결재문서 파일 저장 시 임시파일 생성 후 파일크기를 체크하여 원본 파일로 복사하도록 루틴 수정
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
			 
            if(pDocState == strDocState11)
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
            var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
            var field;
            var objRoot;
            var objNode;
            var field;
	
            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();

            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
            createNodeAndInsertText(xmlpara, objNode, "FORMID", pFormID);
            if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
                createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pOrgDocID);
            else
                createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", "");
            if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
                createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", pDocType);
            else
                createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", "");

            if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
                createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", pDocState);
            else
                createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", "");

            createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", strAprState2);
            createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + pDocID + ".htm");
            field = message.GetListItem(fields, "doctitle");
            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", field.textContent);

            var field = message.GetListItem(fields, "docnumber");
            if (field)
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
            else {
                var field = message.GetListItem(fields, "bedocnumber");
                if (field)
                    createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
                else
                    createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
            }

            createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
            createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);
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
            createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[11]);
            createNodeAndInsertText(xmlpara, objNode, "PDEPTID", arr_userinfo[4]);

            createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
            createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
            createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);

            createNodeAndInsertText(xmlpara, objNode, "PUBLIC", "");
            createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
            createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
            createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
            createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);

            createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", "");
            createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", "");
            createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", "");
            createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[11]);
            createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);
            createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", pDocNumCode);

            //createNodeAndInsertText(xmlpara, objNode, "PMEMBERNAME", arr_userinfo[11]);
            //createNodeAndInsertText(xmlpara, objNode, "SMEMBERNAME", arr_userinfo[12]);
            //createNodeAndInsertText(xmlpara, objNode, "PMEMBERDEPTNAME", arr_userinfo[15]);
            //createNodeAndInsertText(xmlpara, objNode, "SMEMBERDEPTNAME", arr_userinfo[16]);
            //createNodeAndInsertText(xmlpara, objNode, "PMEMBERJOBTITLE", arr_userinfo[13]);
            //createNodeAndInsertText(xmlpara, objNode, "SMEMBERJOBTITLE", arr_userinfo[14]);
	
            xmlhttp.open("POST","/ezApprovalG/doDraft.do",false);
            xmlhttp.send(xmlpara);

            SetBtnStateFalse();
            return getNodeText(GetChildNodes(xmlhttp.responseXML)[0]);
        }catch(e){
            alert("SaveDraftDocInfo_ilban " + e.description);
        }
    }

    function SaveDraftDocInfo_susin()
    {
        try{
            var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
            var field;
            var objRoot;
            var objNode;
            var field;
	    
            var objNodes = xmldoc.documentElement.childNodes;
		
            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();
            var xmlRtn = createXmlDom();
		
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "DOCID", objNodes(0).text);
            createNodeAndInsertText(xmlpara, objNode, "FORMID", objNodes(1).text);
            createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", objNodes(2).text);
            createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", objNodes(3).text);

            createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", objNodes(4).text);
            createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", strAprState2);
            createNodeAndInsertText(xmlpara, objNode, "HREF", objNodes(6).text);
	
            field = fields.Item("doctitle");
            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", field.Value); 

            var field = fields.Item("docno");
            if (field)
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", field.textContent);
            else
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");

            createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
            createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", "");
            createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "DRAFT");
            createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
            createNodeAndInsertText(xmlpara, objNode, "WRITERID", objNodes(13).text);
            createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", objNodes(14).text);

            createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", objNodes(15).text);
            createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", objNodes(16).text);
            createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", objNodes(17).text);
            createNodeAndInsertText(xmlpara, objNode, "HTML", "");
            createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");

            createNodeAndInsertText(xmlpara, objNode, "PUSERID", arr_userinfo[1]);
            createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[2]);
            createNodeAndInsertText(xmlpara, objNode, "PDEPTID", arr_userinfo[4]);

            createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
            createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
            createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);

            createNodeAndInsertText(xmlpara, objNode, "PUBLIC", tempPublic);
            createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
            createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
            createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
            createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
            createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);

            createNodeAndInsertText(xmlpara, objNode, "PMEMBERNAME", arr_userinfo[11]);
            createNodeAndInsertText(xmlpara, objNode, "SMEMBERNAME", arr_userinfo[12]);
            createNodeAndInsertText(xmlpara, objNode, "PMEMBERDEPTNAME", arr_userinfo[15]);
            createNodeAndInsertText(xmlpara, objNode, "SMEMBERDEPTNAME", arr_userinfo[16]);
            createNodeAndInsertText(xmlpara, objNode, "PMEMBERJOBTITLE", arr_userinfo[13]);
            createNodeAndInsertText(xmlpara, objNode, "SMEMBERJOBTITLE", arr_userinfo[14]);
	
            xmlhttp.open("POST","/ezApprovalG/doDraft.do",false);
            xmlhttp.send(xmlpara);
	  		
            SetBtnStateFalse();
            return xmlhttp.responseText;
        }catch(e){
            alert("SaveDraftDocInfo_susin : " + e.description);
        }
    }

    //field 정보 가져 오기(드롭다운 리스트 포함)
    function getfieldValue(pfield)
    {
        var rtnVal = "";
		
        if(pfield){
		
            switch (pfield.tagName)//CKEDITOR-원본 : switch (pfield.TagObject.tagName)
            {
                case "TD":
                    rtnVal = pfield.textContent;//CKEDITOR-원본 : pfield.Value;
                    break;
                case "SELECT":
                    rtnVal = pfield.textContent;//CKEDITOR-원본 : pfield.TagObject.value;
                    break;
                case "INPUT" :
                    rtnVal = pfield.textContent;//CKEDITOR-원본 : pfield.TagObject.value;
                    break;
            }
        }
	
        return rtnVal;
    }

    var aprsign1_cross_dialogArguments = new Array();
    function openSignUI(parameter)
    {
        try{
            var signOption = parameter[1];  //20090112 직접서명
            var objRoot;
            var objNode;
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
            if(SignNodeList.length != 0 || signOption == "YES")     
            { 
                var parameter = pUserID;
                aprsign1_cross_dialogArguments[0] = parameter;
                aprsign1_cross_dialogArguments[1] = openSignUI_Complete;

                DivPopUpShow(350, 310, "/ezApprovalG/aprSign.do");
            }else{
                openSignUI_Complete("NAME");
            }
        }catch(e){
            alert("openSignUI : " + e.description);
        }
    }

    //결재선 지정 UI호출 함수
    function openAprLineUI()
    {
        //0:문서ID, 1: 폼ID, 2: 사인칸수, 3: 사인칸 헤드정보(직위), 4: 합의칸수 , 5:재기안유무(REDRAFT,DRAFT)
        //6:수신유무(Y/N) , 7: 참조유무(Y/N) , 8:결재선변경 유무(true/false) , 문서타입 ( 품위 , 수신, 감사)
        try{
            var parameter	= new Array();
	
            // [2006.07.24] 반송된 수신문서를 재기안할 경우 재기안문서인지 체크한다.
            var tmpReDraftFlag = (DraftFlag == "REDRAFT") ? DraftFlag : pDraftFlag;
			
            parameter[0]	= pDocID;
            //parameter[1]	= pFormID;
            parameter[1]	= "9999999999";
            parameter[2]	= SignCount;
            parameter[3]	= SignInfo;
            parameter[4]  = hapyuiCount;
            parameter[5]  = tmpReDraftFlag;
            parameter[6]  = pSuSinFlag;
            parameter[7]  = pChamJoFlag;
            parameter[8]  = gongramCount;
            parameter[9]  = false;       
            parameter[10]  = pDocType;   
            parameter[11] = "";
            parameter[12]  = "";
            parameter[13] = DraftFlag;
	
            parameter[17] = AprLineArea;       // 2012.02.08 프로세스 디자이너 
            parameter[18] = HapyuiArea;       // 2012.02.08 프로세스 디자이너 
	  
            var url		= "/ezApprovalG/aprLine.do";
            var feature	= "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";
            //2011.07.28 FireFox는 ShowModalDialog() 호출시 화면 중앙에 뜨지 않아 top, left를 지정해 줘야한다.	
            feature =  feature + GetShowModalPosition(990, 720);
            //리턴값 : 0:결재선정보(XML), 
            //         1: 수신처정보(XML),
            //         3:결재선변경Flag(C / R:첨부터다시)
            var ret = window.showModalDialog(url,parameter,feature);	
            return ret;

        }catch(e){
            alert("openAprLineUI : " + e.description);
        }
    }


    //FormID를 가져오는 함수
    function GetAprDocFormID()
    {
        try{
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
            
            pFormID = getNodeText(GetChildNodes(loadXMLString(result))[0]);

        }catch(e){
            alert("GetAprDocFormID : " + e.description);
        }
    }


    // Trim 함수 구현 2000.8.24 김성헌
    /* 좌우 공백 제거 */
    function trim(parm_str)
    {
        return rtrim(ltrim(parm_str));
    }

    /* 좌측 공백 제거 */
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

    /* 우측 공백 제거 */
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

    //서버시간
    function getGyulJeDate()
    {
        try{
  
            var objRoot;
            var objNode;
    
            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();
	  
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "getDate", "");
	  
            xmlhttp.open("POST","/ezApprovalG/getDate.do",false);
            xmlhttp.send(xmlpara);
	  
            return xmlhttp.responseText;

        }catch(e){
  
            alert("getGyulJeDate : " + e.description);
    
        }
    }

    //수신문서접수 : 문서ID Update
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
        			deptID   : arr_userinfo[4]
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

    //Load된 문서 셀정보 Init
    function setInitLoadDocCellInfo()
    {
        try{
            var i;
            var j;
            var k;
            var fieldsign;
            var fieldTmpsign;
            var fieldseumyung;
            var fieldTmpseumyung;
            var fieldseumyungdate;
            var fieldTmpseumyungdate;
            var field;
            var RtnVal;
    
            // 0 : Sign
            // 1 : hapyui
            var SignArray = new Array();
            var SignArrayLen;
            SignArray[0] = "sign";
            SignArray[1] = "habyuisign";
    
            var fieldSN = 1;
            var fieldNum = 1;
            var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
            SignArrayLen = SignArray.length;
    
            if(!fields) return;
    
            //Cell Info Init
            for(k = 0 ; k < SignArrayLen ; k++)
            {
                //사인(수신)
                for(i = 0 ; i < fieldNum ; i++)
                {
                    if(i == "0")
                    {
                        fieldsign = SignArray[k];
                        fieldseumyung = "jikwe";
                        fieldseumyungdate = "seumyungdate";
                    }
                    else
                    {
                        fieldsign = i + SignArray[k];
                        fieldseumyung = i + "jikwe";
                        fieldseumyungdate = i + "seumyungdate";
                    }
                    fieldTmpsign = fieldsign + 1;
                    field = message.GetListItem(fields, fieldTmpsign);//CKEDITOR-원본 : field = fields.item(fieldTmpsign);    
                    if(field)
                    {
                        //사인(일반)
                        for(j = 0 ; j < fieldSN ; j++)
                        {
                            fieldTmpsign = fieldsign + ( parseInt(j) + 1 );
                            fieldTmpseumyung = fieldseumyung + ( parseInt(j) + 1 );
                            fieldTmpseumyungdate = fieldseumyungdate + ( parseInt(j) + 1 );
                            field = message.GetListItem(fields, fieldTmpsign);//CKEDITOR-원본 : field = fields.item(fieldTmpsign);
                            if(field)
                            {
                                field.textContent = "";//CKEDITOR-원본 : field.value = "";
                                field = message.GetListItem(fields, fieldTmpseumyung);//CKEDITOR-원본 : field = fields.item(fieldTmpseumyung)
                                if(field)
                                {
                                    field.textContent = "";//CKEDITOR-원본 : field.value = "";
                                }
                                field = message.GetListItem(fields, fieldTmpseumyungdate);//CKEDITOR-원본 : field = fields.item(fieldTmpseumyungdate)
                                if(field)
                                {
                                    field.textContent = "";//CKEDITOR-원본 : field.value = "";
                                }
                                fieldSN = parseInt(fieldSN) + 1;
                            }
                            else
                            {
                                fieldNum = parseInt(fieldNum) + 1;
                                break;
                            }
                        }
                    }
                    else
                    {
                        break;
                    }
                }        
            }
        }catch(e){
            alert("setInitLoadDocCellInfo : " + e.description);
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

    //****************************************************************
    // 문서정보를 가져오는 함수
    //****************************************************************
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
    			result = xml;
    		}        			
    	});

        xmldoc = loadXMLString(result);

        var objNodes = xmldoc.documentElement.childNodes;
        if (objNodes) {
            pOrgDocID = GetChildNodes(xmldoc.documentElement)[2].textContent;
            if (GetChildNodes(xmldoc.documentElement)[10].textContentt == "Y" || GetChildNodes(xmldoc.documentElement)[10].textContent == "O")
                pHasOpinionYN = "Y";

            tempSecurity = getNodeText(GetChildNodes(xmldoc.documentElement)[19]);
            tempKeep = getNodeText(GetChildNodes(xmldoc.documentElement)[20]);
            tempUrgent = getNodeText(GetChildNodes(xmldoc.documentElement)[21]);
            tempPublic = getNodeText(GetChildNodes(xmldoc.documentElement)[18]);
            tempKeyword = getNodeText(GetChildNodes(xmldoc.documentElement)[25]);
            tempItemCode = getNodeText(GetChildNodes(xmldoc.documentElement)[23]);
            tempItemName = getNodeText(GetChildNodes(xmldoc.documentElement)[24]);

            pSummery = getNodeText(GetChildNodes(xmldoc.documentElement)[35]);
            pSpecialRecordCode = getNodeText(GetChildNodes(xmldoc.documentElement)[26]);
            pPublicityCode = getNodeText(GetChildNodes(xmldoc.documentElement)[27]);
            pLimitRange = getNodeText(GetChildNodes(xmldoc.documentElement)[28]);
            pPageNum = getNodeText(GetChildNodes(xmldoc.documentElement)[29]);
            cabinetID = getNodeText(GetChildNodes(xmldoc.documentElement)[30]);
            TaskCode = getNodeText(GetChildNodes(xmldoc.documentElement)[31]);

            tempSecurityDate = getNodeText(GetChildNodes(xmldoc.documentElement)[36]);
        }
    }

    //부서합의 및 수신문서 접수시 브라우즈 모드로 변형한다.
    function changeEditMode()
    {
        if(pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
        {
        }
    }

    function getReceiveDocInfo()
    {
        try{
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
            
            var pdocXML;
            var xmlString;
	
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
            pdocXML =  SelectSingleNodeNew(result, "RECEIVEDATA/DOCFLAGINFO");
            xmlString = getXmlString(pdocXML);
            xmlpara = loadXMLString(xmlString);	

            var node = GetElementsByTagName(xmlpara, "DocFlag");		
            pDraftFlag = getNodeText(node[0]);
            var node = GetElementsByTagName(xmlpara, "Href");
            pFormHref = getNodeText(node[0]);	
	
            pOrgDocID = getNodeText(GetElementsByTagName(result, "ORGDOCID")[0]);
            var doctitle = getNodeText(GetElementsByTagName(result, "DOCTITLE")[0]);
	
	   
            switch (pDraftFlag)
            {
                case "SUSIN" :
                    pSusinSN        = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
                    pDocType        = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
                    pDocState       = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
                    pAprState       = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
                    pSusinDocURL    = pFormHref;
                    break;

                case "HAPYUI" :
                    pSusinSN = ""
                    pDocType        = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
                    pDocState       = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
                    pAprState       = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
                    pSusinDocURL    = getNodeText(GetElementsByTagName(result, "HAPYUI")[0]);
                    break;
				
                case "GAMSABU" :
                    pSusinSN        = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
                    pDocType        = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
                    pDocState       = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
                    pAprState       = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
                    pSusinDocURL    = getNodeText(GetElementsByTagName(result, "GAMSA")[0]);
                    ConvertYN       = getNodeText(GetElementsByTagName(xmlpara, "CONVERTYN")[0]);
			
                    if (ConvertYN == "N")
                        pSusinSN = "gamsa";
                    else
                        pSusinSN = "";
                    break;
				
                case "WHOKYUL" :
                    pSusinSN        = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
                    pDocType        = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
                    pDocState       = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
                    pAprState       = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
                    pSusinDocURL    = getNodeText(GetElementsByTagName(result, "GAMSA")[0]);
			
                    break;
			
                case "GONGRAM" :
                    pSusinSN    = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
                    pDocType    = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
                    pDocState   = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
                    pAprState   = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
                    pSusinDocURL = pFormHref;
                    break;
			
                default :
                    pSusinSN = "1"; 
                    break;
            }
        }catch(e){
            alert("getReceiveDocInfo :: " + e.description);
        }
    }


    //접수기 배부,회송,지정,바로결재 버튼 상태변경
    function setButtonReceiveTrue()
    {
        SetBtnStateFalse();
        btnAssign.Enable = "false";
        btnDistribute.Enable = "false";
        btnReturn.Enable = "false";
        btnAproveSusin.Enable = "false";

    }

    //ContextMenu Enable/Disable
    function document_oncontextmenu()
    {
	
        if(g_sendDraftFlag)
        {
		
            return false;
	
        }else{
	
            return true;
	
        }
    }


    function setHeSongDocInfo()
    {
        try{
        	var result = "";
            var docState = "";
            
        	if (pAprState == strAprState15) {
        		docState = "REACK";
        	} else {
        		docState = "RECEIVE";
        	}
        	
            $.ajax({
        		type : "POST",
        		dataType : "text",
        		async : false,
        		url : "/ezApprovalG/setHeSongDocInfo.do",
        		data : {
        			docID : pDocID,
        			receiveSN : pSusinSN,
        			deptID  : arr_userinfo[4],
        			docState : docState,
        			userID : pUserID,
        			userName : arr_userinfo[11],
        			userName2 : arr_userinfo[12]
        		},
        		success: function(text){
        			result = text;
        		}        			
        	});
            
            if(result != "TRUE")
            {
                var pAlertContent = strLang350;
                OpenAlertUI(pAlertContent);
                return false;
            }
            else
            {
                var pAlertContent = strLang35;
                OpenAlertUI(pAlertContent);
                return true;
            }
        }catch(e){
            alert("setHeSongDocInfo :: " + e.description);
            return true;
        }
    }

    var ezchkpasswd_cross_dialogArguments = new Array();
    function chk_Passwd()
    {
        var parameter = pUserID;
        var url = "/ezApprovalG/ezchkPasswd.do";

        ezchkpasswd_cross_dialogArguments[0] = parameter;
        ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

        DivPopUpShow(330, 200, url);
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

        var fields = message.GetFieldsList();//CKEDITOR-추가
        var field = message.GetListItem(fields, "memo");
        if(field)
        {
            //field.value = content;
            field.textContent = content;
        }
    }

    //기안자를 디폴트로 결재선에 등록한다.
    function setFirstDrafter()
    {
        var pxml 
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        pxml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang106 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pxml = pxml + "<HEADER><NAME>" + strLang107 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pxml = pxml + "<HEADER><NAME>" + strLang108 + "</NAME><WIDTH>150</WIDTH></HEADER>";
        pxml = pxml + "<HEADER><NAME>" + strLang38 + "</NAME><WIDTH>150</WIDTH></HEADER>";
        pxml = pxml + "<HEADER><NAME>" + strLang109 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pxml = pxml + "<HEADER><NAME>" + strLang110 + "</NAME><WIDTH>120</WIDTH></HEADER>";
        pxml = pxml + "<HEADER><NAME>" + strLang111 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>";
        pxml = pxml + "<ROWS><ROW><COLUMN>1</COLUMN>";
        pxml = pxml + "<COLUMN>" + arr_userinfo[2] + "</COLUMN>";
        pxml = pxml + "<COLUMN>" + arr_userinfo[3] + "</COLUMN>";
        pxml = pxml + "<COLUMN>" + arr_userinfo[5] + "</COLUMN>";
	 
        pxml = pxml + "<COLUMN>" + strLangAprType2 + "</COLUMN>";
        pxml = pxml + "<COLUMN>" + strLangAprState2 + "</COLUMN>";
        pxml = pxml + "<DATA name='ProcessDate'></DATA>";
        pxml = pxml + "<DATA name='ReceivedDate'></DATA>";
        pxml = pxml + "<DATA name='DocID'>" + pDocID + "</DATA>";
        pxml = pxml + "<DATA name='AprMemberID'>" + arr_userinfo[1] + "</DATA>";
        pxml = pxml + "<DATA name='AprmemberIsDeptYN'>N</DATA>";
        pxml = pxml + "<DATA name='AprMemberDeptID'>" + arr_userinfo[4] + "</DATA>";
        pxml = pxml + "<DATA name='ReasonDoNotApprov'>" + "" + "</DATA>";
        pxml = pxml + "<DATA name='isProposerYN'>N</DATA>";
        pxml = pxml + "<DATA name='isBriefUserYN'>N</DATA>";
        //추가부분
        pxml = pxml + "<DATA name='isCompanyID'>N</DATA>";
        pxml = pxml + "<DATA name='AprType'>" + strAprType2 + "</DATA>";
        pxml = pxml + "<DATA name='AprState'>" + strAprState2 + "</DATA>";
	
        // 수정(2007.06.18) : multidata 기능추가 
        pxml = pxml + "<DATA name='PMemberName'>" + arr_userinfo[11] + "</DATA>";		//primary usernm
        pxml = pxml + "<DATA name='SMemberName'>" + arr_userinfo[12] + "</DATA>";		//secondary usernm
        pxml = pxml + "<DATA name='PMemberDeptName'>" + arr_userinfo[15] + "</DATA>";	//primary deptname
        pxml = pxml + "<DATA name='SMemberDeptName'>" + arr_userinfo[16] + "</DATA>";	//secondary deptname
        pxml = pxml + "<DATA name='PMemberJobTitle'>" + arr_userinfo[13] + "</DATA>";	//primary title
        pxml = pxml + "<DATA name='SMemberJobTitle'>" + arr_userinfo[14] + "</DATA>";	//secondary title
	
        pxml = pxml + "</ROW></ROWS></LISTVIEWDATA>";
        xmlpara.loadXML(pxml);
	
        xmlhttp.open("POST","/ezApprovalG/aprLineSave.do",false);
        xmlhttp.send(xmlpara);
	
        if(xmlhttp.responseText == "true")
        {
            LastSignSN = 1;
        }
        else
        {
            var pAlertContent = strLang352;
            OpenAlertUI(pAlertContent);
        }
    }

    //문서번호 포멧 설정
    function setDocNumFormat(pPrefix)
    {
        var fields = message.GetFieldsList();//CKEDITOR-추가
        var Arr_Header = new Array();
        var Header, Tail;
        var i;
        //var d = new Date();
	
        //20110105 문서번호 기안자 PC  시간을 가져오는 오류 처리
        var initdate = getGyulJeDate();
        var szYear  = initdate.substring(0,4);
        var szMonth = initdate.substring(5,7);
        var szDay   = initdate.substring(8,10);
		
        var numHeader = "";
		
        var field = GetListItem(fields, pPrefix + "docnumber");//CKEDITOR-원본 : var field = pzFormProc.fields(pPrefix + "docnumber")
        if(!field) return 
		
        var fieldValue = getfieldValue(field);//pzFormProc.editor.DOM.body.getAttribute("orgdocnum");
        Arr_Header = fieldValue.split("@");
	   
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
                    numHeader = numHeader + DeptSymbol + Tail;
                    break;

                case "YY":
                    numHeader = numHeader + szYear + Tail; //20110105 문서번호 기안자 PC  시간을 가져오는 오류 처리
                    break;

                case "yy":
                    var yyear = szYear;//20110105 문서번호 기안자 PC  시간을 가져오는 오류 처리
                    numHeader = numHeader + yyear.toString().substr(2) + Tail; 
                    break;

                case "MM":
                    numHeader = numHeader + szMonth + Tail; //20110105 문서번호 기안자 PC  시간을 가져오는 오류 처리
                    break;

                case "mm":			    
                    if(szMonth.substr(0,1) == "0")
                    {
                        numHeader = numHeader + szMonth.substr(1) + Tail; //20110105 문서번호 기안자 PC  시간을 가져오는 오류 처리
                    }
                    else
                    {
                        numHeader = numHeader + szMonth + Tail; //20110105 문서번호 기안자 PC  시간을 가져오는 오류 처리
                    }
                    break;

                case "NN":
                    break;

                case "nn":
                    break;

                case "cs":
                    if (tempItemCode != "")
                        numHeader = numHeader + tempItemCode + Tail;
                    else
                        numHeader = numHeader + tempdocnumcode + Tail;
                    break;

                default:
                    numHeader = numHeader + fieldValue;
                    break;
            }
        }
			
        field.textContent = numHeader;
    }


    //파일정보를 저장한다. 
    function SaveFile()
    {
        // 20090907 : 표준모듈 패치, 빈문서 저장을 막기위한 체크
        if(CheckBlankDoc() == "FALSE")
            return "FALSE";

        var mhtBody = "";
        mhtBody = message.Get_EditorBodyHTML()
        mhtBody = "<HTML>" + GetCKEditerHeader() + mhtBody + "</HTML>";
        mhtBody = ConvertHTMLtoMHT(mhtBody);
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/saveFile.do",
    		data : {
    			docID : pDocID,
    			html  : mhtBody
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});

        return result;
    }

    // 20090907 : 표준모듈 패치, 빈문서 저장을 막기위한 체크
    function CheckBlankDoc()
    {
        var rtnVal = "TRUE";
        //20080301_성수곤
        // 폼프록의 mht바이너리 코드를 확인한다.
        // 빈문서 저장을 막기 시작-------------------------------------------------------------------------------------------------------------------------
        var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
        var field = message.GetListItem(fields, "doctitle");//CKEDITOR-원본 : var field = fields.Item("doctitle");
        pDocTitle = field.textContent;//CKEDITOR-원본 : pDocTitle = field.value;
	
        var mhtData = ConvertHTMLtoMHT(message.Get_EditorBodyHTML());
        var pDocMHTSubject = mhtData.substring(mhtData.indexOf("Subject:"),mhtData.indexOf("Date:"));//CKEDITOR-원본 : var pDocMHTSubject = pzFormProc.DocumentHTML.substring(pzFormProc.DocumentHTML.indexOf("Subject:"),pzFormProc.DocumentHTML.indexOf("Date:"));
        var pDocTitleCheckOn = pDocTitle;
        if(pDocTitleCheckOn == "HTML to Mime-HTML")    // "HTML to Mime-HTML"가 제목이면 비교할수가 없다. 저장 못하게 처리. 이걸 제목으로 쓰는일은 없겠지?
            rtnVal = "FALSE";
        
        if(pDocMHTSubject.replace("Subject:", "").replace(" ","") == "HTMLtoMime-HTML")    // 빈문서 리턴시 제목이 "HTML to Mime-HTML"로 넘어온다. "HTML to Mime-HTML"를 문서제목에 들어있진 않겠지?
            rtnVal = "FALSE";
        
        //혹시 모르니 제목부분이 mht바이너리의 subject와 동일한지도 체크
        if(pDocTitleCheckOn.indexOf("Date:") == -1) // 제목에 "Date:"가 들어 있는지 체크
        {
            //특수기호 처리 안되는 부분으로 인해 삭제
        }
        else    // 만약에 제목에 "Date:" 있다면 "--Boundary-="로 짤라서 비교한다.
        {
        }
        // 빈문서 저장 막기 끝-------------------------------------------------------------------------------------------------------------------------------
    
        return rtnVal;
    }

    //파일정보를 저장한다. 
    function SaveOrgFile()
    {
        var mhtBody = "";
        mhtBody = "<HTML>" + GetCKEditerHeader() + pOrgHtml + "</HTML>";
        mhtBody = ConvertHTMLtoMHT(mhtBody);

        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/saveFile.do",
    		data : {
    			docID : pDocID,
    			html  : mhtBody
    		},
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

            var objNode;
            objNode = createNodeInsert(xmlpara, objNode, "SIGNINFOS");
	
            for (i=0; i<SignContent.length; i++)
            {
                var objSub;
                objSub = createNodeAndAppandNode(xmlpara,  objNode, objSub, "SIGNINFO");
			
                var objSub2;
                createNodeAndAppandNodeText(xmlpara,  objSub, objSub2 , "DOCID", pDocID);			
                createNodeAndAppandNodeText(xmlpara,  objSub, objSub2 , "SIGNTYPE", SignType[i]);
                createNodeAndAppandNodeText(xmlpara,  objSub, objSub2 , "SIGNNAME", SignName[i]);
                createNodeAndAppandNodeText(xmlpara,  objSub, objSub2 , "CONTENT", SignContent[i]);
			
            }  		
            xmlhttp.open ("Post","/ezApprovalG/setSignInfo.do",false);
            xmlhttp.send(xmlpara);
        }
    }

    function delOpinionInfo()
    {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	
        xmlhttp.open("POST","../ezAPROPINION/aspx/BansongOpinionDel.aspx",false);
        xmlhttp.send(xmlpara);

        return xmlhttp.responseText;
    }

    function btnApprovalInfo_save(ret) {
        pDocID = SelectSingleNodeValueNew(ret[1], "PARAMETER/DOCID");
        summary = SelectSingleNodeValueNew(ret[1], "PARAMETER/SUMMARY");

        var xmlhttp = createXMLHttpRequest();

        var result = "";

        xmlhttp.open("Post", "/ezApprovalG/aprLineSave.do", false);
        xmlhttp.send(ret[2]);

        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        result = getNodeText(dataNodes[0]);

        if (result != "TRUE") {
            alert(strLang259);
        }

        if (pSuSinFlag == "Y") {
            var AprDeptInfo = loadXMLString(ret[3]);

            var AprDeptPara = createXmlDom();
            var pAprNDeptNumber = 1;
            var pAprDeptFlag = "NDept";
            AprDeptPara = AprDeptParameter(pAprNDeptNumber, pAprDeptFlag);

            if (CrossYN()) {
                var xmlRtn = AprDeptPara.documentElement;
                var Node = AprDeptInfo.importNode(xmlRtn, true);
                AprDeptInfo.documentElement.appendChild(Node);
            }
            else {
                var xmlRtn = AprDeptPara.documentElement;
                AprDeptInfo.documentElement.appendChild(xmlRtn);
            }

            xmlhttp = null;
            xmlhttp = createXMLHttpRequest();
            xmlhttp.open("Post", "/ezApprovalG/aprDeptSave.do", false);
            xmlhttp.send(AprDeptInfo);

            var dataNodes = GetChildNodes(xmlhttp.responseXML);
            result = getNodeText(dataNodes[0]);

            if (result == "") {
                alert(strLang163);
            }
        }
    }