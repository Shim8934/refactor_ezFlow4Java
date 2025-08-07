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
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" type="text/css"/>
		<style>
			#div_AprLine .mainlist tr th {
				border-top:0px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_obj.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/PreviewItem.js')}"></script>				
		<script type="text/javascript">
			var labelcolor = "gray";
			var OrderCell = "";
			var xmlhttp = createXMLHttpRequest();
			var xmldoc = createXmlDom();
			var DocID, pURL, FormID, DocTitle, OrgDocid, DelFlag;
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
			var nowDate = "<c:out value = '${nowDateUTC}'/>";
			var pOpenYear = "<c:out value = '${openYear}'/>";
			var useWebHWP = "<c:out value = '${useWebHWP}'/>";
			var selectYear = "ALL";
			var useReceiveInfoName = "<c:out value ='${useReceiveInfoName}'/>"; // 수신처 뒤에 "장"을 붙이는지 여부 (0 : 안붙임 / 1 : 붙임 / 2: 상위부서 + 수신처장)

			document.onselectstart = function () {
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
				    return false;
				} else {
				    return true;
				}
			};
			
		    $(document).ready(function() {
		    	var clickOutside;
		    	
		    	if (navigator.userAgent.toLowerCase().indexOf("msie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { 
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].document);
		    	} else {
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].contentWindow.document);
		    	}	    	
		    	
		    	clickOutside.mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(window.parent.frames['left'].document).mouseup(function (e) {
			    	MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(parent.document).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(document).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    });
			
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
				
				var toDayYear = parseInt(nowDate.substring(0,4));
	            var minusYear = parseInt(nowDate.substring(0,4)) - parseInt(pOpenYear);
	            for (var i = toDayYear; i >= toDayYear - minusYear ; i--) {
	                AddOption(sel_year, i, i);
	            }
	            
                pChackYN = "INIT";
				
				GetDocList();
			});
			
			var _draftUser = "";
			function lvtDoclist_SelChange() {
				var SelList = new ListConstr();
				SelList.LoadFromID("DocList");
				var oArrRows = SelList.GetSelectedRows();
				
				if (oArrRows.length != 0) {
				    var tr = oArrRows[0];
				
				    DocID = GetAttribute(tr, "DATA1");
	                pURL = GetAttribute(tr, "DATA2");
	                FormID = GetAttribute(tr, "DATA6");
	                OrgDocid = GetAttribute(tr, "DATA5");
	                _draftUser = GetAttribute(tr, "DATA3");
				    DelFlag = GetAttribute(tr, "DELFLAG");
	                
	                if (DelFlag == "Y") {
                		$("#btnDelete").removeClass();
                		$("#btnDelete").text("<spring:message code='ezApprovalG.kms0002'/>");
                	} else {
                		$("#btnDelete").addClass("icon16 icon16_delete");
                		$("#btnDelete").text("");
                	}
	                
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
				} else {
					$("#btnDelete").addClass("icon16 icon16_delete");
            		$("#btnDelete").text("");
				}
				
	            /* 2021-03-24 홍승비 - 제목 클릭 시 원클릭 이벤트로 전자결재 읽기, 결재 팝업창을 표출 */
	            var headerNameTD = $(event.target).attr("headerName");
	            if (headerNameTD != null && typeof(headerNameTD) != "undefined" && headerNameTD == "DOCTITLE") {
	            	lvtDoclist_onSel_DBclick();
	            }
			}
			
			function GetDocList() {
				var pDocstate = "000";
				
				if (pChackYN == "FALSE") {
				    for (var i = 0; i < 20; i++) {
				        SearchCond[i] = "";
				    }
				    
				    /* 2024-03-20 홍승비 - 기존 문자열 subQuery를 신규 파라미터로 대체 (두 개의 검색조건만 사용됨) */
				    ezStatisticsSearch_QueryMap.set("keyword", "");
				    ezStatisticsSearch_QueryMap.set("itemcode", "");
				}
				else if (pChackYN == "SEARCH") {
					// 검색을 위한 SearchCond 조건을 그대로 사용
				}
				else if (pChackYN == "INIT") {
					for (var i = 0; i < 20; i++) {
						SearchCond[i] = "";
					}
					
					ezStatisticsSearch_QueryMap.set("keyword", "");
					ezStatisticsSearch_QueryMap.set("itemcode", "");
					 
					var nowyear = nowDate.substring(0,4);
			        var nowmonth = nowDate.substring(5,7);
			        var nowday = nowDate.substring(8,10);
			        
					SearchCond[3] = nowyear-1;
	            	SearchCond[4] = nowmonth;
	            	SearchCond[5] = nowday;
	            	SearchCond[6] = nowyear
	            	SearchCond[7] = nowmonth;
	                SearchCond[8] = nowday;
					 
	                pChackYN == "FALSE";
				}
				
				$.ajax({
	            	type : "POST",
	            	url : "/admin/ezApprovalG/getStatSearchEndDocList.do",
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
	            		//subQuery : SearchCond[18],
	            		orderCell : "",
	            		orderOption : "",
	            		approvUser : SearchCond[19],
	            		companyID : pCompanyID,
	            		/* 2024-03-20 홍승비 - 기존 문자열 subQuery를 신규 파라미터로 대체 (두 개의 검색조건만 사용됨) */
	            		keyword : ezStatisticsSearch_QueryMap.get("keyword"),
	            		itemcode : ezStatisticsSearch_QueryMap.get("itemcode")
	            	},
	            	success : function(resultXml) {
	            		var result = JSON.parse(resultXml);
	            		getDocList_after(result);
	            	}
	            });
			}
			
			function getDocList_after(result) {
				try {
				

				    var lstCnt = result.totalCount;
	                if (lstCnt == "") {
	                    lstCnt = 0;
	                }

				    totalPage = Math.ceil(new Number(lstCnt / pageSize));
				    
				    pTotalCnt = lstCnt;
				    makePageSelPage();
				
				    result['tableId'] = 'DocList';
				    result['multiSelectable'] = false;
				    result['rowOnClick'] = 'lvtDoclist_SelChange';
				    result['rowOnDblClick'] = 'lvtDoclist_onSel_DBclick';
				    result['urgentFlag'] = true;
				    result['securityFlag'] = false;
				    result['bindId'] = 'lvtDoclist';
				    result['delFlag'] = true;
				    
				    
				   // console.log(result);
				    
				    var DocList = new ListConstr(result);
				}
				catch (e) {
				}
				
				selFirstRow();
			}
			
			function selFirstRow() {
	            var DocList = new ListConstr();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var tr = oArrRows[0];

	            if (oArrRows.length != 0) {
	                DocID = GetAttribute(tr, "DATA1");
	                pURL = GetAttribute(tr, "DATA2");
	                _draftUser = GetAttribute(tr, "DATA3");
	                
				    DelFlag = GetAttribute(tr, "DELFLAG");
	                
	                if (DelFlag == "Y") {
	                	$("#btnDelete").removeClass();
                		$("#btnDelete").text("<spring:message code='ezApprovalG.kms0002'/>");
                	} else {
                		$("#btnDelete").addClass("icon16 icon16_delete");
                		$("#btnDelete").text("");
                	}
	            }
	            else {
	                DocID = "";
	                pURL = "";
	                _draftUser = "";
	                
	                $("#btnDelete").addClass("icon16 icon16_delete");
            		$("#btnDelete").text("");
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
			    ViewDoc_onclick();
			}
			
			function ViewDoc_onclick() {
			    if (DocID == "") {
			        showAlert("<spring:message code = 'ezApprovalG.t633' />");
			    } else {
			        var para = new Array();
			        para[0] = DocID;
			        para[1] = pURL;
			        var openLocation = "";
			        var ext = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
			        
			     	// 2021.12.22 (KLIB) - ezd 확장자 처리
			        ext = (ext == "ezd") ? pURL.substr(pURL.length - 7, 3).toLowerCase() : ext;
			        
			        if (ext == "hwp") { //한글기안
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
			        openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(FormID) + "&orgDocID=" + encodeURI(OrgDocid.trim()) + "&admin=Y";
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
			        // window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
					showPopupSlide(wfileLocation, width, heigth, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left, hidePopupSlide);
			    } catch (e) {
			        showAlert("openwindow :: " + e.description);
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
	                                    
	                                    if (AttachUrlA2 == ".hwp" || AttachUrlA2 == ".ezd") {
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
			}
			
			function selectCompanyID() {
				if (pCompanyID != document.getElementById("ListCompany").value) {
				    pCompanyID = document.getElementById("ListCompany").value;
				    pChackYN = "INIT";
				    pageNum = "1"; // 회사 선택 시 페이징 초기화
	                
				    GetDocList();
				}
			}
			
			// var ezStatisticsSearch_Cross_dialogArguments = new Array();
			var ezStatisticsSearch_QueryMap = new Map();
			function SearchCondi_onclick() {
				var para;
				
				flag = "END";
				$('#sel_year').val("ALL");
				
				if (CrossYN()) {
				    // ezStatisticsSearch_Cross_dialogArguments[0] = para;
				    // ezStatisticsSearch_Cross_dialogArguments[1] = SearchCondi_onclick_Complete;
				    // var ezStatisticsSearch_Cross;
					ezCommon_cross_dialogArguments[0] = para;
				    if (approvalFlag == "S") {
					    // ezStatisticsSearch_Cross = window.open("/admin/ezApprovalG/search.do?ingFlag=END", "ezStatisticsSearch", GetOpenWindowfeature(560, 314));
						showPopup("/admin/ezApprovalG/search.do?ingFlag=END", 560, 314, "ezStatisticsSearch", GetOpenWindowfeature(560, 314), SearchCondi_onclick_Complete);
				    } else {
					    // ezStatisticsSearch_Cross = window.open("/admin/ezApprovalG/search.do?ingFlag=END", "ezStatisticsSearch", GetOpenWindowfeature(560, 404));
						showPopup("/admin/ezApprovalG/search.do?ingFlag=END", 560, 404, "ezStatisticsSearch", GetOpenWindowfeature(560, 404), SearchCondi_onclick_Complete);
				    }	// 팝업 사이즈 수정(510 > 560) : 다국어 버튼 아래로 떨어짐

				    // try { ezStatisticsSearch_Cross.focus(); } catch (e) {
				    // }
				} else {
				    var url = "ezStatisticsSearch_Cross.aspx?INGFLAG=END";
				    var feature = "";
				    
				    if (approvalFlag == "S") {
					    feature = "dialogWidth:500px;dialogHeight:260px;status:no;scroll:no;edge:sunken";
				    } else {
					    feature = "dialogWidth:500px;dialogHeight:340px;status:no;scroll:no;edge:sunken";
				    }
				    
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
				hidePopup();
				if (condition) {
				    pChackYN = "SEARCH";
				    
				    for (var i = 0; i < 20; i++) {
				    	if (condition[i] == null) {
				    		condition[i] = "";
				    	}
				    	
				        SearchCond[i] = replaceCond(condition[i]);
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

					/* 2024-02-16 양지혜 - 선택한 연도 정보를 유지하기 위해 주석처리
			        for (var i = 0; i < 20; i++) {
			            SearchCond[i] = "";
			        } */
			
			        if (selectSearch.item(0).selected) {
			            SearchCond[1] = replaceCond(document.getElementById("txt_keyword").value);
			        } else if (selectSearch.item(1).selected) {
			            SearchCond[2] = replaceCond(document.getElementById("txt_keyword").value);
			        } else if (selectSearch.item(2).selected) {
			        	SearchCond[17] = replaceCond(document.getElementById("txt_keyword").value);
			        } //2019.12.30 김정언 - 기안부서 검색 추가
			        
			    } else {
			        alert(strLang1106);
			        return;
			    }
			    
			    pageNum = 1;
			    GetDocList();
  
			    $('#sel_year').val(selectYear);
			}
			
			//2018-10-01 김보미 - 년도가 string값이 아니라 발생하는 버그 수정
			function replaceCond(condStr){//검색조건 수정(% _ ' 추가)
				return condStr.toString().replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/%/g, "\\%").replace(/'/g, "\\'").replace(/_/g, "\\_");
			}

			function restoreCond(condStr) {
				return condStr.toString().replace(/\\_/g, "_").replace(/\\'/g, "'").replace(/\\%/g, "%").replace(/&gt;/g, ">").replace(/&lt;/g, "<").replace(/&amp;/g, "&");
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
		    
	        function onSelect_Year() {
	            pChackYN = "SEARCH";
	            pageNum = 1;
				selectYear = GetSelectVal("sel_year");
	            
	            if (selectYear != "ALL") {
	            	SearchCond[3] = selectYear;
	            	SearchCond[4] = "01";
	            	SearchCond[5] = "01";
	            	SearchCond[6] = selectYear;
	            	SearchCond[7] = "12";
	                SearchCond[8] = "31";
	            }
	            else {
	            	var nowyear = nowDate.substring(0,4);
			        var nowmonth = nowDate.substring(5,7);
			        var nowday = nowDate.substring(8,10);
	            	SearchCond[3] = nowyear-1;
	            	SearchCond[4] = nowmonth;
	            	SearchCond[5] = nowday;
	            	SearchCond[6] = nowyear
	            	SearchCond[7] = nowmonth;
	                SearchCond[8] = nowday;
                }
	            
	            GetDocList();
	        }
	        
			/* 2021-08-17  홍승비 - 현재 선택된 문서가 없다면 삭제사유 팝업 표출하지 않도록 수정 */	        
		    function btnDelete_onclick() {
		    	var SelList = new ListConstr();
				SelList.LoadFromID("DocList");
				var oArrRows = SelList.GetSelectedRows();
				
				if (oArrRows.length != 0) {
		    		PopupCenter("/admin/ezApprovalG/statisticsDelDocInfo.do?DocID=" + escape(DocID) ,"",520,350);
				} else {
					alert("<spring:message code = 'ezApprovalG.t360' />");
					return;
				}
		    }
			
		    function popupCallback(obj) {
				if(obj.flag == true) {
					GetDocList();
				}
			}
		    function PopupCenter(pageURL, title,w,h) 
			{
				  var left = (screen.width/2)-(w/2);
				  var top = (screen.height/2)-(h/2);
				  var targetWin = window.open (pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
				  return targetWin;
			} 
		    
		    // 선택한 리스트 개수에 맞춰 문서 리스트 표출하기
		    function endAprListCount(count) {
		    	 pChackYN = "FALSE";
				 pageNum = "1"; // 회사 선택 시 페이징 초기화
				 pageSize = count;   
				 GetDocList();
		    }
		    
		    // 현재 리스트 표출 문서 통합 PC 저장
		    function btnTotalSaveZip_onclick() {
		        listLoading(true);
		    	var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var allRows = DocList.GetDataRows();
		        var docIdList = "";
		        
		        if (allRows.length == 1 && allRows[0].id == "DocList_TR_noItems") {
		        	alert("<spring:message code='ezApprovalG.t1533'/>");
		        	listLoading(false);
			    	return;
			    }
		        
		        for (var i = 0; i < allRows.length; i++) {
		        	var docID = allRows[i].getAttribute("DATA1");
		        	if (allRows[i].getAttribute("delflag") != "Y") { // 삭제된 문서 제외
			        	docIdList += docID + "|||";
		        	}
		        }
		        
		        if (docIdList == "") { // 모든 문서가 삭제된 경우 - 문서 선택하라는 알림창 표출
		        	alert("<spring:message code='ezApprovalG.t1533'/>");
		        	listLoading(false);
		        	return;
		        }
		        
		        setCookie("fileDownload", "false");
		        blockUI();
		        
		        totalSaveAll(docIdList);
	    		
		    }
		   	
		    // 현재 리스트 표출 문서 엑셀다운로드
		    function btnExcel_onclick(AllFG) {
				var url;
				var tempPageSize = pageSize;
				var tempPageNum = "1";
				
				if (AllFG != 1) {
				    tempPageSize = pageSize;
				    tempPageNum = pageNum;
				}
				
				var DocList = new ListView();
				DocList.LoadFromID("DocList");
			    var allRows = DocList.GetDataRows();
			    
			    var allDelChk = false; // 전체 삭제 여부 확인
			    var delCount = 0;
			    for (var k = 0; k < allRows.length; k++) {
			    	if (allRows[k].getAttribute("delflag") == "Y") {
			    		delCount++;
			    	}
			    }
			    
			    if (delCount == allRows.length) {
			    	allDelChk = true;
			    }
				
			    if ((allRows.length == 1 && allRows[0].id == "DocList_TR_noItems") || allDelChk) {
			    	alert("<spring:message code='ezApprovalG.t1533'/>");
			    	return;
			    }
			    
	       		url = "/ezApprovalG/excelExportOut.do";
	       		if (approvalFlag == "G") {
					url += "?listType=SEARCH&P0=" + encodeURI(SearchCond[0]) + "&P1=" +
					encodeURI(SearchCond[1]) + "&P2=" + encodeURI(SearchCond[2]) + "&P3=" + encodeURI(SearchCond[3]) +
					"&P4=" + encodeURI(SearchCond[4]) + "&P5=" + encodeURI(SearchCond[5]) + "&P6=" + encodeURI(SearchCond[6]) +
					"&P7=" + encodeURI(SearchCond[7]) + "&P8=" + encodeURI(SearchCond[8]) + "&P9=" + encodeURI(SearchCond[9]) +
					"&P10=" + encodeURI(SearchCond[10]) + "&P11=" + encodeURI(SearchCond[11]) + "&P12=" + encodeURI(SearchCond[12]) +
					"&P13=" + encodeURI(SearchCond[13]) + "&P14=" + encodeURI(SearchCond[14]) + "&P15=" + "" + "&P16=" + "" + "&P17=" +
					 "" + "&P18=" + "" + "&P19=" + "" + "&P20=" + "" + "&P21=" + encodeURI(SearchCond[16]) +
					"&P23=" + encodeURI(SearchCond[17]) + "&P24=" + "ADMIN" + "&PN=" + encodeURI(tempPageNum) + "&PS=" + encodeURI(tempPageSize) + "&OC=" + encodeURI(OrderCell) +
					"&OO=" + "" + "&allFG=" + AllFG + "&SQ=" + encodeURI(restoreCond(SearchCond[18])) + "&orgCompanyID=" + pCompanyID;
	       		} else {
	       			url += "?listType=SEARCH&P0=" + encodeURI(SearchCond[0]) + "&P1=" + encodeURI(SearchCond[1]) +
					"&P2=" + encodeURI(SearchCond[2]) +
					"&P3=" + (SearchCond[3].toString().trim() != "" ? encodeURI(SearchCond[3] + "-" + SearchCond[4] + "-" + SearchCond[5]) : "" ) +
					"&P4=" + (SearchCond[6].trim() != "" ? encodeURI(SearchCond[6] + "-" + SearchCond[7] + "-" + SearchCond[8]) : "" ) +
					"&P5=" + (SearchCond[9].trim() != "" ? encodeURI(SearchCond[9] + "-" + SearchCond[10] + "-" + SearchCond[11] + " 00:00:01") : "") + 
					"&P6=" + (SearchCond[12].trim() != "" ? encodeURI(SearchCond[12] + "-" + SearchCond[13] + "-" + SearchCond[14] + " 23:59:59") : "") +
					"&P7=" + "" + "&P8=" + "" + "&P9=" + encodeURI(SearchCond[16]) +
					"&P10=" + "" + "&P11=" + encodeURI(SearchCond[17]) + "&P12=" + "ADMIN" +
					"&P13=" + "" + "&P14=" + "" + "&P15=" + "" + "&P16=" + "" + "&P17=" + "" + 
					"&P18=" + "" + "&P19=" + "" + "&P20=" + "" + "&P21=" + "" +
					"&P23=" + "" + "&P24=" + "ADMIN" + "&PN=" + encodeURI(tempPageNum) + "&PS=" + encodeURI(tempPageSize) + "&OC=" + encodeURI(OrderCell) +
					"&OO=" + "" + "&allFG=" + AllFG + "&SQ=" + encodeURI(restoreCond(SearchCond[18])) + "&orgCompanyID=" + pCompanyID;
	       		}
	           
			     window.frames["saveExcel"].location.href = url;
		    }
		    
		    function totalSaveAll(docIdList) {
		    	$.ajax ({
	    			url: "/ezApprovalG/totalSaveFileAll.do",
	    			type: 'POST',
	    			dataType: 'text',
	    			data: {
	    				docIDstr: docIdList,
	    				type: "END",
	    				orgCompanyID: pCompanyID
	    			}, success: function(result) {
	    				if (result == "FALSE") {
	    					alert("<spring:message code='ezApprovalG.t00017'/>");
	    				} else {
	    					AttachDownFrame.location.href = "/ezApprovalG/downloadAttach.do?filePath=" + encodeURIComponent(result) + "&isToDelFG=Y";
	    				}
	    				
	    				// 사용한 쿠키 삭제.
	    	    		setTimeout(() => delCookie(), 1000);
	    			}, error: function() {
	    				alert("<spring:message code='ezApprovalG.t00017'/>");
	    				unBlockUI();
	    				setTimeout(() => delCookie(), 1000);
	    			}
	    		});
		    }
		    
		    // 쿠키 초기화
		    function setCookie(cName, value){
		    	var date = new Date(0);
		    	document.cookie = cName + "=; expires=" + date.toUTCString() + ";path=/";
		    }
		    
		    // controller 에서 세팅해준 fileDownload 값이 true인 경우 로딩바 숨김.
		    function getCookie(name) {
		        var parts = document.cookie.split(name+"=");
		        if(parts.length == 2){
		            return parts.pop().split(";").shift();

		        }
		    }
		    
		    var downloadTimer;
		    
		    // 로딩바 표출 이후, fileDownload 값을 주기적으로 확인하여 true 인경우 loading 바 숨김. 
		    function blockUI() {
		        downloadTimer = setInterval(function() {
		            var token = getCookie("fileDownload");
		            if(token == "true") {
		                unBlockUI();
		            }
		        }, 1000 );
		    }
		    
		    function unBlockUI() {
		        listLoading(false);
		        clearInterval(downloadTimer);
		    }
		    
		    function delCookie() {
		    	 document.cookie = "fileDownload=; expires=" + new Date(0) + "; path=/;";
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
		
	    <h1><spring:message code = 'ezApprovalG.t1324' /><span id="mailBoxInfo"></span>
	        <span class="searchForm">
	        	<select id="selectType" class="text"; style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezApprovalG.t106'/></option>
		    		<option value="rad_Writer"><spring:message code='ezApprovalG.t445'/></option>
		    		<option value="rad_Department"><spring:message code='ezApproval.t437'/></option>
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
	            <c:if test="${not empty list}">
                    <li>
                        <select id="ListCompany" onChange="selectCompanyID()">
                            <c:forEach var="item" items="${list}">
                                <option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
                            </c:forEach>
                        </select>
                    </li>
        		</c:if>       	
        		
        		<%-- 2023-06-30 한태훈 - 관리자 완료문서 조회 > 통합PC저장, 내보내기(엑셀다운로드) 기능 추가 --%>
        		<li id="totalSaveZip"><span id="btnTotalSaveZip" onclick="return btnTotalSaveZip_onclick()"><spring:message code = 'ezApprovalG.t00008' /></span></li>
        		<li id="excelSave"><span id="btnExcelSave" onclick="return btnExcel_onclick(0)"><spring:message code = 'ezApprovalG.t1526' /></span></li>
	            <li id="GetEDMSXML" style="display:none"><span onclick="return SendEDM_onclick()"><spring:message code = 'ezApprovalG.t522' /></span></li>
	            <!-- 폐기버튼 숨김처리 -->
	            <%-- <li id="SearchCondi" class = "approvalG"><span onclick="return DisuseItem_onclick()"><spring:message code = 'ezApprovalG.t523' /></span></li> --%>	            
	            <li id="SearchCondi"><span class="icon16 icon16_search" onclick="return SearchCondi_onclick()"></span></li>

				<%-- 2023-06-30 한태훈 - 관리자 완료문서 조회 > 리스트 표출 개수 선택 기능 추가 --%>
				<div id="right" class="sub_frameIcon" style="float:right">	
					<div class="sub_frameIconUL02">
					  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="maillistoptiondiv" onclick="MailOptionView(this, 'N');"></span></p>  
					</div>
				</div>	
	      	 	<!-- 전체 문서 조회 년도별 select box 추가 -->
	      	 	<li style="vertical-align: middle; float:right">
	            	<select id="sel_year" name="sel_year" style="height:29px;" onchange="onSelect_Year(this);">
		            	<option value="ALL"><spring:message code ='ezApprovalG.kmsg01'/></option>
		        	</select>
		        </li>
		        <li id="tbtnDelete"><span class="icon16 icon16_delete" id="btnDelete" onclick="return btnDelete_onclick(1)"></span></li>
	        </ul>
	    </div>
	    
	    <div id="layer_Viewpopup" style="width: 150px; position: absolute; left: 1540px; top: 83px; background-color: rgb(255, 255, 255); display: none;">
	        <div class="popupwrap1">
	            <div class="popupwrap2">
	                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width: 80px;">
	                        <col>
	                    </colgroup>
						<tbody>
							<tr>
		                        <th><spring:message code='ezBoard.t10021'/></th>
		                        <td>
		                            <select id="listcount" style="width: 45px; height: 20px;" onchange="endAprListCount(this.value);">
		                                <option value="10">10</option>
		                                <option value="50">50</option>
		                                <option value="100">100</option>
		                            </select>
		                        </td>
		                    </tr>
		                </tbody>
	                </table>
	            </div>
	        </div>
	        <div class="shadow">
	        </div>
		</div>
	    
		<div class="div_scroll" style="width:100%;HEIGHT:375px; overflow:AUTO" id="divList">
	  		<div id="lvtDoclist" ></div>
		</div>
	 	<div id="tblPageRayer"></div>
	
		<%-- <div id="tabnav" style="width:100%">
	  		<ul>
			    <li id="tagsub1"><span onClick="pDocInfoValue='1';MM_swapImagesub('1', event);Approval_onclick()" ><spring:message code = 'ezApprovalG.t1769' /></span></li>
			    <li id="tagsub2">
			    	<span onClick="pDocInfoValue='2';MM_swapImagesub('2', event);Recipent_onclick()" >
			    		<c:choose>
			    			<c:when test="${approvalFlag == 'S' }">
				    			<spring:message code = 'ezApprovalG.t999932' />
			    			</c:when>
			    			<c:otherwise>
					    		<spring:message code = 'ezApprovalG.t950' />
			    			</c:otherwise>
			    		</c:choose>
			    	</span>
			    </li>
			    <li id="tagsub3"><span onClick="pDocInfoValue='4'; MM_swapImagesub('3', event);Attach_onclick()" ><spring:message code = 'ezApprovalG.t56' /></span></li>
			    <li id="tagsub4"><span onClick="pDocInfoValue='3'; MM_swapImagesub('4', event);Opinion_onclick()" ><spring:message code = 'ezApprovalG.t55' /></span></li>
	  		</ul>
		</div> --%>
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

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>

	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        //selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	        Tab1_NewTabIni("tab1");
	    </script>
	    
	     <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
		 <iframe id="saveExcel" name="saveExcel" style="display: none" ></iframe>
	</body>
</html>
