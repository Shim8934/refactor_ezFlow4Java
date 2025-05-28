/**
 * 메일에서만 보이는 window.open 설정셋 (mailLeft 중복코드)
 * 새로 만들때는 되도록: XmlHttpRequest.js의 GetOpenWindowfeature 또는 GetOpenWindow를 사용하자.
 */
function openWindowForMail(url, name, featureObj) {
    // featureObj : 추후 feature의 값을 바꾸는 유동적인 함수로 사용할 시, feature를 객체화 하여 속성(pTop,pLeft 등)을 설정하고 조건화하여 사용바람.

	var minimumWidth = 890;
    var pheight = window.outerHeight;
    var conHeight = pheight;
    var pwidth = window.outerWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > minimumWidth)
        conWidth = minimumWidth;

    var pLeft = window.outerWidth / 2 + window.screenX - (conWidth / 2);
    var pTop = window.outerHeight / 2 + window.screenY - (conHeight / 2);
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
//    console.log("feature: %s", feature);

    window.open(url, name, feature);
}