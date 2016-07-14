function GetAprLineTempletList()
{
    var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
    var objNode;
    
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID );
    
	xmlhttp.open ("Post","/myoffice/ezApprovalG/ezAPRLINE/ezAPRTEMPLET/aspx/AprLineTempletList.aspx",false);
	xmlhttp.send(xmlpara);
	
    var NodeList = SelectNodes(xmlhttp.responseXML,"APRTEMP/DATA");
  
	AddAprLineTempletList(NodeList);
}

function AddAprLineTempletList(NodeList)
{
    document.getElementById("stl_AprLineTemplet").innerHTML = "";
    var p_NodeListLen = NodeList.length;
  
	if(p_NodeListLen != 0)
	{
		var i;
		for(i = (p_NodeListLen - 1) ; i >= 0 ; i--)
		{
		    var p_Option = document.createElement("OPTION");
		    var NodeList2 ;
			
			NodeList2 =  GetChildNodes(NodeList[i]); 
			p_Option.text   = getNodeText(NodeList2[0]);
			p_Option.value  = getNodeText(NodeList2[1]);
						
			if(i == 0)
				p_Option.selected = true;
        
            if(CrossYN())
                document.getElementById("stl_AprLineTemplet").appendChild(p_Option);
		    else
		        document.getElementById("stl_AprLineTemplet").add(p_Option);
			
		}
	}
}

function GetAprLineTempletInfo(p_AprLineTempletID)
{
    var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	
	var objNode;
    
    createNodeInsert(xmlpara, objNode, "APRTEMP");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID );
    createNodeAndInsertText(xmlpara, objNode, "pAprLineSN", document.getElementById("stl_AprLineTemplet").value ); 
	  
	xmlhttp.open ("Post","/myoffice/ezApprovalG/ezAPRLINE/ezAPRTEMPLET/aspx/AprLineTempletListInfo.aspx",false);
	xmlhttp.send(xmlpara);
	  
	Resultxml = xmlhttp.responseXML;
	if(document.getElementById("APRTEMP").innerHTML != "")
	    document.getElementById("APRTEMP").innerHTML = "";
	var pAPRTEMP = new ListView();      
    pAPRTEMP.SetID("pAPRTEMP");
    pAPRTEMP.SetMulSelectable(false);    
    pAPRTEMP.DataSource(Resultxml); 
	pAPRTEMP.DataBind("APRTEMP"); 
	
}

function AprLineTempletInfoShow(Resultxml)
{
	if(document.getElementById("APRTEMP").innerHTML != "")
	    document.getElementById("APRTEMP").innerHTML = "";
	var pAPRTEMP = new ListView();      
    pAPRTEMP.SetID("pAPRTEMP");
    pAPRTEMP.SetMulSelectable(false);    
    pAPRTEMP.DataSource(Resultxml); 
	pAPRTEMP.DataBind("APRTEMP"); 
}

function AprLineInfoShow(Resultxml)
{
	if(document.getElementById("APRLINE").innerHTML != "")
	    document.getElementById("APRLINE").innerHTML = "";
	var pAPRLINE = new ListView();      
    pAPRLINE.SetID("pAPRLINE");
    pAPRLINE.SetMulSelectable(false);    
    pAPRLINE.SetRowOnClick("OnSelChange_onclick");           
	pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");      
	pAPRLINE.SetSelectFlag(false);  
    pAPRLINE.DataSource(Resultxml); 
	pAPRLINE.DataBind("APRLINE"); 
}

function SetLateststl_AprLineTemplet()
{
	var p_Option = document.createElement("OPTION");
	      
	p_Option.text   = strLang263;
	p_Option.value  = strLang263;
	p_Option.selected = true;
	        
	if(CrossYN())
        document.getElementById("stl_AprLineTemplet").appendChild(p_Option);
    else
        document.getElementById("stl_AprLineTemplet").add(p_Option);
		               
}

function DelAprLineTempletList(p_SelAprLineTempletSN)
{
    var xmlpara   = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	var objNode;
    
    createNodeInsert(xmlpara, objNode, "APRTEMP");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID );
    createNodeAndInsertText(xmlpara, objNode, "pAprLineSN", p_SelAprLineTempletSN ); 
	  
	xmlhttp.open ("Post","/myoffice/ezApprovalG/ezAPRLINE/ezAPRTEMPLET/aspx/DelAprLineTempletList.aspx",false);
	xmlhttp.send(xmlpara);
	  
	var dataNodes = GetChildNodes(xmlhttp.responseXML); 
    var RtnVal = getNodeText(dataNodes[0]);
    
	if(RtnVal != "TRUE")
	{
		var parameter = strLang264;
		var url = "/myoffice/ezApprovalG/ezAPRALERT_Cross.aspx";
		var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	    feature =  feature + GetShowModalPosition(330, 205);
	    
		var RtnVal = window.showModalDialog(url,parameter,feature);
	}
	else
	{		    
		InitAprlineTemplet();
	}
	
}

function DelstlAprLineTemplet(p_SelAprLineTempletSN)
{
	var p_SelAprLineTempletLen  = document.getElementById("stl_AprLineTemplet").length;
	
	var i;
	for(i = 0 ; i < p_SelAprLineTempletLen ; i++ )
	{
	    if( p_SelAprLineTempletSN == document.getElementById("stl_AprLineTemplet").item(i).value)//stl_AprLineTemplet.item(i).value)
		{
			var p_SelAprLineTempletIndex  = document.getElementById("stl_AprLineTemplet").item(i).index;
			stl_AprLineTemplet.remove(p_SelAprLineTempletIndex);
			break;  
		}
	}
}

function FirstAprLineTempletDisplay()
{
	var p_AprLineTempletIndex;
	p_AprLineTempletIndex = GetFirstAprLineTempletIndex();
    var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
    var objNode;
    
    createNodeInsert(xmlpara, objNode, "APRTEMP");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID );
    createNodeAndInsertText(xmlpara, objNode, "p_AprLineTempletIndex", p_AprLineTempletIndex ); 
	  
	xmlhttp.open ("Post","/myoffice/ezApprovalG/ezAPRLINE/ezAPRTEMPLET/aspx/AprLineTempletListInfo.aspx",false);
	xmlhttp.send(xmlpara);
	
	if(document.getElementById("APRTEMP").innerHTML != "")
	    document.getElementById("APRTEMP").innerHTML = "";
	    
	var pAPRTEMP = new ListView();      
    pAPRTEMP.SetID("pAPRTEMP");
    pAPRTEMP.SetMulSelectable(false);    
    pAPRTEMP.DataSource(xmlhttp.responseXML); 
	pAPRTEMP.DataBind("APRTEMP");
}

function GetFirstAprLineTempletIndex()
{
    var p_AprLineTempletLen = document.getElementById("stl_AprLineTemplet").length;
    
	var p_AprLineTempletIndex = 0;
	var i;
  
	for( i = 0 ; i < p_AprLineTempletLen ; i++)
	{
		if(stl_AprLineTemplet.item(i).selected)
		{
			p_AprLineTempletIndex = stl_AprLineTemplet.item(i).value;
			break;
		}
		
		p_AprLineTempletIndex = 0;
	}
	
	return p_AprLineTempletIndex;
}

function AddToAprLineFromAprLineTemplet( p_CheckAprLineTempletSN)
{
    var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	
	var objNode;
    
    createNodeInsert(xmlpara, objNode, "APRTEMP");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID );
    createNodeAndInsertText(xmlpara, objNode, "p_AprLineTempletIndex", p_CheckAprLineTempletSN ); 

	xmlhttp.open ("Post","/myoffice/ezApprovalG/ezAPRLINE/ezAPRTEMPLET/aspx/AddToaprline.aspx",false);
	xmlhttp.send(xmlpara);
	  
	Resultxml = xmlhttp.responseXML;
	
	if(document.getElementById("APRLINE").innerHTML != "")
	    document.getElementById("APRLINE").innerHTML = "";
	   
	var pAPRLINE = new ListView();      
    pAPRLINE.SetID("pAPRLINE");
    pAPRLINE.SetMulSelectable(false);    
    pAPRLINE.SetRowOnClick("OnSelChange_onclick");           
	pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");          
	pAPRLINE.SetSelectFlag(false);
    pAPRLINE.DataSource(xmlhttp.responseXML); 
	pAPRLINE.DataBind("APRLINE");
}

function CreateNewAprLineTemplet(p_AprLineTempletName)
{
	var AprLineTemplet = createXmlDom();
	var xmlhttp = createXMLHttpRequest();	
	var p_AprLineTempletID;

	AprLineTemplet = AprLineTempletXmlParsing(p_AprLineTempletName);

	var AprLineXml =  APRLINETEMPLETXMLParsing();
	var AprLineInfo = createXmlDom();
	AprLineInfo = loadXMLString(AprLineXml); 
    if(CrossYN())
	{ 
	    var xmlRtn = AprLineTemplet.documentElement;
	    var Node = AprLineInfo.importNode(xmlRtn,true);
        AprLineInfo.documentElement.appendChild(Node);
	}
	else
	{
	     var xmlRtn = AprLineTemplet.documentElement;
         AprLineInfo.documentElement.appendChild(xmlRtn);
	}
	
	xmlhttp.open("Post","/myoffice/ezApprovalG/ezAPRLINE/ezAPRTEMPLET/aspx/CreateAprLineTemplet.aspx",false);
	xmlhttp.send(AprLineInfo);
    
    var dataNodes = GetChildNodes(xmlhttp.responseXML); 
    var RtnVal = getNodeText(dataNodes[0]);
    	
	if(RtnVal == "TRUE")
	{
	}else{
		var parameter = strLang199;
		var url = "/myoffice/ezApprovalG/ezAPRALERT_Cross.aspx";
		var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	    feature =  feature + GetShowModalPosition(330, 205);
		var RtnVal = window.showModalDialog(url,parameter,feature);
	}
	GetAprLineTempletList();
	p_AprLineTempletID = Addstl_AprLineTemplet(p_AprLineTempletName);
	stl_AprLineTemplet.value = p_AprLineTempletID;
	GetAprLineTempletInfo(p_AprLineTempletID);
}

function Addstl_AprLineTemplet(p_AprLineTempletName)
{
	var stl_AprLineTempletLen = document.getElementById("stl_AprLineTemplet").length; 
	var stl_AprLineTempletIndex;
	var i;
  
	for(i = 0 ; i < stl_AprLineTempletLen ; i++)
	{
		if(p_AprLineTempletName == stl_AprLineTemplet.item(i).text)
		{
			stl_AprLineTempletIndex = stl_AprLineTemplet.item(i).value;
			break;
		}
	}
	return stl_AprLineTempletIndex;    
}

function AprLineTempletXmlParsing(p_AprLineTempletName)
{
	var pAprLineSN;
	if(pAprLineTempletFlag)
	{
		pAprLineSN = p_CheckAprLineTempletSN;
	}else{
		pAprLineSN = "";
	}
	
	var xmlpara = createXmlDom();
	var objNode;
    
    createNodeInsert(xmlpara, objNode, "APRTEMP");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID );
    createNodeAndInsertText(xmlpara, objNode, "pAprLineSN", pAprLineSN ); 
    createNodeAndInsertText(xmlpara, objNode, "p_AprLineTempletName", p_AprLineTempletName ); 
    
	return xmlpara;
}

function InitAprlineTemplet()
{
	GetAprLineTempletList();
	FirstAprLineTempletDisplay();
}

function OpenInformationUI(pInformationContent)
{
	var parameter = pInformationContent;
	var url = "/myoffice/ezApprovalG/ezAPROPINION_Cross.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	feature =  feature + GetShowModalPosition(330, 205);
	
	var RtnVal = window.showModalDialog(url,parameter,feature);	
	return RtnVal;
}