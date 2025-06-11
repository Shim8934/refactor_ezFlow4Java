var lastKyulName, lastKyuljiwee, LastSignSN;
var DraftLastFlag = false;

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

        if (xmlReDraft == "C") {
            ApplyDocCellInfo();
        } else if (xmlReDraft == "R") {
            ClearDocCellInfo(ret);
        }

        xmldom = loadXMLString(xmlKuljea);

        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        count = objNodes.length;

        for(i=1;i<60;i++)
        {
            name = "habyuisign" + i;
            if (message.FieldExist(name) && ret[32] != "Y")
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

                name = "habyuija" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, "");
            }
            else {
               break;
            }
        }

        for (i = 1; i < 10; i++) {
            if (message.FieldExist("gamsasign" + i)) {
                message.PutFieldText("gamsasign" + i , "");
            }

            if (message.FieldExist("gamsajikwe" + i)) {
                message.PutFieldText("gamsajikwe" + i , "");
            }

            if (message.FieldExist("gamsaseumyung" + i)) {
                message.PutFieldText("gamsaseumyung" + i , "");
            }

            if (message.FieldExist("gamsaseumyungdate" + i)) {
                message.PutFieldText("gamsaseumyungdate" + i , "");
            }
        }

        if (message.FieldExist("refer")) {
            message.PutFieldText("refer", "");
        }

        if (message.FieldExist("hgamsa")) {
            message.PutFieldText("hgamsa", "");
        }

        var tmpI = 1;
        while(message.FieldExist("gongram" + tmpI)){
            message.PutFieldText("gongram" + tmpI++ , "");
        }

        var habyuiList = ["habyuiaccount", "habyuisign", "habyuija", "habyuiaddress", "tongjesign", "tongjenumber"];
        for (i = 1; i < 60; i++) {
            var isPassCnt = 0;
            for(var j = 0; j < habyuiList.length; j++){
                fieldname = habyuiList[j] + i;
                if (message.FieldExist(fieldname)) {
                    message.PutFieldText(fieldname, "");
                    isPassCnt++;
                }
            }
            if(isPassCnt == 0)
                break;
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
        if (message.FieldExist("lastKyuljikwee")) {
            message.PutFieldText("lastKyuljikwee", lastKyuljiwee);
        }

        if (message.FieldExist("lastKyulName")) {
            message.PutFieldText("lastKyulName", lastKyulName);
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

                case strAprType8: // 개인순차합의
                case strAprType9: // 개인병렬합의
                case strAprType12: // 부서병렬합의
                case strAprType11: // 부서순차합의
                    var orderStat = OrderType[i] == strAprType12 ? strLangS57 : strLangS26;
                    var habyuisign = OrderType[i] == strAprType11 || OrderType[i] == strAprType12 ? OrderDept[i] : OrderName[i];

                    fieldname = "habyui" + hapyuiCnt;
                    if (message.FieldExist(fieldname) && !(xmlReDraft == "C" && OrderStat[i] == orderStat)) {
                        message.PutFieldText(fieldname, OrderDept[i]);
                    }

                    fieldname = "habyuisign" + hapyuiCnt;
                    if (message.FieldExist(fieldname) && !(xmlReDraft == "C" && OrderStat[i] == orderStat)) {
                        if(message.FieldExist("habyuisign" + hapyuiCnt) && !message.FieldExist("habyuija" + hapyuiCnt))
                            message.PutFieldText(fieldname, habyuisign);
                    }

                    fieldname = "habyuija" + hapyuiCnt;
                    if (message.FieldExist(fieldname)) {
                        message.PutFieldText(fieldname, OrderName[i]);
                    }

                    fieldname = "habyuiaddress" + hapyuiCnt;
                    if (message.FieldExist(fieldname)) {
                        message.PutFieldText(fieldname, OrderAddress[i]);
                    }

                    fieldname = "habyuipositon" + hapyuiCnt;
                    if (message.FieldExist(fieldname) && !(xmlReDraft == "C" && OrderStat[i] == orderStat)) {
                        message.PutFieldText(fieldname, OrderJobtitle[i]);
                    }

                    fieldname = "habyuiapprodept" + hapyuiCnt;
                    if (message.FieldExist(fieldname) && !(xmlReDraft == "C" && OrderStat[i] == orderStat)) {
                        message.PutFieldText(fieldname, OrderDept[i]);
                    }

                    if (xmlReDraft == "C") {
                        IsSkipDrafter = "TRUE";
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

                case strLangS61:
                    fieldname = "gongram" + gongramCnt
                    if (message.FieldExist(fieldname)) {
                        message.PutFieldText(fieldname, OrderName[i] + " " + OrderJobtitle[i] + " " + OrderDept[i]);
                        gongramCnt = gongramCnt + 1;
                    }
                    break;

                case strLangS63:
                case strLangS64:
                    fieldname = "hgamsa"
                    if (message.FieldExist(fieldname)) {
                        message.PutFieldText(fieldname, OrderType[i] == strLangS64 ? strLangS64 : strLangS63);
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
        var Flag = "";
        if (pDraftFlag == "SUSIN" || pDocState == strDocState11) {
            susinSN = pSusinSN;
            Flag = susinSN + "Recv";
        }

        var cnt = 20;

        var fieldList = ["jikwe", "sign", "approdept", "seumyung"];
        var isPass = false;
        for (i = 1; i <= cnt; i++) {
            for(var j = 0; j < fieldList.length; j++){
                fieldname = susinSN + fieldList[j] + i;
                if (message.FieldExist(fieldname)) {
                    message.PutFieldText(fieldname, "");
                }else if(j == 0){
                    isPass = true;
                    break;
                }
            }
            if(isPass)
                break;
        }

        for (i = 1; i < cnt; i++) {
            fieldname = "hjkwe" + i
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, "");
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
                        if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + k;
                        else signID = "sign" + k;

                        if (message.FieldExist(signID)) {
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
                if (message.FieldExist(fieldname)) {
                    message.PutFieldText(fieldname, OrderJobtitle[i]);
                }

                fieldname = susinSN + "approdept" + idx;
                if (message.FieldExist(fieldname)) {
                    message.PutFieldText(fieldname, OrderDept[i]);
                }

                fieldname = susinSN + "seumyung" + idx;
                if (message.FieldExist(fieldname)) {
                    message.PutFieldText(fieldname, OrderName[i]);
                }

                fieldname = susinSN + "sign" + idx;
                if (message.FieldExist(fieldname)) {
                    /* 2020-07-24 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
                	if (draftJunGyulFlag == '1' && OrderType[i] == "004") { // 전결 서명 부여
                        message.PutFieldText(fieldname, strLang6 + "\r" + OrderName[i]);
                	}
                	// 서명필드만 존재
                	else if (!message.FieldExist(susinSN + "seumyung" + idx)) {
                		message.PutFieldText(fieldname, OrderName[i]);
                	}
                	// 서명필드 + 결재자명 필드가 함께 존재
                	else {
                	    message.PutFieldText(fieldname, "[NOSLASH]");
                	    // 그 외의 경우, 아무런 값이 부여되지 않으므로 슬래시 이미지를 표출
                	    // 그 외의 경우가 없음.
//                		field.innerHTML = "[NOSLASH]";
                	}
                	idx = idx + 1; // 서명칸이 존재하는 경우, idx를 1 증가시켜서 다음 칸을 찾는다.
                }
            }
        }
        if (isSplit == "Y")
            setSignSlash("sign", susinSN);
    } catch (e) {
        alert("SGetDraftAprLineInfo(ret)" + e.description);
    }
}

//S버젼 추가
function setSignSlash(pSignKinds, pSusin) {
    var i, j;
    var fieldName;
    var field, fieldvalue;
    var tempFieldName;
    for (i = 1; i < 21; i++) {
        fieldName = pSusin + pSignKinds + i;
        if (message.FieldExist(fieldName)) {
            fieldvalue = trim(message.GetFieldText(fieldName));
            message.MoveToField(fieldName);
            var act = message.HwpCtrl.CreateAction("CellBorder");
            var set = act.CreateSet();
            act.GetDefault(set);
            set.SetItem("DiagonalType", 1);
            if (fieldvalue == "")
                set.SetItem("SlashFlag", 0x02);
            else if (fieldvalue == "[NOSLASH]") {
            	message.PutFieldText(fieldName, "");
                set.SetItem("SlashFlag", 0x00);
            }
            else
                set.SetItem("SlashFlag", 0x00);
            act.Execute(set);
        }else{
            break;
        }
    }
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
	
	setAprLinesXML(xmlKuljea);
	
	if(xmlReDraft == "C") {
		ApplyDocCellInfo();
	} else if(xmlReDraft == "R")	{
		ClearDocCellInfo(ret);
	}
    
	xmldom = loadXMLString(xmlKuljea);
	  
	objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
	count = objNodes.length;
	
	for(i=1;i<60;i++)
	{
	   	name = "habyuisign" + i;
		if (message.FieldExist(name) && ret[32] != "Y")
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
	  		
	  		name = "habyuija" + i;
	  		if (message.FieldExist(name))
	  			message.PutFieldText(name, "");
	  	}
	  	else {
	  	   break;
	  	}
	}
	
	if (message.FieldExist("refer"))
		message.PutFieldText("refer", "");
	
	
	if (message.FieldExist("hgamsa"))
		message.PutFieldText("hgamsa", "");
	
	
	for(i=1; i < 20; i++) {
		if (message.FieldExist("gongram" + i))
			message.PutFieldText("gongram" + i, "");
	}
    
    	
	for(i=0;i < count;i++) {
		var Cell = GetChildNodes(objNodes[i]);
	    var KyljeaOrder = 		getNodeText(Cell[0]);
	    var KyljeaName = 		getNodeText(Cell[1]);
	    var KyljeaDeptName = 	getNodeText(Cell[3]);
	    var KyljeaType  = 		getNodeText(Cell[16]);
	    var KyljeaTypeName  = 	getNodeText(Cell[4]);
	    var KyljeaStat = 		getNodeText(Cell[17]);
	    var KyljeaStatName = 	getNodeText(Cell[5]);
	    var KyljeaJobtitle = 	getNodeText(Cell[2]);
	    var ReasonDoNotApprov = getNodeText(Cell[12]);
   		var suggester = 		getNodeText(Cell[13]);
   		var reporter = 			getNodeText(Cell[14]);
	      	
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
    
	LastSignSN = OrderType.length
    
    for(i=1;i<OrderType.length;i++) {
		if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) {
			LastSignSN = i;
			i = OrderType.length
		}
		
		else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType3 || OrderType[i] == strAprType13)
    		LastSignSN = i;
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
	  
	
	for(i=1;i < 20;i++) {
	  	fieldname = "jikwe" + i
		if (message.FieldExist(fieldname) && ret[32] != "Y") {
			message.PutFieldText(fieldname, "");
			fieldname = "sign" + i
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
		} else{
			break;
		}	
	}

	var idx = 1;
	var hidx = 1;	  
	for(i=1;i < OrderJobtitle.length;i ++) {
		
		if(OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1  || OrderType[i] == strAprType16 || OrderType[i] == strAprType3 || OrderType[i] == strAprType4 || OrderType[i] ==strAprType13)
		{
			fieldname = "jikwe" + idx;
			if (message.FieldExist(fieldname)) {
				var jikweName = trim(message.GetFieldText(fieldname));					
				if(jikweName.substring(0,1) != strLang128)
					message.PutFieldText(fieldname, OrderJobtitle[i]);
					
				if(OrderSuggester[i] == "Y")
					message.PutFieldText(fieldname, strLang75 + message.GetFieldText(fieldname));
					
				if(OrderReporter[i] == "Y")
					message.PutFieldText(fieldname, strLang76 + message.GetFieldText(fieldname));
			}
			idx = idx + 1;
	  	}
		else if(OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
			fieldname = "habyui" + hidx;
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, OrderDept[i]);
		
			fieldname = "habyuipositon" + hidx;
			if (message.FieldExist(fieldname)) {
				var jikweName = trim(message.GetFieldText(fieldname));					
				if(jikweName.substring(0,1) != strLang128)
					message.PutFieldText(fieldname, OrderJobtitle[i]);
					
				if(OrderSuggester[i] == "Y")
					message.PutFieldText(fieldname, strLang75 + message.GetFieldText(fieldname));
					
				if(OrderReporter[i] == "Y")
					message.PutFieldText(fieldname, strLang76 + message.GetFieldText(fieldname));
			}
			hidx = hidx + 1;
		}	
	}
  } catch(e){
	  alert("GetDraftAprLineInfo(ret) :: " + e);
  }	
}

function setRecevInfo(ret) {
	setDeptLinesXML(ret);
	var precipent = ""
	var precipents = ""
	var recipflag = true;
	var xmldom = createXmlDom();
	xmldom = loadXMLString(ret);
	
	/*if( xmldom.xml == "" ) return;
	if( xmldom.documentElement.childNodes.length == 0 ) return;*/
	if (getXmlString(xmldom) == "" || xmldom.getElementsByTagName("ROW").length == 0) return; 
	
	btnReceivLineEnable = true;
	
	var rows = xmldom.documentElement.childNodes
	if (message.FieldExist("hrecipients"))
		message.PutFieldText("hrecipients", "");
	
	if (message.FieldExist("recipient"))
		message.PutFieldText("recipient", "");
	
	if (message.FieldExist("recipients"))
		message.PutFieldText("recipients", "");
	
    for (var i = rows.length - 1; i >= 0; i--) {
		var row = rows[i];
		var dataNodes = GetChildNodes(row);
		
        if (recipflag) {
            if (getNodeText(dataNodes[3]) == "Y") {
				if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
					precipent = strLang92;
					precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
				} else {
					precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
					precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
				}
					recipflag = false;	
				}
            else {
                if (isExtDoc == "Y") {
					if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
						precipent = strLang92;
						precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);				
					} else {
						precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
						precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);				
					}
						recipflag = false;	
				} else {
					if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
						precipent = strLang92;
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
			precipent = strLang92;
			
			if(getNodeText(dataNodes[3]) == "Y")
				precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
            else {
				if(isExtDoc == "Y")
					precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]); 
				else
					precipents = precipents + ", " + getNodeText(dataNodes[0]);
			}
		}		
	}
	
    if (message.FieldExist("recipient")) {
        if (precipent == strLang92) {
        	message.PutFieldText("recipient", precipent);

            if (!!SummaryOuterReceiverList) {
                if (message.FieldExist("recipients")) {
                	message.PutFieldText("recipients", SummaryOuterReceiverList);
                    if (message.FieldExist("hrecipients"))
                    	message.PutFieldText("hrecipients", strLang129);
                }
            } else {
                if (message.FieldExist("recipients")) {
                	message.PutFieldText("recipients", precipents);
					if (message.FieldExist("hrecipients"))
						message.PutFieldText("hrecipients", strLang129);
                }
			}
		} else {
			message.PutFieldText("recipient", precipent);
            if (precipents == "") {
				if (message.FieldExist("hrecipients"))
					message.PutFieldText("hrecipients", "");
			
				if (message.FieldExist("recipients"))
					message.PutFieldText("recipients", "");
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
		if(pDraftFlag == "SUSIN" || pDocState == "011" ) susunSN = pSusinSN;
			
		for(i = 1; i <= SignCount ; i++) {
			fieldname = susunSN + "sign" + i;
			if (message.FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
					  		
			fieldname = susunSN + "seumyung" + i;
			if (message.FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				message.PutFieldText(fieldname, "");
					  		
			fieldname = susunSN + "seumyungdate" + i;
			if (message.FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				message.PutFieldText(fieldname, "");
				    
			fieldname = susunSN + "jikwe" + i;
			if (message.FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				message.PutFieldText(fieldname, "");
		}

		for(j = 1 ; j <= hapyuiCount ; j++) {
			fieldname = susunSN + "habyui" + j;
			if (message.FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				message.PutFieldText(fieldname, "");
			    
			fieldname = susunSN + "habyuipositon" + j;
			if (message.FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				message.PutFieldText(fieldname, "");
			
	  		fieldname =  susunSN + "habyuidate" + j;
			if (message.FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				message.PutFieldText(fieldname, "");
	      
			fieldname = susunSN + "habyuisign" + j;
			if (message.FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				message.PutFieldText(fieldname, " ");
		}
	    
		for(i=1;i<20;i++) {
			fieldname = "habyuiopinion" + i;
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, "");
		}
		
		
		fieldname = "sealsign";
		if (message.FieldExist(fieldname)) {
			message.PutFieldText(fieldname, "");
			message.SetFieldBackImage(fieldname, "");		// 닷넷은 SetFieldBackImage 미사용
		}
		
		
		fieldname = "opinions";
		if (message.FieldExist(fieldname)) {
			message.PutFieldText(fieldname, "");
		}
	}
	catch(e) {
		alert("ClearDocCellInfo() :: " + e);
	}
}


function setClearSusinCellInfo() {
  try{
	var fieldname;			
	fieldname = "recipient";
	if (message.FieldExist(fieldname))
		message.PutFieldText(fieldname, "");
		
	fieldname = "recipients";
	if (message.FieldExist(fieldname))
		message.PutFieldText(fieldname, "");
  }
  catch(e){
	alert("setClearSusinCellInfo() :: " + e);
  }
}


function ApplyDocCellInfo() {
  try {
	var i;
	var j;
	var k;
	var fieldname;
	var fieldvalue;
		
	for(j = 1 ; j <= hapyuiCount ; j++) {
		fieldname = "habyuidate" + j;
		if (message.FieldExist(fieldname)) {
			fieldvalue = message.GetFieldText(fieldname);
			fieldvalue = trim(fieldvalue);
		    
		  	if(fieldvalue == "") {
		  		fieldname = "habyui" + j;
				if (message.FieldExist(fieldname))
					message.PutFieldText(fieldname, " ");
			}
		} 
	}
  } catch(e) {
	alert("ApplyDocCellInfo() :: " + e);
  }	
}


function putJunkyulSign(signID) {
	if (message.FieldExist(signID))
		message.PutFieldText(signID, strLang6);
}


function SendDraftMappingSign(ret) {
  try {
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt = 0;
	var sn = 1;
	
	var OpinionText = "";
	var PositionText = "";
	
	// 기안자가 최종결재자인 경우, 서명일자를 서명칸에 표출할지 여부를 처리
	if (LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16) {
		OpinionText = getSignDate() + "\15";
	}
	
	if (approvalFlag == "S") {
        if (LastSignSN == 1 || DraftLastFlag) {
            if (DraftLastFlag) {
                putJunkyulSign("sign" + sn);
            }
            
            for (i = 1; i <= 20; i++) {
                if (pDraftFlag == "SUSIN") {
                	signID = pSusinSN + "sign" + i;
                }
                else {
                	signID = "sign" + i;
                }

                if (message.FieldExist(signID)) {
                    LastSignNo = i;
                }
            }
            sn = LastSignNo;
        }
    }
    
	psigncell = "sign" + sn;
	pseumyungcell = "jikwe" + sn;
	pseumyungdatecell = "seumyungdate" + sn;
	
	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 
	var strimg;
	var SingFlag = true;
	var DekyulFlag = false;
	// 2021-03-25 박기범 - 서명 이미지 삽입시 포트번호 추가.
  	var portNum = document.location.port == "" ? "" : ":" + document.location.port;

	if (message.FieldExist(pseumyungcell)) {
		message.PutFieldText(pseumyungcell, message.GetFieldText(pseumyungcell) + PositionText);
	}
	
	if (message.FieldExist(pseumyungdatecell)) {
		message.PutFieldText(pseumyungdatecell, s);
        rtnSignInfo.push(pseumyungdatecell);
        
        /* 2023-10-05 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
    	signInfo[signCnt] = pseumyungdatecell;
    	SignName[signCnt] = pseumyungdatecell;
    	SignType[signCnt] = "TEXT";
    	SignContent[signCnt] = s;
    	signCnt = signCnt + 1;
    }
    
	if (CurAprType == strAprType16) {
		if (message.FieldExist(psigncell)) {
			// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
			if (message.FieldExist(pseumyungdatecell)) {
			    OpinionText = "\15";
			}
			
			if (ret != "NAME") {
				message.PutFieldText(psigncell, "");
				message.PrependFieldText(psigncell, strLang7 + OpinionText);
				
				//HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);
				message.InsertPicture(psigncell, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(ret), SendDraftMappingSign_after);
				
			  	signInfo[signCnt] = psigncell;
				SignType[signCnt] = "IMAGE";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = ret + "::" + strLang7 + OpinionText;
                rtnSignInfo.push(psigncell);
							  	
			  	//SetDocumentElement(HwpCtrl, psigncell, ret);
			  	signCnt = signCnt + 1
			  	SingFlag = true;
			} else {
				message.PutFieldText(psigncell, arr_userinfo[2]);
				message.PrependFieldText(psigncell, strLang7 + OpinionText);
				
		  		signInfo[signCnt] = psigncell;
				SignType[signCnt] = "TEXT";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = strLang7 + OpinionText + arr_userinfo[2];
                rtnSignInfo.push(psigncell);
		  		
		  		signCnt = signCnt + 1
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
		if (message.FieldExist(psigncell)) {
			message.PutFieldText(psigncell, strLang6);	
			
			signInfo[signCnt] = psigncell;
			
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = psigncell;
			SignContent[signCnt] = strLang6;
            rtnSignInfo.push(psigncell);
			
			signCnt = signCnt + 1
			SingFlag = false; 
		}
	} else if (DekyulFlag) {
	
	} else {	
		if (message.FieldExist(psigncell)) {
			// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
			if (message.FieldExist(pseumyungdatecell)) {
			    OpinionText = "\15";
			}
			
			if (ret != "NAME") {
				message.PutFieldText(psigncell, "");	
				//HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);
				
				if (CurAprType == strAprType4) {
                    OpinionText = strLangAprType4 + OpinionText;
				}
				
				// OpinionText에 대결/전결/서명일자 표기 없이 개행문자만 존재하는 경우, 공백으로 치환
				if (OpinionText == "\15") {
					OpinionText = "";
				}
				
                message.PrependFieldText(psigncell, OpinionText);
                message.InsertPicture(psigncell, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(ret), SendDraftMappingSign_after);
                
			  	signInfo[signCnt] = psigncell;
				SignType[signCnt] = "IMAGE";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = ret + "::" + OpinionText;
                rtnSignInfo.push(psigncell);
				
			  	//SetDocumentElement(HwpCtrl, psigncell, ret);
			  	signCnt = signCnt + 1
			  	SingFlag = true;
			}
			else {
			    if (CurAprType == strAprType4) {
			    	OpinionText = strLangAprType4 + OpinionText;
			    }
			    
			    // OpinionText에 대결/전결/서명일자 표기 없이 개행문자만 존재하는 경우, 공백으로 치환
				if (OpinionText == "\15") {
					OpinionText = "";
				}
			    
			    message.PutFieldText(psigncell, arr_userinfo[2]);	
			    message.PrependFieldText(psigncell, OpinionText);
			  	
			  	signInfo[signCnt] = psigncell;
		        SignType[signCnt] = "TEXT";
		        SignName[signCnt] = psigncell;
		        SignContent[signCnt] = OpinionText + arr_userinfo[2];
                rtnSignInfo.push(psigncell);
			        
			  	signCnt = signCnt + 1
			  	SingFlag = false; 
			}
		}
	}	
	if(ret == "NAME") {
		GetHTML(saveDraftInfo);
	}
  } catch(e) {
    alert("SendDraftMappingSign(ret) :: " + e);
  }
}

function SendDraftMappingSign_after() {
	GetHTML(saveDraftInfo);
}


function UndoSignInfo(signInfo) {
  try{
	var cnt 
	if(signInfo) {
		for(cnt=0; cnt < signInfo.length; cnt++) {
			if (message.FieldExist(signInfo[cnt]))
				message.PutFieldText(signInfo[cnt], "");
		}
	}
  } catch(e) {
	alert("UndoSignInfo(signInfo) :: " + e);
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
			code1 : "A01",
			code2 : pDocType,
			flag  : "CODE"
		},
		success: function(xml){
			result = xml;
		}        			
	});

    return SelectSingleNodeValue(loadXMLString(result), "RESULT");
}

/*function chk_Passwd() {
	var parameter = pUserID;
	var url = "/ezApprovalG/ezchkPasswd.do";
	var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret = window.showModalDialog(url,parameter,feature);
	
	return ret;
}*/

function setDrafterAddress() {
	SetDocumentElement("drafter", arr_userinfo[2]);
	SetDocumentElement("address", arr_userinfo[8]);
	SetDocumentElement("drafterdept",arr_userinfo[4]);
	SetDocumentElement("lastKyulName", lastKyulName);
	SetDocumentElement("lastKyuljikwee", lastKyuljiwee);
}

var getformcont_cross_dialogArguments = new Array();
function openFormUI() {
	try {
		var parameter = new Array();
		parameter[0] = arr_userinfo[4];
		parameter[1] = "000";				
		
		getformcont_cross_dialogArguments[0] = parameter;
		getformcont_cross_dialogArguments[1] = openFormUI_complete;

		var url = "/ezApprovalG/getFormCont.do?fileType=hwp";
		//var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no"
		//var ret = window.showModalDialog(url,parameter,feature);
		var ret = window.open(url, '', 'height=570,width=713,scrollbars=no' + GetOpenPosition(713, 570));
	} catch(e) {
		alert("openFormUI() :: " + e);
	}
}

function openFormUI_complete(ret) {
	pFormHref = ret[0];
	pDocType  = ret[1];
	
	if(pFormHref == "PC") {
		pReadPC = true;
		
		//var rtnval = HwpCtrl.LoadFile("", false);
		
		lstAttachLink.innerHTML = "";
		AppendFileAttach = "";
		AppenAprDocAttachList = "";
		window_onbeforeunload();
		pFormID = ""
		pDocID = ""
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
			
		//FieldsAvailable(rtnval);
		FieldsAvailable(false);
	} else {
  		if(pFormHref != "cancel") {
  			pReadPC = false;
	  		
  			pFormID = ""
  			pDocID = ""
  			SetBtnStateTrue();
	  		
  			lstAttachLink.innerHTML = "";
			AppendFileAttach = "";
			AppenAprDocAttachList = "";
  			window_onbeforeunload();
  			pFormID = ""
  			pDocID = ""
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

			//2021-04-19 남학선 의견입력 후 양식선택시 양식 데이터는 초기화 되지만 의견 flag값이 그대로'Y'로 남아있는 문제 수정
			pHasOpinionYN = "N";

			var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pFormHref);
            message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null); 
  		}
	}
}

var form_check_ui_cross_dialogArguments = new Array();
function Form_check() {
  try {
      form_check_ui_cross_dialogArguments[0] = "";
      form_check_ui_cross_dialogArguments[1] = Form_check_Complete;
      
      DivPopUpShow(330, 205, "/ezApprovalG/formCheckUI.do");
  } catch(e) {
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
		setMenuBar("btnSetAprLine",false);
		setMenuBar("btnSetReceivLine",false);
		setMenuBar("btnSendDraft",false);
		setMenuBar("btnDocInfo",false);
		setMenuBar("btnFileAttach",false);
		setMenuBar("btnAprDocAttach",false);
		setMenuBar("btnOpinion",false);
		setMenuBar("btnSave", false);
		
//		if (pDraftFlag == "REDRAFT") {
//		    setMenuBar("btnSaveServer", false);
//		} else {
//		    setMenuBar("btnSaveServer", true);
//		}
	}catch(e){
		alert("SetBtnStateFalse()" + e.description);
	}
}


function SetBtnStateTrue()
{
	try{
		setMenuBar("btnSelForm",true);
		setMenuBar("btnSetAprLine",true);
		setMenuBar("btnSendDraft",true);
		setMenuBar("btnDocInfo",true);
		setMenuBar("btnFileAttach",true);
		setMenuBar("btnAprDocAttach",true);
		setMenuBar("btnOpinion",true);	
		btnClose.style.diplay = ""	
		//setMenuBar("btnSave",true);
		setMenuBar("btnPrint",true);
		
		if(pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
		{
			setMenuBar("btnSelForm",false);
		}
//		if (pDraftFlag == "REDRAFT") {
//		    setMenuBar("btnSaveServer", false);
//		}
//		else {
//		    setMenuBar("btnSaveServer", true);
//		}ddd

		//setFormAprOption();  //결재 세부옵션

	}catch(e){
		alert("SetBtnStateTrue()" + e.description);
	}
}

function SetAutoPropertyValue() {
//  try{
	var fieldname;
	var field;
	var pSusinNextSN;
	var objNodes;
	var CurrentDate;

	objNodes = xmluserInfo.documentElement.childNodes;
	  
	
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

	var Fields = message.GetFieldList(0, 1);
	
	for (i = 0 ; i < Fields.length ; i ++) {
		if(pDraftFlag == "DRAFT") {
			switch (Fields[i]) {
				case "bedocnumber" :				    
					setDocNumFormat("be");
					break;

				case "docnumber" :				    
					setDocNumFormat("");
					break;

				case "enforcedate" :		  
					message.PutFieldText(Fields[i], " ");
					break;

				case "opinions" :		  
					message.PutFieldText(Fields[i], " ");
					break;

				case "receiptdate" :		  
					message.PutFieldText(Fields[i],  "");
					break;
				
				case "recipient" :			  
					message.PutFieldText(Fields[i],  "");
					break;

				case "hrecipients" :			  
					message.PutFieldText(Fields[i],  "");
					break;

				case "recipients" :			  
					message.PutFieldText(Fields[i],  "");
					break;
				
				case "refer" :				    
					message.PutFieldText(Fields[i],  "");
					break;
				
				case "zipcode" :	
					//message.PutFieldText(Fields[i], getNodeText(GetElementsByTagName(objNodes, "POSTALCODE")[0]));
					break;

				case "address" :
					//message.PutFieldText(Fields[i], getNodeText(GetElementsByTagName(objNodes, "STREETADDRESS")[0]));
					break;												

				case "telephone" :		  	
					if( trim(getNodeText(objNodes.item(5))) != "" )
						message.PutFieldText(Fields[i], getNodeText(objNodes.item(5)));
					break;

				case "depttelephone" :		  	
					message.PutFieldText(Fields[i], getNodeText(objNodes.item(5)));
					break;																							
				case "fax" :			      	
					if( trim(getNodeText(objNodes.item(4))) != "" )
						message.PutFieldText(Fields[i], getNodeText(objNodes.item(4)));
					break;
				case "deptfax" :			      	
					message.PutFieldText(Fields[i], getNodeText(objNodes.item(4)));
					break;													
				case "department" :		  	
					message.PutFieldText(Fields[i], pDeptName);
					break;												
				case "parantdept" :       
					message.PutFieldText(Fields[i], getNodeText(objNodes.item(3)));
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
				case "email" :				 
					message.PutFieldText(Fields[i], arr_userinfo[8]);
					break;
				case "keepperiod" :			  
					
					break;												
				case "publication" :		  
					message.PutFieldText(Fields[i], "");
					break;												

				case "examname" :			    
					break;												
				
				case "examdate" :			    
				break;												
				
				case "headcampaign" :		  
					
					break;							
				
				case "deptname" :         
					message.PutFieldText(Fields[i], arr_userinfo[5]);
					break;
				
				case "seal" :             
					message.PutFieldText(Fields[i], getNodeText(objNodes.item(3)) + "대표이사");
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
				
				case "deptshortedname" :
					message.PutFieldText(Fields[i], DeptSymbol + ":");
					break;

				case "organ" :        
					if (SendName != "")
						message.PutFieldText(Fields[i], SendName);
					break;

				case "chief" :        
					if (SendName != "")
						message.PutFieldText(Fields[i], SendName + strLang93);
					break;
			}
		} else {
			switch (Fields[i]) {
				case pSusinSN + "receiptdate" :	 
					message.PutFieldText(Fields[i], CurrentDate);
					break;
			}
		}
	  	
		
		if(pDraftFlag == "SUSIN" ||  pDocState == "011") {
			var pSignSusin = pSusinSN + "sign";
			if (Fields[i].substr(0, 5) == pSignSusin)
			{
				SignCount = SignCount + 1;
			}
		} else {
			if (Fields[i].substr(0, 4) == "sign") {
				SignCount = SignCount + 1;
			}
		} 
	    
	    if (Fields[i].substr(0,10) == "habyuisign") {
	    	hapyuiCount = hapyuiCount + 1;
	    }

	    if (Fields[i].substr(0,10) == "gamsasign1") {
			gamsaCount =  gamsaCount + 1;
	    }
	    
	    if (Fields[i].substr(0, 7) == "gongram") {
	    	gongramCount = gongramCount + 1;
	    }
	  	
	    if(pDraftFlag == "SUSIN" || pSusinSN != "0") {
			var pSignInfoSusin = pSusinSN + "jikwe";
			if(Fields[i].substr(0,6) == pSignInfoSusin) {
				if(SignInfoFlag) {
					SignInfo = message.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				} else {
					SignInfo = message.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    }else {
			if(Fields[i].substr(0,5) == "jikwe") {
				if(SignInfoFlag) {
					SignInfo = message.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				} else {
					SignInfo = message.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
		}
	}
	
	pSuSinFlag = "N";

	if(pDraftFlag != "SUSIN" && pDocState != "011" ) {
		var RtnVal = message.FieldExist("recipient");
		if(RtnVal) {
			pSuSinFlag = "Y";
			setMenuBar("btnSetReceivLine", true);	
		} else {
			pSuSinFlag = "N";
			setMenuBar("btnSetReceivLine", false);	
		}
	}
	
	
	if(pSusinSN)
		pSusinNextSN = parseInt(pSusinSN) + 1;
	else
		pSusinNextSN = 1;

	fieldname = pSusinNextSN + "sign1";
	if(message.FieldExist(fieldname)) {
		pSuSinFlag = "Y";
		setMenuBar("btnSetReceivLine", true);
	} else {
		if(pSuSinFlag == "N") {	
			pSuSinFlag = "N";
			setMenuBar("btnSetReceivLine", false);
		}
	}
	
	pChamJoFlag = "Y";
//  }catch(e){	
//	alert("SetAutoPropertyValue()" + e.description);
//  }
}

function SetAutoPropFinal()
{
  try{
    var CurrentDate;
    CurrentDate = getGyulJeDate();
    
	var Fields = message.GetFieldList(0, 1);
  
	for (i = 0; i < Fields.length; i ++) {
		if(pDraftFlag == "DRAFT") {
			switch (Fields[i]) {
	  			case "sentdate" :        
	  				message.PutFieldText(Fields[i], CurrentDate);
	  		  		break;
 			}
	  	}
	}  
  } catch(e){	
	  alert("SetAutoPropFinal()::" + e);
  }
}

function openOpinionUI(pOpinionFlag)
{
  try{
    var parameter = new Array();
    parameter[0]	= pDocID;
    parameter[1]	= pOpinionFlag;
    parameter[2]	= KuyjeType;
    parameter[3]	= pDraftFlag;
    parameter[98]	= orgCompanyID;
    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
    parameter[99] = "hwp";
    
    var url = "/ezApprovalG/aprOpinion.do";
	var feature = "status:no;dialogWidth:530px;dialogHeight:495px;edge:sunken;scroll:no"
	var ret = window.showModalDialog(url,parameter,feature);
	
	if (ret != "cancel" && ret != undefined) {
	    var NodeList;
	    var objXML = new ActiveXObject("Microsoft.XMLDOM");
	    
	    objXML.loadXML(ret);
	    NodeList = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	
	    if (NodeList.length != 0) {
			pHasOpinionYN = "Y";
	    } else {
			pHasOpinionYN = "N";
			ret = "cancel";
	    }
	    
	    makeOpinionList(objXML);
    }
	
    return ret;
  }catch(e){
    alert("openOpinionUI(pOpinionFlag)" + e.description);
  }
}

var apropinion_cross_dialogArguments = new Array();
function openOpinionUI_New(pOpinionType) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = pDraftFlag;	//DRAFTFLAG
		parameter[3] = "";			//DOCSTATE 기안은 공백 고정
		parameter[4] = orgCompanyID;//ORGCOMPANYID
		parameter[99] = ext;		//EXT
		
		var url = "/ezApprovalG/aprOpinionNew.do";
		//var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
		//var ret = window.showModalDialog(url,parameter,feature);
		
		apropinion_cross_dialogArguments[0] = parameter;
		if (typeof(CompleteFunction) != "undefined") {
			apropinion_cross_dialogArguments[1] = CompleteFunction; 
		} else {
			apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete;
		}
		DivPopUpShow(530, 520, url);
	} catch (e) {
		alert("openOpinionUI_New ::: " + e.description);
	}
}

function openOpinionUI_New_Complete(ret) {
	DivPopUpHidden();
	if(ret == "Clear"){
		pHasOpinionYN = "N";
		ret = "cancel";
	} else if (ret == "cancel"){

	} else {
		var objXML = loadXMLString(ret);

		var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
		if (NodeList.length != 0) {
			pHasOpinionYN = "Y";
		} else {
			pHasOpinionYN = "N";
			ret = "cancel";
		}
		makeOpinionList(objXML);
	}
    return ret;
}

function makeOpinionList(OpinionXML) {
	if (!message.FieldExist("opinions"))
		return;

	var firstFlag = true;
	var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
	if (NodeList.length > 0) {
		var strOpinion = " ";
		for (i=NodeList.length - 1; i>=0; i--) {
			var childNode = GetChildNodes(NodeList[i]);
		    if (getNodeText(childNode[9]) == "001") {
				if (firstFlag) {
					strOpinion = "[" + strLang27 + "";
					firstFlag = false;
				}
				
				
				if (getNodeText(childNode[2]) != "")
				    strOpinion = strOpinion + getNodeText(childNode[2]) + "\11";  
				else
					strOpinion = strOpinion + "   \11";  
					
				strOpinion = strOpinion + getNodeText(childNode[1]) + "\11";  
				strOpinion = strOpinion + getNodeText(childNode[6]) + "\15";  
			}
				
		}		
		message.PutFieldText("opinions", strOpinion);
	}
	else {
		message.PutFieldText("opinions", " ");
	}
}


function openFileAttachUI() {
  try {
	/*var parameter = pDocID;
	var url = "/ezApprovalG/aprAttach.do?formID=" + pFormID + "&docID=" + pDocID + "&draftFlag=" + pDraftFlag + "&orgCompanyID=" + orgCompanyID + "&ext=" + "hwp";
	var feature	= "status:no;dialogWidth:760px;dialogHeight:415px;edge:sunken;scroll:no"; 
	var ret = window.showModalDialog(url, parameter, feature);
	
	if (ret != "cancel") {
		setAttachInfo(pDocID, "APR", lstAttachLink);
	}
	
	return ret;*/
	  
	  var url = "/ezApprovalG/aprAttach.do?formID=" + pFormID + "&docID=" + pDocID + "&draftFlag=" + pDraftFlag + "&orgCompanyID=" + orgCompanyID + "&ext=" + "hwp";
	  DivPopUpShow(800, 610, url);
  } catch(e) {
	  alert("openFileAttachUI() :: " + e);
  }
}

var aprcabinetattach_cross_dialogArguments = new Array();
function openAaprDocAttachUI() {
  try{
	  var parameter = pDocID;
	  var url = "/ezApprovalG/aprCabinetAttach.do?draftFlag=" + pDraftFlag;
      if (approvalFlag == "S") {
        url = "/ezApprovalG/aprDocAttach.do?orgCompanyID=" + orgCompanyID;
      }
	  /* var feature	= "status:no;dialogWidth:1050px;dialogHeight:520px;edge:sunken;scroll:no;help:no"; 
	  var ret = window.showModalDialog(url,parameter,feature); */
	
	  aprcabinetattach_cross_dialogArguments[0] = parameter;
      aprcabinetattach_cross_dialogArguments[1] = openAaprDocAttachUI_complete;
      
	  DivPopUpShow(1050, 560, url);
  } catch(e) {
	  alert("openAaprDocAttachUI() :: " + e);
  }
}

function openAaprDocAttachUI_complete(ret){
	DivPopUpHidden();
	if(ret != "cancel") {
		setAttachInfo(pDocID, "APR", lstAttachLink);	
	}
}

function SaveDraftDocInfo() {
	var rtnVal;

	if (SaveFile() != "TRUE")
		return "FALSE";
		
    SignSave();
	rtnVal = SaveDraftDocInfo_ilban("002");
	
	if (rtnVal.toUpperCase() != "TRUE")	{
		SaveOrgFile();
	}
	
	return rtnVal;
}

function SaveDraftDocInfo_ilban(pState)
{
  try{
	var objRoot;
	var objNode;
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();

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

	createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", pState);
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
	createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
	createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);

	var startdate;
	if (pState == "000")
	    startdate = "DRAFTSAVE";
	else
	    startdate = "DRAFT";
	createNodeAndInsertText(xmlpara, objNode, "STARTDATE", startdate);
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
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);
	createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");

	createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
	createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElement("sepattachlvxml", true);
	if (!g_SepAttachLVXml)
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
	else
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));

	createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);

	createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	
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
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(rows[i], "CABINETID"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", SelectSingleNodeValue(rows[i], "SEPTITLE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(rows[i], "SEPNUMOFPAGE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", SelectSingleNodeValue(rows[i], "SEPREGTYPE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", SelectSingleNodeValue(rows[i], "SEPSUMMARY"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", SelectSingleNodeValue(rows[i], "SEPRECORDTYPE"));
            }
            
            createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SEPERATEATTACH", getXmlString(rtnXml));
		}
	}
	
	xmlhttp.open("POST","/ezApprovalG/doDraftHWP.do",false);
	xmlhttp.send(xmlpara);
	
	if(pState != "000")		
		SetBtnStateFalse();
	
	if (xmlhttp.status == 200) {
		var dataNodes = GetChildNodes(xmlhttp.responseXML);
		
        return getNodeText(dataNodes[0]);
	} else {
		return "FALSE";
	}
  } catch(e){
	  alert("SaveDraftDocInfo_ilban(pState)::" + e);
  }
}

function setDocNumFormat(pPrefix)
{
	var Arr_Header = new Array()
	var Header, Tail
	var i
	var d = new Date();
		
	var numHeader = ""
		
	if(approvalFlag == "G" && pDraftFlag == "REDRAFT") return;
		
	if(!message.FieldExist(pPrefix + "docnumber"))		
		return 

	//var fieldValue = getNodeText(DocumentInfo.getElementsByTagName("SUBJECT").item(0));
	var fieldValue = message.GetFieldText(pPrefix + "docnumber");
	Arr_Header = fieldValue.split("@")
	    
	for(i=1; i<Arr_Header.length; i++) {
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

			//2021-01-28 문서번호의 년도가 제대로 출력되지 않는 부분 해결
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
	if(numHeader.indexOf(strLang107) > 0) {
		// SetDocumentElement("", message.GetFieldText("docnumber"));
		//HwpCtrl.SetDocumentInfo("NULL", "NULL", numHeader);
	}
	
	/*if (HwpCtrl.CheckFieldExist("receiptnumber")) {
		if (HwpCtrl.GetFieldText("receiptnumber") != "") {
			SetDocumentElement(HwpCtrl, "receiptnumber", HwpCtrl.GetFieldText("receiptnumber"));
		}
		HwpCtrl.SetFieldText("receiptnumber", "");

		if (GetDocumentElement(HwpCtrl, "receiptnumber") == "")
			SetDocumentElement(HwpCtrl, "receiptnumber", fieldValue);
	}*/
	
    if (message.FieldExist("receiptnumber")) {
        if (message.GetFieldText("receiptnumber") != "") {
            SetDocumentElement("receiptnumber", message.GetFieldText("receiptnumber"));
        }

        message.PutFieldText("receiptnumber", "");
    }
}

//구현해야하는부분
function SaveFile() {
	var result = "";

	var data = {
		docID : pDocID,
		formId : pFormID,
		html  : pSaveHtml
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

function SaveOrgFile() {
	var result = "";

	// 2021.01.07 강승구 : 오류발생 후 파일이 사라지는 오류 수정
	if (!pOrgHtml)
        return;

	var data = {
		docID : pDocID,
		formId : pFormID,
		html  : pOrgHtml
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

function openSignUI() {
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
      alert("openSignUI()" + e.description);
    }
}

function putSignXML(SignXML)
{
  var retVal = false;
  try {
	var NodeList;
	NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
	if (NodeList.length > 0) 
	{
		for (i=0; i<NodeList.length; i++)
		{
		    var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
		    var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
		    var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));
			// 2021-03-25 박기범 - 서명 이미지 삽입시 포트번호 추가.
			var portNum = document.location.port == "" ? "" : ":" + document.location.port;
			
			if (message.FieldExist(SignName)) {			
			    retVal = true;
				if (SignType == "TEXT")
				{
					//HwpCtrl.SetFieldText(SignName, SignCont);
					message.PutFieldText(SignName, ReplaceText(SignCont, "<br/>", "\15"));
				}
				else if (SignType == "HTML")
				{
					//HwpCtrl.AppendFieldText(SignName, SignCont, true, true, true);
					message.AppendFieldText(SignName, SignCont);
				}
				else if (SignType == "PROXY")
				{
					/*HwpCtrl.SetFieldText(SignName, " ");
					HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(SignCont), 3, 0, 0, true, 2);
					HwpCtrl.AppendFieldText(SignName, strLang17, true);*/
					
					message.PutFieldText(SignName, " ");                        
					message.AppendFieldText(SignName, strLang17);
					message.InsertPicture(SignName, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(SignCont), null);
				}
				else if (SignType == "IMAGE")  
				{
				    /*var img = SignCont.split("::"); 
					HwpCtrl.SetFieldText(SignName, "");
					if(img.length >= 1)
					    HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(img[0]), 3, 0, 0, true, 2);
				    
				    if(img.length >= 2)
				        HwpCtrl.AppendFieldText(SignName, img[1], true);*/
					
					var img = SignCont.split("::");                        
                    message.PutFieldText(SignName, "");
                    if(img.length >= 1) {
                    	message.InsertPicture(SignName, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(img[0]));
                    }
                    
                    if(img.length >= 2) {
                        message.AppendFieldText(SignName, img[1]);
                    }

				}			
			}
		}
	}
  } catch(e) {
	alert("putSignXML : " + e.description);
	return false;
  }
  return retVal;
}


function SaveTMPFile(html) {
    var result = "";

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
		html  : html
	}
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveTmpFileHWP.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});

    return result;
}

function SaveTMPDocInfo(AutoSave, Saveflag, pState, phtml) {
    try {
        var objRoot;
        var objNode;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        
        var pAutoTmpDocTitle = trim(message.GetFieldText("doctitle"));
        createNodeInsert(xmlpara, objNode, "PARAMETER");

        if(Saveflag) {
            if(AutoSave == "autosave" && createAutoDoc == "Y"){
                createNodeAndInsertText(xmlpara, objNode, "DOCID", autopDocID);
            }else {
                createNodeAndInsertText(xmlpara, objNode, "DOCID", newpDocID);
            }
        }else {
            if(AutoSave == "autosave" && createAutoDoc == "Y"){
                createNodeAndInsertText(xmlpara, objNode, "DOCID", autopDocID);
            }else {
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


        if (message.FieldExist("doctitle")) {
            if(pAutoTmpDocTitle != "") {
                createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", message.GetFieldText("doctitle"));
            }else{
                createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", strLang1133);
            }
        }else {
            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", "");
        }
        var field
        if (message.FieldExist("docnumber"))
            field = message.GetFieldText("docnumber");
        else if (message.FieldExist("be_docnumber"))
            field = message.GetFieldText("be_docnumber");
        else if (message.FieldExist("deptshortedname"))
            field = message.GetFieldText("deptshortedname");
        else
            field = "";

        createNodeAndInsertText(xmlpara, objNode, "DOCNO", field);
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
        g_SepAttachLVXml = GetDocumentElement("sepattachlvxml", true);
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
        
        if(Saveflag) {
        	createNodeAndInsertText(xmlpara, objNode, "saveFlag", Saveflag);
        	createNodeAndInsertText(xmlpara, objNode, "oldDocID", pDocID);
        }
        
        if (AutoSave == "autosave" && createAutoDoc == "Y"){
            createNodeAndInsertText(xmlpara, objNode, "autoSaveFlag", "Y");
            createNodeAndInsertText(xmlpara, objNode, "autopDocSN", autopDocSN);
        }

        if (AutoSave == "autosave"){
            createNodeAndInsertText(xmlpara, objNode, "FautoSaveFlag", AutoSave);
        }
        xmlhttp.open("POST", "/ezApprovalG/doDraftHWP.do", false);
        xmlhttp.send(xmlpara);

        if (xmlhttp.status == 200) {
    		var dataNodes = GetChildNodes(xmlhttp.responseXML);
    		
            return getNodeText(dataNodes[0]);
    	} else {
    		return "FALSE";
    	}
    } catch (e) {
        OpenAlertUI("SaveTMPDocInfo()" + e.description);
    }
}

/*function OpenInformationUI(pInformationContent) {
	var parameter = pInformationContent;
	var url = "/ezApprovalG/ezAprOpinion.do";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
	return RtnVal;
}*/

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
//		New_DrawAutoLine(lineXml, pDraftFlag);
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
//    var autoAprLineField = $("#message").contents().find("td[id^='autoLine']");
    var signFields = message.GetFieldList(0);

    LastSignNo = signFields.forEach(
        function(name){
            LastSignNo += name.indexOf(SusinSN + "sign") == 0 ? 1 : 0;
        });
    // 테넌트 컨피그와 실제 양식 상의 가변결재선 필드 모두 확인
//    if (useDynamicAprLine == "1" && autoAprLineField.length > 0) {
//    	isAutoAprLineExit = true;
//    }

//	var fields = message.GetFieldsList();
//	var field;

	// 가변결재선의 초기화
//	if (isAutoAprLineExit == true) {
//		for (var p = startSignIdx; p <= signMax; p++) {
//			field = message.GetListItem(fields, SusinSN + "jikwe" + p);
//			if (field) {
//				setNodeText(field , " ");
//				if (new RegExp(/Firefox/).test(navigator.userAgent)) {
//					field.innerHTML = "<br type='_moz'>";
//				}
//			}
//
//			field = message.GetListItem(fields, SusinSN + "sign" + p);
//			if (field) {
//				setNodeText(field , " ");
//				if (new RegExp(/Firefox/).test(navigator.userAgent)) {
//					field.innerHTML = "<br type='_moz'>";
//				}
//			}
//
//			field = message.GetListItem(fields, SusinSN + "seumyung" + p);
//			if (field) {
//				setNodeText(field , " ");
//				if (new RegExp(/Firefox/).test(navigator.userAgent)) {
//					field.innerHTML = "<br type='_moz'>";
//				}
//			}
//
//			field = message.GetListItem(fields, SusinSN + "seumyungdate" + p);
//			if (field) {
//				setNodeText(field , " ");
//				if (new RegExp(/Firefox/).test(navigator.userAgent)) {
//					field.innerHTML = "<br type='_moz'>";
//				}
//			}
//		}
//	}
//	else { // 일반적인 결재선의 초기화 (내부결재, 수신결재)
	    if (LastSignNo > 0) {

	    	var newAddSignCnt = signMax - startSignIdx; // 이 값이 0 이하라면, 기결재된 결재선 외에 새로 추가된 결재선은 없음
	    	var signResetCnt = LastSignNo - newAddSignCnt; // 양식 상의 전체 결재선 필드에서 새로 추가된 결재선 카운트를 뺀 횟수만큼 초기화를 진행

	    	if (newAddSignCnt >= 0 && signResetCnt > 0) {  // 새로 추가된 결재선이 존재하거나, 양식 상에서 초기화가 필요한 결재선 필드가 존재함
	    		// startSignIdx 지점부터 양식 상의 마지막 결재서명필드(최종결재자 영역)까지 초기화를 진행
				for (var r = startSignIdx; r <= signResetCnt; r++) {
					if (message.FieldExist(SusinSN + "jikwe" + r)) {
						message.PutFieldText(SusinSN + "jikwe" + r , "");
					}

					if (message.FieldExist(SusinSN + "sign" + r)) {
						message.PutFieldText(SusinSN + "sign" + r , "");
					}

					if (message.FieldExist(SusinSN + "seumyung" + r)) {
						message.PutFieldText(SusinSN + "seumyung" + r , "");
					}

					if (message.FieldExist(SusinSN + "seumyungdate" + r)) {
						message.PutFieldText(SusinSN + "seumyungdate" + r , "");
					}
				}
	    	}
	    }

//	}

	for (var p = startHabyIdx; p <= habyMax; p++) {
        if (message.FieldExist(SusinSN + "habyuipositon" + p)) {
            message.PutFieldText(SusinSN + "habyuipositon" + p , "");
        }

        if (message.FieldExist(SusinSN + "habyuisign" + p)) {
            message.PutFieldText(SusinSN + "habyuisign" + p , "");
        }

        if (message.FieldExist(SusinSN + "habyuija" + p)) {
            message.PutFieldText(SusinSN + "habyuija" + p , "");
        }

        if (message.FieldExist(SusinSN + "habyuidate" + p)) {
            message.PutFieldText(SusinSN + "habyuidate" + p , "");
        }
	}

	var sIdx = startSignIdx;
	var hIdx = startHabyIdx;
	for (var p = 0; p < reOrderSignName.length; p++) {

		// 가변결재선이 아닌 경우, 최종결재자는 가장 마지막 서명칸에 맵핑 (기안자=최종결재자인 경우도 동일하게 처리)
		if (p == reOrderSignName.length - 1 && isAutoAprLineExit == false) {
			sIdx = LastSignNo;
		}

        if (message.FieldExist(SusinSN + "jikwe" + sIdx)) {
            message.PutFieldText(SusinSN + "jikwe" + sIdx , reOrderSignTitle[p]);
        }

		/* 2020-07-27 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
//		field = message.GetListItem(fields, SusinSN + "sign" + sIdx);
		if (message.FieldExist(SusinSN + "sign" + sIdx)) {
			// 서명필드만 존재
			if (!message.FieldExist(SusinSN + "seumyung" + sIdx)) {
				message.PutFieldText(SusinSN + "sign" + sIdx , reOrderSignName[p]);
			}
			// 서명필드 + 결재자명 필드가 함께 존재
			else {
			    message.PutFieldText(SusinSN + "sign" + sIdx , "[NOSLASH]");
//				field.innerHTML = "[NOSLASH]";
			}
	     	// 그 외의 경우, 아무런 값이 부여되지 않으므로 슬래시 이미지를 표출
		}

        if (message.FieldExist(SusinSN + "seumyung" + sIdx)) {
            message.PutFieldText(SusinSN + "seumyung" + sIdx , reOrderSignName[p]);
        }
		sIdx++;
	}

    if (isSplit == "Y") { // 슬래시 이미지 삽입
        setSignSlash("sign", SusinSN);
    }

	for (var p = 0; p < reOrderHabyName.length; p++) {
        if (message.FieldExist(SusinSN + "seumyung" + hIdx)) {
            message.PutFieldText(SusinSN + "seumyung" + hIdx , reOrderHabyTitle[p]);
        }
        if (message.FieldExist(SusinSN + "habyuija" + hIdx)) {
            message.PutFieldText(SusinSN + "habyuija" + hIdx , reOrderHabyName[p]);
        }
		hIdx++;
	}

}
