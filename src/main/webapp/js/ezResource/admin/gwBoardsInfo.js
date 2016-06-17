function initTreeInfo(pFlag, p_UserID, p_DeptID)
{
    try{	
    	var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
		var xmlRtn = new ActiveXObject("Microsoft.XMLDOM"); 

		var objRoot = xmlpara.createNode(1,"BRDLIST","");	
		xmlpara.appendChild(objRoot);
		
		objNode = xmlpara.createNode(1, "FLAG", "");	
		objNode.text = pFlag;
		xmlpara.documentElement.appendChild(objNode)
		
		var objNode = xmlpara.createNode(1, "USER_ID", "");
		objNode.text = p_UserID;
		objRoot.appendChild(objNode);
		
		var objNode = xmlpara.createNode(1, "DEPT_ID", "");
		objNode.text = p_DeptID;
		objRoot.appendChild(objNode);
		
		var objNode = xmlpara.createNode(1, "SEARCH_GROUP", "");
		objNode.text = "";
		objRoot.appendChild(objNode);
		
		objNode = xmlpara.createNode(1, "BRDID", "");	
		objNode.text = "1";
		xmlpara.documentElement.appendChild(objNode);
		
		objNode = xmlpara.createNode(1, "Depth", "");	
		objNode.text = "2";
		xmlpara.documentElement.appendChild(objNode);
		
		objNode = xmlpara.createNode(1, "SATEADMIN", "");	
		objNode.text = "ADMIN";
		xmlpara.documentElement.appendChild(objNode);
		
		objNode = xmlpara.createNode(1, "FirstNodeYN", "");	
		objNode.text = "Y";
		xmlpara.documentElement.appendChild(objNode);
		
		objNode = xmlpara.createNode(1, "BoardAdmin", "");	
		objNode.text = "BoardAdmin";
		xmlpara.documentElement.appendChild(objNode);
		
		objNode = xmlpara.createNode(1, "STRPARA", "");	
		objNode.text = pCompanyID;
		xmlpara.documentElement.appendChild(objNode);

		xmlhttp.open("POST","/admin/ezResource/callManagerDepthNode.do",false);
		xmlhttp.send(xmlpara);
		
		if(xmlhttp.responseXML.xml == "") return;
	
			TreeCtrl.dataSource = xmlhttp.responseXML;
		    
    }catch(e) { 
	}
}


function TreeCtrl_onReqData(TreeView)
{
	var requestNode = window.event.param;
	
	var brd_level = requestNode.DATA3;
	var m_param1 = requestNode.DATA1;
	
	if(requestNode)
	{
		if (requestNode.ISLEAF == 0)													
		{		
			getFirstDepthNode(TreeView,parseInt(brd_level) + 1,m_param1)
		}
	}
	
	if (  m_param1 == "4") 
	{
		
		HqProposalNM = requestNode.DATA2;
		
	}
	
	TreeCtrl_onNodeClick();
}



function getFirstDepthNode(TreeView, p_Depth, p_brd_id)
{
	var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	var xmlDOM  = new ActiveXObject("Microsoft.XMLDOM");
	var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
	
	
	objRoot = xmlpara.createNode(1,"BRDLIST","");
	xmlpara.appendChild(objRoot);
    
    objNode = xmlpara.createNode(1, "FLAG", "");	
	objNode.text = "ADMIN";
	xmlpara.documentElement.appendChild(objNode)
	
	objNode = xmlpara.createNode(1, "USERID", "");	
	objNode.text = pUserID;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "DRPTID", "");	
	objNode.text = pDeptID;
	xmlpara.documentElement.appendChild(objNode)
	
	objNode = xmlpara.createNode(1, "BRDGROUP", "");	
	objNode.text = "";
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "BRDID", "");	
	objNode.text = p_brd_id;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "Depth", "");	
	objNode.text = p_Depth;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "SATEADMIN", "");	
	objNode.text = "ADMIN";
	xmlpara.documentElement.appendChild(objNode);
		
	objNode = xmlpara.createNode(1, "FistNodeYN", "");	
	objNode.text = "N";
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "BoardAdmin", "");	
	objNode.text = "";
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "STRPARA", "");	
	objNode.text = pCompanyID;
	xmlpara.documentElement.appendChild(objNode);
	
	xmlhttp.open("POST","/admin/ezResource/callManagerDepthNode.do",false);
	xmlhttp.send(xmlpara);
	
	if(xmlhttp.responseXML.xml == "") return;
	
	var selnode = window.event.param;
	selnode.insertChild(xmlhttp.responseXML);
	
}

