package com.example.springboot.controller;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.example.springboot.common.Constants;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.User;
import com.example.springboot.service.IAdminService;
import com.example.springboot.service.IUserService;
import com.example.springboot.utils.TokenUtils;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@RestController
@RequestMapping("/web")
public class WebController {

    //拿到当前项目所在的路径
    private static final String FILE_UPLOAD_PATH = System.getProperty("user.dir") + File.separator + "files" + File.separator;
    @Value("${ip:localhost}")
    String ip;

    @Value("${server.port}")
    String port;

    @Resource
    private IUserService userService;
    @Resource
    private IAdminService adminService;

    /*json web token jwt
    场景
    系统核心保密数据，比如学系统里面的学生信息，手机号，身份证，不应该任何人都可以获取，这个接口应该不是所有人都可以访问的
    如果不做限制，没登录和登录过单独都可以正常访问系统，数据就很不安全
    如果只是简单判断登录状态，那么我伪造一个登录状态，也可以访问数据了
    所以需要一个token（令牌）证明你确实登录了，并且同时这个不是伪造的，能够扛得起验证的*/




    //登录
    //RequestBody会帮助我们解析前端发送来的数据对象，然后帮我们解析成java语言内的对象
    @PostMapping("/login")
    public Result login(@RequestBody Account account) {
        //要进行一个判空，如果前端有少发的内容，那么告诉他一下，咱们就不执行了
        //这里判断一下用户名和密码是否为空
        if (StrUtil.isBlank(account.getUsername()) || StrUtil.isBlank(account.getPassword())||StrUtil.isBlank(account.getRole())) {
            return Result.error(Constants.CODE_400,"参数错误");
        }
        if (StrUtil.equals(account.getRole(),"ROLE_USER")){
            account=userService.login(account);
            // 新增：检查用户是否被封禁
            if (account != null && account.getId() != null) {
                User user = userService.getById(account.getId());
                if (user != null && user.getStatus() != null && user.getStatus() == 0) {
                    return Result.error("403", "该账号已被禁止使用");
                }
            }
        }
        if (StrUtil.equals(account.getRole(),"ROLE_ADMIN")){
            account=adminService.login(account);
        }

        return Result.success(account);
    }

    //注册
    @PostMapping("/register")
    public Result register(@RequestBody Account account) {
        //要进行一个判空，如果前端有少发的内容，那么告诉他一下，咱们就不执行了
        //这里判断一下用户名和密码是否为空
        if (StrUtil.isEmpty(account.getUsername()) || StrUtil.isEmpty(account.getPassword())) {
            return Result.error(Constants.CODE_400,"参数错误");
        }
        if (StrUtil.equals(account.getRole(),"ROLE_USER")){
            userService.register(account);
        }
        if (StrUtil.equals(account.getRole(),"ROLE_ADMIN")){
            adminService.register(account);
        }
        return Result.success();
    }

    //修改密码
    @PostMapping("/password")
    public Result updatePassword(@RequestBody Account account) {
        if (StrUtil.isBlank(account.getPassword())||StrUtil.isBlank(account.getPassword())) {
            return Result.error(Constants.CODE_400,"参数错误");
        }
        Account one= TokenUtils.getCurrentUser();//拿到当前用户信息
        account.setUsername(one.getUsername());

        if (StrUtil.equals(one.getRole(),"ROLE_USER")){
            userService.updatePassword(account);
        }

        if (StrUtil.equals(one.getRole(),"ROLE_ADMIN")){
            adminService.updatePassword(account);
        }

        return Result.success();
    }

    //获取用户信息
    @GetMapping("/userInfo")
    public Result userInfo(){
        Account account=TokenUtils.getCurrentUser();

        if (StrUtil.equals(account.getRole(),"ROLE_USER")){
            return Result.success(userService.getById(account.getId()));
        }
        if (StrUtil.equals(account.getRole(),"ROLE_ADMIN")){
            return Result.success(adminService.getById(account.getId()));
        }

        return Result.error(Constants.CODE_605,"获取用户信息失败");
    }

    //文件上传接口：统一返回 Result，data 为可访问 URL
    @PostMapping("/upload")
    public Result upload(@RequestParam MultipartFile file) throws IOException{
        if (file == null || file.isEmpty()) {
            return Result.error("400", "文件不能为空");
        }
        String originalFilename = file.getOriginalFilename();
        String type= FileUtil.extName(originalFilename);

        //定义一个文件唯一的标识码
        String fileUUID= IdUtil.fastSimpleUUID()+StrUtil.DOT+type;

        File uploadFile=new File(FILE_UPLOAD_PATH+fileUUID);
        //判断配置的文件目录是否存在，若不存在则创建一个新的文件目录
        File parenFile=uploadFile.getParentFile();
        if(!parenFile.exists()){
            parenFile.mkdirs();
        }

        //文件保存到磁盘
        file.transferTo(uploadFile);
        //拼接文件地址
        String url="http://"+ip+":"+port+"/web/download/"+fileUUID;
        return Result.success(url);
    }

    //文件下载接口
    //@param fileUUID 根据文件UUID找到特定文件
    @GetMapping("/download/{fileUUID}")
    public void download(@PathVariable String fileUUID, HttpServletResponse response) throws IOException {
        // 防止路径穿越
        String safeName = fileUUID == null ? "" : fileUUID.replace("\\", "").replace("/", "");
        File uploadFile = new File(FILE_UPLOAD_PATH + safeName);
        if (!uploadFile.exists() || !uploadFile.isFile()) {
            // 缺图时回退默认图，避免页面大量 404 刷屏
            File fallback = new File(FILE_UPLOAD_PATH + "default.jpg");
            if (fallback.exists()) {
                uploadFile = fallback;
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        String lower = uploadFile.getName().toLowerCase();
        String contentType = "application/octet-stream";
        if (lower.endsWith(".png")) contentType = "image/png";
        else if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) contentType = "image/jpeg";
        else if (lower.endsWith(".webp")) contentType = "image/webp";
        else if (lower.endsWith(".gif")) contentType = "image/gif";

        response.setContentType(contentType);
        response.setHeader("Content-Disposition", "inline;filename=" + URLEncoder.encode(safeName, "UTF-8"));
        response.setHeader("Cache-Control", "public, max-age=86400");

        try (ServletOutputStream os = response.getOutputStream()) {
            os.write(FileUtil.readBytes(uploadFile));
            os.flush();
        }
    }
}