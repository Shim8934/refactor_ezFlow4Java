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
    strXML = strXML + "<HEADER><NAME>" + strLang48 + "</NAME><WIDTH>100</WIDTH></HEADER>";
    strXML = strXML + "<HEADER><NAME>" + strLang50 + "</NAME><WIDTH>50</WIDTH></HEADER>";
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
        pstrXML += "<HEADER><NAME>" + strLang48 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pstrXML += "<HEADER><NAME>" + strLang50 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        pstrXML += "</HEADERS><ROWS>";
        for (i = 0; i < nodes.length; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[1]) != "denied") {
                pstrXML += "<ROW><CELL><VALUE>" + getNodeText(GetChildNodes(nodes[i])[2]).replace(re, "&amp;").replace("%3b",";").replace("%2b","+") + "</VALUE>";
                pstrXML += "<DATA1>" + getNodeText(GetChildNodes(nodes[i])[2]).replace(re, "&amp;").replace("%3b", ";").replace("%2b", "+") + "</DATA1>";
                pstrXML += "<DATA2>" + getNodeText(GetChildNodes(nodes[i])[0]).replace(re, "&amp;") + "</DATA2>";
                pstrXML += "<DATA3></DATA3>";
                pstrXML += "<DATA4></DATA4>";
                pstrXML += "<DATA5>Y</DATA5>";
                pstrXML += "<DATA6>" + getNodeText(GetChildNodes(nodes[i])[3]) + "</DATA6>";
                pstrXML += "</CELL><CELL>";
                pstrXML += "<VALUE>" + getNodeText(GetChildNodes(nodes[i])[3]) + " Bytes" + "</VALUE>";
                pstrXML += "</CELL></ROW>";
            }
        }
        pstrXML += "</ROWS></LISTVIEWDATA>";
        objXML = loadXMLString(pstrXML);

            if (pAttachListXml == "") {
                pAttachListXml = objXML;
            }
            else {
                if (typeof (pAttachListXml) == "string")
                    Rtnxml = loadXMLString(pAttachListXml);
                else
                    Rtnxml = loadXMLString(getXmlString(pAttachListXml));
             
                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
                    if (CrossYN()) {
                        var Node = Rtnxml.importNode(objNewAttachNodes, true);
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(Node);
                    }
                    else {
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                    }
                }
                pAttachListXml = Rtnxml;	
            }

        AppendFileAttachInfo(pAttachListXml);
        return;

    } catch (ErrMsg) {

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