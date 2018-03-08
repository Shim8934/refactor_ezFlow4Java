// 편지지함 트리 가져오기
function resultRead() {
	$.ajax({
		type : "POST",
		url : "/admin/ezEmail/getLetterBox.do?companyId=" + returnCompany,
		datatype : 'json',
		error : function(data) {
			alert("error");
			console.log(data);
		},
		complete : function(data) {
	        result = data.responseJSON;
	        
	        if (pageType == 'letterBox') {
	    	   setCompany();
	        }
	        treeSet();
	    	treeView();
	    	treeInit();
	    }
	});
}

// 페이지 처음 들어갔을 때 클릭되는 부분
function treeInit() {
	$("#divTree").on('ready.jstree', function (e, data) {
		selectNode = data;
		data.instance.select_node([treeCollection[0].id]);
	});
}

// 회사 아이디 저장
function setCompany() {
	company = result[0].company_id;
	
	if (company == null) {
		company = "";
	}
}

// 노드 클릭 시
function treeOnclick() {
	var parent;
	
	$('#divTree').on('changed.jstree', function (e, data) {
		if (pageType === "letterBox") { // 편지지함 
    		if (addCheck == -1) {
    			//추가하면 다른 node 못누르게됨
    			$("#divTree").jstree('select_node', "#temp");
    			setDisplay("편지지함", "letterbox_temp");
    			return;
    		}
    		
    		
    		selectNode = data;
    		parent = selectNode.node.parent;
    		
    		if (parent == '#') {
    			parent = '0';
    		}
    		
    		document.getElementById("parent_letterbox_no").value = parent;
    		document.getElementById("letterbox_no").value = selectNode.node.id; 
    		//여기다가 비슷하게 회사 추가하기
    		
    		if (!(selectNode.node.id.indexOf('temp'))) {
    			// 편지지함이 임시 추가라면
    			setDisplay("편지지함", "letterbox_temp");
    		} else { 
    			selectBox(selectNode.node.id);
    		}
		} else { // 편지지
			// letterBoxNo
			var letterBoxNo = data.node.id === "undefined" ? "1" : data.node.id;
			
			getLetterList(letterBoxNo); // 편지지 리스트
		}
    });
	
}

// 현재 노드 저장
function selectBox(letterBoxNo) {
	var query = "/admin/ezEmail/readLetterBox.do?letterBoxNo=" + letterBoxNo;
	
	xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", query, true);
    xmlhttp.responseType = 'text'; 
    xmlhttp.onreadystatechange = readText;
    xmlhttp.send();
}

// 편지지함 삭제
function deleteBox(letterBoxNo) {
	var query = "/admin/ezEmail/deleteLetterBox.do?letterbox_no=" + letterBoxNo;
	
	xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", query, true);
    xmlhttp.responseType = 'json'; 
    xmlhttp.onreadystatechange = deleteText;
    xmlhttp.send();
}
// 편지지함 삭제 상태
function deleteText() {
	if (xmlhttp == null || xmlhttp.readyState != 4) return;
	responseResult = xmlhttp.response;
	
	if (responseResult == "ERROR") {
		return;
	}
}

// 이름, 이름(영문) 가져오는 친구
function readText() { 
	if (xmlhttp == null || xmlhttp.readyState != 4) return;
	responseResult = xmlhttp.response;
	var displayname = 'displayname":"';
	var displayname2 = 'displayname2":"';
	var displayname_start = responseResult.indexOf(displayname) + displayname.length;
	var displayname2_start = responseResult.indexOf(displayname2) + displayname2.length;
	var displayname_end = responseResult.indexOf('","par');
	var displayname2_end = responseResult.indexOf('","com');
	
	letter_displayname = responseResult.substring(displayname_start, displayname_end);
	letter_displayname2 = responseResult.substring(displayname2_start, displayname2_end);
	
	setDisplay(letter_displayname, letter_displayname2);
}

// 트리에서 필요한 아이들만 빼서 treeCollection 재구성
function treeSet() {
	for(var i = 0; i < result.length; i++) {
		var treeId = result[i].letterbox_no;
		var treeParent = result[i].parent_letterbox_no;
		var treeText = result[i].displayname;
		var companyId = result[i].company_id;
		
		if (treeParent == '0') {
			treeParent = '#'; 
		}
		
		treeCollection.push({id:treeId, parent:treeParent, text:treeText, company_id:companyId});
	}
	
	
}

// jstree 보여주는 애
function treeView() {
	$('#divTree').jstree({
		"plugins" : [ "changed", "wholerow", "types" ],
		'core' : {
			'data' : treeCollection,
			"check_callback": true
			},
			"types" : {
                "default": {
                    "icon" :"/images/OrganTree_cross/fldr.gif" 
                }
            }
	});
	treeOnclick();
}

// 편지지함 추가
function addLetterBox() {
	
	if (addCheck == -1) {
		alert("추가 더이상 안돼"); // 이거 strLang으로 바꾸기
		return;
	}
	
	var parent = selectNode.node.id;
	var node = { id: 'temp', text:"편지지함"};
	$('#divTree').jstree('create_node', parent, node, 'last');
	
	$("#divTree").jstree("open_node", $('#'+parent));
	$("#divTree").jstree("select_node", $('#temp'));
	
	document.getElementById("parent_letterbox_no").value = parent;
	document.getElementById("company_id").value = company;
	
	$("#letterbox_no").attr("disabled","disabled");
	
	addCheck = -1;
	
}

// 폴더명 중복 체크
function boxNameCheck() {
	var boxNamearr = [];
	var returnVal = false;
	
	for(var i = 0; i < result.length; i++) {
		if(selectNode.node.parent == result[i].parent_letterbox_no) {
			boxNamearr.push(result[i].displayname);
		}
	}
	 
	for (var i = 0; i < boxNamearr.length; i++) {
		if (document.getElementById("display").value == boxNamearr[i]) {
			returnVal = true;
		}
	}
	
	return returnVal;
}

// 편지지함 삭제 버튼 클릭 시
function deleteLetterBox() {
	var id = selectNode.node.id;
	var realCheck = false;
	
	if (id == treeCollection[0].id) {
		alert("기본편지지함은 삭제가 불가능합니다.");
		return;
	}
	
	if (selectNode.node.children.length != 0) {
		alert("하위 편지지함이 존재합니다. 하위편지지함을 삭제해주세요");
		return;
	} else {
		var con = confirm("편지지함을 삭제하시겠습니까?");
		if (con == true) {
			realCheck = true;
		}
	}
	
	if (realCheck == true) {
		$('#divTree').jstree().delete_node($('#'+id));
		var a = deleteBox(id);
		alert("삭제를 완료하였습니다.");
		refreshLetterBox();
		
	}
	
}

// '확인' 버튼 클릭 시, update로 할것인지 insert로 할것인지
function submitClick() {
	var formData = $("#myForm").serialize();
	var formUrl = "/admin/ezEmail/updateLetterBox.do";
	if (document.getElementById("letterbox_no").disabled) {
		formUrl = "/admin/ezEmail/createLetterBox.do";
	}
	
	var checkVal = boxNameCheck();
	
	if (checkVal == true) {
		alert("편지지함명 이 중복되었습니다.");
		document.getElementById("display").focus();
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
