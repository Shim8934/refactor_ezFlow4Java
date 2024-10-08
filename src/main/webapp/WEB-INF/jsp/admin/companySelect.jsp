<span class="title_bar"><img src="/images/name_bar.gif"></span>
<label for="ListCompany" style="display: none;"></label>
<select class="companySelect" id="ListCompany"></select>
<script>
    // 선택된 회사값 :companySelectID
    // 변경시 함수 : changeCompany(회사id) 함수로 선언하면 select 변경시 실행
    var companySelectID = '' ;
    (function () {
        var request = new XMLHttpRequest();
        request.open('GET', '/admin/ezOrgan/getCompanies.do', false);
        request.setRequestHeader('Content-Type', 'application/json');
        request.onload = function () {
            if (request.status >= 200 && request.status < 400) {
                var result = JSON.parse(request.responseText);

                var userCompany = '${param.companySelectID}' || result.userCompany;
                var companyList = result.list;
                var select = document.getElementById("ListCompany");
                if (!result.isMaster) {
                    select.style.display = "none";
                }

                companyList.forEach(function (item) {
                    var optionElement = document.createElement("option");
                    optionElement.value = item.cn;
                    optionElement.text = item.displayName;
                    if (item.cn === userCompany) {
                        optionElement.selected = true;
                        companySelectID = item.cn;
                    }
                    select.appendChild(optionElement);
                });

                if (!companySelectID) {
                    companySelectID = select.value;
                }
                
                select.onchange = function () {
                    companySelectID = select.options[select.selectedIndex].value;

                    if (typeof window['changeCompany'] === 'function') {
                        window['changeCompany'](companySelectID);
                    }
                };
            }
        };

        request.onerror = function () {
            console.log("getCompanies failed");
        };

        request.send();
    })();
</script>