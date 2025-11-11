import http from '@ohos.net.http';

@Component
export default struct GetAna {
  @State message: string = ''
  @State URL: string = 'https://v1.hitokoto.cn'
  @State countDown: number = 0
  @State isButtonEnabled: boolean = true
  @State anaType: string = ''

  getUserName(type: string) {
    let httpRequest = http.createHttp()
    httpRequest.request(this.URL + '/?c=' + type, { method: http.RequestMethod.GET },
      (err, data) => {
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
    Column({ space: 5 }) {
      Text('随机GET一句话')
      Text(this.message)
        .border({ width: 1 })
        .width('100%')
        .height('150vp')
        .padding(10)
        .align(Alignment.TopStart)
      Row() {
        Select([
          { value: '全部类型' },
          { value: '动画' },
          { value: '漫画' },
          { value: '游戏' },
          { value: '文学' },
          { value: '原创' },
          { value: '来自网络' },
          { value: '其他' },
          { value: '影视' },
          { value: '诗词' },
          { value: '网易云' },
          { value: '哲学' },
          { value: '抖机灵' }
        ])
          .width('35%')
          .value('全部类型')
          .onSelect((index) => {
            if (index === 0) {
              this.anaType = ''
            } else {
              this.anaType = String.fromCharCode(96 + index)
            }
          })
        Button(this.countDown > 0 ? `${this.countDown} 秒后重试` : '发送请求')
          .width('35%')
          .enabled(this.isButtonEnabled)
          .onClick(() => {
            this.getUserName(this.anaType)
            this.isButtonEnabled = false
            this.countDown = 3
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
      .margin({ bottom: '300vp' })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding('10vp')
  }
}