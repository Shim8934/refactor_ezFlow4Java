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
			orgCompanyID : orgCompanyID,
			proxyUserFlag : "",
			isMailSendFlag : "Y"
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
    var linelist = "";
    var MemberList = createXmlDom();
    
    /* 2022-02-08 홍승비 - 일괄기안문서의 경우, 알림메일발송 시 1안의 데이터를 기준으로 한다. */
    if (ui == "DRAFTALL" || ui == "DRAFTALL_APPROV") {
    	linelist = getAprLinefor(mode, pDocIDAry[1]);
    } else {
    	linelist = getAprLinefor(mode, pDocID);
    }
    
    MemberList = loadXMLString(linelist);

    if (ui == "DRAFT") {
        SendMailApproveMember(MemberList, sn, pDocTitle, arr_userinfo[2], Gyuljedate);
    } else if (ui == "DRAFTALL") {
    	SendMailApproveMember(MemberList, sn, pDocTitleAry[1], arr_userinfo[2], Gyuljedate);
    }
    else {
    	if (CurrentAprType != "007") {
	        var _pAprMemberSN = sn;
	        var objNodes = SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW");
	        for (i = 0; i < objNodes.length; i++) {
	            if (trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4])) == CurrentAprUserID && trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11])) == CurrentAprType &&
	                trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) == "003") {
	                _pAprMemberSN = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[0])); break;
	            }
	        }
	        
	        var pwriterID = "";
	        var Drafter = "";
	        var pstartdate = "";
	        var DocTitle = "";
	        
	        if (ui == "DRAFTALL_APPROV") { // 일괄기안된 문서 결재 시 분기 추가 (1안의 정보를 전달)
	        	var ifrm1 = document.getElementById("ifrm1");
	        	pwriterID = getNodeText(GetChildNodes(GetElementsByTagName(ifrm1.contentWindow.document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]);
		        Drafter = getNodeText(GetChildNodes(GetElementsByTagName(ifrm1.contentWindow.document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]);
		        pstartdate = getNodeText(GetChildNodes(GetElementsByTagName(ifrm1.contentWindow.document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]);
		        DocTitle = getNodeText(GetChildNodes(GetElementsByTagName(ifrm1.contentWindow.document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]);
	        } else { // 기존 일반 결재 분기
	        	pwriterID = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]);
		        Drafter = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]);
		        pstartdate = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]);
		        //DocTitle = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]);
		        DocTitle = getDocTitleForMail();
	        }
	        
	        SendMailApproveMember(MemberList, _pAprMemberSN, DocTitle, Drafter, pstartdate);
    	}
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

    if (!!isNextBujea(aprLineList, sn)) {
        sn -= 1;
    }
    
    if (sn >= 0) {
        nextMethod = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[11]));

        if (nextMethod == "040" || nextMethod == "003") {
            for (var i = sn; i < objNodes.length; i++) {
                nextMethod = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]));
                if (nextMethod == "040" || nextMethod == "003")
                    sn -= 1
                else
                    break;
            }
        }
        continusendMail(nextMethod, aprLineList, sn);
    }
}

function isNextBujea(aprLineList, sn) {
    if (sn < 0) {
        return "";
    }

    var nextUser = SelectNodes(aprLineList, "LISTVIEWDATA/ROWS/ROW")[sn];
    var nextUserID = getNodeText(GetElementsByTagName(nextUser, "DATA4")[0]);
    var nextUserDeptID = getNodeText(GetElementsByTagName(nextUser, "DATA6")[0]);

    var xhr = new XMLHttpRequest();
    xhr.open("get", "/ezApprovalG/getBujaeInfo.do?userID=" + nextUserID + "&deptID=" + nextUserDeptID, false);
    xhr.send();

    var res = xhr.responseText;

    return res;
}

function sendmail(to, eSubject, Drafter, pDraftDate, type, opt, isCheck, Method) {
    /*var dosend = GetNoticeMail(to, type);  
        if (!dosend && isCheck == undefined)
        return;*/
    var id = to;
    var to = getmailaddress(id);
    var docExt = checkHWP(pDocID);
    var deptid = to.split(",")[2];
    to = to.split(",")[0] + "," + to.split(",")[1];
    var from = "\"" + arr_userinfo[2] + "\" <" + arr_userinfo[8] + ">\ ";
    var Subject = "";
    var Content = "";
    //메일에서 문서 볼 수 있는 문서 생성 변수
    var Approv_a = "";
    Content = "<span>" + strLang1124 + ": " + eSubject + "</span><br>";
    if (type == "SIHANG") {
        Content += "<span>" + strLang1107 + ": " + Drafter + "</span><br>";
    }
    else if (type == "SIMSABANSONG") {
        Content += "<span>" + strLang1108 + ": " + Drafter + "</span><br>";
    }
    else {
        Content += "<span>" + strLang1109 + ": " + Drafter + "</span><br>";
    }
    if (pDraftDate != "") {
    	if (pDraftDate.slice(-2) == ".0") {
    		pDraftDate = pDraftDate.substring(0, pDraftDate.length - 2);
    	}
    	Content += "<span>" + strLang332 + ": " + pDraftDate + "</span><br>";
    }

    if (type == "callback") Subject = strLang1111;
    /* 2021-08-27 홍승비 - 수신메일 알림의 경우 서버단에서 수신자 리스트를 취합하여 스케줄러 또는 즉시 발송되도록 수정되었으므로, 개별 메일 발송 동작은 주석처리함 (insertSendDocDB, sendSusinMail 참조) */
    else if (type == "susin") {Subject = strLang1112; return;}
    else if (type == "daeree") Subject = strLang1113;
    else if (type == "bansong") Subject = strLang1114;
    else if (type == "opinion") Subject = strLang1123;
    else if (type == "hesong") Subject = strLang1115;
    else if (type == "approve_complete" && pDraftFlag == "DRAFT") Subject = strLang1116;
    else if (type == "approve_complete" && pDraftFlag == "SUSIN") Subject = strLang1117;
    else if (type == "SIHANG") Subject = strLang1118;
    else if (type == "SIHANGBANSONG") Subject = strLangHSBSH01; // 시행문 반송알림
    else if (type == "SIMSABANSONG") Subject = strLang1119;
    else if (type == "SIMSAALERT") Subject = strLang1120;
    else if (type == "hukyul") Subject = strLang1121;
    else Subject = strLang1122;
    
    /* 2022-02-11 홍승비 - 일괄기안의 경우, 1안의 문서정보를 삽입하도록 pDocID 변경 분기 추가 */
    var mailDocID = pDocID;
    if (typeof(draftAllFlag) != "undefined" && draftAllFlag == "Y") {
    	/* 2023-04-21 홍승비 > 일괄기안의 경우, 자식 프레임에서 메일을 발송하는 분기처리 추가 */
    	if (typeof(pDocIDAry) != "undefined") { // 부모 페이지에서 접근
    		mailDocID = pDocIDAry[1];
    	} else { // 자식 프레임에서 접근
    		mailDocID = parent.pDocIDAry[1];
    	}
    }
    
    if (Subject == strLang1122) {
    	if (Method != "007") {
    		if (docExt == "hwp") {
    			if (useWebHWP == "YES") {
    				/* 2022-02-23 홍승비 - 일괄기안문서 대응용 분기 추가 */
    				if (typeof(draftAllFlag) != "undefined" && draftAllFlag == "Y" && typeof draftAllTypeB != "undefined" && draftAllTypeB != "Y") { // 일괄기안문서
    					Approv_a += "<span style='font-weight:bold;'>" + Drafter + "</span>"+ "<span>" + strLangSpjj34 + "</span>" + "<a id='approv_a' href ='"+window.location.protocol + "//" + window.location.host+"/ezApprovalG/approvuiAll_WHWP.do?docID="+mailDocID+"&id="+id+"&name="+javaURLEncode(to.split(",")[0])+"&deptID="+deptid+"&allFlag=0&mode=APR&mailchk=Y" + (orgCompanyID == undefined ? "" : "&orgCompanyID=" + orgCompanyID) + "'"+ "data-id='" + mailDocID + "'"+ "data-comp='" + orgCompanyID + "' onclick ='javascript:mail_link();' style='cursor: pointer; color: blue;' target='_blank'><br>"+ strLangSpjj33 + "</a><br><br><span style='font-weight:bold;'>" + strLangjjh04 + "</span><br>";
    				} else { // 기존 단일기안문서
    					Approv_a += "<span style='font-weight:bold;'>" + Drafter + "</span>"+ "<span>" + strLangSpjj34 + "</span>" + "<a id='approv_a' href ='"+window.location.protocol + "//" + window.location.host+"/ezApprovalG/approvuiWHWP.do?docID="+mailDocID+"&id="+id+"&name="+javaURLEncode(to.split(",")[0])+"&deptID="+deptid+"&allFlag=0&mode=APR&mailchk=Y" + (orgCompanyID == undefined ? "" : "&orgCompanyID=" + orgCompanyID) + "'"+ "data-id='" + mailDocID + "'"+ "data-comp='" + orgCompanyID + "' onclick ='javascript:mail_link();' style='cursor: pointer; color: blue;' target='_blank'><br>"+ strLangSpjj33 + "</a><br><br><span style='font-weight:bold;'>" + strLangjjh04 + "</span><br>";
    				}
    			}
    			else
    				Approv_a += "<span style='font-weight:bold;'>" + Drafter + "</span>"+ "<span>" + strLangSpjj34 + "</span>" + "<a id='approv_a' href ='"+window.location.protocol + "//" + window.location.host+"/ezApprovalG/approvuiHWP.do?docID="+mailDocID+"&id="+id+"&name="+javaURLEncode(to.split(",")[0])+"&deptID="+deptid+"&allFlag=0&mode=APR&mailchk=Y" + (orgCompanyID == undefined ? "" : "&orgCompanyID=" + orgCompanyID) + "'"+ "data-id='" + mailDocID + "'"+ "data-comp='" + orgCompanyID + "' onclick ='javascript:mail_link();' style='cursor: pointer; color: blue;' target='_blank'><br>"+ strLangSpjj33 + "</a><br><br><span style='font-weight:bold;'>" + strLangjjh04 + "</span><br>";
    		} else {
    			Approv_a += "<span style='font-weight:bold;'>" + Drafter + "</span>"+ "<span>" + strLangSpjj34 + "</span>" + "<a id='approv_a' href ='"+window.location.protocol + "//" + window.location.host+"/ezApprovalG/approvui.do?docID="+mailDocID+"&id="+id+"&name="+javaURLEncode(to.split(",")[0])+"&deptID="+deptid+"&allFlag=0&mode=APR&mailchk=Y" + (orgCompanyID == undefined ? "" : "&orgCompanyID=" + orgCompanyID) + "'"+ "data-id='" + mailDocID + "'"+ "data-comp='" + orgCompanyID + "' onclick ='javascript:mail_link();' style='cursor: pointer; color: blue;' target='_blank'><br>"+ strLangSpjj33 + "</a><br><br><span style='font-weight:bold;'>" + strLangjjh04 + "</span><br>";
    		}
    	}
    }
    
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

    if (type == "hesong" || type == "SIMSABANSONG" || type == "SIHANGBANSONG") {
        if (valueOpinion != "") {
            Content = Content + "<br>" + valueOpinion;
        } 
    }
    Content = "<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>" + Approv_a + Content +"</td></tr></table>";
    
    console.log("Approv_a  : "+Approv_a);
    
    // 메일 발송 이후 동기적인 추가 동작이 존재하지 않으므로 비동기처리 (async = true)
    try {
        var Result = "";
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : true,
    		data : {
    			Content : Content,
    			Subject : Subject,
    			to  : to,
    			from : from,
				targetUserId: id,
				subType: getNotiSubType(type)
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
    } else {
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
    } else if (type == "approve_complete") {
        if (s_completeMail == 1)
            return true;
        else
            return false;
    } else if (type == "hesong") {
        if (s_hesongMail == 1)
            return true;
        else
            return false;
    } else if (type == "bansong" || type == "SIMSABANSONG" || type == "opinion" || type == "SIHANGBANSONG") {
        if (s_bansongMail == 1)
            return true;
        else
            return false;
    } else if (type == "callback") {
        if (s_callbackMail == 1)
            return true;
        else
            return false;
    }
}

/** @param type [susin, SIHANG, SIMSAALERT, hukyul] = 도착(1)
 * [approve_complete] = 완료(2)
 * [bansong, SIMSABANSONG, opinion] = 반송(3)
 * [callback] = 회수(4)
 * [hesong] = 수신문서 회송(5)
 */
function getNotiSubType(type) {
	if (!type) {
		return 1;
	}

	switch (type.toLowerCase()) {
		case "susin":
		case "sihang":
		case "simsaalert":
		case "hukyul":
			return 1;
		case "approve_complete":
			return 2;
		case "bansong":
		case "simsabansong":
		case "opinion":
			return 3;
		case "callback":
			return 4;
		case "hesong":
			return 5;
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

    if (nextMethod == "009" || nextMethod == "012") {
        if (CurrentAprType != "009" && CurrentAprType != "012") {
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
                if (trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11])) == "009" && trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) != "003")
                    return;
            }
            var Tempsn = sn > 0 ? sn - 1 : sn;
            Method = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[Tempsn])[0])[11]))
            continusendMail(Method, aprlinelist, Tempsn);
        }
    } else {
        if (sn == objNodes.length || sn < 0) {
        	return;
        } 

        if (CurrentAprType == "009") {
        	var alreadySend = false;
        	
            for (var i = sn + 1; i < objNodes.length; i++) {
	            if(trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) == "002"){
	            	nextID = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[4]));
		            Method = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[11]));
		            sendNextMail(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[5]), nextID, Method);
		            alreadySend = true;
	            } else if ((trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) != "003" && trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12])) != "010") || alreadySend) {
                	return;
                }
            }
        }
        
        if (nextMethod == "007") {
        	sendMailToChamJoUsers(sn, nextMethod, objNodes, aprlinelist, true);
        } else {
        	 nextID = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[4]));
             Method = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[11]));
             sendNextMail(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn])[0])[5]), nextID, Method);
             
             if (sn < objNodes.length) {
            	 if(sn-1 >= 0) {
	            	if (trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[sn-1])[0])[11])) == "007") {
	            		sendMailToChamJoUsers(sn - 1, nextMethod, objNodes, aprlinelist, false);
	            	}
            	 }
             }
        }
    }
}

// nextFlag는 참조자들에게 메일을 보낸 후 다음 결재자에게 메일을 보낼지의 여부이다
function sendMailToChamJoUsers(sn, nextMethod, objNodes, aprlinelist, nextFlag) {
	var isstop = false;
    var isLastman = "N";

    for (var i = sn; i > -1; i--) {
        sn = i;

        if (objNodes.length != "0") {
            var nextID = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]));
            var Method = trim(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]));

            if (Method == nextMethod) {
            	isstop = false;
            } else {
            	isstop = true;
            }

            if (isstop == true) {
                break;
            } else {  
                sendNextMail(getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[5]), nextID, Method);
                if (i == 0) {  
                    isLastman = "Y";
                }
            }
        }
        else { break; return; }
    }

    if (nextFlag && sn >= 0 && isLastman == "N") {
    	continusendMail(Method, aprlinelist, sn);
    }
}

function sendNextMail(isDept, nextID, Method) {
    if (isDept == "Y") {
        sendmailBusu(nextID, Method);
    }
    else {
        sendmail(nextID, MDrafttitle, MdraftName, Mdraftdate, "", "", undefined, Method);
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
	// 정주환 #70971 부서 메일 발송 서비스로 변경
	return;
    var pwriterID = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
    var Drafter = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
    var pstartdate = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]));
//    var pDocTitle = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));
    var pDocTitle = getDocTitleForMail();

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

            /* 2021-04-06 홍승비 - 수신부서에 수발신담당자가 존재하지 않는 경우, 다음 부서를 체크하지 않고 바로 루프를 빠져나가는 오류 수정 */
            if (receiverList == "") {
                continue;
            }
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

/**
 *  원하는 문서의 정보를 XML로 변형하는 함수
 *  field에 얻고 싶은 XML field명 입력
 * */
function GetDocInfoData(mode, field) {
    try {
        var value = "";
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER"); 
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "mode", mode);
        createNodeAndInsertText(xmlpara, objNode, "fields", field);

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

/* 2022-02-17 홍승비 - 일괄기안 대응용 함수 분리 */
function GetDocInfoDataForDraftAll(mode, field) {
	try {
		var value = "";
		var xmlpara = createXmlDom();
		var objNode;
		createNodeInsert(xmlpara, objNode, "PARAMETER"); 
		createNodeAndInsertText(xmlpara, objNode, "DocID", pDocIDAry[1]);
		createNodeAndInsertText(xmlpara, objNode, "mode", mode);
		createNodeAndInsertText(xmlpara, objNode, "fields", field);
		
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
			else { // 사용되지 않는 분기로 보임
				if (flag == "END") {
					Gyuljedate = GetDocInfoDataForDraftAll("APR", "ENDDATE");
					sendAlertMail();
					return "";
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
	
	/* 2023-04-21 홍승비 - 일괄기안의 경우, 반송 시 1안의 의견정보를 삽입하도록 pDocID 분기 추가 */
    if (typeof(draftAllFlag) != "undefined" && draftAllFlag == "Y") {
    	if (typeof(pDocIDAry) != "undefined") { // 부모 페이지에서 접근
    		pDocID = pDocIDAry[1];
    	} else { // 자식 프레임에서 접근
    		pDocID = parent.pDocIDAry[1];
    	}
    }
    
    getOpinionInfo(pDocID, "APR");
    
    if (pDraftFlag == "DRAFT") {
    	//기안 문서 반송 메일알림은 원기안자에게
        var pwriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
        var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
        var pstartdate  = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]));
        
        var DocTitle;
        if (pDocTitle) {
            DocTitle = pDocTitle;
        }
        else {
            //DocTitle = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));
        	DocTitle = getDocTitleForMail();
        }
        var NextUser = pwriterID;

        sendmail(NextUser, DocTitle, Drafter, pstartdate, "bansong", "");
    }

    if (pDraftFlag == "SUSIN") {
    	//수신 문서 반송 메일알림은 수신자에게 
    	var susinUserIdx = GetElementsByTagName(document.getElementById("APRLINEINFO").dataSource, "ROW").length-1; 
    	var susinUserID = trim(getNodeText(GetChildNodes(GetChildNodes(GetElementsByTagName(document.getElementById("APRLINEINFO").dataSource, "ROW")[susinUserIdx])[0])[4]));
    	var NextUser = susinUserID;
        var pwriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
        var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
        var pstartdate  = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[11]));

        var DocTitle;
        if (pDocTitle) {
            DocTitle = pDocTitle;
        }
        else {
            //DocTitle = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));
        	DocTitle = getDocTitleForMail();
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
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getSameOrgHAPYUIDoc.do",
		data : {
			docID : orgID
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    return result;
}

function SendMailToDrafter() {
    var pwriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
    var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
//    var pDocTitle   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));    
    var pDocTitle   = getDocTitleForMail();    
    var NextUser = pwriterID;
    var startDate = GetDocInfoData("END", "STARTDATE");
    getOpinionInfo(pDocID, "END");
    sendmail(NextUser, pDocTitle, Drafter, startDate, "approve_complete", "");
}
/* 2022-02-17 홍승비 - 일괄기안 대응을 위한 함수 분리 (1안의 정보에 접근) */
function SendMailToDrafterForDraftAll() {
	var ifrm1 = document.getElementById("ifrm1");
	var pwriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(ifrm1.contentWindow.document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
	var Drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(ifrm1.contentWindow.document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
	var pDocTitle   = trim(getNodeText(GetChildNodes(GetElementsByTagName(ifrm1.contentWindow.document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));
	var NextUser = pwriterID;
	var startDate = GetDocInfoDataForDraftAll("END", "STARTDATE");
	//getOpinionInfo(pDocIDAry[currIdx], "END"); // 이미 SendMailToDrafterForDraftAll 함수 호출 이전에 1안의 의견정보를 대표로 가져온 상태임
	sendmail(NextUser, pDocTitle, Drafter, startDate, "approve_complete", "");
}

function SendMailToDrafter_Hesong(pWriterID, pWirterName, pDocTitle) {
    // var pWriterID   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[13]));
    // var drafter     = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[14]));
    // var pDocTitle   = trim(getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]));
    var NextUser = pWriterID;
    
    getOpinionInfo(pDocID, "APR");
    sendmail(NextUser, pDocTitle, pWirterName, "", "hesong", "");
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
    if (_DrafterID != "") {
    	sendmail(_DrafterID, title, arr_userinfo[2], "", "SIMSABANSONG", "");
    }
}

function SendSihangBansong(title) {
    var _DrafterID = GetDocInfoData("END", "WRITERID");
    var _DrafterName = GetDocInfoData("END", "WRITERNAME");
    getOpinionInfo(pDocID, "END");
    if (_DrafterID != "") {
    	sendmail(_DrafterID, title, _DrafterName, "", "SIHANGBANSONG", "");
    }
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

function SendMailToCancel(DocID, pDocTitle, pDrafterName, pDraftDate) {
    var linelist = getAprLinefor("APR", DocID);
    var MemberList = createXmlDom();
    MemberList = loadXMLString(linelist);

    var objNodes = SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW");
    var i;

    for (i = 0; i < objNodes.length; i++) {
        var nowstate    = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12]);
        
        if (nowstate == "002") {
            break;
        }
    }

    var nextID = getNodeText(GetChildNodes(GetChildNodes(objNodes[i - 1])[0])[4]);
    
    // var DocList = new ListView();
    // DocList.LoadFromID("DocList");
    // var oArrRows = DocList.GetSelectedRows();
    // var pCurSelRow = oArrRows[0]; 
    
    /* 2020-07-31 홍승비 - 의견여부 아이콘이 추가되어 발생한 사이드이펙트 수정 */
    var doctitle = pDocTitle;
    var dratertname = pDrafterName;
    var startdate = pDraftDate;
    
    // 제목, 기안자, 기안일 데이터를 리스트뷰의 셀에서 가져온다. (리스트헤더의 colname 속성 활용)
    // var docListHeader = $("#DocList").find("tr[id='DocList_TH']");
    
    // if (docListHeader.length > 0) {
	//     var docTitleIdx = docListHeader.find("th[colname='DOCTITLE']").index();
	//     var drafterNameIdx = docListHeader.find("th[colname='WRITERNAME']").index();
	//     var startDateIdx = docListHeader.find("th[colname='STARTDATE']").index();
	   
	// 	if (docTitleIdx >= 0) {
	// 		doctitle = pCurSelRow.cells[docTitleIdx].innerText;
	// 	}
	// 	if (drafterNameIdx >= 0) {
	// 		dratertname = pCurSelRow.cells[drafterNameIdx].innerText;
	// 	}
	// 	if (startDateIdx >= 0) {
	// 		startdate = pCurSelRow.cells[startDateIdx].innerText;
	// 	}
    // }
   
    // 기존 리스트뷰에서 하드하게 데이터 가져오는 부분 주석처리
    /*
    var doctitle = pCurSelRow.cells[0].innerText; 
    var dratertname = pCurSelRow.cells[2].innerText;
    var startdate = pCurSelRow.cells[3].innerText;
    */
    
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

        if (nowMethod == "011") { 

            var Nextid = getNodeText(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[4]);
            var draftername = getNodeText(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[13]);
            
            var doctitle = pSelectedRow.cells[0].innerText; 
            getOpinionInfo(pSelectedRow.getAttribute("DATA1"), "APR");
            sendmail(Nextid, doctitle, draftername, "", "hesong", "");

        }
        else if (nowMethod == "012") { 

        var doctitle = pSelectedRow.cells[0].innerText;
            var draftername = getNodeText(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[13]);
            var stardate = getNodeText(GetChildNodes(GetChildNodes(objNodes[objNodes.length - 1])[0])[1]);

            SendMailApproveMember(MemberList, sn, doctitle, draftername, stardate);            
        }
    }

}

/**
 * 해당 문서의 '의견' 정보 추출
 * */
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
            txtRtn = txtRtn + "<td style='BORDER-BOTTOM: black 1px solid;  BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px' align='left'>" + MakeXMLString(getNodeText(GetChildNodes(GetChildNodes(NodeList[i])[0])[3]))  + "</td>";
            txtRtn = txtRtn + "</tr>";
        }
    }
    /**
     *  NodeList.length > 0 의견이 존재하는 경우
     *  NodeList.length <= 0 의견이 존재하지 않는 경우
     */
    if (TitleList.length > 0 && NodeList.length > 0) {
        txtRtn = txtRtn + "</table>";
    } else if (TitleList.length > 0 && NodeList.length <= 0) {
         txtRtn = "";  
    }

    valueOpinion = txtRtn;

}

function SendMailOpiniontoReceptionist(pGubn) {

    if ((LastKyulSN == pAprMemberSN || pAprLineType == "004") && pGubn != "BANSONG")
        getOpinionInfo(pDocID, "END");
    else
        getOpinionInfo(pDocID, "APR");

    if (pDraftFlag == "SUSIN" || pDraftFlag == "HABYUI") {
        if (rtnValue[1] == "Receptionist") {

            if ((LastKyulSN == pAprMemberSN || pAprLineType == "004") && pGubn != "BANSONG")
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

    if ((LastKyulSN == pAprMemberSN || pAprLineType == "004") && pGubn != "BANSONG")
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
    if ((LastKyulSN == pAprMemberSN || pAprLineType == "004") && pGubn != "BANSONG")
        getOpinionInfo(pDocID, "END");
    else
        getOpinionInfo(pDocID, "APR");

    if (pDraftFlag == "DRAFT") {

        var linelist;
        if ((LastKyulSN == pAprMemberSN || pAprLineType == "004") && pGubn != "BANSONG")
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


            if ((approveType == "001" || approveType == "002" || approveType == "009" || approveType == "008" || approveType == "040") && approveState == "003") {
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
            else if ((approveType == "001" || approveType == "002" || approveType == "009" || approveType == "008" || approveType == "040") && approveState == "001") {
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
                if (approveType == "001" && trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[0].textContent) == "1" && pGubn == "BANSONG") {
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
        if ((LastKyulSN == pAprMemberSN || pAprLineType == "004") && pGubn != "BANSONG")
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
            if ((approveType == "001" || approveType == "002" || approveType == "009" || approveType == "008" || approveType == "040") && approveState == "003") {
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
                if (approveType == "001" && trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[0].textContent) == "1" && pGubn == "BANSONG") {
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
    if ((LastKyulSN == pAprMemberSN || pAprLineType == "004") && pGubn != "BANSONG")
        getOpinionInfo(pDocID, "END");
    else
        getOpinionInfo(pDocID, "APR");

    var linelist;
    var xmldoc = DOCINFO.dataSource;
    var objNodes = SelectNodes(xmldoc, "DATA");
    var orgID = trim(GetChildNodes(objNodes[0])[2].textContent);

    if ((LastKyulSN == pAprMemberSN || pAprLineType == "004") && pGubn != "BANSONG" || pDraftFlag == "SUSIN")
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


        if ((approveType == "001" || approveType == "002" || approveType == "009" || approveType == "008" || approveType == "040") && approveState == "003") {
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
            if (approveType == "001" && trim(GetChildNodes(GetChildNodes(objNodes[i])[0])[0].textContent) == "1" && pGubn == "BANSONG") {
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
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getEndDocInfo.do",
		data : {
			docID : pOrgDocID
		},
		success: function(xml){
			result = xml;
		}        			
	});

    return loadXMLString(result);
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

function checkHWP(pDocID) {
	var docExt = "";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/checkDocExt.do",
		data : {
			docID : pDocID,
			orgCompanyID : orgCompanyID
		},
		success: function(xml){
			docExt = xml;
		}        			
	});
    
    return docExt;
}

/* 2022-03-23 홍승비 - 메일발송을 위한 제목을 DOCINFO가 아닌 문서에 직접 접근하여 리턴하는 함수 (편집모드 등에 대응) */
function getDocTitleForMail() {
	var result = "";
	
	try {
		var docExt = checkHWP(pDocID);
		
		if (docExt == "mht") { // 일반 MHT 문서
			result = message.document.getElementById("doctitle").textContent.trim();
		}
		else if (docExt == "hwp") {
			if (useWebHWP == "YES") { // 웹한글 문서
				if (typeof(draftAllFlag) != "undefined" && draftAllFlag != null && draftAllFlag == "Y") { // 일괄기안 (1안의 문서제목)
					if (typeof(pDocTitleAry) != "undefined" && pDocTitleAry != null) { // 부모프레임에서 접근
						result = pDocTitleAry[1];
					} else { // 자식프레임 내부에서 접근
						result = parent.pDocTitleAry[1];
					}
				} else { // 단일기안
					result = message.GetFieldText("doctitle").trim();
				}
			} else { // 일반 한글 문서
				result = trim(HwpCtrl.GetFieldText("doctitle"));
			}
		}
	} catch (e) { // 에러 발생 시, 기존처럼 DOCINFO에 접근하여 제목을 리턴
		console.log(e);
		result = getNodeText(GetChildNodes(GetElementsByTagName(document.getElementById("DOCINFO").dataSource, "DATA")[0])[7]);
	}
	
	return result;
}


