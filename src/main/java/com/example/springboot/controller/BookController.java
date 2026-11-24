package com.example.springboot.controller;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.Book;
import com.example.springboot.entity.Collect;
import com.example.springboot.service.IBookService;
import com.example.springboot.service.ICollectService;
import com.example.springboot.utils.TokenUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 图书控制器（对应参考项目 GoodsController 逻辑）
 */
@RestController
@RequestMapping("/book")
public class BookController {

    @Resource
    private IBookService bookService;
    @Resource
    private ICollectService collectService;

    @PostMapping
    public Result save(@RequestBody Book book) {
        if (book.getId() == null) {
            book.setUserId(TokenUtils.getCurrentUser().getId());
            book.setStatus("可借阅");
            book.setViewCount(0);
            book.setFavoriteCount(0);
            book.setBorrowCount(0);
        }
        return Result.success(bookService.saveOrUpdate(book));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        return Result.success(bookService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        return Result.success(bookService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {
        return Result.success(bookService.list());
    }

    @GetMapping("/user/{id}")
    public Result findByUser(@PathVariable Integer id) {
        LambdaQueryWrapper<Book> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(Book::getId).eq(Book::getUserId, id);
        return Result.success(bookService.list(wrapper));
    }

    @GetMapping("/front")
    public Result findFront() {
        LambdaQueryWrapper<Book> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(Book::getViewCount)
                .eq(Book::getStatus, "可借阅");
        return Result.success(bookService.list(wrapper.last("LIMIT 12")));
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        Book book = bookService.getById(id);
        if (book == null) {
            return Result.error("404", "图书不存在");
        }
        book.setViewCount((book.getViewCount() == null ? 0 : book.getViewCount()) + 1);
        book.setIsCollected(false);
        Account currentUser = TokenUtils.getCurrentUser();
        if (ObjectUtil.isNotNull(currentUser) && currentUser.getId() != null) {
            LambdaQueryWrapper<Collect> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Collect::getBookId, id).eq(Collect::getUserId, currentUser.getId());
            book.setIsCollected(collectService.getOne(wrapper) != null);
        }
        bookService.updateById(book);
        return Result.success(book);
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {
        LambdaQueryWrapper<Book> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(Book::getId);
        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Book::getName, keyword);
        }
        return Result.success(bookService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    @GetMapping("/collect/page")
    public Result findCollectPage(@RequestParam(defaultValue = "") String keyword,
                                  @RequestParam Integer pageNum,
                                  @RequestParam Integer pageSize) {
        LambdaQueryWrapper<Collect> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Collect::getUserId, TokenUtils.getCurrentUser().getId());
        List<Integer> ids = collectService.list(wrapper).stream()
                .map(Collect::getBookId)
                .collect(Collectors.toList());
        if (CollectionUtil.isEmpty(ids)) {
            return Result.success(new Page<>(pageNum, pageSize));
        }
        LambdaQueryWrapper<Book> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StrUtil.isNotEmpty(keyword), Book::getName, keyword);
        queryWrapper.in(Book::getId, ids);
        return Result.success(bookService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    @GetMapping("/front/page")
    public Result findFrontPage(@RequestParam(defaultValue = "") String keyword,
                                @RequestParam(defaultValue = "0") Integer typeId,
                                @RequestParam(defaultValue = "all") String sortBy,
                                @RequestParam Integer pageNum,
                                @RequestParam Integer pageSize) {
        LambdaQueryWrapper<Book> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Book::getStatus, "可借阅");
        if (StrUtil.equals(sortBy, "all")) {
            queryWrapper.orderByAsc(Book::getId);
        } else if (StrUtil.equals(sortBy, "new")) {
            queryWrapper.orderByDesc(Book::getCreateTime);
        } else if (StrUtil.equals(sortBy, "recommend") || StrUtil.equals(sortBy, "hot")) {
            queryWrapper.orderByDesc(Book::getViewCount);
        } else if (StrUtil.equals(sortBy, "collect") || StrUtil.equals(sortBy, "favorite")) {
            queryWrapper.orderByDesc(Book::getFavoriteCount);
        } else {
            queryWrapper.orderByDesc(Book::getId);
        }
        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Book::getName, keyword);
        }
        if (typeId != null && typeId != 0) {
            queryWrapper.and(w -> w.eq(Book::getTypeId, typeId)
                    .or()
                    .inSql(Book::getTypeId, "select id from book_type where parent_id = " + typeId));
        }
        return Result.success(bookService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    @GetMapping("/rank")
    public Result rank(@RequestParam(defaultValue = "recommend") String type,
                       @RequestParam(defaultValue = "10") Integer limit) {
        LambdaQueryWrapper<Book> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Book::getStatus, "可借阅");
        if ("collect".equals(type) || "favorite".equals(type)) {
            wrapper.orderByDesc(Book::getFavoriteCount).orderByDesc(Book::getViewCount);
        } else {
            wrapper.orderByDesc(Book::getViewCount).orderByDesc(Book::getFavoriteCount);
        }
        wrapper.last("limit " + Math.min(Math.max(limit, 1), 50));
        return Result.success(bookService.list(wrapper));
    }
}
