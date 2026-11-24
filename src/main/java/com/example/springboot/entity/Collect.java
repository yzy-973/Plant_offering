package com.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName(value = "collect")
public class Collect {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer userId;

    private Integer bookId;

    private String remark;

    private LocalDateTime createTime;

    @TableField(exist = false)
    private Integer itemId;

    public Integer getItemId() {
        return itemId != null ? itemId : bookId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
        if (itemId != null) {
            this.bookId = itemId;
        }
    }
}
