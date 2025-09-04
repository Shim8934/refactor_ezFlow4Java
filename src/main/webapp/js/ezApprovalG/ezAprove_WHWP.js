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
var portNum = document.location.port == "" ? "" : ":" + document.location.port;
var hostURL = document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=";
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
		if (message.FieldExist(habyui))
		{
			message.PutFieldText(habyui, strLang4);
			field.value = strLang4;
			SignContent[signCnt] = strLang4;
			signInfo[signCnt] = habyui
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = habyui;					
					
			signCnt = signCnt + 1
			SingFlag = false; 
		}
		
		var habyuidateID = phabyuidate + pAprMemberSN;
		if (message.FieldExist(habyuidateID))
		{
			message.PutFieldText(habyuidateID, s);
			signInfo[signCnt] = habyuidateID;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = habyuidateID;
			SignContent[signCnt] = s;					
			signCnt = signCnt + 1;
		}
	}
	return signInfo;   
}

var signInfo = [];
var newSignInfo = [];
function AprrovMappingSign(ret)
{
	var allTypeB = typeof draftAllTypeB != "undefined" && typeof pDocIDAry != "undefined" && typeof anCnt == "number" && draftAllTypeB == "Y" && pDocIDAry.length > 2 && anCnt > 1;
	var SingFlag = true;
	var DekyulFlag = false;
	var habyui
	var signCnt = 0;
	
	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 
	
	var OpinionText = "";
	var PositionText = "";
	// 4 : 전결, 16 : 대결
	if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		OpinionText = getSignDate() + "\15";
	}
	
	// 8 : 개인순차협조, 9 : 개인병렬협조, 11 : 부서순차협조, 12 : 부서병렬협조
	if (pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
  		var phabyuisign;
  		var phabyuidate;
  		var phabyuijikwee;
  		var phabyuidept;
  		
  		if (pDraftFlag == "SUSIN") {
  			phabyuisign = pSusinSN + "habyuisign";
  			phabyuidate = pSusinSN + "habyuidate";
  			phabyuijikwee = pSusinSN + "habyuipositon";
  			phabyuidept = pSusinSN + "habyui";
  		} else {
  			phabyuisign   = "habyuisign";
  			phabyuidate   = "habyuidate";
  			phabyuijikwee = "habyuipositon";
  			phabyuidept   = "habyui";
  		}
  		
  		// 합의일자와 합의직위가 이미지 서명보다 나중에 삽입되는 경우, 양식상에 제대로 삽입되지 않는 경우가 있어 상단으로 코드 이동 (웹한글 비동기 관련)
		var habyuidateID = phabyuidate + pAprMemberSN;
		if (message.FieldExist(habyuidateID)) {
			message.PutFieldText(habyuidateID, s);		
			signInfo[signCnt] = habyuidateID;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = habyuidateID;
			SignContent[signCnt] = s;					
			signCnt = signCnt + 1;
            newSignInfo.push(habyuidateID);
		}
		
		var phabyuijikweeID = phabyuijikwee + pAprMemberSN;
		if (message.FieldExist(phabyuijikweeID)) {
			message.PutFieldText(phabyuijikweeID, message.GetFieldText(phabyuijikweeID) + PositionText);
		}
		
		var habyui = phabyuisign + pAprMemberSN;
		if (message.FieldExist(habyui)) {
			if (ret != "NAME" && ret != "") { // 서명이 이미지인 경우 
				message.PutFieldText(habyui, "");
				
				// 대리결재 시, 代 문자를 이미지 서명 위에 붙임
				if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
					message.PrependFieldText(habyui, strLang8 + "\15");
				}
				
				signInfo[signCnt] = habyui;
				SignName[signCnt] = habyui;
                newSignInfo.push(habyui);
                
				if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
					SignType[signCnt] = "IMAGE";
					SignContent[signCnt] = ret + "::" + strLang8;
				}
				else {
					SignType[signCnt] = "IMAGE";
					SignContent[signCnt] = ret;
				}
				
//				message.InsertPicture(habyui, hostURL + escape(ret), AprrovMappingSign_after);
				if(allTypeB){
                    var retFunction = null;
                    for(var j = 0; j < anCnt; j++){
                        retFunction = j == anCnt -1 ? AprrovMappingSign_after : null;
                        message.InsertPicture(signID + "{{" + j + "}}", hostURL + escape(ret), retFunction);    
                    }
				}else{
				    message.InsertPicture(habyui, hostURL + escape(ret), AprrovMappingSign_after);
				}
				
				signCnt = signCnt + 1
				SingFlag = true;
			}
			else {
				// 대리결재 시, 代 문자를 문자서명 좌측에 붙임
				if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
					message.PutFieldText(habyui, strLang8 + arr_userinfo[2]);
					SignContent[signCnt] = strLang8 + arr_userinfo[2];
				}
				else {
					message.PutFieldText(habyui, arr_userinfo[2]);
					SignContent[signCnt] = arr_userinfo[2];
				}
				
				signInfo[signCnt] = habyui
				SignType[signCnt] = "TEXT";
				SignName[signCnt] = habyui;
				signCnt = signCnt + 1
				SingFlag = false; 
				newSignInfo.push(habyui);
			}
		}
	}
	else if (pAprLineType == strAprType2 || pAprLineType == strAprType7) {   // 2 : 확인, 7 : 참조
	
	}
	else if (pAprLineType == strAprType15) { // 15 : 후열
		signID = "gamsasign1" 
		if (message.FieldExist(signID)) {
			message.PutFieldText(signID, arr_userinfo[2] + "\15" + s);
			signInfo[signCnt] = signID;
			SignName[signCnt] = signID;
			SignType[signCnt] = "TEXT";
			SignContent[signCnt] = arr_userinfo[2] + "\15" + s;
			newSignInfo.push(signID);
			signCnt = signCnt + 1;
		}
	}
	/* 2024-10-04 홍승비 - 웹한글 S버전 대응 > 합의결재와 일반적인 내부결재를 분기처리하는 if~else문의 오류 수정 (합의결재 대응 코드가 if문, 그 이외의 결재 케이스가 else문) */
	else if(ret == "BANSONG" && KuyjeType == "001" && approvalFlag == "S") {
        var pAprMemberSignSN = pAprMemberSN;
        var signID;
        var seumyungID;
        var seumyungdateID;

        signID = "sign" + pAprMemberSignSN;
        seumyungID = "seumyung" + pAprMemberSignSN;
        seumyungdateID = "seumyungdate" + pAprMemberSignSN;

        if (message.FieldExist(signID)) {
            var SContent = strLang4 + "\15" + arr_userinfo[2];
            message.PutFieldText(signID, SContent);
            signInfo[signCnt] = signID;

            SignName[signCnt] = signID;
            SignType[signCnt] = "TEXT";
            SignContent[signCnt] = SContent;
            newSignInfo.push(signID);

            signCnt = signCnt + 1;
        }

        if (message.FieldExist(seumyungID)) {
            message.PutFieldText(seumyungID, arr_userinfo[5]);
            signInfo[signCnt] = seumyungID;
            SignName[signCnt] = seumyungID;
            SignType[signCnt] = "TEXT";
            SignContent[signCnt] = arr_userinfo[5];
            newSignInfo.push(seumyungID);

            signCnt = signCnt + 1;
        }

        if (message.FieldExist(seumyungdateID)) {
            message.PutFieldText(seumyungdateID, s);
            signInfo[signCnt] = seumyungdateID;
            SignName[signCnt] = seumyungdateID;
            SignType[signCnt] = "TEXT";
            SignContent[signCnt] = s;
            signCnt = signCnt + 1;
            newSignInfo.push(seumyungdateID);
        }
    }
    else if (pAprLineType == strAprType4 && approvalFlag == "S") { // 4 : 전결
        var pAprMemberSignSN = pAprMemberSN;
        var signID;
        var seumyungID;
        var seumyungdateID;

        var pSusinSN2 = "";
        if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N")) {
            pSusinSN2 = pSusinSN;
        }

        if (junGyulFlag == "1") {
            /* 2018-04-27 천성준 - 전결자만 결재칸에 전결 표시 >> 전결자 결재칸에 전결String */
            signID = pSusinSN2 + "sign" + pAprMemberSignSN;

            if (message.FieldExist(signID)) {
                message.PutFieldText(signID, strLang6);
            }

            //최종결재자 인덱스 구하기
            for (var i=0; i<20; i++) {
                signID = pSusinSN2 + "sign" + i;

                if (message.FieldExist(signID)) {
                    LastKyulSN = i;
                }
            }

            //최종결재자 결재칸에 싸인
            signID = pSusinSN2 + "sign" + LastKyulSN;
            seumyungID = pSusinSN2 + "jikwe" + LastKyulSN;
            seumyungdateID = pSusinSN2 + "seumyungdate" + LastKyulSN;

            if (message.FieldExist(seumyungdateID)) {
                message.PutFieldText(seumyungdateID, s);
            }

            if (message.FieldExist(seumyungID)) {
                message.PutFieldText(seumyungID, message.GetFieldText(seumyungID) + PositionText);
            }

            if (message.FieldExist(signID)) {
                if (ret != "NAME") { //이미지 서명
                    var strimg;
                    message.PutFieldText(signID, "");

                    if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        message.PrependFieldText(signID, strLang8);
                    }

                    if (!message.FieldExist(seumyungdateID)) {
                        message.PrependFieldText(signID, OpinionText);
                    }

                    var contents = OpinionText;

//                        if (signImageType == "NAME") {
//                            message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSignName_after);
//                        } else {
//                        message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
//                        }
                    if(allTypeB){
                        var retFunction = null;
                        for(var j = 0; j < anCnt; j++){
                            retFunction = j == anCnt -1 ? AprrovMappingSign_after : null;
                            message.InsertPicture(signID + "{{" + j + "}}", hostURL + escape(ret), retFunction);    
                        }
                    }else{
                        message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
                    }


                    SignType[signCnt] = "IMAGE";
                    SignContent[signCnt] = ret+"::"+contents;
                }
                else { //문자 서명
                    var content ="";
                    if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        message.PutFieldText(signID, strLang8 + arr_userinfo[2]);
                        content = strLang8 + arr_userinfo[2];
                    } else {
                        message.PutFieldText(signID, arr_userinfo[2]);
                        content = arr_userinfo[2];
                    }

                    if (!message.FieldExist(seumyungdateID)) {
                        message.PrependFieldText(signID, OpinionText);
                        content = OpinionText + content;
                    }

                    SignType[signCnt] = "TEXT";
                    SignContent[signCnt] = content;
                }
                signInfo[signCnt] = signID;
                SignName[signCnt] = signID;
                signCnt = signCnt + 1
                SingFlag = false;
                newSignInfo.push(signID);
            }
        } else if (junGyulFlag == "4") {
            signID = pSusinSN2 + "sign" + pAprMemberSignSN;
            seumyungID = pSusinSN2 + "jikwe" + pAprMemberSignSN;
            seumyungdateID = pSusinSN2 + "seumyungdate" + pAprMemberSignSN;

            if (message.FieldExist(seumyungdateID)) {
                message.PutFieldText(seumyungdateID, s);
            }

            if (message.FieldExist(seumyungID)) {
                message.PutFieldText(seumyungID, message.GetFieldText(seumyungID) + PositionText);
            }

            if (message.FieldExist(signID)) {
                if (ret != "NAME") { //이미지 서명
                    var strimg;
                    message.PutFieldText(signID, "");

                    if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        message.PrependFieldText(signID, strLang8);
                    }

                    if (!message.FieldExist(seumyungdateID)) {
                        message.PrependFieldText(signID, OpinionText);
                    }

                    message.PrependFieldText(signID, strLang6);
                    var contents = strLang6 + OpinionText;

//                    message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
                    if(allTypeB){
                        var retFunction = null;
                        for(var j = 0; j < anCnt; j++){
                            retFunction = j == anCnt -1 ? AprrovMappingSign_after : null;
                            message.InsertPicture(signID + "{{" + j + "}}", hostURL + escape(ret), retFunction);    
                        }
                    }else{
                        message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
                    }

                    SignType[signCnt] = "IMAGE";
                    SignContent[signCnt] = ret+"::"+contents;
                }
                else { // 문자 서명
                    if(pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        message.PutFieldText(signID, strLang8 + arr_userinfo[2]);
                        contents = strLang8 + arr_userinfo[2];
                    }
                    else {
                        message.PutFieldText(signID, arr_userinfo[2]);
                        contents = arr_userinfo[2];
                    }

                    if (!message.FieldExist(seumyungdateID)) {
                        message.PrependFieldText(signID, OpinionText);
                        contents = OpinionText + contents;
                    }

                    message.PrependFieldText(signID, strLang6);
                    contents = strLang6 + contents;

                    SignType[signCnt] = "TEXT";
                    SignContent[signCnt] = contents;
                }
                signInfo[signCnt] = signID;
                SignName[signCnt] = signID;
                signCnt = signCnt + 1
                SingFlag = false;
                newSignInfo.push(signID);
            }
        }
        //TODO: junGyulFlag 2,3 일때 처리
    }
	else {
		var pAprMemberSignSN = pAprMemberSN;
		var signID;
		var seumyungID;
		var seumyungdateID;
		
		// 전자결재 일반버전 웹한글 대응 분기 (서명칸 정렬 수정)
        if (approvalFlag == "S") {
            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4) {
                for (i = 1; i <= 20; i++) {
                    if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N"))
                        signID = pSusinSN + "sign" + i
                    else
                        signID = "sign" + i
                            
                    if (message.FieldExist(signID)) {
                        LastSignNo = i;
                    }
                }
                
                if (LastKyulSN == pAprMemberSN) {
                    pAprMemberSignSN = LastSignNo;
                }
                
                if (pAprLineType == strAprType4) {
                    LastKyulSN = LastSignNo;
                }
            }
        }
        
		if (pDraftFlag == "SUSIN") {
			signID = pSusinSN + "sign" + pAprMemberSignSN;
			seumyungID = pSusinSN + "jikwe" + pAprMemberSignSN;
			seumyungdateID = pSusinSN + "seumyungdate" + pAprMemberSignSN;
		} else {
			signID = "sign" + pAprMemberSignSN;
			seumyungID = "jikwe" + pAprMemberSignSN;
   			seumyungdateID = "seumyungdate" + pAprMemberSignSN;
		}
		
		if (message.FieldExist(seumyungdateID)) {
			message.PutFieldText(seumyungdateID, s);
            newSignInfo.push(seumyungdateID);
            
            /* 2023-10-05 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
    		signInfo[signCnt] = seumyungdateID;
    		SignName[signCnt] = seumyungdateID;
    		SignType[signCnt] = "TEXT";
    		SignContent[signCnt] = s;
    		signCnt = signCnt + 1;
		}
		
		if (message.FieldExist(seumyungID)) {
			message.PutFieldText(seumyungID, message.GetFieldText(seumyungID) + PositionText);
		}
		
		if (pAprLineType == strAprType16) {	// 대결
			if (message.FieldExist(signID)) {
				// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
				if (message.FieldExist(seumyungdateID)) {
				    OpinionText = "\15";
				}
				
	  			if (ret != "NAME") {
	  				message.PutFieldText(signID, "");
                    var content = "";
                    
                    // 대리결재 시, 代 문자를 이미지 서명 위에 붙임 (대결 및 서명일자 표기보다는 아래에 위치)
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
						message.PrependFieldText(signID, strLang8 + "\15");
						content = strLang8 + "\15";
					}
					
	  				message.PrependFieldText(signID, strLang7 + OpinionText);
//	  				message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
                    if(allTypeB){
                        var retFunction = null;
                        for(var j = 0; j < anCnt; j++){
                            retFunction = j == anCnt -1 ? AprrovMappingSign_after : null;
                            message.InsertPicture(signID + "{{" + j + "}}", hostURL + escape(ret), retFunction);    
                        }
                    }else{
                        message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
                    }
	  				
	  				signInfo[signCnt] = signID;
			        SignName[signCnt] = signID;
			        SignType[signCnt] = "IMAGE";
			        SignContent[signCnt] = ret + "::" + strLang7 + OpinionText + content;
			        newSignInfo.push(signID);
			        
	  				signCnt = signCnt + 1
	  				SingFlag = true;
	  			}
	  			else {
	  			    var content = "";
	  			    
	  			    // 대리결재 시, 代 문자를 문자서명 좌측에 붙임
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
						message.PutFieldText(signID, OpinionText + strLang8 + arr_userinfo[2]);
	  			        content = OpinionText + strLang8 + arr_userinfo[2];
					} else {
						message.PutFieldText(signID, OpinionText + arr_userinfo[2]);
						content = OpinionText + arr_userinfo[2];
					}
					
					message.PrependFieldText(signID, strLang7);
					content = strLang7 + content ;
					
	  				signInfo[signCnt] = signID;
			        SignName[signCnt] = signID;
			        SignType[signCnt] = "TEXT";
			        SignContent[signCnt] = content;
	  				signCnt = signCnt + 1
	  				SingFlag = false;
	  				newSignInfo.push(signID);
	  			}
	  			
	  			DekyulFlag = true;
	  			pAprMemberSignSN = pAprMemberSignSN + 1;
				if (pDraftFlag == "SUSIN") {
					signID = pSusinSN + "sign" + pAprMemberSignSN;
					seumyungID = pSusinSN + "jikwe" + pAprMemberSignSN;
					seumyungdateID = pSusinSN + "seumyungdate" + pAprMemberSignSN;
				} else {
					signID = "sign" + pAprMemberSignSN;
					seumyungID = "jikwe" + pAprMemberSignSN;
   					seumyungdateID = "seumyungdate" + pAprMemberSignSN;
				}
			}
		}
		
		// 상단 분기에서 + 1 처리된 서명 필드에 접근 (다음 결재자의 서명 필드)
		if (message.FieldExist(signID)) {
			// 4 : 전결 (대결자 이후 최종결재자로 전결자가 존재하는 경우, 즉 위임전결사항의 대결 처리)
			if (DekyulFlag && pAprLineB4type == strAprType4) {
				message.PutFieldText(signID, strLang6);
				
	  			signInfo[signCnt] = signID;
		        SignName[signCnt] = signID;
		        SignType[signCnt] = "TEXT";
		        SignContent[signCnt] = strLang6;
		        newSignInfo.push(signID);
		        
	  			signCnt = signCnt + 1
			} else if (DekyulFlag) {
			}
			else {
			    var contents = "";
			    // 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
				if (message.FieldExist(seumyungdateID)) {
				    OpinionText = "\15";
				}
				
	  			if (ret != "NAME") { // 이미지서명
	  				message.PutFieldText(signID, "");
	  				
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
						// 이미지 서명의 경우, 代 문자를 이미지 서명 위에 붙임 (대결/전결, 서명일자 표기보다는 아래에 위치)
						contents = strLang8 + "\15";
					}
					
					if (pAprLineType == strAprType4) { // 전결
						OpinionText = strLang6 + OpinionText;
	  				}
					
					// OpinionText에 대결/전결/서명일자 표기 없이 개행문자만 존재하는 경우, 공백으로 치환
					if (OpinionText == "\15") {
						OpinionText = "";
					}
					
					contents = OpinionText + contents;
					
					message.PrependFieldText(signID, contents);
//	  				message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
                    if(allTypeB){
                        var retFunction = null;
                        for(var j = 0; j < anCnt; j++){
                            retFunction = j == anCnt -1 ? AprrovMappingSign_after : null;
                            message.InsertPicture(signID + "{{" + j + "}}", hostURL + escape(ret), retFunction);    
                        }
                    }else{
                        message.InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
                    }
	  				
	  				signInfo[signCnt] = signID;
		            SignName[signCnt] = signID;
		            SignType[signCnt] = "IMAGE";
		            SignContent[signCnt] = ret + "::" + contents;
		            newSignInfo.push(signID);
		            
	  				signCnt = signCnt + 1
	  				SingFlag = true;
	  			}
	  			else { // 문자서명
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) { // 대리결재
						contents = strLang8 + arr_userinfo[2]; // 문자서명 시, 代 문자와 결재자명 사이에는 개행 없음
					}
					else {
						contents = arr_userinfo[2];		
					}
					
					if (pAprLineType == strAprType4) {
						OpinionText = strLang6 + OpinionText;
	  				}
					
					// OpinionText에 대결/전결/서명일자 표기 없이 개행문자만 존재하는 경우, 공백으로 치환
					if (OpinionText == "\15") {
						OpinionText = "";
					}
					
					contents = OpinionText + contents;
					
					message.PutFieldText(signID, contents);
					
	  				signInfo[signCnt] = signID;
		            SignName[signCnt] = signID;
		            SignType[signCnt] = "TEXT";
		            SignContent[signCnt] = contents;
	  				signCnt = signCnt + 1
	  				SingFlag = false; 
	  				newSignInfo.push(signID);
	  			}
	  		}
		}
	}
	//return signInfo;   
	if (ret == "NAME") {
		GetHTML(Before_SaveApproveInfo);
	}
}

function AprrovMappingSign_after() {
	GetHTML(Before_SaveApproveInfo);
}

function putJunkyulSign(signID) {
	if (message.FieldExist(signID)) {
		message.PutFieldText(signID, strLang6);	
	}
}

function putKyuljeSign(signID)
{
}

function UndoSignInfo(signInfo)
{
	var cnt;
	for(cnt=0;cnt < signInfo.length;cnt++)
		if (message.FieldExist(signInfo[cnt]))
			message.PutFieldText(signInfo[cnt], " ");
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

function openOpinionUI_New(pOpinionType, CompleteFunction) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = "";			//DRAFTFLAG 결재는 공백 고정 
		parameter[3] = docState;	//DOCSTATE
		parameter[4] = orgCompanyID;//ORGCOMPANYID
		parameter[99] = ext;		//EXT
		
		var url = "/ezApprovalG/aprOpinionNew.do";
		//var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
		//var ret = window.showModalDialog(url,parameter,feature);
		
		apropinion_cross_dialogArguments[0] = parameter;
	    if (CompleteFunction != undefined)
	        apropinion_cross_dialogArguments[1] = CompleteFunction;
	    else
	        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;
	    
	    DivPopUpShow(530, 520, url);
	} catch (e) {
		alert("openOpinionUI_New ::: " + e);
	}
}

function makeOpinionList(OpinionXML, anIdx) {
	if (!message.FieldExist("opinions"))
		return;

	var firstFlag = true;
	var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
	if (NodeList.length > 0) {
		var strOpinion = " ";
		for (i=NodeList.length - 1; i>=0; i--) {
			if (getNodeText(GetChildNodes(NodeList[i])[9]) == "001") {
				if (firstFlag) {
					strOpinion = "[" + strLang27;
					firstFlag = false;
				}
			
				if (getNodeText(GetChildNodes(NodeList[i])[2]) != "")
				    strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[2]) + "\11";  
				else
					strOpinion = strOpinion + "   \11";  
						
				strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[1]) + "\11";
				strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[6]) + "\15";
			}
		}		
		
		if(typeof anIdx != "undefined" && anIdx > 0){
            message.PutFieldText("opinions" + "{{" + (anIdx-1) + "}}", strOpinion);
        }else{
            message.PutFieldText("opinions", strOpinion);
        }
		/*if (OpinionAction == "ADD" || OpinionAction == "DEL") {
			GetHTML(before_SaveFile);
		}*/
			
		OpinionAction = "";
	}
	else {
	    if(typeof anIdx != "undefined" && anIdx > 0){
		    message.PutFieldText("opinions" + "{{" + (anIdx-1) + "}}", "");
	    }else{
		    message.PutFieldText("opinions", "");
	    }
	}

//	GetHTML(before_SaveFile);

	if(typeof anIdx != "undefined" && typeof draftAllTypeB != "undefined" && draftAllTypeB == "Y" && anIdx > 0){
	    GetHTML(SaveFileAfterOpinions);
    }else{
	    GetHTML(before_SaveFile);
    }
}

function SaveFileAfterOpinions(html) {
    SaveHtml = html;

	// 확인, 참조일 경우 파일 저장 안함
	if (pAprLineType == strAprType2 || pAprLineType == strAprType7) return "TRUE";
	var result = "";
	
	var data = {
		docID : pDocIDAry[1],
		formId : pFormIDAry[1],
		html  : SaveHtml,
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

function before_SaveFile(html) {
	SaveHtml = html;
	
	SaveFile();
}

/* 2023-10-24 강동주 - 한글양식 편집모드 사용후 즉시 저장에 사용되는 메서드. */
function before_SaveFile2(html) {
	SaveHtml = html;

	if(SaveHtml != "")
		UpdateDocHistory(SaveHtml, "N", beforeDocURL);

	SaveFile();
}

function before_SaveFile_BackEnd(html) {
	SaveHtml = html;
	
	SaveFile();
	
	if(typeof saveBtypeFlag != "undefined"){
        saveBtypeFlag = true;
	}
	if(typeof backFailFlag != "undefined" && !backFailFlag){
	    Approv_Complete_BackEnd(); 
	}else{
	    Approve_complete("NAME");
	}
}

var aprattach_dialogArguments = new Array();
function openFileAttachUI() {
	var parameter = pDocID;
	var url = "/ezApprovalG/aprAttach.do?formID=" + pFormID + "&docID=" + pDocID + "&draftFlag=" + pDraftFlag + "&orgCompanyID=" + orgCompanyID + "&ext=" + "hwp";

	aprattach_dialogArguments[0] = parameter;
	aprattach_dialogArguments[1] = openFileAttachUI_Complete;
	
	DivPopUpShow(800, 610, url);
}

function openFileAttachUI_Complete(ret) {
	DivPopUpHidden();
	
	if (ret != "cancel")	{
		setAttachInfo(pDocID, "APR", lstAttachLink);
	}
}

/**
 * 백단 결재 메서드
 * data에 결재관련 정보 저장
 * pApproveFlag 1 : 결재, 2 : 반송, 3 : 보류, 4 : 회수, 5 : 확인, 6 : 공람
 * */
function SaveApproveInfoInBackEnd(pApproveFlag) {
    var result = "";
    var sn = wAprMemberSN.toString();
    var mode = "APR";
    var pAprState = "";
    
    if (pApproveFlag == "1") {
        pAprState = "APR";
    } else if (pApproveFlag == "2") {
        pAprState = "BAN";
    } else if (pApproveFlag == "3") {
        pAprState = "BO";
    } else if (pApproveFlag == "4") {
        pAprState = "HWE";
    } else if (pApproveFlag == "5") {
        pAprState = "CHECK";
    } else if(pApproveFlag == "6"){
        pAprState = "GR";
    }
    
    var tmpDocID = pDocID;
    /*if(typeof draftAllTypeB != "undefined" && draftAllTypeB == "Y" && typeof pDocIDAry != "undefined" && pDocIDAry.length > 0){
        tmpDocID = pDocIDAry[0];
    else{
        tmpDocID = pDocID;
    }*/
    var data = {"docID" : tmpDocID, "aprMemberSN" : sn, "mode" : mode, "type" : pAprState};
    
    $.ajax({
        type : "POST",
        dataType : "json",
        async : false,
        url : "/ezApprovalG/doApprovBackEnd.do",
        contentType : "application/json",
        data : JSON.stringify(data),
        success: function(obj){
            if(obj){
                console.log(obj);
                result = obj;
            }
        },
        error : function(err){
            console.log(err);
        }        			
    });
    
    return result;
}

var approvBack = "N";
function SaveApproveInfo(pApproveFlag) {
	var rtnVal = SaveFile();

	if (rtnVal.toUpperCase() != "TRUE") {
        return rtnVal;
	}

	SignSave();
	
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	pDocTitle = message.GetFieldText("doctitle");
	if(anCnt > 1){
	    var tmpID = pDocIDAry[1];
	    pDocID = pDocIDAry[1];
	    var tmpDir = "/" + Number(pDocID.substr(-3)) + "/";   
	    pFormID = pFormIDAry[1];
	    pDocHref = pDocHref.substring(0,pDocHref.indexOf(",") == -1 ? pDocHref.length : pDocHref.indexOf(","));
	    pHasAttachYN = pHasAttachYNAry[1];
	    pHasOpinionYN = pHasOpinionYNAry[1];
	    
        for(var i = 1; i < anCnt; i++){
            pDocID += "," + pDocIDAry[i + 1];
            pFormID += "," + pFormIDAry[i + 1];
            pDocHref += "," + pDocHref.replace(tmpID, pDocIDAry[i + 1]).replace(tmpDir, "/" + Number(pDocIDAry[i + 1].substr(-3)) + "/");
            pHasAttachYN += pHasAttachYNAry[i + 1] == "Y" || pHasDocAttachYNAry[i + 1] == "Y" ? ",Y" : ",N";
            pHasOpinionYN += "," + pHasOpinionYNAry[i + 1];
            
            if(typeof pDocTitleAry != "undefined" && pDocTitleAry.length > 1){
                pDocTitle += "㉾" + pDocTitleAry[i + 1];
            }else{
                pDocTitle += "㉾" + message.GetFieldText("doctitle{{" + i + "}}");
            }
        }
    }
	createNodeAndInsertText(xmlpara, objNode, "DOCID", anCnt > 1 ? pDocID : getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[0]));
	createNodeAndInsertText(xmlpara, objNode, "FORMID", anCnt > 1 ? pFormID : getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[1]));
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", anCnt > 1 ? "" : getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[2]));
	createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", anCnt > 1 ? "" : getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[3]));
	createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", anCnt > 1 ? "" : getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[4]));
	createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", "002");
	createNodeAndInsertText(xmlpara, objNode, "HREF", anCnt > 1 ? pDocHref : getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[6]));

	createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", pDocTitle);

    if (approvalFlag == 'S' && pApproveFlag == "2") {
        if (message.FieldExist("opinions")) {
        	message.PutFieldText("opinions", "");
        }

//    	if (approvalFlag == 'G' && pDraftFlag == "SUSIN" && useReceiveDocNo == 'NO') {
//    		if (field) {
//    			var forTest = getfieldValue(field).slice(-1);
//    			if (getfieldValue(field).slice(-1) == "-") {
//    				createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field).substring(0, getfieldValue(field).length - 1));
//    			} else {
//    				createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
//    			}
//    		} else {
//    			var field = message.GetListItem(fields, "receiptnumber");
//    			if (field) {
//    				var forTest = getfieldValue(field).slice(-1);
//    				if (getfieldValue(field).slice(-1) == "-") {
//    					createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field).substring(0, getfieldValue(field).length - 1));
//    				} else {
//    					createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
//    				}
//    			}
//    		}
//    	} else {
    		if (message.FieldExist("deptshortedname")) {
    		    var fieldText = message.GetFieldText("deptshortedname");
    			var forTest = fieldText.slice(-1);
    			if (forTest == "-") {
    				createNodeAndInsertText(xmlpara, objNode, "DOCNO", fieldText.substring(0, fieldText.length - 1));
    			} else {
    				createNodeAndInsertText(xmlpara, objNode, "DOCNO", fieldText);
    			}
    		} else {
    			if (message.FieldExist("docnumber")) {
    				var fieldText = message.GetFieldText("deptshortedname");
                    var forTest = fieldText.slice(-1);

    				/* 2021-08-25 홍승비 - 개인병렬협조/합의자가 반송하는 경우, 테넌트 컨피그 PersonalAgreeReturnType를 체크하여 DOCNO 뒤의 '-' 문자를 지우거나 유지함 */
    				if (forTest == "-") {
    					// PersonalAgreeReturnType값이 1인 경우, 개인병렬협조/합의자가 반송해도 다음 결재권자에게 문서를 전달하며 결재가 가능하다.
    					var personalAgreeReturnType = getPersonalAgreeReturnType();
    					if (pAprLineType == "009" && personalAgreeReturnType.trim() == "1") {
    						createNodeAndInsertText(xmlpara, objNode, "DOCNO", fieldText);
    					} else {
    						createNodeAndInsertText(xmlpara, objNode, "DOCNO", fieldText.substring(0, fieldText.length - 1));
    					}
    				} else {
    					createNodeAndInsertText(xmlpara, objNode, "DOCNO", fieldText);
    				}
    			} else {
    				if (message.FieldExist("bedocnumber")) {
                        var fieldText = message.GetFieldText("deptshortedname");
                        var forTest = fieldText.slice(-1);
    					if (forTest == "-") {
    						createNodeAndInsertText(xmlpara, objNode, "DOCNO", fieldText.substring(0, fieldText.length - 1));
    					} else {
    						createNodeAndInsertText(xmlpara, objNode, "DOCNO", fieldText);
    					}
    				} else {
    					createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
    				}
    			}
    		}
//    	}
    } else {
    	/* 2025-02-18 홍승비 - 전자결재 G > useReceiveDocNo 플래그에 관계없이 수신문의 접수번호를 문서번호로 사용하도록 수정 */
		// useReceiveDocNo가 YES인 경우, 최종결재 시점이 아닌 수신문 접수 시점에 접수번호를 미리 채번함
        if (approvalFlag == 'G' && pDraftFlag == "SUSIN") {
            if (message.FieldExist("receiptnumber")) {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", message.GetFieldText("receiptnumber"));
            } else if (message.FieldExist("docnumber")) {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", message.GetFieldText("docnumber"));
            } else if (message.FieldExist("be_docnumber")) {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", message.GetFieldText("be_docnumber"));
            } else if (message.FieldExist("deptshortedname")) {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", message.GetFieldText("deptshortedname"));
            } else {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
            }
        } else {
            if (message.FieldExist("docnumber")) {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", message.GetFieldText("docnumber"));
            } else if (message.FieldExist("be_docnumber")) {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", message.GetFieldText("be_docnumber"));
            } else if (message.FieldExist("deptshortedname")) {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", message.GetFieldText("deptshortedname"));
            } else {
                createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
            }
        }
	}

	if (pHasAttachYN == "")
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", anCnt > 1 ? pHasAttachYN : getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[9]));
	else
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);

	var objNode;

	if (pHasOpinionYN == "")
	    createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", anCnt > 1 ? pHasOpinionYN : getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[10]));
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
	g_SepAttachLVXml = GetDocumentElement("sepattachlvxml", true);
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
	
	createNodeAndInsertText(xmlpara, objNode, "APPROVBACK", approvBack);
	pDocID = tmpID;
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
	// 확인, 참조일 경우 파일 저장 안함
	if (pAprLineType == strAprType2 || pAprLineType == strAprType7) return "TRUE";
	var result = "";
	
	var data = {
		docID : pDocID,
		formId : pFormID,
		html  : SaveHtml,
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

function SaveFileForApprovAllTypeB(data) {
	// 확인, 참조일 경우 파일 저장 안함
	if (pAprLineType == strAprType2 || pAprLineType == strAprType7) return "TRUE";
	var result = "";
	
	// 일괄기안 B타입은 각 안을 저장 하는 것이 아님 
	// 1안만 저장 
	var data = {
		docID : pDocIDAry[1],
		formId : pFormIDAry[1],
		html  : data,
		orgCompanyID : orgCompanyID
	}

	var url = "/ezApprovalG/saveFileHWP.do";

    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : url,
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
	
	// 2021.01.07 강승구 : 오류발생 후 파일이 사라지는 오류 수정
	if (!OrgHtml)
        return;

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

	var Fields = message.GetFieldList();
  
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
				SignInfo = message.GetFieldText(Fields[i]);
				SignInfoFlag = false;
			}
			else
			{
				SignInfo = message.GetFieldText(Fields[i]) + ";" + SignInfo ;
			}
		}
	}
	
	pSuSinFlag = "N";
	if(pDraftFlag != "SUSIN")
	{
		var RtnVal = message.FieldExist("recipient");
		if(RtnVal)
		{
			pSuSinFlag = "Y";
		}else{
			pSuSinFlag = "N";
		}
	}
	
	pSusinNextSN = parseInt(pSusinSN) + 1;
	fieldname = pSusinNextSN + "sign1";
	if (message.FieldExist(fieldname))
		pSuSinFlag = "Y";
	
	pChamJoFlag = "Y";
}

function SReAprLineSingMapping(ret) {
    var xmlKuljea, chamjo, hapyuiCnt, SignCnt, referCnt, xmlReDraft
    var OrderType = new Array();
    var OrderTypeName = new Array();
    var OrderDept = new Array();
    var OrderName = new Array();
    var OrderStat = new Array();
    var OrderStatName = new Array();
    var OrderJobtitle = new Array();
    var OrderReason = new Array();
    var reMappingSign = false;

    if (typeof ret == "object") {
    	xmlKuljea = ret[1];
    	xmlReDraft = ret[5];
//    	New_DrawAutoLine(ret[1], pDraftFlag);
    } else {
    	reMappingSign = true;
    	xmlKuljea = ret;
    }

    var xmldom = createXmlDom();
    xmldom = loadXMLString(xmlKuljea);
    var objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    var findstring;
    var lastno;
    var count = objNodes.length;
    if (message.FieldExist("refer"))
        message.PutFieldText("refer", "");

    for(i=1;i < 20;i++) {
        if (message.FieldExist("gongram" + i))
            message.PutFieldText("gongram" + i, "");
    }

    for (i = 0; i < count; i++) {
    	var dataNodes = GetChildNodes(objNodes[i]);
    	if (reMappingSign) {
    		var KyljeaOrder = SelectSingleNodeValue(dataNodes[0], "VALUE").trim();

    		OrderType[KyljeaOrder] = SelectSingleNodeValue(dataNodes[0], "DATA11").trim();
    		OrderTypeName[KyljeaOrder] = SelectSingleNodeValue(dataNodes[4], "VALUE").trim();
    		OrderName[KyljeaOrder] = SelectSingleNodeValue(dataNodes[1], "VALUE").trim();
    		OrderDept[KyljeaOrder] = SelectSingleNodeValue(dataNodes[3], "VALUE").trim();
    		OrderStat[KyljeaOrder] = SelectSingleNodeValue(dataNodes[0], "DATA12").trim();
    		OrderStatName[KyljeaOrder] = SelectSingleNodeValue(dataNodes[5], "VALUE").trim();
    		OrderJobtitle[KyljeaOrder] = SelectSingleNodeValue(dataNodes[2], "VALUE").trim();
    		OrderReason[KyljeaOrder] = SelectSingleNodeValue(dataNodes[0], "DATA7").trim();
    		lastno = i;
    	} else {
    		var KyljeaOrder = getNodeText(dataNodes[0]);
    		var KyljeaName = getNodeText(dataNodes[1]);
    		var KyljeaDeptName = getNodeText(dataNodes[3]);
    		var KyljeaType = getNodeText(dataNodes[16]);
    		var KyljeaTypeName = getNodeText(dataNodes[4]);
    		var KyljeaStat = getNodeText(dataNodes[17]);
    		var KyljeaStatName = getNodeText(dataNodes[5]);
    		var KyljeaJobtitle = getNodeText(dataNodes[2]);
    		var ReasonDoNotApprov = getNodeText(dataNodes[12]);

    		OrderType[KyljeaOrder] = KyljeaType;
    		OrderTypeName[KyljeaOrder] = KyljeaTypeName;
    		OrderName[KyljeaOrder] = KyljeaName;
    		OrderDept[KyljeaOrder] = KyljeaDeptName;
    		OrderStat[KyljeaOrder] = KyljeaStat;
    		OrderStatName[KyljeaOrder] = KyljeaStatName;
    		OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
    		OrderReason[KyljeaOrder] = ReasonDoNotApprov;
    		lastno = i;
    	}
    }

    if (pDraftFlag != "SUSIN") {
        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];

		if (message.FieldExist("lastKyuljikwee"))
			message.PutFieldText("lastKyuljikwee", lastKyuljiwee);

		if (message.FieldExist("lastKyulName"))
			message.PutFieldText("lastKyulName", lastKyulName);
    }
    else {
        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];

		if (message.FieldExist("slastKyuljikwee"))
			message.PutFieldText("slastKyuljikwee", lastKyulName);

		if (message.FieldExist("slastKyulName"))
			message.PutFieldText("slastKyulName", lastKyulName);
    }

    var hapyuiCnt = 1;
    var startIdx = 0;
    var IngFlag = false;
    for (i = 1; i < OrderStat.length; i++) {
        if ((OrderStat[i] == strAprState1 || OrderStat[i] == strAprState1 == "") && IngFlag) {
            startIdx = startIdx;
            break;
        }
        else {
            if ((OrderStat[i] == strAprState2 && OrderType[i] != strAprType7) || OrderStat[i] == strAprState5) {
                startIdx = startIdx + 1;
                IngFlag = true;
            }
            else if (OrderType[i] != strAprType31 && OrderType[i] != strAprType17 && OrderType[i] != strAprType2 && OrderType[i] != strAprType7 && OrderType[i] != strAprType8 && OrderType[i] != strAprType9 && OrderType[i] != strAprType11 && OrderType[i] != strAprType12)
                startIdx = startIdx + 1;
            else if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)
                hapyuiCnt = hapyuiCnt + 1;
        }
    }

    var refer = "";
    referCnt = 1;
    for (i = 1; i < OrderType.length; i++) {
        if (OrderType[i] == strAprType7) {
            if (referCnt == 1) {
                refer = refer + OrderName[i];
                referCnt = referCnt + 1
            }
            else
                refer = refer + ", " + OrderName[i];
        }
    }
    if (refer != "") {
		fieldname = "refer";
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, refer);
    }

    var susinSN = ""
    if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N")) {
        susinSN = pSusinSN
    }

    for (i = startIdx; i <= 20; i++) {
		fieldname = susinSN + "jikwe" + i
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, "");

        fieldname = susinSN + "sign" + i
        if (message.FieldExist(fieldname))
            message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */

        fieldname = susinSN + "seumyungdate" + i
        if (message.FieldExist(fieldname))
            message.PutFieldText(fieldname, "");

        fieldname = susinSN + "approdept" + i;
        if (message.FieldExist(fieldname))
            message.PutFieldText(fieldname, "");
    }
    for (i = 1; i < 50; i++) {
        name = susinSN + "habyuidate" + i;
        if (message.FieldExist(name))
        {
            if(trim(message.GetFieldText(name)) == "")
            {
                name = susinSN + "habyui" + i
                if (message.FieldExist(name))
                    message.PutFieldText(name, "");

                name = susinSN + "habyuisign" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, " ");

                name = susinSN + "habyuipositon" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, "");

                name = susinSN + "habyuiapprodept" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, "");
            }
        }
        else
            break;
    }

    var idx = startIdx;
    var hidx = hapyuiCnt;
    var startOrder = 1;
    for (i = 1; i < OrderStat.length; i++) {
        if ((OrderStat[i] == strAprState2 && OrderType[i] != strAprType7) || OrderStat[i] == strAprState5)
            break;
        else
            startOrder = startOrder + 1;
    }

    var tempLastSignSN = OrderType.length
    for (i = 1; i < OrderType.length; i++) {
        if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40)
            tempLastSignSN = i;
    }

    for (i = startOrder; i < OrderJobtitle.length; i++) {
        if (OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3 || OrderType[i] == strAprType40) {
            var j, chkflag;
            if (count == i || i == tempLastSignSN) {
                var cnt = 20;

                for (k = 1; k <= cnt; k++) {
                    if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N"))
                        signID = pSusinSN + "sign" + k
                    else
                        signID = "sign" + k

                    if (message.FieldExist(signID)) {
                        var LastSignNo1 = k;
                    }
                }
                idx = LastSignNo1;
            }

            if (junGyulFlag == "4") { // 전결 이후 결재안함(003) 결재자들은 서명칸에 표출하지 않음
    			if (OrderType[i] == "003") {
    				continue;
    			}
    		}

            if (OrderType[i] == strAprType3) {
                chkflag = false;
                for (j = startOrder; j < i; j++) {
                    if (OrderType[j] == strAprType4) { // 004 전결
                        chkflag = true;
                        break;
                    }
                }

                if (!chkflag) {
                    fieldname = susinSN + "jikwe" + idx;
                    if (message.FieldExist(fieldname))
                        message.PutFieldText(fieldname, OrderJobtitle[i]);

                    fieldname = susinSN + "sign" + idx;
                    if (message.FieldExist(fieldname))
                        message.PutFieldText(fieldname, OrderName[i] + "\15" + OrderReason[i]);

                    fieldname = susinSN + "approdept" + idx;
                    if (message.FieldExist(fieldname))
                    	message.PutFieldText(fieldname, OrderDept[i]);

                    idx = idx + 1;
                    continue;
                }
            }

            fieldname = susinSN + "jikwe" + idx;
            if (message.FieldExist(fieldname)){
                if (trim(OrderJobtitle[i]) == "") {
                    message.PutFieldText(fieldname , "");
                }
                else
                    message.PutFieldText(fieldname, OrderJobtitle[i]);
            }

            /* 2020-07-27 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
            fieldname = susinSN + "sign" + idx;
            if (message.FieldExist(fieldname)){
            	// 서명필드만 존재
            	if (!message.FieldExist(susinSN + "seumyung" + idx)) {
            		/* 2022-08-04 홍승비 - 전결인 경우 전결 표시를 함께 부여 (단, draftJunGyulFlag를 체크하여 기안 시점에 '전결' 텍스트를 표출한 경우에만 동일하게 표출함) */
            		if (draftJunGyulFlag == '1' && OrderType[i] == strAprType4) {
            			message.PutFieldText(fieldname, strLang6 + "\15" + OrderName[i]);
            		} else {
            			message.PutFieldText(fieldname, OrderName[i]);
            		}
            	}
            	// 서명필드 + 결재자명 필드가 함께 존재
            	else {
                    message.PutFieldText(fieldname, "[NOSLASH]");
            	}
            }

            fieldname = susinSN + "seumyung" + idx;
            if (message.FieldExist(fieldname)) {
            	message.PutFieldText(fieldname, OrderName[i]);
            }

            fieldname = susinSN + "approdept" + idx;
            if (message.FieldExist(fieldname)) {
            	message.PutFieldText(fieldname, OrderDept[i]);
            }
            idx = idx + 1;
        }

        if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9) { // 개인순차합의, 개인병렬합의
            fieldname = susinSN + "habyui" + hidx;
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, OrderDept[i]);
            }

            /* 2020-07-27 홍승비 - 합의자명 필드가 존재하지 않는 경우, 합의자 사인 필드에 이름 표출하도록 수정 */
            fieldname = susinSN + "habyuisign" + hidx;
            if (message.FieldExist(fieldname)) {
            	// 합의자 사인 필드만 존재, 합의자명 필드 없음
            	if (message.FieldExist("habyuija" + hidx)) {
            		message.PutFieldText(fieldname, OrderName[i]);
            	}
            }

            fieldname = susinSN + "habyuija" + hidx;
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, OrderName[i]);
            }

            fieldname = susinSN + "habyuipositon" + hidx;
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, OrderJobtitle[i]);
            }

            fieldname = susinSN + "habyuiapprodept" + hidx;
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, OrderDept[i]);
            }
            hidx = hidx + 1;
        }

        if (OrderType[i] == strAprType11 || OrderType[i] == strAprType12) { // 부서순차합의, 부서병렬합의
        	fieldname = susinSN + "habyui" + hidx;
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, OrderDept[i]);
            }

            fieldname = susinSN + "habyuisign" + hidx;
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, OrderDept[i]);
            }

            fieldname = susinSN + "habyuipositon" + hidx;
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, OrderJobtitle[i]);
            }

            fieldname = susinSN + "habyuiapprodept" + hidx;
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, OrderDept[i]);
            }
            hidx = hidx + 1;
        }
    }
    if (isSplit == "Y")
        setSignSlash("sign", susinSN);

    if (pADMIN == "N") {
        if (chkflag)
            setMenuBar("btnJunKyul", false);
        else
            setMenuBar("btnJunKyul", false);
    }
}

function setSignSlash(pSignKinds, pSusin) {
    var i, j;
    var fieldName;
    var field, fieldvalue;
    var tempFieldName;
    var fields = message.GetFieldsList();
    for (i = 1; i < 21; i++) {
        fieldName = pSusin + pSignKinds + i;
        if (message.FieldExist(fieldName)) {
            fieldvalue = trim(message.GetFieldText(fieldName));
            message.MoveToField(fieldName);
            var act = message.HwpCtrl.CreateAction("CellBorder");
            var set = act.CreateSet();
            act.GetDefault(set);
            if (fieldvalue == "") {
                set.SetItem("DiagonalType", 1);
                set.SetItem("SlashFlag", 0x02);
            }
            /* 2020-07-24 홍승비 - 전자결재 일반버전의 경우, 서명과 결재자명 필드 구분하도록 수정 */
            else if (trim(fieldvalue) == "[NOSLASH]") {
                set.SetItem("SlashFlag", 0x00);
            	message.PutFieldText(fieldName, " ");
            }else
                set.SetItem("SlashFlag", 0x00);
            
            act.Execute(set);
        }
    }
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
	if (message.FieldExist("refer"))
		message.PutFieldText("refer", "");
	
	for(i=1;i < 20;i++) {
		if (message.FieldExist("gongram" + i))
			message.PutFieldText("gongram" + i, "");
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
		
		if (message.FieldExist("lastKyuljikwee"))
			message.PutFieldText("lastKyuljikwee", lastKyuljiwee);

		if (message.FieldExist("lastKyulName"))
			message.PutFieldText("lastKyulName", lastKyulName);
	} else {
		lastKyulName = OrderName[LastSignSN]
		lastKyuljiwee = OrderJobtitle[LastSignSN]
		if (message.FieldExist("slastKyuljikwee"))
			message.PutFieldText("slastKyuljikwee", lastKyulName);

		if (message.FieldExist("slastKyulName"))
			message.PutFieldText("slastKyulName", lastKyulName);
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
		if (message.FieldExist(fieldname))
			message.PutFieldText(fieldname, refer);
	}	

	
	var susinSN = ""
	if(pDraftFlag == "SUSIN")
	{
		susinSN = pSusinSN 
	}

	
	for(i=startIdx;i < 20;i ++)
	{
		fieldname = susinSN + "jikwe" + i
		if (message.FieldExist(fieldname))
		{
			message.PutFieldText(fieldname, "");
					
			fieldname = susinSN + "sign" + i
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */

			fieldname = susinSN + "seumyungdate" + i
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, "");
		}
		else break;
	}	
	for(i=1;i<20;i++)
	{
		name = susinSN + "habyuisign" + i;
		if (message.FieldExist(name))
		{
			if(trim(message.GetFieldText(name)) == "")
			{
				name = susinSN + "habyui" + i
				if (message.FieldExist(name))
					message.PutFieldText(name, "");
				  			
				name = susinSN + "habyuisign" + i;
				if (message.FieldExist(name))
					message.PutFieldText(name, " ");
					  		    
				name = susinSN + "habyuipositon" + i;
				if (message.FieldExist(name))
					message.PutFieldText(name, "");

				name = susinSN + "habyuidate" + i;
				if (message.FieldExist(name))
					message.PutFieldText(name, "");
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
					if (message.FieldExist(fieldname))
					{
						message.PutFieldText(fieldname, OrderJobtitle[i]);
						if(OrderSuggester[i] == "Y")
							message.AppendFieldText(fieldname, strLang75);						
						if(OrderReporter[i] == "Y")
							message.AppendFieldText(fieldname, strLang76);						
					}
	  				  				
	  				fieldname = susinSN + "sign" + idx;
	  				if (message.FieldExist(fieldname))
	  					message.PutFieldText(fieldname, OrderName[i] + "\15" + OrderReason[i]);
	  				  				
	  				idx = idx + 1;
	  				continue;
	  			}
	  		}
	  		
			fieldname = susinSN + "jikwe" + idx;
			if (message.FieldExist(fieldname))
			{
				message.PutFieldText(fieldname, OrderJobtitle[i]);
				if(OrderSuggester[i] == "Y")
					message.AppendFieldText(fieldname, strLang75);						
				if(OrderReporter[i] == "Y")
					message.AppendFieldText(fieldname, strLang76);						
			}
			
			fieldname = susinSN + "sign" + idx;
			if (message.FieldExist(fieldname))
			{
			}
			idx = idx + 1;
		}
		
		if (OrderType[i] == strAprType8 ||OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)		
		{
			fieldname = susinSN + "habyui" + hidx;
			if (message.FieldExist(fieldname))
				message.PutFieldText(fieldname, OrderDept[i]);
		
			fieldname = susinSN + "habyuisign" + hidx;
			if (message.FieldExist(fieldname))
			{
			}			

			fieldname = susinSN + "habyuipositon" + hidx;
			if (message.FieldExist(fieldname))
			{
				message.PutFieldText(fieldname, OrderJobtitle[i]);
				if(OrderSuggester[i] == "Y")
					message.AppendFieldText(fieldname, strLang75);						
				if(OrderReporter[i] == "Y")
					message.AppendFieldText(fieldname, strLang76);						
			}

			hidx = hidx + 1;
		}			
	}
	setMenuBar("btnJunKyul", false);
}


var aprsign1_cross_dialogArguments = new Array();
function openSingUI(parameter) {
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
  
	//if (SignNodeList.length != 0) { 
		var parameter = pingUserID;
		/*var url = "/ezApprovalG/aprSign.do";
		var feature	= "status:no;dialogWidth:350px;dialogHeight:310px;help:no;scroll:no;edge:sunken";
		var ret = window.showModalDialog(url,parameter,feature);*/
		aprsign1_cross_dialogArguments[0] = parameter;
        aprsign1_cross_dialogArguments[1] = openSingUI_Complete;
        DivPopUpShow(350, 310, "/ezApprovalG/aprSign.do");
	/*
	} else {
		var ret = "NAME";
		// 결재 백단 로직으로 변경 
        Approv_Complete_BackEnd(ret);
		// Approve_complete(ret);
		//GetHTML(Approve_complete);
	}
	*/
}

function SetAutoPropFinal()
{
  try{
    var CurrentDate;
    CurrentDate = getGyulJeDate();
    
	var Fields = message.GetFieldList();
  
	for (i = 0 ; i < Fields.length ; i ++)
	{
		if(pDraftFlag == "DRAFT" )
		{
			switch (Fields[i])
			{
	  			case "sentdate" :
	  				message.PutFieldText(Fields[i], CurrentDate);
	  		  		break;
 			}
	  	}
	}  
  }catch(e){	
	alert(e.description);
  }
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

	if (message.FieldExist("memo"))
		message.PutFieldText("memo", content);
}

function putSignXML(SignXML) {
  var retVal = false;
  try {
	var NodeList;
	NodeList = SignXML.selectNodes("SIGNINFOS/SIGNINFO");
	if (NodeList.length > 0) {
	    var allTypeB = typeof draftAllTypeB != "undefined" && typeof pDocIDAry != "undefined" && typeof anCnt == "number" && draftAllTypeB == "Y" && pDocIDAry.length > 2 && anCnt > 1;
		for (i=0; i<NodeList.length; i++) {
		    var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
		    var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
		    var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));
			
			if (message.FieldExist(SignName)) {		
			    retVal = true;	
				if (SignType == "TEXT") {
					message.PutFieldText(SignName, SignCont);
				} else if (SignType == "HTML") {
					message.AppendFieldText(SignName, SignCont);
				} else if (SignType == "PROXY") {
					message.PutFieldText(SignName, " ");
					message.AppendFieldText(SignName, strLang8);
//					message.InsertPicture(SignName, hostURL + escape(SignCont), null);
                    if(allTypeB){
                        for(var j = 0; j < anCnt; j++){
                            message.InsertPicture(SignName + "{{" + j + "}}", hostURL + escape(SignCont), null);    
                        }
                    }else{
                        message.InsertPicture(SignName, hostURL + escape(SignCont), null);
                    }
				} else if (SignType == "IMAGE") {
				    var img = SignCont.split("::");
				    message.PutFieldText(SignName, "");
					if(img.length >= 1) {
//					    message.InsertPicture(SignName, hostURL + escape(img[0]), null);
                        if(allTypeB){
                            for(var j = 0; j < anCnt; j++){
                                message.InsertPicture(SignName + "{{" + j + "}}", hostURL + escape(img[0]), null);    
                            }
                        }else{
                            message.InsertPicture(SignName, hostURL + escape(img[0]), null);
                        }
					}
				    if(img.length >= 2)
				    	message.AppendFieldText(SignName, img[1]);
				}			
			}
		}
	}
  } catch(e) {
	alert("putSignXML : " + e);
	return false;
  }
  return retVal;
}

function setPublicFlag() {
	if (!message.FieldExist("publication"))
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

	message.PutFieldText("publication", PublicText);
}

function getHistory() {	
    var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + "hwp";
	centerOpenWindow(URL, 740, 450);
}

function centerOpenWindow(wfileLocation, wWeight, wHeight) {
	try {
		if (CrossYN()) {
        	if (isIE() && !document.getElementById("iFrameLayer")) {
        		var heigth = window.screen.availHeight;
        		var width = window.screen.availWidth;
        		var left = (width - wWeight) / 2;
        		var top = (heigth - wHeight) / 2;
        		window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
        	} else {
        		DivPopUpShow(wWeight, wHeight, wfileLocation);
        	}
        } else {
            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;
            var left = (width - wWeight) / 2;
            var top = (heigth - wHeight) / 2;
            window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
        }
	} catch(e) {
		alert("centerOpenWindow :: " + e);
	}
}

function setRecevInfo(ret) {
    var precipent = "";
    var precipents = "";
    var recipflag = true;
    var xmldom = createXmlDom();
    xmldom.async = false;
    xmldom = loadXMLString(ret);

    if (xmldom.documentElement.length == 0) return;

    var rows = xmldom.documentElement.childNodes
    if (message.FieldExist("hrecipients"))
        message.PutFieldText("hrecipients", "");

    if (message.FieldExist("recipient"))
        message.PutFieldText("recipient", "");

    if (message.FieldExist("recipients"))
        message.PutFieldText("recipients", "");

    for (var i = rows.length - 1; i >= 0; i--) {
    	var row = rows[i];
        var params = new Array();
        params[0] = "0";

        var dataNodes = GetChildNodes(rows[i], params);
        if (recipflag) {
        	if (getNodeText(dataNodes[3]) == "Y") {
				if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
					precipent = approvalFlag == "G" ? strLang92 : strLangS68;
					precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
				} else {
					precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
					precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
				}
                recipflag = false;
            } else {
            	if (isExtDoc == "Y") {
					if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
						precipent = approvalFlag == "G" ? strLang92 : strLangS68;
						precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
					} else {
						precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
						precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
					}
                    recipflag = false;
                } else {
					if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
						precipent = approvalFlag == "G" ? strLang92 : strLangS68;
						precipents = getNodeText(dataNodes[0]);
					} else {
						precipent = getNodeText(dataNodes[0]);
						precipents = getNodeText(dataNodes[0]);
					}
                    recipflag = false;
                }
            }
        } else {
        	 precipent = approvalFlag == "G" ? strLang92 : strLangS68;

             if (getNodeText(dataNodes[3]) == "Y") {
                 precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
             } else {
                 if (isExtDoc == "Y")
                     precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                 else
                     precipents = precipents + ", " + getNodeText(dataNodes[0]);
             }
        }
    }
    
    if (message.FieldExist("recipient")) {
        if (precipent == strLang92) {
            message.PutFieldText("recipient", precipent);
            if (message.FieldExist("recipients")) {
                message.PutFieldText("recipients", precipents);
                if (message.FieldExist("hrecipients"))
                    message.PutFieldText("hrecipients", strLang129);
            }
        }
        else {
            message.PutFieldText("recipient", precipent);
            if (precipents == "") {
                if (message.FieldExist("hrecipients"))
                    message.PutFieldText("hrecipients", "");

                if (message.FieldExist("recipients"))
                    message.PutFieldText("recipients", "");
            }
        }
    }
}

/* 2023-02-08 홍승비 - WHWP 문서의 수정이력 비교 기능을 위해 isBeforeDoc, beforeDocURL 파라미터 추가 */
/* 2020-02-27 홍승비 - mht 문서 수정이력 비교용 파라미터 추가 (데이터 삽입 시 오류 방지) */
function UpdateDocHistory(pHtml, isBeforeDoc, beforeDocURL) {
	var xmlhttp2 = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pHtml", pHtml);
	createNodeAndInsertText(xmlpara, objNode, "mode", "hwp");
    createNodeAndInsertText(xmlpara, objNode, "ISBEFOREDOC", isBeforeDoc);

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
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", ConvMakeXMLString(arr_userinfo[15]));
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", ConvMakeXMLString(arr_userinfo[16]));
        createNodeAndInsertText(xmlpara, objNode, "ORGCOMPANYID", orgCompanyID);
        createNodeAndInsertText(xmlpara, objNode, "ISBEFOREDOC", isBeforeDoc);
        createNodeAndInsertText(xmlpara, objNode, "BEFOREDOCURL", beforeDocURL);
		if(editVersionYN && editVersionYN == "Y"){
			createNodeAndInsertText(xmlpara, objNode, "editVersion", editVersion);
			createNodeAndInsertText(xmlpara, objNode, "editMode", editMode);
		}
        
        xmlhttp.open("POST", "/ezApprovalG/updateDocHistory.do", false);
        xmlhttp.send(xmlpara);
        
        if (xmlhttp != null && xmlhttp.readyState == 4) {
         	 if (xmlhttp.status == 200) {
				returnURL = xmlhttp.responseText;
				if(!(typeof draftAllTypeB != "undefined" && typeof anCnt != "undefined" && draftAllTypeB == "Y" && anCnt > 1)){
				    snapshotCode = getSnapshotCode();
				}
			 } else {
         		 var pAlertContent = strLang89;
                OpenAlertUI(pAlertContent);
         	 }
       }
   } else {
       var pAlertContent = strLang90;
       OpenAlertUI(pAlertContent);
   }
    
    return returnURL;
}

function setPublicFlag2() {
    if (!message.FieldExist("publication")) return;
    var PublicType = pPublicityYN.substring(0, 1);

    if (PublicType == "Y" || PublicType == "B")
        PublicText = strLang82;
    else if (PublicType == "N")
        PublicText = strLang84;
    else
        PublicText = " ";
    
    message.PutFieldText("publication", PublicText);
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

/* 2024-06-24 양지혜 - 지정반송 > 결재상태 업데이트 및 문서저장 */
function returnByDesignation (ret, returnUserSN) {
	pHasOpinionYN = "Y";
	UpdateLineHistory(); // '변경내역' 업데이트

	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateReturnByDesignation.do",
		data : {
			returnUserSN : returnUserSN,
			docID : pDocID
		}
	});

	signDel(returnUserSN); // WHWP 서명제거
	GetHTML(before_SaveFile); // 파일 저장
	process_AfterApprove("2"); // 알림창
}

/* 2024-06-24 양지혜 - 지정반송 > WHWP 결재 사인 제거 */
function signDel(returnUserSN) {
	for (var i = returnUserSN; i < 10; i++) {
		if (message.FieldExist("sign" + i)) {
			message.PutFieldText("sign" + i, "");
		}
		if (message.FieldExist("seumyungdate" + i)) {
			message.PutFieldText("seumyungdate" + i, "");
		}
	}
}