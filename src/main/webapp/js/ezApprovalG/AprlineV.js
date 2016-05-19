//******************************************************
// 현재 결재상태에 대한 Convert함수
//******************************************************
function ConvertAprLineState(pAprLineSate, pConvertType)
{
    var xmlhttp = createXMLHttpRequest();
    var RtnValxml = createXmlDom();
    var xmlpara = createXmlDom();
  
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "CODE1", "A04");
    createNodeAndInsertText(xmlpara, objNode, "CODE2", pAprLineSate);
    if(pConvertType.toLowerCase() == "code")
		createNodeAndInsertText(xmlpara, objNode, "FLAG", "NAME");
	else
		createNodeAndInsertText(xmlpara, objNode, "FLAG", "CODE");

	xmlhttp.open ("Post","../aspx/getCodeData.aspx",false);
  	xmlhttp.send(xmlpara);	
  	  
  	var dataNodes = GetChildNodes(xmlhttp.responseXML); 
    var ret = getNodeText(dataNodes[0]);
    return ret; 	
}


//******************************************************
// 현재 결재상태에 대한 Convert함수
//******************************************************
function ConvertAprLineType(pAprLineType , pConvertType)
{
  
    var xmlhttp = createXMLHttpRequest();
    var RtnValxml = createXmlDom();
    var xmlpara = createXmlDom();
  
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "CODE1", "A03");
    createNodeAndInsertText(xmlpara, objNode, "CODE2", pAprLineType);
    if(pConvertType.toLowerCase() == "code")
		createNodeAndInsertText(xmlpara, objNode, "FLAG", "NAME");
	else
		createNodeAndInsertText(xmlpara, objNode, "FLAG", "CODE");
	
	xmlhttp.open ("Post","../aspx/getCodeData.aspx",false);
  	xmlhttp.send(xmlpara);	
   	
   	var dataNodes = GetChildNodes(xmlhttp.responseXML); 
    var ret = getNodeText(dataNodes[0]);
    return ret;
}
