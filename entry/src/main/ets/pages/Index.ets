import { HttpUtils } from '../common/network/HttpUtils'
import { common } from '@kit.AbilityKit'

@Entry
@Component
struct Index {
  @State pictureUri: string = ''
  private context = getContext(this) as common.UIAbilityContext
  private applicationContext = this.context.getApplicationContext()
  private cacheDir = this.applicationContext.filesDir

  async aboutToAppear(): Promise<void> {
    let httpUtil: HttpUtils = new HttpUtils()

    await httpUtil.getHttpRequest(this.cacheDir).then((value: string) => {
      this.pictureUri = value
    })
    httpUtil.destroyHttpRequest()

  }

  build() {
    Column() {
      Text('咔咔啦咔')
      Image(this.pictureUri)
        .width('100%')
    }
  }
}