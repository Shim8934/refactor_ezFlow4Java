<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t88'/></title>
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
	    </style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezJournal/journal_script.js')}"></script>
	   	<script type="text/javascript">
	   		//트리조직도 JSON
	   		var treeContent;
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
	   		// 즐겨찾기 아이디
	   		var favoriteId = "";
	   		// 즐겨찾기 저장, 수정 flag
	   		var type = "new";
	   		//올른쪽 리스트에서 선택된 유저
	   		var selMainListUserId="";
	   		var selMainListUserName="";
	   		var selDeptId = "";
	   		
	   		var CurPage = "1";
	   		var totalPage = "";
	   		
	   		/* 2019-12-04 홍승비 - 다국어 스타일 적용을 위한 lang 변수 */
	   		var lang = "<c:out value='${lang}'/>";
	   		
	   		/* 2022-08-05 홍승비 - 현재 선택된 즐겨찾기 리스트의 이름을 담는 변수 (즐겨찾기 수정 시 사용) */
	   		var favoriteNameForMod = "";
	   		
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
				/**
					페이징할 때 사용.
					뭔가 다른 방법이 있는지 찾아보기.
				*/	   			
	   			if(key === undefined && value === undefined && deptName === undefined) {
	   				key = "DEPARTMENT";
	   				value = $(".jstree-wholerow-clicked").parent()[0].id;
	   				deptName = $("#"+value+" a:first").text();
	   			}
	   			
	   			var listType = getOrganListType();
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
		        	})
		        	return organListType;
		        }
	   			
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezJournal/userList.do",
	   				data:{"key" : key, "value" : value, "deptName" : deptName, "listType" : listType, "curPage" : CurPage },
	   				success: function(result){
	   					var picList = $(result).find(".organwrap");
	   					if(picList.length == 0 && key != "DEPARTMENT"){
	   						alert("<spring:message code='ezJournal.t207'/>");
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
	   		
	   		//검색
	   		function fn_serach(type) {
	   			var value = $("#keyword").val().trim();
	   			
	   			if (value == '' || value == undefined) {
	   				alert("<spring:message code='ezJournal.t208'/>");	
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
	   				alert("<spring:message code='ezJournal.t208'/>")
	   			}
	   		}
	   		
	   		//오른쪽 리스트에서 클릭이벤트 적용
	   		function setMainListUserAuthorDept(elem) {
	   			if ($(elem).parent().attr("id") === "List_TBODY2") {
	   				$("#List_TBODY2 tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "receiverList"){
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
	   			if ($(elem).parent().attr("id") === "List_TBODY2") {
	   				$("#List_TBODY2 tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "receiverList") {
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
	   		}
	   		
	   		// 선택한 사람을 수신자에 추가
	   		function setAuthorViewUser() {
	   			
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
	   		
	   		// 선택된 수신자 배열을 토대로 화면에 그리는 곳
	   		function drawReceiverList() {
		    	var $receiverList = $("#receiverList");
		    	var strHTML = "";     
		    	for (var i = 0; i < receiverList.length; i++) {
		    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
		    		strHTML += "<tr style='cursor:pointer;' id=" + receiverList[i].userId + " class='hover' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver()'>";
		    		strHTML += "<td>";
		    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
		    		strHTML += receiverList[i].userName;
		    		strHTML += "</td>";
		    		strHTML += "</tr>";
		    		strHTML += "</table>";
		    	}
		    	$receiverList.html(strHTML);
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
	   		
	   		// 즐겨찾기 리스트 가져오기
	   		function getFavoriteList() {
	   			
	   			$.ajax({
	   				type : "post",
	   				dataType : "html",
	   				url : "/ezJournal/getFavoriteList.do",
	   				data : {"userId" : userId },
	   				success : function(result){
	   					$("#List_TBODY").html(result);
	   					favoriteId = $(result).filter("tr").attr("favoriteid");
	   					if (favoriteId != undefined) {
				   			getFavoriteUser($("#List_TBODY tr:first"));
				   			$("#journalFavorite").scrollTop();
	   					}
	   				},
	   				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nerror : " + error);
	   				}
	   			});
	   		}
			
	   		// 즐겨찾기 아이디에 해당하는 수신자리스트 가져오기
	   		function getFavoriteUser(elem) {
	   			$("*").removeClass("selectTR");
	   			$(elem).addClass("selectTR");
	   			if (elem != null && elem != "") {
		   			favoriteId = $(elem).attr("favoriteId");
	   			}
	   			// console.log("userId : " + userId + ", favoriteId : " + favoriteId);
	   			$.ajax({
	   				type : "post",
	   				dataType : "html",
	   				url : "/ezJournal/getFavoriteUser.do",
	   				data : {"userId" : userId,
	   						"favoriteId" : favoriteId},
	   				success : function(result){
	   					$("#List_TBODY2").html(result);
	   				},
	   				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nerror : " + error);
	   				}
	   			});
	   		 	selMainListUserId = "";
				selUserId = "";
	   		}
	   		
	   		// 즐겨찾기 적용하기
	   		function applyFavorite() {
	   			if (favoriteId != undefined) {
		   			$.ajax({
		   				type : "POST",
		   				dataType : "json",
		   				url : "/ezJournal/applyFavoriteUser.do",
		   				data : {"userId" : userId,
	   							"favoriteId" : favoriteId},
	   					success : function(result){
	   						receiverList = result.slice();
	   						drawReceiverList();
		   				},
		   				error : function(request, status, error) {
			    			alert("code : " + request.status + "\nerror : " + error);
		   				}
		   			});
	   			} else {
	   				alert("<spring:message code='ezJournal.t173'/>");
	   			}
	   		}
	   		
	   		// 즐겨찾기 수정
	   		function modifyFavorite() {
	   			if (favoriteId != undefined) {
		   			type = "mod";
		   			
					// 현재 선택된 즐겨찾기의 이름을 변수에 저장
					if ($("tr .selectTR").length > 0) {
						favoriteNameForMod = $("tr .selectTR").children(":eq(1)").text();
					}
					
		   			saveFavoriteLine();
	   			} else {
	   				alert("<spring:message code='ezJournal.t173'/>");
	   			}
	   		}
	   		
	   		// 즐겨찾기 삭제
	   		function deleteFavorite() {
	   			if (favoriteId != undefined) {
		   			var delCheck = confirm("<spring:message code='ezJournal.t139'/>");
		   			
		   			if (delCheck) {
			   			$.ajax({
			   				type : "POST",
			   				url : "/ezJournal/deleteFavorite.do",
			   				data : {"userId" : userId,
		   							"favoriteId" : favoriteId},
		   					success : function(){
		   						alert("<spring:message code='ezJournal.t138'/>");
		   						getFavoriteList();
			   				},
			   				error : function(request, status, error) {
				    			alert("code : " + request.status + "\nerror : " + error);
			   				}
			   			});
		   			}
	   			} else {
	   				alert("<spring:message code='ezJournal.t173'/>");
	   			}
	   		}
	   		
	   		function applyReceiver() {
  				setAuthorViewUser();
	   		}
	   		
	   		$(document).ready(function() {
	   			var openerSelReceiver = "";
	   			treeContent = ${deptList};
	   			$("#1tab1").click();
	            ChangeTab(document.getElementById("1tab1"));
		   		setDeptList();
	   			getFavoriteList();
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
	   			
	   			/* 2019-12-04 홍승비 - 다국어 환경에서 즐겨찾기 버튼 마진 수정 */
	   			/* !important 적용불가 - 태그에 margin-left : auto !important 로 수정 => auto로 한,영,일 언어 전부 적용 가능
				if (lang == "2") {
	   				document.getElementById("addFavoriteLineA").style.marginLeft = "53px";
	   			} else if (lang == "3") {
	   				document.getElementById("addFavoriteLineA").style.marginLeft = "57px";
	   			}
				*/
   			});
	   		
	   		var Tab1_SelectID = "1tab1";
		    function ChangeTab(obj) {
		    	var pSelectTab = GetAttribute(obj, "tdname");

		        switch (pSelectTab) {
		            case "journalOrgan":
		                if (document.getElementById("journalOrgan_content").style.display == "none") {
		                    document.getElementById("journalOrgan_content").style.display = "";
		                    document.getElementById("journalFavorite_content").style.display = "none";
		                   	$("#List_TBODY tr").css("backgroundColor", "#ffffff"); // 탭 바꾸면 즐겨찾기에 선택되어있던 것 해제
		                    $("#dblarrow").css("display", "none");
		                }
		                break;
		            case "journalFavorite":
		                if (document.getElementById("journalFavorite_content").style.display == "none") {
		                    document.getElementById("journalOrgan_content").style.display = "none";
		                    document.getElementById("journalFavorite_content").style.display = "";
		                    $("#dblarrow").css("display", "");
		                    getFavoriteList();
		                    $("#journalFavorite").scrollTop(0);
		                }
		                break;
		    	}
		        selMainListUserId = "";
				selUserId = "";
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
	   		
	   		function infoview_click() { 
	            if (selUserId == null || selUserId == "") {
	                alert("<spring:message code='ezJournal.t209' />");
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
	   		
	   	  /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != Tab1_SelectID) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
		</script>
		<style>
			tr.hover:not(.selectTR):hover{background:#eee; color:#fff;}
			
			.selectTR{
				background-color: rgb(237, 244, 253);
			}
			#List_TBODY2 tr{
				cursor: pointer;
			}
			#List_TBODY tr{
				cursor: pointer;
			}
		</style>
	</head>
	<body class="popup" style="overflow: hidden;"> 
        <h1 style="height: 20px;"><spring:message code='ezJournal.t88'/></h1>
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
			                <div class="portlet_tabpart01" style="width:680px;">
			                	<div class="portlet_tabpart01_top" id="tab1" style="margin-top:25px;margin-bottom: 2px;">
					            	<p><span id="1tab1" tdname="journalOrgan" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezJournal.t89' /></span></p>
									<p><span id="1tab2" tdname="journalFavorite" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezJournal.t90' /></span></p>
					        	</div>
					        </div>
				        	<td id="journalOrgan_content" style="display: none;">
				        		<div class="portlet_tabpart03" style="background-color: #f8f8fa; margin-top: 1px; padding:0px; border-top: none;">
				                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #eaeaea;">
				                        <table style="margin-top: 3px; width: 100%;">
				                            <tr>
				                                <td>
				                                    <div style="float: left; margin-left: 5px;">
				                                        <select id="search_type" style="height:22px">
				                                            <option selected value="displayname"><spring:message code='ezJournal.t38'/></option>
								                            <option value="cn"><spring:message code='ezJournal.t210'/></option>
								                            <option value="description"><spring:message code='ezJournal.t40'/></option>
								                            <option value="title"><spring:message code='ezJournal.t39'/></option>
								                            <option value="telephonenumber"><spring:message code='ezJournal.t46'/></option>
								                            <option value="mobile"><spring:message code='ezJournal.t211'/></option>
								                            <option value="HomePhone"><spring:message code='ezJournal.t212'/></option>
								                            <option value="facsimileTelephoneNumber"><spring:message code='ezJournal.t213'/></option>
								                            <c:if test="${primaryLang eq '3' }">
		                                                    <option value="extensionPhone" usedefault="0"><spring:message code='main.ksa02' /></option>
		                                                    <option value="officeMobile" usedefault="0"><spring:message code='main.ksa03' /></option>
		                                                    </c:if>
								                            <option value="mail"><spring:message code='ezJournal.t214'/></option>
								                            <option value="streetAddress" style="display:none"><spring:message code='ezJournal.t215'/></option>
				                                        </select>
				                                        <input id="keyword" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){fn_serach('search'); return false;}" value="" style="width: 130px; margin: 0px;height:22px" />
				                                        <a class="imgbtn"><span onclick="fn_serach('search')"><spring:message code='ezJournal.t43'/></span></a>
				                                    </div>
				                                </td>
				                                <td>
				                                    <div style="float: right; margin-right: 5px; position: relative;">
				                                    	<a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezJournal.t216' /></span></a>  
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
		                  	<td id="journalFavorite_content" style="display:none; width:680px;">
	                        	<table style="width:100%">
	                                <tr>
	                                    <td style="background-color: #f3f3f3; padding: 0px 0 3px 0; background-color: #ffffff; height: 20px;">
                                        	<h2 class="h2_dot" style="display: inline-block;"><spring:message code='ezJournal.t95'/></h2>
		                                    <div style="float:right; margin-top: -5px;">
		                                        <a class="imgbtn imgbck"><span onclick="applyFavorite()"><spring:message code='ezJournal.t135'/></span></a>
		                                        <a class="imgbtn imgbck"><span onclick="modifyFavorite()"><spring:message code='ezJournal.t96'/></span></a>
		                                        <a class="imgbtn imgbck"><span onclick="deleteFavorite()"><spring:message code='ezJournal.t97'/></span></a>
		                                    </div>
	                                        <div class="border_gray">
	                                            <div id="journalFavorite" style="Width: 100%; Height: 176px; OVERFLOW: AUTO; padding-top: 0px;">
	                                            	<table class="mainlist" id="favoriteList" style="width: 100%;">
								                        <thead id="List_THEAD">
									                        <tr>
									                        	<th style="width: 10%;"><span><spring:message code='ezJournal.t101' /></span></th>
									                            <th style="width: 50%; "><span><spring:message code='ezJournal.t98' /></span></th>
									                            <th style="width: 40%; "><span><spring:message code='ezJournal.t99' /></span></th>
									                        </tr>
								                        </thead>
								                        <tbody id="List_TBODY">					                        
								                        </tbody>
								                    </table>
	                                            </div>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="vertical-align: top;">
	                                        <div class="border_gray">
	                                            <div id="journalFavList" style="Width: 100%; Height: 297px; OVERFLOW: AUTO; padding-top: 0px;">
	                                            	<table id="List" class="mainlist" style="width:100%">
														<thead id="List_THEAD2">
															<tr>
																<th id="TH_0" style="width:5%"><spring:message code='ezJournal.t101' /></th>
																<th id="TH_1" style="width:20%"><spring:message code='ezJournal.t38' /></th>
																<th id="TH_2" style="width:17%"><spring:message code='ezJournal.t39' /></th>
																<th id="TH_3" style="width:20%"><spring:message code='ezJournal.t40' /></th>
																<th id="TH_4" style="width:38%"><spring:message code='ezJournal.t100' /></th>
															</tr>
														</thead>
														<tbody id="List_TBODY2">
														</tbody>
													</table>
	                                            </div>
                                            </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                        <td style="width: 30px; text-align: center;">                            
	                            <img src="/images/arr_rright.gif" id="dblarrow" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; display: none;" onclick="applyFavorite()"><br>
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver()"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver()">
	                        </td>
	                        <td style="vertical-align: top;">
	                        	<div style="display: inline-flex; display: -ms-inline-flexbox; width: 252px; position: absolute;top: 56px;">
		                            <h2 class="receiver_tltype01" style="border-bottom:none;">
										<span style="min-width: 45px;" id="PermissionStr"><spring:message code='ezJournal.t80'/> </span>
									</h2>
								 	<a id="addFavoriteLineA" class="imgbtn imgbck" style="margin-top: 4px !important; margin-left: auto !important;">
								 		<span onclick="addFavoriteLine()"><spring:message code='ezJournal.t92'/></span>
								 	</a>
								</div>
								<div class="receiver_borderbox" style="border-top: 1px solid #ddd;">
									<div id="receiverList" style="width: 250px; Height: 516px; overflow-x: auto; overflow-y: auto;">
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
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>

