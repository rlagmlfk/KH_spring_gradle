package com.example.demo.controller;

import org.apache.logging.log4j.LogManager;

import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/board")
public class BoardController {
	Logger logger = LogManager.getLogger(BoardController.class);
	//http://localhost:5000/board
	@GetMapping
	public String board() {
		return "board/index";
	}
}
