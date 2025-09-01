var lastKyulName, lastKyuljiwee, LastSignSN, pAprLineB4type;
var pOrgAttach;
var bbtnApprove = "";
var bbtnReject = "";
var bbtnReject2 = "";
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
var btbtnTotalSave = "";
var bbtntotaldocinfo = "";
var btnAddRelatedCabinet = "";

function putBansongSign() {
    var fields = message.GetFieldsList();
    var field;
    var SingFlag = true;
    var habyui;
    var signInfo = new Array();
    var signCnt = 0;
    var RtnVal = getGyulJeDate();
    var CurrentDate = RtnVal.split(".");
    var s = CurrentDate[1] + "." + CurrentDate[2];
    // aprType 9(개인병렬협조), 11(부서순차협조), 12(부서병렬협조)
    if (pAprLineType == strAprType11 || pAprLineType == strAprType12 || pAprLineType == strAprType9) {
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
            phabyuisign = "habyuisign";
            phabyuidate = "habyuidate";
            phabyuijikwee = "habyuipositon";
            phabyuidept = "habyui";
        }

        habyui = phabyuisign + pAprMemberSN;
        var field = message.GetListItem(fields, habyui);
        if (field) {
        	setNodeText(field , strLang4);
            SignContent[signCnt] = strLang4;
            signInfo[signCnt] = habyui;
            SignType[signCnt] = "TEXT";
            SignName[signCnt] = habyui;

            signCnt = signCnt + 1;
            SingFlag = false;
        }

        var habyuidateID = phabyuidate + pAprMemberSN;
        var field = message.GetListItem(fields, habyuidateID);
        if (field) {
        	setNodeText(field , s);
            signInfo[signCnt] = habyuidateID;
            SignType[signCnt] = "TEXT";
            SignName[signCnt] = habyuidateID;
            SignContent[signCnt] = s;
            signCnt = signCnt + 1;
        }
    }
    return signInfo;
}
/**
 * 현재 결재중인 양식에 결재관련 서명 및 기타 내용 출력.
 * field.innerHTML = String Data
 * */
function ApprovMappingSign(ret) {
    var fields = message.GetFieldsList();
    var field;
    var SingFlag = true;
    var DekyulFlag = false;
    var habyui
    var signInfo = new Array();
    var signCnt;

    signCnt = 0;

    var RtnVal = getGyulJeDate();
    var CurrentDate = RtnVal.split(".");
    var s = CurrentDate[1] + "." + CurrentDate[2];

    var OpinionText = "";
    var PositionText = "";
    // 4 : 전결, 16 : 대결
    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
        OpinionText = getSignDate() + "<br/>";
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
            phabyuisign = "habyuisign";
            phabyuidate = "habyuidate";
            phabyuijikwee = "habyuipositon";
            phabyuidept = "habyui";
        }

        var habyui = phabyuisign + pAprMemberSN;
        var field = message.GetListItem(fields, habyui);
        var isHabyuiDate = message.GetListItem(fields, phabyuidate + pAprMemberSN);
        if (field) {
            if (ret != "NAME" && ret != "") { // 서명이 이미지인 경우 
                var signWidth = 50;
                var signHeight = 50;
                
                // 서명일자 칸이 없고 개인협조(합의)자가 최종결재자인 경우에 대응하기 위한 처리이나, 2023-10-18 기준으로 합의서명칸에 서명일자를 삽입하는 로직은 존재하지 않는다. (합의서명일자칸이 없으면 별다른 처리 없이 넘어감)
            	// 서명일자 칸이 없는 경우, 합의유형이 아닌 일반적인 결재유형의 최종결재자에게만 서명일자를 삽입하는 스펙으로 확정함
             /*   if (isHabyuiDate) {
                	signHeight = 50;
                } else {
                	signHeight = 28;
                }*/
                
                var strimg = "";
                
                if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) { // 대리결재
                	signHeight = 28;
                	strimg = strLang8 + "<br>"; // 대리결재 시, 代 문자를 이미지 서명 위에 붙임
                }
                
                strimg = strimg + "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
                strimg = strimg + " width=" + signWidth;
                
                if (signImageType == "NAME") {
                	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>" + "<br>" + arr_userinfo[2];
				} else {
				    strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";
				}
                
                field.innerHTML = strimg; // field에 이미지 정보 출력
                
                var content = ret;
                if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                    content = ret + "::" + strLang8 + "<br>";
                }
                
                if (signImageType == "NAME") {
                	content = content + "::" + arr_userinfo[2];
                }
                
                signInfo[signCnt] = habyui;
                SignType[signCnt] = "IMAGE";
                SignName[signCnt] = habyui;
                SignContent[signCnt] = content;
                
                signCnt = signCnt + 1;
                SingFlag = true;
            } else {
            	/**
            	 * '환경설정->결재환경설정->부재자설정'을 통한 대리결재 설정
            	 * 두 유저 ID가 다른 경우 -> 대리결재 표시(代) 출력
            	 * */
                if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                    field.innerHTML = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";
                    SignContent[signCnt] = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";
                }
                else {
                    field.innerHTML = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                    SignContent[signCnt] = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                }

                signInfo[signCnt] = habyui;
                SignType[signCnt] = "HTML";
                SignName[signCnt] = habyui;
                signCnt = signCnt + 1;
                SingFlag = false;
            }
        }

        var habyuidateID = phabyuidate + pAprMemberSN;
        var field = message.GetListItem(fields, habyuidateID);
        if (field) {
            setNodeText(field , s);
            signInfo[signCnt] = habyuidateID;
            SignType[signCnt] = "TEXT";
            SignName[signCnt] = habyuidateID;
            SignContent[signCnt] = s; // var s = CurrentDate[1] + "." + CurrentDate[2];
            signCnt = signCnt + 1;
        }

        var phabyuijikweeID = phabyuijikwee + pAprMemberSN;
        var field = message.GetListItem(fields, phabyuijikweeID);
        if (field) {
            setNodeText(field , getNodeText(field) + PositionText);
        }
    }
    else if (pAprLineType == strAprType2 || pAprLineType == strAprType7) { // 2 : 확인, 7 : 참조

    }
    else if (pAprLineType == strAprType15) { // 15 : 후열
        signID = "gamsasign1";

        var field = message.GetListItem(fields, signID);

        if (field) {

            var psingTD = field;
            var SContent = strLang14 + "<br>" + arr_userinfo[2] + "<br>" + s;
            psingTD.innerHTML = SContent;
            signInfo[signCnt] = signID;
            SignName[signCnt] = signID;
            SignType[signCnt] = "HTML";
            SignContent[signCnt] = SContent;

            signCnt = signCnt + 1;
        }
    }
    else if (ret == "BANSONG" && KuyjeType == "001") {
        var pAprMemberSignSN = pAprMemberSN;
        var signID;
        var seumyungID;
        var seumyungdateID;

        signID = "sign" + pAprMemberSignSN;
        seumyungID = "seumyung" + pAprMemberSignSN;
        seumyungdateID = "seumyungdate" + pAprMemberSignSN;

        var field = message.GetListItem(fields, signID);

        if (field) {
            var psingTD = field;
            var SContent = strLang4 + "<br/>" + arr_userinfo[2];
            psingTD.innerHTML = SContent;
            signInfo[signCnt] = signID;

            SignName[signCnt] = signID;
            SignType[signCnt] = "HTML";
            SignContent[signCnt] = SContent;

            signCnt = signCnt + 1;
        }

        field = message.GetListItem(fields, seumyungID);

        if (field) {
            setNodeText(field , arr_userinfo[5]);
            signInfo[signCnt] = seumyungID;
            SignName[signCnt] = seumyungID;
            SignType[signCnt] = "TEXT";
            SignContent[signCnt] = arr_userinfo[5];

            signCnt = signCnt + 1;
        }

        field = message.GetListItem(fields, seumyungdateID);
        if (field) {
            setNodeText(field , s);
            signInfo[signCnt] = seumyungdateID;
            SignName[signCnt] = seumyungdateID;
            SignType[signCnt] = "TEXT";
            SignContent[signCnt] = s;
            signCnt = signCnt + 1;
        }

    }
    else if (approvalFlag == "S" && pAprLineType == strAprType4) { // 4 : 전결
    	var pAprMemberSignSN = pAprMemberSN;
        var signID;
        var seumyungID;
        var seumyungdateID;
        
        var pSusinSN2 = "";
    	if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N")) {
    		pSusinSN2 = pSusinSN;
    	}
        
    	// 전결 처리 타입 1(default) : 전결자 이후 결재자들도 사인칸에 등록. 전결자가 결재하면 전결자 사인칸에 전결표시하고, 최종결재자 사인칸에 전결자 서명을 입력한다.
        if (junGyulFlag == "1") {
            //전결자, 결재안함 결재칸에 전결String
           /* for (var i = pAprMemberSignSN; i < LastKyulSN; i++) {
            	signID = pSusinSN2 + "sign" + i;
            	
            	var field = message.GetListItem(fields, signID);
                if (field) {
                	field.innerHTML = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang6 + "</P>";
                }
            }*/
        	
    		/* 2018-04-27 천성준 - 전결자만 결재칸에 전결 표시 >> 전결자 결재칸에 전결String */
        	signID = pSusinSN2 + "sign" + pAprMemberSignSN;
        	
        	var field = message.GetListItem(fields, signID);
            if (field) {
            	field.innerHTML = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang6 + "</P>";
            }
            
            //최종결재자 인덱스 구하기
            for (var i = 0; i < 20; i++) {
            	signID = pSusinSN2 + "sign" + i;
            	var field = message.GetListItem(fields, signID);
            	
                if (field) {
                	LastKyulSN = i;
                }
            }
            
            //최종결재자 결재칸에 싸인
        	signID = pSusinSN2 + "sign" + LastKyulSN;
            seumyungID = pSusinSN2 + "jikwe" + LastKyulSN;
            seumyungdateID = pSusinSN2 + "seumyungdate" + LastKyulSN;
            
            var field = message.GetListItem(fields, seumyungdateID);
            if (field) {
                setNodeText(field , s);
                
                /* 2023-10-05 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
                signInfo[signCnt] = seumyungdateID;
        		SignName[signCnt] = seumyungdateID;
        		SignType[signCnt] = "TEXT";
        		SignContent[signCnt] = s;
        		signCnt = signCnt + 1;
            }

            field = message.GetListItem(fields, seumyungID);
            if (field) {
                setNodeText(field , getNodeText(field) + PositionText);
            }
            
            var field = message.GetListItem(fields, signID);
            if (field) {
            	//전자결재 일반에는 대결없음
//                if (DekyulFlag && pAprLineB4type == strAprType4) {
//                    field.innerHTML = strLang6;
//                    signInfo[signCnt] = signID;
//                    SignName[signCnt] = signID;
//                    SignType[signCnt] = "TEXT";
//                    SignContent[signCnt] = strLang6;
//
//                    signCnt = signCnt + 1;
//                }
//                else if (DekyulFlag) {
//                }
//                else {
            	
            	// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
    			if (message.GetListItem(fields, seumyungdateID)) {
    			    OpinionText = "";
    			}
    			
                    if (ret != "NAME") { //이미지 서명
                        signWidth = 50;
                        signHeight = 50;

                        var strimg;
                        var contents = "";
                        var FilePath = encodeURI(ret);
                        
                        if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase()) {
                            strimg = "<img src='" + FilePath + "' border=0 embedding='1' ";
                        } else {
                        	strimg = strLang8 + "<br><img src='" + FilePath + "' border=0 embedding='1' ";
                        	signHeight = 28;
                        	
                        	// 대리결재 시, 代 문자를 이미지 서명 위에 붙임 (대결/전결 및 서명일자 표기보다는 아래에 위치)
                        	contents = strLang8 + "<br>";
                        }
                        
                        strimg = strimg + " width=" + signWidth;
                        
                        // 서명일자칸이 없는 경우, 서명칸에 서명일자를 함께 표출하기 위해 이미지 서명의 높이 조정
                        if (!message.GetListItem(fields, seumyungdateID)) {
                        	signHeight = 28;
                        }
                        
                        if (signImageType == "NAME") {
                        	strimg = strimg + " height=" + signHeight + " spath='" + FilePath + "'>" + "<br>" + arr_userinfo[2];
						} else {
						    strimg = strimg + " height=" + signHeight + " spath='" + FilePath + "'>";
						}
                        
                        if (!message.GetListItem(fields, seumyungdateID)) {
                            strimg = OpinionText + strimg;
                        }
                        
                        if (signImageType == "NAME") {
                        	content = content + "::" + arr_userinfo[2];
                        }
                        
                        field.innerHTML = strimg;
                        signInfo[signCnt] = signID;
                        SignName[signCnt] = signID;
                        SignType[signCnt] = "IMAGE";
                        SignContent[signCnt] = ret + "::" + OpinionText + contents;
                        
                        signCnt = signCnt + 1;
                        SingFlag = true;
                    }
                    else { //문자 서명
                        if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase()) {
                            strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                        } else {
                            strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";
                        }
                        
                        if (!message.GetListItem(fields, seumyungdateID)) {
                            strimg = OpinionText + strimg;
                        }

                        field.innerHTML = strimg;
                        signInfo[signCnt] = signID;
                        SignName[signCnt] = signID;
                        SignType[signCnt] = "HTML";
                        SignContent[signCnt] = strimg;
                        signCnt = signCnt + 1;
                        SingFlag = false;
                    }
//                }
            }
    	}
        // 전결 처리 타입 4 : 전결자 이후 결재자들은 사인칸에 미등록. 전결자가 결재하면 전결자 사인칸에 전결자 서명을 입력한다.
        else if (junGyulFlag == "4") {
    		signID = pSusinSN2 + "sign" + pAprMemberSignSN;
            seumyungID = pSusinSN2 + "jikwe" + pAprMemberSignSN;
            seumyungdateID = pSusinSN2 + "seumyungdate" + pAprMemberSignSN;
            
            var field = message.GetListItem(fields, seumyungdateID);
            if (field) {
                setNodeText(field , s);
                
                /* 2023-10-05 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
                signInfo[signCnt] = seumyungdateID;
        		SignName[signCnt] = seumyungdateID;
        		SignType[signCnt] = "TEXT";
        		SignContent[signCnt] = s;
        		signCnt = signCnt + 1;
            }

            field = message.GetListItem(fields, seumyungID);
            if (field) {
                setNodeText(field , getNodeText(field) + PositionText);
            }
            
            var field = message.GetListItem(fields, signID);
            if (field) {
            	//전자결재 일반에는 대결없음
//                if (DekyulFlag && pAprLineB4type == strAprType4) {
//                    field.innerHTML = strLang6;
//                    signInfo[signCnt] = signID;
//                    SignName[signCnt] = signID;
//                    SignType[signCnt] = "TEXT";
//                    SignContent[signCnt] = strLang6;
//
//                    signCnt = signCnt + 1;
//                }
//                else if (DekyulFlag) {
//                }
//                else {
            	
            	// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
    			if (message.GetListItem(fields, seumyungdateID)) {
    			    OpinionText = "";
    			}
    			
                    if (ret != "NAME") { //이미지 서명
                        signWidth = 50;
                        signHeight = 28;

                        var strimg;
                        var contents = "";
                        var FilePath = encodeURI(ret);
                        
                        if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase()) {
                            strimg = "<img src='" + FilePath + "' border=0 embedding='1' ";
                        } else {
                        	strimg = strLang8 + "<br><img src='" + FilePath + "' border=0 embedding='1' ";
                        	
                        	// 대리결재 시, 代 문자를 이미지 서명 위에 붙임 (대결/전결 및 서명일자 표기보다는 아래에 위치)
                        	contents = strLang8 + "<br>";
                        }

                        strimg = strimg + " width=" + signWidth;
                        strimg = strimg + " height=" + signHeight + " spath='" + FilePath + "'>";
                        
                        if (!message.GetListItem(fields, seumyungdateID)) {
                            strimg = OpinionText + strimg;
                        }
                        
                        strimg = strLang6 + strimg;
                        
                        field.innerHTML = strimg;
                        signInfo[signCnt] = signID;
                        SignName[signCnt] = signID;
                        SignType[signCnt] = "IMAGE";
                        SignContent[signCnt] = ret + "::" + strLang6 + OpinionText + contents;
                        
                        signCnt = signCnt + 1;
                        SingFlag = true;
                    }
                    else { // 문자 서명
                    	var strimg;
                    	
                        if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase()) {
                            strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                        } else {
                            strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";
                        }
                        
                        if (!message.GetListItem(fields, seumyungdateID)) {
                            strimg = OpinionText + strimg;
                        }

                        strimg = strLang6 + strimg;

                        field.innerHTML = strimg;
                        signInfo[signCnt] = signID;
                        SignName[signCnt] = signID;
                        SignType[signCnt] = "HTML";
                        SignContent[signCnt] = strimg;
                        signCnt = signCnt + 1;
                        SingFlag = false;
                    }
//                }
            }
    	} 
        //TODO: junGyulFlag 2,3 일때 처리
    } else {
    	var pAprMemberSignSN = pAprMemberSN;
    	var signID;
    	var seumyungID;
    	var seumyungdateID;
    	
    	//S버젼 추가
    	//approvalFlag == "S" && pAprLineType == strAprType4인 경우는 없음(위에서 처리하였음)
    	if (approvalFlag == "S") {
    		if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4) {
    			for (i = 1; i <= 20; i++) {
    				if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N")) {
    					signID = pSusinSN + "sign" + i
    				} else {
    					signID = "sign" + i
    				}
    				
    				field = message.GetListItem(fields, signID);
    				if (field) {
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

        var field = message.GetListItem(fields, seumyungdateID); 
        if (field) {
            setNodeText(field , s); // '서명날짜'에 출력
            
            /* 2023-10-05 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
            signInfo[signCnt] = seumyungdateID;
    		SignName[signCnt] = seumyungdateID;
    		SignType[signCnt] = "TEXT";
    		SignContent[signCnt] = s;
    		signCnt = signCnt + 1;
        }

        field = message.GetListItem(fields, seumyungID);
        if (field) {
            setNodeText(field , getNodeText(field) + PositionText); // '직위' 출력
        }
        
        /**
         * 기안 작성시 결재자의 결재유형을 '대결'로 설정한 경우
         *  16 : 대결
         * */
        if (pAprLineType == strAprType16) {
            var field = message.GetListItem(fields, signID);
            if (field) {
            	// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
    			if (message.GetListItem(fields, seumyungdateID)) {
    			    OpinionText = "<br>";
    			}
    			
                if (ret != "NAME") {
                    signWidth = 50;
                    signHeight = 28;
                    
                    var strimg;
                    var contents = "";
                    var FilePath = encodeURI(ret);
                    
                    if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase()) {
                        strimg = "<img src='" + FilePath + "' border=0 embedding='1' ";
                    }
                    // 대리결재 시, 代 문자를 이미지 서명 위에 붙임 (대결 및 서명일자 표기보다는 아래에 위치)
                    else {
                        strimg = strLang8 + "<br><img src='" + FilePath + "' border=0 embedding='1' ";
                        contents = strLang8 + "<br>";
                    }
                    
                    strimg = strimg + " width=" + signWidth;
                    
                    if (signImageType == "NAME") {
                    	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>" + "<br>" + arr_userinfo[2];
                    } else {
                        strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";
                    }
                    
					// 서명 정보에 strLang7 = '대결' 출력
                    strimg = strLang7 + OpinionText + strimg;
                    field.innerHTML = strimg;
                    
                    if (signImageType == "NAME") {
                    	content = content + "::" + arr_userinfo[2];
                    }
                    
                    signInfo[signCnt] = signID;
                    SignName[signCnt] = signID;
                    SignType[signCnt] = "IMAGE";
                    SignContent[signCnt] = ret + "::" + strLang7 + OpinionText + contents;

                    signCnt = signCnt + 1;
                    SingFlag = true;
                }
                else {
                    if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase()) {
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                    }
                    // 대리결재 시, 代 문자를 문자서명 좌측에 붙임
                    else {
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";
                    }
                    
                    field.innerHTML = strLang7 + OpinionText + strimg;
                    
                    signInfo[signCnt] = signID;
                    SignName[signCnt] = signID;
                    SignType[signCnt] = "HTML";
                    SignContent[signCnt] = strLang7 + OpinionText + strimg;
                    
                    signCnt = signCnt + 1;
                    SingFlag = false;
                }

                DekyulFlag = true;
                pAprMemberSignSN = pAprMemberSignSN + 1;
                if (pDraftFlag == "SUSIN") {
                    signID = pSusinSN + "sign" + pAprMemberSignSN;
                    seumyungID = pSusinSN + "jikwe" + pAprMemberSignSN;
                    seumyungdateID = pSusinSN + "seumyungdate" + pAprMemberSignSN;
                }
                else {
                    signID = "sign" + pAprMemberSignSN;
                    seumyungID = "jikwe" + pAprMemberSignSN;
                    seumyungdateID = "seumyungdate" + pAprMemberSignSN;
                }
            }
        }

        var field = message.GetListItem(fields, signID);
        if (field) {
            if (DekyulFlag && pAprLineB4type == strAprType4) { // 4: 전결 (대결자 이후 최종결재자로 전결자가 존재하는 경우, 즉 위임전결사항의 대결 처리)
                field.innerHTML = strLang6;
                signInfo[signCnt] = signID;
                SignName[signCnt] = signID;
                SignType[signCnt] = "TEXT";
                SignContent[signCnt] = strLang6;

                signCnt = signCnt + 1;
            }
            else if (DekyulFlag) {
            }
            else {
                if (ret != "NAME") { // 서명이 이름이 아닌 경우 (즉, 이미지)
                    var signWidth = 50;
                    var signHeight = 50;
                    
                    if (!message.GetListItem(fields, seumyungdateID)) {
                    	// 서명일자칸이 존재하지 않는 경우, 서명칸에 서명일자를 함께 표출하기 위해 이미지 서명의 높이를 조정 (최종결재일때만 서명칸에 서명일자를 표출)
                    	if (LastKyulSN == pAprMemberSN) {
                        	signHeight = 28;
                        }
                    } else {
                    	signHeight = 50;
                    }
                    
                    // 대결/전결 메세지는 서명칸에 표출하므로 이미지 서명의 높이를 조정
                	if (pAprLineType == strAprType4 || pAprLineType == strAprType16) {
                		signHeight = 28;
                	}
                	
                    var strimg;
                    var contents = "";
                    var FilePath = encodeURI(ret);
                    
                    if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase()) {
                        strimg = "<img src='" + FilePath + "' border=0 embedding='1' ";
                    } else {
                    	signHeight = 28;
                    	strimg = strLang8 + "<br><img src='" + FilePath + "' border=0 embedding='1' ";
                    }

                    strimg = strimg + " width=" + signWidth;
                    
                    if (signImageType == "NAME") {
                    	strimg = strimg + " height=" + signHeight + " spath='" + FilePath + "'>" + "<br>" + arr_userinfo[2];
					} else {
					    strimg = strimg + " height=" + signHeight + " spath='" + FilePath + "'>";
					}
                    
                    if (!message.GetListItem(fields, seumyungdateID)) {
                        strimg = OpinionText + strimg;
                        contents = OpinionText + contents;
                    }
                    
                    if (pAprLineType == strAprType4) {
                    	// strimg HTML의 맨 앞 부분이 OpinionText로 시작하지 않는 경우(서명칸에 서명일자+개행태그가 함께 들어가지 않는 경우), 대결/전결 문자 직후에 개행 태그를 삽입
                    	if (!strimg.startsWith(OpinionText)) {
                    		strimg = "<br>" + strimg;
                    	}
                    	
                    	strimg = strLang6 + strimg;
                        contents = strLang6 + contents;
                    }
                    
                    if (pAprLineType == strAprType16) {
                    	if (!strimg.startsWith(OpinionText)) {
                    		strimg = "<br>" + strimg;
                    	}
                    	
                        strimg = strLang7 + strimg;
                        contents = strLang7 + contents;
                    }
                    
                    // 대리결재 시, 代 문자를 이미지 서명 위에 붙임 (대결 및 서명일자 표기보다는 아래에 위치)
                    if (pOrgAprUserID.toLowerCase() != pingUserID.toLowerCase()) {
                    	// 代 문자 이전의 내용이 개행 태그로 끝나는 경우
                    	if (contents.endsWith("<br>") || contents.endsWith("<br/>")) {
                    		contents = contents + strLang8 + "<br>";
                    	}
                    	// 代 문자 이전의 내용이 개행 태그로 끝나지 않으며, 공백이 아닌 내용이 존재하는 경우
                    	else if (contents != "") {
                    		contents = contents + "<br>" + strLang8 + "<br>";
                    	}
                    	// 代 문자 이전의 내용이 공백인 경우
                    	else {
                    		contents = strLang8 + "<br>";
                    	}
                    }
                    
                    if (signImageType == "NAME") {
                    	content = content + "::" + arr_userinfo[2];
                    }
                    
                    field.innerHTML = strimg; // 서명 field에 값 넣기
                    signInfo[signCnt] = signID;
                    SignName[signCnt] = signID;
                    SignType[signCnt] = "IMAGE";
                    SignContent[signCnt] = ret + "::" + contents;
                    
                    signCnt = signCnt + 1;
                    SingFlag = true;
                }
                else { // 서명이 이름인 경우 (즉, 문자)
                	var strimg;
                	
                    if (pOrgAprUserID.toLowerCase() == pingUserID.toLowerCase()) {
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>";
                    } else {
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + strLang8 + arr_userinfo[2] + "</P>";
                    }

                    if (!message.GetListItem(fields, seumyungdateID)) {
                        strimg = OpinionText + strimg;
                    }

                    if (pAprLineType == strAprType4) { // 전결 + strimg
                        strimg = strLang6 + strimg;
                    }

                    if (pAprLineType == strAprType16) { // 대결 + strimg
                        strimg = strLang7 + strimg;
                    }
                    
                    field.innerHTML = strimg;
                    signInfo[signCnt] = signID;
                    SignName[signCnt] = signID;
                    SignType[signCnt] = "HTML";
                    SignContent[signCnt] = strimg;
                    signCnt = signCnt + 1;
                    SingFlag = false;
                }
            }
        }
    }
    return signInfo;
}


function putJunkyulSign(signID) {
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, signID);
    if (field) {
        var signWidth = Number(field.offsetWidth) - 4 - 15;
        var signHeight = Number(field.offsetHeight) - 4;
        var strimg;
        field.style.fontSize = "12pt";
        field.style.fontWeight = "bolder";
        field.style.color = "blue";
        field.textContent = strLang6;
    }
}
function putKyuljeSign(signID) {
}
function UndoSignInfo(signInfo) {
    var cnt;
    var fields = message.GetFieldsList();
    var field;

    for (cnt = 0; cnt < signInfo.length; cnt++) {

        field = GetListItem(fields, signInfo[cnt]);
        if (field) {
            field.textContent = "";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
}

function AprLineSNCount(pAprLineType, objNodes, pTmpAprLineType) {
    var objNodesLen = objNodes.length;
    var pAprLineSN = 0;
    
    for (i = (objNodesLen - 1) ; i >= 0; i--) {
        var pCurrentAprState = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12]);
        var pCurrentAprType = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]);
        if (pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) { // 개인순차/병렬협조, 부서순차/병렬협조
            if (pCurrentAprType == strAprType8 || pCurrentAprType == strAprType9 || pCurrentAprType == strAprType11 || pCurrentAprType == strAprType12) {
                if ((getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5))) {
                    pAprLineSN = pAprLineSN + 1;
                    break;
                } else {
                    pAprLineSN = pAprLineSN + 1;
                }
            }
        }
        else {
        	/* 2021-02-03 홍승비 - 결재선 카운트에 감사 유형 추가 (기안, 검토, 결재, 대결, 전결, 감사) */
            if (pCurrentAprType == strAprType18 || pCurrentAprType == strAprType19 || pCurrentAprType == strAprType1 || pCurrentAprType == strAprType16 || pCurrentAprType == strAprType4 || pCurrentAprType == strAprType5) {
                if ((getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5))) { // 진행, 보류
                    pAprLineSN = pAprLineSN + 1;
                    break;
                } else {
                    pAprLineSN = pAprLineSN + 1;
                }
            }
        }

    }
    return pAprLineSN;
}

function SAprLineSNCount(pAprLineType, objNodes, pTmpAprLineType) {
    var objNodesLen = objNodes.length;
    var pAprLineSN = 0;

    if (pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
        for (i = (objNodesLen - 1) ; i >= 0; i--) {
            var pCurrentAprType = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]);
            if (pCurrentAprType == strAprType8 || pCurrentAprType == strAprType9 || pCurrentAprType == strAprType11 || pCurrentAprType == strAprType12) {
                var pCurrentAprState = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12]);
                if ((getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5))) {
                    pAprLineSN = pAprLineSN + 1;
                    break;
                } else {
                    pAprLineSN = pAprLineSN + 1;
                }
            }
        }
    }
    else {
        for (i = (objNodesLen - 1) ; i >= 0; i--) {
            var pCurrentAprType = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[11]);
            if (pCurrentAprType == strAprType18 || pCurrentAprType == strAprType19 || pCurrentAprType == pAprLineType || pCurrentAprType == pTmpAprLineType || pCurrentAprType == strAprType3 || pCurrentAprType == strAprType40) {
                var pCurrentAprState = getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[12]);
                if ((getNodeText(GetChildNodes(GetChildNodes(objNodes[i])[0])[4]).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5))) {
                    pAprLineSN = pAprLineSN + 1;
                    break;
                } else {
                    pAprLineSN = pAprLineSN + 1;
                }
            }
        }
    }
    return pAprLineSN;
}

function GetAprDocFormID(pDocID) {
    var pFormID;

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

    xmlhttp.open("Post", "../DraftUI/aspx/GetAprDocFormID.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    pFormID = getNodeText(dataNodes[0]);

    return pFormID;
}

var apropinion_cross_dialogArguments = new Array();
function openOpinionUI(ret, CompleteFunction) {
    var parameter = new Array();
    parameter[0] = pDocID;
    parameter[1] = ret;
    parameter[2] = KuyjeType;
    parameter[3] = pOrgDocID;
    parameter[5] = window;
    parameter[6] = docState;
    
    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
    parameter[99] = ext;

    apropinion_cross_dialogArguments[0] = parameter;
    if (CompleteFunction != undefined)
        apropinion_cross_dialogArguments[1] = CompleteFunction;
    else
        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;

    DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do?orgCompanyID=" + orgCompanyID + "&orgDeptID=" + OrgAprUserDeptID);
}
function openOpinionUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel" && ret!= "Clear") {
        var Rtnxml = createXmlDom();
        Rtnxml = loadXMLString(ret);

        var NodeList = SelectNodes(Rtnxml, "LISTVIEWDATA/ROWS/ROW");

        if (NodeList.length != 0)
            pHasOpinionYN = "Y";
        else {
            pHasOpinionYN = "N";
            ret = "cancel";
        }
        makeOpinionList(Rtnxml);
    }
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
		
		apropinion_cross_dialogArguments[0] = parameter;
		if (typeof(CompleteFunction) != "undefined") {
			apropinion_cross_dialogArguments[1] = CompleteFunction; 
		} else {
			apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete;
		}
		
		DivPopUpShow(530, 520, "/ezApprovalG/aprOpinionNew.do");
	} catch (e) {
		alert("openOpinionUI_New ::: " + e.description);
	}
}
function openOpinionUI_New_Complete(ret) {
	try {
		DivPopUpHidden();
		if (ret == "Clear") {
			pHasOpinionYN = "N";
			var fields = message.GetFieldsList();
		    var field = message.GetListItem(fields, "opinions");
		    if (field) {
		    	field.innerHTML = " ";
		    }
		} else if (ret == "cancel") {
			//do_nothing
		} else {
	        var objXML = createXmlDom();
	        objXML = loadXMLString(ret);
	        
	        var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
	        if (NodeList.length != 0) {
	            pHasOpinionYN = "Y";
	        } else {
	            pHasOpinionYN = "N";
	            ret = "cancel";
	        }
	        makeOpinionList(objXML);
		}
	} catch (e) {
		alert("openOpinionUI_New_Complete ::: " + e.description);
	}
}

function makeOpinionList(OpinionXML) {
	var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, "opinions");
    if (!field) return;

    var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
    field.innerHTML = " ";
    if (NodeList.length > 0) {
        for (i = NodeList.length - 1; i >= 0; i--) {
    		var opinionsTable = '<p style="margin-top: 10px;margin-left: 3px;margin-bottom: 3px;">▶ ' + getNodeText(NodeList[i].childNodes[3]) + ' - ' + getNodeText(NodeList[i].childNodes[2]) + ' - ' + getNodeText(NodeList[i].childNodes[1]) + '</p><p style="margin-top: 0px;margin-left: 10px;margin-bottom: 0px;">' + MakeXMLString(getNodeText(NodeList[i].childNodes[6])) + '</p>';
    		$(field).append(opinionsTable);
        }
    }
    SaveFile();
}

// 반송용으로 추가
function makeOpinionList4Bansong(OpinionXML) { 
	var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, "opinions");
    if (!field) return;

    field.innerHTML = " ";
	SaveFile();   
}

var aprattach_cross_dialogArguments = new Array();
function openFileAttachUI() {
    var parameter = pDocID;
    url = "/ezApprovalG/aprAttach.do?formID=" + encodeURI(pFormID) + "&docID=" + encodeURI(pDocID) + "&orgCompanyID=" + orgCompanyID + "&ext=" + ext;

    aprattach_cross_dialogArguments[0] = parameter;
    aprattach_cross_dialogArguments[1] = openFileAttachUI_Complete;

    DivPopUpShow(800, 610, url);
}

function openFileAttachUI_Complete(ret) {
    DivPopUpHidden();
}
function ChangeBtnState() {
    setMenuBar("btnReject", Btnflag);
    setMenuBar("btnStay", Btnflag);
    setMenuBar("btnApprove", Btnflag);
    setMenuBar("btnEdit", Btnflag);
    setMenuBar("btnModAprLine", Btnflag);
    setMenuBar("btnModAprDept", Btnflag);
    setMenuBar("btnFileAttach", Btnflag);
    setMenuBar("btnOpinion", Btnflag);
    setMenuBar("btnJunKyul", false);
    setMenuBar("btnConn", Btnflag);
}
function ChangeBtnStateTrue() {
    try {
        setMenuBar("btnSelDoc", Btnflag);
        setMenuBar("btnReject", Btnflag);
        var APRSTATE = GetElementsByTagName(xmldoc, "DOCSTATE");
        if (APRSTATE == "005")
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

        if (pDraftFlag == "CHAMJO") {
            setMenuBar("btnApprove", false);
            setMenuBar("btnReject", false);
            setMenuBar("btnReject2", false);
            setMenuBar("btnStay", false);
            setMenuBar("btnModAprLine", false);
            setMenuBar("btnModAprDept", false);
            setMenuBar("btnFileAttach", false);
        }
    } catch (e) {
        alert("ChangeBtnStateTrue  :: " + e.description);
    }
}
function chkBtn(pBtnflag, approvalFlag) {
    setMenuBar("btnApprove", pBtnflag);
    setMenuBar("btnReject", pBtnflag);
    setMenuBar("btnReject2", pBtnflag);
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
    setMenuBar("tbtnTotalSave", pBtnflag);
    setMenuBar("btntotaldocinfo", pBtnflag);

    if (trim(pDraftFlag) == "GONGRAM" || trim(pDraftFlag) == "CHAMJO") {
        setMenuBar("btnReject", false);
        setMenuBar("btnReject2", false);
        setMenuBar("btnStay", false);
    }
    else {
        setMenuBar("btnReject", pBtnflag);
        setMenuBar("btnReject2", pBtnflag);

        var APRSTATE = GetElementsByTagName(xmldoc, "DOCSTATE");
        if (APRSTATE == strAprState5)
            setMenuBar("btnStay", false);
        else
            setMenuBar("btnStay", pBtnflag);
    }
}
function chkBtnConfirm(para) {
    if (para == "1") {
        if (document.getElementById("btnApprove").style.display == "")
            bbtnApprove = "1";

        if (document.getElementById("btnReject").style.display == "")
            bbtnReject = "1";
        if (document.getElementById("btnReject2").style.display == "")
            bbtnReject2 = "1";
        if (document.getElementById("btnStay").style.display == "")
            bbtnStay = "1";

        if (document.getElementById("btnJunKyul").style.display == "")
            bbtnJunKyul = "1";

        if (document.getElementById("btnModAprLine").style.display == "")
            bbtnModAprLine = "1";

        if (document.getElementById("btnEdit").style.display == "")
            bbtnEdit = "1";

        if (document.getElementById("btnOpinion").style.display == "")
            bbtnOpinion = "1";

        if (document.getElementById("btnFileAttach").style.display == "")
            bbtnFileAttach = "1";

        if (document.getElementById("btnAprDocAttach").style.display == "")
            bbtnAprDocAttach = "1";

        if (document.getElementById("btnPrint").style.display == "")
            bbtnPrint = "1";

        if (document.getElementById("btnSave").style.display == "")
            bbtnSave = "1";

        if (document.getElementById("btnMail").style.display == "")
            bbtnMail = "1";
        else 
        	bbtnMail = "";

        if (document.getElementById("btnSetTaskCode").style.display == "")
            bbtnSetTaskCode = "1";

        if (document.getElementById("btnAddSepAttach").style.display == "")
            bbtnAddSepAttach = "1";

        if (document.getElementById("btnhistory").style.display == "")
            bbtnhistory = "1";

        if (document.getElementById("btnDocInfo").style.display == "")
            bbtnDocInfo = "1";

        if (document.getElementById("btnModAprDept").style.display == "")
            bbtnModAprDept = "1";

        if (document.getElementById("tbtnTotalSave").style.display == "")
            btbtnTotalSave = "1";

        if (document.getElementById("btntotaldocinfo").style.display == "")
            bbtntotaldocinfo = "1";       
        if (document.getElementById("btnAddRelatedCabinet").style.display == "")
            btnAddRelatedCabinet = "1";
    }
    else {
        if (bbtnApprove == "1")
            setMenuBar("btnApprove", true);

        if (bbtnReject == "1")
            setMenuBar("btnReject", true);
        
        if (bbtnReject2 == "1")
            setMenuBar("btnReject2", true);

        if (bbtnStay == "1")
            setMenuBar("btnStay", true);

        if (bbtnModAprLine == "1")
            setMenuBar("btnModAprLine", true);

        if (bbtnEdit == "1")
            setMenuBar("btnEdit", true);

        if (bbtnOpinion == "1")
            setMenuBar("btnOpinion", true);

        if (bbtnFileAttach == "1")
            setMenuBar("btnFileAttach", true);

        if (bbtnAprDocAttach == "1")
            setMenuBar("btnAprDocAttach", true);

        if (bbtnPrint == "1")
            setMenuBar("btnPrint", true);

        if (bbtnSave == "1")
            setMenuBar("btnSave", true);

        if (bbtnMail == "1")
            setMenuBar("btnMail", true);

        if (bbtnSetTaskCode == "1")
            setMenuBar("btnSetTaskCode", true);

        if (bbtnAddSepAttach == "1")
            setMenuBar("btnAddSepAttach", true);

        if (bbtnhistory == "1")
            setMenuBar("btnhistory", true);

        if (bbtnModAprDept == "1")
            setMenuBar("btnModAprDept", true);

        if (bbtnDocInfo == "1")
            setMenuBar("btnDocInfo", true);

        if (btbtnTotalSave == "1")
            setMenuBar("tbtnTotalSave", true);

        if (bbtntotaldocinfo == "1")
            setMenuBar("btntotaldocinfo", true);
        
        if (btnAddRelatedCabinet == "1")
            setMenuBar("btnAddRelatedCabinet", true);
    }
}
function getDocInfo() {
    try {
        xmldoc = document.getElementById("DOCINFO").dataSource;
        var APRSTATE = GetElementsByTagName(xmldoc, "FUNCTIONTYPE");
        if (getNodeText(APRSTATE[0]) == strAprState5)
            setMenuBar("btnStay", false);

        var opinionNode = GetElementsByTagName(xmldoc, "HASOPINIONYN");
        pHasOpinionYN = getNodeText(opinionNode[0]);

        var objNodes = xmldoc.documentElement.childNodes;
        if (objNodes) {
        	tempKeep = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/STORAGEPERIOD");
        	tempPublic = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ISPUBLIC");
        	tempUrgent = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/URGENTAPPROVAL");
        	tempKeyword = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/KEYWORD");
        	tempItemCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMCODE");
        	tempSecurity = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SECURITYCODE");
        	tempItemName = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMNAME");
        	tempItemName2 = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMNAME2");
        	tempSecurityDate = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SECURITYAPPROVAL");
        	pPublicityCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PUBLICITYCODE");
        	pPublicityYN = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PUBLICITYYN");
        	pLimitRange = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/LIMITRANGE");
        	pSummery = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SUMMARY");
        	pPageNum = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PAGENUM");
        	TaskCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/TASKCODE");
        	cabinetID = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/CABINETID");
        	pSpecialRecordCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SPECIALRECORDCODE");
        	
            /* xml데이터 추출 방법 변경으로 인한 주석처리
            tempSecurity = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[19]);
            tempKeep = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[20]);
            tempUrgent = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[21]);
            tempPublic = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[18]);
            tempKeyword = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[25]);
            tempItemCode = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[23]);
            tempItemName = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[24]);
            tempItemName2 = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[37]);
            pSummery = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[35]);
            pSpecialRecordCode = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[26]);
            pPublicityCode = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[27]);
            pPublicityYN = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[41]);
            pLimitRange = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[28]);
            pPageNum = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[29]);
            cabinetID = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[30]);
            TaskCode = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[31]);
            tempSecurityDate = getNodeText(GetChildNodes(SelectNodes(xmldoc, "DOCINFO/DATA")[0])[36]);
            */

            if (useOpenGov == "YES") {
                basis = SelectSingleNodeValueNew(xmldoc, "DATA/BASIS");
                reason = SelectSingleNodeValueNew(xmldoc, "DATA/REASON");
                listOpenFlag = SelectSingleNodeValueNew(xmldoc, "DATA/LISTOPENFLAG");
                fileOpenFlagList = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
                limitDate = SelectSingleNodeValueNew(xmldoc, "DATA/LIMITDATE");
            }
        }
    } catch (e) {
        alert("getDocInfo :: " + e.description);
    }
}
function getApprovInfo() {
    try {
        pOrgAprUserID = OrgAprUserID;
        pOrgAprUserName = OrgAprUserName;
        pOrgAprUserName2 = OrgAprUserName2;
        pOrgAprUserDeptID = OrgAprUserDeptID;
        var pMode = "APR";
    	var result = "";
    	
    	if (docState == "017") {
	 	   $.ajax({
	 			type : "POST",
	 			dataType : "text",
	 			async : false,
	 			url : "/ezApprovalG/getLineMode.do",
	 			data : {
	 					docID : pDocID,
	 					orgCompanyID : pCompanyID
	 					},
	 			success: function(xml){
	 				if (xml == "END") {
	 					pMode = "CHAMJOEND";
	 				} else {
	 					pMode = "CHAMJOAPR";
	 				}
	 			}        			
	 		});
    	}
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getApproveDocInfo.do",
    		data : {
    			docID : pDocID,
    			userID : pUserID,
    			deptID : OrgAprUserDeptID,
    			mode : pMode,
    			chamState : docState,
    			orgCompanyID : pCompanyID
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});
    	
    	result = loadXMLString(result);
        var xmlpara = createXmlDom();

        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/DOCINFO");
        var xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("DOCINFO").dataSource = xmlpara;

        pFormID = getNodeText(SelectSingleNodeNew(xmlpara, "DOCINFO/DATA/FORMID"));
        pOrgDocID = getNodeText(SelectSingleNodeNew(xmlpara, "DOCINFO/DATA/ORGDOCID"));

        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/ATTACHINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("ATTACHINFO").dataSource = xmlpara;

        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/APRLINEINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("APRLINEINFO").dataSource = xmlpara;

        var dataNodes = GetElementsByTagName(xmlpara, "DATA6");
        var lastIdx = dataNodes.length;
        drafterDeptid = getNodeText(dataNodes[lastIdx - 1]);
        
        aprDocTimeStamp = getNodeText(SelectSingleNodeNew(result, "APROVEDATA/APRDOCTIMESTAMP"));

        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/DOCFLAGINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);

        var node = GetElementsByTagName(xmlpara, "DocHref");
        pDocHref = getNodeText(node[0]);
        var node = GetElementsByTagName(xmlpara, "DocFlag");
        pDraftFlag = getNodeText(node[0]);

        var doctitle = GetElementsByTagName(result, "DOCTITLE");

        var docflagnode = GetElementsByTagName(xmlpara, "DocFlagValue");
        switch (trim(pDraftFlag)) {
            case "DRAFT":
                pDocType = getNodeText(docflagnode[0]);
                break;

            case "GONGRAM":
            	approvalType = "GONRAM";
                pOrgDocID = getNodeText(docflagnode[0]);
                GetChildNodes(document.getElementById("btnApprove"))[0].innerHTML = strLang10;
                setMenuBar("btnJunKyul", false);
                break;

            case "CHAMJO":
            	approvalType = "CHAMJO";
                pOrgDocID = getNodeText(docflagnode[0]);
                GetChildNodes(document.getElementById("btnApprove"))[0].innerHTML = strLang10;
                setMenuBar("btnJunKyul", false);
                setMenuBar("btnReject", false);
                setMenuBar("btnReject2", false);
                setMenuBar("btnStay", false);
                setMenuBar("btnOpinion", true); // 2019-04-02 천성준 - 참조자가 작성된 의견은 확인이 가능하기에 의견 버튼 표출 
                setMenuBar("btnFileAttach", false);
                setMenuBar("btnAprDocAttach", false);
                setMenuBar("btnEdit", false);
                break;

            case "HABYUI":
            	approvalType = "HABYUI";
                setMenuBar("btnEdit", false);
                setMenuBar("btnModAprDept", false);
                setMenuBar("btnFileAttach", false);
                setMenuBar("btnAprDocAttach", false);
                break;

            case "SUSIN":
            	approvalType = "SUSIN";
                pOrgDocID = getNodeText(docflagnode[0]);
                break;

            case "GAMSA":
            	approvalType = "GAMSA";
                setMenuBar("btnApprove", true);
                setMenuBar("btnReject", false);
                setMenuBar("btnReject2", false);
                setMenuBar("btnStay", false);
                setMenuBar("btnJunKyul", false);
                setMenuBar("btnModAprLine", false);
                setMenuBar("btnModAprDept", false);
                setMenuBar("btnAprDocAttach", false);
                setMenuBar("btnEdit", false);
                setMenuBar("btnFileAttach", false);
                break;

            case "B_GAMSA":
            	approvalType = "B_GAMSA";
                setMenuBar("btnApprove", true);
                setMenuBar("btnReject", true);  // 부서감사 유형 감사부서에서 반송 가능하도록 수정. 2020-02-28 홍대표
                setMenuBar("btnReject2", false);
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

    } catch (e) {
        alert("getApprovInfo :: " + e.description);
    }
}
function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;
            pleftpos = Number(width) - 725;
            heigth = Number(heigth) - 30;
            width = Number(width) - pleftpos;
            left = pleftpos / 2;
        } else {
            heigth = Number(heigth) - 30;
            width = Number(width) - 10;
        }

        var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left;

        window.open(wfileLocation, "view", param);
    } catch (e) {
        alert("openwindow :: " + e.description);
    }
}
function getCurApproverAprLine(type) {
	var result = "";
    var pMode = "";
	if (docState == "017") {
		  $.ajax({
	 			type : "POST",
	 			dataType : "text",
	 			async : false,
	 			url : "/ezApprovalG/getLineMode.do",
	 			data : {
	 					docID : pDocID,
	 					orgCompanyID : orgCompanyID
	 					},
	 			success: function(xml){
	 					pMode = xml;
	 			}        			
		  });
	}
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/aprLineRequest.do",
		data : {
				docID    : pDocID, 
				userID 	 : "",
				formID   : "",
				orgCompanyID : orgCompanyID,
				isUsed   : type,
				mode     : pMode
				},
		success: function(xml){
			result = xml;
		}        			
	});
    
    Resultxml = loadXMLString(result);

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
    LastKyulSN = getLastSignSN(objNodes);
    
    //최종 결재에 개인 합의 추가 하기 위해 결재선에 표시된 전체 개수
    LastTotalKyulSN = getLastTotalSignSN(objNodes);
    LastSignSN = objNodes.length;
    
    for (var i = objNodes.length - 1; i < objNodes.length; i--) {
    	// i가 음수값을 가지지 않도록 임시 수정
    	if (i < 0) {
    		break;
    	}
    	
        var params = new Array();
        params[0] = "0";
        var dataNodes = GetLastChildNodes(objNodes[i], params);

        var pCurrentAprState = getNodeText(dataNodes[12]);
        if ((getNodeText(dataNodes[4]).toLowerCase() == pUserID.toLowerCase()) && ((pCurrentAprState == strAprState2) || (pCurrentAprState == strAprState5) || (pCurrentAprState == strAprState0))) {
            pAprLineType = getNodeText(dataNodes[11]);
            wAprMemberSN = getNodeText(dataNodes[19]);

            if (approvalFlag == "S") {
            	if (pAprLineType == strAprType4)
                    var pTmpAprLineType = strAprType1;
            	
            	pAprMemberSN = SAprLineSNCount(pAprLineType, objNodes, pTmpAprLineType);
            } else {
            	if (i < 1)
            		pAprLineB4type = "";
            	else
            		pAprLineB4type = getNodeText(GetLastChildNodes(objNodes[i - 1], params)[11]); // 대결자(016) 이후 최종결재자로 전결자(004)가 존재하는 경우, 즉 위임전결사항의 대결 처리를 위한 플래그
            	
            	if (pAprLineType == strAprType4 || pAprLineType == strAprType16)
            		var pTmpAprLineType = strAprType1;
            	
            	pAprMemberSN = AprLineSNCount(pAprLineType, objNodes, pTmpAprLineType);
            }
            if (docState == "017") {
            	if (pAprLineType == "007") {
            		break;
            	} 
            } else {
            	if (pCurrentAprState != strAprState0) {
            		break;
            	}
            }
        }
    }
    
    var auditSignCnt = 0;
    // auditSign set
    for(var i=0; i<objNodes.length; i++) {
    	var apprType = objNodes[i].getElementsByTagName("CELL")[0].getElementsByTagName("DATA11")[0].textContent;
    	
    	if(apprType == "005") {
    		auditSignCnt++;
    	}
    }
    if(auditSignCnt > 1) {
    	for(var i=0; i<objNodes.length; i++) {
        	var apprType = objNodes[i].getElementsByTagName("CELL")[0].getElementsByTagName("DATA11")[0].textContent;
        	var userId = objNodes[i].getElementsByTagName("CELL")[0].getElementsByTagName("DATA4")[0].textContent;
        	
        	if(apprType == "005") {
        		auditSignId = userId;
        		break;
        	}
        }
    }
    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType2)
        setMenuBar("btnJunKyul", false);
    /* 2024-04-22 - 보류된 문서여도 결재유형이 개인병렬협조(009), 결재상태가 진행(002)일 경우, 보류버튼 활성화 */
    if (pCurrentAprState == strAprState2 && pAprLineType == strAprType9 ) {
        setMenuBar("btnStay", true);
    }
}
/**
 * xmlpara에 결재관련 정보 저장
 * pApproveFlag 1 : 결재, 2 : 반송, 3 : 보류
 * */
function SaveApproveInfo(pApproveFlag) {
	var fields = message.GetFieldsList();
    var rtnVal = SaveFile();

    if(rtnVal.toUpperCase() != "TRUE") {
        return rtnVal;
    }

    SignSave();

    var objNodes = GetChildNodes(GetChildNodes(document.getElementById('DOCINFO').dataSource.childNodes[0])[0]);

    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", getNodeText(objNodes[0]));
    createNodeAndInsertText(xmlpara, objNode, "FORMID", getNodeText(objNodes[1]));
    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", getNodeText(objNodes[2]));
    createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", getNodeText(objNodes[3]));
    createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", getNodeText(objNodes[4]));
    createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", "002");
    createNodeAndInsertText(xmlpara, objNode, "HREF", getNodeText(objNodes[6]));
    
    var field = message.GetListItem(fields, "doctitle");
    pDocTitle = field.textContent;
    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", pDocTitle);
    // 경우에 따른 DOCNO 설정.
    
    if (pApproveFlag == "2") {
        field = message.GetListItem(fields, "opinions");
        if (field) {
        	field.innerHTML = " ";
        }
        
    	if (approvalFlag == 'G' && pDraftFlag == "SUSIN" && useReceiveDocNo == 'NO') {
    		if (field) {
    			var forTest = getfieldValue(field).slice(-1);
    			if (getfieldValue(field).slice(-1) == "-") {
    				createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field).substring(0, getfieldValue(field).length - 1));
    			} else {
    				createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
    			}
    		} else {
    			var field = message.GetListItem(fields, "receiptnumber");
    			if (field) {
    				var forTest = getfieldValue(field).slice(-1);
    				if (getfieldValue(field).slice(-1) == "-") {
    					createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field).substring(0, getfieldValue(field).length - 1));
    				} else {
    					createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
    				}
    			}
    		}
    	} else {
    		var field = message.GetListItem(fields, "deptshortedname");
    		if (field) {
    			var forTest = getfieldValue(field).slice(-1);
    			if (getfieldValue(field).slice(-1) == "-") {
    				createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field).substring(0, getfieldValue(field).length - 1));
    			} else {
    				createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
    			}
    		} else {
    			var field = message.GetListItem(fields, "docnumber");
    			if (field) {
    				var forTest = getfieldValue(field).slice(-1);
    				
    				/* 2021-08-25 홍승비 - 개인병렬협조/합의자가 반송하는 경우, 테넌트 컨피그 PersonalAgreeReturnType를 체크하여 DOCNO 뒤의 '-' 문자를 지우거나 유지함 */
    				if (getfieldValue(field).slice(-1) == "-") {
    					// PersonalAgreeReturnType값이 1인 경우, 개인병렬협조/합의자가 반송해도 다음 결재권자에게 문서를 전달하며 결재가 가능하다.
    					var personalAgreeReturnType = getPersonalAgreeReturnType();
    					if (pAprLineType == "009" && personalAgreeReturnType.trim() == "1") {
    						createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
    					} else {
    						createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field).substring(0, getfieldValue(field).length - 1));
    					}
    				} else {
    					createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
    				}
    			} else {
    				var field = message.GetListItem(fields, "bedocnumber");
    				if (field) {
    					var forTest = getfieldValue(field).slice(-1);
    					if (getfieldValue(field).slice(-1) == "-") {
    						createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field).substring(0, getfieldValue(field).length - 1));
    					} else {
    						createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
    					}
    				} else {
    					createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
    				}
    			}
    		}
    	}
    } else {
    	if (approvalFlag == 'G' && pDraftFlag == "SUSIN" && useReceiveDocNo == 'NO') {
    		var field = message.GetListItem(fields, "deptshortedname");
        	if (field) {
        		createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
        	} else {
        		var field = message.GetListItem(fields, "receiptnumber");
        		if (field) {
        			createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
        		}
        	}
    	} else {
    		var field = message.GetListItem(fields, "deptshortedname");
        	if (field) {
        		createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
        	} else {
        		/* 2025-02-18 홍승비 - 전자결재 G > useReceiveDocNo 플래그에 관계없이 수신문의 접수번호를 문서번호로 사용하도록 수정 */
        		// useReceiveDocNo가 YES인 경우, 최종결재 시점이 아닌 수신문 접수 시점에 접수번호를 미리 채번함
        		var field = "";
        		if (approvalFlag == 'G' && pDraftFlag == "SUSIN") {
        			field = message.GetListItem(fields, "receiptnumber");
        		} else {
        			field = message.GetListItem(fields, "docnumber");
        		}
        		
        		if (field) {
        			createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
        		} else {
        			var field = message.GetListItem(fields, "bedocnumber");
        			if (field) {
        				createNodeAndInsertText(xmlpara, objNode, "DOCNO", getfieldValue(field));
        			} else {
        				createNodeAndInsertText(xmlpara, objNode, "DOCNO", "");
        			}
        		}
        	}
    	}
    }

    if (pHasAttachYN == "") {
        createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", getNodeText(objNodes[9]));
    } else {
        createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
    }

    var objNode;

    if (pHasOpinionYN == "") {
        createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", getNodeText(objNodes[10]));
    } else {
        createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);
    }


    createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "");
    createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "");
    createNodeAndInsertText(xmlpara, objNode, "WRITERID", getNodeText(objNodes[13]));
    createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", getNodeText(objNodes[14]));
    createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", getNodeText(objNodes[15]));
    createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", getNodeText(objNodes[16]));
    createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", getNodeText(objNodes[17]));
    createNodeAndInsertText(xmlpara, objNode, "HTML", "");
    createNodeAndInsertText(xmlpara, objNode, "PUSERID", pOrgAprUserID);
    createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", pOrgAprUserName);
    createNodeAndInsertText(xmlpara, objNode, "PDEPTID", pOrgAprUserDeptID);
    createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");

    createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
    createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
    createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);
    createNodeAndInsertText(xmlpara, objNode, "PROXYUSERID", pingUserID);

    createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
    createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
    createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
    createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);

    createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");
    createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
    createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
    createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", pPublicityYN);
    createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
    createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
    createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
    createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
    createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
    createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");
    createNodeAndInsertText(xmlpara, objNode, "ORGCOMPANYID", orgCompanyID);

    var g_SepAttachLVXml = "";
    g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
    if (!g_SepAttachLVXml) {
        createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
    } else {
        createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));
    }

    createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);

    createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

    createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", getNodeText(SelectSingleNodeNew(xmldoc, "DOCINFO/DATA/WRITERNAME2"))); 
    createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", getNodeText(SelectSingleNodeNew(xmldoc, "DOCINFO/DATA/WRITERJOBTITLE2")));
    createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", getNodeText(SelectSingleNodeNew(xmldoc, "DOCINFO/DATA/WRITERDEPTNAME2")));

    createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", pOrgAprUserName2);
    createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);

    if (curDocNum != "") {
   	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
   } else {
   	 createNodeAndInsertText(xmlpara, objNode, "CURDOCNUM", curDocNum);
   }
    
    //반송일때, 반송문서를 부서문서함(반송함)에 보관할 부서ID를 가져온다.
    if (pApproveFlag == "2") {
    	createNodeAndInsertText(xmlpara, objNode, "BANSONGDEPTID", getBansongDeptID());
    }
    
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

/*
 * 반송함에 들어갈 부서를 반환함
 * - 기안결재중 반송은 기안부서
 * - 접수결재중 반송은 접수부서
 * */
function getBansongDeptID() {
	var rtnDeptID = "";
	
	try {
		var oRows = SelectNodes(document.getElementById("APRLINEINFO").dataSource, "LISTVIEWDATA/ROWS/ROW");
		var oRowsLeng = oRows.length;
		if (oRowsLeng > 0) {
			rtnDeptID = SelectSingleNodeValue(GetChildNodes(oRows[oRowsLeng - 1])[0], "DATA6");
		} else {
			rtnDeptID = draftDeptID;
		}
	} catch (e) {
		console.error(e.description);
		rtnDeptID = draftDeptID;
	}
	
	return rtnDeptID;
}

function getfieldValue(pfield) {
    var rtnVal = "";
    if (pfield) {
        switch (pfield.tagName) {
            case "TD":
                rtnVal = pfield.textContent;
                break;
            case "SELECT":
                rtnVal = pfield.value;
                break;
            case "INPUT":
                rtnVal = pfield.value;
                break;
        }
    }
    return rtnVal;
}
function SaveFile() {
    // 확인, 참조일 경우 파일 저장 안함
    if (pAprLineType == strAprType2 || pAprLineType == strAprType7) return "TRUE";

	headerAction("open");
	var result = "";
    var mhtBody = "";
	mhtBody = message.Get_EditorBodyHTML();
	EmbedContentIntoXML(mhtBody);
	mhtBody = ConvertHTMLtoMHT(mhtBody);
	
	var data = {
		docID : pDocID,
		html  : mhtBody,
		formId : pFormID,
		orgCompanyID : orgCompanyID
	}
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveFile.do",
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
    var objNode;
    var mhtBody = "";
    var HTML = document.createElement("HTML");
    var HEAD = document.createElement("HEAD");
    var META = document.createElement("META");
    var META2 = document.createElement("META");
    var BODY = document.createElement("BODY");

    META.content = "text/html; charset=utf-8";
    META.httpEquiv = "Content-Type";

    META2.name = "GENERATOR";
    META2.content = "MSHTML 10.00.9200.16721";

    HEAD.appendChild(META);
    HEAD.appendChild(META2);

    HTML.appendChild(HEAD);

    Doc_ContentHtml = document.createElement("DIV");
    Doc_ContentHtml.innerHTML = OrgHtml;
    BODY.appendChild(Doc_ContentHtml);
    HTML.appendChild(BODY);

    mhtBody = HTML.outerHTML;
    mhtBody = ConvertHTMLtoMHT(mhtBody);
	
	var data = {
		docID : pDocID,
        formId : pFormID,
		html  : mhtBody,
		orgCompanyID : orgCompanyID
	}

    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveFile.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});

    return result;
}
function openApproveDocList() {
    var parameter = "";
    var url = "AprDocList.html";
    var feature = "status:no;dialogHeight: 410px; dialogWidth: 387px; resizable: no; help: no;edge:sunken;scroll:no";
    feature = feature + GetShowModalPosition(387, 430);
    var rvalue = window.showModalDialog(url, parameter, feature);
    return rvalue;
}
function openAprLineUI() {
    var pChangeAprLineparameter = new Array();
    var pFormID;
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

    var URL = "/ezApprovalG/aprLine.do";
    var parameter = "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";
    parameter = parameter + GetShowModalPosition(990, 720);
    var ret = window.showModalDialog(URL, pChangeAprLineparameter, parameter);
    return ret;
}
function CheckDocCellInfo() {
    var fields = message.GetFieldsList();
    var field;
    var fieldname;
    var pSusinNextSN;

    var SignInfoFlag = true;
    hapyuiCount = 0;
    SignCount = 0;
    gongramCount = 0;

    for (i = 0 ; i < fields.length ; i++) {
        var field = fields[i];

        if (pDraftFlag == "SUSIN") {
            var pSignSusin = pSusinSN + "sign";
            if (field.id.substr(0, 5) == pSignSusin) {
                SignCount = SignCount + 1;
            }
        } else {
            if (field.id.substr(0, 4) == "sign") {
                SignCount = SignCount + 1;
            }
        }

        if (pDraftFlag == "SUSIN") {
            var pSignSusin = pSusinSN + "habyuisign";
            if (field.id.substr(0, 11) == pSignSusin) {
                hapyuiCount = hapyuiCount + 1;
            }
        } else {
            if (field.id.substr(0, 10) == "habyuisign") {
                hapyuiCount = hapyuiCount + 1;
            }
        }
        if (field.id.substr(0, 9) == "gamsasign") {
            gamsaCount = gamsaCount + 1;
        }
        if (field.id.substr(0, 7) == "gongram") {
            gongramCount = gongramCount + 1;
        }
        if (field.id.substr(0, 5) == "jikwe") {
            if (SignInfoFlag) {
                SignInfo = field.textContent;
                SignInfoFlag = false;
            } else {
                SignInfo = field.textContent + ";" + SignInfo;
            }
        }
    }
    pSuSinFlag = "N";
    if (pDraftFlag != "SUSIN") {

        var RtnVal = message.GetListItem(fields, "recipient");;
        if (RtnVal != null) {
            pSuSinFlag = "Y";
        } else {
            pSuSinFlag = "N";
        }
    }
    pSusinNextSN = Number(pSusinSN) + 1;

    fieldname = pSusinNextSN + "sign1";
    var field;
    field = message.GetListItem(fields, fieldname);
    if (field)
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
    	//DrawAutoAprLine(ret[1], pDraftFlag);
    	New_DrawAutoLine(ret[1], pDraftFlag);
    } else {
    	reMappingSign = true;
    	xmlKuljea = ret;
    }

    var xmldom = createXmlDom();
    xmldom = loadXMLString(xmlKuljea);
    var objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    var fields = message.GetFieldsList();
    var findstring;
    var lastno;
    var count = objNodes.length;
    field = message.GetListItem(fields, "refer");
    if (field) {
        setNodeText(field , " ");
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    for (i = 1; i < fields.length; i++) {
        field = message.GetListItem(fields, "gongram" + i);;
        if (field) {
            setNodeText(field , " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
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
        lastKyulName = OrderName[LastSignSN]
        lastKyuljiwee = OrderJobtitle[LastSignSN]
        var field = message.GetListItem(fields, "lastKyuljikwee");
        if (field)
            setNodeText(field, lastKyuljiwee);

        var field = message.GetListItem(fields, "lastKyulName");
        if (field)
            setNodeText(field, lastKyulName);
    }
    else {
        lastKyulName = OrderName[LastSignSN]
        lastKyuljiwee = OrderJobtitle[LastSignSN]
        var field = message.GetListItem(fields, "slastKyuljikwee");
        if (field)
            setNodeText(field, lastKyuljiwee);

        var field = message.GetListItem(fields, "slastKyulName");
        if (field)
            setNodeText(field, lastKyulName);
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
                refer = "";
                refer = refer + OrderName[i];
                referCnt = referCnt + 1
            }
            else
                refer = refer + ", " + OrderName[i];
        }
    }
    if (refer != "") {
        fieldname = "refer";
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field , refer);
        }
    }

    var susinSN = ""
    if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N")) {
        susinSN = pSusinSN
    }

    for (i = startIdx; i <= 20; i++) {
        fieldname = susinSN + "jikwe" + i
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field , " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";

        }
        fieldname = susinSN + "sign" + i
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field , " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        fieldname = susinSN + "seumyungdate" + i
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field , " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
        
        fieldname = susinSN + "approdept" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
            setNodeText(field , " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
    for (i = 1; i < 50; i++) {
        name = susinSN + "habyuidate" + i
        field = message.GetListItem(fields, name);
        if (field) {
            if (!trim(getNodeText(field))) {
                name = susinSN + "habyui" + i
                field = message.GetListItem(fields, name);
                if (field) {
                    setNodeText(field , " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }

                fieldname = susinSN + "habyuisign" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    setNodeText(field , " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }

                fieldname = susinSN + "habyuipositon" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    setNodeText(field , " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
                
                fieldname = susinSN + "habyuiapprodept" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    setNodeText(field , " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
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
                field = message.GetListItem(fields, "AprLine");

                var cnt = 20;
                if (field)
                    cnt = OrderType.length;


                for (k = 1; k <= cnt; k++) {
                    if (pDraftFlag == "SUSIN" || (pDraftFlag == "B_GAMSA" && ConvertYN == "N"))
                        signID = pSusinSN + "sign" + k
                    else
                        signID = "sign" + k

                    field = message.GetListItem(fields, signID);
                    if (field) {
                        var LastSignNo1 = k;
                    }
                }
                idx = LastSignNo1;
            }
            
            if (junGyulFlag == "1") { // 전결 이후 결재안함(003) 결재자들도 서명칸에 표출함
    			// 아무것도 안함
    		} else if (junGyulFlag == "4") { // 전결 이후 결재안함(003) 결재자들은 서명칸에 표출하지 않음
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
                    field = message.GetListItem(fields, fieldname)
                    if (field)
                        setNodeText(field , OrderJobtitle[i]);

                    fieldname = susinSN + "sign" + idx;
                    field = message.GetListItem(fields, fieldname)
                    if (field)
                        field.innerHTML = OrderName[i] + "<br>" + OrderReason[i];
                    
                    fieldname = susinSN + "approdept" + idx;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                    	setNodeText(field, OrderDept[i]);
                    }
                    idx = idx + 1;
                    continue;
                }
            }

            fieldname = susinSN + "jikwe" + idx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                if (trim(OrderJobtitle[i]) == "") {
                    setNodeText(field , " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
                else
                    setNodeText(field , OrderJobtitle[i]);
            }

            /* 2020-07-27 홍승비 - 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정 */
            fieldname = susinSN + "sign" + idx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	// 서명필드만 존재
            	if (message.GetListItem(fields, (susinSN + "sign" + idx)) != null && message.GetListItem(fields, (susinSN + "seumyung" + idx)) == null) {
            		/* 2022-08-04 홍승비 - 전결인 경우 전결 표시를 함께 부여 (단, draftJunGyulFlag를 체크하여 기안 시점에 '전결' 텍스트를 표출한 경우에만 동일하게 표출함) */
            		if (draftJunGyulFlag == '1' && OrderType[i] == strAprType4) {
            			field.innerHTML = (strLang6 + "<br>" + OrderName[i]);
            		} else {
            			setNodeText(field , OrderName[i]);
            		}
            	}
            	// 서명필드 + 결재자명 필드가 함께 존재
            	else if (message.GetListItem(fields, (susinSN + "sign" + idx)) != null && message.GetListItem(fields, (susinSN + "seumyung" + idx)) != null) {
            		field.innerHTML = "[NOSLASH]";
            	}
            	// 그 외의 경우, 아무런 값이 부여되지 않으므로 슬래시 이미지를 표출
            	else {
            		//field.innerHTML = OrderName[i];
            	}
            }
            
            fieldname = susinSN + "seumyung" + idx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	field.innerHTML = OrderName[i];
            }
            
            fieldname = susinSN + "approdept" + idx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	setNodeText(field, OrderDept[i]);
            }
            idx = idx + 1;
        }

        if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9) { // 개인순차합의, 개인병렬합의
            fieldname = susinSN + "habyui" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                setNodeText(field , OrderDept[i]);
            }

            /* 2020-07-27 홍승비 - 합의자명 필드가 존재하지 않는 경우, 합의자 사인 필드에 이름 표출하도록 수정 */
            fieldname = susinSN + "habyuisign" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	// 합의자 사인 필드만 존재, 합의자명 필드 없음
            	if (message.GetListItem(fields, ("habyuisign" + hidx)) != null && message.GetListItem(fields, ("habyuija" + hidx)) == null) {
            		setNodeText(field , OrderName[i]);
            	}
                //setNodeText(field , OrderName[i]);
            }
            
            fieldname = susinSN + "habyuija" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	setNodeText(field , OrderName[i]);
            }

            fieldname = susinSN + "habyuipositon" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                setNodeText(field , OrderJobtitle[i]);
            }
            
            fieldname = susinSN + "habyuiapprodept" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	setNodeText(field , OrderDept[i]);
            }
            hidx = hidx + 1;
        }
        
        if (OrderType[i] == strAprType11 || OrderType[i] == strAprType12) { // 부서순차합의, 부서병렬합의
        	fieldname = susinSN + "habyui" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                setNodeText(field , OrderDept[i]);
            }

            fieldname = susinSN + "habyuisign" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                //setNodeText(field , OrderName[i]);
            	setNodeText(field , OrderDept[i]);
            }

            fieldname = susinSN + "habyuipositon" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                setNodeText(field , OrderJobtitle[i]);
            }
            
            fieldname = susinSN + "habyuiapprodept" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	setNodeText(field , OrderDept[i]);
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

function ReAprLineSingMapping(ret) {
    var xmlKuljea, chamjo, hapyuiCnt, SignCnt, referCnt, xmlReDraft;
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
        New_DrawAutoLine(ret[0], pDraftFlag);
    }
    else {
        xmlKuljea = ret[1];
        xmlReDraft = ret[5];
        New_DrawAutoLine(ret[1], pDraftFlag);
    }

    var xmldom = createXmlDom();
    xmldom = loadXMLString(xmlKuljea);
    var objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    var fields = message.GetFieldsList();
    var findstring;
    var lastno;

    var count = objNodes.length;
    field = message.GetListItem(fields, "refer");
    if (field) {
    	setNodeText(field, " ");
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    for (i = 1; i < fields.length; i++) {
        field = message.GetListItem(fields, "gongram" + i);
        if (field) {
        	setNodeText(field, " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }

    for (i = 0; i < count; i++) {
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

    if (isSplit == "Y")
        SplitSign(OrderType, OrderName, OrderDept, OrderStat, OrderJobtitle);

    if (pDraftFlag != "SUSIN") {
        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];
        var field = message.GetListItem(fields, "lastKyuljikwee");
        if (field)
        	setNodeText(field , lastKyuljiwee);

        var field = message.GetListItem(fields, "lastKyulName");
        if (field)
        	setNodeText(field , lastKyulName);
    }
    else {
        lastKyulName = OrderName[LastSignSN];
        lastKyuljiwee = OrderJobtitle[LastSignSN];
        var field = message.GetListItem(fields, "slastKyuljikwee");
        if (field)
        	setNodeText(field , lastKyuljiwee);

        var field = message.GetListItem(fields, "slastKyulName");
        if (field)
        	setNodeText(field , lastKyulName);
    }

    var hapyuiCnt = 1;
    var startIdx = 0;

    for (i = 1; i < OrderStat.length; i++) {
        if (OrderStat[i] == strAprState1) {
            startIdx = startIdx;
            break;
        }
        else {
        	// 정주환 결재라인 변경 startidx 수정
            if ((OrderStat[i] == strAprState2 && OrderType[i] != strAprType7) || OrderStat[i] == strAprState5)
                startIdx = startIdx + 1;
            else if (OrderType[i] != strAprType2 && OrderType[i] != strAprType7 && OrderType[i] != strAprType8 && OrderType[i] != strAprType9 && OrderType[i] != strAprType11 && OrderType[i] != strAprType12)
                startIdx = startIdx + 1;
            else if (OrderType[i] == strAprType8 ||OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)
                hapyuiCnt = hapyuiCnt + 1;
        }
    }
    var refer = "";
    referCnt = 1;
    for (i = 1; i < OrderType.length; i++) {
        if (OrderType[i] == strAprType7) {
            if (referCnt == 1) {
                refer = "";
                refer = refer + OrderName[i];
                referCnt = referCnt + 1;
            }
            else
                refer = refer + ", " + OrderName[i];
        }
    }
    if (refer != "") {
        fieldname = "refer";
        field = message.GetListItem(fields, fieldname);
        if (field) {
        	setNodeText(field , refer);
        }
    }
    var susinSN = "";
    if (pDraftFlag == "SUSIN") {
        susinSN = pSusinSN;
    }
    for (i = startIdx; i < 10; i++) {
        fieldname = susinSN + "jikwe" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
        	setNodeText(field, " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        fieldname = susinSN + "sign" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        fieldname = susinSN + "seumyungdate" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
        	setNodeText(field, " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
    for (i = 1; i < 50; i++) {
        name = susinSN + "habyuisign" + i;
        field = message.GetListItem(fields, name);
        if (field) {
            if (!trim(field.textContent)) {
                name = susinSN + "habyui" + i;
                field = message.GetListItem(fields, name);
                if (field) {
                	setNodeText(field, " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }

                fieldname = susinSN + "habyuisign" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                	setNodeText(field, " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }

                fieldname = susinSN + "habyuipositon" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                	setNodeText(field, " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }

                fieldname = susinSN + "habyuidate" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                	setNodeText(field, " ");
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
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

    var chamjocount = 0;
    for (i = startIdx; i < OrderJobtitle.length; i++) {
        if (OrderType[i] == strAprType7) {
            chamjocount = chamjocount + 1;
        }
    }

    var tempLastSignSN = OrderType.length;
    for (i = 1; i < OrderType.length; i++) {
        if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) 
            tempLastSignSN = i;
    }

    for (i = startOrder; i < OrderJobtitle.length; i++) {
        if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3)
        {
            var j, chkflag;
            if (OrderType[i] == strAprType3) {
                chkflag = false;
                for (j = startOrder; j < i; j++) {
                    if (OrderType[j] == strAprType4 || OrderType[j] == strAprType16) {
                        chkflag = true;
                        break;
                    }
                }
                if (!chkflag) {
                    fieldname = susinSN + "jikwe" + idx;
                    field = message.GetListItem(fields, fieldname);
                    if (field) {
                    	setNodeText(field , OrderJobtitle[i]);
                        if (OrderSuggester[i] == "Y")
                        	setNodeText(field , "★" + getNodeText(field));
                        if (OrderReporter[i] == "Y")
                        	setNodeText(field , "⊙" + getNodeText(field));
                    }

                    fieldname = susinSN + "sign" + idx;
                    field = message.GetListItem(fields, fieldname);
                    if (field)
                        field.innerHTML = OrderName[i] + "<br/>" + OrderReason[i];

                    idx = idx + 1;
                    continue;
                }
            }

            if (pDraftFlag == "HABYUI" && (LastSignSN == 1 ||  LastSignSN == i)) {
                for (k = 1; k < 10; k++) {
                    if (pDraftFlag == "SUSIN")
                        signID = pSusinSN + "sign" + k;
                    else
                        signID = "sign" + k;

                    field = message.GetListItem(fields, signID);//CKEDITOR-원본 : field = fields.Item(signID)
                    if (field)
                        LastSignNo = k;
                }
                idx = LastSignNo;
            }

            fieldname = susinSN + "jikwe" + idx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	setNodeText(field , OrderJobtitle[i]);
                if (OrderSuggester[i] == "Y")
                	setNodeText(field , "★" + getNodeText(field));
                if (OrderReporter[i] == "Y")
                	setNodeText(field , "⊙"  + getNodeText(field));
            }

            fieldname = susinSN + "sign" + idx;
            field = message.GetListItem(fields, fieldname);
            if (field && pDraftFlag == "HABYUI") {
            	setNodeText(field , OrderName[i]);
            }
            idx = idx + 1;
        }

        if (OrderType[i] == strAprType8 ||OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
            fieldname = susinSN + "habyui" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	setNodeText(field , OrderDept[i]);
            }

            fieldname = susinSN + "habyuisign" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            }

            fieldname = susinSN + "habyuipositon" + hidx;
            field = message.GetListItem(fields, fieldname);
            if (field) {
            	setNodeText(field , OrderJobtitle[i]);
                if (OrderSuggester[i] == "Y")
                	setNodeText(field , "★" + getNodeText(field));
                if (OrderReporter[i] == "Y")
                	setNodeText(field , "⊙" + getNodeText(field));
            }
            hidx = hidx + 1;
        }
    }
    
    // 정주환 결재라인수정시 오류 수정 lineapr
    var field = message.GetListItem(fields, "lineapr");
//    if (field == message.GetListItem(fields, "lineapr")) {
    if(field){
        if (idx > 5) {
            message.GetListItem(fields, "lineapr").style.display = "";
            for (i = 0; i < message.GetListItem(fields, "lineapr").childNodes.length; i++) {
                if(message.GetListItem(fields, "lineapr").children[i] != undefined)
                    message.GetListItem(fields, "lineapr").children[i].style.display = "";
            }
        }
        else {
            message.GetListItem(fields, "lineapr").style.display = "";
            for (i = 0; i < message.GetListItem(fields, "lineapr").childNodes.length; i++) {
                if (message.GetListItem(fields, "lineapr").children[i] != undefined)
                    message.GetListItem(fields, "lineapr").children[i].style.display = "none";
            }
        }
    }
    
    field = message.GetListItem(fields, "linehab");
//    if (field == message.GetListItem(fields, "linehab")) {
    if(field){
        if (hidx > 5) {
            message.GetListItem(fields, "linehab").style.display = "";
            for (i = 0; i < message.GetListItem(fields, "linehab").childNodes.length; i++) {
                if(message.GetListItem(fields, "linehab").children[i] != undefined)
                    message.GetListItem(fields, "linehab").children[i].style.display = "";
            }
        }
        else {
            message.GetListItem(fields, "linehab").style.display = "";
            for (i = 0; i < message.GetListItem(fields, "linehab").childNodes.length; i++) {
                if (message.GetListItem(fields, "linehab").children[i] != undefined)
                    message.GetListItem(fields, "linehab").children[i].style.display = "none";
            }
        }
    }

    setMenuBar("btnJunKyul", false);
}
function ChangeHapYuiInfo() {
    var fields = message.GetFieldsList();
    var field;
    var fieldname;
    var i;

    for (i = 1 ; i <= hapyuiCount ; i++) {
        var TmpRtnVal;
        fieldname = "habyuidate" + i;
        field = message.GetListItem(fields, fieldname);
        if (field) {
            TmpRtnVal = field.textContent;
            TmpRtnVal = trim(TmpRtnVal);
            if (TmpRtnVal == "") {
                fieldname = "habyui" + i;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    field.textContent = "";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
            }
        }
    }
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
			result = loadXMLString(xml);
		}
	});

    Resultxml = result;

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
    var SignNodeList = objNodes.length;
    // 결재 서명 정보가 존재하는 경우
    // if (SignNodeList != 0) {
        var parameter = pingUserID;
        aprsign1_cross_dialogArguments[0] = parameter;
        aprsign1_cross_dialogArguments[1] = openSingUI_Complete;
        // 서명하는 팝업 호출
        DivPopUpShow(350, 310, "/ezApprovalG/aprSign.do");
        /*
        }
        else {
            var ret = "NAME";
            Approv_Complete(ret);
        }
        */
}
/**
 * sentdate field가 존재하는 경우
 * */
function SetAutoPropFinal() {
    try {
        var fields = message.GetFieldsList();

        if (!fields) return;

        var CurrentDate;
        var RtnVal = getGyulJeDate();
        var CurrentDate = RtnVal.split(".");
        CurrentDate = CurrentDate[1] + "." + CurrentDate[2];
        for (i = 0 ; i < fields.length ; i++) {
            var field = fields[i];

            if (!fields) return;

            if (pDraftFlag == "DRAFT") {
                switch (field.id) {
                    case "sentdate":
                        field.textContent = CurrentDate;
                        break;
                }
            }
        }
    } catch (e) {
        alert(e.description);
    }
}
function getGyulJeDate() {
    var GyulJeDate;
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getDate.do",
		success: function(text){
			result = text;
		}
	});
	
    GyulJeDate = result;

    return GyulJeDate;
}
function trim(parm_str) {
    return rtrim(ltrim(parm_str));
}
function ltrim(parm_str) {
    str_temp = parm_str;
    while (str_temp.length != 0) {
        if (str_temp.substring(0, 1) == " ") {
            str_temp = str_temp.substring(1, str_temp.length);
        } else {
            return str_temp;
        }
    }
    return str_temp;
}
function rtrim(parm_str) {
    str_temp = parm_str;
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
function getSusinSNInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "orgCompanyID", orgCompanyID);

    xmlhttp.open("POST", "/ezApprovalG/getSusinSN.do", false);
    xmlhttp.send(xmlpara);

    if (xmlhttp.responseText != "") {
        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        pSusinSN = getNodeText(dataNodes[0]);
    }
}
function setBtnDisableAprLineType() {
    if (pDraftFlag == "SUSIN" || pAprLineType == strAprType7 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
        setMenuBar("btnReject", false);
        setMenuBar("btnReject2", false);
        setMenuBar("btnStay", false);
        setMenuBar("btnModAprLine", false);
        setMenuBar("btnModAprDept", false);
    }
}
function getLastSignSN(pNodes) {
    var i;
    var aprlineSN;
    var lastaprlineSN;
    var junkyulflag = false;

    aprlineSN = pNodes.length;
    lastaprlineSN = 0;
    for (i = aprlineSN - 1; i >= 0; i--) {
        var params = new Array();
        params[0] = "0";
        var dataNodes = GetLastChildNodes(pNodes[i], params);

        var pCurrentAprType = getNodeText(dataNodes[11]);
        
        /* 2021-02-03 홍승비 - 결재선 카운트에 감사 유형 추가 (기안, 검토, 결재, 전결, 대결, 결재안함, 후결, 감사) */
        	if (pCurrentAprType == strAprType18 || pCurrentAprType == strAprType19 || pCurrentAprType == strAprType1 || pCurrentAprType == strAprType4 || pCurrentAprType == strAprType16 || pCurrentAprType == strAprType3 || pCurrentAprType == strAprType40 || pCurrentAprType == strAprType5) {
                if (pCurrentAprType == strAprType4) junkyulflag = true;

                switch (pCurrentAprType) {
                    case strAprType1:
                        lastaprlineSN = lastaprlineSN + 1;
                        break;

                    case strAprType18:
                        lastaprlineSN = lastaprlineSN + 1;
                        break;

                    case strAprType19:
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
                    //후결
                    case strAprType40:
                        lastaprlineSN = lastaprlineSN + 1;
                        break;
                    // 감사
                    case strAprType5:
                        lastaprlineSN = lastaprlineSN + 1;
                        break;
                }
            }
        }
        
    return lastaprlineSN;
}

function getLastTotalSignSN(pNodes) {
    var i;
    var aprlineSN;
    var junkyulflag = false;

    aprlineSN = pNodes.length;
    lastHabYuiSN = 0;
    
    
	var params = new Array();
    params[0] = "0";
    
    //결재선 인덱스가 높은숫자가 sn 1번이라 최종이 0 
    var dataNodes = GetLastChildNodes(pNodes[0], params);

    var pCurrentAprType = getNodeText(dataNodes[11]);
    
    //최종결재가 결재거나 참조일 경우 채번되도록
    if (pCurrentAprType == "001" || pCurrentAprType == "007" ) {
    	lastHabYuiSN = 1;
    }

	 return lastHabYuiSN;
}

function HabyuiResultOpinion() {
    try {
        var parameter = new Array();
        var rtnVal = true;

        parameter[0] = "";
        parameter[1] = "N";
        parameter[2] = KuyjeType;
        parameter[3] = pOrgDocID;
        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
        parameter[99] = ext;
        
        var url = "/ezApprovalG/aprOpinion.do";
        var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
        feature = feature + GetShowModalPosition(530, 520);

        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            var NodeList;
            var objXML = createXmlDom();

            objXML.loadXMLString(ret);
            var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0)
                rtnVal = true;
            else
                rtnVal = false;
        }
        return rtnVal;
    } catch (e) {
        alert(e.description);
    }
}
function upDateAprLine() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pingUserID);

    xmlhttp.open("POST", "aspx/upDateJunKyul.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText
}
var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction, isEditMode) {
    var parameter = pInformationContent;

    var url = "";
    if(isEditMode && isEditMode == "Y"){
        var url = "/ezApprovalG/ezAprOpinion.do?editModeYN=Y";
    }else{
        var url = "/ezApprovalG/ezAprOpinion.do";
    }
    
    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
        DivPopUpShow(330, 205, url);
    } else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);

        if (url != "")
            var rtn = window.showModalDialog(url, parameter, feature);

        if (rtn) {
		  openOpinionUI("Display", CheckOpinionYN_Complete_Complete);
        }
    }
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}
var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}

var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd(pPwd, CompleteFunction) {
    var parameter = pPwd

    ezchkpasswd_cross_dialogArguments[0] = parameter;
    if(CompleteFunction != undefined)
        ezchkpasswd_cross_dialogArguments[1] = CompleteFunction;
    else
        ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

    DivPopUpShow(350, 225, "/ezApprovalG/ezchkPasswd.do");
}

function sendMail() {
    var AddressList = makeAddress();

    if (AddressList) {
        if (AddressList.indexOf("@") > 0) {
            if (AddressList != "" && AddressList != "undefind")
                sendMails(AddressList);
        }
    }
}
function sendMails(pAddList) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", DocID);
    createNodeAndInsertText(xmlpara, objNode, "DocURL", pEndDocHref);
    createNodeAndInsertText(xmlpara, objNode, "DocTitle", pDocTitle);
    createNodeAndInsertText(xmlpara, objNode, "To", pAddList);

    xmlhttp.open("POST", "/Eoffice/OWA/Email/aspx/SendDoc.aspx", true);
    xmlhttp.onreadystatechange = SendDoc_after;
    xmlhttp.send(xmlpara);
}
function SendDoc_after() { }
function makeAddress() {
    var address = message.CKEDITOR.instances.editor1.document.$.body.getAttribute("sendMailInfo", 0);
    return address;
}
function getLastOpinon() {
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

    var objNodes = GetChildNodes(loadXMLString(result).documentElement);
    if (objNodes.length > 0)
        var content = getNodeText(objNodes[0]);

    var fields = message.GetFieldsList();

    var field = message.GetListItem(fields, "memo");
    if (field)
        field.textContent = content;
}
/* 2022-02-17 홍승비 - 일괄기안용 함수 분리 */
function getLastOpinonForDraftAll(currIdx) {
	var result = "";
	var content = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getLastOpinonCotent.do",
		data : {
			docID : parent.pDocIDAry[currIdx]
		},
		success: function(xml){
			result = xml;
		}
	});
	
	var objNodes = GetChildNodes(loadXMLString(result).documentElement);
	if (objNodes.length > 0) {
		content = getNodeText(objNodes[0]);
	}
	var fields = GetFieldsList();
	var field = GetListItem(fields, "memo");
	if (field) {
		field.textContent = content;
	}
}
function setMenuBar(id, flag) {
    var strCmd, display_Value

    if (flag)
        display_Value = "";
    else
        display_Value = "none";

    if (document.getElementById(id) != null)
        document.getElementById(id).style.display = display_Value;
}
function setMenuDisable(id, flag) {
    if (flag)
        eval(id).disabled = true;
    else
        eval(id).disabled = false;
}

var aprcabinetattach_cross_dialogArguments = new Array();
function openAaprDocAttachUI() {
    try {
        var parameter = pDocID;

        aprcabinetattach_cross_dialogArguments[0] = parameter;
        aprcabinetattach_cross_dialogArguments[1] = openAaprDocAttachUI_Complete;
        
        if(approvalFlag == "G") {
        	DivPopUpShow(1050, 560, "/ezApprovalG/aprCabinetAttach.do");
        } else {
        	DivPopUpShow(1050, 560, "/ezApprovalG/aprDocAttach.do?orgCompanyID=" + orgCompanyID+"&pDocID="+pDocID);
        }
    } catch (e) {
        alert(e.description);
    }
}

function openAaprDocAttachUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel") {
        setAttachInfo(pDocID, "APR", lstAttachLink);
    }
}
/**
 * 결재 진행시 발생하는 서명 정보 업데이트
 * */
function SignSave() {
    if (SignContent.length > 0) {
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
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "ORGCOMPANYID", orgCompanyID);
        }
        xmlhttp.open("Post", "/ezApprovalG/setSignInfo.do", false);
        xmlhttp.send(xmlpara);
        
    }
}
function SignCheck() {
    var SignXML = createXmlDom();

	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getSignInfo.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}
	});

	if (result == "" || result == null) {
        return;
    }
    
    result = loadXMLString(result);

    if (agreeReturnType == "2") {
    
	    var chkBansongList = SelectNodes(result, "SIGNINFOS");
	    var agreeBansongType = getNodeText(SelectSingleNode(chkBansongList[0], "CHKBANSONG"));
	
	    if (agreeBansongType == "TRUE") {
	    	var pAlertContent = strLangPJG03;
	    	alert(pAlertContent);
	    	window.close();
	    	return;
	    }  
	    
    }
    
    var NodeList;
    NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");
    if (NodeList.length <= 0) {
        return;
    }
    SignXML = result;

    var rtnVal = putSignXML(SignXML);

}

function putSignXML(SignXML) {
    var retVal = false;
    
    try {
        var NodeList;
        var fields = message.GetFieldsList();

        NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
        if (NodeList.length > 0) {
            for (i = 0; i < NodeList.length; i++) {
                var SignType = getNodeText(SelectSingleNode(NodeList[i], "SIGNTYPE"));
                var SignName = getNodeText(SelectSingleNode(NodeList[i], "SIGNNAME"));
                var SignCont = getNodeText(SelectSingleNode(NodeList[i], "CONTENT"));
                
                var aprMemberName = getNodeText(SelectSingleNode(NodeList[i], "APRMEMBERNAME"));
                
                //2018-07-11 천성준 -전자결재G 중간결재자 부재설정 시, 부재내용 서명란에 표기안되서 주석
//                if (!(SignName.indexOf("habyui") > -1)) {
//                	continue;
//                }
                
                var field = message.GetListItem(fields, SignName);
                var field2 = message.GetListItem(fields, SignName.replace("habyuisign", "habyuija"));
                
                if (field) {
                    retVal = true;
                    if (SignType == "TEXT" || SignType == "HTML") {
                        field.innerHTML = SignCont;
                        //2018-07-11 천성준 - replace가 서명 볼드처리 해제시켜버려서 주석 
//                        if (field2) {
//                        	field2.textContent = SignCont.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
//                        }
                    }
                    else {
                    	var seumyung = message.GetListItem(fields, "seumyungdate" + (i + 1));
                        var img = SignCont.split("::");
                        var signWidth = Number(field.offsetWidth) - 4 - 15;
                        var signHeight = Number(field.offsetHeight) - 4;
                        signWidth = 50;
                        
                        if (seumyung) {
                        	if (img[1] != null) {
                        		if (img[1].indexOf(strLang7) > -1) {
                        			signHeight = 28;
                        		} else {
                        			signHeight = 50;
                        		}
                        	} else {
                        		signHeight = 50;
                        	}
                        } else {
                        	signHeight = 28;
                        }

                        var strimg;
                        if (img.length >= 1) {
                            var filename = img[0].split("/")[img[0].split("/").length - 1];
                            strimg = "<img src='" + encodeURI(img[0]) + "' border=0 embedding='1' ";
                            strimg = strimg + " width=" + signWidth;
                            if (signImageType == "NAME") {
                            	//이효진 signImageType Name일때 반복문으로 앞쪽 이미지 서명까지 전부 새로 입력중이라 userInfo 말고 DB에서 꺼내쓰도록 수정
//                            	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>" + "<br>" + arr_userinfo[2] ;
                            	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>" + "<br>" + aprMemberName;
                            } else {
                                strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>";
                            }
                        }
                        
                        if (seumyung) {
                        	field.innerHTML = strimg;
                        } else {
                        	if (img.length >= 2 && img[1] != "") {
                        		field.innerHTML = img[1] + "<br/>" + strimg;
                        	}
                        	else {
                        		field.innerHTML = strimg;
                        	}
                        }

                    }
                }
            }
        }
    } catch (e) {
        alert("putSignXML : " + e.description);
        return false;
    }
    
    return retVal;
}
function openDocExinfo() {
    var parameter = new Array();
    parameter[0] = tempSecurity;
    parameter[1] = tempUrgent;
    parameter[2] = pSummery;
    parameter[3] = pSpecialRecordCode;
    parameter[4] = pPublicityCode;
    parameter[5] = pLimitRange;
    parameter[6] = pPageNum;
    parameter[7] = tempSecurityDate;
    parameter[8] = pPublicityYN;
    
    var url = "../ezDocInfo/ezDocInfoG_Cross.aspx";
    var feature = "status:no;dialogWidth:420px;dialogHeight:605px;help:no;scroll:no;edge:sunken;";
    feature = feature + GetShowModalPosition(420, 605);
    var RtnVal = window.showModalDialog(url, parameter, feature);

    tempSecurity = RtnVal[0];
    tempUrgent = RtnVal[1];
    pSummery = RtnVal[2];
    pSpecialRecordCode = RtnVal[3];
    pPublicityCode = RtnVal[4];
    pLimitRange = RtnVal[5];
    pPageNum = RtnVal[6];
    tempSecurityDate = RtnVal[7];

    /*2018-04-05 김은석 수정 건설공사 공개여부*/
//  setPublicFlag();
  setPublicFlag2();
}
/*2018-04-05 김은석 수정 건설공사 공개여부*/
//function setPublicFlag() {
//  var fields = message.GetFieldsList();
//  var field = message.GetListItem(fields, "publication");
//  if (!field) return;
//
//  var PublicType = pPublicityCode.substring(0, 1);
//  var PublicLevel = pPublicityCode.substring(1, 9);
//  var PublicText = "";
//
//  if (pLimitRange != "")
//      PublicText = " (" + pLimitRange + ")";
//
//  if (PublicType == "1")
//      PublicText = strLang82;
//  else if (PublicType == "2")
//      PublicText = strLang83 + getPublicLevel(PublicLevel);
//  else if (PublicType == "3")
//      PublicText = strLang84 + getPublicLevel(PublicLevel);
//  else
//      PublicText = " ";
//
//  field.innerHTML = PublicText;
//}
function setPublicFlag2() {
	var fields = message.GetFieldsList();
	var field = message.GetListItem(fields, "publication");
	if (!field) return;
	
	var PublicType = pPublicityYN.substring(0, 1);
	var PublicText = "";
	
	
	if (PublicType == "Y" || PublicType == "B")
		PublicText = strLang82;
	else if (PublicType == "N")
		PublicText = strLang84
	else
		PublicText = " ";
	
	field.innerHTML = PublicText;
}
function setPublicFlag() {
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, "publication");
    if (!field) return;

    var PublicType = pPublicityCode.substring(0, 1);
    var PublicLevel = pPublicityCode.substring(1, 9);
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

    field.innerHTML = PublicText;
}
function getPublicLevel(PublicLevel) {
    var strRtn = "";
    var firstFlag = true;
    for (i = 0; i < 8; i++) {
        if (PublicLevel.substring(i, i + 1) == "Y") {
            if (firstFlag) {
                strRtn = "(" + (i + 1);
                firstFlag = false;
            }
            else {
                strRtn = strRtn + "," + (i + 1);
            }
        }
    }
    if (!firstFlag)
        strRtn = strRtn + ")";
    return strRtn;
}
function getSignDate() {
    var GyulJeDate;
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getSignDate.do",
		data : {
			getDate : ""
		},
		success: function(text){
			result = text;
		}
	});

    GyulJeDate = result;
    
    return GyulJeDate;
}
var ezaprhistory_cross_dialogArguments = new Array();
function getHistory() {
    var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + ext;

    ezaprhistory_cross_dialogArguments[0] = "";
    ezaprhistory_cross_dialogArguments[1] = getHistory_Complete;

    DivPopUpShow(740, 450, URL);
}

function getHistory_Complete() {
    DivPopUpHidden();
}

/* 2020-02-24 홍승비 - 편집 전후 문서를 판단하기 위한 플래그 isBeforeDoc, 편집전문서 파일경로 beforeDocURL 파라미터 추가 */
function UpdateDocHistory(pHtml, isBeforeDoc, beforeDocURL) {

    var xmlhttp2 = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pHtml", ConvertHTMLtoMHT(pHtml));
    createNodeAndInsertText(xmlpara, objNode, "mode", "mht");
    createNodeAndInsertText(xmlpara, objNode, "ISBEFOREDOC", isBeforeDoc);
    
    xmlhttp2.open("POST", "/ezApprovalG/uploadDocHistory.do", false);
    xmlhttp2.send(xmlpara);
    
    var URL = xmlhttp2.responseText;
    var returnURL = "";
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
/**
 * 결재선의 이력관리
 * */
function UpdateLineHistory() {
	var result = "";
    
	/* 2020-05-22 홍승비 - 사용자 부서에 특수문자 허용 + arr_userinfo[] 배열의 값은 c:out 태그로 저장하므로, DB 저장 시 역으로 특수문자 인코딩 진행 */
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateLineHistory.do",
		data : {
			docID : pDocID,
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
		success: function(xml){
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

function setRecevInfo(ret) {
    var i;
    var strMailAdd = "";
    var precipent = "";
    var precipents = "";
    var mailflag = true;
    var recipflag = true;
    var mailList = "";
    var mailcnt = 0;
    var fields = message.GetFieldsList();

    if (ret == "") {
        var field = message.GetListItem(fields, "hrecipients");
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipient");
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }

        var field = message.GetListItem(fields, "recipients");
        if (field) {
            field.textContent = " ";
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
        return;
    }

    var xmldom = createXmlDom();
    xmldom.async = false;
    xmldom = loadXMLString(ret);

    var rows = GetChildNodes(xmldom.documentElement);
    if (rows.length == 0) return;

    var field = message.GetListItem(fields, "hrecipients");
    if (field) {
        field.textContent = " ";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    var field = message.GetListItem(fields, "recipient");
    if (field) {
        field.textContent = " ";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    var field = message.GetListItem(fields, "recipients");
    if (field) {
        field.textContent = " ";
        if (new RegExp(/Firefox/).test(navigator.userAgent))
            field.innerHTML = "<br type='_moz'>";
    }

    for (i = rows.length - 1; i >= 0; i--) {
        var params = new Array();
        params[0] = "0";

        var dataNodes = GetChildNodes(rows[i], params);

        if (getNodeText(GetChildNodes(rows[i])[3]) == "Y") {
            if (mailflag) {
                strMailAdd = "\"" + getNodeText(dataNodes[0]) + "\"" + " " + "<" + getNodeText(dataNodes[6]) + ">";
                mailflag = false;
                mailList = getNodeText(dataNodes[0]);
            }
            else {
                strMailAdd = strMailAdd + ", " + "\"" + getNodeText(dataNodes[0]) + "\"" + " " + "<" + getNodeText(dataNodes[6]) + ">";
                mailList = mailList + "," + getNodeText(dataNodes[0]);
            }
            mailcnt = mailcnt + 1;
        }

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
            }
            else {
                if (isExtDoc == "Y") {
                    if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
                        precipent = approvalFlag == "G" ? strLang92 : strLangS68;
                        precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                    } else {
                        precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                        precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                    }
                    recipflag = false;
                }
                else {
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
        	if (approvalFlag == "G") {
        		precipent = strLang92;
        	} else {
        		precipent = strLangS68;
        	}

            if (getNodeText(dataNodes[3]) == "Y")
                precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
            else {
                if (isExtDoc == "Y")
                    precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
                else
                    precipents = precipents + ", " + getNodeText(dataNodes[0]);
            }
        }
    }
    message.DocumentBodySetAttribute("sendMailInfo", strMailAdd);
    
    var field = message.GetListItem(fields, "recipient");
    if (field) {
        if (precipent == strLang92) {
            field.textContent = precipent
            var field = message.GetListItem(fields, "recipients");
            if (field) {
                field.textContent = precipents
                var field = message.GetListItem(fields, "hrecipients");
                if (field)
                    field.textContent = strLang94;
            }
        } else if (precipent == strLangS68) {
        	 field.textContent = precipent
             var field = message.GetListItem(fields, "recipients");
             if (field) {
                 field.textContent = precipents
                 var field = message.GetListItem(fields, "hrecipients");
                 if (field) {
                     field.textContent = strLang94;
                 }
             }
        } else {
            field.textContent = precipent;

            if (precipents == "") {
                var field = message.GetListItem(fields, "hrecipients");
                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent))
                        field.innerHTML = "<br type='_moz'>";
                }
                var field = message.GetListItem(fields, "recipients");
                if (field) {
                    field.textContent = " ";
                    if (new RegExp(/Firefox/).test(navigator.userAgent)) {
                        field.innerHTML = "<br type='_moz'>";
                    }
                }
            }
        }
    }
}
function openReceivUI() {
    var parameter = new Array();

    isExtDoc = message.CKEDITOR.instances.editor1.document.$.body.getAttribute("EXTDOC", 0);

    if (isExtDoc != "Y") isExtDoc = "N"

    parameter[0] = pFormID;
    parameter[1] = pDocID;
    parameter[2] = "SEND"
    parameter[3] = isExtDoc;
    parameter[4] = pDocType;

    var url = "../ezAPRDEPT/AprDept1_Cross.aspx";
    var feature = "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(855, 530);

    var ret = window.showModalDialog(url, parameter, feature);

    return ret
}
function SendAckForExch(pType, pMode) {
	var result = "";
	var pBody = "";
	var fields = message.GetFieldsList();
	var field = message.GetListItem(fields, "body")
	if (field) {
		pBody = field.textContent;
	}
	else {
		pBody = "";
	}
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/sendAckforExch.do",
		data : {
			docID : pDocID,
			type  : pType,
			mode  : pMode,
			body  : pBody
		},
		success: function(xml){
			result = loadXMLString(xml);
		}
	});

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
function getNextDocInfo() {
    try {
    	var result = "";
    	var isIEFlag = "Y";
    	
    	if (!isIE()) {
    		isIEFlag = "N";
    	}
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getNextDocInfo.do",
    		data : {
    			docID : pDocID,
    			userID  : pUserID,
    			userDeptID  : arr_userinfo[4],
    			orgCompanyID : orgCompanyID,
    			isIEFlag  : isIEFlag
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});
    	
        NextDocID = "";
        NextDocUserID = "";
        NextDocUserName = "";
        NextDocUserName2 = "";
        NextDocDeptID = "";
        if (result != "") {
            var objNodes = loadXMLString(result);

            NextDocID =  getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "DOCID"));
            NextDocUserID = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "USERID"));
            NextDocUserName = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "USERNAME"));
            NextDocDeptID = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "USERDEPTID"));
            NextDocType = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "DOCTYPE"));
            NextDocState = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "DOCSTATE"));
            docState = NextDocState;
            NextDocWriterID = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "WRITERID"));
            NextDocAprType = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "APRTYPE"));
            NextDocHref = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "HREF"));
            NextDocExtended = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "EXTENDEDNAME"));
            pCompanyID = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "COMPANYID"));
            docNumZeroCnt = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "DOCNUMZEROCNT"));
            orgCompanyID = pCompanyID;
            wAprMemberSN = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "APRMEMBERSN"));
            nonElecRec = getNodeText(SelectSingleNode(GetChildNodesByNodeName(objNodes, "NEXTDOCINFO")[0], "NONELECREC"));
        }
    } catch (e) { }
}
function getNextDocOne(tempDocID) {
    try {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", tempDocID);

        xmlhttp.open("Post", "aspx/GetNextDocOne.aspx", false);
        xmlhttp.send(xmlpara);

        NextDocID = "";
        NextDocUserID = "";
        NextDocUserName = "";
        NextDocUserName2 = "";
        NextDocDeptID = "";
        if (xmlhttp.responseText != "") {
            var objNodes = GetChildNodes(xmlhttp.responseXML);
            if (objNodes.length > 0) {
                NextDocID = getNodeText(objNodes[0]);
                NextDocUserID = getNodeText(objNodes[1]);
                NextDocUserName = getNodeText(objNodes[2]);
                NextDocDeptID = getNodeText(objNodes[3]);
                NextDocType = getNodeText(objNodes[4]);
                NextDocState = getNodeText(objNodes[5]);
                NextDocWriterID = getNodeText(objNodes[6]);
                NextDocAprType = getNodeText(objNodes[7]);
                NextDocHref = getNodeText(objNodes[8]);
                NextDocExtended = getNodeText(objNodes[9]);
            }
        }
    } catch (e) { }
}
function DeleteDeptInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp.open("Post", "../ezAPRDEPT/aspx/AprDeptDelete.aspx", false);
    xmlhttp.send(xmlpara);
}


function EmbedContentIntoXML(bodyhtml) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = bodyhtml;

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0 && !imgColl.item(i).src.toLowerCase().indexOf(".tmp")) {
            var OrgSrc = imgColl.item(i).src;
            var ImgHeight = "0";
            var ImgWidth = "0";
            if (imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/) == null) {
                if (imgColl.item(i).style.width != "")
                    ImgWidth = imgColl.item(i).style.width.replace("px", "");
                if (imgColl.item(i).style.height != "")
                    ImgHeight = imgColl.item(i).style.height.replace("px", "");
            }
            else {
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgWidth = result[1];
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/height="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgHeight = result[1];
            }
            ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
        }
    }
    return bodyhtml;
}

function ConvertSaveImageFile(pUrl, pImgWidth, pImgHeight) {
	$.ajax({
		url : "/ezCommon/convertSaveImage.do",
		type : "POST",
		async : false,
		data : {
			"url" : encodeURI(pUrl),
			"height" : pImgHeight,
			"width" : pImgWidth,
			"type" : 2
		}
	});
}

function setDocNumFormat(pPrefix) {
    var Arr_Header = new Array();
    var Header, Tail;
    var i;
    var d = new Date();

    var numHeader = "";

    var fields = message.GetFieldsList();

    var field = message.GetListItem(fields, pPrefix + "docnumber");
    
    if (!field) {
    	return
    }
    
    var fieldValue = message.DocumentBodyGetAttribute("orgdocnum", 0);

    Arr_Header = fieldValue.split("-");
    org_Header = field.split("-");
    
    Arr_Header.forEach(function(item, index) {
    	if (!item.indexOf('@')) {
    		//@ exist
    		Header = item.replace("@", "");

            switch (Header) {
                case "DP":
                    numHeader += DeptSymbol;
                    break;

                case "dp":
                    numHeader += DeptSymbol;
                    break;

                case "YY":
                    var tempYear = d.getFullYear();
                    numHeader += (org_Header[index] == tempYear ? tempYear : org_Header[index]);
                    break;
                    
                case "yy":
                    var tempYear = d.getFullYear().substr(2);
                    numHeader += (org_Header[index] == tempYear ? tempYear : org_Header[index]);
                    break;

                case "MM":
                    var mmonth = d.getMonth() + 1;
                    if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
                    numHeader += mmonth;
                    break;

                case "mm":
                    numHeader += (d.getMonth() + 1);
                    break;

                case "NN":
                    break;

                case "nn":
                    break;

                case "cs":
                    numHeader += strLang107;
                    break;
                    
                case "FT":
                	numHeader += "FT";
                	break;
                	
                case "MV":
                	numHeader += "MV";
                	break;
                	
                case "YM":
                    var tempYear = d.getFullYear().toString().substr(2);
                    numHeader += (org_Header[index] == tempYear ? tempYear : org_Header[index]);
                    
                	var mmonth = d.getMonth() + 1;
                    if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
                    numHeader += mmonth;
                    
                    var mdate = d.getDate();
                    if (parseInt(mdate) < 10) mdate = "0" + mdate;
                    numHeader += mdate;
                    
                    break;
                    
                /*단암 양식*/
                case "D1":
                	numHeader += "계약";
            		break;
                case "D2":
                	numHeader += "교육기안";
            		break;
                case "D3":
                	numHeader += "교육";
            		break;
                case "D4":
                	numHeader += "구매";
            		break;
                case "D5":
                	numHeader += "제";
            		break;
                case "D6":
                	numHeader += "기구";
            		break;
                case "D7":
                	numHeader += "기안";
            		break;
                case "D8":
                	numHeader += "제 문서 신청";
            		break;
                case "D9":
                	numHeader += "보고";
            		break;
                case "DA":
                	numHeader += "제조-보고";
            		break;
                case "DB":
                	numHeader += "연장근무보고서";
            		break;
                case "DC":
                	numHeader += "출장";
            		break;
                case "DD":
                	numHeader += "해외출장";
            		break;
                case "DE":
                	numHeader += "품질검사";
            		break;
                case "DF":
                	numHeader += "휴가";
                	break;

                default:
                    numHeader += fieldValue;
                    break;
            }
    	} else {
    		numHeader += item;
    	}
    	
    	if (!(index == Arr_Header.length - 1)) {
    		numHeader += "-";
    	}
    });
    
    field.textContent = numHeader;
    if (numHeader.indexOf(strLang107) > 0)
        message.DocumentBodySetAttribute("docnum", numHeader);
}

/* 2020-03-06 홍승비 - 부서에 특수문자를 허용하므로, DB 저장 시 역인코딩을 위한 함수 추가 */
function ConvMakeXMLString(str) {
    str = ReplaceText(str, "&lt;", "<");
    str = ReplaceText(str, "&gt;", ">");
    str = ReplaceText(str, "&#039;", "'");
    str = ReplaceText(str, "&#034;", "\"");
	str = ReplaceText(str, "&#92;", "\\");
	str = ReplaceText(str, "&amp;", "&");
    return str;
}

//2020-05-08 : 결재정보/문서정보 저장
function setApprDocInfo(){
    var objNodes = GetChildNodes(GetChildNodes(document.getElementById('DOCINFO').dataSource.childNodes[0])[0]);

    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");  
    createNodeAndInsertText(xmlpara, objNode, "DOCID", getNodeText(objNodes[0])); 
    createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic); 
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

function getPersonalAgreeReturnType() {
	var result = "";
	
   $.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getPersonalAgreeReturnType.do",
		data : {},
		success: function(resultVal){
			result = resultVal;
		}        			
	});
   
   return result;
}

// 문서번호의 @DP, @dp에서 필요한 부서명 리턴
function getDeptSymbol(DeptID, DeptName) {
	var result = "";
	var dataNodes;
	var RtnVal;
	
	if(approvalFlag == "S") {
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/getChaebunDept.do",
			data : {
				deptID : DeptID,
				orgCompanyID : orgCompanyID
			},
			success: function(xml){
				result = xml;
				if(result != null) {
					dataNodes = GetChildNodes(loadXMLString(result).documentElement);
					DeptName = getNodeText(dataNodes[0]);
					RtnVal = getNodeText(dataNodes[1]);
				}
			}        			
		});
	} else {
        
        if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
            DeptID = upperDeptCode;
            
            /* 2024-11-07 홍승비 - 전자결재 > 상위부서문서함 관련 변수 체크 추가 */
            if (typeof upperDeptName !== "undefined" && upperDeptName !== "") {
            	DeptName = upperDeptName;
            }
        }
        
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezOrgan/getADInfos.do",
			data : {
				cn : DeptID,
				prop : "extensionAttribute6",
				cate  : "group"
			},
			success: function(xml){
				result = xml;
			}        			
		});
	
		dataNodes = GetChildNodes(loadXMLString(result).documentElement);
		RtnVal = getNodeText(dataNodes[0]);
	}
	
    if (RtnVal == "") {
        return DeptName;
    }
    else {
        return RtnVal;
    }
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

    signDel(returnUserSN); // 사인제거
    SaveFile(); // 문서 저장
    process_AfterApprove("2"); // 알림창
}

/* 2024-06-24 양지혜 - 지정반송 > 결재 사인 제거 */
function signDel(returnUserSN) {
    var fields = message.GetFieldsList();
    for (i = returnUserSN; i < 10; i++) {
        var field = message.GetListItem(fields, "sign" + i);
        if (field) {
            setNodeText(field, " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
        field = message.GetListItem(fields, "seumyungdate" + i);
        if (field) {
            setNodeText(field, " ");
            if (new RegExp(/Firefox/).test(navigator.userAgent))
                field.innerHTML = "<br type='_moz'>";
        }
    }
}

// 2025-02-18 박기범 - 프론트에서 문서 편집시, 문서를 오픈한 이후로 다른 문서/결재진행 변화가 있었는지 체크하기 위한 코드
function getSnapshotCode() {
    var snapshotCode = "";
    $.ajax({
        method : "GET",
        url : "/ezApprovalG/getDocumentSnapshotCode.do",
        async: false,
        data : {
            docID: pDocID
        },
        success : function(code){
            snapshotCode = code;
        }
    });
    return snapshotCode;
}
