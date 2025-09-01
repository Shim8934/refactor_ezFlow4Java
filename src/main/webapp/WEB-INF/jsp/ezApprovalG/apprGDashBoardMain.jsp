<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html style="height:100%;">
	<head>
		<title>index_Approval</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprmanage_Cross.js')}"></script>
        <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
        <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfo_Cross.js')}"></script>
	</head>
	
	<body class="db_body" style="margin:0px; overflow:auto;">
	    <div class="statistics_wrap">
            <%-- 미결재 건수 --%>
            <div class="statistics">
                <div class="tit">
                    <p><spring:message code="ezPersonal.dashBoard03"/></p>
                </div>
                <div id="divMonth">
                    <div class="time">
                        <p><spring:message code="ezPersonal.dashBoard07"/><span id="OTHER">0</span></p>
                    </div>
                    <div class="graph_box">
                        <ul class="txt">
                            <li class="my"><spring:message code="ezPersonal.dashBoard08"/></li>
                            <li class="department"><spring:message code="ezPersonal.dashBoard09"/></li>
                            <li class="headquarters"><spring:message code="ezPersonal.dashBoard010"/></li>
                            <li class="company"><spring:message code="main.t00010"/></li>
                        </ul>
                        <div class="graph">
                            <ul>
                                <li><div class="bar my"><span id="ONEDAY"></span></div></li>
                                <li><div class="bar department"><span id="TWODAY"></span></div></li>
                                <li><div class="bar headquarters"><span id="THREEDAY"></span></div></li>
                                <li><div class="bar company"><span id="OTHER2"></span></div></li>
                            </ul>
                            <div class="display first">
                                <span class="bar"></span>
                                <span class="num">5<spring:message code='ezPersonal.dashBoard011'/></span>
                            </div>
                            <div class="display second">
                                <span class="bar"></span>
                                <span class="num">10<spring:message code='ezPersonal.dashBoard011'/></span>
                            </div>
                            <div class="display third">
                                <span class="bar"></span>
                                <span class="num">15<spring:message code='ezPersonal.dashBoard011'/></span>
                            </div>
                            <div class="display forth">
                                <span class="bar"></span>
                                <span class="num">20<spring:message code='ezPersonal.dashBoard011'/></span>
                            </div>
                            <div class="display fifth">
                                <span class="bar"></span>
                                <span class="num">25<spring:message code='ezPersonal.dashBoard011'/></span>
                            </div>
                            <div class="display sixth">
                                <span class="bar"></span>
                                <span class="num">30<spring:message code='ezPersonal.dashBoard011'/></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%-- 대시보드 카운트 --%>
			<div class="document_info">
                <ul>
                    <li class="approval" onclick="dashBoardBoxClick(1)">
                        <dl>
                            <dt><spring:message code='ezApprovalG.t1747'/></dt>
                            <dd><span id="dashboardCnt1">0</span><spring:message code='ezApprovalG.t1702'/></dd>
                        </dl>
                    </li>
                    <li class="ing" onclick="dashBoardBoxClick(3)">
                        <dl>
                            <dt><spring:message code='ezApprovalG.t1706'/></dt>
                            <dd><span id="dashboardCnt2">0</span><spring:message code='ezApprovalG.t1702'/></dd>
                        </dl>
                    </li>
                    <li class="department" onclick="dashBoardBoxClick(4)">
                        <dl>
                            <dt><spring:message code='ezApprovalG.t1749'/></dt>
                            <dd><span id="dashboardCnt3">0</span><spring:message code='ezApprovalG.t1702'/></dd>
                        </dl>
                    </li>
                    <li class="reference" onclick="dashBoardBoxClick(24)">
                        <dl>
                            <dt><spring:message code='ezApprovalG.t1756'/></dt>
                            <dd><span id="dashboardCnt4">0</span><spring:message code='ezApprovalG.t1702'/></dd>
                        </dl>
                    </li>
                </ul>
            </div>
		</div>
        <%-- 진행문서 --%>
        <div class="payment_template">
        <div class="template_box">
            <div class="top_tit"><spring:message code='ezApprovalG.t1706'/></div>
            <div class="conts_box">
                <ul class="payment_ing" id="progressDoc"></ul>
            </div>
        </div>
        <%-- 지연문서 --%>
        <div class="left_box">
            <div class="template_box mb0">
                <div class="top_tit"><spring:message code='ezPersonal.dashBoard013'/><a onclick="dashBoardBoxClick(1)"></a></div>
                <div class="conts_box">
                    <div class="document_list">
                        <ul class="info" id="lateListBox"></ul>
                    </div>
                </div>
            </div>
        </div>

        <ul class="right_box">
            <li>
                <div class="template_box">
                    <div class="top_tit"><spring:message code='ezApprovalG.t1749' /><a onclick="dashBoardBoxClick(4)"></a></div>
                    <div class="conts_box">
                        <div class="document_list">
                            <ul class="info" id="deptBoxLists"></ul>
                        </div>
                    </div>
                </div>
            </li>
            <%-- 최근 기안한 문서 --%>
            <li>
                <div class="template_box">
                    <div class="top_tit"><spring:message code='ezPersonal.dashBoard012'/></div>
                    <div class="conts_box">
                        <div class="document_list">
                            <ul class="info" id="draftBox"></ul>
                        </div>
                    </div>
                </div>
            </li>
            <%-- 완료함 --%>
            <li>
                <div class="template_box mb0">
                    <div class="top_tit"><spring:message code='ezApproval.t990042'/><a onclick="dashBoardBoxClick('MYCONT')"></a></div>
                    <div class="conts_box">
                        <div class="document_list">
                            <ul class="info" id="completedBox"></ul>
                        </div>
                    </div>
                </div>
            </li>
            <%-- 즐겨찾기 양식 --%>
            <li>
                <div class="template_box mb0">
                    <div class="top_tit"><spring:message code='ezPortal.pjg09' /><a class="more" onclick="favoriteFormAdd()"></a></div>
                    <div class="conts_box">
                        <div class="payment_form_list">
                            <ul id="favoriteForm">
                            </ul>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
		
		<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1005; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
				
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
            <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div class="title_tooltip"></div>
		<input type="hidden" id="aprDashBoard">
		<input type="hidden" id="userLang" value="<c:out value = '${userInfo.lang}'/>">
		<input type="hidden" id="userDept" value="<c:out value = '${userInfo.deptName}'/>">
		<input type="hidden" id="userDept2" value="<c:out value = '${userInfo.deptName2}'/>">
		<input type="hidden" id="userTitle" value="<c:out value = '${userInfo.title}'/>">
		<input type="hidden" id="userTitle2" value="<c:out value = '${userInfo.title2}'/>">
        <input type="hidden" id="userPrimary" value="<c:out value = '${userInfo.primary}'/>">
            
		<%-- script line --%>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.orbit-1.2.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/raphael-min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AprDashBoard.js')}"></script>
        <script type="text/javascript">
			
			/* 카운트 */
			var ViewLeftCount = "<c:out value = '${viewLeftCount}'/>";
			var localValue = "";
			var approvalFlag = "<c:out value = '${approvalFlag}'/>"; 
			var pListTypeValue = "";
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
            var PresentOpen = "APPROVAL";
            var tmpValue = "";
            var now = "<c:out value='${now}'/>"
            var pUserID = "<c:out value='${userInfo.id}'/>";
            
            /* 부재 관련 */
            var arr_userinfo = new Array();
		    arr_userinfo[1]  = "<c:out value = '${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName}'/>";
		    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";
		    var companyID = "<c:out value = '${userInfo.companyID}'/>";
		    arr_userinfo[7] = "<c:out value = '${buJaeInfo}'/>";
            var BString = arr_userinfo[7];
		    arr_userinfo[10]  = "<c:out value = '${susinAdmin}'/>";
		    arr_userinfo[13]  = "<c:out value = '${userInfo.title1}'/>";
            var proxyStartDate = "<c:out value = '${proxyInfo.startDate}'/>"
            var proxyEndDate = "<c:out value = '${proxyInfo.endDate}'/>"
            var proxyInfo = "<c:out value = '${proxyInfo}'/>"
            var userLang = "<c:out value = '${userInfo.lang}'/>";
            var nowDateUTC = "<c:out value = '${nowDateUTC}'/>";
            var nowDate = "<c:out value = '${nowDate}'/>";
            var extensionattribute4 = "<c:out value = '${userInfo.gyumJik}'/>";
            var deptPathCode = "<c:out value = '${userInfo.deptPathCode}'/>";
            var extensionattribute5 = "<c:out value = '${userInfo.extensionattribute5}'/>";
		    var absenceAllClear = "<c:out value = '${absenceAllClear}'/>";
		    var deptPathCode = "<c:out value = '${userInfo.deptPathCode}'/>";
            
            var draftAllTypeB = "<c:out value='${draftAllTypeB}'/>";
            
            /* 즐겨찾기 양식 */
            var getformcont_cross_dialogArguments = new Array();
			var openForm = function() {
		        var parameter = new Array();
		        parameter[0] = "<c:out value='${userInfo.deptID}'/>";
		        parameter[1] = "A01000";
	            url = "/ezApprovalG/getFormCont.do";
		        
		        if (CrossYN()) {
		            getformcont_cross_dialogArguments[0] = parameter;
		            getformcont_cross_dialogArguments[1] = openForm_Complete2;
		            getformcont_Cross_OpenWin = window.open(url, "/ezApprovalG/getFormCont.do", GetOpenWindowfeature(713, 570));
		            
		            try { getformcont_Cross_OpenWin.focus(); } catch (e) {}
		        } else {
		            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		            var ret = window.showModalDialog(url, parameter, feature);
		            formURL = ret[0];
		            formDocType = ret[1];
		            
		            if (formURL != "cancel") {
		                openDraftUI(formURL, formDocType);
		            }
		        }
		    }
            
            /* 결재 문서 보기 */
            function openDraftUI(formURL, formDocType) {
		        var openLocation = "";
		      
		        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
		        	openLocation += "/ezApprovalG/draftui.do?formURL=";
		            openLocation += encodeURIComponent(formURL) + "&draftFlag=" + encodeURIComponent('DRAFT') + "&formDocType=" + encodeURIComponent(formDocType);
		            openLocation += "&susinSN=0&docState=&listType=1&aprState=";
		            openLocation += "&isTmpDoc=";
		        } else {
		        	if("${useWebHWP}" == "NO") {
			        	if (!isIE()) {
			                alert(strLang1103);
			                return;
			            } else {
			            	openLocation += "/ezApprovalG/draftuiHWP.do?formURL=";
			            	openLocation += encodeURIComponent(formURL) + "&draftFlag=" + encodeURIComponent('DRAFT') + "&formDocType=" + encodeURIComponent(formDocType);
			                openLocation += "&susinSN=0&docState=&listType=1&aprState=";
			                openLocation += "&isTmpDoc=";
			            }
		        	} else {
		        		openLocation += "/ezApprovalG/draftuiWHWP.do?formURL=";
		            	openLocation += encodeURIComponent(formURL) + "&draftFlag=" + encodeURIComponent('DRAFT') + "&formDocType=" + encodeURIComponent(formDocType);
		                openLocation += "&susinSN=0&docState=&listType=1&aprState=";
		                openLocation += "&isTmpDoc=";
		        	}
		        }
		        openwindow(openLocation, "", 890, 560);
		    }
            
			// 부재자 설정 체크 로직
			var checkBujaeOpenDraftUI = function (formURL, formDocType) {
		    	if (!checkBujaeInfo('draft', formURL, formDocType)) {
		    		return;
		    	}
		    }
			
			function checkBujaeInfo(type, formURL, formDocType) {
                
                var isFavorite = "";
                
		        if (type != "main") {
                    isFavorite = "true";
                }
                
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
		
		            tmpStartDate = tmpStartDate.replace("/", ":");
		            tmpEndDate = tmpEndDate.replace("/", ":");
		            
		            if (tmpEndDate < now) {
		                setBujaeOff();
                        checkBujaeInfo_Complete(true, type, formURL, formDocType, isFavorite);
		                return true;

		            } else if (tmpStartDate > now) {
                        if (type == "main") {
                            checkBujaeInfo_Complete("ING");
                        } else {
                            checkBujaeInfo_Complete(true);
                        }
		                return true;
		            }
		            
		            var pAlertContent = "";
		            
		            if (userLang == "1" || userLang == "3" || userLang == "6") {
			            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + "<spring:message code='ezApprovalG.t1723'/>" + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
		            }
		            else if (userLang == "2") {
			            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
		            }
                    
                    if (type == "main") {
                        showConfirm(pAlertContent, checkBujaeInfo_Complete);
                    } else {
                        var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN", type, formURL, formDocType);
                        return;

                        if (Rtnval) {
                            checkBujaeInfo_Complete(true, type, formURL, formDocType, isFavorite);
                            return;
                        }
                        else {
                            checkBujaeInfo_Complete(false, type, formURL, formDocType, isFavorite);
                            return;
                        }
                    }
		        } else if(GetBujaeFlag()){
                    tmpStartDate = proxyStartDate;
                    tmpEndDate = proxyEndDate;
                    var pAlertContent = "";
                    
                    if (userLang == "1" || userLang == "3" || userLang == "6") {
                        pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + "<spring:message code='ezApprovalG.t1723'/>" + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
                    }
                    else if (userLang == "2") {
                        pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
                    }
                    showConfirm(pAlertContent, checkBujaeInfo_Complete);
		        } else {
                    if (type == "main") {
                        checkBujaeInfo_Complete("ING");
                    } else {
                        checkBujaeInfo_Complete(true, type, formURL, formDocType, isFavorite);
                        return true;
                    }
		        }
		    }
			
			var setBujaeOff = function() {
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujae.do",
		    		data : {
		    				buJae  : "",
		    				proxy  : ""
		    				},
		    		success: function(xml) {
		    			BString = "";
		    		}
		    	});
		    }
			
            function checkBujaeInfo_Complete(Rtnval, type, formURL, formDocType, isFavorite) {
                if (isFavorite != "true") {
                    hideConfirm();
                    if (Rtnval == true) {
                        saveBujaeUser();
                        btnVisible('ok');
                    }
                    else if (Rtnval == "ING") { }
                    else {
                        btnVisible('false');
                        return;
                    }

                    if (beforeJob != pListTypeValue) {
                        pageNum = 1;
                    }
                    if (arr_userinfo[10] == "YES" || arr_userinfo[10] == "Y")
                        pSusinManagerFlag = "admin";
                    else
                        pSusinManagerFlag = "user";
                    
                    try {
                        parent.frames["left"].getAprCount();
                        parent.frames["left"].setPresentValue("");
                    } catch (e) { }
                } else {
                    if (type == "form") {
		            	openForm();
		            } else {
		            	openDraftUI(formURL, formDocType);
		            }
                }
	        }
            
            function saveBujaeUser() {
		    	var jo = new Object();
		    	var formArray = new Array();
		    	var index = 0;
		    	
				var deptPathCodeArray = deptPathCode.split(",");
				var deptId = deptPathCodeArray[deptPathCodeArray.length-1];
				var title = "";
				var addJobXml = createXmlDom();
				
				$.ajax({
					type : "POST"
					,dataType : "text"
					,url : "/admin/ezOrgan/getEntryInfo.do"
					,async : false
					,data : {
						cn : arr_userinfo[1]
						,prop : "department;title;extensionAttribute5"
						,pMode : "user"
					}
				})
				.success(function(result) {
					var xmlDom = loadXMLString(result);
					deptId = SelectSingleNodeValueNew(xmlDom, "DATA/DEPARTMENT").trim();
					title = SelectSingleNodeValueNew(xmlDom, "DATA/TITLE").trim();
					extensionattribute5 = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE5").trim();
				})
				.fail(function(fail) {
					console.log("apprGManage > /admin/ezOrgan/getEntryInfo.do > fail => ", fail);
					showAlert("<spring:message code='ezTask.t200913'/>");
					return;
				});
				
				if(absenceAllClear == "YES" || (arr_userinfo[4] == deptId && arr_userinfo[13] == title)) {
	        		extensionattribute5 = "";
    			}
		    	
		    	jo.count = index;
	        	jo.deptId = deptId	// 본직
	        	jo.proxy = extensionattribute5;
	        	
	        	formArray.push(jo);
		        
	        	$.ajax({
		    		type : "POST"
		    		,dataType : "text"
		    		,async : false
		    		,url : "/admin/ezOrgan/getUserAddJobList.do"
		    		,data : {
		    			cn : arr_userinfo[1]
		    		}
		    	})
		    	.success(function(res) {
		    		addJobXml = loadXMLString(res);
		    	})
		    	.fail(function(fail) {
		    		console.log("apprGManage > /admin/ezOrgan/getUserAddJobList.do > fail => ", fail);
		    		showAlert("<spring:message code='ezTask.t200913'/>");
					return;
		    	});
		         
	        	var rows = addJobXml.getElementsByTagName("ROW");
	    		for(var i=0; i<rows.length; i++) {
	    			var getUserId = rows[i].getElementsByTagName("CN")[0].textContent;
	    			var getDeptId = rows[i].getElementsByTagName("DEPARTMENT")[0].textContent;
	    			var getTitle = rows[i].getElementsByTagName("TITLE")[0].textContent;
	    			var getJobId = rows[i].getElementsByTagName("JOBID")[0].textContent;
	    			var getProxy = rows[i].getElementsByTagName("EXTENSIONATTRIBUTE5")[0].textContent;
	    			
	    			if(absenceAllClear == "YES" || (arr_userinfo[4] == getDeptId && arr_userinfo[13] == getTitle)) {
	    				getProxy = "";
	    			}
					jo = new Object();
	    			
					jo.count = i+1;
		        	jo.deptId = getDeptId	// 겸직부서
		        	jo.proxy = getProxy;
		        	jo.jobId = getJobId;
		        	
		        	formArray.push(jo);
	    		}
	    		
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujaeUser.do",
		    		data : {
		    				formArray : JSON.stringify(formArray)
		    				},
		    		success: function(text){
			            arr_userinfo[7] = "";
		    		},
		    		error: function(){
		    		}
		    	});
		    }
            
            function GetBujaeFlag() {
		        var BString = arr_userinfo[7];
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
					
		            if (tmpStartDate <= nowDate && tmpEndDate >= nowDate) {
		                return true;
		            } else if(tmpStartDate < nowDate && tmpEndDate < nowDate){
		            	setBujaeOff();
				        return false;
		            }
		        } else if (proxyInfo != null && proxyInfo != "") {
		        	var strDate = proxyStartDate;
		        	var endDate = proxyEndDate;
		            if (strDate <= nowDate && endDate >= nowDate) {
		                return true;
		            }else if(strDate < nowDate && endDate < nowDate){
		            	setBujaeOff();
				        return false;
		            }
		        }
		        return false;
		    }
            
            // 부재자 버튼 확인/취소 누른 후의 결과 
            function btnVisible(val) {
		    }
            // 부재자 관련 끝 //
            
            /* 부서수신함 */
            var condition = new Array();
            var SearchCond = new Array();
            var nowyear = nowDate.substring(0,4);
            var nowmonth = nowDate.substring(5,7);
            var nowday = nowDate.substring(8,10);
            condition[3] = (nowyear - 1) + "-" + nowmonth + "-" + nowday;
            condition[4] = nowyear + "-" + nowmonth + "-" + nowday;
            var SQLPARADATA;
            
            function MakeSubCondition2() {
                SearchFlag = true;
                var TYPE = "";
                var DATA = "";
                if (approvalFlag =='G') {
                    if (SearchCond[0] != "" && SearchCond[0] !== undefined)		// DocNumber
                    {
                        TYPE += "DOCNO;";
                        DATA += "<DOCNO>" + SearchCond[0] + "</DOCNO>";
                    }
            
                    if (SearchCond[1] != "" && SearchCond[1] !== undefined)		// DocTitle
                    {
                        TYPE += "DOCTITLE;";
                        SearchCond[1] = SearchCond[1].replace(/\\/g, "\\\\");
                        DATA += "<DOCTITLE>" + SearchCond[1] + "</DOCTITLE>";
                    }
            
                    if (SearchCond[2] != "" && SearchCond[2] !== undefined)		// DrafterName
                    {
                        TYPE += "WRITERNAME;";
                        DATA += "<WRITERNAME>" + SearchCond[2] + "</WRITERNAME>";
                    }
            
                    if (SearchCond[3] != "" && SearchCond[4] != "" && SearchCond[5] != "")		// APRSTARTDATE
                    {
                        TYPE += "APRSTARTDATE;";
                        DATA += "<APRSTARTDATE>" + SearchCond[3] + "-" + SearchCond[4] + "-" + SearchCond[5] + "</APRSTARTDATE>";
                    }
            
                    if (SearchCond[6] != "" && SearchCond[7] != "" && SearchCond[8] != "")		// APRENDDATE
                    {
                        TYPE += "APRENDDATE;";
                        DATA += "<APRENDDATE>" + SearchCond[6] + "-" + SearchCond[7] + "-" + SearchCond[8] + "</APRENDDATE>";
                    }
            
                    if (SearchCond[21] != "" && SearchCond[21] !== undefined )		// FormID
                    {
                        TYPE += "FORMNAME;";
                        DATA += "<FORMNAME>" + SearchCond[21] + "</FORMNAME>";
                    }
            
                    if (SearchCond[23] != "" && SearchCond[23] !== undefined )		// draftDeptName
                    {
                        TYPE += "WRITERDEPTNAME;";
                        DATA += "<WRITERDEPTNAME>" + SearchCond[23] + "</WRITERDEPTNAME>";
                    }
            
                    // 2021-03-15 키워드 검색 추가 - 박기범
                    if (SearchCond[24] != "" && SearchCond[24] !== undefined )
                    {
                        TYPE += SearchCond[24].slice(0,5);
                        DATA += "<KEYWORD>" + SearchCond[24].slice(5) + "</KEYWORD>";
                    }
            
                    if (typeof (condition[25]) != "undefined" && condition[25] != "") {
                        TYPE += "RECVSTARTDATE;"
                        DATA += "<RECVSTARTDATE>" + condition[25] + "</RECVSTARTDATE>";
                    }
                    if (typeof (condition[26]) != "undefined" && condition[26] != "") {
                        TYPE += "RECVENDDATE;"
                        DATA += "<RECVENDDATE>" + condition[26] + "</RECVENDDATE>";
                    }
                    if (typeof (condition[27]) != "undefined" && condition[27] != "") {
                        TYPE += "SENTDEPTNAME;"
                        DATA += "<SENTDEPTNAME>" + condition[27] + "</SENTDEPTNAME>";
                    }
                    if (typeof (condition[28]) != "undefined" && condition[28] != "") {
                        TYPE += "RECEIVEDDEPTNAME;"
                        DATA += "<RECEIVEDDEPTNAME>" + condition[28] + "</RECEIVEDDEPTNAME>";
                    }
            
                    SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
                } else {
                    if (condition[0] != "" && condition[0] !== undefined) {
                        TYPE += "DOCNO;"
                        DATA += "<DOCNO>" + condition[0] + "</DOCNO>";
                    }
            
                    if (condition[1] != "" && condition[1] !== undefined) {
                        TYPE += "DOCTITLE;"
                        DATA += "<DOCTITLE>" + condition[1] + "</DOCTITLE>";
                    }
            
                    if (condition[2] != "" && condition[2] !== undefined) {
                        TYPE += "WRITERNAME;"
                        DATA += "<WRITERNAME>" + condition[2] + "</WRITERNAME>";
                    }
            
                    if (condition[3] != "" && condition[3] !== undefined) {
                        TYPE += "APRSTARTDATE;"
                        DATA += "<APRSTARTDATE>" + condition[3] + "</APRSTARTDATE>";
                    }
            
                    if (condition[4] != "" && condition[4] !== undefined) {
                        TYPE += "APRENDDATE;"
                        DATA += "<APRENDDATE>" + condition[4] + "</APRENDDATE>";
                    }
            
                    if (condition[5] != "" && condition[5] !== undefined) {
                        TYPE += "APRSTARTDATE;"
                        DATA += "<APRSTARTDATE>" + condition[5] + "</APRSTARTDATE>";
                    }
            
                    if (condition[6] != "" && condition[6] !== undefined) {
                        TYPE += "APRENDDATE;"
                        DATA += "<APRENDDATE>" + condition[6] + "</APRENDDATE>";
                    }
            
                    if (condition[9] != "" && condition[9] !== undefined) {
                        TYPE += "FORMNAME;"
                        DATA += "<FORMNAME>" + condition[9] + "</FORMNAME>";
                    }
                    
                    if (typeof (condition[11]) != "undefined" && condition[11] != "") {
                        TYPE += "WRITERDEPTNAME;"
                        DATA += "<WRITERDEPTNAME>" + condition[11] + "</WRITERDEPTNAME>";
                    }
            
                    if (typeof (condition[12]) != "undefined" && condition[12] != "") {
                        TYPE += condition[12];
                        DATA += condition[13];
                    }
                    if (typeof (condition[14]) != "undefined" && condition[14] != "") {
                        TYPE += condition[14];
                        DATA += condition[15];
                    }
                    if (typeof (condition[16]) != "undefined" && condition[16] != "") {
                        TYPE += condition[16];
                        DATA += condition[17];
                    }
            
                    // 2021-03-15 키워드 검색 추가 - 박기범
                    if (SearchCond[24] != "" && SearchCond[24] !== undefined )
                    {
                        TYPE += SearchCond[24].slice(0,5);
                        DATA += "<KEYWORD>" + SearchCond[24].slice(5) + "</KEYWORD>";
                    }
            
                    if (typeof (condition[25]) != "undefined" && condition[25] != "") {
                        TYPE += "RECVSTARTDATE;"
                        DATA += "<RECVSTARTDATE>" + condition[25] + "</RECVSTARTDATE>";
                    }
                    if (typeof (condition[26]) != "undefined" && condition[26] != "") {
                        TYPE += "RECVENDDATE;"
                        DATA += "<RECVENDDATE>" + condition[26] + "</RECVENDDATE>";
                    }
                    if (typeof (condition[27]) != "undefined" && condition[27] != "") {
                        TYPE += "SENTDEPTNAME;"
                        DATA += "<SENTDEPTNAME>" + condition[27] + "</SENTDEPTNAME>";
                    }
                    if (typeof (condition[28]) != "undefined" && condition[28] != "") {
                        TYPE += "RECEIVEDDEPTNAME;"
                        DATA += "<RECEIVEDDEPTNAME>" + condition[28] + "</RECEIVEDDEPTNAME>";
                    }
                }
                SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
            }

            function getDeptBoxList() {
                MakeSubCondition2();
                pageSize = "3";   
                var manager;
            
                var pSelMenu = "all";
            
                manager = pSusinManagerFlag;
                
                pListTypeValue = "4";
                
                if (pListTypeValue == "4") {
                    $.ajax({
                        type : "POST",
                        dataType : "text",
                        async : false,
                        url : "/ezOrgan/isProxyUser.do",
                        success: function(xml){
                            if (xml == 1) {
                                manager = "admin";
                            }
                        }
                    });
                }
            
                OrderOption = "";
                OrderCell = "";
                var SelYearFlag = false;
                var SearchFlag = false;
                
                if (beforeJob != pListTypeValue || SelYearFlag || SearchFlag) {
                    beforeJob = pListTypeValue;
                    pageNum = 1;
                    OrderOption = "";
                    OrderCell = "";
                }
            
                SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
                
                CurrentDocList = "Receive";
                
                $.ajax({
                    type : "POST",
                    dataType : "text",
                    async : true,
                    url : "/ezApprovalG/getDeptBoxList.do",
                    data : {
                            userID  : pUserID,
                            deptID  : arr_userinfo[4],
                            mFlag   : manager,
                            docState: pSelMenu,
                            pageSize: pageSize,
                            pageNum : pageNum,
                            orderCell : OrderCell,
                            orderOption : OrderOption,
                            searchQuery : SQLPARADATA,
                            assignChk : "N"
                            },
                    success: function(xml){
                        makeDeptBox(xml);
                    }
                });
            }
            
            function openDeptBoxList(data) {
                if (GetBujaeFlag())
                    return;
               if (pSusinManagerFlag == "admin" || data.getAttribute("DATA8") == pUserID) {
                   var pDraftFlag;
                   var tmpDocState = data.getAttribute("DATA9");
                   if (tmpDocState == strDocState11 || tmpDocState == strDocState16)
                       pDraftFlag = "SUSIN";
                   else if (tmpDocState == strDocState12 || tmpDocState == strDocState2)
                       pDraftFlag = "HAPYUI";
                   if (data.getAttribute("DATA10") == strAprState15) {
                       openViewDocInfoDeptBox(data);
                   } else {
                       OpenReceiveDeptBoxDraftUI(data, pDraftFlag);
                   }
               } else {
                   openViewDocInfoDeptBox(data);
               }
		    }
            
            window.addEventListener("load", function() {
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
                }
                checkBujaeInfo("main");
				getDraftAndDoing("draft");
				getFavoriteForms();
                grapeResize();
                getDashBoardCnt();
                getDeptBoxList();
                getCompletedList();
                getLateDocBox();
                getDoingList();
			});
			
			window.onresize = function(event) {
                grapeResize();
			}
			
			function openergetDocInfo() {
				checkBujaeInfo("main");
				getDraftAndDoing("draft");
                grapeResize();
                getDashBoardCnt();
                getDeptBoxList();
                getCompletedList();
                getLateDocBox();
                getDoingList();
			}
		</script>
	</body>	
</html>