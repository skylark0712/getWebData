import http from '@ohos.net.http';

@Entry
@Component
struct Index {
  @State message: string = '咔咔啦咔'
  @State URL: string = 'https://v1.hitokoto.cn'

  getUserName() {
    let httpRequest = http.createHttp()
    httpRequest.request(this.URL, { method: http.RequestMethod.GET },
      (err, data) => {
        console.info("data:" + JSON.stringify(data.result))
        console.info("code:" + JSON.stringify(data.responseCode))
        console.info("error:" + JSON.stringify(err))
        if (err) {
          this.message = JSON.stringify(err)
        } else if (data.responseCode != 200) {
          this.message = data.responseCode + ''
        } else {
          this.message = JSON.parse(data.result.toString()).hitokoto
        }
      })
  }

  build() {
    Column() {
      Text(this.message)
      Button('发送请求')
        .onClick(() => this.getUserName())
    }
    .width('100%')
  }
}