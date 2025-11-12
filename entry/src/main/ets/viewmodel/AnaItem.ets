/**
 * 语句 - 实体类
 *
 * @author 小生化
 * @date 2025/11/12 10:28
 */
export class AnaItem {
  id: number
  anaContent: string

  constructor(id: number, anaContent: string) {
    this.id = id
    this.anaContent = anaContent
  }
}