// 일괄기안을 위하여 모든 안에서 공통으로 사용되는 변수 부모창으로 이동
// var lastKyulName, lastKyuljiwee, LastSignSN;
// var DraftLastFlag = false;

function GetDraftAprLineInfo(ret) {
  try {
	parent.DraftLastFlag = false;
	
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
	
	if (xmlReDraft == "C") {
		ApplyDocCellInfo();
	} else if (xmlReDraft == "R") {
		ClearDocCellInfo(ret);
	}
    
	xmldom = loadXMLString(xmlKuljea);
	  
	objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
	count = objNodes.length;
	
	for(i=1;i<60;i++) {
	   	name = "habyuisign" + i;
		if (FieldExist(name) && ret[32] != "Y") {
	  		name = "habyui" + i;
	  		if (FieldExist(name))
	  			PutFieldText(name, "");
	  		
	  		name = "habyuisign" + i;
	  		if (FieldExist(name))
	  			PutFieldText(name, "");
	  		
	  		name = "habyuipositon" + i;
	  		if (FieldExist(name))
	  			PutFieldText(name, "");
	  		
	  		name = "habyuidate" + i;
	  		if (FieldExist(name))
	  			PutFieldText(name, "");
	  		
	  		name = "habyuija" + i;
	  		if (FieldExist(name))
	  			PutFieldText(name, "");
	  	}
	  	else {
	  	   break;
	  	}
	}
	
	if (FieldExist("refer"))
		PutFieldText("refer", "");
	
	
	if (FieldExist("hgamsa"))
		PutFieldText("hgamsa", "");
	
	
	for(i=1; i < 20; i++) {
		if (FieldExist("gongram" + i))
			PutFieldText("gongram" + i, "");
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

    parent.CurAprType = OrderType[1];
    if (OrderType.length > 2) {
		parent.NextAprType = OrderType[2];
    }
    
    parent.LastSignSN = OrderType.length
    
    for (i=1;i<OrderType.length;i++) {
		if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) {
			parent.LastSignSN = i;
			i = OrderType.length
		}
		
		else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType3 || OrderType[i] == strAprType13)
			parent.LastSignSN = i;
    }
    
	parent.lastKyulName = OrderName[parent.LastSignSN]
	parent.lastKyuljiwee = OrderJobtitle[parent.LastSignSN]
	if (FieldExist("lastKyuljikwee"))
		PutFieldText("lastKyuljikwee", parent.lastKyuljiwee);

	if (FieldExist("lastKyulName"))
		PutFieldText("lastKyulName", parent.lastKyulName);
      
	hapyuiCnt = 1;
	SignCnt = 1;
	referCnt = 1;
	gongramCnt = 1;
	
	var fieldname;
	var field;
	  
	
	for(i=1;i < 20;i++) {
	  	fieldname = "jikwe" + i
		if (FieldExist(fieldname) && ret[32] != "Y") {
			PutFieldText(fieldname, "");
			fieldname = "sign" + i
			if (FieldExist(fieldname))
				PutFieldText(fieldname, "");
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
			if (FieldExist(fieldname)) {
				var jikweName = trim(GetFieldText(fieldname));					
				if(jikweName.substring(0,1) != strLang128)
					PutFieldText(fieldname, OrderJobtitle[i]);
					
				if(OrderSuggester[i] == "Y")
					PutFieldText(fieldname, strLang75 + GetFieldText(fieldname));
					
				if(OrderReporter[i] == "Y")
					PutFieldText(fieldname, strLang76 + GetFieldText(fieldname));
			}
			idx = idx + 1;
	  	}
		else if(OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
			fieldname = "habyui" + hidx;
			if (FieldExist(fieldname))
				PutFieldText(fieldname, OrderDept[i]);
		
			fieldname = "habyuipositon" + hidx;
			if (FieldExist(fieldname)) {
				var jikweName = trim(GetFieldText(fieldname));					
				if(jikweName.substring(0,1) != strLang128)
					PutFieldText(fieldname, OrderJobtitle[i]);
					
				if(OrderSuggester[i] == "Y")
					PutFieldText(fieldname, strLang75 + GetFieldText(fieldname));
					
				if(OrderReporter[i] == "Y")
					PutFieldText(fieldname, strLang76 + GetFieldText(fieldname));
			}
			hidx = hidx + 1;
		}	
	}
  } catch(e){
	  alert("GetDraftAprLineInfo(ret) :: " + e);
  }	
}

function SGetDraftAprLineInfo(ret) {
    try {
        message = this;
        parent.DraftLastFlag = false;
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

        parent.CurAprType = OrderType[1];
        if (OrderType.length > 2) {
            parent.NextAprType = OrderType[2];
        }

        parent.LastSignSN = OrderType.length;
        LastSignSN = OrderType.length;

        for (i = 1; i < OrderType.length; i++) {
            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3){
                parent.LastSignSN = i;
                LastSignSN = i;
            }
        }

        if (OrderType[1] == strAprType4) {
            DraftLastFlag = true;
            parent.DraftLastFlag = true;
        }

        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];
        parent.lastKyulName = OrderName[LastSignSN];
        parent.lastKyuljiwee = OrderJobtitle[LastSignSN];
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

function setRecevInfo(ret) {
	setDeptLinesXML(ret);
	var precipent = ""
	var precipents = ""
	var recipflag = true;
	var xmldom = createXmlDom();
	xmldom = loadXMLString(ret);
	
	// 부모 페이지의 고정수신처 존재여부 배열 btnReceivLineEnableAry[] 값 변경
	if (getXmlString(xmldom) == "" || xmldom.getElementsByTagName("ROW").length == 0) {
		parent.btnReceivLineEnableAry[frameNum] = false;
		return; 
	}
	
	btnReceivLineEnable = true;
	parent.btnReceivLineEnableAry[frameNum] = true;
	
	var rows = xmldom.documentElement.childNodes;
	if (FieldExist("hrecipients")) {
		PutFieldText("hrecipients", "");
	}
	if (FieldExist("recipient")) {
		PutFieldText("recipient", "");
	}
	if (FieldExist("recipients")) {
		PutFieldText("recipients", "");
	}
	
    for (var i = rows.length - 1; i >= 0; i--) {
		var row = rows[i];
		var dataNodes = GetChildNodes(row);
		
        if (recipflag) {
            if (getNodeText(dataNodes[3]) == "Y") {
				if (getNodeText(dataNodes[1]).indexOf(parent.preSusinGroupStr) == 0) {
					precipent = strLang92;
					precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
				} else {
					precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
					precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
				}
					recipflag = false;
				}
            else {
                if (parent.isExtDoc == "Y") {
					if (getNodeText(dataNodes[1]).indexOf(parent.preSusinGroupStr) == 0) {
						precipent = strLang92;
						precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);				
					} else {
						precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
						precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);				
					}
						recipflag = false;	
				} else {
					if (getNodeText(dataNodes[1]).indexOf(parent.preSusinGroupStr) == 0) {
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
				if (parent.isExtDoc == "Y")
					precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]); 
				else
					precipents = precipents + ", " + getNodeText(dataNodes[0]);
			}
		}		
	}
	
    if (FieldExist("recipient")) {
        if (precipent == strLang92) {
        	PutFieldText("recipient", precipent);

            if (parent.SummaryOuterReceiverList != "") {
                if (FieldExist("recipients")) {
                	PutFieldText("recipients", parent.SummaryOuterReceiverList);
                    if (FieldExist("hrecipients"))
                    	PutFieldText("hrecipients", strLang129);
                }
            } else {
                if (FieldExist("recipients")) {
                	PutFieldText("recipients", precipents);
					if (FieldExist("hrecipients"))
						PutFieldText("hrecipients", strLang129);
                }
			}
		} else {
			PutFieldText("recipient", precipent);
            if (precipents == "") {
				if (FieldExist("hrecipients"))
					PutFieldText("hrecipients", "");
			
				if (FieldExist("recipients"))
					PutFieldText("recipients", "");
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
			if (FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				PutFieldText(fieldname, "");
					  		
			fieldname = susunSN + "seumyung" + i;
			if (FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				PutFieldText(fieldname, "");
					  		
			fieldname = susunSN + "seumyungdate" + i;
			if (FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				PutFieldText(fieldname, "");
				    
			fieldname = susunSN + "jikwe" + i;
			if (FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				PutFieldText(fieldname, "");
		}

		for(j = 1 ; j <= hapyuiCount ; j++) {
			fieldname = susunSN + "habyui" + j;
			if (FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				PutFieldText(fieldname, "");
			    
			fieldname = susunSN + "habyuipositon" + j;
			if (FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				PutFieldText(fieldname, "");
			
	  		fieldname =  susunSN + "habyuidate" + j;
			if (FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				PutFieldText(fieldname, "");
	      
			fieldname = susunSN + "habyuisign" + j;
			if (FieldExist(fieldname) && (typeof ret == "undefined" || ret[32] != "Y"))
				PutFieldText(fieldname, "");
		}
	    
		for(i=1;i<20;i++) {
			fieldname = "habyuiopinion" + i;
			if (FieldExist(fieldname))
				PutFieldText(fieldname, "");
		}
		
		
		fieldname = "sealsign";
		if (FieldExist(fieldname)) {
			PutFieldText(fieldname, "");
			SetFieldBackImage(fieldname, "");		// 닷넷은 SetFieldBackImage 미사용
		}
		
		
		fieldname = "opinions";
		if (FieldExist(fieldname)) {
			PutFieldText(fieldname, "");
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
	if (FieldExist(fieldname))
		PutFieldText(fieldname, "");
		
	fieldname = "recipients";
	if (FieldExist(fieldname))
		PutFieldText(fieldname, "");
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
		if (FieldExist(fieldname)) {
			fieldvalue = GetFieldText(fieldname);
			fieldvalue = trim(fieldvalue);
		    
		  	if(fieldvalue == "") {
		  		fieldname = "habyui" + j;
				if (FieldExist(fieldname))
					PutFieldText(fieldname, " ");
			}
		} 
	}
  } catch(e) {
	alert("ApplyDocCellInfo() :: " + e);
  }	
}


function putJunkyulSign(signID) {
	if (FieldExist(signID))
		PutFieldText(signID, strLang6);
}


// maxIdx : 최대 안의 갯수
function SendDraftMappingSign(ret, maxIdx) {
  try {
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt = 0;
	var sn = 1;
	
	var OpinionText = "";
	var PositionText = "";
	var LastSignSN = parent.LastSignSN;

	if (approvalFlag == "S") {
        if (LastSignSN == 1) {
            for (i = 1; i <= 20; i++) {
                signID = "sign" + i

                if (FieldExist(signID)) {
                    LastSignNo = i;
                }
            }
            sn = LastSignNo;
        } else if (DraftLastFlag) {
            putJunkyulSign("sign" + sn);
            for (i = 1; i <= 20; i++) {
                signID = "sign" + i

                if (FieldExist(signID)) {
                    LastSignNo = i;
                }
            }
            sn = LastSignNo;
        }
    } else {
        if (parent.LastSignSN == 1 || parent.CurAprType == strAprType4 || parent.CurAprType == strAprType16) {
            OpinionText = getSignDate() + "\15";
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

	if (FieldExist(pseumyungcell)) {
		PutFieldText(pseumyungcell, GetFieldText(pseumyungcell) + PositionText);
	}
	if (FieldExist(pseumyungdatecell)) {
		PutFieldText(pseumyungdatecell, s);
		parent.rtnSignInfo.push(pseumyungdatecell);
		
		/* 2023-10-06 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
		signInfo[signCnt] = pseumyungdatecell;
		parent.SignName[signCnt] = pseumyungdatecell;
		parent.SignType[signCnt] = "TEXT";
		parent.SignContent[signCnt] = s;
		signCnt = signCnt + 1;
    }
	
	// 기안자의 결재유형이 대결(strAprType16)이 되는 경우가 있다. G버전에서는 기안자 하나만 있으면 결재유형으로 대결/전결 등 선택 가능함.
	if (parent.CurAprType == strAprType16) {
		if (FieldExist(psigncell)) {
			// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
			if (FieldExist(pseumyungdatecell)) {
			    OpinionText = "";
			}
			
			if (ret != "NAME") {
				PutFieldText(psigncell, "");
				PrependFieldText(psigncell, strLang7 + OpinionText);
				parent.docDraftSignChkCnt ++; // 서명완료 카운트 증가 (이미지 서명 부여 시 SendDraftMappingSign_after 호출이 비동기적으로 진행되므로, 그 전에 미리 증가시킴)
				InsertPicture(psigncell, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(ret), SendDraftMappingSign_after);
				
			  	signInfo[signCnt] = psigncell;
			  	parent.SignType[signCnt] = "IMAGE";
			  	parent.SignName[signCnt] = psigncell;
			  	parent.SignContent[signCnt] = ret + "::" + strLang7 + OpinionText;
			  	parent.rtnSignInfo.push(psigncell);
                
			  	signCnt = signCnt + 1;
			  	SingFlag = true;
			} else {
				PutFieldText(psigncell, arr_userinfo[2]);	
				PrependFieldText(psigncell, strLang7 + OpinionText);
				parent.docDraftSignChkCnt ++;
				
				signInfo[signCnt] = psigncell;
				parent.SignType[signCnt] = "TEXT";
				parent.SignName[signCnt] = psigncell;
				parent.SignContent[signCnt] = strLang7 + OpinionText + arr_userinfo[2];
				parent.rtnSignInfo.push(psigncell);
		  		
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
	
	if (DekyulFlag && parent.NextAprType == strAprType4) { // 현재 기안자 = 대결, 다음 결재자 = 전결이 되는 분기
		if (FieldExist(psigncell)) {
			PutFieldText(psigncell, strLang6);
			parent.docDraftSignChkCnt ++;
			
			signInfo[signCnt] = psigncell;
			parent.SignType[signCnt] = "TEXT";
			parent.SignName[signCnt] = psigncell;
			parent.SignContent[signCnt] = strLang6;
			parent.rtnSignInfo.push(psigncell);
			
			signCnt = signCnt + 1;
			SingFlag = false; 
		}
	} else if (DekyulFlag) {
	
	} else {
		if (FieldExist(psigncell)) {
			// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
			if (FieldExist(pseumyungdatecell)) {
			    OpinionText = "";
			}
			
			if (ret != "NAME") { // 이미지 서명
				PutFieldText(psigncell, "");
				
				if (parent.CurAprType == strAprType4) {
                    OpinionText = strLangAprType4 + OpinionText;
				}
				
                PrependFieldText(psigncell, OpinionText);
                parent.docDraftSignChkCnt ++;
                InsertPicture(psigncell, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(ret), SendDraftMappingSign_after);
                
                signInfo[signCnt] = psigncell;
                parent.SignType[signCnt] = "IMAGE";
                parent.SignName[signCnt] = psigncell;
                parent.SignContent[signCnt] = ret + "::" + OpinionText;
                parent.rtnSignInfo.push(psigncell);
				
			  	signCnt = signCnt + 1;
			  	SingFlag = true;
			}
			else {
			    if (parent.CurAprType == strAprType4) {
			    	OpinionText = strLangAprType4 + OpinionText;
			    }
			    
			    PutFieldText(psigncell, arr_userinfo[2]);	
			    PrependFieldText(psigncell, OpinionText);
			    parent.docDraftSignChkCnt ++;
			  	
			    signInfo[signCnt] = psigncell;
			    parent.SignType[signCnt] = "TEXT";
			    parent.SignName[signCnt] = psigncell;
			    parent.SignContent[signCnt] = OpinionText + arr_userinfo[2];
			    parent.rtnSignInfo.push(psigncell);
			        
			  	signCnt = signCnt + 1;
			  	SingFlag = false; 
			}
		}
	}
	if (ret == "NAME") {
		// 서명 부여가 완료된 안의 갯수를 체크하여, 최종 안까지 부여가 전부 끝났을때 부모창의 GetHTML를 호출한다.
		if (parent.docDraftSignChkCnt == maxIdx) {
			parent.GetHTML(parent.saveDraftInfo);
		}
	}
  } catch(e) {
	  parent.HiddenMailProgress();
	  alert("SendDraftMappingSign(ret) :: " + e);
  }
}

// 서명부여 동작은 자식창마다 iframe에 접근하여 호출되므로, 부모 페이지의 전역변수를 사용하도록 한다. (콜백함수로 파라미터 직접 전달이 어려워서 우회함) 
function SendDraftMappingSign_after() {
	if (parent.docDraftSignChkCnt == parent.docMaxTabNumForDraft) { // 최종 안까지 전부 서명부여가 완료된 경우, 기안파일+DB정보저장 진입
		parent.GetHTML(parent.saveDraftInfo);
	}
}

// 배열을 전달받는다.
function UndoSignInfo(signInfo) {
  try {
	var cnt 
	if (signInfo) {
		for (cnt = 0; cnt < signInfo.length; cnt++) {
			if (FieldExist(signInfo[cnt])) {
				PutFieldText(signInfo[cnt], "");
			}
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

function setDrafterAddress() {
	SetDocumentElementForDraftAll("drafter", arr_userinfo[2]);
	SetDocumentElementForDraftAll("address", arr_userinfo[8]);
	SetDocumentElementForDraftAll("drafterdept",arr_userinfo[4]);
	SetDocumentElementForDraftAll("lastKyulName", parent.lastKyulName);
	SetDocumentElementForDraftAll("lastKyuljikwee", parent.lastKyuljiwee);
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
	
	if (pFormHref == "PC") {
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
            Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null); 
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
	  alert("ezDraftAll_WHWP.js > openFormUI()" + e.description);
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
		alert("ezDraftAll_WHWP.js > SetBtnStateFalse()" + e.description);
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
		alert("ezDraftAll_WHWP.js > SetBtnStateTrue()" + e.description);
	}
}

function SetAutoPropertyValue(frameNum) {
	var fieldname;
	var field;
	var pSusinNextSN;
	var objNodes;
	var CurrentDate;
    xmluserInfo = typeof xmluserInfo != "undefined" ? xmluserInfo : parent.xmluserInfo;
	objNodes = xmluserInfo.documentElement.childNodes;
	
	var FullDate = typeof getGyulJeFullDate != "undefined" ? getGyulJeFullDate() : parent.getGyulJeFullDate();
	CurrentDate = typeof getGyulJeDate != "undefined" ? getGyulJeDate() : parent.getGyulJeDate();
	SendName = parent.SendName; // 부모 페이지에서 가져온 부서발신명의 그대로 사용
	
	SignInfo = "";
	hapyuiCount = 0;
	SignCount = 0;
	gamsaCount = 0;

	var Fields = GetFieldList(0, 1);
	
	// 임시보관함 또는 반송 후 재기안창에서 연 다음 안추가 동작에 대응하도록 조건 추가
	for (i = 0 ; i < Fields.length ; i ++) {
		if (pDraftFlag == "DRAFT" || ((ListType == "21" || pDraftFlag == "REDRAFT") && parent.addFlag == true)) { // 임시저장 또는 반송된 문서도 안추가 가능
			switch (Fields[i]) {
				case "bedocnumber" :				    
					setDocNumFormat("be");
					break;

				case "docnumber" :				    
					setDocNumFormat("");
					break;

				case "enforcedate" :		  
					PutFieldText(Fields[i], " ");
					break;

				case "opinions" :		  
					PutFieldText(Fields[i], " ");
					break;

				case "receiptdate" :		  
					PutFieldText(Fields[i],  "");
					break;
				
				case "recipient" :			  
					PutFieldText(Fields[i],  "");
					break;

				case "hrecipients" :			  
					PutFieldText(Fields[i],  "");
					break;

				case "recipients" :			  
					PutFieldText(Fields[i],  "");
					break;
				
				case "refer" :				    
					PutFieldText(Fields[i],  "");
					break;
				
				case "zipcode" :	
					//PutFieldText(Fields[i], getNodeText(GetElementsByTagName(objNodes, "POSTALCODE")[0]));
					break;

				case "address" :
					//PutFieldText(Fields[i], getNodeText(GetElementsByTagName(objNodes, "STREETADDRESS")[0]));
					break;												

				case "telephone" :		  	
					if( trim(getNodeText(objNodes.item(5))) != "" )
						PutFieldText(Fields[i], getNodeText(objNodes.item(5)));
					break;

				case "depttelephone" :		  	
					PutFieldText(Fields[i], getNodeText(objNodes.item(5)));
					break;																							
				case "fax" :			      	
					if( trim(getNodeText(objNodes.item(4))) != "" )
						PutFieldText(Fields[i], getNodeText(objNodes.item(4)));
					break;
				case "deptfax" :			      	
					PutFieldText(Fields[i], getNodeText(objNodes.item(4)));
					break;													
				case "department" :		  	
					PutFieldText(Fields[i], arr_userinfo[5]);
					break;												
				case "parantdept" :       
					PutFieldText(Fields[i], getNodeText(objNodes.item(3)));
					break;
				case "seniorposition" :		
					break;												
				case "seniorname" :			  
					break;												
				case "charge" :				    
					PutFieldText(Fields[i], getNodeText(objNodes.item(0)));
					break;
				case "position" :			    
					PutFieldText(Fields[i], arr_userinfo[3]);
					break;
				case "email" :				 
					PutFieldText(Fields[i], arr_userinfo[8]);
					break;
				case "keepperiod" :			  
					
					break;												
				case "publication" :		  
					PutFieldText(Fields[i], "");
					break;												

				case "examname" :			    
					break;												
				
				case "examdate" :			    
				break;												
				
				case "headcampaign" :		  
					
					break;							
				
				case "deptname" :         
					PutFieldText(Fields[i], arr_userinfo[5]);
					break;
				
				case "seal" :             
					PutFieldText(Fields[i], getNodeText(objNodes.item(3)) + "대표이사");
					break;
				
				case "username" :         
					PutFieldText(Fields[i], arr_userinfo[2]);
					break;
				
				case "draftername" :      
					PutFieldText(Fields[i], arr_userinfo[2]);
					break;
				
				case "draftdate" :        
					
					PutFieldText(Fields[i], CurrentDate);
					break;
				
				case "deptshortedname" :
					PutFieldText(Fields[i], DeptSymbol + ":");
					break;

				case "organ" :        
					if (SendName != "")
						PutFieldText(Fields[i], SendName);
					break;

				case "chief" :        
					if (SendName != "")
						PutFieldText(Fields[i], SendName + strLang93);
					break;
			}
		} else {
			switch (Fields[i]) {
				case pSusinSN + "receiptdate" :	 
					PutFieldText(Fields[i], CurrentDate);
					break;
			}
		}
	  	
		
		if (pDraftFlag == "SUSIN" ||  pDocState == "011") {
			var pSignSusin = pSusinSN + "sign";
			if (Fields[i].substr(0, 5) == pSignSusin) {
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
	  	
	    if (pDraftFlag == "SUSIN" || pSusinSN != "0") {
			var pSignInfoSusin = pSusinSN + "jikwe";
			if (Fields[i].substr(0,6) == pSignInfoSusin) {
				if (SignInfoFlag) {
					SignInfo = GetFieldText(Fields[i]);
					SignInfoFlag = false;
				} else {
					SignInfo = GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    } else {
			if (Fields[i].substr(0,5) == "jikwe") {
				if (SignInfoFlag) {
					SignInfo = GetFieldText(Fields[i]);
					SignInfoFlag = false;
				} else {
					SignInfo = GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
		}
	}
	
	pSuSinFlag = "N";

	if (pDraftFlag != "SUSIN" && pDocState != "011" ) {
		var RtnVal = FieldExist("recipient");
		if (RtnVal) {
			pSuSinFlag = "Y";
			setMenuBar("btnSetReceivLine", true);	
		} else {
			pSuSinFlag = "N";
			setMenuBar("btnSetReceivLine", false);	
		}
	}
	
	
	if (pSusinSN) {
		pSusinNextSN = parseInt(pSusinSN) + 1;
	} else {
		pSusinNextSN = 1;
	}
	
	fieldname = pSusinNextSN + "sign1";
	if (FieldExist(fieldname)) {
		pSuSinFlag = "Y";
		setMenuBar("btnSetReceivLine", true);
	} else {
		if (pSuSinFlag == "N") {	
			pSuSinFlag = "N";
			setMenuBar("btnSetReceivLine", false);
		}
	}
	
	pChamJoFlag = "Y";

	// 부모창의 일괄기안 데이터 배열에 값 추가
	parent.SignInfoAry[frameNum] = SignInfo;
	parent.hapyuiCountAry[frameNum] = hapyuiCount;
	parent.SignCountAry[frameNum] = SignCount;
	parent.gamsaCountAry[frameNum] = gamsaCount;
	parent.pSuSinFlagAry[frameNum] = pSuSinFlag;
}

function SetAutoPropFinal()
{
  try {
    var CurrentDate;
    CurrentDate = getGyulJeDate();
    
	var Fields = GetFieldList(0, 1);
  
	for (i = 0; i < Fields.length; i ++) {
		if (pDraftFlag == "DRAFT") {
			switch (Fields[i]) {
	  			case "sentdate" :        
	  				PutFieldText(Fields[i], CurrentDate);
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
    alert("ezDraftAll_WHWP.js > openOpinionUI(pOpinionFlag)" + e.description);
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
		
		apropinion_cross_dialogArguments[0] = parameter;
		if (typeof(CompleteFunction) != "undefined") {
			apropinion_cross_dialogArguments[1] = CompleteFunction; 
		} else {
			apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete;
		}
		DivPopUpShow(530, 520, url);
	} catch (e) {
		alert("ezDraftAll_WHWP.js > openOpinionUI_New ::: " + e.description);
	}
}

function openOpinionUI_New_Complete(ret) {
	DivPopUpHidden();
	if (ret == "Clear") { // 의견 전부 삭제
		pHasOpinionYN = "N";
		pHasOpinionYNAry[currentTabIdx] = "N";
		ret = "cancel";
	} else if (ret == "cancel") {
		// 취소시 동작 없음
	} else {
		var objXML = loadXMLString(ret);

		var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
		if (NodeList.length != 0) {
			pHasOpinionYN = "Y";
			pHasOpinionYNAry[currentTabIdx] = "Y";
		} else {
			pHasOpinionYN = "N";
			pHasOpinionYNAry[currentTabIdx] = "N";
			ret = "cancel";
		}
		makeOpinionList(objXML);
	}
    return ret;
}

function makeOpinionList(OpinionXML) {
	if (!document.getElementById("ifrm" + currentTabIdx).contentWindow.FieldExist("opinions"))
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
		document.getElementById("ifrm" + currentTabIdx).contentWindow.PutFieldText("opinions", strOpinion);
	}
	else {
		document.getElementById("ifrm" + currentTabIdx).contentWindow.PutFieldText("opinions", " ");
	}
}

// 일괄기안 플래그와 안 번호 전달
function openFileAttachUI() {
  try {
	  var url = "/ezApprovalG/aprAttach.do?formID=" + pFormID + "&docID=" + pDocID + "&draftFlag=" + pDraftFlag + "&orgCompanyID=" + orgCompanyID + "&ext=hwp&draftAllFlag=Y&anNo=" + currentTabIdx;
	  DivPopUpShow(800, 610, url);
  } catch(e) {
	  alert("openFileAttachUI() :: " + e);
  }
}

var aprcabinetattach_cross_dialogArguments = new Array();
function openAaprDocAttachUI() {
  try {
	  var parameter = pDocID;
	  var url;
      if(approvalFlag == "G") {
	    url = "/ezApprovalG/aprCabinetAttach.do?draftFlag=" + pDraftFlag + "&draftAllFlag=Y&anNo=" + currentTabIdx;
      } else {
        url = "/ezApprovalG/aprDocAttach.do?orgCompanyID=" + orgCompanyID + "&draftAllFlag=Y&anNo=" + currentTabIdx;
      }

	  aprcabinetattach_cross_dialogArguments[0] = parameter;
      aprcabinetattach_cross_dialogArguments[1] = openAaprDocAttachUI_complete;
      
	  DivPopUpShow(1050, 560, url);
  } catch(e) {
	  alert("openAaprDocAttachUI() :: " + e);
  }
}

function openAaprDocAttachUI_complete(ret){
	DivPopUpHidden();
	if (ret != "cancel") {
		document.getElementById("ifrm" + currentTabIdx).contentWindow.setAttachInfo(pDocID, "APR", lstAttachLink);	// 각 안별 iframe 내부에 첨부파일 영역이 존재
	}
}

function SaveDraftDocInfo(currIdx) {
	var rtnVal;
	
	if (SaveFileForDraftAll(currIdx) != "TRUE") {
		return "FALSE";
	}
	
    SignSave(currIdx);
    
	rtnVal = SaveDraftDocInfo_ilban("002", currIdx);
	
	if (rtnVal.toUpperCase() != "TRUE")	{
		SaveOrgFile(currIdx);
	}
	
	return rtnVal;
}

// iframe 내부에서 실행됨 (실제 기안올림 시에는 SaveFlag 사용되지 않음, 임시저장 시에만 체크함)
function SaveDraftDocInfo_ilban(pState, currIdx)
{
  try {
	var objRoot;
	var objNode;
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();

	createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", parent.pDocIDAry[currIdx]);
	createNodeAndInsertText(xmlpara, objNode, "FORMID", parent.pFormIDAry[currIdx]);

/*	if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
	    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pOrgDocID);
	    createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", pDocType);
	    createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", pDocState);
	}
	else {*/
	    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", "");
	    createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", "");
	    createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", "");
//	}

	createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", pState);
    createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + parent.pDocIDAry[currIdx] + "." + parent.extAry[currIdx]);

	if (FieldExist("doctitle")) {
	    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", GetFieldText("doctitle"));
	} else {
	    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", "");
	}
	
	var field = "";
	if (FieldExist("docnumber")) {
	    field = GetFieldText("docnumber");
	} else if (FieldExist("be_docnumber")) {
	    field = GetFieldText("be_docnumber");
	} else if (FieldExist("deptshortedname")) {
	    field = GetFieldText("deptshortedname");
	} else {
	    field = "";
	}
	
	createNodeAndInsertText(xmlpara, objNode, "DOCNO", field);
	
	// 일반첨부 또는 문서첨부가 존재하는 경우를 고려
    if (parent.pHasAttachYNAry[currIdx] == "Y" || parent.pHasDocAttachYNAry[currIdx] == "Y") {
    	createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", "Y");
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", "N");
    }
	createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", undefined2EmptyString(parent.pHasOpinionYNAry[currIdx]));

	var startdate;
	if (pState == "000") {
	    startdate = "DRAFTSAVE";
	} else {
	    startdate = "DRAFT";
	}
	
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

	createNodeAndInsertText(xmlpara, objNode, "SECURITY", parent.tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", parent.tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", parent.tempPublic);

	createNodeAndInsertText(xmlpara, objNode, "PUBLIC", parent.tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", parent.tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", parent.tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", parent.tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", parent.tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KEYWORD", parent.tempKeyword);
	createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");

	createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", parent.pSpecialRecordCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", parent.pPublicityCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", parent.tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", parent.pLimitRange);
	createNodeAndInsertText(xmlpara, objNode, "PAGENUM", parent.pPageNum);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", parent.cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", parent.TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", undefined2EmptyString(parent.pDocNumCodeAry[currIdx])); // 안별 문서번호
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

	// 각 안 별 분리첨부데이터 저장
	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElementForDraftAll("sepattachlvxml", true);
	
	if (!g_SepAttachLVXml) {
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
	} else {
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));
	}
	createNodeAndInsertText(xmlpara, objNode, "SUMMARY", parent.pSummery);

	createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", parent.tempSecurityDate);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", parent.tempItemName2);
	
	createNodeAndInsertText(xmlpara, objNode, "PASSAPRLINE", "N");
	
	if (currIdx != 1) {
		createNodeAndInsertText(xmlpara, objNode, "SENDNOTIFLAG", "N");
	}
	
	/*
	 * 2018-06-14 천성준
	 * 비전자문서 데이터 세팅 메소드
	 * */
/*	if (nonElecRec == "Y") {
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
	}*/
	
	xmlhttp.open("POST",parent.extAry[currIdx] == "mht" ? "/ezApprovalG/doDraft.do" : "/ezApprovalG/doDraftHWP.do",false);
	xmlhttp.send(xmlpara);
	
	if (pState != "000") {	
		SetBtnStateFalse();
	}
	if (xmlhttp.status == 200) {
		var dataNodes = GetChildNodes(xmlhttp.responseXML);
        return getNodeText(dataNodes[0]);
	} else {
		return "FALSE";
	}
  } catch(e){
	  alert("SaveDraftDocInfo_ilban(pState)::" + e);
	  console.log(e);
	  console.log(e.stack);
  }
}

// 문서번호 리턴 부분은 getDocNumByFormat() 함수로 분리
function setDocNumFormat(pPrefix) {
	var numHeader = "";
	
	// 임시보관함에서는 안추가를 허용하므로, 분기 추가 (addFlag값이 true인 경우에만 추가적인 안추가로 체크)
	if (pDraftFlag == "REDRAFT" && (ListType != "21" && parent.addFlag == false)) {
		return;
	}
	
	if (!FieldExist(pPrefix + "docnumber")) {
		return; 
	}

	var fieldValue = GetFieldText(pPrefix + "docnumber"); // 문서번호 필드의 문서번호 포맷
    
    // orgdocnum 처리 추가
    if ("hwp" === docHref.substring(docHref.lastIndexOf(".") + 1)) {
        var tmpdocNum = GetDocumentElementForDraftAll(pPrefix + "orgdocnum", true);

        if (!tmpdocNum) {
            if (fieldValue) {
                SetDocumentElementForDraftAll("orgdocnum", fieldValue);
            }
        } else {
            fieldValue = tmpdocNum;
        }
    } else {
        var tmpdocNum = DocumentBodyGetAttribute(pPrefix + "orgdocnum");

        if (!tmpdocNum) {
            if (fieldValue) {
                DocumentBodySetAttribute("orgdocnum", fieldValue);
            }
        } else {
            fieldValue = tmpdocNum;
        }
    }

    
    numHeader = getDocNumByFormat(fieldValue);
	
	PutFieldText(pPrefix + "docnumber", numHeader);
	
	if (numHeader.indexOf(strLang107) > 0) {}
	
    if (FieldExist("receiptnumber")) {
        if (GetFieldText("receiptnumber") != "") {
        	SetDocumentElementForDraftAll("receiptnumber", GetFieldText("receiptnumber"));
        }

        PutFieldText("receiptnumber", "");
    }
}

// 문서번호만 별도로 리턴하기 위한 함수 분리 파트
function getDocNumByFormat(format) {
	var Arr_Header = new Array();
	var numHeader = "";
	var Header, Tail;
	var i;
	var d = new Date();
		
	Arr_Header = format.split("@");
    
	for (i = 1; i < Arr_Header.length; i++) {
		Header = Arr_Header[i].substr(0,2);
		Tail = Arr_Header[i].substr(2);
		
		switch(Header) {
			case "DP":
				numHeader = numHeader + DeptSymbol + Tail;
				break;			

			case "dp":
				numHeader = numHeader + DeptSymbol + Tail;
				break;

			//2021-01-28 문서번호의 년도가 제대로 출력되지 않는 부분 해결
			case "YY":
				numHeader = numHeader + getAccountingYear() + Tail;
				break;

			case "yy":
				var yyear = getAccountingYear();
				numHeader = numHeader + yyear.toString().substr(2) + Tail;
				break;

			case "MM":
				var mmonth = d.getMonth() + 1;
				if (parseInt(mmonth) < 10) {
					mmonth = "0" + mmonth;
				}
				numHeader = numHeader + mmonth + Tail;
				break;

			case "mm":
				numHeader = numHeader + (d.getMonth() + 1) + Tail;
				break;

			case "NN":
				break;

			case "nn":
				break;

			case "cs":
				numHeader = numHeader + strLang107 + Tail;
				break;
				
            case "FT":
                numHeader += "FT" + Tail;
                break;
    
            case "MV":
                numHeader += "MV" + Tail;
                break;
    
            case "YM":
                var yyear = d.getFullYear();
                numHeader += yyear.toString().substr(2);
    
                var mmonth = d.getMonth() + 1;
                if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
                numHeader += mmonth;
    
                var mdate = d.getDate();
                if (parseInt(mdate) < 10) mdate = "0" + mdate;
                numHeader += mdate + Tail;
    
                break;

			default:
				numHeader = numHeader + format;
				break;
		}
	}
	
	return numHeader;
}

// 부모창에서 각 자식프레임에 접근해 호출하므로 docID 전달 시 배열을 사용
function SaveFileForDraftAll(currIdx) {
	var result = "";

	var data = {
		docID : parent.pDocIDAry[currIdx],
		formId : parent.pFormIDAry[currIdx],
		html  : parent.htmlDataAry[currIdx]
	}

	var url = parent.extAry[currIdx] == "mht" ? "/ezApprovalG/saveFile.do" : "/ezApprovalG/saveFileHWP.do";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : url,
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});
    
    return result;
}

function SignSave(currIdx) {
    if (parent.SignContent.length > 0) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objRoot, objNode, subNode;
        objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

        for (i = 0; i < parent.SignContent.length; i++) {
            objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "SIGNINFO");
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", parent.pDocIDAry[currIdx]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNTYPE", parent.SignType[i]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNNAME", parent.SignName[i]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "CONTENT", parent.SignContent[i]);
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, subNode, "ORGCOMPANYID", typeof orgCompanyID == "undefined" ? parent.orgCompanyID : orgCompanyID);
        }
        xmlhttp.open("Post", "/ezApprovalG/setSignInfo.do", false);
        xmlhttp.send(xmlpara);
    }
}

//부모창에서 각 자식프레임에 접근해 호출하므로 docID 전달 시 배열을 사용
function SaveOrgFile(currIdx) {
	var result = "";

	// 2021.01.07 강승구 : 오류발생 후 파일이 사라지는 오류 수정
	// 웹한글기안기 기안 페이지에서 pOrgHtml 변수는 선언만 되고 값이 부여되지는 않는다.
	// 따라서 서명 및 문서번호 동작 이전, 최초로 기안을 위해 웹한글 HTML 파일을 가져오는 시점 (GetHTML)에서 pOrgHtmlAry 배열에 원문서 정보를 넣어준다.
	// 이 동작이 정상이 아니라면 오류 발생 시에도 서명이 들어간 채로 문서가 남아있게 됨.
	
	// 원래는 이 동작이 항상 리턴되는 코드였음. (!pOrgHtml 시 리턴 ==> undefined인 변수가 항상 true조건을 가지므로...)
	
	//console.log(currIdx + "안에서 SaveOrgFile() 진입, parent.pOrgHtmlAry[currIdx]   ::   " + parent.pOrgHtmlAry[currIdx]);
	
	// 원문서 데이터가 없다면 바로 리턴
	if (typeof(parent.pOrgHtmlAry[currIdx]) == "undefined" || parent.pOrgHtmlAry[currIdx].trim() == "") {
        return;
	}
        
	var data = {
		docID : parent.pDocIDAry[currIdx],
		formId : parent.pFormIDAry[currIdx],
		html  : parent.pOrgHtmlAry[currIdx]
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

var aprsign1_cross_dialogArguments = new Array();
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
      alert("ezDraftAll_WHWP.js > openSignUI()" + e.description);
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
			
			if (FieldExist(SignName)) {			
			    retVal = true;
				if (SignType == "TEXT")
				{
					//HwpCtrl.SetFieldText(SignName, SignCont);
					PutFieldText(SignName, ReplaceText(SignCont, "<br/>", "\15"));
				}
				else if (SignType == "HTML")
				{
					//HwpCtrl.AppendFieldText(SignName, SignCont, true, true, true);
					AppendFieldText(SignName, SignCont);
				}
				else if (SignType == "PROXY")
				{
					/*HwpCtrl.SetFieldText(SignName, " ");
					HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(SignCont), 3, 0, 0, true, 2);
					HwpCtrl.AppendFieldText(SignName, strLang17, true);*/
					
					PutFieldText(SignName, " ");                        
					AppendFieldText(SignName, strLang17);
					InsertPicture(SignName, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(SignCont), null);
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
                    PutFieldText(SignName, "");
                    if(img.length >= 1) {
                    	InsertPicture(SignName, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(img[0]));
                    }
                    
                    if(img.length >= 2) {
                        AppendFieldText(SignName, img[1]);
                    }

				}			
			}
		}
	}
  } catch(e) {
	alert("ezDraftAll_WHWP.js > putSignXML : " + e.description);
	return false;
  }
  return retVal;
}

// 웹한글기안기 iframe 내부에서 실행되므로, 변수는 부모창에 접근해서 사용한다.
// 배열에 접근하기 위해 idx 전달함 (1부터 시작)
function SaveTMPFile(Saveflag, html, idx) {
    var result = "";
    
    var docID = "";
    if (Saveflag) {
    	docID = parent.newpDocIDAry[idx];
    } else {
    	docID = parent.pDocIDAry[idx];
    }
    
    //console.log("parent.pDocIDAry[" + idx + "] in SaveTMPFile    ::   " + parent.pDocIDAry[idx]);
    //console.log("docID in SaveTMPFile    ::   " + docID);
    
	var data = {
		docID : docID,
		formId : parent.pFormIDAry[idx],
		html  : html
	}

    var url = parent.extAry[idx] == "mht" ? "/ezApprovalG/saveTmpFile.do" : "/ezApprovalG/saveTmpFileHWP.do";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : url,
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});

    return result;
}

//웹한글기안기 iframe 내부에서 실행되므로, 일부 변수는 부모창에 접근해서 사용한다.
// 비동기 동작에 대응하기 위해 단일 파라미터가 아닌 배열에 접근하도록 수정함
function SaveTMPDocInfo(Saveflag, idx) {
    try {
        var objRoot;
        var objNode;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");

        // setTabInfo 루프를 돌며 부여한 값을 사용한다. PARENT에 접근해야 함 (임시저장 후 다시 임시저장하는 경우, 덮어쓰지 않고 새 문서로 저장)
        if (Saveflag) {
        	createNodeAndInsertText(xmlpara, objNode, "DOCID", parent.newpDocIDAry[idx]);
        } else {
        	createNodeAndInsertText(xmlpara, objNode, "DOCID", parent.pDocIDAry[idx]);
        }
        createNodeAndInsertText(xmlpara, objNode, "FORMID", parent.pFormIDAry[idx]);
        
        // 수신문서 접수나 부서합의 시 일괄기안 사용 불가이므로 주석처리
        // 수신문서 -> 내부결재완료된 일괄기안문서이므로 각 안별로 개별 문서가 되어 도착함
        // 합의 - > 개인합의만 가능하므로 draftall쪽의 스크립트를 타지 않음
/*        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
            createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", parent.pOrgDocID);
            createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", parent.pDocType);
            createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", parent.pDocState);
        } else {*/
        // DRAFT 또는 REDRAFT만 존재할듯
            createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", "");
            createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", "");
            createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", "");
      //  }
        
        // 기안 시점의 aprState값이 001(대기)이면 임시저장으로 취급한다.
        createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", strAprState1); // 001 (대기)
        if (Saveflag) {
        	createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + parent.newpDocIDAry[idx] + "." + parent.extAry[idx]); // 원래는 .htm이었는데  hwp로 수정함. 뭔 의미가 있나?
        } else {
        	createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + parent.pDocIDAry[idx] + "." + parent.extAry[idx]);
        }
        
        if (FieldExist("doctitle")) {
            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", GetFieldText("doctitle"));
        } else {
            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", "");
        }
        
        var pDocNO = "";
        if (FieldExist("docnumber")) {
        	pDocNO = GetFieldText("docnumber");
        } else if (FieldExist("be_docnumber")) {
        	pDocNO = GetFieldText("be_docnumber");
        } else if (FieldExist("deptshortedname")) {
        	pDocNO = GetFieldText("deptshortedname");
        } else {
        	pDocNO = "";
        }
        
        createNodeAndInsertText(xmlpara, objNode, "DOCNO", pDocNO);
        
        // 일반첨부 또는 문서첨부가 존재하는 경우를 고려
        if (parent.pHasAttachYNAry[idx] == "Y" || parent.pHasDocAttachYNAry[idx] == "Y") {
        	createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", "Y");
        } else {
        	createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", "N");
        }
        
        createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", undefined2EmptyString(parent.pHasOpinionYNAry[idx]));
        createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "DRAFTSAVE");
        createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WRITERID", arr_userinfo[1]); // IFRAME 내부 로드 시 부모의 정보 복사함
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "HTML", "");
        createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");
        createNodeAndInsertText(xmlpara, objNode, "PUSERID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "PDEPTID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "SECURITY", parent.tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", parent.tempKeep); // 보존년한인데 ""으로 고정되어있음
        createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", parent.tempPublic); // 기본값은 공개
        createNodeAndInsertText(xmlpara, objNode, "PUBLIC", parent.tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", parent.tempItemCode); // ""으로 고정
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", parent.tempItemName); // ""으로 고정
        createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", parent.tempUrgent); // 기본값은 긴급결재 아님
        createNodeAndInsertText(xmlpara, objNode, "KEYWORD", parent.tempKeyword);
        createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");
        createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", parent.pSpecialRecordCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", parent.pPublicityCode);
        createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", parent.pLimitRange);
        createNodeAndInsertText(xmlpara, objNode, "PAGENUM", parent.pPageNum); // 기본값은 1
        createNodeAndInsertText(xmlpara, objNode, "CABINETID", parent.cabinetID);
        createNodeAndInsertText(xmlpara, objNode, "TASKCODE", parent.TaskCode); // ""로 고정됨
        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", undefined2EmptyString(parent.pDocNumCodeAry[idx])); // 임시저장문서이므로 ""로 고정됨
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");
        createNodeAndInsertText(xmlpara, objNode, "FORMHREF", parent.pFormHrefAry[idx]);
        createNodeAndInsertText(xmlpara, objNode, "DOCSN", undefined2EmptyString(parent.DocSNAry[idx])); // 재기안 등에 사용
        createNodeAndInsertText(xmlpara, objNode, "LISTTYPE", parent.ListType); // 변경없이 고정
        createNodeAndInsertText(xmlpara, objNode, "DRAFTFLAG", parent.DraftFlag); // 대부분 DRAFT 또는 REDRAFT

        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = GetDocumentElementForDraftAll("sepattachlvxml", true);
        if (!g_SepAttachLVXml) {
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
        } else {
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));
        }
        
        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", parent.pSummery);
        createNodeAndInsertText(xmlpara, objNode, "SUMMARYPATH", parent.pSummaryPath);
        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", parent.tempSecurityDate);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", parent.tempItemName); // ""로 고정
        
        if (Saveflag) {
        	createNodeAndInsertText(xmlpara, objNode, "saveFlag", Saveflag);
        	createNodeAndInsertText(xmlpara, objNode, "oldDocID", parent.pDocIDAry[idx]);
        }
        
        //console.log(xmlpara);
        
        xmlhttp.open("POST", parent.extAry[idx] == "mht" ? "/ezApprovalG/doDraft.do" : "/ezApprovalG/doDraftHWP.do", false);
        xmlhttp.send(xmlpara);

        if (xmlhttp.status == 200) {
    		var dataNodes = GetChildNodes(xmlhttp.responseXML);
    		
            return getNodeText(dataNodes[0]);
    	} else {
    		return "FALSE";
    	}
    } catch (e) {
        OpenAlertUI("ezDraftAll_WHWP.js > SaveTMPDocInfo()" + e.description);
        return "FALSE";
    }
}

//결재 세부옵션처리
function setFormAprOption(){  
    if(formAprOption.indexOf("_a2_"))  //파일첨부
        setMenuBar("btnFileAttach", false);	
    if(formAprOption.indexOf("_a3_"))  //문서첨부
        setMenuBar("btnAprDocAttach", false);	
}

// undefined 문자열을 공백으로 반환
function undefined2EmptyString(value) {
	if (value == undefined) {
		return ""; 
	} else {
		return value; 
	}
}

// 임시저장을 위해 최신 임시저장 순번을 리턴하는 ajax 함수
function getMaxTmpGroupDocSN() {
	var ret = "";
	
	  $.ajax({
			type : "GET",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/getMaxTmpGroupDocSN.do", // userInfo만 사용하므로 데이터는 전달할 필요 없음
			success: function(result) {
				if (result == "error") {
					var pAlertContent = strLang217;
					OpenAlertUI(pAlertContent);
					return false;
				} else {
					ret = result;
				}
			}, error : function () {} // 서버단에서 예외처리함. result를 error로 반환하므로 success에서 체크
		});
	  
	  return ret;
}

// 일괄기안을 위한 결재선 업데이트 함수 (docID 배열로 접근)
function UpdateLineHistoryForDraftAll(currIdx) {
	var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateLineHistory.do",
		data : {
			docID : pDocIDAry[currIdx],
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
		        var pAlertContent = strLang91; // "결재선 이력 등록시 오류가 발생하였습니다.";
		        OpenAlertUI(pAlertContent);
		    }
		},
		error : function() {
			var pAlertContent = strLang91;
	        OpenAlertUI(pAlertContent);
		}
	});
}

// 일괄기안을 위한 임시저장 및 기안올림 안된 문서데이터 제거 함수 (루프를 돌며 docID 배열 파라미터를 전달)
function UndoDocForDraftAll(pDocID) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/undoDoc.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
		}        			
	});
}

// 일괄기안 성공 시 일괄기안그룹 테이블의 기존 임시저장 데이터 삭제 및 새로운 기안데이터 삽입 함수 추가 
// 임시저장된 문서가 아니라면 tmpGroupDocSN값은 공백으로 전달된다.
function saveAprGroupAndDelTmp(tmpGroupDocSN, pDocID, pNewGroupDocSN, tabSN) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveAprGroupAndDelTmp.do",
		data : {
			docID : pDocID, // 새로 저장할 docID
			tmpGroupDocSN : tmpGroupDocSN, // 임시저장된 문서의 경우, 기존 임시저장된 일괄기안그룹 ID
			newGroupDocSN : pNewGroupDocSN, // 새롭게 저장할 일괄기안그룹 ID (1안의 DOCID)
			tabSN : tabSN // 안 번호
		},
		success: function(text) {},
		error : function(e) {
			console.log(e);
		}
	});
}

// 임시저장문서 또는 재기안문서 가져올 때 각 안 별 수신처 존재여부를 체크하여 true/false를 리턴한다.
function getReceiptExists(pDocID, mode) {
	var res = false;
	
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getReceiptExists.do",
		data : {
			docID : pDocID, // docID 또는 docSN
			mode : mode // TMP 또는 APR
		},
		success: function(result) {
			if (result == "TRUE") {
				res = true;
			}
		},
		error : function(e) {
			console.log(e);
		}
	});
	
	return res;
}

// 일괄기안된 문서의 반송의견 삭제 함수 오버라이드 (반송 시 의견작성은 1안 기준이나, 모든 안으로 복사되므로 각 안마다 삭제함)
function delOpinionInfoForDraftAll(currIdx) {
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
			docID : pDocIDAry[currIdx],
			opinionType : opinionType
		},
		success: function(result) {}
	});
}

// 현재 문서가 가진 총 의견의 갯수를 체크하여 의견 존재 여부를 리턴하는 함수
function chkOpinionInfoExist(currIdx) {
	var res = "N";
	
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/chkOpinionInfoExist.do",
		data : {
			docID : pDocIDAry[currIdx],
			orgCompanyID : orgCompanyID
		},
		success: function(result) {
			res = result;
		}
	});
	
	return res;
}

// 반송 및 회수된 문서를 재기안하는 경우, 안삭제 -> 결재올림 완료 시 안삭제된 문서는 실제로 삭제한다.
function RemoveDoc(pDocID, orgCompanyID) {
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/delDocInfo.do",
		data : {
			docID : pDocID,
			field  : "MUST",
			orgCompanyID : orgCompanyID 
		},
		success: function(xml) {
			result = xml;
		}        			
	});
    
    if (result == "FALSE") {
        var pAlertContent = strLang872;
        OpenAlertUI(pAlertContent);
        //return;
    }
}

// 양식ID를 전달하면 해당 양식의 문서번호 포맷을 문자열로 리턴하는 함수
function getDocNumFormatByFormID(pFormID, orgCompanyID) {
	var result = "";
	
    $.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getDocNumFormatByFormID.do",
		data : {
			formID : pFormID,
			orgCompanyID : orgCompanyID 
		},
		success: function(text) {
			result = text;
		}
	});
    
    return result;
}
