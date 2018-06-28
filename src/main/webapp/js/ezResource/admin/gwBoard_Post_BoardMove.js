function cmdOk_onclick() {
	if( (typeof(p_TBrd_ID) != "undefined") &&  p_TBrd_ID !="" )
	{
		if(( p_TBrd_ID == p_SrcBrdID ) || ( p_TBrd_ID == p_SrcBrdUpper )  )
		{
			alert("" + strLang9 + "");
			return;
		}
		else
		{
			if( confirm("" + strLang10 + "") == true )
			{
				var rv = BrdMove_xmlhttp(p_SrcBrdID, p_TBrd_ID);
				
				if( rv )
				{
					alert("" + strLang11 + "");
					parent.window.location.reload()	
				}
				else
				{				
					alert("" + strLang12 + "");
				}
			}
		}
	}
	else
	{
		alert("" + strLang13 + "");
	}
}

function BrdMove_xmlhttp(pSrcID, pTargetID)
{
    try{	
    	var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");		
		var xmlRtn = new ActiveXObject("Microsoft.XMLDOM");
		var szUrl = "/myoffice/ezBoard/Admin/Call_BrdMove.asp?src_id=" + pSrcID + "&target_id=" + pTargetID + "&StrPara=" +pCompanyID;

		xmlhttp.open("POST", szUrl, false);
		xmlhttp.send();
		if( xmlhttp.responseText == "False" )
		{
			return(false);			
		}
		else
		{
			return(true);
		}
		    
    }catch(e) { 
	}
}


function window_onload() {
	
	var p_UserID = pUserID;
	var p_DeptID = pDeptID;
	
	var SelectedNode = parent.window.frames("board_menu").document.all("TreeView").selectedIndex;
	
	if( SelectedNode )
		
		pUpExp.innerText = parent.window.frames("board_menu").document.all("TreeView").getvalue(SelectedNode, "DATA9");
}


function cmdSelect_onclick(){
	
	var para = new Array();
	var retVal = new Array();
	var url = "Organ.aspx"
	para[1] = pCompanyID;
	
	retVal = window.showModalDialog(url,para,"dialogWidth:260px;dialogHeight:440px;status:no;help:no;scroll:no");

	if ( typeof(retVal) != "undefined" )
	{
		p_TBrd_Level	= retVal[0];		
		p_TBrd_Ref		= retVal[1];	
		p_TBrd_ID		= retVal[2];	
		p_TBrd_UpID		= retVal[3];	
		p_TBrd_NM		= retVal[4];	
		p_TBrd_Explain	= retVal[5];	
		txtTBrd_NM.innerText = p_TBrd_NM;	 
		txtTBrd_Explain.innerText = p_TBrd_Explain;
	}
}

