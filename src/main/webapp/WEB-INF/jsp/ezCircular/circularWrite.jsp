<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code="ezCircular.t55"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />
		<script type="text/javascript" src="<spring:message code="ezSchedule.e1"/>"></script>
		<script type="text/javascript" src="<spring:message code='ezCircular.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circular_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezBoard/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/ezBoard/AttachItem_CK.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		
		<script type="text/javascript">
	    	var msgRtn = "";
	    	var mode = "${mode}";
	    	var oldCircularID = "${circularID}";
	    	var AttachLimit = 5;
	    	var userID = "${userID}";
	    	var userName = "${userName}";
	    	var userName2 = "${userName2}";
	    	var userMyID = "${userMyID}";
	    	var userMyName = "${userMyName}";
	    	var userMyName2 = "${userMyName2}";
	    	var listSize = "${listSize}";
	    	
	    	if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
	        	}
	    	}

	    	window.onbeforeunload = function () {
	    		btn_Close();
	    	} 

		    window.onload = function () {
				if (listSize != 0) {
		        	document.getElementById("title").value = '${result.title}';
		        	document.getElementById("receiverlist").innerHTML = "${userName}";
		        	document.getElementById("receiverlist2").innerHTML = "${userName2}";
		        	document.getElementById("receiverID").innerHTML = "${userID}";

		        	//hasFie구분
		        	setAttachFileInfo("${strAttach}");
			        
		        	g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
		        	
		        	var list = userID.split(", ");
		        	var nameList = userName.split(", ");
		        	var nameList2 = userName2.split(", ");

		        	// circularID 값이 있으면 작성자는 회람자로 무조건 추가되기때문에 -1
		        	if (oldCircularID != 0) {
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

				for (var i = 0; i < filelist.length - 1; i++) {	    
					if (i == 0) {
						fileList = GetAttribute(filelist[i + 1], "data2");
					} else {
						fileList += "," + GetAttribute(filelist[i + 1], "data2");
            		}
				}
				
				var receiverList = document.getElementById("receiverlist").innerHTML;
				var receiverList2 = document.getElementById("receiverlist2").innerHTML;
				var receiverID = document.getElementById("receiverID").innerHTML;

				if (receiverList.indexOf(userMyName) == -1) {
					receiverList += ", " + userMyName;
					receiverList2 += ", " + userMyName2;
					receiverID += ", " + userMyID;
				}

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
	                			fileList : fileList,
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

					for (var i = 0; i < filelist.length - 1; i++) {	    
						if (i == 0) {
							fileList = GetAttribute(filelist[i + 1], "data2");
						} else {
							fileList += "," + GetAttribute(filelist[i + 1], "data2");
	            		}
					}
					
					var receiverList = document.getElementById("receiverlist").innerHTML;
					var receiverList2 = document.getElementById("receiverlist2").innerHTML;
					var receiverID = document.getElementById("receiverID").innerHTML;

					if (receiverList == "") {
						receiverList = userMyName;
						receiverList2 = userMyName2;
						receiverID = userMyID;
					}

					if (receiverList.indexOf(userMyName) == -1) {
						receiverList += ", " + userMyName;
						receiverList2 += ", " + userMyName2;
						receiverID += ", " + userMyID;
					}

		    		$.ajax ({
		 			   	url : '/ezCircular/circularSaveTemp.do?mode=temp',
		                type : 'POST',
		                dataType : 'text',
		                data : {	title : document.getElementById("title").value,
		                			importance : document.getElementById("importance").value,
		                			option : option,
		                			receiverList : receiverList,
		                			receiverList2 : receiverList2,
		                			receiverID : receiverID,
		                			circularID : circularID,
		                			content : content,
		                			fileList : fileList
		                },  
		                cache: false,
		                success: function(data) {	   
							window.opener.getLeftCount();
							window.opener.refresh_onclick();
							window.close();
		                },
		                error: function() {
		                	alert("<spring:message code='ezCircular.t102'/>");	
		                }
		 			});
	    		}
	    	}

			function Editor_Complete() {
    	    	message.SetEditorContent(sigBody.innerHTML);
    	    }
			
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

				$.ajax({
					async : false,
					url : '/ezCircular/tempUploadFileDelete.do',
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
	
	<xmp id="sigBody" style="display: none;">${result.content}</xmp>
	
	<body id="mainbodytag" class="popup" style="height: 100%; overflow: hidden;">
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
		          					<li><span onClick="btn_Save('${mode}')"><spring:message code="ezCircular.t55"/></span></li>	
		          					<li><span onClick="btn_TempSave()"><spring:message code="ezCircular.t71"/></span></li>       						
        						</c:otherwise>
        					</c:choose>
        				</ul>
      				</div>
      				<div id="close">
        				<ul>
          					<li><span onClick="btn_Close()"><spring:message code="ezCircular.t84"/></span></li>
        				</ul>
      				</div>
      				<table class="content" style="width:100%;">
        				<tr>
          					<th style="width:200px;"><spring:message code="ezCircular.t32"/></th>
          					<td colspan="3" style="width:100%"><input type="text" id="title" style="width:100%"></td>
        				</tr>
	        			<tr>
	          				<th><spring:message code="ezCircular.t115"/></th>
	          				<td id="Td_StartDate" style="overflow:hidden; width:200px;">
	          					<select id="importance" class="select">
	          						<option value="0" <c:if test="${result.importance eq '0'}">selected</c:if>><spring:message code="ezCircular.t116"/></option>
   									<option value="1" <c:if test="${result.importance eq '1'}">selected</c:if>><spring:message code="ezCircular.t117"/></option>
   								</select>	
	          				</td>
	       					<th style="width:40px;"><spring:message code="ezCircular.t118"/></th>
	       					<td style="width:200px;">
								<c:choose>
		                			<c:when test="${result.option eq '1'}">
		                				<input type="checkbox" id="option1" name="chkList" checked/><spring:message code="ezCircular.t119"/>
		                				<input type="checkbox" id="option2" name="chkList"/><spring:message code="ezCircular.t120"/>
		                			</c:when>
		                			<c:when test="${result.option eq '2'}">
		                				<input type="checkbox" id="option1" name="chkList"/><spring:message code="ezCircular.t119"/>
		                				<input type="checkbox" id="option2" name="chkList" checked/><spring:message code="ezCircular.t120"/>
		                			</c:when>
		                			<c:when test="${result.option eq '3'}">
		                				<input type="checkbox" id="option1" name="chkList" checked/><spring:message code="ezCircular.t119"/>
										<input type="checkbox" id="option2" name="chkList" checked/><spring:message code="ezCircular.t120"/>
		                			</c:when>
		                			<c:otherwise>
		                				<input type="checkbox" id="option1" name="chkList"/><spring:message code="ezCircular.t119"/>
										<input type="checkbox" id="option2" name="chkList"/><spring:message code="ezCircular.t120"/>
		                			</c:otherwise>
		                		</c:choose>					
	         				</td>
	        			</tr>
						<tr>
	           				<th rowspan="2"><spring:message code="ezCircular.t34"/></th>
	           				<td colspan="7" id ="itemList" style="padding-left:4px;">
	           					<a class="imgbtn"><span id="clickbtn" onclick="_manage_attendant()"><spring:message code="ezCircular.t39"/></span></a>
	           				</td>
						</tr>
						<tr>
	         				<td colspan="3" id ="itemList">
	         					<input name="Input" id="receiverinput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box; display:none;" onkeyup="return on_keydown(event)">
	         					<div id="receiverlist" style="OVERFLOW-Y: auto; HEIGHT: 28px"></div>
	         					<div id="receiverlist2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	         					<div id="receiverID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	         				</td>
	       				</tr>
      				</table>
      			</td>
  			</tr>
  			<tr>
	  			<td id="EdtorSize" style="vertical-align:top;height:100%;">
		  			<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 97%; width: 99.7%; overflow: auto;border-top:0px"></iframe>
      			</td>
  			</tr>
  			<tr>
  				<td>
  					<c:choose>
   						<c:when test="${mode eq 'temp'}">
   							<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezCircular/dragAndDrop.do?mode=temp&circularID=${circularID}"></iframe>
   						</c:when>
   						<c:otherwise>
	       					<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezCircular/dragAndDrop.do"></iframe>	
   						</c:otherwise>
   					</c:choose>
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
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>