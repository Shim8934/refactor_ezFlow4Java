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
	    <link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
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
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var labelcolor = "gray";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var ContainerID, UserID, DocID, DeptID, jobState, pURL, subCondition;
	        var condition = new Array("");
	        var g_tagSelectsub = "1";
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, DocListType;
	        var NodeList2, PageSize, ListView;
	        var contFlag = "${contType}";
	        var pSusinManagerFlag = "user";
	        var UserID = "${userInfo.id}";
	        var Block_Size, WriterID;
	        var docdir = "";
	        var OrderOption = "";
	        var OrderCell = "";
	        var pEndDocHref = '${dirPath}';
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName}";
	        arr_userinfo[3] = "${userInfo.title}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName}";
	        arr_userinfo[6] = "${userInfo.jikChek}";
	        arr_userinfo[8] = "${userInfo.email}";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "${susinAdmin}";
	        arr_userinfo[11] = "${userInfo.displayName1}";
	        arr_userinfo[12] = "${userInfo.displayName2}";
	        arr_userinfo[13] = "${userInfo.title1}";
	        arr_userinfo[14] = "${userInfo.title2}";
	        arr_userinfo[15] = "${userInfo.deptName1}";
	        arr_userinfo[16] = "${userInfo.deptName2}";
	        var LoadContID = "${contID}";
	        var LoadSquery = "${sQuery}";
	        var GamSaFlag = false;
	        var CompanyID = "${userInfo.companyID}";
	        var USE_OCS = "${useOcs}";
	        var Udomain = "${userEmail}";
	        var pOpenYaer = "${openYear}";
			var approvalFlag = "${approvalFlag}"
	        var CurrentHeight = 0;
	        var CurrentWidth = 0;
	        var pItemCD = ""; 
	        var pEndAprType = "${endAprType}";
	        var pEndAprState = "${endAprState}";
	        var pUse_Editor = "${useEditor}";
	        var DocType = "";
 	        var DocState = "";
 	        var period;
 	        var pDocInfoValue = "1";
 	       	var nowDate = "${nowDateUTC}";
 	        
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
	
	            //document.getElementById('div_AprLine').style.height = reheight + "px";
	
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
	            var toDayYear = parseInt(nowDate.substring(0,4));
	            var minusYear = parseInt(nowDate.substring(0,4)) - parseInt(pOpenYaer);
	            for (var i = toDayYear; i >= toDayYear - minusYear ; i--)
	                AddOption(sel_year, i, i);
	
	            try {
	                if ("${type}" == "1")
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
	                
					if(approvalFlag == "G") {
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

	                if (LoadSquery == "usercontlist") {
	                    ContainerID = LoadContID;
	                    subCondition = "";
	                    GetUserContList();
	                }
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
	                }
	
	                try {
	                    parent.frames["left"].setPresentValue("");
	                } catch (e) { }
	
	            } catch (e) {
	            }
	        };
	
	        var SelYearFlag = false;
	        function onSelect_Year() {
	            SelYearFlag = true;
	            if(approvalFlag == 'G') {
		            if (GetSelectVal("sel_year") != "ALL") {
		                condition[9] = GetSelectVal("sel_year");
		                condition[10] = "01";
		                condition[11] = "01";
		                condition[12] = GetSelectVal("sel_year");
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
	                        condition[5] = GetSelectVal("sel_year") + "-01-01 00:00:01";
	                        condition[6] = GetSelectVal("sel_year") + "-12-31 23:59:59";
	                        SQLPARADATA = "<ROOT><TYPE>ENDDATEAF;ENDDATEBF;</TYPE><DATA><ENDDATEAF>" + GetSelectVal("sel_year") + "-01-01 00:00:01</ENDDATEAF><ENDDATEBF>" + GetSelectVal("sel_year") + "-12-31 23:59:59</ENDDATEBF></DATA></ROOT>";
	                    }
	                    else {
	                        condition[5] = GetSelectVal("who_year") + "-01-01 00:00:01";
	                        condition[6] = GetSelectVal("who_year") + "-12-31 23:59:59";
	                        SQLPARADATA = "<ROOT><TYPE>ENDDATEAF;ENDDATEBF;</TYPE><DATA><ENDDATEAF>" + GetSelectVal("who_year") + "-01-01 00:00:01</ENDDATEAF><ENDDATEBF>" + GetSelectVal("who_year") + "-12-31 23:59:59</ENDDATEBF></DATA></ROOT>";
	                    }
	                }
	                else {
	                	var nowyear = nowDate.substring(0,4);
			            var nowmonth = nowDate.substring(5,7);
			            var nowday = nowDate.substring(8,10);       
	                    
	                    var settingmonth = nowDate.substring(5,7);
	                    var settingday = nowDate.substring(8,10);

	                    condition[5] = (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01";
	                    condition[6] = nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59";
	                    SQLPARADATA = "<ROOT><TYPE>STARTDATEAF;STARTDATEBF;</TYPE><DATA><STARTDATEAF>" + (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01</STARTDATEAF><STARTDATEBF>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</STARTDATEBF></DATA></ROOT>";
	                }

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
		    
		    var SelCont_dialogArgument = new Array();
		    function SelCont_onclick() {
		        var para;
		        var url = "/ezApprovalG/selectContainer.do"
		        SelCont_dialogArgument[0] = para;
		        SelCont_dialogArgument[1] = SelCont_Complete;        
		        var result = GetOpenWindow(url, "selectContainer", 950, 440, "NO");
		    }
		    
		    function SelCont_Complete(retVal) {
		        var i;
		        try {
		            if (retVal == "")
		                return;
		        } catch (e) { }
	
		        ContainerID = "";
		        Init_Flag = "False";
	
		        for (i = 0; i < retVal.length - 1; i++) {
		            if (retVal[i]) {
		                ContainerID = ContainerID + "'" + retVal[i] + "',";
		            }
		        }
	
		        ContainerID = ContainerID + "'" + retVal[i] + "'";
		        subCondition = "";
		        if (ContainerID != "'undefined'") {
		            document.getElementById("presentcell").innerHTML = unescape("<spring:message code='ezApprovalG.t1516'/>");
		            GetDocList();
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
		    var setsearchinfo_cross_dialogArguments = new Array();
		    var OpenWin2;
		    function SearchCondi_onclick() {
		        var para = LoadSquery;
		        setsearchinfo_cross_dialogArguments[0] = para;
		        setsearchinfo_cross_dialogArguments[1] = SearchCondi_onclick_Complete;
		
		        OpenWin2 = window.open("/ezApprovalG/setSearchInfo.do", "setsearchInfo_Cross", GetOpenWindowfeature(510, 375));
		        try { OpenWin2.focus(); } catch (e) { }
		    }
		
		    function SearchCondi_onclick_Complete(returnvalue) {
	    	   for(var i =0; i < returnvalue.length; i++) {
		        	condition[i] = returnvalue[i]; 
		        }
	    	   
	    	    if (LoadSquery == "usercontlist") {
	    	    	MakeSubCondition();
	    	    	GetUserContList();
	    	    } else if (condition) {
		            Init_Flag = "False";
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
		            if (jobState == "APPROVAL") {
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
				            window.open("/ezCommon/showPersonInfo.do?id=" + GetAttribute(tr, "DATA4"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1, left=" + left + "px, top=" + top);
		                }
		            } else if (jobState == "RECIPENT") {
		                var heigth = window.screen.availHeight;
		                var width = window.screen.availWidth;
		                var left = (parseInt(width) - 540) / 2;
		                var top = (parseInt(heigth) - 220) / 2;
		
		                var isExtYN = tr.getAttribute("DATA3");
		                
		                if (isExtYN.toUpperCase() == "Y") {
		                    var url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + DocID + "&deptID=" + encodeURI(tr.getAttribute("DATA1"));
		                    var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
		                    feature = feature + GetShowModalPosition(555, 240);
		                    var ret = window.showModalDialog(url, "", feature);
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
//	                             if (GetAttribute(tr,"data4") == "file")
//	                                 window.open(document.location.protocol + "//" + document.location.hostname + "/approvalG/downloadAttach.do?type=APPROVAL&docID=" + GetAttribute(tr, "data3") + "&docStatus=" + tempINGFlag + "&docAttachSn=" + GetAttribute(tr,"data2"));
//	                             else
	                                window.open("/ezApprovalG/downloadAttach.do?fileName=" + Attachfilename + "&filePath=" + AttachUrl, "_self");
	                        }

	                    }
		            }
		        }
		    }
		    //START
		    function ViewDoc_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();
		        var tr = selRow[0];
		        pURL = tr.getAttribute("DATA2");
		
		        var para = new Array();
		        para[0] = DocID;
		        para[1] = pURL;
		
		        if (tr.getAttribute("DATA10") != "" && tr.getAttribute("DATA10") >= GetTodayDate()) {
		            if (CheckAprLine(tr.getAttribute("DATA1")) == "TRUE") {
		                if ("${approvalPWD}" != "N") {
		                    chk_Passwd(UserID);
		                }
		                else {
		                    chk_Passwd_Complete("TRUE");
		                }
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t1518'/>","OPEN");
		                return "";
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
		            OpenAlertUI(pAlertContent);
		            return "";
		        }
		        else if (Rtn == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		            OpenAlertUI(pAlertContent);
		            return "";
		        }
		        else {
		            var DocList = new ListView();
		            DocList.LoadFromID("DocList");
		            var selRow = DocList.GetSelectedRows();
		            var tr = selRow[0];
		            pURL = tr.getAttribute("DATA2");
		
		            var formid = tr.getAttribute("DATA6");
		            if (approvalFlag == 'S' ) {
			            var docState =  tr.getAttribute("DATA12");
		            } else {
			            var docState =  tr.getAttribute("DATA7");
		            }
		            var orgdocid = trim_Cross(tr.getAttribute("DATA5"));
		            var openLocation;
		            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
		            	if (isIE()) {
			                openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
		                } else {
		                	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
		                	alert(pAlertContent);
		                    
		                    return;
		                }
		            } else {
	                    openLocation = "/ezApprovalG/contDocView.do";
		            }
		            openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(formid) + "&orgDocID=" + encodeURI(orgdocid) + "&docState=" + docState;
		            openwindow(openLocation, "", 880, 570);
		        }
		    }
		    //END
		
	        function enforce_onclick() {
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
	                if ("${userInfoEnforce}" == "1") {
	                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezEnforce_HWP_Cross.aspx";
	                }
	                else if ("${userInfoEnforce}" == "2") {
	                    openLocation = "../ezViewHWP/ezConv_HWP_Cross.aspx";
	                }
	                else {
	                    openLocation = "../ezViewHWP/ezConvSend_HWP_Cross.aspx";
	                }
	            }
	            else {
	                if ("${userInfoEnforce}" == "1") {                    
	                    if (CrossYN())
	                        openLocation = "../enforce/convEnforce_CK.aspx";
	                    else
	                    {
	                        openLocation = "../enforce/convEnforce.aspx";
	                    }
	                }
	                else if ("${userInfoEnforce}" == "2") {
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
		            alert("openwindow :: " + e.description);
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
			
			        if (DocListType == "DocList") {
			            url += "?listType=DOC&cont=" + encodeURI(ContainerID) + "&PN=" +
			                encodeURI(tempPageNum) + "&PS=" + encodeURI(tempPageSize) + "&OC=" + encodeURI(OrderCell) +
			                "&OO=" + encodeURI(OrderOption) + "&allFG=" + AllFG ;
		        	} else {
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
		                "&OO=" + encodeURI(OrderOption) + "&SQ=" + encodeURI(subCondition)+ "&allFG=" + AllFG ;
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
		            OpenAlertUI(InformationString);
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
		                    OpenAlertUI(InformationString);
		
		                    if (DocListType == "DocList")
		                        GetDocList();
		                    else if (DocListType == "GetDocSearch")
		                        GetDocSearch();
		
		                    return;
		                }
		                else {
		                    var InformationString = "EDMS " + "<spring:message code='ezApprovalG.t1522'/>";
		                    OpenAlertUI(InformationString);
		                    return;
		                }
		            }
		            else {
		                var InformationString = "EDMS " + "<spring:message code='ezApprovalG.t1523'/>";
		                OpenAlertUI(InformationString);
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
		    				companyName : "${userInfo.companyName}",
		    				companyName2 : "${userInfo.companyName2}"
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
	
		        if (document.getElementById("sel_year").value.toLowerCase() == "all") {
		        	var nowyear = nowDate.substring(0,4);
		            var nowmonth = nowDate.substring(5,7);
		            var nowday = nowDate.substring(8,10); 
		            
	            	/* if (condition[5] != null && condition[5] != "" && condition[5].length >= 10) {
			            period = condition[5].substring(0, 4) + strLang1028 + " " + condition[5].substring(5, 7) + strLang1029 + " " + condition[5].substring(8,10) + strLang1030 + " ~ " + condition[6].substring(0, 4) + strLang1028 + " " + condition[6].substring(5, 7) + strLang1029 + " " + condition[6].substring(8, 10) + strLang1030;
	            	} else if (condition[3] != null && condition[3] != "" && condition[3].length >= 10) {
			            period = condition[3].substring(0, 4) + strLang1028 + " " + condition[3].substring(5, 7) + strLang1029 + " " + condition[3].substring(8,10) + strLang1030 + " ~ " + condition[4].substring(0, 4) + strLang1028 + " " + condition[4].substring(5, 7) + strLang1029 + " " + condition[4].substring(8, 10) + strLang1030;
	            	} else if (condition[7] != null && condition[7] != "" && condition[7].length >= 10) {
			            period = condition[7].substring(0, 4) + strLang1028 + " " + condition[7].substring(5, 7) + strLang1029 + " " + condition[7].substring(8,10) + strLang1030 + " ~ " + condition[8].substring(0, 4) + strLang1028 + " " + condition[8].substring(5, 7) + strLang1029 + " " + condition[8].substring(8, 10) + strLang1030;
	            	}else {
		            	period = (nowyear - 1) + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030 + " ~ " + nowyear + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030;
	            	} */
	            	
	            	if (condition[5] != null && condition[5] != "" && condition[5].length >= 10) {
	            		period = condition[5].substring(0, 4) + strLang1028 + " " + condition[5].substring(5, 7) + strLang1029 + " " + condition[5].substring(8,10) + strLang1030 + " ~ " + condition[6].substring(0, 4) + strLang1028 + " " + condition[6].substring(5, 7) + strLang1029 + " " + condition[6].substring(8, 10) + strLang1030;
	            	} else if (condition[3] != null && condition[3] != "" && condition[6] != null && condition[6] != "" && condition[3].length <= 4 && condition[6].length <= 4) {
	            		period = condition[3]+strLang1028+" "+condition[4]+strLang1029+" "+condition[5]+strLang1030+" ~ "+condition[6]+strLang1028+" "+condition[7]+strLang1029+" "+condition[8]+strLang1030;
	            	} else if (condition[9] != null && condition[9] != "" && condition[12] != null && condition[12] != "" && condition[9].length <= 4 && condition[12].length <= 4) {
	            		period = condition[9]+strLang1028+" "+condition[10]+strLang1029+" "+condition[11]+strLang1030+" ~ "+condition[12]+strLang1028+" "+condition[13]+strLang1029+" "+condition[14]+strLang1030;
	            	} else if (condition[15] != null && condition[15] != "" && condition[18] != null && condition[18] != "" && condition[15].length <= 4 && condition[18].length <= 4) {
	            		period = condition[15]+strLang1028+" "+condition[16]+strLang1029+" "+condition[17]+strLang1030+" ~ "+condition[18]+strLang1028+" "+condition[19]+strLang1029+" "+condition[20]+strLang1030;
	            	} else {
	            		period = (nowyear - 1) + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030 + " ~ " + nowyear + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030;
	            	}
		        }
		        else {
		        	if (GetSelectVal("sel_year") != "ALL" || GetSelectVal("who_year") != "ALL") {
		                if (GetSelectVal("sel_year") != "ALL")
				            period = document.getElementById("sel_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("sel_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
		                else
				            period = document.getElementById("who_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("who_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
		            }		        
		        }
		
		        document.getElementById("TitleInfo").innerHTML = " &nbsp;[" + strLang942 + "<span style='color:#017BEC;font-weight:bold;'> " + NodeListLen + " </span>" + strLang943 + " - " + period + "]";
		
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var totalPage = totalPages;
		        var pageNum = curpage;
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg'><a onclick= 'return goToPageByNum(1)'>";
		            strtext = strtext + "<img src='/images/kr/cm/btn_p_prev.gif' /></a></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'><a >";
		            strtext = strtext + "<img src='/images/kr/cm/btn_p_prev01.gif' /></a></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'>";
		                strtext = strtext + "<img src='/images/kr/cm/btn_prev.gif' ></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg'>";
		                strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='btnimg'>";
		            strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif'></span>";
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
		                strtext = "<span class='btnimg' onclick='return selafterBlock()'>";
		                strtext = strtext + "<img src='/images/kr/cm/btn_next.gif'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg'>";
		                strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='btnimg'>";
		            strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif'></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'>";
		            strtext = strtext + "<img src='/images/kr/cm/btn_n_next.gif' /></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'>";
		            strtext = strtext + "<img src='/images/kr/cm/btn_n_next01.gif' /></span>";
		            PagingHTML += strtext;
		        }
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
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
		    }
		
		    function TotalSave_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var tr = DocList.GetSelectedRows();
		
		        if (tr.length == 0) {
		            OpenAlertUI("<spring:message code='ezApprovalG.t113'/>");
		            return;
		        }
		        else
		            pDocID = tr[0].getAttribute("DATA1");
		
		        var url = "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=END";
		        var feature = "status=no,help=no,scroll=no,edge=sunken,width=580px,height=450px";
		        feature = feature + GetOpenPosition(580, 450);
		        window.open(url, "", feature);
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
		            var selectSearch = document.getElementById('selectType');
		
		            for (var i = 0; i < 25; i++) {
		                condition[i] = "";
		            }
		
		            if (selectSearch.item(0).selected) {
		                condition[1] = document.getElementById("txt_keyword").value;
		            }
		            else if (selectSearch.item(1).selected) {
		                condition[2] = document.getElementById("txt_keyword").value;
		            }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1160'/>");
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
		
		        $('#sel_year').val("ALL");
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

		        if (UserID.toLowerCase() != WriterID.toLowerCase()) {
		            var InformationString = "<spring:message code='ezApproval.t579'/>";
		            OpenAlertUI(InformationString, "OPEN");
		            return;
		        }
	
		        if (GetAttribute(tr[0], "DATA12") == strDocState4) {
		            var InformationString = "<spring:message code='ezApproval.t580'/>";
		            OpenAlertUI(InformationString, "OPEN");
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
		                alert(strLang1103);
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
		        var result = GetOpenWindow(openLocation, "", 1000, 950, "NO");
		    }
		    
		    var aprgongramline_cross_dialogArguments = new Array();
		    function sendCirCulation_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var tr = DocList.GetSelectedRows();
	
		        if (GetAttribute(tr[0], "DATA12") != strDocState1) {
		            var InformationString = "<spring:message code='ezApprovalG.hyj26'/>";
		            OpenAlertUI(InformationString, "OPEN");
		            return;
		        }
		        
		        var url = "/ezApprovalG/aprGongRamLine.do?type=END";
		    	var para = new Array()
		        para[0] = DocID;
		        para[1] = pURL;
				
	            aprgongramline_cross_dialogArguments[0] = para;
	            aprgongramline_cross_dialogArguments[1] = sendCirCulation_onclick_Complete;
	
	            var OpenWin = window.open(url, "AprGongRamLine_Cross", GetOpenWindowfeature(1145, 760));
	            try { OpenWin.focus(); } catch (e) { }
		    }

		    function sendCirCulation_onclick_Complete(rtn) {
		        if (rtn == "OK") {
		            var pAlertContent = "<spring:message code='ezApprovalG.hyj27'/>";
		            OpenAlertUI(pAlertContent);
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
	    </script>
	</head>
	<body class="mainbody" style="margin-top: 0px">
	    <div id="MOC_Div" style="display: none"></div>
	    <h1><span id="presentcell"></span><span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
	        <span style="float:right;font-weight:normal;color:black;">
	        	<select id="selectType" style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezApprovalG.t106'/></option>
		    		<option value="rad_Writer"><spring:message code='ezApprovalG.t445'/></option>
		    	</select>
		        <input id="txt_keyword" style="height: 27px;border: 1px solid #cbcbcb; border-right:0px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	            <a href="#" style="float:right"><img src="/images/bsearch_new.gif" border="0" onClick="search()"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul id="menuend">
	        	<c:if test ="${approvalFlag == 'S'}">	        	
	            <li id="tresend" style="display: none"><span id="resend" onClick="return resend_onclick()" ><spring:message code='ezApprovalG.t940'/></span></li>
	            <li id="tsendCir" style="display: none"><span id="sendCir" onClick="return sendCirCulation_onclick()" ><spring:message code='ezApprovalG.hyj25'/></span></li>
<!-- 	            시행문 변환 추후 개발 -->
				<div style="display: none">
		            <li id="tenforce" style="display: none"><span id="enforce" onclick="return enforce_onclick()"><spring:message code='ezApprovalG.t1524'/></span></li>
				</div>
	            <li id=tbtnRegUserCont><span id=btnRegUserCont onClick ="return btnRegUserCont_onclick()" ><spring:message code='ezApproval.t589'/></span></li>
	            </c:if>
	            <li id="tbar1" style="background: none; padding-right: 2px; display: none;">
	            <li id="tdEDMFolder" style="display: none"><span id="SelEDMFolder" onclick="return SelEDMFolder_onclick()"><spring:message code='ezApprovalG.t1525'/></span></li>
	            <li id="tbtnExcel"><span id="btnExcel" onclick="return btnExcel_onclick(0)"><spring:message code='ezApprovalG.t1526'/></span></li>
	            <li id="tbtnExcelAll"><span id="btnExcelAll" onclick="return btnExcel_onclick(1)"><spring:message code='ezApprovalG.t1527'/></span></li>
	            <c:if test ="${approvalFlag == 'S'}">
	            <!-- <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif"></li> -->
	            <li id=tbtnRemoveDoc><span id=btnRemoveDoc onClick ="return btnRemoveDoc_onclick()"><spring:message code='ezApprovalG.t266'/></span></li>
	            <c:if test ="${tmpValue !='' && contID !=''}">
		            <li><span onclick="return SelCont_onclick()"><spring:message code='ezApprovalG.t1516'/></span></li>
	            </c:if>
			    <li id="tSearchCondi"><span id="SearchCondi" onClick="return SearchCondi_onclick()" ><spring:message code='ezApprovalG.t111'/></span></li>
		        <li id="tViewDoc"><span id="ViewDoc" onClick="return ViewDoc_onclick()" ><spring:message code='ezApprovalG.t367'/></span></li>      
		        <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        <!-- <li id="Li2" style="background: none; padding-right: 2px;">
		        <img src="/images/i_bar.gif"></li> -->
	            </c:if>
	            <c:if test ="${approvalFlag == 'G'}">
	            <li id="tDocInfo"><span id="DocInfo" onclick="return GongRamDocInfo()"><spring:message code='ezApprovalG.t946'/></span></li>
	            <!-- <li id="tbar2" style="background: none; padding-right: 2px; display: none;"><img src="/images/i_bar.gif"></li> -->
	            <li id="tSearchCondi"><span id="SearchCondi" onclick="return SearchCondi_onclick()"><spring:message code='ezApprovalG.t111'/></span></li>
	            <li id="tViewDoc"><span id="ViewDoc" onclick="return ViewDoc_onclick()"><spring:message code='ezApprovalG.t367'/></span></li>
	            <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	            <!-- <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li> -->
	            </c:if>
	            <!-- <img src="/images/i_bar.gif"> -->
	            <li style="vertical-align: middle;">
	            	<select id="sel_year" name="sel_year" style="height:29px;" onchange="onSelect_Year(this);">
		            	<option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option>
		        	</select>  
		        </li>
	        </ul>
	        <!-- 	        후결 문서함 -->
	    	<ul id="menuapr">
		        <li id="tViewDocApr"><span id="ViewDocApr" onClick="return ViewDoc_onclick()" ><spring:message code='ezApproval.pjj35'/></span></li> 
		        <li id="tSearchCondiApr"><span id="SearchCondiApr" onClick="return SearchCondi_onclick()" ><spring:message code='ezApprovalG.t111'/></span></li>
		        <li id="Li1"><span id="Span1" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        <!-- <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li> -->
		        <li style="vertical-align: middle;">
		        	<select id="who_year" name="who_year" style="height:29px;" onchange="onSelect_Year(this);">
		            	<option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option>
		        	</select>  
		        </li>
      		</ul>
	    </div>
	    <div class="div_scroll" style="width:100%;HEIGHT:360px; overflow:AUTO" id="divList">
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
	
	        <div style="WIDTH:100%;HEIGHT:230px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
	            <div id="lvtDetail" style="border: 0;"></div>
	        </div>
	    </div>
	
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        //selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	        Tab1_NewTabIni("tab1");
	    </script>
	
	    <iframe id="saveExcel" name="saveExcel" style="display: none" ></iframe>
	</body>
</html>
