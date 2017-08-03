package egovframework.ezMobile.ezEmail.service;

import java.util.Locale;

import org.json.simple.JSONArray;

import egovframework.ezMobile.ezOption.vo.MCommonVO;

public interface MEmailService {
	public JSONArray getMainMailList(MCommonVO info, Locale locale, String filter, String listSize);
}
