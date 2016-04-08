package egovframework.ezEKP.ezCommunity.web;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCommunityController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value="/ezCommunity/communityMain.do")
	public String  main(){
		
		return "/ezCommunity/communityMain";
	}
	
	@RequestMapping(value ="/ezCommunity/communityLeftCommunity.do")
	public String communityLeftCommunity(){
		
		return "/ezCommunity/communityLeftCommunity";
	}
}
