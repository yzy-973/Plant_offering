package com.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@EqualsAndHashCode(callSuper = true)
@Data
@TableName(value = "sys_user")
public class User extends Account {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private String username;

    private String password;

    private String nickname;

    private String avatarUrl;

    private String email;

    private String phone;

    private Integer status;

    private Integer creditScore;

    private Integer borrowCount;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
