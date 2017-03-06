function setAttachForm()
{
try{
  
    var doc;
    var form;
    
    doc = iframe.document;
    form = doc.all("form");
    form.UploadID.value = pBoardID;
    form.UploadSN.value = pAttachSN;		
    form.UploadMaxFileSize.value = pBoardFileSize;
    form.UploadAddFileSize.value = pAttachAddFileSize;
}catch(ErrMsg){
	alert(ErrMsg.description);
  }
}


function APRAttachXMLParsing()
{
  try{
     
    var i;
    var j;
    var strXML;

    var Rtnxml = createXmlDom();
    Rtnxml = loadXMLString(getXmlString(pAttachListXml));
    var objAttachNodes = SelectNodes(Rtnxml, "LISTVIEWDATA/ROWS/ROW");
	
	var pTotalRowsLen = objAttachNodes.length;
	
    var re = /&/g
	
    strXML = "<LISTVIEWDATA><HEADERS>";
    strXML = strXML + "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
    strXML = strXML + "<HEADER><NAME>" + strLang2 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    strXML = strXML + "</HEADERS><ROWS>";
	
    for( i = 0 ; i < pTotalRowsLen ; i++)
    {
        strXML = strXML + "<ROW><CELL><VALUE>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]).replace(re, "&amp;") + "</VALUE>";
        strXML = strXML + "<DATA1>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[1]).replace(re, "&amp;") + "</DATA1>";
        strXML = strXML + "<DATA2>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]).replace(re, "&amp;") + "</DATA2>";
        strXML = strXML + "<DATA3>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[3]) + "</DATA3>";
        strXML = strXML + "<DATA4>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[4]) + "</DATA4>";
        strXML = strXML + "<DATA5>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]) + "</DATA5>";
        strXML = strXML + "<DATA6>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[6]) + "</DATA6></CELL>";
        strXML = strXML + "<CELL><VALUE>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[1])[0]) + "</VALUE></CELL></ROW>";
    }
	strXML = strXML + "</ROWS></LISTVIEWDATA>";
	
	return strXML;

  }catch(ErrMsg){
  
    alert(ErrMsg.description);
  
  }
  
}



function DelAttachFileAtList(pNewNodeName)
{
  try{
    
    var Idoc;
    var Iform;

	var pDelAttachRow = pNewNodeName.split("*)[_-");

	var pDelCount = pDelAttachRow.length;
	
	var objXML = createXmlDom();
	
	//objXML = pAttachListXml;
	objXML = loadXMLString(getXmlString(pAttachListXml));
	
	var objAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
	
	var totalcnt = objAttachNodes.length;

	for (var i = 0; i < objAttachNodes.length; i++) {
		
		for (var k = 0; k < pDelCount-1; k++) {

		    var realFileNM = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]);

		    var DelFileSize = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[6]);
		    var objSelectedNode = objAttachNodes[i];
		    var is_newfile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]);

		
			var tempName = pDelAttachRow[k]
			tempName = ReplaceText(tempName, "&apos;", "'");

			if (tempName == realFileNM) 
			{
			    GetChildNodes(GetChildNodes(objXML)[0])[1].removeChild(objSelectedNode);
			    pAttachListXml = objXML;	    
				
			}
			
		}
	}

  }catch(ErrMsg){
  
    alert(ErrMsg.description);
  }
}

/*
// 2010.07.06 : Drag&Drop 실행, pAttatchFilePath
function AddAttachFileInfoXmlParsing(pfilename, pSaveFileName, pfilesize)
{
  try{
  
	var pstrXML;
	var re = /&/g;
	var objXML = createXmlDom();
	var Rtnxml = createXmlDom();

	
	//Rtnxml = loadXMLString(getXmlString(pAttachListXml));	
	//var objAttachNodes = SelectNodes(Rtnxml, "LISTVIEWDATA/ROWS/ROW");
	
	pstrXML = "<LISTVIEWDATA><HEADERS>";
	pstrXML = pstrXML + "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
	pstrXML = pstrXML + "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	pstrXML = pstrXML + "</HEADERS><ROWS><ROW><CELL>";
	pstrXML = pstrXML + "<VALUE>"+ pfilename.replace(re,"&amp;") +"</VALUE>";
	pstrXML = pstrXML + "<DATA1>" + pfilename.replace(re, "&amp;") + "</DATA1>";
	pstrXML = pstrXML + "<DATA2>" + pSaveFileName.replace(re, "&amp;") + "</DATA2>";
	pstrXML = pstrXML + "<DATA3></DATA3>";
	pstrXML = pstrXML + "<DATA4></DATA4>";
	pstrXML = pstrXML + "<DATA5>Y</DATA5>";
	pstrXML = pstrXML + "<DATA6>" + pfilesize + "</DATA6>";
	pstrXML = pstrXML + "</CELL><CELL>";
	pstrXML = pstrXML + "<VALUE>" + pfilesize +" Bytes" + "</VALUE>";
	pstrXML = pstrXML + "</CELL></ROW></ROWS></LISTVIEWDATA>";

	//objXML.loadXML(pstrXML);
	objXML = loadXMLString(pstrXML);

	//if (objAttachNodes.length == 0)
	if (document.getElementById('mode').value == "PHOTO") {
	    pAttachListXml = objXML;
	}
	else {
	    if (pAttachListXml == "") {
	        //pAttachListXml = objXML.xml;
	        pAttachListXml = objXML; //objXML.xml;
	    }
	    else {
	        if (typeof (pAttachListXml) == "string")
	            Rtnxml = loadXMLString(pAttachListXml);
	        else
	            Rtnxml = loadXMLString(getXmlString(pAttachListXml));
	        var objNewAttachNodes = objXML.documentElement.getElementsByTagName("ROW")[0]; // Resultxml.documentElement.getElementsByTagName("ROW")[0];
	        var Node = Rtnxml.importNode(objNewAttachNodes, true);

	        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(Node);
	        pAttachListXml = Rtnxml;
	    }
	}
      
	AppendFileAttachInfo(pAttachListXml);
	
    return;

  }catch(ErrMsg){
  
    alert(ErrMsg.description);
  }
}
*/
function AddAttachFileInfoXmlParsing(resultXML) {
    try {
        var xml = loadXMLString(resultXML);
        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
        var pstrXML="";
        var re = /&/g;
        var objXML = createXmlDom();
        var Rtnxml = createXmlDom();
        var filenm="";
        
        pstrXML += "<LISTVIEWDATA><HEADERS>";
        pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        pstrXML += "</HEADERS><ROWS>";
        for (i = 0; i < nodes.length; i++) {
            if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") != "denied") {
                pstrXML += "<ROW><CELL><VALUE>" + SelectSingleNodeValue(nodes[i], "PFILENAME").replace(re, "&amp;") + "</VALUE>";//파일명
                pstrXML += "<DATA1>" + SelectSingleNodeValue(nodes[i], "PFILENAME").replace(re, "&amp;") + "</DATA1>"; //파일명
                pstrXML += "<DATA2>" + SelectSingleNodeValue(nodes[i], "PUPLOADSN").replace(re, "&amp;") + "</DATA2>"; //저장될 파일명
                pstrXML += "<DATA3></DATA3>";
                pstrXML += "<DATA4></DATA4>";
                pstrXML += "<DATA5>Y</DATA5>";
                pstrXML += "<DATA6>" + SelectSingleNodeValue(nodes[i], "FILESIZE") + "</DATA6>";//파일크기
                pstrXML += "</CELL><CELL>";
                pstrXML += "<VALUE>" + SelectSingleNodeValue(nodes[i], "FILESIZE") + " Bytes" + "</VALUE>";//파일크기
                pstrXML += "</CELL></ROW>";
            }
        }
        pstrXML += "</ROWS></LISTVIEWDATA>";
        
        objXML = loadXMLString(pstrXML);

        if (document.getElementById('mode').value == "PHOTO") {
            pAttachListXml = objXML;
        } else {
            if (pAttachListXml == "") {
                pAttachListXml = objXML;
            } else {
                if (typeof (pAttachListXml) == "string") {
                    Rtnxml = loadXMLString(pAttachListXml);
                } else {
                    Rtnxml = loadXMLString(getXmlString(pAttachListXml));
                }
                
                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
                    
                    try {
                        var Node = Rtnxml.importNode(objNewAttachNodes, true);
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(Node);
                    } catch (e) {
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                    }
                }
                pAttachListXml = Rtnxml;
            }
        }
        
        AppendFileAttachInfo(pAttachListXml);
        return;

    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}
function importNode(node, allChildren) {
    switch (node.nodeType) {
        case document.ELEMENT_NODE:
            var newNode = document.createElementNS(node.namespaceURI, node.nodeName);
            if (node.attributes && node.attributes.length > 0)
                for (var i = 0, il = node.attributes.length; i < il; i++)
                    newNode.setAttribute(node.attributes[i].nodeName, node.getAttribute(node.attributes[i].nodeName));
            if (allChildren && node.childNodes && node.childNodes.length > 0)
                for (var i = 0, il = node.childNodes.length; i < il; i++)
                    newNode.appendChild(importNode(node.childNodes[i], allChildren));
            return newNode;
            break;
        case document.TEXT_NODE:
        case document.CDATA_SECTION_NODE:
        case document.COMMENT_NODE:
            return document.createTextNode(node.nodeValue);
            break;
    }
}

function AttachRemoveAll()
{
  try{
  
    var objRoot;
    var objNode;

    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();

    var objNode;

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);
  
    xmlhttp.open ("Post","/ezflow/ezAPRATTACH/AttachRemove.aspx",false);
    xmlhttp.send(xmlpara);
  
    return xmlhttp.responseText;
  
  }catch(ErrMsg){
    
    alert(ErrMsg.description);
  
  }
  
}

function DeleteFileAtServer(pAttachDelFileName) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pFileName", pAttachDelFileName);
    createNodeAndInsertText(xmlpara, objNode, "pCompanyID", pCompanyID);
    createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);

    xmlhttp.open("Post", "DeleteServerFile.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}


function DeleteSaveFileAtServer( pAttachDelFileName, pBoard, pItemID )
{
    try {

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pFileName", pAttachDelFileName);
    createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);
    createNodeAndInsertText(xmlpara, objNode, "pItemID", pItemID);
    createNodeAndInsertText(xmlpara, objNode, "pCompanyID", pCompanyID);
    
	
    xmlhttp.open ("Post","DeleteServerSaveFile.aspx",false);
    xmlhttp.send(xmlpara);
  
    return xmlhttp.responseText;

  }catch(ErrMsg){
  
    alert(ErrMsg.description);
  }
}


function OpenInformationUI(pInformationContent)
{
  var parameter = pInformationContent;
	
	//var url = "/ezflow/ezAPROPINION.htm";
	//var url = "/ezflow/ezAPROPINION.aspx";
	var url = "/myoffice/ezCommunity/htm/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:235px;dialogHeight:175px;help:no;scroll:no";
	
	var RtnVal = window.showModalDialog(url,parameter,feature);

  return RtnVal;
}
