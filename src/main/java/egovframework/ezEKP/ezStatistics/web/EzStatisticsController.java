package egovframework.ezEKP.ezStatistics.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/** 
 * @Description [Controller] 통계
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.06.27    이동호             신규작성
 *
 * @see
 */

@Controller
public class EzStatisticsController {
	
	/**
	 * 통계 메인화면 호출 함수
	 */
	@RequestMapping(value="/ezStatistics/statisticsMain.do")
	public String showMain() throws Exception{		
		return "ezStatistics/statisticsMain";
	}

}
