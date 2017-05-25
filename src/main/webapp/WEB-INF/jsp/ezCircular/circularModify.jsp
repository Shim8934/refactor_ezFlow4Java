<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title>회람수정</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
		<script type="text/javascript" src="<spring:message code="ezSchedule.e1"/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezResource/Schedule_cross.js"></script>
		<script type="text/javascript" src="/js/ezCircular/schedule_write_Cross.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
	    	var reFlag;
	    	var importanceVal;
	    	var g_fromStr		= "${fromStr}";
	    	var s_userID		= "${userInfo.id}";
	    	var ss_companyID	= "${userInfo.companyID}";
	    	var ss_deptNM		= "";
	    	var ss_ownerNM		= "";
	    	var lang = "${userInfo.primary}";
	    	
	    	if(lang == '2') {
	        	ss_deptNM		= "${userInfo.deptName2}"; 
	        	ss_ownerNM		= "${userInfo.displayName2}";
	    	} else  {
	        	ss_deptNM		= "${userInfo.deptName1}"; 
	        	ss_ownerNM		= "${userInfo.displayName1}";
	    	}
	    	
	    	var org_deptNM      = "${deptNm}";
	    	var org_ownerNM     = "${ownerNm}";
	    	var org_num			= "${num}";
	    	var org_ownerID		= "${ownerID}";
	    	var pnumVal			= "${pNum}";
	    	var writerIDVal		= "${writerID}";
	    	var cmd				= "${cmdStr}";
	    	var typeVal			= "${typeVal}";
	    	var startDateVal	= "${startDateVal}";
	    	var endDateVal		= "${endDateVal}";
	    	var gFlagVal		= "${gresFlag}";
	    	var uploadPath		= "${scheduleFilePath}";
	    	var org_companyID	= ss_companyID;
	    	var pAdminFg		= "${adminFg}";
	    	var nowDate         = "${nowDate}";
	    	var ApproveFlag     = "${approveFlag}";
	    	var SavedApproveFlag= "${saveApproveFlag}";
	    	var reFlagVal		= "${reFlag}";
	        var server_name = "${serverName}";
		    var allday_chk, onck = "1";	
	    	var sDT				="${startDateTime}";
	    	var eDT				="${endDateTime}";
	    	var flag = false;
	    	var startDateTimeRepeat = "${startDateTimeRepeat}";
	    	var endDateTimeRepeat = "${endDateTimeRepeat}";
	    	var brdName = "${brdName}";
	    	var resID = "${resID}";
	    	var ItemArray = new Array();
	    	var m_Arguments;
	    	var msgRtn = "";
	    	
	    	if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
	        	}
	    	}

		    window.onload = function () {
		        try {
	    	        m_Arguments = opener.schedule_add_ck_dialogArguments[0];
		       } catch (e) {
	            	try {
	            		m_Arguments = window.dialogArguments;
	            	} catch (e) {
	            		m_Arguments = parent.schedule_add_ck_dialogArguments[0];
		            }        
	    	    } 
	        	/* if (cmd == "mod") {
	        		document.getElementById("displayNM").innerHTML = "<a href=# onClick=MemberInfo_onClick('" + writerIDVal + "')>" + org_ownerNM + "</a> (" + org_deptNM + ")";	
	        	} else {
	        	document.getElementById("displayNM").innerHTML = "<a href=# onClick=MemberInfo_onClick('" + s_userID + "')>" + ss_ownerNM + "</a> (" + ss_deptNM + ")";
	        	} */
	            
	        	document.getElementById("title").value = "${result.title}";
	        	document.getElementById("receiverlist").innerHTML = "${listUser}";
	        	
		        var resultXML;
	    	    var xmlHttp = createXMLHttpRequest();
	        	var xmlpara = createXmlDom();
	        	var objNode;

	        	createNodeInsert(xmlpara, objNode, "PARAMETER");
	        	createNodeAndInsertText(xmlpara, objNode, "NUM", org_num);
	        	createNodeAndInsertText(xmlpara, objNode, "OWNERID", org_ownerID);
	        	createNodeAndInsertText(xmlpara, objNode, "GROUPID", "");
	        	createNodeAndInsertText(xmlpara, objNode, "companyID", org_companyID);

	        	if (document.getElementById("iReFlag").value == "1") {
	            	if (org_num != "" && org_ownerID != "") {
	                	xmlHttp.open("POST", "/ezResource/scheduleRepetitionProc.do?cmd=get", false);
	                	xmlHttp.send(xmlpara);

	                	resultXML = xmlHttp.responseXML;

	                	if (resultXML.xml != "") {
	                    	g_data["recurrence"] = getXmlString(resultXML);
	                	}
	            	}

	            	show_repetition_info();
	        	}

		        if (brdName != "" && resID  != "") {
		            ItemArray[0] = Array("${resID}");
	    	        ItemArray[1] = Array("${brdName}");

	        	    document.getElementById('itemList').innerHTML = "";
	            	document.getElementById('itemList').innerHTML = "${brdName}";
	        	}
		        
	        	if (cmd == "add") {
	            	var xmlHttp2 = createXMLHttpRequest();
	            	var xmlDoc2 = createXmlDom();
	
		            createNodeInsert(xmlDoc2, objNode, "PARAMETER");
	    	        createNodeAndInsertText(xmlDoc2, objNode, "RESID", "${resID}");

	        	    xmlHttp2.open("POST", "/ezResource/scheduleGetForm.do", false);
	            	xmlHttp2.send(xmlDoc2);

	            	result = xmlHttp2.responseText;

	            	if (result != "FALSE") {
	                	msgRtn = result;
	                	message.SetEditorContent(msgRtn);
	            	}
	        	}

	        	if (m_Arguments != undefined) {
	            	ItemArray[0] = m_Arguments[0];
	            	ItemArray[1] = m_Arguments[1];

		            document.getElementById('itemList').innerHTML = "";

		            for (var i = 0 ; i < ItemArray[0].length; i++) {
	                	if ((i + 1) < ItemArray[0].length) {
	                		document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i] + " ,  ";
	                	} else {
	                		document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i];
		                }	
		            }
		        }
		    }
			
		    window.onresize = function () {
		        document.getElementById("EdtorSize").style.height = document.body.clientHeight - 220 + "PX";
	    	}
		    
		    window.onunload = function () {
		        try {
		            m_Arguments = opener.schedule_add_ck_dialogArguments[0];
		            opener.close();
		        }
		        catch (e) {
		        }
		    }
		    
		    function DocumentComplete() {
		        //if (cmd == "mod") {
	    	        message.SetEditorContent(sigBody.innerHTML);
	        	//}

	        	/* if (cmd == "add") {
		            if (msgRtn != "") {
		                message.SetEditorContent(msgRtn);
	    	        }
		        } */
	    	}

	    	function FieldsAvailable() {
	    	}

	    	function MemberInfo_onClick(pSelUserID) {
	        	if (pSelUserID != "") {
		            var feature = GetOpenPosition(420, 438);
		            window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	    	    }
	    	}	

	    	function display_time_Unshow() {
		        allday_chk = document.getElementById("AllDay").value;

		        if (allday_chk == "on") {

	    	        if (onck == "1") {
	        	        document.getElementById("Stimepicker").style.display = "none";
	            	    document.getElementById("Etimepicker").style.display = "none";
	                	onck = "0";
	                	return;
	            	}

	            	if (onck == "0") {
		                document.getElementById("Stimepicker").style.display = "";
		                document.getElementById("Etimepicker").style.display = "";
	    	            onck = "1";
	        	        return;
	            	}
	        	}

	        	if (allday_chk == "") {
		            document.getElementById("Stimepicker").style.display = "";
		            document.getElementById("Etimepicker").style.display = "";
	    	        onck = "1";
	        	}
		    }

		    function keyword_onkeydown() {
	    	    if (event.keyCode == 13) {
	    	    	Entry_onKeydown();	
	    	    }
		        return true;
		    }

		    var schedule_add_select_cross_dialogArguments = new Array();
	    
	    	function Open_Select_Complete(retVal) {
	        	if (retVal == "close") {
	        	} else if (typeof (retVal) != "undefined" && retVal.length == 2) {
	            	ItemArray[0] = retVal[0];
	            	ItemArray[1] = retVal[1];

	            	document.getElementById('itemList').innerHTML = "";
	            	
	            	for (var i = 0 ; i < ItemArray[0].length ; i++) {
		                if ((i + 1) < ItemArray[0].length) {
		                	document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i] + " ,  ";	
		                } else {
	                		document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i];
	                	}
		            }
	        	}
	        	DivPopUpHidden();
	    	}
	    	//회람저장 눌렀을 시
        	var content = message.GetEditorContent();
			var option = 0;
			
			//댓글기능 사용할때
			$(':checkbox[id=optionRefly]:checked').each(function(){
				option = 0;	
			});
			
			//메일공지 사용할때
			$(':checkbox[id=optionMail]:checked').each(function(){
				option = 1;	
			});
			
			//댓글기능, 메일공지 둘 다 사용할 때
			if ($(':checkbox[name=chkList]:checked').length == 2) {
				option = 2;
			}
	    	
	    	function btn_Save() {
	    		$.ajax ({
	 			   	url : '/ezCircular/saveModifyCircular.do',
	                type : 'POST',
	                dataType : 'text',
	                data : {	title : document.getElementById("title").value,
	                			importance : document.getElementById("importance").value,
	                			//option : document.getElementById("option"),
	                			option : option,
	                			receiverList : document.getElementById("receiverlist").innerHTML,
	                			receiverID : document.getElementById("receiverID").innerHTML,
	                			circularId : "${circularID}"
	                },  
	                cache: false,
	                success: function(data) {	   
	             	  window.close();
	                }
	 			});
	    	}

	    	function window_onUnload() {
	        	if (m_Arguments == undefined) {
		            if (window.opener != null && g_fromStr == "schedule" && trim(s_userID) != "") {
		                window.opener.btnRefresh_onclick();
	    	        } else if (window.opener != null && g_fromStr == "schedule2" && trim(s_userID) != "") {
	                	window.opener.parent.main.document.location.reload();
	            	} else if (window.opener != null && g_fromStr == "frame" && trim(s_userID) != "") {
	                	window.opener.document.all.iframeWin2.document.location.reload();
	            	} else if (window.opener != null && g_fromStr == "frame2" && trim(s_userID) != "") {
	                	window.opener.document.all.iframeWin.document.location.reload();
	            	} else if (window.opener != null && g_fromStr == "todaySchedule" && trim(s_userID) != "") {
	                	window.opener.location.reload();
	            	}
	        	}
	    	}
	    	
	    	//파일업로드
    	    function returnvalue(strXML) {
	        var pAttachXml = loadXMLString(strXML);
	        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
	        var extFlag = false;        
	        for (var i = 0; i < nodes.length; i++) {
	            if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
	                if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
	                    alert(strLang6);
	                    return;
	                }
	                /* if (document.getElementById('mode').value == "PHOTO")
	                    document.getElementById('txtPhotoFile').value = getNodeText(GetChildNodes(nodes[i])[2]); */
	            }
	            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied")
	                extFlag = true;
	            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
	                alert(strLang8 + AttachLimit + "MB" + strLang9);
	                return;
	            }
	            else {
	                alert("<spring:message code='ezCommunity.lhj08'/>" + "\n\n" + result);
	            }
	        }
	        if (extFlag)
	            alert(strLang54);
	
	        if (dadiframe.document.getElementById("lstAttachLink") == null)
	            setTimeout(function () { AttachFileInfo(strXML); }, 500);
	        else
	            AttachFileInfo(strXML);
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
							<div id="menuTable1" >
	          					<li><span onClick="btn_Save()"> <spring:message code="ezResource.t185"/></span></li>
	          					<li><span onClick="btn_Save()"> 임시보관</span></li>
	          				</div>          
        				</ul>
      				</div>
      				<div id="close">
        				<ul>
          					<li><span onClick="window.close();"> <spring:message code="ezResource.t150"/></span></li>
        				</ul>
      				</div>
      				<table class="content" style="width:100%;">
        				<tr>
          					<th style="width:200px;">제목</th>
          					<td colspan="3" style="width:100%"><input type="text" id="title" style="width:700px"></td>
        				</tr>
						
	        			<tr id="tr_STime" ${strDspMod1}>
	          				<th> 중요도</th>
	          				<td width="100%" colspan="3" id="Td_StartDate" style="overflow:hidden;">
	          					<select id="importance" class="select">
	          						<option value="0" <c:if test="${result.importance eq '0'}">selected</c:if>>일반</option>
   									<option value="1" <c:if test="${result.importance eq '1'}">selected</c:if>>중요</option>
   								</select>	
	          				</td>
	        			</tr>
				        <tr>
	       					<th> 옵션</th>
	       					<td style="width:160px" colspan="3">
								<c:choose>
		                			<c:when test="${result.option eq '0'}">
		                				<input type="checkbox" id="option" checked onClick="display_time_Unshow()" />댓글기능 사용
		                				<input type="checkbox" id="AllDay" onClick="display_time_Unshow()" />메일공지 사용
		                			</c:when>
		                			<c:when test="${result.option eq '1'}">
		                			<input type="checkbox" id="option" onClick="display_time_Unshow()" />댓글기능 사용
		                				<input type="checkbox" id="AllDay" checked onClick="display_time_Unshow()" />메일공지 사용
		                			</c:when>
		                			<c:otherwise>
		                				<input type="checkbox" id="option" checked onClick="display_time_Unshow()" />댓글기능 사용
										<input type="checkbox" id="AllDay" checked onClick="display_time_Unshow()" />메일공지 사용
		                			</c:otherwise>
		                		</c:choose>   									
	         				</td>
       						<th style="display: none"> <spring:message code="ezResource.t217"/></th>
		           			<td style="display: none"><input type="checkbox" style="display: none" id="PublicFlag" checked /><spring:message code="ezResource.t217"/></td>
		           			<th style="display: none"> <spring:message code="ezResource.t218"/></th>
		           			<td style="display: none">
		           				<select id="characterID" name="select" class="select">
		               				<option value="0" selected>회람자</option>
		             			</select>          
		         			</td>
			     		</tr>
        
						<tr id="Span1">
	           				<th>
	           					회람자
	           				</th>
	           				<td colspan="7" id ="itemList" style="padding-left:4px;">
	           					<a class="imgbtn"><span id="clickbtn" onclick="manage_attendant()">선택</span></a>
	           				</td>
						</tr>
						<tr>
	         				<!-- <th>회람자목록</th> -->
	         				<td colspan="3" id ="itemList">
	         					<input name="Input" id="receiverinput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box; display:none;" onkeyup="return on_keydown(event)">
	         					<div id="receiverlist" style="OVERFLOW-Y: auto; HEIGHT: 17px"></div>
	         					<div id="receiverID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	         				</td>
	       				</tr>
      				</table>
      			</td>
  			</tr>
  			<tr>
	  			<td id="EdtorSize" style="vertical-align:top;height:100%;">
					<iframe id="Iframe1" class="viewbox" name="message" src="/ezResource/ckEditor.do" style="padding: 0; height: 97%; width: 99.7%; overflow: auto;border-top:0px"></iframe>
      			</td>
  			</tr>
  			<tr>
  				<td>
  					<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezBoard/dragAndDrop.do"></iframe>
  				</td>
  			</tr>
		</table>
		<div id="baseColor" style="background-color: #fff9e5; border-bottom: gray 1px inset; border-left: gray 1px inset; border-right: gray 1px inset; border-top: gray 1px inset;
		display: none; position: absolute">
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

	    <table id="printScreen" style="display: none;">
  			<tr style="text-align:center">
    			<td style="vertical-align:top">
    				<table style="width:100%; border:0px; padding:1px; border-collapse:collapse; border-spacing:0px; " class="content2">
	      				<tr style="height:25px"> 
        					<th style="padding-left:10px" width="80"><spring:message code="ezResource.t193"/></th> 
        					<td style="padding-left:10px"> <div id="printOwner"></div></td> 
      					</tr> 
      					<tr style="height:25px"> 
	        				<th style="padding-left:10px"><spring:message code="ezResource.t213"/></th> 
        					<td style="padding-left:10px"> <div id="printImportance"></div></td> 
      					</tr> 
      					<tr style="height:25px"> 
	        				<th style="padding-left:10px"><spring:message code="ezResource.t197"/></th> 
        					<td style="padding-left:10px"> <div id="printDate"></div></td> 
      					</tr> 
      					<tr style="height:25px"> 
	        				<th style="padding-left:10px"><spring:message code="ezResource.t224"/></th> 
        					<td style="padding-left:10px"> <div id="printTitle"></div></td> 
      					</tr> 
      					<tr> 
	        				<td colspan="2"><div align="left" id="printDocument" style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; WIDTH: 100%;  PADDING-TOP: 5px"></div></td> 
      					</tr> 
   					</table>
   				</td>
  			</tr>
		</table>
		<xmp id="xmpEntryEmailList" style="display: none;"> ${entryList}</xmp>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
    	<script type="text/javascript">
	       	//document.getElementById("EdtorSize").style.height = document.body.clientHeight - 220 + "PX";
	       	document.getElementById("EdtorSize").style.height = document.body.clientHeight - 380 + "PX";
    	</script>
	</body>
</html>