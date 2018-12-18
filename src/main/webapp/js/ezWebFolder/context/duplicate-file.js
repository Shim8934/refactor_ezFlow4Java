"use strict";
var duplicateFile = (function() {
	var requiredParamProperties = [ "workType", "infoArray", "folderId" ];
	
	// upload, copy, move, restore
	var infoQueue = [];
	// 현재 상태를 담는 변수
	var current = null;
	
	var work = {
		upload: {
			overwrite: function(result) {
				var fd = new FormData();
				
				fd.append("folderId", current.folderId);
				fd.append("fileToUpload", current.info.fileObject);
				fd.append("fileIdArray", JSON.stringify([ {
					fileIdArray: current.info.oldId
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
							alert(strSuccess);
							refreshView();
							break;
						case 1:
							alert(messages.parameterError);
							break;
						case 2:
							alert(messages.serverError);
							break;
						case 3:
							alert(messages.permissionError);
							break;
						case 4:
							alert(messages.outOfStorageSpaceForOneTime);
							break;
						case 5:
							alert(messages.outOfStorageSpace);
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
				var fileExtension = current.info.fileName.slice((current.info.fileName.lastIndexOf(".") - 1 >>> 0) + 2);
				var newFileName = result.newFileName + "." + fileExtension

				var fd = new FormData();
				
				fd.append("folderId", current.folderId);
				fd.append("fileToUpload", current.info.fileObject);
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
						switch (data.code) {
						case 0:
							alert(strSuccess);
							refreshView();
							break;
						case 1:
							alert(messages.parameterError);
							break;
						case 2:
							alert(messages.serverError);
							break;
						case 3:
							alert(messages.permissionError);
							break;
						case 4:
							alert(messages.outOfStorageSpaceForOneTime);
							break;
						case 5:
							alert(messages.outOfStorageSpace);
							break;
						case 8:
							alert(messages.resultErrDuplicateRename);
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
		},
		move: {
			overwrite: function(result) {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/moveFile.do",
					data: {
						"fileList": current.info.newId,
						"folderId": current.folderId,
						"privileges": current.mode,
						"mode": "move",
						"overwritable": true
					},
					dataType: "JSON",
					async: true,
					success: function(data) {
						var code = data.code;
						
						switch (code) {
						case 0:
							alert(messages.successMoveFile);
							refreshView();
							break;
						case 1:
							alert(messages.parameterError);
							break;
						case 2:
							alert(messages.serverError);
							break;
						case 3:
							alert(messages.permissionError);
							break;
						case 4:
							alert(messages.strLang13);
							break;
						}
					},
					error: function(error) {
						alert(strErr);
					}
				}).complete(function(res) {
					nextJob(result);
				});
			},
			skip: function(result) {
				setTimeout(function() {
					nextJob(result);
				}, 0);
			},
			rename: function(result) {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/moveFile.do",
					data: {
						"fileList": current.info.newId,
						"nameList": JSON.stringify([ result.newFileName ]),
						"folderId": current.folderId,
						"privileges": current.mode,
						"mode": "move"
					},
					dataType: "JSON",
					async: true,
					success: function(data) {
						var code = data.code;
						
						switch (code) {
						case 0:
							alert(messages.successMoveFile);
							refreshView();
							break;
						case 1:
							alert(messages.parameterError);
							break;
						case 2:
							alert(messages.serverError);
							break;
						case 3:
							alert(messages.permissionError);
							break;
						case 4:
							alert(messages.strLang13);
							break;
						case 8:
							alert(messages.resultErrDuplicateRename);
							break;
						}
					},
					error: function(error) {
						alert(strErr);
					}
				}).complete(function(res) {
					nextJob(result);
				});
			}
		},
		copy: {
			overwrite: function(result) {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/moveFile.do",
					data: {
						"fileList": current.info.newId,
						"folderId": current.folderId,
						"mode": "copy",
						"overwritable": true
					},
					dataType: "JSON",
					async: true,
					success: function(data) {
						switch (data.code) {
						case 0:
							alert(messages.successCopyFile);
							refreshView();
							break;
						case 1:
							alert(messages.parameterError);
							break;
						case 2:
							alert(messages.serverError);
							break;
						case 3:
							alert(messages.permissionError);
							break;
						case 4:
							alert(messages.outOfStorageSpace);
							break;
						case 8:
							alert(messages.resultErrDuplicateRename);
							break;
						}
					},
					error: function(error) {
						alert(strErr);
					}
				}).complete(function(res) {
					nextJob(result);
				});
			},
			skip: function(result) {
				setTimeout(function() {
					nextJob(result);
				}, 0);
			},
			rename: function(result) {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/moveFile.do",
					data: {
						"fileList": current.info.newId,
						"nameList": JSON.stringify([ result.newFileName ]),
						"folderId": current.folderId,
						"mode": "copy"
					},
					dataType: "JSON",
					async: true,
					success: function(data) {
						switch (data.code) {
						case 0:
							alert(messages.successCopyFile);
							refreshView();
							break;
						case 1:
							alert(messages.parameterError);
							break;
						case 2:
							alert(messages.serverError);
							break;
						case 3:
							alert(messages.permissionError);
							break;
						case 4:
							alert(messages.outOfStorageSpace);
							break;
						case 8:
							alert(messages.resultErrDuplicateRename);
							break;
						}
					},
					error: function(error) {
						alert(strErr);
					}
				}).complete(function(res) {
					nextJob(result);
				});
			}
		},
		trashMove: {
			overwrite: function(result) {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/moveTrashCanForDuplicate.do",
					dataType: "json",
					data: {
						"id": current.info.newId,
						"type": current.info.newType,
						"folderId": current.folderId,
						"overwritable": true
					},
					success: function(data) {
						switch (data.code) {
						case 0:
							alert(messages.successMoveFile);
							refreshView();
							break;
						case 1:
							alert(messages.parameterError);
							break;
						case 2:
							alert(messages.serverError);
							break;
						case 3:
							alert(messages.permissionError);
							break;
						}
					},
					error: function(error) {
						alert(strErr);
					}
				}).complete(function(res) {
					nextJob(result);
				});
			},
			skip: function(result) {
				setTimeout(function() {
					nextJob(result);
				}, 0);
			},
			rename: function(result) {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/moveTrashCanForDuplicate.do",
					dataType: "json",
					data: {
						"id": current.info.newId,
						"type": current.info.newType,
						"folderId": current.folderId,
						"newName": result.newFileName
					},
					success: function(data) {
						switch (data.code) {
						case 0:
							alert(messages.successMoveFile);
							refreshView();
							break;
						case 1:
							alert(messages.parameterError);
							break;
						case 2:
							alert(messages.serverError);
							break;
						case 3:
							alert(messages.permissionError);
							break;
						case 8:
							alert(messages.resultErrDuplicateRename);
							break;
						}
					},
					error: function(error) {
						alert(strErr);
					}
				}).complete(function(res) {
					nextJob(result);
				});
			}
		}
	};
	
	var completeJob = function() {
		// 큐 비우기
		infoQueue = [];
		// 현재 정보 비우기
		current = null;
		
		// 완료 알림 띄우기
		// alert(messages.completeDuplicateJob);
	}

	var executeJob = function(result) {
		// workType에 맞는 덮어쓰기, 건너뛰기, 이름바꾸기 작업 실행
		var jobs = work[current.workType];
		var detailJob = jobs[result.code.toLowerCase()];
		
		detailJob(result);
	}

	var onClosePopup = function(result) {
		// if (!isEmptyInfo()) {
		executeJob(result);
		// }
	}

	var isEmptyInfo = function(result) {
		return infoQueue.length === 0;
	}

	var nextJob = function(result) {
		// 큐가 비어있으면 작업 끝내기
		if (isEmptyInfo()) {
			completeJob();
			return;
		}
		
		// 처리할 다음 info 가 비어있으면 작업 안 함
		if ((current.info = infoQueue.pop()) === undefined) {
			return;
		}
		
		// 반복 수행 중이라면 팝업 안 띄우고 작업 수행
		if (result && result.looping) {
			executeJob(result);
			return;
		}
		
		// 파일 중복 처리하는 팝업 띄우기
		var url = "/ezWebFolder/fileDuplicateConfirm.do?";
		var currentInfo = current.info;
		
		url += "fileName=" + currentInfo.fileName;
		url += "&newType=" + currentInfo.newType;
		url += "&newDate=" + currentInfo.newDate;
		url += "&newSize=" + currentInfo.newSize;
		url += "&oldType=" + currentInfo.oldType;
		url += "&oldDate=" + currentInfo.oldDate;
		url += "&oldSize=" + currentInfo.oldSize;
		url += "&oldOwnerId=" + currentInfo.oldOwnerId;
		
		// 기존 팝업이 닫히는거 기다리기
		setTimeout((function(height) {
			return function() {
				openLeftPanel();
				DivPopUpShow(450, height, url);
			}
		})(currentInfo.newType === "FILE" ? 300 : 200), 0);
	}

	var process = function(params) {
		// 아직 끝나지 않았을 때 메소드 진입 막기
		if (infoQueue.length > 0 || current) {
			throw new Error("other processing is in progress.");
		}
		
		// 필수 파라미터가 있는지 확인
		requiredParamProperties.forEach(function(property) {
			if (!params.hasOwnProperty(property)) {
				throw new Error("'" + property + "' property is required.");
			}
		});
		
		infoQueue = Array.prototype.slice.call(params.infoArray);
		// pop 메소드를 사용하기 위해서 스택 구조에서 큐 형태로 만듦
		// unshift 를 이용하여 앞 원소부터 빼면 되지만 뭔가 헷갈림
		infoQueue.reverse();
		
		// params.infoArray 프로퍼티 삭제
		delete params.infoArray;
		
		// 현재 정보를 params 레퍼런스로 쓰기
		current = params;
		
		// 처리 실행
		nextJob();
	}

	return {
		onClosePopup: onClosePopup,
		process: process
	};
}());