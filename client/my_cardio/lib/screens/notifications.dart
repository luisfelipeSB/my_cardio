import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cardio/common/api/api_checklist.dart';
import 'package:my_cardio/common/api/api_user.dart';
import 'package:my_cardio/common/shared_preferences.dart';
import 'package:my_cardio/models/notification.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserApiMethods userAPI = UserApiMethods();
  ChecklistApiMethods checklistAPI = ChecklistApiMethods();

  late Future<List<Notificationo>> _myFuture;
  String usercode = 'initialize';

  @override
  void initState() {
    SharedPreferencesMethods.instance
        .getStringValue("usercode")
        .then((value) => setState(() {
              usercode = value;
              _myFuture = getData(usercode);
            }));
    _myFuture = getData(usercode);
    super.initState();
  }

  Future<List<Notificationo>> getData(String usercode) async {
    return await userAPI.getNotifications(usercode);
  }

  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,

      // App bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: const Padding(
              padding: EdgeInsets.only(top: 20), child: Text('Notificações')),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Image.asset('assets/images/logo-horiz-alt.png',
                  width: 100, height: 80, fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      // Notifications list
      body: FutureBuilder(
        future: _myFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<Notificationo>> snapshot) {
          Widget page;

          // Waiting to get data
          if (snapshot.connectionState == ConnectionState.waiting) {
            page = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text('A buscar suas notificações...'),
                  ),
                ],
              ),
            );

            // Error
          } else if (snapshot.hasError) {
            page = const Center(
              child: Text('Ocorreu um erro :('),
            );

            // Got data
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Notificationo>? notifications = snapshot.data;

            List<Notificationo> recent = [];
            List<Notificationo> older = [];

            for (Notificationo n in notifications!) {
              n.day.isAfter(DateTime.now().subtract(const Duration(days: 7)))
                  ? recent.add(n)
                  : older.add(n);
            }

            // Notifications list
            page = ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 40, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notifications from past week
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Desta Semana',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: recent.length,
                        itemBuilder: (context, index) {
                          return Container();
                        },
                      ),
                      Divider(
                        color: colorscheme.outline,
                        thickness: 2,
                      ),

                      // Older notifications
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Mais antigas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: older.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          bool t = (notif.type == 'measur' ? true : false);
                          // Risk card
                          return Card(
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: t
                                      ? colorscheme.onSecondary
                                      : colorscheme.onPrimary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(7)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text('${notif.occurrences}'),
                                ),
                              ),
                              title: t
                                  ? const Text('Medições tomadas')
                                  : const Text('Riscos detetado'),
                              trailing: Text(DateFormat('d/M/y')
                                  .format(notif.day)
                                  .toString()),
                            ),
                            elevation: 5,
                            color: t
                                ? colorscheme.onSecondaryContainer
                                : colorscheme.onPrimaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );

            // No data
          } else {
            page = Center(
              child: Column(
                children: const [
                  Text('Sem notificações'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );
          }
          return page;
        },
      ),
    );
  }
}
