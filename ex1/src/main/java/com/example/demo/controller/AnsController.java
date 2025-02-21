package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Qna;
import com.example.demo.model.QnaAns;
import com.example.demo.model.StartEnd;
import com.example.demo.service.AnsService;


@Controller
public class AnsController {
	
	@Autowired
	private AnsService service;
	
	@GetMapping(value="/anslist")	
		public ModelAndView qnalist(Integer PAGE_NUM) {
			ModelAndView mav = new ModelAndView("anslist");					
			int currentPage = 1;
			if(PAGE_NUM != null) currentPage = PAGE_NUM;
			int count = this.service.getTotal();//이미지 게시글의 갯수를 검색
			int startRow = 0; int endRow = 0; int totalPageCount = 0;
			if(count > 0) {
				totalPageCount = count / 10;
				if(count % 10 != 0) totalPageCount++;
				startRow = (currentPage - 1) * 10;
				endRow = ((currentPage - 1) * 10) + 11;
				if(endRow > count) endRow = count;
			}
			StartEnd se = new StartEnd(); se.setStart(startRow); se.setEnd(endRow); 
			List<Qna> imageList = this.service.qnaList(se);//DB에서 이미지 게시글을 5개 검색한다.			
			mav.addObject("START",startRow); 
			mav.addObject("END", endRow);
			mav.addObject("TOTAL", count);	
			mav.addObject("currentPage",currentPage);
			mav.addObject("LIST",imageList); 
			mav.addObject("pageCount",totalPageCount);			
			return mav;	
	}
	@GetMapping(value="/ansdetail")
	public ModelAndView ansdetail(Integer ID) {
		ModelAndView mav = new ModelAndView("ansdetail");
		Qna qna = this.service.getqnaList(ID);
		mav.addObject("qna",qna);
		return mav;
	}
	@PostMapping(value="/ansinsert")
	public ModelAndView ansinsert(Integer qna_number, String ans_title, String ans_content) {
		ModelAndView mav = new ModelAndView();
		 System.out.println("qna_number: " + qna_number);
		    System.out.println("ans_title: " + ans_title);
		    System.out.println("ans_content: " + ans_content); // 여기서 null인지 확인
		QnaAns ans = new QnaAns();
		Integer count = this.service.getMaxQnaAnsId()+1;
		ans.setQna_number(qna_number);
		ans.setQna_ans(count);
		ans.setAns_content(ans_content);
		ans.setAns_title(ans_title);
		this.service.InsertQnaAns(ans);
		Qna qna = new Qna();
		this.service.UpdateIndex(ans.getQna_number());
		mav.setViewName("admin");
		return mav;		
	}
	
	
}
