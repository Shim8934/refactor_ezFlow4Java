var num = 0;
var nowZoom = 100;
			function nextClick(){
				num = $("#message").contents().find(".divImg").find(".imgDiv").index();
				var divImg = $("#message").contents().find(".divImg");
				var imgDiv = $("#message").contents().find(".imgDiv");
				var imgDiv2 = imgDiv.next();
				var imgMove = $("#message").contents().find(".office-image");
				nowZoom = 100;
				zooms(imgMove);
				if(imgDiv2.length > 0){
					$(imgDiv).css("display", "none");
					$(imgDiv2).css("display", "");
					$(imgDiv).removeClass("imgDiv");
					$(imgDiv2).addClass("imgDiv");
					num++;
					var select = $("#selectImg option:eq(" + num + ")").prop('selected', true);
				}else{
					alert("마지막 페이지 입니다.")
				}
			}
			
			
			function prevClick(){
				num = $("#message").contents().find(".divImg").find(".imgDiv").index();
				var imgDiv = $("#message").contents().find(".imgDiv");
				var imgDiv2 = imgDiv.prev();
				var imgMove = $("#message").contents().find(".office-image");
				nowZoom = 100;
				zooms(imgMove);
				if(imgDiv2.length > 0){
					$(imgDiv).css("display", "none");
					$(imgDiv2).css("display", "");
					$(imgDiv).removeClass("imgDiv");
					$(imgDiv2).addClass("imgDiv");
					num--;
					var select = $("#selectImg option:eq(" + num + ")").prop('selected', true);
				}else{
					alert("첫번째 페이지 입니다.")
				}
			}
			
			function prevClickAll(){
				var imgSelector = $("#message").contents().find(".divImg");
				var divImg = $("#message").contents().find(".divImg");
				var imgDiv = $(imgSelector).children().first();
				var imgDiv2 = imgDiv.nextAll();
				var imgMove = $("#message").contents().find(".office-image");
				nowZoom = 100;
				zooms(imgMove);
				if(imgDiv2.length > 0){
					$(imgDiv).css("display", "");
					$(imgDiv2).css("display", "none");
					$(imgDiv2).removeClass("imgDiv");
					$(imgDiv).addClass("imgDiv");
					num++;
					var select = $("#selectImg option:eq(0)").prop('selected', true);
				}else{
					alert("마지막 페이지 입니다.")
				}
			}
			
			function nextClickAll(){
				var imgSelector = $("#message").contents().find(".divImg");
				var divImg = $("#message").contents().find(".divImg");
				var imgDiv = $(imgSelector).children().last();
				var imgDiv2 = imgDiv.prevAll();
				var imgMove = $("#message").contents().find(".office-image");
				nowZoom = 100;
				zooms(imgMove);
				if(imgDiv2.length > 0){
					$(imgDiv).css("display", "");
					$(imgDiv2).css("display", "none");
					$(imgDiv2).removeClass("imgDiv");
					$(imgDiv).addClass("imgDiv");
					num++;
					var select = $("#selectImg option:eq(-1)").prop('selected', true);
				}else{
					alert("마지막 페이지 입니다.")
				}
			}
			var scrollValue = 1;
			$(window).scroll(function(){
				scrollValue = $(document).scrollTop();
				});
			
			function allImg(e){
				var imgDiv = $("#message").contents().find(".imgDiv");
				var scrollHtml = $("#message").contents().find("html");
				var scrollBody = $("#message").contents().find("body");
				var imgDiv2 = imgDiv.nextAll();
				var imgDiv3 = imgDiv.prevAll();
				var btn = $(e);
				nowZoom = 100;
				if(imgDiv.length > 0){
					var imgMove = $("#message").contents().find(".office-image");
					nowZoom = 100;
					zooms(imgMove);
					$(imgDiv2).css("display", "");
					$(imgDiv3).css("display", "");
					var imgNowPage = $(imgDiv).offset();
					$(scrollHtml,scrollBody).animate({scrollTop: imgNowPage.top}, 400);
					$(imgDiv).removeClass("imgDiv");
					var select = $("#selectImg").css("display", "none");
					var next = $("#next").css("display", "none");
					var prev = $("#prev").css("display", "none");
					var nextAll = $("#nextAll").css("display", "none");
					var prevAll = $("#prevAll").css("display", "none");
					var zoomIn = $("#zoomIn").css("display", "none");
					var zoomOut = $("#zoomOut").css("display", "none");
					var zoomReset = $("#zoomReset").css("display", "none");
					var officeBar = $("#officeBar1").css("display", "none");
					var officeBar = $("#officeBar2").css("display", "none");
					btn.attr("src", "/images/icviewer_downsize.png");
				}else{
					var div = $("#message").contents().find(".divImg");
					var scrollValue = $("#message").get(0).contentWindow.scrollValue;
					var idx = $("#message").contents().find(".office-image");
					if(scrollValue == null || scrollValue == ""){
						scrollValue = 1;
					}
					for(var i=0; i<=idx.length; i++){
						var imgScroll = idx.eq(i).offset();
						if(imgScroll.top >= scrollValue){
							$(idx).eq(i).parent().addClass("imgDiv");
							var select = $("#selectImg option:eq("+i+")").prop('selected', true);
							
							break;
						}
					}
					imgDiv = $("#message").contents().find(".imgDiv");
					imgDiv2 = imgDiv.nextAll();
					imgDiv3 = imgDiv.prevAll();
//					$(imgDiv).addClass("imgDiv");
					$(imgDiv2).css("display", "none");
					$(imgDiv3).css("display", "none");
					var selectImg = $("#selectImg").css("display", "");
					var next = $("#next").css("display", "");
					var prev = $("#prev").css("display", "");
					var nextAll = $("#nextAll").css("display", "");
					var prevAll = $("#prevAll").css("display", "");
					var zoomIn = $("#zoomIn").css("display", "");
					var zoomOut = $("#zoomOut").css("display", "");
					var zoomReset = $("#zoomReset").css("display", "");
					var officeBar = $("#officeBar1").css("display", "");
					var officeBar = $("#officeBar2").css("display", "");
					num = 0;
					btn.attr("src", "/images/icviewer_expend.png");
				}
			}

			function reOffice(e){
				document.getElementById("iFrameLayer2").contentWindow.btnfileup();
				
			}
			
			function selectImg(){
				var val = parseInt($("#selectImg option:selected").val());
				var divImg = $("#message").contents().find(".divImg");
				nowZoom = 100;
				var imgDiv = divImg.children().eq(val-1);
				var imgDiv2 = imgDiv.nextAll();
				var imgDiv3 = imgDiv.prevAll();
				$(imgDiv).addClass("imgDiv");
				$(imgDiv).css("display", "");
				$(imgDiv2).css("display", "none");
				$(imgDiv3).css("display", "none");
				$(imgDiv2).removeClass("imgDiv");
				$(imgDiv3).removeClass("imgDiv");
				num = val -1;
				nowZoom = 100;
			}
			
			
			function zoomOut() {
				var imgMove = $("#message").contents().find(".office-image");
				if(nowZoom == 70) {
				     alert("더 이상 축소할 수 없습니다.");   
				   }
				   nowZoom = nowZoom - 10;
				   if(nowZoom <= 70){
					   nowZoom = 70;   
				   }
				   zooms(imgMove);
				   if(nowZoom < 100){
					   imgMove.draggable({
						   disabled: false
					   });
				   }else{
					   imgMove.draggable({
						   disabled: true
					   });
					   
				   }
				}
			
			function zoomIn() {  
				var imgMove = $("#message").contents().find(".office-image");
				  if(nowZoom == 200) {
					     alert("더 이상 확대할 수 없습니다.");   
				  	}

				   nowZoom = nowZoom + 20;
				   if(nowZoom >= 200){
					   nowZoom = 200;   
				   }
				   zooms(imgMove);
				   if(nowZoom > 100){
					   imgMove.draggable({
						   disabled: false
					   });
				   }else{
					   imgMove.draggable({
						   disabled: true
					   });
					   
				   }
				}

			function zoomReset() {
				var imgMove = $("#message").contents().find(".office-image");
				   nowZoom = 100;   
				   zooms(imgMove);
				   imgMove.draggable({
					   disabled: true
				   });
				   $(imgMove).css("left",0);
				   $(imgMove).css("top",0);
				}

			function zooms(imgMove) {
//				var imgZoom = parent.document.getElementById("message").contentWindow.document.getElementById("body").getElementsByClassName("office-image")[0].style.zoom = nowZoom + "%";
				imgMove.css("zoom", nowZoom + "%");
				}
			

