package com.example.springboot.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.Address;
import com.example.springboot.entity.Book;
import com.example.springboot.entity.BookStock;
import com.example.springboot.entity.BorrowRecord;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.service.IAddressService;
import com.example.springboot.service.IBookService;
import com.example.springboot.service.IBookStockService;
import com.example.springboot.service.IBorrowRecordService;
import com.example.springboot.utils.TokenUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

/**
 * 借阅记录控制器（对应参考项目 OrdersController 逻辑）
 */
@RestController
@RequestMapping("/borrow")
public class BorrowController {

    @Resource
    private IBorrowRecordService borrowRecordService;
    @Resource
    private IBookService bookService;
    @Resource
    private IBookStockService bookStockService;
    @Resource
    private IAddressService addressService;

    @PostMapping
    public Result save(@RequestBody BorrowRecord borrow) {
        if (borrow.getId() == null) {
            Account currentUser = TokenUtils.getCurrentUser();
            if (currentUser == null || currentUser.getId() == null) {
                throw new ServiceException("401", "请先登录");
            }
            Book book = bookService.getById(borrow.getBookId());
            if (book == null) {
                throw new ServiceException("400", "图书不存在");
            }
            if (!StrUtil.equals(book.getStatus(), "可借阅")) {
                throw new ServiceException("400", "图书当前不可借阅");
            }
            BookStock stock = bookStockService.getOne(new LambdaQueryWrapper<BookStock>()
                    .eq(BookStock::getBookId, book.getId())
                    .eq(BookStock::getStatus, 0)
                    .last("limit 1"));
            if (stock == null) {
                throw new ServiceException("400", "暂无可用库存");
            }

            borrow.setNo(DateUtil.format(new Date(), "yyyyMMddHHmmssSSS") + RandomUtil.randomNumbers(6));
            borrow.setBookName(book.getName());
            borrow.setBookImg(book.getImg());
            borrow.setFromUserId(book.getUserId());
            borrow.setToUserId(currentUser.getId());
            borrow.setStockId(stock.getId());
            borrow.setStatus("待审核");
            borrow.setExtendCount(0);
            if (borrow.getAddressId() != null) {
                Address address = addressService.getById(borrow.getAddressId());
                if (address != null) {
                    borrow.setRemark(address.getName() + " " + address.getPhone() + " " + address.getAddress()
                            + (StrUtil.isNotBlank(address.getInfo()) ? (" " + address.getInfo()) : ""));
                }
            }
            borrowRecordService.save(borrow);

            stock.setStatus(1);
            stock.setBorrowRecordId(borrow.getId());
            bookStockService.updateById(stock);

            // 若已无库存则图书标记为已借出
            long available = bookStockService.count(new LambdaQueryWrapper<BookStock>()
                    .eq(BookStock::getBookId, book.getId())
                    .eq(BookStock::getStatus, 0));
            if (available == 0) {
                book.setStatus("已借出");
                bookService.updateById(book);
            }
            book.setBorrowCount((book.getBorrowCount() == null ? 0 : book.getBorrowCount()) + 1);
            bookService.updateById(book);
            return Result.success(true);
        }
        return Result.success(borrowRecordService.saveOrUpdate(borrow));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        return Result.success(borrowRecordService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        return Result.success(borrowRecordService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {
        return Result.success(borrowRecordService.list());
    }

    @GetMapping("/user/{id}")
    public Result findUser(@PathVariable Integer id) {
        LambdaQueryWrapper<BorrowRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(BorrowRecord::getId)
                .eq(BorrowRecord::getFromUserId, id)
                .isNotNull(BorrowRecord::getBorrowerReview)
                .isNotNull(BorrowRecord::getBorrowerRating);
        return Result.success(borrowRecordService.list(wrapper));
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(borrowRecordService.getById(id));
    }

    /** 取消/拒绝借阅（对应 orders/cancel） */
    @GetMapping("/cancel/{id}")
    public Result cancel(@PathVariable Integer id) {
        BorrowRecord record = borrowRecordService.getById(id);
        record.setStatus("拒绝");
        restoreStock(record);
        Book book = bookService.getById(record.getBookId());
        if (book != null) {
            book.setStatus("可借阅");
            bookService.updateById(book);
        }
        borrowRecordService.updateById(record);
        return Result.success();
    }

    /** 书主同意借出（对应 orders/pay 或 shipment） */
    @GetMapping("/approve/{id}")
    public Result approve(@PathVariable Integer id) {
        BorrowRecord record = borrowRecordService.getById(id);
        record.setStatus("借阅中");
        record.setBorrowDate(LocalDateTime.now());
        record.setDueDate(LocalDateTime.now().plusDays(30));
        borrowRecordService.updateById(record);
        return Result.success();
    }

    /** 兼容前端沿用的 pay 路径：同意借出 */
    @GetMapping("/pay/{id}")
    public Result pay(@PathVariable Integer id) {
        return approve(id);
    }

    /** 书主确认交付（对应 orders/shipment） */
    @GetMapping("/shipment/{id}")
    public Result shipment(@PathVariable Integer id) {
        BorrowRecord record = borrowRecordService.getById(id);
        record.setStatus("借阅中");
        if (record.getBorrowDate() == null) {
            record.setBorrowDate(LocalDateTime.now());
            record.setDueDate(LocalDateTime.now().plusDays(30));
        }
        borrowRecordService.updateById(record);
        return Result.success();
    }

    /** 确认归还（对应 orders/receipt） */
    @GetMapping("/receipt/{id}")
    public Result receipt(@PathVariable Integer id) {
        BorrowRecord record = borrowRecordService.getById(id);
        record.setStatus("已归还");
        record.setReturnDate(LocalDateTime.now());
        restoreStock(record);
        Book book = bookService.getById(record.getBookId());
        if (book != null) {
            book.setStatus("可借阅");
            bookService.updateById(book);
        }
        borrowRecordService.updateById(record);
        return Result.success();
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {
        LambdaQueryWrapper<BorrowRecord> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(BorrowRecord::getId);
        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(BorrowRecord::getNo, keyword);
        }
        return Result.success(borrowRecordService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    @GetMapping("/front/page")
    public Result findFrontPage(@RequestParam Integer pageNum,
                                @RequestParam Integer pageSize,
                                @RequestParam(defaultValue = "") String keyword,
                                @RequestParam(defaultValue = "全部") String status,
                                @RequestParam(defaultValue = "我借出的") String flag) {
        LambdaQueryWrapper<BorrowRecord> wrapper = new LambdaQueryWrapper<>();
        Account account = TokenUtils.getCurrentUser();
        wrapper.orderByDesc(BorrowRecord::getCreateTime);
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.like(BorrowRecord::getNo, keyword);
        }
        if (!StrUtil.equals(status, "全部")) {
            wrapper.eq(BorrowRecord::getStatus, status);
        }
        // 兼容旧文案：我卖出的/我买到的
        if (StrUtil.equals(flag, "我借出的") || StrUtil.equals(flag, "我卖出的")) {
            wrapper.eq(BorrowRecord::getFromUserId, account.getId());
        }
        if (StrUtil.equals(flag, "我借入的") || StrUtil.equals(flag, "我买到的")) {
            wrapper.eq(BorrowRecord::getToUserId, account.getId());
        }
        return Result.success(borrowRecordService.page(new Page<>(pageNum, pageSize), wrapper));
    }

    @GetMapping("/comments/{bookId}")
    public Result getCommentsByBookId(@PathVariable Integer bookId) {
        LambdaQueryWrapper<BorrowRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BorrowRecord::getBookId, bookId)
                .isNotNull(BorrowRecord::getBorrowerReview)
                .isNotNull(BorrowRecord::getBorrowerRating)
                .eq(BorrowRecord::getStatus, "已归还")
                .orderByDesc(BorrowRecord::getId);
        return Result.success(borrowRecordService.list(wrapper));
    }

    private void restoreStock(BorrowRecord record) {
        if (record.getStockId() == null) {
            return;
        }
        BookStock stock = bookStockService.getById(record.getStockId());
        if (stock != null) {
            stock.setStatus(0);
            stock.setBorrowRecordId(null);
            bookStockService.updateById(stock);
        }
    }
}
