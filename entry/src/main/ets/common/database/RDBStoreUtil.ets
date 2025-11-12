import { relationalStore } from '@kit.ArkData'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { BusinessError } from '@kit.BasicServicesKit'
import CommonConstants from '../constants/CommonConstants'
import { AnaItem } from '../../viewmodel/AnaItem'

const TAG: string = 'RDBStoreUtil'

/**
 * 数据库工具类
 *
 * @author 小生化
 * @date 2025/11/11 17:28
 */
export class RDBStoreUtil {
  objectiveRDB?: relationalStore.RdbStore

  /**
   * 创建数据库
   */
  createObjectiveRDB(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'Objective.db',
      securityLevel: relationalStore.SecurityLevel.S1
    } // 数据库配置参数
    relationalStore.getRdbStore(context, STORE_CONFIG,
      (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
        this.objectiveRDB = rdbStore // 在该方法中将 getRdbStore() 方法的返回的 RdbStore 实例赋值给工具类的对象属性 objectiveRDB，以便后续方便地使用它。
        if (err) {
          hilog.error(0x0000, TAG, `关系型数据库实例获取失败, code is ${err.code}, message is ${err.message}`)
          return
        }
        hilog.error(0x0000, TAG, '关系型数据库实例获取成功。')
      }
    )
  }

  /**
   * 创建语句表
   */
  createAnaTable() {
    this.objectiveRDB?.execute(CommonConstants.CREATE_ANA_TABLE_SQL) // RdbStore 实例提供了 execute() 方法用于执行 SQL 语句，只要将创建两张表的 SQL 语句作为参数传入即可。
      .then(() => {
        hilog.info(0x0000, TAG, `SQL执行成功`)
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, `SQL执行失败, code is ${err.code}, message is ${err.message}`)
      })
  }

  /**
   * 初始化语句表
   */
  initAnaTable() {
    const anaDataOne: relationalStore.ValuesBucket =
      { 'ID': 0, 'ANA_CONTENT': '实变函数学十遍，泛函学完心泛寒。——数学系名言' }
    const anaDataTwo: relationalStore.ValuesBucket =
      { 'ID': 1, 'ANA_CONTENT': '行百里者半九十。——战国策·秦策五·谓秦王' }
    const anaDataThree: relationalStore.ValuesBucket =
      { 'ID': 2, 'ANA_CONTENT': '新欢是良药，而我选择了时间。——九望' }
    let valueBuckets = new Array(anaDataOne, anaDataTwo, anaDataThree)
    this.objectiveRDB?.batchInsert('ANA',
      valueBuckets) // batchInsert() 方法的参数有两个，第一个是需要插入数据的数据表名，第二个是要插入的 ValuesBucket 数组
      .then((insertNum: number) => {
        hilog.info(0x0000, TAG, `SQL执行成功，新增了 ${insertNum} 条记录。`)
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, `SQL执行失败, code is ${err.code}, message is ${err.message}`)
      })
  }

  /**
   * 列表查询
   */
  async queryAllAnas(): Promise<AnaItem[]> {
    let anasSet: Array<AnaItem> = []
    await this.objectiveRDB?.querySql(CommonConstants.SELECT_ALL_ANAS_SQL)
      .then((resultSet: relationalStore.ResultSet) => {
        while (resultSet.goToNextRow()) {
          const id = resultSet.getValue(resultSet.getColumnIndex('ID')) as number
          const anaContent = resultSet.getValue(resultSet.getColumnIndex('ANA_CONTENT')) as string
          anasSet.push(new AnaItem(id, anaContent))
        }
        resultSet.close()
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, `SQL执行失败, code is ${err.code}, message is ${err.message}`)
      })
    return anasSet
  }

  /**
   * 新增（单个）
   */
  async insertAna(anaContent: string) {
    const anaData: relationalStore.ValuesBucket = { 'ANA_CONTENT': anaContent }
    await this.objectiveRDB?.insert('ANA', anaData,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE) // 参数分别为表名，插入数据，冲突解决策略
      .then((rowId: number) => {
        hilog.info(0x0000, TAG, `SQL执行成功，rowId = ${rowId}`)
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, `SQL执行失败, code is ${err.code}, message is ${err.message}`)
      })
  }

  async deletePlan(id: number) {
    // todo
  }
}

export default new RDBStoreUtil()