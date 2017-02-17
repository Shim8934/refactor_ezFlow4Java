var g_AdminMenu = {	"NEW" : "gwBoardListRegSubBoard.do", 
			"MOD" : "gwBoardListRegComBoard.do",
			"ACL" : "gwBoardPostRegBoardRightMain.do",
			"STEP": "gwBoardPostRegBoardOrder.do",
			"MOV" : "gwBoardPostBoardMove.do",
			"DEL" : "gwBoardPostBoardDel.do",
			"ITEMMOV" : "gwboardGetItemMoveSearch.do" ,
			"ITEMUPDATE" : "gwboardGetItemMoveSearch.do",
			"GONGJI" : "gwBoardPostRegGongjiBoard.do" };


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
		
		var szUrl = "/admin/ezResource/" + g_AdminMenu[pFlag];
		szUrl += "?brdID=" + p_BrdID + "&brdNm=" + encodeURIComponent(p_BrdNm);
		szUrl += "&brdLevel=" + escape(p_BrdLevel) + "&brdRef=" + p_BrdRef;
		szUrl += "&brdStep=" + p_BrdStep + "&brdCount=" + p_BrdCount;
		szUrl += "&brdGb=" + p_BrdGb + "&brdUpper=" + p_BrdUpper;
		szUrl += "&brdGroup=" + p_BrdGroup + "&menu=" + pFlag + "&selCompanyID=" + pSelCompanyID;
	    //frames("board_main") == frames[1]
		window.parent.frames[1].location = szUrl;
	}else{
		alert("" + strLang1 + "");
	}
}

function NavigateBrdAdminleft(pFlag) {
    var objSelected = "";
    var pSelCompanyID = window.parent.frames["board_menu"].pCompanyID;;
    objSelected = window.parent.frames["board_menu"].TreeView.selectedIndex();

	if( objSelected ) {
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
		
		var szUrl = "/admin/ezResource/" + g_AdminMenu[pFlag];
		szUrl += "?brdID=" + p_BrdID + "&brdNm=" + encodeURIComponent(p_BrdNm);
		szUrl += "&brdLevel=" + escape(p_BrdLevel) + "&brdRef=" + p_BrdRef;
		szUrl += "&brdStep=" + p_BrdStep + "&brdCount=" + p_BrdCount;
		szUrl += "&brdGb=" + p_BrdGb + "&brdUpper=" + p_BrdUpper;
		szUrl += "&brdGroup=" + p_BrdGroup + "&menu=" + pFlag + "&selCompanyID=" + pSelCompanyID;
		
	    //frames("board_main") == frames[1]
		window.parent.frames[1].location = szUrl;
	} else {
		alert("" + strLang1 + "");
	}
}


