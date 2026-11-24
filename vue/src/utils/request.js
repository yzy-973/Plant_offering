import axios from "axios";
import router from "@/router";
import {serverHost} from '../../config/config.default'
//使用Element Plus组件进行错误信息提示
import {ElMessage} from "element-plus";

const request=axios.create({
    baseURL:serverHost,
    timeout:5000
})

//request拦截器
//可以自请求发送前对请求做一些处理
//比如统一加token，对请求参数统一加密
request.interceptors.request.use(
    (config)=>{
        // FormData 必须由浏览器自动带 boundary，不能写成 application/json
        if (config.data instanceof FormData) {
            if (config.headers) {
                delete config.headers['Content-Type']
            }
        } else {
            config.headers['Content-Type']='application/json;charset=utf-8'
        }
        let account=localStorage.getItem('account')?JSON.parse(localStorage.getItem('account')):null
        if (account){
            config.headers['token']=account.token//设置请求头
        }
        return config
    },
    (error)=>{
        return Promise.reject(error)
    }
)

//response 拦截器
//可以在接口响应后统一处理结果
request.interceptors.response.use(
    (response)=>{
        let res=response.data
        //如果是返回的文件
        if (response.config.responseType==='blob'){
            return res
        }
        //兼容服务端返回的字符串数据（上传接口可能直接返回 URL 纯文本）
        if (typeof res==='string'){
            try {
                res = JSON.parse(res)
            } catch {
                return res
            }
        }
        //当权限验证不通过的时候给出提示
        if (res.code==='401'){
            ElMessage.error(res.msg)
            //跳转到登录页面
            router.push('/login')
        }
        // 新增：当账号被封禁时（403状态码），清除本地存储并跳转登录页
        if (res.code === '403' && res.msg === '该账号已被禁止使用') {
            ElMessage.error('该账号已被禁止使用，请联系管理员')
            localStorage.removeItem('account')
            router.push('/login')
            return Promise.reject(new Error(res.msg))
        }
        return res
    },
    (error)=>{
        console.log('error' + error)//for debug
        return Promise.reject(error)
    }
)
export default request