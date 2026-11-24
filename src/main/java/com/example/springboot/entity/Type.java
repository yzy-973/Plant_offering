package com.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.List;

@Data
@TableName(value = "book_type")
public class Type {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private String name;

    private String info;

    private String icon;

    private String img;

    private Integer parentId;

    private Integer sortOrder;

    /** 0禁用 1启用 */
    private Integer status;

    /** 是否推荐到首页：0否 1是 */
    private Integer isRecommend;

    @TableField(exist = false)
    private List<Book> bookList;
}
