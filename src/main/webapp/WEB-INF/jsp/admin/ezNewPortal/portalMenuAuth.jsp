<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezNewPortal.t070' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezJournal/journal_css.css')}" type="text/css" />
		<style>
	    	.mainlist tr td:first-child {
	    		padding-left:15px;
	    	}
			tr.hover:not(.selectTR):hover {
				background:#eee;
				color:#fff;
			}
			.selectTR{
				background-color: rgb(237, 244, 253);
			}
			
			.nameTD {width:70%;}
			.authTD {position:relative;}
			.portlet_tabpart01_top{text-align:center;} 
			#portalJikwi, #portalJikcheck {width: 100%; height: 510px; overflow: auto; background-color: #ffffff;}
			.titleListTR:hover, .groupListTR:hover {background-color : #f4f5f5; cursor:pointer;}
			.titleListTR.selectTR, .groupListTR.selectTR {background-color:#f1f8ff;}
			#portalGroup {height:478px;width: 100%; overflow: auto; background-color: #ffffff;}
			#portalGroup_btn {width:100%;padding:0;}
	    </style>
	</head>
	<body class="popup" style="overflow: hidden;"> 
        <h1 style="height:20px;"><spring:message code='ezNewPortal.t070' /></h1>
        <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"></span></li>
	        </ul>
	    </div>
	    <table style="width:100%">
			<tr>
				<td>
					<table id="TreeViewTD">
					 	<tr>
				        	<td id="journalOrgan_content" style='vertical-align: top'>
				        		<div class="portlet_tabpart01" style="width: 680px;">
					        		<div class="portlet_tabpart01_top" id="tab1" style="margin-top: 25px;margin-bottom: 2px;">
						            	<p><span id="1tab1" tdname="portalOrgan" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)" class="tabon"><spring:message code='ezNewPortal.t024' /></span></p>
						            	<%-- !!!TODO!!! 테마별, 포틀릿별 권한은 못사용하게 해놨어요! 로직은 구현되어있지만 나중에 QC할때는 이부분 주석풀어주세요 --%>
<%--						            	<c:if test="${mode eq 'menu' || mode eq 'portlet' }"> --%>
											<p><span id="1tab2" tdname="portalJikwi" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)" class=""><spring:message code='ezEmail.t28'/></span></p>
											<p><span id="1tab3" tdname="portalJikcheck" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)" class=""><spring:message code='ezEmail.t281'/></span></p>
											<p><span id="1tab4" tdname="portalGroup" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)" class=""><spring:message code='ezPersonal.yej05'/></span></p>
<%--						            	</c:if>--%>
						        	</div>
 		                            <!-- <h2 class="receiver_tltype01" style='margin-top:4px; border-bottom:none;'> 
										<span style="min-width: 45px;" id="PermissionStr"><spring:message code='ezNewPortal.t024' /></span>
 									</h2> -->
								</div>
								<div id="portalOrgan_content">
					        		<div class="portlet_tabpart03" style="background-color: #f8f8fa; margin-top: 2px; padding:0px; border-top: none;">
					                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #eaeaea;">
					                        <table style="margin-top: 3px; width: 100%;">
					                            <tr>
					                                <td>
					                                    <div style="float: left; margin-left: 5px;">
					                                        <select id="search_type" style="height:22px">
					                                            <option selected value="displayname"><spring:message code='ezOrgan.t67'/></option>
									                            <option value="cn"><spring:message code='ezOrgan.t94'/></option>
									                            <option value="description"><spring:message code='ezOrgan.t68'/></option>
									                            <option value="title"><spring:message code='ezOrgan.t69'/></option>
									                            <option value="telephonenumber"><spring:message code='ezOrgan.t95'/></option>
									                            <option value="mobile"><spring:message code='ezOrgan.t96'/></option>
									                            <option value="HomePhone"><spring:message code='ezOrgan.t97'/></option>
									                            <option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98'/></option>
									                            <option value="mail"><spring:message code='ezOrgan.t99'/></option>
									                            <option value="streetAddress" style="display:none"><spring:message code='ezOrgan.t100'/></option>
					                                        </select>
					                                        <input id="keyword" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){fn_serach('search'); return false;}" value="" style="width: 130px; margin: 0px;height:22px" />
					                                        <a class="imgbtn"><span onclick="fn_serach('search')"><spring:message code='ezOrgan.t101'/></span></a>
					                                    </div>
					                                </td>
					                                <td>
					                                    <div style="float: right; margin-right: 5px; position: relative;">
					                                    	<a class="imgbtn"><span onclick="setAuthorViewUser('dept')"><spring:message code='ezNewPortal.t071' /></span></a>
					                                    	<a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezCircular.t161' /></span></a>  
					                                    </div>
					                                </td> 
					                                <td></td>   
					                            </tr>
					                        </table>
					                    </div>
				                  	</div>
									<table style="margin-top: 3px;">
							            <tr>
							                <td class="box" style="border-right: 0px; height: 465px;">
							                    <div style="width: 250px; height: 470px; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
							                </td>
							                <td></td>
							                <td class="listview" style="width: 426px" id="orglistView">
							                </td>    
							            </tr>
							        </table>
						        </div>
								<div id="portalJikwi_content" style="display:none;">
									<div class="border_gray">
										<div id="portalJikwi">
											<table id="pListViewJikwi" cellspacing="0" cellpadding="0" multiselectable="true" useocs="false" rowondblclick="InsertReceiver" width="100%" border="0" class="mainlist">
												<thead id="pListViewJikwi_THEAD">
													<tr id="pListViewJikwi_TH">
														<th id="pListViewJikwi_TH_0" class="h4_center" bgcolor="#CCCCCC" width="70px"><spring:message code='ezPersonal.yej07'/></th>
													</tr>
												</thead>
												<tbody id="pListViewJikwi_TBODY"></tbody>
											</table>
										</div>
									</div>
						        </div>
								<div id="portalJikcheck_content" style="display:none;">
									<div class="border_gray">
										<div id="portalJikcheck">
											<table id="pListViewJikcheck" cellspacing="0" cellpadding="0" multiselectable="true" useocs="false" rowondblclick="InsertReceiver" width="100%" border="0" class="mainlist">
												<thead id="pListViewJikcheck_THEAD">
													<tr id="pListViewJikcheck_TH">
														<th id="pListViewJikcheck_TH_0" class="h4_center" bgcolor="#CCCCCC" width="70px"><spring:message code='ezPersonal.yej07'/></th>
													</tr>
												</thead>
												<tbody id="pListViewJikcheck_TBODY"></tbody>
											</table>
										</div>
									</div>
						        </div>
								<div id="portalGroup_content" style="display:none;">
									<table id="portalGroup_btn" class="mainlist">
										<tr>
											<td>
												<a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="groupmember_click()"><spring:message code='ezEmail.t598' /></span></a>
											</td>
										</tr>
									</table>
									<div class="border_gray">
										<div id="portalGroup">
											<table id="pListViewGroup" cellspacing="0" cellpadding="0" multiselectable="true" useocs="false" rowondblclick="InsertReceiver" width="100%" border="0" class="mainlist">
												<thead id="pListViewGroup_THEAD">
													<tr id="pListViewGroup_TH">
														<th id="pListViewGroup_TH_0" class="h4_center" bgcolor="#CCCCCC" width="70px"><spring:message code='ezPersonal.yej07'/></th>
													</tr>
												</thead>
												<tbody id="pListViewGroup_TBODY"></tbody>
											</table>
										</div>
									</div>
						        </div>
		                  	</td>   
	                        <td style="width: 30px; text-align: center;">                            
	                            <img id='addAuthBtn' src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;"><br>
	                            <img id='deleteAuthBtn' src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;">
	                        </td>
	                        <td style='vertical-align: top'>
	                        	<div style="margin-top: 27px;margin-bottom: 2px; border-bottom: 1px solid #565b66; width: 252px;">
		                            <h2 class="receiver_tltype01" style='margin-top:4px; border-bottom:none;'>
										<span style="min-width: 45px;" id="PermissionStr"><spring:message code='ezNewPortal.t072' /> </span>
									</h2>
								</div>
								<div class="receiver_borderbox" style="border-top: 1px solid #ddd; margin-top: 2px;">
									<div id="authList" style="width: 250px; Height: 482px; overflow-x: auto; overflow-y: auto;">
									</div>
								</div>
								<table class="content" style="width: 100%;">
									<tbody>
									<tr>
										<th><spring:message code='ezBoard.t999025' /></th>
										<td>
											<input type="checkbox" id="admin_OK" name="admin_OK" disabled onclick="checkbox_onclick(event)">&nbsp;<spring:message code='ezSurvey.t51' />
											<input type="checkbox" id="admin_NO" name="admin_NO" disabled onclick="checkbox_onclick(event)">&nbsp;<spring:message code='ezSurvey.t50' />
										</td>
									</tr>
									</tbody>
								</table>
	                        </td>
	                    </tr>
	                </table>
	      		</td> 
			</tr>
        </table>
		<div class="btnposition btnpositionNew">
	    	<a class="imgbtn" onClick="ok_Click()" ><span><spring:message code='ezJournal.t15' /></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezJournal/journal_script.js')}"></script>
	   	<script type="text/javascript">
	   		//트리조직도 JSON
	   		var treeContent;
	   		// 설정된 권한목록
	   		var menuAuths = new Array();
	   		// 선택된 수신자 이름
	   		var userName = "";
	   		// 선택된 수신자 아이디
	   		var selUserId = "";
	   		// 선택된 수신자 이름
	   		var selUserName = "";
	   		// 현재 로그인된 사용자 아이디
	   		var userId = "<c:out value='${userId}'/>";
	   		// 즐겨찾기 저장, 수정 flag
	   		var type = "new";
	   		
	   		var selDeptId = "";
	   		
	   		var CurPage = "1";
	   		var totalPage = "";
	        var Tab1_SelectID = "1tab1";
	   		//권한설정의 위치 : theme, menu, portlet
	   		var mode = "<c:out value='${mode}'/>";
	   		
	   		document.onselectstart = function () { return false; };
	   		function close_Click(){
	   			window.close();
	   		}
	   		/**
	   			2018-07-10 페이징 기능 추가
	   		*/
	   		var BlockSize = 10;
	   		
	    	var td_Create1 = function(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
	    	}
	    	
	    	var makePageSelPage = function() {
		        var strtext;
	        	var PagingHTML = "";
	        	document.getElementById("tblPageRayer").innerHTML = "";
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
	        	for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
	    	            PagingHTML += strtext;
	            	} else {
	                	strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                	PagingHTML += strtext;
	            	}
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
	    	
	    	var goToPageByNum = function(Value) {
	        	CurPage = Value;
	        	makePageSelPage();
	        	movePage(CurPage);
	    	}
	    	
	    	var selbeforeBlock = function() {
		        var pageNum = parseInt(CurPage);
	        	pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	        	goToPageByNum(pageNum);
	    	}
	    	
	    	var selbeforeBlock_one = function() {
		        var pageNum = parseInt(CurPage);
	        	if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
	        	else
		            return;
	    	}
	    	
	    	var selafterBlock = function() {
		        var pageNum = parseInt(CurPage);
	        	pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	        	goToPageByNum(pageNum);
	    	}
	    	
	    	var selafterBlock_one = function() {
		        var pageNum = parseInt(CurPage);
	        	if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
	    	        return;
	    	}
	    	
	    	var movePage = function(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	            	CurPage = newPage;
	            	if(issearch) {
		                search_click();
	            	} else {
		                setUserList();
	            	}
	        	}
	    	}
	    	
	    	var prevPage_onclick = function() {
		        newPage = parseInt(CurPage) - 1;
	        	if (newPage > 0) {
		            CurPage = newPage;
	            	if (issearch) {
		                search_click();
	            	} else {
		                setUserList();
	            	}
	        	}
	    	}
	    	var nextPage_onclick = function() {
		        newPage = parseInt(CurPage) + 1;
	        	if (newPage <= parseInt(totalPage)) {
		            CurPage = newPage;
	            	if (issearch) {
		                search_click();
	            	} else {
		                setUserList();
	            	}
	        	}
	    	}

			// 하위부서 허용/불가 클릭 이벤트
			function checkbox_onclick(e) {
				if (!CrossYN()) {
					srcElementID = window.event.srcElement.id;
				} else {
					srcElementID = e.target.id;
				}

				var checkFlag = "Y";
				if (srcElementID == "admin_OK") {
					document.getElementById("admin_OK").checked = true;
					document.getElementById("admin_NO").checked = false;
					checkFlag = "Y";
				} else {
					document.getElementById("admin_OK").checked = false;
					document.getElementById("admin_NO").checked = true;
					checkFlag = "N";
				}

				var container = document.getElementById("authList");
				var selectedRow = container.querySelectorAll("tr.selectTR");

				if (selectedRow == "" || selectedRow.length == 0)
					return;

				selectedRow[0].setAttribute("data-subdeptPermitted", checkFlag);
				var user = menuAuths.find(item => item.userId === selectedRow[0].getAttribute("data-id"));
				if (user) {
					user.subdeptPermitted = checkFlag;
				}

			}

	   		//조직도 뿌리는 펑션
	   		var setDeptList = function() {
				$('#treeview').on('changed.jstree', function (e, data) {
			     	var id = data.instance.get_node(data.selected).id;
			     	var deptName = $("#"+id+" a:first").text();
			     	/**
			     		조직도를 뿌린다는 것 = 왼쪽 조직도에서 해당 부서를 선택하는 것
			     		페이지, 겸색여부, 키워드 등 초기화
			     	*/
			     	CurPage = 1;                  
			     	issearch = false; 
			     	$("#keyword").val("");
			     	
					setUserList("DEPARTMENT", id,deptName);
					selUserId = "";
				  })
				.jstree({ 
					'core'   : {'data' : treeContent, 'multiple' : false},
					'plugins': ["wholerow"],
					'themes' : {'responsive' : true}
				}).on('ready.jstree', function(e, data) {
					var offset = $(".jstree-wholerow-clicked").offset();
		   	    	var jstree = document.getElementById("treeview");
		   	        $('#treeview').animate({scrollTop : offset.top - jstree.offsetHeight / 2}, 40);
			    });
	   		}
	   		
	   		//사원 리스트 뿌리기
	   		var setUserList = function(key, value, deptName) {
	   			if(key === undefined && value === undefined && deptName === undefined) {
	   				key = "DEPARTMENT";
	   				value = $(".jstree-wholerow-clicked").parent()[0].id;
	   				deptName = $("#"+value+" a:first").text();
	   			}
	   			
	   			var listType = getOrganListType();
	   			
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezNewPortal/userList.do",
	   				data:{"key" : key, "value" : value, "deptName" : deptName, "companyId":"<c:out value='${companyId}'/>", "listType" : listType, "curPage" : CurPage },
	   				success: function(result){
	   					var picList = $(result).find(".organwrap");
	   					if(picList.length == 0 && key != "DEPARTMENT"){
	   						alert("<spring:message code='ezCommunity.t1379'/>");
	   						issearch = false;
	   					}
	   					$("#orglistView").empty();
		   				$("#orglistView").html(result);
						/**
							2018-07-10 페이징 기능 추가.
						*/
		   				$("#orglistView").append("<div id='tblPageRayer' style='text-align:center;'></div>");
						totalPage = Math.ceil($("#totalCount").val() / 50 );
		   				makePageSelPage();
	   				}
	   			});
	   		}
	   		
	   		function getOrganListType() {
	        	var organListType = "TXT";
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/getListType.do",
	        		async : false,
	        		success : function(result) {
	        			organListType = result;
	        		}
	        	});
	        	
	        	return organListType;
	        }
	   		
	   		//검색
	   		function fn_serach(type) {
	   			var value = $("#keyword").val().trim();
	   			
	   			if (value == '' || value == undefined) {
	   				alert("<spring:message code='ezSchedule.t8'/>");	
	   			} else {
	   				search_click(type);	
	   			}
	   		}
	   		
	   		var issearch = false;
	   		var searchKey = "";
	   		function search_click(type) {
	   			var key = $("#search_type").val();
	   			
	   			if ($("#keyword").val().trim()!= '' && $("#keyword").val().trim() != undefined) {
	   				searchKey = $("#keyword").val().trim();
	   			}
	   			
	   			if(searchKey){
	   				if(type === "search") {
	   					CurPage = 1;            // 검색을 할 때마다 curPage 초기화
	   					issearch = true;
	   				}
		   			setUserList(key, searchKey);
	   			} else {
	   				alert("<spring:message code='ezSchedule.t8'/>")
	   			}
	   		}
	   		
	   		//오른쪽 리스트에서 클릭이벤트 적용
	   		function setMainListUserAuthorDept(elem) {
				$("#admin_OK").removeAttr("disabled");
				$("#admin_NO").removeAttr("disabled");
				
	   			if ($(elem).parent().parent().parent().attr("id") === "authList"){
		   			$("#authList tr").removeClass("selectTR");
	   			}
	   			
	   			$(elem).addClass("selectTR");

				if (elem.getAttribute("data-usertype") == "0") {
					document.getElementById("admin_OK").disabled = false;
					document.getElementById("admin_NO").disabled = false;
					var subdeptPermitted = elem.getAttribute("data-subdeptPermitted")

					if (subdeptPermitted == "Y" || subdeptPermitted == "true") {
						document.getElementById("admin_OK").checked = true;
						document.getElementById("admin_NO").checked = false;
					} else {
						document.getElementById("admin_OK").checked = false;
						document.getElementById("admin_NO").checked = true;
						elem.setAttribute("data-subdeptPermitted", "N");
					}
				} else {
					document.getElementById("admin_OK").disabled = true;
					document.getElementById("admin_OK").checked = false;
					document.getElementById("admin_NO").disabled = true;
					document.getElementById("admin_NO").checked = true;
				}
	   		}
	   		
	   		// 조직도 사원목록 클릭이벤트 적용
	   		function setUserAuthorDept(elem) {
	   			if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "DeptUserImgList") {
		   			$("#DeptUserImgList tr").removeClass("selectTR");
	   			}
	   			
	   			$(elem).addClass("selectTR");
	   			selUserId = $(elem).attr("id");
	   			selUserName = $(elem).attr("name");
	   			selDeptId = $(elem).attr("deptId");
	   			//user / dept 구분
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
	   		
	   		function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != Tab1_SelectID) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	   		
		    function ChangeTab(obj) {
		    	var pSelectTab = GetAttribute(obj, "tdname");
		    	curTab = pSelectTab;
		    	
		        switch (pSelectTab) {
		            case "portalOrgan":
	                    document.getElementById("portalOrgan_content").style.display = "";
	                    document.getElementById("portalJikwi_content").style.display = "none";
	                    document.getElementById("portalJikcheck_content").style.display = "none";
	                    document.getElementById("portalGroup_content").style.display = "none";
		                break;
		            case "portalJikwi":
	                    document.getElementById("portalOrgan_content").style.display = "none";
	                    document.getElementById("portalJikwi_content").style.display = "";
	                    document.getElementById("portalJikcheck_content").style.display = "none";
	                    document.getElementById("portalGroup_content").style.display = "none";
	                    getTitleList('001');
		                break;
		            case "portalJikcheck":
	                    document.getElementById("portalOrgan_content").style.display = "none";
	                    document.getElementById("portalJikwi_content").style.display = "none";
	                    document.getElementById("portalJikcheck_content").style.display = "";
	                    document.getElementById("portalGroup_content").style.display = "none";
	                    getTitleList('002');
		                break;
		            case "portalGroup":
	                    document.getElementById("portalOrgan_content").style.display = "none";
	                    document.getElementById("portalJikwi_content").style.display = "none";
	                    document.getElementById("portalJikcheck_content").style.display = "none";
	                    document.getElementById("portalGroup_content").style.display = "";
	                    getPermissionGroup();
		                break;
		    	}
		        selMainListUserId = "";
				selUserId = "";
		    }
		    
		    var getTitleList = function(type) {
		    	var request = new XMLHttpRequest();
		    	request.open('POST', '/admin/ezNewPortal/getTitleList.do', true);
				request.setRequestHeader('Content-Type', 'application/json');

		    	request.onload = function() {
		    		if (this.status >= 200 && this.status < 400) {
		    			var titleList = JSON.parse(request.responseText);
		    			//pListViewJikwi_TBODY
		    			var titleListCount = titleList.length;
		    			
		    			if (type == "001") {
		    		    	document.getElementById("pListViewJikwi_TBODY").innerHTML = "";
		    			} else {
		    		    	document.getElementById("pListViewJikcheck_TBODY").innerHTML = "";
		    			}
		    			
		    			for (var i = 0; i < titleListCount; i++) {
		    				var titleTR = document.createElement("tr");
		    				var titleTD = document.createElement("td");
		    				titleTR.className="titleListTR";
		    				titleTR.id = "title_" + titleList[i].jobID + "_" + titleList[i].type;
		    				titleTR.setAttribute("data1", titleList[i].jobID);
		    				titleTR.setAttribute("data2", titleList[i].type);
		    				titleTR.setAttribute("data3", titleList[i].displayName);
		    				titleTR.setAttribute("ondblclick", "applyReceiver()");
		    				titleTR.setAttribute("onclick", "setSelectTR(this)");
		    				titleTD.textContent = titleList[i].displayName;
		    				titleTD.style.height = "24px";
		    				
		    				titleTR.appendChild(titleTD);
		    				
			    			if (type == "001") {
			    		    	document.getElementById("pListViewJikwi_TBODY").appendChild(titleTR);
			    			} else {
			    				document.getElementById("pListViewJikcheck_TBODY").appendChild(titleTR);
			    			}
		    			}
		    		} else {

		    		}
		    	};

		    	request.onerror = function() {
		    		// There was a connection error of some sort
		    	};
		    	
		    	var data = JSON.stringify({
		    		companyId : "<c:out value='${companyId}'/>",
		    		type : type
		    	});
		    	
		    	request.send(data);
		    }
		    
		    var getPermissionGroup = function() {
		    	var request = new XMLHttpRequest();
		    	request.open('POST', '/admin/ezNewPortal/getGroupList.do', true);
				request.setRequestHeader('Content-Type', 'application/json');

		    	request.onload = function() {
		    		if (this.status >= 200 && this.status < 400) {
		    			var groupList = JSON.parse(request.responseText);
		    			//pListViewJikwi_TBODY
		    			var groupListCount = groupList.length;
		    		    document.getElementById("pListViewGroup_TBODY").innerHTML = "";
		    		    
		    			for (var i = 0; i < groupListCount; i++) {
		    				var groupTR = document.createElement("tr");
		    				var groupTD = document.createElement("td");
		    				groupTR.className="groupListTR";
		    				groupTR.id = "group_" + groupList[i].groupID;
		    				groupTR.setAttribute("data1", groupList[i].groupID);
		    				groupTR.setAttribute("data3", groupList[i].groupName);
		    				groupTR.setAttribute("ondblclick", "applyReceiver()");
		    				groupTR.setAttribute("onclick", "setSelectTR(this)");
		    				groupTD.textContent = groupList[i].groupName;
		    				groupTD.style.height = "24px";
		    				
		    				groupTR.appendChild(groupTD);
			    			document.getElementById("pListViewGroup_TBODY").appendChild(groupTR);
		    			}
		    		} else {

		    		}
		    	};

		    	request.onerror = function() {
		    		// There was a connection error of some sort
		    	};
		    	
		    	var data = JSON.stringify({
		    		companyId : "<c:out value='${companyId}'/>",
		    		type : type
		    	});
		    	
		    	request.send(data);
		    }
		    
		    var setSelectTR = function(elem) {
		    	$(".selectTR").removeClass("selectTR");
		    	$(elem).addClass("selectTR");
		    }
		    
	   		// 선택한 사람을 수신자에 추가
	   		function setAuthorViewUser(isUser) {
	   			
	   			var receiverId = "";
	   			var userType = 1;
		   		var userDeptName = "";
		   		
		   		if (isUser == undefined) {
		   			isUser = "user";
		   		}
	   			
	   			if (isUser == "dept"){
	   				receiverId = $(".jstree-clicked").attr("id");
	   				receiverId = receiverId.substring(0, receiverId.lastIndexOf("_anchor"));
	   				userType = 0;
	   				userName = $(".jstree-clicked").text();
	   				userDeptName = $(".jstree-clicked").text();
	   			} else if (isUser == "jikwi") {
	   				userType = 2;
	   				var selectedElem = document.getElementById("pListViewJikwi_TBODY").querySelector(".selectTR");
	   				receiverId = selectedElem.getAttribute("data1");
	   				userName = selectedElem.getAttribute("data3");
	   			} else if (isUser == "jikcheck") {
	   				userType = 3;
	   				var selectedElem = document.getElementById("pListViewJikcheck_TBODY").querySelector(".selectTR");
	   				receiverId = selectedElem.getAttribute("data1");
	   				userName = selectedElem.getAttribute("data3");
	   			} else if (isUser == "group") {
	   				userType = 4;
	   				var selectedElem = document.getElementById("pListViewGroup_TBODY").querySelector(".selectTR");
	   				receiverId = selectedElem.getAttribute("data1");
	   				userName = selectedElem.getAttribute("data3"); 
	   			} else if (isUser == "user") {
	   				receiverId = selUserId;
					userType = 1;
			   		userName = selUserName;
			   		userDeptName = $(".jstree-clicked").text();
	   			}
		   		
		   		var chkFlag = true;
	   			
	   			var menuId = Number("<c:out value='${menuId}'/>");
	   				
		   		for(var i = 0; i < menuAuths.length; i++) {
		   			if (menuAuths[i].userId == receiverId) {
		   				chkFlag = false;
		   			}
		   		}
		   		
		   		if (chkFlag) {
		   			menuAuths.push({"userName" : userName, "userId" : receiverId, "userDeptName" : userDeptName, "menuId" : menuId, "userType" : userType, "accessYN" : false, "subdeptPermitted" : "N"});
		   		} else {
		   			alert("<spring:message code='ezJournal.t127'/>");
		   		}
		   		
		   		drawAuths();
	   		}
	   		
	   		// 권한목록배열에서 삭제
		    var deleteAuth = function() {
	    		var selectedAuthId = document.querySelector('#authList tr.selectTR').dataset.id;
	    		
		    	menuAuths.some(function(item, index) {
		    		if (item.userId === selectedAuthId) {
		    			menuAuths.splice(index, 1);
		    		}
		    	});
		    	
		     	drawAuths();
		    }
	   		
	   		var drawAuths = function() {
	   			var authsHTML = "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
	   			authsHTML += "<tr><th class='nameTD'><spring:message code='ezNewPortal.t073' /></th><th class='authTD'><spring:message code='ezNewPortal.t074' /></th></table>";
	   			
				menuAuths.forEach(function(item, index) {
					authsHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
					
					authsHTML += "<tr style='cursor:pointer;' class='hover'";
					authsHTML += " data-id=" + item.userId;
					authsHTML += " data-userName=" + item.userName;
					authsHTML += " data-userDeptName=" + item.userDeptName;
					authsHTML += " data-userType=" + item.userType;
					authsHTML += " data-accessYN=" + item.accessYN;
					authsHTML += " data-subdeptPermitted=" + item.subdeptPermitted;
					authsHTML += " onclick='setMainListUserAuthorDept(this)' ondblclick='deleteAuth()'>";
					authsHTML += "<td class='nameTD'>";
					
					if (item.userType == 1) {
						authsHTML += item.userName;
						/* authsHTML += "(" + item.userDeptName + ")"; */
					} else if(item.userType == 0) {
						authsHTML +=  "<spring:message code='ezBoard.t9'/>" + " : " + item.userDeptName;
					} else if (item.userType == 2){
						authsHTML += "<spring:message code='ezEmail.t28'/>" + " : " + item.userName;
					} else if (item.userType == 3) {
						authsHTML += "<spring:message code='ezEmail.t281'/>" + " : " + item.userName;
					} else if (item.userType == 4) {
						authsHTML += "<spring:message code='ezPersonal.yej05'/>" + " : " + item.userName;
					} else {
						authsHTML += item.userName;
					}
					
					authsHTML += "</td>";
					
					authsHTML += "<td class='authTD'>";
					
					if (item.accessYN === true) {
						authsHTML += "<label class='switch'><input type='checkbox' checked><span class='slider round'></span></label>";
					} else {
						authsHTML += "<label class='switch'><input type='checkbox'><span class='slider round'></span></label>";
					}
					
					authsHTML += "</td>";
				});
	   			
	   			document.getElementById("authList").innerHTML = authsHTML;
	   			
	   			$("input[type='checkbox']").change(function() {
	   				var isChecked = $(this).is(":checked");
	   				var userId = $("#authList").find(".selectTR").attr("data-id");
	   				
	   				var menuAuthCount = menuAuths.length;
	   				
	   				menuAuths.forEach(function(item, index) { 
	   					if (item.userId == userId) {
	   						menuAuths[index].accessYN = isChecked;
	   					}
	   				});
	   			});
		    }
	   		
	   		function applyReceiver() {
	   			var selId = "";
	   			
	   			if (Tab1_SelectID === "1tab1") {
	   				selId = $("#txtlist_Layer").find(".selectTR");
		   			
		   			var isUser = true;
		   			
		   			if (selId.length == 0) {
		   				isUser = false;
		   			}
		   			
		   			if (isUser) {
		   				//사람추가 조건은 음 사람셀렉트안됫을떄?
		   				setAuthorViewUser("user");
		   				
		   			} else {
		   				//부서추가
		   				setAuthorViewUser("dept");
		   			}
	   			} else if (Tab1_SelectID === "1tab2") {
	   				selId = $("#pListViewJikwi_TBODY").find(".selectTR");
	   				
	   				if (selId.length != 0) {
	   					setAuthorViewUser("jikwi");
	   				}
	   			} else if (Tab1_SelectID === "1tab3") {
	   				selId = $("#pListViewJikcheck_TBODY").find(".selectTR");
	   				
	   				if (selId.length != 0) {
	   					setAuthorViewUser("jikcheck");
	   				}
	   			} else if (Tab1_SelectID === "1tab4") {
	   				selId = $("#pListViewGroup_TBODY").find(".selectTR");
	   				
	   				if (selId.length != 0) {
	   					setAuthorViewUser("group");
	   				}
	   			}
  				
	   		}
	   		
	   		function infoview_click() { 
	            if (selUserId == null || selUserId == "") {
	                alert("<spring:message code='ezCircular.t148' />");
	                return;
	            }
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 450) / 2;
	            var pLeft = (pwidth - 420) / 2;
	            
	            window.open("/ezCommon/showPersonInfo.do?id=" + selUserId + "&dept=" + selDeptId, "", "height=450px,width=420px,  top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	   		
	   		function ok_Click() {
	   			/* opener.selReceiver = JSON.stringify(receiverList);
	   			opener.showReceiver(); */
	   			
	   			/* 내 데이터로 바꿔야 */
	   			if (mode === "menu") {
	   				window.opener.menuAuths = JSON.stringify(menuAuths);
	   			} else if (mode === "theme") {
	   				window.opener.themeAuths = JSON.stringify(menuAuths);
	   			} else {
	   				window.opener.portletAuths = JSON.stringify(menuAuths);
	   			}
	   			
	   			var menuAuthsY = [];
	   			var menuAuthsN = [];
	   			var menuAuthsCount = menuAuths.length;
	   			
	   			menuAuths.forEach(function(item, index) {
	   				if (item.accessYN) {
	   					menuAuthsY.push(item);
	   				} else {
	   					menuAuthsN.push(item);
	   				}
	   			});
	   			
				var menuAuthsYList = "";
				
				menuAuthsY.forEach(function(item, index) {
					if (item.userType == 1) {
						menuAuthsYList += ", " + item.userName;
						menuAuthsYList += "(" + item.userDeptName + ")";
					} else if (item.userType == 0) {
						menuAuthsYList += ", " + item.userDeptName;
					} else {
						menuAuthsYList += ", " + item.userName;
					}
				});
					
				window.opener.$(".accessOK").find("div").text(menuAuthsYList.substring(1));
	   			
				var menuAuthsNList = "";
				
				menuAuthsN.forEach(function(item, index) {
					if (item.userType == 1) {
						menuAuthsNList += ", " + item.userName;
						menuAuthsNList += "(" + item.userDeptName + ")";
					} else if (item.userType == 0) {
						menuAuthsNList += ", " + item.userDeptName;
					} else {
						menuAuthsNList += ", " + item.userName;
					}
				});
					
				window.opener.$(".accessNO").find("div").text(menuAuthsNList.substring(1));

	   			window.close();
	   		}
	   		
	   	 	var mail_select_groupmember_cross_dialogArguments = new Array();
			function groupmember_click() {
				var selectGroup = document.getElementById("pListViewGroup").querySelector(".selectTR");
				
				if (selectGroup == null || selectGroup == undefined) {
					alert("<spring:message code='ezOrgan.zNo003' />");
					return;
				}
				
				var groupID = selectGroup.getAttribute("data1");
				mail_select_groupmember_cross_dialogArguments[0] = DivPopUpHidden;
				var companyId = "<c:out value='${companyId}'/>";
				DivPopUpShow(601, 470, "/admin/ezOrgan/permissionGroupUserListView.do?groupID=" + groupID + "&companyID=" + companyId);
			}
	   		
	   		/** get MenuAuth data */
	   		var getMenuAuths = function() {
	   			if (mode === "menu") {
		   			if (typeof window.opener.menuAuths == "string") {
	   					menuAuths = JSON.parse(window.opener.menuAuths);
		   			} else {
		   				menuAuths = JSON.parse(JSON.stringify(window.opener.menuAuths));
		   			}
	   			} else if (mode === "theme") {
		   			if (typeof window.opener.themeAuths == "string") {
	   					menuAuths = JSON.parse(window.opener.themeAuths);
		   			} else {
	   					menuAuths = JSON.parse(JSON.stringify(window.opener.themeAuths));
		   			}
	   			} else {
					if (typeof window.opener.portletAuths == "string") {
	   					menuAuths = JSON.parse(window.opener.portletAuths);
		   			} else {
	   					menuAuths = JSON.parse(JSON.stringify(window.opener.portletAuths));
		   			}
	   			}
	   			
				drawAuths();
	   		};
	   		
	   		//onload
   			getMenuAuths();
   			
   			treeContent = ${deptList};
	   		setDeptList();
	   		
	   		//eventSet
	   		$("#addAuthBtn").on("click", applyReceiver);
	   		$("#deleteAuthBtn").on("click", deleteAuth);
	   		
		</script>
	</body>
</html>

