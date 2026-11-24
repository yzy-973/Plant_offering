package com.example.springboot.exception;


import com.example.springboot.common.Result;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

@ControllerAdvice
public class GlobalExceptionHandler {
    //如果抛出的是ServiceException，则调用该方法
    //@paramse 业务异常
    //@return Result
    @ExceptionHandler(ServiceException.class)
    @ResponseBody
    public Result handle(ServiceException se){
        return Result.error(se.getCode(),se.getMessage());
    }
    
    //捕获所有其他异常
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public Result handleException(Exception e){
        e.printStackTrace();
        return Result.error("500", e.getMessage());
    }
}
