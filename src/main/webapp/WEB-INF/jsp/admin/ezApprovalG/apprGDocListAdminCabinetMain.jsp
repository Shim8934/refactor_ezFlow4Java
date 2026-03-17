<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t901'/></title>
	    <style>
	        .IMG_BTN {
	            behavior: url("/css/include/ImgBtn.htc");a
	        }
	
	        .pagetd {
	            padding-top: 6px;
	        }
	
	        .pcol {
	            padding-top: 6px;
	        }
	
	        .Right_Point01 {
	            font: bold;
	            color: #017bec;
	        }
	        
	        #mainmenu.cabinetMenu {
	            display:  flex;
	        }
	        
	        #recordRight.selectUnderDept {
	            max-width: 350px;
	        }
	        
	    </style>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/previewmail.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezCabinet_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfoCB_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendOffer_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.js')}"></script>
		<!-- <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.min.css')}"> -->
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Common_Function.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/PreviewItem.js')}"></script>
		<script type="text/javascript" id="clientEventHandlersJS">
				var OrderOption = "";
		        var OrderCell = "";        
		        var g_sFlag = "<c:out value ='${sFlag}'/>";
		        var g_uFlag = "<c:out value ='${sFlag}'/>";
		        var labelcolor = "gray";
		        var xmlhttp = createXMLHttpRequest();
		        var xmldoc = createXmlDom();
		        var ContainerID, condition, DocID, jobState, pURL, FormID, DocDeptYN, SelDept, DelListYN, deptName;
		        var g_tagSelectsub = "1";
		        var NodeList, nowblock, totalPage, block, p_page, p_nowblock, Init_Flag, DocList_Flag, DocTitle, AdminYN;
		        var DeptAdminYN;
			    var contFlag = "<c:out value ='${contType}'/>";
		        var pSusinManagerFlag = "user";
		        var pChackYN, WriterID;
		        var docdir = "";
			    var pEndDocHref = "<c:out value ='${dirPath}'/>";
		        var szRoleInfo = "<c:out value = '${userInfo.rollInfo}' />";
		        var UserID = "<c:out value ='${userInfo.id}'/>";
		        var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
		        var spanElement = window.parent.frames.left.document.getElementById("selectDeptName");
                //var selDeptID = spanElement.getAttribute("dataDeptId");
		        var DeptID = spanElement.getAttribute("dataDeptId"); // "<c:out value ='${userInfo.deptID}'/>"
		        var deptName = "<c:out value ='${userInfo.deptName}'/>";
		        var PageSize, Block_Size, curpage, ListView, NodeList2, NodeListLen;
		        var arr_userinfo = new Array();
		        arr_userinfo[0] = "user";
			    arr_userinfo[0]  = "user";
			    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
			    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
			    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
			    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
			    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
			    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
			    arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
		        arr_userinfo[9] = CompanyID;
			    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
			    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
			    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
			    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
			    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
			    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
			    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
			    var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
		        var g_DeptInfo = "<c:out value ='${deptInfo}'/>";
			    var USE_OCS = "<c:out value ='${useOcs}'/>";
			    var Udomain = "<c:out value ='${userEmail}'/>";
		        var UserLang = "<c:out value ='${userInfo.lang}'/>";
		        var g_DeliveryXmlhttp = createXMLHttpRequest();
			    var pOpenYaer = "<c:out value ='${openYear}'/>";
		        var vWriterID;
		        var ext= "";
		        var useWebHWP = "<c:out value ='${useWebHWP}'/>";
				var WriterID = null;
				var WriterDeptID = null;
		        var shareDeptId = "${shareDeptId}";
		        var isCabinetToRecordFirst = true; // 기록물철등록부에서 기록물보기 메뉴로 최초 진입했는지 판단하기 위한 변수
				var selRowChangeFlag = false;

		        // 2023-05-23 이혜림 - 전자결재G > 기록물대장 미리보기 - 기록물 등록대장 미리보기에서 사용하는 변수를 추가
		        var cabinetPreviewItemFlagArr = ['m01', 'm03', 'm05', 'm06', 'm12', 'm13', 'm14', 'UNTREATED', 'docShare']; // 미리보기를 표시해야 할 리스트 플래그 모음 배열
		        var temp_g_sFlag = "";
		        var pMailListDiv = 0;
		  		var pMailPreVDiv = 0;
		 	   	var pMailListWidthH = 0;
		 	   	var pMailPreWidthH = 0;
			 	var pMailListDiv_H = 0;
		 	   	var pMailPreVDiv_H = 0;
		 	   	var CurrentHeight = 0;
		 	   	var CurrentWidth = 0;
		 	    var PreviewH_Move = false;

		        var pListTypeValue = "";
		        var pPreviewShow_HOW = "";
		        var previewInfo = "<c:out value = '${previewInfo}'/>";
			    var useAprPreview = "<c:out value = '${useAprPreview}'/>";
			    var approvalFlag = "<c:out value = '${approvalFlag}'/>";
		    	var share = "";
				var selectYear = "ALL";
		        var ezapralert_cross_dialogArguments = [];
				var underDeptList = JSON.parse('${underDeptList}'); // 2024-06-03 전인하 - 하위부서 리스트
				var underDeptFlag = "<c:out value='${underDeptFlag}'/>" // 2024-06-03 전인하 - 하위부서문서함 표출 여부 플래그 (TRUE/FALSE)
		        
				var useDraftAll = "${ useDraftAll }";
				var attachedDocList;

		        document.onselectstart = function () { return false; };
		
		        window.onload = function () {
		            var toDay = new Date();
		            var toDayYear = parseInt(toDay.getFullYear());
		            var minusYear = parseInt(toDay.getFullYear()) - parseInt(pOpenYaer);
		            for (var i = toDayYear; i >= toDayYear - minusYear ; i--) {
		                AddOption(rec_year, i, i);
		                AddOption(cab_year, i, i);
		                AddOption(del_year, i, i);
		            }
		
                    // 2023-05-23 이혜림 - 전자결재G > 기록물대장 미리보기 - 미리보기 영역 크기설정 관련 값 설정
                    CurrentHeight = document.documentElement.clientHeight;
                    CurrentWidth = document.documentElement.clientWidth;
		
		            if (navigator.userAgent.indexOf('Firefox') != -1) {
		                document.body.style.MozUserSelect = 'none';
		                document.body.style.WebkitUserSelect = 'none';
		                document.body.style.khtmlUserSelect = 'none';
		                document.body.style.oUserSelect = 'none';
		                document.body.style.UserSelect = 'none';
		            }
		            try {
		                DocList_Flag = "";
		                pChackYN = "FALSE";

		                PageSize = 10;
		                Block_Size = 10;

		                initUserRoleinfo();
		                DocDeptYN = IsDocDept(DeptID);
		                jobState = "APPROVAL";
		
		                LoadList();
		            }
		            catch (e) {
		                console.log(e);
		            }
		            
		            // 2023-06-15 전인하 - 전자결재G > 기록물대장 미리보기 - 온로드 시 미리보기 기능 관련 설정값 부여
                    if (useAprPreview == "YES" && previewInfo == "H") {
                        document.getElementById("PreviewRayerH").style.display = "";
		            }

                    if (cabinetPreviewItemFlagArr.includes(g_sFlag)) {
                        if (useAprPreview == "YES") {
                            if (pPreviewShow_HOW == "") {
                                if (previewInfo != null && previewInfo.trim() != "") {
                                    pPreviewShow_HOW = previewInfo;
                                } else {
                                    pPreviewShow_HOW = "OFF";
                                }
                            }
                        } else {
                            pPreviewShow_HOW = "OFF";
                        }
                    } else {
                        // 기록물대장 미리보기가 열린 상태에서 기록물 미리보기 안쓰는 페이지로 이동 시, 미리보기 레이어가 화면에 나타나는 것을 방지
                        document.getElementById("PreviewRayerH").style.display = "none";
                    }

                    // 2024-06-03 전인하 - 기록물대장 > 하위부서문서함 선택 드롭다운박스 생성
                    if (underDeptFlag === "TRUE") {
                        if (g_sFlag === "m02") {
                            var deptSelectBox = document.getElementById("rec_underDept2");
                        } else {
                            var deptSelectBox = document.getElementById("rec_underDept");
                        }
                        for (let i = 0; i < underDeptList.length; i++) {
                            if (underDeptList[i].id == DeptID) {
                                continue;
                            }
                            var newOption = document.createElement("option");
                            newOption.value = underDeptList[i].id;
                            newOption.text = underDeptList[i].name;
                            deptSelectBox.appendChild(newOption);
                        }
                    }
		            settingResize();
		            Window_resize();
		        };
		        
		        var isPeriodYear = true;
		        // 2023-05-23 이혜림 - g_sFlag에 대한 설명 주석 추가
		        function LoadList() {
		        	listLoading(true); //20201211 조진호 - 리스트 출력 시 시간이 오래 걸릴 수 있어 로딩바 추가
		        	
		            switch (g_sFlag) {
		                case "m01": // 기록물등록대장
		                    RecordList_onclick();
		                    break;
		                case "m02": // 기록물철등록부
						case "m15" :
		                	PageSize = 20;
		                    isPeriodYear = false;
		                    CabinetList_onclick();
		                    break;
		                case "m03": // 기록물배부대장
		                    idistbox_onclick();
		                    break;
		                case "m05": // 기록물접수목록
		                    ReceiptList_onclick();
		                    break;
		                case "m06": // 기록물발송목록
		                    SendList_onclick();
		                    break;
		                case "m07": // 종료연기신청
		                	PageSize = 20;
		                    isPeriodYear = false;
		                    DelayEndYRequest_onclick();
		                    break;
		                case "m08": // 정리대상목록
		                	PageSize = 20;
		                    isPeriodYear = false;
		                    ArrTargetList_onclick();
		                    break;
		                case "m09": // 인계목록
		                    isPeriodYear = false;
		                    CabGiveList_onclick();
		                    break;
		                case "m10":
		                    ToggleAdminMenu();
		                    break;
		                case "UNTREATED": // 미처리문서함
		                    untreatedList_onclick();
		                    break;
		                case "docShare": // 공유문서함
		      		        DeptID = shareDeptId;
		                    RecordList_onclick();
		                    break;
		                case "m12": // 대외접수목록
		                    OutReceiptList_onclick();
		                    break;
		                case "m13": // 대외발송목록
		                    OutSendList_onclick();
		                    break;
		                case "m14": // 대외배부대장
		                    idistbox_onclick();
		                    break;
		                default:
		                    RecordList_onclick();
		                    break;
		            }
		        }

				function checkRecordAll() {
					return (g_sFlag === "m12" || g_sFlag === "m13") && szRoleInfo.indexOf("i=1;") > -1 && DeptID === arr_userinfo[4];
				}
		
		        var SelYearFlag = false;
		        function onSelect_Year() {
		        	listLoading(true); //20201211 조진호 - 리스트 출력 시 시간이 오래 걸릴 수 있어 로딩바 추가
					curpage = 1;
		            SelYearFlag = true;

					switch (DocList_Flag) {
						case "CABINET" :
							selectYear = GetSelectVal("cab_year");
							break;
						case "RECORD" :
							selectYear = GetSelectVal("rec_year");
							break;
						default :
							selectYear = GetSelectVal("del_year");
							break;
					}

					if (document.getElementById("txt_keyword").value != "") {
						search();
						return;
					}

					var tempDeptID = DeptID;
					if (checkRecordAll()) {
						tempDeptID = "ALL";
					}
                    
					if (underDeptFlag === "TRUE") {
					    var deptSelectBox = g_sFlag === "m02" ? "rec_underDept2" : "rec_underDept";
                        if (GetSelectVal(deptSelectBox) != "default") {
                            tempDeptID = GetSelectVal(deptSelectBox);
                        }
                    }
                    

		            if (GetSelectVal("rec_year") != "ALL" || GetSelectVal("cab_year") != "ALL" || GetSelectVal("del_year") != "ALL") {
		
		                //hideProgress();
		                //showProgress();
		
		                if (DocList_Flag == "CABINET") {
							g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + selectYear + "</SPRODUCEY><EPRODUCEY>" + selectYear + "</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
		                    GetCaninetList();
		                }
		                else if (DocList_Flag == "RECORD") {
							g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + selectYear + "-01-01 00:00:00</SREGDATE><EREGDATE>" + selectYear + "-12-31 23:59:59</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
		                    GetRecordList();
		                }
		                else {
							g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + selectYear + "-01-01 00:00:00</SREGDATE><EREGDATE>" + selectYear + "-12-31 23:59:59</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";
		                    GetDocDeliveryList(g_DeliverySearchParamXml);
		                }
		            }
		            else {
		                g_RecSearchParamXml = "";
		                g_CabSearchParamXml = "";
		                g_DeliverySearchParamXml = "";
						selectYear = "ALL";
		
		                var nowyear = new Date().getFullYear();
		                var nowmonth = new Date().getMonth() + 1;
		                var nowday = new Date().getDate();
		
		                if (nowmonth < 10)
		                    nowmonth = "0" + nowmonth;
		
		                if (nowday < 10)
		                    nowday = "0" + nowday;
		
		                if (DocList_Flag == "CABINET") {
		                    if (isPeriodYear) {
		                        g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SPRODUCEY><EPRODUCEY>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
		                    } else if (underDeptFlag == "TRUE" && GetSelectVal(deptSelectBox) != "default") {
		                        g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY></SPRODUCEY><EPRODUCEY></EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";

		                    }
		                    GetCaninetList();
		                }
		                else if (DocList_Flag == "RECORD") {
		                    g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
		                    GetRecordList();
		                }
		                else {
		                    g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";
		                    GetDocDeliveryList(g_DeliverySearchParamXml);
		                }
		            }
		            
		            // 2024-06-03 전인하 - 기록물대장 > 하위부서문서함 선택시 메뉴 숨김 처리
		            if (g_sFlag == "m01" || g_sFlag == "m05" || g_sFlag == "m06") {
                        if (underDeptFlag == "TRUE" && GetSelectVal("rec_underDept") != "default") {
                            document.getElementById("trRecSubMenu").style.display = 'none';
                            document.getElementById("recordRight").classList.remove('selectUnderDept');
                        } else {
                            document.getElementById("trRecSubMenu").style.display = '';
                            document.getElementById("recordRight").classList.add('selectUnderDept');
                        }
		            } else if (g_sFlag == "m02") {
                        if (underDeptFlag === "TRUE" && GetSelectVal("rec_underDept2") != "default") {
                            document.getElementById("tdRegCabinet").style.display = 'none';
                            document.getElementById("tdNewVol").style.display = 'none';
                            document.getElementById("tdViewCabInfo").style.display = 'none';
                            document.getElementById("tdViewCabHist").style.display = 'none';
                            document.getElementById("tdModifyCab").style.display = 'none';
                            document.getElementById("tdDocListPrint").style.display = 'none';
                            document.getElementById("tdSetCharger").style.display = 'none';
                            document.getElementById("tdSearchCab").style.display = 'none';
                            document.getElementById("tdBtnCabDel").style.display = 'none';
                        } else {
                            document.getElementById("tdRegCabinet").style.display = 'none';
                            document.getElementById("tdViewCabInfo").style.display = '';
                            document.getElementById("tdViewCabHist").style.display = '';
                            document.getElementById("tdModifyCab").style.display = 'none';
                            document.getElementById("tdDocListPrint").style.display = '';
                            document.getElementById("tdSetCharger").style.display = 'none';
                            document.getElementById("tdSearchCab").style.display = '';
                            document.getElementById("tdBtnCabDel").style.display = '';
                        }
		            }
		            
		            //listLoading(false);	// 20201211 조진호 로딩바 display:none
		        }
		
		        function btnAddJob_onclick() {
		            var parameter = "";
		            var url = "../ezDocInfo/ezSubTitle_Cross.aspx?id=" + escape(UserID);
		            var feature = "status:no;dialogWidth:270px;dialogHeight:250px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(270, 250);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		
		            if (RtnVal[0] == "OK") {
		                arr_userinfo[4] = RtnVal[1];
		                arr_userinfo[5] = RtnVal[2];
		                arr_userinfo[3] = RtnVal[3];
		
		                arr_userinfo[13] = RtnVal[6];
		                arr_userinfo[14] = RtnVal[7];
		                arr_userinfo[15] = RtnVal[4];
		                arr_userinfo[16] = RtnVal[5];
		
		                DeptID = RtnVal[1];
		                ChangeCookies();
		
		                window.parent.frames.left.document.location.href = "/myoffice/ezApprovalG/left_approval_Cross.aspx?listType=1";
		                LoadList();
		            }
		        }
		        function ChangeCookies() {
		            $.ajax({
		        		type : "POST",
		        		async : false,
		        		url : "/ezApprovalG/ChangeUserInfo.do",
		        		data : {
		        				deptID : arr_userinfo[4],
		        				deptName  : arr_userinfo[5],
		        				deptName2 : arr_userinfo[14],
		        				position  : arr_userinfo[3],
		        				position2 : arr_userinfo[16],
		        				companyID : CompanyID,
		        				companyName : "${userInfo.companyName}",
		        				companyName2 : "${userInfo.companyName2}"
		        				},
		        		success: function(xml){
		        		}        			
		        	});
		        }
		        function lvtDetail_SelChange() {
		        }
		        function lvtDoclist_onclick() {
		        }
		        function lvtDoclist_onSel_DBclick() {
		            if (DocList_Flag == "CABINET") {
		                btnViewCabInfo_onclick();
		            }
		            else {
		                ViewDoc_onclick();
		            }
		        }
		        function lvtDetail_onclick() {
		        }
/*			    function lvtDetail_onSel_DBclick() {
			        var DocList = new ListView();
			        DocList.LoadFromID("SubDocList");
			        var selRow = DocList.GetSelectedRows();
			        var tr = selRow[0];
			        if (tr != null && typeof (selRow.length) != "undefined" && selRow.length > 0) {
			            if (jobState == "APPROVAL" || jobState == "CIRCUL") {
			                if (tr.getAttribute("DATA5") == "Y") {
			                    var heigth = window.screen.availHeight;
			                    var width = window.screen.availWidth;
			                    var left = (parseInt(width) - 1155) / 2;
			                    var top = (parseInt(heigth) - 460) / 2;
			                    window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA3") + "&deptID=" + encodeURI(tr.getAttribute("DATA4")) + "&docState=012", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			                } else {
			                	var heigth = window.screen.availHeight;
					            var width = window.screen.availWidth;
					            var left = (parseInt(width) - 600) / 2;
					            var top = (parseInt(heigth) - 450) / 2;
					            window.open("/ezCommon/showPersonInfo.do?id=" + GetAttribute(tr, "DATA4") + "&dept=" + GetAttribute(tr, "DATA6"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1, left=" + left + "px, top=" + top);
			                }
			            } else if (jobState == "RECIPENT") {
			                var heigth = window.screen.availHeight;
			                var width = window.screen.availWidth;
			                var left = (parseInt(width) - 540) / 2;
			                var top = (parseInt(heigth) - 220) / 2;
			
			                var isExtYN = tr.getAttribute("DATA3");
			                
			                if (isExtYN.toUpperCase() == "Y") {
			                	left = (parseInt(width) - 1155) / 2;
						        top = (parseInt(heigth) - 460) / 2;
			                    var url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + DocID + "&deptID=" + encodeURI(tr.getAttribute("DATA1"));
// 			                    var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
// 			                    feature = feature + GetShowModalPosition(555, 240);
// 			                    var ret = window.showModalDialog(url, "", feature);
			                    var ret = window.open(url, "", "height=460px,width=855px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			                } else {
			                	left = (parseInt(width) - 1155) / 2;
						        top = (parseInt(heigth) - 460) / 2;
			                    window.open("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + escape(tr.getAttribute("DATA1")) + "&docState=011" + "&aprState=" + escape(tr.getAttribute("DATA4")), "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			                }
			            } else if (jobState == "ATTACH") {
			            	var AttachfilenameA1 = tr.cells[1].innerHTML;
			            	
		                    if (AttachfilenameA1 != null) {
		                        var AttachfilenameN1 = AttachfilenameA1.lastIndexOf(".");
		                        var AttachfilenameA2 = AttachfilenameA1.substr(AttachfilenameN1, AttachfilenameA1.length);
		                        var AttachUrlA1 = GetAttribute(tr,"DATA1");
		                        var AttachUrlN1 = AttachUrlA1.lastIndexOf(".");
		                        var AttachUrlA2 = AttachUrlA1.substr(AttachUrlN1, AttachUrlA1.length);
		                        AttachUrl = encodeURIComponent(GetAttribute(tr,"DATA1"));
		                     
		                        if (AttachfilenameN1 < 0) {
		                            Attachfilename = encodeURIComponent(tr.cells[1].innerText + AttachUrlA2);
		                        } else {
		                        	if (AttachUrlA2 == ".mht") {
			                            Attachfilename = encodeURIComponent(tr.cells[1].innerText + AttachUrlA2);
		                        	} else {
			                            Attachfilename = encodeURIComponent(tr.cells[1].innerText);
		                        	}
		                        }

		                        if (AttachUrl != "null") {
//		                             if (GetAttribute(tr,"data4") == "file")
//		                                 window.open(document.location.protocol + "//" + document.location.hostname + "/approvalG/downloadAttach.do?type=APPROVAL&docID=" + GetAttribute(tr, "data3") + "&docStatus=" + tempINGFlag + "&docAttachSn=" + GetAttribute(tr,"data2"));
//		                             else
									//2018-09-12 천성준 - 전자결재 결재문서리스트 하단 첨부탭에서 첨부파일이 문서첨부일경우 문서보기로 열수있게
									try {
										if (GetAttribute(tr,"data4") == strLangCSJ01 || GetAttribute(tr,"data4") == "Document") {
		                                	var tempStr = AttachUrlA1.split("/");
		                                    var docID = tempStr[tempStr.length - 1].replace(AttachUrlA2, '');
		                                    var openLocation;
		                                    
		                                    if (AttachUrlA2.lastIndexOf(".ezd") === AttachUrlA2.length - 5) {
		                                    	docID = docID.substr(0, docID.lastIndexOf("."));
		                                    	AttachUrlA2 = "." + getOriginalFileExtension(AttachUrlA1)
		                                    }
		                                    
		                                    if (AttachUrlA2 == ".hwp") {
												if(useWebHWP == "NO") {
													if (isIE()) {
														openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
													} else {
														var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
														alert(pAlertContent);
														return;
													}
												} else {
													openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
												}
		                                    } else {
		                                    	openLocation = "/ezApprovalG/contDocView.do";
		                                    }
		                                    openLocation += "?docID=" + docID + "&docHref=" + AttachUrl + "&formID=&orgDocID=";
		                                    openwindow(openLocation, "", 880, 570);
										} else {
		                                    window.open("/ezApprovalG/downloadAttach.do?fileName=" + Attachfilename + "&filePath=" + AttachUrl, "_self");
		                                }
									} catch(e) {
										console.log(e);
									}
		                        }
		                    }
			            }
			        }
			    }*/
 		        function lvtDetail_onSel_DBclick() {
		            var DocList = new ListView();
		            DocList.LoadFromID("SubDocList");
		            var selRow = DocList.GetSelectedRows();
		            var tr = selRow[0];
		            if (tr != null && typeof (selRow.length) != "undefined" && selRow.length > 0) {
		                if (jobState == "ATTACH") {
		                    return;
		
		                    var para = "";
		                    var url = tr.getAttribute("DATA1");
		                    var feature;
		                    feature = window.open(url);
		
		                }
		                else if (jobState == "RECIPENT") {
		                	var heigth = window.screen.availHeight;
			                var width = window.screen.availWidth;
			                var left = (parseInt(width) - 540) / 2;
			                var top = (parseInt(heigth) - 220) / 2;
			
			                var isExtYN = tr.getAttribute("DATA3");
			                
			                if (isExtYN.toUpperCase() == "Y") {
			                	left = (parseInt(width) - 1155) / 2;
						        top = (parseInt(heigth) - 460) / 2;
			                    var url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + DocID + "&deptID=" + encodeURI(tr.getAttribute("DATA1"));
// 			                    var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
// 			                    feature = feature + GetShowModalPosition(555, 240);
// 			                    var ret = window.showModalDialog(url, "", feature);
			                    var ret = window.open(url, "", "height=300px,width=855px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			                } else {
			                	left = (parseInt(width) - 1155) / 2;
						        top = (parseInt(heigth) - 460) / 2;
			                    window.open("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + escape(tr.getAttribute("DATA1")) + "&docState=011" + "&aprState=" + escape(tr.getAttribute("DATA4")), "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			                }
// 		                    OpenReceiptHistory();
		                }
		                else if (jobState == "APPROVAL") {
		                    openUserInfo();
		                }
		            }
		        }
 		        
		    function idistbox_onclick() {
		        document.getElementById("imgTitle").innerHTML = g_sFlag === "m03" ? "<spring:message code='ezApprovalG.t911'/>" : "<spring:message code='ezApprovalG.kbh08'/>";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("0");
		
		        pChackYN == "FALSE";
		        DocList_Flag = "Delivery";
		        try {
		            if (trSubInfoTab) {
		                document.getElementById("trSubInfoTab").style.display = "";
		                document.getElementById("divList").style.height = "375px;";
		                //PageSize = 10;
		                Block_Size = 10;
		            }
		        } catch (e) { }
		            // 2024-06-13 전인하 - 전자결재G > 기록물배부대장/대외배부대장 > 리스트 정렬 변경 시 년도 소팅 초기화하지 않도록 검색조건 추가
                    if (GetSelectVal("del_year") != "ALL") {
                        var selectYear = GetSelectVal("del_year");
                        g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + selectYear + "-01-01 00:00:00</SREGDATE><EREGDATE>" + selectYear + "-12-31 23:59:59</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";               		            		                  
                    } else {
                        var nowyear = new Date().getFullYear();
                        var nowmonth = new Date().getMonth() + 1;
                        var nowday = new Date().getDate();
                
                        if (nowmonth < 10)
                            nowmonth = "0" + nowmonth;
                
                        if (nowday < 10)
                            nowday = "0" + nowday;
                        g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";
                    }
		        GetDocDeliveryList(g_DeliverySearchParamXml);
		    }
		    function ichange_onclick() {
		        SendOffer(UserID);
			}
			function ichangeS_onclick() {
		        var DocList = new ListView();
				DocList.LoadFromID("DocList");
				
				var selRows = DocList.GetSelectedRows();
		        if (selRows.length === 0) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		            alert(pAlertContent);
		            return;
				}

				var selRow = selRows[0];
				
				var docID = GetAttribute(selRow, "DATA1");
				var docHref = GetAttribute(selRow, "DATA2");
				var ext = docHref.substr(docHref.lastIndexOf(".") + 1);
				var recordID = GetAttribute(selRow, "DATA6");

                var url = null;
                if (ext === "mht") {
                    url = "/ezApprovalG/ezConvSihang.do" +
                        "?docID=" + encodeURIComponent(docID) +
                        "&docHref=" + encodeURIComponent(docHref) +
                        "&orgCompanyID=" + CompanyID +
                        "&recordID=" + recordID;
                } else if (ext === "hwp") {
                    if (useWebHWP === "NO") {
                        if (!isIE()) {
                            var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                            alert(pAlertContent);
                            return;
                        }

                        url = "/ezApprovalG/ezConvSihang_HWP.do" +
                            "?docID=" + encodeURIComponent(docID) +
                            "&docHref=" + encodeURIComponent(docHref) +
                            "&orgCompanyID=" + CompanyID +
                            "&recordID=" + recordID;
                    } else {
                        url = "/ezApprovalG/ezConvSihang_WHWP.do" +
                            "?docID=" + encodeURIComponent(docID) +
                            "&docHref=" + encodeURIComponent(docHref) +
                            "&orgCompanyID=" + CompanyID +
                            "&recordID=" + recordID;
                    }
                }
					
				window.open(url, "enforce", GetOpenWindowfeature(window.screen.availHeight - 50, window.screen.availWidth / 2));
			}
		    function Approval_onclick() {
		        jobState = "APPROVAL";
		        getDataInfo();
		    }
		    function Attach_onclick() {
		        jobState = "ATTACH";
		        getDataInfo();
		    }
		    function Recipent_onclick() {
		        jobState = "RECIPENT";
		        getDataInfo();
		    }
		    function Opinion_onclick() {
		        jobState = "OPINION";
		        getDataInfo();
		    }
		    function MM_swapImagesub(nSel, e) {
		        if (nSel != g_tagSelectsub) {
		            g_tagSelectsub = nSel;
		            var Event = e ? e : window.event;
		            var Element = Event.target ? Event.target : Event.srcElement;
		
		            Element.src = "/images/tab_appsub" + nSel + ".gif";
		//             Element.height = "23";
		
		            var i;
		            for (i = 1 ; i <= 4; i++) {
		                if (g_tagSelectsub != i) {
		                    var str = "tagsub" + i + ".src" + "=" + "\"/images/tab_appsub" + i + "a.gif\"";
		                    eval(str);
		//                     var str = "tagsub" + i + ".height" + "=" + "23";
		//                     eval(str);
		                }
		            }
		        }
		    }
		    function GetUserRole() {
		        if (AdminYN == "TRUE")
		            return "Admin";
		        else if (g_bRecAdmin)
		            return "DeptAdmin";
		        else
		            return "User";
		    }
		
		    function InitSubMenu(MenuType) {
		        if (g_sFlag == "m01")
		            document.getElementById("tdichange_Rec").style.display = "none";//"";//
		        else
		            document.getElementById("tdichange_Rec").style.display = "none";
		        switch (MenuType) {
					case "15" :
		            case "0":
		                document.getElementById("trCabSubMenu").style.display = "";
		                document.getElementById("trRecSubMenu").style.display = "none";
		                document.getElementById("recordRight").style.display = "none";
		
		                //document.getElementById("Radio2").style.display = "none";11
		                //document.getElementById("searchwriter").style.display = "none";
		                document.getElementById('rad2').style.display = "none";
		
		                if (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE") {
		                    if (ListTypeFlag != "8" && ListTypeFlag != "9" && ListTypeFlag != "10")
		                        document.getElementById("tdRegCabinet").style.display = "none";
		                    else
		                        document.getElementById("tdRegCabinet").style.display = "none";
		
		                    if (ListTypeFlag != "9")
		                        document.getElementById("tdNewVol").style.display = "none";
		                    else
		                        document.getElementById("tdNewVol").style.display = "none";
		                    
		                    // btnCabDel 업무관리자, 기록물관리자만 사용
		                    document.getElementById("tdBtnCabDel").style.display = "";
		                }
		                else {
		                    document.getElementById("tdRegCabinet").style.display = "none";
		                    document.getElementById("tdNewVol").style.display = "none";
		                }
		
		                if (ListTypeFlag != "9") {
		                    if (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE")
		                        document.getElementById("tdModifyCab").style.display = "none";
		                    else
		                        document.getElementById("tdModifyCab").style.display = "none";
		
		                    if (g_bRecAdmin || AdminYN == "TRUE") {
		                        document.getElementById("tdViewCabHist").style.display = "";
		                        document.getElementById("tdSetCharger").style.display = "none";
		                    }
		                    else {
		                        document.getElementById("tdViewCabHist").style.display = "none";
		                        document.getElementById("tdSetCharger").style.display = "none";
		                    }
		
		                    document.getElementById("tdbtnViewRecList").style.display = "";
// 		                    document.getElementById("tbar1").style.display = "";
		
		                }
		                else {
		                    document.getElementById("tdModifyCab").style.display = "none";
		                    document.getElementById("tdViewCabHist").style.display = "none";
		                    document.getElementById("tdSetCharger").style.display = "none";
		                    document.getElementById("tdbtnViewRecList").style.display = "none";
// 		                    document.getElementById("tbar1").style.display = "none";
		
		                }
		
		                if (ListTypeFlag == "8" && (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE") && g_sFlag != "m09") {
		                	//2018-12-21 천성준 정리대상목록에 데이터가 없을 때, 편철확인 편철확인취소 버튼이 표출되는 현상 때문에 주석처리 (버튼의 표출여부는 리스트 데이터가 무엇이 선택 되었는지에 따라 표출됨.)
// 		                    document.getElementById("tdbtnEndProduce").style.display = "";
// 		                    document.getElementById("tdbtnCancelEndProd").style.display = "";
		                }
		                else {
		                    document.getElementById("tdbtnEndProduce").style.display = "none";
		                    document.getElementById("tdbtnCancelEndProd").style.display = "none";
		                }
		
		                if (ListTypeFlag == "10" && (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE")) {
		                    document.getElementById("tdReqDelayEndY").style.display = "";
		                    document.getElementById("CancelDelayEndY").style.display = "";
		                }
		                else {
		                    document.getElementById("tdReqDelayEndY").style.display = "none";
		                    document.getElementById("CancelDelayEndY").style.display = "none";
		                }

						if (ListTypeFlag === "15") {
							document.getElementById("tdModifyCab").style.display = "none";		// 수정 버튼
							document.getElementById("tdSetCharger").style.display = "none";		// 업무담당자지정 버튼
							document.getElementById("tdBtnCabDel").style.display = "none";		// 삭제 버튼
							document.getElementById("tdbtnViewRecList").style.display = "none";	// 기록물보기 버튼
						}

		                break;
		
		            case "1":
		                document.getElementById("trCabSubMenu").style.display = "none";
		                document.getElementById("trRecSubMenu").style.display = "";
		                document.getElementById("recordRight").style.display = "";
		
		
		                if (g_bRecAdmin || AdminYN == "TRUE")
		                    document.getElementById("tdRegRecord").style.display = "none";
		                else
		                    document.getElementById("tdRegRecord").style.display = "none";
		
		                if (ListTypeFlag == "0")
		                    document.getElementById("tdCabSelect").style.display = "none";
		                else
		                    document.getElementById("tdCabSelect").style.display = "none";
		
		                if (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE") {
		                    document.getElementById("tdMoveRec").style.display = "none";
		                    document.getElementById("tdRegSepAtt").style.display = "none";
		                    
		                    // btnCabDel 업무관리자, 기록물관리자만 사용
		                    document.getElementById("tdBtnCabDel").style.display = "";		                    
		                }
		                else {
		                    document.getElementById("tdMoveRec").style.display = "none";
		                    document.getElementById("tdRegSepAtt").style.display = "none";
		                }
		
		                if (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE")
		                    document.getElementById("tdModifyRec").style.display = "none";
		                else
		                    document.getElementById("tdModifyRec").style.display = "";
		
		                if (g_bRecAdmin) {
		                    document.getElementById("tdVeiwRecHist").style.display = "";
		                    document.getElementById("tdbtnViewRecReadHist").style.display = "";
							document.getElementById("tdbtnSetRecRole").style.display = "none";
		                    CheckBtnSetRecRole();
		                } else {
		                    document.getElementById("tdVeiwRecHist").style.display = "none";
		                    document.getElementById("tdbtnViewRecReadHist").style.display = "none";
		                    document.getElementById("tdbtnSetRecRole").style.display = "none";
		                }
		                break;
		        }

				if (g_sFlag !== "m01" && g_sFlag !== "m05" && g_sFlag !== "m06") {
					document.getElementById("tdAttachedDraft").style.display = "none";
				}
		    }
		
		    function CheckBtnSetRecRole() {
				// #125383 전자결재G > 업무담당자 > 대장등록과 열람권한 설정 가능
				// 기록물 관리 책임자 외에 관리자, 작성자, 업무담당자등 버튼 감추라고 하여 변경함.

				if (g_bRecAdmin) {
					document.getElementById("tdbtnSetRecRole").style.display = "none";
				} else {
					document.getElementById("tdbtnSetRecRole").style.display = "none";
				}

		        /*if (g_bRecAdmin || AdminYN == "TRUE") {
		            if (AdminYN != "TRUE") {
		                var tmpAuthChk = false;
		                var tmpChkDeptID = DeptID;
		
		                if (g_RecSearchParamXml != "") {
		                    var tmpXMLDOM = createXmlDom();
		                    tmpXMLDOM = loadXMLString(g_RecSearchParamXml);
		                    var deptcdoenode = SelectSingleNodeNew(tmpXMLDOM, "SEARCHPARAM/DEPTCODE");
		                    if (deptcdoenode.length > 0)
		                        tmpChkDeptID = getNodeText(deptcdoenode);
		                }

		                if ("<c:out value = '${userInfo.deptID}'/>" == tmpChkDeptID) 
		                    tmpAuthChk = true;
		
		                if (g_DeptInfo != "") {
		                    var tmpArrDeptInfo = g_DeptInfo.split(";");
		
		                    for (var n = 0 ; n < tmpArrDeptInfo.length ; n++) {
		                        if (tmpArrDeptInfo[n].split(":")[0] == tmpChkDeptID)
		                            tmpAuthChk = true;
		                    }
		                }
		
		                if (tmpAuthChk)
		                    document.getElementById("tdbtnSetRecRole").style.display = "";
		                else
		                    document.getElementById("tdbtnSetRecRole").style.display = "none";
		            }
		            else {
		                document.getElementById("tdbtnSetRecRole").style.display = "";
		            }
		        }
		        else {
		            document.getElementById("tdbtnSetRecRole").style.display = "none";
		        }*/
		    }
		    function SwapSubMenuDisplay(flag) {
		        if (flag == "0") {
		            document.getElementById("trCabSubMenu").style.display = "none";
		            document.getElementById("trRecSubMenu").style.display = "none";
		            document.getElementById("recordRight").style.display = "none"
		            document.getElementById("trDeliveryMenu").style.display = "";
		        }
		    }
		    function ArrTargetList_onclick() {
		        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t908'/>";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("1");
		
		        InitGlobals("CABINET", "8", "0");
		        if (g_bRecAdmin || AdminYN == "TRUE") {
		        }
		        else {
		            g_CabSearchParamXml = "<SEARCHPARAM><CHARGER>'" + UserID + "'</CHARGER></SEARCHPARAM>";
		        }
		        GetCaninetList();
		    }
		    function DelayEndYRequest_onclick() {
		        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t907'/>";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("1");
		
		        InitGlobals("CABINET", "10", "0");
		
		        GetCaninetList();
		    }
		    function CabGiveList_onclick() {
		        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t909'/>";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("1");
		
		        InitGlobals("CABINET", "9", "0");
		
		        GetCaninetList();
		    }
		    function CabinetList_onclick() {
				var listType = g_sFlag === "m02" ? "0" : "15";
				var menuType = listType;
				var imgTitle = g_sFlag === "m02" ? "<spring:message code = "ezApprovalG.t912" />" : "<spring:message code = "ezApprovalG.listOfDeletedIron" />";

		        document.getElementById("imgTitle").innerHTML = imgTitle;
		        document.getElementById("imgTitle").style.display = "";
		
		        SwapSubMenuDisplay("1");

				InitGlobals("CABINET", listType, menuType);
		
		        GetCaninetList();
			}
			function untreatedList_onclick() {
		        document.getElementById("imgTitle").innerHTML = "미처리문서함";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("1");
		        InitGlobals("RECORD", "23", "1");
		        GetRecordList();
			}
		
		    var regcabinet_cross_dialogArguments = new Array();
		    function btnRegCabinet_onclick() {
		        var para = new Array();
		        para[0] = "0";
		        var url = "/ezApprovalG/regCabinet.do";
		
		        regcabinet_cross_dialogArguments[0] = para;
		        regcabinet_cross_dialogArguments[1] = btnRegCabinet_onclick_Complete;
		
		        var OpenWin;
		
		        if (UserLang == "1")
		            OpenWin = window.open(url, "RegCabinet_Cross", GetOpenWindowfeature(900, 445));
		        else
		            OpenWin = window.open(url, "RegCabinet_Cross", GetOpenWindowfeature(905, 435));
		
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function btnRegCabinet_onclick_Complete(rtn) {
		        if (rtn[0] == "TRUE")
		            GetCaninetList();
		    }
		    function btnNewVolume_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selnode = DocList.GetSelectedRows();
		
		        if (selnode.length != 0) {
		            var tr = selnode[0];
		            var rtn = NewVolume(tr.getAttribute("DATA1"), tr.getAttribute("DATA2"), "OPEN", btnNewVolume_onclick_Complete);
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t913'/>");
		        }
		    }
		
		    function btnNewVolume_onclick_Complete(rtn) {
		        if (rtn[0] != "FALSE") {
		            AddNewVolume(temppCabClassNo, rtn[1]);
		            GetCaninetList();
		        }
		    }
		    var changecabinetinfo_cross_dialogArguments = new Array();
		    function btnChangeCabinetInfo_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var para = new Array();
		            para[0] = tr.getAttribute("DATA1");
		            para[1] = tr.getAttribute("DATA2");
		            para[2] = arr_userinfo[1];
		            para[3] = arr_userinfo[2];
		            para[4] = g_bRecAdmin;
		            para[5] = arr_userinfo[10];
		            var url = "/ezApprovalG/changeCabinetInfo.do";
		
		            changecabinetinfo_cross_dialogArguments[0] = para;
		            changecabinetinfo_cross_dialogArguments[1] = btnChangeCabinetInfo_onclick_Complete;
		
		            var popupHeight = 390;
		            var popupWidth = 405;
		            
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            
		            var pTop = (pheight - popupHeight) / 2;
		            var pLeft = (pwidth - popupWidth) / 2;
		            
		            var dualScreenTop = window.screenY;
		            var dualScreenLeft = window.screenX;

		            pTop += dualScreenTop;
		            pLeft += dualScreenLeft;
		            
		            var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + popupHeight + ",width=" + popupWidth + ",top=" + pTop + ",left=" + pLeft;

		            var OpenWin = window.open(url, "ChangeCabinetInfo_Cross", feature, "");
		            try { OpenWin.focus(); } catch (e) { }		           
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
		        }
		    }
		    function btnChangeCabinetInfo_onclick_Complete(rtn) {
		        if (rtn[0] == "TRUE") {
		            GetCaninetList();
		        }
		    }
		    var settaskchrger_cross_dialogArguments = new Array();
		    function btnSetTaskCharger_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var para = new Array();
		            para[0] = tr.getAttribute("DATA2");
		            para[1] = DeptID;
		
		            var url = "/ezApprovalG/setTaskChrger.do";
		
		            settaskchrger_cross_dialogArguments[0] = para;
		
		            var OpenWin = window.open(url, "SetTaskChrger_Cross", GetOpenWindowfeature(790, 490));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
		        }
		    }
		    function ReqDelayEndY_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        var len = selRow.length;
		        var i;
		
		        if (len > 0) {
		            var CabClassList = "";
		            for (i = 0; i < len; i++) {
		                if (CabClassList != "")
		                    CabClassList += ",";
		
		                var tr = selRow[i];
		                CabClassList += tr.getAttribute("DATA2");
		            }
		
		            if (ReqDelayCabEndY(CabClassList, "Y") == "TRUE") {
		                OpenAlertUI("<spring:message code='ezApprovalG.t914'/>");
		                DelayEndYRequest_onclick();
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t915'/>");
		            }
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t916'/>");
		        }
		    }
		    function CancelDelayEndY_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        var len = selRow.length;
		        var i;
		
		        if (len > 0) {
		            var CabClassList = "";
		            for (i = 0; i < len; i++) {
		                if (CabClassList != "")
		                    CabClassList += ",";
		
		                var tr = selRow[i];
		                CabClassList += tr.getAttribute("DATA2");
		            }
		            if (ReqDelayCabEndY(CabClassList, "N") == "TRUE")
		                DelayEndYRequest_onclick();
		            else
		                OpenAlertUI("<spring:message code='ezApprovalG.t917'/>");
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t916'/>");
		        }
		    }
		    function ReqDelayCabEndY(CabClassList, Flag) {
		    	var result = "";
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/reqDelayCabEndY.do",
		    		data : {
		    				companyID : CompanyID,
		    				cabClassList  : CabClassList,
		    				flag : Flag
		    				},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}, error:function () {
		    			return "FALSE";
		    		}  			
		    	});
		        
		        var dataNodes = GetChildNodes(result);
		        return getNodeText(dataNodes[0]);
		    }
		    
		    var endcabproduce_cross_dialogArguments = new Array();
		    function btnEndProduce_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var para = new Array();
		            para[0] = tr.getAttribute("DATA1");
		            para[1] = tr.getAttribute("DATA2");
		
		            var url = "/ezApprovalG/endCabProduce.do";
		
		            endcabproduce_cross_dialogArguments[0] = para;
		            endcabproduce_cross_dialogArguments[1] = btnEndProduce_onclick_Complete;
		
		            var OpenWin = window.open(url, "EndCabProduce_Cross", GetOpenWindowfeature(400, 280));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
		        }
		    }
		    function btnEndProduce_onclick_Complete(rtn) {
		        if (rtn[0] == "TRUE") {
		            GetCaninetList();
		        }
		    }
		    function btnCancelEndProd_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            bCon = OpenInformationUI("<spring:message code='ezApprovalG.t918'/>", btnCancelEndProd_onclick_Complete);
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
		        }
		    }
		    function btnCancelEndProd_onclick_Complete(bCon) {
		        if (bCon) {
		            var DocList = new ListView();
		            DocList.LoadFromID("DocList");
		            var selRow = DocList.GetSelectedRows();
		            var tr = selRow[0];
		
		            if (EndCabProduce(tr.getAttribute("DATA2"), "", "1")) {
		                GetCaninetList();
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t919'/>");
		            }
		        }
		    }
		    function btnViewRecList_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        
		        /* 2022-07-20 홍승비 - 기록물보기 버튼 클릭 시, 이전 기록물의 검색조건이 남아있는 오류 수정 (검색조건 초기화) */
				g_RecSearchParamXml = "";
				isCabinetToRecordFirst = true; // 최초 진입 플래그 true로 변경
		        
		        if (selRow.length != 0) {
		        	SwapSubMenuDisplay("1");
			        InitGlobals("RECORD", "0", "1");
			            
		        	g_SelCabXml = "<CABINETINFO><CABINET>";
		        	
		        	/* 2022-07-22 홍승비 - 선택한 기록물철의 생산년도를 체크 */
		        	if (typeof(isCabinetToRecordFirst) != "undefined" && isCabinetToRecordFirst == true && typeof(g_sFlag) != "undefined" && g_sFlag == "m02") {
			        	var cabinetClassNo = selRow[0].getAttribute("DATA2");
			        	cabProduceY = getProduceYear(cabinetClassNo); // 전역변수인 cabProduceY에 생산년도를 저장
		        	}
		        	
		        	for(var i = 0; i < selRow.length; i++) {
		        		g_SelCabXml += "<CABINETID><![CDATA[" + selRow[i].getAttribute("DATA1") + "]]></CABINETID>";
		        	}
		        	
		        	g_SelCabXml += "</CABINET></CABINETINFO>";
		            
		            GetRecordList();
		            $("#tdViewCabList").show();
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
		        }
		    }
		
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		
		        if (CrossYN()) {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        return RtnVal;
		    }
		
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		
		    function RecordList_onclick() {
		        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t552'/>";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("1");
		        InitGlobals("RECORD", "0", "1");
		        GetRecordList();
		    }
		        function btnRegRecord_onclick() {
		            var para = new Array();
		            para[0] = g_SelCabXml;
		            para[1] = ListTypeFlag;
		
		            if (CrossYN()) {
		                var url = "/ezApprovalG/regRecord.do?SelCabXml=" + g_SelCabXml + "&TypeFlag=" + ListTypeFlag;
		
		                var wWeight = "";
		                var wHeight = "";
		
		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;
		
		                var left = "";
		                var top = "";
		
		                if ("${userInfo.lang}" == "1") { 
			                wWeight = 1015;
			                wHeight = 690;
			                left = (width - wWeight) / 2;
			                top = (heigth - wHeight) / 2;
		                } else { 
			                wWeight = 1015;
			                wHeight = 690;
			                left = (width - wWeight) / 2;
			                top = (heigth - wHeight) / 2;
		                } 
		                if (url != "")
		                    var ret = window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    GetRecordList();
		            }
		            else {
		                var url = "/ezApprovalG/regRecord.do";
		
		                if ("${userInfo.lang}" == "1")
		              { 
		                var feature = "dialogWidth:755px;dialogHeight:570px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
		                }
		              else
		              { 
		                var feature = "dialogWidth:825px;dialogHeight:570px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
		                } 
		                if (url != "")
		                    var rtn = window.showModalDialog(url, para, feature);
		
		                if (rtn[0] == "TRUE") {
		                   GetRecordList();
		                }
		            }
		        }
		    var regsepattach_cross_dialogArguments = new Array();
		    function btnRegAttach_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var para = new Array();
		            para[0] = "0";
		            para[1] = tr.getAttribute("DATA6");
		            para[2] = tr.getAttribute("DATA7");
		            para[3] = "";
		
		            var url = "/ezApprovalG/regSepAttach.do";
		
		            regsepattach_cross_dialogArguments[0] = para;
		            regsepattach_cross_dialogArguments[1] = btnRegAttach_onclick_Complete;
		
		            var OpenWin = window.open(url, "schedule_select_attendant", GetOpenWindowfeature(880, 615));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		    }
		
		    function btnRegAttach_onclick_Complete(rtn) {
		        if (rtn[0] == "TRUE") {
		            GetRecordList();
		        }
		    }
		
		    var selectcabinet_cross_dialogArguments = new Array();
		    function CabinetSelect_onclick() {
		        DocList_Flag = "RECORD";
		
		        var para = new Array();
		        var rtn;
		        var url = "/ezApprovalG/selectCabinet.do?initFlag=0";
		
		        selectcabinet_cross_dialogArguments[0] = para;
		        selectcabinet_cross_dialogArguments[1] = CabinetSelect_onclick_Complete;
		
		        var OpenWin = window.open(url, "selectCabinet", GetOpenWindowfeature(1000, 620));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		
		    function CabinetSelect_onclick_Complete(rtn) {
		        if (rtn[0] == "TRUE") {
		            curpage = "1";
		            g_SelCabXml = rtn[1];
		            g_TransFlag = rtn[2];
		            GetRecordList();
		        }
		    }
		
		    function btnChangeRecCabinet_onclick() {
		        var rtn = new Array();
		        rtn[0] = "FALSE";
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var RecID = tr.getAttribute("DATA6");
		            var CabID = tr.getAttribute("DATA7");
		            var SepAttNo = tr.getAttribute("DATA8");
		
		            var para = new Array();
		            var url = "/ezApprovalG/selectCabinet.do?initFlag=1";
		
		            selectcabinet_cross_dialogArguments[0] = para;
		            selectcabinet_cross_dialogArguments[1] = btnChangeRecCabinet_onclick_Complete;
		
		            var OpenWin = window.open(url, "SelectCabinet_Cross", GetOpenWindowfeature(1000, 620));
		            try { OpenWin.focus(); } catch (e) { }
		
		           
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
		        }
		    }
		    var temparrCabInfo;
		    function btnChangeRecCabinet_onclick_Complete(rtn) {
		        if (rtn[0] == "TRUE") {
		            var arrCabInfo = GetSelCabInfo(rtn[1], 0);
		            temparrCabInfo = arrCabInfo;
		           OpenInformationUI("<spring:message code='ezApprovalG.t927'/>" + arrCabInfo[1] + "(" + arrCabInfo[4] + "<spring:message code='ezApprovalG.t923'/>" + "<spring:message code='ezApprovalG.t924'/>", ChangeRecCabinetOpenUI);
		        }
		    }
		
		    function ChangeRecCabinetOpenUI(bConfirm) {
		        if (bConfirm) {
		            var DocList = new ListView();
		            DocList.LoadFromID("DocList");
		            var selRow = DocList.GetSelectedRows();
		            var tr = selRow[0];
		            var RecID = tr.getAttribute("DATA6");
		            var CabID = tr.getAttribute("DATA7");
		            var SepAttNo = tr.getAttribute("DATA8");
		
		            if (MoveRecord(RecID, SepAttNo, temparrCabInfo[0], "0")) {
		                OpenAlertUI("<spring:message code='ezApprovalG.t925'/>");
		                GetRecordList();
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t926'/>");
		            }
		        }
		    }
		
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";

		        if (CrossYN()) {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            
		            ezapropinion_cross_dialogArguments[2] = true;
		            var OpenWin = window.open(url, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var feature = "status:no;dialogWidth:350px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(350, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        return RtnVal;
		    }
		
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		
		    function GetSelCabInfo(pCabListXml, idx) {
		        var len;
		        var rtnArr = new Array();
		        if (pCabListXml != "") {
		            var CabListXml = createXmlDom();
		            CabListXml = loadXMLString(pCabListXml);
		
		            var objCabs = SelectNodes(CabListXml, "CABINET");
		            len = objCabs.length;
		
		            if (idx < len) {
		                rtnArr[0] = getNodeText(SelectNodes(CabListXml, "CABINETID")[idx]);
		                rtnArr[1] = getNodeText(SelectNodes(CabListXml, "CABINETNAME")[idx]);
		                rtnArr[2] = getNodeText(SelectNodes(CabListXml, "RECTYPE")[idx]);
		                rtnArr[3] = getNodeText(SelectNodes(CabListXml, "CABINETSN")[idx]);
		                rtnArr[4] = getNodeText(SelectNodes(CabListXml, "CABINETVOLNO")[idx]);
		            }
		        }
		        return rtnArr;
		    }
		    var changerecordinfo_cross_dialogArguments = new Array();
		    function btnChangeRecInfo_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var para = new Array();
		            para[0] = tr.getAttribute("DATA6");
		            para[1] = tr.getAttribute("DATA8");
		            para[2] = arr_userinfo[1];
		            para[3] = arr_userinfo[2];
		            para[4] = g_bRecAdmin;
		
		            var url = "/ezApprovalG/changeRecordInfo.do";
		
		            changerecordinfo_cross_dialogArguments[0] = para;
		            changerecordinfo_cross_dialogArguments[1] = btnChangeRecInfo_onclick_Complete;
		
		            var OpenWin = window.open(url, "ChangeRecordInfo_Cross", GetOpenWindowfeature(445, 510));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
		        }
		    }
		
		    function btnChangeRecInfo_onclick_Complete(rtn) {
		        if (rtn[0] == "TRUE") {
		            GetRecordList();
		        }
		    }
		    var viewrecreadhistory_cross_dialogArguments = new Array();
		    function btnViewRecReadHist_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var para = new Array();
		            para[0] = tr.getAttribute("DATA1");
		
		            var url = "/ezApprovalG/viewRecReadHistory.do";
		
		            viewrecreadhistory_cross_dialogArguments[0] = para;
		
		            var OpenWin = window.open(url, "ViewRecReadHistory_Cross", GetOpenWindowfeature(615, 450));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
		        }
		    }
		
		    //START
		    var SendCard_Cross_dialogArguments = new Array();
		    function btnCardSend_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var para = new Array();
		            para[0] = tr.getAttribute("DATA6");
		            para[1] = tr.getAttribute("DATA8");
		            para[2] = DeptID;
		
		            var url = "/myoffice/ezApprovalG/ezCabinet/SendCard_Cross.aspx";
		            SendCard_Cross_dialogArguments[0] = para;
		            SendCard_Cross_dialogArguments[1] = SendCard_Cross_Complete;
		
		            var feature = "dialogWidth:400px;dialogHeight:178px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
		
		            var OpenWin = window.open(url, "SendCard_Cross", GetOpenWindowfeature(400, 400));
		            try { OpenWin.focus(); } catch (e) { }
		
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
		        }
		    }
		
		    function SendCard_Cross_Complete(Rtn)
		    {
		        if (Rtn[0] == "TRUE") {
		            GetRecordList();
		        }
		    }
		    //END
		
		    function ReceiptList_onclick() {
		        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t905'/>";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("1");
		
		        InitGlobals("RECORD", "10", "1");
		        GetRecordList();
		    }
			function SendList_onclick() {
				document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t906'/>";
				document.getElementById("imgTitle").style.display = "";
				SwapSubMenuDisplay("1");
				InitGlobals("RECORD", "11", "1");
				GetRecordList();
			}
		    function OutReceiptList_onclick() {
		        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.kbh06'/>";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("1");
		
		        InitGlobals("RECORD", "12", "1");
		        GetRecordList();
		    }
		    function OutSendList_onclick() {
		        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.kbh07'/>";
		        document.getElementById("imgTitle").style.display = "";
		        SwapSubMenuDisplay("1");
		        InitGlobals("RECORD", "13", "1");
		        GetRecordList();
		    }
		    window.onunload = function () {
		    };
		    function GongRamDocInfo() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var tr = selRow[0];
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = (parseInt(width) - 1155) / 2;
		            var top = (parseInt(heigth) - 460) / 2;
		            window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA1") + "&pDeptID=&docState=015", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        }
		        else {
                    OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
                }
		    }
		    var aprgongramline_cross_dialogArguments = new Array();
		    function btnSendAround_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length != 0) {
		            var para = new Array();
		            para[0] = DocID;
		            var url = "/ezApprovalG/aprGongRamLine.do?type=END";
		
		            aprgongramline_cross_dialogArguments[0] = para;
		            aprgongramline_cross_dialogArguments[1] = btnSendAround_onclick_Complete;
		
		            var OpenWin = window.open(url, "AprGongRamLine_Cross", GetOpenWindowfeature(1200, 780));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
                    OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
                }
		    }
		
		    function btnSendAround_onclick_Complete(rtn) {
		        if (rtn == "OK") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1424'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		
		    // START
		    var ezSelectSusin_Cross_dialogArguments = new Array();
		    function btnReSend_onclick() {
		        if (UserID.toLowerCase() != WriterID.toLowerCase()) {
		            var InformationString = "<spring:message code='ezApprovalG.t928'/>";
		            OpenAlertUI(InformationString);
		            return;
		        }
		        if (CheckFormConnFlag(DocID)) {
		            var InformationString = "<spring:message code='ezApprovalG.t929'/>";
		            OpenAlertUI(InformationString);
		            return;
		        }
		        var parameter = new Array();
		        parameter[0] = DocID;
		        parameter[1] = "";
		
		        ezSelectSusin_Cross_dialogArguments[0] = parameter;
		        ezSelectSusin_Cross_dialogArguments[1] = btnReSend_onclick_Complete;
		
		        var url = "/ezApprovalG/ezSelectSusin.do";
		        
		        var OpenWin = window.open(url, "ezSelectSusin_Cross", GetOpenWindowfeature(750, 650));
		        try { OpenWin.focus(); } catch (e) { }
		
		       
		    }
		    function btnReSend_onclick_Complete(rtn)
		    {
		        if (rtn[0] != "CANCEL") {
		            var xmlhttp = createXMLHttpRequest();
		            xmlhttp.open("POST", "/ezApprovalG/resendEndDoc.do", false);
		            xmlhttp.send(rtn[1]);
		        }
		    	if (xmlhttp.status == 200) {
		    		OpenAlertUI("<spring:message code='ezApproval.t157'/> <spring:message code='ezApproval.t854'/>");		    		
		    		return;
		    	} else {
		    		alert(strLang223);
		    	}
		    }
		    // END
		
		    var ezreceivedistributeui_cross_dialogArguments = new Array();
		    function btnBaeBu_onclick() {
		    	var DocList = new ListView();
				DocList.LoadFromID("DocList");
				
				var selRows = DocList.GetSelectedRows();
		        if (selRows.length === 0) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		            alert(pAlertContent);
		            return;
				}

				var selRow = selRows[0];
				
				var DocID = GetAttribute(selRow, "DATA1");
		        if (DocID == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t99991'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "DOCID", DocID);
		
		        xmlhttp.open("POST", "/ezApprovalG/getCheckEndHref.do", false);
		        xmlhttp.send(xmlpara);
		
		        if (SelectSingleNodeValue(xmlhttp.responseXML, "RESULT") == "TRUE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.pjj06'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        var parameter = new Array();
		        parameter[0] = DocID;
		        parameter[1] = "1";
		        parameter[2] = arr_userinfo[4];
		        parameter[3] = "011";
		        parameter[4] = arr_userinfo[4];
		
		        var url = "/ezApprovalG/ezReceiveDistributeUI.do?mode=add&pdocid=" + DocID;
		
		        ezreceivedistributeui_cross_dialogArguments[0] = parameter;
		        ezreceivedistributeui_cross_dialogArguments[1] = btnBaeBu_onclick_Complete;
		
		        var OpenWin = window.open(url, "ezReceiveDistributeUI_Cross", GetOpenWindowfeature(800, 600));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		
		    function btnBaeBu_onclick_Complete(ret) {
		        if (ret == "true") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1419'/>";
		            OpenAlertUI(pAlertContent);
		        }
		        idistbox_onclick();
		    }
		
	    var pSaveDocIDlist = []; // 통합PC저장할 문서docID를 담는 전역변수
	    var havingReadRightRows =[]; // 문서 열람권한이 있는 rows
	    var noRight = false; // 열람권한이 없는 문서가 하나라도 존재하면 noRight = true
	    var failDocNums = "";
	    var failDocCount = 0;
	    var secDocRows = []; // 보안결재 설정한 문서들의 rows (결재선 포함 여부 확인에 필요함.)
	    var secDocIDsInAprLine =[]; // 보안결재 포함 문서 docID 배열
		var sepaAttSet = null; // 분리첨부 제외 문서번호 집합
	    function TotalSave_onclick() {
		    	noRight = false;
		    	pSaveDocIDlist = [];
		    	secDocIDsInAprLine = [];
		    	secDocRows = [];
		    	failDocNums = "";
				failDocCount = 0;
				sepaAttSet = new Set();
		    	
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");

		        var selRows = DocList.GetSelectedRows();
		        
		        if (selRows.length == 0) {
		            OpenAlertUI("<spring:message code='ezApprovalG.t113'/>");
		        }
		        // 단일 문서 저장 시엔 팝업창 띄워서 다운로드할 파일 선택. (단일 다운로드 시 hwp파일 배포문서 전환 대응)
		        else if (selRows.length == 1) {
		        	
	        		if (DocList_Flag == "RECORD") {
		                if (AdminYN != "TRUE" && (!g_bRecAdmin)) {
		                    if (!HasRecReadRight(trim_Cross(selRows[0].getAttribute("DATA6")), trim_Cross(selRows[0].getAttribute("DATA8")), UserID)) {
		                        OpenAlertUI(strLang580);
		                        return "";
		                    }
		                }
		                if (selRows[0].getAttribute("DATA8") != "00") {
		                    OpenAlertUI(strLang260);
		                    return "";
		                }
		            }
		            
			        /* 2021-10-21 홍승비 - 결재완료문서 통합 PC 저장 시 보안결재 확인동작 추가 */
					if (selRows[0].getAttribute("DATA14") != "" && selRows[0].getAttribute("DATA14") >= GetTodayDate()) {
			            if (CheckAprLine(selRows[0].getAttribute("DATA1")) == "TRUE") {
			            	secDocIDsInAprLine.push(selRows[0].getAttribute("DATA1"));
			            	chk_Passwd(UserID, chk_Passwd_CompleteSave);
			            	
			            } else {
			                OpenAlertUI(strLang580, "OPEN", "");
			                return;
			            }
			        } else {
			        	pSaveDocIDlist.push(selRows[0].getAttribute("DATA1"));
			        	TotalSave_onclick_complete(pSaveDocIDlist, noRight);
			        }
		        }
		        // 다중 문서 통합 PC 저장 시 팝업창 없이 선택한 문서 바로 압축하여 다운로드. (다중 다운로드 시 hwp파일 배포문서 전환 대응하지 않음)
		        else {
		        	var pRightChkDocIDs = '';
		        	havingReadRightRows = [];
		        	
		        	for (var i = 0; i < selRows.length; i++) {
		        		if (selRows[i].getAttribute("DATA8") != "00") { // 문서 내용이 없다면 제외.
		        			sepaAttSet.add(selRows[i].getElementsByTagName("td").item(5).getAttribute("title"));
		        			selRows[i] = null;
		        			noRight = true;
		        		} else {
		        			pRightChkDocIDs += selRows[i].getAttribute("DATA1") + "|||";
			        		havingReadRightRows.push(selRows[i]); // 모든 문서의 열람 권한이 있을 시 선택되었던 행들을 파라미터로 보내기 위해 담아둠.
		        		}
		        	}
		        	
		        	checkRightTotalSave(pRightChkDocIDs, selRows);
		        }
		    }
		    
			// 2023-07-05 한태훈 - 열람권한이 있는 문서인지 아닌지 확인하는 함수.    
	    	function checkRightTotalSave(pRightChkDocIDs, selRows) {
	    		$.ajax ({
	    			url : "/ezApprovalG/checkRightTotalSave.do",
	    			type: 'POST',
	    			dataType: 'text',
	    			async: false,
	    			data: {
	    				docIDstr : pRightChkDocIDs,
	    				orgCompanyID : CompanyID
	    			},
	    			success: function(resultXMLstr) {
	    				if (resultXMLstr == "<RESULT>TRUE</RESULT>") {
	    					chkSecAppr(havingReadRightRows);
	    				} else {
	    					havingReadRightRows = [];
	    					var resultXML = loadXMLString(resultXMLstr);
	    					var failDocIDStr = SelectSingleNodeValue(resultXML, "RESULT");
	    					var failDocIDarr = failDocIDStr.split("|||");
	    					// failDocIDarr 의 마지막 값이 공백이라면 제거한다.
	    					if (failDocIDarr.length > 0 && failDocIDarr[failDocIDarr.length - 1] == "") {
	    						failDocIDarr.pop();
	    					}
	    					
	    					for (var k = 0; k < selRows.length; k++) {
	    						if (selRows[k] == null) {
	    							continue;
	    						}
	    						var selDocID = selRows[k].getAttribute("DATA1");
	    						
	    						if (failDocIDarr.indexOf(selDocID) >= 0) {
	    							var failDocNum = selRows[k].getElementsByTagName("td").item(5).getAttribute("title");
	    							if (k != selRows.length - 1) {
	    								failDocNums = failDocNums + failDocNum + "/ ";
	    							} else {
	    								failDocNums = failDocNums + failDocNum;
	    							}
	    							
	    							failDocCount = failDocCount + 1;
	    							noRight = true;
	    						} else {
	    							havingReadRightRows.push(selRows[k]);
	    						}
	    					}
	    					
	    					if (havingReadRightRows.length > 0) {
	    						chkSecAppr(havingReadRightRows);
	    		        	} else if (havingReadRightRows.length == 0) {
	    		        		if (noRight) {
	    		        			OpenAlertUI("<spring:message code='ezApprovalG.t00016'/>");
	    		        		}
	    		        	}
	    				}
	    			}, error: function() {
	    				OpenAlertUI("<spring:message code='ezApprovalG.t00017'/>");
	    				return;
	    			}
    			});
	    	}
				    
		    // 열람권한이 있는 문서들을 대상으로 보안 결재 설정 여부 확인 및
		    // 보안 결재 설정된 문서 다운로드 시도자가 해당 문서의 결재선에 포함여부 확인 (보안결재 문서 열람 권한 여부 확인).
		    function chkSecAppr(havingReadRightRows) {
		    	var pSecApprDocIDs = "";
		    	
		    	for (var i = 0; i < havingReadRightRows.length; i++) {
		    		var tempDocID = havingReadRightRows[i].getAttribute("DATA1");
		    		
		    		if (havingReadRightRows[i].getAttribute("DATA14") != "" && havingReadRightRows[i].getAttribute("DATA14") >= GetTodayDate()) {
		    			pSecApprDocIDs += tempDocID + "|||";
		    			secDocRows.push(havingReadRightRows[i]);
			        } else {
			        	pSaveDocIDlist.push(tempDocID);
			        }
		    	}
		    	
		    	if (pSecApprDocIDs != "") {
		    		$.ajax ({
		    			url : "/ezApprovalG/chkSecDocInAprLine.do",
		    			type: 'POST',
		    			dataType: 'text',
		    			async: false,
		    			data: {
		    				companyID : CompanyID,
		    				docIDStr  : pSecApprDocIDs,
		    				mode  	  : "END",
		    				userID    : UserID
		    			},
		    			success: function(resultXMLstr) {
		    				var resultXML = "";
		  		            var pohamIDs = "";
		  		            var mipohamIDs = "";
		    				resultXML = loadXMLString(resultXMLstr);
		    				pohamIDsStr = getNodeText(SelectNodes(resultXML, "RESULT/INAPRLINE")[0]);
		  		            secDocIDsNotInAprLineStr = getNodeText(SelectNodes(resultXML, "RESULT/NOTINARPLINE")[0]);
		  		            secDocIDsInAprLine = pohamIDsStr.split("|||");
		  		            
		  		            if (secDocIDsInAprLine.length > 0 && secDocIDsInAprLine[secDocIDsInAprLine.length - 1] == "") {
		  		            	secDocIDsInAprLine.pop();
		  		            }
		  		            
		  		            if (secDocIDsNotInAprLineStr != "") {
		  		            	noRight = true;
		  		           	    var secDocIDsNotInAprLine = secDocIDsNotInAprLineStr.split("|||");
		  		           	    if (secDocIDsNotInAprLine.length > 0 && secDocIDsNotInAprLine[secDocIDsNotInAprLine.length - 1] == "") {
		  		           	    	secDocIDsNotInAprLine.pop();
		  		           	    }
		  		           	    
		  		            	for (var d = 0; d < secDocRows.length; d++) {
		  		            		var tempSecDocID = secDocRows[d].getAttribute("DATA1");
		  		            		 
		  		            		if (secDocIDsNotInAprLine.indexOf(tempSecDocID.trim()) >= 0){
		  		            			failDocNums += secDocRows[d].getElementsByTagName("td").item(5).getAttribute("title") + "/ ";
				  		           	    failDocCount = failDocCount + 1;
		  		            		}
		  		            	}
		  		            }
		  					
		  		          chkNeedNorightAlert();
					    
		    			}, error : function() {
		    				OpenAlertUI("<spring:message code='ezApprovalG.t00017'/>");
		    			}
			    	});
		    	} else {
		    		chkNeedNorightAlert();
		    	}
		    }
		    
		    function noRightOpenAlertUI_Complete() {
		    	ezapralert_cross_dialogArguments = [];
		    	chkNeedPassword();
		    }
		    
		    // 열람권한이 없는 문서가 포함된 경우 알림창을 포출하는 함수.
		    function chkNeedNorightAlert() {
		    	
		    	if (pSaveDocIDlist.length <= 0 && secDocIDsInAprLine.length <= 0) {
		    		OpenAlertUI("<spring:message code='ezApprovalG.t00016'/>");
		    		return;
		    	}
		    	
				if (failDocCount > 0 || sepaAttSet.size > 0) {
					var pAlertContent = "";
					if (failDocCount > 0) {
						pAlertContent += "<spring:message code='ezApprovalG.t00019'/>";
						pAlertContent += " (";
						pAlertContent += failDocNums+" " + failDocCount + "<spring:message code='ezApprovalG.t00020'/>" + ")";
					}
					
					if (failDocCount > 0 && sepaAttSet.size > 0) {
						pAlertContent += " <spring:message code='ezApprovalG.t00018'/> "
					}
					
					if (sepaAttSet.size > 0) {
						pAlertContent += "("
						var index = 0;
						for (var item of sepaAttSet) {
							if (index != sepaAttSet.size - 1) {
								pAlertContent += item + "/ ";
							} else{
								pAlertContent += item + ")";
							}
							index += 1;
						}
						
						pAlertContent += "<spring:message code='ezApprovalG.t00023'/>"
					}
					
					pAlertContent += "<spring:message code='ezApprovalG.t00024'/>"
					ezapralert_cross_dialogArguments[1] = noRightOpenAlertUI_Complete;
					ezapralert_cross_dialogArguments[2] = true;
	 				OpenAlertUI(pAlertContent, noRightOpenAlertUI_Complete);
				} else {
					chkNeedPassword();
				}
			}
		    
		    // 보안결재 설정을 한 문서가 포함되어 있는 경우 암호창 표출하는 함수.
		    function chkNeedPassword() {
		    	if (secDocIDsInAprLine.length > 0) {
		    		chk_Passwd(UserID, chk_Passwd_CompleteSave);
		    	} else {
		    		TotalSave_onclick_complete(pSaveDocIDlist, noRight);
		    	}
		    }
		    
		    // 2023-06-23 한태훈 - 통합 PC 저장 시 보안결재 설정 문서 존재 시 패스워드 확인 후 동작
			function chk_Passwd_CompleteSave(Rtn) {
		        if (Rtn == "FALSE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		        }
		        else if (Rtn == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		            var boAhnKyulDocStr = "";
		            if (secDocRows.length > 0) {
			            for (var i = 0; i < secDocRows.length; i++) {
			            	if (i != secDocRows.length - 1) {
				                boAhnKyulDocStr += secDocRows[i].getElementsByTagName("td").item(5).getAttribute("title") + "/ ";
			            	} else {
				                boAhnKyulDocStr += secDocRows[i].getElementsByTagName("td").item(5).getAttribute("title") + " ";
			            	}
			                
			            }
			            pAlertContent = pAlertContent + "\n <spring:message code='ezApprovalG.t00021'/> \n" + boAhnKyulDocStr + " <spring:message code='ezApprovalG.t00022'/>"
		            }
		            OpenAlertUI(pAlertContent);
		        }
		        else {
		            if (secDocIDsInAprLine.length > 0) {
		                for (var c = 0; c < secDocIDsInAprLine.length; c++) {
			        		pSaveDocIDlist.push(secDocIDsInAprLine[c]);
		        	    }
		        	}
		        	TotalSave_onclick_complete(pSaveDocIDlist, noRight);
		        }
		    }
		    
		    // 실제 통합 PC 저장 동작 분리 (기록물대장)
		    function TotalSave_onclick_complete(pDocIDarr, noRight) {
		    	if (!noRight && pDocIDarr.length == 1) {
		    		 var url = "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocIDarr[0] + "&type=END" + "&orgCompanyID=" + CompanyID;
				        var feature = "status=no,help=no,scroll=no,edge=sunken,width=580px,height=480px";
				        feature = feature + GetOpenPosition(580, 480);
				        window.open(url, "", feature);
				        
		    	} else if (noRight && pDocIDarr.length == 1 || pDocIDarr.length > 1) {
		    		//열람권한이 없는 문서와 열람권한이 있는 문서를 같이 선택했는데, 열람권한이 있는 문서가 딱 하나인 경우(위의 로직을 타지 않게 하기 위해 추가) || 열람권한이 가능한 문서를 여러개 선택된 경우
			    	
		    		var pDocIDstr = "";
		    		for (var k = 0; k < pDocIDarr.length; k++) {
		    			pDocIDstr += pDocIDarr[k] + "|||"
		    		}
		    		
		    		$.ajax ({
		    			url: "/ezApprovalG/totalSaveFileAll.do",
		    			type: 'POST',
		    			dataType: 'text',
		    			async: false,
		    			data: {
		    				docIDstr : pDocIDstr,
		    				type : "END",
		    				orgCompanyID : CompanyID
		    			},
		    			success: function(result) {
		    				if (result == "FALSE") {
		    					OpenAlertUI("<spring:message code='ezApprovalG.t00017'/>");
		    				} else {
		    					var URL = result;
		    					AttachDownFrame.location.href = "/ezApprovalG/downloadAttach.do?filePath=" + encodeURIComponent(URL);
		    					DivPopUpHidden();
		    				}
		    			}, error: function() {
		    				OpenAlertUI("<spring:message code='ezApprovalG.t00017'/>");
		    			}
		    		});
		    	}
		    }
		
		    window.onresize = function() {
		    	settingResize();
		        // 2023-06-20 전인하 - 전자결재G > 기록물대장 미리보기 - 미리보기 영역 리사이징 동작 추가
		    	Window_resize();
		    };
		    
		    var settingResize = function() {
		    	if (document.getElementById('trSubInfoTab').style.display == 'none') {
		    		var currentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
			        var divListHeight = document.getElementById('divList').style.height;
			        document.getElementById('divList').style.height = (currentHeight - 69) + "px";
		    	}
		    }
		    
		    function onkeydown_start_search() {
		        if (window.event.keyCode == "13") {
		            search();
		        }
		    }
		
		    function keyword_Clear() {
		        document.getElementById('txt_keyword').value = "";
		    }
		
		    function search() {
				var nowyear = new Date().getFullYear();
				var nowmonth = new Date().getMonth() + 1;
				var nowday = new Date().getDate();

				if (nowmonth < 10)
					nowmonth = "0" + nowmonth;

				if (nowday < 10)
					nowday = "0" + nowday;

		        if (document.getElementById("txt_keyword").value != "") {
					// 2021-09-27 기록물대장 검색시 페이지 변경되지 않는 버그 수정
		            curpage = 1;
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1160'/>");
		            return;
		        }
                
                //var spanElement = window.parent.frames.left.document.getElementById("selectDeptName");
                //var selDeptID = spanElement.getAttribute("dataDeptId");
                //var tempDeptID = selDeptID;
				var tempDeptID = DeptID;
				
				// 하위부서 선택시 서브메뉴가 사라지기 때문에 하위부서를 선택했을 경우에도 분기를 탈 수 있도록 조건 추가해줌.
		        if (document.getElementById("trRecSubMenu").style.display == "" || (underDeptFlag === "TRUE" && document.getElementById("recordRight").style.display == "")) {
		            var radiosearch = document.getElementById('selectType');

					if (checkRecordAll()) {
						tempDeptID = "ALL";
					}
					
                    if (underDeptFlag === "TRUE" && g_sFlag != 'm02' && GetSelectVal("rec_underDept") != "default" ) {
                        tempDeptID = GetSelectVal("rec_underDept");
                    }
		            
		            if (radiosearch.value == "rad_Subject") {
						if (selectYear == "ALL") {
							g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE><![CDATA[" + document.getElementById("txt_keyword").value + "]]></TITLE><REGTYPE></REGTYPE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00.001</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59.999</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
						} else {
							g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE><![CDATA[" + document.getElementById("txt_keyword").value + "]]></TITLE><REGTYPE></REGTYPE><SREGDATE>" + selectYear + "-01-01 00:00:00.001</SREGDATE><EREGDATE>" + selectYear + "-12-31 23:59:59.999</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
						}
		            } else if (radiosearch.value == "rad_Writer") {
						if (selectYear == "ALL") {
							g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00.001</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59.999</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER><![CDATA[" + document.getElementById("txt_keyword").value + "]]></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
						} else {
							g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + selectYear + "-01-01 00:00:00.001</SREGDATE><EREGDATE>" + selectYear + "-12-31 23:59:59.999</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER><![CDATA[" + document.getElementById("txt_keyword").value + "]]></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
						}
		            }
		            
		            switch (ListTypeFlag) {
		                case "2":
		                    GetTransListXml("P02");
		                    break;
		
		                case "3":
		                    GetTransListXml("T02");
		                    break;
		
		                case "4":
		                    GetTransListXml("T02");
		                    break;
		
		                default:
		                    GetRecordListXml();
		            }
		        }
		        else if (document.getElementById("trCabSubMenu").style.display == "" || (underDeptFlag === "TRUE" && document.getElementById("rec_underDept2"))) {
		            var radiosearch = document.getElementById('selectType');
		            
		            if (underDeptFlag === "TRUE" && g_sFlag === 'm02' && GetSelectVal("rec_underDept2") != "default" ) {
                        tempDeptID = GetSelectVal("rec_underDept2");                    
                    }
		
		            if (radiosearch.value == "rad_Subject") {
						if (selectYear == "ALL") {
							g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE><![CDATA[" + document.getElementById("txt_keyword").value + "]]></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SPRODUCEY><EPRODUCEY>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
						} else {
							g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE><![CDATA[" + document.getElementById("txt_keyword").value + "]]></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + selectYear + "</SPRODUCEY><EPRODUCEY>" + selectYear + "</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
						}
		            }
		            else if (radiosearch.value == "rad_Writer") {
						if (selectYear == "ALL") {
							g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SPRODUCEY><EPRODUCEY>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER><![CDATA[" + document.getElementById("txt_keyword").value + "]]></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
						} else {
							g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + tempDeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + selectYear + "</SPRODUCEY><EPRODUCEY>" + selectYear + "</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER><![CDATA[" + document.getElementById("txt_keyword").value + "]]></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
						}
		            }
		
		            switch (ListTypeFlag) {
		                case "2":
		                    GetTransListXml("P01");
		                    break;
		
		                case "3":
		                    GetTransListXml("T01");
		                    break;
		
		                case "4":
		                    g_CabSearchParamXml = "<SEARCHPARAM><TRANSFLAG>16=0</TRANSFLAG></SEARCHPARAM>";
		                    GetTransListXml("T01");
		                    break;
		                default:
		                    GetCaninetListXml();
		            }
		        }
		        else {
		            var radiosearch = document.getElementById('selectType');
		
		            if (radiosearch.value == "rad_Subject") {
						if (selectYear == "ALL") {
							g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + tempDeptID + "</DEPTCODE2><TITLE><![CDATA[" + document.getElementById("txt_keyword").value + "]]></TITLE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00.001</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59.999</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";
						} else {
							g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + tempDeptID + "</DEPTCODE2><TITLE><![CDATA[" + document.getElementById("txt_keyword").value + "]]></TITLE><SREGDATE>" + selectYear + "-01-01 00:00:00.001</SREGDATE><EREGDATE>" + selectYear + "-12-31 23:59:59.999</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";
						}
		            }
		            else if (radiosearch.value == "rad_Writer") {
						if (selectYear == "ALL") {
							g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + tempDeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00.001</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59.999</EREGDATE><DEBENTURER><![CDATA[" + document.getElementById("txt_keyword").value + "]]></DEBENTURER></SEARCHPARAM>";
						} else {
							g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + tempDeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + selectYear + "-01-01 00:00:00.001</SREGDATE><EREGDATE>" + selectYear + "-12-31 23:59:59.999</EREGDATE><DEBENTURER><![CDATA[" + document.getElementById("txt_keyword").value + "]]></DEBENTURER></SEARCHPARAM>";
						}
		            }
		
		            GetDocDeliveryList(g_DeliverySearchParamXml);
		        }
		
		
		        $('#sel_year').val(selectYear);
		        /* $('#sel_year').selectmenu('refresh'); */
		    }
		    
			/////////////////////////////////////////////////////////////////////////////
		    
		    function DeleteCab() {  	
		    	var DocList = new ListView();
		    	DocList.LoadFromID("DocList");
		    	var selRow = DocList.GetSelectedRows();
		    	if (selRow.length != 0) {
		    		var tr = selRow[0];
		    		SwapSubMenuDisplay("1");
		    		pCabClassNo = tr.getAttribute("DATA1");
		    		
		    		var selectResult = DeleteORselect_CabNo(pCabClassNo, '/ezApprovalG/selectExpCabDocInfo.do');

		    		if (selectResult=="TRUE") {
		    			if (confirm("<spring:message code='ezApprovalG.t30000'/>")) {
			    			DeleteORselect_CabNo(pCabClassNo, '/ezApprovalG/deleteCabInfo.do');
			    			LoadList();
		    			}
		    		} else {
		    			OpenAlertUI("<spring:message code='ezApprovalG.t30002'/>");
		    			return false;
		    		}
					return false;
		    	} else {
		    		OpenAlertUI("<spring:message code='ezApprovalG.t913'/>");
		    		return false;
		    	}	
		    }
		    
		    function DeleteORselect_CabNo(pCabClassNo, pUrl) {
	    		var result = "";
	    		$.ajax ({
	    			url: pUrl
	    			,type: 'POST'
	    			,dataType: 'text'
	    			,async: false
	    			,data: {
	    				cabClassNO : pCabClassNo
	    			}, success: function(res) {
	    				result = res;
	    			}, error: function() {
	    				OpenAlertUI("<spring:message code='ezApprovalG.t30001'/>");
	    			}
	    		});
	    		return result;
		    }
		    
		     function lvtDoclist_HeaderClick(pHeaderName) {
		            if (OrderCell == pHeaderName) {
		                if (OrderOption == "")
		                    OrderOption = "DESC";
		                else
		                    OrderOption = "";
		            }
		            else {
		                OrderCell = pHeaderName;
		                OrderOption = "";
		            }
		            SortList(OrderCell);
		        }
		     var Tab1_SelectID = "";
			    function Tab1_MouserOver(obj) {
			        obj.className = "tabover";
			    }
		
			    function Tab1_MouserOut(obj) {
			        if(Tab1_SelectID != obj.id)
			            obj.className = "";
			    }
		
			    function Tab1_MouseClick(obj) {		    	
			        obj.className = "tabon";
			        if (obj.id != Tab1_SelectID) {
			            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
			                document.getElementById(Tab1_SelectID).className = "";
		
			            obj.className = "tabon";
			            Tab1_SelectID = obj.id;
			            ChangeTab(obj);
			        }
			    }
			    
			    function ChangeTab(obj) {
			        var pSelectTab = obj.id;

			        switch (pSelectTab) {
			            case "tagsub1": pDocInfoValue='1';Approval_onclick(); break;
			            case "tagsub2": pDocInfoValue='2';Recipent_onclick(); break;
			            case "tagsub3": pDocInfoValue='4';Attach_onclick(); break;
			            case "tagsub4": pDocInfoValue='3';Opinion_onclick(); break;
			            case "tagsub5": pDocInfoValue='5';Circulation_onclick(); break;
			        }
			    }
			    
		     function Tab1_NewTabIni(pTabNodeID) {
			        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
			            if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
			                if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
			                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
			                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
			                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };

			                    if (i == 1) {
			                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).className = "tabon";
			                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).id;
			                    }	
			                }
			            }
			        }
			    }
		     
			    function GetEndYConfirmList() {
			    	/* 2022-07-22 홍승비 -  기록물보기 화면에서 다시 기록물철보기 버튼 클릭 시, 우측 상단의 년도 선택 셀렉트박스 ALL(최근 1년)으로 초기화 */
			    	$("#rec_year").val("ALL");
			    	resetRecYearSel();// 기록물보기 시의 생산년도 체크로 추가된 년도 부분 초기화
			    	
			    	switch (g_sFlag) {
				    	case "m02":
				    		isPeriodYear = false;
		                    CabinetList_onclick();
		                    break;
		                    
			    		case "m07" :
			    			isPeriodYear = false;
			    			DelayEndYRequest_onclick();
			    			break;
			    		
			    		case "m08" :
			    			isPeriodYear = false;
			    			ArrTargetList_onclick();
			    			break;
			    		
			    		default :
							return;				    			
			    	}
			    }
			    
			    var changeOpenGovInfo_cross_dialogArguments = new Array();
			    function btnChangeOpenGovInfo_onclick() {
			        var DocList = new ListView();
			        DocList.LoadFromID("DocList");
			        var selRow = DocList.GetSelectedRows();
			        if (selRow.length != 0) {
			            var tr = selRow[0];
			            var para = new Array();
			            para[0] = tr.getAttribute("DATA6");
			            para[1] = tr.getAttribute("DATA8");
			            para[2] = arr_userinfo[1];
			            para[3] = arr_userinfo[2];
			            para[4] = g_bRecAdmin;
			            para[5] = tr.getAttribute("DATA1");
			
			            var url = "/ezApprovalG/changeOpenGovInfo.do";
			
			            changeOpenGovInfo_cross_dialogArguments[0] = para;
			            changeOpenGovInfo_cross_dialogArguments[1] = btnChangeOpenGovInfo_onclick_Complete;
			
			            var OpenWin = window.open(url, "ChangeOpenGovInfo_Cross", GetOpenWindowfeature(615, 510));
			            try { OpenWin.focus(); } catch (e) { }
			        }
			        else {
			            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
			        }
			    }
			
			    function btnChangeOpenGovInfo_onclick_Complete(rtn) {
			        if (rtn[0] == "TRUE") {
			            GetRecordList();
			        }
			    }
			    
			    /* 2022-03-18 홍승비 - 미처리문서함의 내부시행문 반송문서 삭제 함수 추가 (물리적인 삭제가 아니며, 관리자단의 DELFLAG 변경 함수 그대로 사용함) */
				function btnRemoveDoc_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows == 0) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		            alert(pAlertContent);
		            return;
		        }
		        
		        var Ans = confirm("<spring:message code='ezApprovalG.t1728'/>");
		        if (Ans) {
					pCurSelRow = oArrRows[0];
	        		var pDocID = GetAttribute(pCurSelRow, "DATA1");
	        		
	        		var xmlhttp = createXMLHttpRequest();
	        		var xmlpara = createXmlDom();
	        		var objNode;
	        		
	        		createNodeInsert(xmlpara, objNode, "PARAMETER");
	        		createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID); // 현재 회사의 문서만 표출하므로, companyID 그대로 사용
	        		createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
	        		createNodeAndInsertText(xmlpara, objNode, "DELFLAG", "Y");
	        		createNodeAndInsertText(xmlpara, objNode, "DELINFO", "사용자[" + arr_userinfo[1] + "]에 의해 삭제된 내부시행문서입니다."); // 삭제사유 자동삽입
	        		
	        		xmlhttp.open("POST","/admin/ezApprovalG/setDelDocInfo.do",false);
	        		xmlhttp.send(xmlpara);
	        		
					if (xmlhttp != null && xmlhttp.readyState == 4) {
						if (xmlhttp.status == 200) {
							openergetDocInfo();
	  	                } else {
	  	                	var pAlertContent = "<spring:message code='ezApprovalG.t131'/>";
							OpenAlertUI(pAlertContent);
	  	                }
					}
		        }
		    }
			    
			/* 2022-07-22 홍승비 - 기록물보기 시의 년도 셀렉트박스를 초기화하는 함수 추가 */
			function resetRecYearSel() {
	            var toDay = new Date();
	            var toDayYear = parseInt(toDay.getFullYear());
	            var minusYear = parseInt(toDay.getFullYear()) - parseInt(pOpenYaer);
	            
	            $("#rec_year option[value != 'ALL']").remove(); // ALL 제외하고 모든 옵션 제거
	            
	            for (var i = toDayYear; i >= toDayYear - minusYear ; i--) {
	                AddOption(rec_year, i, i);
	            }
			}
			
            //2023-05-23 이혜림 - 전자결재G > 기록물대장 미리보기 > 미리보기영역의 문서팝업창 보기버튼 동작메소드 추가
            function btn_newpopup() {
                lvtDoclist_onSel_DBclick();
            }

			/* 첨부기안 */
			function attachedDraft() {
				let lv = new ListView();
				lv.LoadFromID("DocList");

				if (!checkIsValidReq(lv)) {
					return;
				}

				extractDocID(lv);

				if (typeof parent != "undefined") {
					parent.left.attachedDocList = attachedDocList;
				}

				if (useDraftAll) {
					let draftInfo = [
						{
							"msg" : "단건기안",
							"rtnF" : "attachedDraft_single",
							"fl" : "parent",
							"css" : "margin : 0 3px 0 3px;"
						},
						{
							"msg" : "일괄기안",
							"rtnF" : "attachedDraft_all",
							"fl" : "parent",
							"css" : "margin : 0 3px 0 3px;"
						}
					];

					OpenAlertUI("<spring:message code = 'ezApprovalG.record.attachedDraftMsg1' />", draftInfo, null, true);
				} else {
					attachedDraft_single();
				}
			}

			function checkIsValidReq(lv) {
				let selectedDocList = lv.GetSelectedRows();

				if (selectedDocList.length < 1) {
					alert("<spring:message code = 'ezApprovalG.t113' />");

					return false;
				}

				return true;
			}

			function extractDocID(lv) {
				attachedDocList = [];
				let selectedDocList = lv.GetSelectedRows();
				let docListCnt = selectedDocList.length;

				for (var cnt = 0; cnt < docListCnt; cnt++) {
					attachedDocList.push(selectedDocList[cnt].getAttribute("data1"));
				}
			}

			function attachedDraft_single() {
				parent.left.btnDraft_onclick();

				DivPopUpHidden();
			}

			function attachedDraft_all() {
				parent.left.btnDraftAll_onclick();

				DivPopUpHidden();
			}
			
			
		</script>
	</head>
	<%-- 2023-05-23 이혜림 - 전자결재G > 기록물대장 미리보기 - 프리뷰 리사이징바 영역 동작 추가 --%>
	<body class="mainbody" style="margin-top:0px; overflow:auto;" marginwidth="0" marginheight="0" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	    <h1><span id="imgTitle" style="font-size:17px"></span><span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
			<span class="searchForm">
				<select id="selectType" class="text" style="width:80px; height:27px; border-color: #c8c8c8;">
					<option selected="" value="rad_Subject" id="rad1"><spring:message code='ezApprovalG.t106'/></option>
					<option value="rad_Writer" id="rad2"><spring:message code='ezApprovalG.t445'/></option>
				</select>
				<input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true" onmousedown="keyword_Clear();"> 
				<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="search()"></a>
			</span>
	    </h1>
	
	    <div id="mainmenu" class='cabinetMenu'>
	        <ul id="trCabSubMenu" style="Display: None;">
	            <li class="important" id="tdReqDelayEndY" style="Display: None"><span id="ReqDelayEndY" onclick="return ReqDelayEndY_onclick()">
	                <spring:message code='ezApprovalG.t907'/></span></li>
	            <li class="important" id="tdCancelDelayEndY" style="Display: None"><span id="CancelDelayEndY" onclick="return CancelDelayEndY_onclick()"><spring:message code='ezApprovalG.t930'/></span></li>
	            <li class="important" id="tdbtnEndProduce" style="Display: None"><span id="btnEndProduce" onclick="return btnEndProduce_onclick()">
	                <spring:message code='ezApprovalG.t931'/></span></li>
	            <li class="important" id="tdbtnCancelEndProd" style="Display: None"><span id="btnCancelEndProd" onclick="return btnCancelEndProd_onclick()">
	                <spring:message code='ezApprovalG.t932'/></span></li>
	            <!-- <li id="tbar1" style="background: none; padding-right: 2px;">
	                <img src="/images/i_bar.gif"></li> -->
	            <li class="important" id="tdRegCabinet" style="Display: None"><span id="RegCabinet" onclick="return btnRegCabinet_onclick()"><spring:message code='ezApprovalG.t2002'/></span></li>
	            <li id="tdNewVol" style="Display: None"><span id="NewVol" onclick="return btnNewVolume_onclick()"><spring:message code='ezApprovalG.t894'/></span></li>
	            <li id="tdViewCabInfo"><span id="ViewCabInfo" onclick="return btnViewCabInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
	            <li id="tdViewCabHist" style="Display: None"><span id="ViewCabHist" onclick="return btnViewCabHistory_onclick()"><spring:message code='ezApprovalG.t947'/></span></li>
	            <li id="tdModifyCab" style="Display: None"><span id="ModifyCab" onclick="return btnChangeCabinetInfo_onclick()"><spring:message code='ezApprovalG.t269'/></span></li>
	            <%-- <li id="tdBtnCabDel"><span id="btnCabDel" onclick="return DeleteCab();" style="Display: None"><spring:message code='ezApprovalG.t266'/></span> </li> --%>
	            <%-- <li id="tdSearchCab"><span id="SearchCab" onclick="return SearchCabinet('0')"><spring:message code='ezApprovalG.t111'/></span></li> --%>
	            <li id="tdDocListPrint"><span id="DocListPrintRec" onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
	            <li id="tdSetCharger" style="Display: None"><span id="SetCharger" onclick="return btnSetTaskCharger_onclick()"><spring:message code='ezApprovalG.t937'/></span></li>
	            <li id="tdSearchCab"><span class="icon16 icon16_search" id="SearchCab" onclick="return SearchCabinet('0')"></span></li>
	            <li id="tdBtnCabDel" style="display: none;"><span class="icon16 icon16_delete" id="btnCabDel" onclick="return DeleteCab();"></span></li>
	            <li id="tdbtnViewRecList"><span id="btnViewRecList" onclick="return btnViewRecList_onclick()"><spring:message code='ezApprovalG.t526'/></span></li>	            
                <%-- 2024-06-07 전인하 - 기록물대장 > 하위부서 선택 드롭다운 --%>
                <c:if test="${underDeptFlag eq 'TRUE'}">
                    <li style="vertical-align: middle; float:right; display:none;">
                        <select select id="rec_underDept2" name="rec_underDept2" style="max-width:200px;" onchange="onSelect_Year(this);">    
                            <option value="default" selected><spring:message code='ezApprovalG.underDept.jih001'/></option>
                        </select>
                    </li>
                </c:if>
                <li style="vertical-align: middle; float:right">
	                <select id="cab_year" name="cab_year" style="width:75px;" onchange="onSelect_Year(this);">    
	                    <option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option>
                    </select>
                </li>
	        </ul>
	
	        <ul id="trRecSubMenu" style="Display: none;">
	            <li class="important" id="tdichange_Rec" style="display:none;"><span id="ichange_Rec" onclick="return ichange_onclick()"><spring:message code='ezApprovalG.t939'/></span></li>
                <li class="important" id="tdichangeS_Rec" style="display:none;"><span id="ichangeS_Rec" onclick="return ichangeS_onclick()"><spring:message code='ezApprovalG.t1524'/></span></li>
                <li class="important" id="tdReSend" style="display:none;"><span id="ReSend" onclick="return btnReSend_onclick()"><spring:message code='ezApprovalG.t940'/></span></li>
                <!-- <li id="tbar3" style="background: none; padding-right: 2px;">
                    <img src="/images/i_bar.gif"></li> -->	            
                <li class="important" id="tdRegRecord" style="Display: None"><span id="RegRecord" onclick="return btnRegRecord_onclick()"><spring:message code='ezApprovalG.t933'/></span></li>
                <li class="important" id="tdRegSepAtt" style="Display: None"><span id="RegSepAtt" onclick="return btnRegAttach_onclick()"><spring:message code='ezApprovalG.t942'/></span></li>
                <li id="tdViewRecInfo"><span id="ViewRecInfo" onclick="return btnViewRecInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
                <li id="tDocInfo"><span id="DocInfo" onclick="return GongRamDocInfo()"><spring:message code='ezApprovalG.t946'/></span></li>	            
                <li id="tdbtnCardSend" style="Display: None"><span id="btnCardSend" onclick="return btnCardSend_onclick()"><spring:message code='ezApprovalG.t943'/></span></li>
                <li id="tdbtnSetRecRole" style="display: none"><span id="btnSetRecRole" onclick="return btnSetRecUserRole_onclick()"><spring:message code='ezApprovalG.t944'/></span></li>
                <li id="tdbtnViewRecReadHist" style="Display: None"><span id="btnViewRecReadHist" onclick="return btnViewRecReadHist_onclick()"><spring:message code='ezApprovalG.t945'/></span></li>
                <li id="tdVeiwRecHist" style="Display: None"><span id="VeiwRecHist" onclick="return btnViewRecHistory_onclick()"><spring:message code='ezApprovalG.t947'/></span></li>
                <!-- <li id="tbar4" style="background: none; padding-right: 2px;">
                    <img src="/images/i_bar.gif"></li> -->
                <li id="tdMoveRec" style="Display: None"><span id="MoveRec" onclick="return btnChangeRecCabinet_onclick()"><spring:message code='ezApprovalG.t948'/></span></li>
                <li id="tdModifyRec" style="Display: None"><span id="ModifyRec" onclick="return btnChangeRecInfo_onclick()"><spring:message code='ezApprovalG.t269'/></span></li>
                <li id="tdDocListPrint"><span id="DocListPrintRec" onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
                <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
                <li id="tdGongRam" style="display:none;"><span id="GongRam" onclick="return btnSendAround_onclick()"><spring:message code='ezApprovalG.t1428'/></span></li>
                <li id="tdCabSelect"><span id="CabSelect" onclick="return CabinetSelect_onclick()"><spring:message code='ezApprovalG.t941'/></span></li>
<%-- 	            <c:if test=""> 원문정보공개 사용하면 보이게 해줘야함 --%>
<%-- 		            <li id="tdModifyOpenGov" style="<c:if test="${useOpenGov != 'YES'}">display:none;</c:if>"><span id="ModifyOpenGov" onclick="return btnChangeOpenGovInfo_onclick()">원문공개수정</span></li> --%>
<%-- 	            </c:if> --%>
				<%-- 첨부기안 --%>
				<li id = "tdAttachedDraft" style="display: none;">
					<span id = "attachedDraft" onclick = "attachedDraft()">
						<spring:message code = "ezApprovalG.record.attachedDraft" />
					</span>
				</li>
	            <li id="tdSearchRec"><span class="icon16 icon16_search" id="SearchRec" onclick="return btnSearchRec_onclick(0,'OPEN')"></span></li>
	            <%-- 2022-03-18 홍승비 - 미처리문서함 > 내부시행문의 반송 시 문서삭제 기능 추가 --%>
	            <li id="tbtnRemoveDoc" style="display:none;"><span class="icon16 icon16_delete" id="btnRemoveDoc" onclick="return btnRemoveDoc_onclick()"></span></li>
	            <li id="tdViewCabList" style="display:none"><span onclick="return GetEndYConfirmList()"><spring:message code='ezApprovalG.t525'/></span></li>
            </ul>         
            <ul id='recordRight' class='selectUnderDept' style='width:100%'>
	            <%-- 2023-05-23 이혜림 - 전자결재G > 기록물대장 미리보기 - 미리보기 영역 상단 아이콘 삽입 (기록물 대장) --%>
		            <div id="right" class="sub_frameIcon" <c:if test="${useAprPreview != 'YES'}">style="display:none;"</c:if>>
	    				<div class="sub_frameIconUL" style="width:auto !important;">
	           				<p class="frameIconLI"><span class="icon16 btn_onnoframe" id="PreViewNone" onclick="PreviewRayerChange('NONE', 'Cabinet')"></span></p>
	        				<p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H', 'Cabinet')"></span></p>
					    </div>
					</div>
					<%-- 2024-06-07 전인하 - 기록물대장 > 하위부서 선택 드롭다운 --%>
                    <c:if test="${underDeptFlag eq 'TRUE'}">
                        <li style="vertical-align: middle; float:right display:none;">
                            <select id="rec_underDept" name="rec_underDept" style="max-width:200px;" onchange="onSelect_Year(this);">
                                <option value="default" selected><spring:message code='ezApprovalG.underDept.jih001'/></option>
                            </select>
                        </li>
                    </c:if>	
	            <li style="vertical-align: middle; float:right">
	                <select id="rec_year" name="rec_year" style="width:75px;" onchange="onSelect_Year(this);">
	                    <option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option>
	                </select>
                </li>  
            </ul>
	
	        <ul id="trDeliveryMenu" style="display: none">
	        	<li class="important" id="tbnBaeBu"><span id="Span2" onclick="return btnBaeBu_onclick()"><spring:message code='ezApprovalG.t100000'/></span></li>
	            <li id="Li1"><span id="Span1" onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
	            <li id="tbSearchDelivery"><span class="icon16 icon16_search" id="SearchDelivery" onclick="return btnSearchDelivery_onclick()"></span></li>

	            <%-- 2023-06-07 전인하 - 전자결재G > 기록물대장 미리보기 - 미리보기 영역 상단 아이콘 삽입 (배부 대장) --%>
	            <div id="right" class="sub_frameIcon" <c:if test="${useAprPreview != 'YES'}">style="display:none;"</c:if>>
                    <div class="sub_frameIconUL" style="width:auto !important;">
                        <p class="frameIconLI"><span class="icon16 btn_onnoframe" id="PreViewNoneDelivery" onclick="PreviewRayerChange('NONE', 'Cabinet')"></span></p>
                        <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleftDelivery" onclick="PreviewRayerChange('H', 'Cabinet')"></span></p>
                    </div>
                </div>
	            <li style="vertical-align: middle; float:right"> <select id="del_year" name="del_year" style="width:75px;" onchange="onSelect_Year(this);">    
	                <option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option>
	            </select>    </li>
	        </ul>
	    </div>
        <%-- 2023-05-23 이혜림 - 전자결재G > 기록물대장 미리보기 - 미리보기 레이어 및 리사이징 바 요소 추가 --%>
	    <%-- 리사이즈 바 클릭 시의 음영을 위한 부분 --%>
 		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="ResizeBarPanel"></div>
	    <div style="width: 8px; height:738px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	    <%-- 좌측 리스트 영역 --%>
	    <span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block; width: 100%;">
	    <div id="divList" class="div_scroll" style="width: 100%; height: 480px; overflow: AUTO; margin-bottom:10px;">
	        <div id="lvtDoclist"></div>
	    </div>
	    <div id="tblPageRayer"></div>
	    <div id="trSubInfoTab">
	        <%-- <div id="tabnav" style="width: 100%">
	            <ul>
	                <li id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1', event);Approval_onclick()"><spring:message code='ezApprovalG.t1769'/></span></li>
	                <li id="tagsub2"><span onclick="pDocInfoValue='2';MM_swapImagesub('2', event);Recipent_onclick()"><spring:message code='ezApprovalG.t950'/></span></li>
	                <li id="tagsub3"><span onclick="pDocInfoValue='3';MM_swapImagesub('3', event);Attach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                <li id="tagsub4"><span onclick="pDocInfoValue='4';MM_swapImagesub('4', event);Opinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                <c:if test="${approvalFlag != 'G'}">
					    <li id="tagsub5"><span onClick="MM_swapImagesub('5', event);Circulation_onclick()" ><spring:message code='ezApprovalG.hyj24'/></span></li>
				    </c:if>
	            </ul>
	        </div> --%>
	        <div id="tabnav" class="portlet_tabpart01" style="width:100%">
				<div class="portlet_tabpart01_top" id="tab1">
				    <p><span id="tagsub1"><spring:message code='ezApprovalG.t1769'/></span></p>
				    <p><span id="tagsub2"><spring:message code='ezApprovalG.t950'/></span></p>
				    <p><span id="tagsub3"><spring:message code='ezApprovalG.t56'/></span></p>
				    <p><span id="tagsub4"><spring:message code='ezApprovalG.t55'/></span></p>
			  	</div>
			</div>

	        <div style="WIDTH:100%;HEIGHT:230px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
	            <div id="lvtDetail" style="border: 0;"></div>
		        </div>
		    </div>
	    </span>

	    <%-- 우측 미리보기 영역 --%>
	    <div id="PreviewRayerH" style="border:0px; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
	        <div class="previewmail_bar_h" id="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block; height:738px;">
	            <p class="hbar_dotted">
	                <img src="/images/prevview_hbar_dotted.gif">
	            </p>
	        </div>
	        <div id="PreContent_RayerH" style="position: absolute; border: 0px; margin-left:7px;">
	            <div class="previewmail">
	            	<div class="previewmail_info"></div>
	                <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 738px; border: solid 0px green; display: inline-block;"></iframe>
	            </div>
	        </div>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        //selToggleList(document.getElementById("tabnav"), "p", "span", "1");
	        Tab1_NewTabIni("tab1");
	    </script>
	
	    <div id="tdDebug"></div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		 <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
	</body>
</html>
