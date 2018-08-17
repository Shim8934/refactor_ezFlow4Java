package egovframework.ezEKP.ezMemo.web;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzMemoGWController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzLadderService")
	private EzLadderService ezLadderService;
	
	@Resource(name="MOptionService")
	private MOptionService MOptionService;
	
	@Autowired
	private EzOrganService ezOrganService;
}
