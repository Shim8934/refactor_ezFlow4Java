<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPersonal.t380' /></title>
		<link rel="stylesheet"  href="<spring:message code='ezPersonal.e3' />" type="text/css">
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<style type="text/css">
        	.question {
            	background:url(/images/kr/main/popup_pollimg.gif) no-repeat #f2f2f2 0px 0px;
            	padding:5px 0px 5px 55px;
            	margin-top:0px;
            	height:60px;
            	word-break:break-all;
				border:1px solid #b8b6b6;
	        }
			.question p { 
				margin:0px;
				padding:0px;
				font-size:12px;
				font-weight:bold;
				color:#4a83d5;
			}
    	    .qlist {
				width223px;
	            color:#666666;
            	background-color:#FFFFFF;
            	word-break:break-all;
            	font-size:12px;
				line-height:20px;
				border:1px solid #d7d4d5;
				border-top:0px ;
        	}
	        .btn_vote, .btn_vote_view, .btn_result {
    	        background-repeat: no-repeat;
        	    height: 18px;
	            cursor: pointer;
            	margin: 1px;
        	}
    	</style>
		<script type="text/javascript">
			var g_UsePortal = "${usePortal}";

			window.onload = function () {
		    	var userlnag = ${userInfo.lang};
		    	if(userlnag == 1){
			        document.getElementById("btnpoll").src ="/images/main/btn_vote.gif";
		        	document.getElementById("btnview").src = "/images/main/btn_vote_view.gif"
		        	document.getElementById("btnresult").src = "/images/main/btn_result.gif";
		    	} else if(userlnag == 2){
		        	document.getElementById("btnpoll").src ="/images_en/main/btn_vote.gif";
		        	document.getElementById("btnview").src = "/images_en/main/btn_vote_view.gif"
		        	document.getElementById("btnresult").src = "/images_en/main/btn_result.gif";
		    	} else if(userlnag == 3){
		        	document.getElementById("btnpoll").src ="/images_ja/main/btn_vote.gif";
		        	document.getElementById("btnview").src = "/images_ja/main/btn_vote_view.gif"
		        	document.getElementById("btnresult").src = "/images_ja/main/btn_result.gif";
		    	} else if(userlnag == 4){
		        	document.getElementById("btnpoll").src ="/images_zh/main/btn_vote.gif";
		        	document.getElementById("btnview").src = "/images_zh/main/btn_vote_view.gif"
		        	document.getElementById("btnresult").src = "/images_zh/main/btn_result.gif";
		    	} else {
		        	document.getElementById("btnpoll").src ="/images/main/btn_vote.gif";
		        	document.getElementById("btnview").src = "/images/main/btn_vote_view.gif"
		        	document.getElementById("btnresult").src = "/images/main/btn_result.gif";
		    	}
			}
			var PollResult_Cross_dialogArguments = new Array();
			function vote_poll(poll_answer) {
				var itemseq = "${pollSeq}";
			
				//if( g_bvoted == false && poll_answer == '1' )
				if( poll_answer == '1' ) {
					poll_answer = "-1";
				
					var answer = document.getElementsByName("answer");

					for (var i=0; i<answer.length; i++)
						if(answer[i].checked == true)
							poll_answer = i+1;

					if (poll_answer == "-1") {
						alert("<spring:message code='ezPersonal.t381' />");
						return;
					}
				
			    	var url = "/ezPersonal/pollResult.do?itemSeq=" + itemseq + "&answer=" + poll_answer;
			    	PollResult_Cross_dialogArguments[1] = vote_poll_Complete;
			    	var OpenWin = window.open(url, "PollResult_Cross", GetOpenWindowfeature(455, 400));
		        	try { OpenWin.focus(); } catch (e) { }
				} else {
				    var heigth = window.screen.availHeight;
				    var width = window.screen.availWidth;
				    var left = (width - 455) / 2;
				    var top = (heigth - 400) / 2;
				    
				    window.open("/ezPersonal/pollResult.do?itemSeq=" + itemseq, "", "height=400px,width=455px, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=" + top + ",left = " + left);
				}
			}
			
		    function vote_poll_Complete() {
				document.location.reload();
				window.opener.location.reload();
				
		        if(window.opener.opener != null) {
		            window.opener.opener.location.reload();
		            if(window.opener.opener.opener != null)
		                window.opener.opener.opener.location.reload();
		        }
		    }

		function open_polllist() {
		    var pheight = window.screen.availHeight;
		    var pwidth = window.screen.availWidth;
		    var pTop = (pheight - 420) / 2;
		    var pLeft = (pwidth - 765) / 2;
		    window.open("/ezPersonal/homePollListUser.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=420,width=765,top=" + pTop + ",left=" + pLeft, "");
		}
		</script>
	</head>
	<body style="overflow:hidden;height:100%">
		<div class="popup">
  			<h1><spring:message code='ezPersonal.t380' /></h1>
    		<div style="overflow:auto;height:325px;width:auto">
  				<div class="question" style="width:223px;overflow-y:auto">
					<p><spring:message code='ezPersonal.t2000' />:</p>
    				${labelPollTitle}
  				</div>
  				<div class="qlist" style="width: 268px;height:179px;padding:10px 0px 0px 10px;overflow:auto">
    				${literalAnswer}
  				</div>
  				<div style="text-align:center;padding-top:10px">
    				<img class="btn_vote" id="btnpoll" onclick="vote_poll('1')" />
    				<img class="btn_vote_view" id="btnview" onclick="vote_poll('')" />
    				<img class="btn_result" id="btnresult" onclick="open_polllist()" />
  				</div>
			</div>
    	</div>
	<form name="wp_LightPoll" runat="server">
	</form>
	</body>
</html>