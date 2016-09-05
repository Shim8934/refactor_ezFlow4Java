var lastKyulName, lastKyuljiwee, LastSignSN, pAprLineB4type;
var pOrgAttach;
var bbtnApprove = "";
var bbtnReject = "";
var bbtnStay = "";
var bbtnJunKyul = "";
var bbtnModAprLine = "";
var bbtnEdit = "";
var bbtnOpinion = "";
var bbtnFileAttach = "";
var bbtnAprDocAttach = "";
var bbtnPrint = "";
var bbtnSave = "";
var bbtnmail = "";
var bbtnSetTaskCode = "";
var bbtnAddSepAttach = "";
var bbtnhistory = "";
var bbtnDocInfo = "";
var bbtnModAprDept = "";
var btbtnTotalSave = "";
var bbtntotaldocinfo = "";

function putBansongSign() {
    var fields = message.GetFieldsList();
    var field;
    var SingFlag = true;
    var habyui;
    var signInfo = new Array();
    var signCnt = 0;
    var RtnVal = getGyulJeDate();
    var CurrentDate = RtnVal.split(".");
    var s = CurrentDate[1] + "." + CurrentDate[2];
    if (pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
        var phabyuisign;
        var phabyuidate;
        var phabyuijikwee;
        var phabyuidept;
        if (pDraftFlag == "SUSIN") {
            phabyuisign = pSusinSN + "habyuisign";
            phabyuidate = pSusinSN + "habyuidate";
            phabyuijikwee = pSusinSN + "habyuipositon";
            phabyuidept = pSusinSN + "habyui";
        }
        else {
            phabyuisign = "habyuisign";
            phabyuidate = "habyuidate";
            phabyuijikwee = "habyuipositon";
            phabyuidept = "habyui";
        }

        habyui = phabyuisign + pAprMemberSN;
        var field = message.GetListItem(fields, habyui);
        if (field) {

            field.textContent = strLang4;
            SignContent[signCnt] = strLang4;
            signInfo[signCnt] = habyui;
            SignType[signCnt] = "TEXT";
            SignName[signCnt] = habyui;

            signCnt = signCnt + 1;
            SingFlag = false;
        }

        var habyuidateID = phabyuidate + pAprMemberSN;

        var field = message.GetListItem(fields, habyuidateID);
        if (field) {

            field.textContent = s;
            signInfo[signCnt] = habyuidateID;
            SignType[signCnt] = "TEXT";
            SignName[signCnt] = habyuidateID;
            SignContent[signCnt] = s;
            signCnt = signCnt + 1;
        }
    }
    return signInfo;
}
function AprrovMappingSign(ret) {
    var fields = message.GetFieldsList();
    var field;
    var SingFlag = true;
    var DekyulFlag = false;
    var habyui;
    var signInfo = new Array();
    var signCnt;

    signCnt = 0;

    var RtnVal = getGyulJeDate();
    var CurrentDate = RtnVal.split(".");
    var s = CurrentDate[1] + "." + CurrentDate[2];

    var OpinionText = "";
    var PositionText = "";
    if (getOpinionCount()) {
        PositionText = "(" + strLang5 + "";
    }

    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
        OpinionText = getSignDate() + "<br>";
    }

    if (pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
        var phabyuisign;
        var phabyuidate;
        var phabyuijikwee;
        var phabyuidept;

        if (pDraftFlag == "SUSIN") {
            phabyuisign = pSusinSN + "habyuisign";
            phabyuidate = pSusinSN + "habyuidate";
            phabyuijikwee = pSusinSN + "habyuipositon";
            phabyuidept = pSusinSN + "habyui";
        } else {
            phabyuisign = "habyuisign";
            phabyuidate = "habyuidate";
            phabyuijikwee = "habyuipositon";
            phabyuidept = "habyui";
        }

        var habyui = phabyuisign + pAprMemberSN;
        var field = message.GetListItem(fields, habyui);
        if (field) {
            if (ret != "NAME" && ret != "") {
                var signWidth = parseInt(field.offsetWidth) - 4 - 15;
                var signHeight = parseInt(field.offsetHeight) - 4;
                signWidth = 50;
                signHeight = 28;

                var strimg;
                strimg = "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
                strimg = strimg + " width=" + signWidth;
                strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";

                if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
                    strimg = strLang8 + strimg;

                field.innerHTML = strimg;
                var content = ret;
                if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
                    content = ret + "::" + strLang8;
                signInfo[signCnt] = habyui;
                SignType[signCnt] = "IMAGE";
                SignName[signCnt] = habyui;
                SignContent[signCnt] = content;
                
                signCnt = signCnt + 1;
                SingFlag = true;

            } else {
                if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                    field.innerHTML = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";
                    SignContent[signCnt] = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";
                }
                else {
                    field.innerHTML = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                    SignContent[signCnt] = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                }

                signInfo[signCnt] = habyui;
                SignType[signCnt] = "HTML";
                SignName[signCnt] = habyui;
                signCnt = signCnt + 1;
                SingFlag = false;
            }
        }

        var habyuidateID = phabyuidate + pAprMemberSN;
        var field = message.GetListItem(fields, habyuidateID);
        if (field) {
            field.textContent = s;
            signInfo[signCnt] = habyuidateID;
            SignType[signCnt] = "TEXT";
            SignName[signCnt] = habyuidateID;
            SignContent[signCnt] = s;
            signCnt = signCnt + 1;
        }

        var phabyuijikweeID = phabyuijikwee + pAprMemberSN;
        var field = message.GetListItem(fields, phabyuijikweeID);
        if (field) {
            field.textContent = field.textContent + PositionText;
        }
    }
    else if (pAprLineType == strAprType2 || pAprLineType == strAprType7) {

    }
    else if (pAprLineType == strAprType15) {
        signID = "gamsasign1";

        var field = message.GetListItem(fields, signID);

        if (field) {

            var psingTD = field;
            var SContent = strLang14 + "<br>" + arr_userinfo[2] + "<br>" + s;
            psingTD.innerHTML = SContent;
            signInfo[signCnt] = signID;
            SignName[signCnt] = signID;
            SignType[signCnt] = "HTML";
            SignContent[signCnt] = SContent;

            signCnt = signCnt + 1;
        }
    }
    else if (ret == "BANSONG" && KuyjeType == "001") {
        var pAprMemberSignSN = pAprMemberSN;
        var signID;
        var seumyungID;
        var seumyungdateID;

        signID = "sign" + pAprMemberSignSN;
        seumyungID = "seumyung" + pAprMemberSignSN;
        seumyungdateID = "seumyungdate" + pAprMemberSignSN;

        var field = message.GetListItem(fields, signID);

        if (field) {
            var psingTD = field;
            var SContent = strLang4 + "<br>" + arr_userinfo[2];
            psingTD.innerHTML = SContent;
            signInfo[signCnt] = signID;

            SignName[signCnt] = signID;
            SignType[signCnt] = "HTML";
            SignContent[signCnt] = SContent;

            signCnt = signCnt + 1;
        }

        field = message.GetListItem(fields, seumyungID);

        if (field) {
            field.textContent = arr_userinfo[5];
            signInfo[signCnt] = seumyungID;
            SignName[signCnt] = seumyungID;
            SignType[signCnt] = "TEXT";
            SignContent[signCnt] = arr_userinfo[5];

            signCnt = signCnt + 1;
        }

        field = message.GetListItem(fields, seumyungdateID);
        if (field) {
            field.textContent = s;
            signInfo[signCnt] = seumyungdateID;
            SignName[signCnt] = seumyungdateID;
            SignType[signCnt] = "TEXT";
            SignContent[signCnt] = s;
            signCnt = signCnt + 1;
        }

    }
    else {
        var pAprMemberSignSN = pAprMemberSN;
        var signID;
        var seumyungID;
        var seumyungdateID;

        if (pDraftFlag == "SUSIN") {
            signID = pSusinSN + "sign" + pAprMemberSignSN;
            seumyungID = pSusinSN + "jikwe" + pAprMemberSignSN;
            seumyungdateID = pSusinSN + "seumyungdate" + pAprMemberSignSN;
        } else {
            signID = "sign" + pAprMemberSignSN;
            seumyungID = "jikwe" + pAprMemberSignSN;
            seumyungdateID = "seumyungdate" + pAprMemberSignSN;
        }

        var field = message.GetListItem(fields, seumyungdateID);
        if (field && !(LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16)) {
            field.innerText = s;
        }

        field = message.GetListItem(fields, seumyungID);
        if (field) {
            field.textContent = field.textContent + PositionText;
        }

        if (pAprLineType == strAprType16) {
            var field = message.GetListItem(fields, signID);
            if (field) {
                if (ret != "NAME") {
                    signWidth = 50;
                    signHeight = 28;

                    var strimg;

                    var FilePath = encodeURI(ret);

                    if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase())
                        strimg = "<img src='" + FilePath + "' border=0 embedding='1' ";
                    else
                        strimg = strLang17 + "<br><img src='" + FilePath + "' border=0 embedding='1' ";

                    strimg = strimg + " width=" + signWidth;
                    strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";

                    strimg = OpinionText + strimg;
                    strimg = strLang7 + strimg;

                    field.innerHTML = strimg;
                    signInfo[signCnt] = signID;

                    var contents = "";
                    if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
                        contents = strLang17;

                    SignName[signCnt] = signID;
                    SignType[signCnt] = "IMAGE";
                    SignContent[signCnt] = ret + "::" + strLang7 + OpinionText + contents;


                    //message.BodySetAttribute(signID, ret);
                    signCnt = signCnt + 1;
                    SingFlag = true;
                }
                else {
                    if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase())
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                    else
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";

                    strimg = OpinionText + strimg;
                    strimg = strLang7 + strimg;

                    field.innerHTML = strimg;
                    signInfo[signCnt] = signID;
                    SignName[signCnt] = signID;
                    SignType[signCnt] = "HTML";
                    SignContent[signCnt] = strimg;

                    signCnt = signCnt + 1;
                    SingFlag = false;
                }

                DekyulFlag = true;
                pAprMemberSignSN = pAprMemberSignSN + 1;
                if (pDraftFlag == "SUSIN") {
                    signID = pSusinSN + "sign" + pAprMemberSignSN;
                    seumyungID = pSusinSN + "jikwe" + pAprMemberSignSN;
                    seumyungdateID = pSusinSN + "seumyungdate" + pAprMemberSignSN;
                }
                else {
                    signID = "sign" + pAprMemberSignSN;
                    seumyungID = "jikwe" + pAprMemberSignSN;
                    seumyungdateID = "seumyungdate" + pAprMemberSignSN;
                }
            }
        }

        var field = message.GetListItem(fields, signID);
        if (field) {
            if (DekyulFlag && pAprLineB4type == strAprType4) {
                field.innerHTML = strLang6;
                signInfo[signCnt] = signID;
                SignName[signCnt] = signID;
                SignType[signCnt] = "TEXT";
                SignContent[signCnt] = strLang6;

                signCnt = signCnt + 1;
            }
            else if (DekyulFlag) {
            }
            else {
                if (ret != "NAME") {
                    var signWidth = field.offsetWidth;
                    var signHeight = field.offsetHeight;
                    if (signWidth > signHeight) {
                        signHeight = signHeight - 15;
                        signWidth = signHeight;
                    }
                    else {
                        signWidth = signWidth - 15;
                        sighHeight = signWidth;
                    }
                    signWidth = 50;
                    signHeight = 28;

                    var strimg;

                    var FilePath = encodeURI(ret);

                    if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase())
                        strimg = "<img src='" + FilePath + "' border=0 embedding='1' ";
                    else
                        strimg = strLang17 + "<br><img src='" + FilePath + "' border=0 embedding='1' ";

                    strimg = strimg + " width=" + signWidth;
                    strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";

                    strimg = OpinionText + strimg;

                    var contents = OpinionText;
                    if (pAprLineType == strAprType4) {
                        strimg = strLang6 + strimg;
                        contents = strLang6 + contents;
                    }

                    if (pAprLineType == strAprType16) {
                        strimg = strLang7 + strimg;
                        contents = strLang7 + contents;
                    }

                    field.innerHTML = strimg;
                    signInfo[signCnt] = signID;
                    SignName[signCnt] = signID;
                    SignType[signCnt] = "IMAGE";
                    SignContent[signCnt] = ret + "::" + contents;

                    //message.BodySetAttribute(signID, ret);
                    signCnt = signCnt + 1;
                    SingFlag = true;
                }
                else {
                    if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase())
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                    else
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";

                    strimg = OpinionText + strimg;
                    if (pAprLineType == strAprType4) {
                        strimg = strLang6 + strimg;
                    }

                    if (pAprLineType == strAprType16) {
                        strimg = strLang7 + strimg;
                    }

                    field.innerHTML = strimg;
                    signInfo[signCnt] = signID;
                    SignName[signCnt] = signID;
                    SignType[signCnt] = "HTML";
                    SignContent[signCnt] = strimg;
                    signCnt = signCnt + 1;
                    SingFlag = false;
                }
            }
        }
    }
    return signInfo;
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
function putKyuljeSign(signID) {
}
function UndoSignInfo(signInfo) {
    var cnt;
    var fields = message.GetFieldsList();
    var field;

    for (cnt = 0; cnt < signInfo.length; cnt++) {

        field = GetListItem(fields, signInfo[cnt]);
        if (field) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
}
function AprLineSNCount(pAprLineType, objNodes, pTmpAprLineType) {
    var objNodesLen = objNodes.length;
    var pAprLineSN = 0;

    for (i = (objNodesLen - 1) ; i >= 0; i--) {
        var pCurrentAprState = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12]);
        var pCurrentAprType = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]);
        if (pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
            if (pCurrentAprType == strAprType8 || pCurrentAprType == strAprType9 || pCurrentAprType == strAprType11 || pCurrentAprType == strAprType12) {
                if ((getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5))) {
                    pAprLineSN = pAprLineSN + 1;
                    break;
                } else {
                    pAprLineSN = pAprLineSN + 1;
                }
            }
        }
        else {
            if (pCurrentAprType == strAprType18 || pCurrentAprType == strAprType19 || pCurrentAprType == strAprType1 || pCurrentAprType == strAprType16 || pCurrentAprType == strAprType4) {
                if ((getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5))) {
                    pAprLineSN = pAprLineSN + 1;
                    break;
                } else {
                    pAprLineSN = pAprLineSN + 1;
                }
            }
        }

    }
    return pAprLineSN;
}
function GetAprDocFormID(pDocID) {
    var pFormID;

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

    xmlhttp.open("Post", "../DraftUI/aspx/GetAprDocFormID.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    pFormID = getNodeText(dataNodes[0]);

    return pFormID;
}

var apropinion_cross_dialogArguments = new Array();
function openOpinionUI(ret, CompleteFunction) {
    var parameter = new Array();
    parameter[0] = pDocID;
    parameter[1] = ret;
    parameter[2] = KuyjeType;
    parameter[3] = pOrgDocID;
    parameter[5] = window;

    apropinion_cross_dialogArguments[0] = parameter;
    if (CompleteFunction != undefined)
        apropinion_cross_dialogArguments[1] = CompleteFunction;
    else
        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;

    DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
}
function openOpinionUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel") {
        var Rtnxml = createXmlDom();
        Rtnxml = loadXMLString(ret);

        var NodeList = SelectNodes(Rtnxml, "LISTVIEWDATA/ROWS/ROW");

        if (NodeList.length != 0)
            pHasOpinionYN = "Y";
        else {
            pHasOpinionYN = "N";
            ret = "cancel";
        }
        makeOpinionList(Rtnxml);
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
            if (getNodeText(GetChildNodes(NodeList[i])[9]) == "001") {
                if (firstFlag) {
                    strOpinion = "<P>[" + strLang27 + "</P>";
                    firstFlag = false;
                }
                if (getNodeText(GetChildNodes(NodeList[i])[2]) != "")
                    strOpinion = strOpinion + "<P>" + getNodeText(GetChildNodes(NodeList[i])[2]) + "&nbsp;&nbsp;&nbsp;";
                else
                    strOpinion = strOpinion + "<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

                strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[1]) + "&nbsp;&nbsp;&nbsp;";
                strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[6]) + "</P>";
            }
        }
        field.innerHTML = strOpinion;

        if (OpinionAction == "ADD" || OpinionAction == "DEL")
            SaveFile();

        OpinionAction = "";
    }
    else {
        field.innerHTML = " ";
    }
}
var aprattach_cross_dialogArguments = new Array();
function openFileAttachUI() {
    var parameter = pDocID;
    url = "/ezApprovalG/aprAttach.do?formID=" + encodeURI(pFormID) + "&docID=" + encodeURI(pDocID);

    aprattach_cross_dialogArguments[0] = parameter;
    aprattach_cross_dialogArguments[1] = openFileAttachUI_Complete;

    DivPopUpShow(535, 285, url);
}

function openFileAttachUI_Complete(ret) {
    DivPopUpHidden();
}
function ChangeBtnState() {
    setMenuBar("btnReject", Btnflag);
    setMenuBar("btnStay", Btnflag);
    setMenuBar("btnApprove", Btnflag);
    setMenuBar("btnEdit", Btnflag);
    setMenuBar("btnModAprLine", Btnflag);
    setMenuBar("btnModAprDept", Btnflag);
    setMenuBar("btnFileAttach", Btnflag);
    setMenuBar("btnOpinion", Btnflag);
    setMenuBar("btnJunKyul", false);
    setMenuBar("btnConn", Btnflag);
}
function ChangeBtnStateTrue() {
    try {
        setMenuBar("btnSelDoc", Btnflag);
        setMenuBar("btnReject", Btnflag);
        var APRSTATE = GetElementsByTagName(xmldoc, "DOCSTATE");
        if (APRSTATE == "005")
            setMenuBar("btnStay", false);
        else
            setMenuBar("btnStay", Btnflag);

        setMenuBar("btnApprove", Btnflag);
        setMenuBar("btnPrevDoc", Btnflag);
        setMenuBar("btnNextDoc", Btnflag);
        setMenuBar("btnEdit", Btnflag);
        setMenuBar("btnModAprLine", Btnflag);
        setMenuBar("btnModAprDept", Btnflag);
        setMenuBar("btnFileAttach", Btnflag);
        setMenuBar("btnOpinion", Btnflag);
        setMenuBar("btnPrint", Btnflag);
        setMenuBar("btnJunKyul", false);

        if (pDraftFlag == "CHAMJO") {
            setMenuBar("btnApprove", false);
            setMenuBar("btnReject", false);
            setMenuBar("btnStay", false);
            setMenuBar("btnModAprLine", false);
            setMenuBar("btnModAprDept", false);
            setMenuBar("btnFileAttach", false);
        }
    } catch (e) {
        alert("ChangeBtnStateTrue  :: " + e.description);
    }
}
function chkBtn(pBtnflag) {
    setMenuBar("btnApprove", pBtnflag);
    setMenuBar("btnReject", pBtnflag);
    setMenuBar("btnStay", pBtnflag);
    setMenuBar("btnDocInfo", pBtnflag);
    setMenuBar("btnJunKyul", false);
    setMenuBar("btnModAprLine", pBtnflag);
    setMenuBar("btnModAprDept", false);
    setMenuBar("btnMail", pBtnflag);
    setMenuBar("btnOpinion", pBtnflag);
    setMenuBar("btnFileAttach", pBtnflag);
    setMenuBar("btnAprDocAttach", pBtnflag);
    setMenuBar("btnPrint", pBtnflag);
    setMenuBar("btnSave", pBtnflag);
    setMenuBar("btnSetTaskCode", pBtnflag);
    setMenuBar("btnAddSepAttach", pBtnflag);
    setMenuBar("btnhistory", pBtnflag);
    setMenuBar("tbtnTotalSave", pBtnflag);
    setMenuBar("btntotaldocinfo", pBtnflag);

    if (trim(pDraftFlag) == "GONGRAM" || trim(pDraftFlag) == "CHAMJO") {
        setMenuBar("btnReject", false);
        setMenuBar("btnStay", false);
    }
    else {
        setMenuBar("btnReject", pBtnflag);

        var APRSTATE = GetElementsByTagName(xmldoc, "DOCSTATE");
        if (APRSTATE == strAprState5)
            setMenuBar("btnStay", false);
        else
            setMenuBar("btnStay", pBtnflag);
    }
}
function chkBtnConfirm(para) {
    if (para == "1") {
        if (document.getElementById("btnApprove").style.display == "")
            bbtnApprove = "1";

        if (document.getElementById("btnReject").style.display == "")
            bbtnReject = "1";

        if (document.getElementById("btnStay").style.display == "")
            bbtnStay = "1";

        if (document.getElementById("btnJunKyul").style.display == "")
            bbtnJunKyul = "1";

        if (document.getElementById("btnModAprLine").style.display == "")
            bbtnModAprLine = "1";

        if (document.getElementById("btnEdit").style.display == "")
            bbtnEdit = "1";

        if (document.getElementById("btnOpinion").style.display == "")
            bbtnOpinion = "1";

        if (document.getElementById("btnFileAttach").style.display == "")
            bbtnFileAttach = "1";

        if (document.getElementById("btnAprDocAttach").style.display == "")
            bbtnAprDocAttach = "1";

        if (document.getElementById("btnPrint").style.display == "")
            bbtnPrint = "1";

        if (document.getElementById("btnSave").style.display == "")
            bbtnSave = "1";

        if (document.getElementById("btnMail").style.display == "")
            bbtnMail = "1";

        if (document.getElementById("btnSetTaskCode").style.display == "")
            bbtnSetTaskCode = "1";

        if (document.getElementById("btnAddSepAttach").style.display == "")
            bbtnAddSepAttach = "1";

        if (document.getElementById("btnhistory").style.display == "")
            bbtnhistory = "1";

        if (document.getElementById("btnDocInfo").style.display == "")
            bbtnDocInfo = "1";

        if (document.getElementById("btnModAprDept").style.display == "")
            bbtnModAprDept = "1";

        if (document.getElementById("tbtnTotalSave").style.display == "")
            btbtnTotalSave = "1";

        if (document.getElementById("btntotaldocinfo").style.display == "")
            bbtntotaldocinfo = "1";       
    }
    else {
        if (bbtnApprove == "1")
            setMenuBar("btnApprove", true);

        if (bbtnReject == "1")
            setMenuBar("btnReject", true);

        if (bbtnStay == "1")
            setMenuBar("btnStay", true);

        if (bbtnModAprLine == "1")
            setMenuBar("btnModAprLine", true);

        if (bbtnEdit == "1")
            setMenuBar("btnEdit", true);

        if (bbtnOpinion == "1")
            setMenuBar("btnOpinion", true);

        if (bbtnFileAttach == "1")
            setMenuBar("btnFileAttach", true);

        if (bbtnAprDocAttach == "1")
            setMenuBar("btnAprDocAttach", true);

        if (bbtnPrint == "1")
            setMenuBar("btnPrint", true);

        if (bbtnSave == "1")
            setMenuBar("btnSave", true);

        if (bbtnMail == "1")
            setMenuBar("btnMail", true);

        if (bbtnSetTaskCode == "1")
            setMenuBar("btnSetTaskCode", true);

        if (bbtnAddSepAttach == "1")
            setMenuBar("btnAddSepAttach", true);

        if (bbtnhistory == "1")
            setMenuBar("btnhistory", true);

        if (bbtnModAprDept == "1")
            setMenuBar("btnModAprDept", true);

        if (bbtnDocInfo == "1")
            setMenuBar("btnDocInfo", true);

        if (btbtnTotalSave == "1")
            setMenuBar("tbtnTotalSave", true);

        if (bbtntotaldocinfo == "1")
            setMenuBar("btntotaldocinfo", true);
    }
}
function getDocInfo() {
    try {
        xmldoc = document.getElementById("DOCINFO").dataSource;
        var APRSTATE = GetElementsByTagName(xmldoc, "DOCSTATE");
        if (getNodeText(APRSTATE[0]) == strAprState5)
            setMenuBar("btnStay", false);

        var opinionNode = GetElementsByTagName(xmldoc, "HASOPINIONYN");
        pHasOpinionYN = getNodeText(opinionNode[0]);

        var objNodes = xmldoc.documentElement.childNodes;
        if (objNodes) {
            tempSecurity = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[19]);
            tempKeep = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[20]);
            tempUrgent = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[21]);
            tempPublic = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[18]);
            tempKeyword = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[25]);
            tempItemCode = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[23]);
            tempItemName = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[24]);
            tempItemName2 = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[37]);
            pSummery = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[35]);
            pSpecialRecordCode = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[26]);
            pPublicityCode = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[27]);
            pLimitRange = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[28]);
            pPageNum = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[29]);
            cabinetID = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[30]);
            TaskCode = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[31]);
            tempSecurityDate = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[36]);
        }
    } catch (e) {
        alert("getDocInfo :: " + e.description);
    }
}
function getApprovInfo() {
    try {
        pOrgAprUserID = OrgAprUserID;
        pOrgAprUserName = OrgAprUserName;
        pOrgAprUserName2 = OrgAprUserName2;
        pOrgAprUserDeptID = OrgAprUserDeptID;

    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getApproveDocInfo.do",
    		data : {
    			docID : pDocID,
    			userID : pUserID,
    			deptID : OrgAprUserDeptID
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});
    	
        var xmlpara = createXmlDom();


        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/DOCINFO");
        var xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("DOCINFO").dataSource = xmlpara;

        pFormID = getNodeText(SelectSingleNodeNew(xmlpara, "DOCINFO/DATA/FORMID"));
        pOrgDocID = getNodeText(SelectSingleNodeNew(xmlpara, "DOCINFO/DATA/ORGDOCID"));

        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/ATTACHINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("ATTACHINFO").dataSource = xmlpara;

        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/APRLINEINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("APRLINEINFO").dataSource = xmlpara;

        var dataNodes = GetElementsByTagName(xmlpara, "DATA6");
        var lastIdx = dataNodes.length;
        drafterDeptid = getNodeText(dataNodes[lastIdx - 1]);

        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/DOCFLAGINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);

        var node = GetElementsByTagName(xmlpara, "DocHref");
        pDocHref = getNodeText(node[0]);
        var node = GetElementsByTagName(xmlpara, "DocFlag");
        pDraftFlag = getNodeText(node[0]);

        var doctitle = GetElementsByTagName(result, "DOCTITLE");

        var docflagnode = GetElementsByTagName(xmlpara, "DocFlagValue");
        switch (trim(pDraftFlag)) {
            case "DRAFT":
                pDocType = getNodeText(docflagnode[0]);
                break;

            case "GONGRAM":
                pOrgDocID = getNodeText(docflagnode[0]);
                GetChildNodes(document.getElementById("btnApprove"))[0].innerHTML = strLang10;
                setMenuBar("btnJunKyul", false);
                break;

            case "CHAMJO":
                pOrgDocID = getNodeText(docflagnode[0]);
                GetChildNodes(document.getElementById("btnApprove"))[0].innerHTML = strLang10;
                setMenuBar("btnJunKyul", false);
                setMenuBar("btnReject", false);
                setMenuBar("btnStay", false);
                setMenuBar("btnOpinion", false);
                setMenuBar("btnFileAttach", false);
                setMenuBar("btnAprDocAttach", false);
                setMenuBar("btnEdit", false);
                break;

            case "HABYUI":
                setMenuBar("btnEdit", false);
                setMenuBar("btnModAprDept", false);
                setMenuBar("btnFileAttach", false);
                setMenuBar("btnAprDocAttach", false);
                break;

            case "SUSIN":
                pOrgDocID = getNodeText(docflagnode[0]);
                break;

            case "GAMSA":
                setMenuBar("btnApprove", true);
                setMenuBar("btnReject", false);
                setMenuBar("btnStay", false);
                setMenuBar("btnJunKyul", false);
                setMenuBar("btnModAprLine", false);
                setMenuBar("btnModAprDept", false);
                setMenuBar("btnAprDocAttach", false);
                setMenuBar("btnEdit", false);
                setMenuBar("btnFileAttach", false);
                break;

            case "B_GAMSA":
                setMenuBar("btnApprove", true);
                setMenuBar("btnReject", false);
                setMenuBar("btnStay", false);
                setMenuBar("btnJunKyul", false);
                setMenuBar("btnModAprLine", false);
                setMenuBar("btnModAprDept", false);
                setMenuBar("btnAprDocAttach", false);
                setMenuBar("btnEdit", false);
                setMenuBar("btnFileAttach", false);
                break;

        }
        pOrgAttach = "";

    } catch (e) {
        alert("getApprovInfo :: " + e.description);
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

        var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left;

        window.open(wfileLocation, "view", param);
    } catch (e) {
        alert("openwindow :: " + e.description);
    }
}
function getCurApproverAprLine() {
	var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/aprLineRequest.do",
		data : {
				docID    : pDocID, 
				userID 	 : "",
				formID   : "",
				deptID   : arr_userinfo[4]
				},
		success: function(xml){
			result = xml;
		}        			
	});
    
    Resultxml = result;

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
    LastKyulSN = getLastSignSN(objNodes);
    LastSignSN = objNodes.length;

    for (var i = 0; i < objNodes.length; i++) {
        var params = new Array();
        params[0] = "0";
        var dataNodes = GetLastChildNodes(objNodes[i], params);

        var pCurrentAprState = getNodeText(dataNodes[12]);
        if ((getNodeText(dataNodes[4]).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5))) {
            pAprLineType = getNodeText(dataNodes[11]);

            if (i < 1)
                pAprLineB4type = "";
            else
                pAprLineB4type = getNodeText(GetLastChildNodes(objNodes[i - 1], params)[11]);

            if (pAprLineType == strAprType4 || pAprLineType == strAprType16)
                var pTmpAprLineType = strAprType1;

            pAprMemberSN = AprLineSNCount(pAprLineType, objNodes, pTmpAprLineType);
            break;
        }
    }
    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType2)
        setMenuBar("btnJunKyul", false);
}
function SaveApproveInfo(pApproveFlag) {
    SaveFile();
    SignSave();

    var fields = message.GetFieldsList();
    var field;

    var objNodes = GetChildNodes(GetChildNodes(document.getElementById('DOCINFO').dataSource.childNodes[0])[0]);

    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", getNodeText(objNodes[0]));
    createNodeAndInsertText(xmlpara, objNode, "FormID", getNodeText(objNodes[1]));
    createNodeAndInsertText(xmlpara, objNode, "OrgDocID", getNodeText(objNodes[2]));
    createNodeAndInsertText(xmlpara, objNode, "DocType", getNodeText(objNodes[3]));
    createNodeAndInsertText(xmlpara, objNode, "DocState", getNodeText(objNodes[4]));
    createNodeAndInsertText(xmlpara, objNode, "FunctionType", "002");
    createNodeAndInsertText(xmlpara, objNode, "Href", getNodeText(objNodes[6]));

    var field = message.GetListItem(fields, "doctitle");
    pDocTitle = field.textContent;
    createNodeAndInsertText(xmlpara, objNode, "DocTitle", pDocTitle);

    var field = message.GetListItem(fields, "deptshortedname");
    if (field) {
        createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
    }
    else {

        var field = message.GetListItem(fields, "docnumber");
        if (field)
            createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
        else {
            var field = message.GetListItem(fields, "bedocnumber");
            if (field)
                createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
            else
                createNodeAndInsertText(xmlpara, objNode, "DocNo", "");
        }
    }

    if (pHasAttachYN == "")
        createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", getNodeText(objNodes[9]));
    else
        createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);

    var objNode;

    if (pHasOpinionYN == "")
        createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", getNodeText(objNodes[10]));
    else
        createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", pHasOpinionYN);


    createNodeAndInsertText(xmlpara, objNode, "StartDate", "");
    createNodeAndInsertText(xmlpara, objNode, "EndDate", "");
    createNodeAndInsertText(xmlpara, objNode, "WriterID", getNodeText(objNodes[13]));
    createNodeAndInsertText(xmlpara, objNode, "WriterName", getNodeText(objNodes[14]));
    createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", getNodeText(objNodes[15]));
    createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", getNodeText(objNodes[16]));
    createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", getNodeText(objNodes[17]));
    createNodeAndInsertText(xmlpara, objNode, "Html", "");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pOrgAprUserID);
    createNodeAndInsertText(xmlpara, objNode, "pUserName", pOrgAprUserName);
    createNodeAndInsertText(xmlpara, objNode, "pDeptID", pOrgAprUserDeptID);
    createNodeAndInsertText(xmlpara, objNode, "OrgHtml", "");

    createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
    createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
    createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);
    createNodeAndInsertText(xmlpara, objNode, "proxyuserid", pingUserID);

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

    createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", getNodeText(SelectSingleNodeNew(xmldoc, "DOCINFO/DATA/WRITERNAME2"))); 
    createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", getNodeText(SelectSingleNodeNew(xmldoc, "DOCINFO/DATA/WRITERJOBTITLE2")));
    createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", getNodeText(SelectSingleNodeNew(xmldoc, "DOCINFO/DATA/WRITERDEPTNAME2")));

    createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", pOrgAprUserName2);
    createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);

    if (pApproveFlag == "1") {
        xmlhttp.open("POST", "/ezApprovalG/doApprov.do", false);
    } else if (pApproveFlag == "2") {
        xmlhttp.open("POST", "/ezApprovalG/doBansongApprov.do", false);
    } else if (pApproveFlag == "3") {
        xmlhttp.open("POST", "/ezApprovalG/doBoryuApprov.do", false);
    }
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    if (getNodeText(dataNodes[0]) != "TRUE") {
        SaveOrgFile();
    }
    return getNodeText(dataNodes[0]);
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
function SaveFile() {
	var result = "";
    var mhtBody = "";
    mhtBody = message.Get_EditorBodyHTML();

    EmbedContentIntoXML(mhtBody);

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
function SaveOrgFile() {
	var result = "";
    var objNode;

    var mhtBody = "";
    var HTML = document.createElement("HTML");
    var HEAD = document.createElement("HEAD");
    var META = document.createElement("META");
    META.content = "text/html; charset=utf-8";
    META.httpEquiv = "Content-Type";
    var META2 = document.createElement("META");
    META2.name = "GENERATOR";
    META2.content = "MSHTML 10.00.9200.16721";
    HEAD.appendChild(META);
    HEAD.appendChild(META2);
    HTML.appendChild(HEAD);
    var BODY = document.createElement("BODY");
    Doc_ContentHtml = document.createElement("DIV");
    Doc_ContentHtml.innerHTML = OrgHtml;
    BODY.appendChild(Doc_ContentHtml);
    HTML.appendChild(BODY);

    mhtBody = HTML.outerHTML;
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
function openApproveDocList() {
    var parameter = "";
    var url = "AprDocList.html";
    var feature = "status:no;dialogHeight: 410px; dialogWidth: 387px; resizable: no; help: no;edge:sunken;scroll:no";
    feature = feature + GetShowModalPosition(387, 430);
    var rvalue = window.showModalDialog(url, parameter, feature);
    return rvalue;
}
function openAprLineUI() {
    var pChangeAprLineparameter = new Array();
    var pFormID;
    pFormID = GetAprDocFormID(pDocID);

    CheckDocCellInfo();

    pChangeAprLineparameter[0] = pDocID;
    pChangeAprLineparameter[1] = pFormID;
    pChangeAprLineparameter[2] = SignCount;
    pChangeAprLineparameter[3] = SignInfo;
    pChangeAprLineparameter[4] = hapyuiCount;
    pChangeAprLineparameter[5] = pDraftFlag;
    pChangeAprLineparameter[6] = pSuSinFlag;
    pChangeAprLineparameter[7] = pChamJoFlag;
    pChangeAprLineparameter[8] = gongramCount;
    pChangeAprLineparameter[9] = true;
    pChangeAprLineparameter[10] = pDocType;
    pChangeAprLineparameter[11] = gamsaCount;
    pChangeAprLineparameter[12] = "";
    pChangeAprLineparameter[13] = pOrgAprUserID;
    pChangeAprLineparameter[14] = aprlineinfoTMP;

    var URL = "../ezAPRLINE/aprline_Cross.aspx";
    var parameter = "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";
    parameter = parameter + GetShowModalPosition(990, 720);
    var ret = window.showModalDialog(URL, pChangeAprLineparameter, parameter);
    return ret;
}
function CheckDocCellInfo() {
    var fields = message.GetFieldsList();
    var field;
    var fieldname;
    var pSusinNextSN;

    var SignInfoFlag = true;
    hapyuiCount = 0;
    SignCount = 0;
    gongramCount = 0;

    for (i = 0 ; i < fields.length ; i++) {
        var field = fields[i];

        if (pDraftFlag == "SUSIN") {
            var pSignSusin = pSusinSN + "sign";
            if (field.id.substr(0, 5) == pSignSusin) {
                SignCount = SignCount + 1;
            }
        } else {
            if (field.id.substr(0, 4) == "sign") {
                SignCount = SignCount + 1;
            }
        }

        if (pDraftFlag == "SUSIN") {
            var pSignSusin = pSusinSN + "habyuisign";
            if (field.id.substr(0, 11) == pSignSusin) {
                hapyuiCount = hapyuiCount + 1;
            }
        } else {
            if (field.id.substr(0, 10) == "habyuisign") {
                hapyuiCount = hapyuiCount + 1;
            }
        }
        if (field.id.substr(0, 9) == "gamsasign") {
            gamsaCount = gamsaCount + 1;
        }
        if (field.id.substr(0, 7) == "gongram") {
            gongramCount = gongramCount + 1;
        }
        if (field.id.substr(0, 5) == "jikwe") {
            if (SignInfoFlag) {
                SignInfo = field.textContent;
                SignInfoFlag = false;
            } else {
                SignInfo = field.textContent + ";" + SignInfo;
            }
        }
    }
    pSuSinFlag = "N";
    if (pDraftFlag != "SUSIN") {

        var RtnVal = message.GetListItem(fields, "recipient");;
        if (RtnVal != null) {
            pSuSinFlag = "Y";
        } else {
            pSuSinFlag = "N";
        }
    }
    pSusinNextSN = parseInt(pSusinSN) + 1;

    fieldname = pSusinNextSN + "sign1";
    var field;
    field = message.GetListItem(fields, fieldname);
    if (field)
        pSuSinFlag = "Y";
    pChamJoFlag = "Y";
}
function ReAprLineSingMapping(ret) {
    var xmlKuljea, chamjo, hapyuiCnt, SignCnt, referCnt, xmlReDraft;
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

    if (ret[5] == undefined) {
        xmlKuljea = ret[0];
        xmlReDraft = ret[2];
    }
    else {
        xmlKuljea = ret[1];
        xmlReDraft = ret[5];
    }

    var xmldom = createXmlDom();
    xmldom = loadXMLString(xmlKuljea);
    var objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    var fields = message.GetFieldsList();
    var findstring;
    var lastno;

    var count = objNodes.length;
    field = message.GetListItem(fields, "refer");
    if (field) {
        field.textContent = " ";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    for (i = 1; i < fields.length; i++) {
        field = message.GetListItem(fields, "gongram" + i);
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }

    for (i = 0; i < count; i++) {
        var dataNodes = GetChildNodes(objNodes[i]);

        var KyljeaOrder = getNodeText(dataNodes[0]);
        var KyljeaName = getNodeText(dataNodes[1]);
        var KyljeaDeptName = getNodeText(dataNodes[3]);
        var KyljeaTypeName = getNodeText(dataNodes[4]);
        var KyljeaType = getNodeText(dataNodes[16]);
        var KyljeaStat = getNodeText(dataNodes[17]);
        var KyljeaStatName = getNodeText(dataNodes[5]);
        var KyljeaJobtitle = getNodeText(dataNodes[2]);
        var ReasonDoNotApprov = getNodeText(dataNodes[12]);
        var suggester = getNodeText(dataNodes[13]);
        var reporter = getNodeText(dataNodes[14]);

        OrderType[KyljeaOrder] = KyljeaType;
        OrderTypeName[KyljeaOrder] = KyljeaTypeName;
        OrderName[KyljeaOrder] = KyljeaName;
        OrderDept[KyljeaOrder] = KyljeaDeptName;
        OrderStat[KyljeaOrder] = KyljeaStat;
        OrderStatName[KyljeaOrder] = KyljeaStatName;
        OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
        OrderReason[KyljeaOrder] = ReasonDoNotApprov;
        OrderReason[KyljeaOrder] = ReasonDoNotApprov;
        OrderSuggester[KyljeaOrder] = suggester;
        OrderReporter[KyljeaOrder] = reporter;
        lastno = i;
    }

    if (isSplit == "Y")
        SplitSign(OrderType, OrderName, OrderDept, OrderStat, OrderJobtitle);

    if (pDraftFlag != "SUSIN") {
        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];
        var field = message.GetListItem(fields, "lastKyuljikwee");
        if (field)
            field.textContent = lastKyuljiwee;

        var field = message.GetListItem(fields, "lastKyulName");
        if (field)
            field.textContent = lastKyulName;
    }
    else {
        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];
        var field = message.GetListItem(fields, "slastKyuljikwee");
        if (field)
            field.textContent = lastKyuljiwee;

        var field = message.GetListItem(fields, "slastKyulName");
        if (field)
            field.textContent = lastKyulName;
    }

    var hapyuiCnt = 1;
    var startIdx = 0;

    for (i = 1; i < OrderStat.length; i++) {
        if (OrderStat[i] == strAprState1) {
            startIdx = startIdx;
            break;
        }
        else {
            if (OrderStat[i] == strAprState2 || OrderStat[i] == strAprState5)
                startIdx = startIdx + 1;
            else if (OrderType[i] != strAprType2 && OrderType[i] != strAprType7 && OrderType[i] != strAprType9 & OrderType[i] != strAprType11 && OrderType[i] != strAprType12)
                startIdx = startIdx + 1;
            else if (OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)
                hapyuiCnt = hapyuiCnt + 1;
        }
    }
    var refer = "";
    referCnt = 1;
    for (i = 1; i < OrderType.length; i++) {
        if (OrderType[i] == strAprType7) {
            if (referCnt == 1) {
                refer = "";
                refer = refer + OrderName[i];
                referCnt = referCnt + 1;
            }
            else
                refer = refer + ", " + OrderName[i];
        }
    }
    if (refer != "") {
        fieldname = "refer";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            field.textContent = refer;
        }
    }
    var susinSN = "";
    if (pDraftFlag == "SUSIN") {
        susinSN = pSusinSN;
    }
    for (i = startIdx; i < 10; i++) {
        fieldname = susinSN + "jikwe" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        fieldname = susinSN + "sign" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        fieldname = susinSN + "seumyungdate" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
    for (i = 1; i < 50; i++) {
        name = susinSN + "habyuisign" + i;
        field = message.GetListItem(fields, name);
        if (field) {
            if (!trim(field.textContent)) {
                name = susinSN + "habyui" + i;
                field = message.GetListItem(fields, name);
                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }

                fieldname = susinSN + "habyuisign" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }

                fieldname = susinSN + "habyuipositon" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }

                fieldname = susinSN + "habyuidate" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
            }
        }
        else
            break;
    }

    var idx = startIdx;
    var hidx = hapyuiCnt;
    var startOrder = 1;
    for (i = 1; i < OrderStat.length; i++) {
        if (OrderStat[i] == strAprState2 || OrderStat[i] == strAprState5)
            break;
        else
            startOrder = startOrder + 1;
    }

    var chamjocount = 0;
    for (i = startIdx; i < OrderJobtitle.length; i++) {
        if (OrderType[i] == strAprType7) {
            chamjocount = chamjocount + 1;
        }
    }

    var tempLastSignSN = OrderType.length;
    for (i = 1; i < OrderType.length; i++) {
        if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) 
            tempLastSignSN = i;
    }

    for (i = startOrder; i < OrderJobtitle.length; i++) {
        if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3)
        {
            var j, chkflag;
            if (OrderType[i] == strAprType3) {
                chkflag = false;
                for (j = startOrder; j < i; j++) {
                    if (OrderType[j] == strAprType4 || OrderType[j] == strAprType16) {
                        chkflag = true;
                        break;
                    }
                }
                if (!chkflag) {
                    fieldname = susinSN + "jikwe" + idx;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                        field.textContent = OrderJobtitle[i];
                        if (OrderSuggester[i] == "Y")
                            field.textContent = strLang75 + field.textContent;
                        if (OrderReporter[i] == "Y")
                            field.textContent = strLang76 + field.textContent;
                    }

                    fieldname = susinSN + "sign" + idx;
                    field = message.GetListItem(fields, fieldname);
                    if (field)
                        field.innerHTML = OrderName[i] + "<br>" + OrderReason[i];

                    idx = idx + 1;
                    continue;
                }
            }

            if (pDraftFlag == "HABYUI" && (LastSignSN == 1 ||  LastSignSN == i)) {
                for (k = 1; k < 10; k++) {
                    //if(pDraftFlag == "SUSIN" || pDraftFlag == "GAMSABU") 
                    if (pDraftFlag == "SUSIN")
                        signID = pSusinSN + "sign" + k;
                    else
                        signID = "sign" + k;

                    field = message.GetListItem(fields, signID);//CKEDITOR-원본 : field = fields.Item(signID)
                    if (field)
                        LastSignNo = k;
                }
                idx = LastSignNo;
            }

            fieldname = susinSN + "jikwe" + idx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                field.textContent = OrderJobtitle[i];
                if (OrderSuggester[i] == "Y")
                    field.textContent = strLang75 + field.textContent;
                if (OrderReporter[i] == "Y")
                    field.textContent = strLang76 + field.textContent;
            }

            fieldname = susinSN + "sign" + idx;
            field = message.GetListItem(fields, fieldname);
            if (field && pDraftFlag == "HABYUI") {
                field.textContent = OrderName[i];
            }
            idx = idx + 1;
        }

        if (OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
            fieldname = susinSN + "habyui" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                field.textContent = OrderDept[i];
            }

            fieldname = susinSN + "habyuisign" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            }

            fieldname = susinSN + "habyuipositon" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                field.textContent = OrderJobtitle[i];
                if (OrderSuggester[i] == "Y")
                    field.textContent = strLang75 + field.textContent;
                if (OrderReporter[i] == "Y")
                    field.textContent = strLang76 + field.textContent;
            }
            hidx = hidx + 1;
        }
    }

    if (field == message.GetListItem(fields, "lineapr")) {
        if (idx > 5) {
            message.GetListItem(fields, "lineapr").style.display = "";
            for (i = 0; i < message.GetListItem(fields, "lineapr").childNodes.length; i++)
                message.GetListItem(fields, "lineapr").children[i].style.display = "";
        }
        else {
            message.GetListItem(fields, "lineapr").style.display = "";
            for (i = 0; i < message.GetListItem(fields, "lineapr").childNodes.length; i++)
                message.GetListItem(fields, "lineapr").children[i].style.display = "none";
        }
    }

    if (field == message.GetListItem(fields, "linehab")) {
        if (hidx > 5) {
            message.GetListItem(fields, "linehab").style.display = "";
            for (i = 0; i < message.GetListItem(fields, "linehab").childNodes.length; i++)
                message.GetListItem(fields, "linehab").children[i].style.display = "";
        }
        else {
            message.GetListItem(fields, "linehab").style.display = "";
            for (i = 0; i < message.GetListItem(fields, "linehab").childNodes.length; i++)
                message.GetListItem(fields, "linehab").children[i].style.display = "none";
        }
    }

    setMenuBar("btnJunKyul", false);
}
function ChangeHapYuiInfo() {
    var fields = message.GetFieldsList();
    var field;
    var fieldname;
    var i;

    for (i = 1 ; i <= hapyuiCount ; i++) {
        var TmpRtnVal;
        fieldname = "habyuidate" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
            TmpRtnVal = field.textContent;
            TmpRtnVal = trim(TmpRtnVal);
            if (TmpRtnVal == "") {
                fieldname = "habyui" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    field.textContent = "";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
            }
        }
    }
}
var aprsign1_cross_dialogArguments = new Array();
function openSingUI(parameter) { 
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getSignRequest.do",
		data : {
			userID : pingUserID
		},
		success: function(xml){
			result = xml;
		}
	});

    Resultxml = result;

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
    var SignNodeList = objNodes.length;

    if (SignNodeList != 0) {
        var parameter = pingUserID;
        aprsign1_cross_dialogArguments[0] = parameter;
        aprsign1_cross_dialogArguments[1] = openSingUI_Complete;
        DivPopUpShow(350, 310, "/ezApprovalG/aprSign.do");
    }
    else {
        var ret = "NAME";
        Approv_Complete(ret);
    }
}
function SetAutoPropFinal() {
    try {
        var fields = message.GetFieldsList();

        if (!fields) return;

        var CurrentDate;
        var RtnVal = getGyulJeDate();
        var CurrentDate = RtnVal.split(".");
        CurrentDate = CurrentDate[1] + "." + CurrentDate[2];
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
        alert(e.description);
    }
}
function getGyulJeDate() {
    var GyulJeDate;
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getDate.do",
		success: function(text){
			result = text;
		}
	});
	
    GyulJeDate = result;

    return GyulJeDate;
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
function getSusinSNInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp.open("POST", "aspx/getSusinSN.aspx", false);
    xmlhttp.send(xmlpara);

    if (xmlhttp.responseText != "") {
        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        pSusinSN = getNodeText(dataNodes[0]);
    }
}
function setBtnDisableAprLineType() {
    if (pDraftFlag == "SUSIN" || pAprLineType == strAprType7 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
        setMenuBar("btnReject", false);
        setMenuBar("btnStay", false);
        setMenuBar("btnModAprLine", false);
        setMenuBar("btnModAprDept", false);
    }
}
function getLastSignSN(pNodes) {
    var i;
    var aprlineSN;
    var lastaprlineSN;
    var junkyulflag = false;

    aprlineSN = pNodes.length;
    lastaprlineSN = 0;
    for (i = aprlineSN - 1; i >= 0; i--) {
        var params = new Array();
        params[0] = "0";
        var dataNodes = GetLastChildNodes(pNodes[i], params);

        var pCurrentAprType = getNodeText(dataNodes[11]);
        if (pCurrentAprType == strAprType18 || pCurrentAprType == strAprType19 || pCurrentAprType == strAprType1 || pCurrentAprType == strAprType4 || pCurrentAprType == strAprType16 || pCurrentAprType == strAprType3) {
            if (pCurrentAprType == strAprType4) junkyulflag = true;

            switch (pCurrentAprType) {
                case strAprType1:
                    lastaprlineSN = lastaprlineSN + 1;
                    break;

                case strAprType18:
                    lastaprlineSN = lastaprlineSN + 1;
                    break;

                case strAprType19:
                    lastaprlineSN = lastaprlineSN + 1;
                    break;

                case strAprType4:
                    lastaprlineSN = lastaprlineSN + 1;
                    break;

                case strAprType16:
                    lastaprlineSN = lastaprlineSN + 1;
                    break;

                case strAprType3:
                    lastaprlineSN = lastaprlineSN + 1;
                    break;
            }
        }
    }
    return lastaprlineSN
}
function HabyuiResultOpinion() {
    try {
        var parameter = new Array();
        var rtnVal = true;

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

            objXML.loadXMLString(ret);
            var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0)
                rtnVal = true;
            else
                rtnVal = false;
        }
        return rtnVal;
    } catch (e) {
        alert(e.description);
    }
}
function upDateAprLine() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pingUserID);

    xmlhttp.open("POST", "aspx/upDateJunKyul.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText
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

var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd(pPwd, CompleteFunction) {
    var parameter = pPwd

    ezchkpasswd_cross_dialogArguments[0] = parameter;
    if(CompleteFunction != undefined)
        ezchkpasswd_cross_dialogArguments[1] = CompleteFunction;
    else
        ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

    DivPopUpShow(330, 200, "/ezApprovalG/ezchkPasswd.do");
}

function sendMail() {
    var AddressList = makeAddress();

    if (AddressList) {
        if (AddressList.indexOf("@") > 0) {
            if (AddressList != "" && AddressList != "undefind")
                sendMails(AddressList);
        }
    }
}
function sendMails(pAddList) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", DocID);
    createNodeAndInsertText(xmlpara, objNode, "DocURL", pEndDocHref);
    createNodeAndInsertText(xmlpara, objNode, "DocTitle", pDocTitle);
    createNodeAndInsertText(xmlpara, objNode, "To", pAddList);

    xmlhttp.open("POST", "/Eoffice/OWA/Email/aspx/SendDoc.aspx", true);
    xmlhttp.onreadystatechange = SendDoc_after;
    xmlhttp.send(xmlpara);
}
function SendDoc_after() { }
function makeAddress() {
    var address = message.CKEDITOR.instances.editor1.document.$.body.getAttribute("sendMailInfo", 0);
    return address;
}
function getLastOpinon() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getLastOpinonCotent.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}
	});

    var objNodes = GetChildNodes(result.documentElement);
    if (objNodes.length > 0)
        var content = getNodeText(objNodes[0]);

    var fields = message.GetFieldsList();

    var field = message.GetListItem(fields, "memo");
    if (field)
        field.textContent = content;
}
function setMenuBar(id, flag) {
    var strCmd, display_Value

    if (flag)
        display_Value = "";
    else
        display_Value = "none";

    if (document.getElementById(id) != null)
        document.getElementById(id).style.display = display_Value;
}
function setMenuDisable(id, flag) {
    if (flag)
        eval(id).disabled = true;
    else
        eval(id).disabled = false;
}

var aprcabinetattach_cross_dialogArguments = new Array();
function openAaprDocAttachUI() {
    try {
        var parameter = pDocID;

        aprcabinetattach_cross_dialogArguments[0] = parameter;
        aprcabinetattach_cross_dialogArguments[1] = openAaprDocAttachUI_Complete;

        DivPopUpShow(800, 370, "/ezApprovalG/aprCabinetAttach.do");
    } catch (e) {
        alert(e.description);
    }
}

function openAaprDocAttachUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel") {
        setAttachInfo(pDocID, "APR", lstAttachLink);
    }
}
function SignSave() {
    if (SignContent.length > 0) {
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
        xmlhttp.open("Post", "/ezApprovalG/setSignInfo.do", false);
        xmlhttp.send(xmlpara);
    }
}
function SignCheck() {
    var SignXML = createXmlDom();

	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getSignInfo.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}
	});

    if (result == "" || result == null)
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
                        var signWidth = parseInt(field.offsetWidth) - 4 - 15;
                        var signHeight = parseInt(field.offsetHeight) - 4;
                        signWidth = 50;
                        signHeight = 28;

                        var strimg;
                        if (img.length >= 1) {
                            var filename = img[0].split("/")[img[0].split("/").length - 1];
                            strimg = "<img src='" + "/ezApprovalG/approvalGSign.do?fileName=" + filename + "' border=0 embedding='1' ";
                            strimg = strimg + " width=" + signWidth;
                            strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>";
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
function openDocExinfo() {
    var parameter = new Array();
    parameter[0] = tempSecurity;
    parameter[1] = tempUrgent;
    parameter[2] = pSummery;
    parameter[3] = pSpecialRecordCode;
    parameter[4] = pPublicityCode;
    parameter[5] = pLimitRange;
    parameter[6] = pPageNum;
    parameter[7] = tempSecurityDate;

    var url = "../ezDocInfo/ezDocInfoG_Cross.aspx";
    var feature = "status:no;dialogWidth:420px;dialogHeight:605px;help:no;scroll:no;edge:sunken;";
    feature = feature + GetShowModalPosition(420, 605);
    var RtnVal = window.showModalDialog(url, parameter, feature);

    tempSecurity = RtnVal[0];
    tempUrgent = RtnVal[1];
    pSummery = RtnVal[2];
    pSpecialRecordCode = RtnVal[3];
    pPublicityCode = RtnVal[4];
    pLimitRange = RtnVal[5];
    pPageNum = RtnVal[6];
    tempSecurityDate = RtnVal[7];

    setPublicFlag();
}
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
function getPublicLevel(PublicLevel) {
    var strRtn = "";
    var firstFlag = true;
    for (i = 0; i < 8; i++) {
        if (PublicLevel.substring(i, i + 1) == "Y") {
            if (firstFlag) {
                strRtn = "(" + (i + 1);
                firstFlag = false;
            }
            else {
                strRtn = strRtn + "," + (i + 1);
            }
        }
    }
    if (!firstFlag)
        strRtn = strRtn + ")";
    return strRtn;
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
var ezaprhistory_cross_dialogArguments = new Array();
function getHistory() {
    var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID;

    ezaprhistory_cross_dialogArguments[0] = "";
    ezaprhistory_cross_dialogArguments[1] = getHistory_Complete;

    DivPopUpShow(730, 430, URL);
}

function getHistory_Complete() {
    DivPopUpHidden();
}
function UpdateDocHistory(pHtml) {

    var xmlhttp2 = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pHtml", ConvertHTMLtoMHT(pHtml));

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

        var DataNodes = GetChildNodes(xmlhttp.responseXML);
        if (getNodeText(DataNodes[0]) == "TRUE") {
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
	var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "xml",
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
		}        			
	});
    
    var DataNodes = GetChildNodes(result);
    if (getNodeText(DataNodes[0]) == "TRUE") {
    }
    else {
        var pAlertContent = strLang91;
        OpenAlertUI(pAlertContent);
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
function setRecevInfo(ret) {
    var i;
    var strMailAdd = "";
    var precipent = "";
    var precipents = "";
    var mailflag = true;
    var recipflag = true;
    var mailList = "";
    var mailcnt = 0;
    var fields = message.GetFieldsList();

    if (ret == "") {
        var field = message.GetListItem(fields, "hrecipients");
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipient");
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipients");
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
        return;
    }

    var xmldom = createXmlDom();
    xmldom.async = false;
    xmldom = loadXMLString(ret);

    var rows = GetChildNodes(xmldom.documentElement);
    if (rows.length == 0) return;

    var field = message.GetListItem(fields, "hrecipients");
    if (field) {
        field.textContent = " ";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    var field = message.GetListItem(fields, "recipient");
    if (field) {
        field.textContent = " ";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    var field = message.GetListItem(fields, "recipients");
    if (field) {
        field.textContent = " ";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    for (i = rows.length - 1; i >= 0; i--) {
        var params = new Array();
        params[0] = "0";

        var dataNodes = GetChildNodes(rows[i], params);

        if (getNodeText(GetChildNodes(rows[i])[3]) == "Y") {
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
            field.textContent = precipent
            var field = message.GetListItem(fields, "recipients");
            if (field) {
                field.textContent = precipents
                var field = message.GetListItem(fields, "hrecipients");
                if (field)
                    field.textContent = strLang94;
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
                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
            }
        }
    }
}
function openReceivUI() {
    var parameter = new Array();

    isExtDoc = message.CKEDITOR.instances.editor1.document.$.body.getAttribute("EXTDOC", 0);

    if (isExtDoc != "Y") isExtDoc = "N"

    parameter[0] = pFormID;
    parameter[1] = pDocID;
    parameter[2] = "SEND"
    parameter[3] = isExtDoc;
    parameter[4] = pDocType;

    var url = "../ezAPRDEPT/AprDept1_Cross.aspx";
    var feature = "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(855, 530);

    var ret = window.showModalDialog(url, parameter, feature);

    return ret
}
function SendAckForExch(pType, pMode) {
	var result = "";
	var pBody = "";
	var fields = message.GetFieldsList();
	var field = message.GetListItem(fields, "body")
	if (field) {
		pBody = field.textContent;
	}
	else {
		pBody = "";
	}
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/sendAckforExch.do",
		data : {
			docID : pDocID,
			type  : pType,
			mode  : pMode,
			body  : pBody
		},
		success: function(xml){
			result = xml;
		}
	});

}
var NextDocID = "";
var NextDocUserID = "";
var NextDocUserName = "";
var NextDocUserName2 = "";
var NextDocDeptID = "";
var NextDocType = "";
var NextDocState = "";
var NextDocWriterID = "";
var NextDocAprType = "";
var NextDocHref = "";
var NextDocExtended = "";
function getNextDocInfo() {
    try {
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getNextDocInfo.do",
    		data : {
    			docID : pDocID,
    			userID  : pUserID,
    			userDeptID  : arr_userinfo[4]
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});
    	
        NextDocID = "";
        NextDocUserID = "";
        NextDocUserName = "";
        NextDocUserName2 = "";
        NextDocDeptID = "";
        if (result != "") {
            var objNodes = GetChildNodes(result.documentElement);

            if (objNodes.length > 0) {
                NextDocID = getNodeText(objNodes[0]);
                NextDocUserID = getNodeText(objNodes[1]);
                NextDocUserName = getNodeText(objNodes[2]);
                NextDocDeptID = getNodeText(objNodes[3]);
                NextDocType = getNodeText(objNodes[4]);
                NextDocState = getNodeText(objNodes[5]);
                NextDocWriterID = getNodeText(objNodes[6]);
                NextDocAprType = getNodeText(objNodes[7]);
                NextDocHref = getNodeText(objNodes[8]);
                NextDocExtended = getNodeText(objNodes[9]);
            }
        }
    } catch (e) { }
}
function getNextDocOne(tempDocID) {
    try {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", tempDocID);

        xmlhttp.open("Post", "aspx/GetNextDocOne.aspx", false);
        xmlhttp.send(xmlpara);

        NextDocID = "";
        NextDocUserID = "";
        NextDocUserName = "";
        NextDocUserName2 = "";
        NextDocDeptID = "";
        if (xmlhttp.responseText != "") {
            var objNodes = GetChildNodes(xmlhttp.responseXML);
            if (objNodes.length > 0) {
                NextDocID = getNodeText(objNodes[0]);
                NextDocUserID = getNodeText(objNodes[1]);
                NextDocUserName = getNodeText(objNodes[2]);
                NextDocDeptID = getNodeText(objNodes[3]);
                NextDocType = getNodeText(objNodes[4]);
                NextDocState = getNodeText(objNodes[5]);
                NextDocWriterID = getNodeText(objNodes[6]);
                NextDocAprType = getNodeText(objNodes[7]);
                NextDocHref = getNodeText(objNodes[8]);
                NextDocExtended = getNodeText(objNodes[9]);
            }
        }
    } catch (e) { }
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