package com.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName(value = "book")
public class Book {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private String name;

    private String img;

    private String imgList;

    private Integer typeId;

    private String author;

    private String publisher;

    private String isbn;

    private Integer publishYear;

    private String content;

    private String place;

    private Integer userId;

    private Integer viewCount;

    /** 可借阅 / 已借出 / 维护中 / 已下架 */
    private String status;

    private String quality;

    private String publishDate;

    private Integer borrowCount;

    private Integer favoriteCount;

    private BigDecimal avgRating;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableField(exist = false)
    private Boolean isCollected;

    @TableField(exist = false)
    private Double price;
}
