function setLogData(tempDocID, tempActionCode, tempParam1, tempParam2)
{
  try{
  	var xmlpara = new createXmlDom();
	var xmlhttp = new createXMLHttpRequest;
		  
	var objNode;
    createNodeInsert(xmlpara, objNode, "ROW");
    createNodeAndInsertText(xmlpara, objNode, "tempDocID", tempDocID);
    createNodeAndInsertText(xmlpara, objNode, "tempActionCode", tempActionCode);
    createNodeAndInsertText(xmlpara, objNode, "tempParam1", tempParam1);
    createNodeAndInsertText(xmlpara, objNode, "tempParam2", tempParam2);		  
	  
	xmlhttp.open("POST","/myoffice/ezApproval/ezDocInfo/setLogData.aspx",false);
	xmlhttp.send(xmlpara);
  }catch(e){
	alert("setLogData : " + e.description);
  }
}

