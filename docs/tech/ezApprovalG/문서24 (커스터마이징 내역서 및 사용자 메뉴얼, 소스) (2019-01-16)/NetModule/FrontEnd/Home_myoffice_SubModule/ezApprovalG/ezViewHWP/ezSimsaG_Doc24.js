function OpenCheckUI() {
    return "NONE";
}

function GetAprDeptXML() {
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/AprDeptRequest.aspx", false);
	xmlhttp.send(xmlpara);
	
	APRDEPTXML = loadXMLString(xmlhttp.responseText);
	
    for (i = 0; i < APRDEPTXML.getElementsByTagName("DATA3").length; i++) {
        if (getNodeText(APRDEPTXML.getElementsByTagName("DATA3").item(i)) == "Y")
			isExternal = true;
	}
	
    if (isExternal) {
        for (i = 0; i < APRDEPTXML.getElementsByTagName("DATA1").length; i++) {
            if (getNodeText(APRDEPTXML.getElementsByTagName("DATA1").item(i)).indexOf("Address") > -1)
				isAddress = true;
		}
	}
}

function GetEndDocInfo() {
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETERS");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);
	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/getEndDocInfo.aspx", false);
	xmlhttp.send(xmlpara);

	pDocInfoXML = loadXMLString(xmlhttp.responseText);
}

function getLineInfo() {
	var xmlpara = createXmlDom();	
	var xmlhttp = createXMLHttpRequest();	
	  
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETERS");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);
	
	xmlhttp.open("Post", "/myoffice/ezApprovalG/enforce/aspx/getLineInfo.aspx", false);
	xmlhttp.send(xmlpara);
	
	return loadXMLString(xmlhttp.responseText);
}



function chkToInfo() {
	var i;
	var isFrom_Cert = true;	
	sendCNT[0] = 0;
	sendCNT[1] = 0;
	
	
    if (is_Enc == "NONE")
        isFrom_Cert = false;
	
    for (i = 0; i < APRDEPTXML.getElementsByTagName("DATA1").length; i++) {
        BaseURL[i] = getNodeText(APRDEPTXML.getElementsByTagName("DATA1").item(i));
        AddInfo[i] = getNodeText(APRDEPTXML.getElementsByTagName("DATA9").item(i));
        if (isFrom_Cert) {
			isGPKI[i] = "Y";
			sendCNT[0] = sendCNT[0] + 1;
        } else {
			isGPKI[i] = "N"
			sendCNT[1] = sendCNT[1] + 1;		
		}	
	}
	return true;
}

function getPasswdEnd() {
    var url = "/myoffice/ezApprovalG/enforce/cert.aspx";
	var feature = "status:no;dialogWidth:420px;dialogHeight:350px;help:no;scroll:no"
	var param = true;
	var ret = window.showModalDialog(url,param,feature);
		
    if (ret[0]) {
		encodePass = ret[1];
		encodePath = ret[2];	
	}		
	return ret[0];
}

function sendExt() {
	var orgHTML;
	var sihangDate = "";
	var field;
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
    var xmlRtn;	
		
	var chkFlag = chkToInfo();
    if (!chkFlag) {
		return false;
	}

    if (sendCNT[0] > 0) {
        if (!getPasswdEnd()) {
			return false;
		}
	}
	
	if (makeXML(pDocID))		
		return true;
	else
		return false;
}

function covBody(pbody) {
    var pbody_as = pbody;
    pbody = removeTags(pbody, '<caption><img><i><b><u><sub><sup><p><ul><ol><table><tr><td>');

	var compSTR, subcompSTR, compChar, startIdx, findIdx, nextIdx, endIdx;
	var i, strgt, startflag;
	startflag = false;
    tmpSTR = pbody;
    
    startIdx = 1;
    endIdx = tmpSTR.length;
    
    i = 0;
    startflag = false;
    strgt = false;
    compChar = '"';
    newSTR = "";
    var newSTR_as="";
   

    while (i < endIdx) {
        compSTR = tmpSTR.substr(i, 1);
        //strgt = false;
        
        if(compSTR == "<") strgt = true;
        if(compSTR == ">") strgt = false;
            
        if (!startflag) {
            if (compSTR == "=" && strgt) {
                i = i + 1
                subcompSTR = tmpSTR.substr(i,1);
                if(compSTR == "<") strgt = true;
                if(compSTR == ">") strgt = false;
                                
                if (subcompSTR != compChar && strgt) {
                    newSTR = newSTR + compSTR.toLowerCase() + "'" + subcompSTR.toLowerCase();
                    startflag = true;
                }
                else {
                    if (strgt) {
						if(subcompSTR == compChar) subcompSTR = "'";
                        newSTR = newSTR + compSTR.toLowerCase() + subcompSTR.toLowerCase();
                    }
                    else
                        newSTR = newSTR + compSTR + subcompSTR;
                }
            }                    
            else {
                if (strgt) {
                    if(compSTR == compChar) compSTR = "'";
                    newSTR = newSTR + compSTR.toLowerCase();
                    
                }
                else
                    newSTR = newSTR + compSTR;
            }    
            i = i + 1;
        }
        else {
            if (compSTR == " " || compSTR == ">") {
                if (strgt) {
					if(compSTR == compChar) compSTR = "'";
                    newSTR = newSTR + "'" + compSTR.toLowerCase() + " ";
                }
                else
                    newSTR = newSTR + "'" + compSTR + " ";
                startflag = false
            }
            else {
                if (strgt) {
					if(compSTR == compChar) compSTR = "'";
                    newSTR = newSTR + compSTR.toLowerCase();
                }
                else
                    newSTR = newSTR + compSTR;
            }
            i = i + 1
        }
    }

    


	var re = /&nbsp;/g; 
	var BodyStr = "<content>" + newSTR.replace(re,"&amp;nbsp;") + "</content>";
	



	BodyStr = BodyStr.replace(/: '/g,":");
	BodyStr = BodyStr.replace(/'' /g,"' ");
	BodyStr = BodyStr.replace(/''>/g,"'>");
	BodyStr = BodyStr.replace(/'; /g,"; ");
	BodyStr = BodyStr.replace(/<br>/g,"");
    
    BodyStr = BodyStr.replace(/<BR>/g, "");
    BodyStr = BodyStr.replace(/class=hstyle0/g, "");
    BodyStr = BodyStr.replace(/''font-size:'/g, "'font-size:");
    
    BodyStr = BodyStr.replace(/''margin-bottom:'/g, "'margin-bottom:");
    BodyStr = BodyStr.replace(/='>/g, "=''>");
    BodyStr = BodyStr.replace(/=''/g, "='");
    BodyStr = BodyStr.replace(/:'  '/g, ":");
    
    //BodyStr = BodyStr.replace(/width="(.*?)[0-9]*/ig, " $&mm");
    //BodyStr = BodyStr.replace(/width='(.*?)[0-9]*/ig, " $&mm");
    //BodyStr = BodyStr.replace(/hight="(.*?)[0-9]*/ig, " $&mm");
    //BodyStr = BodyStr.replace(/hight='(.*?)[0-9]*/ig, " $&mm");
    
    BodyStr = BodyStr.replace(/(\?(\w)*?\w=)((')(\w*?)['])/ig, "$1$5$4");

    BodyStr = BodyStr.replace(/\n|\r|\t/g, "");
    BodyStr = BodyStr.replace("align='center'", ""); //소방수정(20170814)
	var xmlpara = createXmlDom();
	xmlpara.async = false;
	if (xmlpara.loadXML(BodyStr) == false) { //소방 스타일 깨짐 분기처리(20170413)
	    for (var i = 0; i < endIdx; i++) { //소방 스타일 깨짐 분기처리(20170413)
	        pbody_as = pbody_as.replace("\"", "'");
	        pbody_as = pbody_as.replace("'굴림'", "굴림");
	        //pbody_as = pbody_as.replace("○", "");
	        pbody_as = pbody_as.replace("<b>", "");	       
	        pbody_as = pbody_as.replace("</b>", "");
	    }
	    newSTR_as = pbody_as;
	    var re_as = /&nbsp;/g;
	    var BodyStr_as = "<content>" + newSTR_as.replace(re_as, "&amp;nbsp;") + "</content>"; //소방 스타일 깨짐 분기처리(20170413)
	    BodyStr_as = BodyStr_as.replace(/: '/g, ":");
	    BodyStr_as = BodyStr_as.replace(/'' /g, "' ");
	    BodyStr_as = BodyStr_as.replace(/''>/g, "'>");
	    BodyStr_as = BodyStr_as.replace(/'; /g, "; ");
	    BodyStr_as = BodyStr_as.replace(/<br>/g, "");

	    BodyStr_as = BodyStr_as.replace(/<BR>/g, "");
	    BodyStr_as = BodyStr_as.replace(/class=hstyle0/g, "");
	    BodyStr_as = BodyStr_as.replace(/''font-size:'/g, "'font-size:");

	    BodyStr_as = BodyStr_as.replace(/''margin-bottom:'/g, "'margin-bottom:");
	    BodyStr_as = BodyStr_as.replace(/='>/g, "=''>");
	    BodyStr_as = BodyStr_as.replace(/=''/g, "='");
	    BodyStr_as = BodyStr_as.replace(/:'  '/g, ":");

	    BodyStr_as = BodyStr_as.replace(/(\?(\w)*?\w=)((')(\w*?)['])/ig, "$1$5$4");

	    BodyStr_as = BodyStr_as.replace(/\n|\r|\t/g, "");

	    xmlpara.loadXML(BodyStr_as);
	}
	else {
	    xmlpara.loadXML(BodyStr);
	}
    var bodyNodes = xmlpara.documentElement;


	return bodyNodes;
}

function removeTags(input, allowed) {
    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('');
    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi, commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
        return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
    });
}
function makeXML(pDocID) {
	//GetEndDocInfo();
	
	var tempNode;
	
    if (HwpCtrl.CheckFieldExist("opinions")) {
        if (HwpCtrl.CheckFieldExist("body")) {
			HwpCtrl.AppendFieldText("body", "<br><br>", false, true);
			HwpCtrl.AppendFieldText("body", HwpCtrl.GetFieldText("opinions"), false);
			HwpCtrl.SetFieldText("opinions", "");
		}
	}
	
	sihangXML = createXmlDom();
	sihangXML.async = false;
	sihangXML.load("/myoffice/ezApprovalG/enforce/pubdocsample.xml");
	
	var eNodes = sihangXML.documentElement;
	
	var Nodes = eNodes.selectNodes("head/organ");
    if (HwpCtrl.CheckFieldExist("organ")) {
        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("organ"));
    } else {
        setNodeText(Nodes(0) , "");
	}
	
	var Nodes = eNodes.selectNodes("head/receiptinfo/recipient");
    if (HwpCtrl.CheckFieldExist("recipients")) {
        if (trim(HwpCtrl.GetFieldText("recipients")) == "") {
			Nodes(0).setAttribute("refer", "false");
            if (HwpCtrl.CheckFieldExist("recipient")) {
                tempNode = eNodes.selectNodes("head/receiptinfo/recipient/rec");
                setNodeText(tempNode(0) , HwpCtrl.GetFieldText("recipient"));
			}
        } else {
			Nodes(0).setAttribute("refer", "true");	
            tempNode = eNodes.selectNodes("head/receiptinfo/recipient/rec");
            setNodeText(tempNode(0) , HwpCtrl.GetFieldText("recipients").replace(strLang177, ""));
		}
	}
	
	var Nodes = eNodes.selectNodes("head/receiptinfo");
    if (HwpCtrl.CheckFieldExist("refer")) {
        if (trim(HwpCtrl.GetFieldText("refer")) != "") {
            var tempNode2 = sihangXML.createNode(1, "via", "");
			Nodes(0).appendChild(tempNode2)
			setNodeText(tempNode2 , HwpCtrl.GetFieldText("refer"));
		}
	}
    var title = "";
	var Nodes = eNodes.selectNodes("body/title");
    if (HwpCtrl.CheckFieldExist("doctitle")) {
        setNodeText(Nodes(0), HwpCtrl.GetFieldText("doctitle"));
        title = HwpCtrl.GetFieldText("doctitle");
    } else {
        setNodeText(Nodes(0), "");
	}

	var Nodes = eNodes.selectNodes("body");	
    if (attachbodyPath != "") {
		Nodes(0).setAttribute("separate", "true");	
    } else {
		Nodes(0).setAttribute("separate", "false");	
	}
	
	var Nodes = eNodes.selectNodes("body");	
    if (HwpCtrl.CheckFieldExist("body")) {
		var strBody = GetHTMLBody(HwpCtrl.GetCloneData("body", "HTML"));
		var pBody = Encode(strBody);
		
        if (pBody == "</ERROR>") {
            alert("본문에 잘못된 내용이 포함되어 있습니다.\n(이미지, 스타일속성 등을 포함할 수 없습니다.)");
            return;
        }

		var re = /vAlign=center/g;
		pBody = pBody.replace(re,"vAlign=middle");
		
		var rtnNodes = covBody(pBody);
        Nodes(0).appendChild(rtnNodes);
    } else {
        setNodeText(Nodes(0) , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendername");
    if (HwpCtrl.CheckFieldExist("chief")) {
        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("chief"));
    } else {
        setNodeText(Nodes(0) , "");
	}

	var Nodes = eNodes.selectNodes("foot/seal");
    if (NostampFlag) {
		Nodes(0).setAttribute("omit", "true");
    } else {
        if (HwpCtrl.CheckFieldExist("sealsign")) {
			sealPath = GetDocumentElement(HwpCtrl, "surl");
            if (sealPath != "") {
				Nodes(0).setAttribute("omit", "false");
				var tempNode2 = sihangXML.createNode(1,"img","")
				Nodes(0).appendChild(tempNode2)
				
				var len = sealPath.lastIndexOf("/");
				var filelength = sealPath.length - (len + 1);  
				
				sealName = sealPath.substr(len + 1,filelength);
				tempNode2.setAttribute("src",sealName)
                tempNode2.setAttribute("alt", strLang178);
				tempNode2.setAttribute("height", GetDocumentElement(HwpCtrl, "sheight").toString() + "mm");
				tempNode2.setAttribute("width", GetDocumentElement(HwpCtrl, "swidth").toString() + "mm");
			}
		}
	}

	var Nodes = eNodes.selectNodes("foot/approvalinfo");
	//var LineNode = getLineInfo();
	var SignSN = 1;
	psignCount = 1;
    var DekyulFlag = false;
    
    var tempNode2 = sihangXML.createNode(1, "approval", "");
    Nodes(0).appendChild(tempNode2);
    tempNode2.setAttribute("order", "1");

    var tempNode3 = sihangXML.createNode(1, "signposition", "");
    tempNode2.appendChild(tempNode3);
    setNodeText(tempNode3, arr_userinfo[6]);

    var tempNode3 = sihangXML.createNode(1, "type", "");
    tempNode2.appendChild(tempNode3);
    setNodeText(tempNode3, "상신");

    var tempNode3 = sihangXML.createNode(1, "name", "");
    tempNode2.appendChild(tempNode3);
    setNodeText(tempNode3, arr_userinfo[2]);

    var tempNode3 = sihangXML.createNode(1, "date", "");
    tempNode2.appendChild(tempNode3);
    setNodeText(tempNode3, "");
    
	var Nodes = eNodes.selectNodes("foot/processinfo/regnumber");
    if (HwpCtrl.CheckFieldExist("docnumber")) {

        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("docnumber"));
		
		var regnumbercode;
		//regnumbercode = getNodeText(pDocInfoXML.documentElement.childNodes(32));
        regnumbercode = "";
		Nodes(0).setAttribute("regnumbercode", regnumbercode);
    } else {
        setNodeText(Nodes(0) , "");
		Nodes(0).setAttribute("regnumbercode", "");
	}
	
	var Nodes = eNodes.selectNodes("foot/processinfo/enforcedate");
    if (HwpCtrl.CheckFieldExist("enforcedate")) {
        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("enforcedate"));
    } else {
        setNodeText(Nodes(0) , "");
	}

	var Nodes = eNodes.selectNodes("foot/processinfo");
    if (HwpCtrl.CheckFieldExist("receiptnumber")) {
		var tempNode2 = sihangXML.createNode(1,"receipt","");
		Nodes(0).appendChild(tempNode2);

		var tempNode3 = sihangXML.createNode(1,"number","");
		tempNode2.appendChild(tempNode3);
		setNodeText(tempNode3 , HwpCtrl.GetFieldText("receiptnumber"));

		var tempNode3 = sihangXML.createNode(1,"date","");
		tempNode2.appendChild(tempNode3);

        if (HwpCtrl.CheckFieldExist("receiptdate")) {
            setNodeText(tempNode3 , HwpCtrl.GetFieldText("receiptdate"));
		}
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("zipcode")) {
		var tempNode2 = sihangXML.createNode(1,"zipcode","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("zipcode"));
    } else {
		var tempNode2 = sihangXML.createNode(1,"zipcode","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("address")) {
		var tempNode2 = sihangXML.createNode(1,"address","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("address"));
    } else {
		var tempNode2 = sihangXML.createNode(1,"address","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("homepage")) {
		var tempNode2 = sihangXML.createNode(1,"homeurl","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("homepage"));
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("telephone")) {
		var tempNode2 = sihangXML.createNode(1,"telephone","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("telephone"));
    } else {
		var tempNode2 = sihangXML.createNode(1,"telephone","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("fax")) {
		var tempNode2 = sihangXML.createNode(1,"fax","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("fax"));
    } else {
		var tempNode2 = sihangXML.createNode(1,"fax","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("email")) {
		var tempNode2 = sihangXML.createNode(1,"email","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("email"));
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("publication")) {
		var tempNode2 = sihangXML.createNode(1,"publication","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("publication"));
		//tempNode2.setAttribute("code", getNodeText(pDocInfoXML.documentElement.childNodes(27)));		
        tempNode2.setAttribute("code", "1NNNNNNNN");		
    } else {
		var tempNode2 = sihangXML.createNode(1,"publication","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
		//tempNode2.setAttribute("code", getNodeText(pDocInfoXML.documentElement.childNodes(27)));		
        tempNode2.setAttribute("code", "1NNNNNNNN");		
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("symbol")) {
		symbolPath = GetDocumentElement(HwpCtrl, "symbolurl");
        if (symbolPath != "") {
				var tempNode3 = sihangXML.createNode(1,"symbol","");
				Nodes(0).appendChild(tempNode3);
				var tempNode2 = sihangXML.createNode(1,"img","")
            tempNode3.appendChild(tempNode2);
				
				var len = symbolPath.lastIndexOf("/");
				var filelength = symbolPath.length - (len + 1);  
				symbolName = symbolPath.substr(len + 1,filelength);
				tempNode2.setAttribute("src",symbolName);
				tempNode2.setAttribute("alt",strLang180);
				
            var tempSize = GetHTMLBody(HwpCtrl.GetCloneData("symbol", "HTML"));
            var tmpDiv = document.createElement("div");
            tmpDiv.innerHTML = tempSize;
            //var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0],'height'));
            //var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0],'width'));

            tempNode2.setAttribute("width", "17mm");
            tempNode2.setAttribute("height", "17mm");
			}
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("logo")) {
		logoPath = GetDocumentElement(HwpCtrl, "logourl");
		
        if (logoPath != "") {
					var tempNode3 = sihangXML.createNode(1,"logo","");
					Nodes(0).appendChild(tempNode3);
					var tempNode2 = sihangXML.createNode(1,"img","")
					tempNode3.appendChild(tempNode2)
					
					var len = logoPath.lastIndexOf("/");
					var filelength = logoPath.length - (len + 1);  
					logoName = logoPath.substr(len + 1,filelength);
					tempNode2.setAttribute("src",logoName)
					tempNode2.setAttribute("alt", strLang181)
					
            var tempSize = GetHTMLBody(HwpCtrl.GetCloneData("logo", "HTML"));
            var tmpDiv = document.createElement("div");
            tmpDiv.innerHTML = tempSize;

            tempNode2.setAttribute("width", "16mm");
			tempNode2.setAttribute("height", "15mm");

			}
	}
	
    if (HwpCtrl.CheckFieldExist("headcampaign")) {
		var Nodes = eNodes.selectNodes("foot");
		var tempNode2 = sihangXML.createNode(1,"campaign","");
		Nodes(0).appendChild(tempNode2);

		var tempNode3 = sihangXML.createNode(1,"headcampaign","");
		tempNode2.appendChild(tempNode3);		
		setNodeText(tempNode3 , HwpCtrl.GetFieldText("headcampaign"));
		
        if (HwpCtrl.CheckFieldExist("footcampaign")) {
			var tempNode3 = sihangXML.createNode(1,"footcampaign","");
			tempNode2.appendChild(tempNode3);		
			setNodeText(tempNode3 , HwpCtrl.GetFieldText("footcampaign"));
		}		
    } else {
        if (HwpCtrl.CheckFieldExist("footcampaign")) {
			var Nodes = eNodes.selectNodes("foot");
			var tempNode2 = sihangXML.createNode(1,"campaign","");
			Nodes(0).appendChild(tempNode2);

			var tempNode3 = sihangXML.createNode(1,"footcampaign","");
			tempNode2.appendChild(tempNode3);		
			setNodeText(tempNode3 , HwpCtrl.GetFieldText("footcampaign"));
		}
	}

	
    if (attachName.length > 0) {
        tempNode = sihangXML.createNode(1, "attach", "");
        eNodes.appendChild(tempNode);
		
		var i;
        for (i = 0; i < attachName.length; i++) {
			var subNode;
			subNode = sihangXML.createNode(1,"title","")
			tempNode.appendChild(subNode);
			setNodeText(subNode , attachName[i]);
		}
	}
	
	var result = true;
	var sihangXML2 = sihangXML.xml;
	var strtempxml = sihangXML2;
	
	var re = /&amp;nbsp;/g; 
    var strtempxml = strtempxml.replace(re, "&nbsp;");
	var re = /strong>/g; 
    var strtempxml = strtempxml.replace(re, "b>");
	
	var objSaveTmp = new ActiveXObject("EzUtil.MiscFunc"); 
    objSaveTmp.SaveTextToFile("c:\\" + pDocID + "pubdoc.xml", "<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml-stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">" + strtempxml);
	objSaveTmp = null;
    FileUpload(pDocID + "pubdoc.xml", "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + "pubdoc.xml", "c:\\" + pDocID + "pubdoc.xml");
	
	arrDelFiles[arrDelFiles.length] = "c:\\" + pDocID + "pubdoc.xml";
	
	var xmlhttp = createXMLHttpRequest();
	var xmlPubDocCheck = createXmlDom();
	
	var objRoot = xmlPubDocCheck.createNode(1,"PARAMETER","");
	xmlPubDocCheck.appendChild(objRoot);
	
	var objNode = xmlPubDocCheck.createNode(1, "XMLPATH", "");
	setNodeText(objNode , "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + "pubdoc.xml");
	xmlPubDocCheck.documentElement.appendChild(objNode);
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/checkPubDocXML.aspx", false);
	xmlhttp.send(xmlPubDocCheck);
	
    if (xmlhttp.responseText != "0") {
        alert("파서오류(pubdoc) : " + "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + "pubdoc.xml" + ", " + xmlhttp.responseText);
		return false;
	}
	
    
    if (sendCNT[0] > 0) {

        var rtnXML = makeExtinfo(sihangXML, pDocID, "GPKI", title);
        if (encodePath == "NONE_Enc_SEND") {
			var rtnFileName = encodeDN(rtnXML);
			var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
			ContentXML = objSave.LoadTextFromFile("c:\\" + rtnFileName)
			objSave = null;
			ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");
			var xmlContent = createXmlDom();
			xmlContent.loadXML(ContentXML);
			result = sendExtDoc(xmlContent);
        } else {
			var rtnFileName = encodeDN(rtnXML);
			result = encodeUP(rtnFileName);
		}
	}
	
    
    if (sihangXML.xml == "")
        sihangXML.loadXML(sihangXML2);

    if (sendCNT[1] > 0) {
        var rtnXML = makeExtinfo(sihangXML, pDocID, "SEND", title);
		var rtnFileName = encodeDN(rtnXML);
		var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
		ContentXML = objSave.LoadTextFromFile("c:\\" + rtnFileName)
		ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");
		var xmlContent = createXmlDom();
		xmlContent.loadXML(ContentXML);
		result = sendExtDoc(xmlContent);
	}
		
    if (result) {
		return true;
    } else {
		var pAlertContent = strLang185;
		OpenAlertUI(pAlertContent);
		return false;
	}
}

function FileUpload(pFileName, pURL, localPath) {
	oPoster.Clear();
	oPoster.UseUTF8 = true;
	oPoster.AddFormData("DocID", pFileName);
	oPoster.AddFormData("UploadPath", pURL);
	oPoster.AddFile("UploadFile", localPath, 0);

	oPoster.Host = document.location.hostname;
	oPoster.PostURL = "/myoffice/ezApprovalG/ezAPRATTACH/aspx/upload_file.aspx";
	
    if (window.location.protocol == "http:")
        oPoster.Protocol = 0;
    else
        oPoster.Protocol = 1;
	oPoster.Post();
	var rtnVal = oPoster.Response;
	
    if (rtnVal == "SUCCESS") {
		return true;	
	}	
    else {
		return false;
	}
}

function makeExtinfo(psihangXML, pDocID, mode, title) {
	var ExtSNodes, Nodes, Nodes2, strTO, i;
	var isfirst;
	
    
	var ExtXML =  createXmlDom();
	ExtXML.async = false;
	ExtXML.load("/myoffice/ezApprovalG/enforce/packXML.xml");
	
  try {
	var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	var eNodes = ExtXML.documentElement;
	var Nodes = psihangXML.documentElement;
	
        
	var Nodes = eNodes.selectNodes("header/send-orgcode");
      //setNodeText(Nodes(0) , companyID); //소방기관코드 수정(20170206)
	setNodeText(Nodes(0), pSpanCode);
        
	var Nodes = eNodes.selectNodes("header/send-id");
      //setNodeText(Nodes(0) , companyID); //소방기관코드 수정(20170206)
	setNodeText(Nodes(0), pSpanCode);
        
	var Nodes = eNodes.selectNodes("header/send-name");
	setNodeText(Nodes(0) , objSave.EncodeBase64(companyName));
	
	isfirst = true;
        if (mode == "GPKI") {
            for (i = 0; i < isGPKI.length; i++) {
                if (isGPKI[i] == "Y") {
                    if (isfirst) {
					strTO = BaseURL[i];
					isfirst = false;	
                    } else {
					strTO = strTO + ";" + BaseURL[i];
			}		
		}	
	}
        } else {
            for (i = 0; i < isGPKI.length; i++) {
                if (isGPKI[i] == "N") {
                    if (isfirst) {
					strTO = BaseURL[i];
					isfirst = false;	
                    } else {
                        strTO = strTO + ";" + BaseURL[i];
				}
			}
		}
	}
	
        
	var Nodes = eNodes.selectNodes("header/receive-id");
	setNodeText(Nodes(0) , strTO);

        
	var Nodes = eNodes.selectNodes("header/date");
	setNodeText(Nodes(0) , "");

        
	var Nodes = eNodes.selectNodes("header/title");
      setNodeText(Nodes(0), objSave.EncodeBase64(title));
        
	var Nodes = eNodes.selectNodes("header/doc-id");
      setNodeText(Nodes(0), pDocID);
	
        
	var Nodes = eNodes.selectNodes("header/doc-type");
	if (pAprType == strLang186 )
		Nodes(0).setAttribute("type", "resend");
	else
		Nodes(0).setAttribute("type", "send");

        
	//Nodes(0).setAttribute("dept", objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(17))));
      Nodes(0).setAttribute("dept", objSave.EncodeBase64(arr_userinfo[5]));    
	//Nodes(0).setAttribute("name", objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(14))));
      Nodes(0).setAttribute("name", objSave.EncodeBase64(arr_userinfo[2]));

        
	var Nodes = eNodes.selectNodes("header/send-gw");
	setNodeText(Nodes(0) , objSave.EncodeBase64("ezFlow2000/G"));

        
	var Nodes = eNodes.selectNodes("header/dtd-version");
	setNodeText(Nodes(0) , "2.0");

        
	var Nodes = eNodes.selectNodes("header/xsl-version");
	setNodeText(Nodes(0) , "2.0");
	
	var Nodes = eNodes.selectNodes("contents");
	var tempNode = sihangXML.createNode(1,"content","");
	Nodes(0).appendChild(tempNode);
	tempNode.setAttribute("content-role", "pubdoc");
	tempNode.setAttribute("filename", objSave.EncodeBase64("pubdoc.xml"));
	tempNode.setAttribute("content-transfer-encoding", "base64");
	tempNode.setAttribute("content-type", "text/xml");
        tempNode.setAttribute("charset", "euc-kr");
	
	var strtempxml = psihangXML.xml;
	var re = /&amp;nbsp;/g; 
	var strtempxml = strtempxml.replace(re,"&nbsp;")
	var re = /strong>/g; 
	var strtempxml = strtempxml.replace(re,"b>")

	setNodeText(tempNode , objSave.EncodeBase64("<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml-stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">" + strtempxml));
	
        
        if (sealName != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "seal");
		tempNode.setAttribute("filename", objSave.EncodeBase64(sealName));
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , sealPath.replace(pDomainName, ""));
	}	
	
        
        for (i = 0; i < attachName.length; i++) {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		if (attachType[i] == "Y")
			tempNode.setAttribute("content-role", "attach_body");
		else
			tempNode.setAttribute("content-role", "attach");
		tempNode.setAttribute("filename", objSave.EncodeBase64(attachName[i]));
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , attachPath[i]);
	}
	
        if (attachxmlPath != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "attach_xml");
		tempNode.setAttribute("filename", objSave.EncodeBase64(attachxmlName));
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "html/xml");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , attachxmlPath);
	}

        if (attachxslPath != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "attach_xsl");
		tempNode.setAttribute("filename", objSave.EncodeBase64(attachxslName));
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "html/xsl");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , attachxslPath);	
	}
		
        
        for (i = 1; i < psignCount; i++) {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "sign");
		tempNode.setAttribute("filename", objSave.EncodeBase64(psignName[i]));
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , psignPath[i]);
	}
	
        
        if (symbolName != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "symbol");
		tempNode.setAttribute("filename", objSave.EncodeBase64(symbolName));
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , symbolPath.replace(pDomainName, ""));
	}	
        
        if (logoName != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "logo");
		tempNode.setAttribute("filename", objSave.EncodeBase64(logoName));
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , logoPath.replace(pDomainName, ""));
	}			
	return ExtXML;
	
  } catch(e) {
	alert("makeExtinfo : " + e.description);
  }
}

var i = 0;
function sendExtDoc(ExtXML) {
    try {
		i = i + 1;
		var objSaveTmp = new ActiveXObject("EzUtil.MiscFunc"); 
		objSaveTmp.SaveTextToFile("c:\\" + pDocID + i + "pack.xml", "<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">" + ExtXML.xml);
		objSaveTmp = null;
		FileUpload(pDocID + i + "pack.xml", "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + i + "pack.xml", "c:\\" + pDocID + i + "pack.xml")
		
		
		arrDelFiles[arrDelFiles.length] = "c:\\" + pDocID + i + "pack.xml";
		
		
		var xmlhttp = createXMLHttpRequest();
		var xmlPubDocCheck = createXmlDom();
		
		var objRoot = xmlPubDocCheck.createNode(1,"PARAMETER","");
		xmlPubDocCheck.appendChild(objRoot);
		
		var objNode = xmlPubDocCheck.createNode(1, "XMLPATH", "");
		setNodeText(objNode , "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + i + "pack.xml");
		xmlPubDocCheck.documentElement.appendChild(objNode);
		
		xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/checkPubDocXML.aspx", false);
		xmlhttp.send(xmlPubDocCheck);
		
        if (xmlhttp.responseText != "0") {
			alert("" + strLang187 + "" + xmlPubDocCheck.parseError.reason);
			return false;
		}
		
		
        xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/sendMsg.aspx", false);
		xmlhttp.send(ExtXML);	
		return true;
	}
    catch (e) {
        alert("sendExtDoc : " + e.description);
		return false;
	}
}

function encodeDN(ExtXML) {
	var xmlhttp = createXMLHttpRequest();
	xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/sendMsg2.aspx", false);
	xmlhttp.send(ExtXML);
	
	var emlName = xmlhttp.responseText;
	
    try {
		var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
		ezUtil.UseUTF8 = true;
		var result = ezUtil.DownloadToFile(pDomainName + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape("/Upload_ApprovalG/" + companyID + "/ExDocSendMsg/" + emlName), "c:\\" + emlName);
		ezUtil = null;
		
		return emlName;
	}
    catch (e) {
		return emlName;
	}
}


function encodeUP(emlName) {
	var ouCodes;
	var rtnVal = true;
	
	
	showProgress(strLang744);
	
	var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	ContentXML = objSave.LoadTextFromFile("c:\\" + emlName)

	ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");

    var xmlContent = createXmlDom();
	xmlContent.loadXML(ContentXML);
	
	var ContentsView = xmlContent.selectSingleNode("pack/contents");
	var ContentText = "";
    for (i = 0; i < ContentsView.childNodes.length; i++) {
		ContentText = ContentText + ContentsView.childNodes(i).xml;
	}
	objSave.SaveTextToFile("c:\\content.xml", ContentText);
	
	
	arrDelFiles[arrDelFiles.length] = "c:\\content.xml";
	
    if (ObjGPKI.Parse("c:\\content.xml")) {
		var i = 0;
		ouCodes = "";
		
		var strTO;
		var isfirst = true;
		
        for (i = 0 ; i < isGPKI.length; i++) {
            if (isGPKI[i] == "Y") {
				ouCodes = ouCodes + BaseURL[i] + ";";
				
                if (isfirst) {
					strTO = AddInfo[i];
					isfirst = false;	
                } else {
                    strTO = strTO + "," + AddInfo[i];
				}
			}
		}
		
		
		var xmlhttp = createXMLHttpRequest();
		xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/getServerTime.aspx", false);
		xmlhttp.send();
		
        if (is_Enc == "ENC") {
			
            if (ObjGPKI.Encode(encodePath, ouCodes, encodePass, xmlhttp.responseText)) {
				var dday = ObjGPKI.errorMsg
                if (ObjGPKI.FailCertList != "") {
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
                    for (i = 0; i < isGPKI.length; i++) {
                        if (tempFailList.indexOf(BaseURL[i]) >= 0) {
							isGPKI[i] = "N"
                            if (isfirst) {
								TempRecvList = AddInfo[i];
								isfirst = false;
                            } else {
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + "" + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}
				
				ObjGPKI.WriteResultFile("C:\\upload.p7m");
				var GPKIContent = objSave.DownloadToBase64("C:\\upload.p7m");
				
				
				var NewContents = makePKIHeader(GPKIContent);
				rtnVal = sendExtDoc(NewContents);
            } else {
                if (ObjGPKI.FailCertList != "") {
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
                    for (i = 0; i < isGPKI.length; i++) {
                        if (tempFailList.indexOf(BaseURL[i]) >= 0) {
							isGPKI[i] = "N"
                            if (isfirst) {
								TempRecvList = AddInfo[i];
								isfirst = false;
                            } else {
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
                } else {
					var pAlertContent = strLang191 + ObjGPKI.errorMsg;
					OpenAlertUI(pAlertContent);				
					rtnVal = false;
				}
			}
        } else if (is_Enc == "SIGN") {
			
            if (ObjGPKI.EncodeBySign(encodePath, ouCodes, encodePass, xmlhttp.responseText)) {
				var dday = ObjGPKI.errorMsg
                if (ObjGPKI.FailCertList != "") {
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
                    for (i = 0; i < isGPKI.length; i++) {
                        if (tempFailList.indexOf(BaseURL[i]) >= 0) {
							isGPKI[i] = "N"
                            if (isfirst) {
								TempRecvList = AddInfo[i];
								isfirst = false;
                            } else {
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}
				
				ObjGPKI.WriteResultFile("C:\\upload.p7m");
				var GPKIContent = objSave.DownloadToBase64("C:\\upload.p7m");
				
				
				arrDelFiles[arrDelFiles.length] = "C:\\upload.p7m";
				
				
				var NewContents = makePKIHeader(GPKIContent);
				rtnVal = sendExtDoc(NewContents);
            } else {
                if (ObjGPKI.FailCertList != "") {
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
                    for (i = 0; i < isGPKI.length; i++) {
                        if (tempFailList.indexOf(BaseURL[i]) >= 0) {
							isGPKI[i] = "N"
                            if (isfirst) {
								TempRecvList = AddInfo[i];
								isfirst = false;
                            } else {
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
                } else {
					var pAlertContent = strLang191 + ObjGPKI.errorMsg;
					OpenAlertUI(pAlertContent);
					rtnVal = false;
				}
			}
        } else {
			var pAlertContent = strLang192 + "<br>" + strLang193;
			OpenAlertUI(pAlertContent);
			rtnVal = false;
		}
    } else {

	}
	
	hideProgress();
	
	return rtnVal;
}

function makePKIHeader(psihangXML) {
    alert("1");
	var ExtSNodes, Nodes, Nodes2, strTO, i;
	var isfirst;
	
	var ExtXML =  createXmlDom();
	ExtXML.async = false;
	ExtXML.load("/myoffice/ezApprovalG/enforce/packXML.xml");
	
  try {	
	var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	var eNodes = ExtXML.documentElement;
	var Nodes = psihangXML.documentElement;
	

	var Nodes = eNodes.selectNodes("header/send-orgcode");
	//setNodeText(Nodes(0) , companyID);
	setNodeText(Nodes(0), pSpanCode); //소방기관코드 수정(20170206)

	var Nodes = eNodes.selectNodes("header/send-id");
	
	//setNodeText(Nodes(0) , companyID);
	setNodeText(Nodes(0), pSpanCode); //소방기관코드 수정(20170206)

	var Nodes = eNodes.selectNodes("header/send-name");
	
	setNodeText(Nodes(0) , objSave.EncodeBase64(companyName));
	
	isfirst = true;
        for (i = 0; i < isGPKI.length; i++) {
            if (isGPKI[i] == "Y") {
                if (isfirst) {
				strTO = BaseURL[i];
				isfirst = false;	
			}
			else
				strTO = strTO + ";" + BaseURL[i];
		}		
	}	
	
	var Nodes = eNodes.selectNodes("header/receive-id");
	setNodeText(Nodes(0) , strTO);

	var Nodes = eNodes.selectNodes("header/date");
	setNodeText(Nodes(0) , "");

      var Nodes = eNodes.selectNodes("header/title");
      setNodeText(Nodes(0), "");
	//setNodeText(Nodes(0) , objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(7))));

	var Nodes = eNodes.selectNodes("header/doc-id");
	
	
	setNodeText(Nodes(0) , pOrgDocID);

	var Nodes = eNodes.selectNodes("header/doc-type");
	if (pAprType == strLang186)
		Nodes(0).setAttribute("type", "resend");
	else
		Nodes(0).setAttribute("type", "send");
      //Nodes(0).setAttribute("dept", objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(17))));
      Nodes(0).setAttribute("dept", objSave.EncodeBase64(arr_userinfo[5]));
      //Nodes(0).setAttribute("name", objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(14))));
      Nodes(0).setAttribute("name", objSave.EncodeBase64(arr_userinfo[2]));

	var Nodes = eNodes.selectNodes("header/send-gw");
	
	setNodeText(Nodes(0) , objSave.EncodeBase64("ezFlow2000/G"));

	var Nodes = eNodes.selectNodes("header/dtd-version");
	setNodeText(Nodes(0) , "2.0");

	var Nodes = eNodes.selectNodes("header/xsl-version");
	setNodeText(Nodes(0) , "2.0");
	

	var Nodes = eNodes.selectNodes("contents");
	var tempNode = sihangXML.createNode(1,"content","");
	Nodes(0).appendChild(tempNode);
	tempNode.setAttribute("content-role", "gpki");
	tempNode.setAttribute("filename", objSave.EncodeBase64("smime.p7m"));
	tempNode.setAttribute("content-transfer-encoding", "base64");
	if(is_Enc == "ENC")
		tempNode.setAttribute("content-type", "application/gcc-mime;smime-type=signedandenveloped-data;");
	else
            tempNode.setAttribute("content-type", "application/gcc-mime;smime-type=signed-data;");
	tempNode.setAttribute("charset", "euc-kr");
	setNodeText(tempNode , psihangXML);

	return ExtXML;
	
  } catch(e) {
	alert("makePKIHeader : " + e.description);
  }
}

function trim(parm_str) {
	return rtrim(ltrim(parm_str));
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

function openFileAttachUI() {
    try {
        var parameter = pDocID;
        var url = "/myoffice/ezApprovalG/ezAPRATTACH/Aprattach.aspx?FormID=" + escape("2009000003");
        var feature = "status:no;dialogWidth:820px;dialogHeight:350px;edge:sunken;scroll:no";
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            setAttachInfo(pDocID, "APR", lstAttachLink);
        }
        return ret;
    } catch (e) {
        alert("openFileAttachUI()" + e.description);
    }
}