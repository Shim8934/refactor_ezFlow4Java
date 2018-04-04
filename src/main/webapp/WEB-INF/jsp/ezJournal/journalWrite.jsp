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
	    <link rel="stylesheet" href="<spring:message code='ezJournal.c1' />" type="text/css">
	    <link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
	    <link rel="stylesheet" href="/css/ezJournal/journal_css.css" type="text/css" />
	    <link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jstree/jstree.js"></script>
	    <script type="text/javascript" src="/js/ezJournal/journal_script.js"></script>
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
			var userId = "${userId}";
			//트리조직도 JSON
	   		var treeContent;
	    	// 수신자
	    	var selReceiver = [];
	    	// 마지막에 사용했던 양식아이디
	    	var lastFormId = "";
	    	// 일지함아이디
	    	var typeId = "<c:out value='${typeId}'/>";
	    	// 부서아이디
	    	var deptId = "${info.deptID}";
	    	// 첨부파일 최대용량
	    	var AttachLimit = 5;
	    	var mode = "<c:out value='${mode}'/>";
	    	var oldJournalId = "<c:out value='${journalId}'/>";
	    	var selFormId = "";
	    	var selTypeId = "";
	    	// 수정, 임시저장, 재사용시 가져오는 수신자리스트
	    	var receiverId = "";
	    	var receiverName = "";
	    	//취합할 양식 아이디들
	    	var journalIdList = [];
	    	
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
	    				console.log(result.length);
	    				var str = "";
	    				if (result.length > 0) {
		    				$(result).each(function() {
		    					str += "<option value=" + this.formId + ">" + this.formName + "</option>";
		    				});
	    				} else {
	    					str += "<option><spring:message code='ezJournal.t134'/></option>";
	    				}
	    				$("#optForm").html(str);
	    			}
	    		});
	    		
	    	}
			
	    	function changeType(elem) {
	    		if (mode == "temp" || mode == "reuse" || mode == "sum") {
					if (!confirm("<spring:message code='ezJournal.t159'/>")) {
						// 취소시 현재의 양식을 선택하게해야함..
					//	$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
						$(elem).val(selTypeId);
						return;
					}
				}
	    		
 	    		getFormList(elem);
// 	    		getJournalForm(lastFormId);
	    		var changeTypeId = $(elem).val();
	    		selTypeId = changeTypeId;
				
	    		console.log("lastFormId 확인 : " + lastFormId);
	    		if (lastFormId != null && lastFormId != "" ) {
	    			lastFormId = parseInt(lastFormId);
	    			console.log("이전양식가져올때는 여기로 : " + lastFormId);
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
				
				console.log("formId확인 :" + formId);
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
   						console.log(result);
   						
   						if (result.formStatus == null) {
   							$("#btnGetOther").css("display", "none");
   						} else {
   							$("#btnGetOther").css("display", "");
   						}
   						
   						$("#title").val(result.journalTitle);
   						message.SetEditorContent(result.journalContent);
   						opener.journalIdList = [];
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
				GetOpenWindow(url, "selectReceiver", 980, 600);
			}
	    	
			// 선택된 수신자 화면에 뿌리기
	    	function showReceiver() {
	    		console.log("selReceiver : " + selReceiver);
    			var strReceiver = "";
    			var strReceiverID = "";
    			var total = $(selReceiver).length;
    			console.log("total : " + total);
	    		$.each(selReceiver, function(index, item) {
					if (index == total - 1) {
						strReceiver += item.userName;	
						strReceiverID += item.userId;
					} else {
						strReceiver += item.userName + ", ";
						strReceiverID += item.userId + ", ";
					}
	    		});
	    		console.log(strReceiverID);
	    		$("#receiverlist").html(strReceiver);
	    		$("#receiverID").html(strReceiverID);
	    	}
	     	
	    	window.onload = function () {
	    		
	    		if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
                    self.resizeTo(760, 800);
                } else {
                    self.resizeTo(785, 830);
                }
				
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
	    			console.log(fileList);
	    			dadiframe.setAttachFileInfo(fileList);
	    		}
	    	
	    	}; 
	    
	    	// 양식내용을 에디터에 넣어주는 작업 
		    function Editor_Complete() {
				getFormList($("#optType"));
	    		
	    		switch (mode) {
				case 'new':
//					getFormList($("#optType"));
		    		getLastForm(typeId);
				
		    		if (lastFormId != null && lastFormId != "" ) {
		    			console.log("이전양식가져올때는 여기로 : " + lastFormId);
		    			selFormId = lastFormId;
		    			getJournalForm(lastFormId);
		    			$("#optForm option[value=" + lastFormId + "]").attr("selected", "selected");
		    			lastFormId = "";
		    		} else {
		    			selFormId = $("#optForm").find("option:selected").val();
		    			console.log("selFormId : " + selFormId);
			    		getJournalForm(selFormId);
		    		}
					break;
				case 'sum':
					selFormId = opener.sumFormId;
					journalIdList = opener.journalIdList;
					var selectedType = $("#optType");
					getFormList(selectedType);
					$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
		    		getJournalForm(selFormId);
		    		opener.sumFormId = "";
					break;
				case 'reuse': case 'modify': case 'temp':
					selFormId = "${journal.formId}";
			//		var selectedType = $("#optType");
			//		getFormList(selectedType);
					$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
					var content = '${content}';
	    			message.SetEditorContent(content);
	    			
	    			if (mode == 'modify') {
	    				$("#optType").attr("disabled", "true");
						$("#optForm").attr("disabled", "true");
	    			}
	    			
					break;
				/*	
				case 'modify': 
					selFormId = "${formId}";
			//		var selectedType = $("#optType");
			//		getFormList(selectedType);
					$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
					$("#optType").attr("disabled", "true");
					$("#optForm").attr("disabled", "true");
					var content = '${content}';
	    			message.SetEditorContent(content);
					break;
				case 'temp': 
					selFormId = "${formId}";
				//	journalId = "${journalId}";
				//	var selectedType = $("#optType");
				//	getFormList(selectedType);
					$("#optForm option[value=" + selFormId + "]").attr("selected", "selected");
					var content = '${content}';
	    			message.SetEditorContent(content);
					break;
				*/
				default:
					break;
				}
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
					alert("<spring:message code='ezCircular.t52'/>");
					doubleSubmitFlag = false;
					
					return;
				}
	
				if ($.trim($("#title").val()) == "") {
		        	alert("<spring:message code='ezCircular.t190' />");
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
						fileList += "," + GetAttribute(filelist[i + 1], "fileinfo");
	        		}
				}
				
				// 수신자 있는 경우 수신자 가져오기
				var receiverList = $("#receiverlist").html();
				var receiverID = $("#receiverID").html();
	
	    		$.ajax ({
	 			   	url : '/ezJournal/saveJournal.do',
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
	                			oldJournalId : oldJournalId,
	                			mode : mode
	                },  
	                cache: false,
	                success: function(result) {	   
	                	if (result != null && result != "") {
		                  	alert("<spring:message code='ezJournal.t137'/>");
	          			 	sendJournalRecvMail($("#title").val(),receiverID,result);
		                  
		             	  	opener.setJournalList();
	          			  	window.close();
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
					type:"post",
					data:{"journalTitle":journalTitle,"recvIds":recvIds,"journalId":journalId},
					url:"/ezJournal/sendJournalRecvMail.do",
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
					alert("<spring:message code='ezCircular.t52'/>");
					doubleSubmitFlag = false;
					
					return;
				}
	
				if ($.trim($("#title").val()) == "") {
		        	alert("<spring:message code='ezCircular.t190' />");
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
						fileList += "," + GetAttribute(filelist[i + 1], "fileinfo");
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
	                },  
	                cache: false,
	                success: function(result) {
	                	if (result === "ok") {
			            	alert("<spring:message code='ezJournal.t137'/>");
			             	opener.setJournalList();
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
						fileList += "," + GetAttribute(filelist[i + 1], "fileinfo");
	        		}
				}
				console.log("fileList : " + fileList);
				$.ajax({
					async : false,
					url : '/ezJournal/tempUploadFileDelete.do',
	                type : 'POST',
	                dataType : 'json',
	                data : {
	                	fileList : fileList
	                },
	                success: function() {
	                	opener.setJournalList();
						window.close();
	                },
	                error: function() {
	                	alert("<spring:message code='ezJournal.t149'/>");	
	                }
				});
			}
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
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t73' /></span></li>
			                        <li><span onclick="btn_TempSave('reuse')"><spring:message code='ezJournal.t74' /></span></li>
	                    		</c:when>
	                    		<c:when test="${mode eq 'modify'}">
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t26' /></span></li>
	                    		</c:when>
	                    		<c:otherwise>
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t73' /></span></li>
			                        <li><span onclick="btn_TempSave('temp')"><spring:message code='ezJournal.t74' /></span></li>
	                    		</c:otherwise>
	                    	</c:choose>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnGetOther"><span onclick="getOtherJournalList()"><spring:message code='ezJournal.t75' /></span></li>
	                        <li><span onclick="btn_Close();"><spring:message code='ezJournal.t27' /></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px">
	                <table class="content" style="width: 100%;">
	                    <tr>
	                        <th style="width: 6%;"><spring:message code='ezJournal.t76'/></th>
	                        <td style="width: 40%">
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
	                        <td style="width: 40%; border-right: none;">
	                        	<c:choose>
	                        		<c:when test="${journal.deptShare eq 'N' && journal.deptShare ne null }">
			                        	<input type="radio" id="selPublic" name="isPublic" value="Y"/><label for="selPublic"><spring:message code='ezJournal.t78'/></label>
			                        	<input type="radio" id="selPrivate" name="isPublic" value="N" checked/><label for="selPrivate"><spring:message code='ezJournal.t79'/></label>
	                        		</c:when>
	                        		<c:otherwise>
			                        	<input type="radio" id="selPublic" name="isPublic" value="Y" checked/><label for="selPublic"><spring:message code='ezJournal.t78'/></label>
			                        	<input type="radio" id="selPrivate" name="isPublic" value="N"/><label for="selPrivate"><spring:message code='ezJournal.t79'/></label>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                        <td style="border-left: none;"></td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezJournal.t80' /></th>
	                        <td colspan="3" style="border-right: none; vertical-align: middle;">
	                       		<div style="overflow-y: auto; height: 28px;">
	                       			<div style="display: table; height: 100%;">
	                       				<div id="receiverlist" style="display: table-cell; vertical-align: middle;">
	                       				</div>
	                       			</div>
	                       		</div>	
	                        	<div id="receiverID" style="overflow-y: auto; height: 17px; display:none;"></div>
	                        </td>
	                        <td style="border-left: none;">
                        		<a class="imgbtn"><span style="text-align: right;" id="clickbtn" onclick="selectReceiver()"><spring:message code='ezJournal.t81'/></span></a>
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
   					<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px;" src="/ezJournal/dragAndDrop.do?mode=${mode}&journalId=${journalId}"></iframe>
  				</td>
  			</tr>
	    </table>

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    
	    <div id="loading"><img id="loading-image" src="/images/ProgressBar.gif" alt="Loading..." /></div>

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
		
		$(window).load(function() {    
		     $('#loading').hide();  
	    });
		</script>
	</body>
</html>