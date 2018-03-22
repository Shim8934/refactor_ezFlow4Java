function GetAprLineTempletList()
{
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/aprLineTempletList.do",
		data : {
				formID  : pFormID,
				userID 	: pUserID
				},
		success: function(xml){
			result = xml;
		}        			
	});	
	
    var NodeList = SelectNodes(loadXMLString(result), "APRTEMP/DATA");
  
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
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/aprLineTempletListInfo.do",
		data : {
				userID 	 : pUserID,
				formID   : pFormID,
				aprLineSN: document.getElementById("stl_AprLineTemplet").value
				},
		success: function(text){
			Resultxml = loadXMLString(text);
			if(document.getElementById("APRTEMP").innerHTML != "")
			    document.getElementById("APRTEMP").innerHTML = "";
			var pAPRTEMP = new ListView();      
		    pAPRTEMP.SetID("pAPRTEMP");
		    pAPRTEMP.SetMulSelectable(false);    
		    pAPRTEMP.DataSource(Resultxml); 
			pAPRTEMP.DataBind("APRTEMP");
		}        			
	});
	  
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
	var result = "";
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/delAprLineTempletList.do",
		data : {
				userID 	 : pUserID,
				formID   : pFormID,
				aprLineSN: p_SelAprLineTempletSN
				},
		success: function(result){
			InitAprlineTemplet();
		}, error : function() {
			var parameter = strLang264;
			var url = "/ezApprovalG/ezAprAlert.do";
			var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		    feature =  feature + GetShowModalPosition(330, 205);
		    
			var RtnVal = window.showModalDialog(url,parameter,feature);
		}
	});
	
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
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/aprLineTempletListInfo.do",
		data : {
				userID 	 : pUserID,
				formID   : pFormID,
				aprLineSN: p_AprLineTempletIndex
				},
		success: function(text){
			if(document.getElementById("APRTEMP").innerHTML != "")
			    document.getElementById("APRTEMP").innerHTML = "";
			    
			var pAPRTEMP = new ListView();      
		    pAPRTEMP.SetID("pAPRTEMP");
		    pAPRTEMP.SetMulSelectable(false);    
		    pAPRTEMP.DataSource(loadXMLString(text)); 
			pAPRTEMP.DataBind("APRTEMP");
		}        			
	});
	
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
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/addToAprLine.do",
		data : {
				userID 	 : pUserID,
				formID   : pFormID,
				aprSN	 : p_CheckAprLineTempletSN
				},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});
	
	Resultxml = result;
	
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
/**
 * 결재선 즐겨찾기 저장 
 */
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
	
	xmlhttp.open("Post","/ezApprovalG/createAprLineTemplet.do",false);
	xmlhttp.send(AprLineInfo);
	
    var RtnVal = xmlhttp.responseText;
    	
	if(RtnVal == "TRUE") {
	} else {
		var parameter = strLang199;
		var url = "/ezApprovalG/ezAprAlert.do";
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

function OpenInformationUI(pInformationContent) {
	var parameter = pInformationContent;
	var url = "/ezApprovalG/ezAprOpinion.do";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	feature =  feature + GetShowModalPosition(330, 205);
	
	var RtnVal = window.showModalDialog(url,parameter,feature);	
	return RtnVal;
}