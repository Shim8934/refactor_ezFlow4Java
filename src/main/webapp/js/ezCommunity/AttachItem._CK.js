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
     
	var Rtnxml = new ActiveXObject("Microsoft.XMLDOM");
	Rtnxml.loadXML(pAttachListXml);
	var objAttachNodes = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
	
	var pTotalRowsLen = objAttachNodes.length;
	
    var re = /&/g
	
    strXML = "<LISTVIEWDATA><HEADERS>";
    strXML = strXML + "<HEADER><NAME>" + strLang22 + "</NAME><WIDTH>100</WIDTH></HEADER>";
    strXML = strXML + "<HEADER><NAME>" + strLang23 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    strXML = strXML + "</HEADERS><ROWS>";
	
    for( i = 0 ; i < pTotalRowsLen ; i++)
    {
      strXML = strXML + "<ROW><CELL><VALUE>" + objAttachNodes(i).childNodes.item(0).childNodes.item(0).text.replace(re,"&amp;") + "</VALUE>";     
      strXML = strXML + "<DATA1>" + objAttachNodes(i).childNodes.item(0).childNodes.item(1).text.replace(re,"&amp;") + "</DATA1>";
      strXML = strXML + "<DATA2>" + objAttachNodes(i).childNodes.item(0).childNodes.item(2).text.replace(re,"&amp;") + "</DATA2>";
      strXML = strXML + "<DATA3>" + objAttachNodes(i).childNodes.item(0).childNodes.item(3).text + "</DATA3>";
      strXML = strXML + "<DATA4>" + objAttachNodes(i).childNodes.item(0).childNodes.item(4).text + "</DATA4>";
      strXML = strXML + "<DATA5>" + objAttachNodes(i).childNodes.item(0).childNodes.item(5).text + "</DATA5>";
      strXML = strXML + "<DATA6>"+  objAttachNodes(i).childNodes.item(0).childNodes.item(6).text   + "</DATA6></CELL>";
      strXML = strXML + "<CELL><VALUE>" + objAttachNodes(i).childNodes.item(1).childNodes.item(0).text  + "</VALUE></CELL></ROW>";
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
	
	var objXML = new ActiveXObject("Microsoft.XMLDOM");
	objXML.loadXML(pAttachListXml);
	var objAttachNodes = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	

	for (var i = 0 ; i < objAttachNodes.length ; i++)
	{
		var realFileNM = objAttachNodes(i).childNodes.item(0).childNodes.item(2).text;
		var DelFileSize = objAttachNodes(i).childNodes.item(0).childNodes.item(6).text;
		var objSelectedNode = objAttachNodes.item(i);
		var is_newfile = objAttachNodes(i).childNodes.item(0).childNodes.item(5).text;
		
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

// 201007 : Drag&Drop 실행, pAttatchFilePath
function AddAttachFileInfoXmlParsing(pfilename, pSaveFileName, pfilesize, pfilelocation, pAttachAddFileSize, pAttatchFilePath) {
    try {

        var pstrXML;
        var re = /&/g;
        var objXML = new ActiveXObject("Microsoft.XMLDOM");
        var Rtnxml = new ActiveXObject("Microsoft.XMLDOM");

        Rtnxml.loadXML(pAttachListXml);
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

        objXML.loadXML(pstrXML);
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
    
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
    
    objRoot = xmlpara.createNode(1,"PARAMETER","");	// Root Node " + strLang25 + "
	  xmlpara.appendChild(objRoot);

	  objNode = xmlpara.createNode(1, "pBoardID", "");	// " + strLang26 + "
	  objNode.text = pBoardID;
	  xmlpara.documentElement.appendChild(objNode);
  
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
    
    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
      
    objRoot = xmlpara.createNode(1,"PARAMETER","");	
    xmlpara.appendChild(objRoot);
  
	objNode = xmlpara.createNode(1, "pFileName", "");
	objNode.text = pAttachDelFileName;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "pCompanyID", "");
	objNode.text = pCompanyID;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "pBoardID", "");
	objNode.text = pBoardID;
	xmlpara.documentElement.appendChild(objNode);
	
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
    
    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
      
    objRoot = xmlpara.createNode(1,"PARAMETER","");	
    xmlpara.appendChild(objRoot);
  
	objNode = xmlpara.createNode(1, "pFileName", "");
	objNode.text = pAttachDelFileName;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "pBoard", "");	
	objNode.text = pBoard;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "pItemID", "");	
	objNode.text = pItemID;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "pCompanyID", "");	
	objNode.text = pCompanyID;
	xmlpara.documentElement.appendChild(objNode);
	
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
	
	//[070511_1508_/myoffice/ezCommunity/htm/ezAPROPINION.htm가 아닌지 의문
	//var url = "/ezflow/ezAPROPINION.htm";
	var url = "/myoffice/ezCommunity/htm/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:235px;dialogHeight:175px;help:no;scroll:no";
	
	var RtnVal = window.showModalDialog(url,parameter,feature);

  return RtnVal;
}

