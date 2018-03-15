<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
		<c:choose>
			<c:when test="${mode == 'new'}">
			    <title><spring:message code='ezJournal.t131' /></title>
			</c:when>
			<c:otherwise>
			    <title><spring:message code='ezJournal.t131' /></title>
			</c:otherwise>
		</c:choose>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
	    <link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
	    <link rel="stylesheet" href="/css/ezJournal/journal_css.css" type="text/css" />
	    <link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jstree/jstree.js"></script>
	    <script type="text/javascript" src="/js/ezJournal/journal_script.js"></script>
	    <script type="text/javascript">
			var companyId = "${info.companyID}"; 
			var userId = "${userId}";
			// 작성자 이름 // lang에 따라 가져오는값 바꿔야함..
			var userName = "${info.displayName1}";			
			//트리조직도 JSON
	   		var treeContent;
	    	// 수신자
	    	var selReceiver = [];
	    	// 마지막에 사용했던 양식아이디
	    	var lastFormId;
	    	// 일지함아이디
	    	var typeId = "<c:out value='${typeId}'/>";
	    	// 작성일
	    	var nowDate = "${nowDate}";
	    	// 부서아이디
	    	var deptId = "${info.deptID}";
	    	// 첨부파일 최대용량
	    	var AttachLimit = 5;
	    	var mode = "${mode}";
	    	var oldJournalId = "${journalId}";
	    	var selFormId = "";
	    	
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
	    		
	    		console.log("lastFormId 확인 : " + lastFormId);
	    		if (lastFormId != null && lastFormId != "") {
	    			lastFormId = parseInt(lastFormId);
	    			console.log("이전양식가져올때는 여기로 : " + lastFormId);
	    			getJournalForm(lastFormId);
	    			selFormId = lastFormId;
	    			$("#optForm option[value=" + lastFormId + "]").attr("selected", "selected");
	    			lastFormId = "";
	    		} else {
	    			selFormId = $("#optForm").find("option:selected").val();
		    		getJournalForm(selFormId);
	    		}
	    	}
			
			// 선택된 양식의 폼 호출
			function getJournalForm(formId) {
				$.ajax({
	    			type : "POST",
	   				dataType : "json",
	   				url : "/ezJournal/journalGetForm.do",
	   				data : {"formId" : formId,
   							"typeId" : typeId},
   					success : function(result){
   						console.log(result);
   						console.log(userName);
   						
   						if (result.formStatus == null) {
   							$("#btnGetOther").css("display", "none");
   						} else {
   							$("#btnGetOther").css("display", "");
   						}
   						var title = "[" + result.formName + "] " + nowDate + " (" + userName + ")";
   						console.log(title);
   						
   						$("#title").val(title);
   						
   						// 예약어 부분에 내용 추가
   						var content = result.formContent;
	   					content = content.replace(/@journalDeptId/gim, deptId);
   						content = content.replace(/@journalWriterId/gim, userId);
   						content = content.replace(/@journalWriteDate/gim, nowDate);
   						
   					//	message.SetEditorContent(result.formContent);
   						message.SetEditorContent(content);
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
	   				dataType : "json",
	   				url : "/ezJournal/journalGetLastForm.do",
	   				data : {"typeId" : typeId},
   					success : function(result){
						lastFormId = result;
						var firstType = $("#optType").find("option:selected");
			    		getFormList(firstType);
	   				},
	   				error : function(request, status, error) {
		    			alert("code : " + request.status + "\nmessage : " + request.responseText + "\nerror : " + error);
	   				}
	    		});
				
			}
			
			// 수신자 선택화면 호출
	    	function selectReceiver(){			
				var url = "/ezJournal/selectReceiver.do";
				url += "?companyId=" + companyId;
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
			
	    /* 	
	    	$(document).ready(function() {
	    		var firstType = $("#optType").find("option:first");
	    		getFormList(firstType);
	    	}); 
	    */
	    
	    	// 양식내용을 에디터에 넣어주는 작업 
		    function Editor_Complete() {
	    		getLastForm(typeId);
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
						fileList = GetAttribute(filelist[i + 1], "data2");
					} else {
						fileList += "," + GetAttribute(filelist[i + 1], "data2");
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
	                success: function(data) {	   
	                  alert("<spring:message code='ezCircular.t70'/>");
	                  
	               // window.opener.refresh_onclick();
	             	  window.opener.reload();
          			  window.close();
	                }
	 			});
	    	}
	    	
	    	// 임시 저장
		    function btn_TempSave() {
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
						fileList = GetAttribute(filelist[i + 1], "data2");
					} else {
						fileList += "," + GetAttribute(filelist[i + 1], "data2");
	        		}
				}
				
				// 수신자 있는 경우 수신자 가져오기
				var receiverList = $("#receiverlist").html();
				var receiverID = $("#receiverID").html();
	
	    		$.ajax ({
	 			   	url : '/ezJournal/saveTempJournal.do?mode=temp',
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
	                success: function(data) {	   
	                  alert("<spring:message code='ezCircular.t70'/>");
	                  
	               // window.opener.refresh_onclick();
	             	  window.opener.reload();
          			  window.close();
	                }
	 			});
	    	}
	    	
	    	// 다른일지 가져오기
		    function getOtherJournal() {
	    	//	var height = window.screen.availHeight;
	    	//	var width = window.screen.availWidth;
	    	//	var left = (width - 500) / 2;
	    	//	var top = (height - 400) / 2;
	    	/*
	    		var url = "/ezJournal/getOtherJournal.do?userId=" + userId + "&typeId=" + typeId + "&formId=" + selFormId;
	    		var feature = "status:no; dialogHeight:400px; dialogWidth:520px; help:no; resizable:yes;";
	    		feature += GetShowModalPosition(400, 300);
	    		var rtnVal = window.showModalDialog(url, "", feature);
	    	*/
	    	//	DivPopUpShow(520, 410, url);
	    	
	    	/*
	    		$.ajax({
	    			url : "/ezJournal/getOtherJournal.do",
	    			type : "POST",
					dataType : "text",
					data : {	userId : userId,
								typeId : typeId,
								formId : selFormId
					},
					success : function (result) {
						$("#selectOther").html(result);
						$("#getOtherPopup").css("display", "");
					}
	    		})		
	    	*/	
	    	
	    	}
	    
	    	// 닫기 버튼 클릭시
		    function btn_Close() {
				//파일 첨부된 목록 가져오기
				var listtable = dadiframe.document.getElementById("filelist");
				var filelist = GetChildNodes(listtable);
				var fileList = "";
	
				for (var i = 0; i < filelist.length - 1; i++) {	    
					if (i == 0) {
						fileList = GetAttribute(filelist[i + 1], "data2");
					} else {
						fileList += "," + GetAttribute(filelist[i + 1], "data2");
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
						window.close();
	                },
	                error: function() {
	                	alert("<spring:message code='ezCircular.t102'/>");	
	                }
				});
			}
	    </script>
	</head>
	<body class="popup" style="height: 97%;" ondragover="bodydragover(event)">
	
	 
	 
	    <table class="layout" style="width: 100%;">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                    	<c:choose>
	                    		<c:when test="${mode eq 'reuse'}">
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t73' /></span></li>
	                    		</c:when>
	                    		<c:when test="${mode eq 'modify'}">
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t73' /></span></li>
	                    		</c:when>
	                    		<c:otherwise>
			                        <li><span onclick="btn_Save('${mode}');"><spring:message code='ezJournal.t73' /></span></li>
			                        <li><span onclick="btn_TempSave()"><spring:message code='ezJournal.t74' /></span></li>
	                    		</c:otherwise>
	                    	</c:choose>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnGetOther"><span onclick="getOtherJournal()"><spring:message code='ezJournal.t75' /></span></li>
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
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezJournal.t76'/></th>
	                        <td style="width: 300px">
	                        	<select id="optType" style="width: 110px;" onchange="getFormList(this)">
	                        		<c:forEach var="type" items="${typeList}">
	                        			<option value="<c:out value='${type.journaltypeId }'/>"
	                        				<c:if test="${type.journaltypeId eq typeId}">
	                        					selected
	                        				</c:if>
	                        			><spring:message code='${type.journaltypeId }'/></option>
	                        		</c:forEach>
	                        	</select>
	                        	<select id="optForm" style="width:182px;" onchange="getJournalForm(this.value)">
						                        	
	                        	</select>
	                        </td>
	                        <th><spring:message code='ezJournal.t77' /></th>
	                        <td style="width: 300px;">
	                        	<input type="radio" id="selPublic" name="isPublic" value="Y" checked/><label for="selPublic"><spring:message code='ezJournal.t78'/></label>
	                        	<input type="radio" id="selPrivate" name="isPublic" value="N"/><label for="selPrivate"><spring:message code='ezJournal.t79'/></label>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezJournal.t80' /></th>
	                        <td colspan="3">
	                            <input id="receiverInput" name="receiverInput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box; display:none;" onkeyup="return on_keydown(event)" >
	                       		<div id="receiverlist" style="overflow-y: auto; height: 28px; display: inline;"></div>
	                        	<div id="receiverID" style="overflow-y: auto; height: 17px; display:none;"></div>
	                        	<div style="position: absolute; right: 15px; top: 88px;">
	                        		<a class="imgbtn"><span style="text-align: right;" id="clickbtn" onclick="selectReceiver()"><spring:message code='ezJournal.t81'/></span></a>
	                        	</div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezJournal.t56' /></th>
	                        <td colspan="3">
	                            <input type="text" id="title" style="WIDTH: 100%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeydown="Title_onkeyDown(event)" >
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>  
	        <tr>
	            <td style="vertical-align: top; height: 100%" id="EdtorSize">
	                <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 97%; width: 100%; overflow: auto; margin-top:-1px"></iframe>
	            </td>
	        </tr>
	        <tr>
  				<td>
   					<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezJournal/dragAndDrop.do?mode=${mode}&journalId=${journalId}"></iframe>
  				</td>
  			</tr>
	    </table>
	    <div id="getOtherPopup" class="popupwrap1" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:70px">
			<div class="popupwrap3">
				<table id="selectOther" class="mainlist" style="margin-top:10px;">  
					
				</table>
				<br />
				<table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<a class="imgbtn"><span onClick="search_start()"><spring:message code='ezAddress.t142' /></span></a>
							<a class="imgbtn"><span onClick="SearchOptionHidden()"><spring:message code='ezAddress.t11' /></span></a>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="shadow"></div>	
	</body>
</html>