<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="upload.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html>
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		
	<script type="text/javascript">

		window.onload = function() {

			var strContentType = document.getElementById("divContentType").value;
			var strImagePath = document.getElementById("divImagePath").value;
			
			var dialogType = document.getElementById('dialogType').value;

			if (strImagePath != undefined && strImagePath != "") {

				var strLocation = location.href;//페이지 값이 반환 ex)document.write(location.href); -> http://localhost/testcode.asp 반환
				strLocation = strLocation.replace("/uploaddot", "");//닷넷폴더는 한수준 아래에 있으니깐..
				var index = strLocation.lastIndexOf("/");//그러므로 위 반환값의 /의 마지막위치 뒤쪽에 상대경로값을 붙여주면 된다.

				if (index > 0) {

					strLocation = strLocation.substring(0, index+1) + document.getElementById("divImagePath").value;

				} else {

					strLocation = parent.tseBasePath + "/upload/" + document.getElementById("divImagePath").value;
				}

				if (strContentType == "flash") {					
					
					if(parent.insertFlash) {					    

						parent.insertFlash.setFlash(strLocation);

					} else {

						parent.parent.insertFlash.setFlash(strLocation);
					}

				} else if (strContentType == "image") {						
					
					// 배경 이미지 처리.
					if(dialogType === 'background') {

						if(parent.insertBackground) {

							parent.insertBackground.setBgImage(strLocation);

						} else {

							parent.parent.insertBackground.setBgImage(strLocation);	
						}

					} else {

						if(parent.insertImage) {

							parent.insertImage.setImage(strLocation);

						} else {

							parent.parent.insertImage.setImage(strLocation);
						}
					}
				}	
			} else {

				alert("에러발생");
			}
		};
	</script>
</head>

<body>
    <form id="form1" runat="server">
		<div>
			<input type="hidden" id="divContentType"  runat="server" />
			<input type="hidden" id="divImagePath" runat="server" />

			<input type="hidden" id="dialogType" runat="server" />
			
		</div>
    </form>
</body>
</html>
