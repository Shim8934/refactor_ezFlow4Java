<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t133' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style type="text/css">
			.tagColor {
				width: 20px;
				height: 20px;
				float: left;
				margin-top: 1.5px;
				margin-left: 2px;
			}
			
			.tagText {
				width: 60px;
				height: 20px;
				float: left;
				margin-top: 3px;
				margin-left: 5px;
				font-size: 13px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>	
	    <script type="text/javascript">
		    var defaultview = "<c:out value='${scheduleConfigVO.defaultView}'/>";
			var startday = "<c:out value='${scheduleConfigVO.startDay}'/>";
			var starttime = "<c:out value='${scheduleConfigVO.startTime}'/>";
			var endtime = "<c:out value='${scheduleConfigVO.endTime}'/>";
			var autodelete = "<c:out value='${scheduleConfigVO.isAutoDelete}'/>";
			var reminderTime = "<c:out value='${scheduleConfigVO.reminderTime}'/>";
			var primary = "<c:out value='${lang}'/>";
			var defaultviewcheck = "<c:out value='${scheduleConfigVO.defaultViewCheck}'/>";
			var jsonPersonalScheConfigList = "<c:out value='${jsonPersonalScheConfigList}'/>";
			
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (defaultview != "") {
		            document.getElementById("DefaultViewSelect").value = defaultview;
		            document.getElementById("StartDaySelect").value = startday;
		            document.getElementById("StartTimeSelect").value = starttime;
		            document.getElementById("EndTimeSelect").value = endtime;
	
		            if (autodelete != "0") {
		                document.getElementById("CheckDelete").checked = false;
		                document.getElementById("TextDelete").value = autodelete;
		            }
		        }
		        
		        if (reminderTime != "") {
		        	document.getElementById("reminderTime").value = reminderTime;
		        }
		        
		        if (defaultviewcheck != "N") {
		        	$('#defaultViewCheckBox').attr('checked', 'checked');
		        }
		        
		        var personalScheConfigList = JSON.parse(decodeHtml(jsonPersonalScheConfigList));
		        
				for (var i = 0; i < personalScheConfigList.length; i++) {
					try {
						var config = personalScheConfigList[i];
						var scheduleType = config.scheduleType ? config.scheduleType : 1;
						var relatedId = config.relatedId ? config.relatedId : config.userId;
						var tagColor = config.tagColor ? config.tagColor : null;

						// 기본 셀렉터 구성 (색상 태그, 색상 텍스트)
						var selector = "div[data-schedule-type='" + scheduleType + "']";

						// scheduleType이 1(개인), 4(협업)가 아닌 경우에는 relatedID가 필요함
				    	if (scheduleType !== 1 && scheduleType !== 4) {
				    		selector += "[data-related-id='" + relatedId + "']";
				    	}

						var targetElem = document.querySelector(selector);

						if (!targetElem || !tagColor) {
							continue;
						}

						targetElem.style.backgroundColor = tagColor;
						targetElem.nextElementSibling && (targetElem.nextElementSibling.innerHTML = tagColor);

					} catch (e) {
						console.log("Error at index", i, e);
    					continue;
					}
				}
			}
					
		    function CheckDeleteClick() {
		        if (document.getElementById("CheckDelete").checked == true) {
		            document.getElementById("TextDelete").value = "";
		            document.getElementById("TextDelete").readOnly = true;
		        }
		        else
		            document.getElementById("TextDelete").readOnly = false;
		    }
					
		    function save_info() {
		        if (document.getElementById("TextDelete").value != "" && parseInt(document.getElementById("TextDelete").value) != document.getElementById("TextDelete").value ||
		            parseInt(document.getElementById("TextDelete").value) > 5000) {
			            alert("<spring:message code='ezSchedule.t134' />");
			            document.getElementById("TextDelete").focus();
			            return;
		        }
	
		        if (document.getElementById("StartTimeSelect").selectedIndex >= document.getElementById("EndTimeSelect").selectedIndex) {
		            alert("<spring:message code='ezSchedule.t135' />");
		            return;
		        }	      
		        
		        var listSecretary = new Array();		        
                var count = 0;		        
		        
		        for (var i = 0; i < document.getElementById("ListSecretary").length; i++) {		            
		            var data = new Object();
                    data.secretaryID = document.getElementById("ListSecretary").options[i].value;
                    data.secretaryName = getNodeText(document.getElementById("ListSecretary").options[i]);                     
                    
                    listSecretary.push(data);
                    count++;
		        }		        
		        
		        // 2025-04-28 조수빈 - 사용자의 일정 요소 색상 정보
		        var tagColorList = new Array();
		        var tagElems = document.querySelectorAll(".tagColor");
		        
		        for (var i = 0; i < tagElems.length; i++) {
		        	var data = new Object();
		        	data.scheduleType = tagElems[i].dataset.scheduleType;
		        	data.relatedId = tagElems[i].dataset.relatedId;
		        	data.tagColor = tagElems[i].nextElementSibling.innerHTML;
		        	
		        	tagColorList.push(data);
		        }
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "html",				    		
		    		async : false,
		    		data : {
		    			DEFAULTVIEW : document.getElementById("DefaultViewSelect").value,
		    			STARTDAY : document.getElementById("StartDaySelect").value,
		    			STARTTIME : document.getElementById("StartTimeSelect").value,
		    			ENDTIME : document.getElementById("EndTimeSelect").value,
		    			AUTODELETE : (document.getElementById("TextDelete").value == "" ? "0" : document.getElementById("TextDelete").value),
		    			DISPLAYNAME : "<c:out value='${displayName1}'/>",
		    			DISPLAYNAME2 : "<c:out value='${displayName2}'/>",
		    			LISTSECRETARY : JSON.stringify(listSecretary),
		    			REMINDERTIME : document.getElementById("reminderTime").value,
		    			DEFAULTVIEWCHECKBOX : $("#defaultViewCheckBox").is(':checked'),
		    			tagColorList : JSON.stringify(tagColorList)
		    		},
		    		url : "/ezSchedule/scheduleSaveConfig.do",
		    		success: function(text){
		    			alert("<spring:message code='ezSchedule.t137' />");		    
		    			parent.parent.frames['left'].location = "/ezSchedule/scheduleLeft.do?funCode=11";
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.t136' />");
		    		}
		        });		
		        try {
		            if (parent.parent.frames["left"].CalendarMini != undefined)		            	
		                parent.parent.frames["left"].location = "/ezSchedule/scheduleLeft.do?funCode=11";		            	    	
		        } catch (e) { }
		    }
					
		    var schedule_select_attendant_dialogArguments = new Array();
		    function ModifySecretary() {
		        var secretary = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };
	
		        for (var i = 0; i < document.getElementById("ListSecretary").length; i++) {
		            secretary["id"][i] = document.getElementById("ListSecretary").options[i].value;
		            secretary["name"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "name");
		            secretary["name1"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "name");
		            secretary["name2"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "name2");
		            secretary["deptname"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "deptname");
		            secretary["deptname2"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "deptname");
		            secretary["email"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "email");
		        }
		        schedule_select_attendant_dialogArguments[0] = secretary;
		        schedule_select_attendant_dialogArguments[1] = ModifySecretary_Complete;
		        var OpenWin = window.open("/ezSchedule/scheduleSelectAttendant.do?gubun=config&title=" + encodeURI("<spring:message code='ezSchedule.t138' />"), "schedule_group_write", GetOpenWindowfeature(980, 670));
		        try { OpenWin.focus(); } catch (e) { }
		    }
	
		    function ModifySecretary_Complete(rtn) {
		        if (typeof (rtn) != "undefined") {
		            var length = document.getElementById("ListSecretary").length;
		            for (var i = 0; i < length; i++)
		                document.getElementById("ListSecretary").options[0] = null;
	
		            for (var i = 0; i < rtn["id"].length; i++) {
		                var lastindex = document.getElementById("ListSecretary").length;
		                var newoption = new Option(primary == 1 ? rtn["name"][i] : rtn["name2"][i], rtn["id"][i]);
		                document.getElementById("ListSecretary").options[lastindex] = newoption;
		                newoption.setAttribute("name", rtn["name"][i]);
		                newoption.setAttribute("name2", rtn["name2"][i]);
		                newoption.setAttribute("deptname", rtn["deptname"][i]);
		                newoption.setAttribute("deptname2", rtn["deptname2"][i]);
		            }
		            
		            //2018-08-10 김보미 - 비서가 없을 경우 dropbox가 내려오지 않도록 변경
		            if (rtn["id"].length > 0) {
		            	document.getElementById("ListSecretary").disabled = false;
		            } else {
		            	document.getElementById("ListSecretary").disabled = true;
		            }
		        }
		    }
			
			//개인 일정 색상 선택(실습)
			function select_personalcolor(type, relatedID) {
		    	var selector = "div[data-schedule-type='" + type + "']";
		    	
		    	if (type !== 1 && type !== 4) {
		    		selector += "[data-related-id='" + relatedID + "']";
		    	}
				
				var color = document.querySelector(selector).nextElementSibling.innerText;
				document.getElementById("iFrameLayer").src = "/ezSchedule/scheduleSelectColor.do?type="+ type + "&relatedID=" + encodeURIComponent(relatedID) + "&color=" + encodeURIComponent(color);
				document.getElementById("iFramePanel").style.top = "10px";
				document.getElementById("iFramePanel").style.left = "530px";
				document.getElementById("iFramePanel").style.height = "300px";
				document.getElementById("iFrameLayer").style.width = "360px";
				document.getElementById("iFrameLayer").style.height = "300px";
				document.getElementById("iFramePanel").style.display = "";
			}
		</script>
	</head>
	<body style="margin-left:10px">
		<form method="post">
		<br />   
			<table class="content" style="width:500px;">
		    	<tr>
		      		<th><spring:message code='ezSchedule.t139' /></th>
		      		<td>
		      			<select name="DefaultViewSelect" id="DefaultViewSelect" style="width:65px">
		          			<option value="0"><spring:message code='ezSchedule.t140' /></option>
		          			<option value="1"><spring:message code='ezSchedule.t141' /></option>
		          			<option value="2" selected><spring:message code='ezSchedule.t142' /></option>
		        		</select>
		      			<input type="checkbox" id="defaultViewCheckBox" name="defaultViewCheckBox"><spring:message code="ezSchedule.t402" /></input>
		      		</td>
		    	</tr>
		    	<tr>
		      		<th><spring:message code='ezSchedule.t143' /></th>
		      		<td>
		      			<select name="StartDaySelect" id="StartDaySelect" style="width:65px">
		          			<option selected value="7"><spring:message code='ezSchedule.t395' /></option>
		          			<option value="1"><spring:message code='ezSchedule.t396' /></option>
		        		</select>
		      		</td>
		    	</tr>
		    	<tr>
		      		<th><spring:message code='ezSchedule.t149' /></th>
		      		<td>
		      			<select name="StartTimeSelect" id="StartTimeSelect" style="width:65px">
			          		<option value="0">00:00</option>
					        <option value="60">01:00</option>
					        <option value="120">02:00</option>
					        <option value="180">03:00</option>
					        <option value="240">04:00</option>
					        <option value="300">05:00</option>
					        <option value="360">06:00</option>
					        <option value="420">07:00</option>
					        <option value="480">08:00</option>
					        <option value="540" selected>09:00</option>
					        <option value="600">10:00</option>
					        <option value="660">11:00</option>
					        <option value="720">12:00</option>
					        <option value="780">13:00</option>
					        <option value="840">14:00</option>
					        <option value="900">15:00</option>
					        <option value="960">16:00</option>
					        <option value="1020">17:00</option>
					        <option value="1080">18:00</option>
					        <option value="1140">19:00</option>
					        <option value="1200">20:00</option>
					        <option value="1260">21:00</option>
					        <option value="1320">22:00</option>
					        <option value="1380">23:00</option>
			        	</select>
		       			<spring:message code='ezSchedule.t150' />
				        <select name="EndTimeSelect" id="EndTimeSelect" style="width:65px">
					         <option value="0">00:00</option>
					         <option value="60">01:00</option>
					         <option value="120">02:00</option>
					         <option value="180">03:00</option>
					         <option value="240">04:00</option>
					         <option value="300">05:00</option>
					         <option value="360">06:00</option>
					         <option value="420">07:00</option>
					         <option value="480">08:00</option>
					         <option value="540">09:00</option>
					         <option value="600">10:00</option>
					         <option value="660">11:00</option>
					         <option value="720">12:00</option>
					         <option value="780">13:00</option>
					         <option value="840">14:00</option>
					         <option value="900">15:00</option>
					         <option value="960">16:00</option>
					         <option value="1020">17:00</option>
					         <option value="1080" selected>18:00</option>
					         <option value="1140">19:00</option>
					         <option value="1200">20:00</option>
					         <option value="1260">21:00</option>
					         <option value="1320">22:00</option>
					         <option value="1380">23:00</option>
				        </select>
				        <spring:message code='ezSchedule.t151' />
					</td>
				</tr>
			    <tr>
			    	<th><spring:message code='ezSchedule.t152' /></th>
			      	<td>
			      	<!-- 2018-08-06 김보미 - 셀렉트박스, 버튼 가운데로 위치 조정 -->		
<!-- 			      		<select name="ListSecretary" id="ListSecretary" style="width:85px"> -->
<%-- 			      			<c:forEach var="item" items="${selectList}"> --%>
<%-- 			      				<option value="${item.cn}" name2="${item.displayName2}" deptname="${item.description}" deptname2="${item.description2}" email="${item.mail}"> --%>
<%-- 			      					${item.displayName} --%>
<!-- 			      				</option> -->
<%-- 			      			</c:forEach> --%>
<!-- 			      		</select>			      		 -->
<%-- 			        	<a class="imgbtn imgbck"><span onClick="ModifySecretary()"><spring:message code='ezSchedule.t153' /></span></a> --%>
						<div style='height: 75%;'>
						<!-- 2018-08-10 김보미 - 비서가 없을 경우 dropbox가 내려오지 않도록 변경 -->
 				      	<%--<select name="ListSecretary" id="ListSecretary" style="width:85px; margin-top: 1px;" > --%>
				      		<select name="ListSecretary" id="ListSecretary" style="width:85px; margin-top: -1px;" <c:if test='${selectList eq null || selectList eq "[]"}'> disabled </c:if>>
				      			<c:forEach var="item" items="${selectList}">
				      				<option value="${item.cn}" name="${item.displayName}" name2="${item.displayName2}" deptname="${item.description}" deptname2="${item.description2}" email="${item.mail}">
				      					<c:if test="${lang == 1}">
				      						${item.displayName}
				      					</c:if>
				      					<c:if test="${lang != 1}">
				      						${item.displayName2}
				      					</c:if>
				      				</option>
				      			</c:forEach>
				      		</select>			      		
				        	<a class="imgbtn imgbck" style="margin-top: -1px !important; height: 22px"><span onClick="ModifySecretary()"><spring:message code='ezSchedule.t153' /></span></a>
			        	</div>
			        </td>
			    </tr>
			    <!-- 2023-08-25 한태훈 - 미리알림 추가 -->
			    <tr>
			    	<th><spring:message code='ezSchedule.hth01' /></th>
			    	<td>
			    		<select name="reminderTime" id="reminderTime">
			    			<option value="0"><spring:message code='ezSchedule.t404' /></option>
			    			<option value="30">30<spring:message code='ezSchedule.hth02' /></option>
			    			<option value="60">1<spring:message code='ezSchedule.hth03' /></option>
			    			<option value="120">2<spring:message code='ezSchedule.hth04' /></option>
			    			<option value="180">3<spring:message code='ezSchedule.hth04' /></option>
			    			<option value="360">6<spring:message code='ezSchedule.hth04' /></option>
			    			<option value="720">12<spring:message code='ezSchedule.hth04' /></option>
			    			<option value="1440"><spring:message code='ezSchedule.hth09' /></option>
			    		</select>
			    	</td>
			    </tr>
			    <tr>  
   			    	<!--<th><spring:message code='ezSchedule.hth01' /></th>-->
			    	<th><spring:message code='ezSchedule.color01' /></th>
			    	<td>
			    		<div class="tagColor" style="background:#018AF9;" data-schedule-type="1" data-related-id="<c:out value='${loginVO.id}'/>"></div>
			      		<div class="tagText">#018AF9</div>
			    		<a class="imgbtn" onclick="select_personalcolor('1', '<c:out value='${loginVO.id}'/>')" style="float: left;"><span ><spring:message code='ezSchedule.csj02' /></span></a>
			    	</td>
			    </tr>
			    <tr>
			    	<th><spring:message code='ezSchedule.color02' /></th>
			    	<td>
			    		<div class="tagColor" style="background-color:#01B33F;" data-schedule-type="2" data-related-id="<c:out value='${loginVO.deptID}'/>"></div>
						<div class="tagText">#01B33F</div>
			    		<a class="imgbtn" onclick="select_personalcolor('2', '<c:out value='${loginVO.deptID}'/>')" style="float: left;"><span ><spring:message code='ezSchedule.csj02' /></span></a>
			    	</td>
			    </tr>
				<c:if test='${!empty scheCum}'>
					<c:forEach var="cum" items="${scheCum}">
						<c:if test="${cum.deptId ne loginVO.deptID}">
							<tr>
						    	<th><spring:message code='ezSchedule.color02' />-${cum.titleName}</th>
						    	<td>
						    		<div class="tagColor" style="background-color:#01B33F;" data-schedule-type="2" data-related-id="<c:out value='${cum.deptId}'/>"></div>
									<div class="tagText">#01B33F</div>
						    		<a class="imgbtn" onclick="select_personalcolor('2', '${cum.deptId}')" style="float: left;"><span ><spring:message code='ezSchedule.csj02' /></span></a>
						    	</td>
						    </tr>
						</c:if>
					</c:forEach>
				</c:if>
			    <tr>
			    	<th><spring:message code='ezSchedule.color03' /></th>
			    	<td>
			    		<div class="tagColor" style="background:#FE1C71;" data-schedule-type="3" data-related-id="<c:out value='${loginVO.companyID}'/>"></div>
			      		<div class="tagText">#FE1C71</div>
			      		<a class="imgbtn" onclick="select_personalcolor('3','<c:out value='${loginVO.companyID}'/>')" style="float: left;"><span ><spring:message code='ezSchedule.csj02' /></span></a>
			    	</td>
			    </tr>
		    	<tr style="display:none"> 
		      		<th><spring:message code='ezSchedule.t154' /></th>
		      		<td>
		      			<input type="text" name="TextDelete" id="TextDelete" value="" size="8" readonly ="true" />
		        		<spring:message code='ezSchedule.t155' />
		        		<input type="checkbox" id="CheckDelete" value="radiobutton" onClick="CheckDeleteClick()" checked />
		        		<spring:message code='ezSchedule.t156' />
		        	</td>
		    	</tr>
		  	</table>
		  	<div align="center" style="width:450px;">
		  		<div class="btnpositionJsp">
		    		<a class="imgbtn" onClick="save_info()"><span><spring:message code='ezSchedule.t157' /></span></a>
		    	</div>	
		    	<%-- <a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezSchedule.t5' /></span></a> --%>
		  	</div>
		</form>
		<div style="width: 100%; height: calc(100% - 85px); position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: 3px solid black;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>