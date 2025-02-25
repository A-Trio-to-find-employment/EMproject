package com.example.demo.utils;

import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.model.Book;
@Service
public class CoverValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		return Book.class.isAssignableFrom(clazz);
	}

	    @Override
	    public void validate(Object target, Errors errors) {
	        Book book = (Book) target;
	        MultipartFile coverImage = book.getCoverImage();

	        if (coverImage == null || coverImage.isEmpty()) {
	            errors.rejectValue("coverImage", "error.coverImage.empty");
	        }
	    }

}
