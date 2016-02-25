package egovframework.ezEKP.ezQuestion.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EZQuestionDAO")
public class ezQuestionDAO extends EgovAbstractDAO{
	Map<String, Object> map = new HashMap<String, Object>();
}
