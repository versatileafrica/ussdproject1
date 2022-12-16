import 'package:ussd/database/dbhelper.dart';
import 'package:ussd/database/utils.dart';
import 'package:ussd/model/ussdModel.dart';

class ussdRepository {
  DBHelper dbhelper = DBHelper();

  Future<List<ussdModel>> getussdlist() async {
    var dbclient = await dbhelper.db;
    // final sql = 'SELECT * FROM ussd ORDER BY $orderBy';
    List<Map> maps = await dbclient.query(tableName,
        columns: ['id', 'numeros', 'montant', 'status'],
        // where: 'simchoice = ? and libeler = ?',
        where: 'status = ?',
        whereArgs: [0]);
    // whereArgs: [1, "689"]);
    List<ussdModel> ussdList = [];

    for (var i = 0; i < maps.length; i++) {
      ussdList.add(ussdModel.fromMap(maps[i]));
    }
    return ussdList;
  }

  Future<int> add(ussdModel ussdmodel) async {
    var dbclient = await dbhelper.db;
    return await dbclient.insert(tableName, ussdmodel.toMap());
  }

  Future<int> update(ussdModel ussdmodel) async {
    var dbclient = await dbhelper.db;
    return await dbclient.update(tableName, ussdmodel.toMap(),
        where: 'id = ?', whereArgs: [ussdmodel.id]);
  }

  Future<int> updatestatus(int id) async {
    var dbclient = await dbhelper.db;
    return await dbclient
        .rawUpdate('UPDATE ussd SET status = ? WHERE id = ?', [1, id]);
  }

  Future<int> delete(int id) async {
    var dbclient = await dbhelper.db;
    return await dbclient.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
