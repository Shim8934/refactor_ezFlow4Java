//sign 정보를 가지고 온다!
var lastKyulName, lastKyuljiwee, LastSignSN;
var DraftLastFlag = false;

//결재선정보 Mapping하는 함수
function GetDraftAprLineInfo(ret) { 
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
	var OrderSuggester = new Array(); 
	var OrderReporter = new Array(); 
	
	var xmldom = createXmlDom();

	if (ret[5] == undefined) {
	    xmlKuljea = ret[0];
	    xmlReDraft = ret[2];
	} else {
	    xmlKuljea = ret[1];
	    xmlReDraft = ret[5];
	}

	if (xmlReDraft == "C") {
		ApplyDocCellInfo();
	} else if (xmlReDraft == "R") {
		ClearDocCellInfo();
	}

	xmldom = loadXMLString(xmlKuljea);
	
	objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
	fields = message.GetFieldsList();
	count = objNodes.length;

	for(i=1; i<200; i++) {
		name = "habyuidate" + i;
		field = message.GetListItem(fields,name);
		if(field) {
	  		if(!trim(field.textContent)) {
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
		} else {
	  		break;
	  	}
	}
	
	//공람(참석)
	for(i=1; i < fields.Count; i++) { 
		field = message.GetListItem(fields, "gongram" + i);
		if(field) field.textContent = "";
	}
	
    //순서를 정리한다.	
	for(i=0; i < count; i++) {
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
	
	/* 2023-11-03 홍승비 - G버전에서는 부서합의문서 접수 시에도 기안자의 대결/전결이 가능하므로, 기안자의 결재유형 체크 변수 추가 */
	CurAprType = OrderType[1];
	
    //마지막사인Index
    LastSignSN = OrderType.length;
    for(i=1;i<OrderType.length;i++) {
		 
    	if(OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40) {
    		LastSignSN = i;
        }	
    }

	 
    if (OrderType[1] == strAprType4 || OrderType[1] == strAprType16) {
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

	for(i=0;i < OrderType.length;i ++) {
		if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) {
			LastSignSN = i;
			i = OrderType.length;
		} else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 ||  OrderType[i] == strAprType1 ||  OrderType[i] == strAprType3) {
    		LastSignSN = i;
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
		if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) {
            fieldname = "jikwe" + idx;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                var jikweName = trim(getNodeText(field));
                setNodeText(field , OrderJobtitle[i]);

                if (OrderSuggester[i] == "Y")
                    setNodeText(field , strLang75 + getNodeText(field));

                if (OrderReporter[i] == "Y")
                    setNodeText(field , strLang76 + getNodeText(field));
            }
            idx = idx + 1;
        }
        else if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
            fieldname = "habyui" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                setNodeText(field , OrderDept[i]);
            }

            fieldname = "habyuipositon" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                var jikweName = trim(getNodeText(field));
                setNodeText(field , OrderJobtitle[i]);

                if (OrderSuggester[i] == "Y")
                    setNodeText(field , strLang75 + getNodeText(field));

                if (OrderReporter[i] == "Y")
                    setNodeText(field , strLang76 + getNodeText(field));
            }
            hidx = hidx + 1;
        }
		
		var field = message.GetListItem(fields, "lineapr");
	    if (field) {
			if (idx > 5) {
				field.style.display = "";
				for (i=0; i<field.childElementCount; i++)
				    field.children[i].style.display = "";
			} else {
				field.style.display = "none";
				for (i=0; i<field.childElementCount; i++)
				    field.children[i].style.display = "none";
			}
		}
	    field = message.GetListItem(fields, "linehab");
		if (field) {
			if (hidx > 5) {
				field.style.display = "";
				for (i=0; i<field.childElementCount; i++)
				    field.children[i].style.display = "";
			} else {
				field.style.display = "none";
				for (i=0; i<field.childElementCount; i++)
				    field.children[i].style.display = "none";
			}	
		}		
	}
	
	//setSignSlash("sign", susinSN);

  }catch(e){
    alert("GetDraftAprLineInfo : " + e.description);
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
        var xmldom = createXmlDom();
        if (pDraftFlag == "REDRAFT") {
            xmlReDraft = "R";
        }
        else {
            xmlReDraft = "C";
        }

        if (ret[5] == undefined) {
            TempsaveAprlineinfo = ret[0];
            xmlKuljea = ret[0];
            setAprLinesXML(xmlKuljea);
        }
        else {
		    TempsaveAprlineinfo = ret[1];
		    xmlKuljea = ret[1];
		    setAprLinesXML(xmlKuljea);
        }

        xmlReDraft = "R";
        if (xmlReDraft == "C") {
            ApplyDocCellInfo();
        } else if (xmlReDraft == "R") {
            ClearDocCellInfo();
        }

        xmldom = loadXMLString(xmlKuljea);
        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        fields = message.GetFieldsList();
        count = objNodes.length;

        for (i = 1; i < 200; i++) {
            name = "habyuidate" + i
            field = message.GetListItem(fields, name);
            if (field) {
                if (!trim(getNodeText(field))) {
                    name = "habyui" + i
                    field = message.GetListItem(fields, name);
                    if (field)
                        setNodeText(field , "");

                    fieldname = "habyuisign" + i;
                    field = message.GetListItem(fields, fieldname);
                    if (field)
                        setNodeText(field , "");

                    fieldname = "habyuipositon" + i;
                    field = message.GetListItem(fields, fieldname);

                    if (field)
                        setNodeText(field , "");
                }
            } else {
                break;
            }
        }

        for (i = 1; i < fields.Count; i++) {
            field = message.GetListItem(fields, "gongram" + i);
            if (field) setNodeText(field,"");
        }

        for (i = 0; i < count; i++) {
            var KyljeaOrder = getNodeText(GetChildNodes(objNodes[i])[0]);
            var KyljeaName = getNodeText(GetChildNodes(objNodes[i])[1]);
            var KyljeaDeptName = getNodeText(GetChildNodes(objNodes[i])[3]);
            var KyljeaType = getNodeText(GetChildNodes(objNodes[i])[16]);
            var KyljeaTypeName = getNodeText(GetChildNodes(objNodes[i])[4]);
            var KyljeaStat = getNodeText(GetChildNodes(objNodes[i])[17]);
            var KyljeaStatName = getNodeText(GetChildNodes(objNodes[i])[5]);
            var KyljeaJobtitle = getNodeText(GetChildNodes(objNodes[i])[2]);
            var ReasonDoNotApprov = getNodeText(GetChildNodes(objNodes[i])[12]);

            OrderType[KyljeaOrder] = KyljeaType;
            OrderTypeName[KyljeaOrder] = KyljeaTypeName;
            OrderName[KyljeaOrder] = KyljeaName;
            OrderDept[KyljeaOrder] = KyljeaDeptName;
            OrderStat[KyljeaOrder] = KyljeaStat;
            OrderStatName[KyljeaOrder] = KyljeaStatName;
            OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
            OrderReason[KyljeaOrder] = ReasonDoNotApprov;
        }

        LastSignSN = OrderType.length
        for (i = 1; i < OrderType.length; i++) {

            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40) {
                LastSignSN = i;
            }
        }

        if (OrderType[1] == strAprType4) {
            DraftLastFlag = true;
        }

        var field = message.GetListItem(fields, "lastKyulName");
        if (field)
            setNodeText(field , OrderName[LastSignSN]);

        hapyuiCnt = 1;
        SignCnt = 1;
        referCnt = 1;
        gongramCnt = 1;

        var fieldname;
        var field;
        var refer;
        refer = "";

        for (i = 0; i < OrderType.length; i++) {
            switch (OrderType[i]) {


                case strAprType1:
                    break;

                case strAprType2:
                    if ((OrderName[i] == arr_userinfo[2]) && (i == 1)) IsSkipDrafter = "TRUE";
                    break;

                case strAprType11: // 부서순차합의
                    if (xmlReDraft == "R") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field)
                            setNodeText(field , OrderDept[i]);

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field)
                            setNodeText(field , OrderName[i]);

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field)
                            setNodeText(field , OrderJobtitle[i]);
                    }
                    else if (xmlReDraft == "C") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26)
                            setNodeText(field , OrderDept[i]);

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26)
                            setNodeText(field , OrderName[i]);

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26)
                            field.Value = OrderJobtitle[i];
                        IsSkipDrafter = "TRUE";
                    }
                    else {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field)
                            setNodeText(field , OrderDept[i]);

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field)
                            setNodeText(field , OrderName[i]);

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field)
                            setNodeText(field , OrderJobtitle[i]);
                    }
                    hapyuiCnt = hapyuiCnt + 1;
                    break;

                case strAprType8: // 개인순차합의
                    if (xmlReDraft == "R") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field)
                            setNodeText(field , OrderDept[i]);
                        IsSkipDrafter = "FALSE";
                    }
                    else if (xmlReDraft == "C") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != "" + strLangS57 + "") {
                        }
                        IsSkipDrafter = "TRUE";
                    }
                    else {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field)
                            setNodeText(field , OrderDept[i]);
                    }
                    hapyuiCnt = hapyuiCnt + 1;
                    break;


                case strAprType7:
                    if (referCnt == 1) {
                        refer = "";
                        refer = refer + OrderName[i];
                        referCnt = referCnt + 1
                    } else {
                        refer = refer + ", " + OrderName[i];
                    }
                    break;

                case strAprType17:
                    fieldname = "gongram" + gongramCnt
                    field = message.GetListItem(fields, fieldname);

                    if (field) {
                        setNodeText(field , OrderName[i] + " " + OrderJobtitle[i] + " " + OrderDept[i]);
                        gongramCnt = gongramCnt + 1;
                    }
                    break;
            }
        }

        if (refer != "") {
            fieldname = "refer";
            field = message.GetListItem(fields, fieldname);

            if (field)
                field.Value = refer;
        }

        var susinSN = "";
        if (pDraftFlag == "SUSIN" || pDocState == strDocState11 || pDraftFlag == "GAMSABU")
            susinSN = pSusinSN

        for (i = 1; i < 20; i++) {
            fieldname = susinSN + "jikwe" + i
            field = message.GetListItem(fields, fieldname);

            if (field)
                setNodeText(field , " ");
            else
                break;
        }

        for (i = 1; i < 20; i++) {
            fieldname = "hjkwe" + i
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field , " ");
            else
                break;
        }

        for (i = 1; i < 20; i++) {
            fieldname = "sign" + i
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field , " ");
            else
                break;
        }

        var idx = 1;
        var hidx = 1;
        var Flag = "";
        if (pDraftFlag == "SUSIN" || pDocState == strDocState11) {
            susinSN = pSusinSN;
            Flag = susinSN + "Recv";
        }

        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40) {
                if (LastSignSN == 1 || LastSignSN == i) {
                    field = message.GetListItem(fields, Flag + "AprLine");
                    var cnt = 20;
                    if (field)
                        cnt = OrderType.length;

                    for (k = 1; k < 20; k++) {
                        if (pDraftFlag == "SUSIN" || pDraftFlag == "GAMSABU")
                            signID = pSusinSN + "sign" + k
                        else
                            signID = "sign" + k

                        field = message.GetListItem(fields, signID);
                        if (field)
                            LastSignNo = k;
                    }
                    idx = LastSignNo;
                }
                var j, chkflag;

                if (junGyulFlag == "1") {
        			//아무것도 안함
        		} else if (junGyulFlag == "4") {
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
                        field = message.GetListItem(fields, fieldname);
                        if (field)
                            setNodeText(field , OrderJobtitle[i]);

                        fieldname = susinSN + "sign" + idx;
                        field = message.GetListItem(fields, fieldname);
                        if (field)
                            field.innerHTML = OrderName[i] + "<br>" + OrderReason[i];
                        
                        fieldname = susinSN + "approdept" + idx;
                        field = message.GetListItem(fields, fieldname);
                        if (field)
                        	setNodeText(field , OrderDept[i]);

                        idx = idx + 1;
                        continue;
                    }
                }
                fieldname = susinSN + "jikwe" + idx;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    setNodeText(field , OrderJobtitle[i]);
                }
                
                /* 2020-07-27 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
                fieldname = susinSN + "sign" + idx;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                	// 서명필드만 존재
                	if (message.GetListItem(fields, (susinSN + "sign" + idx)) != null && message.GetListItem(fields, (susinSN + "seumyung" + idx)) == null) {
                		setNodeText(field , OrderName[i]);
                	}
                	// 서명필드 + 결재자명 필드가 함께 존재
                	else if (message.GetListItem(fields, (susinSN + "sign" + idx)) != null && message.GetListItem(fields, (susinSN + "seumyung" + idx)) != null) {
                		field.innerHTML = "[NOSLASH]";
                	}
                	// 그 외의 경우, 아무런 값이 부여되지 않으므로 슬래시 이미지를 표출
                	else {
                		//setNodeText(field , OrderName[i]);
                	}
                }
                
                fieldname = susinSN + "approdept" + idx;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                	setNodeText(field , OrderDept[i]);
                }
                
                idx = idx + 1;
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
function SendDraftMappingSign(ret) {
  try {
	var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
	var field;
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt = 0;
	var signposition = "1";
	
    if (approvalFlag == "S") {
        if (LastSignSN == 1) {
            for (i = 1; i < 20; i++) {
                if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
                else signID = "sign" + i

                field = message.GetListItem(fields, signID)
                if (field) {
                    LastSignNo = i;
                }
            }
            signposition = LastSignNo;
        } else if (DraftLastFlag) {
            putJunkyulSign("sign" + signposition);
            for (i = 1; i < 20; i++) {
                if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
                else signID = "sign" + i

                field = message.GetListItem(fields, signID)
                if (field) {
                    LastSignNo = i;
                }
            }
            signposition = LastSignNo;
        }
    } else {
    	if (LastSignSN == "1") {
    		signposition = 1;
		} else if (DraftLastFlag) {
    		putJunkyulSign("sign" + signposition);
    		for (i = 1; i < 20; i++) {
    			if(pDraftFlag == "SUSIN") signID = "sign" + i;
    			else signID = "sign" + i;
    			
    			field = message.GetListItem(fields, signID);//CKEDITOR-원본 : field = fields.Item(signID)
    			if(field) {
    				LastSignNo = i;
    			}
    		}
    		signposition = LastSignNo;
    	}
    }
	
	if (pDraftFlag == "SUSIN" ||  pDocState == strDocState11 || pDraftFlag == "GAMSABU") { 
		psigncell = pSusinSN + "sign" + signposition;
		pseumyungcell = pSusinSN + "jikwe" + signposition;
		pseumyungdatecell = pSusinSN + "seumyungdate" + signposition;
	} else {
	    psigncell = "sign" + signposition;
	    pseumyungcell = "jikwe" + signposition;
	    pseumyungdatecell = "seumyungdate" + signposition;
	}
	
	// 서명일자 
	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 	  

	var field = message.GetListItem(fields, psigncell); // CKEDITOR-원본 : field = fields.Item(psigncell);
	var signWidth = 50; // CKEDITOR-원본 :var signWidth	= parseInt(field.TagObject.offsetWidth) - 4 - 15; 
	var signHeight = 50; // CKEDITOR-원본 :var signHeight	= parseInt(field.TagObject.offsetHeight) - 4;
	
	var strimg;
	var SingFlag = true;
	var OpinionText = ""; // 합의문서 접수 시에도 대결/전결 문자를 표출하기 위한 변수
	
	if (CurAprType == strAprType4) {
		signHeight = 28;
		OpinionText = strLang6 + "<br>";
	} else if (CurAprType == strAprType16) {
		signHeight = 28;
		OpinionText = strLang7 + "<br>";
	}
	
	if (ret != "NAME") { // 이미지서명
	    strimg = OpinionText + "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
	    strimg = strimg + " width=" + signWidth;
	    
	    if (signImageType == "NAME") { // 부서합의문 서명 이미지타입일때 이미지랑 부서아이디 같이 들어가는 버그 수정 20200313 윤상원
	    	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'> " + "<br>" + arr_userinfo[2];
	    } else {
	    	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'> ";
	    }
	    
	  	field.innerHTML = strimg; // CKEDITOR-원본 : field.TagObject.innerHTML = strimg;
	  	
	  	if (signImageType == "NAME") {
			OpinionText = OpinionText + "::" + arr_userinfo[2];
        }
        
	  	// 사인정보를 저장한다. (Undo용, 서명 데이터 맵핑을 위해서도 사용)
	  	signInfo[signCnt] = psigncell;
		SignType[signCnt] = "IMAGE";
		SignName[signCnt] = psigncell;
		SignContent[signCnt] = ret + "::" + OpinionText;
	  	signCnt = signCnt + 1;
	  	SingFlag = true;
	} else { // 문자서명
	  	if (field) {
	  	    strimg = OpinionText + "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
	  		field.innerHTML = strimg;//CKEDITOR-원본 : field.TagObject.innerHTML = strimg
	  		
	  		signInfo[signCnt] = psigncell;
			SignType[signCnt] = "HTML";
			SignName[signCnt] = psigncell;
			SignContent[signCnt] = strimg;
	  		signCnt = signCnt + 1;
	  		SingFlag = false; 
	  	}
	}
	
    //서명정보를 display해주는 function
	field = message.GetListItem(fields, pseumyungcell); // CKEDITOR-원본 : field = fields.item(pseumyungcell);
	if (SingFlag) {
	  	if (field) {
	  		setNodeText(field , arr_userinfo[3]);
	  		
	  		signInfo[signCnt] = pseumyungcell;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = pseumyungcell;
			SignContent[signCnt] = arr_userinfo[3];
	  		signCnt = signCnt + 1;
	  	}
	} else {
	  	if (field) {
	  		setNodeText(field , arr_userinfo[3]);
	  		
	  		signInfo[signCnt] = pseumyungcell;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = pseumyungcell;
			SignContent[signCnt] = arr_userinfo[3];
	  		signCnt = signCnt + 1;
	  	}
	}
  
	// 서명일자
	field = message.GetListItem(fields, pseumyungdatecell); // CKEDITOR-원본 : field = fields.item(pseumyungdatecell)
	if (field) {
		setNodeText(field , s);
		
		signInfo[signCnt] = pseumyungdatecell;
		SignType[signCnt] = "TEXT";
		SignName[signCnt] = pseumyungdatecell;
		SignContent[signCnt] = s;
		signCnt = signCnt + 1;
	}
    return signInfo;
  } catch(e) {
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
	
    var rtnXml = xmlhttp.responseXML;
    if (xmlhttp != null && xmlhttp.readyState == 4) {
    	 if (xmlhttp.status == 200) {
    		 return xmlhttp.responseText;
    	 } else {
    		 var pAlertContent = strLang344 + "<br> " + strLang345;
    			OpenAlertUI(pAlertContent);
    	 }
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

    if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
        DeptID = upperDeptCode;
        
        /* 2024-11-07 홍승비 - 전자결재 > 상위부서문서함 관련 변수 체크 추가 */
        if (typeof upperDeptName !== "undefined" && upperDeptName !== "") {
        	DeptName = upperDeptName;
        }
    }
	
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
	
	//일반기안 참고하여 수정. 기존 result와 비교 오류가 있었음. 2019-02-11 홍대표.
	var dataNodes = GetChildNodes(loadXMLString(result).documentElement);
    var RtnVal = getNodeText(dataNodes[0]);

    if (RtnVal == "") {
        return DeptName;
    }
    else {
        return RtnVal;
    }
}

//자동입력Field에 값을 입력하는 함수
function SetAutoPropertyValue() {
  try {
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
  
	for (i = 0 ; i < fields.length ; i ++) {
		var field = fields[i];
		if(!fields) return;
		
		if(pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
	  		switch (field.id) {
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
	  	} else {
	  	    switch (field.id) {
	  	     	case pSusinSN + "receiptdate" :	 
	  				field.textContent = CurrentDate;//CKEDITOR-원본 : field.Value = CurrentDate;
	  				break;
	  	    }	
	  	}
	  	
	  	//일반결재
	  	if(pDraftFlag == "SUSIN" ||  pDocState == strDocState11 || pDraftFlag == "GAMSABU") {
	  		var pSignSusin = pSusinSN + "sign";
	  		if (field.id.substr(0, pSignSusin.length) == pSignSusin)
	  	  		SignCount = SignCount + 1;
	  	} else {
	  		if (field.id.substr(0, 4) == "sign")
	  	  		SignCount = SignCount + 1;
	  	} 
      
		//합의
	    if (field.id.substr(0, 10) == "habyuidate") {
	    	hapyuiCount = hapyuiCount + 1;
	    }
	    
	    //공람칸
	    if (field.id.substr(0, 7) == "gongram") {
	    	gongramCount = gongramCount + 1;
	    }
	  	
	    //직위정보
	    if(pDraftFlag == "SUSIN" || pSusinSN != "0" || pDraftFlag == "GAMSABU") {
			var pSignInfoSusin = pSusinSN + "jikwe";
			if(field.id.substr(0,pSignInfoSusin.length) == pSignInfoSusin) {
				if(SignInfoFlag) {
					SignInfo = field.textContent;//CKEDITOR-원본 : SignInfo = field.value;
					SignInfoFlag = false;
				} else {
					SignInfo = field.textContent + ";" + SignInfo ;//CKEDITOR-원본 : SignInfo = field.value + ";" + SignInfo ;
				}
			}
	    } else {
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
        parameter[99] = "mht";
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
function SaveDraftDocInfo() {
    var rtnVal;
	
    // 수정(2008.06.12) : 결재문서 파일 저장 시 임시파일 생성 후 파일크기를 체크하여 원본 파일로 복사하도록 루틴 수정
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
            if(pDocState == strDocState11)
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
            var fields = message.GetFieldsList();//CKEDITOR-원본 : var fields = FormProc.Fields;
            var field;
            var objRoot;
            var objNode;
            var field;
	
            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();

            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
            //합의문 formid로 수정해야
            if (pDraftFlag == "HAPYUI") {
            	createNodeAndInsertText(xmlpara, objNode, "FORMID", "2003000007");
            } else {
            	createNodeAndInsertText(xmlpara, objNode, "FORMID", pFormID);
            }
            	
            if (pDraftFlag == "SUSIN" || (pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU"))
                createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pOrgDocID);
            else
                createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", "");
            if (pDraftFlag == "SUSIN" || (pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU"))
                createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", pDocType);
            else
                createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", "");

            if (pDraftFlag == "SUSIN" || (pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU"))
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
                
                	//부서순차합의 일경우 접수번호를 통해 가져온 DOCNO 를 가져오도록 수정. 2019-02-21 홍대표
	                if((pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU") && approvalFlag == "G") {
	                	xmlpara.getElementsByTagName("DOCNO")[0].textContent = pDocNo;
	                }
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
            //부서합의할 때, 원기안부서 기록물등록대장에 합의부서 문서가 보이는 오류때문에 아래부분 추가. 2019-03-11 홍대표
            createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
            createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
            createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", pDocNumCode);

            //createNodeAndInsertText(xmlpara, objNode, "PMEMBERNAME", arr_userinfo[11]);
            //createNodeAndInsertText(xmlpara, objNode, "SMEMBERNAME", arr_userinfo[12]);
            //createNodeAndInsertText(xmlpara, objNode, "PMEMBERDEPTNAME", arr_userinfo[15]);
            //createNodeAndInsertText(xmlpara, objNode, "SMEMBERDEPTNAME", arr_userinfo[16]);
            //createNodeAndInsertText(xmlpara, objNode, "PMEMBERJOBTITLE", arr_userinfo[13]);
            //createNodeAndInsertText(xmlpara, objNode, "SMEMBERJOBTITLE", arr_userinfo[14]);
            if (curDocNum != "") {
              	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
              } else {
              	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
              }
            xmlhttp.open("POST","/ezApprovalG/doDraft.do",false);
            xmlhttp.send(xmlpara);
            
            if (xmlhttp != null && xmlhttp.readyState == 4) {
             	 if (xmlhttp.status == 200) {
             		SetBtnStateFalse();
             		 return getNodeText(GetChildNodes(xmlhttp.responseXML)[0]);
             	 } else {
             		return "FALSE";
             	 }
           }
        } catch(e){

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
	
            if (curDocNum != "") {
              	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
              } else {
              	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
              }
            
            xmlhttp.open("POST","/ezApprovalG/doDraft.do",false);
            xmlhttp.send(xmlpara);
            
            if (xmlhttp != null && xmlhttp.readyState == 4) {
             	 if (xmlhttp.status == 200) {
             		SetBtnStateFalse();
                    return xmlhttp.responseText;
             	 } else {
             		return "FALSE";
             	 }
           }
        } catch(e){
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
                var parameter = pUserID;
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
            if (GetChildNodes(xmldoc.documentElement)[10].textContent == "Y" || GetChildNodes(xmldoc.documentElement)[10].textContent == "O") {
                pHasOpinionYN = "Y";
            }

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

            if (CrossYN()) {
                RECEIPTDEPTID.textContent = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
            } else {
                RECEIPTDEPTID.innerText = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
            }
	   
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
        //닷넷 로직 따라서 주석 처리. 2019-02-27 홍대표
//        btnAssign.Enable = "false";
//        btnDistribute.Enable = "false";
//        btnReturn.Enable = "false";
//        btnAproveSusin.Enable = "false";

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

    var ezchkpasswd_cross_dialogArguments = new Array();
    function chk_Passwd()
    {
        var parameter = pUserID;
        var url = "/ezApprovalG/ezchkPasswd.do";

        ezchkpasswd_cross_dialogArguments[0] = parameter;
        ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

        DivPopUpShow(350, 225, url);
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
        
        var d = new Date(initdate);
		
        var numHeader = "";
        
        pPrefix = !pPrefix ? "" : pPrefix;
		
        var field = GetListItem(fields, pPrefix + "docnumber");//CKEDITOR-원본 : var field = pzFormProc.fields(pPrefix + "docnumber")
        if(!field) return 
		
//        var fieldValue = getfieldValue(field);//pzFormProc.editor.DOM.body.getAttribute("orgdocnum");
        var fieldValue = message2.DocumentBodyGetAttribute("orgdocnum", 0);
      
        if (fieldValue != null) {
	        if (fieldValue.indexOf("@")) {
	        	Arr_Header = fieldValue.split("-");
	            
	            Arr_Header.forEach(function(item, index) {
	            	if (!item.indexOf('@')) {
	            		//@ exist
	            		Header = item.replace("@", "");

	                    switch (Header) {
	                        case "DP":
	                            numHeader += DeptSymbol;
	                            break;

	                        case "dp":
	                            numHeader += DeptSymbol;
	                            break;

	                        case "YY":
	                            numHeader += getAccountingYear();
	                            break;
	                            
	                        case "yy":
	                            var yyear = getAccountingYear();
	                            numHeader += yyear.toString().substr(2);
	                            break;

	                        case "MM":
	                            var mmonth = d.getMonth() + 1;
	                            if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
	                            numHeader += mmonth;
	                            break;

	                        case "mm":
	                            numHeader += (d.getMonth() + 1);
	                            break;

	                        case "NN":
	                            break;

	                        case "nn":
	                            break;

	                        case "cs":
	                            numHeader += strLang107;
	                            break;
	                            
	                        case "FT":
	                        	numHeader += "FT";
	                        	break;
	                        	
	                        case "MV":
	                        	numHeader += "MV";
	                        	break;
	                        	
	                        case "YM":
	                        	var yyear = d.getFullYear();
	                            numHeader += yyear.toString().substr(2);
	                            
	                        	var mmonth = d.getMonth() + 1;
	                            if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
	                            numHeader += mmonth;
	                            
	                            var mdate = d.getDate();
	                            if (parseInt(mdate) < 10) mdate = "0" + mdate;
	                            numHeader += mdate;
	                            
	                            break;
	                            
	                        /*단암 양식*/
	                        case "D1":
	                        	numHeader += "계약";
	                    		break;
	                        case "D2":
	                        	numHeader += "교육기안";
	                    		break;
	                        case "D3":
	                        	numHeader += "교육";
	                    		break;
	                        case "D4":
	                        	numHeader += "구매";
	                    		break;
	                        case "D5":
	                        	numHeader += "제";
	                    		break;
	                        case "D6":
	                        	numHeader += "기구";
	                    		break;
	                        case "D7":
	                        	numHeader += "기안";
	                    		break;
	                        case "D8":
	                        	numHeader += "제 문서 신청";
	                    		break;
	                        case "D9":
	                        	numHeader += "보고";
	                    		break;
	                        case "DA":
	                        	numHeader += "제조-보고";
	                    		break;
	                        case "DB":
	                        	numHeader += "연장근무보고서";
	                    		break;
	                        case "DC":
	                        	numHeader += "출장";
	                    		break;
	                        case "DD":
	                        	numHeader += "해외출장";
	                    		break;
	                        case "DE":
	                        	numHeader += "품질검사";
	                    		break;
	                        case "DF":
	                        	numHeader += "휴가";
	                        	break;

	                        default:
	                            numHeader += fieldValue;
	                            break;
	                    }
	            	} else {
	            		numHeader += item;
	            	}
	            	
	            	if (!(index == Arr_Header.length - 1)) {
	            		numHeader += "-";
	            	}
	            });
	        }
        }
        message.DocumentSetFildeValue(pPrefix + "docnumber", numHeader);
        message2.DocumentSetFildeValue(pPrefix + "docnumber", numHeader);
//        field.textContent = numHeader;
    }

    //파일정보를 저장한다. 
    function SaveFile()
    {
        // 20090907 : 표준모듈 패치, 빈문서 저장을 막기위한 체크
        if(CheckBlankDoc() == "FALSE")
            return "FALSE";

        var mhtBody = "";
    	mhtBody = message.Get_EditorBodyHTML();
    	EmbedContentIntoXML(mhtBody);
    	mhtBody = ConvertHTMLtoMHT(mhtBody);
    	
    	var data = {
			docID : pDocID,
			formId : pFormID,
			html  : mhtBody,
			orgCompanyID : orgCompanyID
    	}
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/saveFile.do",
    		contentType : "application/json",
    		data : JSON.stringify(data),
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
    	
    	var data = {
			docID : pDocID,
			formId : pFormID,
			html  : mhtBody,
			orgCompanyID : orgCompanyID
    	}

        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/saveFile.do",
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
                createNodeAndAppandNodeText(xmlpara, objSub, objSub2, "ORGCOMPANYID", orgCompanyID);
			
            }  		
            xmlhttp.open ("Post","/ezApprovalG/setSignInfo.do",false);
            xmlhttp.send(xmlpara);
        }
    }

    function delOpinionInfo() {
    	$.ajax({
    		type : "POST",
    		dataType : "json",
    		async : false,
    		url : "/ezApprovalG/deleteOpinionTypeInfo.do",
    		data : {
    			docID : pDocID,
    			opinionType : "002",
    		},
    		success: function(result) {
    			pHasOpinionYN = "";
    		}
    	});
    	
        /*var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	
        xmlhttp.open("POST","../ezAPROPINION/aspx/BansongOpinionDel.aspx",false);
        xmlhttp.send(xmlpara);

        return xmlhttp.responseText;*/
    }

    function btnApprovalInfo_save(ret) {
        pDocID = SelectSingleNodeValueNew(ret[1], "PARAMETER/DOCID");
        summary = SelectSingleNodeValueNew(ret[1], "PARAMETER/SUMMARY");

        var xmlhttp = createXMLHttpRequest();

        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/aprLineSave.do",
    		data : {
    				ret    : ret[2]
    				},
    		success : function(result){
    			if (result == "TRUE") {
    				
    			} else {
    				alert(strLang259);
    			}
    		}
    	});

        if (pSuSinFlag == "Y") {
            var AprDeptInfo = ret[2];

//            var AprDeptPara = createXmlDom();
//            var pAprNDeptNumber = 1;
//            var pAprDeptFlag = "NDept";
//            AprDeptPara = AprDeptParameter(pAprNDeptNumber, pAprDeptFlag);
//
//            if (CrossYN()) {
//                var xmlRtn = AprDeptPara.documentElement;
//                var Node = AprDeptInfo.importNode(xmlRtn, true);
//                AprDeptInfo.documentElement.appendChild(Node);
//            }
//            else {
//                var xmlRtn = AprDeptPara.documentElement;
//                AprDeptInfo.documentElement.appendChild(xmlRtn);
//            }
            
            $.ajax({
        		type : "POST",
        		dataType : "text",
        		async : false,
        		url : "/ezApprovalG/aprDeptSave.do",
        		data : {
        				aprDeptInfo : AprDeptInfo
        				},
        		success : function(result){
        			if (result == "TRUE") {
        				
        			} else {
        				alert(strLang163);
        			}
        		}
        	});
        }
    }
    
    //부서합의에서 회송 처리하기 위해 추가. 2019-02-27 홍대표
    function setHeSongDocInfo() {
    	var objRoot;
        var objNode;

        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        createNodeInsert(xmlpara, objNode, "ASSIGN");

        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pAprMemberDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pAprMemberID", pUserID);

        //receivesn 받아올 곳 찾기 전까진 1로 고정.
        createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", "1");
//        if (pListTypeValue == "4")
//            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", GetAttribute(pSelectedRow, "DATA2"));
//        else {
//            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", "1");
//        }

        xmlhttp.open("POST", "/ezApprovalG/setHeSongHapyuiDocInfo.do", false);
        xmlhttp.send(xmlpara);
        
        if (xmlhttp != null && xmlhttp.readyState == 4) {
       	 if (xmlhttp.status == 200) {
       		 var pAlertContent = strLang878;
             OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
             return true;
       	 } else {
       		 var pAlertContent = strLang740;
             OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
             return false;
       	 }
       }
    }
    
    function OpenAlertUI_Close_Complete() {
        btnClose_onclick();
    }
    
    // 부서합의 문서에도 신규 의견작성창을 적용
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
    			var fields = message.GetFieldsList();
    		    var field = message.GetListItem(fields, "opinions");
    		    if (field) {
    		    	field.innerHTML = " ";
    		    }
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
    	        makeOpinionList(objXML);
    		}
    	} catch (e) {
    		alert("openOpinionUI_New_Complete ::: " + e.description);
    	}
    }

    function makeOpinionList(OpinionXML) {
    	var fields = message.GetFieldsList();
        var field = message.GetListItem(fields, "opinions");
        if (!field) return;

        var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
        field.innerHTML = " ";
        if (NodeList.length > 0) {
            for (i = NodeList.length - 1; i >= 0; i--) {
        		var opinionsTable = '<p style="margin-top: 10px;margin-left: 3px;margin-bottom: 3px;">▶ ' + getNodeText(NodeList[i].childNodes[3]) + ' - ' + getNodeText(NodeList[i].childNodes[2]) + ' - ' + getNodeText(NodeList[i].childNodes[1]) + '</p><p style="margin-top: 0px;margin-left: 10px;margin-bottom: 0px;">' + MakeXMLString(getNodeText(NodeList[i].childNodes[6])) + '</p>';
        		$(field).append(opinionsTable);
            }
        }
        SaveFile();
    }
    