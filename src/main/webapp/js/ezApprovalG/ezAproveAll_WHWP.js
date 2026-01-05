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

	
	if (parent.pAprLineType ==  strAprType9 || parent.pAprLineType ==  strAprType11 || parent.pAprLineType ==  strAprType12)
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
  	
		habyui = phabyuisign + parent.pAprMemberSN;
		if (FieldExist(habyui))
		{
			PutFieldText(habyui, strLang4);
			field.value = strLang4;
			SignContent[signCnt] = strLang4;
			signInfo[signCnt] = habyui
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = habyui;					
					
			signCnt = signCnt + 1
			SingFlag = false; 
		}
		
		var habyuidateID = phabyuidate + parent.pAprMemberSN;
		if (FieldExist(habyuidateID))
		{
			PutFieldText(habyuidateID, s);
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
function AprrovMappingSign(ret, maxIdx) {
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
	if (parent.LastKyulSN == parent.pAprMemberSN || parent.pAprLineType == strAprType4 || parent.pAprLineType == strAprType16) {
		OpinionText = getSignDate() + "\15";
	}
	
	// 8 : 개인순차협조, 9 : 개인병렬협조, 11 : 부서순차협조, 12 : 부서병렬협조
	if (parent.pAprLineType == strAprType8 || parent.pAprLineType == strAprType9 || parent.pAprLineType == strAprType11 || parent.pAprLineType == strAprType12) {
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
		var habyuidateID = phabyuidate + parent.pAprMemberSN;
		if (FieldExist(habyuidateID)) {
			PutFieldText(habyuidateID, s);
			parent.signInfo[signCnt] = habyuidateID;
			parent.SignType[signCnt] = "TEXT";
			parent.SignName[signCnt] = habyuidateID;
			parent.SignContent[signCnt] = s;					
			signCnt = signCnt + 1;
			parent.newSignInfo.push(habyuidateID);
		}
		
		var phabyuijikweeID = phabyuijikwee + parent.pAprMemberSN;
		if (FieldExist(phabyuijikweeID)) {
			PutFieldText(phabyuijikweeID, GetFieldText(phabyuijikweeID) + PositionText);
		}
  	
		var habyui = phabyuisign + parent.pAprMemberSN;
		if (FieldExist(habyui)) {
			if (ret != "NAME" && ret != "") { // 서명이 이미지인 경우 
				PutFieldText(habyui, "");
				
				// 대리결재 시, 代 문자를 이미지 서명 위에 붙임
				if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
					PrependFieldText(habyui, strLang8 + "\15");
				}
				parent.docApprovSignChkCnt ++;
				
				parent.signInfo[signCnt] = habyui;
				parent.SignName[signCnt] = habyui;
				parent.newSignInfo.push(habyui);
				
				if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
					parent.SignType[signCnt] = "IMAGE";
					parent.SignContent[signCnt] = ret + "::" + strLang8;
				}
				else {
					parent.SignType[signCnt] = "IMAGE";
					parent.SignContent[signCnt] = ret;
				}
				
				InsertPicture(habyui, hostURL + escape(ret), AprrovMappingSign_after);
				
				signCnt = signCnt + 1;
				SingFlag = true;
			}
			else {
				// 대리결재 시, 代 문자를 문자서명 좌측에 붙임
				if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
					PutFieldText(habyui, strLang8 + arr_userinfo[2]);	
					parent.SignContent[signCnt] = strLang8 + arr_userinfo[2];
				}
				else {
					PutFieldText(habyui, arr_userinfo[2]);	
					parent.SignContent[signCnt] = arr_userinfo[2];
				}
				parent.docApprovSignChkCnt ++;
	
				parent.signInfo[signCnt] = habyui;
				parent.SignType[signCnt] = "TEXT";
				parent.SignName[signCnt] = habyui;
				signCnt = signCnt + 1;
				SingFlag = false; 
				parent.newSignInfo.push(habyui);
			}
		}
	}
	else if (parent.pAprLineType == strAprType2 || parent.pAprLineType == strAprType7) { // 2 : 확인, 7 : 참조
		// 실제로 서명이 부여되지 않는 분기이므로, 다음 진행을 위해 전역변수를 증가시킨다.
		parent.docApprovSignChkCnt ++;
	}
	else if (parent.pAprLineType == strAprType15) { // 15 : 후열
		signID = "gamsasign1"; 
		if (FieldExist(signID)) {
			PutFieldText(signID, arr_userinfo[2] + "\15" + s);
			parent.docApprovSignChkCnt ++;
			
			parent.signInfo[signCnt] = signID;
			parent.SignName[signCnt] = signID;
			parent.SignType[signCnt] = "TEXT";
			parent.SignContent[signCnt] = arr_userinfo[2] + "\15" + s;
			parent.newSignInfo.push(signID);
			signCnt = signCnt + 1;
		}
	}
	else if (ret == "BANSONG" && parent.KuyjeType == "001") {
        var pAprMemberSignSN = parent.pAprMemberSN;
        var signID;
        var seumyungID;
        var seumyungdateID;

        signID = "sign" + pAprMemberSignSN;
        seumyungID = "seumyung" + pAprMemberSignSN;
        seumyungdateID = "seumyungdate" + pAprMemberSignSN;

        if (FieldExist(signID)) {
            var SContent = strLang4 + "\15" + arr_userinfo[2];
            PutFieldText(signID, SContent);
            parent.docApprovSignChkCnt ++;

            parent.signInfo[signCnt] = signID;
            parent.SignName[signCnt] = signID;
            parent.SignType[signCnt] = "TEXT";
            parent.SignContent[signCnt] = SContent;
            parent.newSignInfo.push(signID);
            signCnt = signCnt + 1;
        }

        if (FieldExist(seumyungID)) {
            PutFieldText(seumyungID, arr_userinfo[5]);
            parent.signInfo[signCnt] = seumyungID;
            parent.SignName[signCnt] = seumyungID;
            parent.SignType[signCnt] = "TEXT";
            parent.SignContent[signCnt] = arr_userinfo[5];
//            signCnt = signCnt + 1;
        }

        if (FieldExist(seumyungdateID)) {
            PutFieldText(seumyungdateID, s);
            parent.signInfo[signCnt] = seumyungdateID;
            parent.SignName[signCnt] = seumyungdateID;
            parent.SignType[signCnt] = "TEXT";
            parent.SignContent[signCnt] = s;
//            signCnt = signCnt + 1;
        }
    }
    else if (approvalFlag == "S" && parent.pAprLineType == strAprType4) { // 4 : 전결
    	var pAprMemberSignSN = parent.pAprMemberSN;
        var signID;
        var seumyungID;
        var seumyungdateID;
        var LastKyulSN = parent.LastKyulSN;

        var pSusinSN2 = "";
        // 일괄은 수신이 없음
//    	if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N")) {
//    		pSusinSN2 = pSusinSN;
//    	}

        if (junGyulFlag == "1") {
    		/* 2018-04-27 천성준 - 전결자만 결재칸에 전결 표시 >> 전결자 결재칸에 전결String */
        	signID = pSusinSN2 + "sign" + pAprMemberSignSN;

        	var field = message.GetListItem(fields, signID);
            if (FieldExist(signID)) {
                PutFieldText(strLang6);
            }

            //최종결재자 인덱스 구하기
            for (var i=0; i<20; i++) {
            	signID = pSusinSN2 + "sign" + i;

                if (FieldExist(signID)) {
                	LastKyulSN = i;
                }
            }

            //최종결재자 결재칸에 싸인
        	signID = pSusinSN2 + "sign" + LastKyulSN;
            seumyungID = pSusinSN2 + "jikwe" + LastKyulSN;
            seumyungdateID = pSusinSN2 + "seumyungdate" + LastKyulSN;

            if (FieldExist(seumyungdateID)) {
                PutFieldText(seumyungdateID , s);
            }

            if (FieldExist(signID)) {
                if (ret != "NAME") { //이미지 서명
                    PutFieldText(signID, "");

                    if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        AppendFieldText(signID, strLang8, true);
                    }

                    if(!FieldExist(seumyungdateID))
                        AppendFieldText(signID, OpinionText, true);

                    parent.docApprovSignChkCnt ++;

                    parent.signInfo[signCnt] = signID;
                    parent.SignName[signCnt] = signID;
                    parent.newSignInfo.push(signID);

                    if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        parent.SignType[signCnt] = "IMAGE";
                        parent.SignContent[signCnt] = ret+"::"+strLang8;
                    }
                    else {
                        parent.SignType[signCnt] = "IMAGE";
                        parent.SignContent[signCnt] = ret;
                    }

                    InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);

                    signCnt = signCnt + 1;
                    SingFlag = true;
                }
                else { //문자 서명
                    if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        PutFieldText(signID, strLang8 + "\15" + arr_userinfo[2]);
                        contents = strLang8 + "\15" + arr_userinfo[2];
                    }
                    else {
                        PutFieldText(signID, arr_userinfo[2]);
                        contents = arr_userinfo[2];
                    }

                    if (!FieldExist(seumyungdateID)) {
                        PrependFieldText(signID, OpinionText);
                        contents = OpinionText + contents;
                    }

                    if (parent.pAprLineType == strAprType4) {
                        PrependFieldText(signID, strLang6);
                        contents = strLang6 + contents;
                    }

                    parent.docApprovSignChkCnt ++;

                    parent.signInfo[signCnt] = signID;
                    parent.SignName[signCnt] = signID;
                    parent.SignType[signCnt] = "TEXT";
                    parent.SignContent[signCnt] = contents;
                    signCnt = signCnt + 1;
                    SingFlag = false;
                    parent.newSignInfo.push(signID);
                }
            }
    	} else if (junGyulFlag == "4") {
    		signID = pSusinSN2 + "sign" + pAprMemberSignSN;
            seumyungID = pSusinSN2 + "jikwe" + pAprMemberSignSN;
            seumyungdateID = pSusinSN2 + "seumyungdate" + pAprMemberSignSN;

            if (FieldExist(seumyungdateID)) {
                PutFieldText(seumyungdateID , s);
            }

            if (FieldExist(seumyungID)) {
                PutFieldText(seumyungID , GetFieldText(seumyungID) + PositionText);
            }

            var field = message.GetListItem(fields, signID);
            if (field) {
                if (ret != "NAME") { //이미지 서명
                    PutFieldText(signID, "");

                    if(!FieldExist(seumyungdateID))
                        AppendFieldText(signID, OpinionText, true);

                    parent.docApprovSignChkCnt ++;

                    parent.signInfo[signCnt] = signID;
                    parent.SignName[signCnt] = signID;
                    parent.newSignInfo.push(signID);

                    if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        parent.SignType[signCnt] = "IMAGE";
                        parent.SignContent[signCnt] = ret+"::"+strLang8;
                    }
                    else {
                        parent.SignType[signCnt] = "IMAGE";
                        parent.SignContent[signCnt] = ret;
                    }

                    InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);

                    signCnt = signCnt + 1;
                    SingFlag = true;
                }
                else { // 문자 서명
                    if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                        PutFieldText(signID, strLang8 + "\15" + arr_userinfo[2]);
                        contents = strLang8 + "\15" + arr_userinfo[2];
                    }
                    else {
                        PutFieldText(signID, arr_userinfo[2]);
                        contents = arr_userinfo[2];
                    }

                    if (!FieldExist(seumyungdateID)) {
                        PrependFieldText(signID, OpinionText);
                        contents = OpinionText + contents;
                    }

                    if (parent.pAprLineType == strAprType4) {
                        PrependFieldText(signID, strLang6);
                        contents = strLang6 + contents;
                    }

                    parent.docApprovSignChkCnt ++;

                    parent.signInfo[signCnt] = signID;
                    parent.SignName[signCnt] = signID;
                    parent.SignType[signCnt] = "TEXT";
                    parent.SignContent[signCnt] = contents;
                    signCnt = signCnt + 1;
                    SingFlag = false;
                    parent.newSignInfo.push(signID);
                }
            }
    	}
        //TODO: junGyulFlag 2,3 일때 처리
    }
	else {
		var pAprMemberSignSN = parent.pAprMemberSN;
		var signID;
		var seumyungID;
		var seumyungdateID;
		var LastKyulSN = parent.LastKyulSN;
		var pAprMemberSN = parent.pAprMemberSN;

        if (approvalFlag == "S") {
            if (LastKyulSN == pAprMemberSN || parent.pAprLineType == strAprType4) {
                for (i = 1; i <= 20; i++) {
                    signID = "sign" + i;

                    if (FieldExist(signID)) {
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
		} else{
			signID = "sign" + pAprMemberSignSN;
			seumyungID = "jikwe" + pAprMemberSignSN;
   			seumyungdateID = "seumyungdate" + pAprMemberSignSN;
		}
		
		if (FieldExist(seumyungdateID)) {
			PutFieldText(seumyungdateID, s);
			parent.newSignInfo.push(seumyungdateID);
			
			/* 2023-10-05 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
			parent.signInfo[signCnt] = seumyungdateID;
			parent.SignName[signCnt] = seumyungdateID;
			parent.SignType[signCnt] = "TEXT";
			parent.SignContent[signCnt] = s;
			signCnt = signCnt + 1;
		}
		
		if (FieldExist(seumyungID)) {
			PutFieldText(seumyungID, GetFieldText(seumyungID) + PositionText);
		}
		
		if (parent.pAprLineType == strAprType16) { // 대결
			if (FieldExist(signID)) {
				// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
				if (FieldExist(seumyungdateID)) {
				    OpinionText = "\15";
				}
				
	  			if (ret != "NAME") {
	  				PutFieldText(signID, "");
                    var content = "";
                    
                    // 대리결재 시, 代 문자를 이미지 서명 위에 붙임 (대결 및 서명일자 표기보다는 아래에 위치)
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
						PrependFieldText(signID, strLang8 + "\15");
						content = strLang8 + "\15";
					}
					
	  				PrependFieldText(signID, strLang7 + OpinionText);
	  				parent.docApprovSignChkCnt ++;
	  				
	  				InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
	  				
	  				parent.signInfo[signCnt] = signID;
	  				parent.SignName[signCnt] = signID;
	  				parent.SignType[signCnt] = "IMAGE";
	  				parent.SignContent[signCnt] = ret + "::" + strLang7 + OpinionText + content;
	  				parent.newSignInfo.push(signID);
			
	  				signCnt = signCnt + 1;
	  				SingFlag = true;
	  			}
	  			else {
	  			    var content = "";
	  			    
	  			    // 대리결재 시, 代 문자를 문자서명 좌측에 붙임
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
						PutFieldText(signID, OpinionText + strLang8 + arr_userinfo[2]);
	  			        content = OpinionText + strLang8 + arr_userinfo[2];
					} else {
						PutFieldText(signID, OpinionText + arr_userinfo[2]);
						content = OpinionText + arr_userinfo[2];
					}
					
					PrependFieldText(signID, strLang7);
					parent.docApprovSignChkCnt ++;
					content = strLang7 + content ;
					
					parent.signInfo[signCnt] = signID;
					parent.SignName[signCnt] = signID;
					parent.SignType[signCnt] = "TEXT";
					parent.SignContent[signCnt] = content;
	  				signCnt = signCnt + 1;
	  				SingFlag = false;
	  				parent.newSignInfo.push(signID);
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
		if (FieldExist(signID)) {
			if (DekyulFlag && parent.pAprLineB4type == strAprType4) { // 현재 결재자가 대결자이면서 다음 결재자가 전결인 경우 (4: 전결)
				// 대결로 이미지 서명을 부여하는 경우, 웹한글함수인 InsertPicture를 사용하기 때문에 삽입이 비동기적으로 완료된다.
				// 따라서 리턴 시 콜백함수를 호출할때, 전결서명이 들어가있지 않은 상태로 콜백이 진행되고 전결서명은 빠진 상태로 hwp 파일을 저장한다.
				// 추후 검토 필요 (2023-12-13 기준 해결되지 않은 표준모듈 오류이므로 참고. 서명 데이터 재맵핑 기능으로 화면상 표출은 정상화됨.)
				PutFieldText(signID, strLang6);
				// 대결 직후 전결 필드에 자동으로 서명을 부여하는 경우, 서명완료 카운트는 증가시키지 않는다. (안 당 한번만 증가시켜야 함)
				//parent.docApprovSignChkCnt ++;
				
				parent.signInfo[signCnt] = signID;
				parent.SignName[signCnt] = signID;
				parent.SignType[signCnt] = "TEXT";
				parent.SignContent[signCnt] = strLang6;
				parent.newSignInfo.push(signID);
			        
	  			signCnt = signCnt + 1;
			} else if (DekyulFlag) {
				
			}
			else {
			    var contents = "";
			    // 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
				if (FieldExist(seumyungdateID)) {
				    OpinionText = "\15";
				}
				
	  			if (ret != "NAME") { // 이미지서명
	  				PutFieldText(signID, "");
	  				
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
						// 이미지 서명의 경우, 代 문자를 이미지 서명 위에 붙임 (대결/전결, 서명일자 표기보다는 아래에 위치)
						contents = strLang8 + "\15";
					}
					
					if (parent.pAprLineType == strAprType4) { // 전결
						OpinionText = strLang6 + OpinionText;
	  				}
					
					// OpinionText에 대결/전결/서명일자 표기 없이 개행문자만 존재하는 경우, 공백으로 치환
					if (OpinionText == "\15") {
						OpinionText = "";
					}
					
					contents = OpinionText + contents;
					parent.docApprovSignChkCnt ++;
					
					PrependFieldText(signID, contents);
	  				InsertPicture(signID, hostURL + escape(ret), AprrovMappingSign_after);
	      
	  				parent.signInfo[signCnt] = signID;
	  				parent.SignName[signCnt] = signID;
	  				parent.SignType[signCnt] = "IMAGE";
	  				parent.SignContent[signCnt] = ret + "::" + contents;
	  				parent.newSignInfo.push(signID);
		        
	  				signCnt = signCnt + 1;
	  				SingFlag = true;
	  			}
	  			else { // 문자서명
					if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) { // 대리결재
						contents = strLang8 + arr_userinfo[2]; // 문자서명 시, 代 문자와 결재자명 사이에는 공백/개행 없음
					}
					else {
						contents = arr_userinfo[2];		
					}
					
					if (parent.pAprLineType == strAprType4) {
						OpinionText = strLang6 + OpinionText;
	  				}
	  				
					// OpinionText에 대결/전결/서명일자 표기 없이 개행문자만 존재하는 경우, 공백으로 치환
					if (OpinionText == "\15") {
						OpinionText = "";
					}
					
					contents = OpinionText + contents;
					
					PutFieldText(signID, contents);
					
					parent.docApprovSignChkCnt ++;
					
					parent.signInfo[signCnt] = signID;
					parent.SignName[signCnt] = signID;
					parent.SignType[signCnt] = "TEXT";
					parent.SignContent[signCnt] = contents;
	  				signCnt = signCnt + 1;
	  				SingFlag = false;
	  				parent.newSignInfo.push(signID);
	  			}
	  		}
		}
	}
	//return signInfo;   
	if (ret == "NAME") {
		// 서명 부여가 완료된 안의 갯수를 체크하여, 최종 안까지 부여가 전부 끝났을때 부모창의 GetHTML를 호출한다.
		if (parent.docApprovSignChkCnt == maxIdx) {
			parent.GetHTML(parent.Before_SaveApproveInfo);
		}
	}
}

function AprrovMappingSign_after() {
	if (parent.docApprovSignChkCnt == parent.docMaxTabNumForApprov) { // 최종 안까지 전부 서명부여가 완료된 경우, 결재파일+DB정보저장 진입
		parent.GetHTML(parent.Before_SaveApproveInfo);
	}
}

function putJunkyulSign(signID) {
	if (FieldExist(signID)) {
		PutFieldText(signID, strLang6);	
	}
}

function putKyuljeSign(signID) {
}

function UndoSignInfo(signInfo) {
	var cnt;
	for (cnt = 0; cnt < signInfo.length; cnt++) {
		if (FieldExist(signInfo[cnt])) {
			PutFieldText(signInfo[cnt], " ");
		}
	}
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
		
		// 각 안 내부로 접근하여 맵핑하도록 수정
		var currIfrm = document.getElementById("ifrm" + currentTabIdx);
		currIfrm.contentWindow.makeOpinionList(Rtnxml);
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
		
		apropinion_cross_dialogArguments[0] = parameter;
	    if (CompleteFunction != undefined) {
	        apropinion_cross_dialogArguments[1] = CompleteFunction;
	    } else {
	        apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete;
	    }
	    DivPopUpShow(530, 520, url);
	} catch (e) {
		alert("openOpinionUI_New ::: " + e);
	}
}

function openOpinionUI_New_Complete(ret) {
	DivPopUpHidden();
	// 각 안 내부로 접근하여 맵핑하도록 수정
	var currIfrm = document.getElementById("ifrm" + currentTabIdx);
	
	if (ret == "Clear") { // 의견 전부 삭제
		pHasOpinionYN = "N";
		pHasOpinionYNAry[currentTabIdx] = "N";
		ret = "cancel";
		currIfrm.contentWindow.makeOpinionList(objXML); // 전부 삭제 시 문서에 맵핑된 의견도 지워주기
	} else if (ret == "cancel") {
		// 취소시 동작 없음
	} else {
		var objXML = loadXMLString(ret);
		var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
		
		if (NodeList.length != 0) {
			pHasOpinionYN = "Y";
			pHasOpinionYNAry[currentTabIdx] = "Y";
		} else {
			pHasOpinionYN = "N";
			pHasOpinionYNAry[currentTabIdx] = "N";
			ret = "cancel";
		}
		currIfrm.contentWindow.makeOpinionList(objXML);
	}
    return ret;
}

function makeOpinionList(OpinionXML) {
	if (!FieldExist("opinions")) {
		return;
	}
	
	var firstFlag = true;
	var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
	if (NodeList.length > 0) {
		var strOpinion = " ";
		for (i = NodeList.length - 1; i >= 0; i --) {
			if (getNodeText(GetChildNodes(NodeList[i])[9]) == "001") {
				if (firstFlag) {
					strOpinion = "[" + strLang27;
					firstFlag = false;
				}
				
				if (getNodeText(GetChildNodes(NodeList[i])[2]) != "") {
				    strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[2]) + "\11";  
				} else {
					strOpinion = strOpinion + "   \11";  
				}
				
				strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[1]) + "\11";
				strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[6]) + "\15";
			}
		}		
		PutFieldText("opinions", strOpinion);
		
		OpinionAction = "";
	}
	else {
		PutFieldText("opinions", "");
	}
	// 각 안에 접근하여 호출된 함수이므로, 다시 부모창으로 접근
	parent.GetHTMLForOpinion(before_SaveFileForOpinion, frameNum); // 의견 맵핑한 문서를 실제 파일로 저장
}

// 모든 안에 대하여 로딩한 htmlDataAry[]를 이용해 문서 파일을 저장하는 함수
function before_SaveFile() {
	if (docGetHTMLCnt < docMaxTabNumForApprov) {
		//console.log("현재 docGetHTMLCnt   ::   " + docGetHTMLCnt);
		return;
	} else {
		for (var i = 1; i <= docMaxTabNumForApprov; i++) {
			SaveFileForApprovAll(i);
		}
	}
}

function before_SaveFileForOpinion(html) { // 1안의 의견 저장을 위한 단일 동작 함수
	SaveFileForApprovAll(1);
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

function SaveApproveInfo(pApproveFlag, currIdx) {
	var rtnVal = SaveFileForApprovAll(currIdx);
	
	if (rtnVal.toUpperCase() != "TRUE") {
        return rtnVal;
	}
	
	SignSave(currIdx);
	
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

	pDocTitle = GetFieldText("doctitle");
	createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", pDocTitle);

	if (approvalFlag == 'G' && pDraftFlag == "SUSIN" && useReceiveDocNo == 'NO') {
		if (FieldExist("receiptnumber")) {
			createNodeAndInsertText(xmlpara, objNode, "DOCNO", GetFieldText("receiptnumber"));
		} else if (FieldExist("docnumber")) {
			createNodeAndInsertText(xmlpara, objNode, "DOCNO", GetFieldText("docnumber"));
		} else if (FieldExist("be_docnumber")) {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", GetFieldText("be_docnumber"));
		} else if (FieldExist("deptshortedname")) {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", GetFieldText("deptshortedname"));
		} else {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
		}
	} else {
		if (FieldExist("docnumber")) {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", GetFieldText("docnumber"));
		} else if (FieldExist("be_docnumber")) {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", GetFieldText("be_docnumber"));
		} else if (FieldExist("deptshortedname")) {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", GetFieldText("deptshortedname"));
		} else {
		    createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
		}
	}

	// 일반첨부 또는 문서첨부가 존재하는 경우를 고려
	if (parent.pHasAttachYNAry[currIdx] == "Y" || parent.pHasDocAttachYNAry[currIdx] == "Y") {
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", "Y");
	} else {
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", "N");
	}
	
	if (parent.pHasOpinionYNAry[currIdx] == "Y") {
	    createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", "Y");
	} else {
	    createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", "N");
	}

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

	createNodeAndInsertText(xmlpara, objNode, "SECURITY", parent.tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", parent.tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", parent.pPublicityYN);
	createNodeAndInsertText(xmlpara, objNode, "PROXYUSERID", parent.pingUserID);

	createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", parent.tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", parent.tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", parent.tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KEYWORD", parent.tempKeyword);

	createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");
	createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", parent.pSpecialRecordCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", parent.pPublicityCode);
	createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", parent.pLimitRange);
	createNodeAndInsertText(xmlpara, objNode, "PAGENUM", parent.pPageNum);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", parent.cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", parent.TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", undefined2EmptyString(parent.pDocNumCodeAry[currIdx])); // 안별 문서번호
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElementForDraftAll("sepattachlvxml", true);
	if (!g_SepAttachLVXml) {
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
	} else {
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));
	}

	createNodeAndInsertText(xmlpara, objNode, "SUMMARY", parent.pSummery);
	createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", parent.tempSecurityDate);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", getNodeText(xmldoc.getElementsByTagName("WRITERNAME2").item(0)));
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", getNodeText(xmldoc.getElementsByTagName("WRITERJOBTITLE2").item(0)));
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", getNodeText(xmldoc.getElementsByTagName("WRITERDEPTNAME2").item(0)));

	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", pOrgAprUserName2);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", parent.tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "ORGCOMPANYID", orgCompanyID);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", parent.pPublicityYN);
	
	// 일괄기안 결재창과 비전자등록문서는 호환 불가
	/*
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
	*/
	
	if (currIdx != 1) {
		createNodeAndInsertText(xmlpara, objNode, "SENDNOTIFLAG", "N");
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
     		 SaveOrgFile(currIdx);
     		 return "FALSE";
     	 }
    }
}

//부모창에서 각 자식프레임에 접근해 호출하므로 docID 전달 시 배열을 사용
function SaveFileForApprovAll(currIdx) {
	// 확인, 참조일 경우 파일 저장 안함
	if (pAprLineType == strAprType2 || pAprLineType == strAprType7) return "TRUE";
	var result = "";
	
	var data = {
		docID : parent.pDocIDAry[currIdx],
		formId : parent.pFormIDAry[currIdx],
		html  : parent.htmlDataAry[currIdx],
		orgCompanyID : orgCompanyID
	}

	var url = parent.extAry[currIdx] == "mht" ? "/ezApprovalG/saveFile.do" : "/ezApprovalG/saveFileHWP.do";

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

function SignSave(currIdx) {
    if (parent.SignContent.length > 0) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objRoot, objNode, subNode;
        objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

        for (i = 0; i < parent.SignContent.length; i++) {
            objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "SIGNINFO");
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", parent.pDocIDAry[currIdx]);
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNTYPE", parent.SignType[i]);
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNNAME", parent.SignName[i]);
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "CONTENT", parent.SignContent[i]);
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "ORGCOMPANYID", typeof orgCompanyID == "undefined" ? parent.orgCompanyID : orgCompanyID);
        }
        xmlhttp.open("Post", "/ezApprovalG/setSignInfo.do", false);
        xmlhttp.send(xmlpara);
        
    }
}

function SaveOrgFile(currIdx) {
	var result = "";
	
	//console.log(currIdx + "안에서 SaveOrgFile() 진입, parent.pOrgHtmlAry[currIdx]   ::   " + parent.pOrgHtmlAry[currIdx]);

	// 2021.01.07 강승구 : 오류발생 후 파일이 사라지는 오류 수정
	// 원문서 데이터가 없다면 바로 리턴
	if (typeof(parent.pOrgHtmlAry[currIdx]) == "undefined" || parent.pOrgHtmlAry[currIdx].trim() == "") {
        return;
	}

	var data = {
		docID : parent.pDocIDAry[currIdx],
		formId : parent.pFormIDAry[currIdx],
		html  : parent.pOrgHtmlAry[currIdx]
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

	var Fields = GetFieldList();
  
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
				SignInfo = GetFieldText(Fields[i]);
				SignInfoFlag = false;
			}
			else
			{
				SignInfo = GetFieldText(Fields[i]) + ";" + SignInfo ;
			}
		}
	}
	
	pSuSinFlag = "N";
	if(pDraftFlag != "SUSIN")
	{
		var RtnVal = FieldExist("recipient");
		if(RtnVal)
		{
			pSuSinFlag = "Y";
		}else{
			pSuSinFlag = "N";
		}
	}
	
	pSusinNextSN = parseInt(pSusinSN) + 1;
	fieldname = pSusinNextSN + "sign1";
	if (FieldExist(fieldname))
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
	if (FieldExist("refer"))
		PutFieldText("refer", "");
	
	for(i=1;i < 20;i++) {
		if (FieldExist("gongram" + i))
			PutFieldText("gongram" + i, "");
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
		
		if (FieldExist("lastKyuljikwee"))
			PutFieldText("lastKyuljikwee", lastKyuljiwee);

		if (FieldExist("lastKyulName"))
			PutFieldText("lastKyulName", lastKyulName);
	} else {
		lastKyulName = OrderName[LastSignSN]
		lastKyuljiwee = OrderJobtitle[LastSignSN]
		if (FieldExist("slastKyuljikwee"))
			PutFieldText("slastKyuljikwee", lastKyulName);

		if (FieldExist("slastKyulName"))
			PutFieldText("slastKyulName", lastKyulName);
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
		if (FieldExist(fieldname))
			PutFieldText(fieldname, refer);
	}	

	
	var susinSN = ""
	if(pDraftFlag == "SUSIN")
	{
		susinSN = pSusinSN 
	}

	
	for(i=startIdx;i < 20;i ++)
	{
		fieldname = susinSN + "jikwe" + i
		if (FieldExist(fieldname))
		{
			PutFieldText(fieldname, "");
					
			fieldname = susinSN + "sign" + i
			if (FieldExist(fieldname))
				PutFieldText(fieldname, "");

			fieldname = susinSN + "seumyungdate" + i
			if (FieldExist(fieldname))
				PutFieldText(fieldname, "");
		}
		else break;
	}	
	for(i=1;i<20;i++)
	{
		name = susinSN + "habyuisign" + i;
		if (FieldExist(name))
		{
			if(trim(GetFieldText(name)) == "")
			{
				name = susinSN + "habyui" + i
				if (FieldExist(name))
					PutFieldText(name, "");
				  			
				name = susinSN + "habyuisign" + i;
				if (FieldExist(name))
					PutFieldText(name, "");
					  		    
				name = susinSN + "habyuipositon" + i;
				if (FieldExist(name))
					PutFieldText(name, "");

				name = susinSN + "habyuidate" + i;
				if (FieldExist(name))
					PutFieldText(name, "");
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
					if (FieldExist(fieldname))
					{
						PutFieldText(fieldname, OrderJobtitle[i]);
						if(OrderSuggester[i] == "Y")
							AppendFieldText(fieldname, strLang75);						
						if(OrderReporter[i] == "Y")
							AppendFieldText(fieldname, strLang76);						
					}
	  				  				
	  				fieldname = susinSN + "sign" + idx;
	  				if (FieldExist(fieldname))
	  					PutFieldText(fieldname, OrderName[i] + "\15" + OrderReason[i]);
	  				  				
	  				idx = idx + 1;
	  				continue;
	  			}
	  		}
	  		
			fieldname = susinSN + "jikwe" + idx;
			if (FieldExist(fieldname))
			{
				PutFieldText(fieldname, OrderJobtitle[i]);
				if(OrderSuggester[i] == "Y")
					AppendFieldText(fieldname, strLang75);						
				if(OrderReporter[i] == "Y")
					AppendFieldText(fieldname, strLang76);						
			}
			
			fieldname = susinSN + "sign" + idx;
			if (FieldExist(fieldname))
			{
			}
			idx = idx + 1;
		}
		
		if (OrderType[i] == strAprType8 ||OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)		
		{
			fieldname = susinSN + "habyui" + hidx;
			if (FieldExist(fieldname))
				PutFieldText(fieldname, OrderDept[i]);
		
			fieldname = susinSN + "habyuisign" + hidx;
			if (FieldExist(fieldname))
			{
			}			

			fieldname = susinSN + "habyuipositon" + hidx;
			if (FieldExist(fieldname))
			{
				PutFieldText(fieldname, OrderJobtitle[i]);
				if(OrderSuggester[i] == "Y")
					AppendFieldText(fieldname, strLang75);						
				if(OrderReporter[i] == "Y")
					AppendFieldText(fieldname, strLang76);						
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
  
	// if (SignNodeList.length != 0) { 
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
		Approv_Complete_BackEnd(ret);
		//Approve_complete(ret);
		//GetHTML(Approve_complete);
	}
	*/
}

function SetAutoPropFinal() {
  try {
    var CurrentDate;
    CurrentDate = getGyulJeDate();
    
	var Fields = GetFieldList();
  
	for (i = 0 ; i < Fields.length ; i ++) {
		if (pDraftFlag == "DRAFT" ) {
			switch (Fields[i]) {
	  			case "sentdate" :
	  				PutFieldText(Fields[i], CurrentDate);
	  		  		break;
 			}
	  	}
	}  
  } catch(e){	
	alert(e);
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

	if (FieldExist("memo"))
		PutFieldText("memo", content);
}

function putSignXML(SignXML) {
  var retVal = false;
  try {
	var NodeList;
	NodeList = SignXML.selectNodes("SIGNINFOS/SIGNINFO");
	if (NodeList.length > 0) {
		for (i=0; i<NodeList.length; i++) {
		    var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
		    var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
		    var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));
			
			if (FieldExist(SignName)) {		
			    retVal = true;	
				if (SignType == "TEXT") {
					PutFieldText(SignName, SignCont);
				} else if (SignType == "HTML") {
					AppendFieldText(SignName, SignCont);
				} else if (SignType == "PROXY") {
					PutFieldText(SignName, " ");
					AppendFieldText(SignName, strLang8);
					InsertPicture(SignName, hostURL + escape(SignCont), null);
				} else if (SignType == "IMAGE") {
				    var img = SignCont.split("::");
				    PutFieldText(SignName, "");
					if(img.length >= 1) {
					    InsertPicture(SignName, hostURL + escape(img[0]), null);
					}
				    if(img.length >= 2)
				    	AppendFieldText(SignName, img[1]);
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
	if (!FieldExist("publication"))
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

	PutFieldText("publication", PublicText);
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
    if (FieldExist("hrecipients"))
        PutFieldText("hrecipients", "");

    if (FieldExist("recipient"))
        PutFieldText("recipient", "");

    if (FieldExist("recipients"))
        PutFieldText("recipients", "");

    for (var i = rows.length - 1; i >= 0; i--) {
    	var row = rows[i];
        var params = new Array();
        params[0] = "0";

        var dataNodes = GetChildNodes(rows[i], params);
        if (recipflag) {
        	if (getNodeText(dataNodes[3]) == "Y") {
				if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
					precipent = strLang92;
					precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
				} else {
					precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
					precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
				}
                recipflag = false;
            } else {
            	if (isExtDoc == "Y") {
					if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
						precipent = strLang92;
						precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
					} else {
						precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
						precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
					}
                    recipflag = false;
                } else {
					if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
						precipent = strLang92;
						precipents = getNodeText(dataNodes[0]);
					} else {
						precipent = getNodeText(dataNodes[0]);
						precipents = getNodeText(dataNodes[0]);
					}
                    recipflag = false;
                }
            }
        } else {
        	 precipent = strLang92;

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
    
    if (FieldExist("recipient")) {
        if (precipent == strLang92) {
            PutFieldText("recipient", precipent);
            if (FieldExist("recipients")) {
                PutFieldText("recipients", precipents);
                if (FieldExist("hrecipients"))
                    PutFieldText("hrecipients", strLang129);
            }
        }
        else {
            PutFieldText("recipient", precipent);
            if (precipents == "") {
                if (FieldExist("hrecipients"))
                    PutFieldText("hrecipients", "");

                if (FieldExist("recipients"))
                    PutFieldText("recipients", "");
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
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", ConvMakeXMLString(arr_userinfo[15]));
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", ConvMakeXMLString(arr_userinfo[16]));
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
    if (!FieldExist("publication")) return;
    var PublicType = pPublicityYN.substring(0, 1);

    if (PublicType == "Y" || PublicType == "B")
        PublicText = strLang82;
    else if (PublicType == "N")
        PublicText = strLang84;
    else
        PublicText = " ";
    
    PutFieldText("publication", PublicText);
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

//undefined 문자열을 공백으로 반환
function undefined2EmptyString(value) {
	if (value == undefined) {
		return ""; 
	} else {
		return value; 
	}
}

//일괄기안을 위한 결재선 업데이트 함수 (docID 배열로 접근)
function UpdateLineHistoryForDraftAll(currIdx) {
	var result = "";
    
	/* 2020-05-22 홍승비 - 사용자 부서에 특수문자 허용 + arr_userinfo[] 배열의 값은 c:out 태그로 저장하므로, DB 저장 시 역으로 특수문자 인코딩 진행 */
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateLineHistory.do",
		data : {
			docID : pDocIDAry[currIdx],
			userID : arr_userinfo[1],
			userName : arr_userinfo[11],
			userJobTitle : arr_userinfo[13],
			userDeptID : arr_userinfo[4],
			userDeptName : ConvMakeXMLString(arr_userinfo[15]),
			chkFlag : "CHECK",
			userName2 : arr_userinfo[12],
			userJobTitle2 : arr_userinfo[14],
			userDeptName2 : ConvMakeXMLString(arr_userinfo[16]),
			orgCompanyID : orgCompanyID
		},
		success: function(xml) {
			result = xml;
			
			var DataNodes = GetChildNodes(loadXMLString(result));
		    if (getNodeText(DataNodes[0]) != "TRUE") {
		        var pAlertContent = strLang91;
		        OpenAlertUI(pAlertContent);
		    }
		},
		error : function () {
			var pAlertContent = strLang91;
	        OpenAlertUI(pAlertContent);
		}
	});
}
