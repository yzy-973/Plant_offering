package com.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName(value = "book_rating")
public class BookRating {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer bookId;

    private Integer userId;

    /** 1-5 分 */
    private Integer score;

    private String comment;

    private LocalDateTime createTime;

    @TableField(exist = false)
    private String nickname;

    @TableField(exist = false)
    private String avatarUrl;
}
