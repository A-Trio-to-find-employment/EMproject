package com.example.demo.controller;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Qna;
import com.example.demo.model.QnaBoard;
import com.example.demo.model.StartEnd;
import com.example.demo.service.LoginService;
import com.example.demo.service.QnaService;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class QnaController {
	@Autowired
	private QnaService service;	
	
	@Autowired
	public LoginService loginService;
	
	
	@GetMapping(value="/qnadetail")
	public ModelAndView qnadetail( HttpSession session ,Integer ID) {
		ModelAndView mav = new ModelAndView("qnalayout");
		Qna qna = this.service.getqnaList(ID);
		String qnanas=this.service.getAnsContent(ID);
		qna.setAns_content(qnanas);
		mav.addObject("qna",qna);
		mav.addObject("BODY","qnadetail.jsp");
		return mav;
	}
	
	@GetMapping(value="/qnalist")
	public ModelAndView qnalist(Integer PAGE_NUM,HttpSession session) {
		ModelAndView mav = new ModelAndView("qnalayout");		
		String user = (String)session.getAttribute("loginUser");
		
		mav.addObject("BODY","qnalist.jsp");
		int currentPage = 1;
		if(PAGE_NUM != null) currentPage = PAGE_NUM;
		int count = this.service.getTotal(user);//이미지 게시글의 갯수를 검색
		int startRow = 0; int endRow = 0; int totalPageCount = 0;
		if(count > 0) {
			totalPageCount = count / 5;
			if(count % 5 != 0) totalPageCount++;
			startRow = (currentPage - 1) * 5;
			endRow = ((currentPage - 1) * 5) + 6;
			if(endRow > count) endRow = count;
		}
		StartEnd se = new StartEnd(); se.setStart(startRow); se.setEnd(endRow); se.setUser_id(user);
		List<Qna> imageList = this.service.qnaList(se);//DB에서 이미지 게시글을 5개 검색한다.
		mav.addObject("BODY","qnalist.jsp");
		mav.addObject("START",startRow); 
		mav.addObject("END", endRow);
		mav.addObject("TOTAL", count);	
		mav.addObject("currentPage",currentPage);
		mav.addObject("LIST",imageList); 
		mav.addObject("pageCount",totalPageCount);
		
		return mav;
	}
	
	@PostMapping(value="/qnawriteform")
	public ModelAndView qnawrite( HttpSession session,@ModelAttribute("Qna")@Valid Qna qna,BindingResult br) {		
	ModelAndView mav = new ModelAndView("qnalayout");	
	 if (br.hasErrors()) {
	        mav.addObject("BODY", "QnaWriteForm.jsp"); // 작성 폼 페이지로 이동
	        mav.addObject("errors", br.getAllErrors()); // 에러 메시지 전달
	        return mav;
	    }
	///이미지 파일 업로드 및 DB에 삽입 
	MultipartFile multipart = qna.getImage();//선택한 파일을 불러온다.
	String fileName = null; String path = null; OutputStream os = null;
	
	 if (multipart != null && !multipart.isEmpty()) { // 파일이 있을 경우만 처리
	        fileName = multipart.getOriginalFilename(); // 선택한 파일 이름
	        ServletContext ctx = session.getServletContext(); // ServletContext 생성
	        path = ctx.getRealPath("/upload/" + fileName); // 업로드 폴더의 절대 경로 획득
	        System.out.println("업로드 경로: " + path);

	        try {
	            os = new FileOutputStream(path); // 파일 생성
	            BufferedInputStream bis = new BufferedInputStream(multipart.getInputStream());
	            byte[] buffer = new byte[8156]; // 8K 크기로 배열 생성
	            int read = 0;
	            while ((read = bis.read(buffer)) > 0) { // 원본 파일에서 읽은 바이트 수가 0 이상인 경우 반복
	                os.write(buffer, 0, read); // 파일에 출력
	            }
	            qna.setQna_image(fileName); // 업로드된 파일 이름 저장
	        } catch (Exception e) {
	            System.out.println("파일 업로드 중 문제 발생!");
	        } finally {
	            try { if (os != null) os.close(); } catch (Exception e) {}
	        }
	    } else {
	        qna.setQna_image(null); // 파일이 없을 경우 null 설정 (또는 기본 이미지 설정 가능)
	    }
	qna.setQna_image(fileName);//업로드 된 파일 이름을 Imagebbs에 설정
	int maxNum = this.service.getMaxWid() + 1;//글번호 생성
	
	qna.setQna_number(maxNum);//글번호 설정
	String users = (String)session.getAttribute("loginUser");//세션에서 LoginUser를찾음
	qna.setUser_id(users);//작성자에 계정을 설정
	
	this.service.putQna(qna);//DB에 insert
	mav.setViewName("redirect:/qnalist");
	return mav;	
	}
	@RequestMapping(value="/qnawrite")
	public ModelAndView writeform() {
		ModelAndView mav = new ModelAndView("qnalayout");
		mav.addObject("Qna",new Qna());
		mav.addObject("BODY","QnaWriteForm.jsp");
		return mav;
	}
	@GetMapping(value="/qna")
	public ModelAndView qna() {
		ModelAndView mav = new ModelAndView("qnalayout");
		List<QnaBoard> list = this.service.getQnaBoard();
		mav.addObject("list",list);
		mav.addObject("BODY","qna.jsp");
		return mav;
	}
}
