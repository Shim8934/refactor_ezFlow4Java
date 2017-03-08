package egovframework.ezEKP.ezStatistics.web;

import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
public class EzStatisticsLeftMenuController {
	
    @Autowired
    private Properties config;
    
	/**
	 * 통계 좌측 메뉴 화면 표시 함수
	 */
	@RequestMapping(value="/ezStatistics/statisticsLeftMenu.do")
	public String statisticsLeftMenu(Model model) throws Exception {
	    String IsJMochaStandAlone = config.getProperty("config.IsJMochaStandAlone");
	    String use_approvalG = config.getProperty("config.UserInfo_ApprovalG");
	    
	    model.addAttribute("IsJMochaStandAlone", IsJMochaStandAlone);
	    model.addAttribute("use_approvalG", use_approvalG);
	    
		return "ezStatistics/statisticsLeftMenu";
	}

}
