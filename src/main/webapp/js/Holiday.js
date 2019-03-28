// ** 
// * @Description [Controller] 휴일 데이터
// * 휴일 데이터가 여러 js 파일에 혼재하여 한 곳으로 모을 필요가 있음. 나중에는 DB에서 관리하도록 해야
// * @author 오픈솔루션팀 지정석
// * @Modification Information
// *
// *    수정일        수정자         수정내용
// *    ----------    ------    -------------------
// *    2016.08.19	김경식	신규작성
// *
// * @see
// */

var yearmemorialDays = Array(
		);


var memorialDays = Array(
		 
);



function yearmemorialDay(name, name2, year, month, day, solarLunar, holiday, type, repetition) {
    this.name = name;
    this.name2 = name2;
    this.year = year;
    this.month = month;
    this.day = day;
    this.solarLunar = solarLunar;
    this.holiday = holiday;
    this.type = type;
    this.techneer = true;
    this.repetition = repetition;
}

function memorialDay(name, name2, month, day, solarLunar, holiday, type, repetition) {
    this.name = name;
    this.name2 = name2;
    this.month = month;
    this.day = day;
    this.solarLunar = solarLunar;
    this.holiday = holiday;
    this.type = type;
    this.techneer = true;
    this.repetition = repetition;
}

