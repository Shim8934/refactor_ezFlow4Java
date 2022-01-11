package egovframework.let.main.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import egovframework.com.cmm.EgovMessageSource;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.let.main.dao.MainDAO;
import egovframework.let.main.service.MainService;
import egovframework.let.main.vo.MainVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

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