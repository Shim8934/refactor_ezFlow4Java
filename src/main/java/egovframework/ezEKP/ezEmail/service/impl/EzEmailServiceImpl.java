package egovframework.ezEKP.ezEmail.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezEmail.dao.EzEmailDAO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;

@Service("EzEmailService")
public class EzEmailServiceImpl implements EzEmailService {

	@Resource(name="EzEmailDAO")
	private EzEmailDAO ezEmailDAO;

	@Override
	public List<MailGeneralVO> getMailGeneral(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userId);
		return ezEmailDAO.getMailGeneral(map);
	}

}
