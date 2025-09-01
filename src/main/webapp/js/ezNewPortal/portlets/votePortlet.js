/**
 * 
 */
function viewQstList() {
	parent.document.querySelector("iframe[name=main]").src = "/ezPoll/pollMain.do";		    	
}

function votePoll() {
	var qstId = $(".votePortlet").attr("id");
	qstId = qstId.substring(1);

	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezPoll/checkPoll.do",
		data : {
			qstId : qstId
		},
		success: function(data) {		    			
			var result = JSON.parse(data).result;					

			if (result == "Normal") {
				parent.document.querySelector("iframe[name=main]").src = "/ezPoll/pollMain.do?qstId=" + qstId;
			}
			else {
				alert(messages.strLang13);
				window.location.reload();
			}
		},
		error: function(error) {
			console.log(error);
		}
	});
}

var getVoteInfo = function() {
	var request = new XMLHttpRequest();
	request.open('GET', '/ezNewPortal/getVoteInfo.do' , false);
	request.setRequestHeader('Content-Type', 'application/json');

	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			if (request.responseText == null) {
				return;
			}
			
			var parent = document.getElementById("voteDiv");
			var vote = document.getElementById("voteList");
			
			if (vote == null) {
				vote = document.getElementById("noDataUL");
			}
			
			parent.removeChild(vote);
			
			var result = JSON.parse(request.responseText);
			var voteCount = result.voteCount;
			
			if (voteCount == 0) {
				var portletListUL = document.createElement("ul");
				portletListUL.className = "portlet_list";
				
				var noDataDL = document.createElement("dl");
				noDataDL.className = "nodata";
				
				var noDataDT = document.createElement("dt");
				var noDataImg = document.createElement("img");
				noDataImg.src = "/images/kr/main/noData_sIcon.png";
				
				var noDataDD = document.createElement("dd");
				noDataDD.textContent = messages.strLang1;
				
				noDataDT.appendChild(noDataImg);
				
				noDataDL.appendChild(noDataDT);
				noDataDL.appendChild(noDataDD);
				portletListUL.appendChild(noDataDL);
				
				document.getElementById("voteDiv").appendChild(portletListUL);
			} else {
				var voteTitle = result.title;
				var qstId = result.qstId;
				var pollAnswer = result.pollAnswer;
				var pollAnswerCount = result.pollAnswerCount;
				
				var contentsDiv = document.createElement("div");
				contentsDiv.className = "vote_contents";
				contentsDiv.id = "voteList";
				
				var titleP = document.createElement("p");
				titleP.className = "voteTitle";
				titleP.textContent = '"' + voteTitle + '"';
				
				contentsDiv.appendChild(titleP);
				
				var voteBtn = document.createElement("p");
				voteBtn.className = "voteBtn votePortlet";
				voteBtn.id = "V" + qstId;
				voteBtn.textContent = messages.strLang24;
				
				contentsDiv.appendChild(voteBtn);
				
				var listUL = document.createElement("ul");
				listUL.className = "voteList";
				
				var pollLength = pollAnswer.length;
				
				if (pollLength > 4) {
					pollLength = 4;
				}
				
				for (var i = 0; i < pollLength; i++) {
					var voteLI = document.createElement("li");
					voteLI.className = "voteList_0" + (i + 1);
					
					var voteT = document.createElement("div");
					voteT.className = "voteT";
					
					var Vnum = document.createElement("span");
					Vnum.className = "Vnum";
					Vnum.textContent = (i + 1);
					
					var Vtext = document.createElement("span");
					Vtext.className = "Vtext";
					Vtext.textContent = " " + pollAnswer[i].content;
					
					voteT.appendChild(Vnum);
					voteT.appendChild(Vtext);
					
					voteLI.appendChild(voteT);
					
					var percentDiv = document.createElement("div");
					percentDiv.className = "percent";
					percentDiv.id = "percent" + (i + 1);
					
					if (pollAnswerCount == 0) {
						percentDiv.textContent = "0%";
					} else {
						 var percentValue = parseInt((Number(pollAnswer[i].votesNumber) / Number(pollAnswerCount)) * 100);
						 
						 percentDiv.textContent = percentValue + "%";
					}
					
					voteLI.appendChild(percentDiv);
					
					var graphDiv = document.createElement("div");
					graphDiv.className = "voteGraph";
					graphDiv.id = "divGraph" + (i + 1);
					
					var graphSpan = document.createElement("span");
					graphSpan.id = "graph" + (i + 1);
					
					if (pollAnswerCount == 0) {
						graphSpan.style.width = "0%";
					} else {
						 var percentValue = parseInt((Number(pollAnswer[i].votesNumber) / Number(pollAnswerCount)) * 100);
						 
						 graphSpan.style.width = percentValue + "%";
					}
					
					graphDiv.appendChild(graphSpan);
					
					voteLI.appendChild(graphDiv);
					listUL.appendChild(voteLI);
				}
				
				contentsDiv.appendChild(listUL);
				document.getElementById("voteDiv").appendChild(contentsDiv);
				$("#voteList").find(".voteBtn").on("click", votePoll);
			}
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	request.send();
}