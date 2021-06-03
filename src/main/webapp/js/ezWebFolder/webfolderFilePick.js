(function(window){
	var util = {
			'getHostDomain' : function() {
				var scriptList = document.getElementsByTagName("script"),
					thisUrl = scriptList[scriptList.length-1].src;
				return thisUrl.match(/^https?:\/\/[a-z0-9-_:\.]*/i)[0];
			}
		};
	var MY_DOMAIN = util.getHostDomain();
	var url = "/ezWebFolder/webfolderFileListPickup.do?folderType=C&allFileFlag=N&parentId=root";
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
				DivPopUpShow_sub(760, 610, url);
			},
			'popupClose' : function() {
				DivPopUpHidden_sub();
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