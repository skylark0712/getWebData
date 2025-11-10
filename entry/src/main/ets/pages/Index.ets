import http from '@ohos.net.http';

@Entry
@Component
struct Index {
  @State message: string = ''
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
          this.message = JSON.parse(data.result.toString()).hitokoto + '\n——' + JSON.parse(data.result.toString()).from
        }
      })
  }

  build() {
    Column({space:5}) {
      Text('随机GET一句话')
      Text(this.message)
        .border({ width: 1 })
        .width('100%')
        .height('150vp')
        .padding(10)
        .align(Alignment.TopStart)
      Button(this.countDown > 0 ? `${this.countDown} 秒后重试` : '发送请求')
        .width('30%')
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
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding('10vp')
  }
}