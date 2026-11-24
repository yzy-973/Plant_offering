package com.example.springboot.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Book;
import com.example.springboot.entity.Type;
import com.example.springboot.service.IBookService;
import com.example.springboot.service.ITypeService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/type")
public class TypeController {

    @Resource
    private ITypeService typeService;
    @Resource
    private IBookService bookService;

    @PostMapping
    public Result save(@RequestBody Type type) {
        return Result.success(typeService.saveOrUpdate(type));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        return Result.success(typeService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        return Result.success(typeService.removeByIds(ids));
    }

    @GetMapping("/front")
    public Result findFront() {
        LambdaQueryWrapper<Type> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Type::getStatus, 1)
                .eq(Type::getIsRecommend, 1)
                .eq(Type::getParentId, 0)
                .orderByAsc(Type::getSortOrder)
                .last("limit 4");
        List<Type> typeList = typeService.list(wrapper);
        for (Type type : typeList) {
            LambdaQueryWrapper<Book> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.and(w -> w.eq(Book::getTypeId, type.getId())
                            .or()
                            .inSql(Book::getTypeId, "select id from book_type where parent_id = " + type.getId()))
                    .eq(Book::getStatus, "可借阅")
                    .orderByDesc(Book::getViewCount)
                    .last("limit 3");
            type.setBookList(bookService.list(queryWrapper));
        }
        return Result.success(typeList);
    }

    // 查询所有（与参考项目一致：后台/下拉不额外过滤）
    @GetMapping
    public Result findAll() {
        return Result.success(typeService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(typeService.getById(id));
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {
        LambdaQueryWrapper<Type> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(Type::getId);
        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Type::getName, keyword);
        }
        return Result.success(typeService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }
}
