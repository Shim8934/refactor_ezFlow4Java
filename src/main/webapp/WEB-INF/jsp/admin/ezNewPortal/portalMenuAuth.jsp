<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>메뉴 권한설정</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezJournal.c1', 'msg')}" type="text/css" />
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
	    </style>
	</head>
	<body class="popup" style="overflow: hidden;"> 
        <h1>메뉴권한설정</h1>
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
				        		<div style="display: inline-flex; display: -ms-inline-flexbox; border-bottom: 1px solid #565b66; width: 680px;">
		                            <h2 class="receiver_tltype01" style='margin-top:4px; border-bottom:none;'>
										<span style="min-width: 45px;" id="PermissionStr">조직도</span>
									</h2>
								</div>
				        		<div class="portlet_tabpart03" style="background-color: #f8f8fa; margin-top: 2px; padding:0px; border-top: none;">
				                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #eaeaea;">
				                        <table style="margin-top: 5px; width: 100%;">
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
								                            <option value="streetAddress"><spring:message code='ezOrgan.t100'/></option>
				                                        </select>
				                                        <input id="keyword" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){fn_serach('search'); return false;}" value="" style="width: 130px; margin: 0px;height:22px" />
				                                        <a class="imgbtn"><span onclick="fn_serach('search')"><spring:message code='ezOrgan.t101'/></span></a>
				                                    </div>
				                                </td>
				                                <td>
				                                    <div style="float: right; margin-right: 5px; position: relative;">
				                                    	<a href="#" class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezCircular.t161' /></span></a>  
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
		                  	</td>   
	                        <td style="width: 30px; text-align: center;">                            
	                            <img src="/images/arr_rright.gif" id="dblarrow" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; display: none;" onclick="applyFavorite()"><br>
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver()"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver()">
	                        </td>
	                        <td style='vertical-align: top'>
	                        	<div style="display: inline-flex; display: -ms-inline-flexbox; border-bottom: 1px solid #565b66; width: 252px;">
		                            <h2 class="receiver_tltype01" style='margin-top:4px; border-bottom:none;'>
										<span style="min-width: 45px;" id="PermissionStr">권한목록 </span>
									</h2>
								</div>
								<div class="receiver_borderbox" style="border-top: 1px solid #ddd; margin-top: 2px;">
									<div id="receiverList" style="width: 250px; Height: 511px; overflow-x: auto; overflow-y: auto;">
									</div>
								</div>
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
			<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
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
	   		// 선택된 수신자 배열
	   		var receiverList = [];
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
	   		//올른쪽 리스트에서 선택된 유저
	   		var selMainListUserId="";
	   		var selMainListUserName="";
	   		var selDeptId = "";
	   		
	   		var CurPage = "1";
	   		var totalPage = "";
	   		
	   		document.onselectstart = function () { return false; };
	   		function close_Click(){
	   			window.close();
	   		}
	   		/**
	   			2018-07-10 페이징 기능 추가
	   		*/
	   		var BlockSize = 10;
	    	function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
	    	}
	    	function makePageSelPage() {
		        var strtext;
	        	var PagingHTML = "";
	        	document.getElementById("tblPageRayer").innerHTML = "";
	        	strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
	        	var pageNum = CurPage;
	        	if (totalPage > 1 && pageNum != 1) {
	            	strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' ></span>";
	            	PagingHTML += strtext;
	        	} else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' ></span>";
	            	PagingHTML += strtext;
	        	}
	        	if (totalPage > BlockSize) {	
		            if (pageNum > BlockSize) {
	                	strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' ></span>";
		                PagingHTML += strtext;
		            } else {
	                	strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
	                	PagingHTML += strtext;
	            	}
	        	} else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
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
	                	strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' ></span>";
	                	PagingHTML += strtext;
	            	} else {
	                	strtext = "";
	                	strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
	                	PagingHTML += strtext;
	            	}
	        	} else {
	            	strtext = "";
	            	strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
	            	PagingHTML += strtext;
	        	}
	        	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	            	strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' ></span>";
	            	PagingHTML += strtext;
	        	} else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' ></span>";
	            	PagingHTML += strtext;
	        	}
	        	PagingHTML += "</div>";
	        	td_Create1(PagingHTML);
	    	}
	    	function goToPageByNum(Value) {
	        	CurPage = Value;
	        	makePageSelPage();
	        	movePage(CurPage);
	    	}
	    	function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
	        	pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	        	goToPageByNum(pageNum);
	    	}
	    	function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
	        	if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
	        	else
		            return;
	    	}
	    	function selafterBlock() {
		        var pageNum = parseInt(CurPage);
	        	pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	        	goToPageByNum(pageNum);
	    	}
	    	function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
	        	if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
	    	        return;
	    	}
	    	function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	            	CurPage = newPage;
	            	if(issearch) {
		                search_click();
	            	} else {
		                setUserList();
	            	}
	        	}
	    	}
	    	function prevPage_onclick() {
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
	    	function nextPage_onclick() {
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
	   		
	   		//조직도 뿌리는 펑션
	   		function setDeptList(){
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
					selMainListUserId = "";
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
	   		function setUserList(key, value, deptName){
	   			if(key === undefined && value === undefined && deptName === undefined) {
	   				key = "DEPARTMENT";
	   				value = $(".jstree-wholerow-clicked").parent()[0].id;
	   				deptName = $("#"+value+" a:first").text();
	   			}
	   			
	   			var listType = getOrganListType();
	   			
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezJournal/userList.do",
	   				data:{"key" : key, "value" : value, "deptName" : deptName, "listType" : listType, "curPage" : CurPage },
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
	   			if ($(elem).parent().parent().parent().attr("id") === "receiverList"){
		   			$("#receiverList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			}
	   			$(elem).addClass("selectTR");
	   			selMainListUserId = $(elem).attr("id");
	   			selMainListUserName = $(elem).attr("name");
	   			// console.log("selMainListUserId : " + selMainListUserId)
	   		}
	   		
	   		// 리스트에서 클릭이벤트 적용
	   		function setUserAuthorDept(elem) {
	   			if ($(elem).parent().parent().parent().attr("id") === "receiverList") {
		   			$("#receiverList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
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
	   		
	   		// 선택한 사람을 수신자에 추가
	   		function setAuthorViewUser() {
alert(menuAuths);
	   			if (selUserId != "" && selUserId != undefined) {
		   			var receiverId = selUserId;
		   			var chkFlag = true;
		   			userName = selUserName;
	   				
		   			if (userId == receiverId) {
		   				chkFlag = false;
		   			}
		   			
		   			for(var i = 0; i < receiverList.length; i++) {
		   				if (receiverList[i].userId == receiverId) {
		   					chkFlag = false;
		   				}
		   			}
		   			
		   			if (chkFlag) {
						receiverList.push({"userName" : userName, "userId" : receiverId});
		   			} else {
		   				if (userId == receiverId) {
			   				alert("<spring:message code='ezJournal.t140'/>");
		   				} else {
			   				alert("<spring:message code='ezJournal.t127'/>");
		   				}
		   			}
		   			drawReceiverList();
		   			selMainListUserId = "";
	   			} else {
	   				alert("<spring:message code='ezJournal.t136'/>");
	   			}
	   		}
	   		
	   		// 선택된 수신자배열에서 특정 사원 삭제
		    function deleteReceiver() {
		     	for(var j = 0; j < receiverList.length; j++) {
		     		
		    		if (receiverList[j].userId === selMainListUserId) {
		    			receiverList.splice(j, 1);
		    			selMainListUserId = "";
		    		}
		    	} 
		     	drawReceiverList();
		    }
	   		
	   		//TODO 메뉴타입 추가된 table로  수정해서 그려라 
	   		function drawReceiverList() {
	   			
	   			authsHTML = "";
	   			
	   			if (menuAuths != null && menuAuths.length != 0) {
					menuAuthsN.forEach(function(item, index) {
						authsHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
						
						authsHTML += "<tr style='cursor:pointer;' class='hover'";
						authsHTML += " data-id=" + item.userId;
						authsHTML += " data-userName=" + item.userName;
						authsHTML += " data-userDeptName=" + item.userDeptName;
						authsHTML += " data-userType=" + item.userType;
						authsHTML += " data-accessYN=" + item.accessYN;
						authsHTML += " onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver()'>";
						authsHTML += "<td>";
						
						if (item.userType) {
							authHTML += item.userName;
							authHTML += "(" + item.userDeptName + ")";
						} else {
							authHTML += item.userDeptName;
						}
						
						authsHTML += "</td>";
						
						authsHTML += "<td>";
						
						if (item.accessYN === true) {
							authsHTML += "접근";
						} else {
							authsHTML += "거부";
						}
						
						authHTML += "</td>";
					});
				}
	   			
	   			document.getElementById("receiverList").innerHTML = authHTML;
		    }
	   		
	   		function addFavoriteLine() {
   				type = "new";
   				saveFavoriteLine();
	   		}
	   		
	   		// 선택된 수신자리스트 즐겨찾기 저장
	   		function saveFavoriteLine() {
	   			if (receiverList.length > 0) {
		   		 	DivPopUpShow(360, 185, "/ezJournal/receiverLineName.do");
	   			} else {
	   				alert("<spring:message code='ezJournal.t136'/>");
	   			}
	   		}
	   		
	   		function applyReceiver() {
  				setAuthorViewUser();
	   		}
	   		
	   		$(document).ready(function() {
	   			getMenuAuths();
	   			
	   			var openerSelReceiver = "";
	   			treeContent = ${deptList};
		   		setDeptList();
		   		
	   			if ($(opener.selReceiver).length > 0) {
	   				//2018-07-10 배현상, opener.selReceiver를 receiverList에 바로 담아서 수정,삭제한 후 취소를 해도 바로 적용되는 오류 문제로 인한 로직 수정 
	   				openerSelReceiver = opener.selReceiver;
	   				for (i = 0; i < openerSelReceiver.length; i++) {
	   					receiverList.push({"userName" : openerSelReceiver[i].userName, "userId" : openerSelReceiver[i].userId});
	   				}
	   				drawReceiverList();
	   			}
		   		
	   			$(function () {
		   			$(document).on({
		   				"dblclick":function(){delTargetDept(this);},
		   				"click":function(){targetDept = this;
			   				$("*").removeClass("selectTR");
				   			$(this).addClass("selectTR");
		   				}
	   				},"#lplistView tr");
	   			});
   			});
	   		
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
	   			opener.selReceiver = JSON.stringify(receiverList);
	   			opener.showReceiver();
	   			window.close();
	   		}
	   		
	   		/** get MenuAuth data */
	   		var getMenuAuths = function() {
	   			var menuId = "${menuId}";
				var companyValue = "${companyId}";
				
				var request = new XMLHttpRequest();
				request.open('POST', '/admin/ezNewPortal/getMenuAuths.do', true);
				request.setRequestHeader('content-type', 'application/json');
				
				request.onload = function(result) {
					if (request.status >= 200 && request.status < 400) {
						var result = JSON.parse(request.responseText);
						var menuAuthsY = result.menuAuths.menuAuthsY;
						var menuAuthsN = result.menuAuths.menuAuthsN;
						
						menuAuths = new Array();
						
						Array.prototype.push.apply(menuAuths, menuAuthsY);
						Array.prototype.push.apply(menuAuths, menuAuthsN);
						
						drawReceiverList();
					}
				}
				
				request.onerror = function() {}
				
				var data = JSON.stringify({
					menuId : menuId,
					companyId : companyValue,
				});
				 
				request.send(data);
	   		};
	   		
		</script>
	</body>
</html>

