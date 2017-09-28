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
			var hasVoted = "<c:out value='${hasVoted}'/>";
			var votePrivilege = "<c:out value='${hasVotePrivilege}'/>";
			var numberOfMultiSelect = "<c:out value='${question.multiSelect}'/>";
			var seeResultBeforVote = "<c:out value='${question.resultFirst}'/>";
			var secretVote = "<c:out value='${question.secretVote}'/>";
			var totalVotes = parseInt("<c:out value='${totalVotes}'/>");
			var s_Users = "<c:out value='${seenUsers}'/>";
			var qstId = "<c:out value='${question.qstId}'/>";	
			var curentUser = "<c:out value='${curentUser}'/>";
			var curentUserName = "<c:out value='${curentUserName}'/>";
			var numberOfSelected = 0;
			var maxLoop = 0;			
			var seenText = "분이 투표 내용을 확인했습니다";
			var _status = "<c:out value='${question.status}'/>";
			var sessionId = "<c:out value='${question.creator}'/>";			
			var commentIndex = 0;
			var votedUsers = ${votedUsers};
			var window_open1;		
			var window_open2;
			var numberOptions = "<c:out value='${numberOfOptions}'/>";
			var votesArr = [];	
			var userNameArr = [[]];
			var colors = ["#49a0d8", "#d353a0", "#ffc527", "#df4c27","#34cb34","7127df"];
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
 				autoResize("message_test");	
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
					//console.log("Poll is running! SeeResultBeforVote: " + seeResultBeforVote);
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
			        stompClient.subscribe('/reply/getSeenUpdate', function (updatedInfo) {
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
			        
			        stompClient.subscribe('/reply/finishVoteForQst' + qstId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;
			        	console.log("Vote is changing!");
				            if (ret == "OK") {
								console.log("Running here!");
				            	document.location.href = "/ezPoll/pollVote.do?qstId=" + qstId;
						    }
				    });
			        
			        stompClient.subscribe('/reply/editQst' + qstId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;
			        	var user = JSON.parse(updatedInfo.body).userId;			        	
				            if (ret == "CHANGED" && user != curentUser) {
								//console.log("Vote is deleted!");
								alert(user + " is modifying the vote! Please wait!");
				            	document.location.href = "/ezPoll/pollList.do?brdID=6";
						    }
				    });
			        
			        stompClient.subscribe('/reply/deleteQst' + qstId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;	
			        	var user = JSON.parse(updatedInfo.body).userId;	
				            if (ret == "DELETED" && user != curentUser) {
								//console.log("Vote is deleted!");
								alert(user + " deleted the vote! The vote is not longer exist!");
				            	document.location.href = "/ezPoll/pollList.do?brdID=6";
						    }
				    });
			        
			        stompClient.subscribe('/reply/getResultUpdateForQst' + qstId, function (updatedInfo) {
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
		    
		    function autoResize(id) {
		        var newheight = 10;
		        document.getElementById("message_test").style.height = "10px";

		        if(document.getElementById(id)){
		            newheight = document.getElementById(id).contentWindow.document.body.scrollHeight;
		        }	        
		        
		        document.getElementById(id).style.height = (newheight) + "px";
		        document.getElementById("messagetd").style.height = (newheight + 10) + "px";		       
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
		    	//alert("Testtttt");
		    }
		    
		    function test_func() {
		    	//document.getElementById("sendBttn").disabled = true;		    
		    	document.getElementById("sendBttn").disabled = false;		    	
		    }
		    
		    function showEditPanel(obj) {
				//obj.stopPropagation();
		    	var id = obj.getAttribute("_comtIndex");		    	
		    	document.getElementById(id).style.display = "block";		    	
		    	document.addEventListener("click", function handleClick(e){
		    		console.log("Clicked outside!");		    									
			    	document.getElementById(id).style.display = "none"; 	
			    	document.removeEventListener("click", handleClick);
		    	});	   	
		    }
		    
		    
		    function sendComment() {
		    	alert("This is a test function!");
		    	document.getElementById("sendBttn").disabled = true;	
		    	var currentText = document.getElementById("comment_input").value;
		    	document.getElementById("comment_input").value = "";
		    	
 		    	//Create table comment element if not exist
		    	startComment();
		    	var oTable = document.getElementById("commentListView");
		    	//create the Tr field
		    	objTr = document.createElement("tr");
		    	objTr.setAttribute("style", "border-bottom: 1px solid #b6b6b6");
		    	
		    	var objTd = document.createElement("td");
                objTd.style.paddingLeft  = "10px";
                objTd.style.paddingRight = "0px";
                objTd.style.paddingBottom = "0px";
                objTd.style.paddingTop = "0px";
                objTd.style.width = "24px";
                objTd.style.height = "24px";
                
                var image_tag = document.createElement("img");                
                image_tag.src = "/images/account.jpg";
                image_tag.setAttribute("height", "50");
                image_tag.setAttribute("width", "50");
                image_tag.setAttribute("vertical-align", "middle");
                //image_tag.onclick = function () { filedelete(this); };
                objTd.appendChild(image_tag);
                objTr.appendChild(objTd);                          
                
                var objTd2 = document.createElement("td");
                var div1ForTd2 = document.createElement("div");
                var div2ForTd2 = document.createElement("div");
                var txtAreaForTd2 = document.createElement("textarea");
                div2ForTd2.appendChild(txtAreaForTd2);
                div1ForTd2.innerHTML = curentUser;
                div1ForTd2.setAttribute("style", "display: inline-block; padding-left: 8px; padding-top: 10px; color: blue");       
                txtAreaForTd2.value = currentText;
                txtAreaForTd2.setAttribute("style", "display: inline-block; overflow: auto; height: 32px; width: 98%; outline: none; border: none; resize:none; padding-left: 8px;");       
                txtAreaForTd2.setAttribute("cols", "20");
                txtAreaForTd2.setAttribute("rows", "1");
                objTd2.appendChild(div1ForTd2);
                objTd2.appendChild(div2ForTd2);
                objTr.appendChild(objTd2);
                
                var objTd3 = document.createElement("td");
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
                div1ForTd3.setAttribute("style", "float:right; display: none; position: absolute; z-index: 10 ; border: 1px solid #b6b6b6; margin-top: -14px; margin-right: 3px; width: 120px;");
                div1ForTd3.setAttribute("id", "editComt" + commentIndex);
                div1ForTd3.setAttribute("tabindex", "0");        
                var innerDiv1ForTd3 = document.createElement("div");
                innerDiv1ForTd3.innerHTML = "Edit Comment";
                innerDiv1ForTd3.setAttribute("id", "innerEditComment" + commentIndex);
                innerDiv1ForTd3.setAttribute("style", "border-bottom: 1px solid #b6b6b6; text-align: center; padding-top: 5px;padding-bottom: 5px;");                
                var innerDiv2ForTd3 = document.createElement("div");
                innerDiv2ForTd3.innerHTML = "Delete Comment";
                innerDiv2ForTd3.setAttribute("style", "text-align: center; padding-top: 5px;padding-bottom: 5px;");
                div1ForTd3.appendChild(innerDiv1ForTd3);
                div1ForTd3.appendChild(innerDiv2ForTd3);
                objTd3.appendChild(div1ForTd3);
                objTr.appendChild(objTd3);
                
                oTable.appendChild(objTr);
                commentIndex = commentIndex + 1;
		    }
		    
		    function startComment() {
		    	var oTable = document.getElementById("commentListView");
		    	if (oTable == null) {
		    		oTable = document.createElement("TABLE");
		    	    oTable.style.width = "100%";
		    	    oTable.id = "commentListView";		    	    
		    	}		    	
		        document.getElementById("commentArea").appendChild(oTable); 
		    }

		</script>
	</head>
	<xmp id="sigBody" style="display: none;">${question.content}</xmp>
	<body class="mainbody"  id="mainbodytag">
		<form method="post">
			<h1 style="margin-bottom: 16px;"><spring:message code='ezBoard.t371' /></h1>
			<div id="mainmenu3" style="overflow: hidden;">
				  <div style="float: left; display: block;width:300px;">
				  		<img src="/images/account.jpg" style="display:inline-block;float:left; height:50px;width:50px;">
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
	             <iframe id="message_test" style="border: #b6b6b6 0px solid; overflow: auto;width: 100%; padding-top: 6px; background-color: white;"></iframe>   	                                 
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
		               				<img src="/images/arrow_right.png" height="10px" width="10px" style="float:left; display:block; padding-top: 2.5px; padding-left: 10px;" onclick="javascript:displayVotedUser('${question.qstId}', '${_option.ansId}')">
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
							<img src="/images/arrow_right.png" height="20px" width="20px" style="float:left; display:block; padding-left: 5px; padding-top: 5px;" onclick="javascript:displayDetail('${question.qstId}')">
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
			</div>
			<div id="sendComment" style="padding-top: 20px;">
				<img id="_addFile" src="/images/add.png" style="float:left; display:block; height:25px; width:25px; padding-left: 60px;">
				<img id="_addEmoticon" src="/images/add_emo.png" style="float:left; display:block; height:25px; width:25px; padding-left: 10px;">
				<div style="float:left; display:block; width:80%;">
					<textarea cols="20" rows="1" id="comment_input" placeholder="Add a comment." style="display: inline-block; overflow: auto; height: 32px;  outline: none; border: none; resize:none; padding-left: 15px;" oninput="test_func();"></textarea>
				</div>	
				<button id="sendBttn" style="float:left; display:block; width: 60px; padding-bottom: 2px; text-align: center; margin-left: 15px; margin-right: 15px; vertical-align: middle;" onclick="sendComment(); return false;">Send</button>			
				<!-- <div style="float:left; display:block; border: 1px solid #b6b6b6; width: 60px; height:20px; text-align: center; margin-left: 15px; position: relative; cursor: pointer;" id="sendBttn" onclick="sendComment();">
					<span style="vertical-align: middle; padding-top: 3.5px;">Send</span>
				</div>	 -->			
			</div>
			
		</form>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe> 
	</body>
</html>