/**
 * 解析上传接口返回值为图片 URL 字符串
 * 兼容：纯字符串、Result{data}、el-upload file.response 等
 */
export function resolveUploadUrl(res) {
  if (res == null) return ''

  if (typeof res === 'string') {
    const text = res.trim()
    if (!text) return ''
    if (
      (text.startsWith('{') && text.endsWith('}')) ||
      (text.startsWith('"') && text.endsWith('"'))
    ) {
      try {
        return resolveUploadUrl(JSON.parse(text))
      } catch {
        return text
      }
    }
    return text
  }

  if (typeof res === 'object') {
    if (typeof res.data === 'string' && res.data) return res.data
    if (typeof res.url === 'string' && res.url) return res.url
    if (res.response) return resolveUploadUrl(res.response)
    if (res.data && typeof res.data === 'object') {
      const nested = resolveUploadUrl(res.data)
      if (nested) return nested
    }
    for (const value of Object.values(res)) {
      if (typeof value === 'string' && /^https?:\/\//.test(value)) {
        return value
      }
    }
  }
  return ''
}

/**
 * 统一上传文件，返回图片 URL
 * 优先走 Vite 代理 /web/upload（同源），失败再直连 serverHost
 * @param {File|Blob} file
 * @param {string} serverHost
 * @returns {Promise<string>}
 */
export async function uploadFile(file, serverHost) {
  const formData = new FormData()
  formData.append('file', file)

  const account = localStorage.getItem('account')
    ? JSON.parse(localStorage.getItem('account'))
    : null
  const headers = account?.token ? { token: account.token } : {}

  const axios = (await import('axios')).default
  const urls = ['/web/upload']
  if (serverHost) {
    urls.push(`${serverHost}/web/upload`)
  }

  let lastError = null
  for (const url of urls) {
    try {
      const axiosRes = await axios.post(url, formData, {
        headers,
        timeout: 60000
      })
      const body = axiosRes.data
      const fileUrl = resolveUploadUrl(body)
      if (fileUrl) {
        return fileUrl
      }
      lastError = new Error(body?.msg || '上传响应无效')
    } catch (e) {
      lastError = e
      console.warn('upload try failed:', url, e?.message || e)
    }
  }
  throw lastError || new Error('上传失败')
}
