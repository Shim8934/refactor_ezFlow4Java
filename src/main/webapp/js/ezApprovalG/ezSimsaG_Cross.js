var selectenc_dialogArguments = new Array();
function OpenCheckUI()
{
	var parameter = "";
	var url = "selectEnc.aspx";

	selectenc_dialogArguments[0] = parameter;
	selectenc_dialogArguments[1] = OpenCheckUI_Complete;

	DivPopUpShow(330, 205, "/myoffice/ezApprovalG/enforce/selectEnc.aspx");
}

function GetAprDeptXML()
{
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
	
	for (i=0; i<APRDEPTXML.getElementsByTagName("DATA3").length; i++)
	{
	    if (getNodeText(APRDEPTXML.getElementsByTagName("DATA3").item(i)) == "Y")
			isExternal = true;
	}
	
	if (isExternal)
	{
		for (i=0; i<APRDEPTXML.getElementsByTagName("DATA1").length; i++)
		{
		    if (getNodeText(APRDEPTXML.getElementsByTagName("DATA1").item(i)).indexOf("Address") > -1)
				isAddress = true;
		}
	}
}

function GetEndDocInfo()
{
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);

	xmlhttp.open("POST","../aspx/getEndDocInfo.aspx",false);
	xmlhttp.send(xmlpara);

	pDocInfoXML = xmlhttp.responseXML;
}

function getLineInfo()
{
    var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
	createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);

	xmlhttp.open("Post","aspx/getLineInfo.aspx",false);
	xmlhttp.send(xmlpara);
	
	return xmlhttp.responseXML;
}

function chkToInfo()
{
	var i;
	var isFrom_Cert = true;	
	sendCNT[0] = 0;
	sendCNT[1] = 0;
	
	if(is_Enc == "NONE") isFrom_Cert = false;
	
	for (i=0; i<APRDEPTXML.getElementsByTagName("DATA1").length; i++)
	{
	    BaseURL[i] = getNodeText(APRDEPTXML.getElementsByTagName("DATA1").item(i));
	    AddInfo[i] = getNodeText(APRDEPTXML.getElementsByTagName("DATA9").item(i));
		if(isFrom_Cert)
		{
			isGPKI[i] = "Y";
			sendCNT[0] = sendCNT[0] + 1;
		}
		else
		{
			isGPKI[i] = "N"
			sendCNT[1] = sendCNT[1] + 1;		
		}	
	}
	return true;
}

var cert_dialogArguments = new Array();
function getPasswdEnd()
{
    cert_dialogArguments[0] = true;
    cert_dialogArguments[1] = getPasswdEnd_Complete;

    DivPopUpShow(420, 350, "/myoffice/ezApprovalG/enforce/cert.aspx");
}

function getPasswdEnd_Complete(ret) {
    DivPopUpHidden();
    if (ret[0]) {
        encodePass = ret[1];
        encodePath = ret[2];
    }
    if (makeXML(pDocID))
        Check_Container();
    else
        return false;
}

function sendExt()
{
	var orgHTML;
	var sihangDate = "";
	var field;
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
    var xmlRtn;	
		
	var chkFlag = chkToInfo();
	if (!chkFlag)
	{
		return;
	}
	if (sendCNT[0] > 0) {
	    if (!getPasswdEnd()) {
	        return;
	    }
	}
	else {
	    if (makeXML(pDocID))
	        Check_Container();
	    else
	        return false;
	}
}


function makeXML(newDocID) {
    GetEndDocInfo();
    var fields = message.GetFieldsList();
    var field;
    var tempNode;
    var mhtBody = "";
    mhtBody = message.Get_EditorBodyHTML()
    field = message.GetListItem(fields, "opinions");
    if (field) {
        var bodyfield = message.GetListItem(fields, "body");
        if (bodyfield) {
            bodyfield.innerHTML = bodyfield.innerHTML + field.innerHTML;
            field.innerHTML = "";
        }
    }

    sihangXML = loadXMLFile("pubdocsample.xml");
    var eNodes = sihangXML.documentElement;

    var Nodes = eNodes.getElementsByTagName("organ");
    field = message.GetListItem(fields, "organ");
    if (field) {
        setNodeText(Nodes.item(0), trim_Cross(field.innerText));
    }
    else {
        setNodeText(Nodes.item(0), "");
    }

    var Nodes = eNodes.getElementsByTagName("recipient");
    field = message.GetListItem(fields, "recipients");
    if (field) {
        if (trim_Cross(field.innerText).length <= 1) {
            SetAttribute(Nodes[0], "refer", "false");
            field = message.GetListItem(fields, "recipient");
            if (field) {
                tempNode = eNodes.getElementsByTagName("rec");
                setNodeText(tempNode.item(0), trim_Cross(field.innerText));
            }
        }
        else {
            SetAttribute(Nodes[0], "refer", "true");            
            tempNode = eNodes.getElementsByTagName("rec");
            setNodeText(tempNode.item(0), trim_Cross(field.innerText).replace(strLang177, ""))
        }
    }

    var Nodes = eNodes.getElementsByTagName("receiptinfo");
    field = message.GetListItem(fields, "refer");
    if (field) {
        if (trim_Cross(field.innerText).length > 1) {
            var objChildNodes;
            createNodeAndAppandNodeText(sihangXML, Nodes.item(0), objChildNodes, "vis", trim_Cross(field.innerText))
        }
    }

    var Nodes = eNodes.getElementsByTagName("title");
    field = message.GetListItem(fields, "doctitle");
    if (field) {
        setNodeText(Nodes.item(0), trim_Cross(field.innerText));
    }
    else {
        setNodeText(Nodes.item(0), "");
    }

    var Nodes = eNodes.getElementsByTagName("body");
    if (attachbodyPath != "") 
        SetAttribute(Nodes[0], "separate", "true");
    else 
        SetAttribute(Nodes[0], "separate", "false");    

    var Nodes = SelectNodes(eNodes, "body");
    field = message.GetListItem(fields, "body");
    if (field) {

        var strBody = "";
        if (CrossYN())
            strBody = Document_Encode(GetChildNodes(field)[0].innerHTML);
        else
            strBody = Document_Encode(trim_Cross(field.innerHTML));


        var re = /vAlign=center/g;
        strBody = strBody.replace(re, "vAlign=middle");        

        strBody = covBody(strBody);        
        Nodes[0].appendChild(strBody);
    }
    else {
        setNodeText(Nodes[0], "");
    }

    var Nodes = eNodes.getElementsByTagName("sendername");
    field = message.GetListItem(fields, "chief");
    if (field) {
        setNodeText(Nodes.item(0), trim_Cross(field.innerText));
    }
    else {
        setNodeText(Nodes.item(0), "");
    }

    var Nodes = eNodes.getElementsByTagName("seal");
    if (NostampFlag) {
        SetAttribute(Nodes[0], "omit", "true");
    }
    else {
        field = message.GetListItem(fields, "sealsign");
        if (field) {
            if (field.childNodes.length > 0) {
                SetAttribute(Nodes[0], "omit", "false");
                var objChildNodes;
                objChildNodes = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), objChildNodes, "img", "")
                sealPath = GetAttribute(field, "surl");

                var len = sealPath.lastIndexOf("/");
                var filelength = sealPath.length - (len + 1);
                sealName = sealPath.substr(len + 1, filelength);
                SetAttribute(objChildNodes, "src", trim_Cross(sealName));
                SetAttribute(objChildNodes, "alt", strLang178);
                SetAttribute(objChildNodes, "height", Conversion(parseInt(field.childNodes.item(0).height)).toString() + "mm");
                SetAttribute(objChildNodes, "width", Conversion(parseInt(field.childNodes.item(0).width)).toString() + "mm");
                
            }
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
            SetAttribute(tempNode2, "order", getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));

            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signposition", "");
            if (getNodeText(LineNodes.item(i).getElementsByTagName("OPINION").item(0)) == "YES")
                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("SIGNPOSITION").item(0)) + "(" + strLang5);
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

                                var signPath = imageflag && field.childNodes.item(j).getAttribute("spath");
                                var len = signPath.lastIndexOf("/");
                                var filelength = signPath.length - (len + 1);
                                var signName = signPath.substr(len + 1, filelength);

                                SetAttribute(tempNode4, "src", sealName);
                                SetAttribute(tempNode4, "alt", strLang179);
                                SetAttribute(tempNode4, "height", Conversion(field.childNodes.item(j).height).toString() + "mm");
                                SetAttribute(tempNode4, "width", Conversion(field.childNodes.item(j).width).toString() + "mm");                                

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
            setNodeText(tempNode2, getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));

            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signposition", "");
            if (getNodeText(LineNodes.item(i).getElementsByTagName("OPINION").item(0)) == "YES")
                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)) + "(" + strLang5);
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

                    var signPath = field.childNodes.item(j).getAttribute("spath");
                    var len = signPath.lastIndexOf("/");
                    var filelength = signPath.length - (len + 1);
                    var signName = signPath.substr(len + 1, filelength);
                    SetAttribute(tempNode4, "src", sealName);
                    SetAttribute(tempNode4, "src", strLang179);
                    SetAttribute(tempNode4, "src", Conversion(field.childNodes.item(0).height).toString() + "mm");
                    SetAttribute(tempNode4, "src", Conversion(field.childNodes.item(0).width).toString() + "mm");

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
        setNodeText(Nodes[0], trim_Cross(field.innerText));
        SetAttribute(Nodes[0], "regnumbercode", getNodeText(pDocInfoXML.getElementsByTagName("DOCNUMCODE").item(0)));
    }
    else {
        setNodeText(Nodes[0], "");
        SetAttribute(Nodes[0], "regnumbercode", "");
    }

    var Nodes = eNodes.getElementsByTagName("enforcedate");
    field = message.GetListItem(fields, "enforcedate");
    if (field) {
        setNodeText(Nodes.item(0), trim_Cross(field.innerText));
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
        setNodeText(tempNode3, trim_Cross(field.innerText));

        var tempNode3;
        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");
        var field2 = message.GetListItem(fields, "receiptdate");
        if (field2)
            setNodeText(tempNode3, trim_Cross(field2.innerText));
    }

    var Nodes = eNodes.getElementsByTagName("sendinfo");
    field = message.GetListItem(fields, "zipcode");
    var tempNode2;
    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "zipcode", "");
    if (field)
        setNodeText(tempNode2, trim_Cross(field.innerText));


    field = message.GetListItem(fields, "address");
    var tempNode2;
    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "address", "");
    if (field)
        setNodeText(tempNode2, trim_Cross(field.innerText));

    field = message.GetListItem(fields, "address");
    var tempNode2;
    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "homeurl", "");
    if (field)
        setNodeText(tempNode2, trim_Cross(field.innerText));

    field = message.GetListItem(fields, "telephone");
    var tempNode2;
    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "telephone", "");
    if (field)
        setNodeText(tempNode2, trim_Cross(field.innerText));

    field = message.GetListItem(fields, "fax");
    var tempNode2;
    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "fax", "");
    if (field)
        setNodeText(tempNode2, trim_Cross(field.innerText));

    field = message.GetListItem(fields, "email");
    var tempNode2;
    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "fax", "");
    if (field)
        setNodeText(tempNode2, trim_Cross(field.innerText));

    field = message.GetListItem(fields, "publication");
    var tempNode2;
    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "fax", "");
    SetAttribute(tempNode2, "code", getNodeText(pDocInfoXML.getElementsByTagName("PUBLICITYCODE").item(0)));
    if (field)
        setNodeText(tempNode2, trim_Cross(field.innerText));

    field = message.GetListItem(fields, "symbol");
    if (field) {
        if (field.childNodes.length > 0) {
            if (field.childNodes.item(0).tagName == "IMG") {
                var tempNode2;
                tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "symbol", "");

                var tempNode3;
                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "img", "");

                symbolPath = field.childNodes.item(0).getAttribute("web");
                var len = symbolPath.lastIndexOf("/");
                var filelength = symbolPath.length - (len + 1);
                symbolName = symbolPath.substr(len + 1, filelength);

                SetAttribute(tempNode3, "src", symbolName);
                SetAttribute(tempNode3, "alt", strLang180);
                SetAttribute(tempNode3, "height", Conversion(field.childNodes.item(0).height).toString() + "mm");
                SetAttribute(tempNode3, "width", Conversion(field.childNodes.item(0).width).toString() + "mm");
            }
        }
    } 
    field = message.GetListItem(fields, "logo");
    if (field) {
        if (field.childNodes.length > 0) {
            if (field.childNodes.item(0).tagName == "IMG") {
                logoPath = field.childNodes.item(0).getAttribute("web");
                if (logoPath) {
                    var tempNode2;
                    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "logo", "");

                    var tempNode3;
                    tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "img", "");

                    var len = logoPath.lastIndexOf("/");
                    var filelength = logoPath.length - (len + 1);
                    logoName = logoPath.substr(len + 1, filelength);

                    SetAttribute(tempNode3, "src", logoName);
                    SetAttribute(tempNode3, "alt", strLang181);
                    SetAttribute(tempNode3, "height", Conversion(field.childNodes.item(0).height).toString() + "mm");
                    SetAttribute(tempNode3, "width", Conversion(field.childNodes.item(0).width).toString() + "mm");
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
        setNodeText(tempNode3, trim_Cross(field.innerText));

        var field2 = message.GetListItem(fields, "footcampaign");
        if (field2) {
            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "footcampaign", trim_Cross(field2.innerText));
        }
    }
    else {
        var field2 = message.GetListItem(fields, "footcampaign");
        if (field2) {
            var tempNode2;
            tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "campaign", "");

            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "footcampaign", trim_Cross(field2.innerText));
        }
    }

    if (attachName.length > 0) {
        var tempNode2;
        tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "attach", "");

        var i;
        for (i = 0; i < attachName.length; i++) {
            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "title", attachName[i]);
        }
    }

    var result = true;
    var sihangXML2 = sihangXML;
    var strtempxml = getXmlString(sihangXML2);
    var re = /&amp;nbsp;/g;
    var strtempxml = strtempxml.replace(re, "");
    var re = /strong>/g;
    var strtempxml = strtempxml.replace(re, "b>");
    
    sihangXML = loadXMLString(strtempxml);

    var SaveDocHTTp = createXMLHttpRequest();
    SaveDocHTTp.open("POST", "aspx/SimsaG_Upload.aspx?DOCID=" + pDocID, false);
    SaveDocHTTp.send(sihangXML);

    var ResultXML = SaveDocHTTp.responseXML;
    if (getNodeText(GetChildNodes(ResultXML)[0]) == "OK") {
        //var xmlhttp = createXMLHttpRequest();
        //var xmlPubDocCheck = createXmlDom();
        //var objNode;
        //createNodeInsert(xmlPubDocCheck, objNode, "PARAMETER");
        //createNodeAndInsertText(xmlPubDocCheck, objNode, "XMLPATH", "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + "pubdoc.xml");
        //xmlhttp.open("POST", "aspx/checkPubDocXML.aspx", false);
        //xmlhttp.send(xmlPubDocCheck);   

        //alert(xmlhttp.responseText);

        //if (xmlhttp.responseText != "0") {
        //    var pAlertContent = strLang185;
        //    OpenAlertUI(pAlertContent);
        //    return false;
        //}
        if (sendCNT[0] > 0) {
            var rtnXML = makeExtinfo(sihangXML, newDocID, "GPKI");
            if (encodePath == "NONE_Enc_SEND") {
                var rtnFileName = encodeDN(rtnXML);
                var objSave = new ActiveXObject("EzUtil.MiscFunc");
                ContentXML = objSave.LoadTextFromFile("c:\\" + rtnFileName)
                objSave = null;
                ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");
                var xmlContent = new ActiveXObject("Microsoft.XMLDOM");
                xmlContent.loadXML(ContentXML);
                result = sendExtDoc(xmlContent);
            }
            else {
                var rtnFileName = encodeDN(rtnXML);
                result = encodeUP(rtnFileName);
            }
        }

        if (sihangXML == "")
            sihangXML = sihangXML2;

        if (sendCNT[1] > 0) {
            var rtnXML = makeExtinfo(sihangXML, newDocID, "SEND")
            var resultXml = encodeDN(rtnXML);
            //var objSave = new ActiveXObject("EzUtil.MiscFunc");
            //ContentXML = objSave.LoadTextFromFile("c:\\" + rtnFileName);
            ContentXML = resultXml.split('::')[1];
            ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");

            //var xmlContent = createXmlDom();
            //xmlContent = loadXMLString(ContentXML);

            result = sendExtDoc(ContentXML);
        }
        if (result) {
            return true;
        }
        else {
            var pAlertContent = strLang185;
            OpenAlertUI(pAlertContent);
            return false;
        }
    }
}

function covBody(pbody) {
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
    var BodyStr = "<content>" + newSTR.replace(re, "&amp;nbsp;") + "</content>";

    BodyStr = BodyStr.replace(/: '/g, ":");
    BodyStr = BodyStr.replace(/'' /g, "' ");
    BodyStr = BodyStr.replace(/''>/g, "'>");
    BodyStr = BodyStr.replace(/'; /g, "; ");
    BodyStr = BodyStr.replace(/<br>/g, "");
    
    var xmlpara = loadXMLString(BodyStr);
    var bodyNodes = xmlpara.documentElement;
    return bodyNodes;
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
        var ExtXML = loadXMLFile("packXML.xml"); // xmlhttp.responseXML;	  
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
            SetAttribute(tempNode, "charset", "");
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
            setNodeText(tempNode, attachPath[i]);                        
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
            setNodeText(tempNode, attachxmlPath);
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
            setNodeText(tempNode, attachxslPath);
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
            setNodeText(tempNode, psignPath[i]);
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
function sendExtDoc(ExtXML)
{
	try
	{
		i = i + 1;		
		var xmlhttp = createXMLHttpRequest();
		var xmlpara = createXmlDom();
		var objNode;

		createNodeInsert(xmlpara, objNode, "PARAMETER");
	    createNodeAndInsertText(xmlpara, objNode, "XMLDATA", "<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\"><pack>" + ExtXML + "</pack>");
		createNodeAndInsertText(xmlpara, objNode, "XMLPATH", "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + i + "pack.xml");
						
		xmlhttp.open("Post","aspx/sendMsg_Cross.aspx",false);
		xmlhttp.send(xmlpara);
		return true;
	}
	catch(e)
	{
		return false;
	}
}

function encodeDN(ExtXML)	
{
    var xmlhttp = createXMLHttpRequest();
	xmlhttp.open("POST", "aspx/sendMsg2_Cross.aspx", false);
	xmlhttp.send(ExtXML);
	var XmlData = xmlhttp.responseText;
	return XmlData;
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
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}
				
				ObjGPKI.WriteResultFile("C:\\upload.p7m");
				var GPKIContent = objSave.DownloadToBase64("C:\\upload.p7m");
				
				var NewContents = makePKIHeader(GPKIContent);
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
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
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
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}
				
				ObjGPKI.WriteResultFile("C:\\upload.p7m");
				var GPKIContent = objSave.DownloadToBase64("C:\\upload.p7m");
				
				arrDelFiles[arrDelFiles.length] = "C:\\upload.p7m";
				
				var NewContents = makePKIHeader(GPKIContent);
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
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
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