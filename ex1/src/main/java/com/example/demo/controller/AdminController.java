package com.example.demo.controller;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

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

import com.example.demo.model.Authorities;
import com.example.demo.model.Book;
import com.example.demo.model.BookCategories;
import com.example.demo.model.BookStatistics;
import com.example.demo.model.Category;
import com.example.demo.model.DeliveryModel;
import com.example.demo.model.Review;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.Users;
import com.example.demo.service.CartService;
import com.example.demo.service.FieldService;
import com.example.demo.service.GoodsService;
import com.example.demo.service.JJimService;
import com.example.demo.service.LoginService;
import com.example.demo.service.OrderService;
import com.example.demo.service.ReviewService;
import com.example.demo.utils.CoverValidator;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class AdminController {
	@Autowired
	private GoodsService goodsService;
    @Autowired
	private CartService cartService;
	@Autowired
	private CoverValidator coverValidator;
	@Autowired
	private FieldService fieldService;
	@Autowired
	private LoginService loginService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private ReviewService reviewservice;
	@Autowired
	private JJimService jjimservice;
	
	private List<Category> categories;
	
    @GetMapping("/getCategories")
    public ResponseEntity<List<Category>> getCategories(@RequestParam("parent_id") String parentId) {
    	//List<Category> categories = goodsService.getCategoriesByParentId(parentId);
    	categories = goodsService.getCategoriesByParentId(parentId);
    	System.out.println("parent_id: " + parentId + " → categories: " + categories);
        
        if (categories.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(categories);
        }
        
        return ResponseEntity.ok(categories);  
        }
    @GetMapping("/getCategoryPath")
    @ResponseBody
    public ResponseEntity<?> getCategoryPath(@RequestParam(value = "cat_id", required = false) String catId) {
        if (catId == null || catId.isEmpty()) {
            return ResponseEntity.badRequest().body("카테고리 ID가 없습니다.");
        }
        String path = goodsService.getCategoryPath(catId);
        if(path == null || path.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body("경로 없음");
        }
        return ResponseEntity.ok(path);

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
	@PostMapping(value = "/manageGoods/search")
	public ModelAndView goodsSearch(String TITLE, @RequestParam(required = false) Integer pageNo) {
		int currentPage = 1;
		if(pageNo != null) currentPage = pageNo;
		List<Book> goodsList = this.goodsService.getGoodsByName(TITLE, pageNo);
		Integer totalCount = this.goodsService.getGoodsCountList(TITLE);
		int pageCount = totalCount / 5;
		if(totalCount % 5 != 0) pageCount++;
		ModelAndView mav = new ModelAndView("admin");
		mav.addObject("PAGES",pageCount);mav.addObject("currentPage",currentPage);
		mav.addObject("GOODS",goodsList);
		mav.addObject("BODY","goodsByTitle.jsp");
		mav.addObject("TITLE",TITLE);
		return mav;
	}
	@GetMapping(value = "/manageGoods/search")
	public ModelAndView goodsSearch1(@RequestParam(required = false) String TITLE, @RequestParam(required = false) Integer pageNo) {
		int currentPage = 1;
	    if (pageNo != null) currentPage = pageNo;
	    
	    List<Book> goodsList = this.goodsService.getGoodsByName(TITLE, pageNo);
	    Integer totalCount = this.goodsService.getGoodsCountList(TITLE);
	    int pageCount = totalCount / 5;
	    if (totalCount % 5 != 0) pageCount++;

	    ModelAndView mav = new ModelAndView("admin");
	    mav.addObject("PAGES", pageCount);
	    mav.addObject("currentPage", currentPage);
	    mav.addObject("GOODS", goodsList);
	    mav.addObject("BODY", "goodsByTitle.jsp");
	    mav.addObject("TITLE", TITLE);
	    return mav;
	}

	@GetMapping(value = "/manageGoods/add")
	public ModelAndView goodsAdd() {
		ModelAndView mav = new ModelAndView("admin");
		mav.addObject(new Book());
		
		
		mav.addObject("CAT",categories);
		mav.addObject("BODY","addGoods.jsp");
		return mav;
	}
	@PostMapping(value = "/manageGoods/insert")
	public ModelAndView goodsInsert(@Valid Book book,
			BindingResult br, HttpSession session, @RequestParam("cat_id") 
			List<String> selectedCat, @RequestParam("authors") String authors) {
		ModelAndView mav = new ModelAndView("admin");
		String loginUser = (String)session.getAttribute("loginUser");
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
		
		this.goodsService.addGoods(book);//책 객체와 cat_id 동시에 불러옴
		
		for(String catId : selectedCat) {
		BookCategories bookcat = new BookCategories();
		bookcat.setIsbn(book.getIsbn());
		bookcat.setCat_id(catId);
		this.goodsService.addInfoCategory(bookcat);
		}
		System.out.println("선택된 카테고리 ID들: " + selectedCat);
		System.out.println("INSERT SQL 실행: " + book);
		Users users = this.loginService.getUserById(loginUser);
		mav.addObject("USER",users);
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
	@GetMapping(value = "/manageGoods/update")
	public ModelAndView updateScreen(Long isbn) {
		ModelAndView mav = new ModelAndView("admin");
		Book goods = this.goodsService.getGoodsDetail(isbn);
		
		List<String> catIds = this.goodsService.getCategoryByIsbn(isbn);
		List<String> categoryPath = new ArrayList<>();
			for(String catId : catIds){
				String path = this.goodsService.getCategoryPath(catId); // 각각 ID별 경로 조회
				categoryPath.add(path);
				}
		mav.addObject(goods);
		mav.addObject("GOODS", goods);
		mav.addObject("catId", catIds);
		mav.addObject("categoryPath", categoryPath);  // 기존 카테고리 경로
		mav.addObject("BODY","goodsDetail.jsp");
		return mav;
	}
	@PostMapping(value = "/manageGoods/update") 
	public ModelAndView updateGoods(@Valid Book book,
				BindingResult br, HttpSession session, @RequestParam("cat_id")
				List<String> selectedCat, @RequestParam("authors")String authors) {
	    System.out.println("도서: " + book);
		ModelAndView mav = new ModelAndView("admin");
		this.coverValidator.validate(book, br);
		if(br.hasErrors()) {
			List<String> exCat = this.goodsService.getCategoryByIsbn(book.getIsbn());
			List<String> catPath = new ArrayList<>();
			for(String catId : exCat) {
				catPath.add(this.goodsService.getCategoryPath(catId));
			}
			mav.addObject("GOODS",book);
			mav.addObject("catIds",exCat);
			mav.addObject("categoryPath",catPath);
			mav.addObject("BODY","goodsDetail.jsp");
			mav.getModel().putAll(br.getModel());
			System.out.println("검증 오류 발생: " + br.getAllErrors());
			return mav;
		}
		System.out.println("수정 대상 도서: " + book);
	    System.out.println("선택된 카테고리 ID 목록: " + selectedCat);
	    System.out.println("저자 정보: " + authors);
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
	        mav.addObject("BODY", "goodsDetail.jsp");
	        mav.addObject("imageError", "앞표지를 업로드해야 합니다.");
	        return mav;
		}
		List<String> existingCats = this.goodsService.getCategoryByIsbn(book.getIsbn());
		System.out.println("📌 기존 카테고리: " + existingCats);
		
		selectedCat = selectedCat.stream()
                .filter(catId -> catId != null && !catId.trim().isEmpty() && !"0".equals(catId))
                .distinct()
                .collect(Collectors.toList());
		List<String> mergedCategories = new ArrayList<>(existingCats); 
		
		mergedCategories.addAll(selectedCat);
	    selectedCat = new ArrayList<>(mergedCategories);
		System.out.println("📌 병합된 카테고리: " + selectedCat);
		List<String> categoriesToDelete = new ArrayList<>();
		for (String catId : existingCats) {
		    if (!selectedCat.contains(catId)) {
		        categoriesToDelete.add(catId);
		    }
		}System.out.println("🗑 삭제할 카테고리: " + categoriesToDelete);
		List<String> categoriesToAdd = new ArrayList<>();
		for (String catId : selectedCat) {
		    if (!existingCats.contains(catId)) {
		        categoriesToAdd.add(catId);
		    }
		} System.out.println("➕ 추가할 카테고리: " + categoriesToAdd);
		for (String catId : categoriesToAdd) {
		    if (!mergedCategories.contains(catId)) {
		        mergedCategories.add(catId);
		    }
		}
		if (!categoriesToDelete.isEmpty()) {
	        goodsService.deleteCategoriesByIsbn(book.getIsbn(), categoriesToDelete);
	    }
	    if (!categoriesToAdd.isEmpty()) {
	        goodsService.updateInfoCategory(book.getIsbn(), mergedCategories);
	    }
		
//		this.goodsService.deleteCategoriesByIsbn(book.getIsbn(), categoriesToDelete); 
//		System.out.println("병합된 카테고리 ID 목록: " + selectedCat);
		
		book.setAuthors(authors);
		this.goodsService.updateGoods(book);
//		this.goodsService.updateInfoCategory(book.getIsbn(), selectedCat);
		mav.addObject("isbnChecked",book.getIsbn());
		mav.addObject("book",new Book());
		mav.addObject("BODY","updateComplete.jsp");
		}
		return mav;
	}
	@PostMapping(value = "/manageGoods/delete")//구현중
	public ModelAndView deleteGoods(Book book, Review review,
			 @RequestParam(value = "authors", required = false) String authors, 
		     @RequestParam(value = "selectedCat", required = false) List<String> selectedCat) {
		ModelAndView mav = new ModelAndView("admin");				
			book.setAuthors(authors);
			Long isbn = book.getIsbn();
			//
			this.fieldService.deletebookCategories(isbn);
			this.jjimservice.deleteJjimisbn(isbn);
			this.orderService.nullisbn(isbn);
			this.reviewservice.deleteReviewisbn(isbn);
			this.goodsService.deleteBookAuthors(isbn);
			this.goodsService.deleteCatInfo(book.getIsbn()); // 기존 데이터 삭제
			
			if (selectedCat != null) {
				for(String catId : selectedCat) {
			        BookCategories bookcat = new BookCategories();
			        bookcat.setIsbn(book.getIsbn());
			        bookcat.setCat_id(catId);
			    }
			}
			this.goodsService.deleteGoods(isbn);
			mav.addObject("book",book);
			mav.addObject("BODY","goodsDeleteResult.jsp");
		
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
	public ModelAndView goOrderStatistics(Integer PAGE, String SELECT, String o_id, String od_id, Integer deliveryStatus) {
	    ModelAndView mav = new ModelAndView("delivStatistics");

	    // 페이지 번호 설정
	    int currentPage = 1;
	    if (PAGE != null) currentPage = PAGE;
	    int start = (currentPage - 1) * 5;
	    int end = ((currentPage - 1) * 5) + 6;    
	    StartEndKey sek = new StartEndKey();
	    sek.setStart(start); sek.setEnd(end);

	    // 배송 상태 수정 처리 (o_id, od_id, deliveryStatus가 있을 경우)
	    if (o_id != null && od_id != null && deliveryStatus != null) {
	        DeliveryModel dm = new DeliveryModel();
	        dm.setOrder_id(o_id);
	        dm.setOrder_detail_id(od_id);
	        dm.setDelivery_status(deliveryStatus);
	        this.orderService.updateDeliveryCount(dm);  // 배송 상태 업데이트
	    }

	    // SELECT 필터에 따른 주문 리스트 조회
	    List<DeliveryModel> orderList = new ArrayList<DeliveryModel>();
	    if (SELECT == null || SELECT.isEmpty()) {
	        orderList = this.orderService.getDeliveryListWithoutStatus(sek);
	        int totalCount = this.orderService.getOrderDetailCount();
	        int pageCount = totalCount / 5;
	        if (totalCount % 5 != 0) pageCount++;
	        mav.addObject("PAGES", pageCount);
	    } else {
	        int status = 0;
	        switch (SELECT) {
	            case "배송 준비중": status = 0; break;
	            case "배송 중": status = 1; break;
	            case "배송 취소": status = 2; break;
	            case "배송 완료": status = 3; break;
	        }
	        sek.setAns(status);
	        orderList = this.orderService.getDeliveryListWithStatus(sek);
	        int totalCount = this.orderService.getOrderDetailCountDeliv(sek.getAns());
	        int pageCount = totalCount / 5;
	        if (totalCount % 5 != 0) pageCount++;
	        mav.addObject("PAGES", pageCount);
	    }

	    mav.addObject("SELECT", SELECT);  // SELECT 값을 유지
	    mav.addObject("currentPage", currentPage);
	    mav.addObject("orderList", orderList);
	    return mav;
	}
	
	@GetMapping(value="/updateUserAdmin")
    public ModelAndView updateUserAdmin(String ID, Integer GD) {
        ModelAndView mav = new ModelAndView("redirect:/goUserDetailAdmin");
        Users users = new Users();
        Authorities ua = new Authorities();
        users.setUser_id(ID); 
        if(GD < 3) {
            users.setGrade(9);
            ua.setUser_id(ID);
            ua.setAuth("ROLE_ADMIN");
        }else {
            Integer totalSum = this.cartService.getUserTotalPriceSum(ID);
            if(totalSum < 150000) {
                users.setGrade(0);
            } else if(totalSum >= 150000 && totalSum < 300000) {
                users.setGrade(1);
            } else {
                users.setGrade(2);
            }
            ua.setUser_id(ID);
            ua.setAuth("ROLE_MEMBER");
        }
        System.out.print(GD);
        this.loginService.updateUserAuth(ua);
        this.loginService.updateUserGrade(users);
        mav.addObject("ID", ID);
        return mav;
    }
}