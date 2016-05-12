// p_Flag: USER
function initTreeInfo(p_Flag, p_UserID, p_DeptID) {
	g_DeptBoardYN = false;
   	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom(); 
	
	var objNode;		
	createNodeInsert(xmlpara, objNode, "BRDLIST"); 
	createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", "1");
	createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
	createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", g_AccessCode);
	createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "Y");
	createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "0");
	createNodeAndInsertText(xmlpara, objNode, "USER_ID", p_UserID);
	createNodeAndInsertText(xmlpara, objNode, "DEPT_PATH", g_DeptPath);
	
	xmlhttp.open("POST","/ezResource/callNodeTreeData.do?flag=" + selectNo, false);
	xmlhttp.send(xmlpara);
	
	var XMLstring = xmlhttp.responseXML;
	
	// 표준모듈 (2007.05.30) : HTC TreeView로 변경	
	//xmlRtn = loadXMLString(XMLstring);	
	TreeView.source(XMLstring);
	TreeView.update();
}

// 선택된 게시판을 Main화면에 게시물LIST 보여주는 함수
function GetTreeBrdsInfo() 
{
	var selnode = TreeView.selectedIndex();
	nodeIdx = selnode;

	var brd_id = TreeView.getvalue(nodeIdx, "DATA1");
	
	if( brd_id == "1" )	 return;

	var brdGubun = TreeView.getvalue(nodeIdx, "DATA7");
	
	if (brdGubun == 1)	// 1: 자원구분 2: 자원
	{
		var brd_url = TreeView.getvalue(nodeIdx, "DATA8");					// 게시판 URL
	
		if( brd_url != "" && brd_url != document.location.protocol+"//"){
			strUrl = brd_url;
			if( strUrl.indexOf(document.location.protocol+"//") == -1 ){
				strUrl = document.location.protocol+"//" + strUrl;
			}

			if (strUrl.indexOf("target=") != -1 ){
				var strTarget = "";
				strTarget = strUrl.substr(strUrl.indexOf("target=")+7);
				window.open(strUrl, strTarget);
			}else{
				window.open(strUrl);
			}
			
		}else{
			var rep = new RegExp( "&", "gi" );				// 정규식을 쓴이유는 ??????
			var brd_nm = TreeView.getvalue(nodeIdx, "DATA2");
			var brd_nm = brd_nm.replace(rep, "chr(38)");	
			
			var strUrl = "/ezResource/viewResList2.do?brdID=" + brd_id + "&accessCode=" + g_AccessCode; 
			strUrl = strUrl + "&brdNm=" + encodeURI(brd_nm);
			
			Navigate( strUrl );
			
		}
	} else {

	        strUrl = "ResSch/scheduleMain.do?resID=" + brd_id + "&accessCode=" + g_AccessCode;
	    
		Navigate( strUrl );
	}	
}

function Navigate(url){	
	//TDCV----------------------------------
	//window.parent.item(1).location = url

    //window.parent.right.location = url // 임시로 주석
    //window.parent.right.location.href = url;
    window.open(url, 'right');
}

function displayBrdTree(p_UserID, p_DeptID, event) {
    if (!event) event = window.event;
	var nodeIdx = event.nodeIdx;
	var p_BrdID = TreeView.getvalue(nodeIdx, "DATA1");
	
	AddSubBrdTree(p_UserID, p_DeptID, p_BrdID, nodeIdx);
}

function AddSubBrdTree(p_UserID, p_DeptID, p_BrdID, nodeIdx)
{
    try{   
		var xmlhttp = createXMLHttpRequest();
		var xmlpara = createXmlDom();
		var xmlRtn = createXmlDom(); 
		
		var objNode;		
	    createNodeInsert(xmlpara, objNode, "BRDLIST"); 
	    createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", p_BrdID);
	    createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
	    createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", g_AccessCode);
	    createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "N");
	    createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "0");
	    createNodeAndInsertText(xmlpara, objNode, "USER_ID", p_UserID);
	    createNodeAndInsertText(xmlpara, objNode, "DEPT_PATH", g_DeptPath);
	
		xmlhttp.open("POST","/ezResource/callNodeTreeData.do",false);
		xmlhttp.send(xmlpara);
		
		xmlRtn = xmlhttp.responseXML;
	
		//if(xmlRtn.selectNodes("NODES/NODE").length

	    //if(SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0)
	    //{
	    //    if(CrossYN())
	    //    {
		//        xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
		//    }
		//    else
		//    {
		//        xmlRtn.selectNodes("NODES/NODE")[0].removeChild(xmlRtn.selectNodes("NODES/NODE/SELECT")[0]);
		//    }
	    //}
        //미리 생성된 TreeView의 ID로 TreeView 개체 생성
        TreeView.putchildxml(nodeIdx, xmlRtn);
	}
	catch(Err_Msg) {		
	}	
}