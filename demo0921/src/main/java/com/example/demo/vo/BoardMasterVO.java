package com.example.demo.vo;

import lombok.Data;

@Data
public class BoardMasterVO {

	private int    b_no          =0;     
	private String b_title       ="";
	private String b_writer      ="";
	private String b_content     ="";
	private int    b_hit         =0;     
	private int    b_group       =0;
	private int    b_pos         =0;
	private int    b_step        =0;
	private String b_date        ="";
	private String b_pw          ="";
	private BoardSubVO boardSubVO = null;
	private String  bs_file     ="";
	private String  bs_size     ="";
	private int  	bs_seq      =0;

}
