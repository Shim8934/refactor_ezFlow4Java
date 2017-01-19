var g_szAuthor = "";
var SaveSendBoxFlag = "Y";
var MDrafttitle = "";
var MdraftName = "";
var Mdraftdate = "";
var valueOpinion = "";

function getAprLinefor(mode, docid) {
  	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getLineList.do",
		data : {
			docID : docid,
			mode  : mode,
		},
		success: function(text){
			result = text;
		}			
	});

    return result;
}

var CurrentAprType;
var CurrentAprUserID;
function sendAlertMail(mode, sn, ui) {
    var linelist = getAprLinefor(mode, pDocID)
    var MemberList = createXmlDom();
    MemberList = loadXMLString(linelist);

    if (ui == "DRAFT")
        SendMailApproveMember(MemberList, sn, pDocTitle, arr_userinfo[2], Gyuljedate);
    else {       

        var _pAprMemberSN = sn;
        var objNodes = SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW");
        for (i = 0; i < objNodes.length; i++) {
            if (trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4])) == CurrentAprUserID && trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11])) == CurrentAprType &&
                trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) == "A04003") {
                _pAprMemberSN = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[0])); break;
            }
        }
        var pwriterID   = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]);
        var Drafter     = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]);
        var pstartdate  = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]);
        var DocTitle    = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]);

        SendMailApproveMember(MemberList, _pAprMemberSN, DocTitle, Drafter, pstartdate);
    }
}

function SendMailApproveMember(aprLineList,  aprsn, pdrafttitle, pdraftname, pdrafdate) {
    MDrafttitle = pdrafttitle
    MdraftName = pdraftname
    Mdraftdate = pdrafdate   
    var objNodes = SelectNodes(aprLineList, "LISTVIEWDATA/ROWS/ROW");     
    var nextID = "";
    var sn = objNodes.length - aprsn - 1;
    var nextMethod = ""
    
    if (sn >= 0) {
        nextMethod = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[11]));

        if (nextMethod == "A03040" || nextMethod == "A03003") {
            for (var i = sn; i < objNodes.length; i++) {
                nextMethod = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]));
                if (nextMethod == "A03040" || nextMethod == "A03003")
                    sn -= 1
                else
                    break;
            }
        }
        continusendMail(nextMethod, aprLineList, sn);
    }
}

function sendmail(to, eSubject, Drafter, pDraftDate, type, opt, isCheck) {
    var dosend = GetNoticeMail(to, type);  
        if (!dosend && isCheck == undefined)
        return;
    var to = getmailaddress(to);
    var from = "\"" + arr_userinfo[2] + "\" <" + arr_userinfo[8] + ">\ ";
    var Subject = "";
    var Content = "";

    Content = strLang1124 + " : " + eSubject + "<br>";
    if (type == "SIHANG") {
        Content += strLang1107 + " : " + Drafter + "<br>";
    }
    else if (type == "SIMSABANSONG") {
        Content += strLang1108 + " : " + Drafter + "<br>";
    }
    else {
        Content += strLang1109 + " : " + Drafter + "<br>";
    }
    if (pDraftDate != "")
        Content += strLang1110 + " : " + pDraftDate + "<br>";



    if (type == "callback") Subject = strLang1111;
    else if (type == "susin") Subject = strLang1112;
    else if (type == "daeree") Subject = strLang1113;
    else if (type == "bansong") Subject = strLang1114;
    else if (type == "opinion") Subject = strLang1123;
    else if (type == "hesong") Subject = strLang1115;
    else if (type == "approve_complete" && pDraftFlag == "DRAFT") Subject = strLang1116;
    else if (type == "approve_complete" && pDraftFlag == "SUSIN") Subject = strLang1117;
    else if (type == "SIHANG") Subject = strLang1118;
    else if (type == "SIMSABANSONG") Subject = strLang1119;
    else if (type == "SIMSAALERT") Subject = strLang1120;
    else if (type == "hukyul") Subject = strLang1121;
    else Subject = strLang1122;
    Subject += " " + eSubject;

    if (type == "approve_complete" && (pDraftFlag == "DRAFT" || pDraftFlag == "SUSIN")) {
        if (valueOpinion != "") {
            Content = Content + "<br>" + valueOpinion;
        }
    }

    if (type == "bansong" || type == "opinion") {
        if (valueOpinion != "") {
            Content = Content + "<br>" + valueOpinion;
        }
    }

    if (type == "hesong" || type == "SIMSABANSONG") {
        if (valueOpinion != "") {
            Content = Content + "<br>" + valueOpinion;
        }
    }

    Content = "<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>" + Content + "</td></tr></table>";

    try {
            var Result = "";
	        $.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		data : {
	    			Content : Content,
	    			Subject : Subject,
	    			to  : to,
	    			from : from ,
	    			SaveSendBoxFlag : SaveSendBoxFlag
	    		},
	    		url : "/ezApprovalG/mail_intersend.do",
	    		success: function(xml){
	    
	    		}        			
	    	});
    }
    catch (e) {
        alert(e.description);
    }
}


function MakeXmlNode(xmldoc, root, key, value) {
    var childNode = xmldoc.createElement(key);

    try {
        var cDataNode = xmldoc.createCDATASection(String(value));
        childNode.appendChild(cDataNode);
    }
    catch (e) {
        childNode.text = String(value);
    }
    root.appendChild(childNode);
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");

    return (orgStr.replace(re, replaceStr));
}

function GetNoticeMail(UserID, type) {

    if (type == "daeree")
        return true


    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "USERID", UserID);

    xmlhttp.open("Post", "/ezPersonal/getApprovNoticeMail.do", false);
    xmlhttp.send(xmlpara);
    var xmlDocument = createXmlDom();
    xmlDocument = loadXMLString(xmlhttp.responseText);

    var s_alertMail = 0;
    var s_completeMail = 0;
    var s_bansongMail = 0;
    var s_callbackMail = 0;
    var s_hesongMail = 0;

    var objNodes = SelectNodes(xmlDocument, "DATA");
    if (objNodes.length <= 0) {
        return false;
    }
    else {
        s_alertMail     = getNodeText(SelectNodes(xmlDocument, "DATA/ALERT")[0]); 
        s_completeMail  = getNodeText(SelectNodes(xmlDocument, "DATA/COMPLETE")[0]);  
        s_bansongMail   = getNodeText(SelectNodes(xmlDocument, "DATA/BANSONG")[0]); 
        s_callbackMail  = getNodeText(SelectNodes(xmlDocument, "DATA/CALLBACK")[0]);   
        s_hesongMail    = getNodeText(SelectNodes(xmlDocument, "DATA/HESONG")[0]);  
        SaveSendBoxFlag = getNodeText(SelectNodes(xmlDocument, "DATA/SAVEMAILFLAG")[0]);  
    }


    if (type == "" || type == "susin" || type == "SIHANG" || type == "SIMSAALERT" || type == "hukyul") {
        if (s_alertMail == 1)
            return true;
        else
            return false;

    }
    
    else if (type == "approve_complete") {
        if (s_completeMail == 1)
            return true;
        else
            return false;

    }
    
    else if (type == "hesong") {
        if (s_hesongMail == 1)
            return true;
        else
            return false;
    }
    
    else if (type == "bansong" || type == "SIMSABANSONG" || type == "opinion") {
        if (s_bansongMail == 1)
            return true;
        else
            return false;
    }
    
    else if (type == "callback") {
        if (s_callbackMail == 1)
            return true;
        else
            return false;
    }

}

function getmailaddress(id) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "id", id);

    xmlhttp.open("POST", "/ezApprovalG/getMailAddress.do", false);
    xmlhttp.send(xmlpara);

    var RtnVal = xmlhttp.responseText;


    return RtnVal;
}

function continusendMail(nextMethod, aprlinelist, sn) { 
    var objNodes = SelectNodes(aprlinelist, "LISTVIEWDATA/ROWS/ROW"); 
    var nextID = "";
    var Method = "";
    var i = sn;

    if (nextMethod == "A03009" || nextMethod == "A03012") {
        if (CurrentAprType != "A03009" && CurrentAprType != "A03012") {
            var isstop = false;
            for (i = sn; i > -1; i--) {
                if (objNodes.length != "0") {

                    nextID = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]));
                    Method = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]));

                    if (Method == nextMethod)
                        isstop = false;
                    else
                        isstop = true;

                }

                if (isstop == true) {
                    break;
                    return;

                }
                else {  
                    sendNextMail(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[5]), nextID, Method);
                }

            }  

        }
        else {
            for (i = 0; i < objNodes.length; i++) {
                if (trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11])) == "A03009" && trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) != "A04003")
                    return;
            }
            var Tempsn = sn > 0 ? sn - 1 : sn;
            Method = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[Tempsn])[0])[11]))
            continusendMail(Method, aprlinelist, Tempsn);
        }
    }
        
    else if (nextMethod == "A03007") {

        
        var isstop = false;
        var isLastman = "N";

        for (i = sn; i > -1; i--) {

            sn = i;

            if (objNodes.length != "0") {

                nextID = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]));
                Method = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]));

                if (Method == nextMethod)
                    isstop = false;
                else
                    isstop = true;


                if (isstop == true) {
                    break;
                }
                else {  

                    sendNextMail(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[5]), nextID, Method);

                    if (i == 0) {  
                        isLastman = "Y";
                    }


                }
            }
            else { break; return; }

        }

        if (sn >= 0 && isLastman == "N")
            continusendMail(Method, aprlinelist, sn);
        return; 
    }
    else {
        if (sn == objNodes.length || sn < 0)  
            return;

        if (CurrentAprType == "A03009") {
            for (var i = sn + 1; i < objNodes.length; i++) {
                if (trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) != "A04003" && trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) != "A04010")
                    return;
            }
        }

        nextID = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[4]));
        Method = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[11]));
        sendNextMail(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[5]), nextID, Method);
    }
}

function sendNextMail(isDept, nextID, Method) {
    if (isDept == "Y") {
        sendmailBusu(nextID, Method);
    }
    else {
        sendmail(nextID, MDrafttitle, MdraftName, Mdraftdate, "", "");
    }
}

function sendmailBusu(deptid, Method) {
    if (deptid == "")
        return;

    else {
        var receiveDeptID = deptid;

        var receiverList = receiverIDList(receiveDeptID);


        if (receiverList == "")
            return;
        else {
            var receiverID = receiverList.split(";");

            for (var j = 0; j < receiverID.length - 1; j++) {
                var NextUser = receiverID[j];

                sendmail(NextUser, MDrafttitle, MdraftName, Mdraftdate, "susin", "");
            }
        }
    }
}

function receiverIDList(preceiveDeptID) {

	var RtnVal = "";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getReceiverList.do",
		data : {
			receiveDeptID : preceiveDeptID
				},
		success: function(xml){
			RtnVal = xml;
		}
	});
    var xmlDocument = createXmlDom();
    xmlDocument = loadXMLString(RtnVal);

    if (xmlDocument.documentElement.childNodes.length <= 0)
        return "";


    var objNodes =   SelectNodes(xmlDocument, "DATA/ROW");
    var receiveDeptIDlist = "";

    var receiverID = "";
    var receiverlist = "";
    
    if (objNodes.length != "0") {
        for (var sn = 0; sn < objNodes.length; sn++) {
            receiverID = getNodeText(GetElementsByTagName(xmlDocument, "CN").item(sn));
            receiverlist += receiverID + ";";
        }
    }

    return receiverlist;
}

function SendMailToReceiveDept_Approv() {
    var pwriterID = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
    var Drafter = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
    var pstartdate = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]));
    var pDocTitle = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));

    SendMailToReceiveDept(pDocTitle, Drafter, pstartdate, pDocID);
}

function SendMailToReceiveDept(pdrafttitle, pdraftname, pdrafdate, docid) {
    MDrafttitle = pdrafttitle;
    MdraftName = pdraftname;
    Mdraftdate = pdrafdate;
    Mopinion = "";

    var receiveDeptIDlist = new Array();
    receiveDeptIDlist = getreceiveDeptIDlist(docid);

    if (receiveDeptIDlist[0] == "" && receiveDeptIDlist[1] == "")
        return;

    if (receiveDeptIDlist[0] != "") {
        var receiveDeptID = receiveDeptIDlist[0].split(";");
        for (var i = 0; i < receiveDeptID.length - 1; i++) {

            var DeptID = receiveDeptID[i];
            var receiverList = receiverIDList(DeptID);

            if (receiverList == "")
                return;
            else {
                var receiverID = receiverList.split(";");

                for (var j = 0; j < receiverID.length - 1; j++) {
                    var NextUserID = receiverID[j];
                    sendmail(NextUserID, MDrafttitle, MdraftName, Mdraftdate, "susin", "");
                }
            }
        }
    }

    if (receiveDeptIDlist[1] != "") {
        var receiverID = receiveDeptIDlist[1].split(";");

        for (var j = 0; j < receiverID.length - 1; j++) {
            var NextUserID = receiverID[j];
            sendmail(NextUserID, MDrafttitle, MdraftName, Mdraftdate, "susin", "");
        }
    }
}

function GetDocInfoData(mode, filed) {
    try {
        var value = "";
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER"); 
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "mode", mode);
        createNodeAndInsertText(xmlpara, objNode, "fields", filed);

        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("Post", "/ezApprovalG/GetDocInfoMode.do", false);
        xmlhttp.send(xmlpara);

        var xmlDocument = createXmlDom();
        xmlDocument = loadXMLString(xmlhttp.responseText);

        var objNodes = GetChildNodes(xmlDocument.documentElement);

        if (objNodes) {
            if (objNodes.length > 0) {
                value = getNodeText(objNodes[0]);
            }
            else {  
                
                if (flag == "END") {
                    Gyuljedate = GetDocInfoData("APR", "ENDDATE");
                    sendAlertMail();
                    return ""
                }
            }
        }

        return value;
    }
    catch (e) {
        alert(e.description);
        return "";
    }
}

function SendMailBansongtoDrafter() {
    getOpinionInfo(pDocID, "APR");
    if (pDraftFlag == "DRAFT") {
        var pwriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
        var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
        var pstartdate  = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]));
        
        var DocTitle;
        if (pDocTitle) {
            DocTitle = pDocTitle;
        }
        else {
            DocTitle = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));
        }
        var NextUser = pwriterID;

        sendmail(NextUser, DocTitle, Drafter, pstartdate, "bansong", "");
    }

    if (pDraftFlag == "SUSIN") {
        var NextUserID  = trim(getNodeText(GetChildNodes(GetChildNodes(GetElementsByTagName(document.getElementById("APRLINEINFO").dataSource, "ROW")[0])[0])[14]));
        var NextUser    = NextUserID;
        var pwriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
        var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
        var pstartdate  = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]));

        var DocTitle;
        if (pDocTitle) {
            DocTitle = pDocTitle;
        }
        else {
            DocTitle = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));
        }

        sendmail(NextUser, DocTitle, Drafter, pstartdate, "bansong", "");
    }
}

function LastHapyui() {
    var orgID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[2]));
    var rtn = getSameOrgHAPYUIDoc(orgID);

    if (rtn != 0) {
        var linelist = getAprLinefor("APR", orgID);
        var MemberList = createXmlDom();
        MemberList = loadXMLString(linelist);

        var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
        var pstartdate  = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]));
        var pDocTitle   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));

        SendMailApproveMember(MemberList, rtn, pDocTitle, Drafter, pstartdate);
    }
}

function getSameOrgHAPYUIDoc(orgID) {
    var xmlpara = createXmlDom();
    
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");  
    createNodeAndInsertText(xmlpara, objNode, "porgID", orgID);

    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("Post", "/myoffice/ezApprovalG/aspx/getSameOrgHAPYUIDoc.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}

function SendMailToDrafter() {
    var pwriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
    var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
    var pDocTitle   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));    
    var NextUser = pwriterID;
    var startDate = GetDocInfoData("END", "ENDDATE");
    getOpinionInfo(pDocID, "END");
    sendmail(NextUser, pDocTitle, Drafter, startDate, "approve_complete", "");
}

function SendMailToDrafter_Hesong() {
    var pwriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
    var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
    var pDocTitle   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));
    var NextUser = pwriterID;
    
    getOpinionInfo(pDocID, "APR");
    sendmail(NextUser, pDocTitle, Drafter, "", "hesong", "");
}

function trim(str)
{
   return str.replace(/(^\s*)|(\s*$)/g, "");
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

function SendSimsaAlertmail(simsaID, title)
{
    if (simsaID != "") {
        sendmail(simsaID, title, arr_userinfo[2], "", "SIMSAALERT", "");
    }
}


function SendSihangMail(title) {
    if (recDeptIDs == "")
        return;

    var receiveDeptID = recDeptIDs.split(";");


    for (var i = 0; i < receiveDeptID.length - 1; i++) {

        var DeptID = receiveDeptID[i];

        var receiverList = receiverIDList(DeptID)

        if (receiverList != "") {
            var receiverID = receiverList.split(";");

            for (var j = 0; j < receiverID.length - 1; j++) {
                var NextUser = receiverID[j];
                sendmail(NextUser, title, arr_userinfo[2], "", "SIHANG", "");
            }
        }
    }

}


function getreceiveDeptIDlist(DocID) {
	var RtnVal = "";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getReceiptinfo.do",
		data : {
				docID : DocID,
				mode  :  "END"
				},
		success: function(xml){
			RtnVal = xml;
		}
	});
    var xmlDocument = createXmlDom();
    xmlDocument = loadXMLString(RtnVal);

    var objNodes =  SelectNodes(xmlDocument, "LISTVIEWDATA/ROWS/ROW");
    
    var receiveDeptIDlist = new Array();
    receiveDeptIDlist[0] = ""; 
    receiveDeptIDlist[1] = "";  
    if (objNodes.length != "0") {
        for (var sn = 0; sn < objNodes.length; sn++) {
            if (trim_Cross(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[7])) == "") {            
                receiveDeptID = trim_Cross(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[1]));
                receiveDeptIDlist[0] += receiveDeptID + ";"
            }
            else {
                receiveDeptUSERID = trim_Cross(getNodeText(GetChildNodes(GetChildNodes(objNodes.item(sn))[0])[7]));
                receiveDeptIDlist[1] += receiveDeptUSERID + ";"
            }
        }
    }
    return receiveDeptIDlist;
}



function SendSimsaBansong(title) {
    var _DrafterID = GetDocInfoData("APR", "WRITERID");
    getOpinionInfo(pDocID, "APR");
    if (_DrafterID != "")
        sendmail(_DrafterID, title, arr_userinfo[2], "", "SIMSABANSONG", "");
}



function SendMailHesong(CurSelRow) {
   
    var NextUserEmail = "";
    var pDocTitle = CurSelRow.cells[0].innerText;
    var draftername = "";

    var xmlpara = createXmlDom();
    
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");  
    createNodeAndInsertText(xmlpara, objNode, "DOCID", CurSelRow.getAttribute("DATA1"));

    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("Post", "./aspx/getdocinfo.aspx", false);
    xmlhttp.send(xmlpara);

    var xmlDocument = createXmlDom();
    xmlDocument = loadXMLString(xmlhttp.responseText);

    var objNodes = SelectNodes(xmlDocument, "DATA");
    var NextUser = getNodeText(GetChildNodes(objNodes[0])[13]);
    draftername = getNodeText(GetChildNodes(objNodes[0])[14]);
    
    getOpinionInfo(CurSelRow.getAttribute("DATA1"), "APR");
    sendmail(NextUser, pDocTitle, draftername, "", "hesong", "");

}



function SendMailToCancel(DocID) {
    var linelist = getAprLinefor("APR", DocID);
    var MemberList = createXmlDom();
    MemberList = loadXMLString(linelist);

alert(linelist);
    var objNodes = SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW");
    var i;

    for (i = 0; i < objNodes.length; i++) {
        var nowstate    = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12]);

        if (nowstate == "A04002")
            break;

    }

    var nextID = getNodeText(GetChildNodes(GetChildNodes(objNodes[i - 1])[0])[4]);
    
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var pCurSelRow = oArrRows[0]; 

    var doctitle = pCurSelRow.cells[0].innerText; 
    var dratertname = pCurSelRow.cells[2].innerText;
    var startdate = pCurSelRow.cells[3].innerText;

    sendmail(nextID, doctitle, dratertname, startdate, "callback", "");
}


function getHapyuitype(pSelectedRow, orgid) {
   
    var sn = getSameOrgHAPYUIDoc(orgid);

    if (sn != 0) {
        var linelist = getAprLinefor("APR", orgid);

        var MemberList = createXmlDom();
        MemberList = loadXMLString(linelist);


        
        var objNodes =  SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW");
        var rsn = objNodes.length - sn;

        var nowMethod   = getNodeText(GetChildNodes(GetChildNodes(objNodes[rsn])[0])[11]);

        if (nowMethod == "A03011") { 

            var Nextid = getNodeText(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[4]);
            var draftername = getNodeText(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[13]);
            
            var doctitle = pSelectedRow.cells[0].innerText; 
            getOpinionInfo(pSelectedRow.getAttribute("DATA1"), "APR");
            sendmail(Nextid, doctitle, draftername, "", "hesong", "");

        }
        else if (nowMethod == "A03012") { 

        var doctitle = pSelectedRow.cells[0].innerText;
            var draftername = getNodeText(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[13]);
            var stardate = getNodeText(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[1]);

            SendMailApproveMember(MemberList, sn, doctitle, draftername, stardate);            
        }
    }

}


function getOpinionInfo(docid, Flag) {
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getOpinionInfo.do",
		data : {
				docID : docid,
				mode  : Flag
				},
		success: function(xml){
			RtnVal = xml;
		}
	});

    var xmlDocument = createXmlDom();
    xmlDocument = loadXMLString(RtnVal);

    var str = "No."
    var TitleList = SelectNodes(xmlDocument, "LISTVIEWDATA/HEADERS/HEADER");
    var txtRtn = "";
    if (TitleList.length > 0) {
        txtRtn = "<table width='750' cellpadding='0' cellspacing='0'><tr align='center' height='30' style='background:#F9F8F8'>"
        txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + str + "</b></td>";
        txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + getNodeText(GetChildNodes(TitleList[1])[0]) + "</b></td>";
        txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + getNodeText(GetChildNodes(TitleList[4])[0]) + "</b></td>";
        txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + getNodeText(GetChildNodes(TitleList[0])[0]) + "</b></td>";
        txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + getNodeText(GetChildNodes(TitleList[2])[0]) + "</b></td>";
        txtRtn = txtRtn + "</tr>"
    }

    var NodeList = SelectNodes(xmlDocument, "LISTVIEWDATA/ROWS/ROW");
    if (NodeList.length > 0) {
        for (i = 0; i < NodeList.length; i++) {
            txtRtn = txtRtn + "<tr align='center' bgcolor='#FFFFFF' height='20'>";
            txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'>" + getNodeText(GetChildNodes(GetChildNodes(NodeList[i])[0])[5])  + "</td>";
            txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'>" + getNodeText(GetChildNodes(GetChildNodes(NodeList[i])[0])[7]) + "</td>";
            txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'>" + getNodeText(GetChildNodes(GetChildNodes(NodeList[i])[0])[11])  + "</td>";
            txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'>" + getNodeText(GetChildNodes(GetChildNodes(NodeList[i])[0])[0])  + "</td>";
            txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid;  BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px' align='left'>" + getNodeText(GetChildNodes(GetChildNodes(NodeList[i])[0])[3])  + "</td>";
            txtRtn = txtRtn + "</tr>";
        }
    }
    if (TitleList.length > 0 && NodeList.length > 0) {
        txtRtn = txtRtn + "</table>";
    } else if (TitleList.length > 0 && NodeList.length <= 0) {
         txtRtn = "";  
    }

    valueOpinion = txtRtn;

}

function SendMailOpiniontoReceptionist(pGubn) {

    if ((LastKyulSN == pAprMemberSN || pAprLineType == "A03004") && pGubn != "BANSONG")
        getOpinionInfo(pDocID, "END");
    else
        getOpinionInfo(pDocID, "APR");

    if (pDraftFlag == "SUSIN" || pDraftFlag == "HABYUI") {
        if (rtnValue[1] == "Receptionist") {

            if ((LastKyulSN == pAprMemberSN || pAprLineType == "A03004") && pGubn != "BANSONG")
                linelist = getAprLinefor("END", pDocID)
            else
                linelist = getAprLinefor("APR", pDocID)

            var xmldoc = DOCINFO.dataSource;
            var objNodes = SelectNodes(xmldoc, "DATA");
            var orgID = trim(GetChildNodes(objNodes[0])[2].textContent);

            if (pDraftFlag == "SUSIN")
                xmldoc = GetEndOrgDocinfoXml(orgID);
            else if (pDraftFlag == "HABYUI")
                xmldoc = GetAprOrgDocinfoXml(orgID);

            objNodes = SelectNodes(xmldoc, "DATA");

            var pwriterID_ = trim(GetChildNodes(objNodes[0])[13].textContent);
            var Drafter_ = trim(GetChildNodes(objNodes[0])[14].textContent);
            var pstartdate_ = trim(GetChildNodes(objNodes[0])[11].textContent);
            var pDocTitle_ = trim(GetChildNodes(objNodes[0])[7].textContent);

            if (pstartdate_ == "" || pstartdate_ == undefined || pstartdate_ == null) {
                pstartdate_ = trim(GetChildNodes(objNodes[0])[12].textContent);
            }

            var approveType = "", approveState = "";

            var xmldoc = createXmlDom();
            xmldoc = loadXMLString(linelist);

            var objNodes = SelectNodes(xmldoc, "ROW");

            var lastSN = objNodes.length - 1;

            var DocTitle;
            if (pDocTitle) {
                DocTitle = pDocTitle;
            } else {
                DocTitle = pDocTitle_
            }
            var NextUser = trim(GetChildNodes(GetChildNodes(objNodes[lastSN])[0])[4].textContent);
            sendmail(NextUser, DocTitle, Drafter_, pstartdate_, "opinion", "", false);
        } else if (rtnValue[1] == "Drafter") {

            var xmldoc = DOCINFO.dataSource;
            objNodes = SelectNodes(xmldoc, "DATA");
            var orgID = trim(GetChildNodes(objNodes[0])[2].textContent);

            if (pDraftFlag == "SUSIN")
                xmldoc = GetEndOrgDocinfoXml(orgID);
            else if (pDraftFlag == "HABYUI")
                xmldoc = GetAprOrgDocinfoXml(orgID);

            objNodes = SelectNodes(xmldoc, "DATA");

            var pwriterID = trim(GetChildNodes(objNodes[0])[13].textContent);
            var Drafter = trim(GetChildNodes(objNodes[0])[14].textContent);
            var pstartdate = trim(GetChildNodes(objNodes[0])[11].textContent);
            var pDocTitle_ = trim(GetChildNodes(objNodes[0])[7].textContent);

            if (pstartdate == "" || pstartdate == undefined || pstartdate == null) {
                pstartdate = trim(GetChildNodes(objNodes[0])[12].textContent);
            }

            var DocTitle;
            if (pDocTitle) {
                DocTitle = pDocTitle;
            }
            else {
                DocTitle = pDocTitle_;
            }
            var NextUser = pwriterID;
            sendmail(NextUser, DocTitle, Drafter, pstartdate, "opinion", "", false);
        }
    }
}

function SendMailOpiniontoDrafter(pGubn) {

    if ((LastKyulSN == pAprMemberSN || pAprLineType == "A03004") && pGubn != "BANSONG")
        getOpinionInfo(pDocID, "END");
    else
        getOpinionInfo(pDocID, "APR");

    if (pDraftFlag == "DRAFT") {

        var xmldoc = DOCINFO.dataSource;
        var objNodes = SelectNodes(xmldoc, "DATA");

        var pwriterID = trim(GetChildNodes(objNodes[0])[13].textContent);
        var Drafter = trim(GetChildNodes(objNodes[0])[14].textContent);
        var pstartdate = trim(GetChildNodes(objNodes[0])[11].textContent);

        if (pstartdate == "" || pstartdate == undefined || pstartdate == null) {
            pstartdate = trim(GetChildNodes(objNodes[0])[12].textContent);
        }


        var DocTitle;
        if (pDocTitle) {
            DocTitle = pDocTitle;
        }
        else {
            DocTitle = trim(GetChildNodes(objNodes[0])[7].textContent);
        }
        var NextUser = pwriterID;
        sendmail(NextUser, DocTitle, Drafter, pstartdate, "opinion", "", false);
    }
}

function SendMailOpiniontoApproveMember(pGubn) {
    if ((LastKyulSN == pAprMemberSN || pAprLineType == "A03004") && pGubn != "BANSONG")
        getOpinionInfo(pDocID, "END");
    else
        getOpinionInfo(pDocID, "APR");

    if (pDraftFlag == "DRAFT") {

        var linelist;
        if ((LastKyulSN == pAprMemberSN || pAprLineType == "A03004") && pGubn != "BANSONG")
            linelist = getAprLinefor("END", pDocID)
        else
            linelist = getAprLinefor("APR", pDocID)


        var approveType = "", approveState = "";
        var xmldoc = createXmlDom();
        xmldoc = loadXMLString(linelist);

        var objNodes = SelectNodes(xmldoc, "ROW");

        var pwriterID_ = trim(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[4].textContent);
        var Drafter_ = trim(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[13].textContent);
        var pstartdate_ = trim(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[2].textContent);
        if (pstartdate_ == "" || pstartdate_ == undefined || pstartdate_ == null) {
            pstartdate_ = trim(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[3].textContent);
        }

        for (var i = 0; i < objNodes.length; i++) {
            approveType = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[11].textContent);
            approveState = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[12].textContent);


            if ((approveType == "A03001" || approveType == "A03002" || approveType == "A03009" || approveType == "A03008" || approveType == "A03040") && approveState == "A04003") {
                var pwriterID = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[4].textContent);
                var Drafter = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[13].textContent);
                var pstartdate = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[2].textContent);
                var DocTitle;
                if (pDocTitle) {
                    DocTitle = pDocTitle;
                } else {
                    DocTitle = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[7].textContent);
                }
                var NextUser = pwriterID;
                if (pOrgAprUserID != pwriterID) { sendmail(NextUser, DocTitle, Drafter_, pstartdate_, "opinion", "", false); }
            }
            else if ((approveType == "A03001" || approveType == "A03002" || approveType == "A03009" || approveType == "A03008" || approveType == "A03040") && approveState == "A04001") {
                var pwriterID = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[4].textContent);
                var Drafter = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[13].textContent);
                var pstartdate = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[2].textContent);
                var DocTitle;
                if (pDocTitle) {
                    DocTitle = pDocTitle;
                } else {
                    DocTitle = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[7].textContent);
                }
                var NextUser = pwriterID;
                if (pOrgAprUserID != pwriterID) { sendmail(NextUser, DocTitle, Drafter_, pstartdate_, "opinion", "", false); }
            }
            else {
                if (approveType == "A03001" && trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[0].textContent) == "1" && pGubn == "BANSONG") {
                    var pwriterID = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[4].textContent);
                    var Drafter = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[13].textContent);
                    var pstartdate = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[2].textContent);
                    var DocTitle;
                    if (pstartdate == "" || pstartdate == undefined || pstartdate == null) {
                        pstartdate = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[3].textContent);
                    }
                    if (pDocTitle) {
                        DocTitle = pDocTitle;
                    } else {
                        DocTitle = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[7].textContent);
                    }
                    var NextUser = pwriterID;

                    if (pOrgAprUserID != pwriterID) { sendmail(NextUser, DocTitle, Drafter_, pstartdate_, "opinion", "", false); }
                }
            }
        }
    }

    if (pDraftFlag == "SUSIN" || pDraftFlag == "HABYUI") {
        var linelist;
        if ((LastKyulSN == pAprMemberSN || pAprLineType == "A03004") && pGubn != "BANSONG")
            linelist = getAprLinefor("END", pDocID)
        else
            linelist = getAprLinefor("APR", pDocID)

        var xmldoc = DOCINFO.dataSource;
        var objNodes = SelectNodes(xmldoc, "DATA");
        var orgID = trim(GetChildNodes(objNodes[0])[2].textContent);
        if (pDraftFlag == "SUSIN")
            xmldoc = GetEndOrgDocinfoXml(orgID);
        else if (pDraftFlag == "HABYUI")
            xmldoc = GetAprOrgDocinfoXml(orgID);

        objNodes = SelectNodes(xmldoc, "DATA");
        
        var pwriterID_ = trim(GetChildNodes(objNodes[0])[13].textContent);
        var Drafter_ = trim(GetChildNodes(objNodes[0])[14].textContent);
        var pstartdate_ = trim(GetChildNodes(objNodes[0])[11].textContent);
        if (pstartdate_ == "" || pstartdate_ == undefined || pstartdate_ == null) {
            pstartdate_ = trim(GetChildNodes(objNodes[0])[12].textContent);
        }
        var pDocTitle_ = trim(GetChildNodes(objNodes[0])[7].textContent);

        var approveType = "", approveState = "";
        var xmldoc = createXmlDom();
        xmldoc = loadXMLString(linelist);

        var objNodes = SelectNodes(xmldoc, "ROW");
        for (var i = 0; i < objNodes.length; i++) {
            approveType = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[11].textContent);
            approveState = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[12].textContent);
            if ((approveType == "A03001" || approveType == "A03002" || approveType == "A03009" || approveType == "A03008" || approveType == "A03040") && approveState == "A04003") {
                var pwriterID = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[4].textContent);
                var DocTitle;
                if (pDocTitle) {
                    DocTitle = pDocTitle;
                } else {
                    DocTitle = pDocTitle_;
                }
                var NextUser = pwriterID;

                if (pOrgAprUserID != pwriterID) { sendmail(NextUser, DocTitle, Drafter_, pstartdate_, "opinion", "", false); }
            }
            else {
                if (approveType == "A03001" && trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[0].textContent) == "1" && pGubn == "BANSONG") {
                    var pwriterID = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[4].textContent);
                    var DocTitle;
                    if (pDocTitle) {
                        DocTitle = pDocTitle;
                    } else {
                        DocTitle = pDocTitle_;
                    }
                    var NextUser = pwriterID;

                    if (pOrgAprUserID != pwriterID) { sendmail(NextUser, DocTitle, Drafter_, pstartdate_, "opinion", "", false); }
                }
            }
        }
    }
}

function SendMailOpiniontoReceptionistAll(pGubn) {
    if ((LastKyulSN == pAprMemberSN || pAprLineType == "A03004") && pGubn != "BANSONG")
        getOpinionInfo(pDocID, "END");
    else
        getOpinionInfo(pDocID, "APR");

    var linelist;
    var xmldoc = DOCINFO.dataSource;
    var objNodes = SelectNodes(xmldoc, "DATA");
    var orgID = trim(GetChildNodes(objNodes[0])[2].textContent);

    if ((LastKyulSN == pAprMemberSN || pAprLineType == "A03004") && pGubn != "BANSONG" || pDraftFlag == "SUSIN")
        linelist = getAprLinefor("END", orgID);
    else
        linelist = getAprLinefor("APR", orgID);

    var approveType = "", approveState = "";
    var xmldoc = createXmlDom();
    xmldoc = loadXMLString(linelist);

    var objNodes = SelectNodes(xmldoc, "ROW");

    var pwriterID_ = trim(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[4].textContent);
    var Drafter_ = trim(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[13].textContent);
    var pstartdate_ = trim(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[2].textContent);
    if (pstartdate_ == "" || pstartdate_ == undefined || pstartdate_ == null) {
        pstartdate_ = trim(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[3].textContent);
    }

    for (var i = 0; i < objNodes.length; i++) {
        approveType = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[11].textContent);
        approveState = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[12].textContent);


        if ((approveType == "A03001" || approveType == "A03002" || approveType == "A03009" || approveType == "A03008" || approveType == "A03040") && approveState == "A04003") {
            var pwriterID = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[4].textContent);
            var Drafter = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[13].textContent);
            var pstartdate = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[2].textContent);
            var DocTitle;
            if (pDocTitle) {
                DocTitle = pDocTitle;
            } else {
                DocTitle = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[7].textContent);
            }
            var NextUser = pwriterID;

            if (pOrgAprUserID != pwriterID) { sendmail(NextUser, DocTitle, Drafter_, pstartdate_, "opinion", "", false); }
        }
        else {
            if (approveType == "A03001" && trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[0].textContent) == "1" && pGubn == "BANSONG") {
                var pwriterID = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[4].textContent);
                var Drafter = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[13].textContent);
                var pstartdate = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[2].textContent);
                var DocTitle;
                if (pstartdate == "" || pstartdate == undefined || pstartdate == null) {
                    pstartdate = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[3].textContent);
                }
                if (pDocTitle) {
                    DocTitle = pDocTitle;
                } else {
                    DocTitle = trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[7].textContent);
                }
                var NextUser = pwriterID;

                if (pOrgAprUserID != pwriterID) { sendmail(NextUser, DocTitle, Drafter_, pstartdate_, "opinion", "", false); }
            }
        }
    }
}

function GetEndOrgDocinfoXml(pOrgDocID) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);

    xmlhttp.open("Post", "../aspx/getEndDocInfo.aspx", false);
    xmlhttp.send(xmlpara);
    xmldoc = xmlhttp.responseXML;

    return xmldoc;
}

function GetAprOrgDocinfoXml(pOrgDocID) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);

    xmlhttp.open("Post", "../aspx/getDocInfo.aspx", false);
    xmlhttp.send(xmlpara);
    xmldoc = xmlhttp.responseXML;

    return xmldoc;
}