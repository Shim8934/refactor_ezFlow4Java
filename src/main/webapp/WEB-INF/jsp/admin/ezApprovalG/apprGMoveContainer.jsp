<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t1674'/></title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	    <style>
	    
		/* 2018-08-02 김보미 - 검색 테이블 ui수정 */
	    /*table, td {
			white-space: nowrap;
			/* overflow-x: hidden; */
		/*	text-overflow: ellipsis;
		} */
		.mainlist, .mainlist th, .mainlist td {
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}		
		td {
			padding: 8px 5px;
		}
		#t1 {
			 border-top: 1px solid #e8e8e8;
			 border-left: 1px solid #e8e8e8;
			 border-right: 1px solid #e8e8e8;
			 background-color: #f8f8fa;
		}
		#t2 {
			 border-left: 1px solid #e8e8e8;
			 border-right: 1px solid #e8e8e8;
			 background-color: #f8f8fa;
		}
		#t3 {
			 border: 1px solid #e8e8e8;
			 border-top: 1px dotted #eee;
			 background-color: #f8f8fa;
		}
		.mainlist tr th {
			border-top:0px;
			border-bottom:1.5px solid #e2e3e6;
		}
	    </style>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/MoveContainer_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/Pagenation_Cross.js')}"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	    var Check = false, PeriodDocList;
	    var ScontID = "";
	    var P_CompanyID = "";
	    var ListIdx;
	    var text1 = "<spring:message code='ezStatistics.t1008'/>";
	    var text2 = "<spring:message code='ezApproval.t345'/>";
	    var deleteTimes = 0;		    
	    var pUse_Editor = "<c:out value='${useEditor}'/>";
	    
	    var CurPage = "";
		var totalPage = "";
		var totalCount = "";
		var BlockSize = 10;
		var searchStartTime = "";
		var searchEndTime = "";
		var std = "";
		var etd = "";
		var startDate = "";
		var endDate = "";
		var usedate = false;
		var strMoveListIDInfo = "";
		var pSelectTab = "completedoclist";
		var check = "false";
		var selectelem = null;
		var popupselTContName = "";
		//2018-10-16 김보미 - 프로그래스바
		var startTime = "";
		var endTime = "";
		var pSourceCompanyID = "";
		var pTargetCompanyID = "";
		
	    function window_onload() {
	   	
	    	getTime();
	    	P_CompanyID = $("#ListCompany").val();
    	    $("#startDatepicker").datepicker('disable');
	        $("#endDatepicker").datepicker('disable');
	        
	        //더블클릭으로 셀선택 방지
	        $(document).bind("selectstart", function(event){event.preventDefault();});
	        //드래그 방지
	        $(document).bind("dragstart", function(event){event.preventDefault();});
	        
	        //페이징 위치 조정
	        windowResize();
	        makePageSelPage();
	    }
	    
		// 검색값 입력 후 엔터키 입력 시 검색 호출
	    function search_keypress(evt) {
	        var evtKeyCode = (window.event) ? event.keyCode : evt.which;
	     if (evtKeyCode == "13") {
	            search(1);
	        }
	    }

	        function lvSDoc_onSel_DBclick() {
	            listview.LoadFromID("lvSDocForm");
	            listview2.LoadFromID("lvTDocForm");
	            var openLocation = "";
	            var oArrRows = listview.GetSelectedRows();
	            var length = listview.GetSelectedIndexes();
	            var DocID = GetAttribute(oArrRows[0], "DATA1");
	            var pURL = GetAttribute(oArrRows[0], "DATA2");
	            var formID = GetAttribute(oArrRows[0], "DATA6");
	            var orgDocid = GetAttribute(oArrRows[0], "DATA5");
	            if (trim_Cross(GetAttribute(oArrRows[0], "DATA5")) == "" || escape(orgDocid.replace(/ /gi, "")) == "%0A")
	                orgDocid = "";
	            else
	                orgDocid = GetAttribute(oArrRows[0], "DATA5");
	            
	            var ext = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
	
	            // 2018.08.01 (KLIB) - ezd 확장자 처리
	            if (ext == "hwp" || ext == "ezd") {
	            	if (isIE()) {
		            	openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
	                } else {
	                	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	                	alert(pAlertContent);
	                    
	                    return;
	                }
	            }
	            else {
	                if (CrossYN()) {
	                    openLocation = "/ezApprovalG/contDocView.do";
	                } else {
                        openLocation = "/ezApprovalG/contDocView.do";
	                }
	            }
	            openLocation = openLocation + "?docID=" + encodeURIComponent(DocID) + "&docHref=" + encodeURIComponent(pURL) + "&formID=" + encodeURIComponent(formID) + "&orgDocID=" + encodeURIComponent(orgDocid) + "&admin=Y";
	            var result = GetOpenWindow(openLocation, "", 1000, 950, "YES");
	        }

    
	    // 날짜 아이콘 적용 및 날짜 검색
		 function getTime() {
			
			var dateObj = new Date();
			var year = dateObj.getFullYear();
			var month = dateObj.getMonth() + 1;
			var date = dateObj.getDate();
			
			if (date < 10) {
				date = '0' + date;
			}
			
			if (month < 10) {
				month = '0' + month;
			}
			
			dateObj = year + "-" + month + "-" + date;
			searchStartTime = dateObj;
	    	searchEndTime = dateObj;
	    	
	    	$('#startDatepicker').val(dateObj);
			$('#endDatepicker').val(dateObj);
			
			std = $('#startDatepicker').val();
			etd = $('#endDatepicker').val();
			
		}
	
	    $(function() {
	    	$('#startDatepicker').datepicker({
	    		changeMonth: true,
	    		changeYear: true,
	    		autoSize: true,
	    		showOn: "both",
	    		buttonImage: "/images/ImgIcon/calendar-month.png",
	    		buttonImageOnly: true,
	    		maxDate: 0,
	    		onSelect: function(selected) {
	    			compareDateStart();
    				etd = $('#endDatepicker').val();
	    		}
	    	});
	    	
	    	$('#endDatepicker').datepicker({
	    		changeMonth: true,
	    		changeYear: true,
	    		autoSize: true,
	    		showOn: "both",
	    		buttonImage: "/images/ImgIcon/calendar-month.png",
	    		buttonImageOnly: true,
	    		maxDate: 0,
	    		onSelect: function(selected) {
	    			compareDateEnd();
    				std = $('#startDatepicker').val();
	    		}
	    	});  
	    	
	    	 	var SDate = new Date();
		        var EDate = new Date();
		        
		        $("#startDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#startDatepicker").datepicker('setDate', SDate);
		
		        $("#endDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#endDatepicker").datepicker('setDate', EDate);
	    	
	    });
	    
		function compareDateStart() {
			startDate = new Date($("#startDatepicker").datepicker("getDate"));
			endDate = new Date($("#endDatepicker").datepicker("getDate"));
			
			if (startDate - endDate > 0) {
				std = $('#startDatepicker').val();
				$('#endDatepicker').val(std);
			}		
			
		}
	   	
	   	function compareDateEnd() {
			startDate = new Date($("#startDatepicker").datepicker("getDate"));
			endDate = new Date($("#endDatepicker").datepicker("getDate"));
			
			if (endDate - startDate < 0) {
				etd = $('#endDatepicker').val();
				$('#startDatepicker').val(etd);
			} 
			
		}
	   	
	   	var dayMsg = "<spring:message code='main.kyj1'/>";
		var dayStr = dayMsg.split(";");
		var monthMsg = "<spring:message code='main.kyj2'/>";
		var monthStr = monthMsg.split(";");
	    
		$(function() {
			$.datepicker.regional["<spring:message code='main.t0619'/>"] = {
				closeText : "<spring:message code='main.t3'/>",
				prevText : "<spring:message code='main.t0604'/>",
				nextText : "<spring:message code='main.t0605'/>",
				currentText : "<spring:message code='main.t0606' />",
				monthNames : monthStr,
				monthNamesShort : monthStr,
				dayNames : dayStr,
				dayNamesShort : dayStr,
				dayNamesMin : dayStr,
				weekHeader : 'Wk',
				dateFormat : 'yy-mm-dd',
				firstDay : 0,
				isRTL : false,
				duration : 200,
				showAnim : 'show',
				showMonthAfterYear : true
			};
			$.datepicker
					.setDefaults($.datepicker.regional["<spring:message code='main.t0619'/>"]);
		});
		
		// 페이징처리
		function td_Create1(strtext) {
			document.getElementById("tblPageRayer").innerHTML = strtext;
		}

		function makePageSelPage() {
			var strtext;
			var PagingHTML = "";
			$("#tblpageRayer").html("");
			$("#listInfo").html("&nbsp;&nbsp;<span class='txt_color'>" + totalCount + " </span>");
			strtext = "<div class='pagenavi'>";
			PagingHTML += strtext;
			var pageNum = CurPage;

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

			if(MaxNum != ""){
				for (i = startNum; i <= MaxNum; i++) {
					if (i == pageNum) {
						strtext = "<span class='on'>" + i + "</span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span onclick='goToPageByNum(" + i + ")'>"
								+ i + "</span>";
						PagingHTML += strtext;
					}
				}
			} else {
				PagingHTML += '<span class="on">1</span>';
			}

			if (totalPage > BlockSize) {
				if (totalPage >= parseInt(((parseInt((pageNum - 1)
						/ BlockSize) + 1) * BlockSize) + 1)) {
					strtext = "";
					strtext = strtext
							+ "<span class='btnimg next' onclick='return selafterBlock()'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "";
					strtext = strtext
							+ "<span class='btnimg next disabled'></span>";
					PagingHTML += strtext;
				}
			} else {
				strtext = "";
				strtext = strtext
						+ "<span class='btnimg next disabled'></span>";
				PagingHTML += strtext;
			}

			if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
				strtext = "<span class='btnimg last' onclick='return goToPageByNum("
						+ totalPage
						+ ")'>\</span>";
				PagingHTML += strtext;
			} else {
				strtext = "<span class='btnimg last disabled'></span>";
				PagingHTML += strtext;
			}

			PagingHTML += "</div>";
			td_Create1(PagingHTML);
		}
		
		function goToPageByNum(Value) {
			
			if ($("#checkboxAll").is(":checked")) {
	    		$("#checkboxAll").prop("checked", false);
	    		$(".row_body").css("background", "");
	    	}
			
			strMoveListIDInfo = "";
			
			CurPage = Value;
			makePageSelPage();
			goToPage(CurPage);
		}
		
		function selbeforeBlock() {
			var pageNum = parseInt(CurPage);
			pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
			goToPageByNum(pageNum);
		}

		function selbeforeBlock_one() {
			var pageNum = parseInt(CurPage);

			if (parseInt(pageNum - 1) > 0) {
				goToPageByNum(parseInt(pageNum - 1));
			} else {
				return;
			}
		}

		function selafterBlock() {
			var pageNum = parseInt(CurPage);
			pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
			goToPageByNum(pageNum);
		}

		function selafterBlock_one() {
			var pageNum = parseInt(CurPage);

			if (parseInt(pageNum + 1) <= totalPage) {
				goToPageByNum(parseInt(pageNum + 1));
			} else {
				return;
			}
		}
		
		function goToPage(page) {
			getDocListjson(page);
		}
		
		function chk_onselect(obj) {
			if (obj.checked) {
	            strMoveListIDInfo += $(obj).attr("id") + ";";
	            selectelem = null;
	        } else {
	            strMoveListIDInfo = ReplaceText(strMoveListIDInfo, $(obj).attr("id") + ";", "");
	            selectelem = obj.closest("tr");
	        }
	    }
		
		function select_row(elem) {		    	
			if ($("#checkboxAll").is(":checked")) {					
				if ($("input[id='" + $(elem).attr("id") + "']").prop("checked") == true && selectelem != null) {//전체 선택 후 개별 선택 시 선택한것 해제
					$("input[id='" + $(elem).attr("id") + "']").prop("checked", false);
					$(".row_body[id='" + $(elem).attr("id") + "']").css("background", "#ffffff");
					strMoveListIDInfo = ReplaceText(strMoveListIDInfo, $(elem).attr("id") + ";", "");
		    		return;
				}
				
				// 목록에서 하나씩 다른거 선택할 때
				if ((selectelem != null && selectelem != elem)) {
					strMoveListIDInfo += $(elem).attr("id") + ";";
		            
		        	selectelem = null;
		    	}
			} else {					
				// 목록에서 하나씩 다른거 선택할 때
		    	if ((selectelem != null && selectelem != elem)) {
 					$("input[name=myCheckbox]").prop("checked", false);
 					$(".row_body").css("background", "#ffffff");	 					
					strMoveListIDInfo = $(elem).attr("id") + ";";
		        	selectelem = null;
		    	}
			}

			// 체크 후 체크박스 눌러서 체크 해제할 때
	        if (selectelem != null) {
				if ($("#checkboxAll").is(":checked")) {
		        	$("input[id='" + $(elem).attr("id") + "']").prop("checked", false);
		        	$(".row_body[id='" + $(elem).attr("id") + "']").css("background", "#ffffff");
					return;
				} else {
		        	selectelem.style.backgroundColor = "#ffffff";
		        	$("input[id='" + $(selectelem).attr("id") + "']").prop("checked", false);
		            selectelem = null;
		            return;
				}
	        }

	        selectelem = elem;
	        elem.style.backgroundColor = "#f1f8ff";
	        $("input[id='" + $(elem).attr("id") + "']").prop("checked", true);

	        // 목록화면 나오고 처음 선택할 때 strMoveListIDInfo 값 셋팅
	        if (strMoveListIDInfo == "") {
	        	strMoveListIDInfo = $(elem).attr("id") + ";";
	        }
	    }
		
		  function selectAll() {
				$(selectelem).css("background", "#ffffff");

				var deleteListID = [];
				
				if ($("#checkboxAll").is(":checked")) {
					strMoveListIDInfo = "";

					$(":checkbox[name=myCheckbox]").prop("checked", true);
					$(".row_body").css("background", "#f1f8ff");

					$(":checkbox[name=myCheckbox]:checked").each(function(){
						deleteListID.push($(this).attr("id") + ";")
					});

					for (var i = 0; i < deleteListID.length; i++) {
						strMoveListIDInfo += deleteListID[i];
					}
				} else {
					strMoveListIDInfo = "";
					selectelem = null;

					$(":checkbox[name=myCheckbox]").prop("checked", false);
					$(".row_body").css("background", "");
				}
				
		    }
		  
		// 검색 버튼 클릭시 이벤트
		function search(pageNum) {
			$(function() {

				if ($('#DocNumber').val().trim() == "") {
					$('#DocNumber').val('');
				}

				if ($('#startDatepicker').val() != ''
						&& $('#endDatepicker').val() == '') {
					alert(strLang5);
					return false;
				}

				if ($('#startDatepicker').val() == ''
						&& $('#endDatepicker').val() != '') {
					alert(strLang6);
					return false;
				}
				$("#checkboxAll").prop("checked", false);

				getDocListjson(pageNum);

			});
		}
		
		function DateSearch_Click() {
	        if(usedate){
	        	usedate = false;
	            $("#startDatepicker").datepicker('disable');
	            $("#endDatepicker").datepicker('disable');
	        } else {
	        	usedate = true;
	            $("#startDatepicker").datepicker('enable');
	            $("#endDatepicker").datepicker('enable');
	        }
	    }
		 
		 function RefreshView(){
		 
			 getDocListjson(CurPage);
			 search(CurPage);
			 
		 }
		 
		function reload() {
			var SDate = new Date();
	        var EDate = new Date();
	        $("#startDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#endDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#startDatepicker").datepicker('setDate', SDate);
	        $("#endDatepicker").datepicker('setDate', EDate);
			$("#startDatepicker").datepicker('disable');
	        $("#endDatepicker").datepicker('disable');
	        
			$(":checkbox[id=usedate]").prop("checked", false);
			usedate = false;
			$("#checkboxAll").prop("checked", false);
	        
	        $("#DocNumber").val("");
			$("#DocTitle").val("");
			$("#drafter").val("");
			$("#drafterdept").val("");
			
			getDocListjson(1);
		}
		
		function openDoc(obj) {
			
			var DocID = $(obj).attr("id");
			var pURL = $(obj).attr("dochref");
			var formID = $(obj).attr("formid");
			var orgDocid = $(obj).attr("orgdocid");
			
			if ($(obj).attr("orgdocid") == "" || $(obj).attr("orgdocid") == "null" ||escape(orgDocid.replace(/ /gi, "")) == "%0A")
	            orgDocid = "";
	        else
	            orgDocid = $(obj).attr("orgdocid");
			
			var openLocation = "/ezApprovalG/contDocView.do";
			openLocation += "?docID=" + encodeURIComponent(DocID) + "&docHref=" + encodeURIComponent(pURL) + "&formID=" + encodeURIComponent(formID) + "&orgDocID=" + encodeURIComponent(orgDocid) + "&admin=Y";
			console.log(openLocation);
			GetOpenWindow(openLocation, "", 1000, 950, "YES");
		}
		
	        var Init_Flag, pChackYN, DocListType;
	
	        var organ_dialogArguments = new Array();
	        function bt_SDeptSelect_onclick() {
	            organ_dialogArguments[0] = P_CompanyID;
	            organ_dialogArguments[1] = bt_SDeptSelect_onclick_Complete;
	            var result = GetOpenWindow("/admin/ezApprovalG/apprGOrgan.do", "Organ_Cross", 400, 485, "NO");
	        }
	
	        function bt_SDeptSelect_onclick_Complete(retVal) {
	            var Flag;
	            if (typeof (retVal) != "undefined") {
	                document.getElementsByName("SDeptName")[0].id = retVal[0];
	                document.getElementsByName("SDeptName")[0].value = retVal[1];
	                pSourceCompanyID = retVal[2]; // 보낼부서의 회사ID를 설정
	                pChackYN == "FALSE"
	                if(document.getElementsByName("SDeptName")[0].id == ""){
	                	document.getElementsByName("drafterdept")[0].id = "";
		                document.getElementsByName("drafterdept")[0].value = "";
		                pSourceCompanyID = "";
	                }
	            }
	            Flag = "SDeptName";
	            getDocType(Flag);
	            ScontID = document.getElementsByName("selSContName")[0].value;
				
	            if (ScontID != "") {
	            	getDocListjson(1);
	            } else {
	            	if(retVal[0] != "" && retVal[1] !="") {
 	            		document.getElementsByName("SDeptName")[0].id = "";
 		                document.getElementsByName("SDeptName")[0].value = "";
						pSourceCompanyID = "";
	            		alert("<spring:message code='ezApprovalG.t1788'/>");
	            	}
	            	//$('#DocCompleteListBody').empty().append("<tr><td colspan='11' style='text-align:center;'>"+text1+"</td></tr>");
	            	$('#DocCompleteListBody').empty().append("<tr><td colspan='10' style='text-align:center;'>"+text1+"</td></tr>");
	            	CurPage = "";
	        		totalPage = "";
	        		totalCount = "";
	            	makePageSelPage();
	            }
				$("#checkboxAll").prop("checked", false);

	        }
	
	        function bt_TDeptSelect_onclick(obj) {
	        	if(document.getElementsByName("SDeptName")[0].id == null || document.getElementsByName("SDeptName")[0].id == ""){
	        		alert("<spring:message code='ezApproval.t345'/>");
	        		return;
	        	}
	            organ_dialogArguments[0] = P_CompanyID;
	            if (obj.id == "spanrecev") {
	            	organ_dialogArguments[1] = bt_TDeptSelect_onclick_Complete;
	            } else {
	            	organ_dialogArguments[1] = bt_TDeptSelect_onclick_Complete_spanvdept;
	            }
	            var result = GetOpenWindow("/admin/ezApprovalG/apprGOrgan.do", "Organ_Cross", 400, 485, "NO");
	        }
	        
	        function bt_TDeptSelect_onclick_Complete(retVal) {
	            if (typeof (retVal) != "undefined") {
	                document.getElementsByName("drafterdept")[0].id = retVal[0];
	                document.getElementsByName("drafterdept")[0].value = retVal[1];
	            }
	            getDocListjson(1);
	        }
	        
	        function bt_TDeptSelect_onclick_Complete_spanvdept(retVal) {
	        	if (typeof (retVal) != "undefined") {
	                document.getElementsByName("drafterdept")[0].id = retVal[0];
	                document.getElementsByName("drafterdept")[0].value = retVal[1];
	            }
	            getDocListjson(1);
	        }	
	
	        function bt_selSContName_onclick() {
	            if (document.getElementsByName("selSContName")[0].value != ScontID) {
	                ScontID = document.getElementsByName("selSContName")[0].value;
	                pChackYN == "FALSE"
	                getDocListjson(1);
	            }
	        }
	
	        var approval_admin_popup_choicedept_dialogArguments = new Array();
	        
	        function bt_OK_onclick() {
	        	if (document.getElementsByName("SDeptName")[0].value != "") {
	        	 if (CrossYN()) {
	        		 	approval_admin_popup_choicedept_dialogArguments[0] = "one";
		                approval_admin_popup_choicedept_dialogArguments[1] = bt_OK_onclick_Complete;
		                approval_admin_popup_choicedept_dialogArguments[2] = pSourceCompanyID;
		                var OpenWin = window.open("/admin/ezApprovalG/approvGAdminPopupChoiceDept.do", "approvalGAdminPopupChoiceDept", GetOpenWindowfeature(500, 180));
		                try { OpenWin.focus(); } catch (e) { }
		            } else {
		                var feature = GetShowModalPosition(500, 180);
		                var rtnValue = window.showModalDialog("/admin/ezApprovalG/approvalGAdminPopupChoiceDept.do", "","dialogHeight:180px;dialogwidth:360px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
		                
		                if (typeof (rtnValue) != "unlimited" && rtnValue == "OK") {
		                    window.location.reload(false);
		                }
		            }
	        	}
			}
	        
	        function bt_OK_onclick_Complete(retVal) { 
	        	
	        	popupselTContName = retVal[0];
	        	
	        	if(popupselTContName!=undefined && popupselTContName != "" ) {
		        	var length = $("input:checkbox[name=myCheckbox]:checked").length;
			        if (length > 0 && check == 'false') {
			            if (popupselTContName == null || popupselTContName == '')
			                alert("<spring:message code='ezApprovalG.t1676'/>")
						else {
						    var Ans = confirm("<spring:message code='ezApprovalG.t1677'/>");
						    if (Ans) {
						    	if (popupselTContName == $("select[name=selSContName]").val()) {
						    		alert("<spring:message code='ezCircular.t109'/>");
						    	} else {
							    	ContMove();
									getDocListjson(CurPage);
						    	}
						    }
						}
			        } else {
			            alert("<spring:message code='ezApprovalG.t1570'/>");
			        }
			        $("#checkboxAll").prop("checked", false);
	        	} else {
		            alert("<spring:message code='ezApprovalG.t1676'/>");
	        		strMoveListIDInfo = "";
					selectelem = null;
					$("#checkboxAll").prop("checked", false);
					$(":checkbox[name=myCheckbox]").prop("checked", false);
					$(".row_body").css("background", "");
	        	}
	        }
	        
	        function bt_All_onclick() {
	        	if (document.getElementsByName("SDeptName")[0].value != "") {
	        	 if (CrossYN()) {
	        		 	approval_admin_popup_choicedept_dialogArguments[0] = "all";
		                approval_admin_popup_choicedept_dialogArguments[1] = bt_All_onclick_Complete;
		                approval_admin_popup_choicedept_dialogArguments[2] = pSourceCompanyID;
		                var OpenWin = window.open("/admin/ezApprovalG/approvGAdminPopupChoiceDept.do", "approvalGAdminPopupChoiceDept", GetOpenWindowfeature(500, 180));
		                try { OpenWin.focus(); } catch (e) { }
		            } else {
		                var feature = GetShowModalPosition(500, 180);
		                var rtnValue = window.showModalDialog("/admin/ezApprovalG/approvalGAdminPopupChoiceDept.do", "","dialogHeight:180px;dialogwidth:360px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
		                
		                if (typeof (rtnValue) != "unlimited" && rtnValue == "OK") {
		                    window.location.reload(false);
		                }
		            }
	        	}
	        }
	        
	        function bt_All_onclick_Complete(retVal) {
				check = "true";
				popupselTContName = retVal[0];
				if(popupselTContName!=undefined && popupselTContName != "" ) {
				if (popupselTContName == null || popupselTContName == '' 
	        			|| $("select[name=selSContName]").val() == null || $("select[name=selSContName]").val() == '') {
	                alert("<spring:message code='ezApprovalG.t1676'/>");
	                
	        	}
				else {
				    var Ans = confirm("<spring:message code='ezApprovalG.t1541'/><spring:message code='ezApprovalG.t1677'/>");
				    if (Ans) {
				    	if (popupselTContName == $("select[name=selSContName]").val()) {
				    		alert("<spring:message code='ezCircular.t109'/>");
				    	} else {
					        ContMove();
					        getDocListjson(1);
				    	}
				    }
				}
				        
	        } else {
	            alert("<spring:message code='ezApprovalG.t1676'/>");
        		strMoveListIDInfo = "";
				selectelem = null;
				$(":checkbox[name=myCheckbox]").prop("checked", false);
				$(".row_body").css("background", "");
	        }
	        	$("#checkboxAll").prop("checked", false);
				check = "false";
	        }
	        
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 235;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") == -1) {
	        		height = height - 20;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
		    
	        //2018-10-16 김보미 - 프로그래스바		
			function ShowMailProgress() {
	        	startTime = new Date();//프로그래스바 시작시간
				CurrenWidth = document.body.clientWidth;
	        	
			    document.getElementById("mailPanel").style.display = "";
			    document.getElementById("MailProgress").style.top = "400px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
			    document.getElementById("MailProgress").style.display = "";
			}
			function HiddenMailProgress() {
			    document.getElementById("mailPanel").style.display = "none";
			    document.getElementById("MailProgress").style.display = "none";
			}
			function keyword_Clear() {
		        document.getElementsByName('drafterdept')[0].value = "";
		        document.getElementsByName('drafterdept')[0].id = "";
		        getDocListjson(1);
		    }
			function all_keyword_Clear() {
		        document.getElementsByName('SDeptName')[0].value = "";
		        document.getElementsByName('SDeptName')[0].id = "";
		        document.getElementsByName('drafterdept')[0].value = "";
		        document.getElementsByName('drafterdept')[0].id = "";
		        $("select[name=selSContName]").val("");
		        ScontID = "";
		        totalCount = "";
		        //$('#DocCompleteListBody').empty().append("<tr><td colspan='11' style='text-align:center;'>"+text1+"</td></tr>");
		        $('#DocCompleteListBody').empty().append("<tr><td colspan='10' style='text-align:center;'>"+text1+"</td></tr>");
		        makePageSelPage();
		    }
			
			function selectCompanyID() {
				if (P_CompanyID != document.getElementById("ListCompany").value) {
					P_CompanyID = document.getElementById("ListCompany").value;
					all_keyword_Clear();
				}
			}
	    </script>
	</head>
	
	<body class="mainbody" onLoad="javascript:window_onload()">
		<h1><spring:message code='ezApprovalG.t1678'/><span id="listInfo"></span>
			<%-- 2020-10-20 홍승비 - 회사선택 셀렉트박스 추가 --%>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select class="companySelect" id="ListCompany" onChange="selectCompanyID()">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</h1>
		<span style="float:right; margin-top: -20px;"><spring:message code='ezApproval.psb01'/></span>
<%-- 		<input type="hidden" id="ListCompany" value="${userInfo.companyID }" > --%>
		<!-- 2018-08-02 김보미 - 검색테이블 ui 수정 -->	
		<!-- <table style="width:100%;">		
			<tr>
				<table id = "t1" style="width:100%;border-top:1px solid #e8e8e8">
					<tr>
						<td style="width:60px;">
							<spring:message code='ezApprovalG.kes04'/>  
						</td>
						<td style="width:200px;">
							<input type="text" id="SDeptName" name="SDeptName" style="width: 110px; height: 23px;" readonly="readonly" />
			 	            <a class="imgbtn" name="SDeptSelect"><span onclick="bt_SDeptSelect_onclick()"><spring:message code='ezApprovalG.t105'/></span></a>
						</td>
						<td style="width:50px;">
							<spring:message code='ezApproval.t611'/>
						</td>
						<td style="width:80px;">
							<select name="selSContName" style="width:110px; height: 23px;" onchange="return bt_selSContName_onclick()"></select>
						</td>
						<td style="width:50px;">
							<spring:message code='ezApproval.t434'/> 
						</td>
						<td style="width:80px;">
							<input type="text" id="DocNumber" name="DocNumber" style="width: 110px; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)" />
						</td>
						<td style="width:50px;">
							<spring:message code='ezApproval.t435'/> 
						</td>
						<td style="width:80px;">
							<input type="text" id="DocTitle" name="DocTitle" style="width: 110px; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)"/>
						</td>
						<td style=" width:*; margin-bottom: 10px; padding: 8px 5px;">
						</td>
					</tr>
				</table>
			</tr>
			<tr>
			<table id ="t2" style="width:100%;">
				<tr>
					<td style="width:60px;">
							 <spring:message code='ezApproval.t437'/>
					</td>
					<td style="width:200px;">
							<input type="text" id="drafterdept" name="drafterdept" style="width: 110px; height: 23px;" maxlength="50" readonly="readonly"/>
							<a class="imgbtn" name="TDeptSelect"><span id = "spandept" onclick="bt_TDeptSelect_onclick(this)"><spring:message code='ezApprovalG.t105'/></span></a>
					</td>
					<td style="width:50px;">
						    <spring:message code='ezApproval.t436'/> 
					</td>
					<td style="width:80px;">
							<input type="text" id="drafter" name="drafter" style="width:110px; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)"/>
					</td>
					<td style="width: 70px;">
							<input type="checkbox" id="usedate" value="1" onclick="DateSearch_Click();"><label for="usedate"><spring:message code='ezSystem.x0032'/></label>
					</td>
					<td style="width: 250px;">
						<span id="topmenu" style="width: 500px">
							<input type="text" id="startDatepicker" class="hasDatapicker" style="width:90px; text-align: center" readonly="readonly" />&nbsp; ~ &nbsp;
							<input type="text" id="endDatepicker" class="hasDatapicker" style="width:90px; text-align: center" readonly="readonly" />
						</span>						
					</td>
					<td style="width: 290px;">
						<a class="imgbtn" >
							<span onclick="javascript:search(1);"><spring:message code="ezApproval.t236"></spring:message></span>
						</a>&nbsp;
						<a class="imgbtn">
							<span onClick="reload()"><spring:message code='ezApprovalG.t165' /></span>
						</a>&nbsp;
						<a class="imgbtn">
							<span onClick="bt_OK_onclick()"><spring:message code='ezApproval.t25005' /></span>
						</a>&nbsp;
						<a class="imgbtn">
								<span onClick="bt_All_onclick()"><spring:message code='ezApprovalG.t1679' /></span>
						</a>
					</td>
					<td style=" width:*; margin-bottom: 10px;">
					</td>
				</tr>
			</table>
			</tr>
		</table> -->
		<table style="width:100%;">		
			<tr>
				<table id = "t1" style="width:100%;border-top:1px solid #e8e8e8;border-bottom:1px solid #e8e8e8">
					<tr>
						<td style="width:6%;">
							<spring:message code='ezApprovalG.kes04'/>  
						</td>
						<td style="width:17%;">
							<input type="text" id="" name="SDeptName" style="width: 72%; height: 23px;" readonly="readonly" onmousedown="all_keyword_Clear()"/>
			 	            <a class="imgbtn" name="SDeptSelect"><span onclick="bt_SDeptSelect_onclick()"><spring:message code='ezApprovalG.t105'/></span></a>
						</td>
						<td style="width:6%;">
							<spring:message code='ezApproval.t611'/>
						</td>
						<td style="width:12%;">
							<select name="selSContName" style="width:84%; height: 23px;" onchange="return bt_selSContName_onclick()"></select>
						</td>
						<td style="width:7%;">
							<spring:message code='ezApproval.t434'/> 
						</td>
						<td style="width:22%;">
							<input type="text" id="DocNumber" name="DocNumber" style="width: 80%; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)" />
						</td>
						<td style="width:6%;">
							<spring:message code='ezApproval.t435'/> 
						</td>
						<td style="width:24%;">
							<input type="text" id="DocTitle" name="DocTitle" style="width: 51%; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)"/>
						</td>
					</tr>
					<tr>
						<td>
							<spring:message code='ezApproval.t437'/>
						</td>
						<td>
							<input type="text" id="" name="drafterdept" style="width: 72%; height: 23px;" maxlength="50" readonly="readonly" onmousedown="keyword_Clear()"/>
							<a class="imgbtn" name="TDeptSelect"><span id = "spandept" onclick="bt_TDeptSelect_onclick(this)"><spring:message code='ezApprovalG.t105'/></span></a>
						</td>
						<td>
							<spring:message code='ezApproval.t436'/> 
						</td>
						<td>
							<input type="text" id="drafter" name="drafter" style="width:84%; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)"/>
						</td>
						<td>
							<div class='custom_checkbox'><input type="checkbox" style="vertical-align: middle; margin: -1px 4px 0px 0px;" id="usedate" value="1" onclick="DateSearch_Click();"><label for="usedate"><spring:message code='ezSystem.x0032'/></label></div>
						</td>
						<td>
							<span id="topmenu" style="width: 500px">
								<input type="text" id="startDatepicker" class="hasDatapicker" style="width:90px; text-align: center" readonly="readonly" />&nbsp; ~ &nbsp;
								<input type="text" id="endDatepicker" class="hasDatapicker" style="width:90px; text-align: center" readonly="readonly" />
							</span>						
						</td>
						<td colspan="2">
							<a class="imgbtn" >
								<span onclick="javascript:search(1);"><spring:message code="ezApproval.t236"></spring:message></span>
							</a>
							<a class="imgbtn">
								<span onClick="reload()"><spring:message code='ezApprovalG.t165' /></span>
							</a>
							<a class="imgbtn">
								<span onClick="bt_OK_onclick()"><spring:message code='ezApproval.t25005' /></span>
							</a>
							<a class="imgbtn">
								<span onClick="bt_All_onclick()"><spring:message code='ezApprovalG.t1679' /></span>
							</a>
						</td>
					</tr>
				</table>
			</tr>
		</table>
		
		<div id="contentlist" style="width: 100%; height: 610px; overflow: auto; margin-top:5px">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr id = "doclist">
						<th style="width:3%;"><div class='custom_checkbox'><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 4px; vertical-align:middle"/></div></th>
						<th style="width:15%;"><spring:message code="ezApproval.t434"></spring:message></th>
						<th style="width:3%;"><img src="/images/newAttach.gif"></th>
						<th style="width:*;"><spring:message code="ezApprovalG.t106"></spring:message></th>
						<th style="width:10%;"><spring:message code="ezApproval.t433"></spring:message></th>
						<th style="width:10%;"><spring:message code="ezApproval.t437"></spring:message></th>
						<th style="width:10%;"><spring:message code="ezApprovalG.t445"></spring:message></th>
						<th style="width:5%;"><spring:message code="ezStatistics.t1042"></spring:message></th>
						<%-- <th style="width:5%;"><spring:message code="ezTask.t210"></spring:message></th> --%> <!-- 상태 주석 -->
						<th style="width:10%;"><spring:message code="ezApproval.t448"></spring:message></th>
						<th style="width:5%;"><spring:message code="ezApprovalG.t47"></spring:message></th>
					</tr>
				</thead>
				<tbody id="DocCompleteListBody" style="overflow: auto;">
					<tr>
						<%-- <td colspan="11" style="text-align: center; font-size: 12px;"> --%>
						<td colspan="10" style="text-align: center; font-size: 12px;">
							<spring:message code="ezApprovalG.t1126"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="tblPageRayer"></div>
		
	    <!-- 2018-10-16 김보미 - 프로그레스바 -->
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" >&nbsp;</div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
        <img src="/images/email/progress_img.gif" style="padding-top:20px;">
        <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
</html>
