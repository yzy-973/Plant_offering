package com.example.springboot.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.common.Constants;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.Admin;
import com.example.springboot.entity.User;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.mapper.AdminMapper;
import com.example.springboot.service.IAdminService;
import com.example.springboot.utils.TokenUtils;
import jakarta.annotation.Resource;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

//服务实现类
@Service
public class AdminServiceImpl extends ServiceImpl<AdminMapper, Admin> implements IAdminService {

    @Resource
    private AdminMapper adminMapper;

    @Override
    public Account login(Account account) throws ServiceException {
        //登录就是通过账号密码查询出来是否有这条数据
        LambdaQueryWrapper<Admin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Admin::getUsername, account.getUsername());
        wrapper.eq(Admin::getPassword, account.getPassword());
        Admin one = adminMapper.selectOne(wrapper);

        //如果one==null，就说明登录账号或密码错误了，查找不到
        if (one!=null){
            //执行到这里就说明找到了这个用户，那么我们把这个用户数据再处理一下，返回到controller层就可以了
            String role="ROLE_ADMIN";
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
        LambdaQueryWrapper<Admin> wrapper = new LambdaQueryWrapper<>();
        //查询的是username和password字段
        wrapper.eq(Admin::getUsername, account.getUsername());
        wrapper.eq(Admin::getPassword, account.getPassword());
        Admin one=adminMapper.selectOne(wrapper);
        //为空说明可以注册
        if (one==null){
            one=new Admin();
            //bean工具，拷贝属性
            BeanUtils.copyProperties(account,one);
            //手动设置值，与copyProperties一样
//            one.setUsername(account.getUsername());
//            one.setPassword(account.getPassword());
            adminMapper.insert(one);
//            return one;
        }
        else {
            //不等于空说明已经有了这个账户
            throw new ServiceException(Constants.CODE_605,"用户已存在");
        }
    }

    @Override
    public void updatePassword(Account account) {
        LambdaUpdateWrapper<Admin> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Admin::getUsername, account.getUsername());
        wrapper.eq(Admin::getPassword, account.getPassword());
        //先判断后更改
        wrapper.set(Admin::getPassword,account.getNewPassword());
        //执行更新操作
        int updateCount=adminMapper.update(null,wrapper);
        //检查更新结果
        if (updateCount==0){
            throw new ServiceException(Constants.CODE_605,"原密码输入错误，请检查后再试！");
        }
    }

}
