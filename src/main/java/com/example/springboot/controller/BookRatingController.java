package com.example.springboot.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.Book;
import com.example.springboot.entity.BookRating;
import com.example.springboot.entity.User;
import com.example.springboot.service.IBookRatingService;
import com.example.springboot.service.IBookService;
import com.example.springboot.service.IUserService;
import com.example.springboot.utils.TokenUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/rating")
public class BookRatingController {

    @Resource
    private IBookRatingService bookRatingService;
    @Resource
    private IBookService bookService;
    @Resource
    private IUserService userService;

    @GetMapping("/book/{bookId}")
    public Result listByBook(@PathVariable Integer bookId) {
        LambdaQueryWrapper<BookRating> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookRating::getBookId, bookId).orderByDesc(BookRating::getCreateTime);
        List<BookRating> list = bookRatingService.list(wrapper);
        if (list.isEmpty()) {
            return Result.success(list);
        }
        List<Integer> userIds = list.stream().map(BookRating::getUserId).distinct().collect(Collectors.toList());
        Map<Integer, User> userMap = userService.listByIds(userIds).stream()
                .collect(Collectors.toMap(User::getId, u -> u, (a, b) -> a));
        for (BookRating rating : list) {
            User user = userMap.get(rating.getUserId());
            if (user != null) {
                rating.setNickname(user.getNickname());
                rating.setAvatarUrl(user.getAvatarUrl());
            }
        }
        return Result.success(list);
    }

    @GetMapping("/mine/{bookId}")
    public Result myRating(@PathVariable Integer bookId) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (currentUser == null || currentUser.getId() == null) {
            return Result.success(null);
        }
        LambdaQueryWrapper<BookRating> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookRating::getBookId, bookId).eq(BookRating::getUserId, currentUser.getId());
        return Result.success(bookRatingService.getOne(wrapper));
    }

    @PostMapping
    public Result save(@RequestBody BookRating rating) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (currentUser == null || currentUser.getId() == null) {
            return Result.error("401", "请先登录");
        }
        if (rating.getBookId() == null) {
            return Result.error("400", "图书不能为空");
        }
        if (rating.getScore() == null || rating.getScore() < 1 || rating.getScore() > 5) {
            return Result.error("400", "请选择1-5星评分");
        }
        if (StrUtil.isBlank(rating.getComment())) {
            return Result.error("400", "请填写评价内容");
        }

        Book book = bookService.getById(rating.getBookId());
        if (book == null) {
            return Result.error("404", "图书不存在");
        }

        LambdaQueryWrapper<BookRating> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookRating::getBookId, rating.getBookId())
                .eq(BookRating::getUserId, currentUser.getId());
        BookRating exist = bookRatingService.getOne(wrapper);
        if (exist != null) {
            exist.setScore(rating.getScore());
            exist.setComment(rating.getComment().trim());
            bookRatingService.updateById(exist);
            refreshAvgRating(rating.getBookId());
            return Result.success(exist);
        }

        rating.setUserId(currentUser.getId());
        rating.setComment(rating.getComment().trim());
        bookRatingService.save(rating);
        refreshAvgRating(rating.getBookId());
        return Result.success(rating);
    }

    private void refreshAvgRating(Integer bookId) {
        LambdaQueryWrapper<BookRating> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BookRating::getBookId, bookId);
        List<BookRating> list = bookRatingService.list(wrapper);
        Book book = bookService.getById(bookId);
        if (book == null) {
            return;
        }
        if (list.isEmpty()) {
            book.setAvgRating(BigDecimal.ZERO);
        } else {
            double avg = list.stream().mapToInt(BookRating::getScore).average().orElse(0);
            book.setAvgRating(BigDecimal.valueOf(avg).setScale(2, RoundingMode.HALF_UP));
        }
        bookService.updateById(book);
    }
}
