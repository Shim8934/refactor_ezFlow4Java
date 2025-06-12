// 2024-08-20 유길상 - 자원관리 즐겨찾기 관리
var fvMangeWindow;
document.addEventListener("DOMContentLoaded", function(event) {
	document.querySelector("#fav_manage").addEventListener("click", function(event) {
		event.stopPropagation();
		if (fvMangeWindow) {
			fvMangeWindow.focus();
		} else {
			fvMangeWindow = window.open("/ezResource/resFavoriteManage.do", "config", GetOpenWindowfeature(600, 425));
			fvMangeWindow.focus();
			var winTimer;
			winTimer = setInterval(function() {
	            if (fvMangeWindow.closed !== false) {
	                clearInterval(winTimer);
	                fvMangeWindow = null;
	                window.location.reload();
	            }
	        }, 500);
		}
	});
});

var getFavoriteList = function (topId) {
    if (!topId) {
        topId = "";
    }
    
    var data = $.param({
    	topId : topId
    });
    
    $.ajax({
        url: "/ezResource/getFavoriteCategoryList.do?",
        type: "POST",
        data: data,
        headers: {
            "accept": "application/json"
        },
        success: function (jsonObj) {
        	var catList = jsonObj.list;
    		if (!topId) {
    			if (catList.length > 0) {
    				var treeMain = document.querySelector("#TreeCtrl_MyFavoriteTree");
    				getMainTreeUI(catList, treeMain)
    			} else {
    				if (!topId) {
    					var treeMain = document.querySelector("#TreeCtrl_MyFavoriteTree");
    					treeMain.innerHTML = "";
    					var divTag = document.createElement("div");
    					divTag.innerHTML = strLangFvYGS17;
    					treeMain.appendChild(divTag);
    				}
    			}
    		} else {
    			var childListDiv = document.querySelector('[data-parent-id="' + topId + '"]');
    			getMainTreeUI(catList, childListDiv);
    		}
        },
        error: function (xhr, status, error) {
            console.error("AJAX Error:", status, error);
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
        document.querySelector('[data-parent-id="' + topId + '"]').innerHTML = '';
    }
}

function checkCategory(event) {
	if (event.target.classList.contains("node_selected")) {
		event.target.classList.remove("node_selected");
		event.target.classList.add("node_normal");
	} else {
		var nodeNomalArr = document.querySelectorAll('.node_normal');
		for (var i = 0; i < nodeNomalArr.length; i++) {
			var node = nodeNomalArr[i];
			node.classList.remove("node_selected");
			node.classList.add("node_normal");
		}
		event.target.classList.add("node_selected");
	}
}

function checkBrd(event) {
	var nodeSelectArr = document.querySelectorAll('.node_selected');
	for (var i = 0; i < nodeSelectArr.length; i++) {
		var node = nodeSelectArr[i];
		node.classList.remove("node_selected");
		node.classList.add("node_normal");
		event.target.classList.add("node_selected");
	}
	var resID = event.target.dataset.id;
	window.open("/ezResource/scheduleMain.do?resID=" + resID + "&accessCode=" + g_AccessCode , "right");
}

function getMainTreeUI(catList, treeMain) {
    treeMain.innerHTML = '';
    var topId = treeMain.dataset.parentId;
    
    if (!topId) {
        topId = catList[0].topId;
    }
    
    var data = $.param({
    	catId : topId
    });

    $.ajax({
        url: "/ezResource/getBrdFavoriteList.do",
        type: "POST",
        data: data,
        headers: {
            "accept": "application/json"
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
                brdIcon.style.cursor = 'pointer';
                brdDivTag.appendChild(brdIcon);

                var brdNode = document.createElement("span");
                if(lang == '1'){
                    brdNode.innerHTML = brdList[j]["brdNm"];
                }else{
                    brdNode.innerHTML = brdList[j]["brdNm2"];
                }
                brdNode.classList.add("node_normal");
                brdNode.style.cursor = 'pointer';
                brdNode.dataset.id = brdList[j].brdID;
                brdNode.addEventListener("click", checkBrd);
                brdDivTag.appendChild(brdNode);
                brdDivTag.style.marginLeft = "15px";

                treeMain.appendChild(brdDivTag);
            }

            // 분류 추가
            for (var i = 0; i < catList.length; i++) {
                var spanTag2 = document.createElement("span");
                spanTag2.innerHTML = catList[i]['catName'];
                spanTag2.dataset.id = catList[i].catId;
                spanTag2.classList.add("node_normal");
                spanTag2.style.cursor = 'pointer';

                if (treeMain.id == "TreeCtrl_MyFavoriteTree" && !$('[data-parent-id="' + topId + '"]').length) {
                    spanTag2.dataset.first = "Y";
                }

                spanTag2.addEventListener("click", checkCategory);

                if (catList[i].childList.length > 0 || catList[i].brdYn == "Y") {
                    var spanTag1 = document.createElement("span");
                    spanTag1.classList.add('sub_iconLNB');
                    spanTag1.classList.add('tree_plus');
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
            console.error("AJAX Error:", status, error);
        }
    });
}
