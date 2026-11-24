package com.example.springboot.controller;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Book;
import com.example.springboot.entity.BorrowRecord;
import com.example.springboot.entity.Collect;
import com.example.springboot.entity.Type;
import com.example.springboot.service.IBookRatingService;
import com.example.springboot.service.IBookService;
import com.example.springboot.service.IBorrowRecordService;
import com.example.springboot.service.ICollectService;
import com.example.springboot.service.ITypeService;
import com.example.springboot.service.IUserService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/echarts")
public class EchartsController {

    @Resource
    private ITypeService typeService;
    @Resource
    private IBookService bookService;
    @Resource
    private IUserService userService;
    @Resource
    private IBorrowRecordService borrowRecordService;
    @Resource
    private ICollectService collectService;
    @Resource
    private IBookRatingService bookRatingService;

    /**
     * 按顶级分类汇总图书数量（含子分类图书）
     * 仅返回有数量的分类，避免 0 扇区挤在一起
     */
    @GetMapping("/count")
    public Result count() {
        List<Type> allTypes = typeService.list();
        Map<Integer, Type> typeById = allTypes.stream()
                .filter(t -> t.getId() != null)
                .collect(Collectors.toMap(Type::getId, t -> t, (a, b) -> a));

        List<Type> parents = allTypes.stream()
                .filter(t -> t.getParentId() == null || t.getParentId() == 0)
                .filter(t -> t.getStatus() == null || t.getStatus() == 1)
                .collect(Collectors.toList());

        Map<Integer, Long> directCount = bookService.list().stream()
                .filter(book -> book.getTypeId() != null)
                .collect(Collectors.groupingBy(Book::getTypeId, Collectors.counting()));

        JSONArray array = new JSONArray();
        for (Type parent : parents) {
            long value = directCount.getOrDefault(parent.getId(), 0L);
            for (Map.Entry<Integer, Long> entry : directCount.entrySet()) {
                Type type = typeById.get(entry.getKey());
                if (type != null && Objects.equals(parent.getId(), type.getParentId())) {
                    value += entry.getValue();
                }
            }
            if (value <= 0) {
                continue;
            }
            JSONObject object = new JSONObject();
            object.set("name", parent.getName());
            object.set("value", value);
            array.add(object);
        }
        return Result.success(array);
    }

    /** 后台首页总览指标 */
    @GetMapping("/overview")
    public Result overview() {
        Map<String, Object> data = new HashMap<>();
        data.put("userCount", userService.count());
        data.put("bookCount", bookService.count());
        data.put("borrowCount", borrowRecordService.count());
        data.put("collectCount", collectService.count());
        data.put("ratingCount", bookRatingService.count());
        data.put("availableCount", bookService.count(new LambdaQueryWrapper<Book>().eq(Book::getStatus, "可借阅")));
        data.put("borrowingCount", borrowRecordService.count(new LambdaQueryWrapper<BorrowRecord>().eq(BorrowRecord::getStatus, "借阅中")));
        data.put("collectBookCount", collectService.count(new LambdaQueryWrapper<Collect>()));
        return Result.success(data);
    }
}
