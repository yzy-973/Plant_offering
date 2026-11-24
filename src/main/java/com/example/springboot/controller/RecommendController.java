package com.example.springboot.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.Book;
import com.example.springboot.entity.RecommendSlot;
import com.example.springboot.service.IBookService;
import com.example.springboot.service.IRecommendSlotService;
import com.example.springboot.utils.TokenUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/recommend")
public class RecommendController {

    private static final String USER_SLOT_CODE = "user_recommend";
    private static final String USER_SLOT_NAME = "用户推荐";

    @Resource
    private IRecommendSlotService recommendSlotService;
    @Resource
    private IBookService bookService;

    /** 我已推荐的图书（推荐管理页仅展示已推荐项） */
    @GetMapping("/my")
    public Result myBooks(@RequestParam(defaultValue = "") String keyword) {
        Account currentUser = TokenUtils.getCurrentUser();
        LambdaQueryWrapper<Book> bookWrapper = new LambdaQueryWrapper<>();
        bookWrapper.eq(Book::getUserId, currentUser.getId()).orderByDesc(Book::getId);
        if (StrUtil.isNotBlank(keyword)) {
            bookWrapper.like(Book::getName, keyword);
        }
        List<Book> books = bookService.list(bookWrapper);
        if (books.isEmpty()) {
            return Result.success(new ArrayList<>());
        }

        List<Integer> bookIds = books.stream().map(Book::getId).collect(Collectors.toList());
        LambdaQueryWrapper<RecommendSlot> slotWrapper = new LambdaQueryWrapper<>();
        slotWrapper.in(RecommendSlot::getBookId, bookIds)
                .eq(RecommendSlot::getSlotCode, USER_SLOT_CODE)
                .eq(RecommendSlot::getStatus, 1);
        Map<Integer, RecommendSlot> slotMap = recommendSlotService.list(slotWrapper).stream()
                .collect(Collectors.toMap(RecommendSlot::getBookId, s -> s, (a, b) -> a));

        List<Map<String, Object>> result = new ArrayList<>();
        for (Book book : books) {
            RecommendSlot slot = slotMap.get(book.getId());
            if (slot == null) {
                continue;
            }
            Map<String, Object> row = new HashMap<>();
            row.put("id", book.getId());
            row.put("name", book.getName());
            row.put("img", book.getImg());
            row.put("status", book.getStatus());
            row.put("author", book.getAuthor());
            row.put("recommended", true);
            row.put("slotId", slot.getId());
            result.add(row);
        }
        return Result.success(result);
    }

    /** 将自己的图书加入推荐位 */
    @PostMapping
    public Result add(@RequestBody RecommendSlot body) {
        Account currentUser = TokenUtils.getCurrentUser();
        Integer bookId = body.getBookId();
        if (bookId == null) {
            return Result.error("400", "请选择图书");
        }
        Book book = bookService.getById(bookId);
        if (book == null || !currentUser.getId().equals(book.getUserId())) {
            return Result.error("403", "只能推荐自己发布的图书");
        }

        LambdaQueryWrapper<RecommendSlot> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RecommendSlot::getBookId, bookId)
                .eq(RecommendSlot::getSlotCode, USER_SLOT_CODE);
        RecommendSlot exist = recommendSlotService.getOne(wrapper);
        if (exist != null) {
            exist.setStatus(1);
            exist.setRemark(body.getRemark());
            recommendSlotService.updateById(exist);
            return Result.success(exist);
        }

        RecommendSlot slot = new RecommendSlot();
        slot.setBookId(bookId);
        slot.setSlotCode(USER_SLOT_CODE);
        slot.setSlotName(USER_SLOT_NAME);
        slot.setSortOrder(0);
        slot.setStatus(1);
        slot.setRemark(body.getRemark());
        recommendSlotService.save(slot);
        return Result.success(slot);
    }

    /** 取消推荐（按图书ID） */
    @DeleteMapping("/book/{bookId}")
    public Result cancelByBook(@PathVariable Integer bookId) {
        Account currentUser = TokenUtils.getCurrentUser();
        Book book = bookService.getById(bookId);
        if (book == null || !currentUser.getId().equals(book.getUserId())) {
            return Result.error("403", "只能管理自己发布的图书");
        }
        LambdaQueryWrapper<RecommendSlot> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RecommendSlot::getBookId, bookId)
                .eq(RecommendSlot::getSlotCode, USER_SLOT_CODE);
        recommendSlotService.remove(wrapper);
        return Result.success();
    }
}
