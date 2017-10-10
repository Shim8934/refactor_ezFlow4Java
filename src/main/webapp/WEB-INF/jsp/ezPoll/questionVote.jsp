<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezQuestion.t378' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<link rel="stylesheet" href="/css/ezPoll/vote.css" type="text/css">
		<script type="text/javascript" src="/js/ezPoll/stomp.min.js"></script>
		<script type="text/javascript" src="/js/ezPoll/sockjs.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<!-- <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script> -->
		
		<script type="text/javascript">	
			var filesize = 0;
			var xhr1 = new XMLHttpRequest();
			var hasVoted = "<c:out value='${hasVoted}'/>";
			var votePrivilege = "<c:out value='${hasVotePrivilege}'/>";
			var numberOfMultiSelect = "<c:out value='${question.multiSelect}'/>";
			var seeResultBeforVote = "<c:out value='${question.resultFirst}'/>";
			var secretVote = "<c:out value='${question.secretVote}'/>";
			var totalVotes = parseInt("<c:out value='${totalVotes}'/>");
			var s_Users = "<c:out value='${seenUsers}'/>";
			var qstId = "<c:out value='${question.qstId}'/>";
			var tenantId = "<c:out value='${question.tenantId}'/>";
			var curentUser = "<c:out value='${curentUser}'/>";
			var curentUserName = "<c:out value='${curentUserName}'/>";
			var numberOfSelected = 0;
			var maxLoop = 0;			
			var seenText = "분이 투표 내용을 확인했습니다";
			var _status = "<c:out value='${question.status}'/>";
			var sessionId = "<c:out value='${question.creator}'/>";			
			var commentIndex = ${numberOfCmt};
			var votedUsers = ${votedUsers};
			var window_open1;		
			var window_open2;
			var numberOptions = "<c:out value='${numberOfOptions}'/>";
			var votesArr = [];	
			var stickerIndex = null;
			var userNameArr = [[]];
			var stompClient = null;
			var numberOfGroupSticker = 4;	
			var currentGroupSticker = -1;
			var flagEvent = -1;
			var currentEditingCmt = -1;
			var colors = ["#49a0d8", "#d353a0", "#ffc527", "#df4c27","#34cb34","7127df"]; //add more colors
            var iframeStyle = "<style>";
            iframeStyle += "P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "DIV { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "TD { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "UL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "OL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "LI { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }";
            iframeStyle += "BODY { MARGIN-RIGHT: 10px; FONT-SIZE:10PT;LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic }";
            iframeStyle += "TABLE TD { text-indent: 0px }";
            iframeStyle += "BLOCKQUOTE { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}";
            iframeStyle += "</style>";          
            
    		window.onunload = function(){
    		    if (stompClient !== null) {
    		        stompClient.disconnect();
    		    }
        	}; 
            
			window.onload = function () {				
				commentCheck();				
 				getConnect(); 				
				document.getElementById("seenPeople").innerHTML = s_Users + seenText;
				document.getElementById("votedUsers").innerHTML = votedUsers + "명 참여";				
				document.getElementById("seenPeople").style.color="red";
				document.getElementById("status").style.color="#2828e2";								
	            var doc = document.getElementById("message_test").contentWindow.document;	        
				doc.open();
				doc.write(iframeStyle + sigBody.innerHTML);
				doc.close();							
 				//Result view segment
 				preProcess();
 				updateGraph();
			}		
					
			function commentCheck(){
				document.getElementById("sendBttn").addEventListener("click", function(event){
				    event.preventDefault()
				});
				document.getElementById("sendBttn").disabled = true;
			}
			
			function preProcess() {	
				var maxWidth =  document.getElementById("_content1").offsetWidth;
				maxLoop = Math.floor((maxWidth - 250)/80);
				
				if (maxLoop > 5) {
					maxLoop = 5;
				}	
				
				//Check if poll is ended
				if( _status == 0) { 
					for (var i = 0; i < numberOptions; i++) {
						var _optId = votesArr[i][0];
						var checkboxId = "_checkbox" + _optId;
						var resultBox = "resultBox" + _optId;						
						document.getElementById(checkboxId).style.display = "none";
						document.getElementById(resultBox).style.paddingLeft = "20px";
					}	
					
					var creator = "<c:out value='${question.creator}'/>";
					var admin = "<c:out value='${adminPrivilege}'/>";
					if (curentUser == creator || admin == 1) {
						document.getElementById("_finish").style.display = "none";
						document.getElementById("_editVote").style.display = "none";
					}
				}	
				else {				
					if (seeResultBeforVote != 1) {
						for (var i = 0; i < numberOptions; i++) {
							var _optId = votesArr[i][0];
							var graphId = "graph" + _optId;
							var showVotes = "voterNumber2" + _optId;	
							var voteInfo = "voteInfo" + _optId;							
							document.getElementById(graphId).style.display = "none";
							document.getElementById(showVotes).style.display = "none";
							document.getElementById(voteInfo).style.display = "none";
						}
					}
					
					if (hasVoted == 1) {
						var test = ${listSelectedOptions};
						
						for (var i = 0; i < test.length; i++) {
							var imageCheckBoxId = "_imageCheckBox" + test[i];
							var imageCheckBox = document.getElementById(imageCheckBoxId);
							if (imageCheckBox.src.indexOf("/images/unchecked.png") !== -1) {
								imageCheckBox.src = "/images/checked.png";
							}
						}
					}					
				}				
			}
			
			function updateGraph() {				
				for (var i = 0; i < numberOptions; i++) {
					var _optId = votesArr[i][0];					
					var graphId = "graph" + _optId;
					var voteInfo = "voteInfo" + _optId;
					var percentTdId = "_resultPercentage" + _optId; 				
					
					if (totalVotes > 0) {				
 						var percent = votesArr[i][1]/totalVotes;
 						
 						if (seeResultBeforVote == 1 || _status == 0 || hasVoted == 1) { 								
							document.getElementById(percentTdId).innerHTML = "[" + (percent * 100).toFixed(1) + "%]";
 						} 							
 					
						if (votesArr[i][1] != 0) {								
							var id = "myCanvas" + _optId;							
							var showVotes = "voterNumber" + _optId;							   					
		   					var canv = document.getElementById(id);
		   					
		   					document.getElementById(showVotes).innerHTML = votesArr[i][1];	
		   					
		   					if (seeResultBeforVote == 1 || _status == 0 || hasVoted == 1) {
			   					document.getElementById(graphId).style.display = "block";	
			   					document.getElementById(voteInfo).style.display = "block";
		   					}
		   					
		   					var test_width = document.getElementById(graphId).offsetWidth;
		   					var maxWidth_for_canvas = test_width - 40;	   					   					
							var test = Math.round(maxWidth_for_canvas * percent);	
							
							//Fill canvas with color
	 						canv.width = test;       					
	       					var ctx = canv.getContext("2d");
	       					ctx.shadowOffsetX = 2;
	       					ctx.shadowOffsetY = 2;
	       					ctx.shadowBlur = 2;
	       					ctx.shadowColor = "#999";
	       					var gradient = ctx.createLinearGradient(0, 0, test, 0);
	       					gradient.addColorStop(1, colors[i]);
	       					gradient.addColorStop(0, "#ffffff");
	       					ctx.fillStyle = gradient;
	       					ctx.fillRect(0, 0 , test, 20); 
	       					
	       					//Show vote infor
         					if (secretVote == 0) {
	       						var listUserAnswer = ${listOfUserAnswer};       						       						       						
	       						var tempLoop = 0;	       						
	       						
	       						if (maxLoop >= votesArr[i][1]) {
	       							tempLoop = votesArr[i][1];	       							
	       						}	       	
	       						else {
	       							tempLoop = maxLoop;
	       						}
	       						
	       						//console.log("Temp Loop is: " + tempLoop);	       						
	       						var tempClassId = "_thu" + i;	 
	       						var viewAll = "_tax" + i;
	       						var listDivs = document.getElementsByClassName(tempClassId);

	       						for (var j = 0; j < tempLoop; j++){
	       							listDivs[j].style.display = "block";	
	       							//listDivs[j].innerHTML = Object.values(userNameArr[i][j])[0];
	       							listDivs[j].innerHTML = Object.keys(userNameArr[i][j]).map(function(key){return userNameArr[i][j][key];})[0];
	       						}   
	       						
	       						if (votesArr[i][1] > tempLoop) {	       							
	       							document.getElementById(viewAll).style.display = "block";
	       						}
	       						else {	       							
	       							document.getElementById(viewAll).style.display = "none";
	       						}
	       					}
         					else {
         						document.getElementById(voteInfo).innerHTML = "무기명";
         					}
						}
						else {
							//Check if the poll is allowed see result before vote
							if (seeResultBeforVote != 0) {
								var showVotes = "voterNumber2" + _optId;
								document.getElementById(showVotes).style.display = "block";		
								document.getElementById(graphId).style.display = "none";
								document.getElementById(voteInfo).style.display = "block";
							}
							
							//If it is secret vote, then show 무기명 even no one votes for this option
							if (secretVote == 1 && seeResultBeforVote == 1){
								document.getElementById(voteInfo).style.display = "block";
								document.getElementById(voteInfo).innerHTML = "무기명";
							}
						}
					}
					else {
						document.getElementById(percentTdId).innerHTML = "";
						
						//Check if the poll is allowed see result before vote
						if (seeResultBeforVote != 0) {
							var showVotes = "voterNumber2" + _optId;
							document.getElementById(showVotes).style.display = "block";	
							document.getElementById(graphId).style.display = "none";
							document.getElementById(voteInfo).style.display = "block";
						}
					}
				}
			}
			
			function getConnect() {
			    //var socket = new WebSocket('ws://localhost:8080/ezFlow/hello');
			    //var socket = new WebSocket('ws://localhost:8080/ezFlow/hello/websocket');
			    var socket = new SockJS('/ezFlow/hello');
			    stompClient = Stomp.over(socket);			
			    stompClient.connect({}, function (frame) {		        			    
			    	stompClient.subscribe('/reply/getSeenUpdateForQst' + qstId + "+" + tenantId, function (updatedInfo) {
			        //stompClient.subscribe('/app/getSeenUpdate', function (updatedInfo) {
		        		var ret = JSON.parse(updatedInfo.body).updatedNumber;
		        	
			            if (ret != -1 && ret != s_Users) {
					    	s_Users = ret;
					    	document.getElementById("seenPeople").innerHTML = ret + seenText;	
					    	document.getElementById("seenPeople").style.color="red";
					    	
				    		if (window_open1 != null && !window_open1.closed) {	
				    			window_open1.location.reload();
					    	}	    						    	
					    }
			        });
			        
			        stompClient.subscribe('/reply/finishVoteForQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;
			        	console.log("Vote is changing!");
			            if (ret == "OK") {
							console.log("Running here!");
			            	document.location.href = "/ezPoll/pollVote.do?qstId=" + qstId;
					    }
				    });
			        
			        stompClient.subscribe('/reply/editQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;
			        	var user = JSON.parse(updatedInfo.body).userId;			        	
			            if (ret == "CHANGED" && user != curentUser) {
							//console.log("Vote is deleted!");
							alert(user + " is modifying the vote! Please wait!");
			            	document.location.href = "/ezPoll/pollList.do?brdID=6";
					    }
				    });
			        
			        stompClient.subscribe('/reply/deleteQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;	
			        	var user = JSON.parse(updatedInfo.body).userId;	
			            if (ret == "DELETED" && user != curentUser) {													
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
			        	
			            if (_userId != curentUser) {			          		
			            	if (_cmdId <= commentIndex) {
			          			alert("Something is wrong!");
			          			return;
			          		}
			            	updateNewCmt(_userId, _attachFilePath, _fileType, _fileName, _filePath, _txtContent, _cmtTime);
					    }
				    });
			        
			        stompClient.subscribe('/reply/editCmtForQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var _cmdId = JSON.parse(updatedInfo.body).cmId;	
			        	var _userId = JSON.parse(updatedInfo.body).userId;	
			        	var _attachFilePath = JSON.parse(updatedInfo.body).attachFilePath;
			        	var _fileType = JSON.parse(updatedInfo.body).fileType;
			        	var _fileName = JSON.parse(updatedInfo.body).fileName;
			        	var _filePath = JSON.parse(updatedInfo.body).filePath;
			        	var _txtContent = JSON.parse(updatedInfo.body).txtContent;

			            if (_userId != curentUser) {			          		
			            	if (_cmdId > commentIndex) {
			          			alert("Something is wrong!");
			          			return;
			          		}
			            	updateCurrentCmt(_cmdId, _attachFilePath, _fileType, _fileName, _filePath, _txtContent);
					    }
				    });
			        
			        stompClient.subscribe('/reply/getResultUpdateForQst' + qstId + "+" + tenantId, function (updatedInfo) {
			        	var optId = JSON.parse(updatedInfo.body).optionId;			        	
			        	var mode = JSON.parse(updatedInfo.body).mode;
			        	var user = JSON.parse(updatedInfo.body).userId;
			        	var userName = JSON.parse(updatedInfo.body).userName;
			        	
			        	if (user != curentUser) {
			        		var voteId = -1;							
				        	if (mode == 1) {
				        		//Adding mode
				        		var showVotes = "voterNumber2" + optId;
				        		document.getElementById(showVotes).style.display = "none";
				        		
				        		totalVotes = totalVotes + 1;
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
									if (userNameArr[voteId].map(function (o) {return o[user];}).indexOf(userName) === -1){	
										userNameArr[voteId].push(tempObj);
									}
				        		}
				        		updateGraph();
				        	}
				        	else {
				        		//Remove mode
				        		totalVotes = totalVotes - 1;					        		
				        		for (var i = 0; i < numberOptions; i++) {
				        			if (votesArr[i][0] == optId) {
				        				votesArr[i][1] = votesArr[i][1] - 1;
				        				voteId = i;
				        				break;
				        			}
				        		}	
				        		if (secretVote == 0) {
					        		//Remove userName if exist in userName Array
					        		var pos = userNameArr[voteId].map(function (o) {return o[user];}).indexOf(userName);					        		
									if ( pos > -1){	
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
			        	}			        	
			        });		        
			    });
			 }

			function voteEdit() {
				if (totalVotes > 0) {
					alert("Someone has already voted! You cannot edit this vote"); //chu y sua thanh tieng han
					return;
				}		
				var tenantId = "<c:out value='${question.tenantId}'/>";
				stompClient.send("/app/editVote", {}, JSON.stringify({'question': qstId, 'tenant': tenantId, 'user': curentUser}));
				document.location.href = "/ezPoll/pollCreate.do?qstId=" + qstId + "&mode=modify";				
		    }		
		    
		    function menuDetailSeenUserInfo(pQstID) {
		    	 //console.log("Run Here! QustID is: " + pQstID);
		    	 var feature = GetOpenPosition(420, 438);
		    	 window_open1 = window.open("/ezPoll/showSeenUserInfo.do?qstId=" + pQstID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
		    
		    function AttachDetail_view(obj) {
		        if (obj.className == "icon_graydown") {
		            obj.className = "icon_grayup"
		            document.getElementById("fileList").style.display = "";
		        }
		        else {
		            obj.className = "icon_graydown"
		            document.getElementById("fileList").style.display = "none";
		        }
		    }
		    
		    function DownloadAttach(downloadUrl) {
		        AttachDownFrame.location.href = downloadUrl;
		    }
		    
		    var suffix = 0;
		    function AttachAllDownload() {
		    	var test = ${numOfFile};
		    	
		        if (suffix < test) {
		        	setTimeout(function () { FileDownload(document.getElementsByName("file_path").item(suffix++).getAttribute("_filehref")) }, 2000);
		        }		            
		        else {	
		        	suffix = 0;
		            return;
		        }
		    }
		    
		    function FileDownload(pFileUrl) {
		        if (pFileUrl != null) {
		            AttachDownFrame.location.href = pFileUrl;
		            AttachAllDownload();
		        }
		        else {		
		        	suffix = 0;
		            return;
		        }
		    }
		    
		    function resizeFrame() {
				var iFrame = document.getElementById("message_test");
				iFrame.style.height = "10px";
				newheight = iFrame.contentWindow.document.body.scrollHeight;
				
				if (newheight > 350) {
					iFrame.style.height = "350px";
				}
				else {
					iFrame.style.height = (newheight + 10) + "px";
				}				
		    }
		    
		    function change(obj) {
	 	    	if (obj.src.indexOf("/images/unchecked.png") !== -1) {	 	    		   		
	 	    		if (votePrivilege == 0) {
	 	    			alert("You don't have privilege to vote for this poll!");
	 					return;
	 	    		}
	 	    		
	 	    		if (numberOfMultiSelect != 0 && numberOfSelected >= numberOfMultiSelect) {
	 					alert("The maximum selected options is: " + numberOfMultiSelect);
	 					return;
	 	    		}
	 	    		
	 	    		if(hasVoted == 0){
	 	    			votedUsers = votedUsers + 1; //Inform for other users
	 	    			hasVoted = 1;
	 	    			document.getElementById("votedUsers").innerHTML = votedUsers + "명 참여";
	 	    		}
	 	    		
	 	    		seeResultBeforVote = 1;
	 	    		numberOfSelected = numberOfSelected + 1;
	 	    		obj.src = "/images/checked.png";
		    		var voteId = obj.name;
		    		var optId = votesArr[voteId][0];		    	
		    		var showVotes = "voterNumber2" + optId;
		    		
		    		//update values of total votes and votes for current option 
		    		votesArr[voteId][1] = votesArr[voteId][1] + 1;
		    		totalVotes = totalVotes + 1;				
					document.getElementById(showVotes).style.display = "none";
					
					if (secretVote == 0) {
						//Update the userName array
						var tempObj = new Object();
						tempObj[curentUser] = curentUserName;
						if (userNameArr[voteId].map(function (o) {return o[curentUser];}).indexOf(curentUserName) === -1){	
							userNameArr[voteId].push(tempObj);
						}
					}
					
		    		//then update the graph for all options				    		
		    		updateGraph();
		    		
		    		//Update in server
		    		var xhr = new XMLHttpRequest();
		    	    var fd = new FormData();
		    	    fd.append("optionId", optId);
		    	    fd.append("questId", qstId);
		    	    fd.append("flag", "1");
		    	    xhr.open("POST", "/ezPoll/adjustJoinedUsers.do");
		    	    xhr.send(fd);		    		
		    	}
	 	    	else {
	 	    		obj.src = "/images/unchecked.png";
	 	    		var voteId = obj.name;
	 	    		var optId = votesArr[voteId][0];
	 	    		checkVoted();
	 	    		seeResultBeforVote = 1;	 	    			 	    		
	 	    		
	 	    		//Update infor
	 	    		numberOfSelected = numberOfSelected - 1;
	 	    		votesArr[voteId][1] = votesArr[voteId][1] - 1;
	 	    		totalVotes = totalVotes - 1;

					if (secretVote == 0) {
		 	    		var pos = userNameArr[voteId].map(function (o) {return o[curentUser];}).indexOf(curentUserName);
		 	    		
						if ( pos > -1){	
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
 	    			
 	    			//Delete entry in server
		    		var xhr = new XMLHttpRequest();
		    	    var fd = new FormData();
		    	    fd.append("optionId", optId);
		    	    fd.append("questId", qstId);
		    	    fd.append("flag", "0");
		    	    xhr.open("POST", "/ezPoll/adjustJoinedUsers.do");
		    	    xhr.send(fd);	
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
 	    			document.getElementById("votedUsers").innerHTML = votedUsers + "명 참여";
		    	}
		    }
		    
		    function displayDetail(pQstID) {		    	
		    	 var feature = GetOpenPosition(420, 438);
		    	 window_open2 = window.open("/ezPoll/showUnJoinedUsersInfo.do?qstId=" + pQstID, "", "height=438px,width=350px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
		    
		    function displayVotedUser(pQstID, pOptId) {		    		    
		    	var feature = GetOpenPosition(420, 438);
		    	window_open2 = window.open("/ezPoll/showVotedUsersInfo.do?qstId=" + pQstID + "&optId=" + pOptId, "", "height=438px,width=350px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
		    
		    function finishVote() {	    	
		    	var tenantId = "<c:out value='${question.tenantId}'/>";
		    	stompClient.send("/app/finish", {}, JSON.stringify({'question': qstId, 'tenant': tenantId}));		    	
		    }
		    
		    function menuQst_DetailUserInfo(pUserID){
		    	 var feature = GetOpenPosition(420, 438);
		         window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }	
		    
		    function test_func() {		    			    
		    	document.getElementById("sendBttn").disabled = false;		    	
		    }
		    
		    function showEditPanel(obj) {					    	
		    	if (flagEvent != -1) {					
		    		document.getElementById("editComt" + flagEvent).style.display = "none";
		    	}	
		    	
		    	var id = obj.getAttribute("_comtIndex");
		    	
		    	if (flagEvent == id.slice(8)){
		    		flagEvent = -1;
					return;
		    	}
		    	flagEvent = id.slice(8);	    	
		    	document.getElementById(id).style.display = "block";	
		    	
		    	document.addEventListener("click", function handleClick(e){		    									
			    	document.getElementById(id).style.display = "none"; 	
			    	document.removeEventListener("click", handleClick);
			    	flagEvent = -1;
		    	});	   	
		    }		    
		    
		    function deleteFileInCmt () {		    	
		    	document.getElementById("descriptCmt" + currentEditingCmt).style.display = "none";
		    	if (document.getElementById("descriptCmt" + currentEditingCmt).childElementCount == 3) {
		    		document.getElementById("descriptCmt" + currentEditingCmt).lastElementChild.innerHTML = "";
		    	}
		    	document.getElementById("toolCmt" + currentEditingCmt).style.display = "block";	
		    	if (document.getElementById("editCmtArea" + currentEditingCmt).value == "") {
		    		document.getElementById("clA2cmt" + currentEditingCmt).disabled = true;
		    	}
		    }
		    
		    function editComment(obj) {
		    	if (currentEditingCmt != -1) {
		    		var cancelObj = document.getElementById("clA1cmt" + currentEditingCmt);
		    		cancelEditComment(cancelObj);
		    	}
		    	
		    	document.getElementById("sendComment").style.display = "none";	
		    	var id = obj.getAttribute("_comtIndex");
		    	currentEditingCmt = id.slice(8);
		    	document.getElementById("_eCmt" + id.slice(8)).style.display = "none";	    		    	
		    	var div2Cmt = document.getElementById("div2Cmt" + id.slice(8));
		    	div2Cmt.style.display = "none";	
		    	var nChilds = div2Cmt.childElementCount;		    	
		    	var editDiv2Cmt = document.getElementById("editCmtDiv" + id.slice(8));	    	
		    	var innerDiv1 = document.createElement("div");
		    	innerDiv1.setAttribute("style", "display: inline-block;");		    	
		    	var innerDiv2 = document.createElement("div");	
		    	innerDiv2.setAttribute("id", "descriptCmt" + id.slice(8));
		    	innerDiv2.setAttribute("style", "display: none;  padding-left: 10px; position: relative;");	
		    	var innerDiv3 = document.createElement("div");	
		    	innerDiv3.setAttribute("style", "padding-top: 10px;");			    	
		    	editDiv2Cmt.appendChild(innerDiv1);
		    	editDiv2Cmt.appendChild(innerDiv2);
		    	
		    	//Inner div 2
		    	var imgForInnerDiv2 = document.createElement("img"); 
		    	imgForInnerDiv2.setAttribute("id", "editPreviewImg" + id.slice(8));
		    	imgForInnerDiv2.setAttribute("style", "display: block; height: 60px; width: 60px; ");	    	
		    	innerDiv2.appendChild(imgForInnerDiv2);		    	
		    	
		    	//Copy text comment
		    	var innInnerDiv1 = document.createElement("div");
		    	innInnerDiv1.setAttribute("style", "display: block; float:left; border:1px solid #b6b6b6;padding-left: 0px;margin-left: 7px; width: 500px;");
		    	var editTxtArea = document.createElement("textarea");
		    	editTxtArea.setAttribute("id", "editCmtArea" + id.slice(8));
		    	editTxtArea.setAttribute("cols", "20");
		    	editTxtArea.setAttribute("rows", "1");
		    	editTxtArea.setAttribute("style", "display: inline-block; overflow: hidden; outline: none; border: none; resize:none; padding-left: 5px; width: 90%;");
		    	editTxtArea.onkeyup =  function () { editAutoGrow(this); }	
		    	
		    	innInnerDiv1.appendChild(editTxtArea);		
		    	innerDiv1.appendChild(innInnerDiv1);	
		    	
	    		var innInnerDiv2 = document.createElement("div");
	    		innInnerDiv2.setAttribute("style", "display: none; float:left;");
	    		innInnerDiv2.setAttribute("id", "toolCmt" + id.slice(8));
	    		var divFile = document.getElementById("_addFile");
	    		var divSticker = document.getElementById("_stickerArea");
	    		var cloneOfDivFile = divFile.cloneNode(true);
	    		var cloneOfDivSticker = divSticker.cloneNode(true);
	    		innInnerDiv2.appendChild(cloneOfDivFile);
	    		innInnerDiv2.appendChild(cloneOfDivSticker);
	    		innerDiv1.appendChild(innInnerDiv2);
		    	
		    	//Copy file or sticker
		    	if (nChilds == 1) {		    		
		    		if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {		    			
			    		editTxtArea.value = div2Cmt.firstElementChild.innerHTML;
			    		innInnerDiv2.style.display = "block";
			    	}
		    		else {		    			
		    			innInnerDiv2.style.display = "none";		    			
		    			imgForInnerDiv2.src = div2Cmt.firstElementChild.firstElementChild.src;
		    			innerDiv2.style.display = "block";		    					    			
		    			
		    			//Add delete image
		    			var cancelImgForInnerDiv2 = document.createElement("img"); 
		    			cancelImgForInnerDiv2.src = "/images/close.png";
		    			cancelImgForInnerDiv2.setAttribute("style", "height: 20; width: 20px; top: 0; left: 50px; position: absolute; cursor: pointer;");
		    			cancelImgForInnerDiv2.onclick = function () { deleteFileInCmt(); };
		    			innerDiv2.appendChild(cancelImgForInnerDiv2);
		    			
		    			var fileType = div2Cmt.firstElementChild.firstElementChild.getAttribute("_type");	
		    			
		    			if (fileType == "file") {
		    				imgForInnerDiv2.setAttribute("_fileInfo", div2Cmt.firstElementChild.firstElementChild.getAttribute("_fileInfo"));
		    				imgForInnerDiv2.setAttribute("_type", "file");
		    				var nameDiv = document.createElement("div");
							nameDiv.innerHTML = div2Cmt.firstElementChild.lastElementChild.innerHTML;	
							nameDiv.setAttribute("style", "padding-left: 6px;");
							nameDiv.setAttribute("_fileInfo", div2Cmt.firstElementChild.firstElementChild.getAttribute("_fileInfo"));
							innerDiv2.appendChild(nameDiv);
		    			}
		    			else if (fileType == "images") {
		    				imgForInnerDiv2.setAttribute("_type", "images");
		    			}
		    			else {
		    				imgForInnerDiv2.setAttribute("_type", "sticker");
		    			}
		    		}
		    	}
		    	else {		    		
		    		innInnerDiv2.style.display = "none";
		    		//Copy file/sticker to an div then add delete image in the file/sticker
		    		editTxtArea.value = div2Cmt.firstElementChild.innerHTML;
		    		imgForInnerDiv2.src = div2Cmt.lastElementChild.firstElementChild.src;
		    		innerDiv2.style.display = "block";
		    			
	    			//Add delete image
	    			var cancelImgForInnerDiv2 = document.createElement("img"); 
	    			cancelImgForInnerDiv2.src = "/images/close.png";
	    			cancelImgForInnerDiv2.setAttribute("style", "height: 20; width: 20px; top: 0; left: 50px; position: absolute; cursor: pointer;");
	    			cancelImgForInnerDiv2.onclick = function () { deleteFileInCmt(); };
	    			innerDiv2.appendChild(cancelImgForInnerDiv2);
	    			
	    			var fileType = div2Cmt.lastElementChild.firstElementChild.getAttribute("_type");
	    			
	    			if (fileType == "file") {
	    				imgForInnerDiv2.setAttribute("_fileInfo", div2Cmt.lastElementChild.firstElementChild.getAttribute("_fileInfo"));
	    				imgForInnerDiv2.setAttribute("_type", "file");
	    				var nameDiv = document.createElement("div");
						nameDiv.innerHTML = div2Cmt.lastElementChild.lastElementChild.innerHTML;	
						nameDiv.setAttribute("style", "padding-left: 6px;");
						innerDiv2.appendChild(nameDiv);
	    			}
	    			else if (fileType == "images") {
	    				imgForInnerDiv2.setAttribute("_type", "images");
	    			}
	    			else {
	    				imgForInnerDiv2.setAttribute("_type", "sticker");
	    			}
		    	}	
		    	
		    	//Inner div 3
		    	var tagA1 = document.createElement("button"); 
		    	tagA1.innerHTML = "Cancel";
		    	tagA1.setAttribute("id", "clA1cmt" + id.slice(8));
		    	tagA1.setAttribute("_cmtIndex", id.slice(8));
		    	tagA1.setAttribute("style", "padding-left: 8px; cursor: pointer; ");
		    	tagA1.onclick = function (event) { event.stopPropagation(); event.preventDefault(); cancelEditComment(this); };
		    	
		    	var tagA2 = document.createElement("button");		    	
		    	tagA2.innerHTML = "Save";
		    	tagA2.setAttribute("id", "clA2cmt" + id.slice(8));
		    	tagA2.setAttribute("style", "padding-left: 8px; cursor: pointer; ");
		    	tagA2.setAttribute("_cmtIndex", id.slice(8));
		    	tagA2.onclick = function (event) { event.stopPropagation(); event.preventDefault(); saveEditComment(this); };
		    	innerDiv3.appendChild(tagA1);
		    	innerDiv3.appendChild(tagA2);
		    	
		    	editDiv2Cmt.appendChild(innerDiv3);
		    	editDiv2Cmt.style.display = "inline-block";	
		    	editTxtArea.focus(); 
		    }
		    
		    function cancelEditComment(obj){
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
		    
		    function saveEditComment(obj){
		    	console.log("Run in save edit comment!");
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
		    		fd.append("cmtTxt", document.getElementById("editCmtArea" + commentIndex).value);
		    		if (div2Cmt.firstElementChild.tagName.toLowerCase() == "p") {
		    			div2Cmt.firstElementChild.innerHTML = document.getElementById("editCmtArea" + commentIndex).value;
		    		}
		    		else {
		    			var pForTd2 = document.createElement("p");  
		    			pForTd2.innerHTML = document.getElementById("editCmtArea" + commentIndex).value;
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
					    		imgForinnerDiv1.src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
					    		innerDiv1.appendChild(imgForinnerDiv1);
					    		div2Cmt.appendChild(innerDiv1);
					    	}
			    			else if (fileType == "images") {
					    		imgForinnerDiv1.setAttribute("_type", "images");					    		
						    	imgForinnerDiv1.setAttribute("height", "60");
						    	imgForinnerDiv1.setAttribute("width", "60");	
						    	imgForinnerDiv1.setAttribute("style", "cursor: pointer;");
					    		imgForinnerDiv1.src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
					    		imgForinnerDiv1.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src); 
					    		innerDiv1.appendChild(imgForinnerDiv1);
					    		div2Cmt.appendChild(innerDiv1);
			    			}
			    			else {					    		
			    				imgForinnerDiv1.setAttribute("height", "60");
						    	imgForinnerDiv1.setAttribute("width", "60");
						    	imgForinnerDiv1.setAttribute("style", "cursor: pointer; padding-left: 10px;");
						    	imgForinnerDiv1.setAttribute("_type", "file");
						    	imgForinnerDiv1.src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;
						    	imgForinnerDiv1.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src); 
						    	innerDiv1.appendChild(imgForinnerDiv1);						    	
					    		var innerDiv2 = document.createElement("div");
					    		innerDiv2.innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;					    		
					    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
					    		innerDiv2.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);   
					    		innerDiv1.appendChild(innerDiv2);
					    		div2Cmt.appendChild(innerDiv1);
					    		fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML);
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
		    					div2Cmt.firstElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
			    			}
			    			else if (fileType == "images") {
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
			    				}
			    				div2Cmt.firstElementChild.children[0].setAttribute("_type", "images");					    		
			    				div2Cmt.firstElementChild.children[0].setAttribute("height", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("width", "60");	
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "cursor: pointer;");
			    				div2Cmt.firstElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src); 
			    			}
			    			else {
			    				div2Cmt.firstElementChild.children[0].setAttribute("height", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("width", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px;");
			    				div2Cmt.firstElementChild.children[0].setAttribute("_type", "file");
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src); 
			    				div2Cmt.firstElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.children[1].innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;
			    					div2Cmt.firstElementChild.children[1].setAttribute("style", "cursor: pointer; padding-left: 15px;");
			    					div2Cmt.firstElementChild.children[1].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);   
			    				}
			    				else {
			    					var innerDiv2 = document.createElement("div");
						    		innerDiv2.innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;					    		
						    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
						    		innerDiv2.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);   
						    		div2Cmt.lastElementChild.appendChild(innerDiv2);
			    				}
			    				fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML);
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
	    					div2Cmt.lastElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
		    			}
		    			else if (fileType == "images") {
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {
		    					div2Cmt.lastElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
		    				}
		    				div2Cmt.lastElementChild.children[0].setAttribute("_type", "images");					    		
		    				div2Cmt.lastElementChild.children[0].setAttribute("height", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("width", "60");	
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "cursor: pointer;");
		    				div2Cmt.lastElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;	
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src); 
		    			}
		    			else {		    				
		    				div2Cmt.lastElementChild.children[0].setAttribute("height", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("width", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px;");
		    				div2Cmt.lastElementChild.children[0].setAttribute("_type", "file");
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src); 
		    				div2Cmt.lastElementChild.children[0].src = document.getElementById("descriptCmt" + commentIndex).firstElementChild.src;
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {		    					
		    					div2Cmt.lastElementChild.children[1].innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;
		    					div2Cmt.lastElementChild.children[1].setAttribute("style", "cursor: pointer; padding-left: 15px;");
		    					div2Cmt.lastElementChild.children[1].setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);   
		    				}
		    				else {
		    					var innerDiv2 = document.createElement("div");
					    		innerDiv2.innerHTML = document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML;					    		
					    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
					    		innerDiv2.setAttribute("_fileInfo", document.getElementById("descriptCmt" + commentIndex).firstElementChild.src);   
					    		div2Cmt.lastElementChild.appendChild(innerDiv2);
		    				}
		    				fd.append("fileName", document.getElementById("descriptCmt" + commentIndex).lastElementChild.innerHTML);
		    			}
		    			fd.append("cmtAttach", div2Cmt.lastElementChild.children[0].src);
		    		}
		    	}
		    	
		    	//Delete all child of editCmtDiv element
		    	var editDiv2Cmt = document.getElementById("editCmtDiv" + commentIndex);
		    	while (editDiv2Cmt.hasChildNodes()) {
		    		editDiv2Cmt.removeChild(editDiv2Cmt.lastChild);
		    	}
		    	editDiv2Cmt.style.display = "none";	
		    	
		    	//Enable div2Cmt, sendComment and edit option
		    	div2Cmt.style.display = "inline-block";
		    	document.getElementById("_eCmt" + commentIndex).style.display = "block";
		    	document.getElementById("sendComment").style.display = "block";
		    	
		    	//Create a post request to update comment
		        fd.append("qstId", qstId);
		        fd.append("cmtId", commentIndex);		        		        
	    	    xhr1.open("POST", "/ezPoll/editComment.do");
	    	    xhr1.send(fd); 		  
		    }
		    
		    function deleteComment(obj) {
		    	console.log("Run in delete Comment function!");
		    	//currentEditingCmt = -1;
		    	var id = obj.getAttribute("_comtIndex");
		    	//document.getElementById(id).style.display = "none";
		    	if (confirm("<spring:message code = 'ezPoll.t207' />")) { 
		    		console.log("Delete comment!");
				    // Delete comment by sending a post request!
				    
				    
				} else {
				    // Cancel
				    console.log("Cancel!");
				}
		    }
		    
		    function sendComment() {		    	
		    	var fd = new FormData();
		    	commentIndex = commentIndex + 1;
		    	document.getElementById("sendBttn").disabled = true;		    		    		    		    	
		    	var currentText = document.getElementById("comment_input").value;		    			    	
		    	var oTable = document.getElementById("commentListView");
		    	//create the Tr field
		    	objTr = document.createElement("tr");
		    	objTr.setAttribute("style", "border-bottom: 1px solid #b6b6b6");
		    	
		    	//Td1
		    	var objTd = document.createElement("td");
		    	objTd.setAttribute("style", "padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; ");                  
                var image_tag = document.createElement("img");                
                image_tag.src = "/images/account.jpg";
                image_tag.setAttribute("style", "padding-top: 10px; height: 50px; width:50px; cursor: pointer; "); 
                image_tag.onclick = function () { menuQst_DetailUserInfo(curentUser); };
                objTd.appendChild(image_tag);
                objTr.appendChild(objTd);                          
                
                //Td2
                var objTd2 = document.createElement("td");
                var div1ForTd2 = document.createElement("div");
                var div2ForTd2 = document.createElement("div");  
                var editDiv2ForTd2 = document.createElement("div");  
                editDiv2ForTd2.setAttribute("id", "editCmtDiv" + commentIndex);   
                editDiv2ForTd2.style.display = "none"; 
                
                div2ForTd2.setAttribute("style", "display: inline-block; width: 40%; height: auto; padding-left: 8px; padding-bottom: 7px;padding-top: 2px;");               
                div2ForTd2.setAttribute("id", "div2Cmt" + commentIndex);                
                div1ForTd2.innerHTML = curentUser;
                div1ForTd2.setAttribute("style", "display: block; padding-left: 8px; padding-top: 10px; color: blue");       
                
                //Add text comment if exist
                if (currentText.length > 0) {
                	currentText = currentText.replace(/(?:\r\n|\r|\n)/g, '<br />');
                	var pForTd2 = document.createElement("p");  
                	pForTd2.innerHTML = currentText;
                	pForTd2.setAttribute("style", "word-wrap: break-word; margin-top: 0px;margin-bottom: 0px;");
                	pForTd2.setAttribute("id", "cmtArea" + commentIndex);
                	div2ForTd2.appendChild(pForTd2);                	
                	fd.append("cmtTxt", currentText);
                }
                
                //Add file if exist
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
					    	imgForinnerDiv1.setAttribute("height", "60");
					    	imgForinnerDiv1.setAttribute("width", "60");	
					    	imgForinnerDiv1.setAttribute("style", "cursor: pointer;");
				    		imgForinnerDiv1.src = "/files/commentImages/" + fileinfo.split("/")[0];	
				    		imgForinnerDiv1.setAttribute("_fileInfo", fileinfo);   
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
				    	imgForinnerDiv1.setAttribute("style", "cursor: pointer;  padding-left: 10px;");
				    	imgForinnerDiv1.setAttribute("_type", "file");
				    	imgForinnerDiv1.setAttribute("_fileInfo", fileinfo.split("/")[0]);   
				    	
				    	if (ext == "doc" || ext == "docx"){
				    		imgForinnerDiv1.src = "/images/msWord.png";
				    	}
				    	else if (ext == "ppt" || ext == "pptx"){
				    		imgForinnerDiv1.src = "/images/msPowerpoint.png";
				    	}
				    	else if (ext == "xls" || ext == "xlsx"){
				    		imgForinnerDiv1.src = "/images/msExcel.png";
				    	}
				    	else if (ext == ".hwp"){
				    		imgForinnerDiv1.src = "/images/hancomHWP.png";
				    	}
				    	else {
				    		imgForinnerDiv1.src = "/images/cmtFile.png";
				    	}				    	
				    	
			    		innerDiv1.appendChild(imgForinnerDiv1);
			    		div2ForTd2.appendChild(innerDiv1);
			    		var innerDiv2 = document.createElement("div");
			    		innerDiv2.innerHTML = fileinfo.split("/")[1];
			    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
			    		innerDiv2.setAttribute("_fileInfo", fileinfo.split("/")[0]);   
			    		innerDiv1.appendChild(innerDiv2);
			    		fd.append("fileName", innerDiv2.innerHTML);
			    		fd.append("filePath", fileinfo.split("/")[0]);
			    	}	
			    	fd.append("cmtAttach", imgForinnerDiv1.src);
		        }               
		        
                objTd2.appendChild(div1ForTd2);
                objTd2.appendChild(div2ForTd2);
                objTd2.appendChild(editDiv2ForTd2);
                objTr.appendChild(objTd2);
                
                //Td3
                var objTd3 = document.createElement("td");
                objTd3.setAttribute("style", "width: 145px; position: relative;");                
                var fistChildForTd3 = document.createElement("div");
                fistChildForTd3.setAttribute("style", "position: absolute; top:10px;");     
                fistChildForTd3.innerHTML = formatCmtTime();
                objTd3.appendChild(fistChildForTd3);                
                
                var imagForTd3 = document.createElement("img");                
                imagForTd3.src = "/images/option3.png";
                imagForTd3.setAttribute("_comtIndex", "editComt" + commentIndex);
                imagForTd3.setAttribute("_inner", "innerEditComment" + commentIndex);
                imagForTd3.setAttribute("height", "25");
                imagForTd3.setAttribute("width", "25");
                imagForTd3.setAttribute("vertical-align", "middle");
                imagForTd3.setAttribute("style", "float:right; display: block; cursor:pointer;");
                imagForTd3.onclick = function (event) { event.stopPropagation(); showEditPanel(this); };
                objTd3.appendChild(imagForTd3);
                
                var div1ForTd3 = document.createElement("div");
                div1ForTd3.setAttribute("style", "float:right; display: none; position: absolute; z-index: 10 ; border: 1px solid #b6b6b6; background-color: #576652; color: white;; margin-top: -14px; margin-right: 3px; width: 120px;");
                div1ForTd3.setAttribute("id", "editComt" + commentIndex);
                div1ForTd3.setAttribute("tabindex", "0");        
                var innerDiv1ForTd3 = document.createElement("div");
                innerDiv1ForTd3.setAttribute("id", "_eCmt" + commentIndex);
                innerDiv1ForTd3.innerHTML = "Edit Comment";
                innerDiv1ForTd3.setAttribute("_comtIndex", "editComt" + commentIndex);               
                innerDiv1ForTd3.setAttribute("style", "border-bottom: 1px solid #b6b6b6; text-align: center; padding-top: 5px;padding-bottom: 5px; cursor: pointer;");
                innerDiv1ForTd3.onclick = function (event) { editComment(this); };
                var innerDiv2ForTd3 = document.createElement("div");                
                innerDiv2ForTd3.innerHTML = "Delete Comment";
                innerDiv2ForTd3.setAttribute("_comtIndex", "editComt" + commentIndex);  
                innerDiv2ForTd3.setAttribute("style", "text-align: center; padding-top: 5px;padding-bottom: 5px; cursor: pointer;");         
                innerDiv2ForTd3.onclick = function (event) { deleteComment(this); };
                div1ForTd3.appendChild(innerDiv1ForTd3);
                div1ForTd3.appendChild(innerDiv2ForTd3);
                objTd3.appendChild(div1ForTd3);
                objTr.appendChild(objTd3);
                
                oTable.appendChild(objTr);                
                
                //Clean the place
                document.getElementById("comment_input").value = "";          
		        document.getElementById("uploadedFile").style.display = "none"; 	            
		        window.scrollTo(0, document.body.scrollHeight);
		        
		        //Send comment information to server
		        fd.append("qstId", qstId);
		        fd.append("cmtId", commentIndex);
		        fd.append("cmtTime", fistChildForTd3.innerHTML);		        
	    	    xhr1.open("POST", "/ezPoll/addComment.do");
	    	    xhr1.send(fd); 		        
		    }
		    
		    function formatCmtTime() {		    	
		    	var strTime = new Date().toTimeString().split(" ")[0];
		    	var strDateTime = new Date().toISOString();
		    	var strDate = strDateTime.substring(0, 10);
		    	return strDate + " " + strTime;
		    }
		    
		    function uploadFileCmt() {		    	
	    	    var fd = new FormData();		    	
		    	var _file = document.getElementById("file").files[0];
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
			    	document.getElementById("sendBttn").disabled = false;
		    	}
		    	else {
		    		//Editing situation
		    		imagePreview = document.getElementById("editPreviewImg" + currentEditingCmt);	    		    				    		
		    		var childElmNumber = imagePreview.parentElement.childElementCount;
		    		if (childElmNumber == 1) {
		    			// Add cancel image
		    			var cancelImg = document.createElement("img"); 
		    			cancelImg.src = "/images/close.png";
		    			cancelImg.setAttribute("style", "height: 20; width: 20px; top: 0; left: 50px; position: absolute; cursor: pointer;");
		    			cancelImg.onclick = function () { deleteFileInCmt(); };
		    			imagePreview.parentElement.appendChild(cancelImg);
						
						if (!(_ext == "jpg" || _ext == "png" || _ext == "bmp")) {
							imagePreview.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.setAttribute("_type", "file"); 
							var nameDiv = document.createElement("div");
							nameDiv.innerHTML = orgFileName;
							nameDiv.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							nameDiv.setAttribute("style", "padding-left: 6px;");
							imagePreview.parentElement.appendChild(nameDiv);							
						}
						else {
							imagePreview.setAttribute("_type", "images"); 
						}
		    		}
		    		else if (childElmNumber == 2) {
						if (!(_ext == "jpg" || _ext == "png" || _ext == "bmp")) {
							imagePreview.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.setAttribute("_type", "file"); 
							var nameDiv = document.createElement("div");
							nameDiv.innerHTML = orgFileName;	
							nameDiv.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							nameDiv.setAttribute("style", "padding-left: 6px;");
							imagePreview.parentElement.appendChild(nameDiv);							
						}
						else {
							imagePreview.setAttribute("_type", "images"); 
						}
		    		}
		    		else {
						if (!(_ext == "jpg" || _ext == "png" || _ext == "bmp")) {
							imagePreview.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.setAttribute("_type", "file"); 
							imagePreview.parentElement.lastElementChild.innerHTML = orgFileName;
							imagePreview.parentElement.lastElementChild.setAttribute("_fileInfo", fileinfo.split("/")[0]);
							imagePreview.parentElement.lastElementChild.setAttribute("style", "padding-left: 6px;");
						}	
						else {
							imagePreview.setAttribute("_type", "images"); 
						}
		    		}	   
		    		imagePreview.parentElement.style.display = "block";	
		    		document.getElementById("clA2cmt" + currentEditingCmt).disabled = false;
		    	}
		    	
		    	imagePreview.setAttribute("_type", "file");	
		    	
		    	if (_ext == "jpg" || _ext == "png" || _ext == "bmp") {		    	    	             
		    		imagePreview.src = "/files/commentImages/" + fileinfo.split("/")[0];
		    	}
		    	else if (_ext == "doc" || _ext == "docx"){
		    		imagePreview.src = "/images/msWord.png";
		    	}
		    	else if (_ext == "ppt" || _ext == "pptx"){
		    		imagePreview.src = "/images/msPowerpoint.png";
		    	}
		    	else if (_ext == "xls" || _ext == "xlsx"){
		    		imagePreview.src = "/images/msExcel.png";
		    	}
		    	else if (_ext == ".hwp"){
		    		imagePreview.src = "/images/hancomHWP.png";
		    	}
		    	else {
		    		imagePreview.src = "/images/cmtFile.png";
		    	}

		    }
		    
		    function addFileComment() {
				//Close sticker picker if display
				document.getElementById("emoticonPanel").style.display = "none";
		    	document.getElementById("file").click();
		    }
		    
		    function cancelShowingCmtFile(obj) {
				var type = obj.getAttribute("_type");
				
				if (type == "file") {
					//Delete file in server
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
		        	document.getElementById("sendBttn").disabled = true;
		        }
		    }
		    
		    function auto_grow(element) {
				if (element.value == "" && document.getElementById("uploadedFile").style.display == "none") {
					document.getElementById("sendBttn").disabled = true;
				}
				else {
			    	document.getElementById("sendBttn").disabled = false;
			        element.style.height = "5px";
			        element.style.height = (element.scrollHeight)+"px";
			        window.scrollTo(0,document.body.scrollHeight);
				}
		    }
		    
		    function editAutoGrow(element) {
				if (element.value == "" && document.getElementById("descriptCmt" + currentEditingCmt).style.display == "none") {
					document.getElementById("clA2cmt" + currentEditingCmt).disabled = true;
				}
				else {
					document.getElementById("clA2cmt" + currentEditingCmt).disabled = false;
				}
				
		    	element.style.height = "5px";
		        element.style.height = (element.scrollHeight)+"px";		        
		    }
			
		    function checkScrollBars() {		
				if (document.getElementById("_listG" + stickerIndex + "Table").scrollHeight > 320){
		    		document.getElementById("emoticonPanel").style.width = "420px";
		    	}
		    }
		    
		    function addSticker(){
		    	processGroupStickers();
		    	stickerIndex = 1;		    	
		    	document.getElementById("_group1").style.backgroundColor  = "#d9d9d9";
		    	document.getElementById("_listG1").style.display = "block";
		    	
		    	for (var i = 2; i <= numberOfGroupSticker; i++) {
		    		document.getElementById("_group" + i).style.backgroundColor  = "#fff";
		    		document.getElementById("_listG" + i).style.display = "none";
		    	}
		    	document.getElementById("emoticonPanel").style.display = "block";
		    	checkScrollBars();
		    }
		    
		    function changeStickerGroup(obj) {		    	
		    	document.getElementById("_group" + stickerIndex).style.backgroundColor  = "#fff";
		    	obj.style.backgroundColor  = "#d9d9d9";
		    	document.getElementById("_listG" + stickerIndex).style.display = "none";
		    	var imageTag = obj.firstElementChild;
		    	if (imageTag.src.indexOf("hackerGirl.png") !== -1) {		    		
		    		stickerIndex = 1;		    		
		    	}
		    	else if (imageTag.src.indexOf("crayonShin.png") !== -1) {
		    		stickerIndex = 2;
		    	}
		    	else if (imageTag.src.indexOf("catEmoticon.png") !== -1) {
		    		stickerIndex = 3;
		    	}
		    	else {
		    		stickerIndex = 4;
		    	}
		    	document.getElementById("_listG" + stickerIndex).style.display = "block";
		    	checkScrollBars();
		    }
		    
		    function displaySticker(obj) {				    	
		    	var style = obj.currentStyle || window.getComputedStyle(obj, false);
		    	var bgImage = style.backgroundImage.slice(4, -1);
		    	var actualUrl = bgImage.slice(bgImage.indexOf("/images/"), -1);		   	    		    	
		    	
		    	//Close sticker picker
		    	document.getElementById("emoticonPanel").style.display = "none";
		    	
		    	if (document.getElementById("sendComment").style.display !== "none") {
			    	//Add sticker in upload File
			    	document.getElementById("uploadedFile").style.display = "inline-block";
			    	var imagePreview = document.getElementById("previewImage");
			    	var cancelPreview = document.getElementById("cancelImg");
			    	cancelPreview.setAttribute("_type", "sticker");
			    	imagePreview.setAttribute("_fileInfo", actualUrl);
			    	imagePreview.setAttribute("_type", "sticker");
			    	imagePreview.src = actualUrl;
			    	document.getElementById("sendBttn").disabled = false;
		    	}
		    	else {
		    		//Editing situation
		    		var editPreviewTag = document.getElementById("editPreviewImg" + currentEditingCmt);
		    		editPreviewTag.setAttribute("_type", "sticker");
		    		editPreviewTag.src = actualUrl;
		    		var childElmNumber = editPreviewTag.parentElement.childElementCount;
		    		if (childElmNumber == 1) {
		    			// Add cancel image
		    			var cancelImg = document.createElement("img"); 
		    			cancelImg.src = "/images/close.png";
		    			cancelImg.setAttribute("style", "height: 20; width: 20px; top: 0; left: 50px; position: absolute; cursor: pointer;");
		    			cancelImg.onclick = function () { deleteFileInCmt(); };
		    			editPreviewTag.parentElement.appendChild(cancelImg);
		    		}
		    		editPreviewTag.parentElement.style.display = "block";
		    		document.getElementById("clA2cmt" + currentEditingCmt).disabled = false;
		    	}

		    }
		    
		    function processGroupStickers() {				
		    	if (numberOfGroupSticker > 8) {
		    		currentGroupSticker = 8;
		    		for (var i = 9; i <= numberOfGroupSticker; i++){
		    			document.getElementById("_group" + i).style.display = "none";
		    		}
		    		document.getElementById("nextEmoticon").src = "/images/next.png";
		    		document.getElementById("nextEmoticon").style.cursor = "pointer";
		    		document.getElementById("nextEmoticon").onclick = function () { showNextGroupSticker(); };
		    	}
		    	else {
		    		for (var i = numberOfGroupSticker + 1; i <= 8; i++){
		    			document.getElementById("_group" + i).style.display = "none";
		    		}		    		
		    	}
		    }
		    
		    function showNextGroupSticker() {
		    	currentGroupSticker = currentGroupSticker + 1;
		    	document.getElementById("_group" + (currentGroupSticker - 8)).style.display = "none";
		    	document.getElementById("_group" + currentGroupSticker).style.display = "block";
		    	document.getElementById("previousEmoticon").src = "/images/previous.png";
		    	document.getElementById("previousEmoticon").style.cursor = "pointer";
		    	document.getElementById("previousEmoticon").onclick = function () { showPreviousGroupSticker(); };
		    	
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
		    
		    function updateNewCmt(userId, attach, type, name, path, txtContent, cmtTime) {
		    	commentIndex = commentIndex + 1;
		    	var oTable = document.getElementById("commentListView");
		    	//create the Tr field
		    	objTr = document.createElement("tr");
		    	objTr.setAttribute("style", "border-bottom: 1px solid #b6b6b6");
		    	
		    	//Td1
		    	var objTd = document.createElement("td");
		    	objTd.setAttribute("style", "padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; ");                  
                var image_tag = document.createElement("img");                
                image_tag.src = "/images/account.jpg";
                image_tag.setAttribute("style", "padding-top: 10px; height: 50px; width:50px; cursor: pointer; "); 
                image_tag.onclick = function () { menuQst_DetailUserInfo(userId); };
                objTd.appendChild(image_tag);
                objTr.appendChild(objTd);
                
              	//Td2
                var objTd2 = document.createElement("td");
                var div1ForTd2 = document.createElement("div");
                var div2ForTd2 = document.createElement("div");  
                var editDiv2ForTd2 = document.createElement("div");  
                editDiv2ForTd2.setAttribute("id", "editCmtDiv" + commentIndex);   
                editDiv2ForTd2.style.display = "none"; 
                
                div2ForTd2.setAttribute("style", "display: inline-block; width: 40%; height: auto; padding-left: 8px; padding-bottom: 7px;padding-top: 2px;");               
                div2ForTd2.setAttribute("id", "div2Cmt" + commentIndex);                
                div1ForTd2.innerHTML = userId;
                div1ForTd2.setAttribute("style", "display: block; padding-left: 8px; padding-top: 10px; color: blue");       
                
                //Add text comment if exist
                if (txtContent.length > 0) {
                	txtContent = txtContent.replace(/(?:\r\n|\r|\n)/g, '<br />');
                	var pForTd2 = document.createElement("p");  
                	pForTd2.innerHTML = txtContent;
                	pForTd2.setAttribute("style", "word-wrap: break-word; margin-top: 0px;margin-bottom: 0px;");
                	pForTd2.setAttribute("id", "cmtArea" + commentIndex);
                	div2ForTd2.appendChild(pForTd2);
                }
                
              	//Add file if exist
                if (attach != ""){
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
				    	imgForinnerDiv1.setAttribute("height", "60");
				    	imgForinnerDiv1.setAttribute("width", "60");	
				    	imgForinnerDiv1.setAttribute("style", "cursor: pointer;  padding-left: 10px;");
			    		imgForinnerDiv1.src = attach;	
			    		innerDiv1.appendChild(imgForinnerDiv1);
			    		div2ForTd2.appendChild(innerDiv1);
			    		
			    		if (name == "") {
			    			imgForinnerDiv1.setAttribute("_fileInfo", attach);
			    			imgForinnerDiv1.setAttribute("_type", "images"); 
			    		}
			    		else {					    	
					    	imgForinnerDiv1.setAttribute("_type", "file");
			    			imgForinnerDiv1.setAttribute("_fileInfo", path); 
				    		var innerDiv2 = document.createElement("div");
				    		innerDiv2.innerHTML = name;
				    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
				    		innerDiv2.setAttribute("_fileInfo", path);   
				    		innerDiv1.appendChild(innerDiv2);
			    		}			    		
                	}
                }
              	
                objTd2.appendChild(div1ForTd2);
                objTd2.appendChild(div2ForTd2);
                objTd2.appendChild(editDiv2ForTd2);
                objTr.appendChild(objTd2);             	            	
              	
                //Td3
                var objTd3 = document.createElement("td");
                objTd3.setAttribute("style", "width: 145px; position: relative;");                
                var fistChildForTd3 = document.createElement("div");
                fistChildForTd3.setAttribute("style", "position: absolute; top:10px;");     
                fistChildForTd3.innerHTML = cmtTime;
                objTd3.appendChild(fistChildForTd3);                                         
                objTr.appendChild(objTd3);             
                oTable.appendChild(objTr);  
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
		    			div2Cmt.firstElementChild.innerHTML = txtContent;
		    		}
		    		else {
		    			var pForTd2 = document.createElement("p");  
		    			pForTd2.innerHTML = txtContent;
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
					    		imgForinnerDiv1.src = attachFilePath;	
					    		innerDiv1.appendChild(imgForinnerDiv1);
					    		div2Cmt.appendChild(innerDiv1);
					    	}
			    			else if (fileType == "images") {
					    		imgForinnerDiv1.setAttribute("_type", "images");					    		
						    	imgForinnerDiv1.setAttribute("height", "60");
						    	imgForinnerDiv1.setAttribute("width", "60");	
						    	imgForinnerDiv1.setAttribute("style", "cursor: pointer;");
					    		imgForinnerDiv1.src = attachFilePath;	
					    		imgForinnerDiv1.setAttribute("_fileInfo", attachFilePath); 
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
						    	innerDiv1.appendChild(imgForinnerDiv1);						    	
					    		var innerDiv2 = document.createElement("div");
					    		innerDiv2.innerHTML = fileName;					    		
					    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
					    		innerDiv2.setAttribute("_fileInfo", filePath);   
					    		innerDiv1.appendChild(innerDiv2);
					    		div2Cmt.appendChild(innerDiv1);
			    			}					    	
		    			}
		    			else {		    				
		    				if (fileType == "sticker") {
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
			    				}
		    					div2Cmt.firstElementChild.children[0].setAttribute("_type", "sticker");					    		
		    					div2Cmt.firstElementChild.children[0].setAttribute("height", "80");
		    					div2Cmt.firstElementChild.children[0].setAttribute("width", "80");					    	
		    					div2Cmt.firstElementChild.children[0].src = attachFilePath;	
			    			}
			    			else if (fileType == "images") {
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
			    				}
			    				div2Cmt.firstElementChild.children[0].setAttribute("_type", "images");					    		
			    				div2Cmt.firstElementChild.children[0].setAttribute("height", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("width", "60");	
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "cursor: pointer;");
			    				div2Cmt.firstElementChild.children[0].src = attachFilePath;	
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileInfo", attachFilePath); 
			    			}
			    			else {
			    				div2Cmt.firstElementChild.children[0].setAttribute("height", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("width", "60");
			    				div2Cmt.firstElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px;");
			    				div2Cmt.firstElementChild.children[0].setAttribute("_type", "file");
			    				div2Cmt.firstElementChild.children[0].setAttribute("_fileInfo", filePath); 
			    				div2Cmt.firstElementChild.children[0].src = attachFilePath;
			    				if (div2Cmt.firstElementChild.childElementCount == 2) {
			    					div2Cmt.firstElementChild.children[1].innerHTML = fileName;
			    					div2Cmt.firstElementChild.children[1].setAttribute("style", "cursor: pointer; padding-left: 15px;");
			    					div2Cmt.firstElementChild.children[1].setAttribute("_fileInfo", filePath);   
			    				}
			    				else {
			    					var innerDiv2 = document.createElement("div");
						    		innerDiv2.innerHTML = fileName;					    		
						    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
						    		innerDiv2.setAttribute("_fileInfo", filePath);   
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
	    					div2Cmt.lastElementChild.children[0].setAttribute("_type", "sticker");					    		
	    					div2Cmt.lastElementChild.children[0].setAttribute("height", "80");
	    					div2Cmt.lastElementChild.children[0].setAttribute("width", "80");					    	
	    					div2Cmt.lastElementChild.children[0].src = attachFilePath;	
		    			}
		    			else if (fileType == "images") {
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {
		    					div2Cmt.lastElementChild.removeChild(div2Cmt.lastElementChild.children[1]);	    					
		    				}
		    				div2Cmt.lastElementChild.children[0].setAttribute("_type", "images");					    		
		    				div2Cmt.lastElementChild.children[0].setAttribute("height", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("width", "60");	
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "cursor: pointer;");
		    				div2Cmt.lastElementChild.children[0].src = attachFilePath;	
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileInfo", attachFilePath); 
		    			}
		    			else {
		    				div2Cmt.lastElementChild.children[0].setAttribute("height", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("width", "60");
		    				div2Cmt.lastElementChild.children[0].setAttribute("style", "cursor: pointer; padding-left: 10px;");
		    				div2Cmt.lastElementChild.children[0].setAttribute("_type", "file");
		    				div2Cmt.lastElementChild.children[0].setAttribute("_fileInfo", filePath); 
		    				div2Cmt.lastElementChild.children[0].src = attachFilePath;
		    				if (div2Cmt.lastElementChild.childElementCount == 2) {		    					
		    					div2Cmt.lastElementChild.children[1].innerHTML = fileName;
		    					div2Cmt.lastElementChild.children[1].setAttribute("style", "cursor: pointer; padding-left: 15px;");
		    					div2Cmt.lastElementChild.children[1].setAttribute("_fileInfo", filePath);   
		    				}
		    				else {
		    					var innerDiv2 = document.createElement("div");
					    		innerDiv2.innerHTML = fileName;					    		
					    		innerDiv2.setAttribute("style", "cursor: pointer; padding-left: 15px;");
					    		innerDiv2.setAttribute("_fileInfo", filePath);   
					    		div2Cmt.lastElementChild.appendChild(innerDiv2);
		    				}
		    			}		    			
		    		}
		    	}
		    }
		</script>
	</head>
	<xmp id="sigBody" style="display: none;">${question.content}</xmp>
	<body class="mainbody"  id="mainbodytag">
		<form method="post">
			<h1 style="margin-bottom: 16px;"><spring:message code='ezBoard.t371' /></h1>
			<div id="mainmenu3" style="overflow: hidden;">
				  <div style="float: left; display: block;width:300px;">
				  		<img src="/images/account.jpg" style="display:inline-block;float:left; height:50px;width:50px; cursor: pointer;" onclick="menuQst_DetailUserInfo('${question.creator}')">
						<div id="textTest" style="display:inline-block;">
							<span style="display:block;padding-top: 8px;padding-left: 5px;"><c:out value='${question.creatorName}'/></span>
							<span style="display:block;padding-top: 8px;padding-left: 5px;"><c:out value='${question.startDate}'/></span>
						</div>
				  </div>
				  <div style="float: left; display: block;padding-top: 30px;padding-left: 420px;">
				  	<a style="display:inline-block;cursor: pointer;" id="seenPeople" onClick="menuDetailSeenUserInfo('${question.qstId}')">분이 투표 내용을 확인했습니다</a>
				  </div>
				  <c:if test="${curentUser == question.creator || adminPrivilege == 1}">
					  <div style="float: right; display: block;" id="_editVote">
					  		<img src="/images/edit1600.png" style="display:inline-block;float:left; height:25px;width:25px;padding-top: 12px;" onclick="voteEdit()">
					  </div>
				  </c:if>
			</div>
			<div id="titleAndContent" style="border: 1px solid #b6b6b6; background-color: #e5d5df; overflow: hidden;padding-top: 8px;padding-bottom: 8px;">				
				<div id="title" style="display:inline-block;float:left;padding-left: 10px;"><font size="5"><c:out value='${question.title}'/></font></div>
				<div id="status" style="display:inline-block;padding-left: 1330px;">
					<c:choose>
						<c:when test="${question.status == 1}">
							투표중
						</c:when>
						<c:otherwise>
							투표완료
						</c:otherwise>
					</c:choose>
				</div>
				<div id="votedUsers"style="display:inline-block;float:right;padding-right: 45px;">
					<c:out value='${votedUsers}'/>명 참여
				</div>
				 <c:if test="${question.status == 1}">
					<div id="daysRemain"style="display:block;padding-left: 1450px;padding-top: 5px; color: green;">
						<c:out value='${timeRemain}'/>
					</div> 			
				</c:if>
			</div>			
			<div class="pad1" style="vertical-align: top; width: 100%;border-right-width: 0px;display:inline-block;" id="messagetd">
	             <iframe onload="resizeFrame()" id="message_test" style="border: #b6b6b6 0px solid; overflow: auto;width: 100%; padding-top: 6px; background-color: white;"></iframe>   	                                 
	        </div>
	        <c:if test="${numOfFile != 0}">
	        	<div id="attached file" style="overflow: hidden;display:inline-block; width: 100%;">
	        		<img src="/images/attach_file.png" style="hegith:20px; width:20px;float: left;display:block;" >
	        		<div style="float: left;display:block; padding-top: 4px;">
	        			<spring:message code='ezEmail.t99000003' /> - <c:out value='${numOfFile}'/> 개(<c:out value='${totalFilesSize}'/>)
	        		</div>
	        		<div style="float: left;display:block;">
	        			<span class="icon_grayup" id="BtnAttachDetail" onclick="AttachDetail_view(this);" style="display:inline-block;"></span> 
	        			<span class="title_btn" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='padding-top: 5px;cursor: pointer;display:inline-block;' onclick="AttachAllDownload();"><spring:message
									code='ezEmail.t99000004' /></span>
	        		</div>
	        		<div id="fileList" style="width: 100%;">	        		
	  					<c:forEach var="list" items="${fileNames}" varStatus="status">
							<table class="content" style="width: 100%;">
								<tr>
									<td>
										<span onclick="DownloadAttach('/ezPoll/downloadAttach.do?folderPath=${filePaths[status.index]}&filename=${list}');" style="cursor:pointer;" _filehref="/ezPoll/downloadAttach.do?folderPath=${filePaths[status.index]}&filename=${list}" name="file_path">
											<img src="/images/icon_adddownload.gif" width="16" height="16" style="padding-left: 5px;">											
										</span>
										<span onclick="DownloadAttach('/ezPoll/downloadAttach.do?folderPath=${filePaths[status.index]}&filename=${list}');" style="cursor:pointer;">	
											<span onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style="cursor: pointer; color: rgb(102, 102, 102);">${list} (${fileSizes[status.index]})</span>								
										</span>									
									</td>
								</tr>
							</table>   			
		        		</c:forEach>
					</div>  
			</div>
	        </c:if>	
			<table class="content" style="width:100%; table-layout: fixed" id="_content1">
				<c:forEach var="_option" items="${listOptions}" varStatus="loop">
		        	<tr>
		               <td style="width:30px; border-right: none;" id="_checkbox<c:out value ="${_option.ansId}"/>">	    
		               		<img id="_imageCheckBox<c:out value ="${_option.ansId}"/>" onclick="javascript:change(this)" src="/images/unchecked.png" style="height:20px; width:20px; display:inline-block;padding-left: 5px;" name="${loop.index}" class="_imageTag"/>	               		             		         		
		               </td>
		               <td style="border-right: none;border-left: none;" id="resultBox<c:out value ="${_option.ansId}" />">	   	               		
		               		<div id="optionContent" style="display:block;padding-top: 6px;padding-bottom: 6px;">${_option.content}</div> 
		               		<div id="graph<c:out value ="${_option.ansId}" />" style="float: left; display:none; width:100%">
		               				<div id="graphBar<c:out value ="${_option.ansId}" />" style="float:left;display:block; heigth:25px;">
		               					<canvas id="myCanvas<c:out value ="${_option.ansId}" />"  height="20" style="border:1px solid #000000;"></canvas>			               					               					
		               				</div>	
		               				<div id="voterNumber<c:out value ="${_option.ansId}" />" style="float:left;display:block;padding-left: 5px;padding-top: 4px;">0</div>		               				
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
												tempObj[listUserAnswer[i].userId] = listUserAnswer[i].userName;
		               							userNameArr[loopIdx].push(tempObj);
		               						}
		               					}
		               				</script>      					               			
		               		</div>
		               		<div id="voterNumber2<c:out value ="${_option.ansId}" />" style="float:left;display:none;width:100%">0</div>
		               		<div id="voteInfo<c:out value ="${_option.ansId}" />" style="float:left; display:none;padding-top: 6px;padding-bottom: 6px;">	              
		               			<div style="float:left; display:none;width:80px; border:1px solid black;margin-left: 1px;" align="center" class="_thu${loop.index}"></div>
		               			<div style="float:left; display:none;width:80px; border:1px solid black;margin-left: 1px;" align="center" class="_thu${loop.index}"></div>
		               			<div style="float:left; display:none;width:80px; border:1px solid black;margin-left: 1px;" align="center" class="_thu${loop.index}"></div>
		               			<div style="float:left; display:none;width:80px; border:1px solid black;margin-left: 1px;" align="center" class="_thu${loop.index}"></div>
		               			<div style="float:left; display:none;width:80px; border:1px solid black;margin-left: 1px;" align="center" class="_thu${loop.index}"></div>
		               			<div style="float:left; display:none;width:80px; margin-left: 1px;" align="center" id="_tax${loop.index}">
		               				<div style="float:left; display:block; padding-left: 5px; padding-top: 1.5px">모두보기</div>
		               				<img src="/images/arrow_right.png" height="10px" width="10px" style="cursor: pointer; float:left; display:block; padding-top: 2.5px; padding-left: 10px;" onclick="javascript:displayVotedUser('${question.qstId}', '${_option.ansId}')">
		               			</div>
		               		</div>          		
		               </td>
		               
			          <td style="width:80px;border-left: none;">	   	               		
			               	<div id="_resultPercentage<c:out value ="${_option.ansId}"/>" style="padding-bottom: 3px;padding-left: 20px;"></div>           		
			          </td>
		               
		            </tr>
				</c:forEach>
				<tr>
					<td style="border-right: none;width:100%; " colspan="3" >
						<div style="overflow: hidden;display:inline-block;">
							<div style="float:left; display:block; padding-top: 8px; padding-left: 35px;">미참여 인원:</div>
							<div style="float:left; display:block; padding-top: 8px; padding-left: 20px;"><c:out value='${numberOfUnvotedUsers}'/></div>
							<img src="/images/arrow_right.png" height="20px" width="20px" style="cursor: pointer; float:left; display:block; padding-left: 5px; padding-top: 5px;" onclick="javascript:displayDetail('${question.qstId}')">
						</div>
					</td>					
				</tr>
			</table>		
			<c:if test="${curentUser == question.creator || adminPrivilege == 1}">
				<div id="_finish" style="border:1px solid #b6b6b6; margin-right: auto; margin-left: auto; width:120px; height:40px; margin-top: 15px; cursor: pointer;" onclick="finishVote();">
					<img src="/images/verified.png" style="height:15px; width:15px; float:left; display:block; padding-top: 14px;padding-left: 5px; cursor: pointer;">				
					<div style="float:left; display:block; padding-top: 14px;padding-left: 14px; cursor: pointer;">투표 종료</div>
				</div> 
			</c:if>
			<div id="commentArea" style="">
				<table style="width: 100%;" id="commentListView">
					<c:forEach var="_comt" items="${listComments}">
						<tr>
							<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; ">
								<img src="/images/account.jpg" style="padding-top: 10px; height: 50px; width:50px; cursor: pointer; " onclick="menuQst_DetailUserInfo('${_comt.userId}');">
							</td>
							<td>
								<div style="display: block; padding-left: 8px; padding-top: 10px; color: blue">${_comt.userId}</div>
								<div id="div2Cmt<c:out value ="${_comt.cmtId}" />" style="display: inline-block; width: 40%; height: auto; padding-left: 8px; padding-bottom: 7px;padding-top: 2px;" >
									<c:if test="${_comt.textContent != ''}">
										<p id="cmtArea<c:out value ="${_comt.cmtId}" />" style="word-wrap: break-word; margin-top: 0px;margin-bottom: 0px; ">${_comt.textContent}</p>
									</c:if>
									<c:if test="${_comt.imageAttach != ''}">
										<div style="padding-top: 5px;">
											<img _type="sticker" height=80 width=80 vertical-align="middle" style="display: block; padding-left: 10px; padding-right: 5px;" src="<c:out value ="${_comt.imageAttach}" />">
										</div>										
									</c:if>
									<c:if test="${_comt.fileAttach != ''}">
										<c:if test="${_comt.fileName != ''}">
											<div style="padding-top: 5px;">
												<img _type="file" height=60 width=60 vertical-align="middle" style="display: block; padding-left: 10px; padding-right: 5px; cursor: pointer;" src="<c:out value ="${_comt.fileAttach}" />" _fileInfo="<c:out value ="${_comt.filePath}"/>" >									
												<div style="cursor: pointer; padding-left: 15px;" _fileInfo="<c:out value ="${_comt.filePath}" />" ><c:out value ="${_comt.fileName}" /></div>						
											</div>					
										</c:if>
										<c:if test="${_comt.fileName == ''}">
											<div style="padding-top: 5px;">
												<img _type="images" height=60 width=60 vertical-align="middle" style="display: block; padding-left: 10px; padding-right: 5px; cursor: pointer;" src="<c:out value ="${_comt.fileAttach}" />" _fileInfo="<c:out value ="${_comt.fileAttach}" />">
											</div>
										</c:if>
									</c:if>
								</div>
								<div id="editCmtDiv<c:out value ="${_comt.cmtId}" />" style="display: none;"></div>
							</td>
							<td style="width: 145px; position: relative;">
								<div style="position: absolute; top:10px;"><c:out value ="${_comt.cmtTime}" /></div>
								<c:if test="${_comt.userId == curentUser}">								
									<img src="/images/option3.png" height=25 width=25 vertical-align="middle" _comtIndex="editComt<c:out value ="${_comt.cmtId}"/>" style="float:right; display: block; cursor:pointer;" onclick="(function(e){e.stopPropagation();})(event); showEditPanel(this);" >
									<div id="editComt<c:out value ="${_comt.cmtId}" />" style="float:right; display: none; position: absolute; z-index: 10 ; border: 1px solid #b6b6b6; background-color: #576652; color: white;; margin-top: -14px; margin-right: 3px; width: 120px;" tabindex=0>							
										<div id="_eCmt<c:out value ="${_comt.cmtId}" />" _comtIndex="editComt<c:out value ="${_comt.cmtId}" />" style="border-bottom: 1px solid #b6b6b6; text-align: center; padding-top: 5px;padding-bottom: 5px; cursor: pointer;" onclick="editComment(this);">Edit Comment</div>
										<div style="text-align: center; padding-top: 5px;padding-bottom: 5px; cursor: pointer;" onclick="deleteComment(this);">Delete Comment</div>
									</div>
								</c:if>
							</td>
						</tr>
					</c:forEach>					
				</table>
			</div>
			<div id="sendComment" style="padding-top: 20px;">
				<div style="float:left; display:block;">
					<img id="_addFile" src="/images/add.png" style="float:left; display:block; height:25px; width:25px; padding-left: 60px; cursor: pointer;" onclick="addFileComment()">
				</div>
				<div id ="_stickerArea" style="float:left; display:block;">					
					<div id="emoticonPanel" style="display: none; width:400px; height:356.5px; margin-top: -362px;margin-right: -400px; background-color: #fff; border:1px solid #b6b6b6; position: absolute;">
						<div id="emoticonGroup" style="display:block;width:100%; height: 45px;background-color: #fff; border-bottom:1px solid #b6b6b6;">
							<div style="float:left; display:block;">
								<img id="previousEmoticon" src="/images/previous1.png" height=40 width=30 style="padding-top: 3px; ">
							</div>
							<div id="_ePresentors" style="float:left; display:block; ">
								<div id="_group1" style="background-color: #d9d9d9; float:left; display: block; height:45px; width:45px; cursor: pointer; " onclick="changeStickerGroup(this);"><img src="/images/emoticon/hackerGirl.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
								<div id="_group2" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/crayonShin.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
								<div id="_group3" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/catEmoticon.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
								<div id="_group4" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/student.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
								<div id="_group5" style="float:left; display: block; height:45px; width:45px; cursor: pointer; " onclick="changeStickerGroup(this);"><img src="/images/emoticon/hackerGirl.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
								<div id="_group6" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/crayonShin.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
								<div id="_group7" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/catEmoticon.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
								<div id="_group8" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/student.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
<!-- 								<div id="_group9" style="float:left; display: block; height:45px; width:45px; cursor: pointer; " onclick="changeStickerGroup(this);"><img src="/images/emoticon/hackerGirl.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>
								<div id="_group10" style="float:left; display: block; height:45px; width:45px; cursor: pointer;" onclick="changeStickerGroup(this);"><img src="/images/emoticon/crayonShin.png" height=30 width=30 style="padding-top: 7px; padding-left: 7px; "></div>  -->
							</div>
							<div style="float: right; display:block;">
								<img id="nextEmoticon" src="/images/next1.png" height=40 width=30 style="padding-top: 3px; ">
							</div>
						</div>						
						<div id="emoticonList" style="display:inline-block;width:100%; background-color: #fff;">
							<div id="_listG1" style="height:310px; overflow-y: auto; overflow-x: hidden; display: block;">
								<table id="_listG1Table">
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/45.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/65.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/75.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/85.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/95.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/105.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/118.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/119.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/125.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/135.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/145.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/155.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/165.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/172.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/182.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/192.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/202.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/215.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/216.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/222.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/232.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/242.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/252.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/262.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/272.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/282.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/292.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/302.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/314.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/315.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/322.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/332.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/341.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/351.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/361.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/371.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/381.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/391.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/401.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/girl/431.png);" onclick="displaySticker(this);"></div></td>
									</tr>
								</table>
							</div>
							<div id="_listG2" style="height:310px; overflow-y: auto; overflow-x: hidden; display: none;">
								<table id="_listG2Table">
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/2.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/3.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/4.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/5.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/6.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/7.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/8.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/9.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/10.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/11.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/12.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/13.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/14.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/15.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/16.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/17.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/18.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/19.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/20.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/21.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/22.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/23.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/24.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/25.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/26.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/27.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/28.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/29.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/30.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/31.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/32.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/shin/33.png);" onclick="displaySticker(this);"></div></td>
									</tr>
								</table>
							</div>
							<div id="_listG3" style="height:310px; overflow-y: auto; overflow-x: hidden; display: none;">
								<table id="_listG3Table">
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/1.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/2.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/3.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/4.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/5.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/6.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/7.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/8.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/9.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/10.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/11.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/12.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/13.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/14.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/15.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/16.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/17.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/18.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/19.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/20.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/21.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/22.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/23.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/cat/24.png);" onclick="displaySticker(this);"></div></td>
									</tr>
								</table>
							</div>
							<div id="_listG4" style="height:310px; overflow-y: auto; overflow-x: hidden; display: none;">
								<table id="_listG4Table">
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/1.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/2.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/3.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/4.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/5.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/6.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/7.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/8.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/9.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/10.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/11.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/12.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/13.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/14.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/15.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/16.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/17.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/18.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/19.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/20.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/21.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/22.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/23.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/24.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/25.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/26.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/27.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/28.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/29.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/30.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/31.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/32.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/33.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/34.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/35.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/36.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/37.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/38.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/39.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/40.png);" onclick="displaySticker(this);"></div></td>
									</tr>
									<tr style="width:100%; height:45px;">
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/41.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/42.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/43.png);" onclick="displaySticker(this);"></div></td>
										<td><div class="emoticon" style="background-image: url(/images/emoticon/boy/44.png);" onclick="displaySticker(this);"></div></td>
									</tr>
								</table>
							</div>
						</div>
					</div>					
					<img id="_addEmoticon" src="/images/add_emo.png" style="display:block; height:25px; width:25px; padding-left: 10px; cursor: pointer;" onclick="addSticker()">
				</div >				
				<div style="float:left; display:block; width:80%;">
					<textarea cols="20" rows="1" id="comment_input" placeholder="Add a comment." style="display: inline-block; overflow: hidden; height: 32px;  outline: none; border: none; resize:none; padding-left: 15px;"  onkeyup="auto_grow(this)"></textarea>
				</div>
				<div style="float:left; display:block; width: 60px;">
					<div id="uploadedFile" style="display:none; border:1px solid #b6b6b6; width: 100px; height:100px; float:right;margin-right: -35px; margin-top: -100px; background-color: #4B4B4B; z-index: 1000; position: absolute">
						<img id="cancelImg" src="/images/close.png"  style="float:right; display: block; cursor: pointer;  z-index: 2000;" height=20 width=20 onclick="cancelShowingCmtFile(this);">
						<img id="previewImage" style="display: block; padding-left: 20px; padding-right: 20px;" height=60 width=60>
					</div>	
					<button id="sendBttn" style="display:inline-block; width: 60px; padding-bottom: 2px; text-align: center; margin-left: 15px; margin-right: 15px; vertical-align: middle;" onclick="sendComment(); return false;">Send</button>						
				</div>
				
			</div>
			<input id="file" type="file" onchange="uploadFileCmt()" style="width: 1px; height: 1px" /> 
<!-- 			<div style="display:none">	
				<input type="text" name="hidCmtTime" id="hidCmtTime" style="display:none"> 
                <input type="text" name="hidCmtTxt" id="hidCmtTxt" style="display:none" value="">
                <input type="text" name="hidCmtType" id="hidCmtType" style="display:none">	
                <input type="text" name="hidCmtAttach" id="hidCmtAttach" style="display:none" value="">
                 <input type="text" name="hidQst" id="hidQst" style="display:none">
			</div> -->
		</form>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe> 
	</body>
</html>