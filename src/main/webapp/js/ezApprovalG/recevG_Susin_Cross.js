var selectcabinet_cross_dialogArguments = new Array();
function btnSetTaskCode_onclick() {
    try {
        var para = new Array();
        para[0] = cabinetID;

        selectcabinet_cross_dialogArguments[0] = para;
        selectcabinet_cross_dialogArguments[1] = btnSetTaskCode_onclick_Complete;

        DivPopUpShow(850, 455, "/ezApprovalG/selectCabinet.do?initFlag=1");
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
        }
        else {
            xmlKuljea = ret[1];
            xmlReDraft = ret[5];
        }
        setAprLinesXML(xmlKuljea);

        if (xmlReDraft == "C") {
            ApplyDocCellInfo();
        }
        else if (xmlReDraft == "R") {
            ClearDocCellInfo();
        }

        xmldom = loadXMLString(xmlKuljea);
        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        fields = message.GetFieldsList();
        count = objNodes.length;

        var susinSN = "";
        if (pDraftFlag == "SUSIN" || pDocState == "011") {
            susinSN = pSusinSN;
        }

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

        if (isSplit == "Y")
            SplitSign(OrderType, OrderName, OrderDept, OrderStat, OrderJobtitle);

        LastSignSN = OrderType.length;

        CurAprType = OrderType[1];
        if (OrderType.length > 2)
            NextAprType = OrderType[2];

        for (i = 1; i < OrderType.length; i++) {
            if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) {
                LastSignSN = i;
                i = OrderType.length;
            }
            else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3)
                LastSignSN = i;
        }


        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];
        var field = message.GetListItem(fields, "lastKyuljikwee");
        if (field)
            field.textContent = lastKyuljiwee;

        var field = message.GetListItem(fields, "lastKyulName");
        if (field)
            field.textContent = lastKyulName;

        hapyuiCnt = 1;
        SignCnt = 1;
        referCnt = 1;
        gongramCnt = 1;

        var fieldname;
        var field;
        var refer = "";


        for (i = 1; i < 10; i++) {
            fieldname = susinSN + "jikwe" + i;
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.textContent = " ";
                fieldname = susinSN + "sign" + i;
                field = message.GetListItem(fields, fieldname);
                if (field)
                    field.textContent = " ";
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

        var idx = 1;
        var hidx = 1;
        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) {
                fieldname = susinSN + "jikwe" + idx;
                field = message.GetListItem(fields, fieldname);

                if (field) {
                    var jikweName = trim(field.textContent);
                    if (jikweName.substring(0, 1) != strLang128)
                        field.textContent = OrderJobtitle[i];

                    if (OrderSuggester[i] == "Y")
                        field.textContent = strLang75 + field.textContent;

                    if (OrderReporter[i] == "Y")
                        field.textContent = strLang76 + field.textContent;
                }

                fieldname = susinSN + "sign" + idx;
                field = message.GetListItem(fields, fieldname);

                if (field) {
                }
                idx = idx + 1;
            }
            else if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
                fieldname = susinSN + "habyui" + hidx;
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
                hidx = hidx + 1;
            }
        }

        if (message.GetListItem(fields, "lineapr")) {
            if (idx > 5) {
                message.GetListItem(fields, "lineapr").style.display = "";
                for (i = 0; i < message.GetListItem(fields, "lineapr").children.length; i++)
                    message.GetListItem(fields, "lineapr").children[i].style.display = "";
            }
            else {
                message.GetListItem(fields, "lineapr").style.display = "none";
                for (i = 0; i < message.GetListItem(fields, "lineapr").children.length; i++)
                    message.GetListItem(fields, "lineapr").children[i].style.display = "none";
            }
        }

        if (message.GetListItem(fields, "linehab")) {
            if (hidx > 5) {
                message.GetListItem(fields, "linehab").style.display = "";
                for (i = 0; i < message.GetListItem(fields, "linehab").children.length; i++)
                    message.GetListItem(fields, "linehab").children[i].style.display = "";
            }
            else {
                message.GetListItem(fields, "linehab").style.display = "none";
                for (i = 0; i < message.GetListItem(fields, "linehab").children.length; i++)
                    message.GetListItem(fields, "linehab").children[i].style.display = "none";
            }
        }
    } catch (e) {
        alert("GetDraftAprLineInfo(ret)" + e.description);
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
            if (field)
                field.textContent = " ";

            fieldname = susunSN + "seumyung" + i;
            field = message.GetListItem(fields, fieldname);
            if (field)
                field.textContent = " ";

            fieldname = susunSN + "seumyungdate" + i;
            field = message.GetListItem(fields, fieldname);
            if (field)
                field.textContent = " ";

            fieldname = susunSN + "jikwe" + i;
            field = message.GetListItem(fields, fieldname);

            if (field)
                field.textContent = " ";
        }

        for (j = 1 ; j <= hapyuiCount ; j++) {
            fieldname = susunSN + "habyui" + j;
            field = message.GetListItem(fields, fieldname);
            if (field)
                field.textContent = " ";

            fieldname = susunSN + "habyuipositon" + j;
            field = message.GetListItem(fields, fieldname);
            if (field)
                field.textContent = " ";

            fieldname = susunSN + "habyuidate" + j;
            field = message.GetListItem(fields, fieldname);
            if (field)
                field.textContent = " ";

            fieldname = susunSN + "habyuisign" + j;
            field = message.GetListItem(fields, fieldname);
            if (field)
                field.textContent = " ";
        }
    } catch (e) {
        alert("ClearDocCellInfo : " + e.description);
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
        var signInfo = new Array();
        var signCnt;
        var sn = 1;

        var OpinionText = "";
        var PositionText = "";
        if (getOpinionCount()) {
            PositionText = "(" + strLang5;
        }

        if (LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16)
        {
            OpinionText = getSignDate() + "<br>";
        }

        signCnt = 0;
        if (pDraftFlag == "SUSIN" || pDocState == "011") {
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

        var field = message.GetListItem(fields, psigncell);
        var signWidth = field.offsetWidth;
        var signHeight = field.offsetHeight;

        if (signWidth > signHeight) {
            signHeight = signHeight - 15;
            signWidth = signHeight;
        } else {
            signWidth = signWidth - 15;
            sighHeight = signWidth;
        }
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
                    //message.BodySetAttribute(psigncell, escape(ret));
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
                    SignContent[signCnt] = ret + "::" + OpinionText;
                    //message.BodySetAttribute(psigncell, escape(ret));
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
                if (field)
                    field.textContent = " ";
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
    		dataType : "xml",
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
    	
        xmluserInfo = result;

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

        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
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

        if (NodeList.length != 0) {
            pHasOpinionYN = "Y";
        } else {
            pHasOpinionYN = "N";
        }
    }
}

function openFileAttachUI() {
    try {
        var parameter = pDocID;
        var url = "../ezAPRATTACH/Aprattach_Cross.aspx";
        var feature = "status:no;dialogWidth:390px;dialogHeight:285px;edge:sunken;scroll:no"; 
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            setAttachInfo(pDocID, "APR", lstAttachLink);
        }
        return ret;
    } catch (e) {
        alert("openFileAttachUI : " + e.description);
    }
}

function SaveDraftDocInfo() {
    var rtnVal;
    SaveFile();
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
        createNodeAndInsertText(xmlpara, objNode, "DocID", getNodeText(objNodes[0]));
        createNodeAndInsertText(xmlpara, objNode, "FormID", getNodeText(objNodes[1]));
        createNodeAndInsertText(xmlpara, objNode, "OrgDocID", getNodeText(objNodes[2]));
        createNodeAndInsertText(xmlpara, objNode, "DocType", getNodeText(objNodes[3]));
        createNodeAndInsertText(xmlpara, objNode, "DocState", getNodeText(objNodes[4]));
        createNodeAndInsertText(xmlpara, objNode, "FunctionType", strAprState2);
        createNodeAndInsertText(xmlpara, objNode, "Href", getNodeText(objNodes[6]));        
        createNodeAndInsertText(xmlpara, objNode, "DocTitle", message.GetDocTitle());
        createNodeAndInsertText(xmlpara, objNode, "DocNo", pDocNo);
        createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", "");
        createNodeAndInsertText(xmlpara, objNode, "StartDate", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "EndDate", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WriterID", getNodeText(objNodes[13]));
        createNodeAndInsertText(xmlpara, objNode, "WriterName", getNodeText(objNodes[14]));
        createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", getNodeText(objNodes[15]));
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", getNodeText(objNodes[16]));
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", getNodeText(objNodes[17]));
        createNodeAndInsertText(xmlpara, objNode, "Html", message.Get_EditorBodyHTML());
        createNodeAndInsertText(xmlpara, objNode, "OrgHtml", pOrgHtml);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[2]);
        createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "Public", "");
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

        xmlhttp.open("POST", "/ezApprovalG/doDraft.do", false);
        xmlhttp.send(xmlpara);

        SetBtnStateFalse();

        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        return getNodeText(dataNodes[0]);

    } catch (e) {
        alert("SaveDraftDocInfo_susin : " + e.description);
    }
}

var inssepattach_cross_dialogArguments = new Array();
function btnAddSepAttach_onclick() {
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

    inssepattach_cross_dialogArguments[0] = para;
    inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;

    DivPopUpShow(730, 630, "/myoffice/ezApprovalG/ezCabinet/InsSepAttach_Cross.aspx");
}


function btnAddSepAttach_onclick_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        g_SepAttachLVXml = rtn[1];
        message.BodySetAttribute("SepAttachLVXml", g_SepAttachLVXml);
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
    		dataType : "xml",
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

        SignNodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");

        if (SignNodeList.length != 0) {
            var parameter = pUserID;

            aprsign1_cross_dialogArguments[0] = parameter;
            aprsign1_cross_dialogArguments[1] = openSignUI_Complete;

            DivPopUpShow(350, 310, "/ezApprovalG/aprSign.do");
        } else {
            openSignUI_Complete("NAME");
        }
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
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getDocData.do",
    		data : {
    			docID : pDocID,
    			mode  : "APR",
    			sel   : "FormID"
    		},
    		success: function(xml){
    			result = xml;
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
    		dataType : "xml",
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
        
        var dataNodes = GetChildNodes(result);
        
        return getNodeText(dataNodes[0]);

    } catch (e) {
        alert("setSusinUpdataDocID : " + e.description);
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
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getDocInfo.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
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

        cabinetID = "";
        TaskCode = "";

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
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getReceiveDocInfo.do",
    		data : {
    			docID : pDocID
    		},
    		success: function(xml){
    			result = xml;
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
        }
        else {
            RECEIPTDEPTID.innerText = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
        }
        pOrgAttach = "";

        pRelayURL = getNodeText(GetElementsByTagName(result, "RELAY")[0]);
        pRelayURL2 = getNodeText(GetElementsByTagName(result, "RELAY2")[0]);
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
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmlpara, objNode, "ASSIGN");
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "ReceiveSN", pSusinSN);
        createNodeAndInsertText(xmlpara, objNode, "DeptID", arr_userinfo[4]);
        if (pAprState == "015")
            createNodeAndInsertText(xmlpara, objNode, "DocSate", "REBACK");
        else
            createNodeAndInsertText(xmlpara, objNode, "DocSate", "RECEIVE");

        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName2", arr_userinfo[12]);

        xmlhttp.open("POST", "../ezAPRRECEIVE/aspx/setHeSongDocInfo.aspx", false);
        xmlhttp.send(xmlpara);

        var RtnVal = getNodeText(xmlhttp.responseXML.documentElement);

        if (RtnVal != "TRUE") {
            var pAlertContent = strLang740;
            OpenAlertUI(pAlertContent);
            return false;
        }
        else {
            var pAlertContent = strLang741;
            OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
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
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pDeptName", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "pDocSN", pDocSN);
        createNodeAndInsertText(xmlpara, objNode, "pDeptName2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName2", arr_userinfo[12]);

        xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/setCabinetHesong.aspx", false);
        xmlhttp.send(xmlpara);

        var RtnVal = getNodeText(xmlhttp.responseXML.documentElement);

        if (RtnVal == "TRUE")
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

    DivPopUpShow(330, 200, "/ezApprovalG/ezchkPasswd.do");
}

function setFirstDrafter() {
    var ret = getAutoAprLine();

    if (ret[0] != "NONE") {
        GetDraftAprLineInfo(ret);
        btnSendDraft.Enable = "true";
        LastSignSN = 1;
    }

    return;
}


function openAaprDocAttachUI() {
    try {
        var parameter = pUserID;
        var url = "../ezAprDocAttach/aprDocAttach_Cross.aspx";
        var feature = "status:no;dialogWidth:574px;dialogHeight:385px;edge:sunken;scroll:no";
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            setAttachInfo(pDocID, "APR", lstAttachLink);
        }
        return ret;
    } catch (e) {
        alert("openAaprDocAttachUI : " + e.description);
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

function getOpinionCount() {
    try {
    	var result = "";
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getOpinionCount.do",
    		data : {
    			docID : pDocID,
    			userID : arr_userinfo[1],
    			chkFlag : "ING"
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});
        
        var tempValue = parseInt(result);
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

function SignCheck() {
    var objNodes = getNodeText(xmldoc.documentElement);
    var SignXML = createXmlDom();

	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
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

    var NodeList;
    NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");
    if (NodeList.length <= 0)
        return;

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
                var SignType = getNodeText(GetChildNodes(NodeList[i])[2]);
                var SignName = getNodeText(GetChildNodes(NodeList[i])[3]);
                var SignCont = getNodeText(GetChildNodes(NodeList[i])[4]);

                var field = message.GetListItem(fields, SignName);
                if (field) {
                    retVal = true;
                    if (SignType == "TEXT" || SignType == "HTML") {
                        field.innerHTML = SignCont;
                    }
                    else {
                        var img = SignCont.split("::");
                        var signWidth = parseInt(field.offsetWidth) - 4 - 15;
                        var signHeight = parseInt(field.offsetHeight) - 4
                        signWidth = 50;
                        signHeight = 28;

                        var strimg;
                        if (img.length >= 1) {
                            strimg = "<img src='" + document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(img[0]) + "' border=0 embedding='1' ";
                            strimg = strimg + " width=" + signWidth;
                            strimg = strimg + " height=" + signHeight + " spath='" + escape(img[0]) + "'>";
                            //message.BodySetAttribute(SignName, img[0]);
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
        }
        xmlhttp.open("Post", "/ezApprovalG/setSignInfo.do", false);
        xmlhttp.send(xmlpara);
    }
}