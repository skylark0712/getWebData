import { http } from '@kit.NetworkKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'HttpUtils';
const IMAGE_URL: string = 'https://zhengikkyu.com/playground/yzj.svg';

/**
 * The HttpUtils provides the capability of accessing the network through HTTP.
 */
export class HttpUtils {
  httpRequest: http.HttpRequest;

  constructor() {
    this.httpRequest = http.createHttp();
  }

  /**
   * The method of initiating a GET request through HTTP.
   */
  async getHttpRequest(cacheDir: string): Promise<string> {
    let responsePictureUri: string = '';
    try {
      let httpResponse = await this.httpRequest.request(IMAGE_URL, { method: http.RequestMethod.GET })
      let filePath = cacheDir + '/test.svg'
      try {
        let file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
        responsePictureUri = fileUri.getUriFromPath(filePath)
        fileIo.writeSync(file.fd, httpResponse.result as ArrayBuffer)
        fileIo.closeSync(file.fd)
      } catch (error) {
        let err = error as BusinessError
        hilog.error(0x00, TAG, `openSync failed, code = ${err.code}, message = ${err.message}`)
      }
    } catch (error) {
      hilog.error(0x00, TAG, `request failed, code = ${error.code}, message = ${error.message}}`)
    }
    return responsePictureUri
  }

  /**
   * The method of destroying httpRequest.
   */
  destroyHttpRequest() {
    this.httpRequest.destroy();
  }
}