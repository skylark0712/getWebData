export default class CommonConstants {
  /**
   * 创建语句表
   */
  static readonly CREATE_ANA_TABLE_SQL: string =
    'CREATE TABLE IF NOT EXISTS ANA (ID INTEGER PRIMARY KEY AUTOINCREMENT, ANA_CONTENT TEXT NOT NULL)'

  /**
   * 查询
   */
  static readonly SELECT_ALL_ANAS_SQL: string =
    'SELECT ID, ANA_CONTENT FROM ANA'

}