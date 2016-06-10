var g_AdminMenu = {	"NEW" : "GwBoard_List_RegSubBoard.aspx", 
			"MOD" : "GwBoard_List_RegComBoard.aspx",
			"ACL" : "gwBoard_Post_RegBoardRightMain.aspx",
			"STEP": "GwBoard_Post_RegBoardOrder.aspx",
			"MOV" : "GwBoard_Post_BoardMove.aspx",
			"DEL" : "gwBoard_post_BoardDel.aspx",
			"ITEMMOV" : "gwboard_get_ItemMoveSearch.aspx" ,
			"ITEMUPDATE" : "gwboard_get_ItemMoveSearch.aspx",
			"GONGJI" : "gwBoard_Post_RegGongjiBoard.aspx" };


function NavigateBrdAdmin_Res(pFlag) {
    var objSelected = "";
    var pSelCompanyID = window.parent.frames["board_menu"].pCompanyID;;
    objSelected = window.parent.frames["board_menu"].TreeView.selectedIndex();

	if( objSelected ){
		
	    var p_BrdID = TreeView.getvalue(objSelected, "DATA1");
	    var p_BrdNm = TreeView.getvalue(objSelected, "DATA2");
	    var p_BrdLevel = TreeView.getvalue(objSelected, "DATA3");
	    var p_BrdStep = TreeView.getvalue(objSelected, "DATA4");
	    var p_BrdCount = TreeView.getvalue(objSelected, "DATA11");
	    var p_BrdRef = TreeView.getvalue(objSelected, "DATA14");
	    var p_BrdGb = TreeView.getvalue(objSelected, "DATA7");
	    var p_BrdUpper = TreeView.getvalue(objSelected, "DATA6");
	    var p_BrdGroup = TreeView.getvalue(objSelected, "DATA15");
	    var p_BrdExp = TreeView.getvalue(objSelected, "DATA9");

		var rep = new RegExp( "&", "gi" );
		p_BrdNm = p_BrdNm.replace(rep, "chr(38)");
		
		var szUrl = "/Myoffice/ezResource/Admin/" + g_AdminMenu[pFlag];
		szUrl += "?brd_id=" + p_BrdID + "&brd_nm=" + escape(p_BrdNm);
		szUrl += "&brd_level=" + encodeURI(p_BrdLevel) + "&brd_ref=" + p_BrdRef;
		szUrl += "&brd_step=" + p_BrdStep + "&brd_count=" + p_BrdCount;
		szUrl += "&brd_gb=" + p_BrdGb + "&brd_upper=" + p_BrdUpper;
		szUrl += "&brd_group=" + p_BrdGroup + "&Menu=" + pFlag + "&SelCompanyID=" + pSelCompanyID;
	    //frames("board_main") == frames[1]
		window.parent.frames[1].location = szUrl;
	}else{
		alert("" + strLang1 + "");
	}
}


function NavigateBrdAdminleft(pFlag)
{
    var objSelected = "";
    var pSelCompanyID = window.parent.frames["board_menu"].pCompanyID;;
    objSelected = window.parent.frames["board_menu"].TreeView.selectedIndex();

	if( objSelected )
	{
		var p_BrdID = TreeView.getvalue(objSelected, "DATA1");
		var p_BrdNm = TreeView.getvalue(objSelected, "DATA2");
		var p_BrdLevel = TreeView.getvalue(objSelected, "DATA3");
		var p_BrdStep = TreeView.getvalue(objSelected, "DATA4");
		var p_BrdCount = TreeView.getvalue(objSelected, "DATA11");
		var p_BrdRef = TreeView.getvalue(objSelected, "DATA14");
		var p_BrdGb	= TreeView.getvalue(objSelected, "DATA7");
		var p_BrdUpper = TreeView.getvalue(objSelected, "DATA6");
		var p_BrdGroup = TreeView.getvalue(objSelected, "DATA15");
		var p_BrdExp = TreeView.getvalue(objSelected, "DATA9");

		var rep = new RegExp( "&", "gi" );
		p_BrdNm = p_BrdNm.replace( rep, "chr(38)" );
		
		var szUrl = "/Myoffice/ezResource/Admin/" + g_AdminMenu[pFlag];
		szUrl += "?brd_id=" + p_BrdID + "&brd_nm=" + escape(p_BrdNm);
		szUrl += "&brd_level=" + encodeURI(p_BrdLevel) + "&brd_ref=" + p_BrdRef;
		szUrl += "&brd_step=" + p_BrdStep + "&brd_count=" + p_BrdCount;
		szUrl += "&brd_gb=" + p_BrdGb + "&brd_upper=" + p_BrdUpper;
		szUrl += "&brd_group=" + p_BrdGroup + "&Menu=" + pFlag + "&SelCompanyID=" + pSelCompanyID;
		
	    //frames("board_main") == frames[1]
		window.parent.frames[1].location = szUrl;
	}
	else
	{
		alert("" + strLang1 + "");
	}
}


