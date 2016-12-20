function OpenAlertUI(pAlertContent)
{
	var parameter = pAlertContent;
	var url = "/ezApprovalG/ezAprAlert.do";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	//2011.07.28 FireFox는 ShowModalDialog() 호출시 화면 중앙에 뜨지 않아 top, left를 지정해 줘야한다.	
	feature =  feature + GetShowModalPosition(330, 205);
	var RtnVal = window.showModalDialog(url,parameter,feature);
}

//기록물철 업무담당자 여부
function ISCabCharger(pCabClassNo, pUserID)
{
	var XmlHttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();	// 매개변수 전달을 위한 XMLDOM
	var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); // Root Node 생성
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);// 회사 아이디
    createNodeAndInsertText(xmlpara, objNode, "CABCLASSNO", pCabClassNo);// 처리과 코드
    createNodeAndInsertText(xmlpara, objNode, "USERID", pUserID);// 처리과 코드
		
	XmlHttp.open("POST","/myoffice/ezApprovalG/ezCabinet/aspx/API_ISCabCharger.aspx",false);
	XmlHttp.send(xmlpara);
	
	var ResultXML = XmlHttp.responseXML; 
    var rtnVal = getNodeText(GetChildNodes(ResultXML)[0]);   
            
	if (rtnVal=="FALSE" || rtnVal=="")
	{
		OpenAlertUI(strLang489);
		return false;
	}
	else
	{
		if(rtnVal=="0")
			return false;
		else if(rtnVal=="1")
			return true;
	}
}

function initUserRoleinfo()
{	
	//기록물관리 책임자 여부
	if(GetValFromRoleStr(szRoleInfo, "m")=="1")
		g_bRecAdmin = true;
	else
		g_bRecAdmin = false;
	
	//부서 업무담당자 여부
	if(GetValFromRoleStr(szRoleInfo, "w")=="1")
		g_bDeptCharger = true;
	else
		g_bDeptCharger = false;
		
	//관리자 여부
	if(GetValFromRoleStr(szRoleInfo, "c")=="1")
		AdminYN ="TRUE";
	else
		AdminYN ="FALSE";
}

function GetValFromRoleStr(szRoleStr, RoleChar)
{
	var idx=szRoleStr.indexOf(RoleChar);
	// 수정(2007.06.25) : 권한 값 비교 시 "=" 추가
	if( idx >= 0 )
		return szRoleStr.substr(idx+2, 1);
	else
		return "";
}

//문서과 여부인지를 리턴
function IsDocDept(pDeptCode)
{
	// 여기서 문서과 여부를 가지고 온다.
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
 
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA"); // Root Node 생성
    createNodeAndInsertText(xmlpara, objNode, "CN", pDeptCode);
    createNodeAndInsertText(xmlpara, objNode, "PROP",  "extensionAttribute4");
 
	xmlhttp.open("POST","/myoffice/ezOrgan/OrganInfo/GetADInfo.aspx",false);
	xmlhttp.send(xmlpara);
	
	var ResultXML = xmlhttp.responseXML; 
    var result = getNodeText(GetChildNodes(ResultXML)[0]);  
	if (result != "")
		return true;
	else
		return false;
}