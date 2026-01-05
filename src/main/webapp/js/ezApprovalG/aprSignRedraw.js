/* 2023-11-30 홍승비 - 결재 서명 데이터를 DB(TBL_SIGNINFO)에서 가져와, 문서 상에 다시 그려주는(재맵핑) 함수 구현 */

/* 1. 서명 데이터 재맵핑 기능을 구현한 이유 : 
						서로 다른 결재창에서 동시에 결재가 진행되는 경우(개인병렬합의 등) 발생 가능한 문서 상의 서명 누락에 대응하기 위해 구현했습니다.
						문서 상의 서명 누락을 근본적으로 방지하기 위해서는 모든 결재 방식을 페이지단이 아닌 서버단으로 이동해야 하나, 해당 개선 이전에
						문서를 화면에 표출할때만 서명이 누락되지 않도록 수정한 것입니다. (오류 발생중인 문서를 다운로드 시 서명이 누락된 상태로 저장됩니다.)
						* DB(TBL_SIGNINFO)에 정상적인 결재서명 데이터가 존재하는 경우 재맵핑을 진행합니다.
*/
/* 2. 서명칸에 서명이 나타나는 형식 (최대 3행에 걸쳐 표출) : 
						대결/전결(해당하는 경우)MM.dd(서명칸에 서명일자를 함께 표출하는 경우, 즉 서명일자칸이 없는 양식의 최종결재자인 경우)
						代문자(대리결재의 경우 표기하며, '代' 문자는 문자서명의 좌측 / 이미지 서명의 위에 붙임)
						서명(이름 또는 이미지)
*/
/* 3. 서명 데이터 재맵핑 기능의 적용 범위 : 
 						2023-11-30 기준으로 웹 그룹웨어의 전자결재 문서기안, 문서보기, 문서결재 페이지에만 기능이 적용되도록 구현하였습니다.
 						(모바일 그룹웨어의 전자결재 문서보기, 문서결재 페이지에는 기능이 적용되지 않습니다.)
*/

///////////////////////////////////////////////////// 공통 함수 /////////////////////////////////////////////////////
/* TBL_SIGNINFO 테이블의 결재서명 데이터를 XML(문자열) 형식으로 가져오는 함수 */
function getAllAprSignDataXML(pDocID, pOrgCompanyID) {
	var resultXML = "";
	
	// 문서 로딩에 맞춰서 순차적으로 동작(비동기 아님)
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getAllAprSignDataXML.do",
		data : {
			docID : pDocID,
			orgCompanyID : pOrgCompanyID
		},
		success : function(xml) {
			// 서버단에서는 아래의 정규식과 필드 ID가 매치되는 경우의 값만 가져온다.
			// "[0-9]*sign[0-9]*|[0-9]*approdept[0-9]*|[0-9]*jikwe[0-9]*|[0-9]*seumyung[0-9]*|[0-9]*seumyungdate[0-9]*|";
			// "[0-9]*habyuisign[0-9]*|[0-9]*habyui[0-9]*|[0-9]*habyuipositon[0-9]*|[0-9]*habyuija[0-9]*|[0-9]*habyuidate[0-9]*";
			resultXML = xml;
		},
		error : function(e) {
			console.log(e);
		}
	});
	
	return resultXML;
}

/* 2024-10-04 홍승비 - 전자결재 버전 플래그(ApprovalFlag) 테넌트 컨피그값을 가져오는 AJAX 함수 추가 */
function getApprovalFlag() {
	var resultFlag = "";
	
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getApprovalFlag.do",
		success : function(result) {
			resultFlag = result;
		},
		error : function(e) {
			console.log(e);
		}
	});
	
	return resultFlag;
}


///////////////////////////////////////////////////// MHT 함수 /////////////////////////////////////////////////////
/* MHT - 결재서명 재맵핑 전체 제어 함수 (각 함수들을 호출하는 최상위 함수) */
function startRemapAllAprSign_MHT(pDocID, pOrgCompanyID) {
	try {
		// 1) 결재서명 데이터 XML로 리턴
		var signDataXML = getAllAprSignDataXML(pDocID, pOrgCompanyID);
		
		// 2) 가져온 XML 데이터로 서명 필드 재맵핑
		redrawAllAprSign_MHT(signDataXML);
	} catch (e) {
		console.log(e);	
	}
}

/* MHT - 결재서명 데이터를 전달받아 결재문서의 서명 데이터를 다시 그리는 함수 */
function redrawAllAprSign_MHT(pSignDataXML) {
	var signDataDom = SelectNodes(loadXMLString(pSignDataXML), "SIGNDATA");
	var signDataLength = signDataDom.length;
	
	if (signDataLength > 0) {
		 for (i = 0; i < signDataLength; i++) {
             var signType = getNodeText(SelectSingleNode(signDataDom[i], "SIGNTYPE"));
             var signName = getNodeText(SelectSingleNode(signDataDom[i], "SIGNNAME"));
             var signCont = getNodeText(SelectSingleNode(signDataDom[i], "CONTENT"));
             
             // signName으로 필드 ID를 찾아, DB 상에 서명 데이터가 존재하는 경우에만 재맵핑 진행
             var field = $("#" + signName);
             
             if (field.length > 0 && signCont.trim() != "") {
            	 // 각각의 타입에 따라 다르게 진행 (TEXT, HTML, IMAGE)
            	 if (signType == "TEXT") {
        			 field.text(signCont);
            	 }
            	 else if (signType == "HTML") {
        			 field.html(signCont);
            	 }
            	 else if (signType == "IMAGE") {
            		 var strimg = "";
        			 var signWidth = 50;
        			 var signHeight = 50;
        			 
            		 // 이미지 서명 파일경로 (/fileroot/...)
            		 var signContSrc = typeof(signCont.split("::")[0]) != "undefined" ? signCont.split("::")[0] : "";
            		 
            		 // 이미지 서명 추가정보 (대결, 전결, 代, 서명일자 등)
            		 var signContAddStr = typeof(signCont.split("::")[1]) != "undefined" ? signCont.split("::")[1] : "";
            		 
            		 // 이미지 서명의 하단에 결재자명을 함께 표출하는 경우에만 존재 (테넌트 컨피그 signImageType 참고)
            		 var signContAddName = typeof(signCont.split("::")[2]) != "undefined" ? signCont.split("::")[2] : "";
            		 
                     strimg = "<img src='" + encodeURI(signContSrc) + "' border='0' embedding='1' ";
        			 
        			 // 대결, 전결, 대리결재('代' 문자), 서명일자(서명일자칸 없는 양식의 최종결재 시) 등의 추가 정보가 있는 경우
    				 if (signContAddStr != "") {
    					 signHeight = 28;
    					 strimg = signContAddStr + strimg; // 이미지 서명 위에 추가 정보 붙임
    				 }
    				 
    				 strimg = strimg + "width='" + signWidth + "' height='" + signHeight + "' spath='" + encodeURI(signContSrc) + "'>";
    				 
    				 // 이미지 서명의 하단에 결재자명을 함께 표출하는 경우, 이미지 서명의 높이는 조절하지 않음 (기존 스펙)
    				 if (signContAddName != "") {
    					 strimg = strimg + "<br>" + signContAddName;
    				 }
    				 
    				 field.html(strimg);
            	 }
             }
		 }
	}
}


///////////////////////////////////////////////////// HWP(WHWP) 함수 /////////////////////////////////////////////////////
// 사내 내부망 개발환경 기준, 전체 서명 맵핑 시 속도 이슈는 없는 것으로 확인
/* WHWP - 결재서명 재맵핑 전체 제어 함수 (각 함수들을 호출하는 최상위 함수) */
function startRemapAllAprSign_WHWP(pDocID, pOrgCompanyID) {
	try {
		/* 2024-09-30 홍승비 - 웹한글 양식 사용 시, 결재서명 재맵핑 함수 동작은 G버전에서만 동작하도록 임시 수정 (2024-09-30 기준으로 일반버전 웹한글 기능에는 대응하지 않음) */
		// 차후 일반버전 웹한글 기능에도 대응되도록 수정 가능 (수정 후 아래 pApprovalFlag == "G" 체크 분기와 pApprovalFlag 파라미터 관련 호출을 제거할 것)
		var pApprovalFlag = getApprovalFlag();
		
	    if (pApprovalFlag != "G") {
	    	return;
	    }
		
		// 1) 결재서명 데이터 XML로 리턴
		var signDataXML = getAllAprSignDataXML(pDocID, pOrgCompanyID);
		
		// 2) 가져온 XML 데이터로 서명 필드 재맵핑
		redrawAllAprSign_WHWP(signDataXML);
	} catch (e) {
		console.log(e);	
	}
}

/* WHWP - 결재서명 데이터를 전달받아 결재문서의 서명 데이터를 다시 그리는 함수 */
function redrawAllAprSign_WHWP(pSignDataXML) {
	var portNum = document.location.port == "" ? "" : ":" + document.location.port;
	var hostURL = document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=";
	var signDataDom = SelectNodes(loadXMLString(pSignDataXML), "SIGNDATA");
	var signDataLength = signDataDom.length;
	var allTypeB = typeof parent.draftAllTypeB != "undefined" && typeof parent.pDocIDAry != "undefined" && typeof parent.anCnt == "number" && parent.draftAllTypeB == "Y" && parent.pDocIDAry.length > 2 && parent.anCnt > 1;
	
	if (signDataLength > 0) {
		 for (i = 0; i < signDataLength; i++) {
             var signType = getNodeText(SelectSingleNode(signDataDom[i], "SIGNTYPE"));
             var signName = getNodeText(SelectSingleNode(signDataDom[i], "SIGNNAME"));
             var signCont = getNodeText(SelectSingleNode(signDataDom[i], "CONTENT")).replace(/(\r\n|\r|\n)/g, '\15'); // 웹한글용 개행문자 \15
             
             // signName으로 필드 ID를 찾아, DB 상에 서명 데이터가 존재하는 경우에만 재맵핑 진행
             var fieldExist = FieldExist(signName);
             
             if (fieldExist == true && signCont.trim() != "") {
            	 // 각각의 타입에 따라 다르게 진행 (TEXT, HTML, IMAGE)
            	 // 웹한글 문서의 경우, 서명 타입 중 HTML은 사용하지 않으며 TEXT와 동일하게 취급
            	 if (signType == "TEXT" || signType == "HTML") {
        			 PutFieldText(signName, signCont);	
            	 }
            	 else if (signType == "IMAGE") {
            		 // 웹한글 문서의 경우, 이미지 서명의 하단에 결재자명을 함께 표출하는 컨피그(signImageType)를 사용하지 않으며
            		 // 이미지 서명의 가로 세로 사이즈가 InsertPicture() 함수 내부에서 고정됨
            		 
            		 // 이미지 서명 파일경로 (/fileroot/...)
            		 var signContSrc = typeof(signCont.split("::")[0]) != "undefined" ? signCont.split("::")[0] : "";
            		 
            		 // 이미지 서명 추가정보 (대결, 전결, 代, 서명일자 등)
            		 var signContAddStr = typeof(signCont.split("::")[1]) != "undefined" ? signCont.split("::")[1] : "";
            		 
        			 // 기존 서명칸 내부의 텍스트, 이미지 등 초기화
            		 PutFieldText(signName, "");
            		 
        			 // 대결, 전결, 대리결재('代' 문자), 서명일자(서명일자칸 없는 양식의 최종결재 시) 등의 추가 정보가 있는 경우
    				 if (signContAddStr != "") {
    					 PrependFieldText(signName, signContAddStr);
    				 }
                     
//    				 InsertPicture(signName, hostURL + escape(signContSrc), null);
                     if(allTypeB){
                         for(var j = 0; j < parent.anCnt; j++){
                             InsertPicture(signName + "{{" + j + "}}", hostURL + escape(signContSrc), null);
                         }
                     }else{
                         InsertPicture(signName, hostURL + escape(signContSrc), null);    
                     }
            	 }
             }
		 }
		 
		 // 서명 데이터 재맵핑 완료 후 문서의 최상단으로 이동 (캐럿 및 화면 이동)
		 HwpCtrl.MovePos(2); // 캐럿의 위치를 문서의 시작(moveTopOfFile)으로 이동
         ScrollPosInfo(0, 0); // 스크롤의 위치를 최상단으로 이동
	}
}
