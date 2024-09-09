var noResult = false;

/* result : 모든 편지지함 정보(letteBoxNo, parentLetterBoxNo, displayname, displayname2, compnayId)
 * treeCollection : jstree에서 사용할 수 있도록 변형(id, parent, text)
 * */

// 편지지함 트리 가져오기
function resultRead() {
	
	$.ajax({
		type : "POST",
		url : "/admin/ezEmail/getLetterBox.do",
		datatype : 'json',
		data : {"companyId" : returnCompany},
		error : function(data) {
			alert("error");
			console.log(data);
		},
		complete : function(data) {
	        result = data.responseJSON;
	        
	        if (result.length === 0) {
        		noResult = true;
        	}
	        
	        treeSet();
	        treeView();
	    	treeInit();
	    }
	});
}

// 페이지 처음 들어갔을 때 클릭되는 부분
function treeInit() {
	if (!noResult) {
		$("#divTree").on('ready.jstree', function (e, data) {
			selectNode = data;
			data.instance.select_node([treeCollection[0].id]);
		});
	}
}

// 노드 클릭 시
function treeOnclick() {
	$('#divTree').on('changed.jstree', function (e, data) {
		searchTxt = "";
		selectNode = data;
		
		if (pageType === "letterBox") { // 편지지함 
    		var nodeId = selectNode.node.id;
    		var parentId = selectNode.node.parent;
    		
    		if (parentId == '#') {
    			parentId = '0';
    		}
    		
    		document.getElementById("parent_letterbox_no").value = parentId;
    		document.getElementById("letterbox_no").value = nodeId;
    		
    		if (!(nodeId.indexOf('temp'))) { // 편지지함이 임시 추가라면
    			if (addCheck == -1) {return;}
    			
    			setDisplay(letterStr20, "letterbox_temp");
    		} else { 
    			selectBox(nodeId);
    		}
    		
    		if (addCheck == -1) { 
    			$('#divTree').jstree().delete_node($('#temp'));
    			addCheck = 0;
    			$("#letterbox_no").removeAttr("disabled");
    			return;
    		}
    		
		} else if (pageType === "letter_user") {
			var letterBoxNo = data.node.id === "undefined" ? "1" : data.node.id;
			getLetterList(letterBoxNo); // 편지지 리스트
			
			$(".lmLetterTitle").empty();
			$(".lmLetterTitle").html(letterListMsg);
		} else { // 편지지 관리, 사용자 편지지 팝업
			var letterBoxNo = data.node.id === "undefined" ? "1" : data.node.id;
			getLetterList(letterBoxNo); // 편지지 리스트
		}
		
		$(".searchDis").removeAttr("disabled");
		searchMode = false;
    });
}

// 현재 노드 저장
function selectBox(letterBoxNo) {
	var query = "/admin/ezEmail/readLetterBox.do";
	
	$.ajax({
		type : "POST",
		url : query,
		cache : false,
		dataType : 'json',
		data : {"letterBoxNo" : letterBoxNo},
		success : function(data) {
			setDisplay(data.displayname, data.displayname2);
		},
		error : function(data) {
			alert("error");
		}
	});
}

// 트리에서 필요한 아이들만 빼서 treeCollection 재구성 (구성할 때 jsTree 규칙에 맞게 변경)
function treeSet() {
	
	if (userLang != 1) {
		for(var i = 0; i < result.length; i++) {
			var treeId = result[i].letterBoxNo;
			var treeParent = result[i].parentLetterboxNo;
			var treeText = result[i].displayname2;
			var companyId = result[i].companyId;
			
			if (treeParent == '0') {
				treeParent = '#'; 
			}
			
			treeCollection.push({id:treeId, parent:treeParent, text:treeText, companyId:companyId});
		}
	} else {
		for(var i = 0; i < result.length; i++) {
			var treeId = result[i].letterBoxNo;
			var treeParent = result[i].parentLetterboxNo;
			var treeText = result[i].displayname;
			var companyId = result[i].companyId;
			
			if (treeParent == '0') {
				treeParent = '#'; 
			}
			
			treeCollection.push({id:treeId, parent:treeParent, text:treeText, companyId:companyId});
		}
	}
	
	
}

// jstree 보여줌
function treeView() {
	$('#divTree').jstree({
		"plugins" : [ "changed", "wholerow", "types" ],
		'core' : {
			'data' : treeCollection,
			"check_callback": true
			},
			"types" : {
                "default": {
//                    "icon" :"/images/OrganTree_cross/fldr.gif" 
                }
            }
	});
	treeOnclick();
}

// 편지지함 추가
function addLetterBox() {
	var parent;
	var parentId;
	var putParent;
	
	if (addCheck == -1) {
		alert(letterStr22);
		return;
	}
	
	if (noResult) {
		//편지지함이 한개도 없을 경우, 부모를 루트로 만들어야함
		parent = '#';
		parentId = '';
		putParent = '0';
	} else {
		parent = selectNode.node.id;
		parentId = parent;
		putParent = parent;
	}

	var text = letterStr20;
	if (userLang != '1') {
		text = "letterbox_temp";
	}
	
	var node = { id: 'temp', text: text};
	$('#divTree').jstree('create_node', parent, node, 'last');
	$("#divTree").jstree("open_node", $('#' + parentId));
	$("#divTree").jstree("select_node", $('#temp'));
	$("#letterbox_no").attr("disabled","disabled");
	document.getElementById("parent_letterbox_no").value = putParent;
	
	addCheck = -1;
}

// 폴더명 중복 체크
function boxNameCheck(displayNumber) {
	var returnVal = false;
	var selectNd = selectNode.node;
	var checkId = displayNumber == 1 ? "display" : "display2";
	
	for(var i = 0; i < result.length; i++) {
		if(selectNd.parent == result[i].parentLetterboxNo && selectNd.id != result[i].letterBoxNo) {
			var checkName = displayNumber == 1 ? result[i].displayname : result[i].displayname2;
			
			if (document.getElementById(checkId).value == checkName) {
				returnVal = true;
			}
		}
	}
	
	return returnVal;
}

// 편지지함 삭제 버튼 클릭 시
function deleteLetterBox() {
	if (selectNode == null || typeof selectNode == "undefined") {return; }
	
	var letter = selectNode.node;
	var letterBoxNo = letter.id;
	var letterBoxParentNo = letter.parent;
	var realCheck = false;
	
	if (addCheck == -1) { // 편지지함 추가중
		if (confirm(letterStr24)){
			addCheck = 0;
			$('#divTree').jstree().delete_node($('#temp'));
			$("#display, #display2").val("");
			selectNode = null;
			
			$(".jstree-clicked").click();
			
		}
	} else if (letterBoxParentNo == '#') { //treeCollection[0].id ==
		alert(letterStr23);
		return;
	} else if (letter.children.length !== 0) {
		alert(letterStr25);
		return;
	} else {
		var con = confirm(letterStr27 + "\n" + letterStr28);
		
		if (con === true) {
			realCheck = true;
		}
	}
	
	if (realCheck === true) {
		$('#divTree').jstree().delete_node($('#' + letterBoxNo));
		
		$.ajax({
			type : "POST",
			url : "/admin/ezEmail/deleteLetterBox.do",
			datatype : 'json',
			data : {"letterBoxNo" : letterBoxNo},
			success : function(data) {
				$.ajax({
					type : "POST",
					url : "/admin/ezEmail/deleteLetterFile",
					datatype : 'json',
					data : {"letterBoxNo" : letterBoxNo},
					success : function(data) {},
					error : function(data) {
						alert("error");
					}
				});
				
				alert(letterBoxDelMsg);
				refreshLetterBox();
			},
			error : function(data) {
				alert("error");
			}
		}); // ajax End
	} // if End
}

// '확인' 버튼 클릭 시, update로 할것인지 insert로 할것인지
function submitClick() {
	var formData = $("#myForm").serialize();
	var formUrl = "/admin/ezEmail/updateLetterBox.do";
	var disName = strChk($("#myForm #display").val(), false, 40, letterBoxNameMsg);
	var disName2 = strChk($("#myForm #display2").val(), false, 40, letterBoxNameMsg);
	var disMsg = disName.msg !== "" ? disName.msg : disName2.msg !== "" ? disName2.msg : "";
	
	if (document.getElementById("letterbox_no").disabled) {
		formUrl = "/admin/ezEmail/createLetterBox.do";
	}
	
	if (selectNode == null || typeof selectNode == "undefined" || selectNode == "") {
		alert(selectLetterboxMsg);
		return;
	} else if (disMsg !== "") {
		alert(disMsg);
		return;
	}
	
	// 편지지함명 중복체크
	if (boxNameCheck(1) === true) {
		alert(letterStr26);
		document.getElementById("display").focus();
		return;
	}
	
	if (boxNameCheck(2) === true) {
		alert(letterStr26);
		document.getElementById("display2").focus();
		return;
	}
	
	$.ajax({
		type : "POST",
		url : formUrl,
		cache : false,
		data : formData,
		error : function(data) {
			console.log(data);
		},
		complete : function() {
			refreshLetterBox();
		}
	});
}

function refreshLetterBox() {
	window.location.reload();
}