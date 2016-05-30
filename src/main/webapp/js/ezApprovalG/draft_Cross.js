var lastKyulName, lastKyuljiwee, LastSignSN;
var DraftLastFlag = false;
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
	var FormProc;
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
	var OrderSuggester = new Array(); 
	var OrderReporter = new Array(); 
					  
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
	
	if(xmlReDraft == "C")
	{
		ApplyDocCellInfo();
	}
	else if(xmlReDraft == "R")
	{
		ClearDocCellInfo();
	}
    
	 
	xmldom = loadXMLString(xmlKuljea);
	  
    objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    fields = message.GetFieldsList();
	count = objNodes.length;
	
	 
	for(i=1;i<20;i++)
	{
	   	name = "habyuisign" + i;
	  	field = message.GetListItem(fields, name);
	  
	  	if(field)
	  	{
	  		name = "habyui" + i;
	  		field = message.GetListItem(fields, name);
	  	
            if(field)
	  	    {
	  	        field.textContent= "";
	  	        if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
            }  
	  		
	  		fieldname = "habyuisign" + i;
	  		field = message.GetListItem(fields, name);
	  		
            if(field)
	  	    {
	  	        field.textContent= "";
	  	        if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
            }
	  		
	  		fieldname = "habyuipositon" + i;
	  		field = message.GetListItem(fields, name);
	  		
            if(field)
	  	    {
	  	        field.textContent= "";
	  	        if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
            }
	  		
	  		
	  		fieldname = "habyuidate" + i;
	  		field = message.GetListItem(fields, name);
	  		
            if(field)
	  	    {
	  	        field.textContent= "";
	  	        if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
            }
	  	}
	  	else
	  	{
	  	   break;
	  	}
	}
	
    field = message.GetListItem(fields, "refer");
    if (field) {
        if (field.childNodes.length == 0) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
	
	
	field = message.GetListItem(fields, "hgamsa");
	if (field) {
	    field.textContent = "";
	    if (new RegExp(/Firefox/).test(navigator.userAgent))
	        field.innerHTML = "<br type='_moz'>";
	}
	
	for (i = 1; i < fields.length; i++) {
	    field = message.GetListItem(fields, "gongram" + i);
	    if (field) {
	        field.innerText = "";
	        if (new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
	    }
	}
		
	for(i=0;i < count;i++)
	{
	    var Cell = GetChildNodes(objNodes[i]);
	    var KyljeaOrder = getNodeText(Cell[0]);
	    var KyljeaName = getNodeText(Cell[1]);
	    var KyljeaDeptName = getNodeText(Cell[3]);
	    var KyljeaType  = getNodeText(Cell[16]);
	    var KyljeaTypeName  = getNodeText(Cell[4]);
	    var KyljeaStat = getNodeText(Cell[17]);
	    var KyljeaStatName = getNodeText(Cell[5]);
	    var KyljeaJobtitle = getNodeText(Cell[2]);
	    var ReasonDoNotApprov = getNodeText(Cell[12]);
   		var suggester = getNodeText(Cell[13]);
   		var reporter = getNodeText(Cell[14]);
	      	
	    OrderType[KyljeaOrder] = KyljeaType;
	    OrderTypeName[KyljeaOrder] = KyljeaTypeName;
	    OrderName[KyljeaOrder] = KyljeaName;
	    OrderDept[KyljeaOrder] = KyljeaDeptName;
	    OrderStat[KyljeaOrder] = KyljeaStat;
	    OrderStatName[KyljeaOrder] = KyljeaStatName;
	    OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
	    OrderReason[KyljeaOrder] = ReasonDoNotApprov;
   		OrderSuggester[KyljeaOrder] = suggester;
   		OrderReporter[KyljeaOrder] = reporter;
    }

    CurAprType = OrderType[1];
    if (OrderType.length > 2)
		NextAprType = OrderType[2];
    
    if(isSplit == "Y")  
		SplitSign(OrderType,OrderName,OrderDept,OrderStat,OrderJobtitle);
    
	LastSignSN = OrderType.length;
    
    for(i=1;i<OrderType.length;i++)
    {
		if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16)
		{
			LastSignSN = i;
			i = OrderType.length;
		}
		else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 ||  OrderType[i] == strAprType1 ||  OrderType[i] == strAprType3)
		{
    		LastSignSN = i;
        }
    }
    
    lastKyulName = OrderName[LastSignSN];
    lastKyuljiwee = OrderJobtitle[LastSignSN];
    var field = message.GetListItem(fields, "lastKyuljikwee");
    if(field)
		field.textContent = lastKyuljiwee;
    
    var field = message.GetListItem(fields, "lastKyulName");
    if(field)
		field.textContent = lastKyulName;
      
	hapyuiCnt = 1;
	SignCnt = 1;
	referCnt = 1;
	gongramCnt = 1;
	
	var fieldname;
	var field;
	  
	
	for(i=1;i < 10;i++)
	{
	  	fieldname = "jikwe" + i;
		field = message.GetListItem(fields, fieldname);
	  
		if(field)
		{
            field.textContent= " ";	
            if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
			fieldname = "sign" + i;
			field = message.GetListItem(fields, fieldname);
			if(field)
			{
				field.textContent= " ";	
				if(new RegExp(/Firefox/).test(navigator.userAgent))
	                field.innerHTML = "<br type='_moz'>";

			}
		}else{
			break;
		}	
	}
	var idx = 1;
	var hidx = 1;	  
	for(i=1;i < OrderJobtitle.length;i ++)
	{
		if(OrderType[i] == strAprType18 || OrderType[i] == strAprType19  || OrderType[i] == strAprType1 || OrderType[i] == strAprType4  || OrderType[i] == strAprType16 || OrderType[i] == strAprType3)
		{
			fieldname = "jikwe" + idx;
			field = message.GetListItem(fields, fieldname);
	  	
			if(field)
			{
			    var jikweName = trim(field.textContent);					
				field.textContent =  OrderJobtitle[i];
						
				if(OrderSuggester[i] == "Y")
						field.textContent = strLang75 + field.textContent;
					
				if(OrderReporter[i] == "Y")
						field.textContent = strLang76 + field.textContent;
			}
			idx = idx + 1;
	  	}
		else if(OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)
		{
			fieldname = "habyui" + hidx;
			field = message.GetListItem(fields, fieldname);
	  		if(field)
	  		{
	  			field.textContent = OrderDept[i];
	  		}
			
			fieldname = "habyuipositon" + hidx;
			field = message.GetListItem(fields, fieldname);
			if(field)
			{
			    var jikweName = trim(field.textContent);
			    field.textContent = OrderJobtitle[i];

				if(OrderSuggester[i] == "Y")
						field.textContent = strLang75 + field.textContent;
					
				if(OrderReporter[i] == "Y")
						field.textContent = strLang76 + field.textContent;
			}
			hidx = hidx + 1;
		}	
	}
    var field = message.GetListItem(fields, "lineapr");
    if (field)
	{
		if (idx > 5)
		{
			field.style.display = "";
			for (i=0; i<field.childElementCount; i++)
			    field.children[i].style.display = "";
		}
		else
		{
			field.style.display = "none";
			for (i=0; i<field.childElementCount; i++)
			    field.children[i].style.display = "none";
		}
	}
    field = message.GetListItem(fields, "linehab");
	if (field)
	{
		if (hidx > 5)
		{
			field.style.display = "";
			for (i=0; i<field.childElementCount; i++)
			    field.children[i].style.display = "";
		}
		else
		{
			field.style.display = "none";
			for (i=0; i<field.childElementCount; i++)
			    field.children[i].style.display = "none";
		}	
	}		
		
  }catch(e){
    alert("GetDraftAprLineInfo(ret)" + e.description);
  }	
}

function setRecevInfo(ret) {
    setDeptLinesXML(ret);

    var fields = message.GetFieldsList();
    var i;
    var strMailAdd = "";
    var precipent = "";
    var precipents = "";
    var mailflag = true;
    var recipflag = true;
    var mailList = "";
    var mailcnt = 0;
    var xmldom = createXmlDom();
    xmldom.async = false;
    xmldom = loadXMLString(ret);

    if (getXmlString(xmldom) == "") {
        var field = message.GetListItem(fields, "hrecipients");
        if (field) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipient");
        if (field) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipients");
        if (field) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        return;
    }
    if (xmldom.documentElement.childElementCount == 0) {
        var field = message.GetListItem(fields, "hrecipients");
        if (field) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipient");
        if (field) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipients");
        if (field) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        return;
    }
    btnReceivLineEnable = true;

    var rows = SelectNodes(xmldom, "ROWS/ROW");
    var field = message.GetListItem(fields, "hrecipients");
    if (field) {
        field.textContent = "";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    var field = message.GetListItem(fields, "recipient");
    if (field) {
        field.textContent = "";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    var field = message.GetListItem(fields, "recipients");
    if (field) {
        field.textContent = "";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    for (i = rows.length - 1; i >= 0; i--) {
        var row = rows[i];
        var dataNodes = GetChildNodes(row);

        if (getNodeText(dataNodes[3]) == "Y") {
            if (mailflag) {
                strMailAdd = "\"" + getNodeText(dataNodes[0]) + "\"" + " " + "<" + getNodeText(dataNodes[6]) + ">";
                mailflag = false;
                mailList = getNodeText(dataNodes[0]);
            }
            else {
                strMailAdd = strMailAdd + ", " + "\"" + getNodeText(dataNodes[0]) + "\"" + " " + "<" + getNodeText(dataNodes[6]) + ">";
                mailList = mailList + "," + getNodeText(dataNodes[0]);
            }
            mailcnt = mailcnt + 1;
        }
        if (recipflag) {
            if (getNodeText(dataNodes[3]) == "Y") {
                precipent = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                precipents = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                recipflag = false;
            }
            else {
                if (isExtDoc == "Y") {
                    precipent = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                    precipents = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                    recipflag = false;
                }
                else {
                    precipent = getNodeText(dataNodes[0]);
                    precipents = getNodeText(dataNodes[0]);
                    recipflag = false;
                }
            }
        }
        else {
            precipent = strLang92;

            if (getNodeText(dataNodes[3]) == "Y")
                precipents = precipents + "," + getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
            else {
                if (isExtDoc == "Y")
                    precipents = precipents + "," + getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                else
                    precipents = precipents + "," + getNodeText(dataNodes[0]);
            }
        }
    }
    message.DocumentBodySetAttribute("sendMailInfo", strMailAdd);
    var field = message.GetListItem(fields, "recipient");
    if (field) {
        if (precipent == strLang92) {
            field.textContent = precipent;

            /* 2015-06-30 표준모듈:추가(외부수신자요약) */
            if (SummaryOuterReceiverList != "") {
                var field = message.GetListItem(fields, "recipients");
                if (field) {
                    field.textContent = SummaryOuterReceiverList;
                    var field = message.GetListItem(fields, "hrecipients");
                    if (field)
                        field.textContent = strLang129;
                }
            } else {
            var field = message.GetListItem(fields, "recipients");
            if (field) {
                field.textContent = precipents;
                var field = message.GetListItem(fields, "hrecipients");
                if (field)
                    field.textContent = strLang129;
                }
            }
        }
        else {
            field.textContent = precipent;

            if (precipents == "") {
                var field = message.GetListItem(fields, "hrecipients");
                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
                var field = message.GetListItem(fields, "recipients");
                if (field){
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
            }
        }
    }
}

function ClearDocCellInfo() {
    try {
        var i;
        var j;
        var k;
        var fieldname;
        var susunSN = "";

        var fields = message.GetFieldsList();

        if (pDraftFlag == "SUSIN" || pDocState == "011") susunSN = pSusinSN;
        for (i = 1; i <= SignCount ; i++) {
            fieldname = susunSN + "sign" + i;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "seumyung" + i;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "seumyungdate" + i;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "jikwe" + i;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }
        }
        for (j = 1 ; j <= hapyuiCount ; j++) {
            fieldname = susunSN + "habyui" + j;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "habyuipositon" + j;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "habyuidate" + j;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "habyuisign" + j;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }
        }
        for (i = 1; i < 20; i++) {

            fieldname = "habyuiopinion" + i;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }
        }
        fieldname = "sealsign";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
    catch (e) {
        alert("ClearDocCellInfo()" + e.description);
    }
}
function setClearSusinCellInfo() {
    try {
        var fields = message.GetFieldsList();
        var fieldname;

        fieldname = "recipient";
        field = message.GetListItem(fields, fieldname);

        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        fieldname = "recipients";
        field = message.GetListItem(fields, fieldname);

        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
    catch (e) { alert("setClearSusinCellInfo()" + e.description); }
}
function ApplyDocCellInfo() {
    try {
        var i;
        var j;
        var k;
        var fieldname;
        var fieldvalue;

        var fields = message.GetFieldsList();

        for (j = 1 ; j <= hapyuiCount ; j++) {
            fieldname = "habyuidate" + j;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                fieldvalue = field.textContent;
                fieldvalue = trim(fieldvalue);

                if (fieldvalue == "") {
                    fieldname = "habyui" + j;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                        field.textContent = "";
                        if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                    }
                }
            }
        }
    } catch (e) {
        alert("ApplyDocCellInfo()" + e.description);
    }
}
function putJunkyulSign(signID) {
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, signID);
    if (field) {
        var signWidth = parseInt(field.offsetWidth) - 4 - 15;
        var signHeight = parseInt(field.offsetHeight) - 4;

        var strimg;
        field.style.fontSize = "12pt";
        field.style.fontWeight = "bolder";
        field.style.color = "blue";
        field.textContent = strLang6;
    }
}
function SendDraftMappingSign(ret) {
    try {
        var fields = message.GetFieldsList();
        var field;

        var psigncell;
        var pseumyungcell;
        var pseumyungdatecell;
        var signInfo = new Array();
        var signCnt = 0;
        var sn = 1;

        var OpinionText = "";
        var PositionText = "";
        if (getOpinionCount()) {
            PositionText = "(" + strLang5 + "";
        }

        if (LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16) 
        {
            OpinionText = getSignDate() + "<br>";
        }

        psigncell = "sign" + sn;
        pseumyungcell = "jikwe" + sn;
        pseumyungdatecell = "seumyungdate" + sn;

         
        var RtnVal = getGyulJeDate();
        var CurrentDate = RtnVal.split(".");
        var s = CurrentDate[1] + "." + CurrentDate[2];

        field = message.GetListItem(fields, psigncell);
        var signWidth = parseInt(field.offsetWidth) - 4;
        var signHeight = parseInt(field.offsetHeight) - 4;

        signWidth = 50;
        signHeight = 28;

        var strimg;
        var SingFlag = true;

        var DekyulFlag = false;

        var field = message.GetListItem(fields, pseumyungcell);
        if (field) {
            field.textContent = field.textContent + PositionText;
        }

        if (CurAprType == strAprType16)  
        {
            var field = message.GetListItem(fields, psigncell);
            if (field) {
                
                if (ret != "NAME") {
                    strimg = "<img src='" + document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                    strimg = strimg + " height=" + signHeight + " spath='" + escape(ret) + "'>";

                    field.innerHTML = strLang7 + OpinionText + strimg;

                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "IMAGE";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = ret + "::" + strLang7 + OpinionText;

                    message.DocumentBodySetAttribute(psigncell, ret);
                    signCnt = signCnt + 1;
                    SingFlag = true;
                }
                else {
                    strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                    field.innerHTML = strLang7 + OpinionText + strimg;
                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "HTML";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = strLang7 + OpinionText + strimg;

                    signCnt = signCnt + 1;
                    SingFlag = false;
                }
            }
            DekyulFlag = true;
            sn = sn + 1;
            psigncell = "sign" + sn;
            pseumyungcell = "jikwe" + sn;
            pseumyungdatecell = "seumyungdate" + sn;
        }
        if (DekyulFlag && NextAprType == strAprType4)
        {
            var field = message.GetListItem(fields, psigncell);
            if (field) {
                field.innerHTML = strLangAprType4;
                signInfo[signCnt] = psigncell;
                SignType[signCnt] = "TEXT";
                SignName[signCnt] = psigncell;
                SignContent[signCnt] = strLangAprType4;
                signCnt = signCnt + 1;
                SingFlag = false;
            }
        }
        else if (DekyulFlag) {
        }
        else {
            var field = message.GetListItem(fields, psigncell);
            if (field) {
                if (ret != "NAME") {
                    strimg = "<img src='" + document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                    strimg = strimg + " height=" + signHeight + " spath='" + escape(ret) + "'>";

                    if (CurAprType == strAprType4)
                        OpinionText = strLangAprType4 + OpinionText;

                    field.innerHTML = OpinionText + strimg;

                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "IMAGE";
                    SignName[signCnt] = psigncell;
                    if (OpinionText != "")
                        SignContent[signCnt] = ret + "::" + OpinionText;
                    else
                        SignContent[signCnt] = ret;

                    message.DocumentBodySetAttribute(psigncell, ret);
                    signCnt = signCnt + 1;
                    SingFlag = true;
                }
                else {
                    if (field) {
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                        if (CurAprType == strAprType4)
                            OpinionText = strLangAprType4 + OpinionText;
                        field.innerHTML = OpinionText + strimg;
                        signInfo[signCnt] = psigncell;
                        SignType[signCnt] = "HTML";
                        SignName[signCnt] = psigncell;
                        SignContent[signCnt] = OpinionText + strimg;

                        signCnt = signCnt + 1;
                        SingFlag = false;
                    }
                }
            }
        }
        return signInfo;
    } catch (e) {
        alert("SendDraftMappingSign(ret)" + e.description);
    }
}

function UndoSignInfo(signInfo) {
    try {
        var cnt;
        var fields = message.GetFieldsList();
        var field;

        if (signInfo) {
            for (cnt = 0; cnt < signInfo.length; cnt++) {
                field = message.GetListItem(fields, signInfo[cnt]);

                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
            }
        }
    } catch (e) {
        alert("UndoSignInfo(signInfo)" + e.description);
    }
}
function getDraftInfo() {
    try {
        pFormHref = FormHref;
        pDraftFlag = DraftFlag;
        pDocType = DocType;

        pSusinSN = SusinSN;
        pDocState = DocState;
        pDocState = ConvertDocState(pDocState);

        if (pDraftFlag == "SUSIN") {
            pSusinSN = SusinSN;
            pDocType = DocType;
            pDocState = DocState;

            pDocType = ConvertDocType(pDocType);
            pDocState = ConvertDocState(pDocState);
        }
        else if (pDraftFlag == "HAPYUI") {
            pDocType = DocType;
            pDocState = DocState;

            pDocType = ConvertDocType(pDocType);
            pDocState = ConvertDocState(pDocState);
        }
    } catch (e) {
        alert("getDraftInfo()" + e.description);
    }
}
function ConvertDocType(pDocType) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getCodeData.do",
		data : {
			code1 : "",
			code2 : pDocType,
			flag  : "CODE"
		},
		success: function(xml){
			result = xml;
		}        			
	});

    return SelectSingleNodeValue(result, "RESULT");
}
function ConvertDocState(pDocState) {
	var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getCodeData.do",
		data : {
			code1 : "A02",
			code2 : pDocType,
			flag  : "CODE"
		},
		success: function(xml){
			result = xml;
		}        			
	});

    return SelectSingleNodeValue(result, "RESULT");
}

var getformcont_cross_dialogArguments = new Array();
function openFormUI() {
    try {
        var parameter = new Array();
        parameter[0] = arr_userinfo[4];
        parameter[1] = "000";

        getformcont_cross_dialogArguments[0] = parameter;
        getformcont_cross_dialogArguments[1] = openFormUI_Complete;

        DivPopUpShow(713, 570, "/ezApprovalG/getFormCont.do");
    }
    catch (e) {
        alert("openFormUI()" + e.description);
    }
}

function openFormUI_Complete(ret) {
    DivPopUpHidden();

    pFormHref = ret[0];
    pDocType = ret[1];

    if (pFormHref == "PC") {
        document.getElementById('pFile').click();
        if (rtnval) {
            pReadPC = true;
            noFieldsAvailable = false;

            lstAttachLink.innerHTML = "";
            AppendFileAttach = "";
            AppenAprDocAttachList = "";
            window_onbeforeunload();
            pFormID = "";
            pDocID = "";
            pDraftFlag = "DRAFT";

            pSummery = "";
            pSpecialRecordCode = "";
            pPublicityCode = "";
            pLimitRange = "";
            pPageNum = "1";
            cabinetID = "";
            TaskCode = "";
            DocNumCode = "";

            tempSecurity = "";
            tempKeep = "";
            tempUrgent = "N";
            tempPublic = "Y";
            tempKeyword = "";
            tempItemCode = "";
            tempItemName = "";
            tempdocnumcode = strLang107;

            tempSecurityDate = "";
        }
    }
    else {
        if (pFormHref != "cancel") {
            pReadPC = false;

            pFormID = "";
            pDocID = "";
            SetBtnStateTrue();
            lstAttachLink.innerHTML = "";
            AppendFileAttach = "";
            AppenAprDocAttachList = "";
            window_onbeforeunload();
            pFormID = "";
            pDocID = "";
            pDraftFlag = "DRAFT";
            pSummery = "";
            pSpecialRecordCode = "";
            pPublicityCode = "";
            pLimitRange = "";
            pPageNum = "1";
            cabinetID = "";
            TaskCode = "";
            DocNumCode = "";
            tempSecurity = "";
            tempKeep = "";
            tempUrgent = "N";
            tempPublic = "Y";
            tempKeyword = "";
            tempItemCode = "";
            tempItemName = "";
            tempdocnumcode = strLang107;
            tempSecurityDate = "";

            message.Set_EditorContentURL(pFormHref);
        }
    }
}

var form_check_ui_cross_dialogArguments = new Array();
function Form_check() {
    try {
        form_check_ui_cross_dialogArguments[0] = "";
        form_check_ui_cross_dialogArguments[1] = Form_check_Complete;
        DivPopUpShow(330, 205, "/ezApprovalG/formCheckUI.do");
    } catch (e) {
        alert("openFormUI()" + e.description);
    }
}

function Form_check_Complete(pCheck) {
    DivPopUpHidden();
    if (pCheck.toUpperCase() == "OK")
        openForm();
}

function SetBtnStateFalse() {
    try {
        setMenuBar("btnSetAprLine", false);
        setMenuBar("btnSetReceivLine", false);
        setMenuBar("btnSendDraft", false);
        setMenuBar("btnDocInfo", false);
        setMenuBar("btnFileAttach", false);
        setMenuBar("btnAprDocAttach", false);
        setMenuBar("btnOpinion", false);
        setMenuBar("btnSave", false);
        setMenuBar("btnConn", false);

        if (pDraftFlag == "REDRAFT") {
            setMenuBar("btnSaveServer", false);
        }
        else {
            setMenuBar("btnSaveServer", true);
        }
    } catch (e) {
        alert("SetBtnStateFalse()" + e.description);
    }
}
function SetBtnStateTrue() {
    try {
        setMenuBar("btnSelForm", true);
        setMenuBar("btnSetAprLine", true);
        setMenuBar("btnSetReceivLine", true);
        setMenuBar("btnSendDraft", true);
        setMenuBar("btnDocInfo", true);
        setMenuBar("btnFileAttach", true);
        setMenuBar("btnAprDocAttach", true);
        setMenuBar("btnOpinion", true);
        btnClose.style.diplay = "";
        setMenuBar("btnPrint", true);

        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
            setMenuBar("btnSelForm", false);
        }

        if (pDraftFlag == "REDRAFT") {
            setMenuBar("btnSaveServer", false);
        }
        else {
            setMenuBar("btnSaveServer", true);
        }

    } catch (e) {
        alert("SetBtnStateTrue()" + e.description);
    }
}
function createNewDoc() {
    try {
    	var result = "";
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/createNewDoc.do",
    		data : {
    			formID : pFormID,
    			xdocID : ""
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});
        if (result == "False") {
            var pAlertContent = strLang131 + "<br> " + strLang132;
            OpenAlertUI(pAlertContent);
        } else {
            return result;
        }
    } catch (e) {
        alert("createNewDoc()" + e.description);
    }
}
function getDraftUserInfo() {
    try {
    	$.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezOrgan/getADInfos.do",
    		data : {
    			cn : pUserID,
    			prop : "displayName;mail;description;company;facsimileTelephoneNumber;telephoneNumber;streetaddress;postalcode",
    			cate  : "user"
    		},
    		success: function(xml){
    			xmluserInfo = xml;
    		}        			
    	});
    } catch (e) {
        alert("getDraftUserInfo()" + e.description);
    }
}
function SetAutoPropertyValue() {
    try {
        var fields = message.GetFieldsList();

        if (!fields) return;

        var fieldname;
        var field;
        var pSusinNextSN;
        var objNodes;
        var CurrentDate;
        var tmpdocNum = message.DocumentBodyGetAttribute("orgdocnum");

        if (!tmpdocNum) {
            var field = message.GetListItem(fields, "docnumber");
            if (field)
                message.DocumentBodySetAttribute("orgdocnum", getfieldValue(field));

            var field = message.GetListItem(fields, "bedocnumber");
            if (field)
                message.DocumentBodySetAttribute("orgdocnum", getfieldValue(field));
        }

        objNodes = xmluserInfo.documentElement;

        var FullDate = getGyulJeFullDate();
        CurrentDate = getGyulJeDate();
        var SendName = getDeptSendName(arr_userinfo[4]);

        SignInfo = "";
        hapyuiCount = 0;
        SignCount = 0;
        gamsaCount = 0;
        for (var i = 0 ; i < fields.length ; i++) {
            var field = fields[i];

            if (!fields) return;

            if (pDraftFlag == "DRAFT") {
                switch (field.id) {
                    case "bedocnumber":
                        setDocNumFormat("be");
                        break;

                    case "docnumber":
                        setDocNumFormat("");
                        break;

                    case "enforcedate":
                        field.textContent = "";
                        if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                        break;

                    case "receiptdate":
                        field.textContent = "";
                        if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                        break;

                    case "recipient":
                        break;

                    case "refer":
                        break;

                    case "zipcode":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "POSTALCODE")[0]);
                        break;

                    case "address":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "STREETADDRESS")[0]);
                        break;

                    case "telephone":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "TELEPHONENUMBER")[0]);
                        break;

                    case "depttelephone":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "TELEPHONENUMBER")[0]);
                        break;

                    case "fax":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "FACSIMILETELEPHONENUMBER")[0]);
                        break;

                    case "deptfax":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "FACSIMILETELEPHONENUMBER")[0]);
                        break;

                    case "department":
                        field.textContente = arr_userinfo[5];
                        break;

                    case "parantdept":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "COMPANY")[0]);
                        break;

                    case "seniorposition":
                        break;

                    case "seniorname":
                        break;

                    case "charge":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "DISPLAYNAME")[0]);
                        break;

                    case "position":
                        field.textContent = arr_userinfo[3];
                        break;

                    case "email":
                        field.textContent = arr_userinfo[8];
                        break;

                    case "keepperiod":
                        break;

                    case "publication":
                        break;

                    case "examname":
                        break;

                    case "examdate":
                        break;

                    case "headcampaign":
                        break;

                    case "deptname":
                        field.textContent = arr_userinfo[5];
                        break;

                    case "seal":
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "COMPANY")[0]) + "대표이사";// + strLang148;
                        break;

                    case "username":         
                        field.textContent = arr_userinfo[2];
                        break;

                    case "draftername":      
                        field.textContent = arr_userinfo[2];
                        break;

                    case "draftdate":
                        field.textContent = FullDate;
                        break;

                    case "deptshortedname":
                        field.textContent = DeptSymbol + ":";
                        break;

                    case "organ":
                        if (trim(SendName) != "")
                            field.textContent = SendName;
                        break;

                    case "chief":
                        if (SendName != "")
                            field.textContent = SendName + "장";
                        break;
                }
            } else {
                switch (field.id) {
                    case pSusinSN + "receiptdate":
                        field.textContent = CurrentDate;
                        break;
                }
            }
            if (pDraftFlag == "SUSIN" || pDocState == "011") {
                var pSignSusin = pSusinSN + "sign";

                if (field.id.substr(0, 5) == pSignSusin) {
                    SignCount = SignCount + 1;
                }
            } else {
                if (field.id.substr(0, 4) == "sign") {
                    SignCount = SignCount + 1;
                }
            }
            if (field.id.substr(0, 10) == "habyuisign") {
                hapyuiCount = hapyuiCount + 1;
            }
            if (field.id.substr(0, 10) == "gamsasign1") {
                gamsaCount = gamsaCount + 1;
            }
            if (field.id.substr(0, 7) == "gongram") {
                gongramCount = gongramCount + 1;
            }
            if (pDraftFlag == "SUSIN" || pSusinSN != "0") {
                var pSignInfoSusin = pSusinSN + "jikwe";

                if (field.id.substr(0, 6) == pSignInfoSusin) {
                    if (SignInfoFlag) {
                        SignInfo = field.textContent;
                        SignInfoFlag = false;
                    } else {
                        SignInfo = field.textContent + ";" + SignInfo;
                    }
                }
            } else {
                if (field.FieldID.substr(0, 5) == "jikwe") {
                    if (SignInfoFlag) {
                        SignInfo = field.textContent;
                        SignInfoFlag = false;
                    } else {
                        SignInfo = field.textContent + ";" + SignInfo;
                    }
                }
            }
        }
        pSuSinFlag = "N";
        if (pDraftFlag != "SUSIN" && pDocState != "011") {
            var RtnVal = message.GetListItem(fields, "recipient");

            if (RtnVal != null) {
                pSuSinFlag = "Y";
                setMenuBar("btnSetReceivLine", true);
                CheckGubun = "1";
            } else {
                pSuSinFlag = "N";
                setMenuBar("btnSetReceivLine", false);
                CheckGubun = "11";
            }
        }
        if (pSusinSN)
            pSusinNextSN = parseInt(pSusinSN) + 1;
        else
            pSusinNextSN = 1;

        fieldname = pSusinNextSN + "sign1";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            pSuSinFlag = "Y";

            setMenuBar("btnSetReceivLine", true);
            CheckGubun = "1";
        }
        else {

            if (pSuSinFlag == "N") {
                pSuSinFlag = "N";
                setMenuBar("btnSetReceivLine", false);
                CheckGubun = "11";
            }
        }
        RtnVal = message.GetListItem(fields, "refer");
        if (RtnVal != null) {
            pChamJoFlag = "Y";
        } else {
            pChamJoFlag = "N";
        }
        pChamJoFlag = "Y";

    } catch (e) {
        alert("SetAutoPropertyValue()" + e.description);
    }
}
function SetAutoPropFinal() {
    try {
        var fields = message.GetFieldsList();

        if (!fields) return;
        var CurrentDate;
        CurrentDate = getGyulJeDate();
        for (i = 0 ; i < fields.length ; i++) {
            var field = fields[i];

            if (!fields) return;

            if (pDraftFlag == "DRAFT") {
                switch (field.id) {
                    case "sentdate":
                        field.textContent = CurrentDate;
                        break;
                }
            }
        }
    } catch (e) {
        alert("SetAutoPropFinal()" + e.description);
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

        apropinion_cross_dialogArguments[0] = parameter;
        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;

        DivPopUpShow(530, 520, "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion_Cross.aspx");

    } catch (e) {
        alert("openOpinionUI(pOpinionFlag)" + e.description);
    }
}

function openOpinionUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel") {
        var NodeList;
        var objXML = createXmlDom();

        objXML = loadXMLString(ret);
        NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

        if (NodeList.length != 0) {
            pHasOpinionYN = "Y";
        } else {
            pHasOpinionYN = "N";
            ret = "cancel";
        }
        makeOpinionList(objXML);
    }
}

function makeOpinionList(OpinionXML) {
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, "opinions");
    if (!field) return;

    var firstFlag = true;
    var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
    if (NodeList.length > 0) {
        var strOpinion = " ";
        for (i = NodeList.length - 1; i >= 0; i--) {
            if (getNodeText(NodeList[i].childNodes[9]) == "001") {
                if (firstFlag) {
                    strOpinion = "<P>[" + strLang27 + "</P>";
                    firstFlag = false;
                }
                if (getNodeText(NodeList[i].childNodes[2]) != "")
                    strOpinion = strOpinion + "<P>" + getNodeText(NodeList[i].childNodes[2]) + "&nbsp;&nbsp;&nbsp;";  
                else
                    strOpinion = strOpinion + "<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";  

                strOpinion = strOpinion + getNodeText(NodeList[i].childNodes[1]) + "&nbsp;&nbsp;&nbsp;";
                strOpinion = strOpinion + getNodeText(NodeList[i].childNodes[6]) + "</P>";
            }
        }
        field.innerHTML = strOpinion;
    }
    else {
        field.innerHTML = " ";
    }
}

var aprattach_cross_dialogArguments = new Array();
function openFileAttachUI() {
    try {
        aprattach_cross_dialogArguments[0] = "";
        aprattach_cross_dialogArguments[1] = "";

        DivPopUpShow(535, 285, "/myoffice/ezApprovalG/ezAPRATTACH/AprAttach_cross.aspx?FormID=" + escape(pFormID) + "&DocID=" + escape(pDocID) + "&DraftFlag=" + DraftFlag);
    } catch (e) {
        alert("openFileAttachUI()" + e.description);
    }
}

var aprcabinetattach_cross_dialogArguments = new Array();
function openAaprDocAttachUI() {
    try {
        var parameter = pDocID;
        var url = "/myoffice/ezApprovalG/ezAprDocAttach/aprCabinetAttach_Cross.aspx?" + "DraftFlag=" + DraftFlag;

        if (CrossYN() || NonActiveX == "YES") {
            aprcabinetattach_cross_dialogArguments[0] = parameter;
            aprcabinetattach_cross_dialogArguments[1] = openAaprDocAttachUI_Complete;

            DivPopUpShow(800, 370, url);
        }
        else {
            var feature = "status:no;dialogWidth:675px;dialogHeight:395px;edge:sunken;scroll:no;help:no";
            feature = feature + GetShowModalPosition(675, 395);

            var ret = window.showModalDialog(url, parameter, feature);
            if (ret != "cancel") {
                setAttachInfo(pDocID, "APR", lstAttachLink);
            }
            return ret;
        }
    } catch (e) {
        alert("openAaprDocAttachUI()" + e.description);
    }
}

function openAaprDocAttachUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel") {
        setAttachInfo(pDocID, "APR", lstAttachLink);
    }
}
function SaveDraftDocInfo() {
    var rtnVal;
    SaveFile();
    rtnVal = SaveDraftDocInfo_ilban("002");
    rtnVal = SaveFile();
    if (rtnVal.toUpperCase() != "TRUE") {
        SaveOrgFile();
    }
    return rtnVal;
}

function SaveDraftDocInfo_ilban(pState) {
    try {
        var fields = message.GetFieldsList();
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
            createNodeAndInsertText(xmlpara, objNode, "OrgDocID", pDocID);
            createNodeAndInsertText(xmlpara, objNode, "DocType", pDocType);
            createNodeAndInsertText(xmlpara, objNode, "DocState", pDocState);
        }
        else {
            createNodeAndInsertText(xmlpara, objNode, "OrgDocID", "");
            createNodeAndInsertText(xmlpara, objNode, "DocType", "");
            createNodeAndInsertText(xmlpara, objNode, "DocState", "");
        }

        createNodeAndInsertText(xmlpara, objNode, "FunctionType", pState);
        createNodeAndInsertText(xmlpara, objNode, "Href", "/document/doc/" + pDocID + ".htm");

        //field = message.GetListItem(fields, "doctitle");
        createNodeAndInsertText(xmlpara, objNode, "DocTitle", message.GetDocTitle());

        var field = message.GetListItem(fields, "docnumber");
        var deptfield = message.GetListItem(fields, "deptshortedname");
        if (deptfield) {
            createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(deptfield));
        }
        else if (field) {
            createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
        }
        else {
            var field = message.GetListItem(fields, "bedocnumber");
            if (field)
                createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
            else
                createNodeAndInsertText(xmlpara, objNode, "DocNo", "");
        }

        createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", pHasOpinionYN);

        var startdate;
        if (pState == strAprState0)
            startdate = "DRAFTSAVE";
        else
            startdate = "DRAFT";
        createNodeAndInsertText(xmlpara, objNode, "StartDate", startdate);
        createNodeAndInsertText(xmlpara, objNode, "EndDate", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WriterID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "WriterName", arr_userinfo[2]);
        createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", arr_userinfo[3]);
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", arr_userinfo[5]);
        createNodeAndInsertText(xmlpara, objNode, "Html", "");
        createNodeAndInsertText(xmlpara, objNode, "OrgHtml", "");
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[2]);
        createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

        createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);

        createNodeAndInsertText(xmlpara, objNode, "public", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "ItemCode", tempItemCode);
        createNodeAndInsertText(xmlpara, objNode, "ItemName", tempItemName);
        createNodeAndInsertText(xmlpara, objNode, "UrgentApproval", tempUrgent);
        createNodeAndInsertText(xmlpara, objNode, "KeyWord", tempKeyword);
        createNodeAndInsertText(xmlpara, objNode, "Xdocid", "");

        createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
        createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
        createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
        createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
        createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
        if (!g_SepAttachLVXml)
            createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", GetSepAttParamXml(g_SepAttachLVXml));

        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);

        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);

        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);

        xmlhttp.open("POST", "aspx/dodraft.aspx", false);
        xmlhttp.send(xmlpara);

        if (pState != "000")
            SetBtnStateFalse();
        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        return getNodeText(dataNodes[0]);
    } catch (e) {
        alert("SaveDraftDocInfo_ilban(pState)" + e.description);
    }
}
function getfieldValue(pfield) {
    var rtnVal = "";
    if (pfield) {
        switch (pfield.tagName) {
            case "TD":
                rtnVal = getNodeText(pfield)
                break;
            case "SELECT":
                rtnVal = getNodeText(pfield)
                break;
            case "INPUT":
                rtnVal = getNodeText(pfield)
                break;
        }
    }
    return rtnVal;
}

var aprsign1_cross_dialogArguments = new Array();
function openSignUI() {
    try {
        var objRoot;
        var objNode;
        var SignNodeList;

        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);

        xmlhttp.open("Post", "../ezAPRSIGN/aspx/GetSignRequest.aspx", false);
        xmlhttp.send(xmlpara);

        SignNodeList = SelectNodes(xmlhttp.responseXML, "LISTVIEWDATA/ROWS/ROW");

        if (SignNodeList.length != 0) {
            var parameter = pUserID;

            aprsign1_cross_dialogArguments[0] = parameter;
            aprsign1_cross_dialogArguments[1] = openSignUI_Complete;

            DivPopUpShow(350, 310, "/myoffice/ezApprovalG/ezAPRSIGN/AprSign1_Cross.aspx");
        } else {
            openSignUI_Complete("NAME");
        }
    } catch (e) {
        alert("openSignUI()" + e.description);
    }
}

function openAprLineUI() {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;
        parameter[1] = pFormID;
        parameter[2] = SignCount;
        parameter[3] = SignInfo;
        parameter[4] = hapyuiCount;
        parameter[5] = pDraftFlag;
        parameter[6] = pSuSinFlag;
        parameter[7] = pChamJoFlag;
        parameter[8] = gongramCount;
        parameter[9] = false;
        parameter[10] = pDocType;
        parameter[11] = gamsaCount;
        parameter[12] = "";
        var url = "../ezAPRLINE/aprline_Cross.aspx";
        var feature = "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(990, 720);
        var ret = window.showModalDialog(url, parameter, feature);
        return ret;
    } catch (e) {
        alert("openAprLineUI()" + e.description);
    }
}
function openReceivUI() {
    var parameter = new Array();
    isExtDoc = message.DocumentBodyGetAttribute("EXTDOC");
    if (isExtDoc != "Y") isExtDoc = "N";

    parameter[0] = pFormID;
    parameter[1] = pDocID;
    parameter[2] = "SEND"
    parameter[3] = isExtDoc;
    parameter[4] = DocType;

    var url = "../ezAPRDEPT/AprDept1_Cross.aspx";
    var feature = "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(855, 530);
    var ret = window.showModalDialog(url, parameter, feature);
    return ret
}

function GetAprDocFormID() {
    try {
        var objRoot;
        var objNode;

        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

        xmlhttp.open("Post", "aspx/GetAprDocFormID.aspx", false);
        xmlhttp.send(xmlpara);
        pFormID = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/FORMID");
    } catch (e) {
        alert("GetAprDocFormID()" + e.description);
    }
}
function trim(parm_str) {
    if (parm_str == "")
        return ""
    else
        return rtrim(ltrim(parm_str));
}
function ltrim(parm_str) {
    var str_temp = parm_str;
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
    var str_temp = parm_str;
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
function getGyulJeFullDate() {
    try {

        var xmlhttp = createXMLHttpRequest();

        xmlhttp.open("POST", "/ezApprovalG/getFullDate.do", false);
        xmlhttp.send();

        return xmlhttp.responseText;

    } catch (e) {
        alert("getGyulJeFullDate()" + e.description);
    }
}
function setSusinUpdataDocID() {
    try {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pOrgDocID", pOrgDocID);
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

        xmlhttp.open("POST", "aspx/setSusinUpdateDocID.aspx", false);
        xmlhttp.send(xmlpara);

        return xmlhttp.responseText;
    } catch (e) {
        alert("setSusinUpdataDocID()" + e.description);
    }
}
function setInitLoadDocCellInfo() {
    try {
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
        var SignArray = new Array();
        var SignArrayLen;

        SignArray[0] = "sign";
        SignArray[1] = "habyuisign";

        var fieldSN = 1;
        var fieldNum = 1;
        var fields = message.GetFieldsList();

        SignArrayLen = SignArray.length;

        if (!fields) return;

        for (k = 0 ; k < SignArrayLen ; k++) {
            for (i = 0 ; i < fieldNum ; i++) {
                if (i == "0") {
                    fieldsign = SignArray[k];
                    fieldseumyung = "seumyung";
                    fieldseumyungdate = "seumyungdate";
                } else {
                    fieldsign = i + SignArray[k];
                    fieldseumyung = i + "seumyung";
                    fieldseumyungdate = i + "seumyungdate";
                }
                fieldTmpsign = fieldsign + 1;
                field = message.GetListItem(fields, fieldTmpsign);
                if (field) {
                    for (j = 0 ; j < fieldSN ; j++) {
                        fieldTmpsign = fieldsign + (parseInt(j) + 1);
                        fieldTmpseumyung = fieldseumyung + (parseInt(j) + 1);
                        fieldTmpseumyungdate = fieldseumyungdate + (parseInt(j) + 1);

                        field = message.GetListItem(fields, fieldTmpsign);

                        if (field) {
                            field.textContent = "";
                            field = message.GetListItem(fields, fieldTmpseumyung)
                            if (field) {
                                field.textContent = "";
                            }

                            field = message.GetListItem(fields, fieldTmpseumyungdate)
                            if (field) {
                                field.textContent = "";
                            }

                            fieldSN = parseInt(fieldSN) + 1;

                        } else {
                            fieldNum = parseInt(fieldNum) + 1;
                            break;
                        }
                    }
                }
                else {
                    break;
                }
            }
        }
    } catch (e) {
        alert("setInitLoadDocCellInfo()" + e.description);
    }
}
var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN() || NonActiveX == "YES") {
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

    if (CrossYN() || NonActiveX == "YES") {
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
function getDocInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

    xmlhttp.open("Post", "../aspx/getDocInfo.aspx", false);
    xmlhttp.send(xmlpara);
    xmldoc = xmlhttp.responseXML;

    var objNodes = xmldoc.documentElement.childNodes;
    if (objNodes) {
        pOrgDocID = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/ORGDOCID");
        if (SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/HASOPINIONYN") == "Y" || SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/HASOPINIONYN") == "O")
            pHasOpinionYN = "Y";

        tempSecurity = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/SECURITYCODE");
        tempKeep = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/STORAGEPERIOD");
        tempUrgent = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/URGENTAPPROVAL");
        tempPublic = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/ISPUBLIC");
        tempKeyword = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/KEYWORD");
        tempItemCode = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/ITEMCODE");
        tempItemName = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/ITEMNAME");

        pSummery = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/SUMMARY");
        pSpecialRecordCode = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/SPECIALRECORDCODE");
        pPublicityCode = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/PUBLICITYCODE");
        pLimitRange = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/LIMITRANGE");
        pPageNum = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/PAGENUM");
        cabinetID = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/CABINETID");
        TaskCode = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/TASKCODE");

        tempSecurityDate = SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA/SECURITYAPPROVAL");
    }
}
function changeEditMode() {
}
function HabyuiResultOpinion() {
    try {
        var parameter = new Array();
        var rtnVal = true

        parameter[0] = "";
        parameter[1] = "N";
        parameter[2] = KuyjeType;
        parameter[3] = pOrgDocID;

        var url = "../ezAPROPINION/AprOpinion_Cross.aspx";
        var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
        feature = feature + GetShowModalPosition(530, 520);
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            var NodeList;
            var objXML = createXmlDom();

            objXML.loadXML(ret);
            NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0)
                rtnVal = true;
            else
                rtnVal = true;
        }
        return rtnVal;
    } catch (e) {
        alert("HabyuiResultOpinion()" + e.description);
    }
}
function setDocNumFormat(pPrefix) {
    var Arr_Header = new Array()
    var Header, Tail
    var i
    var d = new Date();

    var numHeader = ""

    var fields = message.GetFieldsList();

    if (pDraftFlag == "REDRAFT") return;

    var field = message.GetListItem(fields, pPrefix + "docnumber")
    if (!field) return

    var fieldValue = message.DocumentBodyGetAttribute("orgdocnum", 0);

    Arr_Header = fieldValue.split("@")

    for (i = 1; i < Arr_Header.length; i++) {
        Header = Arr_Header[i].substr(0, 2);
        Tail = Arr_Header[i].substr(2);

        switch (Header) {
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
                if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
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

    field.textContent = numHeader;
    if (numHeader.indexOf(strLang107) > 0)
        message.DocumentBodySetAttribute("docnum", numHeader);

    var field = message.GetListItem(fields, "receiptnumber");
    if (field) {
        field.setAttribute("Format", field.textContent);
        message.DocumentBodySetAttribute("receiptnumber", field.textContent);
        field.textContent = "";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }
}

var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd() {
    var parameter = pUserID;

    ezchkpasswd_cross_dialogArguments[0] = parameter;
    ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

    DivPopUpShow(330, 200, "/myoffice/ezApprovalG/ezchkPasswd_Cross.aspx");
}

function setDrafterAddress() {
    message.DocumentBodySetAttribute("drafter", arr_userinfo[2]);
    message.DocumentBodySetAttribute("address", arr_userinfo[8]);
    message.DocumentBodySetAttribute("drafterdept", arr_userinfo[4]);
    message.DocumentBodySetAttribute("lastKyulName", lastKyulName);
    message.DocumentBodySetAttribute("lastKyuljikwee", lastKyuljiwee);
}
function setFirstDrafter() {
    var ret = getAutoAprLine();

    if (ret[0] != "NONE") {
        IsSkipDrafter = "FALSE";
        btnSendDraftEnable = "true";
        ret[1] = ret[0];
        ret[5] = ret[2];
        GetDraftAprLineInfo(ret);
    }
    return;
}
function delOpinionInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "DocID", "002");

    xmlhttp.open("POST", "../ezAPROPINION/aspx/DeleteOpinionTypeInfo.aspx", false);
    xmlhttp.send(xmlpara);

    pHasOpinionYN = "";
    return xmlhttp.responseText;
}
function deltmpDocinfo(pSN) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "SN", pSN);

    xmlhttp.open("POST", "aspx/delTMPDocInfo.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
function removeDocInfo() {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "FIELD", "CHECK");

    xmlhttp.open("POST", "../ReceivUI/aspx/deldocinfo.aspx", false);
    xmlhttp.send(xmlpara);
}
function CheckMem(DeptID) {
	var result = "";
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezOrgan/getADInfos.do",
		data : {
			cn : DeptID,
			prop : "displayName",
			cate  : "group"
		},
		success: function(xml){
			result = xml;
		}        			
	});

    return getXmlString(result);
}
function getDeptSymbol(DeptID, DeptName) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
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
	
    var dataNodes = GetChildNodes(result.documentElement);
    var RtnVal = getNodeText(dataNodes[0]);

    if (RtnVal == "") {
        return DeptName;
    }
    else {
        return RtnVal;
    }
}
function getDeptSendName(DeptID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezOrgan/getADInfos.do",
		data : {
			cn : DeptID,
			prop : "extensionAttribute5",
			cate  : "group"
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    return trim(SelectSingleNodeValue(result, "EXTENSIONATTRIBUTE5"));
}
function setMenuBar(id, flag) {
    var strCmd, display_Value

    if (flag)
        display_Value = ""
    else
        display_Value = "none"


    strCmd = id + ".style.display='" + display_Value + "'"
    eval(strCmd);
}
function SaveFile() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var mhtBody = "";
    mhtBody = message.Get_EditorBodyHTML();
    EmbedContentIntoXML(mhtBody);
    mhtBody = ConvertHTMLtoMHT(mhtBody);

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Html", mhtBody);

    xmlhttp.open("POST", "../aspx/saveFile.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
function SignSave() {
    if (SignContent.length > 0) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objRoot, objNode, subNode;
        objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

        for (i = 0; i < SignContent.length; i++) {
            objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "SIGNINFO");
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", pDocID);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNTYPE", SignType[i]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNNAME", SignName[i]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "CONTENT", SignContent[i]);
        }
        xmlhttp.open("Post", "../ezAPRSIGN/aspx/setSignInfo.aspx", false);
        xmlhttp.send(xmlpara);
    }
}

function SaveOrgFile() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var mhtBody = "";
    mhtBody = "<HTML>" + GetCKEditerHeader() + pOrgHtml + "</HTML>";
    mhtBody = ConvertHTMLtoMHT(mhtBody);

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Html", mhtBody);

    xmlhttp.open("POST", "../aspx/saveFile.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
function SignCheck() {
    var SignXML = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);


    xmlhttp.open("Post", "../ezAPRSIGN/aspx/getSignInfo.aspx", false);
    xmlhttp.send(xmlpara);

    if (getXmlString(xmlhttp.responseXML) == "")
        return;

    var NodeList;
    if (SelectNodes(xmlhttp.responseXML, "SIGNINFOS/SIGNINFO")) {
        NodeList = SelectNodes(xmlhttp.responseXML, "SIGNINFOS/SIGNINFO");
        if (NodeList.length <= 0)
            return;
    }
    SignXML = xmlhttp.responseXML;

    var rtnVal = putSignXML(SignXML);
    if (rtnVal) {
        SaveFile();

        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("Post", "../ezAPRSIGN/aspx/delSignInfo.aspx", false);
        xmlhttp.send(SignXML);
    }
}
function putSignXML(SignXML) {
    var retVal = false;
    try {
        var NodeList;
        var fields = message.GetFieldsList();
        var field;

        NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
        if (NodeList.length > 0) {
            for (i = 0; i < NodeList.length; i++) {
                var SignType = getNodeText(SelectSingleNode(NodeList[i], "SIGNTYPE"));
                var SignName = getNodeText(SelectSingleNode(NodeList[i], "SIGNNAME"));
                var SignCont = getNodeText(SelectSingleNode(NodeList[i], "CONTENT"));

                var field = message.GetListItem(fields, SignName);
                if (field) {
                    retVal = true;
                    if (SignType == "TEXT" || SignType == "HTML") {
                        field.innerHTML = SignCont;
                    }
                    else {
                        var img = SignCont.split("::");
                        var signWidth = field.offsetWidth
                        var signHeight = field.offsetHeight

                        if (signWidth > signHeight) {
                            signHeight = signHeight - 15;
                            signWidth = signHeight;
                        }
                        else {
                            signWidth = signWidth - 15;
                            sighHeight = signWidth
                        }
                        signWidth = 50;
                        signHeight = 28;

                        var strimg;
                        if (img.length >= 1) {
                            strimg = "<img src='" + document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(img[0]) + "' border=0 embedding='1' "; //20110209 exchange2010 적용후 결재문서 메일 발송시 이미지깨짐
                            strimg = strimg + " width=" + signWidth;
                            strimg = strimg + " height=" + signHeight + " spath='" + escape(img[0]) + "'>";
                            message.DocumentBodySetAttribute(SignName, img[0]);
                        }

                        if (img.length >= 2 && img[1] != "") {
                            field.innerHTML = img[1] + "<br>" + strimg;
                        }
                        else {
                            field.innerHTML = strimg;
                        }

                    }

                }
            }
        }
    } catch (e) {
        alert("putSignXML : " + e.description);
        return false;
    }
    return retVal;
}
function UndoDoc() {
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/undoDoc.do",
		data : {
			docID  : pDocID
		},
		success: function(xml){
		}        			
	});
}
function getSignDate() {
    var GyulJeDate;
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "getDate", "");

    xmlhttp.open("POST", "../aspx/GetSignDate.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
function getHistory() {
    var URL = "../ezAPRHISTORY/ezAPRHISTORY_Cross.aspx?DocID=" + pDocID;
    centerOpenWindow(URL, 730, 430);
}
function centerOpenWindow(wfileLocation, wWeight, wHeight) {
    try {
        if (CrossYN() || NonActiveX == "YES") {
            DivPopUpShow(wWeight, wHeight, wfileLocation);
        }
        else {
            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;
            var left = (width - wWeight) / 2;
            var top = (heigth - wHeight) / 2;
            window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
        }
    } catch (e) {
        alert("centerOpenWindow :: " + e.description);
    }
}

function UpdateDocHistory(pHtml) {
    var xmlhttp2 = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pHtml", pHtml);

    xmlhttp2.open("POST", "../ezAPRHISTORY/aspx/UploadDocHistory.aspx", false);
    xmlhttp2.send(xmlpara);

    var URL = xmlhttp2.responseText;

    if (URL.length < 255 && URL != "FALSE") {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pURL", URL);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", arr_userinfo[16]);

        xmlhttp.open("POST", "../ezAPRHISTORY/aspx/UpdateDocHistory.aspx", false);
        xmlhttp.send(xmlpara);
        if (SelectSingleNodeValue(xmlhttp.responseXML, "RESULT") == "TRUE") {
        }
        else {
            var pAlertContent = strLang89;
            OpenAlertUI(pAlertContent);
        }
    }
    else {
        var pAlertContent = strLang90;
        OpenAlertUI(pAlertContent);
    }
}
function UpdateLineHistory() {
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
    xmlhttp.open("POST", "../ezAPRHISTORY/aspx/UpdateLineHistory.aspx", false);
    xmlhttp.send(xmlpara);

    var DataNodes = GetChildNodes(xmlhttp.responseXML);
    var rtnVal = getNodeText(DataNodes[0]);
    if (rtnVal == "TRUE") {
    }
    else {
        var pAlertContent = strLang91;
        OpenAlertUI(pAlertContent);
    }
}
function getOpinionCount() {
    try {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "chkFlag", "ING");
        xmlhttp.open("POST", "../ezAPROPINION/aspx/GetOpinionCount.aspx", false);
        xmlhttp.send(xmlpara);

        var tempValue = parseInt(getXmlString(xmlhttp.responseXML))
        if (tempValue > 0) {
            return true;
        }
        else {
            return false;
        }
    } catch (e) {
        return false;
    }
}

var AutoSave;
function SaveTMPFile(AutoSave) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");

    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

    var mhtBody = "";
    mhtBody = message.Get_EditorBodyHTML();
    mhtBody = "<HTML>" + GetCKEditerHeader() + mhtBody + "</HTML>";
    mhtBody = ConvertHTMLtoMHT(mhtBody);

    createNodeAndInsertText(xmlpara, objNode, "Html", mhtBody);

    xmlhttp.open("POST", "../aspx/saveTmpFile.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}

function SaveTMPDocInfo(AutoSave) {
    try {
        var field;
        var objRoot;
        var objNode;
        var field;
        var AutoSave;
        var fields = message.GetFieldsList();
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");

        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);
        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "OrgDocID", pOrgDocID);
        else
            createNodeAndInsertText(xmlpara, objNode, "OrgDocID", "");

        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "DocType", pDocType);
        else
            createNodeAndInsertText(xmlpara, objNode, "DocType", "");

        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "DocState", pDocState);

        else
            createNodeAndInsertText(xmlpara, objNode, "DocState", "");

        createNodeAndInsertText(xmlpara, objNode, "FunctionType", strAprState1);
        createNodeAndInsertText(xmlpara, objNode, "Href", "/document/doc/" + pDocID + ".htm");

        if (AutoSave != "") {
            createNodeAndInsertText(xmlpara, objNode, "doctitle", message.GetDocTitle());
        }
        else {
            createNodeAndInsertText(xmlpara, objNode, "doctitle", "자동임시저장문서");
        }

        field = message.GetListItem(fields, "docnumber");
        if (field)
            createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));

        else {
            field = message.GetListItem(fields, "be_docnumber");
            if (field)
                createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
            else
                createNodeAndInsertText(xmlpara, objNode, "DocNo", "");
        }

        //var field = fields("deptshortedname")
        //if (field)
        //    objNode.text = getfieldValue(field);
        //xmlpara.documentElement.appendChild(objNode);

        createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", pHasOpinionYN);
        createNodeAndInsertText(xmlpara, objNode, "StartDate", "DRAFTSAVE");
        createNodeAndInsertText(xmlpara, objNode, "EndDate", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WriterID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "WriterName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "Html", "");
        createNodeAndInsertText(xmlpara, objNode, "OrgHtml", "");
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "public", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "ItemCode", tempItemCode);
        createNodeAndInsertText(xmlpara, objNode, "ItemName", tempItemName);
        createNodeAndInsertText(xmlpara, objNode, "UrgentApproval", tempUrgent);
        createNodeAndInsertText(xmlpara, objNode, "KeyWord", tempKeyword);
        createNodeAndInsertText(xmlpara, objNode, "Xdocid", "");
        createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
        createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
        createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
        createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
        createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
        if (!g_SepAttachLVXml)
            createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", GetSepAttParamXml(g_SepAttachLVXml));

        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);
        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);

        xmlhttp.open("POST", "aspx/dodraft.aspx", false);
        xmlhttp.send(xmlpara);

        return xmlhttp.responseText;
    } catch (e) {
        OpenAlertUI("SaveTMPDocInfo()" + e.description);
    }
}

function RemoveTmpDoc(pDocID) {

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "../aspx/RemoveTMPDocInfo.aspx", false);
    xmlhttp.send(xmlpara);

    var RtnVal = xmlhttp.responseText;
    if (RtnVal.indexOf("TRUE") == -1) {
        var pAlertContent = "임시 문서 삭제에 실패하였습니다.!";
        OpenAlertUI(pAlertContent);
    }
}

function setFirstDrafterAuto() {

    var d = new Date();
    var RecieveDay = d.getFullYear() + "." + (d.getMonth() + 1) + "." + d.getDate();

    var pxml
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    pxml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang331 + "</NAME><WIDTH>100</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>100</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>150</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>150</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>100</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang332 + "</NAME><WIDTH>120</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang333 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>"
    pxml = pxml + "<ROWS><ROW><COLUMN>1</COLUMN>"
    pxml = pxml + "<COLUMN>" + arr_userinfo[2] + "</COLUMN>"
    pxml = pxml + "<COLUMN>" + arr_userinfo[3] + "</COLUMN>"
    pxml = pxml + "<COLUMN>" + arr_userinfo[5] + "</COLUMN>"
    pxml = pxml + "<COLUMN>" + strLang6 + "</COLUMN>"//전결
    pxml = pxml + "<COLUMN>" + strLang18 + "</COLUMN>"//진행
    pxml = pxml + "<DATA name='ProcessDate'></DATA>"
    pxml = pxml + "<DATA name='ReceivedDate'>" + RecieveDay + "</DATA>"
    pxml = pxml + "<DATA name='DocID'>" + pDocID + "</DATA>"
    pxml = pxml + "<DATA name='AprMemberID'>" + arr_userinfo[1] + "</DATA>"
    pxml = pxml + "<DATA name='AprmemberIsDeptYN'>N</DATA>"
    pxml = pxml + "<DATA name='AprMemberDeptID'>" + arr_userinfo[4] + "</DATA>"
    pxml = pxml + "<DATA name='ReasonDoNotApprov'>" + "" + "</DATA>"
    pxml = pxml + "<DATA name='isProposerYN'>N</DATA>"
    pxml = pxml + "<DATA name='isBriefUserYN'>N</DATA>"
    pxml = pxml + "<DATA name='isCompanyID'>" + pCompanyID + "</DATA>"
    pxml = pxml + "<DATA name='AprType'>" + strAprType4 + "</DATA>" //전결
    pxml = pxml + "<DATA name='AprState'>" + strAprState2 + "</DATA>" //진행
    pxml = pxml + "<DATA name='PMemberName'>" + arr_userinfo[11] + "</DATA>"
    pxml = pxml + "<DATA name='SMemberName'>" + arr_userinfo[12] + "</DATA>"
    pxml = pxml + "<DATA name='PMemberDeptName'>" + arr_userinfo[15] + "</DATA>"
    pxml = pxml + "<DATA name='SMemberDeptName'>" + arr_userinfo[16] + "</DATA>"
    pxml = pxml + "<DATA name='PMemberJobTitle'>" + arr_userinfo[13] + "</DATA>"
    pxml = pxml + "<DATA name='SMemberJobTitle'>" + arr_userinfo[14] + "</DATA>"
    pxml = pxml + "</ROW></ROWS></LISTVIEWDATA>"

    xmlpara = loadXMLString(pxml);

    xmlhttp.open("POST", "../ezaprline/aspx/AprLineSave.aspx", false);
    xmlhttp.send(xmlpara);
    //	if(xmlhttp.responseXML.text == "TRUE")
    //	{
    //		var ret = new Array();
    //		ret[0] = pxml;
    //		ret[1] = "NONE";
    //		ret[2] = "R";
    //		ret[3] = "";
    //	
    //		GetDraftAprLineInfo(ret);
    //		btnSendDraft.Enable	= "true";
    //		LastSignSN = 1;
    //	}
    //	else
    //	{
    //		var pAlertContent = strLang742 + "<BR>" + strLang831 + xmlhttp.responseText;
    //		OpenAlertUI(pAlertContent);
    //	}
}
function DeleteDeptInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp.open("Post", "../ezAPRDEPT/aspx/AprDeptDelete.aspx", false);
    xmlhttp.send(xmlpara);
}


function EmbedContentIntoXML(bodyhtml) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = bodyhtml;

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0) {
            var OrgSrc = imgColl.item(i).src;
            var ImgHeight = "0";
            var ImgWidth = "0";
            if (imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/) == null) {
                if (imgColl.item(i).style.width != "")
                    ImgWidth = imgColl.item(i).style.width.replace("px", "");
                if (imgColl.item(i).style.height != "")
                    ImgHeight = imgColl.item(i).style.height.replace("px", "");
            }
            else {
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgWidth = result[1];
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/height="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgHeight = result[1];
            }
            ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
        }
    }
    return bodyhtml;
}

function ConvertSaveImageFile(pUrl, pImgWidth, pImgHeight) {
    var XmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", encodeURIComponent(pUrl));
    createNodeAndInsertText(xmlDom, objNode, "HEIGHT", pImgHeight);
    createNodeAndInsertText(xmlDom, objNode, "WIDTH", pImgWidth);
    createNodeAndInsertText(xmlDom, objNode, "TYPE", "2");
    try {
        XmlHttp.open("POST", "/myoffice/Common/ConvertSaveImage.aspx", false);
        XmlHttp.send(xmlDom);
    }
    catch (e) { }
}