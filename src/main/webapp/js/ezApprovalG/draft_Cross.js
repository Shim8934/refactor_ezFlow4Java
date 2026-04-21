var lastKyulName, lastKyuljiwee, LastSignSN;
var DraftLastFlag = false;
/**
 *  양식에 출력될 결재라인 가져오기
 * */
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

      //2021-02-19 박희찬 G버전에도 가변결재사용할수 있도록 추가
      if (ret[5] == undefined) {
        xmlKuljea = ret[0];
        xmlReDraft = ret[2];
        New_DrawAutoLine(ret[0], pDraftFlag);
    }
    else {
        xmlKuljea = ret[1];
        xmlReDraft = ret[5];
        New_DrawAutoLine(ret[1], pDraftFlag);

    }

	setAprLinesXML(xmlKuljea);
	
	if(xmlReDraft == "C")
	{
		ApplyDocCellInfo();
	}
	else if(xmlReDraft == "R")
	{
		ClearDocCellInfo(ret);
	}
    
	 
	xmldom = loadXMLString(xmlKuljea);
	 
	// 결재리스트를 objNodes에 담아둔다.
    objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    fields = message.GetFieldsList();
	count = objNodes.length;
	
	 
	for(i=1;i<20;i++) {
	   	name = "habyuisign" + i;
	  	field = message.GetListItem(fields, name);
	  
	  	if(field) {
	  		name = "habyui" + i;
	  		field = message.GetListItem(fields, name);
	  	
            if(field) {
	  	        field.textContent= "";
	  	        if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
            }  
	  		
            name = "habyuisign" + i;
	  		field = message.GetListItem(fields, name);
	  		
            if(field) {
	  	        field.textContent= "";
	  	        if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
            }
	  		
            name = "habyuipositon" + i;
	  		field = message.GetListItem(fields, name);
	  		
            if(field) {
	  	        field.textContent= "";
	  	        if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
            }
	  		
            name = "habyuidate" + i;
	  		field = message.GetListItem(fields, name);
	  		
            if(field && ret[32] != "Y") {
	  	        field.textContent= "";
	  	        if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
            }
	  	} else	{
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
	/**
	 *  결재양식 결재라인에 저장될 내용 처리
	 * */	
	for(i=0;i < count;i++) {
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
    
    var chkGamsa = false;
	LastSignSN = OrderType.length;
	// 마지막 결재하는 사람 찾기
    for(i=1;i<OrderType.length;i++) {
		if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) {
			LastSignSN = i;
			i = OrderType.length;
		} else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 ||  OrderType[i] == strAprType1 ||  OrderType[i] == strAprType3) {
    		LastSignSN = i;
        } else if (OrderType[i] == strAprType13) {
        	chkGamsa = true;
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
	
	for(i=1;i < 10;i++) {
	  	fieldname = "jikwe" + i;
		field = message.GetListItem(fields, fieldname);
	  
		if(field) {
            field.textContent= " ";	
            if(new RegExp(/Firefox/).test(navigator.userAgent))
	            field.innerHTML = "<br type='_moz'>";
			fieldname = "sign" + i;
			field = message.GetListItem(fields, fieldname);
			
			if(field && ret[32] != "Y") {
				field.textContent= " ";	
				if(new RegExp(/Firefox/).test(navigator.userAgent))
	                field.innerHTML = "<br type='_moz'>";
			}
		} else {
			break;
		}	
	}
	var idx = 1;
	var hidx = 1;	  
	// 결재자 직위 출력
	for(i=1;i < OrderJobtitle.length;i ++) {
		if(OrderType[i] == strAprType18 || OrderType[i] == strAprType19  || OrderType[i] == strAprType1 || OrderType[i] == strAprType4  || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) 	{
			fieldname = "jikwe" + idx;
			field = message.GetListItem(fields, fieldname);
	  	
			if(field) {
			    var jikweName = trim(field.textContent);					
				field.textContent =  OrderJobtitle[i];
						
				if(OrderSuggester[i] == "Y")
						field.textContent = strLang75 + field.textContent;
					
				if(OrderReporter[i] == "Y")
						field.textContent = strLang76 + field.textContent;
			}
			idx = idx + 1;
	  	}
		else if(OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) 	{
			fieldname = "habyui" + hidx;
			field = message.GetListItem(fields, fieldname);
	  		if(field) {
	  			field.textContent = OrderDept[i];
	  		}
			
			fieldname = "habyuipositon" + hidx;
			field = message.GetListItem(fields, fieldname);
			if(field) {
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
	
    if (chkGamsa) {
        fieldname = "deptgamsaname";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field, "감    사");
        }
    }
    else {
        fieldname = "deptgamsaname";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field, "");
        }
    }
    
  } catch(e) {
    alert("GetDraftAprLineInfo(ret)" + e.description);
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
            //DrawAutoAprLine(ret[0], pDraftFlag);
            New_DrawAutoLine(ret[0], pDraftFlag);
        } else {
	        TempsaveAprlineinfo = ret[1];
	        xmlKuljea = ret[1];
	        setAprLinesXML(xmlKuljea);
	        //DrawAutoAprLine(ret[1], pDraftFlag);
	        New_DrawAutoLine(ret[1], pDraftFlag);
        }
        
        if (xmlReDraft == "C") {
            ApplyDocCellInfo();
        } else if (xmlReDraft == "R") {
            ClearDocCellInfo(ret);
        }

        xmldom = loadXMLString(xmlKuljea);

        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        fields = message.GetFieldsList();
        count = objNodes.length;

        field = message.GetListItem(fields, "habyuidate1");
        if (field) {
            for (i = 1; i < 200; i++) {
                name = "habyuidate" + i
                field = message.GetListItem(fields, name);

                if (field) {
                    if (!trim_Cross(getNodeText(field))) {
                        name = "habyui" + i
                        field = message.GetListItem(fields, name);

                        if (field) {
                            setNodeText(field , "");
                            if (new RegExp(/Firefox/).test(navigator.userAgent))
                                field.innerHTML = "<br type='_moz'>";
                        }

                        fieldname = "habyuisign" + i;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , "");
                            if (new RegExp(/Firefox/).test(navigator.userAgent))
                                field.innerHTML = "<br type='_moz'>";
                        }

                        fieldname = "habyuija" + i;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , "");
                            if (new RegExp(/Firefox/).test(navigator.userAgent))
                                field.innerHTML = "<br type='_moz'>";
                        }

                        fieldname = "habyuiaddress" + i;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , "");
                            if (new RegExp(/Firefox/).test(navigator.userAgent))
                                field.innerHTML = "<br type='_moz'>";
                        }

                        fieldname = "habyuipositon" + i;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , "");
                            if (new RegExp(/Firefox/).test(navigator.userAgent))
                                field.innerHTML = "<br type='_moz'>";
                        }
                        
                        fieldname = "habyuiapprodept" + i;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	setNodeText(field, "");
                        	if (new RegExp(/Firefox/).test(navigator.userAgent))
                                field.innerHTML = "<br type='_moz'>";
                        }
                    }
                } else {
                    break;
                }
            }
        }
        else {
            for (i = 1; i < 200; i++) {
                name = "habyuisign" + i
                field = message.GetListItem(fields, name);

                if (field) {
                    name = "habyui" + i
                    field = message.GetListItem(fields, name);
                    if (field) {
                        setNodeText(field , "");
                        if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                    }

                    fieldname = "habyuisign" + i;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                        setNodeText(field , "");
                        if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                    }

                    fieldname = "habyuija" + i;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                        setNodeText(field , "");
                        if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                    }

                    fieldname = "habyuiaddress" + i;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                        setNodeText(field , "");
                        if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                    }

                    fieldname = "habyuipositon" + i;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                        setNodeText(field , "");
                        if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                    }
                    
                    fieldname = "habyuiapprodept" + i;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                    	setNodeText(field, "");
                    	if (new RegExp(/Firefox/).test(navigator.userAgent))
                            field.innerHTML = "<br type='_moz'>";
                    }
                } else {
                    break;
                }
            }
        }

        for (i = 1; i < 10; i++) {
            field = message.GetListItem(fields, "gamsasign" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            field = message.GetListItem(fields, "gamsajikwe" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            field = message.GetListItem(fields, "gamsaseumyung" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            field = message.GetListItem(fields, "gamsaseumyungdate" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }
        }

        field = message.GetListItem(fields, "refer");
        if (field) {
            setNodeText(field, "");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        field = message.GetListItem(fields, "hgamsa");
        if (field) {
            setNodeText(field, "");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        for (i = 1; i < fields.Count; i++) {
            field = message.GetListItem(fields, "gongram" + i);
            if (field) {
                setNodeText(field , "");
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }
        }

//        RollbackTongjeNumber();
        for (i = 1; i < 200; i++) {
            field = message.GetListItem(fields, "habyuiaccount" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            field = message.GetListItem(fields, "habyuisign" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            field = message.GetListItem(fields, "habyuija" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            field = message.GetListItem(fields, "habyuiaddress" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            field = message.GetListItem(fields, "tongjesign" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            field = message.GetListItem(fields, "tongjenumber" + i);
            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }
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
        
        var tempOrderAddress = getAddress(OrderID).split("||");
        var cnt = 1;
        OrderAddress[0] = "";
        for (var i = tempOrderAddress.length -1; i >= 0; i--) {
            OrderAddress[cnt] = tempOrderAddress[i];
            cnt++;
        }
        
        LastSignSN = OrderType.length;

        for (i = 1; i < OrderType.length; i++) {
            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3)
                LastSignSN = i;
        }

        if (OrderType[1] == strAprType4) {
            DraftLastFlag = true;
        }

        lastKyulName = OrderName[LastSignSN]
        lastKyuljiwee = OrderJobtitle[LastSignSN]
        var field = message.GetListItem(fields, "lastKyuljikwee")
        if (field)
            setNodeText(field, lastKyuljiwee);

        var field = message.GetListItem(fields, "lastKyulName")
        if (field)
            setNodeText(field, lastKyulName);

        hapyuiCnt = 1;
        SignCnt = 1;
        referCnt = 1;
        gongramCnt = 1;

        var fieldname;
        var field;
        var refer;

        refer = "";

        if (ret[5] == "R") {
        	xmlReDraft = "R";
        } else  if (ret[5] == "C") {
        	xmlReDraft = "C";
        } 

        for (i = 0; i < OrderType.length; i++) {
            switch (OrderType[i]) {
                case strAprType1:
                    break;

                case strAprType2:
                    if (OrderName[i] == arr_userinfo[2] && i == 1) {
                    	IsSkipDrafter = "TRUE";
                    }
                    break;

                case strAprType8: // 개인순차합의
                    if (xmlReDraft == "R") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderDept[i]);
                        }
                        
                        /* 2020-07-27 홍승비 - 합의자명 필드가 존재하지 않는 경우, 합의자 사인 필드에 이름 표출하도록 수정(개인순차합의, 개인병렬합의) */
                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	// 합의자 사인 필드만 존재, 합의자명 필드 없음
                        	if (message.GetListItem(fields, ("habyuisign" + hapyuiCnt)) != null && message.GetListItem(fields, ("habyuija" + hapyuiCnt)) == null) {
                        		setNodeText(field , OrderName[i]);
                        	}
                            //setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	setNodeText(field, OrderDept[i]);
                        }
                    } else if (xmlReDraft == "C") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                        	if (message.GetListItem(fields, ("habyuisign" + hapyuiCnt)) != null && message.GetListItem(fields, ("habyuija" + hapyuiCnt)) == null) {
                        		setNodeText(field , OrderName[i]);
                        	}
                            //setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        
                        if (field && OrderStat[i] != strLangS26) {
                        	setNodeText(field, OrderDept[i]);
                        }
                        IsSkipDrafter = "TRUE";
                    } else {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                        	if (message.GetListItem(fields, ("habyuisign" + hapyuiCnt)) != null && message.GetListItem(fields, ("habyuija" + hapyuiCnt)) == null) {
                        		setNodeText(field , OrderName[i]);
                        	}
                            //setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        
                        if (field) {
                        	setNodeText(field, OrderDept[i]);
                        }
                    }
                    hapyuiCnt = hapyuiCnt + 1;
                    break;

                case strAprType9: // 개인병렬합의
                    if (xmlReDraft == "R") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderDept[i]);
                        }
                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	if (message.GetListItem(fields, ("habyuisign" + hapyuiCnt)) != null && message.GetListItem(fields, ("habyuija" + hapyuiCnt)) == null) {
                        		setNodeText(field , OrderName[i]);
                        	}
                            //setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	setNodeText(field, OrderDept[i]);
                        }
                    }
                    else if (xmlReDraft == "C") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                        	if (message.GetListItem(fields, ("habyuisign" + hapyuiCnt)) != null && message.GetListItem(fields, ("habyuija" + hapyuiCnt)) == null) {
                        		setNodeText(field , OrderName[i]);
                        	}
                            //setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field && OrderStat[i] != strLangS26) {
                        	setNodeText(field, OrderDept[i]);
                        }
                        IsSkipDrafter = "TRUE";
                    }
                    else {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                        	if (message.GetListItem(fields, ("habyuisign" + hapyuiCnt)) != null && message.GetListItem(fields, ("habyuija" + hapyuiCnt)) == null) {
                        		setNodeText(field , OrderName[i]);
                        	}
                            //setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	setNodeText(field, OrderDept[i]);
                        }
                    }
                    hapyuiCnt = hapyuiCnt + 1;
                    break;

                case strAprType12: // 부서병렬합의
                    if (xmlReDraft == "R") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderDept[i]);
                        }
                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            //setNodeText(field , OrderName[i]);
                        	setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	setNodeText(field, OrderDept[i]);
                        }
                    }
                    else if (xmlReDraft == "C") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS57) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS57) {
                            //setNodeText(field , OrderName[i]);
                        	setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS57) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field && OrderStat[i] != strLangS57) {
                        	setNodeText(field, OrderDept[i]);
                        }
                        IsSkipDrafter = "TRUE";
                    }
                    else {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            //setNodeText(field , OrderName[i]);
                        	setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	setNodeText(field, OrderDept[i]);
                        }
                    }
                    hapyuiCnt = hapyuiCnt + 1;
                    break;

                case strAprType11: // 부서순차합의
                    if (xmlReDraft == "R") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            //setNodeText(field , OrderName[i]);
                        	setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	setNodeText(field, OrderDept[i]);
                        }
                    }
                    else if (xmlReDraft == "C") {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                            //setNodeText(field , OrderName[i]);
                        	setNodeText(field , OrderDept[i]);
                        }


                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }
                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field && OrderStat[i] != strLangS26) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field && OrderStat[i] != strLangS26) {
                        	setNodeText(field, OrderDept[i]);
                        }
                        IsSkipDrafter = "TRUE";
                    }
                    else {
                        fieldname = "habyui" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuisign" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            //setNodeText(field , OrderName[i]);
                        	setNodeText(field , OrderDept[i]);
                        }

                        fieldname = "habyuija" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderName[i]);
                        }

                        fieldname = "habyuiaddress" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                            setNodeText(field , OrderAddress[i]);
                        }

                        fieldname = "habyuipositon" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);

                        if (field) {
                            setNodeText(field , OrderJobtitle[i]);
                        }
                        
                        fieldname = "habyuiapprodept" + hapyuiCnt;
                        field = message.GetListItem(fields, fieldname);
                        if (field) {
                        	setNodeText(field, OrderDept[i]);
                        }
                    }
                    hapyuiCnt = hapyuiCnt + 1;
                    break;

                case strAprType7:
                    if (referCnt == 1) {
                        refer = "";
                        refer = refer + OrderName[i];
                        referCnt = referCnt + 1
                    } else {
                        refer = refer + "," + OrderName[i];
                    }
                    break;

                case strLangS61:
                    fieldname = "gongram" + gongramCnt
                    field = message.GetListItem(fields, fieldname);

                    if (field) {
                        setNodeText(field , OrderName[i] + " " + OrderJobtitle[i] + " " + OrderDept[i]);
                        gongramCnt = gongramCnt + 1;
                    }
                    break;

                case strLangS63:
                    fieldname = "hgamsa"
                    field = message.GetListItem(fields, fieldname)
                    if (field) {
                        setNodeText(field , strLangS63);
                    }
                    break;

                case strLangS64:
                    fieldname = "hgamsa"
                    field = message.GetListItem(fields, fieldname)
                    if (field) {
                        setNodeText(field , strLangS64);
                    }
                    break;
            }
        }

        if (refer != "") {
            fieldname = "refer";
            field = message.GetListItem(fields, fieldname);
            if (field) {
                setNodeText(field , refer);
            }
        }

        var susinSN = "";
        var Flag = "";
        if (pDraftFlag == "SUSIN" || pDocState == strDocState11) {
            susinSN = pSusinSN;
            Flag = susinSN + "Recv";
        }

        field = message.GetListItem(fields, Flag + "AprLine");

        var cnt = 20;
        if (field)
            cnt = OrderType.length;

        for (i = 1; i <= cnt; i++) {
            fieldname = susinSN + "jikwe" + i
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";

                fieldname = susinSN + "sign" + i
                field = message.GetListItem(fields, fieldname)
                if (field) {
                    field.innerHTML = "&nbsp;";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";

                }
                
                fieldname = susinSN + "approdept" + i
                field = message.GetListItem(fields, fieldname)
                if (field) {
                    field.innerHTML = "&nbsp;";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";

                }
                
                fieldname = susinSN + "seumyung" + i
                field = message.GetListItem(fields, fieldname)
                if (field) {
                    field.innerHTML = "&nbsp;";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";

                }
            } else {
                break;
            }
        }

        for (i = 1; i < cnt; i++) {
            fieldname = "hjkwe" + i
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.innerHTML = "&nbsp;";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            } else {
                break;
            }
        }

        var idx = 1;
        var hidx = 1;

        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40) {
                if (LastSignSN == 1 || LastSignSN == i) {
                    for (k = 1; k <= cnt; k++) {
                        if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + k
                        else signID = "sign" + k

                        field = message.GetListItem(fields, signID)
                        if (field) {
                            LastSignNo = k;
                        }
                    }
                    idx = LastSignNo;
                }
                
 				if (junGyulFlag == "4") {
        			if (OrderType[i] == "003") {
        				continue;
        			}
        		}
                
                fieldname = susinSN + "jikwe" + idx;
                field = message.GetListItem(fields, fieldname);

                if (field) {
                    setNodeText(field , OrderJobtitle[i]);

                    if (new RegExp(/Firefox/).test(navigator.userAgent) && trim(getNodeText(field)) == "")
                        field.innerHTML = "<br type='_moz'>";
                }
                
                fieldname = susinSN + "approdept" + idx;
                field = message.GetListItem(fields, fieldname);
                
                if (field) {
                    setNodeText(field , OrderDept[i]);

                    if (new RegExp(/Firefox/).test(navigator.userAgent) && trim(getNodeText(field)) == "")
                        field.innerHTML = "<br type='_moz'>";
                }
                
                fieldname = susinSN + "seumyung" + idx;
                field = message.GetListItem(fields, fieldname);
                
                if (field) {
                	setNodeText(field , OrderName[i]);
                	
                	if (new RegExp(/Firefox/).test(navigator.userAgent) && trim(getNodeText(field)) == "")
                		field.innerHTML = "<br type='_moz'>";
                }
                
                fieldname = susinSN + "sign" + idx;
                field = message.GetListItem(fields, fieldname);
                
                /* 2020-07-24 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
                if (field) {
                	if (draftJunGyulFlag == '1' && OrderType[i] == "004") { // 전결 서명 부여
                		field.innerHTML = strLang6 + "<br>" + OrderName[i];
                	}
                	// 서명필드만 존재
                	else if (message.GetListItem(fields, (susinSN + "sign" + idx)) != null && message.GetListItem(fields, (susinSN + "seumyung" + idx)) == null) {
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
                	idx = idx + 1; // 서명칸이 존재하는 경우, idx를 1 증가시켜서 다음 칸을 찾는다.
                }
            }

            if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
                fieldname = "habyuipositon" + hidx;
                field = message.GetListItem(fields, fieldname);
            }
        }
        if (isSplit == "Y")
            setSignSlash("sign", susinSN);
    } catch (e) {
        alert("SGetDraftAprLineInfo(ret)" + e.description);
    }
}
/**
 *  수신부서 수신자 관련 설정
 * */
function setRecevInfo(ret) {
    var fields = message.GetFieldsList();
    setDeptLinesXML(ret);

    if (ret == "NONE") {
        var field = message.GetListItem(fields, "hrecipients");
        if (field) {
            field.innerHTML = "&nbsp;";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipient");
        if (field) {
            field.innerHTML = "&nbsp;";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipients");
        if (field) {
            field.innerHTML = "&nbsp;";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
        return;
    }
    var i
    var strMailAdd = ""
    var precipent = ""
    var precipents = ""
    var mailflag = true;
    var recipflag = true;
    var mailList = "";
    var mailcnt = 0;
    var xmldom = createXmlDom();
    xmldom.async = false;
    xmldom = loadXMLString(ret);

    var rows = GetChildNodes(xmldom.documentElement);

    if (rows.length == 0) {
        var field = message.GetListItem(fields, "hrecipients");
        if (field) {
            field.innerHTML = "&nbsp;";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipient");
        if (field) {
            field.innerHTML = "&nbsp;";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipients");
        if (field) {
            field.innerHTML = "&nbsp;";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
        return;
    }
    
    btnReceivLineEnable = true;
    
    var field = message.GetListItem(fields, "hrecipients");
    if (field) {
        field.innerHTML = "&nbsp;";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    var field = message.GetListItem(fields, "recipient");
    if (field) {
        field.innerHTML = "&nbsp;";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    var field = message.GetListItem(fields, "recipients");
    if (field) {
        field.innerHTML = "&nbsp;";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }
    // 수신자 ROW 갯수 만큼 실행
    for (i = rows.length - 1; i >= 0; i--) {
        var row = rows[i];
        var params = new Array();
        params[0] = "0";

        var dataNodes = GetChildNodes(rows[i], params);

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
                if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
                    precipent = strLangS68;
                    precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                } else {
                    precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                    precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                }
                recipflag = false;
            } else {
                if (isExtDoc == "Y") {
                    if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
                        precipent = strLangS68;
                        precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                    } else {
                        precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                        precipents = (getNodeText(dataNodes[7]) ? (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") : "") + getNodeText(dataNodes[0]);
                    }
                    recipflag = false;
                }
                else {
                    if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
                        precipent = strLangS68;
                        precipents = getNodeText(dataNodes[0]);
                    } else {
                        precipent = getNodeText(dataNodes[0]);
                        precipents = getNodeText(dataNodes[0]);
                    }
                    recipflag = false;
                }
            }
        }
        else {
            precipent = strLangS68;

            if (getNodeText(dataNodes[3]) == "Y")
                precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
            else {
                if (isExtDoc == "Y")
                    precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                else
                    precipents = precipents + ", " + getNodeText(dataNodes[0]);
            }
        }
    }
    message.DocumentBodySetAttribute("sendMailInfo", strMailAdd);

    var field = message.GetListItem(fields, "recipient");
    if (field) {
        if (precipent == strLangS68) {
            setNodeText(field , precipent);
            var field = message.GetListItem(fields, "recipients");
            if (field) {
                setNodeText(field , precipents);
                var field = message.GetListItem(fields, "hrecipients");
                if (field)
                    setNodeText(field , strLangS70);
            }
        }
        else {
            setNodeText(field , precipent);

            if (precipents == "") {
                var field = message.GetListItem(fields, "hrecipients");
                if (field) {
                    field.innerHTML = "&nbsp;";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
                var field = message.GetListItem(fields, "recipients");
                if (field) {
                    field.innerHTML = "&nbsp;";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
            }
        }
    }

    var field = message.GetListItem(fields, "recipients");
    if (field) {
    	if (SummaryOuterReceiverList != "") {
            setNodeText(field , SummaryOuterReceiverList);
        }else{
        	var precipentsList = precipents.split(",");
        	
        	if (precipentsList.length > 1) {
                setNodeText(field , precipents);
        	}
        }
    }
}

function ClearDocCellInfo(ret) {
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

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "seumyung" + i;
            field = message.GetListItem(fields, fieldname);

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "seumyungdate" + i;
            field = message.GetListItem(fields, fieldname);

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "jikwe" + i;
            field = message.GetListItem(fields, fieldname);

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }
            
            // 사인칸에 부서 
            fieldname = susunSN + "approdept" + i;
            field = message.GetListItem(fields, fieldname);

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            } 
        }
        for (j = 1 ; j <= hapyuiCount ; j++) {
            fieldname = susunSN + "habyui" + j;
            field = message.GetListItem(fields, fieldname);

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "habyuipositon" + j;
            field = message.GetListItem(fields, fieldname);

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "habyuidate" + j;
            field = message.GetListItem(fields, fieldname);

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
                field.textContent = " ";
                if (new RegExp(/Firefox/).test(navigator.userAgent))
                    field.innerHTML = "<br type='_moz'>";
            }

            fieldname = susunSN + "habyuisign" + j;
            field = message.GetListItem(fields, fieldname);

            if (field && (typeof ret == "undefined" || ret[32] != "Y")) {
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
        
        fieldname = "deptgamsaname";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field, " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        fieldname = "deptgamsasign";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field, " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        fieldname = "deptgamsadate";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field, " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
               field.innerHTML = "<br type='_moz'>";
        }
        
        //2018-09-27 김보미
        if (AprState == "015" || isUsed == "reuse") { //회송이거나 재사용일 경우 수신처 결재칸도 비울것. 
        	susunSN = "1";
        	for (i = 1; i <= SignCount ; i++) {
        		fieldname = susunSN + "sign" + i;
        		field = message.GetListItem(fields, fieldname);
        		
        		if (field && field.innerHTML != null && field.innerHTML != " " && field.innerHTML != "") { //서명이 있을 경우에만 값을 지운다.
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
        				field.innerHTML = "&nbsp; "; //그냥 공백(" ")을 넣으면 표가 틀어지기 때문에 기호값으로 넣어준다.
        				if (new RegExp(/Firefox/).test(navigator.userAgent))
        					field.innerHTML = "<br type='_moz'>";
        			}
        			
        			fieldname = susunSN + "approdept" + i;
        			field = message.GetListItem(fields, fieldname);
        			
        			if (field) {
        				field.innerHTML = "&nbsp; "; //그냥 공백(" ")을 넣으면 표가 틀어지기 때문에 기호값으로 넣어준다.
        				if (new RegExp(/Firefox/).test(navigator.userAgent))
        					field.innerHTML = "<br type='_moz'>";
        			}        			
        		}
        	}
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
/**
 *  결재 서명관련 Customize
 *  서명의 사이즈 조절 등이 이뤄지는 함수
 * */
function SendDraftMappingSign(ret) {
    try {
        var fields = message.GetFieldsList();
        var field;

        var psigncell;
        var pseumyungcell;
        var pseumyungdatecell;
        var papprodeptcell;
        var signInfo = new Array();
        var signCnt = 0;
        var sn = 1;

        var OpinionText = "";
        var PositionText = "";

        if (approvalFlag == "S") {
            if (LastSignSN == 1) {
                for (i = 1; i <= 20; i++) {
                    if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
                    else signID = "sign" + i

                    field = message.GetListItem(fields, signID)
                    if (field) {
                        LastSignNo = i;
                    }
                }
                sn = LastSignNo;
            } else if (DraftLastFlag) {
                putJunkyulSign("sign" + sn);
                for (i = 1; i <= 20; i++) {
                    if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
                    else signID = "sign" + i

                    field = message.GetListItem(fields, signID)
                    if (field) {
                        LastSignNo = i;
                    }
                }
                sn = LastSignNo;
            }
        }
        
        /* 2023-10-12 홍승비 - 전자결재 일반버전에서도 기안자의 최종결재가 가능하므로, 서명일자 관련 분기 분리 (결재진행 js와 동일 스펙) */
    	if (LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16) {
    		OpinionText = getSignDate() + "<br>";
    	}

        psigncell = "sign" + sn;
        pseumyungcell = "jikwe" + sn;
        pseumyungdatecell = "seumyungdate" + sn;
        papprodeptcell = "approdept" + sn;
         
        var RtnVal = getGyulJeDate();
        var CurrentDate = RtnVal.split(".");
        var s = CurrentDate[1] + "." + CurrentDate[2];

        field = message.GetListItem(fields, psigncell);
        
        var signWidth = 50;
        var signHeight = 50;
        
        var field = message.GetListItem(fields, pseumyungcell);
        if (field) {
            setNodeText(field , getNodeText(field) + PositionText);
        } 
        
        var strimg;
        var SingFlag = true;
        var DekyulFlag = false;
        
        var field = message.GetListItem(fields, pseumyungdatecell);
        if (field) {
            setNodeText(field , s);
            
            /* 2023-10-05 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
    		signInfo[signCnt] = pseumyungdatecell;
    		SignName[signCnt] = pseumyungdatecell;
    		SignType[signCnt] = "TEXT";
    		SignContent[signCnt] = s;
    		signCnt = signCnt + 1;
        }
        
        // 서명일자칸이 존재하지 않는 경우, 서명칸에 서명일자를 함께 표출하기 위해 이미지 서명의 높이를 조정 (최종결재일때만 서명칸에 서명일자를 표출)
        // 대결/전결 메세지는 서명칸에 표출하므로 이미지 서명의 높이를 조정
        if ((!field && LastSignSN == 1) || CurAprType == strAprType4 || CurAprType == strAprType16) {
        	signHeight = 28;
        }
        
        // 결재선에 부서가 있는 경우.
        var field = message.GetListItem(fields, papprodeptcell);
        if (field) {
        	var userDeptInfo;
        	if(Number(arr_userinfo[17]) === 1) {
        		userDeptInfo = arr_userinfo[15];
        	} else {
        		userDeptInfo = arr_userinfo[16];
        	}
        	setNodeText(field, userDeptInfo);	
        }

        if (CurAprType == strAprType16) {
            var field = message.GetListItem(fields, psigncell);
            if (field) {
            	// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
    			if (message.GetListItem(fields, pseumyungdatecell)) {
    			    OpinionText = "<br>";
    			}
    			
                if (ret != "NAME") {
                    strimg = "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                    
					if (signImageType == "NAME") {
						strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>" + "<br>" + arr_userinfo[2];
					} else {
						strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";
					}
					 
					// 대결 시 서명일자칸 없으면 서명칸에 일자를 함께 표시, 대결 문자 우측에 서명일자 표출하며 서명의 위에 위치
					field.innerHTML = strLang7 + OpinionText + strimg;
					
					if (signImageType == "NAME") {
						OpinionText = OpinionText + "::" + arr_userinfo[2];
	                }
					
                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "IMAGE";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = ret + "::" + strLang7 + OpinionText;

                    message.DocumentBodySetAttribute(psigncell, ret);
                    signCnt = signCnt + 1;
                    SingFlag = true;
                } else {
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
        
        if (DekyulFlag && NextAprType == strAprType4) {
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
        } else if (DekyulFlag) {
        } else {
            var field = message.GetListItem(fields, psigncell);

            if (field) {
            	// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
    			if (message.GetListItem(fields, pseumyungdatecell)) {
    			    OpinionText = "<br>";
    			}
    			
                if (ret != "NAME") {
                    strimg = "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                   	if (signImageType == "NAME") {
                    	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>" + "<br>" + arr_userinfo[2];
                    } else {
                        strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";
                    }
                    
                    if (CurAprType == strAprType4) { // 전결
                        OpinionText = strLangAprType4 + OpinionText;
                    }
                    
					if (OpinionText != "<br>") { // 서명일자 또는 전결 문자가 존재
                        field.innerHTML = OpinionText + strimg;
                    }
                    else { // 서명일자와 전결 문자가 없는 최종결재
                    	OpinionText = "";
						field.innerHTML = strimg;
					}
					
					if (signImageType == "NAME") {
						OpinionText = OpinionText + "::" + arr_userinfo[2];
	                }
					
                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "IMAGE";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = ret + "::" + OpinionText;
                    
                    message.DocumentBodySetAttribute(psigncell, ret);
                    signCnt = signCnt + 1;
                    SingFlag = true;
                } else {
                    if (field) {
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                        
                        if (CurAprType == strAprType4) {
                            OpinionText = strLangAprType4 + OpinionText;
                        }
                        
                        if (OpinionText != "<br>") { // 서명일자 또는 전결 문자가 존재
                        	field.innerHTML = OpinionText + strimg;
                    	}
                    	else { // 서명일자와 전결 문자가 없는 최종결재
                    		OpinionText = "";
							field.innerHTML = strimg;
						}
                        
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
        } else if (pDraftFlag == "HAPYUI") {
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
		dataType : "text",
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

    return SelectSingleNodeValue(loadXMLString(result), "RESULT");
}
function ConvertDocState(pDocState) {
	var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
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

    return SelectSingleNodeValue(loadXMLString(result), "RESULT");
}

var getformcont_cross_dialogArguments = new Array();
/* 기안을 위한 양식창을 띄우는 곳 */
function openFormUI() {
    try {
        var parameter = new Array();
        parameter[0] = arr_userinfo[4];
        parameter[1] = "000";

        getformcont_cross_dialogArguments[0] = parameter;
        getformcont_cross_dialogArguments[1] = openFormUI_Complete;

        DivPopUpShow(713, 570, "/ezApprovalG/getFormCont.do?fileType=mht");
    } catch (e) {
        alert("openFormUI()" + e.description);
    }
}

function openFormUI_Complete(ret) {
    DivPopUpHidden();
    pFormHref = ret[0];
    pDocType = ret[1];
    // 2021-01-21 심기영 오피스결재 추가
    officeFlag = ret[4];
    
    checkHeaderAction();

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
            pPublicityYN = "";
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
    } else {
        if (pFormHref != "cancel") {
            pReadPC = false;

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
            pPublicityYN = "";
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
            pHasOpinionYN = "N";			// 2021-04-29 김민성 - 기안 > 양식선택시 기존에 의견이 있었던 경우 값이 안바뀌는 오류 수정 

            message.Set_EditorContentURL(pFormHref);
            
            // 2021-01-21 심기영 오피스결재 추가
             if(officeFlag == 'Y') {
	        	document.getElementById("mailPanel").style.display = "";
	        	document.getElementById("layerpopup").style.display = "";
	        	document.getElementById("iFrameLayer2").src = "/ezApprovalG/officeAttach.do";
            }
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
        
        if (pDraftFlag == "DRAFT" || DocSN != "") {
            setMenuBar("btnSaveServer", true);
        }

        //setFormAprOption();  //결재 세부옵션
    } catch (e) {
        alert("SetBtnStateTrue()" + e.description);
    }
}
function createNewDoc() {
	var url = "/ezApprovalG/createNewDoc.do";
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
    		}, error: function() {
    			 var pAlertContent = strLang131 + "<br> " + strLang132;
    	         OpenAlertUI(pAlertContent);
    	         return "";
    		}      
    	});
        return result;
    } catch (e) {
        alert("createNewDoc()" + e.description);
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
        
        var pDeptName = arr_userinfo[5];
        if (typeof upperDeptName !== "undefined" && upperDeptName !== "") {
            pDeptName = upperDeptName;
        }
        
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
                        field.textContent = pDeptName;
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
                        field.textContent = getNodeText(GetElementsByTagName(objNodes, "COMPANY")[0]) + strLang157;// + strLang148;
                        break;

                    case "username":         
                        field.textContent = arr_userinfo[2];
                        break;

                    case "draftername":      
                        field.textContent = arr_userinfo[2];
                        break;

                    case "draftdate":
                        /*field.textContent = FullDate;*/
                        field.textContent = CurrentDate;
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
                            field.textContent = SendName + strLang93;
                        break;
                }
            } else {
                switch (field.id) {
                    case pSusinSN + "receiptdate":
                        field.textContent = CurrentDate;
                        break;
                    
                    case "bedocnumber":
                        setDocNumFormat("be");
                        break;

                    case "docnumber":
                        setDocNumFormat("");
                        break;

                    case "draftdate":
                    	/*field.textContent = FullDate;*/
                        field.textContent = CurrentDate;
                    	break;
                    	
                    /**
                     * 부서이동 혹은 부서이름 변경 전 임시보관한 문서의 부서이름이 바뀌지 않는현상 수정
                     * 부서이름 뿐만아니라 직위 및 기안자 이름도 수정되도록 수정 
                     * */
                    case "draftername":      
                        field.textContent = arr_userinfo[2];
                        break;
                    case "position":
                        field.textContent = arr_userinfo[3];
                        break;
                    case "department":
                    	field.textContent = arr_userinfo[5];
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
            	//가변결재선 양식으로 수신문을 사용하는경우, 양식내에 수신처란이 없어도 수신문으로 인식되도록
            	if ($("#message").contents().find("#autoLine").length > 0 && DocType == "003") {
            		pSuSinFlag = "Y";
            		setMenuBar("btnSetReceivLine", true);
            		CheckGubun = "1";
            	} else {
            		pSuSinFlag = "N";
            		setMenuBar("btnSetReceivLine", false);
            		CheckGubun = "11";
            	}
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
        
        if (message.GetListItem(fields, "deptgamsasign")) {
            deptgamsaCount = 1;
        }

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
        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
        parameter[99] = "mht";
        
        apropinion_cross_dialogArguments[0] = parameter;
        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;

        DivPopUpShow(530, 495, "/ezApprovalG/aprOpinion.do");

    } catch (e) {
        alert("openOpinionUI(pOpinionFlag)" + e.description);
    }
}

function openOpinionUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel" && ret != "Clear") {
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
    } else if (ret == "Clear") {
    	pHasOpinionYN = "N";
    }
}

function openOpinionUI_New(pOpinionType, CompleteFunction) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = pDraftFlag;	//DRAFTFLAG
		parameter[3] = "";			//DOCSTATE 기안은 공백 고정
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
}

var aprattach_cross_dialogArguments = new Array();
function openFileAttachUI() {
    try {
        aprattach_cross_dialogArguments[0] = "";
        aprattach_cross_dialogArguments[1] = "";

        DivPopUpShow(800, 610, "/ezApprovalG/aprAttach.do?formID=" + encodeURI(pFormID) + "&docID=" + encodeURI(pDocID) + "&draftFlag=" + DraftFlag + "&orgCompanyID=" + orgCompanyID + "&ext=" + ext);
    } catch (e) {
        alert("openFileAttachUI()" + e.description);
    }
}

var aprcabinetattach_cross_dialogArguments = new Array();
/**
 * [문서첨부]
 * */
function openAaprDocAttachUI() {
    try {
        var parameter = pDocID;
        var url ;
        
        if(approvalFlag == "G") {
        	url = "/ezApprovalG/aprCabinetAttach.do?" + "draftFlag=" + DraftFlag;
        } else {
        	url = "/ezApprovalG/aprDocAttach.do?orgCompanyID=" + orgCompanyID;
        }
        	
        if (CrossYN()) {
            aprcabinetattach_cross_dialogArguments[0] = parameter;
            aprcabinetattach_cross_dialogArguments[1] = openAaprDocAttachUI_Complete;

            DivPopUpShow(1050, 560, url);
        } else {
        	var feature;
        	if(approvalFlag == "G") {
        		feature = "status:no;dialogWidth:805px;dialogHeight:395px;edge:sunken;scroll:no;help:no";
        		feature = feature + GetShowModalPosition(675, 395);
        	} else {
        		feature = "status:no;dialogWidth:1050px;dialogHeight:660px;edge:sunken;scroll:no";
        	}
           
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
/**
 *  기안진행 중인 문서 파일 생성
 * */
function SaveDraftDocInfo() {
    var rtnVal;
    rtnVal = SaveFile();

    if (rtnVal.toUpperCase() != "TRUE") {
        return rtnVal;
    }

    SignSave();
    rtnVal = SaveDraftDocInfo_ilban("002");
    if (rtnVal.toUpperCase() == "FALSE") {
    	 return rtnVal;
    }

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
        createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "FORMID", pFormID);

        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
            createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pDocID);
            createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", pDocType);
            createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", pDocState);
        } else {
            createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", "");
            createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", "");
            createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", "");
        }

        createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", pState);
        createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + pDocID + ".htm");

        //field = message.GetListItem(fields, "doctitle");
        createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", message.GetDocTitle());

        var field = message.GetListItem(fields, "docnumber");
        var deptfield = message.GetListItem(fields, "deptshortedname");
        if (deptfield) {
            createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(deptfield));
        } else if (field) {
            createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
        } else {
            var field = message.GetListItem(fields, "bedocnumber");
            if (field)
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
            else
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
        }

        createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);

        var startdate;
        if (pState == strAprState0)
            startdate = "DRAFTSAVE";
        else
            startdate = "DRAFT";
        
        createNodeAndInsertText(xmlpara, objNode, "STARTDATE", startdate);
        createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WRITERID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", arr_userinfo[2]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", arr_userinfo[3]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", arr_userinfo[5]);
        createNodeAndInsertText(xmlpara, objNode, "HTML", "");
        createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");
        createNodeAndInsertText(xmlpara, objNode, "PUSERID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[2]);

        var pDeptID = arr_userinfo[4];
        if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
            pDeptID = upperDeptCode;
        }        
        createNodeAndInsertText(xmlpara, objNode, "PDEPTID", pDeptID);

        createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);

        createNodeAndInsertText(xmlpara, objNode, "PUBLIC", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
        createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
        createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);
        createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");

        createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", pPublicityYN);
        createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
        createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
        createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
        createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
        if (!g_SepAttachLVXml){
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
        } else{
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));
        }
        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);

        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);

        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);
        if (curDocNum != "") {
       	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
       } else {
       	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
       }
        
        createNodeAndInsertText(xmlpara, objNode, "PASSAPRLINE", passAprLine);
        
        /*
    	 * 2018-06-14 천성준
    	 * 비전자문서 데이터 세팅 메소드
    	 * */
    	if (nonElecRec == "Y") {
    		var NonElecXML = createXmlDom();
    		NonElecXML = loadXMLString(nonElecRecInfoXml);
    		
    		createNodeAndInsertText(xmlpara, objNode, "NONELECREC", nonElecRec);
    		createNodeAndInsertText(xmlpara, objNode, "REGISTERTYPE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE"));
    		createNodeAndInsertText(xmlpara, objNode, "REGISTERDATE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERDATE"));
    		createNodeAndInsertText(xmlpara, objNode, "REGISTERYEAR", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERYEAR"));
    		createNodeAndInsertText(xmlpara, objNode, "EXECUTEDATE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "EXECUTEDATE"));
    		createNodeAndInsertText(xmlpara, objNode, "TITLE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "TITLE"));
    		createNodeAndInsertText(xmlpara, objNode, "APRMEMBERTITLE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "APRMEMBERTITLE"));
    		createNodeAndInsertText(xmlpara, objNode, "APRMEMBERTITLE2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "APRMEMBERTITLE2"));
    		createNodeAndInsertText(xmlpara, objNode, "DRAFTERNAME", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DRAFTERNAME"));
    		createNodeAndInsertText(xmlpara, objNode, "DRAFTERNAME2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DRAFTERNAME2"));
    		createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "RECEIPTMEMBER"));
    		createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "RECEIPTMEMBER2"));
    		createNodeAndInsertText(xmlpara, objNode, "SENDINGMEMBER", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SENDINGMEMBER"));
    		createNodeAndInsertText(xmlpara, objNode, "DELIVERYNO", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DELIVERYNO"));
    		createNodeAndInsertText(xmlpara, objNode, "ORIGINREGSN", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "ORIGINREGSN"));
    		createNodeAndInsertText(xmlpara, objNode, "ELECTRONICRECFLAG", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "ELECTRONICRECFLAG"));
    		createNodeAndInsertText(xmlpara, objNode, "NONELECREC_CABINETID", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "CABINETID"));
    		
    		// 시청각 기록물일경우
    		if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "5" || SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "6") {
    			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECINFO", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "AUDIOVISUALRECINFO"));
    			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECSUMMARY", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SUMMARY"));
    		}
    		
    		// 분리첨부가 존재할 경우
    		if (SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW").length > 0) {
    			var sepAtt, Data, i;
    			var rtnXml = createXmlDom();
    	        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
    			var sepLVXml = createXmlDom();
                	sepLVXml = loadXMLString(nonElecRecInfoXml);
                var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW");
                
                for (i = 0; i < rows.length; i++) {
                    sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID",  SelectSingleNodeValue(rows[i], "CABINETID"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", SelectSingleNodeValue(rows[i], "SEPTITLE"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(rows[i], "SEPNUMOFPAGE"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", SelectSingleNodeValue(rows[i], "SEPREGTYPE"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", SelectSingleNodeValue(rows[i], "SEPSUMMARY"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", SelectSingleNodeValue(rows[i], "SEPRECORDTYPE"));
                }
                
                createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SEPERATEATTACH", getXmlString(rtnXml));
    		}

            if (SelectNodes(NonElecXML, "DOCATTACHNAME").length > 0 ) {
                createNodeAndInsertText(xmlpara, objNode, "DOCATTACHNAME", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DOCATTACHNAME"));
            }
    	}
    	
        xmlhttp.open("POST", "/ezApprovalG/doDraft.do", false);
        xmlhttp.send(xmlpara);

    	if (xmlhttp.status == 200) {
    		 if (pState != "000")
    	            SetBtnStateFalse();
    	        var dataNodes = GetChildNodes(xmlhttp.responseXML);
    	        return getNodeText(dataNodes[0]);
    	} else {
    		return "FALSE";
    	}
    } catch (e) {
        alert("SaveDraftDocInfo_ilban(pState)" + e.description);
    }
}

function getfieldValue(pfield) {
    var rtnVal = "";
    if (pfield) {
        switch (pfield.tagName) {
            case "TD":
                rtnVal = getNodeText(pfield);
                break;
            case "SELECT":
                rtnVal = getNodeText(pfield);
                break;
            case "INPUT":
                rtnVal = getNodeText(pfield);
                break;
        }
    }
    return rtnVal;
}

var aprsign1_cross_dialogArguments = new Array();
/**
 * 결재자의 사인 저장 여부 확인
 * */
function openSignUI() {
    try {
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
    	
        var SignNodeList;

        SignNodeList = SelectNodes(loadXMLString(result), "LISTVIEWDATA/ROWS/ROW");

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
        var url = "/ezApprovalG/aprLine.do";
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
    parameter[2] = "SEND";
    parameter[3] = isExtDoc;
    parameter[4] = DocType;

    var url = "../ezAPRDEPT/AprDept1_Cross.aspx";
    var feature = "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(855, 530);
    var ret = window.showModalDialog(url, parameter, feature);
    return ret;
}

function GetAprDocFormID(tempDocID) {
    try {
    	var result = "";
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getAprDocFormID.do",
    		data : {
    			docID : typeof tempDocID == "undefined" || tempDocID == "" ? pDocID : tempDocID
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});

        pFormID = SelectSingleNodeValueNew(loadXMLString(result), "DATA/FORMID");
        
        if (approvalFlag == "S") {
        	if (pFormID == "") {
            	isTmpDocID = MakeTmp2Ing(DocSN)
                pDocID = isTmpDocID;
                GetAprDocFormID();
            }
        }
        
    } catch (e) {
        alert("GetAprDocFormID()" + e.description);
    }
}

function MakeTmp2Ing(tmpDocID) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/makeTmp2Ing.do",
		data : {
			tmpDocID : tmpDocID
		},
		success: function(xml){
			result = xml;
		}
	});
    return  getNodeText(loadXMLString(result).documentElement);
}

function trim(parm_str) {
    if (parm_str == "")
        return "";
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
                            field = message.GetListItem(fields, fieldTmpseumyung);
                            if (field) {
                                field.textContent = "";
                            }

                            field = message.GetListItem(fields, fieldTmpseumyungdate);
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
//  ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
    	if (isIE() && !document.getElementById("iFrameLayer")) {
    		var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    		feature = feature + GetShowModalPosition(330, 205);
			var rtn = window.showModalDialog(url, parameter, feature);
    	} else {
    		ezCommon_cross_dialogArguments[0] = parameter;
    		if (CompleteFunction != undefined)
    			ezCommon_cross_dialogArguments[1] = CompleteFunction;
    		else
    			ezCommon_cross_dialogArguments[1] = OpenAlertUI_Complete;
    		DivPopUpShow(330, 205, url);
    	}
    } else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        if (url != "")
        	var rtn = window.showModalDialog(url, parameter, feature);
        
        if(rtn) {
        	Complete_Deaft2();
        }
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
    } else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        if (url != "")
            var rtn = window.showModalDialog(url, parameter, feature);
        if (rtn) {
        	 window.returnValue = true; // 한글기안기 반송의견 삭제 안되는 버그로 인해 변경.
        	 //window.close();
        }
    }
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}
function getDocInfo() {
	var result = "";
	
	if (isUsed == "reuse") {
		url = "/ezApprovalG/getDocInfo.do?isUsed=" + isUsed + "&beforeDocID=" + beforeDocID;
	} else {
		url = "/ezApprovalG/getDocInfo.do";
	}
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : url,
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});
	
    xmldoc = result;
    var objNodes = xmldoc.documentElement.childNodes;
    if (objNodes) {
        pOrgDocID = SelectSingleNodeValueNew(result, "DATA/ORGDOCID");
        if (SelectSingleNodeValueNew(result, "DATA/HASOPINIONYN") == "Y" || SelectSingleNodeValueNew(result, "DATA/HASOPINIONYN") == "O")
            pHasOpinionYN = "Y";
       
//        if (isUsed == "reuse") {
//        	if (apprReuseConfig != '1') {
//        		doctitle = SelectSingleNodeValueNew(result, "DATA/DOCTITLE");
//        	}
//        }
        
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
        pPublicityYN = SelectSingleNodeValueNew(result, "DATA/PUBLICITYYN");
        pLimitRange = SelectSingleNodeValueNew(result, "DATA/LIMITRANGE");
        pPageNum = SelectSingleNodeValueNew(result, "DATA/PAGENUM");
        cabinetID = SelectSingleNodeValueNew(result, "DATA/CABINETID");
        TaskCode = SelectSingleNodeValueNew(result, "DATA/TASKCODE");
        tempSecurityDate = SelectSingleNodeValueNew(result, "DATA/SECURITYAPPROVAL");

        if (useOpenGov == "YES") {
            basis = SelectSingleNodeValueNew(result, "DATA/BASIS");
            reason = SelectSingleNodeValueNew(result, "DATA/REASON");
            listOpenFlag = SelectSingleNodeValueNew(result, "DATA/LISTOPENFLAG");
            fileOpenFlagList = SelectSingleNodeValueNew(result, "DATA/FILEOPENFLAGLIST");
            limitDate = SelectSingleNodeValueNew(result, "DATA/LIMITDATE");
        }
    }
}

function HabyuiResultOpinion() {
    try {
        var parameter = new Array();
        var rtnVal = true;

        parameter[0] = "";
        parameter[1] = "N";
        parameter[2] = KuyjeType;
        parameter[3] = pOrgDocID;
        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
        parameter[99] = "mht";
        
        var url = "/ezApprovalG/aprOpinion.do";
        var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no";
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
    var numHeader = "";

    var fields = message.GetFieldsList();

    if (approvalFlag == "G") {
        if (pDraftFlag == "REDRAFT" && ListType != "21") {
        	return;
        }
    }

    var field = message.GetListItem(fields, pPrefix + "docnumber");
    
    if (!field) {
    	return
    }
    
    var fieldValue = message.DocumentBodyGetAttribute("orgdocnum", 0);

    numHeader = getDocNumByFormat(fieldValue);
    
    field.textContent = numHeader;
    if (numHeader.indexOf(strLang107) > 0)
        message.DocumentBodySetAttribute("docnum", numHeader);

    var field = message.GetListItem(fields, "receiptnumber");
    if (field) {
        field.setAttribute("Format", field.textContent.trim());
        message.DocumentBodySetAttribute("receiptnumber", field.textContent.trim());
        field.textContent = "";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }
}

function getDocNumByFormat(format) {
    format = format.trim();
    var Arr_Header = new Array();
    var numHeader = "";
    var d = new Date();
    Arr_Header = format.split("-");

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
                    numHeader += yyear.toString().substring(2);
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
                    numHeader += format;
                    break;
            }
        } else {
            numHeader += item;
        }

        if (!(index == Arr_Header.length - 1)) {
            numHeader += "-";
        }
    });

    return numHeader;
}

var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd() {
    var parameter = pUserID;

    ezchkpasswd_cross_dialogArguments[0] = parameter;
    ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

    DivPopUpShow(350, 225, "/ezApprovalG/ezchkPasswd.do");
}

function setDrafterAddress() {
    message.DocumentBodySetAttribute("drafter", arr_userinfo[2]);
    message.DocumentBodySetAttribute("address", arr_userinfo[8]);
    message.DocumentBodySetAttribute("drafterdept", arr_userinfo[4]);
    message.DocumentBodySetAttribute("lastKyulName", lastKyulName);
    message.DocumentBodySetAttribute("lastKyuljikwee", lastKyuljiwee);
}
function setFirstDrafter(type, beforDocID) {
    var ret = getAutoAprLine(type, beforDocID);
    
    if (nonElecRec == "Y"){return}

    if (ret[0] != "NONE") {
        IsSkipDrafter = "FALSE";
        btnSendDraftEnable = "true";
        ret[1] = ret[0];
        ret[5] = ret[2];
        
        if (approvalFlag == "S") {
        	SGetDraftAprLineInfo(ret);
        } else {
        	GetDraftAprLineInfo(ret);
        }
    }
    return;
}
function delOpinionInfo(tmpID) {
	var opinionType = "";
	if (useRedraftOpinionKeep != "YES") {
		opinionType = "100"
	} else {
		opinionType = "003";
	}

	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/ezApprovalG/deleteOpinionTypeInfo.do",
		data : {
			docID : tmpID ? tmpID : pDocID,
			opinionType : opinionType
		},
		success: function(result) {
			
		}
	});
	
	pHasOpinionYN = "";
	
    /*var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "DocID", "002");

    xmlhttp.open("POST", "../ezAPROPINION/aspx/DeleteOpinionTypeInfo.aspx", false);
    xmlhttp.send(xmlpara);

    pHasOpinionYN = "";
    return xmlhttp.responseText;*/
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
		dataType : "text",
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

    return getXmlString(loadXMLString(result));
}
function getDeptSymbol(DeptID, DeptName) {
	var result = "";
	var dataNodes;
	var RtnVal;
	
	if(approvalFlag == "S") {
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/getChaebunDept.do",
			data : {
				deptID : DeptID,
				orgCompanyID : orgCompanyID
			},
			success: function(xml){
				result = xml;
				if(result != null) {
					dataNodes = GetChildNodes(loadXMLString(result).documentElement);
					DeptName = getNodeText(dataNodes[0]);
					RtnVal = getNodeText(dataNodes[1]);
				}
			}        			
		});
	} else {
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
	
		dataNodes = GetChildNodes(loadXMLString(result).documentElement);
		RtnVal = getNodeText(dataNodes[0]);
	}
	
    if (RtnVal == "") {
        return DeptName;
    }
    else {
        return RtnVal;
    }
}
function getDeptSendName(DeptID) {
	var result = "";
	var resultNode;
	
	$.ajax({
		type : "POST",
		dataType : "text",
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
	
	resultNode = loadXMLString(result);
	
	if (resultNode.firstChild) {
		resultNode = resultNode.firstChild;
	}
	
    return trim(SelectSingleNodeValue(resultNode, "EXTENSIONATTRIBUTE5"));
}
function setMenuBar(id, flag) {
    var strCmd, display_Value;

    if (flag)
        display_Value = "";
    else
        display_Value = "none";

    strCmd = id + ".style.display='" + display_Value + "'";
    eval(strCmd);
}
/**
 *  mht파일 생성.
 * */
function SaveFile() {
	
	headerAction("open");
	var result = "";
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
function SignSave() {
    if (SignContent.length > 0) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objRoot, objNode, subNode;
        objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

        for (i = 0; i < SignContent.length; i++) {
            objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "SIGNINFO");
            if(typeof draftAllTypeB != "undefined" && draftAllTypeB == "Y" && an.options.length > 1)
                subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", pDocIDAry);
            else
                subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", pDocID);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNTYPE", SignType[i]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNNAME", SignName[i]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "CONTENT", SignContent[i]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "ORGCOMPANYID", orgCompanyID);
        }
        xmlhttp.open("Post", "/ezApprovalG/setSignInfo.do", false);
        xmlhttp.send(xmlpara);
    }
}

function SaveOrgFile() {
	var result = "";
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
function SignCheck() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getSignInfo.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}
	});
	
    var SignXML = createXmlDom();

    if (result == "" || result == null) {
        return;
    }

    var NodeList;
    NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");
    
    if (NodeList.length <= 0) {
        return;
    }
    
    SignXML = result;

    var rtnVal = putSignXML(SignXML);
    
    if (rtnVal) {
        SaveFile();
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
                    	var seumyung = message.GetListItem(fields, "seumyungdate" + (i + 1));
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
                        
                        if (seumyung) {
                        	signHeight = 50;
                        } else {
                        	signHeight = 28;
                        }

                        var strimg;
                        if (img.length >= 1) {
                            strimg = "<img src='" + encodeURI(img[0]) + "' border=0 embedding='1' "; //20110209 exchange2010 적용후 결재문서 메일 발송시 이미지깨짐
                            strimg = strimg + " width=" + signWidth;
                            strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>";
                            message.DocumentBodySetAttribute(SignName, img[0]);
                        }
                        
                        if (seumyung) {
                        	field.innerHTML = strimg;
                        } else {
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
		dataType : "text",
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
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getSignDate.do",
		data : {
			getDate : ""
		},
		success: function(text){
			result = text;
		}
	});

    return result;
}

function getHistory() {
    var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + ext;
    centerOpenWindow(URL, 740, 450);
}

function centerOpenWindow(wfileLocation, wWeight, wHeight) {
    try {
        if (CrossYN()) {
        	if (isIE() && !document.getElementById("iFrameLayer")) {
        		var heigth = window.screen.availHeight;
        		var width = window.screen.availWidth;
        		var left = (width - wWeight) / 2;
        		var top = (heigth - wHeight) / 2;
        		window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
        	} else {
        		DivPopUpShow(wWeight, wHeight, wfileLocation);
        	}
        } else {
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
function UpdateLineHistory(tmpDocID) {
	var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateLineHistory.do",
		data : {
			docID : tmpDocID ? tmpDocID : pDocID,
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
			var pAlertContent = strLang91;
	        OpenAlertUI(pAlertContent);
		}
	});
}

var AutoSave;
function SaveTMPFile(AutoSave) {
	
	headerAction("open");
    var mhtBody = "";
    mhtBody = message.Get_EditorBodyHTML();
    mhtBody = "<HTML>" + GetCKEditerHeader() + mhtBody + "</HTML>";
    mhtBody = ConvertHTMLtoMHT(mhtBody);
	
    var docID = "";
    if(Saveflag) {
    	docID = newpDocID;
    }
    else {
    	docID = pDocID
    }
    
    if(AutoSave == "autosave" && createAutoDoc == "Y"){
        docID = autopDocID;
    }
    
	var data = {
		docID : docID,
        formId : pFormID,
		html  : mhtBody
	}

    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveTmpFile.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});

    return result;
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

        var pAutoTmpDocTitle = trim(message.GetDocTitle());
        createNodeInsert(xmlpara, objNode, "PARAMETER");

        if(Saveflag) {
            if(AutoSave == "autosave" && createAutoDoc == "Y"){
                createNodeAndInsertText(xmlpara, objNode, "DOCID", autopDocID);
            }else{
                createNodeAndInsertText(xmlpara, objNode, "DOCID", newpDocID);
            }
        }else {
            if(AutoSave == "autosave" && createAutoDoc == "Y"){
                createNodeAndInsertText(xmlpara, objNode, "DOCID", autopDocID);
            }else{
                createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
            }
        }
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

        createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", strAprState1);
        createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + pDocID + ".htm");

        if (AutoSave != "") {
            if(pAutoTmpDocTitle != "") {
                createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", message.GetDocTitle());
            }else{
                createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", strLang1133);
            }
        }
        else {
            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", strLang1133);
        }

        field = message.GetListItem(fields, "docnumber");
        if (field)
            createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));

        else {
            field = message.GetListItem(fields, "be_docnumber");
            if (field)
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
            else
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
        }

        //var field = fields("deptshortedname")
        //if (field)
        //    objNode.text = getfieldValue(field);
        //xmlpara.documentElement.appendChild(objNode);

        createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);
        createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "DRAFTSAVE");
        createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WRITERID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "HTML", "");
        createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");
        createNodeAndInsertText(xmlpara, objNode, "PUSERID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "PDEPTID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "PUBLIC", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
        createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
        createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);
        createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");
        createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", pPublicityYN);
        createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
        createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
        createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
        createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");
        createNodeAndInsertText(xmlpara, objNode, "FORMHREF", FormHref);
        createNodeAndInsertText(xmlpara, objNode, "DOCSN", DocSN);
        createNodeAndInsertText(xmlpara, objNode, "LISTTYPE", ListType);
        createNodeAndInsertText(xmlpara, objNode, "DRAFTFLAG", DraftFlag);
        
        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
        if (!g_SepAttachLVXml)
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));

        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);
        createNodeAndInsertText(xmlpara, objNode, "SUMMARYPATH", pSummaryPath);
        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);
        
        if (isUsed == "reuse") {
            createNodeAndInsertText(xmlpara, objNode, "beforeDocID", beforeDocID);
            createNodeAndInsertText(xmlpara, objNode, "isUsed", isUsed);
            createNodeAndInsertText(xmlpara, objNode, "saveFlag", Saveflag);
            createNodeAndInsertText(xmlpara, objNode, "oldDocID", pDocID);
        } else if(Saveflag) {
        	createNodeAndInsertText(xmlpara, objNode, "saveFlag", Saveflag);
        	createNodeAndInsertText(xmlpara, objNode, "oldDocID", pDocID);
        }
        
        if (AutoSave == "autosave" && createAutoDoc == "Y"){
            createNodeAndInsertText(xmlpara, objNode, "autopDocSN", autopDocSN);
            createNodeAndInsertText(xmlpara, objNode, "autoSaveFlag", "Y");
        }

        if (AutoSave == "autosave"){
            createNodeAndInsertText(xmlpara, objNode, "FautoSaveFlag", AutoSave);
        }
        xmlhttp.open("POST", "/ezApprovalG/doDraft.do", false);
        xmlhttp.send(xmlpara);
        
     	if (xmlhttp.status == 200) {
     		return xmlhttp.responseText;
     	} else {
     		return "FALSE";
     	}
      
    } catch (e) {
        OpenAlertUI("SaveTMPDocInfo()" + e.description);
    }
}

function RemoveTmpDoc(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/removeTMPDocInfo.do",
		data : {
			docID : pDocID
		},
		success: function(text){
			result = text;
		},
		error : function() {
			var pAlertContent = strLang1134;
	        OpenAlertUI(pAlertContent);
		}
	});
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
    pxml = pxml + "<COLUMN><![CDATA[" + arr_userinfo[2] + "]]></COLUMN>"
    pxml = pxml + "<COLUMN><![CDATA[" + arr_userinfo[3] + "]]></COLUMN>"
    pxml = pxml + "<COLUMN><![CDATA[" + arr_userinfo[5] + "]]></COLUMN>"
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
    pxml = pxml + "<DATA name='PMemberName'><![CDATA[" + arr_userinfo[11] + "]]></DATA>"
    pxml = pxml + "<DATA name='SMemberName'><![CDATA[" + arr_userinfo[12] + "]]></DATA>"
    pxml = pxml + "<DATA name='PMemberDeptName'><![CDATA[" + arr_userinfo[15] + "]]></DATA>"
    pxml = pxml + "<DATA name='SMemberDeptName'><![CDATA[" + arr_userinfo[16] + "]]></DATA>"
    pxml = pxml + "<DATA name='PMemberJobTitle'><![CDATA[" + arr_userinfo[13] + "]]></DATA>"
    pxml = pxml + "<DATA name='SMemberJobTitle'><![CDATA[" + arr_userinfo[14] + "]]></DATA>"
    pxml = pxml + "</ROW></ROWS></LISTVIEWDATA>"

    xmlpara = loadXMLString(pxml);

    var url = typeof draftAllTypeB != "undefined" && draftAllTypeB == "Y" && an.options.length > 1 ? "/ezApprovalG/aprLineSaveAll.do" : "/ezApprovalG/aprLineSave.do";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : url,
		data : {
				ret    : pxml,
                docIDAry : pDocIDAry
		},
		success : function(result){
			
		}
	});
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
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0 && !imgColl.item(i).src.toLowerCase().indexOf(".tmp")) {
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
	$.ajax({
		url : "/ezCommon/convertSaveImage.do",
		type : "POST",
		async : false,
		data : {
			"url" : encodeURI(pUrl),
			"height" : pImgHeight,
			"width" : pImgWidth,
			"type" : 2
		}
	});
}

function getAddress(puserIDs) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getAddress.do",
		data : {
			userID : puserIDs
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    return result;
    
}
//재기안 시, 문서내 기안일자와 현재일자가 다르면 현재일자로 수정되게
function compareDocDateCurDate() {
	try {
		var fields = message.GetFieldsList();
		if (!fields) return;
		
		var field = message.GetListItem(fields, "draftdate");
		
		var DocumentDate = field.textContent;	//문서내 기안일자
		var CurrentDate = getGyulJeDate();		//현재일자
		
		if (DocumentDate != "" && CurrentDate != "" && DocumentDate != CurrentDate) {
			field.textContent = CurrentDate;
		}
	} catch(e){ console.log("ERROR::::compareDocDateCurDate() " + e.description); }
}

//결재 세부옵션처리
function setFormAprOption(){  
    if(formAprOption.indexOf("_a2_"))  //파일첨부
        setMenuBar("btnFileAttach", false);	
    if(formAprOption.indexOf("_a3_"))  //문서첨부
        setMenuBar("btnAprDocAttach", false);	
}
    
//기결재통과 시, 기결재자 제외하고 사인칸 다시 그리고 정보 세팅해주는 메소드.. 급하게 만드느라 디버깅 거의 불가하게 만들어버림
function SReAprLineSingMapping(ret) {
	var lineXml = "";
	
	if (typeof(ret) == "object") {
		lineXml = ret[1];
		New_DrawAutoLine(lineXml, pDraftFlag);
	} else {
		return false;
	}
	
	var SusinSN = "";
	if (pDraftFlag == "SUSIN") {
		SusinSN = "1";
	}
	
	var reOrderSignName = new Array();
	var reOrderSignTitle = new Array();
	var reOrderHabyName = new Array();
	var reOrderHabyTitle = new Array();
	
	var OrderName = new Array();
	var OrderDept = new Array();
	var OrderType = new Array();
	var OrderTypeName = new Array();
	var OrderStat = new Array();
	var OrderStatName = new Array();
	var OrderJobtitle = new Array();
	var OrderReason = new Array();
	
	var xmlDom = createXmlDom();
	xmlDom = loadXMLString(lineXml);
	
	var oRows = SelectNodes(xmlDom, "LISTVIEWDATA/ROWS/ROW");
	var oCount = oRows.length;
	
	var dataNodes, tempSn;
	for (var i = 0; i < oCount; i++) {
		dataNodes = GetChildNodes(oRows[i]);
		tempSn = getNodeText(dataNodes[0]);
		
		OrderName[tempSn] = getNodeText(dataNodes[1]);
		OrderDept[tempSn] = getNodeText(dataNodes[3]);
		OrderType[tempSn] = getNodeText(dataNodes[16]);
		OrderStat[tempSn] = getNodeText(dataNodes[17]);
		OrderReason[tempSn] = getNodeText(dataNodes[12]);
		OrderTypeName[tempSn] = getNodeText(dataNodes[4]);
		OrderStatName[tempSn] = getNodeText(dataNodes[5]);
		OrderJobtitle[tempSn] = getNodeText(dataNodes[2]);
	}
	
	/* 2020-07-27 홍승비 - 반송 후 재기안 > 기결재통과 체크 > 결재선 정보 설정 시, 결재선 맵핑 오류 수정*/
	var LastSignSN = OrderType.length;
    for(var i = 1; i < OrderType.length; i++) { // 마지막 결재하는 사람 찾기
		if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) { // 전결, 대결
			LastSignSN = i;
			break;
		} else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 ||  OrderType[i] == strAprType1 ||  OrderType[i] == strAprType3) { // 기안, 검토, 결재, 결재안함
    		LastSignSN = i;
        }
    }
    
	var signMax = 0;
	var habyMax = 0;
	var startSignIdx = 1;
	var startHabyIdx = 1;
	for (var j = 1; j <= oCount; j++) {
		if (OrderType[j] == strAprType1 || OrderType[j] == strAprType3 || OrderType[j] == strAprType4 || OrderType[j] == strAprType15 || OrderType[j] == strAprType40) {
			if (OrderStat[j] == strAprState3) {
				startSignIdx++;
			} else if (OrderStat[j] == strAprState2 && j == 1) {
				startSignIdx++;
			} else {
				reOrderSignName.push(OrderName[j]);
				reOrderSignTitle.push(OrderJobtitle[j]);
			}
			signMax++;
		} else if (OrderType[j] == strAprType8 || OrderType[j] == strAprType11) {
			if (OrderStat[j] == strAprState3) {
				startHabyIdx++;
			} else {
				reOrderHabyName.push(OrderName[j]);
				reOrderHabyTitle.push(OrderJobtitle[j]);
			}
			habyMax++;
		} else if (OrderType[j] == strAprType9 || OrderType[j] == strAprType12) {
			if (OrderStat[j] == strAprState3 || OrderStat[j] == strAprState4) {
				startHabyIdx++;
			} else {
				reOrderHabyName.push(OrderName[j]);
				reOrderHabyTitle.push(OrderJobtitle[j]);
			}
			habyMax++;
		}
	}
	
	// 가변결재선이 아니라면, 마지막 결재자의 서명 필드가 존재하는지 체크 (내부결재선, 수신결재선의 최종결재자는 가장 마지막 결재칸에 표출되어야 함)
    var LastSignNo = 0;
    var isAutoAprLineExit = false;
    var autoAprLineField = $("#message").contents().find("td[id^='autoLine']");
    var signFields = $("#message").contents().find("td[id^='" + SusinSN + "sign']");
    
    if (signFields.length > 0) {
    	LastSignNo = signFields.length;
    }
    // 테넌트 컨피그와 실제 양식 상의 가변결재선 필드 모두 확인
    if (useDynamicAprLine == "1" && autoAprLineField.length > 0) {
    	isAutoAprLineExit = true;
    }
    
	var fields = message.GetFieldsList();
	var field;
	
	// 가변결재선의 초기화
	if (isAutoAprLineExit == true) {
		for (var p = startSignIdx; p <= signMax; p++) {
			field = message.GetListItem(fields, SusinSN + "jikwe" + p);
			if (field) {
				setNodeText(field , " ");
				if (new RegExp(/Firefox/).test(navigator.userAgent)) {
					field.innerHTML = "<br type='_moz'>";
				}
			}
			
			field = message.GetListItem(fields, SusinSN + "sign" + p);
			if (field) {
				setNodeText(field , " ");
				if (new RegExp(/Firefox/).test(navigator.userAgent)) {
					field.innerHTML = "<br type='_moz'>";
				}
			}
			
			field = message.GetListItem(fields, SusinSN + "seumyung" + p);
			if (field) {
				setNodeText(field , " ");
				if (new RegExp(/Firefox/).test(navigator.userAgent)) {
					field.innerHTML = "<br type='_moz'>";
				}
			}
			
			field = message.GetListItem(fields, SusinSN + "seumyungdate" + p);
			if (field) {
				setNodeText(field , " ");
				if (new RegExp(/Firefox/).test(navigator.userAgent)) {
					field.innerHTML = "<br type='_moz'>";
				}
			}
		}
	}
	else { // 일반적인 결재선의 초기화 (내부결재, 수신결재)
	    if (signFields.length > 0) {
	    	
	    	var newAddSignCnt = signMax - startSignIdx; // 이 값이 0 이하라면, 기결재된 결재선 외에 새로 추가된 결재선은 없음
	    	var signResetCnt = signFields.length - newAddSignCnt; // 양식 상의 전체 결재선 필드에서 새로 추가된 결재선 카운트를 뺀 횟수만큼 초기화를 진행
	    	
	    	if (newAddSignCnt >= 0 && signResetCnt > 0) {  // 새로 추가된 결재선이 존재하거나, 양식 상에서 초기화가 필요한 결재선 필드가 존재함
	    		// startSignIdx 지점부터 양식 상의 마지막 결재서명필드(최종결재자 영역)까지 초기화를 진행
				for (var r = startSignIdx; r <= signResetCnt; r++) {
					field = message.GetListItem(fields, SusinSN + "jikwe" + r);
					if (field) {
						setNodeText(field , " ");
						if (new RegExp(/Firefox/).test(navigator.userAgent)) {
							field.innerHTML = "<br type='_moz'>";
						}
					}
					
					field = message.GetListItem(fields, SusinSN + "sign" + r);
					if (field) {
						setNodeText(field , " ");
						if (new RegExp(/Firefox/).test(navigator.userAgent)) {
							field.innerHTML = "<br type='_moz'>";
						}
					}
					
					field = message.GetListItem(fields, SusinSN + "seumyung" + r);
					if (field) {
						setNodeText(field , " ");
						if (new RegExp(/Firefox/).test(navigator.userAgent)) {
							field.innerHTML = "<br type='_moz'>";
						}
					}
					
					field = message.GetListItem(fields, SusinSN + "seumyungdate" + r);
					if (field) {
						setNodeText(field , " ");
						if (new RegExp(/Firefox/).test(navigator.userAgent)) {
							field.innerHTML = "<br type='_moz'>";
						}
					}
				}
	    	}
	    }
	    
	}
	
	for (var p = startHabyIdx; p <= habyMax; p++) {
		field = message.GetListItem(fields, SusinSN + "habyuipositon" + p);
		if (field) {
			setNodeText(field , " ");
			if (new RegExp(/Firefox/).test(navigator.userAgent)) {
				field.innerHTML = "<br type='_moz'>";
			}
		}
		
		field = message.GetListItem(fields, SusinSN + "habyuisign" + p);
		if (field) {
			setNodeText(field , " ");
			if (new RegExp(/Firefox/).test(navigator.userAgent)) {
				field.innerHTML = "<br type='_moz'>";
			}
		}
		
		field = message.GetListItem(fields, SusinSN + "habyuija" + p);
		if (field) {
			setNodeText(field , " ");
			if (new RegExp(/Firefox/).test(navigator.userAgent)) {
				field.innerHTML = "<br type='_moz'>";
			}
		}
		
		field = message.GetListItem(fields, SusinSN + "habyuidate" + p);
		if (field) {
			setNodeText(field , " ");
			if (new RegExp(/Firefox/).test(navigator.userAgent)) {
				field.innerHTML = "<br type='_moz'>";
			}
		}
	}
	
	var sIdx = startSignIdx;
	var hIdx = startHabyIdx;
	for (var p = 0; p < reOrderSignName.length; p++) {
		
		// 가변결재선이 아닌 경우, 최종결재자는 가장 마지막 서명칸에 맵핑 (기안자=최종결재자인 경우도 동일하게 처리)
		if (p == reOrderSignName.length - 1 && isAutoAprLineExit == false) {
			sIdx = LastSignNo;
		}
		
		field = message.GetListItem(fields, SusinSN + "jikwe" + sIdx);
		if (field) {
			setNodeText(field , reOrderSignTitle[p]);
		}
		
		/* 2020-07-27 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
		field = message.GetListItem(fields, SusinSN + "sign" + sIdx);
		if (field) {
			// 서명필드만 존재
			if (message.GetListItem(fields, (SusinSN + "sign" + sIdx)) != null && message.GetListItem(fields, (SusinSN + "seumyung" + sIdx)) == null) {
				setNodeText(field , reOrderSignName[p]);
			}
			// 서명필드 + 결재자명 필드가 함께 존재
			else if (message.GetListItem(fields, (SusinSN + "sign" + sIdx)) != null && message.GetListItem(fields, (SusinSN + "seumyung" + sIdx)) != null) {
				field.innerHTML = "[NOSLASH]";
			}
	     	// 그 외의 경우, 아무런 값이 부여되지 않으므로 슬래시 이미지를 표출
		}
         	
		field = message.GetListItem(fields, SusinSN + "seumyung" + sIdx);
		if (field) {
			setNodeText(field , reOrderSignName[p]);
		}
		
		sIdx++;
	}
	
    if (isSplit == "Y") { // 슬래시 이미지 삽입
        setSignSlash("sign", SusinSN);
    }
    
	for (var p = 0; p < reOrderHabyName.length; p++) {
		field = message.GetListItem(fields, SusinSN + "habyuipositon" + hIdx);
		if (field) {
			setNodeText(field , reOrderHabyTitle[p]);
		}
		field = message.GetListItem(fields, SusinSN + "habyuija" + hIdx);
		if (field) {
			setNodeText(field , reOrderHabyName[p]);
		}
		
		hIdx++;
	}
}

var checkJobTransferStatus = function(id, deptId, jobId) {
    var result = false;
    $.ajax({
        type : "GET",
        async : false,
        url : "/ezApprovalG/checkJobTransferStatus.do",
        dataType: "text",
        data : {
            id: id,
            deptID : deptId,
            jobId : jobId
        },
        success: function() {
            result = true;
        }, error : function (e) {
            alert(e.responseText);
            result = false;
        }
    });

    return result;
}