function getUseContainer(pOtherDeptID, pOWN)
{
	alert(300);
	var xmlpara = createXmlDom();
	var xmlRtn  = createXmlDom();
	
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER"); 	
	createNodeAndInsertText(xmlpara, objNode, "myDeptID", pDeptID);
	createNodeAndInsertText(xmlpara, objNode, "otherDeptID", pOtherDeptID);
	createNodeAndInsertText(xmlpara, objNode, "OWN", pOWN);
	
	xmlhttp.open("POST", "/myoffice/ezApproval/formContainer/aspx/getUseContainer.aspx", false);
	xmlhttp.send(xmlpara);
	
	xmlRtn = loadXMLString(xmlhttp.responseText);

    document.getElementById('divlvtCont').innerHTML = "";
    var listview = new ListView();                         
    listview.SetID("lvtCont");                       
    listview.SetMulSelectable(false);                     
    listview.SetRowOnDblClick("lvtCont_rowdblclick");     
    listview.DataSource(xmlRtn);                          
    listview.DataBind("divlvtCont");                     
    
    listview.SetSelectFlag(true);   
	
}

function Init()
{
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom();
	
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER"); 	
	createNodeAndInsertText(xmlpara, objNode, "DeptID", pDeptID);
			
	xmlhttp.open("POST", "/ezApprovalG/getcontuseGroup.do", false);
	xmlhttp.send(xmlpara);

    document.getElementById('divlvtDept').innerHTML = "";
    xmlRtn = loadXMLString(xmlhttp.responseText);
    var listview = new ListView();                        
    listview.SetID("lvtDept");                           
    listview.SetMulSelectable(false);                      
    listview.SetRowOnClick("lvtDept_SelChange");         
    listview.DataSource(xmlRtn);                         
    listview.DataBind("divlvtDept");                   
	var oArrRows = listview.GetSelectedRows();
    var selRow = oArrRows[0]; 
	if (selRow)
	{
		listview.SetSelectFlag(true);
		var DeptID = GetAttribute(selRow, "DATA1");
		var isOwnflag = GetAttribute(selRow, "DATA2");
				
		getUseContainer(DeptID, isOwnflag);
	}
}

function listAdd(pDeptName, pContName, pDeptID, pContID, lastRowIdx)
{
	var pparsingXML 
	
	if(lastRowIdx < 1)
	{
		
	    pparsingXML = "<LISTVIEWDATA><HEADERS>";
	    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang40 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang390 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	    pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
	    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pDeptName) + "</VALUE>";
	    pparsingXML = pparsingXML + "<DATA1>" + pDeptID + "</DATA1>";
	    pparsingXML = pparsingXML + "<DATA2>" + pContID + "</DATA2>";
	    pparsingXML = pparsingXML + "</CELL><CELL>";
	    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pContName) + "</VALUE>";
	    pparsingXML = pparsingXML + "</CELL></ROW></ROWS></LISTVIEWDATA>";
	}
	else
	{
	    pparsingXML = "<ROW><CELL>";
	    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pDeptName) + "</VALUE>";
	    pparsingXML = pparsingXML + "<DATA1>" + pDeptID + "</DATA1>";
	    pparsingXML = pparsingXML + "<DATA2>" + pContID + "</DATA2>";
	    pparsingXML = pparsingXML + "</CELL><CELL>";
	    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pContName) + "</VALUE>";
	    pparsingXML = pparsingXML + "</CELL></ROW>";
	}
	
	return pparsingXML;
}

function MakeXMLString(pOrgString)
{
	return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
}

function ReplaceText(orgStr, findStr, replaceStr)
{
  try {
	if (findStr == ".")
	{
		var a=0;
		for (a=0; a<10; a++)
			orgStr = orgStr.replace(".", replaceStr);
		return orgStr;
	}
	else
	{
		var re = new RegExp(findStr, "gi");
		return (orgStr.replace(re, replaceStr)); 
	}
  } catch(e) {
	return orgStr
  }
}
