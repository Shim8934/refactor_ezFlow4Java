/**
 * 프로젝트 업무트리 가져오기
 */
function getProjectTaskTree(containerId, data, location) {
	$("#"+containerId).jstree({
		'core' : {
			'data' : data,
			'multiple' : false,
			'animation' : 0,
			'themes' : {
				'responsive' : true
				//'variant' : 'small',
				//'stripes' : false
			}
		},
		'plugins' : [ 'sort', "wholerow" ],
		'sort' : function(a, b) {
			var a1 = this.get_node(a);
			var b1 = this.get_node(b);
			return (a1.original.sort > b1.original.sort) ? 1 : -1;
		}
	})
	.bind("loaded.jstree", function (event, data) {
		$(this).jstree("open_all");
		var firstNode = $(this).find(".jstree-anchor");
		$("#" + firstNode[0].id).addClass("jstree-clicked");
		$("#" + firstNode[0].id).prev().prev().addClass("jstree-wholerow-clicked");
		var firstNodeId = firstNode[0].id;
		
		firstNodeId = firstNodeId.substring(0, firstNodeId.indexOf("_"));
		
		if (location == "taskLog" || location == "taskList") {
			groupId = firstNodeId;
			setContentList();
		}
	
	})
	.on("select_node.jstree", function(e, data) {
		if (location == "taskLog" || location == "taskList") {
			if (data.node.id.indexOf("t") != -1) {
				taskId = data.node.id.substring(1);
				setContentList();
			} else {
				taskId = 0;
				groupId = data.node.id;
				setContentList();
			}
		}
	});
}


function convertString(str) {
//	str = ReplaceText(str, "&", "&amp;");
//	str = ReplaceText(str, "<", "&lt;");
//	str = ReplaceText(str, ">", "&gt;");
	//str = ReplaceText(str, "\'", "&apos;");
	//str = ReplaceText(str, "\"", "&quot;");
	str = str.replace(/(?:\r\n|\r|\n)/g, '<br/>');
	return str;
}
 
function ReplaceText(orgStr, findStr, replaceStr) {
     var re = new RegExp(findStr, "gi");
     return (orgStr.replace(re, replaceStr));
}
 
function replaceString(p_str) {
     p_str = ReplaceText(p_str, "&lt;", "<");
     p_str = ReplaceText(p_str, "&gt;", ">");
     p_str = ReplaceText(p_str, "&apos;", "\'");
     p_str = ReplaceText(p_str, "&#039;", "\'");
     p_str = ReplaceText(p_str, "&quot;", "\"");
     p_str = ReplaceText(p_str, "&#034;", "\"");
     p_str = ReplaceText(p_str, "&amp;", "&");
     p_str = p_str.replace(/<br\/>/g, "\r\n");
     return p_str;
}

function popupClose() {
	parent.DivPopUpHidden();
}
 
function showSearchDiv() {	
	if ($("#searchDiv").css("display") == "none") {
		$(".searchViewIcon").attr("src", "/images/etc/view-sortdown.gif");
		$("#searchDiv").slideDown();
	} else {
		$(".searchViewIcon").attr("src", "/images/etc/view-sortup.gif");
		$("#searchDiv").slideUp();
	}
}

//레이어팝업 top과 left %로 주기 위해 사용
function addProjectPopup(topPct, leftPct, popUpW, popUpH, URL) {
    try {
        var Position = DivPopUpPosition(popUpW, popUpH);
        document.getElementById("iFrameLayer").src = URL;
        document.getElementById("iFramePanel").style.top = topPct + "%";
        document.getElementById("iFramePanel").style.left = leftPct + "%";
        document.getElementById("iFramePanel").style.height = popUpH + "px";
        document.getElementById("iFrameLayer").style.width = popUpW + "px";
        document.getElementById("iFrameLayer").style.height = popUpH + "px";
        document.getElementById("mailPanel").style.display = "";
        document.getElementById("iFramePanel").style.display = "";
    } catch (e) {}
}

//작업이력 추가
function addTaskLog(projectId, logStatus, groupId, taskId, logContent) {
	//logStatus : 1(등록), 2(수정), 3(삭제)
	var data = {
		projectId : projectId,
		logStatus : logStatus,
		groupId : groupId,
		taskId : taskId,
		logContent : logContent
	}
	
	$.ajax({
		type : "post",
		url : "/ezPMS/addTaskLog.do",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function() {
			
		},
		error : function(request, status, error) {
		}
	});
}

//목록에서 체크된 값을 저장
function getCheckedVal() {

	checkedVal = "";
	
	if (viewType == "1") {
		$("input[type='checkbox']:checked").parent().parent().each(function(){
			checkedVal += "_" + $(this).attr("id");
		});
		
		if (checkedVal != "") {
			if ($("input:checkbox[id='HeaderAllCheckBox']").is(":checked") == true) {
				checkedVal = checkedVal.substring(14);
			} else {
				checkedVal = checkedVal.substring(1);
			}
		}
		
	} else {
		console.log($("input[type='checkbox']:checked").parent().parent().parent().parent().parent().parent());
		$("input[type='checkbox']:checked").parent().parent().parent().parent().parent().parent().each(function(){
			checkedVal += "_" + $(this).attr("id");
		});
		
		if(checkedVal != "") {
			checkedVal = checkedVal.substring(1);
		}
	}
	
	if (checkedVal == "") {
		return 0;
	}
	
	return 1;
}

//검색 - 날짜 초기화 버튼
function emptyDate(elem){
	$(elem).siblings('input').val("");
}

function viewSetting() {
	CurrentHeight = $(window).height() - 100;
	$("MailListRayer").css("height", CurrentHeight + "px");
	$("#taskTree").css("height", CurrentHeight + "px");
	$("#projectContent").css("height", CurrentHeight + "px");
	$("#contentList").css("height", (CurrentHeight - 102) + "px");
	$("#projectListBody").css("height", (CurrentHeight - 190) + "px");
	$("#divList").css("height", (CurrentHeight - 150) + "px");
	$("#divList").css("overflow", "auto");
}