package com.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName(value = "book_stock")
public class BookStock {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer bookId;

    private String stockCode;

    /** 0可借 1已借出 2维护中 3已损坏 4已下架 */
    private Integer status;

    private Integer borrowRecordId;

    private String location;

    private LocalDate purchaseDate;

    private BigDecimal purchasePrice;

    private Integer condition;

    private String remark;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
