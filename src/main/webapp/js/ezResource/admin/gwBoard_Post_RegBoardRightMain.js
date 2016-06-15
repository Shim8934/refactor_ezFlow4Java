var L_AclText = "";
var L_AclValue = "";
var L_ACLERRORMESSAGE = "" + strLang30 + "";

function cmdOk_onclick() 
{    
	var objSelected = acllist;
	var cnt = objSelected.options.length;
	
	
	if (cnt <= 0 )
	{
		alert("" + strLang31 + "");
	}
	else
	{
		var xmldom = "";
		var xmlhttp = "";

		if (CrossYN()) {
		    xmldom = createXmlDom();
		    xmlhttp = createXMLHttpRequest();

		    var objNode, objRow;
		    createNodeInsert(xmldom, objNode, "DATA");

		    for (i = 0; i < cnt; i++) {
		        var objOptions = objSelected.options[i];

		        objRow = createNodeAndInsertText(xmldom, objRow, "ROW_DATA", "");
		        SetAttribute(objRow, "ResID", g_BrdID);
		        SetAttribute(objRow, "Dept_YN", objOptions.getAttribute("Dept_YN"));
		        SetAttribute(objRow, "SDA_YN", objOptions.getAttribute("SDA_YN"));
		        SetAttribute(objRow, "Member_nam", objOptions.getAttribute("Member_nam"));
		        SetAttribute(objRow, "Member_ID", objOptions.getAttribute("Member_ID"));
		        SetAttribute(objRow, "Access_lvl", objOptions.getAttribute("Access_lvl"));
		        SetAttribute(objRow, "CompanyID", pCompanyID);
		    }

		} else {
		    xmldom = new ActiveXObject("Microsoft.XMLDOM");
		    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");

		    var objRoot = xmldom.createNode(1, "DATA", "");
		    xmldom.appendChild(objRoot);

		    for (i = 0; i < cnt; i++) {
		        var objOptions = objSelected.options[i];

		        var objRowData = xmldom.createNode(1, "ROW_DATA", "");

		        objRowData.setAttribute("ResID", g_BrdID);
		        if (objOptions.Dept_YN != null) {
		            objRowData.setAttribute("Dept_YN", objOptions.Dept_YN);
		            objRowData.setAttribute("SDA_YN", objOptions.SDA_YN);
		            objRowData.setAttribute("Member_nam", objOptions.Member_nam);
		            objRowData.setAttribute("Member_ID", objOptions.Member_ID);
		            objRowData.setAttribute("Access_lvl", objOptions.Access_lvl);
		        }
		        else {
		            objRowData.setAttribute("Dept_YN", objOptions.getAttribute("Dept_YN"));
		            objRowData.setAttribute("SDA_YN", objOptions.getAttribute("SDA_YN"));
		            objRowData.setAttribute("Member_nam", objOptions.getAttribute("Member_nam"));
		            objRowData.setAttribute("Member_ID", objOptions.getAttribute("Member_ID"));
		            objRowData.setAttribute("Access_lvl", objOptions.getAttribute("Access_lvl"));
		        }

		        
		        objRowData.setAttribute("CompanyID", pCompanyID);

		        objRoot.appendChild(objRowData);
		    }

		}
	
		xmlhttp.open("POST", "/admin/ezResource/callBrdMng.do", false);
		xmlhttp.send(xmldom);
	
		if (xmlhttp.status != 200){
			alert("1." + strLang32 + "");
			return;
		}

		var rtnXML = xmlhttp.responseText;
		
		if (rtnXML != "True"){
			alert("2." + strLang32 + "");
		}else{
			alert("" + strLang33 + "");
		}
	}
}

var gwboard_post_regboardright_dialogArguments = new Array();
function cmdAdd_onclick() {
    if (CrossYN()) {
        gwboard_post_regboardright_dialogArguments[1] = cmdAdd_onclick_Complete;

        var OpenWin = window.open("/admin/ezResource/popup/gwBoardPostRegBoardRight.do", "gwBoardPostRegBoardRight", GetOpenWindowfeature(970, 655));
        try { OpenWin.focus(); } catch (e) { }
    } else {
        var Url = "/admin/ezResource/popup/gwBoardPostRegBoardRight.do";
        var config = "dialogHeight:655px; dialogWidth:970px; status:no; scroll:no; help:no; edge:sunken";
        var rv = window.showModalDialog(Url, '', config);

        if (typeof (rv) != "undefined") {
        	SetAddACLList(rv);
        }
    }
}
function cmdAdd_onclick_Complete(retVal) {
    if (typeof (retVal) != "undefined")
        SetAddACLList(retVal);
}


function SetAddACLList(objAddList) {
	var acl_cnt		= objAddList.length;
	
	for( var i = 0; i < acl_cnt; i++ )
	{		
		var pCurrAcl = objAddList[i+1].split("^");

		var objUserList = acllist;
		var User_Cnt = objUserList.options.length;
		var AddUser = new Option();
		var IsExist = false
		
		var tempName = "";
		for (var j = 0; j < User_Cnt; j++) {
		    tempName = CrossYN() ? objUserList.options[j].getAttribute("Member_ID") : objUserList.options[j].Member_ID;
			if( pCurrAcl[1] == tempName ){
				IsExist = true
			}
		}
		
		if (!IsExist) {
		    if (CrossYN()) {
		        AddUser.setAttribute("Dept_YN", "Y");
		        AddUser.setAttribute("SDA_YN", "Y");
		        AddUser.setAttribute("Member_nam", pCurrAcl[2]);
		        AddUser.setAttribute("Member_ID", pCurrAcl[1]);
		        AddUser.setAttribute("Access_lvl", "2");
		    } else {
		        AddUser.Dept_YN = "Y";
		        AddUser.SDA_YN = "Y";
		        AddUser.Member_nam = pCurrAcl[2];
		        AddUser.Member_ID = pCurrAcl[1];
		        AddUser.Access_lvl = "2";
		    }
			AddUser.text = pCurrAcl[2] + " - (" + strLang35 + "";

			objUserList.options[User_Cnt] = AddUser;

		}
	}
}


function cmdDel_onclick() 
{
    var objSelected = acllist;
	var pos = objSelected.selectedIndex;
	if (pos == "-1") return;
	
	var SelectedUser = objSelected.options[pos];
	var xmldom = "";
	var xmlhttp = "";
	if (CrossYN()) {
	    xmldom = createXmlDom();
	    xmlhttp = createXMLHttpRequest();
	} else {
	    xmldom = new ActiveXObject("Microsoft.XMLDOM");
	    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	
	objSelected.options[pos] = null;
}

function CheckRead() {
	if( brd_mng[0].checked == true )
	{
		CheckMng();
		return;
	}

	if( L_BrdGb == "2" )
		return false;

	if( brd_read[0].checked == true )
	{
		brd_lst[0].checked = true;
		brd_vbl[0].checked = true;
	}		
}

function CheckReply() {
	if( brd_mng[0].checked == true )
	{
		CheckMng();
		return;
	}

	if( L_BrdGb == "2" )
		return false;

	if( brd_reply[0].checked == true )
	{
		brd_read[0].checked = true;
		brd_lst[0].checked = true;
		brd_vbl[0].checked = true;
	}		
}


function CheckWrt() {
	if( brd_mng[0].checked == true )
	{
		CheckMng();
		return;
	}
	
	if( brd_wrt[0].checked == true )
	{
		brd_vbl[0].checked = true;
	}
	
}

function CheckLst() {
	if( brd_mng[0].checked == true  )
	{
		CheckMng();
		return;
	}

	if( L_BrdGb == "2" )
		return false;
		
	if( brd_lst[0].checked == true || brd_lst[2].checked == true )
	{
		brd_vbl[0].checked = true;
	}
	else
	{
		brd_read[1].checked = true;
		brd_wrt[1].checked = true;
	}
}


function CheckVbl() {
	if( brd_mng[0].checked == true )
	{
		CheckMng();
		return;
	}
	
	if( brd_vbl[1].checked == true )
	{
		brd_mng[1].checked = true;
		brd_read[1].checked = true;
		brd_wrt[1].checked = true;
		brd_lst[1].checked = true;
		brd_reply[1].checked = true;
	}
}


function CheckMng() {	
	var objSelected = acllist.options[acllist.selectedIndex];	
	
	if( objSelected.gubun == '2' || objSelected.gubun == '0')
	{
		alert("" + strLang36 + "");
		brd_mng[1].checked = true;
		return;
	}

	if( brd_mng[0].checked == true ) 
	{
		brd_read[0].disabled = false;	
		brd_lst[0].disabled = false;
		brd_reply[0].disabled = false;

		brd_vbl[0].checked = true;
		brd_wrt[0].checked = true;
		brd_read[0].checked = true;
		brd_lst[0].checked = true;	
		brd_reply[0].checked = true;		
	}
	
	if( L_BrdGb == "2" && brd_mng[1].checked == true )
	{
		brd_read[0].disabled = true;	
		brd_lst[0].disabled = true;
		brd_reply[0].disabled = true;
		
		brd_read[1].checked = true;
		brd_lst[1].checked = true;	
		brd_reply[1].checked = true;
	}
}

function CheckManager(){
	if( brd_manager[0].checked == true )
	{
		brd_mail.disabled = false;
		
		brd_read[0].checked = true;
		brd_wrt[0].checked = true;
		brd_lst[0].checked = true;
		brd_reply[0].checked = true;
		brd_vbl[0].checked = true;
		brd_mail.checked = true;
	}
	else{
		brd_mail.checked = false;
		brd_mail.disabled = true;
	}

}


function SetPermission( gubun, value ) {
	var objSelected = acllist;
	
	if( objSelected.selectedIndex == -1 ) 
	{
		alert(L_ACLERRORMESSAGE);
		return false;cmdOk_onclick
	}

	var pos = objSelected.selectedIndex;
	var SelectedUser = objSelected.options[pos];

	if( SelectedUser.acl.substring(0,1) == '1' && SelectedUser.user_id == g_UserID && gubun != "manager" && gubun != "mail")
	{
		alert("" + strLang37 + "");
		brd_mng[0].checked = true;
		return false;
	}	
	
	var acl_cnt;
	var strAcl;
	
	if( gubun == "mng" )
		CheckMng();
	
	if( gubun == "lst")   
		CheckLst();
	
	if( gubun == "read") 
		CheckRead();
		
	if( gubun == "vbl")  
		CheckVbl();

	if( gubun == "wrt")  
		CheckWrt();
		
	if( gubun == "reply")
		CheckReply();
	
	if( gubun == "manager")
		CheckManager();

	if( value == 0 && brd_mng[0].checked && gubun != "manager" && gubun != "mail")
		return false;
		
	acl_cnt = objSelected.options.length;
	
	for( i = 0; i < acl_cnt; i++ )
	{
		if( objSelected.options[i].selected )
		{
			pos = objSelected.options[i].value.lastIndexOf('^');
			tmp = objSelected.options[i].value.substring(0, pos);
						
			SetAclLst();
			objSelected.options[i].value = tmp + "^" + L_AclValue;			
			objSelected.options[i].text = tmp.substring(2, tmp.length) + " " + L_AclText;			
			
			objSelected.options[i].acl = L_AclValue;
			
			objSelected.options[i].selected = true;
		}
	}
}


function SetAclLst() {
	var strNewAcl = "",strGrant = "",strDeny = "",strlstDeny="";
	

	if( brd_mng[0].checked )	{
		strNewAcl = strNewAcl + "1";
		strGrant = strGrant + "" + strLang38 + "";
	} else	{
		strNewAcl = strNewAcl + "0";
		strDeny = strDeny + "" + strLang38 + "";
	}
	
	if( brd_read[0].checked )	{
		strNewAcl = strNewAcl + "1";
		strGrant = strGrant + "" + strLang39 + "";
	} else {
		strNewAcl = strNewAcl + "0";
		strDeny = strDeny + "" + strLang39 + "";
	}
	
	if( brd_wrt[0].checked )	{
		strNewAcl = strNewAcl + "1";
		strGrant = strGrant + "" + strLang40 + "";
	} else	{
		strNewAcl = strNewAcl + "0";
		strDeny = strDeny + "" + strLang40 + "";
	}
	
	if( brd_lst[0].checked )	{
		strNewAcl = strNewAcl + "1";
		strGrant = strGrant + "" + strLang41 + "";
	} else if( brd_lst[1].checked ){
		strNewAcl = strNewAcl + "0";
		strDeny = strDeny + "" + strLang41 + "";
	} else if( brd_lst[2].checked )	{
		strNewAcl = strNewAcl + "2";
		strlstDeny = strlstDeny + "" + strLang41 + "";
	}
	
	if( brd_vbl[0].checked )	{
		strNewAcl = strNewAcl + "1";
		strGrant = strGrant + "" + strLang42 + "";
	} else	{
		strNewAcl = strNewAcl + "0";
		strDeny = strDeny + "" + strLang42 + "";
	}

	if( brd_reply[0].checked )	{
		strNewAcl = strNewAcl + "1";
		strGrant = strGrant + "" + strLang43 + "";
	} else {
		strNewAcl = strNewAcl + "0";
		strDeny = strDeny + "" + strLang43 + "";
	}

	if( strGrant.length > 0 ) strGrant = strGrant + "" + strLang44 + "";
	if( strDeny.length > 0 ) strDeny = strDeny + "" + strLang45 + "";
	if( strlstDeny.length > 0 ) strlstDeny = strlstDeny + "" + strLang46 + "";
	
	if( strGrant.length > 0 &&  strDeny.length > 0  && strlstDeny.length > 0 ) {
		strLst = strGrant + ", " +  strlstDeny  + ", " +  strDeny;
	} else if( strGrant.length > 0 &&  strDeny.length > 0  && strlstDeny.length <= 0 ) {
		strLst = strGrant + ", " + strDeny;
	} else {
		strLst = strDeny;
		if( strDeny.length == 0 ) {
			strLst = "" + strLang47 + ""
		}
	}
	
	if( brd_manager[0].checked ){
		strNewAcl = strNewAcl + "1";
		strLst = strLst + ", " + strLang48 + ""
	} else{
		strNewAcl = strNewAcl + "0";
		strLst = strLst + ", " + strLang49 + ""
	}
	
	if( brd_mail.checked ){
		strNewAcl = strNewAcl + "1";
	} else{
		strNewAcl = strNewAcl + "0";
	}
	 	
	L_AclText = strLst;
	L_AclValue = strNewAcl;
	
}


function SetUserValue() {
	var pos = acllist.selectedIndex;
	var pos1 = acllist.options[pos].value.lastIndexOf('^');
	var strAcl = acllist.options[pos].acl;


	var objSelected = acllist;
	var SelectedUser = objSelected.options[pos];

	brd_manager[0].disabled = false;
	
	if (SelectedUser.user_id == "everyone") {
		brd_mail.disabled = true;
		brd_manager[1].checked = true;
		brd_manager[0].disabled = true;
	}
	
	if( L_BrdGb == "2" ) {
		brd_read[0].disabled = true;	
		brd_lst[0].disabled = true;
		brd_reply[0].disabled = true;
	} else {
		brd_read[0].disabled = false;	
		brd_lst[0].disabled = false;
		brd_reply[0].disabled = false;
	}

	if( strAcl.substring(0,1) == '1') {
		brd_mng[0].checked = true;
		brd_read[0].disabled = false;
		brd_lst[0].disabled = false;
		brd_reply[0].disabled = false;
	} else {
		brd_mng[1].checked = true;
	}
		
	if( strAcl.substring(1,2) == '1') {
		brd_read[0].checked = true;
	} else {
		brd_read[1].checked = true;
	}
	
	if( strAcl.substring(2,3) == '1') {
		brd_wrt[0].checked = true;
	} else {
		brd_wrt[1].checked = true;
	}
		
	if( strAcl.substring(3,4) == '1') {
		brd_lst[0].checked = true;
	} else if( strAcl.substring(4,5) == '2') {
		brd_lst[2].checked = true;
	} else {
		brd_lst[1].checked = true;
	}
		
	if( strAcl.substring(4,5) == '1') {
		brd_vbl[0].checked = true;
	} else {
		brd_vbl[1].checked = true; 
	}
		
	if(strAcl.substring(5,6) == '1') {
		brd_reply[0].checked = true;
	} else {
		brd_reply[1].checked = true;
	}

	if(strAcl.substring(6,7) == '1') {
		brd_mail.disabled = false;
		brd_manager[0].checked = true;
	} else {	
		brd_mail.disabled = true;
		brd_manager[1].checked = true;
	}
		
	if(strAcl.substring(7,8) == '1') {
		brd_mail.checked = true;
	} else {
		brd_mail.checked = false;
	}
}

function makeArray(n) {
	this.length = n;
	for( var i = 1;	i <= n;	i++ ) {
		this[i] = 0;
	}
	return this;
}


