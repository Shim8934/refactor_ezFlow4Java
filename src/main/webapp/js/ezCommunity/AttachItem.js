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
	
    var re = /&/g
	
    strXML = "<LISTVIEWDATA><HEADERS>";
    strXML = strXML + "<HEADER><NAME>" + strLang22 + "</NAME><WIDTH>100</WIDTH></HEADER>";
    strXML = strXML + "<HEADER><NAME>" + strLang23 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    strXML = strXML + "</HEADERS><ROWS>";
	
    for( i = 0 ; i < pTotalRowsLen ; i++)
    {
        strXML = strXML + "<ROW><CELL><VALUE>" + getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(0)).replace(re,"&amp;") + "</VALUE>";     
        strXML = strXML + "<DATA1>" + getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(1)).replace(re,"&amp;") + "</DATA1>";
        strXML = strXML + "<DATA2>" + getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(2)).replace(re,"&amp;") + "</DATA2>";
        strXML = strXML + "<DATA3>" + getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(3)) + "</DATA3>";
        strXML = strXML + "<DATA4>" + getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(4)) + "</DATA4>";
        strXML = strXML + "<DATA5>" + getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(5)) + "</DATA5>";
        strXML = strXML + "<DATA6>"+  getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(6))   + "</DATA6></CELL>";
        strXML = strXML + "<CELL><VALUE>" + getNodeText(objAttachNodes(i).childNodes.item(1).childNodes.item(0))  + "</VALUE></CELL></ROW>";
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
	    var realFileNM = getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(2));
	    var DelFileSize = getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(6));
		var objSelectedNode = objAttachNodes.item(i);
		var is_newfile = getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(5));
		
		for (var k = 0; k < pDelCount-1; k++)
		{
			var tempName = pDelAttachRow[k]
			tempName = ReplaceText(tempName, "&apos;", "'");

			if (tempName == realFileNM)
			{
				objXML.childNodes.item(0).childNodes.item(1).removeChild(objSelectedNode);
				pAttachListXml = objXML.xml
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
        pstrXML = pstrXML + "<HEADER><NAME>" + strLang22 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pstrXML = pstrXML + "<HEADER><NAME>" + strLang24 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        pstrXML = pstrXML + "</HEADERS><ROWS><ROW><CELL>";
        pstrXML = pstrXML + "<VALUE>" + pfilename.replace(re, "&amp;") + "</VALUE>";
        pstrXML = pstrXML + "<DATA1>" + pfilename.replace(re, "&amp;") + "</DATA1>";
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
            pAttachListXml = objXML.xml;
        }
        else {
            var objNewAttachNodes = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
            var objSelectedNode = objNewAttachNodes.item(0);
            Rtnxml.childNodes.item(0).childNodes.item(1).appendChild(objSelectedNode);
            pAttachListXml = Rtnxml.xml
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
  
    var objRoot;
    var objNode;
    
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    
    var objRoot, objNode
    objRoot = createNodeInsert(xmlpara, xmlpara, "PARAMETER");
    objNode = createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);

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
    var objRoot;
    var objNode;
    
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
      
    var objRoot, objNode
    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    objNode = createNodeAndInsertText(xmlpara, objNode, "pFileName", pAttachDelFileName);
    objNode = createNodeAndInsertText(xmlpara, objNode, "pCompanyID", pCompanyID);
    objNode = createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);
	
    xmlhttp.open ("Post","DeleteServerFile.aspx",false);
    xmlhttp.send(xmlpara);
  
    return xmlhttp.responseText;
  }catch(ErrMsg){
    alert(ErrMsg.description);
  }
}


function DeleteSaveFileAtServer( pAttachDelFileName, pBoard, pItemID )
{
  try{
  
    var objRoot;
    var objNode;
    
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objRoot, objNode
    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    objNode = createNodeAndInsertText(xmlpara, objNode, "pFileName", pAttachDelFileName);
    objNode = createNodeAndInsertText(xmlpara, objNode, "pBoard", pBoard);
    objNode = createNodeAndInsertText(xmlpara, objNode, "pItemID", pItemID);
    objNode = createNodeAndInsertText(xmlpara, objNode, "pCompanyID", pCompanyID);
	
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
	
	var url = "/myoffice/ezCommunity/htm/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:235px;dialogHeight:175px;help:no;scroll:no";
	
	var RtnVal = window.showModalDialog(url,parameter,feature);

  return RtnVal;
}

