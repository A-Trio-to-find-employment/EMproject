package com.example.demo.controller;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
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
import com.example.demo.model.BookStatistics;
import com.example.demo.model.Category;
import com.example.demo.model.DeliveryModel;
import com.example.demo.model.Review;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.Users;
import com.example.demo.service.FieldService;
import com.example.demo.service.GoodsService;
import com.example.demo.service.LoginService;
import com.example.demo.service.OrderService;
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
	@Autowired
	private FieldService fieldService;
	@Autowired
	private LoginService loginService;
	@Autowired
	private OrderService orderService;
	
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
	@GetMapping(value = "/manageGoods/passwordCheck")
	public ModelAndView passwordCheck(){
		ModelAndView mav = new ModelAndView("passwordCheck");
		return mav;
	}
	@PostMapping(value = "/manageGoods/update") 
	public ModelAndView updateGoods(@Valid Book book,
				BindingResult br, HttpSession session, @RequestParam("cat_id")
				String selectedCat, @RequestParam("authors")String authors) {
	    System.out.println("수정 대상 도서: " + book);
		ModelAndView mav = new ModelAndView("admin");
		this.coverValidator.validate(book, br);
		if(br.hasErrors()) {
			mav.addObject("BODY","goodsDetail.jsp");
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
		book.setAuthors(authors);
		this.goodsService.updateGoods(book);
		
		mav.addObject("isbnChecked",book.getIsbn());
		mav.addObject("book",new Book());
		mav.addObject("BODY","updateComplete.jsp");
		}
		return mav;
	}
	@PostMapping(value = "/manageGoods/delete")//구현중
	public ModelAndView deleteGoods(Book book, Review review,
			@RequestParam("authors")String authors) {
		int replyCount = this.goodsService.getReplyCount(review.getReview_id());
		ModelAndView mav = new ModelAndView("admin");
		if(replyCount > 0) {//답글이 있는 글, 즉 삭제 불가
			mav.addObject("BODY","goodsDeleteResult.jsp?R=NO");
		}else {//답글이 없는 글, 즉 삭제 가능
			book.setAuthors(authors);
			Long isbn = book.getIsbn();
			this.goodsService.deleteBookAuthors(isbn);
			this.goodsService.deleteCatInfo(isbn);
			this.goodsService.deleteGoods(isbn);
			mav.addObject("book",book);
			mav.addObject("BODY","goodsDeleteResult.jsp");
		}
		return mav;
	}
	@GetMapping(value = "/goStatistics")
	public ModelAndView goStatistics(@RequestParam(value = "SELECT", required = false) String SELECT,
	                                 @RequestParam(value = "SEARCH", required = false) String SEARCH,
	                                 Integer PAGE, String KEY) {
	    ModelAndView mav = new ModelAndView("statisticsList");
	    List<BookStatistics> bsList = new ArrayList<BookStatistics>();
	    int currentPage = 1;
		if(PAGE != null) currentPage = PAGE;
		int start = (currentPage - 1) * 9;
		int end = ((currentPage - 1) * 9) + 10;	
		StartEndKey sek = new StartEndKey();
		sek.setStart(start); sek.setEnd(end);
		
	    if (SEARCH != null) {
	        if (SELECT == null || SELECT.isEmpty()) {  // NULL 체크 후 처리
	        	sek.setKey(SEARCH);
	            bsList = this.fieldService.getBookSalesSearch(sek);
	        } else if("전체 판매량".equals(SELECT)) {
	        	sek.setKey(SEARCH);
	            bsList = this.fieldService.getBookSalesSearch(sek);
	        } else if ("일일 판매량".equals(SELECT)) {
	        	sek.setKey(SEARCH);
	            bsList = this.fieldService.getBookSalesSearchDT(sek);
	        } else if ("전체 판매액".equals(SELECT)) {
	        	sek.setKey(SEARCH);
	            bsList = this.fieldService.getBookSalesSearchTR(sek);
	        } else if ("일일 판매액".equals(SELECT)) {
	        	sek.setKey(SEARCH);
	            bsList = this.fieldService.getBookSalesSearchDR(sek);
	        }
	        int totalCount = this.fieldService.getBookCountSearch(SEARCH);
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
	    } else {
	        if (SELECT == null || SELECT.isEmpty()) {  // NULL 체크 후 처리
	            bsList = this.fieldService.getBookSalesReport(sek);
	        } else if("전체 판매량".equals(SELECT)) {
	            bsList = this.fieldService.getBookSalesReport(sek);
	        } else if ("일일 판매량".equals(SELECT)) {
	            bsList = this.fieldService.getBookSalesReportDT(sek);
	        } else if ("전체 판매액".equals(SELECT)) {
	            bsList = this.fieldService.getBookSalesReportTR(sek);
	        } else if ("일일 판매액".equals(SELECT)) {
	            bsList = this.fieldService.getBookSalesReportDR(sek);
	        }
	        int totalCount = this.fieldService.getBookCount();
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
	    }
		mav.addObject("currentPage",currentPage);
	    mav.addObject("SELECT", SELECT);
	    mav.addObject("SEARCH", SEARCH);
	    mav.addObject("bsList", bsList);
	    return mav;
	}
	@GetMapping(value="/userStatistics")
	public ModelAndView goUserStatistics(Integer PAGE, String KEY) {
		ModelAndView mav = new ModelAndView("userStatisList");
		int currentPage = 1;
		if(PAGE != null) currentPage = PAGE;
		int start = (currentPage - 1) * 9;
		int end = ((currentPage - 1) * 9) + 10;	
		StartEndKey sek = new StartEndKey();
		sek.setStart(start); sek.setEnd(end);
		List<Users> userList = new ArrayList<Users>();
		if(KEY != null) {
			sek.setKey(KEY);
			userList = this.loginService.getUserListSearch(sek);
			int totalCount = this.loginService.getUserCountSearch(KEY);
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
		}else {
			userList = this.loginService.getUserList(sek);
			int totalCount = this.loginService.getUserCount();
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
		}
		
		mav.addObject("currentPage",currentPage);
	    mav.addObject("userList", userList);
		return mav;
	}
	@GetMapping(value="/goUserDetailAdmin")
	public ModelAndView goUserDetailAdmin(String ID) {
		ModelAndView mav = new ModelAndView("userDetailAdmin");
		Users user = this.loginService.getUserByIdAdmin(ID);
		mav.addObject("userDetail", user);
		return mav;
	}
	@GetMapping(value="/orderStatistics")
	public ModelAndView goOrderStatistics(Integer PAGE, String SELECT) {
		ModelAndView mav = new ModelAndView("delivStatistics");
		int currentPage = 1;
		if(PAGE != null) currentPage = PAGE;
		int start = (currentPage - 1) * 9;
		int end = ((currentPage - 1) * 9) + 10;	
		StartEndKey sek = new StartEndKey();
		sek.setStart(start); sek.setEnd(end);
		List<DeliveryModel> orderList = new ArrayList<DeliveryModel>();
		if(SELECT == null || SELECT.isEmpty()) {
			orderList = this.orderService.getDeliveryListWithoutStatus(sek);
			int totalCount = this.orderService.getOrderDetailCount();
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
		}else if(SELECT.equals("배송 준비중")) {
			sek.setAns(0);
			orderList = this.orderService.getDeliveryListWithStatus(sek);
			int totalCount = this.orderService.getOrderDetailCountDeliv(sek.getAns());
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
		}else if(SELECT.equals("배송 중")) {
			sek.setAns(1);
			orderList = this.orderService.getDeliveryListWithStatus(sek);
			int totalCount = this.orderService.getOrderDetailCountDeliv(sek.getAns());
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
		}else if(SELECT.equals("배송 취소")) {
			sek.setAns(2);
			orderList = this.orderService.getDeliveryListWithStatus(sek);
			int totalCount = this.orderService.getOrderDetailCountDeliv(sek.getAns());
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
		}else if(SELECT.equals("배송 완료")) {
			sek.setAns(3);
			orderList = this.orderService.getDeliveryListWithStatus(sek);
			int totalCount = this.orderService.getOrderDetailCountDeliv(sek.getAns());
			int pageCount = totalCount / 10;
			if(totalCount % 10 != 0) pageCount++;
			mav.addObject("PAGES", pageCount);
		}
		mav.addObject("SELECT", SELECT);
		mav.addObject("currentPage",currentPage);
	    mav.addObject("orderList", orderList);
		return mav;
	}
	@GetMapping(value="updateDeliveryStatus")
	public ModelAndView updateDeliveryStatus(String o_id, String od_id, Integer deliveryStatus) {
		ModelAndView mav = new ModelAndView("redirect:/orderStatistics");
		DeliveryModel dm = new DeliveryModel();
		dm.setOrder_id(o_id);
		dm.setOrder_detail_id(od_id);
		dm.setDelivery_status(deliveryStatus);
		this.orderService.updateDeliveryCount(dm);
		return mav;
	}
}

