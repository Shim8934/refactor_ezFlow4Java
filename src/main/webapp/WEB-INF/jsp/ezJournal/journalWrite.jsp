<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
		<c:choose>
			<c:when test="${mode == 'new' || mode == 'reuse' || mode == 'temp' || mode == 'sum'}">
			    <title><spring:message code='ezJournal.t131' /></title>
			</c:when>
			<c:otherwise>
			    <title><spring:message code='ezJournal.t132' /></title>
			</c:otherwise>
		</c:choose>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/ezJournal/journal_css.css')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezJournal/journal_script.js')}"></script>
	    <style type="text/css">
	    	#loading {
				 width: 100%;  
				 height: 100%;  
				 top: 0px;
				 left: 0px;
				 position: fixed;  
				 display: block;  
				 opacity: 0.7;  
				 background-color: #fff;  
				 z-index: 99;  
				 text-align: center; 
			 } 
			  
			#loading-image {  
				 position: absolute;  
				 top: 50%;  
				 left: 50%; 
				 z-index: 100; 
			 }
	    </style>
	    <script type="text/javascript">
		//	var companyId = "${info.companyID}"; 
			var userId = "<c:out value='${userId}'/>";
			//트리조직도 JSON
	   		var treeContent;
	    	// 수신자
	    	var selReceiver = [];
	    	// 마지막에 사용했던 양식아이디
	    	var lastFormId = "";
	    	// 일지함아이디
	    	var typeId = "<c:out value='${typeId}'/>";
	    	// 부서아이디
	    	var deptId = "<c:out value='${info.deptID}'/>";
	    	// 첨부파일 최대용량
	    	var AttachLimit = 5;
	    	var mode = "<c:out value='${mode}'/>";
	    	var oldJournalId = "<c:out value='${journalId}'/>";
	    	var selFormId = "";
	    	var selTypeId = "";
	    	// 수정, 임시저장, 재사용시 가져오는 수신자리스트
	    	var receiverId = "";
	    	var receiverName = "";
	    	// 취합할 양식 아이디들
	    	var journalIdList = [];
	    	// 취합일지여부
	    	var isSum = "N";
	    	
	    	
    		window.onload = function () {
				
	    		selTypeId = $("#optType").find("option:selected").val();
	    		
	    		// 수정, 임시, 재사용 모드에서는 수신자 정보와 파일정보를 가져와 화면에 적용
	    		if (mode == "modify" || mode == "reuse" || mode == "temp") {
	    			$("#title").val("${journal.journalTitle}");
	    			var receiverID = "${receiverIds}";
	    			var receiverName = "${receiverNames}";
	    			
	    			if ((receiverID != null && receiverID != "") && (receiverName != null && receiverName != "")) {
	    				receiverID = receiverID.slice(0, -2).split(", ");
	    				receiverName = receiverName.slice(0, -2).split(", ");
		    			for (var i = 0; i < receiverID.length; i++) {
		    				selReceiver.push({"userName" : receiverName[i], "userId" : receiverID[i]});
		    			}
		    			showReceiver();
	    			}
	    			
	    			var fileList = '${fileList}';
	    			if (fileList != null && fileList != "") {
	    			//	fileList = fileList.replace(/&nbsp;/gi, " ");
	    				fileList = decodeURIComponent(fileList);
		    			dadiframe.setAttachFileInfo(fileList);
	    			}
	    			
    	    		var checkSum = "<c:out value='${journal.isSum}'/>";
    	    		if (checkSum != null && checkSum != "") {
    	    			isSum = checkSum;
    	    		}
	    		} else if (mode == "sum") {
    	    		isSum = "Y"
	    		}
	    	
// 	    	 	if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
//                     self.resizeTo(760, 800);
//                 } else {
//                     self.resizeTo(785, 830);
//                 } 
	    		
// 	    		// IE10에서 에디터사이즈 조절
// 	    		if (new RegExp(/MSIE 10/).test(navigator.userAgent)) {
// 		    		document.getElementById("EdtorSize").style.height = document.body.clientHeight - 310 + "PX";
// 		    	}
	    	}; 
	    
	    	// 양식내용을 에디터에 넣어주는 작업 
		    function Editor_Complete() {
				getFormList($("#optType"));
	    		
	    		switch (mode) {
				case 'new':
		    		getLastForm(typeId);
				
		    		if (lastFormId != null && lastFormId != "" ) {
		    			selFormId = lastFormId;
		    			getJournalForm(lastFormId);
		    			$("#optForm option[value=" + lastFormId + "]").attr("selected", "selected");
		    			lastFormId = "";
		    		} else {
		    			selFormId = $("#optForm").find("option:selected").val();
			    		getJournalForm(selFormId);
		    		}
					break;
					
				case 'sum':
					selFormId = opener.sumFormId;
				//	selFormId = "${sumFormId}";
					journalIdList = opener.journalIdList;
					var selectedType = $("#optType");
				
// 					getFormList(selectedType).setTimeout(function(){
// 						$('#loading').hide()
// 					},0);
					
				//	getFormList(selectedType);
					
					$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
					
					getSumJournal(selFormId);
// 		    		opener.sumFormId = "";
					break;
					
				case 'reuse': case 'modify': case 'temp':
					selFormId = "${journal.formId}";
					$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
					var content = '${content}';
					content = content.replace(/&#39;/gi, "\'");
	    			message.SetEditorContent(content);
	    			
	    			if (mode == 'modify') {
	    				$("#optType").attr("disabled", "true");
						$("#optForm").attr("disabled", "true");
	    			}
	    			
					break;

				default:
					break;
				}
	    	}
	    	
			// 선택된 일지함의 양식 리스트 가져오기
	    	function getFormList(elem) {
	    		typeId = $(elem).val();
	    		$.ajax({
	    			type : "POST",
	    			dataType : "json",
	    			async : false,
	    			url : "/ezJournal/getFormList.do",
	    			data : {"typeId" : typeId,
	    					"deptId" : deptId},
	    			success : function(result) {
	    				var str = "";
	    				$(result).each(function() {
	    					str += "<option value=" + this.formId + ">" + this.formName + "</option>";
	    				});
	    				$("#optForm").html(str);
	    			}
	    		});
	    	}
			
	    	function changeType(elem) {
	    		if (mode == "temp" || mode == "reuse" || mode == "sum") {
					if (!confirm("<spring:message code='ezJournal.t159'/>")) {
					//	$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
						$(elem).val(selTypeId);
						return;
					}
				}
	    		
 	    		getFormList(elem);
// 	    		getJournalForm(lastFormId);
	    		var changeTypeId = $(elem).val();
	    		selTypeId = changeTypeId;
				
	    		if (lastFormId != null && lastFormId != "" ) {
	    			lastFormId = parseInt(lastFormId);
	    			selFormId = lastFormId;
	    			getJournalForm(lastFormId);
	    			$("#optForm option[value=" + lastFormId + "]").attr("selected", "selected");
	    			lastFormId = "";
	    		} else {
	    			selFormId = $("#optForm").find("option:selected").val();
		    		getJournalForm(selFormId);
	    		}
	    	}
			
	    	// 양식변경시
	    	function changeForm(elem) {
	    		if (mode == "temp" || mode == "reuse" || mode == "sum") {
					if (!confirm("<spring:message code='ezJournal.t159'/>")) {
				//		$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
						$(elem).val(selFormId);
						return;
					}
				}
	    		
	    		getJournalForm($(elem).val());
	    	}
	    	
			// 선택된 양식의 폼 호출
			function getJournalForm(formId) {
// 				var jsonString = JSON.stringify({"mode" : mode,"formId" : formId,"typeId" : typeId,"journalIdList" : journalIdList});
				
				selFormId = formId;
				
				$.ajax({
	    			type : "POST",
	   				dataType : "json",
	   				async:false,
	   				url : "/ezJournal/journalGetForm.do",
	   				data : {
	   					mode : mode, formId : formId, typeId : typeId,
						journalIdList : JSON.stringify(journalIdList)
					},
   					success : function(result){
   						if (result.formStatus == null) {
   							$("#btnGetOther").css("display", "none");
   						} else {
   							$("#btnGetOther").css("display", "");
   						}
   						
   						$("#title").val(result.journalTitle);
   						message.SetEditorContent(result.journalContent);
   					//	opener.journalIdList = [];
//    					opener.journalIdList.length = 0;
   						if(mode == "sum"){
   			    			setTimeout(function() {
   								$('#loading').hide();
   							}, 0);
   			    		}
	   				},
	   				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nerror : " + error);
	   				}
	    		});
			}
			
			// 취합한 일지 가져오기
			function getSumJournal(formId) {
				
				selFormId = formId;
				
				$.ajax({
	    			type : "POST",
	   				dataType : "json",
	   			//	async:false,
	   				url : "/ezJournal/journalGetForm.do",
	   				data : {
	   					mode : mode, formId : formId, typeId : typeId,
						journalIdList : JSON.stringify(journalIdList)
					},
					beforeSend : function() {
						$("#loading-image").remove();
						$("#loading").html('<img id="loading-image" src="/images/ProgressBar.gif" alt="Loading...">');
					},
   					success : function(result){
   						if (result.formInfo == "fail") {
   							alert("<spring:message code='ezJournal.t177'/>");
   							window.close();
   						}
   						$("#title").val(result.journalTitle);
   						message.SetEditorContent(result.journalContent);
   						if(mode == "sum"){
   			    			setTimeout(function() {
   								$('#loading').hide();
   							}, 0);
   			    		}
	   				},
	   				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nerror : " + error);
	   				}
	    		});
			}
	    	
			// 최근에 사용한 양식 호출
			function getLastForm(typeId) {
				$.ajax({
	    			type : "POST",
	   				dataType : "text",
	   				url : "/ezJournal/journalGetLastForm.do",
	   				data : {"typeId" : typeId},
	   				async : false,
   					success : function(result){
						lastFormId = result;
			//			var firstType = $("#optType").find("option:selected");
			//    		getFormList(firstType);
	   				},
	   				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nmessage : " + request.responseText + "\nerror : " + error);
	   				}
	    		});
			}
			
			// 수신자 선택화면 호출
	    	function selectReceiver(){			
				var url = "/ezJournal/selectReceiver.do";
			//	url += "?companyId=" + companyId;
				var OpenWin = window.open(url, "", GetOpenWindowfeature(980, 650));
	    		try { OpenWin.focus(); } catch (e) { }
			//	GetOpenWindow(url, "selectReceiver", 980, 650);
			}
	    	
			// 선택된 수신자 화면에 뿌리기
	    	function showReceiver() {
				if (typeof selReceiver == "string") {
					selReceiver = JSON.parse(selReceiver);
				}
    			var strReceiver = "";
    			var strReceiverID = "";
    			var total = $(selReceiver).length;
	    		$.each(selReceiver, function(index, item) {
					if (index == total - 1) {
						strReceiver += '<span style="cursor:pointer;" onclick=OpenUserInfo("'+item.userId+'");>'+item.userName+'</span>';
						strReceiverID += item.userId;
					} else {
						strReceiver += '<span style="cursor:pointer;" onclick=OpenUserInfo("'+item.userId+'");>'+item.userName+', </span>';
						strReceiverID += item.userId + ", ";
					}
	    		});
	    		$("#receiverlist").html(strReceiver);
	    		$("#receiverID").html(strReceiverID);
	    	}
			
	    	 //수신자 정보창
		    function OpenUserInfo(pUserID) {
		        GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID, "UserInfo", 420, 450, "NO");
		    }
	    
		 	// 버튼 중복클릭 방지
		    var doubleSubmitFlag = false;
		    function doubleSubmitCheck() {
		    	if (doubleSubmitFlag) {
		    		return doubleSubmitFlag;
		    	} else {
		    		doubleSubmitFlag = true;
		    		return false;
		    	}
		    }
	    
	    	// 저장
		    function btn_Save(mode) {
	        	if (doubleSubmitCheck()){
	        		return;
	        	}
	    		//일지작성 눌렀을 시
	        	var content = message.GetEditorContent();
	
				if ($("#title").val() == "") {
					alert("<spring:message code='ezJournal.t217'/>");
					doubleSubmitFlag = false;
					
					return;
				}
	
				if ($.trim($("#title").val()) == "") {
		        	alert("<spring:message code='ezJournal.t218' />");
		        	doubleSubmitFlag = false;
	
		        	return;
		        }
	
				// 부서공유여부
				var isPublic = $("input[type=radio][name=isPublic]:checked").val();
				
				//파일 첨부된 목록 가져오기
				var listtable = dadiframe.document.getElementById("filelist");
				var filelist = GetChildNodes(listtable);
				var fileList = "";
	
				for (var i = 0; i < filelist.length - 1; i++) {	    
					if (i == 0) {
						fileList = GetAttribute(filelist[i + 1], "fileinfo");
					} else {
						fileList += "/" + GetAttribute(filelist[i + 1], "fileinfo");
	        		}
				}
				console.log("fileList : " + fileList);
				
				// 수신자 있는 경우 수신자 가져오기
				var receiverList = $("#receiverlist").html();
				var receiverID = $("#receiverID").html();
	
	    		$.ajax ({
	 			   	url : '/ezJournal/saveJournal.do',
	 			   	type : 'POST',
	 			    async : false,
	                dataType : 'text',
	                data : {	title : $("#title").val(),
	                			typeId : typeId,
	                			formId : selFormId,
	                			isPublic : isPublic,
	                			receiverList : receiverList,
	                			receiverID : receiverID,
	                			content : content,
	                			fileList : fileList,
	                			oldJournalId : oldJournalId,
	                			isSum : isSum,
	                			mode : mode
	                },  
	                cache: false,
	                success: function(result) {	   
	                	if (result != null && result != "") {
		                  	alert("<spring:message code='ezJournal.t137'/>");
		                  
		                	try {
								opener.setJournalList();
							} catch(e) { }
							
							if (receiverID != null && receiverID != "") {
		          			 	sendJournalRecvMail($("#title").val(), receiverID, result);
							}
	          			 	
	          			 	setTimeout(function(){
		          			  	window.close();
   							},100);
	                	}
          			  	
	                },
	                error : function() {
	                	alert("<spring:message code='ezJournal.t149'/>");
          			  	window.close();
          			  	
	                }
	 			});
	    	}
	    	
	    	//수신자에게 메일 보내기
	    	function sendJournalRecvMail(journalTitle,recvIds,journalId){
	    		$.ajax({
					type : "post",
// 					async : false,
					data : {
						"journalTitle" : journalTitle,
						"recvIds" : recvIds,
						"journalId" : journalId
					},
					url : "/ezJournal/sendJournalRecvMail.do",
					success: function(){
					}
				});
	    	}
	    	
	    	// 임시 저장
		    function btn_TempSave(mode) {
	        	if (doubleSubmitCheck()){
	        		return;
	        	}
	
				if ($("#title").val() == "") {
					alert("<spring:message code='ezJournal.t217'/>");
					doubleSubmitFlag = false;
					
					return;
				}
	
				if ($.trim($("#title").val()) == "") {
		        	alert("<spring:message code='ezJournal.t218' />");
		        	doubleSubmitFlag = false;
	
		        	return;
		        }
				
	        	var content = message.GetEditorContent();
	    		
				// 부서공유여부
				var isPublic = $("input[type=radio][name=isPublic]:checked").val();
				var journalId = 0;
				
				if (oldJournalId != "") {
					journalId = oldJournalId;
				}
				
				//파일 첨부된 목록 가져오기
				var listtable = dadiframe.document.getElementById("filelist");
				var filelist = GetChildNodes(listtable);
				var fileList = "";
	
				for (var i = 0; i < filelist.length - 1; i++) {	    
					if (i == 0) {
						fileList = GetAttribute(filelist[i + 1], "fileinfo");
					} else {
						fileList += "/" + GetAttribute(filelist[i + 1], "fileinfo");
	        		}
				}
				
				// 수신자 있는 경우 수신자 가져오기
				var receiverList = $("#receiverlist").html();
				var receiverID = $("#receiverID").html();
	
	    		$.ajax ({
	 			   	url : '/ezJournal/saveTempJournal.do?mode=' + mode,
	 			   	type : 'POST',
	                dataType : 'text',
	                data : {	title : $("#title").val(),
	                			typeId : typeId,
	                			formId : selFormId,
	                			isPublic : isPublic,
	                			receiverList : receiverList,
	                			receiverID : receiverID,
	                			content : content,
	                			fileList : fileList,
	                			oldJournalId : journalId,
	                			isSum : isSum
	                },  
	                cache: false,
	                success: function(result) {
	                	if (result === "ok") {
			            	alert("<spring:message code='ezJournal.t137'/>");
			            	
			            	try {
								opener.setJournalList();
							} catch(e) { }
		          			window.close();
	                	}
	                },
	                error : function() {
	                	alert("<spring:message code='ezJournal.t149'/>");
	                }
	 			});
	    	}
	    	
	    
	    	// 닫기 버튼 클릭시
		    function btn_Close() {
				//파일 첨부된 목록 가져오기
				var listtable = dadiframe.document.getElementById("filelist");
				var filelist = GetChildNodes(listtable);
				var fileList = "";
	
				for (var i = 0; i < filelist.length - 1; i++) {	    
					if (i == 0) {
						fileList = GetAttribute(filelist[i + 1], "fileinfo");
					} else {
						fileList += "/" + GetAttribute(filelist[i + 1], "fileinfo");
	        		}
				}
				
				if (fileList != null && fileList != "") {
 
					$.ajax({
						async : false,
						url : '/ezJournal/tempUploadFileDelete.do',
		                type : 'POST',
		                dataType : 'text',
		                data : {
		                	fileList : fileList
		                },
		                success: function() {
		                	try {
								opener.setJournalList();
							} catch(e) { }
							window.close();
		                },
		                error: function() {
		                	alert("<spring:message code='ezJournal.t149'/>");	
		                }
					});
				} else {
					try {
						opener.setJournalList();
					} catch(e) { }
					window.close();
				}
			}
			
			function mobileDistinction() {
				var  userAgent = navigator.userAgent.toLowerCase();
				
				if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
					if (window.innerWidth > window.innerHeight) {
						document.getElementById("EdtorSize").style.height = 436 + "PX";
						document.getElementById("Iframe1").style.height = 436 + "PX";
					} else {
						document.getElementById("EdtorSize").style.height = "100%";
						document.getElementById("Iframe1").style.height = "98%";
					}
				}
			}
		
			window.addEventListener('resize', function() {
				mobileDistinction();
			});
	
			mobileDistinction();
	    </script>
	</head>
	<body class="popup" style="height: 99%;" ondragover="bodydragover(event)">
	    <table class="layout" style="width: 100%;">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                    	<c:choose>
	                    		<c:when test="${mode eq 'reuse'}">
			                        <li><span onclick="btn_Save('<c:out value='${mode}'/>');"><spring:message code='ezJournal.t26' /></span></li>
			                        <li><span onclick="btn_TempSave('reuse')"><spring:message code='ezJournal.t74' /></span></li>
	                    		</c:when>
	                    		<c:when test="${mode eq 'modify'}">
			                        <li><span onclick="btn_Save('<c:out value='${mode}'/>');"><spring:message code='ezJournal.t26' /></span></li>
	                    		</c:when>
	                    		<c:otherwise>
	                    			<!-- 2018-05-30 구해안 그룹웨어 모듈 '등록','저장후닫기' => '저장'으로 통일  ezJournal.t73 => t26 -->
			                        <li><span onclick="btn_Save('<c:out value='${mode}'/>');"><spring:message code='ezJournal.t26' /></span></li>
			                        <li><span onclick="btn_TempSave('temp')"><spring:message code='ezJournal.t74' /></span></li>
	                    		</c:otherwise>
	                    	</c:choose>
	                    	<li id="btnGetOther"><span onclick="getOtherJournalList()"><spring:message code='ezJournal.t75' /></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>	                        
	                        <li><span onclick="btn_Close();"></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px">
	                <table class="content" style="width: 100%;">
	                    <tr>
	                        <th style="width: 6%;"><spring:message code='ezJournal.t76'/></th>
	                        <td style="width: 45%" colspan="2">
	                        	<select id="optType" style="width: 38%;" onchange="changeType(this);">
	                        		<c:forEach var="type" items="${typeList}">
	                        			<option value="<c:out value='${type.journaltypeId }'/>"
	                        				<c:if test="${type.journaltypeId eq typeId}">
	                        					selected
	                        				</c:if>
	                        			><spring:message code='${type.journaltypeId }'/></option>
	                        		</c:forEach>
	                        	</select>
	                        	<select id="optForm" style="width:60%;" onchange="changeForm(this)">
	                        	</select>
	                        </td>
	                        <th style="width: 10%;"><spring:message code='ezJournal.t77' /></th>
	                        <td style="width: 35%; border-right: none;">
								<div class="custom_radio">
									<c:choose>
										<c:when test="${journal.deptShare eq 'N' && journal.deptShare ne null }">
											<input type="radio" id="selPublic" name="isPublic" value="Y"/><label for="selPublic"><spring:message code='ezJournal.t78'/></label>
											<input type="radio" id="selPrivate" name="isPublic" value="N" checked/><label for="selPrivate"><spring:message code='ezJournal.t79'/></label>
										</c:when>
										<c:otherwise>
											<input type="radio" style="margin-bottom: 3px;" id="selPublic" name="isPublic" value="Y" checked/><label for="selPublic"><spring:message code='ezJournal.t78'/></label>
											<input type="radio" style="margin-bottom: 3px;" id="selPrivate" name="isPublic" value="N"/><label for="selPrivate"><spring:message code='ezJournal.t79'/></label>
										</c:otherwise>
									</c:choose>
								</div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezJournal.t80' /></th>
	                        <td style="width: 5%; border-right: none;">
                        		<a class="imgbtn imgbck"><span style="text-align: right;" id="clickbtn" onclick="selectReceiver()"><spring:message code='ezJournal.t81'/></span></a>
	                        </td>
	                        <td colspan="3" style="border-left: none; vertical-align: middle; height: 28px;">
	                       		<div style="overflow-y: auto; height: 28px;">
	                       			<div style="display: table; height: 100%;">
	                       				<div id="receiverlist" style="display: table-cell; vertical-align: middle;">
	                       				</div>
	                       			</div>
	                       		</div>	
	                        	<div id="receiverID" style="overflow-y: auto; height: 17px; display:none;"></div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezJournal.t56' /></th>
	                        <td colspan="4">
	                            <input type="text" id="title" style="WIDTH: 100%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" >
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>  
	        <tr>
	            <td style="vertical-align: top; height: 100%" id="EdtorSize">
	                <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 98%; width: 100%; overflow: auto; margin-top:-1px"></iframe>
	            </td>
	        </tr>
	        <tr>
  				<td>
   					<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px;" src="/ezJournal/dragAndDrop.do?mode='<c:out value='${mode}'/>'&journalId='<c:out value='${journalId}'/>'"></iframe>
  				</td>
  			</tr>
	    </table>

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <c:if test="${mode eq 'sum' }">
	    	<span id="loading"><img id="loading-image" src="/images/ProgressBar.gif" alt="Loading..."></span>
	    </c:if>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='ezJournal.t185' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>

		<script>
		// 다른일지 가져오기 리스트
	    function getOtherJournalList() {
	        var heigth = window.screen.availHeight;
	        var width = window.screen.availWidth;
	        var left = (width - 500) / 2;
	        var top = (heigth - 300) / 2;
	        var szHref = "/ezJournal/otherJournalList.do?formId=" + selFormId;
            DivPopUpShow(520, 390, szHref);
    	}
		
		function getOtherJournal(journalId){
			$.ajax({
    			type : "POST",
    			dataType : "html",
    			url : "/ezJournal/getOtherJournalContent.do",
    			data : {"journalId" : journalId},
    			success : function(result) {
					message.SetEditorContent(result);
					DivPopUpHidden();
    			}
    		});
		}
		
			mobileDistinction();
		</script>
	</body>
</html>