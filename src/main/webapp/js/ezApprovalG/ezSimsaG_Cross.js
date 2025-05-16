function GetAprDeptXML() {
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/aprDeptRequest.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
  	APRDEPTXML = loadXMLString(result);
	
	for (i=0; i<APRDEPTXML.getElementsByTagName("DATA3").length; i++) {
	    if (getNodeText(APRDEPTXML.getElementsByTagName("DATA3").item(i)) == "Y")
			isExternal = true;
	}
	
	if (isExternal) {
		for (i=0; i<APRDEPTXML.getElementsByTagName("DATA1").length; i++) {
		    if (getNodeText(APRDEPTXML.getElementsByTagName("DATA1").item(i)).indexOf("Address") > -1)
				isAddress = true;
		}
	}
}

function GetEndDocInfo() {
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

	pDocInfoXML = loadXMLString(result);
}

function getLineInfo() {
    var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
	createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);

	xmlhttp.open("Post","/ezApprovalG/getLineInfo.do",false);
	xmlhttp.send(xmlpara);
	
	return xmlhttp.responseXML;
}

function chkToInfo() {
	var i;
	var isFrom_Cert = true;	
	sendCNT[0] = 0;
	sendCNT[1] = 0;
	
	if(is_Enc == "NONE") isFrom_Cert = false;
	
	for (i=0; i<APRDEPTXML.getElementsByTagName("DATA1").length; i++) {
	    BaseURL[i] = getNodeText(APRDEPTXML.getElementsByTagName("DATA1").item(i));
	    AddInfo[i] = getNodeText(APRDEPTXML.getElementsByTagName("DATA9").item(i));
		if(isFrom_Cert) {
			isGPKI[i] = "Y";
			sendCNT[0] = sendCNT[0] + 1;
		} else {
			isGPKI[i] = "N"
			sendCNT[1] = sendCNT[1] + 1;		
		}	
	}
	return true;
}

var cert_dialogArguments = new Array();
function getPasswdEnd() { 
    var url	= "/ezApprovalG/cert.do";
	var feature = "status:no;dialogWidth:420px;dialogHeight:350px;help:no;scroll:no"
	var param = true;
	var ret = window.showModalDialog(url,param,feature);
		
	if(ret[0])
	{
		encodePass = ret[1];
		encodePath = ret[2];	
	}		
	return ret[0];
}

function getPasswdEnd_Complete(ret) {
	 DivPopUpHidden();
	    if (ret[0]) {
	        encodePass = ret[1];
	        encodePath = ret[2];
	    }
	    
	    if (makeXML(pDocID)) {
	        Check_Container();
	        return true;
	    } else {
	    	return false;
	    }
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
		return;
	}
	if (sendCNT[0] > 0) {
	    if (!getPasswdEnd()) {
	        return;
	    }
	} else {
	    if (makeXML(pDocID)) {
	    	Check_Container();
	    	return true;
	    } else {
	    	return false;
	    }
	}
}


function makeXML(newDocID) {
	 GetEndDocInfo();

	    var fields = message.GetFieldsList();
	    var field;
	    var tempNode;
	    var mhtBody = "";
	    
	    mhtBody = message.Get_EditorBodyHTML();
	    
	    field = message.GetListItem(fields, "opinions");
	    if (field) {
	        var bodyfield = message.GetListItem(fields, "body");
	        if (bodyfield) {
	            bodyfield.innerHTML = bodyfield.innerHTML + field.innerHTML;
	            field.innerHTML = "";
	        }
	    }

	    sihangXML = loadXMLFile("/xml/ezApprovalG/pubdocsample.xml");
	    var eNodes = sihangXML.documentElement;

	    var Nodes = eNodes.getElementsByTagName("organ");
	    field = message.GetListItem(fields, "organ");
	    if (field) {
	        setNodeText(Nodes.item(0), getNodeText(field))
	    } else {
	        setNodeText(Nodes.item(0), "")
	    }

	    var Nodes = eNodes.getElementsByTagName("recipient");
	    field = message.GetListItem(fields, "recipients");
	    if (field) {
	        if (trim(getNodeText(field)).length <= 1) {
	            Nodes.item(0).setAttribute("refer", "false");
	            field = message.GetListItem(fields, "recipient");
	            if (field) {
	                tempNode = eNodes.getElementsByTagName("rec");
	                setNodeText(tempNode.item(0), getNodeText(field));
	            }
	        } else {
//	            Nodes.item(0).setAttribute("refer", "true");
	        	SetAttribute(Nodes[0], "refer", "true");    
	            tempNode = eNodes.getElementsByTagName("rec");
	            setNodeText(tempNode.item(0), getNodeText(field).replace(strLang177, ""))
	        }
	    }

	    var Nodes = eNodes.getElementsByTagName("receiptinfo");
	    field = message.GetListItem(fields, "refer");
	    if (field) {
	        if (trim(getNodeText(field)).length > 1) {
	            var objChildNodes;
	            createNodeAndAppandNodeText(sihangXML, Nodes.item(0), objChildNodes, "via", getNodeText(field))
	        }
	    }

	    var Nodes = eNodes.getElementsByTagName("title");
	    field = message.GetListItem(fields, "doctitle");
	    if (field) {
	    	setNodeText(Nodes.item(0), MakeXMLString(getNodeText(field)));
	    }
	    else {
	        setNodeText(Nodes.item(0), "");
	    }

	    var Nodes = eNodes.getElementsByTagName("body");
	    if (attachbodyPath != "") {
	        Nodes.item(0).setAttribute("separate", "true");
	    }
	    else {
	        Nodes.item(0).setAttribute("separate", "false");
	    }

	    var Nodes = eNodes.getElementsByTagName("body");
	    field = message.GetListItem(fields, "body");
	    if (field) {
	        var defaultFontFamily = "";
	        var defaultFontSize = "";
	        if (field.fontFamily !== null) {
	            defaultFontFamily = field.fontFamily;
	        }

	        if (field.fontSize !== null) {
	            defaultFontSize = field.fontSize;
	        }
	        
	        styleToAttribute(field);

	        var strBody = Document_Encode(field.innerHTML, defaultFontFamily, defaultFontSize);

	        if (strBody === "") {
	            return false;
	        }
	        
	        strBody = covBody(strBody);        
	        Nodes[0].appendChild(strBody);
	    }
	    else {
	        setNodeText(Nodes[0], "");
	    }
//	        var objChildNodes;
//	        createNodeAndAppandNodeText(sihangXML, Nodes.item(0), objChildNodes, "content", strBody);
//	    }
//	    else {
//	        var objChildNodes;
//	        createNodeAndAppandNodeText(sihangXML, Nodes.item(0), objChildNodes, "content", "");
//	    }

	    var Nodes = eNodes.getElementsByTagName("sendername");
	    field = message.GetListItem(fields, "chief");
	    if (field) {
	        setNodeText(Nodes.item(0), getNodeText(field));
	    }
	    else {
	        setNodeText(Nodes.item(0), "");
	    }

        field = message.GetListItem(fields, "sealsign");
        if (field) {
            if (field.childNodes.length > 0) {
	            var Nodes = eNodes.getElementsByTagName("seal");
                if (NostampFlag) {
                    Nodes.item(0).setAttribute("omit", "true");
                } else {
                    Nodes.item(0).setAttribute("omit", "false");
                }
                
                var objChildNodes;
                objChildNodes = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), objChildNodes, "img", "")
                sealPath = GetAttribute(field,"surl");

                var len = sealPath.lastIndexOf("/");
                var filelength = sealPath.length - (len + 1);
                sealName = sealPath.substr(len + 1, filelength);
                objChildNodes.setAttribute("src", sealName);
                objChildNodes.setAttribute("alt", strLang178);
                objChildNodes.setAttribute("height", Conversion(Number(field.childNodes.item(0).height)).toString() + "mm");
                objChildNodes.setAttribute("width", Conversion(Number(field.childNodes.item(0).width)).toString() + "mm");
            }
        }

	    var Nodes = eNodes.getElementsByTagName("approvalinfo");
	    var LineNode = getLineInfo();
	    var SignSN = 1;
	    psignCount = 1;
	    var DekyulFlag = false;
	    var LineNodes = SelectNodes(LineNode, "APPROVALINFO/APPROVAL");
	    for (i = 0; i < LineNodes.length; i++) {
	        if (getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) != strLang3) {
	            var tempNode2;
	            tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "approval", "");
	            tempNode2.setAttribute("order", getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));

	            var tempNode3;
	            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signposition", "");
	            if (getNodeText(LineNodes.item(i).getElementsByTagName("OPINION").item(0)) == "YES")
	                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("SIGNPOSITION").item(0)));
	            else
	                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("SIGNPOSITION").item(0)));

	            var tempNode3;
	            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "type", "");
	            setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)));

	            if (getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) == strLang7)
	                DekyulFlag = true;

	            if ((getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) == strLang6) && (DekyulFlag)) {
	                var tempNode3;
	                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
	                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));

	                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");
	            }
	            else {
	                var field = message.GetListItem(fields, "sign" + SignSN);
	                if (field) {
	                    if (field.childNodes.length > 0) {
	                        var imageflag = true;
	                        for (j = 0; j < field.childNodes.length; j++) {
	                            if (imageflag && field.childNodes.item(j).tagName == "IMG") {
	                                var tempNode3;
	                                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signimage", "");

	                                var tempNode4;
	                                tempNode4 = createNodeAndAppandNodeText(sihangXML, tempNode3, tempNode4, "img", "");

	                                var signPath = imageflag && GetAttribute(field.childNodes.item(j),"spath");
	                                var len = signPath.lastIndexOf("/");
	                                var filelength = signPath.length - (len + 1);
	                                var signName = signPath.substr(len + 1, filelength);
	                                tempNode4.setAttribute("src", signName)
	                                tempNode4.setAttribute("alt", strLang179)
	                                tempNode4.setAttribute("height", Conversion(field.childNodes.item(j).height).toString() + "mm")
	                                tempNode4.setAttribute("width", Conversion(field.childNodes.item(j).width).toString() + "mm")

	                                psignName[psignCount] = signName;
	                                psignPath[psignCount] = signPath;
	                                psignCount = psignCount + 1;
	                                imageflag = false;
	                            }
	                        }
	                        var tempNode3;
	                        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
	                        setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
	                    }
	                    else {
	                        var tempNode3;
	                        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
	                        setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
	                    }
	                }
	                else {
	                    var tempNode3;
	                    tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
	                    setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));

	                }
	                var tempNode3;
	                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");

	                if (getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)) == "final" || DekyulFlag)
	                    setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("DATE").item(0)));
	            }
	            SignSN = SignSN + 1;
	        }
	    }

	    for (i = 0; i < LineNodes.length; i++) {
	        var SignSN = 1;
	        if (getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) == strLang3) {
	            var tempNode2;
	            tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "assist", "");
	            tempNode2.setAttribute("order", getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));

	            var tempNode3;
	            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signposition", "");
	            if (getNodeText(LineNodes.item(i).getElementsByTagName("OPINION").item(0)) == "YES")
	                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));
	            else
	                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));


	            var tempNode3;
	            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "type", "");
	            setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)));
	            
	            var field = message.GetListItem(fields, "habyuisign" + SignSN);
	            if (field) {
	                if (field.childNodes.length > 0 && field.childNodes.item(0).tagName == "IMG") {

	                    var tempNode3;
	                    tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signimage", "");

	                    var tempNode4;
	                    tempNode4 = createNodeAndAppandNodeText(sihangXML, tempNode3, tempNode4, "img", "");

	                    var signPath = GetAttribute(field.childNodes.item(j),"spath");
	                    var len = signPath.lastIndexOf("/");
	                    var filelength = signPath.length - (len + 1);
	                    var signName = signPath.substr(len + 1, filelength);
	                    tempNode4.setAttribute("src", signName);
	                    tempNode4.setAttribute("alt", strLang179);
	                    tempNode4.setAttribute("height", Conversion(field.childNodes.item(0).height).toString() + "mm");
	                    tempNode4.setAttribute("width", Conversion(field.childNodes.item(0).width).toString() + "mm");

	                    psignName[psignCount] = signName;
	                    psignPath[psignCount] = signPath;
	                    psignCount = psignCount + 1;
	                }
	                else {
	                    var tempNode3;
	                    tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
	                    setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
	                }
	            }
	            else {
	                var tempNode3;
	                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
	                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));

	            }
	            var tempNode3;
	            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");

	            SignSN = SignSN + 1;
	        }
	    }

	    var Nodes = eNodes.getElementsByTagName("regnumber");
	    field = message.GetListItem(fields, "docnumber");
	    if (field) {
	        setNodeText(Nodes.item(0), getNodeText(field));
	        Nodes.item(0).setAttribute("regnumbercode", getNodeText(pDocInfoXML.getElementsByTagName("DOCNUMCODE").item(0)));
	    }
	    else {
	        setNodeText(Nodes.item(0), "");
	        Nodes.item(0).setAttribute("regnumbercode", "");
	    }

	    var Nodes = eNodes.getElementsByTagName("enforcedate");
	    field = message.GetListItem(fields, "enforcedate");
	    if (field) {
	        setNodeText(Nodes.item(0), getNodeText(field));
	    }
	    else {
	        setNodeText(Nodes.item(0), "");
	    }

	    var Nodes = eNodes.getElementsByTagName("processinfo");
	    field = message.GetListItem(fields, "receiptnumber");
	    if (field) {
	        var tempNode2;
	        tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "receipt", "");

	        var tempNode3;
	        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "number", "");
	        setNodeText(tempNode3, getNodeText(field));

	        var tempNode3;
	        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");
	        var field2 = message.GetListItem(fields, "receiptdate");
	        if (field2)
	            setNodeText(tempNode3, getNodeText(field2));
	    }

	    var Nodes = eNodes.getElementsByTagName("sendinfo");
	    field = message.GetListItem(fields, "zipcode");
	    var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "zipcode", "");
	    if (field)
	        setNodeText(tempNode2, getNodeText(field));


	    field = message.GetListItem(fields, "address");
	    var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "address", "");
	    if (field)
	        setNodeText(tempNode2, getNodeText(field));

	    field = message.GetListItem(fields, "homepage");
	    var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "homeurl", "");
	    if (field)
	        setNodeText(tempNode2, getNodeText(field));

	    field = message.GetListItem(fields, "telephone");
	    var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "telephone", "");
	    if (field)
	        setNodeText(tempNode2, getNodeText(field));

	    field = message.GetListItem(fields, "fax");
	    var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "fax", "");
	    if (field)
	        setNodeText(tempNode2, getNodeText(field));

	    field = message.GetListItem(fields, "email");
	    var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "email", "");
	    if (field)
	        setNodeText(tempNode2, getNodeText(field));

	    field = message.GetListItem(fields, "publication");
	    var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "publication", "");
	    tempNode2.setAttribute("code", getNodeText(pDocInfoXML.getElementsByTagName("PUBLICITYCODE").item(0)));
	    if (field)
	        setNodeText(tempNode2, getNodeText(field));

	    field = message.GetListItem(fields, "symbol");
	    if (field) {
	        if (field.childNodes.length > 0) {
	            if (field.getElementsByTagName("img").length > 0) {
	            	var symbolImg = field.getElementsByTagName("img")[0];
	                var tempNode2;
	                tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "symbol", "");

	                var tempNode3;
	                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "img", "");

	                symbolPath = GetAttribute(symbolImg,"src");
	                var len = symbolPath.lastIndexOf("/");
	                symbolName = symbolPath.substr(len + 1, symbolPath.length);
	                tempNode3.setAttribute("src", symbolName);
	                tempNode3.setAttribute("alt", strLang180);
	                tempNode3.setAttribute("height", Conversion(symbolImg.height).toString() + "mm");
	                tempNode3.setAttribute("width", Conversion(symbolImg.width).toString() + "mm");
	            }
	        }
	    }
	    field = message.GetListItem(fields, "logo");
	    if (field) {
	        if (field.childNodes.length > 0) {
	            if (field.getElementsByTagName("img").length > 0) {
	            	var logoImg = field.getElementsByTagName("img")[0];
	            	logoPath = GetAttribute(logoImg,"src");
	                if (logoPath) {
	                    var tempNode2;
	                    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "logo", "");

	                    var tempNode3;
	                    tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "img", "");

	                    var len = logoPath.lastIndexOf("/");
	                    logoName = logoPath.substr(len + 1, logoPath.length);
	                    tempNode3.setAttribute("src", logoName);
	                    tempNode3.setAttribute("alt", strLang181);
	                    tempNode3.setAttribute("height", Conversion(logoImg.height).toString() + "mm");
	                    tempNode3.setAttribute("width", Conversion(logoImg.width).toString() + "mm");
	                }
	            }
	        }
	    }

	    field = message.GetListItem(fields, "headcampaign");
	    if (field) {
	        var Nodes = eNodes.getElementsByTagName("foot");
	        var tempNode2;
	        tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "campaign", "");

	        var tempNode3;
	        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "headcampaign", "");
	        setNodeText(tempNode3, getNodeText(field));

	        var field2 = message.GetListItem(fields, "footcampaign");
	        if (field2) {
	            var tempNode3;
	            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "footcampaign", getNodeText(field2));
	        }
	    }
	    else {
	        var field2 = message.GetListItem(fields, "footcampaign");
	        if (field2) {
	            var tempNode2;
	            tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "campaign", "");

	            var tempNode3;
	            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "footcampaign", field2.value);
	        }
	    }

	    if (attachName.length > 0) {
	        var tempNode2;
	        tempNode2 = createNodeAndAppandNodeText(sihangXML, eNodes, tempNode2, "attach", "");

	        var i;
	        for (i = 0; i < attachName.length; i++) {
	            var tempNode3;
	            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "title", attachName[i]);
	        }
	    }
	    var SaveDocHTTp = createXMLHttpRequest();
	    SaveDocHTTp.open("POST", "/ezApprovalG/simsaGUpload.do?docID=" + pDocID, false);
	    SaveDocHTTp.send(getXmlString(sihangXML));
	     
	    if (SaveDocHTTp.responseText == "OK") {
	    	
	        $.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/checkPubDocXML.do",
	    		data : {
	    			xmlPath :  "/sendXML/" + pDocID + "pubdoc.xml"
	    		},
	    		success: function(xml){
	    			result = xml;
	    		}        			
	    	});
	        
	        if (result != "OK") {
	            var pAlertContent = strLang185;
	            OpenAlertUI(pAlertContent);
	            return false;
	        } else {
	            var rtnXML = makeExtinfo(sihangXML, newDocID, "SEND");
	            result = sendExtDoc(rtnXML);
	            if (result) {
	            	return true;
	            } else {
	            	return false;
	            }
	        }
	    }
	}

function Conversion(pixel) {
    //return parseInt(pixel * (35 / 100));
    return Number(pixel * (26.4583 / 100));
}

function SizeConvert(size) {
    //return Math.round(parseFloat(size) * parseFloat("0.35")).toFixed(2);
    return Math.floor(parseFloat(size) * parseFloat("0.264583")).toFixed(4);
}

function covBody(pbody) {
	pbody = removeTags(pbody, '<caption><img><i><b><u><sub><sup><br><p><span><ul><ol><li><table><tbody><tr><td>');
	
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

    while (i < endIdx) {
        compSTR = tmpSTR.substr(i, 1);

        if (compSTR == "<") strgt = true;
        if (compSTR == ">") strgt = false;

        if (!startflag) {
            if (compSTR == "=" && strgt) {
                i = i + 1
                subcompSTR = tmpSTR.substr(i, 1);
                if (compSTR == "<") strgt = true;
                if (compSTR == ">") strgt = false;

                if (subcompSTR != compChar && strgt) {
                    newSTR = newSTR + compSTR.toLowerCase() + "'" + subcompSTR.toLowerCase();
                    startflag = true;
                }
                else {
                    if (strgt) {
                        if (subcompSTR == compChar) subcompSTR = "'";
                        newSTR = newSTR + compSTR.toLowerCase() + subcompSTR.toLowerCase();
                    }
                    else
                        newSTR = newSTR + compSTR + subcompSTR;
                }
            }
            else {
                if (strgt) {
                    if (compSTR == compChar) compSTR = "'";
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
                    if (compSTR == compChar) compSTR = "'";
                    newSTR = newSTR + "'" + compSTR.toLowerCase() + " ";
                }
                else
                    newSTR = newSTR + "'" + compSTR + " ";
                startflag = false
            }
            else {
                if (strgt) {
                    if (compSTR == compChar) compSTR = "'";
                    newSTR = newSTR + compSTR.toLowerCase();
                }
                else
                    newSTR = newSTR + compSTR;
            }
            i = i + 1
        }
    }
    var re = /&nbsp;/g;
    var BodyStr = "<content>" + newSTR.replace(re, "&amp;nbsp;").replace(/&lt;/g, "&amp;lt;").replace(/&gt;/g, "&amp;gt;") + "</content>";

    BodyStr = BodyStr.replace(/: '/g, ":");
    BodyStr = BodyStr.replace(/''(?=[a-zA-Z0-9])/g, "'");
    BodyStr = BodyStr.replace(/''>/g, "'>");
    BodyStr = BodyStr.replace(/'; /g, "; ");
    BodyStr = BodyStr.replace(/''font-size:'/g, "'font-size:");
    
    BodyStr = BodyStr.replace(/''margin-bottom:'/g, "'margin-bottom:");
    BodyStr = BodyStr.replace(/='>/g, "=''>");
    BodyStr = BodyStr.replace(/(style|data-\w+)=('')/g, "$1=''");
    BodyStr = BodyStr.replace(/:'  '/g, ":");
    BodyStr = BodyStr.replace(/:'  /g, ":");
    BodyStr = BodyStr.replace(/';'/g, ";'");

    BodyStr = BodyStr.replace(/(\?(\w)*?\w=)((')(\w*?)['])/ig, "$1$5$4");
    BodyStr = BodyStr.replace(/\n|\r|\t/g, "");
    
    var xmlpara = loadXMLString(BodyStr);
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

function styleToAttribute(bodyElem) {
	var pElem = bodyElem.getElementsByTagName("p");
	for (var i = 0; i < pElem.length; i++) {
        if (pElem[i].style) {
            if (pElem[i].style.textAlign) {
                var alignVal = pElem[i].style.removeProperty("text-align");
                if (alignVal == 'justify') {
                    pElem[i].removeAttribute("align");
                } else {
                    pElem[i].align = alignVal;
                }
            }
            
            if (pElem[i].style.lineHeight) {
                var lh = pElem[i].style.lineHeight;
    
                if (isLineHeightUnitless(lh)) {
                    var fontSizeStr = pElem[i].style.fontSize;
                    var fontPx = 16;
    
                    if (fontSizeStr) {
                        var match = fontSizeStr.match(/^([\d.]+)(pt|px)?$/);
                        if (match) {
                            var size = parseFloat(match[1]);
                            var unit = match[2] || "px";
    
                            if (unit == "pt") {
                                fontPx = size * (96 / 72);
                            } else if (unit == "px") {
                                fontPx = size;
                            } else {
                                fontPx = 16;
                            }
                        }
                    }
    
                    var multiplier = parseFloat(lh);
                    if (!isNaN(multiplier)) {
                        pElem[i].style.lineHeight = (fontPx * multiplier) + "px";
                    }
                }
            }
        }
    
		if (pElem[i].getAttribute("style") == "") {
			pElem[i].removeAttribute("style");
		}
	}
}

function isLineHeightUnitless(value) {
  return !!value && /^[\d.]+$/.test(value);
}

function FileUpload(pFileName, pURL, localPath)
{
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
	
	if(rtnVal == "SUCCESS")
	{
		return true;	
	}	
	else
	{
		return false;
	}
}

function makeExtinfo(psihangXML, newDocID, mode) {
    try {
        var ExtSNodes, Nodes, Nodes2, strTO, i;
        var isfirst;

        //var ExtXML = createXmlDom();
        //var xmlhttp = createXMLHttpRequest();
        //xmlhttp.open("GET", "packXML.xml", false);
        //xmlhttp.send("");
        //var objSave = new ActiveXObject("EzUtil.MiscFunc");
        var ExtXML = loadXMLFile("/xml/ezApprovalG/packXML.xml"); // xmlhttp.responseXML;	  
        var eNodes = ExtXML.documentElement;
        var Nodes = psihangXML.documentElement;

        //var Nodes = eNodes.selectNodes("header/send-orgcode");
        //Nodes(0).text = companyID;
        var Nodes = SelectNodes(eNodes, "send-orgcode");
        setNodeText(Nodes[0], companyID);
        
        Nodes = SelectNodes(eNodes, "send-id");
        setNodeText(Nodes[0],companyID);

        Nodes = SelectNodes(eNodes, "send-name");
        setNodeText(Nodes[0], companyName);

        isfirst = true;
        if (mode == "GPKI") {
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
        }
        else {
            for (i = 0; i < isGPKI.length; i++) {
                if (isGPKI[i] == "N") {
                    if (isfirst) {
                        strTO = BaseURL[i];
                        isfirst = false;
                    }
                    else
                        strTO = strTO + ";" + BaseURL[i];
                }
            }
        }

        Nodes = SelectNodes(eNodes, "receive-id");
        setNodeText(Nodes[0], strTO);

        Nodes = SelectNodes(eNodes, "date");
        setNodeText(Nodes[0], "");

        Nodes = SelectNodes(eNodes, "title");
        setNodeText(Nodes[0], getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[7]));

        Nodes = SelectNodes(eNodes, "doc-id");
        setNodeText(Nodes[0], pOrgDocID);

        Nodes = SelectNodes(eNodes, "doc-type");
        if (pAprType == strLang186)
            SetAttribute(Nodes[0], "type", "resend")            
        else
            SetAttribute(Nodes[0], "type", "send");

        SetAttribute(Nodes[0], "dept", getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[17]));
        SetAttribute(Nodes[0], "name", getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[14]));

        Nodes = SelectNodes(eNodes, "send-gw");
        setNodeText(Nodes[0], "ezFlow2000/G");

        Nodes = SelectNodes(eNodes, "dtd-version");
        setNodeText(Nodes[0], "2.0");

        Nodes = SelectNodes(eNodes, "xsl-version");
        setNodeText(Nodes[0], "2.0");

        Nodes = SelectNodes(eNodes, "contents");

        var tempNode = createNode(sihangXML, "content");
        Nodes[0].appendChild(tempNode);

        SetAttribute(tempNode, "content-role", "pubdoc");
        SetAttribute(tempNode, "filename", "pubdoc.xml");
        SetAttribute(tempNode, "content-transfer-encoding", "base64");
        SetAttribute(tempNode, "content-type", "text/xml");
        SetAttribute(tempNode, "charset", "");

        var strtempxml = getXmlString(psihangXML);
        var re = /&amp;nbsp;/g;
        var strtempxml = strtempxml.replace(re, "&nbsp;")
        var re = /strong>/g;
        var strtempxml = strtempxml.replace(re, "b>")
        
        setNodeText(tempNode, "<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml:stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">" + strtempxml);

        if (sealName != "") {
            var Nodes = SelectNodes(eNodes, "contents");
            var tempNode = createNode(sihangXML, "content"); 
            Nodes[0].appendChild(tempNode);

            SetAttribute(tempNode, "content-role", "seal");
            SetAttribute(tempNode, "filename", sealName); // btoa
            SetAttribute(tempNode, "content-transfer-encoding", "base64");
            SetAttribute(tempNode, "content-type", "");
            SetAttribute(tempNode, "charset", "UTF-8");
            setNodeText(tempNode, sealPath.replace(pDomainName, ""));                        
        }


        for (i = 0; i < attachName.length; i++) {
            var Nodes = SelectNodes(eNodes, "contents"); 
            var tempNode = createNode(sihangXML, "content");
            Nodes[0].appendChild(tempNode);
            if (attachType[i] == "Y")
                SetAttribute(tempNode, "content-role", "attach_body");
            else
                SetAttribute(tempNode, "content-role", "attach");

            SetAttribute(tempNode, "filename", attachName[i]); // btoa
            SetAttribute(tempNode, "content-transfer-encoding", "base64");
            SetAttribute(tempNode, "content-type", "");
            SetAttribute(tempNode, "charset", "");
            setNodeText(tempNode, attachPath[i].replace(pDomainName, ""));                        
        }

        if (attachxmlPath != "") {
            var Nodes = SelectNodes(eNodes, "contents"); 
            var tempNode = createNode(sihangXML, "content");
            Nodes[0].appendChild(tempNode);

            SetAttribute(tempNode, "content-role", "attach_xml");
            SetAttribute(tempNode, "filename", attachxmlName); // btoa
            SetAttribute(tempNode, "content-transfer-encoding", "base64");
            SetAttribute(tempNode, "content-type", "html/xml");
            SetAttribute(tempNode, "charset", "");
            setNodeText(tempNode, attachxmlPath.replace(pDomainName, ""));
        }

        if (attachxslPath != "") {
            var Nodes = SelectNodes(eNodes, "contents");
            var tempNode = createNode(sihangXML, "content");
            Nodes[0].appendChild(tempNode);

            SetAttribute(tempNode, "content-role", "attach_xsl");
            SetAttribute(tempNode, "filename", attachxslName); // btoa
            SetAttribute(tempNode, "content-transfer-encoding", "base64");
            SetAttribute(tempNode, "content-type", "html/xsl");
            SetAttribute(tempNode, "charset", "");
            setNodeText(tempNode, attachxslPath.replace(pDomainName, ""));
        }

        for (i = 1; i < psignCount; i++) {
            var Nodes = SelectNodes(eNodes, "contents");
            var tempNode = createNode(sihangXML, "content");
            Nodes[0].appendChild(tempNode);

            SetAttribute(tempNode, "content-role", "sign");
            SetAttribute(tempNode, "filename", psignName[i]); // btoa
            SetAttribute(tempNode, "content-transfer-encoding", "base64");
            SetAttribute(tempNode, "content-type", "");
            SetAttribute(tempNode, "charset", "");
            setNodeText(tempNode, psignPath[i].replace(pDomainName, ""));
        }

        if (symbolName != "") {
            var Nodes = SelectNodes(eNodes, "contents"); 
            var tempNode = createNode(sihangXML, "content");
            Nodes[0].appendChild(tempNode);

            SetAttribute(tempNode, "content-role", "symbol");
            SetAttribute(tempNode, "filename", symbolName); // btoa
            SetAttribute(tempNode, "content-transfer-encoding", "base64");
            SetAttribute(tempNode, "content-type", "");
            SetAttribute(tempNode, "charset", "");
            setNodeText(tempNode, symbolPath.replace(pDomainName, ""));
        }

        if (logoName != "") {
            var Nodes = SelectNodes(eNodes, "contents");
            var tempNode = createNode(sihangXML, "content");
            Nodes[0].appendChild(tempNode);

            SetAttribute(tempNode, "content-role", "logo");
            SetAttribute(tempNode, "filename", logoName); // btoa
            SetAttribute(tempNode, "content-transfer-encoding", "base64");
            SetAttribute(tempNode, "content-type", "");
            SetAttribute(tempNode, "charset", "");
            setNodeText(tempNode, logoPath.replace(pDomainName, ""));
        }
        return ExtXML;
    } catch (e) {
        alert("makeExtinfo : " + e.description);
    }
}

var i = 0;
function sendExtDoc(ExtXML) {
	try {
		i = i + 1;		
		
	    $.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/sendMsg.do",
			data : {
				extXML : getXmlString(ExtXML),
				xmlPath : pDocID + i + "pack.xml",
				docID : pOrgDocID
			},
			success: function(xml){
				result = xml;
			},
			error : function () {
				return false;
			}       			
		});
		
	    if (result == "OK") {
	    	return true;
	    }
	} catch(e) {
		return false;
	}
}

function encodeDN(ExtXML) {
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/sendMsg2.do",
		data : {
			extXML : getXmlString(ExtXML)
		},
		success: function(xml){
			result = xml;
		}        			
	});
	return result;
}

function encodeUP(emlName)
{	
	var ouCodes;
	var rtnVal = true;
	
	pzFormProc.ShowWorkingDlg("\n" + strLang188, true);
	
	var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	ContentXML = objSave.LoadTextFromFile("c:\\" + emlName)

	ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");

    var xmlContent = new ActiveXObject("Microsoft.XMLDOM");
	xmlContent.loadXML(ContentXML);
	
	var ContentsView = xmlContent.selectSingleNode("pack/contents");
	var ContentText = "";
	for (i=0; i<ContentsView.childNodes.length; i++)
	{
		ContentText = ContentText + ContentsView.childNodes(i).xml;
	}
	objSave.SaveTextToFile("c:\\content.xml", ContentText);
	
	arrDelFiles[arrDelFiles.length] = "c:\\content.xml";
	
	if(ObjGPKI.Parse("c:\\content.xml")) 
	{
		var i = 0;
		ouCodes = "";
		
		var strTO;
		var isfirst = true;
		
		for(i = 0 ; i < isGPKI.length; i++)
		{
			if(isGPKI[i] == "Y")
			{
				ouCodes = ouCodes + BaseURL[i] + ";";
				
				if(isfirst)
				{
					strTO = AddInfo[i];
					isfirst = false;	
				}
				else
					strTO = strTO + "," + AddInfo[i];
			}
		}
		
		var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		xmlhttp.open("POST", "aspx/getServerTime.aspx", false);
		xmlhttp.send();
		
		if(is_Enc == "ENC")
		{		
			if(ObjGPKI.Encode(encodePath, ouCodes, encodePass, xmlhttp.responseText))
			{
				var dday = ObjGPKI.errorMsg
				if (ObjGPKI.FailCertList != "")
				{
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
					for(i=0;i<isGPKI.length;i++)
					{
						if (tempFailList.indexOf(BaseURL[i]) >= 0 )
						{
							isGPKI[i] = "N"
							if (isfirst)
							{
								TempRecvList = AddInfo[i];
								isfirst = false;
							}
							else
							{
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + "[" + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}
				
				ObjGPKI.WriteResultFile("C:\\upload.p7m");
				var GPKIContent = objSave.DownloadToBase64("C:\\upload.p7m");
				
				var NewContents = makePKIHeader(GPKIContent);
				// 2018-08-25 sendExtDoc 함수 변경됨(클라이언트에서 Content를 넘겨주지 않고 서버에서 읽어서 처리). GPKI쪽 개발 시 참고!
				rtnVal = sendExtDoc(NewContents);
			}
			else
			{
				if (ObjGPKI.FailCertList != "")
				{
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
					for(i=0;i<isGPKI.length;i++)
					{
						if (tempFailList.indexOf(BaseURL[i]) >= 0 )
						{
							isGPKI[i] = "N"
							if (isfirst)
							{
								TempRecvList = AddInfo[i];
								isfirst = false;
							}
							else
							{
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + "[" + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}			
				else
				{
					var pAlertContent = strLang191 + ObjGPKI.errorMsg;
					OpenAlertUI(pAlertContent);				
					rtnVal = false;
				}
			}
		}
		else if(is_Enc == "SIGN")
		{
			if(ObjGPKI.EncodeBySign(encodePath, ouCodes, encodePass, xmlhttp.responseText))
			{
				var dday = ObjGPKI.errorMsg
				if (ObjGPKI.FailCertList != "")
				{
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
					for(i=0;i<isGPKI.length;i++)
					{
						if (tempFailList.indexOf(BaseURL[i]) >= 0 )
						{
							isGPKI[i] = "N"
							if (isfirst)
							{
								TempRecvList = AddInfo[i];
								isfirst = false;
							}
							else
							{
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + "["  + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}
				
				ObjGPKI.WriteResultFile("C:\\upload.p7m");
				var GPKIContent = objSave.DownloadToBase64("C:\\upload.p7m");
				
				arrDelFiles[arrDelFiles.length] = "C:\\upload.p7m";
				
				var NewContents = makePKIHeader(GPKIContent);
				// 2018-08-25 sendExtDoc 함수 변경됨(클라이언트에서 Content를 넘겨주지 않고 서버에서 읽어서 처리). GPKI쪽 개발 시 참고!
				rtnVal = sendExtDoc(NewContents);
			}
			else
			{
				if (ObjGPKI.FailCertList != "")
				{
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
					for(i=0;i<isGPKI.length;i++)
					{
						if (tempFailList.indexOf(BaseURL[i]) >= 0 )
						{
							isGPKI[i] = "N"
							if (isfirst)
							{
								TempRecvList = AddInfo[i];
								isfirst = false;
							}
							else
							{
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + "["  + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}			
				else
				{			
					var pAlertContent = strLang191 + ObjGPKI.errorMsg;
					OpenAlertUI(pAlertContent);
					rtnVal = false;
				}
			}
		}
		else
		{
			var pAlertContent = strLang192 + "<br>" + strLang193;
			OpenAlertUI(pAlertContent);
			rtnVal = false;
		}
	}
	else {
	}
	pzFormProc.ShowWorkingDlg("", false);
	
	return rtnVal;
}

function makePKIHeader(psihangXML)
{
	var ExtSNodes, Nodes, Nodes2, strTO, i;
	var isfirst;
	
	var ExtXML =  new ActiveXObject("Microsoft.XMLDOM");
	ExtXML.async = false;
	ExtXML.load("packXML.xml");
	
  try {	
	var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	var eNodes = ExtXML.documentElement;
	var Nodes = psihangXML.documentElement;
	
	var Nodes = eNodes.selectNodes("header/send-orgcode");
	Nodes(0).text = companyID;
	
	var Nodes = eNodes.selectNodes("header/send-id");
	Nodes(0).text = companyID;

	var Nodes = eNodes.selectNodes("header/send-name");
	Nodes(0).text = btoa(companyName);
	
	isfirst = true;
	for(i=0;i<isGPKI.length;i++)
	{
		if(isGPKI[i] == "Y")
		{
			if(isfirst)
			{
				strTO = BaseURL[i];
				isfirst = false;	
			}
			else
				strTO = strTO + ";" + BaseURL[i];
		}		
	}	
	
	var Nodes = eNodes.selectNodes("header/receive-id");
	Nodes(0).text = strTO;

	var Nodes = eNodes.selectNodes("header/date");
	Nodes(0).text = "";

	var Nodes = eNodes.selectNodes("header/title");
	Nodes(0).text = btoa(pDocInfoXML.documentElement.childNodes(7).text);

	var Nodes = eNodes.selectNodes("header/doc-id");
	Nodes(0).text = pOrgDocID;

	var Nodes = eNodes.selectNodes("header/doc-type");
	if (pAprType == strLang186)
		Nodes(0).setAttribute("type", "resend");
	else
		Nodes(0).setAttribute("type", "send");
	Nodes(0).setAttribute("dept", btoa(pDocInfoXML.documentElement.childNodes(17).text));
	Nodes(0).setAttribute("name", btoa(pDocInfoXML.documentElement.childNodes(14).text));

	var Nodes = eNodes.selectNodes("header/send-gw");
	Nodes(0).text = btoa("ezFlow2000/G");

	var Nodes = eNodes.selectNodes("header/dtd-version");
	Nodes(0).text = "2.0";

	var Nodes = eNodes.selectNodes("header/xsl-version");
	Nodes(0).text = "2.0";
	
	var Nodes = eNodes.selectNodes("contents");
	var tempNode = sihangXML.createNode(1,"content","");
	Nodes(0).appendChild(tempNode);
	tempNode.setAttribute("content-role", "gpki");
	tempNode.setAttribute("filename", btoa("smime.p7m"));
	tempNode.setAttribute("content-transfer-encoding", "base64");
	if(is_Enc == "ENC")
		tempNode.setAttribute("content-type", "application/gcc-mime;smime-type=signedandenveloped-data;");
	else
		tempNode.setAttribute("content-type", "application/gcc-mime;smime-type=signed-data;");  // 전자관인만
	tempNode.setAttribute("charset", "");
	tempNode.text = psihangXML;

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

function setMenuDisable(id, flag) {
    if (document.getElementById(id) != null) {
        if (flag)
            document.getElementById(id).style.display = "";
        else
            document.getElementById(id).style.display = "none";
    }
}