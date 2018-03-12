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
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
		<script type="text/javascript" src="/js/ezLadder/string_component.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderSetting.js"></script>
		<script type="text/javascript" src="/css/ezLadder/ladder_CSS.css"></script>
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
		
		<script type="text/javascript">
			var g_attendant = null;
			var ladder_select_attendant_dialogArguments = new Array();
		
			$(function() {
				$(".ladderType:eq(<c:out value='${ladType}' />)").addClass("active");
				
				$("#makeLad").on("click", function() {
					makeLadder();
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
				$(".ladderSecret").on("click", function() {
					$(".ladderSecret").toggleClass("active");
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
						$("#amount").val(ui.value);
					}
				});
				$("#amount").val($("#slider-range-min").slider("value"));
				$("#bmtest").on("click", function() { /* 즐겨찾기 테스트 버튼 */
					var flag = "delete";
					var ladderbmid = flag === "add" ? "0" : "68";
					var bmname = "수뎡ㅇㅇㅇㅇㅇㅇㅇㅇ";
					var bmuserid = ["id1", "id2", "id3", "id-add"];
					var bmusername = ["name1", "name2", "name3", "name-add"];
					var bmusername2 = ["name1", "name2", "name3", "name-add"];
					var bmuserinfo = {"userid":bmuserid, "username":bmusername, "username2":bmusername2};
					
					var bmusers = JSON.stringify(bmuserinfo);
					
					$.ajax({
						type: "POST",
						url: "/ezLadder/setLadderBM.do",
						data: { 
							flag: flag,
							ladderBMId: ladderbmid,
							bmName: bmname,
							bmUsers: bmusers 
						},
						dataType: "json",
						success: function(result) {
							console.log(result);
						}
					});
				});
				
			});

			function _manage_attendant() {
			    check_name("attendant");
			}
			
			/** 조직도 호출 */
			function manage_attendant_after() {
				ladder_select_attendant_dialogArguments[0] = g_attendant;
			    ladder_select_attendant_dialogArguments[1] = manage_attendant_Complete;
			    ladder_select_attendant_dialogArguments[2] = true;

			    GetOpenWindow("/ezLadder/setLadderAttendant.do", "ladder_select_attendant", 970, 680);
			}
			
			/** 참여자+아이템 추가 */
			function manage_attendant_Complete(attendList, attendType, arrayType) {
				console.log("manage_attendant_Complete");
				var i = 0;
				var len = 0;
				
				if(typeof attendList !== "undefined") {
					if(arrayType === "xml") { // 바로 입력
						console.log('xml');
						i = 0;
						len = attendList.length;
	
						if(typeof g_attendant === "undefined") {
							g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };
						}
						
						console.log('i  '+i);
						console.log('len  '+len);
						for(; i < len; i++) {
							g_attendant["name"].push(getNodeText(GetChildNodes(SelectNodes(attendList[i], "LISTVIEWDATA/ROWS/ROW")[0])[3]));
							g_attendant["name1"].push(getNodeText(attendList[i].getElementsByTagName("DATA5")[0]));
							g_attendant["name2"].push(getNodeText(attendList[i].getElementsByTagName("DATA6")[0]));
							
							if(attendType == "anonyuser") {
								g_attendant["id"].push("anonyAttendant");
								g_attendant["deptname"].push("");
								g_attendant["deptname2"].push("");
								$("#attendantList").append("<li class='attendant'><input type='text' value='" +g_attendant["name"][g_attendant["id"].length - 1]+ "' /><span class='remove'>X</span></li>");
							} else {
								g_attendant["id"].push(getNodeText(attendList[i].getElementsByTagName("DATA2")[0]));
								g_attendant["deptname"].push(getNodeText(attendList[i].getElementsByTagName("DATA4")[0]));
								g_attendant["deptname2"].push(getNodeText(attendList[i].getElementsByTagName("DATA7")[0]));
								$("#attendantList").append("<li class='attendant'>" + g_attendant["name"][g_attendant["id"].length - 1] + "<span class='remove'>X</span></li>");
							}
							
			            	$("#itemList").append("<li class='item'><input type='text' value='" +g_attendant["name"][g_attendant["id"].length - 1]+ " item' /></li>");
						}
					} else{ // 조직도에서 불러옴
						console.log('json');
						i = 0;
						len = attendList["id"].length;
						console.log('len  '+len);
	
						if(typeof g_attendant === "undefined" || ladder_select_attendant_dialogArguments[2]) {
							g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };
							$("#attendantList").html("");
							$("#itemList").html("");
							ladder_select_attendant_dialogArguments[2] = false;
						}
						
						for(; i < len; i++) {
							g_attendant["name"].push(attendList["name"][i]);
							g_attendant["name1"].push(attendList["name"][i]);
							g_attendant["name2"].push(attendList["name"][i]);
							
							if(attendType == "anonyuser" || attendList["id"][i] === "anonyAttendant") {
								g_attendant["id"].push("anonyAttendant");
								g_attendant["deptname"].push("");
								g_attendant["deptname2"].push("");
								$("#attendantList").append("<li class='attendant'><input type='text' value='" +g_attendant["name"][g_attendant["id"].length - 1]+ "' /><span class='remove'>X</span></li>");
							} else {
								g_attendant["id"].push(attendList["id"][i]);
								g_attendant["deptname"].push(attendList["deptname"][i]);
								g_attendant["deptname2"].push(attendList["deptname2"][i]);
								$("#attendantList").append("<li class='attendant'>" + g_attendant["name"][g_attendant["id"].length - 1] + "<span class='remove'>X</span></li>");
							}
							
			            	$("#itemList").append("<li class='item'><input type='text' value='" +g_attendant["name"][g_attendant["id"].length - 1]+ " item' /></li>");
						}
					}
				}
				changeSliderValue();
			}
			
			/** 참여자 추가할때마다 슬라이더 바 조절 */
			function changeSliderValue() { 
				$("#slider-range-min").slider("option", "max", g_attendant["id"].length * 5);
				$("#slider-range-min").slider("option", "value", Math.round(g_attendant["id"].length * 5 / 2));
				$("#amount").val($("#slider-range-min").slider("value"));
			}
			
			/** 참여자 삭제 */
			function attendant_remove(index) {
				g_attendant["id"].splice(index, 1);
				g_attendant["name"].splice(index, 1);
				g_attendant["name1"].splice(index, 1);
				g_attendant["name2"].splice(index, 1);
				g_attendant["deptname"].splice(index, 1);
				g_attendant["deptname2"].splice(index, 1);
				
				$(".attendant:eq(" + index + ")").remove();
				$(".item:eq(" + index + ")").remove();
			}
			
			/** 사다리 만들기 */
			function makeLadder() {
				var lad = {};
				var ladline = { "userid": [], "username": [], "username2": [], "item": [], "ladderorder": [] };
				var ladstr = "";
				var ladlinestr = "";
				var today = GetDateTimeFormatString();
				var i = 0;
				var len = $("#attendantList li").length;
				
				lad.title = $("#title").val();
				lad.type = $(".ladderType.active").attr("typeNumber");
				lad.secretflag = $(".ladderSecret.active").length;
				lad.linecnt = $("#slider-range-min").slider("option", "value");
				lad.writedate = today;
				
				for(; i < len; i++) {
					ladline["userid"].push(g_attendant["id"][i]);
					if (g_attendant["id"][i] !== "anonyAttendant") {
						ladline["username"].push(g_attendant["name"][i]);
						ladline["username2"].push(g_attendant["name2"][i]);
					} else {
						ladline["username"].push($(".attendant:eq(" + i + ") input").val());
						ladline["username2"].push($(".attendant:eq(" + i + ") input").val());
					}
					ladline["item"].push($(".item:eq(" + i + ") input").val());
					ladline["ladderorder"].push(i);
				}
				
				ladstr = JSON.stringify(lad);
				ladlinestr = JSON.stringify(ladline);
				
				console.log(lad);
				console.log(ladline);
				
				/* $.ajax({ //수정하기
					type: "POST",
					url: "/ezLadder/setLadder.do",
					data: { 
						allLadData: ladstr
					},
					dataType: "json",
					success: function(result) {
						console.log('make ladder success');
					}
				}); */
			} 
			
			var ladder_check_Attendant_dialogArguments = [];
			var i = 0;
			var namelength = 0;
			var checknametype = "";
			var AttendantXML = [];
			var overlapAttendantXML = [];
			function check_name(type) {
			    if (type != undefined)
			        checknametype = type;
			    else
			        checknametype = "";

			    var name = document.getElementById("inputAttendant").value;
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
			    			prop   : "displayName;description",
			    			type   : "user"
			    		},
			    		success: function(xml){
			    			xmlDOM = loadXMLString(xml);
			                adCount = xmlDOM.getElementsByTagName("ROW").length;
			    		}    		
			    	});
			        
			        if (adCount == 0) { // 검색결과 없을때 
			            alert("'" + names[i] + "' <spring:message code='ezLadder.t110' />");
			            continue;
			        } else if (adCount == 1) { // 검색결과 한명일때 
			            if (g_attendant == null) {
			            	g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };
			            }
			            
		                var length = g_attendant["name"].length;
		                for (var j = 0; j < length; j++) {
		                	if(g_attendant["id"][j] !== "anonyAttendant" && g_attendant["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) {
	                			overlapAttendantXML.push(xmlDOM);
			                	break;
		                	}		   
		                }
		                
		                if(typeof overlapAttendantXML == "undefined" || g_attendant["id"].indexOf(getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) === -1) {
		                	AttendantXML.push(xmlDOM);
		                }
		                
			        } else { // 검색결과 여러명일때 
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
			    
			    console.log('name:'+rgParams["name"]);
			    
			    if (rgParams["name"] != "") {
			        if (g_attendant == null)
			            g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };

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
		        	g_attendant["deptname2"].push(rgParams["deptname2"]);
		        	
			        console.log('g attend');
			        console.log(g_attendant);

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

		</script>
	</head>
	<body>
		<div>
			<table class="ladder_table">
				<tr>
					<td>
						<input type="text" id="title" placeholder="제목" />
					</td>
				</tr>
				<tr>
					<td>
						<label for="amount">line count: </label>
						<input type="text" id="amount" readonly style="border:0; color:#f6931f; font-weight:bold;">
						<div id="slider-range-min"></div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="Seldiv ladderSecret">비밀옵션</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="Seldiv ladderType" typeNumber="0">꽝</div>
						<div class="Seldiv ladderType" typeNumber="1">돈</div>
						<div class="Seldiv ladderType" typeNumber="2">순서</div>
						<div class="Seldiv ladderType" typeNumber="3">직접</div>
					</td>
				</tr>
				<tr>
					<td>
						<input type="text" id="inputAttendant" placeholder="참여자추가" />
					</td>
				</tr>
				<tr>
					<td>
						<button id="addAttendant">참여자추가</button>
					</td>
				</tr>
				<tr>
					<td>
						<div id="ladderLineBox">
							<ul id="attendantList"></ul>
							<ul id="itemList"></ul>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<button id="bmtest">bmtest</button>
					</td>
				</tr>
			</table>
		</div>
		
		<span id="makeLad"><h3>만들기</h3></span>
		
		<!-- popup start -->
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	    <div id="dialog" title="Dialog Title">I'm a dialog</div>
	    <!-- end -->
	</body>
</html>