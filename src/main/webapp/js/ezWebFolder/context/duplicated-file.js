"use strict";
var duplicateFile = (function() {
	// upload, copy, move, restore
	var fileInfoQueue = [];
	var currentWorkType = "";
	var currentFolderId = "";
	var currentFileInfo = null;
	
	var work = {
		upload: {
			overwrite: function(result) {
				var fd = new FormData();
				
				fd.append("folderId", currentFolderId);
				fd.append("fileToUpload", currentFileInfo.fileObject);
				fd.append("fileIdArray", JSON.stringify([ {
					fileIdArray: currentFileInfo.fileId
				} ]));
				
				var dragZone = document.getElementById("dragDropArea");
				var height = dragZone.clientHeight;
				dragZone.style.height = height - 34 + "px";
				
				$.ajax({
					url: "/ezWebFolder/uploadFileOverwrite.do",
					type: "POST",
					data: fd,
					contentType: false,
					dataType: "JSON",
					cache: false,
					processData: false,
					xhr: ajaxUploadXhr,
					mimeType: "multipart/form-data",
					success: function(data) {
						var code = data.code;
						
						switch (code) {
						case 0:
							// alert(strSuccess);
							refreshView();
							break;
						case 1:
							alert(resultErr1);
							break;
						case 2:
							alert(resultErr2);
							break;
						case 3:
							alert(resultErr3);
							break;
						case 4:
							alert(resultErr4);
							break;
						case 5:
							alert(resultErr5);
							break;
						}
					},
					error: function(error) {
						alert(strErr);
					}
				}).complete(function(res) {
					ajaxUploadComplete();
					nextJob(result);
				});
			},
			skip: function(result) {
				setTimeout(function() {
					nextJob(result);
				}, 0);
			},
			rename: function(result) {
				// https://stackoverflow.com/questions/190852/how-can-i-get-file-extensions-with-javascript
				var fileExtension = currentFileInfo.fileName.slice((currentFileInfo.fileName.lastIndexOf(".") - 1 >>> 0) + 2);
				var newFileName = result.newFileName + "." + fileExtension

				var fd = new FormData();
				
				fd.append("folderId", currentFolderId);
				fd.append("fileToUpload", currentFileInfo.fileObject);
				fd.append("nameArray", JSON.stringify([ newFileName ]));
				
				var dragZone = document.getElementById("dragDropArea");
				var height = dragZone.clientHeight;
				dragZone.style.height = height - 34 + "px";
				
				$.ajax({
					url: "/ezWebFolder/uploadFile.do",
					type: "POST",
					data: fd,
					contentType: false,
					dataType: "JSON",
					cache: false,
					processData: false,
					xhr: ajaxUploadXhr,
					mimeType: "multipart/form-data",
					success: function(data) {
						var code = data.code;
						
						switch (code) {
						case 0:
							// alert(strSuccess);
							refreshView();
							break;
						case 1:
							alert(resultErr1);
							break;
						case 2:
							alert(resultErr2);
							break;
						case 3:
							alert(resultErr3);
							break;
						case 4:
							alert(resultErr4);
							break;
						case 5:
							alert(resultErr5);
							break;
						case 8:
							alert(messages.resultErrDuplicatedRename);
							console.log(data);
							break;
						}
					},
					error: function(error) {
						alert(strErr);
					}
				}).complete(function(res) {
					ajaxUploadComplete();
					nextJob(result);
				});
			}
		}
	};
	
	var completeJob = function() {
		currentWorkType = "";
		fileInfoQueue = [];
		currentFolderId = "";
		currentFileInfo = null;
		
		alert(messages.completeDuplicatedJob);
	}

	var executeJob = function(result) {
		// workType에 맞는 덮어쓰기, 건너뛰기, 이름바꾸기 작업 실행
		work[currentWorkType][result.code.toLowerCase()](result);
	}

	var onClosePopup = function(result) {
		executeJob(result);
	}

	var nextJob = function(result) {
		if (fileInfoQueue.length === 0) {
			completeJob();
			return;
		}
		
		currentFileInfo = fileInfoQueue.pop();
		
		if (currentFileInfo === undefined) {
			return;
		}
		
		if (result && result.looping) {
			executeJob(result);
			return;
		}
		
		var url = "/ezWebFolder/fileDuplicatedConfirm.do?";
		
		url += "fileName=" + currentFileInfo.fileName;
		url += "&newDate=" + currentFileInfo.newDate;
		url += "&newSize=" + currentFileInfo.newSize;
		url += "&oldDate=" + currentFileInfo.oldDate;
		url += "&oldSize=" + currentFileInfo.oldSize;
		url += "&oldOwnerId=" + currentFileInfo.oldOwnerId;
		
		// 팝업이 닫힌 후에 다시 팝업 띄우기
		setTimeout(function() {
			openLeftPanel();
			DivPopUpShow(450, 300, url);
		}, 0);
	}

	var process = function(workType, fileInfoArray, folderId) {
		// 아직 끝나지 않았을 때 메소드 진입 막기
		if (fileInfoQueue.length > 0) {
			return;
		}
		
		// 필요없는 처리 return
		if (fileInfoArray.length === 0) {
			return;
		}
		
		currentWorkType = workType;
		// 현재 처리중인 폴더 아이디
		currentFolderId = folderId;
		// FileList to Array
		fileInfoQueue = Array.prototype.slice.call(fileInfoArray);
		// pop 메소드를 사용하기 위해서 스택 구조에서 큐 형태로 만듦
		// unshift 를 이용하여 앞 원소부터 빼면 되지만 뭔가 헷갈림
		fileInfoQueue.reverse();
		
		// job 실행
		nextJob();
	}

	return {
		onClosePopup: onClosePopup,
		process: process
	};
}());