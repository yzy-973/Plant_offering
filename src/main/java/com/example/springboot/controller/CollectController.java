package com.example.springboot.controller;

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

@RestController
@RequestMapping("/collect")
public class CollectController {

    @Resource
    private ICollectService collectService;
    @Resource
    private IBookService bookService;

    @PostMapping
    public Result save(@RequestBody Collect collect) {
        Account currentUser = TokenUtils.getCurrentUser();
        Integer bookId = collect.getBookId() != null ? collect.getBookId() : collect.getItemId();
        collect.setUserId(currentUser.getId());
        collect.setBookId(bookId);
        try {
            collectService.save(collect);
            increaseFavorite(bookId);
        } catch (Exception e) {
            LambdaQueryWrapper<Collect> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Collect::getUserId, currentUser.getId());
            wrapper.eq(Collect::getBookId, bookId);
            collectService.remove(wrapper);
            decreaseFavorite(bookId);
            return Result.error("605", "已取消收藏");
        }
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        Account currentUser = TokenUtils.getCurrentUser();
        LambdaQueryWrapper<Collect> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Collect::getUserId, currentUser.getId());
        wrapper.eq(Collect::getBookId, id);
        boolean removed = collectService.remove(wrapper);
        if (removed) {
            decreaseFavorite(id);
        }
        return Result.success();
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        return Result.success(collectService.removeByIds(ids));
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum, @RequestParam Integer pageSize, @RequestParam(defaultValue = "") String keyword) {
        LambdaQueryWrapper<Collect> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(Collect::getId);
        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Collect::getUserId, keyword);
        }
        return Result.success(collectService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    private void increaseFavorite(Integer bookId) {
        if (bookId == null) {
            return;
        }
        Book book = bookService.getById(bookId);
        if (book != null) {
            book.setFavoriteCount((book.getFavoriteCount() == null ? 0 : book.getFavoriteCount()) + 1);
            bookService.updateById(book);
        }
    }

    private void decreaseFavorite(Integer bookId) {
        if (bookId == null) {
            return;
        }
        Book book = bookService.getById(bookId);
        if (book != null) {
            int count = book.getFavoriteCount() == null ? 0 : book.getFavoriteCount();
            book.setFavoriteCount(Math.max(0, count - 1));
            bookService.updateById(book);
        }
    }
}
