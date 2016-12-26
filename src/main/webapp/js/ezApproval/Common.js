var colSignCnt = 10;


function CheckAprLineInfo()
{
	var xmldom = createXmlDom();
	try
	{
		xmldom.load(getAprLineInfo());
		
		if(xmldom.getElementsByTagName("ROW").length == 0 )
			return "OK";
			
	    if( _DeptInfo != "" && _DeptInfo != null) 
        {

		    for(var i=0;i<xmldom.getElementsByTagName("ROW").length;i++)
		    {
		        var pUserId = getNodeText(xmldom.getElementsByTagName("ROW").item(i).selectSingleNode("CELL/DATA4"));
		        var pDeptID = getNodeText(xmldom.getElementsByTagName("ROW").item(i).selectSingleNode("CELL/DATA6"));
		        var pDeptName = getNodeText(xmldom.getElementsByTagName("ROW").item(i).selectNodes("CELL").item(3));
		    	if (pUserId == arr_userinfo[1] && pDeptID == arr_userinfo[4])
			    {	
				    var end="OK";
		    		return "OK";	
			    }
			    else
			    {
			        if(pUserId == arr_userinfo[1]) 
                    { 
			            pDeptName = getNodeText(xmldom.getElementsByTagName("ROW").item(i).selectNodes("CELL").item(3)); 
                    } 
                    else 
                    { 
                      var pBujaeUserInfo = getBujaeInfo_AprLine(pUserId); 
                      if(pBujaeUserInfo != "") 
                      { 
                          var arrBUserInfo = new Array(""); 
                              arrBUserInfo = pBujaeUserInfo.split(":");

                              if (arrBUserInfo[0] == arr_userinfo[1] && arrBUserInfo[2] == pUserCurrentDeptID)
                              { 
                            return "OK"; 
                              } 
                              else if(arrBUserInfo[0] == arr_userinfo[1]) 
                              { 
                                  pDeptName = arrBUserInfo[3]; 
                              } 
                      } 
                    } 

			    }
		    }
		    if(end !="OK")
		    {
	    		pDeptName = pDeptName.replace("\"", "");
	    		return pDeptName;
		    }
		 }
		 else
		 {
		    return "OK";
		 }
	}
	catch (e)
	{
		alert(e.description);
		return "OK";
	}
}
function getBujaeInfo_AprLine(pBujaeUserID) 
{ 
    var xmlpara = createXmlDom();


    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "USERID", pBujaeUserID);

    var xmlhttp_bujaeinfo = createXMLHttpRequest(); 
    xmlhttp_bujaeinfo.open("POST","/myoffice/ezApproval/aspx/GetBujaeCheckInfo.aspx", false); 
    xmlhttp_bujaeinfo.send(xmlpara); 

    return xmlhttp_bujaeinfo.responseText; 
} 
function getAprLineInfo()
{
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Mode", "APR");

	var xmlhttp = createXMLHttpRequest();
	xmlhttp.open("POST", "/myoffice/ezApproval/ezLine/aspx/GetIngLineInfo.aspx", false);
	xmlhttp.send(xmlpara);

	if (xmlhttp.statusText == "OK")
		return loadXMLString(xmlhttp.responseText);
	else
		return "";
}

function escapenew(str)
{
	if (str == undefined)
		return "";

	var ret = escape(ReplaceText(str, "·", "_kaoni_special_1_"));
	ret = ReplaceText(ReplaceText(ret, "_kaoni_special_1_", "%A1%A4"), "\\+", "%2B");
	return ret;
}
function getGyulJeDateDB()
{
    try
    {
	    var objRoot;
	    var objNode;
        
	    var xmlpara = createXmlDom();
	    var xmlhttp = createXMLHttpRequest();
    	
	    createNodeInsert(xmlpara, objNode, "PARAMETER");
	    createNodeAndInsertText(xmlpara, objNode, "getDate", "");

	    xmlhttp.open("POST","/myoffice/ezApproval/aspx/GetDateDB.aspx",false);
	    xmlhttp.send(xmlpara);
        
	    return xmlhttp.responseText;
    }
    catch(e)
    {
        alert("getGyulJeDateDB()" + e.description);
    }
}
function DrawAutoAprLine(ret, pDraftFlag) {

    var SignCnt = 0; 
    var HapyCnt = 0; 
    var SSignCnt = 0; 
    var SHapyCnt = 0; 

    var SignHTML = "";
    var HapyHTML = "";
    var SSignHTML = "";
    var SHapyHTML = "";

    var pFormTagName = new Array(); 

    var i, j, p, k, z;


    var xmldom = createXmlDom();
    xmldom.loadXML(ret);
    var susinSN = "";
    var Recv = "";

    if (pDraftFlag == "SUSIN") {
        susinSN = pSusinSN;
        Recv = pSusinSN+"Recv";
    }
    objNodes = xmldom.selectNodes("LISTVIEWDATA/ROWS/ROW");
    FormProc = pzFormProc.object;
    fields = FormProc.Fields;
    count = objNodes.length;

    for (i = 0; i < count; i++) {
        var KyljeaType = getNodeText(objNodes.item(i).childNodes(16));
        if (KyljeaType == "A03001" || KyljeaType == "A03003" || KyljeaType == "A03004" || KyljeaType == "A03015" || KyljeaType == "A03040") {
            SignCnt = SignCnt + 1;
        }
        if (KyljeaType == "A03008" || KyljeaType == "A03009" || KyljeaType == "A03011" || KyljeaType == "A03012") {
            HapyCnt = HapyCnt + 1;
        }
    }

    var tempLen = 0;
    var SignLen = 0;
    var tempLen1 = parseInt(SignCnt / colSignCnt);
    SignLen = (SignCnt % colSignCnt > 0) ? tempLen1 + 1 : tempLen1;

    var HapyLen = 0;
    var tempLen2 = parseInt(HapyCnt / colSignCnt);
    HapyLen = (HapyCnt % colSignCnt > 0) ? tempLen2 + 1 : tempLen2;
    field = fields.Item(Recv + "AprLine");
    if (field && SignCnt > 0) {
        if (Recv != "")
            pFormTagName[0] = "<P align=center>수</P><P align=center>신</P><P align=center>결</P><P align=center>재</P>";
        else
            pFormTagName[0] = "<P align=center>기</P><P align=center>안</P><P align=center>결</P><P align=center>재</P>";

        pFormTagName[1] = "18";

        var strHTML = "";
        k = 1;
        z = (SignCnt >= colSignCnt) ? colSignCnt : SignCnt;

        strHTML = "<TABLE style='FONT-SIZE: 0pt' cellSpacing=0 cellPadding=0 align=right valign=top>";
        for (p = 1; SignLen >= p; p++) {
            strHTML += "<TR><TD>";
            if (p >= SignLen) {
                z = SignCnt;
            }

            strHTML += "<TABLE style='TABLE-LAYOUT:fixed; FONT-SIZE:9pt; FONT-FAMILY:굴림체; Design_Time_Lock:true' cellSpacing='0' borderColorDark='white' cellPadding='0' borderColorLight='black' border='1' align='right'>";
            for (i = 1; i <= 3; i++) {
                strHTML += "<TR>";
                for (j = k; j <= z; j++) {
                    if (i == "1" && (j % colSignCnt) == "1") {
                        strHTML += "<TD vAlign='middle' width='" + pFormTagName[1] + "' rowSpan='4' align='center' bgColor='#d2e2fd'><STRONG>" + pFormTagName[0] + "</STRONG></TD>";
                    }

                    switch (i.toString()) {
                        case "1":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "jikwe" + j + "' vAlign='middle' align='center' width='64' height='17' bgColor='#efefef'>";

                            if (fields.Item(susinSN + "jikwe" + j))
                                strHTML += fields.Item(susinSN + "jikwe" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "2":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "sign" + j + "' vAlign='middle' align='center' width='64' height='50'>";

                            if (fields.Item(susinSN + "sign" + j))
                                strHTML += fields.Item(susinSN + "sign" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "3":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "seumyungdate" + j + "' vAlign='middle' align='center' width='64' height='17'>";

                            if (fields.Item(susinSN + "seumyungdate" + j))
                                strHTML += fields.Item(susinSN + "seumyungdate" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                    }
                }

                strHTML += "</TR>";
            }
            strHTML += "</TABLE>";
            strHTML += "</TD></TR>";

            if (SignCnt > (p * colSignCnt)) {
                k = k + colSignCnt;
                z = z + colSignCnt;
            }
        }
        strHTML += "</TABLE>";
        field.TagObject.innerHTML = strHTML;

    }

    if (field && SignCnt <= 0) {
        field.TagObject.innerHTML = "&nbsp;";
    }

    field = fields.Item(Recv + "AprHapuiLine");

    if (field && HapyCnt <= 0) {
        field.TagObject.innerHTML = "&nbsp;";
    }

    if (field && HapyCnt > 0) {
        pFormTagName[0] = "<P align=center>합</P><P align=center>의</P><P align=center>결</P><P align=center>재</P>";
        pFormTagName[1] = "18";


        k = 1;
        z = (HapyCnt >= colSignCnt) ? colSignCnt : HapyCnt;
        strHTML = "<TABLE style='FONT-SIZE: 0pt' cellSpacing=0 cellPadding=0 align=right valign=top>";

        for (p = 1; HapyLen >= p; p++) {
            strHTML += "<TR><TD>";
            if (p >= HapyLen) {
                z = HapyCnt;
            }
            strHTML += "<TABLE style='TABLE-LAYOUT:fixed; FONT-SIZE:9pt; FONT-FAMILY:굴림체; Design_Time_Lock:true' cellSpacing='0' borderColorDark='white' cellPadding='0' borderColorLight='black' border='1' align='right'>";
            for (i = 1; i <= 3; i++) {
                strHTML += "<TR>";
                for (j = k; j <= z; j++) {
                    if (i == "1" && (j % colSignCnt) == "1") {
                        strHTML += "<TD vAlign='middle' width='" + pFormTagName[1] + "' rowSpan='4' align='center' bgColor='#d2e2fd'><STRONG>" + pFormTagName[0] + "</STRONG></TD>";
                    }

                    switch (i.toString()) {
                        case "1":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "habyuipositon" + j + "' vAlign='middle' align='center' width='64' height='17' bgColor='#efefef'>";

                            if (fields.Item(susinSN + "habyuipositon" + j))
                                strHTML += fields.Item(susinSN + "habyuipositon" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "2":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "habyuisign" + j + "' vAlign='middle' align='center' width='64' height='50'>";

                            if (fields.Item(susinSN + "habyuisign" + j))
                                strHTML += fields.Item(susinSN + "habyuisign" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "3":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "habyuidate" + j + "' vAlign='middle' align='center' width='64' height='17'>";

                            if (fields.Item(susinSN + "habyuidate" + j))
                                strHTML += fields.Item(susinSN + "habyuidate" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                    }
                }
                strHTML += "</TR>";
            }

            strHTML += "</TABLE>";
            strHTML += "</TD></TR>";

            if (HapyCnt > (p * colSignCnt)) {
                k = k + colSignCnt;
                z = z + colSignCnt;
            }

        }
        strHTML += "</TABLE>";
       
        field.TagObject.innerHTML = strHTML;
    }

    pzFormProc.Refresh();
}

function chkProcessorLines(xmlPath , susinSn)
{    
    var xmlpara = createXmlDom();
    try 
    {        
        xmlpara.loadXML(xmlPath.innerHTML);
    } 
    catch(e) 
    {
        return "<PROCESSORLINE><MUST></MUST><MUSTNOT></MUSTNOT></PROCESSORLINE>";
    }

    var RtnXML = "<PROCESSORLINE><MUST>";
    var objNodes = xmlpara.selectNodes("PROCESSOR/FLOW");
    
    if (objNodes.length > 0)
	{
        var nodeName ="APRLINES"+(parseInt(susinSn)+1)+"/APRLINE";
        var objCheck = objNodes.item(i).selectNodes(nodeName);

        for (var i=0; i<objCheck.length; i++)
        {
            var pOrder = getNodeText(objCheck.item(i).selectSingleNode("ORDER"));
            var pAprType = getNodeText(objCheck.item(i).selectSingleNode("APRTYPE"));
            var pClass = getNodeText(objCheck.item(i).selectSingleNode("CLASS"));
            var pValue = getNodeText(objCheck.item(i).selectSingleNode("VALUE"));
            var pDesc = getNodeText(objCheck.item(i).selectSingleNode("DESC"));

            RtnXML = RtnXML + "<APRLINE><ORDER>" + pOrder + "</ORDER><APRTYPE>" + MakeXMLString(pAprType) + 
            "</APRTYPE><CLASS>" + MakeXMLString(pClass) + 
            "</CLASS><VALUE>" + MakeXMLString(pValue) + 
            "</VALUE><DESC>" + MakeXMLString(pDesc) + "</DESC></APRLINE>";
        }
	    RtnXML = RtnXML + "</MUST><MUSTNOT></MUSTNOT>";
	    var MustCheck = "True";
	    
	    if(xmlpara.getElementsByTagName("ISMUST").length != 0 )
	        MustCheck = getNodeText(xmlpara.getElementsByTagName("ISMUST").item(0));
       
            
	    RtnXML = RtnXML + "<ISMUST>" + MustCheck + "</ISMUST></PROCESSORLINE>";
	}
	return RtnXML;
}
