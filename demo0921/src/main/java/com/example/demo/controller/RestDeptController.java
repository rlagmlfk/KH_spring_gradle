package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.example.demo.logic.DeptLogic;
import com.example.demo.vo.DeptVO;
import com.google.gson.Gson;

@RestController // 리액트 연동할 때는 RestController를 사용함
@RequestMapping("/dept/*")
public class RestDeptController {
	Logger logger = LogManager.getLogger(RestDeptController.class);
	@Autowired
	private DeptLogic deptLogic = null;
	@GetMapping("jsonDeptList")
	public String deptList(Model model, @RequestParam Map<String, Object> pMap) {
		logger.info("deptList 호출성공");
		List<Map<String, Object>> deptList = null;
		deptList = deptLogic.deptList(pMap);
		String temp = null;
		Gson g = new Gson();
		temp = g.toJson(deptList);
		return temp;
	}

}
