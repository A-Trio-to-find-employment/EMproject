package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.JJim;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.UserInfo;
import com.example.demo.model.User_pref;
import com.example.demo.model.Users;
import com.example.demo.service.CartService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.FieldService;
import com.example.demo.service.JJimService;
import com.example.demo.service.LoginService;
import com.example.demo.service.PrefService;
import com.example.demo.utils.LoginValidator;
import com.example.demo.utils.MyinfoValidator;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class MypageController {
	@Autowired
	public LoginService loginService;
	@Autowired
	public LoginValidator loginValidator; 
	@Autowired
	public MyinfoValidator myinfoValidator; 
	@Autowired
	private FieldService service;
	@Autowired
	private FieldService fieldService;
	@Autowired
	private CartService cartService;
	@Autowired
	private PrefService prefService;
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private JJimService jjimservice;
	@Autowired
    private PasswordEncoder passwordEncoder;
	
	
	@GetMapping(value = "/secondfa")
	public ModelAndView mypage(HttpSession session,HttpServletRequest request){
		String loginUser = (String)session.getAttribute("loginUser");
		if(loginUser == null) {
			ModelAndView mav = new ModelAndView("loginFail");
			return mav;
		}
		Users users = this.loginService.getUserById(loginUser);
		ModelAndView mav = new ModelAndView("index"); 
		mav.addObject("users", users);
		// 쿠키에서 가져온 ISBN 목록을 처리
				String recentBookIsbnStr = null;
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
				    for (Cookie cookie : cookies) {
				        if (cookie.getName().equals("recentBook")) {
				            recentBookIsbnStr = cookie.getValue();
				            break;
				        }
				    }
				}
				List<Book> recentBooks = new ArrayList<>();
				if (recentBookIsbnStr != null) {
				    try {
				        // 여러 ISBN이 파이프(|)로 구분되어 있다고 가정
				        String[] isbnList = recentBookIsbnStr.split("\\|");  // 파이프 구분자로 분리
				        
				        // 배열을 뒤집어서 최근에 본 책을 먼저 처리
				        for (int i = isbnList.length - 1; i >= 0; i--) {
				            String isbn = isbnList[i].trim();
				            long recentBookIsbn = Long.parseLong(isbn);
				            Book recentBook = this.fieldService.getBookDetail(recentBookIsbn);
				            if (recentBook != null) {
				                recentBooks.add(recentBook);
				            }
				        }
				        mav.addObject("recentBooks", recentBooks);
				    } catch (NumberFormatException e) {
				        System.out.println("잘못된 ISBN 값: " + recentBookIsbnStr);
				    }
				}
				mav.addObject("BODY","secondfa.jsp");
		return mav;
	}
	@PostMapping(value = "/secondfa")
	public ModelAndView secondfa(
			@RequestParam("username") String username, 
            @RequestParam("password") String password, 
            HttpSession session, Users users, BindingResult br,
            HttpServletRequest request) {
			ModelAndView mav = new ModelAndView("myArea");
	        // DB에서 아이디에 해당하는 비밀번호 가져오기
	        String getPassword = this.loginService.getPasswordByUsername(username);

	        // 비밀번호 비교 (암호화된 비밀번호와 일치하는지 확인)
	        if (getPassword != null && passwordEncoder.matches(password, getPassword)) {
	            session.setAttribute("TWO_FACTOR_VERIFIED", true); // 2차 인증 완료 상태 저장
	            mav.setViewName("redirect:/secondfaSuccess"); // 성공 페이지로 이동
	        } else {
	            mav.setViewName("redirect:/secondfa?error=true"); // 실패 시 다시 2차 인증 페이지로
	        }
	        mav.addObject("BODY","secondfa.jsp");
		// 쿠키에서 가져온 ISBN 목록을 처리
				String recentBookIsbnStr = null;
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
				    for (Cookie cookie : cookies) {
				        if (cookie.getName().equals("recentBook")) {
				            recentBookIsbnStr = cookie.getValue();
				            break;
				        }
				    }
				}
				List<Book> recentBooks = new ArrayList<>();
				if (recentBookIsbnStr != null) {
				    try {
				        // 여러 ISBN이 파이프(|)로 구분되어 있다고 가정
				        String[] isbnList = recentBookIsbnStr.split("\\|");  // 파이프 구분자로 분리
				        
				        // 배열을 뒤집어서 최근에 본 책을 먼저 처리
				        for (int i = isbnList.length - 1; i >= 0; i--) {
				            String isbn = isbnList[i].trim();
				            long recentBookIsbn = Long.parseLong(isbn);
				            Book recentBook = this.fieldService.getBookDetail(recentBookIsbn);
				            if (recentBook != null) {
				                recentBooks.add(recentBook);
				            }
				        }

				        // 뷰에 전달
				        mav.addObject("recentBooks", recentBooks);
				    } catch (NumberFormatException e) {
				        System.out.println("잘못된 ISBN 값: " + recentBookIsbnStr);
				    }
				}
				return mav;
			}
	@RequestMapping(value = "/secondfaSuccess")
	public ModelAndView secondfaSuccess() {
		ModelAndView mav = new ModelAndView("myArea");
		mav.addObject("BODY","secondfaSuccess.jsp");
		return mav;
	}
	@GetMapping(value = "/myInfo")
	public ModelAndView myInfo(HttpSession session,HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("myArea");
		// 쿠키에서 가져온 ISBN 목록을 처리
				String recentBookIsbnStr = null;
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
				    for (Cookie cookie : cookies) {
				        if (cookie.getName().equals("recentBook")) {
				            recentBookIsbnStr = cookie.getValue();
				            break;
				        }
				    }
				}

				List<Book> recentBooks = new ArrayList<>();
				if (recentBookIsbnStr != null) {
				    try {
				        // 여러 ISBN이 파이프(|)로 구분되어 있다고 가정
				        String[] isbnList = recentBookIsbnStr.split("\\|");  // 파이프 구분자로 분리
				        
				        // 배열을 뒤집어서 최근에 본 책을 먼저 처리
				        for (int i = isbnList.length - 1; i >= 0; i--) {
				            String isbn = isbnList[i].trim();
				            long recentBookIsbn = Long.parseLong(isbn);
				            Book recentBook = this.fieldService.getBookDetail(recentBookIsbn);
				            if (recentBook != null) {
				                recentBooks.add(recentBook);
				            }
				        }

				        // 뷰에 전달
				        mav.addObject("recentBooks", recentBooks);
				    } catch (NumberFormatException e) {
				        System.out.println("❌ 잘못된 ISBN 값: " + recentBookIsbnStr);
				    }
				}
		String loginUser = (String)session.getAttribute("loginUser");
		if(loginUser == null) {
			mav.addObject("error", "로그인을 한 후 다시 시도해주세요.");
			return mav;
		}
		UserInfo userInfo = this.loginService.getUserInfoById(loginUser);
		if(userInfo != null) {
			mav.addObject("userInfo",userInfo);
			mav.addObject("user_id", userInfo.getUser_id());
		}else {
			mav.addObject("error", "회원 정보를 찾을 수 없습니다.");
		}
		mav.addObject("BODY","mypage.jsp");
		return mav;
	}
	@PostMapping(value = "/mypage/modify")
	public ModelAndView modify(@Valid UserInfo userInfo, BindingResult br) {
		ModelAndView mav = new ModelAndView("myArea");
		//this.myinfoValidator.validate(userInfo, br);
		
		System.out.println("user)name:"+userInfo.getUser_name());
		System.out.println("address:"+userInfo.getAddress());
		System.out.println("address detail:"+userInfo.getAddress_detail());
		System.out.println("Izipcode:"+userInfo.getZipcode());
		System.out.println("email:"+userInfo.getEmail());
		System.out.println("birth:"+userInfo.getBirth());
		System.out.println("phone:"+userInfo.getPhone());
		
		if(br.hasErrors()) {
			mav.addObject("errors", br.getAllErrors());
			mav.getModel().putAll(br.getModel());
			mav.addObject("userInfo", userInfo);
			mav.addObject("BODY","mypage.jsp");
			System.out.println("### has Errors !!!");
			return mav;
		}
		this.loginService.modifyUser(userInfo);
//		Users newuser = this.loginService.getUser(users);
		UserInfo newuser = this.loginService.getUserInfoById(userInfo.getUser_id());
		if(newuser != null) {
			mav.addObject("userInfo",newuser);
			mav.addObject("userInfo",userInfo);
			mav.addObject("BODY","myInfoupdate.jsp");
		}else {
			mav.addObject("error", "회원 정보 수정 실패");
		}
		return mav;
	}
	@GetMapping("/jjimlist")
	public ModelAndView fields(Integer PAGE_NUM, String cat_id, String sort, 
	                            Long BOOKID, String action, String action1, HttpSession session,HttpServletRequest request) {
	    String loginUser = (String) session.getAttribute("loginUser");

	    int currentPage = 1;
	    // 페이지 번호가 null이 아니면 currentPage 설정
	    if (PAGE_NUM != null) {
	    	currentPage = PAGE_NUM;
	    }

	    // 사용자의 찜 갯수 조회
	    int count = this.jjimservice.getjjimCount(loginUser);  // 갯수를 검색
	    int startRow = 0;
	    int endRow = 0;
	    int totalPageCount = 0;

	    if(count > 0) {
	        totalPageCount = count / 5;  // 페이지 수 계산
	        if(count % 5 != 0) totalPageCount++;  // 나머지가 있으면 페이지 수 +1

	        // startRow는 currentPage에 맞게 계산, 첫 페이지는 0, 두 번째 페이지는 5
	        startRow = (currentPage - 1) * 5;

	        // endRow는 startRow + 5로 설정, 단 endRow가 count보다 클 수 있으므로 count로 제한
	        endRow = startRow + 5;

	        if(endRow > count) {
	            endRow = count;
	        }
	    }
        System.out.println(startRow);
        System.out.println(endRow);
        System.out.println(currentPage);
	    // StartEndKey 설정
	    StartEndKey se = new StartEndKey();
	    se.setStart(startRow);
	    se.setEnd(endRow);
	    se.setUser_id(loginUser);

	    // 찜 목록을 페이지 범위에 맞게 가져옴
	    List<Book> bookLists = jjimservice.getorderByjjim(se);
	    ModelAndView mav1 = new ModelAndView("jjimlist");

	    // 찜 상태 변경 처리
	    if (action1 != null) {
	        // 로그인한 사용자가 없으면 로그인 페이지로 리다이렉트
	        if (loginUser == null) {
	            ModelAndView loginFailMav = new ModelAndView("loginFail");
	            return loginFailMav;
	        }
	        // JJim 객체 생성 및 값 설정
	        JJim jjim = new JJim();
	        jjim.setUser_id(loginUser);
	        jjim.setIsbn(BOOKID);

	        // 찜 상태를 확인하고 변경
	        if (action1.equals("jjim")) {
	            boolean isLiked = jjimservice.isBookLiked(jjim) > 0;  // 찜 상태 확인

	            if (isLiked) {
	                jjimservice.deleteJjim(jjim); // 찜 삭제
	            } else {
	                jjimservice.insertjjim(jjim); // 찜 추가
	            }
	        }
	    }
	    // 찜 상태 및 찜한 사람 수 계산
	    JJim jjim = new JJim();
	    jjim.setUser_id(loginUser);
	    for (Book book : bookLists) {
	        jjim.setIsbn(book.getIsbn());
	        boolean isLiked = jjimservice.isBookLiked(jjim) > 0;
	        book.setLiked(isLiked);

	        int likeCount = jjimservice.getLikeCount(book.getIsbn());
	        book.setLikecount(likeCount);
	    }
	 // 쿠키에서 가져온 ISBN 목록을 처리
	 		String recentBookIsbnStr = null;
	 		Cookie[] cookies = request.getCookies();
	 		if (cookies != null) {
	 		    for (Cookie cookie : cookies) {
	 		        if (cookie.getName().equals("recentBook")) {
	 		            recentBookIsbnStr = cookie.getValue();
	 		            break;
	 		        }
	 		    }
	 		}

	 		List<Book> recentBooks = new ArrayList<>();
	 		if (recentBookIsbnStr != null) {
	 		    try {
	 		        // 여러 ISBN이 파이프(|)로 구분되어 있다고 가정
	 		        String[] isbnList = recentBookIsbnStr.split("\\|");  // 파이프 구분자로 분리
	 		        
	 		        // 배열을 뒤집어서 최근에 본 책을 먼저 처리
	 		        for (int i = isbnList.length - 1; i >= 0; i--) {
	 		            String isbn = isbnList[i].trim();
	 		            long recentBookIsbn = Long.parseLong(isbn);
	 		            Book recentBook = this.fieldService.getBookDetail(recentBookIsbn);
	 		            if (recentBook != null) {
	 		                recentBooks.add(recentBook);
	 		            }
	 		        }
	 		        // 뷰에 전달
	 		        mav1.addObject("recentBooks", recentBooks);
	 		    } catch (NumberFormatException e) {
	 		        System.out.println("❌ 잘못된 ISBN 값: " + recentBookIsbnStr);
	 		    }
	 		}
	    // 페이지네이션 및 모델 데이터 설정	    
	    mav1.addObject("START", startRow);
	    mav1.addObject("END", endRow);
	    mav1.addObject("TOTAL", count);
	    mav1.addObject("currentPage", currentPage);
	    mav1.addObject("pageCount", totalPageCount); 
	    mav1.addObject("bookList", bookLists); // 도서 목록 전달
	    mav1.addObject("loginUser", loginUser); // 로그인 사용자 정보 전달
	    return mav1;
	}
	@PostMapping("/removeJjim")
	public ModelAndView removeJjim(String userId, Long isbn, HttpSession session) {
	    ModelAndView mav = new ModelAndView();
	    JJim jjim = new JJim();
	    jjim.setIsbn(isbn);
	    jjim.setUser_id(userId);

	    // 찜 삭제
	    this.jjimservice.deleteJjim(jjim);

	    // 찜을 삭제했으므로 카테고리 선호도 점수도 감소
	    List<String> catList = this.categoryService.getCatIdFromIsbn(isbn);  // 해당 책의 카테고리 목록
	    for (String catId : catList) {
	        User_pref up = new User_pref();
	        up.setUser_id(userId);
	        up.setCat_id(catId);
	        User_pref testUp = this.prefService.getUserCatIdByCat(up);

	        if (testUp != null && testUp.getPref_score() > 0) {
	            // 찜을 제거했으므로 점수 감소
	            Integer score = testUp.getPref_score() - 1;  // 점수를 1 감소
	            up.setPref_score(score);
	            this.prefService.updateScore(up);
	        }
	    }
	    // 리다이렉트하면서 URL에 alert 파라미터 추가
	    mav.setViewName("redirect:/jjimlist?alert=true");
	    return mav;
	}

}