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
        new memorialDay("신정", "New Year's Day", 1, 1, 1, true),
        new memorialDay("", "", 12, 0, 2, true, true),
        new memorialDay("설날", "Lunar New Year", 1, 1, 2, true),
        new memorialDay("", "", 1, 2, 2, true),
        new memorialDay("3·1절", "Samiljeol", 3, 1, 1, true),
        new memorialDay("석가탄신일", "Buddha's Birthday", 4, 8, 2, true),
        new memorialDay("어린이날", "Children's Day", 5, 5, 1, true),
        new memorialDay("현충일", "Memorial Day", 6, 6, 1, true),
        new memorialDay("광복절", "National Liberation Day", 8, 15, 1, true),
        new memorialDay("", "", 8, 14, 2, true),
        new memorialDay("추석", "Thanksgiving Day", 8, 15, 2, true),
        new memorialDay("", "", 8, 16, 2, true),
        new memorialDay("김경식", "김경식의 테스트 기념일", 8, 31, 1, true),
        new memorialDay("개천절", "Foundation Day", 10, 3, 1, true),
        new memorialDay("성탄절", "Christmas", 12, 25, 1, true),
        new memorialDay("한글날", "Hangul Proclamation Day", 10, 9, 1, true)
       );

function yearmemorialDay(name, name2, year, month, day, solarLunar, holiday, type) {
    this.name = name;
    this.name2 = name2;
    this.year = year;
    this.month = month;
    this.day = day;
    this.solarLunar = solarLunar;
    this.holiday = holiday;
    this.type = type;
    this.techneer = true;
}

function memorialDay(name, name2, month, day, solarLunar, holiday, type) {
    this.name = name;
    this.name2 = name2;
    this.month = month;
    this.day = day;
    this.solarLunar = solarLunar;
    this.holiday = holiday;
    this.type = type;
    this.techneer = true;
}

