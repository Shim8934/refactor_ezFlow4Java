var noResult = false;

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
	        
	        if (result.length == 0) {
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
	var parent;
	
	$('#divTree').on('changed.jstree', function (e, data) {
		selectNode = data;
		if (pageType === "letterBox") { // 편지지함 
    		if (addCheck == -1) {
    			//추가하면 다른 node 못누르게됨
    			$("#divTree").jstree('select_node', "#temp");
    			setDisplay("편지지함", "letterbox_temp");
    			return;
    		}
    		
    		parent = selectNode.node.parent;
    		
    		if (parent == '#') {
    			parent = '0';
    		}
    		
    		document.getElementById("parent_letterbox_no").value = parent;
    		document.getElementById("letterbox_no").value = selectNode.node.id; 
    		
    		if (!(selectNode.node.id.indexOf('temp'))) {
    			// 편지지함이 임시 추가라면
    			setDisplay("편지지함", "letterbox_temp");
    		} else { 
    			selectBox(selectNode.node.id);
    		}
    		
		} else if (pageType == 'letter_move') { 
			
			
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
	
	$.ajax({
		type : "POST",
		url : query,
		cache : false,
		dataType : 'json',
		success : function(data) {
			setDisplay(data.displayname, data.displayname2);
		},
		error : function(data) {
			alert("error");
			console.log(data);
		}
	});
	
}

// 트리에서 필요한 아이들만 빼서 treeCollection 재구성
function treeSet() {
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
	var parent;
	var parentId;
	var putParent;
	
	if (addCheck == -1) {
		alert("추가 더이상 안돼"); // 이거 strLang으로 바꾸기
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

	var node = { id: 'temp', text:"편지지함"};
	$('#divTree').jstree('create_node', parent, node, 'last');
	$("#divTree").jstree("open_node", $('#'+parentId));
	$("#divTree").jstree("select_node", $('#temp'));
	$("#letterbox_no").attr("disabled","disabled");
	document.getElementById("parent_letterbox_no").value = putParent;
	
	addCheck = -1;
	
}

// 폴더명 중복 체크
function boxNameCheck() {
	var boxNamearr = [];
	var returnVal = false;
	
	for(var i = 0; i < result.length; i++) {
		if(selectNode.node.parent == result[i].parentLetterboxNo && selectNode.node.id != result[i].letterBoxNo) { 
			//selectNode.node.id != result[i].letterBoxNo 이거 해줘야 자기자신은 비교 x
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
	var letterBoxNo = selectNode.node.id;
	var realCheck = false;
	
	if (letterBoxNo == treeCollection[0].id) {
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
		$('#divTree').jstree().delete_node($('#'+letterBoxNo));
		$.ajax({
			type : "POST",
			url : "/admin/ezEmail/deleteLetterBox.do?letterBoxNo=" + letterBoxNo,
			datatype : 'json',
			success : function(data) {
				
				$.ajax({
					type : "POST",
					url : "/admin/ezEmail/deleteLetterFile?letterBoxNo=" + letterBoxNo,
					datatype : 'json',
					success : function(data) {},
					error : function(data) {
						alert("error");
						console.log(data);
					}
				});
				
				alert("삭제를 완료하였습니다.");
				refreshLetterBox();
			},
			error : function(data) {
				alert("error");
				console.log(data);
			}
		});
		
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
