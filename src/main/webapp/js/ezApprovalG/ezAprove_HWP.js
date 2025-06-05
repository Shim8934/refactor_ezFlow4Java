var lastKyulName, lastKyuljiwee, LastSignSN, pAprLineB4type;
var pOrgAttach;
var bbtnApprove = "";
var bbtnReject = "";
var bbtnStay = "";
var bbtnJunKyul = "";
var bbtnModAprLine = "";
var bbtnEdit = "";
var bbtnOpinion = "";
var bbtnFileAttach = "";
var bbtnAprDocAttach = "";
var bbtnPrint = "";
var bbtnSave = "";
var bbtnmail = "";
var bbtnSetTaskCode = "";
var bbtnAddSepAttach = "";
var bbtnhistory = "";
var bbtnDocInfo = "";
var bbtnModAprDept = "";
var bbtntotaldocinfo = "";
function putBansongSign()
{
	var SingFlag = true;
	var habyui
	var signInfo  = new Array();
	var signCnt = 0;

	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 

	
	if(pAprLineType ==  strAprType9 || pAprLineType ==  strAprType11 || pAprLineType ==  strAprType12)
	{ 
  		var phabyuisign;
  		var phabyuidate;
  		var phabyuijikwee;
  		var phabyuidept;  	
  		if(pDraftFlag == "SUSIN")
  		{
  			phabyuisign = pSusinSN + "habyuisign";
  			phabyuidate = pSusinSN + "habyuidate";
  			phabyuijikwee = pSusinSN + "habyuipositon";
  			phabyuidept = pSusinSN + "habyui";
  		}
  		else
  		{
  			phabyuisign   = "habyuisign";
  			phabyuidate   = "habyuidate";
  			phabyuijikwee = "habyuipositon";
  			phabyuidept   = "habyui";
  		}
  	
		habyui = phabyuisign + pAprMemberSN;
		if (HwpCtrl.CheckFieldExist(habyui))
		{
			HwpCtrl.SetFieldText(habyui, strLang4);
			field.value = strLang4;
			SignContent[signCnt] = strLang4;
			signInfo[signCnt] = habyui
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = habyui;					
					
			signCnt = signCnt + 1
			SingFlag = false; 
		}
		
		var habyuidateID = phabyuidate + pAprMemberSN;
		if (HwpCtrl.CheckFieldExist(habyuidateID))
		{
			HwpCtrl.SetFieldText(habyuidateID, s);
			signInfo[signCnt] = habyuidateID;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = habyuidateID;
			SignContent[signCnt] = s;					
			signCnt = signCnt + 1;
		}
	}
	return signInfo;   
}

function AprrovMappingSign(ret)
{
	var SingFlag = true;
	var DekyulFlag = false;
	var habyui
	var signInfo  = new Array();
	var signCnt;
	
	signCnt = 0;

	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 
	
	var OpinionText = "";
	var PositionText = "";
	
	if( LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16)   
	{
		OpinionText = getSignDate() + "\15";
	}
	
	
	if(pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12)
	{ 
  		var phabyuisign;
  		var phabyuidate;
  		var phabyuijikwee;
  		var phabyuidept;
  	
  		if(pDraftFlag == "SUSIN")
  		{
  			phabyuisign = pSusinSN + "habyuisign";
  			phabyuidate = pSusinSN + "habyuidate";
  			phabyuijikwee = pSusinSN + "habyuipositon";
  			phabyuidept = pSusinSN + "habyui";
  		}else{ 
  			phabyuisign   = "habyuisign";
  			phabyuidate   = "habyuidate";
  			phabyuijikwee = "habyuipositon";
  			phabyuidept   = "habyui";
  		}
  	
		var habyui = phabyuisign + pAprMemberSN;
		if (HwpCtrl.CheckFieldExist(habyui))
		{
			if(ret != "NAME" && ret != "")
			{
				HwpCtrl.SetFieldText(habyui, "");
				HwpCtrl.SetFieldImage(habyui, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);

				if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
					HwpCtrl.AppendFieldText(habyui, strLang17, true);

				signInfo[signCnt] = habyui;
				SignName[signCnt] = habyui;
				if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
				{
					SignType[signCnt] = "IMAGE";
					SignContent[signCnt] = ret+"::"+strLang17;
				}
				else
				{
					SignType[signCnt] = "IMAGE";
					SignContent[signCnt] = ret;
				}
				SetDocumentElement(HwpCtrl, habyui, ret);
				
				signCnt = signCnt + 1
				SingFlag = true;
			}
			else
			{
				if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
				{
					HwpCtrl.SetFieldText(habyui, strLang8 + arr_userinfo[2]);	
					SignContent[signCnt] = strLang8 + arr_userinfo[2];
				}
				else
				{
					HwpCtrl.SetFieldText(habyui, arr_userinfo[2]);	
					SignContent[signCnt] = arr_userinfo[2];
				}				
	
				signInfo[signCnt] = habyui
				SignType[signCnt] = "TEXT";
				SignName[signCnt] = habyui;
				signCnt = signCnt + 1
				SingFlag = false; 
			}
		}
	  
		var habyuidateID = phabyuidate + pAprMemberSN;
		if (HwpCtrl.CheckFieldExist(habyuidateID))
		{
			HwpCtrl.SetFieldText(habyuidateID, s);		
			signInfo[signCnt] = habyuidateID;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = habyuidateID;
			SignContent[signCnt] = s;					
			signCnt = signCnt + 1;
		}
		
		var phabyuijikweeID = phabyuijikwee + pAprMemberSN;
		if (HwpCtrl.CheckFieldExist(phabyuijikweeID))		
		{
			HwpCtrl.SetFieldText(phabyuijikweeID, HwpCtrl.GetFieldText(phabyuijikweeID) + PositionText);
		}
	}
	else if(pAprLineType == strAprType2 || pAprLineType == strAprType7)
	{
	
	}
	else if(pAprLineType == strAprType15)
	{
		signID = "gamsasign1" 
		if (HwpCtrl.CheckFieldExist(signID))		
		{
			HwpCtrl.SetFieldText(signID, arr_userinfo[2] + "\15" + s);
			signInfo[signCnt] = signID;
			SignName[signCnt] = signID;
			SignType[signCnt] = "TEXT";
			SignContent[signCnt] = arr_userinfo[2] + "\15" + s;
			
			signCnt = signCnt + 1;
		}
	}
	else
	{ 
		var pAprMemberSignSN = pAprMemberSN;
		var signID;
		var seumyungID;
		var seumyungdateID;
		
		if(pDraftFlag == "SUSIN")
		{
			signID = pSusinSN + "sign" + pAprMemberSignSN;
			seumyungID = pSusinSN + "jikwe" + pAprMemberSignSN;
			seumyungdateID = pSusinSN + "seumyungdate" + pAprMemberSignSN;
		}else{
			signID = "sign" + pAprMemberSignSN;
			seumyungID = "jikwe" + pAprMemberSignSN;
   			seumyungdateID = "seumyungdate" + pAprMemberSignSN;
		}
		
		if (HwpCtrl.CheckFieldExist(seumyungdateID)) {
		    HwpCtrl.SetFieldText(seumyungdateID, s);
		}

		if (HwpCtrl.CheckFieldExist(seumyungID))		
		{
			HwpCtrl.SetFieldText(seumyungID, HwpCtrl.GetFieldText(seumyungID) + PositionText);
		}
				
		if(pAprLineType == strAprType16)  
		{			
			if (HwpCtrl.CheckFieldExist(signID))
	  		{
	  			if(ret != "NAME")
	  			{
					HwpCtrl.SetFieldText(signID, "");
					HwpCtrl.SetFieldImage(signID, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);
                    var content ="";
					if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
					{
						HwpCtrl.AppendFieldText(signID, strLang17, true);
						content = strLang17;
					}
	  			
	  				HwpCtrl.AppendFieldText(signID, strLang7 + OpinionText, true);
	  				content = strLang7 + OpinionText;

	  				signInfo[signCnt] = signID;
			        SignName[signCnt] = signID;
			        SignType[signCnt] = "IMAGE";
			        SignContent[signCnt] = ret +"::"+ arr_userinfo[2] + "\15" + s;
			
	  				SetDocumentElement(HwpCtrl, signID, ret);
	  				signCnt = signCnt + 1
	  				SingFlag = true;
	  			}
	  			else
	  			{
	  			    var content ="";
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
						HwpCtrl.SetFieldText(signID, strLang8 + arr_userinfo[2]);
	  			        content = strLang8 + arr_userinfo[2];
					} else {
						HwpCtrl.SetFieldText(signID, arr_userinfo[2]);
						content = arr_userinfo[2];
					}
					
					if (!HwpCtrl.CheckFieldExist(seumyungdateID)) {
						HwpCtrl.AppendFieldText(signID, OpinionText, true);
						content = content + OpinionText;
					}
					
					HwpCtrl.AppendFieldText(signID, strLang7 + "\15", true);
					content = content + strLang7;
					
	  				signInfo[signCnt] = signID;
			        SignName[signCnt] = signID;
			        SignType[signCnt] = "TEXT";
			        SignContent[signCnt] = content;
	  				signCnt = signCnt + 1
	  				SingFlag = false;
	  			}
	  		
	  			DekyulFlag = true;
	  			pAprMemberSignSN = pAprMemberSignSN + 1;
				if(pDraftFlag == "SUSIN")
				{
					signID = pSusinSN + "sign" + pAprMemberSignSN;
					seumyungID = pSusinSN + "jikwe" + pAprMemberSignSN;
					seumyungdateID = pSusinSN + "seumyungdate" + pAprMemberSignSN;
				}
				else
				{
					signID = "sign" + pAprMemberSignSN;
					seumyungID = "jikwe" + pAprMemberSignSN;
   					seumyungdateID = "seumyungdate" + pAprMemberSignSN;
				}
			}
		}		
		
		if (HwpCtrl.CheckFieldExist(signID))
		{  	
			if (DekyulFlag && pAprLineB4type == strAprType4)
			{
				HwpCtrl.SetFieldText(signID, strLang6);
	  			signInfo[signCnt] = signID;
		        SignName[signCnt] = signID;
		        SignType[signCnt] = "TEXT";
		        SignContent[signCnt] = strLang6;
			        
	  			signCnt = signCnt + 1
			}
			else if (DekyulFlag)
			{
			}
			else
			{
			    var contents = "";
	  			if(ret != "NAME")
	  			{
	  				var strimg;
					HwpCtrl.SetFieldText(signID, "");
					HwpCtrl.SetFieldImage(signID, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);

					if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
					{
						HwpCtrl.AppendFieldText(signID, strLang17, true);
						contents = strLang17;
					}

					if (!HwpCtrl.CheckFieldExist(seumyungdateID)) {
					    HwpCtrl.AppendFieldText(signID, OpinionText, true);
					    contents = contents + OpinionText;
					}

					if(pAprLineType == strAprType4)
					{
	  					HwpCtrl.AppendFieldText(signID, strLang6, true);
	  					contents = contents + strLang6;
	  				}

					if(pAprLineType == strAprType16)  
					{
	  					HwpCtrl.AppendFieldText(signID, strLang7, true);
	  					contents = contents + strLang7;
	  				}
	      
	  				signInfo[signCnt] = signID;
		            SignName[signCnt] = signID;
		            SignType[signCnt] = "IMAGE";
		            SignContent[signCnt] = ret+"::"+contents;
		        
	  				SetDocumentElement(HwpCtrl, signID, ret);
	  				signCnt = signCnt + 1
	  				SingFlag = true;
	  			}
	  			else
	  			{
					if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
					{
						HwpCtrl.SetFieldText(signID, strLang8 + arr_userinfo[2]);
						contents = strLang8 + arr_userinfo[2];	
					}
					else
					{
						HwpCtrl.SetFieldText(signID, arr_userinfo[2]);
						contents = arr_userinfo[2];		
					}

					if (!HwpCtrl.CheckFieldExist(seumyungdateID)) {
					    HwpCtrl.AppendFieldText(signID, OpinionText, true);
					    contents = contents + OpinionText;
					}

					if(pAprLineType == strAprType4)
					{
						HwpCtrl.AppendFieldText(signID, strLang6 + "\15", true);
						contents = contents + strLang6;
	  				}

					if(pAprLineType == strAprType16)  
					{
						HwpCtrl.AppendFieldText(signID, strLang7 + "\15", true);
						contents = contents + strLang7;
	  				}

	  				signInfo[signCnt] = signID;
		            SignName[signCnt] = signID;
		            SignType[signCnt] = "TEXT";
		            SignContent[signCnt] = contents;
	  				signCnt = signCnt + 1
	  				SingFlag = false; 
	  			}
	  		}
		}
	}
	return signInfo;   
}

function putJunkyulSign(signID)
{
	if (HwpCtrl.CheckFieldExist(signID))
	{
		HwpCtrl.SetFieldText(signID, strLang6);	
	}
}

function putKyuljeSign(signID)
{
}

function UndoSignInfo(signInfo)
{
	var cnt;
	for(cnt=0;cnt < signInfo.length;cnt++)
		if (HwpCtrl.CheckFieldExist(signInfo[cnt]))
			HwpCtrl.SetFieldText(signInfo[cnt], " ");
}

function openOpinionUI(ret)
{
	var parameter = new Array();
	parameter[0] = pDocID;    
	parameter[1] = ret;       
	parameter[2] = KuyjeType; 
	parameter[3] = pOrgDocID;
	parameter[5] = window;
	
	parameter[98] = orgCompanyID;
    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
    parameter[99] = "hwp";
    
	var url = "/ezApprovalG/aprOpinion.do";
	var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
	var ret = window.showModalDialog(url,parameter,feature);
		
	if (ret != "cancel" && ret != undefined)	{
		var Rtnxml = new ActiveXObject("Microsoft.XMLDOM");
		Rtnxml.async = "false";
		Rtnxml.loadXML(ret);
		
		var NodeList = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
			  
		if (NodeList.length != 0)
			pHasOpinionYN = "Y";
		else {
			pHasOpinionYN = "N";
			ret = "cancel";
		}
		
		makeOpinionList(Rtnxml);
	}
	
	return ret;
}

function openOpinionUI_New(pOpinionType) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = "";			//DRAFTFLAG 결재는 공백 고정 
		parameter[3] = docState;	//DOCSTATE
		parameter[4] = orgCompanyID;//ORGCOMPANYID
		parameter[99] = ext;		//EXT
		
		var url = "/ezApprovalG/aprOpinionNew.do";
		var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
		var ret = window.showModalDialog(url,parameter,feature);
		
		if (ret != "cancel" && ret != undefined) {
		    var objXML = new ActiveXObject("Microsoft.XMLDOM");
		    objXML.loadXML(ret);
		    
		    var NodeList = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
		    if (NodeList.length != 0) {
				pHasOpinionYN = "Y";
		    } else {
				pHasOpinionYN = "N";
				ret = "cancel";
		    }
		    makeOpinionList(objXML);
	    }
		
	    return ret;
	} catch (e) {
		alert("openOpinionUI_New ::: " + e.description);
	}
}

function makeOpinionList(OpinionXML) {
	if (!HwpCtrl.CheckFieldExist("opinions"))
		return;

	var firstFlag = true;
	var NodeList = OpinionXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	if (NodeList.length > 0)
	{
		var strOpinion = " ";
		for (i=NodeList.length - 1; i>=0; i--)
		{
		    if (getNodeText(NodeList.item(i).childNodes(9)) == "001")
			{
				if (firstFlag)
				{
					strOpinion = "[" + strLang27;
					firstFlag = false;
				}
			
				if (getNodeText(NodeList.item(i).childNodes(2)) != "")
				    strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(2)) + "\11";  
				else
					strOpinion = strOpinion + "   \11";  
						
				strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(1)) + "\11";
				strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(6)) + "\15";
			}
		}		
		HwpCtrl.SetFieldText("opinions", strOpinion);
		
		if (OpinionAction == "ADD" || OpinionAction == "DEL")
			SaveFile();
			
		OpinionAction = "";
	}
	else
	{
		HwpCtrl.SetFieldText("opinions", "");
	}
}

function openFileAttachUI()
{
	var parameter = pDocID;
	var url = "/ezApprovalG/aprAttach.do?formID=" + pFormID + "&docID=" + pDocID + "&draftFlag=" + pDraftFlag + "&orgCompanyID=" + orgCompanyID + "&ext=" + "hwp";
	var feature	= "status:no;dialogWidth:800px;dialogHeight:610px;edge:sunken;scroll:no"; 
	var ret = window.showModalDialog(url,parameter,feature);

	if (ret != "cancel")	{
		setAttachInfo(pDocID, "APR", lstAttachLink);
	}
	
	return ret;
}

function SaveApproveInfo(pApproveFlag) {
	var rtnVal = SaveFile();

	if (rtnVal.toUpperCase() != "TRUE") {
        return rtnVal;
	}

	SignSave();
	
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DOCID", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[0]));
	createNodeAndInsertText(xmlpara, objNode, "FORMID", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[1]));
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[2]));
	createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[3]));
	createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[4]));
	createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", "002");
	createNodeAndInsertText(xmlpara, objNode, "HREF", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[6]));

	pDocTitle = HwpCtrl.GetFieldText("doctitle");
	createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", pDocTitle);

	if (approvalFlag == 'G' && pDraftFlag == "SUSIN" && useReceiveDocNo == 'NO') {
		if (HwpCtrl.CheckFieldExist("receiptnumber")) {
			createNodeAndInsertText(xmlpara, objNode, "DOCNO", HwpCtrl.GetFieldText("receiptnumber"));
		} else if (HwpCtrl.CheckFieldExist("docnumber")) {
			createNodeAndInsertText(xmlpara, objNode, "DOCNO", HwpCtrl.GetFieldText("docnumber"));
		} else if (HwpCtrl.CheckFieldExist("be_docnumber")) {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", HwpCtrl.GetFieldText("be_docnumber"));
		} else if (HwpCtrl.CheckFieldExist("deptshortedname")) {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", HwpCtrl.GetFieldText("deptshortedname"));
		} else {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
		}
	} else {
		if (HwpCtrl.CheckFieldExist("docnumber"))
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", HwpCtrl.GetFieldText("docnumber"));
		else if (HwpCtrl.CheckFieldExist("be_docnumber"))
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", HwpCtrl.GetFieldText("be_docnumber"));
		else if (HwpCtrl.CheckFieldExist("deptshortedname"))
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", HwpCtrl.GetFieldText("deptshortedname"));
		else
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
	}

	if (pHasAttachYN == "")
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[9]));
	else
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);

	var objNode;

	if (pHasOpinionYN == "")
	    createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[10]));
	else
	    createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);


	createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "");
	createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "");
	createNodeAndInsertText(xmlpara, objNode, "WRITERID", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[13]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[14]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[15]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[16]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[17]));
	createNodeAndInsertText(xmlpara, objNode, "HTML", "");
	createNodeAndInsertText(xmlpara, objNode, "PUSERID", pOrgAprUserID);
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", pOrgAprUserName);
	createNodeAndInsertText(xmlpara, objNode, "PDEPTID", pOrgAprUserDeptID);
	createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");

	createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", pPublicityYN);
	createNodeAndInsertText(xmlpara, objNode, "PROXYUSERID", pingUserID);

	createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);

	createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");
	createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
	createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
	createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml", true);
	if (!g_SepAttachLVXml)
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
	else
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));


	createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);

	createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", getNodeText(xmldoc.getElementsByTagName("WRITERNAME2").item(0)));
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", getNodeText(xmldoc.getElementsByTagName("WRITERJOBTITLE2").item(0)));
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", getNodeText(xmldoc.getElementsByTagName("WRITERDEPTNAME2").item(0)));

	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", pOrgAprUserName2);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "ORGCOMPANYID", orgCompanyID);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", pPublicityYN);
	
	if (nonElecRec == "Y") {
		var NonElecXML = createXmlDom();
		NonElecXML = loadXMLString(nonElecRecInfoXml);
		
		createNodeAndInsertText(xmlpara, objNode, "NONELECREC", nonElecRec);
		createNodeAndInsertText(xmlpara, objNode, "REGISTERTYPE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE"));
		createNodeAndInsertText(xmlpara, objNode, "REGISTERDATE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERDATE"));
		createNodeAndInsertText(xmlpara, objNode, "REGISTERYEAR", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERYEAR"));
		createNodeAndInsertText(xmlpara, objNode, "EXECUTEDATE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "EXECUTEDATE"));
		createNodeAndInsertText(xmlpara, objNode, "TITLE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "TITLE"));
		createNodeAndInsertText(xmlpara, objNode, "APRMEMBERTITLE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "APRMEMBERTITLE"));
		createNodeAndInsertText(xmlpara, objNode, "APRMEMBERTITLE2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "APRMEMBERTITLE2"));
		createNodeAndInsertText(xmlpara, objNode, "DRAFTERNAME", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DRAFTERNAME"));
		createNodeAndInsertText(xmlpara, objNode, "DRAFTERNAME2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DRAFTERNAME2"));
		createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "RECEIPTMEMBER"));
		createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "RECEIPTMEMBER2"));
		createNodeAndInsertText(xmlpara, objNode, "SENDINGMEMBER", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SENDINGMEMBER"));
		createNodeAndInsertText(xmlpara, objNode, "DELIVERYNO", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DELIVERYNO"));
		createNodeAndInsertText(xmlpara, objNode, "ORIGINREGSN", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "ORIGINREGSN"));
		createNodeAndInsertText(xmlpara, objNode, "ELECTRONICRECFLAG", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "ELECTRONICRECFLAG"));
		createNodeAndInsertText(xmlpara, objNode, "NONELECREC_CABINETID", cabinetID);
		
		// 시청각 기록물일경우
		if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "5" || SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "6") {
			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECINFO", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "AUDIOVISUALRECINFO"));
			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECSUMMARY", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SUMMARY"));
		}
		
		// 분리첨부가 존재할 경우
		if (SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW").length > 0) {
			var sepAtt, Data, i;
			var rtnXml = createXmlDom();
	        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
			var sepLVXml = createXmlDom();
            	sepLVXml = loadXMLString(nonElecRecInfoXml);
            var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW");
            
            for (i = 0; i < rows.length; i++) {
                sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
                
                if (SelectSingleNodeValue(rows[i], "SEPCABINETID") != "") {
                	Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(rows[i], "SEPCABINETID"));
                } else {
                	Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(rows[i], "CABINETID"));
                }
                
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", SelectSingleNodeValue(rows[i], "SEPTITLE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(rows[i], "SEPNUMOFPAGE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", SelectSingleNodeValue(rows[i], "SEPREGTYPE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", SelectSingleNodeValue(rows[i], "SEPSUMMARY"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", SelectSingleNodeValue(rows[i], "SEPRECORDTYPE"));
            }
            
            createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SEPERATEATTACH", getXmlString(rtnXml));
		}
		
		// 특수목록이 존재하는 기록물 철 일경우
		if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SPECIALCATALOGFLAG") == "1") {
			if (SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/SCDATA").length > 0) {
    			var sepAtt, Data, i;
    			var rtnXml = createXmlDom();
    			var root = createNodeInsert(rtnXml, root, "SPECIALCATALOGINFO");
    			var sepLVXml = createXmlDom();
    				sepLVXml = loadXMLString(nonElecRecInfoXml);
    			var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/SCDATA");
    			var rows2 = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/SCNAME");
    			
    			sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SCNAME");
    			Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST1", SelectSingleNodeValue(rows2[0], "LIST1"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST2", SelectSingleNodeValue(rows2[0], "LIST2"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST3", SelectSingleNodeValue(rows2[0], "LIST3"));
    			
    			for (i = 0; i < rows.length; i++) {
    				sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SCDATA");
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SN", SelectSingleNodeValue(rows[i], "SN"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST1", SelectSingleNodeValue(rows[i], "LIST1"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST2", SelectSingleNodeValue(rows[i], "LIST2"));
                    Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST3", SelectSingleNodeValue(rows[i], "LIST3"));
    			}
    			
    			createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SPECIALCATALOGINFO", getXmlString(rtnXml));
			}
		}
	}
	
	if (pApproveFlag == "1") {
        xmlhttp.open("POST", "/ezApprovalG/doApprov.do", false);
    } else if (pApproveFlag == "2") {
        xmlhttp.open("POST", "/ezApprovalG/doBansongApprov.do", false);
    } else if (pApproveFlag == "3") {
        xmlhttp.open("POST", "/ezApprovalG/doBoryuApprov.do", false);
    }
	
    xmlhttp.send(xmlpara);
    
    if (xmlhttp != null && xmlhttp.readyState == 4) {
     	 if (xmlhttp.status == 200) {
     	    var dataNodes = GetChildNodes(xmlhttp.responseXML);
     	    return getNodeText(dataNodes[0]);
     	 } else {
     		 SaveOrgFile();
     		 return "FALSE";
     	 }
    }
}

function SaveFile() {
	var result = "";
	
	var data = {
		docID : pDocID,
		formId : pFormID,
		html  : HwpCtrl.GetCloneData("", "HWP"),
		orgCompanyID : orgCompanyID
	}
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveFileHWP.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});
    
    return result;
}

function SaveOrgFile() {
	var result = "";
	
	var data = {
		docID : pDocID,
		formId : pFormID,
		html  : OrgHtml
	}
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveFileHWP.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});
    
    return result;
}

function CheckDocCellInfo()
{
	var fieldname;
	var pSusinNextSN;
	var SignInfoFlag = true;
	hapyuiCount = 0;
	SignCount = 0;
	gongramCount = 0;

	var FieldLists = HwpCtrl.GetFieldList();
	var Fields = FieldLists.split(";");
  
	for (i = 0 ; i < Fields.length ; i ++)
	{
		if(pDraftFlag == "SUSIN" )
		{
			var pSignSusin = pSusinSN + "sign";
			
			if (Fields[i].substr(0, 5) == pSignSusin)
			{
			  	SignCount = SignCount + 1;
			}
		}
		else
		{
			
			if (Fields[i].substr(0, 4) == "sign")
			{
				SignCount = SignCount + 1;
			}
		} 

		if(pDraftFlag == "SUSIN")    
		{
			var pSignSusin = pSusinSN + "habyuisign";
			if (Fields[i].substr(0, 11) == pSignSusin)
			{
		  		hapyuiCount = hapyuiCount + 1;
			}
		}
		else
		{
			
			if (Fields[i].substr(0,10) == "habyuisign")
			{
				hapyuiCount = hapyuiCount + 1;
			}
		} 
		
	    if (Fields[i].substr(0,9) == "gamsasign")
	    {
			gamsaCount =  gamsaCount + 1;
	    }
		
	  	if (Fields[i].substr(0, 7) == "gongram")
	  	{
	  		gongramCount = gongramCount + 1;
	  	}
		
		if(Fields[i].substr(0,5) == "jikwe")
		{
			if(SignInfoFlag)
			{
				SignInfo = HwpCtrl.GetFieldText(Fields[i]);
				SignInfoFlag = false;
			}
			else
			{
				SignInfo = HwpCtrl.GetFieldText(Fields[i]) + ";" + SignInfo ;
			}
		}
	}
	
	pSuSinFlag = "N";
	if(pDraftFlag != "SUSIN")
	{
		var RtnVal = HwpCtrl.CheckFieldExist("recipient");
		if(RtnVal)
		{
			pSuSinFlag = "Y";
		}else{
			pSuSinFlag = "N";
		}
	}
	
	pSusinNextSN = parseInt(pSusinSN) + 1;
	fieldname = pSusinNextSN + "sign1";
	if (HwpCtrl.CheckFieldExist(fieldname))
		pSuSinFlag = "Y";
	
	pChamJoFlag = "Y";
}

function ReAprLineSingMapping(ret)
{
	var xmlKuljea, chamjo, hapyuiCnt, SignCnt, referCnt,xmlReDraft 
	var OrderType = new Array(); 
	var OrderTypeName = new Array(); 
	var OrderDept = new Array(); 
	var OrderName = new Array(); 
	var OrderStat = new Array(); 
	var OrderStatName = new Array(); 
	var OrderJobtitle = new Array();
	var OrderReason = new Array();  
	var OrderSuggester = new Array(); 
	var OrderReporter = new Array(); 

	if (ret[5] == undefined) {
	    xmlKuljea = ret[0];
	    xmlReDraft = ret[2];
	}
	else {
	    xmlKuljea = ret[1];
	    xmlReDraft = ret[5];
	}
	 
	var xmldom = createXmlDom();
	xmldom = loadXMLString(xmlKuljea);
	var objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
	var findstring;
	var lastno;

	var count = objNodes.length;
	if (HwpCtrl.CheckFieldExist("refer"))
		HwpCtrl.SetFieldText("refer", "");
	
	for(i=1;i < 20;i++) {
		if (HwpCtrl.CheckFieldExist("gongram" + i))
			HwpCtrl.SetFieldText("gongram" + i, "");
	}
	
		
	for(i=0;i < count;i++) {
		var dataNodes = GetChildNodes(objNodes[i]);

        var KyljeaOrder = getNodeText(dataNodes[0]);
        var KyljeaName = getNodeText(dataNodes[1]);
        var KyljeaDeptName = getNodeText(dataNodes[3]);
        var KyljeaTypeName = getNodeText(dataNodes[4]);
        var KyljeaType = getNodeText(dataNodes[16]);
        var KyljeaStat = getNodeText(dataNodes[17]);
        var KyljeaStatName = getNodeText(dataNodes[5]);
        var KyljeaJobtitle = getNodeText(dataNodes[2]);
        var ReasonDoNotApprov = getNodeText(dataNodes[12]);
        var suggester = getNodeText(dataNodes[13]);
        var reporter = getNodeText(dataNodes[14]);	   
	    	
		OrderType[KyljeaOrder] = KyljeaType;
		OrderTypeName[KyljeaOrder] = KyljeaTypeName;
		OrderName[KyljeaOrder] = KyljeaName;
		OrderDept[KyljeaOrder] = KyljeaDeptName;
		OrderStat[KyljeaOrder] = KyljeaStat;      
		OrderStatName[KyljeaOrder] = KyljeaStatName; 
		OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
		OrderReason[KyljeaOrder] = ReasonDoNotApprov;
		OrderReason[KyljeaOrder] = ReasonDoNotApprov;
	   	OrderSuggester[KyljeaOrder] = suggester;
	   	OrderReporter[KyljeaOrder] = reporter;
		lastno = i;
	}
	
	if(pDraftFlag != "SUSIN") {
		
		lastKyulName = OrderName[LastSignSN];
		lastKyuljiwee = OrderJobtitle[LastSignSN];
		
		if (HwpCtrl.CheckFieldExist("lastKyuljikwee"))
			HwpCtrl.SetFieldText("lastKyuljikwee", lastKyuljiwee);

		if (HwpCtrl.CheckFieldExist("lastKyulName"))
			HwpCtrl.SetFieldText("lastKyulName", lastKyulName);
	} else {
		lastKyulName = OrderName[LastSignSN]
		lastKyuljiwee = OrderJobtitle[LastSignSN]
		if (HwpCtrl.CheckFieldExist("slastKyuljikwee"))
			HwpCtrl.SetFieldText("slastKyuljikwee", lastKyulName);

		if (HwpCtrl.CheckFieldExist("slastKyulName"))
			HwpCtrl.SetFieldText("slastKyulName", lastKyulName);
	}
	
	var hapyuiCnt = 1;
	var startIdx = 0;
	
	for(i = 1; i < OrderStat.length;i++)
	{
		if(OrderStat[i] == strAprState1)
		{
			startIdx = startIdx;
			break;
		}
		else
		{
		    if (OrderStat[i] == strAprState2 || OrderStat[i] == strAprState5)
		        startIdx = startIdx + 1;
		    else if (OrderType[i] != strAprType2 && OrderType[i] != strAprType7 && OrderType[i] != strAprType9 & OrderType[i] != strAprType11 && OrderType[i] != strAprType12)
		        startIdx = startIdx + 1;
		    else if (OrderType[i] == strAprType8 ||OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)
		        hapyuiCnt = hapyuiCnt + 1;
		}
	}
	
	var refer = "";
	referCnt = 1;
	for(i=1;i < OrderType.length;i ++)
	{
		if (OrderType[i] == strAprType7)
		{
			if (referCnt == 1)
			{
				refer = "";			
				refer = refer + OrderName[i];
				referCnt = referCnt + 1
			}
			else
				refer = refer + ", "  + OrderName[i];
		}
	}
	if (refer != "")
	{
		fieldname = "refer";
		if (HwpCtrl.CheckFieldExist(fieldname))
			HwpCtrl.SetFieldText(fieldname, refer);
	}	

	
	var susinSN = ""
	if(pDraftFlag == "SUSIN")
	{
		susinSN = pSusinSN 
	}

	
	for(i=startIdx;i < 20;i ++)
	{
		fieldname = susinSN + "jikwe" + i
		if (HwpCtrl.CheckFieldExist(fieldname))
		{
			HwpCtrl.SetFieldText(fieldname, "");
					
			fieldname = susinSN + "sign" + i
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");

			fieldname = susinSN + "seumyungdate" + i
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
		}
		else break;
	}	
	for(i=1;i<20;i++)
	{
		name = susinSN + "habyuisign" + i;
		if (HwpCtrl.CheckFieldExist(name))
		{
			if(trim(HwpCtrl.GetFieldText(name)) == "")
			{
				name = susinSN + "habyui" + i
				if (HwpCtrl.CheckFieldExist(name))
					HwpCtrl.SetFieldText(name, "");
				  			
				name = susinSN + "habyuisign" + i;
				if (HwpCtrl.CheckFieldExist(name))
					HwpCtrl.SetFieldText(name, "");
					  		    
				name = susinSN + "habyuipositon" + i;
				if (HwpCtrl.CheckFieldExist(name))
					HwpCtrl.SetFieldText(name, "");

				name = susinSN + "habyuidate" + i;
				if (HwpCtrl.CheckFieldExist(name))
					HwpCtrl.SetFieldText(name, "");
			}
		}
		else			  	
			break;
	}	
	
	var idx = startIdx;
	var hidx = hapyuiCnt;
		
	var startOrder = 1;
	for (i=1; i<OrderStat.length; i++)
	{
	    if (OrderStat[i] == strAprState2 || OrderStat[i] == strAprState5)
			break;
		else
			startOrder = startOrder + 1;
	}
	
	var chamjocount = 0;
	for(i=startIdx;i < OrderJobtitle.length;i ++)
	{	   
	   if (OrderType[i] == strAprType7)
	   {
		   chamjocount = chamjocount + 1;
	   }
	}
	
	var tempLastSignSN = OrderType.length
    for(i=1;i<OrderType.length;i++)
    {
    	if(OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3 )
    		tempLastSignSN = i;
    }
	
	for(i=startOrder;i < OrderJobtitle.length;i ++)
	{
		if(OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3 )
		{
			var j, chkflag;
	  		if(OrderType[i] == strAprType3)
	  		{
	  			chkflag = false;
	  			for(j=startOrder;j < i;j++)
	  			{
	  				if(OrderType[j] == strAprType4 || OrderType[j] == strAprType16) 
	  				{
	  					 chkflag = true;
	  					 break;   
	  				}
	  			}
	  			
	  			if(!chkflag)
	  			{
	  				fieldname = susinSN + "jikwe" + idx;
					if (HwpCtrl.CheckFieldExist(fieldname))
					{
						HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);
						if(OrderSuggester[i] == "Y")
							HwpCtrl.AppendFieldText(fieldname, strLang75, true);						
						if(OrderReporter[i] == "Y")
							HwpCtrl.AppendFieldText(fieldname, strLang76, true);						
					}
	  				  				
	  				fieldname = susinSN + "sign" + idx;
	  				if (HwpCtrl.CheckFieldExist(fieldname))
	  					HwpCtrl.SetFieldText(fieldname, OrderName[i] + "\15" + OrderReason[i]);
	  				  				
	  				idx = idx + 1;
	  				continue;
	  			}
	  		}
	  		
			fieldname = susinSN + "jikwe" + idx;
			if (HwpCtrl.CheckFieldExist(fieldname))
			{
				HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);
				if(OrderSuggester[i] == "Y")
					HwpCtrl.AppendFieldText(fieldname, strLang75, true);						
				if(OrderReporter[i] == "Y")
					HwpCtrl.AppendFieldText(fieldname, strLang76, true);						
			}
			
			fieldname = susinSN + "sign" + idx;
			if (HwpCtrl.CheckFieldExist(fieldname))
			{
			}
			idx = idx + 1;
		}
		
		if (OrderType[i] == strAprType8 ||OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)		
		{
			fieldname = susinSN + "habyui" + hidx;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, OrderDept[i]);
		
			fieldname = susinSN + "habyuisign" + hidx;
			if (HwpCtrl.CheckFieldExist(fieldname))
			{
			}			

			fieldname = susinSN + "habyuipositon" + hidx;
			if (HwpCtrl.CheckFieldExist(fieldname))
			{
				HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);
				if(OrderSuggester[i] == "Y")
					HwpCtrl.AppendFieldText(fieldname, strLang75, true);						
				if(OrderReporter[i] == "Y")
					HwpCtrl.AppendFieldText(fieldname, strLang76, true);						
			}

			hidx = hidx + 1;
		}			
	}
	setMenuBar("btnJunKyul", false);
}


function openSingUI(parameter)
{
	var result = "";
	// 결재 서명 존재유무 확인
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getSignRequest.do",
		data : {
			userID : pingUserID
		},
		success: function(xml){
			result = xml;
		}
	});

	var SignNodeList = SelectNodes(loadXMLString(result), "LISTVIEWDATA/ROWS/ROW");
  
	// if (SignNodeList.length != 0) { 
		var parameter = pingUserID;
		var url = "/ezApprovalG/aprSign.do";
		var feature	= "status:no;dialogWidth:350px;dialogHeight:310px;help:no;scroll:no;edge:sunken";
		var ret = window.showModalDialog(url,parameter,feature);
	/*
	} else
		var ret = "NAME";
    */
	return ret;
}

function SetAutoPropFinal()
{
  try{
    var CurrentDate;
    CurrentDate = getGyulJeDate();
    
	var FieldLists = HwpCtrl.GetFieldList();
	var Fields = FieldLists.split(";");
  
	for (i = 0 ; i < Fields.length ; i ++)
	{
		if(pDraftFlag == "DRAFT" )
		{
			switch (Fields[i])
			{
	  			case "sentdate" :
	  				HwpCtrl.SetFieldText(Fields[i], CurrentDate);
	  		  		break;
 			}
	  	}
	}  
  }catch(e){	
	alert(e.description);
  }
}

function OpenInformationUI(pInformationContent) {
	var parameter	= pInformationContent;
	var url = "/ezApprovalG/ezAprOpinion.do";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal		= window.showModalDialog(url,parameter,feature);
	return RtnVal;
}

function OpenAlertUI(pAlertContent)
{
	var parameter	= pAlertContent;
	var url = "/ezApprovalG/ezAprAlert.do";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal		= window.showModalDialog(url,parameter,feature);
}

function chk_Passwd(pPwd)
{
	var parameter = pPwd
	var url = "/ezApprovalG/ezchkPasswd.do";
	var feature	= "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret	= window.showModalDialog(url,parameter,feature);
	
	return ret;
}

function getLastOpinon()
{
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getLastOpinonCotent.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}
	});
	
	var content = "";
	if (loadXMLString(result).documentElement.childNodes.length > 0 )
	    content = getNodeText(loadXMLString(result).documentElement.childNodes[0]);		

	if (HwpCtrl.CheckFieldExist("memo"))
		HwpCtrl.SetFieldText("memo", content);
}

function openAaprDocAttachUI()
{
	try{
		var parameter = pDocID;
		var url = "/ezApprovalG/aprCabinetAttach.do";
		var feature	= "status:no;dialogWidth:1050px;dialogHeight:520px;edge:sunken;scroll:no;help:no"; 
		var ret = window.showModalDialog(url,parameter,feature);

		if (ret != "cancel") {
			setAttachInfo(pDocID, "APR", lstAttachLink);
		}
		
		return ret;
	}catch(e){
		alert(e.description);
	}
}

function putSignXML(SignXML)
{
  var retVal = false;
  try {
	var NodeList;
	NodeList = SignXML.selectNodes("SIGNINFOS/SIGNINFO");
	if (NodeList.length > 0) 
	{
		for (i=0; i<NodeList.length; i++)
		{
		    var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
		    var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
		    var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));
			
			if (HwpCtrl.CheckFieldExist(SignName))
			{		
			    retVal = true;	
				if (SignType == "TEXT")
				{
					HwpCtrl.SetFieldText(SignName, SignCont);
				}
				else if (SignType == "HTML")
				{
					HwpCtrl.AppendFieldText(SignName, SignCont, true, true, true);
				}
				else if (SignType == "PROXY")
				{
					HwpCtrl.SetFieldText(SignName, " ");
					HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(SignCont), 3, 0, 0, true, 2);
					HwpCtrl.AppendFieldText(SignName, strLang17, true);
				}
				else if (SignType == "IMAGE")
				{
				    var img = SignCont.split("::");
					HwpCtrl.SetFieldText(SignName, "");
					if(img.length >= 1)
					    HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(img[0]), 3, 0, 0, true, 2);
					    
				    if(img.length >= 2)
				        HwpCtrl.AppendFieldText(SignName, img[1], true);
				}			
			}
		}
	}
  } catch(e) {
	alert("putSignXML : " + e.description);
	return false;
  }
  return retVal;
}

function setPublicFlag()
{
	if (!HwpCtrl.CheckFieldExist("publication"))
		return;
					
	var PublicType = pPublicityCode.substring(0,1);
	var PublicLevel = pPublicityCode.substring(1,9);
	var PublicText = "";

	if (pLimitRange != "")
		PublicText = " (" + pLimitRange + ")";
	
	if (PublicType == "1")
		PublicText = strLang82;
	else if (PublicType == "2")
		PublicText = strLang83 + getPublicLevel(PublicLevel);
	else if (PublicType == "3")
		PublicText = strLang84 + getPublicLevel(PublicLevel);
	else
		PublicText = " ";

	HwpCtrl.SetFieldText("publication", PublicText);
}

function getHistory()
{	
    var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + "hwp";
	centerOpenWindow(URL, 730, 430);
}

function centerOpenWindow(wfileLocation, wWeight, wHeight)
{
	try{
		var heigth = window.screen.availHeight;
		var width = window.screen.availWidth;
		
		var left = (width - wWeight) / 2;
		var top = (heigth - wHeight) / 2;
		
		window.open(wfileLocation, "" ,"toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	
	}catch(e){
		alert("centerOpenWindow :: " + e.description);
	}
}

function setRecevInfo(ret) {
    var precipent = "";
    var precipents = "";
    var recipflag = true;
    var xmldom = new ActiveXObject("Microsoft.XMLDOM");
    xmldom.async = false;
    xmldom = loadXMLString(ret);

    if (xmldom.documentElement.length == 0) return;

    var rows = xmldom.documentElement.childNodes
    if (HwpCtrl.CheckFieldExist("hrecipients"))
        HwpCtrl.SetFieldText("hrecipients", "");

    if (HwpCtrl.CheckFieldExist("recipient"))
        HwpCtrl.SetFieldText("recipient", "");

    if (HwpCtrl.CheckFieldExist("recipients"))
        HwpCtrl.SetFieldText("recipients", "");

    for (var i = rows.length - 1; i >= 0; i--) {
    	var row = rows[i];
        var params = new Array();
        params[0] = "0";

        var dataNodes = GetChildNodes(rows[i], params);
        if (recipflag) {
        	if (getNodeText(dataNodes[3]) == "Y") {
                precipent = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                precipents = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                recipflag = false;
            } else {
            	if (isExtDoc == "Y") {
                    precipent = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                    precipents = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                    recipflag = false;
                } else {
                    precipent = getNodeText(dataNodes[0]);
                    precipents = getNodeText(dataNodes[0]);
                    recipflag = false;
                }
            }
        } else {
        	 precipent = strLang92;

             if (getNodeText(dataNodes[3]) == "Y") {
                 precipents = precipents + "," + getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
             } else {
                 if (isExtDoc == "Y")
                     precipents = precipents + "," + getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
                 else
                     precipents = precipents + "," + getNodeText(dataNodes[0]);
             }
        }
    }
    
    if (HwpCtrl.CheckFieldExist("recipient")) {
        if (precipent == strLang92) {
            HwpCtrl.SetFieldText("recipient", precipent);
            if (HwpCtrl.CheckFieldExist("recipients")) {
                HwpCtrl.SetFieldText("recipients", precipents);
                if (HwpCtrl.CheckFieldExist("hrecipients"))
                    HwpCtrl.SetFieldText("hrecipients", strLang129);
            }
        }
        else {
            HwpCtrl.SetFieldText("recipient", precipent);
            if (precipents == "") {
                if (HwpCtrl.CheckFieldExist("hrecipients"))
                    HwpCtrl.SetFieldText("hrecipients", "");

                if (HwpCtrl.CheckFieldExist("recipients"))
                    HwpCtrl.SetFieldText("recipients", "");
            }
        }
    }
}

/* 2020-02-27 홍승비 - mht 문서 수정이력 비교용 파라미터 추가 (데이터 삽입 시 오류 방지) */
function UpdateDocHistory(pHtml) {
	var xmlhttp2 = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pHtml", pHtml);
	createNodeAndInsertText(xmlpara, objNode, "mode", "hwp");
    createNodeAndInsertText(xmlpara, objNode, "ISBEFOREDOC", "");

    xmlhttp2.open("POST", "/ezApprovalG/uploadDocHistory.do", false);
	xmlhttp2.send(xmlpara);
	
	var URL = xmlhttp2.responseText;
    if (URL.length < 255 && URL != "FALSE") {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pURL", URL);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "ORGCOMPANYID", orgCompanyID);
        createNodeAndInsertText(xmlpara, objNode, "ISBEFOREDOC", "");
        createNodeAndInsertText(xmlpara, objNode, "BEFOREDOCURL", "");
        
        xmlhttp.open("POST", "/ezApprovalG/updateDocHistory.do", false);
        xmlhttp.send(xmlpara);
        if (xmlhttp != null && xmlhttp.readyState == 4) {
         	 if (xmlhttp.status == 200) {
         		
         	 } else {
         		 var pAlertContent = strLang89;
                OpenAlertUI(pAlertContent);
         	 }
       }
   } else {
       var pAlertContent = strLang90;
       OpenAlertUI(pAlertContent);
   }
}

function setPublicFlag2() {
    if (!HwpCtrl.CheckFieldExist("publication")) return;
    var PublicType = pPublicityYN.substring(0, 1);

    if (PublicType == "Y" || PublicType == "B")
        PublicText = strLang82;
    else if (PublicType == "N")
        PublicText = strLang84;
    else
        PublicText = " ";
    
    HwpCtrl.SetFieldText("publication", PublicText);
}

//2020-05-08 : 결재정보/문서정보 저장
function setApprDocInfo(){
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");  
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID); 
    createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", pPublicityYN); 
    createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
    createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
    createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword); 
    createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
    createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
    createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", pPublicityYN);
    createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
    createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);   
    createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);
    createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

    xmlhttp.open("POST", "/ezApprovalG/setApprDocInfo.do", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}

//결재 세부옵션처리
function setFormAprOption(){
    if(formAprOption.indexOf("_a2_"))  //파일첨부
        setMenuBar("btnFileAttach", false);
    if(formAprOption.indexOf("_a3_"))  //문서첨부
        setMenuBar("btnAprDocAttach", false);
}