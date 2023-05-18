"use strict";
var duplicateFile = (function() {
	var completeListener = null;
	var requiredParamProperties = [ "workType", "infoArray", "folderId" ];
	
	// upload, copy, move, restore
	var infoQueue = [];
	// 현재 상태를 담는 변수
	var current = null;

	// ok: 파일, 폴더아이디
	// okMessage: 처리 완료 메세지 (ok 배열들과 같은 처리니깐 하나만 있으면 됨)
	// error: 
	var alerts = {
			ok: [],
			okMessage: "",
			error: []
	};
	
	var work = {
		upload: {
			overwrite: function(result) {
				var fd = new FormData();
				
				fd.append("folderId", current.folderId);
				appendFileForDupli(fd, "fileToUpload", current.info.fileObject);
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
					success: (function(currentInfo) {
						return function(data) {
							var code = data.code;
							
							switch (code) {
							case 0:
								refreshView();
								addSuccessAlert(currentInfo, strSuccess);
								break;
							case 1:
								addErrorAlert(currentInfo, messages.parameterError);
								break;
							case 2:
								addErrorAlert(currentInfo, messages.serverError);
								break;
							case 3:
								addErrorAlert(currentInfo, messages.permissionError);
								break;
							case 4:
								addErrorAlert(currentInfo, messages.outOfStorageSpaceForOneTime);
								break;
							case 5:
								addErrorAlert(currentInfo, messages.outOfStorageSpace);
								break;
							}
						};
					})(current.info),
					error: (function(currentInfo) {
						return function(error) {
							addErrorAlert(currentInfo, strErr);
						};
					})(current.info)
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
				var newFileName = result.newFileName;
				
				// https://stackoverflow.com/questions/190852/how-can-i-get-file-extensions-with-javascript
				var fileExtension = current.info.fileName.slice((current.info.fileName.lastIndexOf(".") - 1 >>> 0) + 2);
				
				if (fileExtension.length > 0) {
					newFileName += "." + fileExtension;
				}

				var fd = new FormData();
				
				fd.append("folderId", current.folderId);
				appendFileForDupli(fd, "fileToUpload", current.info.fileObject);
				fd.append("nameArray", JSON.stringify([ newFileName ]));
				
				if (current.isReply) {
					fd.append("parentId", current.parentId);
				}

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
					success: (function(currentInfo) {
						return function(data) {
							var code = data.code;
							
							switch (code) {
							case 0:
								refreshView();
								addSuccessAlert(currentInfo, strSuccess);
								break;
							case 1:
								addErrorAlert(currentInfo, messages.parameterError);
								break;
							case 2:
								addErrorAlert(currentInfo, messages.serverError);
								break;
							case 3:
								addErrorAlert(currentInfo, messages.permissionError);
								break;
							case 4:
								addErrorAlert(currentInfo, messages.outOfStorageSpaceForOneTime);
								break;
							case 5:
								addErrorAlert(currentInfo, messages.outOfStorageSpace);
								break;
							case 8:
								addErrorAlert(currentInfo, messages.resultErrDuplicateRename);
								break;
							}
						};
					})(current.info),
					error: (function(currentInfo) {
						return function(error) {
							addErrorAlert(currentInfo, strErr);
						};
					})(current.info)
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
					success: (function(currentInfo) {
						return function(data) {
							var code = data.code;
							
							switch (code) {
							case 0:
								refreshView();
								addSuccessAlert(currentInfo, messages.successMoveFile);
								break;
							case 1:
								addErrorAlert(currentInfo, messages.parameterError);
								break;
							case 2:
								addErrorAlert(currentInfo, messages.serverError);
								break;
							case 3:
								addErrorAlert(currentInfo, messages.permissionError);
								break;
							case 4:
								addErrorAlert(currentInfo, messages.strLang13);
								break;
							}
						};
					})(current.info),
					error: (function(currentInfo) {
						return function(error) {
							addErrorAlert(currentInfo, strErr);
						};
					})(current.info)
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
					success: (function(currentInfo) {
						return function(data) {
							var code = data.code;
							
							switch (code) {
							case 0:
								refreshView();
								addSuccessAlert(currentInfo, messages.successMoveFile);
								break;
							case 1:
								addErrorAlert(currentInfo, messages.parameterError);
								break;
							case 2:
								addErrorAlert(currentInfo, messages.serverError);
								break;
							case 3:
								addErrorAlert(currentInfo, messages.permissionError);
								break;
							case 4:
								addErrorAlert(currentInfo, messages.strLang13);
								break;
							case 8:
								addErrorAlert(currentInfo, messages.resultErrDuplicateRename);
								break;
							}
						};
					})(current.info),
					error: (function(currentInfo) {
						return function(error) {
							addErrorAlert(currentInfo, strErr);
						};
					})(current.info)
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
					success: (function(currentInfo) {
						return function(data) {
							var code = data.code;
							
							switch (code) {
							case 0:
								refreshView();
								addSuccessAlert(currentInfo, messages.successCopyFile);
								break;
							case 1:
								addErrorAlert(currentInfo, messages.parameterError);
								break;
							case 2:
								addErrorAlert(currentInfo, messages.serverError);
								break;
							case 3:
								addErrorAlert(currentInfo, messages.permissionError);
								break;
							case 4:
								addErrorAlert(currentInfo, messages.outOfStorageSpace);
								break;
							case 8:
								addErrorAlert(currentInfo, messages.resultErrDuplicateRename);
								break;
							}
						};
					})(current.info),
					error: (function(currentInfo) {
						return function(error) {
							addErrorAlert(currentInfo, strErr);
						};
					})(current.info)
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
					success: (function(currentInfo) {
						return function(data) {
							var code = data.code;
							
							switch (code) {
							case 0:
								refreshView();
								addSuccessAlert(currentInfo, messages.successCopyFile);
								break;
							case 1:
								addErrorAlert(currentInfo, messages.parameterError);
								break;
							case 2:
								addErrorAlert(currentInfo, messages.serverError);
								break;
							case 3:
								addErrorAlert(currentInfo, messages.permissionError);
								break;
							case 4:
								addErrorAlert(currentInfo, messages.outOfStorageSpace);
								break;
							case 8:
								addErrorAlert(currentInfo, messages.resultErrDuplicateRename);
								break;
							}
						};
					})(current.info),
					error: (function(currentInfo) {
						return function(error) {
							addErrorAlert(currentInfo, strErr);
						};
					})(current.info)
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
					success: (function(currentInfo) {
						return function(data) {
							var code = data.code;
							
							switch (code) {
							case 0:
								refreshView();
								addSuccessAlert(currentInfo, messages.successMoveFile);
								break;
							case 1:
								addErrorAlert(currentInfo, messages.parameterError);
								break;
							case 2:
								addErrorAlert(currentInfo, messages.serverError);
								break;
							case 3:
								addErrorAlert(currentInfo, messages.permissionError);
								break;
							}
						};
					})(current.info),
					error: (function(currentInfo) {
						return function(error) {
							addErrorAlert(currentInfo, strErr);
						};
					})(current.info)
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
					success: (function(currentInfo) {
						return function(data) {
							var code = data.code;
							
							switch (code) {
							case 0:
								refreshView();
								addSuccessAlert(currentInfo, messages.successMoveFile);
								break;
							case 1:
								addErrorAlert(currentInfo, messages.parameterError);
								break;
							case 2:
								addErrorAlert(currentInfo, messages.serverError);
								break;
							case 3:
								addErrorAlert(currentInfo, messages.permissionError);
								break;
							case 8:
								addErrorAlert(currentInfo, messages.resultErrDuplicateRename);
								break;
							}
						};
					})(current.info),
					error: (function(currentInfo) {
						return function(error) {
							addErrorAlert(currentInfo, strErr);
						};
					})(current.info)
				}).complete(function(res) {
					nextJob(result);
				});
			}
		}
	};
	
	/**
	 * duplicateFile는 객체로 쌓여 있어서 캡슐화 되었다.
	 * - 같은 이름의 함수를 마지막에 정의한다고 해서 재정의가 되지 않는다.
	 * 		overwriteAppendFileForDupliFunction: function(func) {
	 * 			appendFileForDupli = func;
	 * 		}
	 * 	 return에 이와 같은 함수를 호출할 수 있게 해서 확장하게 하였다.
	 * 	 (사용예시) duplicateFile.overwriteAppendFileForDupliFunction(appendFileForUpload);
	 */
	function appendFileForDupli(fd, paramKey, fileObject) {
	// (1) 웹폴더 > 파일업로드 : MultipartFile
		fd.append(paramKey, fileObject);	// paramKey = "fileToUpload"
	}

	function addSuccessAlert(currentInfo, message) {
		alerts.ok.push(currentInfo);
		alerts.okMessage = message;
	}

	function addErrorAlert(currentInfo, message) {
		alerts.error.push({info: currentInfo, message: message});
	}

	function flushAlerts() {
		if (alerts.ok.length > 0) {
			alert(alerts.okMessage);
		}

		var errors = alerts.error;
		var error;
		for (var i = 0; i < errors.length; i++) {
			error = errors[i];
			alert(error.message + "\n" + error.info.fileName);
		}

		alerts = {
				ok: [],
				okMessage: "",
				error: []
		};
	}

	var completeJob = function() {
		// 큐 비우기
		infoQueue = [];
		// 현재 정보 비우기
		current = null;
		
		flushAlerts();
		// 완료 알림 띄우기
		// alert(messages.completeDuplicateJob);

		if (completeListener) {		// 빈 function을 정의하는 것도 메모리를 잡는다. null을 체크하는 것이 오히려 나음.
			completeListener();
		}
	}

	var executeJob = function(result) {
		// workType에 맞는 덮어쓰기, 건너뛰기, 이름바꾸기 작업 실행
		var jobs = work[current.workType];
		var detailJob = jobs[result.code.toLowerCase()];
		
		detailJob(result);
	}

	var onClosePopup = function(result) {
		if (current) {
			executeJob(result);
		}
	}
	
	// 팝업 닫힐때 이걸로 판단하여 onClosePopup을 호출함
	var isProcessing = function(result) {
		return infoQueue.length > 0 || current !== null;
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
		
		var currentInfo = current.info;

		// 반복 수행 중이라면 팝업 안 띄우고 작업 수행
		if (result && result.looping) {
			if (result.code !== "OVERWRITE"
				|| (currentInfo.oldType === "FILE" && currentInfo.newType === "FILE" && currentInfo.accessible)) {
				executeJob(result);
				return;
			}
		}
		
		// 이전 작업들 완료 알림 띄우기
		flushAlerts();

		// 파일 중복 처리하는 팝업 띄우기
		var url = "/ezWebFolder/fileDuplicateConfirm.do?";
		var height;
		
		url += "fileName=" + encodeURIComponent(currentInfo.fileName);
		url += "&newType=" + encodeURIComponent(currentInfo.newType);
		url += "&newDate=" + encodeURIComponent(currentInfo.newDate);
		url += "&newSize=" + encodeURIComponent(currentInfo.newSize);
		url += "&oldType=" + encodeURIComponent(currentInfo.oldType);
		url += "&oldDate=" + encodeURIComponent(currentInfo.oldDate);
		url += "&oldSize=" + encodeURIComponent(currentInfo.oldSize);
		url += "&oldOwnerId=" + encodeURIComponent(currentInfo.oldOwnerId);
		url += "&oldId=" + encodeURIComponent(currentInfo.oldId);
		
		if (current.isReply) {
			url += "&isReply";
		}
		
		if (currentInfo.newType === "FILE") {
			// 파일이 하나일 때는 체크박스 사라지니까 더 작게
			if (isEmptyInfo()) {
				url += "&isOne";
				height = 315;
			} else {
				height = 332;
			}

			if (currentInfo.oldType === "FILE" && !currentInfo.accessible) {
				height += isEmptyInfo() ? 12 : 27;
			}
		} else {
			height = 200;
		}
		
		// 기존 팝업이 닫히는거 기다리기
		setTimeout((function(height) {
			return function() {
				openLeftPanel();
				DivPopUpShow(450, height, url);
			}
		})(height), 100);
		// 기존 팝업이 제대로 뜨지 않는 문제로 0->100수정
	}

	var process = function(params, callerIsPopup) {
		// 아직 끝나지 않았을 때 메소드 진입 막기
		if (isProcessing()) {
			throw new Error("other processing is in progress.");
		}
		
		// 필수 파라미터가 있는지 확인
		requiredParamProperties.forEach(function(property) {
			if (!params.hasOwnProperty(property)) {
				throw new Error("'" + property + "' property is required.");
			}
		});
		
		// 만약 팝업에서 해당 함수를 실행했다면 얕은 복사 (IE 에서 팝업이 닫히면 레퍼런스가 없어져서 버그 생김)
		if (callerIsPopup) {
			params = JSON.parse(JSON.stringify(params));
		}
		
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
		isProcessing: isProcessing,
		process: process,
		setOnCompleteListener: function(func) {
			completeListener = func;
		},
		overwriteAppendFileForDupliFunction: function(func) {
			appendFileForDupli = func;
		},
		overwriteAjaxUploadCompleteFunction: function(func) {
			ajaxUploadComplete = func;
		}
	};
}());