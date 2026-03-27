<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	    <style>
	    	.mainlist tr th {
	    		word-break: break-all;
	    	}
	    	.mainlist :not(tr) {
 				white-space: normal;
			}
	    </style>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/controls/ListView_Group.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/NameControl.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <script type="text/javascript">
		    var strListInfo = "";
		    var use_ocs = "<c:out value='${use_ocs}' />";
		    var searchStartTime = "";
			var searchEndTime = "";
			var CurPage = "";
			var totalPage = "";
			var totalCount = "";
			var BlockSize = 10;
			
		    window.onload = function () {
		    	
		        //getTime();
		        getGroupList(1, searchStartTime, searchEndTime);	
		        makePageSelPage();
		    }
		    
		    
	
		    
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
               /* $.datepicker
						.setDefaults($.datepicker.regional["<spring:message code='main.t0619'/>"]); */
			});
			
			
		 
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
		    	
		    });	   
		    
		    
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
		 
		 
		 
			// 페이징처리///////////////////////////////
				function td_Create1(strtext) {
					document.getElementById("tblPageRayer").innerHTML = strtext;
				}
			
				// 페이지네이션 클릭시
				function goToPage(page) {
					getGroupList(page, searchStartTime, searchEndTime);
				}
				

				function makePageSelPage() {
					var strtext;
					var PagingHTML = "";
					document.getElementById("tblPageRayer").innerHTML = "";
					strtext = "<div class='pagenavi'>";
					PagingHTML += strtext;
					var pageNum = CurPage;

					if (totalPage > 1 && pageNum != 1) {
						strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg first disabled'></span>"
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
							strtext = "<span onclick='goToPageByNum(" + i + ")'>"
									+ i + "</span>";
							PagingHTML += strtext;
						}
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
								+ ")'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg last disabled'></span>";
						PagingHTML += strtext;
					}

					PagingHTML += "</div>";
					td_Create1(PagingHTML);
				}

				function goToPageByNum(Value) {
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
		
				
		    function getGroupList(pageNum, searchStartTime, searchEndTime) {
		    	$.ajax({
		    		type : "GET",
		    		dataType : "xml",
		    		cache : false,
		    		data : {
		    			searchType2 : QuerySelect.options[QuerySelect.selectedIndex].value, // 검색옵션
						searchValue : document.getElementById("txt_SearchQuery").value,
						startDate : searchStartTime,
						endDate : searchEndTime,
						pageNum : pageNum,
						company : encodeURIComponent(companySelectID)
		    		},
		    		async : false,
		    		url : "/admin/ezSchedule/scheduleGroupList.do",		    		
		    		success: function(text){
		    			var listNode = SelectSingleNodeNew(text, "LISTVIEWDATA");
				        if (listNode == null) return;
				
				        var xmlDoc;
				        if (CrossYN()) {
				            var xmlLIST = createXmlDom();
				            var nodeToImport = xmlLIST.importNode(listNode, true);
				            xmlLIST.appendChild(nodeToImport);				
				            xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
				        }
				        else {
				            xmlDoc = createXmlDom();
				            xmlDoc.appendChild(listNode);
				        }
				        strListInfo = "";
				        document.getElementById("GroupList").innerHTML = "";
				        var xmldom = text;
				        var listview = new ListView();
				        listview.SetID("GroupListView");
				        listview.SetSelectFlag(false);
				        listview.SetMulSelectable(true);
				        //listview.SetRowOnClick("View_Detail");
				        listview.SetRowOnDblClick("show_groupinfo2");
				        listview.DataSource(xmlDoc);
				        listview.DataBind("GroupList");				        
				        xmldom = null;
		    		},
		    		error:function(request,status,error){
		    	        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    	    }

		    	});
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : 'json',
		    		data : {
		    			searchType2 : QuerySelect.options[QuerySelect.selectedIndex].value, // 검색옵션
						searchValue : document.getElementById("txt_SearchQuery").value,
						startDate : searchStartTime,
						endDate : searchEndTime,
						pageNum : pageNum
		    		},
		    		async : false,
		    		url : "/admin/ezSchedule/scheduleGroupListCount.do",		    		
		    		success: function(data){
		    			CurPage = data.currPage;
		    			totalPage = data.totalPage;
		    			totalCount = data.itemCnt;
		    		},
		    		error:function(request,status,error){
		    	        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    	    }

		    	});
		    	

		    	makePageSelPage();
		    }
		
		    function View_Detail(obj) {
		        document.getElementById("Group_View").innerHTML = "";
		        
		        var listview = new ListView();
		        listview.LoadFromID("GroupListView");
		        var Selected = listview.GetSelectedRows();
		        var DIV_Description = document.createElement("DIV");		       
		        var Span = document.createElement("SPAN");
		        Span.setAttribute("style", "color: #000; font-weight: bold;");
		        
		        if (CrossYN())
		            Span.textContent = "▒ " +strLang264;
		        else
		            Span.innerText = "▒ " +strLang264;		
		        
		        DIV_Description.appendChild(Span);
		        var P = document.createElement("P");
		        DIV_Description.appendChild(P);
		        var DIV = document.createElement("DIV");
		        DIV.style.width = "90%";
		        DIV.style.marginTop = "10px";
		        DIV.style.marginLeft = "5px";
		        DIV.style.wordBreak = "break-all";
		
		        if (CrossYN())
		            DIV.textContent = obj.getAttribute('data2');
		        else
		            DIV.innerText = obj.getAttribute('data2');
		
		        DIV_Description.appendChild(DIV);
		        DIV_Description.appendChild(P);
		
		        document.getElementById("Group_View").appendChild(DIV_Description);
		        
		        $.ajax({
		    		type : "GET",
		    		dataType : "xml",
		    		async : false,
		    		data : {
		    			groupID : obj.getAttribute('data1')
		    		},
		    		url : "/ezSchedule/getGroupDetail.do",		    		
		    		success: function(text){
		    			var P = document.createElement("P");
		                document.getElementById("Group_View").appendChild(P);
		
		                var DIV_GroupMember = document.createElement("DIV");
		                var Span = document.createElement("SPAN");
		                var BR = document.createElement("BR");
		                Span.setAttribute("style", "color: #000; font-weight: bold;");
		                
		                if (CrossYN())
		                    Span.textContent = "▒ " +strLang265;
		                else
		                    Span.innerText = "▒ " +strLang265;
		                
		                DIV_GroupMember.appendChild(Span);
		                var P = document.createElement("P");
		                DIV_GroupMember.appendChild(P);
		                
		                for (var i = 0; i < SelectNodes(text, "MEMBERID").length; i++)
		                {
		                    var DIV = document.createElement("DIV");
		                    DIV.style.marginLeft = "5px";
		                    DIV.style.marginTop = "5px";
		                    DIV.style.cursor = "hand";
		                    DIV.style.color = "#000";
		                    DIV.style.display = "inline-block";
		                    
		                    if (CrossYN()) {
		                        //if (use_ocs == "YES") {
		                            //DIV.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + SelectNodes(text, "MAIL").item(i).textContent + "\",this);'/></span><span style='margin-top:50px; cursor:pointer' id=" + SelectNodes(text, "MEMBERID").item(i).textContent + " onclick='show_member(this)'>" + SelectNodes(text, "INFO").item(i).textContent + "</span>";
		                            DIV.innerHTML = "<span style='margin-top:50px; cursor:pointer' id=" + SelectNodes(text, "MEMBERID").item(i).textContent + " data-dept="+SelectNodes(text, "DEPARTMENT").item(i).textContent +" onclick='show_member(this)'>" + SelectNodes(text, "INFO").item(i).textContent + "</span>";
		                        /* } else {
		                            DIV.innerHTML = SelectNodes(text, "INFO").item(i).textContent;
		                        } */
		                    } else {
		                        //if (use_ocs == "YES") {
		                            //DIV.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + SelectNodes(text, "MAIL").item(i).text + "\",this);'/></span><span style='margin-top:50px; ; cursor:pointer' id=" + SelectNodes(text, "MEMBERID").item(i).text + " onclick='show_member(this)'>" + SelectNodes(text, "INFO").item(i).text + "</span>";
		                            DIV.innerHTML = "<span style='margin-top:50px; ; cursor:pointer' id=" + SelectNodes(text, "MEMBERID").item(i).text + "data-dept="+SelectNodes(text, "DEPARTMENT").item(i).text +" onclick='show_member(this)'>" + SelectNodes(text, "INFO").item(i).text + "</span>";
		                        /* } else {
		                            DIV.innerHTML = SelectNodes(text, "INFO").item(i).text;
		                        } */
		                    }
		
		                    DIV_GroupMember.appendChild(DIV);
		                    var BR = document.createElement("BR");
		                    DIV_GroupMember.appendChild(BR);
		                }                    
		                document.getElementById("Group_View").appendChild(DIV_GroupMember);
		    		}
		        });		        
		    }
				     		
		    function show_member(obj) {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 450) / 2;
		        var pLeft = (pwidth - 420) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + obj.id + "&dept="+$(obj).data("dept"), "", "height=450px,width=420px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }
		
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		
		    var schedule_group_write_dialogArguments = new Array();
		  
					
		    function del_group() {
		    	var strListInfo = "";
		    	var checkId = $("input[name=chk_group]:checked");
		    	
		    	if(checkId.length == 0){
		    		 alert("<spring:message code='ezSchedule.t253' />");
			         return;
		    	}
		    	
		    	for(var i=0; i<$("input[name=chk_group]:checked").length; i++){
		    		strListInfo += $("input[name=chk_group]:checked")[i].id;
		    	}
		    	console.log('strListInfo : ' + strListInfo);
		    	 var count = strListInfo.split(';').length - 1;
		    	
		    
		        if (!confirm(count + " <spring:message code='ezSchedule.t254' />"))
		            return; 

		        $.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		async : false,
		    		data : {
		    			groupID : strListInfo
		    		},
		    		url : "/ezSchedule/scheduleDelGroup.do",
		    		success: function(text){
		    			alert(count + " <spring:message code='ezSchedule.t256' />");
			            window.location.reload(false);
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.t255' />");
		    		}
		        });
		        
		        parent.frames["left"].groupRefresh();
		    }
					
		     
		    
		    function search_GroupInfo() {
		    	
		    	
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

				searchStartTime = $('#startDatepicker').datepicker({dateFormat : 'yyyymmdd'}).val();
				searchEndTime = $('#endDatepicker').datepicker({dateFormat : 'yyyymmdd'}).val();
		    	
		    	
		    	
		    	
				var strQuery = document.getElementById("txt_SearchQuery").value;
				
				/* if(strQuery == "") {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
 					//OpenAlertUI("<spring:message code = 'ezCommunity.t75' />");
					alert("<spring:message code = 'ezCommunity.t75' />");
					return;
				}
				 */
				 
				getGroupList(1, searchStartTime, searchEndTime);

			}
		    
		    function get_search_GroupInfo(e) {
			    var kecode = e.keyCode;
			    
			    if (kecode == 13) {
			    	search_GroupInfo();
	
			        return false;
			    }
			    return true;
			}
		   
		 
		 function show_groupinfo2(obj) {
		    // 영어에서 ui 틀어짐 : 850 > 900 으로 수치 변경
		 	var checkRealID = "";
		 	var feature = GetOpenPosition(900, 550);
		 	
		 	var checkCnt = 0;
		 	var allChild = $("#GroupListView")[0].childNodes[1];
		     for (var i = 0;i < allChild.childNodes.length; i++) {
		     	if (allChild.childNodes[i].getElementsByTagName("td").item(0).childNodes.item(0).querySelector('input').checked){
		     		checkCnt++;
		     	}
		     }
		 	
		     if (checkCnt == 0) {
		         alert(strLang266);
		         return;
		     }
		 	
		 	if(obj == 'show'){
		 		var checkId = $('input:checked')
 				var groupColor = checkId[0].closest('tr').getAttribute("data3");
		 		if(checkId.length > 1){
		 			alert(strLang276);
		 			return;
		 		}else if(checkId.length == 0){
		 			alert(strLang266);
		 			return;
		 		}else{
		 			checkRealID = checkId[0].id.substring(0,checkId[0].id.length -1);
		 			window.open("/ezSchedule/scheduleGroupMember.do?groupID=" + checkRealID + "&groupColor=" + encodeURIComponent(groupColor), "schedule_group_modify", "height = 550px, width = 900px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
		 			return;
		 		}
		 	}else{
		 		
		 		var selectedTr = document.getElementById(obj);
		 		
		 		
		 		
		 		window.open("/ezSchedule/scheduleGroupMember.do?groupID=" + selectedTr.getAttribute("data1") + "&groupColor=" + encodeURIComponent(selectedTr.getAttribute("data3")), "", "height = 550px, width = 900px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
		 		
		 	}
			
		 }
		 
		 
		// 초기화버튼
			function reset() {
				$(function() {
					$('#txt_SearchQuery').val('');
					$('#startDatepicker').val('');
					$('#endDatepicker').val('');
					//getTime();
				});
			}
		

			// 2018-10-26 김민성 - 관리자 히스토리 새로고침 프로그래스 바 추가
			// 새로고침 클릭시 이벤트
			function reload() {
				//getTime();
				getGroupList(1, searchStartTime, searchEndTime);
				makePageSelPage();
				

			}

			var changeCompany = function() {
				reset();
				reload();
			};
		</script>
	</head>
	<body class="mainbody">		
	    <h1><spring:message code='ezSchedule.shb12' />
			<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
		</h1><br />
	    <div class="txt">▒ <spring:message code='ezSchedule.shb15' /></div>
	    <div class="txt" style="margin-top:3px">▒ <spring:message code='ezSchedule.t00006' /></div>
	    <div class="txt" style="margin-top:3px">▒ <spring:message code='ezSchedule.t00007' /></div>
<%-- 	    <div class="txt" style="margin-top:3px">▒ <spring:message code='ezSchedule.t00008' /></div> --%>
	    <div id="mainmenu" style="margin-top:20px">
	        <ul>
	            <li><span onClick="show_groupinfo2('show')"><spring:message code='ezSchedule.shb06' /></span></li>
	            <li><span class="icon16 icon16_delete" onclick='del_group();'></span></li>
	        </ul>

	    </div>
	 
	        <div>
	        
	        
	         <!-- <table class="mainlist" style="margin: 10px 0px;"> -->
	         <table style="width: 100%; background-color: #f8f8f8; border-top: 1px solid #e8e8e8; border-bottom: 1px solid #e8e8e8;">
				<tr>
					<th style="background-color: #f1f3f5; height: 26px; border: 1px solid #e2e3e6;"><spring:message code = 'ezCommunity.t1431' /></th>
					<td style=" border: 1px solid #e2e3e6;">
						<span id="idSpan" class="idSpan">${idSpanValue}</span>
						&nbsp;
						<span id="topmenu" style="width: 500px"><spring:message code='ezSchedule.shb16'/> : &nbsp; 
							<input type="text" id="startDatepicker" class="hasDatapicker" style="width: 100px;  height: 22px; text-align: center " readonly="readonly" /> ~ 
							<input type="text" id="endDatepicker" class="hasDatapicker" style="width: 100px;  height: 22px; text-align: center" readonly="readonly" />
						</span> 
						&nbsp;&nbsp;&nbsp;
						<select id="QuerySelect" name="QuerySelect" style=" height: 22px;">
							<option selected value="groupName"><spring:message code = 'ezAddress.t304' /></option>
							<option value="groupMembers" ><spring:message code = 'ezSchedule.t00001' /></option>
							<option value="creatorname" ><spring:message code = 'ezSchedule.shb20' /></option>
						</select>
						
						<input name="text" type="text" style="WIDTH:200px;  height: 25px;" id="txt_SearchQuery" onKeyPress="return get_search_GroupInfo(event)"> 
						
						
						<a class="imgbtn imgbck" style=" margin-bottom:0px;"><span onClick="search_GroupInfo()"><spring:message code = 'ezCommunity.t31' /></span></a>
			  		    <a class="imgbtn" ><span onclick="javascript:reset();"><spring:message code="ezSystem.x0033"></spring:message></span></a>
						<%-- <a class="imgbtn" ><span onclick="javascript:reload();"><spring:message code="ezSystem.x0037"></spring:message></span></a> --%>
			  		</td>
				</tr>
			</table>
			</div>	       
	                <div id="Group_View" style="display: none; padding:15px; width: 100%; height: 369px; margin-right: 5px; margin-bottom: 5px; margin-left: 5px; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; overflow-y: auto;">
	                </div>
	   
	   <div id="contentlist" style="width:100%; overflow: auto; height:650px">	         
	    <!-- <table class="mainlist" style="width:100%;"> -->
	    <br/>
	    <table  style="width:100%;">
	        <tr>
	            <td style="vertical-align:top; border-bottom:none">
	                <div id="GroupList" ></div>
	                <!-- <div id="GroupList" style ="BORDER:0;WIDTH:100%; height:400px; overflow-y: auto; border-top-color: #dbdbda; border-right-color: #dbdbda; border-bottom-color: #dbdbda; border-left-color: #dbdbda; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;"></div> -->
	            </td>
	            
	        </tr>
	    </table>
		</div>	    

		<div id="tblPageRayer" style="padding-top: 10px;"></div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

