/**
 * @file 메인 페이지가(포탈/관리자/메일 등) 달라지더라도, top에는 꼭 필요한 함수들이 있습니다.
 * @author 솔루션1팀 김은실
 * @version 1.0.0
 * @date 2025-07-29
 */

function reloadLoginPage(multiLoginFlag, url) {
    var frm = "";

    frm = "<form action='" + url + "' method='post' style='display:none;' id='reloadLogin' onsubmit='return false;'>";
    if(!!multiLoginFlag) {
        frm += "<input type='hidden' name='multiLoginFlag' value='" + multiLoginFlag + "'>";
    }
    frm += "</form>";

    var wrapper = document.createElement("div");
    wrapper.innerHTML = frm;
    document.body.appendChild(wrapper);
    document.getElementById("reloadLogin").submit();
}
