<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t1515'/></title>
	    <style>
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
	        #div_AprLine .mainlist tr th {
				border-top:0px;
			}
	    </style>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" type="text/css"/>
	    <link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.js')}"></script>
	    <!-- <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.min.css')}"> --> 
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Common_Function.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/PreviewItem.js')}"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var labelcolor = "gray";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var ContainerID, UserID, DocID, DeptID, jobState, pURL, subCondition;
	        var condition = new Array("");
	        var g_tagSelectsub = "1";
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, DocListType;
	        var NodeList2, PageSize, ListView;
	        var contFlag = "<c:out value = '${contType}'/>";
	        var pSusinManagerFlag = "user";
	        var UserID = "<c:out value = '${userInfo.id}'/>";
	        var Block_Size, WriterID;
	        var docdir = "";
	        var OrderOption = "";
	        var OrderCell = "";
	        var pEndDocHref = "<c:out value = '${dirPath}'/>";
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "<c:out value = '${userInfo.id}'/>";
	        arr_userinfo[2] = "<c:out value = '${userInfo.displayName}'/>";
	        arr_userinfo[3] = "<c:out value = '${userInfo.title}'/>";
	        arr_userinfo[4] = "<c:out value = '${userInfo.deptID}'/>";
	        arr_userinfo[5] = "<c:out value = '${userInfo.deptName}'/>";
	        arr_userinfo[6] = "<c:out value = '${userInfo.jikChek}'/>";
	        arr_userinfo[7] = "<c:out value = '${buJaeInfo}'/>";
	        arr_userinfo[8] = "<c:out value = '${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value = '${susinAdmin}'/>";
	        arr_userinfo[11] = "<c:out value = '${userInfo.displayName1}'/>";
	        arr_userinfo[12] = "<c:out value = '${userInfo.displayName2}'/>";
	        arr_userinfo[13] = "<c:out value = '${userInfo.title1}'/>";
	        arr_userinfo[14] = "<c:out value = '${userInfo.title2}'/>";
	        arr_userinfo[15] = "<c:out value = '${userInfo.deptName1}'/>";
	        arr_userinfo[16] = "<c:out value = '${userInfo.deptName2}'/>";
	        var LoadContID = "${contID}";
	        var LoadSquery = "${sQuery}";
	        var GamSaFlag = false;
	        var CompanyID = "<c:out value = '${userInfo.companyID}'/>";
	        var USE_OCS = "<c:out value = '${useOcs}'/>";
	        var Udomain = "<c:out value = '${userEmail}'/>";
	        var pOpenYaer = "<c:out value = '${openYear}'/>";
			var approvalFlag = "<c:out value = '${approvalFlag}'/>"
	        var CurrentHeight = 0;
	        var CurrentWidth = 0;
	        var pItemCD = ""; 
	        var pEndAprType = "<c:out value = '${endAprType}'/>";
	        var pEndAprState = "<c:out value = '${endAprState}'/>";
	        var pUse_Editor = "<c:out value = '${useEditor}'/>";
	        var DocType = "";
 	        var DocState = "";
 	        var period;
 	        var pDocInfoValue = "1";
 	       	var nowDate = "<c:out value = '${nowDateUTC}'/>";
 	        var orgCompanyID = "";
 	       	var ext;
 	        var pListTypeValue;
 	        var isSearch = false;
 	     	//개인문서함 엑셀내보내기시에 필요한 파일명.
 	        var excelFileName = "<c:out value = '${excelFileName}'/>";
		    var userLang = "<c:out value = '${userLang}'/>";
 	        var shareDeptId = "<c:out value = '${shareDeptId}'/>";
 	        var share = "<c:out value = '${share}'/>";
 	        var useWebHWP = "<c:out value = '${useWebHWP}'/>";
 	       	var onclickFlag = false;
		    var pMailListDiv = 0;
		    var pMailPreVDiv = 0;
		    var pMailListWidthH = 0;
		    var pMailPreWidthH = 0;
		    var pMailListDiv_H = 0;
		    var pMailPreVDiv_H = 0;
		    var p_ListorderValue = "";
		    var pPreviewShow_HOW = "";
		    var clickPreviweType = "TEXT";
		    var PreviewH_Move = false;
		    var selobj = null;
		    var previewInfo = "<c:out value = '${previewInfo}'/>";
		    var useAprPreview = "<c:out value = '${useAprPreview}'/>";
			var selRowChangeFlag = false;
			var selectYear = "ALL";
		    
		    var containerState = "<c:out value = '${containerState}'/>";
		    var useReceiveInfoName = "<c:out value ='${useReceiveInfoName}'/>"; // 수신처 뒤에 "장"을 붙이는지 여부 (0 : 안붙임 / 1 : 붙임 / 2: 상위부서 + 수신처장)
 	        
	        document.onselectstart = function () { return false; };
	
	        $(function () {
	        	/* 2018-06-19 김민성 - 전자결재 selectbox 기본으로 변경 */
	           /*  $("#sel_year").selectmenu({
	                change: function (event, data) {
	                    onSelect_Year(data.item.value);
	                }
	            }); 
	
	            $("#who_year").selectmenu({
	                change: function (event, data) {
	                    onSelect_Year(data.item.value);
	                }
	            }); */
	            
	            /* $("#number")
	              .selectmenu()
	              .selectmenu("menuWidget")
	                .addClass("overflow"); */
	        });
	
	        window.onload = function () {
	            //var height = parseInt(divList.style.height.replace('px', '')) + 200;
	            //var reheight = window.innerHeight - parseInt(height);
	            CurrentHeight = document.documentElement.clientHeight;//document.body.clientHeight;
	            CurrenWidth = document.documentElement.clientWidth;//document.body.clientWidth;
	            var height = parseInt(divList.style.height.replace('px', '')) + 200;
	            var reheight = document.documentElement.offsetHeight - parseInt(height);
	            
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
	            /* 2022-07-04 홍승비 - 우측 미리보기 영역의 표출여부 스타일 속성을 온로드 초기에 제어 */
	        	if (useAprPreview == "YES" && previewInfo == "H") {
	        		document.getElementById("PreviewRayerH").style.display = "";
	        	}
	            
	            var toDayYear = parseInt(nowDate.substring(0,4));
	            var minusYear = parseInt(nowDate.substring(0,4)) - parseInt(pOpenYaer);
	            for (var i = toDayYear; i >= toDayYear - minusYear ; i--)
	                AddOption(sel_year, i, i);
	
	            try {
	                if ("<c:out value = '${type}'/>" == "1")
	                    GamSaFlag = true;
	
	                PageSize = 10;
	                Block_Size = 10;
	
	                pChackYN = "FALSE";
	
	                if (arr_userinfo[10] == "YES" || arr_userinfo[10] == "Y")
	                    pSusinManagerFlag = "admin";
	                else
	                    pSusinManagerFlag = "user";
	
	                DeptID = arr_userinfo[4];
	                jobState = "APPROVAL";
	
	                document.getElementById("menuapr").style.display = "none";
	                document.getElementById("menuend").style.display = "";
	                
	                var nowyear = nowDate.substring(0,4);
		            var nowmonth = nowDate.substring(5,7);
		            var nowday = nowDate.substring(8,10);       
	                
					if(approvalFlag == "G" && LoadSquery != "usercontlist") {
		                for (var i = 0; i < 25; i++) {
		                    condition[i] = "";
		                }
		
		                condition[9] = nowyear - 1;
		                condition[10] = nowmonth;
		                condition[11] = nowday;
		                condition[12] = nowyear;
		                condition[13] = nowmonth;
		                condition[14] = nowday;
		                condition[24] = "";
					} else {
			            for (var i = 0; i < 25; i++) {
			                condition[i] = "";
			            }
					}
					
					DocListType == "GetDocSearch";
                	var settingDate = new Date();
                	settingDate.setYear(parseInt(nowDate.substring(0,4)) - 1);

                    var settingmonth = nowDate.substring(5,7);
                    var settingday = nowDate.substring(8,10);

                    condition[5] = (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01";
                    condition[6] = nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59";

                    SQLPARADATA = "<ROOT><TYPE>STARTDATEAF;STARTDATEBF;</TYPE><DATA><STARTDATEAF>" + (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01</STARTDATEAF><STARTDATEBF>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</STARTDATEBF></DATA></ROOT>";

                    listLoading(true); //20201211 조진호 - 리스트 출력 시 시간이 오래 걸릴 수 있어 로딩바 추가
                    
                    // 개인문서함
	                if (LoadSquery == "usercontlist") {
	                    ContainerID = LoadContID;
	                    subCondition = "";
	                    GetUserContList();
	                } // 부서문서함
	                else if (LoadSquery == "deptcontlist") {
	                    ContainerID = LoadContID;
	                    subCondition = "";
	                    GetDeptContList();
	                }
	                else if (LoadSquery == "aprlist") {
	                    ContainerID = "";
	                    subCondition = LoadContID;
	                    GetDocList();
	                }
	                else if (LoadContID == "GAMSAHAM") {
	                    GamSaFlag = true;
	                    ContainerID = "";
	                    subCondition = LoadSquery;
	                    GetDocList();
	                }
	                else if (LoadSquery != "") {
	                	if (approvalFlag == 'G') {
		                    for (i = 0; i < 25; i++) {
		                        condition[i] = "";
		                    }
		                    ContainerID = LoadContID;
		                    subCondition = "TBL_EXPENDAPRDOCINFO.itemcode = '" + LoadSquery + "'";
		                    pChackYN = "FALSE";
		                    Init_Flag = "False";
		                    GetDocSearch();
	                	} else if (LoadSquery != ""){
	                		// 후결문서함
	                		//2018-10-30 김보미 - ie에서 includes() 지원하지 않는 문제
	                		if(LoadSquery.indexOf('AprType') >= 0) {
	                			checkBujaeInfo();
	                		}
	                		 for (i = 0; i <= 13; i++) {
	                             condition[i] = "";
	                         }
	                         condition[5] = (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01";
	                         condition[6] = nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59";
	                         if (pItemCD != "") {
	                             condition[12] += "CAPR;";
	                             condition[13] += "<ITEMCODE>" + pItemCD + "</ITEMCODE>";
	                         }

	                         if (pEndAprType != "" && pEndAprState != "") {
	                             condition[14] = "EAPRTYPE;";
	                             condition[15] = "<ENDAPRTYPE>" + pEndAprType + "</ENDAPRTYPE>";
	                             condition[16] = "EAPRSTATE;";
	                             condition[17] = "<ENDAPRSTATE>" + pEndAprState + "</ENDAPRSTATE>";
	                             document.getElementById("menuapr").style.display = "";
	                             document.getElementById("menuend").style.display = "none";
	                         }

	                         ContainerID = LoadContID;
	                         subCondition = LoadSquery;
	                         pChackYN = "FALSE";
	                         Init_Flag = "False";
	                         MakeSubCondition();
	                         GetDocSearch();
	                	}
	                } else {
	                    ContainerID = LoadContID;
	                    subCondition = "";
	                    GetDocSearch();
	                    getDataInfo();
	                }
					
                    // 대리결재자 설정에 따른, 버튼 활성화
	                var btnView = "";
	                if(arr_userinfo[7] !== "" && LoadSquery.includes('AprType')) {
		        		btnView = "false";
		        	}
	                btnVisible(btnView);
	                try {
	                    parent.frames["left"].setPresentValue("");
	                } catch (e) { }
	            } catch (e) {
	            }
	            
	            if (approvalFlag != 'G' &&  LoadSquery != 'usercontlist') {
		            AddOption(sel_status, '<spring:message code="ezApprovalG.t1434"/>', 'H');
		            AddOption(sel_status,'<spring:message code="ezApprovalG.t1422"/>', 'I');
		            AddOption(sel_status, '<spring:message code="ezApprovalG.t1687"/>', 'N');
		            AddOption(sel_status, '<spring:message code="ezApproval.t854"/>', 'Y');
	            }
	            
	            // 미리보기 영역 관련 온로드 설정, 테넌트 컨피그에 따라 제어
	            if (useAprPreview == "YES") { // 전자결재 미리보기 영역 활성화 시
		            if (pPreviewShow_HOW == "") {
						if (previewInfo != null && previewInfo.trim() != "") {
							pPreviewShow_HOW = previewInfo;
						} else {
							pPreviewShow_HOW = "OFF";
						}
					}
					if (previewInfo != "H") {
						PreviewRayerChange(pPreviewShow_HOW, 'Container');
					}
					/* 2022-06-29 홍승비 - 우측 미리보기 영역을 위한 온로드 시 리사이즈 동작 추가 */
			    	Window_resize();
	            } else {
					pPreviewShow_HOW = "OFF";
					PreviewRayerChange(pPreviewShow_HOW, 'Container');
				}
	        };
			
	        // 부재자정보 체크
	        function checkBujaeInfo() {
		        var BString = arr_userinfo[7];
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
		
		            tmpStartDate = tmpStartDate.replace("/", ":");
		            tmpEndDate = tmpEndDate.replace("/", ":");
		            
		            if (tmpEndDate < nowDate) {
		                setBujaeOff();
		                checkBujaeInfo_Complete(true);
		                return true;

		            } else if (tmpStartDate > nowDate) {
		            	checkBujaeInfo_Complete("ING");
		                return true;
		            }
		            
		            var pAlertContent = "";
		            
		            if (userLang == "1" || userLang == "3") {
			            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + "<spring:message code='ezApprovalG.t1723'/>" + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
		            }
		            else if (userLang == "2") {
			            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
		            }
		            
		            var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN");
		            if (Rtnval) {
		                checkBujaeInfo_Complete(true);
		            }
		            else {
		                checkBujaeInfo_Complete(false);
		            }
		        } else if(GetBujaeFlag()){
		        	
		        		tmpStartDate = proxyStartDate;
		        		tmpEndDate = proxyEndDate;
		        		
			            var pAlertContent = "";
			            
			            if (userLang == "1" || userLang == "3") {
				            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + "<spring:message code='ezApprovalG.t1723'/>" + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
			            }
			            else if (userLang == "2") {
				            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
			            }

			            var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN");
			            if (Rtnval) {
			                checkBujaeInfo_Complete(true);
			            }
			            else {
			                checkBujaeInfo_Complete(false);
			            }		            	
		        } else {
		            checkBujaeInfo_Complete("ING");
		        }
		    }
		
	        // 부재자정보 return function
		    function checkBujaeInfo_Complete(Rtnval) {
	            if (Rtnval == true) {
	                setBujaeOff();
	                btnVisible("ok");
	            }
	            else if (Rtnval == "ING") { }
	            else {
	                return;
	            }
	        }
		    
			// 부재자설정 off		        
		    function setBujaeOff() {
		    	var result = "";
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujae.do",
		    		data : {
		    				buJae  : "",
		    				proxy  : ""
		    				},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
		        
		        arr_userinfo[7] = "";
		    }
		    
		 	// 부재자설정에 따른 버튼 활성화 
			function btnVisible(val) {
				var scopeDoc = window.document;
				// 메인버튼
    			var mainmenu = scopeDoc.getElementById('mainmenu');
				// 페이지레이어
    			var tblPageRayer = scopeDoc.getElementById('tblPageRayer');
				// 결재리스트
    			var div_scroll = scopeDoc.getElementsByClassName('div_scroll');
				// 타이틀
    			var title_h1 = scopeDoc.getElementsByClassName('title_h1');
				// 결재선
				var div_AprLine = scopeDoc.getElementById('div_AprLine');
				
    			if(val === "ok") {
	    			mainmenu.style.visibility = "visible";
	    			tblPageRayer.style.visibility = "visible";
	    			div_AprLine.style.visibility = "visible";
	    			div_scroll[0].style.visibility = "visible";
	    			title_h1[0].style.visibility = "visible";
    			} else if(val === "false"){
    				mainmenu.style.visibility = "hidden";
	    			tblPageRayer.style.visibility = "hidden";
	    			div_AprLine.style.visibility = "hidden";
	    			div_scroll[0].style.visibility = "hidden";
	    			title_h1[0].style.visibility = "hidden";
    			}
		    }
		    
		    
		    function GetBujaeFlag() {
		        var BString = arr_userinfo[7];
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
					
		            if (tmpStartDate <= "<c:out value = '${nowDate}'/>" && tmpEndDate >= "<c:out value = '${nowDate}'/>") {
		                return true;
		            }
		        } 
		        setBujaeOff();
		        return false;
		    }
		    
	        var SelYearFlag = false;
	        function onSelect_Year() {
	            SelYearFlag = true;
	            if(approvalFlag == 'G' && LoadSquery != "usercontlist") {
					selectYear = GetSelectVal("sel_year");
		            if (selectYear != "ALL") {
		                condition[9] = selectYear;
		                condition[10] = "01";
		                condition[11] = "01";
		                condition[12] = selectYear;
		                condition[13] = "12";
		                condition[14] = "31";
		                condition[24] = "";
		                DocListType == "GetDocSearch";
		                GetDocSearch();
		            } else {
		            	var nowyear = nowDate.substring(0,4);
			            var nowmonth = nowDate.substring(5,7);
			            var nowday = nowDate.substring(8,10);       
		
		                condition[9] = nowyear - 1;
		                condition[10] = nowmonth;
		                condition[11] = nowday;
		                condition[12] = nowyear;
		                condition[13] = nowmonth;
		                condition[14] = nowday;
		                condition[24] = "";
		                DocListType == "GetDocSearch";
		                GetDocSearch();
		            }
	            } else {
	            	if (GetSelectVal("sel_year") != "ALL" || GetSelectVal("who_year") != "ALL") {
	                    if (GetSelectVal("sel_year") != "ALL") {
							selectYear = GetSelectVal("sel_year");
	                        condition[5] = selectYear + "-01-01 00:00:01";
	                        condition[6] = selectYear + "-12-31 23:59:59";
	                        // SQLPARADATA = "<ROOT><TYPE>ENDDATEAF;ENDDATEBF;</TYPE><DATA><ENDDATEAF>" + selectYear + "-01-01 00:00:01</ENDDATEAF><ENDDATEBF>" + selectYear + "-12-31 23:59:59</ENDDATEBF></DATA></ROOT>";
	                    }
	                    else {
							selectYear = GetSelectVal("who_year");
	                        condition[5] = selectYear + "-01-01 00:00:01";
	                        condition[6] = selectYear + "-12-31 23:59:59";
	                        // SQLPARADATA = "<ROOT><TYPE>ENDDATEAF;ENDDATEBF;</TYPE><DATA><ENDDATEAF>" + selectYear + "-01-01 00:00:01</ENDDATEAF><ENDDATEBF>" + selectYear + "-12-31 23:59:59</ENDDATEBF></DATA></ROOT>";
	                    }
	                }
	                else {
						selectYear = "ALL";
	                	var nowyear = nowDate.substring(0,4);
			            var nowmonth = nowDate.substring(5,7);
			            var nowday = nowDate.substring(8,10);       
	                    
	                    var settingmonth = nowDate.substring(5,7);
	                    var settingday = nowDate.substring(8,10);

	                    condition[5] = (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01";
	                    condition[6] = nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59";
	                    // SQLPARADATA = "<ROOT><TYPE>STARTDATEAF;STARTDATEBF;</TYPE><DATA><STARTDATEAF>" + (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01</STARTDATEAF><STARTDATEBF>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</STARTDATEBF></DATA></ROOT>";
	                }
					MakeSubCondition();
	                if (LoadSquery == "usercontlist") {
	                    ContainerID = LoadContID;
	                    GetUserContList();
	                }
	                else if (LoadSquery == "deptcontlist") {
	                    ContainerID = LoadContID;
	                    GetDeptContList();
	                }
	                else
	                    GetDocSearch();
	            }
	        }
	
		    function lvtDetail_SelChange() { }
		    
		    // 전자결재 일반(S)버전에서만 사용하는 문서함검색 함수
		    // var SelCont_dialogArgument = new Array();
		    function SelCont_onclick() {
		        var para;
		        var url = "/ezApprovalG/selectContainer.do"
		        // SelCont_dialogArgument[0] = para;
		        // SelCont_dialogArgument[1] = SelCont_Complete;        
		        // var result = GetOpenWindow(url, "selectContainer", 950, 440, "NO");
				var feature = "status=no,toolbar=no,scroll=no,menubar=no,location=no,width=950px,height=440px,resizable=no";
				ezCommon_cross_dialogArguments[0] = para;
				feature = feature + GetOpenPosition(950, 440);
				showPopup(url, 950, 440, "selectContainer", feature, SelCont_Complete);
		    }
		    
		    function SelCont_Complete(retVal) {
				hidePopup();
		        var i;
		        try {
		            if (retVal == "")
		                return;
		        } catch (e) { console.log(e); }
	
		        ContainerID = "";
		        Init_Flag = "False";
		        
		        for (i = 0; i < retVal.length - 1; i++) {
		            if (retVal[i]) {
		                ContainerID = ContainerID + "'" + retVal[i] + "',";
		            }
		        }
		        
		        ContainerID = ContainerID + "'" + retVal[i] + "'";
		        subCondition = "";
		        
		        /* 2023-09-01 홍승비 - 전자결재 일반버전 > 문서함검색 시 최초 동작에 최근 1년 검색조건 디폴트 추가 (다른 전자결재 검색기능과 동일) */
		        makeDefaultCondition1Year();
		        
		        if (ContainerID != "'undefined'") {
		            document.getElementById("presentcell").innerHTML = unescape("<spring:message code='ezApprovalG.t1516'/>");
		            GetDocSearch(); // 일반버전 검색에 대응하는 함수로 변경
		        }
		    }
		    
		    function SelCont_onclick2(cont, ContainerName) {
		        if (ContainerName == "<spring:message code='ezApprovalG.t1517'/>") {
		            GamSaFlag = true;
	// 	            cont = "";
		        }
		        else {
		            GamSaFlag = false;
		        }
		
		        document.getElementById("presentcell").innerHTML = ContainerName;
		
		        ContainerID = cont;
		        subCondition = "";
		
		        for (var i = 0; i < 25; i++) {
		            condition[i] = "";
		        }
		
		        var nowyear = nowDate.substring(0,4);
	            var nowmonth = nowDate.substring(5,7);
	            var nowday = nowDate.substring(8,10);   
		
		        condition[9] = nowyear - 1;
		        condition[10] = nowmonth;
		        condition[11] = nowday;
		        condition[12] = nowyear;
		        condition[13] = nowmonth;
		        condition[14] = nowday;
		        condition[24] = "";
		        DocListType == "GetDocSearch";
		        GetDocSearch();
		    }
		    function SelCont_onclick3(cont, Containers, ContainerName) {
		        var i;
		        document.getElementById("presentcell").innerHTML = ContainerName;
		
		        for (i = 0; i < 25; i++) {
		            condition[i] = "";
		        }
		        ContainerID = Containers;
		        subCondition = "TBEXPENDAPRDOCINFO.itemcode = '" + cont + "'";
		        pChackYN = "FALSE";
		        Init_Flag = "False";
		        GetDocSearch();
		    }
		    var g_progresswin = null;
		    function showProgress() {
		    }
		
		    function hideProgress() {
		    }
		    // var setsearchinfo_cross_dialogArguments = new Array();
		    // var OpenWin2;
		    function SearchCondi_onclick() {
		        var para = LoadSquery;
		        // setsearchinfo_cross_dialogArguments[0] = para;
		        // setsearchinfo_cross_dialogArguments[1] = SearchCondi_onclick_Complete;
				//
		        // OpenWin2 = window.open("/ezApprovalG/setSearchInfo.do", "setsearchInfo_Cross", GetOpenWindowfeature(510, 405));
		        // try { OpenWin2.focus(); } catch (e) { }
				ezCommon_cross_dialogArguments[0] = para;
				var url = "/ezApprovalG/setSearchInfo.do";
				var height = 405;
				if (para == "usercontlist") height += 45;
				showPopup(url, 510, height, "setsearchInfo_Cross", GetOpenWindowfeature(510, 405), SearchCondi_onclick_Complete);
		    }
		
		    function SearchCondi_onclick_Complete(returnvalue) {
				hidePopup();
		    	isSearch = true;
	    	   for(var i =0; i < returnvalue.length; i++) {
					if (returnvalue[i] == null) {
						returnvalue[i] = "";
					}

                    condition[i] = replaceCond(returnvalue[i]);
               }
	    	   
				var nowyear = nowDate.substring(0,4);
				var nowmonth = nowDate.substring(5,7);
				var nowday = nowDate.substring(8,10);
	    	   
				if (approvalFlag == "G" && LoadSquery != "usercontlist") {
					if (condition[3] == "" && condition[9] == "" && condition[15] == "") {
	    			   	condition[9] = (nowyear-1);
						condition[10] = nowmonth;
						condition[11] = nowday;
						condition[12] = nowyear;
						condition[13] = nowmonth;
						condition[14] = nowday;
	    		   }
				} else {
					if (condition[3] == "" && condition[5] == "" && condition[7] == "") {
						condition[5] = (nowyear-1) + "-" + nowmonth + "-" + nowday + " 00:00:01";
						condition[6] = nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59";
					}
				}

	    	    if (LoadSquery == "usercontlist") {
	    	    	MakeSubCondition();
	    	    	GetUserContList();
	    	    } else if (condition) {
		            Init_Flag = "False";
					MakeSubCondition();
		            GetDocSearch();
		        }
		        $('#sel_year').val("ALL");
		        /* $('#sel_year').selectmenu('refresh'); */
		     
		    }
		    function lvtDoclist_onclick() {
		    }
		
		    function lvtDoclist_onSel_DBclick() {
		        ViewDoc_onclick();
		    }
		    function lvDocList_HeaderClick(pHeaderName) {
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
		
		        pChackYN = "TRUE";
		        if (DocListType == "DocList")
		            GetDocList();
		        else if (DocListType == "GetDocSearch")
		            GetDocSearch();
		        else if (DocListType == "UserContDocList")
		        	GetUserContList();
		        else
		            GetDocList();
		    }
		    function lvtDetail_onclick() {
		    }
		    function lvtDetail_onSel_DBclick() {
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
// 		                    window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA3") + "&deptID=" + encodeURI(tr.getAttribute("DATA4")) + "&docState=012", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
							showPopup("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA3") + "&deptID=" + encodeURI(tr.getAttribute("DATA4")) + "&docState=012", 1155, 460, "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
		                } else {
		                	var heigth = window.screen.availHeight;
				            var width = window.screen.availWidth;
				            var left = (parseInt(width) - 600) / 2;
				            var top = (parseInt(heigth) - 450) / 2;
// 				            window.open("/ezCommon/showPersonInfo.do?id=" + GetAttribute(tr, "DATA4") + "&dept=" + GetAttribute(tr, "DATA6"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1, left=" + left + "px, top=" + top);
				            showPopup("/ezCommon/showPersonInfo.do?id=" + GetAttribute(tr, "DATA4") + "&dept=" + GetAttribute(tr, "DATA6"), 420, 450, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1, left=" + left + "px, top=" + top,  hidePopup);
		                }
		            } else if (jobState == "RECIPENT") {
		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;
		                var left = (parseInt(width) - 540) / 2;
		                var top = (parseInt(heigth) - 220) / 2;
		
		                var isExtYN = tr.getAttribute("DATA3");
		                
		                if (isExtYN.toUpperCase() == "Y") {
		                    var url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + DocID + "&deptID=" + encodeURI(tr.getAttribute("DATA1"));
// 		                    var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
// 		                    feature = feature + GetShowModalPosition(555, 240);
// 		                    var ret = window.showModalDialog(url, "", feature);
// 		                    var ret = window.open(url, "", "height=300px,width=855px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		                    showPopup(url, 855, 300, "", "height=300px,width=855px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1",  hidePopup);
		                } else {
		                	left = (parseInt(width) - 1155) / 2;
					        top = (parseInt(heigth) - 460) / 2;
// 		                    window.open("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + escape(tr.getAttribute("DATA1")) + "&docState=011" + "&aprState=" + escape(tr.getAttribute("DATA4")), "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		                    showPopup("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + escape(tr.getAttribute("DATA1")) + "&docState=011" + "&aprState=" + escape(tr.getAttribute("DATA4")), 1155, 460,  "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
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
	                            Attachfilename = encodeURIComponent(tr.cells[1].innerText);
	                        }

	                        if (AttachUrl != "null") {
//	                             if (GetAttribute(tr,"data4") == "file")
//	                                 window.open(document.location.protocol + "//" + document.location.hostname + "/approvalG/downloadAttach.do?type=APPROVAL&docID=" + GetAttribute(tr, "data3") + "&docStatus=" + tempINGFlag + "&docAttachSn=" + GetAttribute(tr,"data2"));
//	                             else
								//2018-09-12 천성준 - 전자결재 결재문서리스트 하단 첨부탭에서 첨부파일이 문서첨부일경우 문서보기로 열수있게
								try {
									if (GetAttribute(tr,"data4") == strLangCSJ01 || GetAttribute(tr,"data4") == "Document") {
	                                	var tempStr = AttachUrlA1.split("/");
	                                    var docID = tempStr[tempStr.length - 1].replace(AttachUrlA2, '');
	                                    var openLocation;
	                                    
	                                    if (AttachUrlA2.lastIndexOf(".ezd")>0) {
	                                    	docID = docID.substr(0, docID.lastIndexOf("."));
	                                    	AttachUrlA2 = "." + getOriginalFileExtension(AttachUrlA1)
	                                    }
	                                    
	                                    if (AttachUrlA2 == ".hwp") {
											if(useWebHWP == "NO") {
												if (isIE()) {
													openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
												} else {
													var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
													showAlert(pAlertContent);
													return;
												}
											} else {
												openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
											}
	                                    } else {
	                                    	openLocation = "/ezApprovalG/contDocView.do";
	                                    }
	                                    openLocation += "?docID=" + docID + "&docHref=" + AttachUrl + "&formID=&orgDocID=";
// 	                                    openwindow(openLocation, "", 880, 570);
	                                    showPopupSlide(openLocation, 1000, 950, "", GetOpenWindowfeature(1000, 950), hidePopupSlide);
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
		    }
		    function getOriginalFileExtension(filePath) {
		    	var pathLength = filePath.length;
		    	var lastIndexOfDot = filePath.lastIndexOf(".");

		    	if (lastIndexOfDot < 0) {
		    		return "";
		    	}

		    	var ext = trim_Cross(filePath.substr(lastIndexOfDot + 1, filePath.length).toLowerCase());

		    	if (ext === "ezd") {
		    		return getOriginalFileExtension(filePath.substr(0, lastIndexOfDot));
		    	}

		    	return ext;
		    }
		    //START
		    function ViewDoc_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        
		        var selRow = DocList.GetSelectedRows();

		        if (selRow.length <= 0) {
		        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		        	showAlert(pAlertContent);
		            return;
		        }
		        
		        var tr = selRow[0];
		        pURL = tr.getAttribute("DATA2");
		
		        var para = new Array();
		        para[0] = DocID;
		        para[1] = pURL;
		
		        if (tr.getAttribute("DATA10") != "" && tr.getAttribute("DATA10") >= GetTodayDate()) {
		            if (CheckAprLine(tr.getAttribute("DATA1")) == "TRUE") {
		                    chk_Passwd(UserID);
		            } else {
						showAlertUI(strLang580);
		                return;
		            }
		        }
		        else {
		            chk_Passwd_Complete("TRUE");
		        }
		    }
		
		    function chk_Passwd_Complete(Rtn)
		    {
		        if (Rtn == "FALSE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            showAlertUI(pAlertContent);
		            return "";
		        }
		        else if (Rtn == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
					showAlertUI(pAlertContent);
		            return "";
		        }
		        else {
		            var DocList = new ListView();
		            DocList.LoadFromID("DocList");
		            var selRow = DocList.GetSelectedRows();
		            var tr = selRow[0];
		            pURL = tr.getAttribute("DATA2");
					orgCompanyID = tr.getAttribute("ORGCOMPANYID");
		            var formid = tr.getAttribute("DATA6");
		            if (approvalFlag == 'S' ) {
			            var docState =  tr.getAttribute("DATA12");
		            } else {
			            var docState =  tr.getAttribute("DATA7");
		            }
		            var orgdocid = trim_Cross(tr.getAttribute("DATA5"));
		            var openLocation;
		            var tempURL = pURL;
		            
		            if (tempURL.substr(tempURL.length - 4, tempURL.length).toLowerCase() == ".ezd") {
	                	tempURL = tempURL.substr(0, tempURL.length - 4);
	                }
		            
		            if (tempURL.substr(tempURL.length - 3, tempURL.length).toLowerCase() == "hwp") {
		            	if(useWebHWP == "NO") {
			            	if (isIE()) {
				                openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
			                } else {
			                	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
			                	showAlert(pAlertContent);
			                    
			                    return;
			                }
		            	} else {
		            		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
		            	}
		            } else {
	                    openLocation = "/ezApprovalG/contDocView.do";
		            }
		            openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(formid) + "&orgDocID=" + encodeURI(orgdocid) + "&docState=" + docState + "&orgCompanyID=" + encodeURI(orgCompanyID);
		            if(share && share == 'share'){
		            	openLocation += "&share=Y";
		            }
		            // openwindow(openLocation, "", 880, 570);
					showPopupSlide(openLocation, 1000, 950, "", GetOpenWindowfeature(1000, 950), hidePopupSlide);
		        }
		    }
		    //END
		    //기존 시행문변환 로직 주석처리
	        /* function enforce_onclick() {
	            var heigth = window.screen.availHeight;
	            var width = window.screen.availWidth;
	
	            var heigth = heigth - 10;
	            var width = width - 10;
	
	            var para = new Array();
	            para[0] = DocID;
	            para[1] = pURL;
	
	            var left = 0;
	            var top = 0;
	            var openLocation = "";
	            if (UserID.toLowerCase() != WriterID.toLowerCase()) {
	                var InformationString = "<spring:message code='ezApprovalG.t1519'/>";
	                OpenAlertUI(InformationString);
	                return;
	            }
	
	            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	                if ("<c:out value = '${userInfoEnforce}'/>" == "1") {
	                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezEnforce_HWP_Cross.aspx";
	                }
	                else if ("<c:out value = '${userInfoEnforce}'/>" == "2") {
	                    openLocation = "../ezViewHWP/ezConv_HWP_Cross.aspx";
	                }
	                else {
	                    openLocation = "../ezViewHWP/ezConvSend_HWP_Cross.aspx";
	                }
	            }
	            else {
	                if ("<c:out value = '${userInfoEnforce}'/>" == "1") {                    
	                    if (CrossYN())
	                        openLocation = "../enforce/convEnforce_CK.aspx";
	                    else
	                    {
	                        openLocation = "../enforce/convEnforce.aspx";
	                    }
	                }
	                else if ("<c:out value = '${userInfoEnforce}'/>" == "2") {
	                    openLocation = "../enforce/ezConv.aspx";
	                    if (CrossYN()) {
	                        openLocation = "../enforce/ezConv_CK.aspx";
	                    }
	                }
	                else {
	                    openLocation = "../enforce/ezConvSend.aspx";
	                    if (CrossYN()) {
	                        openLocation = "../enforce/ezConvSend_Cross.aspx";
	                    }
	                }
	            }
	            openLocation = openLocation + "?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL) + "&ListSusin=";
	            var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left;
	            window.open(openLocation, "enforce", param);
	        } */
	        // var getformcont_cross_dialogArguments = new Array();
	        function enforce_onclick() {
				var DocList = new ListView();
				DocList.LoadFromID("DocList");
		        
		        var selRow = DocList.GetSelectedRows();
		        if (selRow.length > 0) {
		        	var pWriterID = GetAttribute(selRow[0], "DATA3");
		        	if (pWriterID.toLowerCase() == UserID.toLowerCase()) {
		        		// getformcont_cross_dialogArguments[0] = ""; //parameter가 없다..
			            // getformcont_cross_dialogArguments[1] = enforce_onclick_complete;
		        		
			            enforceDocID = GetAttribute(selRow[0], "DATA1");
			            enforceDocHref = GetAttribute(selRow[0], "DATA2");
			            enforceDocOrgCompanyID = GetAttribute(selRow[0], "ORGCOMPANYID");
			            enforceExt = GetAttribute(selRow[0], "DATA2").indexOf("hwp") > -1 ? "hwp" : "mht";
			            
		        		var pURL = "/ezApprovalG/getFormCont.do?pFormType=004&ext=" + enforceExt; //일반버전의 FormType=004는 시행문
		        		// var getFormCont_Cross = window.open(pURL, "formCont", GetOpenWindowfeature(713, 570));
		        		// try { getFormCont_Cross.focus(); } catch (e) {}
						ezCommon_cross_dialogArguments[0] = "";
						showPopup(pURL, 713, 570, "formCont", GetOpenWindowfeature(713, 570), enforce_onclick_complete);
		        	} else {
						showAlert("<spring:message code='ezApprovalG.t1519'/>");
		        	}
		        } else {
		        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
					showAlert(pAlertContent);
		            return;
		        }
	        }
	        var enforceDocID = "";
	        var enforceDocHref = "";
	        var enforceDocOrgCompanyID = "";
	        var enforceExt = "";
	        function enforce_onclick_complete(ret) {
				hidePopup();
	        	if (ret[0] != "cancel") {
	        	    var isHwp = enforceExt == "hwp";
	        		var pURL = isHwp ? "/ezApprovalG/ezConvSihang_WHWP.do" : "/ezApprovalG/enforceSihangDocView.do";
	        		pURL += "?pFormURL=" + encodeURIComponent(ret[0]);
	        		pURL += "&pFormType=" + encodeURIComponent(ret[1]);
	        		pURL += "&pFormID=" + encodeURIComponent(ret[2]);
	        		pURL +=  (isHwp ? "&docID=" : "&pDocID=") + encodeURIComponent(enforceDocID);
	        		pURL += (isHwp ? "&docHref=" : "&pDocHref=") + encodeURIComponent(enforceDocHref);
	        		pURL += (isHwp ? "&orgCompanyID=" : "&pOrgCompanyID=") + encodeURIComponent(enforceDocOrgCompanyID);

                    var height = window.screen.availHeight;
                    var width = window.screen.availWidth;
                    var height = height - 50;
                    var width = width/2;
					showPopupSlide(pURL, isHwp ? width : 850, isHwp ? height : 900, "", GetOpenWindowfeature(isHwp ? width : 850, isHwp ? height : 900), hidePopupSlide);
	        	}
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
			function Circulation_onclick() {
			    jobState = "CIRCUL";
			    getDataInfo();
			}
			function help_onclick() {
			  	  CallHelp("<spring:message code='ezApprovalG.t904'/>");
		    }
		    function MM_swapImagesub(nSel, e) {
		        if (nSel != g_tagSelectsub) {
		            g_tagSelectsub = nSel;
		
		            var Event = e ? e : window.event;
		            var Element = Event.target ? Event.target : Event.srcElement;
		
		            Element.src = "/images/tab_appsub" + nSel + ".gif";
		
		            var i;
		            for (i = 1 ; i <= 4; i++) {
		                if (g_tagSelectsub != i) {
		                    var str = "tagsub" + i + ".src" + "=" + "\"/images/tab_appsub" + i + "a.gif\"";
		
		                    eval(str);
		                }
		            }
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

		                pleftpos = parseInt(width) - 967;
		                heigth = parseInt(heigth) - 30;
		                if (CrossYN())
		                    heigth = parseInt(heigth) - 25;

		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		                    heigth = parseInt(heigth) - 40;
		                width = parseInt(width) - pleftpos;
		                left = pleftpos / 2;
		            }
		            else {
		                heigth = parseInt(heigth) - 30;
		                if (CrossYN())
		                    heigth = parseInt(heigth) - 25;

		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		                    heigth = parseInt(heigth) - 40;
		                width = parseInt(width) - 10;
		            }
		
		            window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
		        }
		        catch (e) {
		            showAlert("openwindow :: " + e.description);
		        }
		    }
		    function onchange_objSelForm(p_strVal) {
		        GetDocList(p_strVal);
		    }
		    function btnExcel_onclick(AllFG) {
		        var url;
		        if (typeof (ContainerID) == "undefined")
		            ContainerID = "";
		
		        if (typeof (subCondition) == "undefined")
		            subCondition = "";
		
		        var tempPageSize = PageSize;
		        var tempPageNum = "1";
		        if (AllFG != 1) {
		            tempPageSize = PageSize;
		            tempPageNum = curpage;
		        }
				
		        if (LoadSquery == "usercontlist") {
  		      		ContainerID = LoadContID;
        	 		subCondition = "";
           	  		GetUserContListSave(AllFG);
                } else {
			        if (GamSaFlag) {
			            url = "../excelExportOutGS.aspx";
			        } else {
			            url = "/ezApprovalG/excelExportOut.do";
			        }
			
			        // 2024-03-07 기준으로 DocListType 변수를 "DocList"로 설정하는 코드 미존재, 해당 if 분기는 의미가 없음 
			        if (DocListType == "DocList") {
			            url += "?listType=DOC&cont=" + encodeURI(ContainerID) + "&PN=" +
			                encodeURI(tempPageNum) + "&PS=" + encodeURI(tempPageSize) + "&OC=" + encodeURI(OrderCell) +
			                "&OO=" + encodeURI(OrderOption) + "&allFG=" + AllFG ;
		        	} else {
		        		/*var myApprFrom = condition[7];
		        		var myApprTo = condition[8];
		        		var apprFrom = condition[5];
	        			var apprTo = condition[6];
	        			var draftFrom = condition[3];
	        			var draftTo = condition[4];*/
						if (typeof (condition[24]) != "undefined" && condition[24] != "") {
							if (subCondition) {
								subCondition += "AND ";
							}
							subCondition += "KEYWORD like '%" + condition[24].slice(5) + "%'";
						}
	        			var searchStatus = $("#sel_status").val();
	        			if(searchStatus && searchStatus != "ALL"){
	        				searchStatus = "PROCESSYN = '" + searchStatus + "'";
							if (subCondition) {
								searchStatus = " AND " + searchStatus;
							}
	        			} else {
	        				searchStatus = "";
	        			}
	        			
		        		/*if(condition[7] != "" && condition[6] == "") {
		        			condition[15] = condition[7].substring(0,4);
		        			condition[16] = condition[7].substring(5,7);
		        			condition[17] = condition[7].substring(8,10);
		        			
		        			condition[18] = condition[8].substring(0,4);
		        			condition[19] = condition[8].substring(5,7);
		        			condition[20] = condition[8].substring(8,10);
		        		}
		        		
		        		if(condition[6] != "" && condition[7] == "") {
		        			condition[9] = condition[5].substring(0,4);
		        			condition[10] = condition[5].substring(5,7);
		        			condition[11] = condition[5].substring(8,10);
		        			
		        			condition[12] = condition[6].substring(0,4);
		        			condition[13] = condition[6].substring(5,7);
		        			condition[14] = condition[6].substring(8,10);
		        		}
		        		
		        		if(condition[4] != "" && condition[5] == "") {
		        			condition[3] = draftFrom.substring(0,4);
		        			condition[4] = draftFrom.substring(5,7);
		        			condition[5] = draftFrom.substring(8,10);
		        			
		        			condition[6] = draftTo.substring(0,4);
		        			condition[7] = draftTo.substring(5,7);
		        			condition[8] = draftTo.substring(8,10);
		        		} */
		        		
		        		/* 2020-10-29 홍승비 - 양식별 문서함 엑셀로 내보내기 시, P12/P24에 양식함 ID 전달 */
		        		if (LoadSquery.indexOf("FORMNAME") > -1) {
		        			if (approvalFlag == "S") {
		        				condition[12] = ContainerID;
		        			} else {
		        				condition[24] = ContainerID;
		        			}
		        		}
		        		
		        		/* 2023-07-21 한태훈 - 전자결재 일반 버전 > 부서문서함, 분류코드문서함 내보내기시 양식함 아이디가 null로 넘어가
		        		 결재완료문서 리스트가 다운로드 되는 오류 수정 */ 
		        		if (approvalFlag == "S") {
		        			condition[12] = ContainerID;
		        		}
		        		
		                url += "?listType=SEARCH&P0=" + encodeURI(condition[0]) + "&P1=" +
		                encodeURI(condition[1]) + "&P2=" + encodeURI(condition[2]) + "&P3=" + encodeURI(condition[3]) +
		                "&P4=" + encodeURI(condition[4]) + "&P5=" + encodeURI(condition[5]) + "&P6=" + encodeURI(condition[6]) +
		                "&P7=" + encodeURI(condition[7]) + "&P8=" + encodeURI(condition[8]) + "&P9=" + encodeURI(condition[9]) +
		                "&P10=" + encodeURI(condition[10]) + "&P11=" + encodeURI(condition[11]) + "&P12=" + encodeURI(condition[12]) +
		                "&P13=" + encodeURI(condition[13]) + "&P14=" + encodeURI(condition[14]) + "&P15=" + encodeURI(condition[15]) +
		                "&P16=" + encodeURI(condition[16]) + "&P17=" + encodeURI(condition[17]) + "&P18=" + encodeURI(condition[18]) +
		                "&P19=" + encodeURI(condition[19]) + "&P20=" + encodeURI(condition[20]) + "&P21=" + encodeURI(condition[21]) +
		                "&P22=" + encodeURI(condition[22]) + "&P23=" + encodeURI(condition[23]) + "&P24=" + encodeURI(ContainerID) +
		                "&PN=" + encodeURI(tempPageNum) + "&PS=" + encodeURI(tempPageSize) + "&OC=" + encodeURI(OrderCell) +
		                "&OO=" + encodeURI(OrderOption) + "&SQ=" + encodeURI(subCondition + searchStatus)+ "&allFG=" + AllFG + "&KW=" + condition[24];
		               
		                // 2023-07-21 한태훈 - 부서공유함에서 회사가 다를 시, 엑셀 내보내기 안되는 오류 수정.
		                if (orgCompanyID != null && orgCompanyID != "") {
		        			url += "&orgCompanyID=" + encodeURI(orgCompanyID);
		                }
		                
		                /*for(var i=3; i<=20; i++) {
		                	condition[i] = "";
		                }
		                
		                condition[7] = myApprFrom;
		        		condition[8] = myApprTo;
		        		condition[5] = apprFrom;
	        			condition[6] = apprTo;
	        			condition[3] = draftFrom;
	        			condition[4] = draftTo;*/
		        	}
			        
		        	window.frames["saveExcel"].location.href = url;
                }
		    }
		    
		    function SelEDMFolder_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		
		        if (selRow.length <= 0) {
		            var InformationString = "<spring:message code='ezApprovalG.t1520'/>";
					showAlertUI(InformationString);
		            return;
		        }
		        var param = new Array();
		        param[0] = "";
		        var url = "/myoffice/ezApprovalG/ezDMSConnector/SelectFolder.aspx";
		        var feature = "dialogWidth:365px;dialogHeight:450px;status:no; scroll:no; help:no;edge:sunken";
		        feature = feature + GetShowModalPosition(365, 450);
		        var rtn = window.showModalDialog(url, param, feature);
		
		        if (rtn[0] == "OK") {
		            var xmlhttp = createXMLHttpRequest();
		            var xmlpara = createXmlDom();
		
		            var objNode, objRoot, objDocid;
		            objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
		            createNodeAndInsertText(xmlpara, objNode, "DESTFOLD", rtn[1]);
		            var list = createNodeAndAppandNode(xmlpara, objRoot, list, "DOCIDS");
		
		            for (var i = 0; i < selRow.length; i++) {
		                var tr = selRow[i];
		
		                createNodeAndAppandNodeText(xmlpara, list, objDocid, "DOCID", tr.getAttribute("DATA1"));
		            }
		            xmlhttp.open("POST", "aspx/getEDMxmlForDoc.aspx", false);
		            xmlhttp.send(xmlpara);
		
		            var xmlhttp2 = createXMLHttpRequest();
		            xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezDMSConnector/aspx/SendDocDataToEDM.aspx", false);
		            xmlhttp2.send(xmlhttp.responseXML);
		
		            if (xmlhttp2.responseText == "TRUE") {
		                var xmlhttp3 = createXMLHttpRequest();
		                xmlhttp3.open("POST", "aspx/setEDMSYN.aspx", false);
		                xmlhttp3.send(xmlpara);
		
		                if (xmlhttp3.responseText == "TRUE") {
		                    var InformationString = "EDMS " + "<spring:message code='ezApprovalG.t1521'/>";
							showAlertUI(InformationString);
		
		                    if (DocListType == "DocList")
		                        GetDocList();
		                    else if (DocListType == "GetDocSearch")
		                        GetDocSearch();
		
		                    return;
		                }
		                else {
		                    var InformationString = "EDMS " + "<spring:message code='ezApprovalG.t1522'/>";
							showAlertUI(InformationString);
		                    return;
		                }
		            }
		            else {
		                var InformationString = "EDMS " + "<spring:message code='ezApprovalG.t1523'/>";
						showAlertUI(InformationString);
		                return;
		            }
		        }
		    }
		    function btnAddJob_onclick() {
		        var parameter = "";
		        var url = "../ezDocInfo/ezSubTitle_Cross.aspx?id=" + escape(UserID);
		        var feature = "status:no;dialogWidth:280px;dialogHeight:259px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(280, 259);
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
		    				companyName : "<c:out value = '${userInfo.companyName}'/>",
		    				companyName2 : "<c:out value = '${userInfo.companyName2}'/>"
	        				},
	        		success: function(xml){
	        		}        			
	        	});
		    }
		    window.onbeforeunload = function () {
		        try {
		        } catch (e) { }
		    };
		    function goToPage(page) {
		
		        var goPage = page;
		        if (isNaN(goPage) || goPage == "")
		            return;
		
		        if (parseInt(goPage) < 1 || parseInt(goPage) > parseInt(totalPages))
		            return;
		        curpage = parseInt(goPage);
		        pChackYN = "TRUE";
		        if (DocListType == "DocList")
		            GetDocList();
		        else if (DocListType == "GetDocSearch")
		            GetDocSearch();
		        else if (DocListType == "UserContDocList")
		            GetUserContList();
		        else if (DocListType == "DeptContDocList")
		            GetDeptContList();
		    }
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        
	        	var nowyear = nowDate.substring(0,4);
	            var nowmonth = parseInt(nowDate.substring(5,7));
	            var nowday = parseInt(nowDate.substring(8,10)); 
	
		        if (document.getElementById("sel_year").value.toLowerCase() == "all" && isSearch == false) {
	            	/* if (condition[5] != null && condition[5] != "" && condition[5].length >= 10) {
			            period = condition[5].substring(0, 4) + strLang1028 + " " + condition[5].substring(5, 7) + strLang1029 + " " + condition[5].substring(8,10) + strLang1030 + " ~ " + condition[6].substring(0, 4) + strLang1028 + " " + condition[6].substring(5, 7) + strLang1029 + " " + condition[6].substring(8, 10) + strLang1030;
	            	} else if (condition[3] != null && condition[3] != "" && condition[3].length >= 10) {
			            period = condition[3].substring(0, 4) + strLang1028 + " " + condition[3].substring(5, 7) + strLang1029 + " " + condition[3].substring(8,10) + strLang1030 + " ~ " + condition[4].substring(0, 4) + strLang1028 + " " + condition[4].substring(5, 7) + strLang1029 + " " + condition[4].substring(8, 10) + strLang1030;
	            	} else if (condition[7] != null && condition[7] != "" && condition[7].length >= 10) {
			            period = condition[7].substring(0, 4) + strLang1028 + " " + condition[7].substring(5, 7) + strLang1029 + " " + condition[7].substring(8,10) + strLang1030 + " ~ " + condition[8].substring(0, 4) + strLang1028 + " " + condition[8].substring(5, 7) + strLang1029 + " " + condition[8].substring(8, 10) + strLang1030;
	            	}else {
		            	period = (nowyear - 1) + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030 + " ~ " + nowyear + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030;
	            	} */
	            	
	            	//2018-09-07 배현상, 년도 선택 시 한자리 숫자인 월 앞에 0이 붙지 않도록 변경
	            	if (condition[5] != null && condition[5] != "" && condition[5].length >= 10) {
	            		period = getDatePeriod(userLang, condition[5].substring(0, 4), parseInt(condition[5].substring(5, 7)), parseInt(condition[5].substring(8,10)), condition[6].substring(0, 4), parseInt(condition[6].substring(5, 7)), parseInt(condition[6].substring(8, 10)));
	            	} else if (condition[3] != null && condition[3] != "" && condition[6] != null && condition[6] != "" && condition[3].length <= 4 && condition[6].length <= 4) {
	            		period = getDatePeriod(userLang, condition[3], condition[4], condition[5], condition[6], condition[7], condition[8]);
	            	} else if (condition[9] != null && condition[9] != "" && condition[12] != null && condition[12] != "" && condition[9].length <= 4 && condition[12].length <= 4) {
	            		period = getDatePeriod(userLang, condition[9], condition[10], condition[11], condition[12], condition[13], condition[14]);
	            	} else if (condition[15] != null && condition[15] != "" && condition[18] != null && condition[18] != "" && condition[15].length <= 4 && condition[18].length <= 4) {
	            		period = getDatePeriod(userLang, condition[15], condition[16], condition[17], condition[18], condition[19], condition[20]);
	            	} else {
	            		period = getDatePeriod(userLang, (nowyear - 1), nowmonth, nowday, nowyear, nowmonth, nowday);
	            	}
	            	
		        }
		        else {
		        	if ((GetSelectVal("sel_year") != "ALL" || GetSelectVal("who_year") != "ALL") && isSearch == false) {
		        		if (GetSelectVal("sel_year") != "ALL") {
		                	period = getDatePeriod(userLang, document.getElementById("sel_year").value, 1, 1, document.getElementById("sel_year").value, 12, 31);
		                } else {
		                	period = getDatePeriod(userLang, document.getElementById("who_year").value, 1, 1, document.getElementById("who_year").value, 12, 31);
		                }
		            }		        
	            	//2019-01-24 김민성 - 검색시 기간 설정 수정
	            	else {
	            		//S와 G가 날짜조건을 다른 배열에 담아와서 구분함.
	            		if (approvalFlag == "G") {
	            			var tempStartDate = "";
	            			var tempEndDate = "";
	            			
	            			if (condition[3] != null && condition[3] != "" && condition[6] != null && condition[6] != "") {
	            				tempStartDate = getDateStrByLang(userLang, condition[3], parseInt(condition[4]), parseInt(condition[5]));
	            				tempEndDate = getDateStrByLang(userLang, condition[6], parseInt(condition[7]), parseInt(condition[8]));
	            			} else if (condition[9] != null && condition[9] != "" && condition[12] != null && condition[12] != "") {
	            				tempStartDate = getDateStrByLang(userLang, condition[9], parseInt(condition[10]), parseInt(condition[11]));
	            				tempEndDate = getDateStrByLang(userLang, condition[12], parseInt(condition[13]), parseInt(condition[14]));
	            			} else if (condition[15] != null && condition[15] != "" && condition[18] != null && condition[18] != "") {
	            				tempStartDate = getDateStrByLang(userLang, condition[15], parseInt(condition[16]), parseInt(condition[17]));
	            				tempEndDate = getDateStrByLang(userLang, condition[18], parseInt(condition[19]), parseInt(condition[20]));
	            			} else {
	            				tempStartDate = getDateStrByLang(userLang, (nowyear - 1), nowmonth, nowday);
	            				tempEndDate = getDateStrByLang(userLang, nowyear, nowmonth, nowday);
	            			}
	            			
	            			period = tempStartDate + " ~ " + tempEndDate;
	            		} else {
	            			if(condition[3] != null && condition[3] != "") {
			            		period = getDatePeriod(userLang, condition[3].substring(0,4), parseInt(condition[3].substring(5,7)), parseInt(condition[3].substring(8,10)), condition[4].substring(0,4), parseInt(condition[4].substring(5,7)), parseInt(condition[4].substring(8,10)));
			            	} else if(condition[5] != null && condition[5] != "") {
			            		period = getDatePeriod(userLang, condition[5].substring(0,4), parseInt(condition[5].substring(5,7)), parseInt(condition[5].substring(8,10)), condition[6].substring(0,4), parseInt(condition[6].substring(5,7)), parseInt(condition[6].substring(8,10)));
			            	} else if(condition[7] != null && condition[7] != "") {
			            		period = getDatePeriod(userLang, condition[7].substring(0,4), parseInt(condition[7].substring(5,7)), parseInt(condition[7].substring(8,10)), condition[8].substring(0,4), parseInt(condition[8].substring(5,7)), parseInt(condition[8].substring(8,10)));
			            	} else {
			            		period = getDatePeriod(userLang, (nowyear - 1), nowmonth, nowday, nowyear, nowmonth, nowday);
			            	}
	            		}
	            	}
		        }
		
		        document.getElementById("TitleInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color' style='font-weight:bold;'> " + NodeListLen + " </span>&nbsp;/ " + period;
		
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var totalPage = totalPages;
		        var pageNum = curpage;
		        if (totalPage > 1 && pageNum != 1) {
		            // strtext = "<span class='btnimg'><a onclick= 'return goToPageByNum(1)'>";
		            // strtext = strtext + "<img src='/images/kr/cm/btn_p_prev.gif' /></a></span>";
					strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            // strtext = "<span class='btnimg'><a >";
		            // strtext = strtext + "<img src='/images/kr/cm/btn_p_prev01.gif' /></a></span>";
					strtext = "<span class='btnimg first disabled'></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                // strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'>";
		                // strtext = strtext + "<img src='/images/kr/cm/btn_prev.gif' ></span>";
						strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                // strtext = "<span class='btnimg'>";
		                // strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif'></span>";
						strtext = "<span class='btnimg prev disabled'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            // strtext = "<span class='btnimg'>";
		            // strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif'></span>";
					strtext = "<span class='btnimg prev disabled'></span>";
		            PagingHTML += strtext;
		        }
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        }
		        else {
		            MaxNum = totalPage;
		        }
		        
		        if(totalPage == "0") {
		        	MaxNum = 1;
		        }
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span onclick = 'goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                // strtext = "<span class='btnimg' onclick='return selafterBlock()'>";
		                // strtext = strtext + "<img src='/images/kr/cm/btn_next.gif'></span>";
						strtext = "<span class='btnimg next' onclick='return selafterBlock()'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                // strtext = "<span class='btnimg'>";
		                // strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif'></span>";
						strtext = "<span class='btnimg next disabled'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            // strtext = "<span class='btnimg'>";
		            // strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif'></span>";
					strtext = "<span class='btnimg next disabled'></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            // strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'>";
		            // strtext = strtext + "<img src='/images/kr/cm/btn_n_next.gif' /></span>";
					strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            // strtext = "<span class='btnimg'>";
		            // strtext = strtext + "<img src='/images/kr/cm/btn_n_next01.gif' /></span>";
					strtext = "<span class='btnimg last disabled'></span>";
		            PagingHTML += strtext;
		        }
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		        
		        listLoading(false);	// 20201211 조진호 로딩바 display:none
		        
		        isSearch = false;
		    }
		    function goToPageByNum(Value) {
		        curpage = Value;
		        makePageSelPage();
		        goToPage(Value);
		    }
		    function selbeforeBlock() {
		        var pageNum = curpage;
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selbeforeBlock_one() {
		        var pageNum = curpage;
		        var totalPage = totalPages;
		        if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
		        else
		            return;
		    }
		    function selafterBlock() {
		        var pageNum = curpage;
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selafterBlock_one() {
		        var pageNum = curpage;
		        var totalPage = totalPages;
		        if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }
		    //function GongRamDocInfo() {
		    //    var tr = lvtDoclist.getMultiRowIndex();
		    //    if (tr.length > 0) {
		    //        var heigth = window.screen.availHeight;
		    //        var width = window.screen.availWidth;
		    //        var left = (parseInt(width) - 525) / 2;
		    //        var top = (parseInt(heigth) - 220) / 2;
		    //        window.open("../ezDocInfo/ezLineInfo.aspx?pDocID=" + lvtDoclist.getvalue3(tr[0], 0, "DATA1") + "&pDeptID=&pDocState=015", "", "height=220px,width=525px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    //    }
		    //}
		    function GongRamDocInfo() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		
		        if (selRow.length > 0) {
		            var tr = selRow[0];
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = (parseInt(width) - 1155) / 2;
		            var top = (parseInt(heigth) - 460) / 2;
		            window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA1") + "&deptID=&docState=015", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        }
		        else {
                    OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
                }
		    }
		
		    var pSaveDocID = ""; // 통합PC저장을 위한 전역변수
		    var pSaveOrgCompanyID = "";
		    function TotalSave_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var tr = DocList.GetSelectedRows();
		        
		        if (tr.length == 0) {
		        	//팝업창에서 알럿창으로 변경
// 		            OpenAlertUI("<spring:message code='ezApprovalG.t113'/>");
					var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
					showAlert(pAlertContent);
		            return;
		        }
		        else {
		        	pSaveDocID = tr[0].getAttribute("DATA1");
		        	pSaveOrgCompanyID = tr[0].getAttribute("orgCompanyID");
		        }
		        
		        /* 2021-10-21 홍승비 - 결재완료문서 통합 PC 저장 시 보안결재 확인동작 추가 */
				if (tr[0].getAttribute("DATA10") != "" && tr[0].getAttribute("DATA10") >= GetTodayDate()) {
		            if (CheckAprLine(tr[0].getAttribute("DATA1")) == "TRUE") {
		            	chk_Passwd(UserID, chk_Passwd_CompleteSave);
		            } else {
						showAlertUI(strLang580);
		                return;
		            }
		        } else {
		        	TotalSave_onclick_complete(pSaveDocID, pSaveOrgCompanyID);
		        }
		    }
		    
		    // 통합 PC 저장 시 보안결재 > 패스워드 확인 후 동작
			function chk_Passwd_CompleteSave(Rtn) {
		        if (Rtn == "FALSE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
					showAlertUI(pAlertContent);
		        }
		        else if (Rtn == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
					showAlertUI(pAlertContent);
		        }
		        else {
		        	TotalSave_onclick_complete(pSaveDocID, pSaveOrgCompanyID);
		        }
		    }
		    
		    // 실제 통합 PC 저장 동작 분리 (완료문서, 부서문서함)
		    function TotalSave_onclick_complete(pDocID, orgCompanyID) {
		        var url = "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=END&orgCompanyID="+orgCompanyID;
		        var feature = "status=no,help=no,scroll=no,edge=sunken,width=580px,height=480px";
		        feature = feature + GetOpenPosition(580, 480);
		        // window.open(url, "", feature);
				showPopup(url, 580, 480, "", feature, DivPopUpHidden);
		    }
		
		    window.onresize = function () {
		        var height = parseInt(divList.style.height.replace('px', '')) + 200;
		//150709 이윤호 리사이즈 예외처리
		//        var reheight = window.innerHeight - parseInt(height);
		        var reheight = document.documentElement.offsetHeight - parseInt(height);
		        if (reheight < 0) {
		            reheight = 0;
		        }
		        //document.getElementById('div_AprLine').style.height = reheight + "px";
		        
		        /* 2022-06-24 홍승비 - 우측 미리보기 영역을 위한 리사이즈 동작 추가 */
		    	Window_resize();
		    };
		
		    function ShowMailProgress() {
		        document.getElementById("loadingPanel").style.display = "";
		        document.getElementById("loadingProgress").style.top = "400px";
		        document.getElementById("loadingProgress").style.left = (CurrenWidth / 2) - 100 + "px";
		        document.getElementById("loadingProgress").style.display = "";
		    }
		    function HiddenMailProgress() {
		        document.getElementById("loadingPanel").style.display = "none";
		        document.getElementById("loadingProgress").style.display = "none";
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
		        if (document.getElementById("txt_keyword").value != "") {
		        	isSearch = true;
		            var selectSearch = document.getElementById('selectType');

					/*
		            for (var i = 0; i < 25; i++) {
		                condition[i] = "";
		            } */
		
		            if (selectSearch.item(0).selected) {
		                condition[1] = replaceCond(document.getElementById("txt_keyword").value);
						condition[2] = "";
		            }
		            else if (selectSearch.item(1).selected) {
						condition[1] = "";
		                condition[2] = replaceCond(document.getElementById("txt_keyword").value);
		            }

					/*
		            var nowyear = nowDate.substring(0,4);
		            var nowmonth = nowDate.substring(5,7);
		            var nowday = nowDate.substring(8,10);

		            if (approvalFlag == "G") {
		            	condition[9] = (nowyear-1);
		            	condition[10] = nowmonth;
		            	condition[11] = nowday;
		            	condition[12] = nowyear;
		            	condition[13] = nowmonth;
		            	condition[14] = nowday;
		            } else {
		            	condition[5] = (nowyear-1) + "-" + nowmonth + "-" + nowday + " 00:00:01";
		            	condition[6] = nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59";
		            } */
		        }
		        else {
		            showAlert("<spring:message code='ezApprovalG.t1160'/>");
		            return;
		        }
		        pageNum = 1;
		        Init_Flag = "False";

		        if (LoadSquery == "usercontlist") {
		        	MakeSubCondition();
	    	    	GetUserContList();
		        } else {
		       		GetDocSearch();
		        }
		
		        $('#sel_year').val(selectYear);
		        /* $('#sel_year').selectmenu('refresh'); */
		    }
	    
		    function resend_onclick() {
		        var para = new Array()
		        para[0] = DocID;
		        para[1] = pURL;
		        var openLocation = "";
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var tr = DocList.GetSelectedRows();

		        if (tr.length <= 0) {
		        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		        	showAlert(pAlertContent);
		            return;
		        }
		        
		        if (UserID.toLowerCase() != WriterID.toLowerCase()) {
		            var InformationString = "<spring:message code='ezApproval.t579'/>";
		            //2018-09-20 김보미 - 팝업창 확인 안닫히는 문제
 		            //OpenAlertUI(InformationString, "OPEN");
					showAlertUI(InformationString);
		            return;
		        }
	
		        if (GetAttribute(tr[0], "DATA12") == strDocState4) {
		            var InformationString = "<spring:message code='ezApproval.t580'/>";
					showAlertUI(InformationString, "OPEN");
		            return;
		        }
	
		        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "doc") {
		            if (CrossYN()) {
		                openLocation = "/myoffice/ezApproval/enforce/convEnforce_Cross.aspx?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL) + "&ListSusin=";
		            }
		            else {
	                    openLocation = "/myoffice/ezApproval/enforce/convEnforce.aspx?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL) + "&ListSusin=";
		            }
		        }
		        else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
		            openLocation = "";
		            if (CrossYN()) {
		                showAlert(strLang1103);
		                return;
		            }
		            else {
	                    openLocation = "/myoffice/ezApproval/enforce/convEnforce.aspx?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL) + "&ListSusin=";
		            }
		        }
		        else {
		            if (CrossYN())
		                openLocation = "/ezApprovalG/docReSend.do";
		            else {
	                    openLocation = "/myoffice/ezApproval/enforce/ezReSend.aspx";
		            }
		            openLocation = openLocation + "?docID=" + escape(DocID) + "&docHref=" + encodeURI(pURL);
		        }
		        // var result = GetOpenWindow(openLocation, "", 1000, 950, "NO");
				showPopupSlide(openLocation, 1000, 950, "", GetOpenWindowfeature(1000, 950), hidePopupSlide);
		    }
		    
		    var aprgongramline_cross_dialogArguments = new Array();
		    function sendCirCulation_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var tr = DocList.GetSelectedRows();
		        
		        if (tr.length <= 0) {
		        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		        	showAlert(pAlertContent);
		            return;
		        }
	
		        if (GetAttribute(tr[0], "DATA12") != strDocState1) {
		            var InformationString = "<spring:message code='ezApprovalG.hyj26'/>";
					showAlertUI(InformationString, "OPEN");
		            return;
		        }
		        
		        var url = "/ezApprovalG/aprGongRamLine.do?type=END";
		    	var para = new Array()
		        para[0] = DocID;
		        para[1] = pURL;
				
	            // aprgongramline_cross_dialogArguments[0] = para;
	            // aprgongramline_cross_dialogArguments[1] = sendCirCulation_onclick_Complete;
				//
	            // var OpenWin = window.open(url, "AprGongRamLine_Cross", GetOpenWindowfeature(1145, 760));
	            // try { OpenWin.focus(); } catch (e) { }
				ezCommon_cross_dialogArguments[0] = para;
				showPopup(url, 1145, 760, "AprGongRamLine_Cross", GetOpenWindowfeature(1145, 760), sendCirCulation_onclick_Complete);
		    }

		    function sendCirCulation_onclick_Complete(rtn) {
		        hidePopup();
				if (rtn == "OK") {
		            var pAlertContent = "<spring:message code='ezApprovalG.hyj27'/>";
					showAlertUI(pAlertContent);
		        }
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
		    
		    //2018-10-01 김보미 - 년도가 string값이 아니라 발생하는 버그 수정
		    function replaceCond(condStr){//검색조건 수정(% _ ' 추가)
		    	return condStr.toString().replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/%/g, "\\%").replace(/'/g, "\\'").replace(/_/g, "\\_");
		    }
		    
		    function onSelect_Status() {
		    	subCondition = "";
		    	GetDocSearch();
		    }
		    
		    /* 2019-01-02 천성준 #14647
		            결재암호 사용유무 조회 (Y / N)
		    */
		    function CheckUsePassword() {
		    	var result = "";
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getApprovalPWD.do",
		    		success: function(text) {
		    			result = text;
		    		}        			
		    	});
		    	
		    	if (result != "N") {
		    		return true;
		    	} else {
		    		return false;
		    	}
		    }
		    
		    function btn_newpopup() {
		    	lvtDoclist_onSel_DBclick();
		    }
		    
	        /* 2023-09-01 홍승비 - 전자결재 일반버전 > 문서함검색 시 최초 동작에 최근 1년 검색조건 디폴트 추가 (다른 전자결재 검색기능과 동일) */
	        function makeDefaultCondition1Year() {
				for (var i = 0; i < 25; i++) {
					condition[i] = "";
		        }
	        	
		        var nowyear = nowDate.substring(0, 4);
	            var nowmonth = nowDate.substring(5, 7);
	            var nowday = nowDate.substring(8, 10);
	            
	            condition[5] = (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:01";
				condition[6] = nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59";
				
				$('#sel_year').val("ALL"); // 우측 상단 년도 선택 영역 최근 1년으로 갱신 (val의 설정으로는 문서 리스트를 갱신하지 않음)
	        }
	        
	    </script>
	</head>
	<body class="mainbody" style="margin-top:0px; overflow:auto;" marginwidth="0" marginheight="0" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	    <div id="MOC_Div" style="display: none"></div>
	    <h1 class="title_h1"><span id="presentcell"></span><span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
	        <span class="searchForm">
	        	<select id="selectType" class="text" style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezApprovalG.t106'/></option>
		    		<option value="rad_Writer"><spring:message code='ezApprovalG.t445'/></option>
		    	</select>
		        <input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	            <a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search()"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul id="menuend" style="display:none">
	        	<c:if test ="${approvalFlag == 'S'}">	        	
		            <li class="important" id="tresend" style="display: none"><span id="resend" onClick="return resend_onclick()" ><spring:message code='ezApprovalG.t940'/></span></li>
		            <li class="important" id="tsendCir" style="display: none"><span id="sendCir" onClick="return sendCirCulation_onclick()" ><spring:message code='ezApprovalG.hyj25'/></span></li>
	            </c:if>
	            <li id="tbar1" style="background: none; padding-right: 2px; display: none;">
	            <li id="tdEDMFolder" style="display: none"><span id="SelEDMFolder" onclick="return SelEDMFolder_onclick()"><spring:message code='ezApprovalG.t1525'/></span></li>
	            <c:if test ="${approvalFlag == 'S'}">
	            	<c:choose>
	            		<c:when test="${useEnforceSihang == 'YES'}">
				            <li id="tenforce"><span id="enforce" onclick="return enforce_onclick()"><spring:message code='ezApprovalG.t1524'/></span></li>
	            		</c:when>
	            		<c:otherwise>
	            		<span style="display: none;">
				            <li id="tenforce"><span id="enforce" onclick="return enforce_onclick()"><spring:message code='ezApprovalG.t1524'/></span></li>
	            		</span>
	            		</c:otherwise>
	            	</c:choose>
	            	<li id="tViewDoc"><span id="ViewDoc" onClick="return ViewDoc_onclick()" ><spring:message code='ezApprovalG.t367'/></span></li>
			        <li id="tbtnExcel"><span id="btnExcel" onclick="return btnExcel_onclick(0)"><spring:message code='ezApprovalG.t1526'/></span></li>
	            	<li id="tbtnExcelAll"><span id="btnExcelAll" onclick="return btnExcel_onclick(1)"><spring:message code='ezApprovalG.t1527'/></span></li>      
			        <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
			        <li id=tbtnRegUserCont><span id=btnRegUserCont onClick ="return btnRegUserCont_onclick()" ><spring:message code='ezApproval.t589'/></span></li>
			        <c:if test ="${share != 'share'}">			<!-- 구문서함 아닐때만 나오도록 수정 -->
			            <li id="tbtnSelContainer"><span onclick="return SelCont_onclick()"><spring:message code='ezApprovalG.t1516'/></span></li>
		            </c:if>
				    <li id="tSearchCondi"><span class="icon16 icon16_search" id="SearchCondi" onClick="return SearchCondi_onclick()" ></span></li>
			        <li id=tbtnRemoveDoc><span class="icon16 icon16_delete" id=btnRemoveDoc onClick ="return btnRemoveDoc_onclick()"></span></li>
			        <!-- <li id="Li2" style="background: none; padding-right: 2px;">
			        <img src="/images/i_bar.gif"></li> -->
	            </c:if>
	            <c:if test ="${approvalFlag == 'G'}">
	            	<li id="tViewDoc"><span id="ViewDoc" onclick="return ViewDoc_onclick()"><spring:message code='ezApprovalG.t367'/></span></li>
	            	<li id="tDocInfo"><span id="DocInfo" onclick="return GongRamDocInfo()"><spring:message code='ezApprovalG.t946'/></span></li>
	            	<li id="tbtnExcel"><span id="btnExcel" onclick="return btnExcel_onclick(0)"><spring:message code='ezApprovalG.t1526'/></span></li>
	            	<li id="tbtnExcelAll"><span id="btnExcelAll" onclick="return btnExcel_onclick(1)"><spring:message code='ezApprovalG.t1527'/></span></li>		            
		            <!-- <li id="tbar2" style="background: none; padding-right: 2px; display: none;"><img src="/images/i_bar.gif"></li> -->
		            <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
					<c:if test ="${useUserCont == 'YES'}">
						<li id=tbtnRegUserCont><span id=btnRegUserCont onClick ="return btnRegUserCont_onclick()" ><spring:message code='ezApproval.t589'/></span></li>
					</c:if>
		            <li id="tSearchCondi"><span class="icon16 icon16_search" id="SearchCondi" onclick="return SearchCondi_onclick()"></span></li>
					<c:if test ="${sQuery == 'usercontlist'}">
						<li id=tbtnRemoveDoc><span class="icon16 icon16_delete" id=btnRemoveDoc onClick ="return btnRemoveDoc_onclick()"></span></li>
					</c:if>	
		            <!-- <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li> -->
	            </c:if>
				<c:if test="${null eq sQuery || sQuery eq '' }">
                    <%-- 전자결재 우측 미리보기 상단 아이콘 --%>
                    <div id="right" class="sub_frameIcon" <c:if test="${useAprPreview != 'YES'}">style="display:none;"</c:if>>
                        <div class="sub_frameIconUL" style="width:auto !important;">
                            <p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE', 'Manage')"></span></p>
                            <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H', 'Manage')"></span></p>
                        </div>
                    </div>
				</c:if>
	            <!-- <img src="/images/i_bar.gif"> -->
	            <li style="vertical-align: middle; float:right">
	            	<select id="sel_year" name="sel_year" style="height:29px;" onchange="onSelect_Year(this);">
		            	<option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option>
		        	</select>
		        </li>
		        	<c:if test = "${approvalFlag != 'G' && sQuery != 'usercontlist'}">
		        		<li style="vertical-align: middle; float:right">
		        			<div id="sel_status_div" style="display:inline;">
							<select id="sel_status" name="sel_status" onchange="onSelect_Status(this);">    
								<option value="ALL"><spring:message code='ezPoll.t104'/></option>
			        		</select>  
		        			</div>
		        		</li>
		        	</c:if>  
		        
	        </ul>
	        <!-- 	        후결 문서함 -->
	    	<ul id="menuapr" style="display:none">
		        <li id="tViewDocApr"><span id="ViewDocApr" onClick="return ViewDoc_onclick()" ><spring:message code='ezApproval.pjj35'/></span></li>
		        <li id="Li1"><span id="Span1" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        <li id="tSearchCondiApr"><span class="icon16 icon16_search" id="SearchCondiApr" onClick="return SearchCondi_onclick()" ></span></li>
			<c:if test="${null ne sQuery && sQuery ne '' }">
                 <%-- 전자결재 우측 미리보기 상단 아이콘 --%>
                 <div id="right" class="sub_frameIcon" <c:if test="${useAprPreview != 'YES'}">style="display:none;"</c:if>>
                     <div class="sub_frameIconUL" style="width:auto !important;">
                         <p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE', 'Manage')"></span></p>
                         <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H', 'Manage')"></span></p>
                     </div>
                 </div>
	        </c:if>
		        <li style="vertical-align: middle; float:right">
		        	<select id="who_year" name="who_year" style="height:29px;" onchange="onSelect_Year(this);">
		            	<option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option>
		        	</select>  
		        </li>
      		</ul>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="ResizeBarPanel"></div>
	    <div style="width: 8px; height: 738px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	   	<span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
		    <div class="div_scroll" style="width:100%;HEIGHT:480px; overflow:AUTO; margin-bottom:10px;" id="divList">
		        <div id="lvtDoclist"></div>
		    </div>
		    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="loadingPanel" onclick="ContextMenuHidden();"></div>
		    <div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingProgress">
		        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
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
					    <c:if test="${approvalFlag != 'G'}">
						   	<p><span id="tagsub5"><spring:message code='ezApprovalG.hyj24'/></span></p>
					    </c:if>
				  	</div>	
				</div>
		
		        <div style="WIDTH:100%;HEIGHT:171px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
		            <div id="lvtDetail" style="border: 0;"></div>
		        </div>
		    </div>
		</span>
		
		<%-- 전자결재 우측 미리보기 영역 --%>
		<div id="PreviewRayerH" style="border:0px; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
	        <div class="previewmail_bar_h" id="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block; height:753px;">
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

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel2">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer2"></iframe>
		</div>
	    
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        //selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	        Tab1_NewTabIni("tab1");
	    </script>
	
	    <iframe id="saveExcel" name="saveExcel" style="display: none" ></iframe>
	</body>
</html>
