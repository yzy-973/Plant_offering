package com.example.springboot.entity;

//实体类

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

@Data
public class Account {
    private Integer id;
    private String username;
    private String password;
    private String nickname;
    private String avatarUrl;

    @TableField(exist = false) //字段表——这个字段在表里不存在，不用插入
    private String role;
    @TableField(exist = false)
    private String newPassword;
    @TableField(exist = false)
    private String token;
}
