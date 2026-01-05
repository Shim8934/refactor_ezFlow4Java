var selectcabinet_cross_dialogArguments = new Array();
function btnSetTaskCode_onclick() {
    try {
        var para = new Array();
        para[0] = cabinetID;

        selectcabinet_cross_dialogArguments[0] = para;
        selectcabinet_cross_dialogArguments[1] = btnSetTaskCode_onclick_Complete;

        DivPopUpShow(1000, 625, "/ezApprovalG/selectCabinet.do?initFlag=1");
    } catch (e) {
        alert("btnSetTaskCode_onclick : " + e.description);
    }
}

function btnSetTaskCode_onclick_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        var g_SelCabXml = rtn[1];
        var xmlCab = createXmlDom();
        xmlCab = loadXMLString(g_SelCabXml);

        cabinetID = getNodeText(SelectNodes(xmlCab, "CABINETINFO/CABINET/CABINETID")[0]);
        TaskCode = getNodeText(SelectNodes(xmlCab, "CABINETINFO/CABINET/TASKCODE")[0]);
    }
    TaskCode_Save();
}

/*2018-04-05 김은석 수정 건설공사 공개여부*/
// 마스터 머지후 setpublicflag2 만 타서 다시 살림 2018-08-17 강민수92
function setPublicFlag() {
  var fields = message.GetFieldsList();
  var field = message.GetListItem(fields, "publication");
  if (!field) return;

  var PublicType = pPublicityCode.substring(0, 1);
  var PublicLevel = pPublicityCode.substring(1, 9);
  var PublicText = "";

  if (pLimitRange != "")
      PublicText = " (" + pLimitRange + ")";

  if (PublicType == "1")
      PublicText = strLang82;
  else if (PublicType == "2")
      PublicText = strLang83 + getPublicLevel(PublicLevel);
  else if (PublicType == "3")
      PublicText = strLang84 + getPublicLevel(PublicLevel);
  else
      PublicText = " ";

  field.innerHTML = PublicText;
}
/*기존의 공개여부 함수 2018-04-04 김은석 수정*/
function setPublicFlag2() {
    if (!message.FieldExist("publication")) return;
    var PublicType = pPublicityYN.substring(0, 1);

    var PublicText = "";
    if (PublicType == "Y" || PublicType == "B")
        PublicText = strLang82;
    else if (PublicType == "N")
        PublicText = strLang84;
    else
        PublicText = " ";
    
    message.PutFieldText("publication", PublicText);
}

function GetDraftAprLineInfo(ret) {
    try {
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
        } else {
            xmlKuljea = ret[1];
            xmlReDraft = ret[5];
        }
        
        setAprLinesXML(xmlKuljea);

        if (xmlReDraft == "C") {
            ApplyDocCellInfo();
        } else if (xmlReDraft == "R") {
            ClearDocCellInfo();
        }

        var susinSN = "";
        if (pDraftFlag == "SUSIN" || pDocState == "011") {
            susinSN = pSusinSN;
        }
        
        xmldom = loadXMLString(xmlKuljea);
        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        count = objNodes.length;

        if (ext == "mht") {
	        fields = message.GetFieldsList();
	
	        for (i = 1; i < 20; i++) {
	            name = susinSN + "habyuisign" + i;
	            field = message.GetListItem(fields, name);
	
	            if (field) {
	                name = susinSN + "habyui" + i;
	                field = message.GetListItem(fields, name);
	
	                if (field) {
	                    field.textContent = " ";
	                }
	
	                fieldname = susinSN + "habyuisign" + i;
	                field = message.GetListItem(fields, fieldname);
	
	                if (field) {
	                    field.textContent = " ";
	                }
	
	                fieldname = susinSN + "habyuipositon" + i;
	                field = message.GetListItem(fields, fieldname);
	
	                if (field) {
	                    field.textContent = " ";
	                }
	
	                fieldname = susinSN + "habyuidate" + i;
	                field = message.GetListItem(fields, fieldname);
	
	                if (field) {
	                    field.textContent = " ";
	                }
	            }
	            else {
	                break;
	            }
	        }
	
	
	        field = message.GetListItem(fields, "refer");
	        if (field) field.textContent = "";
	
	        field = message.GetListItem(fields, "hgamsa");
	
	        if (field) field.textContent = "";
	        for (i = 1; i < fields.length; i++) {
	            field = message.GetListItem(fields, "gongram" + i);
	            if (field) field.textContent = "";
	        }
        } else if (ext == "hwp") {
        	   for (i = 1; i < 20; i++) {
                   name = susinSN + "habyuisign" + i;
                   if (message.FieldExist(name)) {
                       name = susinSN + "habyui" + i;
                       if (message.FieldExist(name)) {
                    	   message.PutFieldText(name, "");
                       }

                       name = susinSN + "habyuisign" + i;
                       if (message.FieldExist(name)) {
                    	   message.PutFieldText(name, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
                       }

                       name = susinSN + "habyuipositon" + i;
                       if (message.FieldExist(name)) {
                    	   message.PutFieldText(name, "");
                       }


                       name = susinSN + "habyuidate" + i;
                       if (message.FieldExist(name)) {
                    	   message.PutFieldText(name, "");
                       }
                   } else {
                       break;
                   }
               }

               if (message.FieldExist("refer")) {
            	   message.PutFieldText("refer", "");
               }


               if (message.FieldExist("hgamsa")) {
            	   message.PutFieldText("hgamsa", "");
               }

               for (i = 1; i < 20; i++) {
                   if (message.FieldExist("gongram" + i)) {
                	   message.PutFieldText("gongram" + i, "");
                   }
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

        if (isSplit == "Y") {
        	SplitSign(OrderType, OrderName, OrderDept, OrderStat, OrderJobtitle);
        }

        LastSignSN = OrderType.length;

        CurAprType = OrderType[1];
        if (OrderType.length > 2) {
        	NextAprType = OrderType[2];
        }

        for (i = 1; i < OrderType.length; i++) {
            if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) {
                LastSignSN = i;
                i = OrderType.length;
            } else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3) {
            	LastSignSN = i;
            }
        }

        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];
        
        if (ext == "mht") {
	        var field = message.GetListItem(fields, "lastKyuljikwee");
	        if (field) {
	        	field.textContent = lastKyuljiwee;
	        }
	
	        var field = message.GetListItem(fields, "lastKyulName");
	        if (field) {
	        	field.textContent = lastKyulName;
	        }
        } else if (ext == "hwp") {
        	if (message.FieldExist("lastKyuljikwee")) {
        		message.PutFieldText("lastKyuljikwee", lastKyuljiwee);
        	}

            if (message.FieldExist("lastKyulName")) {
            	message.PutFieldText("lastKyulName", lastKyulName);
            }
        }
        
        hapyuiCnt = 1;
        SignCnt = 1;
        referCnt = 1;
        gongramCnt = 1;

        var fieldname;
        var field;
        var refer = "";

        if (ext == "mht") {
	        for (i = 1; i < 10; i++) {
	            fieldname = susinSN + "jikwe" + i;
	            field = message.GetListItem(fields, fieldname);
	
	            if (field) {
	                field.textContent = " ";
	                fieldname = susinSN + "sign" + i;
	                field = message.GetListItem(fields, fieldname);
	                if (field) {
	                	field.textContent = " ";
	                }
	            } else {
	                break;
	            }
	        }
	
	        for (i = 1; i < 10; i++) {
	            fieldname = "hjkwe" + i;
	            field = message.GetListItem(fields, fieldname);
	
	            if (field) {
	                field.textContent = " ";
	            } else {
	                break;
	            }
	        }
        } else if (ext == "hwp") {
        	
        }

        var idx = 1;
        var hidx = 1;
        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) {
                fieldname = susinSN + "jikwe" + idx;
                if (ext == "mht") {
	                field = message.GetListItem(fields, fieldname);
	
	                if (field) {
	                    var jikweName = trim(field.textContent);
	                    if (jikweName.substring(0, 1) != strLang128) {
	                    	field.textContent = OrderJobtitle[i];
	                    }
	
	                    if (OrderSuggester[i] == "Y") {
	                    	field.textContent = strLang75 + field.textContent;
	                    }
	
	                    if (OrderReporter[i] == "Y") {
	                    	field.textContent = strLang76 + field.textContent;
	                    }
	                }
	
	                fieldname = susinSN + "sign" + idx;
	                field = message.GetListItem(fields, fieldname);
	
	                if (field) {
	                }
                } else if (ext == "hwp") {
                	if (message.FieldExist(fieldname)) {
                        var jikweName = trim(message.GetFieldText(fieldname));
                        if (jikweName.substring(0, 1) != "" + strLang128 + "") {
                        	message.PutFieldText(fieldname, OrderJobtitle[i]);
                        }

                        if (OrderSuggester[i] == "Y") {
                        	message.PutFieldText(fieldname, strLang75 + message.GetFieldText(fieldname));
                        }

                        if (OrderReporter[i] == "Y") {
                        	message.PutFieldText(fieldname, strLang76 + message.GetFieldText(fieldname));
                        }
                    }
                }
                idx = idx + 1;
            } else if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
                fieldname = susinSN + "habyui" + hidx;
                if (ext == "mht") {
	                field = message.GetListItem(fields, fieldname);
	                if (field) {
	                    field.textContent = OrderDept[i];
	                }
	
	                fieldname = susinSN + "habyuipositon" + hidx;
	                field = message.GetListItem(fields, fieldname);
	                if (field) {
	                    var jikweName = trim(field.textContent);
	
	                    if (OrderSuggester[i] == "Y")
	                        field.textContent = strLang75 + field.textContent;

	                    if (OrderReporter[i] == "Y")
	                        field.textContent = strLang76 + field.textContent;
	                }
                } else if (ext == "hwp") {
                	if (message.FieldExist(fieldname))
                        message.PutFieldText(fieldname, OrderDept[i]);

                    fieldname = susinSN + "habyuipositon" + hidx;
                    if (message.FieldExist(fieldname)) {
                        var jikweName = trim(message.GetFieldText(fieldname));
                        if (jikweName.substring(0, 1) != "" + strLang128 + "") {
                        	message.PutFieldText(fieldname, OrderJobtitle[i]);
                        }

                        if (OrderSuggester[i] == "Y") {
                        	message.PutFieldText(fieldname, strLang75 + message.GetFieldText(fieldname));
                        }

                        if (OrderReporter[i] == "Y") {
                        	message.PutFieldText(fieldname, strLang76 + message.GetFieldText(fieldname));
                        }
                    }
                }
                hidx = hidx + 1;
            }
        }

        if (ext == "mht") {
	        if (message.GetListItem(fields, "lineapr")) {
	            if (idx > 5) {
	                message.GetListItem(fields, "lineapr").style.display = "";
	                for (i = 0; i < message.GetListItem(fields, "lineapr").children.length; i++) {
	                	message.GetListItem(fields, "lineapr").children[i].style.display = "";
	                }
	            } else {
	                message.GetListItem(fields, "lineapr").style.display = "none";
	                for (i = 0; i < message.GetListItem(fields, "lineapr").children.length; i++) {
	                	message.GetListItem(fields, "lineapr").children[i].style.display = "none";
	                }
	            }
	        }
	
	        if (message.GetListItem(fields, "linehab")) {
	            if (hidx > 5) {
	                message.GetListItem(fields, "linehab").style.display = "";
	                for (i = 0; i < message.GetListItem(fields, "linehab").children.length; i++) {
	                	message.GetListItem(fields, "linehab").children[i].style.display = "";
	                }
	            } else {
	                message.GetListItem(fields, "linehab").style.display = "none";
	                for (i = 0; i < message.GetListItem(fields, "linehab").children.length; i++) {
	                	message.GetListItem(fields, "linehab").children[i].style.display = "none";
	                }
	            }
	        }
        }
    } catch (e) {
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

        if (ret[5] == undefined) {
            TempsaveAprlineinfo = ret[0];
            xmlKuljea = ret[0];
        } else {
            TempsaveAprlineinfo = ret[1];
            xmlKuljea = ret[1];
        }

	    setAprLinesXML(xmlKuljea);

        xmlReDraft = "R";
        ClearDocCellInfo(ret);

        xmldom = loadXMLString(xmlKuljea);

        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        count = objNodes.length;

        for(i=1;i<60;i++)
        {
            name = "habyuidate" + i;
            if (message.FieldExist(name))
            {
                putText(["habyui", "habyuipositon", "habyuidate", "habyuija"], "", i);

                name = "habyuisign" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
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

            OrderType[KyljeaOrder] = KyljeaType;
            OrderTypeName[KyljeaOrder] = KyljeaTypeName;
            OrderName[KyljeaOrder] = KyljeaName;
            OrderDept[KyljeaOrder] = KyljeaDeptName;
            OrderStat[KyljeaOrder] = KyljeaStat;
            OrderStatName[KyljeaOrder] = KyljeaStatName;
            OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
            OrderReason[KyljeaOrder] = ReasonDoNotApprov;
        }

        LastSignSN = OrderType.length;

        for (i = 1; i < OrderType.length; i++) {
            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40){
                LastSignSN = i;
            }
        }

        if (OrderType[1] == strLangAprType4) {
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
                    if (OrderName[i] == arr_userinfo[2] && i == 1) IsSkipDrafter = "TRUE";
                    break;

                case strLangS51:
                    fieldname = "habyuisign" + hapyuiCnt;
                    if (message.FieldExist(fieldname) && !message.FieldExist("habyuija" + hapyuiCnt))
                        message.PutFieldText(fieldname, habyuisign);

                    fieldname = "habyuipositon" + hapyuiCnt;
                    putText([fieldName], OrderJobtitle[i], "");

                    fieldname = "habyuiapprodept" + hapyuiCnt;
                    putText([fieldName], OrderDept[i], "");

                case strAprType8:
                    fieldname = "habyui" + hapyuiCnt;
                    putText([fieldName], OrderDept[i], "");

                    if(OrderType[i] == strAprType8)
                        IsSkipDrafter = "FALSE";

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

                case strLangS6:
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
        var Flag = "";
        if (pDraftFlag == "SUSIN" || pDocState == strDocState11) {
            susinSN = pSusinSN;
            Flag = susinSN + "Recv";
        }

        for (i = 1; i <= 20; i++) {
            fieldname = susinSN + "jikwe" + i;
            var cnt = putText([fieldname], "", i);
            if(cnt == 0)
                break;
        }

        for (i = 1; i < 20; i++) {
            fieldname = "hjkwe" + i;
            var cnt = putText([fieldname], "", i);
            if(cnt == 0)
                break;
        }

        for (i = 1; i < 20; i++) {
            fieldname = susinSN + "seumyungdate" + i;
            var cnt = putText([fieldname], "", i);
            if(cnt == 0)
                break;
        }

        for (i = 1; i < 20; i++) {
            fieldname = susinSN + "approdept" + i;
            var cnt = putText([fieldname], "", i);
            if(cnt == 0)
                break;
        }

        var idx = 1;
        var hidx = 1;

        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40) {
                if (LastSignSN == 1 || LastSignSN == i) {
                    var cnt = 20;
                    for (k = 1; k <= cnt; k++) {
                        if (pDraftFlag == "SUSIN") signID = susinSN + "sign" + k;
                        else signID = "sign" + k;

                        if (message.FieldExist(signID)) {
                            LastSignNo = k;
                        }
                    }
                    idx = LastSignNo;
                }
                var j, chkflag

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
                        putText([fieldname], OrderJobtitle[i], "");

                        fieldname = susinSN + "sign" + idx;
                        putText([fieldname], OrderName[i] + "\r" + OrderReason[i], "");

                        fieldname = susinSN + "approdept" + idx;
                        putText([fieldname], OrderDept[i], "");

                        idx++;
                        continue;
                    }
        		}
                fieldname = susinSN + "jikwe" + idx;
                putText([fieldname], OrderJobtitle[i], "");

                fieldname = susinSN + "sign" + idx;
                if (message.FieldExist(fieldname)) {
                    /* 2020-07-24 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
                	// 서명필드만 존재
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

                fieldname = susinSN + "seumyung" + idx;
                putText([fieldname], OrderName[i], "");

                fieldname = susinSN + "approdept" + idx;
                putText([fieldname], OrderDept[i], "");

                idx++; // 서명칸이 존재하는 경우, idx를 1 증가시켜서 다음 칸을 찾는다.
            }

            if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {

                fieldname = "hjikwe" + hidx;
                var hjikweCnt = putText([fieldname], OrderJobtitle[i], "");
                if(hjikweCnt > 0) hidx++;
            }
        }
        if (isSplit == "Y")
            setSignSlash("sign", susinSN);
    } catch (e) {
        alert("SGetDraftAprLineInfo(ret)" + e.description);
    }
}

function putText(fieldList, text, index){
    var cnt = 0;
    for(var i = 0; i < fieldList.length; i++){
        if(message.FieldExist(fieldList[i] + index)){
            message.PutFieldText(fieldList[i] + index, text);
            cnt++;
        }
    }
    return cnt;
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
            if (fieldvalue == "") {
                set.SetItem("DiagonalType", 1);
                set.SetItem("SlashFlag", 0x02);
            }
            /* 2020-07-24 홍승비 - 전자결재 일반버전의 경우, 서명과 결재자명 필드 구분하도록 수정 */
            else if (fieldvalue == "[NOSLASH]") {
                set.SetItem("SlashFlag", 0x00);
            	message.PutFieldText(fieldName, "");
            }else
                set.SetItem("SlashFlag", 0x00);
            act.Execute(set);
        }else{
            break;
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
        if (pDraftFlag == "SUSIN" || pDocState == "011") {
        	susunSN = pSusinSN;
        }
        
    	for(i = 1; i <= SignCount ; i++) {
    		fieldname = susunSN + "sign" + i;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
    		}
    				  		
    		fieldname = susunSN + "seumyung" + i;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, "");
    		}
    				  		
    		fieldname = susunSN + "seumyungdate" + i;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, "");
    		}
    			    
    		fieldname = susunSN + "jikwe" + i;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, "");
    		}
    		
            // 부서 출력
            fieldname = susunSN + "approdept" + i;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, "");
    		}        		
    	}

        for(j = 1 ; j <= hapyuiCount ; j++) {
    		fieldname = susunSN + "habyui" + j;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, "");
    		}
    		    
    		fieldname = susunSN + "habyuipositon" + j;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, "");
    		}
    		
    	  	fieldname =  susunSN + "habyuidate" + j;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, "");
    		}
          
    		fieldname = susunSN + "habyuisign" + j;
    		if (message.FieldExist(fieldname)) {
    			message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
    		}
        }
    } catch (e) {
        alert("ClearDocCellInfo : " + e);
    }
}


function setClearSusinCellInfo() {
    try {
        var fields = message.GetFieldsList();
        var fieldname;

        fieldname = "recipient";
        field = message.GetListItem(fields, fieldname);
        if (field)
            field.textContent = " ";

        fieldname = "recipients";
        field = message.GetListItem(fields, fieldname);
        if (field)
            field.textContent = " ";

    } catch (e) {
        alert("setClearSusinCellInfo : " + e.description);
    }
}

function ApplyDocCellInfo() {
    try {
        var i;
        var j;
        var k;
        var fieldname;
        var fieldvalue;

        if (ext == "mht") {
	        var fields = message.GetFieldsList();
	
	        for (j = 1 ; j <= hapyuiCount ; j++) {
	            fieldname = "habyuidate" + j;
	            field = message.GetListItem(fields, fieldname);
	            if (field) {
	                fieldvalue = field.textContent;
	                fieldvalue = trim_Cross(fieldvalue);
	                if (fieldvalue == "") {
	                    fieldname = "habyui" + j;
	                    field = message.GetListItem(fields, fieldname);
	                    if (field)
	                        field.textContent = "";
	                }
	            }
	        }
        } else if (ext == "hwp") {
        	for(j = 1 ; j <= hapyuiCount ; j++) {
        		fieldname = "habyuidate" + j;
        		if (message.FieldExist(fieldname)) {
        			fieldvalue = message.GetFieldText(fieldname);
        			fieldvalue = trim(fieldvalue);
        		    
        		  	if(fieldvalue == "") {
        		  		fieldname = "habyui" + j;
        				if (message.FieldExist(fieldname)) {
        					message.PutFieldText(fieldname, "");
        				}
        			}
        		} 
        	}
        }
    } catch (e) {
        alert("ApplyDocCellInfo : " + e.description);
    }
}

function SendDraftMappingSign(ret) {
    try {
        var fields = message.GetFieldsList();
        var field;
        var psigncell;
        var pseumyungcell;
        var pseumyungdatecell;
        var papprodeptcell;
        var signInfo = new Array();
        var signCnt;
        var sn = 1;

        var OpinionText = "";
        var PositionText = "";

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
                sn = LastSignNo;
            } else if (DraftLastFlag) {
                putJunkyulSign("sign" + sn);
                for (i = 1; i < 20; i++) {
                    if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
                    else signID = "sign" + i

                    field = message.GetListItem(fields, signID)
                    if (field) {
                        LastSignNo = i;
                    }
                }
                sn = LastSignNo;
            }
        } else {
        	if (LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16) 
        	{
        		OpinionText = getSignDate() + "<br>";
        	}
        }
        
        signCnt = 0;
        if (pDraftFlag == "SUSIN" || pDocState == "011") {
            psigncell = pSusinSN + "sign" + sn;
            pseumyungcell = pSusinSN + "jikwe" + sn;
            pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
            papprodeptcell = pSusinSN + "approdept" + sn;
        } else {
            psigncell = "sign" + sn;
            pseumyungcell = "jikwe" + sn;
            pseumyungdatecell = "seumyungdate" + sn;
            papprodeptcell = "approdept" + sn;
        }
        
        var RtnVal = getGyulJeDate();
        var CurrentDate = RtnVal.split(".");
        var s = CurrentDate[1] + "." + CurrentDate[2];

        var field = message.GetListItem(fields, psigncell);
        var signWidth = 50;
        var signHeight = 50;
        
        var field = message.GetListItem(fields, pseumyungdatecell);
        
        if (field) {
            setNodeText(field , s);
            
            /* 2023-10-06 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
    		signInfo[signCnt] = pseumyungdatecell;
    		SignName[signCnt] = pseumyungdatecell;
    		SignType[signCnt] = "TEXT";
    		SignContent[signCnt] = s;
    		signCnt = signCnt + 1;
        } else {  
	        signWidth = 50;
	        signHeight = 28;
        }
        
        // 결재칸에 부서 추가
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
       
        var strimg;
        var SingFlag = true;
        var DekyulFlag = false;

        var field = message.GetListItem(fields, pseumyungcell);
        if (field) {
            setNodeText(field , getNodeText(field) + PositionText);
        }

        if (CurAprType == strAprType16) {
            var field = message.GetListItem(fields, psigncell);
            if (field) {
                if (ret != "NAME") {
                    strimg = "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                    
                    if (message.GetListItem(fields, pseumyungdatecell)) {
                    	signHeight = 28;
                    }
                   
                    if (signImageType == "NAME") {
                    	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>" + "<br>" + arr_userinfo[2];
                    } else {
                    	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";
                    }
                    
                    // 대결 시 서명일자칸 없으면 날짜 표시
					if (!message.GetListItem(fields, pseumyungdatecell)) {
						 field.innerHTML  = strLang7 + OpinionText + strimg;
					} else {
						 field.innerHTML  = strLang7 + strimg;
					}
					
					if (signImageType == "NAME") {
						OpinionText = OpinionText + "::" + arr_userinfo[2];
			        }
			        
                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "IMAGE";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = ret + "::" + strLang7 + OpinionText;
                    //message.BodySetAttribute(psigncell, escape(ret));
                    signCnt = signCnt + 1;
                    SingFlag = true;
                    rtnSignInfo.push(psigncell);
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
                    rtnSignInfo.push(psigncell);
                }
            }
            DekyulFlag = true;
            sn = sn + 1;
            if (pDraftFlag == "SUSIN" || pDocState == "011") {
                psigncell = pSusinSN + "sign" + sn;
                pseumyungcell = pSusinSN + "jikwe" + sn;
                pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
            } else {
                psigncell = "sign" + sn;
                pseumyungcell = "jikwe" + sn;
                pseumyungdatecell = "seumyungdate" + sn;
            }
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
                rtnSignInfo.push(psigncell);
            }
        }
        else if (DekyulFlag) {
        }
        else {
            var field = message.GetListItem(fields, psigncell);
            if (field) {
                
                if (ret != "NAME") {
                    strimg = "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                    if (signImageType == "NAME") {
                    	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>" + "<br>" + arr_userinfo[2];
                    } else {
                    	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";
                    }
                    
                    if (message.GetListItem(fields, pseumyungdatecell)) {
                        OpinionText = "";
					}
					
                    if (CurAprType == strAprType4) {
                        OpinionText = strLangAprType4 + OpinionText;
					}
					
                    field.innerHTML = OpinionText + strimg;
                    
                    if (signImageType == "NAME") {
            			OpinionText = OpinionText + "::" + arr_userinfo[2];
                    }
                    
                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "IMAGE";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = ret + "::" + OpinionText;
                    //message.BodySetAttribute(psigncell, escape(ret));
                    signCnt = signCnt + 1;
                    SingFlag = true;
                    rtnSignInfo.push(psigncell);
                }
                else {
                    if (field) {
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                        
                        if (message.GetListItem(fields, pseumyungdatecell))
                            OpinionText = "";
                        
                        if (CurAprType == strAprType4)
                            OpinionText = strLangAprType4 + OpinionText;
                        field.innerHTML = OpinionText + strimg;
                        signInfo[signCnt] = psigncell;
                        SignType[signCnt] = "HTML";
                        SignName[signCnt] = psigncell;
                        SignContent[signCnt] = OpinionText + strimg;
                        signCnt = signCnt + 1;
                        SingFlag = false;
                        rtnSignInfo.push(psigncell);
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
        if (ext == "mht") {
	        var fields = message.GetFieldsList();
	        var field;
	
	        if (signInfo) {
	            for (cnt = 0; cnt < signInfo.length; cnt++) {
	                field = message.GetListItem(fields, signInfo[cnt]);
	                if (field)
	                	setNodeText(field, " ");
	            }
	        }
        } else if (ext == "hwp"){
        	if(signInfo) {
        		for(cnt=0; cnt < signInfo.length; cnt++) {
        			if (message.FieldExist(signInfo[cnt])) {
        				message.PutFieldText(signInfo[cnt], "");
        			}
        		}
        	}
        }
    } catch (e) {
        alert("UndoSignInfo : " + e.description);
    }
}

function getDraftInfo() {
    try {
        pFormHref = FormHref;
        pDraftFlag = DraftFlag;
        pDocType = DocType;

        //수발신SN
        pSusinSN = SusinSN;
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
        else {
            pDocState = DocState;
            pDocState = ConvertDocState(pDocState);
        }
        pCurSelRow = CurSelRow;

    } catch (e) {
        alert("getDraftInfo : " + e.description);
    }
}

function ConvertDocType(pDocType) {
    var xmlhttp = createXMLHttpRequest();
    var RtnValxml = createXmlDom();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "CODE1", "A01");
    createNodeAndInsertText(xmlpara, objNode, "CODE2", pDocType);
    createNodeAndInsertText(xmlpara, objNode, "FLAG", "CODE");

    xmlhttp.open("Post", "../aspx/getCodeData.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}

function ConvertDocState(pDocState) {
    var xmlhttp = createXMLHttpRequest();
    var RtnValxml = createXmlDom();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "CODE1", "A02");
    createNodeAndInsertText(xmlpara, objNode, "CODE2", pDocType);
    createNodeAndInsertText(xmlpara, objNode, "FLAG", "CODE");

    xmlhttp.open("Post", "../aspx/getCodeData.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}

function SetBtnStateFalse() {
    try {
        setMenuBar("btnSetAprLine", false);
        setMenuBar("btnSendDraft", false);
        setMenuBar("btnOpinion", false);
    } catch (e) {
        alert("SetBtnStateFalse : " + e.description);
    }
}

function SetBtnStateTrue() {
    try {
        setMenuBar("btnSetAprLine", true);
        setMenuBar("btnOpinion", true);
        setMenuBar("btnPrint", true);
        btnClose.Enable = "true";
    } catch (e) {
        alert("SetBtnStateTrue : " + e.description);
    }
}

function createNewDoc() {
    try {
        var NewDocID;
        var objRoot;
        var objNode;

        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, PARAMETER, "FormID", pFormID);

        xmlhttp.open("POST", "../aspx/createnewdoc.aspx", false);
        xmlhttp.send(xmlpara);

        if (xmlhttp.responseText == "False") {
            var pAlertContent = strLang131 + "<br> " + strLang132;
            OpenAlertUI(pAlertContent);
        } else {
            return xmlhttp.responseText;
        }
    } catch (e) {
        alert("createNewDoc : " + e.description);
    }
}

function getDraftUserInfo() {
    try {
    	var result = "";
    	
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
    			result = xml;
    		}        			
    	});
    	
        xmluserInfo = loadXMLString(result);

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
        objNodes = GetChildNodes(xmluserInfo.documentElement);

        
        CurrentDate = getGyulJeDate();
        SignInfo = "";
        hapyuiCount = 0;
        SignCount = 0;

        for (i = 0; i < fields.length; i++) {
            var field = fields[i];
            if (!fields) return;

            if (pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
                switch (field.id) {
                    case "enforcedate":
                        break;
                    case "recipient":
                        break;
                    case "refer":
                        break;
                    case "zipcode":
                        field.textContent = getNodeText(objNodes[7]);
                        break;
                    case "address":
                        field.textContent = getNodeText(objNodes[6]);
                        break;
                    case "telephone":
                        field.textContent = getNodeText(objNodes[5]);
                        break;
                    case "fax":
                        field.textContent = getNodeText(objNodes[5]);
                        break;
                    case "department":
                        field.textContent = getNodeText(objNodes[2]);
                        break;
                    case "parantdept":
                        field.textContent = getNodeText(objNodes[3]);
                        break;
                    case "seniorposition":
                        break;
                    case "seniorname":
                        break;
                    case "charge":
                        field.textContent = getNodeText(objNodes[0]);
                        break;
                    case "position":
                        field.textContent = arr_userinfo[3];
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
                        field.textContent = getNodeText(objNodes[3]);
                        break;
                    case "deptname":
                        field.textContent = arr_userinfo[5];
                        break;
                    case "seal":
                        field.textContent = getNodeText(objNodes[3]) + strLang157;
                        break;
                    case "username":         
                        field.textContent = arr_userinfo[2];
                        break;
                    case "draftername":      
                        field.textContent = arr_userinfo[2];
                        break;
                    case "draftdate":
                        field.textContent = CurrentDate;
                        break;
                    case "receiptdate":
                        field.textContent = CurrentDate;
                        break;
                }
            }
            else {
                switch (field.id) {
                    case "receiptdate":
                        field.textContent = CurrentDate;
                        break;
                    case pSusinSN + "receiptdate":
                        field.textContent = CurrentDate;
                        break;
                    case "susinhide":
                        field.style.display = 'none';
                        break;
                    case "susinhideP":
                        field.style.display = 'none';
                        break;
                    case "susinbody":
                        field.style.display = '';
                        setMenuBar("btnEdit", true);
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

            var pSignSusin = pSusinSN + "habyuisign";
            if (field.id.substr(0, 11) == pSignSusin) {
                hapyuiCount = hapyuiCount + 1;
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
            }
            else {
                if (field.id.substr(0, 5) == "jikwe") {
                    if (SignInfoFlag) {
                        SignInfo = field.textContent;
                        SignInfoFlag = false;
                    }
                    else {
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
            } else {
                pSuSinFlag = "N";
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
            btnSetReceivLine.style.display = "";
        }

        RtnVal = message.GetListItem(fields, "refer");
        if (RtnVal != null) {
            pChamJoFlag = "Y";
        } else {
            pChamJoFlag = "N";
        }

        pChamJoFlag = "Y";

    } catch (e) {
        alert("SetAutoPropertyValue : " + e.description);
    }
}

function openReceivUI() {
    var parameter = new Array();

    isExtDoc = message.CKEDITOR.instances.editor1.document.$.body.getAttribute("EXTDOC", 0);
    if (isExtDoc != "Y") isExtDoc = "N";

    parameter[0] = pFormID;
    parameter[1] = pDocID;
    parameter[2] = "SEND";
    parameter[3] = isExtDoc;

    var url = "../ezAPRDEPT/AprDept1_Cross.aspx";
    var feature = "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
    var ret = window.showModalDialog(url, parameter, feature);

    return ret;
}

function setRecevInfo(ret) {
    setDeptLinesXML(ret);

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


    var rows = GetChildNodes(xmldom.documentElement);

    if (rows.length == 0) return;

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
        	if (approvalFlag == "G") {
        		precipent = strLang92;
        	} else {
        		precipent = strLangS68;
        	}

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
        apropinion_cross_dialogArguments[0] = parameter;
        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;

        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
    } catch (e) {
        alert("openOpinionUI : " + e.description);
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
        }
    } else if (ret != "Clear") {
    	pHasOpinionYN = "N";
    }
}

function openOpinionUI_New(pOpinionType, CompleteFunction) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = pDraftFlag;	//DRAFTFLAG
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
	        //makeOpinionList(objXML);
		}
	} catch (e) {
		alert("openOpinionUI_New_Complete ::: " + e.description);
	}
}

function openFileAttachUI() {
	try {
		var url = "/ezApprovalG/aprAttach.do?formID=" + pFormID + "&docID=" + pDocID + "&draftFlag=" + pDraftFlag + "&orgCompanyID=" + orgCompanyID + "&ext=" + "hwp";
		DivPopUpShow(800, 610, url);
    } catch (e) {
        alert("openFileAttachUI : " + e.description);
    }
}

function SaveDraftDocInfo() {
    var rtnVal;
	
    // 수정(2008.06.12) : 결재문서 파일 저장 시 임시파일 생성 후 파일크기를 체크하여 원본 파일로 복사하도록 루틴 수정
    rtnVal = SaveFile();
    if (rtnVal != "TRUE")
    {
        return rtnVal;
    }
    SignSave();

    rtnVal = SaveDraftDocInfo_susin();
    return rtnVal;
}

function SaveDraftDocInfo_susin() {
    try {
        if (pDocNumCode == "")
            return "FLASE";

        var fields = message.GetFieldsList();
        var field;
        var objRoot;
        var objNode;
        var field;

        var objNodes = GetChildNodes(xmldoc.documentElement);

        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var xmlRtn = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DOCID", getNodeText(objNodes[0]));
        createNodeAndInsertText(xmlpara, objNode, "FORMID", getNodeText(objNodes[1]));
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", getNodeText(objNodes[2]));
        createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", getNodeText(objNodes[3]));
        
        createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", getNodeText(objNodes[4]));
        createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", strAprState2);
        createNodeAndInsertText(xmlpara, objNode, "HREF", getNodeText(objNodes[6]));        
        
        createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", message.GetDocTitle());
        if (approvalFlag == 'G') {
        	createNodeAndInsertText(xmlpara, objNode, "DOCNO", pDocNo);
        } else {
            var fieldname = "docnumber";
            field = message.GetListItem(fields, fieldname);
        	createNodeAndInsertText(xmlpara, objNode, "DOCNO",  field.textContent);
        }
        createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", "");
        createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WRITERID", getNodeText(objNodes[13]));
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", getNodeText(objNodes[14]));
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", getNodeText(objNodes[15]));
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", getNodeText(objNodes[16]));
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", getNodeText(objNodes[17]));
        
        createNodeAndInsertText(xmlpara, objNode, "HTML", message.Get_EditorBodyHTML());
        createNodeAndInsertText(xmlpara, objNode, "ORGHTML", pOrgHtml);
        createNodeAndInsertText(xmlpara, objNode, "PUSERID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[2]);
        createNodeAndInsertText(xmlpara, objNode, "PDEPTID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "PUBLIC", "");

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
        
        /*
         * 수발신담당자 접수 > 원단위부서코드와 단위부서코드의 값이 같은 경우
         * 
         * pOrgDocNumdeCode는 처음 수신한 수발신부서의 단위번호코드이다.
         * pDocNumCode의 값은 수발신담당자가 배부를 하였을 경우 
         * 배부된 부서의 단위번호코드가 지정됨
         */
        if(!pDocNumCode) {
        	pDocNumCode = pOrgDocNumCode;
        }
        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", pDocNumCode);
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", pOrgDocNumCode);
        
        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");

        if (!g_SepAttachLVXml)
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));

        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);
        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", getNodeText(objNodes[38]));
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", getNodeText(objNodes[39]));
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", getNodeText(objNodes[40]));
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);

        if (curDocNum != "") {
          	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
          } else {
          	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
          }
        
        createNodeAndInsertText(xmlpara, objNode, "PASSAPRLINE", passAprLine);
        
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
    		createNodeAndInsertText(xmlpara, objNode, "NONELECREC_CABINETID", cabinetID);
    		
    		// 시청각 기록물일경우
    		if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "5" || SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "6") {
    			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECINFO", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "AUDIOVISUALRECINFO"));
    			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECSUMMARY", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SUMMARY"));
    		}
    		
    		// 분리첨부가 존재할 경우
    		if (SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/LISTVIEWDATA/ROWS/ROW").length > 0) {
    			var sepAtt, Data, i;
    			var rtnXml = createXmlDom();
    	        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
    			var sepLVXml = createXmlDom();
                	sepLVXml = loadXMLString(nonElecRecInfoXml);
                var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/LISTVIEWDATA/ROWS/ROW");
                
                for (i = 0; i < rows.length; i++) {
                    sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(rows[i].childNodes[0],"DATA1"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", SelectSingleNodeValue(rows[i].childNodes[1], "VALUE"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(rows[i].childNodes[4], "VALUE"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", SelectSingleNodeValue(rows[i].childNodes[0], "DATA2"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", SelectSingleNodeValue(rows[i].childNodes[6], "VALUE"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", SelectSingleNodeValue(rows[i].childNodes[0], "DATA3"));
                }
                createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SEPERATEATTACH", getXmlString(rtnXml));
    		}
    		
    		// 특수목록이 존재하는 기록물 철 일경우
    		if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SPECIALCATALOGFLAG") == "1") {
    			if (SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/SCDATA").length > 0) {
	    			var sepAtt, Data, i;
	    			var rtnXml = createXmlDom();
	    			var root = createNodeInsert(rtnXml, root, "SPECIALCATALOGINFO");
	    			var sepLVXml = createXmlDom();
	    				sepLVXml = loadXMLString(nonElecRecInfoXml);
	    			var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/SCDATA");
	    			var rows2 = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/SCNAME");
	    			
	    			sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SCNAME");
	    			Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST1", SelectSingleNodeValue(rows2[0], "LIST1"));
	                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST2", SelectSingleNodeValue(rows2[0], "LIST2"));
	                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST3", SelectSingleNodeValue(rows2[0], "LIST3"));
	    			
	    			for (i = 0; i < rows.length; i++) {
	    				sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SCDATA");
	                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SN", SelectSingleNodeValue(rows[i], "SN"));
	                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST1", SelectSingleNodeValue(rows[i], "LIST1"));
	                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST2", SelectSingleNodeValue(rows[i], "LIST2"));
	                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST3", SelectSingleNodeValue(rows[i], "LIST3"));
	    			}
	    			
	    			createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SPECIALCATALOGINFO", getXmlString(rtnXml));
    			}
    		}
    	}
        
        xmlhttp.open("POST", "/ezApprovalG/doDraft.do", false);
        xmlhttp.send(xmlpara);

        if (xmlhttp != null && xmlhttp.readyState == 4) {
        	 if (xmlhttp.status == 200) {
        		 if (nonElecRec == "Y") {
        			 nonElecRecTempCabSwitch(nonElecRecInfoXml);
        		 }
        		  SetBtnStateFalse();
        	      var dataNodes = GetChildNodes(xmlhttp.responseXML);
        	      return getNodeText(dataNodes[0]);
        	 } else {
        		return "FALSE";
        	 }
      }
    } catch (e) {
        alert("SaveDraftDocInfo_susin : " + e.description);
    }
}

var inssepattach_cross_dialogArguments = new Array();
function btnAddSepAttach_onclick() {
	var deptCheckFlag = checkDeptAndCabinetId();
	
	if (deptCheckFlag == "3") {
		alert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		return;
	} else if (deptCheckFlag == "4") {
		alert(strLanggarm06 + " '" + "'" + strLanggarm08);
		return;
	} else if (deptCheckFlag == "2" && upperDeptCode == "") {
		alert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
		return;
	}
	
    if (cabinetID == "") {
        var pAlertContent = strLang731;
        OpenAlertUI(pAlertContent);
        return;
    }

    var g_SepAttachLVXml = "";
    g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
    
    if (!g_SepAttachLVXml)
        g_SepAttachLVXml = "";
    
    var para = new Array();
    para[0] = g_SepAttachLVXml;
    para[1] = cabinetID;
    para[2] = "1";
    para[3] = ext;

    inssepattach_cross_dialogArguments[0] = para;
    inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;

    DivPopUpShow(920, 630, "/ezApprovalG/insSepAttach.do");
}

function btnAddSepAttach_onclick_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        g_SepAttachLVXml = rtn[1];
        message.DocumentBodySetAttribute("SepAttachLVXml", g_SepAttachLVXml);
    }
}
function GetSepAttParamXml(g_SepAttachLVXml) {
    var rtnXml = createXmlDom();

    var objRoot, objNode, subNode;
    objRoot = createNodeInsert(rtnXml, objRoot, "SEPATTACHINFO");

    var sepAtt, Data, i;
    if (g_SepAttachLVXml != "") {
        var sepLVXml = createXmlDom();
        sepLVXml = loadXMLString(g_SepAttachLVXml);

        var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");

        for (i = 0; i < rows.length; i++) {
            objNode = createNodeAndAppandNode(sepLVXml, objRoot, objNode, "SEPATTACH");
            createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "CABINETID", getNodeText(GetChildNodes(GetChildNodes(rows[i])[0])[1]));
            createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "TITLE", getNodeText(GetChildNodes(rows[i])[1]));
            createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "NUMOFPAGE", getNodeText(GetChildNodes(rows[i])[4]));
            createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "REGTYPE", getNodeText(GetChildNodes(GetChildNodes(rows[i])[0])[2]));
            createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "SUMMARY", getNodeText(GetChildNodes(rows[i])[6]));
            createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "AVTYPE", getNodeText(GetChildNodes(GetChildNodes(rows[i])[0])[3]));

        }
    }
    return getXmlString(rtnXml);
}

function SetSepAttParamXmlNull(g_SepAttachLVXml) {
    var sepAtt, Data, i;
    if (g_SepAttachLVXml != "") {
        var sepLVXml = createXmlDom();
        sepLVXml = loadXMLString(g_SepAttachLVXml);

        var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");

        for (i = 0; i < rows.length; i++) {
            setNodeText(rows.item(i).childNodes.item(0).childNodes.item(1), "")
            setNodeText(rows.item(i).childNodes.item(2).childNodes.item(0), "")
        }
        g_SepAttachLVXml = getXmlString(sepLVXml);
    }
    return g_SepAttachLVXml;
}

function CheckSepAttParamXmlNull(g_SepAttachLVXml) {
    var sepAtt, Data, i;
    var rtnVal = true;
    if (g_SepAttachLVXml != "") {
        var sepLVXml = createXmlDom();
        sepLVXml = loadXMLString(g_SepAttachLVXml);

        var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");

        for (i = 0; i < rows.length; i++) {
            if (getNodeText(rows[i].childNodes[0].getElementsByTagName("DATA1")[0]) == "")
                rtnVal = false;
        }
    }
    return rtnVal;
}

function getfieldValue(pfield) {
    var rtnVal = "";

    if (pfield) {

        switch (pfield.tagName) {
            case "TD":
                rtnVal = pfield.textContent;
                break;
            case "SELECT":
                rtnVal = pfield.value;
                break;
            case "INPUT":
                rtnVal = pfield.value;
                break;
        }
    }
    return rtnVal;
}
var aprsign1_cross_dialogArguments = new Array();
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
    			result = loadXMLString(xml);
    		}        			
    	});

        var SignNodeList;

        SignNodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");

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
        alert("openSignUI : " + e.description);
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
        parameter[11] = "";
        parameter[12] = "";
        parameter[13] = g_DraftFlag;

        var url = "/ezApprovalG/aprLine.do";
        var feature = "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";

        var ret = window.showModalDialog(url, parameter, feature);
        return ret;

    } catch (e) {
        alert("openAprLineUI : " + e.description);
    }
}


function GetAprDocFormID() {
    try {
    	var result = "";
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getDocData.do",
    		data : {
    			docID : pDocID,
    			mode  : "APR",
    			sel   : "FormID"
    		},
    		success: function(xml){
    			result = loadXMLString(xml);
    		}        			
    	});
        
        var dataNodes = GetChildNodes(result);
        pFormID = getNodeText(dataNodes[0]);

    } catch (e) {
        alert("GetAprDocFormID : " + e.description);
    }
}

function trim(parm_str) {
    return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
    str_temp = parm_str;
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
    str_temp = parm_str;
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
    	var result = "";
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getDate.do",
    		data : {
    			getDate : ""
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});

        return result;

    } catch (e) {
        alert("getGyulJeDate : " + e.description);
    }
}

function setSusinUpdataDocID() {
    try {
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
    			result = loadXMLString(xml);
    		}        			
    	});
        
        var dataNodes = GetChildNodes(result);
        
        return getNodeText(dataNodes[0]);

    } catch (e) {
        alert("setSusinUpdataDocID : " + e.description);
    }
}

function setSusinRollbackDocID() {
    var xhr = new XMLHttpRequest();
    xhr.open("get", "/ezApprovalG/setSusinRollbackDocID.do?beforeAprState=" + pAprState + "&docId=" + pDocID + "&orgDocId=" + pOrgDocID);
    xhr.send();
    
    xhr.onload = function() {
        var res = xhr.responseText;
        if (res !== "TRUE") {
            OpenAlertUI("오류가 발생했지만 접수정보를 되돌리는데 실패했습니다!");
        }
    }
}

// var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezCommon_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezCommon_cross_dialogArguments[1] = CompleteFunction;
        else
            ezCommon_cross_dialogArguments[1] = OpenAlertUI_Complete;
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

    var objNodes = GetChildNodes(result.documentElement);
    if (objNodes) {
        pOrgDocID = getNodeText(objNodes[2]);
        if (getNodeText(objNodes[10]) == "Y" || getNodeText(objNodes[10]) == "O")
            pHasOpinionYN = "Y";

        tempSecurity = getNodeText(objNodes[19]);
        tempKeep = getNodeText(objNodes[20]);
        tempUrgent = getNodeText(objNodes[21]);
        tempPublic = getNodeText(objNodes[18]);
        tempKeyword = getNodeText(objNodes[25]);
        tempItemCode = getNodeText(objNodes[23]);
        tempItemName = getNodeText(objNodes[24]);
        pSummery = getNodeText(objNodes[35]);
        pSpecialRecordCode = getNodeText(objNodes[26]);
        pPublicityCode = getNodeText(objNodes[27]);
        pLimitRange = getNodeText(objNodes[28]);
        pPageNum = getNodeText(objNodes[29]);
        pPublicityYN = getNodeText(objNodes[41]);
        
        if (approvalFlag == "G") {
        	cabinetID = "";
        	TaskCode = "";
        } else {
        	cabinetID = getNodeText(objNodes[30]);
        	TaskCode = getNodeText(objNodes[31]);
        }

        tempSecurityDate = getNodeText(objNodes[36]);

    }
}

function changeEditMode() {
    if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
    }
}

function HabyuiResultOpinion() {
    try {
        var parameter = new Array();
        var rtnVal = true

        parameter[0] = "";
        parameter[1] = "N";
        parameter[2] = KuyjeType;
        parameter[3] = pOrgDocID;

        var url = "/ezApprovalG/aprOpinion.do";
        var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
        feature = feature + GetShowModalPosition(530, 520);
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            var NodeList;
            var objXML = createXmlDom();

            objXML = loadXMLString(ret);
            NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0) {
                rtnVal = true;
            } else {
                rtnVal = true;
            }
        }
        return rtnVal;
    } catch (e) {
        alert("HabyuiResultOpinion : " + e.description);
    }
}

function getReceiveDocInfo() {
    try {
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
        var xmlpara = createXmlDom();
        pdocXML = SelectSingleNodeNew(result, "RECEIVEDATA/DOCINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("DOCINFO").dataSource = xmlpara;
        CONNINFO.XMLDocument = loadXMLString(xmlString);
        var node = GetElementsByTagName(xmlpara, "ORGDOCNUMCODE");
        pOrgDocNumCode = getNodeText(node[0]);
        if (pOrgDocNumCode == "") {
            var node = GetElementsByTagName(xmlpara, "DOCNUMCODE");
            pOrgDocNumCode = getNodeText(node[0]);
        }
        
        orgCompanyID = getNodeText(GetElementsByTagName(xmlpara, "ORGCOMPANYID")[0]);

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

        pWriterDeptID = getNodeText(GetElementsByTagName(result, "WRITERDEPTID")[0]);
        zFormID = getNodeText(GetElementsByTagName(result, "FORMID")[0]);

        pSusinSN = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
        pDocType = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
        pDocState = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
        pAprState = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
        pSusinDocURL = pFormHref;

        if (CrossYN()) {
            RECEIPTDEPTID.textContent = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
        } else {
            RECEIPTDEPTID.innerText = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
        }
        pOrgAttach = "";

        if (ext == "mht") {
        	 pRelayURL = getNodeText(GetElementsByTagName(result, "RELAY")[0]);
             pRelayURL2 = getNodeText(GetElementsByTagName(result, "RELAY2")[0]);
        } else if (ext == "hwp") {
        	 pRelayURL = getNodeText(GetElementsByTagName(result, "RELAY")[0]).replace("mht", "hwp");
             pRelayURL2 = getNodeText(GetElementsByTagName(result, "RELAY2")[0]).replace("mht", "hwp");
        }
    } catch (e) {
        alert("getReceiveDocInfo :: " + e.description);
    }
}

function setButtonReceiveTrue() {
    SetBtnStateFalse();
}

function document_oncontextmenu() {
    if (g_sendDraftFlag) {
        return false;
    } else {

        return true;
    }
}

function setHeSongDocInfo() {
    try {
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
    		success: function(xml){
    			result = loadXMLString(xml);
    		}, error: function() {
    			var pAlertContent = strLang740;
                OpenAlertUI(pAlertContent);
                return false;
    		}			
    	});

        var RtnVal = getNodeText(result.documentElement);

        if (RtnVal == "TRUE") {
        	   var pAlertContent = strLang741;
               OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
               
               //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가 - 회송
		        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {       	
					$.ajax({
						type : 'POST',
						dataType : 'json',
						async : true,
						url : '/ezAttitude/approvalGConn.do',
						data : {
							status : 'delete',
							docId : pOrgDocID,
							type : 'hesong'
						},
						success : function(result) {
						},
						error : function() {
						}
					});				
		        }
               
               return true;
        }
    }
    catch (e) {
        alert("setHeSongDocInfo :: " + e.description);
        return false;
    }
}

function OpenAlertUI_Close_Complete() {
    btnClose_onclick();
}

function setCabinetHeSong(pDocSN) {
    try {
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/setCabinetHesong.do",
    		data : {
    			docID : pDocID,
    			deptID  : arr_userinfo[4],
    			deptName : arr_userinfo[15],
    			deptName2 : arr_userinfo[16],
    			userName : arr_userinfo[11],
    			userName2 : arr_userinfo[12],
    			docSN     : pDocSN
    		},
    		success: function(xml){
    			result = xml;
    		}, error: function() {
                return false;
    		}			
    	});
        
        if (result == "TRUE")
            return true;
        else
            return false;
    }
    catch (e) {
        alert("setCabinetHeSong :: " + e.description);
        return false;
    }
}

function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;
        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;
            pleftpos = parseInt(width) - 725;
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - pleftpos;
            left = pleftpos / 2;
        } else {
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - 10;
        }

        var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left
        window.open(wfileLocation, "view", param);

    } catch (e) {
        alert("openwindow :: " + e.description);
    }
}
var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd() {
    var parameter = pUserID;

    ezchkpasswd_cross_dialogArguments[0] = parameter;
    ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

    DivPopUpShow(350, 225, "/ezApprovalG/ezchkPasswd.do");
}

function setFirstDrafter() {
    var ret = getAutoAprLine("");

    if (ret[0] != "NONE") {
    	if (approvalFlag == "S") {
    		SGetDraftAprLineInfo(ret);
    	} else {
    		GetDraftAprLineInfo(ret);
    	}
        btnSendDraft.Enable = "true";
        LastSignSN = 1;
    }

    return;
}

var aprcabinetattach_cross_dialogArguments = new Array();
function openAaprDocAttachUI() {
    try {
        var parameter = pDocID;
		var url = "/ezApprovalG/aprCabinetAttach.do?draftFlag=" + pDraftFlag;
	
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

function delDocInfo() {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

    xmlhttp.open("POST", "../aspx/UndoDocMust.aspx", false);
    xmlhttp.send(xmlpara);
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

var bbtnSetAprLine = "";
var bbtnSendDraft = "";
var bbtnOpinion = "";
var bbtnDistribute = "";
var bbtnReturn = "";
var bbtnEdit = "";
var bbtnRJunkyul = "";
var bbtnPrint = "";
var bbtnMail = "";

function chkBtnConfirm(para) {
    if (para == "1") {
        if (btnSetAprLine.style.display == "") {
            setMenuBar("btnSetAprLine", false);
            bbtnSetAprLine = "1";
        }

        if (btnSendDraft.style.display == "") {
            setMenuBar("btnSendDraft", false);
            bbtnSendDraft = "1";
        }

        if (btnOpinion.style.display == "") {
            setMenuBar("btnOpinion", false);
            bbtnOpinion = "1";
        }

        if (btnDistribute.style.display == "") {
            setMenuBar("btnDistribute", false);
            bbtnDistribute = "1";
        }

        if (btnReturn.style.display == "") {
            setMenuBar("btnReturn", false);
            bbtnReturn = "1";
        }

        if (btnEdit.style.display == "") {
            setMenuBar("btnEdit", false);
            bbtnEdit = "1";
        }

        if (btnRJunkyul.style.display == "") {
            setMenuBar("btnRJunkyul", false);
            bbtnRJunkyul = "1";
        }

        if (btnPrint.style.display == "") {
            setMenuBar("btnPrint", false);
            bbtnPrint = "1";
        }

        if (btnMail.style.display == "") {
            setMenuBar("btnMail", false);
            bbtnMail = "1";
        }
    }
    else {
        if (bbtnSetAprLine == "1")
            setMenuBar("btnSetAprLine", true);

        if (bbtnSendDraft == "1")
            setMenuBar("btnSendDraft", true);

        if (bbtnOpinion == "1")
            setMenuBar("btnOpinion", true);

        if (bbtnDistribute == "1")
            setMenuBar("btnDistribute", true);

        if (bbtnReturn == "1")
            setMenuBar("btnReturn", true);

        if (bbtnEdit == "1")
            setMenuBar("btnEdit", true);

        if (bbtnRJunkyul == "1")
            setMenuBar("btnRJunkyul", true);

        if (bbtnPrint == "1")
            setMenuBar("btnPrint", true);

        if (bbtnMail == "1")
            setMenuBar("btnMail", true);

    }
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
	
    GyulJeDate = result;
    
    return GyulJeDate;
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
    createNodeAndInsertText(xmlpara, objNode, "DocID", "002");

    xmlhttp.open("POST", "../ezAPROPINION/aspx/DeleteOpinionTypeInfo.aspx", false);
    xmlhttp.send(xmlpara);

    pHasOpinionYN = "";
    return xmlhttp.responseText;*/
}

//17.09.14:재배부 후 재배부의견을 제외한 모든의견 삭제
function delOpinionInfoAll2() {
	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/ezApprovalG/OpinionDel2.do",
		data : {
			docID : pDocID
		},
		success: function(result) {
		}
	});
}

//17.09.14:중계문서 접수 시 재배부의견은 삭제처리
function delOpinionInfoAll3() {
	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/ezApprovalG/OpinionDel3.do",
		data : {
			docID : pDocID
		},
		success: function(result) {
		}
	});
}

function SignCheck() {
    var objNodes = getNodeText(xmldoc.documentElement);
    var SignXML = createXmlDom();

	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getSignInfo.do",
		data : {
			docID : getNodeText(SelectSingleNodeNew(xmldoc, "DATA/ORGDOCID"))
		},
		success: function(xml){
			result = xml;
		}
	});
	
    if (result == "")
        return;
    
    result = loadXMLString(result);
    var NodeList;
    NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");
    if (NodeList.length <= 0)
        return;

    SignXML = result;

    return;
    var rtnVal = putSignXML(SignXML);

    if (rtnVal) {
        SaveFile();
    }
}

function putSignXML(SignXML) {
    var retVal = false;
    try {
        var NodeList;
        
        if (ext == "mht") {
        	 var fields = message.GetFieldsList();
             var field;

             NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
             if (NodeList.length > 0) {
                 for (i = 0; i < NodeList.length; i++) {
                     var SignType = getNodeText(GetChildNodes(NodeList[i])[2]);
                     var SignName = getNodeText(GetChildNodes(NodeList[i])[3]);
                     var SignCont = getNodeText(GetChildNodes(NodeList[i])[4]);
                     
                     var aprMemberName = getNodeText(SelectSingleNode(NodeList[i], "APRMEMBERNAME"));

                     var field = message.GetListItem(fields, SignName);
                     if (field) {
                         retVal = true;
                         if (SignType == "TEXT" || SignType == "HTML") {
                             field.innerHTML = SignCont;
                         } else {
                         	var seumyung = message.GetListItem(fields, "seumyungdate" + (i + 1));
                             var img = SignCont.split("::");
                             var signWidth = parseInt(field.offsetWidth) - 4 - 15;
                             var signHeight = parseInt(field.offsetHeight) - 4
                             signWidth = 50;
                             if (seumyung) {
                             	if (img[1] != null) {
     	                        	if (img[1].indexOf(strLang7) > -1) {
     	                        		signHeight = 28;
     	                        	} else {
     	                        		signHeight = 50;
     	                        	}
                             	} else {
                             		signHeight = 50;
                             	}
                             } else {
                             	signHeight = 28;
                             }

                             var strimg;
                             if (img.length >= 1) {
                                 strimg = "<img src='" + encodeURI(img[0]) + "' border=0 embedding='1' ";
                                 strimg = strimg + " width=" + signWidth;
                                 
                                 if (signImage = "NAME") {
                                 	//2018-08-02 이효진 signImage Name 사용시 결재때만 정상동작하고 수신쪽은 처리되어있지 않아 추가 
                                 	//2018-08-02 이효진 signImage Name일때 반복문으로 앞쪽 이미지 서명까지 전부 새로 입력중이라 userInfo 말고 DB에서 꺼내쓰도록 수정
//                                 	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>" + "<br>" + arr_userinfo[2] ;
                                 	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>" + "<br>" + aprMemberName;
                                 } else {
                                 	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>";
                                 }
                             }
                             
                             if (seumyung) {
                             	if (img[1].indexOf(strLang7) > -1) {
                             		if (img.length >= 2 && img[1] != "") {
                                         field.innerHTML = img[1] + strimg;
                                     } else {
                                         field.innerHTML = strimg;
                                     }
                             	} else {
                             		field.innerHTML = strimg;
                             	}
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
        } else if (ext == "hwp") {
        	NodeList = SignXML.selectNodes("SIGNINFOS/SIGNINFO");
        	if (NodeList.length > 0) 
        	{
        		for (i=0; i<NodeList.length; i++)
        		{
        		    var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
        		    var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
        		    var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));
        			
        			if (message.FieldExist(SignName))
        			{	
        			    retVal = true;		
        				if (SignType == "TEXT")
        				{
        					message.PutFieldText(SignName, SignCont);
        				}
        				else if (SignType == "HTML")
        				{
        					
        					HwpCtrl.AppendFieldText(SignName, SignCont, true, true, true);
        				}
        				else if (SignType == "PROXY")
        				{
        					message.PutFieldText(SignName, " ");
        					HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(SignCont), 3, 0, 0, true, 2);
        					HwpCtrl.AppendFieldText(SignName, strLang17, true);
        				}
        				else if (SignType == "IMAGE")
        				{
        				    var img = SignCont.split("::");  
        					message.PutFieldText(SignName, "");
        					if(img.length >= 1)
        					    HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(img[0]), 3, 0, 0, true, 2);
        					    
        				    if(img.length >= 2)
        				        HwpCtrl.AppendFieldText(SignName, img[1], true);
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

function SignSave() {
    if (SignContent.length > 0) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objRoot, objNode, subNode;
        objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

        for (i = 0; i < SignContent.length; i++) {
            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SIGNINFO", "");
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

/* 2022-08-16 홍승비 - 부서수신함에서 수신문 접수기안(또는 전결) 시, 결재선 변경이력 남기도록 수정 */
function UpdateLineHistory() {
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
			var pAlertContent = strLang91;
	        OpenAlertUI(pAlertContent);
		}
	});
}
