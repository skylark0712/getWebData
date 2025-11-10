import http from '@ohos.net.http';

@Entry
@Component
struct Index {
  @State message: string = '咔咔啦咔'
  @State URL: string = 'https://v1.hitokoto.cn'
  @State countDown: number = 0
  @State isButtonEnabled: boolean = true

  getUserName() {
    let httpRequest = http.createHttp()
    httpRequest.request(this.URL, { method: http.RequestMethod.GET },
      (err, data) => {
        // console.info("data:" + JSON.stringify(data.result))
        // console.info("code:" + JSON.stringify(data.responseCode))
        // console.info("error:" + JSON.stringify(err))
        if (err) {
          this.message = JSON.stringify(err)
        } else if (data.responseCode != 200) {
          this.message = data.responseCode + ''
        } else {
          this.message = JSON.parse(data.result.toString()).hitokoto + '——' + JSON.parse(data.result.toString()).from
        }
      })
  }

  build() {
    Column() {
      Text(this.message)
      Button(this.countDown > 0 ? `${this.countDown}秒后重试` : '发送请求')
        .enabled(this.isButtonEnabled)
        .onClick(() => {
          this.getUserName()
          this.isButtonEnabled = false
          this.countDown = 2
          const timer = setInterval(() => {
            this.countDown -= 1
            if (this.countDown <= 0) {
              this.countDown = 0
              this.isButtonEnabled = true
              clearInterval(timer)
            }
          }, 1000)
        })
    }
    .width('100%')
  }
}