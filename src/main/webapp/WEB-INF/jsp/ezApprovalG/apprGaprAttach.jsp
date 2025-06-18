<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t264'/></title>
		<style> 
			.IMG_BTN { behavior:url("/css/include/ImgBtn.htc") }
			<%-- 2020-03-25 홍승비 - 첨부파일 버튼영역 마우스 드래그, 셀렉트 방지 추가 --%>
			.btnposition.btnpositionNew {
				-ms-user-select: none; 
				-moz-user-select: -moz-none;
				-khtml-user-select: none;
				-webkit-user-select: none;
				user-select: none;
			}
		</style>
		<meta http-equiv="Content-Type" content="text/html; charset=uft-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attach_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/webfolderFilePick.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
			var pDocID = null;
			var OrderCell = "";
			var pAttachFlag	= 0;
			var pAttachSN;
			var pAttachAddFileSize = 0;
			var Resultxml		= createXmlDom();
			var FirstAttach		= createXmlDom();
			var xmlhttp			= createXMLHttpRequest();
			var chkFlag			= false;
			var arr_userinfo = new Array();
			arr_userinfo[0]  = "user";								// 사용자-부서구분
			arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";              // 사용자ID
			arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";         // 사용자명
			arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";               // 사용자 직위
			arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";              // 사용자 부서 ID 
			arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";            // 사용자 부서 이름
			arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";             // 사용자 직책            
			arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";               // E-Mail Address 
			arr_userinfo[9]  = "";
			arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";                  // 수신 접수담당자
			arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";		// 사용자명(P)
			arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";		// 사용자명(S)
			arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";				// 사용자 직위(P)
			arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";				// 사용자 직위(S)
			arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";			// 사용자 부서 이름(P)
			arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";			// 사용자 부서 이름(S)
			
			var pUserID			= arr_userinfo[1];		// 사용자 ID
			var pUserName		= arr_userinfo[2];	    // 사용자 이름
			var pUserJobTitle	= arr_userinfo[3];	// 사용자 직위
			var pDeptID			= arr_userinfo[4];		// 부서ID  
			var pDeptName		= arr_userinfo[5];		// 부서 이름 
			var optExt = "<c:out value ='${poptExt}'/>";
			var maxSize = "<c:out value ='${apprTotalAttachLimit}'/>";
			var isBody = "<c:out value ='${isBody}'/>";
			var BodyAttach = "N";
			var AttachDelFlag = false;
			var pDraftFlag = "<c:out value ='${draftFlag}'/>";
			var approvalFlag = "<c:out value ='${approvalFlag}'/>";
			var apprTotalAttachLimit = "<c:out value ='${apprTotalAttachLimit}'/>";
			var attachFileNameMaxLength = Number("<c:out value ='${attachFileNameMaxLength}'/>");
			var totalSize = 0;
			var orgCompanyID = "<c:out value ='${orgCompanyID}'/>";
			var ext = "<c:out value ='${ext}'/>";
			var pCompanyID = "<c:out value='${userInfo.companyID}'/>"; // 원회사가 아닌 현재 소속 회사ID
			
			/* 2020-11-12 홍승비 - 대용량첨부 기능 추가 */
			var apprAttachLimit = "<c:out value='${apprAttachLimit}'/>"; // 일반 첨부파일 총 크기제한 (MB) = 일반 첨부파일 -> 대용량으로 변경되는 기준 크기 (MB)
			var bigSizeAttachLimitCount = "<c:out value='${bigSizeAttachLimitCount}'/>"; // 전자결재 대용량 첨부파일 개수제한
			var bigSizeApprAttachLimit = "<c:out value='${bigSizeApprAttachLimit}'/>"; //  전자결재 대용량 첨부파일 총 크기제한 (MB)
			var bigSizeApprAttachDelDay = "<c:out value='${bigSizeApprAttachDelDay}'/>"; // 전자결재 대용량 첨부파일 보존기간 (일)
	        var normalAttachSize = 0; // 일반첨부파일 크기
	        var bigAttachSize = 0; // 대용량 첨부파일 크기
	        var isBigAttachBtnClicked = false; // 대용량첨부 버튼으로 파일을 추가하는지 여부
	        var isOuterForm = "<c:out value ='${isOuterForm}'/>";
	        
	        /*2021-03-05 남학선 첨부를 올린사람 이외의 사람도 삭제가능여부를  결정하는 값*/
	        var delAttachByOthers = "<c:out value ='${delAttachByOthers}'/>";
	        
	        // 웹폴더첨부용 변수
	        var pickerData = "";
	        
	        /* 2022-01-20 홍승비 - 일괄기안용 변수 추가 */
	        var draftAllFlag = "<c:out value ='${draftAllFlag}'/>"; // 일괄기안 여부 플래그 (Y/M)
	        var anNo = "<c:out value ='${anNo}'/>"; // 일괄기안인 경우, 첨부파일을 첨부할 안의 번호
	        
	        var filetag;
	        
	        var orgResultxml;
			
			// 문서정보를 가져오는 함수
			function getDocInfo()
			{
			  try {
				if (isBody == "YES")
				{
					document.getElementById("BtnBodyAttach").style.display = "";
				}
				else
				{
					document.getElementById("BtnBodyAttach").style.display  = "none";
				}
			  } catch(e) {
				document.getElementById("BtnBodyAttach").style.display  = "none";
			  }
			}
			/**
			* 첨부파일의 History 관리
			*/
			function CheckHistory(pFlag) {
				var i, j;
				var listview = new ListView();
			    listview.LoadFromID("attachList");
			        
				if (pFlag == 0) {
					var FirstData = SelectNodes(FirstAttach, "LISTVIEWDATA/ROWS/ROW");
					var pAttachCurSel = listview.GetDataRows();
					
					for (i = 0; i < FirstData.length; i++) {
						var tempSN = SelectSingleNodeValue(GetChildNodes(FirstData[i])[0], "DATA2");
						var tempFileName = SelectSingleNodeValue(GetChildNodes(FirstData[i])[0], "DATA10");
						var DelFlag = true;
						
						for (j = 0; j < pAttachCurSel.length; j++) {
						    if (GetAttribute(pAttachCurSel[j], "DATA2") == tempSN && GetAttribute(pAttachCurSel[j], "DATA10") == tempFileName) {
								DelFlag = false;
							}
						}
						if (DelFlag) {
							UpdateAttachHistory(tempSN, strModifyFlag2);
						}
					}
				} else {
					var FirstData = listview.GetDataRows();
					var FileData = SelectNodes(FirstAttach,"LISTVIEWDATA/ROWS/ROW");
					
					for (i = 0; i < FirstData.length; i++) {
						var tempSN = GetAttribute(FirstData[i], "DATA2");
						var tempFileName = GetAttribute(FirstData[i], "DATA10");
						var AddFlag = true;
						
						for (j = 0; j < FileData.length; j++) {
			                if (getNodeText(FileData[j].getElementsByTagName("DATA2")[0]) == tempSN && getNodeText(FileData[j].getElementsByTagName("DATA10")[0]) == tempFileName) {
								AddFlag = false;
							}
						}
						
						if (AddFlag) {
							if (GetAttribute(FirstData[i], "DATA11") == "Y") {
								UpdateAttachHistory(tempSN, strModifyFlag4);
							} else {
								UpdateAttachHistory(tempSN, strModifyFlag1);
							}
						} else {
							if (GetAttribute(FirstData[i], "DATA12") == "EDITED")
								UpdateAttachHistory(tempSN, strModifyFlag3);
						}
					}
				}
			}
			
			/** 
			* 파일첨부UI 초기화
			* InitAttach()에서 기존 첨부파일리스트 추출 후 ListView()로 화면에 출력
			*/
			window.onload = function()
			{
				var doc;
				var form;
				getDocInfo();
				pDocID = "<c:out value ='${docID}'/>";
				pBoardFileSize  =	parseInt(maxSize);
			    document.getElementById("docid").value =pDocID;
			    document.getElementById("compid").value =  "<c:out value ='${userInfo.companyID}'/>";
				Resultxml = InitAttach(pDocID);
				
				if (parent.pOrgDocID != '') {
					orgResultxml = orgInitAttach(parent.pOrgDocID);
				}

				//2021-04-14 남학선 대용량첨부파일 용량제한이 0일때는 사용안하므로 버튼을 생략
				if(bigSizeApprAttachLimit == "0"){
					document.getElementById("btn_BigAttachAddA").style.display = "none";
				}

				totalSize = 0;
				normalAttachSize = 0;
				bigAttachSize = 0;
				
				var filezisearr = new Array();				
				for (var i = 0; i < SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW").length; i++) {
					
					var realFileSize = SelectSingleNodeValue(GetChildNodes(SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")[i],2)[0], "DATA8");
					totalSize += parseInt(realFileSize.split(".")[0]);
					
				    var fileSize = ReplacText(getNodeText(GetChildNodes(GetChildNodes(SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")[i])[2])[0]));
				    filezisearr[i] = fileSize;

				    
/* 				    if (fileSize > 1024 * 1024) {
				        fileSize = fileSize / 1024 / 1024;
				        strSize = parseInt(fileSize) + "MB";
				    }
				    else if (fileSize > 1024) {
				        fileSize = fileSize / 1024;
				        strSize = parseInt(fileSize) + "KB";
				    }
				    else {
				        strSize = parseInt(fileSize) + "B";
				    } */
				    strSize = fileSize;
			
				    setNodeText(GetChildNodes(GetChildNodes(SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")[i])[2])[0], strSize);
				    
				    // 기존 일반첨부, 대용량첨부 파일크기 계산
				    var isBigAttachFile = SelectSingleNodeValue(GetChildNodes(SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")[i],2)[0], "ISBIGATTACH");
				    if (isBigAttachFile == "Y") {
				    	bigAttachSize += parseInt(realFileSize.split(".")[0]);
				    } else {
				    	normalAttachSize += parseInt(realFileSize.split(".")[0]);
				    }
				}
				
				if (orgResultxml != null && SelectNodes(orgResultxml, "LISTVIEWDATA/ROWS/ROW").length > 0) {
					for (var i = 0; i < SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW").length; i++) {
						var href = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")[i])[0])[1]);
						for (var j = 0; j < SelectNodes(orgResultxml, "LISTVIEWDATA/ROWS/ROW").length; j++) {
							var orgHref = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(orgResultxml, "LISTVIEWDATA/ROWS/ROW")[j])[0])[1]);
							if (href == orgHref) {
								createNodeAndAppandNodeText(Resultxml, GetChildNodes(SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")[i])[0], "", "DELETE", "N");
								break;
							}
						}
					}	
				}
				
				/* 2020-03-19 홍승비 - 첨부파일 리스트뷰에서 다중선택이 가능하도록 수정 */
			    var listview = new ListView();
			    listview.SetID("attachList");
			    listview.SetSelectFlag(false);
			    listview.SetMulSelectable(true);
			    listview.SetRowOnDblClick("ATTACH_onDblclick");
			    listview.DataSource(Resultxml);
			    listview.DataBind("ATTACH");
			    
			    FirstAttach = Resultxml;
				pAttachSN = GetAttachSN(Resultxml);
				var pAttachRow = listview.GetDataRows();
				var pAttachRowLen = pAttachRow.length;
				pAttachSN = pAttachSN + 1;
				
				//btn_AttachDel.disabled = true; 
				
				for (var i = 0; i<4; i++) {
					var attachHead = document.getElementById("attachList_TH_"+[i]);
					if (i == 0) {
						attachHead.setAttribute("width","143px");
					} else if (i==1) {
						attachHead.setAttribute("width","435px");
					} else if (i==2) {
						attachHead.setAttribute("width","177px");
					}
				}
				
				// 웹폴더첨부를 위한 파라미터 설정
				pickerData = {
						'mode' 		: 'pickup', 		  // pickup: 웹폴더 → 첨부
						'confirmBT' : webFolderConfirmBT, // 웹폴더첨부 확인 시 실행할 함수
						'cancelBT' : webFolderCancelBT // 웹폴더첨부 취소 시 실행할 함수
				};
				
				filetag = document.getElementById("file1");
				filetag.addEventListener("click", function(){
					initialize();
				});
				
				setAttachSortable();
			}
			
			// 파일Size Text처리 함수
			function ReplacText(f_size)
			{
				rep = /'/g;
				f_size = f_size.replace("bytes","")
				return f_size
			}
			
			function attach_Add()
			{
			    document.form.file1.click();
			}
			//  파일첨부 화면 Call function
			var g_progresswin;
			function btn_AttachAdd_onclick() 
			{
			    if (document.form.file1.value != "") {
					if (document.form.file1.files[0].name.length > attachFileNameMaxLength) {
						showAlert_sub("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
						document.form.file1.value = "";
						return;
					} else {
				        document.getElementById("btn_AttachDel").disabled = false;
				        document.getElementById("attachsn").value = pAttachSN;
				        document.getElementById("maxsize").value = pBoardFileSize * 1024 * 1024; 
				        var frm = document.getElementById('form');
				        frm.submit();
				        
				        document.form.file1.value = "";
					}
			    } else {
			    	return;
// 			        showAlert_sub("<spring:message code='ezApprovalG.pjj01'/>");
			    }
			}
			
			function show_progress(fileinfo)
			{
				g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape(fileinfo), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken"); 
			}
			
			function status_change(fileinfo)
			{
				try {
					g_progresswin.document.Script.fileinfo_change(fileinfo);
				} catch(e) {}
			}
			 
			//파일 첨부 화면 Close Function
			function AttachCancel_onclick()
			{
				chkFlag = true;
				if (pAttachFlag != "0")
				{
					AttachFileListCancel();
				}
			  
				if (CrossYN()) {
					if (isIE() && window.dialogArguments) {
					    window.returnValue = "cancel";
					    window.close();
					} else {
					    parent.DivPopUpHidden();
					}
				} else {
				    window.returnValue = "cancel";
				    window.close();
				}
			}
			
			// 파일첨부리스트중 파일을 삭제하는 기능
			function btn_AttachDel_onclick()
			{
			    var listview = new ListView();
			    listview.LoadFromID("attachList");
			    
			    var pAttachCurSel =listview.GetSelectedRows();
			    if (pAttachCurSel.length > 0)
				{
					var isUsed = "";
				    if (typeof(parent.isUsed) != "undefined") {
				    	isUsed = parent.isUsed;
				    }
				    
				    for (var i = 0; i < pAttachCurSel.length; i++) {
		            	if (typeof(GetAttribute(pAttachCurSel[i], "DELETE")) != "undefined" && GetAttribute(pAttachCurSel[i], "DELETE") == "N") {
		            		OpenAlertUI("<spring:message code='ezApprovalG.t277'/>");
		            		return;
		            	}
		            }
				    
				    var userCheck = true;
		            for (var i = 0; i < pAttachCurSel.length; i++) {
		            	if (pUserID.toLowerCase() != GetAttribute(pAttachCurSel[i], "DATA4").toLowerCase()) {
		            		userCheck = false;
		            		break;
		            	}
		            }
				    
 					if (!userCheck && pDraftFlag != "REDRAFT" && isUsed != "reuse")
					{
 						if(delAttachByOthers == "0"){
							var pAlertContent = "<spring:message code='ezApprovalG.t277'/>" + "<br>" + "<spring:message code='ezApprovalG.t278'/>";
							OpenAlertUI(pAlertContent);				 							
 						} else {
							btn_AttachDel_onclick_doDel();		
 						}
					}
					else
					{ 
						btn_AttachDel_onclick_doDel();						
					}
				}
				else
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t281'/>";
					OpenAlertUI(pAlertContent);
				}
			}
			
			function btn_AttachDel_onclick_doDel(){
				var pInformationContent = "<spring:message code='ezApprovalG.t279'/>";
			    var Ans = OpenInformationUI(pInformationContent, btn_AttachDel_onclick_Complete);
			    
			    /* 2020-03-30 홍승비 - 한글기안 시 첨부파일 호환 코드 추가 (Ans가 바로 조건으로 사용됨) */
			    if (Ans) {
			        var listview = new ListView();
			        listview.LoadFromID("attachList");
			        var pAttachCurSel = listview.GetSelectedRows();
			        var pAttachRow = listview.GetSelectedRows();
			        
					/* 2020-03-19 홍승비 - 첨부파일 다중삭제 동작 구현 */
			        var Rtnval = ""
			        var pSelectedRowLength = pAttachRow.length; 
			        for (var i = 0; i < pSelectedRowLength; i++) {
				        Rtnval = DeleteFileAtServer(pAttachCurSel[i]);
				        // 의미없는 미구현 함수 DelfileSize(delfileSize) 동작 제거
				        
				        if (Rtnval != "TRUE") {
				        	break;
				        } else {
				            if (totalSize > 0) { // 첨부파일의 크기 계산하는 부분 루프 내부로 이동
				            	totalSize -= parseInt(GetAttribute(pAttachRow[i], "DATA8"));
				            }
				            
				            // 일반첨부, 대용량첨부의 삭제 후 크기 계산
				            if (bigAttachSize > 0 && GetAttribute(pAttachRow[i], "ISBIGATTACH") == "Y") {
				            	bigAttachSize -= parseInt(GetAttribute(pAttachRow[i], "DATA8"));
				            }
				            else if (normalAttachSize > 0 && GetAttribute(pAttachRow[i], "ISBIGATTACH") != "Y") {
				            	normalAttachSize -= parseInt(GetAttribute(pAttachRow[i], "DATA8"));
				            }
				        }
			        }
			        
			        if (Rtnval == "TRUE") {
			            DelAttachFileAtList(pAttachCurSel);
			            
			            /* 2018-10-11 김민성 - 데이터 없을 때 문구 뜨도록 수정 */
			            var totalRows = listview.GetDataRows();
					    if(totalRows.length == 0) {
					    	setDeleteRow("attachList");
					    }
			        }
			        else {
			            var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
			            OpenAlertUI(pAlertContent);
			        }
			    }
			}
			
			function btn_AttachDel_onclick_Complete(Ans) {
			    DivPopUpHidden();
			    if (Ans) {
			        var listview = new ListView();
			        listview.LoadFromID("attachList");
			        var pAttachCurSel = listview.GetSelectedRows();
			        var pAttachRow = listview.GetSelectedRows();
			        
					/* 2020-03-19 홍승비 - 첨부파일 다중삭제 동작 구현 */
			        var Rtnval = ""
			        var pSelectedRowLength = pAttachRow.length; 
			        for (var i = 0; i < pSelectedRowLength; i++) {
				        Rtnval = DeleteFileAtServer(pAttachCurSel[i]);
				        // 의미없는 미구현 함수 DelfileSize(delfileSize) 동작 제거
				        
				        if (Rtnval != "TRUE") {
				        	break;
				        } else {
				            if (totalSize > 0) { // 첨부파일의 크기 계산하는 부분 루프 내부로 이동
				            	totalSize -= parseInt(GetAttribute(pAttachRow[i], "DATA8"));
				            }
				            
				            // 일반첨부, 대용량첨부의 삭제 후 크기 계산
				            if (bigAttachSize > 0 && GetAttribute(pAttachRow[i], "ISBIGATTACH") == "Y") {
				            	bigAttachSize -= parseInt(GetAttribute(pAttachRow[i], "DATA8"));
				            }
				            else if (normalAttachSize > 0 && GetAttribute(pAttachRow[i], "ISBIGATTACH") != "Y") {
				            	normalAttachSize -= parseInt(GetAttribute(pAttachRow[i], "DATA8"));
				            }
				        }
			        }
			        
			        if (Rtnval == "TRUE") {
			            DelAttachFileAtList(pAttachCurSel);
			            
			            /* 2018-10-11 김민성 - 데이터 없을 때 문구 뜨도록 수정 */
			            var totalRows = listview.GetDataRows();
					    if(totalRows.length == 0) {
					    	setDeleteRow("attachList");
					    }
			        }
			        else {
			            var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
			            OpenAlertUI(pAlertContent);
			        }
			    }
			}
			
			// 첨부파일리스트중에서 선택된 첨부파일을 내용을 보는 함수
			function btn_AttachOpen_onclick() {
			
			}
			
			// 첨부파일리스트중에서 선택된 첨부파일을 로컬로 복사하는 함수
			function btn_AttachSave_onclick()
			{
			
			}
			
			//   첨부파일 리스트를 DB에 저장하는 function
			function btn_AttachSaveSure_onclick() {
			    var listview = new ListView();
			    listview.LoadFromID("attachList");
			    
			    var Listlen =listview.GetDataRows();
			    var tr = Listlen[0];
				chkFlag = true;

				// 첨부파일이 전부 삭제되었거나, 추가하지 않은 경우
				if (Listlen.length == 0 || tr.getAttribute("DATA1") == null) {
					CheckHistory(0);
					var RtnVal = AttachRemoveAll();
					if (RtnVal == "FALSE") {
						var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
						OpenAlertUI(pAlertContent);
					}
					
					for (i=0 ; i < pDeleteFile.length ; i++) {
						DeleteFileAtServer_true(pDeleteFile[i]);
					}
					
					// 일괄기안창에서 접근한 경우, 각 안별 첨부파일 플래그 변경
					if (draftAllFlag == "Y") {
						modDraftAllHasAttachYN(anNo, "N");
					}
					
					if (CrossYN()) {
						if (isIE() && window.dialogArguments) {
						    window.returnValue = "Clear";
						    window.close();
						} else {
						    parent.setAttachInfo(pDocID, "APR", parent.lstAttachLink);
						    parent.DivPopUpHidden();
						}
					} else {
					    window.returnValue = "Clear";
					    window.close();
					}
				}
				// 리스트에 리스트 목록이 있는 경우 그리고 파일추가 flag > 0 인경우 
				else {
					CheckHistory(0);
					var Attachxml = APRAttachXMLParsing(ATTACH,pDocID);
					SaveAttachListInfo(Attachxml);
					
					if (draftAllFlag == "Y") {
						modDraftAllHasAttachYN(anNo, "Y");
					}
					
					for (i=0 ; i < pDeleteFile.length ; i++) {
						DeleteFileAtServer_true(pDeleteFile[i]);
					}
				}
			}
			   
			
			function AttachFileInfo(pFileName, pFileSize, pFileLocation, addToBigAttach)
			{
			    if (pFileName == "Error") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
			        OpenAlertUI(pAlertContent);
			        btn_AttachAdd.disabled = false;
			    }
			    else {
			        if (CrossYN()) {
			            AddAttachFileInfoXmlParsing(pFileName, pFileSize, pFileLocation, addToBigAttach);
			        }
			        else {
			            Resultxml = AddAttachFileInfoXmlParsing(pFileName, pFileSize, pFileLocation, addToBigAttach)
			            InsertAttachFileInfo(ATTACH, Resultxml);
			            pAttachFlag = pAttachFlag + 1;
			            pAttachSN = pAttachSN + 1;
			            btn_AttachAdd.disabled = false;
			        }
			    }
			}
			
			// 첨부파일 리스트 클릭시 사용자가 추가한 첨부파일인지 여부 검사
			function ATTACHonSelChange_onclick()
			{
				var pCurSelRow = window.event.result;
				var pAttachUserID = pCurSelRow.cells(0).DATA4;
				if(pAttachUserID.toLowerCase() == pUserID.toLowerCase())
				{
					btn_AttachDel.Enable = "true";
					btn_AttachDel.disabled = false;
				}
				else
				{
				    btn_AttachDel.Enable = "false";
					btn_AttachDel.disabled = true;
				}
			}
			
			window.onbeforeunload = function()
			{
				if(!chkFlag)
					AttachCancel_onclick();
			}
			
			function ATTACH_onDblclick() {
			    var CurSelList = new ListView();
			    CurSelList.LoadFromID("attachList");
			
			    var pCurSelRow = CurSelList.GetSelectedRows();
			    var pAttachUserID = GetAttribute(pCurSelRow[0], "DATA4");
			    var isUsed = "";
			    if (typeof(parent.isUsed) != "undefined") {
			    	isUsed = parent.isUsed;
			    }
			    
            	if (typeof(GetAttribute(pCurSelRow[0], "DELETE")) != "undefined" && GetAttribute(pCurSelRow[0], "DELETE") == "N") {
            		OpenAlertUI("<spring:message code='ezApprovalG.t282'/>");
            		return;
            	}
				
			    if (pAttachUserID.toLowerCase() == pUserID.toLowerCase() || isUsed == "reuse") {
			        var retValue = getAttachFilePageNum(GetAttribute(pCurSelRow[0], "DATA9"), GetChildNodes(pCurSelRow[0])[1].innerHTML, ATTACH_onDblclick_Complete);
			        if (retValue != undefined) {
			            if ((!CrossYN()) && retValue[0] == "OK") {
			                SetAttribute(pCurSelRow[0], "DATA9", retValue[1]);
			                pCurSelRow[0].childNodes[1].innerHTML = retValue[2];
			                pCurSelRow[0].childNodes[3].innerHTML = retValue[1];
			                SetAttribute(pCurSelRow[0], "DATA12", retValue[2]);
			            }
			        }
			    }
			    else {
			        var pAlertContent = "<spring:message code='ezApprovalG.t282'/>" + "<br>" + "<spring:message code='ezApprovalG.t283'/>";
			        OpenAlertUI(pAlertContent);
			    }
			}
			
			    function ATTACH_onDblclick_Complete(retValue) {
			        DivPopUpHidden();
			        if (retValue[0] == "OK") {
			            var CurSelList = new ListView();
			            CurSelList.LoadFromID("attachList");
			            var pCurSelRow = CurSelList.GetSelectedRows();
			            SetAttribute(pCurSelRow[0], "DATA9", retValue[1]);
			            pCurSelRow[0].childNodes[1].innerHTML = MakeXMLString(retValue[2]);
			            pCurSelRow[0].childNodes[1].title = retValue[2];
// 			            pCurSelRow[0].childNodes[3].innerHTML = retValue[1];
			            SetAttribute(pCurSelRow[0], "DATA12", retValue[2]);
			        }
			    }
			
			function btn_AttachEdit_onclick()
			{
			    try
			    {
			        var AttachList = new ListView();
			        AttachList.LoadFromID("attachList");
			        
			        var pSelectedRow = AttachList.GetSelectedRows();
			
			    	
			        if(pSelectedRow.length != "0")
			        {
			            // 수정(2008.04.03) : 수정버튼 클릭시에도 등록자인지 여부 체크하도록 수정
			            var pAttachUserID = GetAttribute(pSelectedRow[0], "DATA4");//pSelectedRow.item(0).cells(0).DATA4;
				        if(pAttachUserID.toLowerCase() != pUserID.toLowerCase())
				        {
					        var pAlertContent = "<spring:message code='ezApprovalG.t282'/>" + "<br>" + "<spring:message code='ezApprovalG.t283'/>";
					        OpenAlertUI(pAlertContent);
					        return;
				        }
			            
			            var tempAttachFileName = GetAttribute(pSelectedRow[0], "DATA1");
					    var tempAttachFileExt = tempAttachFileName.substring(tempAttachFileName.length - 3, tempAttachFileName.length);
					    var tempAttachFileFlag = false;
					    if (tempAttachFileExt == "xml" || tempAttachFileExt == "htm" || tempAttachFileExt == "log")
						    tempAttachFileFlag = true;
			    		
					    if (tempAttachFileFlag)
					    {
						    var parameter = GetAttribute(pSelectedRow[0], "DATA1");
						    var url = "EditAttach.aspx";
						    var feature = "status:no;dialogWidth:720px;dialogHeight:630px;help:no;scroll:no";	
				            feature =  feature + GetShowModalPosition(720, 630);
						    var RtnVal = window.showModalDialog(url,parameter,feature);
			    		
						    if (RtnVal == "OK")
						    {
						        tempAttachSN = GetAttribute(pSelectedRow[0], "DATA2");
			                    EditAttachFileInfoXmlParsing(GetChildNodes(pSelectedRow[0])[1].innerHTML, GetChildNodes(pSelectedRow[0])[2].innerHTML, GetAttribute(pSelectedRow[0], "DATA1"), tempAttachSN);
						    }			
					    }
					    else
					    {    
						    var parameter = GetAttribute(pSelectedRow[0], "DATA1");
						    var url = "EditFileAttach.aspx";
						    var feature = "status:no;dialogWidth:333px;dialogHeight:205px;help:no;scroll:no";	
				            feature =  feature + GetShowModalPosition(333, 195);
						    var RtnVal = window.showModalDialog(url,parameter,feature);
			    		
						    if (RtnVal == "OK")
						    {
							    tempAttachSN = GetAttribute(pSelectedRow[0], "DATA2");
			                    EditAttachFileInfoXmlParsing(GetChildNodes(pSelectedRow[0])[1].innerHTML, GetChildNodes(pSelectedRow[0])[2].innerHTML, GetAttribute(pSelectedRow[0], "DATA1"), tempAttachSN);
						    }		
					    }
				    }
				    else
				    {
					    var pAlertContent = "<spring:message code='ezApprovalG.t284'/>";
					    OpenAlertUI(pAlertContent);
				    }
			    }
			    catch(ErrMsg)
			    {
			        showAlert_sub("btn_AttachEdit_onclick : " + ErrMsg.description);  
			    }
			}
			
			function btn_AttachBodyAdd_onclick()
			{
				BodyAttach = "Y";
				var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
				ezUtil.UseUTF8 = true;
				var file = ezUtil.OpenLoadDlgMulti("", "");
			
				if (!file)
					return;
			
				g_fileList = file.split(";");
				var fileSize = 0;
				for (var i=0; i<g_fileList.length-1; i++)
				{
				    ezUtil.UseUTF8 = true;
					if (ezUtil.GetFileSize(g_fileList[i]) == 0)
					{
						showAlert_sub("<spring:message code='ezApprovalG.t270'/>");
						return;
					}
					ezUtil.UseUTF8 = true;
					fileSize += ezUtil.GetFileSize(g_fileList[i]); 			
				}
			
				ezUtil = null;
				if (fileSize > pBoardFileSize * 1024 * 1024)
				{
					showAlert_sub("<spring:message code='ezApprovalG.t271'/>" + pBoardFileSize + "MB" + "<spring:message code='ezApprovalG.t272'/>");
					return;
				}
			
				var fileNamelist = "";
				var fileName = "";
				show_progress(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\")+1) + "<spring:message code='ezApprovalG.t273'/>" + 1 + "/" + (g_fileList.length-1));
			
				for (var i=0; i<g_fileList.length-1; i++)
				{
					try {
						if (i > 0)
							status_change(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1) + "<spring:message code='ezApprovalG.t273'/>" + (i+1) + "/" + (g_fileList.length-1));
			
						oPoster.Clear();
						oPoster.UseUTF8 = true;
						oPoster.AddFormData("mode", "send");
						oPoster.AddFormData("UploadID", pDocID);
						oPoster.AddFormData("UploadSN", pAttachSN);
						oPoster.AddFormData("UploadMaxFileSize", pBoardFileSize);
						oPoster.AddFormData("UploadAddFileSize", pAttachAddFileSize);
						oPoster.AddFile("UploadFile", g_fileList[i], 0);
						oPoster.Host = "<c:out value ='${serverName}'/>";
						oPoster.PostURL = "/myoffice/ezApprovalG_Cross/ezAPRATTACH/aspx/AttachFile.aspx";
			            if (window.location.protocol == "http:")
			                oPoster.Protocol = 0;
			            else
			                oPoster.Protocol = 1;
						oPoster.Post();
			
						if (oPoster.Response.substr(0, 2) != "OK")
						{
							try {
								g_progresswin.close();
							} catch(e) {}
			
							showAlert_sub(g_fileList[i] + " <spring:message code='ezApprovalG.t274'/>");
							return;
						}
						else
						{
							var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
							ezUtil.UseUTF8 = true;
							fileSize = ezUtil.GetFileSize(g_fileList[i]) + "bytes"; 			
							AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), fileSize, oPoster.Response.substr(3, oPoster.Response.length-3), "");
						}
					} 
					catch (e) 
					{
						try {
							g_progresswin.close();
						} catch(e) {}
			
						if (e.number == -2147352567)
							showAlert_sub("<spring:message code='ezApprovalG.t275'/>");
						else 
							showAlert_sub(g_fileList[i] + " <spring:message code='ezApprovalG.t276'/>" + "\n\n" + e.number + " - " + e.description);
						return;
					}	
				}
				try {
					g_progresswin.close();
				} catch(e) {}
			}
			
			var fileSize = 0;
			function returnvalue(result, filename, filelocation, filesize, addToBigAttach)
			{
			    if(result == "true")
			    {
			        if (filesize == 0)
				    {
					    showAlert_sub("<spring:message code='ezApprovalG.t270'/>");
					    return;
			        }
			        AttachFileInfo(filename, filesize, filelocation, addToBigAttach);
			    }
			    else if(result == "overflow")
			    {
			        showAlert_sub("<spring:message code='ezApprovalG.t271'/>" + pBoardFileSize + "MB"+ "<spring:message code='ezApprovalG.t272'/>");
			    }
			    else if (result == "denied") {
			        showAlert_sub(strLang1026);
			    }
			    else
			    {
			        showAlert_sub(filename + "<spring:message code='ezApprovalG.pjj07'/>" + "\n\n" + result);
			    }
			}
			function onDragEnter(evt) {
		        evt.dataTransfer.dropEffect = "copy";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
		    function onDragOver(evt) {
		        evt.dataTransfer.dropEffect = "copy";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
		    var filesize = 0;
		    var file = new Array;
		    var xhr = new XMLHttpRequest();
		    var lstAttachLink = document.getElementById("ATTACH");
		    var isfileup = false;
		    function onDrop(evt) {
		        file = new Array;
		        if (evt != undefined) {
		            evt.stopPropagation();
		            evt.preventDefault();
		        }
		        if (isfileup) {
		            hideLoadingProgress();
		            showAlert_sub(strLangjjh03);
		            return;
		        }
		        var filelist;
		        if (evt == undefined) {
		            filelist = document.getElementById("file1").files;
		        }
		        else {
		            filelist = evt.dataTransfer.files;
		        }
	
		        var tempfilesize = 0;
		        var filecnt = file.length;
		        
		        /* 2020-05-18 홍승비 - 첨부파일 개수제한 기능 추가 */
				var checkAttachResult = checkAttachFileCntLimit(filelist.length);
		        if (checkAttachResult == "NO") {
		        	document.form.file1.value = "";
		        	hideLoadingProgress();
		        	return;
		        }
		        
		        for (var i = 0; i < filelist.length; i++) {
		            /* if (filelist[i].size / 1024 / 1024 > 5) {
		                showAlert_sub(strLang25);
		                return;
		            }
		            else { */
		                file[filecnt + i] = filelist[i];
		                tempfilesize += filelist[i].size;
		            //}
		        }
		        filesize += tempfilesize;
	
/* 		        if (CrossYN()) {
		            document.getElementById("file").value = "";
		        }
		        else {
		            document.getElementById("file").type = "text";
		            document.getElementById("file").type = "file";
		        } */

		        fileupload();
		    }
		    
		    function fileupload() {
		        var fd = new FormData();
		        var calTotalSize = 0; // 전체 첨부파일 크기
		        var calNormalAttachSize = 0; // 일반첨부파일 크기
		        var calBigAttachSize = 0; // 대용량 첨부파일 크기
		        var calBigAttachCnt = 0; // 대용량 첨부파일 개수
		        var addToBigAttach = "N"; // 대용량 첨부파일로 추가하는지 여부

		        // 대용량 첨부파일과 일반 첨부파일 분리하여 각각의 총합 계산
		        for (var i = 0; i < file.length; i++) {
		        	calTotalSize += parseInt(file[i].size);
		        	
		        	// 대용량첨부 버튼으로 추가하는 경우, 모든 파일을 대용량첨부로 계산 (isBigAttachBtnClicked)
		        	// 일반 첨부파일의 총 용량을 넘지 않는다면 일반 첨부파일로 저장
		        	if (isBigAttachBtnClicked == false && (normalAttachSize + calNormalAttachSize + parseInt(file[i].size) < apprAttachLimit * 1024 * 1024)) {
		        		calNormalAttachSize += parseInt(file[i].size);
		        	}
		        	// 일반 첨부파일의 총 용량을 넘는 순간부터 대용량 첨부파일로 저장
		        	else if (isBigAttachBtnClicked == true || ((normalAttachSize + calNormalAttachSize + parseInt(file[i].size) >= apprAttachLimit * 1024 * 1024) && isOuterForm == "false")) {
		        		calBigAttachSize += parseInt(file[i].size);
		        		calBigAttachCnt += 1;
		        		addToBigAttach = "Y";
		        	}
		        }
		        
		        // 일반 첨부파일의 총용량제한 초과 시, 현재 추가하는 파일 전부를 대용량첨부로 변경
		        if (addToBigAttach == "Y") {
		        	var bigFileCheck = false;
		        	
		        	// 대용량첨부 버튼으로 추가하는 경우, 확인 알러트 발생하지 않음
		        	if (isBigAttachBtnClicked == true) {
		        		bigFileCheck = true;
		        	} else {
		        		if(bigSizeApprAttachLimit == "0"){
		        			hideLoadingProgress();
		        			showAlert_sub(strLangAtachHIK_01 + apprAttachLimit + strLangAtachHIK_02);
		        			return false;
						} else {
							// bigFileCheck = confirm(strLangHSBAt13 + apprAttachLimit + "MB" + strLangHSBAt14);
							ezCommon_cross_dialogParams[0] = fd;
							ezCommon_cross_dialogParams[1] = calTotalSize;
							ezCommon_cross_dialogParams[2] = calNormalAttachSize;
							ezCommon_cross_dialogParams[3] = calBigAttachSize;
							ezCommon_cross_dialogParams[4] = calBigAttachCnt;
							ezCommon_cross_dialogParams[5] = addToBigAttach;
							showConfirm_sub(strLangHSBAt13 + apprAttachLimit + "MB" + strLangHSBAt14, fileupload_afterConfirm);
							return;
						}
						//bigFileCheck = confirm(apprAttachLimit + "MB" + strLangHSBAt00 + bigSizeApprAttachDelDay + strLang1030 + " " +strLangHSBAt01);
		        	}
		        	
		        	if (bigFileCheck != true) {
		        		addToBigAttach = "N";
		        		hideLoadingProgress();
		        		return;
		        	} else {
		        		calBigAttachSize += calNormalAttachSize; // 같이 추가되는 일반 첨부파일도 전부 대용량으로 추가되므로.
		        		calNormalAttachSize = 0; // 대용량으로 변환되므로 일반 첨부파일로는 추가되지 않음
		        	}
		        }
		        
		     	// 대용량첨부파일 최대개수 초과 체크
				var checkBigAttachResult = checkBigAttachFileCntLimit(calBigAttachCnt);
		        if (checkBigAttachResult == "NO") {
		        	isfileup = false;
		        	document.form.file1.value = "";
		        	hideLoadingProgress();
		        	return;
		        }
		        
		        // 대용량첨부파일 최대크기 초과 체크
				if (bigAttachSize + calBigAttachSize > parseInt(bigSizeApprAttachLimit) * 1024 * 1024) {
					hideLoadingProgress();
					showAlert_sub(strLangHSBAt03 + bigSizeApprAttachLimit  + strLangHSBAt04);
		        	isfileup = false;
		        	document.form.file1.value = "";
		        	return;
		        }

		        // 첨부파일 총용량제한 (일반 + 대용량의 합)
		        if (apprTotalAttachLimit != "") {
			        if (apprTotalAttachLimit > 0) {
			        	var totMaxSize = parseInt(apprTotalAttachLimit) * 1024 * 1024;
			        	
			        	if (parseInt(totalSize + calTotalSize) > totMaxSize) {
			        		hideLoadingProgress();
			        		showAlert_sub(strLangjjh01 + apprTotalAttachLimit + strLangjjh02);
				        	isfileup = false;
				        	// 용량 초과 파일 같은 파일 업로드 시 알러트 다시 뜨게 수정 2018-04-19 강민수92
				        	document.form.file1.value = "";
				        	return;
				        } else {
				        	totalSize += calTotalSize;
				        }
			        }
		        }

		        for (var i = 0; i < file.length; i++) {
					var fnl = file[i].name.length;
					if (file[i].name.lastIndexOf('.') != -1) { // 2024-02-13 확장자 제외 파일명 길이를 체크
						fnl = file[i].name.lastIndexOf('.');
					}
		        	
		        	if (fnl > attachFileNameMaxLength) {
		        		hideLoadingProgress();
		        		showAlert_sub("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
		        		isfileup = false;
		        		document.form.file1.value = "";
		        		return;
		        	} else {
		        		fd.append("file1", file[i]);
		        	}		            
		        }
        
		        isfileup = true;
		        fd.append("boardid", window.parent.pBoardID);
		        fd.append("maxsize", pBoardFileSize * 1024 * 1024);
		        fd.append("compid", orgCompanyID);
		        fd.append("docid", document.getElementById("docid").value);
		        fd.append("attachsn", pAttachSN);
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezApprovalG/multiUpload.do",
		    		data : fd,
		    		processData: false, 
		    		contentType: false,
		    		success: function(text){
		    			var uFileCnt = text.resultUpload.length

		    			for (var i = 0; i < uFileCnt; i++) {
		    				returnvalue(text.resultUpload[i], text.fileName[i], text.fileLocation[i], text.fileSize[i], addToBigAttach);
		    			}
		    			
		    			isfileup = false;
		    			
		    			// 일반첨부, 대용량첨부 용량 갱신
		    			normalAttachSize += calNormalAttachSize;
		    			bigAttachSize += calBigAttachSize;
		    		}
		    	});
		       	// 같은 파일 업로드 할 수 있게 수정 2018-04-19 강민수92
		        document.form.file1.value = "";
		       	hideLoadingProgress();
		    }
		    
		    /* 2020-03-23 홍승비 - 첨부파일 위로 이동 함수 */
		    function btn_AttachMoveUp_onclick() {
				var listview = new ListView();
		        listview.LoadFromID("attachList");
		        var cnt = listview.GetRowCount();
		        var pSelectedRows = listview.GetSelectedRows();
		        var pSelectedRowsLength = pSelectedRows.length;
		        
		        for (var i = 0; i < pSelectedRowsLength; i++) {
			        if (listview.GetSelectedIndexes().split(",")[i] == "0") { // 최상단 로우 포함
			            return;
			        } else {
                        var item1 = pSelectedRows[i];
                        var item2 = pSelectedRows[i].previousSibling;
                        var parent = item1.parentNode;
                        var itemtmp = item1.cloneNode(1);
                        item2 = parent.replaceChild(itemtmp, item2);
                        parent.replaceChild(item2, item1);
                        parent.replaceChild(item1, itemtmp);
			        }
		        }
		        
		        // 순서조정이 끝난 뒤, 일괄적으로 ID를 갱신(다중선택 시 오류 발생 방지)
		        var afterRows = listview.GetDataRows();
		        for (var j = 0; j < cnt; j++) {
		        	SetAttribute(afterRows[j], "ID", ("attachList_TR_" + j));
		        }
		    }
		    
		    /* 2020-03-23 홍승비 - 첨부파일 아래로 이동 함수 */
		    function btn_AttachMoveDown_onclick() {
				var listview = new ListView();
		        listview.LoadFromID("attachList");
		        var cnt = listview.GetRowCount();
		        var pSelectedRows = listview.GetSelectedRows();
		        var pSelectedRowsLength = pSelectedRows.length;
		        
		        for (var i = pSelectedRowsLength; i > 0; i--) {
			        if (listview.GetSelectedIndexes().split(",")[i - 1] == (cnt - 1)) { // 최하단 로우 포함
			            return;
			        } else {
	                    var item1 = pSelectedRows[i - 1];
	                    var item2 = pSelectedRows[i - 1].nextSibling;
	                    var parent = item1.parentNode;
	                    var itemtmp = item1.cloneNode(1);
	                    item2 = parent.replaceChild(itemtmp, item2);
	                    parent.replaceChild(item2, item1);
	                    parent.replaceChild(item1, itemtmp);
			        }
		        }
		        
		        var afterRows = listview.GetDataRows();
		        for (var j = 0; j < cnt; j++) {
		        	SetAttribute(afterRows[j], "ID", ("attachList_TR_" + j));
		        }
		    }
		    
		    /* 2020-05-18 홍승비 - 현재 첨부파일 개수 + 새로 업로드할 첨부파일 개수를 계산하여 개수제한을 체크하는 함수 */
		    function checkAttachFileCntLimit(pNewAttachFileCnt) {
		    	var resultTxt = "YES";
 		    	var listview = new ListView();
			    listview.LoadFromID("attachList"); 
			    
			    var orgAttachFileCnt =  listview.GetDataRows().length;
			    if (document.getElementById("attachList_TR_noItems") != null) {
			    	orgAttachFileCnt = 0;
			    }
			    
			    var sumAttachFileCnt = orgAttachFileCnt + pNewAttachFileCnt;
			    
            	$.ajax({
                	type : "GET",
                	url : "/admin/ezApprovalG/getAttachLimit.do",
                	async : false,
                	data : {
                		companyID : pCompanyID
                	},
                	success : function(resultCnt) {
                		if (resultCnt != -1 && sumAttachFileCnt > resultCnt) { // -1이라면 무제한
                			showAlert_sub("<spring:message code='ezApprovalG.hsbAL12' arguments='" + resultCnt + "'/>");
                			resultTxt = "NO";
                		}
                	},
                	error : function() {
                		showAlert_sub("<spring:message code='ezApprovalG.hsbAL13' />");
                		resultTxt = "NO";
                	}
                });
            	
            	return resultTxt;
		    }
		    
		    /* 2020-11-12 홍승비 - 현재 대용량첨부파일 개수 + 새로 업로드할 대용량첨부파일 개수를 계산하여 개수제한을 체크하는 함수 */
		    function checkBigAttachFileCntLimit(pNewBigAttachFileCnt) {
		    	var resultTxt = "YES";
			    var orgBigAttachFileCnt =  $("#attachList").find("tr[isbigattach='Y']").length;
			    
			    if (document.getElementById("attachList_TR_noItems") != null) {
			    	orgBigAttachFileCnt = 0;
			    }
			    
			    var sumBigAttachFileCnt = orgBigAttachFileCnt + pNewBigAttachFileCnt;
			    
				if (bigSizeAttachLimitCount > 0 && sumBigAttachFileCnt > bigSizeAttachLimitCount) { // 0이라면 무제한
					showAlert_sub("<spring:message code='ezSystem.HSBAppr05' arguments='" + bigSizeAttachLimitCount + "'/>");
					resultTxt = "NO";
				}
				
            	return resultTxt;
		    }
		    
		    // 대용량첨부 버튼으로 파일을 추가하는지 플래그를 변경하는 함수
		    function isBigAttachButtonClick(flag) {
		    	if (flag == "Y") {
		    		isBigAttachBtnClicked = true;
		    	} else {
		    		isBigAttachBtnClicked = false;
		    	}
		    }
		    
		    // 웹폴더첨부를 위한 함수
		    function filePicker() {
		    	filePick.open(pickerData);
		    }
		    
		    // 웹폴더첨부 확인, 확정 시 동작
		    function webFolderConfirmBT(selectedFileInfo) {
		    	var webFolderFileList = JSON.parse(selectedFileInfo.fileList);
		    	var webFolderFileListCnt = webFolderFileList.length;
		    	
		    	if (isfileup) {
		            showAlert_sub(strLangjjh03);
		            return;
		        }
		        // 새로 추가할 웹폴더 첨부파일과 기존 파일의 개수제한 체크
				var checkAttachResult = checkAttachFileCntLimit(webFolderFileListCnt);
		        if (checkAttachResult == "NO") {
		        	return;
		        }
		        
		        var fd = new FormData();
		        var calTotalSize = 0; // 전체 첨부파일 크기
		        var calNormalAttachSize = 0; // 일반첨부파일 크기
		        var calBigAttachSize = 0; // 대용량 첨부파일 크기
		        var calBigAttachCnt = 0; // 대용량 첨부파일 개수
		        var addToBigAttach = "N"; // 대용량 첨부파일로 추가하는지 여부

		        // 대용량 첨부파일과 일반 첨부파일 분리하여 각각의 총합 계산
		        for (var i = 0; i < webFolderFileListCnt; i++) {
		        	calTotalSize += parseInt(webFolderFileList[i].fileSize);
		        	
		        	// 대용량첨부 버튼으로 추가하는 경우, 모든 파일을 대용량첨부로 계산 (isBigAttachBtnClicked)
		        	// 일반 첨부파일의 총 용량을 넘지 않는다면 일반 첨부파일로 저장
		        	if (isBigAttachBtnClicked == false && (normalAttachSize + calNormalAttachSize + parseInt(webFolderFileList[i].fileSize) < apprAttachLimit * 1024 * 1024)) {
		        		calNormalAttachSize += parseInt(webFolderFileList[i].fileSize);
		        	}
		        	// 일반 첨부파일의 총 용량을 넘는 순간부터 대용량 첨부파일로 저장
		        	else if (isBigAttachBtnClicked == true || (normalAttachSize + calNormalAttachSize + parseInt(webFolderFileList[i].fileSize) >= apprAttachLimit * 1024 * 1024)) {
		        		calBigAttachSize += parseInt(webFolderFileList[i].fileSize);
		        		calBigAttachCnt += 1;
		        		addToBigAttach = "Y";
		        	}
		        }
		        
		        // 일반 첨부파일의 총용량제한 초과 시, 현재 추가하는 파일 전부를 대용량첨부로 변경
		        if (addToBigAttach == "Y") {
		        	var bigFileCheck = false;
		        	
		        	// 대용량첨부 버튼으로 추가하는 경우, 확인 알러트 발생하지 않음
		        	if (isBigAttachBtnClicked == true) {
		        		bigFileCheck = true;
		        	} else {
		        		//bigFileCheck = confirm(apprAttachLimit + "MB" + strLangHSBAt00 + bigSizeApprAttachDelDay + strLang1030 + " " +strLangHSBAt01);
		        		bigFileCheck = confirm(strLangHSBAt13 + apprAttachLimit + "MB" + strLangHSBAt14);
		        	}
		        	
		        	if (bigFileCheck != true) {
		        		addToBigAttach = "N";
		        		return;
		        	} else {
		        		calBigAttachSize += calNormalAttachSize; // 같이 추가되는 일반 첨부파일도 전부 대용량으로 추가되므로.
		        		calNormalAttachSize = 0; // 대용량으로 변환되므로 일반 첨부파일로는 추가되지 않음
		        	}
		        }
		        
		     	// 대용량첨부파일 최대개수 초과 체크
				var checkBigAttachResult = checkBigAttachFileCntLimit(calBigAttachCnt);
		        if (checkBigAttachResult == "NO") {
		        	isfileup = false;
		        	document.form.file1.value = "";
		        	return;
		        }
		        
		        // 대용량첨부파일 최대크기 초과 체크
				if (bigAttachSize + calBigAttachSize > parseInt(bigSizeApprAttachLimit) * 1024 * 1024) {
		        	showAlert_sub(strLangHSBAt03 + bigSizeApprAttachLimit  + strLangHSBAt04);
		        	isfileup = false;
		        	document.form.file1.value = "";
		        	return;
		        }

		        // 첨부파일 총용량제한 (일반 + 대용량의 합)
		        if (apprTotalAttachLimit != "") {
			        if (apprTotalAttachLimit > 0) {
			        	var totMaxSize = parseInt(apprTotalAttachLimit) * 1024 * 1024;
			        	
			        	if (parseInt(totalSize + calTotalSize) > totMaxSize) {
				        	showAlert_sub(strLangjjh01 + apprTotalAttachLimit + strLangjjh02);
				        	isfileup = false;
				        	document.form.file1.value = "";
				        	return;
				        } else {
				        	totalSize += calTotalSize;
				        }
			        }
		        }
		        
		        var webFolderFileStr = "";
		        for (var i = 0; i < webFolderFileListCnt; i++) {
					var fnl = file[i].name.length;
					if (file[i].name.lastIndexOf('.') != -1) { // 2024-02-13 확장자 제외 파일명 길이를 체크
						fnl = file[i].name.lastIndexOf('.');
					}
		        	
		        	if (fnl > attachFileNameMaxLength) {
		        		showAlert_sub("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
		        		isfileup = false;
		        		return;
		        	} else { // 파일명, 사이즈, 경로를 하드하게 '|' 문자열로 붙여서 서버로 전달
		        		webFolderFileStr += webFolderFileList[i].fileName + "|" +  webFolderFileList[i].fileSize + "|" + webFolderFileList[i].filePath + "|||"; 
		        	}		            
		        }
		        
		        isfileup = true;
		        fd.append("webFolderFileStr", webFolderFileStr);
		        fd.append("boardid", window.parent.pBoardID);
		        fd.append("maxsize", pBoardFileSize * 1024 * 1024);
		        fd.append("compid", orgCompanyID);
		        fd.append("docid", document.getElementById("docid").value);
		        fd.append("attachsn", pAttachSN);
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezApprovalG/multiUploadWebFolder.do",
		    		data : fd,
		    		processData: false, 
		    		contentType: false,
		    		success: function(text){
		    			var uFileCnt = text.resultUpload.length

		    			for (var i = 0; i < uFileCnt; i++) {
		    				returnvalue(text.resultUpload[i], text.fileName[i], text.fileLocation[i], text.fileSize[i], addToBigAttach);
		    			}
		    			
		    			isfileup = false;
		    			
		    			// 일반첨부, 대용량첨부 용량 갱신
		    			normalAttachSize += calNormalAttachSize;
		    			bigAttachSize += calBigAttachSize;
		    		}
		    	});
		    }
		    
		    // 웹폴더첨부 취소 시 동작. 필요하다면 input file 부분을 초기화한다.
		    function webFolderCancelBT() {
		    	return;
		    }
		    
		    // 일괄기안 사용 시 부모창의 첨부파일 플래그를 변경해준다. (Y/N)
		    function modDraftAllHasAttachYN(anNo, flag) {
		    	parent.pHasAttachYN = flag;
		    	parent.pHasAttachYNAry[anNo] = flag;
		    }
		    
		    // 파일 선택 다이얼로그를 제어하기 위한 함수
		    function initialize() {
				document.body.onfocus = checkIt;
			}
			
			function checkIt() {
			    setTimeout(function() {
		            if (filetag.value.length) {
		                onDrop();
		            } else {
		                hideLoadingProgress();
		            }
		            document.body.onfocus = null;
		        }, 300);
			};
			
			function isBigAttachButtonApr(flag) {
				showLoadingProgress();
		    	if (flag == "Y") {
		    		isBigAttachBtnClicked = true;
		    	} else {
		    		isBigAttachBtnClicked = false;
		    	}
			}
		    
			function fileupload_afterConfirm(rtn) {
				var fd = ezCommon_cross_dialogParams[0];
				var calTotalSize = ezCommon_cross_dialogParams[1]; // 전체 첨부파일 크기
				var calNormalAttachSize = ezCommon_cross_dialogParams[2]; // 일반첨부파일 크기
				var calBigAttachSize = ezCommon_cross_dialogParams[3]; // 대용량 첨부파일 크기
				var calBigAttachCnt = ezCommon_cross_dialogParams[4]; // 대용량 첨부파일 개수
				var addToBigAttach = ezCommon_cross_dialogParams[5]; // 대용량 첨부파일로 추가하는지 여부
				hideConfirm_sub();
				
				if (rtn != true) {
					addToBigAttach = "N";
					hideLoadingProgress();
					return;
				} else {
					calBigAttachSize += calNormalAttachSize; // 같이 추가되는 일반 첨부파일도 전부 대용량으로 추가되므로.
					calNormalAttachSize = 0; // 대용량으로 변환되므로 일반 첨부파일로는 추가되지 않음
				}

				// 대용량첨부파일 최대개수 초과 체크
				var checkBigAttachResult = checkBigAttachFileCntLimit(calBigAttachCnt);
				if (checkBigAttachResult == "NO") {
					isfileup = false;
					document.form.file1.value = "";
					hideLoadingProgress();
					return;
				}

				// 대용량첨부파일 최대크기 초과 체크
				if (bigAttachSize + calBigAttachSize > parseInt(bigSizeApprAttachLimit) * 1024 * 1024) {
					hideLoadingProgress();
					showAlert_sub(strLangHSBAt03 + bigSizeApprAttachLimit  + strLangHSBAt04);
					isfileup = false;
					document.form.file1.value = "";
					return;
				}

				// 첨부파일 총용량제한 (일반 + 대용량의 합)
				if (apprTotalAttachLimit != "") {
					if (apprTotalAttachLimit > 0) {
						var totMaxSize = parseInt(apprTotalAttachLimit) * 1024 * 1024;

						if (parseInt(totalSize + calTotalSize) > totMaxSize) {
							hideLoadingProgress();
							showAlert_sub(strLangjjh01 + apprTotalAttachLimit + strLangjjh02);
							isfileup = false;
							// 용량 초과 파일 같은 파일 업로드 시 알러트 다시 뜨게 수정 2018-04-19 강민수92
							document.form.file1.value = "";
							return;
						} else {
							totalSize += calTotalSize;
						}
					}
				}

				for (var i = 0; i < file.length; i++) {
					var fnl = file[i].name.length;
					if (file[i].name.lastIndexOf('.') != -1) { // 2024-02-13 확장자 제외 파일명 길이를 체크
						fnl = file[i].name.lastIndexOf('.');
					}

					if (fnl > attachFileNameMaxLength) {
						hideLoadingProgress();
						showAlert_sub("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
						isfileup = false;
						document.form.file1.value = "";
						return;
					} else {
						fd.append("file1", file[i]);
					}
				}

				isfileup = true;
				fd.append("boardid", window.parent.pBoardID);
				fd.append("maxsize", pBoardFileSize * 1024 * 1024);
				fd.append("compid", orgCompanyID);
				fd.append("docid", document.getElementById("docid").value);
				fd.append("attachsn", pAttachSN);

				$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezApprovalG/multiUpload.do",
					data : fd,
					processData: false,
					contentType: false,
					success: function(text){
						var uFileCnt = text.resultUpload.length

						for (var i = 0; i < uFileCnt; i++) {
							returnvalue(text.resultUpload[i], text.fileName[i], text.fileLocation[i], text.fileSize[i], addToBigAttach);
						}

						isfileup = false;

						// 일반첨부, 대용량첨부 용량 갱신
						normalAttachSize += calNormalAttachSize;
						bigAttachSize += calBigAttachSize;
					}
				});
				// 같은 파일 업로드 할 수 있게 수정 2018-04-19 강민수92
				document.form.file1.value = "";
				hideLoadingProgress();
			}
		</script>
		<style>
			.mainlist tr th {border-top:0px}
		</style>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t264'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="return AttachCancel_onclick()"></span></li>
            </ul>
        </div>
		<table>
		  <tr>
		    <td style="text-align:center;">
		    	<div class="listview" style="min-width:780px;">
		        	<div id="ATTACH" class="ui-sortable" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)" STYLE="overflow-x:hidden;HEIGHT:455px;min-width:780px;margin:auto;"></div>
		      	</div>
		      	<%-- 2020-11-12 홍승비 - 파일첨부 관련 알림 메세지 영역 --%>
		      	<div style="text-align:left; line-height:21px;margin-bottom: 50px;">
		      		<img src="/images/i_notice.gif" style="vertical-align: middle;padding-left:1px;" />
		      		<span style="color:#3a76c3;height:18px;display:inline-block;">${pAttachWarning0}</span><br>
		      		<span style="color:#3a76c3;height:18px;display:${spanDisplayStyle}; margin-left:29px;">${pAttachWarning1}</span>
		      	</div>	
		    </td>
		    <th style="display:none;width:75px;text-align:center;">
		      <input id="btn_AttachEdit" type="button" name="btn_AttachEdit" onClick="return btn_AttachEdit_onclick()" value="<spring:message code='ezApprovalG.t269'/>" class="imginput" style="margin-top:3px;display:none;" /><br />
		      <span id="BtnBodyAttach" style="display:none">
		      <input id="btn_AttachBodyAdd" type=button name="btn_AttachBodyAdd" onClick="return btn_AttachBodyAdd_onclick()" value="<spring:message code='ezApprovalG.t285'/>">
		      </span> </th>
		  </tr>
		</table>
		<iframe name="ifrm" src="about:blank" style="display:none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezApprovalG/upload.do" target="ifrm" >
		    <div class="btnposition btnpositionNew">       
		        <input id="file1" name="file1" type="file" multiple="multiple" style="margin-left:100px; display: none;">
		        <a class="imgbtn"><label for="file1"><span id="btn_AttachAdd" onclick="isBigAttachButtonApr('N')" style="cursor:pointer"><spring:message code='ezApprovalG.t268'/></span></label></a>
		        <%-- 2020-11-12 홍승비 - 대용량첨부기능 추가 --%>
		        <a class="imgbtn" id = "btn_BigAttachAddA" style="<c:if test='${isOuterForm eq true}'>display:none</c:if>"><label for="file1"><span id="btn_BigAttachAdd" onclick="isBigAttachButtonApr('Y')" style="cursor:pointer"><spring:message code='ezSystem.HSBAppr11'/></span></label></a>
		        <%-- 2020-11-17 홍승비 - 웹폴더첨부기능 추가 --%>
				<a class="imgbtn" style="display:none;"><span id="btn_WebFolderAttachAdd" onclick="isBigAttachButtonClick('N'); filePicker();" style="cursor:pointer"><spring:message code='ezSystem.HSBAppr12'/></span></a>
		        <a class="imgbtn"><span id="btn_AttachDel" onClick="return btn_AttachDel_onclick()"><spring:message code='ezApprovalG.t266'/></span></a>
				<%-- 2020-03-19 홍승비 - 첨부파일 위/아래 이동버튼 추가 --%>
		        <a class="imgbtn"><span id="btn_AttachMoveUp" onClick="return btn_AttachMoveUp_onclick()"><img src="/images/ImgIcon/prev.gif" alt="" style="vertical-align:middle;"></span></a>
		        <a class="imgbtn"><span id="btn_AttachMoveDown" onClick="return btn_AttachMoveDown_onclick()"><img src="/images/ImgIcon/next.gif" alt="" style="vertical-align:middle;"></span></a>
		        <a class="imgbtn"><span id="btn_AttachSaveSure" onClick="return btn_AttachSaveSure_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		    </div>
		    
			<input type="hidden" name="compid" id="compid" />
			<input type="hidden" name="docid" id="docid" />
			<input type="hidden" name="attachsn" id="attachsn" />
			<input type="hidden" name="maxsize" id="maxsize" />
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<%-- 2020-11-17 홍승비 - 웹폴더 첨부 레이어팝업을 위한 태그 추가--%>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel_sub">&nbsp;</div>	
		<div class="layerpopup"  style="z-index:2000; position:absolute; display:none; overflow:hidden;" id="iFramePanel_sub">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer_sub"></iframe>
		</div>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 1500; position: absolute;" id="loadingLayer">
	        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
	    </div>
	</body>
</html>
