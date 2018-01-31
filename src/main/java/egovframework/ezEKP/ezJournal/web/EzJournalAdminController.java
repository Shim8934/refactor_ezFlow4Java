package egovframework.ezEKP.ezJournal.web;

import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * @Description [Controller] 업무일지 관리자
 * @author 오픈솔루션팀 박성빈
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2018.01.18    박성빈    신규작성
 *
 * @see
 */

@Controller
public class EzJournalAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	
		
	
}
