package com.example.springboot.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.Address;
import com.example.springboot.entity.Banner;
import com.example.springboot.mapper.AddressMapper;
import com.example.springboot.mapper.BannerMapper;
import com.example.springboot.service.IAddressService;
import com.example.springboot.service.IBannerService;
import org.springframework.stereotype.Service;

//服务实现类
@Service
public class AddressServiceImpl extends ServiceImpl<AddressMapper, Address> implements IAddressService {


}
