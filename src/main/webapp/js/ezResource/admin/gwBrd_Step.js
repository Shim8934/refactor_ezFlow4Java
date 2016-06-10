function SetOrder(inc)
{
	var SelectedNode = parent.window.frames("board_menu").document.all("TreeView").selectedIndex;
	
	if( SelectedNode == null && BRDLIST.length==0 )
	{
		alert("" + strLang50 + "");
		return;
	}
		
	var selectobj = BRDLIST;
	var index = selectobj.selectedIndex;	

	if (index >= 0)
	{
		var newidx = index + inc;
        
		if (newidx < 0 || newidx >= selectobj.length)	
		return;

		var curr_id, next_id;
		curr_id = selectobj.options[index].value;		
		next_id = selectobj.options[newidx].value;

		if( ChgStep_xmlhttp(inc, curr_id, next_id) )
		{
			tmp = selectobj.options[index].value;		
			selectobj.options[index].value = selectobj.options[newidx].value;		
			selectobj.options[newidx].value = tmp;

			tmp = selectobj.options[index].text;
			selectobj.options[index].text = selectobj.options[newidx].text;
			selectobj.options[newidx].text = tmp;

			selectobj.options[newidx].selected = true;
		}	
	}
}

function ChgStep_xmlhttp(p_Gubun, p_Curr_ID, p_Next_ID)
{
	try{	
		var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");

		var szUrl ="/ezBoard/Admin/Call_BrdStep.asp?gubun=" + p_Gubun;
		szUrl += "&user_id=" + g_UserID + "&upper_id=" + g_BrdID;
		szUrl += "&up_level=" + L_UpLevel + "&curr_id=" + p_Curr_ID;
		szUrl += "&next_id=" + p_Next_ID + "&CompanyID=" + pCompanyID;
alert(szUrl);
		xmlhttp.open("POST", szUrl, false);
		xmlhttp.send();

		var rv = xmlhttp.responseText;
		
		if( rv == "True")
			return(true);
		else
			return(false);
		    
	}catch(e) { 
	}
}


function cmdSave_onclick() 
{
	
	var SelectedNode = parent.window.frames("board_menu").document.all("TreeView").selectedIndex;
	
	var i,j;
	var cnt = SelectedNode.childNodes.length;
	
	if ( cnt == 0)
	{
		var vcnt =  SelectedNode.parentElement.childNodes.length;
		var ParentSelectedNode = SelectedNode.parentElement;
		
		for( j=vcnt; j>0; j--)
		{
			ParentSelectedNode.childNodes(j-1).remove();
		} 
		
		L_UpLevel = parseInt(L_UpLevel);
	}
	else
	{
		for( i=cnt; i>0; i--)
		{
			SelectedNode.childNodes(i-1).remove();
		} 
		
		 L_UpLevel = parseInt(L_UpLevel)+1;
	}
	
	parent.window.frames("board_menu").document.Script.get_Call_FirstDepthNode(cAdmin,pUserID, pDeptID, L_UpLevel, g_BrdID );

}


