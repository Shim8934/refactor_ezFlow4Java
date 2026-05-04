<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1310' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>	
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>	
		<style>
			#div_AprLine .mainlist tr th {
				border-top:0px;
			}
		</style>
		<script type="text/javascript">
			var labelcolor = "gray";
			var OrderCell = "";
			var xmlhttp = createXMLHttpRequest();
			var xmldoc = createXmlDom();
			var DocID, pURL, FormID, DocTitle, OrgDocid;
			var jobState = "APPROVAL" ;
			var pChackYN = "FALSE";
			var g_tagSelectsub = "1";
			var NodeList2, pageSize = 10, ListViewNode, Block_Size, pTotalCnt = "";
			var pageNum = "1";
			var NodeList, curpage, nowblock, totalPage, totalPages, block, p_page, p_nowblock, NodeListLen;
			var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
			var SearchCond = new Array();
			var approvalFlag = "<c:out value = '${approvalFlag}' />";
			var type = "<c:out value = '${type}' />";
			var startDateTime = "<c:out value ='${startDateTime}'/>";
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
	        arr_userinfo[9] = "<c:out value ='${userInfo.companyID}'/>";
		    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
			 $(function () {
		        	if (document.getElementById("resendChk").checked){
		        		$("#idDatepicker").attr('disabled',false);
		        		$("#idDatepicker2").attr('disabled',false);
		        	} else {
		        		$("#idDatepicker").attr('disabled',true);
		        		$("#idDatepicker2").attr('disabled',true);
		        	}
		        	
		        	
	        		//var date = new Date(startDateTime);
	        		var date = new Date();
	        		date.setDate(date.getDate() - 1);
		        	$("#idDatepicker").datepicker({
		        		maxDate : date,
			            changeMonth: true,
			            changeYear: true,
			            autoSize: true,
			            showOn: "both",
			            buttonImage: "/images/ImgIcon/calendar-month.png",
			            buttonImageOnly: true,
			            onSelect : function(dateText, inst) {
			            	var nowSDate = dateText.split('-');
			            	var nowSDate2 = new Date(nowSDate[0], nowSDate[1]-1, nowSDate[2]);

			            	$("#idDatepicker2").datepicker('option', 'minDate', nowSDate2);
			            }
			        });
		        	$("#idDatepicker2").datepicker({
		        		maxDate : date,
			            changeMonth: true,
			            changeYear: true,
			            autoSize: true,
			            showOn: "both",
			            buttonImage: "/images/ImgIcon/calendar-month.png",
			            buttonImageOnly: true
			        });
		        	
		        	initdatepicker();
		        });
			
			document.onselectstart = function () {
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
				    return false;
				} else {
				    return true;
				}
			};
			
			$(document).ready(function(){
				if (approvalFlag == 'S') {
					$(".approvalS").show();
					$(".approvalG").hide();
				} else {
					$(".approvalG").show();
					$(".approvalS").hide();
				}
				var height = parseInt(divList.style.height.replace('px', '')) + 200;
				var reheight = document.documentElement.clientHeight - parseInt(height);
				//document.getElementById('div_AprLine').style.height = reheight + "px";
				
				if (type == 'admin') {
					document.getElementById("SCompID").value = pCompanyID;
				}
				
				GetDocList();
			});
			
			var _draftUser = "";
			function lvtDoclist_SelChange() {
				var SelList = new ListView();
				SelList.LoadFromID("DocList");
				var oArrRows = SelList.GetSelectedRows();
				
				if (oArrRows.length != 0) {
				    var tr = oArrRows[0];
				
				    DocID = GetAttribute(tr, "DATA1");
	                pURL = GetAttribute(tr, "DATA2");
	                FormID = GetAttribute(tr, "DATA6");
	                OrgDocid = GetAttribute(tr, "DATA5");
	                _draftUser = GetAttribute(tr, "DATA3");
				
				    switch (jobState) {
				        case "ATTACH":
				            Attach_onclick();
				            break;
				
				        case "OPINION":
				            Opinion_onclick();
				            break;
				
				        case "APPROVAL":
				            Approval_onclick();
				            break;
				
				        case "RECIPENT":
				            Recipent_onclick();
				            break;
				    }
				}
			}
			
			function GetDocList() {
				var pDocstate = "000";
				
				if (pChackYN == "FALSE") {
				    for (var i = 0; i < 20; i++) {
				        SearchCond[i] = "";
				    }
				} else if (pChackYN == "SEARCH") {
				}
				
				$.ajax({
	            	type : "POST",
	            	url : "/admin/ezApprovalG/getStatSearchDocListForOpenGov.do",
	            	async : true,
	            	dataType : "text",
	            	data : {
	            		docNumber : SearchCond[0],
	            		docTitle : SearchCond[1],
	            		drafter : SearchCond[2],
	            		drafter2 : SearchCond[2],
	            		draftFromYear : SearchCond[3],
	            		draftFromMonth : SearchCond[4],
	            		draftFromDay : SearchCond[5],
	            		draftToYear : SearchCond[6],
	            		draftToMonth : SearchCond[7],
	            		draftToDay : SearchCond[8],
	            		apprFromYear : SearchCond[9],
	            		apprFromMonth : SearchCond[10],
	            		apprFromDay : SearchCond[11],
	            		apprToYear : SearchCond[12],
	            		apprToMonth : SearchCond[13],
	            		apprToDay : SearchCond[14],
	            		formID : SearchCond[15],
	            		formName : SearchCond[16],
	            		deptName1 : SearchCond[17],
	            		deptName2 : SearchCond[17],
	            		pageNum : pageNum,
	            		pageSize : pageSize,
	            		docState : "",
	            		subQuery : SearchCond[18],
	            		orderCell : "",
	            		orderOption : "",
	            		approvUser : SearchCond[19],
	            		companyID : pCompanyID
	            	},
	            	success : function(result) {
	            		getDocList_after(result);
	            	}
	            });
			}
			
			function getDocList_after(result) {
				try {
				    Resultxml = loadXMLString(result);
				
				    var listNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
				    var cntNode = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");
				    
				    if (listNode == null) {
				    	return;
				    }
				    
				    var lstCnt = getNodeText(cntNode);
	                if (lstCnt == "") {
	                    lstCnt = 0;
	                }

				    totalPage = Math.ceil(new Number(lstCnt / pageSize));
				    
				    pTotalCnt = lstCnt;
				    makePageSelPage();
				
				    var xmlDoc;
				    xmlDoc = createXmlDom();
	                xmlDoc.appendChild(listNode);
	                
				    if (document.getElementById("lvtDoclist").innerHTML != "") {
				        document.getElementById("lvtDoclist").innerHTML = "";
				    }
				
				    var DocList = new ListView();
				    DocList.SetID("DocList");
				    DocList.SetMulSelectable(false);
				    DocList.SetRowOnClick("lvtDoclist_SelChange");
				    DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");
				    DocList.SetUrgentFlag(true);
				    DocList.SetSecurityFlag(false);
				    DocList.DataSource(xmlDoc);
				    DocList.DataBind("lvtDoclist");
				    DocList = null;
				}
				catch (e) {
				}
				
				selFirstRow();
			}
			
			function selFirstRow() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var tr = oArrRows[0];

	            if (oArrRows.length != 0) {
	                DocID = GetAttribute(tr, "DATA1");
	                pURL = GetAttribute(tr, "DATA2");
	                _draftUser = GetAttribute(tr, "DATA3");
	            }
	            else {
	                DocID = "";
	                pURL = "";
	                _draftUser = "";
	            }

	            getDataInfo();
	        }
			
			var BlockSize = 10;
			function td_Create1(strtext) {
				document.getElementById("tblPageRayer").innerHTML = strtext;
			}
			
			function makePageSelPage() {
				var strtext;
				var PagingHTML = "";
				document.getElementById("tblPageRayer").innerHTML = "";
				document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + pTotalCnt + "</span>";
				strtext = "<div class='pagenavi'>";
				PagingHTML += strtext;
				
				if (totalPage > 1 && pageNum != 1) {
				    strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
				    PagingHTML += strtext;
				} else {
				    strtext = "<span class='btnimg first disabled'></span>";
				    PagingHTML += strtext;
				}
				
				if (totalPage > BlockSize) {
				    if (pageNum > BlockSize) {
				        strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
				        PagingHTML += strtext;
				    } else {
				        strtext = "<span class='btnimg prev disabled'></span>";
				        PagingHTML += strtext;
				    }
				} else {
				    strtext = "<span class='btnimg prev disabled'></span>";
				    PagingHTML += strtext;
				}
				var MaxNum;
				var i;
				var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
				
				if (totalPage >= (startNum + parseInt(BlockSize))) {
				    MaxNum = (startNum + parseInt(BlockSize)) - 1;
				} else {
				    MaxNum = totalPage;
				}
				
				for (i = startNum; i <= MaxNum; i++) {
				    if (i == pageNum) {
				        strtext = "<span class='on'>" + i + "</span>";
				        PagingHTML += strtext;
				    } else {
				        strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
				        PagingHTML += strtext;
				    }
				}
				
		        if (i == 1) {
		        	strtext = "<span class='on'>" + i + "</span>";
		            PagingHTML += strtext;
		        }				
				
				if (totalPage > BlockSize) {
				    if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
				        strtext = "";
				        strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
				        PagingHTML += strtext;
				    } else {
				        strtext = "";
				        strtext = strtext + "<span class='btnimg next disabled'></span>";
				        PagingHTML += strtext;
				    }
				} else {
				    strtext = "";
				    strtext = strtext + "<span class='btnimg next disabled'></span>";
				    PagingHTML += strtext;
				}
				
				if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
				    strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
				    PagingHTML += strtext;
				} else {
				    strtext = "<span class='btnimg last disabled'></span>";
				    PagingHTML += strtext;
				}
				
				PagingHTML += "</div>";
				td_Create1(PagingHTML);
			}
			
			function goToPageByNum(Value) {
				currentpage = Value;
				pageNum = currentpage;
				makePageSelPage();
				GetDocList();
			}
			
			function selbeforeBlock() {
				var pageNum = currentpage;
				pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
				goToPageByNum(pageNum);
			}
			
			function selbeforeBlock_one() {
				if (parseInt(pageNum - 1) > 0) {
				    goToPageByNum(parseInt(pageNum - 1));
				} else {
				    return;
				}
			}
			
			function selafterBlock() {
				var pageNum = currentpage;
				pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
				goToPageByNum(pageNum);
			}
			
			function selafterBlock_one() {
				if (parseInt(pageNum + 1) <= totalPage) {
				    goToPageByNum(parseInt(pageNum + 1));
				} else {
				    return;
				}
			}
			
			function selNum(pselNum) {
				pageNum = pselNum;
				GetDocList();
			}
			
			function selNext() {
				pageNum = pageNum + 1;
				GetDocList();
			}
			
			function selPrev() {
				pageNum = pageNum - 1;
				GetDocList();
			}
			
			function selbeforeBlock() {
				pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
				GetDocList();
			}
			
			function selafterBlock() {
				pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
				GetDocList();
			}
			
			function td_Create(strtext) {
				tblPageNum.innerHTML = tblPageNum.innerHTML + strtext;
			}
			
			function getDataInfo() {
				var ajaxURL = "";
	            var ajaxAsync = false;
	            
	            switch (jobState) {
	                case "ATTACH":
	                	ajaxURL = "/admin/ezApprovalG/getStatAttachList.do";
	                	ajaxAsync = true;
	                    break;
	
	                case "OPINION":
	                	ajaxURL = "/admin/ezApprovalG/getStatOpinionList.do";
	                	ajaxAsync = true;
	                    break;
	
	                case "APPROVAL":
	                	ajaxURL = "/admin/ezApprovalG/getStatLineList.do";
	                	ajaxAsync = false;
	                    break;
	
	                case "RECIPENT":
	                	ajaxURL = "/admin/ezApprovalG/getStatReceiptList.do";
	                	ajaxAsync = true;
	                    break;
	            }
	            
	            $.ajax({
	            	type : "POST",
	            	url : ajaxURL,
	            	async : ajaxAsync,
	            	dataType : "text",
	            	data : {docID : DocID, flag : "END", companyID : pCompanyID},
	            	success : function (result) {
	            		getdoclistSub_after(result);
	            	}
	            });
			}
			
			function getdoclistSub_after(result) {
			    try {
			        Resultxml = loadXMLString(result);
			        if (document.getElementById("lvAprLine").innerHTML != "") {
			            document.getElementById("lvAprLine").innerHTML = "";
			        }
			
			        var DocList = new ListView();
			        DocList.SetID("SubDocList");
			        DocList.SetMulSelectable(false);
			        DocList.SetRowOnDblClick("lvtDetail_onSel_DBclick");
			        DocList.DataSource(Resultxml);
			        DocList.DataBind("lvAprLine");
			    }
			    catch (e) { }
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
			
			function MM_swapImagesub(nSel, evt) {
			    if (nSel != g_tagSelectsub) {
			        g_tagSelectsub = nSel;
			        var Element = window.event.srcElement;
			
			        Element.src = "/images/tab_appsub" + nSel + ".gif";
			        Element.height = "23";
			
			        for (var i = 1 ; i <= 4; i++) {
			            if (g_tagSelectsub != i) {
			                var str = "tagsub" + i + ".src" + "=" + "\"/images/tab_appsub" + i + "a.gif\"";
			                eval(str);
			                var str = "tagsub" + i + ".height" + "=" + "23";
			                eval(str);
			            }
			        }
			    }
			}
			
			function lvtDoclist_onSel_DBclick() {
			    ViewDoc_onclick(DocID, pURL);
			}
			
			function ViewDoc_onclick(DocID, pURL) {
			    if (DocID == "") {
			        alert("<spring:message code = 'ezApprovalG.t633' />");
			    } else {
			        var para = new Array();
			        para[0] = DocID;
			        para[1] = pURL;
			        var openLocation = "";
			        var ext = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
			        
			        // 2018.08.01 (KLIB) - ezd 확장자 처리
			        if ((ext == "hwp" || ext == "ezd") && !isIE()) {
                        var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                        alert(pAlertContent);
                        
                        return;
			        }
                    openLocation = "/ezApprovalG/view.do?admin=Y&docID=" + encodeURI(DocID);
			        openwindow(openLocation, "", 880, 570);
			    }
			}
			
			function ResizeTableWidth() {
			    lvAprLine.headers.headerTable.style.width = 790;
			    lvAprLine.rows.rowTable.style.width = 790;
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
		            if(wfileLocation.includes("view.do")){
                        var param = new URLSearchParams(wfileLocation.substring(wfileLocation.indexOf("?")));
                        wName = wName ? wName : param.get("docID");
                        var data = ["docID", "share", "isPreview", "listSusin", "docAttachParent", "admin", "listType", "pageType", "isOpinion", "callBackType"];
                        window.open("", wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
                        const form = document.createElement("form");
                        form.method = "post";
                        form.action = wfileLocation.substring(0,wfileLocation.indexOf("?"));
                        form.target = wName;
                        for(const key of data){
                            if(param.get(key)){
                                const hidden = document.createElement("input");
                                hidden.type = "hidden";
                                hidden.name = key;
                                hidden.value = param.get(key);
                                form.appendChild(hidden);
                            }
                        }
                        document.body.appendChild(form);
                        form.submit();
                        document.body.removeChild(form);
                    }else
			            window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
			    } catch (e) {
			        alert("openwindow :: " + e.description);
			    }
			}
			
			var g_progresswin = null;
			function showProgress() {
				g_progresswin = window.showModelessDialog("/ezApprovalG/showProgress.do?fileInfo=" + encodeURI("<spring:message code = 'ezApprovalG.t628' />"), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
			}
			
			function hideProgress() {
			    try {
			        if (g_progresswin) {
			            g_progresswin.close();
			        }
			    } catch (e) { }
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
				            window.open("/ezApprovalG/ezLineInfo.do?docID=" + GetAttribute(tr, "DATA3") + "&deptID=" + encodeURI(GetAttribute(tr, "DATA4")) + "&docState=012", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
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
				        var isExtYN = GetAttribute(tr, "DATA3");
//TODO 외부부서일때 isExtYN ==Y
			        	if (isExtYN.toUpperCase() == "Y") {
				            var url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + DocID + "&deptID=" + encodeURIComponent(GetAttribute(tr, "DATA1"));
				            var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
				            feature = feature + GetShowModalPosition(555, 240);
				            var ret = window.showModalDialog(url, "", feature);
			        	} else {
			        		left = (parseInt(width) - 1155) / 2;
					        top = (parseInt(heigth) - 460) / 2;
			            	window.open("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + encodeURI(GetAttribute(tr, "DATA1")) + "&docState=011", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
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
                                var tempINGFlag = "";
                                /* if (GetAttribute(tr,"data4") == "file") {
                                    window.open(document.location.protocol + "//" + document.location.hostname + "/approvalG/downloadAttach.do?type=APPROVAL&docID=" + GetAttribute(tr, "data3") + "&docStatus=" + tempINGFlag + "&docAttachSn=" + GetAttribute(tr,"data2"));
                                } else {
                                    window.open("/ezApprovalG/downloadAttach.do?fileName=" + Attachfilename + "&filePath=" + AttachUrl, "_self");
                                } */
                                
                              	//2018-09-12 천성준 - 전자결재 결재문서리스트 하단 첨부탭에서 첨부파일이 문서첨부일경우 문서보기로 열수있게
								try {
									if (GetAttribute(tr,"data4") == strLangCSJ01 || GetAttribute(tr,"data4") == "Document") {
	                                	var tempStr = AttachUrlA1.split("/");
	                                    var docID = tempStr[tempStr.length - 1].replace(AttachUrlA2, '');
	                                    var openLocation;
	                                    if (AttachUrlA1 == "") {
                                            showAlert("<spring:message code='ezApprovalG.t633'/>");
                                            return;
                                        } else if ((AttachUrlA2 == ".hwp" || AttachUrlA2 == ".ezd") && !isIE()) {
                                            var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                                            alert(pAlertContent);
                                            return;
	                                    }
                                        openLocation = "/ezApprovalG/view.do?docID=" + docID;
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
			}
			
			function selectCompanyID() {
				if (pCompanyID != document.getElementById("SCompID").value) {
				    pCompanyID = document.getElementById("SCompID").value;
				    pChackYN = "FALSE";
				
				    GetDocList();
				}
			}
			
			var ezStatisticsSearch_Cross_dialogArguments = new Array();
			function SearchCondi_onclick() {
				var para;
				
				if (CrossYN()) {
				    ezStatisticsSearch_Cross_dialogArguments[0] = para;
				    ezStatisticsSearch_Cross_dialogArguments[1] = SearchCondi_onclick_Complete;
				
				    var ezStatisticsSearch_Cross = window.open("/admin/ezApprovalG/search.do?ingFlag=END", "ezStatisticsSearch", GetOpenWindowfeature(560, 404));

				    try { ezStatisticsSearch_Cross.focus(); } catch (e) {
				    }
				} else {
				    var url = "ezStatisticsSearch_Cross.aspx?INGFLAG=END";
				    var feature = "dialogWidth:500px;dialogHeight:340px;status:no;scroll:no;edge:sunken";
				    var condition = window.showModalDialog(url, para, feature);
				    
				    if (condition) {
				        pChackYN = "SEARCH";
				        
				        for (var i = 0; i < 20; i++) {
				            SearchCond[i] = condition[i];
				        }
				        
				        pageNum = 1;
				        GetDocList();
				    }
				}
			}
			
			function SearchCondi_onclick_Complete(condition) {
				if (condition) {
				    pChackYN = "SEARCH";
				    
				    for (var i = 0; i < 20; i++) {
				        SearchCond[i] = condition[i];
				    }
				
				    pageNum = 1;
				    GetDocList();
				}
			}
			
			function DisuseItem_onclick() {
				var SelList = new ListView();
				SelList.LoadFromID("DocList");
				var oArrRows = SelList.GetSelectedRows();
				
				if (oArrRows.length == 0) {
				    return;
				} else {
				    var tr = oArrRows[0];
				
				    if (!confirm("<spring:message code = 'ezApprovalG.t1317' />")) {
				        return;
				    }

				    $.ajax({
				    	type : "POST",
				    	url : "/admin/ezApprovalG/setContainerIDForDoc.do",
				    	async : false,
				    	data : {docID : DocID, deptID : GetAttribute(tr, "DATA12"), orgContainerID : GetAttribute(tr, "DATA4"), containerType : '999', companyID : pCompanyID},
				    	dataType : 'text',
				    	success : function (result) {
				    		if (result == 'OK') {
					            alert("<spring:message code = 'ezApprovalG.t1318' />");
					        } else {
					            alert("<spring:message code = 'ezApprovalG.t1319' />" + result);
					        }
				    	},
				    	error : function() {
				    		alert("<spring:message code = 'ezApprovalG.t1319' />");
				    	}
				    });
				}
			}
			
			function SendEDM_onclick() {
				var tr = lvtDoclist.multiselects(0);
				
				if (tr.length == 0) {
				    alert("EDMS<spring:message code = 'ezApprovalG.t1320' />");
				    return;
				}
				
				if (tr.childNodes(0).getAttribute("DATA11") != "Y") {
				    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
				    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
				    var objRoot = xmlpara.createNode(1, "PARAMETER", "");
				    xmlpara.appendChild(objRoot);
				
				    var objNode = xmlpara.createNode(1, "DocID", "");
				    objNode.text = tr.childNodes(0).getAttribute("DATA1");
				    xmlpara.documentElement.appendChild(objNode);
				
				    xmlhttp.open("POST", "../Conn/aspx/SendEDMS.aspx", false);
				    xmlhttp.send(xmlpara);
				
				    if (xmlhttp.responseText == "True") {
				        alert("EDMS<spring:message code = 'ezApprovalG.t1321' />");
				        goToPage('go');
				    } else {
				        alert("EDMS <spring:message code = 'ezApprovalG.t1322' />" + xmlhttp.responseText);
				    }
				} else {
				    alert("<spring:message code = 'ezApprovalG.t1323' />");
				}
			}
			
			window.onresize = function () {
			    var height = parseInt(divList.style.height.replace('px', '')) + 200;
			    var reheight = document.documentElement.clientHeight - parseInt(height);
			    //document.getElementById('div_AprLine').style.height = reheight + "px";
			};
			
			function onkeydown_start_search() {
			    if (window.event.keyCode == "13") {
			        search();
			    }
			}
			
			function keyword_Clear() {
			    document.getElementById('txt_keyword').value = "";
			}
			
			function search() {
			    pChackYN = "SEARCH";
			    if (document.getElementById("txt_keyword").value != "") {
			        var selectSearch = document.getElementById('selectType');
			
			        for (var i = 0; i < 20; i++) {
			            SearchCond[i] = "";
			        }
			
			        if (selectSearch.item(0).selected) {
			            SearchCond[1] = document.getElementById("txt_keyword").value;
			        } else if (selectSearch.item(1).selected) {
			            SearchCond[2] = document.getElementById("txt_keyword").value;
			        }
			    } else {
			        alert(strLang1106);
			        return;
			    }
			    
			    pageNum = 1;
			    GetDocList();
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
		    
		    function btnViewDoc_onclick() {
		            var DocList = new ListView();
		            DocList.LoadFromID("DocList");
		            var oArrRows = DocList.GetSelectedRows();
		            if (oArrRows.length > 0) {
		            	var pCurSelRow = oArrRows[0];
			        	var viewDocID = pCurSelRow.getAttribute("DATA1");
			       	 	var viewURL = pCurSelRow.getAttribute("DATA2");
		            	OrgDocid = pCurSelRow.getAttribute("DATA5");
		            	ViewDoc_onclick(viewDocID, viewURL);
		            } else {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		                //OpenAlertUI(pAlertContent);
		                alert(pAlertContent);
		            }
		    }
		    
		    function initdatepicker() {
	    	$("#idDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#idDatepicker").datepicker('setDate', new Date(startDateTime.substring(0, 10)));
	        $("#idDatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#idDatepicker2").datepicker('setDate', new Date(startDateTime.substring(0, 10)));
	        
			$.datepicker.regional["<spring:message code='main.t0619' />"] = {
				closeText: "<spring:message code='main.t3' />",
				prevText: "<spring:message code='main.t0604' />",
				nextText: "<spring:message code='main.t0605' />",
				currentText: "<spring:message code='main.t0606' />",
				monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
				           "<spring:message code='main.t0627' />"],
				dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                "<spring:message code='main.t0627' />"],
				dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				              "<spring:message code='main.t0627' />"],
				weekHeader: "Wk",
				dateFormat: "yy-mm-dd",
				firstDay: 0,
				isRTL: false,
				duration: 200,
				showAnim: "show",
				showMonthAfterYear: true
			};
			
			$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
	    }
		    
		function resendChk_onClick() {
			if (document.getElementById("resendChk").checked) {
				document.getElementById("idDatepicker").disabled = "";
				document.getElementById("idDatepicker2").disabled = ""
				document.getElementById("tbresend").style.display = "";
			} else {
				document.getElementById("idDatepicker").disabled = "disabled";
				document.getElementById("idDatepicker2").disabled = "disabled";
				document.getElementById("tbresend").style.display = "none";
			}
		}
		
		function resend_onclick() {
			var resendDate = document.getElementById("idDatepicker").value.substring(0, 10);
			var resendDate2 = document.getElementById("idDatepicker2").value.substring(0, 10);
			var checkDate = new Date(resendDate);
			var checkDate2 = new Date(resendDate2);
			var today = new Date();
			var todayCheck = today.getFullYear() + "-" + today.getMonth() + "-" + today.getDate();
			var resendCheck = checkDate.getFullYear() + "-" + checkDate.getMonth() + "-" + checkDate.getDate();
			var resendCheck2 = checkDate2.getFullYear() + "-" + checkDate2.getMonth() + "-" + checkDate2.getDate();
			
			var diffDate = checkDate2 - checkDate;
			diffDate = parseInt(diffDate / (24 * 60 * 60 * 1000))
			
			if (checkDate > new Date() || todayCheck == resendCheck) {
				alert("오늘 이전의 날짜를 선택해주세요.");
				return;
			}
			
			if(diffDate > 31) {
				alert('재전송 기간은 30일까지 가능합니다.');
				return;
			}
			
			if(confirm('해당 기간의 문서를 재전송 하시겠습니까?')) {
				$.ajax({
					type : "POST",
	            	url : "/admin/ezApprovalG/resendOpenGov.do",
	            	async : true,
	            	dataType : "text",
	            	data : {
	            		resendStartDate : resendDate,
	            		resendEndDate : resendDate2
	            	},
	            	success : function(result) {
	            		alert("재전송이 완료되었습니다.\n전송 결과는 익일 확인 가능합니다.");
	            	}
				})
			} else {
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
	            para[4] = true;
	            para[5] = tr.getAttribute("DATA1");
	
	            var url = "/ezApprovalG/changeOpenGovInfo.do";
	
	            changeOpenGovInfo_cross_dialogArguments[0] = para;
	            changeOpenGovInfo_cross_dialogArguments[1] = btnChangeOpenGovInfo_onclick_Complete;
	
	            var OpenWin = window.open(url, "ChangeOpenGovInfo_Cross", GetOpenWindowfeature(680, 510));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        else {
	        	alert("<spring:message code='ezApprovalG.t632'/>");
	        }
	    }
	
	    function btnChangeOpenGovInfo_onclick_Complete(rtn) {
	        if (rtn[0] == "TRUE") {
	            GetRecordList();
	        }
	    }

		var modifyOpenGovHistory_cross_dialogArguments = new Array();

		function btnOpenGovInfoHistory_onclick() {
			var DocList = new ListView();
			DocList.LoadFromID("DocList");
			var selRow = DocList.GetSelectedRows();
			if (selRow.length != 0) {
				var tr = selRow[0];
				var para = new Array();
				para[0] = tr.getAttribute("DATA1");
				para[1] = tr.children[1].textContent;
				//                         para[2] = arr_userinfo[1];
				//                         para[3] = arr_userinfo[2];
				//                         para[4] = true;
				//                         para[5] = tr.getAttribute("DATA1");

				var url = "/admin/ezApprovalG/modifyOpenGovHistory.do";

				modifyOpenGovHistory_cross_dialogArguments[0] = para;

				var OpenWin = window.open(url, "ModifyOpenGovHistory_Cross", GetOpenWindowfeature(680, 510));
				try {
					OpenWin.focus();
				} catch (e) {
				}
			}
			else {
				alert("<spring:message code='ezApprovalG.t632'/>");
			}
		}
		</script>
	</head>
	<body class="mainbody">
	    <xml id='FORMLIST'  style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code = 'ezApprovalG.t1314' /></NAME>
						<WIDTH>300</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		
	    <h1>원문공개문서함<span id="mailBoxInfo"></span>
	        <span class="searchForm">
	        	<select id="selectType" class="text"; style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezApprovalG.t106'/></option>
		    		<option value="rad_Writer"><spring:message code='ezApprovalG.t445'/></option>
		    	</select>
			  	<input id="txt_keyword" class="searchinputBox searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	          	<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search()"></a>
	        </span>
	    </h1>
	    
	    
	    <div id="mainmenu">
	    	<c:if test="${type == 'admin' }">
	    		<input type="hidden" id="SCompID" value="${userInfo.companyID }" >
			</c:if>
	        <ul>
	            <li id="GetEDMSXML" style="display:none"><span onclick="return SendEDM_onclick()"><spring:message code = 'ezApprovalG.t522' /></span></li>
	            <li id="tbtnViewDoc"><span id="btnViewDoc" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.t367'/></span></li>
	            <li id="tdModifyOpenGov"><span id="ModifyOpenGov" onclick="return btnChangeOpenGovInfo_onclick()">원문공개수정</span></li>
				<li id="tdModifyOpenGovHistory"><span id="ModifyOpenGovHistory" onclick="return btnOpenGovInfoHistory_onclick()">수정이력</span></li>
	            <li id="SearchCondi"><span class="icon16 icon16_search" onclick="return SearchCondi_onclick()"></span></li>
	            <li style="border:0px;line-height:35px;margin-left:10px;">
                 <input style="width:25px;height:25px" type="checkbox" name="resendChk" id="resendChk" value="checkbox" onclick="resendChk_onClick()">
                 </li>
	            <li style="border:0px;line-height:35px;margin-right:5px">
                 <input readonly="readonly" id='idDatepicker' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;height:27px">
                  ~ <input readonly="readonly" id='idDatepicker2' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;height:27px">
                 </li>
	            <li id="tbresend" style="display:none"><span id="resend" onclick="return resend_onclick()" >재전송</span></li>
	        </ul>
	    </div>
	
		<div class="div_scroll" style="width:100%;HEIGHT:375px; overflow:AUTO" id="divList">
	  		<div id="lvtDoclist" ></div>
		</div>
	 	<div id="tblPageRayer"></div>
	
		<div id="tabnav" class="portlet_tabpart01" style="width:100%">
			<div class="portlet_tabpart01_top" id="tab1">
			    <p><span id="tagsub1"><spring:message code='ezApprovalG.t1769'/></span></p>
			    <c:if test="${approvalFlag == 'S'}">
			    	<%-- <p><span id="tagsub2"><spring:message code = 'ezApprovalG.t999932' /></span></p> --%>
			    	<p><span id="tagsub2"><spring:message code = 'ezApprovalG.t950' /></span></p>
			    </c:if>
			    <c:if test="${approvalFlag != 'S'}">
			    	<p><span id="tagsub2"><spring:message code = 'ezApprovalG.t950' /></span></p>
			    </c:if>			    
			    <p><span id="tagsub3"><spring:message code='ezApprovalG.t56'/></span></p>
			    <p><span id="tagsub4"><spring:message code='ezApprovalG.t55'/></span></p>
			    <%-- <c:if test="${approvalFlag != 'G'}">
				   	<p><span id="tagsub5"><spring:message code='ezApprovalG.hyj24'/></span></p>
			    </c:if> --%>
		  	</div>	
		</div>
	
		<div style="WIDTH:100%;HEIGHT:204px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
	  		<div id="lvAprLine" ></div>
		</div>

	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        //selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	        Tab1_NewTabIni("tab1");
	    </script>
	</body>
</html>
