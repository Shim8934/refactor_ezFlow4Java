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
	        "accept":"application/json"
	    },
	    success: function (jsonObj) {
	        var catList = jsonObj.list;
	        if (!topId) {
	            var MoveTree = document.querySelector("#MoveTree");
	            getMainTreeUI(catList, MoveTree);
	        } else {
	            var childListDiv = document.querySelector("[data-parent-id='" + topId + "']");
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
		document.querySelector("#moveCategoryId").value = "";
		
	} else {
		var nodeNomalArr = document.querySelectorAll(".node_normal");
		for (var i = 0; i < nodeNomalArr.length; i++) {
			var node = nodeNomalArr[i];
			node.classList.remove("node_selected");
		}
		event.target.classList.add("node_selected");
		
		document.querySelector("#moveCategoryId").value = event.target.dataset.id;
		
	}
}
function checkBrd(event) {
	if (event.target.classList.contains("node_selected")) {
		event.target.classList.remove("node_selected");
		document.querySelector("#moveCategoryId").value = "";
	} else {
		var nodeNomalArr = document.querySelectorAll(".node_normal");
		for (var i = 0; i < nodeNomalArr.length; i++) {
			var node = nodeNomalArr[i];
			node.classList.remove("node_selected");
		}
		event.target.classList.add("node_selected");
		document.querySelector("#moveCategoryId").value = "";
	}
}

function getMainTreeUI(catList, treeMain) {
    treeMain.innerHTML = '';
    var topId = treeMain.dataset.parentId;
    if (!topId) {
        topId = catList[0].topId;
    }
    
    var data = $.param({
    	catId: topId
    });
    
    $.ajax({
        url: "/ezResource/getBrdFavoriteList.do",
        type: "POST",
        data: data,
        headers: {
            "accept":"application/json"
        },
        success: function (jsonObj) {
            var divTag = document.createElement("div");
            var brdList = jsonObj.list;
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
                brdIcon.style.cursor = "pointer";
                brdDivTag.appendChild(brdIcon);

                var brdNode = document.createElement("span");
                brdNode.innerHTML = brdList[j]["brdNm" + lang];
                brdNode.classList.add("node_normal");
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
                var spanTag2 = document.createElement("span");
                spanTag2.innerHTML = catList[i]["catName"];
                spanTag2.dataset.id = catList[i].catId;
                spanTag2.classList.add("node_normal");
                spanTag2.style.cursor = "pointer";
                if (treeMain.id == "TreeCtrl_MyFavoriteTree" && !document.querySelector("[data-parent-id='" + topId + "']")) {
                    spanTag2.dataset.first = "Y";
                }
                spanTag2.addEventListener("click", checkCategory);

                if (catList[i].childList.length > 0 || (catList[i].brdYn == "Y")) {
                    var spanTag1 = document.createElement("span");
                    spanTag1.classList.add("sub_iconLNB");
                    spanTag1.classList.add("tree_plus");
                    spanTag1.dataset.id = catList[i].catId;
                    spanTag1.addEventListener("click", nextTree);
                    divTag.appendChild(spanTag1);
                } else {
                    spanTag2.style.marginLeft = "15px";
                }

                divTag.appendChild(spanTag2);
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

function moveCategory() {
    if (types == "M") {
        var moveTopId = document.querySelector("#moveCategoryId").value;
        var moveCatId = parent.document.querySelector("#selectCategoryId").value;
        var curCatTopId = parent.document.querySelector("#selectBrdTopCatId").value;
        if (!moveTopId) {
        	var selectNode = document.querySelector(".node_selected");
        	if (selectNode) {
        		if (selectNode.dataset.cid) {
        			alert(strLangFvYGS18);
        		}
        	} else {
    			alert(strLangFvYGS06);
    		}
            return;
        }
        
        if (moveTopId == moveCatId) {
            alert(strLangFvYGS08);
            return;
        }

        var data = {
            catId: moveCatId,
            topId: moveTopId
        };
        
        var jsonData = JSON.stringify(data);

        $.ajax({
            url: "/ezResource/moveCategory.do",
            type: "POST",
            contentType: "application/json",
            data: jsonData,
            success: function (response) {
                if (response.result == "true") {
                    Wclose();
                } else if (response.result == "fail") {
                    alert(strLangFvYGS07);
                } else if (response.result == "equalfail") {
                    alert(strLangFvYGS08);
                }
            },
            error: function (xhr, status, error) {
                console.error("카테고리(분류) 이동 오류 :", status, error);
            }
        });

    } else if (types == "BM") {
        var moveCatId = document.querySelector("#moveCategoryId").value;
        var moveBrdId = parent.document.querySelector("#selectBrdId").value;
        var moveTopId = parent.document.querySelector("#selectBrdTopCatId").value;
        
        if (!moveCatId) {
        	var selectNode = document.querySelector(".node_selected");
        	if (selectNode) {
        		if (selectNode.dataset.cid) {
        			alert(strLangFvYGS18);
        		}
        	} else {
    			alert(strLangFvYGS06);
    		}
            return;
        }
        if (moveCatId == moveTopId) {
            alert(strLangFvYGS09);
            return;
        }

        var data = {
            catId: moveCatId,
            topId: moveTopId,
            brdId: moveBrdId
        };
        var jsonData = JSON.stringify(data);

        $.ajax({
            url: "/ezResource/moveCategory.do",
            type: "POST",
            contentType: "application/json",
            data: jsonData,
            success: function (response) {
                Wclose(response.result);
            },
            error: function (xhr, status, error) {
                console.error("자원 이동 오류  :", status, error);
            }
        });
    }
}
