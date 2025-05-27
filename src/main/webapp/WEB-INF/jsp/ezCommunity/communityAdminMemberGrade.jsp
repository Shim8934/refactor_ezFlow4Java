<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admin_memberlist</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			.gradeList {
				list-style-type: none;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var code = "<c:out value = '${code}' />";
			
			window.onload = function () {
				getGradeList();
			}
			
			function addGrade() {
				var ul = document.querySelector('#gradeLevel');
				var spanCount = ul.getElementsByTagName('span').length;
				var spanToCopy = document.getElementById('ans2'); 
				var newSpan = spanToCopy.cloneNode(true);
				
				var selectGrade = document.getElementById("joinGrade");
				var optionCount = selectGrade.getElementsByTagName('option').length;
				var option = selectGrade.getElementsByTagName('option')[0];
				var newOption = option.cloneNode(true);

				if (spanCount > 8) {
					alert("<spring:message code = 'ezCommunity.lyj12' />");
				} else {
					spanCount++;
					optionCount++;
					
					newSpan.id = 'ans' + spanCount;
					newOption.value = optionCount + 2;
					
					var li = newSpan.querySelector('li');
					li.class = 'gradeList';
					
					var input = newSpan.querySelector('input');
					input.name = 'gradeNm' + spanCount;

					if (spanCount == 4) {
						input.value = '<spring:message code = 'ezCommunity.lyj08' />';
					} else {
						input.value = '<spring:message code = 'ezCommunity.lyj28' />' + spanCount;
					}
					
					newOption.textContent = input.value;
					
					ul.appendChild(newSpan);
					selectGrade.appendChild(newOption);
				}
			}
			
			function removeGrade() {
				var ul = document.querySelector('#gradeLevel');
				var spans = ul.querySelectorAll('span');

				var selectGrade = document.querySelector("#joinGrade");
				var options = selectGrade.querySelectorAll('option');

				if (spans.length > 3) { 
					var lastSpan = spans[spans.length - 1];
					var lastOption = options[options.length - 1];
					
					var grade = lastSpan.id.substring(3);

					$.ajax({
						type : "POST",
						url : "/ezCommunity/adminMemberGradeCount.do",
						dataType : "json",
						async : false,
						data : {
							code : code,
							grade : grade
						},
						success : function(result) {
							if (result != 0) {
								alert("<spring:message code = 'ezCommunity.lyj23' />");
								return;
							} else {
								ul.removeChild(lastSpan);
								selectGrade.removeChild(lastOption);

								var remainOptions = selectGrade.querySelectorAll('option');
								remainOptions[remainOptions.length - 1].selected = true;
							}
						},
						error : function() {
							alert("<spring:message code = 'ezCommunity.t283' />");
						}
					});
				} else {
					alert("<spring:message code = 'ezCommunity.lyj13' />");
				}
			}
			
			function saveGrade() {
				var ul = document.querySelector('#gradeLevel');
				var inputs = ul.querySelectorAll('input');
				
				for (var i = 0; i < inputs.length; i++) {
					if (inputs[i].value == "") {
						alert("<spring:message code = 'ezCommunity.lyj14' />");
						return;
					} 
					if (inputs[i].value.length > 20) {
						alert("<spring:message code = 'ezCommunity.lyj15' />");
						return;
					}
				}

				var joinGrade = document.getElementById("joinGrade").value;
				var gradelist = new Array();
				
				inputs.forEach(input => {
					gradelist.push(input.value)
				});
				
				$.ajax({
					type : "POST",
					url : "/ezCommunity/adminMemberGradeSave.do",
					dataType : "json",
					contentType: "application/json;charset=UTF-8",
					async : false,
					data : JSON.stringify({
						code : code,
						joinGrade : joinGrade,
						gradeName : gradelist
					}),
					success : function(result) {
						if (result == true) {
							alert("<spring:message code = 'ezCommunity.t282' />");
							getGradeList();
							window.parent.opener.location.reload();
						} else {
							alert("<spring:message code = 'ezCommunity.t283' />");
						}
					},
					error : function() {
						alert("<spring:message code = 'ezCommunity.t283' />");
					}
				});
			}
			
			function getGradeList() {
				$.ajax({
					type : "GET",
					url : "/ezCommunity/getAdminMemberGrade.do",
					dataType : "json",
					data : {
						code : code
					},
					success : function(result) {
						getGradeList_after(result);
					},
					error : function(xhr, status, error) {
						console.error("Error: " + error); 
					}
				});
			}
			
			function getGradeList_after(gradeList) {
				var selectGrade = document.getElementById("joinGrade");
				selectGrade.innerHTML = "";
				
				for (var i = 2; i < gradeList.length-1; i++) {
					var option = document.createElement("option");

					option.value = gradeList[i].gradeCode;
					option.textContent = gradeList[i].gradeName;

					if (gradeList[i].gradeCode == gradeList[i].join_Grade) {
						option.selected = true;
					}
					
					selectGrade.appendChild(option);
				}

				var ul = document.querySelector('#gradeLevel');
				ul.innerHTML = "";

				for (var i = 0; i < gradeList.length-1; i++) {
					var span = document.createElement("span");
					
					span.id = 'ans' + (i+1);
					
					if (i >= 1) {
						span.style.display = 'block';
						span.style.marginTop = '5px';
					}
					
					var li = document.createElement('li');
					li.className = 'gradeList';

					var img = document.createElement('img');
					img.src = '../images/icon/icon_yellowstar.gif';

					var input = document.createElement('input');
					input.style.marginLeft = '5px'; 
					input.name = 'gradeNm' + (i+1);  
					input.type = 'text';  
					input.size = '30'; 
					input.value = gradeList[i].gradeName;

					li.appendChild(img);
					li.appendChild(input);
					
					if(i == 2) {
						var addLink = document.createElement('a');
						addLink.href = 'javascript:addGrade()';  
						addLink.className = 'imgbtn imgbck';  
						addLink.style.width = '31px';  
						addLink.style.paddingLeft = '7px';
						addLink.style.setProperty("margin-left", "3px", "important");
						addLink.title = '<spring:message code = 'ezCommunity.lyj26' />';  
						addLink.textContent = '<spring:message code = 'ezCommunity.lyj26' />'; 

						var removeLink = document.createElement('a');
						removeLink.href = 'javascript:removeGrade()';  
						removeLink.className = 'imgbtn imgbck';  
						removeLink.style.width = '31px';  
						removeLink.style.paddingLeft = '7px';
						removeLink.style.setProperty("margin-left", "3px", "important");
						removeLink.title = '<spring:message code = 'ezCommunity.lyj27' />';  
						removeLink.textContent = '<spring:message code = 'ezCommunity.lyj27' />';

						li.appendChild(addLink);
						li.appendChild(removeLink);
					}
					span.appendChild(li);
					ul.appendChild(span);
				}
			}
		</script>
		
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.lyj01' /></h1>
		<div class="point"><spring:message code = 'ezCommunity.lyj02' /></div>
		<hr style="margin-top:10px;">	
		<div style="font-size:14px;"><spring:message code = 'ezCommunity.lyj03' />
			<select id="joinGrade" style="MIN-WIDTH: 60px; height: 20px;" onchange="">
				<option value="3"><spring:message code = 'ezCommunity.lyj07' /></option>
				<option value="4" selected><spring:message code = 'ezCommunity.lyj08' /></option>
			</select> <spring:message code = 'ezCommunity.lyj04' /></div>
		<br>
		<div class="level">
			<ul id="gradeLevel" style="margin-left: -40px;">
				<span id="ans1" style="display: block;">
					<li class="gradeList"><img src="../images/icon/icon_yellowstar.gif"/><input style="margin-left:5px;" name="gradeNm1" type="text" size="30" value="마스터"/></li>
				</span>
				<span id="ans2" style="display: block;margin-top:5px;">
					<li class="gradeList"><img src="../images/icon/icon_yellowstar.gif"/><input style="margin-left:5px;" name="gradeNm2" type="text" size="30" value="운영자"/></li>
				</span>
				<span id="ans3" style="display: block;margin-top:5px;">
					<li class="gradeList">
						<img src="../images/icon/icon_yellowstar.gif"/><input style="margin-left:5px;" name="gradeNm3" type="text" size="30" value="정회원"/>
						<a href="javascript:addGrade()" style="width: 31px;padding-left: 7px;" class="imgbtn imgbck" title="추가"><spring:message code = 'ezCommunity.lyj26' /></a> <a href="javascript:removeGrade()" style="width: 31px;padding-left: 7px;" class="imgbtn imgbck" title="삭제"><spring:message code = 'ezCommunity.lyj27' /></a> 
					</li>
				</span>
				<span id="ans4" style="display: block;margin-top:5px;">
					<li class="gradeList"><img src="../images/icon/icon_yellowstar.gif"/><input style="margin-left:5px;" name="gradeNm4" type="text" size="30" value="준회원"/></li>
				</span>
			</ul>
		</div>

		<br>
		<div class="txt">▒ <spring:message code='ezCommunity.lyj09' /></div>
		<div class="txt" style="margin-top:3px">▒ <spring:message code='ezCommunity.lyj10' /></div>
		<div class="txt" style="margin-top:3px">▒ <spring:message code='ezCommunity.lyj11' /></div>

		<br><br><br>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"	name="Submit"	onclick="javascript:saveGrade();"><span><spring:message code ='ezCommunity.t20' /></span></a>
			<a class="imgbtn"	name="Submit2"	onclick="window.location.reload(false)" ><span><spring:message code ='ezCommunity.t109' /></span></a>
			<a class="imgbtn"	name="Submit3"	onclick="parent.parent.window.close()"><span><spring:message code ='ezCommunity.t21' /></span></a>
		</div>
	</body>
</html>