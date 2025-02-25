package com.example.demo.controller;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.BookCategories;
import com.example.demo.model.Category;
import com.example.demo.service.GoodsService;
import com.example.demo.utils.CoverValidator;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class AdminController {
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private CoverValidator coverValidator;
	
    @GetMapping("/getCategories")
    public ResponseEntity<List<Category>> getCategories(@RequestParam("parent_id") String parentId) {
    	List<Category> categories = goodsService.getCategoriesByParentId(parentId);
        System.out.println("parent_id: " + parentId + " → categories: " + categories);
        
        if (categories.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(categories);
        }
        
        return ResponseEntity.ok(categories);  
        }
    @GetMapping("/getCategoryPath")
    @ResponseBody   //jsp가 아닌 json으로 받아와 정상출력 위해
    public String getCategoryPath(@RequestParam("cat_id") String catId) {
        return goodsService.getCategoryPath(catId);
    }
	@GetMapping(value = "/adminPage")
	public ModelAndView adminPage() {
		ModelAndView mav = new ModelAndView("admin");
		return mav;
	}
	@GetMapping(value = "/manageGoods")
	public ModelAndView manageGoods(Integer pageNo) {
		int currentPage = 1;
		if(pageNo != null) currentPage = pageNo;
		List<Book> goodsList = this.goodsService.getGoodsList(pageNo);
		ModelAndView mav = new ModelAndView("admin");
		Integer totalCount = this.goodsService.getGoodsCount();
		int pageCount = totalCount / 5;
		if(totalCount % 5 != 0) pageCount++;
		mav.addObject("GOODS",goodsList);
		mav.addObject("PAGES",pageCount);mav.addObject("currentPage",currentPage);
		mav.addObject("BODY","goodsList.jsp");
		return mav;
	}
	@PostMapping(value = "manageGoods/insertStock")
	public ModelAndView insertStock(Long isbn, @RequestParam("amount") 
					int amount, Model model) {
		System.out.println("ISBN: "+isbn);
		System.out.println("수량: "+amount);
		ModelAndView mav = new ModelAndView("admin");
		if (isbn == null || amount <= 0) {
	        mav.addObject("error", "유효한 ISBN과 수량을 입력하세요.");
	        mav.addObject("BODY", "insertStock.jsp");
	        return mav;
	    }
		this.goodsService.insertStock(isbn, amount);
		Book book = this.goodsService.getGoodsDetail(isbn);
		model.addAttribute("BOOK",book);
		model.addAttribute("AMOUNT", amount);
		mav.addObject("BODY","insertStockComplete.jsp");
		return mav;
	}
	@GetMapping(value = "/manageGoods/detail")   
	public ModelAndView goodsDetail(Long isbn) {
		ModelAndView mav = new ModelAndView("admin");
		Book goods = this.goodsService.getGoodsDetail(isbn);
		String catId = this.goodsService.getCategoryByIsbn(isbn);
		String categoryPath = this.goodsService.getCategoryPath(catId);
		mav.addObject(goods);
		mav.addObject("GOODS", goods);
		mav.addObject("catId", catId);
		mav.addObject("categoryPath", categoryPath);  // 기존 카테고리 경로
		mav.addObject("BODY","goodsDetail.jsp");
		return mav;
	}
	@PostMapping(value = "/manageGoods/search")
	public ModelAndView goodsSearch(String TITLE, Integer pageNo) {
		int currentPage = 1;
		if(pageNo != null) currentPage = pageNo;
		List<Book> goodsList = this.goodsService.getGoodsByName(TITLE, pageNo);
		Integer totalCount = this.goodsService.getGoodsCount();
		int pageCount = totalCount / 5;
		if(totalCount % 5 != 0) pageCount++;
		ModelAndView mav = new ModelAndView("admin");
		mav.addObject("PAGES",pageCount);mav.addObject("currentPage",currentPage);
		mav.addObject("GOODS",goodsList);
		mav.addObject("BODY","goodsByTitle.jsp");
		mav.addObject("TITLE",TITLE);
		return mav;
	}
	@GetMapping(value = "/manageGoods/add")
	public ModelAndView goodsAdd() {
		ModelAndView mav = new ModelAndView("admin");
		mav.addObject(new Book());
		mav.addObject("BODY","addGoods.jsp");
		return mav;
	}
	@PostMapping(value = "/manageGoods/insert")
	public ModelAndView goodsInsert(@Valid Book book,
			BindingResult br, HttpSession session, @RequestParam("cat_id") 
			String selectedCat, @RequestParam("authors") String authors) {
		ModelAndView mav = new ModelAndView("admin");
		this.coverValidator.validate(book, br);
		if(br.hasErrors()) {
			mav.addObject("BODY","addGoods.jsp");
			mav.addObject("","");
			mav.getModel().putAll(br.getModel());
			System.out.println("검증 오류 발생: " + br.getAllErrors());
			return mav;
		}
		//이미지 업로드
		MultipartFile multipart = book.getCoverImage();//선택한 파일을 불러온다.
		String fileName = null; String path = null; OutputStream os = null;
		fileName = multipart.getOriginalFilename();//선택한 파일의 이름을 찾는다.
		ServletContext ctx = session.getServletContext();//ServletContext 생성
		path = ctx.getRealPath("/upload/"+fileName);// upload 폴더의 절대 경로를 획득
		System.out.println("업로드 경로:"+path);
		try {
			os = new FileOutputStream(path);//OutputStream을 생성한다.즉, 파일 생성
			BufferedInputStream bis = new BufferedInputStream(multipart.getInputStream());
			//InputStream을 생성한다. 즉, 원본파일을 읽을 수 있도록 연다.
			byte[] buffer = new byte[8156];//8K 크기로 배열을 생성한다.
			int read = 0;//원본 파일에서 읽은 바이트 수를 저장할 변수 선언
			while( (read = bis.read(buffer)) > 0) {//원본 파일에서 읽은 바이트 수가 0이상인 경우 반복
				os.write(buffer, 0, read);//생성된 파일에 출력(원본 파일에서 읽은 바이트를 파일에 출력)
			}
		}catch(Exception e) {
			System.out.println("파일 업로드 중 문제 발생!");
		}finally {
			try { if(os != null) os.close(); }catch(Exception e) {}
		}
		book.setImage_name(fileName);//업로드 된 파일 이름을 Book에 설정
		
		//끝
		if (book.getCoverImage() == null || book.getCoverImage().isEmpty()) {
	        mav.addObject("BODY", "addGoods.jsp");
	        mav.addObject("imageError", "앞표지를 업로드해야 합니다.");
	        return mav;
	    }
		//저자,옮긴이 주입 위해서
		book.setAuthors(authors);
		
		this.goodsService.addGoods(book, selectedCat);//책 객체와 cat_id 동시에 불러옴
		
		BookCategories bookcat = new BookCategories();
		bookcat.setIsbn(book.getIsbn());
		bookcat.setCat_id(selectedCat);
		this.goodsService.addInfoCategory(bookcat);
		
		System.out.println("선택된 카테고리 ID: " + selectedCat);
		System.out.println("INSERT SQL 실행: " + book);
//		System.out.println("DB INSERT 결과: " + result);
		mav.addObject("BODY","addGoodsComplete.jsp");
		return mav;
	}
	@GetMapping(value = "/manageGoods/isbnCheck")
	public ModelAndView isbnCheck(Long isbn) {
		ModelAndView mav = new ModelAndView("isbnCheckResult");
		Integer count = this.goodsService.getIsbnDup(isbn);
		if(count > 0) {
			mav.addObject("DUP","YES");
		}else {
			mav.addObject("DUP","NO");
		}
		mav.addObject("ISBN",isbn);
		return mav;
	}
	@PostMapping(value = "/manageGoods/update") 
	public ModelAndView updateGoods(@Valid Book book,
				BindingResult br, HttpSession session, @RequestParam("cat_id")
				String selectedCat, @RequestParam("authors")String authors) {
		ModelAndView mav = new ModelAndView("admin");
		this.coverValidator.validate(book, br);
		if(br.hasErrors()) {
			mav.addObject("BODY","addGoods.jsp");
			mav.addObject("","");
			mav.getModel().putAll(br.getModel());
			System.out.println("검증 오류 발생: " + br.getAllErrors());
			return mav;
		}
		//이미지 업로드
		MultipartFile multipart = book.getCoverImage();//선택한 파일을 불러온다.
		if(! multipart.getOriginalFilename().equals("")) {//파일이름이 존재하는 경우,즉 이미지 변경
		String fileName = null; String path = null; OutputStream os = null;
		fileName = multipart.getOriginalFilename();//선택한 파일의 이름을 찾는다.
		ServletContext ctx = session.getServletContext();//ServletContext 생성
		path = ctx.getRealPath("/upload/"+fileName);// upload 폴더의 절대 경로를 획득
		System.out.println("변경된 경로:"+path);
		try {
			os = new FileOutputStream(path);//upload폴더에 파일 재생성
			BufferedInputStream bis = new BufferedInputStream(multipart.getInputStream());
			//InputStream을 생성한다. 즉, 원본파일을 읽을 수 있도록 연다.
			byte[] buffer = new byte[8156];//8K 크기로 배열을 생성한다.
			int read = 0;//원본 파일에서 읽은 바이트 수를 저장할 변수 선언
			while( (read = bis.read(buffer)) > 0) {//원본 파일에서 읽은 바이트 수가 0이상인 경우 반복
				os.write(buffer, 0, read);//생성된 파일에 출력(원본 파일에서 읽은 바이트를 파일에 출력)
			}
		}catch(Exception e) {
			System.out.println("변경 중 문제 발생!");
		}finally {
			try { if(os != null) os.close(); }catch(Exception e) {}
		}
		book.setImage_name(fileName);//업로드 된 파일 이름을 Book에 설정
		if (book.getCoverImage() == null || book.getCoverImage().isEmpty()) {
	        mav.addObject("BODY", "addGoods.jsp");
	        mav.addObject("imageError", "앞표지를 업로드해야 합니다.");
	        return mav;
		}
		this.goodsService.updateGoods(book);
		
		
		
//		this.imageService.updateImageBBS(imagebbs);
//		mav.addObject("BODY","imageUpdateResult.jsp");
//		return mav;
		
		mav.addObject("isbnChecked","");
//		model.addAttribute("BOOK",book);
		mav.addObject("book",new Book());
		mav.addObject("BODY","updateComplete.jsp");
		return mav;
		}
		return mav;//임시
	}
}

