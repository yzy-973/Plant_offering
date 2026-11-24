package com.example.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.User;

import java.util.List;

//服务类
public interface IUserService extends IService<User> {

    Account login(Account account);

    //不需要返回，只需要传给数据库
    void register(Account account);

    void updatePassword(Account account);

    // ========== 封禁/解封功能 ==========
    Result updateStatus(Integer id, Integer status);
    Result batchUpdateStatus(List<Integer> ids, Integer status);
}