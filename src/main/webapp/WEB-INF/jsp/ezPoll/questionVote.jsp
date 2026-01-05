<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPoll.t232' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezPoll/vote.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<script type="text/javascript" src="${util.addVer('/js/ezPoll/stomp.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPoll/sockjs.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>	
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>	
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		
		<script type="text/javascript">	
			var filesize 				= 0;
			var xhr1 					= new XMLHttpRequest();
			var _primary 				= "<c:out value='${primary}'/>";
			var hasVoted 				= "<c:out value='${hasVoted}'/>";
			var votePrivilege 			= "<c:out value='${hasVotePrivilege}'/>";
			var numberOfMultiSelect 	= "<c:out value='${question.multiSelect}'/>";
			var seeResultBeforVote  	= "<c:out value='${question.resultFirst}'/>";
			var secretVote 				= "<c:out value='${question.secretVote}'/>";
			var totalVotes 				= parseInt("<c:out value='${totalVotes}'/>");
			var s_Users 				= "<c:out value='${seenUsers}'/>";
			var qstId 					= "<c:out value='${question.qstId}'/>";
			var tenantId 				= "<c:out value='${question.tenantId}'/>";
			var curentUser 				= "<c:out value='${curentUser}'/>";
			var sessionId 				= "<c:out value='${sessionID}'/>";
			var curentUserName 			= "<c:out value='${curentUserName}'/>";
			var numberOfUnvotedUsers 	= parseInt("<c:out value='${numberOfUnvotedUsers}'/>");
			var numberOfSelected 		= 0;
			var maxLoop 				= 0;			
			var _status 				= "<c:out value='${question.status}'/>";						
			var commentIndex 			= parseInt("<c:out value='${numberOfCmt}'/>");
			var votedUsers 				= parseInt("<c:out value='${votedUsers}'/>");
			var window_open1			= null;		
			var window_open2			= null;
			var window_open3			= null;
			var numberOptions 			= "<c:out value='${numberOfOptions}'/>";
			var votesArr 				= [];	
			var stickerIndex 			= null;
			var userNameArr 			= [[]];
			var stompClient 			= null;
			/* 스티커 그룹 초기값 현재는 하나만 있기 때문에 1로 처리 */
			var numberOfGroupSticker 	= 1;	
			var currentGroupSticker 	= -1;
			var flagEvent 				= -1;
			var currentEditingCmt 		= -1;
			var selectedList 			= ${listSelectedOptions};
			var colors 					= ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89", "#90d4f7", "#71e096", "#f5a26f",		
											"#668de5", "#ed6d79", "#5ad0e5", "#da97e0", "#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924",     
			           						"#d41e47", "#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431", "#d41e47", "#eb148d"];
            var iframeStyle 			= "<style>";            
            iframeStyle += "P    	    { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "DIV  	    { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "TD   	    { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "UL   	    { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "OL   	    { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "LI   	    { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "BODY 	    { MARGIN: 10px; FONT-SIZE:10PT;LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic, Meiryo UI; overflow-x: auto; overflow-y: hidden;}";
            iframeStyle += "TABLE TD    { text-indent: 0px }";
            iframeStyle += "BLOCKQUOTE  { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}";
            iframeStyle += "</style>";          
            
    		window.onunload = function() {
    		    if (stompClient !== null) {
    		        stompClient.disconnect();
    		    }
        	}; 
            
			window.onload = function() {
				if(document.getElementById("sendBttn") != null){
					commentCheck();				
				}
 				getConnect();
 				stompDisConnProcess();
 				
	            var doc = document.getElementById("message_test").contentWindow.document;	        
				doc.open();
				doc.write(iframeStyle + sigBody.innerHTML);
				doc.close();	
				
 				//View vote result functions
 				preProcess();
 				updateGraph();
			}		
			
			window.onresize = function(event) {
				resizeCanvas();
			};
			
			function resizeCanvas(){
				for (var i = 0; i < numberOptions; i++) {
					var _optId = votesArr[i][0];					
					var graphId = "graph" + _optId;
					
					if (votesArr[i][1] != 0) {	
						var percent = votesArr[i][1]/totalVotes;
						var id = "myCanvas" + _optId;																	   					
	   					var canv = document.getElementById(id);	   					
	   					var max_width = document.getElementById(graphId).offsetWidth;
	   					var maxWidth_for_canvas = max_width - 75;	   					   					
						var best_width = Math.round(maxWidth_for_canvas * percent);	
						
						//Resize and fill canvas
 						canv.width = best_width;  
 						fillCanvas(i, best_width, canv);
					}
				}
			}			
			
			function fillCanvas(id, value, canv) {
				var ctx = canv.getContext("2d");
				/* ctx.shadowOffsetX = 2;
				ctx.shadowOffsetY = 2;
				ctx.shadowBlur = 2;
				ctx.shadowColor = "#999";
				var gradient = ctx.createLinearGradient(0, 0, value, 0);
				gradient.addColorStop(1, colors[id % 30]);
				gradient.addColorStop(0, "#ffffff"); */
				ctx.fillStyle = colors[id % 30];
				ctx.fillRect(0, 0, value, 20);
				ctx.strokeStyle = colors[id % 20];
				ctx.strokeRect(0, 0, value, 20);				
			}			
					
			function commentCheck() {
				document.getElementById("sendBttn").addEventListener("click", function(event) {
				    event.preventDefault();
				});
				document.getElementById("sendBttn").style.backgroundColor = "#d0d0d0";
				document.getElementById("sendBttn").disabled = true;
			}
			
			function preProcess() {	
				var maxWidth =  document.getElementById("_content1").offsetWidth;
				maxLoop = Math.floor((maxWidth - 250)/80);
				var test_value = ${listSelectedOptions};
				numberOfSelected = test_value.length;
				
				if (maxLoop > 5) {
					maxLoop = 5;
				}	
				
				//Check if poll is ended
				if ( _status == 0) { 
					for (var i = 0; i < numberOptions; i++) {
						var _optId = votesArr[i][0];						
						var resultBox = "resultBox" + _optId;									
						document.getElementById(resultBox).style.paddingLeft = "20px";
					}
				}	
				else {				
					if (seeResultBeforVote != 1) {
						for (var i = 0; i < numberOptions; i++) {
							var _optId = votesArr[i][0];
							var graphId = "graph" + _optId;
							var showVotes = "voterNumber_" + _optId;
							var showVotesObj = document.getElementById(showVotes);
							var voteInfo = "voteInfo" + _optId;							
							document.getElementById(graphId).style.display = "none";
							
							//투표 수가 있고 내가 투표한 항목일 경우
							if(votesArr[i][1] > 0 && selectedList.indexOf(_optId) != -1){
								showVotesObj.style.cssText = "display: block; color: "+ colors[i % 30] +"; font-weight: bold;";
							}
							
							showVotesObj.innerHTML = "<i class='fa fa-check' style='font-size:15px; color:" + colors[i % 30] + ";'></i>"
							   					   + "<spring:message code = 'ezBoard.t47'/>";
							document.getElementById(voteInfo).style.display = "none";
						}
					}					
					if (hasVoted == 1) {
						var test = ${listSelectedOptions};
						
						for (var i = 0; i < test.length; i++) {
							var imageCheckBoxId = "_imageCheckBox" + test[i];
							var imageCheckBox = document.getElementById(imageCheckBoxId);
							
							if (imageCheckBox.src.indexOf("/images/poll/unchecked_vote.png") !== -1) {
								imageCheckBox.src = "/images/checked.png";
							}
						}
					}					
				}
				
				var voteInfoDiv = $("#voteInfoDiv");
				voteInfoDiv.on("mouseover", function(){
					voteInfoDiv.find("ul").show();
				}).on("mouseout", function(){
					voteInfoDiv.find("ul").hide();
				});
				
				emoticonPanelClose();
				optImgSearch();
				addThumbnailEvent();
				dateTimePickerSetting();
// 				stopButtonPosition();
				
			}
			
			function updateGraph() {				
				for (var i = 0; i < numberOptions; i++) {
					var _optId = votesArr[i][0];					
					var graphId = "graph" + _optId;
					var voteInfo = "voteInfo" + _optId;
					var percentTdId = "_resultPercentage" + _optId; 
					var optionID = "optionContent" + _optId;		
					var emailElmt = document.getElementById("mailSend" + _optId);
					
					var selectedFlag = 0;
					for(var j = 0; j < selectedList.length; j++){
						selectedFlag = selectedList.indexOf(_optId) != -1 ? true : false;
					}
					
 					document.getElementById(optionID).style.color = colors[i % 30];
					
					if (totalVotes > 0 && (seeResultBeforVote == 1 || _status == 0)) {				
 						var percent = votesArr[i][1]/totalVotes; 
 						
 						if (seeResultBeforVote == 1 || _status == 0 || hasVoted == 1) { 								
							document.getElementById(percentTdId).innerHTML = "[" + (percent * 100).toFixed(1) + "%]";
 						} 							
 						
						if (votesArr[i][1] != 0) {			
							var id = "myCanvas" + _optId;							
							var showVotes = "voterNumber" + _optId;							   					
		   					var canv = document.getElementById(id);
		   					
		   					document.getElementById(showVotes).innerHTML = votesArr[i][1];		
		   					document.getElementById(showVotes).style.color = colors[i % 30];
		   					
		   					if (seeResultBeforVote == 1 || _status == 0 || hasVoted == 1) {
			   					document.getElementById(graphId).style.display = "block";	
			   					document.getElementById(voteInfo).style.display = "block";
		   					}
		   					
		   					var max_width = document.getElementById(graphId).offsetWidth;		   					
		   					var maxWidth_for_canvas = max_width - 75;	   					   					
							var best_width = Math.round(maxWidth_for_canvas * percent);	
							
							//Fill canvas with color
	 						canv.width = best_width;      
	 						fillCanvas(i, best_width, canv);
	       					
	       					//Show vote information
         					if (secretVote == 0) {
	       						var listUserAnswer = ${listOfUserAnswer};       						       						       						
	       						var tempLoop = 0;	       						
	       						
	       						if (maxLoop >= votesArr[i][1]) {
	       							tempLoop = votesArr[i][1];	       							
	       						}	       	
	       						else {
	       							tempLoop = maxLoop;
	       						}
	       							       						      						
	       						var tempClassId = "_thu" + i;	 
	       						var viewAll = "_tax" + i;
	       						var listDivs = document.getElementsByClassName(tempClassId);	       						

	       						for (var j = 0; j < tempLoop; j++) {
	       							listDivs[j].style.display = "block";   
	       							
	       							if (j < tempLoop - 1) {
	       								listDivs[j].innerHTML = Object.keys(userNameArr[i][j]).map(function(key){return userNameArr[i][j][key];})[0] + ",&nbsp;";
	       							} 
	       							else {
	       								listDivs[j].innerHTML = Object.keys(userNameArr[i][j]).map(function(key){return userNameArr[i][j][key];})[0];
	       							}	       							       							
	       						}   
	       						
	       						if (votesArr[i][1] > tempLoop) {
	       							emailElmt.style.display = "none";
	       							document.getElementById("vAll" + i).style.color = colors[i % 30];
	       							document.getElementById(viewAll).style.display = "block";	       							
	       						}
	       						else {	   
	       							emailElmt.style.display = "";
	       							document.getElementById(viewAll).style.display = "none";
	       						}
	       					}
         					else {
         						document.getElementById(voteInfo).innerHTML = "<spring:message code = 'ezPoll.t111' />";
         					}
						}
						else {
							document.getElementById(voteInfo).style.display = "none";
							
							//Check if the poll is allowed see result before vote														
							if (_status != 0) {							
								/* if (seeResultBeforVote != 0) {
									var showVotes = document.getElementById("voterNumber_" + _optId);																	
					   				showVotes.innerHTML = "<spring:message code='ezPoll.t249'/>";	
				   					showVotes.style.color = colors[i % 30];
									showVotes.style.display = "block";
									
									document.getElementById(graphId).style.display = "none";
									//document.getElementById(voteInfo).style.display = "block";
								} */
									var showVotes = document.getElementById("voterNumber_" + _optId);																	
					   				showVotes.innerHTML = "<spring:message code='ezPoll.t249'/>";	
				   					showVotes.style.color = colors[i % 30];
									showVotes.style.display = "block";
									
									document.getElementById(graphId).style.display = "none";
							}
							else {
								var showVotes = document.getElementById("voterNumber_" + _optId);
								showVotes.innerHTML = "0";
			   					showVotes.style.color = colors[i % 30];
								showVotes.style.display = "block";
							}
							//If it is secret vote, then show 무기명 even no one votes for this option
 							/*if (secretVote == 1 && seeResultBeforVote == 1) {
								document.getElementById(voteInfo).style.display = "block";
								document.getElementById(voteInfo).innerHTML = "<spring:message code = 'ezPoll.t111' />";
							} */
							
							if (emailElmt) {
								emailElmt.style.display = "none";
							}
						}
					}
					else {
						if (emailElmt) {
							emailElmt.style.display = "none";
						}
						
						document.getElementById(voteInfo).style.display = "none";
						document.getElementById(percentTdId).innerHTML = "";						
						
						//Check if the poll is allowed see result before vote
						if (_status != 0) {							
							/* if (seeResultBeforVote != 0) {
								var showVotes = document.getElementById("voterNumber_" + _optId);																	
				   				showVotes.innerHTML = "<spring:message code='ezPoll.t249'/>";	
			   					showVotes.style.color = colors[i % 30];
								showVotes.style.display = "block";
								
								document.getElementById(graphId).style.display = "none";
								//document.getElementById(voteInfo).style.display = "block";
							} */
							if (!selectedFlag) {
								var showVotes = document.getElementById("voterNumber_" + _optId);																	
				   				showVotes.innerHTML = "<spring:message code='ezPoll.t249'/>";	
			   					/* showVotes.style.color = colors[i % 30];
								showVotes.style.display = "block"; */
								showVotes.style.cssText = "display: block; color:" + colors[i % 30] + ";";
								
								document.getElementById(graphId).style.display = "none";
								//document.getElementById(voteInfo).style.display = "block";
							}
						}
						else {
							var showVotes = document.getElementById("voterNumber_" + _optId);
							showVotes.innerHTML = "0";
		   					showVotes.style.color = colors[i % 30];
							showVotes.style.display = "block";
						}
					}
				}
			}
			
			function getConnect() {
			    //var socket = new WebSocket('ws://localhost:8080/ezFlow/hello');			    
			    var socket = new SockJS('/hello');
			    stompClient = Stomp.over(socket);			
			    stompClient.connect({}, function (frame) {		        			    
			    	stompClient.subscribe('/reply/getSeenUpdateForQst' + qstId + "+" + tenantId, function (updatedInfo) {			
		        		var ret = JSON.parse(updatedInfo.body).updatedNumber;
		        	
			            if (ret != -1 && ret != s_Users) {
					    	s_Users = ret;
					    	document.getElementById("seenPeople").innerHTML = ret;	
					    	//document.getElementById("seenPeople").style.color="red";
					    	
				    		if (window_open1 != null && !window_open1.closed) {	
				    			window_open1.location.reload();
					    	}	    						    	
					    }
			        });
			        
			        stompClient.subscribe('/reply/finishVoteForQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;
			        	var brdId = "${brdId}";
			        	
			            if (ret == "OK") {							
			            	document.location.href = "/ezPoll/pollVote.do?qstId=" + qstId + "&brdId=" + brdId;
					    }
				    });
			        
			        stompClient.subscribe('/reply/updateUnVotedUsersForQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;	
			        	var user = JSON.parse(updatedInfo.body).userId;
			        	var _sessionid = JSON.parse(updatedInfo.body).sessionid;
			        	
			        	
			            if (ret == "ADD") {							
			            	numberOfUnvotedUsers = numberOfUnvotedUsers - 1;			            	
			            	document.getElementById("_unVotedNumber").innerHTML = numberOfUnvotedUsers;
			            	
			            	//if (user != curentUser || sessionId != _sessionid) {
			            	votedUsers = votedUsers + 1;
			            	document.getElementById("votedUsers").innerHTML = "(" + votedUsers + "<spring:message code = 'ezPoll.t110'/>" + ")";
			            	//}
					    }
			            else {
			            	numberOfUnvotedUsers = numberOfUnvotedUsers + 1;			            	
			            	document.getElementById("_unVotedNumber").innerHTML = numberOfUnvotedUsers;
			            	
			            	//if (user != curentUser || sessionId != _sessionid) {
		            		votedUsers = votedUsers - 1;
		            		document.getElementById("votedUsers").innerHTML = "(" + votedUsers + "<spring:message code = 'ezPoll.t110'/>" + ")";
			            	//}			            	
			            }
			            
			    		if (window_open2 != null && !window_open2.closed) {	
			    			window_open2.location.reload();
				    	}
				    });			        		        
			        
			        stompClient.subscribe('/reply/editQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;
			        	var user = JSON.parse(updatedInfo.body).userId;	
			        	var _sessionid = JSON.parse(updatedInfo.body).sessionid;			        	
			        	
			            if (ret == "CHANGED" && (user != curentUser || sessionId != _sessionid)) {			            
							alert("<spring:message code = 'ezPoll.t113'/>");
			            	document.location.href = "/ezPoll/pollList.do?brdID=6";
					    }
				    });
			        
			        stompClient.subscribe('/reply/deleteQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;	
			        	var user = JSON.parse(updatedInfo.body).userId;	
			        	
			            //if (ret == "DELETED" && user != curentUser) {		
			            if (ret == "DELETED") {
							alert("<spring:message code = 'ezPoll.t270'/>");
			            	document.location.href = "/ezPoll/pollList.do?brdID=6";
					    }
				    });
			        
			        stompClient.subscribe('/reply/addCmtForQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var _cmdId = JSON.parse(updatedInfo.body).cmId;	
			        	var _userId = JSON.parse(updatedInfo.body).userId;	
			        	var _attachFilePath = JSON.parse(updatedInfo.body).attachFilePath;
			        	var _fileType = JSON.parse(updatedInfo.body).fileType;
			        	var _fileName = JSON.parse(updatedInfo.body).fileName;
			        	var _filePath = JSON.parse(updatedInfo.body).filePath;
			        	var _txtContent = JSON.parse(updatedInfo.body).txtContent;
			        	var _cmtTime = JSON.parse(updatedInfo.body).cmtTime;
			        	var _userPhoto = JSON.parse(updatedInfo.body).userPhoto;
			        	var _sessionID = JSON.parse(updatedInfo.body).sessionid;
			        	var _deptId = JSON.parse(updatedInfo.body).deptId;
			        	var _userName = "";			        				        	
			        	
			        	if (_primary == 1) {
			        		_userName = JSON.parse(updatedInfo.body).userName1;
			        	}
			        	else {
			        		_userName = JSON.parse(updatedInfo.body).userName2;
			        	}
			        	
/* 			            if (_userId != curentUser || _sessionID != sessionId) {			          		
			            	if (_cmdId <= commentIndex) {
			          			alert("<spring:message code = 'ezPoll.t114'/>");
			          			return;
			          		}
			            	
			            	updateNewCmt(_userId, _userName, _attachFilePath, _fileType, _fileName, _filePath, _txtContent, _cmtTime, _userPhoto);
					    } */
		            	if (_cmdId < commentIndex) {
		          			alert("<spring:message code = 'ezPoll.t114'/>");
		          			return;
		          		}
		            	else {
		            		if (_cmdId > commentIndex) {
		            			commentIndex = commentIndex + 1;
		            		}
		            	}
		            	
		            	updateNewCmt(_userId, _userName, _attachFilePath, _fileType, _fileName, _filePath, _txtContent, _cmtTime, _userPhoto, _deptId);
				    });
			        
			        stompClient.subscribe('/reply/editCmtForQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var _cmdId = JSON.parse(updatedInfo.body).cmId;	
			        	var _userId = JSON.parse(updatedInfo.body).userId;	
			        	var _attachFilePath = JSON.parse(updatedInfo.body).attachFilePath;
			        	var _fileType = JSON.parse(updatedInfo.body).fileType;
			        	var _fileName = JSON.parse(updatedInfo.body).fileName;
			        	var _filePath = JSON.parse(updatedInfo.body).filePath;
			        	var _txtContent = JSON.parse(updatedInfo.body).txtContent;
			        	var _sessionId = JSON.parse(updatedInfo.body).sessionid;			        	

/* 			            if (_userId != curentUser || _sessionId != sessionId) {			          		
			            	if (_cmdId > commentIndex) {
			          			alert("<spring:message code = 'ezPoll.t114'/>");
			          			return;
			          		}
			            	
			            	updateCurrentCmt(_cmdId, _attachFilePath, _fileType, _fileName, _filePath, _txtContent);
					    } */
					    
			        	if (_cmdId > commentIndex) {
		          			alert("<spring:message code = 'ezPoll.t114'/>");
		          			return;
		          		}
		            	
		            	updateCurrentCmt(_cmdId, _attachFilePath, _fileType, _fileName, _filePath, _txtContent);					    
				    });
			        
			        stompClient.subscribe('/reply/deleteCmtInQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var _cmdId = JSON.parse(updatedInfo.body).cmId;	
			        	var _userId = JSON.parse(updatedInfo.body).userId;
			        	var _sessionId = JSON.parse(updatedInfo.body).sessionid;			        	

			            /* if (_userId != curentUser || _sessionId != sessionId) {			          		
			            	if (_cmdId > commentIndex) {
			          			alert("<spring:message code = 'ezPoll.t114'/>");
			          			return;
			          		}
			            	
			            	if (_cmdId == commentIndex) {
			            		commentIndex = commentIndex - 1;
			            	}
			            	
			            	deleteCurrentCmt(_cmdId);
					    } */
					    /*if (_cmdId > commentIndex) {
		          			alert("<spring:message code = 'ezPoll.t114'/>");
		          			return;
		          		} */
		            	
		            	if (_cmdId == commentIndex) {
		            		commentIndex = commentIndex - 1;
		            	}
		            	
		            	deleteCurrentCmt(_cmdId);
				    });
			        
			        stompClient.subscribe('/reply/getResultUpdateForQst' + qstId + "+" + tenantId, function (updatedInfo) {
			        	var optId = JSON.parse(updatedInfo.body).optionId;			        	
			        	var mode = JSON.parse(updatedInfo.body).mode;
			        	var user = JSON.parse(updatedInfo.body).userId;
			        	var _sessionId = JSON.parse(updatedInfo.body).sessionid;			        	
			        	var userName = "";
			        	
			        	if (_primary == 1) {
			        		userName = JSON.parse(updatedInfo.body).userName1;
			        	}
			        	else {
			        		userName = JSON.parse(updatedInfo.body).userName2;
			        	}
			        	
			        	//if (user != curentUser || _sessionId != sessionId) {
		        		var voteId = -1;
		        		
			        	if (mode == 1) {							
			        		//In adding mode
			        		var showVotes = "voterNumber_" + optId;
			        		var showVotesObj = document.getElementById(showVotes);
			        		if("${question.resultFirst}" !== "1"){
			        			$("#selectAnsImg_" + optId).css("display","block");
			        			showVotesObj.innerHTML = "<i class='fa fa-check' style='font-size:15px; color:" + colors[(optId - 1) % 30] + ";'></i>"
			        								   + "<spring:message code = 'ezBoard.t47'/>";
			        			showVotesObj.style.fontWeight = "bold";
			        		}
			        		else{
			        			showVotesObj.style.display = "none";
			        		}
			        		totalVotes = totalVotes + 1;
			        		
			        		if (user == curentUser) {
			        			numberOfSelected = numberOfSelected + 1;
	        					document.getElementById("_imageCheckBox" + optId).src = "/images/checked.png";
	        					if (hasVoted == 0) {
									//votedUsers = votedUsers + 1;
									hasVoted = 1;	 	    			
									//document.getElementById("votedUsers").innerHTML = "(" + votedUsers + "<spring:message code = 'ezPoll.t110'/>" + ")";
								} 	
	        				}
			        		
			        		for (var i = 0; i < numberOptions; i++) {
			        			if (votesArr[i][0] == optId) {		        								        				
			        				votesArr[i][1] = votesArr[i][1] + 1;
			        				voteId = i;	
			        				break;
			        			}
			        		}						        		
			        		
			        		if (secretVote == 0) {
								//Update the userName array
								var tempObj = new Object();
								tempObj[user] = userName;	
								
								if (userNameArr[voteId].map(function (o) {return o[user];}).indexOf(userName) === -1) {	
									userNameArr[voteId].push(tempObj);
								}
			        		}
			        		
			        		updateGraph();
			        	}
			        	else {			        	
			        		//In removing mode
			        		totalVotes = totalVotes - 1;
			        		
			        		if (user == curentUser) {
			        			numberOfSelected = numberOfSelected - 1;
	        					document.getElementById("_imageCheckBox" + optId).src = "/images/poll/unchecked_vote.png";
	        					checkVoted();
	        				}
			        		
			        		for (var i = 0; i < numberOptions; i++) {
			        			if (votesArr[i][0] == optId) {
			        				votesArr[i][1] = votesArr[i][1] - 1;
			        				voteId = i;
			        				break;
			        			}
			        		}	
			        		
			        		if (secretVote == 0) {
				        		//Remove userName if exist in userName array
				        		var pos = userNameArr[voteId].map(function (o) {return o[user];}).indexOf(userName);	
				        		
								if ( pos > -1) {	
									userNameArr[voteId].splice(pos, 1);									
			   						var tempClassId = "_thu" + voteId;
			   						var listDivs = document.getElementsByClassName(tempClassId);
			   						
			   						for (var j = 0; j < 5; j++) {
			   							listDivs[j].innerHTML == "";
			   							listDivs[j].style.display = "none";
			   						}		   						
								}		
			        		}
			        		
			        		updateGraph();
			        	}
			        	//}
			        	
			    		if (window_open3 != null && !window_open3.closed) {	
			    			window_open3.location.reload();
				    	}
			        });		        
			    });
			 }

			function voteEdit() {
				if (totalVotes > 0) {
					alert("<spring:message code = 'ezPoll.t115'/>");
					return;
				}
				
				var logincookie = document.cookie.match(/loginCookie=(.+?)(;|$)/)[0].split("=")[1];
				logincookie = logincookie.substr(0, logincookie.length-1);
				
				var tenantId = "<c:out value='${question.tenantId}'/>";
				stompClient.send("/app/editVote", {}, JSON.stringify({'question': qstId, 'tenant': tenantId, 'user': curentUser, 'sessionid': sessionId, 'loginCookie': logincookie}));
				
				var params = "<c:out value='${params}'/>";
				var searchStr = "<c:out value='${searchStr}'/>";
				var searchN = "<c:out value='${searchN}'/>";
				
				document.location.href = "/ezPoll/pollCreate.do?qstId=" + qstId + "&mode=modify" + "&params=" + params + "&search=" + searchStr + "&searchN=" + searchN;				
		    }		
			
			//재사용 버튼 누르면 동작하는 함수
			function voteReuse() {
				var tenantId = "<c:out value='${question.tenantId}'/>";
				var params = "<c:out value='${params}'/>";
				var searchStr = "<c:out value='${searchStr}'/>";
				var searchN = "<c:out value='${searchN}'/>";
				document.location.href = "/ezPoll/pollCreate.do?qstId=" + qstId + "&mode=reuse" + "&params=" + params + "&search=" + searchStr + "&searchN=" + searchN;				
			}
		    
		    function menuDetailSeenUserInfo(pQstID) {		    	 
		    	 var feature = GetOpenPosition(420, 438);
		    	 window_open1 = window.open("/ezPoll/showSeenUserInfo.do?qstId=" + pQstID, "", "height=438px,width=733px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
		    
		    function AttachDetail_view(obj) {
		        if (obj.className == "icon_graydown") {
		            obj.className = "icon_grayup";
		            document.getElementById("fileList").style.display = "";
		        }
		        else {
		            obj.className = "icon_graydown";
		            document.getElementById("fileList").style.display = "none";
		        }
		    }
		    
		    function DownloadAttach(downloadPath, fileName) {	
		    	var downloadUrl = "/ezPoll/downloadAttach.do?folderPath=" + encodeURIComponent(downloadPath) + "&filename=" + encodeURIComponent(fileName);
		    	//console.log("Download URL: " + downloadUrl);
		        AttachDownFrame.location.href = downloadUrl;
		    }
		    
		    function DownloadAttachNew(obj) {
	        	var downloadPath = obj.getAttribute("_path");
	        	var fileName = obj.getAttribute("_file");
	        	var downloadUrl = "/ezPoll/downloadAttach.do?folderPath=" + encodeURIComponent(downloadPath) + "&filename=" + encodeURIComponent(fileName);
	        	AttachDownFrame.location.href = downloadUrl;
		    }
		    
		    var suffix = 0;
		    
		    function AttachAllDownload() {
		    	var test = ${numOfFile};
		    	
		        if (suffix < test) {
		        	setTimeout(function () { FileDownload(document.getElementsByName("file_path").item(suffix++)) }, 2000);
		        }		            
		        else {	
		        	suffix = 0;
		            return;
		        }
		    }
		    
		    function FileDownload(obj) {
		        if (obj != null) {
		        	var downloadPath = obj.getAttribute("_path");
		        	var fileName = obj.getAttribute("_file");
		        	var downloadUrl = "/ezPoll/downloadAttach.do?folderPath=" + encodeURIComponent(downloadPath) + "&filename=" + encodeURIComponent(fileName);
		        	//console.log("Download URL: " + downloadUrl);
		        	
		            AttachDownFrame.location.href = downloadUrl;
		            AttachAllDownload();
		        }
		        else {		
		        	suffix = 0;
		            return;
		        }
		    }
		    
		    function resizeFrame() {
				var iFrame = document.getElementById("message_test");
				var messTd = document.getElementById("messagetd");
				iFrame.style.height = "10px";
				newheight = iFrame.contentWindow.document.body.scrollHeight;
				
				/*if (newheight > 350) {
					iFrame.style.height = "350px";
				}
				else {
					iFrame.style.height = (newheight + 10) + "px";
				}	 */			
				iFrame.style.height = (newheight) + "px";
				messTd.style.height = (newheight) + "px";
		    }
		    
		    function updateVoteResult1(obj, voteId, optId) {	    	
		    	if (hasVoted == 0) {
 	    			votedUsers = votedUsers + 1;
 	    			hasVoted = 1;	 	    			
 	    			document.getElementById("votedUsers").innerHTML = "(" + votedUsers + "<spring:message code = 'ezPoll.t110'/>" + ")";
 	    		} 	    		

 	    		numberOfSelected = numberOfSelected + 1;
 	    		obj.src = "/images/checked.png";
	    		//var voteId = obj.name;
	    		//var optId = votesArr[voteId][0];    	
	    		var showVotes = "voterNumber_" + optId;
	    		
	    		//Update values of total votes and votes for current option 
	    		votesArr[voteId][1] = votesArr[voteId][1] + 1;
	    		totalVotes = totalVotes + 1;				
				document.getElementById(showVotes).style.display = "none";
				
				if (secretVote == 0) {
					//Update the userName array
					var tempObj = new Object();
					tempObj[curentUser] = curentUserName;
					
					if (userNameArr[voteId].map(function (o) {return o[curentUser];}).indexOf(curentUserName) === -1) {	
						userNameArr[voteId].push(tempObj);
					}
				}
				
	    		//Then update the graph for all options				    		
	    		updateGraph();
		    }
		    
		    function updateVoteResult2(obj, voteId, optId) {
		    	obj.src = "/images/poll/unchecked_vote.png";		
 	    		checkVoted();	 	    			 	    		
 	    		
 	    		//Update local information
 	    		numberOfSelected = numberOfSelected - 1;
 	    		votesArr[voteId][1] = votesArr[voteId][1] - 1;
 	    		totalVotes = totalVotes - 1;

				if (secretVote == 0) {
	 	    		var pos = userNameArr[voteId].map(function (o) {return o[curentUser];}).indexOf(curentUserName);
	 	    		
					if ( pos > -1) {	
						userNameArr[voteId].splice(pos, 1);						
   						var tempClassId = "_thu" + voteId;	   						
   						var listDivs = document.getElementsByClassName(tempClassId);
   						
   						for (var j = 0; j < 5; j++) {
   							listDivs[j].innerHTML == "";
   							listDivs[j].style.display = "none";
   						}  						
					}
				}
				
				//Then update the graph for all options	
 	    		updateGraph();
		    }		
		    
		    function change(obj) {
				//baonk added 20180109 
				if (_status == "2") {
					alert("<spring:message code = 'ezPoll.t252'/>");
					return;
				}
				//end
		    	
		    	var voteId = obj.name;
 	    		var optId = votesArr[voteId][0];
 	    		var isUnchecked = obj.src.indexOf("/images/poll/unchecked_vote.png");
 	    		
	 	    	if (isUnchecked !== -1) { 	    		   		
	 	    		
	 	    		if (votePrivilege == 0) {
	 	    			alert("<spring:message code = 'ezPoll.t172'/>");
	 					return;
	 	    		}
	 	    		
	 	    		if (numberOfMultiSelect != 0 && numberOfSelected >= numberOfMultiSelect) {
	 					alert("<spring:message code = 'ezPoll.t171'/>" + numberOfMultiSelect + "<spring:message code = 'ezPoll.t173'/>");
	 					return;
	 	    		}
	 	    		
	 	    		if(selectOnlyOnce(isUnchecked)){
	 	    			var msg = "<spring:message code = 'ezPoll.t262'/> <spring:message code = 'ezPoll.t263'/>";
	 	    			if(!window.confirm(msg)){
	 	    				return;
	 	    			}
	 	    		}
	 	    		  		  		
	 	    		modifySelectedList(optId, 'add');
	 	    		
	 	    		obj.onclick = null;
	 	    		
	 	    		$.ajax({
						type: "POST",
						url: "/ezPoll/adjustJoinedUsers.do",
						data: {
							"optionId": optId,
							"questId": qstId,
							"flag": "1"
						},
						dataType: "text",
						async: true,
						success: function(result) {							
/* 							var xml = loadXMLString(result);							
							var state = SelectSingleNodeValue(xml, "RESULT");
							
							if (state == "ADD_OK") {
								updateVoteResult1(obj, voteId, optId);
							} */						
						},
						error: function (xhr, status, e){
							alert("<spring:message code = 'ezPoll.t250'/>");
						},
						complete: function() {
							obj.onclick = function() {change(obj);};
				        }
					});   		
		    	}
	 	    	else {
	 	    		if(selectOnlyOnce(isUnchecked)){
	 	    			return;
	 	    		}
	 	    		modifySelectedList(optId, 'remove');
	 	    		
	 	    		obj.onclick = null;
	 	    		
	 	    		$.ajax({
						type: "POST",
						url: "/ezPoll/adjustJoinedUsers.do",
						data: {
							"optionId": optId,
							"questId": qstId,
							"flag": "0"
						},
						dataType: "text",
						async: true,
						success: function(result) {
/* 							var xml = loadXMLString(result);							
							var state = SelectSingleNodeValue(xml, "RESULT");						

							if (state == "REMOVE_OK") {
								updateVoteResult2(obj, voteId, optId);
							}	 */		
						},
						error: function (xhr, status, e){
							alert("<spring:message code = 'ezPoll.t250'/>");
						},
						complete: function() {
							obj.onclick = function() {change(obj);};
				        }
					});
	 	    		
	 	    	}
		    }
		    
		    function checkVoted() {				
		    	var flag = 0;	
		    	var imgTags = document.getElementsByClassName("_imageTag");	
		    	
		    	for (var i = 0; i < imgTags.length; i++) {
		    		if (imgTags[i].src.indexOf("/images/checked.png") !== -1) {
		    			flag = 1;
		    			break;
		    		}
		    	}
		    	
		    	if (flag == 0) {		    		
		    		votedUsers = votedUsers - 1;
 	    			hasVoted = 0; 	    			
 	    			document.getElementById("votedUsers").innerHTML = "(" + votedUsers + "<spring:message code = 'ezPoll.t110'/>" + ")";
		    	}
		    }
		    
		    function displayDetail(pQstID) {		    	
		    	 var feature = GetOpenPosition(420, 438);
		    	 var target = "${question.target}";
		    	 window_open2 = window.open("/ezPoll/showUnJoinedUsersInfo.do?qstId=" + pQstID + "&target=" + target, "", "height=438px,width=395px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
		    
		    function displayVotedUser(pQstID, pOptId) {		    		    
		    	var feature = GetOpenPosition(420, 438);
		    	var target = "${question.target}";
		    	
 		    	if (window_open3 != null && !window_open3.closed) {		    		
 		    		window_open3.close();
		    	}
		    	
		    	window_open3 = window.open("/ezPoll/showVotedUsersInfo.do?qstId=" + pQstID + "&optId=" + pOptId  + "&target=" + target, "", "height=384px,width=390px, status = no, toolbar=no, menubar=no,location=no, resizable=no" + feature);
		    }
		    
		    function finishVote() {	    	
		    	if(window.confirm("<spring:message code = 'ezPoll.hdp06'/>")){
			    	var tenantId = "<c:out value='${question.tenantId}'/>";
			    	stompClient.send("/app/finish", {}, JSON.stringify({'question': qstId, 'tenant': tenantId}));		    	
		    	}
		    }
		    
		    function menuQst_DetailUserInfo(pUserID, pDeptID) {
		    	 var feature = GetOpenPosition(420, 450);
		         window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }	
		    
		    function showEditPanel(obj) {					    	
		    	if (flagEvent != -1) {					
		    		document.getElementById("editComt" + flagEvent).style.display = "none";
		    	}	
		    	
		    	var id = obj.getAttribute("_comtIndex");
		    	
		    	if (flagEvent == id.slice(8)) {
		    		flagEvent = -1;
					return;
		    	}
		    	
		    	flagEvent = id.slice(8);	    	
		    	document.getElementById(id).style.display = "block";	
		    	
		    	document.addEventListener("click", function handleClick(e) {		    									
			    	if (document.getElementById(id) != null) {
			    		document.getElementById(id).style.display = "none"; 
			    	}		    			
			    	document.removeEventListener("click", handleClick);
			    	flagEvent = -1;
		    	});	   	
		    }		    
		    
		    function deleteFileInCmt() {		    	
		    	document.getElementById("descriptCmt" + currentEditingCmt).style.display = "none";
		    	
		    	if (document.getElementById("descriptCmt" + currentEditingCmt).childElementCount == 3) {
		    		document.getElementById("descriptCmt" + currentEditingCmt).lastElementChild.innerHTML = "";
		    	}
		    	
		    	document.getElementById("toolCmt" + currentEditingCmt).style.display = "block";	
		    	
		    	if (document.getElementById("editCmtArea" + currentEditingCmt).value == "") {
		    		document.getElementById("clA2cmt" + currentEditingCmt).style.backgroundColor = "#eee";
		    		document.getElementById("clA2cmt" + currentEditingCmt).disabled = true;
		    	}
		    }
		    
		    function editComment(obj) {
		    	if (currentEditingCmt != -1) {
		    		var cancelObj = document.getElementById("clA1cmt" + currentEditingCmt);
		    		cancelEditComment(cancelObj);
		    	}
		    	
		    	//Prepare step
		    	document.getElementById("sendComment").style.display = "none";	
		    	var id = obj.getAttribute("_comtIndex");
		    	currentEditingCmt = id.slice(8);
		    	document.getElementById("_eCmt" + id.slice(8)).style.display = "none";	    		    	
		    	var div2Cmt = document.getElementById("div2Cmt" + id.slice(8));
		    	div2Cmt.style.display = "none";	
		    	var nChilds = div2Cmt.childElementCount;		    	
		    	var editDiv2Cmt = document.getElementById("editCmtDiv" + id.slice(8));	    	
		    	var innerDiv1 = document.createElement("div");
		    	//innerDiv1.setAttribute("style", "display: inline-block;");		    	
		    	var innerDiv2 = document.createElement("div");	
		    	innerDiv2.setAttribute("id", "descriptCmt" + id.slice(8));
		    	innerDiv2.setAttribute("class", "descriptCmt");
		    	var innerDiv3 = document.createElement("div");	
		    	innerDiv3.setAttribute("class", "cmtEditBtnDiv");
		    	editDiv2Cmt.appendChild(innerDiv1);
		    	editDiv2Cmt.appendChild(innerDiv2);
		    	
		    	//Create image element for stickers/files
		    	var imgForInnerDiv2 = document.createElement("img"); 
		    	imgForInnerDiv2.setAttribute("id", "editPreviewImg" + id.slice(8));
		    	//imgForInnerDiv2.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 60px; width: 60px;");	    	
		    	innerDiv2.appendChild(imgForInnerDiv2);		    	
		    	
		    	//Copy text comment
		    	var innInnerDiv1 = document.createElement("div");
		    	innInnerDiv1.setAttribute("style", "display: block; float:left; border:1px solid #ddd;padding-left: 0px;margin-left: 20px; width: 105%; border-radius: 3px;");
		    	var editTxtArea = document.createElement("textarea");
		    	editTxtArea.setAttribute("id", "editCmtArea" + id.slice(8));
		    	editTxtArea.setAttribute("cols", "20");
		    	editTxtArea.setAttribute("rows", "1");
		    	editTxtArea.setAttribute("style", "display: inline-block; overflow: hidden; outline: none; border: none; resize:none; padding: 5px 5px; width: 98%; min-width: 600px; word-break: break-all;");
		    	editTxtArea.oninput =  function () { editAutoGrow(this); }	
		    	
		    	innInnerDiv1.appendChild(editTxtArea);		
		    	innerDiv1.appendChild(innInnerDiv1);	
		    	
	    		var innInnerDiv2 = document.createElement("div");
	    		innInnerDiv2.setAttribute("style", "display: none;");
	    		innInnerDiv2.setAttribute("id", "toolCmt" + id.slice(8));
	    		var divFile = document.getElementById("_addFile");
	    		var divSticker = document.getElementById("_stickerArea");
	    		var cloneOfDivFile = divFile.cloneNode(true);
	    		var cloneOfDivSticker = divSticker.cloneNode(true);
	    		/* 이모티콘 패널 위치 수정 제거. */
	    		/* var childElemt = cloneOfDivSticker.firstElementChild; //baonk changed
	    		childElemt.style.marginLeft = "-39px"; //baonk changed */
	    		cloneOfDivFile.setAttribute("class", "cmtAddFile");
	    		cloneOfDivSticker.setAttribute("style", "float:left; display:block; padding: 0px;");
	    		innInnerDiv2.appendChild(cloneOfDivFile);
	    		innInnerDiv2.appendChild(cloneOfDivSticker);
	    		innerDiv1.appendChild(innInnerDiv2);
		    	
		    	//Copy files/stickers
		    	if (nChilds == 1) {		    		
		    		if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {		    			
			    		//editTxtArea.value = div2Cmt.firstElementChild.innerHTML.replace(/<br\s*\/?>/mg,"\n");
			    		editTxtArea.value = div2Cmt.firstElementChild.textContent.replace(/<br\s*\/?>/mg,"\n");		    		
			    		innInnerDiv2.style.display = "block";
			    	}
		    		else {		    			
		    			innInnerDiv2.style.display = "none";		    			
		    			imgForInnerDiv2.src = div2Cmt.firstElementChild.firstElementChild.src;		    			
		    			innerDiv2.style.display = "block";		    					    			
		    			
		    			//Add delete image in top rigt of sticker/files
		    			var cancelImgForInnerDiv2 = document.createElement("img"); 
		    			cancelImgForInnerDiv2.src = "/images/close.png";
		    			cancelImgForInnerDiv2.setAttribute("style", "height: 20; width: 20px; top: 0px; left: 20px; position: absolute; cursor: pointer;");
		    			cancelImgForInnerDiv2.onclick = function () { deleteFileInCmt(); };
		    			innerDiv2.appendChild(cancelImgForInnerDiv2);
		    			
		    			var fileType = div2Cmt.firstElementChild.firstElementChild.getAttribute("_type");	
		    			
		    			if (fileType == "file") {
		    				imgForInnerDiv2.setAttribute("_fileInfo", div2Cmt.firstElementChild.firstElementChild.getAttribute("_fileInfo"));
		    				imgForInnerDiv2.setAttribute("_type", "file");
		    				imgForInnerDiv2.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 60px; width: 60px;");
		    				var nameDiv = document.createElement("div");
							nameDiv.innerHTML = div2Cmt.firstElementChild.lastElementChild.innerHTML;	
							nameDiv.setAttribute("style", "padding-left: 10px;");
							nameDiv.setAttribute("_fileInfo", div2Cmt.firstElementChild.firstElementChild.getAttribute("_fileInfo"));
							nameDiv.setAttribute("_orgName", div2Cmt.firstElementChild.lastElementChild.innerHTML);
							innerDiv2.appendChild(nameDiv);
		    			}
		    			else if (fileType == "images") {
		    				imgForInnerDiv2.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
		    				imgForInnerDiv2.setAttribute("_type", "images");
		    			}
		    			else {
		    				imgForInnerDiv2.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 80px; width: 80px;");
		    				imgForInnerDiv2.setAttribute("_type", "sticker");		    				
		    			}
		    		}
		    	}
		    	else {		    		
		    		innInnerDiv2.style.display = "none";
		    		
		    		//Copy files/sticker to a div
		    		//editTxtArea.value = div2Cmt.firstElementChild.innerHTML.replace(/<br\s*\/?>/mg,"\n");
		    		editTxtArea.value = div2Cmt.firstElementChild.textContent.replace(/<br\s*\/?>/mg,"\n");		    		
		    		imgForInnerDiv2.src = div2Cmt.lastElementChild.firstElementChild.src;
		    		innerDiv2.style.display = "block";
		    			
	    			//Add delete image in top rigt of sticker/files
	    			var cancelImgForInnerDiv2 = document.createElement("img"); 
	    			cancelImgForInnerDiv2.src = "/images/close.png";
	    			cancelImgForInnerDiv2.setAttribute("style", "height: 20; width: 20px; top: 0px; left: 20px; position: absolute; cursor: pointer;");
	    			cancelImgForInnerDiv2.onclick = function () { deleteFileInCmt(); };
	    			innerDiv2.appendChild(cancelImgForInnerDiv2);
	    			
	    			var fileType = div2Cmt.lastElementChild.firstElementChild.getAttribute("_type");
	    			
	    			if (fileType == "file") {
	    				imgForInnerDiv2.setAttribute("_fileInfo", div2Cmt.lastElementChild.firstElementChild.getAttribute("_fileInfo"));
	    				imgForInnerDiv2.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 60px; width: 60px;");
	    				imgForInnerDiv2.setAttribute("_type", "file");
	    				var nameDiv = document.createElement("div");
						nameDiv.innerHTML = div2Cmt.lastElementChild.lastElementChild.innerHTML;
						nameDiv.setAttribute("_fileInfo", div2Cmt.lastElementChild.firstElementChild.getAttribute("_fileInfo"));
						nameDiv.setAttribute("_orgName", div2Cmt.lastElementChild.lastElementChild.innerHTML);
						nameDiv.setAttribute("style", "padding-left: 10px;");
						innerDiv2.appendChild(nameDiv);
	    			}
	    			else if (fileType == "images") {
	    				imgForInnerDiv2.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
	    				imgForInnerDiv2.setAttribute("_type", "images");
	    			}
	    			else {
	    				imgForInnerDiv2.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 80px; width: 80px;");
	    				imgForInnerDiv2.setAttribute("_type", "sticker");
	    			}
		    	}	
		    	
		    	//Adding save/cancel comment buttons
		    	var tagA1 = document.createElement("button"); 
		    	tagA1.innerHTML = "<spring:message code = 'ezPoll.t139'/>"; 
		    	tagA1.setAttribute("id", "clA1cmt" + id.slice(8));
		    	tagA1.setAttribute("class", "voteCancelBttn");
		    	tagA1.setAttribute("_cmtIndex", id.slice(8));
		    	/* tagA1.setAttribute("style", "cursor: pointer; width:46px; height:24px; margin:0px 4px 0px 0px; padding:0px; background:#eee; border:1px solid #999;"); */
		    	tagA1.onclick = function (event) { event.stopPropagation(); event.preventDefault(); cancelEditComment(this); };
		    	
		    	var tagA2 = document.createElement("button");		    	
		    	tagA2.innerHTML = "<spring:message code = 'ezPoll.t140'/>";
		    	tagA2.setAttribute("id", "clA2cmt" + id.slice(8));
		    	tagA2.setAttribute("class", "voteSaveBttn");
		    	/* tagA2.setAttribute("style", "cursor: pointer; width:46px; height:24px; color:#FFF; background:#004896; border:none;"); */
		    	tagA2.setAttribute("_cmtIndex", id.slice(8));
		    	tagA2.onclick = function (event) { event.stopPropagation(); event.preventDefault(); saveEditComment(this); };
		    	innerDiv3.appendChild(tagA1);
		    	innerDiv3.appendChild(tagA2);
		    	
		    	editDiv2Cmt.appendChild(innerDiv3);		    			    	
		    	editDiv2Cmt.style.display = "block";	 
		    	
		    	editAutoGrow(editTxtArea);    	
		    	editTxtArea.focus(); 
		    }
		    
		    function cancelEditComment(obj) {
		    	var commentIndex = obj.getAttribute("_cmtIndex");
		    	var div2Cmt = document.getElementById("div2Cmt" + commentIndex);
		    	div2Cmt.style.display = "inline-block";
		    	var editDiv2Cmt = document.getElementById("editCmtDiv" + commentIndex);
		    	
		    	while (editDiv2Cmt.hasChildNodes()) {
		    		editDiv2Cmt.removeChild(editDiv2Cmt.lastChild);
		    	}
		    	
		    	editDiv2Cmt.style.display = "none";	
		    	document.getElementById("sendComment").style.display = "block";	
		    	document.getElementById("_eCmt" + commentIndex).style.display = "block";
		    	currentEditingCmt = -1;
		    }
		    
		    function saveEditComment(obj) { 	
		    	var fd = new FormData();
		    	currentEditingCmt = -1;
		    	var commentIndex = obj.getAttribute("_cmtIndex");
		    	var div2Cmt = document.getElementById("div2Cmt" + commentIndex);
				
				if (document.getElementById("editCmtArea" + commentIndex).value != "") {
					fd.append("cmtTxt", document.getElementById("editCmtArea" + commentIndex).value);
				}	

				if (document.getElementById("descriptCmt" + commentIndex).style.display != "none") {
					var fileType = document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_type");
		    		fd.append("fileType", fileType);
					
					if (div2Cmt.childElementCount == 1) {			    			
		    			if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {	                					    	
					    	if (fileType != "sticker" && fileType != "images") {				    		
					    		fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");					    		
					    		fd.append("filePath", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
			    			}
					    	
					    	fd.append("cmtAttach", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);
		    			}
		    			else {   				
							if (fileType != "sticker" && fileType != "images") {			    				
			    				fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");	
			    				fd.append("filePath", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
			    			}
		    				
		    				fd.append("cmtAttach", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);
		    			}
		    		}
		    		else {   					    			
		    			if (fileType != "sticker" && fileType != "images") {   					    				
		    				fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");	
		    				fd.append("filePath", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
		    			}
		    			
		    			fd.append("cmtAttach", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);
		    		}					
					
				}
				
				//Delete all child element of editCmtDiv
		    	var editDiv2Cmt = document.getElementById("editCmtDiv" + commentIndex);
		    	
		    	while (editDiv2Cmt.hasChildNodes()) {
		    		editDiv2Cmt.removeChild(editDiv2Cmt.lastChild);
		    	}
		    	
		    	editDiv2Cmt.style.display = "none";	
		    	
		    	//Enable div2Cmt, sendComment and edit option
		    	//div2Cmt.style.display = "inline-block";
		    	document.getElementById("_eCmt" + commentIndex).style.display = "block";
		    	document.getElementById("sendComment").style.display = "block";
		    	
		    	//Send an update comment request to server
		        fd.append("qstId", qstId);
		        fd.append("cmtId", commentIndex);		        		        
	    	    xhr1.open("POST", "/ezPoll/editComment.do");
	    	    xhr1.send(fd);
			}		
		    
/* 		    function saveEditComment(obj) {		    	
		    	var fd = new FormData();
		    	currentEditingCmt = -1;
		    	var commentIndex = obj.getAttribute("_cmtIndex");
		    	var div2Cmt = document.getElementById("div2Cmt" + commentIndex);
		    	
		    	if (document.getElementById("editCmtArea" + commentIndex).value == "") {
		    		if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {
		    			div2Cmt.removeChild(div2Cmt.children[0]);
		    		}
		    	}
		    	else {
		    		//fd.append("cmtTxt", document.getElementById("editCmtArea" + commentIndex).value.replace(/(?:\r\n|\r|\n)/g, '<br />'));
		    		fd.append("cmtTxt", document.getElementById("editCmtArea" + commentIndex).value);
		    		
		    		if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {
		    			//div2Cmt.firstElementChild.innerHTML = document.getElementById("editCmtArea" + commentIndex).value.replace(/(?:\r\n|\r|\n)/g, '<br />');
		    			div2Cmt.firstElementChild.textContent = document.getElementById("editCmtArea" + commentIndex).value;
		    			div2Cmt.firstElementChild.setAttribute("style", "word-wrap: break-word; margin-top: 0px;margin-bottom: 0px; white-space: pre-wrap;");
		    		}
		    		else {
		    			var pForTd2 = document.createElement("p");  
		    			//pForTd2.innerHTML = document.getElementById("editCmtArea" + commentIndex).value.replace(/(?:\r\n|\r|\n)/g, '<br />');
		    			pForTd2.textContent = document.getElementById("editCmtArea" + commentIndex).value;
		    			pForTd2.setAttribute("style", "word-wrap: break-word; margin-top: 0px;margin-bottom: 0px; white-space: pre-wrap;");
		    			div2Cmt.insertBefore(pForTd2, div2Cmt.children[0]);
		    		}
		    	}
		    	
		    	if (document.getElementById("descriptCmt" + commentIndex).style.display == "none") {
		    		if (div2Cmt.lastElementChild.tagName.toLowerCase() == "div") {
		    			div2Cmt.removeChild(div2Cmt.children[1]);
		    		}
		    	}
		    	else {
		    		var fileType = document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_type");
		    		fd.append("fileType", fileType);
		    		
		    		if (div2Cmt.childElementCount == 1) {	    				    			
		    			if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {		                	
		    				var innerDiv1 = document.createElement("div");
		                	innerDiv1.setAttribute("style", "padding-top: 5px;");
					    	var imgForinnerDiv1 = document.createElement("img");  	    	           
					    	imgForinnerDiv1.setAttribute("vertical-align", "middle");
					    	imgForinnerDiv1.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px;");
					    	
					    	if (fileType == "sticker") {
					    		imgForinnerDiv1.setAttribute("_type", "sticker");					    		
					    		imgForinnerDiv1.setAttribute("height", "80");
						    	imgForinnerDiv1.setAttribute("width", "80");	
						    	imgForinnerDiv1.onclick = "";
					    		imgForinnerDiv1.src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
					    		innerDiv1.appendChild(imgForinnerDiv1);
					    		div2Cmt.appendChild(innerDiv1);
					    	}
			    			else if (fileType == "images") {
					    		imgForinnerDiv1.setAttribute("_type", "images");				    			
						    	imgForinnerDiv1.setAttribute("style", "cursor: pointer; padding-left: 10px; padding-right: 5px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
					    		imgForinnerDiv1.src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
					    		imgForinnerDiv1.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src); 
					    		imgForinnerDiv1.onclick = function () { downloadFileInCmt(this); };
					    		innerDiv1.appendChild(imgForinnerDiv1);
					    		div2Cmt.appendChild(innerDiv1);
			    			}
			    			else {					    		
			    				imgForinnerDiv1.setAttribute("height", "60");
						    	imgForinnerDiv1.setAttribute("width", "60");
						    	imgForinnerDiv1.setAttribute("style", "cursor: pointer; padding-left: 10px; padding-right: 5px;");
						    	imgForinnerDiv1.setAttribute("_type", "file");
						    	imgForinnerDiv1.src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;
						    	imgForinnerDiv1.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo")); 
						    	imgForinnerDiv1.setAttribute("_fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");
						    	imgForinnerDiv1.onclick = function () { downloadFileInCmt(this); };
						    	innerDiv1.appendChild(imgForinnerDiv1);
						    	
					    		var innerDiv2 = document.createElement("div");
					    		innerDiv2.innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;					    		
					    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
					    		innerDiv2.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
					    		innerDiv2.setAttribute("_fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");
					    		innerDiv2.onclick = function () { downloadFileInCmt(this); };
					    		
					    		innerDiv1.appendChild(innerDiv2);
					    		div2Cmt.appendChild(innerDiv1);
					    		
					    		fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");					    		
					    		fd.append("filePath", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
			    			}
					    	
					    	fd.append("cmtAttach", imgForinnerDiv1.src);
		    			}
		    			else {		    				
		    				div2Cmt.firstElementChild.children[0].setAttribute("vertical-align", "middle");
		    				div2Cmt.firstElementChild.children[0].setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px;");
		    				
		    				if (fileType == "sticker") {
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
			    				}
			    				
		    					div2Cmt.firstElementChild.children[0].setAttribute("_type", "sticker");					    		
		    					div2Cmt.firstElementChild.children[0].setAttribute("height", "80");
		    					div2Cmt.firstElementChild.children[0].setAttribute("width", "80");	
		    					div2Cmt.firstElementChild.children[0].onclick = "";
		    					div2Cmt.firstElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
			    			}
			    			else if (fileType == "images") {
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
			    				}
			    				
			    				div2Cmt.firstElementChild.children[0].setAttribute("_type", "images");				    		
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
			    				div2Cmt.firstElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);
			    				div2Cmt.firstElementChild.children[0].onclick = function () { downloadFileInCmt(this); };
			    			}
			    			else {
			    				div2Cmt.firstElementChild.children[0].setAttribute("height", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("width", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px;");
			    				div2Cmt.firstElementChild.children[0].setAttribute("_type", "file");
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");
			    				div2Cmt.firstElementChild.children[0].onclick = function () { downloadFileInCmt(this); };
			    				div2Cmt.firstElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;
			    				
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.children[1].innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;
			    					div2Cmt.firstElementChild.children[1].setAttribute("style", "cursor: pointer; padding-left: 15px;");
			    					div2Cmt.firstElementChild.children[1].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo")); 
			    					div2Cmt.firstElementChild.children[1].setAttribute("_fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");
			    					div2Cmt.firstElementChild.children[1].onclick = function () { downloadFileInCmt(this); };
			    				}
			    				else {
			    					var innerDiv2 = document.createElement("div");
						    		innerDiv2.innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;					    		
						    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
						    		innerDiv2.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
						    		innerDiv2.setAttribute("_fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");
						    		innerDiv2.onclick = function () { downloadFileInCmt(this); };
						    		div2Cmt.lastElementChild.appendChild(innerDiv2);
			    				}			    				
			    				
			    				fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");	
			    				fd.append("filePath", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
			    			}
		    				
		    				fd.append("cmtAttach", div2Cmt.firstElementChild.children[0].src);
		    			}
		    		}
		    		else {    					    			
		    			div2Cmt.lastElementChild.children[0].setAttribute("vertical-align", "middle");
		    			div2Cmt.lastElementChild.children[0].setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px;");
		    			
		    			if (fileType == "sticker") {
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {
		    					div2Cmt.lastElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
		    				}
		    				
	    					div2Cmt.lastElementChild.children[0].setAttribute("_type", "sticker");					    		
	    					div2Cmt.lastElementChild.children[0].setAttribute("height", "80");
	    					div2Cmt.lastElementChild.children[0].setAttribute("width", "80");
	    					div2Cmt.lastElementChild.children[0].onclick = "";
	    					div2Cmt.lastElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
		    			}
		    			else if (fileType == "images") {
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {
		    					div2Cmt.lastElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
		    				}
		    				
		    				div2Cmt.lastElementChild.children[0].setAttribute("_type", "images");				    		
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
		    				div2Cmt.lastElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src); 
		    				div2Cmt.lastElementChild.children[0].onclick = function () { downloadFileInCmt(this); };
		    			}
		    			else {		    				
		    				div2Cmt.lastElementChild.children[0].setAttribute("height", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("width", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px;");
		    				div2Cmt.lastElementChild.children[0].setAttribute("_type", "file");
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo")); 
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");
		    				div2Cmt.lastElementChild.children[0].onclick = function () { downloadFileInCmt(this); };
		    				div2Cmt.lastElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;
		    				
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {		    					
		    					div2Cmt.lastElementChild.children[1].innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;
		    					div2Cmt.lastElementChild.children[1].setAttribute("style", "cursor: pointer; padding-left: 15px;");
		    					div2Cmt.lastElementChild.children[1].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));   
		    					div2Cmt.lastElementChild.children[1].setAttribute("_fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");
		    					div2Cmt.lastElementChild.children[1].onclick = function () { downloadFileInCmt(this); };
		    				}
		    				else {
		    					var innerDiv2 = document.createElement("div");
					    		innerDiv2.innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;					    		
					    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
					    		innerDiv2.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
					    		innerDiv2.setAttribute("_fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");
					    		innerDiv2.onclick = function () { downloadFileInCmt(this); };
					    		div2Cmt.lastElementChild.appendChild(innerDiv2);
		    				}		    				
		    				
		    				fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.getAttribute("_orgName") || "");	
		    				fd.append("filePath", document.getElementById("descriptCmt" + commentIndex).firstElementChild.getAttribute("_fileInfo"));
		    			}
		    			
		    			fd.append("cmtAttach", div2Cmt.lastElementChild.children[0].src);
		    		}
		    	}
		    	
		    	//Delete all child element of editCmtDiv
		    	var editDiv2Cmt = document.getElementById("editCmtDiv" + commentIndex);
		    	
		    	while (editDiv2Cmt.hasChildNodes()) {
		    		editDiv2Cmt.removeChild(editDiv2Cmt.lastChild);
		    	}
		    	
		    	editDiv2Cmt.style.display = "none";	
		    	
		    	//Enable div2Cmt, sendComment and edit option
		    	div2Cmt.style.display = "inline-block";
		    	document.getElementById("_eCmt" + commentIndex).style.display = "block";
		    	document.getElementById("sendComment").style.display = "block";
		    	
		    	//Send an update comment request to server
		        fd.append("qstId", qstId);
		        fd.append("cmtId", commentIndex);		        		        
	    	    xhr1.open("POST", "/ezPoll/editComment.do");
	    	    xhr1.send(fd); 		  
		    } */ 
		    
		    function deleteComment(obj) {
		    	var id = obj.getAttribute("_comtIndex");
		    	
		    	if (confirm("<spring:message code = 'ezPoll.t207' />")) { 	    			    		
		    		if (id == commentIndex) {
		    			commentIndex = commentIndex - 1;
		    		}
		    		
		    		//Delete this row in comment table
		    		var oTable = document.getElementById("commentListView");
		    		var i = obj.parentNode.parentNode.parentNode.rowIndex;
		    		oTable.deleteRow(i);
		    		
				    //Send delete comment request to server
 		    		var fd = new FormData();
			        fd.append("qstId", qstId);
			        fd.append("cmtId", id);		        		        
		    	    xhr1.open("POST", "/ezPoll/deleteComment.do");
		    	    xhr1.send(fd);				    
				}
		    	
		    	if (document.getElementById("sendComment").style.display == "none") {	
		    		document.getElementById("sendComment").style.display = "block";
		    	}
		    	
		    	currentEditingCmt = -1;
		    }
		    
			function sendComment() {		    	
		    	var fd = new FormData();
		    	commentIndex = commentIndex + 1;
		    	document.getElementById("sendBttn").style.backgroundColor = "#d0d0d0";
		    	document.getElementById("sendBttn").disabled = true;		    		    		    		    	
		    	var currentText = document.getElementById("comment_input").value;	//de lai	    			    	

                //Add text comment if exists
                if (currentText.length > 0) {                	
                	fd.append("cmtTxt", currentText);
                }
                
                //Add files/sticker if exists
                var uploadFileElement = document.getElementById("uploadedFile");   
                
		        if (uploadFileElement.style.display !== "none") {
		        	var img2ForUpFileElmt = uploadFileElement.lastElementChild;
		        	var fileinfo = img2ForUpFileElmt.getAttribute("_fileInfo");	
		        	var fileType = img2ForUpFileElmt.getAttribute("_type");	
			    	var orgFileName = "";	
			    	
			    	if (fileType == "file") {
			    		orgFileName = fileinfo.split("/")[1];  		
			    	}
			    	else {
			    		orgFileName = fileinfo.split("/")[4];
			    	}			    	
			    	
			    	var ext = orgFileName.split('.').pop().toLowerCase();
					var imgSrc = null;
			    	
			    	if (ext == "jpg" || ext == "png" || ext == "bmp") {	   			    		
			    		if (fileType == "file") {			    						    		
				    		fd.append("fileType", "file");						    	
				    		imgSrc= "/fileroot/"+tenantId+"/files/upload_common/commentImages/" + fileinfo.split("/")[0];
				    	}
				    	else {			    						    		
				    		fd.append("fileType", "sticker");					    	
				    		imgSrc = fileinfo;				    		   
				    	}
			    	}
			    	else {			    		
			    		fd.append("fileType", "file");
				    	
				    	if (ext == "doc" || ext == "docx") {
				    		imgSrc = "/images/msWord.png";
				    	}
				    	else if (ext == "ppt" || ext == "pptx") {
				    		imgSrc = "/images/msPowerpoint.png";
				    	}
				    	else if (ext == "xls" || ext == "xlsx") {
				    		imgSrc = "/images/msExcel.png";
				    	}
				    	else if (ext == "hwp") {
				    		imgSrc = "/images/hancomHWP.png";
				    	}
				    	else if (ext == "pdf") {
				    		imgSrc = "/images/pdfIcon.png";
				    	}
				    	else {
				    		imgSrc = "/images/cmtFile.png";
				    	}		    	
			    		
			    		fd.append("fileName", fileinfo.split("/")[1]);
			    		fd.append("filePath", fileinfo.split("/")[0]);
			    	}	
			    	fd.append("cmtAttach", imgSrc);
		        }           
                
                //Clean the place
                document.getElementById("comment_input").value = "";          
		        document.getElementById("uploadedFile").style.display = "none"; 
		        document.getElementById("sendComment").style.height = "66px";
		        document.getElementById("comment_input").style.height = "15px";
		        //window.scrollTo(0, document.body.scrollHeight);
		        
		        //Send add comment request to server
		        fd.append("qstId", qstId);
		        fd.append("cmtId", commentIndex);
		        fd.append("cmtTime", formatCmtTime());	        		       
		        
	    	    xhr1.open("POST", "/ezPoll/addComment.do");
	    	    xhr1.send(fd); 		        
		    }
		    
		    /* function sendComment() {		    	
		    	var fd = new FormData();
		    	commentIndex = commentIndex + 1;
		    	document.getElementById("sendBttn").style.backgroundColor = "#d0d0d0";
		    	document.getElementById("sendBttn").disabled = true;		    		    		    		    	
		    	var currentText = document.getElementById("comment_input").value;		    			    	
		    	var oTable = document.getElementById("commentListView");
		    	
		    	//create the tr element
		    	objTr = document.createElement("tr");
		    	objTr.setAttribute("style", "border-bottom: 1px dotted #ddd");
		    	
		    	//Process td1 (user image) element
		    	var objTd = document.createElement("td");
		    	objTd.setAttribute("style", "padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; ");                  
                var image_tag = document.createElement("img");                
                image_tag.src = "${userPhoto}";
                image_tag.setAttribute("style", "padding-top: 10px; height: 38px; width:38px; cursor: pointer; "); 
                image_tag.onclick = function () { menuQst_DetailUserInfo(curentUser); };
                objTd.appendChild(image_tag);
                objTr.appendChild(objTd);                          
                
                //Process td2 (comment and user information) element
                var objTd2 = document.createElement("td");
                var div1ForTd2 = document.createElement("div");
                var div2ForTd2 = document.createElement("div");  
                var editDiv2ForTd2 = document.createElement("div");  
                editDiv2ForTd2.setAttribute("id", "editCmtDiv" + commentIndex);   
                editDiv2ForTd2.style.display = "none"; 
                
                div2ForTd2.setAttribute("style", "display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 1300px;");               
                div2ForTd2.setAttribute("id", "div2Cmt" + commentIndex);                
                div1ForTd2.innerHTML = curentUserName;
                div1ForTd2.setAttribute("style", "display: block; color:#004896; font-size:14px; padding:7px 0px 0px 20px;");       
                
                //Add text comment if exists
                if (currentText.length > 0) {
                	//currentText = currentText.replace(/(?:\r\n|\r|\n)/g, '<br />');
                	var pForTd2 = document.createElement("p");                  	
                	//pForTd2.innerHTML = currentText;
                	pForTd2.textContent = currentText;
                	pForTd2.setAttribute("style", "word-wrap: break-word; margin-top: 0px;margin-bottom: 0px; white-space: pre-wrap;");
                	pForTd2.setAttribute("id", "cmtArea" + commentIndex);
                	div2ForTd2.appendChild(pForTd2);                	
                	fd.append("cmtTxt", currentText);
                }
                
                //Add files/sticker if exists
                var uploadFileElement = document.getElementById("uploadedFile");   
                
		        if (uploadFileElement.style.display !== "none") {		        	
		        	var img2ForUpFileElmt = uploadFileElement.lastElementChild;
		        	var fileinfo = img2ForUpFileElmt.getAttribute("_fileInfo");	
		        	var fileType = img2ForUpFileElmt.getAttribute("_type");	
			    	var orgFileName = "";	
			    	
			    	if (fileType == "file") {
			    		orgFileName = fileinfo.split("/")[1];  		
			    	}
			    	else {
			    		orgFileName = fileinfo.split("/")[4];
			    	}			    	
			    	
			    	var ext = orgFileName.split('.').pop().toLowerCase();
			    	var innerDiv1 = document.createElement("div");	
			    	innerDiv1.setAttribute("style", "padding-top: 5px;");
			    	var imgForinnerDiv1 = document.createElement("img");  	    	           
			    	imgForinnerDiv1.setAttribute("vertical-align", "middle");
			    	imgForinnerDiv1.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px;"); 
			    	
			    	if (ext == "jpg" || ext == "png" || ext == "bmp") {	   			    		
			    		if (fileType == "file") {				    		
				    		imgForinnerDiv1.setAttribute("_type", "images");
				    		fd.append("fileType", "file");	
					    	imgForinnerDiv1.setAttribute("style", "cursor: pointer; padding-left: 10px; padding-right: 5px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
				    		imgForinnerDiv1.src = "/fileroot/0/files/upload_common/commentImages/" + fileinfo.split("/")[0];	
				    		imgForinnerDiv1.setAttribute("_fileInfo", "/fileroot/0/files/upload_common/commentImages/" + fileinfo.split("/")[0]);   
				    		imgForinnerDiv1.onclick = function() { downloadFileInCmt(this); };
				    	}
				    	else {				    		
				    		imgForinnerDiv1.setAttribute("_type", "sticker");
				    		fd.append("fileType", "sticker");
				    		imgForinnerDiv1.setAttribute("height", "80");
					    	imgForinnerDiv1.setAttribute("width", "80");					    	
				    		imgForinnerDiv1.src = fileinfo;
				    		imgForinnerDiv1.setAttribute("_fileInfo", fileinfo);   
				    	}
		    			    	
			    		innerDiv1.appendChild(imgForinnerDiv1);
			    		div2ForTd2.appendChild(innerDiv1);
			    	}
			    	else {			    		
			    		fd.append("fileType", "file");
			    		imgForinnerDiv1.setAttribute("height", "60");
				    	imgForinnerDiv1.setAttribute("width", "60");
				    	imgForinnerDiv1.setAttribute("style", "cursor: pointer;  padding-left: 10px; padding-right: 5px;");
				    	imgForinnerDiv1.setAttribute("_type", "file");
				    	imgForinnerDiv1.setAttribute("_fileInfo", fileinfo.split("/")[0]); 
				    	imgForinnerDiv1.setAttribute("_fileName", fileinfo.split("/")[1]);
				    	
				    	if (ext == "doc" || ext == "docx") {
				    		imgForinnerDiv1.src = "/images/msWord.png";
				    	}
				    	else if (ext == "ppt" || ext == "pptx") {
				    		imgForinnerDiv1.src = "/images/msPowerpoint.png";
				    	}
				    	else if (ext == "xls" || ext == "xlsx") {
				    		imgForinnerDiv1.src = "/images/msExcel.png";
				    	}
				    	else if (ext == "hwp") {
				    		imgForinnerDiv1.src = "/images/hancomHWP.png";
				    	}
				    	else if (ext == "pdf") {
				    		imgForinnerDiv1.src = "/images/pdfIcon.png";
				    	}
				    	else {
				    		imgForinnerDiv1.src = "/images/cmtFile.png";
				    	}				    	
				    	
				    	imgForinnerDiv1.onclick = function () { downloadFileInCmt(this); };
			    		innerDiv1.appendChild(imgForinnerDiv1);
			    		div2ForTd2.appendChild(innerDiv1);
			    		var innerDiv2 = document.createElement("div");
			    		innerDiv2.innerHTML = fileinfo.split("/")[1];
			    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
			    		innerDiv2.setAttribute("_fileInfo", fileinfo.split("/")[0]); 
			    		innerDiv2.setAttribute("_fileName", fileinfo.split("/")[1]);
			    		innerDiv2.onclick = function () { downloadFileInCmt(this); };
			    		innerDiv1.appendChild(innerDiv2);
			    		
			    		fd.append("fileName", fileinfo.split("/")[1]);
			    		fd.append("filePath", fileinfo.split("/")[0]);
			    	}	
			    	fd.append("cmtAttach", imgForinnerDiv1.src);
		        }               
		        
                objTd2.appendChild(div1ForTd2);
                objTd2.appendChild(div2ForTd2);
                objTd2.appendChild(editDiv2ForTd2);
                objTr.appendChild(objTd2);
                
                //Process td3 (comment time and edit comment) element
                var objTd3 = document.createElement("td");
                objTd3.setAttribute("style", "width: 145px; position: relative;");                
                var fistChildForTd3 = document.createElement("div");
                fistChildForTd3.setAttribute("style", "position: absolute; top:10px; right:18px; color:#a3a3a3; white-space:nowrap;");     
                fistChildForTd3.innerHTML = formatCmtTime();
                objTd3.appendChild(fistChildForTd3);                
                
                var imagForTd3 = document.createElement("img");                
                imagForTd3.src = "/images/option3.png";
                imagForTd3.setAttribute("_comtIndex", "editComt" + commentIndex);
                imagForTd3.setAttribute("_inner", "innerEditComment" + commentIndex);
                imagForTd3.setAttribute("height", "25");
                imagForTd3.setAttribute("width", "25");
                imagForTd3.setAttribute("vertical-align", "middle");
                imagForTd3.setAttribute("style", "margin:30px 10px 0px 0px; position:absolute;top:0;right:0; padding:0px; cursor: pointer;");
                imagForTd3.onclick = function (event) { event.stopPropagation(); showEditPanel(this); };
                objTd3.appendChild(imagForTd3);
                
                var div1ForTd3 = document.createElement("div");
                div1ForTd3.setAttribute("style", "float:right; display: none; position: absolute; z-index: 10 ; border: 1px solid #ddd; background-color: #576652; color: white; top: 30px; right: 28px; width: 120px;");
                div1ForTd3.setAttribute("id", "editComt" + commentIndex);
                div1ForTd3.setAttribute("tabindex", "0");        
                var innerDiv1ForTd3 = document.createElement("div");
                innerDiv1ForTd3.setAttribute("id", "_eCmt" + commentIndex);
                innerDiv1ForTd3.innerHTML = "<spring:message code = 'ezPoll.t125'/>";
                innerDiv1ForTd3.setAttribute("_comtIndex", "editComt" + commentIndex);               
                innerDiv1ForTd3.setAttribute("style", "border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;");
                innerDiv1ForTd3.onclick = function (event) { editComment(this); };
                var innerDiv2ForTd3 = document.createElement("div");                
                innerDiv2ForTd3.innerHTML = "<spring:message code = 'ezPoll.t126'/>";
                innerDiv2ForTd3.setAttribute("_comtIndex", commentIndex);  
                innerDiv2ForTd3.setAttribute("style", "text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;");         
                innerDiv2ForTd3.onclick = function (event) { deleteComment(this); };
                div1ForTd3.appendChild(innerDiv1ForTd3);
                div1ForTd3.appendChild(innerDiv2ForTd3);
                
                objTd3.appendChild(div1ForTd3);
                objTr.appendChild(objTd3);                
                oTable.appendChild(objTr);                
                
                //Clean the place
                document.getElementById("comment_input").value = "";          
		        document.getElementById("uploadedFile").style.display = "none"; 
		        document.getElementById("sendComment").style.height = "66px";
		        document.getElementById("comment_input").style.height = "15px";
		        window.scrollTo(0, document.body.scrollHeight);
		        
		        //Send add comment request to server
		        fd.append("qstId", qstId);
		        fd.append("cmtId", commentIndex);
		        fd.append("cmtTime", fistChildForTd3.innerHTML);	        		       
		        
	    	    xhr1.open("POST", "/ezPoll/addComment.do");
	    	    xhr1.send(fd); 		        
		    } */
		    
		    function formatCmtTime() {		    	
		    	var strTime = new Date().toTimeString().split(" ")[0];
		    	var strDateTime = new Date().toISOString();
		    	var strDate = strDateTime.substring(0, 10);
		    	return strDate + " " + strTime;
		    }
		    
		    function uploadFileCmt() {		    	
	    	    var fd = new FormData();		    	
		    	var _file = document.getElementById("fileInput").files[0];    	
		    	var ext = _file.name.split('.').pop().toLowerCase();
		    	
	            if (_file.size / 1024 / 1024 > 5) {
	                alert("<spring:message code = 'ezPoll.t208' />");
	                return;
	            }	 
	            
	            fd.append("fileToUpload", _file);			
		        xhr1.addEventListener("load", uploadComplete, false);
		        
		        if ( ext == "jpg" || ext == "png" || ext == "bmp") {
		    	    xhr1.open("POST", "/ezPoll/uploadCmtFile.do");
		    	    xhr1.send(fd); 
		        }
		        else {
		    	    xhr1.open("POST", "/ezPoll/uploadFile.do");
		    	    xhr1.send(fd); 
		        }    	    
		    }		   
    
		    function uploadComplete(evt) {		    	
		    	xhr1.removeEventListener("load", uploadComplete);
		    	//document.getElementById("fileInput").value = null;	
		    	clearFileInput(document.getElementById("fileInput"));
		        showAttachedCmtFile(xhr1.responseText);		       
		    }
		    
		    function showAttachedCmtFile(strXML) {
		    	if (strXML == "ERROR") {    	
		            alert("Upload Failed!");
		            return;
		        }		    	
		    	
		        var xml = loadXMLString(strXML); 	        	        
		    	var fileinfo = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[0]);		
		    	var orgFileName = fileinfo.split("/")[1];		 	    	
		    	var _ext = orgFileName.split('.').pop().toLowerCase();		 
		    	var imagePreview = null;
		    	
		    	if (document.getElementById("sendComment").style.display !== "none") {			    	
			    	document.getElementById("uploadedFile").style.display = "inline-block";
			    	imagePreview = document.getElementById("previewImage");
			    	var cancelPreview = document.getElementById("cancelImg");
			    	cancelPreview.setAttribute("_fileInfo", fileinfo);
			    	cancelPreview.setAttribute("_type", "file");
			    	imagePreview.setAttribute("_fileInfo", fileinfo);	
			    	document.getElementById("sendBttn").style.backgroundColor = "#0470e4";
			    	document.getElementById("sendBttn").disabled = false;
			    	imagePreview.setAttribute("_type", "file");	
		    	}
		    	else {
		    		//In editing situation
		    		imagePreview = document.getElementById("editPreviewImg" + currentEditingCmt);	    		    				    		
		    		var childElmNumber = imagePreview.parentElement.childElementCount;
		    		
		    		if (childElmNumber == 1) {
		    			// Add cancel image in top right of files/sticker
		    			var cancelImg = document.createElement("img"); 
		    			cancelImg.src = "/images/close.png";
		    			cancelImg.setAttribute("style", "height: 20; width: 20px; top: 0; left: 20px; position: absolute; cursor: pointer;");
		    			cancelImg.onclick = function () { deleteFileInCmt(); };
		    			imagePreview.parentElement.appendChild(cancelImg);
						
						if (!(_ext == "jpg" || _ext == "png" || _ext == "bmp")) {
							imagePreview.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.setAttribute("_type", "file"); 
							imagePreview.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 60px; width: 60px;");
							var nameDiv = document.createElement("div");
							nameDiv.innerHTML = orgFileName;
							nameDiv.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							nameDiv.setAttribute("_orgName", orgFileName);
							nameDiv.setAttribute("style", "padding-left: 10px;");
							imagePreview.parentElement.appendChild(nameDiv);							
						}
						else {
							imagePreview.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
							imagePreview.setAttribute("_type", "images"); 
						}
		    		}
		    		else if (childElmNumber == 2) {
						if (!(_ext == "jpg" || _ext == "png" || _ext == "bmp")) {
							imagePreview.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.setAttribute("_type", "file"); 
							imagePreview.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 60px; width: 60px;");
							var nameDiv = document.createElement("div");
							nameDiv.innerHTML = orgFileName;	
							nameDiv.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							nameDiv.setAttribute("_orgName", orgFileName);
							nameDiv.setAttribute("style", "padding-left: 10px;");
							imagePreview.parentElement.appendChild(nameDiv);							
						}
						else {
							imagePreview.setAttribute("_type", "images"); 
							imagePreview.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
							imagePreview.setAttribute("_fileInfo", "/fileroot/"+tenantId+"/files/upload_common/commentImages/" + fileinfo.split("/")[0]);
						}
		    		}
		    		else {
						if (!(_ext == "jpg" || _ext == "png" || _ext == "bmp")) {
							imagePreview.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.setAttribute("_type", "file"); 
							imagePreview.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 60px; width: 60px;");
							imagePreview.parentElement.lastElementChild.innerHTML = orgFileName;
							imagePreview.parentElement.lastElementChild.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.parentElement.lastElementChild.setAttribute("_orgName", orgFileName);
							imagePreview.parentElement.lastElementChild.setAttribute("style", "padding-left: 10px;");
						}	
						else {
							imagePreview.setAttribute("_type", "images");
							imagePreview.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
							imagePreview.setAttribute("_fileInfo", "/fileroot/"+tenantId+"/files/upload_common/commentImages/" + fileinfo.split("/")[0]);
						}
		    		}
		    		
		    		imagePreview.parentElement.style.display = "block";	
		    		document.getElementById("clA2cmt" + currentEditingCmt).style.backgroundColor = "#0470e4";
		    		document.getElementById("clA2cmt" + currentEditingCmt).disabled = false;
		    	}
		    	
		    	//imagePreview.setAttribute("_type", "file");	
		    	
		    	if (_ext == "jpg" || _ext == "png" || _ext == "bmp") {		    	    	             
		    		imagePreview.src = "/fileroot/"+tenantId+"/files/upload_common/commentImages/" + fileinfo.split("/")[0];
		    	}
		    	else if (_ext == "doc" || _ext == "docx") {
		    		imagePreview.src = "/images/msWord.png";
		    	}
		    	else if (_ext == "ppt" || _ext == "pptx") {
		    		imagePreview.src = "/images/msPowerpoint.png";
		    	}
		    	else if (_ext == "xls" || _ext == "xlsx") {
		    		imagePreview.src = "/images/msExcel.png";
		    	}
		    	else if (_ext == "hwp") {
		    		imagePreview.src = "/images/hancomHWP.png";
		    	}
		    	else if (_ext == "pdf") {
		    		imagePreview.src = "/images/pdfIcon.png";
		    	}
		    	else {
		    		imagePreview.src = "/images/cmtFile.png";
		    	}
		    }
		    
		    function addFileComment() {
		    	//Close sticker picker
				document.getElementById("emoticonPanel").style.display = "none";
		    	document.getElementById("fileInput").click();
		    }
		    
		    function cancelShowingCmtFile(obj) {
				var type = obj.getAttribute("_type");
				
				if (type == "file") {
					//Send delete file request to server
			    	var fileinfo = obj.getAttribute("_fileInfo");		    	
			    	var orgFileName = fileinfo.split("/")[1];
			    	var ext = orgFileName.split('.').pop().toLowerCase();
			        var fd = new FormData();		        
			        fd.append("fileToDelete", fileinfo);
			        
			        if (ext == "jpg" || ext == "png" || ext == "bmp") {
				        xhr1.open("POST", "/ezPoll/deleteCmtFile.do");
				        xhr1.send(fd);
			        }
			        else {
			    	    xhr1.open("POST", "/ezPoll/deleteFile.do");
			    	    xhr1.send(fd); 
			        }  		        
				}	
				
		        //Hide uploadFile element
		        var uploadFileElement = document.getElementById("uploadedFile");		        	       
		        uploadFileElement.style.display = "none";
		        
		        if (document.getElementById("comment_input").value == "") {
		        	document.getElementById("sendBttn").style.backgroundColor = "#d0d0d0";
		        	document.getElementById("sendBttn").disabled = true;
		        }
		    }
		    
		    function auto_grow(element) {	    		    		    	
				if (element.value == "" && document.getElementById("uploadedFile").style.display == "none") {
					document.getElementById("sendBttn").style.backgroundColor = "#d0d0d0";
					document.getElementById("sendBttn").disabled = true;
				}
				else {
					document.getElementById("sendBttn").style.backgroundColor = "#0470e4";
			    	document.getElementById("sendBttn").disabled = false;
 			        element.style.height = "1px"; 			        
 			        var value = element.scrollHeight;
			        element.style.height = (element.scrollHeight - 32) + "px";			        
			        document.getElementById("sendComment").style.height = value + 18 + "px";
// 			        window.scrollTo(0, document.body.scrollHeight);
				}
		    }
		    
		    function editAutoGrow(element) {
				if (element.value == "" && document.getElementById("descriptCmt" + currentEditingCmt).style.display == "none") {
					document.getElementById("clA2cmt" + currentEditingCmt).style.backgroundColor = "#eee";
					document.getElementById("clA2cmt" + currentEditingCmt).disabled = true;
				}
				else {
					document.getElementById("clA2cmt" + currentEditingCmt).style.backgroundColor = "#0470e4";
					document.getElementById("clA2cmt" + currentEditingCmt).disabled = false;
				}
				
		    	element.style.height = "1px";    	
		        element.style.height = (element.scrollHeight - 10) + "px";		        
		        
		        //내용 길이 제한 로직 추가. 2018-04-09 홍대표
		        var maxLen = 500;
	  			if($(element).val().length > maxLen){
	  				alert(maxLen + " <spring:message code = 'ezPoll.t212'/>");
	  				$(element).val($(element).val().substring(0, maxLen));
	  			}
		    }
			
		    function checkScrollBars() {		
				if (document.getElementById("_listG" + stickerIndex + "Table").scrollHeight > 320) {
		    		document.getElementById("emoticonPanel").style.width = "420px";
		    	}
		    }
		    
		    function addSticker() {
		    	var targetPanel = event.target.parentElement.querySelector(".emoticonPanel") || document.getElementById("emoticonPanel");
		    	if (targetPanel && targetPanel.style && (targetPanel.style.display == "block")) {
		    		targetPanel.style.display = "none";
// 		    		document.getElementById("_addEmoticon").src = "/images/poll/add_emo_vote.png";
		    		$("._addEmoticon").attr("src", "/images/poll/add_emo_vote.png");
		    	}
		    	else {
		    		//baonk added
			    	document.addEventListener("keydown", function handleKeyDown(evt) {	
			    		evt = evt || window.event;
			    		
			    	    if (evt.keyCode == 27) {
			    	    	targetPanel.style.display = "none";
				    		document.getElementById("_addEmoticon").src = "/images/poll/add_emo_vote.png";
			    	    }
			    	    
				    	document.removeEventListener("keydown", handleKeyDown);				    	
			    	});	 
		    		//end
		    		
// 		    		document.getElementById("_addEmoticon").src = "/images/poll/add_emo_vote2.png";
		    		event.target.src = "/images/poll/add_emo_vote2.png";
			    	processGroupStickers();
			    	stickerIndex = 1;		    	
			    	document.getElementById("_group1").style.backgroundColor  = "#d9d9d9";
			    	document.getElementById("_listG1").style.display = "block";
			    	
			    	for (var i = 2; i <= numberOfGroupSticker; i++) {
			    		document.getElementById("_group" + i).style.backgroundColor  = "#fff";
			    		document.getElementById("_listG" + i).style.display = "none";
			    	}		    		    	
			    	
			    	targetPanel.style.display = "block";
			    	checkScrollBars();
// 			    	emoticonPanelClose();
		    	}
		    }
		    
		    function changeStickerGroup(obj) {		    	
		    	document.getElementById("_group" + stickerIndex).style.backgroundColor  = "#fff";
		    	obj.style.backgroundColor  = "#d9d9d9";
		    	document.getElementById("_listG" + stickerIndex).style.display = "none";
		    	var imageTag = obj.firstElementChild;
		    	
		    	/* 이모티콘 추가 시 사용가능성 있음.*/
		    	/* if (imageTag.src.indexOf("girl.png") !== -1) {		    		
		    		stickerIndex = 1;		    		
		    	} */
		    	
		    	stickerIndex = 1;	
		    	
		    	document.getElementById("_listG" + stickerIndex).style.display = "block";
		    	checkScrollBars();
		    }
		    
		    function displaySticker(obj) {				    	
		    	var style = obj.currentStyle || window.getComputedStyle(obj, false);
		    	var bgImage = style.backgroundImage.slice(4, -1);
		    	var actualUrl = "";
		    	
		    	if (bgImage.slice(-1) === '"') {		    		
		    		actualUrl = bgImage.slice(bgImage.indexOf("/images/"), -1);
		    	}
		    	else {		    		
		    		actualUrl = bgImage.slice(bgImage.indexOf("/images/"));
		    	}		    				   	    		    	

		    	//Close sticker picker
		    	document.getElementById("emoticonPanel").style.display = "none";
		    	document.getElementById("_addEmoticon").src = "/images/poll/add_emo_vote.png";
		    	
		    	if (document.getElementById("sendComment").style.display !== "none") {
			    	//Add sticker in uploadFile element
			    	document.getElementById("uploadedFile").style.display = "inline-block";
			    	var imagePreview = document.getElementById("previewImage");
			    	var cancelPreview = document.getElementById("cancelImg");
			    	cancelPreview.setAttribute("_type", "sticker");
			    	imagePreview.setAttribute("_fileInfo", actualUrl);
			    	imagePreview.setAttribute("_type", "sticker");
			    	imagePreview.src = actualUrl;
			    	document.getElementById("sendBttn").style.backgroundColor = "#0470e4";
			    	document.getElementById("sendBttn").disabled = false;
		    	}
		    	else {
		    		//In editing situation
		    		var editPreviewTag = document.getElementById("editPreviewImg" + currentEditingCmt);
		    		editPreviewTag.setAttribute("_type", "sticker");
		    		editPreviewTag.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px; height: 80px; width: 80px;");
		    		editPreviewTag.src = actualUrl;
		    		var childElmNumber = editPreviewTag.parentElement.childElementCount;
		    		
		    		if (childElmNumber == 1) {
		    			// Add cancel image in top right of files/sticker
		    			var cancelImg = document.createElement("img"); 
		    			cancelImg.src = "/images/close.png";
		    			cancelImg.setAttribute("style", "height: 20; width: 20px; top: 0px; left: 20px; position: absolute; cursor: pointer;");
		    			cancelImg.onclick = function () { deleteFileInCmt(); };
		    			editPreviewTag.parentElement.appendChild(cancelImg);
		    		}
		    		
		    		editPreviewTag.parentElement.style.display = "block";
		    		document.getElementById("clA2cmt" + currentEditingCmt).style.backgroundColor = "#0470e4";
		    		document.getElementById("clA2cmt" + currentEditingCmt).disabled = false;
		    	}

		    }
		    
		    function processGroupStickers() {				
		    	
		    	numberOfGroupSticker = document.getElementById("_listG1").getElementsByTagName("table").length;
		    	
		    	/* 스티커 그룹 페이징 처리 영역  이모티콘 그룹이 추가되면 주석 풀어야 함. */
		    	/* if (numberOfGroupSticker > 8) {
		    		currentGroupSticker = 8;
		    		
		    		for (var i = 9; i <= numberOfGroupSticker; i++) {
		    			document.getElementById("_group" + i).style.display = "none";
		    		}
		    		
		    		document.getElementById("nextEmoticon").src = "/images/next.png";
		    		document.getElementById("nextEmoticon").style.cursor = "pointer";
		    		document.getElementById("nextEmoticon").onclick = function () { showNextGroupSticker(); };
		    	}
		    	else if(numberOfGroupSticker > 4) {	    		
		    		for (var i = numberOfGroupSticker + 1; i <= 8; i++) {
		    			document.getElementById("_group" + i).style.display = "none";
		    		}		    		
		    	} */
		    }
		    
		    function showNextGroupSticker() {
		    	currentGroupSticker = currentGroupSticker + 1;
		    	document.getElementById("_group" + (currentGroupSticker - 8)).style.display = "none";
		    	document.getElementById("_group" + currentGroupSticker).style.display = "block";
		    	document.getElementById("previousEmoticon").src = "/images/previous.png";
		    	document.getElementById("previousEmoticon").style.cursor = "pointer";
		    	document.getElementById("previousEmoticon").onclick = function() { showPreviousGroupSticker(); };
		    	
		    	if (currentGroupSticker >= numberOfGroupSticker) {
		    		document.getElementById("nextEmoticon").src = "/images/next1.png";
		    		document.getElementById("nextEmoticon").onclick = null;
		    		document.getElementById("nextEmoticon").style.cursor = "default";
		    	}
		    }
		    
		    function showPreviousGroupSticker() {
		    	document.getElementById("_group" + currentGroupSticker).style.display = "none";
		    	document.getElementById("_group" + (currentGroupSticker - 8)).style.display = "block";
		    	currentGroupSticker = currentGroupSticker - 1;			    	
		    	document.getElementById("nextEmoticon").src = "/images/next.png";
	    		document.getElementById("nextEmoticon").style.cursor = "pointer";
	    		document.getElementById("nextEmoticon").onclick = function () { showNextGroupSticker(); };
	    		
		    	if (currentGroupSticker == 8) {
		    		document.getElementById("previousEmoticon").src = "/images/previous1.png";
		    		document.getElementById("previousEmoticon").onclick = null;
		    		document.getElementById("previousEmoticon").style.cursor = "default";
		    	}
		    }
		    
		    function updateNewCmt(userId, userName, attach, type, name, path, txtContent, cmtTime, userPhoto, deptId) {		    	
		    	var oTable = document.getElementById("commentListView");
		    	
		    	//Create the tr element
		    	objTr = document.createElement("tr");
		    	
		    	//Process td1 (user image) element
		    	var objTd = document.createElement("td");
		    	objTd.setAttribute("class", "userPhotoTd");
                var image_tag = document.createElement("img");                
                image_tag.src = userPhoto;
                image_tag.setAttribute("class", "userPhotoImg");
                image_tag.onclick = function () { menuQst_DetailUserInfo(userId, deptId); };
                objTd.appendChild(image_tag);
                objTr.appendChild(objTd);
                
              	//Process td2 (user information and comment information) element
                var objTd2 = document.createElement("td");
                var div1ForTd2 = document.createElement("div");
                var div2ForTd2 = document.createElement("div");  
                var editDiv2ForTd2 = document.createElement("div");  
                editDiv2ForTd2.setAttribute("id", "editCmtDiv" + commentIndex);   
                editDiv2ForTd2.style.display = "none"; 
                
                //div2ForTd2.setAttribute("style", "display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 98%;");               
                div2ForTd2.setAttribute("class", "div2cmt");              
                div2ForTd2.setAttribute("id", "div2Cmt" + commentIndex);                
                div1ForTd2.innerHTML = userName;
                div1ForTd2.setAttribute("class", "userNameNewCmt");
                
                //Add text comment if exists
                if (txtContent.length > 0) {
                	//txtContent = txtContent.replace(/(?:\r\n|\r|\n)/g, '<br />');
                	var pForTd2 = document.createElement("p");  
                	//pForTd2.innerHTML = txtContent;
                	pForTd2.textContent = txtContent;
                	pForTd2.setAttribute("class", "cmtArea");
                	pForTd2.setAttribute("id", "cmtArea" + commentIndex);
                	div2ForTd2.appendChild(pForTd2);
                }
                
              	//Add files/sticker if exists
                if (attach != "") {
                	var innerDiv1 = document.createElement("div");
                	innerDiv1.setAttribute("style", "padding-top: 5px;");
			    	var imgForinnerDiv1 = document.createElement("img");  	    	           
			    	imgForinnerDiv1.setAttribute("vertical-align", "middle");
			    	imgForinnerDiv1.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px;"); 
			    	
                	if (type == "sticker") {
                		imgForinnerDiv1.setAttribute("_type", "sticker");    
			    		imgForinnerDiv1.setAttribute("height", "80");
				    	imgForinnerDiv1.setAttribute("width", "80");					    	
			    		imgForinnerDiv1.src = attach;
			    		imgForinnerDiv1.setAttribute("_fileInfo", attach);  
			    		innerDiv1.appendChild(imgForinnerDiv1);
			    		div2ForTd2.appendChild(innerDiv1);
                	}
                	else {
			    		imgForinnerDiv1.src = attach;	
			    		innerDiv1.appendChild(imgForinnerDiv1);
			    		div2ForTd2.appendChild(innerDiv1);
			    		
			    		if (name == "") {
			    			imgForinnerDiv1.setAttribute("style", "cursor: pointer;  padding-left: 10px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
			    			imgForinnerDiv1.setAttribute("_fileInfo", attach);
			    			imgForinnerDiv1.setAttribute("_type", "images"); 
			    			imgForinnerDiv1.onclick = function () { downloadFileInCmt(this); };
			    		}
			    		else {	
					    	imgForinnerDiv1.setAttribute("height", "60");
					    	imgForinnerDiv1.setAttribute("width", "60");	
					    	imgForinnerDiv1.setAttribute("style", "cursor: pointer;  padding-left: 10px;");
					    	imgForinnerDiv1.setAttribute("_type", "file");
			    			imgForinnerDiv1.setAttribute("_fileInfo", path); 
			    			imgForinnerDiv1.setAttribute("_fileName", name);
			    			imgForinnerDiv1.onclick = function () { downloadFileInCmt(this); };
			    			
				    		var innerDiv2 = document.createElement("div");
				    		innerDiv2.innerHTML = name;
				    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
				    		innerDiv2.setAttribute("_fileInfo", path);   
				    		innerDiv2.setAttribute("_fileName", name);
				    		innerDiv2.onclick = function () { downloadFileInCmt(this); };
				    		innerDiv1.appendChild(innerDiv2);
			    		}			    		
                	}
                }
              	
                objTd2.appendChild(div1ForTd2);
                objTd2.appendChild(div2ForTd2);
                objTd2.appendChild(editDiv2ForTd2);
                objTr.appendChild(objTd2);             	            	
              	
                //Process td3 (comment time and edit comment) element
                var objTd3 = document.createElement("td");
                objTd3.setAttribute("class", "cmtTdRight");
                var fistChildForTd3 = document.createElement("div");
                fistChildForTd3.setAttribute("class", "cmtCreateTime");  
                fistChildForTd3.innerHTML = cmtTime;
                objTd3.appendChild(fistChildForTd3); 
                
                if (userId == curentUser) {
                    var imagForTd3 = document.createElement("img");                
                    imagForTd3.src = "/images/option3.png";
                    imagForTd3.setAttribute("_comtIndex", "editComt" + commentIndex);
                    imagForTd3.setAttribute("_inner", "innerEditComment" + commentIndex);
                    imagForTd3.setAttribute("class", "editCmtBtnImg");
                    imagForTd3.onclick = function (event) { event.stopPropagation(); showEditPanel(this); };
                    objTd3.appendChild(imagForTd3);
                    
                    var div1ForTd3 = document.createElement("div");
                    div1ForTd3.setAttribute("id", "editComt" + commentIndex);
                    div1ForTd3.setAttribute("class", "editComt");
                    div1ForTd3.setAttribute("tabindex", "0");        
                    var innerDiv1ForTd3 = document.createElement("div");
                    innerDiv1ForTd3.setAttribute("id", "_eCmt" + commentIndex);
                    innerDiv1ForTd3.setAttribute("class", "_eCmt");
                    innerDiv1ForTd3.innerHTML = "<spring:message code = 'ezPoll.t125'/>";
                    innerDiv1ForTd3.setAttribute("_comtIndex", "editComt" + commentIndex);               
                    innerDiv1ForTd3.onclick = function (event) { editComment(this); };
                    var innerDiv2ForTd3 = document.createElement("div");                
                    innerDiv2ForTd3.innerHTML = "<spring:message code = 'ezPoll.t126'/>";
                    innerDiv2ForTd3.setAttribute("class", "_dCmt");
                    innerDiv2ForTd3.setAttribute("_comtIndex", commentIndex);
                    innerDiv2ForTd3.onclick = function (event) { deleteComment(this); };
                    div1ForTd3.appendChild(innerDiv1ForTd3);
                    div1ForTd3.appendChild(innerDiv2ForTd3);
                    objTd3.appendChild(div1ForTd3);
                }                
                                                        
                objTr.appendChild(objTd3);             
//                 oTable.appendChild(objTr);
				//투표 댓글 위로 쌓이는 형태로 수정.
				$(oTable).prepend(objTr);
                
//                 window.scrollTo(0, document.body.scrollHeight);
		    }
		    
		    function updateCurrentCmt(cmdId, attachFilePath, fileType, fileName, filePath, txtContent) {	    			    	
		    	var div2Cmt = document.getElementById("div2Cmt" + cmdId);
		    	
		    	if (txtContent == "") {
		    		if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {
		    			div2Cmt.removeChild(div2Cmt.children[0]);
		    		}
		    	}
		    	else {		    		
		    		if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {
		    			//div2Cmt.firstElementChild.innerHTML = txtContent;
		    			div2Cmt.firstElementChild.textContent = txtContent;
		    			div2Cmt.firstElementChild.setAttribute("style", "word-wrap: break-word; margin-top: 0px;margin-bottom: 0px; white-space: pre-wrap; word-break: break-all;");
		    		}
		    		else {
		    			var pForTd2 = document.createElement("p");  
		    			//pForTd2.innerHTML = txtContent;
		    			pForTd2.textContent = txtContent;		    			
		    			pForTd2.setAttribute("style", "word-wrap: break-word; margin-top: 0px;margin-bottom: 0px; white-space: pre-wrap;");
		    			div2Cmt.insertBefore(pForTd2, div2Cmt.children[0]);
		    		}
		    	}
		    	
		    	if (attachFilePath == "") {
		    		if (div2Cmt.lastElementChild.tagName.toLowerCase() == "div") {
		    			div2Cmt.removeChild(div2Cmt.children[1]);
		    		}
		    	}
		    	else {					
		    		if (div2Cmt.childElementCount == 1) {						
		    			if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {		                	
		    				var innerDiv1 = document.createElement("div");
		                	innerDiv1.setAttribute("style", "padding-top: 5px;");
					    	var imgForinnerDiv1 = document.createElement("img");  	    	           
					    	imgForinnerDiv1.setAttribute("vertical-align", "middle");
					    	imgForinnerDiv1.setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px;");
					    	
					    	if (fileType == "sticker") {
					    		imgForinnerDiv1.setAttribute("_type", "sticker");					    		
					    		imgForinnerDiv1.setAttribute("height", "80");
						    	imgForinnerDiv1.setAttribute("width", "80");
						    	imgForinnerDiv1.onclick = "";
						    	imgForinnerDiv1.style.cursor = "default";
					    		imgForinnerDiv1.src = attachFilePath;	
					    		innerDiv1.appendChild(imgForinnerDiv1);
					    		div2Cmt.appendChild(innerDiv1);
					    	}
			    			else if (fileType == "images") {
					    		imgForinnerDiv1.setAttribute("_type", "images");					    		
						    	imgForinnerDiv1.setAttribute("style", "cursor: pointer; padding-left: 10px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
					    		imgForinnerDiv1.src = attachFilePath;	
					    		imgForinnerDiv1.setAttribute("_fileInfo", attachFilePath); 
					    		imgForinnerDiv1.onclick = function () { downloadFileInCmt(this); };
					    		innerDiv1.appendChild(imgForinnerDiv1);
					    		div2Cmt.appendChild(innerDiv1);
			    			}
			    			else {
					    		imgForinnerDiv1.setAttribute("height", "60");
						    	imgForinnerDiv1.setAttribute("width", "60");
						    	imgForinnerDiv1.setAttribute("style", "cursor: pointer; padding-left: 10px;");
						    	imgForinnerDiv1.setAttribute("_type", "file");
						    	imgForinnerDiv1.src = attachFilePath;
						    	imgForinnerDiv1.setAttribute("_fileInfo", filePath);
						    	imgForinnerDiv1.setAttribute("_fileName", fileName);
						    	imgForinnerDiv1.onclick = function () { downloadFileInCmt(this); };
						    	innerDiv1.appendChild(imgForinnerDiv1);		
						    	
					    		var innerDiv2 = document.createElement("div");
					    		innerDiv2.innerHTML = fileName;					    		
					    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
					    		innerDiv2.setAttribute("_fileInfo", filePath);
					    		innerDiv2.setAttribute("_fileName", fileName);
					    		innerDiv2.onclick = function () { downloadFileInCmt(this); };
					    		innerDiv1.appendChild(innerDiv2);
					    		div2Cmt.appendChild(innerDiv1);
			    			}					    	
		    			}
		    			else {		    				
		    				if (fileType == "sticker") {
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
			    				}
			    				
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px;");
		    					div2Cmt.firstElementChild.children[0].setAttribute("_type", "sticker");					    		
		    					div2Cmt.firstElementChild.children[0].setAttribute("height", "80");
		    					div2Cmt.firstElementChild.children[0].setAttribute("width", "80");	
		    					div2Cmt.firstElementChild.children[0].style.cursor = "default";
		    					div2Cmt.firstElementChild.children[0].onclick = "";
		    					div2Cmt.firstElementChild.children[0].src = attachFilePath;	
			    			}
			    			else if (fileType == "images") {
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
			    				}
			    				
			    				div2Cmt.firstElementChild.children[0].setAttribute("_type", "images");				    		
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
			    				div2Cmt.firstElementChild.children[0].src = attachFilePath;	
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileInfo", attachFilePath); 
			    				div2Cmt.firstElementChild.children[0].onclick = function () { downloadFileInCmt(this); };
			    			}
			    			else {
			    				div2Cmt.firstElementChild.children[0].setAttribute("height", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("width", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px;");
			    				div2Cmt.firstElementChild.children[0].setAttribute("_type", "file");
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileInfo", filePath); 
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileName", fileName);
			    				div2Cmt.firstElementChild.children[0].onclick = function () { downloadFileInCmt(this); };
			    				div2Cmt.firstElementChild.children[0].src = attachFilePath;
			    				
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.children[1].innerHTML = fileName;
			    					div2Cmt.firstElementChild.children[1].setAttribute("style", "cursor: pointer; padding-left: 15px;");
			    					div2Cmt.firstElementChild.children[1].setAttribute("_fileInfo", filePath);   
			    					div2Cmt.firstElementChild.children[1].setAttribute("_fileName", fileName);
			    					div2Cmt.firstElementChild.children[1].onclick = function () { downloadFileInCmt(this); };
			    				}
			    				else {
			    					var innerDiv2 = document.createElement("div");
						    		innerDiv2.innerHTML = fileName;					    		
						    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
						    		innerDiv2.setAttribute("_fileInfo", filePath);   
						    		innerDiv2.setAttribute("_fileName", fileName);
						    		innerDiv2.onclick = function () { downloadFileInCmt(this); };
						    		div2Cmt.lastElementChild.appendChild(innerDiv2);
			    				}
			    			}		    				
		    			}
		    		}
		    		else {		    			
		    			if (fileType == "sticker") {
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {
		    					div2Cmt.lastElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
		    				}
		    				
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "display: block; padding-left: 10px; padding-right: 5px;");
	    					div2Cmt.lastElementChild.children[0].setAttribute("_type", "sticker");					    		
	    					div2Cmt.lastElementChild.children[0].setAttribute("height", "80");
	    					div2Cmt.lastElementChild.children[0].setAttribute("width", "80");
	    					div2Cmt.lastElementChild.children[0].style.cursor = "default";
	    					div2Cmt.lastElementChild.children[0].onclick = "";
	    					div2Cmt.lastElementChild.children[0].src = attachFilePath;	
		    			}
		    			else if (fileType == "images") {
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {
		    					div2Cmt.lastElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
		    				}
		    				
		    				div2Cmt.lastElementChild.children[0].setAttribute("_type", "images");				    		
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px; max-width: 500px; max-height: 500px; width: auto; height: auto;");
		    				div2Cmt.lastElementChild.children[0].src = attachFilePath;
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileInfo", attachFilePath); 
		    				div2Cmt.lastElementChild.children[0].onclick = function () { downloadFileInCmt(this); };
		    			}
		    			else {
		    				div2Cmt.lastElementChild.children[0].setAttribute("height", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("width", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px;");
		    				div2Cmt.lastElementChild.children[0].setAttribute("_type", "file");
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileInfo", filePath); 
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileName", fileName);
		    				div2Cmt.lastElementChild.children[0].onclick = function () { downloadFileInCmt(this); };
		    				div2Cmt.lastElementChild.children[0].src = attachFilePath;
		    				
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {		    					
		    					div2Cmt.lastElementChild.children[1].innerHTML = fileName;
		    					div2Cmt.lastElementChild.children[1].setAttribute("style", "cursor: pointer; padding-left: 15px;");
		    					div2Cmt.lastElementChild.children[1].setAttribute("_fileInfo", filePath);   
		    					div2Cmt.lastElementChild.children[1].setAttribute("_fileName", fileName);
		    					div2Cmt.lastElementChild.children[1].onclick = function () { downloadFileInCmt(this); };
		    				}
		    				else {
		    					var innerDiv2 = document.createElement("div");
					    		innerDiv2.innerHTML = fileName;					    		
					    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
					    		innerDiv2.setAttribute("_fileInfo", filePath);   
					    		innerDiv2.setAttribute("_fileName", fileName);
					    		innerDiv2.onclick = function () { downloadFileInCmt(this); };
					    		div2Cmt.lastElementChild.appendChild(innerDiv2);
		    				}
		    			}		    			
		    		}
		    	}
		    	
		    	if (div2Cmt.style.display == "none") {
		    		div2Cmt.style.display = "inline-block";
		    	}
		    }
		    
		    function deleteCurrentCmt(cmdId) {
		    	var div2Cmt = document.getElementById("div2Cmt" + cmdId);
		    	
		    	if (div2Cmt == null) {
		    		return;
		    	}
		    	
	    		//Delete this row in comment table
	    		var oTable = document.getElementById("commentListView");
	    		var i = div2Cmt.parentNode.parentNode.rowIndex;
	    		oTable.deleteRow(i);
		    }
		    
		    function downloadFileInCmt(obj) {
		    	var filePath = obj.getAttribute("_fileInfo");		    	
		    	var fileName = obj.getAttribute("_fileName");
		    	
		    	if (fileName == null || fileName == "") {
		    		var ext = filePath.split('.').pop().toLowerCase();
		    		fileName = "_" + randString(40) + "." + ext;
		    		var pos = filePath.indexOf("/fileroot/");
		    		filePath = filePath.substring(pos, filePath.length);
		    	}	
		    	
		    	//var param1 = "/ezPoll/downloadAttach.do?folderPath=" + filePath +  "&filename=" + fileName;
		    	DownloadAttach(filePath, fileName);
		    }
		    
		    function clearFileInput(ctrl) {
		    	  try {
		    	    ctrl.value = null;
		    	  } 
		    	  catch(ex) { }
		    	  
		    	  if (ctrl.value) {
		    	    ctrl.parentNode.replaceChild(ctrl.cloneNode(true), ctrl);
		    	  }
		    }
		    
		    function randString(x) {
		        var s = "";
		        
		        while (s.length < x & x > 0) {
		            var r = Math.random();
		            s += (r < 0.1 ? Math.floor(r * 100):String.fromCharCode(Math.floor(r * 26) + (r > 0.5 ? 97:65)));
		        }
		        
		        return s;
		    }
		    
		    function sendMailAll(pQstID, pOptID) {
		    	var feature = GetOpenPosition(1200, 840);
		    	var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 1200) / 2;
		        window.open("/ezEmail/mailWrite.do?cmd=POLL&type=group&state=voted&qstId=" + pQstID + "&optId=" + pOptID, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 1200px, status = no, toolbar=no, menubar=no,location=no,resizable=1" + feature);
		    }
		    
		    //이모티콘 패널이 아닌 영역을 선택하면 패널이 닫힘
		    function emoticonPanelClose(){
		    	var emoticonPanel = document.getElementById("emoticonPanel");
		    	var targetPanel;
		    	if(event.target.parentElement){
			    	targetPanel = event.target.parentElement.querySelector(".emoticonPanel");
		    	}
		    	else{
		    		targetPanel = emoticonPanel;
		    	}
		    	if(targetPanel){
			        $(document).on("click.emo", function(e){
			            var target = e.target;
// 			            var onOff = targetPanel.getAttribute("style").indexOf("display: block")!= -1 ? true : false;
			            var panelDiv = $(".emoticonPanel").filter(function(idx, panel){
							return panel.style.display == "block";	            	
			            });
			            var onOff = !!panelDiv;
			            
			            if(onOff && target.id != "_addEmoticon"){
// 	                        addSticker();
							$(".emoticonPanel").hide();
							$("._addEmoticon").attr("src", "/images/poll/add_emo_vote.png");
			            }
			        });
		    	}
		    }
		    
		    //투표 버튼 누를 때 선택한 리스트의 정보를 바꾸어 줌.
		    function modifySelectedList(optId, mode){
		    	var optIdIdxInArr = selectedList.indexOf(optId);
		    	if(mode == 'add'){
		    		selectedList.push(optId);
		    	}else{
		    		selectedList.splice(optIdIdxInArr,1);
		    	}
		    }
		    
		    //낙장불입 처리
		    function selectOnlyOnce(idx) {
		    	var isSelOnlyOnce = ${question.isSelOnlyOnce};
		    	
		    	if(isSelOnlyOnce === 1){ //낙장불입 Y
		    		if(idx === -1){ //remove 일경우 		
		    			alert("<spring:message code = 'ezPoll.t261'/>");
		    		}
	    			return true;
		    	}else{ //낙장불입 N
		    		return false;
		    	}
		    }
		    
		    //이미지가 있어 td가 추가될 경우에도 투표종료 버튼 부분의 colspan을 조정해줌.
		    function optImgSearch(){
		    	var optImg = document.getElementById("_imgOptionBox1");
		    	var colspanNum = $("#_content1 tbody tr:eq(0) td").length;
		    	
		    	if(optImg === null){
		    		$("#voteBtnFooter").attr("colspan", colspanNum);
		    	}else{
		    		$("#voteBtnFooter").attr("colspan", colspanNum);
		    	}
		    }
		    
		    /* 2018-08-29 홍승비 - 이미지 확대 레이어팝업 IE 오류 수정 */
		  	//썸네일 이미지에 레이어 팝업 기능 관련
		    var tempTimer;
		    function addThumbnailEvent(){
		  		$(document)
// 		  		.on("mouseover",".thumbnail",function(e){thumbnailImgMouseOver(e);})
		    	.on("click", ".thumbCloseBtn", function(e){
					toggleImgPopupBox(e);
				}).on("click", ".thumbnail", function(e){
					toggleImgPopupBox(e);
				}).on("click", "#thumbMagnifyBtn", function(e){
					magnifyThumbnailSize();
				}).on("click", "#thumbZoomInBtn", function(e){
					zoomInImgPopup();
				}).on("mousedown", "#thumbZoomInBtn", function(e){
					e.target.style.color = "#0470e4";
					tempTimer = setInterval(zoomInImgPopup, 150);
				}).on("mouseup mouseleave", "#thumbZoomInBtn", function(e){
					e.target.style.color = "";
					if(tempTimer){
						clearInterval(tempTimer);
					}
				}).on("click", "#thumbZoomOutBtn", function(e){
					zoomOutImgPopup();
				}).on("mousedown", "#thumbZoomOutBtn", function(e){
					e.target.style.color = "#0470e4";
					tempTimer = setInterval(zoomOutImgPopup, 150);
				}).on("mouseup mouseleave", "#thumbZoomOutBtn", function(e){
					e.target.style.color = "";
					if(tempTimer){
						clearInterval(tempTimer);
					}
				}).on("click", "#imgPopup", function(e){
					var pwidth = window.screen.availWidth;
					var pheight = window.screen.availHeight;
		            var htmlString = "";
		            var imgPopupWindow = window.open("" , "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height="+ pheight + ",width="+ pwidth + ",top=0,left=0", "");
		            
		            htmlString = "<html><head><title><spring:message code='ezPortal.t49'/></title></head>";
					htmlString += "<body style='margin:0px;text-align:center;' onClick='window.close()'>";
					htmlString += "<div style='height:" + pheight + "px;width:" + pwidth + "px;vertical-align:middle;display:table-cell;'><img style='cursor:pointer;' src=" + e.target.src + "></div>";
					htmlString += "</body></html>";
					
					imgPopupWindow.document.write(htmlString);
					imgPopupWindow.document.close();
				});
		    }
		  	
		  	//썸네일에 마우스 오버할 때 처리.
		  	function thumbnailImgMouseOver(e){
	    		$("#imgPopupDiv, #imgPopupBox, #imgPopup").attr("style","");
		  		var iPBInnerDivH = $(".iPBInnerDiv").height();
		  		var imgPopupBox = $("#imgPopupBox");
		  		var imgPopupDiv = $("#imgPopupDiv");
		  		var imgPopup = $("#imgPopup");
		  		
		  		imgPopupBox.removeClass("imgPopupBoxOff imgPopupBoxMagnify").addClass("imgPopupBox");
	    		imgPopupDiv.removeClass("imgPopupDivMagnify").addClass("imgPopupDiv");
	    		imgPopup.removeClass("imgPopupOff imgPopupMagnify").addClass("imgPopup");
	    		imgPopup.attr("src", e.target.src);
	    		imgPopup.attr("_filename", e.target.getAttribute("_filename"));
	    		imgPopup.attr("title", e.target.getAttribute("_filename"));
	    		
	    		// src에 부여된 height값 읽어오지 못한 경우
	    		if (imgPopup.height() == 0){
		    		imgPopup.load (function() {
		    			$("#imgPopupDiv, #imgPopupBox, #imgPopup").css("display","");
		    			
		    			var imgPB_LeftOffset = (window.innerWidth-imgPopupBox.width()) / 2;
			    		var imgPB_TopOffset = (window.innerHeight-imgPopupBox.height()) / 2 + window.pageYOffset;
			    		var imgP_LeftOffset = (imgPopup.parent().width()-imgPopup.width()) / 2;
			    		
			    		imgPopupBox.css({"left": imgPB_LeftOffset, "top": imgPB_TopOffset});
			    		imgPopupDiv.css({"width": imgPopup.prop("offsetWidth")});
			    		imgPopup.css({"left": "", "top": ((imgPopupBox.height() - imgPopup.height()) / 2) - iPBInnerDivH});
			    		imgPopup.attr("zoom","1");
		    		});
	    		} else {
	    			$("#imgPopupDiv, #imgPopupBox, #imgPopup").css("display","");
	    			
	    			var imgPB_LeftOffset = (window.innerWidth-imgPopupBox.width()) / 2;
		    		var imgPB_TopOffset = (window.innerHeight-imgPopupBox.height()) / 2 + window.pageYOffset;
		    		var imgP_LeftOffset = (imgPopup.parent().width()-imgPopup.width()) / 2;
		    		
		    		imgPopupBox.css({"left": imgPB_LeftOffset, "top": imgPB_TopOffset});
		    		imgPopupDiv.css({"width": imgPopup.prop("offsetWidth")});
		    		imgPopup.css({"left": "", "top": ((imgPopupBox.height() - imgPopup.height()) / 2) - iPBInnerDivH});
		    		imgPopup.attr("zoom","1");
	    		}

	    		$("#thumbMagnifyBtn").removeClass("fa fa-minus-square").addClass("fa fa-plus-square");
	    		$("#thumbZoomInBtn, #thumbZoomOutBtn").parent().removeClass("iPBInnerDiv_Top").addClass("iPBInnerDiv_TopOff");
		  	}
		  	
		  	//썸네일 원본 크기로 보기 기능.
		  	function magnifyThumbnailSize(){
		  		var iPBInnerDivH = $(".iPBInnerDiv").height();
		  		var imgPopupDiv = document.getElementById("imgPopupDiv");
	    		var imgPopup = document.getElementById("imgPopup");
	    		var $imgPopupBox = $("#imgPopupBox");
		  		var $imgPopupDiv = $("#imgPopupDiv");
		  		var $imgPopup = $("#imgPopup");
	    		
		  		if($("#thumbMagnifyBtn").attr("class").indexOf("plus") != -1){
		  			$("#thumbMagnifyBtn").attr("class","fa fa-minus-square");
		  			$imgPopupDiv.css("overflow", "auto");
		  		}
		  		else{
		  			$("#thumbMagnifyBtn").attr("class","fa fa-plus-square");
		  			$imgPopup.css("width", "");
		  			$imgPopupDiv.css("overflow", "");
		  		}
		  		$imgPopup.attr("zoom","1");
	    		
	    		$("#thumbZoomInBtn, #thumbZoomOutBtn").parent().toggleClass("iPBInnerDiv_TopOff iPBInnerDiv_Top");
				$imgPopupBox.toggleClass("imgPopupBox imgPopupBoxMagnify");
	    		$imgPopupDiv.toggleClass("imgPopupDiv imgPopupDivMagnify");
	    		$imgPopup.toggleClass("imgPopup imgPopupMagnify");
	    		
	    		//imgPopupBox frame 가운데로 위치 조정.
	    		$imgPopupBox.css("left",(window.innerWidth-$imgPopupBox.width()) / 2);
	    		var iPBTopOffset = (window.innerHeight-$imgPopupBox.height()) / 2 + window.pageYOffset;
	    		/* if(window.innerHeight < $imgPopupBox.height()){
	    			$imgPopupBox.css("top", 0);
	    		} */
	    		if(iPBTopOffset < 0){
	    			$imgPopupBox.css("top", 0);
	    		}
	    		else{
		    		$imgPopupBox.css("top", iPBTopOffset);
	    		}
	    		$imgPopupDiv.width(imgPopup.offsetWidth);	    		
	    		//$imgPopup.css("left",($imgPopup.parent().width()-$imgPopup.width()) / 2);
	    		
	    		var imgPopupDivSH = imgPopupDiv.scrollHeight;
	    		var imgPopupDivCH = imgPopupDiv.clientHeight;
	    		var imgPopupCH = imgPopup.clientHeight;
	    		
	    		//imgPopup 세로 위치 조정.
	    		if( imgPopupCH > imgPopupDivCH && imgPopup.naturalHeight > 700 ){
	    			$imgPopup.css("top", 0);
	    		}else{
	    			$imgPopup.css("top",(($imgPopupBox.height() - $imgPopup.height()) / 2) - iPBInnerDivH);
	    		}
	    		
	    		//imgPopup 가로 위치 조정.
	    		/* if(imgPopupDivSH == imgPopupDivCH && imgPopup.naturalWidth > 400){
	    			//$imgPopup.css("top",(($imgPopupBox.height() - $imgPopup.height()) / 2) - iPBInnerDivH);
	    		}
	    		else if(imgPopupDivSH != imgPopupDivCH){
	    			$imgPopup.css({"left": "0", "zoom": 1});
	    		} */
		  	}
		  	
		  	//썸네일 이미지 팝업박스를 토글해준다.
		  	function toggleImgPopupBox(e){
		  		var imgPopupBox = $("#imgPopupBox");
		  		var imgPopupDiv = $("#imgPopupDiv");
		  		var imgPopup = $("#imgPopup");
		  		
		  		$("#imgPopupDiv, #imgPopupBox, #imgPopup").attr("style","");
		  		
		  		//마우스 오버 이벤트 없애는 작업과 함께 이미지 뷰어가 보이는 상태에서 다른 그림 선택했을 때 처리하기 위해 수정. 2018-06-19 홍대표
		  		if(imgPopup.attr("_filename") != e.target.getAttribute("_filename") && e.target.id !== "thumbCloseBtn"){
		  			thumbnailImgMouseOver(e);
		  			return;
		  		}
		  		
		  		if(imgPopup.attr("src")){
			  		imgPopupBox.removeClass("imgPopupBox").addClass("imgPopupBoxOff");
			  		imgPopupDiv.removeClass("imgPopupDivMagnify").addClass("imgPopupDiv");
			  		imgPopup.removeClass("imgPopup").addClass("imgPopupOff");
			  		imgPopup.removeAttr("src");
		  		}
		  		else if(e.target.getAttribute("class") === "thumbnail"){
		  			thumbnailImgMouseOver(e);
		  		}
		  	}
		  	
		  	//줌인버튼 기능.
		  	function zoomInImgPopup(){
		  		var zoom = 1;
		  		var zoomOffset = 0.1;
		  		var $imgPopupBox = $("#imgPopupBox");
		  		var $imgPopupDiv = $("#imgPopupDiv");
		  		var $imgPopup = $("#imgPopup");
		  		var imgPopupOrignW =  $imgPopup.prop("naturalWidth");
		  		
		  		//zoom이 숫자가 아닌 다른 형태로 넘어올 때 처리.
		  		if($imgPopup.attr("zoom").indexOf("%") != -1){
		  			zoom = parseFloat($imgPopup.attr("zoom").replace("%", "") / 100) + zoomOffset;
		  		}
		  		else if($imgPopup.attr("zoom").indexOf("normal") != -1){
		  			zoom = 1 + zoomOffset;
		  		}
		  		else{
			  		zoom = parseFloat($imgPopup.attr("zoom")) + zoomOffset;
		  		}
		  		zoom = zoom.toFixed(1);
		  		$imgPopup.attr("zoom", zoom);
		  		
		  		var iPBInnerDivH = $(".iPBInnerDiv").height();
		  		var thumbImgH = $imgPopup.prop("naturalHeight") * zoom;
		  		var imgPopupDiv = document.getElementById("imgPopupDiv");
	    		var imgPopup = document.getElementById("imgPopup");
		  		var imgPopupDivCH = imgPopupDiv.clientHeight;
		  		$imgPopup.width(imgPopupOrignW * zoom);
		  		$imgPopupDiv.width(imgPopupOrignW * zoom);
		  		
		  		//imgPopup 세로 위치 조정.
		  		if(thumbImgH < (imgPopupDivCH - 100)){
		  			var topOffset = "";
			  		topOffset = ((($imgPopupBox.height() - thumbImgH) / 2) - iPBInnerDivH);
			  		
		  			$imgPopup.css("top", topOffset);
		  		}
		  		else if(thumbImgH > (imgPopupDivCH - 100)){
		  			$imgPopup.css("top", 0);
		  			$imgPopupDiv.css("overflow", "auto");
		  		}
		
		  	}
		  	
		  	//줌아웃 버튼 기능.
		  	function zoomOutImgPopup(){
		  		var zoom = 1;
		  		var zoomOffset = 0.1;
		  		var $imgPopupBox = $("#imgPopupBox");
		  		var $imgPopupDiv = $("#imgPopupDiv");
		  		var $imgPopup = $("#imgPopup");
		  		var imgPopupOrignW =  $imgPopup.prop("naturalWidth");
		  		
		  		//zoom이 숫자가 아닌 다른 형태로 넘어올 때 처리.
		  		if($imgPopup.attr("zoom").indexOf("%") != -1){
		  			zoom = parseFloat($imgPopup.attr("zoom").replace("%", "") / 100) - zoomOffset;
		  		}
		  		else if($imgPopup.attr("zoom").indexOf("normal") != -1){
		  			zoom = 1 - zoomOffset;
		  		}
		  		else{
			  		zoom = parseFloat($imgPopup.attr("zoom")) - zoomOffset;
		  		}
		  		zoom = zoom.toFixed(1);
		  		
		  		// 0.1보다 작은 비율로는 축소 불가능
		  		if ( zoom >= 0.1 ) {
			  		$imgPopup.attr("zoom", zoom);
		  		} else {
		  			return;
		  		}
		  		
		  		var thumbImgW = imgPopupOrignW * zoom;
		  		var thumbImgH = $imgPopup.prop("naturalHeight") * zoom;
		  		var iPBInnerDivH = $(".iPBInnerDiv").height();
		  		var imgPopupDiv = document.getElementById("imgPopupDiv");
	    		var imgPopup = document.getElementById("imgPopup");
		  		var imgPopupDivCW = imgPopupDiv.clientWidth;
		  		var imgPopupDivCH = imgPopupDiv.clientHeight;
	    		$imgPopup.width(thumbImgW);
	    		$imgPopupDiv.width(thumbImgW);
	    		
		  		if(thumbImgW > (imgPopupDivCW - 100)){
		  			$imgPopup.css("left","");
		  		}
		  		
		  		//imgPopup 세로 위치 조정
		  		if(thumbImgH < (imgPopupDivCH - 100)){
		  			var topOffset = "";
					topOffset = ((($imgPopupBox.height() - thumbImgH) / 2) - iPBInnerDivH);
					
		  			$imgPopup.css("top", topOffset);
		  		}
		  		else if(thumbImgH > (imgPopupDivCH - 100)){
		  			$imgPopup.css("top", 0);
		  			$imgPopupDiv.css("overflow", "auto");
		  		}
		  	}
		  	
		  	//종료일 변경 기능
		  	function updateEndDate(){
		  		var fd = new FormData();
		  		var qstId = ${question.qstId};
				var N_EndTime   = $( "#eTimePicker option:selected" ).text() + ":59"; //20180109
	    		var N_EndDate   = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				var L_StartDateTime = "${question.startDate}";
		  		var L_StartTime = L_StartDateTime.substring(L_StartDateTime.indexOf(" ") + 1, L_StartDateTime.length);
		  		var L_StartDate = L_StartDateTime.substring(0, 10);
				var N_EndDateTime = N_EndDate + " " + N_EndTime;
				
				//종료일 유효성 체크
				if (L_StartDate > N_EndDate) {
		        	alert('<spring:message code="ezPoll.t236" />\n<spring:message code="ezPoll.t160" /> : ' + L_StartDateTime);
		        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        	$("#Edatepicker").datepicker('setDate', "${question.endDate}");
		            return false;
		        }
		        else if (L_StartDate == N_EndDate) {
		        	if (L_StartTime >= N_EndTime) {
		        		alert('<spring:message code="ezPoll.t236" />\n<spring:message code="ezPoll.t160" /> : ' + L_StartDateTime);
			            return false;
		        	}
		        }
				
		  		fd.append("qstId", qstId);
		  		fd.append("endDate", N_EndDateTime);
		  		
		  		xhr1.open("POST", "/ezPoll/updateEndDateForQst.do", false);
	    	    xhr1.send(fd);
	    	    window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollList.do?brdID=6";
		  	}
		  	
		  	function dateTimePickerSetting(){
		  		$.datepicker._checkExternalClick = "";
		  		$.datepicker._hideOriginDatepicker = $.datepicker._hideDatepicker;
		  		$.datepicker._hideDatepicker = function(){return false;};
		  		$("#Edatepicker").datepicker({
			        changeMonth: true,
		    	    changeYear: true,
		        	autoSize: true,
		        	showOn: "focus",
		        	format: 'yyyy-mm-dd',
		        	onSelect:function(dateText, inst){
		        		selDateTimePicker(inst);
		        	}
		    	});		
		
				var _endD = "<c:out value='${question.endDate}'/>";
				
		        
		        var eYear = _endD.substring(0, 4);
				var eMonth = _endD.substring(5, 7);
				var eDay = _endD.substring(8, 10);
				var eHour = _endD.substring(11, 13);
				var eMin = _endD.substring(14, 16);				
	        	EDate = new Date(eYear, eMonth-1, eDay);
	        	
	        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Edatepicker").datepicker('setDate', EDate);
	        	
	        	eHourMinute = eHour + eMin;	  
	        	
	        	var selection = "";
	        	var i = 0;
	        	for (var i = 0; i < 24; i++) {
	        	    var j = zeroFill(i, 2);
	        	    selection += "<option value='"+ j +"00'>"+ j + ":00" + "</option>";
	        	    selection += "<option value='"+ j +"30'>"+ j + ":30" + "</option>";
	        	} 
	        	
	        	$("#eTimePicker").html(selection);   	
	        	
	        	//Set time
    			setDateTimeValue();
    			var defaultOpt = $("#eTimePicker").find("[value='" + eHourMinute + "']")[0];
    			var defaultIdx = "";
    			if(defaultOpt){
	    			defaultOpt.selected = true;
	    			defaultIdx = defaultOpt.index;
    			}
    			
    			/* 2018-08-13 홍승비 - 투표모듈 DatePicker 다국어 설정 추가 */
    			var monthMsg = "<spring:message code='ezSchedule.t110' />";
			    var monthStr = monthMsg.split(";");		    
			    var dayMsg = "<spring:message code='ezSchedule.t108' />";
			    var dayStr = dayMsg.split(";");
			    
    			 $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		        	closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
    			
    			$("#endDate").click(function() {
    				if($("#_dateTimePicker").css("display") == "none"){
	    				$("#_dateTimePicker").css("display", "inline-block");
	    				$("#Edatepicker").trigger("focus");
	    				$("#Edatepicker").datepicker("show");
	    				$("#ui-datepicker-div").show();
	    				$("#ui-datepicker-div").css("margin-top","5px")
	    				
    				}
    				else{
	    				$("#_dateTimePicker").css("display", "none");
	    				$("#Edatepicker").datepicker("setDate", EDate);
	    				document.getElementById("eTimePicker").selectedIndex = defaultIdx;
	    				$("#ui-datepicker-div").hide();
	    				$("#Edatepicker").datepicker("hideOrigin");
    				}
    			});
    			
    			$(window).resize(function() {
    				$("#_dateTimePicker").css("display", "none");
    				$("#Edatepicker").datepicker("setDate", EDate);
    				document.getElementById("eTimePicker").selectedIndex = defaultIdx;
    				$("#ui-datepicker-div").hide();
    				$("#Edatepicker").datepicker("hideOrigin");
    			})
    			
    			$("#dateConfirmBtn").click(function(){
    				endDateModifyConfirm(defaultIdx);
    			});
		  	}
		  	
		  	function setDateTimeValue() {
				
				var NowDate = new Date(new Date().getTime());
				var NextWeek = new Date(new Date().getTime() + 7 * 24 * 60 * 60 * 1000);
				
	        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Edatepicker").datepicker('setDate', "${question.endDate}");			
	        	
	        	var selection = "";
	        	var i = 0;
	        	
	        	for (var i = 0; i < 24; i++) {
	        	    var j = zeroFill(i, 2);
	        	    selection += "<option value='"+ j +"00'>"+ j + ":00" + "</option>";
	        	    selection += "<option value='"+ j +"30'>"+ j + ":30" + "</option>";
	        	} 
	        	
	        	$("#eTimePicker").html(selection);
			}	
		  	
		  	function zeroFill( number, width ) {
				  width -= number.toString().length;
				  
				  if ( width > 0 ) {
				    return new Array( width + (/\./.test( number ) ? 2 : 1) ).join( '0' ) + number;
				  }
				  
				  return number + "";
			}
		  	
		  	//종료일 변경 다이얼로그창 띄움.
		  	function endDateModifyConfirm(idx){
		  		$("#Edatepicker, #eTimePicker").css("color", "#0470e4");
	  			window.setTimeout(
       				function(){
       					if(window.confirm("<spring:message code = 'ezPoll.hdp05'/>")){
		        			updateEndDate();
		        		}
		        		else{
		        			$("#Edatepicker").datepicker('setDate', EDate);
		        			document.getElementById("eTimePicker").selectedIndex = idx;
		        		}
  						$("#Edatepicker, #eTimePicker").css("color", "#000000");
        			}, 500);
		  	}
		  	
		  	//datepicker에서 날짜 선택시 효과
		  	function selDateTimePicker(inst){
		  		var selectedObj = $("#" + inst.dpDiv.attr("id") + " a.ui-state-default").eq(inst.selectedDay - 1);
		  		selectedObj.addClass("ui-state-highlight");
		  		setTimeout(function(){
			  		selectedObj.removeClass("ui-state-highlight");
		  		}, 300);
		  	}
		  	
		  	//웹소켓이 끊길 경우 처리.
		  	function stompDisConnProcess(){
		  		var qstId = "${question.qstId}";
		  		var brdId =	"${brdId}";
		  		var rightFrames = window.parent.frames["right"];
		  		setInterval(function(){
		  			if(stompClient.connected === false && rightFrames != null){
		  				rightFrames.location.href = "/ezPoll/pollVote.do?qstId=" + qstId + "&brdId=" + brdId;
		  			}else if(stompClient.connected === false && rightFrames == null){
		  				window.location.reload();
		  			}
		  		}, 10000);
		  	}
		  	
		  	//목록 버튼 눌렀을 때 리스트로 이동.
		  	function gotoList(){
		  		var gotoList = 1;
	  			var params = "<c:out value='${params}'/>";
		  		var pollType = 1;
		  		if(params != null){
		  			var paramsArr = params.split(",");
		  			pollType = paramsArr[4];
		  		}
		  		
		  		if(window.parent.frames["right"] !== undefined){
			  		window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollList.do?qstId=" + qstId + "&gotoList=" + gotoList + "&params=" + params;
		  		}
		  		//알림 메일로 받았을 경우 처리.
		  		else {
			  		window.location.href = "/ezPoll/pollList.do?qstId=" + qstId + "&gotoList=" + gotoList + "&params=" + params;
		  		}
		  	}
		  	
		  	function voteDelete(){
		    	var currentUser = "${curentUser}";
		    	var creator = "${question.creator}";
		    	var adminPrivilege = "${adminPrivilege}";
		    	var brdId = "${brdId}";
		  		if (currentUser !== creator && adminPrivilege != 1) {
		            alert('<spring:message code="ezPoll.t141"/>');
		            return;
		    	}	
		    	
	    		var feature = GetOpenPosition(420, 438);
		    	
		        var w = window.open("/ezPoll/confirmDeleteQuestion.do?brdID=" + brdId + "&listQst=" + qstId, "", "height=310px,width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        w.focus();
		  	}
		  	
		  	function stopButtonPosition(){
		  		var stopBtnDiv = $("#stopButton");
		  		var stopBtnToggle = $("#stopBtnToggle");
		  		var posFromTop = 0.95;
		  		if(stopBtnDiv){
		  			stopBtnDiv.css({"top":(window.innerHeight - stopBtnDiv.outerHeight()) * posFromTop});
		  			stopBtnToggle.css({"top":(window.innerHeight - stopBtnDiv.outerHeight()) * posFromTop});
		  			
		  			$(window).scroll(function(){
			  			var stopBtn_TopOffset = (window.innerHeight - stopBtnDiv.outerHeight()) * posFromTop;
			    		stopBtnDiv.css({"top":$(this).scrollTop() + stopBtn_TopOffset});
		  				stopBtnToggle.css({"top":$(this).scrollTop() + stopBtn_TopOffset});
	    			});
		  			
		  			$("#stopBtnToggle").click(function(){
		  				stopBtnDiv.toggle();
		  			});
		  		}
		  	}
		  	
		</script>
	</head>
	<xmp id="sigBody" style="display: none;">${question.content}</xmp>
	<body class="mainbody"  id="mainbodytag">
		<form method="post">
			<h1 style="margin-bottom: 16px;"><spring:message code='ezBoard.t371' /></h1>
			<div id="ballotSystemBody">
				<div id="mainmenu3" style="overflow: hidden;">
					  <div style="float: left; display: block;" class="voteInfo">
					  		
					  		<p class="voteInfoP"><img src="${question.creatorImage}" style="display:inline-block; float:left; cursor: pointer;" onclick="menuQst_DetailUserInfo('${question.creator}','${deptId}')"></p>
							<div id="textTest" style="display:inline-block;" class="voteTextTest">
								<c:choose>
									<c:when test="${primary == '1'}">
										<span class="questionFont"><c:out value='${question.creatorName1}'/></span>
									</c:when>
									<c:otherwise>
										<span class="questionFont"><c:out value='${question.creatorName2}'/></span>
									</c:otherwise>
								</c:choose>													
								<span style="padding-top: 5px;"><c:out value='${creatorDept}'/></span>	
								<span class="questionFontS"><c:out value='${question.createDate}'/></span>
							</div>
					  </div>
					  <div class="voteIconDiv">
							<ul class="voteIcon_ul">
								<li class="voteIconImg_li icon">
									<img src="/images/poll/icon_list.png" class="voteIconImg nosecret" onclick="gotoList()"  style="width:45px; border: 1px solid #ddd; border-radius: 15px;" title="<spring:message code = 'ezCommunity.t168'/>" onmouseover="this.src = '/images/poll/icon_list_hover.png'" onmouseout="this.src = '/images/poll/icon_list.png'" />
								</li>
							</ul>
							<ul class="voteIcon_ul">
								<li class="voteIconImg_li icon">
									<img id="reuseVoteImg" src="/images/poll/reuseVote.png" class="voteIconImg nosecret" onclick="voteReuse()"  style="width:45px" title="<spring:message code = 'ezPoll.t103'/><spring:message code = 'ezCircular.t183'/>" onmouseover="this.src = '/images/poll/reuseVote_hover.png'" onmouseout="this.src = '/images/poll/reuseVote.png'" />
								</li>
							</ul>
							<c:if test="${(curentUser == question.creator || adminPrivilege == 1) && question.status == 1}">
								<ul class="voteIcon_ul">
									<li class="voteIconImg_li icon">
										<img src="/images/poll/icon_voteDelete.png" class="voteIconImg nosecret" onclick="voteDelete()"  style="width:45px" title="<spring:message code = 'ezPoll.t103'/><spring:message code="ezPoll.t202"/>" onmouseover="this.src = '/images/poll/icon_voteDelete_hover.png'" onmouseout="this.src = '/images/poll/icon_voteDelete.png'" />
									</li>
								</ul>
							</c:if>
							<c:choose>
								<c:when test="${(curentUser == question.creator || adminPrivilege == 1) && (question.status == 1 || question.status == 2) && totalVotes == 0}">
									<ul class="voteIcon_ul">
										<li class="voteIconImg_li icon">
											<img id="editVoteImg" src="/images/poll/editVote.png" class="voteIconImg nosecret" onclick="voteEdit()" title="<spring:message code = 'ezEmail.t149'/>" onmouseover="this.src = '/images/poll/editVote_hover.png'" onmouseout="this.src = '/images/poll/editVote.png'" />
										</li>
									</ul>
								</c:when>
								<c:when test="${(curentUser eq question.creator || adminPrivilege == 1)}">
									<ul class="voteIcon_ul">
										<li class="voteIconImg_li icon endDate">
											<img id="endDate" src="/images/poll/endDateModify.png" class="voteIconImg nosecret" style="width:45px" title="<spring:message code = 'ezPoll.hdp04'/>" onmouseover="this.src = '/images/poll/endDateModify_hover.png'" onmouseout="this.src = '/images/poll/endDateModify.png'" />
											<div id="_dateTimePicker" style="display: none; position: fixed; top: 130px; right: 10px; height: 226px; width: 223px; background: white; border-radius: 10px; padding-top: 20px; border:1px solid #ddd; z-index:10;">										
												<input type="text" id="Edatepicker" style="width:80px; height: 20px; text-align:center; margin-left: 18px; margin-right: 5px; float: left; z-index: 10;" readonly >
												<select id="eTimePicker" style="float:left"></select>
												<i id="dateConfirmBtn" class="fa fa-check-circle"></i>
												<!-- <div style="height: 40px;width: 100%;position: relative;margin-top: 70px;">
													<img src="/images/ImgIcon/mtg-accept.png" style="width: 30px;margin-left: 50px;">
													<img src="/images/ImgIcon/mtg-decline.png" style="width: 30px; margin-left: 50px;">
												</div> -->			
											</div>
										</li>
									</ul>
								</c:when>
							</c:choose>
					  </div>
					  <div class="voteFuncIconDiv">
					  		<ul class="voteIcon_ul">
								<li class="voteIconImg_li icon">
									<c:choose>
										<c:when test="${question.secretVote == 0}">
											<img id="seenVoteUserImg" src="/images/poll/seen_vote_user.png" class="voteIconImg nosecret" title="<spring:message code = 'ezPoll.t112'/>" onclick="menuDetailSeenUserInfo('${question.qstId}')" onmouseover="this.src = '/images/poll/seen_vote_user_hover.png'" onmouseout="this.src = '/images/poll/seen_vote_user.png'" >
										</c:when>
										<c:otherwise>
											<img src="/images/poll/seen_vote_user.png" class="voteIconImg" title="<spring:message code = 'ezPoll.t112'/>" >
										</c:otherwise>
									</c:choose>
								</li>
								<li class="img_description">
									<div><span id="seenPeople">${seenUsers}</span></div>
								</li>
							</ul>
							<ul class="voteIcon_ul">
								<li class="voteIconImg_li icon" >
									<div class="voteIconImg_li_innerDiv">
										<c:choose>
											<c:when test="${question.secretVote == 0}">
												<img id="unvotedUserImg" src="/images/poll/unvoted_user.png" class="voteIconImg nosecret" title="<spring:message code = 'ezPoll.t123'/>" onclick="javascript:displayDetail('${question.qstId}')" onmouseover="this.src = '/images/poll/unvoted_user_hover.png'" onmouseout="this.src = '/images/poll/unvoted_user.png'" >
											</c:when>
											<c:otherwise>
												<img src="/images/poll/unvoted_user.png" class="voteIconImg" title="<spring:message code = 'ezPoll.t123'/>" >
											</c:otherwise>
										</c:choose>
									</div>
								</li>
								<li class="img_description">
									<div><span id="_unVotedNumber">${numberOfUnvotedUsers}</span></div>
								</li>
							</ul>
					  </div>
					  
				</div>
				<div id="titleAndContent">				
					<div id="title" class="questionTitle" ><!--<font size="5"><c:out value='${question.title}'/></font>-->
						<div class="baonkTest" title="<c:out value='${question.title}'/>"><c:out value='${question.title}'/></div>
						<div style="height: 40px; float:left; display:none;">
							<span id="status" style="font-weight: bold; color: #FFF;">
							<c:choose>
								<c:when test="${question.status == 1}"><spring:message code = 'ezPoll.t116'/></c:when>
								<c:otherwise>
									<c:if test="${question.status == 0}"><spring:message code = 'ezPoll.t117'/></c:if>
									<c:if test="${question.status == 2}"><spring:message code = 'ezPoll.t251'/></c:if>
								</c:otherwise>
							</c:choose>
							</span>
							<span id="votedUsers" style="font-weight: bold;">					
								&#40;<c:out value='${votedUsers}'/><spring:message code = 'ezPoll.t110'/>&#41;
							</span>
							 <c:if test="${question.status == 1}">
								<span id="daysRemain" style="font-weight: bold;">
									- <c:out value='${timeRemain}'/>
								</span> 			
							</c:if>
						</div>			
						<div id="voteInfoDiv" class="voteInfoDiv">
					  		<img class="voteInfoImg" src="/images/poll/voteInfo.png" title="<spring:message code = 'ezPoll.t103'/><spring:message code = 'ezApprovalG.t54'/>">
					  		<ul>
					  			<c:choose>
									<c:when test="${question.multiSelect == 0}">
										<li class="voteIconImg_li_info icon">
											<img src="/images/poll/numberOfSelect_${question.multiSelect}.png" class="voteIconImg_info" title="<spring:message code = 'ezPoll.t257'/> : <spring:message code = 'ezEmail.lhm67'/>" >
											<span><spring:message code = 'ezPoll.t257'/> : <spring:message code = 'ezEmail.lhm67'/></span>
										</li>
									</c:when>
									<c:otherwise>
										<li class="voteIconImg_li_info icon">
											<img src="/images/poll/numberOfSelect_${question.multiSelect}.png" class="voteIconImg_info" title="<spring:message code = 'ezPoll.t257'/> : ${question.multiSelect}" >
											<span><spring:message code = 'ezPoll.t257'/> : ${question.multiSelect}</span>
										</li>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${question.resultFirst == 1}">
										<li class="voteIconImg_li_info icon">
											<img src="/images/poll/seeResultBeforeVote_On.png" class="voteIconImg_info" title="<spring:message code = 'ezPoll.t258'/>" >
											<span><spring:message code = 'ezPoll.t258'/></span>
										</li>
									</c:when>
									<c:otherwise>
										<li class="voteIconImg_li_info icon">
											<img src="/images/poll/seeResultBeforeVote_Off.png" class="voteIconImg_info" title="<spring:message code = 'ezPoll.t256'/>" >
											<span><spring:message code = 'ezPoll.t256'/></span>
										</li>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${question.secretVote == 1}">
										<li class="voteIconImg_li_info icon">
											<img src="/images/poll/anonymousVote_On.png" class="voteIconImg_info" title="<spring:message code = 'ezPoll.hdp17'/>" >
											<span><spring:message code = 'ezPoll.hdp17'/></span>
										</li>
									</c:when>
									<c:otherwise>
										<li class="voteIconImg_li_info icon">
											<img src="/images/poll/anonymousVote_Off.png" class="voteIconImg_info" title="<spring:message code = 'ezPoll.t240'/>" >
											<span><spring:message code = 'ezPoll.t240'/></span>
										</li>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${question.isSelOnlyOnce == 1}">
										<li class="voteIconImg_li_info icon">
											<img src="/images/poll/selOnlyOnce_On.png" class="voteIconImg_info" title="<spring:message code = 'ezPoll.hdp01'/>" >
											<span><spring:message code = 'ezPoll.hdp01'/></span>
										</li>
									</c:when>
									<c:otherwise>
										<li class="voteIconImg_li_info icon">
											<img src="/images/poll/selOnlyOnce_Off.png" class="voteIconImg_info" title="<spring:message code = 'ezPoll.hdp02'/>" >
											<span><spring:message code = 'ezPoll.hdp02'/></span>
										</li>
									</c:otherwise>
								</c:choose>
					  		</ul>
						</div>
						<c:if test="${(curentUser == question.creator || adminPrivilege == 1) && question.status == 1}">
							<div id="stopButtonDiv" class="stopButtonDiv" onclick="finishVote()">
								<i class="far fa-stop-circle" title="<spring:message code = 'ezPoll.t124'/>"></i>
							</div>
						</c:if>	
					</div>
					
					
					<div class="pad1" style="vertical-align: top; padding-top:10px; width: 100%; border: none; display:inline-block; min-height: 150px;" id="messagetd">
		               <iframe onload="resizeFrame()" id="message_test" style="border: none; overflow: hidden; width: 100%; background-color: #FFF;"></iframe>   	                                 
		       	 	</div>				
				</div>

				<c:if test="${question.status eq '1'}">
				<span style="color: rgb(224, 67, 67); font-weight: bold;font-size: 15px; display: block; padding-bottom: 5px;">※ <spring:message code='ezPoll.kbh1' /></span>
				</c:if>
	
		        <c:if test="${numOfFile != 0}">
		        	<div id="attachedFile" class="vote_attachedFile" style="position:relative; overflow: hidden;display:inline-block; width: 100%; border-top:1px solid #e1ebf7; border-left:1px solid #e1ebf7; border-right:1px solid #e1ebf7; margin:0px 0px 20px 0px;">
		        		<img src="/images/poll/attach_file_vote.png" class="attach_img" style="float: left;display:block;" >
		        		<div class="txt" style="float: left;display:block; width:100%;">
		        			<spring:message code='ezEmail.t99000003' /> - <c:out value='${numOfFile}'/> <spring:message code='ezPoll.hdp16' />(<c:out value='${totalFilesSize}'/>)
		        		</div>
		        		<div class="all_save" style="display:block;">
		        			<span class="icon_grayup" id="BtnAttachDetail" onclick="AttachDetail_view(this);" style="display:inline-block;"></span> 
		        			<span class="title_btn" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='padding-top: 5px;cursor: pointer;display:inline-block;' onclick="AttachAllDownload();"><spring:message
										code='ezEmail.t99000004' /></span>
		        		</div>
		        		<div id="fileList" class="vote_fileList" style="width: 100%;">	        		
		  					<c:forEach var="list" items="${fileNames}" varStatus="status">
								<table class="content" style="width: 100%; height:32px; line-height:30px; border:none; border-bottom:1px solid #e1ebf7;">
									<tr>
										<td class="vote_listTd" style="border:none;">
											<span name="file_path" _file="<c:out value='${list}'/>" _path="${filePaths[status.index]}" onclick="DownloadAttachNew(this);" style="cursor:pointer; width:16px; height:16px; margin:0px; padding:0px 5px;">
												<img src="/images/poll/icon_adddownload_vote.gif" width="16" height="16" style="padding-left: 5px; vertical-align:middle; margin:-3px 0px 0px 0px;">											
											</span>
											<span _file="<c:out value='${list}'/>" _path="${filePaths[status.index]}" onclick="DownloadAttachNew(this);" style="cursor:pointer;">	
												<span onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style="cursor: pointer; color: rgb(102, 102, 102);"><c:out value='${list}'/> (${fileSizes[status.index]})</span>								
											</span>									
										</td>
									</tr>
								</table>   			
			        		</c:forEach>
						</div>  
				</div>
		        </c:if>	
				<table class="content" style="width:100%; min-width:800px; table-layout:fixed; height:32px; line-height:30px; border:1px solid #DDD; margin-bottom:20px" id="_content1">
                    <c:set var="fileFlag" value="false" />
	                <c:forEach var="optList" items="${listOptions}" varStatus="loop">
	                	<c:if test="${optList.filePath ne null }">
		               	 	<c:set var="fileFlag" value="true" />
	                	</c:if>
	                </c:forEach>
					<c:forEach var="_option" items="${listOptions}" varStatus="loop">
			        	<tr>
			        	   <c:if test="${question.status == 1 || question.status == 2}">
				               <td class="vote_listTd" style="width:54px; border:1px solid #DDD; background:#f9f9f9;" id="_checkbox<c:out value ="${_option.ansId}"/>">	    
				               		<img id="_imageCheckBox<c:out value ="${_option.ansId}"/>" onclick="javascript:change(this)" src="/images/poll/unchecked_vote.png"  name="${loop.index}" class="_imageTag"/>	               		             		         		
				               </td>
			               </c:if>
			        	   <c:if test="${fileFlag}">
				               <td class="vote_listTd _imgOption" id="_imgOptionBox<c:out value ="${_option.ansId}"/>">	    
				               		<%-- <c:if test="${_option.filePath ne null }">
				               			<img id="_imgOption<c:out value ="${_option.ansId}"/>" class="thumbnail" onclick="" src="/fileroot/1/files/upload_schedule/uploadFile/${fn:split(_option.filePath,'/')[0] }" />	               		             		         		
				               		</c:if> --%>
				               		<c:choose>
				               			<c:when test="${_option.filePath ne null }">
				               				<img id="_imgOption<c:out value ="${_option.ansId}"/>" class="thumbnail" onclick="" src="/fileroot/${question.tenantId}/files/upload_vote/uploadFile/${fn:split(_option.filePath,'/')[0] }" _fileName="${fn:split(_option.filePath,'/')[1] }" title="${fn:split(_option.filePath,'/')[1] }"/>
				               			</c:when>
				               			<c:otherwise>
				               				<img class="imgNotAttached" src="/images/poll/no_attachment.png"/>
				               			</c:otherwise>
				               		</c:choose>
				               </td>
			               </c:if>
			               <td class="vote_listTd" style="border:none; border-bottom:1px solid #DDD; height:94px; margin:0px; padding:0px 24px;" id="resultBox<c:out value ="${_option.ansId}" />">	   	               		
			               		<div id="optionContent<c:out value ="${_option.ansId}"/>" class="title01" style="display:block;"><c:out value ="${_option.content}"/></div> 
			               		<div id="graph<c:out value ="${_option.ansId}" />" style="float: left; display:none; width:100%; height:30px;">
			               				<div id="graphBar<c:out value ="${_option.ansId}" />" style="float:left; display:block; heigth:20px; margin:4px 0px 10px 0px;">
			               					<canvas class="graph01" id="myCanvas<c:out value ="${_option.ansId}" />"  height="20"></canvas>			               					               					
			               				</div>	
			               				<div id="voterNumber<c:out value ="${_option.ansId}" />" class="voterNumber" >0</div>		               				
			               				<script type="text/javascript">
			               					var loopIdx = ${loop.index};
			               					userNameArr[loopIdx] = [];
			               					var listUserAnswer = ${listOfUserAnswer};
			               					var voteNum = ${_option.votesNumber};
			               					var optionID = ${_option.ansId};
			               					// voteArr = [[opt1Id, opt1_value], [opt2Id, opt2_value],...]
			               					votesArr.push([optionID, voteNum]);		         
			               					for(var i = 0; i < listUserAnswer.length; i ++){
			               						if (listUserAnswer[i].ansId == optionID) {
													var tempObj = new Object();
													if (_primary == "1") {
														tempObj[listUserAnswer[i].userId] = listUserAnswer[i].userName1;
													}
													else {
														tempObj[listUserAnswer[i].userId] = listUserAnswer[i].userName2;
													}												
			               							userNameArr[loopIdx].push(tempObj);
			               						}
			               					}			               					
			               				</script>      					               			
			               		</div>
			               		<div id="voterNumber_<c:out value ="${_option.ansId}" />" class="voterNumber_" >0</div>
			               		<div id="voteInfo<c:out value ="${_option.ansId}" />" style="clear:both; display:none; height:20px;">              
			               			<div style="display:none; float:left; margin:2px 0px 0px 0px; height:20px; line-height:20px;" align="center" class="_thu${loop.index}"></div>
			               			<div style="display:none; float:left; margin:2px 0px 0px 0px; height:20px; line-height:20px;" align="center" class="_thu${loop.index}"></div>
			               			<div style="display:none; float:left; margin:2px 0px 0px 0px; height:20px; line-height:20px;" align="center" class="_thu${loop.index}"></div>
			               			<div style="display:none; float:left; margin:2px 0px 0px 0px; height:20px; line-height:20px;" align="center" class="_thu${loop.index}"></div>
			               			<div style="display:none; float:left; margin:2px 0px 0px 0px; height:20px; line-height:20px;" align="center" class="_thu${loop.index}"></div>
			               			<img id="mailSend<c:out value ="${_option.ansId}" />" src="/images/poll/sendMail.png" style="vertical-align:middle; margin-left:7px; cursor:pointer; display:none; margin-top: -7px; width:26px" onClick="sendMailAll('${question.qstId}','${_option.ansId}')"/>
			               			<div style="display:none; float:left; margin:2px 0px 0px 0px; height:20px; line-height:20px;" align="center" id="_tax${loop.index}">
			               				<div style="float:left; display:block; margin: 0px 0px 0px 10px; cursor: pointer;" id="vAll${loop.index}" onclick="javascript:displayVotedUser('${question.qstId}', '${_option.ansId}');"><spring:message code = 'ezPoll.t122'/></div>
			               				<img src="/images/arrow_right.png" height="14px" width="14px" style="cursor: pointer; float:left; display:block; margin: 2px 0px 0px 2px;" onclick="javascript:displayVotedUser('${question.qstId}', '${_option.ansId}')">
			               			</div>
			               		</div>          		
			               </td>		               
				          <td style="width:85px; border:1px solid #DDD; border-left:none;">	   	               		
				               	<div id="_resultPercentage<c:out value ="${_option.ansId}"/>" class="_resultPercentage" ></div>           		
				          </td>		               
			            </tr>
					</c:forEach>
					<tr>
						<td id="voteBtnFooter" class="voteTdBg" colspan="3" >
							<div class="voteTdBg_layout">
	                            <c:if test="${(curentUser == question.creator || adminPrivilege == 1) && question.status == 1}">
	                                <div id="_finish" class="voteBtnFooterInner" onclick="finishVote();">
	                                    <img src="/images/verified.png" style="display:none; height:15px; width:15px; float:left; vertical-align:middle; margin:12px 5px; cursor: pointer;">				
	                                    <div style="display:block; cursor: pointer;"><spring:message code = 'ezPoll.t124'/></div>
	                                </div> 
	                            </c:if>
	                    	</div>        
						</td>					
					</tr>
				</table>		
				<!--<c:if test="${curentUser == question.creator || adminPrivilege == 1}">
					<div id="_finish" style="border:1px solid #ddd; margin-right: auto; margin-left: auto; width:120px; height:40px; margin-top: 15px; cursor: pointer;" onclick="finishVote();">
						<img src="/images/verified.png" style="height:15px; width:15px; float:left; display:block; padding-top: 14px;padding-left: 5px; cursor: pointer;">				
						<div style="float:left; display:block; padding-top: 14px;padding-left: 14px; cursor: pointer;"><spring:message code = 'ezPoll.t124'/></div>
					</div> 
				</c:if>-->
				<c:if test="${!(hasVotePrivilege != 1 && question.status != 0) || adminPrivilege == 1 || curentUser == question.creator}">
					<div id="sendComment" class="voteComment">
		            	<div class="sendComment_layout">
						<div class="send_attach">
							<img id="_addFile" class="cmtAddFile" src="/images/poll/add_vote.png" onclick="addFileComment();">
						</div>
						<div id ="_stickerArea">					
							<div id="emoticonPanel" class="emoticonPanel" style="display:none">
								<div id="emoticonGroup" style="display:block;width:100%; height: 45px;background-color: #fff; border-bottom:1px solid #ddd;">
									<div style="float:left; display:block;">
										<img id="previousEmoticon" src="/images/previous1.png">
									</div>
									<div id="_ePresentors" style="float:left; display:block; ">
										<div id="_group1" style="background-color: #d9d9d9; float:left; display: block; height:45px; width:45px; cursor: pointer; " onclick="changeStickerGroup(this);"><img src="/images/emoticon/girl.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
										<!-- <div id="_group2" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/crayonShin.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
										<div id="_group3" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/catEmoticon.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
										<div id="_group4" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/student.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
										<div id="_group5" style="float:left; display: block; height:45px; width:45px; cursor: pointer; " onclick="changeStickerGroup(this);"><img src="/images/emoticon/hackerGirl.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
										<div id="_group6" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/crayonShin.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
										<div id="_group7" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/catEmoticon.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
										<div id="_group8" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/student.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div> -->
								   <!-- <div id="_group9" style="float:left; display: block; height:45px; width:45px; cursor: pointer; " onclick="changeStickerGroup(this);"><img src="/images/emoticon/hackerGirl.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
										<div id="_group10" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/crayonShin.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>  -->
									</div>
									<div style="float: right; display:block;">
										<img id="nextEmoticon" src="/images/next1.png">
									</div>
								</div>						
								<div id="emoticonList" style="display:inline-block;width:100%; background-color: #fff;">
									<div id="_listG1" style="height:310px; overflow-y: auto; overflow-x: hidden; display: block;">
										<table id="_listG1Table">
											<tr style="width:100%; height:45px;">
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set001.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set002.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set003.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set004.png);" onclick="displaySticker(this);"></div></td>
											</tr>
											<tr style="width:100%; height:45px;">
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set005.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set006.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set007.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set008.png);" onclick="displaySticker(this);"></div></td>
											</tr>
											<tr style="width:100%; height:45px;">
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set009.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set010.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set011.png);" onclick="displaySticker(this);"></div></td>
												<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/1set012.png);" onclick="displaySticker(this);"></div></td>
											</tr>
										</table>
									</div>
								</div>
							</div>					
							<img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker()">
						</div >				
						<div class="comment_input_layout">
							<!-- <textarea cols="20" rows="1" id="comment_input" oninput="auto_grow(this)" maxlength="500"></textarea> -->
							<input type="text" id="comment_input" oninput="auto_grow(this)" maxlength="500" style="width: 100%"/>
						</div>
						<div class="commentBtn">
							<div id="uploadedFile" class="uploadedFile" style="display:none;">
								<img id="cancelImg" class="cancelImg" src="/images/close.png"  onclick="cancelShowingCmtFile(this);">
								<img id="previewImage" class="previewImage">
							</div>	
							<button id="sendBttn" class="sendBttn" onclick="sendComment(); return false;"><spring:message code="ezPoll.t144"/></button>						
						</div>
						</div>
					</div>
				</c:if>
				<div id="commentArea" class="commentAreaDiv">
					<table style="width: 100%;" id="commentListView">
						<c:forEach var="_comt" items="${listComments}">
							<tr>
								<td class="userPhotoTd">
									<img class="userPhotoImg" src="${_comt.userImage}" onclick="menuQst_DetailUserInfo('${_comt.userId}','${_comt.deptId}');">
								</td>
								<td>
									<c:choose>
										<c:when test="${primary == '1'}">
											<div class="userName">${_comt.userName1}</div>
										</c:when>
										<c:otherwise>
											<div class="userName">${_comt.userName2}</div>
										</c:otherwise>
									</c:choose>							
									
									<div id="div2Cmt<c:out value ="${_comt.cmtId}" />" class="div2cmt">
										<c:if test="${_comt.textContent != ''}">
											<p id="cmtArea<c:out value ="${_comt.cmtId}" />" class="cmtArea"><c:out value ="${_comt.textContent}" /></p>
										</c:if>
										<c:if test="${_comt.imageAttach != ''}">
											<div style="padding-top: 5px;">
												<img _type="sticker" height=80 width=80 vertical-align="middle" style="display: block; padding-left: 10px; padding-right: 5px;" src="<c:out value ="${_comt.imageAttach}" />">
											</div>										
										</c:if>
										<c:if test="${_comt.fileAttach != ''}">
											<c:if test="${_comt.fileName != ''}">
												<div style="padding-top: 5px;">
													<img _type="file" height=60 width=60 vertical-align="middle" style="display: block; padding-left: 10px; padding-right: 5px; cursor: pointer;" src="<c:out value ="${_comt.fileAttach}" />" _fileName="<c:out value ="${_comt.fileName}" />" _fileInfo="<c:out value ="${_comt.filePath}"/>" onclick="downloadFileInCmt(this);">									
													<div style="cursor: pointer; padding-left: 15px;" _fileInfo="<c:out value ="${_comt.filePath}" />" _fileName="<c:out value ="${_comt.fileName}" />" onclick="downloadFileInCmt(this);"><c:out value ="${_comt.fileName}" /></div>						
												</div>					
											</c:if>
											<c:if test="${_comt.fileName == ''}">
												<div style="padding-top: 5px;">
													<img _type="images" vertical-align="middle" style="display: block; padding-left: 10px; padding-right: 5px; cursor: pointer; max-width: 500px; max-height: 500px; width: auto; height: auto;" src="<c:out value ="${_comt.fileAttach}" />" _fileName="<c:out value ="${_comt.fileName}" />" _fileInfo="<c:out value ="${_comt.fileAttach}" />" onclick="downloadFileInCmt(this);">
												</div>
											</c:if>
										</c:if>
									</div>
									<div id="editCmtDiv<c:out value ="${_comt.cmtId}" />" style="display: none;"></div>
								</td>
								<td class="cmtTdRight">
									<div class="cmtCreateTime"><c:out value ="${_comt.cmtTime}" /></div>
									<c:if test="${_comt.userId == curentUser}">								
										<img src="/images/option3.png" class="editCmtBtnImg" _comtIndex="editComt<c:out value ="${_comt.cmtId}"/>" onclick="(function(e){e.stopPropagation();})(event); showEditPanel(this);" >
										<div id="editComt<c:out value ="${_comt.cmtId}" />" class="editComt" tabindex=0>
											<div id="_eCmt<c:out value ="${_comt.cmtId}" />" class="_eCmt" _comtIndex="editComt<c:out value ="${_comt.cmtId}" />" onclick="editComment(this);"><spring:message code = 'ezPoll.t125'/></div>
											<div class="_dCmt" _comtIndex="<c:out value ="${_comt.cmtId}" />" onclick="deleteComment(this);"><spring:message code = 'ezPoll.t126'/></div>
										</div>
									</c:if>
								</td>
							</tr>
						</c:forEach>					
					</table>
				</div>
				
				<input id="fileInput" type="file" onchange="uploadFileCmt();" class="voteFileInput" />
			</div>	
		</form>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe> 
		<div id="imgPopupBox" class="imgPopupBoxOff">
    		<div style="height:50px;" class="iPBInnerDiv">
    			<div class="iPBInnerDiv_Top">
    				<i id="thumbCloseBtn" class="fa fa-times-circle thumbCloseBtn"></i>
    			</div>
    			<div class="iPBInnerDiv_Top">
    				<i id="thumbMagnifyBtn" class="fa fa-plus-square thumbMagnifyBtn"></i>
    			</div>
    			<div class="iPBInnerDiv_TopOff">
    				<i id="thumbZoomInBtn" class="fa fa-search-plus"></i>
   				</div>
   				<div class="iPBInnerDiv_TopOff">
    				<i id="thumbZoomOutBtn" class="fa fa-search-minus"></i>
   				</div>
   			</div>
   			<div id="imgPopupDiv" class="imgPopupDiv">
				<img id="imgPopup" class="imgPopup">
   			</div>
   		</div>
<%--    		<c:if test="${(curentUser == question.creator || adminPrivilege == 1) && question.status == 1}"> --%>
<!--    			<div id="stopBtnToggle" class="stopBtnToggle"></div> -->
<!-- 	   		<div id="stopButton" class="stopButton" onclick="finishVote()"> -->
<%-- 	   			<i class="far fa-stop-circle" style="margin: 7.5px;" title="<spring:message code = 'ezPoll.t124'/>"></i> --%>
<!-- 			</div> -->
<%-- 		</c:if> --%>
	</body>
</html>
