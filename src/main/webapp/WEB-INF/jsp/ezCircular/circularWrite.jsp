<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%"> 
	<head>
		<c:choose>
			<c:when test="${mode eq 'reuse'}">
				<title><spring:message code="ezCircular.t183"/></title>
			</c:when>
			<c:when test="${mode eq 'modify'}">
				<title><spring:message code="ezCircular.t184"/></title>
			</c:when>
			<c:otherwise>
				<title><spring:message code="ezCircular.t55"/></title>
			</c:otherwise>
		</c:choose>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezCircular.c1', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/circular_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/circularComment.js')}"></script>
		
		<script type="text/javascript">
	    	var msgRtn = "";
	    	var mode = "<c:out value='${mode}'/>";
	    	var oldCircularID = "<c:out value='${circularID}'/>";
	    	var AttachLimit = 5;
	    	var userID = "<c:out value='${userID}'/>";
	    	var userName = "<c:out value='${userName}'/>";
	    	var userName2 = "<c:out value='${userName2}'/>";
	    	var userMyID = "<c:out value='${userMyID}'/>";
	    	var userMyName = "<c:out value='${userMyName}'/>";
	    	var userMyName2 = "<c:out value='${userMyName2}'/>";
	    	var listSize = "<c:out value='${listSize}'/>";
	    	var defaultFontAndSize  = "<c:out value='${defaultFontAndSize}'/>";
	    	var strAttach = "<c:out value='${strAttach}'/>";
	    	
	    	if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
	        	}
	    	}

	    	window.onbeforeunload = function () {
	    		btn_Close();
	    	} 

		    window.onload = function () {
		    	//2018-02-13 주홍선 IE10에서 창이 정상적으로 열리지 않던 것 수정
		    	if (new RegExp(/MSIE 10/).test(navigator.userAgent)) {
		    		document.getElementById("EdtorSize").style.height = document.body.clientHeight - 340 + "PX";
		    	}
				if (listSize != 0) {
		        	document.getElementById("title").value = "${result.title}";
		        	document.getElementById("receiverlist").innerHTML = "<c:out value='${userName}'/>";
		        	document.getElementById("receiverlist2").innerHTML = "<c:out value='${userName2}'/>";
		        	document.getElementById("receiverID").innerHTML = "<c:out value='${userID}'/>";

		        	//hasFie구분
		        	setAttachFileInfo("<c:out value='${strAttach}'/>");
			        
		        	g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
		        	
		        	var list = userID.split(", ");
		        	var nameList = userName.split(", ");
		        	var nameList2 = userName2.split(", ");

		        	// 수정이나 임시저장일경우 작성자는 회람자로 무조건 추가되기때문에 -1처리함
		        	if (mode != "write") {
		        		listSize = listSize - 1;
		        	}

		        	for (var i = 0; i < listSize; i++) {		        		
		        		g_attendant["name"][i] = nameList[i];
		        		g_attendant["id"][i] = list[i];
		        		g_attendant["name2"][i] = nameList2[i];
		        	}
		        	
				}
		    }
		    
			window.onresize = function () {
				document.getElementById("EdtorSize").style.height = document.body.clientHeight - 340 + "PX";
			}
			
	    	function FieldsAvailable() {
	    	}

		    function keyword_onkeydown() {
	    	    if (event.keyCode == 13) {
	    	    	Entry_onKeydown();	
	    	    }
		        return true;
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
		    
	    	function btn_Save(mode) {
	        	if (doubleSubmitCheck()){
	        		return;
	        	}
	    		//회람작성 눌렀을 시
	        	var content = message.GetEditorContent();
				var option = 0;

				if ($("#title").val() == "") {
					alert("<spring:message code='ezCircular.t52'/>");
					doubleSubmitFlag = false;
					
					return;
				}

				if ($("#receiverlist").text() == "") {
	    			alert("<spring:message code='ezCircular.t53'/>")
	    			doubleSubmitFlag = false;
	    			
	    			return;
	    		}

				if ($.trim($("#title").val()) == "") {
		        	alert("<spring:message code='ezCircular.t190' />");
		        	doubleSubmitFlag = false;

		        	return;
		        }

				//의견
				$(':checkbox[id=option1]:checked').each(function(){
					option = 1;	
				});
				
				//공지메일발송
				$(':checkbox[id=option2]:checked').each(function(){
					option = 2;
				});
				
				//의견, 공지메일발송
				if ($(':checkbox[name=chkList]:checked').length == 2) {
					option = 3;
				}
		
				//파일 첨부된 목록 가져오기
				var listtable = dadiframe.document.getElementById("filelist");
				var filelist = GetChildNodes(listtable);
				var fileList = "";

				//2018-07-06 김보미 - 파일부분 수정
// 				for (var i = 0; i < filelist.length - 1; i++) {	    
// 					if (i == 0) {
// 						fileList = GetAttribute(filelist[i + 1], "data2");
// 					} else {
// 						fileList += "," + GetAttribute(filelist[i + 1], "data2");
//             		}
// 				}
			    var fileArr = new Array(); //Object를 배열로 저장할 Array
		        for (var i = 0; i < filelist.length - 1; i++) {
			        var fileObj = new Object(); //key, value형태로 저장할 Object
			        fileObj.newFileName = GetAttribute(filelist[i + 1], "data");
			        fileObj.pFileName = GetAttribute(filelist[i + 1], "data2");
			        fileObj.fileSize = GetAttribute(filelist[i + 1], "data3");
			        fileArr.push(fileObj);
		        }
				
				var receiverList = document.getElementById("receiverlist").innerHTML;
				var receiverList2 = document.getElementById("receiverlist2").innerHTML;
				var receiverID = document.getElementById("receiverID").innerHTML;
				
				// 18-05-24 김민성 - 작성자 이름이 A, 회람자 이름이 A1 과 같은 유사한 이름의 경우 작성된회람판에서 안보이는 문제
				//if (receiverList.indexOf(userMyName) == -1) {
					receiverList += ", " + userMyName;
					receiverList2 += ", " + userMyName2;
					receiverID += ", " + userMyID;
				//}

	    		$.ajax ({
	 			   	url : '/ezCircular/saveCircular.do',
	 			   	type : 'POST',
	                dataType : 'text',
	                data : {	title : document.getElementById("title").value,
	                			importance : document.getElementById("importance").value,
	                			option : option,
	                			receiverList : receiverList,
	                			receiverList2 : receiverList2,
	                			receiverID : receiverID,
	                			content : content,
	                			//2018-07-06 김보미 - 파일부분 수정
 	                			//fileList : fileList,
	                			fileList : JSON.stringify(fileArr),
	                			oldCircularID : oldCircularID,
	                			mode : mode
	                },  
	                cache: false,
	                success: function(data) {	   
	                  alert("<spring:message code='ezCircular.t70'/>");
	                  
	                  window.opener.getLeftCount();
	                  window.opener.refresh_onclick();
	             	  window.close();
	                }
	 			});
	    	}

	    	function btn_TempSave() {
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

	    		//임시저장
	    		if (confirm("<spring:message code='ezCircular.t72'/>")) {
		        	var content = message.GetEditorContent();
					var option = 0;
					var circularID = 0;
					
					if (oldCircularID != "") {
						circularID = oldCircularID;
					}
					
					$(':checkbox[id=option1]:checked').each(function(){
						option = 1;	
					});
					
					$(':checkbox[id=option2]:checked').each(function(){
						option = 2;	
					});
					
					if ($(':checkbox[name=chkList]:checked').length == 2) {
						option = 3;
					}
					
					//파일 첨부된 목록 가져오기
					var listtable = dadiframe.document.getElementById("filelist");
					var filelist = GetChildNodes(listtable);
					var fileList = "";

					//2018-07-06 김보미 - 파일부분 수정
// 					for (var i = 0; i < filelist.length - 1; i++) {	    
// 						if (i == 0) {
// 							fileList = GetAttribute(filelist[i + 1], "data2");
// 						} else {
// 							fileList += "," + GetAttribute(filelist[i + 1], "data2");
// 	            		}
// 					}
					var fileArr = new Array(); //Object를 배열로 저장할 Array
			        for (var i = 0; i < filelist.length - 1; i++) {
				        var fileObj = new Object(); //key, value형태로 저장할 Object
				        fileObj.newFileName = GetAttribute(filelist[i + 1], "data");
				        fileObj.pFileName = GetAttribute(filelist[i + 1], "data2");
				        fileObj.fileSize = GetAttribute(filelist[i + 1], "data3");
				        fileArr.push(fileObj);
			        }
					
					var receiverList = document.getElementById("receiverlist").innerHTML;
					var receiverList2 = document.getElementById("receiverlist2").innerHTML;
					var receiverID = document.getElementById("receiverID").innerHTML;

					if (receiverList == "") {
						receiverList = userMyName;
						receiverList2 = userMyName2;
						receiverID = userMyID;
					} else {
						receiverList += ", " + userMyName;
						receiverList2 += ", " + userMyName2;
						receiverID += ", " + userMyID;
					}

		    		$.ajax ({
		 			   	url : '/ezCircular/circularSaveTemp.do',
		                type : 'POST',
		                dataType : 'text',
		                data : {	
		                			mode : "temp",
		                			title : document.getElementById("title").value,
		                			importance : document.getElementById("importance").value,
		                			option : option,
		                			receiverList : receiverList,
		                			receiverList2 : receiverList2,
		                			receiverID : receiverID,
		                			circularID : circularID,
		                			content : content,
		                			//2018-07-06 김보미 - 파일부분 수정
	 	                			//fileList : fileList
		                			fileList : JSON.stringify(fileArr)
		                },  
		                cache: false,
		                success: function(data) {	   
							window.opener.getLeftCount();
							window.opener.refresh_onclick();
							window.close();
		                	alert("<spring:message code='ezBoard.t10033'/>");	
		                },
		                error: function() {
		                	alert("<spring:message code='ezCircular.t102'/>");	
		                }
		 			});
	    		}
	    	}

	    	/* 2018-09-17 김민성 - 에디터 폰트 설정값 로직 수정 */
 			function Editor_Complete() {
    	    	if(mode != "write") {
		    		message.SetEditorContent(sigBody.innerHTML);
    	    	} else {
    	    		message.SetEditorContent("");
    	    	}
    	    }
			
			function btn_Close() {
				//파일 첨부된 목록 가져오기
				var listtable = dadiframe.document.getElementById("filelist");
				var filelist = GetChildNodes(listtable);
				var fileList = "";

				//2018-07-06 김보미 - 파일부분 수정
// 				for (var i = 0; i < filelist.length - 1; i++) {
// 					if (i == 0) {
// 						fileList = GetAttribute(filelist[i + 1], "data2");
// 					} else {
// 						fileList += "," + GetAttribute(filelist[i + 1], "data2");
//             		}
// 				}
			    var fileArr = new Array(); //Object를 배열로 저장할 Array
		        for (var i = 0; i < filelist.length - 1; i++) {
			        var fileObj = new Object(); //key, value형태로 저장할 Object
			        fileObj.newFileName = GetAttribute(filelist[i + 1], "data");
			        fileObj.pFileName = GetAttribute(filelist[i + 1], "data2");
			        fileObj.fileSize = GetAttribute(filelist[i + 1], "data3");
			        fileArr.push(fileObj);
		        }

				$.ajax({
					async : false,
					url : '/ezCircular/tempUploadFileDelete.do',
	                type : 'POST',
	                dataType : 'json',
	                data : {
						//2018-07-06 김보미 - 파일부분 수정
 	                	//fileList : fileList
	                	fileList : JSON.stringify(fileArr)
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
	
	<xmp id="sigBody" style="display: none;">${result.content}</xmp>
	<!-- 2018-02-19 김보미 - height를 100%에서 98%로 수정 -->
	<body id="mainbodytag" class="popup" style="height: 98%; overflow: hidden;">
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<table id="normalScreen" class="layout">
			<tr>
    			<td style="height:20px">
      				<div id="menu">      
        				<ul>
        					<c:choose>
        						<c:when test="${mode eq 'reuse'}">
        							<li><span onClick="btn_Save('${mode}')"><spring:message code="ezCircular.t183"/></span></li>
        						</c:when>
        						<c:when test="${mode eq 'modify'}">
        							<li><span onClick="btn_Save('${mode}')"><spring:message code="ezCircular.t184"/></span></li>
        						</c:when>
        						<c:otherwise>
        							<!-- 2018-05-30 구해안 그룹웨어 모듈 '등록','저장후닫기' => '저장'으로 통일  ezCircular.t28 => t25 -->
		          					<li><span onClick="btn_Save('${mode}')"><spring:message code="ezCircular.t25"/></span></li>	
		          					<li><span onClick="btn_TempSave()"><spring:message code="ezCircular.t71"/></span></li>       						
        						</c:otherwise>
        					</c:choose>
        				</ul>
      				</div>
      				<div id="close">
        				<ul>
          					<li><span onClick="btn_Close()"></span></li>
        				</ul>
      				</div>
      				<table class="content" style="width:100%;border-bottom:0px">
        				<tr>
          					<th style="width:200px;"><spring:message code="ezCircular.t32"/></th>
          					<!-- 2018-07-16 김보미 - maxLength 추가. -->
          					<td colspan="3" style="width:100%"><input type="text" id="title" style="width:100%"  maxlength="500"></td>
        				</tr>
	        			<tr>
	          				<th><spring:message code="ezCircular.t115"/></th>
	          				<td id="Td_StartDate" style="overflow:hidden; width:200px;">
	          					<select id="importance" class="select">
	          						<c:choose>
	          							<c:when test="${result.importance eq '0' }">
	          								<option value="2" ><spring:message code="ezCircular.t117"/></option>
			          						<option value="1" ><spring:message code="ezCircular.t116"/></option>
		   									<option value="0" selected><spring:message code="ezCircular.t185"/></option>
	          							</c:when>
	          							<c:when test="${result.importance eq '1' }">
	          								<option value="2" ><spring:message code="ezCircular.t117"/></option>
	          								<option value="1" selected><spring:message code="ezCircular.t116"/></option>
   											<option value="0" ><spring:message code="ezCircular.t185"/></option>
	          							</c:when>
	          							<c:when test="${result.importance eq '2' }">
	          								<option value="2" selected><spring:message code="ezCircular.t117"/></option>
			          						<option value="1" ><spring:message code="ezCircular.t116"/></option>
		   									<option value="0" ><spring:message code="ezCircular.t185"/></option>
	          							</c:when>
	          							<c:otherwise>
	          								<option value="2" ><spring:message code="ezCircular.t117"/></option>
			          						<option value="1" selected><spring:message code="ezCircular.t116"/></option>
		   									<option value="0" ><spring:message code="ezCircular.t185"/></option>
	          							</c:otherwise>
	          						</c:choose>
   								</select>	
	          				</td>
	       					<th style="width:40px;"><spring:message code="ezCircular.t118"/></th>
	       					<td style="width:200px;">
								<c:choose>
		                			<c:when test="${result.option eq '1'}">
		                				<input type="checkbox" id="option1" name="chkList" checked><label for="option1"><spring:message code='ezCircular.t119'/></label>
		                				<input type="checkbox" id="option2" name="chkList"><label for="option2"><spring:message code="ezCircular.t120"/></label>
		                			</c:when>
		                			<c:when test="${result.option eq '2'}">
		                				<input type="checkbox" id="option1" name="chkList"/><label for="option1"><spring:message code="ezCircular.t119"/></label>
		                				<input type="checkbox" id="option2" name="chkList" checked/><label for="option2"><spring:message code="ezCircular.t120"/></label>
		                			</c:when>
		                			<c:when test="${result.option eq '3'}">
		                				<input type="checkbox" id="option1" name="chkList" checked/><label for="option1"><spring:message code="ezCircular.t119"/></label>
										<input type="checkbox" id="option2" name="chkList" checked/><label for="option2"><spring:message code="ezCircular.t120"/></label>
		                			</c:when>
		                			<c:otherwise>
		                				<input type="checkbox" id="option1" name="chkList"/><label for="option1"><spring:message code="ezCircular.t119"/></label>
										<input type="checkbox" id="option2" name="chkList"/><label for="option2"><spring:message code="ezCircular.t120"/></label>
		                			</c:otherwise>
		                		</c:choose>					
	         				</td>
	        			</tr>
						<tr>
	           				<th rowspan="2" style="border-bottom:0px"><spring:message code="ezCircular.t34"/></th>
	           				<td colspan="7" id ="itemList" style="padding-left:2px;">
	           					<a class="imgbtn imgbck"><span id="clickbtn" onclick="_manage_attendant()"><spring:message code="ezCircular.t39"/></span></a>
	           				</td>
						</tr>
						<tr>
	         				<td colspan="3" id ="itemList" style="border-bottom:0px">
	         					<input name="Input" id="receiverinput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box; display:none;" onkeyup="return on_keydown(event)">
	         					<div id="receiverlist" style="OVERFLOW-Y: auto; HEIGHT: 28px; display: inline;"></div>
	         					<div id="receiverlist2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	         					<div id="receiverID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	         				</td>
	       				</tr>
      				</table>
      			</td>
  			</tr>
  			<tr>
	  			<td id="EdtorSize" style="vertical-align:top;height:100%;">
		  			<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 97%; width: 100%; overflow: auto;border-top:0px"></iframe>
      			</td>
  			</tr>
  			<tr>
  			<!-- 2018-02-13 주홍선 mode와 circularID 항상 보내도록 수정 -->
  				<td>
   					<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="<c:url value='/ezCircular/dragAndDrop.do?mode=${mode}&circularID=${circularID}'/>"></iframe>
  				</td>
  			</tr>
		</table>
		<div id="baseColor" style="background-color: #fff9e5; border-bottom: gray 1px inset; border-left: gray 1px inset; border-right: gray 1px inset; border-top: gray 1px inset; display: none; position: absolute">
  			<table style="height:0px; width:190px; border:0; border-collapse:collapse; border-spacing:0; padding:0px" >
    			<tr>
      				<td style="width:190px">
      					<table id="baseColorTable" style="border:0px; border-collapse:collapse; border-spacing:1px; padding:0px; border-right-color:#999999; width:220px" onclick="baseColorTable_onClick()">
          					<tr>
            					<td style="width:50px; background-color:#000000; height:12px" title="#000000"></td>
            					<td style="width:50px; background-color:#808080" title="#808080"></td>
            					<td style="width:50px; background-color:#800000" title="#800000"></td>
            					<td style="width:50px; background-color:#808000" title="#808000"></td>
            					<td style="width:50px; background-color:#008000" title="#008000"></td>
            					<td style="width:50px; background-color:#008080" title="#008080"></td>
            					<td style="width:50px; background-color:#000080" title="#000080"></td>
            					<td style="width:50px; background-color:#800080" title="#800080"></td>
          					</tr>
          					<tr>
            					<td style="width:50px; background-color:#ffffff; height:12px" title="#ffffff"></td>
            					<td style="width:50px; background-color:#C0C0C0" title="#C0C0C0"></td>
            					<td style="width:50px; background-color:#FF0000" title="#FF0000"></td>
            					<td style="width:50px; background-color:#FFFF00" title="#FFFF00"></td>
            					<td style="width:50px; background-color:#00FF00" title="#00FF00"></td>
            					<td style="width:50px; background-color:#00FFFF" title="#00FFFF"></td>
            					<td style="width:50px; background-color:#0000FF" title="#0000FF"></td>
            					<td style="width:50px; background-color:#FF00FF" title="#FF00FF"></td>
          					</tr>
        				</table>
        			</td>
    			</tr>
  			</table>
		</div>

		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
	</body>
</html>