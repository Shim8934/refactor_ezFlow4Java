<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
		<script type="text/javascript" src="/js/ezLadder/string_component.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderSetting.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
		
		<script type="text/javascript">
			$(function() {
				ladder_set_init();
				
				$(window).resize(function() {
					ladder_window_resize();
				});
				
				$("#makeLad").on("click", function() {
					makeLadder();
				});
				$("#ladderPreList").on("click", function() {
					preLadderList();
				});
				$("#addAttendant").on("click", function() {
					_manage_attendant();
				});
				$("#inputAttendant").on("keyup", function(e) {
					if(e.keyCode == "13") {
						check_name();
					}
				});
				$(".ladderType").on("click", function() {
					$(".ladderType").removeClass("active");
					$(this).addClass("active");
				});
				$("#ladderSecret").on("click", function() {
					$("#ladderSecret").toggleClass("active");
				});
				$(document).on("click", "span.remove", function() {
					attendant_remove($(this).closest("li").index());
				});
				$("#slider-range-min").slider({ 
					range: "min",
					value: 0,
					min: 0,
					max: 0,
					slide: function( event, ui ) {
						$("#amount").text(ui.value);
					}
				});
				$("#amount").val($("#slider-range-min").slider("value"));
				$("#bmtest").on("click", function() { /* 즐겨찾기 테스트 버튼 */
					
					var flag = "delete";
					var ladderbmid = flag === "add" ? "0" : "106";
					var bmname = "수수ㅜㅅ수수저엉ㅇㅇㅇ제목제";
					var bmuserid = [];
					var bmusername = [];
					var bmusername2 = [];
					
					/* 즐겨찾기 조회 */
					$.ajax({
						type: "GET",
						url: "/ezLadder/getLadderBM.do",
						traditional: true,
						dataType: "json",
						data: { 
							ladderBmId: ""
						},
						success: function(result) {
							console.log(result);
						}
					});
					/* 즐겨찾기 추가,수정,삭제 */
					/* $.ajax({
						type: "POST",
						url: "/ezLadder/setLadderBM.do",
						traditional: true,
						dataType: "json",
						data: { 
							flag: flag,
							ladderBmId: ladderbmid,
							bmName: bmname,
							userIds: bmuserid,
							userNames: bmusername,
							userName2s: bmusername2
						},
						success: function(result) {
							console.log(result);
						}
					}); */
				});
				
			});
			
			function ladder_set_init() {
				$(".ladderType:eq(<c:out value='${ladType}' />)").addClass("active");
				ladder_window_resize();
			}
			
			var ladder_pre_set_dialogArguments = [];
			function preLadderList() {
				ladder_pre_set_dialogArguments[0] = "";
				ladder_pre_set_dialogArguments[1] = preLadderListComplete;
				
				GetOpenWindow("/ezLadder/ladderMain.do?mode=pre&currPage=1&searchSelect=none&searchInput=", "ladder_pre_set", 970, 680);
			}
			
			function preLadderListComplete(ladderInfo, lineInfo) {
				console.log(ladderInfo);
				console.log(lineInfo);
				
				$("#title").val(ladderInfo["title"]);
				$(".icondiv").removeClass("active");
				$(".ladderType:eq(" + ladderInfo["type"] + ")").addClass("active");
				if(ladderInfo["secretFlag"] === 1) {
					$("#ladderSecret").addClass("active");
				} 
				
				var len = lineInfo.length;
				var names = "";
				for(var i = 0; i < len; i++) {
					names += lineInfo[i]["userName"] + ",";
				}
				console.log(names);
				
			}
			
			/** g_attendant, g_item 현재 input box 정보로 셋팅 */
			function set_input_value() {
				var len = 0;
				var name = "";
				
				if(g_attendant !== null) {
					len = g_attendant["id"].length;
				}
				
				for(var i = 0; i < len; i++) {
					if(g_attendant["id"][i].substring(0, 15) === "anonyAttendant_") {
						name = $(".attendant:eq(" + i + ") input").val();
						g_attendant["name"][i] = name;
						g_attendant["name1"][i] = name;
						g_attendant["name2"][i] = name;						
					}
					g_item[i] = $("#itemList li:eq(" + i + ") input").val();
				}
				
			}

			function _manage_attendant() {
			    check_name("attendant");
			}

			/** 조직도 호출 */
			var g_item = [];
			var g_attendant = null;
			var ladder_select_attendant_dialogArguments = [];
			function manage_attendant_after() {
				set_input_value();
				
				ladder_select_attendant_dialogArguments[0] = g_attendant;
			    ladder_select_attendant_dialogArguments[1] = manage_attendant_Complete;
			    ladder_select_attendant_dialogArguments[2] = true;

			    GetOpenWindow("/ezLadder/setLadderAttendant.do", "ladder_select_attendant", 970, 680);
			}

			/** 참여자+아이템 추가 */
			function manage_attendant_Complete(attendList, attendType, arrayType) {
				console.log("manage attendant");
				var len = 0;
				var totallen = 0;
				var picsrc = "";
				
				if(typeof attendList !== "undefined") {
					if(arrayType === "xml") { // xml value
						console.log('xml');
						len = attendList.length;
						
						for(var i = 0; i < len; i++) {
							totallen = g_attendant["id"].length;
							picsrc = "/images/OrganTree/porson_noimg.gif";
							
							g_attendant["name"][totallen] = getNodeText(GetChildNodes(SelectNodes(attendList[i], "LISTVIEWDATA/ROWS/ROW")[0])[3]);
							g_attendant["name1"][totallen] = getNodeText(attendList[i].getElementsByTagName("DATA6")[0]);
							g_attendant["name2"][totallen] = getNodeText(attendList[i].getElementsByTagName("DATA7")[0]);
							
							if(attendType == "anonyuser") {
								g_attendant["id"][totallen] = "anonyAttendant_" + totallen;
								g_attendant["deptname"][totallen] = "";
								g_attendant["deptname1"][totallen] = "";
								g_attendant["deptname2"][totallen] = "";
								g_attendant["pic"][totallen] = "";
								$("#attendantList").append("<li class='attendant'><div><img src='" + picsrc + "' width='90px' height='90px' />" + 
										"<input type='text' class='input' value='" + g_attendant["name"][totallen] + "' />" + 
										"<span class='remove'>X</span></div></li>");
							} else {
								g_attendant["id"][totallen] = getNodeText(attendList[i].getElementsByTagName("DATA2")[0]);
								g_attendant["deptname"][totallen] = getNodeText(attendList[i].getElementsByTagName("DATA4")[0]);
								g_attendant["deptname1"][totallen] = getNodeText(attendList[i].getElementsByTagName("DATA8")[0]);
								g_attendant["deptname2"][totallen] = getNodeText(attendList[i].getElementsByTagName("DATA9")[0]);
								if(!!getNodeText(attendList[i].getElementsByTagName("DATA5")[0])) {
									g_attendant["pic"][totallen] = getNodeText(attendList[i].getElementsByTagName("DATA5")[0]);
									picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + g_attendant["pic"][totallen];
								} else {
									g_attendant["pic"][totallen] = "";
								}
								$("#attendantList").append("<li class='attendant'><div><img src='" + picsrc + "' width='90px' height='90px' />" +
										"<input type='text' disabled='disabled' class='input' value='" + g_attendant["name"][totallen] + "' />" + 
										"<span class='remove'>X</span></div></li>");
							}
							
							g_item[totallen] = "";
			            	$("#itemList").append("<li class='item'><input type='text' class='input' value='" + g_item[totallen] + "' /></li>");
						}
					} else{ // json value
						console.log('json');
						len = attendList["id"].length;
						itemlen = g_item.length;

						if(typeof g_attendant === "undefined" || ladder_select_attendant_dialogArguments[2]) {
							g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname1": new Array(), "deptname2": new Array(), "pic": new Array() };
							$("#attendantList").html("");
							$("#itemList").html("");
							ladder_select_attendant_dialogArguments[2] = false;
						}
						
						for(var i = 0; i < len; i++) {
							totallen = g_attendant["id"].length;
							picsrc = "/images/OrganTree/porson_noimg.gif";
							
							g_attendant["name"][totallen] = attendList["name"][i];
							g_attendant["name1"][totallen] = attendList["name1"][i];
							g_attendant["name2"][totallen] = attendList["name2"][i];
							
							if(attendList["id"][i].substring(0, 14) === "anonyAttendant") {
								g_attendant["id"][totallen] = "anonyAttendant_" + totallen;
								g_attendant["deptname"][totallen] = "";
								g_attendant["deptname1"][totallen] = "";
								g_attendant["deptname2"][totallen] = "";
								g_attendant["pic"][totallen] = "";
								$("#attendantList").append("<li class='attendant'><div><img src='" + picsrc + "' width='90px' height='90px' />" + 
										"<input type='text' class='input' value='" + g_attendant["name"][totallen] + "' />" + 
										"<span class='remove'>X</span></div></li>");
							} else {
								g_attendant["id"][totallen] = attendList["id"][i];
								g_attendant["deptname"][totallen] = attendList["deptname"][i];
								g_attendant["deptname1"][totallen] = attendList["deptname1"][i];;
								g_attendant["deptname2"][totallen] = attendList["deptname2"][i];
								if(!!attendList["pic"][i]) {
									g_attendant["pic"][totallen] = attendList["pic"][i];
									picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + g_attendant["pic"][totallen];
								} else {
									g_attendant["pic"][totallen] = "";
								}
								$("#attendantList").append("<li class='attendant'><div><img src='" + picsrc + "' width='90px' height='90px' />" + 
										"<input type='text' disabled='disabled' class='input' value='" + g_attendant["name"][totallen] + "' />" + 
										"<span class='remove'>X</span></div></li>");
							}
							
							if(totallen >= itemlen) {
								g_item[totallen] = "";
							}
			            	$("#itemList").append("<li class='item'><input type='text' class='input' value='" + g_item[totallen] + "' /></li>");
						}
					}
				}
				changeSliderValue();
				add_user_change_ulsize(g_attendant["id"].length);
				changeUser(len, "add");
				console.log(g_attendant);
			}

			/** 참여자 변경될때 슬라이더 바 조절 */
			var maxLine = 5;
			function changeSliderValue() { 
				var len = g_attendant["id"].length;
				if(len >= 2) {
					$("#slider-range-min").slider("option", "min", len);
					$("#slider-range-min").slider("option", "max", len * maxLine);
					$("#slider-range-min").slider("option", "value", Math.round(len * maxLine / 2));
				} else {
					$("#slider-range-min").slider("option", "max", 0);
					$("#slider-range-min").slider("option", "value", 0);
				}
				$("#amount").text($("#slider-range-min").slider("value"));
			}

			/** 참여자 삭제 */
			function attendant_remove(index) {
				g_attendant["id"].splice(index, 1);
				g_attendant["name"].splice(index, 1);
				g_attendant["name1"].splice(index, 1);
				g_attendant["name2"].splice(index, 1);
				g_attendant["deptname"].splice(index, 1);
				g_attendant["deptname1"].splice(index, 1);
				g_attendant["deptname2"].splice(index, 1);
				g_attendant["pic"].splice(index, 1);
				g_item.splice(index, 1);
				
				$(".attendant:eq(" + index + ")").remove();
				$(".item:eq(" + index + ")").remove();
				add_user_change_ulsize(g_attendant["id"].length);
				
				changeSliderValue()
				changeUser(1);
			}

			/** 이름 검색 */
			var ladder_check_Attendant_dialogArguments = [];
			var i = 0;
			var namelength = 0;
			var checknametype = "";
			var AttendantXML = [];
			var overlapAttendantXML = [];
			function check_name(type, inputname) {
			    if (type !== undefined)
			        checknametype = type;
			    else
			        checknametype = "";

			    var name = "";
			    if(document.getElementById("inputAttendant") !== null) {
				    name = document.getElementById("inputAttendant").value;
			    } else {
			    	name = inputname;
			    }
			    name = ReplaceText(name, ",", ";");
			    
			    var names = name.split(";");
			    namelength = names.length;
			    
			    for (; i < names.length; i++) {
			    	names[i] = TrimText(names[i]);
			    	
			    	if(names[i] == "") {
			    		continue;
			    	}
			    	
			    	var adCount = 0;        
			        var xmlDOM = createXmlDom();
			        
			        $.ajax({
			    		url : "/ezOrgan/getSearchList.do",
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		data : {
			    			search : "displayName::" + names[i],
			    			cell   : "company;description;title;displayName;mail",
			    			prop   : "displayName;description;extensionAttribute2",
			    			type   : "user"
			    		},
			    		success: function(xml){
			    			xmlDOM = loadXMLString(xml);
			                adCount = xmlDOM.getElementsByTagName("ROW").length;
			                console.log(xmlDOM);
			    		}    		
			    	});
			        
		            if (g_attendant == null) {
		            	g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname1": new Array(), "deptname2": new Array(), "pic": new Array() };
		            }
		            
		            var length = g_attendant["id"].length;
		            console.log(length);
			        if (adCount == 0) { // 검색결과 없을때 
			        	var anonyAttendant = { "id": [], "name": [], "deptname": [], "name1": [], "name2": [], "deptname1": [], "deptname2": [], "pic": [] };
			        	anonyAttendant["id"][0] = "anonyAttendant_" + length;
			        	anonyAttendant["name"][0] = names[i];
			        	anonyAttendant["name1"][0] = names[i];
			        	anonyAttendant["name2"][0] = names[i];
			        	anonyAttendant["deptname"][0] = "";
			        	anonyAttendant["deptname1"][0] = "";
			        	anonyAttendant["deptname2"][0] = "";
			        	anonyAttendant["pic"][0] = "";
			        	
			        	console.log(anonyAttendant);
			        	
			        	manage_attendant_Complete(anonyAttendant, "nouser", "json")
			        
			        } else if (adCount == 1) { // 검색결과 한명일때 
			            for (var j = 0; j < length; j++) {
			            	if(g_attendant["id"][j] !== "anonyAttendant" && g_attendant["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) {
			        			overlapAttendantXML.push(xmlDOM);
			                	break;
			            	}		   
			            }
			            
			            if(typeof overlapAttendantXML == "undefined" || g_attendant["id"].indexOf(getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) === -1) {
			            	AttendantXML.push(xmlDOM);
			            }
			            
			        } else { // 검색결과 여러명일때 >수정
			            var rgParams = new Array();
			            rgParams["addrBook"] = xmlDOM;
			            rgParams["name"] = "";
			            rgParams["id"] = "";
			            rgParams["deptname"] = "";
			            rgParams["name1"] = "";
			            rgParams["name2"] = "";
			            rgParams["deptname2"] = "";

			            ladder_check_Attendant_dialogArguments[0] = rgParams;
			            ladder_check_Attendant_dialogArguments[1] = check_name_Complete;
			            
			            GetOpenWindow("/ezLadder/checkName.do", "ladder_check_attendant", 610, 353);
			            /* checkname_cross_dialogArguments[0] = rgParams;
			            checkname_cross_dialogArguments[1] = check_name_Complete;
			            
			            GetOpenWindow("/ezLadder/checkName.do", "ladder_check_attendant", 610, 353); */
			            
			            i++;
			            return;
			        }
			    }
			    document.getElementById("inputAttendant").value = "";
			    
			    if(AttendantXML.length !== 0) {
			    	manage_attendant_Complete(AttendantXML, "", "xml");			    	
				    AttendantXML = [];
			    } 
			    if(overlapAttendantXML.length !== 0) {
			    	checkAttendant(overlapAttendantXML, function(overlapAttendantXML, attendType) {
			    		manage_attendant_Complete(overlapAttendantXML, attendType, "xml");
			    	});
				    overlapAttendantXML = [];
			    } 
			    
			    i = 0;
			    if (checknametype != "")
			        manage_attendant_after();
			}

			function check_name_Complete(rgParams) {
				console.log('check name com');
			    DivPopUpHidden();
			    
			    if (rgParams["name"] != "") {
			        if (g_attendant == null)
			            g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname1": new Array(), "deptname2": new Array(), "pic": new Array() };

			        var length = g_attendant["id"].length;
			        for (var j = 0; j < length; j++) {
			            if (g_attendant["id"][j] == rgParams["id"]) {
			                console.log('중복사용자');
			                return;
			            }
			        }

			        var length = g_attendant["name"].length;

			    	g_attendant["name"].push(rgParams["name"]);
			        g_attendant["id"].push(rgParams["id"]);
			    	g_attendant["deptname"].push(rgParams["deptname"]);
			    	g_attendant["name1"].push(rgParams["name1"]);
			    	g_attendant["name2"].push(rgParams["name2"]);
			    	g_attendant["deptname1"].push(rgParams["deptname1"]);
			    	g_attendant["deptname2"].push(rgParams["deptname2"]);
			    	g_attendant["pic"].push(rgParams["pic"]);
			    	
			        if (length == 0)
			        	$("#attendantList").append("<li class='attendant'>" + g_attendant["name"][length] + "</li>");
			        else
			        	$("#attendantList").append("<li class='attendant'>" + g_attendant["name"][length] + "</li>");

			        if (i != namelength)
			            check_name();
			    }
			    if (i == namelength) {
			        i = 0;
			        document.getElementById("inputAttendant").value = "";
			    }
			    if (checknametype != "")
			        manage_attendant_after();
			}
			
			/** 사다리 만들기 */
			function makeLadder() {
				var title = $("#title").val();
				var type = $(".ladderType.active").attr("num");
				var secretFlag = $("#ladderSecret.active").length;
				var lineCnt = $("#slider-range-min").slider("option", "value");
				
				var userId = [];
				var userName = [];
				var userName2 = [];
				var item = [];
				var ladderOrder = [];
				
				var len = g_attendant["id"].length;
				for(var i = 0; i < len; i++) {
					userId[i] = g_attendant["id"][i];
					if (g_attendant["id"][i].substring(0, 14) !== "anonyAttendant") {
						userName[i] = g_attendant["name"][i];
						userName2[i] = g_attendant["name2"][i];
					} else {
						userName[i] = $(".attendant:eq(" + i + ") input").val();
						userName2[i] = $(".attendant:eq(" + i + ") input").val();
					}
					item[i] = $(".item:eq(" + i + ") input").val();
					ladderOrder[i] = i;
				}
				
				console.log(userId);
				console.log(userName);
				console.log(userName2);
				console.log(item);
				console.log(ladderOrder);
				
				$.ajax({ 
					type: "POST",
					url: "/ezLadder/setLadder.do",
					traditional: true,
					dataType: "json",
					data: { 
						'title': title,
						'type': type,
						'secretFlag': secretFlag,
						'lineCnt': lineCnt,
						'userId': userId,
						'userName': userName,
						'userName2': userName2,
						'item': item,
						'ladderOrder': ladderOrder
					},
					success: function(result) {
						console.log('make ladder success');
					}
				});
			} 
			
			

		</script>
	</head>
	<body class="mainbody">
		<h1>사다리 게임</h1>
		<div class="fullwidth">
			<table class="setTable">
				<tr>
					<td></td><td style="width: 5000px;"></td><td></td>
				</tr>
				<tr>
					<td colspan="2" style="width: 98%;">
						<div class="wrap left">
							<div class="title floatL">
								<div class="icondiv" id="ladderPreList">이전사다리</div>
								<input type="text" class="input" id="title" style="height: 100%; width: 100%;" placeholder="제목" />
							</div>
						</div>
					</td>
					<td>
						<div class="wrap right">
							<div class="icondiv floatR fullwidth" id="ladderSecret">비밀글</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="wrap left">
							<input type="text" class="input" id="inputAttendant" style="height: 100%; width: 200px;" placeholder="참여자추가" />
						</div>
					</td>
					<td colspan="2">
						<div class="wrap right">
							<div class="floatR" style="width: 212px;">
								<div class="icondiv ladderType" num="0">꽝</div>
								<div class="icondiv ladderType" num="1">돈</div>
								<div class="icondiv ladderType" num="2">순서</div>
								<div class="icondiv ladderType" num="3">직접</div>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<div class="wrap left">
							<div class="floatL icondiv" id="amount">0</div>
							<div id="slider-range-min" style="width: 300px;"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="height: 700px; padding: 10px 0px;">
						<div class="wrap center" style="height: 100%; width: 100%;">
							<div id="addAttendant" class="icondiv">add</div>
							<div id="ladderLineBox" style="height: 100%; width: 100%; border: 1px solid gray">
								<canvas id='ladderCanvas' width="0" height="650"></canvas>
								<ul id="attendantList"></ul>
								<ul id="itemList"></ul>
							</div>
						</div>
					</td>
				</tr>
			</table>
			<div class="wrap center">
				<div class="ladderBtn" id="makeLad" style="float: right;">사다리 게임 만들기</div>
			</div>
			<table>
				
				<tr>
					<td>
						<button id="bmtest">bmtest</button>
					</td>
				</tr>
			</table>
		</div>
		<%-- <canvas id='ladderCanvas' width="500px" height="500px" style="border: 1px solid black"></canvas> --%>
		
		<span id="tetetest"><h3>만들기</h3></span>
		
		<!-- popup start -->
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	    <div id="dialog" title="Dialog Title">I'm a dialog</div>
	    <!-- end -->
	</body>
</html>