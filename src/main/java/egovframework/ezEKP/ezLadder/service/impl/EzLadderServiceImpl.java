package egovframework.ezEKP.ezLadder.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCircular.dao.EzCircularDAO;
import egovframework.ezEKP.ezCircular.service.impl.EzCircularServiceImpl;
import egovframework.ezEKP.ezLadder.dao.EzLadderDAO;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderVO;


@Service("EzLadderService")
public class EzLadderServiceImpl implements EzLadderService {

	private static final Logger logger = LoggerFactory.getLogger(EzLadderServiceImpl.class);
	
	@Resource(name="EzLadderDAO")
	private EzLadderDAO ezLadderDAO;
	
	@Override
	public List<LadderVO> getLadderList() throws Exception {
		logger.debug("getLadderList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		
		
		List<LadderVO> list = ezLadderDAO.getLadderList(map);
		return list;
	}

}
