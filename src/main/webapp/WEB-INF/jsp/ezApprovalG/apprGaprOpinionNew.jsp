<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t55'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Opinion_New_Cross.js')}"></script><!-- Opinion_New_Cross.js로 수정 -->
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draft_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script id="clientEventHandlersJS" type="text/javascript">
		var OrderCell = ""; //ListView에서 사용하는 정렬 함수(필요없지만 없으면 ListView에서 에러발생)
		var ModifiedFlag = false; //작성,수정,삭제 동작을 했는지 유/무
		var isNewBBHOpinionFlag = false; // 신규 반송/보류/회송의견(002/003/004) 존재여부 플래그
		
		var pMode; //APR, END
		var pOpinionType; //001,002,003,004,008
		var pDocID, pDisplay, pDraftFlag, pDocState, pOrgCompanyID, pExt;
		
		var pTempRowID = "";
		
		var pUserID = "<c:out value='${userInfo.id}'/>";
		var pUserTitle = "<c:out value='${userInfo.title1}'/>";
		var pUserTitle2 = "<c:out value='${userInfo.title2}'/>";
		var pUserDeptID = "<c:out value='${userInfo.deptID}'/>";
		var pUserDeptName = "<c:out value='${userInfo.deptName1}'/>";
		var pUserDeptName2 = "<c:out value='${userInfo.deptName2}'/>";
		var pUserDisplayName = "<c:out value='${userInfo.displayName1}'/>";
		var pUserDisplayName2 = "<c:out value='${userInfo.displayName2}'/>";
		var pUserCompanyID = "<c:out value='${userInfo.companyID}'/>";
		
		var RetValue, ReturnFunction;
		
		window.onload = function () {
			if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
			    KeEventControl(document.getElementById("txt_OpinionContent"));
			}
			
			try {
			    RetValue = parent.apropinion_cross_dialogArguments[0];
			    ReturnFunction = parent.apropinion_cross_dialogArguments[1];
			    
			    if (typeof(RetValue) == "undefined") {
			    	RetValue = opener.apropinion_cross_dialogArguments[0];
                    ReturnFunction = opener.apropinion_cross_dialogArguments[1];
			    }
			} catch (e) {
			    try {
			        RetValue = opener.apropinion_cross_dialogArguments[0];
			        ReturnFunction = opener.apropinion_cross_dialogArguments[1];
			    } catch (e) {
			        RetValue = window.dialogArguments;
			    }
			}
			
			pDocID = RetValue[0];
			pDisplay = RetValue[1]; 	//공백, BanSong, BoRyu, HeSong, Show
			pDraftFlag = RetValue[2]; 	//DRAFT, REDRAFT, SUSIN
			pDocState = RetValue[3];  	//회람공람때 사용해야할듯
			pOrgCompanyID = RetValue[4];
			pExt = RetValue[99];		//mht, hwp

			validatePara();
			
			pMode = getDocMode(); //APR, END
			pOpinionType = getOpinionType(pDisplay); //001,002,003,004,008
			
			initOpinionInfo();
			autoOpinionPopUp(); // 자동으로 의견 작성창 오픈
		};
		
		//파라미터 유효성 검사 및 초기값 세팅
		function validatePara() {
			if (typeof(pDocID) == "undefined")
				pDocID = "";
			if (typeof(pDisplay) == "undefined")
				pDisplay = "";
			if (typeof(pDraftFlag) == "undefined")
				pDraftFlag = "";
			if (typeof(pDocState) == "undefined")
				pDocState = "";
			if (typeof(pOrgCompanyID) == "undefined")
				pOrgCompanyID = pUserCompanyID;
			if (typeof(pExt) == "undefined")
				pExt = "mht";
		}
		
		//[작성], [수정], [삭제] 버튼 상황별 표출
		function displayButtons() {
			if (pMode == "END" || pDisplay == "Show" || pDocState == "017"){return;}
			
			var DisplayMode = pDisplay.toUpperCase();
			
           	var AddButton = document.getElementById("bbtn_OpinionAdd").style;
           	var ModButton = document.getElementById("bbtn_OpinionMod").style;
           	var DelButton = document.getElementById("bbtn_OpinionDel").style;
           	
			var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");
           	
            var pSelectedRow = OpinionList.GetSelectedRows();
            if (pSelectedRow.length > 0) {
            	//[수정],[삭제] 버튼
	            if (GetAttribute(pSelectedRow[0], "DATA2") == pUserID) {
	            	ModButton.display = "";
	            	DelButton.display = "";
	        	} else {
	        		ModButton.display = "none";
	        		if (pDraftFlag == "REDRAFT") {
	        			DelButton.display = "";
	        		} else {
	        			DelButton.display = "none";
	        		}
	        	}
            } else {
            	ModButton.display = "none";
            	DelButton.display = "none";
            }
            /* 2020-04-02 홍승비 - 동일한 사용자가 모든 의견을 중복하여 작성 가능하도록 수정 */
            //[작성]버튼
/*             if (checkMyOpinionExist(pOpinionType)) {
        		AddButton.display = "none";
        	} else {
        		AddButton.display = "";
        	} */
        	// 일반의견 작성 또는 신규 작성한 반송, 보류, 회송의견이 존재하지 않는 경우에만 작성버튼 활성화
        	if (isNewBBHOpinionFlag == false) {
            	AddButton.display = "";
        	} else {
        		AddButton.display = "none";
        	}
		}
		
		//자신의 의견이 리스트에 존재하는지 유/무
		function checkMyOpinionExist(pType) {
			var rtnVal = false;
			var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");
            
            var pTotalRows = OpinionList.GetDataRows();
            var pTotalRen = pTotalRows.length;
            
            if (pTotalRen > 0 && pTotalRows[0].id.indexOf("noItems") == -1) {
	            for (var i = 0; i < pTotalRen; i++) {
	            	if (GetAttribute(pTotalRows[i], "DATA2") == pUserID) {
	            		if (GetAttribute(pTotalRows[i], "DATA6") == pType) {
	            			pTempRowID = pTotalRows[i].id; // 의견 작성창 자동팝업에 쓰임
		            		rtnVal = true;
		            		break;
	            		}
	            	}
	            }
            }
			return rtnVal;
		}
		
		//Row 클릭
		function OpinionOnSelChange_onclick() {
			var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");
            
            var pSelectedRow = OpinionList.GetSelectedRows();
            if (pSelectedRow.length > 0) {
            	document.getElementById("txt_OpinionContent").value = GetAttribute(pSelectedRow[0], "DATA3");
            	document.getElementById("txt_OpinionContent").disabled = "";
            }
            
            displayButtons();
		}
		
		//Row 더블클릭
		function OpinionOnSelChange_ondbclick() {
			var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");
            
            var pSelectedRow = OpinionList.GetSelectedRows();
            if (pSelectedRow.length > 0) {
            	if (GetAttribute(pSelectedRow[0], "DATA2") == pUserID) {
					btn_OpinionMod_onclick();
            	}
            } 
		}
		
		//닫기[X] 클릭
		function btn_OpinionCancel_onclick() {
			if (ReturnFunction != null) {
				ReturnFunction("cancel");
				window.close();
			} else {
				window.returnValue = "cancel";
				window.close();
			}
		}
		
		//[작성] 버튼 클릭
		var opinionPopup_cross_dialogArguments = new Array();
		function btn_OpinionAdd_onclick() {
			if (pMode == "END" || pDisplay == "Show" || pDocState == "017"){return;}
			
			var parameter = new Array();
	        parameter[0] = "ADD";
	        parameter[1] = "";
	        
			opinionPopup_cross_dialogArguments[0] = parameter;
			opinionPopup_cross_dialogArguments[1] = opinionPopup_complete;
			
			DivPopUpShow(510, 380, "/ezApprovalG/aprOpinionPopup.do");
		}
		
		//[수정] 버튼 클릭
		function btn_OpinionMod_onclick() {
			if (pMode == "END" || pDisplay == "Show" || pDocState == "017"){return;}
			
			var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");
            
            var pSelectedRow = OpinionList.GetSelectedRows();
            if (pSelectedRow.length > 0) {
            	if (GetAttribute(pSelectedRow[0], "DATA2") == pUserID) {
					var parameter = new Array();
			        parameter[0] = "MOD";
			        parameter[1] = GetAttribute(pSelectedRow[0], "DATA3");
			        
					opinionPopup_cross_dialogArguments[0] = parameter;
					opinionPopup_cross_dialogArguments[1] = opinionPopup_complete;
					
					DivPopUpShow(510, 380, "/ezApprovalG/aprOpinionPopup.do");
            	}
            }
		}
		
		//[삭제] 버튼 클릭
		function btn_OpinionDel_onclick() {
			if (pMode == "END" || pDisplay == "Show" || pDocState == "017"){return;}
			
			var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");
            
            var pSelectedRow = OpinionList.GetSelectedRows();
            if (pSelectedRow.length > 0) {
            	if (GetAttribute(pSelectedRow[0], "DATA2") == pUserID || pDraftFlag == "REDRAFT") {
					deleteOpinionInfo();
            	}
            }
		}
		
		//[확인] 버튼 클릭
		function btn_OpinionOK_onclick() {
			if (ModifiedFlag) {
				if (pOpinionType == "001") { // 일반의견
					saveOpinionInfo();
				} else { // 일반의견이 아니라면, 내가 신규작성한 반송, 보류, 회송의견이 리스트 상에 존재하는 경우에만 의견을 저장한다.
					if (checkMyOpinionExist(pOpinionType) && isNewBBHOpinionFlag == true) {
						saveOpinionInfo();
					} else {
						btn_OpinionCancel_onclick();
					}
				}
			} else {
				btn_OpinionCancel_onclick();
			}
		}
		
		//의견내용 작성 팝업_complete
		function opinionPopup_complete(ret) {
			var result = "";
			
			if (ret != "cancel") {
				if (ret[2] == true && (pOpinionType == "002" || pOpinionType == "003" || pOpinionType == "004" || pOpinionType == "008")) { // 반송, 보류, 회송의견 신규작성 플래그값 변경
					isNewBBHOpinionFlag = true;
				} // 한 번이라도 신규작성되었다면, 해당 신규작성의견이 삭제되기 전까지 신규작성 플래그 true값을 유지함
				
				if (ret[0] == "ADD") {
					result = addOpinionContent(ret[1]);
				} else if (ret[0] == "MOD") {
					result = modOpinionContent(ret[1]);
				}
			}
			
			DivPopUpHidden();
			if (result == "TRUE") {
				OpenAlertUI(strLang490);
			} else if (result == "FALSE") {
				OpenAlertUI(strLang417);
			}
		}
		
		//의견 작성창 자동으로 팝업되도록
		function autoOpinionPopUp() {
			if (pDisplay != "" && pDisplay.toUpperCase() != "SHOW") { // 일반적인 의견이 아닌 경우 해당 함수 작동
				var OpinionList = new ListView();
				OpinionList.LoadFromID("OpinionList");
				
				if (pTempRowID != "") {
					OpinionList.SetSelectedID(pTempRowID);
					btn_OpinionMod_onclick(); //자신이 작성한 같은 타입의 의견이 있으면 [수정]창
				} else {
					btn_OpinionAdd_onclick(); //자신이 작성한 같은 타입의 의견이 없으면 [작성]창
				}
			}
		}
	
		</script>
		<style type="text/css">
			.mainlist tr th {
				border-top:0px
			}
			.listview {
				width: 100%; height: 190px; overflow-x:hidden; overflow-y: AUTO;
			}
			#txt_OpinionContent {
				width: 100%; height: 180px; box-sizing:border-box;-moz-box-sizing:border-box; resize:none;
			}
			#OPINION {
				margin:1px 1px 1px 1px;
			}
			h2 {
				margin-top: 10px; margin-bottom: 3px
			}
		</style>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t55'/></h1>
	    
	    <div id="close">
            <ul><li><span onclick="return btn_OpinionCancel_onclick()"></span></li></ul>
        </div>
        
	    <div class="listview">
	        <div id="lvOpinionList"></div>
	    </div>
	    
	    <h2><spring:message code='ezApprovalG.t423'/></h2>
	    <textarea id="txt_OpinionContent" style="cursor: default;" onfocus="this.blur();" readonly="readonly" disabled="disabled"></textarea>
	    
	    <div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="bbtn_OpinionAdd" style="display:none;"><span id="btn_OpinionAdd" onClick="return btn_OpinionAdd_onclick()" ><spring:message code='ezApprovalG.t421'/></span></a>
		    <a class="imgbtn" id="bbtn_OpinionMod" style="display:none;"><span id="btn_OpinionMod" onClick="return btn_OpinionMod_onclick()" ><spring:message code='ezApprovalG.t269'/></span></a>
		    <a class="imgbtn" id="bbtn_OpinionDel" style="display:none;"><span id="btn_OpinionDel" onClick="return btn_OpinionDel_onclick()" ><spring:message code='ezApprovalG.t266'/></span></a>
		    <a class="imgbtn" id="bbtn_OpinionOK"><span id="btn_OpinionOK" onClick="return btn_OpinionOK_onclick()"><spring:message code='ezApprovalG.t1760'/></span></a>
	    </div>
	    
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
