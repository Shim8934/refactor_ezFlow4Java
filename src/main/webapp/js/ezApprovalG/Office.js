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
			

            var imgTag;
            var officeImgExist = false;
			function satImgCheck(){
			    if(!officeImgExist){
                    var tmpsrc = imgTag.src;
                    var formData = new FormData();
                    formData.append("docId", pDocID);
                    formData.append("tenantId", tenantID);
                    formData.append("companyId", orgCompanyID);
                    formData.append("userId", pUserID);
                    const regex = /fileext=([^&]*)/;
                    const match = tmpsrc.match(regex);
                    formData.append("ext", match[1]);
                    $.ajax({
                        type : "post",
                        data : formData,
                        url : "/ezApprovalG/officeUpload.do",
                        processData: false,
                        contentType: false,
                        success : function(result) {
                            setConvertedImg(result);
                            officeSaveFile();
                        },
                        error : function() {
                            alert("변환에 실패하였습니다.");
                        }
                    });
			    }
			}

			function officeSaveFile() {
				var result = "";
				var mhtBody = "";
				mhtBody = message.Get_EditorBodyHTML();
				officeEmbedContentIntoXML(mhtBody);
				mhtBody = ConvertHTMLtoMHT(mhtBody);

				var data = {
					docID : pDocID,
					html  : mhtBody,
					orgCompanyID : orgCompanyID
				}

				var url = typeof pendDir == "undefined" ? "/ezApprovalG/saveFile.do" : "/ezApprovalG/saveEndFile.do";

				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : url,
					contentType : "application/json",
					data : JSON.stringify(data),
					success: function(text){
						result = text;
					}
				});

				return result;
			}

			function officeEmbedContentIntoXML(bodyhtml) {
				var tempDiv = document.createElement("DIV");
				tempDiv.innerHTML = bodyhtml;

				var imgColl = tempDiv.getElementsByTagName("IMG");
				for (var i = 0; i < imgColl.length; i++) {
					if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0 && !imgColl.item(i).src.toLowerCase().indexOf(".tmp")) {
						var OrgSrc = imgColl.item(i).src;
						var ImgHeight = "0";
						var ImgWidth = "0";
						if (imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/) == null) {
							if (imgColl.item(i).style.width != "")
								ImgWidth = imgColl.item(i).style.width.replace("px", "");
							if (imgColl.item(i).style.height != "")
								ImgHeight = imgColl.item(i).style.height.replace("px", "");
						}
						else {
							var result = imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/);
							if (result.length == 2)
								ImgWidth = result[1];
							var result = imgColl.item(i).outerHTML.toLowerCase().match(/height="?([^>'"]+)['"]/);
							if (result.length == 2)
								ImgHeight = result[1];
						}
						officeConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
					}
				}
				return bodyhtml;
			}

			function officeConvertSaveImageFile(pUrl, pImgWidth, pImgHeight) {
				$.ajax({
					url : "/ezCommon/convertSaveImage.do",
					type : "POST",
					async : false,
					data : {
						"url" : encodeURI(pUrl),
						"height" : pImgHeight,
						"width" : pImgWidth,
						"type" : 2
					}
				});
			}

			function setConvertedImg(convertedImgInfo) {
				var divLength = parent.document.getElementById("message").contentWindow.document.getElementById("body").getElementsByClassName("divImg").length;
				if(divLength >0){
					$("#message").contents().find(".divImg").remove();
					var body = parent.document.getElementById("message").contentWindow.document.getElementById("body");
					var divImg = body.getElementsByClassName("divImg");
					$(divImg).remove();
				}
				var div = document.createElement('div');
				$(div).addClass("divImg");
				$(div).css("overflow", "hidden");
				parent.document.getElementById("message").contentWindow.document.getElementById("body").appendChild(div);

				var imgURL = convertedImgInfo;

				// 2021-01-14 이혁진 이미지 URL 가공
				var pagesIndexOf = imgURL.indexOf("pages");
				var pagesURL = imgURL.substr(pagesIndexOf);
				var pagesIndexOf2 = pagesURL.indexOf("&");
				var pagesURL2 = pagesURL.substr(0, pagesIndexOf2);
				var pagesIndexOf3 = pagesURL2.indexOf("=")+1;
				var pages = pagesURL2.substr(pagesIndexOf3); // PDF 페이지 수

				var fileIndexOf = imgURL.indexOf("filename");  // 이미지 filenm을 for문에서 대입해서 넣어주기위해 이미지URL을 자르기 위한 index값
				var fileURL = imgURL.substr(fileIndexOf);
				var fileIndexOf2 = fileURL.indexOf(".png");

				var imgURLF = imgURL.substr(0, fileIndexOf); // 이미지URL 이미지 순서 정해지기 전
				var imgURLL = fileURL.substr(fileIndexOf2); // 이미지URL 이미지 순서 정해진 후

				var body = $(parent.document).find('body');
				var selectBox = body.find("#selectImg");
				$(selectBox).children('option').remove();
				for(var i = 1; i <= pages; i++) {
					var imgSrc = document.createElement('img');
					var fileNm;

					if(i<10){
						fileNm = "filename=0000" + i;
					}else if(i<100){
						fileNm = "filename=000" + i;
					}else{
						fileNm = "filename=00" + i;
					}

					imgSrc.src = imgURLF + fileNm + imgURLL;
					imgSrc.style.width = "654px";
					imgSrc.style.border = "1px solid rgb(200, 200, 200)";
					imgSrc.style.boxSizing = "border-box";
					$(imgSrc).addClass("office-image");
					$(imgSrc).css("position", "relative");
					$(imgSrc).attr("z-index", 100);


					imgDiv = document.createElement('div');
					$(imgDiv).css("overflow", "hidden");
					$(imgDiv).css("page-break-before", "always");
					$(imgDiv).css("text-align", "center");

					if(i>1){
						$(imgDiv).css("display", "none");
					}else{
						$(imgDiv).addClass("imgDiv");
					}


					if(i == pages) {
						$(imgDiv).css("page-break-after", "always");
					}
					imgDiv.appendChild(imgSrc);
					div.appendChild(imgDiv);

					if(i <= pages){
						$(selectBox).append("<option value='" + i + "'>" + i +" / "+pages+ " Page</option>");
					}
				}
				var imgMove = parent.document.getElementById("message").contentWindow.document.getElementById("body").getElementsByClassName("office-image");
				officeBtn.style.display = "";
			}