/**
 * 해당 함수는
 * php의 mb_convert_kana의 Javascript 버전이다.
 * 히라가나는 반각이 없음.
 */
function mbConvertKana(text, option) {
  	var katahan = ["ｶﾞ", "ｷﾞ", "ｸﾞ", "ｹﾞ", "ｺﾞ", "ｻﾞ", "ｼﾞ", "ｽﾞ", "ｾﾞ", "ｿﾞ", "ﾀﾞ", "ﾁﾞ", "ﾂﾞ", "ﾃﾞ", "ﾄﾞ", "ﾊﾞ", "ﾊﾟ", "ﾋﾞ", "ﾋﾟ", "ﾌﾞ", "ﾌﾟ", "ﾍﾞ", "ﾍﾟ", "ﾎﾞ", "ﾎﾟ", "ｳﾞ", "ｰ", "ｧ", "ｱ", "ｨ", "ｲ", "ｩ", "ｳ", "ｪ", "ｴ", "ｫ", "ｵ", "ｶ", "ｷ", "ｸ", "ｹ", "ｺ", "ｻ", "ｼ", "ｽ", "ｾ", "ｿ", "ﾀ", "ﾁ", "ｯ", "ﾂ", "ﾃ", "ﾄ", "ﾅ", "ﾆ", "ﾇ", "ﾈ", "ﾉ", "ﾊ", "ﾋ", "ﾌ", "ﾍ", "ﾎ", "ﾏ", "ﾐ", "ﾑ", "ﾒ", "ﾓ", "ｬ", "ﾔ", "ｭ", "ﾕ", "ｮ", "ﾖ", "ﾗ", "ﾘ", "ﾙ", "ﾚ", "ﾛ", "ﾜ", "ｦ", "ﾝ", "ｶ", "ｹ", "ﾜ", "ｲ", "ｴ", "ﾞ", "ﾟ"];
  	var kanazen = ["ガ", "ギ", "グ", "ゲ", "ゴ", "ザ", "ジ", "ズ", "ゼ", "ゾ", "ダ", "ヂ", "ヅ", "デ", "ド", "バ", "パ", "ビ", "ピ", "ブ", "プ", "ベ", "ペ", "ボ", "ポ", "ヴ", "ー", "ァ", "ア", "ィ", "イ", "ゥ", "ウ", "ェ", "エ", "ォ", "オ", "カ", "キ", "ク", "ケ", "コ", "サ", "シ", "ス", "セ", "ソ", "タ", "チ", "ッ", "ツ", "テ", "ト", "ナ", "ニ", "ヌ", "ネ", "ノ", "ハ", "ヒ", "フ", "ヘ", "ホ", "マ", "ミ", "ム", "メ", "モ", "ャ", "ヤ", "ュ", "ユ", "ョ", "ヨ", "ラ", "リ", "ル", "レ", "ロ", "ワ", "ヲ", "ン", "ヵ", "ヶ", "ヮ", "ヰ", "ヱ", "゛", "゜"];
  	var hirazen = ["が", "ぎ", "ぐ", "げ", "ご", "ざ", "じ", "ず", "ぜ", "ぞ", "だ", "ぢ", "づ", "で", "ど", "ば", "ぱ", "び", "ぴ", "ぶ", "ぷ", "べ", "ぺ", "ぼ", "ぽ", "ヴ", "ー", "ぁ", "あ", "ぃ", "い", "ぅ", "う", "ぇ", "え", "ぉ", "お", "か", "き", "く", "け", "こ", "さ", "し", "す", "せ", "そ", "た", "ち", "っ", "つ", "て", "と", "な", "に", "ぬ", "ね", "の", "は", "ひ", "ふ", "へ", "ほ", "ま", "み", "む", "め", "も", "ゃ", "や", "ゅ", "ゆ", "ょ", "よ", "ら", "り", "る", "れ", "ろ", "わ", "を", "ん", "か", "け", "ゎ", "ゐ", "ゑ", "゛", "゜"];
  	var mojilength = katahan.length;
  	// r: 전각문자를 반각으로 변환
  	// a: 전각영문자를 반각으로 변환
  	if (option.match(/[ra]/)) {
    	text = text.replace(/[Ａ-ｚ]/g, function (elem) {
      	return String.fromCharCode(parseInt(elem.charCodeAt(0)) - 65248);
    	});
  	}
  	// R: 반각문자를 전각으로 변환
  	// A: 반각영문자를 전각으로 변환
  	if (option.match(/[RA]/)) {
    	text = text.replace(/[A-z]/g, function (elem) {
      	return String.fromCharCode(parseInt(elem.charCodeAt(0)) + 65248);
    	});
  	}
  	// n: 전각숫자를 반각으로 변환
  	// a: 전각 영숫자를 반각으로 변환
  	if (option.match(/[na]/)) {
    	text = text.replace(/[０-９]/g, function (elem) {
      	return String.fromCharCode(parseInt(elem.charCodeAt(0)) - 65248);
    	});
  	}
	// N: 반각숫자를 전각으로 변환
  	// A: 반각영숫자를 전각으로 변환
  	if (option.match(/[NA]/)) {
    	text = text.replace(/[0-9]/g, function (elem) {
      	return String.fromCharCode(parseInt(elem.charCodeAt(0)) + 65248);
    	});
  	}
  	// s: 전각스페이스를 반각으로 변환
  	if (option.match(/s/)) {
    	text = text.replace(/　/g, " ");
  	}
  	// S: 반각스페이스를 전각으로 변환
  	if (option.match(/S/)) {
    	text = text.replace(/ /g, "　");
  	}
  	// k: 전각카타카나를 반각카타카타로 변환
  	if (option.match(/k/)) {
    	for (i = 0; i < mojilength; i++) {
      	var re = new RegExp(kanazen[i], "g");
      	text = text.replace(re, katahan[i]);
    	}
  	}
  	// K: 반각카타카타를 전각카타카타로 변환
  	// V: 탁점사용중인 문자를 한글자로 변환
  	if (option.match(/K/)) {
  		if (!option.match(/V/)) {
  			text = text.replace(/ﾞ/g, "゛");
      		text = text.replace(/ﾟ/g, "゜");
    	}
    	for (i = 0; i < mojilength; i++) {
    		var re = new RegExp(katahan[i], "g");
      		text = text.replace(re, kanazen[i]);
    	}
  	}

  	// h: 전각히라가나를 반각카타카나로 변환
  	if (option.match(/h/)) {
    	for (var i = 0; i < mojilength; i++) {
      	var re = new RegExp(hirazen[i], "g");
      	text = text.replace(re, katahan[i]);
    	}
  	}
  	// H: 반각카타카나를 전각히라가라로 변환
  	// V: 탁점사용중인 문자를 한글자로 변환
  	if (option.match(/H/)) {
    	if (!option.match(/V/)) {
    		text = text.replace(/ﾞ/g, "゛");
      		text = text.replace(/ﾟ/g, "゜");
    	}
    	for (var i = 0; i < mojilength; i++) {
      		var re = new RegExp(katahan[i], "g");
      		text = text.replace(re, hirazen[i]);
    	}
  	}
  	// c: 전각카타카나를 전각히라가나로 변환
  	if(option.match(/c/)) {
    	for(var i = 0; i < mojilength; i++) {
      	var re = new RegExp(kanazen[i], "g");
      	text = text.replace(re, hirazen[i]);
    	}
  	}
  	// C: 전각히라가나를 전각카타카나로 변환
  	if (option.match(/C/)) {
    	for(var i = 0; i < mojilength; i++) {
      	var re = new RegExp(hirazen[i], "g");
      	text = text.replace(re, kanazen[i]);
    	}
  	}
  	return text;
}