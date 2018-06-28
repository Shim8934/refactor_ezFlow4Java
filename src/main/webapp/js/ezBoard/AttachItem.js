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
    Rtnxml = loadXMLString(pAttachListXml);
	var objAttachNodes = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
	
	var pTotalRowsLen = objAttachNodes.length;
	
    var re = /&/g;
	
    strXML = "<LISTVIEWDATA><HEADERS>";
    strXML = strXML + "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
    strXML = strXML + "<HEADER><NAME>" + strLang2 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    strXML = strXML + "</HEADERS><ROWS>";
	

    for (i = 0 ; i < pTotalRowsLen ; i++)
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
	objXML = loadXMLString(pAttachListXml);
	var objAttachNodes = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	

	for (var i = 0 ; i < objAttachNodes.length ; i++)
	{
	    var realFileNM = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]);
	    var DelFileSize = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[6]);
	    var objSelectedNode = objAttachNodes[i];
	    var is_newfile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]);
		
		for (var k = 0; k < pDelCount-1; k++)
		{
			var tempName = pDelAttachRow[k];
			tempName = ReplaceText(tempName, "&apos;", "'");
			
			if (tempName == realFileNM)
			{
				objXML.childNodes.item(0).childNodes.item(1).removeChild(objSelectedNode);
				pAttachListXml = getXmlString(objXML);
			}
			
		}
	}

  }catch(ErrMsg){
  
    alert(ErrMsg.description);
  }
}

function AddAttachFileInfoXmlParsing(pfilename, pSaveFileName, pfilesize, pfilelocation, pAttachAddFileSize, pAttatchFilePath) {
    try {
        var pstrXML;
        var re = /&/g;
        var objXML = createXmlDom();
        var Rtnxml = createXmlDom();
        Rtnxml = loadXMLString(pAttachListXml);
        var objAttachNodes = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
        pstrXML = "<LISTVIEWDATA><HEADERS>";
        pstrXML = pstrXML + "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pstrXML = pstrXML + "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        pstrXML = pstrXML + "</HEADERS><ROWS><ROW><CELL>";
        pstrXML = pstrXML + "<VALUE>" + pfilename.replace(re, "&amp;") + "</VALUE>";
        pstrXML = pstrXML + "<DATA1>" + pfilelocation.replace(re, "&amp;") + "</DATA1>";
        pstrXML = pstrXML + "<DATA2>" + pSaveFileName.replace(re, "&amp;") + "</DATA2>";
        pstrXML = pstrXML + "<DATA3></DATA3>";
        pstrXML = pstrXML + "<DATA4></DATA4>";
        pstrXML = pstrXML + "<DATA5>Y</DATA5>";
        pstrXML = pstrXML + "<DATA6>" + pAttachAddFileSize + "</DATA6>";
        pstrXML = pstrXML + "</CELL><CELL>";
        pstrXML = pstrXML + "<VALUE>" + pfilesize + "</VALUE>";
        pstrXML = pstrXML + "</CELL></ROW></ROWS></LISTVIEWDATA>";

        objXML = loadXMLString(pstrXML);
        if (objAttachNodes.length == 0) {
            pAttachListXml = getXmlString(objXML);
        }
        else {
            var objNewAttachNodes = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
            var objSelectedNode = objNewAttachNodes.item(0);

            Rtnxml.childNodes.item(0).childNodes.item(1).appendChild(objSelectedNode);

            pAttachListXml = getXmlString(Rtnxml);
        }

        document.all.EzHTTPTrans.InsertFileList(pfilename, pAttatchFilePath, "N", "N", pAttachAddFileSize);
        document.all.EzHTTPTrans.InsertFileInfo(pSaveFileName);
        AppendFileAttachInfo_List(pAttachListXml);

        return;

    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}

function AttachRemoveAll()
{
  try{
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

function DeleteFileAtServer( pAttachDelFileName )
{
  try{
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pFileName", pAttachDelFileName);
    createNodeAndInsertText(xmlpara, objNode, "pCompanyID", pCompanyID);
    createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);
      
    xmlhttp.open("Post", "/myoffice/ezBoardSTD/DeleteServerFile.aspx", false);
    xmlhttp.send(xmlpara);
  
    return xmlhttp.responseText;

  }catch(ErrMsg){
  
    alert(ErrMsg.description);
  
  }
  
}


function DeleteSaveFileAtServer( pAttachDelFileName, pBoard, pItemID )
{
  try{
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pFileName", pAttachDelFileName);
    createNodeAndInsertText(xmlpara, objNode, "pBoard", pBoard);
    createNodeAndInsertText(xmlpara, objNode, "pItemID", pItemID);
    createNodeAndInsertText(xmlpara, objNode, "pCompanyID", pCompanyID);
      
    xmlhttp.open("Post", "/myoffice/ezBoardSTD/DeleteServerSaveFile.aspx", false);
    xmlhttp.send(xmlpara);
  
    return xmlhttp.responseText;

  }catch(ErrMsg){
  
    alert(ErrMsg.description);
  }
}


function OpenInformationUI(pInformationContent)
{
  var parameter = pInformationContent;
	var url = "/myoffice/ezCommunity/htm/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:235px;dialogHeight:175px;help:no;scroll:no";
	
	var RtnVal = window.showModalDialog(url,parameter,feature);

  return RtnVal;
}
