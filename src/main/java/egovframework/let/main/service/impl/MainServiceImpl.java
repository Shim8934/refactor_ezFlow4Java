package egovframework.let.main.service.impl;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.let.main.dao.MainDAO;
import egovframework.let.main.service.MainService;
import egovframework.let.main.vo.MainVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("mainService")
public class MainServiceImpl extends EgovAbstractServiceImpl implements MainService {

    private static final Logger logger = LoggerFactory.getLogger(MainServiceImpl.class);
            
    @Resource(name="mainDAO")
    private MainDAO mainDAO;

	@Override
	public void insertAdminLog(MainVO vo) throws Exception {
		mainDAO.insertAdminLog(vo);
	}
    
}