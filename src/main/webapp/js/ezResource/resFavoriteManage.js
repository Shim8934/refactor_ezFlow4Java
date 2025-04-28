getFavoriteList();


function getFavoriteList(topId) {
    if (!topId) {
        topId = "";
    }
    var data = $.param({
    	topId: topId
    });

    $.ajax({
        url: "/ezResource/getFavoriteCategoryList.do",
        type: "POST",
        data: data,
        headers: {
            "accept": "application/json"
        },
        success: function (jsonObj) {
            var catList = jsonObj.list;
            if (!topId) {
                var treeMain = $("#TreeCtrl_MyFavoriteTree")[0];
                getMainTreeUI(catList, treeMain);
            } else {
                var childListDiv = $("[data-parent-id='" + topId + "']")[0];
                getMainTreeUI(catList, childListDiv);
            }
        },
        error: function (xhr, status, error) {
            console.error("즐겨찾기 카테고리(분류) 목록 조회 오류 :", status, error);
        }
    });
}

function nextTree(event) {
    var element = event.target;
    var topId = element.dataset.id;
    if (element.classList.contains("tree_plus")) {
        element.classList.remove("tree_plus");
        element.classList.add("tree_minus");
        getFavoriteList(topId);
    } else if (element.classList.contains("tree_minus")) {
        element.classList.remove("tree_minus");
        element.classList.add("tree_plus");
        document.querySelector("[data-parent-id='" + topId + "']").innerHTML = "";
    }
}

function checkCategory(event) {
	if (event.target.classList.contains("node_selected")) {
		event.target.classList.remove("node_selected");
		document.querySelector("#selectCategoryId").value = "";
	} else {
		var nodeNomalArr = document.querySelectorAll(".node_normal");
		
		for (var i = 0; i < nodeNomalArr.length; i++) {
			var node = nodeNomalArr[i];
			node.classList.remove("node_selected");
		}
		event.target.classList.add("node_selected");
		document.querySelector("#selectBrdId").value = "";
		document.querySelector("#selectBrdTopCatId").value = "";
		document.querySelector("#selectCategoryId").value = event.target.dataset.id;
	}
}

function checkBrd(event) {
	if (event.target.classList.contains("node_selected")) {
		event.target.classList.remove("node_selected");
			document.querySelector("#selectBrdId").value = "";
			document.querySelector("#selectBrdTopCatId").value = "";
	} else {
		var nodeNomalArr = document.querySelectorAll(".node_normal");
		for (var i = 0; i < nodeNomalArr.length; i++) {
			var node = nodeNomalArr[i];
			node.classList.remove("node_selected");
		}
		event.target.classList.add("node_selected");
		document.querySelector("#selectBrdId").value = event.target.dataset.id;
		document.querySelector("#selectBrdTopCatId").value = event.target.dataset.cid;
		document.querySelector("#selectCategoryId").value = "";
	}
}

function getMainTreeUI(catList, treeMain) {
    treeMain.innerHTML = "";
    var topId = treeMain.dataset.parentId;
    if (!topId) {
        if (catList[0]) {
            topId = catList[0].topId;
        } else {
            topId = "";
        }
    }
    var data = $.param({
    	catId: topId
    });
    $.ajax({
        url: "/ezResource/getBrdFavoriteList.do?",
        type: "POST",
        data: data,
        headers: {
            "accept":"application/json"
        },
        success: function (jsonObj) {
            var brdList = jsonObj.list;
            var divTag = document.createElement("div");
            var lang = jsonObj.userLang;

            // 자원 추가
            for (var j = 0; j < brdList.length; j++) {
                var brdDivTag = document.createElement("div");
                var brdIcon = document.createElement("span");
                brdIcon.classList.add("sub_iconLNB");
                var classStr = "tree_resource_ok";
                if (brdList[j].approveFlag == "0") {
                    classStr = "tree_resource_standard";
                }
                brdIcon.classList.add(classStr);
                
                if (lang != "") {
                     brdIcon.classList.add("multiLang");
                }
                
                brdIcon.style.cursor = "pointer";
                brdDivTag.appendChild(brdIcon);

                var brdNode = document.createElement("span");
                
                // if (!lang) {
                //     lang = "";
                // } 
                
                brdNode.innerHTML = brdList[j]["brdNm" + lang];
                brdNode.classList.add("node_normal");
                brdNode.classList.add("brd_node");
                brdNode.style.cursor = "pointer";
                brdNode.dataset.id = brdList[j].brdID;
                brdNode.dataset.cid = topId;
                brdNode.addEventListener("click", checkBrd);
                brdDivTag.appendChild(brdNode);
                brdDivTag.style.marginLeft = "15px";

                treeMain.appendChild(brdDivTag);
            }

            // 분류 추가
            for (var i = 0; i < catList.length; i++) {
                var nodeDiv = document.createElement("div");
                var spanTag2 = document.createElement("span");
                spanTag2.innerHTML = catList[i]["catName"];
                spanTag2.dataset.id = catList[i].catId;
                spanTag2.classList.add("node_normal");
                spanTag2.classList.add("cat_node");
                spanTag2.style.cursor = 'pointer';
                if (treeMain.id == "TreeCtrl_MyFavoriteTree" && !$("[data-parent-id='" + topId + "']").length) {
                    spanTag2.dataset.first = "Y";
                }
                spanTag2.addEventListener("click", checkCategory);

                if (catList[i].childList.length > 0 || catList[i].brdYn == "Y") {
                    var spanTag1 = document.createElement("span");
                    spanTag1.classList.add("sub_iconLNB");
                    spanTag1.classList.add("tree_plus");
                    spanTag1.dataset.id = catList[i].catId;
                    spanTag1.addEventListener("click", nextTree);
                    nodeDiv.appendChild(spanTag1);
                } else {
                    spanTag2.style.marginLeft = "15px";
                }
                nodeDiv.classList.add("node_div");
                nodeDiv.appendChild(spanTag2);
                divTag.appendChild(nodeDiv);

                var emptyDiv = document.createElement("div");
                emptyDiv.dataset.parentId = catList[i].catId;
                emptyDiv.style.marginLeft = "15px";
                divTag.appendChild(emptyDiv);

                treeMain.appendChild(divTag);
            }
        },
        error: function (xhr, status, error) {
            console.error("즐겨찾기 자원 목록 조회 오류 :", status, error);
        }
    });
}


var addModal = document.getElementById("addModal");
var moveModal = document.getElementById("moveModal");

var addCloseModalBtn = document.getElementById("addCloseModalBtn");
var types;
var inputnamedlg_dialogArguments = new Array();
var myboard_movecopy_dialogArguments = new Array();

function move_onclick_Complete() {
	window.location.reload();
}

function btn_clicked(type) {
	switch (type) {
	// 분류추가
	case "CC":
		inputnamedlg_dialogArguments[0] = document.querySelector("#selectCategoryId").value;
		inputnamedlg_dialogArguments[1] = btn_ok_onclick;
		inputnamedlg_dialogArguments[2] = "C";
		types = "CC";
		DivPopUpShow("310", "200", "/ezResource/inputNameDlg.do");
		break;
	// 하위추가
	case "C":
		if (document.querySelector("#selectCategoryId").value) {
			inputnamedlg_dialogArguments[0] = document.querySelector("#selectCategoryId").value;
			inputnamedlg_dialogArguments[1] = btn_ok_onclick;
			inputnamedlg_dialogArguments[2] = type;
			types = type;
			DivPopUpShow("310", "200", "/ezResource/inputNameDlg.do");
		} else {
			if (document.querySelector("#selectBrdId").value) {
				alert(strLangFvYGS18);
			} else {
				alert(strLangFvYGS06);
			}
		}
		break;
	// 수정
	case "U":
		types = type;
		var selectEl = document.querySelector(".node_selected");
		var categoryId = document.querySelector("#selectCategoryId").value;
		if (selectEl && categoryId) {
			var catName = selectEl.innerHTML;
			inputnamedlg_dialogArguments[0] = catName;
			inputnamedlg_dialogArguments[1] = btn_ok_onclick;
			inputnamedlg_dialogArguments[2] = type;
			DivPopUpShow("310", "200", "/ezResource/inputNameDlg.do");
		} else {
			alert(strLangFvYGS06);
		}
		break;
	// 카테고리 삭제
	case "D":
		var categoryId = document.querySelector("#selectCategoryId").value;
		var delBrdId = document.querySelector("#selectBrdId").value;
		if (categoryId) {
			types = "D";
			var flag = confirm(strLangFvYGS12);
			if (flag) {
				let selectNode = document.querySelector(".cat_node[data-id = '" + categoryId + "']").previousElementSibling;
				if (selectNode) {
					var rflag = confirm(strLangFvYGS19);
					if (rflag) {
						deleteFavoriteCategory();
					}
				} else {
					deleteFavoriteCategory();
				}
			}
			
		} else if (delBrdId) {
			types = "BD";
			brdDelete();
		} else {
			alert(strLangFvYGS13);
		}
		break;
	// 자원 즐겨찾기에 추가
	case "B":
		if (document.querySelector("#selectCategoryId").value) {
			types = type;
			var flag2 = confirm(strLangFvYGS11);
			if (flag2) {
				addFavoriteBrdId();
			}
		} else {
			var delBrdId = document.querySelector("#selectBrdId").value;
			if (delBrdId) {
				alert(strLangFvYGS18);
			} else {
				alert(strLangFvYGS06);
			}
			window.location.reload();
		}
		break;
	// 카테고리,자원 이동
	case "M":
		var brdId = document.querySelector("#selectBrdId").value;
		var categoryId = document.querySelector("#selectCategoryId").value;
		if (!brdId && !categoryId) {
			alert(strLangFvYGS14);
			return;
		}
		if (brdId) {
			types = "BM";
		} else {
			types = "M";
		}
        if (CrossYN()) {
            myboard_movecopy_dialogArguments[0] = "";
            myboard_movecopy_dialogArguments[1] = move_onclick_Complete;
            var childeWindow = DivPopUpShow(320, 375, "/ezResource/resFavoriteMove.do");
        }
		break;
	}
	
}

function brdDelete() {
    var delBrdId = document.querySelector("#selectBrdId").value;
    var delTopId = document.querySelector("#selectBrdTopCatId").value;

    if (!delBrdId || !delTopId) {
        alert(strLangFvYGS02);
        return;
    }

    var data = {
        delBrdId: delBrdId,
        delTopId: delTopId
    };

    var flag = confirm(strLangFvYGS10);
    if (!flag) {
        return;
    }
    
    $.ajax({
        url: "/ezResource/delBrdFavoriteCategory.do",
        type: "POST",
        contentType: "application/json",
        headers: {
            "accept":"application/json"
        },
        data: JSON.stringify(data),
        success: function (jsonObj) {
            alert(strLangFvYGS16);
            window.location.reload();
        },
        error: function (xhr, status, error) {
            console.error("자원 삭제 오류 :", status, error);
        }
    });
}

function addFavoriteBrdId() {
    var categoryId = document.querySelector("#selectCategoryId").value;
    var brdId = document.querySelector("#brdId").value;
    
    var data = $.param({
    	catId: categoryId,
        brdId: brdId
    });
    
    $.ajax({
        url: "/ezResource/addBrdFavoriteCategory.do",
        type: "POST",
        data: data,
        headers: {
            "accept":"application/json"
        },
        success: function (jsonObj) {
            if (jsonObj.result === "fail") {
                alert(strLangFvYGS03);
            } else {
                alert(strLangFvYGS04);
                window.location.reload();
            }
        },
        error: function (xhr, status, error) {
            console.error("즐겨찾기 자원 추가 오류 :", status, error);
        }
    });
}

function deleteFavoriteCategory() {
    var categoryId = document.querySelector("#selectCategoryId").value;
    $.ajax({
        url: "/ezResource/delFavoriteCategory.do",
        type: "POST",
        data: {
            catId: categoryId
        },
        headers: {
            "accept":"application/json"
        },
        success: function (jsonObj) {
            alert(strLangFvYGS16);
            window.location.reload();
        },
        error: function (xhr, status, error) {
            console.error("카테고리(분류) 삭제 오류 :", status, error);
        }
    });
}

function ConvMakeXMLString(str) {
    str = ReplaceText(str, "&lt;", "<");
    str = ReplaceText(str, "&gt;", ">");
    str = ReplaceText(str, "&#039;", "'");
    str = ReplaceText(str, "&#034;", "\"");
    str = ReplaceText(str, "&#92;", "\\");
    str = ReplaceText(str, "&amp;", "&");	    
    return str;
}

function btn_ok_onclick(catName) {
    var categoryId = document.querySelector("#selectCategoryId").value;
    if (types === "CC") {
        categoryId = "";
    }

    if (!catName) {
        alert(strLangFvYGS05);
        return;
    }
    catName = ConvMakeXMLString(catName);
    
    var url = "";
    if (types === "C" || types === "CC") {
        url = "/ezResource/addFavoriteCategory.do";
    } else if (types === "U") {
        url = "/ezResource/modFavoriteCategory.do";
    }
    
    var data = $.param({
        catName: catName,
        catId: categoryId
    });

    $.ajax({
        url: url,
        type: "POST",
        data: data,
        headers: {
            "accept":"application/json"
        },
        success: function (jsonObj) {
            if (jsonObj.type === "U") {
                alert(strLangFvYGS15);
            } else {
                alert(strLangFvYGS04);
            }
            window.location.reload();
        },
        error: function (xhr, status, error) {
        	if (types === "U") {
        		console.error("카테고리(분류)명 수정 오류 :", status, error);
        	} else {
        		console.error("카테고리(분류) 추가 오류 :", status, error);
        	}
        }
    });
}
