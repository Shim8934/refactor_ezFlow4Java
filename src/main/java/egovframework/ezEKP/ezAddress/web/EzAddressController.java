package egovframework.ezEKP.ezAddress.web;

import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;

/** 
 * @Description [Controller] 사용자 - 주소록 
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.18    장진혁    신규작성
 *
 * @see
 */
@Controller
public class EzAddressController{
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzAddressService ezAddressService;
		
	/**
	 * 주소록 우편번호 팝업 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/address_zip_select.do")
	public String address_zip_select(Model model) throws Exception {		
		String lang = config.getProperty("config.primary");
		
		model.addAttribute("lang", lang);
		
		return "ezAddress/addressZipSelect";
	}
	
	/**
	 * 주소록 우편번호 검색 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/address_zip_iframe.do")
	public String address_zip_iframe(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {		
		String dong = request.getParameter("dong");

		if(dong != null){
			if(!dong.equals("")){
				List<AddressVO> list = ezAddressService.getAddressInfo(dong);
				model.addAttribute("list", list);
			}			
		}		
		
		return "ezAddress/addressZipIframe";
	}
	
} 