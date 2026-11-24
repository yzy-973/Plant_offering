package com.example.springboot.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.RecommendSlot;
import com.example.springboot.mapper.RecommendSlotMapper;
import com.example.springboot.service.IRecommendSlotService;
import org.springframework.stereotype.Service;

@Service
public class RecommendSlotServiceImpl extends ServiceImpl<RecommendSlotMapper, RecommendSlot> implements IRecommendSlotService {
}
