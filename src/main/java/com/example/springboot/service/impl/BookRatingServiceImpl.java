package com.example.springboot.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.BookRating;
import com.example.springboot.mapper.BookRatingMapper;
import com.example.springboot.service.IBookRatingService;
import org.springframework.stereotype.Service;

@Service
public class BookRatingServiceImpl extends ServiceImpl<BookRatingMapper, BookRating> implements IBookRatingService {
}
