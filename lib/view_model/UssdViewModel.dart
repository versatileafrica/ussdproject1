import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd/model/ussdModel.dart';
import 'package:ussd/repository/ussdRepository.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class UssdViewModel extends GetxController {
  ussdRepository ussdrepo = ussdRepository();
  var allussdlist = <ussdModel>[].obs;
  var _requestCode = "".obs;
  var _responseMessage = "".obs;
  var resultt = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchallussd();
    getInfo();
  }

  fetchallussd() async {
    var ussdlist = await ussdrepo.getussdlist();
    allussdlist.value = ussdlist;
  }

  addussd(ussdModel ussdmodel) {
    ussdrepo.add(ussdmodel);
    fetchallussd();
  }

  updateussd(ussdModel ussdmodel) {
    ussdrepo.update(ussdmodel);
    fetchallussd();
  }

  updateussdstatus(int id) {
    ussdrepo.updatestatus(id);
    fetchallussd();
  }

  deleteussd(int id) {
    ussdrepo.delete(id);
    fetchallussd();
  }

  // Future<void> sendUssdRequest(String numeros, String montant, int id) async {
  //   try {
  //     String responseMessage;
  //     await Permission.phone.request();
  //     if (!await Permission.phone.isGranted) {
  //       throw Exception("permission missing");
  //     }

  //     SimData simData = await SimDataPlugin.getSimData();

  //     // await UssdAdvanced.sendUssd(code: "*123*2#", subscriptionId: 1);
  //     print(numeros + "ussd code");
  //     // String? _rese =
  //     //     await UssdAdvanced.sendAdvancedUssd(code: ussd, subscriptionId: 1);
  //     String? _res = await UssdAdvanced.multisessionUssd(
  //         code: "*123*2#", subscriptionId: 1);
  //     //  await UssdAdvanced.sendAdvancedUssd(
  //     //     code: _requestCodes, subscriptionId: 1);
  //     const string =
  //         'Transfert effectue pour  10200 FCFA  a SYLVESTRE ADJANOHOUN (22957632892) le 2022-11-03 08:39:42. Frais: 0 FCFA. Nouveau solde: 39629 FCFA, Reference: a. ID de la transaction: 3666753605. Tu peux aussi payer ta facture SONEB via MoMo. Clique ici : https://bit.ly/3ih3vka';
  //     if (int.parse(string.indexOf('ID de la transaction').toString()) > 0) {
  //       updateussdstatus(id);
  //     } else {
  //       print("Operation non éffectuer");
  //       fetchallussd();
  //     }
  //     _responseMessage.value = _res!;
  //   } on PlatformException catch (e) {
  //     _responseMessage.value = e.message ?? '';
  //   }
  // }

  Future<void> ussdMultiReq(int id) async {
    try {
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      } else {
        // await UssdAdvanced.sendUssd(code: "*123*2#", subscriptionId: 1);
        String? _res = await UssdAdvanced.multisessionUssd(
            code: "*123*6*1#", subscriptionId: 1);

        // String? _res2 = await UssdAdvanced.sendMessage('3');
        _responseMessage.value = _res!;
        await Future.delayed(const Duration(seconds: 5));
        await UssdAdvanced.cancelSession();
        updateussdstatus(id);
      }
    } on PlatformException catch (e) {
      print("error! code: ${e.code} - message: ${e.message}");
    }
  }

  Future<void> sendUssdRequestgroup() async {
    print("fafafafa");
    const string =
        'Transfert effectue pour  10200 FCFA  a SYLVESTRE ADJANOHOUN (22957632892) le 2022-11-03 08:39:42. Frais: 0 FCFA. Nouveau solde: 39629 FCFA, Reference: a. ID de la transaction: 3666753605. Tu peux aussi payer ta facture SONEB via MoMo. Clique ici : https://bit.ly/3ih3vka';
    print(string.indexOf('ID de la transaction')); // 1
    for (var i = 0; i < allussdlist.length; i++) {
      // Timer(const Duration(seconds: 10), () {
      if (allussdlist[i].status == 0) {
        // if (int.parse(string.indexOf('ID de la transaction').toString()) > 0) {
        print("id" + allussdlist[i].id.toString());
        // sendUssdRequest(allussdlist[i].montant.toString(),
        //     allussdlist[i].numeros.toString(), allussdlist[i].id!);
        ussdMultiReq(allussdlist[i].id!);
        // Timer(const Duration(seconds: 10), () {});
        await Future.delayed(const Duration(seconds: 15));
        // }
      }
      // });
    }
  }

  // Future<String> getDeviceInfos() async {
  //   await AndroidMultipleIdentifier.requestPermission();
  //   if (!await AndroidMultipleIdentifier.requestPermission()) {
  //     throw Exception("permission missing");
  //   }
  //   // get information device
  //   Map idmap = await AndroidMultipleIdentifier.idMap;

  //   String imei = idmap["imei"];
  //   String serial = idmap["serial"];
  //   String androidID = idmap["androidID"];
  //   return imei;
  // }
  Future<void> getDeviceInfos() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    // return deviceInfo.;
  }

  // This function will be called when the floating button is pressed
  getInfo() async {
    // Get device id
    String? result = await PlatformDeviceId.getDeviceId;
    resultt.value = result.toString();
    print(result);
    print(resultt);
    return result.toString();
  }
}
