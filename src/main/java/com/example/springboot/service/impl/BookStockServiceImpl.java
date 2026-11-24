package com.example.springboot.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.BookStock;
import com.example.springboot.mapper.BookStockMapper;
import com.example.springboot.service.IBookStockService;
import org.springframework.stereotype.Service;

@Service
public class BookStockServiceImpl extends ServiceImpl<BookStockMapper, BookStock> implements IBookStockService {
}
