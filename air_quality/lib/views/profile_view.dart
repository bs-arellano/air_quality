import 'package:air_quality/session.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final Session session;
  final void Function() closeSession;
  const ProfileView(
      {super.key, required this.session, required this.closeSession});
  @override
  State<ProfileView> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  late Card profileCard;
  @override
  void initState() {
    profileCard = Card(
        margin: const EdgeInsets.all(20),
        child: SizedBox(
            width: 500,
            height: 100,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      size: 50,
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.session.username,
                        )
                      ],
                    ),
                    const Spacer(),
                    FloatingActionButton(
                        onPressed: widget.closeSession,
                        child: const Icon(Icons.close))
                  ],
                ))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[profileCard],
    ));
  }
}
