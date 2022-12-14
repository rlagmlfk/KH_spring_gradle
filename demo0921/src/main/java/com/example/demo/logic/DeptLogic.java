package com.example.demo.logic;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.DeptDao;
import com.example.demo.vo.DeptVO;
@Service
public class DeptLogic {
	Logger logger = LogManager.getLogger(DeptLogic.class);
	@Autowired
	private DeptDao deptDao = null;
	public List<Map<String, Object>> deptList(Map<String, Object> pMap) {
		List<Map<String, Object>> deptList = null;
		deptList = deptDao.deptList(pMap);
		return deptList;
	}
	public List<DeptVO> deptList2(Map<String, Object> pMap) {
		List<DeptVO> deptList = null;
		deptList = deptDao.deptList2(pMap);
		return deptList;
	}
	public int deptInsert(Map<String, Object> pMap) {
		logger.info("deptInsert호출");
		int result = 0;
		result = deptDao.deptInsert(pMap);
		return result;
	}
	public int deptDelete(Map<String, Object> pMap) {
		logger.info("deptDelete호출");
		int result = 0;
		result = deptDao.deptDelete(pMap);
		return result;
	}

}
