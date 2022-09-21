package com.util;

import java.util.Enumeration;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.multipart.MultipartHttpServletRequest;


public class HashMapBinder {
	Logger logger = LogManager.getLogger(HashMapBinder.class);
	HttpServletRequest req = null;
	MultipartHttpServletRequest mreq = null;
	public HashMapBinder(MultipartHttpServletRequest mreq) {
		this.mreq = mreq;
	}
	public void mbind(Map<String, Object> pMap) {
		pMap.clear(); // 초기화를 해줌
		Enumeration<String> em = mreq.getParameterNames();
		while(em.hasMoreElements()) {
			String key = em.nextElement();
			pMap.put(key, HangulConversion.toUTF(mreq.getParameter(key)));
		}
		logger.info(pMap);
		
	}
}
