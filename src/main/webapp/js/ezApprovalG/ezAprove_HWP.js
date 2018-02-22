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
	if (getOpinionCount())
	{
		PositionText = "(" + strLang5;
	}
	
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
				HwpCtrl.SetFieldImage(habyui, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret), 3, 0, 0, true, 2);

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
					HwpCtrl.SetFieldImage(signID, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret), 3, 0, 0, true, 2);
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
					if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase())
					{
						HwpCtrl.SetFieldText(signID, strLang8 + arr_userinfo[2]);	
	  			        content = strLang8 + arr_userinfo[2];						
					}
					else
					{
						HwpCtrl.SetFieldText(signID, arr_userinfo[2]);	
						content = arr_userinfo[2];
					}			
					HwpCtrl.AppendFieldText(signID, strLang7 + OpinionText, true);	
	  				signInfo[signCnt] = signID;
			        SignName[signCnt] = signID;
			        SignType[signCnt] = "TEXT";
			        SignContent[signCnt] = content + strLang7 + OpinionText;
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
					HwpCtrl.SetFieldImage(signID, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret), 3, 0, 0, true, 2);

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

function AprLineSNCount(pAprLineType, objNodes, pTmpAprLineType)
{
	var objNodesLen = objNodes.length;
	var pAprLineSN = 0;
  
	for (i = (objNodesLen - 1); i >= 0; i--)
	{
	    var pCurrentAprState = getNodeText(objNodes.item(i).childNodes(0).childNodes(12));			
	    var pCurrentAprType = getNodeText(objNodes.item(i).childNodes(0).childNodes(11));	

		
		if(pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) 
		{
		    if (pCurrentAprType == strAprType8 || pCurrentAprType == strAprType9 || pCurrentAprType == strAprType11 || pCurrentAprType == strAprType12) {
		        if (getNodeText(objNodes.item(i).childNodes(0).childNodes(4)).toLowerCase() == pUserID.toLowerCase() && (pCurrentAprState == strAprState2 || pCurrentAprState == strAprState5)) {
		            pAprLineSN = pAprLineSN + 1;
		            break;
		        } else {
		            pAprLineSN = pAprLineSN + 1;
		        }
		    }
		}
		else
		{
			if(pCurrentAprType == strAprType18 || pCurrentAprType == strAprType19 || pCurrentAprType == strAprType1 || pCurrentAprType == strAprType16 || pCurrentAprType == strAprType4)
			{
			    if (getNodeText(objNodes.item(i).childNodes(0).childNodes(4)).toLowerCase() == pUserID.toLowerCase() && (pCurrentAprState == strAprState2 || pCurrentAprState == strAprState5 ))
				{
					pAprLineSN = pAprLineSN + 1;    
					break;
				}else{
					pAprLineSN = pAprLineSN + 1;
				}
			}
		}
		
	}   
	return pAprLineSN;
}

function GetAprDocFormID(pDocID)
{
	var pFormID;
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	
	xmlhttp.open("Post", "/myoffice/ezApprovalG/DraftUI/aspx/GetAprDocFormID.aspx", false);
	xmlhttp.send(xmlpara);	
	Resultxml=loadXMLString(xmlhttp.responseText); 
	
	pFormID = getNodeText(Resultxml.childNodes(0));
	return pFormID;
}

function openOpinionUI(ret)
{
	var parameter = new Array();
	parameter[0] = pDocID;    
	parameter[1] = ret;       
	parameter[2] = KuyjeType; 
	parameter[3] = pOrgDocID;
	parameter[5] = window;
	  
	var url = "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion.aspx";
	var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
	var ret = window.showModalDialog(url,parameter,feature);
		
	if(ret != "cancel")
	{
		var Rtnxml = createXmlDom();
		Rtnxml.loadXML(ret);
			  
		var NodeList = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
			  
		if(NodeList.length != 0)
			pHasOpinionYN = "Y";
		else
		{
			pHasOpinionYN = "N";
			ret = "cancel";
		}
		makeOpinionList(Rtnxml);
	}
	return ret;
}


function makeOpinionList(OpinionXML)
{
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
					strOpinion = "[" + strLang717;
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
	var url = "/myoffice/ezApprovalG/ezAPRATTACH/Aprattach.aspx?FormID=" + escape(pFormID);

	var feature	= "status:no;dialogWidth:820px;dialogHeight:350px;edge:sunken;scroll:no"; 
	var ret = window.showModalDialog(url,parameter,feature);

	if(ret != "cancel")
	{
		setAttachInfo(pDocID, "APR", lstAttachLink);
	}
	return ret;
}

function ChangeBtnState()
{
	setMenuBar("btnReject", Btnflag);
	setMenuBar("btnStay", Btnflag);
	setMenuBar("btnApprove", Btnflag);
	setMenuBar("btnEdit", Btnflag);
	setMenuBar("btnModAprLine", Btnflag);
	setMenuBar("btnModAprDept", Btnflag);
	setMenuBar("btnFileAttach", Btnflag);
	setMenuBar("btnOpinion", Btnflag);
	setMenuBar("btnJunKyul", false);
}

function ChangeBtnStateTrue()
{
	try{
		setMenuBar("btnSelDoc", Btnflag);
		setMenuBar("btnReject", Btnflag);

		if(getNodeText(xmldoc.documentElement.childNodes(5)) == "005")
			setMenuBar("btnStay", false);
		else
			setMenuBar("btnStay", Btnflag);

		setMenuBar("btnApprove", Btnflag);
		setMenuBar("btnPrevDoc", Btnflag);
		setMenuBar("btnNextDoc", Btnflag); 
		setMenuBar("btnEdit", Btnflag);
		setMenuBar("btnModAprLine", Btnflag);
		setMenuBar("btnModAprDept", Btnflag);
		setMenuBar("btnFileAttach", Btnflag);
		setMenuBar("btnOpinion", Btnflag);
		setMenuBar("btnPrint", Btnflag);
		setMenuBar("btnJunKyul", false);

		if(pDraftFlag == "CHAMJO")
		{
			setMenuBar("btnApprove", false);
			setMenuBar("btnReject", false);
			setMenuBar("btnStay", false);
			setMenuBar("btnModAprLine", false);
			setMenuBar("btnModAprDept", false);
			setMenuBar("btnFileAttach", false);
		}
	}catch(e){
		alert("ChangeBtnStateTrue  :: " + e.description);
	}
}

function chkBtn(pBtnflag)
{
	setMenuBar("btnApprove", pBtnflag);
	setMenuBar("btnReject", pBtnflag);
	setMenuBar("btnStay", pBtnflag);
	setMenuBar("btnDocInfo", pBtnflag);
	setMenuBar("btnJunKyul", false);
	setMenuBar("btnModAprLine", pBtnflag);
	setMenuBar("btnModAprDept", false);
	setMenuBar("btnMail", pBtnflag);	
	setMenuBar("btnOpinion", pBtnflag);
	setMenuBar("btnFileAttach", pBtnflag);
	setMenuBar("btnAprDocAttach", pBtnflag);
	setMenuBar("btnPrint", pBtnflag);
	setMenuBar("btnSave", pBtnflag);
	setMenuBar("btnSetTaskCode", pBtnflag);
	setMenuBar("btnAddSepAttach", pBtnflag);
	setMenuBar("btnhistory", pBtnflag);
	setMenuBar("btntotaldocinfo", pBtnflag);

	if(trim(pDraftFlag) == "GONGRAM" || trim(pDraftFlag) == "CHAMJO")
	{
		setMenuBar("btnReject", false);
		setMenuBar("btnStay", false);
	}
	else
	{
		setMenuBar("btnReject", pBtnflag);

		if(getNodeText(xmldoc.documentElement.childNodes(5)) == "005")
			setMenuBar("btnStay", false);
		else
			setMenuBar("btnStay", pBtnflag);
	}
}

function chkBtnConfirm(para)
{
	if(para == "1")
	{
		if(btnApprove.style.display == "")
			bbtnApprove = "1";
			
		if(btnReject.style.display == "")
			bbtnReject = "1";
			
		if(btnStay.style.display == "")
			bbtnStay = "1";
			
		if(btnJunKyul.style.display == "")
			bbtnJunKyul = "1";
			
		if(btnModAprLine.style.display == "")
			bbtnModAprLine = "1";
			
		if(btnEdit.style.display == "")
			bbtnEdit = "1";
			
		if(btnOpinion.style.display == "")
			bbtnOpinion = "1";
			
		if(btnFileAttach.style.display == "")
			bbtnFileAttach = "1";
			
		if(btnAprDocAttach.style.display == "")
			bbtnAprDocAttach = "1";
			
		if(btnPrint.style.display == "")
			bbtnPrint = "1";
			
		if(btnSave.style.display == "")
			bbtnSave = "1";
		
		if(btnMail.style.display == "")
			bbtnMail = "1";
			
		if(btnSetTaskCode.style.display == "")
			bbtnSetTaskCode = "1";
			
		if(btnAddSepAttach.style.display == "")
			bbtnAddSepAttach = "1";
		
		if(btnhistory.style.display == "")
			bbtnhistory = "1";

		if(btnDocInfo.style.display == "")
			bbtnDocInfo = "1";

		if(btnModAprDept.style.display == "")
		    bbtnModAprDept = "1";

		if (btntotaldocinfo.style.display == "")
		    bbtntotaldocinfo = "1";
	}
	else
	{
		if(bbtnApprove == "1")
			setMenuBar("btnApprove", true);
			
		if(bbtnReject == "1")
			setMenuBar("btnReject", true);
			
		if(bbtnStay == "1")
			setMenuBar("btnStay", true);
			
		if(bbtnModAprLine == "1")
			setMenuBar("btnModAprLine", true);
			
		if(bbtnEdit == "1")
			setMenuBar("btnEdit", true);
			
		if(bbtnOpinion == "1")
			setMenuBar("btnOpinion", true);
			
		if(bbtnFileAttach == "1")
			setMenuBar("btnFileAttach", true);
			
		if(bbtnAprDocAttach == "1")
			setMenuBar("btnAprDocAttach", true);
			
		if(bbtnPrint == "1")
			setMenuBar("btnPrint", true);
			
		if(bbtnSave == "1")
			setMenuBar("btnSave", true);
			
		if(bbtnMail == "1")
			setMenuBar("btnMail", true);
			
		if(bbtnSetTaskCode == "1")
			setMenuBar("btnSetTaskCode", true);
			
		if(bbtnAddSepAttach == "1")
			setMenuBar("btnAddSepAttach", true);
			
		if(bbtnhistory == "1")
			setMenuBar("btnhistory", true);

		if(bbtnModAprDept == "1")
			setMenuBar("btnModAprDept", true);		
			
		if(bbtnDocInfo == "1")
		    setMenuBar("btnDocInfo", true);

		if (bbtntotaldocinfo == "1")
		    setMenuBar("btntotaldocinfo", true);
	}
}

function getDocInfo()
{
  try{
	xmldoc = DOCINFO.dataSource;
	if(getNodeText(xmldoc.documentElement.childNodes(5)) == "005")
		setMenuBar("btnStay", false);

	pHasOpinionYN = getNodeText(xmldoc.getElementsByTagName("HASOPINIONYN").item(0));
	var objNodes = xmldoc.documentElement.childNodes;
	if(objNodes)
	{
		tempSecurity = getNodeText(objNodes(19));
		tempKeep = getNodeText(objNodes(20));
		tempUrgent = getNodeText(objNodes(21));
		tempPublic = getNodeText(objNodes(18));
		tempKeyword = getNodeText(objNodes(25));
		tempItemCode = getNodeText(objNodes(23));
		tempItemName = getNodeText(objNodes(24));		
		pSummery = getNodeText(objNodes(35));
		pSpecialRecordCode = getNodeText(objNodes(26));
		pPublicityCode = getNodeText(objNodes(27));
		pLimitRange = getNodeText(objNodes(28));
		pPageNum = getNodeText(objNodes(29));				
		cabinetID = getNodeText(objNodes(30));
		TaskCode = getNodeText(objNodes(31));
		tempSecurityDate = getNodeText(objNodes(36));
	}
  }catch(e){
	alert("getDocInfo :: " + e.description);
  }  
}

function getApprovInfo()
{
	try{
		pOrgAprUserID	  = OrgAprUserID;
		pOrgAprUserName  = OrgAprUserName;
		pOrgAprUserName2  = OrgAprUserName2;
		pOrgAprUserDeptID = OrgAprUserDeptID;
		
		var xmlhttp = createXMLHttpRequest();
		var xmlpara = createXmlDom();
		var pdocXML;
		
		var objRoot = xmlpara.createElement("PARAMETER");
		xmlpara.appendChild(objRoot);
		
		var objNode = xmlpara.createElement("DocID");
		setNodeText(objNode , pDocID);
		objRoot.appendChild(objNode);
		
		objNode = xmlpara.createElement("UserID");
		setNodeText(objNode , pUserID);
		objRoot.appendChild(objNode);
		
		objNode = xmlpara.createElement("DEPTID");
		setNodeText(objNode , OrgAprUserDeptID);
		objRoot.appendChild(objNode);
		
		xmlhttp.open("POST", "/myoffice/ezApprovalG/ApprovUI/aspx/getApproveDocInfo.aspx", false);
		xmlhttp.send(xmlpara);
		
		xmlpara = createXmlDom();
		pdocXML = loadXMLString(xmlhttp.responseText).getElementsByTagName("DOCINFO");
		xmlpara.loadXML(pdocXML.item(0).childNodes(0).xml);
		DOCINFO.dataSource = xmlpara;
		
		pFormID = getNodeText(xmlpara.getElementsByTagName("FORMID").item(0));
		pOrgDocID = getNodeText(xmlpara.getElementsByTagName("ORGDOCID").item(0));
		
		xmlpara = createXmlDom();
		pdocXML = loadXMLString(xmlhttp.responseText).getElementsByTagName("ATTACHINFO");
		xmlpara.loadXML(pdocXML.item(0).childNodes(0).xml);
		ATTACHINFO.dataSource = xmlpara;
	
		xmlpara = createXmlDom();
		pdocXML = loadXMLString(xmlhttp.responseText).getElementsByTagName("APRLINEINFO");
		xmlpara.loadXML(pdocXML.item(0).childNodes(0).xml);
		APRLINEINFO.dataSource = xmlpara;
		
		var lastIdx = xmlpara.getElementsByTagName("DATA6").length
		drafterDeptid = getNodeText(xmlpara.getElementsByTagName("DATA6").item(lastIdx - 1))
		
		xmlpara = createXmlDom();
		pdocXML = loadXMLString(xmlhttp.responseText).getElementsByTagName("DOCFLAGINFO");
		xmlpara.loadXML(pdocXML.item(0).xml);
		
		pDocHref = getNodeText(xmlpara.getElementsByTagName("DocHref").item(0));
		pDraftFlag = getNodeText(xmlpara.getElementsByTagName("DocFlag").item(0));
		
		var doctitle = getNodeText(loadXMLString(xmlhttp.responseText).getElementsByTagName("DOCTITLE").item(0))
		switch (trim(pDraftFlag))
		{
		 	case "DRAFT":
		 	    pDocType = getNodeText(xmlpara.getElementsByTagName("DocFlagValue").item(0));
		   	    break;
		   	    
		 	case "GONGRAM":
		 	    pOrgDocID = getNodeText(xmlpara.getElementsByTagName("DocFlagValue").item(0));
				setNodeText(btnApprove , strLang10);
				setMenuBar("btnJunKyul", false);
		   	    break;
			   	
		    case "CHAMJO":
		        pOrgDocID = getNodeText(xmlpara.getElementsByTagName("DocFlagValue").item(0));
				setNodeText(btnApprove , strLang10);
				setMenuBar("btnJunKyul", false);
				setMenuBar("btnReject", false);			
				setMenuBar("btnStay", false);			
				setMenuBar("btnOpinion", false);
				setMenuBar("btnFileAttach", false);			
				setMenuBar("btnAprDocAttach", false);
				setMenuBar("btnEdit", false);			
		   	    break;
			
			case "HABYUI":
				setMenuBar("btnEdit", false);
				setMenuBar("btnModAprDept", false);
				setMenuBar("btnFileAttach", false);
				setMenuBar("btnAprDocAttach", false);
		   	    break;
			
		   	case "SUSIN":
		   	    pOrgDocID = getNodeText(xmlpara.getElementsByTagName("DocFlagValue").item(0));
		   	    break;
		   	    
		   	case "GAMSA":
		   		setMenuBar("btnApprove", true);
				setMenuBar("btnReject", false);
				setMenuBar("btnStay", false);
				setMenuBar("btnJunKyul", false);
				setMenuBar("btnModAprLine", false);
				setMenuBar("btnModAprDept", false);
				setMenuBar("btnAprDocAttach", false);
				setMenuBar("btnEdit", false);
				setMenuBar("btnFileAttach", false);
				break;
				
		   	case "B_GAMSA":
		   		setMenuBar("btnApprove", true);
				setMenuBar("btnReject", false);
				setMenuBar("btnStay", false);
				setMenuBar("btnJunKyul", false);
				setMenuBar("btnModAprLine", false);
				setMenuBar("btnModAprDept", false);
				setMenuBar("btnAprDocAttach", false);
				setMenuBar("btnEdit", false);
				setMenuBar("btnFileAttach", false);
				break;
		   	
		}
		pOrgAttach = "";
				
	}catch(e){
		alert("getApprovInfo :: " + e.description);
	}   	    
}

function openwindow(wfileLocation , wName , wWeigth , wHeigth)
{
	try{
		var heigth = window.screen.availHeight;
		var width = window.screen.availWidth;
		
		var left = 0;
		var top = 0;
			
		if(window.screen.width > 800)
		{
			var pleftpos;
			pleftpos = parseInt(width) - 725;
			heigth = parseInt(heigth) - 30;
			width = parseInt(width) - pleftpos;
			left = pleftpos / 2;
		}else{
			heigth = parseInt(heigth) - 30;
			width = parseInt(width) - 10;
		}
		
		var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left
				
		window.open(wfileLocation,"view",param);
	}catch(e){
		alert("openwindow :: " + e.description);
	}
}

function getCurApproverAprLine()
{
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pUserID", "");
	createNodeAndInsertText(xmlpara, objNode, "pFormID", "");
	xmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/AprLineRequest.aspx", false);
	xmlhttp.send(xmlpara);
		 
	Resultxml = loadXMLString(xmlhttp.responseText);
		 
	var objNodes = Resultxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
	LastKyulSN = getLastSignSN(objNodes)
	LastSignSN = objNodes.length
  
	for (var i=0; i<objNodes.length; i++)
	{
	    var pCurrentAprState = getNodeText(objNodes.item(i).childNodes(0).childNodes(12));  
	    if ((getNodeText(objNodes.item(i).childNodes(0).childNodes(4)).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5)))
		{
	        pAprLineType =  getNodeText(objNodes.item(i).childNodes(0).childNodes(11)); 
				
	    	if(i < 1)
	    		pAprLineB4type = "";
	    	else
	    	    pAprLineB4type = getNodeText(objNodes.item(i - 1).childNodes(0).childNodes(11));
		  	  
			if(pAprLineType == strAprType4 || pAprLineType == strAprType16)    
				var pTmpAprLineType = strAprType1;
		  	     
			pAprMemberSN = AprLineSNCount(pAprLineType, objNodes, pTmpAprLineType);
			break;
		}
	}
   
	if(LastKyulSN == pAprMemberSN || pAprLineType == strLang10)
		setMenuBar("btnJunKyul", false);
		
}

function SaveApproveInfo(pApproveFlag)
{
	if (SaveFile() != "TRUE")
		return "FALSE";
	
	SignSave();
	var objNodes = xmldoc.documentElement.childNodes;
	
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", getNodeText(objNodes(0)));
	createNodeAndInsertText(xmlpara, objNode, "FormID", getNodeText(objNodes(1)));
	createNodeAndInsertText(xmlpara, objNode, "OrgDocID", getNodeText(objNodes(2)));
	createNodeAndInsertText(xmlpara, objNode, "DocType", getNodeText(objNodes(3)));
	createNodeAndInsertText(xmlpara, objNode, "DocState", getNodeText(objNodes(4)));
	createNodeAndInsertText(xmlpara, objNode, "FunctionType", "002");
	createNodeAndInsertText(xmlpara, objNode, "Href", getNodeText(objNodes(6)));

	pDocTitle = HwpCtrl.GetFieldText("doctitle");
	createNodeAndInsertText(xmlpara, objNode, "DocTitle", pDocTitle);

	if (HwpCtrl.CheckFieldExist("docnumber"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", HwpCtrl.GetFieldText("docnumber"));
	else if (HwpCtrl.CheckFieldExist("be_docnumber"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", HwpCtrl.GetFieldText("be_docnumber"));
	else if (HwpCtrl.CheckFieldExist("deptshortedname"))
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", HwpCtrl.GetFieldText("deptshortedname"));
	else
	    createNodeAndInsertText(xmlpara, objNode, "DocNo", "");

	if (pHasAttachYN == "")
	    createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", getNodeText(objNodes(9)));
	else
	    createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);

	var objNode;

	if (pHasOpinionYN == "")
	    createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", getNodeText(objNodes(10)));
	else
	    createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", pHasOpinionYN);


	createNodeAndInsertText(xmlpara, objNode, "StartDate", "");
	createNodeAndInsertText(xmlpara, objNode, "EndDate", "");
	createNodeAndInsertText(xmlpara, objNode, "WriterID", getNodeText(objNodes(13)));
	createNodeAndInsertText(xmlpara, objNode, "WriterName", getNodeText(objNodes(14)));
	createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", getNodeText(objNodes(15)));
	createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", getNodeText(objNodes(16)));
	createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", getNodeText(objNodes(17)));
	createNodeAndInsertText(xmlpara, objNode, "Html", "");
	createNodeAndInsertText(xmlpara, objNode, "pUserID", pOrgAprUserID);
	createNodeAndInsertText(xmlpara, objNode, "pUserName", pOrgAprUserName);
	createNodeAndInsertText(xmlpara, objNode, "pDeptID", pOrgAprUserDeptID);
	createNodeAndInsertText(xmlpara, objNode, "OrgHtml", "");

	createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "proxyuserid", pingUserID);

	createNodeAndInsertText(xmlpara, objNode, "ItemCode", tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ItemName", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "UrgentApproval", tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KeyWord", tempKeyword);

	createNodeAndInsertText(xmlpara, objNode, "Xdocid", "");
	createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
	createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
	createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml");
	if (!g_SepAttachLVXml)
	    createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", "");
	else
	    createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", GetSepAttParamXml(g_SepAttachLVXml));


	createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);

	createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", getNodeText(xmldoc.getElementsByTagName("WRITERNAME2").item(0)));
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", getNodeText(xmldoc.getElementsByTagName("WRITERJOBTITLE2").item(0)));
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", getNodeText(xmldoc.getElementsByTagName("WRITERDEPTNAME2").item(0)));

	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", pOrgAprUserName2);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	if(pApproveFlag == "1")
	{
	    xmlhttp.open("POST", "/myoffice/ezApprovalG/ApprovUI/aspx/doapprov.aspx", false);
	}else if(pApproveFlag == "2"){
	    xmlhttp.open("POST", "/myoffice/ezApprovalG/ApprovUI/aspx/dobansongapprov.aspx", false);
	}else if(pApproveFlag == "3"){
	    xmlhttp.open("POST", "/myoffice/ezApprovalG/ApprovUI/aspx/doboryuapprov.aspx", false);
	}
	xmlhttp.send(xmlpara);
	if (getNodeText(loadXMLString(xmlhttp.responseText)) != "TRUE")
	{
		SaveOrgFile();
	}
	return getNodeText(loadXMLString(xmlhttp.responseText));
}

function SaveFile()
{

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));
		
	xmlhttp.open("POST","aspx/SaveFileHWP.aspx",false);
	xmlhttp.send(xmlpara);
		
	return xmlhttp.responseText;
}

function SaveOrgFile()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "Html", OrgHtml);

		
	xmlhttp.open("POST","aspx/SaveFileHWP.aspx",false);
	xmlhttp.send(xmlpara);
		
	return xmlhttp.responseText;
}


function openAprLineUI()
{
	var pChangeAprLineparameter = new Array();
	var pFormID
	
	pFormID = GetAprDocFormID(pDocID);
	
	
	CheckDocCellInfo();
	
	pChangeAprLineparameter[0] = pDocID;         
	pChangeAprLineparameter[1] = pFormID;        
	pChangeAprLineparameter[2] = SignCount;      
	pChangeAprLineparameter[3] = SignInfo;       
	pChangeAprLineparameter[4] = hapyuiCount;
	pChangeAprLineparameter[5] = pDraftFlag;
	pChangeAprLineparameter[6] = pSuSinFlag;
	pChangeAprLineparameter[7] = pChamJoFlag;
	pChangeAprLineparameter[8] = gongramCount;   
	pChangeAprLineparameter[9] = true;          
	pChangeAprLineparameter[10] = pDocType;
	pChangeAprLineparameter[11] = gamsaCount;	 
	pChangeAprLineparameter[12] = "";
	pChangeAprLineparameter[13] = pOrgAprUserID;
	pChangeAprLineparameter[14] = aprlineinfoTMP;
	
	var URL = "/myoffice/ezApprovalG/ezAPRLINE/aprline.aspx";
	var parameter = "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";
	var ret = window.showModalDialog(URL,pChangeAprLineparameter,parameter);
	
	return ret;
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
	xmldom.loadXML(xmlKuljea);
	var objNodes = xmldom.selectNodes("LISTVIEWDATA/ROWS/ROW");
	var findstring;
	var lastno;

	var count = objNodes.length;
	if (HwpCtrl.CheckFieldExist("refer"))
		HwpCtrl.SetFieldText("refer", "");
	
	for(i=1;i < 20;i++)
	{
		if (HwpCtrl.CheckFieldExist("gongram" + i))
			HwpCtrl.SetFieldText("gongram" + i, "");
	}
	
		
	for(i=0;i < count;i++)
	{
		var KyljeaOrder = getNodeText(objNodes.item(i).childNodes(0))
		var KyljeaName = getNodeText(objNodes.item(i).childNodes(1))
		var KyljeaDeptName = getNodeText(objNodes.item(i).childNodes(3))
		var KyljeaTypeName  = getNodeText(objNodes.item(i).childNodes(4)) 
		var KyljeaType  = getNodeText(objNodes.item(i).childNodes(16));
		var KyljeaStat = getNodeText(objNodes.item(i).childNodes(17)); 
		var KyljeaStatName = getNodeText(objNodes.item(i).childNodes(5))
		var KyljeaJobtitle = getNodeText(objNodes.item(i).childNodes(2)) 
		var ReasonDoNotApprov = getNodeText(objNodes.item(i).childNodes(12)); 
	   	var suggester = getNodeText(objNodes.item(i).childNodes(13));      
	   	var reporter = getNodeText(objNodes.item(i).childNodes(14));	   
	    	
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
	
	if(pDraftFlag != "SUSIN")
	{
		
		lastKyulName = OrderName[LastSignSN];
		lastKyuljiwee = OrderJobtitle[LastSignSN];
		
		if (HwpCtrl.CheckFieldExist("lastKyuljikwee"))
			HwpCtrl.SetFieldText("lastKyuljikwee", lastKyuljiwee);

		if (HwpCtrl.CheckFieldExist("lastKyulName"))
			HwpCtrl.SetFieldText("lastKyulName", lastKyulName);
	}
	else
	{
		
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
		    else if (OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)
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
			if(trim(HwpCtrl.GetFieldText(name)) != "")
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
		
		if (OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)		
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
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pUserID", pingUserID);

  
	xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/GetSignRequest.aspx", false);
	xmlhttp.send(xmlpara);
	
	Resultxml=loadXMLString(xmlhttp.responseText);
	
	var SignNodeList = Resultxml.selectNodes("LISTVIEWDATA/ROWS/ROW"); 
  
	if(SignNodeList.length != 0)
	{ 
		var parameter = pingUserID;
		var url = "/myoffice/ezApprovalG/ezAPRSIGN/AprSign1_Cross.aspx";
		var feature	= "status:no;dialogWidth:350px;dialogHeight:310px;help:no;scroll:no;edge:sunken";
		var ret = window.showModalDialog(url,parameter,feature);
	}
	else
		var ret = "NAME";
    
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

function getGyulJeDate()
{
	var GyulJeDate;
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "getDate", "");

	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetDate.aspx", false);
	xmlhttp.send(xmlpara);
	GyulJeDate = xmlhttp.responseText;
	
	return GyulJeDate;
}

function trim(parm_str) {
	return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
	str_temp = parm_str ;
	while (str_temp.length != 0) {
	if (str_temp.substring(0, 1) == " ") {
		str_temp = str_temp.substring(1, str_temp.length) ;
	} else {
		return str_temp ;
	}
}
return str_temp ;
}

function rtrim(parm_str) {
	str_temp = parm_str ;
	while (str_temp.length != 0) {
		int_last_blnk_pos = str_temp.lastIndexOf(" ");
		if ((str_temp.length - 1) == int_last_blnk_pos) {
			str_temp = str_temp.substring(0, str_temp.length - 1);
		} else {
			return str_temp;
		}
	}
	return str_temp;
}

function getSusinSNInfo()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/ApprovUI/aspx/getSusinSN.aspx", false);
	xmlhttp.send(xmlpara);
	
	if(loadXMLString(xmlhttp.responseText).xml != "")
	    pSusinSN = getNodeText(loadXMLString(xmlhttp.responseText).childNodes(0));
}

function setBtnDisableAprLineType()
{
	if(pDraftFlag == "SUSIN" || pAprLineType == strAprType7 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12)
	{
		setMenuBar("btnReject", false);
		setMenuBar("btnStay", false);
		setMenuBar("btnModAprLine", false);
		setMenuBar("btnModAprDept", false);
	}
}

function getLastSignSN(pNodes)
{
	var i; 
	var aprlineSN;
	var lastaprlineSN;
	var junkyulflag = false;
	
	aprlineSN = pNodes.length;
	lastaprlineSN = 0;
	for(i = aprlineSN - 1;i >= 0;i--)
	{
	    var pCurrentAprType = getNodeText(pNodes(i).childNodes(0).childNodes(11));
		if(pCurrentAprType == strAprType18 || pCurrentAprType == strAprType19 || pCurrentAprType == strAprType1 || pCurrentAprType == strAprType4 || pCurrentAprType == strAprType16 || pCurrentAprType == strAprType3)
		{
			if(pCurrentAprType == strAprType4) junkyulflag = true;			
			
			switch (pCurrentAprType)
			{
				case strAprType1:
		   			lastaprlineSN = lastaprlineSN + 1;
		   			break;

				case strAprType18:
		   			lastaprlineSN = lastaprlineSN + 1;
		   			break;

				case strAprType19:
		   			lastaprlineSN = lastaprlineSN + 1;
		   			break;
		   		
		   		case strAprType13:
		   			lastaprlineSN = lastaprlineSN + 1;
		   			break;
		   		
		   		case strAprType4:
					lastaprlineSN = lastaprlineSN + 1;
		   			break;

		   		case strAprType16:      
					lastaprlineSN = lastaprlineSN + 1;
		   			break;
		   	
		   		case strAprType3:
		   			lastaprlineSN = lastaprlineSN + 1;
		   			break;
			}			   		
		}		
	}
	return lastaprlineSN
}

function upDateAprLine()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pUserID", pingUserID);

	  
	xmlhttp.open("POST", "/myoffice/ezApprovalG/ApprovUI/aspx/upDateJunKyul.aspx", false);
	xmlhttp.send(xmlpara);
	
	return xmlhttp.responseText
}

function OpenInformationUI(pInformationContent)
{
	var parameter	= pInformationContent;
	var url = "/myoffice/ezApprovalG/ezAPROPINION.aspx";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal		= window.showModalDialog(url,parameter,feature);
	return RtnVal;
}

function OpenAlertUI(pAlertContent)
{
	var parameter	= pAlertContent;
	var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal		= window.showModalDialog(url,parameter,feature);
}

function chk_Passwd(pPwd)
{
	var parameter = pPwd
	var url = "/myoffice/ezApprovalG/ezchkPasswd.aspx";
	var feature	= "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret	= window.showModalDialog(url,parameter,feature);
	
	return ret;
}

function getLastOpinon()
{
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	
	xmlhttp.open("Post", "/myoffice/ezApprovalG/ReceivUI/aspx/getLastOpinonCotent.aspx", false);
	xmlhttp.send(xmlpara);	
	
	if (loadXMLString(xmlhttp.responseText).documentElement.childNodes.length > 0 )
	    var content = getNodeText(loadXMLString(xmlhttp.responseText).documentElement.childNodes(0));		

	if (HwpCtrl.CheckFieldExist("memo"))
		HwpCtrl.SetFieldText("memo", content);
}


function setMenuBar(id,flag)
{
	var strCmd, display_Value;
		
	if(flag) 
		display_Value = "";
	else
		display_Value = "none";
	
	strCmd = id + ".style.display='" + display_Value + "'";
	eval(strCmd); 
}


function setMenuDisable(id,flag)
{
	if(flag)
		eval(id).disabled = true;
	else
		eval(id).disabled = false;
}


function openAaprDocAttachUI()
{
	try{
		var parameter = pDocID;
		var url = "/myoffice/ezApprovalG/ezAprDocAttach/aprCabinetAttach.aspx";
		var feature	= "status:no;dialogWidth:800px;dialogHeight:370px;edge:sunken;scroll:no;help:no"; 
		var ret = window.showModalDialog(url,parameter,feature);

		if(ret != "cancel")
		{
			setAttachInfo(pDocID, "APR", lstAttachLink);
		}
		return ret;
	}catch(e){
		alert(e.description);
	}
}

function SignSave()
{
	if (SignContent.length > 0)
	{
		var xmlhttp = createXMLHttpRequest();
		var xmlpara = createXmlDom();
		var objRoot, objNode, subNode;
		objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

		for (i = 0; i < SignContent.length; i++) {
		    objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "SIGNINFO");
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", pDocID);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNTYPE", SignType[i]);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNNAME", SignName[i]);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "CONTENT", SignContent[i]);
		}
		xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/setSignInfo.aspx", false);
		xmlhttp.send(xmlpara);
	}
}

function SignCheck()
{
	var SignXML = createXmlDom();
	
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
  
	xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/getSignInfo.aspx", false);
	xmlhttp.send(xmlpara);
	
	if (loadXMLString(xmlhttp.responseText).xml == "") 
		return;
	
	var NodeList;
	NodeList = loadXMLString(xmlhttp.responseText).selectNodes("SIGNINFOS/SIGNINFO");
	if (NodeList.length <= 0) 
		return;
	
	SignXML = loadXMLString(xmlhttp.responseText);
	var rtnVal = putSignXML(SignXML);
	if (rtnVal)	
	{
		SaveFile();
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
					HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SignCont), 3, 0, 0, true, 2);
					HwpCtrl.AppendFieldText(SignName, strLang17, true);
				}
				else if (SignType == "IMAGE")
				{
				    var img = SignCont.split("::");
					HwpCtrl.SetFieldText(SignName, "");
					if(img.length >= 1)
					    HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(img[0]), 3, 0, 0, true, 2);
					    
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


function openDocExinfo()
{
	var parameter = new Array();
    parameter[0]  = tempSecurity;
    parameter[1]  = tempUrgent;
    parameter[2]  = pSummery;
    parameter[3]  = pSpecialRecordCode;
	parameter[4]  = pPublicityCode;
    parameter[5]  = pLimitRange;
    parameter[6]  = pPageNum;
	parameter[7]  = tempSecurityDate;

	var url = "/myoffice/ezApprovalG/ezDocInfo/ezDocInfoG.aspx";
	var feature = "status:no;dialogWidth:420px;dialogHeight:605px;help:no;scroll:no;edge:sunken;";	 
	var RtnVal = window.showModalDialog(url,parameter,feature);
	
	tempSecurity = RtnVal[0];
	tempUrgent = RtnVal[1];
	pSummery = RtnVal[2];
	pSpecialRecordCode = RtnVal[3];
	pPublicityCode = RtnVal[4];
	pLimitRange = RtnVal[5];
	pPageNum = RtnVal[6];
	tempSecurityDate = RtnVal[7];
	
	setPublicFlag();	
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

function getPublicLevel(PublicLevel)
{
	var strRtn = "";
	var firstFlag = true;
	for (i=0; i<8; i++)
	{
		if (PublicLevel.substring(i, i+1) == "Y")
		{
			if (firstFlag)
			{
				strRtn = "(" + (i+1);
				firstFlag = false;
			}
			else
			{
				strRtn = strRtn + "," + (i+1);
			}			
		}
	}
	if (!firstFlag)
		strRtn = strRtn + ")";
	return strRtn;
}


function getSignDate()
{
	var GyulJeDate;
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "getDate", "");

	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetSignDate.aspx", false);
	xmlhttp.send(xmlpara);
	GyulJeDate = xmlhttp.responseText;
	return GyulJeDate;
}

function getHistory()
{	
    var URL = "/myoffice/ezApprovalG/ezAPRHISTORY/ezAPRHISTORY_Cross.aspx?DocID=" + pDocID;
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

function UpdateDocHistory(pHtml)
{
	var xmlhttp2 = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pHtml", pHtml);

	xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezAPRHISTORY/aspx/UploadDocHistoryHWP.aspx", false);
	xmlhttp2.send(xmlpara);
	
	var URL = xmlhttp2.responseText;
	if (URL.length < 255 && URL != "FALSE")
	{
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

		xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPRHISTORY/aspx/UpdateDocHistory.aspx", false);
		xmlhttp.send(xmlpara);
		if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE")
		{
		}
		else
		{
			var pAlertContent = strLang718;
      		OpenAlertUI(pAlertContent);
		}
	}
	else
	{
		var pAlertContent = strLang719;
		OpenAlertUI(pAlertContent);
	}
}


function UpdateLineHistory()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
	createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
	createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
	createNodeAndInsertText(xmlpara, objNode, "chkFlag", "CHECK");
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[14]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", arr_userinfo[16]);
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPRHISTORY/aspx/UpdateLineHistory.aspx", false);
	xmlhttp.send(xmlpara);
	
	if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE")
	{
	}
	else
	{
		var pAlertContent = strLang720;
    	OpenAlertUI(pAlertContent);
	}	
}


function getOpinionCount()
{
  try {
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "chkFlag", "ING");
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPROPINION/aspx/GetOpinionCount.aspx", false);
	xmlhttp.send(xmlpara);
	
	var tempValue = parseInt(getNodeText(loadXMLString(xmlhttp.responseText)))	
	if (tempValue > 0)
	{
		return true;
	}
	else
	{
		return false;
	}
  } catch(e) {
	return false;
  }
}

function setRecevInfo(ret) {
    var precipent = "";
    var precipents = "";
    var recipflag = true;
    var xmldom = createXmlDom();
    xmldom.async = false;
    xmldom.loadXML(ret)

    if (xmldom.documentElement.length == 0) return;

    var rows = xmldom.documentElement.childNodes
    if (HwpCtrl.CheckFieldExist("hrecipients"))
        HwpCtrl.SetFieldText("hrecipients", "");

    if (HwpCtrl.CheckFieldExist("recipient"))
        HwpCtrl.SetFieldText("recipient", "");

    if (HwpCtrl.CheckFieldExist("recipients"))
        HwpCtrl.SetFieldText("recipients", "");

    for (var i = rows.length - 1; i >= 0; i--) {
        var row = rows(i);
        if (recipflag) {
            if (getNodeText(rows(i).childNodes(3)) == "Y") {
                precipent = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
                precipents = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
                recipflag = false;
            }
            else {
                if (isExtDoc == "Y") {
                    precipent = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
                    precipents = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
                    recipflag = false;
                }
                else {
                    precipent = getNodeText(rows(i).childNodes(0))
                    precipents = getNodeText(rows(i).childNodes(0))
                    recipflag = false;
                }
            }

        }
        else {
            precipent = strLang92;

            if (getNodeText(rows(i).childNodes(3)) == "Y")
                precipents = precipents + "," + getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
            else {
                if (isExtDoc == "Y")
                    precipents = precipents + "," + getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0));
                else
                    precipents = precipents + "," + getNodeText(rows(i).childNodes(0));
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

function openReceivUI()
{
	var parameter	= new Array();
	isExtDoc = GetDocumentElement(HwpCtrl, "EXTDOC");
	if(isExtDoc != "Y")	isExtDoc = "N"
	
	parameter[0]	= pFormID;
	parameter[1]	= pDocID;
	parameter[2]    = "SEND"
	parameter[3]	= isExtDoc;
	
	parameter[4] = pDocType;
		
	var url = "/myoffice/ezApprovalG/ezAPRDEPT/AprDept1.aspx";
	var feature	= "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
  	var ret = window.showModalDialog(url,parameter,feature);
	return ret;
}

function SendAckForExch(pType, pMode)
{
  try {
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pType", pType);
    createNodeAndInsertText(xmlpara, objNode, "pMode", pMode);
    var field = pzFormProc.fields("body");
    if (field) {
        createNodeAndInsertText(xmlpara, objNode, "pBody", field.value);
    }
    else {
        createNodeAndInsertText(xmlpara, objNode, "pBody", "");
    }
    createNodeAndInsertText(xmlpara, objNode, "pUserID", "");
  
    xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRRECEIVE/aspx/sendAckforExch.aspx", false);
    xmlhttp.send(xmlpara);
  } catch(e) {}
}


var NextDocID = "";
var NextDocUserID = "";
var NextDocUserName = "";
var NextDocUserName2 = "";
var NextDocDeptID = "";
var NextDocType = "";
var NextDocState = "";
var NextDocWriterID = "";
var NextDocAprType = "";
var NextDocHref = "";
var NextDocExtended = "";

function getNextDocInfo()
{
  try {
	var xmlhttp		= createXMLHttpRequest();	
	var xmlpara = createXmlDom();	
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "UserID", pUserID);
	createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);

	xmlhttp.open("Post", "/myoffice/ezApprovalG/ApprovUI/aspx/GetNextDocInfo.aspx", false);
	xmlhttp.send(xmlpara);	
	
	NextDocID = "";
	NextDocUserID = "";
	NextDocUserName = "";
	NextDocUserName2 = "";
	NextDocDeptID = "";
	if (loadXMLString(xmlhttp.responseText).xml != "")
	{
	    var resValue = loadXMLString(xmlhttp.responseText);
	    if (resValue.documentElement.childNodes.length > 0)
		{
	        NextDocID = getNodeText(resValue.documentElement.childNodes(0));
	        NextDocUserID = getNodeText(resValue.documentElement.childNodes(1));
	        NextDocUserName = getNodeText(resValue.documentElement.childNodes(2));
	        NextDocUserName2 = getNodeText(resValue.documentElement.childNodes(10));
	        NextDocDeptID = getNodeText(resValue.documentElement.childNodes(3));
	        NextDocType = getNodeText(resValue.documentElement.childNodes(4));
	        NextDocState = getNodeText(resValue.documentElement.childNodes(5));
	        NextDocWriterID = getNodeText(resValue.documentElement.childNodes(6));
	        NextDocAprType = getNodeText(resValue.documentElement.childNodes(7));
	        NextDocHref = getNodeText(resValue.documentElement.childNodes(8));
	        NextDocExtended = getNodeText(resValue.documentElement.childNodes(9));
		}
	}
  } catch(e) {}
}


function getNextDocOne(tempDocID)
{
  try {
	var xmlhttp		= createXMLHttpRequest();	
	var xmlpara = createXmlDom();	
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", tempDocID);
	
	xmlhttp.open("Post", "/myoffice/ezApprovalG/ApprovUI/aspx/GetNextDocOne.aspx", false);
	xmlhttp.send(xmlpara);	
	
	NextDocID = "";
	NextDocUserID = "";
	NextDocUserName = "";
	NextDocUserName2 = "";
	NextDocDeptID = "";
	if (loadXMLString(xmlhttp.responseText).xml != "")
	{
	    var resValue = loadXMLString(xmlhttp.responseText);
	    if (resValue.documentElement.childNodes.length > 0)
		{
	        NextDocID = getNodeText(resValue.documentElement.childNodes(0));
	        NextDocUserID = getNodeText(resValue.documentElement.childNodes(1));
	        NextDocUserName = getNodeText(resValue.documentElement.childNodes(2));
	        NextDocUserName2 = getNodeText(resValue.documentElement.childNodes(10));
	        NextDocDeptID = getNodeText(resValue.documentElement.childNodes(3));
	        NextDocType = getNodeText(resValue.documentElement.childNodes(4));
	        NextDocState = getNodeText(resValue.documentElement.childNodes(5));
	        NextDocWriterID = getNodeText(resValue.documentElement.childNodes(6));
	        NextDocAprType = getNodeText(resValue.documentElement.childNodes(7));
	        NextDocHref = getNodeText(resValue.documentElement.childNodes(8));
	        NextDocExtended = getNodeText(resValue.documentElement.childNodes(9));
			
		}
	}
  } catch(e) {}
}

