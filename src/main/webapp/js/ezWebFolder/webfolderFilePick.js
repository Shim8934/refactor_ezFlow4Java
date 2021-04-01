(function(window){
	var util = {
			'getHostDomain' : function() {
				var scriptList = document.getElementsByTagName("script"),
					thisUrl = scriptList[scriptList.length-1].src;
				return thisUrl.match(/^https?:\/\/[a-z0-9-_:\.]*/i)[0];
			}
		};
	var MY_DOMAIN = util.getHostDomain();
//	var url = "/ezWebFolder/main.do?folderId=97&folderType=D&allFileFlag=N&parentId=root";
	var url = "/ezWebFolder/webfolderFileListPickup.do?folderType=C&allFileFlag=N&parentId=root&folderSubtype=task";
	var selectedInfo = new Object();
	var filePick = {
		'confirmBT' : null,
		'cancelBT'	: null,
		'open'		: function(param) {
			filePick.confirmBT = param.confirmBT;
			filePick.cancelBT = param.cancelBT;
			fileListPick.popupOpen(url);
		}
	}
	var fileListPick = {
			'event' : {
				'confirm' : function(filePickArr) {
					fileListPick.popupClose();
					getFileInfo(filePickArr);
					
					var callback = filePick.confirmBT;
					if(callback) {
						callback(selectedInfo);
					}
				},
				'cancel' : function() {
					fileListPick.popupClose();
					
					var callback = filePick.cancelBT;
					if(callback) {
						callback();
					}
				}
			},
			'pickerSetting' : function() {
	        	var settings = {
						'fnName' : "init"
	        		};
	        },
			'popupOpen' : function(url) {
				/* 2020-11-17 홍승비 - 전자결재 > 웹한글기안기에서는 첨부 레이어 팝업 내부에 웹폴더 첨부기능을 사용하므로, 서브 레이어를 추가*/
				if (parent.location.href.indexOf("/ezApprovalG/") > -1) {
					DivPopUpShow_sub(760, 610, url);
				}
				else {
					var parentDocument = window.document,
					filePick = parentDocument.getElementById("filePicker");
					if (filePick === null) {
						var link = parentDocument.createElement("link");
						link.id = "popupStyle";
						link.rel = "stylesheet";
						link.type = "text/css";
						link.href = "/css/default_kr.css";
						parentDocument.body.appendChild(link);
						
						var div = parentDocument.createElement("div");
						div.innerHTML = '<div class="podim"></div><iframe id="popupIframe" frameborder="0" name="frm"></iframe>';
						parentDocument.body.appendChild(div);
						var pickerIframe = parentDocument.getElementById("popupIframe");
						pickerIframe.setAttribute("src", url);
					}
				}
			},
			'popupClose' : function() {
				if (parent.location.href.indexOf("/ezApprovalG/") > -1) {
					DivPopUpHidden_sub();
				}
				else {
					var parentDocument = window.document;
					var popicker = document.getElementById("popupIframe");
					if(popicker !== null) {
						parentDocument.body.removeChild(popicker.parentElement);
					}
				}
			}
	}
	
	var getFileInfo = function(filePickArr) {
		var data = {
			fileList : filePickArr
		}
		
		$.ajax ({
			type:"POST",
			async: false,
			url : "/ezWebFolder/selectWebfolderFiletoAnother.do",
			contentType: "application/json; charset=UTF-8",
			dataType: "JSON",
			data : JSON.stringify(data),
			success : function (result) {
				console.log(result);
				selectedInfo = result;
			},
			error : function(error) {
			}
		});
	}
	window.filePick = filePick;
	window.fileListPick = fileListPick;
	window.getFileInfo = getFileInfo;
})(window);