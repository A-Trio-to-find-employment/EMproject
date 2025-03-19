package com.example.demo.controller;



import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Users;
import com.example.demo.service.CategoryService;
import com.example.demo.service.CouponService;
import com.example.demo.service.EventService;
import com.example.demo.service.FieldService;
import com.example.demo.service.LoginService;
import com.example.demo.service.PrefService;
import com.example.demo.service.PreferenceService;
import com.example.demo.service.WelcomeService;
import com.example.demo.utils.LoginValidator;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	@Autowired
	public LoginService loginService;
	@Autowired
	public LoginValidator loginValidator;
	@Autowired
	public EventService eventService;
	@Autowired
	public CouponService couponService;
	@Autowired
	public CategoryService categoryService;
	@Autowired
	public PrefService prefService;
	@Autowired
	public PreferenceService preferenceService;
	@Autowired
	public FieldService fieldService;
	@Autowired
	public WelcomeService welcomeService;

	@GetMapping(value = "/login")
	public ModelAndView login(Users user,HttpSession session) {
		ModelAndView mav = new ModelAndView("redirect:/index");
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    
		if (authentication != null) {
		    Object principal = authentication.getPrincipal();
		    String userId = "";
		    String password = "";

		    if (principal instanceof UserDetails) {
		        // 인증된 사용자가 UserDetails를 구현하고 있다면, 아이디와 비밀번호를 가져옴
		        UserDetails userDetails = (UserDetails) principal;
		        userId = userDetails.getUsername(); // 아이디
		        password = userDetails.getPassword(); // 비밀번호
		    } else {
		        // 인증된 사용자가 UserDetails를 사용하지 않는 경우 (기본 사용자)
		        userId = principal.toString(); // 예: "anonymousUser"와 같은 값이 나올 수 있음
		    }

		    // 사용자 아이디와 비밀번호를 콘솔에 출력
		    System.out.println("현재 로그인한 사용자 아이디: " + userId);
		    System.out.println("현재 로그인한 사용자 비밀번호: " + password);
		    
		    // imagebbs.setWriter(userId); // 작성자에 계정 설정
		    session.setAttribute("loginUser", userId); // 세션에 로그인 사용자 설정
		    session.setAttribute("password", password); // 세션에 로그인 사용자 설정
		}
		
		return mav;
	}
	@RequestMapping("/login/securityLogin.html")
	public ModelAndView securityLoginFrom() {
		ModelAndView mav = new ModelAndView("index");
		mav.addObject(new Users());
		mav.addObject("BODY","securitylogin.jsp");
		return mav;
	}
	
	}
