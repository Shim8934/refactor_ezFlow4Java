function getUseContainer()
{
    var xmlRtn = createXmlDom();		 
    
    $.ajax({
    	type : "POST",
    	dataType : "text",
    	url : "/admin/ezApprovalG/apprGMgetContInfo.do",
    	async : false,
    	data : {deptID : pDeptID, comID : companyID},
    	success : function(result){
    		xmlRtn = loadXMLString(result);	        		
    		 document.getElementById('divlvtCont').innerHTML = "";
    	}
    });
	

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
      var xmlRtn = createXmlDom();		 
      
      $.ajax({
      	type : "POST",
      	dataType : "text",
      	url : "/ezApprovalG/getContUseGroup.do",
      	async : false,
      	data : {deptID : pDeptID, comID : companyID},
      	success : function(result){
      		xmlRtn = loadXMLString(result);	        		
      		 document.getElementById('divlvtDept').innerHTML = "";
      	}
      });

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
