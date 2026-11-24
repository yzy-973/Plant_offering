package com.example.springboot.service.impl;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.example.springboot.common.Constants;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.User;
import com.example.springboot.mapper.UserMapper;
import com.example.springboot.service.IUserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.utils.TokenUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import jakarta.annotation.Resource;

import java.util.List;


//服务实现类
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Resource
    private UserMapper userMapper;

    @Override
    public Account login(Account account){

//        User one=getOne(Wrappers.<User> lambdaQuery().eq(User::getUsername, account.getUsername()).eq(User::getPassword, account.getPassword()));
        //登录就是通过账号密码查询出来是否有这条数据
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, account.getUsername());
        wrapper.eq(User::getPassword, account.getPassword());
        User one = userMapper.selectOne(wrapper);

        //如果one==null，就说明登录账号或密码错误了，查找不到
        if (one!=null){
            // 新增：检查用户是否被封禁
            if (one.getStatus() != null && one.getStatus() == 0) {
                throw new ServiceException("403", "该账号已被禁止使用");
            }
            //执行到这里就说明找到了这个用户，那么我们把这个用户数据再处理一下，返回到controller层就可以了
            String role="ROLE_USER";
            BeanUtils.copyProperties(one,account);
            String token= TokenUtils.createToken(one.getId()+"-"+role,account.getPassword());
            account.setToken(token);
            account.setRole(role);
            account.setPassword(null);
            return account;
        }
        else {
            throw new ServiceException(Constants.CODE_605,"用户名或者密码错误");
        }

    }

    @Override
    public void register(Account account) {
        //先保证注册前用户名不重复
        //在user类中查
        //查询的是username和password字段

        User one=getOne(Wrappers.<User> lambdaQuery().eq(User::getUsername,account.getUsername()));
        //为空说明可以注册
        if (one==null){
            one=new User();
            //bean工具，拷贝属性
            BeanUtils.copyProperties(account,one);

            //手动设置值，与copyProperties一样
//            one.setUsername(account.getUsername());
//            one.setPassword(account.getPassword());
//            int result=userMapper.insert(one);
//            System.out.println("用户注册成功，ID："+one.getId());
//            return one;

            save(one);
        }
        else {
            //不等于空说明已经有了这个账户
            throw new ServiceException(Constants.CODE_605,"用户已存在");
        }
    }

    @Override
    public void updatePassword(Account account) {
        LambdaUpdateWrapper<User> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(User::getUsername, account.getUsername());
        wrapper.eq(User::getPassword, account.getPassword());
        wrapper.set(User::getPassword,account.getNewPassword());
        //执行更新操作
        int updateCount=userMapper.update(null,wrapper);
        //检查更新结果
        if (updateCount==0){
            throw new ServiceException(Constants.CODE_605,"原密码输入错误，请检查后再试！");
        }
    }

    // ========== 封禁/解封功能 ==========

    @Override
    public Result updateStatus(Integer id, Integer status) {
        User user = this.getById(id);
        if (user == null) {
            throw new ServiceException(Constants.CODE_400, "用户不存在");
        }
        user.setStatus(status);
        this.updateById(user);
        return Result.success();
    }

    @Override
    public Result batchUpdateStatus(List<Integer> ids, Integer status) {
        if (ids == null || ids.isEmpty()) {
            throw new ServiceException(Constants.CODE_400, "请选择用户");
        }
        LambdaUpdateWrapper<User> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.set(User::getStatus, status);
        updateWrapper.in(User::getId, ids);
        this.update(updateWrapper);
        return Result.success();
    }
}